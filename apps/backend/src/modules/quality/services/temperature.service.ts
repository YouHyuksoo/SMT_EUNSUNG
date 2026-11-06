/**
 * @file src/modules/quality/services/temperature.service.ts
 * @description 온도상태조회 — PB w_pln_product_tempreture_history_query 이식
 *
 * 초보자 가이드:
 * 1. **`ICOM_TEMPERATURE_RAW` 는 1,700만 행이고 인덱스가 (NODEID, GATHER_DATE) 하나뿐이다.**
 *    그래서 노드ID 와 기간을 둘 다 필수로 받는다.
 * 2. **PB SQL 의 `UPPER(NODEID) = :arg` 를 뺐다.** 함수로 감싸면 그 인덱스를 못 쓰고
 *    1,700만 행을 훑는다. 이 DB 의 NODEID 는 49개 전부 대문자 MAC 주소로 균일해
 *    (DISTINCT NODEID 49 = DISTINCT UPPER(NODEID) 49) 결과가 PB 와 같다.
 *    대신 비교 전에 바인드 값을 대문자로 올린다.
 * 3. **NG 판정은 설비 기준범위와 비교한다** — IMCN_MACHINE 의 최소/최대 온도·습도.
 *    PB 계산식을 그대로 옮겼다.
 * 4. **이상 점검이력(IMCN_TEMPERATURE_CHECK_MASTER)은 등록·수정·삭제한다** — PB dw_5 의
 *    INSERT/UPDATE/DELETE 그대로다. 항번은 SEQ_CHECK_SEQ, 확인여부 기본 'W'(대기),
 *    확인일시는 등록 시각이다. 이상 시작·종료는 둘 다 필수이고 시작 ≤ 종료여야 한다.
 *    이 테이블에는 기본키·트리거가 없어 설비 + 항번 + 조직을 키로 다룬다 (PB key 컬럼).
 * 5. 노드현황·원시데이터는 조회 전용이다.
 */
import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import {
  TemperatureCheckKeyDto, TemperatureCheckQueryDto, TemperatureCheckUpdateDto,
  TemperatureCheckUpsertDto, TemperatureRawQueryDto,
} from '../dto/temperature.dto';
import { namedBinds } from '../../../common/utils/named-binds.util';

type OracleRow = Record<string, unknown>;

/** 'YYYY-MM-DDTHH:mm[:ss]' → 'YYYY-MM-DD HH:mm:ss' (TO_DATE 형식에 맞춘다) */
function toDateTimeText(value: string): string {
  const text = value.trim().replace('T', ' ');
  return text.length === 16 ? `${text}:00` : text;
}

const EMPTY_TO_NULL = (value?: string) => (value?.trim() ? value.trim() : null);

@Injectable()
export class TemperatureService {
  constructor(private readonly dataSource: DataSource) {}

  private like(value?: string): string {
    return `${(value ?? '').trim()}%`;
  }

  /** 노드 목록 — 조회조건 드롭다운용. 설비명과 기준범위를 함께 내린다. */
  async findNodes(organizationId: number) {
    return this.dataSource.query<OracleRow[]>(
      `SELECT d.NODEID AS "nodeId", m.MACHINE_CODE AS "machineCode",
              m.MACHINE_NAME AS "machineName",
              m.MIN_TEMP_VALUE AS "minTempValue", m.MAX_TEMP_VALUE AS "maxTempValue",
              m.MIN_HUMIDITY_VALUE AS "minHumidityValue",
              m.MAX_HUMIDITY_VALUE AS "maxHumidityValue",
              d.GATHER_DATE AS "lastGatherDate",
              d.ROOM_TEMPERATURE AS "roomTemperature", d.HUMIDITY AS "humidity",
              d.DEW_POINT AS "dewPoint", d.BATT AS "batt", d.LQI AS "lqi"
         FROM ICOM_TEMPERATURE_DATA d
         LEFT JOIN IMCN_MACHINE m
                ON m.MACHINE_CODE = d.NODEID AND m.ORGANIZATION_ID = d.ORGANIZATION_ID
        WHERE d.ORGANIZATION_ID IS NOT NULL
          AND NVL(m.MACHINE_STATUS_CODE, '*') <> 'S'
        ORDER BY m.MACHINE_NAME NULLS LAST, d.NODEID`,
      [],
    );
  }

