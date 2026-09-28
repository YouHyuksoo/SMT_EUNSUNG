/**
 * @file src/modules/process-transaction/magazine-label.service.ts
 * @description 229 매거진라벨 발행 — PB `w_pln_product_magazine_label_master2` 이식 (**쓰기**)
 *
 * 초보자 가이드:
 * 1. **매거진은 PCB 를 담는 상자다.** 런카드(생산지시) 번호를 찍으면 그 지시의
 *    모델과 수량이 나오고, 상자 단위로 라벨을 발행한다. 라벨 한 장이
 *    `IP_PRODUCT_RUN_CARD_IO` 한 행이다 — 여기서부터 공정 투입 이력이 시작된다.
 * 2. **현장이 매일 쓰는 화면이다** (실측): 전 기간 241,345행, 최근 1년 42,860행,
 *    마지막 입력이 오늘이다. 라인 01~12 의 `W180` 공정에서 나온다.
 * 3. **라벨 구분은 정상(P) 하나만 옮겼다** (실측 근거):
 *        P 정상 241,341건 · B 불량 4건(마지막 2024-05) · R 수리 0건 · D 폐기 0건
 *    6년간 0~4건인 경로를 검증 없이 옮기면 위험만 늘어난다 — 필요해지면 그때
 *    실측을 다시 하고 붙인다.
 * 4. **재출력(RePrint)은 옮기지 않았다.** PB 코드를 읽어보면 DB 를 전혀 건드리지
 *    않고 프린터로 같은 라벨을 다시 찍기만 한다. 웹에는 대응물이 없다.
 * 5. **라벨 인쇄 자체도 제외다.** PB 는 DataWindow 5개를 프린터로 보낸다
 *    (`d_pln_product_magazine_*_label_rpt`). 라벨 프린터 연동은 장비 결정이 필요하므로
 *    **원장(라벨 행)만 만든다.** 발행된 라벨번호는 화면에 돌려주므로 출력은 뒤에 붙일 수 있다.
 * 6. **폐기(Destroy)는 옮겼다.** 실측 `IP_PRODUCT_RUN_CARD_IO_BACK` 6,952건, 오늘도
 *    들어온다 — 살아있는 경로다. 라벨을 이력표로 **옮기고 원본을 지운다.**
 * 7. **쓰기는 실행하지 않고 parse 로만 검증했다** (사용자 결정). 현장 확인이 필요하다.
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import {
  buildMagazineLabelNo,
  checkMagazinePrint,
  MAGAZINE_LABEL_TYPE,
  planMagazineLabels,
} from '@smt/shared';
import { DataSource } from 'typeorm';
import { limited, ROW_LIMIT } from '../../shared/row-limit';
import { TransactionService } from '../../shared/transaction.service';
import {
  MagazineDestroyDto,
  MagazineIssueDto,
  MagazineIssuedQueryDto,
} from './magazine-label.dto';

type Row = Record<string, unknown>;

/** 뽑을 시퀀스. 이름을 SQL 에 문자열로 넣으면 주입 통로가 되므로 상수로 묶는다. */
const SEQUENCES = {
  /** 라벨번호 뒤 4자리. */
  label: 'SEQ_MAGAZINE_LABEL_SEQUENCE',
  /** 행 식별용 접수순번(`RECEIPT_SEQUENCE`) 겸 `TRANSACTION_NO`. */
  receipt: 'SEQ_MAGAZINE_RECEIPT_SEQUENCE',
} as const;

/** PB 가 발행행에 고정으로 넣던 값. 주석은 PB 원본의 것을 그대로 옮겼다. */
const FIXED = {
  /** 입고(`'1'`). 실측 최근 1년 42,860건이 전부 이 값이다. */
  receiptDeficit: '1',
  /** 미확인. 공정에서 받아야 `'Y'` 가 된다. */
  receiptStatus: 'N',
  receiptConfirmYn: 'N',
  /** 런카드 발행(`'R'`). 실측도 전부 이 값이다. */
  transactionType: 'R',
  /** 원본 라벨번호가 아직 없으므로 자기 자신을 넣는다 (PB 주석 그대로). */
  parentMagazineLabelNo: '*',
  mfsGroupNo: '',
} as const;

