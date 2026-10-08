/**
 * @file src/modules/inventory-query/fg-stocktake.service.ts
 * @description 제품(완제품) 실사 — 실사 시작(장부 고정) · 박스 바코드 스캔 · 엑셀 업로드 · 일괄 조정
 *
 * 초보자 가이드:
 * 1. **제품 재고는 박스(PACK) 바코드 한 줄 = 재고 한 행이다** (`IP_PRODUCT_FG_INVENTORY`, 키는
 *    바코드+로케이션, 수량은 박스 안 PCS). 그래서 실사는 "창고의 박스 바코드를 전부 찍는 것"이고,
 *    찍힌 박스는 있는 것, 안 찍힌 박스는 없는 것으로 본다. 자재 바코드 실사(stocktake.service.ts)와 같다.
 * 2. **흐름**
 *    ① 실사 시작: 그 순간의 제품재고(수량 ≠ 0)를 실사표(`IP_PRODUCT_FG_INV_CHECK`)에 장부로 고정한다.
 *    ② 스캔·엑셀: 박스 바코드를 찍으면 실사수량을 채운다. 수량을 비우면 장부 수량(장부에 없던
 *       박스는 박스 라벨 수량), 쓰다 만 박스는 센 수량을 넣는다. 장부에 없던 박스는 장부 0 으로 추가된다.
 *    ③ 일괄 조정: 박스별 (실사 − 장부 − 이미 넣은 조정)을 재고에 더한다.
 * 3. **조정은 입고·출고에 넣지 않는다.** 두 표는 판매실적·납품 뷰·출하 화면이 읽어서 조정이 매출로
 *    섞인다. 재고를 직접 고치고 한 건씩 `IP_PRODUCT_FG_ADJUST` 에 남긴다 (월마감의 조정 칸이 이 표를 합산).
 *    날짜는 그 달 마감 기간의 종료일이다 (마감일자설정, 없으면 말일). 다시 눌러도 이미 넣은 만큼은 빼므로 두 번 들어가지 않는다.
 * 4. 실사 중에는 제품 입출고를 멈춘다 — 장부는 ① 시점에 고정되기 때문이다.
 *    마감한 달은 시작·스캔·조정 모두 거절한다.
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource, QueryRunner } from 'typeorm';
import { likePrefix } from '@smt/shared';
import { TransactionService } from '../../shared/transaction.service';
import { ROW_LIMIT } from '../../shared/row-limit';
import { isStocktakePeriodAllowed } from './close-period';
import { namedBinds } from '../../common/utils/named-binds.util';
import { clobBind } from '../../common/services/oracle.service';
import { isStocktakeMonthAllowed, UPLOAD_MAX_ROWS } from './stocktake.service';

type Row = Record<string, unknown>;
const num = (v: unknown) => Number(v ?? 0);

/** 장부에 없던 박스를 넣을 때 쓰는 로케이션 (양품 창고). */
export const FG_DEFAULT_LOCATION = 'P01';
const ADJUST_BY = 'INV ADJUST';

/** 입력 한 건. 박스 바코드는 있어야 한다. 수량을 비우면 장부(또는 박스 라벨) 수량. */
export interface FgCountRow {
  /** 엑셀 줄 번호 (오류 보고용) */
  row?: number;
  barcode?: string;
  qty?: number;
  locationCode?: string;
}

/** 실사표에 반영할 한 줄 */
export interface FgEntry {
  barcode: string;
  locationCode: string;
  qty: number;
  /** 실사표에 이미 있는 박스인가 (없으면 장부 0 으로 새로 넣는다) */
  inCheck: boolean;
  packType: string | null;
  modelName: string | null;
  modelSuffix: string | null;
  itemCode: string | null;
}

export interface FgUploadError { row: number; value: string; reason: string }

/** 이 달 조정 합계를 박스·로케이션별로 */
const postedSql = `
  SELECT a.BARCODE, a.LOCATION_CODE, SUM(a.ADJUST_QTY) AS POSTED
    FROM IP_PRODUCT_FG_ADJUST a
   WHERE a.CHECK_YYYYMM = :yyyymm AND a.ORGANIZATION_ID = :organizationId
   GROUP BY a.BARCODE, a.LOCATION_CODE`;

