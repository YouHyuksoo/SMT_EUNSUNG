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
  const repo = () => ({ findOne: jest.fn(), find: jest.fn(), query: jest.fn(), count: jest.fn(), create: jest.fn((v) => v), save: jest.fn(async (v) => v), update: jest.fn(), delete: jest.fn(), createQueryBuilder: jest.fn() });
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

  it('rejects a group whose item is outside the request organization', async () => {
    itemRepo.findOne.mockResolvedValue(null);
    await expect(service.createGroup({ routingCode: 'R1', itemCode: 'I1', routingName: 'R' }, 7))
      .rejects.toThrow(NotFoundException);
    expect(itemRepo.findOne).toHaveBeenCalledWith({ where: { itemCode: 'I1', organizationId: 7 } });
  });

  it('rejects a second active routing for the same item', async () => {
    itemRepo.findOne.mockResolvedValue({ itemCode: 'I1' });
    groupRepo.findOne.mockResolvedValueOnce(null).mockResolvedValueOnce({ routingCode: 'OTHER' });
    await expect(service.createGroup({ routingCode: 'R1', itemCode: 'I1', routingName: 'R' }, 7))
      .rejects.toThrow(ConflictException);
  });

  it('maps ORA-00001 during group save to conflict', async () => {
    itemRepo.findOne.mockResolvedValue({ itemCode: 'I1' });
    groupRepo.findOne.mockResolvedValue(null);
    groupRepo.save.mockRejectedValue(Object.assign(new Error('ORA-00001: unique constraint'), { code: 'ORA-00001' }));
    await expect(service.createGroup({ routingCode: 'R1', itemCode: 'I1', routingName: 'R' }, 7))
      .rejects.toThrow(ConflictException);
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
    await expect(service.reorderProcesses('R1', { changes: [{ fromSeq: 10, toSeq: 20 }] }, 7)).resolves.toEqual([{ processSeq: 20 }]);
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

  describe('routing materials', () => {
    beforeEach(() => {
      groupRepo.findOne.mockResolvedValue({ routingCode: 'R1', itemCode: 'FG1' });
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

      const result = await service.findMaterials('R1', 10, 7);

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
      await expect(service.findMaterials('R1', 10, 7)).rejects.toThrow(UnprocessableEntityException);
    });

    it('rejects duplicate mutation payload before writes', async () => {
      await expect(service.bulkSaveMaterials('R1', 10, {
        upserts: [{ childItemCode: 'M1', allocQty: 1 }], deletes: [{ childItemCode: 'M1' }],
      } as any, 7)).rejects.toThrow(ConflictException);
      expect(manager.delete).not.toHaveBeenCalled();
      expect(manager.save).not.toHaveBeenCalled();
    });

    it('rejects mutation or deletion of material owned by another process with its sequence', async () => {
      manager.query.mockImplementation(async (sql: string) => sql.includes('FOR UPDATE') ? [{ routingCode: 'R1' }] : []);
      manager.findOne.mockResolvedValue({ processSeq: 10 });
      manager.find = jest.fn(async () => [{ childItemCode: 'OLD', processSeq: 20 }]);
      await expect(service.bulkSaveMaterials('R1', 10, { upserts: [], deletes: [{ childItemCode: 'OLD' }] } as any, 7))
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
      manager.findOne.mockResolvedValue({ processSeq: 10 });
      manager.find = jest.fn(async () => []);
      manager.delete.mockImplementation(async () => { events.push('delete'); return { affected: 1 }; });
      manager.save.mockImplementation(async () => { events.push('save'); return {}; });
      tx.run.mockImplementation(async (fn: any) => { const value = await fn({ manager }); events.push('commit'); return value; });
      const originalFind = service.findMaterials.bind(service);
      jest.spyOn(service, 'findMaterials').mockImplementation(async (...args: any[]) => { events.push('read'); return originalFind(...args as [string, number, number]); });

      await service.bulkSaveMaterials('R1', 10, {
        upserts: [{ childItemCode: 'M1', allocQty: 1 }], deletes: [{ childItemCode: 'OLD' }],
      } as any, 7);

      expect(events.slice(0, 5)).toEqual(['lock', 'delete', 'save', 'commit', 'read']);
    });

    it('maps integrity races and does not perform a post-rollback read', async () => {
      manager.query.mockImplementation(async (sql: string) => sql.includes('FOR UPDATE') ? [{ routingCode: 'R1' }] : [{ childItemCode: 'M1', bomQty: 2 }]);
      manager.findOne.mockResolvedValue({ processSeq: 10 }); manager.find = jest.fn(async () => []);
      manager.save.mockRejectedValue(Object.assign(new Error('ORA-00001'), { code: 'ORA-00001' }));
      const rollback = jest.fn();
      tx.run.mockImplementation(async (fn: any) => { try { return await fn({ manager }); } catch (error) { rollback(); throw error; } });
      const read = jest.spyOn(service, 'findMaterials');
      await expect(service.bulkSaveMaterials('R1', 10, { upserts: [{ childItemCode: 'M1', allocQty: 1 }], deletes: [] } as any, 7))
        .rejects.toThrow(ConflictException);
      expect(rollback).toHaveBeenCalledTimes(1);
      expect(read).not.toHaveBeenCalled();
    });
  });
});
