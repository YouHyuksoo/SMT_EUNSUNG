import oracledb from 'oracledb';
import * as XLSX from 'xlsx';
import { buildConnectString, loadFileConfig } from '@/lib/db';
import type { DatabaseProfile } from '@/types/option';

type RowValue = string | number | boolean | Date | null | undefined;

export interface SomosMigrationRecord {
  rowNo: number;
  modelName: string;
  itemCode: string;
  modelSuffix: string;
  modelCode: string;
  productDate: string;
  lotNo: string;
  lineCode: string;
  poNo: string;
  ep1: string;
  ep2: string;
  ep3: string;
  ep4: string;
  ep5: string;
  ep6: string;
  swVersion: string;
  hwVersion: string;
  ep2Child: string;
  ep4Child: string;
  ep5Child: string;
}

export interface SomosMigrationPreview {
  file: {
    sheetName: string;
    rowCount: number;
  };
  counts: {
    records: number;
    models: number;
    runs: number;
    rowsWithEp4: number;
    rowsWithEp6: number;
    duplicateEp1: number;
    missingRequiredRows: number;
  };
  db: {
    existingModels: number;
    missingModels: string[];
    existingRuns: number;
    existingSerials: number;
    existingWorkstageSerials: number;
    bomOk: number;
    bomIssues: BomIssue[];
  };
  plan: {
    modelMasterInserts: number;
    miPlanInserts: number;
    runCardInserts: number;
    barcodeInserts: number;
    workstageIoInserts: number;
    workstageDetailInserts: number;
    generatedHspawBarcodes: number;
  };
  samples: {
    records: SomosMigrationRecord[];
    errors: RowError[];
  };
}

interface RowError {
  rowNo: number;
  message: string;
}

interface BomMapping {
  hspswChild: string;
  hspawChild: string;
  memwlChild: string;
}

interface BomIssue {
  hspswChild: string;
  reason: string;
  candidates: { hspawChild: string; memwlChild: string | null }[];
}

interface ExistingState {
  models: Set<string>;
  runs: Set<string>;
  serials: Set<string>;
  bomMap: Map<string, BomMapping>;
  bomIssues: BomIssue[];
  maxPlanSeqByDate: Map<string, number>;
  detailSerials: Set<string>;
}

export type ProgressFn = (msg: string) => void;

const ORG_ID = 1;
const MIGRATION_USER = 'MIGRATION';
const IN_CHUNK_SIZE = 900;
const INSERT_BATCH_SIZE = 5000;

function text(value: RowValue): string {
  return String(value ?? '').trim();
}

function date8(value: RowValue): string {
  const raw = text(value);
  const match = raw.match(/^(\d{4})[-/.]?(\d{2})[-/.]?(\d{2})/);
  return match ? `${match[1]}${match[2]}${match[3]}` : raw;
}

function lineCode(value: RowValue): string {
  const match = text(value).match(/(\d{1,2})\s*$/);
  return match ? match[1].padStart(2, '0') : text(value);
}

function modelSuffix(modelName: string): string {
  return modelName.includes('/') ? modelName.split('/').at(-1) ?? '*' : '*';
}

function itemFromBarcode(value: RowValue): string {
  const raw = text(value);
  const match = raw.match(/(HEKMP\d{5}A|HSPSW\d{5}A|HCAST\d{5}A|HSPAW\d{5}A|MEMWL\d{5}[A-Z])/);
  if (match) return match[1];
  if (/^HCAST\d{5}A$/.test(raw)) return raw;
  return '';
}

function uniq(values: string[]): string[] {
  return [...new Set(values.filter(Boolean))];
}

function makeConnectOptions(): oracledb.ConnectionAttributes {
  const fileConfig = loadFileConfig();
  const profileName = process.env.BJVNSET_ORACLE_PROFILE;
  const profile = profileName
    ? (fileConfig?.profiles.find((item) => item.name === profileName)
      ?? fileConfig?.profiles.find((item) => item.name === fileConfig.activeProfile))
    : fileConfig?.profiles.find((item) => item.name === fileConfig.activeProfile)
      ?? fileConfig?.profiles.find((item) => item.host && item.username);

  if (profile) return makeProfileConnectOptions(profile);

  if (!process.env.BJVNSET_ORACLE_USER || !process.env.BJVNSET_ORACLE_PASSWORD || !process.env.BJVNSET_ORACLE_CONNECT_STRING) {
    throw new Error('마이그레이션 DB 프로필을 찾을 수 없습니다. config/database.json activeProfile 또는 BJVNSET_ORACLE_* 환경변수를 확인하세요.');
  }

  return {
    user: process.env.BJVNSET_ORACLE_USER,
    password: process.env.BJVNSET_ORACLE_PASSWORD,
    connectString: process.env.BJVNSET_ORACLE_CONNECT_STRING,
  };
}

