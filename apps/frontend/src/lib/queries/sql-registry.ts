import { SQL_PRODUCT_LINE_MONITORING } from './product-line-monitoring';
import { sqlCheckItems, sqlSmdProduction } from './smd-production';
import { sqlSmdDualNgCount, sqlSmdDualProduction } from './smd-dual-production';
import { sqlSolderNgCount, sqlSolderWarningList } from './solder-warning';
import { sqlMslNgCount, sqlMslWarningList } from './msl-warning-list';
import { sqlMslWarningIssueList, sqlMslWarningIssueNgCount } from './msl-warning-issue';
import { sqlProductionKpiList } from './production-kpi';
import { sqlSpiByLine, sqlSpiFpyTrend, sqlSpiSummary, sqlSpiTopLines } from './spi-chart';
import { sqlAoiByLine, sqlAoiFpyTrend, sqlAoiSummary, sqlAoiTopLines } from './aoi-chart';
import { sqlFctByModel, sqlFctFpyTrend, sqlFctSummary, sqlFctTopModels } from './fct-chart';

export interface SqlEntry {
  label: string;
  sql: string;
}

export interface ScreenSqlInfo {
  screenId: string;
  title: string;
  queries: SqlEntry[];
}

const LINE_FILTER = '/* AND line_code IN (:line0, ...) */';
const LINE_FILTER_UPPER = '/* AND LINE_CODE IN (:line0, ...) */';

const SCREEN_SQL_BUILDERS: Record<string, () => ScreenSqlInfo> = {
  '21': () => ({
    screenId: '21',
    title: '제품생산현황 (Line Monitoring)',
    queries: [
      { label: 'Line Monitoring', sql: SQL_PRODUCT_LINE_MONITORING },
    ],
  }),
  '24': () => ({
    screenId: '24',
    title: 'SMD Production Status',
    queries: [
      { label: 'SMD Production List', sql: sqlSmdProduction(LINE_FILTER) },
      { label: 'Check Items', sql: sqlCheckItems(LINE_FILTER) },
    ],
  }),
  '25': () => ({
    screenId: '25',
    title: 'Foolproof Status',
    queries: [
      { label: 'SMD Production List', sql: sqlSmdProduction(LINE_FILTER) },
      { label: 'Check Items', sql: sqlCheckItems(LINE_FILTER) },
    ],
  }),
  '26': () => ({
    screenId: '26',
    title: 'Line Production KPI',
    queries: [
      { label: 'Production KPI', sql: sqlProductionKpiList(LINE_FILTER) },
    ],
  }),
  '27': () => ({
    screenId: '27',
    title: 'SMD Dual Production Status',
    queries: [
      { label: 'Production Detail', sql: sqlSmdDualProduction(LINE_FILTER) },
      { label: 'Check Items', sql: sqlCheckItems(LINE_FILTER) },
      { label: 'NG Count', sql: sqlSmdDualNgCount(LINE_FILTER) },
    ],
  }),
  '29': () => ({
    screenId: '29',
    title: 'MSL Warning (장착 기준)',
    queries: [
      { label: 'MSL Warning List', sql: sqlMslWarningList() },
      { label: 'NG Count', sql: sqlMslNgCount() },
    ],
  }),
  '30': () => ({
    screenId: '30',
    title: 'MSL Warning (출고 기준)',
    queries: [
      { label: 'MSL Warning List', sql: sqlMslWarningIssueList() },
      { label: 'NG Count', sql: sqlMslWarningIssueNgCount() },
    ],
  }),
  '31': () => ({
    screenId: '31',
    title: 'Solder Paste Management',
    queries: [
      { label: 'Solder Warning List', sql: sqlSolderWarningList() },
      { label: 'NG Count', sql: sqlSolderNgCount() },
    ],
  }),
  '40': () => ({
    screenId: '40',
    title: 'SPI Chart Analysis',
    queries: [
      { label: 'By Line', sql: sqlSpiByLine(LINE_FILTER_UPPER) },
      { label: 'FPY Trend', sql: sqlSpiFpyTrend(LINE_FILTER_UPPER) },
      { label: 'Summary', sql: sqlSpiSummary(LINE_FILTER_UPPER) },
      { label: 'Top Lines', sql: sqlSpiTopLines(LINE_FILTER_UPPER) },
    ],
  }),
  '41': () => ({
    screenId: '41',
    title: 'AOI Chart Analysis',
    queries: [
      { label: 'By Line', sql: sqlAoiByLine(LINE_FILTER_UPPER) },
      { label: 'FPY Trend', sql: sqlAoiFpyTrend(LINE_FILTER_UPPER) },
      { label: 'Summary', sql: sqlAoiSummary(LINE_FILTER_UPPER) },
      { label: 'Top Lines', sql: sqlAoiTopLines(LINE_FILTER_UPPER) },
    ],
  }),
  '42': () => ({
    screenId: '42',
    title: 'FCT Chart Analysis',
    queries: [
      { label: 'Today By Model', sql: sqlFctByModel(LINE_FILTER_UPPER) },
      { label: 'FPY Trend', sql: sqlFctFpyTrend(LINE_FILTER_UPPER) },
      { label: 'Summary', sql: sqlFctSummary(LINE_FILTER_UPPER) },
      { label: 'Weekly Top Models', sql: sqlFctTopModels(LINE_FILTER_UPPER) },
    ],
  }),
};

export function getScreenSql(screenId: string): ScreenSqlInfo | undefined {
  return SCREEN_SQL_BUILDERS[screenId]?.();
}

export function getRegisteredScreenIds(): string[] {
  return Object.keys(SCREEN_SQL_BUILDERS);
}
