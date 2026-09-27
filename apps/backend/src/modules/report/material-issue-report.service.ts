/**
 * @file src/modules/report/material-issue-report.service.ts
 * @description 자재 출고 계열 리포트 3화면
 *              365 w_mat_issue_report                  자재출고리포트
 *              366 w_mat_issue_sum_report              자재출고합계리포트
 *              367 w_mat_location_address_move_report  자재랙이동리포트
 *
 * 초보자 가이드:
 * 1. **365 상세의 기간 컬럼은 ENTER_DATE 다** (출고일 ISSUE_DATE 가 아니다 — PB 그대로).
 *    등록 시각 기준이라 뒤늦게 입력한 출고가 등록일에 잡힌다.
 *    ENTER_DATE 에는 인덱스가 없어 7일 조회가 1.77s 이고 구간을 좁혀도 빨라지지
 *    않는다 (전체 261만행 스캔 — 실측). ISSUE_DATE 로 바꾸면 인덱스를 타지만
 *    전체 262만건 중 두 날짜의 날짜부가 다른 건이 348건, 최대 650일 차이라
 *    그 건들이 조용히 빠진다. **정확성을 택해 PB 정의를 유지한다.**
 * 2. **합계·매트릭스는 ISSUE_DATE 로 집계한다** (PB 도 그렇다). PK 선두라 빠르다
 *    (31일치 0.05s — 실측).
 * 3. **PB 고정조건 `ISSUE_STATUS <> 'C'`** 를 합계에서 빠뜨리면 취소된 출고가
 *    합계에 섞인다.
 * 4. **품목·협력사 마스터는 외부조인이다** (PB 합계 SQL 이 `(+)` 를 쓴다).
 *    30일치에서 품목마스터 없는 출고가 2건 있다 (실측) — 내부조인이면 사라진다.
 * 5. **풀체크 시각은 목록에 넣지 않는다.** PB 는 출고 한 줄마다 "이 자재가 라인에서
 *    마지막으로 스캔된 시각" 을 상관 서브쿼리로 붙였는데, 그 LIKE 의 접두어가
 *    바인드가 아니라 **컬럼 연결식**(`품목||'-'||롯트||'%'`)이라 Oracle 이 인덱스
 *    range scan 을 쓸 수 없다. 행마다 312만행을 훑어 **1만행에 367초** 가 걸린다
 *    (실측 — 단가 함수만 붙이면 같은 1만행이 4.00s 다).
 *    그래서 목록에서는 빼고 **행을 고르면 그 한 건만** 조회한다
 *    (`findFullCheckDate`). 같은 값을 얻으면서 한 건은 즉시 나온다.
 * 6. **단가는 컬럼이 아니라 DB 함수가 계산한다** (`F_GET_MAT_MAX_UNIT_PRICE_CFM`).
 *    TypeScript 로 다시 쓰면 PB 와 금액이 갈리므로 그대로 호출한다.
 * 7. **367 이 읽는 IM_ITEM_LOCATION_MOVE_HIST 는 0행이다** (실측).
 *    화면은 동작하지만 볼 것이 없다 — 은성이 랙 이동을 기록하지 않는다.
 * 8. **365 미출고 탭이 읽는 IM_ITEM_WORK_ORDER 도 0행이다** (실측).
 */
import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { likePrefix } from '@smt/shared';
import { limited, ROW_LIMIT } from './report-rows';
import {
  MaterialIssueReportQueryDto,
  MaterialIssueSumQueryDto,
  MaterialRackMoveQueryDto,
  SmtCheckBarcodeQueryDto,
} from './material-report.dto';

type Row = Record<string, unknown>;

/** PB 고정조건: 취소된 출고는 리포트에서 뺀다. */
const ISSUE_CANCELED = 'C';

@Injectable()
export class MaterialIssueReportService {
  constructor(private readonly dataSource: DataSource) {}

  /** 종료일 하루가 통째로 빠지지 않게 `< 종료일 + 1` 로 건다 (PB between 의 결함). */
  private dateWhere(column: string) {
    return `${column} >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
        AND ${column} <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1`;
  }

  // ───────────────────────────────── 365 자재출고리포트

