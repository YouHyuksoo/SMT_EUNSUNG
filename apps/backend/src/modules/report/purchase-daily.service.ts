/**
 * @file src/modules/report/purchase-daily.service.ts
 * @description 구매팀 일보 — 원자재 장부 수불 (거래처 묶음별 요약, 품목별 상세)
 *
 * 초보자 가이드:
 * 1. **장부 재고다.** 창고 재고만이 아니라 외주·재공·제품 속에 든 원자재까지 회사 안에 있는
 *    원자재 전체를 본다. 구매팀 엑셀(구매팀 일보 보고.xlsx)의 수불요약·일일수불 시트와 같은 정의다.
 * 2. **기초재고는 저장된 시작값에서 이어 쌓는다.** IM_PURCHASE_BOOK_OPENING 의 기준일(첫 값은
 *    엑셀 일일수불 시트의 2026-10-01 기초) 수량에서, 기준일부터 조회 시작일 전날까지의 입고를 더하고
 *    출고를 빼서 조회 시작일 0시 장부를 만든다. MES 의 재공·완제품 마감만으로는 이 값을 만들 수 없다
 *    (완제품 마감 0건, 재공 마감은 2026-09 부터 0 에서 쌓은 값 — 2026-11-06 대조).
 * 3. **입고누계 = 자재입고(IM_ITEM_RECEIPT, 취소 C 제외)** 수량이다.
 * 4. **출고누계 = 제품출고 수량을 BOM 으로 풀어 원자재로 바꾼 값**이다. 자재출고(창고→라인)가 아니다.
 *    제품출고(IP_PRODUCT_FG_ISSUE)에서 반품(TXN_DEFICIT '4')은 뺀다. BOM(ID_ENG_BOM)은 조회 종료일에
 *    유효한 것을 여러 단계로 풀고, 하위가 없는 품목(원자재)에서 멈춘다.
 *    2026-10-01~14 엑셀 출고와 품목별로 722건 중 573건이 정확히 같았다.
 * 5. **현재고 = 기초 + 입고 − 출고.** 금액 = 수량 × 단가. 단가는 기초 등록 때의 단가(엑셀 단가)를 먼저 쓰고,
 *    기초에 없는 품목만 단가마스터(IM_ITEM_UNIT_PRICE, 품목의 가장 늦은 적용일)를 쓴다.
 *    엑셀 단가와 단가마스터가 다른 품목이 129건 있어 단가마스터를 먼저 쓰면 기초 금액이 엑셀과 어긋난다.
 * 6. **거래처 묶음**은 기초 등록 때의 묶음(BOOK_GROUP: 인팩, 인팩이피엠 …)이고, 기초에 없는 품목은
 *    가장 최근 입고 공급사 이름을 쓴다.
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { namedBinds } from '../../common/utils/named-binds.util';
import { limited } from '../../shared/row-limit';
import { DateRangeReportQueryDto } from './material-report.dto';

/** BOM 전개 깊이 상한. 순환 BOM 이 있어도 멈춘다. */
const MAX_BOM_DEPTH = 10;

export type BomMap = Map<string, Array<{ child: string; qty: number }>>;

/**
 * 제품(또는 반제품) 수량을 BOM 으로 풀어 원자재 수량으로 바꾼다.
 * 하위 BOM 이 없는 품목은 그 자체가 원자재라 그대로 더한다.
 */
export function explodeToMaterials(
  demand: Map<string, number>,
  bom: BomMap,
  into: Map<string, number> = new Map(),
): Map<string, number> {
  const walk = (item: string, qty: number, depth: number) => {
    const kids = bom.get(item);
    if (!kids || kids.length === 0 || depth >= MAX_BOM_DEPTH) {
      into.set(item, (into.get(item) ?? 0) + qty);
      return;
    }
    for (const k of kids) walk(k.child, qty * k.qty, depth + 1);
  };
  for (const [item, qty] of demand) if (qty) walk(item, qty, 0);
  return into;
}

export interface PurchaseDailyDetailRow {
  bookGroup: string;
  itemClass: string | null;
  itemCode: string;
  itemName: string | null;
  itemSpec: string | null;
  unitPrice: number;
  baseQty: number;
  inQty: number;
  outQty: number;
  endQty: number;
  baseAmt: number;
  inAmt: number;
  outAmt: number;
  endAmt: number;
}

export interface PurchaseDailySummaryRow {
  bookGroup: string;
  itemCount: number;
  baseAmt: number;
  inAmt: number;
  outAmt: number;
  endAmt: number;
}

type QtyRow = { itemCode: string; preQty: number | null; qty: number | null };

@Injectable()
export class PurchaseDailyService {
  constructor(private readonly dataSource: DataSource) {}

  private async query<T>(sql: string, binds: Record<string, unknown>): Promise<T[]> {
    return (await this.dataSource.query(sql, namedBinds(binds))) as T[];
  }

