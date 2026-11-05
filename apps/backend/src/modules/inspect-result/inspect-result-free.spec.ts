import 'reflect-metadata';
import { GUARDS_METADATA } from '@nestjs/common/constants';
import { BadRequestException, NotFoundException } from '@nestjs/common';
import { IS_PUBLIC_KEY } from '../../common/decorators/public.decorator';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { InspectResultFreeController } from './inspect-result-free.controller';
import { FREE_INSPECT_RUN_MARK, InspectResultFreeService } from './inspect-result-free.service';
import type { FreeInspectCreateDto } from './inspect-result-free.dto';
import type { InspectResultService } from './inspect-result.service';

const dto: FreeInspectCreateDto = {
  lineCode: 'L2', machineCode: 'ES-Q01', modelName: 'MODEL-A', itemCode: 'ITEM-A',
  inspectResult: 'P', inspectQty: 10, inspectorName: '홍길동',
};

function build(queryImpl: (sql: string, params?: unknown[]) => unknown) {
  const query = jest.fn(async (sql: string, params?: unknown[]) => queryImpl(sql, params));
  const manager = { query, transaction: async (fn: (m: { query: typeof query }) => unknown) => fn({ query }) };
  const create = jest.fn().mockResolvedValue({ runNo: 'R1', seqNo: 1 });
  const cancel = jest.fn().mockResolvedValue({ cancelled: true });
  const service = new InspectResultFreeService(
    { manager } as never,
    { create, cancel } as unknown as InspectResultService,
  );
  return { service, query, create, cancel };
}

describe('InspectResultFreeController', () => {
  it('requires JwtAuthGuard and is not public', () => {
    expect(Reflect.getMetadata(IS_PUBLIC_KEY, InspectResultFreeController)).toBeFalsy();
    expect(Reflect.getMetadata(GUARDS_METADATA, InspectResultFreeController) ?? []).toContain(JwtAuthGuard);
  });
});

describe('InspectResultFreeService', () => {
  it('rejects a machine that is not an inspection (Q) process before creating any run card', async () => {
    const { service, query, create } = build((sql) => (sql.includes('FROM IMCN_MACHINE') ? [{ workstageCode: 'W1', stageType: 'A' }] : []));
    await expect(service.createResult(dto, 7)).rejects.toBeInstanceOf(BadRequestException);
    expect(create).not.toHaveBeenCalled();
    expect(query.mock.calls.some((c) => String(c[0]).includes('INSERT INTO IP_PRODUCT_RUN_CARD'))).toBe(false);
  });

  it('rejects an unknown machine', async () => {
    const { service } = build(() => []);
    await expect(service.createResult(dto, 7)).rejects.toBeInstanceOf(NotFoundException);
  });

  it('creates the run card once, saves through InspectResultService and syncs the plan quantity', async () => {
    const { service, query, create } = build((sql) => {
      if (sql.includes('FROM IMCN_MACHINE')) return [{ workstageCode: 'WQ', stageType: 'Q' }];
      if (sql.includes('FROM IP_PRODUCT_MODEL_MASTER')) return [{ revision: '01' }];
      if (sql.includes('SELECT MIN(RUN_NO)')) return [{ runNo: null }];
      if (sql.includes('F_GET_NEW_RUN_NO')) return [{ runNo: 'R1' }];
      return [];
    });
    const res = await service.createResult(dto, 7, 'u1');
    expect(res).toEqual({ runNo: 'R1', seqNo: 1 });
    const insert = query.mock.calls.find((c) => String(c[0]).includes('INSERT INTO IP_PRODUCT_RUN_CARD'));
    expect(insert?.[1]).toContain(FREE_INSPECT_RUN_MARK);
    expect(insert?.[1]).toContain('WQ');
    expect(create).toHaveBeenCalledWith(expect.objectContaining({ runNo: 'R1', machineCode: 'ES-Q01', inspectQty: 10 }), 7, 'u1');
    expect(query.mock.calls.some((c) => String(c[0]).includes('UPDATE IP_PRODUCT_RUN_CARD'))).toBe(true);
  });

  it('removes the empty run card it just created when the inspection save fails', async () => {
    const { service, query, create } = build((sql) => {
      if (sql.includes('FROM IMCN_MACHINE')) return [{ workstageCode: 'WQ', stageType: 'Q' }];
      if (sql.includes('FROM IP_PRODUCT_MODEL_MASTER')) return [{ revision: '01' }];
      if (sql.includes('SELECT MIN(RUN_NO)')) return [{ runNo: null }];
      if (sql.includes('F_GET_NEW_RUN_NO')) return [{ runNo: 'R1' }];
      return [];
    });
    create.mockRejectedValueOnce(new BadRequestException('불합격은 불량원인을 골라야 합니다'));
    await expect(service.createResult({ ...dto, inspectResult: 'R' }, 7)).rejects.toBeInstanceOf(BadRequestException);
    expect(query.mock.calls.some((c) => String(c[0]).includes('DELETE FROM IP_PRODUCT_RUN_CARD'))).toBe(true);
  });

  it('only cancels results of runs created by this screen', async () => {
    const { service, cancel } = build(() => []);
    await expect(service.cancelResult({ runNo: 'R9', seqNo: 1 }, 7)).rejects.toBeInstanceOf(NotFoundException);
    expect(cancel).not.toHaveBeenCalled();
  });
});
