/**
 * @file src/modules/smt/smt-nc.service.ts
 * @description SMT 피더레이아웃 등록 — PB w_smt_upload_nc_master 이식 (부분)
 *
 * 초보자 가이드:
 * 1. **이관 범위**: 이미 적재된 마운터 배치표(IB_MNT_PLANDATA)를 조회하고,
 *    중복을 찾고, SMT BOM 과 대조한다.
 * 2. **이관 범위 밖 — 벤더별 NC 파일 파싱.** PB 원본 3,322줄의 대부분이
 *    Yamaha·NPM·LG 마운터가 뱉는 텍스트/CSV 를 FileOpen/FileReadEx 로 한 줄씩
 *    끊어 읽는 코드다 (d_yamaha_csv, d_positiondata_npm, d_blockdata, d_stepinfor,
 *    d_stockdata, d_partlist, d_positiondata, d_plandata). 포맷 샘플 파일이 없어
 *    옮겨도 맞는지 확인할 방법이 없으므로 제외했다. 현재 적재는 PB 화면으로 한다.
 * 3. **중복검증이 왜 따로 있나**: IB_MNT_PLANDATA 에는 유일제약이 없다
 *    (인덱스 INDX_PLANDATA2 는 비유일). NC 파일을 두 번 올리면 같은 자리가
 *    두 줄이 되고, 그러면 피더 대조 수량이 부풀어 배포가 틀린다.
 * 4. **대조는 PKG_DESIGN.BOM_QUERY 로 전개한 BOM 과 맞춰 본다.**
 *    PB d_smt_feeder_bom_compare_lst 와 같은 UNION ALL 구조다.
 *    읽은 세션 행은 지운다 — ID_ENG_BOM_TEMP 는 이미 3,357,661행이 쌓여 있다.
 *    PKG_DESIGN 패키지 본문에 COMMIT 이 한 줄도 없음을 확인했으므로(실측),
 *    전개·조회·정리가 tx.run 의 한 트랜잭션 안에 있다 — 중간에 실패하면 전개행도
 *    함께 롤백된다.
 */
import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { TransactionService } from '../../shared/transaction.service';
import { SmtNcCompareQueryDto, SmtNcQueryDto } from './smt-nc.dto';
import { namedBinds } from '../../common/utils/named-binds.util';