@Injectable()
export class MagazineLabelService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  // ───────────────────────────────── 조회

  /**
   * 런카드 번호를 푼다 (PB `sle_run_no` modified 이벤트).
   *
   * PB 와 같은 두 단계다 — 먼저 런카드번호로 찾고, 없으면 **찍은 것이 매거진
   * 라벨번호라고 보고** 그 라벨이 속한 런카드를 되짚는다. 현장은 라벨을 찍어도
   * 화면이 열리기를 기대한다.
   */
  async lookupRunCard(scan: string, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT rc.RUN_NO             AS "runNo",
              rc.LINE_CODE          AS "lineCode",
              ln.LINE_NAME          AS "lineName",
              rc.MASTER_MODEL_NAME  AS "masterModelName",
              rc.MODEL_NAME         AS "modelName",
              rc.ITEM_CODE          AS "itemCode",
              rc.LOT_SIZE           AS "lotSize",
              rc.PCB_ITEM           AS "pcbItem",
              rc.WORKSTAGE_CODE     AS "workstageCode",
              rc.RUN_STATUS         AS "runStatus",
              TO_CHAR(rc.RUN_DATE, 'YYYY-MM-DD') AS "runDate"
         FROM IP_PRODUCT_RUN_CARD rc
         LEFT JOIN IP_PRODUCT_LINE ln
                ON ln.LINE_CODE = rc.LINE_CODE
               AND ln.ORGANIZATION_ID = rc.ORGANIZATION_ID
        WHERE rc.ORGANIZATION_ID = :organizationId
          AND rc.RUN_NO = COALESCE(
                -- ① 찍은 값이 런카드번호인 경우
                (SELECT x.RUN_NO FROM IP_PRODUCT_RUN_CARD x
                  WHERE x.RUN_NO = :scan AND x.ORGANIZATION_ID = :organizationId
                  FETCH FIRST 1 ROWS ONLY),
                -- ② 매거진 라벨번호인 경우 — 그 라벨이 속한 런카드로 되짚는다
                (SELECT MAX(io.RUN_NO) FROM IP_PRODUCT_RUN_CARD_IO io
                  WHERE io.MAGAZINE_LABEL_NO = :scan
                    AND io.ORGANIZATION_ID = :organizationId))`,
      { scan, organizationId } as unknown as unknown[],
    )) as Row[];

    const runCard = rows[0] ?? null;
    if (!runCard) {
      return { scan, runCard: null, models: [], reason: '런카드를 찾을 수 없습니다.' };
    }
    const models = await this.findModelPlan(
      String(runCard.runNo),
      String(runCard.masterModelName ?? ''),
      Number(runCard.lotSize ?? 0),
      organizationId,
    );
    return { scan, runCard, models, reason: null };
  }

  /**
   * 발행 대상 모델 목록 (PB `d_pln_product_model_by_master_model_lst_es`).
   *
   * 모델기준정보의 `MAGAZINE_SIZE` 가 상자 하나에 담는 수량이고,
   * `F_GET_MAGAZINE_QTY_BY_RUN_NO` 가 이 런카드로 **이미 발행한 수량**이다
   * (SQL 문장 안에서 부르던 DB 함수라 그대로 호출한다).
   *
   * PB 가 그리드를 채운 뒤 하던 계산도 여기서 한다 — 정상수량 = 지시수량 − 발행된수량.
   */
  async findModelPlan(
    runNo: string,
    masterModelName: string,
    lotSize: number,
    organizationId: number,
  ) {
    const rows = (await this.dataSource.query(
      `SELECT m.MODEL_NAME    AS "modelName",
              m.MODEL_SUFFIX  AS "modelSuffix",
              m.ITEM_CODE     AS "itemCode",
              NVL(F_GET_MAGAZINE_QTY_BY_RUN_NO(:runNo, m.ORGANIZATION_ID), 0)
                              AS "magazineQty",
              NVL(m.MAGAZINE_SIZE, 1) AS "packingPcsQty"
         FROM IP_PRODUCT_MODEL_MASTER m
        WHERE m.MASTER_MODEL_NAME = :masterModelName
          AND m.ORGANIZATION_ID = :organizationId
        ORDER BY m.MODEL_NAME`,
      { runNo, masterModelName, organizationId } as unknown as unknown[],
    )) as Row[];

    return rows.map((r) => {
      const magazineQty = Number(r.magazineQty ?? 0);
      const packingPcsQty = Number(r.packingPcsQty ?? 0);
      const okQty = Math.max(lotSize - magazineQty, 0);
      return {
        ...r,
        lotQty: lotSize,
        okQty,
        // PB 는 기본 1장을 제안한다 (남은 수량을 상자 수로 나누지 않는다).
        printQty: okQty === 0 || packingPcsQty === 0 ? 0 : 1,
      };
    });
  }

  /** 발행 이력 (PB `d_pln_product_run_card_io_by_run_no_lst` 결과 그리드). */
  async findIssued(query: MagazineIssuedQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT io.MAGAZINE_LABEL_NO   AS "magazineLabelNo",
              io.MAGAZINE_LABEL_TYPE AS "magazineLabelType",
              io.RUN_NO              AS "runNo",
              io.ITEM_CODE           AS "itemCode",
              io.MODEL_NAME          AS "modelName",
              io.MODEL_SUFFIX        AS "modelSuffix",
              io.LINE_CODE           AS "lineCode",
              ln.LINE_NAME           AS "lineName",
              io.WORKSTAGE_CODE      AS "workstageCode",
              ws.WORKSTAGE_NAME      AS "workstageName",
              io.PCB_ITEM            AS "pcbItem",
              io.LOT_QTY             AS "lotQty",
              io.BAD_QTY             AS "badQty",
              io.DESTROY_QTY         AS "destroyQty",
              io.MAGAZINE_SET_NO     AS "magazineSetNo",
              io.RECEIPT_SEQUENCE    AS "receiptSequence",
              io.RECEIPT_STATUS      AS "receiptStatus",
              io.TRANSFER_MAGAZINE_LABEL_NO AS "transferMagazineLabelNo",
              io.ENTER_BY            AS "enterBy",
              TO_CHAR(io.RECEIPT_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "receiptDate"
         FROM IP_PRODUCT_RUN_CARD_IO io
         LEFT JOIN IP_PRODUCT_LINE ln
                ON ln.LINE_CODE = io.LINE_CODE
               AND ln.ORGANIZATION_ID = io.ORGANIZATION_ID
         LEFT JOIN IP_PRODUCT_WORKSTAGE ws
                ON ws.WORKSTAGE_CODE = io.WORKSTAGE_CODE
               AND ws.ORGANIZATION_ID = io.ORGANIZATION_ID
        WHERE io.ORGANIZATION_ID = :organizationId
          AND io.RUN_NO = :runNo
        ORDER BY io.RECEIPT_DATE DESC, io.RECEIPT_SEQUENCE DESC
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      { runNo: query.runNo, organizationId } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /**
   * 폐기할 라벨을 풀어 본다 (읽기 전용).
   *
   * PB 가 막던 것 두 가지를 그대로 본다:
   *   ① 라벨이 원장에 있고 **매거진 세트번호가 있어야** 한다.
   *   ② 이미 공정에 투입된 라벨은 폐기할 수 없다 (`IP_PRODUCT_WORKSTAGE_IO`).
   */
  async lookupDestroy(magazineLabelNo: string, organizationId: number) {
    const rows = (await this.dataSource.query(
      // 집계 SELECT 의 컬럼 목록에 스칼라 서브쿼리를 넣으면 ORA-00937 이 난다
      // (집계가 아닌 식으로 본다). 그래서 투입 건수는 **따로 센 뒤 붙인다.**
      `SELECT agg.*, io_cnt.WORKSTAGE_IO_COUNT AS "workstageIoCount"
         FROM (SELECT COUNT(*)                AS "labelCount",
                      MAX(io.LINE_CODE)       AS "lineCode",
                      MAX(io.WORKSTAGE_CODE)  AS "workstageCode",
                      MAX(io.PCB_ITEM)        AS "pcbItem",
                      MAX(io.MAGAZINE_SET_NO) AS "magazineSetNo",
                      MAX(io.RUN_NO)          AS "runNo",
                      MAX(io.MODEL_NAME)      AS "modelName",
                      SUM(io.LOT_QTY)         AS "lotQty"
                 FROM IP_PRODUCT_RUN_CARD_IO io
                WHERE io.MAGAZINE_LABEL_NO = :magazineLabelNo
                  AND io.ORGANIZATION_ID = :organizationId) agg
        CROSS JOIN (SELECT COUNT(*) AS WORKSTAGE_IO_COUNT
                      FROM IP_PRODUCT_WORKSTAGE_IO x
                     WHERE x.SERIAL_NO = :magazineLabelNo) io_cnt`,
      { magazineLabelNo, organizationId } as unknown as unknown[],
    )) as Row[];

    const info = rows[0] ?? {};
    const labelCount = Number(info.labelCount ?? 0);
    const setNo = String(info.magazineSetNo ?? '');
    const reason = labelCount === 0 || !setNo
      ? '매거진 라벨을 찾을 수 없거나 세트번호가 없습니다.'
      : Number(info.workstageIoCount ?? 0) > 0
        ? '이미 공정에 투입된 라벨입니다. 폐기할 수 없습니다.'
        : null;

    return {
      magazineLabelNo,
      label: labelCount === 0 ? null : info,
      destroyable: reason === null,
      reason,
    };
  }

  // ───────────────────────────────── 발행 (쓰기)

  /**
   * 정상(P) 매거진라벨을 발행한다 (**쓰기**).
   *
   *   ① 라벨번호 접두어(3글자 날짜코드)를 DB 에서 받는다
   *   ② 공유 규칙으로 라벨 한 장씩의 수량을 계산한다
   *   ③ 장마다 라벨번호·접수순번을 뽑아 `IP_PRODUCT_RUN_CARD_IO` 한 행씩 넣는다
   *
   * 수량 검사는 화면과 **같은 공유 함수**로 한다. 보여준 장수와 들어가는 장수가
   * 달라지면 지시수량을 넘겨 발행하게 된다.
   */
  async issueLabels(dto: MagazineIssueDto, organizationId: number, userId: string) {
    const lookup = await this.lookupRunCard(dto.runNo, organizationId);
    if (!lookup.runCard) {
      throw new BadRequestException(lookup.reason ?? '런카드를 찾을 수 없습니다.');
    }
    const runCard = lookup.runCard as Row;
    const model = lookup.models.find((m) => String(m.modelName) === dto.modelName);
    if (!model) {
      throw new BadRequestException(`런카드에 없는 모델입니다: ${dto.modelName}`);
    }

    const input = {
      planQty: Number(runCard.lotSize ?? 0),
      magazineQty: Number(model.magazineQty ?? 0),
      okQty: dto.okQty,
      okIncludeQty: dto.okIncludeQty ?? 0,
      ngQty: 0,
      packingPcsQty: dto.packingPcsQty ?? Number(model.packingPcsQty ?? 0),
      printQty: dto.printQty,
    };
    const verdict = checkMagazinePrint(input);
    if (!verdict.ok) throw new BadRequestException(verdict.reason);
    const labelQtys = planMagazineLabels(input);
    if (labelQtys.length === 0) {
      throw new BadRequestException('발행할 라벨이 없습니다.');
    }

    const lineCode = String(runCard.lineCode ?? '');
    const workstageCode = dto.workstageCode ?? String(runCard.workstageCode ?? '');
    if (!lineCode || !workstageCode) {
      throw new BadRequestException('라인코드·공정코드가 비어 있습니다.');
    }

    return this.tx.run(async (qr) => {
      // 날짜접두어는 자재 롯트번호와 같은 3글자 코드다 (PB `f_ymd_sysdate()`).
      const prefixRows = (await qr.query(
        `SELECT SUBSTR(TO_CHAR(SYSDATE, 'YYYY'), 4, 1)
                || F_GET_MONTH_CODE2(TO_CHAR(SYSDATE, 'MM'))
                || F_GET_DAY_CODE(TO_CHAR(SYSDATE, 'DD')) AS "datePrefix"
           FROM DUAL`,
      )) as Row[];
      const datePrefix = String(prefixRows[0]?.datePrefix ?? '');
      if (!datePrefix) {
        throw new BadRequestException('라벨번호 날짜코드를 만들 수 없습니다.');
      }

      // 장수만큼 시퀀스를 한 번에 뽑는다 (PB 는 장마다 DB 를 왕복했다).
      const seqRows = (await qr.query(
        `SELECT ${SEQUENCES.label}.NEXTVAL   AS "labelSeq",
                ${SEQUENCES.receipt}.NEXTVAL AS "receiptSeq"
           FROM DUAL
        CONNECT BY LEVEL <= :count`,
        { count: labelQtys.length } as unknown as unknown[],
      )) as Row[];

      const issued: { magazineLabelNo: string; qty: number }[] = [];
      let inserted = 0;

      for (let i = 0; i < labelQtys.length; i += 1) {
        const qty = labelQtys[i];
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
                  :receiptDeficit, :qty, :organizationId,
                  SYSDATE, :userId, SYSDATE, :userId,
                  :lineCode, :workstageCode,
                  :magazineLabelNo, :pcbItem, :receiptStatus, :receiptConfirmYn,
                  :transactionType, :receiptSequence, :magazineLabelType,
                  :modelName, :modelSuffix,
                  0, 0, 0,
                  :magazineSetNo, :mfsGroupNo,
                  :magazineLabelNo, :parentMagazineLabelNo
             FROM DUAL
            WHERE NOT EXISTS (
                    SELECT 1 FROM IP_PRODUCT_RUN_CARD_IO x
                     WHERE x.MAGAZINE_LABEL_NO = :magazineLabelNo
                       AND x.ORGANIZATION_ID = :organizationId)`,
          {
            runNo: String(runCard.runNo),
            receiptSequence,
            itemCode: String(model.itemCode ?? runCard.itemCode ?? ''),
            modelName: dto.modelName,
            modelSuffix: (model.modelSuffix as string) ?? null,
            lineCode,
            workstageCode,
            receiptDeficit: FIXED.receiptDeficit,
            qty,
            organizationId,
            userId,
            magazineLabelNo,
            pcbItem: String(runCard.pcbItem ?? ''),
            receiptStatus: FIXED.receiptStatus,
            receiptConfirmYn: FIXED.receiptConfirmYn,
            transactionType: FIXED.transactionType,
            magazineLabelType: MAGAZINE_LABEL_TYPE.normal,
            magazineSetNo: dto.magazineSetNo ?? magazineLabelNo,
            mfsGroupNo: FIXED.mfsGroupNo,
            parentMagazineLabelNo: FIXED.parentMagazineLabelNo,
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
        inserted += affected;
        issued.push({ magazineLabelNo, qty });
      }

      return {
        runNo: String(runCard.runNo),
        modelName: dto.modelName,
        issued,
        labelCount: issued.length,
        totalQty: issued.reduce((sum, l) => sum + l.qty, 0),
        insertedRows: inserted,
      };
    });
  }

  // ───────────────────────────────── 폐기 (쓰기)

  /**
   * 매거진라벨을 폐기한다 (**쓰기**).
   *
   * PB 그대로 **이력표로 옮기고 원본을 지운다** — `IP_PRODUCT_RUN_CARD_IO_BACK` 로
   * `INSERT … SELECT` 한 뒤 `DELETE`. 지워진 라벨은 조회 화면에서 사라지므로
   * 이력표가 유일한 흔적이다.
   *
   * 투입 여부 검사는 **DELETE 문 안에서 다시** 한다. 조회와 삭제 사이에 공정이
   * 라벨을 투입하면 검사만으로는 막지 못한다.
   */
  async destroyLabel(dto: MagazineDestroyDto, organizationId: number) {
    const lookup = await this.lookupDestroy(dto.magazineLabelNo, organizationId);
    if (!lookup.destroyable) {
      throw new BadRequestException(lookup.reason ?? '폐기할 수 없는 라벨입니다.');
    }

    return this.tx.run(async (qr) => {
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
        throw new BadRequestException('폐기할 라벨이 사라졌습니다. 다시 조회하세요.');
      }

      const deleted = await qr.query(
        `DELETE FROM IP_PRODUCT_RUN_CARD_IO io
          WHERE io.MAGAZINE_LABEL_NO = :magazineLabelNo
            AND io.ORGANIZATION_ID = :organizationId
            -- 조회와 삭제 사이에 공정이 투입했을 수 있다. 문장 안에서 다시 막는다.
            AND NOT EXISTS (
                  SELECT 1 FROM IP_PRODUCT_WORKSTAGE_IO x
                   WHERE x.SERIAL_NO = io.MAGAZINE_LABEL_NO)`,
        {
          magazineLabelNo: dto.magazineLabelNo,
          organizationId,
        } as unknown as unknown[],
      );
      const deletedRows = Number(
        (deleted as { rowsAffected?: number })?.rowsAffected ?? 0,
      );
      if (deletedRows !== backedRows) {
        throw new BadRequestException(
          '폐기 도중 라벨이 공정에 투입됐습니다. 폐기를 취소했습니다.',
        );
      }

      return {
        magazineLabelNo: dto.magazineLabelNo,
        backedRows,
        deletedRows,
      };
    });
  }
}
