/**
 * @file src/modules/master/services/bom.service.ts
 * @description BOM 비즈니스 로직 서비스 - TypeORM Repository 패턴
 *
 * 초보자 가이드:
 * 1. **findParents**: BOM에 등재된 모품목(부모품목) 목록 조회
 * 2. **findHierarchy**: 부모품목 ID 기준 재귀 트리 구조 조회
 * 3. **CRUD**: 추가/수정/삭제 모두 DB에 반영
 * 4. **exportToExcel**: BOM 데이터를 xlsx 파일로 내보내기
 * 5. **uploadFromExcel**: xlsx 파일에서 BOM 데이터를 읽어 일괄 등록
 */

import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In, FindOptionsWhere } from 'typeorm';
import * as XLSX from 'xlsx';
import { BomMaster } from '../../../entities/bom-master.entity';
import { ItemMaster } from '../../../entities/item-master.entity';
import { CreateBomDto, UpdateBomDto, BomQueryDto } from '../dto/bom.dto';

/** Excel 업로드 결과 인터페이스 */
export interface BomUploadResult {
  inserted: number;
  skipped: number;
  errors: { row: number; message: string }[];
}

/** 업로드 미리보기 행 */
export interface BomPreviewRow {
  row: number;
  parentItemCode: string;
  childItemCode: string;
  validFrom: string | null;
  validTo: string | null;
  qtyPer: number | null;
  revision: string;
  status: 'new' | 'duplicate_db' | 'duplicate_file' | 'error';
  message?: string;
  /** 업로드 시 넣을 BOM 주인(ID_ENG_BOM.ITEM_CODE) */
  ownerItemCode?: string;
}

/** 업로드 미리보기 결과 */
export interface BomPreviewResult {
  rows: BomPreviewRow[];
  duplicateCount: number;
  newCount: number;
  errorCount: number;
}

type BomParentRow = {
  itemCode: string;
  itemName: string | null;
  itemNo: string | null;
  itemType: string | null;
  /** 품목구분 (공통코드 ITEM DIVISION: F 제품 / W 반제품 / R 원자재) — PB ddlb_item_division 과 같은 기준 */
  itemDivision: string | null;
  /** 차종코드 IP_PRODUCT_MODEL_MASTER.PRODUCT_CLASS (공통코드 PRODUCT CLASS, PB 사전 'PRODUCT CLASS' = 차종코드) */
  productClass: string | null;
  /** 고객코드 — 모델마스터 우선, 없으면 ID_ITEM.CUSTOMER_CODE */
  customerCode: string | null;
  spec: string | null;
  unit: string | null;
  remark: string | null;
  bomCount: string | number;
  revisions: string | null;
  validFrom: string | null;
  validTo: string | null;
};

type BomChildRow = {
  parentItemCode: string;
  childItemCode: string;
  revision: string | null;
  qtyPer: number | string;
  seq: number | string;
  bomGrp: string | null;
  processCode: string | null;
  side: string | null;
  ecoNo: string | null;
  validFrom: string | null;
  validTo: string | null;
  useYn?: string;
  remark: string | null;
};

type BomTreeFlatRow = BomChildRow & {
  id: string;
  lvl: number | string;
  itemCode: string;
  itemNo: string | null;
  itemName: string | null;
  itemType: string | null;
  unit: string | null;
  processName: string | null;
};

export type BomTreeNode = {
  id: string;
  level: number;
  parentItemCode: string;
  childItemCode: string;
  itemCode: string;
  itemNo: string | null;
  itemName: string | null;
  itemType: string | null;
  qtyPer: number;
  unit: string | null;
  revision: string;
  seq: number;
  processCode: string | null;
  processName: string | null;
  side: string | null;
  /** 로케이션 (ID_ENG_BOM.LOCATION_INFO, 예: C1,C2,R5) */
  location: string | null;
  validFrom: string | null;
  validTo: string | null;
  useYn: string;
  children: BomTreeNode[];
};

type BomExcelRow = Record<string, unknown>;

@Injectable()
export class BomService {
  constructor(
    @InjectRepository(BomMaster)
    private readonly bomRepository: Repository<BomMaster>,
    @InjectRepository(ItemMaster)
    private readonly partRepository: Repository<ItemMaster>,
  ) {}

  /** BOM에 등재된 모품목(부모품목) 목록 + 자품목 수 (단일 JOIN 쿼리) */
  async findParents(search?: string, effectiveDate?: string, organizationId?: number) {
    try {
      const params: unknown[] = [];
      // 바인드는 SQL 등장 순서대로 push. LIKE 3개도 같은 값이지만 각각 별도 push.
      const bind = (v: unknown): number => { params.push(v); return params.length; };

      let dateFilter = '';
      if (effectiveDate) {
        const f = bind(effectiveDate);
        const t = bind(effectiveDate);
        dateFilter = `AND TRUNC(b.DATESET) <= TO_DATE(:${f}, 'YYYY-MM-DD')
          AND NVL(TRUNC(b.DATEEND), TO_DATE('9999-12-31', 'YYYY-MM-DD')) >= TO_DATE(:${t}, 'YYYY-MM-DD')`;
      }

      let searchFilter = '';
      if (search) {
        const v = `%${search.toUpperCase()}%`;
        const a = bind(v);
        const b = bind(v);
        const c = bind(v);
        searchFilter = `AND (p.ITEM_CODE LIKE :${a} OR p.ITEM_NAME LIKE :${b} OR p.PART_NO LIKE :${c})`;
      }

      let tenantFilter = '';
      if (organizationId != null) tenantFilter += ` AND p.ORGANIZATION_ID = :${bind(organizationId)}`;

      const rows = await this.bomRepository.query<BomParentRow[]>(
        `SELECT p.ITEM_CODE   AS "itemCode",
                p.ITEM_NAME   AS "itemName",
                p.PART_NO     AS "itemNo",
                p.ITEM_TYPE   AS "itemType",
                p.ITEM_DIVISION AS "itemDivision",
                -- 한 품목에 모델이 여럿일 수 있어 조인하지 않고 서브쿼리로 붙인다 (BOM 건수가 불어나지 않게).
                -- 2026-09-30 기준 모품목별 차종·고객은 모두 하나다.
                (SELECT MIN(m.PRODUCT_CLASS) FROM IP_PRODUCT_MODEL_MASTER m
                  WHERE m.ITEM_CODE = p.ITEM_CODE AND m.ORGANIZATION_ID = p.ORGANIZATION_ID) AS "productClass",
                NVL((SELECT MIN(m.CUSTOMER_CODE) FROM IP_PRODUCT_MODEL_MASTER m
                      WHERE m.ITEM_CODE = p.ITEM_CODE AND m.ORGANIZATION_ID = p.ORGANIZATION_ID),
                    p.CUSTOMER_CODE) AS "customerCode",
                p.ITEM_SPEC   AS "spec",
                p.ITEM_UOM    AS "unit",
                p.COMMENTS    AS "remark",
                COUNT(b.CHILD_ITEM_CODE) AS "bomCount",
                TO_CHAR(MIN(b.DATESET), 'YYYY-MM-DD') AS "validFrom",
                TO_CHAR(MAX(b.DATEEND), 'YYYY-MM-DD') AS "validTo",
                CAST(NULL AS VARCHAR2(4000)) AS "revisions"
           FROM ID_ITEM p
           JOIN ID_ENG_BOM b
             ON b.PARENT_ITEM_CODE = p.ITEM_CODE
            AND b.ORGANIZATION_ID = p.ORGANIZATION_ID
          WHERE p.ITEM_CODE <> '*' ${dateFilter} ${searchFilter} ${tenantFilter}
          GROUP BY p.ITEM_CODE, p.ORGANIZATION_ID, p.CUSTOMER_CODE, p.ITEM_NAME, p.PART_NO, p.ITEM_TYPE, p.ITEM_DIVISION,
                   p.ITEM_SPEC, p.ITEM_UOM, p.COMMENTS
          ORDER BY p.ITEM_CODE ASC`,
        params,
      );

      return rows.map((r) => ({
        ...r,
        bomCount: Number(r.bomCount),
        revisions: r.revisions ? r.revisions.split(',') : [],
      }));
    } catch (error) {
      console.error('[BomService.findParents] Error:', error);
      throw error;
    }
  }