function makeProfileConnectOptions(profile: DatabaseProfile): oracledb.ConnectionAttributes {
  return {
    user: process.env.BJVNSET_ORACLE_USER ?? profile.username,
    password: process.env.BJVNSET_ORACLE_PASSWORD ?? profile.password,
    connectString: process.env.BJVNSET_ORACLE_CONNECT_STRING ?? buildConnectString(profile),
  };
}

function excelDateToJsDate(dateText: string): Date {
  if (!/^\d{8}$/.test(dateText)) return new Date();
  const year = Number(dateText.slice(0, 4));
  const month = Number(dateText.slice(4, 6)) - 1;
  const day = Number(dateText.slice(6, 8));
  return new Date(year, month, day);
}

function parseWorkbook(buffer: Buffer): { sheetName: string; records: SomosMigrationRecord[]; errors: RowError[] } {
  const workbook = XLSX.read(buffer, { cellDates: true, raw: false });
  const sheetName = workbook.SheetNames[0];
  const sheet = workbook.Sheets[sheetName];
  const rows = XLSX.utils.sheet_to_json<RowValue[]>(sheet, { header: 1, raw: false, defval: '' });
  const dataStart = rows[2]?.some((v) => text(v) === 'Factory') ? 3 : 4;
  const errors: RowError[] = [];
  const records = rows
    .slice(dataStart)
    .map((row, idx) => ({ row, rowNo: idx + dataStart + 1 }))
    .filter(({ row }) => row.some((v) => text(v)))
    .map(({ row, rowNo }) => {
      const modelName = text(row[4]);
      const ep1 = text(row[13]);
      const record: SomosMigrationRecord = {
        rowNo,
        modelName,
        itemCode: `BA${modelName}`,
        modelSuffix: modelSuffix(modelName),
        modelCode: ep1.slice(0, 4),
        productDate: date8(row[7]),
        lotNo: text(row[8]),
        lineCode: lineCode(row[9]),
        poNo: text(row[25]),
        ep1,
        ep2: text(row[14]),
        ep3: text(row[15]),
        ep4: text(row[16]),
        ep5: text(row[17]),
        ep6: text(row[18]),
        swVersion: text(row[23]),
        hwVersion: text(row[24]),
        ep2Child: itemFromBarcode(row[14]),
        ep4Child: itemFromBarcode(row[16]),
        ep5Child: itemFromBarcode(row[17]),
      };
      const missing = ['modelName', 'productDate', 'lotNo', 'lineCode', 'poNo', 'ep1', 'ep2', 'ep5']
        .filter((key) => !record[key as keyof SomosMigrationRecord]);
      if (missing.length) errors.push({ rowNo, message: `필수값 누락: ${missing.join(', ')}` });
      return record;
    });
  return { sheetName, records, errors };
}

async function fetchSet<T extends Record<string, unknown>>(
  conn: oracledb.Connection,
  table: string,
  column: string,
  values: string[],
  extraWhere = '',
): Promise<Set<string>> {
  const result = new Set<string>();
  for (let i = 0; i < values.length; i += IN_CHUNK_SIZE) {
    const chunk = values.slice(i, i + IN_CHUNK_SIZE);
    if (!chunk.length) continue;
    const binds = Object.fromEntries(chunk.map((value, index) => [`b${index}`, value]));
    const sql = `
      SELECT ${column} AS VALUE
        FROM ${table}
       WHERE ${extraWhere ? `${extraWhere} AND` : ''} ${column} IN (${chunk.map((_, index) => `:b${index}`).join(',')})
    `;
    const rows = await conn.execute<T>(sql, binds, { outFormat: oracledb.OUT_FORMAT_OBJECT });
    for (const row of rows.rows ?? []) result.add(String(row.VALUE));
  }
  return result;
}

