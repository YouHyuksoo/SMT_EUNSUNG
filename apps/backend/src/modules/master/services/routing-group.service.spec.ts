import { ConflictException, NotFoundException, UnprocessableEntityException } from '@nestjs/common';
import { RoutingGroupService } from './routing-group.service';
import { plainToInstance } from 'class-transformer';
import { validateSync } from 'class-validator';
import { ReorderRoutingProcessChangeDto } from '../dto/routing-group.dto';

describe('RoutingGroupService group/process rules', () => {
  it.each([0, 10_000_000_000])('DTO rejects sequence outside NUMBER(10) positive range: %s', (seq) => {
    const dto = plainToInstance(ReorderRoutingProcessChangeDto, { fromSeq: seq, toSeq: seq });
    expect(validateSync(dto)).not.toHaveLength(0);
  });
  const repo = () => ({ findOne: jest.fn(), find: jest.fn(async () => [] as unknown[]), query: jest.fn(), count: jest.fn(), create: jest.fn((v) => v), save: jest.fn(async (v) => v), update: jest.fn(), delete: jest.fn(), createQueryBuilder: jest.fn() });
  let groupRepo: ReturnType<typeof repo>;
  let processRepo: ReturnType<typeof repo>;
  let workstageRepo: ReturnType<typeof repo>;
  let itemRepo: ReturnType<typeof repo>;
  let bomRepo: ReturnType<typeof repo>;
  let materialRepo: ReturnType<typeof repo>;
  let supplierRepo: ReturnType<typeof repo>;
  let manager: any;
  let tx: any;
  let service: RoutingGroupService;

  beforeEach(() => {
    groupRepo = repo(); processRepo = repo(); workstageRepo = repo(); itemRepo = repo();
    bomRepo = repo(); materialRepo = repo(); supplierRepo = repo();
    manager = { query: jest.fn(), findOne: jest.fn(), count: jest.fn(), create: jest.fn((_entity: any, value: any) => value), save: jest.fn(async (_entity: any, value: any) => value), delete: jest.fn() };
    manager.query.mockImplementation(async (sql: string) => {
      if (sql.includes('FROM IP_ROUTING_GROUPS')) return [{ routingCode: 'R1' }];
      if (sql.includes('FROM IP_ROUTING_PROCESSES p')) return [{ processSeq: 10 }, { processSeq: 20 }];
      if (sql.includes('FROM IP_ROUTING_MATERIALS')) return [];
      if (sql.startsWith('UPDATE IP_ROUTING_MATERIALS')) return 0;
      if (sql.startsWith('UPDATE')) return 1;
      return {};
    });
    tx = { run: jest.fn(async (fn) => fn({ manager })) };
    service = new RoutingGroupService(groupRepo as any, processRepo as any, workstageRepo as any,
      itemRepo as any, bomRepo as any, materialRepo as any, supplierRepo as any, tx);
  });

  it('creates a group from a code and a name only; the item holds the routing code', async () => {
    groupRepo.findOne.mockResolvedValue(null);
    await service.createGroup({ routingCode: 'RT-01', routingName: 'ICT → ROUTER' }, 7);
    expect(itemRepo.findOne).not.toHaveBeenCalled();
    expect(groupRepo.create).toHaveBeenCalledWith(expect.objectContaining({ routingCode: 'RT-01', organizationId: 7, useYn: 'Y' }));
    expect(groupRepo.create.mock.calls[0][0]).not.toHaveProperty('itemCode');
  });

  it('rejects a duplicate routing code', async () => {
    groupRepo.findOne.mockResolvedValue({ routingCode: 'RT-01' });
    await expect(service.createGroup({ routingCode: 'RT-01', routingName: 'R' }, 7)).rejects.toThrow(ConflictException);
    expect(groupRepo.save).not.toHaveBeenCalled();
  });

  it('maps ORA-00001 during group save to conflict', async () => {
    groupRepo.findOne.mockResolvedValue(null);
    groupRepo.save.mockRejectedValue(Object.assign(new Error('ORA-00001: unique constraint'), { code: 'ORA-00001' }));
    await expect(service.createGroup({ routingCode: 'R1', routingName: 'R' }, 7))
      .rejects.toThrow(ConflictException);
  });

  it('does not delete a group that items still follow', async () => {
    groupRepo.findOne.mockResolvedValue({ routingCode: 'R1' });
    processRepo.count.mockResolvedValue(0);
    itemRepo.count.mockResolvedValue(2);
    await expect(service.deleteGroup('R1', 7)).rejects.toThrow('품목이 배정된');
    expect(itemRepo.count).toHaveBeenCalledWith({ where: { routingCode: 'R1', organizationId: 7 } });
    expect(groupRepo.delete).not.toHaveBeenCalled();
  });

  it('does not cascade delete a group with processes', async () => {
    groupRepo.findOne.mockResolvedValue({ routingCode: 'R1' });
    processRepo.count.mockResolvedValue(1);
    await expect(service.deleteGroup('R1', 7)).rejects.toThrow(ConflictException);
    expect(groupRepo.delete).not.toHaveBeenCalled();
  });

  it('requires an organization workstage and supplier for SUBCON', async () => {
    groupRepo.findOne.mockResolvedValue({ routingCode: 'R1' });
    processRepo.findOne.mockResolvedValue(null);
    workstageRepo.findOne.mockResolvedValue({ processCode: 'W1' });
    supplierRepo.findOne.mockResolvedValue(null);
    await expect(service.createProcess('R1', { seq: 10, workstageCode: 'W1', executionType: 'SUBCON', subconSupplierCode: 'S1' }, 7))
      .rejects.toThrow(NotFoundException);
    expect(supplierRepo.findOne).toHaveBeenCalledWith({ where: { supplierCode: 'S1', organizationId: 7 } });
  });

  it('clears supplier for INTERNAL and uses exact new entity properties', async () => {
    groupRepo.findOne.mockResolvedValue({ routingCode: 'R1' });
    manager.findOne.mockResolvedValue(null);
    workstageRepo.findOne.mockResolvedValue({ processCode: 'W1' });
    await service.createProcess('R1', { seq: 10, workstageCode: 'W1', executionType: 'INTERNAL', subconSupplierCode: 'IGNORED' }, 7);
    expect(manager.create).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({
      routingCode: 'R1', processSeq: 10, workstageCode: 'W1', executionType: 'INTERNAL', subconSupplierCode: null,
    }));
  });

  it('serializes process creation with reorder by locking the routing group in the same transaction', async () => {
    workstageRepo.findOne.mockResolvedValue({ processCode: 'W1' }); manager.findOne.mockResolvedValue(null);
    const events: string[] = [];
    manager.query.mockImplementation(async (sql: string) => { if (sql.includes('FOR UPDATE')) events.push('route-lock'); return [{ routingCode: 'R1' }]; });
    manager.findOne.mockImplementation(async () => { events.push('process-check'); return null; });
    manager.save.mockImplementation(async (_entity: any, value: any) => { events.push('process-save'); return value; });
    await service.createProcess('R1', { seq: 10, workstageCode: 'W1' }, 7);
    expect(events).toEqual(['route-lock', 'process-check', 'process-save']);
    expect(tx.run).toHaveBeenCalledTimes(1);
    expect(processRepo.save).not.toHaveBeenCalled();
  });

  it('rejects process deletion when materials exist', async () => {
    manager.findOne.mockResolvedValue({ routingCode: 'R1', processSeq: 10 });
    manager.count.mockResolvedValue(1);
    await expect(service.deleteProcess('R1', 10, 7)).rejects.toThrow(ConflictException);
  });

  it('serializes process deletion with reorder and deletes on the transaction manager', async () => {
    const events: string[] = [];
    manager.query.mockImplementation(async (sql: string) => { if (sql.includes('FOR UPDATE')) events.push('route-lock'); return [{ routingCode: 'R1' }]; });
    manager.findOne.mockImplementation(async () => { events.push('process-check'); return { processSeq: 10 }; });
    manager.count.mockImplementation(async () => { events.push('material-check'); return 0; });
    manager.delete.mockImplementation(async () => { events.push('process-delete'); return { affected: 1 }; });
    await service.deleteProcess('R1', 10, 7);
    expect(events).toEqual(['route-lock', 'process-check', 'material-check', 'process-delete']);
    expect(processRepo.delete).not.toHaveBeenCalled();
  });

  it('findProcesses adds workstage and supplier names to each process', async () => {
    processRepo.find.mockResolvedValue([{ processSeq: 10, workstageCode: 'W010', subconSupplierCode: 'S1' }, { processSeq: 20, workstageCode: 'W020', subconSupplierCode: null }]);
    workstageRepo.find.mockResolvedValue([{ processCode: 'W010', processName: 'MARKING' }]);
    supplierRepo.find.mockResolvedValue([{ supplierCode: 'S1', supplierName: '외주사' }]);
    await expect(service.findProcesses('R1', 7)).resolves.toEqual([
      { processSeq: 10, workstageCode: 'W010', subconSupplierCode: 'S1', workstageName: 'MARKING', subconSupplierName: '외주사' },
      { processSeq: 20, workstageCode: 'W020', subconSupplierCode: null, workstageName: null, subconSupplierName: null },
    ]);
  });

  it('reorders processes and materials atomically with deferred named FK and fresh bind objects', async () => {
    processRepo.find.mockResolvedValue([{ processSeq: 10 }, { processSeq: 20 }]);
    await service.reorderProcesses('R1', { changes: [{ fromSeq: 10, toSeq: 20 }, { fromSeq: 20, toSeq: 10 }] }, 7);
    expect(tx.run).toHaveBeenCalledTimes(1);
    expect(manager.query.mock.calls[0][0]).toContain('FROM IP_ROUTING_GROUPS');
    expect(manager.query.mock.calls[0][0]).toContain('FOR UPDATE');
    expect(manager.query.mock.calls[1][0]).toContain('FROM IP_ROUTING_PROCESSES p');
    expect(manager.query.mock.calls[1][0]).toContain('FOR UPDATE');
    expect(manager.query.mock.calls[2][0]).toContain('FROM IP_ROUTING_MATERIALS');
    expect(manager.query.mock.calls[3][0]).toBe('SET CONSTRAINTS FK_IP_RM_PROCESS DEFERRED');
    expect(manager.query.mock.calls.filter((c: any[]) => /UPDATE IP_ROUTING_(PROCESSES|MATERIALS)/.test(c[0]))).toHaveLength(8);
    const binds = manager.query.mock.calls.filter((c: any[]) => c[1]).map((c: any[]) => c[1]);
    expect(new Set(binds.map((b: object) => b)).size).toBe(binds.length);
    expect(binds.every((b: any) => b.organizationId === 7 && b.routingCode === 'R1')).toBe(true);
  });

  it('reads reordered processes only after the transaction has completed', async () => {
    const events: string[] = [];
    tx.run.mockImplementation(async (fn: any) => { events.push('tx-start'); await fn({ manager }); events.push('tx-end'); });
    manager.query.mockImplementation(async (sql: string) => {
      if (sql.includes('FROM IP_ROUTING_GROUPS')) return [{ routingCode: 'R1' }];
      if (sql.includes('FROM IP_ROUTING_PROCESSES p')) return [{ processSeq: 10 }];
      if (sql.includes('FROM IP_ROUTING_MATERIALS')) return [];
      if (sql.startsWith('UPDATE IP_ROUTING_MATERIALS')) return 0;
      if (sql.startsWith('UPDATE')) return 1;
      return {};
    });
    processRepo.find.mockImplementation(async () => { events.push('read'); return [{ processSeq: 20 }] as any; });
    await expect(service.reorderProcesses('R1', { changes: [{ fromSeq: 10, toSeq: 20 }] }, 7)).resolves.toEqual([{ processSeq: 20, workstageName: null, subconSupplierName: null }]);
    expect(events).toEqual(['tx-start', 'tx-end', 'read']);
  });

  it('propagates a mid-reorder failure and performs no post-transaction read', async () => {
    manager.query.mockImplementation(async (sql: string) => {
      if (sql.includes('FROM IP_ROUTING_GROUPS')) return [{ routingCode: 'R1' }];
      if (sql.includes('FROM IP_ROUTING_PROCESSES p')) return [{ processSeq: 10 }, { processSeq: 20 }];
      if (sql.includes('FROM IP_ROUTING_MATERIALS')) return [];
      if (sql.startsWith('UPDATE IP_ROUTING_PROCESSES')) throw new Error('mid-update');
      if (sql.startsWith('UPDATE IP_ROUTING_MATERIALS')) return 0;
      if (sql.startsWith('UPDATE')) return 1;
      return {};
    });
    const commit = jest.fn(); const rollback = jest.fn();
    tx.run.mockImplementation(async (fn: any) => {
      try { const result = await fn({ manager }); await commit(); return result; }
      catch (error) { await rollback(); throw error; }
    });
    await expect(service.reorderProcesses('R1', { changes: [{ fromSeq: 10, toSeq: 20 }, { fromSeq: 20, toSeq: 10 }] }, 7)).rejects.toThrow('mid-update');
    expect(rollback).toHaveBeenCalledTimes(1);
    expect(commit).not.toHaveBeenCalled();
    expect(processRepo.find).not.toHaveBeenCalled();
  });

  it.each([0, 10_000_000_000])('rejects out-of-range final sequence %s before transaction', async (toSeq) => {
    await expect(service.reorderProcesses('R1', { changes: [{ fromSeq: 10, toSeq }] }, 7)).rejects.toThrow(ConflictException);
    expect(tx.run).not.toHaveBeenCalled();
  });

  it('maps concurrent integrity errors during process deletion to conflict', async () => {
    manager.findOne.mockResolvedValue({ processSeq: 10 }); manager.count.mockResolvedValue(0);
    manager.delete.mockRejectedValue(Object.assign(new Error('ORA-02292'), { code: 'ORA-02292' }));
    await expect(service.deleteProcess('R1', 10, 7)).rejects.toThrow(ConflictException);
  });

  it('maps concurrent integrity errors during reorder to conflict', async () => {
    manager.query.mockImplementation(async (sql: string) => {
      if (sql.includes('FROM IP_ROUTING_GROUPS')) return [{ routingCode: 'R1' }];
      if (sql.includes('FROM IP_ROUTING_PROCESSES p')) return [{ processSeq: 10 }];
      if (sql.includes('FROM IP_ROUTING_MATERIALS')) return [];
      throw Object.assign(new Error('ORA-00001'), { code: 'ORA-00001' });
    });
    await expect(service.reorderProcesses('R1', { changes: [{ fromSeq: 10, toSeq: 20 }] }, 7)).rejects.toThrow(ConflictException);
  });

  it('rejects incomplete reorder mappings before opening a transaction', async () => {
    await expect(service.reorderProcesses('R1', { changes: [{ fromSeq: 10, toSeq: 20 }] }, 7))
      .rejects.toThrow(ConflictException);
    expect(tx.run).toHaveBeenCalledTimes(1);
  });

  it('rolls back with conflict when a concurrent change makes an update affect the wrong row count', async () => {
    manager.query.mockImplementation(async (sql: string) => {
      if (sql.includes('FROM IP_ROUTING_GROUPS')) return [{ routingCode: 'R1' }];
      if (sql.includes('FROM IP_ROUTING_PROCESSES p')) return [{ processSeq: 10 }];
      if (sql.includes('FROM IP_ROUTING_MATERIALS')) return [{ processSeq: 10, materialCount: 1 }];
      if (sql.startsWith('UPDATE IP_ROUTING_MATERIALS')) return 0;
      if (sql.startsWith('UPDATE')) return 1;
      return {};
    });
    const rollback = jest.fn();
    tx.run.mockImplementation(async (fn: any) => { try { return await fn({ manager }); } catch (error) { rollback(); throw error; } });
    await expect(service.reorderProcesses('R1', { changes: [{ fromSeq: 10, toSeq: 20 }] }, 7)).rejects.toThrow(ConflictException);
    expect(rollback).toHaveBeenCalledTimes(1);
    expect(processRepo.find).not.toHaveBeenCalled();
  });

  describe('item routing assignment (ID_ITEM.ROUTING_CODE)', () => {
    const item = (itemCode: string, routingCode: string | null, itemDivision = 'F') => ({ itemCode, routingCode, itemDivision });
    const lock = () => manager.query.mockImplementation(async (sql: string) => (sql.includes('FOR UPDATE') ? [{ routingCode: 'R1' }] : []));

    it('sets only ROUTING_CODE on the items and never touches the legacy ROUTE_NO', async () => {
      lock();
      manager.find = jest.fn(async () => [item('A', null), item('B', 'R1')]);
      manager.update = jest.fn(async () => ({ affected: 1 }));
      manager.findOne.mockResolvedValue(null);
      itemRepo.find.mockResolvedValue([]);
      materialRepo.createQueryBuilder = jest.fn(() => ({ select: jest.fn().mockReturnThis(), addSelect: jest.fn().mockReturnThis(), where: jest.fn().mockReturnThis(), andWhere: jest.fn().mockReturnThis(), groupBy: jest.fn().mockReturnThis(), getRawMany: jest.fn(async () => []) }));
      groupRepo.findOne.mockResolvedValue({ routingCode: 'R1' });

      await service.assignItems('R1', { assign: ['A'], unassign: ['B'] }, 7);

      const changes = manager.update.mock.calls.map((call: any[]) => call[2]);
      expect(changes).toEqual([{ routingCode: 'R1' }, { routingCode: null }]);
      expect(JSON.stringify(changes)).not.toMatch(/routeNo|ROUTE_NO/);
    });

    it('rejects items that are not semi-finished or finished goods', async () => {
      lock();
      manager.find = jest.fn(async () => [item('RAW', null, 'R')]);
      manager.update = jest.fn();
      await expect(service.assignItems('R1', { assign: ['RAW'], unassign: [] }, 7)).rejects.toThrow(UnprocessableEntityException);
      expect(manager.update).not.toHaveBeenCalled();
    });

    it('rejects unknown items and the same item in both lists', async () => {
      lock();
      manager.find = jest.fn(async () => []);
      await expect(service.assignItems('R1', { assign: ['NOPE'], unassign: [] }, 7)).rejects.toThrow(NotFoundException);
      await expect(service.assignItems('R1', { assign: ['A'], unassign: ['A'] }, 7)).rejects.toThrow(ConflictException);
    });

    it('rejects removing an item that does not follow this routing', async () => {
      lock();
      manager.find = jest.fn(async () => [item('A', 'R2')]);
      manager.update = jest.fn();
      await expect(service.assignItems('R1', { assign: [], unassign: ['A'] }, 7)).rejects.toThrow('따르지 않는');
      expect(manager.update).not.toHaveBeenCalled();
    });

    it('does not move or remove an item that already has material assignments', async () => {
      lock();
      manager.find = jest.fn(async () => [item('A', 'R2'), item('B', 'R1')]);
      manager.update = jest.fn();
      manager.findOne.mockResolvedValue({ itemCode: 'A' });
      await expect(service.assignItems('R1', { assign: ['A'], unassign: [] }, 7)).rejects.toThrow('투입자재가 배정된');
      await expect(service.assignItems('R1', { assign: [], unassign: ['B'] }, 7)).rejects.toThrow('투입자재가 배정된');
      expect(manager.update).not.toHaveBeenCalled();
    });

    it('chunks item lookups and updates to Oracle-safe sizes', async () => {
      lock();
      const codes = Array.from({ length: 1001 }, (_, index) => `I${index}`);
      manager.find = jest.fn(async (_entity: any, options: any) => options.where.itemCode.value.map((code: string) => item(code, null)));
      manager.update = jest.fn(async () => ({ affected: 1 }));
      manager.findOne.mockResolvedValue(null);
      itemRepo.find.mockResolvedValue([]);
      materialRepo.createQueryBuilder = jest.fn(() => ({ select: jest.fn().mockReturnThis(), addSelect: jest.fn().mockReturnThis(), where: jest.fn().mockReturnThis(), andWhere: jest.fn().mockReturnThis(), groupBy: jest.fn().mockReturnThis(), getRawMany: jest.fn(async () => []) }));
      groupRepo.findOne.mockResolvedValue({ routingCode: 'R1' });
      await service.assignItems('R1', { assign: codes, unassign: [] }, 7);
      expect(manager.find).toHaveBeenCalledTimes(2);
      expect(manager.update).toHaveBeenCalledTimes(2);
      expect(manager.update.mock.calls.every((call: any[]) => call[1].itemCode.value.length <= 1000)).toBe(true);
    });
  });

  it('never references the legacy ROUTE_NO column or the removed group ITEM_CODE column', () => {
    const source = require('fs').readFileSync(require.resolve('./routing-group.service'), 'utf8').replace(/\/\*[\s\S]*?\*\//g, '').replace(/\/\/.*$/gm, '');
    expect(source).not.toMatch(/ROUTE_NO|routeNo/);
    expect(source).not.toMatch(/FROM IP_ROUTING_GROUPS[^`']*ITEM_CODE|ITEM_CODE AS "itemCode" FROM IP_ROUTING_GROUPS/);
  });

  describe('routing materials', () => {
    // 투입자재는 이 라우팅을 따르는 품목(상위 품목) 기준이다.
    const findOneByEntity = (process: unknown = { processSeq: 10 }, item: unknown = { itemCode: 'FG1', routingCode: 'R1' }) =>
      async (entity: { name?: string }) => (entity?.name === 'ItemMaster' ? item : process);

    beforeEach(() => {
      (itemRepo as any).manager = { findOne: jest.fn(findOneByEntity()) };
      groupRepo.findOne.mockResolvedValue({ routingCode: 'R1' });
      processRepo.findOne.mockResolvedValue({ routingCode: 'R1', processSeq: 10 });
      bomRepo.query.mockResolvedValue([{ childItemCode: 'M1', bomQty: 2 }]);
      materialRepo.find.mockResolvedValue([]);
      itemRepo.find.mockResolvedValue([{ itemCode: 'M1', itemName: 'Material 1' }]);
    });

    it('returns the union of current BOM candidates and stale assignments with bounded item lookup', async () => {
      materialRepo.find.mockResolvedValue([
        { childItemCode: 'M1', processSeq: 10, allocQty: 1, issueMethod: 'PRE_ISSUE' },
        { childItemCode: 'OLD', processSeq: 20, allocQty: 3, issueMethod: 'BACKFLUSH' },
      ]);
      itemRepo.find.mockResolvedValue([{ itemCode: 'M1', itemName: 'Material 1' }, { itemCode: 'OLD', itemName: 'Old' }]);

      const result = await service.findMaterials('R1', 10, 'FG1', 7);

      expect(materialRepo.find).toHaveBeenCalledWith({ where: { routingCode: 'R1', itemCode: 'FG1', organizationId: 7 } });
      expect(bomRepo.query.mock.calls[0][1]).toMatchObject({ parentItemCode: 'FG1', organizationId: 7 });
      expect(result).toEqual([
        expect.objectContaining({ childItemCode: 'M1', bomQty: 2, allocQty: 1, bomMatchYn: 'Y', assignedProcessSeq: 10, selectableYn: 'Y', issueMethod: 'PRE_ISSUE' }),
        expect.objectContaining({ childItemCode: 'OLD', bomQty: null, allocQty: null, bomMatchYn: 'N', mismatchReason: '현재 유효 BOM에 없음', assignedProcessSeq: 20, selectableYn: 'N', issueMethod: 'BACKFLUSH' }),
      ]);
      expect(bomRepo.query.mock.calls[0][0]).toContain('DATESET <= TRUNC(SYSDATE)');
      expect(bomRepo.query.mock.calls[0][0]).toContain('DATEEND >= TRUNC(SYSDATE)');
      expect(itemRepo.find).toHaveBeenCalledWith({ where: { organizationId: 7, itemCode: expect.anything() } });
    });

    it('rejects overlapping current BOM rows for the same child', async () => {
      bomRepo.query.mockResolvedValue([{ childItemCode: 'M1', bomQty: 2 }, { childItemCode: 'M1', bomQty: 3 }]);
      await expect(service.findMaterials('R1', 10, 'FG1', 7)).rejects.toThrow(UnprocessableEntityException);
    });

    it.each([[1000, 1], [1001, 2]])('chunks %i union item codes into %i Oracle-safe lookups', async (count, expectedCalls) => {
      bomRepo.query.mockResolvedValue([]);
      materialRepo.find.mockResolvedValue(Array.from({ length: count }, (_, index) => ({
        childItemCode: `M${index}`, processSeq: 20, allocQty: 1, issueMethod: 'BACKFLUSH',
      })));
      itemRepo.find.mockImplementation(async (options: any) => options.where.itemCode.value.map((itemCode: string) => ({ itemCode })));

      const result = await service.findMaterials('R1', 10, 'FG1', 7);

      expect(itemRepo.find).toHaveBeenCalledTimes(expectedCalls);
      expect(itemRepo.find.mock.calls.every(([options]) => (options as any).where.itemCode.value.length <= 1000)).toBe(true);
      expect(result.map((row) => row.childItemCode)).toEqual(Array.from({ length: count }, (_, index) => `M${index}`));
    });

    it('rejects materials for an item that does not follow the routing', async () => {
      (itemRepo as any).manager.findOne = jest.fn(findOneByEntity(undefined, { itemCode: 'FG1', routingCode: 'OTHER' }));
      await expect(service.findMaterials('R1', 10, 'FG1', 7)).rejects.toThrow(UnprocessableEntityException);
      manager.query.mockImplementation(async (sql: string) => (sql.includes('FOR UPDATE') ? [{ routingCode: 'R1' }] : []));
      manager.findOne.mockImplementation(findOneByEntity(undefined, { itemCode: 'FG1', routingCode: 'OTHER' }));
      await expect(service.bulkSaveMaterials('R1', 10, { itemCode: 'FG1', upserts: [{ childItemCode: 'M1', allocQty: 1 }], deletes: [] } as any, 7))
        .rejects.toThrow('따르는 품목이 아닙니다');
      expect(manager.save).not.toHaveBeenCalled();
    });

    it('rejects duplicate mutation payload before writes', async () => {
      await expect(service.bulkSaveMaterials('R1', 10, {
        itemCode: 'FG1', upserts: [{ childItemCode: 'M1', allocQty: 1 }], deletes: [{ childItemCode: 'M1' }],
      } as any, 7)).rejects.toThrow(ConflictException);
      expect(manager.delete).not.toHaveBeenCalled();
      expect(manager.save).not.toHaveBeenCalled();
    });

    it('rejects mutation or deletion of material owned by another process with its sequence', async () => {
      manager.query.mockImplementation(async (sql: string) => sql.includes('FOR UPDATE') ? [{ routingCode: 'R1' }] : []);
      manager.findOne.mockImplementation(findOneByEntity());
      manager.find = jest.fn(async () => [{ childItemCode: 'OLD', processSeq: 20 }]);
      await expect(service.bulkSaveMaterials('R1', 10, { itemCode: 'FG1', upserts: [], deletes: [{ childItemCode: 'OLD' }] } as any, 7))
        .rejects.toThrow('공정 20');
      expect(manager.delete).not.toHaveBeenCalled();
    });

    it('locks, explicitly deletes and upserts, then reads only after commit', async () => {
      const events: string[] = [];
      manager.query.mockImplementation(async (sql: string) => {
        if (sql.includes('FOR UPDATE')) { events.push('lock'); return [{ routingCode: 'R1' }]; }
        if (sql.includes('FROM ID_ENG_BOM')) return [{ childItemCode: 'M1', bomQty: 2 }];
        return [];
      });
      manager.findOne.mockImplementation(findOneByEntity());
      manager.find = jest.fn(async () => []);
      manager.delete.mockImplementation(async () => { events.push('delete'); return { affected: 1 }; });
      manager.save.mockImplementation(async () => { events.push('save'); return {}; });
      tx.run.mockImplementation(async (fn: any) => { const value = await fn({ manager }); events.push('commit'); return value; });
      const originalFind = service.findMaterials.bind(service);
      jest.spyOn(service, 'findMaterials').mockImplementation(async (...args: any[]) => { events.push('read'); return originalFind(...args as [string, number, string, number]); });

      await service.bulkSaveMaterials('R1', 10, {
        itemCode: 'FG1', upserts: [{ childItemCode: 'M1', allocQty: 1 }], deletes: [{ childItemCode: 'OLD' }],
      } as any, 7);

      expect(events.slice(0, 5)).toEqual(['lock', 'delete', 'save', 'commit', 'read']);
      // 배정은 (라우팅, 공정, 품목, 하위자재) 단위로 저장하고 지운다.
      expect(manager.delete).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({ routingCode: 'R1', processSeq: 10, itemCode: 'FG1', childItemCode: 'OLD' }));
      expect(manager.create).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({ routingCode: 'R1', processSeq: 10, itemCode: 'FG1', childItemCode: 'M1' }));
    });

    it('maps integrity races and does not perform a post-rollback read', async () => {
      manager.query.mockImplementation(async (sql: string) => sql.includes('FOR UPDATE') ? [{ routingCode: 'R1' }] : [{ childItemCode: 'M1', bomQty: 2 }]);
      manager.findOne.mockImplementation(findOneByEntity()); manager.find = jest.fn(async () => []);
      manager.save.mockRejectedValue(Object.assign(new Error('ORA-00001'), { code: 'ORA-00001' }));
      const rollback = jest.fn();
      tx.run.mockImplementation(async (fn: any) => { try { return await fn({ manager }); } catch (error) { rollback(); throw error; } });
      const read = jest.spyOn(service, 'findMaterials');
      await expect(service.bulkSaveMaterials('R1', 10, { itemCode: 'FG1', upserts: [{ childItemCode: 'M1', allocQty: 1 }], deletes: [] } as any, 7))
        .rejects.toThrow(ConflictException);
      expect(rollback).toHaveBeenCalledTimes(1);
      expect(read).not.toHaveBeenCalled();
    });

    it.each([[1000, 1], [1001, 2]])('chunks %i BOM and ownership expressions into %i Oracle-safe queries', async (count, expectedCalls) => {
      const upserts = Array.from({ length: count }, (_, index) => ({ childItemCode: `M${index}`, allocQty: 1 }));
      manager.query.mockImplementation(async (sql: string, binds: Record<string, unknown>) => {
        if (sql.includes('FOR UPDATE')) return [{ routingCode: 'R1' }];
        return Object.keys(binds).filter((key) => key.startsWith('child')).map((key) => ({ childItemCode: binds[key], bomQty: 1 }));
      });
      manager.findOne.mockImplementation(findOneByEntity());
      manager.find = jest.fn(async () => []);
      jest.spyOn(service, 'findMaterials').mockResolvedValue([]);

      await service.bulkSaveMaterials('R1', 10, { itemCode: 'FG1', upserts, deletes: [] } as any, 7);

      const bomCalls = manager.query.mock.calls.filter(([sql]: [string]) => sql.includes('FROM ID_ENG_BOM'));
      expect(bomCalls).toHaveLength(expectedCalls);
      expect(bomCalls.every(([, binds]: [string, Record<string, unknown>]) => Object.keys(binds).filter((key) => key.startsWith('child')).length <= 1000)).toBe(true);
      expect(manager.find).toHaveBeenCalledTimes(expectedCalls);
      expect(manager.find.mock.calls.every(([_, options]: any[]) => options.where.childItemCode.value.length <= 1000)).toBe(true);
    });
  });
});
