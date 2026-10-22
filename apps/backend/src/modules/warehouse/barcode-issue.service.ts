/**
 * @file src/modules/warehouse/barcode-issue.service.ts
 * @description 238 자재바코드출고관리 — PB `w_mat_other_issue_barcode_master` 이식 (**쓰기**)
 *
 * 초보자 가이드:
 * 1. **자재를 라인으로 내보내는(출고대조) 화면이다.** 릴 바코드를 찍으면 그 릴이
 *    "라인으로 나갔다"로 표시되고 출고 원장에 한 건이 들어간다. 자재창고에서 가장
 *    많이 쓰는 화면이다 — 최근 90일 81,322건, 작업자 9명 이상이 찍는다 (실측).
 * 2. **찍기 전에 검사가 열 몇 가지 지난다.** 순서가 뜻을 정한다 — 예를 들어 FIFO
 *    경고는 "이미 출고된 바코드" 거절 **뒤에** 와야 한다. 앞에 오면 이미 나간 릴에
 *    엉뚱하게 FIFO 경고가 떠서 현장이 원인을 못 찾는다. 그래서 검사 순서를
 *    `evaluateScan` 한 곳에 배열로 적어 두고 **화면과 서버가 같은 순서를 쓴다.**
 * 3. **검사는 크게 두 종류다.**
 *      항상 하는 것 — 품목 유효기간 · 보류 · 입고대조 여부 · 중복 출고 · 수량
 *      켜고 끄는 것 — FIFO · MSL 시간 · PCB 코팅 · 장기재고 · 수명주기
 *    PB 체크박스 기본값을 그대로 옮겼다 (FIFO·MSL·PCB 코팅이 기본 ON).
 * 4. **FIFO(선입선출) 검사가 이 화면의 핵심이다.** 지금 찍은 릴보다 먼저 들어온
 *    릴이 창고에 남아 있으면 거절한다. PB 는 세 갈래로 본다:
 *      · PCB 품목 — 제조주차가 더 이른 릴이 있으면 거절
 *      · MOQ(최소 포장수량)보다 적게 남은 릴을 찍었을 때 — 제조일이 더 이른
 *        잔량 릴이 있으면 거절
 *      · 그 밖 — 잔량 릴이 있거나 제조일이 더 이른 릴이 있으면 거절
 *    세 갈래 모두 **베이킹 중인 릴은 뺀다** (`BAKING_START_DATE` 는 있고
 *    `BAKING_END_DATE` 는 없는 것) — 꺼낼 수 없는 릴이라 순서를 막으면 안 된다.
 * 5. **옮기지 않은 것** (실측 근거):
 *      · `rb_request` 자재요청 모드(출고구분 R) — 전체 기간 출고 0건이고
 *        `IM_ITEM_REQUEST` 가 7행이다.
 *      · `rb_smt_bom_report` — 인쇄용 DataWindow. 목록은 출고 BOM 탭이 보여준다.
 *      · `rb_compare_return`(Monitoring) — 생산계획(dw_9) 조회 화면이다.
 *      · 반품 2모드(`rb_mass_return`·`rb_mass_reball_wait_return`) — 250 출고바코드반품에서 다뤘다.
 *      · `dw_5.update()` · `dw_9` 피딩수량 — 앞은 갱신 대상이 없고, 뒤는
 *        피딩 계획이라 이 화면의 업무가 아니다.
 * 5-0. **옵션은 PB Option·Process 묶음을 전부 옮겼다.**
 *      · 기본값은 PB `f_config_setup` 처럼 ISYS_CONFIG 값, 없으면 PB NVL 기본값이다(`getOptions`).
 *        `MATERIAL_ISSUE_COMPARE_YN` 은 표에 없어 **기본 Y — 원라벨 대조가 켜져 있다**
 *        (최근 30일 P 출고의 86% 가 원라벨을 찍었고 14% 가 -NB 였다).
 *      · 잠금 옵션(FIFO 끔 · Model Not Check · No Origin Barcode)은 PB 처럼
 *        `ISYS_CONFIG.FIFO_ISSUE_PASSWORD` 비밀번호가 맞아야 쓴다. 판정·출고 때마다 서버가 다시 맞춘다.
 *      · MSL 시간은 PB 에서 잠긴 칸이라 설정값을 따른다. IQC 는 품목 검사규칙으로 자동이다.
 * 5-1. **출고 형태 (PB Category 라디오)** — 출고구분(ISSUE_DIVISION)과 BOM 대조 목록을 정한다.
 *      · P PCB Assy 출고 (`rb_issue_plan`, PB 기본값) — 전체 출고의 대부분(188만 건, 119개 모델/90일).
 *        제품 모델 품목을 `PKG_DESIGN.BOM_QUERY` 로 풀어 찍은 자재가 있는지 본다.
 *      · K SMT 출고 (`rb_kitting`) — SMT 모델·라인·TOP/BOTTOM 피더 BOM 으로 대조하고
 *        맞은 줄의 피더 위치를 출고 원장에 남긴다. 전체 기간 20건뿐이다.
 *      최근 30일 P 출고 1만여 건을 이 목록으로 다시 대조하면 99.9% 이상 통과한다 (실측).
 * 6. **PB 결함 하나는 경고로만 옮겼다.** 불량재고(창고 M02) 검사가 PB 에서
 *    `count(*)` 를 `lvi_count` 에 넣고 **`lvi_bad_count`** 를 보는데 그 변수는
 *    대입되는 곳이 없다 — 항상 0 이라 **한 번도 걸린 적이 없다.** 지금 거절로 켜면
 *    지금까지 나가던 것이 막히므로, 값을 함께 내되 **경고**로만 둔다.
 * 7. **DB 함수는 그대로 호출한다** — `F_GET_PREPARE_BARCODE` ·
 *    `F_GET_ITEM_CODE_FROM_BARCODE` · `F_GET_LOT_NO_FROM_BARCODE` ·
 *    `F_CHECK_PCB_COATING_DATE` · `F_GET_MAT_MSL_MAX_TIME` ·
 *    `F_GET_MSL_PASSED_TIME` 전부 PB 가 SQL 안에서 부르고 DB 에 VALID 로 있다.
 *    반대로 `f_check_item_inventory_hold_yn` · `f_check_item_barcode_hold_yn` ·
 *    `f_check_item_exists` 는 **PB 함수**라 본문 SQL 을 인라인했다.
 * 8. **쓰기는 실행하지 않고 parse 로만 검증했다** (사용자 결정).
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { likePrefix } from '@smt/shared';
import { limited, ROW_LIMIT } from '../../shared/row-limit';
import { TransactionService } from '../../shared/transaction.service';
import { OracleService } from '../../common/services/oracle.service';
import { IssueManageService } from './issue-manage.service';
import {
  BarcodeIssueCancelDto,
  BarcodeIssueReturnDto,
  BarcodeIssueReturnLookupDto,
  BarcodeIssueDto,
  BarcodeIssueHistoryQueryDto,
  BarcodeIssueScanDto,
  BarcodeIssueWaitingQueryDto,
  IssueBomQueryDto,
  IssueMode,
} from './warehouse.dto';
import { affectedRows } from '../../common/utils/affected-rows.util';
import { namedBinds } from '../../common/utils/named-binds.util';

type Row = Record<string, unknown>;

/** PB 가 이 경로에서 고정으로 넣던 값. */
const FIXED = {
  /** 3 = 출고 (수량이 양수다) */
  issueDeficit: 3,
  issueStatus: 'N',
  issueType: 'N',
  issueAccount: 'M001',
  /** 'T' = 바코드 출고 (실측 이 경로 전부 T) */
  itemType: 'T',
  machineCode: '*',
  workOrderNo: '*',
  parentItemCode: '*',
  closeYn: 'N',
} as const;

/**
 * P(PCB Assy) 출고 BOM — PB `d_des_bom_query_4_issue_plan_check_lst` + `f_set_replace_item_4_issue_bom_query`.
 *
 * `PKG_DESIGN.BOM_QUERY` 가 설계BOM 을 ID_ENG_BOM_TEMP 에 풀고 세션ID(:sid)를 돌려준다.
 * 조건은 PB 그대로다 — 첫 단계(BOM_LEVEL 1) 제외, 라인유형 M·S 제외, 상위 품목 ITEM_CLASS 가 있는 것.
 * 대체품(ID_ITEM_REPLACE)은 PB 처럼 같은 목록에 'REPLACE' 로 붙인다 — 대체품으로 찍어도 통과한다.
 */
const PLAN_BOM_SQL = `
  WITH bom AS (
    SELECT t.PARENT_ITEM_CODE, t.CHILD_ITEM_CODE, t.ITEM_UNIT_QTY, t.WORKSTAGE_CODE,
           t.LINE_TYPE, t.SORT_ORDER, t.ORGANIZATION_ID
      FROM ID_ENG_BOM_TEMP t, ID_ITEM a
     WHERE t.PARENT_ITEM_CODE = a.ITEM_CODE (+)
       AND t.ORGANIZATION_ID = a.ORGANIZATION_ID (+)
       AND t.SESSION_ID = :sid
       AND t.ORGANIZATION_ID = :org
       AND t.BOM_LEVEL <> 1
       AND t.LINE_TYPE NOT IN ('M', 'S')
       AND a.ITEM_CLASS LIKE '%'
  ), list AS (
    SELECT 'BOM' AS div, b.PARENT_ITEM_CODE, b.CHILD_ITEM_CODE AS item_code, NULL AS replace_for,
           b.ITEM_UNIT_QTY, b.WORKSTAGE_CODE, b.LINE_TYPE, b.SORT_ORDER, 0 AS sub_order, b.ORGANIZATION_ID
      FROM bom b
    UNION ALL
    SELECT 'REPLACE', b.PARENT_ITEM_CODE, r.REPLACE_ITEM_CODE, b.CHILD_ITEM_CODE,
           r.ITEM_UNIT_QTY, r.WORKSTAGE_CODE, b.LINE_TYPE, b.SORT_ORDER, 1, b.ORGANIZATION_ID
      FROM bom b
      JOIN ID_ITEM_REPLACE r
        ON r.PARENT_ITEM_CODE = b.PARENT_ITEM_CODE
       AND r.CHILD_ITEM_CODE = b.CHILD_ITEM_CODE
       AND r.ORGANIZATION_ID = b.ORGANIZATION_ID
       AND r.DATESET <= TRUNC(SYSDATE)
       AND r.DATEEND >= TRUNC(SYSDATE)
  )
  SELECT l.div                       AS "div",
         l.PARENT_ITEM_CODE          AS "parentItemCode",
         l.item_code                 AS "itemCode",
         i.ITEM_NAME                 AS "itemName",
         i.ITEM_SPEC                 AS "itemSpec",
         l.replace_for               AS "replaceFor",
         l.ITEM_UNIT_QTY             AS "bomQty",
         l.WORKSTAGE_CODE            AS "workstageCode",
         NULL                        AS "pcbItem",
         NULL                        AS "feederLocationCode",
         F_GET_MAT_INVENTORY_QTY(l.item_code, l.LINE_TYPE, l.ORGANIZATION_ID) AS "inventoryQty"
    FROM list l
    LEFT JOIN ID_ITEM i ON i.ITEM_CODE = l.item_code AND i.ORGANIZATION_ID = l.ORGANIZATION_ID
   ORDER BY l.SORT_ORDER, l.sub_order, l.item_code`;

/**
 * K(SMT) 출고 BOM — PB `d_des_smt_bom_4_item_kitting_lst2` (피더 BOM + 대체품).
 * PB 의 재고 열(Include Inventory)과 계획수량 열(Plan Qty)은 쓰지 않아 뺐다.
 */
