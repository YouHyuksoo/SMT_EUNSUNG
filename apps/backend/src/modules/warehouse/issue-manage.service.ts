/**
 * @file src/modules/warehouse/issue-manage.service.ts
 * @description 257 자재기타출고 · 258 자재출고취소 — PB `w_mat_other_issue_master` ·
 *              `w_mat_mass_issue_cancel_master` 이식 (**쓰기**)
 *
 * 초보자 가이드:
 * 1. **출고 원장(`IM_ITEM_ISSUE`)을 다루는 두 화면이다.** 257 은 재고를 빼고,
 *    258 은 이미 뺀 것을 되돌린다.
 * 2. **수량 부호가 뜻을 정한다** — 254 입고와 같은 방식이다 (실측):
 *        `ISSUE_DEFICIT = 3` 출고 (양수) · `4` 반납 (음수)
 *    최근 1년 482,658건이 정확히 그 규칙을 따른다 (3은 전부 양수, 4는 전부 음수).
 * 3. **258 취소는 지우는 것이 아니라 역분개다.** PB `f_mat_issue_cancel` 을 그대로
 *    옮겼다 (DB 에 같은 이름이 없는 **PB 함수**다 — 실측):
 *        ① 이미 공정으로 이관된 건이면 거절한다
 *        ② 원래 건의 상태를 'C' 로 바꾼다
 *        ③ 딸린 반납요청의 확정을 푼다
 *        ④ **부호를 뒤집은 새 행을 한 건 넣는다** (구분 3↔4, 수량·금액 음수,
 *           상태 'C', 출고일은 취소일)
 *    실측으로 취소 쌍이 남아 있다: 상태 C 중 구분 4 가 3,419건 / 구분 3 이 3,361건.
 *    원장을 지우지 않으므로 이력이 남는다.
 * 4. **출고 수량은 포장 단위로 올라간다.** PB `f_get_item_issue_packing_qty` 를
 *    `@smt/shared` 로 뺐고 테스트 8건으로 못 박았다. **음수 수량에 포장단위를 적용하면
 *    PB 가 양수를 내놓아 반납이 출고로 뒤집힌다** — 그 조합은 여기서 거절한다.
 * 5. **PB 의 죽은 조건 둘을 그대로 둔다** (뜻이 살아 있고 비용이 없다):
 *      · 공정 이관 확인 — `IM_ITEM_WORKSTAGE_ISSUE_PLAN` 이 0행이라 지금은 안 걸린다
 *      · 반납요청 확정 해제 — `IM_ITEM_ISSUE_RETURN_REQUEST` 가 0행이다
 * 6. **쓰기는 실행하지 않고 parse 로만 검증했다** (사용자 결정).
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { applyIssuePacking, likePrefix } from '@smt/shared';
import { limited, ROW_LIMIT } from '../../shared/row-limit';
import { TransactionService } from '../../shared/transaction.service';
import {
  EtcIssueCreateDto,
  IssueCancelDto,
  IssueHistoryQueryDto,
  IssueInventoryQueryDto,
} from './warehouse.dto';
import { affectedRows } from '../../common/utils/affected-rows.util';

type Row = Record<string, unknown>;

/** 뽑을 수 있는 시퀀스. 이름을 문자열로 받아 SQL 에 넣으면 주입 통로가 된다. */
const SEQUENCES = {
  matIssue: 'SEQ_MAT_ISSUE',
  issueInvoice: 'SEQ_ISSUE_INVOICE_SEQUENCE',
} as const;

const FIXED = {
  /** 'N' = 정상출고. PB 는 기타출고 'E'·재생출고 'R' 도 쓰지만 최근 1년 실데이터가 전부 'N' 이다. */
  issueType: 'N',
  issueStatus: 'N',
  /** 취소로 만들어지는 행의 상태 */
  cancelStatus: 'C',
  mfs: '*',
  workOrderNo: '*',
} as const;

