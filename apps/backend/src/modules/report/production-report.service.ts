/**
 * @file src/modules/report/production-report.service.ts
 * @description 설비·제품·공정 리포트 5화면
 *              344 w_smt_pickup_rate_rpt                      SMT PICKUP 리포트
 *              346 w_pln_master_plan_rpt                       생산계획리포트
 *              347 w_product_run_card_rpt                      런카드리포트
 *              350 w_product_workstage_stock_rpt               공정재공조회
 *              352 w_product_workstage_magazine_stock_rpt      공정매거진조회
 *
 * 초보자 가이드:
 * 1. **리포트에는 키가 없다.** 추적·조회는 제조번호·PID·Run No 로 한 건을 찾는데
 *    리포트는 GROUP BY 집계다. 그래서 `checkTrackingFilter` 를 쓸 수 없고
 *    **구동 원장의 날짜 인덱스를 타도록 기간을 필수로 받는다** (DTO 에서 강제).
 *    실측 규모: 픽업 97만행 · 런카드 3.9만행.
 * 2. **344 픽업은 '미스 금액' 이 핵심이다.** (미스 + 인식오류) × 구매단가 다.
 *    PB 는 단가 하한 조건을 둬서 비싼 자재의 미스만 골라 봤다 — 그 조건을 유지한다.
 * 3. **346 은 r01~r10 열 열 개가 시간대다.** 생산 대분류(MI/SMD 계획)에서 쓴 것과
 *    같은 고정 슬롯 구조라 그 형태를 그대로 따른다. 크로스탭이 아니다
 *    (DataWindow processing=0, 즉 일반 표다 — 실측).
 * 4. **350 은 대상이 0행이다** (IP_PRODUCT_WORKSTAGE_INV 실측 0건).
 *    화면은 동작하지만 볼 것이 없다 — 은성이 아직 공정재공을 쌓지 않는다.
 * 5. **352 의 불량·폐기 갈래는 기간이 필수다.** 그 둘은 입출고 원장
 *    (IP_PRODUCT_RUN_CARD_IO)을 집계하고 구동 조건이 RECEIPT_DATE 뿐이다.
 *    공정재공 갈래는 스냅샷(IP_PRODUCT_RUN_CARD_INV, 819행)이라 기간이 없다.
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { likePrefix } from '@smt/shared';
import { limited, ROW_LIMIT } from '../../shared/row-limit';
import {
  MagazineStockQueryDto,
  MasterPlanReportQueryDto,
  PickupRateQueryDto,
  RunCardReportQueryDto,
  WorkstageStockQueryDto,
} from './report.dto';
import { namedBinds } from '../../common/utils/named-binds.util';

type Row = Record<string, unknown>;


/** 352 의 불량·폐기 갈래가 보는 공정코드. PB 가 SQL 안에 박아 둔 값을 그대로 옮겼다. */
const MAGAZINE_WORKSTAGES = {
  defect: ['W063', 'W065', 'W080'],
  destroy: ['W088', 'W089'],
} as const;
/** 매거진 라벨 유형. 'B' 불량 · 'D' 폐기 (PB SQL 그대로). */
const MAGAZINE_LABEL_TYPE = { defect: 'B', destroy: 'D' } as const;

/** 라인 시간대 집계 — 시간대 A~E 주간, F~J 야간 (ICOM_WORKTIME_RANGES 의 시간대 코드) */
const PICKUP_SLOTS = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'] as const;
const PICKUP_HEAD_MAX_DAYS = 7;
/** 시간대 수량 — 직전 차이가 음수면 원값, 차이가 없으면(첫 값) 원값 (PB 식 그대로) */
const headQty = (slot: string, type: 'T' | 'M' | 'R', sum: 'HEAD_SUM' | 'HEAD_SUM_AMT', sim: 'SIM_COUNT' | 'SIM_AMT') =>
  `SUM(DECODE(ACTUAL_TIME, '${slot}', DECODE(DATA_TYPE, '${type}', DECODE(SIGN(SIM_COUNT), -1, ${sum}, NVL(${sim}, ${sum})), 0), 0))`;
