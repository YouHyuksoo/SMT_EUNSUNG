/**
 * @file src/modules/inventory-query/stocktake.service.ts
 * @description 자재 바코드 실사 — 실사 시작(장부 고정) · 바코드 스캔 · 일괄 조정
 *
 * 초보자 가이드:
 * 1. **바코드 1장 = 롯트 1개 = 재고 1행이다** (실측: 바코드 193만 장, 롯트도 193만 개,
 *    재고가 있는 롯트 4,723개 중 4,715개는 바코드 수량과 재고 수량이 같다).
 *    그래서 실사는 "창고에 있는 바코드를 전부 찍는 것" 이고, 찍힌 롯트는 있는 것,
 *    안 찍힌 롯트는 없는 것으로 본다.
 * 2. **흐름**
 *    ① 실사 시작: 그 순간의 장부(`IM_ITEM_INVENTORY` 재고 ≠ 0 인 롯트)를 실사표
 *       (`IM_ITEM_INVENTORY_CHECK`)에 고정한다. 실사수량은 0 으로 시작한다.
 *    ② 스캔: 바코드를 찍으면 스캔 기록(`IM_ITEM_INVENTORY_CHECK_BCD`)을 남기고 실사표의
 *       그 롯트 실사수량을 바코드 수량으로 채운다. 장부에 없던 롯트는 장부 0 으로 추가된다.
 *    ③ 일괄 조정: 실사표의 차이(실사 − 장부)를 조정 출고(M009)로 넣는다. 이미 넣은
 *       조정만큼은 빼고 넣으므로 다시 눌러도 두 번 들어가지 않는다.
 * 3. 실사 중에는 입출고를 멈춘다 — 장부는 ① 시점에 고정되기 때문이다.
 * 4. 조정 날짜는 그 달 마지막 날이다(`postAdjustment`). 마감된 달은 시작·스캔·조정 모두 거절한다.
 * 5. **엑셀 업로드**(`upload`)는 스캔을 한꺼번에 하는 것이다. 한 줄 = 바코드 또는 롯트번호 하나.
 *    이미 찍은 롯트는 엑셀 수량으로 고친다 — 같은 파일을 다시 올려도 결과가 같다.
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource, QueryRunner } from 'typeorm';
import { TransactionService } from '../../shared/transaction.service';
import { clobBind } from '../../common/services/oracle.service';
import { namedBinds } from '../../common/utils/named-binds.util';
import { assertMonthOpen, postAdjustment } from './inventory-check.service';

type Row = Record<string, unknown>;

const num = (v: unknown) => Number(v ?? 0);

/** 엑셀 한 줄. 바코드나 롯트번호 중 하나는 있어야 한다. 수량을 비우면 바코드 수량. */
export interface StocktakeUploadRow {
  /** 엑셀 줄 번호 (오류 보고용) */
  row?: number;
  barcode?: string;
  lotNo?: string;
  itemCode?: string;
  qty?: number;
}

/** 업로드 한 번에 받는 최대 줄 수 (재고 롯트가 5천 개 안쪽이다). */
export const UPLOAD_MAX_ROWS = 20_000;

/** 업로드에서 반영하지 않은 줄 */
export interface UploadError {
  row: number;
  value: string;
  reason: string;
}

/**
 * 찾아온 바코드와 입력 줄을 맞춰 반영할 줄과 오류 줄로 나눈다.
 * 오류: 바코드·롯트 없음 / 등록 안 된 바코드 / 수량이 음수·숫자 아님 / 파일 안 롯트 중복.
 */
