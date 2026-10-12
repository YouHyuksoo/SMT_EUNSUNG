/**
 * @file src/modules/planning/smd-plan-board.service.ts
 * @description 반제품생산계획 현황판 — 날짜 하나의 라인별 블록에 필요한 보조 데이터와 특이사항 메모.
 *
 * 초보자 가이드:
 * 1. **계획 행과 시간대 실적은 여기서 만들지 않는다.** 화면이 기존
 *    `GET /production/smd-plan?dateFrom=d&dateTo=d` 를 그대로 부른다 —
 *    계획↔실적 조인 규칙을 두 곳에 두지 않기 위해서다.
 * 2. 이 서비스가 주는 것은 네 가지다.
 *    - 시간대 정의: ICOM_WORKTIME_RANGES(SMTWORKTIME) A~J. 센서 프로시저가
 *      F_GET_WORKTIME_SMT_ZONE 으로 이 구간을 찍는다. 그 함수가 조직을 거르지 않아 여기서도 거르지 않는다.
 *      앞 5칸(A~E)이 주간 08:30~20:30, 뒤 5칸(F~J)이 야간 20:30~다음날 08:30 이다.
 *    - 라인 목록: 생산 1팀 = SMT 라인구분(@smt/shared SMT_LINE_DIVISIONS, 실데이터는 'D') 중
 *      모니터링 표시(MES_DISPLAY_YN='Y') 라인 + 그날 계획·실적·메모가 있는 라인.
 *      계획이 없는 라인도 메모를 적을 수 있게 빈 블록으로 내려준다.
 *    - 계획 외 실적: 그날 센서 실적 중 같은 날 계획(라인·모델·서픽스·PCB 면)과 맞지 않는 것.
 *      전날 이전 계획을 이어서 생산하면 여기에 나온다. 조인 조건은 PLAN_TABLES.smd.actualJoin 을 쓴다.
 *    - 특이사항·공지: IP_PRODUCT_SMD_PLAN_NOTE. LINE_CODE='*' 는 날짜 전체 공지다.
 * 3. **메모 저장은 날짜+라인 단위로 통째로 바꾼다.** 기존 줄을 지우고 1..n 으로 다시 넣는다.
 *    입력자·입력일시는 마지막으로 저장한 사람·시각이 된다.
 */
import { Injectable, NotFoundException } from '@nestjs/common';
import { SMT_LINE_DIVISIONS } from '@smt/shared';
import { DataSource } from 'typeorm';
import { TransactionService } from '../../shared/transaction.service';
import { namedBinds } from '../../common/utils/named-binds.util';
import { actualTimeColumns } from './plan-shared';
import { PLAN_TABLES } from './plan-base.service';
import { BOARD_NOTICE_LINE, SmdPlanBoardNoteSaveDto } from './smd-plan-board.dto';

type Row = Record<string, unknown>;

export interface BoardNoteGroup {
  lines: string[];
  enterBy: string | null;
  enterDate: string | null;
}

/** 저장할 메모 줄 — 앞뒤 공백을 지우고 빈 줄은 버린다. */
export function normalizeNoteLines(lines: readonly string[]): string[] {
  return lines.map((line) => line.trim()).filter((line) => line.length > 0);
}

/** 메모 행을 라인코드별 묶음으로. '*' 는 날짜 공지다. */
export function groupNotes(rows: ReadonlyArray<Row>): Record<string, BoardNoteGroup> {
  const groups: Record<string, BoardNoteGroup> = {};
  for (const row of rows) {
    const lineCode = String(row.lineCode);
    const group = groups[lineCode] ?? { lines: [], enterBy: null, enterDate: null };
    group.lines.push(String(row.noteText ?? ''));
    group.enterBy = (row.enterBy as string | null) ?? group.enterBy;
    group.enterDate = (row.enterDate as string | null) ?? group.enterDate;
    groups[lineCode] = group;
  }
  return groups;
}

@Injectable()
export class SmdPlanBoardService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  async getBoard(date: string, organizationId: number) {
    const smd = PLAN_TABLES.smd;
    const divisionBinds = Object.fromEntries(SMT_LINE_DIVISIONS.map((d, i) => [`div${i}`, d]));
    const divisionList = Object.keys(divisionBinds).map((k) => `:${k}`).join(', ');

