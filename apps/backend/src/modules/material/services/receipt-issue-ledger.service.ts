/**
 * @file src/modules/material/services/receipt-issue-ledger.service.ts
 * @description 자재입출고수불원장 조회 서비스 (읽기 전용)
 *
 * 레거시 PowerBuilder `w_mat_ledger_report`의 DataWindow 5종을 옮긴 것이다.
 * SQL 원본 스냅샷: docs/sql/mat-receipt-issue-ledger-legacy.sql
 * 설계: docs/specs/2026-09-16-material-receipt-issue-ledger-design.md
 *
 * 레거시 조인 형태를 그대로 유지한다. ID_ITEM은 ITEM_CODE 단독 조인이고
 * ORGANIZATION_ID를 조인 조건에 넣지 않는다 (레거시 SQL과 동일).
 */

import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import {
  FeederLayoutQueryDto,
  IssueLossQueryDto,
  ReceiptBarcodeQueryDto,
  ReceiptIssueLedgerQueryDto,
  WorkstageLedgerQueryDto,
} from '../dto/receipt-issue-ledger.dto';

type OracleRow = Record<string, unknown>;

interface PagedResult {
  data: OracleRow[];
  total: number;
  page: number;
  limit: number;
}

/** LIKE 필터 기본값. 값이 없으면 전체를 의미하는 '%'를 바인드한다. */
function like(value: string | undefined): string {
  const trimmed = value?.trim();
  return trimmed ? trimmed : '%';
}

@Injectable()
export class ReceiptIssueLedgerService {
  constructor(private readonly dataSource: DataSource) {}

