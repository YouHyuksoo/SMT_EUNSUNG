/**
 * @file src/modules/report/material-receipt-report.service.ts
 * @description 자재 입고 계열 리포트 3화면
 *              362 w_mat_receipt_issue_barcode_history_report  자재전표바코드리포트
 *              363 w_mat_receipt_report                        자재입고리포트
 *              364 w_mat_receipt_sum_report                    자재입고합계리포트
 *
 * 초보자 가이드:
 * 1. **기간이 유일한 방어선이다.** 이 화면들에는 키가 없다 (집계다).
 *    IM_ITEM_RECEIPT 는 150만행이고 PK 선두가 RECEIPT_DATE 라 기간을 걸면
 *    인덱스를 탄다. IM_ITEM_RECEIPT_BARCODE(193만행)는 SCAN_DATE 단독 인덱스다.
 * 2. **PB 의 고정 조건을 빠뜨리지 않는다.** 구조에서 SQL 을 새로 쓸 때 상수 조건이
 *    제일 먼저 사라지고, 그러면 행이 조용히 늘어난다. 실측 고정조건:
 *        363·364  RECEIPT_STATUS <> 'C'   (취소 제외 — 30일치 132건)
 *        363 반품  RECEIPT_DEFICIT = '2'   (반품만 — 30일치 73건)
 *        362      LOT_DIVIDE_YN = 'Y'     (롯트 분할 바코드만)
 * 3. **품목·협력사 마스터는 LEFT JOIN 이다.** PB 의 pbselect 구조는 내부조인으로
 *    보이지만 같은 화면의 일자별 DataWindow 는 `(+)` 를 쓴다. 내부조인으로 두면
 *    마스터가 없는 입고가 리포트에서 사라진다 — 30일치에서 품목마스터 없는 입고 4건,
 *    협력사 없는 입고 1건이 실제로 있다 (실측). 원장 리포트에서 그건 데이터 누락이다.
 * 4. **바코드 외부조인은 행을 늘리지 않는다.** (품목코드, 자재롯트) 로 붙이는데
 *    30일치 16,396건이 조인 후에도 16,396건이었다 (실측). PB 와 같은 조인을 유지한다.
 * 5. **매트릭스 탭은 진짜 크로스탭이다** (DataWindow `processing=4` — 실측).
 *    SQL 은 `(일자, 위치, 협력사, 구분, 수량)` 목록만 주고 피벗은 화면에서 돌린다.
 * 6. **코드 이름은 PB 와 같은 DB 함수로 붙인다** (`F_GET_BASECODE`,
 *    `F_GET_SUPPLIER_NAME`). TypeScript 로 다시 구현하면 PB 와 표시가 갈린다.
 */
import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { likePrefix } from '@smt/shared';
import { limited, ROW_LIMIT } from './report-rows';
import {
  MaterialBarcodeSlipQueryDto,
  MaterialReceiptReportQueryDto,
  MaterialReceiptSumQueryDto,
} from './material-report.dto';

type Row = Record<string, unknown>;

/** PB 고정조건: 취소된 입고는 리포트에서 뺀다. */
const RECEIPT_CANCELED = 'C';
/** PB 고정조건: 반품 탭의 입출고구분. */
const RECEIPT_DEFICIT_RETURN = '2';

@Injectable()
export class MaterialReceiptReportService {
  constructor(private readonly dataSource: DataSource) {}

  /**
   * 기간은 `>= 시작일` · `< 종료일 + 1` 로 건다.
   *
   * PB 는 `between :from and :to` 였는데 두 값이 DATE 라 종료일의 00:00:00 까지만
   * 걸려 **종료일 하루가 통째로 빠졌다.** 종료일에 입고된 건을 못 보는 것은
   * 리포트로서 틀린 것이라 `< 종료일 + 1` 로 고쳤다.
   */
  private dateWhere(column: string) {
    return `${column} >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
        AND ${column} <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1`;
  }

  // ───────────────────────────────── 362 자재전표바코드리포트

