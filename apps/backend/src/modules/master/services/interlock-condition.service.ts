/**
 * @file src/modules/master/services/interlock-condition.service.ts
 * @description 인터락조건관리 — 라인·공정별로 공정 통과 때 돌릴 인터락 검사(IQ_INTERLOCK_CHECK_CONDITION)를 관리한다.
 *
 * 초보자 가이드:
 * 1. 테이블에 PK 가 없어 수정·삭제는 조회 때 받은 ROWID(rowKey)로 행을 찾는다.
 * 2. 같은 라인·공정·설비·검사유형·품목 조합은 한 번만 등록한다 (공정통과가 같은 검사를 두 번 돌지 않도록).
 * 3. 수정·삭제 이력은 DB 트리거(TRG_IQ_INTERLOCK_CHK_COND_UPD/DEL)가 IQ_INTERLOCK_CHECK_COND_LOG 에 남긴다.
 */
import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { namedBinds } from '../../../common/utils/named-binds.util';
import { CopyInterlockConditionDto, InterlockConditionQueryDto, SaveInterlockConditionDto } from '../dto/interlock-condition.dto';

type Row = Record<string, unknown>;

@Injectable()
export class InterlockConditionService {
  constructor(private readonly dataSource: DataSource) {}

  findAll(query: InterlockConditionQueryDto, organizationId: number) {
    const conditions = ['c.ORGANIZATION_ID = :organizationId'];
    const binds: Record<string, unknown> = { organizationId };
    for (const [field, column] of [['lineCode', 'LINE_CODE'], ['workstageCode', 'WORKSTAGE_CODE'], ['interlockCheckType', 'INTERLOCK_CHECK_TYPE']] as const) {
      const value = query[field];
      if (value) { conditions.push(`c.${column} = :${field}`); binds[field] = value; }
    }
    if (query.useYn) { conditions.push(`NVL(c.USE_YN, 'Y') = :useYn`); binds.useYn = query.useYn; }
    return this.query(`
      SELECT ROWIDTOCHAR(c.ROWID) AS "rowKey",
             c.LINE_CODE AS "lineCode", l.LINE_NAME AS "lineName",
             c.WORKSTAGE_CODE AS "workstageCode", w.WORKSTAGE_NAME AS "workstageName",
             c.MACHINE_CODE AS "machineCode",
             c.INTERLOCK_CHECK_TYPE AS "interlockCheckType",
             c.CHECK_LIMT_TIME AS "checkLimitTime", c.CHECK_SEQUENCE AS "checkSequence",
             c.ITEM_CODE AS "itemCode", i.ITEM_NAME AS "itemName", i.ITEM_SPEC AS "itemSpec",
             i.MODEL_NAME AS "modelName", i.MODEL_SUFFIX AS "modelSuffix",
             NVL(c.USE_YN, 'Y') AS "useYn",
             c.ENTER_DATE AS "enterDate", c.ENTER_BY AS "enterBy",
             c.LAST_MODIFY_DATE AS "lastModifyDate", c.LAST_MODIFY_BY AS "lastModifyBy"
        FROM IQ_INTERLOCK_CHECK_CONDITION c
        LEFT JOIN IP_PRODUCT_LINE l ON l.LINE_CODE = c.LINE_CODE AND l.ORGANIZATION_ID = c.ORGANIZATION_ID
        LEFT JOIN IP_PRODUCT_WORKSTAGE w ON w.WORKSTAGE_CODE = c.WORKSTAGE_CODE AND w.ORGANIZATION_ID = c.ORGANIZATION_ID
        LEFT JOIN ID_ITEM i ON i.ITEM_CODE = c.ITEM_CODE AND i.ORGANIZATION_ID = c.ORGANIZATION_ID
       WHERE ${conditions.join(' AND ')}
       ORDER BY c.LINE_CODE, c.WORKSTAGE_CODE, c.MACHINE_CODE, c.CHECK_SEQUENCE`, binds);
  }

