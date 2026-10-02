/**
 * @file src/modules/query/feeder-monitor.service.ts
 * @description 329 SMT 피더별 모니터링 — PB w_smt_plan_feeder_monitoring_master 이식
 *
 * 초보자 가이드:
 * 1. **라인 하나의 피더 자리를 전부 펼쳐 놓고 잔량을 본다.** 자리마다 어떤 자재가
 *    물려 있고 몇 개 남았는지 본다 — 곧 떨어질 자리를 미리 찾는 화면이다.
 * 2. **자동갱신이 있다** (PB Interval / Auto Retrieve / Stop). 기본 60초.
 * 3. **'피더 잔량 세팅' 은 쓰기다** (PB 'Set Feeding Qty').
 *    마지막 CCS 투입 이후 스캔된 수량을 합쳐 IB_PRODUCT_PLANDATA.FEEDING_QTY 에
 *    적는다. PB 는 그리드 행마다 SELECT → UPDATE 를 돌렸다 (행이 300개면 600번).
 *    여기서는 집합 단위 UPDATE 한 번으로 같은 결과를 만든다.
 * 4. **NSNP 제어는 NsnpControlService 가 한다.** 321·335 와 같은 동작이다.
 */
import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { likePrefix } from '@smt/shared';
import { TransactionService } from '../../shared/transaction.service';
import { FeederMonitorQueryDto, FeederSlotQueryDto } from './query.dto';
import { ROW_LIMIT } from './row-limit';
import { affectedRows } from '../../common/utils/affected-rows.util';
import { namedBinds } from '../../common/utils/named-binds.util';

type Row = Record<string, unknown>;

