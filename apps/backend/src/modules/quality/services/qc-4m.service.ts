/**
 * @file src/modules/quality/services/qc-4m.service.ts
 * @description 4M 이력관리 — PB w_qc_4m_master 이식
 *
 * 초보자 가이드:
 * 1. **4M = MAN / MATERIAL / MACHINE / METHODE.** 변경구분(ECO_DIVISION)이 그 넷이다.
 *    생산 조건이 바뀐 이력을 남겨 불량 추적의 근거로 쓴다.
 * 2. **이 테이블에는 기본키 제약이 없다.** 그래서 서버가 모델명 + 서픽스 + 변경일자 +
 *    ORGANIZATION_ID 를 키로 다룬다. 등록할 때 같은 키가 있으면 막는다.
 * 3. **PB 는 ROWID 로 단건을 잡았다.** 웹은 ROWID 를 클라이언트로 내보내지 않는다 —
 *    재접속하면 달라질 수 있고 행 위치를 그대로 노출하는 값이라 키로 쓰지 않는다.
 * 4. **첨부 이미지는 이관 범위 밖이다.** PB 는 ECO_IMAGE / ECO_IMAGE2 에 파일을 담고
 *    f_download_qc_4m_data 로 내려줬다. 목록에는 첨부가 있는지만(있음/없음) 보여준다.
 */
import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { Qc4mKeyDto, Qc4mQueryDto, Qc4mUpsertDto } from '../dto/qc-4m.dto';
import { namedBinds } from '../../../common/utils/named-binds.util';

type OracleRow = Record<string, unknown>;

/** 등록·수정에서 사용자가 값을 넣는 컬럼. 키·감사·첨부 컬럼은 여기에 없다. */
const EDITABLE: Array<[column: string, field: keyof Qc4mUpsertDto]> = [
  ['WORKSTAGE_CODE', 'workstageCode'], ['ECO_STATUS', 'ecoStatus'],
  ['ECO_TYPE', 'ecoType'], ['ECO_DIVISION', 'ecoDivision'],
  ['PCB_ITEM', 'pcbItem'], ['HW_REVISION', 'hwRevision'], ['SW_REVISION', 'swRevision'],
  ['ECO_POINT', 'ecoPoint'], ['ECO_COMMENTS', 'ecoComments'], ['ECO_REASON', 'ecoReason'],
];

/** TO_DATE 로 넣어야 하는 날짜 컬럼 */
const DATE_FIELDS: Array<[column: string, field: keyof Qc4mUpsertDto]> = [
  ['APPLY_DATE', 'applyDate'], ['FIRST_PRODUCT_DATE', 'firstProductDate'],
  ['LAST_PRODUCT_DATE', 'lastProductDate'],
];

@Injectable()
export class Qc4mService {
  constructor(private readonly dataSource: DataSource) {}

  private like(value?: string): string {
    return `${(value ?? '').trim()}%`;
  }

