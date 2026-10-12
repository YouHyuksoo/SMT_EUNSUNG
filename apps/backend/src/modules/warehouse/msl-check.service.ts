/**
 * @file src/modules/warehouse/msl-check.service.ts
 * @description 260 MSL 이상품목 처리이력관리 — PB `w_mat_msl_item_check_master` 이식 (**쓰기**)
 *
 * 초보자 가이드:
 * 1. **MSL 시간을 넘긴 자재를 찾아 무엇을 했는지 남기는 화면이다.**
 *    MSL 은 습기에 민감한 부품이 공기에 노출된 누적 시간이고, 품목마다 허용 시간이
 *    있다 (`ID_ITEM.MSL_MAX_TIME` — 실측 등급 3 은 168시간, 2A 는 672, 2 는 8760).
 *    넘긴 자재는 베이킹해서 시계를 되돌리거나(261) 폐기해야 한다.
 * 2. **보는 곳이 세 군데다.**
 *      재고  — 창고에 있는데 MSL 이 넘은 릴 (`IM_ITEM_RECEIPT_BARCODE` + 재고)
 *      투입  — 이미 라인에 나간 릴의 MSL 경과 (`ISSUE_COMPARE_YN='Y'`)
 *      현황  — `IM_ITEM_MSL_CHECK_VIEW` 뷰 (실측 209행). 라인·모델·피더까지 붙는다.
 * 3. **처리이력은 아직 비어 있다.** `IM_ITEM_MSL_CHECK_MASTER` 가 **0행**이다 (실측).
 *    등록 경로는 옮겼지만 현장에서 쓰기 시작한 적이 없다는 뜻이다.
 * 4. **0 으로 나누기를 막아야 한다.** 경과율은 `경과시간 / MSL_MAX_TIME × 100` 인데
 *    `MSL_MAX_TIME` 이 0 이거나 NULL 인 품목이 많다 (실측 등급 없음 1,448건이 0).
 *    PB 도 `NVL(t.MSL_MAX_TIME,0) > 0` 을 걸어 막는다 — 빼면 ORA-01476 이 난다.
 * 5. **DB 함수 `F_GET_MSL_PASSED_TIME` 를 그대로 부른다.** 238·261 과 같은 함수라
 *    한 화면에서만 다시 계산하면 값이 갈린다.
 * 6. **쓰기는 실행하지 않고 parse 로만 검증했다** (사용자 결정).
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { likePrefix } from '@smt/shared';
import { limited, ROW_LIMIT } from '../../shared/row-limit';
import { TransactionService } from '../../shared/transaction.service';
import { MslCheckCreateDto, MslCheckQueryDto, MslOverQueryDto } from './warehouse.dto';
import { affectedRows } from '../../common/utils/affected-rows.util';
import { namedBinds } from '../../common/utils/named-binds.util';

type Row = Record<string, unknown>;

@Injectable()
export class MslCheckService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  /**
   * 재고에 있는데 MSL 이 넘은 릴 (PB `d_mat_item_msl_check_inventory_lst`).
   *
   * 아직 라인에 나가지 않았고(`ISSUE_COMPARE_YN='N'`) 재고가 남아 있는 릴 중
   * 경과율이 기준을 넘은 것만 본다. 경과율 계산의 0 나누기를 PB 와 같이 막는다.
   */
  async findInventoryOver(query: MslOverQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT b.ITEM_CODE                 AS "itemCode",
              t.ITEM_NAME                 AS "itemName",
              t.PART_NO                   AS "partNo",
              b.LOT_NO                    AS "lotNo",
              b.SUPPLIER_CODE             AS "supplierCode",
              b.ITEM_BARCODE              AS "itemBarcode",
              DECODE(b.NEW_SCAN_QTY, 0, b.SCAN_QTY, b.NEW_SCAN_QTY) AS "scanQty",
              v.INVENTORY_QTY             AS "inventoryQty",
              t.MSL_LEVEL                 AS "mslLevel",
              t.MSL_MAX_TIME              AS "mslMaxTime",
              TRUNC(NVL(b.MSL_PASSED_TIME, 0), 2)                  AS "prePassedTime",
              TRUNC(NVL(F_GET_MSL_PASSED_TIME(b.ITEM_BARCODE), 0), 2) AS "passedTime",
              TRUNC(NVL(F_GET_MSL_PASSED_TIME(b.ITEM_BARCODE), 0)
                    / t.MSL_MAX_TIME * 100, 2)                     AS "passedRate",
              t.MSL_MAX_TIME - TRUNC(NVL(F_GET_MSL_PASSED_TIME(b.ITEM_BARCODE), 0), 2)
                                          AS "remainHour",
              TO_CHAR(v.BAKING_DATE, 'YYYY-MM-DD HH24:MI:SS')      AS "bakingDate",
              v.LOCATION_ADDRESS_RACK     AS "locationRack",
              -- 마지막으로 베이킹에서 꺼낸 시각 (261 이 찍는다).
              ( SELECT MAX(m.OUTPUT_SCAN_DATE)
                  FROM IM_ITEM_BAKING_MASTER m
                 WHERE m.CHAMBER_TYPE = 'B'
                   AND m.ITEM_BARCODE = b.ITEM_BARCODE
                   AND m.OUTPUT_SCAN_DATE >= NVL(v.BAKING_DATE, SYSDATE) ) AS "bakingEndDate"
         FROM IM_ITEM_RECEIPT_BARCODE b
         LEFT JOIN IM_ITEM_INVENTORY v
                ON v.MATERIAL_MFS = b.LOT_NO
         LEFT JOIN ID_ITEM t
                ON t.ITEM_CODE = b.ITEM_CODE
        WHERE b.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND NVL(b.ISSUE_COMPARE_YN, 'N') = 'N'
          AND b.BARCODE_STATUS = 'N'
          AND t.MSL_LEVEL >= :mslLevel
          -- PB 와 같은 0 나누기 방어. 빼면 ORA-01476 이 난다 (허용시간 0 품목 1,448건).
          AND NVL(t.MSL_MAX_TIME, 0) > 0
          AND v.INVENTORY_QTY > 0
          AND TRUNC(NVL(F_GET_MSL_PASSED_TIME(b.ITEM_BARCODE), 0)
                    / t.MSL_MAX_TIME * 100, 2) >= :passedRate
          AND v.ORGANIZATION_ID = :organizationId
        ORDER BY TRUNC(NVL(F_GET_MSL_PASSED_TIME(b.ITEM_BARCODE), 0), 2) DESC
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        itemCode: likePrefix(query.itemCode),
        mslLevel: query.mslLevel ?? '2',
        passedRate: Number(query.passedRate ?? 100),
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }

  /**
   * 이미 라인에 나간 릴의 MSL 경과 (PB `d_mat_item_msl_check_returny_lst`).
   *
   * PB 의 인덱스 힌트(`INDXIM_ITEM_RECEIPT_BARCODE4`)는 옮기지 않았다 — 그 인덱스는
   * `ISSUE_COMPARE_DATE` 선두라 지금 조건(`ISSUE_COMPARE_YN='Y'` + 품목)과 맞지 않고,
   * 힌트를 그대로 옮기면 옵티마이저가 더 나은 계획을 못 고른다.
   */
  async findIssuedOver(query: MslOverQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT b.LOT_NO                    AS "lotNo",
              b.ITEM_BARCODE              AS "itemBarcode",
              b.SUPPLIER_CODE             AS "supplierCode",
              b.ITEM_CODE                 AS "itemCode",
              m.ITEM_NAME                 AS "itemName",
              m.PART_NO                   AS "partNo",
              b.NEW_SCAN_QTY              AS "newScanQty",
              b.SCAN_QTY                  AS "scanQty",
              TO_CHAR(b.ISSUE_COMPARE_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "issueCompareDate",
              TO_CHAR(b.FEEDING_DATE, 'YYYY-MM-DD HH24:MI:SS')       AS "feedingDate",
              b.FEEDING_MODEL             AS "feedingModel",
              TO_CHAR(b.MSL_OPEN_DATE, 'YYYY-MM-DD HH24:MI:SS')      AS "mslOpenDate",
              m.MSL_LEVEL                 AS "mslLevel",
              m.MSL_MAX_TIME              AS "mslMaxTime",
              TRUNC(NVL(F_GET_MSL_PASSED_TIME(b.ITEM_BARCODE), 0), 2) AS "passedTime",
              m.MSL_MAX_TIME - TRUNC(NVL(F_GET_MSL_PASSED_TIME(b.ITEM_BARCODE), 0), 2)
                                          AS "remainTime",
              TRUNC(NVL(F_GET_MSL_PASSED_TIME(b.ITEM_BARCODE), 0)
                    / m.MSL_MAX_TIME * 100, 2)                      AS "passedRate",
              TRUNC(ROUND(NVL(b.MSL_PASSED_TIME, 0)), 2)            AS "prePassedTime",
              ROUND((SYSDATE - NVL(b.MSL_OPEN_DATE, SYSDATE)) * 24, 0) AS "curPassedTime",
              F_GET_LINE_NAME(b.LINE_CODE, 1)          AS "lineName",
              F_GET_WORKSTAGE_NAME(b.WORKSTAGE_CODE)   AS "workstageName",
              -- 이 롯트가 라인에 처음 들어간 시각 (검사 이력에서 찾는다).
              ( SELECT MIN(h.CHECK_DATE)
                  FROM IB_SMT_CHECKHIST h
                 WHERE h.LOT_NO = b.LOT_NO
                   AND h.CHECK_TYPE IN ('1', '2')
                   AND h.CHECK_STATUS = 'P' ) AS "firstLineInputDate"
         FROM IM_ITEM_RECEIPT_BARCODE b
         JOIN ID_ITEM m
           ON m.ITEM_CODE = b.ITEM_CODE
          AND m.ORGANIZATION_ID = b.ORGANIZATION_ID
        WHERE b.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND b.ISSUE_COMPARE_YN = 'Y'
          AND m.MSL_LEVEL >= :mslLevel
          AND NVL(m.MSL_MAX_TIME, 0) > 0
          AND TRUNC(NVL(F_GET_MSL_PASSED_TIME(b.ITEM_BARCODE), 0)
                    / m.MSL_MAX_TIME * 100, 2) >= :passedRate
          AND b.ORGANIZATION_ID = :organizationId
        ORDER BY TRUNC(NVL(F_GET_MSL_PASSED_TIME(b.ITEM_BARCODE), 0), 2) DESC
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        itemCode: likePrefix(query.itemCode),
        mslLevel: query.mslLevel ?? '2',
        passedRate: Number(query.passedRate ?? 100),
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }

  /**
   * MSL 현황 뷰 (PB `d_mat_msl_item_check_view_lst`, `IM_ITEM_MSL_CHECK_VIEW`).
   *
   * 라인·모델·피더 위치까지 붙은 화면용 뷰다 (실측 209행). 뷰가 계산을 이미
   * 갖고 있으므로 자르기(`TRUNC`)만 PB 와 같이 얹는다.
   */
  async findCheckView(query: MslCheckQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT v.LINE_CODE                 AS "lineCode",
              v.PCB_ITEM                  AS "pcbItem",
              v.CCS_YN                    AS "ccsYn",
              v.MODEL_NAME                AS "modelName",
              v.LOCATION_CODE             AS "locationCode",
              v.ITEM_BARCODE              AS "itemBarcode",
              v.ITEM_CODE                 AS "itemCode",
              v.ITEM_NAME                 AS "itemName",
              v.ITEM_SPEC                 AS "itemSpec",
              v.PART_NO                   AS "partNo",
              v.LOT_NO                    AS "lotNo",
              v.SCAN_QTY                  AS "scanQty",
              v.NEW_SCAN_QTY              AS "newScanQty",
              v.ISSUE_COMPARE_YN          AS "issueCompareYn",
              TO_CHAR(v.ISSUE_COMPARE_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "issueCompareDate",
              TO_CHAR(v.CHANGE_DATE, 'YYYY-MM-DD HH24:MI:SS')        AS "changeDate",
              v.MSL_LEVEL                 AS "mslLevel",
              v.MSL_MAX_TIME              AS "mslMaxTime",
              TRUNC(v.PASSED_TIME, 2)     AS "passedHour",
              TRUNC(v.MSL_MAX_TIME - v.PASSED_TIME, 2)  AS "remainHour",
              TRUNC(v.MSL_PRE_PASSED_TIME, 2)           AS "prePassedTime",
              v.PASSED_RATE               AS "passedRate",
              -- PB 는 검사·베이킹 횟수 네 열을 더 붙이지만 이 뷰에 없다 (실측 컬럼
              -- 23개에 CHECK_COUNT·BAKING_COUNT·CHECK_MIN_TIME·CHECK_MAX_TIME 이
              -- 없다). 다른 원천에서 오던 값이라 빼 두었다.
              TO_CHAR(v.BAKING_START_DATE, 'YYYY-MM-DD HH24:MI:SS')  AS "bakingStartDate",
              TO_CHAR(v.BAKING_END_DATE, 'YYYY-MM-DD HH24:MI:SS')    AS "bakingEndDate"
         FROM IM_ITEM_MSL_CHECK_VIEW v
        WHERE NVL(v.ITEM_CODE, '*') LIKE :itemCode ESCAPE '\\'
          AND NVL(v.LINE_CODE, '*') LIKE :lineCode ESCAPE '\\'
          AND NVL(v.MODEL_NAME, '*') LIKE :modelName ESCAPE '\\'
        ORDER BY v.PASSED_RATE DESC NULLS LAST
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        itemCode: likePrefix(query.itemCode),
        lineCode: likePrefix(query.lineCode),
        modelName: likePrefix(query.modelName),
      }),
    )) as Row[];
    void organizationId;
    return limited(rows);
  }

  /**
   * 처리이력 (PB `d_mat_item_msl_check_lst` · `d_mat_item_msl_check_history_lst`).
   *
   * **이 표는 아직 비어 있다** — `IM_ITEM_MSL_CHECK_MASTER` 가 0행이다 (실측).
   * 조회 조건은 PB 처럼 바코드 등호가 아니라 앞부분 일치로 두었다 — 목록으로 보려면
   * 등호로는 한 건씩만 볼 수 있다.
   */
  async findHistory(query: MslCheckQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT TO_CHAR(c.SCAN_DATE, 'YYYY-MM-DD HH24:MI:SS')  AS "scanDate",
              c.SCAN_BY                   AS "scanBy",
              c.ITEM_CODE                 AS "itemCode",
              i.ITEM_NAME                 AS "itemName",
              i.ITEM_SPEC                 AS "itemSpec",
              i.MSL_LEVEL                 AS "mslLevel",
              c.ITEM_BARCODE              AS "itemBarcode",
              c.LOT_NO                    AS "lotNo",
              c.LOT_QTY                   AS "lotQty",
              c.MSL_ACTION_CODE           AS "mslActionCode",
              c.COMMENTS                  AS "comments",
              c.ENTER_BY                  AS "enterBy",
              TO_CHAR(c.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')        AS "enterDate"
         FROM IM_ITEM_MSL_CHECK_MASTER c
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = c.ITEM_CODE
               AND i.ORGANIZATION_ID = c.ORGANIZATION_ID
        WHERE NVL(c.ITEM_CODE, '*') LIKE :itemCode ESCAPE '\\'
          AND NVL(c.ITEM_BARCODE, '*') LIKE :barcode ESCAPE '\\'
          AND c.ORGANIZATION_ID = :organizationId
        ORDER BY c.SCAN_DATE DESC
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        itemCode: likePrefix(query.itemCode),
        barcode: likePrefix(query.barcode),
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }

  /**
   * 처리이력 등록 (**쓰기**). PB 는 `dw.update()` 로 넣었고 편집 가능한 열은
   * 처리코드와 비고 둘뿐이다 (실측) — 나머지는 화면이 채워 준다.
   */
  async createHistory(dto: MslCheckCreateDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      const result = await qr.query(
        `INSERT INTO IM_ITEM_MSL_CHECK_MASTER
           (SCAN_DATE, SCAN_BY, ITEM_CODE, ITEM_BARCODE, LOT_NO, LOT_QTY,
            MSL_ACTION_CODE, COMMENTS,
            ORGANIZATION_ID, ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
         SELECT SYSDATE, :userId, b.ITEM_CODE, b.ITEM_BARCODE, b.LOT_NO,
                DECODE(NVL(b.NEW_SCAN_QTY, 0), 0, b.SCAN_QTY, b.NEW_SCAN_QTY),
                :mslActionCode, :comments,
                :organizationId, SYSDATE, :userId, SYSDATE, :userId
           FROM IM_ITEM_RECEIPT_BARCODE b
          WHERE b.ITEM_BARCODE = :barcode
            AND b.ORGANIZATION_ID = :organizationId`,
        namedBinds({
          userId,
          mslActionCode: dto.mslActionCode,
          comments: dto.comments ?? null,
          organizationId,
          barcode: dto.barcode,
        }),
      );
      const rows = Number(affectedRows(result) ?? 0);
      if (rows !== 1) {
        // 다른 서비스와 같은 예외를 쓴다. 평범한 Error 를 던지면 500 으로 나가
        // 화면이 "등록에 실패했습니다" 만 띄우고 이유를 못 보여준다.
        throw new BadRequestException(`바코드를 찾을 수 없습니다: ${dto.barcode}`);
      }
      return { barcode: dto.barcode, mslActionCode: dto.mslActionCode, rows };
    });
  }
}