const PICKUP_HEAD_SQL = `
  SELECT LINE_CODE AS "lineCode", F_GET_LINE_NAME(LINE_CODE, 1) AS "lineName",
         F_GET_REEL_CHANGE_COUNT(LINE_CODE, TO_CHAR(TO_DATE(:day, 'YYYY-MM-DD'), 'YYYY/MM/DD')) AS "reelChange",
         ${PICKUP_SLOTS.map((s) => `${headQty(s, 'T', 'HEAD_SUM', 'SIM_COUNT')} AS "take${s}",
         ${headQty(s, 'M', 'HEAD_SUM', 'SIM_COUNT')} AS "miss${s}",
         ${headQty(s, 'R', 'HEAD_SUM', 'SIM_COUNT')} AS "reco${s}",
         ${headQty(s, 'M', 'HEAD_SUM_AMT', 'SIM_AMT')} + ${headQty(s, 'R', 'HEAD_SUM_AMT', 'SIM_AMT')} AS "amt${s}"`).join(',\n         ')}
    FROM (
      SELECT LINE_CODE, ACTUAL_TIME, ACTUAL_DATE, DATA_TYPE, HEAD_SUM,
             HEAD_SUM * INVENTORY_PRICE AS HEAD_SUM_AMT, SIM_COUNT, SIM_COUNT * INVENTORY_PRICE AS SIM_AMT
        FROM (
          SELECT T.LINE_CODE, T.DATA_TYPE, T.ACTUAL_TIME, T.ACTUAL_DATE,
                 NVL(F_GET_MAT_MAX_UNIT_PRICE_CFM(T.ITEM_CODE, '*', SYSDATE, 1), 0) AS INVENTORY_PRICE,
                 T.HEAD_SUM,
                 DECODE(NVL(T.MACHINE_TYPE, 'CM'), 'NPM', T.HEAD_SUM,
                        T.HEAD_SUM - LAG(T.HEAD_SUM) OVER (
                          PARTITION BY T.LINE_CODE, T.MACHINE_CODE, T.PROGRAM_NAME, T.ADDRESS, T.SUB_ADDRESS, T.ITEM_CODE, T.DATA_TYPE
                          ORDER BY T.LINE_CODE, T.MACHINE_CODE, T.PROGRAM_NAME, T.ADDRESS, T.SUB_ADDRESS, T.ITEM_CODE, T.DATA_TYPE,
                                   T.ACTUAL_DATE, T.ACTUAL_TIME)) AS SIM_COUNT
            FROM IQ_MACHINE_INSPECT_PICKUP_RATE T
           WHERE (T.ACTUAL_DATE = TO_DATE(:day, 'YYYY-MM-DD')
                  OR (T.ACTUAL_DATE = TO_DATE(:day, 'YYYY-MM-DD') - 1 AND T.ACTUAL_TIME = 'J'))
             AND T.LINE_CODE LIKE :lineCode ESCAPE '\\'
             AND T.ITEM_CODE = 'HEAD'))
   WHERE ACTUAL_DATE = TO_DATE(:day, 'YYYY-MM-DD')
   GROUP BY LINE_CODE
   ORDER BY LINE_CODE`;

@Injectable()
export class ProductionReportService {
  constructor(private readonly dataSource: DataSource) {}

  // ───────────────────────────────── 344 SMT PICKUP 리포트

  /** 344 의 세 갈래가 공유하는 조건절. ACTUAL_DATE 가 구동 조건이다. */
  private pickupWhere() {
    return `p.LINE_CODE LIKE :lineCode ESCAPE '\\'
          AND p.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND p.ACTUAL_DATE >= TRUNC(TO_DATE(:dateFrom, 'YYYY-MM-DD'))
          AND p.ACTUAL_DATE <  TRUNC(TO_DATE(:dateTo, 'YYYY-MM-DD')) + 1
          AND NVL(p.PUR_UNIT_PRICE, 0) >= :minUnitPrice`;
  }