export function classifyUploadRows(
  input: { rn: number; barcode: string | null; lotNo: string | null; qty: number | null }[],
  resolved: Record<string, unknown>[],
) {
  const byRn = new Map(resolved.map((r) => [num(r.rn), r]));
  const errors: UploadError[] = [];
  const seen = new Set<string>();
  const accepted: {
    barcode: string; itemCode: string; lotNo: string; qty: number; labelType: string | null; origin: string;
    bookQty: number; price: number; locationCode: string;
  }[] = [];
  for (const src of input) {
    const r = byRn.get(src.rn);
    const value = src.barcode ?? src.lotNo ?? '';
    if (!src.barcode && !src.lotNo) { errors.push({ row: src.rn, value, reason: '바코드·롯트번호가 비어 있음' }); continue; }
    if (!r?.lotNo) { errors.push({ row: src.rn, value, reason: '등록되지 않은 바코드·롯트' }); continue; }
    if (src.qty !== null && !(Number.isFinite(src.qty) && src.qty >= 0)) {
      errors.push({ row: src.rn, value, reason: '수량이 0 이상의 숫자가 아님' }); continue;
    }
    const key = `${String(r.itemCode)}|${String(r.lotNo)}`;
    if (seen.has(key)) { errors.push({ row: src.rn, value, reason: '파일 안에서 같은 롯트가 겹침' }); continue; }
    seen.add(key);
    accepted.push({
      barcode: String(r.itemBarcode), itemCode: String(r.itemCode), lotNo: String(r.lotNo),
      qty: src.qty ?? num(r.scanQty), labelType: (r.labelType as string) ?? null, origin: value,
      bookQty: num(r.bookQty), price: num(r.price), locationCode: (r.locationCode as string) ?? 'M01',
    });
  }
  return { accepted, errors };
}

/** 실사 시작은 이번 달 또는 지난달만 받는다 (월말 실사가 다음 달 초에 끝나는 경우). */
export function isStocktakeMonthAllowed(yyyymm: string, today = new Date()): boolean {
  const cur = today.getFullYear() * 12 + today.getMonth();
  const y = Number(yyyymm.slice(0, 4));
  const m = Number(yyyymm.slice(4, 6)) - 1;
  const target = y * 12 + m;
  return m >= 0 && m < 12 && (target === cur || target === cur - 1);
}

/**
 * 스캔 기록을 실사표에 반영한다. 롯트별 스캔 수량 합을 실사수량으로 쓰고,
 * 실사표에 없는 롯트(장부에 없던 것)는 장부 0 으로 넣는다. `lotNo` 를 주면 그 롯트만.
 */
const applyScansSql = (oneLot: boolean) => `
  MERGE INTO IM_ITEM_INVENTORY_CHECK c
  USING (
    SELECT b.ITEM_CODE, b.LOT_NO, SUM(NVL(b.BARCODE_QTY, 0)) AS QTY,
           NVL(MAX(v.LINE_TYPE), MAX(i.LINE_TYPE))             AS LINE_TYPE,
           NVL(MAX(v.LOCATION_CODE), NVL(MAX(b.LOCATION_CODE), 'M01')) AS LOCATION_CODE,
           NVL(MAX(v.INVENTORY_PRICE), 0)                      AS PRICE
      FROM IM_ITEM_INVENTORY_CHECK_BCD b
      LEFT JOIN IM_ITEM_INVENTORY v
             ON v.MATERIAL_MFS = b.LOT_NO AND v.ITEM_CODE = b.ITEM_CODE
            AND v.ORGANIZATION_ID = b.ORGANIZATION_ID
      LEFT JOIN ID_ITEM i
             ON i.ITEM_CODE = b.ITEM_CODE AND i.ORGANIZATION_ID = b.ORGANIZATION_ID
     WHERE b.CHECK_YYYYMM = :yyyymm
       AND b.ORGANIZATION_ID = :organizationId
       ${oneLot ? 'AND b.LOT_NO = :lotNo' : ''}
     GROUP BY b.ITEM_CODE, b.LOT_NO
  ) s
  ON (c.CLOSE_YYYYMM = :yyyymm AND c.ORGANIZATION_ID = :organizationId
      AND c.ITEM_CODE = s.ITEM_CODE AND c.MATERIAL_MFS = s.LOT_NO)
  WHEN MATCHED THEN UPDATE
       SET c.CHECK_INVENTORY_QTY = s.QTY, c.LAST_MODIFY_DATE = SYSDATE, c.LAST_MODIFY_BY = :userId
  WHEN NOT MATCHED THEN INSERT
       (CLOSE_YYYYMM, ITEM_CODE, LINE_TYPE, MATERIAL_MFS, ORGANIZATION_ID, INVENTORY_HOLD,
        INVENTORY_PRICE, INVENTORY_QTY, CHECK_INVENTORY_QTY, INVENTORY_AMT, LOCATION_CODE,
        COMMENTS, ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
       VALUES (:yyyymm, s.ITEM_CODE, s.LINE_TYPE, s.LOT_NO, :organizationId, 'N',
        s.PRICE, 0, s.QTY, 0, s.LOCATION_CODE,
        '장부에 없던 롯트', SYSDATE, :userId, SYSDATE, :userId)`;

