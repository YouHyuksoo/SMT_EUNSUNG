/**
 * @file src/modules/bom/services/mfs-bom.service.ts
 * @description 제조BOM관리 — PB w_des_mfs_bom_master 이식
 *
 * 화면 구성(PB 와 동일):
 * 1. 제품모델 목록 (IP_PRODUCT_MODEL_MASTER)
 * 2. 선택 모델 품목의 MFS 목록 (ID_MFS_BOM 을 품목+MFS 로 묶은 요약)
 * 3. 선택 MFS 의 상세 (ID_MFS_BOM)
 * 4. 선택 MFS 의 피더 레이아웃 (ID_ENG_BOM_SMT, REVISION = MFS)
 *
 * 처리(모두 한 트랜잭션, 감사컬럼 = 로그인 사용자):
 * - 생성: PKG_DESIGN.BOM_QUERY(_ALL) 로 설계BOM 을 ID_ENG_BOM_TEMP 에 전개한 뒤 ID_MFS_BOM 으로 옮긴다 (PB f_gen_mfs_bom).
 * - 삭제 / 복사(PB f_mfs_bom_copy) / 승인 / 승인취소 / 전체 사용·미사용.
 *
 * PB 와 의도적으로 다른 점:
 * - 승인(CONFIRM_YN='Y')된 MFS 는 생성(덮어쓰기)과 삭제를 막는다. PB 는 확인 없이 덮어썼다.
 * - 복사 대상 MFS 에 이미 행이 있으면 막는다. PB 는 같은 행을 한 벌 더 넣었다.
 * - 승인취소는 해당 MFS 전체 행을 되돌린다. PB 는 USED_YN='N' 행만 대상으로 해서 실제로는 아무 행도 바뀌지 않았다.
 * - PCB_ITEM(B/T) 갱신에 ORGANIZATION_ID 조건을 넣었다.
 * - ID_MFS_BOM.DATEEND 는 NOT NULL 인데 전개 결과(DATEEND)는 NULL 일 수 있어 9999-12-31 로 채운다.
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { outNumberBind } from '../../../common/services/oracle.service';
import { DataSource, QueryRunner } from 'typeorm';
import { TransactionService } from '../../../shared/transaction.service';
import {
  MfsCopyDto,
  MfsFeederQueryDto,
  MfsGenerateDto,
  MfsKeyDto,
  MfsListQueryDto,
  MfsModelQueryDto,
  MfsUsedDto,
} from '../dto/mfs-bom.dto';
import { namedBinds } from '../../../common/utils/named-binds.util';

type OracleRow = Record<string, unknown>;
type Binds = Record<string, unknown>;

/** 생성: 전개 결과(ID_ENG_BOM_TEMP) → ID_MFS_BOM. 컬럼 매핑은 PB f_gen_mfs_bom 과 같다. */
export const MFS_GENERATE_INSERT_SQL = `
  INSERT INTO ID_MFS_BOM (
    MFS, ITEM_CODE, PLAN_DATE, PARENT_ITEM_CODE, CHILD_ITEM_CODE, ORGANIZATION_ID,
    BOM_LEVEL, ITEM_TYPE, LINE_TYPE, MODEL_UNIT_QTY, MODEL_UNIT_QTY_EXT,
    ITEM_UNIT_QTY, ITEM_UNIT_QTY_EXT, SORT_ORDER, ASSY_EXP_YN, DATESET, DATEEND,
    ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE, USED_YN, CONFIRM_YN,
    PCB_ITEM, SORT_SEQUENCE, COMMENTS
  )
  SELECT :mfs, :itemCode, TRUNC(SYSDATE), t.PARENT_ITEM_CODE, t.CHILD_ITEM_CODE, t.ORGANIZATION_ID,
         t.BOM_LEVEL, t.ITEM_TYPE, t.LINE_TYPE, NVL(t.MODEL_UNIT_QTY, 0), NVL(t.MODEL_UNIT_QTY_EXT, 0),
         NVL(t.ITEM_UNIT_QTY, 0), NVL(t.ITEM_UNIT_QTY_EXT, 0), t.SORT_ORDER, :showHide,
         t.DATESET, NVL(t.DATEEND, DATE '9999-12-31'),
         NVL(t.ENTER_BY, :userId), NVL(t.ENTER_DATE, SYSDATE),
         NVL(t.LAST_MODIFY_BY, :userId), NVL(t.LAST_MODIFY_DATE, SYSDATE), 'Y', 'N',
         NULL, t.SORT_SEQUENCE, t.COMMENTS
    FROM ID_ENG_BOM_TEMP t
   WHERE t.SESSION_ID = :sid AND t.ORGANIZATION_ID = :org`;