  private pickupBinds(query: PickupRateQueryDto) {
    return {
      lineCode: likePrefix(query.lineCode),
      itemCode: likePrefix(query.itemCode),
      dateFrom: query.dateFrom,
      dateTo: query.dateTo,
      minUnitPrice: query.minUnitPrice ?? 0,
    };
  }

  /**
   * 픽업 상세 — 노즐 자리마다 집어 올린 수량·미스·인식오류와 그 금액.
   * 미스 금액 = (미스 + 인식오류) × 구매단가 (PB 식 그대로).
   */
  async findPickupDetail(query: PickupRateQueryDto) {
    const rows = (await this.dataSource.query(
      `SELECT p.LINE_CODE                               AS "lineCode",
              p.MACHINE_CODE                            AS "machineCode",
              p.PROGRAM_NAME                            AS "programName",
              p.TABLE_NO                                AS "tableNo",
              p.ADDRESS                                 AS "address",
              p.SUB_ADDRESS                             AS "subAddress",
              p.FEEDER_ZAXIS                            AS "feederZaxis",
              p.FEEDER_LRAXIS                           AS "feederLraxis",
              p.ITEM_CODE                               AS "itemCode",
              p.ITEM_NAME                               AS "itemName",
              p.ABC_GRADE                               AS "abcGrade",
              p.PUR_UNIT_PRICE                          AS "purUnitPrice",
              TO_CHAR(p.ACTUAL_DATE, 'YYYY-MM-DD')      AS "actualDate",
              p.TAKEUP_QTY                              AS "takeupQty",
              p.MISS_QTY                                AS "missQty",
              p.RECOG_QTY                               AS "recogQty",
              (NVL(p.MISS_QTY, 0) + NVL(p.RECOG_QTY, 0)) * p.PUR_UNIT_PRICE AS "missAmount",
              p.CREATE_BY                               AS "createBy",
              TO_CHAR(p.CREATED_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "createdDate"
         FROM IQ_MACHINE_INSPECT_PICKUP_QRY p
        WHERE ${this.pickupWhere()}
        ORDER BY p.ACTUAL_DATE DESC, p.LINE_CODE, p.MACHINE_CODE, p.ADDRESS
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds(this.pickupBinds(query)),
    )) as Row[];
    return limited(rows);
  }

  /**
   * 픽업 금액 집계 — 라인·일자별 미스 금액 (PB d_pickup_rate_by_line_amt_rpt).
   * 미스·인식오류 수량을 함께 낸다. 집어올림은 내지 않는다 — 이 표의 TAKEUP_QTY 는 설비(헤드) 단위
   * 값이 피더 줄마다 되풀이돼 있어 더하면 부풀려진다 (2026-10-12 01라인: 197,564 ↔ 실제 HEAD 집계).
   * 라인 집어올림·픽업률은 findPickupHead(HEAD 시간대 집계)가 맡는다.
   */
  async findPickupAmount(query: PickupRateQueryDto) {
    const rows = (await this.dataSource.query(
      `SELECT p.LINE_CODE                               AS "lineCode",
              F_GET_LINE_NAME(p.LINE_CODE, 1)           AS "lineName",
              TO_CHAR(p.ACTUAL_DATE, 'YYYY-MM-DD')      AS "actualDate",
              SUM(NVL(p.MISS_QTY, 0))                   AS "missQty",
              SUM(NVL(p.RECOG_QTY, 0))                  AS "recogQty",
              SUM((NVL(p.MISS_QTY, 0) + NVL(p.RECOG_QTY, 0)) * p.PUR_UNIT_PRICE)
                                                        AS "missAmount"
         FROM IQ_MACHINE_INSPECT_PICKUP_QRY p
        WHERE ${this.pickupWhere()}
        GROUP BY p.LINE_CODE, p.ACTUAL_DATE
        ORDER BY p.ACTUAL_DATE DESC, p.LINE_CODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds(this.pickupBinds(query)),
    )) as Row[];
    return limited(rows);
  }

