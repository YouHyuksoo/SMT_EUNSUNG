/**
 * @file src/modules/inventory-query/close-date.service.ts
 * @description 재고마감일자 설정 — 월별 마감 시작일~종료일을 미리 정해 둔다
 * PB 원본: PBL Library 10.5/w_system_inventory_close_date_setup.srw
 *
 * 초보자 가이드:
 * 1. 월(YYYYMM)마다 시작일·종료일을 `ISYS_INVENTORY_CLOSE_DATE` 에 등록한다. 자재·제품·공정 마감이 모두
 *    이 기간의 입출고만 그 달로 센다 (close-period.ts). 종료일은 그날 끝까지 포함한다.
 * 2. 기간은 서로 이어져야 한다 — 다음 달 시작일 = 이번 달 종료일 + 1일. 겹치거나 비면 어떤 입출고는
 *    두 달에 잡히거나 어느 달에도 안 잡힌다. 그래서 이웃한 달과 이어지지 않는 변경은 거절한다.
 * 3. **어느 마감(자재·제품·공정)이든 마감한 달은 바꾸거나 지울 수 없다.** 마감 결과가 그 기간으로 계산됐다.
 * 4. 연간 생성: 시작일(1~28)을 주면 12개월을 한 번에 만든다. 1 이면 달력 월, 26 이면 전달 26일~이번 달 25일.
 *    마감한 달이 있는 해는 거절한다 (PB 는 그 해를 통째로 지우고 다시 만들었다).
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { InjectDataSource } from '@nestjs/typeorm';
import { namedBinds } from '../../common/utils/named-binds.util';
import { affectedRows } from '../../common/utils/affected-rows.util';

type Row = Record<string, unknown>;
const DATE = /^\d{4}-\d{2}-\d{2}$/;

export interface ClosePeriodRow {
  yyyymm: string;
  startDate: string;
  endDate: string;
  /** 마감일자설정에 등록된 기간인가 (아니면 달력 월을 보여 주는 것) */
  registered: boolean;
  materialClosed: boolean;
  fgClosed: boolean;
  wipClosed: boolean;
  lastCloseDate: string | null;
}

const addDays = (ymd: string, n: number) => {
  const d = new Date(`${ymd}T00:00:00Z`);
  d.setUTCDate(d.getUTCDate() + n);
  return d.toISOString().slice(0, 10);
};
const monthOf = (yyyymm: string, n: number) => {
  const d = new Date(Date.UTC(Number(yyyymm.slice(0, 4)), Number(yyyymm.slice(4, 6)) - 1 + n, 1));
  return `${d.getUTCFullYear()}${String(d.getUTCMonth() + 1).padStart(2, '0')}`;
};
const firstOf = (yyyymm: string) => `${yyyymm.slice(0, 4)}-${yyyymm.slice(4, 6)}-01`;

/**
 * 연간 12개월 기간을 만든다. `startDay` 가 1 이면 달력 월, N 이면 전달 N일 ~ 이번 달 N−1일.
 * (PB 의 "Generate" 와 같은 규칙.)
 */
export function generateYearPeriods(year: number, startDay: number) {
  const out: { yyyymm: string; startDate: string; endDate: string }[] = [];
  for (let m = 1; m <= 12; m += 1) {
    const yyyymm = `${year}${String(m).padStart(2, '0')}`;
    if (startDay <= 1) {
      out.push({ yyyymm, startDate: firstOf(yyyymm), endDate: addDays(firstOf(monthOf(yyyymm, 1)), -1) });
    } else {
      const prev = monthOf(yyyymm, -1);
      const day = String(startDay).padStart(2, '0');
      out.push({
        yyyymm,
        startDate: `${prev.slice(0, 4)}-${prev.slice(4)}-${day}`,
        endDate: `${year}-${String(m).padStart(2, '0')}-${String(startDay - 1).padStart(2, '0')}`,
      });
    }
  }
  return out;
}

@Injectable()
export class CloseDateService {
  constructor(@InjectDataSource() private readonly dataSource: DataSource) {}

