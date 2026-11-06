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
import { outStringBind } from '../../common/services/oracle.service';
import { DataSource } from 'typeorm';
import { TransactionService } from '../../shared/transaction.service';
import {
  SmtPlanDeleteDto,
  SmtPlanDeployDto,
  SmtPlanQueryDto,
  SmtPlanSetActiveDto,
  SmtPlanSummaryQueryDto,
  SmtPlanScopeDto,
  SmtPlanRunCardQueryDto,
  SmtPlanLineOnOffDto,
} from './smt-plan.dto';
import { namedBinds } from '../../common/utils/named-binds.util';
import { affectedRows } from '../../common/utils/affected-rows.util';

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

  /**
   * 배포 요약(Summary) — PB d_smt_plandata_lst 와 같이 라인·모델·PCB면(·SMT모델)별로 묶는다.
   * 이 행을 고르면 아래 피더 배치(find)를 라인·모델·면·피더축으로 읽는다.
   * PB 는 조직 조건이 없었다 — 여기서는 조직으로 거른다.
   */
  async findSummary(query: SmtPlanSummaryQueryDto, organizationId: number) {
    const lineCode = (query.lineCode ?? '').trim();
    const modelName = (query.modelName ?? '').trim();
    if (!lineCode && !modelName) throw new BadRequestException('라인이나 모델 중 하나는 골라야 합니다.');
    return (await this.dataSource.query(
      `SELECT MAX(d.ACTIVE_YN) AS "activeYn",
              MAX(d.PLAN_DATE) AS "planDate",
              d.MODEL_NAME AS "modelName",
              d.LINE_CODE AS "lineCode",
              MAX(m.MODEL_SPEC) AS "modelSpec",
              MAX(d.MODEL_SUFFIX) AS "modelSuffix",
              d.PCB_ITEM AS "pcbItem",
              MAX(d.FEEDER_SHAFT) AS "feederShaft",
              m.SMT_MODEL_NAME AS "masterSmtModelName",
              d.SMT_MODEL_NAME AS "smtModelName",
              MAX(d.REVISION) AS "revision",
              -- 모델마스터에 같은 SMT 모델이 여러 행이면 조인으로 늘어나므로 계획 행을 따로 센다
              COUNT(DISTINCT d.ROWID) AS "planRows"
         FROM IB_PRODUCT_PLANDATA d
         LEFT JOIN IP_PRODUCT_MODEL_MASTER m
                ON m.SMT_MODEL_NAME = d.SMT_MODEL_NAME AND m.ORGANIZATION_ID = d.ORGANIZATION_ID
        WHERE d.ORGANIZATION_ID = :organizationId
          AND (:lineCode IS NULL OR d.LINE_CODE = :lineCode)
          AND (:modelName IS NULL OR d.MODEL_NAME = :modelName)
          AND NVL(d.REVISION, '0000') LIKE :revision
        GROUP BY d.MODEL_NAME, d.LINE_CODE, d.PCB_ITEM, m.SMT_MODEL_NAME, d.SMT_MODEL_NAME
        ORDER BY MAX(d.ACTIVE_YN) DESC, d.LINE_CODE, d.MODEL_NAME, d.PCB_ITEM, MAX(d.FEEDER_SHAFT)`,
      namedBinds({ organizationId, lineCode: lineCode || null, modelName: modelName || null, revision: this.like(query.revision) }),
    )) as Record<string, unknown>[];
  }

  /**
   * 피더 레이아웃 출력 데이터 — PB d_smt_plandata_list_rpt 와 같은 SQL (읽기 전용).
   * 소요량은 캐리어 수(F_GET_CARRIER_SIZE)를 곱하고, 단가는 F_GET_MAT_MAX_UNIT_PRICE_CFM 이다.
   * 출력은 라인·모델·테이블마다 새 쪽, 그 안에서 대체여부(DIV)로 묶는다.
   */
  async findLayoutPrint(query: SmtPlanScopeDto, organizationId: number) {
    return (await this.dataSource.query(
      `SELECT p.REPLACE_YN AS "div", p.MODEL_NAME AS "modelName", p.ITEM_CODE AS "itemCode",
              p.ITEM_UNIT_QTY * F_GET_CARRIER_SIZE(p.MODEL_NAME, p.ORGANIZATION_ID) AS "itemUnitQty",
              a.ITEM_NAME AS "itemName", a.ITEM_SPEC AS "itemSpec", a.ITEM_UOM AS "itemUom",
              b.ITEM_NAME AS "parentItemName", b.ITEM_SPEC AS "parentItemSpec",
              a.LOCATION_ADDRESS AS "locationAddress",
              p.LOCATION_CODE AS "locationCode", p.LINE_CODE AS "lineCode", p.MACHINE AS "machine",
              lm.LINE_NAME AS "lineName", lm.MACHINE_NAME AS "machineName", p.TABLE_ID AS "tableId",
              a.FEEDER_SIZE AS "feederType", p.PCB_ITEM AS "pcbItem",
              F_GET_MAT_MAX_UNIT_PRICE_CFM(p.ITEM_CODE, 'F', TRUNC(SYSDATE), 1) AS "unitPrice",
              F_GET_PCB_ITEM_BY_NAME(p.MODEL_NAME) AS "pcbItemCode",
              p.REVISION AS "revision", a.MSL_LEVEL AS "mslLevel"
         FROM IB_PRODUCT_PLANDATA p
         LEFT JOIN ID_ITEM a ON a.ITEM_CODE = p.ITEM_CODE AND a.ORGANIZATION_ID = p.ORGANIZATION_ID
         LEFT JOIN ID_ITEM b ON b.ITEM_CODE = p.MODEL_NAME AND b.ORGANIZATION_ID = p.ORGANIZATION_ID
         LEFT JOIN IB_LINE_MASTER lm
                ON lm.LINE_CODE = p.LINE_CODE AND lm.MACHINE = p.MACHINE AND lm.ORGANIZATION_ID = p.ORGANIZATION_ID
        WHERE p.MODEL_NAME = :modelName
          AND p.LINE_CODE LIKE :lineCode
          AND NVL(p.PCB_ITEM, '*') LIKE :pcbItem
          AND p.ORGANIZATION_ID = :organizationId
          AND NVL(p.REVISION, '0000') LIKE :revision
        ORDER BY p.LINE_CODE, p.MODEL_NAME, p.TABLE_ID, p.REPLACE_YN, p.LOCATION_CODE`,
      namedBinds({
        modelName: query.modelName.trim(),
        lineCode: this.like(query.lineCode),
        pcbItem: this.like(query.pcbItem),
        organizationId,
        revision: this.like(query.revision),
      }),
    )) as Record<string, unknown>[];
  }

  /**
   * Restore — PB w_smt_plan_master 의 Restore 버튼 (**쓰기**).
   * 1. 활성인데 CCS 가 안 끝난(N) 행을 체크 완료(합격 P · CCS Y)로 바꾼다.
   * 2. 피더별 자재 바코드·칩명·공급사 바코드·LOT·투입시각을 체크이력(IB_SMT_CHECKHIST, 합격·CHECK_TYPE 1)에서 다시 채운다.
   * PB 는 2번에서 체크이력이 없는 피더도 바코드를 NULL 로 덮었다 — 여기서는 이력이 있는 피더만 채운다.
   */
  async restore(dto: SmtPlanScopeDto, organizationId: number, userId: string) {
    const binds = { modelName: dto.modelName.trim(), lineCode: dto.lineCode.trim(), pcbItem: dto.pcbItem, organizationId };
    return this.tx.run(async (qr) => {
      const checked = await qr.query(
        `UPDATE IB_PRODUCT_PLANDATA
            SET CHECK_STATUS = 'P', CHECK_YN = 'Y', CHECK_MSG = 'OK', CHANGE_DATE = SYSDATE,
                CCS_YN = 'Y', ACTIVE_YN = 'Y', FEEDING_COUNT = 1,
                LAST_MODIFY_BY = :userId, LAST_MODIFY_DATE = SYSDATE
          WHERE MODEL_NAME = :modelName AND LINE_CODE = :lineCode AND PCB_ITEM = :pcbItem
            AND ORGANIZATION_ID = :organizationId
            AND ACTIVE_YN = 'Y' AND CCS_YN = 'N'`,
        namedBinds({ ...binds, userId }),
      );
      const restored = await qr.query(
        `UPDATE IB_PRODUCT_PLANDATA a
            SET (a.SELECTED_DATE, a.ITEM_BARCODE, a.CHIPNAME, a.SUPPLIER_BARCODE, a.LOT_NO, a.FEEDING_END_DATE) = (
                  SELECT DISTINCT MIN(b.CHECK_DATE), b.SCAN_PARTNAME, b.CHIPNAME, b.SCAN_SUPPLIER_PARTNAME, b.LOT_NO, MAX(b.CCS_END_DATE)
                    FROM IB_SMT_CHECKHIST b
                   WHERE a.MODEL_NAME = b.LOT_NAME AND a.LINE_CODE = b.LINE_CODE
                     AND a.LOCATION_CODE = b.LOCATION_CODE AND a.PCB_ITEM = b.PCB_ITEM
                     AND b.LOT_NAME = :modelName AND b.LINE_CODE = :lineCode
                     AND b.CHECK_STATUS = 'P' AND b.CHECK_TYPE = 1 AND b.PCB_ITEM = :pcbItem
                   GROUP BY b.SCAN_PARTNAME, b.CHIPNAME, b.SCAN_SUPPLIER_PARTNAME, b.LOT_NO)
          WHERE a.MODEL_NAME = :modelName AND a.LINE_CODE = :lineCode AND a.PCB_ITEM = :pcbItem
            AND a.ORGANIZATION_ID = :organizationId AND a.ACTIVE_YN = 'Y'
            AND EXISTS (
                  SELECT 1 FROM IB_SMT_CHECKHIST b
                   WHERE b.LOT_NAME = a.MODEL_NAME AND b.LINE_CODE = a.LINE_CODE
                     AND b.LOCATION_CODE = a.LOCATION_CODE AND b.PCB_ITEM = a.PCB_ITEM
                     AND b.CHECK_STATUS = 'P' AND b.CHECK_TYPE = 1)`,
        namedBinds(binds),
      );
      return { checkedRows: Number(affectedRows(checked) ?? 0), restoredRows: Number(affectedRows(restored) ?? 0) };
    });
  }

  /** 라인 ON/OFF 할 런카드 후보 — 그 라인·모델(·면)의 최근 60일 런카드 */
  async findRunCards(query: SmtPlanRunCardQueryDto, organizationId: number) {
    return (await this.dataSource.query(
      `SELECT * FROM (
         SELECT RUN_NO AS "runNo", RUN_DATE AS "runDate", MODEL_NAME AS "modelName", LINE_CODE AS "lineCode",
                PCB_ITEM AS "pcbItem", RUN_STATUS AS "runStatus", LOT_SIZE AS "lotSize"
           FROM IP_PRODUCT_RUN_CARD
          WHERE ORGANIZATION_ID = :organizationId AND MODEL_NAME = :modelName
            AND LINE_CODE LIKE :lineCode AND NVL(PCB_ITEM, '*') LIKE :pcbItem
            AND RUN_DATE >= TRUNC(SYSDATE) - 60
          ORDER BY RUN_DATE DESC, RUN_NO DESC)
        WHERE ROWNUM <= 30`,
      namedBinds({ organizationId, modelName: query.modelName.trim(), lineCode: this.like(query.lineCode), pcbItem: this.like(query.pcbItem) }),
    )) as Record<string, unknown>[];
  }

  /**
   * 라인 ON(장착)/OFF(회수) — 현장 PDA 와 같은 P_CHECK_PDA_TB_INOUT_PS_USER 를 런카드 번호로 부른다 (**쓰기**).
   * PB 계획배포 화면의 Line On/Off 는 다른 스키마(INFINITY21_JSLCD)의 P_CHECK_PDA_TB_INOUT_PS 를 불러 은성에서는 동작하지 않았다.
   * 프로시저가 성공하면 스스로 COMMIT 하고 p_err='OK' 를 돌려준다. 실패 메시지일 때 COMMIT 없이 끝나는 경로가 있어
   * 트랜잭션 안에서 부르고 'OK' 가 아니면 예외를 던져 되돌린다 (TransactionService 가 롤백한다).
   */
  async lineOnOff(dto: SmtPlanLineOnOffDto, userId: string) {
    return this.tx.run(async (qr) => {
      const out = (await qr.query(
        `BEGIN P_CHECK_PDA_TB_INOUT_PS_USER(:lineCode, :runNo, :pcbItem, :inout, :ps, :err, :userId); END;`,
        namedBinds({
          lineCode: dto.lineCode.trim(),
          runNo: dto.runNo.trim(),
          pcbItem: dto.pcbItem,
          inout: dto.onOff === 'ON' ? '1' : '2',
          ps: dto.ps,
          err: outStringBind(4000),
          userId,
        }),
      )) as { err?: string | null };
      const message = String(out?.err ?? '').trim();
      if (message !== 'OK') throw new BadRequestException(message || '라인 ON/OFF 처리 결과를 알 수 없습니다.');
      return { onOff: dto.onOff, runNo: dto.runNo, message };
    });
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
