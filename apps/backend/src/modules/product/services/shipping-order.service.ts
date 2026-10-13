/**
 * @file src/modules/product/services/shipping-order.service.ts
 * @description 제품납품계획(출하지시) — IP_PRODUCT_DELIVERY_PLAN 등록과 출고 박스 연결
 *
 * 초보자 가이드:
 * 1. 출하지시는 고객 납품 계획(고객·모델·수량·납기)이다. 생산지시(런카드)와 따로 내려간다.
 * 2. 출하지시번호 = MFS = 'DLV' + 납기일 YYMMDD + 3자리 순번. 테이블에 PK 가 없어 서버가 중복을 막는다.
 * 3. 출하에는 라인이 없지만 LINE_CODE 가 NOT NULL 이라 '*' 를 넣는다. MODEL_SUFFIX·ITEM_CODE 는 모델마스터에서 채운다.
 * 4. 출고(P_PRODUCT_FG_ISSUE) 직후 같은 트랜잭션에서 박스를 잇는다:
 *    IP_PRODUCT_FG_ISSUE·IP_PRODUCT_PACK_MASTER 의 SHIP_NO 를 지시번호로 바꾸고 ACTUAL_QTY 를 더한다.
 *    SHIP_NO 는 프로시저가 시각으로 만드는 값이고 다른 곳에서 쓰지 않는다.
 * 5. 출고 취소는 박스의 SHIP_NO 로 지시를 찾아 ACTUAL_QTY 를 되돌린다.
 * 6. 상태: 실적 0 = W(대기) / 일부 = P / 지시수량 도달 = C(완료). 공통코드 PLAN STATUS 값이다.
 */