async function loadExistingState(conn: oracledb.Connection, records: SomosMigrationRecord[], onProgress?: ProgressFn): Promise<ExistingState> {
  const models = uniq(records.map((r) => r.modelName));
  const runs = uniq(records.map((r) => r.lotNo));
  const serials = uniq(records.map((r) => r.ep1));
  const hspswChildren = uniq(records.map((r) => r.ep4Child));
  const dates = uniq(records.map((r) => r.productDate));

  onProgress?.('MODEL_MASTER 중복 조회 중...');
  const existingModels = await fetchSet(conn, 'IP_PRODUCT_MODEL_MASTER', 'MODEL_NAME', models, 'ORGANIZATION_ID = 1');
  onProgress?.('RUN_CARD 중복 조회 중...');
  const existingRuns = await fetchSet(conn, 'IP_PRODUCT_RUN_CARD', 'RUN_NO', runs, 'ORGANIZATION_ID = 1');
  onProgress?.('2D_BARCODE 중복 조회 중...');
  const existingSerials = await fetchSet(conn, 'IP_PRODUCT_2D_BARCODE', 'SERIAL_NO', serials);
  onProgress?.('WORKSTAGE_DETAIL 중복 조회 중...');
  const existingDetailSerials = await fetchSet(conn, 'IP_PRODUCT_WORKSTAGE_DETAIL', 'SERIAL_NO', serials, 'ORGANIZATION_ID = 1');

  const { bomMap, bomIssues } = await loadBomMappings(conn, hspswChildren, onProgress);

  const maxPlanSeqByDate = new Map<string, number>();
  onProgress?.(`MI_PLAN 시퀀스 일괄 조회 중... (${dates.length}일)`);
  await loadMaxPlanSequences(conn, dates, maxPlanSeqByDate);

  return { models: existingModels, runs: existingRuns, serials: existingSerials, bomMap, bomIssues, maxPlanSeqByDate, detailSerials: existingDetailSerials };
}

async function loadBomMappings(
  conn: oracledb.Connection,
  hspswChildren: string[],
  onProgress?: ProgressFn,
): Promise<{ bomMap: Map<string, BomMapping>; bomIssues: BomIssue[] }> {
  const bomMap = new Map<string, BomMapping>();
  const bomIssues: BomIssue[] = [];
  const candidatesByParent = new Map<string, { hspawChild: string; memwlChild: string | null }[]>();

  onProgress?.(`BOM 일괄 조회 중... (${hspswChildren.length}개 품목)`);
  for (let i = 0; i < hspswChildren.length; i += IN_CHUNK_SIZE) {
    const chunk = hspswChildren.slice(i, i + IN_CHUNK_SIZE);
    if (!chunk.length) continue;
    const binds = Object.fromEntries(chunk.map((value, index) => [`p${index}`, value]));
    const result = await conn.execute<{ HSPSW_CHILD: string; HSPAW_CHILD: string; MEMWL_CHILD: string | null }>(
      `
        SELECT b1.parent_item_code AS hspsw_child,
               b1.child_item_code AS hspaw_child,
               b2.child_item_code AS memwl_child
          FROM id_eng_bom b1
          LEFT JOIN id_eng_bom b2
            ON b2.organization_id = b1.organization_id
           AND b2.parent_item_code = b1.child_item_code
           AND b2.child_item_code LIKE 'MEMWL%'
           AND b2.dateend > SYSDATE
         WHERE b1.organization_id = ${ORG_ID}
           AND b1.parent_item_code IN (${chunk.map((_, index) => `:p${index}`).join(',')})
           AND b1.child_item_code LIKE 'HSPAW%'
           AND b1.dateend > SYSDATE
      `,
      binds,
      { outFormat: oracledb.OUT_FORMAT_OBJECT },
    );

    for (const row of result.rows ?? []) {
      const parent = String(row.HSPSW_CHILD);
      const candidates = candidatesByParent.get(parent) ?? [];
      candidates.push({ hspawChild: row.HSPAW_CHILD, memwlChild: row.MEMWL_CHILD });
      candidatesByParent.set(parent, candidates);
    }
    onProgress?.(`BOM 일괄 조회: ${Math.min(i + IN_CHUNK_SIZE, hspswChildren.length).toLocaleString()} / ${hspswChildren.length.toLocaleString()}`);
  }

  for (const child of hspswChildren) {
    const candidates = candidatesByParent.get(child) ?? [];
    const valid = candidates.filter((row) => row.memwlChild);
    if (valid.length === 1) {
      bomMap.set(child, { hspswChild: child, hspawChild: valid[0].hspawChild, memwlChild: valid[0].memwlChild! });
    } else if (candidates.length > 0) {
      bomIssues.push({
        hspswChild: child,
        reason: valid.length === 0 ? 'MEMWL BOM 없음' : 'MEMWL 후보 복수',
        candidates,
      });
    }
  }

  return { bomMap, bomIssues };
}

