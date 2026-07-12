import { ConflictException, Injectable, NotFoundException, UnprocessableEntityException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, LessThanOrEqual, MoreThanOrEqual, Repository } from 'typeorm';
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
    await this.findGroupByCode(routingCode, organizationId);
    if (await this.processRepo.findOne({ where: { routingCode, processSeq: dto.seq, organizationId } })) throw new ConflictException(`이미 존재하는 공정순서: ${routingCode}/${dto.seq}`);
    const executionType = dto.executionType ?? 'INTERNAL';
    await this.validateProcessRefs(dto.workstageCode, executionType, dto.subconSupplierCode, organizationId);
    try {
      return await this.processRepo.save(this.processRepo.create({ routingCode, processSeq: dto.seq, workstageCode: dto.workstageCode, executionType,
        jobOrderYn: dto.jobOrderYn ?? 'Y', subconSupplierCode: executionType === 'SUBCON' ? dto.subconSupplierCode! : null,
        standardTime: dto.standardTime ?? null, setupTime: dto.setupTime ?? null, useYn: dto.useYn ?? 'Y', organizationId }));
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
    if (!await this.processRepo.findOne({ where: { routingCode, processSeq: seq, organizationId } })) throw new NotFoundException(`공정순서를 찾을 수 없습니다: ${routingCode}/${seq}`);
    if (await this.materialRepo.count({ where: { routingCode, processSeq: seq, organizationId } })) throw new ConflictException('투입자재가 있는 공정은 삭제할 수 없습니다.');
    await this.processRepo.delete({ routingCode, processSeq: seq, organizationId });
    return { routingCode, seq };
  }

  async reorderProcesses(routingCode: string, dto: ReorderRoutingProcessesDto, organizationId: number) {
    const rows = await this.processRepo.find({ where: { routingCode, organizationId }, select: ['processSeq'] });
    const current = rows.map((r) => r.processSeq).sort((a, b) => a - b);
    const from = dto.changes.map((c) => c.fromSeq).sort((a, b) => a - b);
    const to = dto.changes.map((c) => c.toSeq);
    if (new Set(from).size !== from.length || new Set(to).size !== to.length || current.length !== from.length || current.some((v, i) => v !== from[i])) throw new ConflictException('현재 전체 공정의 정확한 순번 매핑이 필요합니다.');
    const occupied = new Set([...current, ...to]);
    let nextTemp = 9_999_999_999;
    const changes = dto.changes.map((change) => { while (occupied.has(nextTemp)) nextTemp--; if (nextTemp < 1) throw new ConflictException('충돌 없는 임시 공정순번을 만들 수 없습니다.'); occupied.add(nextTemp); return { ...change, tempSeq: nextTemp-- }; });
    return this.tx.run(async ({ manager }) => {
      await manager.query('SET CONSTRAINT FK_IP_RM_PROCESS DEFERRED');
      for (const c of changes) {
        await manager.query('UPDATE IP_ROUTING_MATERIALS SET PROCESS_SEQ = :tempSeq WHERE ORGANIZATION_ID = :organizationId AND ROUTING_CODE = :routingCode AND PROCESS_SEQ = :fromSeq', { organizationId, routingCode, fromSeq: c.fromSeq, tempSeq: c.tempSeq } as never);
        await manager.query('UPDATE IP_ROUTING_PROCESSES SET PROCESS_SEQ = :tempSeq WHERE ORGANIZATION_ID = :organizationId AND ROUTING_CODE = :routingCode AND PROCESS_SEQ = :fromSeq', { organizationId, routingCode, fromSeq: c.fromSeq, tempSeq: c.tempSeq } as never);
      }
      for (const c of changes) {
        await manager.query('UPDATE IP_ROUTING_PROCESSES SET PROCESS_SEQ = :toSeq WHERE ORGANIZATION_ID = :organizationId AND ROUTING_CODE = :routingCode AND PROCESS_SEQ = :tempSeq', { organizationId, routingCode, tempSeq: c.tempSeq, toSeq: c.toSeq } as never);
        await manager.query('UPDATE IP_ROUTING_MATERIALS SET PROCESS_SEQ = :toSeq WHERE ORGANIZATION_ID = :organizationId AND ROUTING_CODE = :routingCode AND PROCESS_SEQ = :tempSeq', { organizationId, routingCode, tempSeq: c.tempSeq, toSeq: c.toSeq } as never);
      }
      return this.findProcesses(routingCode, organizationId);
    });
  }

  async findMaterials(routingCode: string, seq: number, organizationId: number) {
    const group = await this.findGroupByCode(routingCode, organizationId);
    const today = new Date();
    const [bom, assigned, items] = await Promise.all([
      this.bomRepo.find({ where: { parentItemCode: group.itemCode, organizationId, validFrom: LessThanOrEqual(today), validTo: MoreThanOrEqual(today) }, order: { seq: 'ASC' } }),
      this.materialRepo.find({ where: { routingCode, organizationId } }), this.itemRepo.find({ where: { organizationId } }),
    ]);
    const bomMap = new Map(bom.map((b) => [b.childItemCode, b])); const itemMap = new Map(items.map((i) => [i.itemCode, i]));
    return [...new Set([...bom.map((b) => b.childItemCode), ...assigned.map((m) => m.childItemCode)])].map((code) => {
      const b = bomMap.get(code); const a = assigned.find((m) => m.childItemCode === code); const mine = a?.processSeq === seq;
      return { childItemCode: code, childItemName: itemMap.get(code)?.itemName ?? null, bomQty: b?.qtyPer ?? null, allocQty: mine ? a?.allocQty : b?.qtyPer ?? null,
        bomMatchYn: b ? 'Y' : 'N', mismatchReason: b ? null : '현재 유효 BOM에 없음', assignedProcessSeq: a?.processSeq ?? null,
        selectableYn: !a || mine ? 'Y' : 'N', issueMethod: mine ? a?.issueMethod : 'BACKFLUSH' };
    });
  }

  async bulkSaveMaterials(routingCode: string, seq: number, dto: BulkSaveRoutingMaterialDto, organizationId: number) {
    const group = await this.findGroupByCode(routingCode, organizationId);
    if (!await this.processRepo.findOne({ where: { routingCode, processSeq: seq, organizationId } })) throw new NotFoundException(`공정순서를 찾을 수 없습니다: ${routingCode}/${seq}`);
    const codes = dto.upserts.map((u) => u.childItemCode); const today = new Date();
    const bom = codes.length ? await this.bomRepo.find({ where: { parentItemCode: group.itemCode, childItemCode: In(codes), organizationId, validFrom: LessThanOrEqual(today), validTo: MoreThanOrEqual(today) } }) : [];
    const valid = new Set(bom.map((b) => b.childItemCode)); const invalid = codes.find((c) => !valid.has(c));
    if (invalid) throw new UnprocessableEntityException(`현재 유효 BOM에 없는 자재입니다: ${invalid}`);
    const existing = codes.length ? await this.materialRepo.find({ where: { routingCode, childItemCode: In(codes), organizationId } }) : [];
    const conflict = existing.find((m) => m.processSeq !== seq); if (conflict) throw new ConflictException(`자재가 공정 ${conflict.processSeq}에 이미 배정되어 있습니다: ${conflict.childItemCode}`);
    return this.tx.run(async ({ manager }) => {
      for (const d of dto.deletes) await manager.delete(RoutingMaterial, { routingCode, processSeq: seq, childItemCode: d.childItemCode, organizationId });
      for (const u of dto.upserts) await manager.save(RoutingMaterial, manager.create(RoutingMaterial, { routingCode, processSeq: seq, childItemCode: u.childItemCode, allocQty: u.allocQty, issueMethod: u.issueMethod ?? 'BACKFLUSH', organizationId }));
      return this.findMaterials(routingCode, seq, organizationId);
    });
  }
}