  /** 모드 1 — 수불원장 (IM_ITEM_RECEIPT ∪ IM_ITEM_ISSUE). */
  async findLedger(query: ReceiptIssueLedgerQueryDto, organizationId: number): Promise<PagedResult> {
    const binds: Record<string, unknown> = {
      dateFrom: query.dateFrom,
      dateTo: query.dateTo,
      itemCode: like(query.itemCode),
      lotNo: like(query.lotNo),
      locationCode: like(query.locationCode),
      inventoryType: like(query.inventoryType),
      supplierCode: like(query.supplierCode),
      fromSupplierCode: like(query.fromSupplierCode),
      lineCode: like(query.lineCode),
      workstageCode: like(query.workstageCode),
      supplierIssue: like(query.supplierIssue),
      issueDeficit: like(query.issueDeficit),
      rcvIssCode: like(query.rcvIssCode),
      includeW00: query.includeW00 === 'N' ? 'N' : 'Y',
      excludeEtcLine: query.excludeEtcLine === 'Y' ? 'Y' : 'N',
      organizationId,
    };

    const from = `
      FROM (
        SELECT 'R' AS RCV_ISS_CODE,
               RECEIPT_SEQUENCE AS RECEIPT_ISSUE_SEQUENCE,
               RECEIPT_DATE AS RECEIPT_ISSUE_DATE,
               ORGANIZATION_ID, RECEIPT_DEFICIT AS RECEIPT_ISSUE_DEFICIT, LINE_TYPE,
               RECEIPT_QTY AS QTY, MATERIAL_MFS, UNIT_PRICE AS PRICE, MATERIAL_COST_AMT,
               INVOICE_NO, RECEIPT_AMT AS AMT, SUPPLIER_CODE,
               RECEIPT_TYPE AS RECEIPT_ISSUE_TYPE, RECEIPT_STATUS AS RECEIPT_ISSUE_STATUS,
               ITEM_CODE, ENTER_DATE, BARCODE, FROM_SUPPLIER_CODE,
               '' AS LINE_CODE, '' AS WORKSTAGE_CODE, LOCATION_CODE, ORIGIN_MFS,
               '' AS FEEDER_LOCATION_CODE, '' AS FEEDER_SHAFT, '' AS MODEL_NAME, INVENTORY_TYPE
          FROM IM_ITEM_RECEIPT
         WHERE RECEIPT_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
           AND RECEIPT_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
           AND ITEM_CODE LIKE :itemCode
           AND MATERIAL_MFS LIKE :lotNo
           AND NVL(SUPPLIER_CODE, '*') LIKE :supplierCode
           AND NVL(FROM_SUPPLIER_CODE, '*') LIKE :fromSupplierCode
           AND LOCATION_CODE LIKE :locationCode
           AND NVL(INVENTORY_TYPE, '*') LIKE :inventoryType
           AND ORGANIZATION_ID = :organizationId
        UNION ALL
        SELECT 'I' AS RCV_ISS_CODE,
               ISSUE_SEQUENCE AS RECEIPT_ISSUE_SEQUENCE,
               ISSUE_DATE AS RECEIPT_ISSUE_DATE,
               ORGANIZATION_ID, ISSUE_DEFICIT AS RECEIPT_ISSUE_DEFICIT, LINE_TYPE,
               ISSUE_QTY AS QTY, MATERIAL_MFS, ISSUE_PRICE AS PRICE, 0 AS MATERIAL_COST_AMT,
               '' AS INVOICE_NO, ISSUE_AMT AS AMT, SUPPLIER_CODE,
               ISSUE_TYPE AS RECEIPT_ISSUE_TYPE, ISSUE_STATUS AS RECEIPT_ISSUE_STATUS,
               ITEM_CODE, ENTER_DATE, '' AS BARCODE, '' AS FROM_SUPPLIER_CODE,
               LINE_CODE, WORKSTAGE_CODE, LOCATION_CODE, '' AS ORIGIN_MFS,
               FEEDER_LOCATION_CODE, FEEDER_SHAFT, MODEL_NAME, INVENTORY_TYPE
          FROM IM_ITEM_ISSUE
         WHERE ISSUE_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
           AND ISSUE_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
           AND ITEM_CODE LIKE :itemCode
           AND MATERIAL_MFS LIKE :lotNo
           AND LINE_CODE LIKE :lineCode
           AND WORKSTAGE_CODE LIKE :workstageCode
           AND LOCATION_CODE LIKE :locationCode
           AND NVL(SUPPLIER_CODE, '*') LIKE :supplierIssue
           AND ISSUE_DEFICIT LIKE :issueDeficit
           AND NVL(INVENTORY_TYPE, '*') LIKE :inventoryType
           AND ORGANIZATION_ID = :organizationId
           AND ((:includeW00 = 'Y') OR (:includeW00 = 'N' AND WORKSTAGE_CODE <> 'W00'))
           AND (:excludeEtcLine = 'N' OR LINE_CODE NOT IN (
                 SELECT LINE_CODE FROM IP_PRODUCT_LINE
                  WHERE LINE_DIVISION = 'ETC' AND LINE_CODE IS NOT NULL))
      ) A, ID_ITEM B, IM_ITEM_RECEIPT_BARCODE C
     WHERE A.ITEM_CODE = B.ITEM_CODE
       AND A.ITEM_CODE = C.ITEM_CODE(+)
       AND A.MATERIAL_MFS = C.LOT_NO(+)
       AND A.RCV_ISS_CODE LIKE :rcvIssCode`;

    const select = `
      SELECT A.RCV_ISS_CODE AS "rcvIssCode",
             A.RECEIPT_ISSUE_SEQUENCE AS "receiptIssueSequence",
             A.RECEIPT_ISSUE_DATE AS "receiptIssueDate",
             A.ORGANIZATION_ID AS "organizationId",
             A.RECEIPT_ISSUE_DEFICIT AS "receiptIssueDeficit",
             A.LINE_TYPE AS "lineType",
             A.QTY AS "qty",
             A.MATERIAL_MFS AS "materialMfs",
             A.PRICE AS "price",
             A.MATERIAL_COST_AMT AS "materialCostAmt",
             A.INVOICE_NO AS "invoiceNo",
             A.AMT AS "amt",
             A.SUPPLIER_CODE AS "supplierCode",
             A.RECEIPT_ISSUE_TYPE AS "receiptIssueType",
             A.RECEIPT_ISSUE_STATUS AS "receiptIssueStatus",
             A.ITEM_CODE AS "itemCode",
             B.ITEM_NAME AS "itemName",
             B.ITEM_SPEC AS "itemSpec",
             B.ITEM_UOM AS "itemUom",
             B.LOCATION_ADDRESS AS "locationAddress",
             A.ENTER_DATE AS "enterDate",
             A.BARCODE AS "barcode",
             A.FROM_SUPPLIER_CODE AS "fromSupplierCode",
             A.LINE_CODE AS "lineCode",
             A.WORKSTAGE_CODE AS "workstageCode",
             A.LOCATION_CODE AS "locationCode",
             A.ORIGIN_MFS AS "originMfs",
             A.FEEDER_LOCATION_CODE AS "feederLocationCode",
             A.FEEDER_SHAFT AS "feederShaft",
             A.MODEL_NAME AS "modelName",
             A.INVENTORY_TYPE AS "inventoryType",
             C.LOT_DIVIDE_YN AS "lotDivideYn",
             C.LABEL_TYPE AS "labelType",
             C.RECEIPT_TYPE AS "receiptType",
             C.VENDOR_LOTNO AS "vendorLotno",
             C.VENDOR_CODE AS "vendorCode",
             C.MANUFACTURE_WEEK AS "manufactureWeek",
             C.LED_RANK_INFO AS "ledRankInfo",
             C.FEEDING_DATE AS "feedingDate",
             C.REEL_DESTROY_DATE AS "reelDestroyDate"`;

    const order = `
     ORDER BY A.ORGANIZATION_ID, A.ENTER_DATE, A.RECEIPT_ISSUE_DATE DESC, A.RECEIPT_ISSUE_SEQUENCE DESC`;

    return this.paged(select, from, order, binds, query.page, query.limit);
  }

