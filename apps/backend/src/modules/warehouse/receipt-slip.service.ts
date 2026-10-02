/**
 * @file src/modules/warehouse/receipt-slip.service.ts
 * @description 235 자재입고전표관리 — PB w_mat_receipt_slip_master 이식 (**쓰기**)
 *
 * 초보자 가이드:
 * 1. **이 화면이 자재 바코드(라벨)를 만드는 곳이다.** 협력사가 보낸 전표를 고르고,
 *    릴 수만큼 바코드를 발행하면서 **입고 원장(IM_ITEM_RECEIPT)에 입고를 기록**한다.
 *    바코드 한 장 = 입고 한 건이다.
 * 2. **분할 규칙은 `@smt/shared` 에 있다** (`planReelBarcodes`). 화면이 발행 전에
 *    "몇 장이 몇 개씩" 을 보여주고 서버가 그대로 넣어야 하므로 규칙을 공유한다.
 *    그 규칙은 단위테스트로 못 박혀 있다 (`reel-plan.test.ts` 23건) — 이 경로는
 *    운영 원장에 쓰기 때문에 실행 검증을 할 수 없어, 위험한 계산을 그쪽으로 뺐다.
 * 3. **채번은 PB 와 같은 Oracle 시퀀스를 쓴다.** PB `f_get_sequence('이름')` 은
 *    DB 함수가 아니라 **PB 함수**이고 본문이 `SELECT 이름.NEXTVAL FROM DUAL` 뿐이다
 *    (실측). 같은 시퀀스를 읽으므로 값이 같다. 시퀀스 이름은 **화이트리스트**로
 *    제한한다 — 이름을 그대로 SQL 에 넣으면 주입 통로가 된다.
 * 4. **하드코딩 값은 PB 그대로 둔다.** 실측으로 확인한 것들이다:
 *        LOCATION_CODE = 'M01'  — 단가1 입고 1,057건이 **전부 M01** 이다
 *        UNIT_PRICE    = 1      — PB 가 단가 조회를 주석 처리하고 1 로 고정했다.
 *                                 그래서 입고금액 = 수량이 된다. 최근 1년 단가1 입고는
 *                                 1,057건이고 대부분 **무상구매(F)/발주유형 M** 다
 *                                 (938건). 실제 단가를 조회하면 무상 자재에 금액이
 *                                 붙어 회계가 틀어진다 — PB 동작을 유지한다.
 *        ORDER_TYPE    = 'M'    — 실측 분포와 일치한다
 *        CURRENCY='WON' · EXCHANGE_RATE=1 · RECEIPT_DEFICIT=1(입고) · CONFIRM_YN='N'
 * 4-1. **롯트번호 접두어는 `YYYYMMDD` 가 아니다.** PB `f_ymd_sysdate()` 는 PB 함수이고
 *    (DB 에 같은 이름이 **없다** — 실측) 본문이
 *    `연도끝자리 + F_GET_MONTH_CODE2(월) + F_GET_DAY_CODE(일)` 이라 **3글자 코드**를 낸다.
 *    2026-09-28 이면 `69S` 다. 실제 롯트번호가 8자(`69S` + 5자리 순번)인 것과 맞는다
 *    (실측 최근 1년 303,081건이 8자). 그래서 접두어를 화면에서 받지 않고 **여기서
 *    같은 DB 함수로 만든다** — 화면이 만들면 PB 와 롯트번호 체계가 갈린다.
 * 5. **전표번호는 INVOICE_NO 로 들어간다** (PB 그대로). 자재 롯트번호는
 *    MATERIAL_MFS, 협력사 롯트는 MFS, 협력사 바코드는 ORIGIN_MFS 다 — 이름과
 *    뜻이 어긋나 있어 그대로 옮기지 않으면 조회 화면들과 어긋난다.
 * 6. **쓰기는 실행하지 않고 parse 로만 검증했다** (사용자 결정). 실제 발행이
 *    맞는지는 현장 확인이 필요하다.
 * 7. **TB_VIS_INOUT_ISSUENO_HUB 조회는 옮기지 않았다.** 그 표가 은성 DB 에 없고,
 *    PB 에서도 `dw_3.retrieve` 4곳 중 3곳이 주석 처리돼 우클릭 하나만 살아 있다 —
 *    이미 죽은 기능이다.
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { likePrefix, planReelBarcodes, checkReelPlan, totalReelQty } from '@smt/shared';
import { limited, ROW_LIMIT } from '../../shared/row-limit';
import { TransactionService } from '../../shared/transaction.service';
import {
  ReceiptSlipBarcodeQueryDto,
  ReceiptSlipIssueDto,
  ReceiptSlipQueryDto,
} from './warehouse.dto';
import { affectedRows } from '../../common/utils/affected-rows.util';
import { namedBinds } from '../../common/utils/named-binds.util';

type Row = Record<string, unknown>;

/**
 * 뽑을 수 있는 시퀀스 이름. PB 는 이름을 문자열로 받아 동적 SQL 을 만들었다 —
 * 웹에서 같은 짓을 하면 주입 통로가 되므로 화이트리스트로 제한한다.
 */
