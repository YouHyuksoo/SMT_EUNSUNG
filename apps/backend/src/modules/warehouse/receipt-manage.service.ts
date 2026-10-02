/**
 * @file src/modules/warehouse/receipt-manage.service.ts
 * @description 253 자재입고관리 · 254 자재기타입고관리 — PB `w_mat_receipt_master` ·
 *              `w_mat_other_receipt_master` 이식 (254 는 **쓰기**)
 *
 * 초보자 가이드:
 * 1. **두 화면 다 `IM_ITEM_RECEIPT`(입고 원장) 를 다룬다.** 235·237·243 이 바코드로
 *    입고를 만들었다면 여기는 **바코드 없이** 사람이 직접 넣고 고치는 자리다.
 * 2. **253 은 이 현장에서 등록을 할 수 없다.** PB 의 등록 그리드(`dw_2`)는 조회식이
 *    없고(`where=0`) 왼쪽 **입고예정 트리에서 고른 행으로만** 채워지는데, 그 트리가 읽는
 *    `IM_ITEM_ARRIVAL` 이 **0행**이다 (실측). 그 표를 채우는 PB 창은 구매발주·반품 쪽인데
 *    이 현장에서는 쓰이지 않는다. 그래서 253 은 **입고 이력 조회**로 옮긴다 —
 *    빈 등록 화면을 만들면 "왜 아무것도 안 나오나" 로 현장이 헷갈린다.
 * 3. **253 의 `dw_3.update()` 는 무동작이다.** 대상 표는 `IM_ITEM_RECEIPT` 지만 갱신
 *    가능한 6개 열(receipt_date·unit_price·receipt_amt·exchange_rate·
 *    foreign_receipt_amt·receipt_lot_no)이 전부 편집 불가이고, 편집 가능한 열은
 *    선택용 `check_yn` 뿐인데 그건 갱신 대상이 아니다 (237 `dw_4` 와 같은 유형).
 * 4. **254 는 현재고에서 골라 입고(또는 차감)를 만든다.** 재고 목록에서 품목을 고르고
 *    수량을 넣으면 입고 원장에 한 건이 들어간다.
 *    **수량이 음수면 차감이다** — PB 가 `RECEIPT_DEFICIT` 을 수량 부호로 정한다
 *    (`if receipt_qty < 0 then '2' else '1'`). 실측이 정확히 그렇다:
 *    유형 'E' 1,829건 중 음수 1,778건이 전부 deficit 2, 양수 51건이 전부 deficit 1.
 * 5. **고칠 수 있는 열을 화이트리스트로 못 박았다.** PB DataWindow 가 실제로 갱신하는
 *    열만 받는다 — 문장에 없는 열은 애초에 바뀌지 않는다.
 *      253 목록은 이관하지 않지만 참고로, PB 가 고칠 수 있게 둔 20개 열에
 *      **수량·단가·품목·협력사가 없다** (부대비용·창고·도착정보·전송표시뿐).
 *      254 는 22개 열이 편집 가능하고 여기에도 **수량이 없다** — 수량은 재고 목록에서
 *      가져오는 값이라 등록할 때만 정해진다.
 * 6. **소진 여부로 막을 방법이 없다** (실측). 마감·재고 기준 표
 *    (`IM_ITEM_RECEIPT_4_BASE_INV` · `IM_ITEM_RECEIPT_LEDGER_REGEN` ·
 *    `IM_ITEM_INVENTORY_BARCODE`)가 **전부 0행**이고, `CONFIRM_YN` 은 설정상
 *    모든 행이 'N' 이라 갈라 주지 못한다. 그래서 **범위를 좁히는 쪽**으로 막았다:
 *      · 수정·삭제는 `RECEIPT_TYPE='E'` (이 화면이 만든 기타입고)만 대상으로 한다
 *      · 바코드로 만들어진 행(`BARCODE IS NOT NULL`)은 건드리지 않는다
 *      · WHERE 는 진짜 기본키 3개로 건다 (`RECEIPT_DATE`·`RECEIPT_SEQUENCE`·
 *        `ORGANIZATION_ID` — 실측 `XPKIM_ITEM_RECEIPT`)
 *    **이미 출고된 입고분을 고치는 것을 막지는 못한다** — 현장 확인이 필요하다.
 * 7. **인쇄 DataWindow(`d_mat_receipt_invoice_rpt`, 거래명세서)는 옮기지 않는다.**
 *    PB 런타임 인쇄 유틸이다.
 * 8. **쓰기는 실행하지 않고 parse 로만 검증했다** (사용자 결정).
 */