  async findAll(query: BomQueryDto, organizationId?: number) {
    const { page = 1, limit = 10, parentItemCode, childItemCode, revision } = query;
    const skip = (page - 1) * limit;

    const where: FindOptionsWhere<BomMaster> = {};
    if (organizationId != null) where.organizationId = organizationId;
    if (parentItemCode) where.parentItemCode = parentItemCode;
    if (childItemCode) where.childItemCode = childItemCode;
    if (revision) where.revision = revision;

    const [bomList, total] = await this.bomRepository.findAndCount({
      where,
      order: { parentItemCode: 'ASC', seq: 'ASC' },
      skip,
      take: limit,
    });

    if (bomList.length === 0) return { data: [], total: 0, page, limit };

    const parentCodes = [...new Set(bomList.map((b) => b.parentItemCode))];
    const childCodes = [...new Set(bomList.map((b) => b.childItemCode))];
    const allCodes = [...new Set([...parentCodes, ...childCodes])];

    const parts = await this.partRepository.find({
      where: { itemCode: In(allCodes), ...(organizationId != null ? { organizationId } : {}) },
      select: ['itemCode', 'itemName', 'itemNo', 'itemType', 'itemClass', 'spec', 'itemUom'],
    });
    const partMap = new Map(parts.map((p) => [p.itemCode, p]));

    const data = bomList.map((b) => ({
      ...b,
      validFrom: this.toDateOnly(b.validFrom),
      validTo: this.toDateOnly(b.validTo),
      parentPart: partMap.get(b.parentItemCode) || null,
      childPart: partMap.get(b.childItemCode) || null,
    }));

    return { data, total, page, limit };
  }

  async findById(id: string, organizationId?: number) {
    // id is composite key encoded as "parentItemCode::childItemCode::validFrom(YYYY-MM-DD)"
    const [parentItemCode, childItemCode, validFromKey] = id.split('::');
    const validFrom = this.keyDate(validFromKey);
    const bom = await this.bomRepository.findOne({
      where: { parentItemCode, childItemCode, ...(validFrom ? { validFrom } : {}), ...(organizationId != null ? { organizationId } : {}) },
    });

    if (!bom) throw new NotFoundException(`BOM을 찾을 수 없습니다: ${id}`);

    const parts = await this.partRepository.find({
      where: { itemCode: In([parentItemCode, childItemCode]), ...(organizationId != null ? { organizationId } : {}) },
      select: ['itemCode', 'itemName', 'itemNo', 'itemType', 'itemClass', 'spec', 'itemUom'],
    });
    const partMap = new Map(parts.map((p) => [p.itemCode, p]));

    return {
      ...bom,
      validFrom: this.toDateOnly(bom.validFrom),
      validTo: this.toDateOnly(bom.validTo),
      parentPart: partMap.get(parentItemCode) || null,
      childPart: partMap.get(childItemCode) || null,
    };
  }

  async findByParentId(parentItemCode: string, effectiveDate?: string, organizationId?: number) {
    const params: unknown[] = [];
    const bind = (v: unknown): number => { params.push(v); return params.length; };

    // WHERE 등장 순서: parent → date → tenant
    const parentIdx = bind(parentItemCode);
    let dateFilter = '';
    if (effectiveDate) {
      const f = bind(effectiveDate);
      const t = bind(effectiveDate);
      dateFilter = `AND TRUNC(b.DATESET) <= TO_DATE(:${f}, 'YYYY-MM-DD')
        AND NVL(TRUNC(b.DATEEND), TO_DATE('9999-12-31', 'YYYY-MM-DD')) >= TO_DATE(:${t}, 'YYYY-MM-DD')`;
    }
    let tenantFilter = '';
    if (organizationId != null) tenantFilter += ` AND b.ORGANIZATION_ID = :${bind(organizationId)}`;

    const rows = await this.bomRepository.query<BomChildRow[]>(
      `SELECT b.PARENT_ITEM_CODE AS "parentItemCode",
              b.CHILD_ITEM_CODE  AS "childItemCode",
              b.REVISION         AS "revision",
              b.ITEM_UNIT_QTY    AS "qtyPer",
              b.SORT_SEQUENCE    AS "seq",
              CAST(NULL AS VARCHAR2(50)) AS "bomGrp",
              b.WORKSTAGE_CODE   AS "processCode",
              b.LINE_TYPE        AS "side",
              CAST(NULL AS VARCHAR2(50)) AS "ecoNo",
              TO_CHAR(b.DATESET, 'YYYY-MM-DD') AS "validFrom",
              TO_CHAR(b.DATEEND, 'YYYY-MM-DD') AS "validTo",
              'Y'                AS "useYn",
              b.LOCATION_INFO    AS "remark"
         FROM ID_ENG_BOM b
        WHERE b.PARENT_ITEM_CODE = :${parentIdx}
          ${dateFilter}
          ${tenantFilter}
        ORDER BY b.SORT_SEQUENCE ASC`,
      params,
    );

    if (rows.length === 0) return [];

    const childCodes = rows.map((r) => r.childItemCode);
    const parts = await this.partRepository.find({
      where: { itemCode: In(childCodes), ...(organizationId != null ? { organizationId } : {}) },
      select: ['itemCode', 'itemName', 'itemNo', 'itemType', 'itemClass', 'spec', 'itemUom'],
    });
    const partMap = new Map(parts.map((p) => [p.itemCode, p]));

    return rows.map((r) => ({
      ...r,
      childPart: partMap.get(r.childItemCode) || null,
    }));
  }