  async create(dto: SaveInterlockConditionDto, organizationId: number, userId?: string) {
    const values = this.values(dto);
    await this.assertNoDuplicate(values, organizationId);
    await this.query(`
      INSERT INTO IQ_INTERLOCK_CHECK_CONDITION
        (LINE_CODE, WORKSTAGE_CODE, MACHINE_CODE, INTERLOCK_CHECK_TYPE, CHECK_LIMT_TIME, CHECK_SEQUENCE, ITEM_CODE, USE_YN,
         ORGANIZATION_ID, ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
      VALUES (:lineCode, :workstageCode, :machineCode, :interlockCheckType, :checkLimitTime, :checkSequence, :itemCode, :useYn,
         :organizationId, SYSDATE, :userId, SYSDATE, :userId)`, { ...values, organizationId, userId: userId ?? null });
    return { ...values };
  }

  async update(rowKey: string, dto: SaveInterlockConditionDto, organizationId: number, userId?: string) {
    const values = this.values(dto);
    await this.assertNoDuplicate(values, organizationId, rowKey);
    const affected = await this.execute(`
      UPDATE IQ_INTERLOCK_CHECK_CONDITION
         SET LINE_CODE = :lineCode, WORKSTAGE_CODE = :workstageCode, MACHINE_CODE = :machineCode,
             INTERLOCK_CHECK_TYPE = :interlockCheckType, CHECK_LIMT_TIME = :checkLimitTime,
             CHECK_SEQUENCE = :checkSequence, ITEM_CODE = :itemCode, USE_YN = :useYn,
             LAST_MODIFY_DATE = SYSDATE, LAST_MODIFY_BY = :userId
       WHERE ROWID = CHARTOROWID(:rowKey) AND ORGANIZATION_ID = :organizationId`,
      { ...values, organizationId, userId: userId ?? null, rowKey });
    if (affected === 0) throw new NotFoundException('수정할 인터락 조건을 찾지 못했습니다. 다시 조회한 뒤 시도하세요.');
    return { ...values };
  }

  async remove(rowKey: string, organizationId: number) {
    const affected = await this.execute(
      `DELETE FROM IQ_INTERLOCK_CHECK_CONDITION WHERE ROWID = CHARTOROWID(:rowKey) AND ORGANIZATION_ID = :organizationId`,
      { rowKey, organizationId });
    if (affected === 0) throw new NotFoundException('삭제할 인터락 조건을 찾지 못했습니다. 다시 조회한 뒤 시도하세요.');
    return { rowKey };
  }

  /**
   * 한 라인의 인터락 조건을 다른 라인으로 복사한다.
   * 대상 라인에 같은 공정·설비·검사유형·품목 조건이 이미 있으면 건너뛴다.
   */
  async copy(dto: CopyInterlockConditionDto, organizationId: number, userId?: string) {
    if (dto.fromLineCode === dto.toLineCode) throw new BadRequestException('원본 라인과 대상 라인이 같습니다.');
    const source = await this.query(
      `SELECT COUNT(*) AS "cnt" FROM IQ_INTERLOCK_CHECK_CONDITION WHERE LINE_CODE = :fromLineCode AND ORGANIZATION_ID = :organizationId`,
      { fromLineCode: dto.fromLineCode, organizationId });
    const sourceCount = Number(source[0]?.cnt ?? 0);
    if (sourceCount === 0) throw new BadRequestException(`라인 ${dto.fromLineCode} 에 복사할 인터락 조건이 없습니다.`);
    const inserted = await this.execute(`
      INSERT INTO IQ_INTERLOCK_CHECK_CONDITION
        (LINE_CODE, WORKSTAGE_CODE, MACHINE_CODE, INTERLOCK_CHECK_TYPE, CHECK_LIMT_TIME, CHECK_SEQUENCE, ITEM_CODE, USE_YN,
         ORGANIZATION_ID, ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
      SELECT :toLineCode, s.WORKSTAGE_CODE, s.MACHINE_CODE, s.INTERLOCK_CHECK_TYPE, s.CHECK_LIMT_TIME, s.CHECK_SEQUENCE, s.ITEM_CODE, s.USE_YN,
             s.ORGANIZATION_ID, SYSDATE, :userId, SYSDATE, :userId
        FROM IQ_INTERLOCK_CHECK_CONDITION s
       WHERE s.LINE_CODE = :fromLineCode AND s.ORGANIZATION_ID = :organizationId
         AND NOT EXISTS (
           SELECT 1 FROM IQ_INTERLOCK_CHECK_CONDITION t
            WHERE t.LINE_CODE = :toLineCode AND t.ORGANIZATION_ID = s.ORGANIZATION_ID
              AND t.WORKSTAGE_CODE = s.WORKSTAGE_CODE
              AND NVL(t.MACHINE_CODE, ' ') = NVL(s.MACHINE_CODE, ' ')
              AND NVL(t.INTERLOCK_CHECK_TYPE, ' ') = NVL(s.INTERLOCK_CHECK_TYPE, ' ')
              AND NVL(t.ITEM_CODE, ' ') = NVL(s.ITEM_CODE, ' '))`,
      { fromLineCode: dto.fromLineCode, toLineCode: dto.toLineCode, organizationId, userId: userId ?? null });
    return { inserted, skipped: sourceCount - inserted };
  }

