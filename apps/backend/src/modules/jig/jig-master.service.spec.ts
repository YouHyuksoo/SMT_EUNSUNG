import type { DataSource } from 'typeorm';
import type { TransactionService } from '../../shared/transaction.service';
import type { JigMasterUpsertDto } from './jig-master.dto';
import { JigMasterService } from './jig-master.service';

interface Scenario {
  originalMissing?: boolean;
  duplicate?: boolean;
  sameLotCodes?: string[];
  leftoverApplyModels?: number;
  mounted?: Array<{ lineCode: string; columnName: string }>;
}

/** 키 변경 경로의 SQL 을 가로채 시나리오별 결과를 돌려주고, 실행된 SQL 을 모은다. */
function setup(scenario: Scenario = {}) {
  const calls: { sql: string; binds: Record<string, unknown> }[] = [];
  const qr = {
    query: jest.fn(async (sql: string, binds: Record<string, unknown>) => {
      calls.push({ sql, binds });
      if (sql.includes('FOR UPDATE')) return scenario.originalMissing ? [] : [{ JIG_CODE: 'OLD' }];
      if (/FROM IMCN_JIG\s+WHERE JIG_CODE = :toCode AND JIG_LOT_NO = :toLot/.test(sql)) {
        return [{ cnt: scenario.duplicate ? 1 : 0 }];
      }
      if (sql.includes('JIG_CODE <> :toCode')) {
        return (scenario.sameLotCodes ?? []).map((jigCode) => ({ jigCode }));
      }
      if (sql.includes('COUNT(*) AS "cnt" FROM IMCN_JIG_APPLY_MODEL')) {
        return [{ cnt: scenario.leftoverApplyModels ?? 0 }];
      }
      if (sql.includes('FROM IP_PRODUCT_LINE')) return scenario.mounted ?? [];
      return { rowsAffected: 1 };
    }),
  };
  const tx = { run: (cb: (q: typeof qr) => Promise<unknown>) => cb(qr) } as unknown as TransactionService;
  const dataSource = { query: jest.fn(async () => [{ cnt: 1 }]) };
  const service = new JigMasterService(dataSource as unknown as DataSource, tx);
  return { service, calls, dataSource };
}

const dto = (patch: Partial<JigMasterUpsertDto> = {}): JigMasterUpsertDto => ({
  jigCode: 'NEW', jigLotNo: 'NEWLOT', jigName: '마스크', jigType: 'M',
  originalJigCode: 'OLD', originalJigLotNo: 'OLDLOT',
  ...patch,
} as JigMasterUpsertDto);

const updates = (calls: { sql: string }[]) => calls.filter((c) => /^\s*UPDATE/.test(c.sql));

describe('JigMasterService.update — 지그코드·지그LOT 변경', () => {
  it('키가 그대로면 트랜잭션 없이 IMCN_JIG 한 행만 고친다', async () => {
    const { service, calls, dataSource } = setup();
    await service.update(dto({ originalJigCode: 'NEW', originalJigLotNo: 'NEWLOT' }), 1, 'tester');
    expect(calls).toHaveLength(0);
    const sqls = dataSource.query.mock.calls.map((c) => String((c as unknown[])[0]));
    expect(sqls.some((sql) => sql.includes('UPDATE IMCN_JIG SET'))).toBe(true);
    expect(sqls.some((sql) => sql.includes('IMCN_JIG_APPLY_MODEL'))).toBe(false);
  });

  it('키가 바뀌면 IMCN_JIG 와 적용모델 키만 새 값으로 바꾸고 이력 테이블은 건드리지 않는다', async () => {
    const { service, calls } = setup();
    const result = await service.update(dto(), 1, 'tester');
    expect(result).toEqual({ jigCode: 'NEW', jigLotNo: 'NEWLOT' });

    const changed = updates(calls);
    expect(changed).toHaveLength(2);
    expect(changed[0].sql).toContain('UPDATE IMCN_JIG SET JIG_CODE = :toCode, JIG_LOT_NO = :toLot');
    expect(changed[1].sql).toContain('UPDATE IMCN_JIG_APPLY_MODEL');
    for (const call of changed) {
      expect(call.binds).toMatchObject({ fromCode: 'OLD', fromLot: 'OLDLOT', toCode: 'NEW', toLot: 'NEWLOT' });
    }
    const touched = calls.map((c) => c.sql).join('\n');
    for (const history of ['INPUT_HIST', 'MASK_CHECK', 'SQUEZE_CHECK', 'IMCN_JIG_REPAIR', 'IP_PRODUCT_2D_BARCODE']) {
      expect(touched).not.toContain(history);
    }
  });

  it('원래 지그가 없으면 404', async () => {
    const { service, calls } = setup({ originalMissing: true });
    await expect(service.update(dto(), 1, 'tester')).rejects.toThrow('지그를 찾을 수 없습니다');
    expect(updates(calls)).toHaveLength(0);
  });

  it('새 키가 이미 있으면 막는다', async () => {
    const { service, calls } = setup({ duplicate: true });
    await expect(service.update(dto(), 1, 'tester')).rejects.toThrow('이미 등록된 지그입니다 (NEW/NEWLOT)');
    expect(updates(calls)).toHaveLength(0);
  });

  it('새 LOT 을 다른 지그코드가 쓰고 있으면 막는다', async () => {
    const { service, calls } = setup({ sameLotCodes: ['OTHER'] });
    await expect(service.update(dto(), 1, 'tester'))
      .rejects.toThrow('지그LOT NEWLOT 을 다른 지그코드(OTHER)가 사용하고 있습니다');
    expect(updates(calls)).toHaveLength(0);
  });

  it('새 키로 남아 있는 적용모델이 있으면 막는다', async () => {
    const { service, calls } = setup({ leftoverApplyModels: 2 });
    await expect(service.update(dto(), 1, 'tester')).rejects.toThrow('적용모델 2건');
    expect(updates(calls)).toHaveLength(0);
  });

  it('라인에 장착(직전 장착 포함)돼 있으면 어느 라인·칸인지 알려 주고 막는다', async () => {
    const { service, calls } = setup({
      mounted: [
        { lineCode: '07', columnName: 'MASK_LOT_NO' },
        { lineCode: '08', columnName: 'LAST_SQUEEZE_LOT_NO2' },
      ],
    });
    await expect(service.update(dto(), 1, 'tester'))
      .rejects.toThrow('라인 07 메탈마스크, 라인 08 직전 스퀴즈2');
    expect(updates(calls)).toHaveLength(0);
    const mountSql = calls.find((c) => c.sql.includes('IP_PRODUCT_LINE'))!;
    expect(mountSql.binds).toMatchObject({ fromLot: 'OLDLOT' });
    for (const column of ['MASK_LOT_NO2', 'SQUEEZE_LOT_NO', 'SQUEZE_LOT_NO', 'LAST_MASK_LOT_NO']) {
      expect(mountSql.sql).toContain(`${column} = :fromLot`);
    }
  });

  it('새 LOT 이 적용모델 LOT 칸(50자)보다 길면 DB 를 보기 전에 막는다', async () => {
    const { service, calls } = setup();
    await expect(service.update(dto({ jigLotNo: 'L'.repeat(51) }), 1, 'tester'))
      .rejects.toThrow('50자까지');
    expect(calls).toHaveLength(0);
  });
});
