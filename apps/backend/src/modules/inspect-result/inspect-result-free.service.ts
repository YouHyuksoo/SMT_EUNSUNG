// 계획 없는 검사실적 입력 — 모델을 고르고 검사실적을 넣으면 그 수량이 계획(런카드 LOT_SIZE)이 된다.
//
//   작업지시(IP_PRODUCT_RUN_CARD)는 업무일 · 라인 · 검사공정 · 모델당 하나를 서버가 만든다 (COMMENTS = FREE_INSPECT_RUN_MARK).
//   계획수량(LOT_SIZE)은 취소 제외 검사수량 합계다(최소 1, 컬럼 제약). 저장·취소 때마다 다시 맞춘다.
//   검사실적 저장·취소는 InspectResultService 를 그대로 쓴다 — 판정·불량원인 규칙이 한 곳에 있다.
//   타임구간(A~J)은 작업시간 관리(ICOM_WORKTIME_RANGES)의 구간이고 IQ_EQUIP_INSPECT_RESULT.TIME_ZONE 에 저장된다.
//   생산 화면(WorkResultFreeService)이 만든 지시는 COMMENTS 표시가 달라 서로 건드리지 않는다.
import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectDataSource } from '@nestjs/typeorm';
import { DataSource } from 'typeorm';
import { FreeInspectCancelDto, FreeInspectCreateDto } from './inspect-result-free.dto';
import { InspectResultService } from './inspect-result.service';

export const FREE_INSPECT_RUN_MARK = '[검사실적계획]';
const DEFAULT_SHIFT = 'A';
const DEFAULT_USER = 'ADMIN';
/** 2층 조립 후공정이 쓰는 작업시간 구간 종류 (생산실적(계획 없음)과 같다) */
const WORKTIME_RANGE_TYPE = 'WORKTIME';

@Injectable()
export class InspectResultFreeService {
  constructor(
    @InjectDataSource() private readonly dataSource: DataSource,
    private readonly inspect: InspectResultService,
  ) {}

  private requireOrganization(organizationId?: number): number {
    if (organizationId == null || !Number.isInteger(organizationId) || organizationId <= 0) {
      throw new BadRequestException('Authenticated organization is required');
    }
    return organizationId;
  }

  /** 오늘 업무일에 이 화면이 만든 지시 목록 (라인·공정 기준) — 모델별 검사수량 합계 */
  async todayRuns(lineCode: string, workstageCode: string, organizationId?: number) {
    const org = this.requireOrganization(organizationId);
    return this.dataSource.manager.query(
      `SELECT r.RUN_NO AS "runNo", r.MODEL_NAME AS "modelName", r.ITEM_CODE AS "itemCode",
              r.LOT_SIZE AS "planQty",
              NVL((SELECT SUM(ir.INSPECT_QTY) FROM IQ_EQUIP_INSPECT_RESULT ir
                    WHERE ir.RUN_NO=r.RUN_NO AND ir.ORGANIZATION_ID=r.ORGANIZATION_ID
                      AND NVL(ir.RESULT_STATUS,'DONE')<>'CANCEL'),0) AS "resultQty"
         FROM IP_PRODUCT_RUN_CARD r
        WHERE r.ORGANIZATION_ID = :1 AND r.LINE_CODE = :2 AND r.WORKSTAGE_CODE = :3
          AND r.COMMENTS = :4 AND r.RUN_DATE = TRUNC(F_GET_WORK_ACTUAL_DATE(SYSDATE,'A'))
        ORDER BY r.RUN_NO`,
      [org, lineCode, workstageCode, FREE_INSPECT_RUN_MARK],
    );
  }

  /** 계획수량을 취소 제외 검사수량 합계로 맞춘다 */
  private async syncPlan(runNo: string, org: number) {
    await this.dataSource.manager.query(
      `UPDATE IP_PRODUCT_RUN_CARD r
          SET LOT_SIZE = GREATEST(1, NVL((SELECT SUM(ir.INSPECT_QTY) FROM IQ_EQUIP_INSPECT_RESULT ir
                                           WHERE ir.RUN_NO=r.RUN_NO AND ir.ORGANIZATION_ID=r.ORGANIZATION_ID
                                             AND NVL(ir.RESULT_STATUS,'DONE')<>'CANCEL'),0)),
              LAST_MODIFY_DATE = SYSDATE
        WHERE r.RUN_NO = :1 AND r.ORGANIZATION_ID = :2 AND r.COMMENTS = :3`,
      [runNo, org, FREE_INSPECT_RUN_MARK],
    );
  }

