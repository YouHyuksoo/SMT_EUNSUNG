import { ConflictException, Injectable, NotFoundException, UnprocessableEntityException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { EntityManager, In, Repository } from 'typeorm';
import { BomMaster } from '../../../entities/bom-master.entity';
import { ItemMaster } from '../../../entities/item-master.entity';
import { ProcessMaster } from '../../../entities/process-master.entity';
import { RoutingGroup } from '../../../entities/routing-group.entity';
import { RoutingMaterial } from '../../../entities/routing-material.entity';
import { RoutingProcess } from '../../../entities/routing-process.entity';
import { SupplierMaster } from '../../../entities/supplier-master.entity';
import { TransactionService } from '../../../shared/transaction.service';
import { BulkSaveRoutingMaterialDto, CreateRoutingGroupDto, CreateRoutingProcessDto, ReorderRoutingProcessesDto, RoutingGroupQueryDto, UpdateRoutingGroupDto, UpdateRoutingProcessDto } from '../dto/routing-group.dto';

@Injectable()
export class RoutingGroupService {
  constructor(
    @InjectRepository(RoutingGroup) private readonly groupRepo: Repository<RoutingGroup>,
    @InjectRepository(RoutingProcess) private readonly processRepo: Repository<RoutingProcess>,
    @InjectRepository(ProcessMaster) private readonly workstageRepo: Repository<ProcessMaster>,
    @InjectRepository(ItemMaster) private readonly itemRepo: Repository<ItemMaster>,
    @InjectRepository(BomMaster) private readonly bomRepo: Repository<BomMaster>,
    @InjectRepository(RoutingMaterial) private readonly materialRepo: Repository<RoutingMaterial>,
    @InjectRepository(SupplierMaster) private readonly supplierRepo: Repository<SupplierMaster>,
    private readonly tx: TransactionService,
  ) {}

  async findAllGroups(query: RoutingGroupQueryDto, organizationId: number) {
    const { page = 1, limit = 50, search, useYn } = query;
    const qb = this.groupRepo.createQueryBuilder('g').where('g.organizationId = :organizationId', { organizationId });
    if (useYn) qb.andWhere('g.useYn = :useYn', { useYn });
    if (search) qb.andWhere('(g.routingCode LIKE :search OR g.routingName LIKE :search OR g.itemCode LIKE :search)', { search: `%${search}%` });
    const [data, total] = await qb.orderBy('g.routingCode', 'ASC').skip((page - 1) * limit).take(limit).getManyAndCount();
    return { data, total, page, limit };
  }

  async findGroupByCode(routingCode: string, organizationId: number) {
    const group = await this.groupRepo.findOne({ where: { routingCode, organizationId } });
    if (!group) throw new NotFoundException(`라우팅 그룹을 찾을 수 없습니다: ${routingCode}`);
    return group;
  }

  private async ensureItem(itemCode: string, organizationId: number) {
    if (!await this.itemRepo.findOne({ where: { itemCode, organizationId } })) throw new NotFoundException(`품목을 찾을 수 없습니다: ${itemCode}`);
  }

  private async ensureSingleActive(itemCode: string, organizationId: number, excludeCode?: string) {
    const active = await this.groupRepo.findOne({ where: { itemCode, organizationId, useYn: 'Y' } });
    if (active && active.routingCode !== excludeCode) throw new ConflictException(`품목에 이미 활성 라우팅이 있습니다: ${itemCode}`);
  }

  private conflictUnique(error: unknown): never {
    if (error instanceof Error && ((error as Error & { code?: string }).code === 'ORA-00001' || error.message.includes('ORA-00001'))) {
      throw new ConflictException('동일한 활성 라우팅 또는 키가 이미 존재합니다.');
    }
    throw error;
  }

  private conflictIntegrity(error: unknown): never {
    const message = error instanceof Error ? error.message : '';
    const code = error && typeof error === 'object' && 'code' in error ? String(error.code) : '';
    if (['ORA-00001', 'ORA-02291', 'ORA-02292'].some((value) => code === value || message.includes(value))) {
      throw new ConflictException('동시 변경으로 데이터 무결성 충돌이 발생했습니다. 다시 조회 후 시도해 주세요.');
    }
    throw error;
  }

  private async lockRoutingGroup(manager: EntityManager, routingCode: string, organizationId: number) {
    const rows = await manager.query(
      'SELECT ROUTING_CODE AS "routingCode", ITEM_CODE AS "itemCode" FROM IP_ROUTING_GROUPS WHERE ORGANIZATION_ID = :organizationId AND ROUTING_CODE = :routingCode FOR UPDATE',
      { organizationId, routingCode } as never,
    ) as { routingCode: string; itemCode: string }[];
    if (rows.length !== 1) throw new NotFoundException(`라우팅 그룹을 찾을 수 없습니다: ${routingCode}`);
    return rows[0];
  }

  async createGroup(dto: CreateRoutingGroupDto, organizationId: number) {
    await this.ensureItem(dto.itemCode, organizationId);
    if (await this.groupRepo.findOne({ where: { routingCode: dto.routingCode, organizationId } })) throw new ConflictException(`이미 존재하는 라우팅 그룹: ${dto.routingCode}`);
    if ((dto.useYn ?? 'Y') === 'Y') await this.ensureSingleActive(dto.itemCode, organizationId);
    try {
      return await this.groupRepo.save(this.groupRepo.create({ ...dto, description: dto.description ?? null, useYn: dto.useYn ?? 'Y', organizationId }));
    } catch (error: unknown) { return this.conflictUnique(error); }
  }

  async updateGroup(routingCode: string, dto: UpdateRoutingGroupDto, organizationId: number) {
    const group = await this.findGroupByCode(routingCode, organizationId);
    if (dto.useYn === 'Y') await this.ensureSingleActive(group.itemCode, organizationId, routingCode);
    try { await this.groupRepo.update({ routingCode, organizationId }, dto); }
    catch (error: unknown) { return this.conflictUnique(error); }
    return this.findGroupByCode(routingCode, organizationId);
  }

  async deleteGroup(routingCode: string, organizationId: number) {
    await this.findGroupByCode(routingCode, organizationId);
    if (await this.processRepo.count({ where: { routingCode, organizationId } })) throw new ConflictException('공정이 있는 라우팅 그룹은 삭제할 수 없습니다.');
    await this.groupRepo.delete({ routingCode, organizationId });
    return { routingCode };
  }

  async findProcesses(routingCode: string, organizationId: number) {
    return this.processRepo.find({ where: { routingCode, organizationId }, order: { processSeq: 'ASC' } });
  }

  private async validateProcessRefs(workstageCode: string, executionType: 'INTERNAL' | 'SUBCON', supplierCode: string | undefined, organizationId: number) {
    if (!await this.workstageRepo.findOne({ where: { processCode: workstageCode, organizationId } })) throw new NotFoundException(`공정마스터를 찾을 수 없습니다: ${workstageCode}`);
    if (executionType === 'SUBCON') {
      if (!supplierCode) throw new UnprocessableEntityException('외주 공정은 공급처가 필수입니다.');
      if (!await this.supplierRepo.findOne({ where: { supplierCode, organizationId } })) throw new NotFoundException(`공급처를 찾을 수 없습니다: ${supplierCode}`);
    }
  }

  async createProcess(routingCode: string, dto: CreateRoutingProcessDto, organizationId: number) {
    const executionType = dto.executionType ?? 'INTERNAL';
    await this.validateProcessRefs(dto.workstageCode, executionType, dto.subconSupplierCode, organizationId);
    try {
      return await this.tx.run(async ({ manager }) => {
        await this.lockRoutingGroup(manager, routingCode, organizationId);
        if (await manager.findOne(RoutingProcess, { where: { routingCode, processSeq: dto.seq, organizationId } })) throw new ConflictException(`이미 존재하는 공정순서: ${routingCode}/${dto.seq}`);
        const process = manager.create(RoutingProcess, { routingCode, processSeq: dto.seq, workstageCode: dto.workstageCode, executionType,
          jobOrderYn: dto.jobOrderYn ?? 'Y', subconSupplierCode: executionType === 'SUBCON' ? dto.subconSupplierCode! : null,
          standardTime: dto.standardTime ?? null, setupTime: dto.setupTime ?? null, useYn: dto.useYn ?? 'Y', organizationId });
        return manager.save(RoutingProcess, process);
      });
    } catch (error: unknown) { return this.conflictUnique(error); }
  }

  async updateProcess(routingCode: string, seq: number, dto: UpdateRoutingProcessDto, organizationId: number) {
    const existing = await this.processRepo.findOne({ where: { routingCode, processSeq: seq, organizationId } });
    if (!existing) throw new NotFoundException(`공정순서를 찾을 수 없습니다: ${routingCode}/${seq}`);
    const executionType = dto.executionType ?? existing.executionType;
    const workstageCode = dto.workstageCode ?? existing.workstageCode;
    const supplier = executionType === 'SUBCON' ? (dto.subconSupplierCode ?? existing.subconSupplierCode ?? undefined) : undefined;
    await this.validateProcessRefs(workstageCode, executionType, supplier, organizationId);
    await this.processRepo.update({ routingCode, processSeq: seq, organizationId }, { ...dto, subconSupplierCode: executionType === 'SUBCON' ? supplier! : null });
    return this.processRepo.findOne({ where: { routingCode, processSeq: seq, organizationId } });
  }

  async deleteProcess(routingCode: string, seq: number, organizationId: number) {
    try {
      await this.tx.run(async ({ manager }) => {
        await this.lockRoutingGroup(manager, routingCode, organizationId);
        if (!await manager.findOne(RoutingProcess, { where: { routingCode, processSeq: seq, organizationId } })) throw new NotFoundException(`공정순서를 찾을 수 없습니다: ${routingCode}/${seq}`);
        if (await manager.count(RoutingMaterial, { where: { routingCode, processSeq: seq, organizationId } })) throw new ConflictException('투입자재가 있는 공정은 삭제할 수 없습니다.');
        await manager.delete(RoutingProcess, { routingCode, processSeq: seq, organizationId });
      });
    } catch (error: unknown) { this.conflictIntegrity(error); }
    return { routingCode, seq };
  }

  async reorderProcesses(routingCode: string, dto: ReorderRoutingProcessesDto, organizationId: number) {
    if (dto.changes.some((c) => c.fromSeq < 1 || c.fromSeq > 9_999_999_999 || c.toSeq < 1 || c.toSeq > 9_999_999_999)) throw new ConflictException('공정순번은 NUMBER(10) 양수 범위여야 합니다.');
    try {
      await this.tx.run(async ({ manager }) => {
        await this.lockRoutingGroup(manager, routingCode, organizationId);

        const processRows = await manager.query(
          'SELECT p.PROCESS_SEQ AS "processSeq" FROM IP_ROUTING_PROCESSES p WHERE p.ORGANIZATION_ID = :organizationId AND p.ROUTING_CODE = :routingCode ORDER BY p.PROCESS_SEQ FOR UPDATE',
          { organizationId, routingCode } as never,
        ) as { processSeq: number }[];
        const materialRows = await manager.query(
          'SELECT PROCESS_SEQ AS "processSeq", COUNT(*) AS "materialCount" FROM IP_ROUTING_MATERIALS WHERE ORGANIZATION_ID = :organizationId AND ROUTING_CODE = :routingCode GROUP BY PROCESS_SEQ',
          { organizationId, routingCode } as never,
        ) as { processSeq: number; materialCount: number }[];
        const materialCounts = new Map(materialRows.map((row) => [Number(row.processSeq), Number(row.materialCount)]));
        const current = processRows.map((row) => Number(row.processSeq)).sort((a, b) => a - b);
        const from = dto.changes.map((change) => change.fromSeq).sort((a, b) => a - b);
        const to = dto.changes.map((change) => change.toSeq);
        if (new Set(from).size !== from.length || new Set(to).size !== to.length || current.length !== from.length || current.some((value, index) => value !== from[index])) {
          throw new ConflictException('현재 전체 공정의 정확한 순번 매핑이 필요합니다.');
        }
        const occupied = new Set([...current, ...to]);
        let nextTemp = 9_999_999_999;
        const changes = dto.changes.map((change) => {
          while (occupied.has(nextTemp)) nextTemp--;
          if (nextTemp < 1) throw new ConflictException('충돌 없는 임시 공정순번을 만들 수 없습니다.');
          occupied.add(nextTemp);
          return { ...change, tempSeq: nextTemp--, materialCount: materialCounts.get(change.fromSeq) ?? 0 };
        });
        const assertAffected = (result: unknown, expected: number) => {
          const affected = typeof result === 'number'
            ? result
            : result && typeof result === 'object' && 'rowsAffected' in result
              ? Number(result.rowsAffected)
              : -1;
          if (affected !== expected) throw new ConflictException('재정렬 중 동시 변경이 감지되었습니다. 다시 조회 후 시도해 주세요.');
        };

        await manager.query('SET CONSTRAINTS FK_IP_RM_PROCESS DEFERRED');
        for (const c of changes) {
          const materialResult = await manager.query('UPDATE IP_ROUTING_MATERIALS SET PROCESS_SEQ = :tempSeq WHERE ORGANIZATION_ID = :organizationId AND ROUTING_CODE = :routingCode AND PROCESS_SEQ = :fromSeq', { organizationId, routingCode, fromSeq: c.fromSeq, tempSeq: c.tempSeq } as never);
          assertAffected(materialResult, c.materialCount);
          const processResult = await manager.query('UPDATE IP_ROUTING_PROCESSES SET PROCESS_SEQ = :tempSeq WHERE ORGANIZATION_ID = :organizationId AND ROUTING_CODE = :routingCode AND PROCESS_SEQ = :fromSeq', { organizationId, routingCode, fromSeq: c.fromSeq, tempSeq: c.tempSeq } as never);
          assertAffected(processResult, 1);
        }
        for (const c of changes) {
          const processResult = await manager.query('UPDATE IP_ROUTING_PROCESSES SET PROCESS_SEQ = :toSeq WHERE ORGANIZATION_ID = :organizationId AND ROUTING_CODE = :routingCode AND PROCESS_SEQ = :tempSeq', { organizationId, routingCode, tempSeq: c.tempSeq, toSeq: c.toSeq } as never);
          assertAffected(processResult, 1);
          const materialResult = await manager.query('UPDATE IP_ROUTING_MATERIALS SET PROCESS_SEQ = :toSeq WHERE ORGANIZATION_ID = :organizationId AND ROUTING_CODE = :routingCode AND PROCESS_SEQ = :tempSeq', { organizationId, routingCode, tempSeq: c.tempSeq, toSeq: c.toSeq } as never);
          assertAffected(materialResult, c.materialCount);
        }
      });
    } catch (error: unknown) { this.conflictIntegrity(error); }
    return this.findProcesses(routingCode, organizationId);
  }

  async findMaterials(routingCode: string, seq: number, organizationId: number) {
    const group = await this.findGroupByCode(routingCode, organizationId);
    const [bom, assigned] = await Promise.all([
      this.findCurrentBom(this.bomRepo, group.itemCode, organizationId),
      this.materialRepo.find({ where: { routingCode, organizationId } }),
    ]);
    this.assertNoOverlappingCurrentBom(bom);
    const codes = [...new Set([...bom.map((b) => b.childItemCode), ...assigned.map((m) => m.childItemCode)])];
    const items = codes.length ? await this.itemRepo.find({ where: { organizationId, itemCode: In(codes) } }) : [];
    const bomMap = new Map(bom.map((b) => [b.childItemCode, b])); const itemMap = new Map(items.map((i) => [i.itemCode, i]));
    const assignedMap = new Map(assigned.map((m) => [m.childItemCode, m]));
    return codes.map((code) => {
      const b = bomMap.get(code); const a = assignedMap.get(code); const mine = a?.processSeq === seq;
      return { childItemCode: code, childItemName: itemMap.get(code)?.itemName ?? null, bomQty: b?.bomQty ?? null, allocQty: mine ? a?.allocQty : b?.bomQty ?? null,
        bomMatchYn: b ? 'Y' : 'N', mismatchReason: b ? null : '현재 유효 BOM에 없음', assignedProcessSeq: a?.processSeq ?? null,
        selectableYn: !a || mine ? 'Y' : 'N', issueMethod: mine ? a?.issueMethod : 'BACKFLUSH' };
    });
  }

  private async findCurrentBom(
    source: Pick<Repository<BomMaster>, 'query'> | Pick<EntityManager, 'query'>,
    parentItemCode: string,
    organizationId: number,
    childCodes?: string[],
  ): Promise<{ childItemCode: string; bomQty: number }[]> {
    const binds: Record<string, unknown> = { parentItemCode, organizationId };
    let childFilter = '';
    if (childCodes?.length) {
      const placeholders = childCodes.map((code, index) => {
        const key = `child${index}`; binds[key] = code; return `:${key}`;
      });
      childFilter = ` AND CHILD_ITEM_CODE IN (${placeholders.join(', ')})`;
    }
    return source.query(
      `SELECT CHILD_ITEM_CODE AS "childItemCode", ITEM_UNIT_QTY AS "bomQty"
         FROM ID_ENG_BOM
        WHERE ORGANIZATION_ID = :organizationId
          AND PARENT_ITEM_CODE = :parentItemCode
          AND DATESET <= TRUNC(SYSDATE)
          AND DATEEND >= TRUNC(SYSDATE)${childFilter}
        ORDER BY SORT_SEQUENCE, CHILD_ITEM_CODE`,
      binds as never,
    ) as Promise<{ childItemCode: string; bomQty: number }[]>;
  }

  private assertNoOverlappingCurrentBom(rows: { childItemCode: string }[]) {
    const seen = new Set<string>();
    const duplicate = rows.find((row) => seen.has(row.childItemCode) || !seen.add(row.childItemCode));
    if (duplicate) throw new UnprocessableEntityException(`현재 BOM 적용기간이 중복된 자재입니다: ${duplicate.childItemCode}`);
  }

  async bulkSaveMaterials(routingCode: string, seq: number, dto: BulkSaveRoutingMaterialDto, organizationId: number) {
    const group = await this.findGroupByCode(routingCode, organizationId);
    const upsertCodes = dto.upserts.map((u) => u.childItemCode);
    const deleteCodes = dto.deletes.map((d) => d.childItemCode);
    const allCodes = [...upsertCodes, ...deleteCodes];
    if (new Set(allCodes).size !== allCodes.length) throw new ConflictException('동일 자재를 요청에서 중복 변경할 수 없습니다.');
    const nonPositive = dto.upserts.find((u) => !Number.isFinite(u.allocQty) || u.allocQty <= 0);
    if (nonPositive) throw new UnprocessableEntityException(`투입수량은 양수여야 합니다: ${nonPositive.childItemCode}`);
    try {
      await this.tx.run(async ({ manager }) => {
        const lockedGroup = await this.lockRoutingGroup(manager, routingCode, organizationId);
        if (!await manager.findOne(RoutingProcess, { where: { routingCode, processSeq: seq, organizationId } })) throw new NotFoundException(`공정순서를 찾을 수 없습니다: ${routingCode}/${seq}`);
        const bom = upsertCodes.length ? await this.findCurrentBom(manager, lockedGroup.itemCode, organizationId, upsertCodes) : [];
        this.assertNoOverlappingCurrentBom(bom);
        const valid = new Set(bom.map((b) => b.childItemCode));
        const invalid = upsertCodes.find((code) => !valid.has(code));
        if (invalid) throw new UnprocessableEntityException(`현재 유효 BOM에 없는 자재입니다: ${invalid}`);
        const existing = allCodes.length ? await manager.find(RoutingMaterial, { where: { routingCode, childItemCode: In(allCodes), organizationId } }) : [];
        const ownership = existing.find((material) => material.processSeq !== seq);
        if (ownership) throw new ConflictException(`자재가 공정 ${ownership.processSeq}에 이미 배정되어 있습니다: ${ownership.childItemCode}`);
        for (const item of dto.deletes) await manager.delete(RoutingMaterial, { routingCode, processSeq: seq, childItemCode: item.childItemCode, organizationId });
        for (const item of dto.upserts) await manager.save(RoutingMaterial, manager.create(RoutingMaterial, {
          routingCode, processSeq: seq, childItemCode: item.childItemCode, allocQty: item.allocQty,
          issueMethod: item.issueMethod ?? 'BACKFLUSH', organizationId,
        }));
      });
    } catch (error: unknown) { this.conflictIntegrity(error); }
    return this.findMaterials(routingCode, seq, organizationId);
  }
}