async function loadMaxPlanSequences(conn: oracledb.Connection, dates: string[], target: Map<string, number>) {
  for (const date of dates) target.set(date, 0);
  for (let i = 0; i < dates.length; i += IN_CHUNK_SIZE) {
    const chunk = dates.slice(i, i + IN_CHUNK_SIZE);
    if (!chunk.length) continue;
    const binds = Object.fromEntries(chunk.map((value, index) => [`d${index}`, value]));
    const result = await conn.execute<{ PLAN_DATE_TEXT: string; MAX_SEQ: number }>(
      `
        SELECT TO_CHAR(plan_date, 'YYYYMMDD') AS plan_date_text,
               NVL(MAX(plan_sequence), 0) AS max_seq
          FROM ip_product_mi_plan
         WHERE organization_id = ${ORG_ID}
           AND plan_date IN (${chunk.map((_, index) => `TO_DATE(:d${index}, 'YYYYMMDD')`).join(',')})
         GROUP BY plan_date
      `,
      binds,
      { outFormat: oracledb.OUT_FORMAT_OBJECT },
    );
    for (const row of result.rows ?? []) {
      target.set(String(row.PLAN_DATE_TEXT), Number(row.MAX_SEQ ?? 0));
    }
  }
}

function isNewRecord(record: SomosMigrationRecord, state: ExistingState): boolean {
  return !state.serials.has(record.ep1) && !state.detailSerials.has(record.ep1);
}

function summarize(buffer: Buffer, state: ExistingState, sheetName: string, records: SomosMigrationRecord[], errors: RowError[]): SomosMigrationPreview {
  const ep1Counts = new Map<string, number>();
  for (const record of records) ep1Counts.set(record.ep1, (ep1Counts.get(record.ep1) ?? 0) + 1);
  const duplicateEp1 = [...ep1Counts.entries()].filter(([key, count]) => key && count > 1).length;
  const models = uniq(records.map((r) => r.modelName));
  const runs = uniq(records.map((r) => r.lotNo));
  const missingModels = models.filter((model) => !state.models.has(model));
  const validRecords = records.filter((record) => isNewRecord(record, state));
  const rowsWithEp6 = validRecords.filter((record) => record.ep6).length;
  const rowsWithEp4 = validRecords.filter((record) => record.ep4).length;
  const rowsWithHspawMapping = validRecords.filter((record) => record.ep4 && record.ep6 && state.bomMap.has(record.ep4Child)).length;
  const groupedMiPlan = new Set(validRecords.map((record) => `${record.productDate}|${record.lineCode}|${record.modelName}|${record.lotNo}`));
  return {
    file: { sheetName, rowCount: records.length },
    counts: {
      records: records.length,
      models: models.length,
      runs: runs.length,
      rowsWithEp4,
      rowsWithEp6,
      duplicateEp1,
      missingRequiredRows: errors.length,
    },
    db: {
      existingModels: state.models.size,
      missingModels,
      existingRuns: runs.filter((run) => state.runs.has(run)).length,
      existingSerials: records.filter((record) => state.serials.has(record.ep1)).length,
      existingWorkstageSerials: records.filter((record) => state.detailSerials.has(record.ep1)).length,
      bomOk: state.bomMap.size,
      bomIssues: state.bomIssues,
    },
    plan: {
      modelMasterInserts: missingModels.length,
      miPlanInserts: groupedMiPlan.size,
      runCardInserts: runs.filter((run) => !state.runs.has(run)).length,
      barcodeInserts: validRecords.length,
      workstageIoInserts: validRecords.length * 3 + rowsWithHspawMapping * 2,
      workstageDetailInserts: validRecords.length * 2 + rowsWithEp4 + rowsWithHspawMapping * 2,
      generatedHspawBarcodes: rowsWithHspawMapping,
    },
    samples: {
      records: records.slice(0, 20),
      errors: errors.slice(0, 50),
    },
  };
}

export async function previewSomosMigration(buffer: Buffer, onProgress?: ProgressFn): Promise<SomosMigrationPreview> {
  const { sheetName, records, errors } = parseWorkbook(buffer);
  onProgress?.(`Excel 파싱 완료 (${records.length.toLocaleString()}행)`);
  const conn = await oracledb.getConnection(makeConnectOptions());
  onProgress?.('DB 접속 완료');
  try {
    const state = await loadExistingState(conn, records, onProgress);
    onProgress?.('기준정보 조회 완료');
    return summarize(buffer, state, sheetName, records, errors);
  } finally {
    await conn.close();
  }
}

