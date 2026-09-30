/**
 * @file src/modules/price-confirm/price-confirm.service.ts
 * @description 단가승인 3화면 공통 구현
 *              PB w_mat_buy_price_confirm / w_sal_sale_price_confirm
 *                 w_mcn_mold_buy_price_confirm
 *
 * 초보자 가이드:
 * 1. **승인은 PRICE_CHANGE_CONFIRM_YN 을 바꾸는 일이다.** PB 와 같이 세 컬럼을
 *    한 번에 손댄다 — 'Y' 면 CONFIRM_BY·CONFIRM_DATE 를 채우고, 'N' 이면 비운다.
 *    둘을 따로 두면 승인했는데 승인자가 없는 행이 생긴다.
 * 2. **키 컬럼이 테이블마다 다르다.** 실측 유일인덱스:
 *      IM_ITEM_UNIT_PRICE    DATESET + ITEM_CODE + SUPPLIER_CODE + LINE_TYPE + ORG
 *      IS_PRODUCT_SALE_PRICE CUSTOMER_CODE + ITEM_CODE + PRODUCT_LINE_TYPE + DATESET + ORG
 *      IMCN_MOLD_UNIT_PRICE  DATESET + MOLD_CODE + SUPPLIER_CODE + ORG
 *    구매·판매는 라인유형이 키에 들어 있다. 그것을 빼고 UPDATE 하면 같은
 *    품목·거래처의 **다른 라인유형 단가까지 승인된다.**
 * 3. **PB 는 체크한 행을 한꺼번에 처리했다.** 한 건씩 왕복하면 수십 건을 누르는
 *    동안 화면이 멈춘다. 배열로 받아 한 트랜잭션에서 돈다.
 * 4. **결과를 세 갈래로 돌려준다** — changed / alreadySet / missing.
 *    "이미 승인됨" 과 "그런 단가가 없음" 을 같은 0 으로 뭉치면 화면이 거짓말을 한다.
 * 5. **IMCN_MOLD_UNIT_PRICE 는 이 DB 에서 0행이다** — 은성이 S-PARTS 단가를
 *    아직 쓰지 않는다. 화면은 동작하지만 승인할 대상이 없다.
 */
import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { TransactionService } from '../../shared/transaction.service';
import {
  PriceConfirmApplyDto,
  PriceConfirmKeyDto,
  PriceConfirmQueryDto,
} from './price-confirm.dto';
import { affectedRows } from '../../common/utils/affected-rows.util';

type Row = Record<string, unknown>;

export interface PriceConfirmConfig {
  /** 화면 이름. 오류·응답 문구에 쓴다. */
  label: string;
  table: 'IM_ITEM_UNIT_PRICE' | 'IS_PRODUCT_SALE_PRICE' | 'IMCN_MOLD_UNIT_PRICE';
  /** 품목 쪽 키 컬럼 (S-PARTS 는 MOLD_CODE) */
  itemColumn: 'ITEM_CODE' | 'MOLD_CODE';
  /** 거래처 쪽 키 컬럼 */
  partnerColumn: 'SUPPLIER_CODE' | 'CUSTOMER_CODE';
  /** 거래처 마스터 (이름을 붙인다) */
  partnerTable: 'ICOM_SUPPLIER' | 'ICOM_CUSTOMER';
  partnerNameColumn: 'SUPPLIER_NAME' | 'CUSTOMER_NAME';
  /** 라인유형 키 컬럼. 키가 아니면 null */
  lineTypeColumn: 'LINE_TYPE' | 'PRODUCT_LINE_TYPE' | null;
  /** 단가 컬럼 */
  priceColumn: 'UNIT_PRICE' | 'PRODUCT_SALE_PRICE';
  /** 통화 컬럼 */
  currencyColumn: 'CURRENCY' | 'SALE_CURRENCY';
  /** 품목 마스터를 조인해 품목명을 붙이는가 (S-PARTS 는 IMCN_MOLD 를 본다) */
  itemMaster: 'ID_ITEM' | 'IMCN_MOLD';
  itemNameColumn: 'ITEM_NAME' | 'MOLD_NAME';
  /** APPROVAL_NO·DELIVERY 가 있는가 (판매단가에는 없다) */
  hasApprovalNo: boolean;
  /** 표준단가 컬럼명. 판매는 STANDARD_SALE_PRICE 다. */
  standardPriceColumn: 'STANDARD_UNIT_PRICE' | 'STANDARD_SALE_PRICE';
  /**
   * 이전단가를 구하는 DB 함수와 인자 형태.
   * **LAST_UNIT_PRICE 컬럼은 세 테이블 어디에도 없다** — PB 는 이 함수로 가져왔다.
   * 승인 화면의 핵심이 "얼마였는데 얼마가 되는가" 이므로 빼면 안 된다.
   */
  lastPriceCall: (alias: string) => string;
}

