/**
 * @file src/modules/master/services/code-master.service.ts
 * @description 코드마스터(ISYS_CODE_MASTER) 조회 — 공통코드(ISYS_BASECODE)와 다른 체계다.
 *
 * PB DataWindow 의 DDDW 중 `vd_standard_code` 계열(`vd_wqc_standard_code`,
 * `vd_oqc_standard_code`, `vd_iqc_standard_code`, `vd_wqc_line_status_code`)이
 * 이 테이블을 읽는다. CODE_GROUP / CODE_GROUP_SECOND / CODE_GROUP_THIRD 3계층을
 * 가지므로 공통코드 훅으로 대체하면 안 된다.
 * 근거: docs/database/pb-dddw-inventory.md
 *
 * 전체 251행 / 7개 CODE_TYPE 규모라 공통코드와 같이 한 번에 내려주고 클라이언트에서 캐시한다.
 */
import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';

export interface CodeMasterItem {
  detailCode: string;
  codeName: string;
  codeGroup: string | null;
  codeGroupSecond: string | null;
  codeGroupThird: string | null;
}

export type CodeMasterMap = Record<string, CodeMasterItem[]>;

interface CodeMasterRow {
  codeType: string;
  detailCode: string;
  codeNameKor: string | null;
  codeNameEng: string | null;
  codeNameLocal: string | null;
  codeGroup: string | null;
  codeGroupSecond: string | null;
  codeGroupThird: string | null;
}

@Injectable()
export class CodeMasterService {
  constructor(private readonly dataSource: DataSource) {}

  /**
   * CODE_TYPE 별로 묶어서 전부 돌려준다.
   * PB 는 DECODE(:ARG_LANG, ...) 로 언어별 문구를 고르지만, 여기서는 세 문구를 다 내려보내고
   * 표시 언어는 프론트에서 고른다(로케일 전환 시 재조회가 필요 없다).
   */
  async findAllActive(organizationId?: number): Promise<CodeMasterMap> {
    const rows = (await this.dataSource.query(
      `SELECT CODE_TYPE           AS "codeType",
              CODE_NAME           AS "detailCode",
              CODE_MEAN_KOR       AS "codeNameKor",
              CODE_MEAN_ENG       AS "codeNameEng",
              CODE_MEAN_LOCAL     AS "codeNameLocal",
              CODE_GROUP          AS "codeGroup",
              CODE_GROUP_SECOND   AS "codeGroupSecond",
              CODE_GROUP_THIRD    AS "codeGroupThird"
         FROM ISYS_CODE_MASTER
        WHERE (:organizationId IS NULL OR ORGANIZATION_ID = :organizationId)
        ORDER BY CODE_TYPE, CODE_NAME`,
      { organizationId: organizationId ?? null } as unknown as unknown[],
    )) as CodeMasterRow[];

    const grouped: CodeMasterMap = {};
    for (const row of rows) {
      const list = (grouped[row.codeType] ??= []);
      list.push({
        detailCode: row.detailCode,
        codeName: row.codeNameKor ?? row.codeNameEng ?? row.codeNameLocal ?? row.detailCode,
        codeGroup: row.codeGroup,
        codeGroupSecond: row.codeGroupSecond,
        codeGroupThird: row.codeGroupThird,
      });
    }
    return grouped;
  }
}
