// 설비 비가동 사유코드 — IP_EQUIP_DOWNTIME_REASON CRUD
import { ConflictException, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { EquipDowntimeReason } from '../../entities/equip-downtime-reason.entity';
import { IdleReasonUpsertDto } from './idle-reason.dto';

const ORG = 1;
const DEFAULT_USER = 'ADMIN';

// 매뉴얼 첨부 업무구분 — FileAttachment businessType 과 일치
const MANUAL_BIZ = '설비비가동사유';

export interface IdleReasonRow {
  reasonCode: string; reasonName: string; description: string | null;
  reasonType: string | null; oeeReflect: string | null; displayOrder: number | null;
  stdTimeEnabled: boolean; stdTimeValue: number | null; stdTimeUnit: string | null;
  useYn: string | null; manualCount: number; updatedBy: string | null; updatedAt: string | null;
}

@Injectable()
export class IdleReasonService {
  constructor(
    @InjectRepository(EquipDowntimeReason)
    private readonly repo: Repository<EquipDowntimeReason>,
  ) {}

  async list(): Promise<IdleReasonRow[]> {
    const rows: Array<Record<string, unknown>> = await this.repo.manager.query(
      `SELECT REASON_CODE AS "reasonCode", REASON_NAME AS "reasonName", DESCRIPTION AS "description",
              REASON_TYPE AS "reasonType", OEE_REFLECT_YN AS "oeeReflect", DISPLAY_ORDER AS "displayOrder",
              STD_TIME_YN AS "stdTimeYn", STD_TIME_VALUE AS "stdTimeValue", STD_TIME_UNIT AS "stdTimeUnit",
              USE_YN AS "useYn",
              (SELECT COUNT(*) FROM FILE_ATTACHMENTS f
                WHERE f.BUSINESS_TYPE = '${MANUAL_BIZ}' AND f.REF_KEY = r.REASON_CODE AND f.DEL_YN = 'N') AS "manualCount",
              NVL(LAST_MODIFY_BY, ENTER_BY) AS "updatedBy",
              TO_CHAR(NVL(LAST_MODIFY_DATE, ENTER_DATE),'YYYY-MM-DD HH24:MI') AS "updatedAt"
         FROM IP_EQUIP_DOWNTIME_REASON r WHERE ORGANIZATION_ID = ${ORG}
        ORDER BY DISPLAY_ORDER, REASON_CODE`,
    );
    return rows.map((r) => ({
      reasonCode: String(r.reasonCode),
      reasonName: String(r.reasonName ?? ''),
      description: (r.description as string) ?? null,
      reasonType: (r.reasonType as string) ?? null,
      oeeReflect: (r.oeeReflect as string) ?? null,
      displayOrder: r.displayOrder != null ? Number(r.displayOrder) : null,
      stdTimeEnabled: r.stdTimeYn === 'Y',
      stdTimeValue: r.stdTimeValue != null ? Number(r.stdTimeValue) : null,
      stdTimeUnit: (r.stdTimeUnit as string) ?? null,
      useYn: (r.useYn as string) ?? null,
      manualCount: r.manualCount != null ? Number(r.manualCount) : 0,
      updatedBy: (r.updatedBy as string) ?? null,
      updatedAt: (r.updatedAt as string) ?? null,
    }));
  }

  private fields(dto: IdleReasonUpsertDto) {
    return {
      reasonName: dto.reasonName,
      description: dto.description ?? null,
      reasonType: dto.reasonType,
      oeeReflectYn: dto.oeeReflect,
      displayOrder: dto.displayOrder ?? 0,
      stdTimeYn: dto.stdTimeEnabled ? 'Y' : 'N',
      stdTimeValue: dto.stdTimeEnabled ? (dto.stdTimeValue ?? 0) : 0,
      stdTimeUnit: dto.stdTimeUnit,
      useYn: dto.useYn,
    };
  }

  async create(dto: IdleReasonUpsertDto): Promise<void> {
    const exists = await this.repo.findOne({ where: { reasonCode: dto.reasonCode, organizationId: ORG } });
    if (exists) throw new ConflictException(`이미 등록된 사유코드입니다 (${dto.reasonCode})`);
    const user = dto.userId ?? DEFAULT_USER;
    await this.repo.insert({
      reasonCode: dto.reasonCode, organizationId: ORG, ...this.fields(dto),
      enterBy: user, enterDate: new Date(),
    });
  }

  async update(dto: IdleReasonUpsertDto): Promise<void> {
    const user = dto.userId ?? DEFAULT_USER;
    await this.repo.update(
      { reasonCode: dto.reasonCode, organizationId: ORG },
      { ...this.fields(dto), lastModifyBy: user, lastModifyDate: new Date() },
    );
  }

  async remove(reasonCode: string): Promise<void> {
    await this.repo.delete({ reasonCode, organizationId: ORG });
  }
}
