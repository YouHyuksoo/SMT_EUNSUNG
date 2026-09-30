/**
 * @file src/modules/query/sensor-actual.service.ts
 * @description 330 SMT 제품실적센서이력조회 — PB w_pln_product_sensor_actual_master 이식
 *              + 333 자재 바코드 상태 조회 (w_mat_barcode_status_report)
 *
 * 초보자 가이드:
 * 1. **330 은 라인 끝 센서가 세는 생산 실적을 본다.** 네 갈래가 같은 값을 다른
 *    단위로 보여준다 (PB 탭 4개):
 *      현재   IP_PRODUCT_SENSOR_ACTUAL       지금 카운트
 *      이력   IP_PRODUCT_SENSOR_ACTUAL_BACK  일자 마감 후 백업
 *      시간   IP_PRODUCT_SENSOR_ACTUAL_HOUR  1시간 단위
 *      시간대 IP_PRODUCT_SENSOR_ACTUAL_TIME  교대 시간대 단위
 * 2. **'실적 보정' 은 쓰기다** (PB 'Actual Adjust'). 센서가 잘못 센 수량을 손으로
 *    맞춘다. DataWindow 의 update=yes 컬럼은 PRODUCT_ACTUAL_QTY·ADJUST_QTY
 *    둘뿐이다 (실측) — 그 둘만 받는다.
 * 3. **키는 RECEIPT_DATE + RECEIPT_SEQUENCE 다** (실측 PK). 라인·공정으로 잡으면
 *    같은 라인의 다른 시점 실적까지 바뀐다. 시각은 불투명 키로 주고받는다.
 * 4. **자동갱신이 있다** (PB Interval 기본 20초 / Start / Stop).
 * 5. **333 은 독립 화면이지만 파일을 같이 둔다** — 자재 바코드 한 줄의 상태
 *    (입고대조·출고대조·홀딩·릴폐기·MSL)를 보는 단순 조회라 파일을 따로 둘 만큼이
 *    아니다. PB DataWindow 가 PBSELECT 라 SQL 을 새로 썼다 (테이블·컬럼 목록 기준).
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { checkTrackingFilter, likePrefix } from '@smt/shared';
import { TransactionService } from '../../shared/transaction.service';
import {
  MaterialBarcodeQueryDto,
  SensorActualAdjustDto,
  SensorActualQueryDto,
} from './query.dto';
import { ROW_LIMIT } from './row-limit';
import { affectedRows } from '../../common/utils/affected-rows.util';

type Row = Record<string, unknown>;

@Injectable()
export class SensorActualService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  /**
   * 현재·이력 두 탭의 컬럼 구성.
   *
   * **백업 테이블에는 설비·작업자 컬럼이 없다** — IP_PRODUCT_SENSOR_ACTUAL 에만
   * MACHINE_CODE · WORK_TIME · WORKER_NAME · WORKER_COUNT 가 있다 (실측 ORA-00904).
   * 이름이 같은 백업표라고 컬럼까지 같다고 짐작하면 안 된다.
   */
  private actualSelect(table: string, withMachine: boolean) {
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
        ORDER BY a.RECEIPT_DATE DESC, a.RECEIPT_SEQUENCE DESC
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`;
  }

  /** 330 현재 실적 */
  async findCurrent(query: SensorActualQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      this.actualSelect('IP_PRODUCT_SENSOR_ACTUAL', true),
      { lineCode: likePrefix(query.lineCode), organizationId } as unknown as unknown[],
    )) as Row[];
    return { data: rows, total: rows.length, truncated: rows.length >= ROW_LIMIT };
  }

  /** 330 실적 이력 (일자 마감 후 백업) */
  async findHistory(query: SensorActualQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      this.actualSelect('IP_PRODUCT_SENSOR_ACTUAL_BACK', false),
      { lineCode: likePrefix(query.lineCode), organizationId } as unknown as unknown[],
    )) as Row[];
    return { data: rows, total: rows.length, truncated: rows.length >= ROW_LIMIT };
  }

  /**
   * 330 1시간 단위 / 시간대 단위 실적. 두 테이블이 같은 모양이다.
   * 기준일을 주면 그 날부터 본다 (PB 는 `RECEIPT_DATE >= :dateset` 한쪽만 걸었다 —
   * 상한이 없어 그 뒤 전부가 나온다. 그대로 두되 기본값을 오늘로 두어 화면이
   * 폭주하지 않게 했다).
   */
  private async findBucketed(
    table: 'IP_PRODUCT_SENSOR_ACTUAL_HOUR' | 'IP_PRODUCT_SENSOR_ACTUAL_TIME',
    query: SensorActualQueryDto,
    organizationId: number,
  ) {
    const rows = (await this.dataSource.query(
      `SELECT a.LINE_CODE                               AS "lineCode",
              c.LINE_NAME                               AS "lineName",
              a.MODEL_NAME                              AS "modelName",
              a.PRODUCT_ACTUAL_QTY                      AS "productActualQty",
              TO_CHAR(a.RECEIPT_DATE, 'YYYY-MM-DD HH24:MI:SS')      AS "receiptDate",
              TO_CHAR(a.RECEIPT_DATE, 'YYYYMMDDHH24MISS')           AS "receiptDateKey",
              a.ENTER_BY                                AS "enterBy",
              TO_CHAR(a.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')        AS "enterDate"
         FROM ${table} a
         LEFT JOIN IP_PRODUCT_LINE c
                ON c.LINE_CODE = a.LINE_CODE AND c.ORGANIZATION_ID = a.ORGANIZATION_ID
        WHERE NVL(a.LINE_CODE, '*') LIKE :lineCode ESCAPE '\\'
          AND NVL(a.MODEL_NAME, '*') LIKE :modelName ESCAPE '\\'
          AND a.RECEIPT_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND a.ORGANIZATION_ID = :organizationId
        ORDER BY a.RECEIPT_DATE DESC
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        lineCode: likePrefix(query.lineCode),
        modelName: likePrefix(query.modelName),
        dateFrom: query.dateFrom ?? new Date().toISOString().slice(0, 10),
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return { data: rows, total: rows.length, truncated: rows.length >= ROW_LIMIT };
  }

  findHourly(query: SensorActualQueryDto, organizationId: number) {
    return this.findBucketed('IP_PRODUCT_SENSOR_ACTUAL_HOUR', query, organizationId);
  }

  findByTimeSlot(query: SensorActualQueryDto, organizationId: number) {
    return this.findBucketed('IP_PRODUCT_SENSOR_ACTUAL_TIME', query, organizationId);
  }

  /**
   * 실적 보정 (PB 'Actual Adjust' — **쓰기**).
   *
   * 두 컬럼만 바꾼다. 보정 전 값을 함께 돌려준다 — 실적 숫자를 손으로 고치는
   * 동작이라 무엇이 무엇으로 바뀌었는지 남아야 한다.
   */
  async adjust(dto: SensorActualAdjustDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      const before = (await qr.query(
        `SELECT LINE_CODE AS "lineCode", WORKSTAGE_CODE AS "workstageCode",
                PRODUCT_ACTUAL_QTY AS "productActualQty", ADJUST_QTY AS "adjustQty"
           FROM IP_PRODUCT_SENSOR_ACTUAL
          WHERE RECEIPT_DATE = TO_DATE(:receiptDateKey, 'YYYYMMDDHH24MISS')
            AND RECEIPT_SEQUENCE = :receiptSequence
            AND ORGANIZATION_ID = :organizationId`,
        {
          receiptDateKey: dto.receiptDateKey,
          receiptSequence: dto.receiptSequence,
          organizationId,
        } as unknown as unknown[],
      )) as Row[];
      if (before.length === 0) {
        return { found: false, changed: 0, before: null, after: null };
      }
      const result = await qr.query(
        `UPDATE IP_PRODUCT_SENSOR_ACTUAL
            SET PRODUCT_ACTUAL_QTY = NVL(:productActualQty, PRODUCT_ACTUAL_QTY),
                ADJUST_QTY = NVL(:adjustQty, ADJUST_QTY),
                LAST_MODIFY_BY = :userId,
                LAST_MODIFY_DATE = SYSDATE
          WHERE RECEIPT_DATE = TO_DATE(:receiptDateKey, 'YYYYMMDDHH24MISS')
            AND RECEIPT_SEQUENCE = :receiptSequence
            AND ORGANIZATION_ID = :organizationId`,
        {
          productActualQty: dto.productActualQty ?? null,
          adjustQty: dto.adjustQty ?? null,
          userId,
          receiptDateKey: dto.receiptDateKey,
          receiptSequence: dto.receiptSequence,
          organizationId,
        } as unknown as unknown[],
      );
      const after = (await qr.query(
        `SELECT PRODUCT_ACTUAL_QTY AS "productActualQty", ADJUST_QTY AS "adjustQty"
           FROM IP_PRODUCT_SENSOR_ACTUAL
          WHERE RECEIPT_DATE = TO_DATE(:receiptDateKey, 'YYYYMMDDHH24MISS')
            AND RECEIPT_SEQUENCE = :receiptSequence
            AND ORGANIZATION_ID = :organizationId`,
        {
          receiptDateKey: dto.receiptDateKey,
          receiptSequence: dto.receiptSequence,
          organizationId,
        } as unknown as unknown[],
      )) as Row[];
      return {
        found: true,
        changed: Number(affectedRows(result) ?? 0),
        before: before[0],
        after: after[0] ?? null,
      };
    });
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
      {
        itemCode: likePrefix(query.itemCode),
        lotNo: likePrefix(query.lotNo),
        itemBarcode: likePrefix(query.itemBarcode),
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return { data: rows, total: rows.length, truncated: rows.length >= ROW_LIMIT };
  }
}