export const PRICE_CONFIRM: Record<'buy' | 'sale' | 'mold', PriceConfirmConfig> = {
  buy: {
    label: '구매단가승인',
    table: 'IM_ITEM_UNIT_PRICE',
    itemColumn: 'ITEM_CODE',
    partnerColumn: 'SUPPLIER_CODE',
    partnerTable: 'ICOM_SUPPLIER',
    partnerNameColumn: 'SUPPLIER_NAME',
    lineTypeColumn: 'LINE_TYPE',
    priceColumn: 'UNIT_PRICE',
    currencyColumn: 'CURRENCY',
    itemMaster: 'ID_ITEM',
    itemNameColumn: 'ITEM_NAME',
    hasApprovalNo: true,
    standardPriceColumn: 'STANDARD_UNIT_PRICE',
    lastPriceCall: (a) =>
      `F_GET_MAT_LAST_UNIT_PRICE(${a}.SUPPLIER_CODE, ${a}.ITEM_CODE,`
      + ` ${a}.LINE_TYPE, ${a}.DATESET, ${a}.ORGANIZATION_ID)`,
  },
  sale: {
    label: '판매단가승인',
    table: 'IS_PRODUCT_SALE_PRICE',
    itemColumn: 'ITEM_CODE',
    partnerColumn: 'CUSTOMER_CODE',
    partnerTable: 'ICOM_CUSTOMER',
    partnerNameColumn: 'CUSTOMER_NAME',
    lineTypeColumn: 'PRODUCT_LINE_TYPE',
    priceColumn: 'PRODUCT_SALE_PRICE',
    currencyColumn: 'SALE_CURRENCY',
    itemMaster: 'ID_ITEM',
    itemNameColumn: 'ITEM_NAME',
    hasApprovalNo: false,
    standardPriceColumn: 'STANDARD_SALE_PRICE',
    lastPriceCall: (a) =>
      `F_GET_SAL_LAST_PRICE(${a}.CUSTOMER_CODE, ${a}.ITEM_CODE,`
      + ` ${a}.PRODUCT_LINE_TYPE, ${a}.DATESET, ${a}.ORGANIZATION_ID)`,
  },
  mold: {
    label: 'S-PARTS구매단가승인',
    table: 'IMCN_MOLD_UNIT_PRICE',
    itemColumn: 'MOLD_CODE',
    partnerColumn: 'SUPPLIER_CODE',
    partnerTable: 'ICOM_SUPPLIER',
    partnerNameColumn: 'SUPPLIER_NAME',
    lineTypeColumn: null,
    priceColumn: 'UNIT_PRICE',
    currencyColumn: 'CURRENCY',
    itemMaster: 'IMCN_MOLD',
    itemNameColumn: 'MOLD_NAME',
    hasApprovalNo: true,
    standardPriceColumn: 'STANDARD_UNIT_PRICE',
    // S-PARTS 는 라인유형 인자가 없다 (키도 아니다)
    lastPriceCall: (a) =>
      `F_GET_MOLD_LAST_UNIT_PRICE(${a}.SUPPLIER_CODE, ${a}.MOLD_CODE,`
      + ` ${a}.DATESET, ${a}.ORGANIZATION_ID)`,
  },
};