export async function applySomosMigration(buffer: Buffer, onProgress?: ProgressFn): Promise<SomosMigrationPreview> {
  const { sheetName, records, errors } = parseWorkbook(buffer);
  onProgress?.(`Excel 파싱 완료 (${records.length.toLocaleString()}행)`);
  if (errors.length) throw new Error(`필수값 누락 행이 ${errors.length}건 있습니다. preview에서 먼저 수정하세요.`);
  const conn = await oracledb.getConnection(makeConnectOptions());
  onProgress?.('DB 접속 완료');
  try {
    const state = await loadExistingState(conn, records, onProgress);
    onProgress?.('기준정보 조회 완료');
    await insertModelMasters(conn, records, state);
    onProgress?.('MODEL_MASTER 입력 완료');
    await insertMiPlans(conn, records, state);
    onProgress?.('MI_PLAN 입력 완료');
    await insertRunCards(conn, records, state);
    onProgress?.('RUN_CARD 입력 완료');
    await insertBarcodes(conn, records, state, onProgress);
    onProgress?.('2D_BARCODE 입력 완료');
    await insertWorkstageRows(conn, records, state, onProgress);
    onProgress?.('WORKSTAGE 입력 완료 — 커밋 중...');
    await conn.commit();
    onProgress?.('커밋 완료');
    state.models = await fetchSet(conn, 'IP_PRODUCT_MODEL_MASTER', 'MODEL_NAME', uniq(records.map((r) => r.modelName)), 'ORGANIZATION_ID = 1');
    state.runs = await fetchSet(conn, 'IP_PRODUCT_RUN_CARD', 'RUN_NO', uniq(records.map((r) => r.lotNo)), 'ORGANIZATION_ID = 1');
    state.serials = await fetchSet(conn, 'IP_PRODUCT_2D_BARCODE', 'SERIAL_NO', uniq(records.map((r) => r.ep1)));
    return summarize(buffer, state, sheetName, records, errors);
  } catch (error) {
    await conn.rollback();
    throw error;
  } finally {
    await conn.close();
  }
}

async function insertModelMasters(conn: oracledb.Connection, records: SomosMigrationRecord[], state: ExistingState) {
  const byModel = new Map<string, SomosMigrationRecord>();
  for (const r of records) if (!state.models.has(r.modelName) && !byModel.has(r.modelName)) byModel.set(r.modelName, r);
  if (!byModel.size) return;
  const sql = `
    INSERT INTO ip_product_model_master (
      model_name, part_no, customer_code, packing_pcs_qty, organization_id,
      enter_by, enter_date, last_modify_by, last_modify_date, item_code,
      customer_model_name, model_suffix, sw_version, hw_version, model_code, factory_code
    ) VALUES (
      :modelName, :itemCode, 'C001', 1, ${ORG_ID},
      '${MIGRATION_USER}', SYSDATE, '${MIGRATION_USER}', SYSDATE, :itemCode,
      :modelName, :modelSuffix, :swVersion, :hwVersion, :modelCode, 'PDA5'
    )
  `;
  await conn.executeMany(sql, [...byModel.values()].map((r) => ({
    modelName: r.modelName,
    itemCode: r.itemCode,
    modelSuffix: r.modelSuffix,
    swVersion: r.swVersion,
    hwVersion: r.hwVersion,
    modelCode: r.modelCode,
  })));
}

async function insertMiPlans(conn: oracledb.Connection, records: SomosMigrationRecord[], state: ExistingState) {
  const groups = new Map<string, { record: SomosMigrationRecord; qty: number }>();
  for (const r of records.filter((r) => isNewRecord(r, state))) {
    const key = `${r.productDate}|${r.lineCode}|${r.modelName}|${r.lotNo}`;
    const g = groups.get(key);
    if (g) g.qty += 1;
    else groups.set(key, { record: r, qty: 1 });
  }
  if (!groups.size) return;
  const sql = `
    INSERT INTO ip_product_mi_plan (
      plan_date, plan_sequence, plan_priority, line_code, mfs, model_name,
      model_suffix, item_code, work_order_no, plan_qty, actual_qty,
      organization_id, enter_date, enter_by, last_modify_date, last_modify_by,
      customer_code, plan_status, confirm_yn, workstage_code, production_type, parent_item_code, plan_start_date, plan_end_date
    ) VALUES (
      TO_DATE(:productDate, 'YYYYMMDD'), :planSequence, 1, :lineCode, :mfs, :modelName,
      :modelSuffix, :itemCode, :workOrderNo, :qty, :qty,
      ${ORG_ID}, SYSDATE, '${MIGRATION_USER}', SYSDATE, '${MIGRATION_USER}',
      'C001', 'L', 'Y', 'W030', 'G', '*', TO_DATE(:productDate, 'YYYYMMDD'), TO_DATE(:productDate, 'YYYYMMDD')
    )
  `;
  const binds = [...groups.values()].map(({ record: r, qty }) => {
    const maxSeq = state.maxPlanSeqByDate.get(r.productDate) ?? 0;
    const planSequence = maxSeq + 1;
    state.maxPlanSeqByDate.set(r.productDate, planSequence);
    return { productDate: r.productDate, planSequence, lineCode: r.lineCode, mfs: r.poNo, modelName: r.modelName, modelSuffix: r.modelSuffix, itemCode: r.itemCode, workOrderNo: r.lotNo, qty };
  });
  await conn.executeMany(sql, binds);
}