  /** 모드 2 — 공정 수불원장 (IM_ITEM_WORKSTAGE_RECEIPT ∪ IM_ITEM_WORKSTAGE_ISSUE). */
  async findWorkstageLedger(query: WorkstageLedgerQueryDto, organizationId: number): Promise<PagedResult> {
    const binds: Record<string, unknown> = {
      dateFrom: query.dateFrom,
      dateTo: query.dateTo,
      itemCode: like(query.itemCode),
      rcvIssCode: like(query.rcvIssCode),
      organizationId,
    };

    const from = `
      FROM (
        SELECT 'R' AS RCV_ISS_CODE, RECEIPT_SEQUENCE AS RECEIPT_ISSUE_SEQUENCE,
               RECEIPT_DATE AS RECEIPT_ISSUE_DATE, ORGANIZATION_ID,
               RECEIPT_DEFICIT AS RECEIPT_ISSUE_DEFICIT, RECEIPT_QTY AS QTY,
               ITEM_CODE, ENTER_DATE
          FROM IM_ITEM_WORKSTAGE_RECEIPT
         WHERE RECEIPT_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
           AND RECEIPT_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
           AND ITEM_CODE LIKE :itemCode
           AND ORGANIZATION_ID = :organizationId
        UNION ALL
        SELECT 'I' AS RCV_ISS_CODE, ISSUE_SEQUENCE AS RECEIPT_ISSUE_SEQUENCE,
               ISSUE_DATE AS RECEIPT_ISSUE_DATE, ORGANIZATION_ID,
               ISSUE_DEFICIT AS RECEIPT_ISSUE_DEFICIT, ISSUE_QTY AS QTY,
               ITEM_CODE, ENTER_DATE
          FROM IM_ITEM_WORKSTAGE_ISSUE
         WHERE ISSUE_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
           AND ISSUE_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
           AND ITEM_CODE LIKE :itemCode
           AND ORGANIZATION_ID = :organizationId
      ) A, ID_ITEM B
     WHERE A.ITEM_CODE = B.ITEM_CODE
       AND A.RCV_ISS_CODE LIKE :rcvIssCode`;

    const select = `
      SELECT A.RCV_ISS_CODE AS "rcvIssCode",
             A.RECEIPT_ISSUE_SEQUENCE AS "receiptIssueSequence",
             A.RECEIPT_ISSUE_DATE AS "receiptIssueDate",
             A.ORGANIZATION_ID AS "organizationId",
             A.RECEIPT_ISSUE_DEFICIT AS "receiptIssueDeficit",
             A.QTY AS "qty",
             A.ITEM_CODE AS "itemCode",
             B.ITEM_NAME AS "itemName",
             B.ITEM_SPEC AS "itemSpec",
             B.ITEM_UOM AS "itemUom",
             A.ENTER_DATE AS "enterDate",
             B.LOCATION_ADDRESS AS "locationAddress"`;

    const order = `
     ORDER BY A.ORGANIZATION_ID, A.ENTER_DATE, A.RECEIPT_ISSUE_DATE DESC, A.RECEIPT_ISSUE_SEQUENCE DESC`;

    return this.paged(select, from, order, binds, query.page, query.limit);
  }

