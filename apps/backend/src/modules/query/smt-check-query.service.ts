/**
 * @file src/modules/query/smt-check-query.service.ts
 * @description SMT 스캔·검사 조회 2화면
 *              327 w_pln_product_pda_scan_query  SMT 오장착 스캔 현황 조회
 *              328 w_smt_plan_ng_check_master    PDA 검사오류내역조회
 *
 * 초보자 가이드:
 * 1. **327 은 PDA 가 찍은 자재 스캔 이력을 본다.** 오장착(잘못된 자재를 물린 것)을
 *    찾는 화면이고, 찾은 건에 NG 사유·메모를 적어 둘 수 있다.
 * 2. **327 은 네 갈래로 본다** (PB 탭 4개):
 *      상세    스캔 한 건씩
 *      그룹    풀체크 회차별 시작·종료 시각까지 묶어서
 *      바코드  바코드 하나로 자사·공급처·이전 바코드를 한꺼번에
 *      출고    그 자재의 출고 이력
 * 3. **328 은 계획데이터(IB_PRODUCT_PLANDATA)의 검사 설정을 본다.** 모델 하나의
 *    피더 배치를 펼쳐 놓고 검사 사용 여부를 조정한다.
 * 4. **기간이 필수다.** IB_SMT_CHECKHIST 는 (CHECK_DATE, SCAN_PARTNAME) 인덱스가
 *    있어 구간이 닫혀 있어야 인덱스를 탄다. PB 는 빈 조건을 `'%'` 로 보냈다.
 * 5. **수정 가능한 컬럼만 받는다.** DataWindow 의 update=yes 를 실측했다 —
 *    327 은 NG_REASON·COMMENTS, 328 은 CHECK_YN·CHECK_STATUS·CCS_YN 이다.
 *    그 밖의 컬럼을 열어 두면 조회 화면이 조용히 원장을 바꾼다.
 */
import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { likePrefix } from '@smt/shared';
import { TransactionService } from '../../shared/transaction.service';
import {
  BarcodeHistoryQueryDto,
  CheckHistNoteBulkDto,
  LineCodeQueryDto,
  PdaScanQueryDto,
  PlanCheckFlagBulkDto,
  PlanDataQueryDto,
} from './query.dto';
import { ROW_LIMIT } from './row-limit';
import { affectedRows } from '../../common/utils/affected-rows.util';
import { namedBinds } from '../../common/utils/named-binds.util';

type Row = Record<string, unknown>;