  /** 조회 시작일 이전의 가장 늦은 기초 기준일. */
  private async openingDate(dateFrom: string, organizationId: number): Promise<string> {
    const rows = await this.query<{ baseDate: string | null }>(
      `SELECT TO_CHAR(MAX(BASE_DATE), 'YYYY-MM-DD') AS "baseDate"
         FROM IM_PURCHASE_BOOK_OPENING
        WHERE ORGANIZATION_ID = :organizationId
          AND BASE_DATE <= TO_DATE(:dateFrom, 'YYYY-MM-DD')`,
      { organizationId, dateFrom },
    );
    const baseDate = rows[0]?.baseDate;
    if (!baseDate) {
      throw new BadRequestException(`${dateFrom} 이전에 등록된 장부 기초재고가 없습니다.`);
    }
    return baseDate;
  }

  private async bom(dateTo: string, organizationId: number): Promise<BomMap> {
    const rows = await this.query<{ parent: string; child: string; qty: number | null }>(
      `SELECT PARENT_ITEM_CODE AS "parent", CHILD_ITEM_CODE AS "child", ITEM_UNIT_QTY AS "qty"
         FROM ID_ENG_BOM
        WHERE ORGANIZATION_ID = :organizationId
          AND DATESET <= TO_DATE(:dateTo, 'YYYY-MM-DD')
          AND DATEEND >= TO_DATE(:dateTo, 'YYYY-MM-DD')`,
      { organizationId, dateTo },
    );
    const map: BomMap = new Map();
    for (const r of rows) {
      const list = map.get(r.parent) ?? [];
      list.push({ child: r.child, qty: Number(r.qty ?? 0) });
      map.set(r.parent, list);
    }
    return map;
  }

  /** 품목별 [기준일, 시작일) 과 [시작일, 종료일] 수량. */
  private periodSplit(dateColumn: string) {
    return `SUM(CASE WHEN ${dateColumn} <  TO_DATE(:dateFrom, 'YYYY-MM-DD') THEN %Q ELSE 0 END) AS "preQty",
            SUM(CASE WHEN ${dateColumn} >= TO_DATE(:dateFrom, 'YYYY-MM-DD') THEN %Q ELSE 0 END) AS "qty"`;
  }

  /** 장부 상세 — 품목마다 한 줄. */
  async findDetail(
    query: DateRangeReportQueryDto & { bookGroup?: string },
    organizationId: number,
  ) {
    const rows = await this.buildRows(query, organizationId);
    const filtered = query.bookGroup ? rows.filter((r) => r.bookGroup === query.bookGroup) : rows;
    return limited(filtered);
  }

  /** 거래처 묶음별 요약. 금액은 원 단위이고 백만 원 환산은 화면이 한다. */
  async findSummary(query: DateRangeReportQueryDto, organizationId: number) {
    const rows = await this.buildRows(query, organizationId);
    const groups = new Map<string, PurchaseDailySummaryRow>();
    for (const r of rows) {
      const g = groups.get(r.bookGroup) ?? {
        bookGroup: r.bookGroup, itemCount: 0, baseAmt: 0, inAmt: 0, outAmt: 0, endAmt: 0,
      };
      g.itemCount += 1;
      g.baseAmt += r.baseAmt;
      g.inAmt += r.inAmt;
      g.outAmt += r.outAmt;
      g.endAmt += r.endAmt;
      groups.set(r.bookGroup, g);
    }
    const data = [...groups.values()].sort((a, b) => b.endAmt - a.endAmt);
    return { data, total: data.length, truncated: false };
  }