  /**
   * 라인 시간대 집계 — PB w_smt_pickup_rate_head / d_smt_pickup_rate_by_line_head 그대로.
   *
   * 1. 마운터 HEAD 행(ITEM_CODE='HEAD')을 시간대 A~J 로 나눈다. A~E 가 주간, F~J 가 야간이다.
   * 2. HEAD_SUM 은 누적값이라 직전 시간대와의 차이(LAG)를 그 시간대 수량으로 쓴다. 파나소닉 NPM 은
   *    시간대 값이 이미 구간값이라 그대로 쓴다. 차이가 음수(카운터 리셋)면 그 시간대 원값을 쓴다.
   *    A 시간대의 차이를 구하려고 전날 J 시간대를 함께 읽는다.
   * 3. 릴 교체 수는 F_GET_REEL_CHANGE_COUNT (IB_SMT_CHECKHIST 릴 교체 검사 통과 건, 08:30 기준 하루).
   *    미스 수량은 그대로 두고 릴 교체는 따로 보여준다 (PB 와 같다).
   * 4. PB 는 생산일자 하루를 조회한다. 기간을 주면 하루씩 같은 쿼리를 돌려 일자별 줄로 낸다.
   */
  async findPickupHead(query: PickupRateQueryDto) {
    const days: string[] = [];
    const start = new Date(`${query.dateFrom}T00:00:00`);
    const end = new Date(`${query.dateTo}T00:00:00`);
    for (let d = new Date(start); d <= end; d.setDate(d.getDate() + 1)) {
      days.push(`${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`);
    }
    if (days.length > PICKUP_HEAD_MAX_DAYS) {
      throw new BadRequestException(`라인 시간대 집계는 ${PICKUP_HEAD_MAX_DAYS}일까지 조회할 수 있습니다.`);
    }
    const out: Row[] = [];
    for (const day of days) {
      const rows = (await this.dataSource.query(
        PICKUP_HEAD_SQL,
        namedBinds({ day, lineCode: likePrefix(query.lineCode) }),
      )) as Row[];
      out.push(...rows.map((r) => ({ actualDate: day, ...r })));
    }
    return limited(out);
  }

  // ───────────────────────────────── 346 생산계획리포트

