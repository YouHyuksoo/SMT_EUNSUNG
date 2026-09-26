/**
 * @file src/modules/quality/services/inventory-hold.service.ts
 * @description 재고통제관리 + OQC 검사이력관리(PID·LOT) —
 *              PB w_qc_inventory_hold_master · w_qc_oqc_inspect_history_master ·
 *              w_qc_oqc_inspect_history_4_lot_master 이식
 *
 * 초보자 가이드:
 * 1. **재고통제는 별도 테이블에 행을 만드는 것이다** — `IM_ITEM_INVENTORY_HOLD`.
 *    통제하면 행을 만들고 해제하면 지운다. 재고 자체(IM_ITEM_INVENTORY)는 건드리지 않는다.
 *    키는 자재LOT(MATERIAL_MFS) + 품목코드 + ORGANIZATION_ID 다.
 * 2. **`IM_ITEM_INVENTORY` 는 180만 행이다.** 인덱스는 ITEM_CODE · MATERIAL_MFS 뿐이라
 *    통제 대상 조회는 둘 중 하나를 요구한다.
 * 3. **OQC 는 두 화면이 서로 다른 테이블을 본다.**
 *    - PID 단위: `IQ_OQC_INSPECT_HISTORY` (0행)
 *    - LOT 단위: `IP_PRODUCT_PACK_MASTER` (59만 행) 의 매거진 포장 건
 *      PB 조건 유지 — PACK_TYPE='M' AND DIVIDE_FLAG='N'.
 * 4. OQC 항번은 SEQ_QC_OQC_INSPECT_NO 로 채번한다 (이 DB 에 있는 시퀀스다).
 */
import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { TransactionService } from '../../../shared/transaction.service';
import {
  INVENTORY_HOLD_REQUIRED_FILTERS,
  InventoryHoldApplyDto,
  InventoryHoldListQueryDto,
  InventoryHoldReleaseDto,
  InventoryHoldTargetQueryDto,
  OqcHistoryCreateDto,
  OqcHistoryKeyDto,
  OqcHistoryQueryDto,
  OqcLotQueryDto,
} from '../dto/inventory-hold.dto';

type OracleRow = Record<string, unknown>;

/** OQC 등록·수정에서 사용자가 값을 넣는 컬럼 */
const OQC_EDITABLE: Array<[column: string, field: keyof OqcHistoryCreateDto]> = [
  ['MODEL_NAME', 'modelName'], ['MODEL_SUFFIX', 'modelSuffix'], ['ITEM_CODE', 'itemCode'],
  ['DEFECT_CODE', 'defectCode'], ['INSPECT_TYPE', 'inspectType'],
  ['INSPECT_RESULT', 'inspectResult'], ['BAD_REASON_CODE', 'badReasonCode'],
  ['BAD_REASON_DIVISION', 'badReasonDivision'], ['BAD_REASON_RESULT', 'badReasonResult'],
  ['INSPECTOR', 'inspector'], ['INSPECTOR_NAME', 'inspectorName'],
  ['COMMENTS', 'comments'],
  ['INSPECT_QTY', 'inspectQty'], ['DEFECT_QTY', 'defectQty'],
];