  /** 목록 — PB d_qc_4m_lst + d_qc_4m_hist 의 조건 합집합 */
  async find(query: Qc4mQueryDto, organizationId: number) {
    const binds: OracleRow = {
      organizationId,
      modelName: this.like(query.modelName),
      workstageCode: this.like(query.workstageCode),
      ecoStatus: this.like(query.ecoStatus),
      ecoType: this.like(query.ecoType),
      ecoDivision: this.like(query.ecoDivision),
      // PB 는 키워드를 앞자리 LIKE 로 썼다. 변경점 본문 검색이라 부분일치가 맞다.
      keyword: query.keyword?.trim() ? `%${query.keyword.trim()}%` : null,
      dateFrom: query.dateFrom ? query.dateFrom.slice(0, 10) : null,
      dateTo: query.dateTo ? query.dateTo.slice(0, 10) : null,
    };
    const body = `
      SELECT m.MODEL_NAME AS "modelName", m.MODEL_SUFFIX AS "modelSuffix",
             pm.ITEM_CODE AS "itemCode",
             m.ECO_DATE AS "ecoDate", m.APPLY_DATE AS "applyDate",
             m.FIRST_PRODUCT_DATE AS "firstProductDate",
             m.LAST_PRODUCT_DATE AS "lastProductDate",
             m.WORKSTAGE_CODE AS "workstageCode", ws.WORKSTAGE_NAME AS "workstageName",
             m.ECO_STATUS AS "ecoStatus", sta.CODE_MEAN_KOR AS "ecoStatusName",
             m.ECO_TYPE AS "ecoType", typ.CODE_MEAN_KOR AS "ecoTypeName",
             m.ECO_DIVISION AS "ecoDivision", dvn.CODE_MEAN_KOR AS "ecoDivisionName",
             m.PCB_ITEM AS "pcbItem", pcb.CODE_MEAN_KOR AS "pcbItemName",
             m.HW_REVISION AS "hwRevision", m.SW_REVISION AS "swRevision",
             m.ECO_POINT AS "ecoPoint", m.ECO_COMMENTS AS "ecoComments",
             m.ECO_REASON AS "ecoReason",
             CASE WHEN NVL(LENGTH(m.ECO_IMAGE), 0) > 0 THEN 'Y' ELSE 'N' END AS "attach1Yn",
             CASE WHEN NVL(LENGTH(m.ECO_IMAGE2), 0) > 0 THEN 'Y' ELSE 'N' END AS "attach2Yn",
             m.ECO_IMAGE_FILE_NAME AS "attach1Name",
             m.ECO_IMAGE_FILE_NAME2 AS "attach2Name",
             m.ENTER_BY AS "enterBy", m.ENTER_DATE AS "enterDate",
             m.LAST_MODIFY_BY AS "lastModifyBy", m.LAST_MODIFY_DATE AS "lastModifyDate"
        FROM IQ_4M_MASTER m
        LEFT JOIN IP_PRODUCT_MODEL_MASTER pm
               ON pm.MODEL_NAME = m.MODEL_NAME AND pm.MODEL_SUFFIX = m.MODEL_SUFFIX
        LEFT JOIN IP_PRODUCT_WORKSTAGE ws
               ON ws.WORKSTAGE_CODE = m.WORKSTAGE_CODE
              AND ws.ORGANIZATION_ID = m.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE sta
               ON sta.CODE_TYPE = 'ECO STATUS' AND sta.CODE_NAME = m.ECO_STATUS
              AND sta.ORGANIZATION_ID = m.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE typ
               ON typ.CODE_TYPE = 'ECO TYPE' AND typ.CODE_NAME = m.ECO_TYPE
              AND typ.ORGANIZATION_ID = m.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE dvn
               ON dvn.CODE_TYPE = 'ECO DIVISION' AND dvn.CODE_NAME = m.ECO_DIVISION
              AND dvn.ORGANIZATION_ID = m.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE pcb
               ON pcb.CODE_TYPE = 'PCB ITEM' AND pcb.CODE_NAME = m.PCB_ITEM
              AND pcb.ORGANIZATION_ID = m.ORGANIZATION_ID
       -- nullable 컬럼은 NVL 로 감싼다. PB 는 bare LIKE 라 조건을 비워도
       -- MODEL_NAME 이 NULL 인 행이 조용히 사라졌다(실측 1행). 그 손실을 없앴다.
       WHERE NVL(m.MODEL_NAME, '*') LIKE :modelName
         AND NVL(m.WORKSTAGE_CODE, '*') LIKE :workstageCode
         AND NVL(m.ECO_STATUS, '*') LIKE :ecoStatus
         AND NVL(m.ECO_TYPE, '*') LIKE :ecoType
         AND NVL(m.ECO_DIVISION, '*') LIKE :ecoDivision
         AND (:dateFrom IS NULL OR m.ECO_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD'))
         AND (:dateTo IS NULL OR m.ECO_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1)
         AND (:keyword IS NULL
              OR m.ECO_POINT LIKE :keyword
              OR m.ECO_COMMENTS LIKE :keyword
              OR m.ECO_REASON LIKE :keyword)
         AND m.ORGANIZATION_ID = :organizationId`;
    const page = query.page ?? 1;
    const limit = query.limit ?? 500;
    const totals = await this.dataSource.query(
      `SELECT COUNT(*) AS "total" FROM (${body}) source_rows`,
      namedBinds({ ...binds }),
    ) as OracleRow[];
    const rows = await this.dataSource.query(
      `${body} ORDER BY "ecoDate" DESC, "modelName", "modelSuffix"
       OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`,
      namedBinds({ ...binds, offset: (page - 1) * limit, limit }),
    ) as OracleRow[];
    return { data: rows, total: Number(totals[0]?.total ?? 0), page, limit };
  }

  private async exists(dto: Qc4mKeyDto, organizationId: number) {
    const rows = await this.dataSource.query(
      `SELECT COUNT(*) AS "cnt" FROM IQ_4M_MASTER
        WHERE MODEL_NAME = :modelName AND MODEL_SUFFIX = :modelSuffix
          AND ECO_DATE = TO_DATE(:ecoDate, 'YYYY-MM-DD')
          AND ORGANIZATION_ID = :organizationId`,
      namedBinds({
        modelName: dto.modelName,
        modelSuffix: dto.modelSuffix,
        ecoDate: dto.ecoDate.slice(0, 10),
        organizationId,
      }),
    ) as OracleRow[];
    return Number(rows[0]?.cnt ?? 0) > 0;
  }