  /**
   * MI 생산계획 매트릭스. 시간대 10칸(r01~r10)이 고정 컬럼이다 —
   * 생산 대분류에서 쓴 것과 같은 구조다 (크로스탭이 아니다).
   *
   * PB 는 계획일을 등호로 걸었다 (하루치 계획표다). 그대로 유지한다.
   */
  async findMasterPlan(query: MasterPlanReportQueryDto, organizationId: number) {
    const slots = Array.from({ length: 10 }, (_, i) => {
      const n = i + 1;
      return `SUM(NVL(a.PLAN_TIME${n}, 0)) AS "slot${String(n).padStart(2, '0')}"`;
    }).join(',\n              ');

    const rows = (await this.dataSource.query(
      `SELECT b.MODEL_NAME                              AS "modelName",
              a.LINE_CODE                               AS "lineCode",
              F_GET_LINE_NAME(a.LINE_CODE, :organizationId) AS "lineName",
              a.ITEM_CODE                               AS "itemCode",
              b.ITEM_NAME                               AS "itemName",
              b.ITEM_SPEC                               AS "itemSpec",
              a.MFS                                     AS "mfs",
              a.PCB_ITEM                                AS "pcbItem",
              a.CUSTOMER_CODE                           AS "customerCode",
              c.CUSTOMER_NAME                           AS "customerName",
              TO_CHAR(MIN(a.PLAN_DATE), 'YYYY-MM-DD')   AS "planDate",
              ${slots},
              SUM(NVL(a.PLAN_QTY, 0))                   AS "planQty"
         FROM IP_PRODUCT_MI_PLAN a
         JOIN ID_ITEM b
              ON b.ITEM_CODE = a.ITEM_CODE AND b.ORGANIZATION_ID = a.ORGANIZATION_ID
         LEFT JOIN ICOM_CUSTOMER c ON c.CUSTOMER_CODE = a.CUSTOMER_CODE
        WHERE a.PLAN_DATE = TO_DATE(:planDate, 'YYYY-MM-DD')
          AND NVL(a.MODEL_NAME, '*') LIKE :modelName ESCAPE '\\'
          AND NVL(a.LINE_CODE, '*') LIKE :lineCode ESCAPE '\\'
          AND NVL(a.CUSTOMER_CODE, '*') LIKE :customerCode ESCAPE '\\'
          AND a.ORGANIZATION_ID = :organizationId
        GROUP BY b.MODEL_NAME, a.LINE_CODE, a.ITEM_CODE, a.MFS, a.PCB_ITEM,
                 b.ITEM_NAME, b.ITEM_SPEC, a.CUSTOMER_CODE, c.CUSTOMER_NAME
        ORDER BY a.LINE_CODE, b.MODEL_NAME, a.ITEM_CODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        planDate: query.planDate,
        modelName: likePrefix(query.modelName),
        lineCode: likePrefix(query.lineCode),
        customerCode: likePrefix(query.customerCode),
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }

  // ───────────────────────────────── 347 런카드리포트

  private runCardWhere() {
    return `c.RUN_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND c.RUN_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND NVL(c.MODEL_NAME, '*') LIKE :modelName ESCAPE '\\'
          AND NVL(c.RUN_NO, '*') LIKE :runNo ESCAPE '\\'
          AND NVL(c.MARKING_NO, '*') LIKE :markingNo ESCAPE '\\'
          AND NVL(c.LOT_NO, '*') LIKE :lotNo ESCAPE '\\'
          AND NVL(c.LINE_CODE, '*') LIKE :lineCode ESCAPE '\\'
          AND NVL(c.RUN_STATUS, '*') LIKE :runStatus ESCAPE '\\'
          AND c.ORGANIZATION_ID = :organizationId`;
  }

  private runCardBinds(query: RunCardReportQueryDto, organizationId: number) {
    return {
      dateFrom: query.dateFrom,
      dateTo: query.dateTo,
      modelName: likePrefix(query.modelName),
      runNo: likePrefix(query.runNo),
      markingNo: likePrefix(query.markingNo),
      lotNo: likePrefix(query.lotNo),
      lineCode: likePrefix(query.lineCode),
      runStatus: likePrefix(query.runStatus),
      organizationId,
    };
  }

  /** 런카드 상세 */
  async findRunCardDetail(query: RunCardReportQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT c.RUN_NO                                  AS "runNo",
              TO_CHAR(c.RUN_DATE, 'YYYY-MM-DD')         AS "runDate",
              c.LOT_NO                                  AS "lotNo",
              c.ITEM_CODE                               AS "itemCode",
              i.ITEM_NAME                               AS "itemName",
              c.MODEL_NAME                              AS "modelName",
              c.LINE_CODE                               AS "lineCode",
              F_GET_LINE_NAME(c.LINE_CODE, c.ORGANIZATION_ID) AS "lineName",
              c.MARKING_NO                              AS "markingNo",
              c.LOT_SIZE                                AS "lotSize",
              c.RUN_STATUS                              AS "runStatus",
              rs.CODE_MEAN_KOR                          AS "runStatusName",
              c.PRODUCT_RUN_TYPE                        AS "productRunType",
              rt.CODE_MEAN_KOR                          AS "productRunTypeName",
              TO_CHAR(c.KITTING_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "kittingDate"
         FROM IP_PRODUCT_RUN_CARD c
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = c.ITEM_CODE AND i.ORGANIZATION_ID = c.ORGANIZATION_ID
         LEFT JOIN ISYS_BASECODE rs
                ON rs.CODE_TYPE = 'RUN STATUS' AND rs.CODE_NAME = c.RUN_STATUS
         LEFT JOIN ISYS_BASECODE rt
                ON rt.CODE_TYPE = 'PRODUCT RUN TYPE' AND rt.CODE_NAME = c.PRODUCT_RUN_TYPE
        WHERE ${this.runCardWhere()}
        ORDER BY c.RUN_DATE DESC, c.RUN_NO
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds(this.runCardBinds(query, organizationId)),
    )) as Row[];
    return limited(rows);
  }

  /**
   * 런카드 합계 — 지시일·모델·라인별로 라벨/투입/산출 수량을 모은다.
   *
   * 세 수량은 PB 와 같이 DB 함수가 센다 (F_GET_PCB_LABEL_QTY_BY_RUN_NO ·
   * _INPUT_ · _OUTPUT_, 전부 VALID 실측). TypeScript 로 다시 세면 PB 화면과
   * 숫자가 갈린다 — 이 셋이 생산량 대조의 기준이다.
   *
   * **그래서 함수는 바꾸지 않고 기본을 끔으로 뒀다** (`withQty`). 함수 본문 실측:
   * 라벨은 IP_PRODUCT_2D_BARCODE(1.8억행), 투입은 IQ_MACHINE_INSPECT_DATA_MK 를
   * PID IN 서브쿼리로, 산출은 IQ_MACHINE_INSPECT_DATA_AOI(1.75억행)를 센다.
   * 25일치 523건에서 47초가 걸렸다 — 켤 때만 붙인다.
   */
  async findRunCardSummary(query: RunCardReportQueryDto, organizationId: number) {
    // 수량 3종은 런카드마다 1억행 넘는 표를 한 번씩 센다 (25일치 523건 = 47초 실측).
    // PB 와 숫자가 갈리면 안 되니 함수는 그대로 두고, 켤 때만 붙인다.
    const qtyColumns = query.withQty
      ? `SUM(F_GET_PCB_LABEL_QTY_BY_RUN_NO(c.RUN_NO, c.ORGANIZATION_ID))  AS "labelQty",
              SUM(F_GET_PCB_INPUT_QTY_BY_RUN_NO(c.RUN_NO, c.ORGANIZATION_ID))  AS "inputQty",
              SUM(F_GET_PCB_OUTPUT_QTY_BY_RUN_NO(c.RUN_NO, c.ORGANIZATION_ID)) AS "outputQty"`
      : `NULL AS "labelQty", NULL AS "inputQty", NULL AS "outputQty"`;

    const rows = (await this.dataSource.query(
      `SELECT TO_CHAR(c.RUN_DATE, 'YYYY-MM-DD')         AS "runDate",
              c.ITEM_CODE                               AS "itemCode",
              i.ITEM_NAME                               AS "itemName",
              c.MODEL_NAME                              AS "modelName",
              c.MARKING_NO                              AS "markingNo",
              c.LINE_CODE                               AS "lineCode",
              F_GET_LINE_NAME(c.LINE_CODE, :organizationId) AS "lineName",
              c.PRODUCT_RUN_TYPE                        AS "productRunType",
              rt.CODE_MEAN_KOR                          AS "productRunTypeName",
              COUNT(*)                                  AS "runCardCount",
              SUM(NVL(c.LOT_SIZE, 0))                   AS "lotSize",
              ${qtyColumns}
         FROM IP_PRODUCT_RUN_CARD c
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = c.ITEM_CODE AND i.ORGANIZATION_ID = c.ORGANIZATION_ID
         LEFT JOIN ISYS_BASECODE rt
                ON rt.CODE_TYPE = 'PRODUCT RUN TYPE' AND rt.CODE_NAME = c.PRODUCT_RUN_TYPE
        WHERE ${this.runCardWhere()}
        GROUP BY c.RUN_DATE, c.ITEM_CODE, i.ITEM_NAME, c.MODEL_NAME, c.MARKING_NO,
                 c.LINE_CODE, c.PRODUCT_RUN_TYPE, rt.CODE_MEAN_KOR
        ORDER BY c.RUN_DATE DESC, c.LINE_CODE, c.MODEL_NAME
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds(this.runCardBinds(query, organizationId)),
    )) as Row[];
    return { data: rows, total: rows.length, withQty: Boolean(query.withQty) };
  }

