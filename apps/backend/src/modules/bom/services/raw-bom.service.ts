/**
 * @file src/modules/bom/services/raw-bom.service.ts
 * @description 원단위BOM마스터 — PB w_des_raw_bom_master ("Raw BOM Master") 이식
 *
 * 1. 목록: ID_ENG_BOM 을 모/자품목코드 앞부분으로 조회한다(유효기간 조건 없음 — 만료 행도 보인다).
 *    조건이 비어도 조회하되 ROW_LIMIT 에서 자르고 잘렸다고 알린다.
 * 2. 수정: PB 와 같이 등록·삭제는 없다. 키(PARENT, CHILD, DATESET, ORG)로 정확히 1행만 바꾼다.
 * 3. 순환 검사: PB 의 Loop Check / Show Loop(작업테이블 ID_ENG_BOM_LOOP_CHECK 사용)를
 *    계층 쿼리(CONNECT BY NOCYCLE) 한 번으로 대신한다. 테이블에 쓰지 않는다.
 *    PB 와 같이 유효기간과 관계없이 모든 행을 본다.
 */
import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { likePrefix } from '@smt/shared';
import { limited, ROW_LIMIT } from '../../../shared/row-limit';
import { TransactionService } from '../../../shared/transaction.service';
import { RawBomListQueryDto, RawBomLoopCheckQueryDto, RawBomUpdateDto } from '../dto/raw-bom.dto';

type OracleRow = Record<string, unknown>;

/** 순환 한 건. path 는 닫힌 경로다(첫 품목이 끝에 한 번 더 나온다). */
export interface RawBomLoop {
  path: string[];
  length: number;
}

/** 목록 SELECT — PB d_des_raw_bom_lst 컬럼 + 공정명 + 만료 여부 */
const LIST_SQL = `
  SELECT E.PARENT_ITEM_CODE AS "parentItemCode",
         E.CHILD_ITEM_CODE AS "childItemCode",
         TO_CHAR(E.DATESET, 'YYYY-MM-DD') AS "dateset",
         TO_CHAR(E.DATEEND, 'YYYY-MM-DD') AS "dateend",
         CASE WHEN E.DATEEND < TRUNC(SYSDATE) THEN 'Y' ELSE 'N' END AS "expiredYn",
         E.SORT_SEQUENCE AS "sortSequence",
         E.ITEM_UNIT_QTY AS "itemUnitQty",
         E.ITEM_UNIT_QTY_EXT AS "itemUnitQtyExt",
         E.WORKSTAGE_CODE AS "workstageCode",
         WS.WORKSTAGE_NAME AS "workstageName",
         E.BOM_WORK_NO AS "bomWorkNo",
         E.ITEM_TYPE AS "itemType",
         E.LINE_TYPE AS "lineType",
         E.ASSY_EXPLOSION_YN AS "assyExplosionYn",
         E.LOCATION_INFO AS "locationInfo",
         E.ENTER_BY AS "enterBy",
         TO_CHAR(E.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "enterDate",
         E.LAST_MODIFY_BY AS "lastModifyBy",
         TO_CHAR(E.LAST_MODIFY_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "lastModifyDate",
         A.ITEM_NAME AS "itemName",
         A.ITEM_SPEC AS "itemSpec",
         A.ITEM_UOM AS "itemUom",
         A.DRAWING_NO AS "drawingNo",
         A.ABC_GRADE AS "abcGrade",
         A.MANUFACTURE_LEADTIME AS "manufactureLeadtime",
         A.WORK_BAD_RATE AS "workBadRate",
         A.ITEM_DIVISION AS "itemDivision",
         B.SET_ITEM_YN AS "setItemYn",
         B.ITEM_NAME AS "parentItemName",
         B.ITEM_SPEC AS "parentItemSpec"
    FROM ID_ENG_BOM E
    LEFT JOIN ID_ITEM A ON A.ITEM_CODE = E.CHILD_ITEM_CODE AND A.ORGANIZATION_ID = E.ORGANIZATION_ID
    LEFT JOIN ID_ITEM B ON B.ITEM_CODE = E.PARENT_ITEM_CODE AND B.ORGANIZATION_ID = E.ORGANIZATION_ID
    -- PB DDDW(vd_workstage_code) 대응. 코드+조직이 유일해 행이 늘지 않는다.
    LEFT JOIN IP_PRODUCT_WORKSTAGE WS ON WS.WORKSTAGE_CODE = E.WORKSTAGE_CODE AND WS.ORGANIZATION_ID = E.ORGANIZATION_ID
   WHERE E.ORGANIZATION_ID = :organizationId
     AND E.PARENT_ITEM_CODE LIKE :parentItemCode ESCAPE '\\'
     AND E.CHILD_ITEM_CODE LIKE :childItemCode ESCAPE '\\'
   ORDER BY E.PARENT_ITEM_CODE, E.CHILD_ITEM_CODE, E.SORT_SEQUENCE
   FETCH FIRST ${ROW_LIMIT} ROWS ONLY`;

