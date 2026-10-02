/**
 * @file src/modules/smt/smt-plan.service.ts
 * @description SMT 계획배포관리 — PB w_smt_plan_master 이식
 *
 * 초보자 가이드:
 * 1. **"배포" 는 BOM 을 현장용 계획으로 펼치는 일이다.** ID_ENG_BOM_SMT(설계) →
 *    IB_PRODUCT_PLANDATA(현장). 펼친 뒤에는 현장이 이 표를 보고 자재를 물린다.
 * 2. **ACTIVE_YN 이 이 화면의 핵심이다.** 'Y' 면 현장이 쓰는 계획이다.
 *    - 배포: 활성 계획이 있으면 거부. 이미 행이 있으면 거부 (지우고 다시 하라는 뜻).
 *    - 삭제: 비활성 행만 지운다. 지우기 전에 백업 테이블로 옮긴다.
 *    - 활성화: 한 라인에 두 모델이 동시에 활성이 되지 않게 막는다.
 *      PB 에는 이 배타 검사가 없었다 — 두 모델이 활성이면 현장이 어느 계획으로
 *      자재를 물릴지 알 수 없다.
 * 3. **가드와 배포 SQL 은 전부 PKG_MES_SMT 안에 있다.** PB 화면과 웹이 같은
 *    오브젝트를 불러야 결과가 갈리지 않는다. 조직경계 보정도 거기 적어 뒀다.
 * 4. **PLAN_DATE 는 'YYYYMMDD' 로 넣는다.** PB 는 일반품목에 SYSDATE 를 그대로
 *    넣어 세션 NLS 에 따라 문자열이 달라졌다 (실측 18,568행 'DD-MON-YY').
 *    기존 데이터는 고치지 않는다.
 * 5. **CHECK_STATUS / CCS_YN 은 조회·표시만 한다.** 그 값을 바꾸는 것은 현장
 *    스캔·풀체크 화면의 일이고 이 화면이 아니다.
 */