    const [slots, lines, extraActuals, noteRows] = await Promise.all([
      this.dataSource.query(
        `SELECT WORK_TYPE AS "code", START_TIME AS "startTime", END_TIME AS "endTime"
           FROM ICOM_WORKTIME_RANGES
          WHERE RANGE_TYPE = 'SMTWORKTIME'
          ORDER BY WORK_TYPE`,
      ) as Promise<Row[]>,
      this.dataSource.query(
        `SELECT l.LINE_CODE AS "lineCode", l.LINE_NAME AS "lineName"
           FROM IP_PRODUCT_LINE l
          WHERE l.ORGANIZATION_ID = :organizationId
            AND (   (l.LINE_DIVISION IN (${divisionList}) AND l.MES_DISPLAY_YN = 'Y')
                 OR l.LINE_CODE IN (SELECT p.LINE_CODE FROM ${smd.table} p
                                     WHERE p.ORGANIZATION_ID = :organizationId
                                       AND p.PLAN_DATE = TO_DATE(:planDate, 'YYYY-MM-DD'))
                 OR l.LINE_CODE IN (SELECT v.LINE_CODE FROM ${smd.actualView} v
                                     WHERE v.RECEIPT_DATE = TO_DATE(:planDate, 'YYYY-MM-DD'))
                 OR l.LINE_CODE IN (SELECT n.LINE_CODE FROM IP_PRODUCT_SMD_PLAN_NOTE n
                                     WHERE n.ORGANIZATION_ID = :organizationId
                                       AND n.PLAN_DATE = TO_DATE(:planDate, 'YYYY-MM-DD')))
          ORDER BY NVL(l.MES_DISPLAY_SEQUENCE, 9999), l.LINE_CODE`,
        namedBinds({ organizationId, planDate: date, ...divisionBinds }),
      ) as Promise<Row[]>,
      this.dataSource.query(
        `SELECT v.LINE_CODE AS "lineCode", v.MODEL_NAME AS "modelName",
                v.MODEL_SUFFIX AS "modelSuffix", v.PCB_ITEM AS "pcbItem",
                pcb.CODE_MEAN_KOR AS "pcbItemName",
                ${actualTimeColumns('v')}
           FROM ${smd.actualView} v
           LEFT JOIN ISYS_BASECODE pcb
                  ON pcb.CODE_TYPE = 'PCB ITEM' AND pcb.CODE_NAME = v.PCB_ITEM
          WHERE v.RECEIPT_DATE = TO_DATE(:planDate, 'YYYY-MM-DD')
            AND NOT EXISTS (
                  SELECT 1 FROM ${smd.table} p
                   WHERE p.ORGANIZATION_ID = :organizationId
                     AND ${smd.actualJoin.map(([planCol, viewCol]) => `p.${planCol} = v.${viewCol}`).join('\n                     AND ')})
          ORDER BY v.LINE_CODE, v.MODEL_NAME, v.PCB_ITEM`,
        namedBinds({ organizationId, planDate: date }),
      ) as Promise<Row[]>,
      this.dataSource.query(
        `SELECT LINE_CODE AS "lineCode", NOTE_SEQ AS "noteSeq", NOTE_TEXT AS "noteText",
                ENTER_BY AS "enterBy", TO_CHAR(ENTER_DATE, 'YYYY-MM-DD HH24:MI') AS "enterDate"
           FROM IP_PRODUCT_SMD_PLAN_NOTE
          WHERE ORGANIZATION_ID = :organizationId
            AND PLAN_DATE = TO_DATE(:planDate, 'YYYY-MM-DD')
          ORDER BY LINE_CODE, NOTE_SEQ`,
        namedBinds({ organizationId, planDate: date }),
      ) as Promise<Row[]>,
    ]);

    const notes = groupNotes(noteRows);
    const notice = notes[BOARD_NOTICE_LINE] ?? { lines: [], enterBy: null, enterDate: null };
    delete notes[BOARD_NOTICE_LINE];
    return { date, slots, lines, extraActuals, notice, lineNotes: notes };
  }

  async saveNotes(dto: SmdPlanBoardNoteSaveDto, organizationId: number, userId: string) {
    const lines = normalizeNoteLines(dto.lines);
    if (dto.lineCode !== BOARD_NOTICE_LINE) {
      const found = (await this.dataSource.query(
        `SELECT COUNT(*) AS CNT FROM IP_PRODUCT_LINE
          WHERE LINE_CODE = :lineCode AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ lineCode: dto.lineCode, organizationId }),
      )) as Array<{ CNT: number }>;
      if (Number(found?.[0]?.CNT ?? 0) === 0) {
        throw new NotFoundException(`라인을 찾을 수 없습니다: ${dto.lineCode}`);
      }
    }

    return this.tx.run(async (qr) => {
      await qr.query(
        `DELETE FROM IP_PRODUCT_SMD_PLAN_NOTE
          WHERE PLAN_DATE = TO_DATE(:planDate, 'YYYY-MM-DD')
            AND ORGANIZATION_ID = :organizationId
            AND LINE_CODE = :lineCode`,
        namedBinds({ planDate: dto.date, organizationId, lineCode: dto.lineCode }),
      );
      for (const [index, noteText] of lines.entries()) {
        await qr.query(
          `INSERT INTO IP_PRODUCT_SMD_PLAN_NOTE
                  (PLAN_DATE, ORGANIZATION_ID, LINE_CODE, NOTE_SEQ, NOTE_TEXT,
                   ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE)
           VALUES (TO_DATE(:planDate, 'YYYY-MM-DD'), :organizationId, :lineCode, :noteSeq, :noteText,
                   :userId, SYSDATE, :userId, SYSDATE)`,
          namedBinds({
            planDate: dto.date,
            organizationId,
            lineCode: dto.lineCode,
            noteSeq: index + 1,
            noteText,
            userId,
          }),
        );
      }
      return { date: dto.date, lineCode: dto.lineCode, saved: lines.length };
    });
  }
}
