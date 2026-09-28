/**
 * @file src/modules/product/services/product-fg.service.ts
 * @description 302 제품입고관리(PID) · 304 제품입고관리(모델단위) ·
 *   307 제품출하관리 · 308 제품출고관리(모델단위) 이식 (**쓰기**)
 *
 * 초보자 가이드:
 * 1. **포장된 박스를 제품창고에 넣고(입고), 고객에게 내보내는(출하) 화면이다.**
 *    박스 바코드를 찍으면 한 건씩 처리된다.
 * 2. **계산은 전부 DB 프로시저가 한다.** PB 도 검증·원장기록·재고반영을 직접 하지 않고
 *    `P_PRODUCT_FG_RECEIPT` / `P_PRODUCT_FG_MODEL_RECEIPT` / `P_PRODUCT_FG_ISSUE` /
 *    `P_PRODUCT_FG_MODEL_ISSUE` 에 넘긴다. **웹도 같은 프로시저를 그대로 부른다** —
 *    TypeScript 로 다시 구현하면 PB 와 재고가 갈린다.
 * 3. **취소는 같은 프로시저의 다른 코드다** (`p_txn`):
 *        입고 1 정상 / 2 취소      ·      출고 3 정상 / 4 취소
 *    실측도 그대로다 — 입고 590,454/취소 3,928, 출고 565,617/취소 3,837.
 * 4. **`p_commit` 에 `'N'` 을 넘긴다.** 프로시저 안의 `COMMIT`/`ROLLBACK` 이 전부
 *    `if p_commit = 'Y'` 로 감싸여 있어(실측), `'N'` 이면 트랜잭션을 웹이 쥔다.
 *    PB 는 `'Y'` 를 넘겨 프로시저가 직접 커밋했다.
 * 5. **판정은 `p_out`/`p_msg` 로 나온다.** OUT 인자를 쓰면 서비스가 oracledb 드라이버를
 *    직접 import 해야 하므로, 저장소 관례대로 블록 안에서 오류로 바꿔 던진다.
 * 6. **모델단위(304·308)는 박스가 아니라 모델을 찍고 수량을 넣는다.** 실측으로도
 *    포장마스터에 없는 바코드의 입고 1,183건 · 출고 1,040건이 남아 있어 살아있는 경로다.
 * 7. **입고에는 인터락 검사가 없다** — PB 도 없다. `w_prd_product_fg_receipt` 에
 *    `wf_final_inspect`(P_INTERLOCK_CHECK 호출)가 **정의만 돼 있고 호출부가 없다**
 *    (실측: 선언 127줄 · 정의 139줄 · 호출 0곳). 살아있는 인터락 게이트는 포장
 *    스캔(299)에 있고 그쪽에 옮겼다.
 * 8. **쓰기는 실행하지 않고 parse 로만 검증했다** (사용자 결정).
 * 9. **목록은 기간을 좁혀 본다.** 이 표들은 기간 컬럼에 인덱스가 없어 한 달을 보면
 *    9,000행에 **8.7초**가 걸린다 (실측). 7일이면 1,583행 **2.4초**다 — 그래서 화면
 *    기본값을 7일로 뒀다. 인덱스 추가는 스키마 변경이라 손대지 않았다.
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { limited, ROW_LIMIT } from '../../../shared/row-limit';
import { TransactionService } from '../../../shared/transaction.service';
import {
  FgIssuableQueryDto,
  FgIssueDto,
  FgIssueQueryDto,
  FgModelIssueDto,
  FgModelReceiptDto,
  FgReceiptDto,
  FgReceiptQueryDto,
} from '../dto/product-fg.dto';

type Row = Record<string, unknown>;

/** PB `p_txn` — 프로시저가 정상과 취소를 이 값으로 가른다 (프로시저 주석 실측). */
export const FG_TXN = {
  receipt: 1,
  receiptCancel: 2,
  issue: 3,
  issueCancel: 4,
} as const;

/**
 * 프로시저에게 커밋을 맡기지 않는다는 표시.
 * 프로시저 본문의 모든 `COMMIT`/`ROLLBACK` 이 `if p_commit = 'Y'` 안에 있다.
 */
const NO_PROC_COMMIT = 'N';

