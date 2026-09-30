/**
 * @file src/modules/smt/smt-line.service.ts
 * @description SMT 라인관리 — PB w_smt_line_master 이식
 *
 * 초보자 가이드:
 * 1. **IB_LINE_MASTER 는 "라인 × 설비" 표다.** 라인 하나에 설비가 여러 대 달리므로
 *    키가 LINE_CODE + MACHINE + ORGANIZATION_ID 다. 라인 목록이 아니다.
 *    이 DB 에 39행 있다.
 * 2. **IP_PRODUCT_LINE 과 다른 테이블이다.** 조회조건의 라인 셀렉터(PB vd_line_code)는
 *    IP_PRODUCT_LINE(56행)을 읽고, 설비 셀렉터(PB vd_smt_machine_code)는
 *    이 테이블의 MACHINE 을 읽는다. 둘을 섞으면 라인 수가 안 맞는다.
 * 3. **LINE_CODE = '*' 은 표시하지 않는다.** PB retrieve 에 `LINE_CODE <> '*'` 가 있다.
 *    다른 화면이 "미지정"을 가리키려고 쓰는 센티넬 행이라 목록·수정·삭제에서 모두 뺀다.
 *    (지금 이 DB 에는 없지만 PB 가 막고 있었으므로 유지한다.)
 * 4. **LINE_SHAFT_TYPE 은 다루지 않는다.** 39행 전부 NULL 이고 ISYS_BASECODE 에
 *    'LINE SHAFT TYPE' 코드표 자체가 없다. 은성에서 쓰지 않는 컬럼이다.
 * 5. 위치 일괄생성·일괄삭제는 이 서비스가 아니라 PKG_MES_SMT 안에 있다.
 *    PB 화면과 웹이 같은 오브젝트를 불러야 결과가 갈리지 않는다.
 */