  /**
   * 자재 바코드 스캔 이력.
   *
   * `lotDivideYn` 기본값은 'Y' 다 — PB 가 고정으로 걸던 조건이다. 'ALL' 로 끄면
   * 분할하지 않은 바코드까지 나오므로 건수가 크게 늘어난다.
   */
  async findBarcodeSlips(query: MaterialBarcodeSlipQueryDto, organizationId: number) {
    const mode = query.lotDivideYn ?? 'Y';
    const divideWhere = mode === 'ALL' ? '' : `AND b.LOT_DIVIDE_YN = :lotDivideYn`;
    const binds: Row = {
      dateFrom: query.dateFrom,
      dateTo: query.dateTo,
      itemCode: likePrefix(query.itemCode),
      lotNo: likePrefix(query.lotNo),
      organizationId,
    };
    if (mode !== 'ALL') binds.lotDivideYn = mode;

    const rows = (await this.dataSource.query(
      `SELECT b.ITEM_BARCODE                            AS "itemBarcode",
              b.SUPPLIER_BARCODE                        AS "supplierBarcode",
              b.SUPPLIER_CODE                           AS "supplierCode",
              F_GET_SUPPLIER_NAME(b.SUPPLIER_CODE, b.ORGANIZATION_ID) AS "supplierName",
              b.ITEM_CODE                               AS "itemCode",
              b.SUPPLIER_ITEM_CODE                      AS "supplierItemCode",
              b.LOT_NO                                  AS "lotNo",
              b.SUPPLIER_LOT_NO                         AS "supplierLotNo",
              b.SCAN_QTY                                AS "scanQty",
              TO_CHAR(b.SCAN_DATE, 'YYYY-MM-DD HH24:MI:SS')            AS "scanDate",
              b.RECEIPT_SLIP_NO                         AS "receiptSlipNo",
              b.RECEIPT_TYPE                            AS "receiptType",
              b.RECEIPT_COMPARE_YN                      AS "receiptCompareYn",
              TO_CHAR(b.RECEIPT_COMPARE_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "receiptCompareDate",
              b.RECEIPT_COMPARE_BY                      AS "receiptCompareBy",
              b.ISSUE_TYPE                              AS "issueType",
              b.ISSUE_COMPARE_YN                        AS "issueCompareYn",
              TO_CHAR(b.ISSUE_COMPARE_DATE, 'YYYY-MM-DD HH24:MI:SS')   AS "issueCompareDate",
              b.ISSUE_COMPARE_BY                        AS "issueCompareBy",
              b.BARCODE_STATUS                          AS "barcodeStatus",
              b.LABEL_TYPE                              AS "labelType",
              b.LOT_DIVIDE_YN                           AS "lotDivideYn",
              b.ORIGIN_ITEM_BARCODE                     AS "originItemBarcode",
              b.ORIGIN_SUPPLIER_CODE                    AS "originSupplierCode",
              b.FROM_SUPPLIER_CODE                      AS "fromSupplierCode",
              b.ENTER_BY                                AS "enterBy",
              TO_CHAR(b.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')           AS "enterDate",
              b.LAST_MODIFY_BY                          AS "lastModifyBy",
              TO_CHAR(b.LAST_MODIFY_DATE, 'YYYY-MM-DD HH24:MI:SS')     AS "lastModifyDate"
         FROM IM_ITEM_RECEIPT_BARCODE b
        WHERE ${this.dateWhere('b.SCAN_DATE')}
          AND b.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND b.LOT_NO LIKE :lotNo ESCAPE '\\'
          AND b.ORGANIZATION_ID = :organizationId
          ${divideWhere}
        ORDER BY b.SCAN_DATE DESC, b.ITEM_BARCODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      binds as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  // ───────────────────────────────── 363 자재입고리포트

  /** 363 의 네 목록 탭이 함께 쓰는 조건. */
  private receiptWhere(extra: string) {
    return `${this.dateWhere('r.RECEIPT_DATE')}
        AND r.SUPPLIER_CODE LIKE :supplierCode ESCAPE '\\'
        AND r.ITEM_CODE LIKE :itemCode ESCAPE '\\'
        AND r.ORGANIZATION_ID = :organizationId
        AND r.RECEIPT_STATUS <> '${RECEIPT_CANCELED}'
        ${extra}`;
  }

  private receiptBinds(query: MaterialReceiptReportQueryDto, organizationId: number) {
    return {
      dateFrom: query.dateFrom,
      dateTo: query.dateTo,
      supplierCode: likePrefix(query.supplierCode),
      itemCode: likePrefix(query.itemCode),
      organizationId,
    };
  }

  /**
   * 입고 상세 (일자별). PB 의 일자별 그리드를 옮긴 것이다.
   *
   * 품목·협력사·바코드를 전부 외부조인으로 붙인다 (PB 가 `(+)` 로 쓴 그대로).
   * 단가확인값은 PB 와 같은 DB 함수가 계산한다 — 실제 입고단가와 기준단가가
   * 다른 건을 찾는 것이 이 열의 목적이다.
   */
  async findReceiptDetail(query: MaterialReceiptReportQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT TO_CHAR(r.RECEIPT_DATE, 'YYYY-MM-DD HH24:MI:SS')  AS "receiptDate",
              r.RECEIPT_SEQUENCE                        AS "receiptSequence",
              r.ITEM_CODE                               AS "itemCode",
              i.ITEM_NAME                               AS "itemName",
              i.ITEM_SPEC                               AS "itemSpec",
              i.ITEM_UOM                                AS "itemUom",
              i.ITEM_CLASS                              AS "itemClass",
              i.LOCATION_ADDRESS                        AS "locationAddress",
              r.SUPPLIER_CODE                           AS "supplierCode",
              s.SUPPLIER_NAME                           AS "supplierName",
              r.FROM_SUPPLIER_CODE                      AS "fromSupplierCode",
              r.LOCATION_CODE                           AS "locationCode",
              r.RECEIPT_DEFICIT                         AS "receiptDeficit",
              r.RECEIPT_TYPE                            AS "receiptType",
              r.ORDER_TYPE                              AS "orderType",
              r.LINE_TYPE                               AS "lineType",
              r.RECEIPT_QTY                             AS "receiptQty",
              r.UNIT_PRICE                              AS "unitPrice",
              -- 기준단가. 입고단가와 다르면 단가확인이 안 된 입고다 (PB 와 같은 함수).
              F_GET_MAT_UNIT_PRICE_CONFIRM(r.SUPPLIER_CODE, r.ITEM_CODE, r.LINE_TYPE,
                                           r.RECEIPT_DATE, r.ORGANIZATION_ID)
                                                        AS "checkUnitPrice",
              r.RECEIPT_AMT                             AS "receiptAmt",
              r.MATERIAL_COST_AMT                       AS "materialCostAmt",
              r.EXCHANGE_RATE                           AS "exchangeRate",
              r.FOREIGN_RECEIPT_AMT                     AS "foreignReceiptAmt",
              r.CURRENCY                                AS "currency",
              r.INVOICE_NO                              AS "invoiceNo",
              r.SUBCONTRACT_INVOICE_NO                  AS "subcontractInvoiceNo",
              r.MFS                                     AS "mfs",
              r.MATERIAL_MFS                            AS "materialMfs",
              r.ORIGIN_MFS                              AS "originMfs",
              r.RECEIPT_LOT_NO                          AS "receiptLotNo",
              r.BARCODE                                 AS "barcode",
              r.RECEIPT_STATUS                          AS "receiptStatus",
              r.CONFIRM_YN                              AS "confirmYn",
              TO_CHAR(r.CONFIRM_DATE, 'YYYY-MM-DD HH24:MI:SS')   AS "confirmDate",
              r.COMMENTS                                AS "comments",
              b.RECEIPT_COMPARE_YN                      AS "receiptCompareYn",
              b.RECEIPT_SLIP_NO                         AS "receiptSlipNo",
              TO_CHAR(b.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')     AS "barcodeEnterDate",
              b.VENDOR_LOTNO                            AS "vendorLotNo",
              b.VENDOR_CODE                             AS "vendorCode",
              r.ENTER_BY                                AS "enterBy",
              TO_CHAR(r.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')     AS "enterDate"
         FROM IM_ITEM_RECEIPT r
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = r.ITEM_CODE
               AND i.ORGANIZATION_ID = r.ORGANIZATION_ID
         LEFT JOIN ICOM_SUPPLIER s
                ON s.SUPPLIER_CODE = r.SUPPLIER_CODE
               AND s.ORGANIZATION_ID = r.ORGANIZATION_ID
         LEFT JOIN IM_ITEM_RECEIPT_BARCODE b
                ON b.ITEM_CODE = r.ITEM_CODE
               AND b.LOT_NO = r.MATERIAL_MFS
        WHERE ${this.receiptWhere(`
          AND r.RECEIPT_TYPE LIKE :receiptType ESCAPE '\\'
          AND r.LOCATION_CODE LIKE :locationCode ESCAPE '\\'
          -- 품목분류는 외부조인 상대 컬럼이라 NVL 이 필요하다. 벗기면 품목마스터가
          -- 없는 입고가 NULL LIKE '%' = NULL 로 탈락해 외부조인이 내부조인이 된다.
          AND NVL(i.ITEM_CLASS, '*') LIKE :itemClass ESCAPE '\\'`)}
        ORDER BY r.RECEIPT_DATE DESC, r.RECEIPT_SEQUENCE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        ...this.receiptBinds(query, organizationId),
        receiptType: likePrefix(query.receiptType),
        locationCode: likePrefix(query.locationCode),
        itemClass: likePrefix(query.itemClass),
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /**
   * 협력사별 입고 (발주유형 조건 추가) · 반품 (입출고구분 '2' 고정).
   *
   * PB 는 DataWindow 를 둘로 나눴지만 SQL 은 조건 하나만 다르다.
   * @param kind 'supplier' 협력사별 · 'return' 반품
   */
  async findReceiptBySupplier(
    query: MaterialReceiptReportQueryDto,
    organizationId: number,
    kind: 'supplier' | 'return',
  ) {
    const returnWhere = kind === 'return'
      ? `AND r.RECEIPT_DEFICIT = '${RECEIPT_DEFICIT_RETURN}'`
      : `AND r.ORDER_TYPE LIKE :orderType ESCAPE '\\'`;
    const binds: Row = this.receiptBinds(query, organizationId);
    if (kind !== 'return') binds.orderType = likePrefix(query.orderType);

    const rows = (await this.dataSource.query(
      `SELECT TO_CHAR(r.RECEIPT_DATE, 'YYYY-MM-DD HH24:MI:SS')  AS "receiptDate",
              r.RECEIPT_SEQUENCE                        AS "receiptSequence",
              r.SUPPLIER_CODE                           AS "supplierCode",
              s.SUPPLIER_NAME                           AS "supplierName",
              r.ITEM_CODE                               AS "itemCode",
              i.ITEM_NAME                               AS "itemName",
              i.ITEM_SPEC                               AS "itemSpec",
              i.ITEM_UOM                                AS "itemUom",
              r.LOCATION_CODE                           AS "locationCode",
              r.RECEIPT_DEFICIT                         AS "receiptDeficit",
              r.RECEIPT_TYPE                            AS "receiptType",
              r.ORDER_TYPE                              AS "orderType",
              r.LINE_TYPE                               AS "lineType",
              r.RECEIPT_QTY                             AS "receiptQty",
              r.UNIT_PRICE                              AS "unitPrice",
              r.RECEIPT_AMT                             AS "receiptAmt",
              r.MATERIAL_COST_AMT                       AS "materialCostAmt",
              r.EXCHANGE_RATE                           AS "exchangeRate",
              r.FOREIGN_RECEIPT_AMT                     AS "foreignReceiptAmt",
              r.CURRENCY                                AS "currency",
              r.INVOICE_NO                              AS "invoiceNo",
              r.MFS                                     AS "mfs",
              r.MATERIAL_MFS                            AS "materialMfs",
              r.RECEIPT_LOT_NO                          AS "receiptLotNo",
              r.BARCODE                                 AS "barcode",
              r.RECEIPT_STATUS                          AS "receiptStatus",
              r.CONFIRM_YN                              AS "confirmYn",
              TO_CHAR(r.CONFIRM_DATE, 'YYYY-MM-DD HH24:MI:SS')   AS "confirmDate",
              r.COMMENTS                                AS "comments",
              r.ENTER_BY                                AS "enterBy",
              TO_CHAR(r.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')     AS "enterDate"
         FROM IM_ITEM_RECEIPT r
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = r.ITEM_CODE
               AND i.ORGANIZATION_ID = r.ORGANIZATION_ID
         LEFT JOIN ICOM_SUPPLIER s
                ON s.SUPPLIER_CODE = r.SUPPLIER_CODE
               AND s.ORGANIZATION_ID = r.ORGANIZATION_ID
        WHERE ${this.receiptWhere(returnWhere)}
        ORDER BY r.SUPPLIER_CODE, r.RECEIPT_DATE DESC, r.RECEIPT_SEQUENCE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      binds as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /**
   * 363 매트릭스 원자료 (품목 × 일자 입고수량).
   *
   * DataWindow `processing=4` — 진짜 크로스탭이다. 열 집합(일자)이 조회 기간에
   * 따라 달라지므로 SQL 은 목록만 주고 피벗은 화면에서 돌린다.
   */
  async findReceiptMatrix(query: MaterialReceiptReportQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT TO_CHAR(TRUNC(r.RECEIPT_DATE), 'YYYY-MM-DD')      AS "receiptDate",
              r.ITEM_CODE                               AS "itemCode",
              i.ITEM_NAME                               AS "itemName",
              i.ITEM_SPEC                               AS "itemSpec",
              i.ITEM_UOM                                AS "itemUom",
              SUM(NVL(r.RECEIPT_QTY, 0))                AS "receiptQty",
              SUM(NVL(r.RECEIPT_AMT, 0))                AS "receiptAmt",
              SUM(NVL(r.FOREIGN_RECEIPT_AMT, 0))        AS "foreignReceiptAmt"
         FROM IM_ITEM_RECEIPT r
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = r.ITEM_CODE
               AND i.ORGANIZATION_ID = r.ORGANIZATION_ID
        WHERE ${this.dateWhere('r.RECEIPT_DATE')}
          AND r.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND r.ORGANIZATION_ID = :organizationId
        GROUP BY TRUNC(r.RECEIPT_DATE), r.ITEM_CODE,
                 i.ITEM_NAME, i.ITEM_SPEC, i.ITEM_UOM
        ORDER BY r.ITEM_CODE, 1
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        itemCode: likePrefix(query.itemCode),
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  // ───────────────────────────────── 364 자재입고합계리포트

  private sumBinds(query: MaterialReceiptSumQueryDto, organizationId: number) {
    return {
      dateFrom: query.dateFrom,
      dateTo: query.dateTo,
      supplierCode: likePrefix(query.supplierCode),
      itemCode: likePrefix(query.itemCode),
      invoiceNo: likePrefix(query.invoiceNo),
      organizationId,
    };
  }

  /**
   * 품목별 입고합계.
   *
   * `supplierAddress` 를 켜면 PB 의 '협력사용' DataWindow 와 같아진다 (협력사 주소·
   * 전화·팩스를 함께 묶는다). PB 는 DataWindow 를 둘로 나눴지만 집계는 같다.
   */
  async findReceiptSumByItem(
    query: MaterialReceiptSumQueryDto,
    organizationId: number,
    withSupplierContact = false,
  ) {
    const contactColumns = withSupplierContact
      ? `s.ADDRESS AS "supplierAddress",
              s.TEL_NO  AS "supplierTelNo",
              s.FAX_NO  AS "supplierFaxNo",`
      : `NULL AS "supplierAddress", NULL AS "supplierTelNo", NULL AS "supplierFaxNo",`;
    const contactGroup = withSupplierContact ? ', s.ADDRESS, s.TEL_NO, s.FAX_NO' : '';

    const rows = (await this.dataSource.query(
      `SELECT r.ITEM_CODE                               AS "itemCode",
              i.ITEM_NAME                               AS "itemName",
              i.ITEM_SPEC                               AS "itemSpec",
              i.ITEM_UOM                                AS "itemUom",
              i.VIRTUAL_RECEIPT_YN                      AS "virtualReceiptYn",
              r.SUPPLIER_CODE                           AS "supplierCode",
              s.SUPPLIER_NAME                           AS "supplierName",
              ${contactColumns}
              r.RECEIPT_TYPE                            AS "receiptType",
              r.INVOICE_NO                              AS "invoiceNo",
              SUM(NVL(r.RECEIPT_QTY, 0))                AS "receiptQty",
              -- PB 는 단가를 평균냈다 (AVG). 수량 가중이 아니라 단순 평균이다.
              AVG(r.UNIT_PRICE)                         AS "receiptPrice",
              SUM(NVL(r.RECEIPT_AMT, 0))                AS "receiptAmt",
              SUM(NVL(r.FOREIGN_RECEIPT_AMT, 0))        AS "foreignReceiptAmt"
         FROM IM_ITEM_RECEIPT r
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = r.ITEM_CODE
               AND i.ORGANIZATION_ID = r.ORGANIZATION_ID
         LEFT JOIN ICOM_SUPPLIER s
                ON s.SUPPLIER_CODE = r.SUPPLIER_CODE
               AND s.ORGANIZATION_ID = r.ORGANIZATION_ID
        WHERE ${this.dateWhere('r.RECEIPT_DATE')}
          AND r.SUPPLIER_CODE LIKE :supplierCode ESCAPE '\\'
          AND r.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND NVL(r.INVOICE_NO, '*') LIKE :invoiceNo ESCAPE '\\'
          AND r.ORGANIZATION_ID = :organizationId
          AND r.RECEIPT_STATUS <> '${RECEIPT_CANCELED}'
        GROUP BY r.ITEM_CODE, i.ITEM_NAME, i.ITEM_SPEC, i.ITEM_UOM,
                 i.VIRTUAL_RECEIPT_YN, r.SUPPLIER_CODE, s.SUPPLIER_NAME,
                 r.RECEIPT_TYPE, r.INVOICE_NO${contactGroup}
        ORDER BY r.SUPPLIER_CODE, r.ITEM_CODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      this.sumBinds(query, organizationId) as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /** 협력사별 입고합계. */
  async findReceiptSumBySupplier(query: MaterialReceiptSumQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT r.SUPPLIER_CODE                           AS "supplierCode",
              s.SUPPLIER_NAME                           AS "supplierName",
              r.RECEIPT_TYPE                            AS "receiptType",
              r.INVOICE_NO                              AS "invoiceNo",
              SUM(NVL(r.RECEIPT_QTY, 0))                AS "receiptQty",
              SUM(NVL(r.RECEIPT_AMT, 0))                AS "receiptAmt",
              SUM(NVL(r.FOREIGN_RECEIPT_AMT, 0))        AS "foreignReceiptAmt"
         FROM IM_ITEM_RECEIPT r
         LEFT JOIN ICOM_SUPPLIER s
                ON s.SUPPLIER_CODE = r.SUPPLIER_CODE
               AND s.ORGANIZATION_ID = r.ORGANIZATION_ID
        WHERE ${this.dateWhere('r.RECEIPT_DATE')}
          AND r.SUPPLIER_CODE LIKE :supplierCode ESCAPE '\\'
          AND NVL(r.INVOICE_NO, '*') LIKE :invoiceNo ESCAPE '\\'
          AND r.ORGANIZATION_ID = :organizationId
          AND r.RECEIPT_STATUS <> '${RECEIPT_CANCELED}'
        GROUP BY r.SUPPLIER_CODE, s.SUPPLIER_NAME, r.RECEIPT_TYPE, r.INVOICE_NO
        ORDER BY r.SUPPLIER_CODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        supplierCode: likePrefix(query.supplierCode),
        invoiceNo: likePrefix(query.invoiceNo),
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /** 창고별 입고합계. */
  async findReceiptSumByWarehouse(query: MaterialReceiptSumQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT r.LOCATION_CODE                           AS "locationCode",
              F_GET_BASECODE('MATERIAL LOCATION CODE', r.LOCATION_CODE,
                             :lang, r.ORGANIZATION_ID)  AS "locationName",
              r.RECEIPT_TYPE                            AS "receiptType",
              SUM(NVL(r.RECEIPT_QTY, 0))                AS "receiptQty",
              SUM(NVL(r.RECEIPT_AMT, 0))                AS "receiptAmt",
              SUM(NVL(r.FOREIGN_RECEIPT_AMT, 0))        AS "foreignReceiptAmt"
         FROM IM_ITEM_RECEIPT r
        WHERE ${this.dateWhere('r.RECEIPT_DATE')}
          AND NVL(r.LOCATION_CODE, '*') LIKE :locationCode ESCAPE '\\'
          AND r.ORGANIZATION_ID = :organizationId
          AND r.RECEIPT_STATUS <> '${RECEIPT_CANCELED}'
        GROUP BY r.LOCATION_CODE, r.RECEIPT_TYPE, r.ORGANIZATION_ID
        ORDER BY r.LOCATION_CODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        locationCode: likePrefix(query.locationCode),
        lang: query.lang ?? 'KOR',
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /**
   * 입출고·반품 매트릭스 원자료.
   *
   * 입고와 출고를 UNION ALL 로 붙인다 (PB 그대로). 위치·협력사·입출고구분은
   * PB 와 같은 DB 함수로 뜻을 붙인다.
   *
   * `ORDER BY` 는 UNION 바깥에서 한다 — 안쪽 별칭은 UNION 결과에서 보이지 않아
   * ORA-00904 가 난다 (조회 대분류에서 실측했다).
   */
  async findReceiptIssueMatrix(query: MaterialReceiptSumQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT * FROM (
         SELECT TO_CHAR(TRUNC(r.RECEIPT_DATE), 'YYYY-MM-DD')    AS "txnDate",
                'RECEIPT'                                       AS "txnKind",
                r.ITEM_CODE                                     AS "itemCode",
                r.LOCATION_CODE                                 AS "locationCode",
                F_GET_BASECODE('MATERIAL LOCATION CODE', r.LOCATION_CODE,
                               :lang, r.ORGANIZATION_ID)        AS "locationName",
                r.SUPPLIER_CODE                                 AS "supplierCode",
                F_GET_SUPPLIER_NAME(r.SUPPLIER_CODE, r.ORGANIZATION_ID) AS "supplierName",
                r.RECEIPT_DEFICIT                               AS "deficit",
                F_GET_BASECODE('RECEIPT ISSUE DEFICIT', r.RECEIPT_DEFICIT,
                               :lang, r.ORGANIZATION_ID)        AS "deficitName",
                SUM(NVL(r.RECEIPT_QTY, 0))                      AS "qty"
           FROM IM_ITEM_RECEIPT r
          WHERE ${this.dateWhere('r.RECEIPT_DATE')}
            AND r.SUPPLIER_CODE LIKE :supplierCode ESCAPE '\\'
            AND r.ITEM_CODE LIKE :itemCode ESCAPE '\\'
            AND r.ORGANIZATION_ID = :organizationId
          GROUP BY TRUNC(r.RECEIPT_DATE), r.ITEM_CODE, r.LOCATION_CODE,
                   r.SUPPLIER_CODE, r.RECEIPT_DEFICIT, r.ORGANIZATION_ID
         UNION ALL
         SELECT TO_CHAR(TRUNC(g.ISSUE_DATE), 'YYYY-MM-DD')      AS "txnDate",
                'ISSUE'                                         AS "txnKind",
                g.ITEM_CODE                                     AS "itemCode",
                g.LOCATION_CODE                                 AS "locationCode",
                F_GET_BASECODE('MATERIAL LOCATION CODE', g.LOCATION_CODE,
                               :lang, g.ORGANIZATION_ID)        AS "locationName",
                g.SUPPLIER_CODE                                 AS "supplierCode",
                F_GET_SUPPLIER_NAME(g.SUPPLIER_CODE, g.ORGANIZATION_ID) AS "supplierName",
                g.ISSUE_DEFICIT                                 AS "deficit",
                F_GET_BASECODE('RECEIPT ISSUE DEFICIT', g.ISSUE_DEFICIT,
                               :lang, g.ORGANIZATION_ID)        AS "deficitName",
                SUM(NVL(g.ISSUE_QTY, 0))                        AS "qty"
           FROM IM_ITEM_ISSUE g
          WHERE ${this.dateWhere('g.ISSUE_DATE')}
            AND NVL(g.SUPPLIER_CODE, '*') LIKE :supplierCode ESCAPE '\\'
            AND g.ITEM_CODE LIKE :itemCode ESCAPE '\\'
            AND g.ORGANIZATION_ID = :organizationId
          GROUP BY TRUNC(g.ISSUE_DATE), g.ITEM_CODE, g.LOCATION_CODE,
                   g.SUPPLIER_CODE, g.ISSUE_DEFICIT, g.ORGANIZATION_ID
       )
       ORDER BY "itemCode", "txnKind", "txnDate"
       FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        supplierCode: likePrefix(query.supplierCode),
        itemCode: likePrefix(query.itemCode),
        lang: query.lang ?? 'KOR',
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }
}
