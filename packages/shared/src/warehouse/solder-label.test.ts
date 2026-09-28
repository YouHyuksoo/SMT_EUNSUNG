/**
 * @file packages/shared/src/warehouse/solder-label.test.ts
 * @description 솔더 라벨 바코드 규칙 테스트.
 *
 * **왜 이 테스트가 필요한가.** 라벨 발행은 운영 원장에 쓰는 경로라 실제로 돌려 볼 수
 * 없다 (사용자 결정: 쓰기는 parse 까지만). SQL parse 는 바코드가 11자인지, 일련번호가
 * 이어지는지, 999를 넘지 않는지 **아무것도 말해주지 않는다.** 그래서 위험한 부분을
 * 순수 함수로 떼어 여기서 못 박는다 (`reel-plan.test.ts` 와 같은 이유).
 */
import { describe, expect, it } from 'vitest';
import {
  buildSolderBarcode,
  checkSolderLabelPlan,
  planSolderBarcodes,
  SOLDER_DAY_MAX,
  solderTypeCode,
} from './solder-label';

const base = { dateYymmdd: '260928', lastSequence: 0, count: 1, factory: 'A' };

describe('solderTypeCode — 바코드 앞 1자', () => {
  it('무연(F)은 S 로 찍는다 (PB 그대로)', () => {
    expect(solderTypeCode('F')).toBe('S');
  });

  it('유연(P)은 그대로 쓴다', () => {
    expect(solderTypeCode('P')).toBe('P');
  });

  it('없거나 * 이면 빈 문자열이다 — PB 도 그 경우 발행을 멈춘다', () => {
    expect(solderTypeCode(null)).toBe('');
    expect(solderTypeCode('')).toBe('');
    expect(solderTypeCode('*')).toBe('');
  });
});

describe('checkSolderLabelPlan — 발행 가능 판정', () => {
  it('종류·날짜·공장·장수가 갖춰지면 발행할 수 있다', () => {
    expect(checkSolderLabelPlan({ ...base, solderType: 'F' })).toEqual({ ok: true });
  });

  it('솔더 종류가 없으면 거절한다', () => {
    const v = checkSolderLabelPlan({ ...base, solderType: null });
    expect(v.ok).toBe(false);
    expect(v.reason).toContain('솔더 종류');
  });

  it('발행일이 YYMMDD 6자리가 아니면 거절한다', () => {
    expect(checkSolderLabelPlan({ ...base, solderType: 'F', dateYymmdd: '20260928' }).ok)
      .toBe(false);
    expect(checkSolderLabelPlan({ ...base, solderType: 'F', dateYymmdd: '2609' }).ok)
      .toBe(false);
  });

  it('공장코드는 A·B 만 받는다 (PB ddlb_factory 목록)', () => {
    expect(checkSolderLabelPlan({ ...base, solderType: 'F', factory: 'B' }).ok).toBe(true);
    expect(checkSolderLabelPlan({ ...base, solderType: 'F', factory: 'C' }).ok).toBe(false);
    expect(checkSolderLabelPlan({ ...base, solderType: 'F', factory: '' }).ok).toBe(false);
  });

  it('장수가 0 이하이거나 소수면 거절한다', () => {
    expect(checkSolderLabelPlan({ ...base, solderType: 'F', count: 0 }).ok).toBe(false);
    expect(checkSolderLabelPlan({ ...base, solderType: 'F', count: -3 }).ok).toBe(false);
    expect(checkSolderLabelPlan({ ...base, solderType: 'F', count: 2.5 }).ok).toBe(false);
  });

  it('하루 999장을 넘기면 거절한다 — PB 는 검사만 하고 계속 진행했다', () => {
    // 경계: 마지막이 996 이면 3장은 되고 4장은 안 된다.
    expect(checkSolderLabelPlan({
      ...base, solderType: 'F', lastSequence: 996, count: 3,
    }).ok).toBe(true);
    const over = checkSolderLabelPlan({
      ...base, solderType: 'F', lastSequence: 996, count: 4,
    });
    expect(over.ok).toBe(false);
    expect(over.reason).toContain(String(SOLDER_DAY_MAX));
  });

  it('이미 999장이면 한 장도 못 찍는다', () => {
    expect(checkSolderLabelPlan({
      ...base, solderType: 'F', lastSequence: SOLDER_DAY_MAX, count: 1,
    }).ok).toBe(false);
  });
});

describe('buildSolderBarcode — 11자 고정 형식', () => {
  it('종류(1)+YYMMDD(6)+일련(3)+공장(1) 이다', () => {
    expect(buildSolderBarcode('S', '260928', 120, 'A')).toBe('S260928120A');
  });

  it('일련번호를 세 자리로 채운다', () => {
    expect(buildSolderBarcode('S', '251001', 1, 'B')).toBe('S251001001B');
  });

  it('실측 범위의 양 끝과 같은 모양이다 (S251001001B ~ S260916120A)', () => {
    expect(buildSolderBarcode('S', '251001', 1, 'B')).toBe('S251001001B');
    expect(buildSolderBarcode('S', '260916', 120, 'A')).toBe('S260916120A');
  });
});

describe('planSolderBarcodes — 발행 목록', () => {
  it('일련번호는 마지막 다음부터 이어 붙인다 (PB lvl_solder_day_seq + i)', () => {
    expect(planSolderBarcodes({
      ...base, solderType: 'F', lastSequence: 117, count: 3,
    })).toEqual(['S260928118A', 'S260928119A', 'S260928120A']);
  });

  it('그날 처음 찍으면 001 부터다', () => {
    expect(planSolderBarcodes({ ...base, solderType: 'F', count: 2 }))
      .toEqual(['S260928001A', 'S260928002A']);
  });

  it('장수만큼 나오고 전부 11자이며 겹치지 않는다', () => {
    const plans = planSolderBarcodes({
      ...base, solderType: 'P', lastSequence: 50, count: 40, factory: 'B',
    });
    expect(plans).toHaveLength(40);
    expect(plans.every((b) => b.length === 11)).toBe(true);
    expect(new Set(plans).size).toBe(40);
  });

  it('발행 불가한 입력은 던진다 (조용히 0장을 만들지 않는다)', () => {
    expect(() => planSolderBarcodes({ ...base, solderType: null }))
      .toThrow(/솔더 종류/);
    expect(() => planSolderBarcodes({
      ...base, solderType: 'F', lastSequence: 998, count: 5,
    })).toThrow(/999/);
  });
});