/** 마감한 달인지 본다. 마감한 달은 실사를 건드릴 수 없다. */
export async function assertFgMonthOpen(qr: QueryRunner, yyyymm: string, organizationId: number) {
  const closed = num(((await qr.query(
    `SELECT COUNT(*) AS "n" FROM IP_PRODUCT_FG_INV_CLOSE_MONTH
      WHERE CLOSE_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId AND CLOSE_YN = 'Y'`,
    namedBinds({ yyyymm, organizationId }),
  )) as Row[])[0]?.n);
  if (closed) throw new BadRequestException(`${yyyymm} 은 이미 제품 재고마감을 한 달입니다.`);
}

/**
 * 입력 줄과 찾아온 결과를 맞춰 반영할 줄과 오류 줄로 나눈다.
 * 오류: 바코드 없음 / 등록 안 된 바코드 / 수량이 음수·숫자 아님 / 파일 안 바코드 중복.
 * `resolved` 한 줄 = 바코드 하나에 대한 후보(실사표에 있으면 로케이션별로 여러 줄일 수 있다).
 */
export function classifyFgRows(
  input: { rn: number; barcode: string | null; qty: number | null; locationCode: string | null }[],
  resolved: Row[],
) {
  const byRn = new Map<number, Row[]>();
  for (const r of resolved) {
    const list = byRn.get(num(r.rn)) ?? [];
    list.push(r);
    byRn.set(num(r.rn), list);
  }
  const errors: FgUploadError[] = [];
  const entries: FgEntry[] = [];
  const seen = new Set<string>();
  for (const src of input) {
    const value = src.barcode ?? '';
    if (!value) { errors.push({ row: src.rn, value, reason: '바코드가 비어 있음' }); continue; }
    if (src.qty !== null && !(Number.isFinite(src.qty) && src.qty >= 0)) {
      errors.push({ row: src.rn, value, reason: '수량이 0 이상의 숫자가 아님' }); continue;
    }
    const cands = byRn.get(src.rn) ?? [];
    // 실사표에 있는 박스: 로케이션을 줬으면 그 로케이션, 아니면 장부 수량이 큰 쪽
    const inCheck = cands
      .filter((c) => c.checkLocation)
      .sort((a, b) => num(b.bookQty) - num(a.bookQty));
    const picked = src.locationCode
      ? inCheck.find((c) => String(c.checkLocation) === src.locationCode)
      : inCheck[0];
    if (picked) {
      if (seen.has(`${value}|${String(picked.checkLocation)}`)) {
        errors.push({ row: src.rn, value, reason: '파일 안에서 같은 박스 바코드가 겹침' }); continue;
      }
      seen.add(`${value}|${String(picked.checkLocation)}`);
      entries.push({
        barcode: value, locationCode: String(picked.checkLocation), qty: src.qty ?? num(picked.bookQty),
        inCheck: true, packType: null, modelName: null, modelSuffix: null, itemCode: null,
      });
      continue;
    }
    const pack = cands.find((c) => c.packBarcode);
    if (!pack) { errors.push({ row: src.rn, value, reason: '등록되지 않은 박스 바코드' }); continue; }
    const packQty = src.qty ?? num(pack.packQty);
    if (!(packQty > 0)) { errors.push({ row: src.rn, value, reason: '장부에 없는 박스라 수량을 알 수 없음 — 수량을 넣어야 함' }); continue; }
    const locationCode = src.locationCode ?? FG_DEFAULT_LOCATION;
    if (seen.has(`${value}|${locationCode}`)) {
      errors.push({ row: src.rn, value, reason: '파일 안에서 같은 박스 바코드가 겹침' }); continue;
    }
    seen.add(`${value}|${locationCode}`);
    entries.push({
      barcode: value, locationCode, qty: packQty,
      inCheck: false,
      packType: (pack.packType as string | null) ?? null,
      modelName: (pack.modelName as string | null) ?? null,
      modelSuffix: (pack.modelSuffix as string | null) ?? '*',
      itemCode: (pack.itemCode as string | null) ?? null,
    });
  }
  return { entries, errors };
}

