/**
 * @file src/modules/smt/smt-pickup.service.ts
 * @description 마운터 픽업정보관리 — PB w_mcn_feeder_pickup_master 이식
 *
 * 초보자 가이드:
 * 1. **PICKUP_RATE 는 이름과 달리 "픽업 성공률" 이 아니다.**
 *    PB 식이 `흡착에러 / 이송횟수 * 100` 이라 **에러율**이다. 컬럼명이 그렇게
 *    붙어 있으니 값은 PB 와 똑같이 넣고, 화면 라벨만 '흡착에러율' 로 적는다.
 *    식을 뒤집으면 PB 화면과 웹 화면의 같은 행이 다른 숫자를 보인다.
 * 2. **이송횟수가 0 이면 0 으로 둔다.** PB 와 같다 — 0 으로 나누지 않는다.
 * 3. **적재는 (생산일 + 라인 + 조직) 단위로 갈아끼운다.** PB 는 엑셀 행마다
 *    같은 DELETE 를 다시 돌렸다(루프 안에 DELETE 가 있다). 결과는 같지만
 *    여기서는 한 번만 지우고 한 번에 넣는다.
 * 4. **이 테이블은 이 DB 에서 0행이다** — 은성에서 아직 쓰지 않은 기능이다.
 *    유일제약도 없어(비유일 인덱스만 있다) 같은 피더가 두 줄 들어갈 수 있다.
 *    그래서 적재 전에 범위를 지운다.
 */
import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { TransactionService } from '../../shared/transaction.service';
import {
  SmtPickupDeleteDto,
  SmtPickupQueryDto,
  SmtPickupUploadDto,
} from './smt-pickup.dto';
import { affectedRows } from '../../common/utils/affected-rows.util';
import { namedBinds } from '../../common/utils/named-binds.util';

@Injectable()
export class SmtPickupService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  private like(value?: string): string {
    return `${(value ?? '').trim()}%`;
  }

  /** 목록 — PB d_mcn_feeder_pickup_lst. */
  async find(query: SmtPickupQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT TO_CHAR(p.PRODUCT_DATE, 'YYYY-MM-DD') AS "productDate",
              p.LINE_CODE AS "lineCode", l.LINE_NAME AS "lineName",
              p.MODEL_NAME AS "modelName",
              p.ITEM_CODE AS "itemCode", i.ITEM_NAME AS "itemName",
              i.ITEM_SPEC AS "itemSpec",
              p.FEEDER_ID AS "feederId", p.FEEDER_TYPE AS "feederType",
              p.TRANSFER_COUNT AS "transferCount",
              p.ADSORPTION_ERROR_COUNT AS "adsorptionErrorCount",
              p.PICKUP_RATE AS "pickupRate",
              p.PICKUP_STATUS AS "pickupStatus", p.ACTION_PLAN AS "actionPlan",
              p.ENTER_BY AS "enterBy", p.ENTER_DATE AS "enterDate",
              p.LAST_MODIFY_BY AS "lastModifyBy", p.LAST_MODIFY_DATE AS "lastModifyDate"
         FROM IQ_MACHINE_INSPECT_DATA_PICKUP p
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = p.ITEM_CODE AND i.ORGANIZATION_ID = p.ORGANIZATION_ID
         LEFT JOIN IP_PRODUCT_LINE l
                ON l.LINE_CODE = p.LINE_CODE AND l.ORGANIZATION_ID = p.ORGANIZATION_ID
        WHERE p.ORGANIZATION_ID = :organizationId
          AND p.PRODUCT_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND p.PRODUCT_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND NVL(p.LINE_CODE, '*') LIKE :lineCode
          AND NVL(p.MODEL_NAME, '*') LIKE :modelName
          AND NVL(p.ITEM_CODE, '*') LIKE :itemCode
          AND NVL(p.FEEDER_ID, '*') LIKE :feederId
        ORDER BY p.PRODUCT_DATE DESC, p.LINE_CODE, p.FEEDER_ID`,
      namedBinds({
          organizationId,
          dateFrom: query.dateFrom,
          dateTo: query.dateTo,
          lineCode: this.like(query.lineCode),
          modelName: this.like(query.modelName),
          itemCode: this.like(query.itemCode),
          feederId: this.like(query.feederId),
        }),
    )) as Record<string, unknown>[];
    return { data: rows, total: rows.length };
  }

  /**
   * 엑셀 적재 — PB cb('Excel Upload').
   * 같은 (생산일 + 라인 + 조직) 범위를 먼저 비우고 새로 넣는다.
   */
  async upload(dto: SmtPickupUploadDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      const deleted = await qr.query(
        `DELETE FROM IQ_MACHINE_INSPECT_DATA_PICKUP
          WHERE PRODUCT_DATE = TO_DATE(:productDate, 'YYYY-MM-DD')
            AND LINE_CODE = :lineCode
            AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ productDate: dto.productDate, lineCode: dto.lineCode, organizationId }),
      );
      const removed = Number(affectedRows(deleted) ?? 0);

      for (const row of dto.rows) {
        // PB 식 그대로: 이송횟수가 0 이면 0, 아니면 흡착에러 / 이송횟수 * 100
        const rate =
          row.transferCount === 0
            ? 0
            : (row.adsorptionErrorCount / row.transferCount) * 100;

        await qr.query(
          `INSERT INTO IQ_MACHINE_INSPECT_DATA_PICKUP
             (PRODUCT_DATE, LINE_CODE, MODEL_NAME, ITEM_CODE,
              FEEDER_ID, FEEDER_TYPE, TRANSFER_COUNT, ADSORPTION_ERROR_COUNT,
              PICKUP_RATE, PICKUP_STATUS, ORGANIZATION_ID,
              ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE)
           VALUES
             (TO_DATE(:productDate, 'YYYY-MM-DD'), :lineCode, :modelName, :itemCode,
              :feederId, :feederType, :transferCount, :adsorptionErrorCount,
              :pickupRate, 'OK', :organizationId,
              :userId, SYSDATE, :userId, SYSDATE)`,
          namedBinds({
              productDate: dto.productDate,
              lineCode: dto.lineCode,
              modelName: dto.modelName ?? null,
              itemCode: row.itemCode ?? null,
              feederId: row.feederId,
              feederType: row.feederType ?? null,
              transferCount: row.transferCount,
              adsorptionErrorCount: row.adsorptionErrorCount,
              pickupRate: rate,
              organizationId,
              userId,
            }),
        );
      }

      return { replaced: removed, inserted: dto.rows.length };
    });
  }

  /** 범위 삭제 — 생산일 + 라인. */
  async remove(dto: SmtPickupDeleteDto, organizationId: number) {
    return this.tx.run(async (qr) => {
      const result = await qr.query(
        `DELETE FROM IQ_MACHINE_INSPECT_DATA_PICKUP
          WHERE PRODUCT_DATE = TO_DATE(:productDate, 'YYYY-MM-DD')
            AND LINE_CODE = :lineCode
            AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ productDate: dto.productDate, lineCode: dto.lineCode, organizationId }),
      );
      return { deleted: Number(affectedRows(result) ?? 0) };
    });
  }
}
