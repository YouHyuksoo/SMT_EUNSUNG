/**
 * @file src/modules/query/sensor-actual.service.ts
 * @description 330 SMT 제품실적센서이력조회 — PB w_pln_product_sensor_actual_master 이식
 *              + 333 자재 바코드 상태 조회 (w_mat_barcode_status_report)
 *
 * 초보자 가이드:
 * 1. **330 은 생산실적(조립실적)을 본다** (2026-10-17 센서실적에서 바꿈). 원천은
 *    IP_ASSEMBLY_RESULT_SENSOR_V — AOI 양품 자동 · 수기 작업실적 · 보정이 모인 뷰다.
 *    네 탭 (PB 탭 4개를 그대로 둔다):
 *      현재   오늘 작업일 행
 *      이력   지난 작업일 행
 *      시간   1시간 단위 합계 (실적 시각 기준)
 *      시간대 작업일 · 시간대(A~J) 합계
 * 2. **'실적 보정' 은 보정 행을 더한다** (AssemblyResultService). 행을 바꾸지 않는다 —
 *    실적수량을 주면 (새 수량 − 지금 수량), 보정수량을 주면 그 값만큼 보정 행이 생긴다.
 * 3. **키는 작업일 + 순번이다** (조립실적 PK). 작업일은 불투명 키로 주고받는다.
 * 4. **자동갱신이 있다** (PB Interval 기본 20초 / Start / Stop).
 * 5. **333 은 독립 화면이지만 파일을 같이 둔다** — 자재 바코드 한 줄의 상태
 *    (입고대조·출고대조·홀딩·릴폐기·MSL)를 보는 단순 조회라 파일을 따로 둘 만큼이
 *    아니다. PB DataWindow 가 PBSELECT 라 SQL 을 새로 썼다 (테이블·컬럼 목록 기준).
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { checkTrackingFilter, likePrefix, formatDate } from '@smt/shared';
import { AssemblyResultService } from '../assembly-result/assembly-result.service';
import {
  MaterialBarcodeQueryDto,
  SensorActualAdjustDto,
  SensorActualQueryDto,
} from './query.dto';
import { ROW_LIMIT } from './row-limit';
import { namedBinds } from '../../common/utils/named-binds.util';

type Row = Record<string, unknown>;

@Injectable()
export class SensorActualService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly assembly: AssemblyResultService,
  ) {}

  /**
   * 현재·이력 두 탭의 컬럼 구성. 조립실적 뷰에는 설비·작업자 칼럼이 없어 withMachine 은 false 로 부른다.
   */
  private actualSelect(table: string, withMachine: boolean, dateWhere = '') {
    return `SELECT a.LINE_CODE                          AS "lineCode",
              c.LINE_NAME                               AS "lineName",
              a.MODEL_NAME                              AS "modelName",
              a.MODEL_SUFFIX                            AS "modelSuffix",
              a.WORKSTAGE_CODE                          AS "workstageCode",
              a.PCB_ITEM                                AS "pcbItem",
              a.RUN_NO                                  AS "runNo",
              ${withMachine ? 'a.MACHINE_CODE' : 'NULL'}          AS "machineCode",
              a.ACTUAL_TYPE                             AS "actualType",
              a.PRODUCT_ACTUAL_QTY                      AS "productActualQty",
              a.PRODUCT_ACTUAL_SUM                      AS "productActualSum",
              a.PRODUCT_ACTUAL_LOST_QTY                 AS "productActualLostQty",
              a.ADJUST_QTY                              AS "adjustQty",
              a.ORIGIN_COUNT                            AS "originCount",
              ${withMachine ? 'a.WORK_TIME' : 'NULL'}            AS "workTime",
              ${withMachine ? 'a.WORKER_NAME' : 'NULL'}          AS "workerName",
              ${withMachine ? 'a.WORKER_COUNT' : 'NULL'}         AS "workerCount",
              a.IS_LAST_YN                              AS "isLastYn",
              a.RECEIPT_SEQUENCE                        AS "receiptSequence",
              TO_CHAR(a.RECEIPT_DATE, 'YYYY-MM-DD HH24:MI:SS')      AS "receiptDate",
              TO_CHAR(a.RECEIPT_DATE, 'YYYYMMDDHH24MISS')           AS "receiptDateKey",
              TO_CHAR(a.LAST_RECEIPT_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "lastReceiptDate",
              a.ENTER_BY                                AS "enterBy",
              TO_CHAR(a.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')        AS "enterDate",
              a.LAST_MODIFY_BY                          AS "lastModifyBy",
              TO_CHAR(a.LAST_MODIFY_DATE, 'YYYY-MM-DD HH24:MI:SS')  AS "lastModifyDate"
         FROM ${table} a
         LEFT JOIN IP_PRODUCT_LINE c
                ON c.LINE_CODE = a.LINE_CODE AND c.ORGANIZATION_ID = a.ORGANIZATION_ID
        WHERE NVL(a.LINE_CODE, '*') LIKE :lineCode ESCAPE '\\'
          AND a.ORGANIZATION_ID = :organizationId
          ${dateWhere}
        ORDER BY a.RECEIPT_DATE DESC, a.LAST_RECEIPT_DATE DESC, a.RECEIPT_SEQUENCE DESC
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`;
  }

  /** 생산실적 원천 (조립실적). 설비·작업자 칼럼은 없다 */
  private static readonly SOURCE = 'IP_ASSEMBLY_RESULT_SENSOR_V';

  /** 330 현재 실적 — 오늘 작업일 */
  async findCurrent(query: SensorActualQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      this.actualSelect(SensorActualService.SOURCE, false, `AND a.RECEIPT_DATE = F_GET_WORK_ACTUAL_DATE(SYSDATE, 'A')`),
      namedBinds({ lineCode: likePrefix(query.lineCode), organizationId }),
    )) as Row[];
    return { data: rows, total: rows.length, truncated: rows.length >= ROW_LIMIT };
  }

  /** 330 실적 이력 — 지난 작업일 */
  async findHistory(query: SensorActualQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      this.actualSelect(SensorActualService.SOURCE, false, `AND a.RECEIPT_DATE < F_GET_WORK_ACTUAL_DATE(SYSDATE, 'A')`),
      namedBinds({ lineCode: likePrefix(query.lineCode), organizationId }),
    )) as Row[];
    return { data: rows, total: rows.length, truncated: rows.length >= ROW_LIMIT };
  }

  /**
   * 330 1시간 단위 / 시간대 단위 실적 — 조립실적을 접어 내린다.
   * 시간 = 실적 시각의 시(時), 시간대 = 작업일 + A~J. 기준일부터 본다 (기본 오늘).
   */
  private async findBucketed(kind: 'HOUR' | 'SLOT', query: SensorActualQueryDto, organizationId: number) {
    const bucket = kind === 'HOUR' ? `TRUNC(a.LAST_RECEIPT_DATE, 'HH24')` : 'a.RECEIPT_DATE';
    const rows = (await this.dataSource.query(
      `SELECT a.LINE_CODE                               AS "lineCode",
              MAX(c.LINE_NAME)                          AS "lineName",
              a.MODEL_NAME                              AS "modelName",
              ${kind === 'SLOT' ? 'a.TIME_DIVISION' : 'NULL'}  AS "timeDivision",
              SUM(a.PRODUCT_ACTUAL_QTY)                 AS "productActualQty",
              TO_CHAR(${bucket}, 'YYYY-MM-DD HH24:MI:SS')      AS "receiptDate",
              TO_CHAR(${bucket}, 'YYYYMMDDHH24MISS')           AS "receiptDateKey",
              MAX(a.ENTER_BY)                           AS "enterBy",
              TO_CHAR(MAX(a.LAST_RECEIPT_DATE), 'YYYY-MM-DD HH24:MI:SS') AS "enterDate"
         FROM ${SensorActualService.SOURCE} a
         LEFT JOIN IP_PRODUCT_LINE c
                ON c.LINE_CODE = a.LINE_CODE AND c.ORGANIZATION_ID = a.ORGANIZATION_ID
        WHERE NVL(a.LINE_CODE, '*') LIKE :lineCode ESCAPE '\\'
          AND NVL(a.MODEL_NAME, '*') LIKE :modelName ESCAPE '\\'
          AND a.RECEIPT_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD') - 1
          AND ${bucket} >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND a.ORGANIZATION_ID = :organizationId
        GROUP BY a.LINE_CODE, a.MODEL_NAME, ${bucket}${kind === 'SLOT' ? ', a.TIME_DIVISION' : ''}
        ORDER BY ${bucket} DESC${kind === 'SLOT' ? ', a.TIME_DIVISION DESC' : ''}, a.LINE_CODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        lineCode: likePrefix(query.lineCode),
        modelName: likePrefix(query.modelName),
        dateFrom: query.dateFrom ?? formatDate(new Date()),
        organizationId,
      }),
    )) as Row[];
    return { data: rows, total: rows.length, truncated: rows.length >= ROW_LIMIT };
  }

  findHourly(query: SensorActualQueryDto, organizationId: number) {
    return this.findBucketed('HOUR', query, organizationId);
  }

  findByTimeSlot(query: SensorActualQueryDto, organizationId: number) {
    return this.findBucketed('SLOT', query, organizationId);
  }

  /**
   * 실적 보정 — 보정 행을 더한다 (행을 바꾸지 않는다).
   * 실적수량을 주면 (새 수량 − 지금 수량), 보정수량만 주면 그 값이 보정 수량이다.
   * 보정 전·후 수량을 함께 돌려준다.
   */
  async adjust(dto: SensorActualAdjustDto, _organizationId: number, userId: string) {
    let before = 0;
    const r = await this.assembly.adjustRow(
      dto,
      (current) => {
        before = current;
        if (dto.productActualQty != null) return dto.productActualQty - current;
        return dto.adjustQty ?? 0;
      },
      '생산실적 조회 화면 보정',
      userId,
    );
    return {
      found: true,
      changed: r.changed,
      before: { productActualQty: before },
      after: { productActualQty: before + Number(r.adjustQty ?? 0), adjustQty: r.adjustQty ?? 0 },
    };
  }

  // ───────────────────────────────── 333 자재 바코드 상태 조회

  /**
   * 자재 바코드 한 줄의 상태.
   *
   * PB DataWindow `d_mat_rcviss_barcode_4_check_rpt` 는 PBSELECT(SQL 페인터 구조)라
   * 실행 가능한 SQL 이 아니다. 선언된 테이블·컬럼·조건(품목코드 LIKE · 제조번호
   * LIKE · 조직)을 근거로 SQL 을 새로 썼고, 바코드 조건을 하나 더 받는다
   * (현장에서 바코드를 찍어 찾는 일이 대부분이다).
   */
  async findMaterialBarcode(query: MaterialBarcodeQueryDto, organizationId: number) {
    // 조건 하나는 반드시 있어야 한다. 실측: 조건 없이 열면 193만행을 훑어
    // 21.34초에 상한 5,000행만 잘려 나온다 — 그건 조회가 아니라 사고다.
    // 세 조건 모두 인덱스가 있다 (ITEM_CODE · LOT_NO · ITEM_BARCODE 선두).
    const verdict = checkTrackingFilter({
      lotNo: query.lotNo,
      serialNo: query.itemBarcode,
      runNo: query.itemCode,
    });
    if (!verdict.ok) {
      throw new BadRequestException(
        '품목코드 · 제조번호 · 자재 바코드 중 하나를 입력하세요'
        + ' (자재 바코드 표가 193만행이라 조건 없이는 열 수 없습니다).',
      );
    }
    const rows = (await this.dataSource.query(
      `SELECT b.ITEM_BARCODE                            AS "itemBarcode",
              b.ORIGIN_ITEM_BARCODE                     AS "originItemBarcode",
              b.SUPPLIER_BARCODE                        AS "supplierBarcode",
              b.ITEM_CODE                               AS "itemCode",
              i.ITEM_NAME                               AS "itemName",
              i.ITEM_SPEC                               AS "itemSpec",
              b.SUPPLIER_ITEM_CODE                      AS "supplierItemCode",
              b.SUPPLIER_CODE                           AS "supplierCode",
              s.SUPPLIER_NAME                           AS "supplierName",
              b.FROM_SUPPLIER_CODE                      AS "fromSupplierCode",
              b.ORIGIN_SUPPLIER_CODE                    AS "originSupplierCode",
              b.LOT_NO                                  AS "lotNo",
              b.SUPPLIER_LOT_NO                         AS "supplierLotNo",
              b.VENDOR_LOTNO                            AS "vendorLotNo",
              b.SCAN_QTY                                AS "scanQty",
              TO_CHAR(b.SCAN_DATE, 'YYYY-MM-DD HH24:MI:SS')         AS "scanDate",
              b.BARCODE_STATUS                          AS "barcodeStatus",
              bs.CODE_MEAN_KOR                          AS "barcodeStatusName",
              b.LABEL_TYPE                              AS "labelType",
              b.RECEIPT_TYPE                            AS "receiptType",
              b.ISSUE_TYPE                              AS "issueType",
              b.ISSUE_DIVISION                          AS "issueDivision",
              b.RECEIPT_SLIP_NO                         AS "receiptSlipNo",
              b.RECEIPT_COMPARE_YN                      AS "receiptCompareYn",
              TO_CHAR(b.RECEIPT_COMPARE_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "receiptCompareDate",
              b.RECEIPT_COMPARE_BY                      AS "receiptCompareBy",
              b.ISSUE_COMPARE_YN                        AS "issueCompareYn",
              TO_CHAR(b.ISSUE_COMPARE_DATE, 'YYYY-MM-DD HH24:MI:SS')   AS "issueCompareDate",
              b.ISSUE_COMPARE_BY                        AS "issueCompareBy",
              b.ISSUE_RETURN_YN                         AS "issueReturnYn",
              b.RETURN_YN                               AS "returnYn",
              b.HOLDING_YN                              AS "holdingYn",
              b.FEEDING_YN                              AS "feedingYn",
              b.FEEDING_MODEL                           AS "feedingModel",
              b.LOT_DIVIDE_YN                           AS "lotDivideYn",
              b.REEL_DIVIDE_COMPARE_YN                  AS "reelDivideCompareYn",
              b.REEL_DESTROY_YN                         AS "reelDestroyYn",
              TO_CHAR(b.REEL_DESTROY_DATE, 'YYYY-MM-DD HH24:MI:SS')    AS "reelDestroyDate",
              b.CHECK_STATUS                            AS "checkStatus",
              b.LOCATION_CODE                           AS "locationCode",
              b.MANUFACTURE_WEEK                        AS "manufactureWeek",
              TO_CHAR(b.MANUFACTURE_DATE, 'YYYY-MM-DD') AS "manufactureDate",
              TO_CHAR(b.VALID_DATE, 'YYYY-MM-DD')       AS "validDate",
              TO_CHAR(b.MSL_OPEN_DATE, 'YYYY-MM-DD HH24:MI:SS')        AS "mslOpenDate",
              b.MSL_PASSED_TIME                         AS "mslPassedTime",
              b.MSL_REMAIN_TIME                         AS "mslRemainTime",
              i.MSL_LEVEL                               AS "mslLevel",
              i.MSL_MAX_TIME                            AS "mslMaxTime",
              b.ENTER_BY                                AS "enterBy",
              TO_CHAR(b.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')           AS "enterDate",
              b.LAST_MODIFY_BY                          AS "lastModifyBy",
              TO_CHAR(b.LAST_MODIFY_DATE, 'YYYY-MM-DD HH24:MI:SS')     AS "lastModifyDate"
         FROM IM_ITEM_RECEIPT_BARCODE b
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = b.ITEM_CODE AND i.ORGANIZATION_ID = b.ORGANIZATION_ID
         LEFT JOIN ICOM_SUPPLIER s ON s.SUPPLIER_CODE = b.SUPPLIER_CODE
         LEFT JOIN ISYS_BASECODE bs
                ON bs.CODE_TYPE = 'BARCODE STATUS' AND bs.CODE_NAME = b.BARCODE_STATUS
        -- 세 컬럼 모두 인덱스 선두이고 이 셋이 유일한 조건이다. NVL 로 감싸면
        -- 인덱스를 못 써 193만행을 훑는다 (실측 21.34s). PB 도 NULL 행은
        -- 떨어뜨렸으니 동작도 같다.
        WHERE b.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND b.LOT_NO LIKE :lotNo ESCAPE '\\'
          AND b.ITEM_BARCODE LIKE :itemBarcode ESCAPE '\\'
          AND b.ORGANIZATION_ID = :organizationId
        ORDER BY b.SCAN_DATE DESC
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        itemCode: likePrefix(query.itemCode),
        lotNo: likePrefix(query.lotNo),
        itemBarcode: likePrefix(query.itemBarcode),
        organizationId,
      }),
    )) as Row[];
    return { data: rows, total: rows.length, truncated: rows.length >= ROW_LIMIT };
  }
}
