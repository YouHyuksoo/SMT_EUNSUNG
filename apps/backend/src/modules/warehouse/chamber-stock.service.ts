/**
 * @file src/modules/warehouse/chamber-stock.service.ts
 * @description 챔버 재고조회 3화면
 *              262 w_mat_baking_scan_query   베이킹재고조회   (chamber_type 'B')
 *              263 w_mat_vacuum_scan_query   진공포장재고조회 (chamber_type 'V')
 *              264 w_mat_dehumi_scan_query   제습함재고조회   (chamber_type 'D')
 *
 * 초보자 가이드:
 * 1. **세 화면의 SQL 이 같다.** PB DataWindow 두 개(`..._baking_dehumi_query_lst`,
 *    `..._dehumi_query_lst`)의 PBSELECT 구조가 **글자까지 동일**하고, 화면이
 *    `chamber_type` 인자에 'B'/'V'/'D' 중 하나를 고정으로 넘긴다 (실측).
 *    그래서 메서드는 하나이고 갈래 인자로 가른다 — 세 벌로 복제하면 한쪽만 고쳐진다.
 * 2. **재고 = 넣었고 아직 안 꺼낸 것.** PB 고정조건
 *    `INPUT_SCAN_DATE IS NOT NULL AND OUTPUT_SCAN_DATE IS NULL` 이 그 정의다.
 *    빠뜨리면 지나간 이력 18,352건이 전부 재고로 잡힌다 (실제 재고는 59건).
 * 3. **마스터-디테일 화면이다.** 요약(챔버·품목별 묶음)에서 한 줄을 고르면 그 묶음의
 *    자재 목록이 아래에 뜬다. PB 도 그렇게 조회한다.
 * 4. **경과시간은 계산값이다.** `(SYSDATE - INPUT_SCAN_DATE) * 24` = 넣은 뒤 지난 시간
 *    (단위 시간). 품목의 `BAKING_TIME`·`LIFE_CYCLE` 과 비교해 초과를 판단하는 것이
 *    이 화면의 목적이다 — 그래서 두 기준값을 함께 내보낸다.
 * 5. **품목·설비 마스터는 외부조인이다** (PB `OUTER1` 그대로). 마스터가 없는 스캔도
 *    남아야 한다 — 챔버에 들어가 있는 물건을 빠뜨리면 안 된다.
 */
import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { likePrefix } from '@smt/shared';
import { limited, ROW_LIMIT } from '../../shared/row-limit';
import { ChamberStockDetailQueryDto, ChamberStockQueryDto } from './warehouse.dto';
import { namedBinds } from '../../common/utils/named-binds.util';

type Row = Record<string, unknown>;

/**
 * PB 고정조건: 넣었고(입고스캔 있음) 아직 안 꺼낸 것(출고스캔 없음)만 재고다.
 * 이 두 줄이 이 화면의 정의이므로 상수로 빼서 요약·상세가 같은 것을 쓴다.
 */
const STILL_IN_CHAMBER = `b.INPUT_SCAN_DATE IS NOT NULL
        AND b.OUTPUT_SCAN_DATE IS NULL`;

@Injectable()
export class ChamberStockService {
  constructor(private readonly dataSource: DataSource) {}

  /**
   * 요약 — 챔버·품목별로 몇 개가 얼마나 들어 있나.
   *
   * PB 요약 DataWindow 를 그대로 옮겼다. `SUM(1)` 은 건수이므로 `COUNT(*)` 로 쓴다
   * (값은 같고 뜻이 분명하다).
   *
   * 가장 오래 들어 있는 것의 경과시간을 함께 낸다 — PB 는 최소·최대 입고시각만
   * 보여줘서 "얼마나 오래 됐나" 를 사람이 계산해야 했다.
   */
  async findSummary(query: ChamberStockQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT b.CHAMBER_TYPE                            AS "chamberType",
              b.CHAMBER_CODE                            AS "chamberCode",
              F_GET_MACHINE_NAME(b.CHAMBER_CODE)        AS "chamberName",
              b.ITEM_CODE                               AS "itemCode",
              i.ITEM_NAME                               AS "itemName",
              i.ITEM_SPEC                               AS "itemSpec",
              i.SUPPLIER_CODE                           AS "supplierCode",
              COUNT(*)                                  AS "countNum",
              SUM(NVL(b.LOT_QTY, 0))                    AS "lotQty",
              TO_CHAR(MIN(b.INPUT_SCAN_DATE), 'YYYY-MM-DD HH24:MI:SS') AS "minScanDate",
              TO_CHAR(MAX(b.INPUT_SCAN_DATE), 'YYYY-MM-DD HH24:MI:SS') AS "maxScanDate",
              -- 가장 오래 들어 있는 것의 경과시간(시간). PB 는 시각만 보여줘서
              -- 몇 시간 됐는지 사람이 세어야 했다.
              ROUND((SYSDATE - MIN(b.INPUT_SCAN_DATE)) * 24, 1)        AS "maxLapseHours",
              i.BAKING_TIME                             AS "bakingTime",
              i.LIFE_CYCLE                              AS "lifeCycle",
              i.MSL_LEVEL                               AS "mslLevel"
         FROM IM_ITEM_BAKING_MASTER b
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = b.ITEM_CODE
        WHERE ${STILL_IN_CHAMBER}
          AND b.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND NVL(b.LOT_NO, '*') LIKE :lotNo ESCAPE '\\'
          AND NVL(b.CHAMBER_CODE, '*') LIKE :chamberCode ESCAPE '\\'
          AND b.CHAMBER_TYPE = :chamberType
          AND b.ORGANIZATION_ID = :organizationId
        GROUP BY b.CHAMBER_TYPE, b.CHAMBER_CODE, b.ITEM_CODE,
                 i.ITEM_NAME, i.ITEM_SPEC, i.SUPPLIER_CODE,
                 i.BAKING_TIME, i.LIFE_CYCLE, i.MSL_LEVEL
        ORDER BY b.CHAMBER_CODE, b.ITEM_CODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        itemCode: likePrefix(query.itemCode),
        lotNo: likePrefix(query.lotNo),
        chamberCode: likePrefix(query.chamberCode),
        chamberType: query.chamberType,
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }

  /**
   * 상세 — 요약에서 고른 (챔버, 품목) 묶음에 들어 있는 자재 하나하나.
   *
   * 품목·챔버 조건은 **등호**다 (PB 와 같다). 요약이 돌려준 값을 그대로 받으므로
   * 앞부분 일치로 넓힐 이유가 없다.
   *
   * 챔버의 온도 설정값(최소·최대·기준)을 함께 낸다 — 규격을 벗어난 챔버에 들어
   * 있는 자재를 찾는 것이 이 화면의 쓸모다.
   */
  async findDetail(query: ChamberStockDetailQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT b.CHAMBER_CODE                            AS "chamberCode",
              b.CHAMBER_TYPE                            AS "chamberType",
              b.CHAMBER_LOCATION                        AS "chamberLocation",
              b.ITEM_CODE                               AS "itemCode",
              b.ITEM_BARCODE                            AS "itemBarcode",
              b.LOT_NO                                  AS "lotNo",
              b.LOT_QTY                                 AS "lotQty",
              TO_CHAR(b.INPUT_SCAN_DATE, 'YYYY-MM-DD HH24:MI:SS')      AS "inputScanDate",
              TO_CHAR(b.OUTPUT_SCAN_DATE, 'YYYY-MM-DD HH24:MI:SS')     AS "outputScanDate",
              -- PB 계산컬럼 그대로: 넣은 뒤 지난 시간(단위 시간).
              ROUND((SYSDATE - b.INPUT_SCAN_DATE) * 24, 1)             AS "inputLapseTime",
              b.SCAN_BY                                 AS "scanBy",
              i.ITEM_NAME                               AS "itemName",
              i.ITEM_SPEC                               AS "itemSpec",
              i.ITEM_CLASS                              AS "itemClass",
              i.HEIGHT                                  AS "height",
              i.LIFE_CYCLE                              AS "lifeCycle",
              i.BAKING_TIME                             AS "bakingTime",
              i.MSL_LEVEL                               AS "mslLevel",
              i.SUPPLIER_CODE                           AS "supplierCode",
              m.MIN_TEMP_VALUE                          AS "minTempValue",
              m.MAX_TEMP_VALUE                          AS "maxTempValue",
              m.STD_TEMP_VALUE                          AS "stdTempValue",
              b.ENTER_BY                                AS "enterBy",
              TO_CHAR(b.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')           AS "enterDate",
              b.LAST_MODIFY_BY                          AS "lastModifyBy",
              TO_CHAR(b.LAST_MODIFY_DATE, 'YYYY-MM-DD HH24:MI:SS')     AS "lastModifyDate"
         FROM IM_ITEM_BAKING_MASTER b
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = b.ITEM_CODE
         LEFT JOIN IMCN_MACHINE m
                ON m.MACHINE_CODE = b.CHAMBER_CODE
        WHERE ${STILL_IN_CHAMBER}
          AND b.ITEM_CODE = :itemCode
          AND b.CHAMBER_CODE = :chamberCode
          AND b.CHAMBER_TYPE = :chamberType
          AND b.ORGANIZATION_ID = :organizationId
        ORDER BY b.INPUT_SCAN_DATE, b.ITEM_BARCODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        itemCode: query.itemCode,
        chamberCode: query.chamberCode,
        chamberType: query.chamberType,
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }
}