/**
 * 순환 탐지 본문. K(부모 P → 자식 C) 의 모든 간선에서 출발해 아래로 내려가며,
 * 출발 품목으로 되돌아오는 행(C = CONNECT_BY_ROOT P)이 곧 순환의 마지막 간선이다.
 * NOCYCLE 이 반복 경로를 끊으므로 길이와 관계없이 끝난다. 자기참조(P = C)는 1단계에서 잡힌다.
 */
const LOOP_DETECT_SQL = `
  SELECT CONNECT_BY_ROOT P || SYS_CONNECT_BY_PATH(C, ' > ') AS "cyclePath"
    FROM K
   WHERE C = CONNECT_BY_ROOT P
 CONNECT BY NOCYCLE PRIOR C = P`;

/** 같은 부모-자식이 DATESET 별로 여러 행이어도 간선은 하나로 본다(경로 중복 방지). */
const EDGES_CTE = `
  E AS (SELECT DISTINCT PARENT_ITEM_CODE AS P, CHILD_ITEM_CODE AS C
          FROM ID_ENG_BOM
         WHERE ORGANIZATION_ID = :organizationId)`;

/** 조직 전체: 부모이면서 자식인 품목끼리의 간선만 순환 후보다. */
const LOOP_ALL_SQL = `
  WITH ${EDGES_CTE},
  K AS (SELECT P, C FROM E
         WHERE P = C OR (P IN (SELECT C FROM E) AND C IN (SELECT P FROM E)))
  ${LOOP_DETECT_SQL}`;

/** 품목 지정: 그 품목과 하위 전개 품목 사이의 간선만 본다. */
const LOOP_ITEM_SQL = `
  WITH ${EDGES_CTE},
  R AS (SELECT :itemCode AS N FROM DUAL
        UNION
        SELECT C FROM E START WITH P = :itemCode CONNECT BY NOCYCLE PRIOR C = P),
  K AS (SELECT P, C FROM E
         WHERE P IN (SELECT N FROM R) AND C IN (SELECT N FROM R))
  ${LOOP_DETECT_SQL}`;

/**
 * 같은 순환이 구성 품목 수만큼 회전된 형태로 나온다(A>B>C>A, B>C>A>B …).
 * 가장 작은 품목코드에서 시작하도록 돌린 뒤 중복을 없앤다.
 */
export function normalizeLoops(paths: string[]): RawBomLoop[] {
  const seen = new Map<string, RawBomLoop>();
  for (const raw of paths) {
    const nodes = raw.split(' > ').map((s) => s.trim()).filter(Boolean);
    if (nodes.length < 2) continue;
    const ring = nodes.slice(0, -1);
    let start = 0;
    ring.forEach((code, i) => { if (code < ring[start]) start = i; });
    const rotated = [...ring.slice(start), ...ring.slice(0, start)];
    const path = [...rotated, rotated[0]];
    const key = path.join('>');
    if (!seen.has(key)) seen.set(key, { path, length: ring.length });
  }
  return [...seen.values()].sort((a, b) => a.path.join('>').localeCompare(b.path.join('>')));
}

