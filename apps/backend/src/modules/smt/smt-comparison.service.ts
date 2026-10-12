/**
 * @file src/modules/smt/smt-comparison.service.ts
 * @description 피더레이아웃 비교 — PB w_smt_bom_comparison_master_rpt 이식
 *
 * 초보자 가이드:
 * 1. **무엇을 비교하나**: 같은 라인에서 여러 모델의 "부품이 물리는 자리"를 나란히 놓고
 *    다른 자리를 쓰는 부품을 찾는다. 모델을 바꿔 생산할 때 피더를 옮겨야 하는
 *    부품이 그것이다.
 * 2. **PB 는 모델을 `PARENT_ITEM_CODE || PCB_ITEM` 로 묶었다.** 같은 모델도
 *    앞면(T)·뒷면(B)이 다른 레이아웃이므로 면까지 붙여야 한 덩어리가 된다.
 * 3. **PB 의 두 모드(그룹기준 / 위치기준)는 같은 데이터다.** DataWindow 두 개가
 *    묶는 기준만 달랐다. 웹은 한 번 조회해 탭으로 보기만 바꾼다.
 * 4. **BOM 전개는 PKG_DESIGN.BOM_QUERY 를 그대로 부른다.** PB 도
 *    f_bom_query_prc → SQLCA.BOM_QUERY 로 같은 함수를 불렀다. 이 함수가
 *    ID_ENG_BOM_TEMP 에 세션번호로 행을 깔고 그 번호를 돌려준다.
 *    TypeScript 로 다시 전개하지 않는다 — BOM 전개 규칙이 갈리면 비교 자체가 틀린다.
 * 5. **전개가 끝나면 우리가 깐 세션 행을 지운다.** ID_ENG_BOM_TEMP 는 지금
 *    3,357,661행 / 세션 70,117개가 쌓여 있다 (2020년 것부터). PB 가 한 번도
 *    치우지 않은 결과다. 기존 행은 건드리지 않고, 웹이 만든 것만 되돌린다.
 * 6. **LG 비교 리포트(d_lg_bom_comparision_rpt2)는 옮기지 않았다.**
 *    원천 두 테이블(ID_ENG_BOM_EXCEL_LG_CPR1/2)이 둘 다 0행인 죽은 기능이다.
 */
import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { TransactionService } from '../../shared/transaction.service';
import { SmtBomExplodeQueryDto, SmtLocationCompareQueryDto } from './smt-comparison.dto';
import { namedBinds } from '../../common/utils/named-binds.util';

interface CompareRow {
  childItemCode: string;
  itemName: string | null;
  itemSpec: string | null;
  modelKey: string;
  locations: string;
  rowCount: number;
}