import { BadRequestException, ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { TransactionService } from '../../shared/transaction.service';
import {
  SmtPlanDeleteDto,
  SmtPlanDeployDto,
  SmtPlanQueryDto,
  SmtPlanSetActiveDto,
} from './smt-plan.dto';
import { namedBinds } from '../../common/utils/named-binds.util';

@Injectable()
export class SmtPlanService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  private like(value?: string): string {
    return `${(value ?? '').trim()}%`;
  }

  /** 목록 — PB d_smt_plandata_lst / d_smt_plandata_simple_4_plan. */
  async find(query: SmtPlanQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT d.MODEL_NAME AS "modelName", d.MODEL_SUFFIX AS "modelSuffix",
              d.ITEM_CODE AS "itemCode", i.ITEM_NAME AS "itemName",
              i.ITEM_SPEC AS "itemSpec", i.ITEM_UOM AS "itemUom",
              d.LINE_CODE AS "lineCode", lm.LINE_NAME AS "lineName",
              d.MACHINE AS "machine", lm.MACHINE_NAME AS "machineName",
              d.LOCATION_CODE AS "locationCode", d.LOCATION_INFO AS "locationInfo",
              d.TABLE_ID AS "tableId",
              d.PCB_ITEM AS "pcbItem", pcb.CODE_MEAN_KOR AS "pcbItemName",
              d.PLAN_DATE AS "planDate", d.PLAN_DATE_SEQUENCE AS "planDateSequence",
              d.ITEM_UNIT_QTY AS "itemUnitQty", d.FEEDING_QTY AS "feedingQty",
              d.CHECK_YN AS "checkYn",
              d.CHECK_STATUS AS "checkStatus", cs.CODE_MEAN_KOR AS "checkStatusName",
              d.CHECK_MSG AS "checkMsg",
              d.ACTIVE_YN AS "activeYn", act.CODE_MEAN_KOR AS "activeYnName",
              d.CCS_YN AS "ccsYn", ccs.CODE_MEAN_KOR AS "ccsYnName",
              d.REPLACE_YN AS "replaceYn",
              d.FULL_CHECK_YN AS "fullCheckYn", d.FULL_CHECK_TIME AS "fullCheckTime",
              d.REVISION AS "revision", d.FEEDER_SHAFT AS "feederShaft",
              d.LOT_NO AS "lotNo", d.ITEM_BARCODE AS "itemBarcode",
              d.FEEDING_DATE AS "feedingDate", d.FEEDING_END_DATE AS "feedingEndDate",
              d.CHANGE_DATE AS "changeDate", d.RECYCLE_DATE AS "recycleDate",
              d.SMT_MODEL_NAME AS "smtModelName",
              d.ENTER_BY AS "enterBy", d.ENTER_DATE AS "enterDate",
              d.LAST_MODIFY_BY AS "lastModifyBy", d.LAST_MODIFY_DATE AS "lastModifyDate"
         FROM IB_PRODUCT_PLANDATA d
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = d.ITEM_CODE AND i.ORGANIZATION_ID = d.ORGANIZATION_ID
         LEFT JOIN IB_LINE_MASTER lm
                ON lm.LINE_CODE = d.LINE_CODE AND lm.MACHINE = d.MACHINE
               AND lm.ORGANIZATION_ID = d.ORGANIZATION_ID
         LEFT JOIN ISYS_BASECODE pcb
                ON pcb.CODE_TYPE = 'PCB ITEM' AND pcb.CODE_NAME = d.PCB_ITEM
         LEFT JOIN ISYS_BASECODE cs
                ON cs.CODE_TYPE = 'CHECK STATUS' AND cs.CODE_NAME = d.CHECK_STATUS
         LEFT JOIN ISYS_BASECODE act
                ON act.CODE_TYPE = 'ACTIVE YN' AND act.CODE_NAME = d.ACTIVE_YN
         LEFT JOIN ISYS_BASECODE ccs
                ON ccs.CODE_TYPE = 'CCS YN' AND ccs.CODE_NAME = d.CCS_YN
        WHERE d.ORGANIZATION_ID = :organizationId
          AND d.MODEL_NAME = :modelName
          AND NVL(d.LINE_CODE, '*') LIKE :lineCode
          AND NVL(d.PCB_ITEM, '*') LIKE :pcbItem
          AND NVL(d.FEEDER_SHAFT, '*') LIKE :feederShaft
          AND NVL(d.REVISION, '0000') LIKE :revision
          AND NVL(d.REPLACE_YN, 'N') LIKE :replaceYn
          AND NVL(d.ACTIVE_YN, 'N') LIKE :activeYn
        ORDER BY d.LINE_CODE, d.MACHINE, d.TABLE_ID, SUBSTR(d.LOCATION_CODE, 2)`,
      namedBinds({
          organizationId,
          modelName: query.modelName.trim(),
          lineCode: this.like(query.lineCode),
          pcbItem: this.like(query.pcbItem),
          feederShaft: this.like(query.feederShaft),
          revision: this.like(query.revision),
          replaceYn: this.like(query.replaceYn),
          activeYn: this.like(query.activeYn),
        }),
    )) as Record<string, unknown>[];
    return { data: rows, total: rows.length };
  }

  /**
   * 라인별 배포 요약 — 이 화면에서 "지금 어느 라인이 무엇을 물고 있나" 를 본다.
   * PB d_ib_line_master_distinct_4_plan_lst 는 IP_PRODUCT_LINE(LINE_DIVISION='D',
   * 15행)을 읽었다. 이름이 line_master 라 IB_LINE_MASTER 로 착각하기 쉽다.
   */
  async findLineSummary(organizationId: number) {
    return (await this.dataSource.query(
      `SELECT l.LINE_CODE AS "lineCode", l.LINE_NAME AS "lineName",
              l.LINE_STATUS AS "lineStatus", l.NSNP_STATUS AS "nsnpStatus",
              l.MES_DISPLAY_SEQUENCE AS "displaySequence",
              (SELECT COUNT(*) FROM IB_PRODUCT_PLANDATA d
                WHERE d.LINE_CODE = l.LINE_CODE
                  AND d.ORGANIZATION_ID = l.ORGANIZATION_ID) AS "planRows",
              (SELECT MAX(d.MODEL_NAME) FROM IB_PRODUCT_PLANDATA d
                WHERE d.LINE_CODE = l.LINE_CODE
                  AND d.ORGANIZATION_ID = l.ORGANIZATION_ID
                  AND d.ACTIVE_YN = 'Y') AS "activeModelName",
              (SELECT COUNT(DISTINCT d.MODEL_NAME) FROM IB_PRODUCT_PLANDATA d
                WHERE d.LINE_CODE = l.LINE_CODE
                  AND d.ORGANIZATION_ID = l.ORGANIZATION_ID
                  AND d.ACTIVE_YN = 'Y') AS "activeModelCount"
         FROM IP_PRODUCT_LINE l
        WHERE l.ORGANIZATION_ID = :organizationId
          AND l.LINE_CODE <> '*'
          AND l.LINE_DIVISION = 'D'
        ORDER BY l.MES_DISPLAY_SEQUENCE, l.LINE_NAME`,
      namedBinds({ organizationId }),
    )) as Record<string, unknown>[];
  }

  /** 같은 라인·모델·면의 계획 건수. 프로시저 전후를 비교하는 데 쓴다. */
  private async countPlan(
    qr: { query: <T>(sql: string, params?: unknown[]) => Promise<T> },
    lineCode: string,
    modelName: string,
    pcbItem: string,
    organizationId: number,
  ): Promise<number> {
    const rows = (await qr.query(
      `SELECT COUNT(*) AS CNT FROM IB_PRODUCT_PLANDATA
        WHERE LINE_CODE = :lineCode AND MODEL_NAME = :modelName
          AND NVL(PCB_ITEM, '*') LIKE :pcbItem
          AND ORGANIZATION_ID = :organizationId`,
      namedBinds({ lineCode, modelName, pcbItem, organizationId }),
    )) as { CNT: number }[];
    return Number(rows?.[0]?.CNT ?? 0);
  }

  /** 배포 — PKG_MES_SMT.SP_SMT_PLAN_DEPLOY. */
  async deploy(dto: SmtPlanDeployDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      const before = await this.countPlan(
        qr, dto.lineCode, dto.modelName, dto.pcbItem, organizationId,
      );
      await qr
        .query(
          `DECLARE
             v_existing NUMBER;
             v_result   NUMBER;
           BEGIN
             PKG_MES_SMT.SP_SMT_PLAN_DEPLOY(
               :lineCode, :modelName, :pcbItem, :feederShaft,
               :organizationId, :userId, v_existing, v_result);
             IF v_result < 0 THEN
               RAISE_APPLICATION_ERROR(-20034,
                 'SMT_PLAN_DEPLOY_FAILED:' || v_result || ':' || v_existing);
             END IF;
           END;`,
          namedBinds({
              lineCode: dto.lineCode,
              modelName: dto.modelName,
              pcbItem: dto.pcbItem,
              feederShaft: dto.feederShaft ? `${dto.feederShaft}%` : '%',
              organizationId,
              userId,
            }),
        )
        .catch((error: unknown) => {
          const message = error instanceof Error ? error.message : String(error);
          const matched = /SMT_PLAN_DEPLOY_FAILED:(-?\d+):(\d+)/.exec(message);
          if (!matched) throw error;
          const code = Number(matched[1]);
          const existing = Number(matched[2]);
          if (code === -1) {
            throw new ConflictException(
              `${dto.lineCode} 라인의 ${dto.modelName} 계획이 이미 활성 상태입니다.`
              + ' 비활성으로 바꾼 뒤 지우고 다시 배포하세요.',
            );
          }
          if (code === -2) {
            throw new ConflictException(
              `이미 배포된 계획 ${existing}건이 있습니다. 먼저 배포를 취소하세요.`,
            );
          }
          if (code === -3) {
            throw new NotFoundException(
              `배포할 BOM 이 없습니다: ${dto.modelName} / ${dto.lineCode} / ${dto.pcbItem} 면`,
            );
          }
          throw new BadRequestException(`배포 실패 (${code})`);
        });
      const after = await this.countPlan(
        qr, dto.lineCode, dto.modelName, dto.pcbItem, organizationId,
      );
      return { deployed: after - before, total: after };
    });
  }

  /** 배포 취소 — PKG_MES_SMT.SP_SMT_PLAN_DELETE. 비활성 행만 지운다. */
  async remove(dto: SmtPlanDeleteDto, organizationId: number) {
    const pcb = dto.pcbItem ? `${dto.pcbItem}%` : '%';
    return this.tx.run(async (qr) => {
      const before = await this.countPlan(
        qr, dto.lineCode, dto.modelName, pcb, organizationId,
      );
      await qr
        .query(
          `DECLARE
             v_result NUMBER;
           BEGIN
             PKG_MES_SMT.SP_SMT_PLAN_DELETE(
               :lineCode, :modelName, :pcbItem, :feederShaft,
               :organizationId, v_result);
             IF v_result < 0 THEN
               RAISE_APPLICATION_ERROR(-20035, 'SMT_PLAN_DELETE_FAILED:' || v_result);
             END IF;
           END;`,
          namedBinds({
              lineCode: dto.lineCode,
              modelName: dto.modelName,
              pcbItem: pcb,
              feederShaft: dto.feederShaft ? `${dto.feederShaft}%` : '%',
              organizationId,
            }),
        )
        .catch((error: unknown) => {
          const message = error instanceof Error ? error.message : String(error);
          const matched = /SMT_PLAN_DELETE_FAILED:(-?\d+)/.exec(message);
          if (!matched) throw error;
          throw new BadRequestException('라인과 모델을 지정하세요.');
        });
      const after = await this.countPlan(
        qr, dto.lineCode, dto.modelName, pcb, organizationId,
      );
      // 남은 건수는 활성 행이다 — 프로시저가 비활성만 지운다
      return { deleted: before - after, remainingActive: after };
    });
  }

  /** 활성/비활성 전환 — PKG_MES_SMT.SP_SMT_PLAN_SET_ACTIVE. */
  async setActive(dto: SmtPlanSetActiveDto, organizationId: number, userId: string) {
    const pcb = dto.pcbItem ? `${dto.pcbItem}%` : '%';
    return this.tx.run(async (qr) => {
      await qr
        .query(
          `DECLARE
             v_result NUMBER;
           BEGIN
             PKG_MES_SMT.SP_SMT_PLAN_SET_ACTIVE(
               :lineCode, :modelName, :pcbItem, :activeYn,
               :organizationId, :userId, v_result);
             IF v_result < 0 THEN
               RAISE_APPLICATION_ERROR(-20036, 'SMT_PLAN_SET_ACTIVE_FAILED:' || v_result);
             END IF;
           END;`,
          namedBinds({
              lineCode: dto.lineCode,
              modelName: dto.modelName,
              pcbItem: pcb,
              activeYn: dto.activeYn,
              organizationId,
              userId,
            }),
        )
        .catch((error: unknown) => {
          const message = error instanceof Error ? error.message : String(error);
          const matched = /SMT_PLAN_SET_ACTIVE_FAILED:(-?\d+)/.exec(message);
          if (!matched) throw error;
          if (Number(matched[1]) === -1) {
            throw new NotFoundException(
              `계획이 없습니다: ${dto.modelName} / ${dto.lineCode}`,
            );
          }
          throw new ConflictException(
            `${dto.lineCode} 라인에 이미 활성인 다른 모델이 있습니다.`
            + ' 한 라인에 두 모델이 동시에 활성일 수 없습니다.',
          );
        });
      // 전환 결과를 다시 읽어 내린다 — "이미 그 값이었다" 와 "바뀌었다" 를 구분한다
      const rows = (await qr.query(
        `SELECT NVL(ACTIVE_YN, 'N') AS ACTIVE_YN, COUNT(*) AS CNT
           FROM IB_PRODUCT_PLANDATA
          WHERE LINE_CODE = :lineCode AND MODEL_NAME = :modelName
            AND NVL(PCB_ITEM, '*') LIKE :pcbItem
            AND ORGANIZATION_ID = :organizationId
          GROUP BY NVL(ACTIVE_YN, 'N')`,
        namedBinds({
            lineCode: dto.lineCode,
            modelName: dto.modelName,
            pcbItem: pcb,
            organizationId,
          }),
      )) as { ACTIVE_YN: string; CNT: number }[];
      const at = (yn: string) => Number(rows.find((r) => r.ACTIVE_YN === yn)?.CNT ?? 0);
      return { activeYn: dto.activeYn, active: at('Y'), inactive: at('N') };
    });
  }
}
