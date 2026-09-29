/**
 * @file src/modules/tracking/material-tracking.service.ts
 * @description 자재 추적 3화면
 *              313 w_product_pid_tracking_rpt          자재 제조번호 기준 추적
 *              314 w_product_material_tracking_rpt     자재추적조회(동적)
 *              315 w_product_material_tracking_msl_rpt 자재사용이력조회
 *
 * 초보자 가이드:
 * 1. **세 화면 다 '자재 하나가 어디에 들어갔나' 를 되짚는다.** 출발점만 다르다 —
 *    313·315 는 자재 제조번호에서, 314 는 완제품 PID 에서 시작한다.
 * 2. **제조번호 칸에 바코드를 넣어도 된다.** PB 처럼 F_GET_LOT_NO_FROM_BARCODE 로
 *    제조번호를 뽑는다. 이 함수를 TypeScript 로 다시 쓰면 PB 와 값이 갈린다.
 * 3. **날짜는 불투명 키로 주고받는다.** Oracle DATE 를 JSON 으로 내보내면 UTC 로
 *    바뀌는데 DB 는 KST 를 담고 있어 9시간이 틀어진다. 화면 표시용 문자열과
 *    다음 조회에 그대로 돌려줄 `...Key`(YYYYMMDDHH24MISS) 를 함께 낸다.
 * 4. **313 의 라인 매핑은 PB 하드코딩이다.** SMT 통합라인 31~34 를 고르면 SPI
 *    장비라인 2개를 봐야 한다. 지어낸 규칙이 아니라 PB 원본을 옮긴 것이다.
 * 5. **코드값은 코드표에서 뜻을 붙인다.** PB 는 DECODE 로 'CCS'/'REEL' 을 SQL 안에
 *    박아 뒀는데, 이 DB 의 'CHECK TYPE' 코드표는 1=CCS · 2=릴교환 · 3=풀체크 ·
 *    4=릴체크 다. 코드표가 정본이라 그쪽을 쓴다 (다른 화면과 문구가 같아진다).
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { checkTrackingFilter, likePrefix } from '@smt/shared';
import {
  DynamicMaterialQueryDto,
  LotNoQueryDto,
  MaterialLotSpiQueryDto,
  SerialNoQueryDto,
} from './tracking.dto';

type Row = Record<string, unknown>;

/**
 * PB 가 313 에 하드코딩한 라인 매핑 (w_product_pid_tracking_rpt dw_1::rowfocuschanged).
 * SMT 통합라인 하나가 SPI 장비 2대에 걸쳐 있어 검사데이터는 장비라인으로 찾는다.
 */
const SPI_LINE_EXPANSION: Readonly<Record<string, readonly string[]>> = {
  '31': ['01', '02'],
  '32': ['03', '04'],
  '33': ['05', '06'],
  '34': ['07', '08'],
};

/** 한 화면이 한 번에 내보낼 최대 행수. 추적은 키 단건 조회라 이 선을 넘으면 조건이 잘못된 것이다. */
const ROW_LIMIT = 5000;

/**
 * 키가 실제로 채워졌는지 확인한다.
 *
 * DTO 의 `@IsString() @Length(1, 60)` 은 `'%'` 나 공백 한 칸을 통과시킨다. PB 관례가
 * 빈 입력을 `'%'` 로 바꿔 보내던 시스템이라 프론트 코드가 무심히 `'%'` 를 넘길 수
 * 있고, 그러면 1억행 표를 조건 없이 훑는다. 판정은 `@smt/shared` 한 곳에 있고
 * 프론트도 같은 함수로 조회 버튼을 막는다.
 */
function requireKey(input: Parameters<typeof checkTrackingFilter>[0]) {
  const verdict = checkTrackingFilter(input);
  if (!verdict.ok) throw new BadRequestException(verdict.reason);
}

@Injectable()
export class MaterialTrackingService {
  constructor(private readonly dataSource: DataSource) {}

  /**
   * 입력이 바코드면 제조번호로 바꾼다. PB 가 조회 직전에 하던 일이다
   * (`select f_get_lot_no_from_barcode(:barcode) into :lot_no from dual`).
   * 함수가 빈 값을 주면 입력을 그대로 쓴다 — 이미 제조번호를 넣은 경우다.
   */
  private async resolveLotNo(input: string): Promise<string> {
    const rows = (await this.dataSource.query(
      `SELECT F_GET_LOT_NO_FROM_BARCODE(:barcode) AS "lotNo" FROM DUAL`,
      { barcode: input } as unknown as unknown[],
    )) as Row[];
    const resolved = rows[0]?.lotNo;
    return resolved ? String(resolved) : input;
  }

