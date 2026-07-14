import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import { ProductSalePrice } from '../../../entities/product-sale-price.entity';
import { CreateSalePriceDto, CustomerQueryDto, SalePriceImpactQueryDto, SalePriceQueryDto, UpdateSalePriceDto } from '../dto/sale-price.dto';

type Row = Record<string, unknown>;

@Injectable()
export class SalePriceService {
  constructor(@InjectRepository(ProductSalePrice) private readonly repository: Repository<ProductSalePrice>, private readonly dataSource: DataSource) {}

  async findAll(query: SalePriceQueryDto, organizationId: number) {
    const page = query.page ?? 1, limit = query.limit ?? 50;
    const conditions = ['p.ORGANIZATION_ID = :organizationId'];
    const binds: Record<string, unknown> = { organizationId };
    for (const [field, column] of [['customerCode','CUSTOMER_CODE'],['itemCode','ITEM_CODE'],['productLineType','PRODUCT_LINE_TYPE'],['priceType','PRICE_TYPE']] as const) {
      const value = query[field]; if (value) { conditions.push(`p.${column} = :${field}`); binds[field] = value; }
    }
    if (query.baseDate && query.validOnly === 'Y') {
      conditions.push("p.DATESET <= TO_DATE(:baseDate, 'YYYY-MM-DD')");
      conditions.push("NVL(p.DATEEND, DATE '2999-12-31') >= TO_DATE(:baseDate, 'YYYY-MM-DD')");
      binds.baseDate = query.baseDate;
    }
    const where = conditions.join('\n AND ');
    const count = await this.query(`SELECT COUNT(*) AS "total" FROM IS_PRODUCT_SALE_PRICE p WHERE ${where}`, binds);
    Object.assign(binds, { offset: (page - 1) * limit, limit });
    const data = await this.query(`SELECT p.CUSTOMER_CODE AS "customerCode", c.CUSTOMER_NAME AS "customerName",
      p.ITEM_CODE AS "itemCode", i.ITEM_NAME AS "itemName", p.PRODUCT_LINE_TYPE AS "productLineType",
      p.DATESET AS "dateset", p.DATEEND AS "dateend", p.PRODUCT_SALE_PRICE AS "salePrice",
      p.STANDARD_SALE_PRICE AS "standardSalePrice", p.FOREIGN_SALE_PRICE AS "foreignSalePrice",
      p.SALE_CURRENCY AS "saleCurrency", p.FOREIGN_SALE_CURRENCY AS "foreignSaleCurrency",
      p.TAX_RATE AS "taxRate", p.PRICE_TYPE AS "priceType", p.PRICE_CHANGE_REASON AS "priceChangeReason",
      p.PRICE_CHANGE_CONFIRM_YN AS "priceChangeConfirmYn", p.CONFIRM_BY AS "confirmBy", p.CONFIRM_DATE AS "confirmDate",
      p.SALE_CHARGE AS "saleCharge", p.MODEL_NAME AS "modelName", p.ENTER_BY AS "enterBy", p.ENTER_DATE AS "enterDate"
      FROM IS_PRODUCT_SALE_PRICE p
      LEFT JOIN ID_ITEM i ON i.ITEM_CODE=p.ITEM_CODE AND i.ORGANIZATION_ID=p.ORGANIZATION_ID
      LEFT JOIN ICOM_CUSTOMER c ON c.CUSTOMER_CODE=p.CUSTOMER_CODE AND c.ORGANIZATION_ID=p.ORGANIZATION_ID
      WHERE ${where} ORDER BY p.CUSTOMER_CODE,p.ITEM_CODE,p.PRODUCT_LINE_TYPE,p.DATESET DESC
      OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`, binds);
    return { data, total: Number(count[0]?.total ?? count[0]?.TOTAL ?? 0), page, limit };
  }

  async getImpact(query: SalePriceImpactQueryDto, organizationId: number) {
    if (query.mode === 'update') return { mode: query.mode, closingRows: [] };
    const closingRows = await this.query(`SELECT DATESET AS "dateset", DATEEND AS "dateend", PRODUCT_SALE_PRICE AS "salePrice"
      FROM IS_PRODUCT_SALE_PRICE WHERE CUSTOMER_CODE=:customerCode AND ITEM_CODE=:itemCode
      AND PRODUCT_LINE_TYPE=:productLineType AND ORGANIZATION_ID=:organizationId
      AND DATESET<=TO_DATE(:dateset,'YYYY-MM-DD') AND NVL(DATEEND,DATE '2999-12-31')>=TO_DATE(:dateset,'YYYY-MM-DD')`, { ...query, organizationId });
    return { mode: query.mode, closingRows };
  }

  findCustomers(query: CustomerQueryDto, organizationId: number) {
    const binds: Record<string, unknown> = { organizationId, limit: query.limit ?? 200 };
    const condition = query.search ? 'AND (UPPER(CUSTOMER_CODE) LIKE :search OR UPPER(CUSTOMER_NAME) LIKE :search)' : '';
    if (query.search) binds.search = `%${query.search.toUpperCase()}%`;
    return this.query(`SELECT CUSTOMER_CODE AS "customerCode", CUSTOMER_NAME AS "customerName" FROM ICOM_CUSTOMER
      WHERE ORGANIZATION_ID=:organizationId ${condition} ORDER BY CUSTOMER_CODE FETCH FIRST :limit ROWS ONLY`, binds);
  }

  async create(dto: CreateSalePriceDto, organizationId: number, userId?: string) {
    try { return await this.repository.save(this.repository.create({ ...this.mutable(dto), customerCode: dto.customerCode, itemCode: dto.itemCode, productLineType: dto.productLineType, dateset: new Date(dto.dateset), organizationId, enterBy: userId ?? null, lastModifyBy: userId ?? null })); }
    catch (error: unknown) { throw this.oracleError(error); }
  }

  async update(dto: UpdateSalePriceDto, organizationId: number, userId?: string) {
    const key = { customerCode: dto.customerCode, itemCode: dto.itemCode, productLineType: dto.productLineType, dateset: new Date(dto.originalDateset), organizationId };
    try {
      const result = await this.repository.update(key, { ...this.mutable(dto), dateset: new Date(dto.dateset), lastModifyBy: userId ?? null });
      if (!result.affected) throw new NotFoundException('제품판매단가를 찾을 수 없습니다.');
      return this.repository.findOneBy({ ...key, dateset: new Date(dto.dateset) });
    } catch (error: unknown) { if (error instanceof NotFoundException) throw error; throw this.oracleError(error); }
  }

  private mutable(dto: CreateSalePriceDto) { return { dateend: dto.dateend ? new Date(dto.dateend) : null, salePrice: dto.salePrice ?? null, standardSalePrice: dto.standardSalePrice ?? null, foreignSalePrice: dto.foreignSalePrice ?? null, saleCurrency: dto.saleCurrency ?? null, foreignSaleCurrency: dto.foreignSaleCurrency ?? null, taxRate: dto.taxRate ?? null, priceType: dto.priceType ?? null, priceChangeReason: dto.priceChangeReason ?? null, saleCharge: dto.saleCharge ?? null, modelName: dto.modelName ?? null }; }
  private async query(sql: string, binds: Record<string, unknown>): Promise<Row[]> { try { return await this.dataSource.query(sql, { ...binds } as unknown as unknown[]); } catch (error: unknown) { throw this.oracleError(error); } }
  private oracleError(error: unknown) { const value = error as { message?: string; driverError?: { message?: string } }; return new BadRequestException(value?.driverError?.message ?? value?.message ?? '제품판매단가 처리 중 오류가 발생했습니다.'); }
}