async function insertRunCards(conn: oracledb.Connection, records: SomosMigrationRecord[], state: ExistingState) {
  const groups = new Map<string, { record: SomosMigrationRecord; qty: number }>();
  for (const r of records.filter((r) => isNewRecord(r, state) && !state.runs.has(r.lotNo))) {
    const g = groups.get(r.lotNo);
    if (g) g.qty += 1;
    else groups.set(r.lotNo, { record: r, qty: 1 });
  }
  if (!groups.size) return;
  const sql = `
    INSERT INTO ip_product_run_card (
      run_no, run_date, lot_no, item_code, model_name, line_code, lot_size,
      charger, organization_id, enter_date, enter_by, last_modify_date, last_modify_by,
      run_status, product_run_type, active_yn, run_type_code, master_model_name,
      shift_code, plan_start_date, plan_end_date, label_check_yn, bom_check_yn, parent_item_code
    ) VALUES (
      :lotNo, TO_DATE(:productDate, 'YYYYMMDD'), :poNo, :itemCode, :modelName, :lineCode, :qty,
      '${MIGRATION_USER}', ${ORG_ID}, SYSDATE, '${MIGRATION_USER}', SYSDATE, '${MIGRATION_USER}',
      '1', '1', 'N', '1', :modelName,
      'A', TO_DATE(:productDate, 'YYYYMMDD'), TO_DATE(:productDate, 'YYYYMMDD'), 'Y', 'Y', '*'
    )
  `;
  await conn.executeMany(sql, [...groups.values()].map(({ record: r, qty }) => ({
    lotNo: r.lotNo,
    productDate: r.productDate,
    poNo: r.poNo,
    itemCode: r.itemCode,
    modelName: r.modelName,
    lineCode: r.lineCode,
    qty,
  })));
}

async function insertBarcodes(conn: oracledb.Connection, records: SomosMigrationRecord[], state: ExistingState, onProgress?: ProgressFn) {
  const sql = `
    INSERT INTO ip_product_2d_barcode (
      run_no, run_date, item_code, serial_no, label_text, line_code, workstage_code,
      organization_id, enter_date, enter_by, last_modify_date, last_modify_by,
      model_name, barcode_status, actual_date, actual_line_code, is_last
    ) VALUES (
      :lotNo, TO_DATE(:productDate, 'YYYYMMDD'), :itemCode, :ep1, :ep1, :lineCode, 'W030',
      ${ORG_ID}, SYSDATE, '${MIGRATION_USER}', SYSDATE, '${MIGRATION_USER}',
      :modelName, 'N', TO_DATE(:productDate, 'YYYYMMDD'), :lineCode, 1
    )
  `;
  const targets = records.filter((r) => isNewRecord(r, state));
  if (!targets.length) return;
  const allBinds = targets.map((r) => ({ lotNo: r.lotNo, productDate: r.productDate, itemCode: r.itemCode, ep1: r.ep1, lineCode: r.lineCode, modelName: r.modelName }));
  for (let i = 0; i < allBinds.length; i += INSERT_BATCH_SIZE) {
    await conn.executeMany(sql, allBinds.slice(i, i + INSERT_BATCH_SIZE));
    onProgress?.(`2D_BARCODE INSERT: ${Math.min(i + INSERT_BATCH_SIZE, allBinds.length).toLocaleString()} / ${allBinds.length.toLocaleString()}`);
  }
}

