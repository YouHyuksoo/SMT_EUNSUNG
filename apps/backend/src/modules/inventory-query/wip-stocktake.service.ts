/**
 * @file src/modules/inventory-query/wip-stocktake.service.ts
 * @description 공정(라인) 실사 — 실사 시작(장부 고정) · 바코드/품목 수량 입력 · 엑셀 업로드 · 일괄 조정
 *
 * 초보자 가이드:
 * 1. **공정재고는 품목 단위다.** `IM_ITEM_WORKSTAGE_INVENTORY` 의 키는 품목코드+조직뿐이고
 *    롯트·라인이 없다 (실측 1,260행). 그래서 실사표(`IM_ITEM_WORKSTAGE_INV_CHECK`)도 품목 한 줄로
 *    만들고, 라인·공정·롯트 키 칸은 '*' 로 채운다.
 * 2. **세는 방법은 두 가지다.**
 *    - 라인에 걸린 릴 바코드를 찍는다 → 그 롯트의 품목으로 센다. 수량을 비우면 라벨 수량,
 *      쓰다 남은 릴은 남은 수량을 넣는다.
 *    - 바코드가 없는 것은 품목코드와 수량을 넣는다.
 *    입력 한 건은 `IM_ITEM_WS_INVE_CHECK_EXCEL` 한 행이다 (MFS = 롯트, 품목 입력은 '*').
 *    품목의 실사수량 = 그 품목 입력의 합.
 * 3. **조정**은 공정출고(`IM_ITEM_WORKSTAGE_ISSUE`) 한 건이다. 수량 = 장부 − 실사
 *    (+ 면 구분 3 으로 공정재고가 줄고, − 면 구분 4 로 는다). 날짜는 그 달 마지막 날,
 *    `LAST_MODIFY_BY = 'INV ADJUST'` 로 표시해 이미 넣은 조정을 찾는다 (이 표에는 계정 칸이 없다).
 * 4. 공정 출고 트리거(TRG_MAT_ITEM_WS_ISSUE_INS)가 공정재고에서 수량을 뺀다.
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource, QueryRunner } from 'typeorm';
import { TransactionService } from '../../shared/transaction.service';
import { namedBinds } from '../../common/utils/named-binds.util';
import { clobBind } from '../../common/services/oracle.service';
import { isStocktakeMonthAllowed, UPLOAD_MAX_ROWS } from './stocktake.service';

type Row = Record<string, unknown>;
const num = (v: unknown) => Number(v ?? 0);

/** 조정 출고를 찾는 표시 (공정출고에는 계정 칸이 없다). */
export const WIP_ADJUST_MARK = 'INV ADJUST';

/** 입력 한 건. 바코드·롯트번호·품목코드 중 하나는 있어야 한다. */
export interface WipCountRow {
  /** 엑셀 줄 번호 (오류 보고용) */
  row?: number;
  barcode?: string;
  lotNo?: string;
  itemCode?: string;
  qty?: number;
  lineCode?: string;
}

interface Entry {
  itemCode: string;
  lineType: string;
  /** 롯트 (품목 입력이면 '*') */
  mfs: string;
  lineCode: string;
  qty: number;
}

/** 이 달 실사 기간 안의 조정 출고 (장부 − 실사 부호) 합을 품목별로 */
const postedSql = `
  SELECT s.ITEM_CODE, SUM(s.ISSUE_QTY) AS POSTED
    FROM IM_ITEM_WORKSTAGE_ISSUE s
   WHERE s.ORGANIZATION_ID = :organizationId
     AND s.LAST_MODIFY_BY = '${WIP_ADJUST_MARK}'
     AND s.ISSUE_DATE >= TO_DATE(:yyyymm || '01', 'YYYYMMDD')
     AND s.ISSUE_DATE <  ADD_MONTHS(TO_DATE(:yyyymm || '01', 'YYYYMMDD'), 1)
   GROUP BY s.ITEM_CODE`;

