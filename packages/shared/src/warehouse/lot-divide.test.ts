/**
 * @file packages/shared/src/warehouse/lot-divide.test.ts
 * @description 자재 분할 규칙 테스트.
 *
 * **왜 이 테스트가 필요한가.** 분할은 재고를 만드는 경로라 실제로 돌려 볼 수 없다
 * (사용자 결정: 쓰기는 parse 까지만). 그리고 PB 의 "앞 N-1 조각만 새 바코드" 규칙을
 * 한 칸 틀리면 **수량이 한 조각만큼 늘어난다** — 재고가 조용히 부풀어 오른다.
 * SQL parse 는 그것을 말해주지 않는다.
 */
import { describe, expect, it } from 'vitest';
import {
  buildDivideBarcode,
  buildDivideLotNo,
  checkLotDivide,
  LOT_DIVIDE_MAX,
  planLotDivide,
} from './lot-divide';

describe('checkLotDivide — 분할 가능 판정', () => {
  it('조각이 2개 이상이면 나눌 수 있다', () => {
    expect(checkLotDivide([1000, 2000])).toEqual({ ok: true });
  });

  it('조각이 1개면 분할이 아니다 (PB 도 아무것도 하지 않는다)', () => {
    const v = checkLotDivide([3000]);
    expect(v.ok).toBe(false);
    expect(v.reason).toContain('2개 이상');
  });

  it('빈 목록도 거절한다', () => {
    expect(checkLotDivide([]).ok).toBe(false);
    expect(checkLotDivide(null).ok).toBe(false);
    expect(checkLotDivide(undefined).ok).toBe(false);
  });

  it('0 이하가 섞이면 거절한다', () => {
    expect(checkLotDivide([1000, 0]).ok).toBe(false);
    expect(checkLotDivide([1000, -500]).ok).toBe(false);
  });

  it('상한을 넘으면 거절한다 (PB 에는 상한이 없었다)', () => {
    const many = Array.from({ length: LOT_DIVIDE_MAX + 1 }, () => 1);
    expect(checkLotDivide(many).ok).toBe(false);
  });

  it('릴 수량을 주면 합이 맞는지도 본다 — PB 는 이것을 검사하지 않았다', () => {
    expect(checkLotDivide([1000, 1000, 1000], 3000)).toEqual({ ok: true });
    const off = checkLotDivide([1000, 1000, 1000], 2500);
    expect(off.ok).toBe(false);
    expect(off.reason).toContain('릴 수량');
  });

  it('릴 수량을 주지 않으면 합은 보지 않는다', () => {
    expect(checkLotDivide([1000, 1000]).ok).toBe(true);
    expect(checkLotDivide([1000, 1000], 0).ok).toBe(true);
  });
});

describe('planLotDivide — 앞 N-1 조각만 새 바코드다', () => {
  it('세 조각이면 새 바코드 2개 + 원본이 마지막 조각이 된다', () => {
    const plan = planLotDivide([1200, 800, 1000], 3000);
    expect(plan.newPieces).toEqual([1200, 800]);
    expect(plan.originalPiece).toBe(1000);
    expect(plan.pieceCount).toBe(3);
    expect(plan.totalQty).toBe(3000);
  });

  it('두 조각이면 새 바코드 1개 + 원본이 나머지다', () => {
    const plan = planLotDivide([500, 2500], 3000);
    expect(plan.newPieces).toEqual([500]);
    expect(plan.originalPiece).toBe(2500);
  });

  /**
   * 이 테스트가 이 파일의 존재 이유다. 새 바코드를 N개 만들면 원본까지 합쳐
   * N+1 조각이 되어 **수량이 한 조각만큼 늘어난다.**
   */
  it('새 바코드 수량 합 + 원본 수량 = 전체 수량이어야 한다 (수량이 늘지 않는다)', () => {
    for (const pieces of [[10, 20], [100, 200, 300], [1, 1, 1, 1, 1], [7, 13, 21, 59]]) {
      const plan = planLotDivide(pieces);
      const sum = plan.newPieces.reduce((s, q) => s + q, 0) + plan.originalPiece;
      expect(sum).toBe(plan.totalQty);
      expect(plan.newPieces.length).toBe(pieces.length - 1);
    }
  });

  it('분할할 수 없는 입력은 던진다 (조용히 0조각을 만들지 않는다)', () => {
    expect(() => planLotDivide([3000])).toThrow(/2개 이상/);
    expect(() => planLotDivide([1000, 1000], 3000)).toThrow(/릴 수량/);
  });
});

describe('분할 롯트번호·바코드 형식', () => {
  it('롯트번호 = 3글자 날짜코드 + 시퀀스 5자리 0 채움', () => {
    expect(buildDivideLotNo('69S', 42)).toBe('69S00042');
    expect(buildDivideLotNo('69S', 96510)).toBe('69S96510');
  });

  it('5자리를 넘는 시퀀스는 자르지 않는다 (번호가 바뀌면 안 된다)', () => {
    expect(buildDivideLotNo('69S', 123456)).toBe('69S123456');
  });

  it('바코드 = 품목코드-롯트번호-수량', () => {
    expect(buildDivideBarcode('E2760100010', '69S00042', 1200))
      .toBe('E2760100010-69S00042-1200');
  });
});