  /** 원시데이터 — PB d_com_tempreture_raw_lst */
  async findRaw(query: TemperatureRawQueryDto, organizationId: number) {
    const ngOnly = query.ngOnly === 'true';
    const binds = {
      organizationId,
      // PB 는 UPPER(컬럼) 으로 비교했다. 인덱스를 쓰려면 컬럼을 그대로 두고 값을 올려야 한다.
      nodeId: query.nodeId.trim().toUpperCase(),
      dateFrom: query.dateFrom.slice(0, 10),
      dateTo: query.dateTo.slice(0, 10),
    };
    // PB 의 NG 판정식 그대로 — 설비 기준범위를 벗어난 값
    const ngCondition = `
      (m.MIN_TEMP_VALUE > r.ROOM_TEMPERATURE
       OR m.MAX_TEMP_VALUE < r.ROOM_TEMPERATURE
       OR m.MIN_HUMIDITY_VALUE > r.HUMIDITY
       OR m.MAX_HUMIDITY_VALUE < r.HUMIDITY)`;
    const body = `
      SELECT r.NODEID AS "nodeId", m.MACHINE_NAME AS "machineName",
             r.GATHER_DATE AS "gatherDate",
             r.ROOM_TEMPERATURE AS "roomTemperature", r.HUMIDITY AS "humidity",
             r.DEW_POINT AS "dewPoint",
             m.MIN_TEMP_VALUE AS "minTempValue", m.MAX_TEMP_VALUE AS "maxTempValue",
             m.MIN_HUMIDITY_VALUE AS "minHumidityValue",
             m.MAX_HUMIDITY_VALUE AS "maxHumidityValue",
             CASE WHEN ${ngCondition} THEN 'Y' ELSE 'N' END AS "ngYn",
             r.GW_ID AS "gwId", r.LQI AS "lqi", r.BATT AS "batt",
             r.NODETYPE AS "nodeType", r.CHILD_CNT AS "childCnt"
        FROM ICOM_TEMPERATURE_RAW r
        LEFT JOIN IMCN_MACHINE m
               ON m.MACHINE_CODE = r.NODEID AND m.ORGANIZATION_ID = r.ORGANIZATION_ID
       WHERE r.NODEID = :nodeId
         AND r.GATHER_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
         AND r.GATHER_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
         AND r.ORGANIZATION_ID = :organizationId
         ${ngOnly ? `AND ${ngCondition}` : ''}`;
    const page = query.page ?? 1;
    const limit = query.limit ?? 1000;
    const totals = await this.dataSource.query(
      `SELECT COUNT(*) AS "total" FROM (${body}) source_rows`,
      namedBinds({ ...binds }),
    ) as OracleRow[];
    const rows = await this.dataSource.query(
      `${body} ORDER BY "gatherDate" DESC
       OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`,
      namedBinds({ ...binds, offset: (page - 1) * limit, limit }),
    ) as OracleRow[];
    return { data: rows, total: Number(totals[0]?.total ?? 0), page, limit };
  }