/** 출고 원장 한 줄에서 화면이 쓰는 열. 257·258 이 공유한다. */
const ISSUE_COLUMNS = `TO_CHAR(s.ISSUE_DATE, 'YYYY-MM-DD')  AS "issueDate",
       s.ISSUE_SEQUENCE            AS "issueSequence",
       s.ITEM_CODE                 AS "itemCode",
       i.ITEM_NAME                 AS "itemName",
       i.ITEM_SPEC                 AS "itemSpec",
       i.ITEM_UOM                  AS "itemUom",
       s.ISSUE_QTY                 AS "issueQty",
       s.ISSUE_DEFICIT             AS "issueDeficit",
       s.ISSUE_PRICE               AS "issuePrice",
       s.ISSUE_AMT                 AS "issueAmt",
       s.ISSUE_STATUS              AS "issueStatus",
       s.ISSUE_TYPE                AS "issueType",
       s.ISSUE_ACCOUNT             AS "issueAccount",
       s.LINE_CODE                 AS "lineCode",
       F_GET_LINE_NAME(s.LINE_CODE, 1)          AS "lineName",
       s.WORKSTAGE_CODE            AS "workstageCode",
       s.MACHINE_CODE              AS "machineCode",
       s.LOCATION_CODE             AS "locationCode",
       s.MATERIAL_MFS              AS "materialMfs",
       s.MFS                       AS "mfs",
       s.BARCODE                   AS "barcode",
       s.INVOICE_NO                AS "invoiceNo",
       s.WORK_ORDER_NO             AS "workOrderNo",
       s.PARENT_ITEM_CODE          AS "parentItemCode",
       s.MODEL_NAME                AS "modelName",
       s.LINE_TYPE                 AS "lineType",
       s.ITEM_TYPE                 AS "itemType",
       s.INVENTORY_TYPE            AS "inventoryType",
       s.SUPPLIER_CODE             AS "supplierCode",
       s.COMMENTS                  AS "comments",
       s.ENTER_BY                  AS "enterBy",
       TO_CHAR(s.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')        AS "enterDate"`;

