/**
 * @file src/modules/product-model/bom-explode.service.ts
 * @description 제품 모델 마스터의 BOM 전개 방식 — 조회 · 사람이 정하기 · 자동 분류
 *
 * 초보자 가이드:
 * 1. 모델 마스터(IP_PRODUCT_MODEL_MASTER)에는 분류 기준만 둔다: BOM_EXPLODE_TYPE, INSERT_ITEM_CODE(SUB 공정 품목),
 *    BOM_EXPLODE_SOURCE(A 자동 / M 사람), BOM_EXPLODE_NOTE. 마이그레이션: src/migrations/2026-10-17_model_master_bom_explode.sql
 * 1-1. 면별 생산 품목은 BOM 이 정본이다 — 제품 BOM(ID_ENG_BOM)의 반제품 행 PCB_ITEM 에 T / B / '*'(양면) 를 쓴다.
 *    실적 프로시저(P_ASSY_RESULT_ADD)와 제품 입고 소비(P_WIP_ISSUE_CREATE)가 이 면 표시로 생산 품목을 찾는다.
 *    분류 RAW(원자재만)는 제품 자신이라 BOM 에 쓰지 않는다. 모델 마스터 TOP_ITEM_CODE / BOTTOM_ITEM_CODE 는 쓰지 않는다.
 *    말단 부품 행의 PCB_ITEM(부품 실장 면)은 건드리지 않는다 — 자식이 있는 반제품 행만 다룬다.
 * 2. 자동 분류는 사람이 정한 행(M)을 덮어쓰지 않는다.
 * 2-1. 모델 키는 MODEL_NAME 이다 (PK = MODEL_NAME + ORGANIZATION_ID). 고객사품번(PART_NO)은
 *      여러 모델이 같은 값을 쓴다 (2026-10-17 실측 12개 품번).
 * 3. 분류 규칙은 bom-explode.classify.ts 한 곳에 있다.
 * 4. 전체 BOM(약 1만 행)과 품목명은 한 번에 5,000행씩 가져온다 (OracleService.queryAll). 기본 100행씩이면
 *    DB 왕복이 느린 곳(실측 1.9초)에서 BOM 만 53초가 걸려 화면 요청 시간을 넘긴다.
 */
import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { clobBind, OracleService } from '../../common/services/oracle.service';
import { namedBinds } from '../../common/utils/named-binds.util';
import { affectedRows } from '../../common/utils/affected-rows.util';
import { BomEdge, classifyBomExplode, sideOf } from './bom-explode.classify';
import { UpdateBomExplodeDto } from './bom-explode.dto';

/** 제품(:item) BOM 의 반제품 행 — 부모 '*' 아닌, 자식이 있는 행 (말단 부품 면 표시는 다루지 않는다) */
const SEMI_ROW = (b: string, item: string) => `${b}.ITEM_CODE = ${item} AND ${b}.PARENT_ITEM_CODE <> '*'
  AND ${b}.CHILD_ITEM_CODE <> ${b}.PARENT_ITEM_CODE
  AND EXISTS (SELECT 1 FROM ID_ENG_BOM k WHERE k.ITEM_CODE = ${b}.ITEM_CODE AND k.PARENT_ITEM_CODE = ${b}.CHILD_ITEM_CODE
                                         AND k.ORGANIZATION_ID = ${b}.ORGANIZATION_ID AND k.CHILD_ITEM_CODE <> k.PARENT_ITEM_CODE)`;

/** 면(T/B)의 생산 품목 — 분류 RAW 면 제품 자신, 아니면 BOM 반제품 행 중 그 면 또는 '*' */
const SIDE_ITEM = (side: 'T' | 'B') => `CASE WHEN m.BOM_EXPLODE_TYPE = 'RAW' THEN m.ITEM_CODE ELSE
  (SELECT MAX(b.CHILD_ITEM_CODE) KEEP (DENSE_RANK FIRST ORDER BY CASE b.PCB_ITEM WHEN '${side}' THEN 0 ELSE 1 END)
     FROM ID_ENG_BOM b
    WHERE ${SEMI_ROW('b', 'm.ITEM_CODE')} AND b.ORGANIZATION_ID = m.ORGANIZATION_ID AND b.PCB_ITEM IN ('${side}', '*')
      AND ${ACTIVE_BOM}) END`;

/** 유효 BOM (오늘 기준) */
const ACTIVE_BOM = `NVL(b.DATESET, DATE '1900-01-01') <= TRUNC(SYSDATE)
  AND NVL(b.DATEEND, DATE '9999-12-31') >= TRUNC(SYSDATE)`;