/** 생성 후 PCB 면 표시: 상위품목의 ITEM_CLASS 가 B/T 인 행 (PB 와 같음, 조직 조건 추가) */
export const MFS_PCB_ITEM_UPDATE_SQL = `
  UPDATE ID_MFS_BOM SET PCB_ITEM = :pcbItem
   WHERE PARENT_ITEM_CODE IN (SELECT ITEM_CODE FROM ID_ITEM WHERE ITEM_CLASS = :pcbItem AND ORGANIZATION_ID = :org)
     AND ITEM_CODE = :itemCode AND MFS = :mfs AND ORGANIZATION_ID = :org`;

/** 복사: PB f_mfs_bom_copy 컬럼 + 상태/감사 컬럼 초기화 */
export const MFS_COPY_INSERT_SQL = `
  INSERT INTO ID_MFS_BOM (
    MFS, ITEM_CODE, PLAN_DATE, PARENT_ITEM_CODE, CHILD_ITEM_CODE, ORGANIZATION_ID,
    BOM_LEVEL, ITEM_TYPE, LINE_TYPE, MODEL_UNIT_QTY, MODEL_UNIT_QTY_EXT,
    ITEM_UNIT_QTY, ITEM_UNIT_QTY_EXT, SORT_ORDER, ASSY_EXP_YN, DATESET, DATEEND,
    ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE, USED_YN, CONFIRM_YN,
    PCB_ITEM, SORT_SEQUENCE, COMMENTS
  )
  SELECT :destMfs, ITEM_CODE, TRUNC(SYSDATE), PARENT_ITEM_CODE, CHILD_ITEM_CODE, ORGANIZATION_ID,
         BOM_LEVEL, ITEM_TYPE, LINE_TYPE, MODEL_UNIT_QTY, MODEL_UNIT_QTY_EXT,
         ITEM_UNIT_QTY, ITEM_UNIT_QTY_EXT, SORT_ORDER, ASSY_EXP_YN, DATESET, DATEEND,
         :userId, SYSDATE, :userId, SYSDATE, 'Y', 'N',
         PCB_ITEM, SORT_SEQUENCE, COMMENTS
    FROM ID_MFS_BOM
   WHERE MFS = :sourceMfs AND ITEM_CODE = :itemCode AND ORGANIZATION_ID = :org`;

/**
 * MFS 목록. PB 는 USED_YN 까지 GROUP BY 해서 한 MFS 가 여러 줄로 갈라졌다.
 * 여기서는 품목+MFS 로 먼저 묶어 행수·승인행수·사용행수를 센다.
 * (품목 하나에 모델이 여러 개인 경우가 있어 모델 테이블은 조인하지 않는다 — 모델 정보는 화면의 선택 모델을 쓴다.)
 */
