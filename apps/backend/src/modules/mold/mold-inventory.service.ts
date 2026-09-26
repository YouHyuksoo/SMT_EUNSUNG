/**
 * @file src/modules/mold/mold-inventory.service.ts
 * @description S-PARTS 재고 — PB w_mcn_mold_inventory_master 이식
 *
 * 초보자 가이드:
 * 1. 재고 1행의 키는 **S-PARTS 코드 + 버전 + SET번호**다. 같은 코드에 여러 행이 있다.
 * 2. **PB 는 재고에서 MOLD_CODE = '*' 인 행을 뺀다.** '*' 는 기준정보의 전체행 표식이라
 *    실물 재고가 아니다. 그 조건을 유지한다.
 * 3. 하단 두 탭은 선택 행 기준이다 —
 *    출고이력은 PB 가 **최근 30일**로 못박아 놨고(`issue_date >= sysdate - 30`),
 *    청구목록은 미처리(`REQUEST_STATUS = 'R'`)만 본다. 둘 다 그대로 옮겼다.
 */
import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { MoldInventoryDetailQueryDto, MoldInventoryQueryDto } from './mold-inventory.dto';

type OracleRow = Record<string, unknown>;

@Injectable()
export class MoldInventoryService {
  constructor(private readonly dataSource: DataSource) {}

  private like(value?: string): string {
    return `${(value ?? '').trim()}%`;
  }