  private issueBinds(query: MaterialIssueReportQueryDto, organizationId: number) {
    return {
      dateFrom: query.dateFrom,
      dateTo: query.dateTo,
      itemCode: likePrefix(query.itemCode),
      lineCode: likePrefix(query.lineCode),
      materialMfs: likePrefix(query.materialMfs),
      mfs: likePrefix(query.mfs),
      abcGrade: likePrefix(query.abcGrade),
      locationCode: likePrefix(query.locationCode),
      organizationId,
    };
  }

  /**
   * 출고 상세.
   *
   * **풀체크 시각은 여기서 붙이지 않는다** — 1만행에 367초가 걸린다 (파일 머리 5번).
   * 행을 고르면 `findFullCheckDate` 로 그 한 건만 조회한다.
   *
   * @param withMinPrice PB 간이 DataWindow 처럼 단가 하한을 걸지. 단가는 DB 함수가
   *                     계산하므로 이 조건은 인덱스와 무관하다 (모든 행에 함수가 돈다).
   */
  async findIssueDetail(
    query: MaterialIssueReportQueryDto,
    organizationId: number,
    withMinPrice = false,
  ) {
    const unitPrice =
      `F_GET_MAT_MAX_UNIT_PRICE_CFM(g.ITEM_CODE, g.LINE_TYPE,
                                    g.ISSUE_DATE, g.ORGANIZATION_ID)`;
    // 단가 하한은 PB 간이 탭에만 있다. **함수를 두 번 부르지 않는다** — PB 는
    // SELECT 와 WHERE 에서 각각 불러 1만행에 15.40s 였다. 인라인 뷰에서 한 번
    // 계산하고 바깥에서 거르면 값은 같고 호출은 절반이다.
    const priceWhere = withMinPrice
      ? 'WHERE NVL("unitPrice", 0) >= :minUnitPrice'
      : '';
    const binds: Row = this.issueBinds(query, organizationId);
    if (withMinPrice) binds.minUnitPrice = query.minUnitPrice ?? 0;

    const rows = (await this.dataSource.query(
      `SELECT * FROM (
       SELECT TO_CHAR(g.ISSUE_DATE, 'YYYY-MM-DD HH24:MI:SS')    AS "issueDate",
              g.ISSUE_SEQUENCE                          AS "issueSequence",
              -- 풀체크 단건 조회에 되돌려 줄 불투명 키. Oracle DATE 를 JSON 으로
              -- 내보내면 UTC 로 바뀌어 9시간 틀어지므로 문자열로 들고 다닌다.
              TO_CHAR(g.ISSUE_DATE, 'YYYYMMDDHH24MISS') AS "issueDateKey",
              g.ITEM_CODE                               AS "itemCode",
              i.ITEM_NAME                               AS "itemName",
              i.ITEM_SPEC                               AS "itemSpec",
              i.ITEM_UOM                                AS "itemUom",
              i.ABC_GRADE                               AS "abcGrade",
              i.LOCATION_ADDRESS                        AS "locationAddress",
              i.VIRTUAL_RECEIPT_YN                      AS "virtualReceiptYn",
              g.PARENT_ITEM_CODE                        AS "parentItemCode",
              g.ITEM_TYPE                               AS "itemType",
              g.LINE_CODE                               AS "lineCode",
              g.WORKSTAGE_CODE                          AS "workstageCode",
              g.LOCATION_CODE                           AS "locationCode",
              g.ISSUE_DEFICIT                           AS "issueDeficit",
              g.ISSUE_TYPE                              AS "issueType",
              g.ISSUE_ACCOUNT                           AS "issueAccount",
              g.ISSUE_STATUS                            AS "issueStatus",
              g.LINE_TYPE                               AS "lineType",
              g.ISSUE_QTY                               AS "issueQty",
              g.ISSUE_AMT                               AS "issueAmt",
              ${unitPrice}                              AS "unitPrice",
              g.MFS                                     AS "mfs",
              g.MATERIAL_MFS                            AS "materialMfs",
              g.MODEL_NAME                              AS "modelName",
              g.BARCODE                                 AS "barcode",
              g.INVOICE_NO                              AS "invoiceNo",
              g.SUPPLIER_CODE                           AS "supplierCode",
              g.FEEDER_LOCATION_CODE                    AS "feederLocationCode",
              g.FEEDER_SHAFT                            AS "feederShaft",
              g.COMMENTS                                AS "comments",
              g.ENTER_BY                                AS "enterBy",
              TO_CHAR(g.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')     AS "enterDate",
              g.LAST_MODIFY_BY                          AS "lastModifyBy",
              TO_CHAR(g.LAST_MODIFY_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "lastModifyDate"
         FROM IM_ITEM_ISSUE g
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = g.ITEM_CODE
               AND i.ORGANIZATION_ID = g.ORGANIZATION_ID
        WHERE ${this.dateWhere('g.ENTER_DATE')}
          AND g.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND NVL(g.LINE_CODE, '*') LIKE :lineCode ESCAPE '\\'
          AND NVL(g.MATERIAL_MFS, '*') LIKE :materialMfs ESCAPE '\\'
          AND NVL(g.MFS, '*') LIKE :mfs ESCAPE '\\'
          AND NVL(g.LOCATION_CODE, '*') LIKE :locationCode ESCAPE '\\'
          -- ABC 등급은 외부조인 상대 컬럼이라 NVL 이 필요하다. 벗기면 품목마스터가
          -- 없는 출고가 탈락해 외부조인이 내부조인이 된다.
          AND NVL(i.ABC_GRADE, '*') LIKE :abcGrade ESCAPE '\\'
          AND g.ORGANIZATION_ID = :organizationId )
       -- 단가 하한은 **상한을 자르기 전에** 걸어야 한다. 뒤에 두면 '최근 1만건 중
       -- 단가 조건을 만족하는 것' 이 되어, 조건에 맞지만 1만건 밖에 있는 출고가
       -- 조용히 빠진다 (비싼 자재만 보려는 화면에서 하한을 올릴수록 더 빠진다).
       ${priceWhere}
       -- 등록일시는 'YYYY-MM-DD HH24:MI:SS' 문자열이라 사전순이 시간순과 같다.
       ORDER BY "enterDate" DESC, "issueSequence"
       FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      binds as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /**
   * 출고 한 건의 풀체크 시각 (목록에서 고른 행에만 쓴다).
   *
   * PB 는 이 값을 목록의 한 열로 뽑았지만 그 형태로는 1만행에 367초가 걸린다
   * (파일 머리 5번). 값의 정의는 PB 와 **완전히 같다** — 출고 시각 이후에
   * 그 자재(품목-롯트)가 스캔된 마지막 시각이다.
   */
  async findFullCheckDate(itemCode: string, materialMfs: string, issueDateKey: string) {
    const rows = (await this.dataSource.query(
      `SELECT TO_CHAR(MAX(c.CHECK_DATE), 'YYYY-MM-DD HH24:MI:SS') AS "fullCheckDate"
         FROM IB_SMT_CHECKHIST c
        WHERE c.CHECK_DATE >= TO_DATE(:issueDateKey, 'YYYYMMDDHH24MISS')
          AND c.SCAN_PARTNAME LIKE :prefix ESCAPE '\\'`,
      {
        issueDateKey,
        // 접두어를 바인드로 넘기면 SCAN_PARTNAME 인덱스를 탄다. PB 처럼 컬럼
        // 연결식으로 두면 인덱스를 못 쓴다 — 그것이 367초의 원인이었다.
        prefix: likePrefix(`${itemCode}-${materialMfs}`),
      } as unknown as unknown[],
    )) as Row[];
    return { fullCheckDate: (rows[0]?.fullCheckDate as string | null) ?? null };
  }

  /**
   * 미출고 (지시수량 − 출고수량 ≠ 0).
   *
   * **IM_ITEM_WORK_ORDER 는 0행이다** (실측) — 은성이 자재 작업지시를 쓰지 않는다.
   * PB 고정조건 `ISSUE_STATUS <> 'C'` 와 `지시 − 출고 <> 0` 을 그대로 옮겼다.
   */
  async findNotIssued(query: MaterialIssueReportQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT TO_CHAR(w.ISSUE_DATE, 'YYYY-MM-DD')       AS "issueDate",
              w.ITEM_CODE                               AS "itemCode",
              i.ITEM_NAME                               AS "itemName",
              i.ITEM_SPEC                               AS "itemSpec",
              i.ITEM_UOM                                AS "itemUom",
              w.PARENT_ITEM_CODE                        AS "parentItemCode",
              w.ITEM_TYPE                               AS "itemType",
              w.LINE_CODE                               AS "lineCode",
              w.WORKSTAGE_CODE                          AS "workstageCode",
              w.MFS                                     AS "mfs",
              w.PLAN_YYYYMM                             AS "planYyyymm",
              w.ISSUE_PLAN_QTY                          AS "issuePlanQty",
              w.ISSUE_QTY                               AS "issueQty",
              NVL(w.ISSUE_PLAN_QTY, 0) - NVL(w.ISSUE_QTY, 0) AS "remainQty",
              w.ISSUE_STATUS                            AS "issueStatus",
              w.ISSUE_ACCOUNT                           AS "issueAccount",
              w.LINE_TYPE                               AS "lineType",
              w.ENTER_BY                                AS "enterBy",
              TO_CHAR(w.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')     AS "enterDate"
         FROM IM_ITEM_WORK_ORDER w
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = w.ITEM_CODE
               AND i.ORGANIZATION_ID = w.ORGANIZATION_ID
        WHERE ${this.dateWhere('w.ISSUE_DATE')}
          AND w.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND w.ORGANIZATION_ID = :organizationId
          AND NVL(w.ISSUE_PLAN_QTY, 0) - NVL(w.ISSUE_QTY, 0) <> 0
          AND w.ISSUE_STATUS <> '${ISSUE_CANCELED}'
        ORDER BY w.ISSUE_DATE DESC, w.ITEM_CODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        itemCode: likePrefix(query.itemCode),
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /**
   * SMT 풀체크 이력 (바코드 하나).
   *
   * PB 는 세 컬럼을 OR 로 훑는다 — 자재 바코드가 스캔 바코드·협력사 바코드·이전
   * 바코드 중 어디에 들어 있을지 모르기 때문이다. **기간 조건이 없어 바코드가
   * 필수다** (312만행).
   *
   * 재활용 시각은 PB 와 같이 상관없는 스칼라 서브쿼리로 붙는다 — 행마다 같은 값이
   * 나오지만 PB 표시를 유지한다.
   */
  async findSmtCheckHistory(query: SmtCheckBarcodeQueryDto) {
    const rows = (await this.dataSource.query(
      `SELECT TO_CHAR(c.CHECK_DATE, 'YYYY-MM-DD HH24:MI:SS')     AS "checkDate",
              c.LOT_NAME                                AS "lotName",
              c.PARTNAME                                AS "partName",
              c.SCAN_PARTNAME                            AS "scanPartName",
              c.LINE_CODE                               AS "lineCode",
              c.LOCATION_CODE                           AS "locationCode",
              c.PCB_ITEM                                AS "pcbItem",
              c.OLD_BARCODE                             AS "oldBarcode",
              c.CHECK_TYPE                              AS "checkType",
              c.CHECK_SEQUENCE                          AS "checkSequence",
              c.CHECK_STATUS                            AS "checkStatus",
              TO_CHAR((SELECT MIN(y.CHECK_DATE) FROM IB_RECYCLE_CHECKHIST y
                        WHERE y.SCAN_PARTNAME LIKE :barcode ESCAPE '\\'),
                      'YYYY-MM-DD HH24:MI:SS')          AS "recycleDate"
         FROM IB_SMT_CHECKHIST c
        WHERE (   c.SCAN_PARTNAME LIKE :barcode ESCAPE '\\'
               OR c.SCAN_SUPPLIER_PARTNAME LIKE :barcode ESCAPE '\\'
               OR c.OLD_BARCODE LIKE :barcode ESCAPE '\\')
        ORDER BY c.CHECK_DATE DESC
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      { barcode: likePrefix(query.barcode) } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  // ───────────────────────────────── 366 자재출고합계리포트

  /** 품목별 출고합계. */
  async findIssueSumByItem(query: MaterialIssueSumQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT g.ITEM_CODE                               AS "itemCode",
              g.LINE_TYPE                               AS "lineType",
              i.ITEM_NAME                               AS "itemName",
              i.ITEM_SPEC                               AS "itemSpec",
              i.ITEM_UOM                                AS "itemUom",
              g.SUPPLIER_CODE                           AS "supplierCode",
              s.SUPPLIER_NAME                           AS "supplierName",
              SUM(NVL(g.ISSUE_QTY, 0))                  AS "issueQty",
              SUM(NVL(g.ISSUE_AMT, 0))                  AS "issueAmt"
         FROM IM_ITEM_ISSUE g
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = g.ITEM_CODE
               AND i.ORGANIZATION_ID = g.ORGANIZATION_ID
         LEFT JOIN ICOM_SUPPLIER s
                ON s.SUPPLIER_CODE = g.SUPPLIER_CODE
               AND s.ORGANIZATION_ID = g.ORGANIZATION_ID
        WHERE ${this.dateWhere('g.ISSUE_DATE')}
          AND NVL(g.SUPPLIER_CODE, '*') LIKE :supplierCode ESCAPE '\\'
          AND g.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND g.ORGANIZATION_ID = :organizationId
          AND g.ISSUE_STATUS <> '${ISSUE_CANCELED}'
        GROUP BY g.ITEM_CODE, g.LINE_TYPE, i.ITEM_NAME, i.ITEM_SPEC, i.ITEM_UOM,
                 g.SUPPLIER_CODE, s.SUPPLIER_NAME
        ORDER BY g.ITEM_CODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        itemCode: likePrefix(query.itemCode),
        supplierCode: likePrefix(query.supplierCode),
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /** 출고계정별 합계. */
  async findIssueSumByAccount(query: MaterialIssueSumQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT g.ISSUE_ACCOUNT                           AS "issueAccount",
              g.ITEM_CODE                               AS "itemCode",
              g.LINE_TYPE                               AS "lineType",
              i.ITEM_NAME                               AS "itemName",
              i.ITEM_SPEC                               AS "itemSpec",
              i.ITEM_UOM                                AS "itemUom",
              SUM(NVL(g.ISSUE_QTY, 0))                  AS "issueQty",
              SUM(NVL(g.ISSUE_AMT, 0))                  AS "issueAmt"
         FROM IM_ITEM_ISSUE g
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = g.ITEM_CODE
               AND i.ORGANIZATION_ID = g.ORGANIZATION_ID
        WHERE ${this.dateWhere('g.ISSUE_DATE')}
          AND g.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND NVL(g.ISSUE_ACCOUNT, '*') LIKE :issueAccount ESCAPE '\\'
          AND g.ORGANIZATION_ID = :organizationId
          AND g.ISSUE_STATUS <> '${ISSUE_CANCELED}'
        GROUP BY g.ISSUE_ACCOUNT, g.ITEM_CODE, g.LINE_TYPE,
                 i.ITEM_NAME, i.ITEM_SPEC, i.ITEM_UOM
        ORDER BY g.ISSUE_ACCOUNT, g.ITEM_CODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        itemCode: likePrefix(query.itemCode),
        issueAccount: likePrefix(query.issueAccount),
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  // ───────────────────────────────── 367 자재랙이동리포트

  /**
   * 랙(위치주소) 이동 이력.
   *
   * **이 표는 0행이다** (IM_ITEM_LOCATION_MOVE_HIST 실측 0건).
   * 품목명을 함께 보여준다 — PB 는 품목코드만 보여줘서 무엇이 움직였는지
   * 코드를 외우지 않으면 알 수 없었다.
   */
  async findRackMoves(query: MaterialRackMoveQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT TO_CHAR(m.MOVE_DATE, 'YYYY-MM-DD HH24:MI:SS')      AS "moveDate",
              m.ITEM_CODE                               AS "itemCode",
              i.ITEM_NAME                               AS "itemName",
              i.ITEM_SPEC                               AS "itemSpec",
              m.MATERIAL_MFS                            AS "materialMfs",
              m.FROM_RACK                               AS "fromRack",
              m.TO_RACK                                 AS "toRack"
         FROM IM_ITEM_LOCATION_MOVE_HIST m
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = m.ITEM_CODE
               AND i.ORGANIZATION_ID = m.ORGANIZATION_ID
        WHERE ${this.dateWhere('m.MOVE_DATE')}
          AND m.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND NVL(m.MATERIAL_MFS, '*') LIKE :materialMfs ESCAPE '\\'
          AND m.ORGANIZATION_ID = :organizationId
        ORDER BY m.MOVE_DATE DESC
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        itemCode: likePrefix(query.itemCode),
        materialMfs: likePrefix(query.materialMfs),
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }
}
