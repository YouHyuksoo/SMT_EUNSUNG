// 설비별 검사실적관리 — 검사공정(공정유형 Q) 설비에서 작업지시별 판정(합격/불합격)·수량·불량원인을 쌓는다.
//
// 원장: IQ_EQUIP_INSPECT_RESULT (migrations/2026-10-14_iq_equip_inspect_result.sql)
//   완제품 실적(IP_PRODUCT_RESULT)과 별개다. 작업지시(IP_PRODUCT_RUN_CARD)·센서 누적
//   (P_INTERLOCK_SENSOR_ACTUAL_NEO)은 읽기만 하고 쓰지 않는다.
//   SEQ_NO         = 작업지시별 일련번호 (1부터)
//   INSPECT_RESULT = P=합격, R=불합격
//   BAD_REASON_CODE= 불합격이면 필수(WQC BAD REASON CODE), 합격이면 NULL — 테이블 CHECK 도 같다
//   RESULT_STATUS  = DONE=확정, CANCEL=취소 (오늘 업무일 건만 취소)
import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { InspectResultCancelDto, InspectResultCreateDto } from './inspect-result.dto';

const DEFAULT_USER = 'ADMIN';

@Injectable()
export class InspectResultService {
  constructor(private readonly dataSource: DataSource) {}

  private q<T = Record<string, unknown>>(sql: string, params: unknown[] = []): Promise<T[]> {
    return this.dataSource.query(sql, params);
  }

  private requireOrganization(organizationId?: number): number {
    if (organizationId == null || !Number.isInteger(organizationId) || organizationId <= 0) {
      throw new BadRequestException('Authenticated organization is required');
    }
    return organizationId;
  }

  /** 작업지시별 검사실적 이력 */
  results(runNo: string, organizationId?: number) {
    const organization = this.requireOrganization(organizationId);
    return this.q(
      `SELECT ir.SEQ_NO AS "seqNo", ir.MACHINE_CODE AS "machineCode",
              (SELECT MAX(m.MACHINE_NAME) FROM IMCN_MACHINE m
                WHERE m.MACHINE_CODE=ir.MACHINE_CODE AND m.ORGANIZATION_ID=ir.ORGANIZATION_ID) AS "machineName",
              ir.WORKSTAGE_CODE AS "workstageCode",
              ir.INSPECT_RESULT AS "inspectResult", ir.INSPECT_QTY AS "inspectQty",
              ir.BAD_REASON_CODE AS "badReasonCode",
              (SELECT MAX(NVL(c.CODE_MEAN_KOR, c.CODE_MEAN_ENG)) FROM ISYS_CODE_MASTER c
                WHERE c.CODE_TYPE='WQC BAD REASON CODE' AND c.CODE_NAME=ir.BAD_REASON_CODE
                  AND c.ORGANIZATION_ID=ir.ORGANIZATION_ID) AS "badReasonName",
              ir.INSPECTOR_NAME AS "inspectorName", ir.RESULT_STATUS AS "resultStatus",
              TO_CHAR(ir.ENTER_DATE,'YYYY-MM-DD HH24:MI:SS') AS "enteredAt",
              CASE WHEN F_GET_WORK_ACTUAL_DATE(ir.ENTER_DATE,'A') = F_GET_WORK_ACTUAL_DATE(SYSDATE,'A')
                   THEN 'Y' ELSE 'N' END AS "today"
         FROM IQ_EQUIP_INSPECT_RESULT ir
        WHERE ir.RUN_NO=:1 AND ir.ORGANIZATION_ID=:2
        ORDER BY ir.SEQ_NO`,
      [runNo, organization],
    );
  }