const KITTING_BOM_SQL = `
  SELECT 'BOM'                       AS "div",
         a.PARENT_ITEM_CODE          AS "parentItemCode",
         a.CHILD_ITEM_CODE           AS "itemCode",
         b.ITEM_NAME                 AS "itemName",
         b.ITEM_SPEC                 AS "itemSpec",
         NULL                        AS "replaceFor",
         SUM(a.ITEM_UNIT_QTY)        AS "bomQty",
         NULL                        AS "workstageCode",
         a.PCB_ITEM                  AS "pcbItem",
         a.LOCATION_CODE             AS "feederLocationCode",
         NULL                        AS "inventoryQty",
         a.TABLE_ID                  AS "tableId",
         SUM(F_GET_SHAFT_FEEDING_QTY(a.LINE_CODE, a.PARENT_ITEM_CODE, a.LOCATION_CODE, a.PCB_ITEM, a.FEEDER_SHAFT)) AS "feedingQty",
         SUM(F_GET_FEEDER_ACTUAL_QTY(a.LINE_CODE, a.PARENT_ITEM_CODE, a.LOCATION_CODE, a.PCB_ITEM)) AS "actualQty",
         SUM(F_GET_UNFEEDING_QTY(a.LINE_CODE, a.PARENT_ITEM_CODE, a.CHILD_ITEM_CODE, a.LOCATION_CODE, a.FEEDER_SHAFT)) AS "unfeedingQty",
         b.LOCATION_ADDRESS          AS "locationAddress",
         F_GET_MODEL_ST(a.PARENT_ITEM_CODE, a.LINE_CODE, 'A', a.ORGANIZATION_ID) AS "stValue"
    FROM ID_ENG_BOM_SMT a, ID_ITEM b
   WHERE a.CHILD_ITEM_CODE = b.ITEM_CODE (+)
     AND a.ORGANIZATION_ID = b.ORGANIZATION_ID (+)
     AND a.SMT_MODEL_NAME = :modelName
     AND a.LINE_CODE = :lineCode
     AND a.DATESET <= SYSDATE
     AND NVL(a.DATEEND, TO_DATE('99991231', 'YYYYMMDD')) >= SYSDATE
     AND a.PCB_ITEM LIKE :topBottom
     AND a.ORGANIZATION_ID = :org
   GROUP BY a.PARENT_ITEM_CODE, a.CHILD_ITEM_CODE, b.ITEM_NAME, b.ITEM_SPEC, a.LINE_CODE,
            a.TABLE_ID, a.LOCATION_CODE, a.PCB_ITEM, a.FEEDER_SHAFT, a.ORGANIZATION_ID, b.LOCATION_ADDRESS
  UNION ALL
  SELECT 'REPLACE', a.PARENT_ITEM_CODE, a.REPLACE_ITEM_CODE, b.ITEM_NAME, b.ITEM_SPEC,
         a.CHILD_ITEM_CODE, SUM(a.ITEM_UNIT_QTY), NULL, a.PCB_ITEM, NULL,
         NULL,
         a.TABLE_ID, 0, 0, 0, b.LOCATION_ADDRESS, 0
    FROM ID_ENG_BOM_SMT_REPLACE a, ID_ITEM b
   WHERE a.REPLACE_ITEM_CODE = b.ITEM_CODE (+)
     AND a.ORGANIZATION_ID = b.ORGANIZATION_ID (+)
     AND a.PARENT_ITEM_CODE = :modelName
     AND a.LINE_CODE = :lineCode
     AND a.DATESET <= SYSDATE
     AND NVL(a.DATEEND, TO_DATE('99991231', 'YYYYMMDD')) >= SYSDATE
     AND a.PCB_ITEM LIKE :topBottom
     AND a.ORGANIZATION_ID = :org
   GROUP BY a.PARENT_ITEM_CODE, a.REPLACE_ITEM_CODE, a.CHILD_ITEM_CODE, b.ITEM_NAME,
            b.ITEM_SPEC, a.TABLE_ID, a.PCB_ITEM, a.ORGANIZATION_ID, b.LOCATION_ADDRESS
   ORDER BY 10, 3`;

/** 라벨유형 → 창고 (PB: R 리볼대기 M06 · B 벌크 M05 · 그 밖 양산 M01). */
const labelLocation = (labelType: string) => (labelType === 'R' ? 'M06' : labelType === 'B' ? 'M05' : 'M01');

/** 출고 BOM 한 줄 (P·K 공통 모양). */
export interface IssueBomRow {
  div: 'BOM' | 'REPLACE';
  parentItemCode: string | null;
  itemCode: string;
  itemName: string | null;
  itemSpec: string | null;
  replaceFor: string | null;
  bomQty: number | null;
  workstageCode: string | null;
  pcbItem: string | null;
  feederLocationCode: string | null;
  inventoryQty: number | null;
  /** K 만 — 피더 테이블 · 공급/실적/미공급 수량 · 보관위치 · ST */
  tableId?: string | null;
  feedingQty?: number | null;
  actualQty?: number | null;
  unfeedingQty?: number | null;
  locationAddress?: string | null;
  stValue?: number | null;
}

/** 한 건의 검사 결과. */
export interface ScanCheck {
  /** 검사 이름 (화면이 목록으로 보여준다) */
  key: string;
  label: string;
  /** 'pass' 통과 · 'reject' 거절 · 'warn' 경고(통과) · 'skip' 끔 */
  result: 'pass' | 'reject' | 'warn' | 'skip';
  detail?: string;
}

