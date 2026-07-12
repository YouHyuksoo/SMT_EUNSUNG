import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import { ItemSupplier } from '../../../entities/item-supplier.entity';
import { CreateItemSupplierDto, ItemSupplierQueryDto, UpdateItemSupplierDto } from '../dto/item-supplier.dto';

@Injectable()
export class ItemSupplierService {
  constructor(@InjectRepository(ItemSupplier) private readonly repository: Repository<ItemSupplier>, private readonly dataSource: DataSource) {}

  async findAll(query: ItemSupplierQueryDto, organizationId: number) {
    const page = query.page ?? 1, limit = query.limit ?? 50;
    const conditions = ['m.ORGANIZATION_ID = :organizationId'];
    const binds: Record<string, unknown> = { organizationId };
    for (const field of ['itemCode', 'supplierCode', 'orderType', 'inspectRule'] as const) {
      if (query[field]) { conditions.push(`m.${field.replace(/[A-Z]/g, c => `_${c}`).toUpperCase()} = :${field}`); binds[field] = query[field]; }
    }
    if (query.search) {
      conditions.push('(UPPER(m.ITEM_CODE) LIKE :search OR UPPER(i.ITEM_NAME) LIKE :search OR UPPER(m.SUPPLIER_CODE) LIKE :search OR UPPER(s.SUPPLIER_NAME) LIKE :search)');
      binds.search = `%${query.search.toUpperCase()}%`;
    }
    const where = conditions.join(' AND ');
    const totalRows = await this.dataSource.query(`SELECT COUNT(*) "total" FROM IM_ITEM_MASTER m LEFT JOIN ID_ITEM i ON i.ITEM_CODE=m.ITEM_CODE AND i.ORGANIZATION_ID=m.ORGANIZATION_ID LEFT JOIN ICOM_SUPPLIER s ON s.SUPPLIER_CODE=m.SUPPLIER_CODE AND s.ORGANIZATION_ID=m.ORGANIZATION_ID WHERE ${where}`, binds as never);
    const rows = await this.dataSource.query(`SELECT m.SUPPLIER_CODE "supplierCode",s.SUPPLIER_NAME "supplierName",m.ITEM_CODE "itemCode",i.ITEM_NAME "itemName",m.DATESET "dateset",m.DATEEND "dateend",m.ORDER_TYPE "orderType",m.ORDER_RATE "orderRate",m.ORDER_LEADTIME "orderLeadtime",m.ORDER_BAD_RATE "orderBadRate",m.MIM_ORDER_QTY "mimOrderQty",m.PACKING_QTY "packingQty",m.LONGTERM_DELIVERY_YN "longtermDeliveryYn",m.WAREHOUSE_CHARGE "warehouseCharge",m.ORDER_CHARGE "orderCharge",m.MAIN_VENDOR_YN "mainVendorYn",m.PAYMENT_TYPE "paymentType",m.INSPECT_METHOD "inspectMethod",m.INSPECT_RULE "inspectRule",m.INCIDENTAL_EXPENSE_CODE "incidentalExpenseCode",m.INSPECT_PROCESS "inspectProcess",m.ESD_CHECK_CYCLE_VALUE "esdCheckCycleValue",m.ENTER_BY "enterBy",m.ENTER_DATE "enterDate",m.LAST_MODIFY_BY "lastModifyBy",m.LAST_MODIFY_DATE "lastModifyDate" FROM IM_ITEM_MASTER m LEFT JOIN ID_ITEM i ON i.ITEM_CODE=m.ITEM_CODE AND i.ORGANIZATION_ID=m.ORGANIZATION_ID LEFT JOIN ICOM_SUPPLIER s ON s.SUPPLIER_CODE=m.SUPPLIER_CODE AND s.ORGANIZATION_ID=m.ORGANIZATION_ID WHERE ${where} ORDER BY m.ITEM_CODE,m.SUPPLIER_CODE,m.DATESET DESC OFFSET ${(page - 1) * limit} ROWS FETCH NEXT ${limit} ROWS ONLY`, binds as never);
    return { data: rows, total: Number(totalRows[0]?.total ?? 0), page, limit };
  }

  async create(dto: CreateItemSupplierDto, organizationId: number, userId?: string) {
    const key = { supplierCode: dto.supplierCode, itemCode: dto.itemCode, dateset: new Date(dto.dateset), organizationId };
    if (await this.repository.findOneBy(key)) throw new ConflictException('이미 존재하는 품목별 공급처 조건입니다.');
    return this.repository.save(this.repository.create({ ...this.values(dto), ...key, enterBy: userId ?? 'SYSTEM', enterDate: new Date(), lastModifyBy: userId ?? 'SYSTEM', lastModifyDate: new Date() }));
  }

  async update(dto: UpdateItemSupplierDto, organizationId: number, userId?: string) {
    const key = { supplierCode: dto.supplierCode!, itemCode: dto.itemCode!, dateset: new Date(dto.originalDateset), organizationId };
    const result = await this.repository.update(key, { ...this.values(dto as CreateItemSupplierDto), dateset: new Date(dto.dateset!), lastModifyBy: userId ?? 'SYSTEM', lastModifyDate: new Date() });
    if (!result.affected) throw new NotFoundException('품목별 공급처 조건을 찾을 수 없습니다.');
    return this.repository.findOneBy({ ...key, dateset: new Date(dto.dateset!) });
  }

  async delete(supplierCode: string, itemCode: string, dateset: string, organizationId: number) {
    const result = await this.repository.delete({ supplierCode, itemCode, dateset: new Date(dateset), organizationId });
    if (!result.affected) throw new NotFoundException('품목별 공급처 조건을 찾을 수 없습니다.');
  }

  private values(dto: CreateItemSupplierDto): Partial<ItemSupplier> {
    return { dateend: new Date(dto.dateend), orderType: dto.orderType ?? null, orderRate: dto.orderRate, orderLeadtime: dto.orderLeadtime ?? null, orderBadRate: dto.orderBadRate ?? null, mimOrderQty: dto.mimOrderQty ?? null, packingQty: dto.packingQty ?? null, longtermDeliveryYn: dto.longtermDeliveryYn ?? 'N', warehouseCharge: dto.warehouseCharge ?? null, orderCharge: dto.orderCharge ?? null, mainVendorYn: dto.mainVendorYn ?? 'N', paymentType: dto.paymentType, inspectMethod: dto.inspectMethod ?? null, inspectRule: dto.inspectRule ?? null, incidentalExpenseCode: dto.incidentalExpenseCode ?? null, inspectProcess: dto.inspectProcess ?? null, esdCheckCycleValue: dto.esdCheckCycleValue ?? null };
  }
}
