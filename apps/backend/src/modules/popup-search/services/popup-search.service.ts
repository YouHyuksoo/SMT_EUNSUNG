/**
 * @file src/modules/popup-search/services/popup-search.service.ts
 * @description 공용 팝업조회 — 쿼리명 화이트리스트로만 SELECT 를 실행한다
 *
 * 클라이언트가 보내는 것은 **쿼리명 + 카탈로그에 선언된 필터값**뿐이다.
 * 컬럼명·테이블명·정렬·연산자·SQL 조각은 받지 않으며, 선언되지 않은 파라미터는
 * 무시하지 않고 400 으로 거부한다(오타를 조용히 넘기면 필터가 안 먹는 걸 못 본다).
 *
 * SQL 은 읽기 쉽게 명명 바인드(`:organizationId`)로 적고, 실행 직전에 Oracle 위치
 * 바인드(`:1`)로 바꾼다. TypeORM 의 `query()` 두번째 인자는 배열 타입이라 명명 바인드
 * 객체를 그대로 넘기려면 타입 단정이 필요한데, 아키텍처 테스트가 그 escape hatch 를 금지한다.
 */
import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectDataSource } from '@nestjs/typeorm';
import { DataSource } from 'typeorm';
import { findPopupByQuery } from '@smt/shared';
import { BindMatch, POPUP_QUERIES } from '../popup-search.queries';

type OracleRow = Record<string, unknown>;

/** 페이지 크기 상한 — 팝업은 스크롤 선택 UI 다. 대량 추출 용도가 아니다 */
const MAX_LIMIT = 500;
const DEFAULT_LIMIT = 100;

/** LIKE 메타문자 — 사용자 입력에서 제거한다 (PB 팝업도 와일드카드 입력을 지원하지 않았다) */
const LIKE_META = /[%_]/g;

/** SQL 안의 명명 바인드 */
const NAMED_BIND = /:([A-Za-z_][A-Za-z0-9_]*)/g;

/** 사용자 입력을 LIKE 패턴으로 만든다. PB retrieve 인자 형태와 같다 */
export function likePattern(value: string | undefined, match: BindMatch): string {
  const text = (value ?? '').trim().toUpperCase().replace(LIKE_META, '');
  if (!text) return '%';
  if (match === 'exact') return text;
  return match === 'prefix' ? `${text}%` : `%${text}%`;
}

/**
 * 명명 바인드 SQL 을 Oracle 위치 바인드로 바꾼다.
 * 같은 이름이 여러 번 나오면 같은 위치를 재사용한다.
 */
export function toPositionalBinds(
  sql: string,
  values: Readonly<Record<string, unknown>>,
): { sql: string; params: unknown[] } {
  const params: unknown[] = [];
  const positions = new Map<string, number>();
  const rewritten = sql.replace(NAMED_BIND, (_match, name: string) => {
    if (!(name in values)) {
      throw new Error(`바인드 값이 없습니다: ${name}`);
    }
    let position = positions.get(name);
    if (position === undefined) {
      params.push(values[name]);
      position = params.length;
      positions.set(name, position);
    }
    return `:${position}`;
  });
  return { sql: rewritten, params };
}

function toPositiveInt(value: string | undefined, fallback: number, max: number): number {
  if (value === undefined || value === '') return fallback;
  const parsed = Number(value);
  if (!Number.isInteger(parsed) || parsed < 1) {
    throw new BadRequestException(`잘못된 숫자 파라미터입니다: ${value}`);
  }
  return Math.min(parsed, max);
}

@Injectable()
export class PopupSearchService {
  constructor(@InjectDataSource() private readonly dataSource: DataSource) {}

  /**
   * @param queryName 카탈로그 엔트리의 `query`
   * @param params    요청 쿼리스트링 원본 (page/limit + 카탈로그 선언 필터)
   */
  async search(queryName: string, params: Record<string, string>, organizationId: number) {
    const entry = findPopupByQuery(queryName);
    const def = POPUP_QUERIES[queryName];
    if (!entry || !def) {
      throw new NotFoundException(`등록되지 않은 팝업 쿼리입니다: ${queryName}`);
    }

    const page = toPositiveInt(params.page, 1, Number.MAX_SAFE_INTEGER);
    const limit = toPositiveInt(params.limit, DEFAULT_LIMIT, MAX_LIMIT);

    const allowed = new Set(Object.keys(def.binds));
    const unknownKeys = Object.keys(params).filter(
      (key) => key !== 'page' && key !== 'limit' && !allowed.has(key),
    );
    if (unknownKeys.length > 0) {
      throw new BadRequestException(
        `팝업 ${queryName} 에 없는 검색 조건입니다: ${unknownKeys.join(', ')}`,
      );
    }

    const filterBinds: Record<string, unknown> = { organizationId };
    for (const [key, match] of Object.entries(def.binds)) {
      filterBinds[key] = likePattern(params[key], match);
    }

    const listSql = `${def.sql} ORDER BY ${def.orderBy} OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`;
    const list = toPositionalBinds(listSql, {
      ...filterBinds,
      offset: (page - 1) * limit,
      limit,
    });
    const count = toPositionalBinds(`SELECT COUNT(*) AS "total" FROM (${def.sql})`, filterBinds);

    const rows: OracleRow[] = await this.dataSource.query(list.sql, list.params);
    const totals: OracleRow[] = await this.dataSource.query(count.sql, count.params);

    return { data: rows, total: Number(totals[0]?.total ?? 0), page, limit };
  }
}
