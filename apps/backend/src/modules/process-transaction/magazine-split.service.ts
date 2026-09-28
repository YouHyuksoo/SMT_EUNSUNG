/**
 * @file src/modules/process-transaction/magazine-split.service.ts
 * @description 230 매거진라벨 분할 — PB `w_pln_product_magazine_label_split_master` 이식 (**쓰기**)
 *
 * 초보자 가이드:
 * 1. **상자 하나를 여러 상자로 쪼개는 화면이다.** 400개짜리 매거진에서 50개가
 *    불량으로 판정되면, 350(정상) + 50(불량) 두 라벨로 나눈다.
 * 2. **수량이 늘어나면 안 된다.** 조각 수량의 합은 **언제나 원본 수량과 같다** —
 *    잔량 + 분할 + 불량 + 폐기 = 원본. 이 불변식을 `@smt/shared` 의
 *    `planMagazineSplit` 에 두고 단위테스트로 못 박았다 ([[lot-divide]] 와 같은 이유).
 * 3. **원본 라벨은 없어진다.** 이력표(`IP_PRODUCT_RUN_CARD_IO_BACK`)로 옮기고 지운다.
 *    새 조각들에는 원본 라벨번호를 `TRANSFER_MAGAZINE_LABEL_NO` 로 남겨 되짚을 수 있게 한다.
 * 4. **공정 재고도 같이 갈라야 한다.** PB 는 마지막에 DB 프로시저
 *    `PS_PROD_WS_IO_SPLIT_MAGAZINE(조직, 원본라벨)` 을 부른다 — 이 프로시저가
 *    공정 투입 이력을 조각에 맞춰 나눈다. **TypeScript 로 다시 구현하지 않고
 *    그대로 부른다** (실측 `VALID`). 여기서 갈리면 PB 와 웹의 재고가 어긋난다.
 * 5. **현장은 이 화면을 거의 쓰지 않는다** (실측): `PARENT_MAGAZINE_LABEL_NO` 가
 *    채워진 행이 전 기간 **6건**, 마지막이 2026-04-15 다. 그래도 옮긴 이유는
 *    불량이 섞여 나올 때 유일한 수단이기 때문이다.
 * 6. **쓰기는 실행하지 않고 parse 로만 검증했다** (사용자 결정). 프로시저 호출도
 *    실행하지 않았다 — 현장 확인이 필요하다.
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import {
  buildMagazineLabelNo,
  checkMagazineSplit,
  planMagazineSplit,
} from '@smt/shared';
import { DataSource } from 'typeorm';
import { limited, ROW_LIMIT } from '../../shared/row-limit';
import { TransactionService } from '../../shared/transaction.service';
import { MagazineSplitDto, MagazineSplitQueryDto } from './magazine-label.dto';

type Row = Record<string, unknown>;

const SEQUENCES = {
  label: 'SEQ_MAGAZINE_LABEL_SEQUENCE',
  receipt: 'SEQ_MAGAZINE_RECEIPT_SEQUENCE',
} as const;

@Injectable()
export class MagazineSplitService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  /** 분할 이력 — 부모 라벨이 있는 행만 본다 (분할로 생긴 조각). */
  async findSplits(query: MagazineSplitQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT io.MAGAZINE_LABEL_NO          AS "magazineLabelNo",
              io.MAGAZINE_LABEL_TYPE        AS "magazineLabelType",
              io.PARENT_MAGAZINE_LABEL_NO   AS "parentMagazineLabelNo",
              io.TRANSFER_MAGAZINE_LABEL_NO AS "transferMagazineLabelNo",
              io.MAGAZINE_SET_NO            AS "magazineSetNo",
              io.RUN_NO                     AS "runNo",
              io.MODEL_NAME                 AS "modelName",
              io.MODEL_SUFFIX               AS "modelSuffix",
              io.ITEM_CODE                  AS "itemCode",
              io.LINE_CODE                  AS "lineCode",
              ln.LINE_NAME                  AS "lineName",
              io.WORKSTAGE_CODE             AS "workstageCode",
              io.PCB_ITEM                   AS "pcbItem",
              io.LOT_QTY                    AS "lotQty",
              io.ENTER_BY                   AS "enterBy",
              TO_CHAR(io.RECEIPT_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "receiptDate"
         FROM IP_PRODUCT_RUN_CARD_IO io
         LEFT JOIN IP_PRODUCT_LINE ln
                ON ln.LINE_CODE = io.LINE_CODE
               AND ln.ORGANIZATION_ID = io.ORGANIZATION_ID
        WHERE io.ORGANIZATION_ID = :organizationId
          AND io.RECEIPT_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND io.RECEIPT_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          -- 분할로 생긴 조각만 본다. '*' 는 분할이 아닌 일반 발행이다.
          AND io.PARENT_MAGAZINE_LABEL_NO IS NOT NULL
          AND io.PARENT_MAGAZINE_LABEL_NO <> '*'
        ORDER BY io.RECEIPT_DATE DESC, io.MAGAZINE_SET_NO, io.MAGAZINE_LABEL_NO
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /** 나눌 라벨을 풀어 본다 (읽기 전용). */
  async lookupLabel(magazineLabelNo: string, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT io.MAGAZINE_LABEL_NO   AS "magazineLabelNo",
              io.RUN_NO              AS "runNo",
              io.ITEM_CODE           AS "itemCode",
              io.MODEL_NAME          AS "modelName",
              io.MODEL_SUFFIX        AS "modelSuffix",
              io.LINE_CODE           AS "lineCode",
              ln.LINE_NAME           AS "lineName",
              io.WORKSTAGE_CODE      AS "workstageCode",
              io.PCB_ITEM            AS "pcbItem",
              io.LOT_QTY             AS "lotQty",
              io.MAGAZINE_SET_NO     AS "magazineSetNo",
              io.RECEIPT_STATUS      AS "receiptStatus",
              TO_CHAR(io.RECEIPT_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "receiptDate"
         FROM IP_PRODUCT_RUN_CARD_IO io
         LEFT JOIN IP_PRODUCT_LINE ln
                ON ln.LINE_CODE = io.LINE_CODE
               AND ln.ORGANIZATION_ID = io.ORGANIZATION_ID
        WHERE io.MAGAZINE_LABEL_NO = :magazineLabelNo
          AND io.ORGANIZATION_ID = :organizationId`,
      { magazineLabelNo, organizationId } as unknown as unknown[],
    )) as Row[];

    const label = rows[0] ?? null;
    const reason = !label
      ? '매거진 라벨을 찾을 수 없습니다.'
      : Number(label.lotQty ?? 0) <= 0
        ? '라벨 수량이 0 이하입니다.'
        : !String(label.lineCode ?? '') || !String(label.workstageCode ?? '')
          ? '라인코드·공정코드가 비어 있어 나눌 수 없습니다.'
          : null;

    return { magazineLabelNo, label, splittable: reason === null, reason };
  }

  /**
   * 매거진라벨을 나눈다 (**쓰기**).
   *
   *   ① 세트번호를 하나 뽑는다 — 이번에 나온 조각들이 같은 값을 갖는다
   *   ② 조각마다 라벨번호를 뽑아 행을 넣는다 (`PARENT` 에 원본 라벨번호)
   *   ③ 원본을 이력표로 옮기고 지운다
   *   ④ 조각들에 원본 라벨번호를 `TRANSFER_MAGAZINE_LABEL_NO` 로 적는다
   *   ⑤ `PS_PROD_WS_IO_SPLIT_MAGAZINE` 로 공정 재고를 같이 가른다
   */
  async splitLabel(dto: MagazineSplitDto, organizationId: number, userId: string) {
    const lookup = await this.lookupLabel(dto.magazineLabelNo, organizationId);
    if (!lookup.splittable) {
      throw new BadRequestException(lookup.reason ?? '나눌 수 없는 라벨입니다.');
    }
    const label = lookup.label as Row;
    const lotQty = Number(label.lotQty ?? 0);

    const input = {
      lotQty,
      divideQty: dto.divideQty,
      ngQty: dto.ngQty ?? 0,
      destroyQty: dto.destroyQty ?? 0,
    };
    const verdict = checkMagazineSplit(input);
    if (!verdict.ok) throw new BadRequestException(verdict.reason);
    const plan = planMagazineSplit(input);
    if (plan.totalQty !== lotQty) {
      // 여기 걸리면 공유 규칙이 깨진 것이다. 원장을 건드리기 전에 멈춘다.
      throw new BadRequestException('조각 수량의 합이 원본 수량과 다릅니다.');
    }

    const lineCode = String(label.lineCode ?? '');

    return this.tx.run(async (qr) => {
      const prefixRows = (await qr.query(
        `SELECT SUBSTR(TO_CHAR(SYSDATE, 'YYYY'), 4, 1)
                || F_GET_MONTH_CODE2(TO_CHAR(SYSDATE, 'MM'))
                || F_GET_DAY_CODE(TO_CHAR(SYSDATE, 'DD')) AS "datePrefix",
                ${SEQUENCES.label}.NEXTVAL                AS "setSeq"
           FROM DUAL`,
      )) as Row[];
      const datePrefix = String(prefixRows[0]?.datePrefix ?? '');
      if (!datePrefix) {
        throw new BadRequestException('라벨번호 날짜코드를 만들 수 없습니다.');
      }
      // 세트번호도 라벨번호와 같은 형태다 (PB 그대로).
      const magazineSetNo = buildMagazineLabelNo(
        lineCode, datePrefix, Number(prefixRows[0]?.setSeq ?? 0),
      );

      const seqRows = (await qr.query(
        `SELECT ${SEQUENCES.label}.NEXTVAL   AS "labelSeq",
                ${SEQUENCES.receipt}.NEXTVAL AS "receiptSeq"
           FROM DUAL
        CONNECT BY LEVEL <= :count`,
        { count: plan.pieces.length } as unknown as unknown[],
      )) as Row[];

      const created: { magazineLabelNo: string; labelType: string; qty: number }[] = [];

      for (let i = 0; i < plan.pieces.length; i += 1) {
        const piece = plan.pieces[i];
        const magazineLabelNo = buildMagazineLabelNo(
          lineCode, datePrefix, Number(seqRows[i]?.labelSeq ?? 0),
        );
        const receiptSequence = Number(seqRows[i]?.receiptSeq ?? 0);

        const result = await qr.query(
          `INSERT INTO IP_PRODUCT_RUN_CARD_IO
             (RUN_NO, RECEIPT_DATE, RECEIPT_SEQUENCE, ITEM_CODE,
              MODEL_NAME, MODEL_SUFFIX, LINE_CODE, WORKSTAGE_CODE,
              RECEIPT_DEFICIT, LOT_QTY, ORGANIZATION_ID,
              ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY,
              LAST_LINE_CODE, LAST_WORKSTAGE_CODE,
              MAGAZINE_LABEL_NO, PCB_ITEM, RECEIPT_STATUS, RECEIPT_CONFIRM_YN,
              TRANSACTION_TYPE, TRANSACTION_NO, MAGAZINE_LABEL_TYPE,
              TRANSFER_MODEL_NAME, TRANSFER_MODEL_SUFFIX,
              OK_INCLUDE_QTY, BAD_QTY, DESTROY_QTY,
              MAGAZINE_SET_NO, MFS_GROUP_NO,
              ORIGIN_MAGAZINE_LABEL_NO, PARENT_MAGAZINE_LABEL_NO)
           SELECT :runNo, SYSDATE, :receiptSequence, :itemCode,
                  :modelName, :modelSuffix, :lineCode, :workstageCode,
                  '1', :qty, :organizationId,
                  SYSDATE, :userId, SYSDATE, :userId,
                  :lineCode, :workstageCode,
                  :magazineLabelNo, :pcbItem, 'N', 'N',
                  'R', :receiptSequence, :magazineLabelType,
                  :modelName, :modelSuffix,
                  0, :badQty, :destroyQty,
                  :magazineSetNo, '',
                  :magazineLabelNo, :parentMagazineLabelNo
             FROM DUAL
            WHERE NOT EXISTS (
                    SELECT 1 FROM IP_PRODUCT_RUN_CARD_IO x
                     WHERE x.MAGAZINE_LABEL_NO = :magazineLabelNo
                       AND x.ORGANIZATION_ID = :organizationId)`,
          {
            runNo: String(label.runNo ?? ''),
            receiptSequence,
            itemCode: String(label.itemCode ?? ''),
            modelName: String(label.modelName ?? ''),
            modelSuffix: (label.modelSuffix as string) ?? null,
            lineCode,
            workstageCode: String(label.workstageCode ?? ''),
            qty: piece.qty,
            organizationId,
            userId,
            magazineLabelNo,
            pcbItem: String(label.pcbItem ?? ''),
            magazineLabelType: piece.labelType,
            badQty: piece.labelType === 'B' ? piece.qty : 0,
            destroyQty: piece.labelType === 'D' ? piece.qty : 0,
            magazineSetNo,
            parentMagazineLabelNo: dto.magazineLabelNo,
          } as unknown as unknown[],
        );
        const affected = Number(
          (result as { rowsAffected?: number })?.rowsAffected ?? 0,
        );
        if (affected !== 1) {
          throw new BadRequestException(
            `라벨번호가 이미 쓰이고 있습니다: ${magazineLabelNo}`,
          );
        }
        created.push({ magazineLabelNo, labelType: piece.labelType, qty: piece.qty });
      }

      // ③ 원본을 이력표로 옮기고 지운다.
      const backed = await qr.query(
        `INSERT INTO IP_PRODUCT_RUN_CARD_IO_BACK
           (RECEIPT_DATE, RECEIPT_SEQUENCE, RUN_NO, ITEM_CODE, MODEL_NAME, MODEL_SUFFIX,
            LINE_CODE, WORKSTAGE_CODE, RECEIPT_DEFICIT, LOT_QTY, LAST_WORKSTAGE_CODE,
            MAGAZINE_LABEL_NO, PCB_ITEM, RECEIPT_CONFIRM_YN, RECEIPT_CONFIRM_DATE,
            RECEIPT_CONFIRM_BY, RECEIPT_STATUS, ORGANIZATION_ID, ENTER_DATE, ENTER_BY,
            LAST_MODIFY_DATE, LAST_MODIFY_BY, LAST_LINE_CODE, TRANSACTION_TYPE,
            TRANSACTION_NO, TRANSACTION_YN, MAGAZINE_LABEL_TYPE, RETURN_CONFIRM_YN,
            RETURN_CONFIRM_DATE, IN_DATE, OUT_DATE, OUT_QTY, RUN_DATE, ACTIVE_DATE,
            IN_QTY, IO_DEFICIT, TRANSFER_MODEL_NAME, TRANSFER_MODEL_SUFFIX,
            TRANSFER_MAGAZINE_LABEL_NO, BAD_QTY, DEACTIVE_DATE, WORKSTAGE_STOP_COUNT,
            CYCLE_TIME, ACTIVE_YN, DEFECT_QTY, PRODUCT_RUN_TYPE, MAGAZINE_SET_NO,
            ORIGIN_MAGAZINE_LABEL_NO, PARENT_MAGAZINE_LABEL_NO)
         SELECT io.RECEIPT_DATE, io.RECEIPT_SEQUENCE, io.RUN_NO, io.ITEM_CODE,
                io.MODEL_NAME, io.MODEL_SUFFIX, io.LINE_CODE, io.WORKSTAGE_CODE,
                io.RECEIPT_DEFICIT, io.LOT_QTY, io.LAST_WORKSTAGE_CODE,
                io.MAGAZINE_LABEL_NO, io.PCB_ITEM, io.RECEIPT_CONFIRM_YN,
                io.RECEIPT_CONFIRM_DATE, io.RECEIPT_CONFIRM_BY, io.RECEIPT_STATUS,
                io.ORGANIZATION_ID, io.ENTER_DATE, io.ENTER_BY, io.LAST_MODIFY_DATE,
                io.LAST_MODIFY_BY, io.LAST_LINE_CODE, io.TRANSACTION_TYPE,
                io.TRANSACTION_NO, io.TRANSACTION_YN, io.MAGAZINE_LABEL_TYPE,
                io.RETURN_CONFIRM_YN, io.RETURN_CONFIRM_DATE, io.IN_DATE, io.OUT_DATE,
                io.OUT_QTY, io.RUN_DATE, io.ACTIVE_DATE, io.IN_QTY, io.IO_DEFICIT,
                io.TRANSFER_MODEL_NAME, io.TRANSFER_MODEL_SUFFIX,
                io.TRANSFER_MAGAZINE_LABEL_NO, io.BAD_QTY, io.DEACTIVE_DATE,
                io.WORKSTAGE_STOP_COUNT, io.CYCLE_TIME, io.ACTIVE_YN, io.DEFECT_QTY,
                io.PRODUCT_RUN_TYPE, io.MAGAZINE_SET_NO,
                io.ORIGIN_MAGAZINE_LABEL_NO, io.PARENT_MAGAZINE_LABEL_NO
           FROM IP_PRODUCT_RUN_CARD_IO io
          WHERE io.MAGAZINE_LABEL_NO = :magazineLabelNo
            AND io.ORGANIZATION_ID = :organizationId`,
        {
          magazineLabelNo: dto.magazineLabelNo,
          organizationId,
        } as unknown as unknown[],
      );
      const backedRows = Number(
        (backed as { rowsAffected?: number })?.rowsAffected ?? 0,
      );
      if (backedRows === 0) {
        throw new BadRequestException('원본 라벨이 사라졌습니다. 다시 조회하세요.');
      }

      const deleted = await qr.query(
        `DELETE FROM IP_PRODUCT_RUN_CARD_IO
          WHERE MAGAZINE_LABEL_NO = :magazineLabelNo
            AND ORGANIZATION_ID = :organizationId`,
        {
          magazineLabelNo: dto.magazineLabelNo,
          organizationId,
        } as unknown as unknown[],
      );
      const deletedRows = Number(
        (deleted as { rowsAffected?: number })?.rowsAffected ?? 0,
      );

      // ④ 조각들이 어느 라벨에서 나왔는지 적는다.
      await qr.query(
        `UPDATE IP_PRODUCT_RUN_CARD_IO
            SET TRANSFER_MAGAZINE_LABEL_NO = :parentMagazineLabelNo
          WHERE MAGAZINE_SET_NO = :magazineSetNo
            AND ORGANIZATION_ID = :organizationId`,
        {
          parentMagazineLabelNo: dto.magazineLabelNo,
          magazineSetNo,
          organizationId,
        } as unknown as unknown[],
      );

      // ⑤ 공정 재고를 같이 가른다. PB 와 같은 프로시저를 그대로 부른다.
      //    OUT 바인드를 쓰면 서비스가 oracledb 드라이버를 직접 import 해야 하므로,
      //    저장소 관례대로 블록 안에서 오류로 바꿔 던진다 (jig-check 와 같은 방식).
      //    PB 는 프로시저가 NG 를 내도 앞선 원장 변경을 되돌리지 않았다 — 여기서는
      //    트랜잭션이 통째로 롤백된다.
      await qr.query(
        `DECLARE
           v_out VARCHAR2(4000);
           v_msg VARCHAR2(4000);
         BEGIN
           PS_PROD_WS_IO_SPLIT_MAGAZINE(:organizationId, :magazineLabelNo, v_out, v_msg);
           IF v_out = 'NG' THEN
             RAISE_APPLICATION_ERROR(-20004, 'WS_IO_SPLIT_NG:' || v_msg);
           END IF;
         END;`,
        {
          organizationId,
          magazineLabelNo: dto.magazineLabelNo,
        } as unknown as unknown[],
      ).catch((error: unknown) => {
        const message = error instanceof Error ? error.message : String(error);
        const matched = /WS_IO_SPLIT_NG:(.*)/.exec(message);
        if (matched) {
          throw new BadRequestException(
            `공정 재고 분할에 실패했습니다: ${matched[1].trim() || '사유 없음'}`,
          );
        }
        throw error;
      });

      return {
        magazineLabelNo: dto.magazineLabelNo,
        magazineSetNo,
        created,
        backedRows,
        deletedRows,
        totalQty: plan.totalQty,
      };
    });
  }
}
