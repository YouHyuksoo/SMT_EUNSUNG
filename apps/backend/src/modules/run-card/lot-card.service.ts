/**
 * @file src/modules/run-card/lot-card.service.ts
 * @description 롯트카드관리 — PB w_product_run_card_duckil 의 버튼 기능 이식
 *
 * 초보자 가이드:
 * 1. **롯트카드는 생산계획 한 줄에서 만든다.** 라인 구분이 D(SMD)면 IP_PRODUCT_SMD_PLAN,
 *    그 외는 IP_PRODUCT_MI_PLAN 에서 고른다. 수량은 계획의 남은 수량(계획 - 이미 만든 롯트카드)이고,
 *    LOT_NO 에 계획의 제조번호(MFS)가 들어간다. 그래서 남은 수량 계산이 LOT_NO 로 묶인다.
 * 2. **상세(IP_PRODUCT_RUN_CARD_DETAIL)는 투입 자재 목록이다.** 생성할 때 BOM 1단계로 넣고,
 *    [상세 생성]으로 설계 BOM 전개 또는 피더 레이아웃에서 다시 만든다.
 *    상세를 넣고 지우면 DB 트리거가 자재 재고 보류 표시(IM_ITEM_INVENTORY.INVENTORY_HOLD)를 바꾼다.
 * 3. **PID(IP_PRODUCT_2D_BARCODE)는 지시수량만큼 한 번에 만든다.** 일련번호와 라벨 문자열은
 *    DB 함수 F_GET_PCB_BARCODE_SERIAL / F_GET_PCB_BARCODE_LABEL 이 정한다 — TypeScript 로 다시 쓰지 않는다.
 *    시작 번호만 고객별로 다르게 구한다 (KI / AT / 그 외).
 * 4. **공정에 투입된 PID 가 있으면 다시 만들지 않는다.** 이미 찍힌 바코드가 사라진다.
 * 5. 출력물(롯트카드·출고계획·PID 라벨)과 마킹기 파일은 여기서 값만 주고 화면이 그린다.
 */
