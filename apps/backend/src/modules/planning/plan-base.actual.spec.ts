import { PLAN_TABLES, PlanBaseService } from './plan-base.service';

/** 계획 목록의 실적 칸 — 제품생산계획은 그 계획에서 내려간 생산지시(런카드)의 확정 실적, 반제품생산계획은 센서 실적 뷰 */
function findSql(kind: 'mi' | 'smd') {
  const query = jest.fn().mockResolvedValue([]);
  const service = new PlanBaseService({ query } as never, {} as never);
  return service.find(PLAN_TABLES[kind], { dateFrom: '2026-10-01', dateTo: '2026-10-14' } as never, 1)
    .then(() => ({ sql: String(query.mock.calls[0][0]), binds: query.mock.calls[0][1] }));
}

describe('PlanBaseService.find actual columns', () => {
  it('MI plan actual comes from DONE work results of run cards whose LOT_NO is the plan MFS', async () => {
    const { sql } = await findSql('mi');
    expect(sql).not.toMatch(/ACTUAL_TIME_V|WORKSTAGE_IO|p\.ACTUAL_QTY/);
    expect(sql).toContain('IP_PRODUCT_WORK_RESULT');
    expect(sql).toContain("RESULT_STATUS = 'DONE'");
    expect(sql).toContain('ma.LOT_NO = p.MFS');
    expect(sql).toContain('v.LOT_NO = p.MFS');
    expect(sql).toContain('NVL(ma.ACTUAL_QTY, 0) AS "actualQty"');
  });

  it('MI time-slot actuals count only results whose business day is the plan date, bucketed by SMTWORKTIME', async () => {
    const { sql } = await findSql('mi');
    expect(sql).toContain('v.WORK_DAY = p.PLAN_DATE');
    expect(sql).toContain("RANGE_TYPE = 'SMTWORKTIME'");
    expect(sql).toContain('v.A_TIME_ACTUAL AS "actualTime1"');
    expect(sql).toContain('v.J_TIME_ACTUAL AS "actualTime10"');
  });

  it('MI plans without a real MFS (*) do not pick up actuals', async () => {
    const { sql } = await findSql('mi');
    expect(sql).toContain("p.MFS <> '*'");
  });

  it('SMD plan actual stays on the sensor actual view', async () => {
    const { sql } = await findSql('smd');
    expect(sql).toContain('LEFT JOIN IP_ASSEMBLY_ACTUAL_TIME_V v');
    expect(sql).toContain('p.ACTUAL_QTY AS "actualQty"');
    expect(sql).not.toContain('IP_PRODUCT_WORK_RESULT');
  });
});