import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { likePrefix } from '@smt/shared';
import { limited, ROW_LIMIT } from '../../shared/row-limit';
import { TransactionService } from '../../shared/transaction.service';
import {
  EtcReceiptCreateDto,
  EtcReceiptKeyDto,
  EtcReceiptUpdateDto,
  ReceiptHistoryQueryDto,
  ReceiptInventoryQueryDto,
} from './warehouse.dto';
import { affectedRows } from '../../common/utils/affected-rows.util';
import { namedBinds } from '../../common/utils/named-binds.util';

type Row = Record<string, unknown>;

/**
 * 254 등록 시 PB 가 고정으로 넣던 값.
 *
 * `CURRENCY` 는 하드코딩이 아니라 `ISYS_CONFIG.CURRENCY` 다 (PB `GVS_CURRENCY`).
 * 실측값이 `KRW` 이고 유형 'E' 입고 649건이 전부 `KRW` 라 일치한다 —
 * 235·237 이 쓰는 `'WON'` 과 다르다는 점에 주의한다.
 */
const FIXED = {
  /** '2' = 기타 (PB `DELIVERY='2'`). 실측 'E' 입고 전부 2. */
  delivery: '2',
  exchangeRate: 1,
  receiptStatus: 'N',
  virtualReceiptYn: 'N',
  interfaceYn: 'N',
  orderType: 'M',
  /** 'E' = 기타입고. PB 는 재생릴 체크 시 'R' 을 쓰지만 실데이터에 'R' 이 0건이다. */
  receiptType: 'E',
  mfs: '*',
  orderNo: '*',
} as const;

/**
 * 254 에서 고칠 수 있는 열. **PB DataWindow 가 실제로 갱신하는 열만** 담았다
 * (`d_mat_receipt_mst` 의 편집 가능 ∩ 갱신 대상 22개 중 의미 있는 것).
 *
 * 키는 요청 필드 이름, 값은 컬럼 이름이다. 여기 없는 열은 문장에 들어가지 않으므로
 * 요청이 무엇을 보내든 바뀌지 않는다.
 */
const UPDATABLE = {
  itemCode: 'ITEM_CODE',
  lineType: 'LINE_TYPE',
  locationCode: 'LOCATION_CODE',
  materialMfs: 'MATERIAL_MFS',
  mfs: 'MFS',
  invoiceNo: 'INVOICE_NO',
  receiptLotNo: 'RECEIPT_LOT_NO',
  unitPrice: 'UNIT_PRICE',
  currency: 'CURRENCY',
  exchangeRate: 'EXCHANGE_RATE',
  orderNo: 'ORDER_NO',
  orderType: 'ORDER_TYPE',
  originSupplierCode: 'ORIGIN_SUPPLIER_CODE',
  incidentalExpenseCode: 'INCIDENTAL_EXPENSE_CODE',
  tariffRate: 'TARIFF_RATE',
  tariffAmt: 'TARIFF_AMT',
  comments: 'COMMENTS',
} as const;

