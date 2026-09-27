/**
 * @file src/modules/tracking/pid-tracking.service.ts
 * @description 생산이력 추적 3화면
 *              317 w_product_pid_tracking_fpcb_rpt      생산이력조회(PID)
 *              318 w_pln_product_barcode_tracking       생산이력조회(Run No)
 *              319 w_pln_product_all_barcode_tracking   롯트추적조회(ALL)
 *
 * 초보자 가이드:
 * 1. **318·319 는 롯트카드 목록을 공유한다.** 위 표에서 롯트카드를 고르면 아래에
 *    상세가 나오는 같은 구조다. 상세 내용만 다르다 —
 *    318 은 공정별 데이터 보유 건수 매트릭스, 319 는 PID 한 줄씩의 전 공정 시각.
 * 2. **공정 매트릭스의 숫자는 '값' 이 아니라 '건수' 다.** PB DataWindow 의 컬럼
 *    별칭이 RUN_NO·BARCODE·MK 라서 값처럼 보이지만, F_GET_PID_* 함수는 전부
 *    `SELECT COUNT(*)` 를 돌려준다 (소스 실측). 0 이면 그 공정 데이터가 없다는
 *    뜻이다. 컬럼 제목에 '건' 을 붙여 화면에서 오해가 없게 했다.
 * 3. **317 은 PB 에서 동작하지 않는 화면이었다.** DataWindow
 *    `d_ip_product_pid_tracking_fpcb_rpt_k` 는 SQL 이 없는 빈 껍데기다
 *    (컬럼 `a char(10)` 하나, retrieve 문 없음. 형제 `_fpcb_rpt` · `_duckil` 도
 *    같다). 그래서 이 화면은 **이식이 아니라 재구성**이다 — PB 스크립트가 남긴
 *    계약(PID 를 넣으면 Run No·모델명을 채우고 추적을 보여준다)을 318 의
 *    매트릭스와 319 의 자재 목록으로 되살렸다.
 * 4. **필수조건이 곧 성능이다.** IP_PRODUCT_2D_BARCODE 는 1.8억행이고
 *    (SERIAL_NO) · (RUN_NO, SERIAL_NO) 인덱스가 있다. 이 서비스의 모든 조회가
 *    Run No 또는 PID 등호 조건을 반드시 받는다 — DTO 가 필수로 잡는다.
 */
import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { checkTrackingFilter, likePrefix } from '@smt/shared';
import { RunCardListQueryDto, RunNoQueryDto, SerialNoQueryDto } from './tracking.dto';

type Row = Record<string, unknown>;

/**
 * 공정별 데이터 보유 건수. PB `d_pln_product_2d_barcode_tracking` 의 컬럼 순서 그대로.
 * key = 응답 필드, fn = DB 함수, label = 화면 제목.
 *
 * 함수를 TypeScript 로 다시 쓰지 않는다 — PB 화면과 웹 화면이 같은 숫자를 봐야 한다.
 */
export const PID_STAGE_COUNTS: readonly { key: string; fn: string; label: string }[] = [
  { key: 'runCard', fn: 'F_GET_PID_RUNNO', label: '롯트카드' },
  { key: 'barcode', fn: 'F_GET_PID_BARCODE', label: '2D바코드' },
  { key: 'marking', fn: 'F_GET_PID_MK', label: '마킹' },
  { key: 'solderPrint', fn: 'F_GET_PID_SP', label: '인쇄' },
  { key: 'spi', fn: 'F_GET_PID_SPI', label: 'SPI' },
  { key: 'smdAoi', fn: 'F_GET_PID_SMD_AOI', label: 'SMD AOI' },
  { key: 'ict', fn: 'F_GET_PID_ICT', label: 'ICT' },
  { key: 'imdAoi', fn: 'F_GET_PID_IMD_AOI', label: 'IMD AOI' },
  { key: 'imdAoi1', fn: 'F_GET_PID_IMD_AOI1', label: 'IMD AOI1' },
  { key: 'imdAoi2', fn: 'F_GET_PID_IMD_AOI2', label: 'IMD AOI2' },
  { key: 'routing', fn: 'F_GET_PID_RT', label: '라우터' },
  { key: 'rework', fn: 'F_GET_PID_RW', label: '재작업' },
  { key: 'workQc', fn: 'F_GET_PID_WORKQC', label: '공정검사' },
  { key: 'solder', fn: 'F_GET_PID_SOLDER', label: '솔더' },
  { key: 'jig', fn: 'F_GET_PID_JIG', label: '지그' },
  { key: 'sample', fn: 'F_GET_PID_SAMPLE', label: '샘플' },
  { key: 'reelMaterial', fn: 'F_GET_PID_REEL_MAT', label: '릴자재' },
  { key: 'pcbMaterial', fn: 'F_GET_PID_PCB_MAT', label: 'PCB자재' },
];

