/**
 * @file src/modules/warehouse/barcode-receipt.service.ts
 * @description 237 자재바코드입고관리 — PB w_mat_other_receipt_barcode_master 이식 (**쓰기**)
 *
 * 초보자 가이드:
 * 1. **이 화면은 "입고대조" 를 한다.** 235 가 만들어 붙인 자사 바코드와, 협력사가
 *    붙여 보낸 바코드를 **둘 다 스캔**해서 같은 물건인지 맞춰 보고, 맞으면
 *    입고 원장(`IM_ITEM_RECEIPT`)에 입고 한 건을 넣는다. 바코드 한 장 = 입고 한 건이다.
 * 2. **235 와 INSERT 문을 공유하지 않는다.** 같은 표에 넣지만 값이 다르다 (실측):
 *
 *        열              235(전표발행)  237(스캔대조)
 *        UNIT_PRICE      1              **0**
 *        RECEIPT_AMT     수량 × 1       **0**
 *        CLOSE_YN        'N'            **'Y'**
 *        LOCATION_CODE   'M01' 고정     LABEL_TYPE='R' → 'M06', 아니면 'M01'
 *        RECEIPT_LOT_NO  롯트번호       F_GET_ANY_NO('RECEIPT_LOT_NO')
 *
 *    근거: 최근 1년 입고 원장을 `CLOSE_YN`·`UNIT_PRICE` 로 세어 보면
 *    **'Y'/0 이 222,300건** (이 화면 경로), **'N'/1 이 975건** (235 경로)으로
 *    딱 갈린다. 공통 헬퍼로 묶으면 둘 중 하나가 조용히 틀어진다.
 * 3. **PB 의 단가는 실수로 0 이다.** `lvd_unit_price` 를 채우던 줄이 주석 처리돼
 *    있고 (PB 508행) 대입이 한 곳도 없다 — PB `decimal` 초기값 0 이 그대로 들어간다.
 *    의도든 실수든 **원장에 이미 22만건이 0 으로 쌓여 있으므로** 바꾸지 않는다.
 * 4. **PB 의 확인-후-실행 틈을 막았다.** PB 는 `RECEIPT_COMPARE_YN='Y'` 인지 먼저
 *    SELECT 로 보고, 나중에 조건 없이 UPDATE + INSERT 한다. 같은 바코드를 두 사람이
 *    동시에 스캔하면 둘 다 SELECT 를 통과해 **입고가 두 건 들어간다.** 그래서 여기서는
 *    UPDATE 자체에 `NVL(RECEIPT_COMPARE_YN,'N') <> 'Y'` 를 넣고, 그 UPDATE 가
 *    1행을 바꿨을 때만 입고를 넣는다.
 * 5. **바코드 해석 DB 함수는 그대로 호출한다.** `F_GET_ITEM_CODE_FROM_BARCODE(_S)` ·
 *    `F_GET_LOT_NO_FROM_BARCODE` · `F_GET_LOT_QTY_FROM_BARCODE` 는 PB 가 **SQL 문장
 *    안에서** 부르므로 DB 함수이고, 은성 DB 에 VALID 로 있다 (실측). 바코드를 자르는
 *    규칙을 TypeScript 로 다시 쓰면 PB 와 값이 갈린다.
 * 5-1. **`F_CHECK_ITEM_EXISTS` 는 DB 함수를 쓰면 안 된다.** PB 는 SQL 문장 **밖에서**
 *    부르고, 같은 이름의 PB 함수가 따로 있다 (`f_check_item_exists.srf`). 둘의 뜻이
 *    전혀 다르다 (실측):
 *        PB  — `ID_ITEM` 에서 **품목 유효기간**을 본다 (DATESET ≤ 오늘 ≤ DATEEND)
 *        DB  — `ID_CUSTOMER_SET_BOM` 에서 세트 BOM 유무를 보고 'EXISTS'/'NOTFOUND'
 *    인자도 (품목, **조직**) 이라 PB 가 넘기던 날짜 자리와 맞지 않는다
 *    (실측 ORA-06553 PLS-306). 그래서 PB 쪽 SQL 을 그대로 인라인한다.
 * 5-2. **`F_GET_LINE_TYPE_FROM_ITEM` 은 DB 함수를 쓴다** (인자 2개: 품목, 조직).
 *    PB 동명 함수와 본문이 같고 유효기간 조건만 DB 쪽에서 주석 처리돼 있다 —
 *    앞 단계에서 유효기간을 이미 확인하므로 결과가 같다.
 * 6. **PB `f_get_any_no` 는 얇은 껍데기다.** PB 함수 본문이
 *    `SELECT F_GET_ANY_NO(UPPER(:name), :org) INTO ... FROM DUAL` 뿐이라
 *    (실측 `f_get_any_no.srf`) DB 함수를 직접 부르면 값이 같다.
 * 7. **옮기지 않은 것** (실측 근거):
 *      · `dw_4.update()` — 대상 표는 `IM_ITEM_RECEIPT_BARCODE` 인데 갱신 가능한 열이
 *        `BARCODE_STATUS` **하나뿐이고 그 열의 `tabsequence=32766`(편집 불가)** 이다.
 *        화면에서 바꿀 수 있는 열(`receipt_type`·`label_type` 등)은 갱신 대상이 아니라
 *        타이핑해도 버려진다 → **무동작**이다 (266·245 와 같은 유형).
 *      · keyitem 검증 (협력사 롯트 4자·협력사코드 8자) — `ISYS_CONFIG` 에
 *        `RECEIPT_VENDOR_INFO_CHECK` 가 **없어서** PB 에서도 안 탄다.
 *      · 사운드(`f_play_sound`) — 웹은 토스트로 대체한다.
 * 8. **쓰기는 실행하지 않고 parse 로만 검증했다** (사용자 결정). 실제 대조가 맞는지는
 *    현장 확인이 필요하다.
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { likePrefix } from '@smt/shared';
import { limited, ROW_LIMIT } from '../../shared/row-limit';
import { TransactionService } from '../../shared/transaction.service';
import {
  BarcodeCompareQueryDto,
  BarcodeCompareReceiveDto,
  BarcodeReceiptHistoryQueryDto,
  BarcodeScanLookupDto,
} from './warehouse.dto';

type Row = Record<string, unknown>;

/**
 * PB 가 이 경로에서 고정으로 넣던 값. 235 의 `FIXED` 와 **따로 둔다** —
 * 파일 머리 2번의 표대로 네 곳이 다르다.
 */