  /** 모드 3 — 입고 바코드 (IM_ITEM_RECEIPT_BARCODE). */
  async findReceiptBarcodes(query: ReceiptBarcodeQueryDto, organizationId: number): Promise<PagedResult> {
    const binds: Record<string, unknown> = {
      dateFrom: query.dateFrom,
      dateTo: query.dateTo,
      itemCode: like(query.itemCode),
      lotNo: like(query.lotNo),
      slipNo: like(query.slipNo),
      lotDivide: like(query.lotDivide),
      supplierCode: like(query.supplierCode),
      keyitemYn: like(query.keyitemYn),
      organizationId,
    };

    const from = `
      FROM IM_ITEM_RECEIPT_BARCODE b, ID_ITEM i
     WHERE b.ITEM_CODE = i.ITEM_CODE(+)
       AND b.SCAN_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
       AND b.SCAN_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
       AND b.ITEM_CODE LIKE :itemCode
       AND b.LOT_NO LIKE :lotNo
       AND b.ORGANIZATION_ID = :organizationId
       AND b.RECEIPT_SLIP_NO LIKE :slipNo
       AND NVL(b.LOT_DIVIDE_YN, '*') LIKE :lotDivide
       AND b.SUPPLIER_CODE LIKE :supplierCode
       AND NVL(i.KEYITEM_YN, 'N') LIKE :keyitemYn`;

    const select = `
      SELECT b.ITEM_BARCODE AS "itemBarcode",
             b.SUPPLIER_CODE AS "supplierCode",
             b.ITEM_CODE AS "itemCode",
             b.SCAN_DATE AS "scanDate",
             b.LOT_NO AS "lotNo",
             b.SCAN_QTY AS "scanQty",
             b.SUPPLIER_BARCODE AS "supplierBarcode",
             b.SUPPLIER_ITEM_CODE AS "supplierItemCode",
             b.RECEIPT_COMPARE_YN AS "receiptCompareYn",
             b.RECEIPT_COMPARE_DATE AS "receiptCompareDate",
             b.RECEIPT_COMPARE_BY AS "receiptCompareBy",
             b.RECEIPT_SLIP_NO AS "receiptSlipNo",
             b.ISSUE_COMPARE_YN AS "issueCompareYn",
             b.ISSUE_COMPARE_DATE AS "issueCompareDate",
             b.ISSUE_COMPARE_BY AS "issueCompareBy",
             b.BARCODE_STATUS AS "barcodeStatus",
             b.RECEIPT_TYPE AS "receiptType",
             b.ISSUE_TYPE AS "issueType",
             b.FROM_SUPPLIER_CODE AS "fromSupplierCode",
             b.LOT_DIVIDE_YN AS "lotDivideYn",
             b.ORIGIN_ITEM_BARCODE AS "originItemBarcode",
             b.LABEL_TYPE AS "labelType",
             b.SUPPLIER_LOT_NO AS "supplierLotNo",
             b.ORIGIN_SUPPLIER_CODE AS "originSupplierCode",
             i.LOCATION_ADDRESS AS "locationAddress",
             b.VENDOR_LOTNO AS "vendorLotno",
             b.VENDOR_CODE AS "vendorCode"`;

    const order = `
     ORDER BY b.SCAN_DATE, b.LOT_NO`;

    return this.paged(select, from, order, binds, query.page, query.limit);
  }