async function insertWorkstageRows(conn: oracledb.Connection, records: SomosMigrationRecord[], state: ExistingState, onProgress?: ProgressFn) {
  const ioSql = `
    INSERT INTO ip_product_workstage_io (
      io_date, io_sequence, run_no, item_code, serial_no, line_code, workstage_code,
      io_deficit, io_qty, organization_id, enter_date, enter_by, last_modify_date, last_modify_by,
      model_name, model_suffix, actual_date, shift_code, lot_no
    ) VALUES (
      :ioDate, :ioSequence, :runNo, :itemCode, :serialNo, :lineCode, :workstageCode,
      'I', 1, ${ORG_ID}, SYSDATE, '${MIGRATION_USER}', SYSDATE, '${MIGRATION_USER}',
      :modelName, :modelSuffix, :actualDate, 'A', :lotNo
    )
  `;
  const detailSql = `
    INSERT INTO ip_product_workstage_detail (
      io_date, io_sequence, run_no, model_name, item_code, serial_no, child_item_code,
      scan_barcode, scan_result, line_code, workstage_code, io_deficit, io_qty,
      organization_id, enter_date, enter_by, last_modify_date, last_modify_by, scan_mac_addr
    ) VALUES (
      :ioDate, :ioSequence, :runNo, :modelName, :itemCode, :serialNo, :childItemCode,
      :scanBarcode, 'Y', :lineCode, :workstageCode, 'I', 1,
      ${ORG_ID}, SYSDATE, '${MIGRATION_USER}', SYSDATE, '${MIGRATION_USER}', :scanMacAddr
    )
  `;

  let sequence = await getMaxIoSequence(conn);
  const targets = records.filter((r) => isNewRecord(r, state));
  if (!targets.length) return;

  type IoBind = { ioDate: Date; ioSequence: number; runNo: string; itemCode: string; serialNo: string; lineCode: string; workstageCode: string; modelName: string; modelSuffix: string; actualDate: Date; lotNo: string };
  type DetailBind = { ioDate: Date; ioSequence: number; runNo: string; modelName: string; itemCode: string; serialNo: string; childItemCode: string; scanBarcode: string; lineCode: string; workstageCode: string; scanMacAddr: string };

  const ioBinds: IoBind[] = [];
  const detailBinds: DetailBind[] = [];

  for (const record of targets) {
    const actualDate = excelDateToJsDate(record.productDate);

    const addIo = (serialNo: string, itemCode: string, modelName: string, lc: string, wc: string): number => {
      sequence += 1;
      ioBinds.push({ ioDate: actualDate, ioSequence: sequence, runNo: record.lotNo, serialNo, itemCode, modelName, lineCode: lc, workstageCode: wc, modelSuffix: record.modelSuffix, actualDate, lotNo: record.poNo });
      return sequence;
    };
    const addDetail = (serialNo: string, childItemCode: string, scanBarcode: string, lc: string, wc: string, ioSequence: number, scanMacAddr = '', modelName = record.modelName, itemCode = record.itemCode) => {
      if (!scanBarcode || !childItemCode) return;
      detailBinds.push({ ioDate: actualDate, ioSequence, runNo: record.lotNo, modelName, itemCode, serialNo, childItemCode, scanBarcode, lineCode: lc, workstageCode: wc, scanMacAddr });
    };

    const w010Seq = addIo(record.ep1, record.itemCode, record.modelName, record.lineCode, 'W010');
    addDetail(record.ep1, record.ep2Child, record.ep2, record.lineCode, 'W010', w010Seq, record.ep3);
    addIo(record.ep1, record.itemCode, record.modelName, record.lineCode, 'W020');
    const w030Seq = addIo(record.ep1, record.itemCode, record.modelName, record.lineCode, 'W030');
    addDetail(record.ep1, record.ep4Child, record.ep4, record.lineCode, 'W030', w030Seq);
    addDetail(record.ep1, record.ep5Child, record.ep5, record.lineCode, 'W030', w030Seq);

    if (record.ep4 && record.ep6) {
      const mapping = state.bomMap.get(record.ep4Child);
      if (mapping) {
        const generatedHspaw = `MIG-HSPAW-${record.productDate}-${String(record.rowNo).padStart(6, '0')}`;
        const w530Seq = addIo(record.ep4, record.ep4Child, record.ep4Child, '53', 'W530');
        addDetail(record.ep4, mapping.hspawChild, generatedHspaw, '53', 'W530', w530Seq, '', record.ep4Child, record.ep4Child);
        const w540Seq = addIo(generatedHspaw, mapping.hspawChild, mapping.hspawChild, '55', 'W540');
        addDetail(generatedHspaw, mapping.memwlChild!, record.ep6, '55', 'W540', w540Seq, '', mapping.hspawChild, mapping.hspawChild);
      }
    }
  }

  onProgress?.(`WORKSTAGE_IO ${ioBinds.length.toLocaleString()}건 배치 INSERT 시작`);
  for (let i = 0; i < ioBinds.length; i += INSERT_BATCH_SIZE) {
    await conn.executeMany(ioSql, ioBinds.slice(i, i + INSERT_BATCH_SIZE) as oracledb.BindParameters[]);
    onProgress?.(`WORKSTAGE_IO: ${Math.min(i + INSERT_BATCH_SIZE, ioBinds.length).toLocaleString()} / ${ioBinds.length.toLocaleString()}`);
  }

  const filteredDetailBinds = await filterInsertableDetailBinds(conn, detailBinds, onProgress);
  onProgress?.(`WORKSTAGE_DETAIL ${filteredDetailBinds.length.toLocaleString()}건 배치 INSERT 시작`);
  for (let i = 0; i < filteredDetailBinds.length; i += INSERT_BATCH_SIZE) {
    const chunk = filteredDetailBinds.slice(i, i + INSERT_BATCH_SIZE);
    await insertWorkstageDetailBatch(conn, detailSql, chunk, onProgress);
    onProgress?.(`WORKSTAGE_DETAIL: ${Math.min(i + INSERT_BATCH_SIZE, filteredDetailBinds.length).toLocaleString()} / ${filteredDetailBinds.length.toLocaleString()}`);
  }
}

