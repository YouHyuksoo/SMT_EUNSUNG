import { BadRequestException, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { TemperatureService } from './temperature.service';

describe('TemperatureService 이상 점검이력', () => {
  const query = jest.fn();
  const service = new TemperatureService({ query } as unknown as DataSource);

  beforeEach(() => query.mockReset());

  it('등록 — 항번은 SEQ_CHECK_SEQ, 확인여부 기본 W, 일시는 초까지 맞춘다', async () => {
    query.mockResolvedValueOnce([{ seq: 966924 }]).mockResolvedValueOnce(undefined);
    const result = await service.createCheck({
      machineCode: 'C8FD1974788C',
      checkStartDate: '2026-10-07T17:35',
      checkEndDate: '2026-10-07 17:35:30',
      ngReasonCode: 'E',
      comments: '가습기 작동',
    }, 1, 'LH');

    expect(result).toEqual({ machineCode: 'C8FD1974788C', checkSequence: 966924 });
    expect(query.mock.calls[0][0]).toContain('SEQ_CHECK_SEQ.NEXTVAL');
    const [sql, binds] = query.mock.calls[1];
    expect(sql).toContain("NVL(:confirmYn, 'W')");
    expect(binds).toMatchObject({
      checkStartDate: '2026-10-07 17:35:00', checkEndDate: '2026-10-07 17:35:30',
      machineCode: 'C8FD1974788C', checkSequence: 966924, confirmYn: null, actionCode: null,
    });
  });

  it('이상 시작이 종료보다 늦으면 막는다 (PB 검사식)', async () => {
    await expect(service.createCheck({
      machineCode: 'N1', checkStartDate: '2026-10-07 18:00', checkEndDate: '2026-10-07 17:00',
    }, 1, 'LH')).rejects.toBeInstanceOf(BadRequestException);
    expect(query).not.toHaveBeenCalled();
  });

  it('수정·삭제 — 없는 항번이면 NotFound', async () => {
    query.mockResolvedValue([{ cnt: 0 }]);
    await expect(service.updateCheck({
      machineCode: 'N1', checkSequence: 1,
      checkStartDate: '2026-10-07 17:00', checkEndDate: '2026-10-07 18:00',
    }, 1, 'LH')).rejects.toBeInstanceOf(NotFoundException);
    await expect(service.removeCheck({ machineCode: 'N1', checkSequence: 1 }, 1))
      .rejects.toBeInstanceOf(NotFoundException);
  });

  it('수정 — 설비·항번·조직으로 한 행만 고친다', async () => {
    query.mockResolvedValueOnce([{ cnt: 1 }]).mockResolvedValueOnce(undefined);
    await service.updateCheck({
      machineCode: 'N1', checkSequence: 7,
      checkStartDate: '2026-10-07 17:00', checkEndDate: '2026-10-07 18:00', actionCode: 'C',
    }, 1, 'LH');
    const [sql] = query.mock.calls[1];
    expect(sql).toContain('WHERE MACHINE_CODE = :machineCode AND CHECK_SEQUENCE = :checkSequence');
    expect(sql).toContain('AND ORGANIZATION_ID = :organizationId');
  });
});