  /**
   * 모드 4 — 라인 피더 레이아웃 (ID_ENG_BOM_SMT).
   * 레거시에 조직 필터가 없으므로 organizationId를 받지 않는다.
   */
  async findFeederLayout(query: FeederLayoutQueryDto): Promise<PagedResult> {
    const binds: Record<string, unknown> = {
      itemCode: like(query.itemCode),
      modelName: like(query.modelName),
      keyitemYn: like(query.keyitemYn),
    };

    const from = `
      FROM ID_ENG_BOM_SMT s, ID_ITEM i
     WHERE s.CHILD_ITEM_CODE = i.ITEM_CODE(+)
       AND s.ORGANIZATION_ID = i.ORGANIZATION_ID(+)
       AND s.CHILD_ITEM_CODE LIKE :itemCode
       AND NVL(i.KEYITEM_YN, 'N') LIKE :keyitemYn
       AND s.PARENT_ITEM_CODE LIKE :modelName`;

    const select = `
      SELECT s.CHILD_ITEM_CODE AS "itemCode",
             s.LINE_CODE AS "lineCode",
             s.ITEM_UNIT_QTY AS "unitQty",
             s.PCB_ITEM AS "pcbItem",
             (SELECT SUM(v.INVENTORY_QTY) FROM IM_ITEM_INVENTORY v
               WHERE v.ITEM_CODE = s.CHILD_ITEM_CODE) AS "inventoryQty",
             i.ITEM_NAME AS "itemName",
             i.ITEM_SPEC AS "itemSpec",
             i.LOCATION_ADDRESS AS "locationAddress",
             i.MSL_LEVEL AS "mslLevel",
             i.MATERIAL_QTY AS "materialQty",
             i.MATERIAL_QTY2 AS "materialQty2",
             (SELECT SUM(w.INVENTORY_QTY) FROM IM_ITEM_WORKSTAGE_INVENTORY w
               WHERE w.ITEM_CODE = s.CHILD_ITEM_CODE
                 AND w.LINE_CODE = s.LINE_CODE) AS "workstageInventoryQty"`;

    const order = `
     ORDER BY s.CHILD_ITEM_CODE, i.ITEM_NAME, i.ITEM_SPEC, i.LOCATION_ADDRESS`;

    return this.paged(select, from, order, binds, query.page, query.limit);
  }

