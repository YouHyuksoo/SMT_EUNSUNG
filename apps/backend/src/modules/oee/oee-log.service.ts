/**
 * @file src/modules/oee/oee-log.service.ts
 * @description OEE 가동일지 근무조 로드/저장.
 * 저장은 "해당 근무조 기존 행 DELETE + 신규 INSERT"를 트랜잭션으로 원자화한다.
 * 저장 전 @smt/shared 의 validateIntervals 로 서버 방어 검증(프론트와 동일 정의).
 */
import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, In, Repository } from 'typeorm';
import { validateIntervals } from '@smt/shared';
import type { LogInterval } from '@smt/shared';
import { OeeOperationLog } from '../../entities/oee-operation-log.entity';
import { OeeDowntimeReason } from '../../entities/oee-downtime-reason.entity';
import { OeeResource } from '../../entities/oee-resource.entity';
import { OEE_SHIFT_CODES, LogSaveDto, OeeShift } from './oee.dto';

/** 프론트로 반환하는 근무조 구간 행 */
export interface ShiftLogRow {
  logId: number;
  startMin: number;
  endMin: number;
  status: string;
  reasonCode: string | null;
  runNo: string | null;
  remark: string | null;
}

@Injectable()
export class OeeLogService {
  constructor(
    private readonly dataSource: DataSource,
    @InjectRepository(OeeOperationLog)
    private readonly logRepo: Repository<OeeOperationLog>,
    @InjectRepository(OeeResource)
    private readonly resourceRepo: Repository<OeeResource>,
    @InjectRepository(OeeDowntimeReason)
    private readonly reasonRepo: Repository<OeeDowntimeReason>,
  ) {}

  /** WORK_DATE 00:00 (로컬=KST) 기준 Date */
  private baseDate(workDate: string): Date {
    return new Date(`${workDate}T00:00:00`);
  }

  private toMin(t: Date, base: Date): number {
    return Math.round((t.getTime() - base.getTime()) / 60000);
  }

  async loadShift(
    resourceId: number,
    workDate: string,
    shift: string,
    organizationId?: number,
  ): Promise<ShiftLogRow[]> {
    const organization = this.requireOrganization(organizationId);
    this.assertShift(shift);
    const base = this.baseDate(workDate);
    const rows = await this.logRepo.find({
      where: { resourceId, workDate: base, shift, organizationId: organization },
      order: { startTime: 'ASC' },
    });
    return rows.map((r) => ({
      logId: r.logId,
      startMin: this.toMin(r.startTime, base),
      endMin: this.toMin(r.endTime, base),
      status: r.status,
      reasonCode: r.reasonCode,
      runNo: r.runNo,
      remark: r.remark,
    }));
  }

  async saveShift(dto: LogSaveDto, organizationId?: number, userId?: string): Promise<void> {
    const organization = this.requireOrganization(organizationId);
    const executor = this.requireExecutor(userId);
    this.assertShift(dto.shift);
    const resource = await this.resourceRepo.findOne({
      where: { resourceId: dto.resourceId, organizationId: organization },
    });
    if (!resource) {
      throw new NotFoundException('인증 조직의 OEE 리소스가 아닙니다.');
    }

    const intervals: LogInterval[] = dto.intervals.map((iv) => ({
      startMin: iv.startMin,
      endMin: iv.endMin,
      status: iv.status,
      reasonCode: iv.reasonCode ?? null,
    }));
    const errors = validateIntervals(intervals, dto.netLoadMinutes);
    if (errors.length > 0) {
      throw new BadRequestException({ message: '가동일지 검증 실패', errors });
    }

    const reasonCodes = [...new Set(
      dto.intervals
        .filter((interval) => interval.status === 'DOWN' && interval.reasonCode)
        .map((interval) => interval.reasonCode as string),
    )];
    if (reasonCodes.length > 0) {
      const reasons = await this.reasonRepo.find({
        where: {
          organizationId: organization,
          reasonCode: In(reasonCodes),
          processCode: In(['*', resource.processCode]),
          useYn: 'Y',
        },
      });
      if (new Set(reasons.map((reason) => reason.reasonCode)).size !== reasonCodes.length) {
        throw new BadRequestException('인증 조직과 공정에 등록된 비가동 사유가 아닙니다.');
      }
    }

    const base = this.baseDate(dto.workDate);
    await this.dataSource.transaction(async (manager) => {
      await manager.delete(OeeOperationLog, {
        resourceId: dto.resourceId,
        workDate: base,
        shift: dto.shift,
        organizationId: organization,
      });
      if (dto.intervals.length === 0) return;
      // IDENTITY PK(LOG_ID)·CREATED_DATE(SYSDATE 기본)는 키를 넣지 않아 DB가 생성하도록 한다.
      // (엔티티 인스턴스 대신 plain object를 넣어 LOG_ID가 NULL로 바인딩되는 것을 방지)
      const rows: Partial<OeeOperationLog>[] = dto.intervals.map((iv) => ({
        organizationId: organization,
        resourceId: dto.resourceId,
        processCode: resource.processCode,
        workDate: base,
        shift: dto.shift,
        startTime: new Date(base.getTime() + iv.startMin * 60000),
        endTime: new Date(base.getTime() + iv.endMin * 60000),
        durationMin: iv.endMin - iv.startMin,
        status: iv.status,
        reasonCode: iv.reasonCode ?? null,
        runNo: iv.runNo ?? null,
        remark: iv.remark ?? null,
        createdBy: executor,
      }));
      // Oracle IDENTITY 컬럼은 다중행 INSERT에서 PK가 NULL로 바인딩되는 문제가 있어
      // 단건 insert 루프로 저장한다(단건은 IDENTITY 자동생성 정상).
      for (const row of rows) {
        await manager.insert(OeeOperationLog, row);
      }
    });
  }

  private requireOrganization(organizationId?: number): number {
    if (organizationId == null || !Number.isInteger(organizationId) || organizationId <= 0) {
      throw new BadRequestException('인증 조직 정보가 필요합니다.');
    }
    return organizationId;
  }

  private requireExecutor(userId?: string): string {
    if (typeof userId !== 'string' || userId.trim().length === 0) {
      throw new BadRequestException('인증 실행자 ID가 필요합니다.');
    }
    return userId;
  }

  private assertShift(shift: string): asserts shift is OeeShift {
    if (!OEE_SHIFT_CODES.includes(shift as OeeShift)) {
      throw new BadRequestException('지원하지 않는 OEE 근무조입니다.');
    }
  }
}
