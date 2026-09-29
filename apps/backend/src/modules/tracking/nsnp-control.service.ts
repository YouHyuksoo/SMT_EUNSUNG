/**
 * @file src/modules/tracking/nsnp-control.service.ts
 * @description NSNP(오삽 방지 인터록) 제어 — 세 화면이 공유한다
 *              321 w_com_production_status_dashboard     생산현황데쉬보드
 *              329 w_smt_plan_feeder_monitoring_master   SMT 피더별 모니터링
 *              335 w_pln_product_nsnp_history_query      NSNP 처리이력조회
 *
 * 초보자 가이드:
 * 1. **NSNP 는 라인을 세우는 장치다.** 오삽(잘못된 자재 장착)을 감지하면 라인을
 *    잠근다. 그래서 여기 있는 다섯 동작은 전부 생산에 직접 영향을 준다.
 * 2. **다섯 동작을 PB 버튼 이름 그대로 옮겼다.**
 *      lock     NSNP Lock       인터록을 건다 (라인이 멈춘다)
 *      unlock   NSNP UnLock     인터록을 강제로 푼다
 *      use      Use NSNP        NSNP 설비를 사용 상태로 (use_status='U')
 *      noUse    No Use NSNP     인터록을 풀고 설비를 미사용으로 (use_status='S')
 *      resetLog NSNP Log Reset  그 라인의 NSNP 이력을 지운다
 * 3. **PB 가 걸던 사용자 레벨 8 이상 가드를 그대로 유지한다.** JWT 의 role 은
 *    USER_LEVEL 을 ADMIN(9+)/MANAGER(5+)/OPERATOR 로 뭉개서 '8 이상' 을 표현할 수
 *    없다 — 레벨 8 을 MANAGER 로 낮춰 보면 5~7 사용자에게 라인 정지 권한이 생긴다.
 *    그래서 ISYS_USERS.USER_LEVEL 을 직접 읽는다 (**테이블 이름은 복수형이다** —
 *    엔티티 IsysUser 도 `@Entity({ name: 'ISYS_USERS' })` 로 매핑돼 있다.
 *    단수형으로 쓰면 ORA-00942 다).
 * 4. **세 화면이 같은 서비스를 부른다.** PB 는 같은 코드를 세 창에 복붙해 뒀는데,
 *    그러면 한 창에서만 가드가 고쳐지는 일이 생긴다.
 * 5. **noUse 는 두 문장이고 순서가 있다.** 프로시저(UNLOCK) → UPDATE(use_status='S').
 *    한 트랜잭션으로 묶는다 — UPDATE 만 실패하면 '잠금은 풀렸는데 사용중으로 남은'
 *    상태가 되어 나중에 아무도 원인을 찾지 못한다. PB 도 끝에 한 번만 COMMIT 한다.
 */
