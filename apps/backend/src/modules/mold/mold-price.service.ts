/**
 * @file src/modules/mold/mold-price.service.ts
 * @description S-PARTS 구매단가 — PB w_mcn_mold_buy_price_master 이식
 *
 * 초보자 가이드:
 * 1. **적용상태는 계산값이다.** PB 가 DECODE 로 만들던 것을 그대로 옮겼다 —
 *    종료일이 아직 안 지났고 적용일이 미래면 FUTURE, 적용일도 지났으면 RUNNING,
 *    종료일이 지났으면 EXPIRED. PB 트리가 이 값으로 묶여 있었다.
 * 2. **승인 컬럼은 이 화면이 건드리지 않는다.** PRICE_CHANGE_CONFIRM_YN / CONFIRM_BY /
 *    CONFIRM_DATE 는 S-PARTS구매단가승인 화면의 일이다. 등록·수정에서는 건드리지 않는다.
 * 3. **일괄작업 2개는 DB 프로시저에 있다** — PKG_MES_MAC.SP_MOLD_PRICE_GENERATE 와
 *    SP_MOLD_PRICE_SUPPLIER_CHANGE. PB 화면과 웹이 같은 오브젝트를 호출해야 결과가 갈리지 않는다.
 */
import { BadRequestException, ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { TransactionService } from '../../shared/transaction.service';
import {
  MoldPriceGenerateDto,
  MoldPriceKeyDto,
  MoldPriceQueryDto,
  MoldPriceSupplierChangeDto,
  MoldPriceUpsertDto,
} from './mold-price.dto';

type OracleRow = Record<string, unknown>;

/** 등록·수정에서 사용자가 값을 넣는 컬럼. 키·감사·승인 컬럼은 여기에 없다. */
const EDITABLE: Array<[column: string, field: keyof MoldPriceUpsertDto]> = [
  ['LINE_TYPE', 'lineType'], ['DELIVERY', 'delivery'], ['CURRENCY', 'currency'],
  ['PRICE_TYPE', 'priceType'], ['APPROVAL_NO', 'approvalNo'],
  ['PRICE_CHANGE_REASON', 'priceChangeReason'],
  ['UNIT_PRICE', 'unitPrice'], ['STANDARD_UNIT_PRICE', 'standardUnitPrice'],
  ['TAX_RATE', 'taxRate'],
];

/** PB DECODE 를 그대로 옮긴 적용상태 계산식 */
const STATUS_EXPR = `
  DECODE(SIGN(up.DATEEND - TRUNC(SYSDATE)), 1,
         DECODE(SIGN(up.DATESET - TRUNC(SYSDATE)), 1, 'FUTURE', 'RUNNING'),
         'EXPIRED')`;

@Injectable()
export class MoldPriceService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  private like(value?: string): string {
    return `${(value ?? '').trim()}%`;
  }

  /** 목록 — PB d_mcn_mold_buy_price_lst_tree */
  async find(query: MoldPriceQueryDto, organizationId: number) {
    const binds: OracleRow = {
      organizationId,
      moldCode: this.like(query.moldCode),
      supplierCode: this.like(query.supplierCode),
      status: query.status ?? null,
    };
    const body = `
      SELECT up.MOLD_CODE AS "moldCode", up.SUPPLIER_CODE AS "supplierCode",
             up.DATESET AS "dateset", up.DATEEND AS "dateend",
             ${STATUS_EXPR} AS "status",
             up.CURRENCY AS "currency", cur.CODE_MEAN_KOR AS "currencyName",
             up.UNIT_PRICE AS "unitPrice",
             up.STANDARD_UNIT_PRICE AS "standardUnitPrice", up.TAX_RATE AS "taxRate",
             up.LINE_TYPE AS "lineType", lnt.CODE_MEAN_KOR AS "lineTypeName",
             up.DELIVERY AS "delivery", dlv.CODE_MEAN_KOR AS "deliveryName",
             up.PRICE_TYPE AS "priceType", ptp.CODE_MEAN_KOR AS "priceTypeName",
             up.APPROVAL_NO AS "approvalNo",
             up.PRICE_CHANGE_REASON AS "priceChangeReason",
             up.PRICE_CHANGE_CONFIRM_YN AS "priceChangeConfirmYn",
             cfm.CODE_MEAN_KOR AS "priceChangeConfirmName",
             up.CONFIRM_BY AS "confirmBy", up.CONFIRM_DATE AS "confirmDate",
             m.MOLD_NAME AS "moldName", m.MOLD_SPEC AS "moldSpec", m.MOLD_UOM AS "moldUom",
             sup.SUPPLIER_NAME AS "supplierName",
             up.ENTER_BY AS "enterBy", up.ENTER_DATE AS "enterDate",
             up.LAST_MODIFY_BY AS "lastModifyBy", up.LAST_MODIFY_DATE AS "lastModifyDate"
        FROM IMCN_MOLD_UNIT_PRICE up
        LEFT JOIN IMCN_MOLD m
               ON m.MOLD_CODE = up.MOLD_CODE AND m.ORGANIZATION_ID = up.ORGANIZATION_ID
        LEFT JOIN ICOM_SUPPLIER sup
               ON sup.SUPPLIER_CODE = up.SUPPLIER_CODE
              AND sup.ORGANIZATION_ID = up.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE cur
               ON cur.CODE_TYPE = 'CURRENCY' AND cur.CODE_NAME = up.CURRENCY
              AND cur.ORGANIZATION_ID = up.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE lnt
               ON lnt.CODE_TYPE = 'LINE TYPE' AND lnt.CODE_NAME = up.LINE_TYPE
              AND lnt.ORGANIZATION_ID = up.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE dlv
               ON dlv.CODE_TYPE = 'DELIVERY' AND dlv.CODE_NAME = up.DELIVERY
              AND dlv.ORGANIZATION_ID = up.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE ptp
               ON ptp.CODE_TYPE = 'PRICE TYPE' AND ptp.CODE_NAME = up.PRICE_TYPE
              AND ptp.ORGANIZATION_ID = up.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE cfm
               ON cfm.CODE_TYPE = 'CONFIRM YN'
              AND cfm.CODE_NAME = NVL(up.PRICE_CHANGE_CONFIRM_YN, 'N')
              AND cfm.ORGANIZATION_ID = up.ORGANIZATION_ID
       WHERE up.MOLD_CODE LIKE :moldCode
         AND NVL(up.SUPPLIER_CODE, '*') LIKE :supplierCode
         AND (:status IS NULL OR ${STATUS_EXPR} = :status)
         AND up.ORGANIZATION_ID = :organizationId`;
    const page = query.page ?? 1;
    const limit = query.limit ?? 500;
    const totals = await this.dataSource.query(
      `SELECT COUNT(*) AS "total" FROM (${body}) source_rows`,
      { ...binds } as unknown as unknown[],
    ) as OracleRow[];
    // PB 트리 정렬: 적용상태로 묶고 그 안에서 코드·공급처·적용일 순
    const rows = await this.dataSource.query(
      `${body} ORDER BY "status", "moldCode", "supplierCode", "dateset" DESC
       OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`,
      { ...binds, offset: (page - 1) * limit, limit } as unknown as unknown[],
    ) as OracleRow[];
    return { data: rows, total: Number(totals[0]?.total ?? 0), page, limit };
  }

  private async exists(dto: MoldPriceKeyDto, organizationId: number) {
    const rows = await this.dataSource.query(
      `SELECT COUNT(*) AS "cnt" FROM IMCN_MOLD_UNIT_PRICE
        WHERE DATESET = TO_DATE(:dateset, 'YYYY-MM-DD') AND MOLD_CODE = :moldCode
          AND SUPPLIER_CODE = :supplierCode AND ORGANIZATION_ID = :organizationId`,
      {
        dateset: dto.dateset.slice(0, 10),
        moldCode: dto.moldCode,
        supplierCode: dto.supplierCode,
        organizationId,
      } as unknown as unknown[],
    ) as OracleRow[];
    return Number(rows[0]?.cnt ?? 0) > 0;
  }

  /** 등록 — 승인 컬럼은 'N' 으로 시작한다(PB 와 같다). */
  async create(dto: MoldPriceUpsertDto, organizationId: number, userId: string) {
    if (await this.exists(dto, organizationId)) {
      throw new ConflictException(
        `같은 적용일의 단가가 이미 있습니다 (${dto.moldCode}/${dto.supplierCode}).`,
      );
    }
    const columns = ['DATESET', 'MOLD_CODE', 'SUPPLIER_CODE', 'ORGANIZATION_ID', 'DATEEND'];
    const values = [
      `TO_DATE(:dateset, 'YYYY-MM-DD')`, ':moldCode', ':supplierCode', ':organizationId',
      `NVL(TO_DATE(:dateend, 'YYYY-MM-DD'), TO_DATE('99991231', 'YYYYMMDD'))`,
    ];
    const binds: OracleRow = {
      dateset: dto.dateset.slice(0, 10),
      moldCode: dto.moldCode,
      supplierCode: dto.supplierCode,
      organizationId,
      dateend: dto.dateend ? dto.dateend.slice(0, 10) : null,
      userId,
    };
    for (const [column, field] of EDITABLE) {
      columns.push(column);
      values.push(`:${field}`);
      binds[field] = dto[field] ?? null;
    }
    columns.push('PRICE_CHANGE_CONFIRM_YN');
    values.push(`'N'`);
    columns.push('ENTER_BY', 'ENTER_DATE', 'LAST_MODIFY_BY', 'LAST_MODIFY_DATE');
    values.push(':userId', 'SYSDATE', ':userId', 'SYSDATE');

    await this.dataSource.query(
      `INSERT INTO IMCN_MOLD_UNIT_PRICE (${columns.join(', ')}) VALUES (${values.join(', ')})`,
      binds as unknown as unknown[],
    );
    return { moldCode: dto.moldCode, supplierCode: dto.supplierCode, dateset: dto.dateset };
  }

  /** 수정 — 승인 컬럼은 건드리지 않는다. */
  async update(dto: MoldPriceUpsertDto, organizationId: number, userId: string) {
    if (!await this.exists(dto, organizationId)) {
      throw new NotFoundException(
        `단가를 찾을 수 없습니다 (${dto.moldCode}/${dto.supplierCode}/${dto.dateset}).`,
      );
    }
    const sets = [`DATEEND = NVL(TO_DATE(:dateend, 'YYYY-MM-DD'), DATEEND)`];
    const binds: OracleRow = {
      dateset: dto.dateset.slice(0, 10),
      moldCode: dto.moldCode,
      supplierCode: dto.supplierCode,
      organizationId,
      dateend: dto.dateend ? dto.dateend.slice(0, 10) : null,
      userId,
    };
    for (const [column, field] of EDITABLE) {
      sets.push(`${column} = :${field}`);
      binds[field] = dto[field] ?? null;
    }
    sets.push('LAST_MODIFY_BY = :userId', 'LAST_MODIFY_DATE = SYSDATE');

    await this.dataSource.query(
      `UPDATE IMCN_MOLD_UNIT_PRICE SET ${sets.join(', ')}
        WHERE DATESET = TO_DATE(:dateset, 'YYYY-MM-DD') AND MOLD_CODE = :moldCode
          AND SUPPLIER_CODE = :supplierCode AND ORGANIZATION_ID = :organizationId`,
      binds as unknown as unknown[],
    );
    return { moldCode: dto.moldCode, supplierCode: dto.supplierCode, dateset: dto.dateset };
  }

  /** 삭제 — 승인된 단가는 지우지 않는다. */
  async remove(dto: MoldPriceKeyDto, organizationId: number) {
    const rows = await this.dataSource.query(
      `SELECT NVL(PRICE_CHANGE_CONFIRM_YN, 'N') AS "confirmYn"
         FROM IMCN_MOLD_UNIT_PRICE
        WHERE DATESET = TO_DATE(:dateset, 'YYYY-MM-DD') AND MOLD_CODE = :moldCode
          AND SUPPLIER_CODE = :supplierCode AND ORGANIZATION_ID = :organizationId`,
      {
        dateset: dto.dateset.slice(0, 10),
        moldCode: dto.moldCode,
        supplierCode: dto.supplierCode,
        organizationId,
      } as unknown as unknown[],
    ) as OracleRow[];
    if (rows.length === 0) {
      throw new NotFoundException('단가를 찾을 수 없습니다.');
    }
    if (rows[0]?.confirmYn === 'Y') {
      throw new BadRequestException('승인된 단가는 삭제할 수 없습니다.');
    }
    await this.dataSource.query(
      `DELETE FROM IMCN_MOLD_UNIT_PRICE
        WHERE DATESET = TO_DATE(:dateset, 'YYYY-MM-DD') AND MOLD_CODE = :moldCode
          AND SUPPLIER_CODE = :supplierCode AND ORGANIZATION_ID = :organizationId`,
      {
        dateset: dto.dateset.slice(0, 10),
        moldCode: dto.moldCode,
        supplierCode: dto.supplierCode,
        organizationId,
      } as unknown as unknown[],
    );
    return { deleted: true };
  }

  /** 단가행 일괄생성 — PB cb_1 → PKG_MES_MAC.SP_MOLD_PRICE_GENERATE 전환 */
  async generate(dto: MoldPriceGenerateDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      const before = await qr.query(
        `SELECT COUNT(*) AS "cnt" FROM IMCN_MOLD_UNIT_PRICE
          WHERE ORGANIZATION_ID = :organizationId`,
        { organizationId } as unknown as unknown[],
      ) as OracleRow[];
      await qr.query(
        `DECLARE
           v_result NUMBER;
         BEGIN
           PKG_MES_MAC.SP_MOLD_PRICE_GENERATE(:currency, :organizationId, :userId, v_result);
         END;`,
        { currency: dto.currency, organizationId, userId } as unknown as unknown[],
      );
      const after = await qr.query(
        `SELECT COUNT(*) AS "cnt" FROM IMCN_MOLD_UNIT_PRICE
          WHERE ORGANIZATION_ID = :organizationId`,
        { organizationId } as unknown as unknown[],
      ) as OracleRow[];
      return { created: Number(after[0]?.cnt ?? 0) - Number(before[0]?.cnt ?? 0) };
    });
  }

  /** 공급처 일괄변경 — PB cb_2 → PKG_MES_MAC.SP_MOLD_PRICE_SUPPLIER_CHANGE 전환 */
  async changeSupplier(
    dto: MoldPriceSupplierChangeDto,
    organizationId: number,
    userId: string,
  ) {
    if (dto.beforeSupplierCode === dto.afterSupplierCode) {
      throw new BadRequestException('이전 공급처와 이후 공급처가 같습니다.');
    }
    return this.tx.run(async (qr) => {
      const before = await qr.query(
        `SELECT COUNT(*) AS "cnt" FROM IMCN_MOLD_UNIT_PRICE
          WHERE SUPPLIER_CODE = :supplierCode
            AND DATESET <= TRUNC(SYSDATE) AND DATEEND >= TRUNC(SYSDATE)
            AND ORGANIZATION_ID = :organizationId`,
        { supplierCode: dto.beforeSupplierCode, organizationId } as unknown as unknown[],
      ) as OracleRow[];
      await qr.query(
        `DECLARE
           v_result NUMBER;
         BEGIN
           PKG_MES_MAC.SP_MOLD_PRICE_SUPPLIER_CHANGE(
             :beforeSupplier, :afterSupplier, :organizationId, :userId, v_result);
           IF v_result < 0 THEN
             RAISE_APPLICATION_ERROR(-20011, 'MOLD_PRICE_SUPPLIER_INVALID');
           END IF;
         END;`,
        {
          beforeSupplier: dto.beforeSupplierCode,
          afterSupplier: dto.afterSupplierCode,
          organizationId,
          userId,
        } as unknown as unknown[],
      ).catch((error: unknown) => {
        const message = error instanceof Error ? error.message : String(error);
        if (message.includes('MOLD_PRICE_SUPPLIER_INVALID')) {
          throw new BadRequestException('이전·이후 공급처를 확인하세요.');
        }
        throw error;
      });
      return { changed: Number(before[0]?.cnt ?? 0) };
    });
  }
}