export const MFS_LIST_SQL = `
  SELECT m.MFS AS "mfs",
         m.ITEM_CODE AS "itemCode",
         i.ITEM_NAME AS "itemName",
         i.ITEM_SPEC AS "itemSpec",
         i.ITEM_UOM AS "itemUom",
         m.ROW_COUNT AS "rowCount",
         m.CONFIRMED_COUNT AS "confirmedCount",
         m.USED_COUNT AS "usedCount",
         m.PLAN_DATE AS "planDate",
         m.CONFIRM_DATE AS "confirmDate",
         m.CONFIRM_BY AS "confirmBy",
         m.LAST_MODIFY_BY AS "lastModifyBy",
         m.LAST_MODIFY_DATE AS "lastModifyDate",
         m.COMMENTS AS "comments"
    FROM (SELECT MFS, ITEM_CODE, ORGANIZATION_ID,
                 COUNT(*) AS ROW_COUNT,
                 SUM(CASE WHEN CONFIRM_YN = 'Y' THEN 1 ELSE 0 END) AS CONFIRMED_COUNT,
                 SUM(CASE WHEN USED_YN = 'Y' THEN 1 ELSE 0 END) AS USED_COUNT,
                 MIN(PLAN_DATE) AS PLAN_DATE,
                 MAX(CONFIRM_DATE) AS CONFIRM_DATE,
                 MAX(CONFIRM_BY) AS CONFIRM_BY,
                 MAX(LAST_MODIFY_BY) KEEP (DENSE_RANK LAST ORDER BY LAST_MODIFY_DATE NULLS FIRST) AS LAST_MODIFY_BY,
                 MAX(LAST_MODIFY_DATE) AS LAST_MODIFY_DATE,
                 MAX(COMMENTS) AS COMMENTS
            FROM ID_MFS_BOM
           WHERE ITEM_CODE = :itemCode AND ORGANIZATION_ID = :org
           GROUP BY MFS, ITEM_CODE, ORGANIZATION_ID) m
    LEFT JOIN ID_ITEM i ON i.ITEM_CODE = m.ITEM_CODE AND i.ORGANIZATION_ID = m.ORGANIZATION_ID
   ORDER BY m.MFS`;

/** MFS 상세 (PB d_des_mfs_bom_lst) */
export const MFS_DETAIL_SQL = `
  SELECT b.MFS AS "mfs",
         b.ITEM_CODE AS "itemCode",
         b.PARENT_ITEM_CODE AS "parentItemCode",
         b.CHILD_ITEM_CODE AS "childItemCode",
         i.ITEM_NAME AS "childItemName",
         i.ITEM_SPEC AS "childItemSpec",
         i.ITEM_UOM AS "childItemUom",
         b.BOM_LEVEL AS "bomLevel",
         b.ITEM_TYPE AS "itemType",
         b.LINE_TYPE AS "lineType",
         b.MODEL_UNIT_QTY AS "modelUnitQty",
         b.ITEM_UNIT_QTY AS "itemUnitQty",
         b.SORT_ORDER AS "sortOrder",
         b.SORT_SEQUENCE AS "sortSequence",
         b.PCB_ITEM AS "pcbItem",
         b.CONFIRM_YN AS "confirmYn",
         b.USED_YN AS "usedYn",
         b.DATESET AS "dateset",
         b.DATEEND AS "dateend",
         b.ENTER_BY AS "enterBy",
         b.ENTER_DATE AS "enterDate",
         b.LAST_MODIFY_BY AS "lastModifyBy",
         b.LAST_MODIFY_DATE AS "lastModifyDate"
    FROM ID_MFS_BOM b
    LEFT JOIN ID_ITEM i ON i.ITEM_CODE = b.CHILD_ITEM_CODE AND i.ORGANIZATION_ID = b.ORGANIZATION_ID
   WHERE b.ITEM_CODE = :itemCode AND b.MFS = :mfs AND b.ORGANIZATION_ID = :org
   ORDER BY b.SORT_ORDER, b.SORT_SEQUENCE, b.PARENT_ITEM_CODE`;

