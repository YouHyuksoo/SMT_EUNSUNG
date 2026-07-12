import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import { PurchaseUnitPrice } from '../../../entities/purchase-unit-price.entity';
import {
  CreatePurchasePriceDto,
  PurchasePriceImpactQueryDto,
  PurchasePriceQueryDto,
  SupplierQueryDto,
  UpdatePurchasePriceDto,
} from '../dto/purchase-price.dto';

type OracleRow = Record<string, unknown>;

@Injectable()
export class PurchasePriceService {
  constructor(
    @InjectRepository(PurchaseUnitPrice)
    private readonly repository: Repository<PurchaseUnitPrice>,
    private readonly dataSource: DataSource,
  ) {}

  async findAll(query: PurchasePriceQueryDto, organizationId: number) {
    const page = query.page ?? 1;
    const limit = query.limit ?? 50;
    const conditions = ['p.ORGANIZATION_ID = :organizationId'];
    const binds: Record<string, unknown> = { organizationId };
    if (query.itemCode) {
      conditions.push('p.ITEM_CODE = :itemCode');
      binds.itemCode = query.itemCode;
    }
    if (query.supplierCode) {
      conditions.push('p.SUPPLIER_CODE = :supplierCode');
      binds.supplierCode = query.supplierCode;
    }
    if (query.lineType) {
      conditions.push('p.LINE_TYPE = :lineType');
      binds.lineType = query.lineType;
    }
    if (query.priceType) {
      conditions.push('p.PRICE_TYPE = :priceType');
      binds.priceType = query.priceType;
    }
    if (query.baseDate && query.validOnly === 'Y') {
      conditions.push('p.DATESET <= TO_DATE(:baseDate, \'YYYY-MM-DD\')');
      conditions.push('p.DATEEND >= TO_DATE(:baseDate, \'YYYY-MM-DD\')');
      binds.baseDate = query.baseDate;
    }
    const where = conditions.join('\n AND ');
    const countRows = await this.query(`SELECT COUNT(*) AS "total" FROM IM_ITEM_UNIT_PRICE p WHERE ${where}`, binds);
    binds.offset = (page - 1) * limit;
    binds.limit = limit;
    const rows = await this.query(`
      SELECT p.DATESET AS "dateset", p.DATEEND AS "dateend", p.ITEM_CODE AS "itemCode",
             i.ITEM_NAME AS "itemName", p.SUPPLIER_CODE AS "supplierCode",
             s.SUPPLIER_NAME AS "supplierName", p.LINE_TYPE AS "lineType",
             p.UNIT_PRICE AS "unitPrice", p.STANDARD_UNIT_PRICE AS "standardUnitPrice",
             p.TAX_RATE AS "taxRate", p.CURRENCY AS "currency", p.DELIVERY AS "delivery",
             p.PRICE_TYPE AS "priceType", p.PRICE_CHANGE_REASON AS "priceChangeReason",
             p.APPROVAL_NO AS "approvalNo", p.PRICE_CHANGE_CONFIRM_YN AS "priceChangeConfirmYn",
             p.CONFIRM_BY AS "confirmBy", p.CONFIRM_DATE AS "confirmDate",
             p.ENTER_BY AS "enterBy", p.ENTER_DATE AS "enterDate",
             p.LAST_MODIFY_BY AS "lastModifyBy", p.LAST_MODIFY_DATE AS "lastModifyDate"
        FROM IM_ITEM_UNIT_PRICE p
        LEFT JOIN ID_ITEM i ON i.ITEM_CODE = p.ITEM_CODE AND i.ORGANIZATION_ID = p.ORGANIZATION_ID
        LEFT JOIN ICOM_SUPPLIER s ON s.SUPPLIER_CODE = p.SUPPLIER_CODE AND s.ORGANIZATION_ID = p.ORGANIZATION_ID
       WHERE ${where}
       ORDER BY p.ITEM_CODE, p.SUPPLIER_CODE, p.LINE_TYPE, p.DATESET DESC
       OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`, binds);
    const total = Number(countRows[0]?.total ?? countRows[0]?.TOTAL ?? 0);
    return { data: rows, total, page, limit };
  }

