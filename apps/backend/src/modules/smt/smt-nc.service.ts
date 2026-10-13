/**
 * @file src/modules/smt/smt-nc.service.ts
 * @description SMT 피더레이아웃 등록 — PB w_smt_upload_nc_master 이식
 *
 * 초보자 가이드:
 * 1. **흐름**: 설비그룹마다 마운터 NC 파일을 올려 [생성] → 피더 배치(IB_MNT_PLANDATA) →
 *    중복·BOM 대조로 확인 → [적용] 으로 SMT BOM(ID_ENG_BOM_SMT)을 그 배치로 바꾼다.
 * 2. **파일 형식은 삼성 마운터 하나다.** 은성 SMT BOM 의 자리 표기(테이블문자+번지, 트레이 ZTRAY01)와
 *    마지막 적재 흔적(IB_MNT_STEP_INFOR)이 모두 PB 의 삼성 경로(wf_samsung) 결과다. 파나소닉·야마하 경로는
 *    쓰인 흔적이 없어 옮기지 않았다. 파싱은 nc-samsung.parser.ts.
 * 3. **IB_MNT_PLANDATA 는 공용 작업표다.** PB 처럼 [생성] 할 때마다 통째로 지우고 다시 채운다.
 *    [적용]은 작업표가 화면에서 고른 라인·레이아웃 모델의 것인지 확인한 뒤 PB 의 SQL 그대로 반영한다.
 *    PB 가 넣은 행은 ORGANIZATION_ID 가 비어 있어 조회 조건은 NVL 로 감싼다.
 * 4. **중복검증이 왜 따로 있나**: IB_MNT_PLANDATA 에는 유일제약이 없다
 *    (인덱스 INDX_PLANDATA2 는 비유일). NC 파일을 두 번 올리면 같은 자리가
 *    두 줄이 되고, 그러면 피더 대조 수량이 부풀어 배포가 틀린다.
 * 5. **대조는 PKG_DESIGN.BOM_QUERY 로 전개한 BOM 과 맞춰 본다.**
 *    PB d_smt_feeder_bom_compare_lst 와 같은 UNION ALL 구조다.
 *    읽은 세션 행은 지운다 — ID_ENG_BOM_TEMP 는 이미 3,357,661행이 쌓여 있다.
 *    PKG_DESIGN 패키지 본문에 COMMIT 이 한 줄도 없음을 확인했으므로(실측),
 *    전개·조회·정리가 tx.run 의 한 트랜잭션 안에 있다 — 중간에 실패하면 전개행도
 *    함께 롤백된다.
 */
import { BadRequestException, ConflictException, Injectable } from '@nestjs/common';
import { DataSource, QueryRunner } from 'typeorm';
import { TransactionService } from '../../shared/transaction.service';
import {
  SmtNcApplyDto, SmtNcCompareQueryDto, SmtNcGenerateDto, SmtNcQueryDto,
} from './smt-nc.dto';
import { namedBinds } from '../../common/utils/named-binds.util';
import { parseSamsungNc, samsungFeederSlots } from './nc-samsung.parser';

/** 업로드 파일 한 개 (multer memoryStorage) */
export interface NcUploadFile { originalname: string; buffer: Buffer }
interface NcGroup { machineGroup: string; startTableId: string; fileIndex: number }

/** IB_MNT_PLANDATA 한 줄 (PB d_plandata) */
export interface NcPlanRow {
  lotName: string | null; tableId: string | null; address: string | null; position: string | null;
  partName: string | null; chipName: string | null; locationInfo: string | null; feederType: string | null;
  lineCode: string; modelName: string; pcbItem: string; machineGroup: string; machineCode: string;
  itemUnitQty: number;
}

/** PB String(Integer(x), '00') */
const pad2 = (value: string) => {
  const n = /^\s*[+-]?\d+\s*$/.test(value) ? parseInt(value, 10) : 0;
  return String(n).padStart(2, '0');
};

/** 마운터 NC 파일은 ANSI(cp949)다 — PB FileOpen LineMode 와 같게 한 줄씩 나눈다 */
export function decodeNc(buffer: Buffer): string[] {
  const lines = new TextDecoder('euc-kr').decode(buffer).split(/\r\n|\n|\r/);
  if (lines.length > 0 && lines[lines.length - 1] === '') lines.pop();
  return lines;
}

