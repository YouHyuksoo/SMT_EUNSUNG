import { BadRequestException } from '@nestjs/common';
import { SmtPlanService } from './smt-plan.service';

/** Line On/Off — 프로시저를 공용 트랜잭션 안에서 부르고, 결과가 OK 가 아니면 되돌린다 */
describe('SmtPlanService.lineOnOff', () => {
  const dto = { lineCode: ' 01 ', runNo: ' R1 ', pcbItem: 'T', onOff: 'ON', ps: 'P' };

  function serviceWith(err: string) {
    const qr = { query: jest.fn().mockResolvedValue({ err }) };
    const tx = { run: jest.fn(async (cb: (q: typeof qr) => unknown) => cb(qr)) };
    const dataSource = { createQueryRunner: jest.fn() };
    return { service: new SmtPlanService(dataSource as never, tx as never), qr, tx, dataSource };
  }

  it('runs the procedure inside TransactionService with an OUT string bind', async () => {
    const { service, qr, tx, dataSource } = serviceWith('OK');
    await expect(service.lineOnOff(dto as never, 'U')).resolves.toMatchObject({ onOff: 'ON', runNo: ' R1 ', message: 'OK' });
    expect(tx.run).toHaveBeenCalledTimes(1);
    expect(dataSource.createQueryRunner).not.toHaveBeenCalled();
    const binds = qr.query.mock.calls[0][1] as Record<string, unknown>;
    expect(binds).toMatchObject({ lineCode: '01', runNo: 'R1', inout: '1' });
    expect(binds.err).toMatchObject({ maxSize: 4000 });
  });

  it('throws (so the transaction rolls back) when the procedure does not return OK', async () => {
    const { service } = serviceWith('NG 장착 이력 없음');
    await expect(service.lineOnOff(dto as never, 'U')).rejects.toThrow(new BadRequestException('NG 장착 이력 없음'));
  });
});