  /** 점검이력 — PB d_mcn_temerature_check_lst (확인일자 기준) */
  async findChecks(query: TemperatureCheckQueryDto, organizationId: number) {
    const binds = {
      organizationId,
      dateFrom: query.dateFrom.slice(0, 10),
      dateTo: query.dateTo.slice(0, 10),
      machineCode: this.like(query.machineCode),
      confirmYn: this.like(query.confirmYn),
    };
    const body = `
      SELECT c.MACHINE_CODE AS "machineCode", m.MACHINE_NAME AS "machineName",
             c.CHECK_SEQUENCE AS "checkSequence",
             c.CHECK_START_DATE AS "checkStartDate", c.CHECK_END_DATE AS "checkEndDate",
             c.NG_REASON_CODE AS "ngReasonCode", ngr.CODE_MEAN_KOR AS "ngReasonName",
             c.ACTION_CODE AS "actionCode", act.CODE_MEAN_KOR AS "actionName",
             c.CONFIRM_YN AS "confirmYn", cfm.CODE_MEAN_KOR AS "confirmName",
             c.CONFIRM_DATE AS "confirmDate", c.COMMENTS AS "comments",
             c.ENTER_BY AS "enterBy", c.ENTER_DATE AS "enterDate",
             c.LAST_MODIFY_BY AS "lastModifyBy", c.LAST_MODIFY_DATE AS "lastModifyDate"
        FROM IMCN_TEMPERATURE_CHECK_MASTER c
        LEFT JOIN IMCN_MACHINE m
               ON m.MACHINE_CODE = c.MACHINE_CODE AND m.ORGANIZATION_ID = c.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE ngr
               ON ngr.CODE_TYPE = 'NG REASON CODE' AND ngr.CODE_NAME = c.NG_REASON_CODE
              AND ngr.ORGANIZATION_ID = c.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE act
               ON act.CODE_TYPE = 'ACTION CODE' AND act.CODE_NAME = c.ACTION_CODE
              AND act.ORGANIZATION_ID = c.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE cfm
               ON cfm.CODE_TYPE = 'CONFIRM YN' AND cfm.CODE_NAME = c.CONFIRM_YN
              AND cfm.ORGANIZATION_ID = c.ORGANIZATION_ID
       WHERE c.MACHINE_CODE LIKE :machineCode
         AND c.CONFIRM_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
         AND c.CONFIRM_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
         AND NVL(c.CONFIRM_YN, '*') LIKE :confirmYn
         AND c.ORGANIZATION_ID = :organizationId`;
    const page = query.page ?? 1;
    const limit = query.limit ?? 500;
    const totals = await this.dataSource.query(
      `SELECT COUNT(*) AS "total" FROM (${body}) source_rows`,
      namedBinds({ ...binds }),
    ) as OracleRow[];
    const rows = await this.dataSource.query(
      `${body} ORDER BY "confirmDate" DESC, "machineCode", "checkSequence" DESC
       OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`,
      namedBinds({ ...binds, offset: (page - 1) * limit, limit }),
    ) as OracleRow[];
    return { data: rows, total: Number(totals[0]?.total ?? 0), page, limit };
  }

  /** 이상 시작·종료 검사 — PB UPDATE 의 검사식 그대로 */
  private checkPeriod(dto: TemperatureCheckUpsertDto) {
    const start = toDateTimeText(dto.checkStartDate);
    const end = toDateTimeText(dto.checkEndDate);
    if (start > end) throw new BadRequestException('이상 시작일시가 종료일시보다 늦습니다.');
    return { start, end };
  }

  /** 이상 점검이력 등록 — 항번·확인일시·등록자는 서버가 채운다 */
  async createCheck(dto: TemperatureCheckUpsertDto, organizationId: number, userId: string) {
    const { start, end } = this.checkPeriod(dto);
    const [{ seq }] = await this.dataSource.query(
      `SELECT SEQ_CHECK_SEQ.NEXTVAL AS "seq" FROM DUAL`, [],
    ) as Array<{ seq: number }>;
    await this.dataSource.query(
      `INSERT INTO IMCN_TEMPERATURE_CHECK_MASTER
         (MACHINE_CODE, ORGANIZATION_ID, CHECK_SEQUENCE, CHECK_START_DATE, CHECK_END_DATE,
          NG_REASON_CODE, ACTION_CODE, CONFIRM_YN, CONFIRM_DATE, COMMENTS,
          ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE)
       VALUES (:machineCode, :organizationId, :checkSequence,
          TO_DATE(:checkStartDate, 'YYYY-MM-DD HH24:MI:SS'), TO_DATE(:checkEndDate, 'YYYY-MM-DD HH24:MI:SS'),
          :ngReasonCode, :actionCode, NVL(:confirmYn, 'W'), SYSDATE, :comments,
          :userId, SYSDATE, :userId, SYSDATE)`,
      namedBinds({
        machineCode: dto.machineCode.trim(),
        organizationId,
        checkSequence: Number(seq),
        checkStartDate: start,
        checkEndDate: end,
        ngReasonCode: EMPTY_TO_NULL(dto.ngReasonCode),
        actionCode: EMPTY_TO_NULL(dto.actionCode),
        confirmYn: EMPTY_TO_NULL(dto.confirmYn),
        comments: EMPTY_TO_NULL(dto.comments),
        userId,
      }),
    );
    return { machineCode: dto.machineCode.trim(), checkSequence: Number(seq) };
  }