/** 피더 레이아웃 (PB d_des_mfs_feeder_layout 계열). 라인명은 IP_PRODUCT_LINE 에서 붙인다. */
export const MFS_FEEDER_SQL = `
  SELECT s.LINE_CODE AS "lineCode",
         l.LINE_NAME AS "lineName",
         s.PARENT_ITEM_CODE AS "parentItemCode",
         s.PCB_ITEM AS "pcbItem",
         s.REVISION AS "revision",
         s.FEEDER_SHAFT AS "feederShaft",
         s.FEEDER_SHAFT_STATUS AS "feederShaftStatus",
         COUNT(*) AS "partCount"
    FROM ID_ENG_BOM_SMT s
    LEFT JOIN IP_PRODUCT_LINE l ON l.LINE_CODE = s.LINE_CODE AND l.ORGANIZATION_ID = s.ORGANIZATION_ID
   WHERE s.PARENT_ITEM_CODE = :smtModelName AND s.REVISION LIKE :mfs AND s.ORGANIZATION_ID = :org
   GROUP BY s.LINE_CODE, l.LINE_NAME, s.PARENT_ITEM_CODE, s.PCB_ITEM, s.REVISION,
            s.FEEDER_SHAFT, s.FEEDER_SHAFT_STATUS
   ORDER BY s.LINE_CODE, s.PARENT_ITEM_CODE, s.PCB_ITEM, s.REVISION, s.FEEDER_SHAFT`;

