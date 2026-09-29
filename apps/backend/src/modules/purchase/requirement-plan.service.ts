/**
 * @file src/modules/purchase/requirement-plan.service.ts
 * @description 477 자재소요량관리 — PB w_mat_requirment_plan_master 이식 (쓰기)
 *
 * PB 는 커서를 PowerBuilder 로 끌어와 한 행씩 돌렸다. 웹에서 같은 짓을 하면
 * 계획 행 수만큼 왕복이 생긴다. 소요량 전개와 재고 배정은 **익명 PL/SQL 블록**
 * 안에서 커서를 돌린다 — 왕복 1회, 한 트랜잭션.
 *
 * PB 의 동작 중 버그로 보이지만 **그대로 둔 것** 두 가지는 각 자리에 적어 두었다.
 * 고치면 PB 화면과 값이 갈린다.
 */
import { Injectable, BadRequestException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { InjectDataSource } from '@nestjs/typeorm';
import { ROW_LIMIT } from '../../shared/row-limit';
import type {
  MasterPlanQueryDto,
  MasterPlanRowDto,
  MasterPlanDeleteDto,
  RequirementPlanQueryDto,
  RequirementRunDto,
} from './purchase.dto';

/** BOM 전개 결과 중 소요량으로 잡는 거래유형. PB 원본 그대로다. */
const REQUIREMENT_LINE_TYPES = ['G', 'D', 'N', 'S', 'M', 'F', 'B'];

interface Paged<T> {
  data: T[];
  total: number;
  truncated: boolean;
}

@Injectable()
export class RequirementPlanService {
  constructor(@InjectDataSource() private readonly dataSource: DataSource) {}

  // ─────────────────────────────── 조회

  /** dw_1 기준계획 목록. PB 는 구식 조인이라 품목 기준정보가 없으면 행이 사라졌다. */
  async findMasterPlan(
    query: MasterPlanQueryDto,
    organizationId: number,
  ): Promise<Paged<Record<string, unknown>>> {
    const rows = await this.dataSource.query(
      `SELECT * FROM (
         SELECT A.REQUIRMENT_PLAN_DATE  AS "requirementPlanDate",
                A.REQUIRMENT_PLAN_SEQ   AS "requirementPlanSeq",
                A.PLAN_DATE             AS "planDate",
                A.ITEM_CODE             AS "itemCode",
                I.ITEM_NAME             AS "itemName",
                I.ITEM_SPEC             AS "itemSpec",
                I.ITEM_UOM              AS "itemUom",
                A.ORDER_QTY             AS "orderQty",
                A.TOTAL_INVENTORY_QTY   AS "totalInventoryQty",
                A.INVENTORY_QTY         AS "inventoryQty",
                A.SAFETY_INVENTORY_QTY  AS "safetyInventoryQty",
                A.APPLY_YN              AS "applyYn",
                A.ENTER_BY              AS "enterBy",
                A.ENTER_DATE            AS "enterDate"
           FROM IM_ITEM_MASTER_PLAN_4_REQUIR A
           LEFT JOIN ID_ITEM I
             ON I.ITEM_CODE = A.ITEM_CODE
            AND I.ORGANIZATION_ID = A.ORGANIZATION_ID
          WHERE A.ORGANIZATION_ID = :organizationId
            AND TRUNC(A.REQUIRMENT_PLAN_DATE) = TRUNC(TO_DATE(:planDate, 'YYYY-MM-DD'))
          ORDER BY A.PLAN_DATE, A.ITEM_CODE
       ) WHERE ROWNUM <= :rowLimit`,
      {
        organizationId,
        planDate: query.requirementPlanDate,
        rowLimit: ROW_LIMIT + 1,
      } as unknown as unknown[],
    );
    return this.page(rows);
  }

  /** dw_2 소요량 목록. */
  async findRequirementPlan(
    query: RequirementPlanQueryDto,
    organizationId: number,
  ): Promise<Paged<Record<string, unknown>>> {
    const binds: Record<string, unknown> = {
      organizationId,
      planDate: query.requirementPlanDate,
      rowLimit: ROW_LIMIT + 1,
    };
    // (:bind IS NULL OR col = :bind) 는 인덱스를 못 쓴다. 조건 자체를 뺀다.
    let filter = '';
    if (query.supplierCode) {
      filter += ' AND A.SUPPLIER_CODE = :supplierCode';
      binds.supplierCode = query.supplierCode;
    }
    if (query.itemCode) {
      filter += ' AND A.ITEM_CODE LIKE :itemCode';
      binds.itemCode = `%${query.itemCode}%`;
    }
    if (query.lineType) {
      filter += ' AND A.LINE_TYPE = :lineType';
      binds.lineType = query.lineType;
    }

    const rows = await this.dataSource.query(
      `SELECT * FROM (
         SELECT A.REQUIRMENT_PLAN_DATE AS "requirementPlanDate",
                A.PLAN_DATE            AS "planDate",
                A.ITEM_CODE            AS "itemCode",
                I.ITEM_NAME            AS "itemName",
                I.ITEM_SPEC            AS "itemSpec",
                I.ITEM_UOM             AS "itemUom",
                A.LINE_TYPE            AS "lineType",
                A.SUPPLIER_CODE        AS "supplierCode",
                S.SUPPLIER_NAME        AS "supplierName",
                A.REQUIRMENT_QTY       AS "requirementQty",
                A.SET_ITEM_CODE        AS "setItemCode",
                A.PARENT_ITEM_CODE     AS "parentItemCode",
                A.ENTER_BY             AS "enterBy",
                A.ENTER_DATE           AS "enterDate"
           FROM IM_ITEM_REQUIRMENT_PLAN A
           LEFT JOIN ID_ITEM I
             ON I.ITEM_CODE = A.ITEM_CODE
            AND I.ORGANIZATION_ID = A.ORGANIZATION_ID
           LEFT JOIN ICOM_SUPPLIER S
             ON S.SUPPLIER_CODE = A.SUPPLIER_CODE
            AND S.ORGANIZATION_ID = A.ORGANIZATION_ID
          WHERE A.ORGANIZATION_ID = :organizationId
            AND TRUNC(A.REQUIRMENT_PLAN_DATE) = TRUNC(TO_DATE(:planDate, 'YYYY-MM-DD'))
            ${filter}
          ORDER BY A.PLAN_DATE, A.ITEM_CODE
       ) WHERE ROWNUM <= :rowLimit`,
      binds as unknown as unknown[],
    );
    return this.page(rows);
  }

  /**
   * dw_3 소요량 매트릭스. 계획일을 가로로 편다.
   * 날짜 수가 들쭉날쭉이라 SQL 로 피벗하지 않고 (일자, 값) 쌍으로 내보낸다 —
   * 화면이 열을 만든다. PB 는 DataWindow 가 대신해 주던 일이다.
   */
  async findRequirementMatrix(
    query: RequirementPlanQueryDto,
    organizationId: number,
  ): Promise<{
    data: Record<string, unknown>[];
    planDates: string[];
    total: number;
    truncated: boolean;
  }> {
    const result = await this.findRequirementPlan(query, organizationId);
    const dates = new Set<string>();
    const byItem = new Map<string, Record<string, unknown>>();

    for (const row of result.data) {
      const planDate = this.dateKey(row.planDate);
      if (planDate) dates.add(planDate);
      const key = `${String(row.itemCode ?? '')}|${String(row.supplierCode ?? '')}`;
      let bucket = byItem.get(key);
      if (!bucket) {
        bucket = {
          itemCode: row.itemCode,
          itemName: row.itemName,
          itemSpec: row.itemSpec,
          itemUom: row.itemUom,
          lineType: row.lineType,
          supplierCode: row.supplierCode,
          supplierName: row.supplierName,
          totalQty: 0,
          qtyByDate: {} as Record<string, number>,
        };
        byItem.set(key, bucket);
      }
      const qty = Number(row.requirementQty ?? 0);
      bucket.totalQty = Number(bucket.totalQty) + qty;
      if (planDate) {
        const map = bucket.qtyByDate as Record<string, number>;
        map[planDate] = (map[planDate] ?? 0) + qty;
      }
    }

    return {
      data: [...byItem.values()],
      planDates: [...dates].sort(),
      total: byItem.size,
      truncated: result.truncated,
    };
  }

  // ─────────────────────────────── 기준계획 쓰기 (dw_1)

  /** 기준계획 한 줄 등록·수정. 키는 (소요일자, 계획일, 품목, 조직). */
  async saveMasterPlan(
    dto: MasterPlanRowDto,
    organizationId: number,
    userId: string,
  ): Promise<{ updated: boolean }> {
    const orderQty = Number(dto.orderQty);
    if (!Number.isFinite(orderQty) || orderQty < 0) {
      throw new BadRequestException('주문수량은 0 이상이어야 합니다.');
    }

    return this.dataSource.transaction(async (manager) => {
      const updated = await manager.query(
        `UPDATE IM_ITEM_MASTER_PLAN_4_REQUIR
            SET ORDER_QTY = :orderQty,
                APPLY_YN = NVL(:applyYn, APPLY_YN),
                LAST_MODIFY_BY = :userId,
                LAST_MODIFY_DATE = SYSDATE
          WHERE ORGANIZATION_ID = :organizationId
            AND TRUNC(REQUIRMENT_PLAN_DATE) = TRUNC(TO_DATE(:requirementPlanDate, 'YYYY-MM-DD'))
            AND TRUNC(PLAN_DATE) = TRUNC(TO_DATE(:planDate, 'YYYY-MM-DD'))
            AND ITEM_CODE = :itemCode`,
        {
          orderQty,
          applyYn: dto.applyYn ?? null,
          userId,
          organizationId,
          requirementPlanDate: dto.requirementPlanDate,
          planDate: dto.planDate,
          itemCode: dto.itemCode,
        } as unknown as unknown[],
      );
      const affected = Number(
        (updated as { rowsAffected?: number })?.rowsAffected ?? 0,
      );
      if (affected > 0) return { updated: true };

      await manager.query(
        `INSERT INTO IM_ITEM_MASTER_PLAN_4_REQUIR
           (REQUIRMENT_PLAN_DATE, REQUIRMENT_PLAN_SEQ, PLAN_DATE, ORGANIZATION_ID,
            ORDER_QTY, ITEM_CODE, APPLY_YN, TOTAL_INVENTORY_QTY, INVENTORY_QTY,
            SAFETY_INVENTORY_QTY, ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE)
         VALUES
           (TRUNC(TO_DATE(:requirementPlanDate, 'YYYY-MM-DD')),
            SEQ_REQUIRMENT_PLAN_SEQ.NEXTVAL,
            TRUNC(TO_DATE(:planDate, 'YYYY-MM-DD')),
            :organizationId, :orderQty, :itemCode, NVL(:applyYn, 'Y'),
            0, 0, 0, :userId, SYSDATE, :userId, SYSDATE)`,
        {
          requirementPlanDate: dto.requirementPlanDate,
          planDate: dto.planDate,
          organizationId,
          orderQty,
          itemCode: dto.itemCode,
          applyYn: dto.applyYn ?? null,
          userId,
        } as unknown as unknown[],
      );
      return { updated: false };
    });
  }

  /** 기준계획 삭제. PB 는 체크한 줄을 모아 dw.update() 로 한 번에 지웠다. */
  async deleteMasterPlan(
    dto: MasterPlanDeleteDto,
    organizationId: number,
  ): Promise<{ deleted: number }> {
    if (dto.rows.length === 0) return { deleted: 0 };
    return this.dataSource.transaction(async (manager) => {
      let deleted = 0;
      for (const row of dto.rows) {
        const result = await manager.query(
          `DELETE FROM IM_ITEM_MASTER_PLAN_4_REQUIR
            WHERE ORGANIZATION_ID = :organizationId
              AND TRUNC(REQUIRMENT_PLAN_DATE) = TRUNC(TO_DATE(:requirementPlanDate, 'YYYY-MM-DD'))
              AND TRUNC(PLAN_DATE) = TRUNC(TO_DATE(:planDate, 'YYYY-MM-DD'))
              AND ITEM_CODE = :itemCode`,
          {
            organizationId,
            requirementPlanDate: row.requirementPlanDate,
            planDate: row.planDate,
            itemCode: row.itemCode,
          } as unknown as unknown[],
        );
        deleted += Number((result as { rowsAffected?: number })?.rowsAffected ?? 0);
      }
      return { deleted };
    });
  }

  // ─────────────────────────────── 소요량 전개 (cb_1)

  /**
   * 기준계획을 BOM 전개해 소요량을 만든다.
   *
   * PB 순서 그대로다:
   *   1. 기준계획을 품목·계획일로 합쳐 _S 에 담는다 (수량은 SUM, 재고는 AVG)
   *   2. 기준계획을 지우고 _S 에서 새 일련번호로 다시 넣는다
   *   3. 계획 한 줄씩 `PKG_DESIGN.BOM_EXPLOSION` 을 돌려 자재로 펴서 TEMP 에 쌓는다
   *   4. 소요량표를 갈아끼운다 (공급처는 `F_GET_MAX_SUPPLIER_BY_ITEM`)
   */
  async explode(
    dto: RequirementRunDto,
    organizationId: number,
    userId: string,
  ): Promise<{ planRows: number; requirementRows: number }> {
    const [{ CNT: planRows }] = await this.dataSource.query(
      `SELECT COUNT(*) AS CNT
         FROM IM_ITEM_MASTER_PLAN_4_REQUIR
        WHERE ORGANIZATION_ID = :organizationId
          AND TRUNC(REQUIRMENT_PLAN_DATE) = TRUNC(TO_DATE(:planDate, 'YYYY-MM-DD'))`,
      { organizationId, planDate: dto.requirementPlanDate } as unknown as unknown[],
    );
    if (Number(planRows) === 0) {
      throw new BadRequestException('그 일자에 기준계획이 없습니다.');
    }

    return this.dataSource.transaction(async (manager) => {
      await manager.query(
        `DECLARE
           v_date        DATE := TRUNC(TO_DATE(:planDate, 'YYYY-MM-DD'));
           v_req_session NUMBER;
           v_bom_session NUMBER;
         BEGIN
           v_req_session := SEQ_REQUIRMENT_PLAN.NEXTVAL;

           -- 1. 품목·계획일로 합친다. 수량은 더하고 재고는 평균 — PB 원본 그대로.
           INSERT INTO IM_ITEM_MASTER_PLAN_4_REQUIR_S
             (REQUIRMENT_PLAN_DATE, PLAN_DATE, ORGANIZATION_ID, ORDER_QTY,
              TOTAL_INVENTORY_QTY, INVENTORY_QTY, SAFETY_INVENTORY_QTY, ITEM_CODE,
              APPLY_YN, ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE, SESSION_ID)
           SELECT REQUIRMENT_PLAN_DATE, PLAN_DATE, ORGANIZATION_ID, SUM(ORDER_QTY),
                  AVG(TOTAL_INVENTORY_QTY), AVG(INVENTORY_QTY), AVG(SAFETY_INVENTORY_QTY),
                  ITEM_CODE, MAX(APPLY_YN), MAX(ENTER_BY), MAX(ENTER_DATE),
                  MAX(LAST_MODIFY_BY), MAX(LAST_MODIFY_DATE), v_req_session
             FROM IM_ITEM_MASTER_PLAN_4_REQUIR
            WHERE TRUNC(REQUIRMENT_PLAN_DATE) = v_date
              AND ORGANIZATION_ID = :organizationId
            GROUP BY REQUIRMENT_PLAN_DATE, ITEM_CODE, PLAN_DATE, ORGANIZATION_ID;

           -- 2. PB 는 여기서 '=' 가 아니라 '<=' 로 지운다. 지난 일자의 기준계획까지
           --    같이 사라진다. 버그로 보이지만 고치면 PB 화면과 값이 갈리므로 둔다.
           DELETE FROM IM_ITEM_MASTER_PLAN_4_REQUIR
            WHERE TRUNC(REQUIRMENT_PLAN_DATE) <= v_date
              AND ORGANIZATION_ID = :organizationId;

           INSERT INTO IM_ITEM_MASTER_PLAN_4_REQUIR
             (REQUIRMENT_PLAN_DATE, REQUIRMENT_PLAN_SEQ, PLAN_DATE, ORGANIZATION_ID,
              ORDER_QTY, TOTAL_INVENTORY_QTY, INVENTORY_QTY, SAFETY_INVENTORY_QTY,
              ITEM_CODE, APPLY_YN, ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE)
           SELECT REQUIRMENT_PLAN_DATE, SEQ_REQUIRMENT_PLAN_SEQ.NEXTVAL, PLAN_DATE,
                  ORGANIZATION_ID, ORDER_QTY, TOTAL_INVENTORY_QTY, INVENTORY_QTY,
                  SAFETY_INVENTORY_QTY, ITEM_CODE, APPLY_YN, ENTER_BY, ENTER_DATE,
                  LAST_MODIFY_BY, LAST_MODIFY_DATE
             FROM IM_ITEM_MASTER_PLAN_4_REQUIR_S
            WHERE SESSION_ID = v_req_session
              AND ORGANIZATION_ID = :organizationId;

           DELETE FROM IM_ITEM_MASTER_PLAN_4_REQUIR_S
            WHERE SESSION_ID = v_req_session
              AND ORGANIZATION_ID = :organizationId;

           -- 3. 계획 한 줄씩 BOM 을 편다. 전개 결과는 ID_ENG_BOM_TEMP 에 세션번호로
           --    깔리므로, 읽은 뒤 그 세션 행만 지운다 (표가 계속 쌓이는 것을 막는다).
           FOR c IN (
             SELECT ITEM_CODE, PLAN_DATE, ORDER_QTY
               FROM IM_ITEM_MASTER_PLAN_4_REQUIR
              WHERE TRUNC(REQUIRMENT_PLAN_DATE) = v_date
                AND ORGANIZATION_ID = :organizationId
           ) LOOP
             v_bom_session := PKG_DESIGN.BOM_EXPLOSION(c.ITEM_CODE, c.PLAN_DATE, :organizationId);

             INSERT INTO IM_ITEM_REQUIRMENT_PLAN_TEMP
               (SESSION_ID, REQUIRMENT_PLAN_DATE, ITEM_CODE, LINE_TYPE, SUPPLIER_CODE,
                ORGANIZATION_ID, PLAN_DATE, REQUIRMENT_QTY, ENTER_BY, ENTER_DATE,
                LAST_MODIFY_BY, LAST_MODIFY_DATE)
             SELECT v_req_session, v_date, CHILD_ITEM_CODE, LINE_TYPE, '*',
                    ORGANIZATION_ID, c.PLAN_DATE, MODEL_UNIT_QTY * c.ORDER_QTY,
                    :userId, SYSDATE, :userId, SYSDATE
               FROM ID_ENG_BOM_TEMP
              WHERE SESSION_ID = v_bom_session
                AND LINE_TYPE IN (${REQUIREMENT_LINE_TYPES.map((t) => `'${t}'`).join(', ')});

             DELETE FROM ID_ENG_BOM_TEMP WHERE SESSION_ID = v_bom_session;
           END LOOP;

           -- 4. 소요량표를 그 일자만 갈아끼운다.
           DELETE FROM IM_ITEM_REQUIRMENT_PLAN
            WHERE TRUNC(REQUIRMENT_PLAN_DATE) = v_date
              AND ORGANIZATION_ID = :organizationId;

           INSERT INTO IM_ITEM_REQUIRMENT_PLAN
             (REQUIRMENT_PLAN_DATE, ITEM_CODE, LINE_TYPE, SUPPLIER_CODE, ORGANIZATION_ID,
              PLAN_DATE, REQUIRMENT_QTY, ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE)
           SELECT REQUIRMENT_PLAN_DATE, ITEM_CODE, LINE_TYPE,
                  F_GET_MAX_SUPPLIER_BY_ITEM(ITEM_CODE, ORGANIZATION_ID),
                  ORGANIZATION_ID, PLAN_DATE, SUM(REQUIRMENT_QTY),
                  MAX(ENTER_BY), MAX(ENTER_DATE), MAX(LAST_MODIFY_BY), MAX(LAST_MODIFY_DATE)
             FROM IM_ITEM_REQUIRMENT_PLAN_TEMP
            WHERE SESSION_ID = v_req_session
            GROUP BY REQUIRMENT_PLAN_DATE, ITEM_CODE, LINE_TYPE, SUPPLIER_CODE,
                     ORGANIZATION_ID, PLAN_DATE;

           DELETE FROM IM_ITEM_REQUIRMENT_PLAN_TEMP WHERE SESSION_ID = v_req_session;
         END;`,
        {
          planDate: dto.requirementPlanDate,
          organizationId,
          userId,
        } as unknown as unknown[],
      );

      // OUT 인자를 쓰면 서비스가 oracledb 드라이버를 직접 import 해야 한다.
      // 저장소 관례대로 만들어진 행을 같은 트랜잭션에서 세어 온다.
      const [{ CNT }] = await manager.query(
        `SELECT COUNT(*) AS CNT
           FROM IM_ITEM_REQUIRMENT_PLAN
          WHERE ORGANIZATION_ID = :organizationId
            AND TRUNC(REQUIRMENT_PLAN_DATE) = TRUNC(TO_DATE(:planDate, 'YYYY-MM-DD'))`,
        { organizationId, planDate: dto.requirementPlanDate } as unknown as unknown[],
      );
      return { planRows: Number(planRows), requirementRows: Number(CNT) };
    });
  }

  // ─────────────────────────────── 재고 반영 (cb_inventory_set)

  /**
   * 재고를 계획일 순서로 앞에서부터 배정한다.
   *
   * **PB 에서 실재고를 읽어오는 UPDATE 는 주석 처리돼 있다.** 그래서 재고 풀의
   * INVENTORY_QTY 는 늘 0 이고, 배정 루프는 매번 "재고 없음" 가지로 빠진다.
   * 안전재고만 `ID_ITEM.SAFETY_INVENTORY` 에서 채워진다. 고치면 PB 와 값이
   * 갈리므로 주석 그대로 둔다 — 실재고를 쓰려면 현장 합의가 먼저다.
   */
  async applyInventory(
    dto: RequirementRunDto,
    organizationId: number,
  ): Promise<{ planRows: number }> {
    return this.dataSource.transaction(async (manager) => {
      await manager.query(
        `DECLARE
           v_date   DATE := TRUNC(TO_DATE(:planDate, 'YYYY-MM-DD'));
           v_rows   NUMBER := 0;
           v_pool   NUMBER;
           v_rowid  ROWID;
           v_remain NUMBER;
         BEGIN
           UPDATE IM_ITEM_MASTER_PLAN_4_REQUIR
              SET TOTAL_INVENTORY_QTY = 0, INVENTORY_QTY = 0, SAFETY_INVENTORY_QTY = 0
            WHERE TRUNC(REQUIRMENT_PLAN_DATE) = v_date
              AND ORGANIZATION_ID = :organizationId;
           v_rows := SQL%ROWCOUNT;
           IF v_rows = 0 THEN
             RAISE_APPLICATION_ERROR(-20001, 'NO_PLAN');
           END IF;

           DELETE FROM IP_PRODUCT_INV_4_REQUIREMENT
            WHERE ORGANIZATION_ID = :organizationId;

           INSERT INTO IP_PRODUCT_INV_4_REQUIREMENT
             (ORGANIZATION_ID, ITEM_CODE, INVENTORY_QTY, SAFETY_INVENTORY_QTY)
           SELECT ORGANIZATION_ID, ITEM_CODE, 0, 0
             FROM IM_ITEM_MASTER_PLAN_4_REQUIR
            WHERE TRUNC(REQUIRMENT_PLAN_DATE) = v_date
              AND ORGANIZATION_ID = :organizationId
            GROUP BY ITEM_CODE, ORGANIZATION_ID;

           -- PB 는 여기서 실재고(IS_PRODUCT_INVENTORY)를 읽는 UPDATE 를 주석으로
           -- 막아 두었다. 그래서 INVENTORY_QTY 풀은 0 으로 남는다. 그대로 둔다.

           UPDATE IP_PRODUCT_INV_4_REQUIREMENT A
              SET A.SAFETY_INVENTORY_QTY =
                  (SELECT NVL(B.SAFETY_INVENTORY, 0) FROM ID_ITEM B
                    WHERE A.ITEM_CODE = B.ITEM_CODE
                      AND A.ORGANIZATION_ID = B.ORGANIZATION_ID)
            WHERE EXISTS (SELECT 'X' FROM ID_ITEM B
                           WHERE A.ITEM_CODE = B.ITEM_CODE
                             AND A.ORGANIZATION_ID = B.ORGANIZATION_ID);

           UPDATE IM_ITEM_MASTER_PLAN_4_REQUIR A
              SET A.TOTAL_INVENTORY_QTY =
                  (SELECT NVL(B.INVENTORY_QTY, 0) + NVL(B.SAFETY_INVENTORY_QTY, 0)
                     FROM IP_PRODUCT_INV_4_REQUIREMENT B
                    WHERE A.ITEM_CODE = B.ITEM_CODE
                      AND A.ORGANIZATION_ID = B.ORGANIZATION_ID)
            WHERE EXISTS (SELECT 'X' FROM IP_PRODUCT_INV_4_REQUIREMENT B
                           WHERE A.ITEM_CODE = B.ITEM_CODE
                             AND A.ORGANIZATION_ID = B.ORGANIZATION_ID);

           -- 계획일·품목 순서로 앞에서부터 재고를 떼어 준다. 순서가 결과를 바꾸므로
           -- 집합 연산으로 바꾸지 않고 PB 와 같은 커서 순회를 유지한다.
           FOR c IN (
             SELECT ITEM_CODE, ORDER_QTY, ROWID AS RID
               FROM IM_ITEM_MASTER_PLAN_4_REQUIR
              WHERE TRUNC(REQUIRMENT_PLAN_DATE) = v_date
                AND ORGANIZATION_ID = :organizationId
              ORDER BY PLAN_DATE, ITEM_CODE
           ) LOOP
             v_remain := c.ORDER_QTY;

             BEGIN
               SELECT INVENTORY_QTY, ROWID INTO v_pool, v_rowid
                 FROM IP_PRODUCT_INV_4_REQUIREMENT
                WHERE ITEM_CODE = c.ITEM_CODE
                  AND INVENTORY_QTY <> 0
                  AND ORGANIZATION_ID = :organizationId;

               IF v_remain <= v_pool THEN
                 UPDATE IM_ITEM_MASTER_PLAN_4_REQUIR SET INVENTORY_QTY = ORDER_QTY
                  WHERE ROWID = c.RID;
                 UPDATE IP_PRODUCT_INV_4_REQUIREMENT
                    SET INVENTORY_QTY = NVL(INVENTORY_QTY, 0) - NVL(v_remain, 0)
                  WHERE ROWID = v_rowid;
               ELSE
                 UPDATE IM_ITEM_MASTER_PLAN_4_REQUIR SET INVENTORY_QTY = NVL(v_pool, 0)
                  WHERE ROWID = c.RID;
                 UPDATE IP_PRODUCT_INV_4_REQUIREMENT SET INVENTORY_QTY = 0
                  WHERE ROWID = v_rowid;
               END IF;
             EXCEPTION
               WHEN NO_DATA_FOUND THEN
                 UPDATE IM_ITEM_MASTER_PLAN_4_REQUIR SET INVENTORY_QTY = 0
                  WHERE ROWID = c.RID;
             END;

             BEGIN
               SELECT SAFETY_INVENTORY_QTY, ROWID INTO v_pool, v_rowid
                 FROM IP_PRODUCT_INV_4_REQUIREMENT
                WHERE ITEM_CODE = c.ITEM_CODE
                  AND SAFETY_INVENTORY_QTY <> 0
                  AND ORGANIZATION_ID = :organizationId;

               IF v_remain <= v_pool THEN
                 UPDATE IM_ITEM_MASTER_PLAN_4_REQUIR SET SAFETY_INVENTORY_QTY = ORDER_QTY
                  WHERE ROWID = c.RID;
                 UPDATE IP_PRODUCT_INV_4_REQUIREMENT
                    SET SAFETY_INVENTORY_QTY = NVL(SAFETY_INVENTORY_QTY, 0) - NVL(v_remain, 0)
                  WHERE ROWID = v_rowid;
               ELSE
                 UPDATE IM_ITEM_MASTER_PLAN_4_REQUIR SET SAFETY_INVENTORY_QTY = NVL(v_pool, 0)
                  WHERE ROWID = c.RID;
                 UPDATE IP_PRODUCT_INV_4_REQUIREMENT SET SAFETY_INVENTORY_QTY = 0
                  WHERE ROWID = v_rowid;
               END IF;
             EXCEPTION
               WHEN NO_DATA_FOUND THEN
                 UPDATE IM_ITEM_MASTER_PLAN_4_REQUIR SET SAFETY_INVENTORY_QTY = 0
                  WHERE ROWID = c.RID;
             END;
           END LOOP;
         END;`,
        {
          planDate: dto.requirementPlanDate,
          organizationId,
        } as unknown as unknown[],
      )
      .catch((error: unknown) => {
        const message = error instanceof Error ? error.message : String(error);
        if (message.includes('NO_PLAN')) {
          throw new BadRequestException('그 일자에 기준계획이 없습니다.');
        }
        throw error;
      });

      const [{ CNT }] = await manager.query(
        `SELECT COUNT(*) AS CNT
           FROM IM_ITEM_MASTER_PLAN_4_REQUIR
          WHERE ORGANIZATION_ID = :organizationId
            AND TRUNC(REQUIRMENT_PLAN_DATE) = TRUNC(TO_DATE(:planDate, 'YYYY-MM-DD'))`,
        { organizationId, planDate: dto.requirementPlanDate } as unknown as unknown[],
      );
      return { planRows: Number(CNT) };
    });
  }

  // ─────────────────────────────── 보조

  private page<T>(rows: T[]): Paged<T> {
    const truncated = rows.length > ROW_LIMIT;
    const data = truncated ? rows.slice(0, ROW_LIMIT) : rows;
    return { data, total: data.length, truncated };
  }

  private dateKey(value: unknown): string | null {
    if (!value) return null;
    if (value instanceof Date) return value.toISOString().slice(0, 10);
    return String(value).slice(0, 10);
  }
}
