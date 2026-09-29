/**
 * @file src/modules/purchase/arrival.service.ts
 * @description 483 자재출발관리 · 484 자재도착관리 — PB
 *   `w_mat_departure_master` · `w_mat_arrival_master` 이식 (**쓰기**)
 *
 * 초보자 가이드:
 * 1. **주문한 자재가 오는 동안을 따라가는 화면이다.** 협력사가 물건을 보내면
 *    *출발*로 적고, 우리 쪽에 닿으면 *도착*으로 바꾼다. 그 뒤가 입고(253)다.
 * 2. **출발과 도착이 같은 표를 쓴다** (`IM_ITEM_ARRIVAL`). 구분은 `ARRIVAL_TYPE`
 *    한 칸이다 — 공통코드 실측:
 *        `'D'` 출발 · `'A'` 도착 · `'R'` 입고
 *    PB 도 출발로 만든 행의 이 칸을 `'D'` → `'A'` 로 **바꿀 뿐** 새 행을 만들지 않는다.
 *    그래서 웹도 같다 — 행이 늘면 도착수량이 두 배로 잡힌다.
 * 3. **상태는 정상/취소 둘이다** (`ARRIVAL_STATUS`): `'N'` 정상 · `'C'` 취소.
 *    잘못 적은 출발은 지우지 않고 취소로 둔다 — 협력사와 맞춰볼 근거가 남아야 한다.
 * 4. **출발 수량은 주문 잔량을 넘을 수 없다.** PB 는 막지 않았지만, 넘기면
 *    입고 때 주문보다 많이 들어온 것이 되어 원장이 어긋난다.
 * 5. **이 표는 지금 비어 있다** (실측 0행). 쓰기는 parse 까지만 검증했다 —
 *    현장 확인이 반드시 필요하다.
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { limited, ROW_LIMIT } from '../../shared/row-limit';
import { TransactionService } from '../../shared/transaction.service';
import {
  ArrivalConfirmDto,
  ArrivalQueryDto,
  DepartureCreateDto,
  OrderForArrivalQueryDto,
} from './purchase.dto';

type Row = Record<string, unknown>;

/** 공통코드 `ARRIVAL TYPE` 실측값. */
export const ARRIVAL_TYPE = { departure: 'D', arrival: 'A', receipt: 'R' } as const;

/** 공통코드 `ARRIVAL STATUS` 실측값. */
export const ARRIVAL_STATUS = { normal: 'N', cancelled: 'C' } as const;

/** 출발 순번 채번. */
const SEQUENCE = 'SEQ_MAT_ARRIVAL';