  /** 
   * Oracle CONNECT BY로 BOM 계층 조회 (단일 쿼리)
   * START WITH: 시작 부모 품목
   * CONNECT BY PRIOR: 자식으로 재귀 탐색
   * LEVEL: 계층 깊이
   */
  async findHierarchy(parentItemCode: string, depth: number = 3, effectiveDate?: string, organizationId?: number) {
    const rawResults = await this.queryHierarchyRows(parentItemCode, depth, effectiveDate, organizationId);
    // 평면 데이터를 트리 구조로 변환
    return this.buildTreeFromFlatData(rawResults);
  }

  /** CONNECT BY 평면 행(전개 순서 그대로) — 트리 조회와 엑셀 내보내기가 같은 경로를 쓴다 */
  private async queryHierarchyRows(parentItemCode: string, depth: number, effectiveDate?: string, organizationId?: number) {
    const safeDepth = Math.min(Math.max(Math.floor(Number(depth) || 3), 1), 10);
    const params: (string | number)[] = [];
    // 바인드는 SQL 등장 순서대로 push (oracledb positional). 각 절마다 별도 바인드.
    const bind = (v: string | number): number => {
      params.push(v);
      return params.length;
    };

    // 1) WHERE 절 날짜 필터
    let dateFilter = '';
    if (effectiveDate) {
      const f = bind(effectiveDate);
      const t = bind(effectiveDate);
      dateFilter = `AND TRUNC(b.DATESET) <= TO_DATE(:${f}, 'YYYY-MM-DD')
         AND NVL(TRUNC(b.DATEEND), TO_DATE('9999-12-31', 'YYYY-MM-DD')) >= TO_DATE(:${t}, 'YYYY-MM-DD')`;
    }

    // 2) WHERE 절 테넌트 필터
    let tenantFilterWhere = '';
    if (organizationId != null) tenantFilterWhere += ` AND b.ORGANIZATION_ID = :${bind(organizationId)}`;

    // 3) START WITH
    const parentIdx = bind(parentItemCode);

    // 4) CONNECT BY 절 날짜 필터
    let dateFilterConnect = '';
    if (effectiveDate) {
      const f = bind(effectiveDate);
      const t = bind(effectiveDate);
      dateFilterConnect = `AND TRUNC(b.DATESET) <= TO_DATE(:${f}, 'YYYY-MM-DD')
         AND NVL(TRUNC(b.DATEEND), TO_DATE('9999-12-31', 'YYYY-MM-DD')) >= TO_DATE(:${t}, 'YYYY-MM-DD')`;
    }

    // 5) CONNECT BY 절 테넌트 필터
    let tenantFilterConnect = '';
    if (organizationId != null) tenantFilterConnect += ` AND b.ORGANIZATION_ID = :${bind(organizationId)}`;

    const query = `
      SELECT
        b.PARENT_ITEM_CODE || '::' || b.CHILD_ITEM_CODE || '::' || TO_CHAR(b.DATESET, 'YYYY-MM-DD') AS "id",
        b.PARENT_ITEM_CODE AS "parentItemCode",
        b.CHILD_ITEM_CODE  AS "childItemCode",
        b.ITEM_UNIT_QTY    AS "qtyPer",
        b.SORT_SEQUENCE    AS "seq",
        b.REVISION         AS "revision",
        b.WORKSTAGE_CODE   AS "processCode",
        NULL               AS "processName",
        b.LINE_TYPE        AS "side",
        TO_CHAR(b.DATESET, 'YYYY-MM-DD') AS "validFrom",
        TO_CHAR(b.DATEEND, 'YYYY-MM-DD') AS "validTo",
        'Y'                AS "useYn",
        b.LOCATION_INFO    AS "remark",
        p.ITEM_CODE        AS "itemCode",
        p.ITEM_NAME        AS "itemName",
        p.PART_NO          AS "itemNo",
        p.ITEM_TYPE        AS "itemType",
        p.ITEM_UOM         AS "unit",
        LEVEL              AS "lvl"
      FROM ID_ENG_BOM b
      JOIN ID_ITEM p
        ON b.CHILD_ITEM_CODE = p.ITEM_CODE
       AND b.ORGANIZATION_ID = p.ORGANIZATION_ID
      WHERE 1 = 1
        ${dateFilter}
        ${tenantFilterWhere}
      START WITH b.PARENT_ITEM_CODE = :${parentIdx}
      CONNECT BY PRIOR b.CHILD_ITEM_CODE = b.PARENT_ITEM_CODE
        AND LEVEL <= ${safeDepth}
        ${dateFilterConnect}
        ${tenantFilterConnect}
      ORDER SIBLINGS BY b.SORT_SEQUENCE ASC
    `;

    return this.bomRepository.query<BomTreeFlatRow[]>(query, params);
  }

