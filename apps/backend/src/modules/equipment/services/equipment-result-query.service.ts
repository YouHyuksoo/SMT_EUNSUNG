import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { EquipmentResultQueryDto } from '../dto/equipment-result-query.dto';

interface ResultDefinition {
  table: string;
  dateColumn: string;
  modelByRunNo?: boolean;
  pidColumn?: string;
  supports: ReadonlySet<string>;
}

const common = new Set(['lineCode', 'pid', 'modelName', 'runNo', 'result']);
const RESULT_DEFINITIONS: Record<string, ResultDefinition> = {
  sp: { table: 'IQ_MACHINE_INSPECT_DATA_SP', dateColumn: 'INSPECT_DATE', modelByRunNo: true, pidColumn: 'PID', supports: common },
  spi: { table: 'IQ_MACHINE_INSPECT_DATA_SPI', dateColumn: 'INSPECT_DATE', modelByRunNo: true, pidColumn: 'PID', supports: common },
  ict: { table: 'IQ_MACHINE_INSPECT_DATA_ICT', dateColumn: 'INSPECT_DATE', modelByRunNo: true, pidColumn: 'PID', supports: common },
  aoi: { table: 'IQ_MACHINE_INSPECT_DATA_AOI', dateColumn: 'INSPECT_DATE', modelByRunNo: true, pidColumn: 'PID', supports: new Set([...common, 'reviewResult']) },
  router: { table: 'IQ_MACHINE_INSPECT_DATA_RT', dateColumn: 'INSPECT_DATE', modelByRunNo: true, pidColumn: 'PID', supports: common },
  'rom-write': { table: 'IQ_MACHINE_INSPECT_DATA_RW', dateColumn: 'INSPECT_DATE', modelByRunNo: true, pidColumn: 'PID', supports: common },
  solder: { table: 'IQ_MACHINE_INSPECT_DATA_SOLDER', dateColumn: 'MEASURE_DATE', pidColumn: 'SOLDER_NO', supports: new Set(['lineCode', 'pid']) },
  reflow: { table: 'IQ_MACHINE_INSPECT_DATA_REFLOW', dateColumn: 'MEASURE_DATE', supports: new Set(['lineCode', 'jobFile']) },
  performance: { table: 'IQ_MACHINE_INSPECT_DATA_EOL', dateColumn: 'INSPECT_START_DATE', modelByRunNo: true, pidColumn: 'PID', supports: common },
};

function toCamelCase(key: string) {
  return key.toLowerCase().replace(/_([a-z0-9])/g, (_, char: string) => char.toUpperCase());
}

function nextDay(dateText: string) {
  const date = new Date(`${dateText}T00:00:00+09:00`);
  date.setDate(date.getDate() + 1);
  return date.toISOString().slice(0, 10).replaceAll('-', '/');
}

@Injectable()
export class EquipmentResultQueryService {
  constructor(private readonly dataSource: DataSource) {}

  async findAll(type: string, organizationId: number, query: EquipmentResultQueryDto) {
    const definition = RESULT_DEFINITIONS[type];
    if (!definition) throw new BadRequestException(`지원하지 않는 설비 결과 유형입니다: ${type}`);
    if (query.dateFrom > query.dateTo) throw new BadRequestException('시작일은 종료일보다 늦을 수 없습니다.');

    const conditions = [
      `t.${definition.dateColumn} >= :dateFrom`,
      `t.${definition.dateColumn} < :dateToExclusive`,
      't.ORGANIZATION_ID = :organizationId',
    ];
    const binds: Record<string, string | number> = {
      dateFrom: query.dateFrom.replaceAll('-', '/'),
      dateToExclusive: nextDay(query.dateTo),
      organizationId,
      limit: query.limit ?? 1000,
    };

    const addLike = (supportedKey: string, column: string, value?: string) => {
      if (!value || !definition.supports.has(supportedKey)) return;
      conditions.push(`t.${column} LIKE :${supportedKey}`);
      binds[supportedKey] = `%${value}%`;
    };
    addLike('lineCode', 'LINE_CODE', query.lineCode);
    addLike('pid', definition.pidColumn ?? 'PID', query.pid);
    addLike('runNo', 'RUN_NO', query.runNo);
    addLike('result', 'RESULT', query.result);
    addLike('reviewResult', 'REVIEW_RESULT', query.reviewResult);
    addLike('jobFile', 'JOB_FILE', query.jobFile);
    if (query.modelName && definition.modelByRunNo) {
      conditions.push('F_GET_RUN_MODEL_NAME(t.RUN_NO) LIKE :modelName');
      binds.modelName = `%${query.modelName}%`;
    }

    const modelColumn = definition.modelByRunNo ? ', F_GET_RUN_MODEL_NAME(t.RUN_NO) AS MODEL_NAME' : '';
    const sql = `
      SELECT * FROM (
        SELECT t.*${modelColumn}
          FROM ${definition.table} t
         WHERE ${conditions.join('\n           AND ')}
         ORDER BY t.${definition.dateColumn} DESC
      )
      WHERE ROWNUM <= :limit`;
    const rows = await this.dataSource.query(sql, { ...binds } as unknown as unknown[]);
    const data = rows.map((row: Record<string, unknown>) => Object.fromEntries(
      Object.entries(row).map(([key, value]) => [toCamelCase(key), value]),
    ));
    return { data, total: data.length, limited: data.length >= Number(binds.limit) };
  }
}