  /** 검사실적 1건 등록 — 공정은 설비의 공정(검사공정)으로 서버가 정한다 */
  async create(dto: InspectResultCreateDto, organizationId?: number, userId?: string) {
    const organization = this.requireOrganization(organizationId);
    const user = userId ?? DEFAULT_USER;

    const badReason = dto.inspectResult === 'R' ? dto.badReasonCode?.trim() : undefined;
    if (dto.inspectResult === 'R' && !badReason) throw new BadRequestException('불합격은 불량원인을 골라야 합니다');
    if (dto.inspectResult === 'P' && dto.badReasonCode?.trim()) throw new BadRequestException('합격은 불량원인을 넣지 않습니다');
    // 코드 목록의 OK 는 양품 표시라 불량원인이 될 수 없다
    if (badReason === 'OK') throw new BadRequestException('불합격 불량원인으로 OK 를 쓸 수 없습니다');

    if (badReason) {
      const found = await this.q<{ n: number }>(
        `SELECT COUNT(*) AS "n" FROM ISYS_CODE_MASTER
          WHERE CODE_TYPE='WQC BAD REASON CODE' AND CODE_NAME=:1 AND ORGANIZATION_ID=:2`,
        [badReason, organization],
      );
      if (!Number(found[0]?.n)) throw new BadRequestException(`없는 불량원인 코드입니다: ${badReason}`);
    }

    const machine = (await this.q<{ workstageCode: string | null; stageType: string | null }>(
      `SELECT m.WORKSTAGE_CODE AS "workstageCode",
              (SELECT MAX(w.WORKSTAGE_TYPE) FROM IP_PRODUCT_WORKSTAGE w
                WHERE w.WORKSTAGE_CODE=m.WORKSTAGE_CODE AND w.ORGANIZATION_ID=m.ORGANIZATION_ID) AS "stageType"
         FROM IMCN_MACHINE m WHERE m.MACHINE_CODE=:1 AND m.ORGANIZATION_ID=:2`,
      [dto.machineCode, organization],
    ))[0];
    if (!machine) throw new NotFoundException(`설비를 찾을 수 없습니다: ${dto.machineCode}`);
    if (!machine.workstageCode || machine.stageType !== 'Q') {
      throw new BadRequestException('검사공정(공정유형 Q) 설비만 검사실적을 넣을 수 있습니다');
    }

    return this.dataSource.transaction(async (mgr) => {
      // 작업지시 행을 잠가 같은 작업지시의 일련번호 채번이 겹치지 않게 한다(작업지시 값은 바꾸지 않는다)
      const run = (await mgr.query(
        `SELECT RUN_NO AS "runNo" FROM IP_PRODUCT_RUN_CARD WHERE RUN_NO=:1 AND ORGANIZATION_ID=:2 FOR UPDATE`,
        [dto.runNo, organization],
      )) as Array<{ runNo: string }>;
      if (!run.length) throw new NotFoundException(`작업지시를 찾을 수 없습니다: ${dto.runNo}`);

      const nx = (await mgr.query(
        `SELECT NVL(MAX(SEQ_NO),0) + 1 AS "seq" FROM IQ_EQUIP_INSPECT_RESULT WHERE RUN_NO=:1 AND ORGANIZATION_ID=:2`,
        [dto.runNo, organization],
      )) as Array<{ seq: number }>;
      const seqNo = Number(nx[0]?.seq ?? 1);

      await mgr.query(
        `INSERT INTO IQ_EQUIP_INSPECT_RESULT
           (RUN_NO, SEQ_NO, ORGANIZATION_ID, MACHINE_CODE, WORKSTAGE_CODE,
            INSPECT_RESULT, INSPECT_QTY, BAD_REASON_CODE, INSPECTOR_NAME, RESULT_STATUS, ENTER_BY, ENTER_DATE)
         VALUES (:1,:2,:3,:4,:5,:6,:7,:8,:9,'DONE',:10,SYSDATE)`,
        [
          dto.runNo, seqNo, organization, dto.machineCode, machine.workstageCode,
          dto.inspectResult, dto.inspectQty, badReason ?? null, dto.inspectorName?.trim() || null, user,
        ],
      );
      return { runNo: dto.runNo, seqNo };
    });
  }

  /** 검사실적 취소 — 오늘 업무일 건만. 행은 남긴다 */
  async cancel(dto: InspectResultCancelDto, organizationId?: number, userId?: string) {
    const organization = this.requireOrganization(organizationId);
    const user = userId ?? DEFAULT_USER;
    return this.dataSource.transaction(async (mgr) => {
      const rows = (await mgr.query(
        `SELECT RESULT_STATUS AS "st",
                CASE WHEN F_GET_WORK_ACTUAL_DATE(ENTER_DATE,'A') = F_GET_WORK_ACTUAL_DATE(SYSDATE,'A')
                     THEN 'Y' ELSE 'N' END AS "today"
           FROM IQ_EQUIP_INSPECT_RESULT
          WHERE RUN_NO=:1 AND SEQ_NO=:2 AND ORGANIZATION_ID=:3
          FOR UPDATE`,
        [dto.runNo, dto.seqNo, organization],
      )) as Array<{ st: string; today: string }>;
      const cur = rows[0];
      if (!cur) throw new NotFoundException('검사실적을 찾을 수 없습니다');
      if (cur.st === 'CANCEL') throw new BadRequestException('이미 취소된 검사실적입니다');
      if (cur.today !== 'Y') throw new BadRequestException('오늘 업무일 검사실적만 취소할 수 있습니다');
      await mgr.query(
        `UPDATE IQ_EQUIP_INSPECT_RESULT SET RESULT_STATUS='CANCEL', LAST_MODIFY_BY=:1, LAST_MODIFY_DATE=SYSDATE
          WHERE RUN_NO=:2 AND SEQ_NO=:3 AND ORGANIZATION_ID=:4`,
        [user, dto.runNo, dto.seqNo, organization],
      );
      return { cancelled: true };
    });
  }
}