  /**
   * 평면 데이터를 트리 구조로 변환.
   * CONNECT BY 결과는 전개 순서(부모 바로 뒤에 자식)로 오므로 LEVEL 스택으로 부모를 잡는다.
   * 품목코드로 부모를 찾으면 같은 반제품이 한 트리에 두 번 나올 때 자식이 마지막 것에만 붙는다.
   */
  private buildTreeFromFlatData(rows: BomTreeFlatRow[]): BomTreeNode[] {
    const roots: BomTreeNode[] = [];
    const stack: BomTreeNode[] = [];

    for (const row of rows) {
      const node: BomTreeNode = {
        id: row.id,
        level: Number(row.lvl),
        parentItemCode: row.parentItemCode,
        childItemCode: row.childItemCode,
        itemCode: row.itemCode,
        itemNo: row.itemNo,
        itemName: row.itemName,
        itemType: row.itemType,
        qtyPer: Number(row.qtyPer),
        unit: row.unit,
        revision: row.revision ?? '',
        seq: Number(row.seq),
        processCode: row.processCode,
        processName: row.processName,
        side: row.side,
        location: row.remark,
        validFrom: row.validFrom,
        validTo: row.validTo,
        useYn: row.useYn ?? 'Y',
        children: [],
      };
      // 바로 위 레벨의 마지막 행이 부모다. 품목이 안 맞으면(WHERE 절로 부모 행이 빠진 경우) 최상위로 둔다.
      const parent = node.level > 1 ? stack[node.level - 2] : undefined;
      if (parent && parent.childItemCode === node.parentItemCode) {
        parent.children.push(node);
      } else {
        roots.push(node);
      }
      stack[node.level - 1] = node;
      stack.length = node.level;
    }

    return roots;
  }

  /**
   * 날짜형 값(문자열/Date)을 YYYY-MM-DD로 정규화 (실패 시 null).
   * BOM 중복 판정 키(모품목+자품목+적용일자)를 등록/미리보기/업로드에서 동일하게 만들기 위한 단일 경로.
   */
  private toDateOnly(value: unknown): string | null {
    if (!value) return null;
    if (value instanceof Date) {
      if (isNaN(value.getTime())) return null;
      const y = value.getFullYear();
      const m = String(value.getMonth() + 1).padStart(2, '0');
      const d = String(value.getDate()).padStart(2, '0');
      return `${y}-${m}-${d}`;
    }
    const s = String(value).trim();
    if (!s) return null;
    if (/^\d{4}-\d{2}-\d{2}$/.test(s)) return s;
    const parsed = new Date(s);
    if (isNaN(parsed.getTime())) return null;
    return this.toDateOnly(parsed);
  }

  /**
   * 엑셀 셀 값을 YYYY-MM-DD로 변환 (실패 시 null).
   * 날짜 서식 셀은 sheet_to_json 이 일련번호(예: 44337 = 2021-05-21)로 넘기므로 숫자를 먼저 날짜로 바꾼다.
   * 문자열은 2021-05-21 · 2021/5/21 · 2021.05.21 · 20210521 · 숫자만 있는 일련번호를 받는다.
   */
  private excelDateOnly(value: unknown): string | null {
    const ymd = (y: number, m: number, d: number): string | null => {
      if (y < 1900 || y > 9999 || m < 1 || m > 12 || d < 1) return null;
      const dt = new Date(y, m - 1, d);
      if (dt.getFullYear() !== y || dt.getMonth() !== m - 1 || dt.getDate() !== d) return null;
      return `${y}-${String(m).padStart(2, '0')}-${String(d).padStart(2, '0')}`;
    };
    const fromSerial = (n: number): string | null => {
      if (!Number.isFinite(n) || n < 1) return null;
      const p = XLSX.SSF.parse_date_code(n);
      return p ? ymd(p.y, p.m, p.d) : null;
    };

    if (value === null || value === undefined || value === '') return null;
    if (typeof value === 'number') return fromSerial(value);
    if (value instanceof Date) {
      if (isNaN(value.getTime())) return null;
      return ymd(value.getFullYear(), value.getMonth() + 1, value.getDate());
    }
    const s = String(value).trim();
    if (!s) return null;
    if (/^\d{8}$/.test(s)) return ymd(Number(s.slice(0, 4)), Number(s.slice(4, 6)), Number(s.slice(6, 8)));
    if (/^\d+(\.\d+)?$/.test(s)) return fromSerial(Number(s));
    const m = /^(\d{4})[-./](\d{1,2})[-./](\d{1,2})(?:[ T].*)?$/.exec(s);
    if (m) return ymd(Number(m[1]), Number(m[2]), Number(m[3]));
    return null;
  }

  /**
   * 날짜형 값을 로컬(서버 KST) 자정 Date로 변환 — PK VALID_FROM 조회/저장 값 단일 경로.
   * new Date('YYYY-MM-DD')는 UTC 자정(KST 09:00)이라 DB의 자정 값과 어긋난다.
   */
  private keyDate(value: unknown): Date | null {
    const s = this.toDateOnly(value);
    if (!s) return null;
    const [y, m, d] = s.split('-').map(Number);
    return new Date(y, m - 1, d);
  }

  /**
   * 신규 BOM 행의 필수 코드값 — 기존 엑셀 등록과 같은 값(운영 데이터 전부 T/T/*).
   * ITEM_TYPE·LINE_TYPE·WORKSTAGE_CODE 는 NOT NULL 이고 DB 기본값이 없다.
   */
  private newRowCodes(processCode?: string | null): Pick<BomMaster, 'itemType' | 'lineType' | 'processCode'> {
    return { itemType: 'T', lineType: 'T', processCode: processCode?.trim() || '*' };
  }

