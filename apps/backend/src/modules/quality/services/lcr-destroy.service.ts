/**
 * @file src/modules/quality/services/lcr-destroy.service.ts
 * @description LCR 폐기 — 생산1팀이 제품 생산 전 LCR 측정에 쓰고 버리는 L/C/R 칩 자재의 폐기 등록·월 집계
 *
 * 초보자 가이드 (요청: MES 개선요청사항 26.10.22 4·5번 시트):
 * 1. 측정자는 측정일자·품번·LCR 진행 수량(연배 수)·측정자만 입력한다. 나머지는 계산이다.
 * 2. 대상 자재 = 품번 BOM(ID_ENG_BOM)에서 위치가 L/C/R + 숫자로 시작하는 자재 (destroy-price.sql.ts LCR_PART_FILTER).
 *    품번은 L/C/R 위치가 직접 달린 면 품목(TOP/BOT)이다 — 제품 품번은 하위에 TOP/BOT 반제품만 있어 대상이 0 이다.
 *    그래서 모델명이 아니라 품번 키로 다룬다 (TOP·BOT 이 같은 모델명을 쓴다).
 * 3. 실장수 = Σ 자재 실장수량, 단가 = Σ 자재 단가, 폐기금액 = Σ(실장수량 × 단가) × 진행 수량.
 *    요청서 예시 MQ4KH_LDC_PWR-005 BOT(30 / 73 / 133)·TOP(48 / 1017.4 / 3263)와 맞춰 확인했다.
 * 4. 등록 시점의 BOM·단가를 IP_LCR_DESTROY(_DETAIL)에 그대로 남긴다. 나중에 BOM·단가가 바뀌어도 지난 달 금액은 그대로다.
 * 5. 잘못 등록한 건은 지우지 않고 취소(CANCEL_YN='Y')로 남긴다 (사용자 지시 2026-10-27).
 *    취소일시·취소자·사유를 기록하고, 목록에는 보이되 월 누계에서는 뺀다.
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource, QueryRunner } from 'typeorm';
import { TransactionService } from '../../../shared/transaction.service';
import { namedBinds } from '../../../common/utils/named-binds.util';
import {
  LcrDestroyCreateDto,
  LcrDestroyListQueryDto,
  LcrDestroyMonthlyQueryDto,
  LcrItemSearchQueryDto,
} from '../dto/lcr-destroy.dto';
import { bomValidOn, LCR_PART_FILTER, purchasePriceExpr } from './destroy-price.sql';

type OracleRow = Record<string, unknown>;
type Executor = Pick<QueryRunner, 'query'> | DataSource;

export interface LcrPart {
  childItemCode: string;
  childItemName: string | null;
  locationInfo: string | null;
  mountQty: number;
  unitPrice: number | null;
  amount: number;
}

const round2 = (value: number) => Math.round(value * 100) / 100;

@Injectable()
export class LcrDestroyService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  /** BOM 에 L/C/R 위치가 직접 달린 품번 */
  async searchItems(query: LcrItemSearchQueryDto, organizationId: number) {
    const search = query.search?.trim().toUpperCase();
    return await this.dataSource.query(
      `SELECT b.PARENT_ITEM_CODE AS "itemCode",
              MAX(p.ITEM_NAME) AS "itemName",
              MAX(p.MODEL_NAME) AS "modelName",
              MAX(p.CUSTOMER_CODE) AS "customerCode",
              MAX(F_GET_CUSTOMER_NAME(p.CUSTOMER_CODE, p.ORGANIZATION_ID)) AS "customerName",
              COUNT(DISTINCT b.CHILD_ITEM_CODE) AS "partCount"
         FROM ID_ENG_BOM b
         JOIN ID_ITEM i ON i.ITEM_CODE = b.CHILD_ITEM_CODE AND i.ORGANIZATION_ID = b.ORGANIZATION_ID
         LEFT JOIN ID_ITEM p ON p.ITEM_CODE = b.PARENT_ITEM_CODE AND p.ORGANIZATION_ID = b.ORGANIZATION_ID
        WHERE b.ORGANIZATION_ID = :organizationId
          AND ${bomValidOn('b', 'baseDate')}
          AND ${LCR_PART_FILTER}
          AND (:search IS NULL
               OR UPPER(b.PARENT_ITEM_CODE) LIKE '%' || :search || '%'
               OR UPPER(p.ITEM_NAME) LIKE '%' || :search || '%'
               OR UPPER(p.MODEL_NAME) LIKE '%' || :search || '%')
        GROUP BY b.PARENT_ITEM_CODE
        ORDER BY b.PARENT_ITEM_CODE
        FETCH FIRST 200 ROWS ONLY`,
      namedBinds({ organizationId, baseDate: this.today(), search: search || null }),
    ) as OracleRow[];
  }

  /** 품번 하나의 L/C/R 자재와 1연배 합계 */
  async preview(itemCode: string, measureDate: string, organizationId: number, executor: Executor = this.dataSource) {
    const header = await executor.query(
      `SELECT ITEM_CODE AS "itemCode", ITEM_NAME AS "itemName", MODEL_NAME AS "modelName",
              CUSTOMER_CODE AS "customerCode",
              F_GET_CUSTOMER_NAME(CUSTOMER_CODE, ORGANIZATION_ID) AS "customerName"
         FROM ID_ITEM WHERE ITEM_CODE = :itemCode AND ORGANIZATION_ID = :organizationId`,
      namedBinds({ itemCode, organizationId }),
    ) as OracleRow[];
    if (header.length === 0) throw new BadRequestException('품번을 찾을 수 없습니다.');

    const rows = await executor.query(
      `SELECT g.CHILD_ITEM_CODE AS "childItemCode", g.ITEM_NAME AS "childItemName",
              g.LOCATION_INFO AS "locationInfo", g.MOUNT_QTY AS "mountQty",
              ${purchasePriceExpr('g.CHILD_ITEM_CODE', ':organizationId', 'measureDate')} AS "unitPrice"
         FROM (SELECT b.CHILD_ITEM_CODE, MAX(i.ITEM_NAME) AS ITEM_NAME,
                      LISTAGG(b.LOCATION_INFO, ',' ON OVERFLOW TRUNCATE) WITHIN GROUP (ORDER BY b.LOCATION_INFO) AS LOCATION_INFO,
                      SUM(b.ITEM_UNIT_QTY) AS MOUNT_QTY
                 FROM ID_ENG_BOM b
                 JOIN ID_ITEM i ON i.ITEM_CODE = b.CHILD_ITEM_CODE AND i.ORGANIZATION_ID = b.ORGANIZATION_ID
                WHERE b.PARENT_ITEM_CODE = :itemCode
                  AND b.ORGANIZATION_ID = :organizationId
                  AND ${bomValidOn('b', 'measureDate')}
                  AND ${LCR_PART_FILTER}
                GROUP BY b.CHILD_ITEM_CODE) g
        ORDER BY g.LOCATION_INFO`,
      namedBinds({ itemCode, organizationId, measureDate }),
    ) as OracleRow[];
    const parts: LcrPart[] = rows.map(r => {
      const mountQty = Number(r.mountQty);
      const unitPrice = r.unitPrice == null ? null : Number(r.unitPrice);
      return {
        childItemCode: String(r.childItemCode),
        childItemName: (r.childItemName as string | null) ?? null,
        locationInfo: (r.locationInfo as string | null) ?? null,
        mountQty,
        unitPrice,
        amount: round2(mountQty * (unitPrice ?? 0)),
      };
    });
    return {
      item: header[0],
      parts,
      mountQty: parts.reduce((sum, p) => sum + p.mountQty, 0),
      unitPriceSum: round2(parts.reduce((sum, p) => sum + (p.unitPrice ?? 0), 0)),
      amountPerArray: round2(parts.reduce((sum, p) => sum + p.amount, 0)),
      missingPriceCount: parts.filter(p => p.unitPrice == null).length,
    };
  }

  async create(dto: LcrDestroyCreateDto, organizationId: number, userId: string) {
    const measureDate = dto.measureDate.slice(0, 10);
    return this.tx.run(async qr => {
      const calc = await this.preview(dto.itemCode.trim(), measureDate, organizationId, qr);
      if (calc.parts.length === 0) throw new BadRequestException('이 품번의 BOM 에 L/C/R 위치 자재가 없습니다.');

      const seqRows = await qr.query(`SELECT SEQ_IP_LCR_DESTROY.NEXTVAL AS "seq" FROM DUAL`) as OracleRow[];
      const lcrSeq = Number(seqRows[0].seq);
      const item = calc.item;
      await qr.query(
        `INSERT INTO IP_LCR_DESTROY (
           LCR_SEQ, ORGANIZATION_ID, MEASURE_DATE, ITEM_CODE, ITEM_NAME, MODEL_NAME, CUSTOMER_CODE,
           ARRAY_QTY, MOUNT_QTY, UNIT_PRICE_SUM, USE_QTY, DESTROY_AMOUNT, MEASURER, COMMENTS,
           ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE
         ) VALUES (
           :lcrSeq, :organizationId, TO_DATE(:measureDate, 'YYYY-MM-DD'), :itemCode, :itemName, :modelName, :customerCode,
           :arrayQty, :mountQty, :unitPriceSum, :useQty, :amount, :measurer, :comments,
           :userId, SYSDATE, :userId, SYSDATE
         )`,
        namedBinds({
          lcrSeq, organizationId, measureDate,
          itemCode: item.itemCode, itemName: item.itemName ?? null, modelName: item.modelName ?? null,
          customerCode: item.customerCode ?? null,
          arrayQty: dto.arrayQty, mountQty: calc.mountQty, unitPriceSum: calc.unitPriceSum,
          useQty: calc.mountQty * dto.arrayQty, amount: round2(calc.amountPerArray * dto.arrayQty),
          measurer: dto.measurer.trim(), comments: dto.comments?.trim() || null, userId,
        }),
      );
      for (const part of calc.parts) {
        await qr.query(
          `INSERT INTO IP_LCR_DESTROY_DETAIL (
             LCR_SEQ, CHILD_ITEM_CODE, ORGANIZATION_ID, LOCATION_INFO, MOUNT_QTY, UNIT_PRICE, USE_QTY, DESTROY_AMOUNT
           ) VALUES (:lcrSeq, :childItemCode, :organizationId, :locationInfo, :mountQty, :unitPrice, :useQty, :amount)`,
          namedBinds({
            lcrSeq, organizationId, childItemCode: part.childItemCode,
            locationInfo: part.locationInfo?.slice(0, 2500) ?? null,
            mountQty: part.mountQty, unitPrice: part.unitPrice,
            useQty: part.mountQty * dto.arrayQty, amount: round2(part.amount * dto.arrayQty),
          }),
        );
      }
      return { lcrSeq };
    });
  }

  /** 월 단위 등록 목록 */
  async list(query: LcrDestroyListQueryDto, organizationId: number) {
    const itemCode = query.itemCode?.trim();
    return await this.dataSource.query(
      `SELECT d.LCR_SEQ AS "lcrSeq", TO_CHAR(d.MEASURE_DATE, 'YYYY-MM-DD') AS "measureDate",
              d.CUSTOMER_CODE AS "customerCode",
              F_GET_CUSTOMER_NAME(d.CUSTOMER_CODE, d.ORGANIZATION_ID) AS "customerName",
              d.ITEM_CODE AS "itemCode", d.ITEM_NAME AS "itemName", d.MODEL_NAME AS "modelName",
              d.ARRAY_QTY AS "arrayQty", d.MOUNT_QTY AS "mountQty", d.UNIT_PRICE_SUM AS "unitPriceSum",
              d.USE_QTY AS "useQty", d.DESTROY_AMOUNT AS "destroyAmount",
              d.MEASURER AS "measurer", d.COMMENTS AS "comments",
              d.CANCEL_YN AS "cancelYn", d.CANCEL_DATE AS "cancelDate",
              d.CANCEL_BY AS "cancelBy", d.CANCEL_REASON AS "cancelReason",
              d.ENTER_BY AS "enterBy", d.ENTER_DATE AS "enterDate"
         FROM IP_LCR_DESTROY d
        WHERE d.ORGANIZATION_ID = :organizationId
          AND d.MEASURE_DATE >= TO_DATE(:month || '-01', 'YYYY-MM-DD')
          AND d.MEASURE_DATE < ADD_MONTHS(TO_DATE(:month || '-01', 'YYYY-MM-DD'), 1)
          AND (:itemCode IS NULL OR d.ITEM_CODE LIKE :itemCode || '%')
        ORDER BY d.MEASURE_DATE, d.LCR_SEQ`,
      namedBinds({ organizationId, month: query.month, itemCode: itemCode || null }),
    ) as OracleRow[];
  }

  /** 연간 월별 누계 */
  async monthly(query: LcrDestroyMonthlyQueryDto, organizationId: number) {
    return await this.dataSource.query(
      `SELECT TO_CHAR(d.MEASURE_DATE, 'YYYY-MM') AS "month",
              COUNT(*) AS "count", SUM(d.ARRAY_QTY) AS "arrayQty",
              SUM(d.USE_QTY) AS "useQty", SUM(d.DESTROY_AMOUNT) AS "destroyAmount"
         FROM IP_LCR_DESTROY d
        WHERE d.ORGANIZATION_ID = :organizationId
          AND d.CANCEL_YN = 'N'
          AND d.MEASURE_DATE >= TO_DATE(:year || '-01-01', 'YYYY-MM-DD')
          AND d.MEASURE_DATE < ADD_MONTHS(TO_DATE(:year || '-01-01', 'YYYY-MM-DD'), 12)
        GROUP BY TO_CHAR(d.MEASURE_DATE, 'YYYY-MM')
        ORDER BY 1`,
      namedBinds({ organizationId, year: query.year }),
    ) as OracleRow[];
  }

  /** 등록 1건의 자재 내역 (스냅샷) */
  async detail(lcrSeq: number, organizationId: number) {
    return await this.dataSource.query(
      `SELECT t.CHILD_ITEM_CODE AS "childItemCode", i.ITEM_NAME AS "childItemName",
              t.LOCATION_INFO AS "locationInfo", t.MOUNT_QTY AS "mountQty", t.UNIT_PRICE AS "unitPrice",
              t.USE_QTY AS "useQty", t.DESTROY_AMOUNT AS "destroyAmount"
         FROM IP_LCR_DESTROY_DETAIL t
         LEFT JOIN ID_ITEM i ON i.ITEM_CODE = t.CHILD_ITEM_CODE AND i.ORGANIZATION_ID = t.ORGANIZATION_ID
        WHERE t.LCR_SEQ = :lcrSeq AND t.ORGANIZATION_ID = :organizationId
        ORDER BY t.LOCATION_INFO`,
      namedBinds({ lcrSeq, organizationId }),
    ) as OracleRow[];
  }

  /** 잘못 등록한 건을 취소로 바꾼다. 행과 자재 내역은 그대로 둔다 */
  async cancel(lcrSeq: number, reason: string, organizationId: number, userId: string) {
    return this.tx.run(async qr => {
      const found = await qr.query(
        `SELECT CANCEL_YN AS "cancelYn" FROM IP_LCR_DESTROY
          WHERE LCR_SEQ = :lcrSeq AND ORGANIZATION_ID = :organizationId FOR UPDATE`,
        namedBinds({ lcrSeq, organizationId }),
      ) as OracleRow[];
      if (found.length === 0) throw new BadRequestException('대상 등록을 찾을 수 없습니다.');
      if (found[0].cancelYn === 'Y') throw new BadRequestException('이미 취소된 등록입니다.');
      await qr.query(
        `UPDATE IP_LCR_DESTROY
            SET CANCEL_YN = 'Y', CANCEL_DATE = SYSDATE, CANCEL_BY = :userId, CANCEL_REASON = :reason,
                LAST_MODIFY_BY = :userId, LAST_MODIFY_DATE = SYSDATE
          WHERE LCR_SEQ = :lcrSeq AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ lcrSeq, organizationId, userId, reason: reason.trim() }),
      );
      return { lcrSeq, cancelYn: 'Y' };
    });
  }

  /** 서버 시각은 KST 고정(main.ts) — 오늘 'YYYY-MM-DD' */
  private today(): string {
    const now = new Date();
    return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`;
  }
}
