/**
 * @file src/modules/jig/jig-clean-check.service.ts
 * @description 195 스퀴지검사관리(세척) — PB `w_mcn_jig_squeeze_clean_check_master` 이식 (**쓰기**)
 *
 * 초보자 가이드:
 * 1. **스퀴지를 쓰기 전에 깨끗한지 보는 화면이다.** 바코드를 찍고 세척(Clean)·
 *    외관(Visual)·공기압(AIR) 을 판정해 합격/불합격을 남긴다.
 * 2. **193 스퀴즈검사관리와 다른 화면이다.** 193(`/jig/squeeze-check`, 이관됨)은
 *    **장력**(Break/Hit)을 보고, 이 화면은 **세척 상태**를 본다. 같은 표
 *    (`IMCN_JIG_SQUEZE_CHECK`)에 남기지만 채우는 칸이 다르다.
 * 3. **현장이 매일 쓴다** (실측): 38,120건, 마지막 입력이 오늘 01:32 다.
 * 4. **합격 여부가 지그 상태를 바꾼다** (PB 그대로):
 *        합격 `'P'` → `IMCN_JIG.USE_STATUS = 'U'`(사용가능) · `TENSION_CHECK_YN = 'Y'`
 *        불합격      → `IMCN_JIG.USE_STATUS = 'S'`(사용정지)
 *    검사기록과 지그상태가 어긋나면 불합격 스퀴지가 라인에 올라간다 —
 *    그래서 **한 트랜잭션에서 같이 움직인다** (PB 는 따로 커밋했다).
 * 5. **스퀴지만 대상이다** (`JIG_TYPE = 'S'`). PB 가 모든 조회에 건 고정조건이다.
 * 6. **쓰기는 실행하지 않고 parse 로만 검증했다** (사용자 결정).
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { limited, ROW_LIMIT } from '../../shared/row-limit';
import { TransactionService } from '../../shared/transaction.service';
import {
  JigCleanCheckQueryDto,
  JigCleanCheckSaveDto,
} from './jig-clean-check.dto';
import { affectedRows } from '../../common/utils/affected-rows.util';

type Row = Record<string, unknown>;

/** 검사순번 채번. PB `f_get_sequence('SEQ_JIG_CHECK_SEQUENCE')` 와 같다. */
const SEQUENCE = 'SEQ_JIG_CHECK_SEQUENCE';

/** PB 고정조건 — 이 화면은 스퀴지만 다룬다. */
const JIG_TYPE = 'S';

/**
 * PB `wf_insert_inspect(arg_check_status)` 로 넘어가던 값.
 * **불합격은 `'N'` 이다.** 실측 전 기간 `P` 37,386 · `N` 731 · `R` 3 —
 * `'F'` 는 한 건도 없다. 여기를 틀리면 웹으로 넣은 불합격이 기존 조회에서 안 보인다.
 * (`'R'` 3건은 2020~21년 재검사로 보이나 화면에 경로가 없어 옮기지 않았다.)
 */
const CHECK_STATUS = { pass: 'P', fail: 'N' } as const;

/** 합격/불합격이 지그에 남기는 상태. */
const USE_STATUS = { usable: 'U', stopped: 'S' } as const;