@Injectable()
export class SmtComparisonService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  /**
   * 위치 비교 — PB d_smt_bom_location_comparision_4_group_rpt / _4_location_rpt.
   *
   * 부품별로 각 모델이 쓰는 자리를 모아 한 줄로 만든다. 모델마다 자리 목록이
   * 다르면 `diff: true` 다. 어느 모델에 아예 없으면 그것도 차이다 —
   * 자리 목록이 빈 것과 같은 자리를 쓰는 것을 섞지 않는다.
   */
  async compareLocations(query: SmtLocationCompareQueryDto, organizationId: number) {
    const models = query.models;
    const pcbItem = query.pcbItem ? `${query.pcbItem}%` : '%';

    // 모델 목록은 개수가 가변이라 바인드 이름을 만들어 넣는다.
    // 값 자체를 SQL 에 이어붙이지 않는다 — 전부 바인드다.
    const modelBinds = models.map((_, i) => `:model${i}`).join(', ');
    const binds: Record<string, unknown> = { lineCode: query.lineCode, pcbItem, organizationId };
    models.forEach((m, i) => {
      binds[`model${i}`] = m;
    });

    const rows = (await this.dataSource.query(
      `SELECT b.CHILD_ITEM_CODE AS "childItemCode",
              MAX(i.ITEM_NAME) AS "itemName",
              MAX(i.ITEM_SPEC) AS "itemSpec",
              b.PARENT_ITEM_CODE || b.PCB_ITEM AS "modelKey",
              LISTAGG(b.LOCATION_CODE, ',') WITHIN GROUP (ORDER BY b.LOCATION_CODE)
                AS "locations",
              COUNT(*) AS "rowCount"
         FROM ID_ENG_BOM_SMT b
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = b.CHILD_ITEM_CODE
               AND i.ORGANIZATION_ID = b.ORGANIZATION_ID
        WHERE b.ORGANIZATION_ID = :organizationId
          AND b.LINE_CODE LIKE :lineCode
          AND b.PARENT_ITEM_CODE || b.PCB_ITEM IN (${modelBinds})
          AND NVL(b.PCB_ITEM, '*') LIKE :pcbItem
        GROUP BY b.CHILD_ITEM_CODE, b.PARENT_ITEM_CODE || b.PCB_ITEM
        ORDER BY b.CHILD_ITEM_CODE`,
      namedBinds(binds),
    )) as CompareRow[];

    // 부품별로 모델을 가로로 펼친다. 표시 형태는 프론트가 고르고, 차이 판정은 여기서 한다.
    const byItem = new Map<
      string,
      {
        childItemCode: string;
        itemName: string | null;
        itemSpec: string | null;
        byModel: Record<string, string>;
        diff: boolean;
        missingIn: string[];
      }
    >();
    for (const row of rows) {
      const entry = byItem.get(row.childItemCode) ?? {
        childItemCode: row.childItemCode,
        itemName: row.itemName,
        itemSpec: row.itemSpec,
        byModel: {},
        diff: false,
        missingIn: [],
      };
      entry.byModel[row.modelKey] = row.locations;
      entry.itemName = entry.itemName ?? row.itemName;
      entry.itemSpec = entry.itemSpec ?? row.itemSpec;
      byItem.set(row.childItemCode, entry);
    }

    const data = [...byItem.values()].map((entry) => {
      entry.missingIn = models.filter((m) => entry.byModel[m] === undefined);
      const present = models.map((m) => entry.byModel[m] ?? '');
      const first = present[0];
      entry.diff = present.some((value) => value !== first);
      return entry;
    });

    return {
      models,
      data,
      total: data.length,
      diffCount: data.filter((d) => d.diff).length,
    };
  }

  /**
   * BOM 전개 + 피더 위치 대조 — PB d_des_bom_query_4_comparision.
   *
   * PKG_DESIGN.BOM_QUERY 가 세션번호를 돌려주고 ID_ENG_BOM_TEMP 에 전개행을 깐다.
   * 읽고 나서 그 세션 행만 지운다 (위 가이드 5번).
   *
   * f_get_listagg_location 은 행마다 불린다. 세션 행이 수십 건 수준이라
   * (평균 48행) 그대로 두는 것이 PB 와 같고 값도 갈리지 않는다.
   */
  async explodeBom(query: SmtBomExplodeQueryDto, organizationId: number) {
    const pcbItem = query.pcbItem ? `${query.pcbItem}%` : '%';
    return this.tx.run(async (qr) => {
      const sessionRows = (await qr.query(
        `SELECT PKG_DESIGN.BOM_QUERY(:setItemCode, TRUNC(SYSDATE), :organizationId)
                  AS SESSION_ID
           FROM DUAL`,
        namedBinds({ setItemCode: query.setItemCode, organizationId }),
      )) as { SESSION_ID: number }[];
      const sessionId = Number(sessionRows?.[0]?.SESSION_ID ?? 0);
      if (sessionId <= 0) {
        // PB 도 0 이하면 전개 실패로 보고 멈췄다
        return { sessionId, data: [], total: 0 };
      }

      try {
        const data = (await qr.query(
          `SELECT t.PARENT_ITEM_CODE AS "parentItemCode",
                  t.CHILD_ITEM_CODE AS "childItemCode",
                  LPAD(t.BOM_LEVEL, t.BOM_LEVEL, '.') AS "bomLevelIndent",
                  t.BOM_LEVEL AS "bomLevel",
                  t.SORT_SEQUENCE AS "sortSequence", t.SORT_ORDER AS "sortOrder",
                  t.ITEM_UNIT_QTY AS "itemUnitQty",
                  t.MODEL_UNIT_QTY AS "modelUnitQty",
                  t.LOCATION_INFO AS "locationInfo",
                  t.LINE_TYPE AS "lineType",
                  a.ITEM_NAME AS "parentItemName", a.ITEM_SPEC AS "parentItemSpec",
                  a.ITEM_CLASS AS "itemClass",
                  b.ITEM_NAME AS "childItemName", b.ITEM_SPEC AS "childItemSpec",
                  b.ITEM_UOM AS "childItemUom",
                  f_get_listagg_location(:lineCode, :setItemCode,
                                         t.CHILD_ITEM_CODE, :pcbItem)
                    AS "feederLocations"
             FROM ID_ENG_BOM_TEMP t
             LEFT JOIN ID_ITEM a
                    ON a.ITEM_CODE = t.PARENT_ITEM_CODE
                   AND a.ORGANIZATION_ID = t.ORGANIZATION_ID
             LEFT JOIN ID_ITEM b
                    ON b.ITEM_CODE = t.CHILD_ITEM_CODE
                   AND b.ORGANIZATION_ID = t.ORGANIZATION_ID
            WHERE t.SESSION_ID = :sessionId
              AND t.ORGANIZATION_ID = :organizationId
            ORDER BY t.SORT_ORDER`,
          namedBinds({
              sessionId,
              organizationId,
              lineCode: query.lineCode,
              setItemCode: query.setItemCode,
              pcbItem,
            }),
        )) as Record<string, unknown>[];
        return { sessionId, data, total: data.length };
      } finally {
        // 우리가 깐 세션 행만 되돌린다. 남의 세션·옛 행은 손대지 않는다.
        await qr.query(
          `DELETE FROM ID_ENG_BOM_TEMP
            WHERE SESSION_ID = :sessionId AND ORGANIZATION_ID = :organizationId`,
          namedBinds({ sessionId, organizationId }),
        );
      }
    });
  }
}