  /**
   * 모드 5 — 출고 로스 (IM_ITEM_ISSUE_LOSS).
   * 종료일 경계는 레거시 그대로 `< :dateTo`다. 다른 모드의 `+1`과 다르며 종료일 당일이 빠진다.
   */
  async findIssueLoss(query: IssueLossQueryDto, organizationId: number): Promise<PagedResult> {
    const binds: Record<string, unknown> = {
      dateFrom: query.dateFrom,
      dateTo: query.dateTo,
      lineCode: like(query.lineCode),
      modelName: like(query.modelName),
      itemCode: like(query.itemCode),
      materialMfs: like(query.materialMfs),
      keyitemYn: like(query.keyitemYn),
      organizationId,
    };

    const from = `
      FROM IM_ITEM_ISSUE_LOSS l, ID_ITEM i
     WHERE l.ITEM_CODE = i.ITEM_CODE(+)
       AND l.ORGANIZATION_ID = i.ORGANIZATION_ID(+)
       AND l.ISSUE_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
       AND l.ISSUE_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD')
       AND l.LINE_CODE LIKE :lineCode
       AND NVL(l.MODEL_NAME, '*') LIKE :modelName
       AND l.ITEM_CODE LIKE :itemCode
       AND l.MATERIAL_MFS LIKE :materialMfs
       AND l.ORGANIZATION_ID = :organizationId
       AND NVL(i.KEYITEM_YN, 'N') LIKE :keyitemYn`;

    const select = `
      SELECT l.ISSUE_DATE AS "issueDate",
             l.ISSUE_SEQUENCE AS "issueSequence",
             l.ITEM_CODE AS "itemCode",
             l.MATERIAL_MFS AS "materialMfs",
             l.LINE_CODE AS "lineCode",
             l.MODEL_NAME AS "modelName",
             l.ISSUE_QTY AS "issueQty",
             l.ENTER_DATE AS "enterDate",
             l.ENTER_BY AS "enterBy",
             l.LAST_MODIFY_DATE AS "lastModifyDate",
             l.LAST_MODIFY_BY AS "lastModifyBy",
             l.ORGANIZATION_ID AS "organizationId",
             i.ITEM_NAME AS "itemName",
             i.ITEM_SPEC AS "itemSpec"`;

    const order = `
     ORDER BY l.LINE_CODE, l.ISSUE_DATE, l.ISSUE_SEQUENCE`;

    return this.paged(select, from, order, binds, query.page, query.limit);
  }

  private async paged(
    select: string,
    from: string,
    order: string,
    binds: Record<string, unknown>,
    page = 1,
    limit = 50,
  ): Promise<PagedResult> {
    const countRows = await this.query(`SELECT COUNT(*) AS "total" ${from}`, binds);
    const total = Number(countRows[0]?.total ?? 0);
    const rows = await this.query(
      `${select} ${from} ${order} OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`,
      { ...binds, offset: (page - 1) * limit, limit },
    );
    return { data: rows, total, page, limit };
  }

  /**
   * Oracle named bind로 실행한다.
   *
   * 이 원장 SQL은 같은 바인드(:dateFrom, :itemCode, :organizationId 등)를 UNION 양쪽에서
   * 반복 참조한다. oracledb는 위치 바인드를 등장 횟수만큼 요구하므로(DPY-4009), 위치 바인드로
   * 옮기면 SQL 한 줄만 바뀌어도 값 순서가 어긋나 조용히 틀린 수불 결과가 나온다.
   * TypeORM 시그니처는 배열만 선언하지만 Oracle 드라이버는 객체 바인드를 그대로 받으므로
   * 여기서만 단언한다. 단언을 이 헬퍼 한 곳에 가두고 호출부는 타입을 유지한다.
   */
  private async query(sql: string, binds: Record<string, unknown>): Promise<OracleRow[]> {
    try {
      return await this.dataSource.query(sql, { ...binds } as unknown as unknown[]);
    } catch (error: unknown) {
      throw this.toOracleException(error);
    }
  }

  /** Oracle 원문 메시지를 보존한다. 뭉개진 문구로 대체하지 않는다. */
  private toOracleException(error: unknown): BadRequestException {
    const record = typeof error === 'object' && error !== null ? error as Record<string, unknown> : {};
    const driver = typeof record.driverError === 'object' && record.driverError !== null
      ? record.driverError as Record<string, unknown>
      : {};
    const message = typeof driver.message === 'string'
      ? driver.message
      : typeof record.message === 'string' ? record.message : '자재입출고수불원장 조회 중 오류가 발생했습니다.';
    return new BadRequestException(message);
  }
}