  // ───────────────────────────────── 350 공정재공조회

  /**
   * 공정재공 — 모델·라인·공정별 재공수량.
   *
   * **이 표는 0행이다** (IP_PRODUCT_WORKSTAGE_INV 실측 0건). 화면은 동작하지만
   * 볼 것이 없다 — 은성이 아직 공정재공을 쌓지 않는다.
   *
   * PB 는 집계 서브쿼리와 공정 마스터를 내부조인했다. 공정 마스터에 없는 공정코드가
   * 나오면 그 재공이 통째로 사라지므로 LEFT JOIN 으로 옮겼다.
   */
  async findWorkstageStock(query: WorkstageStockQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT y.MODEL_NAME                              AS "modelName",
              y.MODEL_SUFFIX                            AS "modelSuffix",
              y.LINE_CODE                               AS "lineCode",
              F_GET_LINE_NAME(y.LINE_CODE, :organizationId) AS "lineName",
              y.WORKSTAGE_CODE                          AS "workstageCode",
              z.WORKSTAGE_NAME                          AS "workstageName",
              y.INVENTORY_QTY                          AS "inventoryQty"
         FROM ( SELECT x.MODEL_NAME, x.MODEL_SUFFIX, x.WORKSTAGE_CODE, x.LINE_CODE,
                       SUM(NVL(x.INVENTORY_QTY, 0)) AS INVENTORY_QTY
                  FROM IP_PRODUCT_WORKSTAGE_INV x
                 WHERE NVL(x.MODEL_NAME, '*') LIKE :modelName ESCAPE '\\'
                   AND NVL(x.MODEL_SUFFIX, '*') LIKE :modelSuffix ESCAPE '\\'
                   AND NVL(x.WORKSTAGE_CODE, '*') LIKE :workstageCode ESCAPE '\\'
                   AND SIGN(NVL(x.INVENTORY_QTY, 0)) >= :sign
                   AND x.ORGANIZATION_ID = :organizationId
                 GROUP BY x.MODEL_NAME, x.MODEL_SUFFIX, x.WORKSTAGE_CODE, x.LINE_CODE ) y
         LEFT JOIN IP_PRODUCT_WORKSTAGE z ON z.WORKSTAGE_CODE = y.WORKSTAGE_CODE
        ORDER BY y.LINE_CODE, y.WORKSTAGE_CODE, y.MODEL_NAME
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        modelName: likePrefix(query.modelName),
        modelSuffix: likePrefix(query.modelSuffix),
        workstageCode: likePrefix(query.workstageCode),
        sign: query.sign ?? 0,
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }

