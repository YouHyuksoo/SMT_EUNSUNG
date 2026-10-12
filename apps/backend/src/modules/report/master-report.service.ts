/**
 * @file src/modules/report/master-report.service.ts
 * @description 기준정보·바코드·설비 리포트 3화면
 *              338 w_des_item_master_rpt   품목마스터리포트
 *              340 w_pln_line_barcode_rpt  라인설비바코드
 *              343 w_mcn_machine_rpt       설비리포트
 *
 * 초보자 가이드:
 * 1. **기준정보 리포트는 마스터 표를 그대로 뽑는 것이다.** 품목 2,560건 ·
 *    라인설비 39건 · 설비 139건 (실측) — 작은 표라 기간 조건이 없다.
 * 2. **340 의 PB '저장' 은 무동작이었다.** DataWindow `d_line_barcode_lst` 에
 *    갱신 대상 테이블이 지정돼 있지 않고 update=yes 컬럼도 line_code 하나뿐이다
 *    (실측). 조회 전용으로 옮겼다.
 * 3. **바코드 라벨 자체는 이관 대상이 아니다.** `d_line_barcode_rpt` ·
 *    `d_smt_feeder_location_barcode` · `d_mcn_machine_barcode_rpt` ·
 *    `d_mcn_machine_card_rpt` 는 인쇄 지오메트리(용지 여백·칸 간격·글꼴)다.
 *    목록은 옮기고 라벨은 CSV 로 내보내 라벨 소프트웨어가 찍게 한다.
 * 4. **343 은 두 갈래다.** 설비 마스터와 일일가동 이력이다. 일일가동은
 *    IMCN_MACHINE_DAILY_OPERATION 에 **1행만 있다** (실측) — 화면은 동작하지만
 *    볼 것이 없다.
 * 5. **코드값은 코드표에서 뜻을 붙인다.** 품목유형·라인유형(구매유형)·설비유형 등.
 */
import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { likePrefix } from '@smt/shared';
import { limited, ROW_LIMIT } from '../../shared/row-limit';
import {
  ItemMasterReportQueryDto,
  LineBarcodeQueryDto,
  MachineOperationQueryDto,
  MachineReportQueryDto,
} from './report.dto';
import { namedBinds } from '../../common/utils/named-binds.util';

type Row = Record<string, unknown>;


@Injectable()
export class MasterReportService {
  constructor(private readonly dataSource: DataSource) {}

  // ───────────────────────────────── 338 품목마스터리포트