  /** 등록 — 감사컬럼은 서버가 채운다 (PB f_set_security_row) */
  async create(dto: Qc4mUpsertDto, organizationId: number, userId: string) {
    if (await this.exists(dto, organizationId)) {
      throw new ConflictException(
        `같은 변경일자의 4M 이력이 이미 있습니다 (${dto.modelName}/${dto.modelSuffix}/${dto.ecoDate.slice(0, 10)}).`,
      );
    }
    const columns = ['MODEL_NAME', 'MODEL_SUFFIX', 'ORGANIZATION_ID', 'ECO_DATE'];
    const values = [
      ':modelName', ':modelSuffix', ':organizationId', `TO_DATE(:ecoDate, 'YYYY-MM-DD')`,
    ];
    const binds: OracleRow = {
      modelName: dto.modelName,
      modelSuffix: dto.modelSuffix,
      organizationId,
      ecoDate: dto.ecoDate.slice(0, 10),
      userId,
    };
    for (const [column, field] of EDITABLE) {
      columns.push(column);
      values.push(`:${field}`);
      binds[field] = dto[field] ?? null;
    }
    for (const [column, field] of DATE_FIELDS) {
      columns.push(column);
      values.push(`TO_DATE(:${field}, 'YYYY-MM-DD')`);
      binds[field] = dto[field] ? String(dto[field]).slice(0, 10) : null;
    }
    columns.push('ENTER_BY', 'ENTER_DATE', 'LAST_MODIFY_BY', 'LAST_MODIFY_DATE');
    values.push(':userId', 'SYSDATE', ':userId', 'SYSDATE');

    await this.dataSource.query(
      `INSERT INTO IQ_4M_MASTER (${columns.join(', ')}) VALUES (${values.join(', ')})`,
      namedBinds(binds),
    );
    return { modelName: dto.modelName, modelSuffix: dto.modelSuffix, ecoDate: dto.ecoDate };
  }

  /** 수정 — 키는 바꿀 수 없다. LAST_MODIFY_* 만 갱신한다. */
  async update(dto: Qc4mUpsertDto, organizationId: number, userId: string) {
    if (!await this.exists(dto, organizationId)) {
      throw new NotFoundException('4M 이력을 찾을 수 없습니다.');
    }
    const sets: string[] = [];
    const binds: OracleRow = {
      modelName: dto.modelName,
      modelSuffix: dto.modelSuffix,
      ecoDate: dto.ecoDate.slice(0, 10),
      organizationId,
      userId,
    };
    for (const [column, field] of EDITABLE) {
      sets.push(`${column} = :${field}`);
      binds[field] = dto[field] ?? null;
    }
    for (const [column, field] of DATE_FIELDS) {
      sets.push(`${column} = TO_DATE(:${field}, 'YYYY-MM-DD')`);
      binds[field] = dto[field] ? String(dto[field]).slice(0, 10) : null;
    }
    sets.push('LAST_MODIFY_BY = :userId', 'LAST_MODIFY_DATE = SYSDATE');

    await this.dataSource.query(
      `UPDATE IQ_4M_MASTER SET ${sets.join(', ')}
        WHERE MODEL_NAME = :modelName AND MODEL_SUFFIX = :modelSuffix
          AND ECO_DATE = TO_DATE(:ecoDate, 'YYYY-MM-DD')
          AND ORGANIZATION_ID = :organizationId`,
      namedBinds(binds),
    );
    return { modelName: dto.modelName, modelSuffix: dto.modelSuffix, ecoDate: dto.ecoDate };
  }

  /** 삭제 */
  async remove(dto: Qc4mKeyDto, organizationId: number) {
    if (!await this.exists(dto, organizationId)) {
      throw new NotFoundException('4M 이력을 찾을 수 없습니다.');
    }
    await this.dataSource.query(
      `DELETE FROM IQ_4M_MASTER
        WHERE MODEL_NAME = :modelName AND MODEL_SUFFIX = :modelSuffix
          AND ECO_DATE = TO_DATE(:ecoDate, 'YYYY-MM-DD')
          AND ORGANIZATION_ID = :organizationId`,
      namedBinds({
        modelName: dto.modelName,
        modelSuffix: dto.modelSuffix,
        ecoDate: dto.ecoDate.slice(0, 10),
        organizationId,
      }),
    );
    return { deleted: true };
  }
}
