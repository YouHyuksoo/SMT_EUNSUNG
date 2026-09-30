/**
 * @file src/modules/planning/smd-actual.service.ts
 * @description 반제품생산실적관리 — PB w_pln_assembly_actual_master 이식
 *
 * 초보자 가이드:
 * 1. **이 표는 센서가 올린 생산실적이다.** 라인 센서가 카운트를 올리면 한 줄이
 *    쌓인다. 109,644행 있고 계속 늘어난다 — 그래서 조회는 기간이 필수다.
 * 2. **집계일시(RECEIPT_DATE)는 시각까지 있는 DATE 다.** ISO 문자열로 왕복시키면
 *    JSON 직렬화가 UTC 로 바꾸는 바람에 9시간 밀린다(백엔드는 KST 고정).
 *    그래서 목록은 `receiptDateKey`(YYYYMMDDHH24MISS)를 함께 내리고,
 *    수정·삭제는 그 불투명 키로만 행을 찾는다.
 * 3. **고칠 수 있는 것은 실적수량과 보정수량뿐이다.** 센서 원시값(ORIGIN_COUNT)은
 *    건드리지 않는다 — 고치면 센서 이력과 화면이 갈려 원인을 못 찾는다.
 * 4. 캐리어 규격은 SQL 안에서 F_GET_CARRIER_SIZE 를 그대로 부른다.
 *    PB 도 같았다 — TypeScript 로 다시 계산하면 PB 화면과 값이 갈린다.
 */