const FIXED = {
  /** PB `lvd_unit_price` 가 미대입 상태로 들어간다 (실측 22만건이 0). */
  unitPrice: 0,
  exchangeRate: 1,
  /** 1 = 입고 */
  receiptDeficit: 1,
  delivery: 1,
  currency: 'WON',
  orderType: 'M',
  confirmYn: 'N',
  receiptStatus: 'N',
  virtualReceiptYn: 'N',
  interfaceYn: 'N',
  /** 235 는 'N' 인데 이 경로는 'Y' 다 (실측 CLOSE_YN='Y' 222,300건). */
  closeYn: 'Y',
  comments: '*',
  incidentalExpenseCode: '*',
  invoiceOpenYn: 'N',
} as const;

/** 바코드 이력·대조대기 목록이 공유하는 열. PB 두 DataWindow 의 컬럼 목록이 같다. */
const BARCODE_COLUMNS = `b.ITEM_BARCODE                    AS "itemBarcode",
       b.ITEM_CODE                       AS "itemCode",
       i.ITEM_NAME                       AS "itemName",
       i.ITEM_SPEC                       AS "itemSpec",
       b.LOT_NO                          AS "lotNo",
       b.SCAN_QTY                        AS "scanQty",
       TO_CHAR(b.SCAN_DATE, 'YYYY-MM-DD HH24:MI:SS')  AS "scanDate",
       b.RECEIPT_SLIP_NO                 AS "receiptSlipNo",
       b.SUPPLIER_CODE                   AS "supplierCode",
       F_GET_SUPPLIER_NAME(b.SUPPLIER_CODE, b.ORGANIZATION_ID) AS "supplierName",
       b.SUPPLIER_BARCODE                AS "supplierBarcode",
       b.SUPPLIER_ITEM_CODE              AS "supplierItemCode",
       b.RECEIPT_COMPARE_YN              AS "receiptCompareYn",
       TO_CHAR(b.RECEIPT_COMPARE_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "receiptCompareDate",
       b.RECEIPT_COMPARE_BY              AS "receiptCompareBy",
       b.BARCODE_STATUS                  AS "barcodeStatus",
       b.RECEIPT_TYPE                    AS "receiptType",
       b.FROM_SUPPLIER_CODE              AS "fromSupplierCode",
       b.LOT_DIVIDE_YN                   AS "lotDivideYn",
       b.ORIGIN_ITEM_BARCODE             AS "originItemBarcode",
       b.LABEL_TYPE                      AS "labelType",
       -- PB 는 이 두 열을 ID_ITEM 에서 끌어온다 (창고 번지·MSL 등급).
       -- LEFT JOIN 이므로 NVL 을 걸지 않는다 — 걸면 미등록 품목이 사라진다.
       i.LOCATION_ADDRESS                AS "locationAddress",
       i.MSL_LEVEL                       AS "mslLevel",
       b.ENTER_BY                        AS "enterBy",
       TO_CHAR(b.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')           AS "enterDate"`;