@Injectable()
export class FgStocktakeService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  /** 진행 중인 제품 실사 — 실사표가 있는 가장 최근 달. 없으면 null. */
  async active(organizationId: number) {
    const latest = ((await this.dataSource.query(
      `SELECT MAX(CHECK_YYYYMM) AS "yyyymm" FROM IP_PRODUCT_FG_INV_CHECK WHERE ORGANIZATION_ID = :organizationId`,
      namedBinds({ organizationId }),
    )) as Row[])[0]?.yyyymm as string | null | undefined;
    if (!latest) return null;
    const r = ((await this.dataSource.query(
      `SELECT c.CHECK_YYYYMM AS "yyyymm",
              COUNT(*) AS "boxes",
              SUM(CASE WHEN c.INVENTORY_QTY <> 0 THEN 1 ELSE 0 END) AS "bookBoxes",
              SUM(CASE WHEN c.SCANNED_YN = 'Y' THEN 1 ELSE 0 END) AS "scannedBoxes",
              SUM(CASE WHEN c.CHECK_QTY <> c.INVENTORY_QTY THEN 1 ELSE 0 END) AS "diffBoxes",
              SUM(CASE WHEN c.CHECK_QTY - c.INVENTORY_QTY - NVL(a.POSTED, 0) <> 0 THEN 1 ELSE 0 END) AS "pendingBoxes",
              SUM(c.INVENTORY_QTY) AS "bookQty",
              SUM(c.CHECK_QTY) AS "checkQty",
              TO_CHAR(MIN(c.ENTER_DATE), 'YYYY-MM-DD HH24:MI') AS "startedAt"
         FROM IP_PRODUCT_FG_INV_CHECK c
         LEFT JOIN (${postedSql}) a ON a.BARCODE = c.BARCODE AND a.LOCATION_CODE = c.LOCATION_CODE
        WHERE c.ORGANIZATION_ID = :organizationId AND c.CHECK_YYYYMM = :yyyymm
        GROUP BY c.CHECK_YYYYMM`,
      namedBinds({ yyyymm: latest, organizationId }),
    )) as Row[])[0];
    if (!r) return null;
    return {
      yyyymm: String(r.yyyymm),
      boxes: num(r.boxes),
      bookBoxes: num(r.bookBoxes),
      scannedBoxes: num(r.scannedBoxes),
      diffBoxes: num(r.diffBoxes),
      /** 조정이 아직 안 들어간 박스 */
      pendingBoxes: num(r.pendingBoxes),
      bookQty: num(r.bookQty),
      checkQty: num(r.checkQty),
      startedAt: (r.startedAt as string) ?? null,
    };
  }

  /** 실사 시작 — 지금 제품재고(≠ 0)를 실사표에 고정한다. `regenerate` 면 장부만 다시 고정(센 것은 남긴다). */
  async start(yyyymm: string, regenerate: boolean, organizationId: number, userId: string) {
    if (!(await isStocktakePeriodAllowed(this.dataSource, yyyymm, organizationId, isStocktakeMonthAllowed))) {
      throw new BadRequestException('실사는 이번 마감 기간 또는 직전 마감 기간만 시작할 수 있습니다.');
    }
    return this.tx.run(async (qr) => {
      await assertFgMonthOpen(qr, yyyymm, organizationId);
      const exists = num(((await qr.query(
        `SELECT COUNT(*) AS "n" FROM IP_PRODUCT_FG_INV_CHECK WHERE CHECK_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ yyyymm, organizationId }),
      )) as Row[])[0]?.n);
      if (exists && !regenerate) throw new BadRequestException(`${yyyymm} 제품 실사는 이미 시작했습니다.`);
      const adjusted = num(((await qr.query(
        `SELECT COUNT(*) AS "n" FROM IP_PRODUCT_FG_ADJUST WHERE CHECK_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ yyyymm, organizationId }),
      )) as Row[])[0]?.n);
      if (adjusted) {
        throw new BadRequestException(`${yyyymm} 은 이미 조정이 ${adjusted}건 들어가 장부를 다시 고정할 수 없습니다.`);
      }
      // ① 이미 있는 줄은 장부만 지금 값으로 갱신 (센 수량은 그대로)
      await qr.query(
        `UPDATE IP_PRODUCT_FG_INV_CHECK c
            SET c.INVENTORY_QTY = NVL((SELECT i.QTY FROM IP_PRODUCT_FG_INVENTORY i
                                        WHERE i.BARCODE = c.BARCODE AND i.LOCATION_CODE = c.LOCATION_CODE), 0),
                c.LAST_MODIFY_DATE = SYSDATE, c.LAST_MODIFY_BY = :userId
          WHERE c.CHECK_YYYYMM = :yyyymm AND c.ORGANIZATION_ID = :organizationId`,
        namedBinds({ userId, yyyymm, organizationId }),
      );
      // ② 지금 재고가 있는데 실사표에 없는 박스를 추가
      await qr.query(
        `INSERT INTO IP_PRODUCT_FG_INV_CHECK
           (CHECK_YYYYMM, BARCODE, LOCATION_CODE, ORGANIZATION_ID, PACK_TYPE, MODEL_NAME, MODEL_SUFFIX, ITEM_CODE,
            INVENTORY_QTY, CHECK_QTY, SCANNED_YN, COMMENTS, ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
         SELECT :yyyymm, i.BARCODE, i.LOCATION_CODE, i.ORGANIZATION_ID, i.PACK_TYPE, i.MODEL_NAME, i.MODEL_SUFFIX,
                i.ITEM_CODE, i.QTY, 0, 'N', NULL, SYSDATE, :userId, SYSDATE, :userId
           FROM IP_PRODUCT_FG_INVENTORY i
          WHERE i.ORGANIZATION_ID = :organizationId AND i.QTY <> 0
            AND NOT EXISTS (SELECT 1 FROM IP_PRODUCT_FG_INV_CHECK c
                             WHERE c.CHECK_YYYYMM = :yyyymm AND c.ORGANIZATION_ID = i.ORGANIZATION_ID
                               AND c.BARCODE = i.BARCODE AND c.LOCATION_CODE = i.LOCATION_CODE)`,
        namedBinds({ yyyymm, userId, organizationId }),
      );
      // ③ 재고가 0 이 됐고 센 적도 없는 줄은 뺀다
      await qr.query(
        `DELETE FROM IP_PRODUCT_FG_INV_CHECK
          WHERE CHECK_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId AND INVENTORY_QTY = 0 AND SCANNED_YN = 'N'`,
        namedBinds({ yyyymm, organizationId }),
      );
      const boxes = num(((await qr.query(
        `SELECT COUNT(*) AS "n" FROM IP_PRODUCT_FG_INV_CHECK WHERE CHECK_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ yyyymm, organizationId }),
      )) as Row[])[0]?.n);
      return { yyyymm, boxes };
    });
  }

  /**
   * 입력 반영 — 스캔 한 건(`mode = 'scan'`)이면 이미 센 박스를 거절하고, 엑셀(`'upload'`)이면
   * 같은 박스를 엑셀 수량으로 고친다 (같은 파일을 다시 올려도 결과가 같다).
   */
  async record(rows: FgCountRow[], mode: 'scan' | 'upload', organizationId: number, userId: string) {
    if (!rows.length) throw new BadRequestException('넣을 줄이 없습니다.');
    if (rows.length > UPLOAD_MAX_ROWS) {
      throw new BadRequestException(`한 번에 ${UPLOAD_MAX_ROWS.toLocaleString()}줄까지 넣을 수 있습니다.`);
    }
    const session = await this.active(organizationId);
    if (!session) throw new BadRequestException('진행 중인 제품 실사가 없습니다. 실사를 먼저 시작하세요.');
    const yyyymm = session.yyyymm;
    const up = (v?: string) => v?.trim().toUpperCase() || null;
    const input = rows.map((r, i) => ({
      rn: r.row ?? i + 1,
      barcode: up(r.barcode),
      qty: r.qty === undefined ? null : r.qty,
      locationCode: up(r.locationCode),
    }));

    return this.tx.run(async (qr) => {
      await assertFgMonthOpen(qr, yyyymm, organizationId);
      const resolved = await this.resolve(qr, input, yyyymm, organizationId);
      const { entries, errors } = classifyFgRows(input, resolved);
      if (mode === 'scan' && errors.length) throw new BadRequestException(`${errors[0].reason}: ${errors[0].value}`);
      if (!entries.length) return { yyyymm, applied: 0, updated: 0, errors };

      const already = new Set(
        resolved.filter((r) => r.checkLocation && r.scannedYn === 'Y').map((r) => `${String(r.barcode)}|${String(r.checkLocation)}`),
      );
      const updated = entries.filter((e) => e.inCheck && already.has(`${e.barcode}|${e.locationCode}`)).length;
      if (mode === 'scan' && updated) throw new BadRequestException(`이미 센 박스입니다: ${entries[0].barcode}`);

      await qr.query(
        `MERGE INTO IP_PRODUCT_FG_INV_CHECK t
         USING (SELECT J.BC, J.LOC, J.QTY, J.PT, J.MN, J.MS, J.IC FROM JSON_TABLE(:entryJson, '$[*]' COLUMNS (
                  BC VARCHAR2(100) PATH '$.barcode', LOC VARCHAR2(10) PATH '$.locationCode', QTY NUMBER PATH '$.qty',
                  PT VARCHAR2(2) PATH '$.packType', MN VARCHAR2(100) PATH '$.modelName',
                  MS VARCHAR2(50) PATH '$.modelSuffix', IC VARCHAR2(20) PATH '$.itemCode')) J) s
         ON (t.CHECK_YYYYMM = :yyyymm AND t.ORGANIZATION_ID = :organizationId
             AND t.BARCODE = s.BC AND t.LOCATION_CODE = s.LOC)
         WHEN MATCHED THEN UPDATE
              SET t.CHECK_QTY = s.QTY, t.SCANNED_YN = 'Y', t.LAST_MODIFY_DATE = SYSDATE, t.LAST_MODIFY_BY = :userId
         WHEN NOT MATCHED THEN INSERT
              (CHECK_YYYYMM, BARCODE, LOCATION_CODE, ORGANIZATION_ID, PACK_TYPE, MODEL_NAME, MODEL_SUFFIX, ITEM_CODE,
               INVENTORY_QTY, CHECK_QTY, SCANNED_YN, COMMENTS, ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
              VALUES (:yyyymm, s.BC, s.LOC, :organizationId, s.PT, s.MN, s.MS, s.IC,
               0, s.QTY, 'Y', '장부에 없던 박스', SYSDATE, :userId, SYSDATE, :userId)`,
        namedBinds({ yyyymm, organizationId, userId, entryJson: clobBind(JSON.stringify(entries)) }),
      );

      if (mode === 'scan') {
        const e = entries[0];
        const r = ((await qr.query(
          `SELECT c.MODEL_NAME AS "modelName", c.MODEL_SUFFIX AS "modelSuffix", c.INVENTORY_QTY AS "bookQty",
                  c.CHECK_QTY AS "countedQty"
             FROM IP_PRODUCT_FG_INV_CHECK c
            WHERE c.CHECK_YYYYMM = :yyyymm AND c.ORGANIZATION_ID = :organizationId
              AND c.BARCODE = :barcode AND c.LOCATION_CODE = :locationCode`,
          namedBinds({ yyyymm, organizationId, barcode: e.barcode, locationCode: e.locationCode }),
        )) as Row[])[0] ?? {};
        return {
          yyyymm, applied: 1, updated: 0, errors,
          last: {
            barcode: e.barcode, locationCode: e.locationCode,
            modelName: (r.modelName as string) ?? null, modelSuffix: (r.modelSuffix as string) ?? null,
            qty: e.qty, bookQty: num(r.bookQty), countedQty: num(r.countedQty), newBox: !e.inCheck,
          },
        };
      }
      return { yyyymm, applied: entries.length, updated, errors };
    });
  }

  /** 입력 취소 — 센 것을 지운다. 장부에 없던 박스(장부 0)는 실사표에서 뺀다. */
  async cancel(row: FgCountRow, organizationId: number, userId: string) {
    const session = await this.active(organizationId);
    if (!session) throw new BadRequestException('진행 중인 제품 실사가 없습니다.');
    const yyyymm = session.yyyymm;
    const barcode = row.barcode?.trim().toUpperCase();
    if (!barcode) throw new BadRequestException('바코드가 필요합니다.');
    return this.tx.run(async (qr) => {
      await assertFgMonthOpen(qr, yyyymm, organizationId);
      const posted = num(((await qr.query(
        `SELECT COUNT(*) AS "n" FROM IP_PRODUCT_FG_ADJUST WHERE CHECK_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId AND BARCODE = :barcode`,
        namedBinds({ yyyymm, organizationId, barcode }),
      )) as Row[])[0]?.n);
      if (posted) throw new BadRequestException(`이미 조정이 들어간 박스입니다: ${barcode}`);
      const found = num(((await qr.query(
        `SELECT COUNT(*) AS "n" FROM IP_PRODUCT_FG_INV_CHECK
          WHERE CHECK_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId AND BARCODE = :barcode AND SCANNED_YN = 'Y'`,
        namedBinds({ yyyymm, organizationId, barcode }),
      )) as Row[])[0]?.n);
      if (!found) throw new BadRequestException(`센 적 없는 박스입니다: ${barcode}`);
      await qr.query(
        `DELETE FROM IP_PRODUCT_FG_INV_CHECK
          WHERE CHECK_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId AND BARCODE = :barcode
            AND SCANNED_YN = 'Y' AND INVENTORY_QTY = 0`,
        namedBinds({ yyyymm, organizationId, barcode }),
      );
      await qr.query(
        `UPDATE IP_PRODUCT_FG_INV_CHECK
            SET CHECK_QTY = 0, SCANNED_YN = 'N', LAST_MODIFY_DATE = SYSDATE, LAST_MODIFY_BY = :userId
          WHERE CHECK_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId AND BARCODE = :barcode`,
        namedBinds({ userId, yyyymm, organizationId, barcode }),
      );
      return { yyyymm, barcode };
    });
  }

  /**
   * 일괄 조정 — 박스별 (실사 − 장부 − 이미 넣은 조정)을 재고에 더하고 조정 한 건을 남긴다.
   * 안 센 박스는 실사 0 이라 재고가 0 이 된다 — 다 찍은 뒤에 눌러야 한다.
   */
  async adjustAll(yyyymm: string, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      await assertFgMonthOpen(qr, yyyymm, organizationId);
      const rows = (await qr.query(
        `SELECT c.BARCODE AS "barcode", c.LOCATION_CODE AS "locationCode", c.PACK_TYPE AS "packType",
                c.MODEL_NAME AS "modelName", c.MODEL_SUFFIX AS "modelSuffix", c.ITEM_CODE AS "itemCode",
                c.CHECK_QTY - c.INVENTORY_QTY - NVL(a.POSTED, 0) AS "remaining",
                NVL(i.QTY, 0) AS "nowQty", CASE WHEN i.BARCODE IS NULL THEN 'N' ELSE 'Y' END AS "inInventory"
           FROM IP_PRODUCT_FG_INV_CHECK c
           LEFT JOIN (${postedSql}) a ON a.BARCODE = c.BARCODE AND a.LOCATION_CODE = c.LOCATION_CODE
           LEFT JOIN IP_PRODUCT_FG_INVENTORY i ON i.BARCODE = c.BARCODE AND i.LOCATION_CODE = c.LOCATION_CODE
          WHERE c.CHECK_YYYYMM = :yyyymm AND c.ORGANIZATION_ID = :organizationId
            AND c.CHECK_QTY - c.INVENTORY_QTY - NVL(a.POSTED, 0) <> 0`,
        namedBinds({ yyyymm, organizationId }),
      )) as Row[];
      if (!rows.length) throw new BadRequestException('조정할 차이가 없습니다.');
      const negative = rows.find((r) => num(r.nowQty) + num(r.remaining) < 0);
      if (negative) {
        throw new BadRequestException(
          `실사 시작 뒤에 재고가 바뀌어 조정하면 음수가 됩니다: ${String(negative.barcode)} (지금 ${num(negative.nowQty)}, 조정 ${num(negative.remaining)}). 장부를 다시 고정하세요.`,
        );
      }
      const json = clobBind(JSON.stringify(rows.map((r) => ({
        barcode: r.barcode, locationCode: r.locationCode, packType: r.packType, modelName: r.modelName,
        modelSuffix: r.modelSuffix, itemCode: r.itemCode, qty: num(r.remaining),
      }))));
      await qr.query(
        `MERGE INTO IP_PRODUCT_FG_INVENTORY t
         USING (SELECT J.BC, J.LOC, J.QTY, J.PT, J.MN, J.MS, J.IC FROM JSON_TABLE(:adjustJson, '$[*]' COLUMNS (
                  BC VARCHAR2(100) PATH '$.barcode', LOC VARCHAR2(10) PATH '$.locationCode', QTY NUMBER PATH '$.qty',
                  PT VARCHAR2(2) PATH '$.packType', MN VARCHAR2(100) PATH '$.modelName',
                  MS VARCHAR2(50) PATH '$.modelSuffix', IC VARCHAR2(20) PATH '$.itemCode')) J) s
         ON (t.BARCODE = s.BC AND t.LOCATION_CODE = s.LOC)
         WHEN MATCHED THEN UPDATE
              SET t.QTY = t.QTY + s.QTY, t.LAST_MODIFY_BY = :adjustBy, t.LAST_MODIFY_DATE = SYSDATE
         WHEN NOT MATCHED THEN INSERT
              (BARCODE, PACK_TYPE, LOCATION_CODE, QTY, MODEL_NAME, MODEL_SUFFIX, ITEM_CODE, PALLET_FLAG,
               INVENTORY_DATE, ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE, ORGANIZATION_ID)
              VALUES (s.BC, s.PT, s.LOC, s.QTY, s.MN, s.MS, s.IC, 'N',
               SYSDATE, :adjustBy, SYSDATE, :adjustBy, SYSDATE, :organizationId)`,
        namedBinds({ adjustJson: json, adjustBy: ADJUST_BY, organizationId }),
      );
      await qr.query(
        `INSERT INTO IP_PRODUCT_FG_ADJUST
           (ADJUST_DATE, ADJUST_SEQUENCE, ORGANIZATION_ID, CHECK_YYYYMM, BARCODE, LOCATION_CODE, PACK_TYPE,
            MODEL_NAME, MODEL_SUFFIX, ITEM_CODE, ADJUST_QTY, COMMENTS, ENTER_DATE, ENTER_BY)
         SELECT TRUNC(F_GET_INVENTORY_CLOSE_DATE(:yyyymm, 'END', :organizationId)), SEQ_FG_ADJUST_SEQ.NEXTVAL, :organizationId, :yyyymm,
                J.BC, J.LOC, J.PT, J.MN, J.MS, J.IC, J.QTY, 'INVENTORY ADJUST', SYSDATE, :userId
           FROM JSON_TABLE(:adjustJson, '$[*]' COLUMNS (
                  BC VARCHAR2(100) PATH '$.barcode', LOC VARCHAR2(10) PATH '$.locationCode', QTY NUMBER PATH '$.qty',
                  PT VARCHAR2(2) PATH '$.packType', MN VARCHAR2(100) PATH '$.modelName',
                  MS VARCHAR2(50) PATH '$.modelSuffix', IC VARCHAR2(20) PATH '$.itemCode')) J`,
        namedBinds({ yyyymm, organizationId, userId, adjustJson: json }),
      );
      return { yyyymm, adjusted: rows.length, adjustedQty: rows.reduce((s, r) => s + num(r.remaining), 0) };
    });
  }

  /** 실사표 (박스별 장부 · 실사 · 차이 · 이미 넣은 조정). `status`: diff 차이만 · unscanned 안 센 것만. */
  async list(
    yyyymm: string,
    filter: { status?: string; barcode?: string; modelName?: string },
    organizationId: number,
  ) {
    const where: string[] = [];
    if (filter.status === 'diff') where.push('c.CHECK_QTY <> c.INVENTORY_QTY');
    if (filter.status === 'unscanned') where.push(`c.SCANNED_YN = 'N'`);
    const rows = (await this.dataSource.query(
      `SELECT c.BARCODE AS "barcode", c.LOCATION_CODE AS "locationCode", c.PACK_TYPE AS "packType",
              c.MODEL_NAME AS "modelName", c.MODEL_SUFFIX AS "modelSuffix", c.ITEM_CODE AS "itemCode",
              c.INVENTORY_QTY AS "bookQty", c.CHECK_QTY AS "checkQty",
              c.CHECK_QTY - c.INVENTORY_QTY AS "differenceQty",
              a.POSTED AS "adjustedQty", c.SCANNED_YN AS "scannedYn", c.COMMENTS AS "comments"
         FROM IP_PRODUCT_FG_INV_CHECK c
         LEFT JOIN (${postedSql}) a ON a.BARCODE = c.BARCODE AND a.LOCATION_CODE = c.LOCATION_CODE
        WHERE c.CHECK_YYYYMM = :yyyymm AND c.ORGANIZATION_ID = :organizationId
          AND c.BARCODE LIKE :barcode ESCAPE '\\' AND NVL(c.MODEL_NAME, '*') LIKE :modelName ESCAPE '\\'
          ${where.length ? `AND ${where.join(' AND ')}` : ''}
        ORDER BY CASE WHEN c.CHECK_QTY <> c.INVENTORY_QTY THEN 0 ELSE 1 END, c.MODEL_NAME, c.BARCODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({ yyyymm, organizationId, barcode: likePrefix(filter.barcode?.trim().toUpperCase()), modelName: likePrefix(filter.modelName?.trim().toUpperCase()) }),
    )) as Row[];
    return { data: rows, total: rows.length, truncated: rows.length >= ROW_LIMIT };
  }

  /**
   * 입력 줄마다 후보를 찾는다: 실사표(이 달) → 박스 마스터. 실사표에 있으면 로케이션별로,
   * 없으면 박스 마스터 한 줄이 돌아온다.
   * (JSON_TABLE 은 FROM 으로만 쓴다 — 서브쿼리 안에 넣으면 이 DB 에서 ORA-00600 이 난다.)
   */
  private async resolve(
    qr: QueryRunner,
    input: { rn: number; barcode: string | null }[],
    yyyymm: string,
    organizationId: number,
  ) {
    return (await qr.query(
      `SELECT J.RN AS "rn", J.BC AS "barcode",
              c.LOCATION_CODE AS "checkLocation", c.INVENTORY_QTY AS "bookQty", c.SCANNED_YN AS "scannedYn",
              p.PACK_BARCODE AS "packBarcode", p.PACK_TYPE AS "packType", p.MODEL_NAME AS "modelName",
              p.MODEL_SUFFIX AS "modelSuffix", p.PART_NO AS "itemCode", p.PACKING_PCS_QTY AS "packQty"
         FROM JSON_TABLE(:inputJson, '$[*]' COLUMNS (
                RN NUMBER PATH '$.rn', BC VARCHAR2(200) PATH '$.barcode')) J
         LEFT JOIN IP_PRODUCT_FG_INV_CHECK c
                ON c.CHECK_YYYYMM = :yyyymm AND c.ORGANIZATION_ID = :organizationId AND c.BARCODE = J.BC
         LEFT JOIN IP_PRODUCT_PACK_MASTER p ON p.PACK_BARCODE = J.BC
        ORDER BY J.RN`,
      namedBinds({ inputJson: clobBind(JSON.stringify(input)), yyyymm, organizationId }),
    )) as Row[];
  }
}