@Injectable()
export class BomExplodeService {
  constructor(private readonly dataSource: DataSource, private readonly oracle: OracleService) {}

  /** 목록 — 면별 생산 품목은 BOM 면 표시에서 읽는다 (파일 머리 1-1) */
  list(organizationId: number) {
    return this.dataSource.query(
      `SELECT x.*, t.ITEM_NAME AS "topItemName", bt.ITEM_NAME AS "bottomItemName"
         FROM (SELECT m.PART_NO AS "partNo", m.MODEL_NAME AS "modelName", m.MODEL_SPEC AS "modelSpec",
                      m.CUSTOMER_NAME AS "customerName", m.ITEM_CODE AS "itemCode", i.ITEM_NAME AS "itemName",
                      m.BOM_EXPLODE_TYPE AS "bomExplodeType", m.BOM_EXPLODE_SOURCE AS "bomExplodeSource",
                      m.BOM_EXPLODE_NOTE AS "bomExplodeNote",
                      ${SIDE_ITEM('T')} AS "topItemCode",
                      ${SIDE_ITEM('B')} AS "bottomItemCode",
                      m.INSERT_ITEM_CODE AS "subItemCode", si.ITEM_NAME AS "subItemName",
                      m.ORGANIZATION_ID AS org
                 FROM IP_PRODUCT_MODEL_MASTER m
                 LEFT JOIN ID_ITEM i ON i.ITEM_CODE = m.ITEM_CODE AND i.ORGANIZATION_ID = m.ORGANIZATION_ID
                 LEFT JOIN ID_ITEM si ON si.ITEM_CODE = m.INSERT_ITEM_CODE AND si.ORGANIZATION_ID = m.ORGANIZATION_ID
                WHERE m.ORGANIZATION_ID = :organizationId) x
         LEFT JOIN ID_ITEM t ON t.ITEM_CODE = x."topItemCode" AND t.ORGANIZATION_ID = x.org
         LEFT JOIN ID_ITEM bt ON bt.ITEM_CODE = x."bottomItemCode" AND bt.ORGANIZATION_ID = x.org
        ORDER BY x."modelName"`,
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

  /** 사람이 정하기 — 분류 기준은 모델 마스터, 면별 생산 품목은 BOM 반제품 행 면 표시로 쓴다 */
  async update(dto: UpdateBomExplodeDto, organizationId: number, userId: string) {
    const modelName = dto.modelName;
    const top = dto.topItemCode?.trim() || null;
    const bottom = dto.bottomItemCode?.trim() || null;
    const sub = dto.subItemCode?.trim() || null;
    if (dto.bomExplodeType !== 'NONE' && dto.bomExplodeType !== 'RAW' && !top && !bottom) {
      throw new BadRequestException('T면 또는 B면 생산 품목을 하나 이상 고르세요.');
    }
    const itemCode = await this.itemCodeOf(modelName, organizationId);
    const sides = dto.bomExplodeType === 'RAW' || dto.bomExplodeType === 'NONE' ? [] : this.sideRows(itemCode, top, bottom);
    await this.dataSource.transaction(async (m) => {
      await m.query(
        `UPDATE IP_PRODUCT_MODEL_MASTER
            SET BOM_EXPLODE_TYPE = :type, INSERT_ITEM_CODE = :sub,
                BOM_EXPLODE_SOURCE = 'M', BOM_EXPLODE_NOTE = NULL,
                LAST_MODIFY_BY = :userId, LAST_MODIFY_DATE = SYSDATE
          WHERE MODEL_NAME = :modelName AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ type: dto.bomExplodeType, sub, userId, modelName, organizationId }),
      );
      await this.writeBomSides(m.query.bind(m), [itemCode], sides, organizationId, userId);
    });
    return { modelName };
  }

  /** (제품, 반제품, 면) — 두 면이 같은 품목이면 '*'(양면) */
  private sideRows(product: string, top: string | null, bottom: string | null) {
    if (top && top === bottom) return [{ p: product, c: top, s: '*' }];
    return [
      ...(top && top !== product ? [{ p: product, c: top, s: 'T' }] : []),
      ...(bottom && bottom !== product ? [{ p: product, c: bottom, s: 'B' }] : []),
    ];
  }

  /**
   * 제품들의 BOM 반제품 행 면 표시를 지우고 새로 쓴다 (말단 부품 행은 그대로).
   * 이 BOM 을 쓰는 다른 모델(같은 제품)에도 같이 적용된다 — 면 표시는 제품 BOM 에 하나다.
   */
  private async writeBomSides(
    query: (sql: string, params?: unknown[]) => Promise<unknown>,
    products: string[],
    sides: { p: string; c: string; s: string }[],
    organizationId: number,
    userId: string,
  ) {
    if (products.length === 0) return;
    await query(
      `UPDATE ID_ENG_BOM b SET b.PCB_ITEM = NULL, b.LAST_MODIFY_BY = :userId, b.LAST_MODIFY_DATE = SYSDATE
        WHERE b.ITEM_CODE IN (SELECT P FROM JSON_TABLE(:json, '$[*]' COLUMNS (P VARCHAR2(30) PATH '$')))
          AND b.ORGANIZATION_ID = :organizationId AND b.PCB_ITEM IN ('T', 'B', '*')
          AND ${SEMI_ROW('b', 'b.ITEM_CODE')}`,
      namedBinds({ userId, json: clobBind(JSON.stringify(products)), organizationId }) as unknown[],
    );
    if (sides.length === 0) return;
    await query(
      `MERGE INTO ID_ENG_BOM b
       USING (SELECT * FROM JSON_TABLE(:json, '$[*]' COLUMNS (
                P VARCHAR2(30) PATH '$.p', C VARCHAR2(30) PATH '$.c', S VARCHAR2(1) PATH '$.s'))) j
          ON (b.ITEM_CODE = j.P AND b.CHILD_ITEM_CODE = j.C AND b.PARENT_ITEM_CODE <> '*' AND b.ORGANIZATION_ID = :organizationId)
        WHEN MATCHED THEN UPDATE SET b.PCB_ITEM = j.S, b.LAST_MODIFY_BY = :userId, b.LAST_MODIFY_DATE = SYSDATE`,
      namedBinds({ json: clobBind(JSON.stringify(sides)), organizationId, userId }) as unknown[],
    );
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

    const edges = (await this.oracle.queryAll<BomEdge & { top: string }>(
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
    const names = new Map(((await this.oracle.queryAll<{ c: string; n: string | null }>(
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
      return { p: m.modelName, product: m.itemCode as string, ty: r.type, t: r.topItemCode, b: r.bottomItemCode, s: r.subItemCode, n: r.note?.slice(0, 200) ?? null };
    });
    // 면 표시는 제품 BOM 에 하나다 — 사람이 정한 모델(M)과 같은 제품이면 BOM 을 건드리지 않는다
    const manualProducts = new Set(models.filter((m) => m.source === 'M' && m.itemCode).map((m) => m.itemCode as string));
    const sideByKey = new Map<string, { p: string; c: string; s: string }>();
    const products = new Set<string>();
    for (const r of results) {
      if (!r.product || manualProducts.has(r.product)) continue;
      products.add(r.product);
      if (r.ty === 'RAW' || r.ty === 'NONE') continue;
      for (const x of this.sideRows(r.product, r.t, r.b)) sideByKey.set(`${x.p}|${x.c}`, x);
    }
    // 한 문장씩 반영한다 — 모델마다 UPDATE 를 보내면 DB 왕복이 느릴 때 수 분이 걸린다.
    if (results.length > 0) {
      await this.dataSource.transaction(async (m) => {
        await m.query(
          `MERGE INTO IP_PRODUCT_MODEL_MASTER m
           USING (SELECT * FROM JSON_TABLE(:json, '$[*]' COLUMNS (
                    P VARCHAR2(100) PATH '$.p', TY VARCHAR2(10) PATH '$.ty', S VARCHAR2(30) PATH '$.s', N VARCHAR2(200) PATH '$.n'))) j
              ON (m.MODEL_NAME = j.P AND m.ORGANIZATION_ID = :organizationId)
            WHEN MATCHED THEN UPDATE
             SET m.BOM_EXPLODE_TYPE = j.TY, m.INSERT_ITEM_CODE = j.S,
                 m.BOM_EXPLODE_SOURCE = 'A', m.BOM_EXPLODE_NOTE = j.N,
                 m.LAST_MODIFY_BY = :userId, m.LAST_MODIFY_DATE = SYSDATE
           WHERE NVL(m.BOM_EXPLODE_SOURCE, 'A') <> 'M'`,
          namedBinds({ json: clobBind(JSON.stringify(results)), organizationId, userId }),
        );
        await this.writeBomSides(m.query.bind(m), [...products], [...sideByKey.values()], organizationId, userId);
      });
    }
    return {
      classified: targets.length,
      skippedManual: models.filter((m) => m.source === 'M').length,
      skippedNoItem: models.filter((m) => m.source !== 'M' && !m.itemCode).length,
      counts,
    };
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