  private async checkExists(key: TemperatureCheckKeyDto, organizationId: number) {
    const rows = await this.dataSource.query(
      `SELECT COUNT(*) AS "cnt" FROM IMCN_TEMPERATURE_CHECK_MASTER
        WHERE MACHINE_CODE = :machineCode AND CHECK_SEQUENCE = :checkSequence
          AND ORGANIZATION_ID = :organizationId`,
      namedBinds({ machineCode: key.machineCode, checkSequence: key.checkSequence, organizationId }),
    ) as OracleRow[];
    if (Number(rows[0]?.cnt ?? 0) === 0) throw new NotFoundException('이상 점검이력을 찾을 수 없습니다.');
  }

  /** 이상 점검이력 수정 — 설비·항번은 키라 바꾸지 않는다 */
  async updateCheck(dto: TemperatureCheckUpdateDto, organizationId: number, userId: string) {
    const { start, end } = this.checkPeriod(dto);
    await this.checkExists(dto, organizationId);
    await this.dataSource.query(
      `UPDATE IMCN_TEMPERATURE_CHECK_MASTER
          SET CHECK_START_DATE = TO_DATE(:checkStartDate, 'YYYY-MM-DD HH24:MI:SS'),
              CHECK_END_DATE = TO_DATE(:checkEndDate, 'YYYY-MM-DD HH24:MI:SS'),
              NG_REASON_CODE = :ngReasonCode, ACTION_CODE = :actionCode,
              CONFIRM_YN = NVL(:confirmYn, CONFIRM_YN), COMMENTS = :comments,
              LAST_MODIFY_BY = :userId, LAST_MODIFY_DATE = SYSDATE
        WHERE MACHINE_CODE = :machineCode AND CHECK_SEQUENCE = :checkSequence
          AND ORGANIZATION_ID = :organizationId`,
      namedBinds({
        checkStartDate: start,
        checkEndDate: end,
        ngReasonCode: EMPTY_TO_NULL(dto.ngReasonCode),
        actionCode: EMPTY_TO_NULL(dto.actionCode),
        confirmYn: EMPTY_TO_NULL(dto.confirmYn),
        comments: EMPTY_TO_NULL(dto.comments),
        userId,
        machineCode: dto.machineCode,
        checkSequence: dto.checkSequence,
        organizationId,
      }),
    );
    return { machineCode: dto.machineCode, checkSequence: dto.checkSequence };
  }

  /** 이상 점검이력 삭제 */
  async removeCheck(key: TemperatureCheckKeyDto, organizationId: number) {
    await this.checkExists(key, organizationId);
    await this.dataSource.query(
      `DELETE FROM IMCN_TEMPERATURE_CHECK_MASTER
        WHERE MACHINE_CODE = :machineCode AND CHECK_SEQUENCE = :checkSequence
          AND ORGANIZATION_ID = :organizationId`,
      namedBinds({ machineCode: key.machineCode, checkSequence: key.checkSequence, organizationId }),
    );
    return { deleted: true };
  }
}
