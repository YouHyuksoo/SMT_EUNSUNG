/**
 * @file src/modules/product-model/bom-explode.service.ts
 * @description 제품 모델 마스터의 BOM 전개 방식 — 조회 · 사람이 정하기 · 자동 분류
 *
 * 초보자 가이드:
 * 1. 저장 칼럼 (IP_PRODUCT_MODEL_MASTER): BOM_EXPLODE_TYPE, TOP_ITEM_CODE(T면 생산 품목),
 *    BOTTOM_ITEM_CODE(B면 생산 품목), INSERT_ITEM_CODE(SUB 공정 품목 = SUB-Assy),
 *    BOM_EXPLODE_SOURCE(A 자동 / M 사람), BOM_EXPLODE_NOTE.
 *    마이그레이션: src/migrations/2026-10-17_model_master_bom_explode.sql
 * 2. 자동 분류는 사람이 정한 행(M)을 덮어쓰지 않는다.
 * 2-1. 모델 키는 MODEL_NAME 이다 (PK = MODEL_NAME + ORGANIZATION_ID). 고객사품번(PART_NO)은
 *      여러 모델이 같은 값을 쓴다 (2026-10-17 실측 12개 품번).
 * 3. 분류 규칙은 bom-explode.classify.ts 한 곳에 있다.
 * 4. 전체 BOM(약 1만 행)과 품목명은 한 번에 5,000행씩 가져온다 (fetchAll). 기본 100행씩이면
 *    DB 왕복이 느린 곳(실측 1.9초)에서 BOM 만 53초가 걸려 화면 요청 시간을 넘긴다.
 */
import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import * as oracledb from 'oracledb';
import { DataSource } from 'typeorm';
import { clobBind } from '../../common/services/oracle.service';
import { namedBinds } from '../../common/utils/named-binds.util';
import { affectedRows } from '../../common/utils/affected-rows.util';
import { BomEdge, classifyBomExplode, sideOf } from './bom-explode.classify';
import { UpdateBomExplodeDto } from './bom-explode.dto';

/** 유효 BOM (오늘 기준) */
const ACTIVE_BOM = `NVL(b.DATESET, DATE '1900-01-01') <= TRUNC(SYSDATE)
  AND NVL(b.DATEEND, DATE '9999-12-31') >= TRUNC(SYSDATE)`;

@Injectable()
export class BomExplodeService {
  constructor(private readonly dataSource: DataSource) {}

  list(organizationId: number) {
    return this.dataSource.query(
      `SELECT m.PART_NO AS "partNo", m.MODEL_NAME AS "modelName", m.MODEL_SPEC AS "modelSpec",
              m.CUSTOMER_NAME AS "customerName", m.ITEM_CODE AS "itemCode", i.ITEM_NAME AS "itemName",
              m.BOM_EXPLODE_TYPE AS "bomExplodeType", m.BOM_EXPLODE_SOURCE AS "bomExplodeSource",
              m.BOM_EXPLODE_NOTE AS "bomExplodeNote",
              m.TOP_ITEM_CODE AS "topItemCode", t.ITEM_NAME AS "topItemName",
              m.BOTTOM_ITEM_CODE AS "bottomItemCode", bt.ITEM_NAME AS "bottomItemName",
              m.INSERT_ITEM_CODE AS "subItemCode", si.ITEM_NAME AS "subItemName"
         FROM IP_PRODUCT_MODEL_MASTER m
         LEFT JOIN ID_ITEM i ON i.ITEM_CODE = m.ITEM_CODE AND i.ORGANIZATION_ID = m.ORGANIZATION_ID
         LEFT JOIN ID_ITEM t ON t.ITEM_CODE = m.TOP_ITEM_CODE AND t.ORGANIZATION_ID = m.ORGANIZATION_ID
         LEFT JOIN ID_ITEM bt ON bt.ITEM_CODE = m.BOTTOM_ITEM_CODE AND bt.ORGANIZATION_ID = m.ORGANIZATION_ID
         LEFT JOIN ID_ITEM si ON si.ITEM_CODE = m.INSERT_ITEM_CODE AND si.ORGANIZATION_ID = m.ORGANIZATION_ID
        WHERE m.ORGANIZATION_ID = :organizationId
        ORDER BY m.MODEL_NAME`,
      namedBinds({ organizationId }),
    );
  }

