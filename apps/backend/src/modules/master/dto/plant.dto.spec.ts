import { validate } from 'class-validator';
import { CreatePlantDto, UpdatePlantDto } from './plant.dto';

describe('Plant DTO tenant and identifier boundaries', () => {
  it('rejects tenant fields on create and identifier fields on update', async () => {
    const create = Object.assign(new CreatePlantDto(), {
      plantCode: 'EUNSUNG',
      plantName: '공장',
      company: 'OTHER',
      plantCd: '9',
    });
    const update = Object.assign(new UpdatePlantDto(), {
      plantName: '수정',
      company: 'OTHER',
      plantCode: 'OTHER',
      cellCode: '99',
    });

    const [createErrors, updateErrors] = await Promise.all([
      validate(create, { whitelist: true, forbidNonWhitelisted: true }),
      validate(update, { whitelist: true, forbidNonWhitelisted: true }),
    ]);

    expect(createErrors.map((error) => error.property)).toEqual(expect.arrayContaining(['company', 'plantCd']));
    expect(updateErrors.map((error) => error.property)).toEqual(
      expect.arrayContaining(['company', 'plantCode', 'cellCode']),
    );
  });

  it('rejects blank required names and hierarchy keys', async () => {
    const create = Object.assign(new CreatePlantDto(), {
      plantCode: ' ',
      shopCode: ' ',
      lineCode: ' ',
      cellCode: ' ',
      plantName: ' ',
    });
    const update = Object.assign(new UpdatePlantDto(), { plantName: ' ' });

    const [createErrors, updateErrors] = await Promise.all([
      validate(create),
      validate(update),
    ]);

    expect(createErrors.map((error) => error.property)).toEqual(
      expect.arrayContaining(['plantCode', 'shopCode', 'lineCode', 'cellCode', 'plantName']),
    );
    expect(updateErrors.map((error) => error.property)).toContain('plantName');
  });

  it('rejects an empty update body', async () => {
    const errors = await validate(new UpdatePlantDto());

    expect(errors.length).toBeGreaterThan(0);
  });
});