const SEQUENCES = {
  /** 자재 바코드(롯트번호). 장마다 하나씩 뽑는다. */
  materialBarcode: 'SEQ_MATERIAL_BARCODE',
  /** 입고 원장 순번. */
  matReceipt: 'SEQ_MAT_RECEIPT',
} as const;

/** PB 가 고정으로 넣던 값들 (파일 머리 4번의 실측 근거 참고). */
const FIXED = {
  locationCode: 'M01',
  unitPrice: 1,
  exchangeRate: 1,
  /** 1 = 입고 (2 는 반품) */
  receiptDeficit: 1,
  delivery: 1,
  currency: 'WON',
  orderType: 'M',
  confirmYn: 'N',
  receiptStatus: 'N',
  virtualReceiptYn: 'N',
  interfaceYn: 'N',
  comments: '*',
  incidentalExpenseCode: '*',
} as const;

@Injectable()
export class ReceiptSlipService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  // ───────────────────────────────── 조회

  /**
   * 입고전표 목록.
   *
   * **PB 고정조건 `RECEIPT_TYPE NOT IN ('B','T')`** 를 유지한다. 현재 데이터에는
   * 'N' 밖에 없어 아무것도 걸러내지 않지만 (실측 215,672건 전부 'N'),
   * 나중에 B/T 가 생기면 뜻이 살아난다.
   */
  async findSlips(query: ReceiptSlipQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT s.RECEIPT_SLIP_NO                         AS "receiptSlipNo",
              TO_CHAR(s.RECEIPT_DATE, 'YYYY-MM-DD HH24:MI:SS')         AS "receiptDate",
              s.RECEIPT_SEQUENCE                        AS "receiptSequence",
              s.ITEM_CODE                               AS "itemCode",
              i.ITEM_NAME                               AS "itemName",
              i.ITEM_SPEC                               AS "itemSpec",
              i.ITEM_UOM                                AS "itemUom",
              s.RECEIPT_BARCODE                         AS "receiptBarcode",
              s.REEL_QTY                                AS "reelQty",
              s.RECEIPT_UNIT_QTY                        AS "receiptUnitQty",
              s.RECEIPT_SUM_QTY                         AS "receiptSumQty",
              s.RECEIPT_TYPE                            AS "receiptType",
              s.RECEIPT_STATUS                          AS "receiptStatus",
              s.SUPPLIER_CODE                           AS "supplierCode",
              F_GET_SUPPLIER_NAME(s.SUPPLIER_CODE, s.ORGANIZATION_ID) AS "supplierName",
              s.ENTER_BY                                AS "enterBy",
              TO_CHAR(s.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')           AS "enterDate",
              -- **발행 장수를 여기서 세지 않는다.** PB 에 없던 편의 열이었는데,
              -- 바코드 표(193만행)에 RECEIPT_SLIP_NO 인덱스가 없어 전표마다 훑느라
              -- 2,636건 조회가 **31초**가 됐다 (실측). 전표를 고르면 바코드 목록을
              -- 조회하므로 장수는 그때 알 수 있다.
              NULL                                      AS "issuedCount"
         FROM IM_ITEM_RECEIPT_SLIP s
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = s.ITEM_CODE
               AND i.ORGANIZATION_ID = s.ORGANIZATION_ID
        WHERE s.RECEIPT_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND s.RECEIPT_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND s.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND s.RECEIPT_SLIP_NO LIKE :slipNo ESCAPE '\\'
          AND s.RECEIPT_TYPE LIKE :receiptType ESCAPE '\\'
          AND NVL(s.RECEIPT_STATUS, '*') LIKE :receiptStatus ESCAPE '\\'
          -- PB 고정조건. 'B'·'T' 유형 전표는 이 화면에서 다루지 않는다.
          AND s.RECEIPT_TYPE NOT IN ('B', 'T')
          AND s.ORGANIZATION_ID = :organizationId
        ORDER BY s.RECEIPT_DATE DESC, s.RECEIPT_SLIP_NO
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        itemCode: likePrefix(query.itemCode),
        slipNo: likePrefix(query.slipNo),
        receiptType: likePrefix(query.receiptType),
        receiptStatus: likePrefix(query.receiptStatus),
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }

  /**
   * 고른 전표로 발행된 바코드 목록.
   *
   * **PB 고정조건 `BARCODE_STATUS <> 'C'`** — 취소된 바코드는 빼고 본다.
   * 품목·전표 조건은 등호다 (목록이 돌려준 값을 그대로 받는다).
   */
  async findSlipBarcodes(query: ReceiptSlipBarcodeQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT b.ITEM_BARCODE                            AS "itemBarcode",
              b.LOT_NO                                  AS "lotNo",
              b.ORIGIN_ITEM_BARCODE                     AS "originItemBarcode",
              b.SCAN_QTY                                AS "scanQty",
              TO_CHAR(b.SCAN_DATE, 'YYYY-MM-DD HH24:MI:SS')            AS "scanDate",
              b.ITEM_CODE                               AS "itemCode",
              b.RECEIPT_SLIP_NO                         AS "receiptSlipNo",
              b.RECEIPT_TYPE                            AS "receiptType",
              b.BARCODE_STATUS                          AS "barcodeStatus",
              b.RECEIPT_COMPARE_YN                      AS "receiptCompareYn",
              b.HOLDING_YN                              AS "holdingYn",
              b.LOT_DIVIDE_YN                           AS "lotDivideYn",
              b.INVENTORY_TYPE                          AS "inventoryType",
              b.SUPPLIER_CODE                           AS "supplierCode",
              b.SUPPLIER_BARCODE                        AS "supplierBarcode",
              b.SUPPLIER_LOT_NO                         AS "supplierLotNo",
              b.ENTER_BY                                AS "enterBy",
              TO_CHAR(b.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')           AS "enterDate"
         FROM IM_ITEM_RECEIPT_BARCODE b
        WHERE b.ITEM_CODE = :itemCode
          AND b.RECEIPT_SLIP_NO = :slipNo
          -- PB 고정조건: 취소된 바코드는 빼고 본다.
          AND NVL(b.BARCODE_STATUS, '*') <> 'C'
          AND b.ORGANIZATION_ID = :organizationId
        ORDER BY b.SCAN_DATE, b.ITEM_BARCODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        itemCode: query.itemCode,
        slipNo: query.slipNo,
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }

  // ───────────────────────────────── 발행 (쓰기)

  /**
   * 시퀀스에서 값을 n개 뽑는다.
   *
   * PB `f_get_sequence` 와 같은 Oracle 시퀀스를 읽으므로 값이 같다.
   * 이름은 화이트리스트에서만 오므로 문자열을 SQL 에 넣어도 안전하다.
   */
  private async nextSequences(
    qr: { query: (sql: string, binds?: unknown[]) => Promise<unknown> },
    name: (typeof SEQUENCES)[keyof typeof SEQUENCES],
    count: number,
  ): Promise<number[]> {
    const rows = (await qr.query(
      `SELECT ${name}.NEXTVAL AS "seq"
         FROM DUAL
      CONNECT BY LEVEL <= :count`,
      namedBinds({ count }),
    )) as Row[];
    return rows.map((r) => Number(r.seq));
  }

  /**
   * 바코드 발행 + 입고 기록 (**쓰기**).
   *
   * PB 흐름을 그대로 옮긴다:
   *   1. 분할 계획을 만든다 (장수·수량) — 규칙은 `@smt/shared` 가 갖고 있다
   *   2. 장수만큼 롯트 시퀀스를 뽑아 바코드 번호를 만든다
   *   3. 바코드 행을 넣는다 (IM_ITEM_RECEIPT_BARCODE)
   *   4. 장마다 입고 원장에 한 건씩 넣는다 (IM_ITEM_RECEIPT)
   *
   * PB 는 장마다 왕복했다. 여기서는 계획을 먼저 다 만들고 한 트랜잭션에서 넣는다 —
   * 결과는 같고 중간에 끊겨 반쪽만 들어가는 일이 없다.
   */
  async issueBarcodes(dto: ReceiptSlipIssueDto, organizationId: number, userId: string) {
    // 화면이 막지 못한 경우를 서버가 다시 판정한다 (같은 함수를 쓴다).
    const verdict = checkReelPlan(dto);
    if (!verdict.ok) throw new BadRequestException(verdict.reason);

    return this.tx.run(async (qr) => {
      // 전표를 확인한다. 없는 전표로 발행하면 조회 화면에서 짝이 안 맞는다.
      const slips = (await qr.query(
        `SELECT s.ITEM_CODE            AS "itemCode",
                s.RECEIPT_SUM_QTY      AS "receiptSumQty",
                s.SUPPLIER_CODE        AS "supplierCode",
                s.RECEIPT_TYPE         AS "receiptType"
           FROM IM_ITEM_RECEIPT_SLIP s
          WHERE s.RECEIPT_SLIP_NO = :slipNo
            AND s.ITEM_CODE = :itemCode
            AND s.ORGANIZATION_ID = :organizationId`,
        namedBinds({
          slipNo: dto.slipNo,
          itemCode: dto.itemCode,
          organizationId,
        }),
      )) as Row[];
      if (slips.length === 0) {
        throw new BadRequestException(
          `전표를 찾을 수 없습니다: ${dto.slipNo} / ${dto.itemCode}`,
        );
      }

      const planned = totalReelQty(dto);
      const slipQty = Number(slips[0].receiptSumQty ?? 0);
      // 전표 수량과 발행 수량이 다르면 입고 원장이 전표와 어긋난다. PB 는 이 검사를
      // 하지 않아 사용자가 잘못 넣으면 그대로 들어갔다.
      if (slipQty > 0 && planned !== slipQty) {
        throw new BadRequestException(
          `발행 수량 합(${planned.toLocaleString()})이 전표 수량`
          + `(${slipQty.toLocaleString()})과 다릅니다.`,
        );
      }

      // PB `f_ymd_sysdate()` 와 같은 식·같은 DB 함수로 날짜코드를 만든다 (파일 머리 4-1번).
      const prefixRows = (await qr.query(
        `SELECT SUBSTR(TO_CHAR(SYSDATE, 'YYYY'), 4, 1)
                || F_GET_MONTH_CODE2(TO_CHAR(SYSDATE, 'MM'))
                || F_GET_DAY_CODE(TO_CHAR(SYSDATE, 'DD')) AS "datePrefix"
           FROM DUAL`,
      )) as Row[];
      const datePrefix = String(prefixRows[0]?.datePrefix ?? '');
      if (!datePrefix) {
        throw new BadRequestException('롯트번호 날짜코드를 만들 수 없습니다.');
      }

      const lotSeqs = await this.nextSequences(
        qr, SEQUENCES.materialBarcode, dto.divideQty?.length || Number(dto.reelQty),
      );
      const plans = planReelBarcodes({ ...dto, datePrefix }, lotSeqs);
      const receiptSeqs = await this.nextSequences(
        qr, SEQUENCES.matReceipt, plans.length,
      );

      let barcodeRows = 0;
      let receiptRows = 0;
      for (let i = 0; i < plans.length; i += 1) {
        const plan = plans[i];
        const common = {
          itemCode: dto.itemCode,
          slipNo: dto.slipNo,
          lotNo: plan.lotNo,
          itemBarcode: plan.itemBarcode,
          scanQty: plan.scanQty,
          supplierCode: (slips[0].supplierCode as string) ?? null,
          receiptType: (slips[0].receiptType as string) ?? null,
          inventoryType: dto.inventoryType ?? null,
          supplierBarcode: dto.supplierBarcode ?? null,
          supplierLotNo: dto.supplierLotNo ?? null,
          userId,
          organizationId,
        };

        const barcodeResult = await qr.query(
          `INSERT INTO IM_ITEM_RECEIPT_BARCODE
             (ITEM_BARCODE, LOT_NO, ORIGIN_ITEM_BARCODE, SCAN_QTY, SCAN_DATE,
              ITEM_CODE, RECEIPT_SLIP_NO, RECEIPT_TYPE, SUPPLIER_CODE,
              SUPPLIER_BARCODE, SUPPLIER_LOT_NO, INVENTORY_TYPE,
              RECEIPT_COMPARE_YN, BARCODE_STATUS, HOLDING_YN, LOT_DIVIDE_YN,
              ORGANIZATION_ID, ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
           VALUES
             (:itemBarcode, :lotNo, :itemBarcode, :scanQty, SYSDATE,
              :itemCode, :slipNo, :receiptType, :supplierCode,
              :supplierBarcode, :supplierLotNo, :inventoryType,
              -- PB 가 고정으로 넣던 값. 발행 직후 상태다.
              'N', 'N', 'N', 'N',
              :organizationId, SYSDATE, :userId, SYSDATE, :userId)`,
          namedBinds(common),
        );
        barcodeRows += Number(
          affectedRows(barcodeResult) ?? 0,
        );

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
             (:receiptSequence, TRUNC(SYSDATE), :organizationId, '${FIXED.locationCode}',
              ${FIXED.delivery}, ${FIXED.receiptDeficit}, :lineType, :scanQty,
              0, ${FIXED.unitPrice}, 0,
              SYSDATE, :slipNo, :scanQty * ${FIXED.unitPrice}, :userId,
              ${FIXED.exchangeRate}, 0, :supplierCode,
              SYSDATE, :userId, '${FIXED.confirmYn}', TRUNC(SYSDATE),
              :receiptType, :supplierLotNo, 0, '${FIXED.virtualReceiptYn}',
              '${FIXED.comments}',
              '${FIXED.currency}', :itemBarcode, '${FIXED.receiptStatus}',
              :itemCode, :lotNo,
              '${FIXED.interfaceYn}', :lotNo, 0,
              '${FIXED.incidentalExpenseCode}', 0, 0, 0,
              :supplierBarcode, :originSupplierCode, '${FIXED.orderType}', :userId,
              'N', 0, 'N',
              :fromSupplierCode, :manufactureWeek, :inventoryType,
              TO_DATE(:coatingDate, 'YYYY-MM-DD'),
              TO_DATE(:manufactureDate, 'YYYY-MM-DD'))`,
          namedBinds({
            ...common,
            receiptSequence: receiptSeqs[i],
            lineType: dto.lineType ?? null,
            originSupplierCode: dto.originSupplierCode ?? null,
            fromSupplierCode: dto.fromSupplierCode ?? null,
            manufactureWeek: dto.manufactureWeek ?? null,
            coatingDate: dto.coatingDate ?? null,
            manufactureDate: dto.manufactureDate ?? null,
          }),
        );
        receiptRows += Number(
          affectedRows(receiptResult) ?? 0,
        );
      }

      return {
        slipNo: dto.slipNo,
        itemCode: dto.itemCode,
        datePrefix,
        issued: plans.length,
        totalQty: planned,
        barcodeRows,
        receiptRows,
        firstBarcode: plans[0]?.itemBarcode ?? null,
        lastBarcode: plans[plans.length - 1]?.itemBarcode ?? null,
      };
    });
  }
}