  private async buildRows(
    query: DateRangeReportQueryDto,
    organizationId: number,
  ): Promise<PurchaseDailyDetailRow[]> {
    if (query.dateFrom > query.dateTo) throw new BadRequestException('시작일이 종료일보다 늦습니다.');
    const baseDate = await this.openingDate(query.dateFrom, organizationId);
    const window = { organizationId, baseDate, dateFrom: query.dateFrom, dateTo: query.dateTo };
    const inWindow = (col: string) =>
      `${col} >= TO_DATE(:baseDate, 'YYYY-MM-DD') AND ${col} < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1`;

    const [opening, receipts, shipments, bom] = await Promise.all([
      this.query<{ itemCode: string; qty: number; bookGroup: string | null; itemClass: string | null; unitPrice: number | null }>(
        `SELECT ITEM_CODE AS "itemCode", OPENING_QTY AS "qty", BOOK_GROUP AS "bookGroup",
                ITEM_CLASS AS "itemClass", UNIT_PRICE AS "unitPrice"
           FROM IM_PURCHASE_BOOK_OPENING
          WHERE ORGANIZATION_ID = :organizationId AND BASE_DATE = TO_DATE(:baseDate, 'YYYY-MM-DD')`,
        { organizationId, baseDate },
      ),
      this.query<QtyRow>(
        `SELECT ITEM_CODE AS "itemCode", ${this.periodSplit('RECEIPT_DATE').replace(/%Q/g, 'RECEIPT_QTY')}
           FROM IM_ITEM_RECEIPT
          WHERE ORGANIZATION_ID = :organizationId AND RECEIPT_STATUS <> 'C' AND ${inWindow('RECEIPT_DATE')}
          GROUP BY ITEM_CODE`,
        { ...window },
      ),
      this.query<QtyRow>(
        `SELECT ITEM_CODE AS "itemCode",
                ${this.periodSplit('ISSUE_DATE').replace(/%Q/g, "CASE WHEN TXN_DEFICIT = '4' THEN -QTY ELSE QTY END")}
           FROM IP_PRODUCT_FG_ISSUE
          WHERE ORGANIZATION_ID = :organizationId AND ${inWindow('ISSUE_DATE')}
          GROUP BY ITEM_CODE`,
        { ...window },
      ),
      this.bom(query.dateTo, organizationId),
    ]);

    const preShip = new Map<string, number>();
    const curShip = new Map<string, number>();
    for (const s of shipments) {
      preShip.set(s.itemCode, Number(s.preQty ?? 0));
      curShip.set(s.itemCode, Number(s.qty ?? 0));
    }
    const preOut = explodeToMaterials(preShip, bom);
    const curOut = explodeToMaterials(curShip, bom);

    const preIn = new Map(receipts.map((r) => [r.itemCode, Number(r.preQty ?? 0)]));
    const curIn = new Map(receipts.map((r) => [r.itemCode, Number(r.qty ?? 0)]));
    const openMap = new Map(opening.map((o) => [o.itemCode, o]));

    const items = new Set<string>([...openMap.keys(), ...preIn.keys(), ...curIn.keys(), ...preOut.keys(), ...curOut.keys()]);

    // 이름·단가·최근 입고 공급사는 품목 집합 전체를 한 번에 읽는다 (원장이 작아 IN 목록보다 단순하다).
    const [names, prices, lastSuppliers] = await Promise.all([
      this.query<{ itemCode: string; itemName: string | null; itemSpec: string | null }>(
        `SELECT ITEM_CODE AS "itemCode", ITEM_NAME AS "itemName", ITEM_SPEC AS "itemSpec"
           FROM ID_ITEM WHERE ORGANIZATION_ID = :organizationId`,
        { organizationId },
      ),
      this.query<{ itemCode: string; unitPrice: number | null }>(
        `SELECT ITEM_CODE AS "itemCode", MAX(UNIT_PRICE) KEEP (DENSE_RANK LAST ORDER BY DATESET) AS "unitPrice"
           FROM IM_ITEM_UNIT_PRICE WHERE ORGANIZATION_ID = :organizationId GROUP BY ITEM_CODE`,
        { organizationId },
      ),
      this.query<{ itemCode: string; supplierName: string | null }>(
        `SELECT r.ITEM_CODE AS "itemCode",
                MAX(NVL(s.SUPPLIER_NAME, r.SUPPLIER_CODE)) KEEP (DENSE_RANK LAST ORDER BY r.RECEIPT_DATE) AS "supplierName"
           FROM IM_ITEM_RECEIPT r
           LEFT JOIN ICOM_SUPPLIER s ON s.SUPPLIER_CODE = r.SUPPLIER_CODE AND s.ORGANIZATION_ID = r.ORGANIZATION_ID
          WHERE r.ORGANIZATION_ID = :organizationId AND r.RECEIPT_STATUS <> 'C'
            AND r.RECEIPT_DATE >= ADD_MONTHS(TO_DATE(:dateTo, 'YYYY-MM-DD'), -12)
          GROUP BY r.ITEM_CODE`,
        { organizationId, dateTo: query.dateTo },
      ),
    ]);
    const nameMap = new Map(names.map((n) => [n.itemCode, n]));
    const priceMap = new Map(prices.map((p) => [p.itemCode, p.unitPrice]));
    const supplierMap = new Map(lastSuppliers.map((s) => [s.itemCode, s.supplierName]));

    const rows: PurchaseDailyDetailRow[] = [];
    for (const itemCode of items) {
      const open = openMap.get(itemCode);
      const baseQty = Number(open?.qty ?? 0) + (preIn.get(itemCode) ?? 0) - (preOut.get(itemCode) ?? 0);
      const inQty = curIn.get(itemCode) ?? 0;
      const outQty = curOut.get(itemCode) ?? 0;
      if (!open && baseQty === 0 && inQty === 0 && outQty === 0) continue;
      const endQty = baseQty + inQty - outQty;
      const unitPrice = Number(open?.unitPrice ?? priceMap.get(itemCode) ?? 0);
      const name = nameMap.get(itemCode);
      rows.push({
        bookGroup: open?.bookGroup ?? supplierMap.get(itemCode) ?? '미분류',
        itemClass: open?.itemClass ?? null,
        itemCode,
        itemName: name?.itemName ?? null,
        itemSpec: name?.itemSpec ?? null,
        unitPrice,
        baseQty,
        inQty,
        outQty,
        endQty,
        baseAmt: baseQty * unitPrice,
        inAmt: inQty * unitPrice,
        outAmt: outQty * unitPrice,
        endAmt: endQty * unitPrice,
      });
    }
    return rows.sort((a, b) => a.bookGroup.localeCompare(b.bookGroup, 'ko') || a.itemCode.localeCompare(b.itemCode));
  }
}
