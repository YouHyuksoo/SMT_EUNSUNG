import { validate } from 'class-validator';
import {
  OeeMobileEndDowntimeDto,
  OeeMobileReasonsQueryDto,
  OeeMobileResourcesQueryDto,
  OeeMobileStartDowntimeDto,
  OeeMobileStatusQueryDto,
} from './oee-mobile.dto';

describe('OeeMobileResourcesQueryDto', () => {
  it.each(['SMT', 'ASSY'])('accepts processCode=%s', async (processCode) => {
    const dto = Object.assign(new OeeMobileResourcesQueryDto(), { processCode });

    await expect(validate(dto)).resolves.toHaveLength(0);
  });

  it('rejects unsupported process codes', async () => {
    const dto = Object.assign(new OeeMobileResourcesQueryDto(), { processCode: 'PROCESS_X' });

    const errors = await validate(dto);

    expect(errors.map((error) => error.property)).toContain('processCode');
  });

  it('does not allow tenant fields in the query contract', async () => {
    const dto = Object.assign(new OeeMobileResourcesQueryDto(), {
      processCode: 'SMT',
      organizationId: 999,
      company: 'OTHER',
      plantCd: '9',
    });

    const errors = await validate(dto, { whitelist: true, forbidNonWhitelisted: true });

    expect(errors.map((error) => error.property)).toEqual(
      expect.arrayContaining(['organizationId', 'company', 'plantCd']),
    );
  });
});

describe('OeeMobileStartDowntimeDto', () => {
  it('accepts the server-owned mobile start command fields', async () => {
    const dto = Object.assign(new OeeMobileStartDowntimeDto(), {
      processCode: 'SMT',
      resourceType: 'LINE',
      resourceCode: '01',
      parentLineCode: '01',
      workerId: 'WORKER01',
      reasonCode: 'MACHINE_STOP',
      memo: '',
      requestId: 'start-request-1',
    });

    await expect(validate(dto)).resolves.toHaveLength(0);
  });

  it('rejects invalid lengths, enums, event-owned fields, and tenant fields', async () => {
    const dto = Object.assign(new OeeMobileStartDowntimeDto(), {
      processCode: 'PROCESS_X',
      resourceType: 'CELL',
      resourceCode: 'x'.repeat(51),
      parentLineCode: 'x'.repeat(51),
      workerId: 'x'.repeat(21),
      reasonCode: 'x'.repeat(101),
      memo: 'x'.repeat(501),
      requestId: '',
      organizationId: 999,
      startTime: new Date(),
      workDate: '2026-08-07',
      workSegment: 'A',
    });

    const errors = await validate(dto, { whitelist: true, forbidNonWhitelisted: true });

    expect(errors.map((error) => error.property)).toEqual(
      expect.arrayContaining([
        'processCode',
        'resourceType',
        'resourceCode',
        'parentLineCode',
        'workerId',
        'reasonCode',
        'memo',
        'requestId',
        'organizationId',
        'startTime',
        'workDate',
        'workSegment',
      ]),
    );
  });
});

describe('OeeMobileEndDowntimeDto', () => {
  it('requires a positive event id and bounded request id', async () => {
    const invalid = Object.assign(new OeeMobileEndDowntimeDto(), {
      eventId: 0,
      requestId: 'x'.repeat(65),
    });

    const errors = await validate(invalid);

    expect(errors.map((error) => error.property)).toEqual(
      expect.arrayContaining(['eventId', 'requestId']),
    );
  });
});

describe('OeeMobileReasonsQueryDto', () => {
  it('has no client tenant fields', async () => {
    const dto = Object.assign(new OeeMobileReasonsQueryDto(), { organizationId: 99 });

    const errors = await validate(dto, { whitelist: true, forbidNonWhitelisted: true });

    expect(errors.map((error) => error.property)).toContain('organizationId');
  });
});

describe('OeeMobileStatusQueryDto', () => {
  it('accepts the resource-scoped status contract', async () => {
    const dto = Object.assign(new OeeMobileStatusQueryDto(), {
      processCode: 'ASSY',
      resourceType: 'LINE',
      resourceCode: '19',
      parentLineCode: '19',
    });

    await expect(validate(dto)).resolves.toHaveLength(0);
  });

  it('rejects CELL resources from the line-only status contract', async () => {
    const dto = Object.assign(new OeeMobileStatusQueryDto(), {
      processCode: 'ASSY',
      resourceType: 'CELL',
      resourceCode: '50',
      parentLineCode: '50',
    });

    const errors = await validate(dto);

    expect(errors.map((error) => error.property)).toContain('resourceType');
  });
});