@Injectable()
export class ArrivalService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  // ───────────────────────────────── 조회

  /** 483·484 출발·도착 목록. `arrivalType` 으로 갈래를 고른다. */
  async findArrivals(query: ArrivalQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT TO_CHAR(a.ARRIVAL_DATE, 'YYYY-MM-DD')    AS "arrivalDate",
              a.ARRIVAL_SEQ_NO      AS "arrivalSeqNo",
              a.ARRIVAL_TYPE        AS "arrivalType",
              a.ARRIVAL_STATUS      AS "arrivalStatus",
              a.ARRIVAL_QTY         AS "arrivalQty",
              a.ORDER_NO            AS "orderNo",
              a.ORDER_GROUP_NO      AS "orderGroupNo",
              a.SUPPLIER_CODE       AS "supplierCode",
              sp.SUPPLIER_NAME      AS "supplierName",
              a.LINE_TYPE           AS "lineType",
              a.UNIT_PRICE          AS "unitPrice",
              a.CURRENCY            AS "currency",
              o.ITEM_CODE           AS "itemCode",
              i.ITEM_NAME           AS "itemName",
              i.ITEM_SPEC           AS "itemSpec",
              o.ORDER_QTY           AS "orderQty",
              a.ENTER_BY            AS "enterBy",
              TO_CHAR(a.DEPARTURE_DATE, 'YYYY-MM-DD')          AS "departureDate",
              TO_CHAR(a.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')   AS "enterDate"
         FROM IM_ITEM_ARRIVAL a
         LEFT JOIN IM_ITEM_PURCHASE_ORDER o
                ON o.ORDER_NO = a.ORDER_NO
               AND o.ORGANIZATION_ID = a.ORGANIZATION_ID
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = o.ITEM_CODE
               AND i.ORGANIZATION_ID = o.ORGANIZATION_ID
         LEFT JOIN ICOM_SUPPLIER sp
                ON sp.SUPPLIER_CODE = a.SUPPLIER_CODE
               AND sp.ORGANIZATION_ID = a.ORGANIZATION_ID
        WHERE a.ORGANIZATION_ID = :organizationId
          AND a.ARRIVAL_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND a.ARRIVAL_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND NVL(a.ARRIVAL_TYPE, '*') LIKE :arrivalType
          AND NVL(a.ARRIVAL_STATUS, '*') LIKE :arrivalStatus
          AND NVL(a.SUPPLIER_CODE, '*') LIKE :supplierCode
          AND NVL(a.ORDER_NO, '*') LIKE :orderNo
        ORDER BY a.ARRIVAL_DATE DESC, a.ARRIVAL_SEQ_NO DESC
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        organizationId,
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        arrivalType: this.like(query.arrivalType),
        arrivalStatus: this.like(query.arrivalStatus),
        supplierCode: this.like(query.supplierCode),
        orderNo: this.like(query.orderNo),
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /**
   * 483 출발로 잡을 수 있는 주문 (PB `d_mat_purchase_order_4_arrival_lst`).
   *
   * **아직 덜 온 주문만** 낸다 — 주문수량에서 이미 잡힌 출발·도착 수량을 뺀
   * 잔량이 0보다 커야 한다. 취소된 행은 잔량 계산에서 뺀다.
   */
  async findOrdersForDeparture(
    query: OrderForArrivalQueryDto,
    organizationId: number,
  ) {
    const rows = (await this.dataSource.query(
      `SELECT o.ORDER_NO        AS "orderNo",
              o.ORDER_GROUP_NO  AS "orderGroupNo",
              o.SUPPLIER_CODE   AS "supplierCode",
              sp.SUPPLIER_NAME  AS "supplierName",
              o.ITEM_CODE       AS "itemCode",
              i.ITEM_NAME       AS "itemName",
              i.ITEM_SPEC       AS "itemSpec",
              i.ITEM_UOM        AS "itemUom",
              o.LINE_TYPE       AS "lineType",
              o.ORDER_QTY       AS "orderQty",
              o.UNIT_PRICE      AS "unitPrice",
              o.CURRENCY        AS "currency",
              NVL(pend.QTY, 0)  AS "pendingQty",
              o.ORDER_QTY - NVL(pend.QTY, 0) AS "remainQty",
              TO_CHAR(o.PURCHASE_ORDER_DATE, 'YYYY-MM-DD') AS "purchaseOrderDate",
              TO_CHAR(o.DELIVERY_DATE, 'YYYY-MM-DD')       AS "deliveryDate"
         FROM IM_ITEM_PURCHASE_ORDER o
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = o.ITEM_CODE
               AND i.ORGANIZATION_ID = o.ORGANIZATION_ID
         LEFT JOIN ICOM_SUPPLIER sp
                ON sp.SUPPLIER_CODE = o.SUPPLIER_CODE
               AND sp.ORGANIZATION_ID = o.ORGANIZATION_ID
         -- 이미 출발·도착으로 잡힌 수량. 취소된 것은 빼고 센다.
         LEFT JOIN (SELECT a.ORDER_NO, a.ORGANIZATION_ID, SUM(a.ARRIVAL_QTY) AS QTY
                      FROM IM_ITEM_ARRIVAL a
                     WHERE NVL(a.ARRIVAL_STATUS, 'N') <> 'C'
                     GROUP BY a.ORDER_NO, a.ORGANIZATION_ID) pend
                ON pend.ORDER_NO = o.ORDER_NO
               AND pend.ORGANIZATION_ID = o.ORGANIZATION_ID
        WHERE o.ORGANIZATION_ID = :organizationId
          AND NVL(o.SUPPLIER_CODE, '*') LIKE :supplierCode
          AND NVL(o.ORDER_NO, '*') LIKE :orderNo
          AND NVL(o.ITEM_CODE, '*') LIKE :itemCode
          AND o.ORDER_QTY - NVL(pend.QTY, 0) > 0
        ORDER BY o.DELIVERY_DATE, o.ORDER_NO
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        organizationId,
        supplierCode: this.like(query.supplierCode),
        orderNo: this.like(query.orderNo),
        itemCode: this.like(query.itemCode),
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  // ───────────────────────────────── 출발 (쓰기)

  /**
   * 483 출발을 잡는다 (**쓰기**).
   *
   * **주문 잔량을 넘길 수 없다.** 검사를 조회로만 하면 두 사람이 동시에 잡을 때
   * 뚫리므로, INSERT 문 안에서 잔량을 다시 계산해 조건으로 건다.
   */
  async createDeparture(
    dto: DepartureCreateDto,
    organizationId: number,
    userId: string,
  ) {
    if (!(dto.arrivalQty > 0)) {
      throw new BadRequestException('출발 수량을 1 이상으로 넣으세요.');
    }

    return this.tx.run(async (qr) => {
      const seqRows = (await qr.query(
        `SELECT ${SEQUENCE}.NEXTVAL AS "seq" FROM DUAL`,
      )) as Row[];
      const arrivalSeqNo = Number(seqRows[0]?.seq ?? 0);

      const inserted = await qr.query(
        `INSERT INTO IM_ITEM_ARRIVAL
           (ARRIVAL_DATE, ARRIVAL_SEQ_NO, ORGANIZATION_ID, SUPPLIER_CODE,
            DEPARTURE_DATE, ARRIVAL_QTY, ORDER_GROUP_NO, ARRIVAL_STATUS,
            ARRIVAL_TYPE, ORDER_NO, LINE_TYPE, UNIT_PRICE, CURRENCY,
            ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
         SELECT TO_DATE(:departureDate, 'YYYY-MM-DD'), :arrivalSeqNo,
                o.ORGANIZATION_ID, o.SUPPLIER_CODE,
                TO_DATE(:departureDate, 'YYYY-MM-DD'), :arrivalQty,
                o.ORDER_GROUP_NO, :arrivalStatus,
                :arrivalType, o.ORDER_NO, o.LINE_TYPE,
                NVL(o.UNIT_PRICE, 0), NVL(o.CURRENCY, 'KRW'),
                SYSDATE, :userId, SYSDATE, :userId
           FROM IM_ITEM_PURCHASE_ORDER o
          WHERE o.ORDER_NO = :orderNo
            AND o.ORGANIZATION_ID = :organizationId
            -- 잔량을 문장 안에서 다시 센다. 동시에 잡아도 넘지 않는다.
            AND o.ORDER_QTY - NVL((SELECT SUM(a.ARRIVAL_QTY)
                                     FROM IM_ITEM_ARRIVAL a
                                    WHERE a.ORDER_NO = o.ORDER_NO
                                      AND a.ORGANIZATION_ID = o.ORGANIZATION_ID
                                      AND NVL(a.ARRIVAL_STATUS, 'N') <> 'C'), 0)
                >= :arrivalQty`,
        {
          departureDate: dto.departureDate,
          arrivalSeqNo,
          arrivalQty: dto.arrivalQty,
          arrivalStatus: ARRIVAL_STATUS.normal,
          arrivalType: ARRIVAL_TYPE.departure,
          userId,
          orderNo: dto.orderNo,
          organizationId,
        } as unknown as unknown[],
      );
      const affected = Number(
        (inserted as { rowsAffected?: number })?.rowsAffected ?? 0,
      );
      if (affected !== 1) {
        throw new BadRequestException(
          '출발을 잡을 수 없습니다 (주문이 없거나 잔량을 넘습니다).',
        );
      }
      return { orderNo: dto.orderNo, arrivalSeqNo, arrivalQty: dto.arrivalQty };
    });
  }

  // ───────────────────────────────── 도착 (쓰기)

  /**
   * 484 출발한 것을 도착으로 바꾼다 (**쓰기**).
   *
   * **새 행을 만들지 않는다** — `ARRIVAL_TYPE` 을 `'D'` → `'A'` 로 바꾸고
   * 도착일을 적는다 (PB 그대로). 행을 늘리면 도착수량이 두 배로 잡힌다.
   * 주문의 `ARRIVAL_QTY` 누계도 같은 트랜잭션에서 올린다.
   */
  async confirmArrival(
    dto: ArrivalConfirmDto,
    organizationId: number,
    userId: string,
  ) {
    return this.tx.run(async (qr) => {
      const updated = await qr.query(
        `UPDATE IM_ITEM_ARRIVAL
            SET ARRIVAL_TYPE = :toType,
                ARRIVAL_DATE = TO_DATE(:arrivalDate, 'YYYY-MM-DD'),
                LAST_MODIFY_BY = :userId,
                LAST_MODIFY_DATE = SYSDATE
          WHERE ARRIVAL_SEQ_NO = :arrivalSeqNo
            AND ORGANIZATION_ID = :organizationId
            -- 출발 상태인 정상 건만 도착으로 바꾼다.
            AND ARRIVAL_TYPE = :fromType
            AND NVL(ARRIVAL_STATUS, 'N') = :normal`,
        {
          toType: ARRIVAL_TYPE.arrival,
          arrivalDate: dto.arrivalDate,
          userId,
          arrivalSeqNo: dto.arrivalSeqNo,
          organizationId,
          fromType: ARRIVAL_TYPE.departure,
          normal: ARRIVAL_STATUS.normal,
        } as unknown as unknown[],
      );
      const affected = Number(
        (updated as { rowsAffected?: number })?.rowsAffected ?? 0,
      );
      if (affected !== 1) {
        throw new BadRequestException(
          '도착으로 바꿀 수 없습니다 (출발 상태의 정상 건이 아닙니다).',
        );
      }

      // 주문의 도착 누계를 올린다. 이 값이 잔량 계산과 입고의 근거가 된다.
      await qr.query(
        `UPDATE IM_ITEM_PURCHASE_ORDER o
            SET o.ARRIVAL_QTY = NVL((SELECT SUM(a.ARRIVAL_QTY)
                                       FROM IM_ITEM_ARRIVAL a
                                      WHERE a.ORDER_NO = o.ORDER_NO
                                        AND a.ORGANIZATION_ID = o.ORGANIZATION_ID
                                        AND a.ARRIVAL_TYPE = :arrivalType
                                        AND NVL(a.ARRIVAL_STATUS, 'N') = :normal), 0),
                o.LAST_MODIFY_BY = :userId,
                o.LAST_MODIFY_DATE = SYSDATE
          WHERE o.ORDER_NO = (SELECT MAX(x.ORDER_NO) FROM IM_ITEM_ARRIVAL x
                               WHERE x.ARRIVAL_SEQ_NO = :arrivalSeqNo
                                 AND x.ORGANIZATION_ID = :organizationId)
            AND o.ORGANIZATION_ID = :organizationId`,
        {
          arrivalType: ARRIVAL_TYPE.arrival,
          normal: ARRIVAL_STATUS.normal,
          userId,
          arrivalSeqNo: dto.arrivalSeqNo,
          organizationId,
        } as unknown as unknown[],
      );

      return { arrivalSeqNo: dto.arrivalSeqNo, arrivalType: ARRIVAL_TYPE.arrival };
    });
  }

  /**
   * 잘못 잡은 출발·도착을 취소한다 (**쓰기**).
   *
   * **지우지 않고 상태만 바꾼다** — 협력사와 맞춰볼 근거가 남아야 한다.
   * 이미 입고(`'R'`)로 넘어간 건은 손대지 않는다.
   */
  async cancelArrival(
    dto: ArrivalConfirmDto,
    organizationId: number,
    userId: string,
  ) {
    return this.tx.run(async (qr) => {
      const updated = await qr.query(
        `UPDATE IM_ITEM_ARRIVAL
            SET ARRIVAL_STATUS = :cancelled,
                LAST_MODIFY_BY = :userId,
                LAST_MODIFY_DATE = SYSDATE
          WHERE ARRIVAL_SEQ_NO = :arrivalSeqNo
            AND ORGANIZATION_ID = :organizationId
            AND NVL(ARRIVAL_STATUS, 'N') = :normal
            AND ARRIVAL_TYPE <> :receipt`,
        {
          cancelled: ARRIVAL_STATUS.cancelled,
          userId,
          arrivalSeqNo: dto.arrivalSeqNo,
          organizationId,
          normal: ARRIVAL_STATUS.normal,
          receipt: ARRIVAL_TYPE.receipt,
        } as unknown as unknown[],
      );
      const affected = Number(
        (updated as { rowsAffected?: number })?.rowsAffected ?? 0,
      );
      if (affected !== 1) {
        throw new BadRequestException(
          '취소할 수 없습니다 (이미 취소됐거나 입고로 넘어갔습니다).',
        );
      }
      return { arrivalSeqNo: dto.arrivalSeqNo, arrivalStatus: ARRIVAL_STATUS.cancelled };
    });
  }

  private like(value?: string) {
    const trimmed = (value ?? '').trim();
    return trimmed ? `%${trimmed}%` : '%';
  }
}
