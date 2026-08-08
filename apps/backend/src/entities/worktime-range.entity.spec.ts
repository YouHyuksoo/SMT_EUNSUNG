import { getMetadataArgsStorage } from 'typeorm';
import { WorktimeRange } from './worktime-range.entity';

describe('ICOM_WORKTIME_RANGES entity mapping', () => {
  it('uses the approved logical composite key and actual source columns', () => {
    const storage = getMetadataArgsStorage();
    const columns = storage.columns.filter((column) => column.target === WorktimeRange);
    const columnName = (propertyName: string) =>
      columns.find((column) => column.propertyName === propertyName)?.options.name;

    expect(storage.tables.find((table) => table.target === WorktimeRange)?.name).toBe(
      'ICOM_WORKTIME_RANGES',
    );
    expect(
      columns.filter((column) => column.options.primary).map((column) => column.propertyName),
    ).toEqual(['organizationId', 'rangeType', 'workType']);
    expect(columnName('startTime')).toBe('START_TIME');
    expect(columnName('endTime')).toBe('END_TIME');
    expect(columnName('attribute01')).toBe('ATTRIBUTE01');
    expect(columnName('attribute02')).toBe('ATTRIBUTE02');
  });
});