  /** 검사실적 저장 — 오늘 업무일의 같은 라인·공정·모델 지시를 쓰고, 없으면 만든다 */
  async createResult(dto: FreeInspectCreateDto, organizationId?: number, userId?: string) {
    const org = this.requireOrganization(organizationId);
    const user = userId ?? DEFAULT_USER;

    const zones = (await this.dataSource.manager.query(
      `SELECT WORK_TYPE AS "code" FROM ICOM_WORKTIME_RANGES WHERE RANGE_TYPE = :1 AND ORGANIZATION_ID = :2`,
      [WORKTIME_RANGE_TYPE, org],
    )) as Array<{ code: string }>;
    if (!zones.some((z) => z.code === dto.timeZone)) throw new BadRequestException('작업시간 관리에 등록되지 않은 타임구간입니다');

    // 공정은 설비의 공정(검사공정 Q)으로 정한다 — 지시를 만들기 전에 막아 빈 지시를 남기지 않는다
    const machine = (await this.dataSource.manager.query(
      `SELECT m.WORKSTAGE_CODE AS "workstageCode",
              (SELECT MAX(w.WORKSTAGE_TYPE) FROM IP_PRODUCT_WORKSTAGE w
                WHERE w.WORKSTAGE_CODE=m.WORKSTAGE_CODE AND w.ORGANIZATION_ID=m.ORGANIZATION_ID) AS "stageType"
         FROM IMCN_MACHINE m WHERE m.MACHINE_CODE=:1 AND m.ORGANIZATION_ID=:2`,
      [dto.machineCode, org],
    )) as Array<{ workstageCode: string | null; stageType: string | null }>;
    if (!machine.length) throw new NotFoundException(`설비를 찾을 수 없습니다: ${dto.machineCode}`);
    const workstageCode = machine[0].workstageCode;
    if (!workstageCode || machine[0].stageType !== 'Q') {
      throw new BadRequestException('검사공정(공정유형 Q) 설비만 검사실적을 넣을 수 있습니다');
    }

    const model = (await this.dataSource.manager.query(
      `SELECT MAX(REVISION) AS "revision" FROM IP_PRODUCT_MODEL_MASTER
        WHERE MODEL_NAME = :1 AND ITEM_CODE = :2 AND ORGANIZATION_ID = :3 HAVING COUNT(*) > 0`,
      [dto.modelName, dto.itemCode, org],
    )) as Array<{ revision: string | null }>;
    if (!model.length) throw new BadRequestException('모델 마스터에 없는 모델·품번입니다');

    const found = (await this.dataSource.manager.query(
      `SELECT MIN(RUN_NO) AS "runNo" FROM IP_PRODUCT_RUN_CARD
        WHERE ORGANIZATION_ID = :1 AND LINE_CODE = :2 AND WORKSTAGE_CODE = :3 AND MODEL_NAME = :4
          AND ITEM_CODE = :5 AND COMMENTS = :6 AND RUN_DATE = TRUNC(F_GET_WORK_ACTUAL_DATE(SYSDATE,'A'))`,
      [org, dto.lineCode, workstageCode, dto.modelName, dto.itemCode, FREE_INSPECT_RUN_MARK],
    )) as Array<{ runNo: string | null }>;

    let runNo = found[0]?.runNo ?? null;
    let created = false;
    if (!runNo) {
      runNo = await this.dataSource.manager.transaction(async (mgr) => {
        const no = (await mgr.query(
          `SELECT F_GET_NEW_RUN_NO(TRUNC(F_GET_WORK_ACTUAL_DATE(SYSDATE,'A')), :1, :2, :3, :4) AS "runNo" FROM DUAL`,
          [dto.modelName, dto.lineCode, DEFAULT_SHIFT, org],
        )) as Array<{ runNo: string }>;
        const newNo = no[0]?.runNo;
        if (!newNo) throw new BadRequestException('작업지시번호 채번에 실패했습니다');
        await mgr.query(
          `INSERT INTO IP_PRODUCT_RUN_CARD
             (ORGANIZATION_ID, RUN_NO, RUN_DATE, LOT_NO, ITEM_CODE, MODEL_NAME, LINE_CODE, WORKSTAGE_CODE,
              LOT_SIZE, CHARGER, SHIFT_CODE, REVISION, ACTIVE_YN, COMMENTS,
              ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE)
           VALUES (:1, :2, TRUNC(F_GET_WORK_ACTUAL_DATE(SYSDATE,'A')), :3, :4, :5, :6, :7,
              1, :8, :9, :10, 'N', :11, :12, SYSDATE, :13, SYSDATE)`,
          [org, newNo, newNo, dto.itemCode, dto.modelName, dto.lineCode, workstageCode,
           dto.inspectorName ?? null, DEFAULT_SHIFT, model[0].revision, FREE_INSPECT_RUN_MARK, user, user],
        );
        return newNo;
      });
      created = true;
    }

    try {
      const saved = await this.inspect.create(
        {
          runNo, machineCode: dto.machineCode, inspectResult: dto.inspectResult, inspectQty: dto.inspectQty,
          badReasonCode: dto.badReasonCode, inspectorName: dto.inspectorName, timeZone: dto.timeZone,
        },
        org, userId,
      );
      await this.syncPlan(runNo, org);
      return { runNo, ...saved };
    } catch (e: unknown) {
      // 방금 만든 지시에 검사실적이 하나도 없으면 빈 지시를 남기지 않는다
      if (created) {
        await this.dataSource.manager.query(
          `DELETE FROM IP_PRODUCT_RUN_CARD r WHERE r.RUN_NO=:1 AND r.ORGANIZATION_ID=:2 AND r.COMMENTS=:3
             AND NOT EXISTS (SELECT 1 FROM IQ_EQUIP_INSPECT_RESULT ir WHERE ir.RUN_NO=r.RUN_NO AND ir.ORGANIZATION_ID=r.ORGANIZATION_ID)`,
          [runNo, org, FREE_INSPECT_RUN_MARK],
        );
      }
      throw e;
    }
  }

  /** 검사실적 취소 — 기존 취소 규칙을 쓰고 계획수량을 다시 맞춘다 */
  async cancelResult(dto: FreeInspectCancelDto, organizationId?: number, userId?: string) {
    const org = this.requireOrganization(organizationId);
    const own = (await this.dataSource.manager.query(
      `SELECT 1 AS "x" FROM IP_PRODUCT_RUN_CARD WHERE RUN_NO=:1 AND ORGANIZATION_ID=:2 AND COMMENTS=:3`,
      [dto.runNo, org, FREE_INSPECT_RUN_MARK],
    )) as unknown[];
    if (!own.length) throw new NotFoundException('이 화면에서 만든 작업지시가 아닙니다');
    const res = await this.inspect.cancel(dto, org, userId);
    await this.syncPlan(dto.runNo, org);
    return res;
  }
}