  /** 편집 화면에서 고를 품목 — 제품 자신 + 그 BOM 의 반제품 (면 추정 포함) */
  async candidates(modelName: string, organizationId: number) {
    const itemCode = await this.itemCodeOf(modelName, organizationId);
    const rows = (await this.dataSource.query(
      `SELECT DISTINCT b.CHILD_ITEM_CODE AS "itemCode", i.ITEM_NAME AS "itemName", b.PCB_ITEM AS "pcbItem"
         FROM ID_ENG_BOM b
         LEFT JOIN ID_ITEM i ON i.ITEM_CODE = b.CHILD_ITEM_CODE AND i.ORGANIZATION_ID = b.ORGANIZATION_ID
        WHERE b.ITEM_CODE = :itemCode AND b.ORGANIZATION_ID = :organizationId
          AND b.CHILD_ITEM_CODE <> b.PARENT_ITEM_CODE AND ${ACTIVE_BOM}
          AND EXISTS (SELECT 1 FROM ID_ENG_BOM s
                       WHERE s.ITEM_CODE = b.ITEM_CODE AND s.PARENT_ITEM_CODE = b.CHILD_ITEM_CODE
                         AND s.ORGANIZATION_ID = b.ORGANIZATION_ID AND s.CHILD_ITEM_CODE <> s.PARENT_ITEM_CODE)
        ORDER BY b.CHILD_ITEM_CODE`,
      namedBinds({ itemCode, organizationId }),
    )) as { itemCode: string; itemName: string | null; pcbItem: string | null }[];
    const [self] = (await this.dataSource.query(
      `SELECT ITEM_NAME AS "itemName" FROM ID_ITEM WHERE ITEM_CODE = :itemCode AND ORGANIZATION_ID = :organizationId`,
      namedBinds({ itemCode, organizationId }),
    )) as { itemName: string | null }[];
    const semis = new Map<string, { itemCode: string; itemName: string | null; side: string; semi: boolean }>();
    for (const r of rows) {
      // BOM 맨 위 행(부모 '*')은 제품 자신을 자식으로 갖는다 — 제품은 맨 앞에 따로 넣는다
      if (r.itemCode !== itemCode && !semis.has(r.itemCode)) {
        semis.set(r.itemCode, { itemCode: r.itemCode, itemName: r.itemName, side: sideOf(r.itemCode, r.itemName, r.pcbItem), semi: true });
      }
    }
    return [{ itemCode, itemName: self?.itemName ?? null, side: '', semi: false }, ...semis.values()];
  }

  async update(dto: UpdateBomExplodeDto, organizationId: number, userId: string) {
    const modelName = dto.modelName;
    const top = dto.topItemCode?.trim() || null;
    const bottom = dto.bottomItemCode?.trim() || null;
    const sub = dto.subItemCode?.trim() || null;
    if (dto.bomExplodeType !== 'NONE' && !top && !bottom) {
      throw new BadRequestException('T면 또는 B면 생산 품목을 하나 이상 고르세요.');
    }
    const result = await this.dataSource.query(
      `UPDATE IP_PRODUCT_MODEL_MASTER
          SET BOM_EXPLODE_TYPE = :type, TOP_ITEM_CODE = :top, BOTTOM_ITEM_CODE = :bottom, INSERT_ITEM_CODE = :sub,
              BOM_EXPLODE_SOURCE = 'M', BOM_EXPLODE_NOTE = NULL,
              LAST_MODIFY_BY = :userId, LAST_MODIFY_DATE = SYSDATE
        WHERE MODEL_NAME = :modelName AND ORGANIZATION_ID = :organizationId`,
      namedBinds({ type: dto.bomExplodeType, top, bottom, sub, userId, modelName, organizationId }),
    );
    if (!affectedRows(result)) throw new NotFoundException(`모델(${modelName})을 찾을 수 없습니다.`);
    return { modelName };
  }