@Injectable()
export class SmtCheckQueryService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  /** 327 의 네 갈래가 공유하는 조건절. PB 도 같은 조건을 탭마다 반복했다. */
  private scanWhere(alias: string) {
    return `${alias}.CHECK_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND ${alias}.CHECK_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND NVL(${alias}.LINE_CODE, '*') LIKE :lineCode ESCAPE '\\'
          AND NVL(${alias}.PARTNAME, '*') LIKE :itemCode ESCAPE '\\'
          AND NVL(${alias}.LOT_NAME, '*') LIKE :modelName ESCAPE '\\'
          AND NVL(${alias}.LOCATION_CODE, '*') LIKE :locationCode ESCAPE '\\'
          AND NVL(${alias}.CHECK_STATUS, '*') LIKE :checkStatus ESCAPE '\\'
          AND NVL(${alias}.CHECK_TYPE, '*') LIKE :checkType ESCAPE '\\'
          AND NVL(${alias}.SCAN_PARTNAME, '*') LIKE :scanBarcode ESCAPE '\\'`;
  }

  private scanBinds(query: PdaScanQueryDto) {
    return {
      dateFrom: query.dateFrom,
      dateTo: query.dateTo,
      lineCode: likePrefix(query.lineCode),
      itemCode: likePrefix(query.itemCode),
      modelName: likePrefix(query.modelName),
      locationCode: likePrefix(query.locationCode),
      checkStatus: likePrefix(query.checkStatus),
      checkType: likePrefix(query.checkType),
      scanBarcode: likePrefix(query.scanBarcode),
    };
  }

  // ───────────────────────────────── 327 상세

  async findScanDetail(query: PdaScanQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT TO_CHAR(c.CHECK_DATE, 'YYYY-MM-DD HH24:MI:SS')  AS "checkDate",
              TO_CHAR(c.CHECK_DATE, 'YYYYMMDDHH24MISS')       AS "checkDateKey",
              c.CHECK_SEQUENCE                          AS "checkSequence",
              c.FULL_CHECK_SEQUENCE                     AS "fullCheckSequence",
              TO_CHAR(c.PLAN_DATE, 'YYYY-MM-DD')        AS "planDate",
              c.PLAN_DATE_SEQUENCE                      AS "planDateSequence",
              c.LOT_NAME                                AS "lotName",
              c.LINE_CODE                               AS "lineCode",
              F_GET_LINE_NAME(c.LINE_CODE, :organizationId) AS "lineName",
              c.MACHINE                                 AS "machine",
              c.TABLE_ID                                AS "tableId",
              c.LOCATION_CODE                           AS "locationCode",
              c.PCB_ITEM                                AS "pcbItem",
              c.PARTNAME                                AS "partName",
              c.CHIPNAME                                AS "chipName",
              c.SCAN_PARTNAME                           AS "scanPartName",
              c.SCAN_SUPPLIER_PARTNAME                  AS "scanSupplierPartName",
              c.OLD_BARCODE                             AS "oldBarcode",
              c.ITEM_CODE                               AS "itemCode",
              i.ITEM_NAME                               AS "itemName",
              i.ITEM_SPEC                               AS "itemSpec",
              i.MSL_LEVEL                               AS "mslLevel",
              c.CHECK_TYPE                              AS "checkType",
              ct.CODE_MEAN_KOR                          AS "checkTypeName",
              c.CHECK_STATUS                            AS "checkStatus",
              cs.CODE_MEAN_KOR                          AS "checkStatusName",
              c.CHECK_MSG                               AS "checkMsg",
              c.CHECK_BY                                AS "checkBy",
              c.NG_REASON                               AS "ngReason",
              c.NG_TYPE                                 AS "ngType",
              c.COMMENTS                                AS "comments",
              c.LOT_NO                                  AS "lotNo",
              c.LOT_SERIAL                              AS "lotSerial",
              c.SMT_MODEL_NAME                          AS "smtModelName",
              c.RUN_NO                                  AS "runNo",
              c.FEEDER_SHAFT                            AS "feederShaft",
              TO_CHAR(c.VALID_DATE, 'YYYY-MM-DD')       AS "validDate",
              TO_CHAR(c.CCS_END_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "ccsEndDate",
              c.UNLOCK_BY                               AS "unlockBy",
              TO_CHAR(c.UNLOCK_DATE, 'YYYY-MM-DD HH24:MI:SS')  AS "unlockDate",
              b.SCAN_QTY                                AS "scanQty",
              b.SUPPLIER_CODE                           AS "supplierCode",
              b.BARCODE_STATUS                          AS "barcodeStatus",
              b.VENDOR_LOTNO                            AS "vendorLotNo",
              NVL(b.LOT_DIVIDE_YN, 'N')                 AS "lotDivideYn",
              TO_CHAR(b.RECEIPT_COMPARE_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "receiptCompareDate",
              TO_CHAR(b.ISSUE_COMPARE_DATE, 'YYYY-MM-DD HH24:MI:SS')   AS "issueCompareDate"
         FROM IB_SMT_CHECKHIST c
         LEFT JOIN ID_ITEM i ON i.ITEM_CODE = c.PARTNAME
         LEFT JOIN IM_ITEM_RECEIPT_BARCODE b ON b.LOT_NO = c.LOT_NO
         LEFT JOIN ISYS_BASECODE ct
                ON ct.CODE_TYPE = 'CHECK TYPE' AND ct.CODE_NAME = c.CHECK_TYPE
         LEFT JOIN ISYS_BASECODE cs
                ON cs.CODE_TYPE = 'CHECK STATUS' AND cs.CODE_NAME = c.CHECK_STATUS
        WHERE ${this.scanWhere('c')}
        ORDER BY c.CHECK_DATE DESC
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({ ...this.scanBinds(query), organizationId }),
    )) as Row[];
    return { data: rows, total: rows.length, truncated: rows.length >= ROW_LIMIT };
  }

  /**
   * 327 그룹 — 풀체크 회차별로 묶어 시작·종료 시각을 붙인다.
   * PB 는 같은 서브쿼리를 두 번 썼다 (MIN·MAX). 창(window)함수 하나로 바꿨다 —
   * 결과는 같고 IB_SMT_CHECKHIST 를 두 번 더 훑지 않는다.
   */
  async findScanGroup(query: PdaScanQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT TO_CHAR(c.CHECK_DATE, 'YYYY-MM-DD HH24:MI:SS')  AS "checkDate",
              c.CHECK_SEQUENCE                          AS "checkSequence",
              c.FULL_CHECK_SEQUENCE                     AS "fullCheckSequence",
              c.LOT_NAME                                AS "lotName",
              c.LINE_CODE                               AS "lineCode",
              F_GET_LINE_NAME(c.LINE_CODE, :organizationId) AS "lineName",
              c.MACHINE                                 AS "machine",
              c.TABLE_ID                                AS "tableId",
              c.LOCATION_CODE                           AS "locationCode",
              c.PCB_ITEM                                AS "pcbItem",
              c.PARTNAME                                AS "partName",
              c.CHIPNAME                                AS "chipName",
              c.SCAN_PARTNAME                           AS "scanPartName",
              c.SCAN_SUPPLIER_PARTNAME                  AS "scanSupplierPartName",
              c.CHECK_TYPE                              AS "checkType",
              ct.CODE_MEAN_KOR                          AS "checkTypeName",
              c.CHECK_STATUS                            AS "checkStatus",
              cs.CODE_MEAN_KOR                          AS "checkStatusName",
              c.CHECK_MSG                               AS "checkMsg",
              c.CHECK_BY                                AS "checkBy",
              c.NG_REASON                               AS "ngReason",
              c.UNLOCK_BY                               AS "unlockBy",
              TO_CHAR(c.UNLOCK_DATE, 'YYYY-MM-DD HH24:MI:SS')  AS "unlockDate",
              TO_CHAR(c.CCS_END_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "ccsCheckTime",
              TO_CHAR(MIN(c.CHECK_DATE) OVER (
                        PARTITION BY c.LINE_CODE, c.LOT_NAME,
                                     c.FULL_CHECK_SEQUENCE, c.CHECK_TYPE),
                      'YYYY-MM-DD HH24:MI:SS')          AS "fullCheckStartTime",
              TO_CHAR(MAX(c.CHECK_DATE) OVER (
                        PARTITION BY c.LINE_CODE, c.LOT_NAME,
                                     c.FULL_CHECK_SEQUENCE, c.CHECK_TYPE),
                      'YYYY-MM-DD HH24:MI:SS')          AS "fullCheckEndTime"
         FROM IB_SMT_CHECKHIST c
         LEFT JOIN ISYS_BASECODE ct
                ON ct.CODE_TYPE = 'CHECK TYPE' AND ct.CODE_NAME = c.CHECK_TYPE
         LEFT JOIN ISYS_BASECODE cs
                ON cs.CODE_TYPE = 'CHECK STATUS' AND cs.CODE_NAME = c.CHECK_STATUS
        WHERE ${this.scanWhere('c')}
        ORDER BY c.LINE_CODE, c.LOT_NAME, c.FULL_CHECK_SEQUENCE, c.CHECK_DATE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({ ...this.scanBinds(query), organizationId }),
    )) as Row[];
    return { data: rows, total: rows.length, truncated: rows.length >= ROW_LIMIT };
  }

  /**
   * 327 바코드 — 바코드 하나를 세 컬럼에서 한꺼번에 찾는다.
   * PB 원본이 OR 세 개다 (자사·공급처·이전 바코드). 릴을 교환하면 바코드가 바뀌므로
   * 어느 컬럼에 들어갔는지 모른 채 찾아야 한다.
   */
  async findByBarcode(query: BarcodeHistoryQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT TO_CHAR(c.CHECK_DATE, 'YYYY-MM-DD HH24:MI:SS')  AS "checkDate",
              c.LINE_CODE                               AS "lineCode",
              F_GET_LINE_NAME(c.LINE_CODE, :organizationId) AS "lineName",
              c.LOT_NAME                                AS "lotName",
              c.MACHINE                                 AS "machine",
              c.LOCATION_CODE                           AS "locationCode",
              c.PCB_ITEM                                AS "pcbItem",
              c.PARTNAME                                AS "partName",
              c.SCAN_PARTNAME                           AS "scanPartName",
              c.SCAN_SUPPLIER_PARTNAME                  AS "scanSupplierPartName",
              c.OLD_BARCODE                             AS "oldBarcode",
              c.CHECK_TYPE                              AS "checkType",
              ct.CODE_MEAN_KOR                          AS "checkTypeName",
              c.CHECK_STATUS                            AS "checkStatus",
              cs.CODE_MEAN_KOR                          AS "checkStatusName",
              c.LOT_NO                                  AS "lotNo",
              c.RUN_NO                                  AS "runNo",
              c.NG_REASON                               AS "ngReason",
              c.COMMENTS                                AS "comments",
              CASE WHEN c.SCAN_PARTNAME LIKE :barcode ESCAPE '\\' THEN '자사'
                   WHEN c.SCAN_SUPPLIER_PARTNAME LIKE :barcode ESCAPE '\\' THEN '공급처'
                   ELSE '이전' END                       AS "matchedOn"
         FROM IB_SMT_CHECKHIST c
         LEFT JOIN ISYS_BASECODE ct
                ON ct.CODE_TYPE = 'CHECK TYPE' AND ct.CODE_NAME = c.CHECK_TYPE
         LEFT JOIN ISYS_BASECODE cs
                ON cs.CODE_TYPE = 'CHECK STATUS' AND cs.CODE_NAME = c.CHECK_STATUS
        WHERE ( c.SCAN_PARTNAME LIKE :barcode ESCAPE '\\'
                OR c.SCAN_SUPPLIER_PARTNAME LIKE :barcode ESCAPE '\\'
                OR c.OLD_BARCODE LIKE :barcode ESCAPE '\\' )
        ORDER BY c.CHECK_DATE DESC
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({ barcode: likePrefix(query.barcode), organizationId }),
    )) as Row[];
    return { data: rows, total: rows.length, truncated: rows.length >= ROW_LIMIT };
  }

  /** 327 출고 — 그 자재 제조번호의 출고 이력 (PB d_mat_issue_4_pda_scan_lst) */
  async findIssueHistory(query: BarcodeHistoryQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT TO_CHAR(s.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')  AS "issueDate",
              s.ITEM_CODE                               AS "itemCode",
              i.ITEM_NAME                               AS "itemName",
              i.ITEM_SPEC                               AS "itemSpec",
              s.MATERIAL_MFS                            AS "lotNo",
              s.ISSUE_QTY                               AS "issueQty",
              s.ISSUE_DEFICIT                           AS "issueDeficit",
              idf.CODE_MEAN_KOR                         AS "issueDeficitName",
              s.LOCATION_CODE                           AS "locationCode",
              s.LINE_CODE                               AS "lineCode",
              F_GET_LINE_NAME(s.LINE_CODE, :organizationId) AS "lineName",
              s.WORKSTAGE_CODE                          AS "workstageCode",
              s.ENTER_BY                                AS "enterBy"
         FROM IM_ITEM_ISSUE s
         LEFT JOIN ID_ITEM i ON i.ITEM_CODE = s.ITEM_CODE
         LEFT JOIN ISYS_BASECODE idf
                ON idf.CODE_TYPE = 'ISSUE DEFICIT' AND idf.CODE_NAME = s.ISSUE_DEFICIT
        WHERE s.MATERIAL_MFS LIKE :barcode ESCAPE '\\'
          AND s.ORGANIZATION_ID = :organizationId
        ORDER BY s.ENTER_DATE DESC
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({ barcode: likePrefix(query.barcode), organizationId }),
    )) as Row[];
    return { data: rows, total: rows.length, truncated: rows.length >= ROW_LIMIT };
  }

  /**
   * 327 저장 — NG 사유·메모만 바꾼다 (**쓰기**).
   *
   * 키는 라인 + 설비롯트명 + 체크순번 + 체크시각이다. 시각은 불투명 키로 주고받는다
   * (Oracle DATE 를 JSON 으로 내보내면 UTC 로 바뀌어 9시간 틀어진다).
   * 결과를 changed / notFound 두 갈래로 돌려준다.
   */
  async saveCheckNotes(dto: CheckHistNoteBulkDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      let changed = 0;
      let notFound = 0;
      for (const row of dto.rows) {
        const result = await qr.query(
          // IB_SMT_CHECKHIST 에는 LAST_MODIFY_* 컬럼이 없다 (실측 ORA-00904).
          // ENTER_BY/ENTER_DATE 만 있고 그건 스캔한 사람이라 덮어쓰면 안 된다 —
          // 누가 메모를 달았는지는 메모 본문에 남긴다.
          `UPDATE IB_SMT_CHECKHIST
              SET NG_REASON = :ngReason,
                  COMMENTS = :comments
            WHERE LINE_CODE = :lineCode
              AND LOT_NAME = :lotName
              AND CHECK_SEQUENCE = :checkSequence
              AND CHECK_DATE = TO_DATE(:checkDateKey, 'YYYYMMDDHH24MISS')`,
          namedBinds({
            ngReason: row.ngReason ?? null,
            comments: row.comments
              ? `${row.comments} [${userId}]`
              : null,
            lineCode: row.lineCode,
            lotName: row.lotName,
            checkSequence: row.checkSequence,
            checkDateKey: row.checkDateKey,
          }),
        );
        // 영향 행수는 affectedRows 로 읽는다 (TypeORM Oracle 은 DML 결과로 행수 숫자를 준다).
        const affected = Number(affectedRows(result) ?? 0);
        if (affected > 0) changed += affected;
        else notFound += 1;
      }
      return { changed, notFound, total: dto.rows.length };
    });
  }

  // ───────────────────────────────── 328 PDA 검사오류내역조회

  /** 모델 하나의 피더 배치 계획. PB 는 모델명을 등호로 걸었다 (선택도가 충분하다). */
  async findPlanData(query: PlanDataQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT p.MODEL_NAME                              AS "modelName",
              p.MODEL_SUFFIX                            AS "modelSuffix",
              p.LINE_CODE                               AS "lineCode",
              F_GET_LINE_NAME(p.LINE_CODE, :organizationId) AS "lineName",
              p.MACHINE                                 AS "machine",
              p.TABLE_ID                                AS "tableId",
              p.LOCATION_CODE                           AS "locationCode",
              p.PCB_ITEM                                AS "pcbItem",
              p.ITEM_CODE                               AS "itemCode",
              a.ITEM_NAME                               AS "itemName",
              a.ITEM_SPEC                               AS "itemSpec",
              b.ITEM_NAME                               AS "modelItemName",
              p.CHECK_YN                                AS "checkYn",
              p.CHECK_STATUS                            AS "checkStatus",
              p.CCS_YN                                  AS "ccsYn",
              p.ACTIVE_YN                               AS "activeYn",
              p.REVISION                                AS "revision",
              p.REPLACE_YN                              AS "replaceYn",
              p.FEEDING_QTY                             AS "feedingQty",
              p.ENTER_BY                                AS "enterBy",
              TO_CHAR(p.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')       AS "enterDate",
              p.LAST_MODIFY_BY                          AS "lastModifyBy",
              TO_CHAR(p.LAST_MODIFY_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "lastModifyDate"
         FROM IB_PRODUCT_PLANDATA p
         LEFT JOIN ID_ITEM a
                ON a.ITEM_CODE = p.ITEM_CODE AND a.ORGANIZATION_ID = p.ORGANIZATION_ID
         LEFT JOIN ID_ITEM b
                ON b.ITEM_CODE = p.MODEL_NAME AND b.ORGANIZATION_ID = p.ORGANIZATION_ID
        WHERE p.MODEL_NAME = :modelName
          AND NVL(p.LINE_CODE, '*') LIKE :lineCode ESCAPE '\\'
          AND NVL(p.PCB_ITEM, '*') LIKE :pcbItem ESCAPE '\\'
          AND NVL(p.REVISION, '0000') LIKE :revision ESCAPE '\\'
          AND p.ORGANIZATION_ID = :organizationId
        ORDER BY p.LINE_CODE, p.MACHINE, p.TABLE_ID, p.LOCATION_CODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        modelName: query.modelName,
        lineCode: likePrefix(query.lineCode),
        pcbItem: likePrefix(query.pcbItem),
        revision: likePrefix(query.revision),
        organizationId,
      }),
    )) as Row[];
    return { data: rows, total: rows.length, truncated: rows.length >= ROW_LIMIT };
  }

  /** 라인 단위 NG 체크 목록 — 검사가 꺼져 있거나 CCS 를 쓰지 않는 자리를 찾는다. */
  async findLineNgChecks(query: LineCodeQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT p.LINE_CODE                               AS "lineCode",
              F_GET_LINE_NAME(p.LINE_CODE, :organizationId) AS "lineName",
              p.MODEL_NAME                              AS "modelName",
              p.MACHINE                                 AS "machine",
              p.TABLE_ID                                AS "tableId",
              p.LOCATION_CODE                           AS "locationCode",
              p.PCB_ITEM                                AS "pcbItem",
              p.ITEM_CODE                               AS "itemCode",
              i.ITEM_NAME                               AS "itemName",
              p.CHECK_YN                                AS "checkYn",
              p.CHECK_STATUS                            AS "checkStatus",
              p.CCS_YN                                  AS "ccsYn",
              p.ACTIVE_YN                               AS "activeYn",
              p.FEEDING_QTY                             AS "feedingQty",
              p.LAST_MODIFY_BY                          AS "lastModifyBy",
              TO_CHAR(p.LAST_MODIFY_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "lastModifyDate"
         FROM IB_PRODUCT_PLANDATA p
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = p.ITEM_CODE AND i.ORGANIZATION_ID = p.ORGANIZATION_ID
        WHERE p.LINE_CODE = :lineCode
          AND p.ACTIVE_YN = 'Y'
          AND p.ORGANIZATION_ID = :organizationId
        ORDER BY p.MACHINE, p.TABLE_ID, p.LOCATION_CODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({ lineCode: query.lineCode, organizationId }),
    )) as Row[];
    return { data: rows, total: rows.length, truncated: rows.length >= ROW_LIMIT };
  }

  /** 328 워크플로 — 모델의 피더 배치 이미지(BOM 이미지)와 맞춰 본다 */
  async findWorkflow(query: PlanDataQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT p.MODEL_NAME                              AS "modelName",
              p.LINE_CODE                               AS "lineCode",
              p.MACHINE                                 AS "machine",
              p.TABLE_ID                                AS "tableId",
              p.LOCATION_CODE                           AS "locationCode",
              p.PCB_ITEM                                AS "pcbItem",
              p.ITEM_CODE                               AS "itemCode",
              p.CHECK_YN                                AS "checkYn",
              p.CCS_YN                                  AS "ccsYn",
              b.MODEL_IMAGE                             AS "modelImage",
              b.MODEL_COMMENTS                          AS "modelComments"
         FROM IB_PRODUCT_PLANDATA p
         JOIN IB_SMT_BOM_IMAGE b ON b.MODEL_NAME = p.MODEL_NAME
        WHERE p.MODEL_NAME = :modelName
          AND NVL(p.LINE_CODE, '*') LIKE :lineCode ESCAPE '\\'
          AND NVL(p.PCB_ITEM, '*') LIKE :pcbItem ESCAPE '\\'
          AND p.ORGANIZATION_ID = :organizationId
        ORDER BY p.LINE_CODE, p.MACHINE, p.LOCATION_CODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        modelName: query.modelName,
        lineCode: likePrefix(query.lineCode),
        pcbItem: likePrefix(query.pcbItem),
        organizationId,
      }),
    )) as Row[];
    return { data: rows, total: rows.length, truncated: rows.length >= ROW_LIMIT };
  }

  /**
   * 328 저장 — 검사 플래그만 바꾼다 (**쓰기**).
   *
   * 키가 7컬럼이다 (실측 XPKIB_PRODUCT_PLANDATA = MODEL_NAME + LINE_CODE +
   * LOCATION_CODE + ITEM_CODE + MACHINE + TABLE_ID + PCB_ITEM). 일부만 넣으면
   * 같은 위치의 다른 설비·테이블 계획까지 함께 바뀐다.
   */
  async savePlanCheckFlags(
    dto: PlanCheckFlagBulkDto,
    organizationId: number,
    userId: string,
  ) {
    return this.tx.run(async (qr) => {
      let changed = 0;
      let notFound = 0;
      for (const row of dto.rows) {
        const result = await qr.query(
          `UPDATE IB_PRODUCT_PLANDATA
              SET CHECK_YN = NVL(:checkYn, CHECK_YN),
                  CHECK_STATUS = NVL(:checkStatus, CHECK_STATUS),
                  CCS_YN = NVL(:ccsYn, CCS_YN),
                  LAST_MODIFY_BY = :userId,
                  LAST_MODIFY_DATE = SYSDATE
            WHERE MODEL_NAME = :modelName
              AND LINE_CODE = :lineCode
              AND LOCATION_CODE = :locationCode
              AND ITEM_CODE = :itemCode
              AND MACHINE = :machine
              AND TABLE_ID = :tableId
              AND PCB_ITEM = :pcbItem
              AND ORGANIZATION_ID = :organizationId`,
          namedBinds({
            checkYn: row.checkYn ?? null,
            checkStatus: row.checkStatus ?? null,
            ccsYn: row.ccsYn ?? null,
            userId,
            modelName: row.modelName,
            lineCode: row.lineCode,
            locationCode: row.locationCode,
            itemCode: row.itemCode,
            machine: row.machine,
            tableId: row.tableId,
            pcbItem: row.pcbItem,
            organizationId,
          }),
        );
        const affected = Number(affectedRows(result) ?? 0);
        if (affected > 0) changed += affected;
        else notFound += 1;
      }
      return { changed, notFound, total: dto.rows.length };
    });
  }
}