import { BadRequestException, ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { DataSource, EntityManager } from 'typeorm';
import { namedBinds } from '../../common/utils/named-binds.util';
import { LotCardFromPlanDto, LotCardPidDto, LotCardPlanQueryDto } from './lot-card.dto';

type Row = Record<string, unknown>;

/** SEQ_RUN_NO_SEQUENCE 는 순환한다. 이미 있는 번호가 나오면 다시 채번한다 (run-card.service 와 같다). */
const RUN_NO_RETRY = 5;
/** 한 번에 출력할 수 있는 롯트카드 수 — IN 목록 바인드 개수 상한 */
const MAX_PRINT = 200;

/** 계획 조회 SELECT — PB d_pln_smd_plan_popup / d_pln_mi_plan_popup 그대로 */
const PLAN_SELECT = {
  SMD: `
    SELECT 'SMD' AS "planType", p.MFS AS "mfs", TO_CHAR(p.PLAN_DATE, 'YYYY-MM-DD') AS "planDate",
           p.PLAN_SEQUENCE AS "planSequence", p.LINE_CODE AS "lineCode", p.MODEL_NAME AS "modelName",
           p.ITEM_CODE AS "itemCode", i.ITEM_NAME AS "itemName", p.PARENT_ITEM_CODE AS "parentItemCode",
           p.WORK_ORDER_NO AS "workOrderNo", p.PCB_ITEM AS "pcbItem", p.MASTER_MODEL_NAME AS "masterModelName",
           p.MFS_GROUP_NO AS "mfsGroupNo", p.SHIFT_CODE AS "shiftCode", p.PRODUCTION_TYPE AS "productionType",
           p.CUSTOMER_CODE AS "customerCode", NVL(p.PLAN_STATUS, 'W') AS "planStatus",
           p.PLAN_QTY AS "planQty",
           (SELECT SUM(LOT_SIZE) FROM IP_PRODUCT_RUN_CARD WHERE LOT_NO = p.MFS) AS "lotQty",
           p.PLAN_QTY - NVL((SELECT SUM(LOT_SIZE) FROM IP_PRODUCT_RUN_CARD WHERE LOT_NO = p.MFS), 0) AS "remainQty"
      FROM IP_PRODUCT_SMD_PLAN p, ID_ITEM i
     WHERE p.ITEM_CODE = i.ITEM_CODE(+) AND p.ORGANIZATION_ID = i.ORGANIZATION_ID(+)
       AND p.ORGANIZATION_ID = :organizationId`,
  MI: `
    SELECT 'MI' AS "planType", p.MFS AS "mfs", TO_CHAR(p.PLAN_DATE, 'YYYY-MM-DD') AS "planDate",
           p.PLAN_SEQUENCE AS "planSequence", p.LINE_CODE AS "lineCode", p.MODEL_NAME AS "modelName",
           p.ITEM_CODE AS "itemCode", i.ITEM_NAME AS "itemName", p.PARENT_ITEM_CODE AS "parentItemCode",
           p.WORK_ORDER_NO AS "workOrderNo", p.PCB_ITEM AS "pcbItem", p.MODEL_NAME AS "masterModelName",
           p.MFS AS "mfsGroupNo", 'A' AS "shiftCode", 'P' AS "productionType",
           p.CUSTOMER_CODE AS "customerCode", NVL(p.PLAN_STATUS, 'W') AS "planStatus",
           p.PLAN_QTY AS "planQty", p.PLAN_QTY AS "lotQty",
           -- 후공정 지시는 공정마다 따로 내린다 — 남은 수량은 고른 공정의 런카드만 뺀다 (공정 미선택이면 전체)
           p.PLAN_QTY - NVL((SELECT SUM(rc.LOT_SIZE) FROM IP_PRODUCT_RUN_CARD rc
             WHERE rc.LOT_NO = p.MFS AND rc.ORGANIZATION_ID = p.ORGANIZATION_ID
               AND (:workstageCode IS NULL OR rc.WORKSTAGE_CODE = :workstageCode)), 0) AS "remainQty"
      FROM IP_PRODUCT_MI_PLAN p, ID_ITEM i
     WHERE p.ITEM_CODE = i.ITEM_CODE(+) AND p.ORGANIZATION_ID = i.ORGANIZATION_ID(+)
       AND p.ORGANIZATION_ID = :organizationId`,
} as const;

/** SMD 계획 목록만 거른다 — 수량이 남아 있고 취소(X)되지 않은 것 (PB 그대로) */
const SMD_OPEN = `
       AND p.PLAN_QTY > 0 AND NVL(p.PLAN_STATUS, 'W') <> 'X'
       AND p.PLAN_QTY - NVL((SELECT SUM(LOT_SIZE) FROM IP_PRODUCT_RUN_CARD WHERE LOT_NO = p.MFS), 0) > 0`;

export interface LotCardPlanRow {
  planType: 'SMD' | 'MI'; mfs: string; planDate: string; planSequence: number;
  lineCode: string | null; modelName: string | null; itemCode: string | null; itemName: string | null;
  parentItemCode: string | null; workOrderNo: string | null; pcbItem: string | null;
  masterModelName: string | null; mfsGroupNo: string | null; shiftCode: string | null;
  productionType: string | null; customerCode: string | null; planStatus: string;
  planQty: number; lotQty: number | null; remainQty: number;
}

/** PID INSERT — PB cb_3 의 세 분기가 같은 문장을 쓴다. 시작 번호(:serial)만 다르다. */
const PID_INSERT = `
  INSERT INTO IP_PRODUCT_2D_BARCODE (
    RUN_NO, RUN_DATE, ITEM_CODE, SERIAL_NO, LABEL_TEXT, LINE_CODE, WORKSTAGE_CODE, MACHINE_CODE,
    BCR_CODE, ARRAY_TYPE, ORGANIZATION_ID, ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY,
    MAGAZINE_NO, BOX_NO, PALLETE_NO, CARRIER_BARCODE, QC_SCAN_YN, LOT_NO, QC_SCAN_DATE, MODEL_NAME,
    LOT_QTY, BARCODE_STATUS, WORK_ORDER_NO)
  SELECT r.RUN_NO, r.RUN_DATE, r.ITEM_CODE,
         F_GET_PCB_BARCODE_SERIAL(:runNo, :serial + n.NO - 1),
         F_GET_PCB_BARCODE_LABEL(:runNo, :serial + n.NO - 1),
         r.LINE_CODE, 'W010', 'MES', '', '', r.ORGANIZATION_ID, SYSDATE, :userId, SYSDATE, :userId,
         '', '', '', '', 'N', r.LOT_NO, NULL, r.MODEL_NAME, r.LOT_SIZE, 'N', r.MARKING_NO
    FROM IP_PRODUCT_RUN_CARD r,
         (SELECT LEVEL NO FROM DUAL CONNECT BY LEVEL <= :lotSize) n
   WHERE r.RUN_NO = :runNo AND r.ORGANIZATION_ID = :organizationId`;

@Injectable()
export class LotCardService {
  constructor(private readonly dataSource: DataSource) {}

  /** 쉼표로 받은 롯트카드 번호 → IN 목록 바인드 */
  private inList(runNos: string, prefix = 'r') {
    const list = [...new Set(runNos.split(',').map((v) => v.trim()).filter(Boolean))];
    if (list.length === 0) throw new BadRequestException('롯트카드를 선택하세요.');
    if (list.length > MAX_PRINT) throw new BadRequestException(`한 번에 ${MAX_PRINT}장까지 출력할 수 있습니다.`);
    const binds: Row = {};
    const names = list.map((value, i) => {
      binds[`${prefix}${i}`] = value;
      return `:${prefix}${i}`;
    });
    return { sql: names.join(', '), binds, list };
  }

  /** 계획 목록 — 라인 구분으로 SMD/조립 계획을 고른다 (PB cb_inventory) */
  async findPlans(query: LotCardPlanQueryDto, organizationId: number): Promise<LotCardPlanRow[]> {
    const planType = await this.planTypeOf(this.dataSource.manager, query.lineCode, organizationId);
    const rows = await this.dataSource.query(
      `${PLAN_SELECT[planType]}
         AND p.PLAN_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
         AND p.PLAN_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
         AND p.LINE_CODE LIKE :lineCode
         AND p.MODEL_NAME LIKE :modelName
         ${planType === 'SMD' ? SMD_OPEN : ''}
       ORDER BY "planDate", "planSequence"`,
      namedBinds({
        organizationId,
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        lineCode: `${query.lineCode}%`,
        modelName: `${(query.modelName ?? '').trim()}%`,
        ...(planType === 'MI' ? { workstageCode: query.workstageCode?.trim() || null } : {}),
      }),
    ) as LotCardPlanRow[];
    return rows.map((r) => ({
      ...r,
      planSequence: Number(r.planSequence),
      planQty: Number(r.planQty ?? 0),
      lotQty: r.lotQty == null ? null : Number(r.lotQty),
      remainQty: Number(r.remainQty ?? 0),
    }));
  }

  private async planTypeOf(m: EntityManager, lineCode: string, organizationId: number): Promise<'SMD' | 'MI'> {
    const rows = await m.query(
      `SELECT LINE_DIVISION AS "division" FROM IP_PRODUCT_LINE
        WHERE LINE_CODE = :lineCode AND ORGANIZATION_ID = :organizationId`,
      namedBinds({ lineCode, organizationId }),
    ) as Array<{ division: string | null }>;
    if (rows.length === 0) throw new BadRequestException(`라인 ${lineCode} 이 없습니다.`);
    return rows[0].division === 'D' ? 'SMD' : 'MI';
  }

  /**
   * 계획 한 줄로 롯트카드 생성 (PB cb_2 "New Project").
   * 화면이 보낸 수량·모델을 믿지 않고 계획을 다시 읽는다 — 그 사이 다른 사람이 같은 계획으로 만들었을 수 있다.
   */
  async createFromPlan(dto: LotCardFromPlanDto, organizationId: number, userId: string) {
    if (!dto.productRunType?.trim()) throw new BadRequestException('제조유형을 선택하세요.');
    const workstageCode = dto.planType === 'MI' ? dto.workstageCode?.trim() || null : null;
    if (dto.planType === 'MI' && !workstageCode) {
      throw new BadRequestException('공정을 선택하세요. 후공정 지시는 공정마다 따로 내립니다.');
    }
    return this.dataSource.transaction(async (m) => {
      const plans = await m.query(
        `${PLAN_SELECT[dto.planType]}
           AND p.PLAN_DATE = TO_DATE(:planDate, 'YYYY-MM-DD')
           AND p.PLAN_SEQUENCE = :planSequence
           AND p.MFS = :mfs`,
        namedBinds({
          organizationId, planDate: dto.planDate, planSequence: dto.planSequence, mfs: dto.mfs,
          ...(dto.planType === 'MI' ? { workstageCode } : {}),
        }),
      ) as LotCardPlanRow[];
      const plan = plans[0];
      if (!plan) throw new NotFoundException('계획을 찾을 수 없습니다.');

      const lotSize = Number(plan.remainQty ?? 0);
      const missing = [
        ['라인', plan.lineCode], ['모델명', plan.modelName], ['근무조', plan.shiftCode], ['제조그룹번호', plan.mfsGroupNo],
      ].filter(([, value]) => !value || value === '%').map(([label]) => label);
      if (missing.length > 0) throw new BadRequestException(`계획에 ${missing.join('·')} 이 비어 있습니다.`);
      if (!(lotSize > 0)) throw new ConflictException(`계획 ${plan.mfs} 의 남은 수량이 없습니다 (${lotSize}).`);
      // 제조번호가 '*' 면 LOT_NO 가 '*' 인 롯트카드가 생겨 다른 계획과 섞인다 (남은 수량·삭제 트리거가 LOT_NO 로 묶는다).
      if (!plan.mfs || plan.mfs === '*') {
        throw new ConflictException(`계획(순번 ${plan.planSequence})에 제조번호가 없어 롯트카드와 이을 수 없습니다.`);
      }

      // 연배열 수 — 모델마스터에 모델이 없으면 PB 처럼 막는다 (f_get_carrier_size)
      const carriers = await m.query(
        `SELECT COUNT(*) AS "cnt", NVL(MAX(CARRIER_SIZE), 0) AS "carrierSize" FROM IP_PRODUCT_MODEL_MASTER
          WHERE MODEL_NAME = :modelName AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ modelName: plan.modelName, organizationId }),
      ) as Array<{ cnt: number; carrierSize: number }>;
      if (Number(carriers[0]?.cnt ?? 0) === 0) {
        throw new BadRequestException(`모델마스터에 ${plan.modelName} 이 없어 연배열 수를 알 수 없습니다.`);
      }
      const carrierSize = Number(carriers[0].carrierSize ?? 0);

      const runNo = await this.newRunNo(m, plan, organizationId);
      const binds = {
        runNo, organizationId, userId, lotSize, runDate: plan.planDate,
        itemCode: plan.itemCode, parentItemCode: plan.parentItemCode, lineCode: plan.lineCode,
        workOrderNo: plan.workOrderNo,
      };

      // 투입 자재 — 계획 품목의 BOM 1단계 (PB 와 같은 문장)
      await m.query(
        `INSERT INTO IP_PRODUCT_RUN_CARD_DETAIL (
           RUN_NO, MATERIAL_MFS, GROUP_ID, ORGANIZATION_ID, ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE,
           LAST_MODIFY_BY, LOT_SIZE, BIN_CODE, ITEM_CODE, ITEM_PACKING_QTY, BARCODE, LOCATION_QTY,
           ITEM_UNIT_QTY, PARENT_ITEM_CODE)
         SELECT :runNo, '*', :workOrderNo, A.ORGANIZATION_ID, SYSDATE, :userId, SYSDATE, :userId,
                MAX(:lotSize), NULL, A.CHILD_ITEM_CODE, MAX(B.ISSUE_PACKING_QTY), NULL,
                F_GET_LOCATION_QTY(:itemCode, A.CHILD_ITEM_CODE, :lineCode, A.ORGANIZATION_ID),
                MAX(A.ITEM_UNIT_QTY), :parentItemCode
           FROM ID_ENG_BOM A, ID_ITEM B
          WHERE A.CHILD_ITEM_CODE = B.ITEM_CODE(+)
            AND A.ORGANIZATION_ID = B.ORGANIZATION_ID(+)
            AND A.PARENT_ITEM_CODE = :itemCode
            AND A.DATESET <= TO_DATE(:runDate, 'YYYY-MM-DD')
            AND A.DATEEND >= TO_DATE(:runDate, 'YYYY-MM-DD')
            AND A.ORGANIZATION_ID = :organizationId
          GROUP BY A.ORGANIZATION_ID, A.CHILD_ITEM_CODE`,
        namedBinds(binds),
      );

      await m.query(
        `INSERT INTO IP_PRODUCT_RUN_CARD (
           RUN_NO, ORGANIZATION_ID, RUN_DATE, ITEM_CODE, PARENT_ITEM_CODE, MASTER_MODEL_NAME, MFS_GROUP_NO,
           MODEL_NAME, LINE_CODE, SHIFT_CODE, CARRIER_SIZE, PCB_SUPPLIER_CODE, PRODUCT_RUN_TYPE, CHARGER,
           RUN_STATUS, LOT_NO, ARRAY_TYPE, LOT_SIZE, MARKING_NO, PCB_ITEM, REVISION, MODEL_CLASS, PCB_WEEK,
           WORKSTAGE_CODE, ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE)
         VALUES (
           :runNo, :organizationId, TO_DATE(:runDate, 'YYYY-MM-DD'), :itemCode, :parentItemCode,
           :masterModelName, :mfsGroupNo, :modelName, :lineCode, :shiftCode, :carrierSize, NULL,
           :productRunType, :userId, '1', :mfs, F_GET_PCB_ARRAY_TYPE(:modelName, :organizationId),
           :lotSize, '*', :pcbItem, '0', :modelClass, :pcbWeek, :workstageCode, :userId, SYSDATE, :userId, SYSDATE)`,
        namedBinds({
          runNo, organizationId, userId, lotSize, runDate: plan.planDate,
          itemCode: plan.itemCode, parentItemCode: plan.parentItemCode, lineCode: plan.lineCode,
          masterModelName: plan.masterModelName, mfsGroupNo: plan.mfsGroupNo, modelName: plan.modelName,
          shiftCode: plan.shiftCode, carrierSize, productRunType: dto.productRunType, mfs: plan.mfs,
          pcbItem: plan.pcbItem, modelClass: dto.modelClass?.trim() || null, pcbWeek: dto.pcbWeek?.trim() || null,
          workstageCode,
        }),
      );
      return { runNo, lotSize, carrierSize };
    });
  }

  /** 롯트카드 번호 채번 — F_GET_NEW_RUN_NO (저장 직전에만 부른다) */
  private async newRunNo(m: EntityManager, plan: LotCardPlanRow, organizationId: number): Promise<string> {
    for (let attempt = 0; attempt < RUN_NO_RETRY; attempt += 1) {
      const rows = await m.query(
        `SELECT F_GET_NEW_RUN_NO(TO_DATE(:runDate, 'YYYY-MM-DD'), :modelName, :lineCode, :shiftCode, :organizationId) AS "runNo"
           FROM DUAL`,
        namedBinds({
          runDate: plan.planDate, modelName: plan.modelName, lineCode: plan.lineCode,
          shiftCode: plan.shiftCode, organizationId,
        }),
      ) as Array<{ runNo: string | null }>;
      const runNo = rows[0]?.runNo;
      if (!runNo) break;
      const dup = await m.query(
        `SELECT COUNT(*) AS "cnt" FROM IP_PRODUCT_RUN_CARD WHERE RUN_NO = :runNo AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ runNo, organizationId }),
      ) as Array<{ cnt: number }>;
      if (Number(dup[0]?.cnt ?? 0) === 0) return runNo;
    }
    throw new ConflictException('롯트카드 번호 채번에 실패했습니다. 잠시 후 다시 시도하세요.');
  }

  private async runCard(m: EntityManager, runNo: string, organizationId: number) {
    const rows = await m.query(
      `SELECT RUN_NO AS "runNo", MODEL_NAME AS "modelName", TO_CHAR(RUN_DATE, 'YYYY-MM-DD') AS "runDate",
              LOT_SIZE AS "lotSize", ITEM_CODE AS "itemCode", PARENT_ITEM_CODE AS "parentItemCode",
              LINE_CODE AS "lineCode", NVL(CARRIER_SIZE, 0) AS "carrierSize", LOT_NO AS "lotNo"
         FROM IP_PRODUCT_RUN_CARD WHERE RUN_NO = :runNo AND ORGANIZATION_ID = :organizationId`,
      namedBinds({ runNo, organizationId }),
    ) as Array<{
      runNo: string; modelName: string; runDate: string; lotSize: number; itemCode: string;
      parentItemCode: string | null; lineCode: string; carrierSize: number; lotNo: string | null;
    }>;
    if (rows.length === 0) throw new NotFoundException(`롯트카드 ${runNo} 를 찾을 수 없습니다.`);
    return { ...rows[0], lotSize: Number(rows[0].lotSize ?? 0), carrierSize: Number(rows[0].carrierSize ?? 0) };
  }

  /**
   * 상세 다시 만들기 (PB cb_1 "Gen Detail").
   * BOM — 롯트카드 품목에서 설계 BOM 을 끝까지 전개 / FEEDER — 그 라인·모델의 피더 레이아웃.
   */
  async generateDetail(runNo: string, source: 'BOM' | 'FEEDER', organizationId: number, userId: string) {
    return this.dataSource.transaction(async (m) => {
      const card = await this.runCard(m, runNo, organizationId);
      // oracledb 이름 바인드는 문장에 없는 이름이 섞이면 거부한다 — 문장마다 쓰는 것만 넘긴다.
      const common = { runNo, userId, lotSize: card.lotSize, parentItemCode: card.parentItemCode };
      const bomTree = `
        FROM ID_ENG_BOM A, ID_ITEM B
       WHERE A.CHILD_ITEM_CODE = B.ITEM_CODE(+)
         AND A.ORGANIZATION_ID = B.ORGANIZATION_ID(+)
       START WITH A.PARENT_ITEM_CODE = :itemCode
              AND A.DATESET <= TRUNC(SYSDATE) AND NVL(A.DATEEND, TRUNC(SYSDATE)) >= TRUNC(SYSDATE)
              AND A.ORGANIZATION_ID = :organizationId
       CONNECT BY PRIOR A.CHILD_ITEM_CODE = A.PARENT_ITEM_CODE
              AND A.DATESET <= TRUNC(SYSDATE) AND NVL(A.DATEEND, TRUNC(SYSDATE)) >= TRUNC(SYSDATE)
              AND A.ORGANIZATION_ID = :organizationId`;
      const feeder = `
        FROM IB_PRODUCT_PLANDATA A, ID_ITEM B
       WHERE A.ITEM_CODE = B.ITEM_CODE(+)
         AND A.ORGANIZATION_ID = B.ORGANIZATION_ID(+)
         AND A.LINE_CODE = :lineCode
         AND A.MODEL_NAME = :modelName`;

      const count = await m.query(
        `SELECT COUNT(*) AS "cnt" ${source === 'BOM' ? bomTree : feeder}`,
        namedBinds(source === 'BOM'
          ? { itemCode: card.itemCode, organizationId }
          : { lineCode: card.lineCode, modelName: card.modelName }),
      ) as Array<{ cnt: number }>;
      if (Number(count[0]?.cnt ?? 0) === 0) {
        throw new BadRequestException(source === 'BOM'
          ? `${card.itemCode} 의 설계 BOM 이 없습니다.`
          : `${card.lineCode} 라인 ${card.modelName} 의 피더 레이아웃이 없습니다.`);
      }

      // PB 는 ORGANIZATION_ID 없이 지웠다. 롯트카드 번호는 조직마다 다를 수 있어 조건을 넣는다.
      await m.query(
        `DELETE FROM IP_PRODUCT_RUN_CARD_DETAIL WHERE RUN_NO = :runNo AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ runNo, organizationId }),
      );

      const columns = `RUN_NO, MATERIAL_MFS, GROUP_ID, ORGANIZATION_ID, ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE,
        LAST_MODIFY_BY, LOT_SIZE, BIN_CODE, ITEM_CODE, ITEM_PACKING_QTY, BARCODE, LOCATION_QTY, ITEM_UNIT_QTY,
        PARENT_ITEM_CODE`;
      if (source === 'BOM') {
        await m.query(
          `INSERT INTO IP_PRODUCT_RUN_CARD_DETAIL (${columns}, PCB_ITEM)
           SELECT :runNo, '*', 0, A.ORGANIZATION_ID, SYSDATE, :userId, SYSDATE, :userId, MAX(:lotSize), NULL,
                  A.CHILD_ITEM_CODE, MAX(B.ISSUE_PACKING_QTY), NULL, 0, MAX(A.ITEM_UNIT_QTY), :parentItemCode,
                  MAX(PCB_ITEM)
           ${bomTree}
           GROUP BY A.ORGANIZATION_ID, A.CHILD_ITEM_CODE`,
          namedBinds({ ...common, itemCode: card.itemCode, organizationId }),
        );
      } else {
        await m.query(
          `INSERT INTO IP_PRODUCT_RUN_CARD_DETAIL (${columns}, LOCATION_CODE, PCB_ITEM)
           SELECT :runNo, '*', :lotNo, A.ORGANIZATION_ID, SYSDATE, :userId, SYSDATE, :userId, MAX(:lotSize), NULL,
                  A.ITEM_CODE, MAX(B.ISSUE_PACKING_QTY), NULL, 0, MAX(A.ITEM_UNIT_QTY), :parentItemCode,
                  A.LOCATION_CODE, MAX(A.PCB_ITEM)
           ${feeder}
           GROUP BY A.ORGANIZATION_ID, A.ITEM_CODE, A.LOCATION_CODE`,
          namedBinds({ ...common, lotNo: card.lotNo, lineCode: card.lineCode, modelName: card.modelName }),
        );
      }
      const after = await m.query(
        `SELECT COUNT(*) AS "cnt" FROM IP_PRODUCT_RUN_CARD_DETAIL WHERE RUN_NO = :runNo AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ runNo, organizationId }),
      ) as Array<{ cnt: number }>;
      return { runNo, source, count: Number(after[0]?.cnt ?? 0) };
    });
  }

  /** PID 목록 (PB dw_4 d_pcb_label_qr_with_item_code_report) */
  async findPids(runNo: string, organizationId: number) {
    return this.dataSource.query(
      `SELECT SERIAL_NO AS "serialNo", LABEL_TEXT AS "labelText", ITEM_CODE AS "itemCode",
              BARCODE_STATUS AS "barcodeStatus", BOX_NO AS "boxNo"
         FROM IP_PRODUCT_2D_BARCODE
        WHERE RUN_NO = :runNo AND ORGANIZATION_ID = :organizationId
        ORDER BY SERIAL_NO`,
      namedBinds({ runNo, organizationId }),
    ) as Promise<Array<{ serialNo: string; labelText: string | null; itemCode: string | null }>>;
  }

  /**
   * PID 생성 (PB cb_3 "2D Barcode Create" — Create PID 체크 경로).
   * 이미 있으면 regenerate 가 true 일 때만 지우고 다시 만든다.
   */
  async createPids(runNo: string, dto: LotCardPidDto, organizationId: number, userId: string) {
    return this.dataSource.transaction(async (m) => {
      const card = await this.runCard(m, runNo, organizationId);
      if (!(card.lotSize > 0)) throw new BadRequestException('지시수량이 0 이라 PID 를 만들 수 없습니다.');

      const existing = await m.query(
        `SELECT COUNT(*) AS "cnt" FROM IP_PRODUCT_2D_BARCODE
          WHERE RUN_NO = :runNo AND ORGANIZATION_ID = :organizationId AND ROWNUM = 1`,
        namedBinds({ runNo, organizationId }),
      ) as Array<{ cnt: number }>;
      if (Number(existing[0]?.cnt ?? 0) > 0) {
        if (!dto.regenerate) {
          throw new ConflictException({ errorCode: 'PID_EXISTS', message: `${runNo} 의 PID 가 이미 있습니다. 다시 만들려면 재생성을 고르세요.` });
        }
        const used = await m.query(
          `SELECT COUNT(*) AS "cnt" FROM IP_PRODUCT_2D_BARCODE
            WHERE SERIAL_NO IN (SELECT SERIAL_NO FROM IP_PRODUCT_WORKSTAGE_IO
                                 WHERE RUN_NO = :runNo AND ORGANIZATION_ID = :organizationId)`,
          namedBinds({ runNo, organizationId }),
        ) as Array<{ cnt: number }>;
        if (Number(used[0]?.cnt ?? 0) > 0) {
          throw new ConflictException('공정에 투입된 PID 가 있어 다시 만들 수 없습니다.');
        }
        await m.query(
          `DELETE FROM IP_PRODUCT_2D_BARCODE WHERE RUN_NO = :runNo AND ORGANIZATION_ID = :organizationId`,
          namedBinds({ runNo, organizationId }),
        );
      }

      // 후공정 지시는 공정마다 따로 내려가 한 계획(LOT_NO)에 런카드가 여럿이다. PID 는 제품마다 한 벌이라
      // 같은 계획의 다른 런카드에 이미 있으면 만들지 않는다 (PID_INSERT 가 LOT_NO 를 같이 넣는다).
      const sibling = await m.query(
        `SELECT MIN(b.RUN_NO) AS "runNo" FROM IP_PRODUCT_2D_BARCODE b
          WHERE b.LOT_NO = :lotNo AND b.RUN_NO <> :runNo AND b.ORGANIZATION_ID = :organizationId`,
        namedBinds({ lotNo: card.lotNo, runNo, organizationId }),
      ) as Array<{ runNo: string | null }>;
      if (sibling[0]?.runNo) {
        throw new ConflictException(`같은 계획의 다른 공정 지시(${sibling[0].runNo})에 PID 가 이미 있습니다. PID 는 계획당 한 번만 만듭니다.`);
      }

      const models = await m.query(
        `SELECT PRODUCT_CLASS AS "productClass", CUSTOMER_CODE AS "customerCode"
           FROM IP_PRODUCT_MODEL_MASTER WHERE MODEL_NAME = :modelName AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ modelName: card.modelName, organizationId }),
      ) as Array<{ productClass: string | null; customerCode: string | null }>;
      const model = models[0] ?? { productClass: null, customerCode: null };

      const serial = await this.startSerial(m, card, model, dto.startSerial ?? 0);
      await m.query(PID_INSERT, namedBinds({ runNo, serial, lotSize: card.lotSize, userId, organizationId }));

      const result = await m.query(
        `SELECT COUNT(*) AS "count", MIN(SERIAL_NO) AS "firstSerial", MAX(SERIAL_NO) AS "lastSerial"
           FROM IP_PRODUCT_2D_BARCODE WHERE RUN_NO = :runNo AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ runNo, organizationId }),
      ) as Array<{ count: number; firstSerial: string | null; lastSerial: string | null }>;
      return { runNo, startSerial: serial, ...result[0], count: Number(result[0]?.count ?? 0) };
    });
  }

  /** 시작 일련번호 — 고객별로 같은 날 마지막 번호를 다르게 읽는다 (PB cb_3 세 분기) */
  async startSerial(
    m: Pick<EntityManager, 'query'>,
    card: { runNo: string; runDate: string; lineCode: string; carrierSize: number },
    model: { productClass: string | null; customerCode: string | null },
    override: number,
  ): Promise<number> {
    const base = { runNo: card.runNo, runDate: card.runDate };
    if (model.customerCode === 'KI') {
      // KI: 일련번호 7~10자리가 연배열 단위 번호다. 시작 번호 입력은 쓰지 않는다 (PB 그대로).
      if (card.carrierSize < 2) throw new BadRequestException('이 롯트카드의 연배열 수를 확인하세요 (2 이상).');
      const rows = await m.query(
        `SELECT NVL(MAX(TO_NUMBER(SUBSTR(SERIAL_NO, 7, 4))), 0) AS "last" FROM IP_PRODUCT_2D_BARCODE
          WHERE RUN_NO <> :runNo
            AND SERIAL_NO LIKE TO_CHAR(TO_DATE(:runDate, 'YYYY-MM-DD'), 'YY')
                || F_GET_MONTH_CODE2(TO_CHAR(TO_DATE(:runDate, 'YYYY-MM-DD'), 'MM'))
                || TO_CHAR(TO_DATE(:runDate, 'YYYY-MM-DD'), 'DD')
                || F_GET_BASECODE('LINE CODE', :lineCode, 'K', 1) || '%'`,
        namedBinds({ ...base, lineCode: card.lineCode }),
      ) as Array<{ last: number | null }>;
      return Number(rows[0]?.last ?? 0) * card.carrierSize + 1;
    }
    if (model.customerCode === 'AT') {
      const prefix = await m.query(
        `SELECT SUBSTR(F_GET_PCB_BARCODE_LABEL(:runNo, 1), 1, 15) AS "prefix" FROM DUAL`,
        namedBinds({ runNo: card.runNo }),
      ) as Array<{ prefix: string | null }>;
      const rows = await m.query(
        `SELECT NVL(TO_NUMBER(SUBSTR(MAX(SERIAL_NO), 16, 5)), 0) + 1 AS "next" FROM IP_PRODUCT_2D_BARCODE
          WHERE RUN_DATE = TO_DATE(:runDate, 'YYYY-MM-DD') AND RUN_NO <> :runNo AND SERIAL_NO LIKE :prefix || '%'`,
        namedBinds({ ...base, prefix: prefix[0]?.prefix ?? '' }),
      ) as Array<{ next: number }>;
      return override > 0 ? override : Number(rows[0]?.next ?? 1);
    }
    const rows = await m.query(
      `SELECT NVL(TO_NUMBER(SUBSTR(MAX(SERIAL_NO), -4, 3), 'XXX'), 0) + 1 AS "next" FROM IP_PRODUCT_2D_BARCODE
        WHERE RUN_DATE = TO_DATE(:runDate, 'YYYY-MM-DD') AND RUN_NO <> :runNo
          AND SERIAL_NO LIKE :productClass || TO_CHAR(TO_DATE(:runDate, 'YYYY-MM-DD'), 'YYMMDD') || '%'`,
      namedBinds({ ...base, productClass: model.productClass ?? '' }),
    ) as Array<{ next: number }>;
    return override > 0 ? override : Number(rows[0]?.next ?? 1);
  }


  /**
   * 롯트카드 출력 자료 (PB dw_3 d_plan_pcm_run_card_all_rpt_qr).
   * 한 롯트카드에 대표모델이 같은 모델 수만큼 줄이 나온다 — 화면이 롯트카드별로 묶어 한 장씩 그린다.
   */
  async findPrint(runNos: string, organizationId: number) {
    const ins = this.inList(runNos);
    return this.dataSource.query(
      `SELECT R.RUN_NO AS "runNo", TO_CHAR(R.RUN_DATE, 'YYYY-MM-DD') AS "runDate", R.MODEL_NAME AS "modelName",
              B.MODEL_NAME AS "groupModelName", B.ITEM_CODE AS "groupItemCode", B.MODEL_SPEC AS "groupModelSpec",
              R.LINE_CODE AS "lineCode", R.LOT_SIZE AS "lotSize", R.PRODUCT_RUN_TYPE AS "productRunType",
              R.COMMENTS AS "comments",
              (SELECT LISTAGG(JIG_LOT_NO, ', ') WITHIN GROUP (ORDER BY JIG_LOT_NO) FROM IMCN_JIG
                WHERE JIG_LOT_NO IN (SELECT JIG_LOT_NO FROM IMCN_JIG_APPLY_MODEL WHERE ITEM_CODE = R.MODEL_NAME)
                  AND JIG_TYPE = 'M' AND USE_STATUS = 'U' AND JIG_STATUS = 'Z' AND PCB_ITEM = R.PCB_ITEM
                GROUP BY JIG_TYPE) AS "metalMaskCode",
              (SELECT LISTAGG(LOCATION_ADDRESS, ', ') WITHIN GROUP (ORDER BY LOCATION_ADDRESS) FROM IMCN_JIG
                WHERE JIG_LOT_NO IN (SELECT JIG_LOT_NO FROM IMCN_JIG_APPLY_MODEL WHERE ITEM_CODE = R.MODEL_NAME)
                  AND JIG_TYPE = 'M' AND USE_STATUS = 'U' AND JIG_STATUS = 'Z'
                GROUP BY JIG_TYPE) AS "metalMaskAddress",
              (SELECT LISTAGG(SAMPLE_LOT_NO, ', ') WITHIN GROUP (ORDER BY SAMPLE_LOT_NO) FROM IMCN_SAMPLE
                WHERE SAMPLE_LOT_NO IN (SELECT SAMPLE_LOT_NO FROM IMCN_SAMPLE_APPLY_MODEL WHERE ITEM_CODE = R.MODEL_NAME)
                  AND SAMPLE_TYPE = 'S' AND USE_STATUS = 'U' AND SAMPLE_STATUS = 'Z'
                GROUP BY SAMPLE_TYPE) AS "sampleCode",
              (SELECT LISTAGG(LOCATION_ADDRESS, ', ') WITHIN GROUP (ORDER BY LOCATION_ADDRESS) FROM IMCN_SAMPLE
                WHERE SAMPLE_LOT_NO IN (SELECT SAMPLE_LOT_NO FROM IMCN_SAMPLE_APPLY_MODEL WHERE ITEM_CODE = R.MODEL_NAME)
                  AND SAMPLE_TYPE = 'S' AND USE_STATUS = 'U' AND SAMPLE_STATUS = 'Z'
                GROUP BY SAMPLE_TYPE) AS "sampleAddress",
              R.ITEM_CODE AS "itemCode", R.PARENT_ITEM_CODE AS "parentItemCode", R.LOT_NO AS "lotNo",
              R.MARKING_NO AS "markingNo", R.MASTER_MODEL_NAME AS "masterModelName", R.MFS_GROUP_NO AS "mfsGroupNo",
              B.CUSTOMER_CODE AS "customerCode",
              (SELECT MIN(A.SERIAL_NO) || '  -  ' || MAX(A.SERIAL_NO) FROM IP_PRODUCT_2D_BARCODE A
                WHERE A.RUN_NO = R.RUN_NO) AS "serialRange",
              R.PCB_WEEK AS "pcbWeek", F_GET_BASECODE('PCB ITEM', R.PCB_ITEM, 'K', 1) AS "pcbItem",
              B.SOLDER_TYPE AS "solderType", B.SMT_MODEL_NAME AS "smtModelName",
              F_GET_PCB_BARCODE_FIXVAL(R.RUN_NO) AS "serialFixval"
         FROM IP_PRODUCT_RUN_CARD R, IP_PRODUCT_MODEL_MASTER B
        WHERE R.MASTER_MODEL_NAME = B.MASTER_MODEL_NAME(+)
          AND R.ORGANIZATION_ID = B.ORGANIZATION_ID(+)
          AND R.RUN_NO IN (${ins.sql})
          AND R.ORGANIZATION_ID = :organizationId
        ORDER BY R.RUN_NO, B.MODEL_NAME`,
      namedBinds({ ...ins.binds, organizationId }),
    ) as Promise<Row[]>;
  }

  /** 출고계획 (PB dw_5 d_ip_product_run_issue_plan_summary) — 고른 롯트카드들의 투입 자재 합계 */
  async findIssuePlan(runNos: string, organizationId: number) {
    const ins = this.inList(runNos);
    const rows = await this.dataSource.query(
      `SELECT D.ITEM_CODE AS "itemCode", I.ITEM_NAME AS "itemName", I.PART_NO AS "partNo",
              I.ITEM_SPEC AS "itemSpec", I.LOCATION_ADDRESS AS "locationAddress", MAX(D.PCB_ITEM) AS "pcbItem",
              TO_CHAR(R.RUN_DATE, 'YYYY-MM-DD') AS "runDate",
              SUM(D.LOT_SIZE * D.ITEM_UNIT_QTY) AS "inputQty",
              MAX(NVL(I.MATERIAL_QTY, 0)) AS "materialQty"
         FROM IP_PRODUCT_RUN_CARD_DETAIL D, ID_ITEM I, IP_PRODUCT_RUN_CARD R
        WHERE D.ITEM_CODE = I.ITEM_CODE(+) AND D.ORGANIZATION_ID = I.ORGANIZATION_ID(+)
          AND D.RUN_NO = R.RUN_NO AND D.ORGANIZATION_ID = R.ORGANIZATION_ID
          AND D.RUN_NO IN (${ins.sql}) AND D.ORGANIZATION_ID = :organizationId
        GROUP BY D.ORGANIZATION_ID, D.ITEM_CODE, I.PART_NO, I.ITEM_NAME, I.ITEM_SPEC, I.ITEM_CLASS,
                 R.RUN_DATE, I.LOCATION_ADDRESS
        ORDER BY R.RUN_DATE, D.ITEM_CODE`,
      namedBinds({ ...ins.binds, organizationId }),
    ) as Array<Row & { inputQty: number; materialQty: number }>;
    // 릴 수량 = 투입수량 / 릴당 수량 올림 (PB compute_2)
    return rows.map((r) => {
      const inputQty = Number(r.inputQty ?? 0);
      const materialQty = Number(r.materialQty ?? 0);
      return { ...r, inputQty, materialQty, reelQty: materialQty > 0 ? Math.ceil(inputQty / materialQty) : null };
    });
  }

  /**
   * 마킹기 파일 한 줄 (PB w_com_label_file_write_popup → <RUN_NO>.JOB, 머리글 없는 CSV).
   * 컬럼 순서가 파일 형식이다 — 바꾸지 않는다.
   */
  async findMarkingFile(runNo: string, organizationId: number) {
    const rows = await this.dataSource.query(
      `SELECT R.RUN_NO AS "runNo",
              TO_CHAR(R.RUN_DATE, 'YY') || F_GET_MONTH_CODE2(TO_CHAR(R.RUN_DATE, 'MM')) || TO_CHAR(R.RUN_DATE, 'DD') AS "planYymdd",
              F_GET_BASECODE('LINE CODE', R.LINE_CODE, 'K', 1) AS "lineCode",
              (SELECT SUBSTR(MIN(SERIAL_NO), 7, 4) FROM IP_PRODUCT_2D_BARCODE WHERE RUN_NO = R.RUN_NO) AS "startSerial",
              R.LOT_SIZE AS "lotSize", R.CARRIER_SIZE AS "carrierSize",
              F_GET_MODEL_INFO_4_BCR(:runNo, 'HW_VERSION') AS "hwVersion",
              F_GET_MODEL_INFO_4_BCR(:runNo, 'SW_VERSION') AS "swVersion",
              F_GET_MODEL_INFO_4_BCR(:runNo, 'INDEX') AS "indexNo"
         FROM IP_PRODUCT_RUN_CARD R
        WHERE R.RUN_NO = :runNo AND R.ORGANIZATION_ID = :organizationId`,
      namedBinds({ runNo, organizationId }),
    ) as Row[];
    if (rows.length === 0) throw new NotFoundException(`롯트카드 ${runNo} 를 찾을 수 없습니다.`);
    const r = rows[0];
    const order = ['runNo', 'planYymdd', 'lineCode', 'startSerial', 'lotSize', 'carrierSize', 'hwVersion', 'swVersion', 'indexNo'];
    const csv = order
      .map((key) => (r[key] == null ? '' : String(r[key])))
      .map((value) => (/[",\r\n]/.test(value) ? `"${value.replace(/"/g, '""')}"` : value))
      .join(',');
    return { fileName: `${runNo}.JOB`, content: `${csv}\r\n`, row: r };
  }
}
