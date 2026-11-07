import { FREE_RUN_MARK, MI_ORDER_EXISTS, MI_ORDER_RESULTS_SQL, MI_ORDERS_SQL } from './order-result.sql';

describe('order-result.sql', () => {
  it('MI_ORDER_EXISTS ties the run card to an MI plan by LOT_NO = MFS', () => {
    const sql = MI_ORDER_EXISTS('r');
    expect(sql).toContain('FROM IP_PRODUCT_MI_PLAN');
    expect(sql).toContain('.MFS = r.LOT_NO');
    expect(sql).toContain('.ORGANIZATION_ID = r.ORGANIZATION_ID');
  });

  it('MI_ORDER_EXISTS also counts the run cards made by the no-plan result screen, packing process only (semi-finished stays out)', () => {
    const sql = MI_ORDER_EXISTS('r');
    expect(FREE_RUN_MARK).toBe('[실적계획]');
    expect(sql).toContain("r.COMMENTS = '[실적계획]' AND r.WORKSTAGE_CODE = 'W220'");
    expect(sql.startsWith('(') && sql.endsWith(')')).toBe(true);
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

describe('MI_ORDERS_SQL (지시수량)', () => {
  it('reads the order quantity from run cards of MI plans', () => {
    expect(MI_ORDERS_SQL).toContain('FROM IP_PRODUCT_RUN_CARD r');
    expect(MI_ORDERS_SQL).toContain('r.LOT_SIZE');
    expect(MI_ORDERS_SQL).toContain('r.RUN_DATE');
    expect(MI_ORDERS_SQL).toContain(MI_ORDER_EXISTS('r'));
  });
});
