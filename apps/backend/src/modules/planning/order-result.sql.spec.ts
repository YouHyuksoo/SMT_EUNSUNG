import { MI_ORDER_EXISTS, MI_ORDER_RESULTS_SQL } from './order-result.sql';

describe('order-result.sql', () => {
  it('MI_ORDER_EXISTS ties the run card to an MI plan by LOT_NO = MFS', () => {
    const sql = MI_ORDER_EXISTS('r');
    expect(sql).toContain('FROM IP_PRODUCT_MI_PLAN');
    expect(sql).toContain('.MFS = r.LOT_NO');
    expect(sql).toContain('.ORGANIZATION_ID = r.ORGANIZATION_ID');
  });

  it('MI_ORDER_RESULTS_SQL counts only confirmed results (no WIP, no CANCEL)', () => {
    expect(MI_ORDER_RESULTS_SQL).toContain("wr.RESULT_STATUS = 'DONE'");
    expect(MI_ORDER_RESULTS_SQL).not.toContain('CANCEL');
    expect(MI_ORDER_RESULTS_SQL).toContain('JOIN IP_PRODUCT_RUN_CARD r');
    expect(MI_ORDER_RESULTS_SQL).toContain(MI_ORDER_EXISTS('r'));
  });

  it('does not read process-pass history', () => {
    expect(MI_ORDER_RESULTS_SQL).not.toMatch(/WORKSTAGE_IO|ACTUAL_TIME_V/);
  });
});
