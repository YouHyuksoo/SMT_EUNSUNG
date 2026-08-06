// 표준시간 관리 — IP_PRODUCT_ST_MASTER CRUD + ID_ITEM(모델) 조인 조회
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ProductStMaster } from '../../entities/product-st-master.entity';
import { StdTimeUpsertDto } from './standard-time.dto';

const ORG = 1; // 은성 단일 조직
const DEFAULT_USER = 'ADMIN';

export interface StdTimeRow {
  itemCode: string; modelName: string | null;
  validFrom: string; validTo: string;
  st: number | null; ct: number | null; nt: number | null; tt: number | null;
  remark: string | null; registeredBy: string | null; updatedBy: string | null; updatedAt: string | null;
}
export interface ItemRow { itemCode: string; itemName: string | null; itemSpec: string | null; }

@Injectable()
export class StandardTimeService {
  constructor(
    @InjectRepository(ProductStMaster)
    private readonly repo: Repository<ProductStMaster>,
  ) {}

  /** 표준시간 목록 (ID_ITEM 조인으로 모델명 표시) */
  list(): Promise<StdTimeRow[]> {
    return this.repo.manager.query(
      `SELECT s.ITEM_CODE AS "itemCode",
              i.ITEM_NAME AS "modelName",
              TO_CHAR(s.DATESET,'YYYY-MM-DD') AS "validFrom",
              TO_CHAR(s.DATEEND,'YYYY-MM-DD') AS "validTo",
              s.ST_VALUE AS "st", s.CT_VALUE AS "ct", s.NT_VALUE AS "nt", s.TT_VALUE AS "tt",
              s.REMARK AS "remark",
              s.ENTER_BY AS "registeredBy",
              NVL(s.LAST_MODIFY_BY, s.ENTER_BY) AS "updatedBy",
              TO_CHAR(NVL(s.LAST_MODIFY_DATE, s.ENTER_DATE),'YYYY-MM-DD HH24:MI') AS "updatedAt"
         FROM IP_PRODUCT_ST_MASTER s
         LEFT JOIN ID_ITEM i ON i.ITEM_CODE = s.ITEM_CODE AND i.ORGANIZATION_ID = s.ORGANIZATION_ID
        WHERE s.ORGANIZATION_ID = ${ORG}
        ORDER BY s.ITEM_CODE, s.DATESET`,
    );
  }

  /** 모델선택 팝업용 품목 목록 (ID_ITEM) */
  items(): Promise<ItemRow[]> {
    return this.repo.manager.query(
      `SELECT ITEM_CODE AS "itemCode", ITEM_NAME AS "itemName", ITEM_SPEC AS "itemSpec"
         FROM ID_ITEM WHERE ORGANIZATION_ID = ${ORG} ORDER BY ITEM_CODE`,
    );
  }

  /** 신규/수정 — 원본 키가 오면 삭제 후 삽입(모델/시작일 변경 대응). 날짜는 문자열 매칭. */
  async upsert(dto: StdTimeUpsertDto): Promise<void> {
    const m = this.repo.manager;
    const isEdit = !!dto.originalItemCode && !!dto.originalValidFrom;
    if (isEdit) {
      await m.query(
        `DELETE FROM IP_PRODUCT_ST_MASTER WHERE ITEM_CODE = :1 AND TO_CHAR(DATESET,'YYYY-MM-DD') = :2 AND ORGANIZATION_ID = :3`,
        [dto.originalItemCode, dto.originalValidFrom, ORG],
      );
    }
    const user = dto.userId ?? DEFAULT_USER;
    await m.query(
      `INSERT INTO IP_PRODUCT_ST_MASTER
         (ITEM_CODE, DATESET, ORGANIZATION_ID, DATEEND, ST_VALUE, CT_VALUE, NT_VALUE, TT_VALUE, REMARK, ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE)
       VALUES (:1, TO_DATE(:2,'YYYY-MM-DD'), :3, TO_DATE(:4,'YYYY-MM-DD'), :5, :6, :7, :8, :9, :10, SYSDATE, :11, ${isEdit ? 'SYSDATE' : 'NULL'})`,
      [dto.itemCode, dto.validFrom, ORG, dto.validTo, dto.st ?? 0, dto.ct ?? 0, dto.nt ?? 0, dto.tt ?? 0, dto.remark ?? null, user, isEdit ? user : null],
    );
  }

  async remove(itemCode: string, validFrom: string): Promise<void> {
    await this.repo.manager.query(
      `DELETE FROM IP_PRODUCT_ST_MASTER WHERE ITEM_CODE = :1 AND TO_CHAR(DATESET,'YYYY-MM-DD') = :2 AND ORGANIZATION_ID = :3`,
      [itemCode, validFrom, ORG],
    );
  }
}
