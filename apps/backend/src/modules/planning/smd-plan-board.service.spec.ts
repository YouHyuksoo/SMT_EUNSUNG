import { groupNotes, normalizeNoteLines } from './smd-plan-board.service';

describe('smd-plan-board notes', () => {
  it('앞뒤 공백을 지우고 빈 줄은 버린다 (순서 유지)', () => {
    expect(normalizeNoteLines(['  ㄴ 마무리 후 K LINE 이관 ', '', '   ', '※ 야간 종업 07:30'])).toEqual([
      'ㄴ 마무리 후 K LINE 이관',
      '※ 야간 종업 07:30',
    ]);
  });

  it('라인코드별로 묶고 * 는 공지 묶음이 된다', () => {
    const groups = groupNotes([
      { lineCode: '*', noteText: '매주 화요일 대청소', enterBy: 'A', enterDate: '2026-10-02 08:00' },
      { lineCode: '01', noteText: '첫 줄', enterBy: 'B', enterDate: '2026-10-02 09:00' },
      { lineCode: '01', noteText: '둘째 줄', enterBy: 'B', enterDate: '2026-10-02 09:00' },
    ]);
    expect(groups['*'].lines).toEqual(['매주 화요일 대청소']);
    expect(groups['01']).toEqual({ lines: ['첫 줄', '둘째 줄'], enterBy: 'B', enterDate: '2026-10-02 09:00' });
  });
});