import { BadRequestException, ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { namedBinds } from '../../../common/utils/named-binds.util';
import { TransactionService } from '../../../shared/transaction.service';
import { ShippingOrderQueryDto, ShippingOrderUpsertDto } from '../dto/shipping-order.dto';

/** 트랜잭션 QueryRunner 처럼 query 만 쓰는 대상 */
type Q = { query: (sql: string, params?: unknown[]) => Promise<unknown> };
type Row = Record<string, unknown>;

export const SHIP_ORDER_PREFIX = 'DLV';

export function shipOrderNo(planDate: string, seq: number): string {
  return `${SHIP_ORDER_PREFIX}${planDate.slice(2, 4)}${planDate.slice(5, 7)}${planDate.slice(8, 10)}${String(seq).padStart(3, '0')}`;
}

export function nextStatus(planQty: number, actualQty: number): 'W' | 'P' | 'C' {
  if (actualQty <= 0) return 'W';
  return actualQty >= planQty ? 'C' : 'P';
}

@Injectable()
export class ShippingOrderService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  async list(query: ShippingOrderQueryDto, organizationId: number) {
    return this.dataSource.query(
      `SELECT d.MFS AS "shipOrderNo", TO_CHAR(d.PLAN_DATE, 'YYYY-MM-DD') AS "planDate", d.PLAN_SEQUENCE AS "planSequence",
              d.CUSTOMER_CODE AS "customerCode", cu.CUSTOMER_NAME AS "customerName",
              d.MODEL_NAME AS "modelName", d.MODEL_SUFFIX AS "modelSuffix", d.ITEM_CODE AS "itemCode",
              d.PLAN_QTY AS "planQty", NVL(d.ACTUAL_QTY, 0) AS "actualQty",
              d.PLAN_QTY - NVL(d.ACTUAL_QTY, 0) AS "remainQty",
              NVL(d.PLAN_STATUS, 'W') AS "planStatus", d.COMMENTS AS "comments"
         FROM IP_PRODUCT_DELIVERY_PLAN d
         LEFT JOIN ICOM_CUSTOMER cu ON cu.CUSTOMER_CODE = d.CUSTOMER_CODE AND cu.ORGANIZATION_ID = d.ORGANIZATION_ID
        WHERE d.ORGANIZATION_ID = :organizationId
          AND d.MFS LIKE '${SHIP_ORDER_PREFIX}%'
          AND d.PLAN_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD') AND d.PLAN_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND NVL(d.CUSTOMER_CODE, '*') LIKE :customerCode
          AND d.MODEL_NAME LIKE :modelName
          ${query.openOnly === 'Y' ? "AND NVL(d.PLAN_STATUS, 'W') <> 'C'" : ''}
        ORDER BY d.PLAN_DATE, d.PLAN_SEQUENCE`,
      namedBinds({
        organizationId, dateFrom: query.dateFrom, dateTo: query.dateTo,
        customerCode: query.customerCode?.trim() || '%',
        modelName: query.modelName?.trim() ? `%${query.modelName.trim()}%` : '%',
      }),
    ) as Promise<Row[]>;
  }

  async create(dto: ShippingOrderUpsertDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      const model = await this.model(qr, dto.modelName, organizationId);
      // 같은 납기일 순번은 MAX+1 로 잡고, 번호가 겹치면 다시 잡는다
      for (let attempt = 0; attempt < 3; attempt += 1) {
        const seqRows = await qr.query(
          `SELECT NVL(MAX(PLAN_SEQUENCE), 0) + 1 + :attempt AS "seq" FROM IP_PRODUCT_DELIVERY_PLAN
            WHERE PLAN_DATE = TO_DATE(:planDate, 'YYYY-MM-DD') AND ORGANIZATION_ID = :organizationId`,
          namedBinds({ attempt, planDate: dto.planDate, organizationId }),
        ) as Array<{ seq: number }>;
        const seq = Number(seqRows[0]?.seq ?? 1);
        const no = shipOrderNo(dto.planDate, seq);
        const dup = await qr.query(
          `SELECT COUNT(*) AS "cnt" FROM IP_PRODUCT_DELIVERY_PLAN WHERE MFS = :no AND ORGANIZATION_ID = :organizationId`,
          namedBinds({ no, organizationId }),
        ) as Array<{ cnt: number }>;
        if (Number(dup[0]?.cnt ?? 0) > 0) continue;
        await qr.query(
          `INSERT INTO IP_PRODUCT_DELIVERY_PLAN
             (PLAN_DATE, PLAN_SEQUENCE, LINE_CODE, MFS, MODEL_NAME, MODEL_SUFFIX, ITEM_CODE, PLAN_QTY, ACTUAL_QTY,
              CUSTOMER_CODE, PLAN_STATUS, COMMENTS, ORGANIZATION_ID, ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
           VALUES (TO_DATE(:planDate, 'YYYY-MM-DD'), :seq, '*', :no, :modelName, :modelSuffix, :itemCode, :planQty, 0,
                   :customerCode, 'W', :comments, :organizationId, SYSDATE, :userId, SYSDATE, :userId)`,
          namedBinds({
            planDate: dto.planDate, seq, no, modelName: dto.modelName, modelSuffix: model.modelSuffix,
            itemCode: model.itemCode, planQty: dto.planQty, customerCode: dto.customerCode,
            comments: dto.comments?.trim() || null, organizationId, userId,
          }),
        );
        return { shipOrderNo: no };
      }
      throw new ConflictException('출하지시번호를 만들지 못했습니다. 다시 시도하세요.');
    });
  }

  async update(no: string, dto: ShippingOrderUpsertDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      const cur = await this.lock(qr, no, organizationId);
      if (cur.actualQty > 0 && cur.modelName !== dto.modelName) {
        throw new ConflictException('출고된 박스가 있어 모델을 바꿀 수 없습니다.');
      }
      if (dto.planQty < cur.actualQty) {
        throw new BadRequestException(`지시수량은 이미 출고한 수량(${cur.actualQty})보다 작을 수 없습니다.`);
      }
      const model = await this.model(qr, dto.modelName, organizationId);
      await qr.query(
        `UPDATE IP_PRODUCT_DELIVERY_PLAN
            SET PLAN_DATE = TO_DATE(:planDate, 'YYYY-MM-DD'), CUSTOMER_CODE = :customerCode, MODEL_NAME = :modelName,
                MODEL_SUFFIX = :modelSuffix, ITEM_CODE = :itemCode, PLAN_QTY = :planQty, PLAN_STATUS = :planStatus,
                COMMENTS = :comments, LAST_MODIFY_DATE = SYSDATE, LAST_MODIFY_BY = :userId
          WHERE MFS = :no AND ORGANIZATION_ID = :organizationId`,
        namedBinds({
          planDate: dto.planDate, customerCode: dto.customerCode, modelName: dto.modelName,
          modelSuffix: model.modelSuffix, itemCode: model.itemCode, planQty: dto.planQty,
          planStatus: nextStatus(dto.planQty, cur.actualQty), comments: dto.comments?.trim() || null,
          userId, no, organizationId,
        }),
      );
      return { shipOrderNo: no };
    });
  }

  async remove(no: string, organizationId: number) {
    return this.tx.run(async (qr) => {
      const cur = await this.lock(qr, no, organizationId);
      if (cur.actualQty > 0) throw new ConflictException('출고된 박스가 있는 출하지시는 지울 수 없습니다.');
      await qr.query(
        `DELETE FROM IP_PRODUCT_DELIVERY_PLAN WHERE MFS = :no AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ no, organizationId }),
      );
      return { shipOrderNo: no };
    });
  }

  /** 박스 출고 직후(같은 트랜잭션) — 박스를 지시에 잇는다 */
  async linkIssuedBox(qr: Q, no: string, barcode: string, organizationId: number, userId: string) {
    const order = await this.lock(qr, no, organizationId);
    if (order.planStatus === 'C') throw new ConflictException(`출하지시 ${no} 는 이미 완료됐습니다.`);
    const box = await this.box(qr, barcode, organizationId);
    if (box.modelName !== order.modelName) {
      throw new BadRequestException(`박스 모델(${box.modelName})이 출하지시 모델(${order.modelName})과 다릅니다.`);
    }
    const actualQty = order.actualQty + box.qty;
    if (actualQty > order.planQty) {
      throw new ConflictException(`출하지시 수량을 넘습니다 (지시 ${order.planQty}, 출고 ${order.actualQty} + 박스 ${box.qty}).`);
    }
    await this.setShipNo(qr, barcode, no, organizationId, userId);
    await this.saveActual(qr, no, order.planQty, actualQty, organizationId, userId);
  }

  /** 박스 출고 취소 직후(같은 트랜잭션) — 지시 실적을 되돌린다 */
  async unlinkCancelledBox(qr: Q, no: string, barcode: string, organizationId: number, userId: string) {
    const order = await this.lock(qr, no, organizationId);
    const box = await this.box(qr, barcode, organizationId);
    await this.saveActual(qr, no, order.planQty, Math.max(0, order.actualQty - box.qty), organizationId, userId);
  }

  /** 박스가 출하지시로 나갔으면 그 지시번호 */
  async shipOrderOfBox(qr: Q, barcode: string, organizationId: number): Promise<string | null> {
    const rows = await qr.query(
      `SELECT SHIP_NO AS "shipNo" FROM IP_PRODUCT_PACK_MASTER WHERE PACK_BARCODE = :barcode AND ORGANIZATION_ID = :organizationId`,
      namedBinds({ barcode, organizationId }),
    ) as Array<{ shipNo: string | null }>;
    const shipNo = rows[0]?.shipNo ?? null;
    return shipNo?.startsWith(SHIP_ORDER_PREFIX) ? shipNo : null;
  }

  private async lock(qr: Q, no: string, organizationId: number) {
    const rows = await qr.query(
      `SELECT MODEL_NAME AS "modelName", PLAN_QTY AS "planQty", NVL(ACTUAL_QTY, 0) AS "actualQty",
              NVL(PLAN_STATUS, 'W') AS "planStatus"
         FROM IP_PRODUCT_DELIVERY_PLAN WHERE MFS = :no AND ORGANIZATION_ID = :organizationId FOR UPDATE`,
      namedBinds({ no, organizationId }),
    ) as Array<{ modelName: string; planQty: number; actualQty: number; planStatus: string }>;
    if (!rows[0]) throw new NotFoundException(`출하지시 ${no} 가 없습니다.`);
    return { ...rows[0], planQty: Number(rows[0].planQty), actualQty: Number(rows[0].actualQty) };
  }

  private async box(qr: Q, barcode: string, organizationId: number) {
    const rows = await qr.query(
      `SELECT MODEL_NAME AS "modelName", PACK_QTY AS "qty" FROM IP_PRODUCT_PACK_MASTER
        WHERE PACK_BARCODE = :barcode AND ORGANIZATION_ID = :organizationId`,
      namedBinds({ barcode, organizationId }),
    ) as Array<{ modelName: string; qty: number }>;
    if (!rows[0]) throw new BadRequestException(`포장 박스 ${barcode} 를 찾을 수 없습니다.`);
    return { modelName: rows[0].modelName, qty: Number(rows[0].qty ?? 0) };
  }

  private async model(qr: Q, modelName: string, organizationId: number) {
    const rows = await qr.query(
      `SELECT MODEL_SUFFIX AS "modelSuffix", ITEM_CODE AS "itemCode" FROM IP_PRODUCT_MODEL_MASTER
        WHERE MODEL_NAME = :modelName AND ORGANIZATION_ID = :organizationId`,
      namedBinds({ modelName, organizationId }),
    ) as Array<{ modelSuffix: string | null; itemCode: string | null }>;
    if (!rows[0]) throw new BadRequestException(`모델마스터에 ${modelName} 이 없습니다.`);
    return { modelSuffix: rows[0].modelSuffix ?? '*', itemCode: rows[0].itemCode };
  }

  private async setShipNo(qr: Q, barcode: string, no: string, organizationId: number, userId: string) {
    // 방금 프로시저가 넣은 출고 행 = 그 바코드의 가장 늦은 출고 행
    await qr.query(
      `UPDATE IP_PRODUCT_FG_ISSUE SET SHIP_NO = :no, LAST_MODIFY_DATE = SYSDATE, LAST_MODIFY_BY = :userId
        WHERE ROWID = (SELECT MAX(ROWID) KEEP (DENSE_RANK LAST ORDER BY ISSUE_DATE, ISSUE_SEQUENCE)
                         FROM IP_PRODUCT_FG_ISSUE WHERE BARCODE = :barcode AND ORGANIZATION_ID = :organizationId)`,
      namedBinds({ no, userId, barcode, organizationId }),
    );
    await qr.query(
      `UPDATE IP_PRODUCT_PACK_MASTER SET SHIP_NO = :no, LAST_MODIFY_DATE = SYSDATE, LAST_MODIFY_BY = :userId
        WHERE PACK_BARCODE = :barcode AND ORGANIZATION_ID = :organizationId`,
      namedBinds({ no, userId, barcode, organizationId }),
    );
  }

  private async saveActual(qr: Q, no: string, planQty: number, actualQty: number, organizationId: number, userId: string) {
    await qr.query(
      `UPDATE IP_PRODUCT_DELIVERY_PLAN SET ACTUAL_QTY = :actualQty, PLAN_STATUS = :planStatus,
              LAST_MODIFY_DATE = SYSDATE, LAST_MODIFY_BY = :userId
        WHERE MFS = :no AND ORGANIZATION_ID = :organizationId`,
      namedBinds({ actualQty, planStatus: nextStatus(planQty, actualQty), userId, no, organizationId }),
    );
  }
}