  // ───────────────────────────────── 313 자재 제조번호 기준 추적

  /**
   * 313 위쪽 표 — 이 제조번호가 라인에 투입돼 있던 구간.
   * 종료시각은 PB 와 같이 F_GET_CHECK_DATA_END 가 정한다 (다음 교체 시각).
   *
   * **IB_SMT_CHECKHIST 에는 ORGANIZATION_ID 컬럼이 없다** (실측 ORA-00904).
   * 라인명을 붙일 때 조직을 바인드로 넘긴다 — 테이블에 있을 것이라 짐작하면 안 된다.
   */
  async findFeedingWindows(query: LotNoQueryDto, organizationId: number) {
    requireKey({ lotNo: query.lotNo });
    const lotNo = await this.resolveLotNo(query.lotNo);
    const end = `F_GET_CHECK_DATA_END(a.LINE_CODE, a.LOT_NAME, a.PARTNAME,`
      + ` a.LOCATION_CODE, a.LOT_NO, a.CHECK_DATE)`;
    const rows = (await this.dataSource.query(
      `SELECT TO_CHAR(a.CHECK_DATE, 'YYYY-MM-DD HH24:MI:SS')    AS "checkDateStart",
              TO_CHAR(a.CHECK_DATE, 'YYYYMMDDHH24MISS')         AS "checkDateStartKey",
              TO_CHAR(${end}, 'YYYY-MM-DD HH24:MI:SS')          AS "checkDateEnd",
              TO_CHAR(${end}, 'YYYYMMDDHH24MISS')               AS "checkDateEndKey",
              a.LOT_NAME                                        AS "lotName",
              a.PARTNAME                                        AS "partName",
              a.LINE_CODE                                       AS "lineCode",
              F_GET_LINE_NAME(a.LINE_CODE, :organizationId)      AS "lineName",
              a.LOT_NO                                          AS "lotNo",
              a.PCB_ITEM                                        AS "pcbItem",
              a.LOCATION_CODE                                   AS "locationCode",
              a.CHECK_TYPE                                      AS "checkType",
              ct.CODE_MEAN_KOR                                  AS "checkTypeName",
              a.TRACE_CODE                                      AS "traceCode",
              b.VENDOR_LOTNO                                    AS "vendorLotNo",
              b.VENDOR_CODE                                     AS "vendorCode",
              a.OUR_BARCODE_ORIGIN                              AS "ourBarcodeOrigin",
              a.SUPPLIER_BARCODE_ORIGIN                         AS "supplierBarcodeOrigin",
              TO_CHAR(a.CCS_END_DATE, 'YYYY-MM-DD HH24:MI:SS')  AS "ccsEndDate"
         FROM IB_SMT_CHECKHIST a
         LEFT JOIN IM_ITEM_RECEIPT_BARCODE b ON b.LOT_NO = a.LOT_NO
         LEFT JOIN ISYS_BASECODE ct
                ON ct.CODE_TYPE = 'CHECK TYPE' AND ct.CODE_NAME = a.CHECK_TYPE
        WHERE a.LOT_NO = :lotNo
          AND a.CHECK_TYPE IN ('1', '2')
          AND a.CHECK_STATUS = 'P'
        ORDER BY a.CHECK_DATE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      { lotNo, organizationId } as unknown as unknown[],
    )) as Row[];
    return { data: rows, total: rows.length, resolvedLotNo: lotNo };
  }

  /**
   * 313 아래쪽 표 — 위에서 고른 투입 구간·라인의 SPI 검사데이터.
   *
   * 기간을 사용자가 정하지 않는다. 고른 행의 투입 시작~종료가 기간이다.
   * IQ_MACHINE_INSPECT_SPI 는 1억행이고 (INSPECT_DATE, PID) 인덱스가 있어
   * 구간이 닫혀 있어야 인덱스를 탄다.
   *
   * INSPECT_DATE 는 **DATE 가 아니라 VARCHAR2** 다 ('YYYY/MM/DD HH24:MI:SS').
   * PB 도 문자열로 비교했다 — 이 형식은 사전순이 시간순과 같아서 성립한다.
   */
  async findLotSpiData(query: MaterialLotSpiQueryDto, organizationId: number) {
    const lines = SPI_LINE_EXPANSION[query.lineCode] ?? [query.lineCode];
    const placeholders = lines.map((_, i) => `:line${i}`).join(', ');
    const binds: Record<string, unknown> = {
      dateStart: query.checkDateStart,
      dateEnd: query.checkDateEnd,
      organizationId,
    };
    lines.forEach((code, i) => {
      binds[`line${i}`] = code;
    });

    const rows = (await this.dataSource.query(
      `SELECT 'SPI'                                    AS "workstageName",
              s.CSTID                                  AS "cstId",
              s.SEQ_NO                                 AS "seqNo",
              s.PID                                    AS "pid",
              s.RUN_NO                                 AS "inspectRunNo",
              s.EQUIPMENTID                            AS "equipmentId",
              s.INSPECT_DATE                           AS "inspectDate",
              s.RESULT                                 AS "result",
              s.DEFECT_CODE                            AS "defectCode",
              s.LINE_CODE                              AS "lineCode",
              F_GET_LINE_NAME(s.LINE_CODE, s.ORGANIZATION_ID) AS "lineName",
              b.RUN_NO                                 AS "runNo",
              b.MAGAZINE_NO                            AS "magazineNo",
              b.BOX_NO                                 AS "boxNo",
              b.PALLETE_NO                             AS "palleteNo",
              b.CUSTOMER_MODEL_NAME                    AS "customerModelName",
              TO_CHAR(b.MAGAZINE_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "magazineDate",
              b.SHIFT_CODE                             AS "shiftCode",
              b.MASK_LOT_NO                            AS "maskLotNo",
              b.SQUEEZE_LOT_NO                         AS "squeezeLotNo",
              b.SOLDER_LOT_NO                          AS "solderLotNo",
              b.LONGTERM_YN                            AS "longtermYn",
              TO_CHAR(b.QC_SCAN_DATE, 'YYYY-MM-DD HH24:MI:SS')  AS "qcScanDate",
              b.MODEL_NAME                             AS "modelName",
              b.LOT_QTY                                AS "lotQty",
              TO_CHAR(b.RUN_DATE, 'YYYY-MM-DD')        AS "runDate",
              b.WORKSTAGE_CODE                         AS "workstageCode",
              b.IS_PROGRESS                            AS "isProgress",
              b.C_WORKSTAGE_CODE                       AS "currentWorkstageCode"
         FROM IQ_MACHINE_INSPECT_SPI s
         LEFT JOIN IP_PRODUCT_2D_BARCODE b ON b.SERIAL_NO = s.PID
        WHERE s.INSPECT_DATE >= TO_CHAR(TO_DATE(:dateStart, 'YYYYMMDDHH24MISS'),
                                        'YYYY/MM/DD HH24:MI:SS')
          AND s.INSPECT_DATE <  TO_CHAR(TO_DATE(:dateEnd, 'YYYYMMDDHH24MISS'),
                                        'YYYY/MM/DD HH24:MI:SS')
          AND s.LINE_CODE IN (${placeholders})
          AND s.ORGANIZATION_ID = :organizationId
        ORDER BY s.INSPECT_DATE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      binds as unknown as unknown[],
    )) as Row[];
    return { data: rows, total: rows.length, expandedLines: lines };
  }

  // ───────────────────────────────── 314 자재추적조회(동적)

  /**
   * 314 위쪽 표 — 이 PID 가 지나간 공정 시점 (SPI · AOI · 투입).
   *
   * 각 행이 '그 라인이 언제 꺼졌었고(minDatetime) 언제 검사됐나(maxDatetime)' 를
   * 들고 있다. 아래쪽 표가 그 시각으로 자재를 되짚는다.
   *
   * PB 원본은 `INSPECT_DATA.PID = 2d_barcode.SERIAL_NO (+)` 로 2D바코드를
   * 선택조인으로 써 놓고, 바로 다음 줄에서 `2d_barcode.MODEL_NAME =
   * MODEL_MASTER.MODEL_NAME` 을 걸어 **선택조인을 스스로 무력화했다**
   * (필수조건이 붙으면 내부조인이 된다). 여기서는 둘 다 LEFT JOIN 으로 두어
   * 2D바코드에 등록되지 않은 PID 도 검사이력이 보이게 했다.
   */
  async findStageTimeline(query: SerialNoQueryDto, organizationId: number) {
    requireKey({ serialNo: query.serialNo });
    const rows = (await this.dataSource.query(
      `WITH stage AS (
         SELECT 'SPI' AS WORKSTAGE_NAME, d.PID, d.LINE_CODE, d.EQUIPMENTID,
                d.CSTID, d.SEQ_NO, d.RESULT, d.DEFECT_CODE, d.FILE_NAME, d.RUN_NO,
                TO_DATE(d.INSPECT_DATE, 'YYYY/MM/DD HH24:MI:SS') AS INSPECT_DATE,
                ( SELECT MAX(TO_DATE(x.INSPECT_DATE, 'YYYY/MM/DD HH24:MI:SS'))
                    FROM IQ_MACHINE_INSPECT_DATA_SPI x
                   WHERE x.PID = d.PID AND x.LINE_CODE = d.LINE_CODE ) AS MAX_DATETIME
           FROM IQ_MACHINE_INSPECT_DATA_SPI d
          WHERE d.PID = :serialNo AND d.ORGANIZATION_ID = :organizationId
         UNION ALL
         SELECT 'AOI', d.PID, d.LINE_CODE, d.EQUIPMENTID,
                d.CSTID, d.SEQ_NO, d.RESULT, d.DEFECT_CODE, d.FILE_NAME, d.RUN_NO,
                TO_DATE(d.INSPECT_DATE, 'YYYY/MM/DD HH24:MI:SS'),
                ( SELECT MAX(TO_DATE(x.INSPECT_DATE, 'YYYY/MM/DD HH24:MI:SS'))
                    FROM IQ_MACHINE_INSPECT_DATA_AOI x
                   WHERE x.PID = d.PID AND x.LINE_CODE = d.LINE_CODE )
           FROM IQ_MACHINE_INSPECT_DATA_AOI d
          WHERE d.PID = :serialNo AND d.ORGANIZATION_ID = :organizationId
         UNION ALL
         SELECT 'START', io.SERIAL_NO, io.LINE_CODE, NULL,
                NULL, NULL, NULL, NULL, NULL, io.RUN_NO,
                io.IO_DATE, io.IO_DATE
           FROM IP_PRODUCT_WORKSTAGE_IO io
          WHERE io.SERIAL_NO = :serialNo
            AND io.WORKSTAGE_CODE = 'W020'
            AND io.ORGANIZATION_ID = :organizationId
       )
       SELECT g.WORKSTAGE_NAME                         AS "workstageName",
              g.PID                                    AS "serialNo",
              g.LINE_CODE                              AS "lineCode",
              F_GET_LINE_NAME(g.LINE_CODE, :organizationId) AS "lineName",
              g.EQUIPMENTID                            AS "equipmentId",
              g.CSTID                                  AS "cstId",
              g.SEQ_NO                                 AS "seqNo",
              g.RESULT                                 AS "result",
              g.DEFECT_CODE                            AS "defectCode",
              g.FILE_NAME                              AS "fileName",
              g.RUN_NO                                 AS "runNo",
              b.MODEL_NAME                             AS "modelName",
              m.SMT_MODEL_NAME                         AS "smtModelName",
              b.ITEM_CODE                              AS "itemCode",
              b.MAGAZINE_NO                            AS "magazineNo",
              b.BOX_NO                                 AS "boxNo",
              b.PALLETE_NO                             AS "palleteNo",
              b.CARRIER_BARCODE                        AS "carrierBarcode",
              b.QC_SCAN_YN                             AS "qcScanYn",
              b.LOT_NO                                 AS "lotNo",
              b.LOT_QTY                                AS "lotQty",
              b.BARCODE_STATUS                         AS "barcodeStatus",
              bs.CODE_MEAN_KOR                         AS "barcodeStatusName",
              TO_CHAR(b.RUN_DATE, 'YYYY-MM-DD')        AS "runDate",
              TO_CHAR(g.INSPECT_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "inspectDate",
              TO_CHAR(g.MAX_DATETIME, 'YYYY-MM-DD HH24:MI:SS') AS "maxDatetime",
              TO_CHAR(g.MAX_DATETIME, 'YYYYMMDDHH24MISS')      AS "maxDatetimeKey",
              TO_CHAR(
                ( SELECT MAX(h.LINE_ONOFF_DATE)
                    FROM IB_SMT_LINE_ONOFF_HISTORY h
                   WHERE h.LINE_CODE = g.LINE_CODE
                     AND h.LINE_ONOFF = 'OFF'
                     AND h.LINE_ONOFF_DATE < g.MAX_DATETIME ),
                'YYYY-MM-DD HH24:MI:SS')               AS "minDatetime",
              TO_CHAR(
                ( SELECT MAX(h.LINE_ONOFF_DATE)
                    FROM IB_SMT_LINE_ONOFF_HISTORY h
                   WHERE h.LINE_CODE = g.LINE_CODE
                     AND h.LINE_ONOFF = 'OFF'
                     AND h.LINE_ONOFF_DATE < g.MAX_DATETIME ),
                'YYYYMMDDHH24MISS')                    AS "minDatetimeKey"
         FROM stage g
         LEFT JOIN IP_PRODUCT_2D_BARCODE b ON b.SERIAL_NO = g.PID
         LEFT JOIN IP_PRODUCT_MODEL_MASTER m ON m.MODEL_NAME = b.MODEL_NAME
         LEFT JOIN ISYS_BASECODE bs
                ON bs.CODE_TYPE = 'BARCODE STATUS' AND bs.CODE_NAME = b.BARCODE_STATUS
        ORDER BY g.INSPECT_DATE, g.WORKSTAGE_NAME`,
      { serialNo: query.serialNo, organizationId } as unknown as unknown[],
    )) as Row[];
    return { data: rows, total: rows.length };
  }

  /**
   * 314 아래쪽 표 — 고른 시점에 그 라인/모델에 세팅돼 있던 자재.
   *
   * 두 갈래를 UNION 한다 (PB 원본 그대로):
   *   MIN    기준시각 이전의 **가장 최근** 투입 = 그 순간 물려 있던 릴
   *   APPEND 기준시각 이후 N 분 안의 추가 투입 = 검사 직후 바뀐 릴
   * 두 번째 갈래가 있어야 '불량 시점 전후에 무엇이 바뀌었나' 가 보인다.
   *
   * 기준시각이 곧 필수조건이다. DTO 가 maxDatetime 을 필수로 받으므로 조건 없는
   * 전체 조회가 불가능하다 — IB_SMT_CHECKHIST 는 (CHECK_DATE, ...) 인덱스가 있어
   * 시각이 닫혀 있으면 구간 스캔으로 끝난다.
   */
  async findDynamicMaterials(query: DynamicMaterialQueryDto, organizationId: number) {
    const body = (alias: string) =>
      `SELECT ${alias}.LOT_NAME          AS "lotName",
              ${alias}.LINE_CODE         AS "lineCode",
              F_GET_LINE_NAME(${alias}.LINE_CODE, :organizationId) AS "lineName",
              ${alias}.MACHINE           AS "machine",
              ${alias}.PARTNAME          AS "partName",
              ${alias}.SCAN_PARTNAME     AS "scanPartName",
              ${alias}.CHIPNAME          AS "chipName",
              i.ITEM_NAME                AS "itemName",
              i.ITEM_SPEC                AS "itemSpec",
              TO_CHAR(${alias}.CHECK_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "checkDate",
              ${alias}.TABLE_ID          AS "tableId",
              ${alias}.LOCATION_CODE     AS "locationCode",
              ${alias}.CHECK_SEQUENCE    AS "checkSequence",
              ${alias}.CHECK_STATUS      AS "checkStatus",
              cs.CODE_MEAN_KOR           AS "checkStatusName",
              ${alias}.CHECK_MSG         AS "checkMsg",
              ${alias}.CHECK_TYPE        AS "checkType",
              ct.CODE_MEAN_KOR           AS "checkTypeName",
              ${alias}.NG_REASON         AS "ngReason",
              ${alias}.FULL_CHECK_SEQUENCE AS "fullCheckSequence",
              ${alias}.PCB_ITEM          AS "pcbItem",
              ${alias}.OLD_BARCODE       AS "oldBarcode",
              ${alias}.ITEM_CODE         AS "itemCode",
              TO_CHAR(${alias}.CCS_END_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "ccsEndDate",
              ${alias}.LOT_NO            AS "lotNo",
              TO_CHAR(${alias}.VALID_DATE, 'YYYY-MM-DD')  AS "validDate",
              ${alias}.LOT_SERIAL        AS "lotSerial",
              ${alias}.TRACE_CODE        AS "traceCode",
              ${alias}.SUPPLIER_BARCODE_ORIGIN AS "supplierBarcodeOrigin",
              rb.VENDOR_LOTNO            AS "vendorLotNo",
              ${alias}.SMT_MODEL_NAME    AS "smtModelName"
         FROM IB_SMT_CHECKHIST ${alias}
         LEFT JOIN ID_ITEM i ON i.ITEM_CODE = ${alias}.PARTNAME
         LEFT JOIN IM_ITEM_RECEIPT_BARCODE rb ON rb.LOT_NO = ${alias}.LOT_NO
         LEFT JOIN ISYS_BASECODE ct
                ON ct.CODE_TYPE = 'CHECK TYPE' AND ct.CODE_NAME = ${alias}.CHECK_TYPE
         LEFT JOIN ISYS_BASECODE cs
                ON cs.CODE_TYPE = 'CHECK STATUS' AND cs.CODE_NAME = ${alias}.CHECK_STATUS`;

    // UNION ALL 의 ORDER BY 는 파생 별칭을 찾지 못한다 (실측 ORA-00904 "lineName").
    // 합집합을 한 번 더 감싸고 바깥에서 정렬한다 — 위치번호로 정렬하면 컬럼이
    // 하나 늘어날 때 조용히 엉뚱한 기준으로 정렬된다.
    const rows = (await this.dataSource.query(
      `SELECT * FROM (
       SELECT 'MIN' AS "branch", x.* FROM (
         ${body('a')}
        WHERE a.CHECK_DATE <= TO_DATE(:maxDatetime, 'YYYYMMDDHH24MISS')
          AND NVL(a.SMT_MODEL_NAME, '*') LIKE :modelName ESCAPE '\\'
          AND NVL(a.LINE_CODE, '*') LIKE :lineCode ESCAPE '\\'
          AND a.CHECK_TYPE IN ('1', '2')
          AND a.CHECK_STATUS = 'P'
          AND (a.CHECK_DATE, a.PCB_ITEM, a.LOCATION_CODE) IN (
                SELECT MAX(CHECK_DATE), PCB_ITEM, LOCATION_CODE
                  FROM IB_SMT_CHECKHIST
                 WHERE CHECK_DATE <= TO_DATE(:maxDatetime, 'YYYYMMDDHH24MISS')
                   AND CHECK_DATE >= NVL(TO_DATE(:minDatetime, 'YYYYMMDDHH24MISS'),
                                         TO_DATE(:maxDatetime, 'YYYYMMDDHH24MISS') - 30)
                   AND NVL(SMT_MODEL_NAME, '*') LIKE :modelName ESCAPE '\\'
                   AND NVL(LINE_CODE, '*') LIKE :lineCode ESCAPE '\\'
                   AND CHECK_TYPE IN ('1', '2')
                   AND CHECK_STATUS = 'P'
                 GROUP BY LINE_CODE, LOT_NAME, SMT_MODEL_NAME, PCB_ITEM, LOCATION_CODE )
       ) x
       UNION ALL
       SELECT 'APPEND' AS "branch", y.* FROM (
         ${body('b')}
        WHERE b.CHECK_DATE >= TO_DATE(:maxDatetime, 'YYYYMMDDHH24MISS')
          AND b.CHECK_DATE <= TO_DATE(:maxDatetime, 'YYYYMMDDHH24MISS')
                              + (:timeMinutes / 24 / 60)
          AND NVL(b.SMT_MODEL_NAME, '*') LIKE :modelName ESCAPE '\\'
          AND NVL(b.LINE_CODE, '*') LIKE :lineCode ESCAPE '\\'
          AND b.CHECK_TYPE IN ('1', '2')
          AND b.CHECK_STATUS = 'P'
          AND (b.CHECK_DATE, b.PCB_ITEM, b.LOCATION_CODE) IN (
                SELECT MAX(CHECK_DATE), PCB_ITEM, LOCATION_CODE
                  FROM IB_SMT_CHECKHIST
                 WHERE CHECK_DATE >= TO_DATE(:maxDatetime, 'YYYYMMDDHH24MISS')
                   AND CHECK_DATE <= TO_DATE(:maxDatetime, 'YYYYMMDDHH24MISS')
                                     + (:timeMinutes / 24 / 60)
                   AND NVL(SMT_MODEL_NAME, '*') LIKE :modelName ESCAPE '\\'
                   AND NVL(LINE_CODE, '*') LIKE :lineCode ESCAPE '\\'
                   AND CHECK_TYPE IN ('1', '2')
                   AND CHECK_STATUS = 'P'
                 GROUP BY LINE_CODE, LOT_NAME, SMT_MODEL_NAME, PCB_ITEM, LOCATION_CODE )
       ) y
       )
       ORDER BY "lineName", "pcbItem", "locationCode", "checkDate"`,
      {
        maxDatetime: query.maxDatetime,
        minDatetime: query.minDatetime ?? null,
        // PB 관례: 빈 조건은 '%'. NULL LIKE '%' 는 NULL 이라 컬럼을 NVL 로 감쌌다.
        // likePrefix 가 입력의 '%'·'_' 를 escape 한다 — 그러지 않으면 모델명 칸에
        // '%' 한 글자만 넣어도 조건이 '%%' 가 되어 전체를 훑는다. SQL 쪽에
        // ESCAPE 절이 함께 있어야 escape 가 실제로 먹는다.
        modelName: likePrefix(query.modelName),
        lineCode: likePrefix(query.lineCode),
        timeMinutes: query.timeMinutes ?? 0,
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return { data: rows, total: rows.length };
  }

  // ───────────────────────────────── 315 자재사용이력조회

  /**
   * 315 — 제조번호 하나의 전 생애. 세 갈래를 시간순으로 잇는다.
   *   SMT 투입(IB_SMT_CHECKHIST) · 출고(IM_ITEM_ISSUE) · 입고(IM_ITEM_RECEIPT)
   *
   * PB 는 구분값을 SQL 안 DECODE 로 '입고'/'입고취소'/'출고'/'출고반납' 이라고
   * 박아 뒀다. 이 DB 의 코드표는 RECEIPT DEFICIT 1=1입고 · 2=2반품,
   * ISSUE DEFICIT 3=3출고 · 4=4출고반품 이다. **코드표가 정본이라 그쪽을 쓴다** —
   * 같은 값을 자재 화면에서는 '반품' 이라고 부르는데 여기서만 '취소' 면 혼란이 된다.
   * 원시 구분값(procCode)도 같이 내보내 화면에서 확인할 수 있게 둔다.
   */
  async findMaterialUsage(query: LotNoQueryDto, organizationId: number) {
    requireKey({ lotNo: query.lotNo });
    const lotNo = await this.resolveLotNo(query.lotNo);
    const rows = (await this.dataSource.query(
      `WITH events AS (
         SELECT 'SMT'                AS SOURCE_KIND,
                c.CHECK_TYPE         AS PROC_CODE,
                c.CHECK_DATE         AS PROC_DATE,
                c.ITEM_CODE          AS ITEM_CODE,
                c.LOT_NO             AS LOT_NO,
                CAST(NULL AS NUMBER) AS QTY,
                c.LOCATION_CODE      AS LOCATION_CODE,
                c.LINE_CODE          AS LINE_CODE,
                CAST(NULL AS VARCHAR2(30)) AS WORKSTAGE_CODE,
                c.SMT_MODEL_NAME     AS SMT_MODEL_NAME,
                c.PCB_ITEM           AS PCB_ITEM,
                c.LOCATION_CODE      AS MOUNTER_ADDRESS,
                c.SUPPLIER_BARCODE_ORIGIN AS SUPPLIER_BARCODE_ORIGIN,
                c.OLD_BARCODE        AS OLD_BARCODE,
                c.RUN_NO             AS RUN_NO,
                CAST(NULL AS NUMBER) AS MSL_PASSED_TIME
           FROM IB_SMT_CHECKHIST c
          WHERE c.LOT_NO = :lotNo
            AND c.CHECK_TYPE IN ('1', '2')
            AND c.CHECK_STATUS = 'P'
         UNION ALL
         SELECT 'ISSUE', s.ISSUE_DEFICIT, s.ENTER_DATE, s.ITEM_CODE, s.MATERIAL_MFS,
                s.ISSUE_QTY, s.LOCATION_CODE, s.LINE_CODE, s.WORKSTAGE_CODE,
                NULL, NULL, NULL, NULL, NULL, NULL, s.MSL_PASSED_TIME
           FROM IM_ITEM_ISSUE s
          WHERE s.MATERIAL_MFS = :lotNo
         UNION ALL
         SELECT 'RECEIPT', r.RECEIPT_DEFICIT, r.ENTER_DATE, r.ITEM_CODE, r.MATERIAL_MFS,
                r.RECEIPT_QTY, r.LOCATION_CODE, NULL, NULL,
                NULL, NULL, NULL, NULL, NULL, NULL, NULL
           FROM IM_ITEM_RECEIPT r
          WHERE r.MATERIAL_MFS = :lotNo
       )
       SELECT e.SOURCE_KIND                            AS "sourceKind",
              e.PROC_CODE                              AS "procCode",
              CASE e.SOURCE_KIND
                   WHEN 'SMT'     THEN ct.CODE_MEAN_KOR
                   WHEN 'ISSUE'   THEN idf.CODE_MEAN_KOR
                   WHEN 'RECEIPT' THEN rdf.CODE_MEAN_KOR
              END                                      AS "procName",
              TO_CHAR(e.PROC_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "procDate",
              e.ITEM_CODE                              AS "itemCode",
              m.ITEM_NAME                              AS "itemName",
              m.ITEM_CLASS                             AS "itemClass",
              e.LOT_NO                                 AS "lotNo",
              e.QTY                                    AS "qty",
              e.LOCATION_CODE                          AS "locationCode",
              e.LINE_CODE                              AS "lineCode",
              F_GET_LINE_NAME(e.LINE_CODE, :organizationId) AS "lineName",
              e.WORKSTAGE_CODE                         AS "workstageCode",
              e.RUN_NO                                 AS "runNo",
              e.SMT_MODEL_NAME                         AS "smtModelName",
              e.PCB_ITEM                               AS "pcbItem",
              e.MOUNTER_ADDRESS                        AS "mounterAddress",
              e.SUPPLIER_BARCODE_ORIGIN                AS "supplierBarcodeOrigin",
              e.OLD_BARCODE                            AS "oldBarcode",
              m.MSL_LEVEL                              AS "mslLevel",
              m.MSL_MAX_TIME                           AS "mslMaxTime",
              e.MSL_PASSED_TIME                        AS "mslPassedTimeAtEvent",
              F_GET_MSL_PASSED_TIME(rb.ITEM_BARCODE)   AS "mslPassedTime",
              rb.MSL_PASSED_TIME                       AS "mslSavedTime",
              m.PCB_COATING_TYPE                       AS "pcbCoatingType",
              m.PCB_COATING_MAX_DAY                    AS "pcbCoatingMaxDay",
              TO_CHAR(rb.PCB_COATING_DATE, 'YYYY-MM-DD') AS "pcbCoatingDate",
              TO_CHAR(rb.SCAN_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "scanDate",
              rb.SCAN_QTY                              AS "scanQty",
              rb.MANUFACTURE_WEEK                      AS "manufactureWeek",
              TO_CHAR(rb.REEL_DESTROY_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "reelDestroyDate",
              TO_CHAR(rb.BAKING_START_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "bakingStartDate",
              TO_CHAR(rb.BAKING_END_DATE, 'YYYY-MM-DD HH24:MI:SS')   AS "bakingEndDate",
              TO_CHAR(rb.FEEDING_DATE, 'YYYY-MM-DD HH24:MI:SS')      AS "feedingDate",
              NVL(m.LIFE_CYCLE, 365)                   AS "lifeCycle"
         FROM events e
         LEFT JOIN ID_ITEM m ON m.ITEM_CODE = e.ITEM_CODE
         LEFT JOIN IM_ITEM_RECEIPT_BARCODE rb ON rb.LOT_NO = e.LOT_NO
         LEFT JOIN ISYS_BASECODE ct
                ON ct.CODE_TYPE = 'CHECK TYPE' AND ct.CODE_NAME = e.PROC_CODE
         LEFT JOIN ISYS_BASECODE idf
                ON idf.CODE_TYPE = 'ISSUE DEFICIT' AND idf.CODE_NAME = e.PROC_CODE
         LEFT JOIN ISYS_BASECODE rdf
                ON rdf.CODE_TYPE = 'RECEIPT DEFICIT' AND rdf.CODE_NAME = e.PROC_CODE
        ORDER BY e.PROC_DATE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      { lotNo, organizationId } as unknown as unknown[],
    )) as Row[];
    return { data: rows, total: rows.length, resolvedLotNo: lotNo };
  }
}
