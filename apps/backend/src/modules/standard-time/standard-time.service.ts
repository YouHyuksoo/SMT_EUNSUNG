// 표준시간 관리 — IP_PRODUCT_ST_MASTER CRUD (모델코드+설비코드+적용시작일 키)
import { ConflictException, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ProductStMaster } from '../../entities/product-st-master.entity';
import { StdTimeUpsertDto } from './standard-time.dto';

const ORG = 1; // 은성 단일 조직
const DEFAULT_USER = 'ADMIN';

export interface StdTimeRow {
  itemCode: string; modelName: string | null;
  machineCode: string | null; machineName: string | null;
  validFrom: string; validTo: string;
  st: number | null; ct: number | null; nt: number | null; tt: number | null;
  remark: string | null; registeredBy: string | null; updatedBy: string | null; updatedAt: string | null;
}

@Injectable()
export class StandardTimeService {
  constructor(
    @InjectRepository(ProductStMaster)
    private readonly repo: Repository<ProductStMaster>,
  ) {}

  /** 표준시간 목록 (모델명=IP_PRODUCT_MODEL_MASTER, 설비명=IMCN_MACHINE 조인) */
  list(): Promise<StdTimeRow[]> {
    return this.repo.manager.query(
      `SELECT s.ITEM_CODE AS "itemCode",
              (SELECT MAX(m.MODEL_NAME) FROM IP_PRODUCT_MODEL_MASTER m
                WHERE m.PART_NO = s.ITEM_CODE AND m.ORGANIZATION_ID = s.ORGANIZATION_ID) AS "modelName",
              s.MACHINE_CODE AS "machineCode",
              (SELECT MAX(mc.MACHINE_NAME) FROM IMCN_MACHINE mc
                WHERE mc.MACHINE_CODE = s.MACHINE_CODE AND mc.ORGANIZATION_ID = s.ORGANIZATION_ID) AS "machineName",
              TO_CHAR(s.DATESET,'YYYY-MM-DD') AS "validFrom",
              TO_CHAR(s.DATEEND,'YYYY-MM-DD') AS "validTo",
              s.ST_VALUE AS "st", s.CT_VALUE AS "ct", s.NT_VALUE AS "nt", s.TT_VALUE AS "tt",
              s.REMARK AS "remark",
              s.ENTER_BY AS "registeredBy",
              NVL(s.LAST_MODIFY_BY, s.ENTER_BY) AS "updatedBy",
              TO_CHAR(NVL(s.LAST_MODIFY_DATE, s.ENTER_DATE),'YYYY-MM-DD HH24:MI') AS "updatedAt"
         FROM IP_PRODUCT_ST_MASTER s
        WHERE s.ORGANIZATION_ID = ${ORG}
        ORDER BY s.ITEM_CODE, s.MACHINE_CODE, s.DATESET`,
    );
  }

  /** 신규/수정 — 원본 키(모델코드+설비코드+적용시작일)가 오면 삭제 후 삽입. 날짜는 문자열 매칭. */
  async upsert(dto: StdTimeUpsertDto): Promise<void> {
    const isEdit = !!dto.originalItemCode && !!dto.originalMachineCode && !!dto.originalValidFrom;
    const keyChanged = isEdit && (
      dto.originalItemCode !== dto.itemCode ||
      dto.originalMachineCode !== dto.machineCode ||
      dto.originalValidFrom !== dto.validFrom
    );
    const user = dto.userId ?? DEFAULT_USER;

    await this.repo.manager.transaction(async (mgr) => {
      // 중복 체크: 신규이거나 키(모델코드+설비코드+적용시작일) 변경 시 대상 키 존재 여부
      if (!isEdit || keyChanged) {
        const dup: Array<{ cnt: number }> = await mgr.query(
          `SELECT COUNT(*) AS "cnt" FROM IP_PRODUCT_ST_MASTER
            WHERE ITEM_CODE = :1 AND MACHINE_CODE = :2 AND TO_CHAR(DATESET,'YYYY-MM-DD') = :3 AND ORGANIZATION_ID = :4`,
          [dto.itemCode, dto.machineCode, dto.validFrom, ORG],
        );
        if (Number(dup?.[0]?.cnt ?? 0) > 0) {
          throw new ConflictException(`이미 등록된 모델코드·설비코드·적용시작일입니다 (${dto.itemCode} / ${dto.machineCode} / ${dto.validFrom})`);
        }
      }
      if (isEdit) {
        await mgr.query(
          `DELETE FROM IP_PRODUCT_ST_MASTER
            WHERE ITEM_CODE = :1 AND MACHINE_CODE = :2 AND TO_CHAR(DATESET,'YYYY-MM-DD') = :3 AND ORGANIZATION_ID = :4`,
          [dto.originalItemCode, dto.originalMachineCode, dto.originalValidFrom, ORG],
        );
      }
      await mgr.query(
        `INSERT INTO IP_PRODUCT_ST_MASTER
           (ITEM_CODE, MACHINE_CODE, DATESET, ORGANIZATION_ID, DATEEND, ST_VALUE, CT_VALUE, NT_VALUE, TT_VALUE, REMARK, ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE)
         VALUES (:1, :2, TO_DATE(:3,'YYYY-MM-DD'), :4, TO_DATE(:5,'YYYY-MM-DD'), :6, :7, :8, :9, :10, :11, SYSDATE, :12, ${isEdit ? 'SYSDATE' : 'NULL'})`,
        [dto.itemCode, dto.machineCode, dto.validFrom, ORG, dto.validTo, dto.st ?? 0, dto.ct ?? 0, dto.nt ?? 0, dto.tt ?? 0, dto.remark ?? null, user, isEdit ? user : null],
      );
    });
  }

  async remove(itemCode: string, machineCode: string, validFrom: string): Promise<void> {
    await this.repo.manager.query(
      `DELETE FROM IP_PRODUCT_ST_MASTER
        WHERE ITEM_CODE = :1 AND MACHINE_CODE = :2 AND TO_CHAR(DATESET,'YYYY-MM-DD') = :3 AND ORGANIZATION_ID = :4`,
      [itemCode, machineCode, validFrom, ORG],
    );
  }
}
