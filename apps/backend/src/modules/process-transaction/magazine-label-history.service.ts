import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { MagazineLabelHistoryQueryDto } from './magazine-label-history.dto';

type OracleRow = Record<string, unknown>;

@Injectable()
export class MagazineLabelHistoryService {
  constructor(private readonly dataSource: DataSource) {}

  async find(query: MagazineLabelHistoryQueryDto, organizationId: number) {
    const viewMode = query.viewMode ?? 'history';
    const binds = {
      organizationId,
      lineCode: this.like(query.lineCode),
      workstageCode: this.like(query.workstageCode),
      modelName: this.like(query.modelName),
      magazineLabelNo: this.like(query.magazineLabelNo),
      runNo: this.like(query.runNo),
      dateFrom: query.dateFrom ?? '1900-01-01',
      dateTo: query.dateTo ?? '2999-12-31',
    };
    const from = `
      FROM IP_PRODUCT_RUN_CARD_IO io
      -- PB 는 DDDW(vd_line_code/vd_workstage_code)로 코드 대신 이름을 보여준다.
      -- 코드+조직이 유일해 조인으로 행이 늘지 않는다. 근거: docs/database/pb-dddw-inventory.md
      LEFT JOIN IP_PRODUCT_LINE ln
             ON ln.LINE_CODE = io.LINE_CODE AND ln.ORGANIZATION_ID = io.ORGANIZATION_ID
      LEFT JOIN IP_PRODUCT_WORKSTAGE ws
             ON ws.WORKSTAGE_CODE = io.WORKSTAGE_CODE AND ws.ORGANIZATION_ID = io.ORGANIZATION_ID
      WHERE io.LINE_CODE LIKE :lineCode
        AND io.WORKSTAGE_CODE LIKE :workstageCode
        AND io.MODEL_NAME LIKE :modelName
        AND io.MAGAZINE_LABEL_NO LIKE :magazineLabelNo
        AND io.RECEIPT_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
        AND io.RECEIPT_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
        AND io.RUN_NO LIKE :runNo
        AND io.ORGANIZATION_ID = :organizationId`;
    const body = viewMode === 'history' ? this.historySql(from) : viewMode === 'summary' ? this.summarySql(from) : this.matrixSql(from);
    const orderBy = viewMode === 'history'
      ? 'ORDER BY "modelName", "modelSuffix", "magazineLabelNo", "receiptDate", "receiptSequence"'
      : viewMode === 'summary'
        ? 'ORDER BY "receiptDate", "modelName"'
        : 'ORDER BY "lineCode", "runNo", "modelName", "pcbItem", "receiptDate", "magazineLabelType"';
    const countSql = `SELECT COUNT(*) AS "total" FROM (${body}) source_rows`;
    const totals = await this.dataSource.query(countSql, { ...binds } as unknown as unknown[]) as OracleRow[];
    const offset = ((query.page ?? 1) - 1) * (query.limit ?? 500);
    const rows = await this.dataSource.query(
      `${body} ${orderBy} OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`,
      { ...binds, offset, limit: query.limit ?? 500 } as unknown as unknown[],
    ) as OracleRow[];
    return { data: rows, total: Number(totals[0]?.total ?? 0), page: query.page ?? 1, limit: query.limit ?? 500 };
  }

  private historySql(from: string) {
    return `SELECT io.MAGAZINE_LABEL_TYPE AS "magazineLabelType", io.RUN_NO AS "runNo",
      io.MAGAZINE_LABEL_NO AS "magazineLabelNo", io.ENTER_DATE AS "enterDate",
      io.LINE_CODE AS "lineCode", ln.LINE_NAME AS "lineName",
      io.WORKSTAGE_CODE AS "workstageCode", ws.WORKSTAGE_NAME AS "workstageName",
      io.RECEIPT_DATE AS "receiptDate", io.MODEL_NAME AS "modelName",
      io.MODEL_SUFFIX AS "modelSuffix", io.ITEM_CODE AS "itemCode", io.PCB_ITEM AS "pcbItem",
      io.LOT_QTY AS "lotQty", io.BAD_QTY AS "badQty",
      io.TRANSFER_MAGAZINE_LABEL_NO AS "transferMagazineLabelNo",
      io.RECEIPT_SEQUENCE AS "receiptSequence", io.ORGANIZATION_ID AS "organizationId"
      ${from}`;
  }

  private summarySql(from: string) {
    return `SELECT io.MAGAZINE_LABEL_TYPE AS "magazineLabelType", io.RUN_NO AS "runNo",
      io.LINE_CODE AS "lineCode", ln.LINE_NAME AS "lineName",
      io.WORKSTAGE_CODE AS "workstageCode", ws.WORKSTAGE_NAME AS "workstageName",
      TRUNC(io.RECEIPT_DATE) AS "receiptDate", io.MODEL_NAME AS "modelName",
      io.ITEM_CODE AS "itemCode", io.PCB_ITEM AS "pcbItem", SUM(io.LOT_QTY) AS "lotQty",
      io.ORGANIZATION_ID AS "organizationId"
      ${from}
      GROUP BY io.MAGAZINE_LABEL_TYPE, io.RUN_NO, io.LINE_CODE, ln.LINE_NAME,
        io.WORKSTAGE_CODE, ws.WORKSTAGE_NAME,
        TRUNC(io.RECEIPT_DATE), io.MODEL_NAME, io.ITEM_CODE, io.PCB_ITEM, io.ORGANIZATION_ID`;
  }

  private matrixSql(from: string) {
    return `SELECT io.LINE_CODE AS "lineCode", ln.LINE_NAME AS "lineName", io.RUN_NO AS "runNo", io.MODEL_NAME AS "modelName",
      io.PCB_ITEM AS "pcbItem", TRUNC(io.RECEIPT_DATE) AS "receiptDate",
      io.MAGAZINE_LABEL_TYPE AS "magazineLabelType", SUM(io.LOT_QTY) AS "lotQty"
      ${from}
      GROUP BY io.LINE_CODE, ln.LINE_NAME, io.RUN_NO, io.MODEL_NAME, io.PCB_ITEM,
        TRUNC(io.RECEIPT_DATE), io.MAGAZINE_LABEL_TYPE`;
  }

  private like(value?: string) {
    const trimmed = value?.trim();
    return trimmed ? `${trimmed}%` : '%';
  }
}
