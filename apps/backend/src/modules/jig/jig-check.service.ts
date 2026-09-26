/**
 * @file src/modules/jig/jig-check.service.ts
 * @description 지그 검사·수리·출고·보전·샘플 조회 — PB DataWindow 의 retrieve 를 옮긴다.
 *
 * 원본 화면:
 *   w_mcn_jig_squeeze_check_master       (d_mcn_jig_squeze_check_mlst)
 *   w_mcn_jig_mask_tension_check_master  (d_mcn_jig_mask_check_lst)
 *   w_mcn_jig_squeeze_clean_check_master (d_mcn_jig_mask_check_lst + squeze_mlst)
 *   w_mcn_jig_repair_request_master      (d_mcn_jig_repair_request_lst)
 *   w_mcn_jig_repair_master              (d_mcn_jig_repair_lst)
 *   w_mcn_jig_issue_master               (d_mcn_jig_issue_lst)
 *   w_mcn_jig_pm_master                  (d_mcn_jig_pm_plan_lst)
 *   w_mcn_sample_master                  (d_mcn_sample_lst)
 *
 * DataWindow 가 pbselect 포맷(실행 가능한 SQL 이 아님)인 것은 테이블·컬럼 목록을 근거로
 * SQL 을 새로 썼다. 조건과 인자는 PB 의 retrieve arguments 를 그대로 따른다.
 * PB 규약대로 문자열 조건은 `값 + '%'` LIKE 다 — 빈 값이면 전체 조회.
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { TransactionService } from '../../shared/transaction.service';
import {
  JigIssueQueryDto,
  JigPmQueryDto,
  JigRepairQueryDto,
  JigScanLookupDto,
  MaskCheckQueryDto,
  MaskTensionSaveDto,
  SampleApplyModelQueryDto,
  SampleMasterQueryDto,
  SqueezeCheckQueryDto,
  SqueezeScanDto,
} from './jig-check.dto';

type OracleRow = Record<string, unknown>;

const DEFAULT_LIMIT = 500;

@Injectable()
export class JigCheckService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  private like(value?: string): string {
    return `${(value ?? '').trim()}%`;
  }

  private async page(body: string, orderBy: string, binds: OracleRow, page: number, limit: number) {
    const totals = await this.dataSource.query(
      `SELECT COUNT(*) AS "total" FROM (${body}) source_rows`,
      { ...binds } as unknown as unknown[],
    ) as OracleRow[];
    const rows = await this.dataSource.query(
      `${body} ${orderBy} OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`,
      { ...binds, offset: (page - 1) * limit, limit } as unknown as unknown[],
    ) as OracleRow[];
    return { data: rows, total: Number(totals[0]?.total ?? 0), page, limit };
  }

  /** 라인·검사상태 이름 조인 — 그리드에 원시 코드만 나가지 않게 한다 */
  private checkNameJoins(alias: string) {
    return `
      LEFT JOIN IP_PRODUCT_LINE ln
             ON ln.LINE_CODE = ${alias}.LINE_CODE AND ln.ORGANIZATION_ID = ${alias}.ORGANIZATION_ID
      LEFT JOIN ISYS_BASECODE cs
             ON cs.CODE_TYPE = 'JIG CHECK STATUS' AND cs.CODE_NAME = ${alias}.JIG_CHECK_STATUS
            AND cs.ORGANIZATION_ID = ${alias}.ORGANIZATION_ID
      LEFT JOIN ISYS_BASECODE cf
             ON cf.CODE_TYPE = 'CONFIRM YN' AND cf.CODE_NAME = ${alias}.CONFIRM_YN
            AND cf.ORGANIZATION_ID = ${alias}.ORGANIZATION_ID
      LEFT JOIN IMCN_JIG j
             ON j.JIG_CODE = ${alias}.JIG_CODE AND j.JIG_LOT_NO = ${alias}.JIG_LOT_NO
            AND j.ORGANIZATION_ID = ${alias}.ORGANIZATION_ID`;
  }

  /** 스퀴즈검사관리 — PB d_mcn_jig_squeze_check_mlst */
  async findSqueezeChecks(query: SqueezeCheckQueryDto, organizationId: number) {
    const binds = {
      organizationId,
      dateFrom: query.dateFrom ?? '1900-01-01',
      dateTo: query.dateTo ?? '2999-12-31',
      jigLotNo: this.like(query.jigLotNo),
      lineCode: this.like(query.lineCode),
      jigCheckStatus: this.like(query.jigCheckStatus),
    };
    const body = `
      SELECT c.JIG_CODE AS "jigCode", c.JIG_LOT_NO AS "jigLotNo",
             c.JIG_CHECK_SEQUENCE AS "jigCheckSequence", c.JIG_CHECK_DATE AS "jigCheckDate",
             c.JIG_CHECK_STATUS AS "jigCheckStatus", cs.CODE_MEAN_KOR AS "jigCheckStatusName",
             c.LINE_CODE AS "lineCode", ln.LINE_NAME AS "lineName",
             c.CLEAN_YN AS "cleanYn", c.PIN_HOLE_YN AS "pinHoleYn",
             c.AIR_PRESS_VALUE AS "airPressValue",
             c.BREAK_VALUE AS "breakValue", c.HIT_VALUE AS "hitValue",
             c.USED_BY AS "usedBy",
             c.CONFIRM_YN AS "confirmYn", cf.CODE_MEAN_KOR AS "confirmYnName",
             c.CONFIRM_DATE AS "confirmDate", c.COMMENTS AS "comments",
             j.JIG_NAME AS "jigName", j.JIG_SPEC AS "jigSpec",
             c.ENTER_BY AS "enterBy", c.ENTER_DATE AS "enterDate",
             c.LAST_MODIFY_BY AS "lastModifyBy", c.LAST_MODIFY_DATE AS "lastModifyDate"
        FROM IMCN_JIG_SQUEZE_CHECK c
        ${this.checkNameJoins('c')}
       WHERE NVL(c.JIG_LOT_NO, '*') LIKE :jigLotNo
         AND NVL(c.LINE_CODE, '*') LIKE :lineCode
         AND NVL(c.JIG_CHECK_STATUS, '*') LIKE :jigCheckStatus
         AND c.JIG_CHECK_DATE >= TRUNC(TO_DATE(:dateFrom, 'YYYY-MM-DD'))
         AND c.JIG_CHECK_DATE < TRUNC(TO_DATE(:dateTo, 'YYYY-MM-DD')) + 1
         AND c.ORGANIZATION_ID = :organizationId`;
    return this.page(body, 'ORDER BY "jigCheckDate" DESC, "jigCode", "jigCheckSequence"',
      binds, query.page ?? 1, query.limit ?? DEFAULT_LIMIT);
  }

  /**
   * 메탈마스크 텐션·세척 검사 — PB d_mcn_jig_mask_check_lst.
   * modelName 을 주면 PB 처럼 적용모델(IMCN_JIG_APPLY_MODEL) 서브쿼리로 거른다.
   */
  async findMaskChecks(query: MaskCheckQueryDto, organizationId: number) {
    const binds: OracleRow = {
      organizationId,
      dateFrom: query.dateFrom ?? '1900-01-01',
      dateTo: query.dateTo ?? '2999-12-31',
      jigLotNo: this.like(query.jigLotNo),
      lineCode: this.like(query.lineCode),
      jigCheckStatus: this.like(query.jigCheckStatus),
    };
    let modelFilter = '';
    if (query.modelName?.trim()) {
      binds.modelName = this.like(query.modelName);
      modelFilter = `
         AND c.JIG_LOT_NO IN (SELECT JIG_LOT_NO FROM IMCN_JIG_APPLY_MODEL
                               WHERE JIG_LOT_NO LIKE :jigLotNo AND ITEM_CODE LIKE :modelName)`;
    }
    const body = `
      SELECT c.JIG_CODE AS "jigCode", c.JIG_LOT_NO AS "jigLotNo",
             c.JIG_CHECK_SEQUENCE AS "jigCheckSequence", c.JIG_CHECK_DATE AS "jigCheckDate",
             c.JIG_CHECK_STATUS AS "jigCheckStatus", cs.CODE_MEAN_KOR AS "jigCheckStatusName",
             c.JIG_CHECK_TYPE AS "jigCheckType",
             c.LINE_CODE AS "lineCode", ln.LINE_NAME AS "lineName",
             c.CLEAN_YN AS "cleanYn",
             c.TENSION_CHECK1 AS "tensionCheck1", c.TENSION_CHECK2 AS "tensionCheck2",
             c.TENSION_CHECK3 AS "tensionCheck3", c.TENSION_CHECK4 AS "tensionCheck4",
             c.TENSION_CHECK5 AS "tensionCheck5", c.MAX_TENSION AS "maxTension",
             c.TENSION_CHECK1_EXT AS "tensionCheck1Ext", c.TENSION_CHECK2_EXT AS "tensionCheck2Ext",
             c.TENSION_CHECK3_EXT AS "tensionCheck3Ext", c.TENSION_CHECK4_EXT AS "tensionCheck4Ext",
             c.TENSION_CHECK5_EXT AS "tensionCheck5Ext", c.TENSION_CHECK6_EXT AS "tensionCheck6Ext",
             c.USED_QTY AS "usedQty", c.ACTUAL_VALUE AS "actualValue",
             c.BREAK_VALUE AS "breakValue", c.HIT_VALUE AS "hitValue",
             c.USED_BY AS "usedBy", c.RETURN_BY AS "returnBy",
             c.CONFIRM_YN AS "confirmYn", cf.CODE_MEAN_KOR AS "confirmYnName",
             c.CONFIRM_DATE AS "confirmDate", c.COMMENTS AS "comments",
             j.JIG_NAME AS "jigName", j.JIG_SPEC AS "jigSpec",
             j.MIN_TENSION AS "jigMinTension", j.MAX_TENSION AS "jigMaxTension",
             c.ENTER_BY AS "enterBy", c.ENTER_DATE AS "enterDate",
             c.LAST_MODIFY_BY AS "lastModifyBy", c.LAST_MODIFY_DATE AS "lastModifyDate"
        FROM IMCN_JIG_MASK_CHECK c
        ${this.checkNameJoins('c')}
       WHERE NVL(c.JIG_LOT_NO, '*') LIKE :jigLotNo
         AND NVL(c.LINE_CODE, '*') LIKE :lineCode
         AND NVL(c.JIG_CHECK_STATUS, '*') LIKE :jigCheckStatus
         AND c.JIG_CHECK_DATE >= TRUNC(TO_DATE(:dateFrom, 'YYYY-MM-DD'))
         AND c.JIG_CHECK_DATE < TRUNC(TO_DATE(:dateTo, 'YYYY-MM-DD')) + 1
         AND c.ORGANIZATION_ID = :organizationId${modelFilter}`;
    return this.page(body, 'ORDER BY "jigCheckDate" DESC, "jigCode", "jigCheckSequence"',
      binds, query.page ?? 1, query.limit ?? DEFAULT_LIMIT);
  }

  /** 지그수리 — PB d_mcn_jig_repair_lst / d_mcn_jig_repair_request_lst (같은 테이블) */
  async findRepairs(query: JigRepairQueryDto, organizationId: number) {
    const binds = {
      organizationId,
      dateFrom: query.dateFrom ?? '1900-01-01',
      dateTo: query.dateTo ?? '2999-12-31',
      jigCode: this.like(query.jigCode),
      repairStatus: this.like(query.repairStatus),
      repairVendorCode: this.like(query.repairVendorCode),
    };
    const body = `
      SELECT r.JIG_CODE AS "jigCode", r.JIG_LOT_NO AS "jigLotNo",
             r.REPAIR_SEQUENCE AS "repairSequence",
             r.REPAIR_STATUS AS "repairStatus", rs.CODE_MEAN_KOR AS "repairStatusName",
             r.REPAIR_REASON_CODE AS "repairReasonCode", rc.CODE_MEAN_KOR AS "repairReasonName",
             r.REPAIR_REQUEST_DATE AS "repairRequestDate", r.REPAIR_DATE AS "repairDate",
             r.REPAIR_TIME AS "repairTime", r.REPAIR_BY AS "repairBy",
             r.REPAIR_VENDOR_CODE AS "repairVendorCode", rv.CODE_MEAN_KOR AS "repairVendorName",
             r.REPAIR_AMT AS "repairAmt", r.CURRENCY AS "currency",
             r.COMMENTS AS "comments", r.REPAIR_COMMENTS AS "repairComments",
             j.JIG_NAME AS "jigName", j.JIG_TYPE AS "jigType", tp.CODE_MEAN_KOR AS "jigTypeName",
             r.ENTER_BY AS "enterBy", r.ENTER_DATE AS "enterDate",
             r.LAST_MODIFY_BY AS "lastModifyBy", r.LAST_MODIFY_DATE AS "lastModifyDate"
        FROM IMCN_JIG_REPAIR r
        LEFT JOIN IMCN_JIG j
               ON j.JIG_CODE = r.JIG_CODE AND j.JIG_LOT_NO = r.JIG_LOT_NO
              AND j.ORGANIZATION_ID = r.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE rs
               ON rs.CODE_TYPE = 'REPAIR STATUS' AND rs.CODE_NAME = r.REPAIR_STATUS
              AND rs.ORGANIZATION_ID = r.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE rc
               ON rc.CODE_TYPE = 'REPAIR REASON CODE' AND rc.CODE_NAME = r.REPAIR_REASON_CODE
              AND rc.ORGANIZATION_ID = r.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE rv
               ON rv.CODE_TYPE = 'REPAIR VENDOR CODE' AND rv.CODE_NAME = r.REPAIR_VENDOR_CODE
              AND rv.ORGANIZATION_ID = r.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE tp
               ON tp.CODE_TYPE = 'JIG TYPE' AND tp.CODE_NAME = j.JIG_TYPE
              AND tp.ORGANIZATION_ID = r.ORGANIZATION_ID
       WHERE r.JIG_CODE LIKE :jigCode
         AND NVL(r.REPAIR_STATUS, '*') LIKE :repairStatus
         AND NVL(r.REPAIR_VENDOR_CODE, '*') LIKE :repairVendorCode
         AND r.REPAIR_REQUEST_DATE >= TRUNC(TO_DATE(:dateFrom, 'YYYY-MM-DD'))
         AND r.REPAIR_REQUEST_DATE < TRUNC(TO_DATE(:dateTo, 'YYYY-MM-DD')) + 1
         AND r.ORGANIZATION_ID = :organizationId`;
    return this.page(body, 'ORDER BY "repairRequestDate" DESC, "jigCode", "repairSequence"',
      binds, query.page ?? 1, query.limit ?? DEFAULT_LIMIT);
  }

  /** 지그출고관리 — PB d_mcn_jig_issue_lst */
  async findIssues(query: JigIssueQueryDto, organizationId: number) {
    const binds = {
      organizationId,
      dateFrom: query.dateFrom ?? '1900-01-01',
      dateTo: query.dateTo ?? '2999-12-31',
      jigCode: this.like(query.jigCode),
      jigType: this.like(query.jigType),
      issueStatus: this.like(query.issueStatus),
    };
    const body = `
      SELECT i.ISSUE_DATE AS "issueDate", i.ISSUE_SEQUENCE AS "issueSequence",
             i.JIG_CODE AS "jigCode", i.JIG_LOT_NO AS "jigLotNo",
             i.ISSUE_DEFICIT AS "issueDeficit", dfc.CODE_MEAN_KOR AS "issueDeficitName",
             i.ISSUE_QTY AS "issueQty",
             i.ISSUE_STATUS AS "issueStatus", sts.CODE_MEAN_KOR AS "issueStatusName",
             i.ISSUE_ACCOUNT AS "issueAccount", acc.CODE_MEAN_KOR AS "issueAccountName",
             i.WORKSTAGE_CODE AS "workstageCode", ws.WORKSTAGE_NAME AS "workstageName",
             i.MACHINE_CODE AS "machineCode",
             j.JIG_NAME AS "jigName", j.JIG_TYPE AS "jigType", tp.CODE_MEAN_KOR AS "jigTypeName",
             i.ENTER_BY AS "enterBy", i.ENTER_DATE AS "enterDate",
             i.LAST_MODIFY_BY AS "lastModifyBy", i.LAST_MODIFY_DATE AS "lastModifyDate"
        FROM IMCN_JIG_ISSUE i
        LEFT JOIN IMCN_JIG j
               ON j.JIG_CODE = i.JIG_CODE AND j.JIG_LOT_NO = i.JIG_LOT_NO
              AND j.ORGANIZATION_ID = i.ORGANIZATION_ID
        LEFT JOIN IP_PRODUCT_WORKSTAGE ws
               ON ws.WORKSTAGE_CODE = i.WORKSTAGE_CODE AND ws.ORGANIZATION_ID = i.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE dfc
               ON dfc.CODE_TYPE = 'ISSUE DEFICIT' AND dfc.CODE_NAME = i.ISSUE_DEFICIT
              AND dfc.ORGANIZATION_ID = i.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE sts
               ON sts.CODE_TYPE = 'ISSUE STATUS' AND sts.CODE_NAME = i.ISSUE_STATUS
              AND sts.ORGANIZATION_ID = i.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE acc
               ON acc.CODE_TYPE = 'JIG ISSUE ACCOUNT' AND acc.CODE_NAME = i.ISSUE_ACCOUNT
              AND acc.ORGANIZATION_ID = i.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE tp
               ON tp.CODE_TYPE = 'JIG TYPE' AND tp.CODE_NAME = j.JIG_TYPE
              AND tp.ORGANIZATION_ID = i.ORGANIZATION_ID
       WHERE i.JIG_CODE LIKE :jigCode
         AND NVL(j.JIG_TYPE, '*') LIKE :jigType
         AND NVL(i.ISSUE_STATUS, '*') LIKE :issueStatus
         AND i.ISSUE_DATE >= TRUNC(TO_DATE(:dateFrom, 'YYYY-MM-DD'))
         AND i.ISSUE_DATE < TRUNC(TO_DATE(:dateTo, 'YYYY-MM-DD')) + 1
         AND i.ORGANIZATION_ID = :organizationId`;
    return this.page(body, 'ORDER BY "issueDate" DESC, "issueSequence"',
      binds, query.page ?? 1, query.limit ?? DEFAULT_LIMIT);
  }

  /** 지그자주보전관리 — PB d_mcn_jig_pm_plan_lst */
  async findPmPlans(query: JigPmQueryDto, organizationId: number) {
    const binds = {
      organizationId,
      lineCode: this.like(query.lineCode),
      jigCode: this.like(query.jigCode),
      jigLotNo: this.like(query.jigLotNo),
      pmType: this.like(query.pmType),
      confirmYn: this.like(query.confirmYn),
    };
    const body = `
      SELECT p.LINE_CODE AS "lineCode", ln.LINE_NAME AS "lineName",
             p.JIG_CODE AS "jigCode", p.JIG_LOT_NO AS "jigLotNo",
             p.PM_TYPE AS "pmType", pt.CODE_MEAN_KOR AS "pmTypeName",
             p.PM_DIVISION AS "pmDivision", pd.CODE_MEAN_KOR AS "pmDivisionName",
             p.PLAN_DATE AS "planDate", p.PM_DATE AS "pmDate",
             p.BREAK_VALUE AS "breakValue", p.HIT_VALUE AS "hitValue",
             p.CONFIRM_YN AS "confirmYn", cf.CODE_MEAN_KOR AS "confirmYnName",
             p.CONFIRM_BY AS "confirmBy", p.CHARGER AS "charger", p.COMMENTS AS "comments",
             j.JIG_NAME AS "jigName",
             p.ENTER_BY AS "enterBy", p.ENTER_DATE AS "enterDate",
             p.LAST_MODIFY_BY AS "lastModifyBy", p.LAST_MODIFY_DATE AS "lastModifyDate"
        FROM IMCN_JIG_PM_MASTER p
        LEFT JOIN IMCN_JIG j
               ON j.JIG_CODE = p.JIG_CODE AND j.JIG_LOT_NO = p.JIG_LOT_NO
              AND j.ORGANIZATION_ID = p.ORGANIZATION_ID
        LEFT JOIN IP_PRODUCT_LINE ln
               ON ln.LINE_CODE = p.LINE_CODE AND ln.ORGANIZATION_ID = p.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE pt
               ON pt.CODE_TYPE = 'PM TYPE' AND pt.CODE_NAME = p.PM_TYPE
              AND pt.ORGANIZATION_ID = p.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE pd
               ON pd.CODE_TYPE = 'PM DIVISION' AND pd.CODE_NAME = p.PM_DIVISION
              AND pd.ORGANIZATION_ID = p.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE cf
               ON cf.CODE_TYPE = 'CONFIRM YN' AND cf.CODE_NAME = p.CONFIRM_YN
              AND cf.ORGANIZATION_ID = p.ORGANIZATION_ID
       WHERE NVL(p.LINE_CODE, '*') LIKE :lineCode
         AND p.JIG_CODE LIKE :jigCode
         AND NVL(p.JIG_LOT_NO, '*') LIKE :jigLotNo
         AND NVL(p.PM_TYPE, '*') LIKE :pmType
         AND NVL(p.CONFIRM_YN, '*') LIKE :confirmYn
         AND p.ORGANIZATION_ID = :organizationId`;
    return this.page(body, 'ORDER BY "planDate" DESC, "jigCode", "jigLotNo"',
      binds, query.page ?? 1, query.limit ?? DEFAULT_LIMIT);
  }

  /**
   * 샘플마스터 관리 — PB d_mcn_sample_lst.
   * 잔여일 = 적용일 + 유효개월 - 오늘. PB 는 이 값이 arg_remain_days 이하인 것만 본다.
   */
  async findSamples(query: SampleMasterQueryDto, organizationId: number) {
    const binds = {
      organizationId,
      sampleCode: this.like(query.sampleCode),
      sampleName: this.like(query.sampleName),
      sampleType: this.like(query.sampleType),
      sampleStatus: this.like(query.sampleStatus),
      useStatus: this.like(query.useStatus),
      locationAddress: this.like(query.locationAddress),
      remainDays: query.remainDays ?? 10000,
    };
    const body = `
      SELECT s.SAMPLE_CODE AS "sampleCode", s.SAMPLE_LOT_NO AS "sampleLotNo",
             s.SAMPLE_NAME AS "sampleName", s.SAMPLE_SPEC AS "sampleSpec",
             s.SAMPLE_TYPE AS "sampleType", tp.CODE_MEAN_KOR AS "sampleTypeName",
             s.SAMPLE_STATUS AS "sampleStatus", st.CODE_MEAN_KOR AS "sampleStatusName",
             s.SAMPLE_SECTION AS "sampleSection", sc.CODE_MEAN_KOR AS "sampleSectionName",
             s.SAMPLE_GRADE AS "sampleGrade",
             s.USE_STATUS AS "useStatus", us.CODE_MEAN_KOR AS "useStatusName",
             s.SAMPLE_APPLY_DATE AS "sampleApplyDate", s.VALID_MONTHS AS "validMonths",
             NVL(TRUNC(ADD_MONTHS(s.SAMPLE_APPLY_DATE, s.VALID_MONTHS) - SYSDATE), 0) AS "remainDays",
             ADD_MONTHS(s.SAMPLE_APPLY_DATE, NVL(s.VALID_MONTHS, 0)) AS "expireDate",
             s.LINE_CODE AS "lineCode", ln.LINE_NAME AS "lineName",
             s.WORKSTAGE_CODE AS "workstageCode", ws.WORKSTAGE_NAME AS "workstageName",
             s.MODEL_NAME AS "modelName", s.SAMPLE_BARCODE AS "sampleBarcode",
             s.LOCATION_ADDRESS AS "locationAddress",
             s.MANAGEMENT_COMMNETS AS "managementCommnets", s.USE_NSNP_YN AS "useNsnpYn",
             s.ENTER_BY AS "enterBy", s.ENTER_DATE AS "enterDate",
             s.LAST_MODIFY_BY AS "lastModifyBy", s.LAST_MODIFY_DATE AS "lastModifyDate"
        FROM IMCN_SAMPLE s
        LEFT JOIN IP_PRODUCT_LINE ln
               ON ln.LINE_CODE = s.LINE_CODE AND ln.ORGANIZATION_ID = s.ORGANIZATION_ID
        LEFT JOIN IP_PRODUCT_WORKSTAGE ws
               ON ws.WORKSTAGE_CODE = s.WORKSTAGE_CODE AND ws.ORGANIZATION_ID = s.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE tp
               ON tp.CODE_TYPE = 'SAMPLE TYPE' AND tp.CODE_NAME = s.SAMPLE_TYPE
              AND tp.ORGANIZATION_ID = s.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE st
               ON st.CODE_TYPE = 'SAMPLE STATUS' AND st.CODE_NAME = s.SAMPLE_STATUS
              AND st.ORGANIZATION_ID = s.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE sc
               ON sc.CODE_TYPE = 'SAMPLE SECTION' AND sc.CODE_NAME = s.SAMPLE_SECTION
              AND sc.ORGANIZATION_ID = s.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE us
               ON us.CODE_TYPE = 'USE STATUS' AND us.CODE_NAME = s.USE_STATUS
              AND us.ORGANIZATION_ID = s.ORGANIZATION_ID
       WHERE s.SAMPLE_CODE LIKE :sampleCode
         AND NVL(s.SAMPLE_NAME, '*') LIKE :sampleName
         AND s.SAMPLE_TYPE LIKE :sampleType
         AND NVL(s.SAMPLE_STATUS, '*') LIKE :sampleStatus
         AND NVL(s.USE_STATUS, '*') LIKE :useStatus
         AND NVL(s.LOCATION_ADDRESS, '*') LIKE :locationAddress
         AND NVL(TRUNC(ADD_MONTHS(s.SAMPLE_APPLY_DATE, s.VALID_MONTHS) - SYSDATE), 0) <= :remainDays
         AND s.ORGANIZATION_ID = :organizationId`;
    return this.page(body, 'ORDER BY "remainDays", "sampleCode", "sampleLotNo"',
      binds, query.page ?? 1, query.limit ?? DEFAULT_LIMIT);
  }

  /** 샘플별 적용모델 — PB d_mcn_sample_apply_model_lst */
  async findSampleApplyModels(query: SampleApplyModelQueryDto, organizationId: number) {
    return this.dataSource.query(
      `SELECT SAMPLE_CODE AS "sampleCode", SAMPLE_LOT_NO AS "sampleLotNo",
              ITEM_CODE AS "itemCode", APPLY_SMT_MODEL_NAME AS "applySmtModelName",
              ENTER_BY AS "enterBy", ENTER_DATE AS "enterDate"
         FROM IMCN_SAMPLE_APPLY_MODEL
        WHERE SAMPLE_CODE = :sampleCode AND SAMPLE_LOT_NO = :sampleLotNo
          AND ORGANIZATION_ID = :organizationId
        ORDER BY ITEM_CODE`,
      { sampleCode: query.sampleCode, sampleLotNo: query.sampleLotNo, organizationId } as unknown as unknown[],
    ) as Promise<OracleRow[]>;
  }

  /**
   * 스캔한 지그LOT 의 기준정보 — PB 가 스캔 직후 화면에 채우던 값들.
   * 현장 스캐너는 키보드 방식이라 값은 그냥 입력 문자열로 들어온다.
   */
  async lookupByScan(query: JigScanLookupDto, organizationId: number) {
    const rows = await this.dataSource.query(
      `SELECT j.JIG_CODE AS "jigCode", j.JIG_LOT_NO AS "jigLotNo", j.JIG_NAME AS "jigName",
              j.JIG_TYPE AS "jigType", j.JIG_SPEC AS "jigSpec",
              j.BREAK_VALUE AS "breakValue", j.HIT_VALUE AS "hitValue",
              j.MIN_TENSION AS "minTension", j.MAX_TENSION AS "maxTension",
              j.USE_STATUS AS "useStatus", j.TENSION_CHECK_YN AS "tensionCheckYn",
              j.LINE_CODE AS "lineCode", ln.LINE_NAME AS "lineName",
              (SELECT MAX(m.JIG_CHECK_DATE) FROM IMCN_JIG_MASK_CHECK m
                WHERE m.JIG_LOT_NO = j.JIG_LOT_NO AND m.CLEAN_YN = 'Y'
                  AND m.ORGANIZATION_ID = j.ORGANIZATION_ID) AS "lastCleanDate"
         FROM IMCN_JIG j
         LEFT JOIN IP_PRODUCT_LINE ln
                ON ln.LINE_CODE = j.LINE_CODE AND ln.ORGANIZATION_ID = j.ORGANIZATION_ID
        WHERE j.JIG_LOT_NO = :jigLotNo
          AND j.JIG_TYPE = :jigType
          AND j.ORGANIZATION_ID = :organizationId`,
      { jigLotNo: query.jigLotNo.trim(), jigType: query.jigType, organizationId } as unknown as unknown[],
    ) as OracleRow[];
    if (rows.length === 0) throw new BadRequestException('등록되지 않은 바코드입니다.');
    return rows[0];
  }

  /**
   * 스퀴즈 검사 스캔 등록 — PKG_MES_MAC.SP_SQUEEZE_CHECK_SCAN.
   * 조회·판정·등록·지그상태 변경이 DB 프로시저 한 번에 돈다 (PB 와 같은 로직).
   */
  async registerSqueezeScan(dto: SqueezeScanDto, organizationId: number, userId: string) {
    const jigLotNo = dto.jigLotNo.trim();
    if (!jigLotNo) throw new BadRequestException('바코드를 입력하세요.');
    return this.tx.run(async (qr) => {
      // OUT 바인드를 쓰면 서비스가 oracledb 드라이버를 직접 import 해야 하므로,
      // 실패는 Oracle 오류로 던지게 하고 판정 결과는 저장된 행을 다시 읽어 확인한다.
      await qr.query(
        `DECLARE
           v_result NUMBER;
         BEGIN
           PKG_MES_MAC.SP_SQUEEZE_CHECK_SCAN(:jigLotNo, :organizationId, :userId, v_result);
           IF v_result < 0 THEN
             RAISE_APPLICATION_ERROR(-20003, 'SQUEEZE_SCAN_FAILED:' || v_result);
           END IF;
         END;`,
        { jigLotNo, organizationId, userId } as unknown as unknown[],
      ).catch((error: unknown) => {
        const message = error instanceof Error ? error.message : String(error);
        if (/SQUEEZE_SCAN_FAILED/.test(message)) {
          throw new BadRequestException('등록되지 않은 스퀴즈 바코드입니다.');
        }
        throw error;
      });
      // 방금 넣은 행을 다시 읽어 판정 결과를 돌려준다
      const saved = await qr.query(
        `SELECT * FROM (
           SELECT JIG_CHECK_STATUS AS "jigCheckStatus", JIG_CHECK_SEQUENCE AS "jigCheckSequence",
                  BREAK_VALUE AS "breakValue", HIT_VALUE AS "hitValue"
             FROM IMCN_JIG_SQUEZE_CHECK
            WHERE JIG_LOT_NO = :jigLotNo AND ORGANIZATION_ID = :organizationId
            ORDER BY JIG_CHECK_DATE DESC, JIG_CHECK_SEQUENCE DESC
         ) WHERE ROWNUM = 1`,
        { jigLotNo, organizationId } as unknown as unknown[],
      ) as OracleRow[];
      return saved[0] ?? {};
    });
  }

  /** 메탈마스크 장력검사 등록 — PKG_MES_MAC.SP_MASK_TENSION_CHECK */
  async registerMaskTension(dto: MaskTensionSaveDto, organizationId: number, userId: string) {
    const jigLotNo = dto.jigLotNo.trim();
    if (!jigLotNo) throw new BadRequestException('바코드를 입력하세요.');
    return this.tx.run(async (qr) => {
      await qr.query(
        `DECLARE
           v_result NUMBER;
         BEGIN
           PKG_MES_MAC.SP_MASK_TENSION_CHECK(:jigLotNo, :checkStatus, :cleanYn,
             :tension1, :tension2, :tension3, :tension4, :tension5,
             :comments, :organizationId, :userId, v_result);
           IF v_result < 0 THEN
             RAISE_APPLICATION_ERROR(-20004, 'MASK_TENSION_FAILED:' || v_result);
           END IF;
         END;`,
        {
          jigLotNo,
          checkStatus: dto.checkStatus,
          cleanYn: dto.cleanYn ?? 'N',
          tension1: dto.tension1 ?? null,
          tension2: dto.tension2 ?? null,
          tension3: dto.tension3 ?? null,
          tension4: dto.tension4 ?? null,
          tension5: dto.tension5 ?? null,
          comments: dto.comments ?? null,
          organizationId,
          userId,
        } as unknown as unknown[],
      ).catch((error: unknown) => {
        const message = error instanceof Error ? error.message : String(error);
        if (/MASK_TENSION_FAILED/.test(message)) {
          throw new BadRequestException('등록되지 않은 메탈마스크 바코드입니다.');
        }
        throw error;
      });
      return { jigLotNo, checkStatus: dto.checkStatus };
    });
  }
}