@Injectable()
export class BarcodeIssueService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
    private readonly oracle: OracleService,
    private readonly issueManage: IssueManageService,
  ) {}

  // ───────────────────────────────── 조회

  /**
   * 출고 이력 (PB `d_mat_issue_4_barcode_compare_view`).
   *
   * **이 목록은 편집할 수 없다** — PB DataWindow 에 갱신 대상 표가 없고, 편집 가능한
   * 열은 타이핑해도 버려진다 (실측).
   */
  async findIssues(query: BarcodeIssueHistoryQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT TO_CHAR(s.ISSUE_DATE, 'YYYY-MM-DD')  AS "issueDate",
              s.ISSUE_SEQUENCE            AS "issueSequence",
              s.ITEM_CODE                 AS "itemCode",
              i.ITEM_NAME                 AS "itemName",
              i.ITEM_SPEC                 AS "itemSpec",
              i.ITEM_UOM                  AS "itemUom",
              s.ISSUE_QTY                 AS "issueQty",
              s.MATERIAL_MFS              AS "lotNo",
              s.BARCODE                   AS "barcode",
              s.ORIGIN_MFS                AS "supplierBarcode",
              s.LINE_CODE                 AS "lineCode",
              F_GET_LINE_NAME(s.LINE_CODE, 1)          AS "lineName",
              s.WORKSTAGE_CODE            AS "workstageCode",
              s.FEEDER_LOCATION_CODE      AS "feederLocationCode",
              s.ISSUE_DIVISION            AS "issueDivision",
              s.MODEL_NAME                AS "modelName",
              s.INVENTORY_TYPE            AS "inventoryType",
              s.MSL_PASSED_TIME           AS "mslPassedTime",
              s.LOCATION_CODE             AS "locationCode",
              s.MFS                       AS "mfs",
              s.INVOICE_NO                AS "receiptSlipNo",
              s.SUPPLIER_CODE             AS "supplierCode",
              s.LINE_TYPE                 AS "lineType",
              s.ISSUE_STATUS              AS "issueStatus",
              s.ENTER_BY                  AS "enterBy",
              TO_CHAR(s.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')        AS "enterDate"
         FROM IM_ITEM_ISSUE s
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = s.ITEM_CODE
               AND i.ORGANIZATION_ID = s.ORGANIZATION_ID
        WHERE s.ISSUE_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND s.ISSUE_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND s.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND NVL(s.MATERIAL_MFS, '*') LIKE :lotNo ESCAPE '\\'
          AND NVL(s.LINE_CODE, '*') LIKE :lineCode ESCAPE '\\'
          AND NVL(s.WORKSTAGE_CODE, '*') LIKE :workstageCode ESCAPE '\\'
          AND NVL(s.MODEL_NAME, '*') LIKE :modelName ESCAPE '\\'
          -- 출고만 본다 (반품은 250 화면이다).
          AND s.ISSUE_DEFICIT = '${FIXED.issueDeficit}'
          AND s.ORGANIZATION_ID = :organizationId
        ORDER BY s.ISSUE_DATE DESC, s.ISSUE_SEQUENCE DESC
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        itemCode: likePrefix(query.itemCode),
        lotNo: likePrefix(query.lotNo),
        lineCode: likePrefix(query.lineCode),
        workstageCode: likePrefix(query.workstageCode),
        modelName: likePrefix(query.modelName),
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }

  /**
   * 출고 대기 바코드 — 입고대조는 됐고 아직 라인으로 안 나간 릴.
   *
   * PB 고정조건을 유지한다: `RECEIPT_COMPARE_YN='Y'`(입고된 것) ·
   * `ISSUE_COMPARE_YN<>'Y'`(아직 안 나간 것) · `BARCODE_STATUS<>'C'`(취소 아님).
   */
  async findWaiting(query: BarcodeIssueWaitingQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT b.ITEM_BARCODE              AS "itemBarcode",
              b.ITEM_CODE                 AS "itemCode",
              i.ITEM_NAME                 AS "itemName",
              i.ITEM_SPEC                 AS "itemSpec",
              i.ITEM_CLASS                AS "itemClass",
              i.MSL_LEVEL                 AS "mslLevel",
              NVL(i.MATERIAL_QTY, 0)      AS "moqQty",
              b.LOT_NO                    AS "lotNo",
              DECODE(NVL(b.NEW_SCAN_QTY, 0), 0, b.SCAN_QTY, b.NEW_SCAN_QTY) AS "currentQty",
              b.SCAN_QTY                  AS "scanQty",
              b.RECEIPT_SLIP_NO           AS "receiptSlipNo",
              b.SUPPLIER_CODE             AS "supplierCode",
              b.INVENTORY_TYPE            AS "inventoryType",
              b.LABEL_TYPE                AS "labelType",
              b.MANUFACTURE_WEEK          AS "manufactureWeek",
              TO_CHAR(b.MANUFACTURE_DATE, 'YYYY-MM-DD')      AS "manufactureDate",
              TO_CHAR(b.RECEIPT_COMPARE_DATE, 'YYYY-MM-DD')  AS "receiptCompareDate",
              b.HOLDING_YN                AS "holdingYn",
              b.LINE_CODE                 AS "lineCode",
              b.WORKSTAGE_CODE            AS "workstageCode",
              -- 베이킹 중인 릴은 꺼낼 수 없다 (FIFO 판정에서도 뺀다).
              CASE WHEN b.BAKING_START_DATE IS NOT NULL
                    AND b.BAKING_END_DATE IS NULL
                   THEN 'Y' ELSE 'N' END  AS "bakingYn",
              TO_CHAR(b.SCAN_DATE, 'YYYY-MM-DD HH24:MI:SS')  AS "scanDate"
         FROM IM_ITEM_RECEIPT_BARCODE b
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = b.ITEM_CODE
               AND i.ORGANIZATION_ID = b.ORGANIZATION_ID
        WHERE b.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND b.ITEM_BARCODE LIKE :barcode ESCAPE '\\'
          AND b.LOT_NO LIKE :lotNo ESCAPE '\\'
          -- PB 고정조건
          AND NVL(b.RECEIPT_COMPARE_YN, 'N') = 'Y'
          AND NVL(b.ISSUE_COMPARE_YN, 'N') <> 'Y'
          AND NVL(b.BARCODE_STATUS, '*') <> 'C'
          AND NVL(b.LOT_DIVIDE_YN, 'N') = 'N'
          AND b.ORGANIZATION_ID = :organizationId
        ORDER BY b.SCAN_DATE, b.ITEM_BARCODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        itemCode: likePrefix(query.itemCode),
        barcode: likePrefix(query.barcode),
        lotNo: likePrefix(query.lotNo),
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }

  /**
   * 출고 BOM — 출고 형태별로 찍은 자재를 대조하는 목록 (PB dw_5 · dw_1).
   *
   * P 는 `PKG_DESIGN.BOM_QUERY` 로 제품 모델의 설계BOM 을 푼다. 전개 함수가
   * ID_ENG_BOM_TEMP 에 INSERT 하므로 **출고 트랜잭션 밖의 별도 커넥션**에서 부르고
   * 반납 때 롤백한다(`callFunctionReturningCursor`) — 임시행이 남지 않고, 패키지 예외부의
   * ROLLBACK 이 출고 쓰기를 지우지도 않는다.
   */
  async findIssueBom(query: IssueBomQueryDto, organizationId: number): Promise<IssueBomRow[]> {
    const modelName = query.modelName.trim();
    if (query.issueMode === 'K') {
      if (!query.lineCode?.trim()) return [];
      return (await this.dataSource.query(KITTING_BOM_SQL, namedBinds({
        modelName,
        lineCode: query.lineCode.trim(),
        topBottom: query.topBottom?.trim() || '%',
        org: organizationId,
      }))) as IssueBomRow[];
    }

    // PB uo_set_model_name_dynamic — 유효한 제품 모델의 품목코드로 BOM 을 푼다.
    // 모델명 하나에 유효 품목은 하나다 (실측 251개 모델 중 중복 0).
    const model = ((await this.dataSource.query(
      `SELECT ITEM_CODE AS "itemCode"
         FROM IP_PRODUCT_MODEL_MASTER
        WHERE MODEL_NAME = :modelName
          AND ORGANIZATION_ID = :org
          AND DATEEND >= TRUNC(SYSDATE)
          AND ROWNUM = 1`,
      namedBinds({ modelName, org: organizationId }),
    )) as Row[])[0];
    const parent = (model?.itemCode as string | undefined) ?? '';
    if (!parent) return [];

    const { rows, sessionId } = await this.oracle.callFunctionReturningCursor(
      'PKG_DESIGN.BOM_QUERY(:parent, TRUNC(SYSDATE), :org)',
      PLAN_BOM_SQL,
      { parent, org: organizationId },
    );
    return sessionId > 0 ? (rows as unknown as IssueBomRow[]) : [];
  }

  /**
   * FIFO 위반 후보 — 지금 찍은 릴보다 먼저 써야 하는 릴 목록
   * (PB `d_mat_inventory_fifo_check_lst`, 거절 뒤에 띄우는 표).
   *
   * 거절 이유를 눈으로 확인할 수 있어야 하므로 **목록으로** 낸다. 조건은 FIFO
   * 판정과 같다 (파일 머리 4번).
   */
  async findFifoCandidates(
    itemCode: string,
    lotNo: string,
    inventoryType: string | null,
    organizationId: number,
  ) {
    const rows = (await this.dataSource.query(
      `SELECT b.ITEM_BARCODE              AS "itemBarcode",
              b.LOT_NO                    AS "lotNo",
              b.SCAN_QTY                  AS "scanQty",
              b.MANUFACTURE_WEEK          AS "manufactureWeek",
              TO_CHAR(b.MANUFACTURE_DATE, 'YYYY-MM-DD')      AS "manufactureDate",
              TO_CHAR(b.RECEIPT_COMPARE_DATE, 'YYYY-MM-DD')  AS "receiptCompareDate",
              b.INVENTORY_TYPE            AS "inventoryType",
              b.LABEL_TYPE                AS "labelType",
              v.INVENTORY_QTY             AS "inventoryQty",
              v.LOCATION_CODE             AS "locationCode"
         FROM IM_ITEM_RECEIPT_BARCODE b
         JOIN IM_ITEM_INVENTORY v
           ON v.ITEM_CODE = b.ITEM_CODE
          AND v.MATERIAL_MFS = b.LOT_NO
          AND v.LOCATION_CODE = 'M01'
          AND v.INVENTORY_QTY > 0
          AND v.ORGANIZATION_ID = b.ORGANIZATION_ID
        WHERE b.ITEM_CODE = :itemCode
          AND b.LOT_NO <> :lotNo
          AND NVL(b.RECEIPT_COMPARE_YN, 'N') = 'Y'
          AND NVL(b.ISSUE_COMPARE_YN, 'N') = 'N'
          AND NVL(b.REEL_DESTROY_YN, 'N') = 'N'
          AND NVL(b.LABEL_TYPE, 'N') = 'N'
          AND NVL(b.INVENTORY_TYPE, '*') = NVL(:inventoryType, '*')
          -- 베이킹 중인 릴은 꺼낼 수 없으니 순서를 막지 않는다 (PB 조건 그대로).
          AND NOT (b.BAKING_START_DATE IS NOT NULL AND b.BAKING_END_DATE IS NULL)
          AND b.ORGANIZATION_ID = :organizationId
        ORDER BY b.MANUFACTURE_DATE, b.MANUFACTURE_WEEK, b.LOT_NO
        FETCH FIRST 200 ROWS ONLY`,
      namedBinds({ itemCode, lotNo, inventoryType, organizationId }),
    )) as Row[];
    return limited(rows);
  }

  // ───────────────────────────────── 옵션 기본값 · 잠금

  /**
   * 출고 옵션 기본값 — PB `f_config_setup` 이 ISYS_CONFIG 를 읽고 **없으면 NVL 기본값**을 쓴다.
   * 그래서 `MATERIAL_ISSUE_COMPARE_YN` 이 표에 없으면 원라벨 대조가 **켜진다**(기본 Y).
   */
  async getOptions(organizationId: number) {
    void organizationId;
    const rows = (await this.dataSource.query(
      `SELECT CONFIG_NAME AS "name", CONFIG_VALUE AS "value"
         FROM ISYS_CONFIG
        WHERE CONFIG_NAME IN ('MATERIAL_FIFO_YN', 'MATERIAL_ISSUE_COMPARE_YN', 'MSL_TIME_CHECK_YN',
                              'LIFE_CYCLE_CHECK_YN', 'ISSUE_BY_FEEDER', 'LONG_TERM_INVENTORY')`,
    )) as Row[];
    const v = (name: string, fallback: 'Y' | 'N') =>
      String(rows.find((r) => r.name === name)?.value ?? fallback) === 'Y';
    return {
      materialFifo: v('MATERIAL_FIFO_YN', 'N'),
      issueCompare: v('MATERIAL_ISSUE_COMPARE_YN', 'Y'),
      mslTimeCheck: v('MSL_TIME_CHECK_YN', 'Y'),
      lifeCycleCheck: v('LIFE_CYCLE_CHECK_YN', 'N'),
      issueByFeeder: v('ISSUE_BY_FEEDER', 'N'),
      longTermInventory: v('LONG_TERM_INVENTORY', 'N'),
    };
  }

  /** 라인의 생산유형 (PB: PDA 로 고른 IP_PRODUCT_LINE.PRODUCTION_TYPE → Inv Type 기본값). */
  private async lineProductionType(lineCode: string | undefined, organizationId: number) {
    if (!lineCode?.trim()) return null;
    const rows = (await this.dataSource.query(
      `SELECT PRODUCTION_TYPE AS "type" FROM IP_PRODUCT_LINE
        WHERE LINE_CODE = :lineCode AND ORGANIZATION_ID = :organizationId`,
      namedBinds({ lineCode: lineCode.trim(), organizationId }),
    )) as Row[];
    const t = String(rows[0]?.type ?? '');
    return t && t !== '*' ? t : null;
  }

  /**
   * 라인을 고르면 PB 가 채우던 값 — 생산유형(Inv Type) · SMT 공정 · 그 라인에 걸린 생산계획 모델·면.
   */
  async getLineDefaults(lineCode: string, organizationId: number) {
    const productionType = await this.lineProductionType(lineCode, organizationId);
    const ws = (await this.dataSource.query(
      `SELECT MAX(WORKSTAGE_CODE) AS "code" FROM IP_PRODUCT_WORKSTAGE
        WHERE WORKSTAGE_TYPE = 'S' AND ORGANIZATION_ID = :organizationId`,
      namedBinds({ organizationId }),
    )) as Row[];
    const plan = (await this.dataSource.query(
      `SELECT SMT_MODEL_NAME AS "modelName", PCB_ITEM AS "pcbItem"
         FROM IB_PRODUCT_PLANDATA
        WHERE LINE_CODE = :lineCode AND ACTIVE_YN = 'Y' AND ORGANIZATION_ID = :organizationId
          AND ROWNUM = 1`,
      namedBinds({ lineCode, organizationId }),
    )) as Row[];
    return {
      productionType,
      workstageCode: (ws[0]?.code as string) ?? null,
      planModelName: (plan[0]?.modelName as string) ?? null,
      planPcbItem: (plan[0]?.pcbItem as string) ?? null,
    };
  }

  /** 런카드 번호(9자리)로 모델을 찾는다 — PB sle_model_suffix modified. */
  async getRunCardModel(runNo: string, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT MODEL_NAME AS "modelName" FROM IP_PRODUCT_RUN_CARD
        WHERE RUN_NO = :runNo AND ORGANIZATION_ID = :organizationId AND ROWNUM = 1`,
      namedBinds({ runNo: runNo.trim(), organizationId }),
    )) as Row[];
    return { modelName: (rows[0]?.modelName as string) ?? null };
  }

  /** 잠금 옵션 비밀번호 — PB w_lock_by_config('FIFO_ISSUE_PASSWORD'). 값은 화면에 내보내지 않는다. */
  private async passwordMatches(password: string | undefined) {
    if (!password) return false;
    const rows = (await this.dataSource.query(
      `SELECT CONFIG_VALUE AS "value" FROM ISYS_CONFIG WHERE CONFIG_NAME = 'FIFO_ISSUE_PASSWORD'`,
    )) as Row[];
    const value = rows[0]?.value as string | undefined;
    return value !== undefined && value !== null && password === value;
  }

  /** 잠금 해제 확인 (화면의 '?' 버튼). 맞으면 그 비밀번호를 판정·출고 요청에 실어 보낸다. */
  async verifyUnlock(password: string) {
    if (!(await this.passwordMatches(password))) {
      throw new BadRequestException('비밀번호가 맞지 않습니다.');
    }
    return { unlocked: true };
  }

  // ───────────────────────────────── 스캔 판정 (읽기)

  /**
   * 찍은 바코드가 출고 가능한지 **PB 와 같은 순서로** 본다 (읽기 전용).
   *
   * 화면은 이 결과로 버튼을 막고 거절 사유를 보여주고, 쓰기 경로는 **같은 함수를
   * 다시 불러** 판정한다. 그래서 화면이 보여준 사유와 서버가 내는 사유가 같다.
   */
  async evaluateScan(dto: BarcodeIssueScanDto, organizationId: number) {
    const checks: ScanCheck[] = [];
    const add = (
      key: string, label: string, result: ScanCheck['result'], detail?: string,
    ) => { checks.push({ key, label, result, detail }); };
    const firstReject = () => checks.find((c) => c.result === 'reject') ?? null;

    // ① 라인·공정은 PB 가 맨 앞에서 요구한다.
    /**
     * 켜고 끄는 검사의 기본값을 **여기서** 정한다.
     *
     * DTO 의 `@Transform` 에만 맡기면 컨트롤러를 거치지 않는 호출(다른 서비스가
     * 부르거나 시험 하네스)에서 `undefined` 가 그대로 넘어와 **안전한 기본값이
     * 꺼진다.** PB 체크박스 기본값(FIFO·MSL·PCB 코팅 ON)을 서비스가 보장한다.
     */
    const config = await this.getOptions(organizationId);
    const on = {
      // FIFO 는 잠금 옵션이다 — 끄려면 비밀번호가 맞아야 한다 (아래 unlock 검사).
      fifo: dto.checkFifo ?? config.materialFifo,
      // MSL 은 PB 에서 잠긴 칸(설정값)이다. 화면이 끄지 못한다.
      mslTime: config.mslTimeCheck,
      pcbCoating: dto.checkPcbCoating ?? true,
      longTerm: dto.checkLongTermInventory ?? config.longTermInventory,
      lifeCycle: dto.checkLifeCycle ?? config.lifeCycleCheck,
    };

    // 잠금 옵션(PB '?' 버튼 + w_lock_by_config)을 쓰면 비밀번호를 서버에서 다시 맞춘다.
    const lockedUsed = [
      !on.fifo && config.materialFifo ? 'FIFO 끔' : null,
      dto.modelNotCheck ? 'Model Not Check' : null,
      dto.noOriginBarcode ? 'No Origin Barcode' : null,
    ].filter((v): v is string => v !== null);
    if (lockedUsed.length > 0) {
      const ok = await this.passwordMatches(dto.unlockPassword);
      add('unlock', '잠금 옵션', ok ? 'warn' : 'reject',
        ok ? `${lockedUsed.join(' · ')} (비밀번호 확인)` : `${lockedUsed.join(' · ')} — 비밀번호가 맞지 않습니다.`);
    }

    if (!dto.lineCode?.trim()) add('line', '라인', 'reject', '라인을 고르세요.');
    else add('line', '라인', 'pass', dto.lineCode);
    if (!dto.workstageCode?.trim()) {
      add('workstage', '공정', 'reject', '공정을 고르세요.');
    } else add('workstage', '공정', 'pass', dto.workstageCode);

    // ② 바코드를 정제하고 품목·롯트를 뽑는다. PB 와 같은 DB 함수를 쓴다.
    const parsed = ((await this.dataSource.query(
      `SELECT F_GET_PREPARE_BARCODE(:barcode)                 AS "clean",
              F_GET_ITEM_CODE_FROM_BARCODE(
                F_GET_PREPARE_BARCODE(:barcode))              AS "itemCode",
              F_GET_LOT_NO_FROM_BARCODE(
                F_GET_PREPARE_BARCODE(:barcode))              AS "lotNo"
         FROM DUAL`,
      namedBinds({ barcode: dto.barcode }),
    )) as Row[])[0] ?? {};
    const itemCode = (parsed.itemCode as string) || '';
    const lotNo = (parsed.lotNo as string) || '';
    if (!itemCode) add('itemCode', '품목 해석', 'reject', '바코드에서 품목을 찾을 수 없습니다.');
    else add('itemCode', '품목 해석', 'pass', itemCode);
    if (!lotNo) add('lotNo', '롯트 해석', 'reject', '바코드에서 롯트를 찾을 수 없습니다.');
    else add('lotNo', '롯트 해석', 'pass', lotNo);

    if (!itemCode || !lotNo) {
      return {
        barcode: (parsed.clean as string) ?? dto.barcode,
        itemCode: itemCode || null, lotNo: lotNo || null,
        item: null, barcodeRow: null, checks,
        issueMode: dto.issueMode ?? 'P', feederLocationCode: null as string | null,
        supplierBarcode: null as string | null, inventoryType: null as string | null, locationCode: 'M01',
        issuable: false, reason: firstReject()?.detail ?? null,
      };
    }

    // ②-1 사전 검사 — PB 가 바코드를 찍은 직후(sle_our_barcode modified) 출고 함수보다 먼저 본다.
    const inventoryType = dto.inventoryType?.trim()
      || (await this.lineProductionType(dto.lineCode, organizationId)) || 'P';
    const pre = ((await this.dataSource.query(
      `SELECT ( SELECT MIN(m.INSPECT_RULE) FROM IM_ITEM_MASTER m
                 WHERE m.ITEM_CODE = :itemCode AND m.ORGANIZATION_ID = :organizationId ) AS "inspectRule",
              ( SELECT COUNT(*) FROM IM_ITEM_RECEIPT_BARCODE r
                 WHERE r.LOT_NO = :lotNo AND r.INSPECT_RESULT = 'P'
                   AND r.ORGANIZATION_ID = :organizationId )                         AS "iqcPassCount",
              ( SELECT COUNT(*) FROM IM_ITEM_BAKING_MASTER k
                 WHERE k.ITEM_BARCODE LIKE :barcode AND k.OUTPUT_SCAN_DATE IS NULL ) AS "chamberCount",
              ( SELECT MAX(F_GET_MACHINE_NAME(k.CHAMBER_CODE)) FROM IM_ITEM_BAKING_MASTER k
                 WHERE k.ITEM_BARCODE LIKE :barcode AND k.OUTPUT_SCAN_DATE IS NULL ) AS "chamberName",
              -- 재고 행이 불량 창고(M02)에 있나. PB 는 롯트로 한 행을 읽는다.
              ( SELECT MAX(CASE WHEN v.LOCATION_CODE = 'M02' THEN 'M02' ELSE v.LOCATION_CODE END)
                  FROM IM_ITEM_INVENTORY v
                 WHERE v.MATERIAL_MFS = :lotNo AND v.ORGANIZATION_ID = :organizationId
                   AND v.LOCATION_CODE = 'M02' )                                    AS "inventoryLocation",
              ( SELECT MAX(v.INVENTORY_TYPE) FROM IM_ITEM_INVENTORY v
                 WHERE v.MATERIAL_MFS = :lotNo AND v.ORGANIZATION_ID = :organizationId ) AS "stockInventoryType"
         FROM DUAL`,
      namedBinds({ itemCode, lotNo, organizationId, barcode: dto.barcode.trim() }),
    )) as Row[])[0] ?? {};

    // IQC — 품목 검사규칙이 무검사(P)가 아니면 IQC 합격 이력이 있어야 한다 (PB cbx_iqc_check 자동).
    const iqcRequired = String(pre.inspectRule ?? '') !== 'P';
    if (!iqcRequired) add('iqc', 'IQC', 'skip', '무검사 품목');
    else {
      const passed = Number(pre.iqcPassCount ?? 0) > 0;
      add('iqc', 'IQC', passed ? 'pass' : 'reject', passed ? undefined : 'IQC 불합격이거나 판정 이력이 없습니다.');
    }
    // 베이킹·진공·제습 챔버에 들어가 아직 나오지 않은 릴
    add('chamber', '챔버 보관', Number(pre.chamberCount ?? 0) > 0 ? 'reject' : 'pass',
      Number(pre.chamberCount ?? 0) > 0 ? `${pre.chamberName ?? '챔버'}에 미출고 된 자재입니다.` : undefined);
    // 불량 창고(M02)에 있는 롯트
    add('badLocation', '불량 창고', String(pre.inventoryLocation ?? '') === 'M02' ? 'reject' : 'pass',
      String(pre.inventoryLocation ?? '') === 'M02' ? '불량품으로 등록 된 자재입니다.' : undefined);
    // 생산 유형(Inv Type) ↔ 재고 유형
    const stockType = String(pre.stockInventoryType ?? '');
    const typeMismatch = (stockType === 'S' && inventoryType !== 'S') || (stockType === 'P' && inventoryType === 'S');
    add('inventoryType', '생산·재고 유형', typeMismatch ? 'reject' : 'pass',
      typeMismatch ? `생산 유형(${inventoryType})과 재고 유형(${stockType})이 일치하지 않습니다.` : `${inventoryType}`);

    // ③ 한 번에 필요한 사실을 모은다 — 품목 기준정보 · 보류 · 바코드 원장 · 수명.
    const facts = ((await this.dataSource.query(
      `SELECT i.ITEM_NAME                 AS "itemName",
              i.ITEM_SPEC                 AS "itemSpec",
              i.ITEM_CLASS                AS "itemClass",
              i.MSL_LEVEL                 AS "mslLevel",
              NVL(i.MATERIAL_QTY, 0)      AS "moqQty",
              NVL(i.LIFE_CYCLE, 365)      AS "lifeCycle",
              NVL(i.ECO_CHECK_YN, 'N')    AS "ecoCheckYn",
              i.ECO_CHECK_COMMENTS        AS "ecoCheckComments",
              i.LINE_TYPE                 AS "lineType",
              i.SUPPLIER_CODE             AS "itemSupplierCode",
              -- PB f_check_item_exists 를 인라인한 것이다 (품목 유효기간).
              CASE WHEN i.DATESET <= TRUNC(SYSDATE)
                    AND i.DATEEND >= TRUNC(SYSDATE)
                   THEN 'Y' ELSE 'N' END  AS "itemValidYn",
              -- PB f_check_item_inventory_hold_yn('M01') 인라인: 'C' 면 보류다.
              ( SELECT CASE WHEN MAX(v.INVENTORY_HOLD) = 'C' THEN 'Y' ELSE 'N' END
                  FROM IM_ITEM_INVENTORY v
                 WHERE v.ITEM_CODE = i.ITEM_CODE
                   AND v.LOCATION_CODE = 'M01'
                   AND v.ORGANIZATION_ID = i.ORGANIZATION_ID ) AS "inventoryHoldYn",
              -- PB f_check_item_barcode_hold_yn 인라인: 'N' 이 아니면 보류다.
              ( SELECT CASE WHEN NVL(MAX(x.HOLDING_YN), 'N') = 'N' THEN 'N' ELSE 'Y' END
                  FROM IM_ITEM_RECEIPT_BARCODE x
                 WHERE x.ITEM_CODE = i.ITEM_CODE
                   AND x.LOT_NO = :lotNo
                   AND x.ORGANIZATION_ID = i.ORGANIZATION_ID ) AS "barcodeHoldYn",
              -- 불량 창고(M02)에 이 롯트가 남아 있나. PB 는 검사만 하고 쓰지 않는다
              -- (파일 머리 6번) — 경고로만 낸다.
              ( SELECT COUNT(*)
                  FROM IM_ITEM_INVENTORY v2
                 WHERE v2.MATERIAL_MFS = :lotNo
                   AND v2.INVENTORY_QTY > 0
                   AND v2.LOCATION_CODE = 'M02'
                   AND v2.ORGANIZATION_ID = i.ORGANIZATION_ID ) AS "badInventoryCount",
              -- 수명주기: 마지막 입고로부터 지난 날수
              ( SELECT TRUNC(SYSDATE - NVL(MAX(v3.LAST_RECEIPT_DATE), MAX(v3.ENTER_DATE)), 0)
                  FROM IM_ITEM_INVENTORY v3
                 WHERE v3.ITEM_CODE = i.ITEM_CODE
                   AND v3.MATERIAL_MFS = :lotNo
                   AND v3.ORGANIZATION_ID = i.ORGANIZATION_ID ) AS "lifeCyclePassed",
              -- 장기재고: 최근 12개월 안에 입고된 재고가 있나 (PB 와 같은 식)
              ( SELECT COUNT(*)
                  FROM IM_ITEM_INVENTORY v4
                 WHERE v4.LAST_RECEIPT_DATE > ADD_MONTHS(TRUNC(SYSDATE), -12)
                   AND v4.ITEM_CODE = i.ITEM_CODE
                   AND v4.MATERIAL_MFS = :lotNo
                   AND v4.ORGANIZATION_ID = i.ORGANIZATION_ID ) AS "recentInventoryCount"
         FROM ID_ITEM i
        WHERE i.ITEM_CODE = :itemCode
          AND i.ORGANIZATION_ID = :organizationId`,
      namedBinds({ itemCode, lotNo, organizationId }),
    )) as Row[])[0] ?? null;

    if (!facts) {
      add('item', '품목 기준정보', 'reject', `품목을 찾을 수 없습니다: ${itemCode}`);
      return {
        barcode: (parsed.clean as string) ?? dto.barcode, itemCode, lotNo,
        item: null, barcodeRow: null, checks,
        issueMode: dto.issueMode ?? 'P', feederLocationCode: null as string | null,
        supplierBarcode: null as string | null, inventoryType: null as string | null, locationCode: 'M01',
        issuable: false, reason: firstReject()?.detail ?? null,
      };
    }

    const ledger = ((await this.dataSource.query(
      `SELECT b.RECEIPT_SLIP_NO                        AS "receiptSlipNo",
              NVL(b.SUPPLIER_CODE, '*')                AS "supplierCode",
              NVL(b.RECEIPT_COMPARE_YN, 'N')           AS "receiptCompareYn",
              NVL(b.ISSUE_COMPARE_YN, 'N')             AS "issueCompareYn",
              NVL(b.ISSUE_RETURN_YN, 'N')              AS "issueReturnYn",
              NVL(b.LABEL_TYPE, 'N')                   AS "labelType",
              b.INVENTORY_TYPE                         AS "inventoryType",
              b.MANUFACTURE_WEEK                       AS "manufactureWeek",
              TO_CHAR(b.MANUFACTURE_DATE, 'YYYY-MM-DD')     AS "manufactureDate",
              TO_CHAR(b.RECEIPT_COMPARE_DATE, 'YYYY-MM-DD') AS "receiptCompareDate",
              TO_CHAR(b.PCB_COATING_DATE, 'YYYY-MM-DD')     AS "pcbCoatingDate",
              b.ITEM_BARCODE                           AS "itemBarcode",
              DECODE(NVL(b.NEW_SCAN_QTY, 0), 0, b.SCAN_QTY, b.NEW_SCAN_QTY) AS "issueQty",
              b.SCAN_QTY                               AS "scanQty",
              CASE WHEN b.BAKING_START_DATE IS NOT NULL
                    AND b.BAKING_END_DATE IS NULL
                   THEN 'Y' ELSE 'N' END               AS "bakingYn",
              -- MSL 등급이 3 이상인 품목만 시간 검사를 한다 (PB msl_level > '2').
              F_GET_MSL_PASSED_TIME(b.ITEM_BARCODE)    AS "mslPassedTime",
              NVL(F_GET_MAT_MSL_MAX_TIME(b.ITEM_CODE), 0) AS "mslMaxTime",
              -- PCB 코팅일이 기간 안인가 (PB 와 같은 DB 함수).
              F_CHECK_PCB_COATING_DATE(b.ITEM_CODE, b.PCB_COATING_DATE, b.ORGANIZATION_ID)
                                                       AS "pcbCoatingOkYn"
         FROM IM_ITEM_RECEIPT_BARCODE b
        WHERE b.ITEM_CODE = :itemCode
          AND b.LOT_NO = :lotNo
          AND b.ORGANIZATION_ID = :organizationId`,
      namedBinds({ itemCode, lotNo, organizationId }),
    )) as Row[])[0] ?? null;

    // ④ 검사를 PB 순서대로 쌓는다.
    add('itemValid', '품목 유효기간',
      String(facts.itemValidYn) === 'Y' ? 'pass' : 'reject',
      String(facts.itemValidYn) === 'Y' ? undefined : '사용 기간이 지난 품목입니다.');

    if (String(facts.ecoCheckYn) === 'Y') {
      add('eco', '4M 변경', 'warn',
        (facts.ecoCheckComments as string) ?? '4M 변경 품목입니다.');
    } else add('eco', '4M 변경', 'pass');

    add('inventoryHold', '재고 보류',
      String(facts.inventoryHoldYn) === 'Y' ? 'reject' : 'pass',
      String(facts.inventoryHoldYn) === 'Y' ? '보류된 재고입니다.' : undefined);

    // PB 는 이 검사를 켜지 못한 상태다 (파일 머리 6번) — 경고로만 낸다.
    add('badInventory', '불량 재고',
      Number(facts.badInventoryCount ?? 0) > 0 ? 'warn' : 'pass',
      Number(facts.badInventoryCount ?? 0) > 0
        ? `불량 창고(M02)에 같은 롯트가 ${facts.badInventoryCount}건 있습니다.`
        : undefined);

    add('barcodeHold', '바코드 보류',
      String(facts.barcodeHoldYn) === 'Y' ? 'reject' : 'pass',
      String(facts.barcodeHoldYn) === 'Y' ? '보류된 바코드입니다.' : undefined);

    // 원라벨(거래처 바코드) — No Origin Barcode 면 찍은 값 뒤에 '-NB' 를 붙인다 (PB 그대로).
    const supplierRaw = dto.noOriginBarcode
      ? `${(dto.supplierBarcode?.trim() || dto.barcode.trim())}-NB`
      : (dto.supplierBarcode?.trim() ?? '');
    let supplierBarcode: string | null = null;
    if (!supplierRaw) {
      add('origin', '원라벨', 'reject', '원라벨(거래처 바코드)을 먼저 찍으세요.');
    } else {
      const sup = ((await this.dataSource.query(
        `SELECT F_GET_PREPARE_SUPPLIER_BARCODE(:supplier)                         AS "clean",
                F_GET_ITEM_CODE_FROM_BARCODE(F_GET_PREPARE_SUPPLIER_BARCODE(:supplier)) AS "itemCode"
           FROM DUAL`,
        namedBinds({ supplier: supplierRaw }),
      )) as Row[])[0] ?? {};
      supplierBarcode = (sup.clean as string) || supplierRaw;
      const ours = (parsed.clean as string) ?? dto.barcode;
      if (config.issueCompare && supplierBarcode === ours) {
        add('origin', '원라벨', 'reject', '같은 바코드를 원라벨 칸에 찍으면 안 됩니다.');
      } else if (config.issueCompare
        && !supplierBarcode.includes(itemCode) && !String(sup.itemCode ?? '').includes(itemCode)) {
        add('origin', '원라벨', 'reject', `원라벨 품목이 일치하지 않습니다 (${supplierBarcode}).`);
      } else add('origin', '원라벨', 'pass', supplierBarcode);
    }

    if (!ledger) {
      add('ledger', '바코드 원장', 'reject', `발행 이력이 없는 바코드입니다: ${itemCode}-${lotNo}`);
    } else {
      add('ledger', '바코드 원장', 'pass', ledger.itemBarcode as string);
      add('slip', '전표번호', ledger.receiptSlipNo ? 'pass' : 'reject',
        ledger.receiptSlipNo ? String(ledger.receiptSlipNo) : '전표번호가 없는 바코드입니다.');
      const qty = Number(ledger.issueQty ?? 0);
      add('qty', '수량', qty > 0 ? 'pass' : 'reject',
        qty > 0 ? qty.toLocaleString() : '수량이 0 이하입니다.');
      add('receiptCompare', '입고대조',
        String(ledger.receiptCompareYn) === 'Y' ? 'pass' : 'reject',
        String(ledger.receiptCompareYn) === 'Y'
          ? undefined
          : '입고대조가 안 된 바코드는 출고할 수 없습니다.');
      // 이 두 검사 **뒤에** FIFO 가 와야 한다 (파일 머리 2번).
      add('issueCompare', '중복 출고',
        String(ledger.issueCompareYn) === 'Y' ? 'reject' : 'pass',
        String(ledger.issueCompareYn) === 'Y' ? '이미 출고된 바코드입니다.' : undefined);
    }

    // ⑤ 켜고 끄는 검사들. 앞에서 이미 거절됐으면 더 보지 않는다 — PB 도 그 자리에서
    // 돌아가므로, 거절 뒤에 엉뚱한 사유가 붙으면 현장이 원인을 잘못 읽는다.
    const rejectedAlready = firstReject() !== null;
    const itemClass = String(facts.itemClass ?? '');

    // PCB 코팅
    if (!on.pcbCoating) add('pcbCoating', 'PCB 코팅', 'skip');
    else if (rejectedAlready || itemClass !== 'PCB') {
      add('pcbCoating', 'PCB 코팅', itemClass === 'PCB' ? 'skip' : 'pass',
        itemClass === 'PCB' ? undefined : 'PCB 품목이 아닙니다.');
    } else {
      const ok = String(ledger?.pcbCoatingOkYn ?? '') === 'Y';
      add('pcbCoating', 'PCB 코팅', ok ? 'pass' : 'reject',
        ok ? String(ledger?.pcbCoatingDate ?? '') : 'PCB 코팅일이 기간을 넘었습니다.');
    }

    // FIFO
    let fifoCount = 0;
    if (!on.fifo) add('fifo', 'FIFO 선입선출', 'skip');
    else if (rejectedAlready || !ledger) add('fifo', 'FIFO 선입선출', 'skip');
    else {
      fifoCount = await this.countFifoViolations(
        { itemCode, lotNo, itemClass, ledger, moqQty: Number(facts.moqQty ?? 0), inventoryType },
        organizationId,
      );
      add('fifo', 'FIFO 선입선출', fifoCount > 0 ? 'reject' : 'pass',
        fifoCount > 0
          ? '먼저 써야 할 릴이 창고에 남아 있습니다. FIFO 목록을 확인하세요.'
          : undefined);
    }

    // 장기재고 (최근 12개월 입고가 없으면 거절 — PB 와 같다)
    if (!on.longTerm) add('longTerm', '장기재고', 'skip');
    else {
      const recent = Number(facts.recentInventoryCount ?? 0);
      add('longTerm', '장기재고', recent > 0 ? 'pass' : 'reject',
        recent > 0 ? undefined : '12개월이 넘은 재고입니다. 품질 확인을 받으세요.');
    }

    // BOM 대조 — 출고 형태별 목록에 찍은 자재가 있어야 한다 (PB 장기재고 다음, MSL 앞).
    // P 는 제품 모델 설계BOM, K 는 SMT 모델·라인·TOP/BOTTOM 피더 BOM. 대체품도 통과한다.
    // 'Model Not Check'(잠금 옵션)면 P 의 BOM 대조를 건너뛴다 (PB cbx_model_not_check).
    const mode: IssueMode = dto.issueMode ?? 'P';
    let bomMatch: IssueBomRow | null = null;
    if (firstReject() !== null) add('bom', 'BOM 대조', 'skip');
    else if (mode === 'P' && dto.modelNotCheck) add('bom', 'BOM 대조', 'skip', 'Model Not Check');
    else {
      const bom = await this.findIssueBom({
        issueMode: mode, modelName: dto.modelName, lineCode: dto.lineCode, topBottom: dto.topBottom,
      }, organizationId);
      bomMatch = bom.find((r) => r.itemCode === itemCode && r.div === 'BOM')
        ?? bom.find((r) => r.itemCode === itemCode) ?? null;
      if (bom.length === 0) {
        add('bom', 'BOM 대조', 'reject', mode === 'P'
          ? `모델 ${dto.modelName} 의 설계BOM 이 없습니다.`
          : `모델 ${dto.modelName} · 라인 ${dto.lineCode} 의 피더 BOM 이 없습니다.`);
      } else if (!bomMatch) {
        add('bom', 'BOM 대조', 'reject', `${itemCode} 는 ${dto.modelName} BOM 에 없는 자재입니다.`);
      } else {
        add('bom', 'BOM 대조', 'pass', bomMatch.div === 'REPLACE'
          ? `대체품 (${bomMatch.replaceFor} 대신)`
          : (bomMatch.feederLocationCode ? `피더 ${bomMatch.feederLocationCode}` : undefined));
      }
    }

    // MSL 시간 (등급 3 이상만)
    if (!on.mslTime) add('msl', 'MSL 시간', 'skip');
    else {
      const level = String(facts.mslLevel ?? '');
      if (!(level > '2')) add('msl', 'MSL 시간', 'pass', `MSL ${level || '없음'}`);
      else {
        const maxTime = Number(ledger?.mslMaxTime ?? 0);
        const passed = Number(ledger?.mslPassedTime ?? 0);
        add('msl', 'MSL 시간', maxTime >= passed ? 'pass' : 'reject',
          maxTime >= passed
            ? `남은 시간 ${Math.round(maxTime - passed)}`
            : 'MSL 허용 시간을 넘었습니다.');
      }
    }

    // 수명주기
    if (!on.lifeCycle) add('lifeCycle', '수명주기', 'skip');
    else {
      const limit = Number(facts.lifeCycle ?? 365);
      const passed = Number(facts.lifeCyclePassed ?? 0);
      add('lifeCycle', '수명주기', passed <= limit ? 'pass' : 'reject',
        passed <= limit
          ? `남은 일수 ${limit - passed}`
          : `수명주기(${limit}일)를 ${passed - limit}일 넘었습니다.`);
    }

    const reject = firstReject();
    return {
      barcode: (parsed.clean as string) ?? dto.barcode,
      itemCode,
      lotNo,
      item: facts,
      barcodeRow: ledger,
      checks,
      fifoCount,
      issueMode: mode,
      // K 는 맞은 피더 BOM 줄의 피더 위치를 쓴다 (PB dw_1.location_code). P 는 없다.
      feederLocationCode: bomMatch?.feederLocationCode ?? null,
      supplierBarcode,
      inventoryType,
      // 출고 원장의 창고는 라벨유형으로 정한다 (PB: R 리볼대기 M06 · B 벌크 M05 · 그 밖 양산 M01).
      locationCode: labelLocation(String(ledger?.labelType ?? 'N')),
      issuable: reject === null,
      reason: reject?.detail ?? null,
    };
  }

  /**
   * FIFO 위반 건수. PB 의 세 갈래를 그대로 옮겼다 (파일 머리 4번).
   *
   * 한 건이라도 있으면 거절이므로 `ROWNUM = 1` 로 끊는다 (PB 와 같다) — 1,902,554행
   * 표를 다 세지 않는다.
   */
  private async countFifoViolations(
    ctx: { itemCode: string; lotNo: string; itemClass: string; ledger: Row; moqQty: number; inventoryType: string },
    organizationId: number,
  ): Promise<number> {
    const { itemCode, lotNo, itemClass, ledger, moqQty, inventoryType } = ctx;

    /** 세 갈래가 공유하는 조건. */
    const common = `AND NVL(b.RECEIPT_COMPARE_YN, 'N') = 'Y'
          AND NVL(b.ISSUE_COMPARE_YN, 'N') = 'N'
          AND NVL(b.LABEL_TYPE, 'N') = 'N'
          AND NVL(b.INVENTORY_TYPE, '*') = NVL(:inventoryType, '*')
          AND b.LOT_NO IN ( SELECT v.MATERIAL_MFS
                              FROM IM_ITEM_INVENTORY v
                             WHERE v.ITEM_CODE = :itemCode
                               AND v.LOCATION_CODE = 'M01'
                               AND v.INVENTORY_QTY > 0
                               AND v.ORGANIZATION_ID = :organizationId )
          -- 베이킹 중인 릴은 꺼낼 수 없으니 순서를 막지 않는다.
          AND NOT (b.BAKING_START_DATE IS NOT NULL AND b.BAKING_END_DATE IS NULL)
          AND b.ORGANIZATION_ID = :organizationId
          AND ROWNUM = 1`;

    const count = async (extra: string, binds: Record<string, unknown>) => {
      const rows = (await this.dataSource.query(
        `SELECT COUNT(*) AS "cnt"
           FROM IM_ITEM_RECEIPT_BARCODE b
          WHERE b.ITEM_CODE = :itemCode
            ${extra}
          ${common}`,
        namedBinds({ itemCode, inventoryType, organizationId, ...binds }),
      )) as Row[];
      return Number(rows[0]?.cnt ?? 0);
    };

    // 갈래 1 — PCB: 제조주차가 더 이른 릴이 남아 있으면 거절.
    if (itemClass === 'PCB') {
      return count(
        `AND b.LOT_NO <> :lotNo
          AND b.MANUFACTURE_WEEK < :manufactureWeek`,
        { lotNo, manufactureWeek: (ledger.manufactureWeek as string) ?? null },
      );
    }

    const scanQty = Number(ledger.scanQty ?? 0);
    const compareDate = (ledger.receiptCompareDate as string) ?? null;

    // 갈래 2 — MOQ 보다 적게 남은 릴을 찍었다: 제조일이 더 이른 잔량 릴이 있으면 거절.
    if (moqQty > scanQty && moqQty > 0) {
      return count(
        `AND b.LOT_NO <> :lotNo
          AND NVL(b.REEL_DESTROY_YN, 'N') = 'N'
          AND TRUNC(b.MANUFACTURE_DATE) < TRUNC(TO_DATE(:compareDate, 'YYYY-MM-DD'))
          AND b.SCAN_QTY < :moqQty`,
        { lotNo, compareDate, moqQty },
      );
    }

    // 갈래 3 — 그 밖: 먼저 잔량 릴을 보고, 없으면 제조일이 더 이른 릴을 본다.
    if (moqQty > 0) {
      const remnant = await count(
        `AND NVL(b.REEL_DESTROY_YN, 'N') = 'N'
          AND b.SCAN_QTY < :moqQty`,
        { moqQty },
      );
      if (remnant > 0) return remnant;
    }
    return count(
      `AND b.LOT_NO <> :lotNo
          AND NVL(b.REEL_DESTROY_YN, 'N') = 'N'
          AND TRUNC(b.MANUFACTURE_DATE) < TRUNC(TO_DATE(:compareDate, 'YYYY-MM-DD'))`,
      { lotNo, compareDate },
    );
  }

  // ───────────────────────────────── 출고대조 (쓰기)

  /**
   * 출고대조 + 출고 기록 (**쓰기**). PB `wf_issue_barcode('N')` 에 대응한다.
   *
   * 판정은 `evaluateScan` 을 **다시 불러서** 한다 — 화면을 우회할 수 있고, 미리 본
   * 시점과 실제 출고 시점 사이에 FIFO·MSL 상황이 바뀔 수 있다.
   */
  async issueBarcode(dto: BarcodeIssueDto, organizationId: number, userId: string) {
    const verdict = await this.evaluateScan(dto, organizationId);
    if (!verdict.issuable) {
      throw new BadRequestException(verdict.reason ?? '출고할 수 없는 바코드입니다.');
    }
    const ledger = verdict.barcodeRow as Row;
    const facts = verdict.item as Row;
    const issueQty = Number(ledger.issueQty ?? 0);

    return this.tx.run(async (qr) => {
      // **중복 출고를 문장 안에서 막는다** — 같은 릴을 두 사람이 동시에 찍어도
      // 한쪽만 1행을 바꾼다 (237·250 과 같은 관용구).
      const updated = await qr.query(
        `UPDATE IM_ITEM_RECEIPT_BARCODE
            SET ISSUE_COMPARE_YN   = 'Y',
                ISSUE_COMPARE_DATE = SYSDATE,
                ISSUE_COMPARE_BY   = :userId,
                ISSUE_RETURN_YN    = 'N',
                LINE_CODE          = :lineCode,
                FEEDING_MODEL      = :modelName,
                WORKSTAGE_CODE     = :workstageCode,
                LOCATION_CODE      = :feederLocationCode,
                FEEDING_YN         = 'N',
                FEEDING_DATE       = NULL,
                LAST_MODIFY_DATE   = SYSDATE,
                LAST_MODIFY_BY     = :userId
          WHERE LOT_NO = :lotNo
            AND ITEM_CODE = :itemCode
            AND ORGANIZATION_ID = :organizationId
            AND NVL(ISSUE_COMPARE_YN, 'N') <> 'Y'
            AND NVL(RECEIPT_COMPARE_YN, 'N') = 'Y'`,
        namedBinds({
          userId,
          lineCode: dto.lineCode.trim(),
          modelName: dto.modelName.trim(),
          workstageCode: dto.workstageCode.trim(),
          feederLocationCode: verdict.feederLocationCode,
          lotNo: verdict.lotNo,
          itemCode: verdict.itemCode,
          organizationId,
        }),
      );
      const barcodeRows = Number(
        affectedRows(updated) ?? 0,
      );
      if (barcodeRows !== 1) {
        throw new BadRequestException(
          '출고 대상이 아닙니다 (이미 출고됐거나 입고대조가 안 된 바코드).',
        );
      }

      const inserted = await qr.query(
        `INSERT INTO IM_ITEM_ISSUE
           (ITEM_CODE, ISSUE_DATE, ISSUE_SEQUENCE, ORGANIZATION_ID,
            MFS, LOCATION_CODE, ITEM_TYPE, LINE_CODE, WORKSTAGE_CODE,
            ISSUE_DEFICIT, ISSUE_QTY, ISSUE_STATUS, ISSUE_AMT, ISSUE_ACCOUNT,
            LINE_TYPE, COMMENTS, ISSUE_PRICE, VIRTUAL_RECEIPT_YN, ISSUE_TYPE,
            SUPPLIER_CODE, WORK_ORDER_NO,
            ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY,
            MACHINE_CODE, INVOICE_NO, MADE_BY, PARENT_ITEM_CODE, MATERIAL_MFS,
            CLOSE_YN, BARCODE, ORIGIN_MFS, FEEDER_LOCATION_CODE,
            ISSUE_DIVISION, MODEL_NAME, INVENTORY_TYPE, MSL_PASSED_TIME)
         VALUES
           (:itemCode, TRUNC(SYSDATE), SEQ_MAT_ISSUE.NEXTVAL, :organizationId,
            NVL(:mfs, '*'), :locationCode, '${FIXED.itemType}', :lineCode,
            :workstageCode,
            ${FIXED.issueDeficit}, :issueQty, '${FIXED.issueStatus}', 0,
            '${FIXED.issueAccount}',
            :lineType, NULL, 0, NULL, '${FIXED.issueType}',
            :supplierCode, '${FIXED.workOrderNo}',
            SYSDATE, :userId, SYSDATE, :userId,
            '${FIXED.machineCode}', :receiptSlipNo, NULL,
            '${FIXED.parentItemCode}', :lotNo,
            '${FIXED.closeYn}', :barcode, :supplierBarcode, :feederLocationCode,
            :issueDivision, :modelName, :inventoryType,
            F_GET_MSL_PASSED_TIME(:barcode))`,
        namedBinds({
          itemCode: verdict.itemCode,
          organizationId,
          mfs: dto.mfs?.trim() || null,
          locationCode: verdict.locationCode,
          lineCode: dto.lineCode.trim(),
          workstageCode: dto.workstageCode.trim(),
          issueQty,
          lineType: (facts.lineType as string) ?? null,
          supplierCode: (ledger.supplierCode as string) ?? null,
          userId,
          receiptSlipNo: (ledger.receiptSlipNo as string) ?? null,
          lotNo: verdict.lotNo,
          barcode: verdict.barcode,
          supplierBarcode: verdict.supplierBarcode,
          feederLocationCode: verdict.feederLocationCode,
          // 출고 형태가 곧 출고구분이다 (PB `LVS_ISSUE_DIVISION` P·K).
          issueDivision: verdict.issueMode,
          modelName: dto.modelName.trim(),
          inventoryType: verdict.inventoryType,
        }),
      );

      return {
        barcode: verdict.barcode,
        itemCode: verdict.itemCode,
        lotNo: verdict.lotNo,
        issueQty,
        lineCode: dto.lineCode.trim(),
        workstageCode: dto.workstageCode.trim(),
        modelName: dto.modelName.trim(),
        issueDivision: verdict.issueMode,
        feederLocationCode: verdict.feederLocationCode,
        warnings: verdict.checks.filter((c) => c.result === 'warn'),
        barcodeRows,
        issueRows: Number(affectedRows(inserted) ?? 0),
      };
    });
  }

  // ───────────────────────────────── 출고반품 (PB Process · Mass Issue Return 묶음)

  /**
   * 반품할 바코드를 풀어 본다 (읽기 전용) — PB `sle_our_barcode_return` modified 이벤트.
   *
   *   · 폐기된 라벨 · 챔버(베이킹/진공/제습)에 들어가 있는 릴은 막는다.
   *   · Mass Return: 라벨유형으로 창고를 정한다 (N 양산 M01 · R 리볼 M06 · B 벌크 M05).
   *     Bad 면 불량 창고 M02, N·R 라벨은 현장불량 라인 28 로 간다.
   *   · 양품 Mass Return 은 전표·출고 이력이 있어야 하고, 라인은 그 롯트가 마지막으로
   *     나간 라인이다 (Line Manual Check 면 입력한 라인).
   */
  async lookupReturn(dto: BarcodeIssueReturnLookupDto, organizationId: number) {
    const barcode = dto.barcode.trim();
    const bad = dto.bad ?? false;
    const fail = (reason: string, extra: Record<string, unknown> = {}) => ({
      itemCode: null, lotNo: null, barcodeRow: null, labelType: null, locationCode: null,
      lineCode: null, currentQty: null, returnable: false, reason, ...extra,
    });
    if (barcode.length < 7) return fail('바코드 형식이 올바르지 않습니다.');

    const parsed = ((await this.dataSource.query(
      `SELECT F_GET_ITEM_CODE_FROM_BARCODE(:barcode) AS "itemCode",
              F_GET_LOT_NO_FROM_BARCODE(:barcode)    AS "lotNo"
         FROM DUAL`,
      namedBinds({ barcode }),
    )) as Row[])[0] ?? {};
    const itemCode = (parsed.itemCode as string) || '';
    const lotNo = (parsed.lotNo as string) || '';
    if (!itemCode) return fail('품목 마스터에 없는 바코드입니다.');
    const item = ((await this.dataSource.query(
      `SELECT ITEM_NAME AS "itemName", ITEM_SPEC AS "itemSpec",
              CASE WHEN DATESET <= TRUNC(SYSDATE) AND DATEEND >= TRUNC(SYSDATE) THEN 'Y' ELSE 'N' END AS "validYn"
         FROM ID_ITEM WHERE ITEM_CODE = :itemCode AND ORGANIZATION_ID = :organizationId`,
      namedBinds({ itemCode, organizationId }),
    )) as Row[])[0];
    if (!item || String(item.validYn) !== 'Y') return fail(`품목 마스터에 없는 품목입니다: ${itemCode}`, { itemCode });
    if (!lotNo) return fail('롯트번호가 올바르지 않습니다.', { itemCode });

    const row = ((await this.dataSource.query(
      `SELECT b.RECEIPT_SLIP_NO                     AS "receiptSlipNo",
              NVL(b.ISSUE_COMPARE_YN, 'N')          AS "issueCompareYn",
              NVL(b.ISSUE_RETURN_YN, 'N')           AS "issueReturnYn",
              NVL(b.LABEL_TYPE, 'N')                AS "labelType",
              DECODE(NVL(b.NEW_SCAN_QTY, 0), 0, b.SCAN_QTY, b.NEW_SCAN_QTY) AS "currentQty",
              b.INVENTORY_TYPE                      AS "inventoryType",
              NVL(b.REEL_DESTROY_YN, 'N')           AS "reelDestroyYn",
              b.ITEM_BARCODE                        AS "itemBarcode"
         FROM IM_ITEM_RECEIPT_BARCODE b
        WHERE b.ITEM_CODE = :itemCode AND b.LOT_NO = :lotNo AND b.ORGANIZATION_ID = :organizationId`,
      namedBinds({ itemCode, lotNo, organizationId }),
    )) as Row[])[0] ?? null;
    const base = {
      itemCode, lotNo,
      barcodeRow: row ? { ...row, itemName: item.itemName, itemSpec: item.itemSpec } : null,
      currentQty: row ? Number(row.currentQty ?? 0) : null,
    };
    if (row && String(row.reelDestroyYn) !== 'N') {
      return fail(`이미 폐기된 라벨입니다 (${row.reelDestroyYn}).`, base);
    }
    const chamber = ((await this.dataSource.query(
      `SELECT COUNT(*) AS "cnt",
              DECODE(MAX(CHAMBER_TYPE), 'B', '베이킹', 'V', '진공포장', 'D', '제습함', MAX(CHAMBER_TYPE)) AS "type"
         FROM IM_ITEM_BAKING_MASTER
        WHERE LOT_NO = :lotNo AND INPUT_SCAN_DATE IS NOT NULL AND OUTPUT_SCAN_DATE IS NULL`,
      namedBinds({ lotNo }),
    )) as Row[])[0] ?? {};
    if (Number(chamber.cnt ?? 0) > 0) return fail(`${chamber.type} 위치에 입고 중입니다.`, base);

    const labelType = String(row?.labelType ?? 'N') || 'N';
    if (!['N', 'R', 'B'].includes(labelType)) {
      return fail(`선택 유형이 잘못 되었습니다 (라벨유형 ${labelType}).`, { ...base, labelType });
    }
    const locationCode = bad ? 'M02' : labelLocation(labelType);
    let lineCode: string | null = bad && labelType !== 'B' ? '28' : null;

    if (!bad) {
      if (!row?.receiptSlipNo) return fail('바코드 정보가 생성되어 있지 않습니다.', { ...base, labelType, locationCode });
      if (String(row.issueCompareYn) !== 'Y') {
        return fail('이미 반품된 자재이거나 출고 이력이 없습니다.', { ...base, labelType, locationCode });
      }
      if (dto.lineManual) lineCode = dto.lineCode?.trim() || null;
      else {
        const last = (await this.dataSource.query(
          `SELECT MAX(s.LINE_CODE) AS "lineCode"
             FROM IM_ITEM_ISSUE s
            WHERE s.ITEM_CODE = :itemCode AND s.MATERIAL_MFS = :lotNo
              AND s.ISSUE_DEFICIT = '3' AND s.ISSUE_ACCOUNT <> 'M009'
              AND s.ENTER_DATE = ( SELECT MAX(x.ENTER_DATE) FROM IM_ITEM_ISSUE x
                                    WHERE x.ITEM_CODE = :itemCode AND x.MATERIAL_MFS = :lotNo
                                      AND x.ISSUE_DEFICIT = '3' AND x.ISSUE_ACCOUNT <> 'M009' )`,
          namedBinds({ itemCode, lotNo }),
        )) as Row[];
        const found = String(last[0]?.lineCode ?? '');
        if (!found || found === '*' || found === '%') {
          return fail(`${itemCode} ${lotNo} 의 최종 라인을 알 수 없습니다. Line Manual Check 로 넣으세요.`,
            { ...base, labelType, locationCode });
        }
        lineCode = found;
      }
    } else if (!lineCode) lineCode = dto.lineCode?.trim() || null;

    return {
      ...base, labelType, locationCode, lineCode,
      returnable: Boolean(lineCode),
      reason: lineCode ? null : '라인이 올바르지 않습니다.',
    };
  }

  /**
   * 출고반품 (**쓰기**) — PB `sle_return_qty` modified 이벤트.
   *
   *   양품 Mass Return: ① 바코드 원장을 되돌리고(수량·바코드 재생성) ② 마이너스 출고
   *   ③ 로스(반품 수량 − 반품 전 릴 수량)를 남긴다. 새 라벨을 붙인다 (Auto Print).
   *   Bad: 원장은 그대로 두고 불량 창고(M02)로 마이너스 출고만 넣는다. 롯트 자리에
   *   품목코드, 바코드는 `품목-YYMMDD+순번-수량`, 전표는 Invoice(비우면 채번) — PB 그대로.
   *
   * 판정은 `lookupReturn` 을 다시 불러서 한다. 쓰기는 한 트랜잭션이다.
   */
  async returnBarcode(dto: BarcodeIssueReturnDto, organizationId: number, userId: string) {
    const qty = Number(dto.returnQty);
    if (!Number.isFinite(qty) || qty <= 0) throw new BadRequestException('반품 수량이 올바르지 않습니다.');
    const look = await this.lookupReturn(dto, organizationId);
    if (!look.returnable || !look.itemCode || !look.lineCode) {
      throw new BadRequestException(look.reason ?? '반품할 수 없는 바코드입니다.');
    }
    const info = look.barcodeRow as Row;
    const bad = dto.bad ?? false;
    const itemCode = look.itemCode;
    const lineCode = look.lineCode;
    const modelName = dto.modelName?.trim() || null;
    const inventoryType = (info?.inventoryType as string) ?? null;

    return this.tx.run(async (qr) => {
      if (!bad) {
        const lotNo = look.lotNo as string;
        const updated = await qr.query(
          `UPDATE IM_ITEM_RECEIPT_BARCODE
              SET ISSUE_COMPARE_YN        = 'N',
                  ISSUE_COMPARE_DATE      = NULL,
                  ISSUE_COMPARE_BY        = NULL,
                  SUPPLIER_BARCODE        = '*',
                  ISSUE_RETURN_YN         = 'Y',
                  ISSUE_RETURN_DATE       = SYSDATE,
                  SCAN_QTY                = :qty,
                  LAST_SCAN_QTY           = SCAN_QTY,
                  LAST_ISSUE_COMPARE_DATE = ISSUE_COMPARE_DATE,
                  LAST_ISSUE_COMPARE_BY   = ISSUE_COMPARE_BY,
                  ITEM_BARCODE            = :itemCode || '-' || :lotNo || '-' || :qty,
                  FEEDING_YN              = 'N',
                  NEW_SCAN_QTY            = 0,
                  LAST_MODIFY_BY          = :userId,
                  LAST_MODIFY_DATE        = SYSDATE
            WHERE ITEM_CODE = :itemCode AND LOT_NO = :lotNo AND ORGANIZATION_ID = :organizationId
              AND NVL(ISSUE_COMPARE_YN, 'N') = 'Y'`,
          namedBinds({ qty, itemCode, lotNo, userId, organizationId }),
        );
        if (Number(affectedRows(updated) ?? 0) !== 1) {
          throw new BadRequestException('반품 대상이 아닙니다 (이미 반품됐거나 출고되지 않은 바코드).');
        }
        const issued = await qr.query(
          `INSERT INTO IM_ITEM_ISSUE
             (ITEM_CODE, ISSUE_DATE, ISSUE_SEQUENCE, ORGANIZATION_ID, MFS, LOCATION_CODE, ITEM_TYPE,
              LINE_CODE, WORKSTAGE_CODE, ISSUE_DEFICIT, ISSUE_QTY, ISSUE_STATUS, ISSUE_AMT, ISSUE_ACCOUNT,
              LINE_TYPE, COMMENTS, ISSUE_PRICE, VIRTUAL_RECEIPT_YN, ISSUE_TYPE, SUPPLIER_CODE, WORK_ORDER_NO,
              ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY, MACHINE_CODE, INVOICE_NO, MADE_BY,
              PARENT_ITEM_CODE, MATERIAL_MFS, CLOSE_YN, BARCODE, MODEL_NAME, INVENTORY_TYPE, MSL_PASSED_TIME)
           VALUES
             (:itemCode, TRUNC(SYSDATE), SEQ_MAT_ISSUE.NEXTVAL, :organizationId, '*', :locationCode, 'T',
              :lineCode, '*', 4, :qty * -1, 'N', 0, 'M001',
              F_GET_LINE_TYPE_FROM_ITEM(:itemCode, :organizationId), NULL, 0, NULL, 'N', '*', '*',
              SYSDATE, :userId, SYSDATE, :userId, '*', :slipNo, NULL,
              '*', :lotNo, 'N', :barcode, :modelName, :inventoryType, F_GET_MSL_PASSED_TIME(:barcode))`,
          namedBinds({
            itemCode, organizationId, locationCode: look.locationCode, lineCode, qty, userId,
            slipNo: (info.receiptSlipNo as string) ?? null, lotNo, barcode: dto.barcode.trim(),
            modelName, inventoryType,
          }),
        );
        // 로스 = 반품 수량 − 반품 전 릴 수량 (PB: lvl_issue_qty - lvl_new_scan_qty)
        const before = Number(look.currentQty ?? 0);
        const loss = await qr.query(
          `INSERT INTO IM_ITEM_ISSUE_LOSS
             (ISSUE_DATE, ISSUE_SEQUENCE, ITEM_CODE, MATERIAL_MFS, MODEL_NAME, LINE_CODE, ISSUE_QTY,
              ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY, ORGANIZATION_ID, SCAN_QTY)
           VALUES
             (SYSDATE, SEQ_MAT_ISSUE.NEXTVAL, :itemCode, :lotNo, :modelName, :lineCode, :lossQty,
              SYSDATE, :userId, SYSDATE, :userId, :organizationId, :before)`,
          namedBinds({ itemCode, lotNo, modelName, lineCode, lossQty: qty - before, userId, organizationId, before }),
        );
        return {
          bad, itemCode, lotNo, lineCode, locationCode: look.locationCode, returnQty: qty,
          lossQty: qty - before, previousQty: before,
          newBarcode: `${itemCode}-${lotNo}-${qty}`,
          receiptSlipNo: (info.receiptSlipNo as string) ?? null,
          issueRows: Number(affectedRows(issued) ?? 0), lossRows: Number(affectedRows(loss) ?? 0),
        };
      }

      // Bad — 불량 창고로 마이너스 출고만 넣는다 (원장은 그대로).
      const seqRow = ((await qr.query(
        `SELECT SEQ_MATERIAL_BARCODE.NEXTVAL AS "seq", TO_CHAR(SYSDATE, 'YYMMDD') AS "ymd" FROM DUAL`,
      )) as Row[])[0];
      const seq = Number(seqRow.seq);
      const slipNo = dto.invoiceNo?.trim() || String(seq);
      const newBarcode = `${itemCode}-${seqRow.ymd}${String(seq).padStart(5, '0')}-${qty}`;
      const labelType = String(look.labelType ?? 'N');
      const issued = await qr.query(
        `INSERT INTO IM_ITEM_ISSUE
           (ITEM_CODE, ISSUE_DATE, ISSUE_SEQUENCE, ORGANIZATION_ID, MFS, LOCATION_CODE, ITEM_TYPE,
            LINE_CODE, WORKSTAGE_CODE, ISSUE_DEFICIT, ISSUE_QTY, ISSUE_STATUS, ISSUE_AMT, ISSUE_ACCOUNT,
            LINE_TYPE, COMMENTS, ISSUE_PRICE, VIRTUAL_RECEIPT_YN, ISSUE_TYPE, SUPPLIER_CODE, WORK_ORDER_NO,
            ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY, MACHINE_CODE, INVOICE_NO, MADE_BY,
            PARENT_ITEM_CODE, MATERIAL_MFS, CLOSE_YN, BARCODE, MODEL_NAME, INVENTORY_TYPE)
         VALUES
           (:itemCode, TRUNC(SYSDATE), SEQ_MAT_ISSUE.NEXTVAL, :organizationId, '*', :locationCode, 'T',
            :lineCode, '*', 4, :qty * -1, 'N', 0, 'M001',
            F_GET_LINE_TYPE_FROM_ITEM(:itemCode, :organizationId), :labelType, 0, NULL, :labelType, '*', '*',
            SYSDATE, :userId, SYSDATE, :userId, '*', NVL(:slipNo, :itemCode), NULL,
            '*', :itemCode, 'N', :newBarcode, :modelName, :inventoryType)`,
        namedBinds({
          itemCode, organizationId, locationCode: look.locationCode, lineCode, qty, labelType,
          userId, slipNo, newBarcode, modelName, inventoryType,
        }),
      );
      return {
        bad, itemCode, lotNo: itemCode, lineCode, locationCode: look.locationCode, returnQty: qty,
        lossQty: 0, previousQty: Number(look.currentQty ?? 0), newBarcode, receiptSlipNo: slipNo,
        issueRows: Number(affectedRows(issued) ?? 0), lossRows: 0,
      };
    });
  }

  /**
   * 반품 뒤 붙일 릴 라벨 내용 — PB `d_mat_receipt_lot_barcode_rpt` (Auto Print).
   */
  async findReelLabel(itemCode: string, lotNo: string, organizationId: number) {
    return (await this.dataSource.query(
      `SELECT b.ITEM_CODE                AS "itemCode",
              b.ITEM_BARCODE             AS "itemBarcode",
              b.LOT_NO                   AS "lotNo",
              b.SCAN_QTY                 AS "scanQty",
              i.ITEM_NAME                AS "itemName",
              i.ITEM_SPEC                AS "itemSpec",
              i.MSL_LEVEL                AS "mslLevel",
              i.LOCATION_ADDRESS         AS "locationAddress",
              b.SUPPLIER_CODE            AS "supplierCode",
              b.LABEL_TYPE               AS "labelType",
              b.RECEIPT_TYPE             AS "receiptType",
              TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI') AS "printDate"
         FROM IM_ITEM_RECEIPT_BARCODE b
         LEFT JOIN ID_ITEM i ON i.ITEM_CODE = b.ITEM_CODE AND i.ORGANIZATION_ID = b.ORGANIZATION_ID
        WHERE b.ITEM_CODE = :itemCode AND b.LOT_NO = :lotNo
          AND NVL(b.BARCODE_STATUS, '*') <> 'C' AND b.ORGANIZATION_ID = :organizationId`,
      namedBinds({ itemCode, lotNo, organizationId }),
    )) as Row[];
  }

  // ───────────────────────────────── 출고 취소 (PB Cancel Issue → w_mat_issue_cancel_4_barcode_popup)

  /**
   * 취소할 출고를 찾는다 (읽기 전용). 출고된(ISSUE_COMPARE_YN='Y') 바코드여야 하고,
   * 취소 대상은 그 롯트의 가장 늦게 등록된 살아 있는 출고(ISSUE_DEFICIT 3 · 'C' 아님)다 — PB 그대로.
   */
  async lookupCancel(dto: BarcodeIssueCancelDto, organizationId: number) {
    const barcode = dto.barcode.trim();
    const parsed = ((await this.dataSource.query(
      `SELECT F_GET_ITEM_CODE_FROM_BARCODE(:barcode) AS "itemCode",
              F_GET_LOT_NO_FROM_BARCODE(:barcode)    AS "lotNo"
         FROM DUAL`,
      namedBinds({ barcode }),
    )) as Row[])[0] ?? {};
    const itemCode = (parsed.itemCode as string) || '';
    const lotNo = (parsed.lotNo as string) || '';
    const fail = (reason: string) => ({ itemCode: itemCode || null, lotNo: lotNo || null, issue: null, cancelable: false, reason });
    if (!itemCode) return fail('품목을 찾을 수 없는 바코드입니다.');
    if (!lotNo) return fail('롯트번호가 올바르지 않습니다.');

    const issued = ((await this.dataSource.query(
      `SELECT COUNT(*) AS "cnt" FROM IM_ITEM_RECEIPT_BARCODE
        WHERE ITEM_CODE = :itemCode AND LOT_NO = :lotNo AND ISSUE_COMPARE_YN = 'Y'
          AND ORGANIZATION_ID = :organizationId`,
      namedBinds({ itemCode, lotNo, organizationId }),
    )) as Row[])[0];
    if (Number(issued?.cnt ?? 0) === 0) return fail('출고된 바코드가 아닙니다.');

    const issue = ((await this.dataSource.query(
      `SELECT TO_CHAR(s.ISSUE_DATE, 'YYYY-MM-DD') AS "issueDate",
              s.ISSUE_SEQUENCE                    AS "issueSequence",
              s.ISSUE_QTY                         AS "issueQty",
              s.LINE_CODE                         AS "lineCode",
              s.WORKSTAGE_CODE                    AS "workstageCode",
              s.MODEL_NAME                        AS "modelName",
              s.ISSUE_DIVISION                    AS "issueDivision",
              TO_CHAR(s.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "enterDate",
              s.ENTER_BY                          AS "enterBy",
              i.ITEM_NAME                         AS "itemName"
         FROM IM_ITEM_ISSUE s
         LEFT JOIN ID_ITEM i ON i.ITEM_CODE = s.ITEM_CODE AND i.ORGANIZATION_ID = s.ORGANIZATION_ID
        WHERE s.MATERIAL_MFS = :lotNo AND s.ITEM_CODE = :itemCode
          AND s.ISSUE_STATUS <> 'C' AND s.ISSUE_DEFICIT = '3'
          AND s.ENTER_DATE = ( SELECT MAX(x.ENTER_DATE) FROM IM_ITEM_ISSUE x
                                WHERE x.MATERIAL_MFS = :lotNo AND x.ITEM_CODE = :itemCode
                                  AND x.ISSUE_STATUS <> 'C' AND x.ISSUE_DEFICIT = '3'
                                  AND x.ORGANIZATION_ID = :organizationId )
          AND s.ORGANIZATION_ID = :organizationId
          AND ROWNUM = 1`,
      namedBinds({ itemCode, lotNo, organizationId }),
    )) as Row[])[0] ?? null;
    if (!issue) return fail('취소할 출고 이력이 없습니다.');
    return { itemCode, lotNo, issue, cancelable: true, reason: null };
  }

  /**
   * 출고 취소 (**쓰기**) — 한 트랜잭션: ① 바코드 원장을 출고 전으로 (ISSUE_COMPARE_YN 'N' ·
   * 반품표시 'Y', PB 그대로) ② 그 출고를 역분개 (258 출고취소와 같은 `cancelIssue`).
   */
  async cancelBarcode(dto: BarcodeIssueCancelDto, organizationId: number, userId: string) {
    const look = await this.lookupCancel(dto, organizationId);
    if (!look.cancelable || !look.issue) throw new BadRequestException(look.reason ?? '취소할 수 없는 바코드입니다.');
    const issue = look.issue as Row;
    return this.tx.run(async (qr) => {
      const updated = await qr.query(
        `UPDATE IM_ITEM_RECEIPT_BARCODE
            SET ISSUE_COMPARE_YN = 'N', ISSUE_COMPARE_DATE = NULL, ISSUE_RETURN_YN = 'Y',
                LAST_MODIFY_BY = :userId, LAST_MODIFY_DATE = SYSDATE
          WHERE ITEM_CODE = :itemCode AND LOT_NO = :lotNo AND ISSUE_COMPARE_YN = 'Y'
            AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ userId, itemCode: look.itemCode, lotNo: look.lotNo, organizationId }),
      );
      if (Number(affectedRows(updated) ?? 0) !== 1) {
        throw new BadRequestException('출고된 바코드가 아닙니다 (이미 취소·반품된 바코드).');
      }
      const today = ((await qr.query(`SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') AS "d" FROM DUAL`)) as Row[])[0].d as string;
      const canceled = await this.issueManage.cancelIssue({
        issueDate: issue.issueDate as string,
        issueSequence: Number(issue.issueSequence),
        cancelDate: today,
      }, organizationId, userId, qr);
      return { barcode: dto.barcode.trim(), itemCode: look.itemCode, lotNo: look.lotNo, ...canceled };
    });
  }
}