  /**
   * 상위품목별 기존 BOM 주인(ITEM_CODE). 같은 상위품목의 하위 행 중 가장 많이 쓰인 주인을 돌려준다(동률이면 코드순 앞).
   * 하위 행이 없는 상위품목은 결과에 없다.
   */
  private async findExistingOwners(parentCodes: string[], organizationId?: number): Promise<Map<string, string>> {
    const owners = new Map<string, string>();
    const codes = [...new Set(parentCodes.filter(Boolean))];
    for (let i = 0; i < codes.length; i += 500) {
      const chunk = codes.slice(i, i + 500);
      const params: unknown[] = [...chunk];
      const inList = chunk.map((_, idx) => `:${idx + 1}`).join(', ');
      let tenant = '';
      if (organizationId != null) { params.push(organizationId); tenant = `AND ORGANIZATION_ID = :${params.length}`; }
      const rows = await this.bomRepository.query<{ parentItemCode: string; ownerItemCode: string; cnt: number | string }[]>(
        `SELECT PARENT_ITEM_CODE AS "parentItemCode", ITEM_CODE AS "ownerItemCode", COUNT(*) AS "cnt"
           FROM ID_ENG_BOM
          WHERE PARENT_ITEM_CODE IN (${inList}) AND ITEM_CODE IS NOT NULL ${tenant}
          GROUP BY PARENT_ITEM_CODE, ITEM_CODE
          ORDER BY PARENT_ITEM_CODE, COUNT(*) DESC, ITEM_CODE`,
        params,
      );
      for (const r of rows) {
        if (!owners.has(r.parentItemCode)) owners.set(r.parentItemCode, r.ownerItemCode);
      }
    }
    return owners;
  }

  /**
   * 업로드 파일의 상위품목별 BOM 주인.
   * 상위품목에서 시작해 파일 안의 부모를 따라 올라가며, 처음 만나는 "DB 에 이미 하위 행이 있는 품목"의 주인을 쓴다.
   * 끝까지 없으면 파일 안의 최상위 상위품목(다른 행의 하위로 나오지 않는 품목)이 주인이다.
   * 한 품목이 파일 안에서 여러 부모 아래 나오면 파일에서 먼저 나온 부모를 따른다.
   */
  private async resolveUploadOwners(pairs: { parent: string; child: string }[], organizationId?: number): Promise<Map<string, string>> {
    const fileParentOf = new Map<string, string>();
    for (const { parent, child } of pairs) {
      if (parent && child && parent !== child && !fileParentOf.has(child)) fileParentOf.set(child, parent);
    }
    const chains = new Map<string, string[]>();
    for (const { parent } of pairs) {
      if (!parent || chains.has(parent)) continue;
      const chain = [parent];
      const seen = new Set(chain);
      let cur = fileParentOf.get(parent);
      while (cur && !seen.has(cur)) { chain.push(cur); seen.add(cur); cur = fileParentOf.get(cur); }
      chains.set(parent, chain);
    }
    const dbOwners = await this.findExistingOwners([...new Set([...chains.values()].flat())], organizationId);
    const result = new Map<string, string>();
    for (const [parent, chain] of chains) {
      const withOwner = chain.find((code) => dbOwners.has(code));
      result.set(parent, withOwner ? dbOwners.get(withOwner)! : chain[chain.length - 1]);
    }
    return result;
  }

  /**
   * 이 BOM 행(상위→하위)을 함께 쓰는 최상위 제품 목록.
   * 상위품목에서 위로 거슬러 올라가 더 위 부모가 없는 품목을 모은다('*' 루트 행은 부모로 보지 않는다).
   * 상위품목 자신이 최상위면 그 품목 하나다.
   */
  async findUsage(parentItemCode: string, organizationId?: number) {
    const params: unknown[] = [];
    const bind = (v: unknown): number => { params.push(v); return params.length; };
    // 바인드는 SQL 등장 순서대로 push (oracledb positional)
    const startIdx = bind(parentItemCode);
    const tenantStart = organizationId != null ? `AND b.ORGANIZATION_ID = :${bind(organizationId)}` : '';
    const tenantConnect = organizationId != null ? `AND b.ORGANIZATION_ID = :${bind(organizationId)}` : '';
    const rows = await this.bomRepository.query<{ itemCode: string }[]>(
      `SELECT DISTINCT b.PARENT_ITEM_CODE AS "itemCode"
         FROM ID_ENG_BOM b
        WHERE CONNECT_BY_ISLEAF = 1
        START WITH b.CHILD_ITEM_CODE = :${startIdx} AND b.PARENT_ITEM_CODE <> '*' ${tenantStart}
        CONNECT BY NOCYCLE PRIOR b.PARENT_ITEM_CODE = b.CHILD_ITEM_CODE AND b.PARENT_ITEM_CODE <> '*' ${tenantConnect}`,
      params,
    );
    const topCodes = rows.length > 0 ? rows.map((r) => r.itemCode) : [parentItemCode];
    const parts = await this.partRepository.find({
      where: { itemCode: In(topCodes), ...(organizationId != null ? { organizationId } : {}) },
      select: ['itemCode', 'itemName', 'itemNo'],
    });
    const partMap = new Map(parts.map((p) => [p.itemCode, p]));
    const topItems = topCodes
      .map((code) => ({ itemCode: code, itemNo: partMap.get(code)?.itemNo ?? null, itemName: partMap.get(code)?.itemName ?? null }))
      .sort((a, b) => a.itemCode.localeCompare(b.itemCode));
    return { parentItemCode, topItems, count: topItems.length };
  }

  async create(dto: CreateBomDto, organizationId?: number, userId?: string) {
    if (dto.parentItemCode === dto.childItemCode) {
      throw new ConflictException('상위 품목과 하위 품목이 같을 수 없습니다.');
    }

    const validFromYmd = this.toDateOnly(dto.validFrom);
    if (!validFromYmd) {
      throw new ConflictException('적용일자(validFrom)는 필수입니다. (YYYY-MM-DD)');
    }

    const existing = await this.bomRepository.find({
      where: {
        parentItemCode: dto.parentItemCode,
        childItemCode: dto.childItemCode,
        ...(organizationId != null ? { organizationId } : {}),
      },
      select: ['validFrom'],
    });
    if (existing.some((b) => this.toDateOnly(b.validFrom) === validFromYmd)) {
      throw new ConflictException('동일 상위·하위 품목에 같은 적용일자의 BOM이 이미 존재합니다.');
    }

    // BOM 주인(ITEM_CODE): 상위품목에 이미 하위 행이 있으면 그 행들의 주인을 따른다(같은 부모의 형제가 함께 전개되도록).
    // 처음 만드는 상위품목이면 화면에서 보고 있는 최상위 제품, 그것도 없으면 상위품목 자신.
    const existingOwner = (await this.findExistingOwners([dto.parentItemCode], organizationId)).get(dto.parentItemCode);
    const ownerItemCode = existingOwner ?? (dto.topItemCode?.trim() || dto.parentItemCode);

    const bom = this.bomRepository.create({
      parentItemCode: dto.parentItemCode,
      childItemCode: dto.childItemCode,
      qtyPer: dto.qtyPer,
      seq: dto.seq ?? 0,
      revision: dto.revision ?? 'A',
      bomGrp: dto.bomGrp,
      ...this.newRowCodes(dto.processCode),
      itemCode: ownerItemCode,
      side: dto.side,
      ecoNo: dto.ecoNo,
      validFrom: this.keyDate(validFromYmd)!,
      validTo: this.keyDate(dto.validTo) ?? undefined,
      remark: dto.remark,
      useYn: dto.useYn ?? 'Y',
      organizationId,
      createdBy: userId ?? null,
      updatedBy: userId ?? null,
    });

    await this.bomRepository.save(bom);
    return this.findById(`${bom.parentItemCode}::${bom.childItemCode}::${validFromYmd}`, organizationId);
  }

