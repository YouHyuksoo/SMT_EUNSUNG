// 제품 모델 마스터 조회 — 모델 선택 팝업 공용 (IP_PRODUCT_MODEL_MASTER)
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ProductModelMaster } from '../../entities/product-model-master.entity';

const ORG = 1;

export interface ModelRow {
  partNo: string;
  modelName: string | null;
  modelSpec: string | null;
  customerName: string | null;
  /** 품목코드 — 생산계획 등록에서 품목코드로 모델을 고를 때 쓴다 */
  itemCode: string | null;
  masterModelName: string | null;
  modelSuffix: string | null;
}

@Injectable()
export class ProductModelService {
  constructor(
    @InjectRepository(ProductModelMaster)
    private readonly repo: Repository<ProductModelMaster>,
  ) {}

  /** 모델 목록 — 모델코드(PART_NO)·모델명·규격·고객명·품목코드·마스터모델명·서픽스 */
  list(): Promise<ModelRow[]> {
    return this.repo.manager.query(
      `SELECT PART_NO AS "partNo", MODEL_NAME AS "modelName",
              MODEL_SPEC AS "modelSpec", CUSTOMER_NAME AS "customerName",
              ITEM_CODE AS "itemCode", MASTER_MODEL_NAME AS "masterModelName",
              MODEL_SUFFIX AS "modelSuffix"
         FROM IP_PRODUCT_MODEL_MASTER
        WHERE ORGANIZATION_ID = ${ORG}
        ORDER BY PART_NO`,
    );
  }
}