@Injectable()
export class MfsBomService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  /** 제품모델 목록 (PB d_pln_product_model_master_lst) */
  async findModels(query: MfsModelQueryDto, org: number) {
    const rows = await this.select(
      `SELECT MODEL_NAME AS "modelName", MODEL_SPEC AS "modelSpec", MODEL_TYPE AS "modelType",
              PART_NO AS "partNo", CUSTOMER_CODE AS "customerCode", CUSTOMER_NAME AS "customerName",
              MODEL_DIVISION AS "modelDivision", REVISION AS "revision", MODEL_SUFFIX AS "modelSuffix",
              ITEM_CODE AS "itemCode", MASTER_MODEL_NAME AS "masterModelName",
              SMT_MODEL_NAME AS "smtModelName", CARRIER_SIZE AS "carrierSize"
         FROM IP_PRODUCT_MODEL_MASTER
        WHERE MODEL_NAME LIKE :modelName AND ITEM_CODE LIKE :itemCode AND ORGANIZATION_ID = :org
        ORDER BY CUSTOMER_CODE, MODEL_NAME`,
      { modelName: this.prefix(query.modelName), itemCode: this.prefix(query.itemCode), org },
    );
    return { data: rows, total: rows.length };
  }

  async findMfsList(query: MfsListQueryDto, org: number) {
    const rows = await this.select(MFS_LIST_SQL, { itemCode: query.itemCode, org });
    return { data: rows, total: rows.length };
  }

  async findDetail(query: MfsKeyDto, org: number) {
    const rows = await this.select(MFS_DETAIL_SQL, { itemCode: query.itemCode, mfs: query.mfs, org });
    return { data: rows, total: rows.length };
  }

  async findFeederLayout(query: MfsFeederQueryDto, org: number) {
    const rows = await this.select(MFS_FEEDER_SQL, { smtModelName: query.smtModelName, mfs: query.mfs, org });
    return { data: rows, total: rows.length };
  }

  /**
   * 생성 (PB f_gen_mfs_bom).
   * 전개 함수가 첫 번째 쓰기여야 한다 — 함수 예외 처리부에 ROLLBACK 이 있어 앞선 변경을 지울 수 있다.
   * 승인 여부 확인은 SELECT 라 그 앞에 둔다.
   */
  async generate(dto: MfsGenerateDto, org: number, userId: string) {
    const { itemCode, mfs } = dto;
    const showHide = dto.showHide ?? 'Y';
    return this.tx.run(async (qr) => {
      await this.assertNotConfirmed(qr, itemCode, mfs, org, '생성');

      const fn = showHide === 'Y' ? 'PKG_DESIGN.BOM_QUERY_ALL' : 'PKG_DESIGN.BOM_QUERY';
      const out = (await qr.query(
        `BEGIN :sid := ${fn}(:itemCode, SYSDATE, :org); END;`,
        namedBinds({ sid: outNumberBind(), itemCode, org }),
      )) as { sid?: number | null } | undefined;
      const sid = Number(out?.sid ?? 0);
      // 0: 품목 없음, -100: 유효한 설계BOM 없음
      if (!(sid > 0)) throw new BadRequestException(`유효한 설계BOM이 없습니다: ${itemCode}`);

      const key = { itemCode, mfs, org };
      await this.exec(qr, `DELETE FROM ID_MFS_BOM WHERE ITEM_CODE = :itemCode AND MFS = :mfs AND ORGANIZATION_ID = :org`, key);
      const inserted = await this.exec(qr, MFS_GENERATE_INSERT_SQL, { ...key, showHide, userId, sid });
      await this.exec(qr, MFS_PCB_ITEM_UPDATE_SQL, { ...key, pcbItem: 'B' });
      await this.exec(qr, MFS_PCB_ITEM_UPDATE_SQL, { ...key, pcbItem: 'T' });
      // ID_ENG_BOM_TEMP 는 일반 테이블이라 직접 지운다
      await this.exec(qr, `DELETE FROM ID_ENG_BOM_TEMP WHERE SESSION_ID = :sid`, { sid });

      if (inserted === 0) throw new BadRequestException(`유효한 설계BOM이 없습니다: ${itemCode}`);
      return { itemCode, mfs, inserted };
    });
  }

  /** 삭제 — 승인된 MFS 는 막는다 */
  async drop(dto: MfsKeyDto, org: number) {
    const { itemCode, mfs } = dto;
    return this.tx.run(async (qr) => {
      await this.assertNotConfirmed(qr, itemCode, mfs, org, '삭제');
      const deleted = await this.exec(
        qr,
        `DELETE FROM ID_MFS_BOM WHERE ITEM_CODE = :itemCode AND MFS = :mfs AND ORGANIZATION_ID = :org`,
        { itemCode, mfs, org },
      );
      if (deleted === 0) throw new BadRequestException(`${mfs} 제조BOM이 없습니다.`);
      return { itemCode, mfs, deleted };
    });
  }

  /** 복사 (PB f_mfs_bom_copy) — 원본 필수, 대상에 행이 있으면 막는다 */
  async copy(dto: MfsCopyDto, org: number, userId: string) {
    const { itemCode, sourceMfs, destMfs } = dto;
    if (sourceMfs === destMfs) throw new BadRequestException('원본과 같은 MFS 로는 복사할 수 없습니다.');
    return this.tx.run(async (qr) => {
      const sourceCount = await this.count(qr, itemCode, sourceMfs, org);
      if (sourceCount === 0) throw new BadRequestException(`${sourceMfs} 제조BOM이 없습니다.`);
      const destCount = await this.count(qr, itemCode, destMfs, org);
      if (destCount > 0) throw new BadRequestException(`${destMfs} 제조BOM이 이미 있습니다. 삭제 후 복사하세요.`);

      const inserted = await this.exec(qr, MFS_COPY_INSERT_SQL, { itemCode, sourceMfs, destMfs, org, userId });
      return { itemCode, sourceMfs, destMfs, inserted };
    });
  }

  /** 승인 — 해당 MFS 전체 행 */
  async confirm(dto: MfsKeyDto, org: number, userId: string) {
    const updated = await this.tx.run((qr) => this.exec(
      qr,
      `UPDATE ID_MFS_BOM
          SET CONFIRM_YN = 'Y', CONFIRM_DATE = SYSDATE, CONFIRM_BY = :userId,
              LAST_MODIFY_BY = :userId, LAST_MODIFY_DATE = SYSDATE
        WHERE ITEM_CODE = :itemCode AND MFS = :mfs AND ORGANIZATION_ID = :org`,
      { itemCode: dto.itemCode, mfs: dto.mfs, org, userId },
    ));
    if (updated === 0) throw new BadRequestException(`${dto.mfs} 제조BOM이 없습니다.`);
    return { itemCode: dto.itemCode, mfs: dto.mfs, updated };
  }

  /**
   * 승인취소 — 해당 MFS 전체 행.
   * PB 는 `AND USED_YN = 'N'` 조건을 붙였는데, 생성·복사 시 USED_YN='Y' 로 들어가므로
   * 사실상 아무 행도 되돌리지 못했다. 여기서는 조건을 빼고 MFS 전체를 되돌린다.
   */
  async unconfirm(dto: MfsKeyDto, org: number, userId: string) {
    const updated = await this.tx.run((qr) => this.exec(
      qr,
      `UPDATE ID_MFS_BOM
          SET CONFIRM_YN = 'N', CONFIRM_DATE = NULL, CONFIRM_BY = NULL,
              LAST_MODIFY_BY = :userId, LAST_MODIFY_DATE = SYSDATE
        WHERE ITEM_CODE = :itemCode AND MFS = :mfs AND ORGANIZATION_ID = :org`,
      { itemCode: dto.itemCode, mfs: dto.mfs, org, userId },
    ));
    if (updated === 0) throw new BadRequestException(`${dto.mfs} 제조BOM이 없습니다.`);
    return { itemCode: dto.itemCode, mfs: dto.mfs, updated };
  }

  /** 전체 사용 / 전체 미사용 (PB 상세 그리드에서 USED_YN 만 저장하던 기능) */
  async setUsed(dto: MfsUsedDto, org: number, userId: string) {
    const updated = await this.tx.run((qr) => this.exec(
      qr,
      `UPDATE ID_MFS_BOM
          SET USED_YN = :usedYn, LAST_MODIFY_BY = :userId, LAST_MODIFY_DATE = SYSDATE
        WHERE ITEM_CODE = :itemCode AND MFS = :mfs AND ORGANIZATION_ID = :org`,
      { itemCode: dto.itemCode, mfs: dto.mfs, org, userId, usedYn: dto.usedYn },
    ));
    if (updated === 0) throw new BadRequestException(`${dto.mfs} 제조BOM이 없습니다.`);
    return { itemCode: dto.itemCode, mfs: dto.mfs, usedYn: dto.usedYn, updated };
  }

  private async assertNotConfirmed(qr: QueryRunner, itemCode: string, mfs: string, org: number, action: string) {
    const rows = (await qr.query(
      `SELECT COUNT(*) AS "cnt" FROM ID_MFS_BOM
        WHERE ITEM_CODE = :itemCode AND MFS = :mfs AND ORGANIZATION_ID = :org AND CONFIRM_YN = 'Y'`,
      namedBinds({ itemCode, mfs, org }),
    )) as OracleRow[];
    if (Number(rows[0]?.cnt ?? 0) > 0) {
      throw new BadRequestException(`${mfs} 제조BOM은 승인되어 ${action}할 수 없습니다. 승인취소 후 진행하세요.`);
    }
  }

  private async count(qr: QueryRunner, itemCode: string, mfs: string, org: number) {
    const rows = (await qr.query(
      `SELECT COUNT(*) AS "cnt" FROM ID_MFS_BOM WHERE ITEM_CODE = :itemCode AND MFS = :mfs AND ORGANIZATION_ID = :org`,
      namedBinds({ itemCode, mfs, org }),
    )) as OracleRow[];
    return Number(rows[0]?.cnt ?? 0);
  }

  /** DML 실행 후 영향 행수. 구조화 결과를 써야 0 행일 때도 숫자가 온다. */
  private async exec(qr: QueryRunner, sql: string, binds: Binds): Promise<number> {
    const result = await qr.query(sql, namedBinds(binds), true) as { affected?: number };
    return Number(result.affected ?? 0);
  }

  private async select(sql: string, binds: Binds) {
    return (await this.dataSource.query(sql, namedBinds(binds))) as OracleRow[];
  }

  private prefix(value?: string): string {
    return value ? `${value}%` : '%';
  }
}
