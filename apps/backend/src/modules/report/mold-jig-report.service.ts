/**
 * @file src/modules/report/mold-jig-report.service.ts
 * @description S-PARTS·지그·4M 리포트 5화면
 *              354 w_mcn_mold_receipt_rpt  S-PARTS입고리포트
 *              355 w_mcn_mold_issue_rpt    S-PARTS출고리포트
 *              357 w_mcn_jig_rpt           지그리포트
 *              358 w_mcn_mold_rpt          S-PARTS관리리포트
 *              360 w_qc_4m_history_rpt     4M 변경이력
 *
 * 초보자 가이드:
 * 1. **다섯 화면 중 네 개가 빈 표를 읽는다** (실측 행수):
 *        IMCN_MOLD 0 · IMCN_MOLD_RECEIPT 0 · IMCN_MOLD_ISSUE 0 ·
 *        IMCN_MOLD_INVENTORY 0 · IMCN_JIG_ISSUE 0 · IP_PRODUCT_SOFTWARE_MASTER 0
 *    화면은 동작하지만 볼 것이 없다. 조건이 틀린 게 아니라 은성이 S-PARTS 를
 *    이 표들에 쌓지 않는다. **살아있는 것은 지그(IMCN_JIG 1,944행)와
 *    지그수리(IMCN_JIG_REPAIR 12행), 모델마스터(327행)뿐이다.**
 * 2. **PB 의 고정조건을 빠뜨리지 않는다** (실측):
 *        354  MOLD_CODE <> '*' · RECEIPT_STATUS = 'N'
 *        357  JIG_CODE  <> '*'
 *        358  MOLD_CODE <> '*'
 *    `'*'` 는 이 시스템이 '전체' 를 뜻하는 더미 마스터 행에 쓰는 코드다.
 *    빼면 그 더미 행이 리포트에 섞인다.
 * 3. **바코드 라벨은 이관 대상이 아니다.** `d_mcn_jig_barcode_rpt` ·
 *    `d_mcn_mold_barcode_rpt` 는 `'*'||코드||'*'` 를 찍는 인쇄 지오메트리다
 *    (Code39 양끝 기호). 바코드 값은 목록에 컬럼으로 넣고 라벨은 CSV 로 내보내
 *    라벨 소프트웨어가 찍는다 — 340 라인설비바코드와 같은 결정이다.
 * 4. **이력카드는 라벨이 아니라 자료다.** `d_mcn_jig_card_rpt` ·
 *    `d_mcn_mold_card_rpt` 는 수리이력을 붙인 카드라 목록으로 옮긴다.
 *    수리이력은 **외부조인**이다 (PB `(+)` 그대로) — 수리 기록이 없는 지그도
 *    남아야 한다. 그게 이 표의 목적이다.
 * 5. **360 의 S/W 버전은 서브쿼리 두 개가 붙인다.** 모델별 최신 업로드 한 건을
 *    고르는 형태인데 그 표가 0행이라 항상 비어 보인다. PB 의 조건을 그대로 옮겼다 —
 *    두 서브쿼리가 모두 `OUTPUT_SW_VERSION` 이 빈 행을 제외한다 (입력 버전을
 *    고르는 쪽도 그렇다. PB 의 실수로 보이지만 값이 갈리므로 바꾸지 않았다).
 */
import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { likePrefix } from '@smt/shared';
import { limited, ROW_LIMIT } from '../../shared/row-limit';
import {
  FourMHistoryQueryDto,
  JigIssueReportQueryDto,
  JigReportQueryDto,
  MoldIssueReportQueryDto,
  MoldMasterReportQueryDto,
  MoldReceiptReportQueryDto,
} from './material-report.dto';
import { namedBinds } from '../../common/utils/named-binds.util';

type Row = Record<string, unknown>;

/** '전체' 를 뜻하는 더미 마스터 코드. 리포트에서는 뺀다 (PB 고정조건). */
const DUMMY_CODE = '*';
/** PB 고정조건: 354 는 정상 입고만 본다. */
const MOLD_RECEIPT_NORMAL = 'N';

@Injectable()
export class MoldJigReportService {
  constructor(private readonly dataSource: DataSource) {}

  /** 종료일 하루가 통째로 빠지지 않게 `< 종료일 + 1` 로 건다 (PB between 의 결함). */
  private dateWhere(column: string) {
    return `${column} >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
        AND ${column} <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1`;
  }