/** 입고 원장 한 줄에서 화면이 쓰는 열. 253·254 이력이 공유한다. */
const RECEIPT_COLUMNS = `TO_CHAR(r.RECEIPT_DATE, 'YYYY-MM-DD')  AS "receiptDate",
       r.RECEIPT_SEQUENCE            AS "receiptSequence",
       r.ITEM_CODE                   AS "itemCode",
       i.ITEM_NAME                   AS "itemName",
       i.ITEM_SPEC                   AS "itemSpec",
       i.ITEM_UOM                    AS "itemUom",
       r.RECEIPT_QTY                 AS "receiptQty",
       r.RECEIPT_DEFICIT             AS "receiptDeficit",
       r.UNIT_PRICE                  AS "unitPrice",
       r.RECEIPT_AMT                 AS "receiptAmt",
       r.CURRENCY                    AS "currency",
       r.EXCHANGE_RATE               AS "exchangeRate",
       r.INVOICE_NO                  AS "invoiceNo",
       r.RECEIPT_LOT_NO              AS "receiptLotNo",
       r.LOCATION_CODE               AS "locationCode",
       r.MATERIAL_MFS                AS "materialMfs",
       r.MFS                         AS "mfs",
       r.BARCODE                     AS "barcode",
       r.LINE_TYPE                   AS "lineType",
       r.RECEIPT_TYPE                AS "receiptType",
       r.RECEIPT_STATUS              AS "receiptStatus",
       r.DELIVERY                    AS "delivery",
       r.SUPPLIER_CODE               AS "supplierCode",
       F_GET_SUPPLIER_NAME(r.SUPPLIER_CODE, r.ORGANIZATION_ID) AS "supplierName",
       r.ORIGIN_SUPPLIER_CODE        AS "originSupplierCode",
       r.ORDER_NO                    AS "orderNo",
       r.ORDER_TYPE                  AS "orderType",
       r.INCIDENTAL_EXPENSE_CODE     AS "incidentalExpenseCode",
       r.TARIFF_RATE                 AS "tariffRate",
       r.TARIFF_AMT                  AS "tariffAmt",
       r.CONFIRM_YN                  AS "confirmYn",
       r.INTERFACE_YN                AS "interfaceYn",
       r.COMMENTS                    AS "comments",
       r.ENTER_BY                    AS "enterBy",
       TO_CHAR(r.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')          AS "enterDate"`;

