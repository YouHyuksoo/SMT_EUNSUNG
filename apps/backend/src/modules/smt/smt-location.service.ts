/**
 * @file src/modules/smt/smt-location.service.ts
 * @description 라인별 테이블 관리 — PB w_smt_location_master 이식
 *
 * 초보자 가이드:
 * 1. **키에 MACHINE 이 없다.** 유일인덱스는 LINE_CODE + LOCATION_CODE + ORGANIZATION_ID 다.
 *    PB 는 삭제할 때 라인 + 설비로 지웠는데 그건 키가 아니라 범위 조건이다.
 *    수정·삭제의 WHERE 는 키를 쓰고, 일괄삭제만 라인 + 설비 범위를 쓴다.
 * 2. **위치는 배포계획이 참조한다.** IB_PRODUCT_PLANDATA.LOCATION_CODE 가 이 값이다.
 *    참조 중인 위치를 지우면 계획행이 없는 위치를 가리키므로 삭제를 막는다.
 *    PB 에는 이 검사가 없었다.
 * 3. 일괄삭제는 PKG_MES_SMT.SP_SMT_LOCATION_DELETE 를 쓴다 — 라인관리 화면과
 *    같은 오브젝트다. PB 는 두 화면이 서로 다른 DELETE 문을 갖고 있었다.
 */
import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { TransactionService } from '../../shared/transaction.service';
import {
  SmtLocationKeyDto,
  SmtLocationQueryDto,
  SmtLocationUpsertDto,
} from './smt-location.dto';
import { affectedRows } from '../../common/utils/affected-rows.util';
import { namedBinds } from '../../common/utils/named-binds.util';

const EDITABLE: Array<[column: string, field: keyof SmtLocationUpsertDto]> = [
  ['MACHINE', 'machine'],
  ['TABLE_ID', 'tableId'],
  ['TABLE_NO', 'tableNo'],
  ['COMMENTS', 'comments'],
];

