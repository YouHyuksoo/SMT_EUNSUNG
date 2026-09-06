import { plainToInstance } from 'class-transformer';
import { validateSync } from 'class-validator';
import { CreateProdLineDto, UpdateProdLineDto } from './prod-line.dto';

describe('production-line OEE field DTO contract', () => {
  const base = { lineCode: 'L01', lineName: 'Line 1', lineDivision: 'L' };

  it.each([
    ['SMT', 'LINE'],
    ['ASSY', 'CELL'],
  ])('accepts process %s and resource type %s', (processCode, resourceType) => {
    const dto = plainToInstance(CreateProdLineDto, { ...base, processCode, resourceType, parentLineCode: 'L02' });
    expect(validateSync(dto)).toHaveLength(0);
  });

  it('rejects unknown process and resource codes', () => {
    const dto = plainToInstance(CreateProdLineDto, { ...base, processCode: 'PAINT', resourceType: 'MACHINE' });
    const fields = validateSync(dto).map((error) => error.property);
    expect(fields).toEqual(expect.arrayContaining(['processCode', 'resourceType']));
  });

  it('keeps the new fields optional for legacy rows and partial updates', () => {
    expect(validateSync(plainToInstance(CreateProdLineDto, base))).toHaveLength(0);
    expect(validateSync(plainToInstance(UpdateProdLineDto, {}))).toHaveLength(0);
  });

  it('rejects parent line codes longer than the Oracle column', () => {
    const dto = plainToInstance(CreateProdLineDto, { ...base, parentLineCode: '123456789012345678901' });
    expect(validateSync(dto).map((error) => error.property)).toContain('parentLineCode');
  });
});
