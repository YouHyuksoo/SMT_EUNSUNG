/**
 * @file src/modules/query/pid-query.service.ts
 * @description PID·마킹·PCB 투입 조회 3화면
 *              323 w_pln_product_barcode_query      PID 정보조회
 *              324 w_pln_product_pcb_marking_query  마킹이력조회
 *              325 w_qc_pcb_input_scan_master       PCB 투입 리스트조회
 *
 * 초보자 가이드:
 * 1. **323 은 조회 + X-OUT 해제다.** PB 'X-OUT Repair' 버튼이 IP_PRODUCT_WORK_QC 에서
 *    그 PID 의 X-OUT 불량 행을 지운다 — 불량으로 잡힌 PID 를 되살리는 동작이다.
 * 2. **323 은 날짜 조건이 없고 표가 1.8억행이다.** 그래서 Run No·PID·매거진 중
 *    하나를 반드시 받는다 (`@smt/shared` checkTrackingFilter). 모델·라인만으로는
 *    열리지 않는다 — PB 는 빈 조건을 `'%'` 로 보내 전체를 훑을 수 있었다.
 * 3. **324 의 '저장' 은 PB 에서도 아무 일도 하지 않았다.** DataWindow
 *    `d_pln_product_pcb_marking_SUMMARY_lst` 는 갱신 대상 테이블이 지정돼 있지
 *    않아 `dw_2.update()` 가 무동작이다 (실측). 조회 전용으로 옮겼다.
 * 4. **마킹시각(DATESET)은 VARCHAR2 다** ('YYYY/MM/DD HH24:MI:SS'). PB 도 문자열로
 *    비교했다 — 이 형식은 사전순이 시간순과 같아서 성립한다.
 * 5. **구동 컬럼은 NVL 로 감싸지 않는다.** `NVL(col,'*') LIKE :x` 는 인덱스를 못 써서
 *    그 LIKE 가 유일한 조건인 쿼리에서는 전체 스캔이 된다 (323 은 1.8억행,
 *    324 는 1억행). PB 도 `col LIKE '값%'` 로 NULL 행을 떨어뜨렸으니 동작도 같다.
 *    **반대로 LEFT JOIN 상대 테이블의 컬럼은 NVL 이 필요하다** — 벗기면 매칭 없는
 *    행이 `NULL LIKE '%'` = NULL 로 탈락해 외부조인이 내부조인이 된다.
 *    (325 의 MANUFACTURE_WEEK 가 그 경우다.)
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { checkTrackingFilter, likePrefix } from '@smt/shared';
import { TransactionService } from '../../shared/transaction.service';
import {
  MarkingQueryDto,
  PcbInputQueryDto,
  PidInfoQueryDto,
  XOutRepairDto,
} from './query.dto';
import { ROW_LIMIT } from './row-limit';
import { namedBinds } from '../../common/utils/named-binds.util';

type Row = Record<string, unknown>;

/** PB 가 X-OUT 불량에 쓰는 사유코드. 이 값만 지운다 — 다른 불량은 건드리지 않는다. */
const X_OUT_REASON = 'X-OUT';