  /** 그 해 12개월의 기간과 마감 현황. 등록이 없는 달은 달력 월로 보여 준다. */
  async list(year: number, organizationId: number): Promise<ClosePeriodRow[]> {
    const yyyy = String(year);
    const rows = (await this.dataSource.query(
      `SELECT d.CLOSE_YYYYMM AS "yyyymm",
              TO_CHAR(TRUNC(d.START_DATE), 'YYYY-MM-DD') AS "startDate",
              TO_CHAR(TRUNC(d.END_DATE), 'YYYY-MM-DD') AS "endDate",
              d.CLOSE_YN AS "materialYn",
              TO_CHAR(d.LAST_CLOSE_DATE, 'YYYY-MM-DD HH24:MI') AS "lastCloseDate"
         FROM ISYS_INVENTORY_CLOSE_DATE d
        WHERE d.ORGANIZATION_ID = :organizationId AND d.CLOSE_YYYYMM LIKE :yyyy || '%'`,
      namedBinds({ organizationId, yyyy }),
    )) as Row[];
    const byMonth = new Map(rows.map((r) => [String(r.yyyymm), r]));
    // 제품·공정 마감은 등록이 없는 달에도 할 수 있어서 마감 표에서 따로 읽는다
    const fgSet = new Set(((await this.dataSource.query(
      `SELECT CLOSE_YYYYMM AS "ym" FROM IP_PRODUCT_FG_INV_CLOSE_MONTH
        WHERE ORGANIZATION_ID = :organizationId AND CLOSE_YN = 'Y' AND CLOSE_YYYYMM LIKE :yyyy || '%'`,
      namedBinds({ organizationId, yyyy }),
    )) as { ym: string }[]).map((r) => r.ym));
    const wipSet = new Set(((await this.dataSource.query(
      `SELECT DISTINCT CLOSE_YYYYMM AS "ym" FROM IM_ITEM_WORKSTAGE_INV_CLOSE
        WHERE ORGANIZATION_ID = :organizationId AND CLOSE_YYYYMM LIKE :yyyy || '%'`,
      namedBinds({ organizationId, yyyy }),
    )) as { ym: string }[]).map((r) => r.ym));

    const result: ClosePeriodRow[] = [];
    for (let m = 1; m <= 12; m += 1) {
      const yyyymm = `${yyyy}${String(m).padStart(2, '0')}`;
      const r = byMonth.get(yyyymm);
      result.push({
        yyyymm,
        startDate: (r?.startDate as string) ?? firstOf(yyyymm),
        endDate: (r?.endDate as string) ?? addDays(firstOf(monthOf(yyyymm, 1)), -1),
        registered: Boolean(r),
        materialClosed: r?.materialYn === 'Y',
        fgClosed: fgSet.has(yyyymm),
        wipClosed: wipSet.has(yyyymm),
        lastCloseDate: (r?.lastCloseDate as string) ?? null,
      });
    }
    return result;
  }

  /** 한 달의 기간을 등록·수정한다. */
  async save(yyyymm: string, startDate: string, endDate: string, organizationId: number, userId: string) {
    if (!DATE.test(startDate) || !DATE.test(endDate)) throw new BadRequestException('날짜는 YYYY-MM-DD 형식이어야 합니다.');
    if (startDate > endDate) throw new BadRequestException('시작일이 종료일보다 늦을 수 없습니다.');
    await this.assertNotClosed(yyyymm, organizationId);

    const neighbor = async (ym: string) => ((await this.dataSource.query(
      `SELECT TO_CHAR(TRUNC(START_DATE), 'YYYY-MM-DD') AS "s", TO_CHAR(TRUNC(END_DATE), 'YYYY-MM-DD') AS "e"
         FROM ISYS_INVENTORY_CLOSE_DATE WHERE CLOSE_YYYYMM = :ym AND ORGANIZATION_ID = :organizationId`,
      namedBinds({ ym, organizationId }),
    )) as { s: string; e: string }[])[0];
    const prev = await neighbor(monthOf(yyyymm, -1));
    if (prev && addDays(prev.e, 1) !== startDate) {
      throw new BadRequestException(`${monthOf(yyyymm, -1)} 종료일(${prev.e}) 다음 날(${addDays(prev.e, 1)})이 시작일이어야 합니다.`);
    }
    const next = await neighbor(monthOf(yyyymm, 1));
    if (next && addDays(endDate, 1) !== next.s) {
      throw new BadRequestException(`${monthOf(yyyymm, 1)} 시작일(${next.s}) 하루 전(${addDays(next.s, -1)})이 종료일이어야 합니다.`);
    }

    const updated = await this.dataSource.query(
      `UPDATE ISYS_INVENTORY_CLOSE_DATE
          SET START_DATE = TO_DATE(:startDate, 'YYYY-MM-DD'), END_DATE = TO_DATE(:endDate, 'YYYY-MM-DD'),
              LAST_MODIFY_DATE = SYSDATE, LAST_MODIFY_BY = :userId
        WHERE CLOSE_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId`,
      namedBinds({ startDate, endDate, userId, yyyymm, organizationId }),
    );
    if (!affectedRows(updated)) {
      await this.dataSource.query(
        `INSERT INTO ISYS_INVENTORY_CLOSE_DATE
           (CLOSE_YYYYMM, ORGANIZATION_ID, START_DATE, END_DATE, ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
         VALUES (:yyyymm, :organizationId, TO_DATE(:startDate, 'YYYY-MM-DD'), TO_DATE(:endDate, 'YYYY-MM-DD'),
                 SYSDATE, :userId, SYSDATE, :userId)`,
        namedBinds({ yyyymm, organizationId, startDate, endDate, userId }),
      );
    }
    return { yyyymm, startDate, endDate };
  }