@Injectable()
export class PriceConfirmService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  private like(value?: string): string {
    return `${(value ?? '').trim()}%`;
  }

  /** 목록 — PB d_mat_buy_price_4_confirm_lst 계열. */
  async find(cfg: PriceConfirmConfig, query: PriceConfirmQueryDto, organizationId: number) {
    const lineType = cfg.lineTypeColumn
      ? `p.${cfg.lineTypeColumn} AS "lineType", lt.CODE_MEAN_KOR AS "lineTypeName",`
      : `NULL AS "lineType", NULL AS "lineTypeName",`;
    const lineTypeJoin = cfg.lineTypeColumn
      ? `LEFT JOIN ISYS_BASECODE lt
                ON lt.CODE_TYPE = 'LINE TYPE' AND lt.CODE_NAME = p.${cfg.lineTypeColumn}`
      : '';
    const approval = cfg.hasApprovalNo
      ? `p.APPROVAL_NO AS "approvalNo", p.DELIVERY AS "delivery",
         dlv.CODE_MEAN_KOR AS "deliveryName",`
      : `NULL AS "approvalNo", NULL AS "delivery", NULL AS "deliveryName",`;
    const deliveryJoin = cfg.hasApprovalNo
      ? `LEFT JOIN ISYS_BASECODE dlv
                ON dlv.CODE_TYPE = 'DELIVERY' AND dlv.CODE_NAME = p.DELIVERY`
      : '';

    const rows = (await this.dataSource.query(
      `SELECT p.${cfg.itemColumn} AS "itemCode",
              m.${cfg.itemNameColumn} AS "itemName",
              p.${cfg.partnerColumn} AS "partnerCode",
              t.${cfg.partnerNameColumn} AS "partnerName",
              TO_CHAR(p.DATESET, 'YYYY-MM-DD') AS "dateSet",
              TO_CHAR(p.DATEEND, 'YYYY-MM-DD') AS "dateEnd",
              ${lineType}
              p.${cfg.priceColumn} AS "unitPrice",
              p.${cfg.currencyColumn} AS "currency", cur.CODE_MEAN_KOR AS "currencyName",
              ${approval}
              p.${cfg.standardPriceColumn} AS "standardPrice",
              ${cfg.lastPriceCall('p')} AS "lastPrice",
              p.TAX_RATE AS "taxRate",
              p.PRICE_TYPE AS "priceType", pt.CODE_MEAN_KOR AS "priceTypeName",
              p.PRICE_CHANGE_REASON AS "priceChangeReason",
              pcr.CODE_MEAN_KOR AS "priceChangeReasonName",
              NVL(p.PRICE_CHANGE_CONFIRM_YN, 'N') AS "confirmYn",
              p.CONFIRM_BY AS "confirmBy", p.CONFIRM_DATE AS "confirmDate",
              p.ENTER_BY AS "enterBy", p.ENTER_DATE AS "enterDate",
              p.LAST_MODIFY_BY AS "lastModifyBy", p.LAST_MODIFY_DATE AS "lastModifyDate"
         FROM ${cfg.table} p
         LEFT JOIN ${cfg.itemMaster} m
                ON m.${cfg.itemColumn} = p.${cfg.itemColumn}
               AND m.ORGANIZATION_ID = p.ORGANIZATION_ID
         LEFT JOIN ${cfg.partnerTable} t
                ON t.${cfg.partnerColumn} = p.${cfg.partnerColumn}
               AND t.ORGANIZATION_ID = p.ORGANIZATION_ID
         LEFT JOIN ISYS_BASECODE cur
                ON cur.CODE_TYPE = 'CURRENCY' AND cur.CODE_NAME = p.${cfg.currencyColumn}
         LEFT JOIN ISYS_BASECODE pt
                ON pt.CODE_TYPE = 'PRICE TYPE' AND pt.CODE_NAME = p.PRICE_TYPE
         LEFT JOIN ISYS_BASECODE pcr
                ON pcr.CODE_TYPE = 'PRICE CHANGE REASON'
               AND pcr.CODE_NAME = p.PRICE_CHANGE_REASON
         ${lineTypeJoin}
         ${deliveryJoin}
        WHERE p.ORGANIZATION_ID = :organizationId
          AND NVL(p.${cfg.itemColumn}, '*') LIKE :itemCode
          AND NVL(p.${cfg.partnerColumn}, '*') LIKE :partnerCode
          AND NVL(p.PRICE_CHANGE_CONFIRM_YN, 'N') LIKE :confirmStatus
          AND p.DATESET >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND p.DATESET < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
        ORDER BY p.DATESET DESC, p.${cfg.itemColumn}, p.${cfg.partnerColumn}`,
      {
        organizationId,
        itemCode: this.like(query.itemCode),
        partnerCode: this.like(query.partnerCode),
        confirmStatus: this.like(query.confirmStatus),
        // 기간을 안 주면 전부. 두 테이블 다 작다 (5,356 / 132 / 0행).
        dateFrom: query.dateFrom ?? '1900-01-01',
        dateTo: query.dateTo ?? '2999-12-31',
      } as unknown as unknown[],
    )) as Row[];
    return { data: rows, total: rows.length };
  }

  /** 키 하나의 WHERE 절과 바인드. 라인유형이 키인 테이블은 그것까지 넣는다. */
  private keyWhere(cfg: PriceConfirmConfig, suffix: string): string {
    const parts = [
      `${cfg.itemColumn} = :itemCode${suffix}`,
      `${cfg.partnerColumn} = :partnerCode${suffix}`,
      `DATESET = TO_DATE(:dateSet${suffix}, 'YYYY-MM-DD')`,
      'ORGANIZATION_ID = :organizationId',
    ];
    if (cfg.lineTypeColumn) {
      parts.push(`${cfg.lineTypeColumn} = :lineType${suffix}`);
    }
    return parts.join(' AND ');
  }

  private keyBinds(
    cfg: PriceConfirmConfig,
    key: PriceConfirmKeyDto,
    suffix: string,
  ): Record<string, unknown> {
    const binds: Record<string, unknown> = {
      [`itemCode${suffix}`]: key.itemCode,
      [`partnerCode${suffix}`]: key.partnerCode,
      [`dateSet${suffix}`]: key.dateSet,
    };
    if (cfg.lineTypeColumn) {
      // 라인유형이 키인데 화면이 안 보내면 다른 라인유형 단가까지 바뀐다.
      // 빈 문자열로 두면 그 값인 행만 맞으므로 0건이 되고, 조용히 번지는 것보다 낫다.
      binds[`lineType${suffix}`] = key.lineType ?? '';
    }
    return binds;
  }

  /**
   * 승인·승인취소 — PB cb_confirm / cb_cancel.
   *
   * 한 트랜잭션에서 건별로 UPDATE 하고 결과를 세 갈래로 센다.
   * 건수가 최대 500이라 건별 UPDATE 로도 왕복 비용이 없다 (전부 서버 안이다).
   */
  async apply(
    cfg: PriceConfirmConfig,
    dto: PriceConfirmApplyDto,
    organizationId: number,
    userId: string,
  ) {
    return this.tx.run(async (qr) => {
      let changed = 0;
      let alreadySet = 0;
      const missing: PriceConfirmKeyDto[] = [];

      for (const key of dto.keys) {
        const binds = {
          ...this.keyBinds(cfg, key, ''),
          organizationId,
          userId,
          confirmYn: dto.confirmYn,
        };
        const result = await qr.query(
          `UPDATE ${cfg.table}
              SET PRICE_CHANGE_CONFIRM_YN = :confirmYn,
                  CONFIRM_BY = CASE WHEN :confirmYn = 'Y' THEN :userId ELSE NULL END,
                  CONFIRM_DATE = CASE WHEN :confirmYn = 'Y' THEN SYSDATE ELSE NULL END,
                  LAST_MODIFY_BY = :userId,
                  LAST_MODIFY_DATE = SYSDATE
            WHERE ${this.keyWhere(cfg, '')}
              AND NVL(PRICE_CHANGE_CONFIRM_YN, 'N') <> :confirmYn`,
          binds as unknown as unknown[],
        );
        const affected = Number(affectedRows(result) ?? 0);
        if (affected > 0) {
          changed += affected;
          continue;
        }
        // 0건은 "이미 그 상태" 와 "그런 단가가 없음" 두 가지다. 구분해서 센다.
        const exists = (await qr.query(
          `SELECT COUNT(*) AS CNT FROM ${cfg.table} WHERE ${this.keyWhere(cfg, '')}`,
          { ...this.keyBinds(cfg, key, ''), organizationId } as unknown as unknown[],
        )) as Array<{ CNT: number }>;
        if (Number(exists?.[0]?.CNT ?? 0) > 0) alreadySet += 1;
        else missing.push(key);
      }

      return {
        confirmYn: dto.confirmYn,
        changed,
        alreadySet,
        missing: missing.length,
        missingKeys: missing.slice(0, 20),
      };
    });
  }
}