/** 입력 합계를 실사표에 반영한다. 실사표에 없는 품목은 장부 0 으로 넣는다. */
const applyEntriesSql = `
  MERGE INTO IM_ITEM_WORKSTAGE_INV_CHECK c
  USING (
    SELECT e.ITEM_CODE, MAX(e.LINE_TYPE) AS LINE_TYPE, SUM(NVL(e.CHECK_INVENTORY_QTY, 0)) AS QTY
      FROM IM_ITEM_WS_INVE_CHECK_EXCEL e
     WHERE e.CLOSE_YYYYMM = :yyyymm AND e.ORGANIZATION_ID = :organizationId
     GROUP BY e.ITEM_CODE
  ) s
  ON (c.CLOSE_YYYYMM = :yyyymm AND c.ORGANIZATION_ID = :organizationId AND c.ITEM_CODE = s.ITEM_CODE
      AND c.MFS = '*' AND c.MATERIAL_MFS = '*' AND c.LINE_CODE = '*' AND c.WORKSTAGE_CODE = '*')
  WHEN MATCHED THEN UPDATE
       SET c.CHECK_INVENTORY_QTY = s.QTY, c.LAST_MODIFY_DATE = SYSDATE, c.LAST_MODIFY_BY = :userId
  WHEN NOT MATCHED THEN INSERT
       (CLOSE_YYYYMM, ITEM_CODE, LINE_TYPE, LINE_CODE, WORKSTAGE_CODE, MACHINE_CODE, MFS, MATERIAL_MFS,
        ORGANIZATION_ID, INVENTORY_HOLD, INVENTORY_PRICE, INVENTORY_QTY, CHECK_INVENTORY_QTY,
        INVENTORY_AMT, LOCATION_CODE, COMMENTS, ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
       VALUES (:yyyymm, s.ITEM_CODE, s.LINE_TYPE, '*', '*', '*', '*', '*',
        :organizationId, 'N', 0, 0, s.QTY, 0, '*', '장부에 없던 품목', SYSDATE, :userId, SYSDATE, :userId)`;

/** 입력 줄을 반영할 것과 오류로 나눈다 (찾기 결과와 맞춰서). */
export function classifyWipRows(
  input: { rn: number; barcode: string | null; lotNo: string | null; itemCode: string | null; qty: number | null; lineCode: string | null }[],
  resolved: Row[],
) {
  const byRn = new Map(resolved.map((r) => [num(r.rn), r]));
  const errors: { row: number; value: string; reason: string }[] = [];
  const entries: Entry[] = [];
  const seen = new Set<string>();
  for (const src of input) {
    const r = byRn.get(src.rn);
    const value = src.barcode ?? src.lotNo ?? src.itemCode ?? '';
    if (!value) { errors.push({ row: src.rn, value, reason: '바코드·롯트번호·품목코드가 비어 있음' }); continue; }
    if (!r?.itemCode) {
      errors.push({ row: src.rn, value, reason: src.barcode || src.lotNo ? '등록되지 않은 바코드·롯트' : '없는 품목코드' });
      continue;
    }
    const byItem = !src.barcode && !src.lotNo;
    if (byItem && src.qty === null) { errors.push({ row: src.rn, value, reason: '품목으로 넣을 때는 수량이 필요함' }); continue; }
    if (src.qty !== null && !(Number.isFinite(src.qty) && src.qty >= 0)) {
      errors.push({ row: src.rn, value, reason: '수량이 0 이상의 숫자가 아님' }); continue;
    }
    const mfs = byItem ? '*' : String(r.lotNo);
    const lineCode = src.lineCode || '*';
    const key = byItem ? `${String(r.itemCode)}|*|${lineCode}` : `${String(r.itemCode)}|${mfs}`;
    if (seen.has(key)) { errors.push({ row: src.rn, value, reason: '파일 안에서 같은 롯트(품목·라인)가 겹침' }); continue; }
    seen.add(key);
    entries.push({
      itemCode: String(r.itemCode),
      lineType: String(r.lineType ?? '*'),
      mfs,
      lineCode,
      qty: src.qty ?? num(r.scanQty),
    });
  }
  return { entries, errors };
}