@Injectable()
export class PidQueryService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  // ───────────────────────────────── 323 PID 정보조회

  async findPidInfo(query: PidInfoQueryDto, organizationId: number) {
    const verdict = checkTrackingFilter({
      runNo: query.runNo,
      serialNo: query.serialNo,
      magazineNo: query.magazineNo,
    });
    if (!verdict.ok) throw new BadRequestException(verdict.reason);

    const rows = (await this.dataSource.query(
      `SELECT b.SERIAL_NO                               AS "serialNo",
              b.RUN_NO                                  AS "runNo",
              b.LABEL_TEXT                              AS "labelText",
              b.LINE_CODE                               AS "lineCode",
              F_GET_LINE_NAME(b.LINE_CODE, b.ORGANIZATION_ID) AS "lineName",
              b.MODEL_NAME                              AS "modelName",
              b.CUSTOMER_MODEL_NAME                     AS "customerModelName",
              b.MAPPING_MODEL_NAME                      AS "mappingModelName",
              b.MAPPING_LABEL                           AS "mappingLabel",
              b.ITEM_CODE                               AS "itemCode",
              i.ITEM_NAME                               AS "itemName",
              i.ITEM_SPEC                               AS "itemSpec",
              i.ITEM_CLASS                              AS "itemClass",
              i.CUSTOMER_CODE                           AS "customerCode",
              b.MACHINE_CODE                            AS "machineCode",
              b.BCR_CODE                                AS "bcrCode",
              b.MAGAZINE_NO                             AS "magazineNo",
              b.BOX_NO                                  AS "boxNo",
              b.PALLETE_NO                              AS "palleteNo",
              b.CARRIER_BARCODE                         AS "carrierBarcode",
              b.CARRIER_SIZE                            AS "carrierSize",
              b.ARRAY_TYPE                              AS "arrayType",
              b.LOT_NO                                  AS "lotNo",
              b.LOT_QTY                                 AS "lotQty",
              b.WORKSTAGE_CODE                          AS "workstageCode",
              b.WORK_ORDER_NO                           AS "workOrderNo",
              b.EC_NO                                   AS "ecNo",
              b.PART_NO                                 AS "partNo",
              b.BARCODE_STATUS                          AS "barcodeStatus",
              bs.CODE_MEAN_KOR                          AS "barcodeStatusName",
              b.QC_SCAN_YN                              AS "qcScanYn",
              b.LONGTERM_YN                             AS "longtermYn",
              b.COMMENTS                                AS "comments",
              TO_CHAR(b.RUN_DATE, 'YYYY-MM-DD')                    AS "runDate",
              TO_CHAR(b.QC_SCAN_DATE, 'YYYY-MM-DD HH24:MI:SS')     AS "qcScanDate",
              TO_CHAR(b.ACTUAL_DATE, 'YYYY-MM-DD')                 AS "actualDate",
              TO_CHAR(b.RECEIPT_DATE, 'YYYY-MM-DD HH24:MI:SS')     AS "receiptDate",
              TO_CHAR(b.SHIPPING_DATE, 'YYYY-MM-DD HH24:MI:SS')    AS "shippingDate",
              b.ENTER_BY                                AS "enterBy",
              TO_CHAR(b.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')       AS "enterDate",
              b.LAST_MODIFY_BY                          AS "lastModifyBy",
              TO_CHAR(b.LAST_MODIFY_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "lastModifyDate",
              -- X-OUT 불량이 걸려 있는지. PB 는 이 화면에서 그것을 풀어 준다.
              ( SELECT COUNT(*) FROM IP_PRODUCT_WORK_QC q
                 WHERE q.SERIAL_NO = b.SERIAL_NO
                   AND q.BAD_REASON_CODE = '${X_OUT_REASON}'
                   AND q.ORGANIZATION_ID = b.ORGANIZATION_ID ) AS "xOutCount"
         FROM IP_PRODUCT_2D_BARCODE b
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = b.ITEM_CODE AND i.ORGANIZATION_ID = b.ORGANIZATION_ID
         LEFT JOIN ISYS_BASECODE bs
                ON bs.CODE_TYPE = 'BARCODE STATUS' AND bs.CODE_NAME = b.BARCODE_STATUS
        WHERE b.RUN_NO LIKE :runNo ESCAPE '\\'
          AND b.SERIAL_NO LIKE :serialNo ESCAPE '\\'
          AND b.MAGAZINE_NO LIKE :magazineNo ESCAPE '\\'
          AND b.LINE_CODE LIKE :lineCode ESCAPE '\\'
          AND b.MODEL_NAME LIKE :modelName ESCAPE '\\'
          AND b.ORGANIZATION_ID = :organizationId
        ORDER BY b.SERIAL_NO
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        runNo: likePrefix(query.runNo),
        serialNo: likePrefix(query.serialNo),
        magazineNo: likePrefix(query.magazineNo),
        lineCode: likePrefix(query.lineCode),
        modelName: likePrefix(query.modelName),
        organizationId,
      }),
    )) as Row[];
    return { data: rows, total: rows.length, truncated: rows.length >= ROW_LIMIT };
  }

  /**
   * X-OUT 불량 해제 (PB 'X-OUT Repair').
   *
   * PB 원본: `delete from IP_PRODUCT_WORK_QC where serial_no = :pid
   *           and bad_reason_code = 'X-OUT' and organization_id = :org`
   *
   * 지운 건수를 돌려준다. 0 이면 "해제했다" 가 아니라 "X-OUT 이 없었다" 다 —
   * 그 둘을 같은 성공으로 뭉치면 화면이 거짓말을 한다.
   */
  async repairXOut(dto: XOutRepairDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      const before = (await qr.query(
        `SELECT COUNT(*) AS "cnt" FROM IP_PRODUCT_WORK_QC
          WHERE SERIAL_NO = :serialNo
            AND BAD_REASON_CODE = :reason
            AND ORGANIZATION_ID = :organizationId`,
        namedBinds({
          serialNo: dto.serialNo, reason: X_OUT_REASON, organizationId,
        }),
      )) as Row[];
      const count = Number(before[0]?.cnt ?? 0);
      if (count === 0) {
        return { serialNo: dto.serialNo, deleted: 0, repairedBy: userId };
      }
      await qr.query(
        `DELETE FROM IP_PRODUCT_WORK_QC
          WHERE SERIAL_NO = :serialNo
            AND BAD_REASON_CODE = :reason
            AND ORGANIZATION_ID = :organizationId`,
        namedBinds({
          serialNo: dto.serialNo, reason: X_OUT_REASON, organizationId,
        }),
      );
      // 되살린 이력을 2D바코드 메모에 남긴다. PB 는 sle_message 를 화면에만 띄우고
      // 아무 곳에도 적지 않아 '누가 언제 풀었나' 가 남지 않았다.
      await qr.query(
        `UPDATE IP_PRODUCT_2D_BARCODE
            SET COMMENTS = SUBSTR(
                  NVL(COMMENTS || ' / ', '')
                  || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI') || ' X-OUT 해제 ' || :userId
                  || CASE WHEN :comments IS NULL THEN '' ELSE ' (' || :comments || ')' END,
                  1, 500),
                LAST_MODIFY_BY = :userId,
                LAST_MODIFY_DATE = SYSDATE
          WHERE SERIAL_NO = :serialNo AND ORGANIZATION_ID = :organizationId`,
        namedBinds({
          serialNo: dto.serialNo,
          userId,
          comments: dto.comments ?? null,
          organizationId,
        }),
      );
      return { serialNo: dto.serialNo, deleted: count, repairedBy: userId };
    });
  }

  // ───────────────────────────────── 324 마킹이력조회

  /** 마킹 상세 — PID 한 줄씩 */
  async findMarkingDetail(query: MarkingQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT m.LOTID                                   AS "lotId",
              m.CSTID                                   AS "cstId",
              m.SEQ                                     AS "seq",
              m.PID                                     AS "pid",
              m.EQUIPMENTID                             AS "equipmentId",
              m.DATESET                                 AS "markingDate",
              m.RESULT_CODE                             AS "resultCode",
              m.RUN_NO                                  AS "runNo",
              m.LINE_CODE                               AS "lineCode",
              F_GET_LINE_NAME(m.LINE_CODE, m.ORGANIZATION_ID) AS "lineName",
              m.MACHINE_CODE                            AS "machineCode",
              m.FILE_NAME                               AS "fileName",
              m.ENTER_BY                                AS "enterBy",
              TO_CHAR(m.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')       AS "enterDate",
              m.LAST_MODIFY_BY                          AS "lastModifyBy",
              TO_CHAR(m.LAST_MODIFY_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "lastModifyDate"
         FROM IQ_MACHINE_INSPECT_DATA_MK m
        WHERE m.RUN_NO LIKE :runNo ESCAPE '\\'
          AND m.PID LIKE :serialNo ESCAPE '\\'
          AND m.DATESET >= TO_CHAR(TO_DATE(:dateFrom, 'YYYY-MM-DD'), 'YYYY/MM/DD HH24:MI:SS')
          AND m.DATESET <  TO_CHAR(TO_DATE(:dateTo, 'YYYY-MM-DD') + 1,
                                   'YYYY/MM/DD HH24:MI:SS')
          AND m.ORGANIZATION_ID = :organizationId
        ORDER BY m.DATESET, m.PID
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        runNo: likePrefix(query.runNo),
        serialNo: likePrefix(query.serialNo),
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        organizationId,
      }),
    )) as Row[];
    return { data: rows, total: rows.length, truncated: rows.length >= ROW_LIMIT };
  }

  /**
   * 마킹 요약 — 롯트(LOTID)·설비·판정별 집계.
   * 모델명은 PB 와 같이 F_GET_MODEL_NAME_BY_RUN_NO 가 붙인다 (이 DB 에 있는 함수다).
   */
  async findMarkingSummary(query: MarkingQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT m.LOTID                                   AS "lotId",
              COUNT(*)                                  AS "pidQty",
              F_GET_MODEL_NAME_BY_RUN_NO(m.RUN_NO)      AS "modelName",
              MAX(m.SEQ)                                AS "seq",
              MIN(m.PID)                                AS "minPid",
              MAX(m.PID)                                AS "maxPid",
              m.EQUIPMENTID                             AS "equipmentId",
              MIN(m.DATESET)                            AS "markingDate",
              m.RESULT_CODE                             AS "resultCode",
              m.RUN_NO                                  AS "runNo",
              m.LINE_CODE                               AS "lineCode",
              F_GET_LINE_NAME(m.LINE_CODE, :organizationId) AS "lineName",
              m.MACHINE_CODE                            AS "machineCode",
              TO_CHAR(MIN(m.ENTER_DATE), 'YYYY-MM-DD HH24:MI:SS') AS "enterDate"
         FROM IQ_MACHINE_INSPECT_DATA_MK m
        WHERE m.RUN_NO LIKE :runNo ESCAPE '\\'
          AND m.PID LIKE :serialNo ESCAPE '\\'
          AND m.DATESET >= TO_CHAR(TO_DATE(:dateFrom, 'YYYY-MM-DD'), 'YYYY/MM/DD HH24:MI:SS')
          AND m.DATESET <  TO_CHAR(TO_DATE(:dateTo, 'YYYY-MM-DD') + 1,
                                   'YYYY/MM/DD HH24:MI:SS')
          AND m.ORGANIZATION_ID = :organizationId
        GROUP BY m.LOTID, m.EQUIPMENTID, m.RESULT_CODE, m.RUN_NO,
                 m.LINE_CODE, m.MACHINE_CODE
        ORDER BY MIN(m.DATESET), m.LOTID
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        runNo: likePrefix(query.runNo),
        serialNo: likePrefix(query.serialNo),
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        organizationId,
      }),
    )) as Row[];
    return { data: rows, total: rows.length, truncated: rows.length >= ROW_LIMIT };
  }

  // ───────────────────────────────── 325 PCB 투입 리스트조회

  /**
   * PCB 투입 스캔 목록. PB 원본은 날짜 조건이 없었지만 스캔일 범위를 필수로 넣었다 —
   * IP_PRODUCT_PCB_SCAN_MASTER 는 계속 쌓이는 표라 전체 조회는 화면이 못 버틴다.
   */
  async findPcbInput(query: PcbInputQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT m.RUN_NO                                  AS "runNo",
              m.MODEL_NAME                              AS "modelName",
              m.LINE_CODE                               AS "lineCode",
              F_GET_LINE_NAME(m.LINE_CODE, m.ORGANIZATION_ID) AS "lineName",
              m.MACHINE_CODE                            AS "machineCode",
              m.WORKSTAGE_CODE                          AS "workstageCode",
              TO_CHAR(m.SCAN_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "scanDate",
              m.SCAN_BY                                 AS "scanBy",
              m.PCB_BARCODE                             AS "pcbBarcode",
              m.ITEM_CODE                               AS "itemCode",
              i.ITEM_NAME                               AS "itemName",
              i.ITEM_SPEC                               AS "itemSpec",
              m.LOT_QTY                                 AS "lotQty",
              m.SUPPLIER_CODE                           AS "supplierCode",
              s.SUPPLIER_NAME                           AS "supplierName",
              m.RECEIPT_STATUS                          AS "receiptStatus",
              b.SUPPLIER_BARCODE                        AS "supplierBarcode",
              b.ITEM_BARCODE                            AS "itemBarcode",
              b.MANUFACTURE_WEEK                        AS "manufactureWeek",
              i.PCB_COATING_TYPE                        AS "pcbCoatingType",
              i.PCB_COATING_MAX_DAY                     AS "pcbCoatingMaxDay",
              TO_CHAR(b.PCB_COATING_DATE, 'YYYY-MM-DD') AS "pcbCoatingDate",
              m.ENTER_BY                                AS "enterBy",
              TO_CHAR(m.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "enterDate"
         FROM IP_PRODUCT_PCB_SCAN_MASTER m
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = m.ITEM_CODE AND i.ORGANIZATION_ID = m.ORGANIZATION_ID
         LEFT JOIN IM_ITEM_RECEIPT_BARCODE b ON b.ITEM_BARCODE = m.PCB_BARCODE
         LEFT JOIN ICOM_SUPPLIER s ON s.SUPPLIER_CODE = m.SUPPLIER_CODE
        WHERE m.RUN_NO LIKE :runNo ESCAPE '\\'
          AND m.LINE_CODE LIKE :lineCode ESCAPE '\\'
          AND m.MODEL_NAME LIKE :modelName ESCAPE '\\'
          AND m.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND m.PCB_BARCODE LIKE :itemBarcode ESCAPE '\\'
          AND NVL(b.MANUFACTURE_WEEK, '*') LIKE :manufactureWeek ESCAPE '\\'
          AND m.SCAN_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND m.SCAN_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND m.ORGANIZATION_ID = :organizationId
        ORDER BY m.SCAN_DATE DESC
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        runNo: likePrefix(query.runNo),
        lineCode: likePrefix(query.lineCode),
        modelName: likePrefix(query.modelName),
        itemCode: likePrefix(query.itemCode),
        itemBarcode: likePrefix(query.itemBarcode),
        manufactureWeek: likePrefix(query.manufactureWeek),
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        organizationId,
      }),
    )) as Row[];
    return { data: rows, total: rows.length, truncated: rows.length >= ROW_LIMIT };
  }
}
