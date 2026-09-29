import { validate } from 'class-validator';
import { plainToInstance } from 'class-transformer';
import {
  OeeMultiEntryEndDto,
  OeeMultiEntryEndItemDto,
  OeeMultiEntryStartDto,
  OeeMultiEntryStatusQueryDto,
} from './oee-multi-entry.dto';

describe('OeeMultiEntryStatusQueryDto', () => {
  it('accepts the process and bounded line contract', async () => {
    const dto = Object.assign(new OeeMultiEntryStatusQueryDto(), {
      processCode: 'SMT',
      lineCode: '01',
    });

    await expect(validate(dto)).resolves.toHaveLength(0);
  });

  it('rejects client tenant fields and an overlong line code', async () => {
    const dto = Object.assign(new OeeMultiEntryStatusQueryDto(), {
      processCode: 'SMT',
      lineCode: 'x'.repeat(21),
      organizationId: 999,
      company: 'OTHER',
      plantCd: '9',
    });

    const errors = await validate(dto, {
      whitelist: true,
      forbidNonWhitelisted: true,
    });

    expect(errors.map((error) => error.property)).toEqual(
      expect.arrayContaining([
        'lineCode',
        'organizationId',
        'company',
        'plantCd',
      ]),
    );
  });
});

describe('OeeMultiEntryStartDto', () => {
  it('allows an omitted start reason and validates each line code', async () => {
    const dto = Object.assign(new OeeMultiEntryStartDto(), {
      processCode: 'ASSY',
      lineCodes: ['19', '20'],
      workerId: 'WORKER01',
      memo: 'jam',
    });

    await expect(validate(dto)).resolves.toHaveLength(0);
  });

  it('does not treat an empty optional start reason as a reason value', async () => {
    const dto = Object.assign(new OeeMultiEntryStartDto(), {
      processCode: 'SMT',
      lineCodes: ['01'],
      workerId: 'WORKER01',
      reasonCode: '',
    });

    const errors = await validate(dto);

    expect(errors.map((error) => error.property)).toContain('reasonCode');
  });

  it('rejects line and reason values beyond the live byte-sized master lengths', async () => {
    const dto = Object.assign(new OeeMultiEntryStartDto(), {
      processCode: 'SMT',
      lineCodes: ['x'.repeat(21)],
      workerId: 'WORKER01',
      reasonCode: 'x'.repeat(21),
    });

    const errors = await validate(dto);

    expect(errors.map((error) => error.property)).toEqual(
      expect.arrayContaining(['lineCodes', 'reasonCode']),
    );
  });
});

describe('OeeMultiEntryEndDto', () => {
  it('requires a non-empty reason and positive dtSeq items', async () => {
    const valid = Object.assign(new OeeMultiEntryEndDto(), {
      processCode: 'SMT',
      items: [
        Object.assign(new OeeMultiEntryEndItemDto(), {
          lineCode: '01',
          dtSeq: 10,
        }),
      ],
      reasonCode: 'END_REASON',
    });

    await expect(validate(valid)).resolves.toHaveLength(0);

    const invalid = Object.assign(new OeeMultiEntryEndDto(), {
      processCode: 'SMT',
      items: [
        Object.assign(new OeeMultiEntryEndItemDto(), {
          lineCode: '01',
          dtSeq: 0,
        }),
      ],
      reasonCode: 'x'.repeat(21),
    });
    const errors = await validate(invalid);

    expect(errors.map((error) => error.property)).toEqual(
      expect.arrayContaining(['items', 'reasonCode']),
    );
  });

  it('accepts multiple distinct dtSeq items for one line', async () => {
    const dto = Object.assign(new OeeMultiEntryEndDto(), {
      processCode: 'SMT',
      items: [
        Object.assign(new OeeMultiEntryEndItemDto(), {
          lineCode: '03',
          dtSeq: 801,
        }),
        Object.assign(new OeeMultiEntryEndItemDto(), {
          lineCode: '03',
          dtSeq: 802,
        }),
      ],
      reasonCode: 'END_REASON',
    });

    await expect(validate(dto)).resolves.toHaveLength(0);
  });

  it('does not let implicit conversion turn a boolean dtSeq into an integer', async () => {
    const dto = plainToInstance(
      OeeMultiEntryEndDto,
      {
        processCode: 'SMT',
        items: [{ lineCode: '03', dtSeq: true }],
      },
      { enableImplicitConversion: true },
    );

    expect(dto.items[0]?.dtSeq).toBe(true);
    expect((await validate(dto)).map((error) => error.property)).toContain(
      'items',
    );
  });

  it('allows omitted reason but rejects explicit null, blank, and non-string values', async () => {
    const base = {
      processCode: 'SMT',
      items: [
        Object.assign(new OeeMultiEntryEndItemDto(), {
          lineCode: '03',
          dtSeq: 801,
        }),
      ],
    };

    await expect(
      validate(Object.assign(new OeeMultiEntryEndDto(), base)),
    ).resolves.toHaveLength(0);

    for (const reasonCode of [null, '', 123]) {
      const errors = await validate(
        Object.assign(new OeeMultiEntryEndDto(), base, { reasonCode }),
      );
      expect(errors.map((error) => error.property)).toContain('reasonCode');
    }
  });

  it('does not let implicit conversion turn a non-string reason into a valid string', async () => {
    const dto = plainToInstance(
      OeeMultiEntryEndDto,
      {
        processCode: 'SMT',
        items: [{ lineCode: '03', dtSeq: 801 }],
        reasonCode: 123,
      },
      { enableImplicitConversion: true },
    );

    expect(dto.reasonCode).toBe(123);
    expect((await validate(dto)).map((error) => error.property)).toContain(
      'reasonCode',
    );
  });
});