@Injectable()
export class JigCleanCheckService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  // ───────────────────────────────── 조회

  /**
   * 바코드를 찍었을 때 나오는 정보 (PB `sle_barcode` modified).
   *
   * 지그 기준값(장력 Break/Hit)과 **마지막 세척일**을 함께 낸다 — 마지막 세척일은
   * `CLEAN_YN='Y'` 인 검사 중 가장 최근 것이다.
   */
  async lookupJig(jigLotNo: string, organizationId: number) {
    const trimmed = jigLotNo.trim();
    const rows = (await this.dataSource.query(
      `SELECT j.JIG_CODE          AS "jigCode",
              j.JIG_NAME          AS "jigName",
              j.LINE_CODE         AS "lineCode",
              ln.LINE_NAME        AS "lineName",
              j.BREAK_VALUE       AS "breakValue",
              j.HIT_VALUE         AS "hitValue",
              j.USE_STATUS        AS "useStatus",
              j.TENSION_CHECK_YN  AS "tensionCheckYn",
              TO_CHAR((SELECT MAX(s.JIG_CHECK_DATE)
                         FROM IMCN_JIG_SQUEZE_CHECK s
                        WHERE s.JIG_LOT_NO = :jigLotNo
                          AND s.CLEAN_YN = 'Y'
                          AND s.ORGANIZATION_ID = j.ORGANIZATION_ID),
                      'YYYY-MM-DD HH24:MI:SS') AS "lastCleanDate"
         FROM IMCN_JIG j
         LEFT JOIN IP_PRODUCT_LINE ln
                ON ln.LINE_CODE = j.LINE_CODE
               AND ln.ORGANIZATION_ID = j.ORGANIZATION_ID
        WHERE j.JIG_LOT_NO = :jigLotNo
          AND j.JIG_TYPE = :jigType
          AND j.ORGANIZATION_ID = :organizationId`,
      { jigLotNo: trimmed, jigType: JIG_TYPE, organizationId } as unknown as unknown[],
    )) as Row[];

    const jig = rows[0] ?? null;
    return {
      jigLotNo: trimmed,
      jig,
      reason: jig ? null : `등록된 스퀴지가 아닙니다: ${trimmed}`,
    };
  }

  /** 세척검사 이력 (PB `d_mcn_jig_squeze_check_mlst`). */
  async findChecks(query: JigCleanCheckQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT s.JIG_CODE           AS "jigCode",
              j.JIG_NAME           AS "jigName",
              s.JIG_LOT_NO         AS "jigLotNo",
              s.JIG_CHECK_SEQUENCE AS "jigCheckSequence",
              s.JIG_CHECK_STATUS   AS "jigCheckStatus",
              s.LINE_CODE          AS "lineCode",
              ln.LINE_NAME         AS "lineName",
              s.BREAK_VALUE        AS "breakValue",
              s.HIT_VALUE          AS "hitValue",
              s.AIR_PRESS_VALUE    AS "airPressValue",
              NVL(s.CLEAN_YN, 'N')    AS "cleanYn",
              NVL(s.PIN_HOLE_YN, 'N') AS "pinHoleYn",
              NVL(s.CONFIRM_YN, 'N')  AS "confirmYn",
              s.COMMENTS           AS "comments",
              s.USED_BY            AS "usedBy",
              s.ENTER_BY           AS "enterBy",
              TO_CHAR(s.JIG_CHECK_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "jigCheckDate"
         FROM IMCN_JIG_SQUEZE_CHECK s
         LEFT JOIN IMCN_JIG j
                ON j.JIG_CODE = s.JIG_CODE
               AND j.ORGANIZATION_ID = s.ORGANIZATION_ID
         LEFT JOIN IP_PRODUCT_LINE ln
                ON ln.LINE_CODE = s.LINE_CODE
               AND ln.ORGANIZATION_ID = s.ORGANIZATION_ID
        WHERE s.ORGANIZATION_ID = :organizationId
          AND s.JIG_CHECK_DATE >= TRUNC(TO_DATE(:dateFrom, 'YYYY-MM-DD'))
          AND s.JIG_CHECK_DATE <  TRUNC(TO_DATE(:dateTo, 'YYYY-MM-DD')) + 1
          AND NVL(s.JIG_LOT_NO, '*') LIKE :jigLotNo
        ORDER BY s.JIG_CHECK_DATE DESC, s.JIG_CHECK_SEQUENCE DESC
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        organizationId,
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        jigLotNo: this.like(query.jigLotNo),
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  // ───────────────────────────────── 검사 등록 (쓰기)

  /**
   * 세척검사 결과를 남긴다 (**쓰기**).
   *
   *   ① 검사 한 건을 넣는다
   *   ② 합격이면 지그를 사용가능으로, 불합격이면 사용정지로 바꾼다
   *
   * PB 는 ①과 ②를 따로 커밋했다 — ②가 실패하면 검사기록만 남고 지그는 그대로였다.
   * 여기서는 한 트랜잭션이라 둘 다 되거나 둘 다 안 된다.
   */
  async saveCheck(
    dto: JigCleanCheckSaveDto,
    organizationId: number,
    userId: string,
  ) {
    const lookup = await this.lookupJig(dto.jigLotNo, organizationId);
    if (!lookup.jig) {
      throw new BadRequestException(lookup.reason ?? '스퀴지를 찾을 수 없습니다.');
    }
    const jig = lookup.jig as Row;
    const pass = dto.pass === true;
    // 합격은 세척·외관이 **둘 다 OK** 여야 한다. 화면에도 같은 가드가 있지만,
    // 컨트롤러를 거치지 않는 호출이 불합격 스퀴지를 사용가능으로 만들 수 있다.
    if (pass && !(dto.cleanOk && dto.visualOk)) {
      throw new BadRequestException(
        '세척·외관 중 NG 가 있어 합격으로 남길 수 없습니다.',
      );
    }
    const checkStatus = pass ? CHECK_STATUS.pass : CHECK_STATUS.fail;

    return this.tx.run(async (qr) => {
      const seqRows = (await qr.query(
        `SELECT ${SEQUENCE}.NEXTVAL AS "seq" FROM DUAL`,
      )) as Row[];
      const jigCheckSequence = Number(seqRows[0]?.seq ?? 0);

      await qr.query(
        `INSERT INTO IMCN_JIG_SQUEZE_CHECK
           (JIG_CODE, JIG_LOT_NO, ORGANIZATION_ID, JIG_CHECK_SEQUENCE,
            JIG_CHECK_DATE, JIG_CHECK_STATUS, LINE_CODE,
            BREAK_VALUE, HIT_VALUE, AIR_PRESS_VALUE,
            CLEAN_YN, PIN_HOLE_YN, COMMENTS, USED_BY,
            ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE)
         VALUES
           (:jigCode, :jigLotNo, :organizationId, :jigCheckSequence,
            SYSDATE, :jigCheckStatus, :lineCode,
            :breakValue, :hitValue, :airPressValue,
            :cleanYn, :pinHoleYn, :comments, :userId,
            :userId, SYSDATE, :userId, SYSDATE)`,
        {
          jigCode: String(jig.jigCode ?? ''),
          jigLotNo: dto.jigLotNo.trim(),
          organizationId,
          jigCheckSequence,
          jigCheckStatus: checkStatus,
          lineCode: String(jig.lineCode ?? ''),
          breakValue: dto.breakValue ?? jig.breakValue ?? null,
          hitValue: dto.hitValue ?? jig.hitValue ?? null,
          airPressValue: dto.airPressValue ?? null,
          cleanYn: dto.cleanOk ? 'Y' : 'N',
          pinHoleYn: dto.visualOk ? 'Y' : 'N',
          comments: dto.comments ?? null,
          userId,
        } as unknown as unknown[],
      );

      const updated = await qr.query(
        `UPDATE IMCN_JIG
            SET USE_STATUS = :useStatus
                ${pass ? ', TENSION_CHECK_YN = \'Y\'' : ''},
                LAST_MODIFY_BY = :userId,
                LAST_MODIFY_DATE = SYSDATE
          WHERE JIG_LOT_NO = :jigLotNo
            AND JIG_TYPE = :jigType
            AND ORGANIZATION_ID = :organizationId`,
        {
          useStatus: pass ? USE_STATUS.usable : USE_STATUS.stopped,
          userId,
          jigLotNo: dto.jigLotNo.trim(),
          jigType: JIG_TYPE,
          organizationId,
        } as unknown as unknown[],
      );
      const affected = Number(
        affectedRows(updated) ?? 0,
      );
      if (affected !== 1) {
        throw new BadRequestException(
          '지그 상태를 바꾸지 못했습니다. 검사를 취소했습니다.',
        );
      }

      return {
        jigLotNo: dto.jigLotNo.trim(),
        jigCheckSequence,
        jigCheckStatus: checkStatus,
        useStatus: pass ? USE_STATUS.usable : USE_STATUS.stopped,
      };
    });
  }

  private like(value?: string) {
    const trimmed = (value ?? '').trim();
    return trimmed ? `%${trimmed}%` : '%';
  }
}
