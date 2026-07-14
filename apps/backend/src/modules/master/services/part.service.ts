/**
 * @file src/modules/master/services/part.service.ts
 * @description 품목마스터 비즈니스 로직 서비스 - TypeORM Repository 패턴
 */

import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ItemMaster } from '../../../entities/item-master.entity';
import { CreatePartDto, UpdatePartDto, PartQueryDto } from '../dto/part.dto';

@Injectable()
export class PartService {
  constructor(
    @InjectRepository(ItemMaster)
    private readonly partRepository: Repository<ItemMaster>,
  ) {}

  private tenantWhere(organizationId?: number) {
    return {
      ...(organizationId != null ? { organizationId } : {}),
    };
  }

  async findAll(query: PartQueryDto, organizationId?: number) {
    const { page = 1, limit = 20, itemType, itemTypes, search, mesDisplayYn } = query;
    const skip = (page - 1) * limit;

    const queryBuilder = this.partRepository.createQueryBuilder('p')

    if (organizationId != null) {
      queryBuilder.andWhere('p.organizationId = :organizationId', { organizationId });
    }

    if (itemTypes && itemTypes.length > 0) {
      queryBuilder.andWhere('p.itemType IN (:...itemTypes)', { itemTypes });
    } else if (itemType) {
      queryBuilder.andWhere('p.itemType = :itemType', { itemType });
    }

    if (mesDisplayYn) {
      queryBuilder.andWhere('p.mesDisplayYn = :mesDisplayYn', { mesDisplayYn });
    }

    if (search) {
      const upper = search.toUpperCase();
      queryBuilder.andWhere(
        '(p.itemCode LIKE :search OR p.itemName LIKE :searchRaw OR p.itemNo LIKE :search OR p.custPartNo LIKE :search OR p.modelName LIKE :searchRaw OR p.spec LIKE :searchRaw OR p.markingText LIKE :searchRaw)',
        { search: `%${upper}%`, searchRaw: `%${search}%` }
      );
    }

    const [data, total] = await Promise.all([
      queryBuilder
        .orderBy('p.itemCode', 'ASC')
        .skip(skip)
        .take(limit)
        .getMany(),
      queryBuilder.getCount(),
    ]);

    return { data, total, page, limit };
  }

  async findById(itemCode: string, organizationId?: number) {
    const part = await this.partRepository.findOne({
      where: { itemCode, ...this.tenantWhere(organizationId) },
    });
    if (!part) throw new NotFoundException(`품목을 찾을 수 없습니다: ${itemCode}`);
    return part;
  }

  async findByCode(itemCode: string, organizationId?: number) {
    const part = await this.partRepository.findOne({
      where: { itemCode, ...this.tenantWhere(organizationId) },
    });
    if (!part) throw new NotFoundException(`품목을 찾을 수 없습니다: ${itemCode}`);
    return part;
  }

  async create(dto: CreatePartDto, organizationId?: number) {
    const existing = await this.partRepository.findOne({
      where: { itemCode: dto.itemCode, ...this.tenantWhere(organizationId) },
    });

    if (existing) throw new ConflictException(`이미 존재하는 품목 코드입니다: ${dto.itemCode}`);

    const part = this.partRepository.create({
      itemCode: dto.itemCode,
      itemName: dto.itemName ?? dto.itemCode,
      itemNo: dto.itemNo ?? dto.itemCode,
      custPartNo: dto.custPartNo,
      itemType: dto.itemType,
      itemClass: dto.itemClass,
      lineType: '*',
      itemDivision: dto.itemType,
      modelName: dto.modelName ?? null,
      modelSuffix: dto.modelSuffix ?? null,
      spec: dto.spec ?? '*',
      rev: dto.rev ?? 'A',
      markingText: dto.markingText,
      itemUom: dto.itemUom ?? 'EA',
      color: dto.color ?? null,
      drawNo: dto.drawNo,
      leadTime: dto.leadTime ?? 0,
      safetyStock: dto.safetyStock ?? 0,
      lotUnitQty: dto.lotUnitQty,
      boxQty: dto.boxQty ?? 0,
      minPackQty: dto.minPackQty ?? 0,
      tactTime: dto.tactTime ?? 0,
      expiryDate: dto.expiryDate ?? 0,
      expiryExtDays: dto.expiryExtDays ?? 0,
      toleranceRate: dto.toleranceRate ?? 5,
      isSplittable: dto.isSplittable ?? 'Y',
      packUnit: dto.packUnit ?? null,
      storageLocation: dto.storageLocation ?? null,
      remark: dto.remark,
      mesDisplayYn: dto.mesDisplayYn ?? 'Y',
      imageUrl: dto.imageUrl,
      organizationId,
    });

    return this.partRepository.save(part);
  }

