import { RequestMethod } from '@nestjs/common';
import { GUARDS_METADATA, METHOD_METADATA, PATH_METADATA } from '@nestjs/common/constants';
import { plainToInstance } from 'class-transformer';
import { validate } from 'class-validator';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import {
  BulkSaveRoutingMaterialDto,
  CreateRoutingGroupDto,
  CreateRoutingProcessDto,
  ReorderRoutingProcessesDto,
  UpdateRoutingGroupDto,
  UpdateRoutingProcessDto,
} from '../dto/routing-group.dto';
import { RoutingGroupController } from './routing-group.controller';

const route = (methodName: keyof RoutingGroupController) => {
  const handler = RoutingGroupController.prototype[methodName];
  return {
    path: Reflect.getMetadata(PATH_METADATA, handler),
    method: Reflect.getMetadata(METHOD_METADATA, handler),
  };
};

describe('RoutingGroupController contract', () => {
  it('protects the controller with JwtAuthGuard', () => {
    const guards = Reflect.getMetadata(GUARDS_METADATA, RoutingGroupController) ?? [];
    expect(guards).toContain(JwtAuthGuard);
  });

  it('exposes process reorder and material patch routes without legacy bulk/conditions routes', () => {
    expect(route('reorderProcesses')).toEqual({ path: ':code/process-order', method: RequestMethod.PUT });
    expect(route('saveMaterials')).toEqual({ path: ':code/processes/:seq/materials', method: RequestMethod.PUT });

    const methods = Object.getOwnPropertyNames(RoutingGroupController.prototype);
    expect(methods).not.toContain('findByItem');
    expect(methods).not.toContain('findConditions');
    expect(methods).not.toContain('bulkSave');
  });
});

describe('routing DTO validation', () => {
  const errors = (type: new () => object, value: object) => validate(plainToInstance(type, value));

  it('requires an ID_ITEM item code and exact Y/N values for a group', async () => {
    expect(await errors(CreateRoutingGroupDto, { routingCode: 'R1', routingName: 'R', useYn: 'YES' })).not.toHaveLength(0);
    expect(await errors(CreateRoutingGroupDto, { routingCode: 'R1', routingName: 'R', itemCode: 'ITEM1', useYn: 'Y' })).toHaveLength(0);
  });

  it('does not allow routingCode to be updated', () => {
    expect('routingCode' in new UpdateRoutingGroupDto()).toBe(false);
  });

  it('accepts only positive seq, nonnegative times, exact execution type, and Y/N flags', async () => {
    const valid = { seq: 10, workstageCode: 'SMT', executionType: 'INTERNAL', standardTime: 0, setupTime: 0, jobOrderYn: 'Y', useYn: 'N' };
    expect(await errors(CreateRoutingProcessDto, valid)).toHaveLength(0);
    for (const invalid of [
      { ...valid, seq: 0 }, { ...valid, standardTime: -1 }, { ...valid, setupTime: -1 },
      { ...valid, executionType: 'IN_HOUSE' }, { ...valid, jobOrderYn: 'YES' },
    ]) expect(await errors(CreateRoutingProcessDto, invalid)).not.toHaveLength(0);
  });

  it('does not allow ordinary process update to change seq', () => {
    expect('seq' in new UpdateRoutingProcessDto()).toBe(false);
    expect(Object.keys(new CreateRoutingProcessDto())).not.toEqual(expect.arrayContaining([
      'organizationId', 'sampleInspectYn', 'issueLabelType', 'qcSelfYn', 'inspectMethod', 'destructiveYn',
    ]));
  });

  it('validates reorder changes as positive integer pairs', async () => {
    expect(await errors(ReorderRoutingProcessesDto, { changes: [{ fromSeq: 10, toSeq: 20 }] })).toHaveLength(0);
    expect(await errors(ReorderRoutingProcessesDto, { changes: [{ fromSeq: 0, toSeq: 20 }] })).not.toHaveLength(0);
  });

  it('validates material upserts/deletes, positive allocQty, and exact issue method', async () => {
    expect(await errors(BulkSaveRoutingMaterialDto, {
      upserts: [{ childItemCode: 'CHILD', allocQty: 0.1, issueMethod: 'BACKFLUSH' }],
      deletes: [{ childItemCode: 'OLD' }],
    })).toHaveLength(0);
    expect(await errors(BulkSaveRoutingMaterialDto, {
      upserts: [{ childItemCode: 'CHILD', allocQty: 0, issueMethod: 'ISSUE' }], deletes: [],
    })).not.toHaveLength(0);
    expect('circuitId' in new BulkSaveRoutingMaterialDto()).toBe(false);
  });
});