@Injectable()
export class ReceiptManageService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  // ───────────────────────────────── 조회 (253 · 254 공용)

  /**
   * 입고 이력 (PB `d_mat_receipt_hst` — 253·254 가 같은 DataWindow 를 쓴다).
   *
   * PB 조건을 그대로 둔다. 전표번호와 창고는 `NVL(..., '*')` 로 감싸는데,
   * **LEFT JOIN 컬럼이 아니라 NULL 이 들어 있는 열이라** 감싸지 않으면 NULL 행이 빠진다.
   */
  async findHistory(query: ReceiptHistoryQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT ${RECEIPT_COLUMNS}
         FROM IM_ITEM_RECEIPT r
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = r.ITEM_CODE
               AND i.ORGANIZATION_ID = r.ORGANIZATION_ID
        WHERE r.RECEIPT_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND r.RECEIPT_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND r.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND NVL(r.MATERIAL_MFS, '*') LIKE :materialMfs ESCAPE '\\'
          AND NVL(r.SUPPLIER_CODE, '*') LIKE :supplierCode ESCAPE '\\'
          AND NVL(r.LOCATION_CODE, '*') LIKE :locationCode ESCAPE '\\'
          AND NVL(r.INVOICE_NO, '*') LIKE :invoiceNo ESCAPE '\\'
          AND NVL(r.RECEIPT_TYPE, '*') LIKE :receiptType ESCAPE '\\'
          AND r.ORGANIZATION_ID = :organizationId
        ORDER BY r.RECEIPT_DATE DESC, r.RECEIPT_SEQUENCE DESC
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        itemCode: likePrefix(query.itemCode),
        materialMfs: likePrefix(query.materialMfs),
        supplierCode: likePrefix(query.supplierCode),
        locationCode: likePrefix(query.locationCode),
        invoiceNo: likePrefix(query.invoiceNo),
        receiptType: likePrefix(query.receiptType),
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }

  /**
   * 254 현재고 목록 (PB `d_mat_curr_inventory_4_etc_receipt_lst`).
   *
   * 여기서 품목을 골라 기타입고를 만든다. 협력사코드는 PB 와 같이 DB 함수가 붙인다 —
   * 재고 표에는 협력사가 없고 품목·구매유형으로 정해지기 때문이다.
   *
   * **이 목록은 편집할 수 없다.** PB DataWindow 가 `IM_ITEM_INVENTORY` 를 갱신 대상으로
   * 두지만 편집 가능한 세 열(`check_yn`·`receipt_qty`·창고번지)이 모두 갱신 대상이
   * 아니다 — 입력용 칸일 뿐이다 (실측).
   *
   * **PB 는 `IM_ITEM_RECYCLE_INVENTORY`(재생 재고)를 UNION ALL 로 붙인다.**
   * 그 표가 **0행**이라 붙이지 않았다 (실측). 재생 재고를 쓰기 시작하면 그때
   * `WAREHOUSE_TYPE` 열과 함께 되살린다 — PB 의 재생 입고(`RECEIPT_TYPE='R'`)도
   * 실데이터가 0건이라 같은 이유로 빠져 있다.
   */
  async findInventory(query: ReceiptInventoryQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT v.ITEM_CODE                        AS "itemCode",
              i.ITEM_NAME                        AS "itemName",
              i.ITEM_SPEC                        AS "itemSpec",
              i.ITEM_TYPE                        AS "itemType",
              i.ITEM_UOM                         AS "itemUom",
              i.LOCATION_ADDRESS                 AS "locationAddress",
              v.LINE_TYPE                        AS "lineType",
              F_GET_SUPPLIER_CODE_BY_ITEM(v.ITEM_CODE, v.LINE_TYPE, v.ORGANIZATION_ID)
                                                 AS "supplierCode",
              v.INVENTORY_QTY                    AS "inventoryQty",
              v.INVENTORY_PRICE                  AS "inventoryPrice",
              v.INVENTORY_AMT                    AS "inventoryAmt",
              v.INVENTORY_STATUS                 AS "inventoryStatus",
              v.INVENTORY_HOLD                   AS "inventoryHold",
              v.LOCATION_CODE                    AS "locationCode",
              v.MATERIAL_MFS                     AS "materialMfs",
              v.COMMENTS                         AS "comments"
         FROM IM_ITEM_INVENTORY v
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = v.ITEM_CODE
               AND i.ORGANIZATION_ID = v.ORGANIZATION_ID
        WHERE v.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND NVL(v.MATERIAL_MFS, '*') LIKE :materialMfs ESCAPE '\\'
          AND NVL(v.LOCATION_CODE, '*') LIKE :locationCode ESCAPE '\\'
          -- PB 라디오버튼을 그대로 옮긴 식이다: '재고 있는 것' 이면 1, '전체' 면 -2 를
          -- 넘긴다 (PB lvi_sign).
          AND SIGN(v.INVENTORY_QTY) >= :sign
          AND v.ORGANIZATION_ID = :organizationId
        ORDER BY v.ITEM_CODE, v.LOCATION_CODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        itemCode: likePrefix(query.itemCode),
        materialMfs: likePrefix(query.materialMfs),
        locationCode: likePrefix(query.locationCode),
        // 기본은 '재고 있는 것' 이다. 전체는 1,837,572행이라 상한에서 잘린 임의의
        // 10,000행이 되고 실측 7.6초가 걸린다 (재고 있는 것은 3,446행 / 1.2초).
        sign: query.includeZero ? -2 : 1,
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }

  /**
   * 253 입고예정 목록 (PB `d_mat_arrival_4_receipt_lst_tree`).
   *
   * **이 현장에서는 항상 비어 있다** — `IM_ITEM_ARRIVAL` 이 0행이다 (실측).
   * 화면이 "왜 안 나오나" 를 알 수 있게 구조는 남긴다.
   */
  async findArrivals(query: ReceiptHistoryQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT TO_CHAR(a.ARRIVAL_DATE, 'YYYY-MM-DD') AS "arrivalDate",
              a.ARRIVAL_SEQ_NO                 AS "arrivalSeqNo",
              a.ITEM_CODE                      AS "itemCode",
              i.ITEM_NAME                      AS "itemName",
              i.ITEM_SPEC                      AS "itemSpec",
              a.ARRIVAL_QTY                    AS "arrivalQty",
              a.ARRIVAL_STATUS                 AS "arrivalStatus",
              a.ARRIVAL_TYPE                   AS "arrivalType",
              a.UNIT_PRICE                     AS "unitPrice",
              a.ARRIVAL_AMT                    AS "arrivalAmt",
              -- 입고로 넘어간 건은 이 두 열이 채워진다.
              TO_CHAR(a.RECEIPT_DATE, 'YYYY-MM-DD') AS "receiptDate",
              a.RECEIPT_SEQUENCE               AS "receiptSequence",
              a.SUPPLIER_CODE                  AS "supplierCode",
              F_GET_SUPPLIER_NAME(a.SUPPLIER_CODE, a.ORGANIZATION_ID) AS "supplierName",
              a.INVOICE_NO                     AS "invoiceNo",
              a.MATERIAL_MFS                   AS "materialMfs",
              a.LINE_TYPE                      AS "lineType",
              a.ORDER_NO                       AS "orderNo",
              a.INSPECT_RESULT                 AS "inspectResult",
              a.ENTER_BY                       AS "enterBy",
              TO_CHAR(a.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')         AS "enterDate"
         FROM IM_ITEM_ARRIVAL a
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = a.ITEM_CODE
               AND i.ORGANIZATION_ID = a.ORGANIZATION_ID
        WHERE a.ARRIVAL_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND a.ARRIVAL_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND a.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND NVL(a.SUPPLIER_CODE, '*') LIKE :supplierCode ESCAPE '\\'
          AND NVL(a.INVOICE_NO, '*') LIKE :invoiceNo ESCAPE '\\'
          AND a.ORGANIZATION_ID = :organizationId
        ORDER BY a.ARRIVAL_DATE DESC, a.ARRIVAL_SEQ_NO
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        itemCode: likePrefix(query.itemCode),
        supplierCode: likePrefix(query.supplierCode),
        invoiceNo: likePrefix(query.invoiceNo),
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }

  // ───────────────────────────────── 254 등록·수정·삭제 (쓰기)

  /**
   * 기타입고 등록 (**쓰기**). PB `ue_data_control` 의 `'INSERT'` + `'UPDATE'` 한 쌍이다.
   *
   * **수량이 음수면 차감이다.** PB 가 `RECEIPT_DEFICIT` 을 수량 부호로 정하므로
   * 그대로 따른다 (실측 유형 'E' 1,829건이 정확히 그 규칙을 따른다).
   */
  async createEtcReceipt(
    dto: EtcReceiptCreateDto,
    organizationId: number,
    userId: string,
  ) {
    const qty = Number(dto.receiptQty);
    if (!Number.isFinite(qty) || qty === 0) {
      throw new BadRequestException('수량은 0 이 아닌 값이어야 합니다 (음수는 차감).');
    }

    return this.tx.run(async (qr) => {
      const items = (await qr.query(
        `SELECT i.ITEM_CODE AS "itemCode",
                i.LINE_TYPE AS "lineType"
           FROM ID_ITEM i
          WHERE i.ITEM_CODE = :itemCode
            AND i.ORGANIZATION_ID = :organizationId`,
        namedBinds({ itemCode: dto.itemCode, organizationId }),
      )) as Row[];
      if (items.length === 0) {
        throw new BadRequestException(`품목을 찾을 수 없습니다: ${dto.itemCode}`);
      }

      const meta = (await qr.query(
        `SELECT SEQ_MAT_RECEIPT.NEXTVAL                          AS "receiptSequence",
                F_GET_ANY_NO('RECEIPT_LOT_NO', :organizationId)  AS "receiptLotNo",
                TO_CHAR(SYSDATE, 'YYYYMMDD')                     AS "today",
                -- PB GVS_CURRENCY 는 설정값이다 (실측 'KRW'). 235·237 의 'WON' 과 다르다.
                NVL((SELECT c.CONFIG_VALUE FROM ISYS_CONFIG c
                      WHERE c.CONFIG_NAME = 'CURRENCY'
                        AND c.ORGANIZATION_ID = :organizationId), 'KRW') AS "currency",
                NVL((SELECT c.CONFIG_VALUE FROM ISYS_CONFIG c
                      WHERE c.CONFIG_NAME = 'MATERIAL_RECEIPT_AUTO_CONFIRM'
                        AND c.ORGANIZATION_ID = :organizationId), 'N')   AS "autoConfirm"
           FROM DUAL`,
        namedBinds({ organizationId }),
      )) as Row[];
      const receiptSequence = Number(meta[0]?.receiptSequence ?? 0);
      const autoConfirm = String(meta[0]?.autoConfirm ?? 'N') === 'Y' ? 'Y' : 'N';
      // PB `cbx_auto_invoice` 가 켜져 있을 때의 형식이다 (실측 전표번호가 전부 이 꼴).
      const invoiceNo = dto.invoiceNo || `${meta[0]?.today ?? ''}${receiptSequence}`;

      const result = await qr.query(
        `INSERT INTO IM_ITEM_RECEIPT
           (RECEIPT_DATE, RECEIPT_SEQUENCE, ORGANIZATION_ID,
            ITEM_CODE, LINE_TYPE, SUPPLIER_CODE, LOCATION_CODE, MATERIAL_MFS, MFS,
            RECEIPT_QTY, RECEIPT_DEFICIT, DELIVERY, UNIT_PRICE, RECEIPT_AMT,
            MATERIAL_COST, MATERIAL_COST_AMT, FOREIGN_RECEIPT_AMT,
            CURRENCY, EXCHANGE_RATE, INVOICE_NO, RECEIPT_LOT_NO,
            RECEIPT_TYPE, RECEIPT_STATUS, VIRTUAL_RECEIPT_YN, INTERFACE_YN,
            ORDER_NO, ORDER_TYPE, COMMENTS,
            CONFIRM_YN, CONFIRM_DATE, CONFIRM_BY,
            ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
         VALUES
           (TRUNC(SYSDATE), :receiptSequence, :organizationId,
            :itemCode, :lineType, :supplierCode, :locationCode, :materialMfs,
            '${FIXED.mfs}',
            :receiptQty,
            -- 수량 부호가 입고/차감을 정한다 (PB 그대로).
            DECODE(SIGN(:receiptQty), -1, 2, 1),
            '${FIXED.delivery}', :unitPrice, :receiptQty * :unitPrice,
            0, 0, 0,
            :currency, ${FIXED.exchangeRate}, :invoiceNo, :receiptLotNo,
            '${FIXED.receiptType}', '${FIXED.receiptStatus}',
            '${FIXED.virtualReceiptYn}', '${FIXED.interfaceYn}',
            '${FIXED.orderNo}', '${FIXED.orderType}', :comments,
            :confirmYn, DECODE(:confirmYn, 'Y', TRUNC(SYSDATE), NULL),
            DECODE(:confirmYn, 'Y', :userId, NULL),
            SYSDATE, :userId, SYSDATE, :userId)`,
        namedBinds({
          receiptSequence,
          organizationId,
          itemCode: dto.itemCode,
          lineType: dto.lineType ?? (items[0].lineType as string) ?? null,
          supplierCode: dto.supplierCode ?? null,
          locationCode: dto.locationCode ?? null,
          materialMfs: dto.materialMfs ?? '*',
          receiptQty: qty,
          unitPrice: Number(dto.unitPrice ?? 0),
          currency: dto.currency ?? (meta[0]?.currency as string),
          invoiceNo,
          receiptLotNo: dto.receiptLotNo ?? (meta[0]?.receiptLotNo as string) ?? null,
          comments: dto.comments ?? null,
          confirmYn: autoConfirm,
          userId,
        }),
      );

      return {
        receiptSequence,
        itemCode: dto.itemCode,
        receiptQty: qty,
        /** 1 = 입고 · 2 = 차감 */
        receiptDeficit: qty < 0 ? 2 : 1,
        invoiceNo,
        confirmYn: autoConfirm,
        rows: Number(affectedRows(result) ?? 0),
      };
    });
  }

  /**
   * 기타입고 수정 (**쓰기**).
   *
   * 화이트리스트에 있는 열만 문장에 들어간다. `RECEIPT_TYPE='E'` 이고 바코드로 만들어진
   * 행이 아닌 것만 대상이다 (파일 머리 6번).
   */
  async updateEtcReceipt(
    dto: EtcReceiptUpdateDto,
    organizationId: number,
    userId: string,
  ) {
    const sets: string[] = [];
    const binds: Record<string, unknown> = {
      receiptDate: dto.receiptDate,
      receiptSequence: dto.receiptSequence,
      organizationId,
      userId,
    };
    for (const [field, column] of Object.entries(UPDATABLE)) {
      const value = Object.fromEntries(Object.entries(dto))[field];
      if (value === undefined) continue;
      sets.push(`${column} = :${field}`);
      binds[field] = value === '' ? null : value;
    }
    if (sets.length === 0) {
      throw new BadRequestException('바꿀 항목이 없습니다.');
    }
    // 단가를 바꾸면 금액도 따라가야 한다 — 따로 두면 둘이 어긋난다.
    if (dto.unitPrice !== undefined) {
      sets.push('RECEIPT_AMT = RECEIPT_QTY * :unitPrice');
    }

    return this.tx.run(async (qr) => {
      const result = await qr.query(
        `UPDATE IM_ITEM_RECEIPT
            SET ${sets.join(',\n                ')},
                LAST_MODIFY_DATE = SYSDATE,
                LAST_MODIFY_BY = :userId
          WHERE RECEIPT_DATE = TO_DATE(:receiptDate, 'YYYY-MM-DD')
            AND RECEIPT_SEQUENCE = :receiptSequence
            AND ORGANIZATION_ID = :organizationId
            -- 이 화면이 만든 기타입고만 건드린다 (파일 머리 6번).
            AND RECEIPT_TYPE = '${FIXED.receiptType}'
            AND BARCODE IS NULL`,
        namedBinds(binds),
      );
      const rows = Number(affectedRows(result) ?? 0);
      if (rows !== 1) {
        throw new NotFoundException(
          `고칠 수 있는 기타입고가 아닙니다 (${dto.receiptDate} / ${dto.receiptSequence}).`
          + ' 바코드로 만들어진 입고이거나 이미 없는 건입니다.',
        );
      }
      return { ...dto, rows, changed: Object.keys(binds).length };
    });
  }

  /** 기타입고 삭제 (**쓰기**). 수정과 같은 범위 제한을 건다. */
  async deleteEtcReceipt(dto: EtcReceiptKeyDto, organizationId: number) {
    return this.tx.run(async (qr) => {
      const result = await qr.query(
        `DELETE FROM IM_ITEM_RECEIPT
          WHERE RECEIPT_DATE = TO_DATE(:receiptDate, 'YYYY-MM-DD')
            AND RECEIPT_SEQUENCE = :receiptSequence
            AND ORGANIZATION_ID = :organizationId
            AND RECEIPT_TYPE = '${FIXED.receiptType}'
            AND BARCODE IS NULL`,
        namedBinds({
          receiptDate: dto.receiptDate,
          receiptSequence: dto.receiptSequence,
          organizationId,
        }),
      );
      const rows = Number(affectedRows(result) ?? 0);
      if (rows !== 1) {
        throw new NotFoundException(
          `지울 수 있는 기타입고가 아닙니다 (${dto.receiptDate} / ${dto.receiptSequence}).`,
        );
      }
      return { ...dto, rows };
    });
  }
}