@Injectable()
export class WipStocktakeService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  /** 진행 중인 공정 실사 — 실사표가 있는 가장 최근 달. 없으면 null. */
  async active(organizationId: number) {
    const r = ((await this.dataSource.query(
      `SELECT c.CLOSE_YYYYMM AS "yyyymm",
              COUNT(*) AS "items",
              SUM(CASE WHEN NVL(c.INVENTORY_QTY, 0) <> 0 THEN 1 ELSE 0 END) AS "bookItems",
              SUM(CASE WHEN NVL(c.CHECK_INVENTORY_QTY, 0) <> 0 THEN 1 ELSE 0 END) AS "countedItems",
              SUM(CASE WHEN NVL(c.CHECK_INVENTORY_QTY, 0) <> NVL(c.INVENTORY_QTY, 0) THEN 1 ELSE 0 END) AS "diffItems",
              SUM(CASE WHEN NVL(c.INVENTORY_QTY, 0) - NVL(c.CHECK_INVENTORY_QTY, 0)
                            - NVL((SELECT SUM(s.ISSUE_QTY) FROM IM_ITEM_WORKSTAGE_ISSUE s
                                    WHERE s.ITEM_CODE = c.ITEM_CODE AND s.ORGANIZATION_ID = c.ORGANIZATION_ID
                                      AND s.LAST_MODIFY_BY = '${WIP_ADJUST_MARK}'
                                      AND s.ISSUE_DATE >= TO_DATE(c.CLOSE_YYYYMM || '01', 'YYYYMMDD')
                                      AND s.ISSUE_DATE <  ADD_MONTHS(TO_DATE(c.CLOSE_YYYYMM || '01', 'YYYYMMDD'), 1)), 0) <> 0
                       THEN 1 ELSE 0 END) AS "pendingItems",
              (SELECT COUNT(*) FROM IM_ITEM_WS_INVE_CHECK_EXCEL e
                WHERE e.CLOSE_YYYYMM = c.CLOSE_YYYYMM AND e.ORGANIZATION_ID = c.ORGANIZATION_ID) AS "entries",
              TO_CHAR(MIN(c.ENTER_DATE), 'YYYY-MM-DD HH24:MI') AS "startedAt"
         FROM IM_ITEM_WORKSTAGE_INV_CHECK c
        WHERE c.ORGANIZATION_ID = :organizationId
          AND c.MFS = '*' AND c.LINE_CODE = '*'
        GROUP BY c.CLOSE_YYYYMM, c.ORGANIZATION_ID
        ORDER BY c.CLOSE_YYYYMM DESC
        FETCH FIRST 1 ROWS ONLY`,
      namedBinds({ organizationId }),
    )) as Row[])[0];
    if (!r) return null;
    return {
      yyyymm: String(r.yyyymm),
      items: num(r.items),
      bookItems: num(r.bookItems),
      countedItems: num(r.countedItems),
      diffItems: num(r.diffItems),
      /** 조정이 아직 안 들어간 품목 */
      pendingItems: num(r.pendingItems),
      entries: num(r.entries),
      startedAt: (r.startedAt as string) ?? null,
    };
  }

  /** 실사 시작 — 지금 공정재고(≠ 0)를 실사표에 고정한다. `regenerate` 면 장부만 다시 고정. */
  async start(yyyymm: string, regenerate: boolean, organizationId: number, userId: string) {
    if (!isStocktakeMonthAllowed(yyyymm)) {
      throw new BadRequestException('실사는 이번 달 또는 지난달만 시작할 수 있습니다.');
    }
    return this.tx.run(async (qr) => {
      const exists = num(((await qr.query(
        `SELECT COUNT(*) AS "n" FROM IM_ITEM_WORKSTAGE_INV_CHECK
          WHERE CLOSE_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ yyyymm, organizationId }),
      )) as Row[])[0]?.n);
      if (exists && !regenerate) throw new BadRequestException(`${yyyymm} 공정 실사는 이미 시작했습니다.`);
      const adjusted = ((await qr.query(postedSql, namedBinds({ yyyymm, organizationId }))) as Row[]).length;
      if (adjusted) {
        throw new BadRequestException(`${yyyymm} 은 이미 조정이 ${adjusted}개 품목에 들어가 장부를 다시 고정할 수 없습니다.`);
      }
      await qr.query(
        `DELETE FROM IM_ITEM_WORKSTAGE_INV_CHECK WHERE CLOSE_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ yyyymm, organizationId }),
      );
      await qr.query(
        `INSERT INTO IM_ITEM_WORKSTAGE_INV_CHECK
           (CLOSE_YYYYMM, ITEM_CODE, LINE_TYPE, LINE_CODE, WORKSTAGE_CODE, MACHINE_CODE, MFS, MATERIAL_MFS,
            ORGANIZATION_ID, INVENTORY_HOLD, INVENTORY_PRICE, INVENTORY_QTY, CHECK_INVENTORY_QTY,
            INVENTORY_AMT, LOCATION_CODE, COMMENTS, ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
         SELECT :yyyymm, w.ITEM_CODE, NVL(i.LINE_TYPE, '*'), '*', '*', '*', '*', '*',
                w.ORGANIZATION_ID, 'N', 0, w.INVENTORY_QTY, 0, 0, '*', NULL, SYSDATE, :userId, SYSDATE, :userId
           FROM IM_ITEM_WORKSTAGE_INVENTORY w
           LEFT JOIN ID_ITEM i ON i.ITEM_CODE = w.ITEM_CODE AND i.ORGANIZATION_ID = w.ORGANIZATION_ID
          WHERE w.ORGANIZATION_ID = :organizationId AND NVL(w.INVENTORY_QTY, 0) <> 0`,
        namedBinds({ yyyymm, organizationId, userId }),
      );
      await qr.query(applyEntriesSql, namedBinds({ yyyymm, organizationId, userId }));
      const items = num(((await qr.query(
        `SELECT COUNT(*) AS "n" FROM IM_ITEM_WORKSTAGE_INV_CHECK WHERE CLOSE_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ yyyymm, organizationId }),
      )) as Row[])[0]?.n);
      return { yyyymm, items };
    });
  }

  /**
   * 입력 반영 — 스캔 한 건(`mode = 'scan'`)이면 이미 센 롯트를 거절하고, 엑셀(`'upload'`)이면
   * 같은 롯트·품목 입력을 엑셀 수량으로 고친다 (같은 파일을 다시 올려도 결과가 같다).
   */
  async record(rows: WipCountRow[], mode: 'scan' | 'upload', organizationId: number, userId: string) {
    if (!rows.length) throw new BadRequestException('넣을 줄이 없습니다.');
    if (rows.length > UPLOAD_MAX_ROWS) {
      throw new BadRequestException(`한 번에 ${UPLOAD_MAX_ROWS.toLocaleString()}줄까지 넣을 수 있습니다.`);
    }
    const session = await this.active(organizationId);
    if (!session) throw new BadRequestException('진행 중인 공정 실사가 없습니다. 실사를 먼저 시작하세요.');
    const yyyymm = session.yyyymm;
    const up = (v?: string) => v?.trim().toUpperCase() || null;
    const input = rows.map((r, i) => ({
      rn: r.row ?? i + 1,
      barcode: up(r.barcode),
      lotNo: up(r.lotNo),
      itemCode: up(r.itemCode),
      qty: r.qty === undefined ? null : r.qty,
      lineCode: up(r.lineCode),
    }));

    return this.tx.run(async (qr) => {
      const resolved = await this.resolve(qr, input, organizationId);
      const { entries, errors } = classifyWipRows(input, resolved);
      if (mode === 'scan' && errors.length) throw new BadRequestException(errors[0].reason + `: ${errors[0].value}`);
      if (!entries.length) return { yyyymm, applied: 0, updated: 0, errors };

      // 이미 넣은 입력. 롯트는 라인과 상관없이 하나, 품목 입력은 품목·라인마다 하나다.
      // (JSON_TABLE 을 서브쿼리에 넣으면 이 DB 에서 ORA-00600 이 나서 JS 로 맞춘다.)
      const existingRows = (await qr.query(
        `SELECT ROWIDTOCHAR(ROWID) AS "rid", ITEM_CODE AS "itemCode", MFS AS "mfs",
                LINE_CODE AS "lineCode", LINE_TYPE AS "lineType"
           FROM IM_ITEM_WS_INVE_CHECK_EXCEL WHERE CLOSE_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ yyyymm, organizationId }),
      )) as Row[];
      const keyOf = (e: { itemCode: unknown; mfs: unknown; lineCode: unknown }) =>
        (e.mfs === '*' ? `${String(e.itemCode)}|*|${String(e.lineCode)}` : `${String(e.itemCode)}|${String(e.mfs)}`);
      const existing = new Map(existingRows.map((r) => [keyOf({ itemCode: r.itemCode, mfs: r.mfs, lineCode: r.lineCode }), r]));
      const updated = entries.filter((e) => existing.has(keyOf(e))).length;
      if (mode === 'scan' && updated) throw new BadRequestException(`이미 센 입력입니다: ${entries[0].mfs === '*' ? entries[0].itemCode : entries[0].mfs}`);

      // 같은 롯트를 다른 라인·거래유형으로 다시 넣으면 예전 행을 지운다 (MERGE 키가 달라 겹치지 않게).
      const stale = entries
        .map((e) => existing.get(keyOf(e)))
        .filter((r, i): r is Row => Boolean(r) && (String(r!.lineCode) !== entries[i].lineCode || String(r!.lineType) !== entries[i].lineType))
        .map((r) => String(r.rid));
      for (let i = 0; i < stale.length; i += 500) {
        const chunk = stale.slice(i, i + 500);
        const binds: Record<string, string> = {};
        chunk.forEach((rid, j) => { binds[`r${j}`] = rid; });
        await qr.query(
          `DELETE FROM IM_ITEM_WS_INVE_CHECK_EXCEL WHERE ROWID IN (${chunk.map((_, j) => `CHARTOROWID(:r${j})`).join(', ')})`,
          namedBinds(binds),
        );
      }

      const json = JSON.stringify(entries);
      await qr.query(
        `MERGE INTO IM_ITEM_WS_INVE_CHECK_EXCEL t
         USING (SELECT J.ITEM, J.LT, J.MFS, J.LINE, J.QTY FROM JSON_TABLE(:entryJson, '$[*]' COLUMNS (
                  ITEM VARCHAR2(30) PATH '$.itemCode', LT VARCHAR2(10) PATH '$.lineType',
                  MFS VARCHAR2(30) PATH '$.mfs', LINE VARCHAR2(20) PATH '$.lineCode',
                  QTY NUMBER PATH '$.qty')) J) s
         ON (t.CLOSE_YYYYMM = :yyyymm AND t.ORGANIZATION_ID = :organizationId AND t.ITEM_CODE = s.ITEM
             AND t.LINE_TYPE = s.LT AND t.MFS = s.MFS AND t.LINE_CODE = s.LINE
             AND t.WORKSTAGE_CODE = '*' AND t.LOCATION_CODE = '*')
         WHEN MATCHED THEN UPDATE SET t.CHECK_INVENTORY_QTY = s.QTY
         WHEN NOT MATCHED THEN INSERT
              (CLOSE_YYYYMM, ITEM_CODE, LINE_TYPE, MFS, LINE_CODE, WORKSTAGE_CODE, ORGANIZATION_ID,
               CHECK_INVENTORY_QTY, LOCATION_CODE, EXCEL_CHECK_INVENTORY_QTY)
              VALUES (:yyyymm, s.ITEM, s.LT, s.MFS, s.LINE, '*', :organizationId, s.QTY, '*', NULL)`,
        namedBinds({ yyyymm, organizationId, entryJson: clobBind(json) }),
      );
      await qr.query(applyEntriesSql, namedBinds({ yyyymm, organizationId, userId }));

      if (mode === 'scan') {
        const e = entries[0];
        const r = ((await qr.query(
          `SELECT c.ITEM_CODE AS "itemCode", i.ITEM_NAME AS "itemName",
                  NVL(c.INVENTORY_QTY, 0) AS "bookQty", NVL(c.CHECK_INVENTORY_QTY, 0) AS "countedQty"
             FROM IM_ITEM_WORKSTAGE_INV_CHECK c
             LEFT JOIN ID_ITEM i ON i.ITEM_CODE = c.ITEM_CODE AND i.ORGANIZATION_ID = c.ORGANIZATION_ID
            WHERE c.CLOSE_YYYYMM = :yyyymm AND c.ORGANIZATION_ID = :organizationId
              AND c.ITEM_CODE = :itemCode AND c.MFS = '*' AND c.LINE_CODE = '*'`,
          namedBinds({ yyyymm, organizationId, itemCode: e.itemCode }),
        )) as Row[])[0] ?? {};
        return {
          yyyymm, applied: 1, updated: 0, errors,
          last: {
            itemCode: e.itemCode, itemName: (r.itemName as string) ?? null, lotNo: e.mfs, qty: e.qty,
            bookQty: num(r.bookQty), countedQty: num(r.countedQty),
          },
        };
      }
      return { yyyymm, applied: entries.length, updated, errors };
    });
  }

  /** 입력 취소 — 롯트(바코드) 또는 품목·라인 입력 한 건을 지우고 다시 합산한다. */
  async cancel(row: WipCountRow, organizationId: number, userId: string) {
    const session = await this.active(organizationId);
    if (!session) throw new BadRequestException('진행 중인 공정 실사가 없습니다.');
    const yyyymm = session.yyyymm;
    const up = (v?: string) => v?.trim().toUpperCase() || null;
    const input = [{ rn: 1, barcode: up(row.barcode), lotNo: up(row.lotNo), itemCode: up(row.itemCode), qty: 0, lineCode: up(row.lineCode) }];
    return this.tx.run(async (qr) => {
      const resolved = await this.resolve(qr, input, organizationId);
      const { entries, errors } = classifyWipRows(input, resolved);
      if (errors.length) throw new BadRequestException(errors[0].reason + `: ${errors[0].value}`);
      const e = entries[0];
      await qr.query(
        `DELETE FROM IM_ITEM_WS_INVE_CHECK_EXCEL
          WHERE CLOSE_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId
            AND ITEM_CODE = :itemCode AND MFS = :mfs ${e.mfs === '*' ? 'AND LINE_CODE = :lineCode' : ''}`,
        namedBinds({ yyyymm, organizationId, itemCode: e.itemCode, mfs: e.mfs, ...(e.mfs === '*' ? { lineCode: e.lineCode } : {}) }),
      );
      await qr.query(
        `UPDATE IM_ITEM_WORKSTAGE_INV_CHECK c
            SET c.CHECK_INVENTORY_QTY = NVL((SELECT SUM(e.CHECK_INVENTORY_QTY) FROM IM_ITEM_WS_INVE_CHECK_EXCEL e
                                              WHERE e.CLOSE_YYYYMM = c.CLOSE_YYYYMM AND e.ORGANIZATION_ID = c.ORGANIZATION_ID
                                                AND e.ITEM_CODE = c.ITEM_CODE), 0),
                c.LAST_MODIFY_DATE = SYSDATE, c.LAST_MODIFY_BY = :userId
          WHERE c.CLOSE_YYYYMM = :yyyymm AND c.ORGANIZATION_ID = :organizationId AND c.ITEM_CODE = :itemCode
            AND c.MFS = '*' AND c.LINE_CODE = '*'`,
        namedBinds({ yyyymm, organizationId, itemCode: e.itemCode, userId }),
      );
      return { yyyymm, itemCode: e.itemCode, lotNo: e.mfs };
    });
  }

  /** 일괄 조정 — 품목별 (장부 − 실사) 에서 이미 넣은 조정을 빼고 남은 만큼 공정출고로 넣는다. */
  async adjustAll(yyyymm: string, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      const rows = (await qr.query(
        `SELECT c.ITEM_CODE AS "itemCode",
                NVL(c.INVENTORY_QTY, 0) - NVL(c.CHECK_INVENTORY_QTY, 0) - NVL(a.POSTED, 0) AS "remaining"
           FROM IM_ITEM_WORKSTAGE_INV_CHECK c
           LEFT JOIN (${postedSql}) a ON a.ITEM_CODE = c.ITEM_CODE
          WHERE c.CLOSE_YYYYMM = :yyyymm AND c.ORGANIZATION_ID = :organizationId
            AND c.MFS = '*' AND c.LINE_CODE = '*'
            AND NVL(c.INVENTORY_QTY, 0) - NVL(c.CHECK_INVENTORY_QTY, 0) - NVL(a.POSTED, 0) <> 0`,
        namedBinds({ yyyymm, organizationId }),
      )) as Row[];
      if (!rows.length) throw new BadRequestException('조정할 차이가 없습니다.');
      await qr.query(
        `INSERT INTO IM_ITEM_WORKSTAGE_ISSUE
           (ISSUE_DATE, ISSUE_SEQUENCE, ORGANIZATION_ID, ITEM_CODE, ISSUE_DEFICIT, ISSUE_QTY,
            ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
         SELECT F_GET_INVENTORY_CLOSE_DATE(:yyyymm, 'END', :organizationId), SEQ_WORKSTAGE_ISSUE_SEQ.NEXTVAL,
                :organizationId, J.ITEM, CASE WHEN J.QTY > 0 THEN '3' ELSE '4' END, J.QTY,
                SYSDATE, :userId, SYSDATE, '${WIP_ADJUST_MARK}'
           FROM JSON_TABLE(:adjustJson, '$[*]' COLUMNS (
                  ITEM VARCHAR2(30) PATH '$.itemCode', QTY NUMBER PATH '$.remaining')) J`,
        namedBinds({
          yyyymm, organizationId, userId,
          adjustJson: clobBind(JSON.stringify(rows.map((r) => ({ itemCode: r.itemCode, remaining: num(r.remaining) })))),
        }),
      );
      return { yyyymm, adjusted: rows.length };
    });
  }

  /** 실사표 (품목별 장부 · 실사 · 차이 · 이미 넣은 조정). 차이 있는 품목이 먼저. */
  async list(yyyymm: string, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT c.ITEM_CODE AS "itemCode", i.ITEM_NAME AS "itemName", i.ITEM_SPEC AS "itemSpec",
              i.ITEM_UOM AS "itemUom", c.LINE_TYPE AS "lineType",
              NVL(c.INVENTORY_QTY, 0) AS "bookQty", NVL(c.CHECK_INVENTORY_QTY, 0) AS "checkQty",
              NVL(c.CHECK_INVENTORY_QTY, 0) - NVL(c.INVENTORY_QTY, 0) AS "differenceQty",
              -a.POSTED AS "adjustedQty",
              (SELECT COUNT(*) FROM IM_ITEM_WS_INVE_CHECK_EXCEL e
                WHERE e.CLOSE_YYYYMM = c.CLOSE_YYYYMM AND e.ORGANIZATION_ID = c.ORGANIZATION_ID
                  AND e.ITEM_CODE = c.ITEM_CODE) AS "entries",
              c.COMMENTS AS "comments"
         FROM IM_ITEM_WORKSTAGE_INV_CHECK c
         LEFT JOIN ID_ITEM i ON i.ITEM_CODE = c.ITEM_CODE AND i.ORGANIZATION_ID = c.ORGANIZATION_ID
         LEFT JOIN (${postedSql}) a ON a.ITEM_CODE = c.ITEM_CODE
        WHERE c.CLOSE_YYYYMM = :yyyymm AND c.ORGANIZATION_ID = :organizationId
          AND c.MFS = '*' AND c.LINE_CODE = '*'
        ORDER BY CASE WHEN NVL(c.CHECK_INVENTORY_QTY, 0) <> NVL(c.INVENTORY_QTY, 0) THEN 0 ELSE 1 END, c.ITEM_CODE`,
      namedBinds({ yyyymm, organizationId }),
    )) as Row[];
    return rows;
  }

  /** 입력 기록 (롯트·품목 입력 한 건씩). */
  async entries(yyyymm: string, organizationId: number) {
    return (await this.dataSource.query(
      `SELECT e.ITEM_CODE AS "itemCode", i.ITEM_NAME AS "itemName",
              CASE WHEN e.MFS = '*' THEN NULL ELSE e.MFS END AS "lotNo",
              CASE WHEN e.LINE_CODE = '*' THEN NULL ELSE e.LINE_CODE END AS "lineCode",
              e.CHECK_INVENTORY_QTY AS "qty"
         FROM IM_ITEM_WS_INVE_CHECK_EXCEL e
         LEFT JOIN ID_ITEM i ON i.ITEM_CODE = e.ITEM_CODE AND i.ORGANIZATION_ID = e.ORGANIZATION_ID
        WHERE e.CLOSE_YYYYMM = :yyyymm AND e.ORGANIZATION_ID = :organizationId
        ORDER BY e.ITEM_CODE, e.MFS`,
      namedBinds({ yyyymm, organizationId }),
    )) as Row[];
  }

  /** 줄마다 품목을 찾는다: 바코드 → 롯트번호 → 바코드에서 뽑은 롯트·품목 → 품목코드. */
  private async resolve(
    qr: QueryRunner,
    input: { rn: number; barcode: string | null; lotNo: string | null; itemCode: string | null }[],
    organizationId: number,
  ) {
    return (await qr.query(
      `SELECT J.RN AS "rn", NVL(B.ITEM_CODE, I.ITEM_CODE) AS "itemCode", B.LOT_NO AS "lotNo",
              B.SCAN_QTY AS "scanQty", NVL(I2.LINE_TYPE, I.LINE_TYPE) AS "lineType"
         FROM JSON_TABLE(:inputJson, '$[*]' COLUMNS (
                RN NUMBER PATH '$.rn', BC VARCHAR2(200) PATH '$.barcode',
                LOT VARCHAR2(60) PATH '$.lotNo', ITEM VARCHAR2(30) PATH '$.itemCode')) J
         OUTER APPLY (
           SELECT * FROM (
             SELECT b.ITEM_CODE, b.LOT_NO, b.SCAN_QTY, 1 AS RK FROM IM_ITEM_RECEIPT_BARCODE b
              WHERE J.BC IS NOT NULL AND b.ITEM_BARCODE = J.BC AND b.ORGANIZATION_ID = :organizationId
             UNION ALL
             SELECT b.ITEM_CODE, b.LOT_NO, b.SCAN_QTY, 2 FROM IM_ITEM_RECEIPT_BARCODE b
              WHERE J.LOT IS NOT NULL AND b.LOT_NO = J.LOT
                AND (J.ITEM IS NULL OR b.ITEM_CODE = J.ITEM) AND b.ORGANIZATION_ID = :organizationId
             UNION ALL
             SELECT b.ITEM_CODE, b.LOT_NO, b.SCAN_QTY, 3 FROM IM_ITEM_RECEIPT_BARCODE b
              WHERE J.BC IS NOT NULL AND b.LOT_NO = F_GET_LOT_NO_FROM_BARCODE(J.BC)
                AND b.ITEM_CODE = F_GET_ITEM_CODE_FROM_BARCODE(J.BC) AND b.ORGANIZATION_ID = :organizationId
           ) ORDER BY RK FETCH FIRST 1 ROWS ONLY) B
         OUTER APPLY (
           SELECT x.ITEM_CODE, x.LINE_TYPE FROM ID_ITEM x
            WHERE J.BC IS NULL AND J.LOT IS NULL AND x.ITEM_CODE = J.ITEM AND x.ORGANIZATION_ID = :organizationId) I
         OUTER APPLY (
           SELECT y.LINE_TYPE FROM ID_ITEM y
            WHERE y.ITEM_CODE = B.ITEM_CODE AND y.ORGANIZATION_ID = :organizationId) I2
        ORDER BY J.RN`,
      namedBinds({ inputJson: clobBind(JSON.stringify(input)), organizationId }),
    )) as Row[];
  }
}