  /**
   * 품목 마스터 전체. PB 는 품목코드 하나만 조건으로 뒀는데 실무에서 분류·유형으로
   * 뽑는 일이 많아 조건을 넓혔다 (2,560건짜리 표라 비용이 없다).
   *
   * LINE_TYPE 은 라인이 아니라 **구매유형**이다 (F 무상구매 · G 국내구매 · M 무상사급 ·
   * T 자작 · Y 유상사급 — 실측 코드표). 이름 때문에 라인으로 읽기 쉬워 주의가 필요하다.
   */
  async findItemMaster(query: ItemMasterReportQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT i.ITEM_CODE                               AS "itemCode",
              i.ITEM_NAME                               AS "itemName",
              i.ITEM_SPEC                               AS "itemSpec",
              i.ITEM_UOM                                AS "itemUom",
              i.ITEM_TYPE                               AS "itemType",
              it.CODE_MEAN_KOR                          AS "itemTypeName",
              i.ITEM_CLASS                              AS "itemClass",
              ic.CODE_MEAN_KOR                          AS "itemClassName",
              i.ITEM_DIVISION                           AS "itemDivision",
              i.LINE_TYPE                               AS "lineType",
              lt.CODE_MEAN_KOR                          AS "lineTypeName",
              i.SET_ITEM_YN                             AS "setItemYn",
              i.BARCODE                                 AS "barcode",
              i.PART_NO                                 AS "partNo",
              i.DRAWING_NO                              AS "drawingNo",
              -- STATUS 는 컬럼이 아니라 **유효기간 계산식**이다 (PB DataWindow 실측).
              -- 적용종료가 미래면 RUNNING, 적용시작도 미래면 FUTURE, 지났으면 EXPIRED.
              -- i.STATUS 로 쓰면 ORA-00904 다 — ID_ITEM 에 그런 컬럼이 없다.
              DECODE(SIGN(i.DATEEND - TRUNC(SYSDATE)), 1,
                     DECODE(SIGN(i.DATESET - TRUNC(SYSDATE)), 1, 'FUTURE', 'RUNNING'),
                     'EXPIRED')                         AS "status",
              i.ABC_GRADE                               AS "abcGrade",
              i.SPECIAL_PROPERTY                        AS "specialProperty",
              i.WIDTH                                   AS "width",
              i.HEIGHT                                  AS "height",
              i.WEIGHT                                  AS "weight",
              i.INNER_DIAMETER                          AS "innerDiameter",
              i.OUTER_DIAMETER                          AS "outerDiameter",
              TO_CHAR(i.DATESET, 'YYYY-MM-DD')          AS "dateSet",
              TO_CHAR(i.DATEEND, 'YYYY-MM-DD')          AS "dateEnd",
              i.ENTER_BY                                AS "enterBy",
              TO_CHAR(i.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')       AS "enterDate",
              i.LAST_MODIFY_BY                          AS "lastModifyBy",
              TO_CHAR(i.LAST_MODIFY_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "lastModifyDate"
         FROM ID_ITEM i
         LEFT JOIN ISYS_BASECODE it
                ON it.CODE_TYPE = 'ITEM TYPE' AND it.CODE_NAME = i.ITEM_TYPE
         LEFT JOIN ISYS_BASECODE ic
                ON ic.CODE_TYPE = 'ITEM CLASS' AND ic.CODE_NAME = i.ITEM_CLASS
         LEFT JOIN ISYS_BASECODE lt
                ON lt.CODE_TYPE = 'LINE TYPE' AND lt.CODE_NAME = i.LINE_TYPE
        WHERE NVL(i.ITEM_CODE, '*') LIKE :itemCode ESCAPE '\\'
          AND NVL(i.ITEM_NAME, '*') LIKE :itemName ESCAPE '\\'
          AND NVL(i.ITEM_CLASS, '*') LIKE :itemClass ESCAPE '\\'
          AND NVL(i.ITEM_TYPE, '*') LIKE :itemType ESCAPE '\\'
          AND NVL(i.LINE_TYPE, '*') LIKE :lineType ESCAPE '\\'
          AND DECODE(SIGN(i.DATEEND - TRUNC(SYSDATE)), 1,
                     DECODE(SIGN(i.DATESET - TRUNC(SYSDATE)), 1, 'FUTURE', 'RUNNING'),
                     'EXPIRED') LIKE :status ESCAPE '\\'
          AND i.ORGANIZATION_ID = :organizationId
        ORDER BY i.ITEM_CODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        itemCode: likePrefix(query.itemCode),
        itemName: likePrefix(query.itemName),
        itemClass: likePrefix(query.itemClass),
        itemType: likePrefix(query.itemType),
        lineType: likePrefix(query.lineType),
        status: likePrefix(query.status),
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }

  // ───────────────────────────────── 340 라인설비바코드

  /**
   * 라인·설비 조합 목록. 라벨로 찍을 대상을 고르는 표다.
   *
   * PB DataWindow 는 LINE_CODE·MACHINE 두 컬럼만 뽑았다. 라인명과 설비명을 붙여
   * 화면에서 무엇을 찍는지 알 수 있게 했다 — 코드만 찍힌 라벨 목록은 확인이 안 된다.
   */
  async findLineBarcodes(query: LineBarcodeQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT l.LINE_CODE                               AS "lineCode",
              F_GET_LINE_NAME(l.LINE_CODE, :organizationId) AS "lineName",
              l.MACHINE                                 AS "machine",
              m.MACHINE_NAME                            AS "machineName",
              m.MACHINE_TYPE                            AS "machineType",
              m.MACHINE_MODEL_NAME                      AS "machineModelName",
              m.USE_STATUS                              AS "useStatus",
              -- 라벨에 찍는 값. PB 라벨 DataWindow 가 만든 것과 같은 조합이다.
              l.LINE_CODE || '-' || l.MACHINE           AS "barcodeText"
         FROM IB_LINE_MASTER l
         LEFT JOIN IMCN_MACHINE m
                ON m.MACHINE_CODE = l.MACHINE AND m.ORGANIZATION_ID = l.ORGANIZATION_ID
        WHERE NVL(l.LINE_CODE, '*') LIKE :lineCode ESCAPE '\\'
          AND NVL(l.MACHINE, '*') LIKE :machine ESCAPE '\\'
          AND l.ORGANIZATION_ID = :organizationId
        ORDER BY l.LINE_CODE, l.MACHINE`,
      namedBinds({
        lineCode: likePrefix(query.lineCode),
        machine: likePrefix(query.machine),
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }

  // ───────────────────────────────── 343 설비리포트

  /** 설비 마스터. 라벨·설비카드 레이아웃은 제외하고 목록만 옮겼다. */
  async findMachines(query: MachineReportQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT m.MACHINE_CODE                            AS "machineCode",
              m.MACHINE_NAME                            AS "machineName",
              m.MACHINE_TYPE                            AS "machineType",
              mt.CODE_MEAN_KOR                          AS "machineTypeName",
              m.MACHINE_MODEL_NAME                      AS "machineModelName",
              m.LINE_CODE                               AS "lineCode",
              F_GET_LINE_NAME(m.LINE_CODE, :organizationId) AS "lineName",
              m.WORKSTAGE_CODE                          AS "workstageCode",
              m.CAPACITY                                AS "capacity",
              m.RESERVED_CAPACITY                       AS "reservedCapacity",
              m.USE_STATUS                              AS "useStatus",
              m.CUSTOMER_CODE                           AS "customerCode",
              c.CUSTOMER_NAME                           AS "customerName",
              m.NATION_CODE                             AS "nationCode",
              m.ACQUISITION_TYPE                        AS "acquisitionType",
              TO_CHAR(m.ACQUISITION_DATE, 'YYYY-MM-DD') AS "acquisitionDate",
              m.MANUAL_LOCATION_COMMENT                 AS "manualLocationComment",
              m.ENTER_BY                                AS "enterBy",
              TO_CHAR(m.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')       AS "enterDate",
              m.LAST_MODIFY_BY                          AS "lastModifyBy",
              TO_CHAR(m.LAST_MODIFY_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "lastModifyDate"
         FROM IMCN_MACHINE m
         LEFT JOIN ISYS_BASECODE mt
                ON mt.CODE_TYPE = 'MACHINE TYPE' AND mt.CODE_NAME = m.MACHINE_TYPE
         LEFT JOIN ICOM_CUSTOMER c ON c.CUSTOMER_CODE = m.CUSTOMER_CODE
        WHERE NVL(m.MACHINE_CODE, '*') LIKE :machineCode ESCAPE '\\'
          AND NVL(m.MACHINE_TYPE, '*') LIKE :machineType ESCAPE '\\'
          AND m.ORGANIZATION_ID = :organizationId
        ORDER BY m.MACHINE_TYPE, m.MACHINE_CODE`,
      namedBinds({
        machineCode: likePrefix(query.machineCode),
        machineType: likePrefix(query.machineType),
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }

  /**
   * 설비 일일가동 이력.
   *
   * PB 는 설비를 좌외부조인하고 가동이력에 조건을 걸었다 — 필수조건이 붙으면
   * 외부조인이 무력화돼 사실상 내부조인이다. 조인을 LEFT JOIN 으로 옮기면서
   * 날짜·상태 조건을 **조인 조건으로 올렸다**: 그러면 가동 기록이 없는 설비도
   * 목록에 남아 '이 설비는 이 기간에 안 돌았다' 가 보인다.
   *
   * **IMCN_MACHINE_DAILY_OPERATION 은 1행뿐이다** (실측) — 화면은 동작하지만
   * 볼 것이 거의 없다. 은성이 아직 일일가동을 쌓지 않는다.
   */
  async findMachineOperations(query: MachineOperationQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT m.MACHINE_CODE                            AS "machineCode",
              m.MACHINE_NAME                            AS "machineName",
              m.MACHINE_TYPE                            AS "machineType",
              m.LINE_CODE                               AS "lineCode",
              F_GET_LINE_NAME(m.LINE_CODE, :organizationId) AS "lineName",
              TO_CHAR(o.PLAN_DATE, 'YYYY-MM-DD')        AS "planDate",
              o.START_TIME                              AS "startTime",
              o.END_TIME                                AS "endTime",
              o.TOTAL_OPERATION_TIME                    AS "totalOperationTime",
              o.MACHINE_STATUS_CODE                     AS "machineStatusCode"
         FROM IMCN_MACHINE m
         LEFT JOIN IMCN_MACHINE_DAILY_OPERATION o
                ON o.MACHINE_CODE = m.MACHINE_CODE
               AND o.ORGANIZATION_ID = m.ORGANIZATION_ID
               AND o.PLAN_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
               AND o.PLAN_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
               AND o.MACHINE_STATUS_CODE <> 'S'
        WHERE NVL(m.MACHINE_CODE, '*') LIKE :machineCode ESCAPE '\\'
          AND NVL(m.MACHINE_TYPE, '*') LIKE :machineType ESCAPE '\\'
          AND m.ORGANIZATION_ID = :organizationId
        ORDER BY m.MACHINE_CODE, o.PLAN_DATE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        machineCode: likePrefix(query.machineCode),
        machineType: likePrefix(query.machineType),
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }
}
