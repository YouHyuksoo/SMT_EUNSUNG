/**
 * @file src/modules/planning/smd-actual.service.ts
 * @description 반제품생산실적관리 — PB w_pln_assembly_actual_master 이식
 *
 * 초보자 가이드:
 * 1. **생산실적은 조립실적(IP_ASSEMBLY_RESULT)이다** (2026-10-17 센서실적에서 바꿈).
 *    AOI 양품 자동 · 수기 작업실적 · 보정이 한 뷰(IP_ASSEMBLY_RESULT_SENSOR_V)에 모인다.
 *    뷰는 예전 센서 시간대 테이블과 칼럼 이름이 같다. 조회는 기간이 필수다.
 * 2. **집계일시(RECEIPT_DATE)는 작업일이다** (조립실적 PRODUCT_DATE). ISO 문자열로 왕복시키면
 *    JSON 직렬화가 UTC 로 바꾸는 바람에 9시간 밀린다(백엔드는 KST 고정).
 *    그래서 목록은 `receiptDateKey`(YYYYMMDDHH24MISS)를 함께 내리고,
 *    수정·삭제는 그 불투명 키로만 행을 찾는다.
 * 3. **행을 고치거나 지우지 않는다. 보정 행을 더한다** (AssemblyResultService).
 *    수정 = (새 수량 − 지금 수량) 보정, 삭제 = −지금 수량 보정. 같은 런·시각으로 들어가
 *    작업일·시간대가 같고, 전환 이후 실적이면 공정재고도 같이 움직인다.
 * 4. 캐리어 규격은 SQL 안에서 F_GET_CARRIER_SIZE 를 그대로 부른다.
 *    PB 도 같았다 — TypeScript 로 다시 계산하면 PB 화면과 값이 갈린다.
 */