function detailUniqueKey(serialNo: string, scanBarcode: string): string {
  return `${dbText(serialNo)}\u0001${dbText(scanBarcode)}\u0001${ORG_ID}`;
}

function dbText(value: string): string {
  return String(value ?? '').trim();
}

async function filterInsertableDetailBinds(
  conn: oracledb.Connection,
  detailBinds: Array<{ serialNo: string; scanBarcode: string }>,
  onProgress?: ProgressFn,
) {
  if (!detailBinds.length) return detailBinds;

  const candidateKeys = new Set(detailBinds.map((bind) => detailUniqueKey(bind.serialNo, bind.scanBarcode)));
  const existingKeys = new Set<string>();
  const serials = uniq(detailBinds.map((bind) => dbText(bind.serialNo)));

  for (let i = 0; i < serials.length; i += IN_CHUNK_SIZE) {
    const chunk = serials.slice(i, i + IN_CHUNK_SIZE);
    const binds = Object.fromEntries(chunk.map((value, index) => [`s${index}`, value]));
    const rows = await conn.execute<{ SERIAL_NO: string; SCAN_BARCODE: string }>(
      `
        SELECT serial_no, scan_barcode
          FROM ip_product_workstage_detail
         WHERE organization_id = ${ORG_ID}
           AND serial_no IN (${chunk.map((_, index) => `:s${index}`).join(',')})
      `,
      binds,
      { outFormat: oracledb.OUT_FORMAT_OBJECT },
    );
    for (const row of rows.rows ?? []) {
      const key = detailUniqueKey(String(row.SERIAL_NO), String(row.SCAN_BARCODE));
      if (candidateKeys.has(key)) existingKeys.add(key);
    }
  }

  const seen = new Set<string>();
  const filtered = detailBinds.filter((bind) => {
    const key = detailUniqueKey(bind.serialNo, bind.scanBarcode);
    if (existingKeys.has(key) || seen.has(key)) return false;
    seen.add(key);
    return true;
  });
  const skipped = detailBinds.length - filtered.length;
  if (skipped > 0) onProgress?.(`WORKSTAGE_DETAIL 기존/중복 제외: ${skipped.toLocaleString()}건`);
  return filtered;
}

async function insertWorkstageDetailBatch(
  conn: oracledb.Connection,
  sql: string,
  binds: Array<oracledb.BindParameters & { serialNo?: string; scanBarcode?: string }>,
  onProgress?: ProgressFn,
) {
  if (!binds.length) return;
  const result = await conn.executeMany(sql, binds, { batchErrors: true });
  const errors = result.batchErrors ?? [];
  if (!errors.length) return;

  const duplicateErrors = errors.filter((error) => error.message.includes('ORA-00001'));
  const otherErrors = errors.filter((error) => !error.message.includes('ORA-00001'));
  if (duplicateErrors.length > 0) {
    const samples = duplicateErrors.slice(0, 5).map((error) => {
      const bind = binds[error.offset ?? -1] ?? {};
      return `${String(bind.serialNo ?? '')} / ${String(bind.scanBarcode ?? '')}`;
    });
    onProgress?.(`WORKSTAGE_DETAIL 유니크 중복 skip: ${duplicateErrors.length.toLocaleString()}건${samples.length ? ` (예: ${samples.join(', ')})` : ''}`);
  }
  if (otherErrors.length > 0) {
    const first = otherErrors[0];
    const bind = binds[first.offset ?? -1] ?? {};
    throw new Error(`WORKSTAGE_DETAIL INSERT 실패: ${first.message} (serial=${String(bind.serialNo ?? '')}, scan=${String(bind.scanBarcode ?? '')})`);
  }
}

async function getMaxIoSequence(conn: oracledb.Connection): Promise<number> {
  const result = await conn.execute<{ MAX_SEQ: number }>(
    `SELECT NVL(MAX(io_sequence), 0) AS max_seq FROM ip_product_workstage_io WHERE organization_id = 1 AND io_date >= TRUNC(SYSDATE) - 400`,
    {},
    { outFormat: oracledb.OUT_FORMAT_OBJECT },
  );
  return Number(result.rows?.[0]?.MAX_SEQ ?? 0);
}
