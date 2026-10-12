/**
 * @file src/modules/warehouse/manual-input.service.ts
 * @description 239 IMD 라인 자재투입관리 — PB `w_mat_manual_input_history_query` 이식 (**쓰기**)
 *
 * 초보자 가이드:
 * 1. **바코드 없이 라인에 자재를 넣은 것을 손으로 적는 화면이다.** IMD 라인처럼
 *    스캐너가 없는 공정에서 쓴다. 자재 롯트와 작업지시(런번호)를 묶어 남긴다.
 * 2. **이 표는 아직 비어 있다** — `IM_ITEM_MANUAL_INPUT_HISTORY` 가 **0행**이다 (실측).
 *    PB 에도 기능은 있지만 현장에서 쓰기 시작한 적이 없다. 구조는 옮겨 두고
 *    이 사실을 화면에 적었다 — 빈 화면만 보면 "왜 안 나오나" 로 헷갈린다.
 * 3. **`dw_1.update()` 는 무동작이다.** 목록 DataWindow 에 갱신 대상 표가 없다 (실측).
 *    실제 쓰기는 별도 INSERT 한 곳뿐이다.
 * 4. **모델명은 런번호로 찾는다** (`IP_PRODUCT_RUN_CARD`). LEFT JOIN 이므로
 *    런카드가 없어도 이력은 보인다 — NVL 을 걸면 그 행이 사라진다.
 * 5. **쓰기는 실행하지 않고 parse 로만 검증했다** (사용자 결정).
 */
import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { likePrefix } from '@smt/shared';
import { limited, ROW_LIMIT } from '../../shared/row-limit';
import { TransactionService } from '../../shared/transaction.service';
import { ManualInputCreateDto, ManualInputQueryDto } from './warehouse.dto';
import { affectedRows } from '../../common/utils/affected-rows.util';
import { namedBinds } from '../../common/utils/named-binds.util';

type Row = Record<string, unknown>;

@Injectable()
export class ManualInputService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  /** 수동 투입 이력 (PB `d_mat_manual_input_history_lst`). */
  async findHistory(query: ManualInputQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT TO_CHAR(m.INPUT_DATE, 'YYYY-MM-DD HH24:MI:SS')  AS "inputDate",
              m.LINE_CODE                 AS "lineCode",
              F_GET_LINE_NAME(m.LINE_CODE, 1)          AS "lineName",
              m.WORKSTAGE_CODE            AS "workstageCode",
              F_GET_WORKSTAGE_NAME(m.WORKSTAGE_CODE)   AS "workstageName",
              m.RUN_NO                    AS "runNo",
              r.MODEL_NAME                AS "modelName",
              m.MATERIAL_LOT              AS "materialLot",
              m.COMMENTS                  AS "comments",
              m.ENTER_BY                  AS "enterBy",
              TO_CHAR(m.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')        AS "enterDate"
         FROM IM_ITEM_MANUAL_INPUT_HISTORY m
         LEFT JOIN IP_PRODUCT_RUN_CARD r
                ON r.RUN_NO = m.RUN_NO
               AND r.ORGANIZATION_ID = m.ORGANIZATION_ID
        WHERE m.INPUT_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND m.INPUT_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND NVL(m.LINE_CODE, '*') LIKE :lineCode ESCAPE '\\'
          AND NVL(m.WORKSTAGE_CODE, '*') LIKE :workstageCode ESCAPE '\\'
          AND NVL(m.RUN_NO, '*') LIKE :runNo ESCAPE '\\'
          -- 모델명은 LEFT JOIN 컬럼이라 NVL 이 필요하다. 없으면 런카드가 없는
          -- 이력이 조건에서 빠진다 (PB 는 그 때문에 런카드 없는 건을 못 봤다).
          AND NVL(r.MODEL_NAME, '*') LIKE :modelName ESCAPE '\\'
          AND m.ORGANIZATION_ID = :organizationId
        ORDER BY m.INPUT_DATE DESC, m.LINE_CODE, m.RUN_NO
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        lineCode: likePrefix(query.lineCode),
        workstageCode: likePrefix(query.workstageCode),
        runNo: likePrefix(query.runNo),
        modelName: likePrefix(query.modelName),
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }

  /** 수동 투입 등록 (**쓰기**). */
  async createHistory(
    dto: ManualInputCreateDto,
    organizationId: number,
    userId: string,
  ) {
    return this.tx.run(async (qr) => {
      const result = await qr.query(
        `INSERT INTO IM_ITEM_MANUAL_INPUT_HISTORY
           (INPUT_DATE, LINE_CODE, WORKSTAGE_CODE, RUN_NO, MATERIAL_LOT, COMMENTS,
            ORGANIZATION_ID, ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
         VALUES
           (TO_DATE(:inputDate, 'YYYY-MM-DD'), :lineCode, :workstageCode,
            :runNo, :materialLot, :comments,
            :organizationId, SYSDATE, :userId, SYSDATE, :userId)`,
        namedBinds({
          inputDate: dto.inputDate,
          lineCode: dto.lineCode,
          workstageCode: dto.workstageCode,
          runNo: dto.runNo ?? null,
          materialLot: dto.materialLot,
          comments: dto.comments ?? null,
          organizationId,
          userId,
        }),
      );
      return {
        ...dto,
        rows: Number(affectedRows(result) ?? 0),
      };
    });
  }
}