@Injectable()
export class IssueManageService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  // ───────────────────────────────── 조회

  /**
   * 출고 이력 (PB `d_mat_issue_lst` — 257·258 이 같은 DataWindow 를 쓴다).
   *
   * **이 목록은 편집할 수 없다** — PB DataWindow 에 갱신 대상 표가 없다 (실측).
   * 편집 가능한 두 열(`check_yn`·`demand_qty`)은 선택·입력용 칸이다.
   */
  async findHistory(query: IssueHistoryQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT ${ISSUE_COLUMNS}
         FROM IM_ITEM_ISSUE s
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = s.ITEM_CODE
               AND i.ORGANIZATION_ID = s.ORGANIZATION_ID
        WHERE s.ISSUE_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND s.ISSUE_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND s.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND NVL(s.MFS, '*') LIKE :mfs ESCAPE '\\'
          AND NVL(s.MATERIAL_MFS, '*') LIKE :materialMfs ESCAPE '\\'
          AND NVL(s.LINE_CODE, '*') LIKE :lineCode ESCAPE '\\'
          AND NVL(s.WORKSTAGE_CODE, '*') LIKE :workstageCode ESCAPE '\\'
          AND NVL(s.INVOICE_NO, '*') LIKE :invoiceNo ESCAPE '\\'
          AND NVL(s.ISSUE_STATUS, '*') LIKE :issueStatus ESCAPE '\\'
          AND s.ORGANIZATION_ID = :organizationId
        ORDER BY s.ISSUE_DATE DESC, s.ISSUE_SEQUENCE DESC
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        itemCode: likePrefix(query.itemCode),
        mfs: likePrefix(query.mfs),
        materialMfs: likePrefix(query.materialMfs),
        lineCode: likePrefix(query.lineCode),
        workstageCode: likePrefix(query.workstageCode),
        invoiceNo: likePrefix(query.invoiceNo),
        issueStatus: likePrefix(query.issueStatus),
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /**
   * 257 현재고 목록 (PB `d_mat_current_inventory_4_etc_issu_lst`).
   *
   * 254 입고 쪽과 같은 표·같은 조건식이다 (`SIGN(qty) >= :sign`).
   * **기본은 재고 있는 것만** — 전체는 1,837,572행이라 잘린 채로 나온다.
   *
   * PB 는 `IM_ITEM_RECYCLE_INVENTORY`(재생 재고)를 UNION ALL 로 붙이지만
   * 그 표가 0행이라 붙이지 않았다 (실측 — 254 와 같은 판정).
   */
  async findInventory(query: IssueInventoryQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT v.ITEM_CODE                        AS "itemCode",
              i.ITEM_NAME                        AS "itemName",
              i.ITEM_SPEC                        AS "itemSpec",
              i.ITEM_TYPE                        AS "itemType",
              i.ITEM_UOM                         AS "itemUom",
              i.LOCATION_ADDRESS                 AS "locationAddress",
              -- 포장 단위. 화면이 "실제로 몇 개가 나가나" 를 미리 보여줄 때 쓴다.
              NVL(i.ISSUE_PACKING_QTY, 0)        AS "issuePackingQty",
              v.LINE_TYPE                        AS "lineType",
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
          -- PB 라디오버튼 그대로다 ('재고 있는 것' 1 · '전체' -2).
          AND SIGN(v.INVENTORY_QTY) >= :sign
          AND v.ORGANIZATION_ID = :organizationId
        ORDER BY v.ITEM_CODE, v.LOCATION_CODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        itemCode: likePrefix(query.itemCode),
        materialMfs: likePrefix(query.materialMfs),
        locationCode: likePrefix(query.locationCode),
        sign: query.includeZero ? -2 : 1,
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  // ───────────────────────────────── 257 기타출고 (쓰기)

  /**
   * 기타출고 등록 (**쓰기**). PB 의 "선택한 재고를 출고 목록으로 옮기고 저장" 을
   * 한 번에 한다.
   *
   * PB 가 요구하던 것을 그대로 요구한다: **라인·공정·설비를 반드시 고른다.**
   * 세 값 중 하나라도 비면 PB 도 거절했다 (어디로 나갔는지 모르는 출고가 생긴다).
   */
  async createEtcIssue(dto: EtcIssueCreateDto, organizationId: number, userId: string) {
    const qty = Number(dto.issueQty);
    if (!Number.isFinite(qty) || qty === 0) {
      throw new BadRequestException('수량은 0 이 아닌 값이어야 합니다 (음수는 반납).');
    }
    // PB 결함을 막는다 (파일 머리 4번). 음수에 포장단위를 적용하면 양수가 나온다.
    if (dto.applyPackingQty && qty < 0) {
      throw new BadRequestException(
        '반납(음수)에는 포장 단위를 적용할 수 없습니다. 포장 단위 적용을 끄세요.',
      );
    }

    return this.tx.run(async (qr) => {
      const items = (await qr.query(
        `SELECT i.ITEM_TYPE                  AS "itemType",
                i.LINE_TYPE                  AS "lineType",
                NVL(i.ISSUE_PACKING_QTY, 0)  AS "issuePackingQty"
           FROM ID_ITEM i
          WHERE i.ITEM_CODE = :itemCode
            AND i.ORGANIZATION_ID = :organizationId`,
        { itemCode: dto.itemCode, organizationId } as unknown as unknown[],
      )) as Row[];
      if (items.length === 0) {
        throw new BadRequestException(`품목을 찾을 수 없습니다: ${dto.itemCode}`);
      }

      // 규칙은 화면과 같은 공유 함수를 쓴다 — 보여준 수량과 실제로 빠지는 수량이 같아야 한다.
      const issueQty = dto.applyPackingQty
        ? applyIssuePacking(qty, Number(items[0].issuePackingQty ?? 0))
        : qty;

      const seqs = (await qr.query(
        `SELECT ${SEQUENCES.matIssue}.NEXTVAL      AS "issueSequence",
                ${SEQUENCES.issueInvoice}.NEXTVAL  AS "invoiceSequence"
           FROM DUAL`,
      )) as Row[];
      const issueSequence = Number(seqs[0]?.issueSequence ?? 0);
      const invoiceNo = dto.invoiceNo || String(seqs[0]?.invoiceSequence ?? '');

      const result = await qr.query(
        `INSERT INTO IM_ITEM_ISSUE
           (ISSUE_DATE, ISSUE_SEQUENCE, ORGANIZATION_ID,
            ITEM_CODE, ITEM_TYPE, LINE_TYPE, SUPPLIER_CODE,
            LINE_CODE, WORKSTAGE_CODE, MACHINE_CODE,
            LOCATION_CODE, MATERIAL_MFS, MFS, INVENTORY_TYPE,
            ISSUE_QTY, ISSUE_DEFICIT, ISSUE_PRICE, ISSUE_AMT,
            ISSUE_STATUS, ISSUE_TYPE, ISSUE_ACCOUNT,
            INVOICE_NO, WORK_ORDER_NO, COMMENTS,
            ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
         VALUES
           (TO_DATE(:issueDate, 'YYYY-MM-DD'), :issueSequence, :organizationId,
            :itemCode, :itemType, :lineType, :supplierCode,
            :lineCode, :workstageCode, :machineCode,
            :locationCode, :materialMfs, '${FIXED.mfs}', :inventoryType,
            :issueQty,
            -- 수량 부호가 출고(3)/반납(4)을 정한다 (PB 그대로).
            DECODE(SIGN(:issueQty), -1, '4', '3'),
            :issuePrice, :issueQty * :issuePrice,
            '${FIXED.issueStatus}', '${FIXED.issueType}', :issueAccount,
            :invoiceNo, '${FIXED.workOrderNo}', :comments,
            SYSDATE, :userId, SYSDATE, :userId)`,
        {
          issueDate: dto.issueDate,
          issueSequence,
          organizationId,
          itemCode: dto.itemCode,
          itemType: (items[0].itemType as string) ?? null,
          lineType: dto.lineType ?? (items[0].lineType as string) ?? null,
          supplierCode: dto.supplierCode ?? null,
          lineCode: dto.lineCode,
          workstageCode: dto.workstageCode,
          machineCode: dto.machineCode,
          locationCode: dto.locationCode ?? null,
          materialMfs: dto.materialMfs ?? null,
          inventoryType: dto.inventoryType ?? null,
          issueQty,
          issuePrice: Number(dto.issuePrice ?? 0),
          issueAccount: dto.issueAccount ?? null,
          invoiceNo,
          comments: dto.comments ?? null,
          userId,
        } as unknown as unknown[],
      );

      return {
        issueDate: dto.issueDate,
        issueSequence,
        itemCode: dto.itemCode,
        /** 포장 단위를 적용한 뒤의 실제 출고 수량 */
        issueQty,
        requestedQty: qty,
        /** 3 = 출고 · 4 = 반납 */
        issueDeficit: issueQty < 0 ? 4 : 3,
        invoiceNo,
        rows: Number(affectedRows(result) ?? 0),
      };
    });
  }

  // ───────────────────────────────── 258 출고취소 (쓰기)

  /**
   * 출고취소 (**쓰기**). PB `f_mat_issue_cancel` 을 그대로 옮긴 역분개다.
   *
   * **원장을 지우지 않는다.** 원래 건을 'C' 로 바꾸고 부호를 뒤집은 행을 한 건 넣는다 —
   * 그래야 무엇이 언제 취소됐는지 이력에 남는다.
   */
  async cancelIssue(dto: IssueCancelDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      // 취소할 건이 있고 아직 취소되지 않았는지 본다. PB 는 화면이 고른 행을 그대로
      // 믿었지만, 화면을 우회하면 이미 취소된 건을 또 취소해 원장이 두 번 뒤집힌다.
      const originals = (await qr.query(
        `SELECT s.MFS                       AS "mfs",
                s.WORK_ORDER_NO             AS "workOrderNo",
                s.ITEM_CODE                 AS "itemCode",
                s.ISSUE_QTY                 AS "issueQty",
                s.ISSUE_STATUS              AS "issueStatus",
                s.RETURN_REQUEST_DATE       AS "returnRequestDate",
                s.RETURN_REQUEST_SEQUENCE   AS "returnRequestSequence"
           FROM IM_ITEM_ISSUE s
          WHERE s.ISSUE_DATE = TO_DATE(:issueDate, 'YYYY-MM-DD')
            AND s.ISSUE_SEQUENCE = :issueSequence
            AND s.ORGANIZATION_ID = :organizationId`,
        {
          issueDate: dto.issueDate,
          issueSequence: dto.issueSequence,
          organizationId,
        } as unknown as unknown[],
      )) as Row[];
      if (originals.length === 0) {
        throw new BadRequestException(
          `출고 건을 찾을 수 없습니다: ${dto.issueDate} / ${dto.issueSequence}`,
        );
      }
      const original = originals[0];
      if (String(original.issueStatus ?? '') === 'C') {
        throw new BadRequestException('이미 취소된 출고입니다.');
      }

      // PB 가드 ①: 공정으로 이관된 건은 되돌릴 수 없다.
      // (IM_ITEM_WORKSTAGE_ISSUE_PLAN 이 0행이라 지금은 안 걸리지만 뜻은 살아 있다.)
      const transferred = (await qr.query(
        `SELECT COUNT(*) AS "cnt"
           FROM IM_ITEM_WORKSTAGE_ISSUE_PLAN p
          WHERE p.MFS = :mfs
            AND p.WORK_ORDER_NO = :workOrderNo
            AND p.TRANSFER_YN = 'Y'
            AND p.ORGANIZATION_ID = :organizationId`,
        {
          mfs: (original.mfs as string) ?? null,
          workOrderNo: original.workOrderNo ?? null,
          organizationId,
        } as unknown as unknown[],
      )) as Row[];
      if (Number(transferred[0]?.cnt ?? 0) > 0) {
        throw new BadRequestException(
          '이미 공정으로 이관된 자재라 출고를 취소할 수 없습니다.',
        );
      }

      // PB ②: 원래 건을 취소 상태로. **아직 'C' 가 아닌 건만** 바꾼다 —
      // 두 사람이 동시에 눌러도 한쪽만 1행을 바꾼다 (237 과 같은 관용구).
      const flagged = await qr.query(
        `UPDATE IM_ITEM_ISSUE
            SET ISSUE_STATUS = '${FIXED.cancelStatus}',
                LAST_MODIFY_DATE = SYSDATE,
                LAST_MODIFY_BY = :userId
          WHERE ISSUE_DATE = TO_DATE(:issueDate, 'YYYY-MM-DD')
            AND ISSUE_SEQUENCE = :issueSequence
            AND ORGANIZATION_ID = :organizationId
            AND NVL(ISSUE_STATUS, 'N') <> '${FIXED.cancelStatus}'`,
        {
          userId,
          issueDate: dto.issueDate,
          issueSequence: dto.issueSequence,
          organizationId,
        } as unknown as unknown[],
      );
      const flaggedRows = Number(
        affectedRows(flagged) ?? 0,
      );
      if (flaggedRows !== 1) {
        throw new BadRequestException('이미 취소된 출고입니다.');
      }

      // PB ③: 딸린 반납요청의 확정을 푼다.
      // (IM_ITEM_ISSUE_RETURN_REQUEST 가 0행이라 지금은 0행이 바뀐다.)
      const requestCleared = await qr.query(
        `UPDATE IM_ITEM_ISSUE_RETURN_REQUEST
            SET CONFIRM_YN = 'N',
                CONFIRM_DATE = NULL
          WHERE ISSUE_DATE = :returnRequestDate
            AND ISSUE_SEQUENCE = :returnRequestSequence
            AND CONFIRM_YN = 'Y'
            AND ORGANIZATION_ID = :organizationId`,
        {
          returnRequestDate: original.returnRequestDate ?? null,
          returnRequestSequence: original.returnRequestSequence ?? null,
          organizationId,
        } as unknown as unknown[],
      );

      // PB ④: 부호를 뒤집은 취소 행을 넣는다. 열 목록과 DECODE 는 PB 그대로다.
      const [cancelSeq] = ((await qr.query(
        `SELECT ${SEQUENCES.matIssue}.NEXTVAL AS "seq" FROM DUAL`,
      )) as Row[]).map((r) => Number(r.seq));

      const inserted = await qr.query(
        `INSERT INTO IM_ITEM_ISSUE
           (ISSUE_DATE, ISSUE_SEQUENCE, ORGANIZATION_ID,
            MATERIAL_MFS, MFS, ITEM_CODE, LOCATION_CODE, SUPPLIER_CODE,
            ITEM_TYPE, LINE_CODE, WORKSTAGE_CODE, MACHINE_CODE,
            ISSUE_DEFICIT, ISSUE_QTY, ISSUE_STATUS, ISSUE_AMT, ISSUE_ACCOUNT,
            LINE_TYPE, ISSUE_PRICE, ISSUE_TYPE, VIRTUAL_RECEIPT_YN, WORK_ORDER_NO,
            SALE_PRICE, SALE_AMT, COMMENTS,
            ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY,
            INVOICE_NO, PARENT_ITEM_CODE, INTERFACE_YN, INTERFACE_DATE,
            ARRIVAL_DATE, ARRIVAL_SEQ_NO, DEST_ORGANIZATION_ID,
            BARCODE, FEEDER_SHAFT, FEEDER_LOCATION_CODE, ISSUE_DIVISION,
            FEEDING_GROUP_NO, MODEL_NAME, INVENTORY_TYPE)
         SELECT TRUNC(TO_DATE(:cancelDate, 'YYYY-MM-DD')), :cancelSequence, :organizationId,
                s.MATERIAL_MFS, s.MFS, s.ITEM_CODE, s.LOCATION_CODE, s.SUPPLIER_CODE,
                s.ITEM_TYPE, s.LINE_CODE, s.WORKSTAGE_CODE, s.MACHINE_CODE,
                -- 출고(3) ↔ 반납(4) 을 맞바꾼다.
                DECODE(s.ISSUE_DEFICIT, '3', '4', '4', '3'),
                s.ISSUE_QTY * -1, '${FIXED.cancelStatus}', s.ISSUE_AMT * -1,
                s.ISSUE_ACCOUNT,
                s.LINE_TYPE, s.ISSUE_PRICE, s.ISSUE_TYPE, s.VIRTUAL_RECEIPT_YN,
                s.WORK_ORDER_NO,
                s.SALE_PRICE * -1, s.SALE_AMT * -1, s.COMMENTS,
                SYSDATE, :userId, SYSDATE, :userId,
                s.INVOICE_NO, s.PARENT_ITEM_CODE, s.INTERFACE_YN, s.INTERFACE_DATE,
                s.ARRIVAL_DATE, s.ARRIVAL_SEQ_NO, s.DEST_ORGANIZATION_ID,
                s.BARCODE, s.FEEDER_SHAFT, s.FEEDER_LOCATION_CODE, s.ISSUE_DIVISION,
                s.FEEDING_GROUP_NO, s.MODEL_NAME, s.INVENTORY_TYPE
           FROM IM_ITEM_ISSUE s
          WHERE s.ISSUE_DATE = TO_DATE(:issueDate, 'YYYY-MM-DD')
            AND s.ISSUE_SEQUENCE = :issueSequence
            AND s.ORGANIZATION_ID = :organizationId`,
        {
          cancelDate: dto.cancelDate,
          cancelSequence: cancelSeq,
          organizationId,
          userId,
          issueDate: dto.issueDate,
          issueSequence: dto.issueSequence,
        } as unknown as unknown[],
      );
      const insertedRows = Number(
        affectedRows(inserted) ?? 0,
      );
      if (insertedRows !== 1) {
        // 역분개가 안 들어가면 원장이 반쪽만 바뀐다 — 통째로 되돌린다.
        throw new BadRequestException('취소 행을 넣지 못했습니다. 다시 시도하세요.');
      }

      return {
        issueDate: dto.issueDate,
        issueSequence: dto.issueSequence,
        cancelDate: dto.cancelDate,
        cancelSequence: cancelSeq,
        itemCode: (original.itemCode as string) ?? null,
        canceledQty: Number(original.issueQty ?? 0),
        flaggedRows,
        insertedRows,
        returnRequestRows: Number(
          affectedRows(requestCleared) ?? 0,
        ),
      };
    });
  }
}