@Injectable()
export class FeederMonitorService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  /**
   * 라인의 피더 자리 목록 (PB d_smt_plan_master_lst).
   *
   * PB 는 `LINE_CODE IN (:arg_line_code)` 로 받았는데 DataWindow 인자가 하나라
   * 실제로는 라인 한 개였다. 등호로 옮겼다.
   */
  async findFeederSlots(query: FeederMonitorQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT p.LINE_CODE                               AS "lineCode",
              c.LINE_NAME                               AS "lineName",
              p.MODEL_NAME                              AS "modelName",
              p.MODEL_SUFFIX                            AS "modelSuffix",
              p.MACHINE                                 AS "machine",
              p.TABLE_ID                                AS "tableId",
              p.LOCATION_CODE                           AS "locationCode",
              p.PCB_ITEM                                AS "pcbItem",
              p.ITEM_CODE                               AS "itemCode",
              i.ITEM_NAME                               AS "itemName",
              i.ITEM_SPEC                               AS "itemSpec",
              i.MSL_LEVEL                               AS "mslLevel",
              p.CHECK_YN                                AS "checkYn",
              p.CCS_YN                                  AS "ccsYn",
              p.CHECK_STATUS                            AS "checkStatus",
              p.REPLACE_YN                              AS "replaceYn",
              p.REVISION                                AS "revision",
              p.FEEDING_QTY                             AS "feedingQty",
              p.LAST_MODIFY_BY                          AS "lastModifyBy",
              TO_CHAR(p.LAST_MODIFY_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "lastModifyDate",
              -- 그 자리에 지금 물려 있는 롯트와 투입시각. 마지막 CCS 이후 건만 본다.
              ( SELECT MAX(h.LOT_NO) FROM IB_SMT_CHECKHIST h
                 WHERE h.LINE_CODE = p.LINE_CODE
                   AND h.LOT_NAME = p.MODEL_NAME
                   AND h.LOCATION_CODE = p.LOCATION_CODE
                   AND h.PARTNAME = p.ITEM_CODE
                   AND h.CHECK_STATUS = 'P' )        AS "currentLotNo",
              ( SELECT TO_CHAR(MAX(h.CHECK_DATE), 'YYYY-MM-DD HH24:MI:SS')
                  FROM IB_SMT_CHECKHIST h
                 WHERE h.LINE_CODE = p.LINE_CODE
                   AND h.LOT_NAME = p.MODEL_NAME
                   AND h.LOCATION_CODE = p.LOCATION_CODE
                   AND h.PARTNAME = p.ITEM_CODE
                   AND h.CHECK_STATUS = 'P' )        AS "lastFeedingDate"
         FROM IB_PRODUCT_PLANDATA p
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = p.ITEM_CODE AND i.ORGANIZATION_ID = p.ORGANIZATION_ID
         LEFT JOIN IP_PRODUCT_LINE c
                ON c.LINE_CODE = p.LINE_CODE AND c.ORGANIZATION_ID = p.ORGANIZATION_ID
        WHERE p.LINE_CODE = :lineCode
          AND NVL(p.MODEL_NAME, '*') LIKE :modelName ESCAPE '\\'
          AND NVL(p.ITEM_CODE, '*') LIKE :itemCode ESCAPE '\\'
          AND p.ACTIVE_YN = 'Y'
          AND p.ORGANIZATION_ID = :organizationId
        ORDER BY p.MACHINE, p.TABLE_ID, p.LOCATION_CODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        lineCode: query.lineCode,
        modelName: likePrefix(query.modelName),
        itemCode: likePrefix(query.itemCode),
        organizationId,
      }),
    )) as Row[];
    return { data: rows, total: rows.length, truncated: rows.length >= ROW_LIMIT };
  }

  /**
   * 피더 한 자리의 투입 이력 (PB 'Show Change History').
   *
   * **마지막 CCS(체크유형 1) 시각 이후만 본다.** 그 전은 이전 롯트 얘기다.
   * PB 원본 조건을 그대로 옮겼다.
   */
  async findSlotHistory(query: FeederSlotQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT TO_CHAR(c.CHECK_DATE, 'YYYY-MM-DD HH24:MI:SS')  AS "checkDate",
              c.CHECK_TYPE                              AS "checkType",
              ct.CODE_MEAN_KOR                          AS "checkTypeName",
              c.CHECK_STATUS                            AS "checkStatus",
              cs.CODE_MEAN_KOR                          AS "checkStatusName",
              c.LOT_NO                                  AS "lotNo",
              c.SCAN_PARTNAME                           AS "scanPartName",
              c.SCAN_SUPPLIER_PARTNAME                  AS "scanSupplierPartName",
              c.CHECK_BY                                AS "checkBy",
              c.CHECK_MSG                               AS "checkMsg",
              c.NG_REASON                               AS "ngReason",
              ( SELECT DECODE(NVL(b.NEW_SCAN_QTY, 0), 0, b.SCAN_QTY, NVL(b.NEW_SCAN_QTY, 0))
                  FROM IM_ITEM_RECEIPT_BARCODE b
                 WHERE b.ITEM_CODE = c.ITEM_CODE AND b.LOT_NO = c.LOT_NO ) AS "scanQty"
         FROM IB_SMT_CHECKHIST c
         LEFT JOIN ISYS_BASECODE ct
                ON ct.CODE_TYPE = 'CHECK TYPE' AND ct.CODE_NAME = c.CHECK_TYPE
         LEFT JOIN ISYS_BASECODE cs
                ON cs.CODE_TYPE = 'CHECK STATUS' AND cs.CODE_NAME = c.CHECK_STATUS
        WHERE c.LINE_CODE = :lineCode
          AND c.LOT_NAME = :lotName
          AND c.LOCATION_CODE = :locationCode
          AND c.PARTNAME = :itemCode
          AND c.CHECK_TYPE IN ('1', '2', '4')
          AND c.CHECK_DATE >= ( SELECT MAX(h.CHECK_DATE) FROM IB_SMT_CHECKHIST h
                                 WHERE h.LINE_CODE = :lineCode
                                   AND h.LOT_NAME = :lotName
                                   AND h.LOCATION_CODE = :locationCode
                                   AND h.PARTNAME = :itemCode
                                   AND h.CHECK_TYPE = '1' )
        ORDER BY c.CHECK_DATE DESC
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        lineCode: query.lineCode,
        lotName: query.lotName,
        locationCode: query.locationCode,
        itemCode: query.itemCode,
      }),
    )) as Row[];
    return { data: rows, total: rows.length, truncated: rows.length >= ROW_LIMIT };
  }

  /** 라인의 센서 실적 (PB d_pln_product_sensor_actual_4_feeder — 피더 화면 머리글) */
  async findLineActual(query: FeederMonitorQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT a.LINE_CODE                               AS "lineCode",
              a.MODEL_NAME                              AS "modelName",
              a.MODEL_SUFFIX                            AS "modelSuffix",
              m.SMT_MODEL_NAME                          AS "smtModelName",
              a.WORKSTAGE_CODE                          AS "workstageCode",
              a.PRODUCT_ACTUAL_QTY                      AS "productActualQty",
              a.PRODUCT_ACTUAL_SUM                      AS "productActualSum",
              a.ADJUST_QTY                              AS "adjustQty",
              a.ORIGIN_COUNT                            AS "originCount",
              a.RUN_NO                                  AS "runNo",
              a.PCB_ITEM                                AS "pcbItem",
              a.IS_LAST_YN                              AS "isLastYn",
              TO_CHAR(a.RECEIPT_DATE, 'YYYY-MM-DD HH24:MI:SS')      AS "receiptDate",
              TO_CHAR(a.LAST_RECEIPT_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "lastReceiptDate"
         FROM IP_PRODUCT_SENSOR_ACTUAL a
         LEFT JOIN IP_PRODUCT_MODEL_MASTER m ON m.MODEL_NAME = a.MODEL_NAME
        WHERE a.LINE_CODE = :lineCode
          AND a.ORGANIZATION_ID = :organizationId
        ORDER BY a.RECEIPT_DATE DESC, a.WORKSTAGE_CODE
        FETCH FIRST 200 ROWS ONLY`,
      namedBinds({ lineCode: query.lineCode, organizationId }),
    )) as Row[];
    return { data: rows, total: rows.length };
  }

  /**
   * 피더 잔량 세팅 (PB 'Set Feeding Qty' — **쓰기**).
   *
   * 마지막 CCS 투입 이후 스캔된 수량 합을 FEEDING_QTY 에 적는다.
   * PB 는 그리드 행마다 SELECT → UPDATE 를 돌렸다. 여기서는 한 문장으로 한다 —
   * 결과는 같고 라인 하나가 300자리면 왕복 600번이 1번이 된다.
   *
   * PB 의 WHERE 를 그대로 둔다 (LINE_CODE + MODEL_NAME + LOCATION_CODE + ITEM_CODE
   * + ACTIVE_YN='Y'). 유일인덱스보다 느슨해 같은 자리의 여러 설비·테이블 행이 함께
   * 바뀔 수 있다 — PB 의 동작이고, 피더 잔량은 자리 단위 값이라 그게 맞다.
   * 몇 행이 바뀌었는지 돌려준다.
   */
  async setFeedingQty(query: FeederMonitorQueryDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      const result = await qr.query(
        `UPDATE IB_PRODUCT_PLANDATA p
            SET FEEDING_QTY = NVL(( SELECT SUM(
                                      ( SELECT DECODE(NVL(b.NEW_SCAN_QTY, 0), 0,
                                                      b.SCAN_QTY, NVL(b.NEW_SCAN_QTY, 0))
                                          FROM IM_ITEM_RECEIPT_BARCODE b
                                         WHERE b.ITEM_CODE = c.ITEM_CODE
                                           AND b.LOT_NO = c.LOT_NO ))
                                 FROM IB_SMT_CHECKHIST c
                                WHERE c.LINE_CODE = p.LINE_CODE
                                  AND c.LOT_NAME = p.MODEL_NAME
                                  AND c.LOCATION_CODE = p.LOCATION_CODE
                                  AND c.PARTNAME = p.ITEM_CODE
                                  AND c.CHECK_TYPE IN ('1', '2')
                                  AND c.CHECK_STATUS = 'P'
                                  AND c.CHECK_DATE >=
                                      ( SELECT MAX(h.CHECK_DATE) FROM IB_SMT_CHECKHIST h
                                         WHERE h.LINE_CODE = p.LINE_CODE
                                           AND h.LOT_NAME = p.MODEL_NAME
                                           AND h.LOCATION_CODE = p.LOCATION_CODE
                                           AND h.PARTNAME = p.ITEM_CODE
                                           AND h.CHECK_STATUS = 'P'
                                           AND h.CHECK_TYPE = '1' ) ),
                                FEEDING_QTY),
                LAST_MODIFY_BY = :userId,
                LAST_MODIFY_DATE = SYSDATE
          WHERE p.LINE_CODE = :lineCode
            AND NVL(p.MODEL_NAME, '*') LIKE :modelName ESCAPE '\\'
            AND NVL(p.ITEM_CODE, '*') LIKE :itemCode ESCAPE '\\'
            AND p.ACTIVE_YN = 'Y'
            AND p.ORGANIZATION_ID = :organizationId`,
        namedBinds({
          userId,
          lineCode: query.lineCode,
          modelName: likePrefix(query.modelName),
          itemCode: likePrefix(query.itemCode),
          organizationId,
        }),
      );
      return {
        lineCode: query.lineCode,
        changed: Number(affectedRows(result) ?? 0),
      };
    });
  }
}