  /**
   * 자동 분류. 사람이 정한 행(M)은 건너뛴다.
   * @param modelNames 지정하면 그 모델만, 없으면 전체
   */
  async classify(organizationId: number, userId: string, modelNames?: string[]) {
    const models = ((await this.dataSource.query(
      `SELECT MODEL_NAME AS "modelName", ITEM_CODE AS "itemCode", BOM_EXPLODE_SOURCE AS "source"
         FROM IP_PRODUCT_MODEL_MASTER WHERE ORGANIZATION_ID = :organizationId`,
      namedBinds({ organizationId }),
    )) as { modelName: string; itemCode: string | null; source: string | null }[])
      .filter((m) => !modelNames?.length || modelNames.includes(m.modelName));
    const targets = models.filter((m) => m.source !== 'M' && m.itemCode);

    const edges = (await this.fetchAll<BomEdge & { top: string }>(
      `SELECT b.ITEM_CODE AS "top", b.PARENT_ITEM_CODE AS "parent", b.CHILD_ITEM_CODE AS "child", b.PCB_ITEM AS "pcbItem"
         FROM ID_ENG_BOM b
        WHERE b.ORGANIZATION_ID = :organizationId AND b.CHILD_ITEM_CODE <> b.PARENT_ITEM_CODE AND ${ACTIVE_BOM}`,
      { organizationId },
    )) as (BomEdge & { top: string })[];
    const byTop = new Map<string, BomEdge[]>();
    for (const e of edges) {
      const list = byTop.get(e.top) ?? [];
      list.push(e);
      byTop.set(e.top, list);
    }
    const names = new Map(((await this.fetchAll<{ c: string; n: string | null }>(
      `SELECT ITEM_CODE AS "c", ITEM_NAME AS "n" FROM ID_ITEM WHERE ORGANIZATION_ID = :organizationId`,
      { organizationId },
    )) as { c: string; n: string | null }[]).map((r) => [r.c, r.n]));
    // 최근 6개월 SMT 런카드 면 (면이 T/B 인 런만 — 조립 라인 런은 면이 비어 있다)
    const runSides = new Map(((await this.dataSource.query(
      `SELECT ITEM_CODE AS "c", LISTAGG(PCB_ITEM, '') WITHIN GROUP (ORDER BY PCB_ITEM) AS "s"
         FROM (SELECT DISTINCT ITEM_CODE, PCB_ITEM FROM IP_PRODUCT_RUN_CARD
                WHERE ORGANIZATION_ID = :organizationId AND PCB_ITEM IN ('T', 'B')
                  AND RUN_DATE >= ADD_MONTHS(TRUNC(SYSDATE), -6))
        GROUP BY ITEM_CODE`,
      namedBinds({ organizationId }),
    )) as { c: string; s: string | null }[]).map((r) => [r.c, r.s ?? '']));

    const counts: Record<string, number> = {};
    const results = targets.map((m) => {
      const r = classifyBomExplode(m.itemCode as string, byTop.get(m.itemCode as string) ?? [], names, runSides.get(m.itemCode as string) ?? '');
      counts[r.type] = (counts[r.type] ?? 0) + 1;
      return { p: m.modelName, ty: r.type, t: r.topItemCode, b: r.bottomItemCode, s: r.subItemCode, n: r.note?.slice(0, 200) ?? null };
    });
    // 한 문장으로 반영한다 — 모델마다 UPDATE 를 보내면 DB 왕복이 느릴 때 수 분이 걸린다.
    if (results.length > 0) {
      await this.dataSource.query(
        `MERGE INTO IP_PRODUCT_MODEL_MASTER m
         USING (SELECT * FROM JSON_TABLE(:json, '$[*]' COLUMNS (
                  P VARCHAR2(100) PATH '$.p', TY VARCHAR2(10) PATH '$.ty',
                  T VARCHAR2(30) PATH '$.t', B VARCHAR2(30) PATH '$.b', S VARCHAR2(30) PATH '$.s', N VARCHAR2(200) PATH '$.n'))) j
            ON (m.MODEL_NAME = j.P AND m.ORGANIZATION_ID = :organizationId)
          WHEN MATCHED THEN UPDATE
           SET m.BOM_EXPLODE_TYPE = j.TY, m.TOP_ITEM_CODE = j.T, m.BOTTOM_ITEM_CODE = j.B, m.INSERT_ITEM_CODE = j.S,
               m.BOM_EXPLODE_SOURCE = 'A', m.BOM_EXPLODE_NOTE = j.N,
               m.LAST_MODIFY_BY = :userId, m.LAST_MODIFY_DATE = SYSDATE
         WHERE NVL(m.BOM_EXPLODE_SOURCE, 'A') <> 'M'`,
        namedBinds({ json: clobBind(JSON.stringify(results)), organizationId, userId }),
      );
    }
    return {
      classified: targets.length,
      skippedManual: models.filter((m) => m.source === 'M').length,
      skippedNoItem: models.filter((m) => m.source !== 'M' && !m.itemCode).length,
      counts,
    };
  }

  /** 큰 조회 — 드라이버 연결로 한 번에 5,000행씩 가져온다 (파일 머리 4번) */
  private async fetchAll<T>(sql: string, binds: Record<string, unknown>): Promise<T[]> {
    const runner = this.dataSource.createQueryRunner();
    try {
      const conn = (await runner.connect()) as oracledb.Connection;
      const result = await conn.execute<T>(sql, binds as oracledb.BindParameters, {
        outFormat: oracledb.OUT_FORMAT_OBJECT, fetchArraySize: 5000, prefetchRows: 5000,
      });
      return result.rows ?? [];
    } finally {
      await runner.release();
    }
  }

  private async itemCodeOf(modelName: string, organizationId: number): Promise<string> {
    const [row] = (await this.dataSource.query(
      `SELECT ITEM_CODE AS "itemCode" FROM IP_PRODUCT_MODEL_MASTER WHERE MODEL_NAME = :modelName AND ORGANIZATION_ID = :organizationId`,
      namedBinds({ modelName, organizationId }),
    )) as { itemCode: string | null }[];
    if (!row) throw new NotFoundException(`모델(${modelName})을 찾을 수 없습니다.`);
    if (!row.itemCode) throw new BadRequestException(`모델(${modelName})에 품목코드가 없습니다.`);
    return row.itemCode;
  }
}