  // ───────────────────────────────── 354 S-PARTS입고리포트

  /** S-PARTS 입고. **이 표는 0행이다** (IMCN_MOLD_RECEIPT 실측 0건). */
  async findMoldReceipts(query: MoldReceiptReportQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT TO_CHAR(r.RECEIPT_DATE, 'YYYY-MM-DD HH24:MI:SS')   AS "receiptDate",
              r.RECEIPT_SEQUENCE                        AS "receiptSequence",
              r.MOLD_CODE                               AS "moldCode",
              m.MOLD_NAME                               AS "moldName",
              m.MOLD_SPEC                               AS "moldSpec",
              m.MOLD_GROUP                              AS "moldGroup",
              m.ITEM_CODE                               AS "itemCode",
              r.SUPPLIER_CODE                           AS "supplierCode",
              F_GET_SUPPLIER_NAME(r.SUPPLIER_CODE, r.ORGANIZATION_ID) AS "supplierName",
              r.INVOICE_NO                              AS "invoiceNo",
              r.ORDER_NO                                AS "orderNo",
              r.RECEIPT_DEFICIT                         AS "receiptDeficit",
              r.RECEIPT_QTY                             AS "receiptQty",
              r.UNIT_PRICE                              AS "unitPrice",
              r.RECEIPT_AMT                             AS "receiptAmt",
              r.CURRENCY                                AS "currency",
              r.RECEIPT_STATUS                          AS "receiptStatus",
              r.LOCATION_CODE                           AS "locationCode",
              r.LINE_TYPE                               AS "lineType",
              r.MOLD_VERSION                            AS "moldVersion",
              r.MOLD_SET_SERIAL                         AS "moldSetSerial",
              r.ENTER_BY                                AS "enterBy",
              TO_CHAR(r.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')     AS "enterDate",
              r.LAST_MODIFY_BY                          AS "lastModifyBy",
              TO_CHAR(r.LAST_MODIFY_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "lastModifyDate"
         FROM IMCN_MOLD_RECEIPT r
         LEFT JOIN IMCN_MOLD m
                ON m.MOLD_CODE = r.MOLD_CODE
               AND m.ORGANIZATION_ID = r.ORGANIZATION_ID
        WHERE ${this.dateWhere('r.RECEIPT_DATE')}
          AND r.MOLD_CODE LIKE :moldCode ESCAPE '\\'
          AND NVL(r.SUPPLIER_CODE, '*') LIKE :supplierCode ESCAPE '\\'
          AND r.ORGANIZATION_ID = :organizationId
          AND r.MOLD_CODE <> '${DUMMY_CODE}'
          AND r.RECEIPT_STATUS = '${MOLD_RECEIPT_NORMAL}'
        ORDER BY r.RECEIPT_DATE DESC, r.RECEIPT_SEQUENCE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        moldCode: likePrefix(query.moldCode),
        supplierCode: likePrefix(query.supplierCode),
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }

  // ───────────────────────────────── 355 S-PARTS출고리포트

  /** S-PARTS 출고. **이 표는 0행이다** (IMCN_MOLD_ISSUE 실측 0건). */
  async findMoldIssues(query: MoldIssueReportQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT TO_CHAR(g.ISSUE_DATE, 'YYYY-MM-DD HH24:MI:SS')     AS "issueDate",
              g.ISSUE_SEQUENCE                          AS "issueSequence",
              g.MOLD_CODE                               AS "moldCode",
              m.MOLD_NAME                               AS "moldName",
              m.MOLD_SPEC                               AS "moldSpec",
              m.MOLD_GROUP                              AS "moldGroup",
              g.WORKSTAGE_CODE                          AS "workstageCode",
              g.LINE_CODE                               AS "lineCode",
              g.MACHINE_CODE                            AS "machineCode",
              g.ISSUE_DEFICIT                           AS "issueDeficit",
              g.MOLD_ISSUE_ACCOUNT                      AS "moldIssueAccount",
              g.ISSUE_QTY                               AS "issueQty",
              g.ISSUE_PRICE                             AS "issuePrice",
              g.ISSUE_AMT                               AS "issueAmt",
              g.CURRENCY                                AS "currency",
              g.ISSUE_STATUS                            AS "issueStatus",
              g.MOLD_VERSION                            AS "moldVersion",
              g.MOLD_SET_SERIAL                         AS "moldSetSerial",
              g.ENTER_BY                                AS "enterBy",
              TO_CHAR(g.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')     AS "enterDate",
              g.LAST_MODIFY_BY                          AS "lastModifyBy",
              TO_CHAR(g.LAST_MODIFY_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "lastModifyDate"
         FROM IMCN_MOLD_ISSUE g
         LEFT JOIN IMCN_MOLD m
                ON m.MOLD_CODE = g.MOLD_CODE
               AND m.ORGANIZATION_ID = g.ORGANIZATION_ID
        WHERE ${this.dateWhere('g.ISSUE_DATE')}
          AND g.MOLD_CODE LIKE :moldCode ESCAPE '\\'
          AND g.ORGANIZATION_ID = :organizationId
        ORDER BY g.ISSUE_DATE DESC, g.ISSUE_SEQUENCE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        moldCode: likePrefix(query.moldCode),
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }

  // ───────────────────────────────── 357 지그리포트

  /** 지그 목록. 바코드 값(Code39 양끝 기호 포함)을 컬럼으로 함께 낸다. */
  async findJigs(query: JigReportQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT j.JIG_CODE                                AS "jigCode",
              j.JIG_LOT_NO                              AS "jigLotNo",
              -- 라벨에 찍는 값. 라벨 지오메트리는 옮기지 않고 값만 낸다.
              '*' || j.JIG_LOT_NO || '*'                AS "barcodeText",
              j.JIG_NAME                                AS "jigName",
              j.JIG_SPEC                                AS "jigSpec",
              j.JIG_TYPE                                AS "jigType",
              j.JIG_STATUS                              AS "jigStatus",
              j.JIG_MODEL_NAME                          AS "jigModelName",
              j.USE_STATUS                              AS "useStatus",
              j.WORKSTAGE_CODE                          AS "workstageCode",
              j.NATION_CODE                             AS "nationCode",
              j.SUPPLIER_CODE                           AS "supplierCode",
              F_GET_SUPPLIER_NAME(j.SUPPLIER_CODE, j.ORGANIZATION_ID) AS "supplierName",
              j.ACQUISITION_TYPE                        AS "acquisitionType",
              TO_CHAR(j.ACQUISITION_DATE, 'YYYY-MM-DD') AS "acquisitionDate",
              j.BREAK_VALUE                             AS "breakValue",
              j.HIT_VALUE                               AS "hitValue"
         FROM IMCN_JIG j
        WHERE j.JIG_CODE LIKE :jigCode ESCAPE '\\'
          AND j.ORGANIZATION_ID = :organizationId
          AND j.JIG_CODE <> '${DUMMY_CODE}'
        ORDER BY j.JIG_CODE, j.JIG_LOT_NO
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        jigCode: likePrefix(query.jigCode),
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }

  /**
   * 지그 이력카드 (수리이력 포함).
   *
   * 수리이력은 외부조인이다 — 수리 기록이 없는 지그도 남아야 한다 (PB `(+)` 그대로).
   * 한 지그에 수리 기록이 여러 건이면 그만큼 줄이 늘어난다 (PB 도 그렇다).
   */
  async findJigCards(query: JigReportQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT j.JIG_CODE                                AS "jigCode",
              j.JIG_LOT_NO                              AS "jigLotNo",
              j.JIG_NAME                                AS "jigName",
              j.JIG_TYPE                                AS "jigType",
              j.JIG_STATUS                              AS "jigStatus",
              j.JIG_MODEL_NAME                          AS "jigModelName",
              j.WORKSTAGE_CODE                          AS "workstageCode",
              j.ACQUISITION_TYPE                        AS "acquisitionType",
              TO_CHAR(j.ACQUISITION_DATE, 'YYYY-MM-DD') AS "acquisitionDate",
              p.REPAIR_SEQUENCE                         AS "repairSequence",
              p.REPAIR_STATUS                           AS "repairStatus",
              p.REPAIR_REASON_CODE                      AS "repairReasonCode",
              TO_CHAR(p.REPAIR_DATE, 'YYYY-MM-DD HH24:MI:SS')    AS "repairDate",
              p.REPAIR_TIME                             AS "repairTime",
              p.REPAIR_BY                               AS "repairBy",
              p.REPAIR_COMMENTS                         AS "repairComments"
         FROM IMCN_JIG j
         LEFT JOIN IMCN_JIG_REPAIR p
                ON p.JIG_CODE = j.JIG_CODE
               AND p.ORGANIZATION_ID = j.ORGANIZATION_ID
        WHERE j.JIG_CODE LIKE :jigCode ESCAPE '\\'
          AND j.ORGANIZATION_ID = :organizationId
          AND j.JIG_CODE <> '${DUMMY_CODE}'
        ORDER BY j.JIG_CODE, p.REPAIR_SEQUENCE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        jigCode: likePrefix(query.jigCode),
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }

  /** 지그 출고 이력. **이 표는 0행이다** (IMCN_JIG_ISSUE 실측 0건). */
  async findJigIssues(query: JigIssueReportQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT TO_CHAR(g.ISSUE_DATE, 'YYYY-MM-DD HH24:MI:SS')     AS "issueDate",
              g.ISSUE_SEQUENCE                          AS "issueSequence",
              g.JIG_CODE                                AS "jigCode",
              g.JIG_LOT_NO                              AS "jigLotNo",
              j.JIG_TYPE                                AS "jigType",
              j.JIG_STATUS                              AS "jigStatus",
              g.WORKSTAGE_CODE                          AS "workstageCode",
              g.MACHINE_CODE                            AS "machineCode",
              g.ISSUE_DEFICIT                           AS "issueDeficit",
              g.ISSUE_ACCOUNT                           AS "issueAccount",
              g.ISSUE_QTY                               AS "issueQty",
              g.ISSUE_STATUS                            AS "issueStatus",
              g.ENTER_BY                                AS "enterBy",
              TO_CHAR(g.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')     AS "enterDate",
              g.LAST_MODIFY_BY                          AS "lastModifyBy",
              TO_CHAR(g.LAST_MODIFY_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "lastModifyDate"
         FROM IMCN_JIG_ISSUE g
         LEFT JOIN IMCN_JIG j
                ON j.JIG_CODE = g.JIG_CODE
               AND j.ORGANIZATION_ID = g.ORGANIZATION_ID
        WHERE ${this.dateWhere('g.ISSUE_DATE')}
          AND g.JIG_CODE LIKE :jigCode ESCAPE '\\'
          AND NVL(j.JIG_TYPE, '*') LIKE :jigType ESCAPE '\\'
          AND NVL(g.ISSUE_STATUS, '*') LIKE :issueStatus ESCAPE '\\'
          AND g.ORGANIZATION_ID = :organizationId
        ORDER BY g.ISSUE_DATE DESC, g.ISSUE_SEQUENCE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        jigCode: likePrefix(query.jigCode),
        jigType: likePrefix(query.jigType),
        issueStatus: likePrefix(query.issueStatus),
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }

  // ───────────────────────────────── 358 S-PARTS관리리포트

  /**
   * S-PARTS 마스터 + 재고. **두 표 모두 0행이다** (실측).
   *
   * PB 는 마스터와 재고를 내부조인했다. 재고 행이 없는 S-PARTS 가 사라지므로
   * 외부조인으로 옮겼다 — 마스터에는 있는데 재고가 안 잡힌 품목을 찾는 것이
   * 관리 리포트의 목적이다.
   */
  async findMolds(query: MoldMasterReportQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT m.MOLD_CODE                               AS "moldCode",
              m.MOLD_NAME                               AS "moldName",
              m.MOLD_SPEC                               AS "moldSpec",
              m.MOLD_GROUP                              AS "moldGroup",
              m.MOLD_TYPE                               AS "moldType",
              m.DRAWING_NO                              AS "drawingNo",
              m.RAW_MATERIAL                            AS "rawMaterial",
              m.PUNCH_NO                                AS "punchNo",
              m.MOLD_LINE_TYPE                          AS "moldLineType",
              m.ITEM_CODE                               AS "itemCode",
              m.ITEM_UNIT_QTY                           AS "itemUnitQty",
              m.GAS_YN                                  AS "gasYn",
              m.ITEM_GAS_QTY                            AS "itemGasQty",
              m.SAFETY_INVENTORY                        AS "safetyInventory",
              m.ORDER_LEADTIME                          AS "orderLeadtime",
              m.NATION_CODE                             AS "nationCode",
              m.SUPPLIER_CODE                           AS "supplierCode",
              F_GET_SUPPLIER_NAME(m.SUPPLIER_CODE, m.ORGANIZATION_ID) AS "supplierName",
              m.COMMENTS                                AS "comments",
              -- 라벨에 찍는 값. 라벨 지오메트리는 옮기지 않는다.
              '*' || m.MOLD_CODE || '*'                 AS "barcodeText",
              v.MOLD_VERSION                            AS "moldVersion",
              v.MOLD_SET_SERIAL                         AS "moldSetSerial",
              v.MOLD_SET_QTY                            AS "moldSetQty",
              v.MOLD_ROW_QTY                            AS "moldRowQty",
              v.MOLD_USEFULL_ROW_QTY                    AS "moldUsefullRowQty",
              v.MOLD_USE_STATUS                         AS "moldUseStatus",
              v.INVENTORY_QTY                           AS "inventoryQty",
              v.LOCATION_CODE                           AS "locationCode",
              v.MOLD_WAREHOUSE_CODE                     AS "moldWarehouseCode",
              v.APPLY_MODEL_NAME                        AS "applyModelName",
              v.BREAK_VALUE                             AS "breakValue",
              v.ACTUAL_VALUE                            AS "actualValue",
              v.RENT_STATUS                             AS "rentStatus",
              v.SUPPLIER_CODE                           AS "inventorySupplierCode",
              TO_CHAR(v.LAST_RECEIPT_DATE, 'YYYY-MM-DD')             AS "lastReceiptDate",
              TO_CHAR(v.LAST_ISSUE_DATE, 'YYYY-MM-DD')               AS "lastIssueDate"
         FROM IMCN_MOLD m
         LEFT JOIN IMCN_MOLD_INVENTORY v
                ON v.MOLD_CODE = m.MOLD_CODE
               AND v.ORGANIZATION_ID = m.ORGANIZATION_ID
        WHERE m.MOLD_CODE LIKE :moldCode ESCAPE '\\'
          AND NVL(m.MOLD_GROUP, '*') LIKE :moldGroup ESCAPE '\\'
          AND m.ORGANIZATION_ID = :organizationId
          AND m.MOLD_CODE <> '${DUMMY_CODE}'
        ORDER BY m.MOLD_CODE, v.MOLD_VERSION, v.MOLD_SET_SERIAL
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        moldCode: likePrefix(query.moldCode),
        moldGroup: likePrefix(query.moldGroup),
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }

  /**
   * S-PARTS 이력카드 (재고 + 수리이력). **0행이다** (실측).
   *
   * 수리이력은 재고 한 건(코드·버전·세트일련)에 외부조인으로 붙는다 (PB `(+)` 그대로).
   */
  async findMoldCards(query: MoldMasterReportQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT m.MOLD_CODE                               AS "moldCode",
              m.MOLD_NAME                               AS "moldName",
              m.MOLD_SPEC                               AS "moldSpec",
              m.MOLD_GROUP                              AS "moldGroup",
              m.MOLD_TYPE                               AS "moldType",
              m.ITEM_CODE                               AS "itemCode",
              m.SUPPLIER_CODE                           AS "supplierCode",
              v.MOLD_VERSION                            AS "moldVersion",
              v.MOLD_SET_SERIAL                         AS "moldSetSerial",
              v.MOLD_ROW_QTY                            AS "moldRowQty",
              v.MOLD_USEFULL_ROW_QTY                    AS "moldUsefullRowQty",
              v.MOLD_USE_STATUS                         AS "moldUseStatus",
              v.MOLD_WAREHOUSE_CODE                     AS "moldWarehouseCode",
              v.BREAK_VALUE                             AS "breakValue",
              v.ACTUAL_VALUE                            AS "actualValue",
              v.RENT_SUPPLIER_CODE                      AS "rentSupplierCode",
              v.COMMENTS                                AS "comments",
              TO_CHAR(v.LAST_RECEIPT_DATE, 'YYYY-MM-DD')             AS "lastReceiptDate",
              TO_CHAR(v.LAST_ADJUST_DATE, 'YYYY-MM-DD')              AS "lastAdjustDate",
              p.REPAIR_SEQUENCE                         AS "repairSequence",
              p.REPAIR_STATUS                           AS "repairStatus",
              p.REPAIR_REASON_CODE                      AS "repairReasonCode",
              TO_CHAR(p.REPAIR_DATE, 'YYYY-MM-DD HH24:MI:SS')        AS "repairDate",
              p.REPAIR_TIME                             AS "repairTime",
              p.REPAIR_BY                               AS "repairBy",
              p.REPAIR_COMMENTS                         AS "repairComments"
         FROM IMCN_MOLD m
         JOIN IMCN_MOLD_INVENTORY v
              ON v.MOLD_CODE = m.MOLD_CODE
             AND v.ORGANIZATION_ID = m.ORGANIZATION_ID
         LEFT JOIN IMCN_MOLD_REPAIR p
                ON p.MOLD_CODE = v.MOLD_CODE
               AND p.ORGANIZATION_ID = v.ORGANIZATION_ID
               AND p.MOLD_VERSION = v.MOLD_VERSION
               AND p.MOLD_SET_SERIAL = v.MOLD_SET_SERIAL
        WHERE m.MOLD_CODE LIKE :moldCode ESCAPE '\\'
          AND NVL(m.MOLD_GROUP, '*') LIKE :moldGroup ESCAPE '\\'
          AND m.ORGANIZATION_ID = :organizationId
        ORDER BY m.MOLD_CODE, v.MOLD_VERSION, v.MOLD_SET_SERIAL, p.REPAIR_SEQUENCE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        moldCode: likePrefix(query.moldCode),
        moldGroup: likePrefix(query.moldGroup),
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }

  // ───────────────────────────────── 360 4M 변경이력

  /**
   * 모델별 H/W·S/W 버전.
   *
   * PB 는 모델명을 등호로 걸어 정확히 모르면 아무것도 못 봤다. 모델 마스터는
   * 327행뿐이라 앞부분 일치로 넓혀도 비용이 없다.
   *
   * S/W 두 칸은 IP_PRODUCT_SOFTWARE_MASTER 가 **0행이라 항상 비어 있다** (실측).
   */
  async findFourMHistory(query: FourMHistoryQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT a.MODEL_NAME                              AS "modelName",
              a.MODEL_SUFFIX                            AS "modelSuffix",
              a.VERSION                                 AS "version",
              a.ITEM_CODE                               AS "itemCode",
              a.HW_VERSION                              AS "hwVersion",
              -- 모델별 최신 업로드 한 건. 두 서브쿼리 모두 OUTPUT 이 빈 행을
              -- 제외한다 (PB 그대로 — 입력 버전을 고르는 쪽도 그렇다).
              (SELECT OUTPUT_SW_VERSION FROM (
                 SELECT ROW_NUMBER() OVER (PARTITION BY MODEL_NAME
                                           ORDER BY UPLOAD_DATE DESC) CNT,
                        MODEL_NAME, OUTPUT_SW_VERSION
                   FROM IP_PRODUCT_SOFTWARE_MASTER
                  WHERE IS_NEW = 'N' AND NVL(OUTPUT_SW_VERSION, ' ') <> ' ')
                WHERE CNT = 1 AND MODEL_NAME = a.MODEL_NAME) AS "swVersionOut",
              (SELECT INPUT_SW_VERSION FROM (
                 SELECT ROW_NUMBER() OVER (PARTITION BY MODEL_NAME
                                           ORDER BY UPLOAD_DATE DESC) CNT,
                        MODEL_NAME, INPUT_SW_VERSION
                   FROM IP_PRODUCT_SOFTWARE_MASTER
                  WHERE IS_NEW = 'N' AND NVL(OUTPUT_SW_VERSION, ' ') <> ' ')
                WHERE CNT = 1 AND MODEL_NAME = a.MODEL_NAME) AS "swVersionIn"
         FROM IP_PRODUCT_MODEL_MASTER a
        WHERE a.MODEL_NAME LIKE :modelName ESCAPE '\\'
          AND NVL(a.MODEL_SUFFIX, '*') LIKE :modelSuffix ESCAPE '\\'
          AND a.ORGANIZATION_ID = :organizationId
        ORDER BY a.MODEL_NAME, a.MODEL_SUFFIX
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        modelName: likePrefix(query.modelName),
        modelSuffix: likePrefix(query.modelSuffix),
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }
}