  /** 재고 목록 — PB d_mcn_mold_inventory_lst */
  async find(query: MoldInventoryQueryDto, organizationId: number) {
    const binds = {
      organizationId,
      moldCode: this.like(query.moldCode),
      moldUseStatus: this.like(query.moldUseStatus),
      moldGroup: this.like(query.moldGroup),
    };
    const body = `
      SELECT inv.MOLD_CODE AS "moldCode",
             m.MOLD_NAME AS "moldName", m.MOLD_SPEC AS "moldSpec",
             m.MOLD_GROUP AS "moldGroup", grp.CODE_MEAN_KOR AS "moldGroupName",
             inv.MOLD_VERSION AS "moldVersion", inv.MOLD_SET_SERIAL AS "moldSetSerial",
             inv.MOLD_VERSION_SPEC AS "moldVersionSpec",
             inv.INVENTORY_QTY AS "inventoryQty", inv.INVENTORY_PRICE AS "inventoryPrice",
             inv.INVENTORY_AMT AS "inventoryAmt",
             inv.LINE_TYPE AS "lineType", lnt.CODE_MEAN_KOR AS "lineTypeName",
             inv.MOLD_USE_STATUS AS "moldUseStatus", ust.CODE_MEAN_KOR AS "moldUseStatusName",
             inv.MOLD_IN_OUT AS "moldInOut", mio.CODE_MEAN_KOR AS "moldInOutName",
             inv.RENT_STATUS AS "rentStatus", rst.CODE_MEAN_KOR AS "rentStatusName",
             inv.MOLD_ROW_QTY AS "moldRowQty",
             inv.MOLD_USEFULL_ROW_QTY AS "moldUsefullRowQty",
             inv.MOLD_SET_QTY AS "moldSetQty",
             inv.MOLD_WAREHOUSE_CODE AS "moldWarehouseCode",
             whs.CODE_MEAN_KOR AS "moldWarehouseName",
             inv.LOCATION_CODE AS "locationCode",
             inv.MOLD_RENT_LOCATION_CODE AS "moldRentLocationCode",
             inv.BREAK_VALUE AS "breakValue", inv.ACTUAL_VALUE AS "actualValue",
             inv.APPLY_MODEL_NAME AS "applyModelName",
             inv.LINE_CODE AS "lineCode", ln.LINE_NAME AS "lineName",
             inv.WORKSTAGE_CODE AS "workstageCode", ws.WORKSTAGE_NAME AS "workstageName",
             inv.MACHINE_CODE AS "machineCode",
             inv.SUPPLIER_CODE AS "supplierCode", sup.SUPPLIER_NAME AS "supplierName",
             inv.RENT_SUPPLIER_CODE AS "rentSupplierCode",
             inv.BARCODE AS "barcode", inv.CYCLE_TIME AS "cycleTime",
             inv.LAST_RECEIPT_DATE AS "lastReceiptDate",
             inv.LAST_ISSUE_DATE AS "lastIssueDate",
             inv.LAST_ADJUST_DATE AS "lastAdjustDate",
             inv.SCRAP_WEIGHT AS "scrapWeight", inv.NET_WEIGHT AS "netWeight",
             inv.GRAND_WEIGHT AS "grandWeight",
             inv.COMMENTS AS "comments",
             m.RAW_MATERIAL AS "rawMaterial", m.PUNCH_NO AS "punchNo",
             m.MOLD_LINE_TYPE AS "moldLineType", m.ORDER_LEADTIME AS "orderLeadtime",
             m.NATION_CODE AS "nationCode", m.MOLD_UOM AS "moldUom",
             m.MOLD_TYPE AS "moldType", m.ITEM_CODE AS "itemCode",
             m.ITEM_UNIT_QTY AS "itemUnitQty", m.MACHINE_CAPACITY AS "machineCapacity",
             m.GAS_YN AS "gasYn", m.ITEM_GAS_QTY AS "itemGasQty",
             DECODE(NVL(LENGTH(inv.MOLD_IMAGE), 0), 0, 'N', 'Y') AS "moldImageExistsYn",
             inv.ENTER_BY AS "enterBy", inv.ENTER_DATE AS "enterDate",
             inv.LAST_MODIFY_BY AS "lastModifyBy", inv.LAST_MODIFY_DATE AS "lastModifyDate"
        FROM IMCN_MOLD_INVENTORY inv
        JOIN IMCN_MOLD m
          ON m.MOLD_CODE = inv.MOLD_CODE AND m.ORGANIZATION_ID = inv.ORGANIZATION_ID
        LEFT JOIN ICOM_SUPPLIER sup
               ON sup.SUPPLIER_CODE = inv.SUPPLIER_CODE
              AND sup.ORGANIZATION_ID = inv.ORGANIZATION_ID
        LEFT JOIN IP_PRODUCT_LINE ln
               ON ln.LINE_CODE = inv.LINE_CODE AND ln.ORGANIZATION_ID = inv.ORGANIZATION_ID
        LEFT JOIN IP_PRODUCT_WORKSTAGE ws
               ON ws.WORKSTAGE_CODE = inv.WORKSTAGE_CODE
              AND ws.ORGANIZATION_ID = inv.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE grp
               ON grp.CODE_TYPE = 'MOLD GROUP' AND grp.CODE_NAME = m.MOLD_GROUP
              AND grp.ORGANIZATION_ID = m.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE lnt
               ON lnt.CODE_TYPE = 'LINE TYPE' AND lnt.CODE_NAME = inv.LINE_TYPE
              AND lnt.ORGANIZATION_ID = inv.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE ust
               ON ust.CODE_TYPE = 'MOLD USE STATUS' AND ust.CODE_NAME = inv.MOLD_USE_STATUS
              AND ust.ORGANIZATION_ID = inv.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE mio
               ON mio.CODE_TYPE = 'MOLD IN OUT' AND mio.CODE_NAME = inv.MOLD_IN_OUT
              AND mio.ORGANIZATION_ID = inv.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE rst
               ON rst.CODE_TYPE = 'RENT STATUS' AND rst.CODE_NAME = inv.RENT_STATUS
              AND rst.ORGANIZATION_ID = inv.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE whs
               ON whs.CODE_TYPE = 'MOLD WAREHOUSE CODE'
              AND whs.CODE_NAME = inv.MOLD_WAREHOUSE_CODE
              AND whs.ORGANIZATION_ID = inv.ORGANIZATION_ID
       WHERE inv.MOLD_CODE LIKE :moldCode
         AND NVL(inv.MOLD_USE_STATUS, '*') LIKE :moldUseStatus
         AND NVL(m.MOLD_GROUP, '*') LIKE :moldGroup
         AND inv.MOLD_CODE <> '*'
         AND inv.ORGANIZATION_ID = :organizationId`;
    const page = query.page ?? 1;
    const limit = query.limit ?? 500;
    const totals = await this.dataSource.query(
      `SELECT COUNT(*) AS "total" FROM (${body}) source_rows`,
      { ...binds } as unknown as unknown[],
    ) as OracleRow[];
    const rows = await this.dataSource.query(
      `${body} ORDER BY "moldCode", "moldVersion", "moldSetSerial"
       OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`,
      { ...binds, offset: (page - 1) * limit, limit } as unknown as unknown[],
    ) as OracleRow[];
    return { data: rows, total: Number(totals[0]?.total ?? 0), page, limit };
  }

