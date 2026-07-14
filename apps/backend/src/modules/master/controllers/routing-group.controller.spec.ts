import { RequestMethod, ValidationPipe } from '@nestjs/common';
import { GUARDS_METADATA, METHOD_METADATA, PATH_METADATA } from '@nestjs/common/constants';
import { plainToInstance } from 'class-transformer';
import { getMetadataStorage, validate } from 'class-validator';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import {
  BulkSaveRoutingMaterialDto,
  CreateRoutingGroupDto,
  CreateRoutingProcessDto,
  ReorderRoutingProcessesDto,
  RoutingMaterialUpsertDto,
  UpdateRoutingGroupDto,
  UpdateRoutingProcessDto,
} from '../dto/routing-group.dto';
import { RoutingGroupController } from './routing-group.controller';

const controllerRoutes = () => {
  const prototype = RoutingGroupController.prototype;
  return Object.getOwnPropertyNames(prototype)
    .filter((name) => name !== 'constructor')
    .map((name) => {
      const handler = prototype[name as keyof RoutingGroupController];
      return {
        method: Reflect.getMetadata(METHOD_METADATA, handler) as RequestMethod | undefined,
        path: Reflect.getMetadata(PATH_METADATA, handler) as string | undefined,
      };
    })
    .filter((route) => route.method !== undefined && route.path !== undefined)
    .map((route) => `${RequestMethod[route.method!]} ${route.path}`)
    .sort();
};

const validatedProperties = (type: new () => object) => new Set(
  getMetadataStorage().getTargetValidationMetadatas(type, '', true, false)
    .map((metadata) => metadata.propertyName),
);

describe('RoutingGroupController contract', () => {
  it('protects the controller with JwtAuthGuard', () => {
    const guards = Reflect.getMetadata(GUARDS_METADATA, RoutingGroupController) ?? [];
    expect(guards).toContain(JwtAuthGuard);
  });

  it('exposes exactly the approved routing API paths', () => {
    expect(controllerRoutes()).toEqual([
      'DELETE :code',
      'DELETE :code/processes/:seq',
      'GET /',
      'GET :code',
      'GET :code/processes',
      'GET :code/processes/:seq/materials',
      'POST /',
      'POST :code/processes',
      'PUT :code',
      'PUT :code/process-order',
      'PUT :code/processes/:seq',
      'PUT :code/processes/:seq/materials',
    ].sort());

    expect(controllerRoutes().some((route) => route.includes('by-item'))).toBe(false);
    expect(controllerRoutes().some((route) => route.includes('conditions'))).toBe(false);
    expect(controllerRoutes().some((route) => route.endsWith('/materials/bulk'))).toBe(false);
  });
});

describe('routing DTO validation', () => {
  const errors = (type: new () => object, value: object) => validate(plainToInstance(type, value));
  const pipe = new ValidationPipe({ transform: true, whitelist: true });
  const throughPipe = (type: new () => object, value: object) => pipe.transform(value, {
    type: 'body', metatype: type,
  });

  it('accepts numeric strings but rejects boolean, empty string, and null numeric inputs', async () => {
    await expect(throughPipe(CreateRoutingProcessDto, {
      seq: '10', workstageCode: 'SMT', standardTime: '0', setupTime: '1.5',
    })).resolves.toMatchObject({ seq: 10, standardTime: 0, setupTime: 1.5 });

    for (const value of [true, '', null]) {
      await expect(throughPipe(CreateRoutingProcessDto, { seq: value, workstageCode: 'SMT' })).rejects.toThrow();
      await expect(throughPipe(CreateRoutingProcessDto, { seq: 1, workstageCode: 'SMT', standardTime: value })).rejects.toThrow();
      await expect(throughPipe(ReorderRoutingProcessesDto, { changes: [{ fromSeq: value, toSeq: 2 }] })).rejects.toThrow();
      await expect(throughPipe(BulkSaveRoutingMaterialDto, {
        upserts: [{ childItemCode: 'C', allocQty: value }], deletes: [],
      })).rejects.toThrow();
    }
  });

  it('rejects empty and whitespace-only required identifiers and names', async () => {
    for (const field of ['routingCode', 'itemCode', 'routingName'] as const) {
      await expect(throughPipe(CreateRoutingGroupDto, {
        routingCode: 'R', itemCode: 'I', routingName: 'Name', [field]: '   ',
      })).rejects.toThrow();
    }
    await expect(throughPipe(CreateRoutingProcessDto, { seq: 1, workstageCode: '   ' })).rejects.toThrow();
    await expect(throughPipe(BulkSaveRoutingMaterialDto, {
      upserts: [{ childItemCode: '   ', allocQty: 1 }], deletes: [],
    })).rejects.toThrow();
  });

  it('requires an ID_ITEM item code and exact Y/N values for a group', async () => {
    expect(await errors(CreateRoutingGroupDto, { routingCode: 'R1', routingName: 'R', useYn: 'YES' })).not.toHaveLength(0);
    expect(await errors(CreateRoutingGroupDto, { routingCode: 'R1', routingName: 'R', itemCode: 'ITEM1', useYn: 'Y' })).toHaveLength(0);
  });

  it('does not allow routingCode to be updated', () => {
    const properties = validatedProperties(UpdateRoutingGroupDto);
    expect(properties).not.toContain('routingCode');
    expect(properties).not.toContain('itemCode');
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
    const properties = validatedProperties(UpdateRoutingProcessDto);
    expect(properties).not.toContain('seq');
    for (const excluded of [
      'organizationId', 'sampleInspectYn', 'issueLabelType', 'qcSelfYn', 'inspectMethod',
      'destructiveYn', 'sampleQty', 'circuitId',
    ]) expect(properties).not.toContain(excluded);
  });

  it('allows omitted update times but rejects null update times', async () => {
    await expect(throughPipe(UpdateRoutingProcessDto, { workstageCode: 'SMT' }))
      .resolves.toMatchObject({ workstageCode: 'SMT' });
    await expect(throughPipe(UpdateRoutingProcessDto, { standardTime: null })).rejects.toThrow();
    await expect(throughPipe(UpdateRoutingProcessDto, { setupTime: null })).rejects.toThrow();
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
    expect(validatedProperties(RoutingMaterialUpsertDto)).not.toContain('circuitId');
  });
});