  async update(itemCode: string, dto: UpdatePartDto, organizationId?: number) {
    await this.findById(itemCode, organizationId);

    const updateData: Partial<Pick<ItemMaster,
      | 'itemName'
      | 'itemNo'
      | 'custPartNo'
      | 'itemType'
      | 'itemClass'
      | 'modelName'
      | 'modelSuffix'
      | 'spec'
      | 'rev'
      | 'markingText'
      | 'itemUom'
      | 'color'
      | 'drawNo'
      | 'leadTime'
      | 'safetyStock'
      | 'lotUnitQty'
      | 'boxQty'
      | 'tactTime'
      | 'expiryDate'
      | 'expiryExtDays'
      | 'toleranceRate'
      | 'isSplittable'
      | 'packUnit'
      | 'storageLocation'
      | 'imageUrl'
      | 'remark'
      | 'mesDisplayYn'
    >> = {
      ...(dto.itemName !== undefined ? { itemName: dto.itemName } : {}),
      ...(dto.itemNo !== undefined ? { itemNo: dto.itemNo } : {}),
      ...(dto.custPartNo !== undefined ? { custPartNo: dto.custPartNo } : {}),
      ...(dto.itemType !== undefined ? { itemType: dto.itemType } : {}),
      ...(dto.itemClass !== undefined ? { itemClass: dto.itemClass } : {}),
      ...(dto.modelName !== undefined ? { modelName: dto.modelName || null } : {}),
      ...(dto.modelSuffix !== undefined ? { modelSuffix: dto.modelSuffix || null } : {}),
      ...(dto.spec !== undefined ? { spec: dto.spec } : {}),
      ...(dto.rev !== undefined ? { rev: dto.rev } : {}),
      ...(dto.markingText !== undefined ? { markingText: dto.markingText } : {}),
      ...(dto.itemUom !== undefined ? { itemUom: dto.itemUom } : {}),
      ...(dto.color !== undefined ? { color: dto.color } : {}),
      ...(dto.drawNo !== undefined ? { drawNo: dto.drawNo } : {}),
      ...(dto.leadTime !== undefined ? { leadTime: dto.leadTime } : {}),
      ...(dto.safetyStock !== undefined ? { safetyStock: dto.safetyStock } : {}),
      ...(dto.lotUnitQty !== undefined ? { lotUnitQty: dto.lotUnitQty } : {}),
      ...(dto.boxQty !== undefined ? { boxQty: dto.boxQty } : {}),
      ...(dto.tactTime !== undefined ? { tactTime: dto.tactTime } : {}),
      ...(dto.expiryDate !== undefined ? { expiryDate: dto.expiryDate } : {}),
      ...(dto.expiryExtDays !== undefined ? { expiryExtDays: dto.expiryExtDays } : {}),
      ...(dto.toleranceRate !== undefined ? { toleranceRate: dto.toleranceRate } : {}),
      ...(dto.isSplittable !== undefined ? { isSplittable: dto.isSplittable } : {}),
      ...(dto.packUnit !== undefined ? { packUnit: dto.packUnit } : {}),
      ...(dto.storageLocation !== undefined ? { storageLocation: dto.storageLocation } : {}),
      ...(dto.imageUrl !== undefined ? { imageUrl: dto.imageUrl } : {}),
      ...(dto.remark !== undefined ? { remark: dto.remark } : {}),
      ...(dto.mesDisplayYn !== undefined ? { mesDisplayYn: dto.mesDisplayYn } : {}),
    };
    await this.partRepository.update({ itemCode, ...this.tenantWhere(organizationId) }, updateData);
    return this.findById(itemCode, organizationId);
  }