/**
 * 한 롯트카드의 PID 수 상한.
 *
 * 매트릭스 한 줄마다 DB 함수 18개가 각각 COUNT 쿼리를 돈다. PID 500장이면
 * 9,000번이다. PB 는 상한이 없어 큰 롯트에서 화면이 멈췄다 — 여기서 끊고
 * 잘렸다는 사실을 응답에 담는다.
 */
const PID_MATRIX_LIMIT = 500;
const ROW_LIMIT = 5000;

/**
 * 키가 실제로 채워졌는지 확인한다. DTO 는 `'%'` 나 공백 한 칸을 통과시키는데,
 * PB 관례가 빈 입력을 `'%'` 로 바꿔 보내던 시스템이라 그 값이 그대로 넘어올 수 있다.
 * 1.8억행 표를 조건 없이 훑는 일을 막는다. 판정은 `@smt/shared` 한 곳에 있다.
 */
function requireKey(input: Parameters<typeof checkTrackingFilter>[0]) {
  const verdict = checkTrackingFilter(input);
  if (!verdict.ok) throw new BadRequestException(verdict.reason);
}

@Injectable()
export class PidTrackingService {
  constructor(private readonly dataSource: DataSource) {}

  // ───────────────────────────────── 318·319 공용 롯트카드 목록