  private values(dto: SaveInterlockConditionDto) {
    return {
      lineCode: dto.lineCode.trim(),
      workstageCode: dto.workstageCode.trim(),
      machineCode: dto.machineCode?.trim() || null,
      interlockCheckType: dto.interlockCheckType.trim(),
      checkLimitTime: dto.checkLimitTime ?? null,
      checkSequence: dto.checkSequence ?? null,
      itemCode: dto.itemCode?.trim() || null,
      useYn: dto.useYn,
    };
  }

  private async assertNoDuplicate(values: ReturnType<InterlockConditionService['values']>, organizationId: number, exceptRowKey?: string) {
    const rows = await this.query(`
      SELECT COUNT(*) AS "cnt" FROM IQ_INTERLOCK_CHECK_CONDITION
       WHERE ORGANIZATION_ID = :organizationId AND LINE_CODE = :lineCode AND WORKSTAGE_CODE = :workstageCode
         AND NVL(MACHINE_CODE, ' ') = NVL(:machineCode, ' ')
         AND INTERLOCK_CHECK_TYPE = :interlockCheckType
         AND NVL(ITEM_CODE, ' ') = NVL(:itemCode, ' ')
         ${exceptRowKey ? 'AND ROWID <> CHARTOROWID(:exceptRowKey)' : ''}`,
      {
        organizationId, lineCode: values.lineCode, workstageCode: values.workstageCode, machineCode: values.machineCode,
        interlockCheckType: values.interlockCheckType, itemCode: values.itemCode, ...(exceptRowKey ? { exceptRowKey } : {}),
      });
    if (Number(rows[0]?.cnt ?? 0) > 0) {
      throw new BadRequestException('같은 라인·공정·설비·검사유형·품목의 인터락 조건이 이미 있습니다.');
    }
  }

  private async query(sql: string, binds: Record<string, unknown>): Promise<Row[]> {
    try { return await this.dataSource.query(sql, namedBinds(binds)); } catch (error: unknown) { throw this.oracleError(error); }
  }

  /** DML 을 실행하고 영향받은 행 수를 돌려준다 */
  private async execute(sql: string, binds: Record<string, unknown>): Promise<number> {
    const runner = this.dataSource.createQueryRunner();
    try {
      await runner.connect();
      const result = await runner.query(sql, namedBinds(binds), true) as { affected?: number };
      return Number(result.affected ?? 0);
    } catch (error: unknown) {
      throw this.oracleError(error);
    } finally {
      await runner.release();
    }
  }

  private oracleError(error: unknown) {
    const driver = typeof error === 'object' && error !== null && 'driverError' in error ? error.driverError : undefined;
    const driverMessage = typeof driver === 'object' && driver !== null && 'message' in driver && typeof driver.message === 'string'
      ? driver.message : undefined;
    return new BadRequestException(driverMessage ?? (error instanceof Error ? error.message : undefined) ?? '인터락 조건 처리 중 오류가 발생했습니다.');
  }
}
