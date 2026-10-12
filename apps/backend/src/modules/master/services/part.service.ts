/**
 * @file src/modules/master/services/part.service.ts
 * @description 품목마스터 비즈니스 로직 서비스 - TypeORM Repository 패턴
 */

import { Injectable, NotFoundException, ConflictException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ItemMaster } from '../../../entities/item-master.entity';
import { ITEM_MASTER_EDITABLE_COLUMNS, itemMasterDefaults, type ItemMasterColumn } from '@smt/shared';
import { CreatePartDto, UpdatePartDto, PartQueryDto } from '../dto/part.dto';

/** 오늘 (KST, YYYY-MM-DD). 백엔드 시간대는 main.ts 에서 KST 로 고정돼 있다. */
const todayKst = (): string => {
  const d = new Date();
  const pad = (n: number) => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}`;
};

/** 화면 값 → 컬럼 값. 빈 문자열은 NULL, 날짜는 그날 0시(KST). */
function toColumnValue(col: ItemMasterColumn, value: unknown): unknown {
  if (value === undefined || value === null) return null;
  if (col.type === 'number') {
    if (value === '') return null;
    const n = Number(value);
    return Number.isFinite(n) ? n : null;
  }
  const text = String(value).trim();
  if (text === '') return null;
  if (col.type === 'date') return new Date(`${text.slice(0, 10)}T00:00:00+09:00`);
  return text;
}

/** DB 값과 새 값이 같은지 — 날짜는 일자, 숫자는 수치로 비교한다. */
function sameColumnValue(col: ItemMasterColumn, current: unknown, next: unknown): boolean {
  const a = current ?? null;
  const b = next ?? null;
  if (a === null || b === null) return a === b;
  if (col.type === 'date') {
    const day = (v: unknown) => new Date(v as string | Date).toLocaleDateString('sv-SE', { timeZone: 'Asia/Seoul' });
    return day(a) === day(b);
  }
  if (col.type === 'number') return Number(a) === Number(b);
  return String(a) === String(b);
}

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
    const {
      page = 1, limit = 20, itemType, itemTypes, search, mesDisplayYn,
      itemDivision, lineType, itemClass, setItemYn, supplierCode, customerCode,
    } = query;
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

    // 코드 컬럼 필터 — 값과 정확히 같은 행만
    const exact: Array<[string, string | undefined]> = [
      ['itemDivision', itemDivision], ['lineType', lineType], ['itemClass', itemClass],
      ['isSplittable', setItemYn], ['supplierCode', supplierCode], ['customerCode', customerCode],
    ];
    for (const [field, value] of exact) {
      if (value) queryBuilder.andWhere(`p.${field} = :${field}`, { [field]: value });
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

  async create(dto: CreatePartDto, organizationId?: number, userId?: string) {
    const existing = await this.partRepository.findOne({
      where: { itemCode: dto.itemCode, ...this.tenantWhere(organizationId) },
    });

    if (existing) throw new ConflictException(`이미 존재하는 품목 코드입니다: ${dto.itemCode}`);

    // 컬럼 목록 순서대로 — 보낸 값, 없으면 등록 기본값(최근 등록 데이터가 쓰는 값).
    const defaults = itemMasterDefaults(todayKst());
    const values: Record<string, unknown> = {};
    for (const col of ITEM_MASTER_EDITABLE_COLUMNS) {
      const sent = toColumnValue(col, (dto as unknown as Record<string, unknown>)[col.key]);
      const value = sent ?? toColumnValue(col, defaults[col.key]);
      if (col.required && value == null) {
        throw new BadRequestException(`${col.label}은(는) 필수입니다.`);
      }
      values[col.key] = value;
    }
    const now = new Date();
    const part = this.partRepository.create({
      ...(values as Partial<ItemMaster>),
      routeNo: '*',
      organizationId,
      createdBy: userId ?? null,
      createdAt: now,
      updatedBy: userId ?? null,
      updatedAt: now,
    });

    return this.partRepository.save(part);
  }

  /**
   * 수정 — 값이 실제로 바뀐 컬럼만 UPDATE 한다.
   * ID_ITEM 의 UPDATE OF 트리거(TRG_ID_ITEM_UPD: LINE_TYPE·SUPPLIER_CODE·CUSTOMER_CODE)는
   * 값이 같아도 SET 에 들어가기만 하면 돌아서, 폼 전체를 SET 하면 저장할 때마다 연결 테이블이 고쳐진다.
   */
  async update(itemCode: string, dto: UpdatePartDto, organizationId?: number, userId?: string) {
    const current = await this.findById(itemCode, organizationId);
    const currentRow = current as unknown as Record<string, unknown>;

    const changed: Record<string, unknown> = {};
    for (const col of ITEM_MASTER_EDITABLE_COLUMNS) {
      if (col.edit !== 'always') continue;
      const raw = (dto as unknown as Record<string, unknown>)[col.key];
      if (raw === undefined) continue;
      const next = toColumnValue(col, raw);
      if (col.required && next == null) {
        throw new BadRequestException(`${col.label}은(는) 비울 수 없습니다.`);
      }
      if (!sameColumnValue(col, currentRow[col.key], next)) changed[col.key] = next;
    }
    if (Object.keys(changed).length === 0) return current;

    await this.partRepository.update(
      { itemCode, ...this.tenantWhere(organizationId) },
      { ...(changed as Partial<ItemMaster>), updatedBy: userId ?? null, updatedAt: new Date() },
    );
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

  async findByType(itemType: string, organizationId?: number) {
    return this.partRepository.find({
      where: { itemType, mesDisplayYn: 'Y', ...this.tenantWhere(organizationId) },
      order: { itemCode: 'asc' },
    });
  }
}