@Injectable()
export class SmtNcService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  private like(value?: string): string {
    return `${(value ?? '').trim()}%`;
  }

  /** 적재된 마운터 배치표 조회 — PB dw_plandata 계열이 채우는 표. */
  async find(query: SmtNcQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT p.LINE_CODE AS "lineCode", p.MACHINE_CODE AS "machineCode",
              p.MACHINE_GROUP AS "machineGroup",
              p.MODEL_NAME AS "modelName", p.LOT_NAME AS "lotName",
              p.TABLE_ID AS "tableId", p.ADDRESS AS "address",
              p.POSITION AS "position", p.PARTNAME AS "partName",
              p.CHIPNAME AS "chipName", p.PCB_ITEM AS "pcbItem",
              p.ITEM_UNIT_QTY AS "itemUnitQty", p.FEEDER_TYPE AS "feederType",
              p.LOCATION_INFO AS "locationInfo", p.PLAN_DATE AS "planDate",
              i.ITEM_NAME AS "partItemName", i.ITEM_SPEC AS "partItemSpec",
              p.ENTER_BY AS "enterBy", p.ENTER_DATE AS "enterDate",
              p.LAST_MODIFY_BY AS "lastModifyBy", p.LAST_MODIFY_DATE AS "lastModifyDate"
         FROM IB_MNT_PLANDATA p
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = p.PARTNAME AND i.ORGANIZATION_ID = p.ORGANIZATION_ID
        WHERE p.ORGANIZATION_ID = :organizationId
          AND NVL(p.LINE_CODE, '*') LIKE :lineCode
          AND NVL(p.MACHINE_CODE, '*') LIKE :machineCode
          AND NVL(p.MODEL_NAME, '*') LIKE :modelName
          AND NVL(p.LOT_NAME, '*') LIKE :lotName
          AND NVL(p.TABLE_ID, '*') LIKE :tableId
        ORDER BY p.LINE_CODE, p.MACHINE_CODE, p.TABLE_ID, p.ADDRESS, p.POSITION`,
      namedBinds({
          organizationId,
          lineCode: this.like(query.lineCode),
          machineCode: this.like(query.machineCode),
          modelName: this.like(query.modelName),
          lotName: this.like(query.lotName),
          tableId: this.like(query.tableId),
        }),
    )) as Record<string, unknown>[];
    return { data: rows, total: rows.length };
  }

  /**
   * 중복검증 — PB d_plandata_4_dup_check_lst.
   *
   * PB 의 GROUP BY 를 그대로 쓴다. 조직을 조건에 추가했다 — PB 는 조직 없이
   * 전 조직을 한 덩어리로 세어 다른 조직의 같은 자리를 중복으로 잡았다.
   */
  async findDuplicates(query: SmtNcQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT COUNT(*) AS "dupCount",
              p.LINE_CODE AS "lineCode", p.MACHINE_CODE AS "machineCode",
              p.LOT_NAME AS "lotName", p.MODEL_NAME AS "modelName",
              p.TABLE_ID AS "tableId", p.ADDRESS AS "address",
              p.POSITION AS "position", p.PCB_ITEM AS "pcbItem",
              MAX(p.PARTNAME) AS "partName",
              MAX(p.LOCATION_INFO) AS "locationInfo"
         FROM IB_MNT_PLANDATA p
        WHERE p.ORGANIZATION_ID = :organizationId
          AND NVL(p.LINE_CODE, '*') LIKE :lineCode
          AND NVL(p.MACHINE_CODE, '*') LIKE :machineCode
          AND NVL(p.MODEL_NAME, '*') LIKE :modelName
        GROUP BY p.LINE_CODE, p.MACHINE_CODE, p.LOT_NAME, p.MODEL_NAME,
                 p.TABLE_ID, p.ADDRESS, p.POSITION, p.PCB_ITEM
        HAVING COUNT(*) > 1
        ORDER BY 1 DESC, 2, 3`,
      namedBinds({
          organizationId,
          lineCode: this.like(query.lineCode),
          machineCode: this.like(query.machineCode),
          modelName: this.like(query.modelName),
        }),
    )) as Record<string, unknown>[];
    return { data: rows, total: rows.length };
  }

  /**
   * 피더 ↔ BOM 대조 — PB d_smt_feeder_bom_compare_lst.
   *
   * BOM 쪽은 PKG_DESIGN.BOM_QUERY 로 전개한 세션행, 피더 쪽은 IB_MNT_PLANDATA 다.
   * 품목별로 두 쪽 수량을 나란히 놓고 차이를 낸다 — PB 는 UNION ALL 로 두 묶음을
   * 그냥 붙여 놓고 사람이 눈으로 맞췄다. 여기서는 품목 기준으로 묶어 차이를 계산한다.
   *
   * **피더 쪽은 모델로 걸르지 않는다 (라인 전체).** 묻는 것이 "이 라인이 지금
   * 이 모델을 돌릴 준비가 됐나" 이므로 라인에 실제로 물려 있는 것 전부와 맞추는 것이
   * 맞다. PB 도 같다. 단 IB_MNT_PLANDATA 에 MODEL_NAME 컬럼이 있으므로, 한 라인에
   * 두 모델의 배치가 동시에 적재되는 운영이 생기면 판정이 부풀어 오른다 —
   * 그때는 `NVL(p.MODEL_NAME,'*') LIKE :modelName` 을 추가해야 한다.
   * (현재 이 표는 14행이고 라인별 단일 모델이다.)
   */
  async compareWithBom(query: SmtNcCompareQueryDto, organizationId: number) {
    const pcbItem = query.pcbItem ? `${query.pcbItem}%` : '%';
    return this.tx.run(async (qr) => {
      const sessionRows = (await qr.query(
        `SELECT PKG_DESIGN.BOM_QUERY(:setItemCode, TRUNC(SYSDATE), :organizationId)
                  AS SESSION_ID
           FROM DUAL`,
        namedBinds({ setItemCode: query.setItemCode, organizationId }),
      )) as { SESSION_ID: number }[];
      const sessionId = Number(sessionRows?.[0]?.SESSION_ID ?? 0);
      if (sessionId <= 0) {
        return { sessionId, data: [], total: 0, diffCount: 0 };
      }

      try {
        const rows = (await qr.query(
          `SELECT itemCode AS "itemCode",
                  SUM(bomQty) AS "bomQty", SUM(feederQty) AS "feederQty",
                  SUM(bomRows) AS "bomRows", SUM(feederRows) AS "feederRows"
             FROM (
               SELECT NVL(t.CHILD_ITEM_CODE, '*') AS itemCode,
                      NVL(t.ITEM_UNIT_QTY, 0) AS bomQty, 0 AS feederQty,
                      1 AS bomRows, 0 AS feederRows
                 FROM ID_ENG_BOM_TEMP t, ID_ITEM a
                WHERE t.PARENT_ITEM_CODE = a.ITEM_CODE
                  AND a.ORGANIZATION_ID = t.ORGANIZATION_ID
                  AND t.SESSION_ID = :sessionId
                  AND t.ORGANIZATION_ID = :organizationId
                  AND NVL(a.ITEM_CLASS, '*') LIKE :pcbItem
               UNION ALL
               SELECT NVL(p.PARTNAME, '*'), 0, NVL(p.ITEM_UNIT_QTY, 0), 0, 1
                 FROM IB_MNT_PLANDATA p
                WHERE p.ORGANIZATION_ID = :organizationId
                  AND NVL(p.LINE_CODE, '*') LIKE :lineCode
                  AND NVL(p.PCB_ITEM, '*') LIKE :pcbItem
             )
            GROUP BY itemCode
            ORDER BY itemCode`,
          namedBinds({
              sessionId,
              organizationId,
              pcbItem,
              lineCode: this.like(query.lineCode),
            }),
        )) as 
          {
            itemCode: string;
            bomQty: number;
            feederQty: number;
            bomRows: number;
            feederRows: number;
          }[]
        ;

        const data = rows.map((row) => ({
          ...row,
          // 한쪽만 있으면 그 자체가 차이다. 0 과 "없음" 을 섞지 않도록 행수도 같이 내린다.
          onlyInBom: Number(row.feederRows) === 0,
          onlyInFeeder: Number(row.bomRows) === 0,
          qtyDiff: Number(row.feederQty) - Number(row.bomQty),
          diff:
            Number(row.feederRows) === 0
            || Number(row.bomRows) === 0
            || Number(row.feederQty) !== Number(row.bomQty),
        }));
        return {
          sessionId,
          data,
          total: data.length,
          diffCount: data.filter((d) => d.diff).length,
        };
      } finally {
        await qr.query(
          `DELETE FROM ID_ENG_BOM_TEMP
            WHERE SESSION_ID = :sessionId AND ORGANIZATION_ID = :organizationId`,
          namedBinds({ sessionId, organizationId }),
        );
      }
    });
  }
}