@Injectable()
export class SmtLocationService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  private like(value?: string): string {
    return `${(value ?? '').trim()}%`;
  }

  /**
   * 목록 — PB d_ib_location_master_lst.
   *
   * 정렬은 PB vd_location_barcode 와 같다 — 테이블문자 먼저, 그 다음 주소.
   * 문자열 정렬로 두면 A10 이 A2 보다 앞에 온다.
   */
  async find(query: SmtLocationQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT l.LINE_CODE AS "lineCode", l.MACHINE AS "machine",
              l.LOCATION_CODE AS "locationCode", l.TABLE_ID AS "tableId",
              l.TABLE_NO AS "tableNo", l.COMMENTS AS "comments",
              lm.LINE_NAME AS "lineName", lm.MACHINE_NAME AS "machineName",
              (SELECT COUNT(*) FROM IB_PRODUCT_PLANDATA d
                WHERE d.LINE_CODE = l.LINE_CODE
                  AND d.LOCATION_CODE = l.LOCATION_CODE
                  AND d.ORGANIZATION_ID = l.ORGANIZATION_ID) AS "planUseCount",
              l.ENTER_BY AS "enterBy", l.ENTER_DATE AS "enterDate",
              l.LAST_MODIFY_BY AS "lastModifyBy", l.LAST_MODIFY_DATE AS "lastModifyDate"
         FROM IB_MACHINE_LOCATION l
         LEFT JOIN IB_LINE_MASTER lm
                ON lm.LINE_CODE = l.LINE_CODE
               AND lm.MACHINE = l.MACHINE
               AND lm.ORGANIZATION_ID = l.ORGANIZATION_ID
        WHERE l.ORGANIZATION_ID = :organizationId
          AND NVL(l.LINE_CODE, '*') LIKE :lineCode
          AND NVL(l.MACHINE, '*') LIKE :machine
          AND NVL(l.TABLE_ID, '*') LIKE :tableId
          AND NVL(l.LOCATION_CODE, '*') LIKE :locationCode
        ORDER BY l.LINE_CODE, l.MACHINE, l.TABLE_ID, SUBSTR(l.LOCATION_CODE, 2)`,
      namedBinds({
          organizationId,
          lineCode: this.like(query.lineCode),
          machine: this.like(query.machine),
          tableId: this.like(query.tableId),
          locationCode: this.like(query.locationCode),
        }),
    )) as Record<string, unknown>[];
    return { data: rows, total: rows.length };
  }

  async create(dto: SmtLocationUpsertDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      const [dup] = (await qr.query(
        `SELECT COUNT(*) AS CNT FROM IB_MACHINE_LOCATION
          WHERE LINE_CODE = :lineCode AND LOCATION_CODE = :locationCode
            AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ lineCode: dto.lineCode, locationCode: dto.locationCode, organizationId }),
      )) as { CNT: number }[];
      if (Number(dup?.CNT ?? 0) > 0) {
        throw new ConflictException(
          `이미 있는 위치입니다: ${dto.lineCode} / ${dto.locationCode}`
            + ' (같은 라인에서는 설비가 달라도 위치코드가 겹칠 수 없습니다.)',
        );
      }

      const columns = ['LINE_CODE', 'LOCATION_CODE', 'ORGANIZATION_ID'];
      const values = [':lineCode', ':locationCode', ':organizationId'];
      const binds: Record<string, unknown> = {
        lineCode: dto.lineCode,
        locationCode: dto.locationCode,
        organizationId,
        userId,
      };
      for (const [column, field] of EDITABLE) {
        columns.push(column);
        values.push(`:${field}`);
        binds[field] = dto[field] ?? null;
      }
      columns.push('ENTER_BY', 'ENTER_DATE', 'LAST_MODIFY_BY', 'LAST_MODIFY_DATE');
      values.push(':userId', 'SYSDATE', ':userId', 'SYSDATE');

      await qr.query(
        `INSERT INTO IB_MACHINE_LOCATION (${columns.join(', ')}) VALUES (${values.join(', ')})`,
        namedBinds(binds),
      );
      return { lineCode: dto.lineCode, locationCode: dto.locationCode };
    });
  }

  async update(dto: SmtLocationUpsertDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      const binds: Record<string, unknown> = {
        lineCode: dto.lineCode,
        locationCode: dto.locationCode,
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
        `UPDATE IB_MACHINE_LOCATION SET ${sets.join(', ')}
          WHERE LINE_CODE = :lineCode AND LOCATION_CODE = :locationCode
            AND ORGANIZATION_ID = :organizationId`,
        namedBinds(binds),
      );
      const affected = Number(affectedRows(result) ?? 0);
      if (affected === 0) {
        throw new NotFoundException(`위치를 찾을 수 없습니다: ${dto.lineCode} / ${dto.locationCode}`);
      }
      return { lineCode: dto.lineCode, locationCode: dto.locationCode, changed: affected };
    });
  }

  /** 한 건 삭제. 배포계획이 쓰고 있으면 거부한다 (PB 에 없던 검사). */
  async remove(key: SmtLocationKeyDto, organizationId: number) {
    return this.tx.run(async (qr) => {
      const [used] = (await qr.query(
        `SELECT COUNT(*) AS CNT FROM IB_PRODUCT_PLANDATA
          WHERE LINE_CODE = :lineCode AND LOCATION_CODE = :locationCode
            AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ lineCode: key.lineCode, locationCode: key.locationCode, organizationId }),
      )) as { CNT: number }[];
      const planRows = Number(used?.CNT ?? 0);
      if (planRows > 0) {
        throw new ConflictException(
          `배포된 계획 ${planRows}건이 이 위치를 쓰고 있습니다. 계획을 먼저 지우세요.`,
        );
      }

      const result = await qr.query(
        `DELETE FROM IB_MACHINE_LOCATION
          WHERE LINE_CODE = :lineCode AND LOCATION_CODE = :locationCode
            AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ lineCode: key.lineCode, locationCode: key.locationCode, organizationId }),
      );
      const affected = Number(affectedRows(result) ?? 0);
      if (affected === 0) {
        throw new NotFoundException(`위치를 찾을 수 없습니다: ${key.lineCode} / ${key.locationCode}`);
      }
      return { deleted: affected };
    });
  }
}