@Injectable()
export class ProductFgService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  // ───────────────────────────────── 조회

  /** 제품입고 이력 (PB `d_product_fg_receipt_lst`). 취소분은 수량을 음수로 낸다. */
  async findReceipts(query: FgReceiptQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT TO_CHAR(r.RECEIPT_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "receiptDate",
              r.RECEIPT_SEQUENCE  AS "receiptSequence",
              r.BARCODE           AS "barcode",
              r.PACK_TYPE         AS "packType",
              r.TXN_DEFICIT       AS "txnDeficit",
              -- PB 와 같은 식: 취소(2)는 음수로 보여 합계가 맞는다.
              r.QTY * DECODE(r.TXN_DEFICIT, '1', 1, -1) AS "qty",
              r.MODEL_NAME        AS "modelName",
              r.MODEL_SUFFIX      AS "modelSuffix",
              r.ITEM_CODE         AS "itemCode",
              r.ITEM_TYPE         AS "itemType",
              r.MFS               AS "mfs",
              r.LINE_CODE         AS "lineCode",
              ln.LINE_NAME        AS "lineName",
              r.WORKSTAGE_CODE    AS "workstageCode",
              r.MACHINE_CODE      AS "machineCode",
              r.LOCATION_CODE     AS "locationCode",
              r.SHIFT_CODE        AS "shiftCode",
              r.WORK_TIME_ZONE    AS "workTimeZone",
              r.ENTER_BY          AS "enterBy",
              TO_CHAR(r.ACTUAL_DATE, 'YYYY-MM-DD') AS "actualDate"
         FROM IP_PRODUCT_FG_RECEIPT r
         LEFT JOIN IP_PRODUCT_LINE ln
                ON ln.LINE_CODE = r.LINE_CODE
               AND ln.ORGANIZATION_ID = r.ORGANIZATION_ID
        WHERE r.RECEIPT_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND r.RECEIPT_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND r.MODEL_NAME LIKE :modelName
          AND r.BARCODE LIKE :barcode
          AND r.TXN_DEFICIT LIKE :txnDeficit
          AND r.ORGANIZATION_ID = :organizationId
        ORDER BY r.RECEIPT_DATE DESC, r.RECEIPT_SEQUENCE DESC
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        modelName: this.like(query.modelName),
        barcode: this.like(query.barcode),
        txnDeficit: this.like(query.txnDeficit),
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /** 제품출하 이력 (PB `d_product_fg_issue_lst`). */
  async findIssues(query: FgIssueQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT TO_CHAR(i.ISSUE_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "issueDate",
              i.ISSUE_SEQUENCE    AS "issueSequence",
              i.BARCODE           AS "barcode",
              i.PACK_TYPE         AS "packType",
              i.TXN_DEFICIT       AS "txnDeficit",
              i.ISSUE_TYPE        AS "issueType",
              -- 출고 3 은 양수, 취소 4 는 음수로 낸다 (입고와 같은 방식).
              i.QTY * DECODE(i.TXN_DEFICIT, '3', 1, -1) AS "qty",
              i.MODEL_NAME        AS "modelName",
              i.MODEL_SUFFIX      AS "modelSuffix",
              i.ITEM_CODE         AS "itemCode",
              i.CUSTOMER_CODE     AS "customerCode",
              cu.CUSTOMER_NAME    AS "customerName",
              i.SALES_UNIT_PRICE  AS "salesUnitPrice",
              i.CURRENCY          AS "currency",
              i.LOCATION_CODE     AS "locationCode",
              i.PALLET_NO         AS "palletNo",
              i.SHIP_NO           AS "shipNo",
              i.SHIFT_CODE        AS "shiftCode",
              i.ENTER_BY          AS "enterBy",
              TO_CHAR(i.ACTUAL_DATE, 'YYYY-MM-DD') AS "actualDate"
         FROM IP_PRODUCT_FG_ISSUE i
         LEFT JOIN ICOM_CUSTOMER cu
                ON cu.CUSTOMER_CODE = i.CUSTOMER_CODE
               AND cu.ORGANIZATION_ID = i.ORGANIZATION_ID
        WHERE i.ISSUE_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND i.ISSUE_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND i.MODEL_NAME LIKE :modelName
          AND i.BARCODE LIKE :barcode
          AND NVL(i.CUSTOMER_CODE, '*') LIKE :customerCode
          AND i.ORGANIZATION_ID = :organizationId
        ORDER BY i.ISSUE_DATE DESC, i.ISSUE_SEQUENCE DESC
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        modelName: this.like(query.modelName),
        barcode: this.like(query.barcode),
        customerCode: this.like(query.customerCode),
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /** 고객별 출하 요약 (PB `d_product_fg_issue_summary_lst`). */
  async findIssueSummary(query: FgIssueQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT i.CUSTOMER_CODE   AS "customerCode",
              MAX(cu.CUSTOMER_NAME) AS "customerName",
              COUNT(*)          AS "issueCount",
              SUM(i.QTY * DECODE(i.TXN_DEFICIT, '3', 1, -1)) AS "qty"
         FROM IP_PRODUCT_FG_ISSUE i
         LEFT JOIN ICOM_CUSTOMER cu
                ON cu.CUSTOMER_CODE = i.CUSTOMER_CODE
               AND cu.ORGANIZATION_ID = i.ORGANIZATION_ID
        WHERE i.ISSUE_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND i.ISSUE_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND i.MODEL_NAME LIKE :modelName
          AND i.BARCODE LIKE :barcode
          AND NVL(i.CUSTOMER_CODE, '*') LIKE :customerCode
          -- PB 고정조건: 고객이 없는 행은 요약에서 뺀다.
          AND i.CUSTOMER_CODE IS NOT NULL
          AND i.ORGANIZATION_ID = :organizationId
        GROUP BY i.CUSTOMER_CODE
        ORDER BY 4 DESC
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        modelName: this.like(query.modelName),
        barcode: this.like(query.barcode),
        customerCode: this.like(query.customerCode),
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /**
   * 출하할 수 있는 재고 (PB `d_prd_product_fg_issue_able_lst`).
   *
   * PB 고정조건 두 가지를 그대로 둔다 — 파렛트에 실리지 않은 것(`PALLET_FLAG='N'`)과
   * 제품창고(`LOCATION_CODE='P01'`). 창고코드를 화면에서 바꿀 수 있게 열어 두되
   * 기본값은 PB 와 같다.
   */
  async findIssuable(query: FgIssuableQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT v.BARCODE        AS "barcode",
              v.PACK_TYPE      AS "packType",
              v.LOCATION_CODE  AS "locationCode",
              v.QTY            AS "qty",
              v.MODEL_NAME     AS "modelName",
              v.MODEL_SUFFIX   AS "modelSuffix",
              v.ITEM_CODE      AS "itemCode",
              v.ITEM_TYPE      AS "itemType",
              v.PALLET_NO      AS "palletNo",
              NVL(v.PALLET_FLAG, 'N') AS "palletFlag",
              v.RECEIPT_NO     AS "receiptNo",
              v.ENTER_BY       AS "enterBy",
              TO_CHAR(v.INVENTORY_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "inventoryDate"
         FROM IP_PRODUCT_FG_INVENTORY v
        WHERE v.INVENTORY_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND v.INVENTORY_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND v.BARCODE LIKE :barcode
          AND v.MODEL_NAME LIKE :modelName
          AND NVL(v.PALLET_FLAG, 'N') = 'N'
          AND v.LOCATION_CODE = :locationCode
          AND v.ORGANIZATION_ID = :organizationId
        ORDER BY v.PALLET_NO, v.INVENTORY_DATE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        barcode: this.like(query.barcode),
        modelName: this.like(query.modelName),
        locationCode: query.locationCode ?? 'P01',
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  // ───────────────────────────────── 입고 (쓰기)

  /** 302 박스 하나를 제품창고에 넣는다 / 취소한다 (**쓰기**). */
  async receipt(dto: FgReceiptDto, organizationId: number) {
    const txn = dto.cancel ? FG_TXN.receiptCancel : FG_TXN.receipt;
    return this.runProc(
      'P_PRODUCT_FG_RECEIPT(:barcode, :location, :txn, :commitFlag, v_out, v_msg)',
      {
        barcode: dto.barcode.trim(),
        location: dto.locationCode,
        txn,
        commitFlag: NO_PROC_COMMIT,
      },
      dto.cancel ? '입고취소' : '입고',
      { barcode: dto.barcode.trim(), txn, organizationId },
    );
  }

  /** 304 모델과 수량으로 넣는다 / 취소한다 (**쓰기**). */
  async modelReceipt(dto: FgModelReceiptDto, organizationId: number) {
    const txn = dto.cancel ? FG_TXN.receiptCancel : FG_TXN.receipt;
    return this.runProc(
      'P_PRODUCT_FG_MODEL_RECEIPT(:barcode, :qty, :location, :txn, :commitFlag, v_out, v_msg)',
      {
        barcode: dto.barcode.trim(),
        // 프로시저가 VARCHAR2 로 받는다 (실측). 숫자를 문자열로 넘긴다.
        qty: String(dto.qty),
        location: dto.locationCode,
        txn,
        commitFlag: NO_PROC_COMMIT,
      },
      dto.cancel ? '모델단위 입고취소' : '모델단위 입고',
      { barcode: dto.barcode.trim(), qty: dto.qty, txn, organizationId },
    );
  }

  // ───────────────────────────────── 출하 (쓰기)

  /**
   * 307 박스 하나를 고객에게 내보낸다 / 취소한다 (**쓰기**).
   *
   * `barType` 은 PB `p_bar_type` 이다 — `'I'` 는 개별 박스, `'P'` 는 파렛트.
   * 파렛트는 이 현장에서 쓰지 않으므로(`IP_PRODUCT_FG_PALLET` 0행) 기본값은 `'I'` 다.
   */
  async issue(dto: FgIssueDto, organizationId: number) {
    const txn = dto.cancel ? FG_TXN.issueCancel : FG_TXN.issue;
    return this.runProc(
      'P_PRODUCT_FG_ISSUE(:barcode, :barType, :customerCode, :location,'
        + ' :txn, :commitFlag, v_out, v_msg)',
      {
        barcode: dto.barcode.trim(),
        barType: dto.barType ?? 'I',
        customerCode: dto.customerCode,
        location: dto.locationCode,
        txn,
        commitFlag: NO_PROC_COMMIT,
      },
      dto.cancel ? '출하취소' : '출하',
      { barcode: dto.barcode.trim(), txn, organizationId },
    );
  }

  /** 308 모델과 수량으로 내보낸다 / 취소한다 (**쓰기**). */
  async modelIssue(dto: FgModelIssueDto, organizationId: number) {
    const txn = dto.cancel ? FG_TXN.issueCancel : FG_TXN.issue;
    return this.runProc(
      'P_PRODUCT_FG_MODEL_ISSUE(:barcode, :qty, :location, :txn, :commitFlag, v_out, v_msg)',
      {
        barcode: dto.barcode.trim(),
        qty: String(dto.qty),
        location: dto.locationCode,
        txn,
        commitFlag: NO_PROC_COMMIT,
      },
      dto.cancel ? '모델단위 출고취소' : '모델단위 출고',
      { barcode: dto.barcode.trim(), qty: dto.qty, txn, organizationId },
    );
  }

  // ───────────────────────────────── 프로시저 호출 공통

  /**
   * FG 프로시저를 부른다. 네 화면이 모양만 다르고 처리는 같아 여기로 모았다.
   *
   * `p_out = 'NG'` 이면 블록 안에서 오류로 바꿔 던지고, 서비스가 그 메시지를
   * 사용자 문구로 되돌린다. OUT 바인드를 쓰지 않는 저장소 관례를 따른 것이다.
   */
  private async runProc(
    call: string,
    binds: Record<string, unknown>,
    label: string,
    result: Record<string, unknown>,
  ) {
    return this.tx.run(async (qr) => {
      await qr
        .query(
          `DECLARE
             v_out VARCHAR2(4000);
             v_msg VARCHAR2(4000);
           BEGIN
             ${call};
             IF v_out = 'NG' THEN
               RAISE_APPLICATION_ERROR(-20005, 'FG_PROC_NG:' || v_msg);
             END IF;
           END;`,
          binds as unknown as unknown[],
        )
        .catch((error: unknown) => {
          const message = error instanceof Error ? error.message : String(error);
          const matched = /FG_PROC_NG:(.*)/.exec(message);
          if (matched) {
            throw new BadRequestException(
              `${label} 실패: ${matched[1].trim() || '사유 없음'}`,
            );
          }
          throw error;
        });
      return { ...result, label, ok: true };
    });
  }

  private like(value?: string) {
    const trimmed = (value ?? '').trim();
    return trimmed ? `%${trimmed}%` : '%';
  }
}