import { BadRequestException, ForbiddenException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { TransactionService } from '../../shared/transaction.service';

type Row = Record<string, unknown>;

/** PB w_com_production_status_dashboard cb_3/cb_4 · w_pln_product_nsnp_history_query 와 같은 기준 */
export const NSNP_MIN_USER_LEVEL = 8;

export type NsnpAction = 'lock' | 'unlock' | 'use' | 'noUse';

/** NSNP 설비의 사용 상태. IMCN_MACHINE.USE_STATUS (MACHINE_TYPE='NSNP') */
const USE_STATUS = { use: 'U', noUse: 'S' } as const;

@Injectable()
export class NsnpControlService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  /**
   * 사용자 레벨을 DB 에서 직접 읽어 가드한다. 통과하면 이름을 돌려준다
   * (이력 메시지에 누가 했는지 남겨야 한다).
   */
  private async requireLevel(userId: string): Promise<string> {
    const rows = (await this.dataSource.query(
      `SELECT NVL(USER_LEVEL, 0) AS "userLevel", USER_NAME AS "userName"
         FROM ISYS_USERS WHERE USER_ID = :userId`,
      { userId } as unknown as unknown[],
    )) as Row[];
    const level = Number(rows[0]?.userLevel ?? 0);
    if (level < NSNP_MIN_USER_LEVEL) {
      throw new ForbiddenException(
        `NSNP 제어는 사용자 레벨 ${NSNP_MIN_USER_LEVEL} 이상만 할 수 있습니다 (현재 ${level}).`,
      );
    }
    return String(rows[0]?.userName ?? userId);
  }

  /** 라인이 실제로 있는지 확인한다. 없는 라인코드로 프로시저를 부르면 조용히 아무 일도 안 한다. */
  private async requireLine(lineCode: string, organizationId: number): Promise<void> {
    const rows = (await this.dataSource.query(
      `SELECT COUNT(*) AS "cnt" FROM IP_PRODUCT_LINE
        WHERE LINE_CODE = :lineCode AND ORGANIZATION_ID = :organizationId`,
      { lineCode, organizationId } as unknown as unknown[],
    )) as Row[];
    if (Number(rows[0]?.cnt ?? 0) === 0) {
      throw new BadRequestException(`라인 ${lineCode} 을 찾을 수 없습니다.`);
    }
  }

  /** 처리 후 라인의 NSNP 상태를 되돌려준다. 화면이 '무엇이 바뀌었나' 를 보여줄 수 있어야 한다. */
  private async readStatus(lineCode: string, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT l.LINE_CODE                                AS "lineCode",
              l.LINE_NAME                                AS "lineName",
              l.LINE_STATUS                              AS "lineStatus",
              l.NSNP_STATUS                              AS "nsnpStatus",
              TO_CHAR(l.NSNP_START_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "nsnpStartDate",
              l.MODEL_NAME                               AS "modelName",
              m.USE_STATUS                               AS "useStatus",
              m.IP_ADDRESS                               AS "ipAddress"
         FROM IP_PRODUCT_LINE l
         LEFT JOIN IMCN_MACHINE m
                ON m.LINE_CODE = l.LINE_CODE
               AND m.ORGANIZATION_ID = l.ORGANIZATION_ID
               AND m.MACHINE_TYPE = 'NSNP'
        WHERE l.LINE_CODE = :lineCode AND l.ORGANIZATION_ID = :organizationId`,
      { lineCode, organizationId } as unknown as unknown[],
    )) as Row[];
    return rows[0] ?? null;
  }

  /**
   * 네 가지 제어 동작.
   *
   * 실측 시그니처:
   *   P_INTERLOCK_SET_NSNP_TIME_MSG(P_LINE_CODE, P_MESSAGE, P_TIME,
   *                                 P_MODEL_NAME, P_MODEL_SUFFIX,
   *                                 P_NSNP_REASON, P_NSNP_ERROR_MESSAGE)
   * PB 가 넘긴 값: LOCK 은 ('1', 1, '*', '*', 'LOCK', 사유문),
   *                UNLOCK 은 ('0', 0, '*', '*', 'UNLOCK', 사유문).
   *
   * **`MACHINE_TYPE = 'NSNP'` 는 WHERE 의 일부다.** 빼면 그 라인의 설비를 전부
   * 건드린다.
   */
  async control(
    action: NsnpAction,
    lineCode: string,
    organizationId: number,
    userId: string,
  ) {
    const userName = await this.requireLevel(userId);
    await this.requireLine(lineCode, organizationId);

    const before = await this.readStatus(lineCode, organizationId);

    await this.tx.run(async (qr) => {
      // 잠금/해제 프로시저를 먼저 부른다 (noUse 는 UNLOCK 을 포함한다).
      if (action !== 'use') {
        const lock = action === 'lock';
        await qr.query(
          `BEGIN P_INTERLOCK_SET_NSNP_TIME_MSG(:lineCode, :flag, :time,
                                               '*', '*', :reason, :message); END;`,
          {
            lineCode,
            flag: lock ? '1' : '0',
            time: lock ? 1 : 0,
            reason: lock ? 'LOCK' : 'UNLOCK',
            message: lock
              ? `[수동잠금] LOCK ${userName}`
              : `[강제해제] FORCE UNLOCK ${userName}`,
          } as unknown as unknown[],
        );
      }
      // use / noUse 는 설비 사용상태까지 바꾼다.
      if (action === 'use' || action === 'noUse') {
        await qr.query(
          `UPDATE IMCN_MACHINE
              SET USE_STATUS = :useStatus,
                  LAST_MODIFY_BY = :userId,
                  LAST_MODIFY_DATE = SYSDATE
            WHERE LINE_CODE = :lineCode
              AND MACHINE_TYPE = 'NSNP'
              AND ORGANIZATION_ID = :organizationId`,
          {
            useStatus: USE_STATUS[action],
            userId,
            lineCode,
            organizationId,
          } as unknown as unknown[],
        );
      }
    });

    return {
      action,
      lineCode,
      userLevel: NSNP_MIN_USER_LEVEL,
      before,
      after: await this.readStatus(lineCode, organizationId),
    };
  }

  /**
   * NSNP 이력 초기화 (PB 'NSNP Log Reset').
   *
   * **PB 는 `LINE_CODE LIKE :line || '%'` 로 지웠다.** 라인코드가 '1' 이면 '10'·'11'·
   * '12' 까지 함께 사라진다. 현재 데이터의 라인코드는 '01'~'12' 두 자리라 접두어가
   * 서로 겹치지 않아(실측) 지금은 등호와 결과가 같다 — 그래서 **등호로 바꿨다.**
   * 앞으로 한 자리 라인코드가 생겨도 옆 라인 이력이 날아가지 않는다.
   *
   * 되돌릴 수 없는 삭제라 지운 건수를 세어 돌려준다. 라인 하나에 10만 건 가까이
   * 쌓여 있다 (실측 라인 09 = 98,985건).
   */
  async resetLog(lineCode: string, organizationId: number, userId: string) {
    await this.requireLevel(userId);
    await this.requireLine(lineCode, organizationId);

    return this.tx.run(async (qr) => {
      const before = (await qr.query(
        `SELECT COUNT(*) AS "cnt" FROM IQ_MACHINE_INSPECT_NSNP
          WHERE LINE_CODE = :lineCode AND ORGANIZATION_ID = :organizationId`,
        { lineCode, organizationId } as unknown as unknown[],
      )) as Row[];
      await qr.query(
        `DELETE FROM IQ_MACHINE_INSPECT_NSNP
          WHERE LINE_CODE = :lineCode AND ORGANIZATION_ID = :organizationId`,
        { lineCode, organizationId } as unknown as unknown[],
      );
      const after = (await qr.query(
        `SELECT COUNT(*) AS "cnt" FROM IQ_MACHINE_INSPECT_NSNP
          WHERE LINE_CODE = :lineCode AND ORGANIZATION_ID = :organizationId`,
        { lineCode, organizationId } as unknown as unknown[],
      )) as Row[];
      return {
        lineCode,
        deleted: Number(before[0]?.cnt ?? 0) - Number(after[0]?.cnt ?? 0),
        rowsBefore: Number(before[0]?.cnt ?? 0),
        rowsAfter: Number(after[0]?.cnt ?? 0),
      };
    });
  }

  /** 삭제 전에 화면이 건수를 먼저 보여줄 수 있어야 한다 (확인 모달에 넣는다). */
  async countLog(lineCode: string, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT COUNT(*) AS "cnt" FROM IQ_MACHINE_INSPECT_NSNP
        WHERE LINE_CODE = :lineCode AND ORGANIZATION_ID = :organizationId`,
      { lineCode, organizationId } as unknown as unknown[],
    )) as Row[];
    return { lineCode, rows: Number(rows[0]?.cnt ?? 0) };
  }
}