  async update(id: string, dto: UpdateBomDto, organizationId?: number) {
    const bom = await this.findById(id, organizationId);

    const updateData: Partial<Pick<BomMaster, 'qtyPer' | 'seq' | 'revision' | 'processCode' | 'lineType' | 'validFrom' | 'validTo' | 'remark'>> = {};
    if (dto.qtyPer !== undefined) updateData.qtyPer = dto.qtyPer;
    if (dto.seq !== undefined) updateData.seq = dto.seq;
    if (dto.processCode !== undefined) updateData.processCode = dto.processCode;
    // dto.side 는 저장하지 않는다 — 화면 '사이드'(BOM_SIDE N/L/R)와 LINE_TYPE(T/G)은 뜻이 다르다.
    if (dto.revision !== undefined) updateData.revision = dto.revision;
    if (dto.validTo !== undefined) updateData.validTo = this.keyDate(dto.validTo);
    if (dto.remark !== undefined) updateData.remark = dto.remark;

    // 적용일자는 PK — 변경 시 동일 모+자에 같은 적용일자가 이미 있으면 중복
    const oldValidFrom = this.toDateOnly(bom.validFrom);
    const newValidFrom = this.toDateOnly(dto.validFrom);
    if (newValidFrom && newValidFrom !== oldValidFrom) {
      const siblings = await this.bomRepository.find({
        where: {
          parentItemCode: bom.parentItemCode,
          childItemCode: bom.childItemCode,
          ...(organizationId != null ? { organizationId } : {}),
        },
        select: ['validFrom'],
      });
      if (siblings.some((b) => this.toDateOnly(b.validFrom) === newValidFrom)) {
        throw new ConflictException('동일 상위·하위 품목에 같은 적용일자의 BOM이 이미 존재합니다.');
      }
      updateData.validFrom = this.keyDate(newValidFrom)!;
    }

    await this.bomRepository.update(
      {
        parentItemCode: bom.parentItemCode,
        childItemCode: bom.childItemCode,
        ...(oldValidFrom ? { validFrom: this.keyDate(oldValidFrom)! } : {}),
        ...(organizationId != null ? { organizationId } : {}),
      },
      updateData,
    );
    return this.findById(
      `${bom.parentItemCode}::${bom.childItemCode}::${newValidFrom ?? oldValidFrom ?? ''}`,
      organizationId,
    );
  }

  async delete(id: string, organizationId?: number) {
    const bom = await this.findById(id, organizationId);
    const validFrom = this.keyDate(bom.validFrom);
    await this.bomRepository.delete({
      parentItemCode: bom.parentItemCode,
      childItemCode: bom.childItemCode,
      ...(validFrom ? { validFrom } : {}),
      ...(organizationId != null ? { organizationId } : {}),
    });
    return { id };
  }