@Injectable()
export class StocktakeService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  /** 진행 중인 실사 — 실사표가 있고 마감되지 않은 가장 최근 달. 없으면 null. */
  async active(organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT c.CLOSE_YYYYMM AS "yyyymm",
              COUNT(*) AS "lots",
              SUM(CASE WHEN c.INVENTORY_QTY <> 0 THEN 1 ELSE 0 END) AS "bookLots",
              SUM(CASE WHEN NVL(c.CHECK_INVENTORY_QTY, 0) <> 0 THEN 1 ELSE 0 END) AS "countedLots",
              SUM(CASE WHEN NVL(c.CHECK_INVENTORY_QTY, 0) = NVL(c.INVENTORY_QTY, 0) THEN 1 ELSE 0 END) AS "matchedLots",
              SUM(CASE WHEN NVL(c.CHECK_INVENTORY_QTY, 0) < NVL(c.INVENTORY_QTY, 0) THEN 1 ELSE 0 END) AS "shortLots",
              SUM(CASE WHEN NVL(c.CHECK_INVENTORY_QTY, 0) > NVL(c.INVENTORY_QTY, 0) THEN 1 ELSE 0 END) AS "overLots",
              TO_CHAR(MIN(c.ENTER_DATE), 'YYYY-MM-DD HH24:MI') AS "startedAt"
         FROM IM_ITEM_INVENTORY_CHECK c
        WHERE c.ORGANIZATION_ID = :organizationId
          AND NOT EXISTS (SELECT 1 FROM ISYS_INVENTORY_CLOSE_DATE d
                           WHERE d.CLOSE_YYYYMM = c.CLOSE_YYYYMM
                             AND d.ORGANIZATION_ID = c.ORGANIZATION_ID AND d.CLOSE_YN = 'Y')
        GROUP BY c.CLOSE_YYYYMM
        ORDER BY c.CLOSE_YYYYMM DESC
        FETCH FIRST 1 ROWS ONLY`,
      namedBinds({ organizationId }),
    )) as Row[];
    const r = rows[0];
    if (!r) return null;
    return {
      yyyymm: String(r.yyyymm),
      lots: num(r.lots),
      bookLots: num(r.bookLots),
      countedLots: num(r.countedLots),
      matchedLots: num(r.matchedLots),
      shortLots: num(r.shortLots),
      overLots: num(r.overLots),
      startedAt: (r.startedAt as string) ?? null,
    };
  }

  /**
   * 실사 시작 — 지금 장부를 실사표에 고정한다. 이미 시작한 달은 `regenerate` 일 때만
   * 장부를 다시 고정하고, 그동안 찍은 스캔은 지우지 않고 다시 반영한다.
   */
  async start(yyyymm: string, regenerate: boolean, organizationId: number, userId: string) {
    if (!isStocktakeMonthAllowed(yyyymm)) {
      throw new BadRequestException('실사는 이번 달 또는 지난달만 시작할 수 있습니다.');
    }
    return this.tx.run(async (qr) => {
      await assertMonthOpen(qr, yyyymm, organizationId);
      const exists = num(((await qr.query(
        `SELECT COUNT(*) AS "n" FROM IM_ITEM_INVENTORY_CHECK
          WHERE CLOSE_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ yyyymm, organizationId }),
      )) as Row[])[0]?.n);
      if (exists && !regenerate) {
        throw new BadRequestException(`${yyyymm} 실사는 이미 시작했습니다.`);
      }
      const adjusted = num(((await qr.query(
        `SELECT COUNT(*) AS "n" FROM IM_ITEM_ISSUE
          WHERE ISSUE_ACCOUNT = 'M009' AND ORGANIZATION_ID = :organizationId
            AND ISSUE_DATE >= TO_DATE(:yyyymm || '01', 'YYYYMMDD')
            AND ISSUE_DATE <  ADD_MONTHS(TO_DATE(:yyyymm || '01', 'YYYYMMDD'), 1)`,
        namedBinds({ yyyymm, organizationId }),
      )) as Row[])[0]?.n);
      if (adjusted) {
        // 조정이 들어간 뒤 장부를 다시 고정하면 조정이 차이에서 빠져 두 번 조정된다.
        throw new BadRequestException(
          `${yyyymm} 은 이미 조정이 ${adjusted}건 들어가 장부를 다시 고정할 수 없습니다.`,
        );
      }
      await qr.query(
        `DELETE FROM IM_ITEM_INVENTORY_CHECK
          WHERE CLOSE_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ yyyymm, organizationId }),
      );
      await qr.query(
        `INSERT INTO IM_ITEM_INVENTORY_CHECK
           (CLOSE_YYYYMM, ITEM_CODE, LINE_TYPE, MATERIAL_MFS, ORGANIZATION_ID, INVENTORY_HOLD,
            INVENTORY_PRICE, INVENTORY_QTY, CHECK_INVENTORY_QTY, INVENTORY_AMT, LOCATION_CODE,
            COMMENTS, ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
         SELECT :yyyymm, v.ITEM_CODE, v.LINE_TYPE, v.MATERIAL_MFS, v.ORGANIZATION_ID,
                NVL(v.INVENTORY_HOLD, 'N'), v.INVENTORY_PRICE, v.INVENTORY_QTY, 0,
                v.INVENTORY_AMT, NVL(v.LOCATION_CODE, 'M01'), NULL,
                SYSDATE, :userId, SYSDATE, :userId
           FROM IM_ITEM_INVENTORY v
          WHERE v.ORGANIZATION_ID = :organizationId
            AND v.INVENTORY_QTY <> 0`,
        namedBinds({ yyyymm, organizationId, userId }),
      );
      await qr.query(applyScansSql(false), namedBinds({ yyyymm, organizationId, userId }));
      return { yyyymm, lots: await this.countLots(qr, yyyymm, organizationId) };
    });
  }

  /**
   * 바코드 스캔 — 진행 중인 실사월에 기록한다. `qty` 를 주면 바코드 수량 대신 그 수량으로
   * 센다 (일부 쓴 릴·벌크 라벨).
   */
  async scan(barcode: string, qty: number | undefined, organizationId: number, userId: string) {
    const code = barcode.trim().toUpperCase();
    if (code.length < 10) throw new BadRequestException('바코드가 너무 짧습니다.');
    if (qty !== undefined && !(Number.isFinite(qty) && qty >= 0)) {
      throw new BadRequestException('수량은 0 이상이어야 합니다.');
    }
    const session = await this.active(organizationId);
    if (!session) throw new BadRequestException('진행 중인 실사가 없습니다. 자재재고조사에서 실사를 시작하세요.');
    const yyyymm = session.yyyymm;

    return this.tx.run(async (qr) => {
      await assertMonthOpen(qr, yyyymm, organizationId);
      const label = ((await qr.query(
        `SELECT * FROM (
           SELECT b.ITEM_BARCODE AS "itemBarcode", b.ITEM_CODE AS "itemCode", b.LOT_NO AS "lotNo",
                  b.SCAN_QTY AS "scanQty", b.LABEL_TYPE AS "labelType", b.LOCATION_CODE AS "locationCode",
                  1 AS "rank"
             FROM IM_ITEM_RECEIPT_BARCODE b
            WHERE b.ITEM_BARCODE = :code AND b.ORGANIZATION_ID = :organizationId
           UNION ALL
           SELECT b.ITEM_BARCODE, b.ITEM_CODE, b.LOT_NO, b.SCAN_QTY, b.LABEL_TYPE, b.LOCATION_CODE, 2
             FROM IM_ITEM_RECEIPT_BARCODE b
            WHERE b.LOT_NO = F_GET_LOT_NO_FROM_BARCODE(:code)
              AND b.ITEM_CODE = F_GET_ITEM_CODE_FROM_BARCODE(:code)
              AND b.ORGANIZATION_ID = :organizationId)
         ORDER BY "rank" FETCH FIRST 1 ROWS ONLY`,
        namedBinds({ code, organizationId }),
      )) as Row[])[0];
      if (!label) throw new BadRequestException(`등록되지 않은 바코드입니다: ${code}`);
      const itemCode = String(label.itemCode);
      const lotNo = String(label.lotNo);

      const dup = ((await qr.query(
        `SELECT ITEM_BARCODE AS "itemBarcode" FROM IM_ITEM_INVENTORY_CHECK_BCD
          WHERE CHECK_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId
            AND ITEM_CODE = :itemCode AND LOT_NO = :lotNo`,
        namedBinds({ yyyymm, organizationId, itemCode, lotNo }),
      )) as Row[])[0];
      if (dup) throw new BadRequestException(`이미 찍은 바코드입니다: ${lotNo}`);

      const book = ((await qr.query(
        `SELECT v.INVENTORY_QTY AS "qty", v.INVENTORY_PRICE AS "price", v.LOCATION_CODE AS "locationCode"
           FROM IM_ITEM_INVENTORY v
          WHERE v.MATERIAL_MFS = :lotNo AND v.ITEM_CODE = :itemCode AND v.ORGANIZATION_ID = :organizationId`,
        namedBinds({ lotNo, itemCode, organizationId }),
      )) as Row[])[0];
      const countedQty = qty ?? num(label.scanQty);

      await qr.query(
        `INSERT INTO IM_ITEM_INVENTORY_CHECK_BCD
           (CHECK_YYYYMM, ITEM_BARCODE, ITEM_CODE, LOT_NO, ORIGIN_ITEM_BARCODE, BARCODE_QTY,
            INVENTORY_QTY, LABEL_TYPE, CHECK_TYPE, LOCATION_CODE, UNIT_PRICE, INVENTORY_AMT,
            ORGANIZATION_ID, ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE)
         VALUES (:yyyymm, :itemBarcode, :itemCode, :lotNo, :code, :countedQty,
            :bookQty, :labelType, '3', :locationCode, :price, :countedQty * :price,
            :organizationId, :userId, SYSDATE, :userId, SYSDATE)`,
        namedBinds({
          yyyymm,
          itemBarcode: String(label.itemBarcode),
          itemCode,
          lotNo,
          code,
          countedQty,
          bookQty: num(book?.qty),
          labelType: (label.labelType as string) ?? null,
          locationCode: (book?.locationCode as string) ?? (label.locationCode as string) ?? 'M01',
          price: num(book?.price),
          organizationId,
          userId,
        }),
      );
      await qr.query(applyScansSql(true), namedBinds({ yyyymm, organizationId, userId, lotNo }));
      return this.lotResult(qr, yyyymm, itemCode, lotNo, organizationId);
    });
  }

  /**
   * 엑셀 업로드 — 여러 줄을 한 트랜잭션으로 스캔한다. 찾지 못한 줄·수량이 틀린 줄·파일 안에서
   * 같은 롯트가 겹친 줄은 반영하지 않고 줄 번호와 함께 돌려준다. 나머지는 반영한다.
   */
  async upload(rows: StocktakeUploadRow[], organizationId: number, userId: string) {
    if (!rows.length) throw new BadRequestException('올릴 줄이 없습니다.');
    if (rows.length > UPLOAD_MAX_ROWS) {
      throw new BadRequestException(`한 번에 ${UPLOAD_MAX_ROWS.toLocaleString()}줄까지 올릴 수 있습니다.`);
    }
    const session = await this.active(organizationId);
    if (!session) throw new BadRequestException('진행 중인 실사가 없습니다. 실사를 먼저 시작하세요.');
    const yyyymm = session.yyyymm;

    const input = rows.map((r, i) => ({
      rn: r.row ?? i + 1,
      barcode: r.barcode?.trim().toUpperCase() || null,
      lotNo: r.lotNo?.trim().toUpperCase() || null,
      itemCode: r.itemCode?.trim().toUpperCase() || null,
      qty: r.qty === undefined ? null : r.qty,
    }));

    return this.tx.run(async (qr) => {
      await assertMonthOpen(qr, yyyymm, organizationId);
      // 줄마다 입고 바코드를 찾는다: 바코드 그대로 → 롯트번호 → 바코드에서 뽑은 롯트·품목 순.
      const resolved = (await qr.query(
        `SELECT J.RN AS "rn", B.ITEM_BARCODE AS "itemBarcode", B.ITEM_CODE AS "itemCode",
                B.LOT_NO AS "lotNo", B.SCAN_QTY AS "scanQty", B.LABEL_TYPE AS "labelType",
                V.BOOK AS "bookQty", V.PRICE AS "price", V.LOC AS "locationCode"
           FROM JSON_TABLE(:uploadJson, '$[*]' COLUMNS (
                  RN NUMBER PATH '$.rn', BC VARCHAR2(200) PATH '$.barcode',
                  LOT VARCHAR2(60) PATH '$.lotNo', ITEM VARCHAR2(30) PATH '$.itemCode')) J
           OUTER APPLY (
             SELECT * FROM (
               SELECT b.ITEM_BARCODE, b.ITEM_CODE, b.LOT_NO, b.SCAN_QTY, b.LABEL_TYPE, 1 AS RK
                 FROM IM_ITEM_RECEIPT_BARCODE b
                WHERE J.BC IS NOT NULL AND b.ITEM_BARCODE = J.BC AND b.ORGANIZATION_ID = :organizationId
               UNION ALL
               SELECT b.ITEM_BARCODE, b.ITEM_CODE, b.LOT_NO, b.SCAN_QTY, b.LABEL_TYPE, 2
                 FROM IM_ITEM_RECEIPT_BARCODE b
                WHERE J.LOT IS NOT NULL AND b.LOT_NO = J.LOT
                  AND (J.ITEM IS NULL OR b.ITEM_CODE = J.ITEM) AND b.ORGANIZATION_ID = :organizationId
               UNION ALL
               SELECT b.ITEM_BARCODE, b.ITEM_CODE, b.LOT_NO, b.SCAN_QTY, b.LABEL_TYPE, 3
                 FROM IM_ITEM_RECEIPT_BARCODE b
                WHERE J.BC IS NOT NULL AND b.LOT_NO = F_GET_LOT_NO_FROM_BARCODE(J.BC)
                  AND b.ITEM_CODE = F_GET_ITEM_CODE_FROM_BARCODE(J.BC) AND b.ORGANIZATION_ID = :organizationId
             ) ORDER BY RK FETCH FIRST 1 ROWS ONLY) B
           OUTER APPLY (
             SELECT MAX(v.INVENTORY_QTY) AS BOOK, MAX(v.INVENTORY_PRICE) AS PRICE, MAX(v.LOCATION_CODE) AS LOC
               FROM IM_ITEM_INVENTORY v
              WHERE v.MATERIAL_MFS = B.LOT_NO AND v.ITEM_CODE = B.ITEM_CODE
                AND v.ORGANIZATION_ID = :organizationId) V
          ORDER BY J.RN`,
        namedBinds({ uploadJson: clobBind(JSON.stringify(input)), organizationId }),
      )) as Row[];

      const { accepted, errors } = classifyUploadRows(input, resolved);
      if (!accepted.length) return { yyyymm, applied: 0, updated: 0, errors };

      const acceptedJson = JSON.stringify(accepted);
      // 이미 찍은 롯트 수. JSON_TABLE 을 IN 서브쿼리에 넣으면 이 DB 에서 ORA-00600 이 나 JS 로 센다.
      const scanned = new Set(((await qr.query(
        `SELECT ITEM_CODE || '|' || LOT_NO AS "k" FROM IM_ITEM_INVENTORY_CHECK_BCD
          WHERE CHECK_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ yyyymm, organizationId }),
      )) as Row[]).map((r) => String(r.k)));
      const updated = accepted.filter((x) => scanned.has(`${x.itemCode}|${x.lotNo}`)).length;

      await qr.query(
        `MERGE INTO IM_ITEM_INVENTORY_CHECK_BCD t
         USING (
           SELECT J.BC, J.ITEM, J.LOT, J.QTY, J.LABEL, J.ORIG, J.BOOK, J.PRICE, J.LOC
             FROM JSON_TABLE(:acceptedJson, '$[*]' COLUMNS (
                    BC VARCHAR2(200) PATH '$.barcode', ITEM VARCHAR2(30) PATH '$.itemCode',
                    LOT VARCHAR2(60) PATH '$.lotNo', QTY NUMBER PATH '$.qty',
                    LABEL VARCHAR2(10) PATH '$.labelType', ORIG VARCHAR2(200) PATH '$.origin',
                    BOOK NUMBER PATH '$.bookQty', PRICE NUMBER PATH '$.price',
                    LOC VARCHAR2(30) PATH '$.locationCode')) J
         ) s
         ON (t.CHECK_YYYYMM = :yyyymm AND t.ORGANIZATION_ID = :organizationId
             AND t.ITEM_CODE = s.ITEM AND t.LOT_NO = s.LOT)
         WHEN MATCHED THEN UPDATE
              SET t.BARCODE_QTY = s.QTY, t.INVENTORY_AMT = s.QTY * NVL(s.PRICE, 0),
                  t.LAST_MODIFY_BY = :userId, t.LAST_MODIFY_DATE = SYSDATE
         WHEN NOT MATCHED THEN INSERT
              (CHECK_YYYYMM, ITEM_BARCODE, ITEM_CODE, LOT_NO, ORIGIN_ITEM_BARCODE, BARCODE_QTY,
               INVENTORY_QTY, LABEL_TYPE, CHECK_TYPE, LOCATION_CODE, UNIT_PRICE, INVENTORY_AMT,
               ORGANIZATION_ID, ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE)
              VALUES (:yyyymm, s.BC, s.ITEM, s.LOT, s.ORIG, s.QTY,
               NVL(s.BOOK, 0), s.LABEL, '3', NVL(s.LOC, 'M01'), NVL(s.PRICE, 0), s.QTY * NVL(s.PRICE, 0),
               :organizationId, :userId, SYSDATE, :userId, SYSDATE)`,
        namedBinds({ yyyymm, organizationId, userId, acceptedJson: clobBind(acceptedJson) }),
      );
      await qr.query(applyScansSql(false), namedBinds({ yyyymm, organizationId, userId }));
      return { yyyymm, applied: accepted.length, updated, errors };
    });
  }

  /** 스캔 취소 — 그 바코드의 스캔 기록을 지우고 실사수량을 다시 계산한다. */
  async cancelScan(barcode: string, organizationId: number, userId: string) {
    const code = barcode.trim().toUpperCase();
    const session = await this.active(organizationId);
    if (!session) throw new BadRequestException('진행 중인 실사가 없습니다.');
    const yyyymm = session.yyyymm;

    return this.tx.run(async (qr) => {
      await assertMonthOpen(qr, yyyymm, organizationId);
      const hit = ((await qr.query(
        `SELECT ITEM_CODE AS "itemCode", LOT_NO AS "lotNo" FROM IM_ITEM_INVENTORY_CHECK_BCD
          WHERE CHECK_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId
            AND (ITEM_BARCODE = :code OR ORIGIN_ITEM_BARCODE = :code)`,
        namedBinds({ yyyymm, organizationId, code }),
      )) as Row[])[0];
      if (!hit) throw new BadRequestException(`이 실사에서 찍은 적이 없는 바코드입니다: ${code}`);
      const itemCode = String(hit.itemCode);
      const lotNo = String(hit.lotNo);
      await qr.query(
        `DELETE FROM IM_ITEM_INVENTORY_CHECK_BCD
          WHERE CHECK_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId
            AND ITEM_CODE = :itemCode AND LOT_NO = :lotNo`,
        namedBinds({ yyyymm, organizationId, itemCode, lotNo }),
      );
      await qr.query(
        `UPDATE IM_ITEM_INVENTORY_CHECK
            SET CHECK_INVENTORY_QTY = 0, LAST_MODIFY_DATE = SYSDATE, LAST_MODIFY_BY = :userId
          WHERE CLOSE_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId
            AND ITEM_CODE = :itemCode AND MATERIAL_MFS = :lotNo`,
        namedBinds({ yyyymm, organizationId, itemCode, lotNo, userId }),
      );
      // 스캔으로만 생긴 줄(장부 0)은 조정이 들어가지 않았으면 지운다.
      await qr.query(
        `DELETE FROM IM_ITEM_INVENTORY_CHECK c
          WHERE c.CLOSE_YYYYMM = :yyyymm AND c.ORGANIZATION_ID = :organizationId
            AND c.ITEM_CODE = :itemCode AND c.MATERIAL_MFS = :lotNo
            AND NVL(c.INVENTORY_QTY, 0) = 0
            AND NOT EXISTS (SELECT 1 FROM IM_ITEM_ISSUE s
                             WHERE s.ISSUE_ACCOUNT = 'M009' AND s.MATERIAL_MFS = c.MATERIAL_MFS
                               AND s.ORGANIZATION_ID = c.ORGANIZATION_ID
                               AND s.ISSUE_DATE >= TO_DATE(:yyyymm || '01', 'YYYYMMDD')
                               AND s.ISSUE_DATE <  ADD_MONTHS(TO_DATE(:yyyymm || '01', 'YYYYMMDD'), 1))`,
        namedBinds({ yyyymm, organizationId, itemCode, lotNo }),
      );
      return { yyyymm, itemCode, lotNo };
    });
  }

  /**
   * 일괄 조정 — 실사표의 차이(실사 − 장부)에서 이미 넣은 조정을 빼고 남은 만큼만 넣는다.
   * 재고 행이 없는 롯트는 넣지 못하므로 건너뛰고 목록으로 돌려준다.
   */
  async adjustAll(yyyymm: string, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      await assertMonthOpen(qr, yyyymm, organizationId);
      const rows = (await qr.query(
        `SELECT c.ITEM_CODE AS "itemCode", c.MATERIAL_MFS AS "lotNo", c.LOCATION_CODE AS "locationCode",
                NVL(c.CHECK_INVENTORY_QTY, 0) - NVL(c.INVENTORY_QTY, 0) AS "diff",
                NVL(a.POSTED, 0) AS "posted"
           FROM IM_ITEM_INVENTORY_CHECK c
           LEFT JOIN (SELECT s.MATERIAL_MFS, s.ITEM_CODE, -SUM(s.ISSUE_QTY) AS POSTED
                        FROM IM_ITEM_ISSUE s
                       WHERE s.ISSUE_ACCOUNT = 'M009' AND s.ORGANIZATION_ID = :organizationId
                         AND s.ISSUE_DATE >= TO_DATE(:yyyymm || '01', 'YYYYMMDD')
                         AND s.ISSUE_DATE <  ADD_MONTHS(TO_DATE(:yyyymm || '01', 'YYYYMMDD'), 1)
                       GROUP BY s.MATERIAL_MFS, s.ITEM_CODE) a
                  ON a.MATERIAL_MFS = c.MATERIAL_MFS AND a.ITEM_CODE = c.ITEM_CODE
          WHERE c.CLOSE_YYYYMM = :yyyymm AND c.ORGANIZATION_ID = :organizationId
            AND NVL(c.CHECK_INVENTORY_QTY, 0) - NVL(c.INVENTORY_QTY, 0) <> NVL(a.POSTED, 0)`,
        namedBinds({ yyyymm, organizationId }),
      )) as Row[];
      if (!rows.length) throw new BadRequestException('조정할 차이가 없습니다.');

      let adjusted = 0;
      const skipped: { itemCode: string; lotNo: string; reason: string }[] = [];
      for (const r of rows) {
        const remaining = num(r.diff) - num(r.posted);
        try {
          await postAdjustment(qr, {
            yyyymm,
            itemCode: String(r.itemCode),
            lotNo: String(r.lotNo),
            differenceQty: remaining,
            locationCode: (r.locationCode as string) ?? undefined,
          }, organizationId, userId);
          adjusted += 1;
        } catch (error: unknown) {
          // 재고 행이 없는 롯트만 건너뛴다 (조회 단계에서 나므로 쓰기 전이다). 그 밖의 오류는 전체 롤백.
          if (error instanceof BadRequestException && /재고를 찾을 수 없습니다/.test(error.message)) {
            skipped.push({ itemCode: String(r.itemCode), lotNo: String(r.lotNo), reason: error.message });
            continue;
          }
          throw error;
        }
      }
      return { yyyymm, adjusted, skipped };
    });
  }

  private async countLots(qr: QueryRunner, yyyymm: string, organizationId: number) {
    return num(((await qr.query(
      `SELECT COUNT(*) AS "n" FROM IM_ITEM_INVENTORY_CHECK
        WHERE CLOSE_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId`,
      namedBinds({ yyyymm, organizationId }),
    )) as Row[])[0]?.n);
  }

  private async lotResult(qr: QueryRunner, yyyymm: string, itemCode: string, lotNo: string, organizationId: number) {
    const r = ((await qr.query(
      `SELECT c.ITEM_CODE AS "itemCode", i.ITEM_NAME AS "itemName", c.MATERIAL_MFS AS "lotNo",
              NVL(c.INVENTORY_QTY, 0) AS "bookQty", NVL(c.CHECK_INVENTORY_QTY, 0) AS "countedQty"
         FROM IM_ITEM_INVENTORY_CHECK c
         LEFT JOIN ID_ITEM i ON i.ITEM_CODE = c.ITEM_CODE AND i.ORGANIZATION_ID = c.ORGANIZATION_ID
        WHERE c.CLOSE_YYYYMM = :yyyymm AND c.ORGANIZATION_ID = :organizationId
          AND c.ITEM_CODE = :itemCode AND c.MATERIAL_MFS = :lotNo`,
      namedBinds({ yyyymm, organizationId, itemCode, lotNo }),
    )) as Row[])[0] ?? {};
    const bookQty = num(r.bookQty);
    const countedQty = num(r.countedQty);
    return {
      yyyymm,
      itemCode,
      itemName: (r.itemName as string) ?? null,
      lotNo,
      bookQty,
      countedQty,
      /** 실사 − 장부 */
      differenceQty: countedQty - bookQty,
    };
  }
}