  /**
   * 선택 S-PARTS 의 출고이력 — PB d_mcn_mold_issue_4_inventory_lst.
   * PB 가 최근 30일로 못박아 놨다(`issue_date >= sysdate - 30`).
   */
  async findIssueHistory(query: MoldInventoryDetailQueryDto, organizationId: number) {
    return this.dataSource.query(
      `SELECT i.ISSUE_DATE AS "issueDate", i.ISSUE_SEQUENCE AS "issueSequence",
              i.MOLD_CODE AS "moldCode",
              i.MOLD_VERSION AS "moldVersion", i.MOLD_SET_SERIAL AS "moldSetSerial",
              i.ISSUE_DEFICIT AS "issueDeficit", dft.CODE_MEAN_KOR AS "issueDeficitName",
              i.ISSUE_QTY AS "issueQty", i.ISSUE_PRICE AS "issuePrice",
              i.ISSUE_AMT AS "issueAmt",
              i.ISSUE_STATUS AS "issueStatus", stt.CODE_MEAN_KOR AS "issueStatusName",
              i.MOLD_ISSUE_ACCOUNT AS "moldIssueAccount",
              acc.CODE_MEAN_KOR AS "moldIssueAccountName",
              i.WORKSTAGE_CODE AS "workstageCode", ws.WORKSTAGE_NAME AS "workstageName",
              i.LINE_CODE AS "lineCode", ln.LINE_NAME AS "lineName",
              i.MACHINE_CODE AS "machineCode",
              i.ENTER_BY AS "enterBy", i.ENTER_DATE AS "enterDate",
              i.LAST_MODIFY_BY AS "lastModifyBy", i.LAST_MODIFY_DATE AS "lastModifyDate"
         FROM IMCN_MOLD_ISSUE i
         LEFT JOIN IP_PRODUCT_WORKSTAGE ws
                ON ws.WORKSTAGE_CODE = i.WORKSTAGE_CODE
               AND ws.ORGANIZATION_ID = i.ORGANIZATION_ID
         LEFT JOIN IP_PRODUCT_LINE ln
                ON ln.LINE_CODE = i.LINE_CODE AND ln.ORGANIZATION_ID = i.ORGANIZATION_ID
         LEFT JOIN ISYS_BASECODE dft
                ON dft.CODE_TYPE = 'ISSUE DEFICIT' AND dft.CODE_NAME = i.ISSUE_DEFICIT
               AND dft.ORGANIZATION_ID = i.ORGANIZATION_ID
         LEFT JOIN ISYS_BASECODE stt
                ON stt.CODE_TYPE = 'ISSUE STATUS' AND stt.CODE_NAME = i.ISSUE_STATUS
               AND stt.ORGANIZATION_ID = i.ORGANIZATION_ID
         LEFT JOIN ISYS_BASECODE acc
                ON acc.CODE_TYPE = 'MOLD ISSUE ACCOUNT'
               AND acc.CODE_NAME = i.MOLD_ISSUE_ACCOUNT
               AND acc.ORGANIZATION_ID = i.ORGANIZATION_ID
        WHERE i.MOLD_CODE = :moldCode
          AND i.ISSUE_DATE >= SYSDATE - 30
          AND i.ORGANIZATION_ID = :organizationId
        ORDER BY i.ISSUE_DATE DESC, i.ISSUE_SEQUENCE DESC`,
      { moldCode: query.moldCode, organizationId } as unknown as unknown[],
    ) as Promise<OracleRow[]>;
  }

  /**
   * 선택 S-PARTS 의 청구목록 — PB d_mcn_mold_request_lst.
   * PB 는 미처리(`REQUEST_STATUS = 'R'`)만 본다.
   */
  async findRequests(query: MoldInventoryDetailQueryDto, organizationId: number) {
    return this.dataSource.query(
      `SELECT r.MOLD_CODE AS "moldCode",
              r.MOLD_VERSION AS "moldVersion", r.MOLD_SET_SERIAL AS "moldSetSerial",
              r.REQUEST_DATE AS "requestDate", r.REQUEST_SEQUENCE AS "requestSequence",
              r.REQUEST_QTY AS "requestQty",
              r.REQUEST_STATUS AS "requestStatus", stt.CODE_MEAN_KOR AS "requestStatusName",
              r.ISSUE_DATE AS "issueDate", r.ISSUE_SEQUENCE AS "issueSequence",
              r.ISSUE_QTY AS "issueQty",
              r.ENTER_BY AS "enterBy", r.ENTER_DATE AS "enterDate",
              r.LAST_MODIFY_BY AS "lastModifyBy", r.LAST_MODIFY_DATE AS "lastModifyDate"
         FROM IMCN_MOLD_REQUEST r
         LEFT JOIN ISYS_BASECODE stt
                ON stt.CODE_TYPE = 'REQUEST STATUS' AND stt.CODE_NAME = r.REQUEST_STATUS
               AND stt.ORGANIZATION_ID = r.ORGANIZATION_ID
        WHERE r.MOLD_CODE = :moldCode
          AND r.REQUEST_STATUS = 'R'
          AND r.ORGANIZATION_ID = :organizationId
        ORDER BY r.REQUEST_DATE DESC, r.REQUEST_SEQUENCE DESC`,
      { moldCode: query.moldCode, organizationId } as unknown as unknown[],
    ) as Promise<OracleRow[]>;
  }
}