@Injectable()
export class BarcodeReceiptService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  // ───────────────────────────────── 조회

  /**
   * 대조 대기 목록 (PB `d_mat_rceipt_barcode_4_receipt_wait_lst`).
   *
   * **PB 고정조건 3개를 유지한다** — 빼면 대조할 수 없는 바코드가 목록에 섞인다:
   *   `LOT_DIVIDE_YN = 'N'`   분할된 롯트는 원본이 아니라 조각이다
   *   `RETURN_YN = 'N'`       반품된 것은 다시 입고하지 않는다
   *   `BARCODE_STATUS <> 'C'` 취소된 바코드
   */
  async findCompareWaiting(query: BarcodeCompareQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT ${BARCODE_COLUMNS}
         FROM IM_ITEM_RECEIPT_BARCODE b
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = b.ITEM_CODE
               AND i.ORGANIZATION_ID = b.ORGANIZATION_ID
        WHERE b.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND b.ITEM_BARCODE LIKE :barcode ESCAPE '\\'
          AND NVL(b.RECEIPT_COMPARE_YN, 'N') LIKE :receiptCompareYn ESCAPE '\\'
          AND b.LOT_NO LIKE :lotNo ESCAPE '\\'
          -- PB 고정조건 (위 주석 참고)
          AND NVL(b.LOT_DIVIDE_YN, 'N') = 'N'
          AND NVL(b.RETURN_YN, 'N') = 'N'
          AND NVL(b.BARCODE_STATUS, '*') <> 'C'
          AND b.ORGANIZATION_ID = :organizationId
        ORDER BY b.SCAN_DATE DESC, b.ITEM_BARCODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        itemCode: likePrefix(query.itemCode),
        barcode: likePrefix(query.barcode),
        receiptCompareYn: likePrefix(query.receiptCompareYn),
        lotNo: likePrefix(query.lotNo),
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /**
   * 바코드 전체 이력 (PB `d_mat_receipt_barcode_all_lst`).
   *
   * 대기 목록과 달리 **고정조건이 없다** — 취소·분할·반품된 것까지 다 보인다.
   * 그래서 "왜 대기 목록에 없나" 를 여기서 확인한다.
   */
  async findBarcodeHistory(query: BarcodeCompareQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT ${BARCODE_COLUMNS}
         FROM IM_ITEM_RECEIPT_BARCODE b
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = b.ITEM_CODE
               AND i.ORGANIZATION_ID = b.ORGANIZATION_ID
        WHERE b.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND b.ITEM_BARCODE LIKE :barcode ESCAPE '\\'
          AND b.LOT_NO LIKE :lotNo ESCAPE '\\'
          AND NVL(b.RECEIPT_SLIP_NO, '*') LIKE :slipNo ESCAPE '\\'
          AND b.ORGANIZATION_ID = :organizationId
        ORDER BY b.SCAN_DATE DESC, b.RECEIPT_SLIP_NO
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        itemCode: likePrefix(query.itemCode),
        barcode: likePrefix(query.barcode),
        lotNo: likePrefix(query.lotNo),
        slipNo: likePrefix(query.slipNo),
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /**
   * 입고 이력 (PB `d_mat_receipt_4_barcode_compare_lst`).
   *
   * 대조 결과로 들어간 입고 원장을 본다. 바코드 목록과 달리 **기간이 필수**다 —
   * `IM_ITEM_RECEIPT` 는 22만행/년 규모라 기간이 없으면 표 전체를 훑는다.
   */
  async findReceiptHistory(
    query: BarcodeReceiptHistoryQueryDto,
    organizationId: number,
  ) {
    const rows = (await this.dataSource.query(
      `SELECT r.RECEIPT_SEQUENCE            AS "receiptSequence",
              TO_CHAR(r.RECEIPT_DATE, 'YYYY-MM-DD')  AS "receiptDate",
              r.ITEM_CODE                   AS "itemCode",
              i.ITEM_NAME                   AS "itemName",
              i.ITEM_SPEC                   AS "itemSpec",
              r.RECEIPT_QTY                 AS "receiptQty",
              r.UNIT_PRICE                  AS "unitPrice",
              r.RECEIPT_AMT                 AS "receiptAmt",
              r.INVOICE_NO                  AS "invoiceNo",
              r.BARCODE                     AS "barcode",
              r.MATERIAL_MFS                AS "materialMfs",
              r.MFS                         AS "mfs",
              r.ORIGIN_MFS                  AS "originMfs",
              r.RECEIPT_LOT_NO              AS "receiptLotNo",
              r.LOCATION_CODE               AS "locationCode",
              r.LINE_TYPE                   AS "lineType",
              r.RECEIPT_TYPE                AS "receiptType",
              r.RECEIPT_STATUS              AS "receiptStatus",
              r.SUPPLIER_CODE               AS "supplierCode",
              s.SUPPLIER_NAME               AS "supplierName",
              r.ORIGIN_SUPPLIER_CODE        AS "originSupplierCode",
              r.FROM_SUPPLIER_CODE          AS "fromSupplierCode",
              r.CONFIRM_YN                  AS "confirmYn",
              r.INTERFACE_YN                AS "interfaceYn",
              r.CURRENCY                    AS "currency",
              r.ENTER_BY                    AS "enterBy",
              TO_CHAR(r.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')     AS "enterDate"
         FROM IM_ITEM_RECEIPT r
         LEFT JOIN ICOM_SUPPLIER s
                ON s.SUPPLIER_CODE = r.SUPPLIER_CODE
               AND s.ORGANIZATION_ID = r.ORGANIZATION_ID
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = r.ITEM_CODE
               AND i.ORGANIZATION_ID = r.ORGANIZATION_ID
        WHERE r.RECEIPT_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND r.RECEIPT_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND r.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND NVL(r.INVOICE_NO, '*') LIKE :slipNo ESCAPE '\\'
          AND NVL(r.MATERIAL_MFS, '*') LIKE :lotNo ESCAPE '\\'
          AND r.ORGANIZATION_ID = :organizationId
        ORDER BY r.INVOICE_NO, r.RECEIPT_DATE, r.RECEIPT_SEQUENCE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        itemCode: likePrefix(query.itemCode),
        slipNo: likePrefix(query.slipNo),
        lotNo: likePrefix(query.lotNo),
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /**
   * 발행됐지만 입고되지 않은 바코드 (PB `d_mat_no_receipt_issue_barcode_lst`, pb_1 버튼).
   *
   * PB 원본이 실행 가능한 SQL 로 저장돼 있어 그대로 옮긴다. 협력사 바코드는
   * 스캔 이력(`IB_SMT_CHECKHIST`)에서 끌어온다 — 아직 대조가 안 됐으니
   * 바코드 표에는 값이 없다.
   */
  async findNoReceiptIssued(organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT b.ITEM_BARCODE AS "itemBarcode",
              TO_CHAR(b.SCAN_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "scanDate",
              b.LOT_NO       AS "lotNo",
              b.SCAN_QTY     AS "scanQty",
              ( SELECT MAX(h.SCAN_SUPPLIER_PARTNAME)
                  FROM IB_SMT_CHECKHIST h
                 WHERE h.SCAN_PARTNAME = b.ITEM_BARCODE ) AS "supplierBarcode"
         FROM IM_ITEM_RECEIPT_BARCODE b
        WHERE NVL(b.RECEIPT_COMPARE_YN, 'N') = 'N'
          AND NVL(b.BARCODE_STATUS, '*') <> 'C'
          AND b.ORGANIZATION_ID = :organizationId
        ORDER BY b.SCAN_DATE DESC
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      { organizationId } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  // ───────────────────────────────── 스캔 해석 (읽기)

  /**
   * 스캔한 바코드를 풀어 본다.
   *
   * PB 가 바코드를 입력받은 직후 하는 일을 한 번에 한다:
   *   1. 바코드 → 품목코드·롯트번호·수량 (DB 함수 3개)
   *   2. 품목 기준정보 — 4M 변경(`ECO_CHECK_YN`) · 품목분류 · 협력사 롯트 요구 여부
   *   3. 바코드 원장 상태 — 전표번호·대조 여부·취소 여부
   *
   * **판정은 하지 않는다.** 화면이 이 결과로 입력칸을 열거나 경고를 띄운다.
   * 실제 거절은 쓰기 경로에서 다시 한다 (화면을 우회할 수 있으므로).
   */
  async lookupScan(dto: BarcodeScanLookupDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT F_GET_ITEM_CODE_FROM_BARCODE(:barcode)        AS "itemCode",
              F_GET_LOT_NO_FROM_BARCODE(:barcode)           AS "lotNo",
              TO_NUMBER(F_GET_LOT_QTY_FROM_BARCODE(:barcode)) AS "scanQty"
         FROM DUAL`,
      { barcode: dto.barcode } as unknown as unknown[],
    )) as Row[];
    const parsed = rows[0] ?? {};
    const itemCode = (parsed.itemCode as string) || '';

    // 협력사 바코드는 PB `_s` 변형으로 푼다. 협력사코드 자리는 NULL 로 둔다 —
    // 이 함수는 협력사로 못 찾으면 품번·포함관계로 다시 찾으므로 실측으로 같은 값이
    // 나온다 (`E1750100370` · `E1760400080-68J59652-40000` 둘 다 원장의 품목과 일치).
    // 못 푸는 바코드는 빈 값이 아니라 **엉뚱한 토막**을 돌려준다
    // (`ZZ-NOT-A-BARCODE` → `ZZ-NOT`) — 그래서 아래 비교가 그대로 불일치로 잡는다.
    let supplierItemCode: string | null = null;
    if (dto.supplierBarcode) {
      const sup = (await this.dataSource.query(
        `SELECT F_GET_ITEM_CODE_FROM_BARCODE_S(:supplierBarcode, NULL) AS "itemCode"
           FROM DUAL`,
        { supplierBarcode: dto.supplierBarcode } as unknown as unknown[],
      )) as Row[];
      supplierItemCode = (sup[0]?.itemCode as string) || null;
    }

    if (!itemCode) {
      return {
        ...parsed,
        supplierItemCode,
        item: null,
        barcodeRow: null,
        itemExists: false,
      };
    }

    const items = (await this.dataSource.query(
      `SELECT i.ITEM_CODE               AS "itemCode",
              i.ITEM_NAME               AS "itemName",
              i.ITEM_SPEC               AS "itemSpec",
              i.ITEM_CLASS              AS "itemClass",
              NVL(i.ECO_CHECK_YN, 'N')  AS "ecoCheckYn",
              i.ECO_CHECK_COMMENTS      AS "ecoCheckComments",
              -- 품목별 게이트다. ISYS_CONFIG 의 동명 설정과 **다른 것**이므로
              -- 섞으면 모든 품목이 협력사 롯트를 요구하게 된다.
              NVL(i.RECEIPT_LOT_CHECK_YN, 'N')      AS "receiptLotCheckYn",
              NVL(i.NO_CHECK_ORIGIN_SUPPLIER, 'N')  AS "noCheckOriginSupplier",
              NVL(i.KEYITEM_YN, 'N')    AS "keyitemYn",
              i.VENDOR_CODE1            AS "vendorCode1",
              i.VENDOR_CODE2            AS "vendorCode2",
              i.VENDOR_CODE3            AS "vendorCode3",
              F_GET_LINE_TYPE_FROM_ITEM(i.ITEM_CODE, i.ORGANIZATION_ID) AS "lineType",
              -- PB f_check_item_exists 를 그대로 인라인한 것이다 (파일 머리 5-1번).
              -- 같은 이름의 DB 함수는 세트 BOM 을 보는 **다른 함수**라 쓰면 안 된다.
              CASE WHEN i.DATESET <= TRUNC(SYSDATE)
                    AND i.DATEEND >= TRUNC(SYSDATE)
                   THEN 1 ELSE 0 END               AS "itemExistsFlag"
         FROM ID_ITEM i
        WHERE i.ITEM_CODE = :itemCode
          AND i.ORGANIZATION_ID = :organizationId`,
      { itemCode, organizationId } as unknown as unknown[],
    )) as Row[];

    const barcodeRows = (await this.dataSource.query(
      `SELECT b.RECEIPT_SLIP_NO                  AS "receiptSlipNo",
              b.SUPPLIER_CODE                    AS "supplierCode",
              NVL(b.RECEIPT_COMPARE_YN, 'N')     AS "receiptCompareYn",
              NVL(b.RECEIPT_TYPE, 'N')           AS "receiptType",
              b.FROM_SUPPLIER_CODE               AS "fromSupplierCode",
              b.LABEL_TYPE                       AS "labelType",
              b.INVENTORY_TYPE                   AS "inventoryType",
              b.BARCODE_STATUS                   AS "barcodeStatus",
              b.MANUFACTURE_WEEK                 AS "manufactureWeek",
              TO_CHAR(b.PCB_COATING_DATE, 'YYYY-MM-DD')  AS "pcbCoatingDate",
              TO_CHAR(b.MANUFACTURE_DATE, 'YYYY-MM-DD')  AS "manufactureDate",
              b.SCAN_QTY                         AS "ledgerQty"
         FROM IM_ITEM_RECEIPT_BARCODE b
        WHERE b.ITEM_CODE = :itemCode
          AND b.LOT_NO = :lotNo
          AND b.ORGANIZATION_ID = :organizationId`,
      {
        itemCode,
        lotNo: (parsed.lotNo as string) ?? '',
        organizationId,
      } as unknown as unknown[],
    )) as Row[];

    const item = items[0] ?? null;
    return {
      itemCode,
      lotNo: (parsed.lotNo as string) ?? null,
      scanQty: parsed.scanQty === null ? null : Number(parsed.scanQty ?? 0),
      supplierItemCode,
      /**
       * 협력사 바코드의 품목과 자사 바코드의 품목이 다르면 서로 다른 물건이다.
       * **협력사 바코드를 줬는데 품목이 안 풀린 경우도 불일치로 본다** — PB 는
       * `lvs_supplier_item_code <> lvs_item_code` 하나로 판정하므로 빈 값이면
       * 거절했다. null 을 "비교 못 함" 으로 두면 PB 가 막던 것이 웹에서 통과한다.
       */
      itemMatches: dto.supplierBarcode ? supplierItemCode === itemCode : null,
      item,
      itemExists: Number(item?.itemExistsFlag ?? 0) > 0,
      barcodeRow: barcodeRows[0] ?? null,
      /** 화면이 협력사 롯트 입력칸을 열어야 하는지. */
      needsSupplierLot: String(item?.receiptLotCheckYn ?? 'N') === 'Y',
    };
  }

  // ───────────────────────────────── 입고대조 (쓰기)

  /**
   * 입고대조 + 입고 기록 (**쓰기**). PB `wf_receipt_barcode('N')` 에 대응한다.
   *
   * 거절 조건은 PB 순서대로다. 화면이 이미 막았을 것이지만 화면을 우회할 수 있으므로
   * 서버가 다시 본다.
   */
  async compareAndReceive(
    dto: BarcodeCompareReceiveDto,
    organizationId: number,
    userId: string,
  ) {
    // PB: 협력사 바코드와 자사 바코드가 같으면 한 장을 두 번 스캔한 것이다.
    if (!dto.ignoreSupplierBarcode && dto.supplierBarcode === dto.barcode) {
      throw new BadRequestException(
        '협력사 바코드와 자사 바코드가 같습니다. 두 장을 각각 스캔하세요.',
      );
    }

    const lookup = await this.lookupScan(
      { barcode: dto.barcode, supplierBarcode: dto.supplierBarcode },
      organizationId,
    );
    if (!lookup.itemCode) {
      throw new BadRequestException(`바코드에서 품목을 찾을 수 없습니다: ${dto.barcode}`);
    }
    if (!lookup.lotNo) {
      throw new BadRequestException(`바코드에서 롯트번호를 찾을 수 없습니다: ${dto.barcode}`);
    }
    const scanQty = Number(lookup.scanQty ?? 0);
    if (!(scanQty > 0)) {
      throw new BadRequestException(`바코드 수량이 0 이하입니다: ${dto.barcode}`);
    }
    if (!lookup.itemExists) {
      throw new BadRequestException(`사용 중지된 품목입니다: ${lookup.itemCode}`);
    }
    if (lookup.itemMatches === false) {
      throw new BadRequestException(
        `협력사 바코드의 품목(${lookup.supplierItemCode})과`
        + ` 자사 바코드의 품목(${lookup.itemCode})이 다릅니다.`,
      );
    }

    const ledger = lookup.barcodeRow as Row | null;
    if (!ledger) {
      throw new BadRequestException(
        `발행 이력이 없는 바코드입니다: ${dto.barcode} (전표를 먼저 발행하세요)`,
      );
    }
    if (!ledger.receiptSlipNo) {
      throw new BadRequestException(`전표번호가 없는 바코드입니다: ${dto.barcode}`);
    }
    if (String(ledger.barcodeStatus ?? '') === 'C') {
      throw new BadRequestException(`취소된 바코드입니다: ${dto.barcode}`);
    }
    if (String(ledger.receiptCompareYn ?? 'N') === 'Y') {
      throw new BadRequestException(`이미 입고대조된 바코드입니다: ${dto.barcode}`);
    }

    const item = lookup.item as Row | null;
    const itemClass = String(item?.itemClass ?? '');
    if (String(item?.receiptLotCheckYn ?? 'N') === 'Y' && !dto.supplierLotNo) {
      throw new BadRequestException(
        `이 품목은 협력사 롯트번호가 필요합니다: ${lookup.itemCode}`,
      );
    }
    // PB: PCB 는 제조주차와 코팅일이 바코드 원장에 있어야 입고할 수 있다.
    // PCB 가 아니면 비어 있어도 되고, 그때는 오늘 주차를 넣는다.
    const isPcb = itemClass === 'PCB';
    if (isPcb && !ledger.manufactureWeek) {
      throw new BadRequestException('PCB 는 제조주차가 있어야 입고할 수 있습니다.');
    }
    if (isPcb && !ledger.pcbCoatingDate) {
      throw new BadRequestException('PCB 는 코팅일이 있어야 입고할 수 있습니다.');
    }

    // PB: 라벨유형 'R' 은 재생릴이라 창고가 다르다.
    const locationCode = String(ledger.labelType ?? '') === 'R' ? 'M06' : 'M01';

    return this.tx.run(async (qr) => {
      // **확인-후-실행 틈을 여기서 막는다** (파일 머리 4번). 조건이 UPDATE 안에 있으므로
      // 동시에 두 번 스캔되면 한쪽만 1행을 바꾸고 다른 쪽은 0행이 된다.
      const updateResult = await qr.query(
        `UPDATE IM_ITEM_RECEIPT_BARCODE
            SET RECEIPT_COMPARE_YN   = 'Y',
                RECEIPT_COMPARE_DATE = SYSDATE,
                RECEIPT_COMPARE_BY   = :userId,
                SUPPLIER_BARCODE     = :supplierBarcode,
                RETURN_YN            = 'N',
                RETURN_DATE          = NULL,
                VENDOR_LOTNO         = :supplierLotNo,
                VENDOR_CODE          = :originSupplierCode,
                MANUFACTURE_WEEK     = NVL(MANUFACTURE_WEEK, TO_CHAR(SYSDATE, 'YYWW')),
                LAST_MODIFY_DATE     = SYSDATE,
                LAST_MODIFY_BY       = :userId
          WHERE ITEM_CODE = :itemCode
            AND LOT_NO = :lotNo
            AND ORGANIZATION_ID = :organizationId
            AND NVL(RECEIPT_COMPARE_YN, 'N') <> 'Y'
            AND NVL(BARCODE_STATUS, '*') <> 'C'`,
        {
          userId,
          supplierBarcode: dto.supplierBarcode,
          supplierLotNo: dto.supplierLotNo ?? null,
          originSupplierCode: dto.originSupplierCode ?? null,
          itemCode: lookup.itemCode,
          lotNo: lookup.lotNo,
          organizationId,
        } as unknown as unknown[],
      );
      const compared = Number(
        (updateResult as { rowsAffected?: number })?.rowsAffected ?? 0,
      );
      if (compared !== 1) {
        throw new BadRequestException(
          `대조 대상이 아닙니다 (이미 대조됐거나 취소됨): ${dto.barcode}`,
        );
      }

      // PB `f_get_any_no('RECEIPT_LOT_NO')` — PB 함수는 이 DB 함수를 감싼 껍데기뿐이다.
      const anyNo = (await qr.query(
        `SELECT F_GET_ANY_NO('RECEIPT_LOT_NO', :organizationId) AS "no",
                NVL(:manufactureWeek, TO_CHAR(SYSDATE, 'YYWW')) AS "week"
           FROM DUAL`,
        {
          organizationId,
          manufactureWeek: (ledger.manufactureWeek as string) ?? null,
        } as unknown as unknown[],
      )) as Row[];

      const receiptSeq = (await qr.query(
        `SELECT SEQ_MAT_RECEIPT.NEXTVAL AS "seq" FROM DUAL`,
      )) as Row[];

      const receiptResult = await qr.query(
        `INSERT INTO IM_ITEM_RECEIPT
           (RECEIPT_SEQUENCE, RECEIPT_DATE, ORGANIZATION_ID, LOCATION_CODE,
            DELIVERY, RECEIPT_DEFICIT, LINE_TYPE, RECEIPT_QTY,
            MATERIAL_COST, UNIT_PRICE, MATERIAL_COST_AMT,
            ENTER_DATE, INVOICE_NO, RECEIPT_AMT, ENTER_BY,
            EXCHANGE_RATE, FOREIGN_RECEIPT_AMT, SUPPLIER_CODE,
            LAST_MODIFY_DATE, LAST_MODIFY_BY, CONFIRM_YN, CONFIRM_DATE,
            RECEIPT_TYPE, MFS, ARRIVAL_SEQ_NO, VIRTUAL_RECEIPT_YN, COMMENTS,
            CURRENCY, BARCODE, RECEIPT_STATUS, ITEM_CODE, MATERIAL_MFS,
            INTERFACE_YN, RECEIPT_LOT_NO, RECEIPT_EXPENSE_COST,
            INCIDENTAL_EXPENSE_CODE, TARIFF_RATE, TARIFF_AMT, ORDER_NO,
            ORIGIN_MFS, ORIGIN_SUPPLIER_CODE, ORDER_TYPE, CONFIRM_BY,
            INVOICE_OPEN_YN, INVOICE_OPEN_SEQUENCE, CLOSE_YN,
            FROM_SUPPLIER_CODE, MANUFACTURE_WEEK, INVENTORY_TYPE,
            PCB_COATING_DATE, MANUFACTURE_DATE)
         VALUES
           (:receiptSequence, TRUNC(SYSDATE), :organizationId, :locationCode,
            ${FIXED.delivery}, ${FIXED.receiptDeficit}, :lineType, :scanQty,
            0, ${FIXED.unitPrice}, 0,
            SYSDATE, :slipNo, :scanQty * ${FIXED.unitPrice}, :userId,
            ${FIXED.exchangeRate}, 0, :supplierCode,
            SYSDATE, :userId, '${FIXED.confirmYn}', TRUNC(SYSDATE),
            :receiptType, :supplierLotNo, 0, '${FIXED.virtualReceiptYn}',
            '${FIXED.comments}',
            '${FIXED.currency}', :barcode, '${FIXED.receiptStatus}',
            :itemCode, :lotNo,
            '${FIXED.interfaceYn}', :receiptLotNo, 0,
            '${FIXED.incidentalExpenseCode}', 0, 0, 0,
            :supplierBarcode, :originSupplierCode, '${FIXED.orderType}', :userId,
            '${FIXED.invoiceOpenYn}', 0, '${FIXED.closeYn}',
            :fromSupplierCode, :manufactureWeek, :inventoryType,
            TO_DATE(:coatingDate, 'YYYY-MM-DD'),
            TO_DATE(:manufactureDate, 'YYYY-MM-DD'))`,
        {
          receiptSequence: Number(receiptSeq[0]?.seq ?? 0),
          organizationId,
          locationCode,
          lineType: (item?.lineType as string) ?? null,
          scanQty,
          slipNo: ledger.receiptSlipNo as string,
          userId,
          supplierCode: (ledger.supplierCode as string) ?? null,
          receiptType: (ledger.receiptType as string) ?? 'N',
          supplierLotNo: dto.supplierLotNo ?? null,
          barcode: dto.barcode,
          itemCode: lookup.itemCode,
          lotNo: lookup.lotNo,
          receiptLotNo: (anyNo[0]?.no as string) ?? null,
          supplierBarcode: dto.supplierBarcode,
          originSupplierCode: dto.originSupplierCode ?? null,
          fromSupplierCode: (ledger.fromSupplierCode as string) ?? null,
          manufactureWeek: (anyNo[0]?.week as string) ?? null,
          inventoryType: (ledger.inventoryType as string) ?? null,
          coatingDate: (ledger.pcbCoatingDate as string) ?? null,
          manufactureDate: (ledger.manufactureDate as string) ?? null,
        } as unknown as unknown[],
      );

      return {
        barcode: dto.barcode,
        supplierBarcode: dto.supplierBarcode,
        itemCode: lookup.itemCode,
        lotNo: lookup.lotNo,
        receiptQty: scanQty,
        slipNo: ledger.receiptSlipNo as string,
        locationCode,
        comparedRows: compared,
        receiptRows: Number(
          (receiptResult as { rowsAffected?: number })?.rowsAffected ?? 0,
        ),
      };
    });
  }
}
