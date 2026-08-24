import { getMetadataArgsStorage } from 'typeorm';
import { Plant } from './plant.entity';

describe('PLANTS entity mapping', () => {
  const storage = getMetadataArgsStorage();

  it('maps the actual tenant columns and four-column primary key', () => {
    const columns = storage.columns.filter((column) => column.target === Plant);
    const columnName = (propertyName: string) =>
      columns.find((column) => column.propertyName === propertyName)?.options.name;
    const columnLength = (propertyName: string) =>
      columns.find((column) => column.propertyName === propertyName)?.options.length;

    expect(storage.tables.find((table) => table.target === Plant)?.name).toBe('PLANTS');
    expect(columnName('company')).toBe('COMPANY');
    expect(columnName('plantCd')).toBe('PLANT_CD');
    expect(columnName('organizationId')).toBeUndefined();
    expect(columnLength('company')).toBe(50);
    expect(columnLength('plantCd')).toBe(50);
    expect(columnLength('plantName')).toBe(200);

    expect(
      columns.filter((column) => column.options.primary).map((column) => column.propertyName),
    ).toEqual(['plantCode', 'shopCode', 'lineCode', 'cellCode']);
  });
});
