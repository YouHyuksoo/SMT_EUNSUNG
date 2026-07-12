import { ConflictException, NotFoundException } from '@nestjs/common';
import { RoutingGroupService } from './routing-group.service';
import { plainToInstance } from 'class-transformer';
import { validateSync } from 'class-validator';
import { ReorderRoutingProcessChangeDto } from '../dto/routing-group.dto';

describe('RoutingGroupService group/process rules', () => {
  it.each([0, 10_000_000_000])('DTO rejects sequence outside NUMBER(10) positive range: %s', (seq) => {
    const dto = plainToInstance(ReorderRoutingProcessChangeDto, { fromSeq: seq, toSeq: seq });
    expect(validateSync(dto)).not.toHaveLength(0);
  });
  const repo = () => ({ findOne: jest.fn(), find: jest.fn(), count: jest.fn(), create: jest.fn((v) => v), save: jest.fn(async (v) => v), update: jest.fn(), delete: jest.fn(), createQueryBuilder: jest.fn() });
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
    manager = { query: jest.fn(), update: jest.fn(), delete: jest.fn() };
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
    processRepo.findOne.mockResolvedValue(null);
    workstageRepo.findOne.mockResolvedValue({ processCode: 'W1' });
    await service.createProcess('R1', { seq: 10, workstageCode: 'W1', executionType: 'INTERNAL', subconSupplierCode: 'IGNORED' }, 7);
    expect(processRepo.create).toHaveBeenCalledWith(expect.objectContaining({
      routingCode: 'R1', processSeq: 10, workstageCode: 'W1', executionType: 'INTERNAL', subconSupplierCode: null,
    }));
  });

  it('rejects process deletion when materials exist', async () => {
    processRepo.findOne.mockResolvedValue({ routingCode: 'R1', processSeq: 10 });
    materialRepo.count.mockResolvedValue(1);
    await expect(service.deleteProcess('R1', 10, 7)).rejects.toThrow(ConflictException);
  });

  it('reorders processes and materials atomically with deferred named FK and fresh bind objects', async () => {
    processRepo.find.mockResolvedValue([{ processSeq: 10 }, { processSeq: 20 }]);
    manager.query.mockResolvedValue({});
    await service.reorderProcesses('R1', { changes: [{ fromSeq: 10, toSeq: 20 }, { fromSeq: 20, toSeq: 10 }] }, 7);
    expect(tx.run).toHaveBeenCalledTimes(1);
    expect(manager.query.mock.calls[0][0]).toBe('SET CONSTRAINTS FK_IP_RM_PROCESS DEFERRED');
    expect(manager.query.mock.calls.filter((c: any[]) => /UPDATE IP_ROUTING_(PROCESSES|MATERIALS)/.test(c[0]))).toHaveLength(8);
    const binds = manager.query.mock.calls.slice(1).map((c: any[]) => c[1]);
    expect(new Set(binds.map((b: object) => b)).size).toBe(binds.length);
    expect(binds.every((b: any) => b.organizationId === 7 && b.routingCode === 'R1')).toBe(true);
  });

  it('reads reordered processes only after the transaction has completed', async () => {
    const events: string[] = [];
    tx.run.mockImplementation(async (fn: any) => { events.push('tx-start'); await fn({ manager }); events.push('tx-end'); });
    processRepo.find.mockImplementationOnce(async () => [{ processSeq: 10 }] as any).mockImplementationOnce(async () => { events.push('read'); return [{ processSeq: 20 }] as any; });
    await expect(service.reorderProcesses('R1', { changes: [{ fromSeq: 10, toSeq: 20 }] }, 7)).resolves.toEqual([{ processSeq: 20 }]);
    expect(events).toEqual(['tx-start', 'tx-end', 'read']);
  });

  it('propagates a mid-reorder failure and performs no post-transaction read', async () => {
    processRepo.find.mockResolvedValue([{ processSeq: 10 }, { processSeq: 20 }]);
    manager.query.mockResolvedValueOnce({}).mockResolvedValueOnce({}).mockRejectedValueOnce(new Error('mid-update'));
    const commit = jest.fn(); const rollback = jest.fn();
    tx.run.mockImplementation(async (fn: any) => {
      try { const result = await fn({ manager }); await commit(); return result; }
      catch (error) { await rollback(); throw error; }
    });
    await expect(service.reorderProcesses('R1', { changes: [{ fromSeq: 10, toSeq: 20 }, { fromSeq: 20, toSeq: 10 }] }, 7)).rejects.toThrow('mid-update');
    expect(rollback).toHaveBeenCalledTimes(1);
    expect(commit).not.toHaveBeenCalled();
    expect(processRepo.find).toHaveBeenCalledTimes(1);
  });

  it.each([0, 10_000_000_000])('rejects out-of-range final sequence %s before transaction', async (toSeq) => {
    processRepo.find.mockResolvedValue([{ processSeq: 10 }]);
    await expect(service.reorderProcesses('R1', { changes: [{ fromSeq: 10, toSeq }] }, 7)).rejects.toThrow(ConflictException);
    expect(tx.run).not.toHaveBeenCalled();
  });

  it('maps concurrent integrity errors during process deletion to conflict', async () => {
    processRepo.findOne.mockResolvedValue({ processSeq: 10 }); materialRepo.count.mockResolvedValue(0);
    processRepo.delete.mockRejectedValue(Object.assign(new Error('ORA-02292'), { code: 'ORA-02292' }));
    await expect(service.deleteProcess('R1', 10, 7)).rejects.toThrow(ConflictException);
  });

  it('maps concurrent integrity errors during reorder to conflict', async () => {
    processRepo.find.mockResolvedValue([{ processSeq: 10 }]);
    manager.query.mockResolvedValueOnce({}).mockRejectedValueOnce(Object.assign(new Error('ORA-00001'), { code: 'ORA-00001' }));
    await expect(service.reorderProcesses('R1', { changes: [{ fromSeq: 10, toSeq: 20 }] }, 7)).rejects.toThrow(ConflictException);
  });

  it('rejects incomplete reorder mappings before opening a transaction', async () => {
    processRepo.find.mockResolvedValue([{ processSeq: 10 }, { processSeq: 20 }]);
    await expect(service.reorderProcesses('R1', { changes: [{ fromSeq: 10, toSeq: 20 }] }, 7))
      .rejects.toThrow(ConflictException);
    expect(tx.run).not.toHaveBeenCalled();
  });
});