  /**
   * 품목 삭제 가능 여부 검사 — 이력/사용처(FK 무관)가 있으면 삭제 차단.
   * 입하/입고/재고/롯트/BOM/생산계획 테이블은 ID_ITEM과 FK로 묶여있지 않으므로
   * (FK는 PROD_PLANS 하나뿐) DB가 막아주지 못한다. 애플리케이션에서 참조 존재를 확인한다.
   */
  private async assertDeletable(itemCode: string, organizationId?: number): Promise<void> {
    const params: unknown[] = [];
    const bind = (v: unknown): number => { params.push(v); return params.length; };
    // 서브쿼리마다 itemCode/tenant를 개별 바인드(바인드 재사용 이슈 회피)
    const codePred = (col = 'ITEM_CODE'): string => {
      let s = `${col} = :${bind(itemCode)}`;
      if (organizationId != null) s += ` AND ORGANIZATION_ID = :${bind(organizationId)}`;
      return s;
    };
    const bomPred = (): string => {
      let s = `(PARENT_ITEM_CODE = :${bind(itemCode)} OR CHILD_ITEM_CODE = :${bind(itemCode)})`;
      if (organizationId != null) s += ` AND ORGANIZATION_ID = :${bind(organizationId)}`;
      return s;
    };
    const sql =
      `SELECT ` +
      `(SELECT COUNT(*) FROM MAT_ARRIVALS   WHERE ${codePred()}) AS ARRIVAL, ` +
      `(SELECT COUNT(*) FROM MAT_RECEIVINGS WHERE ${codePred()}) AS RECEIVING, ` +
      `(SELECT COUNT(*) FROM MAT_STOCKS     WHERE ${codePred()}) AS STOCK, ` +
      `(SELECT COUNT(*) FROM MAT_LOTS       WHERE ${codePred()}) AS LOT, ` +
      `(SELECT COUNT(*) FROM BOM_MASTERS    WHERE ${bomPred()}) AS BOM, ` +
      `(SELECT COUNT(*) FROM PROD_PLANS     WHERE ${codePred()}) AS PRODPLAN ` +
      `FROM DUAL`;

    const rows = await this.partRepository.query<Array<Record<string, unknown>>>(sql, params);
    const r = rows?.[0] ?? {};
    const blockers: string[] = [];
    const add = (v: unknown, label: string): void => {
      const n = Number(v ?? 0);
      if (n > 0) blockers.push(`${label} ${n}건`);
    };
    add(r.ARRIVAL, '입하');
    add(r.RECEIVING, '입고');
    add(r.STOCK, '재고');
    add(r.LOT, '롯트');
    add(r.BOM, 'BOM');
    add(r.PRODPLAN, '생산계획');

    if (blockers.length > 0) {
      throw new ConflictException(
        `이력/사용처가 있는 품목은 삭제할 수 없습니다 (${blockers.join(', ')}). ` +
        `먼저 관련 데이터를 정리하거나, 품목의 MES_DISPLAY_YN을 N으로 변경하세요.`,
      );
    }
  }

  async delete(itemCode: string, organizationId?: number) {
    await this.findById(itemCode, organizationId);
    await this.assertDeletable(itemCode, organizationId);
    await this.partRepository.delete({ itemCode, ...this.tenantWhere(organizationId) });
    return { itemCode };
  }

  async updateImage(itemCode: string, imageUrl: string | null, organizationId?: number) {
    await this.findById(itemCode, organizationId);
    await this.partRepository.update({ itemCode, ...this.tenantWhere(organizationId) }, { imageUrl });
    return this.findById(itemCode, organizationId);
  }

  async findByType(itemType: string, organizationId?: number) {
    return this.partRepository.find({
      where: { itemType, mesDisplayYn: 'Y', ...this.tenantWhere(organizationId) },
      order: { itemCode: 'asc' },
    });
  }
}