import { Injectable, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { TransactionService } from '../../shared/transaction.service';
import { AssemblyResultService } from '../assembly-result/assembly-result.service';
import {
  SmdActualKeyDto,
  SmdActualQueryDto,
  SmdActualUpdateDto,
  SmdShiftActualQueryDto,
  SmdShiftManualDeleteDto,
  SmdShiftManualSaveDto,
} from './smd-actual.dto';
import { like } from './plan-shared';
import {
  computeShiftActual,
  DAY_TIME_DIVISIONS,
  NIGHT_TIME_DIVISIONS,
  sqlInList,
} from './smd-shift-actual';
import type { SmdShiftSlot } from '../../entities/smd-shift-manual.entity';
import { affectedRows } from '../../common/utils/affected-rows.util';
import { namedBinds } from '../../common/utils/named-binds.util';

type Row = Record<string, unknown>;

@Injectable()
export class SmdActualService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
    private readonly assembly: AssemblyResultService,
  ) {}

  /** 목록 — PB d_pln_product_sensor_actual_time_modify. */
  async find(query: SmdActualQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT TO_CHAR(a.RECEIPT_DATE, 'YYYY-MM-DD') AS "receiptDate",
              TO_CHAR(a.RECEIPT_DATE, 'YYYYMMDDHH24MISS') AS "receiptDateKey",
              a.RECEIPT_SEQUENCE AS "receiptSequence",
              a.LINE_CODE AS "lineCode", pl.LINE_NAME AS "lineName",
              a.MODEL_NAME AS "modelName", a.MODEL_SUFFIX AS "modelSuffix",
              a.WORKSTAGE_CODE AS "workstageCode",
              a.PCB_ITEM AS "pcbItem", pcb.CODE_MEAN_KOR AS "pcbItemName",
              a.PRODUCT_ACTUAL_QTY AS "productActualQty",
              a.PRODUCT_ACTUAL_SUM AS "productActualSum",
              a.PRODUCT_ACTUAL_LOST_QTY AS "productActualLostQty",
              a.ORIGIN_COUNT AS "originCount",
              a.ADJUST_QTY AS "adjustQty",
              a.ACTUAL_TYPE AS "actualType",
              a.TIME_DIVISION AS "timeDivision",
              a.IS_LAST_YN AS "isLastYn",
              a.LAST_RECEIPT_DATE AS "lastReceiptDate",
              TO_CHAR(a.LAST_RECEIPT_DATE, 'YYYY-MM-DD HH24:MI') AS "actualTime",
              F_GET_CARRIER_SIZE(a.MODEL_NAME, a.ORGANIZATION_ID) AS "carrierSize",
              a.RUN_NO AS "runNo", a.ITEM_CODE AS "itemCode",
              a.ACTUAL_SOURCE AS "actualSource", a.REMARK AS "remark",
              a.ENTER_BY AS "enterBy", a.ENTER_DATE AS "enterDate",
              a.LAST_MODIFY_BY AS "lastModifyBy", a.LAST_MODIFY_DATE AS "lastModifyDate"
         FROM IP_ASSEMBLY_RESULT_SENSOR_V a
         LEFT JOIN IP_PRODUCT_LINE pl
                ON pl.LINE_CODE = a.LINE_CODE
               AND pl.ORGANIZATION_ID = a.ORGANIZATION_ID
         LEFT JOIN ISYS_BASECODE pcb
                ON pcb.CODE_TYPE = 'PCB ITEM' AND pcb.CODE_NAME = a.PCB_ITEM
        WHERE a.ORGANIZATION_ID = :organizationId
          AND a.RECEIPT_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND a.RECEIPT_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND NVL(a.LINE_CODE, '*') LIKE :lineCode
          AND NVL(a.MODEL_NAME, '*') LIKE :modelName
          AND NVL(a.WORKSTAGE_CODE, '*') LIKE :workstageCode
        ORDER BY a.RECEIPT_DATE DESC, a.RECEIPT_SEQUENCE DESC`,
      namedBinds({
        organizationId,
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        lineCode: like(query.lineCode),
        modelName: like(query.modelName),
        workstageCode: like(query.workstageCode),
      }),
    )) as Row[];
    return { data: rows, total: rows.length };
  }

  /**
   * 라인·모델별 합계 — PB 는 그리드 합계행으로 보여줬다.
   * 목록과 같은 조건을 쓰되 행을 접어 내린다.
   */
  async findSummary(query: SmdActualQueryDto, organizationId: number) {
    return (await this.dataSource.query(
      `SELECT a.LINE_CODE AS "lineCode", pl.LINE_NAME AS "lineName",
              a.MODEL_NAME AS "modelName",
              COUNT(*) AS "rowCount",
              SUM(NVL(a.PRODUCT_ACTUAL_QTY, 0)) AS "productActualQty",
              SUM(NVL(a.ADJUST_QTY, 0)) AS "adjustQty",
              SUM(NVL(a.PRODUCT_ACTUAL_LOST_QTY, 0)) AS "productActualLostQty",
              MIN(a.RECEIPT_DATE) AS "firstDate",
              MAX(a.RECEIPT_DATE) AS "lastDate"
         FROM IP_ASSEMBLY_RESULT_SENSOR_V a
         LEFT JOIN IP_PRODUCT_LINE pl
                ON pl.LINE_CODE = a.LINE_CODE
               AND pl.ORGANIZATION_ID = a.ORGANIZATION_ID
        WHERE a.ORGANIZATION_ID = :organizationId
          AND a.RECEIPT_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND a.RECEIPT_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND NVL(a.LINE_CODE, '*') LIKE :lineCode
          AND NVL(a.MODEL_NAME, '*') LIKE :modelName
          AND NVL(a.WORKSTAGE_CODE, '*') LIKE :workstageCode
        GROUP BY a.LINE_CODE, pl.LINE_NAME, a.MODEL_NAME
        ORDER BY a.LINE_CODE, a.MODEL_NAME`,
      namedBinds({
        organizationId,
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        lineCode: like(query.lineCode),
        modelName: like(query.modelName),
        workstageCode: like(query.workstageCode),
      }),
    )) as Row[];
  }

  /** 수정 — 행을 바꾸지 않고 (새 수량 − 지금 수량)만큼 보정 행을 더한다. 보정수량 칸은 보정 행에서 계산된다. */
  async update(dto: SmdActualUpdateDto, _organizationId: number, userId: string) {
    return this.assembly.adjustRow(
      dto,
      (current) => dto.productActualQty - current,
      dto.reason?.trim() || '반제품생산실적 수정',
      userId,
    );
  }

  /**
   * 계획별 주야 실적 — 반제품생산계획 한 건당 한 줄.
   * 자동 실적은 조회 시점의 센서 실적을 계획일·라인·모델·서픽스·PCB 면으로 맞춰 더한다
   * (계획 화면이 쓰는 IP_ASSEMBLY_ACTUAL_TIME_V 와 같은 조인 키). 뷰는 표 전체를 접으므로
   * 쓰지 않고, 기간 안의 센서 행만 먼저 접는다. 주간/야간 구분은 smd-shift-actual.ts 참고.
   * 같은 날·라인·모델·서픽스·PCB 면 계획이 여러 건이면 자동 실적이 각 계획에 똑같이 붙는다 —
   * samePlanCount 로 알려 주고 수기로 나눠 넣게 한다.
   */
  async findShiftActual(query: SmdShiftActualQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `WITH s AS (
         SELECT a.RECEIPT_DATE, a.LINE_CODE, a.MODEL_NAME, a.MODEL_SUFFIX, a.PCB_ITEM,
                SUM(CASE WHEN a.TIME_DIVISION IN (${sqlInList(DAY_TIME_DIVISIONS)})
                         THEN NVL(a.PRODUCT_ACTUAL_QTY, 0) ELSE 0 END) AS DAY_QTY,
                SUM(CASE WHEN a.TIME_DIVISION IN (${sqlInList(NIGHT_TIME_DIVISIONS)})
                         THEN NVL(a.PRODUCT_ACTUAL_QTY, 0) ELSE 0 END) AS NIGHT_QTY,
                MAX(a.LAST_RECEIPT_DATE) AS LAST_RECEIPT_DATE
           FROM IP_ASSEMBLY_RESULT_SENSOR_V a
          WHERE a.ORGANIZATION_ID = :organizationId
            AND a.RECEIPT_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
            AND a.RECEIPT_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          GROUP BY a.RECEIPT_DATE, a.LINE_CODE, a.MODEL_NAME, a.MODEL_SUFFIX, a.PCB_ITEM
       )
       SELECT TO_CHAR(p.PLAN_DATE, 'YYYY-MM-DD') AS "planDate",
              p.PLAN_SEQUENCE AS "planSequence",
              p.LINE_CODE AS "lineCode", pl.LINE_NAME AS "lineName",
              p.MODEL_NAME AS "modelName", p.MODEL_SUFFIX AS "modelSuffix",
              p.PCB_ITEM AS "pcbItem", pcb.CODE_MEAN_KOR AS "pcbItemName",
              p.ITEM_CODE AS "itemCode", p.WORK_ORDER_NO AS "workOrderNo",
              p.PLAN_STATUS AS "planStatus", ps.CODE_MEAN_KOR AS "planStatusName",
              p.CONFIRM_YN AS "confirmYn",
              p.PLAN_QTY AS "planQty",
              NVL(s.DAY_QTY, 0) AS "dayAutoQty",
              NVL(s.NIGHT_QTY, 0) AS "nightAutoQty",
              dm.MANUAL_QTY AS "dayManualQty",
              nm.MANUAL_QTY AS "nightManualQty",
              NVL(dm.LAST_MODIFY_BY, dm.ENTER_BY) AS "dayManualBy",
              TO_CHAR(NVL(dm.LAST_MODIFY_DATE, dm.ENTER_DATE), 'YYYY-MM-DD HH24:MI') AS "dayManualDate",
              NVL(nm.LAST_MODIFY_BY, nm.ENTER_BY) AS "nightManualBy",
              TO_CHAR(NVL(nm.LAST_MODIFY_DATE, nm.ENTER_DATE), 'YYYY-MM-DD HH24:MI') AS "nightManualDate",
              TO_CHAR(s.LAST_RECEIPT_DATE, 'YYYY-MM-DD HH24:MI') AS "lastReceiptDate",
              COUNT(*) OVER (PARTITION BY p.PLAN_DATE, p.LINE_CODE, p.MODEL_NAME,
                                          p.MODEL_SUFFIX, p.PCB_ITEM) AS "samePlanCount"
         FROM IP_PRODUCT_SMD_PLAN p
         LEFT JOIN IP_PRODUCT_LINE pl
                ON pl.LINE_CODE = p.LINE_CODE
               AND pl.ORGANIZATION_ID = p.ORGANIZATION_ID
         LEFT JOIN ISYS_BASECODE pcb
                ON pcb.CODE_TYPE = 'PCB ITEM' AND pcb.CODE_NAME = p.PCB_ITEM
         LEFT JOIN ISYS_BASECODE ps
                ON ps.CODE_TYPE = 'PLAN STATUS' AND ps.CODE_NAME = p.PLAN_STATUS
         LEFT JOIN s
                ON s.RECEIPT_DATE = p.PLAN_DATE
               AND s.LINE_CODE = p.LINE_CODE
               AND s.MODEL_NAME = p.MODEL_NAME
               AND s.MODEL_SUFFIX = p.MODEL_SUFFIX
               AND s.PCB_ITEM = p.PCB_ITEM
         LEFT JOIN IP_PRODUCT_SMD_SHIFT_MANUAL dm
                ON dm.PLAN_DATE = p.PLAN_DATE
               AND dm.PLAN_SEQUENCE = p.PLAN_SEQUENCE
               AND dm.ORGANIZATION_ID = p.ORGANIZATION_ID
               AND dm.SHIFT_SLOT = 'DAY'
         LEFT JOIN IP_PRODUCT_SMD_SHIFT_MANUAL nm
                ON nm.PLAN_DATE = p.PLAN_DATE
               AND nm.PLAN_SEQUENCE = p.PLAN_SEQUENCE
               AND nm.ORGANIZATION_ID = p.ORGANIZATION_ID
               AND nm.SHIFT_SLOT = 'NIGHT'
        WHERE p.ORGANIZATION_ID = :organizationId
          AND p.PLAN_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND p.PLAN_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND NVL(p.LINE_CODE, '*') LIKE :lineCode
          AND NVL(p.MODEL_NAME, '*') LIKE :modelName
        ORDER BY p.PLAN_DATE, p.LINE_CODE, p.PLAN_PRIORITY, p.PLAN_SEQUENCE`,
      namedBinds({
        organizationId,
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        lineCode: like(query.lineCode),
        modelName: like(query.modelName),
      }),
    )) as Row[];

    const data = rows.map((row) => ({
      ...row,
      ...computeShiftActual({
        planQty: row.planQty as number | null,
        dayAutoQty: row.dayAutoQty as number | null,
        nightAutoQty: row.nightAutoQty as number | null,
        dayManualQty: row.dayManualQty as number | null,
        nightManualQty: row.nightManualQty as number | null,
      }),
    }));
    return { data, total: data.length };
  }

  /**
   * 수기실적 저장 — 주간·야간을 한 번에 반영한다.
   * 값이 있으면 MERGE(입력자는 처음 값을 두고 수정자만 바꾼다), 비어 있으면 그 근무조 행을 지운다.
   */
  async saveShiftManual(dto: SmdShiftManualSaveDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      const keyBinds = {
        planDate: dto.planDate,
        planSequence: dto.planSequence,
        organizationId,
      };
      const exists = (await qr.query(
        `SELECT COUNT(*) AS CNT FROM IP_PRODUCT_SMD_PLAN
          WHERE PLAN_DATE = TO_DATE(:planDate, 'YYYY-MM-DD')
            AND PLAN_SEQUENCE = :planSequence
            AND ORGANIZATION_ID = :organizationId`,
        namedBinds(keyBinds),
      )) as Array<{ CNT: number }>;
      if (Number(exists?.[0]?.CNT ?? 0) === 0) {
        throw new NotFoundException(
          `반제품생산계획을 찾을 수 없습니다: ${dto.planDate} / 순번 ${dto.planSequence}`,
        );
      }

      const slots: Array<[SmdShiftSlot, number | null | undefined]> = [
        ['DAY', dto.dayManualQty],
        ['NIGHT', dto.nightManualQty],
      ];
      const result: Record<string, 'saved' | 'cleared'> = {};
      for (const [shiftSlot, qty] of slots) {
        if (qty === null || qty === undefined) {
          await qr.query(
            `DELETE FROM IP_PRODUCT_SMD_SHIFT_MANUAL
              WHERE PLAN_DATE = TO_DATE(:planDate, 'YYYY-MM-DD')
                AND PLAN_SEQUENCE = :planSequence
                AND ORGANIZATION_ID = :organizationId
                AND SHIFT_SLOT = :shiftSlot`,
            namedBinds({ ...keyBinds, shiftSlot }),
          );
          result[shiftSlot] = 'cleared';
          continue;
        }
        await qr.query(
          `MERGE INTO IP_PRODUCT_SMD_SHIFT_MANUAL t
           USING (SELECT TO_DATE(:planDate, 'YYYY-MM-DD') AS PLAN_DATE,
                         :planSequence AS PLAN_SEQUENCE,
                         :organizationId AS ORGANIZATION_ID,
                         :shiftSlot AS SHIFT_SLOT
                    FROM DUAL) k
              ON (t.PLAN_DATE = k.PLAN_DATE
                  AND t.PLAN_SEQUENCE = k.PLAN_SEQUENCE
                  AND t.ORGANIZATION_ID = k.ORGANIZATION_ID
                  AND t.SHIFT_SLOT = k.SHIFT_SLOT)
            WHEN MATCHED THEN UPDATE
                 SET t.MANUAL_QTY = :manualQty,
                     t.LAST_MODIFY_BY = :userId,
                     t.LAST_MODIFY_DATE = SYSDATE
            WHEN NOT MATCHED THEN INSERT
                 (PLAN_DATE, PLAN_SEQUENCE, ORGANIZATION_ID, SHIFT_SLOT, MANUAL_QTY,
                  ENTER_BY, ENTER_DATE)
                 VALUES (k.PLAN_DATE, k.PLAN_SEQUENCE, k.ORGANIZATION_ID, k.SHIFT_SLOT,
                         :manualQty, :userId, SYSDATE)`,
          namedBinds({ ...keyBinds, shiftSlot, manualQty: qty, userId }),
        );
        result[shiftSlot] = 'saved';
      }
      return { day: result.DAY, night: result.NIGHT };
    });
  }

  /** 수기실적 삭제 — 지우면 그 근무조는 자동 집계로 돌아간다. */
  async removeShiftManual(dto: SmdShiftManualDeleteDto, organizationId: number) {
    return this.tx.run(async (qr) => {
      const result = await qr.query(
        `DELETE FROM IP_PRODUCT_SMD_SHIFT_MANUAL
          WHERE PLAN_DATE = TO_DATE(:planDate, 'YYYY-MM-DD')
            AND PLAN_SEQUENCE = :planSequence
            AND ORGANIZATION_ID = :organizationId
            AND SHIFT_SLOT LIKE :shiftSlot`,
        namedBinds({
          planDate: dto.planDate,
          planSequence: dto.planSequence,
          organizationId,
          shiftSlot: dto.shiftSlot ?? '%',
        }),
      );
      return { deleted: Number(affectedRows(result) ?? 0) };
    });
  }

  /** 삭제 — 행을 지우지 않고 지금 수량만큼 음수 보정 행을 더한다. */
  async remove(key: SmdActualKeyDto, _organizationId: number, userId: string) {
    const r = await this.assembly.adjustRow(key, (current) => -current, key.reason?.trim() || '반제품생산실적 삭제', userId);
    return { deleted: r.changed };
  }
}