  /** 등록을 지운다 (그 달은 달력 월로 돌아간다). */
  async remove(yyyymm: string, organizationId: number) {
    await this.assertNotClosed(yyyymm, organizationId);
    await this.dataSource.query(
      `DELETE FROM ISYS_INVENTORY_CLOSE_DATE WHERE CLOSE_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId`,
      namedBinds({ yyyymm, organizationId }),
    );
    return { yyyymm };
  }

  /** 한 해 12개월을 한 번에 만든다. 마감한 달이 있는 해는 거절한다. */
  async generate(year: number, startDay: number, organizationId: number, userId: string) {
    if (!(startDay >= 1 && startDay <= 28)) throw new BadRequestException('시작일은 1~28 이어야 합니다.');
    const yyyy = String(year);
    const closed = (await this.list(year, organizationId)).filter((r) => r.materialClosed || r.fgClosed || r.wipClosed);
    if (closed.length) {
      throw new BadRequestException(`${closed.map((r) => r.yyyymm).join(', ')} 은 이미 마감해서 ${yyyy}년 기간을 다시 만들 수 없습니다.`);
    }
    const periods = generateYearPeriods(year, startDay);
    return this.dataSource.transaction(async (manager) => {
      await manager.query(
        `DELETE FROM ISYS_INVENTORY_CLOSE_DATE WHERE CLOSE_YYYYMM LIKE :yyyy || '%' AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ yyyy, organizationId }),
      );
      for (const p of periods) {
        await manager.query(
          `INSERT INTO ISYS_INVENTORY_CLOSE_DATE
             (CLOSE_YYYYMM, ORGANIZATION_ID, START_DATE, END_DATE, ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
           VALUES (:yyyymm, :organizationId, TO_DATE(:startDate, 'YYYY-MM-DD'), TO_DATE(:endDate, 'YYYY-MM-DD'),
                   SYSDATE, :userId, SYSDATE, :userId)`,
          namedBinds({ yyyymm: p.yyyymm, organizationId, startDate: p.startDate, endDate: p.endDate, userId }),
        );
      }
      return { year, startDay, months: periods.length };
    });
  }

  private async assertNotClosed(yyyymm: string, organizationId: number) {
    if (!/^\d{6}$/.test(yyyymm)) throw new BadRequestException('월은 YYYYMM 형식이어야 합니다.');
    const row = (await this.list(Number(yyyymm.slice(0, 4)), organizationId)).find((r) => r.yyyymm === yyyymm);
    if (row && (row.materialClosed || row.fgClosed || row.wipClosed)) {
      const which = [row.materialClosed && '자재', row.fgClosed && '제품', row.wipClosed && '공정'].filter(Boolean).join('·');
      throw new BadRequestException(`${yyyymm} 은 이미 ${which} 마감을 한 달이라 기간을 바꿀 수 없습니다.`);
    }
  }
}