@Injectable()
export class InventoryHoldService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  private like(value?: string): string {
    return `${(value ?? '').trim()}%`;
  }

  /**
   * 통제 대상 재고 — PB d_mat_item_inventory_hold_lst.
   * 품목코드 또는 자재LOT 중 하나가 없으면 400 으로 막는다 (180만 행 테이블).
   * 이미 통제된 LOT 인지도 같이 내려 화면이 중복 통제를 막을 수 있게 한다.
   */
  async findTargets(query: InventoryHoldTargetQueryDto, organizationId: number) {
    const given = INVENTORY_HOLD_REQUIRED_FILTERS.filter(
      (key) => (query[key] ?? '').trim() !== '',
    );
    if (given.length === 0) {
      throw new BadRequestException(
        '품목코드 또는 자재LOT 중 하나를 입력하세요. 자재재고는 180만 행이라 '
        + '이 조건 없이는 조회할 수 없습니다.',
      );
    }
    const binds: OracleRow = { organizationId };
    const indexed: string[] = [];
    if ((query.itemCode ?? '').trim()) {
      indexed.push('v.ITEM_CODE LIKE :itemCode');
      binds.itemCode = this.like(query.itemCode);
    }
    if ((query.materialMfs ?? '').trim()) {
      indexed.push('v.MATERIAL_MFS LIKE :materialMfs');
      binds.materialMfs = this.like(query.materialMfs);
    }
    const body = `
      SELECT v.MATERIAL_MFS AS "materialMfs", v.ITEM_CODE AS "itemCode",
             i.ITEM_NAME AS "itemName", i.ITEM_SPEC AS "itemSpec",
             i.ITEM_UOM AS "itemUom",
             v.LOCATION_CODE AS "locationCode", v.LINE_TYPE AS "lineType",
             v.INVENTORY_QTY AS "inventoryQty",
             h.INVENTORY_STATUS AS "holdStatus", ist.CODE_MEAN_KOR AS "holdStatusName",
             h.HOLDING_DATE AS "holdingDate", h.COMMENTS AS "holdComments",
             CASE WHEN h.MATERIAL_MFS IS NULL THEN 'N' ELSE 'Y' END AS "heldYn"
        FROM IM_ITEM_INVENTORY v
        LEFT JOIN ID_ITEM i
               ON i.ITEM_CODE = v.ITEM_CODE AND i.ORGANIZATION_ID = v.ORGANIZATION_ID
              AND i.DATESET <= TRUNC(SYSDATE) AND i.DATEEND >= TRUNC(SYSDATE)
        LEFT JOIN IM_ITEM_INVENTORY_HOLD h
               ON h.MATERIAL_MFS = v.MATERIAL_MFS AND h.ITEM_CODE = v.ITEM_CODE
              AND h.ORGANIZATION_ID = v.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE ist
               ON ist.CODE_TYPE = 'INVENTORY STATUS' AND ist.CODE_NAME = h.INVENTORY_STATUS
              AND ist.ORGANIZATION_ID = v.ORGANIZATION_ID
       WHERE ${indexed.join('\n         AND ')}
         AND NVL(v.INVENTORY_QTY, 0) > 0
         AND v.ORGANIZATION_ID = :organizationId`;
    const page = query.page ?? 1;
    const limit = query.limit ?? 500;
    const totals = await this.dataSource.query(
      `SELECT COUNT(*) AS "total" FROM (${body}) source_rows`,
      { ...binds } as unknown as unknown[],
    ) as OracleRow[];
    const rows = await this.dataSource.query(
      `${body} ORDER BY "itemCode", "materialMfs"
       OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`,
      { ...binds, offset: (page - 1) * limit, limit } as unknown as unknown[],
    ) as OracleRow[];
    return { data: rows, total: Number(totals[0]?.total ?? 0), page, limit };
  }

  /** 통제된 LOT 목록 — PB d_mat_inventory_4_lot_blocking */
  async findHolds(query: InventoryHoldListQueryDto, organizationId: number) {
    const binds = {
      organizationId,
      itemCode: this.like(query.itemCode),
      materialMfs: this.like(query.materialMfs),
      inventoryStatus: this.like(query.inventoryStatus),
    };
    const body = `
      SELECT h.MATERIAL_MFS AS "materialMfs", h.ITEM_CODE AS "itemCode",
             i.ITEM_NAME AS "itemName", i.ITEM_SPEC AS "itemSpec",
             h.INVENTORY_STATUS AS "inventoryStatus", ist.CODE_MEAN_KOR AS "inventoryStatusName",
             h.HOLDING_DATE AS "holdingDate", h.COMMENTS AS "comments",
             h.ENTER_BY AS "enterBy", h.ENTER_DATE AS "enterDate",
             h.LAST_MODIFY_BY AS "lastModifyBy", h.LAST_MODIFY_DATE AS "lastModifyDate"
        FROM IM_ITEM_INVENTORY_HOLD h
        LEFT JOIN ID_ITEM i
               ON i.ITEM_CODE = h.ITEM_CODE AND i.ORGANIZATION_ID = h.ORGANIZATION_ID
              AND i.DATESET <= TRUNC(SYSDATE) AND i.DATEEND >= TRUNC(SYSDATE)
        LEFT JOIN ISYS_BASECODE ist
               ON ist.CODE_TYPE = 'INVENTORY STATUS' AND ist.CODE_NAME = h.INVENTORY_STATUS
              AND ist.ORGANIZATION_ID = h.ORGANIZATION_ID
       WHERE NVL(h.ITEM_CODE, '*') LIKE :itemCode
         AND NVL(h.MATERIAL_MFS, '*') LIKE :materialMfs
         AND NVL(h.INVENTORY_STATUS, '*') LIKE :inventoryStatus
         AND h.ORGANIZATION_ID = :organizationId`;
    const page = query.page ?? 1;
    const limit = query.limit ?? 500;
    const totals = await this.dataSource.query(
      `SELECT COUNT(*) AS "total" FROM (${body}) source_rows`,
      { ...binds } as unknown as unknown[],
    ) as OracleRow[];
    const rows = await this.dataSource.query(
      `${body} ORDER BY "holdingDate" DESC, "itemCode", "materialMfs"
       OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`,
      { ...binds, offset: (page - 1) * limit, limit } as unknown as unknown[],
    ) as OracleRow[];
    return { data: rows, total: Number(totals[0]?.total ?? 0), page, limit };
  }

  /** 통제 등록 — 이미 통제된 LOT 은 상태·설명만 갱신한다 (중복 행을 만들지 않는다) */
  async applyHold(dto: InventoryHoldApplyDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      let applied = 0;
      for (const { itemCode, materialMfs } of dto.materialMfsList) {
        await qr.query(
          `MERGE INTO IM_ITEM_INVENTORY_HOLD h
           USING (SELECT :itemCode AS ITEM_CODE, :materialMfs AS MATERIAL_MFS,
                         :organizationId AS ORGANIZATION_ID FROM DUAL) src
              ON (h.ITEM_CODE = src.ITEM_CODE AND h.MATERIAL_MFS = src.MATERIAL_MFS
                  AND h.ORGANIZATION_ID = src.ORGANIZATION_ID)
            WHEN MATCHED THEN UPDATE SET
                 h.INVENTORY_STATUS = :inventoryStatus,
                 h.COMMENTS         = :comments,
                 h.LAST_MODIFY_BY   = :userId,
                 h.LAST_MODIFY_DATE = SYSDATE
            WHEN NOT MATCHED THEN INSERT (
                 MATERIAL_MFS, ITEM_CODE, ORGANIZATION_ID, INVENTORY_STATUS,
                 COMMENTS, HOLDING_DATE,
                 ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE
               ) VALUES (
                 :materialMfs, :itemCode, :organizationId, :inventoryStatus,
                 :comments, SYSDATE,
                 :userId, SYSDATE, :userId, SYSDATE
               )`,
          {
            itemCode, materialMfs, organizationId,
            inventoryStatus: dto.inventoryStatus,
            comments: dto.comments ?? null,
            userId,
          } as unknown as unknown[],
        );
        applied += 1;
      }
      return { applied };
    });
  }

  /** 통제 해제 — 행을 지운다 (PB 와 같다) */
  async releaseHold(dto: InventoryHoldReleaseDto, organizationId: number) {
    return this.tx.run(async (qr) => {
      let released = 0;
      for (const { itemCode, materialMfs } of dto.materialMfsList) {
        await qr.query(
          `DELETE FROM IM_ITEM_INVENTORY_HOLD
            WHERE ITEM_CODE = :itemCode AND MATERIAL_MFS = :materialMfs
              AND ORGANIZATION_ID = :organizationId`,
          { itemCode, materialMfs, organizationId } as unknown as unknown[],
        );
        const check = await qr.query(
          `SELECT COUNT(*) AS "cnt" FROM IM_ITEM_INVENTORY_HOLD
            WHERE ITEM_CODE = :itemCode AND MATERIAL_MFS = :materialMfs
              AND ORGANIZATION_ID = :organizationId`,
          { itemCode, materialMfs, organizationId } as unknown as unknown[],
        ) as OracleRow[];
        released += Number(check[0]?.cnt ?? 0) === 0 ? 1 : 0;
      }
      return { released };
    });
  }

  /** OQC 검사이력 (PID) — PB d_iq_oqc_insepct_history */
  async findOqcHistory(query: OqcHistoryQueryDto, organizationId: number) {
    const binds = {
      organizationId,
      dateFrom: query.dateFrom.slice(0, 10),
      dateTo: query.dateTo.slice(0, 10),
      productId: this.like(query.productId),
      modelName: this.like(query.modelName),
      itemCode: this.like(query.itemCode),
      inspectResult: this.like(query.inspectResult),
    };
    const body = `
      SELECT o.INSPECT_DATE AS "inspectDate", o.INSPECT_SEQUENCE AS "inspectSequence",
             -- 삭제가 쓰는 불투명 키. DATE 를 ISO 로 왕복시키면 시간대가 밀린다.
             TO_CHAR(o.INSPECT_DATE, 'YYYYMMDDHH24MISS') AS "inspectDateKey",
             o.PRODUCT_ID AS "productId",
             o.MODEL_NAME AS "modelName", o.MODEL_SUFFIX AS "modelSuffix",
             o.ITEM_CODE AS "itemCode", i.ITEM_NAME AS "itemName",
             o.DEFECT_CODE AS "defectCode", o.INSPECT_TYPE AS "inspectType",
             o.INSPECT_RESULT AS "inspectResult", res.CODE_MEAN_KOR AS "inspectResultName",
             o.BAD_REASON_CODE AS "badReasonCode", bad.CODE_MEAN_KOR AS "badReasonName",
             o.BAD_REASON_DIVISION AS "badReasonDivision",
             o.BAD_REASON_RESULT AS "badReasonResult",
             o.INSPECT_QTY AS "inspectQty", o.DEFECT_QTY AS "defectQty",
             o.INSPECTOR AS "inspector", o.INSPECTOR_NAME AS "inspectorName",
             o.COMMENTS AS "comments",
             o.ENTER_BY AS "enterBy", o.ENTER_DATE AS "enterDate",
             o.LAST_MODIFY_BY AS "lastModifyBy", o.LAST_MODIFY_DATE AS "lastModifyDate"
        FROM IQ_OQC_INSPECT_HISTORY o
        LEFT JOIN ID_ITEM i
               ON i.ITEM_CODE = o.ITEM_CODE AND i.ORGANIZATION_ID = o.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE res
               ON res.CODE_TYPE = 'INSPECT RESULT' AND res.CODE_NAME = o.INSPECT_RESULT
              AND res.ORGANIZATION_ID = o.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE bad
               ON bad.CODE_TYPE = 'BAD REASON CODE' AND bad.CODE_NAME = o.BAD_REASON_CODE
              AND bad.ORGANIZATION_ID = o.ORGANIZATION_ID
       WHERE o.INSPECT_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
         AND o.INSPECT_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
         AND NVL(o.PRODUCT_ID, '*') LIKE :productId
         AND NVL(o.MODEL_NAME, '*') LIKE :modelName
         AND NVL(o.ITEM_CODE, '*') LIKE :itemCode
         AND NVL(o.INSPECT_RESULT, '*') LIKE :inspectResult
         AND o.ORGANIZATION_ID = :organizationId`;
    const page = query.page ?? 1;
    const limit = query.limit ?? 500;
    const totals = await this.dataSource.query(
      `SELECT COUNT(*) AS "total" FROM (${body}) source_rows`,
      { ...binds } as unknown as unknown[],
    ) as OracleRow[];
    const rows = await this.dataSource.query(
      `${body} ORDER BY "inspectDate" DESC, "inspectSequence" DESC
       OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`,
      { ...binds, offset: (page - 1) * limit, limit } as unknown as unknown[],
    ) as OracleRow[];
    return { data: rows, total: Number(totals[0]?.total ?? 0), page, limit };
  }

  /**
   * OQC 검사대상 (LOT) — PB d_prd_cell_biz_pack_4_oqc_master.
   * PB 조건 유지: 매거진 포장(PACK_TYPE='M') 이면서 분할되지 않은 것(DIVIDE_FLAG='N').
   */
  async findOqcLots(query: OqcLotQueryDto, organizationId: number) {
    const binds = {
      organizationId,
      dateFrom: query.dateFrom.slice(0, 10),
      dateTo: query.dateTo.slice(0, 10),
      packBarcode: this.like(query.packBarcode),
      modelName: this.like(query.modelName),
    };
    const body = `
      SELECT p.PACK_BARCODE AS "packBarcode", p.PACK_TYPE AS "packType",
             pt.CODE_MEAN_KOR AS "packTypeName",
             p.MODEL_NAME AS "modelName", p.MODEL_SUFFIX AS "modelSuffix",
             p.PART_NO AS "partNo", p.RUN_NO AS "runNo",
             p.LINE_CODE AS "lineCode", ln.LINE_NAME AS "lineName",
             p.WORKSTAGE_CODE AS "workstageCode", ws.WORKSTAGE_NAME AS "workstageName",
             p.PACK_DATE AS "packDate",
             p.PACKING_PCS_QTY AS "packingPcsQty", p.PACK_QTY AS "packQty",
             p.COMPLETE_FLAG AS "completeFlag", p.PRINT_FLAG AS "printFlag",
             p.BOXING_FLAG AS "boxingFlag", p.PALLET_FLAG AS "palletFlag",
             p.SHIP_FLAG AS "shipFlag", p.RECEIPT_FLAG AS "receiptFlag",
             p.BOX_NO AS "boxNo", p.PALLET_NO AS "palletNo",
             p.SHIP_NO AS "shipNo", p.RECEIPT_NO AS "receiptNo",
             p.BOXING_DATE AS "boxingDate", p.PALLET_DATE AS "palletDate",
             p.SHIP_DATE AS "shipDate", p.RECEIPT_DATE AS "receiptDate",
             p.CUSTOMER_CODE AS "customerCode",
             p.ENTER_BY AS "enterBy", p.ENTER_DATE AS "enterDate"
        FROM IP_PRODUCT_PACK_MASTER p
        LEFT JOIN IP_PRODUCT_LINE ln
               ON ln.LINE_CODE = p.LINE_CODE AND ln.ORGANIZATION_ID = p.ORGANIZATION_ID
        LEFT JOIN IP_PRODUCT_WORKSTAGE ws
               ON ws.WORKSTAGE_CODE = p.WORKSTAGE_CODE
              AND ws.ORGANIZATION_ID = p.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE pt
               ON pt.CODE_TYPE = 'PACK TYPE' AND pt.CODE_NAME = p.PACK_TYPE
              AND pt.ORGANIZATION_ID = p.ORGANIZATION_ID
       WHERE p.PACK_BARCODE LIKE :packBarcode
         AND NVL(p.MODEL_NAME, '*') LIKE :modelName
         AND p.PACK_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
         AND p.PACK_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
         AND p.DIVIDE_FLAG = 'N'
         AND p.PACK_TYPE = 'M'
         AND p.ORGANIZATION_ID = :organizationId`;
    const page = query.page ?? 1;
    const limit = query.limit ?? 500;
    const totals = await this.dataSource.query(
      `SELECT COUNT(*) AS "total" FROM (${body}) source_rows`,
      { ...binds } as unknown as unknown[],
    ) as OracleRow[];
    const rows = await this.dataSource.query(
      `${body} ORDER BY "packDate" DESC, "packBarcode"
       OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`,
      { ...binds, offset: (page - 1) * limit, limit } as unknown as unknown[],
    ) as OracleRow[];
    return { data: rows, total: Number(totals[0]?.total ?? 0), page, limit };
  }

  /** OQC 검사이력 등록 — 항번은 SEQ_QC_OQC_INSPECT_NO 로 채번한다 */
  async createOqc(dto: OqcHistoryCreateDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      const seq = await qr.query(
        `SELECT SEQ_QC_OQC_INSPECT_NO.NEXTVAL AS "seq" FROM DUAL`, [],
      ) as OracleRow[];
      const inspectSequence = Number(seq[0]?.seq ?? 0);

      const columns = ['INSPECT_DATE', 'INSPECT_SEQUENCE', 'ORGANIZATION_ID', 'PRODUCT_ID'];
      const values = ['SYSDATE', ':inspectSequence', ':organizationId', ':productId'];
      const binds: OracleRow = {
        inspectSequence, organizationId, productId: dto.productId, userId,
      };
      for (const [column, field] of OQC_EDITABLE) {
        columns.push(column);
        values.push(`:${field}`);
        binds[field] = dto[field] ?? null;
      }
      columns.push('ENTER_BY', 'ENTER_DATE', 'LAST_MODIFY_BY', 'LAST_MODIFY_DATE');
      values.push(':userId', 'SYSDATE', ':userId', 'SYSDATE');

      await qr.query(
        `INSERT INTO IQ_OQC_INSPECT_HISTORY (${columns.join(', ')})
         VALUES (${values.join(', ')})`,
        binds as unknown as unknown[],
      );
      return { inspectSequence };
    });
  }

  /** OQC 검사이력 삭제 */
  async removeOqc(dto: OqcHistoryKeyDto, organizationId: number) {
    const rows = await this.dataSource.query(
      `SELECT COUNT(*) AS "cnt" FROM IQ_OQC_INSPECT_HISTORY
        WHERE TO_CHAR(INSPECT_DATE, 'YYYYMMDDHH24MISS') = :inspectDateKey
          AND INSPECT_SEQUENCE = :inspectSequence
          AND ORGANIZATION_ID = :organizationId`,
      {
        inspectDateKey: dto.inspectDateKey,
        inspectSequence: dto.inspectSequence,
        organizationId,
      } as unknown as unknown[],
    ) as OracleRow[];
    if (Number(rows[0]?.cnt ?? 0) === 0) {
      throw new NotFoundException('OQC 검사이력을 찾을 수 없습니다.');
    }
    await this.dataSource.query(
      `DELETE FROM IQ_OQC_INSPECT_HISTORY
        WHERE TO_CHAR(INSPECT_DATE, 'YYYYMMDDHH24MISS') = :inspectDateKey
          AND INSPECT_SEQUENCE = :inspectSequence
          AND ORGANIZATION_ID = :organizationId`,
      {
        inspectDateKey: dto.inspectDateKey,
        inspectSequence: dto.inspectSequence,
        organizationId,
      } as unknown as unknown[],
    );
    return { deleted: true };
  }
}