import { BadRequestException, ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { TransactionService } from '../../shared/transaction.service';
import {
  SmtLineKeyDto,
  SmtLineQueryDto,
  SmtLineUpsertDto,
  SmtLocationGenerateDto,
} from './smt-line.dto';
import { affectedRows } from '../../common/utils/affected-rows.util';

/** 센티넬 라인. 목록·수정·삭제 어디서도 대상이 아니다. */
const SENTINEL_LINE = '*';

/** 사용자가 값을 넣는 컬럼. 감사컬럼(ENTER_ · LAST_MODIFY_)은 여기에 없다. */
const EDITABLE: Array<[column: string, field: keyof SmtLineUpsertDto]> = [
  ['LINE_NAME', 'lineName'],
  ['MACHINE_NAME', 'machineName'],
  ['LINE_DIVISION', 'lineDivision'],
  ['LINE_STATUS', 'lineStatus'],
  ['MACHINE_GROUP', 'machineGroup'],
  ['SHOW_TABLE_YN', 'showTableYn'],
];

@Injectable()
export class SmtLineService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  /** PB 규약: 빈 값이면 '%' 가 되어 전체를 조회한다. */
  private like(value?: string): string {
    return `${(value ?? '').trim()}%`;
  }

  /**
   * 목록 — PB d_ib_line_master_lst.
   *
   * PB 의 `MACHINE like :arg` 를 NVL 로 감쌌다. MACHINE 은 NOT NULL 이지만
   * LINE_NAME·MACHINE_GROUP 은 아니고, `NULL LIKE '%'` 는 NULL(=거짓)이라
   * 조건을 비워도 그 행이 조용히 빠진다.
   */
  async find(query: SmtLineQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT m.LINE_CODE AS "lineCode", m.MACHINE AS "machine",
              m.LINE_NAME AS "lineName", m.MACHINE_NAME AS "machineName",
              m.LINE_DIVISION AS "lineDivision",
              m.LINE_STATUS AS "lineStatus", st.CODE_MEAN_KOR AS "lineStatusName",
              m.MACHINE_GROUP AS "machineGroup",
              m.SHOW_TABLE_YN AS "showTableYn",
              m.ACTION_DATE AS "actionDate",
              (SELECT COUNT(*) FROM IB_MACHINE_LOCATION l
                WHERE l.LINE_CODE = m.LINE_CODE
                  AND l.MACHINE = m.MACHINE
                  AND l.ORGANIZATION_ID = m.ORGANIZATION_ID) AS "locationCount",
              m.ENTER_BY AS "enterBy", m.ENTER_DATE AS "enterDate",
              m.LAST_MODIFY_BY AS "lastModifyBy", m.LAST_MODIFY_DATE AS "lastModifyDate"
         FROM IB_LINE_MASTER m
         LEFT JOIN ISYS_BASECODE st
                ON st.CODE_TYPE = 'LINE STATUS' AND st.CODE_NAME = m.LINE_STATUS
        WHERE m.ORGANIZATION_ID = :organizationId
          AND m.LINE_CODE <> :sentinel
          AND NVL(m.LINE_CODE, '*') LIKE :lineCode
          AND NVL(m.MACHINE, '*') LIKE :machine
          AND NVL(m.LINE_STATUS, '*') LIKE :lineStatus
        ORDER BY m.LINE_CODE, m.MACHINE`,
      {
          organizationId,
          sentinel: SENTINEL_LINE,
          lineCode: this.like(query.lineCode),
          machine: this.like(query.machine),
          lineStatus: this.like(query.lineStatus),
        } as unknown as unknown[],
    )) as Record<string, unknown>[];
    return { data: rows, total: rows.length };
  }

  /** 설비 셀렉터 원천 — PB vd_smt_machine_code. */
  async findMachines(organizationId: number) {
    return (await this.dataSource.query(
      `SELECT DISTINCT m.MACHINE AS "machine", m.MACHINE_NAME AS "machineName"
         FROM IB_LINE_MASTER m
        WHERE m.ORGANIZATION_ID = :organizationId
          AND m.LINE_CODE <> :sentinel
        ORDER BY m.MACHINE`,
      { organizationId, sentinel: SENTINEL_LINE } as unknown as unknown[],
    )) as Record<string, unknown>[];
  }

  /** 하위 위치 목록 — PB d_ib_machine_location_lst (dw_2). */
  async findLocations(key: SmtLineKeyDto, organizationId: number) {
    return (await this.dataSource.query(
      `SELECT l.LINE_CODE AS "lineCode", l.MACHINE AS "machine",
              l.LOCATION_CODE AS "locationCode", l.TABLE_ID AS "tableId",
              l.TABLE_NO AS "tableNo", l.COMMENTS AS "comments",
              l.ENTER_BY AS "enterBy", l.ENTER_DATE AS "enterDate",
              l.LAST_MODIFY_BY AS "lastModifyBy", l.LAST_MODIFY_DATE AS "lastModifyDate"
         FROM IB_MACHINE_LOCATION l
        WHERE l.LINE_CODE = :lineCode
          AND l.MACHINE = :machine
          AND l.ORGANIZATION_ID = :organizationId
        ORDER BY l.TABLE_ID, SUBSTR(l.LOCATION_CODE, 2)`,
      { lineCode: key.lineCode, machine: key.machine, organizationId } as unknown as unknown[],
    )) as Record<string, unknown>[];
  }

  private assertNotSentinel(lineCode: string) {
    if (lineCode.trim() === SENTINEL_LINE) {
      throw new BadRequestException(
        "'*' 라인은 다른 화면이 '미지정'을 가리키려고 쓰는 예약 코드입니다. 수정·삭제할 수 없습니다.",
      );
    }
  }

  async create(dto: SmtLineUpsertDto, organizationId: number, userId: string) {
    this.assertNotSentinel(dto.lineCode);
    return this.tx.run(async (qr) => {
      const [dup] = (await qr.query(
        `SELECT COUNT(*) AS CNT FROM IB_LINE_MASTER
          WHERE LINE_CODE = :lineCode AND MACHINE = :machine
            AND ORGANIZATION_ID = :organizationId`,
        { lineCode: dto.lineCode, machine: dto.machine, organizationId } as unknown as unknown[],
      )) as { CNT: number }[];
      if (Number(dup?.CNT ?? 0) > 0) {
        throw new ConflictException(`이미 있는 라인·설비입니다: ${dto.lineCode} / ${dto.machine}`);
      }

      const columns = ['LINE_CODE', 'MACHINE', 'ORGANIZATION_ID'];
      const values = [':lineCode', ':machine', ':organizationId'];
      const binds: Record<string, unknown> = {
        lineCode: dto.lineCode,
        machine: dto.machine,
        organizationId,
        userId,
      };
      for (const [column, field] of EDITABLE) {
        columns.push(column);
        values.push(`:${field}`);
        binds[field] = dto[field] ?? null;
      }
      // PB f_set_security_row 가 하던 일. 본문으로 받지 않는다.
      columns.push('ENTER_BY', 'ENTER_DATE', 'LAST_MODIFY_BY', 'LAST_MODIFY_DATE');
      values.push(':userId', 'SYSDATE', ':userId', 'SYSDATE');

      await qr.query(
        `INSERT INTO IB_LINE_MASTER (${columns.join(', ')}) VALUES (${values.join(', ')})`,
        binds as unknown as unknown[],
      );
      return { lineCode: dto.lineCode, machine: dto.machine };
    });
  }

  async update(dto: SmtLineUpsertDto, organizationId: number, userId: string) {
    this.assertNotSentinel(dto.lineCode);
    return this.tx.run(async (qr) => {
      const binds: Record<string, unknown> = {
        lineCode: dto.lineCode,
        machine: dto.machine,
        organizationId,
        userId,
      };
      const sets: string[] = [];
      for (const [column, field] of EDITABLE) {
        sets.push(`${column} = :${field}`);
        binds[field] = dto[field] ?? null;
      }
      sets.push('LAST_MODIFY_BY = :userId', 'LAST_MODIFY_DATE = SYSDATE');

      const result = await qr.query(
        `UPDATE IB_LINE_MASTER SET ${sets.join(', ')}
          WHERE LINE_CODE = :lineCode AND MACHINE = :machine
            AND ORGANIZATION_ID = :organizationId`,
        binds as unknown as unknown[],
      );
      const affected = Number(affectedRows(result) ?? 0);
      if (affected === 0) {
        throw new NotFoundException(`라인·설비를 찾을 수 없습니다: ${dto.lineCode} / ${dto.machine}`);
      }
      return { lineCode: dto.lineCode, machine: dto.machine, changed: affected };
    });
  }

  /**
   * 삭제 — 하위 위치가 남아 있으면 거부한다.
   * PB 는 라인을 지워도 IB_MACHINE_LOCATION 을 그대로 뒀고, 그러면 위치가
   * 없는 라인을 가리키게 된다. 위치를 먼저 지우도록 안내한다.
   */
  async remove(key: SmtLineKeyDto, organizationId: number) {
    this.assertNotSentinel(key.lineCode);
    return this.tx.run(async (qr) => {
      const [child] = (await qr.query(
        `SELECT COUNT(*) AS CNT FROM IB_MACHINE_LOCATION
          WHERE LINE_CODE = :lineCode AND MACHINE = :machine
            AND ORGANIZATION_ID = :organizationId`,
        { lineCode: key.lineCode, machine: key.machine, organizationId } as unknown as unknown[],
      )) as { CNT: number }[];
      const locations = Number(child?.CNT ?? 0);
      if (locations > 0) {
        throw new ConflictException(
          `이 라인·설비에 위치 ${locations}건이 남아 있습니다. 위치를 먼저 지우세요.`,
        );
      }

      const result = await qr.query(
        `DELETE FROM IB_LINE_MASTER
          WHERE LINE_CODE = :lineCode AND MACHINE = :machine
            AND ORGANIZATION_ID = :organizationId`,
        { lineCode: key.lineCode, machine: key.machine, organizationId } as unknown as unknown[],
      );
      const affected = Number(affectedRows(result) ?? 0);
      if (affected === 0) {
        throw new NotFoundException(`라인·설비를 찾을 수 없습니다: ${key.lineCode} / ${key.machine}`);
      }
      return { deleted: affected };
    });
  }

  /** 라인·설비의 현재 위치 건수. 프로시저 전후를 비교해 실제 변화량을 낸다. */
  private async countLocations(
    qr: { query: <T>(sql: string, params?: unknown[]) => Promise<T> },
    lineCode: string,
    machine: string,
    organizationId: number,
  ): Promise<number> {
    const rows = (await qr.query(
      `SELECT COUNT(*) AS CNT FROM IB_MACHINE_LOCATION
        WHERE LINE_CODE = :lineCode AND MACHINE = :machine
          AND ORGANIZATION_ID = :organizationId`,
      { lineCode, machine, organizationId } as unknown as unknown[],
    )) as { CNT: number }[];
    return Number(rows?.[0]?.CNT ?? 0);
  }

  /**
   * 위치 일괄생성 — PKG_MES_SMT.SP_SMT_LOCATION_GENERATE.
   *
   * 프로시저가 만든 행수를 OUT 바인드로 받지 않는다 (이 저장소는 서비스에서
   * oracledb 를 직접 쓰지 않는다). 대신 같은 트랜잭션 안에서 전후 건수를 세어
   * 차이를 돌려준다 — 이미 있던 위치는 프로시저가 건너뛰므로 차이가 곧 생성 건수다.
   */
  async generateLocations(
    dto: SmtLocationGenerateDto,
    organizationId: number,
    userId: string,
  ) {
    if (dto.addrTo < dto.addrFrom) {
      throw new BadRequestException('주소 끝이 시작보다 작습니다.');
    }
    return this.tx.run(async (qr) => {
      const before = await this.countLocations(qr, dto.lineCode, dto.machine, organizationId);
      await qr
        .query(
          `DECLARE
             v_result NUMBER;
           BEGIN
             PKG_MES_SMT.SP_SMT_LOCATION_GENERATE(
               :lineCode, :machine, :tableId, :addrFrom, :addrTo,
               :positions, :allTables, :organizationId, :userId, v_result);
             IF v_result < 0 THEN
               RAISE_APPLICATION_ERROR(-20031, 'SMT_LOCATION_GENERATE_FAILED:' || v_result);
             END IF;
           END;`,
          {
              lineCode: dto.lineCode,
              machine: dto.machine,
              tableId: dto.tableId.toUpperCase(),
              addrFrom: dto.addrFrom,
              addrTo: dto.addrTo,
              positions: dto.positions,
              allTables: dto.allTables ?? 'N',
              organizationId,
              userId,
            } as unknown as unknown[],
        )
        .catch((error: unknown) => {
          const message = error instanceof Error ? error.message : String(error);
          const matched = /SMT_LOCATION_GENERATE_FAILED:(-?\d+)/.exec(message);
          if (!matched) throw error;
          const reason: Record<string, string> = {
            '-1': `라인·설비가 없습니다: ${dto.lineCode} / ${dto.machine}`,
            '-2': '테이블문자는 알파벳 한 글자여야 합니다.',
            '-3': '주소 범위가 잘못되었습니다.',
            '-4': '위치는 L·R·N 만 쓸 수 있습니다.',
          };
          throw new BadRequestException(reason[matched[1]] ?? `위치 생성 실패 (${matched[1]})`);
        });
      const after = await this.countLocations(qr, dto.lineCode, dto.machine, organizationId);
      return { created: after - before, skipped: 0, total: after };
    });
  }

  /** 위치 일괄삭제 — PKG_MES_SMT.SP_SMT_LOCATION_DELETE. */
  async deleteLocations(key: SmtLineKeyDto, organizationId: number) {
    return this.tx.run(async (qr) => {
      const before = await this.countLocations(qr, key.lineCode, key.machine, organizationId);
      await qr
        .query(
          `DECLARE
             v_result NUMBER;
           BEGIN
             PKG_MES_SMT.SP_SMT_LOCATION_DELETE(
               :lineCode, :machine, :organizationId, v_result);
             IF v_result < 0 THEN
               RAISE_APPLICATION_ERROR(-20032, 'SMT_LOCATION_DELETE_FAILED:' || v_result);
             END IF;
           END;`,
          { lineCode: key.lineCode, machine: key.machine, organizationId } as unknown as unknown[],
        )
        .catch((error: unknown) => {
          const message = error instanceof Error ? error.message : String(error);
          const matched = /SMT_LOCATION_DELETE_FAILED:(-?\d+)/.exec(message);
          if (!matched) throw error;
          const code = Number(matched[1]);
          if (code === -1) throw new BadRequestException('라인과 설비를 지정하세요.');
          // -2 * 참조건수 로 내려온다
          throw new ConflictException(
            `배포된 계획 ${Math.abs(code) / 2}건이 이 위치를 쓰고 있습니다. 계획을 먼저 지우세요.`,
          );
        });
      const after = await this.countLocations(qr, key.lineCode, key.machine, organizationId);
      return { deleted: before - after };
    });
  }
}
