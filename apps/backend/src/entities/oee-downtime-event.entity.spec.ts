import { getMetadataArgsStorage } from 'typeorm';
import { OeeDowntimeEvent } from './oee-downtime-event.entity';

describe('OEE_DOWNTIME_EVENT entity mapping', () => {
  it('maps the identity event key and event columns without misleading nullable indexes', () => {
    const storage = getMetadataArgsStorage();
    const columns = storage.columns.filter((column) => column.target === OeeDowntimeEvent);
    const column = (propertyName: string) => columns.find((item) => item.propertyName === propertyName);

    expect(storage.tables.find((table) => table.target === OeeDowntimeEvent)?.name).toBe(
      'OEE_DOWNTIME_EVENT',
    );
    expect(column('eventId')?.options.name).toBe('EVENT_ID');
    expect(
      storage.generations.find(
        (generation) => generation.target === OeeDowntimeEvent && generation.propertyName === 'eventId',
      )?.strategy,
    ).toBe('identity');
    expect(column('endTime')?.options.nullable).toBe(true);
    expect(column('memo')?.options.length).toBe(500);
    expect(column('startRequestId')?.options.length).toBe(64);
    expect(column('endRequestId')?.options.nullable).toBe(true);

    const indexes = storage.indices.filter((index) => index.target === OeeDowntimeEvent);
    expect(indexes).toEqual([]);
  });
});