  /** BOM 데이터를 Excel(xlsx) 파일로 내보내기 */
  async exportToExcel(parentItemCode?: string, organizationId?: number, effectiveDate?: string): Promise<Buffer> {
    if (parentItemCode) return this.exportTreeToExcel(parentItemCode, organizationId, effectiveDate);

    const where: FindOptionsWhere<BomMaster> = {};
    if (organizationId != null) where.organizationId = organizationId;

    const bomList = await this.bomRepository.find({ where, order: { parentItemCode: 'ASC', seq: 'ASC' } });
    const headers = ['상위품목코드', '하위품목코드', '소요량', '리비전', '순서', 'BOM그룹', '공정코드', '사이드', 'ECO번호', '유효시작일', '유효종료일', '비고'];
    const fmtDate = (d: Date | null) => this.toDateOnly(d) ?? '';
    const rows = bomList.length > 0
      ? bomList.map((b) => [b.parentItemCode, b.childItemCode, b.qtyPer, b.revision, b.seq, b.bomGrp ?? '', b.processCode ?? '', b.lineType ?? '', b.ecoNo ?? '', fmtDate(b.validFrom), fmtDate(b.validTo), b.remark ?? ''])
      : [Array(headers.length).fill('')];

    const ws = XLSX.utils.aoa_to_sheet([headers, ...rows]);
    ws['!cols'] = [{ wch: 20 }, { wch: 20 }, { wch: 10 }, { wch: 10 }, { wch: 8 }, { wch: 15 }, { wch: 15 }, { wch: 10 }, { wch: 15 }, { wch: 14 }, { wch: 14 }, { wch: 30 }];
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'BOM');
    return XLSX.write(wb, { type: 'buffer', bookType: 'xlsx' }) as Buffer;
  }

  /**
   * 선택한 모품목의 BOM 을 화면 트리와 같은 경로(CONNECT BY, 10레벨)로 전부 펼쳐 내보낸다.
   * 업로드 양식의 열 이름(상위품목코드·하위품목코드·소요량…)을 그대로 쓰고 레벨·품번·품명·단위 열을 덧붙인다.
   */
  private async exportTreeToExcel(parentItemCode: string, organizationId?: number, effectiveDate?: string): Promise<Buffer> {
    const flat = await this.queryHierarchyRows(parentItemCode, 10, effectiveDate, organizationId);
    const headers = ['레벨', '상위품목코드', '하위품목코드', '하위품번', '하위품명', '단위', '소요량', '리비전', '순서', '공정코드', '사이드', '유효시작일', '유효종료일', '비고'];
    const rows = flat.length > 0
      ? flat.map((r) => [
          Number(r.lvl), r.parentItemCode, r.childItemCode, r.itemNo ?? '', r.itemName ?? '', r.unit ?? '',
          Number(r.qtyPer), r.revision ?? '', Number(r.seq), r.processCode ?? '', r.side ?? '',
          r.validFrom ?? '', r.validTo ?? '', r.remark ?? '',
        ])
      : [Array(headers.length).fill('')];

    const ws = XLSX.utils.aoa_to_sheet([headers, ...rows]);
    ws['!cols'] = [{ wch: 6 }, { wch: 18 }, { wch: 18 }, { wch: 20 }, { wch: 32 }, { wch: 6 }, { wch: 10 }, { wch: 8 }, { wch: 8 }, { wch: 10 }, { wch: 8 }, { wch: 12 }, { wch: 12 }, { wch: 30 }];
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'BOM');
    return XLSX.write(wb, { type: 'buffer', bookType: 'xlsx' }) as Buffer;
  }

  /** 업로드 양식용 빈 xlsx 템플릿 반환 (헤더 행만 포함) */
  downloadTemplate(): Buffer {
    const headers = ['상위품목코드', '하위품목코드', '소요량', '리비전', '순서', 'BOM그룹', '공정코드', '사이드', 'ECO번호', '유효시작일', '유효종료일', '비고'];
    const ws = XLSX.utils.aoa_to_sheet([headers]);
    ws['!cols'] = [{ wch: 20 }, { wch: 20 }, { wch: 10 }, { wch: 10 }, { wch: 8 }, { wch: 15 }, { wch: 15 }, { wch: 10 }, { wch: 15 }, { wch: 14 }, { wch: 14 }, { wch: 30 }];
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'BOM');
    return XLSX.write(wb, { type: 'buffer', bookType: 'xlsx' }) as Buffer;
  }

  /** 업로드 미리보기 — 중복(모+자+유효시작일) 및 오류 행 사전 확인 */
  async previewUpload(buffer: Buffer, organizationId?: number): Promise<BomPreviewResult> {
    const wb = XLSX.read(buffer, { type: 'buffer' });
    const jsonRows = XLSX.utils.sheet_to_json<BomExcelRow>(wb.Sheets[wb.SheetNames[0]], { defval: '' });
    const str = (v: unknown) => String(v ?? '').trim();
    const fmtDate = (v: unknown): string | null => this.excelDateOnly(v);

    const rows: BomPreviewRow[] = [];
    const fileKeySet = new Set<string>();
    const dbKeys: { parentItemCode: string; childItemCode: string; validFrom: Date | null }[] = [];

    for (let i = 0; i < jsonRows.length; i++) {
      const r = jsonRows[i];
      const rowNum = i + 2;
      const parentCode = str(r['상위품목코드']);
      const childCode = str(r['하위품목코드']);
      const qtyRaw = r['소요량'];
      const revision = str(r['리비전']) || 'A';
      const validFrom = fmtDate(r['유효시작일']);
      const validTo = fmtDate(r['유효종료일']);

      if (!parentCode || !childCode) {
        rows.push({ row: rowNum, parentItemCode: parentCode, childItemCode: childCode, validFrom, validTo, qtyPer: null, revision, status: 'error', message: '상위/하위품목코드 필수' });
        continue;
      }
      if (!validFrom || !validTo) {
        rows.push({ row: rowNum, parentItemCode: parentCode, childItemCode: childCode, validFrom, validTo, qtyPer: qtyRaw === '' || qtyRaw === null || isNaN(Number(qtyRaw)) ? null : Number(qtyRaw), revision, status: 'error', message: '유효시작일·유효종료일이 비었거나 날짜가 아님' });
        continue;
      }
      if (qtyRaw === '' || qtyRaw === null || isNaN(Number(qtyRaw))) {
        rows.push({ row: rowNum, parentItemCode: parentCode, childItemCode: childCode, validFrom, validTo, qtyPer: null, revision, status: 'error', message: '소요량 누락 또는 숫자 아님' });
        continue;
      }
      if (parentCode === childCode) {
        rows.push({ row: rowNum, parentItemCode: parentCode, childItemCode: childCode, validFrom, validTo, qtyPer: Number(qtyRaw), revision, status: 'error', message: '상위=하위 불가' });
        continue;
      }

      const fileKey = `${parentCode}::${childCode}::${validFrom ?? ''}`;
      if (fileKeySet.has(fileKey)) {
        rows.push({ row: rowNum, parentItemCode: parentCode, childItemCode: childCode, validFrom, validTo, qtyPer: Number(qtyRaw), revision, status: 'duplicate_file', message: '파일 내 중복 (동일 모·자·적용일자)' });
        continue;
      }
      fileKeySet.add(fileKey);
      dbKeys.push({ parentItemCode: parentCode, childItemCode: childCode, validFrom: this.keyDate(validFrom) });
      rows.push({ row: rowNum, parentItemCode: parentCode, childItemCode: childCode, validFrom, validTo, qtyPer: Number(qtyRaw), revision, status: 'new' });
    }

    // DB 중복 확인 (모+자+유효시작일)
    if (dbKeys.length > 0) {
      const existBoms = await this.bomRepository.find({
        where: dbKeys.map((k) => ({
          parentItemCode: k.parentItemCode,
          childItemCode: k.childItemCode,
          ...(organizationId != null ? { organizationId } : {}),
        })),
        select: ['parentItemCode', 'childItemCode', 'validFrom'],
      });
      // DB 기존 행의 모+자+유효시작일(PK) 키 셋
      const dbKeySet = new Set(existBoms.map((b) => `${b.parentItemCode}::${b.childItemCode}::${this.toDateOnly(b.validFrom) ?? ''}`));

      for (const row of rows) {
        if (row.status !== 'new') continue;
        const key = `${row.parentItemCode}::${row.childItemCode}::${row.validFrom ?? ''}`;
        if (dbKeySet.has(key)) {
          row.status = 'duplicate_db';
          row.message = 'DB에 동일 모·자·적용일자 존재';
        }
      }
    }

    // 업로드 때 들어갈 BOM 주인을 미리 보여준다 (uploadFromExcel 과 같은 규칙)
    const okRows = rows.filter((r) => r.status !== 'error');
    if (okRows.length > 0) {
      const owners = await this.resolveUploadOwners(okRows.map((r) => ({ parent: r.parentItemCode, child: r.childItemCode })), organizationId);
      for (const r of okRows) r.ownerItemCode = owners.get(r.parentItemCode) ?? r.parentItemCode;
    }

    const duplicateCount = rows.filter((r) => r.status === 'duplicate_db' || r.status === 'duplicate_file').length;
    const newCount = rows.filter((r) => r.status === 'new').length;
    const errorCount = rows.filter((r) => r.status === 'error').length;
    return { rows, duplicateCount, newCount, errorCount };
  }

  /** Excel(xlsx)에서 BOM 일괄 등록 (신규만 INSERT, 기존 PK 스킵) */
  async uploadFromExcel(buffer: Buffer, organizationId?: number, userId?: string): Promise<BomUploadResult> {
    const wb = XLSX.read(buffer, { type: 'buffer' });
    const jsonRows = XLSX.utils.sheet_to_json<BomExcelRow>(wb.Sheets[wb.SheetNames[0]], { defval: '' });
    if (jsonRows.length === 0) return { inserted: 0, skipped: 0, errors: [{ row: 2, message: '데이터가 없습니다.' }] };

    /* 1) 품목코드 일괄 존재 확인 */
    const allItemCodes = new Set<string>();
    for (const row of jsonRows) {
      const p = String(row['상위품목코드'] ?? '').trim();
      const c = String(row['하위품목코드'] ?? '').trim();
      if (p) allItemCodes.add(p);
      if (c) allItemCodes.add(c);
    }
    const parts = allItemCodes.size > 0
      ? await this.partRepository.find({
          where: { itemCode: In([...allItemCodes]), ...(organizationId != null ? { organizationId } : {}) },
          select: ['itemCode'],
        })
      : [];
    const validCodes = new Set(parts.map((p) => p.itemCode));

    /* 2) 기존 BOM 일괄 조회 — 중복 스킵 판정은 PK인 모+자+적용일자 (미리보기와 동일 규칙) */
    const pairList = jsonRows
      .map((r) => ({ p: String(r['상위품목코드'] ?? '').trim(), c: String(r['하위품목코드'] ?? '').trim() }))
      .filter((pk) => pk.p && pk.c);
    const existBoms = pairList.length > 0
      ? await this.bomRepository.find({
          where: pairList.map((pk) => ({
            parentItemCode: pk.p,
            childItemCode: pk.c,
            ...(organizationId != null ? { organizationId } : {}),
          })),
          select: ['parentItemCode', 'childItemCode', 'validFrom'],
        })
      : [];
    // BOM 주인(ITEM_CODE): 행마다 파일 안 자기 계통의 최상위 상위품목 (resolveUploadOwners 규칙)
    const ownerByParent = await this.resolveUploadOwners(pairList.map((pk) => ({ parent: pk.p, child: pk.c })), organizationId);
    const existValidSet = new Set(existBoms.map((b) => `${b.parentItemCode}::${b.childItemCode}::${this.toDateOnly(b.validFrom) ?? ''}`));

    /* 3) 행별 검증 및 INSERT */
    const result: BomUploadResult = { inserted: 0, skipped: 0, errors: [] };
    const doneValidSet = new Set<string>();
    const str = (v: unknown) => String(v ?? '').trim();

    for (let i = 0; i < jsonRows.length; i++) {
      const row = jsonRows[i];
      const rowNum = i + 2;
      const parentCode = str(row['상위품목코드']);
      const childCode = str(row['하위품목코드']);
      const qtyRaw = row['소요량'];
      const revision = str(row['리비전']) || 'A';
      const validFrom = this.excelDateOnly(row['유효시작일']);
      const validTo = this.excelDateOnly(row['유효종료일']);

      if (!parentCode || !childCode) { result.errors.push({ row: rowNum, message: '상위품목코드, 하위품목코드는 필수입니다.' }); continue; }
      if (qtyRaw === '' || qtyRaw === null || qtyRaw === undefined || isNaN(Number(qtyRaw))) { result.errors.push({ row: rowNum, message: '소요량이 누락되었거나 숫자가 아닙니다.' }); continue; }
      if (!validFrom || !validTo) { result.errors.push({ row: rowNum, message: '유효시작일·유효종료일이 비었거나 날짜가 아닙니다. (예: 2026-10-12)' }); continue; }
      if (parentCode === childCode) { result.errors.push({ row: rowNum, message: '상위 품목과 하위 품목이 같을 수 없습니다.' }); continue; }
      if (!validCodes.has(parentCode)) { result.errors.push({ row: rowNum, message: `상위품목코드 [${parentCode}]가 품목마스터에 없습니다.` }); continue; }
      if (!validCodes.has(childCode)) { result.errors.push({ row: rowNum, message: `하위품목코드 [${childCode}]가 품목마스터에 없습니다.` }); continue; }

      // 중복 스킵: PK인 모+자+적용일자 (미리보기 duplicate 규칙과 동일)
      const dupKey = `${parentCode}::${childCode}::${validFrom}`;
      if (existValidSet.has(dupKey) || doneValidSet.has(dupKey)) { result.skipped++; continue; }

      try {
        const bom = this.bomRepository.create({
          parentItemCode: parentCode, childItemCode: childCode, revision,
          qtyPer: Number(qtyRaw), seq: Number(row['순서'] ?? 0) || 0,
          bomGrp: str(row['BOM그룹']) || null,
          ...this.newRowCodes(str(row['공정코드'])),
          itemCode: ownerByParent.get(parentCode) ?? parentCode,
          side: str(row['사이드']) || null, ecoNo: str(row['ECO번호']) || null,
          validFrom: this.keyDate(validFrom)!,
          validTo: this.keyDate(validTo)!,
          remark: str(row['비고']) || null, useYn: 'Y',
          organizationId,
          createdBy: userId ?? null, updatedBy: userId ?? null,
        });
        await this.bomRepository.save(bom);
        doneValidSet.add(dupKey);
        result.inserted++;
      } catch (error: unknown) {
        const msg = error instanceof Error ? error.message : String(error);
        result.errors.push({ row: rowNum, message: `저장 실패: ${msg}` });
      }
    }
    console.log(`[BomService.uploadFromExcel] 완료 — 등록: ${result.inserted}, 스킵: ${result.skipped}, 오류: ${result.errors.length}`);
    return result;
  }
}