@Injectable()
export class SmtNcService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  private like(value?: string): string {
    return `${(value ?? '').trim()}%`;
  }

  /** NC 파일 행 — 라인의 설비그룹 (PB d_smt_nc_upload_file_name_lst) */
  async findMachineGroups(lineCode: string) {
    return (await this.dataSource.query(
      `SELECT LINE_CODE AS "lineCode", MACHINE_GROUP AS "machineGroup"
         FROM IB_LINE_MASTER WHERE LINE_CODE = :lineCode
        GROUP BY LINE_CODE, MACHINE_GROUP
        ORDER BY MACHINE_GROUP`,
      namedBinds({ lineCode }),
    )) as Array<{ lineCode: string; machineGroup: string }>;
  }

  /** SMT 모델명 목록 (PB uo_smt_model_name_ddlb) */
  async findSmtModels(organizationId: number) {
    return (await this.dataSource.query(
      `SELECT DISTINCT SMT_MODEL_NAME AS "smtModelName" FROM IP_PRODUCT_MODEL_MASTER
        WHERE SMT_MODEL_NAME <> '*' AND ORGANIZATION_ID = :organizationId
        ORDER BY SMT_MODEL_NAME`,
      namedBinds({ organizationId }),
    )) as Array<{ smtModelName: string }>;
  }

  /**
   * 마운터 품번 → 품목코드 (PB wf_samsung · cb_7 의 SELECT INTO).
   * 그 공급처 품목 중 품목코드·품번·규격이 같거나 품번·규격에 들어 있는 것을 찾는다. 없으면 원래 품번을 둔다.
   *
   * **후보가 여럿이면 가장 잘 맞는 하나를 고른다.** PB 의 SELECT INTO 는 여러 행이면 오류를 무시하고 처음
   * 읽힌 행을 썼다 — 순서가 우연이다. 실측(2026-10-13, TS 공급처): 같은 규격의 옛 품목과 새 품목이 함께 걸렸고
   * PB 는 두 번 다 정확히 일치하는 칸이 더 많은 품목을 골랐다. 그 기준을 명시한다:
   * 품목코드 일치 > 품번 일치 > 규격 일치 > 품번·규격 포함 순으로 점수를 더하고, 같으면 최근 등록 품목.
   */
  async mapItemCodes(qr: Pick<QueryRunner, 'query'>, supplierCode: string | undefined, parts: string[]) {
    const map = new Map<string, string>();
    if (!supplierCode) return map;
    for (const part of [...new Set(parts.filter(Boolean))]) {
      const rows = (await qr.query(
        `SELECT ITEM_CODE AS "itemCode" FROM ID_ITEM
          WHERE SUPPLIER_CODE = :supplierCode
            AND (ITEM_CODE = :part OR PART_NO = :part OR INSTR(PART_NO, :part) > 0
                 OR ITEM_SPEC = :part OR INSTR(ITEM_SPEC, :part) > 0)
          ORDER BY CASE WHEN ITEM_CODE = :part THEN 8 ELSE 0 END
                 + CASE WHEN PART_NO = :part THEN 4 ELSE 0 END
                 + CASE WHEN ITEM_SPEC = :part THEN 2 ELSE 0 END
                 + CASE WHEN INSTR(PART_NO, :part) > 0 THEN 1 ELSE 0 END
                 + CASE WHEN INSTR(ITEM_SPEC, :part) > 0 THEN 1 ELSE 0 END DESC,
                   ENTER_DATE DESC NULLS LAST, ITEM_CODE
          FETCH FIRST 1 ROWS ONLY`,
        namedBinds({ supplierCode, part }),
      )) as Array<{ itemCode: string | null }>;
      if (rows[0]?.itemCode) map.set(part, rows[0].itemCode);
    }
    return map;
  }

  /** NC 파일들 → 피더 배치 줄 (DB 는 품번 변환에만 쓴다). generate 와 검증 스크립트가 같이 쓴다. */
  async buildRows(
    qr: Pick<QueryRunner, 'query'>,
    dto: Pick<SmtNcGenerateDto, 'lineCode' | 'pcbItem' | 'layoutModelName' | 'supplierCode'>,
    inputs: Array<{ machineGroup: string; startTableId: string; lines: string[] }>,
  ): Promise<NcPlanRow[]> {
    const rows: NcPlanRow[] = [];
    // PB 는 피더 종류 변수를 파일마다 비우지 않는다 — 부품정보에 없으면 앞 자리 값을 이어 쓴다.
    let feederType: string | null = null;
    for (const input of inputs) {
      const nc = parseSamsungNc(input.lines);
      const slots = samsungFeederSlots(nc.steps, input.startTableId);
      const items = await this.mapItemCodes(qr, dto.supplierCode, slots.map((x) => x.partName));
      for (const slot of slots) {
        const feeders = [...new Set(nc.parts.filter((p) => p.partName === slot.partName).map((p) => p.feeder))];
        if (feeders.length === 1) feederType = feeders[0];
        const itemCode = items.get(slot.partName);
        rows.push({
          lotName: nc.lotName, tableId: slot.tableId || null, address: slot.address || null, position: null,
          partName: itemCode ?? slot.partName, chipName: itemCode ?? slot.partName,
          locationInfo: slot.locationInfo, feederType,
          lineCode: dto.lineCode, modelName: dto.layoutModelName, pcbItem: dto.pcbItem,
          machineGroup: input.machineGroup, machineCode: `${dto.lineCode}${pad2(input.machineGroup)}`,
          itemUnitQty: slot.itemUnitQty,
        });
      }
    }
    return rows;
  }

  /**
   * NC 파일 → 피더 배치 생성 (PB cb_1 Generate → wf_samsung).
   * 설비그룹 순서대로 파일을 읽어 자리를 만들고, 작업표를 지운 뒤 한 트랜잭션으로 채운다.
   */
  async generate(dto: SmtNcGenerateDto, files: NcUploadFile[], organizationId: number, userId: string) {
    let groups: NcGroup[];
    try {
      groups = JSON.parse(dto.groups) as NcGroup[];
    } catch {
      throw new BadRequestException('설비그룹 정보(groups)가 JSON 이 아닙니다.');
    }
    const used = groups.filter((g) => Number.isInteger(g.fileIndex) && g.fileIndex >= 0 && files[g.fileIndex]);
    if (used.length === 0) throw new BadRequestException('NC 파일을 하나 이상 올리세요.');
    const noTable = used.find((g) => !/^[A-Z]$/.test(g.startTableId ?? ''));
    if (noTable) throw new BadRequestException(`설비그룹 ${noTable.machineGroup} 의 시작 테이블을 고르세요.`);

    return this.tx.run(async (qr) => {
      const rows = await this.buildRows(qr, dto, used.map((g) => ({
        machineGroup: g.machineGroup, startTableId: g.startTableId, lines: decodeNc(files[g.fileIndex].buffer),
      })));
      if (rows.length === 0) throw new BadRequestException('파일에서 피더 자리를 찾지 못했습니다. 삼성 마운터 NC 파일인지 확인하세요.');
      const tooLong = rows.find((r) => (r.partName ?? '').length > 30);
      if (tooLong) throw new BadRequestException(`품번이 30자를 넘습니다: ${tooLong.partName}`);

      await qr.query(`DELETE FROM IB_MNT_PLANDATA`);
      for (const r of rows) {
        await qr.query(
          `INSERT INTO IB_MNT_PLANDATA (
             PLAN_DATE, LOT_NAME, TABLE_ID, ADDRESS, POSITION, PARTNAME, CHIPNAME, LOCATION_INFO, FEEDER_TYPE,
             LINE_CODE, MODEL_NAME, PCB_ITEM, MACHINE_GROUP, MACHINE_CODE, ITEM_UNIT_QTY,
             ORGANIZATION_ID, ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE)
           VALUES (NULL, :lotName, :tableId, :address, :position, :partName, :chipName, :locationInfo, :feederType,
             :lineCode, :modelName, :pcbItem, :machineGroup, :machineCode, :itemUnitQty,
             :organizationId, :userId, SYSDATE, :userId, SYSDATE)`,
          namedBinds({ ...r, organizationId, userId }),
        );
      }
      return { count: rows.length, files: used.length };
    });
  }

  /** 작업표 한 줄 지우기 (PB dw_1 DELETE) — 작업표에는 키가 없어 ROWID 로 집는다 */
  async removeRow(rowKey: string) {
    await this.dataSource.query(
      `DELETE FROM IB_MNT_PLANDATA WHERE ROWID = CHARTOROWID(:rowKey)`,
      namedBinds({ rowKey }),
    );
    return { rowKey };
  }

  /**
   * 품번 교체 (PB cb_7 Replace PartNo) — 작업표 품번을 공급처 품목코드로 바꾼다.
   * PB 는 못 찾은 줄에 바로 앞 줄의 품목코드를 넣는 결함이 있었다(변수 재사용). 못 찾으면 그대로 둔다.
   */
  async replacePartNo(supplierCode: string) {
    return this.tx.run(async (qr) => {
      const rows = (await qr.query(
        `SELECT ROWIDTOCHAR(ROWID) AS "rowKey", PARTNAME AS "partName" FROM IB_MNT_PLANDATA`,
      )) as Array<{ rowKey: string; partName: string | null }>;
      const items = await this.mapItemCodes(qr, supplierCode, rows.map((r) => r.partName ?? ''));
      let changed = 0;
      for (const r of rows) {
        const itemCode = r.partName ? items.get(r.partName) : undefined;
        if (!itemCode || itemCode === r.partName) continue;
        await qr.query(
          `UPDATE IB_MNT_PLANDATA SET PARTNAME = :itemCode, CHIPNAME = :itemCode WHERE ROWID = CHARTOROWID(:rowKey)`,
          namedBinds({ itemCode, rowKey: r.rowKey }),
        );
        changed++;
      }
      return { total: rows.length, changed };
    });
  }

  /**
   * SMT BOM 반영 (PB cb_2 Apply) — 작업표의 모델·라인·면 SMT BOM 을 지우고 작업표로 다시 넣는다.
   * Line Mixed 면 작업표에 있는 자리(테이블·번지·위치)만 지운다. INSERT·UPDATE 문장은 PB 그대로다.
   * PB 보다 먼저 막는 것: 작업표가 고른 라인·모델의 것이 아닐 때(다른 사람이 새로 생성), 품목마스터에 없는
   * 품번이 있을 때(TRG_ITEM_CODE_CHECK01 이 어차피 거부한다).
   */
  async apply(dto: SmtNcApplyDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      const check = (await qr.query(
        `SELECT COUNT(*) AS "total",
                SUM(CASE WHEN LINE_CODE = :lineCode AND MODEL_NAME = :layoutModelName THEN 1 ELSE 0 END) AS "mine",
                SUM(CASE WHEN ITEM_UNIT_QTY > 0 AND NOT EXISTS (
                      SELECT 1 FROM ID_ITEM i WHERE i.ITEM_CODE = p.PARTNAME AND i.ORGANIZATION_ID = :organizationId)
                    THEN 1 ELSE 0 END) AS "unknown"
           FROM IB_MNT_PLANDATA p`,
        namedBinds({ lineCode: dto.lineCode, layoutModelName: dto.layoutModelName, organizationId }),
      )) as Array<{ total: number; mine: number; unknown: number }>;
      const total = Number(check[0]?.total ?? 0);
      if (total === 0) throw new BadRequestException('먼저 [생성]으로 피더 배치를 만드세요.');
      if (Number(check[0]?.mine ?? 0) !== total) {
        throw new ConflictException('작업표가 고른 라인·레이아웃 모델의 것이 아닙니다. 다른 사람이 새로 생성했을 수 있으니 다시 생성하세요.');
      }
      if (Number(check[0]?.unknown ?? 0) > 0) {
        throw new BadRequestException(`품목마스터에 없는 품번이 ${check[0].unknown}건 있습니다. [품번 교체]나 행 삭제 후 적용하세요.`);
      }

      const key = dto.mixed
        ? `(PARENT_ITEM_CODE, LINE_CODE, PCB_ITEM, LOCATION_CODE) IN
             (SELECT MODEL_NAME, LINE_CODE, PCB_ITEM, TABLE_ID || ADDRESS || POSITION FROM IB_MNT_PLANDATA)`
        : `(PARENT_ITEM_CODE, LINE_CODE, PCB_ITEM) IN (SELECT MODEL_NAME, LINE_CODE, PCB_ITEM FROM IB_MNT_PLANDATA)`;
      const before = (await qr.query(
        `SELECT (SELECT COUNT(*) FROM ID_ENG_BOM_SMT WHERE ${key} AND ORGANIZATION_ID = :organizationId) AS "bom",
                (SELECT COUNT(*) FROM ID_ENG_BOM_SMT_REPLACE WHERE ${key} AND ORGANIZATION_ID = :organizationId) AS "replace"
           FROM DUAL`,
        namedBinds({ organizationId }),
      )) as Array<{ bom: number; replace: number }>;
      await qr.query(`DELETE FROM ID_ENG_BOM_SMT WHERE ${key} AND ORGANIZATION_ID = :organizationId`, namedBinds({ organizationId }));
      await qr.query(`DELETE FROM ID_ENG_BOM_SMT_REPLACE WHERE ${key} AND ORGANIZATION_ID = :organizationId`, namedBinds({ organizationId }));

      await qr.query(
        `INSERT INTO ID_ENG_BOM_SMT (
           PARENT_ITEM_CODE, CHILD_ITEM_CODE, BOM_LEVEL, DATESET, DATEEND, LOCATION_CODE, ORGANIZATION_ID,
           SORT_SEQUENCE, ITEM_UNIT_QTY, WORKSTAGE_CODE, BOM_WORK_NO, ITEM_TYPE, LINE_TYPE,
           ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE, LOCATION_INFO, LINE_CODE, MACHINE,
           LOSS_RATE, SCRAP_RATE, ASSY_EXPLOSION_YN, ITEM_UNIT_QTY_EXT, LOCATION_CODE_ORG, VERSION, PCB_ITEM,
           MARKING_NO, COMMENTS, TABLE_ID, FEEDER_TYPE, LOCATION_CODE_LAST, FEEDER_SHAFT, REVISION,
           MASTER_MODEL_NAME, MODEL_NAME, SMT_MODEL_NAME)
         SELECT MODEL_NAME, PARTNAME, 1, TRUNC(SYSDATE), TO_DATE('99991231', 'YYYYMMDD'),
                TABLE_ID || ADDRESS || POSITION, :organizationId, 1, ITEM_UNIT_QTY, '*', 0, 'T',
                F_GET_LINE_TYPE_FROM_ITEM(PARTNAME, :organizationId),
                :userId, SYSDATE, :userId, SYSDATE, LOCATION_INFO, LINE_CODE, MACHINE_CODE,
                0, 0, 'Y', ITEM_UNIT_QTY, NULL, 1, PCB_ITEM,
                PARTNAME, 'FROM NC MASTER', TABLE_ID, FEEDER_TYPE, '', '*', :revision,
                :smtModelName, :smtModelName, :smtModelName
           FROM IB_MNT_PLANDATA
          WHERE ITEM_UNIT_QTY > 0`,
        namedBinds({ organizationId, userId, revision: dto.revision, smtModelName: dto.smtModelName }),
      );
      const inserted = (await qr.query(
        `SELECT COUNT(*) AS "cnt" FROM IB_MNT_PLANDATA WHERE ITEM_UNIT_QTY > 0`,
      )) as Array<{ cnt: number }>;

      // 품목의 피더 크기가 비어 있으면 배치의 피더 종류로 채운다 (PB 그대로)
      await qr.query(
        `UPDATE ID_ITEM A
            SET A.FEEDER_SIZE = (SELECT MAX(B.FEEDER_TYPE) FROM IB_MNT_PLANDATA B WHERE A.ITEM_CODE = B.PARTNAME)
          WHERE A.ITEM_CODE IN (SELECT B.PARTNAME FROM IB_MNT_PLANDATA B WHERE A.ITEM_CODE = B.PARTNAME)
            AND A.FEEDER_SIZE IS NULL`,
      );
      return {
        inserted: Number(inserted[0]?.cnt ?? 0),
        deleted: { bom: Number(before[0]?.bom ?? 0), replace: Number(before[0]?.replace ?? 0) },
      };
    });
  }

  /** 적재된 마운터 배치표 조회 — PB dw_plandata 계열이 채우는 표. */
  async find(query: SmtNcQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT ROWIDTOCHAR(p.ROWID) AS "rowKey", CASE WHEN i.ITEM_CODE IS NULL THEN 'N' ELSE 'Y' END AS "itemExists",
              p.LINE_CODE AS "lineCode", p.MACHINE_CODE AS "machineCode",
              p.MACHINE_GROUP AS "machineGroup",
              p.MODEL_NAME AS "modelName", p.LOT_NAME AS "lotName",
              p.TABLE_ID AS "tableId", p.ADDRESS AS "address",
              p.POSITION AS "position", p.PARTNAME AS "partName",
              p.CHIPNAME AS "chipName", p.PCB_ITEM AS "pcbItem",
              p.ITEM_UNIT_QTY AS "itemUnitQty", p.FEEDER_TYPE AS "feederType",
              p.LOCATION_INFO AS "locationInfo", p.PLAN_DATE AS "planDate",
              i.ITEM_NAME AS "partItemName", i.ITEM_SPEC AS "partItemSpec",
              p.ENTER_BY AS "enterBy", p.ENTER_DATE AS "enterDate",
              p.LAST_MODIFY_BY AS "lastModifyBy", p.LAST_MODIFY_DATE AS "lastModifyDate"
         FROM IB_MNT_PLANDATA p
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = p.PARTNAME AND i.ORGANIZATION_ID = :organizationId
        WHERE NVL(p.ORGANIZATION_ID, :organizationId) = :organizationId
          AND NVL(p.LINE_CODE, '*') LIKE :lineCode
          AND NVL(p.MACHINE_CODE, '*') LIKE :machineCode
          AND NVL(p.MODEL_NAME, '*') LIKE :modelName
          AND NVL(p.LOT_NAME, '*') LIKE :lotName
          AND NVL(p.TABLE_ID, '*') LIKE :tableId
        ORDER BY p.LINE_CODE, p.MACHINE_CODE, p.TABLE_ID, p.ADDRESS, p.POSITION`,
      namedBinds({
          organizationId,
          lineCode: this.like(query.lineCode),
          machineCode: this.like(query.machineCode),
          modelName: this.like(query.modelName),
          lotName: this.like(query.lotName),
          tableId: this.like(query.tableId),
        }),
    )) as Record<string, unknown>[];
    return { data: rows, total: rows.length };
  }

  /**
   * 중복검증 — PB d_plandata_4_dup_check_lst.
   *
   * PB 의 GROUP BY 를 그대로 쓴다. 조직을 조건에 추가했다 — PB 는 조직 없이
   * 전 조직을 한 덩어리로 세어 다른 조직의 같은 자리를 중복으로 잡았다.
   */
  async findDuplicates(query: SmtNcQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT COUNT(*) AS "dupCount",
              p.LINE_CODE AS "lineCode", p.MACHINE_CODE AS "machineCode",
              p.LOT_NAME AS "lotName", p.MODEL_NAME AS "modelName",
              p.TABLE_ID AS "tableId", p.ADDRESS AS "address",
              p.POSITION AS "position", p.PCB_ITEM AS "pcbItem",
              MAX(p.PARTNAME) AS "partName",
              MAX(p.LOCATION_INFO) AS "locationInfo"
         FROM IB_MNT_PLANDATA p
        WHERE NVL(p.ORGANIZATION_ID, :organizationId) = :organizationId
          AND NVL(p.LINE_CODE, '*') LIKE :lineCode
          AND NVL(p.MACHINE_CODE, '*') LIKE :machineCode
          AND NVL(p.MODEL_NAME, '*') LIKE :modelName
        GROUP BY p.LINE_CODE, p.MACHINE_CODE, p.LOT_NAME, p.MODEL_NAME,
                 p.TABLE_ID, p.ADDRESS, p.POSITION, p.PCB_ITEM
        HAVING COUNT(*) > 1
        ORDER BY 1 DESC, 2, 3`,
      namedBinds({
          organizationId,
          lineCode: this.like(query.lineCode),
          machineCode: this.like(query.machineCode),
          modelName: this.like(query.modelName),
        }),
    )) as Record<string, unknown>[];
    return { data: rows, total: rows.length };
  }

  /**
   * 피더 ↔ BOM 대조 — PB d_smt_feeder_bom_compare_lst.
   *
   * BOM 쪽은 PKG_DESIGN.BOM_QUERY 로 전개한 세션행, 피더 쪽은 IB_MNT_PLANDATA 다.
   * 품목별로 두 쪽 수량을 나란히 놓고 차이를 낸다 — PB 는 UNION ALL 로 두 묶음을
   * 그냥 붙여 놓고 사람이 눈으로 맞췄다. 여기서는 품목 기준으로 묶어 차이를 계산한다.
   *
   * **피더 쪽은 모델로 걸르지 않는다 (라인 전체).** 묻는 것이 "이 라인이 지금
   * 이 모델을 돌릴 준비가 됐나" 이므로 라인에 실제로 물려 있는 것 전부와 맞추는 것이
   * 맞다. PB 도 같다. 단 IB_MNT_PLANDATA 에 MODEL_NAME 컬럼이 있으므로, 한 라인에
   * 두 모델의 배치가 동시에 적재되는 운영이 생기면 판정이 부풀어 오른다 —
   * 그때는 `NVL(p.MODEL_NAME,'*') LIKE :modelName` 을 추가해야 한다.
   * (현재 이 표는 14행이고 라인별 단일 모델이다.)
   */
  async compareWithBom(query: SmtNcCompareQueryDto, organizationId: number) {
    const pcbItem = query.pcbItem ? `${query.pcbItem}%` : '%';
    return this.tx.run(async (qr) => {
      const sessionRows = (await qr.query(
        `SELECT PKG_DESIGN.BOM_QUERY(:setItemCode, TRUNC(SYSDATE), :organizationId)
                  AS SESSION_ID
           FROM DUAL`,
        namedBinds({ setItemCode: query.setItemCode, organizationId }),
      )) as { SESSION_ID: number }[];
      const sessionId = Number(sessionRows?.[0]?.SESSION_ID ?? 0);
      if (sessionId <= 0) {
        return { sessionId, data: [], total: 0, diffCount: 0 };
      }

      try {
        const rows = (await qr.query(
          `SELECT itemCode AS "itemCode",
                  SUM(bomQty) AS "bomQty", SUM(feederQty) AS "feederQty",
                  SUM(bomRows) AS "bomRows", SUM(feederRows) AS "feederRows"
             FROM (
               SELECT NVL(t.CHILD_ITEM_CODE, '*') AS itemCode,
                      NVL(t.ITEM_UNIT_QTY, 0) AS bomQty, 0 AS feederQty,
                      1 AS bomRows, 0 AS feederRows
                 FROM ID_ENG_BOM_TEMP t, ID_ITEM a
                WHERE t.PARENT_ITEM_CODE = a.ITEM_CODE
                  AND a.ORGANIZATION_ID = t.ORGANIZATION_ID
                  AND t.SESSION_ID = :sessionId
                  AND t.ORGANIZATION_ID = :organizationId
                  AND NVL(a.ITEM_CLASS, '*') LIKE :pcbItem
               UNION ALL
               SELECT NVL(p.PARTNAME, '*'), 0, NVL(p.ITEM_UNIT_QTY, 0), 0, 1
                 FROM IB_MNT_PLANDATA p
                WHERE NVL(p.ORGANIZATION_ID, :organizationId) = :organizationId
                  AND NVL(p.LINE_CODE, '*') LIKE :lineCode
                  AND NVL(p.PCB_ITEM, '*') LIKE :pcbItem
             )
            GROUP BY itemCode
            ORDER BY itemCode`,
          namedBinds({
              sessionId,
              organizationId,
              pcbItem,
              lineCode: this.like(query.lineCode),
            }),
        )) as 
          {
            itemCode: string;
            bomQty: number;
            feederQty: number;
            bomRows: number;
            feederRows: number;
          }[]
        ;

        const data = rows.map((row) => ({
          ...row,
          // 한쪽만 있으면 그 자체가 차이다. 0 과 "없음" 을 섞지 않도록 행수도 같이 내린다.
          onlyInBom: Number(row.feederRows) === 0,
          onlyInFeeder: Number(row.bomRows) === 0,
          qtyDiff: Number(row.feederQty) - Number(row.bomQty),
          diff:
            Number(row.feederRows) === 0
            || Number(row.bomRows) === 0
            || Number(row.feederQty) !== Number(row.bomQty),
        }));
        return {
          sessionId,
          data,
          total: data.length,
          diffCount: data.filter((d) => d.diff).length,
        };
      } finally {
        await qr.query(
          `DELETE FROM ID_ENG_BOM_TEMP
            WHERE SESSION_ID = :sessionId AND ORGANIZATION_ID = :organizationId`,
          namedBinds({ sessionId, organizationId }),
        );
      }
    });
  }
}
