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
import { AssignRoutingItemsDto, BulkSaveRoutingMaterialDto, CreateRoutingGroupDto, CreateRoutingProcessDto, ReorderRoutingProcessesDto, RoutingCandidateItemQueryDto, RoutingGroupQueryDto, UpdateRoutingGroupDto, UpdateRoutingProcessDto } from '../dto/routing-group.dto';
import { namedBinds } from '../../../common/utils/named-binds.util';

@Injectable()
export class RoutingGroupService {
  private static readonly ORACLE_IN_LIMIT = 1000;

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
    if (search) qb.andWhere('(g.routingCode LIKE :search OR g.routingName LIKE :search)', { search: `%${search}%` });
    const [groups, total] = await qb.orderBy('g.routingCode', 'ASC').skip((page - 1) * limit).take(limit).getManyAndCount();
    const counts = await this.countItemsByRouting(groups.map((g) => g.routingCode), organizationId);
    const data = groups.map((g) => ({ ...g, itemCount: counts.get(g.routingCode) ?? 0 }));
    return { data, total, page, limit };
  }

  /** 라우팅 코드별로 그 코드를 따르는 품목 수 (ID_ITEM.ROUTING_CODE) */
  private async countItemsByRouting(routingCodes: string[], organizationId: number) {
    const rows = (await Promise.all(this.chunkOracleIn(routingCodes).map((chunk) =>
      this.itemRepo.createQueryBuilder('i')
        .select('i.routingCode', 'routingCode').addSelect('COUNT(*)', 'itemCount')
        .where('i.organizationId = :organizationId', { organizationId })
        .andWhere('i.routingCode IN (:...chunk)', { chunk })
        .groupBy('i.routingCode')
        .getRawMany<{ routingCode: string; itemCount: string | number }>(),
    ))).flat();
    return new Map(rows.map((row) => [row.routingCode, Number(row.itemCount)]));
  }

  async findGroupByCode(routingCode: string, organizationId: number) {
    const group = await this.groupRepo.findOne({ where: { routingCode, organizationId } });
    if (!group) throw new NotFoundException(`라우팅 그룹을 찾을 수 없습니다: ${routingCode}`);
    return group;
  }

  private conflictUnique(error: unknown): never {
    if (error instanceof Error && (('code' in error && error.code === 'ORA-00001') || error.message.includes('ORA-00001'))) {
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
      'SELECT ROUTING_CODE AS "routingCode" FROM IP_ROUTING_GROUPS WHERE ORGANIZATION_ID = :organizationId AND ROUTING_CODE = :routingCode FOR UPDATE',
      namedBinds({ organizationId, routingCode }),
    ) as { routingCode: string }[];
    if (rows.length !== 1) throw new NotFoundException(`라우팅 그룹을 찾을 수 없습니다: ${routingCode}`);
    return rows[0];
  }

  async createGroup(dto: CreateRoutingGroupDto, organizationId: number) {
    if (await this.groupRepo.findOne({ where: { routingCode: dto.routingCode, organizationId } })) throw new ConflictException(`이미 존재하는 라우팅 그룹: ${dto.routingCode}`);
    try {
      return await this.groupRepo.save(this.groupRepo.create({ ...dto, description: dto.description ?? null, useYn: dto.useYn ?? 'Y', organizationId }));
    } catch (error: unknown) { return this.conflictUnique(error); }
  }

  async updateGroup(routingCode: string, dto: UpdateRoutingGroupDto, organizationId: number) {
    await this.findGroupByCode(routingCode, organizationId);
    const changes = { routingName: dto.routingName, description: dto.description, useYn: dto.useYn };
    try { await this.groupRepo.update({ routingCode, organizationId }, changes); }
    catch (error: unknown) { return this.conflictUnique(error); }
    return this.findGroupByCode(routingCode, organizationId);
  }

  async deleteGroup(routingCode: string, organizationId: number) {
    await this.findGroupByCode(routingCode, organizationId);
    if (await this.processRepo.count({ where: { routingCode, organizationId } })) throw new ConflictException('공정이 있는 라우팅 그룹은 삭제할 수 없습니다.');
    if (await this.itemRepo.count({ where: { routingCode, organizationId } })) throw new ConflictException('품목이 배정된 라우팅 그룹은 삭제할 수 없습니다.');
    await this.groupRepo.delete({ routingCode, organizationId });
    return { routingCode };
  }

  /** 이 라우팅을 따르는 품목과 품목별 투입자재 배정 수 */
  async findRoutingItems(routingCode: string, organizationId: number) {
    await this.findGroupByCode(routingCode, organizationId);
    const [items, materialRows] = await Promise.all([
      this.itemRepo.find({
        where: { organizationId, routingCode },
        select: { itemCode: true, itemName: true, modelName: true, itemDivision: true },
        order: { itemCode: 'ASC' },
      }),
      this.materialRepo.createQueryBuilder('m')
        .select('m.itemCode', 'itemCode').addSelect('COUNT(*)', 'materialCount')
        .where('m.organizationId = :organizationId', { organizationId })
        .andWhere('m.routingCode = :routingCode', { routingCode })
        .groupBy('m.itemCode')
        .getRawMany<{ itemCode: string; materialCount: string | number }>(),
    ]);
    const materialCounts = new Map(materialRows.map((row) => [row.itemCode, Number(row.materialCount)]));
    return items.map((item) => ({
      itemCode: item.itemCode, itemName: item.itemName, modelName: item.modelName, itemDivision: item.itemDivision,
      materialCount: materialCounts.get(item.itemCode) ?? 0,
    }));
  }

  /** 라우팅을 붙일 수 있는 반제품(W)·완제품(F). 현재 따르는 라우팅과 유효 BOM 유무를 함께 돌려준다. */
  async findCandidateItems(query: RoutingCandidateItemQueryDto, organizationId: number) {
    const { page = 1, limit = 50, search } = query;
    const qb = this.itemRepo.createQueryBuilder('i')
      .select(['i.itemCode', 'i.itemName', 'i.modelName', 'i.itemDivision', 'i.routingCode'])
      .where('i.organizationId = :organizationId', { organizationId })
      .andWhere('i.itemDivision IN (:...divisions)', { divisions: ['W', 'F'] });
    if (search) qb.andWhere('(i.itemCode LIKE :search OR i.itemName LIKE :search OR i.modelName LIKE :search)', { search: `%${search}%` });
    const [items, total] = await qb.orderBy('i.itemCode', 'ASC').skip((page - 1) * limit).take(limit).getManyAndCount();
    const routingCodes = [...new Set(items.map((i) => i.routingCode).filter((c): c is string => !!c))];
    const groups = (await Promise.all(this.chunkOracleIn(routingCodes).map((chunk) =>
      this.groupRepo.find({ where: { organizationId, routingCode: In(chunk) } }),
    ))).flat();
    const groupNames = new Map(groups.map((g) => [g.routingCode, g.routingName]));
    const bomParents = new Set((await Promise.all(this.chunkOracleIn(items.map((i) => i.itemCode)).map((chunk) =>
      this.queryBomParents(organizationId, chunk),
    ))).flat());
    const data = items.map((i) => ({
      itemCode: i.itemCode, itemName: i.itemName, modelName: i.modelName, itemDivision: i.itemDivision,
      routingCode: i.routingCode, routingName: i.routingCode ? groupNames.get(i.routingCode) ?? null : null,
      bomRegisteredYn: bomParents.has(i.itemCode) ? 'Y' : 'N',
    }));
    return { data, total, page, limit };
  }

  private async queryBomParents(organizationId: number, itemCodes: string[]): Promise<string[]> {
    if (itemCodes.length === 0) return [];
    const binds: Record<string, unknown> = { organizationId };
    const placeholders = itemCodes.map((code, index) => { binds[`p${index}`] = code; return `:p${index}`; });
    const rows = await this.bomRepo.query<{ itemCode: string }[]>(
      `SELECT DISTINCT PARENT_ITEM_CODE AS "itemCode"
         FROM ID_ENG_BOM
        WHERE ORGANIZATION_ID = :organizationId
          AND PARENT_ITEM_CODE IN (${placeholders.join(', ')})
          AND DATESET <= TRUNC(SYSDATE)
          AND DATEEND >= TRUNC(SYSDATE)`,
      namedBinds(binds),
    );
    return rows.map((row) => row.itemCode);
  }

  /**
   * 품목에 라우팅 코드를 붙이거나 뗀다 (ID_ITEM.ROUTING_CODE).
   * ROUTE_NO(레거시 라우팅번호)는 건드리지 않는다. 생산 라우팅은 ROUTING_CODE 만 쓴다.
   * 투입자재가 배정된 품목은 다른 라우팅으로 옮기거나 뗄 수 없다 (FK_IP_RM_PARENT 도 막는다).
   */
  async assignItems(routingCode: string, dto: AssignRoutingItemsDto, organizationId: number) {
    const assign = [...new Set(dto.assign)];
    const unassign = [...new Set(dto.unassign)];
    const overlap = assign.find((code) => unassign.includes(code));
    if (overlap) throw new ConflictException(`같은 품목을 배정과 해제에 함께 넣을 수 없습니다: ${overlap}`);
    const codes = [...assign, ...unassign];
    if (codes.length === 0) return this.findRoutingItems(routingCode, organizationId);
    try {
      await this.tx.run(async ({ manager }) => {
        await this.lockRoutingGroup(manager, routingCode, organizationId);
        const items = (await Promise.all(this.chunkOracleIn(codes).map((chunk) =>
          manager.find(ItemMaster, { where: { organizationId, itemCode: In(chunk) }, select: { itemCode: true, itemDivision: true, routingCode: true } }),
        ))).flat();
        const itemMap = new Map(items.map((i) => [i.itemCode, i]));
        const missing = codes.find((code) => !itemMap.has(code));
        if (missing) throw new NotFoundException(`품목을 찾을 수 없습니다: ${missing}`);
        const notProduced = assign.find((code) => !['W', 'F'].includes(itemMap.get(code)!.itemDivision));
        if (notProduced) throw new UnprocessableEntityException(`반제품·완제품만 라우팅을 붙일 수 있습니다: ${notProduced}`);
        const notMine = unassign.find((code) => itemMap.get(code)!.routingCode !== routingCode);
        if (notMine) throw new ConflictException(`이 라우팅을 따르지 않는 품목입니다: ${notMine}`);

        const leaving = [...assign.filter((code) => { const current = itemMap.get(code)!.routingCode; return !!current && current !== routingCode; }), ...unassign];
        for (const chunk of this.chunkOracleIn(leaving)) {
          const held = await manager.findOne(RoutingMaterial, { where: { organizationId, itemCode: In(chunk) } });
          if (held) throw new ConflictException(`투입자재가 배정된 품목은 라우팅을 바꿀 수 없습니다. 먼저 자재 배정을 지우세요: ${held.itemCode}`);
        }
        for (const chunk of this.chunkOracleIn(assign)) await manager.update(ItemMaster, { organizationId, itemCode: In(chunk) }, { routingCode });
        for (const chunk of this.chunkOracleIn(unassign)) await manager.update(ItemMaster, { organizationId, itemCode: In(chunk) }, { routingCode: null });
      });
    } catch (error: unknown) { this.conflictIntegrity(error); }
    return this.findRoutingItems(routingCode, organizationId);
  }

  async findProcesses(routingCode: string, organizationId: number) {
    const processes = await this.processRepo.find({ where: { routingCode, organizationId }, order: { processSeq: 'ASC' } });
    const stageCodes = [...new Set(processes.map((p) => p.workstageCode))];
    const supplierCodes = [...new Set(processes.map((p) => p.subconSupplierCode).filter((c): c is string => !!c))];
    const stages = (await Promise.all(this.chunkOracleIn(stageCodes).map((chunk) =>
      this.workstageRepo.find({ where: { organizationId, processCode: In(chunk) } }),
    ))).flat();
    const suppliers = (await Promise.all(this.chunkOracleIn(supplierCodes).map((chunk) =>
      this.supplierRepo.find({ where: { organizationId, supplierCode: In(chunk) } }),
    ))).flat();
    const stageMap = new Map(stages.map((w) => [w.processCode, w.processName]));
    const supplierMap = new Map(suppliers.map((v) => [v.supplierCode, v.supplierName]));
    return processes.map((p) => ({ ...p, workstageName: stageMap.get(p.workstageCode) ?? null, subconSupplierName: p.subconSupplierCode ? supplierMap.get(p.subconSupplierCode) ?? null : null }));
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
          namedBinds({ organizationId, routingCode }),
        ) as { processSeq: number }[];
        const materialRows = await manager.query(
          'SELECT PROCESS_SEQ AS "processSeq", COUNT(*) AS "materialCount" FROM IP_ROUTING_MATERIALS WHERE ORGANIZATION_ID = :organizationId AND ROUTING_CODE = :routingCode GROUP BY PROCESS_SEQ',
          namedBinds({ organizationId, routingCode }),
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
          const materialResult = await manager.query('UPDATE IP_ROUTING_MATERIALS SET PROCESS_SEQ = :tempSeq WHERE ORGANIZATION_ID = :organizationId AND ROUTING_CODE = :routingCode AND PROCESS_SEQ = :fromSeq', namedBinds({ organizationId, routingCode, fromSeq: c.fromSeq, tempSeq: c.tempSeq }));
          assertAffected(materialResult, c.materialCount);
          const processResult = await manager.query('UPDATE IP_ROUTING_PROCESSES SET PROCESS_SEQ = :tempSeq WHERE ORGANIZATION_ID = :organizationId AND ROUTING_CODE = :routingCode AND PROCESS_SEQ = :fromSeq', namedBinds({ organizationId, routingCode, fromSeq: c.fromSeq, tempSeq: c.tempSeq }));
          assertAffected(processResult, 1);
        }
        for (const c of changes) {
          const processResult = await manager.query('UPDATE IP_ROUTING_PROCESSES SET PROCESS_SEQ = :toSeq WHERE ORGANIZATION_ID = :organizationId AND ROUTING_CODE = :routingCode AND PROCESS_SEQ = :tempSeq', namedBinds({ organizationId, routingCode, tempSeq: c.tempSeq, toSeq: c.toSeq }));
          assertAffected(processResult, 1);
          const materialResult = await manager.query('UPDATE IP_ROUTING_MATERIALS SET PROCESS_SEQ = :toSeq WHERE ORGANIZATION_ID = :organizationId AND ROUTING_CODE = :routingCode AND PROCESS_SEQ = :tempSeq', namedBinds({ organizationId, routingCode, tempSeq: c.tempSeq, toSeq: c.toSeq }));
          assertAffected(materialResult, c.materialCount);
        }
      });
    } catch (error: unknown) { this.conflictIntegrity(error); }
    return this.findProcesses(routingCode, organizationId);
  }

  /** 투입자재를 다루는 품목은 이 라우팅을 따르는 품목이어야 한다. */
  private async assertItemOnRouting(source: Pick<EntityManager, 'findOne'>, itemCode: string, routingCode: string, organizationId: number) {
    const item = await source.findOne(ItemMaster, { where: { itemCode, organizationId }, select: { itemCode: true, routingCode: true } });
    if (!item) throw new NotFoundException(`품목을 찾을 수 없습니다: ${itemCode}`);
    if (item.routingCode !== routingCode) throw new UnprocessableEntityException(`이 라우팅을 따르는 품목이 아닙니다: ${itemCode}`);
  }

  async findMaterials(routingCode: string, seq: number, itemCode: string, organizationId: number) {
    await this.findGroupByCode(routingCode, organizationId);
    await this.assertItemOnRouting(this.itemRepo.manager, itemCode, routingCode, organizationId);
    const [bom, assigned] = await Promise.all([
      this.findCurrentBom(this.bomRepo, itemCode, organizationId),
      this.materialRepo.find({ where: { routingCode, itemCode, organizationId } }),
    ]);
    this.assertNoOverlappingCurrentBom(bom);
    const codes = [...new Set([...bom.map((b) => b.childItemCode), ...assigned.map((m) => m.childItemCode)])];
    const items = (await Promise.all(this.chunkOracleIn(codes).map((chunk) =>
      this.itemRepo.find({ where: { organizationId, itemCode: In(chunk) } }),
    ))).flat();
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
    if (childCodes) {
      const chunks = this.chunkOracleIn(childCodes);
      if (chunks.length === 0) return [];
      return (await Promise.all(chunks.map((chunk) =>
        this.queryCurrentBom(source, parentItemCode, organizationId, chunk),
      ))).flat();
    }
    return this.queryCurrentBom(source, parentItemCode, organizationId);
  }

  private async queryCurrentBom(
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
    return source.query<{ childItemCode: string; bomQty: number }[]>(
      `SELECT CHILD_ITEM_CODE AS "childItemCode", ITEM_UNIT_QTY AS "bomQty"
         FROM ID_ENG_BOM
        WHERE ORGANIZATION_ID = :organizationId
          AND PARENT_ITEM_CODE = :parentItemCode
          AND DATESET <= TRUNC(SYSDATE)
          AND DATEEND >= TRUNC(SYSDATE)${childFilter}
        ORDER BY SORT_SEQUENCE, CHILD_ITEM_CODE`,
      namedBinds(binds),
    );
  }

  private chunkOracleIn<T>(values: T[]): T[][] {
    const chunks: T[][] = [];
    for (let index = 0; index < values.length; index += RoutingGroupService.ORACLE_IN_LIMIT) {
      chunks.push(values.slice(index, index + RoutingGroupService.ORACLE_IN_LIMIT));
    }
    return chunks;
  }

  private assertNoOverlappingCurrentBom(rows: { childItemCode: string }[]) {
    const seen = new Set<string>();
    const duplicate = rows.find((row) => seen.has(row.childItemCode) || !seen.add(row.childItemCode));
    if (duplicate) throw new UnprocessableEntityException(`현재 BOM 적용기간이 중복된 자재입니다: ${duplicate.childItemCode}`);
  }

  async bulkSaveMaterials(routingCode: string, seq: number, dto: BulkSaveRoutingMaterialDto, organizationId: number) {
    const { itemCode } = dto;
    await this.findGroupByCode(routingCode, organizationId);
    const upsertCodes = dto.upserts.map((u) => u.childItemCode);
    const deleteCodes = dto.deletes.map((d) => d.childItemCode);
    const allCodes = [...upsertCodes, ...deleteCodes];
    if (new Set(allCodes).size !== allCodes.length) throw new ConflictException('동일 자재를 요청에서 중복 변경할 수 없습니다.');
    const nonPositive = dto.upserts.find((u) => !Number.isFinite(u.allocQty) || u.allocQty <= 0);
    if (nonPositive) throw new UnprocessableEntityException(`투입수량은 양수여야 합니다: ${nonPositive.childItemCode}`);
    try {
      await this.tx.run(async ({ manager }) => {
        await this.lockRoutingGroup(manager, routingCode, organizationId);
        await this.assertItemOnRouting(manager, itemCode, routingCode, organizationId);
        if (!await manager.findOne(RoutingProcess, { where: { routingCode, processSeq: seq, organizationId } })) throw new NotFoundException(`공정순서를 찾을 수 없습니다: ${routingCode}/${seq}`);
        const bom = upsertCodes.length ? await this.findCurrentBom(manager, itemCode, organizationId, upsertCodes) : [];
        this.assertNoOverlappingCurrentBom(bom);
        const valid = new Set(bom.map((b) => b.childItemCode));
        const invalid = upsertCodes.find((code) => !valid.has(code));
        if (invalid) throw new UnprocessableEntityException(`현재 유효 BOM에 없는 자재입니다: ${invalid}`);
        const existing = (await Promise.all(this.chunkOracleIn(allCodes).map((chunk) =>
          manager.find(RoutingMaterial, { where: { routingCode, itemCode, childItemCode: In(chunk), organizationId } }),
        ))).flat();
        const ownership = existing.find((material) => material.processSeq !== seq);
        if (ownership) throw new ConflictException(`자재가 공정 ${ownership.processSeq}에 이미 배정되어 있습니다: ${ownership.childItemCode}`);
        for (const item of dto.deletes) await manager.delete(RoutingMaterial, { routingCode, processSeq: seq, itemCode, childItemCode: item.childItemCode, organizationId });
        for (const item of dto.upserts) await manager.save(RoutingMaterial, manager.create(RoutingMaterial, {
          routingCode, processSeq: seq, itemCode, childItemCode: item.childItemCode, allocQty: item.allocQty,
          issueMethod: item.issueMethod ?? 'BACKFLUSH', organizationId,
        }));
      });
    } catch (error: unknown) { this.conflictIntegrity(error); }
    return this.findMaterials(routingCode, seq, itemCode, organizationId);
  }
}
