// 설비별 비가동 사유 연계 — 헤더/디테일 CRUD (IP_EQUIP_DOWNTIME_MAP[_DTL])
import { BadRequestException, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { EquipDowntimeMap } from '../../entities/equip-downtime-map.entity';
import { EquipReasonMapUpsertDto } from './equip-reason-map.dto';

const ORG = 1;
const DEFAULT_USER = 'ADMIN';

export interface MapReason {
  reasonCode: string; reasonName: string | null;
  reasonType: string | null; oeeReflect: string | null; useYn: string | null;
}
export interface MapRecord {
  machineCode: string; machineName: string | null; machineType: string | null;
  lineCode: string | null; processCode: string | null;
  reasons: MapReason[];
  updatedBy: string | null; updatedAt: string | null;
}

@Injectable()
export class EquipReasonMapService {
  constructor(
    @InjectRepository(EquipDowntimeMap)
    private readonly repo: Repository<EquipDowntimeMap>,
  ) {}

  /** 연계 목록 — 설비(IMCN_MACHINE)·사유(IP_EQUIP_DOWNTIME_REASON) 조인 후 설비 단위로 그룹핑 */
  async list(): Promise<MapRecord[]> {
    const rows: Array<Record<string, unknown>> = await this.repo.manager.query(
      `SELECT h.MACHINE_CODE AS "machineCode",
              m.MACHINE_NAME AS "machineName", m.MACHINE_TYPE AS "machineType",
              m.LINE_CODE AS "lineCode", m.WORKSTAGE_CODE AS "processCode",
              d.REASON_CODE AS "reasonCode",
              r.REASON_NAME AS "reasonName", r.REASON_TYPE AS "reasonType",
              r.OEE_REFLECT_YN AS "oeeReflect", r.USE_YN AS "useYn",
              NVL(h.LAST_MODIFY_BY, h.ENTER_BY) AS "updatedBy",
              TO_CHAR(NVL(h.LAST_MODIFY_DATE, h.ENTER_DATE),'YYYY-MM-DD HH24:MI') AS "updatedAt"
         FROM IP_EQUIP_DOWNTIME_MAP h
         JOIN IP_EQUIP_DOWNTIME_MAP_DTL d
           ON d.MACHINE_CODE = h.MACHINE_CODE AND d.ORGANIZATION_ID = h.ORGANIZATION_ID
         LEFT JOIN IMCN_MACHINE m
           ON m.MACHINE_CODE = h.MACHINE_CODE AND m.ORGANIZATION_ID = h.ORGANIZATION_ID
         LEFT JOIN IP_EQUIP_DOWNTIME_REASON r
           ON r.REASON_CODE = d.REASON_CODE AND r.ORGANIZATION_ID = d.ORGANIZATION_ID
        WHERE h.ORGANIZATION_ID = ${ORG}
        ORDER BY h.MACHINE_CODE, NVL(d.SORT_NO, 0), NVL(r.DISPLAY_ORDER, 0), d.REASON_CODE`,
    );

    const map = new Map<string, MapRecord>();
    for (const r of rows) {
      const code = String(r.machineCode);
      let rec = map.get(code);
      if (!rec) {
        rec = {
          machineCode: code,
          machineName: (r.machineName as string) ?? null,
          machineType: (r.machineType as string) ?? null,
          lineCode: (r.lineCode as string) ?? null,
          processCode: (r.processCode as string) ?? null,
          reasons: [],
          updatedBy: (r.updatedBy as string) ?? null,
          updatedAt: (r.updatedAt as string) ?? null,
        };
        map.set(code, rec);
      }
      rec.reasons.push({
        reasonCode: String(r.reasonCode),
        reasonName: (r.reasonName as string) ?? null,
        reasonType: (r.reasonType as string) ?? null,
        oeeReflect: (r.oeeReflect as string) ?? null,
        useYn: (r.useYn as string) ?? null,
      });
    }
    return [...map.values()];
  }

  /** 신규/수정 — 헤더 upsert + 디테일 전체 교체 (트랜잭션) */
  async upsert(dto: EquipReasonMapUpsertDto): Promise<void> {
    const user = dto.userId ?? DEFAULT_USER;
    // 사유코드 중복 제거 + 빈 값 제거
    const codes = [...new Set(dto.reasonCodes.map((c) => c.trim()).filter(Boolean))];
    if (!codes.length) throw new BadRequestException('비가동 사유코드를 1건 이상 선택하세요');

    await this.repo.manager.transaction(async (mgr) => {
      const exists: Array<{ cnt: number }> = await mgr.query(
        `SELECT COUNT(*) AS "cnt" FROM IP_EQUIP_DOWNTIME_MAP WHERE MACHINE_CODE = :1 AND ORGANIZATION_ID = :2`,
        [dto.machineCode, ORG],
      );
      const isEdit = Number(exists?.[0]?.cnt ?? 0) > 0;
      if (isEdit) {
        await mgr.query(
          `UPDATE IP_EQUIP_DOWNTIME_MAP SET LAST_MODIFY_BY = :1, LAST_MODIFY_DATE = SYSDATE WHERE MACHINE_CODE = :2 AND ORGANIZATION_ID = :3`,
          [user, dto.machineCode, ORG],
        );
      } else {
        await mgr.query(
          `INSERT INTO IP_EQUIP_DOWNTIME_MAP (MACHINE_CODE, ORGANIZATION_ID, ENTER_BY, ENTER_DATE) VALUES (:1, :2, :3, SYSDATE)`,
          [dto.machineCode, ORG, user],
        );
      }
      // 디테일 전체 교체
      await mgr.query(
        `DELETE FROM IP_EQUIP_DOWNTIME_MAP_DTL WHERE MACHINE_CODE = :1 AND ORGANIZATION_ID = :2`,
        [dto.machineCode, ORG],
      );
      let sort = 1;
      for (const reasonCode of codes) {
        await mgr.query(
          `INSERT INTO IP_EQUIP_DOWNTIME_MAP_DTL (MACHINE_CODE, REASON_CODE, ORGANIZATION_ID, SORT_NO, ENTER_BY, ENTER_DATE)
           VALUES (:1, :2, :3, :4, :5, SYSDATE)`,
          [dto.machineCode, reasonCode, ORG, sort++, user],
        );
      }
    });
  }

  /** 설비 단위 연계 전체 삭제 (헤더+디테일) */
  async remove(machineCode: string): Promise<void> {
    await this.repo.manager.transaction(async (mgr) => {
      await mgr.query(`DELETE FROM IP_EQUIP_DOWNTIME_MAP_DTL WHERE MACHINE_CODE = :1 AND ORGANIZATION_ID = :2`, [machineCode, ORG]);
      await mgr.query(`DELETE FROM IP_EQUIP_DOWNTIME_MAP WHERE MACHINE_CODE = :1 AND ORGANIZATION_ID = :2`, [machineCode, ORG]);
    });
  }
}