  // ───────────────────────────────── 352 공정매거진조회

  /**
   * 공정매거진 — 세 갈래.
   *   workstage  재공 스냅샷 (IP_PRODUCT_RUN_CARD_INV, 819행)
   *   defect     불량 매거진 입출고 (라벨유형 'B', 공정 W063·W065·W080)
   *   destroy    폐기 매거진 입출고 (라벨유형 'D', 공정 W088·W089)
   *
   * 불량·폐기는 입출고 원장을 기간으로 집계한다 — **기간이 구동 조건이라 필수다.**
   * 공정코드 목록과 라벨유형은 PB 가 SQL 안에 박아 둔 값을 그대로 옮겼다.
   */
  async findMagazineStock(query: MagazineStockQueryDto, organizationId: number) {
    const kind = query.kind ?? 'workstage';

    if (kind === 'workstage') {
      const rows = (await this.dataSource.query(
        `SELECT v.MODEL_NAME                            AS "modelName",
                v.MODEL_SUFFIX                          AS "modelSuffix",
                v.ITEM_CODE                             AS "itemCode",
                v.PCB_ITEM                              AS "pcbItem",
                v.WORKSTAGE_CODE                        AS "workstageCode",
                F_GET_WORKSTAGE_NAME_SORT(v.WORKSTAGE_CODE) AS "workstageName",
                SUM(NVL(v.INVENTORY_QTY, 0))            AS "inventoryQty"
           FROM IP_PRODUCT_RUN_CARD_INV v
          WHERE NVL(v.MODEL_NAME, '*') LIKE :modelName ESCAPE '\\'
            AND NVL(v.MODEL_SUFFIX, '*') LIKE :modelSuffix ESCAPE '\\'
            AND NVL(v.WORKSTAGE_CODE, '*') LIKE :workstageCode ESCAPE '\\'
            AND NVL(v.INVENTORY_QTY, 0) <> 0
            AND v.ORGANIZATION_ID = :organizationId
          GROUP BY v.MODEL_NAME, v.MODEL_SUFFIX, v.ITEM_CODE, v.PCB_ITEM, v.WORKSTAGE_CODE
          ORDER BY v.WORKSTAGE_CODE, v.MODEL_NAME, v.ITEM_CODE
          FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
        namedBinds({
          modelName: likePrefix(query.modelName),
          modelSuffix: likePrefix(query.modelSuffix),
          workstageCode: likePrefix(query.workstageCode),
          organizationId,
        }),
      )) as Row[];
      return { data: rows, total: rows.length, kind };
    }

    if (!query.dateFrom || !query.dateTo) {
      throw new BadRequestException(
        `${kind === 'defect' ? '불량' : '폐기'} 매거진은 입출고 원장을 집계하므로`
        + ' 기간이 필요합니다 (구동 조건이 입출고일뿐입니다).',
      );
    }

    const stages = MAGAZINE_WORKSTAGES[kind];
    const stageList = stages.map((s) => `'${s}'`).join(', ');
    const rows = (await this.dataSource.query(
      `SELECT io.MODEL_NAME                             AS "modelName",
              io.MODEL_SUFFIX                           AS "modelSuffix",
              io.ITEM_CODE                              AS "itemCode",
              io.PCB_ITEM                               AS "pcbItem",
              io.WORKSTAGE_CODE                         AS "workstageCode",
              F_GET_WORKSTAGE_NAME_SORT(io.WORKSTAGE_CODE) AS "workstageName",
              DECODE(io.RECEIPT_DEFICIT, 1, 'IN', 2, 'OUT', '*') AS "receiptDeficit",
              SUM(NVL(io.LOT_QTY, 0))                   AS "workstageInvQty",
              -- 같은 모델·품목의 재공 스냅샷 합계. PB 는 공정코드를 SQL 에 박아 뒀다.
              ( SELECT SUM(NVL(v.INVENTORY_QTY, 0))
                  FROM IP_PRODUCT_RUN_CARD_INV v
                 WHERE v.MODEL_NAME = io.MODEL_NAME
                   AND NVL(v.MODEL_SUFFIX, '*') = NVL(io.MODEL_SUFFIX, '*')
                   AND v.ITEM_CODE = io.ITEM_CODE
                   AND NVL(v.PCB_ITEM, '*') = NVL(io.PCB_ITEM, '*')
                   AND v.WORKSTAGE_CODE IN (${stageList})
                   AND v.ORGANIZATION_ID = :organizationId ) AS "modelInvQty"
         FROM IP_PRODUCT_RUN_CARD_IO io
        WHERE io.RECEIPT_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND io.RECEIPT_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND NVL(io.MODEL_NAME, '*') LIKE :modelName ESCAPE '\\'
          AND NVL(io.MODEL_SUFFIX, '*') LIKE :modelSuffix ESCAPE '\\'
          AND NVL(io.WORKSTAGE_CODE, '*') LIKE :workstageCode ESCAPE '\\'
          AND io.MAGAZINE_LABEL_TYPE = :labelType
          AND io.ORGANIZATION_ID = :organizationId
        GROUP BY io.MODEL_NAME, io.MODEL_SUFFIX, io.ITEM_CODE, io.PCB_ITEM,
                 io.WORKSTAGE_CODE, io.RECEIPT_DEFICIT
        ORDER BY io.WORKSTAGE_CODE, io.MODEL_NAME, io.ITEM_CODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        modelName: likePrefix(query.modelName),
        modelSuffix: likePrefix(query.modelSuffix),
        workstageCode: likePrefix(query.workstageCode),
        labelType: MAGAZINE_LABEL_TYPE[kind],
        organizationId,
      }),
    )) as Row[];
    return { data: rows, total: rows.length, kind };
  }
}