@Injectable()
export class RawBomService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  /** 목록 — PB d_des_raw_bom_lst. 조건이 없으면 조직 전체를 ROW_LIMIT 까지 돌려준다. */
  async findList(query: RawBomListQueryDto, organizationId: number) {
    const rows = await this.dataSource.query(LIST_SQL, {
      organizationId,
      parentItemCode: likePrefix(query.parentItemCode?.toUpperCase()),
      childItemCode: likePrefix(query.childItemCode?.toUpperCase()),
    } as unknown as unknown[]) as OracleRow[];
    return limited(rows);
  }

  /** 수정 — 키로 정확히 1행을 바꾼다. 0행이면 그 사이 키가 바뀌었거나 삭제된 것이다. */
  async update(dto: RawBomUpdateDto, organizationId: number, userId: string) {
    if (dto.dateend < dto.dateset) {
      throw new BadRequestException('종료일자는 시작일자보다 빠를 수 없습니다.');
    }
    const key = {
      parentItemCode: dto.parentItemCode.trim(),
      childItemCode: dto.childItemCode.trim(),
      dateset: dto.dateset,
      organizationId,
    };
    return this.tx.run(async (qr) => {
      // useStructuredResult=true 여야 affected 가 온다. 기본 반환값은 행 수 숫자 자체다.
      const result = await qr.query(
        `UPDATE ID_ENG_BOM
            SET ASSY_EXPLOSION_YN = :assyExplosionYn,
                ITEM_TYPE = :itemType,
                LINE_TYPE = :lineType,
                ITEM_UNIT_QTY = :itemUnitQty,
                ITEM_UNIT_QTY_EXT = :itemUnitQtyExt,
                WORKSTAGE_CODE = :workstageCode,
                SORT_SEQUENCE = :sortSequence,
                DATEEND = TO_DATE(:dateend, 'YYYY-MM-DD'),
                LAST_MODIFY_BY = :userId,
                LAST_MODIFY_DATE = SYSDATE
          WHERE PARENT_ITEM_CODE = :parentItemCode
            AND CHILD_ITEM_CODE = :childItemCode
            AND DATESET = TO_DATE(:dateset, 'YYYY-MM-DD')
            AND ORGANIZATION_ID = :organizationId`,
        {
          ...key,
          assyExplosionYn: dto.assyExplosionYn,
          itemType: dto.itemType,
          lineType: dto.lineType,
          itemUnitQty: dto.itemUnitQty,
          itemUnitQtyExt: dto.itemUnitQtyExt ?? null,
          workstageCode: dto.workstageCode,
          sortSequence: dto.sortSequence,
          dateend: dto.dateend,
          userId,
        } as unknown as unknown[],
        true,
      ) as { affected?: number };
      const affected = Number(result?.affected ?? 0);
      if (affected === 0) {
        throw new NotFoundException(
          `수정할 BOM 행이 없습니다: ${key.parentItemCode} / ${key.childItemCode} / ${key.dateset}`,
        );
      }
      if (affected !== 1) {
        // PK 라 2행 이상은 나올 수 없지만, 나오면 롤백한다.
        throw new BadRequestException(`BOM 행이 ${affected}건 수정되어 취소했습니다.`);
      }
      return { updated: 1, ...key };
    });
  }

  /** 순환 검사 — itemCode 가 있으면 그 품목의 하위 전개 범위, 없으면 조직 전체 */
  async findLoops(query: RawBomLoopCheckQueryDto, organizationId: number) {
    const itemCode = query.itemCode?.trim().toUpperCase() || null;
    if (itemCode) {
      // 조회조건은 앞부분 일치라 부분 코드가 들어올 수 있다. BOM 에 없는 코드면 검사 범위가
      // 비어 '순환 없음' 으로 잘못 보이므로 먼저 막는다.
      const found = await this.dataSource.query(
        `SELECT COUNT(*) AS "cnt" FROM ID_ENG_BOM
          WHERE ORGANIZATION_ID = :organizationId
            AND (PARENT_ITEM_CODE = :itemCode OR CHILD_ITEM_CODE = :itemCode)`,
        { organizationId, itemCode } as unknown as unknown[],
      ) as OracleRow[];
      if (Number(found[0]?.cnt ?? 0) === 0) {
        throw new BadRequestException(
          `BOM 에 없는 품목코드입니다: ${itemCode} — 순환 검사는 정확한 품목코드로 합니다.`,
        );
      }
    }
    const rows = await this.dataSource.query(
      itemCode ? LOOP_ITEM_SQL : LOOP_ALL_SQL,
      (itemCode ? { organizationId, itemCode } : { organizationId }) as unknown as unknown[],
    ) as OracleRow[];
    const loops = normalizeLoops(rows.map((r) => String(r.cyclePath ?? '')));
    return { itemCode, loops, total: loops.length };
  }
}