  /** 318·319 위쪽 표. PB 는 빈 입력에 `값 + '%'` 를 붙여 전체를 봤다 — 그 관례를 유지한다. */
  async findRunCards(query: RunCardListQueryDto, organizationId: number) {
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
              c.PCB_ITEM                                AS "pcbItem",
              c.ENTER_BY                                AS "enterBy",
              TO_CHAR(c.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')       AS "enterDate",
              c.LAST_MODIFY_BY                          AS "lastModifyBy",
              TO_CHAR(c.LAST_MODIFY_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "lastModifyDate"
         FROM IP_PRODUCT_RUN_CARD c
         LEFT JOIN ID_ITEM i ON i.ITEM_CODE = c.ITEM_CODE
        WHERE NVL(c.MODEL_NAME, '*') LIKE :modelName ESCAPE '\\'
          AND NVL(c.RUN_NO, '*') LIKE :runNo ESCAPE '\\'
          AND NVL(c.LINE_CODE, '*') LIKE :lineCode ESCAPE '\\'
          AND c.RUN_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND c.RUN_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND c.ORGANIZATION_ID = :organizationId
        ORDER BY c.RUN_DATE DESC, c.RUN_NO
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        // PB 관례: 빈 조건은 '%'. NULL LIKE '%' 는 NULL 이라 컬럼을 NVL 로 감쌌다.
        // likePrefix 가 입력의 '%'·'_' 를 escape 한다 (SQL 에 ESCAPE 절이 함께 있다).
        modelName: likePrefix(query.modelName),
        runNo: likePrefix(query.runNo),
        lineCode: likePrefix(query.lineCode),
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return { data: rows, total: rows.length };
  }

  // ───────────────────────────────── 317·318 공정별 데이터 건수 매트릭스

  /**
   * PID 별 공정 데이터 보유 건수. Run No 로 한 롯트 전체, 또는 PID 하나만 본다.
   *
   * 318 은 runNo 로, 317 은 serialNo 로 부른다. 같은 표라 하나로 둔다 —
   * 둘로 나누면 함수 목록이 갈려 한쪽만 고쳐진다.
   */
  async findStageCounts(params: { runNo?: string; serialNo?: string }, organizationId: number) {
    requireKey({ runNo: params.runNo, serialNo: params.serialNo });
    const columns = PID_STAGE_COUNTS
      .map((s) => `${s.fn}(b.SERIAL_NO, b.ORGANIZATION_ID) AS "${s.key}"`)
      .join(',\n              ');
    const where = params.serialNo ? 'b.SERIAL_NO = :serialNo' : 'b.RUN_NO = :runNo';
    const binds: Record<string, unknown> = { organizationId };
    if (params.serialNo) binds.serialNo = params.serialNo;
    else binds.runNo = params.runNo;

    const rows = (await this.dataSource.query(
      `SELECT b.SERIAL_NO                               AS "serialNo",
              b.RUN_NO                                  AS "runNo",
              b.MODEL_NAME                              AS "modelName",
              b.LINE_CODE                               AS "lineCode",
              TO_CHAR(b.RUN_DATE, 'YYYY-MM-DD')         AS "runDate",
              ${columns}
         FROM IP_PRODUCT_2D_BARCODE b
        WHERE ${where}
          AND b.ORGANIZATION_ID = :organizationId
        ORDER BY b.SERIAL_NO
        FETCH FIRST ${PID_MATRIX_LIMIT + 1} ROWS ONLY`,
      binds as unknown as unknown[],
    )) as Row[];

    const truncated = rows.length > PID_MATRIX_LIMIT;
    return {
      data: truncated ? rows.slice(0, PID_MATRIX_LIMIT) : rows,
      total: truncated ? PID_MATRIX_LIMIT : rows.length,
      truncated,
      limit: PID_MATRIX_LIMIT,
    };
  }

  // ───────────────────────────────── 317 PID 머리글

  /**
   * PID 하나의 Run No·모델명. PB 는 화면 밖 PB 함수
   * (`f_get_run_no_by_serial` / `f_get_model_name_by_run_no`) 로 채웠다.
   * 앞의 것은 이 DB 에 없어(PB 전용 함수) 2D바코드를 직접 읽는다.
   */
  async findPidHeader(query: SerialNoQueryDto, organizationId: number) {
    requireKey({ serialNo: query.serialNo });
    const rows = (await this.dataSource.query(
      `SELECT b.SERIAL_NO                               AS "serialNo",
              b.RUN_NO                                  AS "runNo",
              b.MODEL_NAME                              AS "modelName",
              b.CUSTOMER_MODEL_NAME                     AS "customerModelName",
              b.ITEM_CODE                               AS "itemCode",
              i.ITEM_NAME                               AS "itemName",
              b.LINE_CODE                               AS "lineCode",
              F_GET_LINE_NAME(b.LINE_CODE, b.ORGANIZATION_ID) AS "lineName",
              TO_CHAR(b.RUN_DATE, 'YYYY-MM-DD')         AS "runDate",
              b.LOT_NO                                  AS "lotNo",
              b.LOT_QTY                                 AS "lotQty",
              b.MAGAZINE_NO                             AS "magazineNo",
              b.BOX_NO                                  AS "boxNo",
              b.PALLETE_NO                              AS "palleteNo",
              b.BARCODE_STATUS                          AS "barcodeStatus",
              bs.CODE_MEAN_KOR                          AS "barcodeStatusName",
              b.WORKSTAGE_CODE                          AS "workstageCode",
              b.C_WORKSTAGE_CODE                        AS "currentWorkstageCode",
              TO_CHAR(b.SHIPPING_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "shippingDate",
              F_GET_PCB_REPAIR_YN(b.SERIAL_NO, b.ORGANIZATION_ID) AS "repairYn"
         FROM IP_PRODUCT_2D_BARCODE b
         LEFT JOIN ID_ITEM i ON i.ITEM_CODE = b.ITEM_CODE
         LEFT JOIN ISYS_BASECODE bs
                ON bs.CODE_TYPE = 'BARCODE STATUS' AND bs.CODE_NAME = b.BARCODE_STATUS
        WHERE b.SERIAL_NO = :serialNo
          AND b.ORGANIZATION_ID = :organizationId
        FETCH FIRST 1 ROWS ONLY`,
      { serialNo: query.serialNo, organizationId } as unknown as unknown[],
    )) as Row[];
    if (rows.length === 0) {
      throw new NotFoundException(`PID ${query.serialNo} 를 2D바코드에서 찾을 수 없습니다.`);
    }
    return rows[0];
  }

  // ───────────────────────────────── 319 롯트 상세 (PID 한 줄씩)

  /**
   * 319 가운데 표 — 이 Run No 의 PID 마다 전 공정 시각을 한 줄로 늘어놓는다.
   * PB `d_pln_product_all_barcode_tracking_es`(45컬럼, 은성판) 을 옮긴 것이다.
   *
   * 마스크·스퀴지 지그는 지그유형(M/S)별로 따로 집계해 붙인다 (PB 와 같이).
   * 롯트 단위 공통값(솔더 롯트, 첫/끝 마킹시각 …)은 스칼라 서브쿼리로 한 번만 센다.
   */
  async findLotDetail(query: RunNoQueryDto, organizationId: number) {
    requireKey({ runNo: query.runNo });
    const rows = (await this.dataSource.query(
      `WITH jig AS (
         SELECT JIG_TYPE,
                MIN(INPUT_DATE)        AS INPUT_DATE,
                MIN(JIG_LOT_NO)        AS FIRST_JIG_LOT_NO,
                MAX(JIG_LOT_NO)        AS LAST_JIG_LOT_NO,
                MAX(CURRENT_HIT_VALUE) AS CURRENT_HIT_VALUE
           FROM IMCN_JIG_INPUT_HIST
          WHERE RUN_NO = :runNo AND JIG_TYPE IN ('M', 'S')
          GROUP BY JIG_TYPE
       ),
       lot AS (
         SELECT ( SELECT LISTAGG(SOLDER_LOT_NO, ',') WITHIN GROUP (ORDER BY SOLDER_LOT_NO)
                    FROM IM_ITEM_SOLDER_INPUT_HIST WHERE RUN_NO = :runNo ) AS SOLDER_LOT_NO,
                ( SELECT MIN(DATESET) FROM IQ_MACHINE_INSPECT_DATA_MK
                   WHERE RUN_NO = :runNo ) AS FIRST_MARKING_DATE,
                ( SELECT MAX(DATESET) FROM IQ_MACHINE_INSPECT_DATA_MK
                   WHERE RUN_NO = :runNo ) AS LAST_MARKING_DATE,
                ( SELECT MIN(INSPECT_DATE) FROM IQ_MACHINE_INSPECT_DATA_SPI
                   WHERE RUN_NO = :runNo ) AS MIN_SPI_INSPECT_DATE,
                ( SELECT MAX(INSPECT_DATE) FROM IQ_MACHINE_INSPECT_DATA_SPI
                   WHERE RUN_NO = :runNo ) AS MAX_SPI_INSPECT_DATE,
                ( SELECT MIN(INSPECT_DATE) FROM IQ_MACHINE_INSPECT_DATA_AOI
                   WHERE RUN_NO = :runNo ) AS MIN_AOI_INSPECT_DATE,
                ( SELECT MAX(INSPECT_DATE) FROM IQ_MACHINE_INSPECT_DATA_AOI
                   WHERE RUN_NO = :runNo ) AS MAX_AOI_INSPECT_DATE,
                ( SELECT MIN(INPUT_DATE) FROM IMCN_SAMPLE_INPUT_HIST
                   WHERE RUN_NO = :runNo ) AS SAMPLE_INPUT_DATE,
                ( SELECT MIN(CHECK_DATE) FROM IB_SMT_CHECKHIST
                   WHERE RUN_NO = :runNo AND CHECK_TYPE = '1' ) AS CCS_START_DATE,
                ( SELECT MAX(CHECK_DATE) FROM IB_SMT_CHECKHIST
                   WHERE RUN_NO = :runNo AND CHECK_TYPE = '1' ) AS CCS_END_DATE
           FROM DUAL
       )
       SELECT b.SERIAL_NO                               AS "serialNo",
              b.RUN_NO                                  AS "runNo",
              TO_CHAR(b.RUN_DATE, 'YYYY-MM-DD')         AS "runDate",
              b.LINE_CODE                               AS "lineCode",
              F_GET_LINE_NAME(b.LINE_CODE, b.ORGANIZATION_ID) AS "lineName",
              b.MAGAZINE_NO                             AS "magazineNo",
              b.BOX_NO                                  AS "boxNo",
              b.PALLETE_NO                              AS "palleteNo",
              b.MODEL_NAME                              AS "modelName",
              b.LOT_QTY                                 AS "lotQty",
              TO_CHAR(b.SHIPPING_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "shippingDate",
              TO_CHAR(ps.SCAN_DATE, 'YYYY-MM-DD HH24:MI:SS')    AS "boxScanDate",
              mk.EQUIPMENTID                            AS "markingEquipmentId",
              mk.DATESET                                AS "markingDate",
              aoi.EQUIPMENTID                           AS "aoiEquipmentId",
              aoi.INSPECT_DATE                          AS "aoiInspectDate",
              aoi.RESULT                                AS "aoiResult",
              aoi.DEFECT_CODE                           AS "aoiDefectCode",
              spi.EQUIPMENTID                           AS "spiEquipmentId",
              spi.INSPECT_DATE                          AS "spiInspectDate",
              spi.RESULT                                AS "spiResult",
              spi.DEFECT_CODE                           AS "spiDefectCode",
              TO_CHAR(jm.INPUT_DATE, 'YYYY-MM-DD HH24:MI:SS')   AS "maskInputDate",
              jm.LAST_JIG_LOT_NO                        AS "maskJigLotNo",
              jm.CURRENT_HIT_VALUE                      AS "maskHitValue",
              TO_CHAR(js.INPUT_DATE, 'YYYY-MM-DD HH24:MI:SS')   AS "squeezeInputDate",
              js.FIRST_JIG_LOT_NO || ',' || js.LAST_JIG_LOT_NO  AS "squeezeJigLotNo",
              js.CURRENT_HIT_VALUE                      AS "squeezeHitValue",
              lot.SOLDER_LOT_NO                         AS "solderLotNo",
              F_GET_TIME_TERM_HHHMISS(
                TO_DATE(mk.DATESET, 'YYYY/MM/DD HH24:MI:SS'),
                NVL(b.SHIPPING_DATE, SYSDATE))          AS "markingToShippingTime",
              F_GET_PCB_REPAIR_YN(b.SERIAL_NO, b.ORGANIZATION_ID) AS "repairYn",
              lot.FIRST_MARKING_DATE                    AS "firstMarkingDate",
              lot.LAST_MARKING_DATE                     AS "lastMarkingDate",
              lot.MIN_SPI_INSPECT_DATE                  AS "minSpiInspectDate",
              lot.MAX_SPI_INSPECT_DATE                  AS "maxSpiInspectDate",
              lot.MIN_AOI_INSPECT_DATE                  AS "minAoiInspectDate",
              lot.MAX_AOI_INSPECT_DATE                  AS "maxAoiInspectDate",
              F_GET_TIME_TERM_HHHMISS(
                TO_DATE(spi.INSPECT_DATE, 'YYYY/MM/DD HH24:MI:SS'),
                TO_DATE(aoi.INSPECT_DATE, 'YYYY/MM/DD HH24:MI:SS')) AS "spiToAoiTime",
              F_GET_TIME_TERM_HHHMISS(
                TO_DATE(mk.DATESET, 'YYYY/MM/DD HH24:MI:SS'),
                TO_DATE(aoi.INSPECT_DATE, 'YYYY/MM/DD HH24:MI:SS')) AS "markingToAoiTime",
              TO_CHAR(lot.SAMPLE_INPUT_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "sampleInputDate",
              TO_CHAR(lot.CCS_START_DATE, 'YYYY-MM-DD HH24:MI:SS')    AS "ccsStartDate",
              TO_CHAR(lot.CCS_END_DATE, 'YYYY-MM-DD HH24:MI:SS')      AS "ccsEndDate"
         FROM IP_PRODUCT_2D_BARCODE b
         CROSS JOIN lot
         LEFT JOIN IQ_MACHINE_INSPECT_DATA_MK  mk  ON mk.PID = b.SERIAL_NO
         LEFT JOIN IQ_MACHINE_INSPECT_DATA_AOI aoi ON aoi.PID = b.SERIAL_NO
         LEFT JOIN IQ_MACHINE_INSPECT_DATA_SPI spi ON spi.PID = b.SERIAL_NO
         LEFT JOIN IP_PRODUCT_PACK_SERIAL      ps  ON ps.BARCODE = b.SERIAL_NO
         LEFT JOIN jig jm ON jm.JIG_TYPE = 'M'
         LEFT JOIN jig js ON js.JIG_TYPE = 'S'
        WHERE b.RUN_NO = :runNo
          AND b.ORGANIZATION_ID = :organizationId
        ORDER BY b.SERIAL_NO
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      { runNo: query.runNo, organizationId } as unknown as unknown[],
    )) as Row[];
    return { data: rows, total: rows.length };
  }

  // ───────────────────────────────── 317·319 PID 자재 목록

  /**
   * 317·319 아래쪽 표 — 이 PID 가 속한 롯트에 투입된 자재.
   *
   * PB `d_ip_product_pid_inspect_data_mat_lst` 를 옮겼다. PB 는
   * `SERIAL_NO like :ARG_SERIAL_NO` 였는데 관례상 빈 입력이 `'%'` 가 되어
   * **아무 롯트나 하나 집어 왔다** (`ROWNUM = 1`). 등호로 바꿨다 — PID 를 안 넣고
   * 열면 엉뚱한 자재가 나오는 것이 PB 의 동작이었고, 그건 이식할 값이 아니다.
   */
  async findPidMaterials(query: SerialNoQueryDto, organizationId: number) {
    requireKey({ serialNo: query.serialNo });
    const rows = (await this.dataSource.query(
      `SELECT c.LINE_CODE                               AS "lineCode",
              F_GET_LINE_NAME(c.LINE_CODE, :organizationId) AS "lineName",
              c.LOCATION_CODE                           AS "locationCode",
              c.PCB_ITEM                                AS "pcbItem",
              c.CHECK_TYPE                              AS "checkType",
              ct.CODE_MEAN_KOR                          AS "checkTypeName",
              c.ITEM_CODE                               AS "itemCode",
              i.ITEM_NAME                               AS "itemName",
              i.ITEM_SPEC                               AS "itemSpec",
              c.SCAN_PARTNAME                           AS "scanPartName",
              c.SCAN_SUPPLIER_PARTNAME                  AS "scanSupplierPartName",
              c.SCAN_QTY                                AS "scanQty",
              c.LOT_NO                                  AS "lotNo",
              TO_CHAR(c.CHECK_DATE, 'YYYY-MM-DD HH24:MI:SS')         AS "feedingDate",
              TO_CHAR(b.REEL_DESTROY_DATE, 'YYYY-MM-DD HH24:MI:SS')  AS "reelDestroyDate",
              i.MSL_LEVEL                               AS "mslLevel",
              i.MSL_MAX_TIME                            AS "mslMaxTime",
              F_GET_MSL_PASSED_TIME(b.ITEM_BARCODE)     AS "mslPassedTime"
         FROM IB_SMT_CHECKHIST c
         LEFT JOIN IM_ITEM_RECEIPT_BARCODE b ON b.ITEM_BARCODE = c.SCAN_PARTNAME
         LEFT JOIN ID_ITEM i ON i.ITEM_CODE = c.ITEM_CODE
         LEFT JOIN ISYS_BASECODE ct
                ON ct.CODE_TYPE = 'CHECK TYPE' AND ct.CODE_NAME = c.CHECK_TYPE
        WHERE c.RUN_NO = ( SELECT MAX(RUN_NO)
                             FROM IP_PRODUCT_2D_BARCODE
                            WHERE SERIAL_NO = :serialNo
                              AND ORGANIZATION_ID = :organizationId )
        ORDER BY c.CHECK_DATE, c.LOCATION_CODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      { serialNo: query.serialNo, organizationId } as unknown as unknown[],
    )) as Row[];
    return { data: rows, total: rows.length };
  }
}