  async getImpact(query: PurchasePriceImpactQueryDto, organizationId: number) {
    const binds = {
      itemCode: query.itemCode,
      supplierCode: query.supplierCode,
      lineType: query.lineType,
      dateset: query.dateset,
      organizationId,
    };
    const closingRows = query.mode === 'create'
      ? await this.query(`
          SELECT DATESET AS "dateset", DATEEND AS "dateend", UNIT_PRICE AS "unitPrice"
            FROM IM_ITEM_UNIT_PRICE
           WHERE ITEM_CODE = :itemCode AND SUPPLIER_CODE = :supplierCode
             AND LINE_TYPE = :lineType AND ORGANIZATION_ID = :organizationId
             AND DATESET <= TO_DATE(:dateset, 'YYYY-MM-DD')
             AND DATEEND >= TO_DATE(:dateset, 'YYYY-MM-DD')`, binds)
      : [];
    const receiptRows = await this.query(`
      SELECT COUNT(*) AS "affectedRows", NVL(SUM(RECEIPT_AMT), 0) AS "affectedAmount"
        FROM IM_ITEM_RECEIPT
       WHERE ITEM_CODE = :itemCode AND SUPPLIER_CODE = :supplierCode
         AND LINE_TYPE = :lineType AND ORGANIZATION_ID = :organizationId
         AND RECEIPT_DATE >= TO_DATE(:dateset, 'YYYY-MM-DD')
         AND RECEIPT_DATE <= TRUNC(SYSDATE)`, binds);
    const receipt = receiptRows[0] ?? {};
    return {
      mode: query.mode,
      closingRows,
      affectedRows: Number(receipt.affectedRows ?? receipt.AFFECTED_ROWS ?? 0),
      affectedAmount: Number(receipt.affectedAmount ?? receipt.AFFECTED_AMT ?? 0),
    };
  }

  async findSuppliers(query: SupplierQueryDto, organizationId: number) {
    const binds: Record<string, unknown> = { organizationId, limit: query.limit ?? 200 };
    const searchCondition = query.search
      ? `AND (UPPER(SUPPLIER_CODE) LIKE :search OR UPPER(SUPPLIER_NAME) LIKE :search)`
      : '';
    if (query.search) binds.search = `%${query.search.toUpperCase()}%`;
    return this.query(`
      SELECT SUPPLIER_CODE AS "supplierCode", SUPPLIER_NAME AS "supplierName"
        FROM ICOM_SUPPLIER
       WHERE ORGANIZATION_ID = :organizationId ${searchCondition}
       ORDER BY SUPPLIER_CODE
       FETCH FIRST :limit ROWS ONLY`, binds);
  }

  async create(dto: CreatePurchasePriceDto, organizationId: number, userId?: string) {
    try {
      const entity = this.repository.create({
        ...this.mutableFields(dto),
        dateset: new Date(dto.dateset),
        itemCode: dto.itemCode,
        supplierCode: dto.supplierCode,
        lineType: dto.lineType,
        organizationId,
        enterBy: userId ?? null,
        lastModifyBy: userId ?? null,
      });
      return await this.repository.save(entity);
    } catch (error: unknown) {
      throw this.toOracleException(error);
    }
  }

  async update(dto: UpdatePurchasePriceDto, organizationId: number, userId?: string) {
    const key = {
      dateset: new Date(dto.originalDateset),
      itemCode: dto.itemCode,
      supplierCode: dto.supplierCode,
      lineType: dto.lineType,
      organizationId,
    };
    try {
      const result = await this.repository.update(key, {
        ...this.mutableFields(dto),
        dateset: new Date(dto.dateset),
        lastModifyBy: userId ?? null,
      });
      if (!result.affected) throw new NotFoundException('구매단가를 찾을 수 없습니다.');
      return this.repository.findOneBy({
        dateset: new Date(dto.dateset), itemCode: dto.itemCode,
        supplierCode: dto.supplierCode, lineType: dto.lineType, organizationId,
      });
    } catch (error: unknown) {
      if (error instanceof NotFoundException) throw error;
      throw this.toOracleException(error);
    }
  }

  private mutableFields(dto: CreatePurchasePriceDto) {
    return {
      dateend: new Date(dto.dateend), unitPrice: dto.unitPrice,
      standardUnitPrice: dto.standardUnitPrice ?? null, taxRate: dto.taxRate ?? null,
      currency: dto.currency, delivery: dto.delivery, priceType: dto.priceType,
      priceChangeReason: dto.priceChangeReason,
    };
  }

  private async query(sql: string, binds: Record<string, unknown>): Promise<OracleRow[]> {
    try {
      return await this.dataSource.query(sql, { ...binds } as unknown as unknown[]);
    } catch (error: unknown) {
      throw this.toOracleException(error);
    }
  }

  private toOracleException(error: unknown): BadRequestException {
    const record = typeof error === 'object' && error !== null ? error as Record<string, unknown> : {};
    const driver = typeof record.driverError === 'object' && record.driverError !== null
      ? record.driverError as Record<string, unknown>
      : {};
    const message = typeof driver.message === 'string'
      ? driver.message
      : typeof record.message === 'string' ? record.message : '구매단가 처리 중 오류가 발생했습니다.';
    return new BadRequestException(message);
  }
}