import { Injectable, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { TransactionService } from '../../shared/transaction.service';
import { SmdActualKeyDto, SmdActualQueryDto, SmdActualUpdateDto } from './smd-actual.dto';
import { like } from './plan-shared';
import { affectedRows } from '../../common/utils/affected-rows.util';

type Row = Record<string, unknown>;

@Injectable()
export class SmdActualService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  /** 목록 — PB d_pln_product_sensor_actual_time_modify. */
  async find(query: SmdActualQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT a.RECEIPT_DATE AS "receiptDate",
              TO_CHAR(a.RECEIPT_DATE, 'YYYYMMDDHH24MISS') AS "receiptDateKey",
              a.RECEIPT_SEQUENCE AS "receiptSequence",
              a.LINE_CODE AS "lineCode", pl.LINE_NAME AS "lineName",
              a.MODEL_NAME AS "modelName", a.MODEL_SUFFIX AS "modelSuffix",
              a.WORKSTAGE_CODE AS "workstageCode",
              a.PCB_ITEM AS "pcbItem", pcb.CODE_MEAN_KOR AS "pcbItemName",
              a.PRODUCT_ACTUAL_QTY AS "productActualQty",
              a.PRODUCT_ACTUAL_SUM AS "productActualSum",
              a.PRODUCT_ACTUAL_LOST_QTY AS "productActualLostQty",
              a.ORIGIN_COUNT AS "originCount",
              a.ADJUST_QTY AS "adjustQty",
              a.ACTUAL_TYPE AS "actualType",
              a.TIME_DIVISION AS "timeDivision",
              a.IS_LAST_YN AS "isLastYn",
              a.LAST_RECEIPT_DATE AS "lastReceiptDate",
              F_GET_CARRIER_SIZE(a.MODEL_NAME, a.ORGANIZATION_ID) AS "carrierSize",
              a.ENTER_BY AS "enterBy", a.ENTER_DATE AS "enterDate",
              a.LAST_MODIFY_BY AS "lastModifyBy", a.LAST_MODIFY_DATE AS "lastModifyDate"
         FROM IP_PRODUCT_SENSOR_ACTUAL_TIME a
         LEFT JOIN IP_PRODUCT_LINE pl
                ON pl.LINE_CODE = a.LINE_CODE
               AND pl.ORGANIZATION_ID = a.ORGANIZATION_ID
         LEFT JOIN ISYS_BASECODE pcb
                ON pcb.CODE_TYPE = 'PCB ITEM' AND pcb.CODE_NAME = a.PCB_ITEM
        WHERE a.ORGANIZATION_ID = :organizationId
          AND a.RECEIPT_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND a.RECEIPT_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND NVL(a.LINE_CODE, '*') LIKE :lineCode
          AND NVL(a.MODEL_NAME, '*') LIKE :modelName
          AND NVL(a.WORKSTAGE_CODE, '*') LIKE :workstageCode
        ORDER BY a.RECEIPT_DATE DESC, a.RECEIPT_SEQUENCE DESC`,
      {
        organizationId,
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        lineCode: like(query.lineCode),
        modelName: like(query.modelName),
        workstageCode: like(query.workstageCode),
      } as unknown as unknown[],
    )) as Row[];
    return { data: rows, total: rows.length };
  }

  /**
   * 라인·모델별 합계 — PB 는 그리드 합계행으로 보여줬다.
   * 목록과 같은 조건을 쓰되 행을 접어 내린다.
   */
  async findSummary(query: SmdActualQueryDto, organizationId: number) {
    return (await this.dataSource.query(
      `SELECT a.LINE_CODE AS "lineCode", pl.LINE_NAME AS "lineName",
              a.MODEL_NAME AS "modelName",
              COUNT(*) AS "rowCount",
              SUM(NVL(a.PRODUCT_ACTUAL_QTY, 0)) AS "productActualQty",
              SUM(NVL(a.ADJUST_QTY, 0)) AS "adjustQty",
              SUM(NVL(a.PRODUCT_ACTUAL_LOST_QTY, 0)) AS "productActualLostQty",
              MIN(a.RECEIPT_DATE) AS "firstDate",
              MAX(a.RECEIPT_DATE) AS "lastDate"
         FROM IP_PRODUCT_SENSOR_ACTUAL_TIME a
         LEFT JOIN IP_PRODUCT_LINE pl
                ON pl.LINE_CODE = a.LINE_CODE
               AND pl.ORGANIZATION_ID = a.ORGANIZATION_ID
        WHERE a.ORGANIZATION_ID = :organizationId
          AND a.RECEIPT_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND a.RECEIPT_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND NVL(a.LINE_CODE, '*') LIKE :lineCode
          AND NVL(a.MODEL_NAME, '*') LIKE :modelName
          AND NVL(a.WORKSTAGE_CODE, '*') LIKE :workstageCode
        GROUP BY a.LINE_CODE, pl.LINE_NAME, a.MODEL_NAME
        ORDER BY a.LINE_CODE, a.MODEL_NAME`,
      {
        organizationId,
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        lineCode: like(query.lineCode),
        modelName: like(query.modelName),
        workstageCode: like(query.workstageCode),
      } as unknown as unknown[],
    )) as Row[];
  }

  /** 불투명 키로 행을 찾는 WHERE. 날짜를 문자열로 왕복시키지 않는다. */
  private readonly KEY_WHERE = `
    TO_CHAR(RECEIPT_DATE, 'YYYYMMDDHH24MISS') = :receiptDateKey
    AND RECEIPT_SEQUENCE = :receiptSequence
    AND ORGANIZATION_ID = :organizationId`;

  async update(dto: SmdActualUpdateDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      const result = await qr.query(
        `UPDATE IP_PRODUCT_SENSOR_ACTUAL_TIME
            SET PRODUCT_ACTUAL_QTY = :productActualQty,
                ADJUST_QTY = :adjustQty,
                LAST_MODIFY_BY = :userId,
                LAST_MODIFY_DATE = SYSDATE
          WHERE ${this.KEY_WHERE}`,
        {
          productActualQty: dto.productActualQty,
          adjustQty: dto.adjustQty ?? null,
          userId,
          receiptDateKey: dto.receiptDateKey,
          receiptSequence: dto.receiptSequence,
          organizationId,
        } as unknown as unknown[],
      );
      const affected = Number(affectedRows(result) ?? 0);
      if (affected === 0) throw new NotFoundException('생산실적을 찾을 수 없습니다.');
      return { changed: affected };
    });
  }

  async remove(key: SmdActualKeyDto, organizationId: number) {
    return this.tx.run(async (qr) => {
      const result = await qr.query(
        `DELETE FROM IP_PRODUCT_SENSOR_ACTUAL_TIME WHERE ${this.KEY_WHERE}`,
        {
          receiptDateKey: key.receiptDateKey,
          receiptSequence: key.receiptSequence,
          organizationId,
        } as unknown as unknown[],
      );
      const affected = Number(affectedRows(result) ?? 0);
      if (affected === 0) throw new NotFoundException('생산실적을 찾을 수 없습니다.');
      return { deleted: affected };
    });
  }
}
