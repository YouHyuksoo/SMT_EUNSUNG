/**
 * @file src/modules/mold/mold-master.service.ts
 * @description S-PARTS 마스터 — PB w_mcn_mold_master 이식
 *
 * 초보자 가이드:
 * 1. **S-PARTS 는 PB 소스에서 MOLD(금형)다.** 테이블 이름이 전부 IMCN_MOLD_* 다.
 *    화면 문구는 은성 메뉴를 따라 S-PARTS 로 쓴다.
 * 2. **키**: IMCN_MOLD 는 MOLD_CODE + ORGANIZATION_ID 가 유일하다.
 *    재고(IMCN_MOLD_INVENTORY)는 여기에 MOLD_VERSION + MOLD_SET_SERIAL 이 더 붙는다.
 *    그래서 마스터 목록은 재고와 **좌측 외부조인**이고, 재고행이 여러 개면 마스터가 여러 줄로 나온다.
 *    PB 도 같다 — 목록을 마스터 건수로 착각하지 않도록 재고 키를 컬럼으로 같이 내린다.
 * 3. **감사컬럼**: PB f_set_security_row 가 하던 일이다. 본문으로 받지 않고
 *    등록 시 ENTER_BY/ENTER_DATE + LAST_MODIFY_*, 수정 시 LAST_MODIFY_* 만 서버가 채운다.
 * 4. **삭제와 품목생성은 이 서비스가 아니라 DB 프로시저에 있다.**
 *    PKG_MES_MAC.SP_MOLD_DELETE_CASCADE / SP_MOLD_GENERATE_ITEM.
 *    PB 화면과 웹이 같은 오브젝트를 호출해야 결과가 갈리지 않는다.
 */
import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { TransactionService } from '../../shared/transaction.service';
import {
  MoldBillQueryDto,
  MoldCodeDto,
  MoldMasterQueryDto,
  MoldMasterUpsertDto,
} from './mold-master.dto';

type OracleRow = Record<string, unknown>;

/** 등록·수정에서 사용자가 값을 넣는 컬럼. 감사컬럼은 여기에 없다. */
const EDITABLE: Array<[column: string, field: keyof MoldMasterUpsertDto]> = [
  ['MOLD_NAME', 'moldName'], ['MOLD_GROUP', 'moldGroup'], ['MOLD_SPEC', 'moldSpec'],
  ['MOLD_UOM', 'moldUom'], ['MOLD_TYPE', 'moldType'], ['MOLD_LINE_TYPE', 'moldLineType'],
  ['DRAWING_NO', 'drawingNo'], ['RAW_MATERIAL', 'rawMaterial'], ['PUNCH_NO', 'punchNo'],
  ['NATION_CODE', 'nationCode'], ['SUPPLIER_CODE', 'supplierCode'],
  ['ITEM_CODE', 'itemCode'], ['BARCODE', 'barcode'], ['COMMENTS', 'comments'],
  ['GAS_YN', 'gasYn'], ['AUTO_RECEIPT_YN', 'autoReceiptYn'],
  ['SAFETY_INVENTORY', 'safetyInventory'], ['ORDER_LEADTIME', 'orderLeadtime'],
  ['ITEM_UNIT_QTY', 'itemUnitQty'], ['CYCLE_TIME', 'cycleTime'],
  ['MACHINE_CAPACITY', 'machineCapacity'], ['ITEM_GAS_QTY', 'itemGasQty'],
];

@Injectable()
export class MoldMasterService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  /** PB 규약: 빈 값이면 '%' 가 되어 전체를 조회한다. */
  private like(value?: string): string {
    return `${(value ?? '').trim()}%`;
  }

  /**
   * 목록 — PB d_mcn_mold_lst_tree.
   * PB 는 MOLD_GROUP 으로 한 단계 그룹핑한 트리였다. 웹은 그룹 컬럼을 앞에 두고
   * 그룹 기준으로 정렬해 같은 묶음이 붙어 보이게 한다.
   */
  async find(query: MoldMasterQueryDto, organizationId: number) {
    const binds = {
      organizationId,
      moldCode: this.like(query.moldCode),
      moldGroup: this.like(query.moldGroup),
    };
    const body = `
      SELECT m.MOLD_CODE AS "moldCode", m.MOLD_NAME AS "moldName",
             m.MOLD_GROUP AS "moldGroup", grp.CODE_MEAN_KOR AS "moldGroupName",
             m.MOLD_SPEC AS "moldSpec", m.MOLD_UOM AS "moldUom",
             m.MOLD_TYPE AS "moldType", mtp.CODE_MEAN_KOR AS "moldTypeName",
             m.MOLD_LINE_TYPE AS "moldLineType", mlt.CODE_MEAN_KOR AS "moldLineTypeName",
             m.DRAWING_NO AS "drawingNo", m.RAW_MATERIAL AS "rawMaterial",
             m.PUNCH_NO AS "punchNo", m.NATION_CODE AS "nationCode",
             m.SAFETY_INVENTORY AS "safetyInventory", m.ORDER_LEADTIME AS "orderLeadtime",
             m.ITEM_CODE AS "itemCode", m.ITEM_UNIT_QTY AS "itemUnitQty",
             m.CYCLE_TIME AS "cycleTime", m.MACHINE_CAPACITY AS "machineCapacity",
             m.GAS_YN AS "gasYn", m.ITEM_GAS_QTY AS "itemGasQty",
             m.AUTO_RECEIPT_YN AS "autoReceiptYn", m.BARCODE AS "barcode",
             m.COMMENTS AS "comments",
             m.LAST_RECEIPT_DATE AS "lastReceiptDate", m.LAST_ISSUE_DATE AS "lastIssueDate",
             m.SUPPLIER_CODE AS "supplierCode", sup.SUPPLIER_NAME AS "supplierName",
             inv.MOLD_VERSION AS "moldVersion", inv.MOLD_SET_SERIAL AS "moldSetSerial",
             inv.MOLD_ROW_QTY AS "moldRowQty",
             inv.MOLD_USEFULL_ROW_QTY AS "moldUsefullRowQty",
             inv.MOLD_USE_STATUS AS "moldUseStatus", ust.CODE_MEAN_KOR AS "moldUseStatusName",
             inv.MOLD_IN_OUT AS "moldInOut", mio.CODE_MEAN_KOR AS "moldInOutName",
             inv.MOLD_WAREHOUSE_CODE AS "moldWarehouseCode",
             whs.CODE_MEAN_KOR AS "moldWarehouseName",
             inv.LOCATION_CODE AS "locationCode", inv.BREAK_VALUE AS "breakValue",
             inv.ACTUAL_VALUE AS "actualValue", inv.MOLD_SET_QTY AS "moldSetQty",
             inv.APPLY_MODEL_NAME AS "applyModelName", inv.BARCODE AS "inventoryBarcode",
             m.ENTER_BY AS "enterBy", m.ENTER_DATE AS "enterDate",
             m.LAST_MODIFY_BY AS "lastModifyBy", m.LAST_MODIFY_DATE AS "lastModifyDate"
        FROM IMCN_MOLD m
        LEFT JOIN IMCN_MOLD_INVENTORY inv
               ON inv.MOLD_CODE = m.MOLD_CODE AND inv.ORGANIZATION_ID = m.ORGANIZATION_ID
        LEFT JOIN ICOM_SUPPLIER sup
               ON sup.SUPPLIER_CODE = m.SUPPLIER_CODE
              AND sup.ORGANIZATION_ID = m.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE grp
               ON grp.CODE_TYPE = 'MOLD GROUP' AND grp.CODE_NAME = m.MOLD_GROUP
              AND grp.ORGANIZATION_ID = m.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE mtp
               ON mtp.CODE_TYPE = 'MOLD TYPE' AND mtp.CODE_NAME = m.MOLD_TYPE
              AND mtp.ORGANIZATION_ID = m.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE mlt
               ON mlt.CODE_TYPE = 'MOLD LINE TYPE' AND mlt.CODE_NAME = m.MOLD_LINE_TYPE
              AND mlt.ORGANIZATION_ID = m.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE ust
               ON ust.CODE_TYPE = 'MOLD USE STATUS' AND ust.CODE_NAME = inv.MOLD_USE_STATUS
              AND ust.ORGANIZATION_ID = m.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE mio
               ON mio.CODE_TYPE = 'MOLD IN OUT' AND mio.CODE_NAME = inv.MOLD_IN_OUT
              AND mio.ORGANIZATION_ID = m.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE whs
               ON whs.CODE_TYPE = 'MOLD WAREHOUSE CODE'
              AND whs.CODE_NAME = inv.MOLD_WAREHOUSE_CODE
              AND whs.ORGANIZATION_ID = m.ORGANIZATION_ID
       WHERE m.MOLD_CODE LIKE :moldCode
         AND NVL(m.MOLD_GROUP, '*') LIKE :moldGroup
         AND m.ORGANIZATION_ID = :organizationId`;
    const page = query.page ?? 1;
    const limit = query.limit ?? 500;
    const totals = await this.dataSource.query(
      `SELECT COUNT(*) AS "total" FROM (${body}) source_rows`,
      { ...binds } as unknown as unknown[],
    ) as OracleRow[];
    // PB 트리 정렬: MOLD_GROUP 으로 묶고 그 안에서 코드·버전·SET번호 순
    const rows = await this.dataSource.query(
      `${body} ORDER BY "moldGroup", "moldCode", "moldVersion", "moldSetSerial"
       OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`,
      { ...binds, offset: (page - 1) * limit, limit } as unknown as unknown[],
    ) as OracleRow[];
    return { data: rows, total: Number(totals[0]?.total ?? 0), page, limit };
  }

  /**
   * BOM(소요품목) — PB d_mcn_mold_bill_lst.
   * PB 가 COMPUTE 로 붙인 F_CHECK_BOM_EXISTS 는 DB 함수라 그대로 호출한다.
   * 품목(ID_ITEM)은 오늘 유효한 행만 붙인다(PB 의 DATESET/DATEEND 조건).
   */
  async findBills(query: MoldBillQueryDto, organizationId: number) {
    return this.dataSource.query(
      `SELECT b.MOLD_CODE AS "moldCode", b.ITEM_CODE AS "itemCode",
              b.SEQUENCE AS "sequence",
              b.MOLD_VERSION AS "moldVersion", b.MOLD_SET_SERIAL AS "moldSetSerial",
              b.BREAK_VALUE AS "breakValue", b.UNIT_QTY AS "unitQty",
              i.ITEM_NAME AS "itemName", i.ITEM_SPEC AS "itemSpec", i.ITEM_UOM AS "itemUom",
              m.MOLD_NAME AS "moldName", m.MOLD_SPEC AS "moldSpec",
              F_CHECK_BOM_EXISTS(b.ITEM_CODE, b.ORGANIZATION_ID) AS "bomCheck",
              b.ENTER_BY AS "enterBy", b.ENTER_DATE AS "enterDate",
              b.LAST_MODIFY_BY AS "lastModifyBy", b.LAST_MODIFY_DATE AS "lastModifyDate"
         FROM IMCN_MOLD_BILL b
         JOIN IMCN_MOLD m
           ON m.MOLD_CODE = b.MOLD_CODE AND m.ORGANIZATION_ID = b.ORGANIZATION_ID
         LEFT JOIN ID_ITEM i
           ON i.ITEM_CODE = b.ITEM_CODE AND i.ORGANIZATION_ID = b.ORGANIZATION_ID
          AND i.DATESET <= TRUNC(SYSDATE) AND i.DATEEND >= TRUNC(SYSDATE)
        WHERE b.MOLD_CODE LIKE :moldCode
          AND b.ITEM_CODE LIKE :itemCode
          AND b.ORGANIZATION_ID = :organizationId
        ORDER BY b.MOLD_CODE, b.ITEM_CODE, b.SEQUENCE`,
      {
        moldCode: this.like(query.moldCode),
        itemCode: this.like(query.itemCode),
        organizationId,
      } as unknown as unknown[],
    ) as Promise<OracleRow[]>;
  }

  /** 선택 S-PARTS 의 재고 — PB d_mcn_mold_inventory_4_mold_lst */
  async findInventory(query: MoldCodeDto, organizationId: number) {
    return this.dataSource.query(
      `SELECT inv.MOLD_CODE AS "moldCode",
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
              inv.BREAK_VALUE AS "breakValue", inv.ACTUAL_VALUE AS "actualValue",
              inv.APPLY_MODEL_NAME AS "applyModelName",
              inv.LINE_CODE AS "lineCode", inv.WORKSTAGE_CODE AS "workstageCode",
              inv.MACHINE_CODE AS "machineCode",
              inv.SUPPLIER_CODE AS "supplierCode",
              inv.RENT_SUPPLIER_CODE AS "rentSupplierCode",
              inv.REPAIR_VENDOR_CODE AS "repairVendorCode",
              inv.BARCODE AS "barcode", inv.CYCLE_TIME AS "cycleTime",
              inv.LAST_RECEIPT_DATE AS "lastReceiptDate",
              inv.LAST_ISSUE_DATE AS "lastIssueDate",
              inv.LAST_ADJUST_DATE AS "lastAdjustDate",
              inv.COMMENTS AS "comments",
              m.MOLD_NAME AS "moldName", m.MOLD_SPEC AS "moldSpec",
              m.MOLD_GROUP AS "moldGroup"
         FROM IMCN_MOLD_INVENTORY inv
         LEFT JOIN IMCN_MOLD m
                ON m.MOLD_CODE = inv.MOLD_CODE AND m.ORGANIZATION_ID = inv.ORGANIZATION_ID
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
        WHERE inv.MOLD_CODE = :moldCode AND inv.ORGANIZATION_ID = :organizationId
        ORDER BY inv.MOLD_VERSION, inv.MOLD_SET_SERIAL`,
      { moldCode: query.moldCode, organizationId } as unknown as unknown[],
    ) as Promise<OracleRow[]>;
  }

  private async exists(moldCode: string, organizationId: number) {
    const rows = await this.dataSource.query(
      `SELECT COUNT(*) AS "cnt" FROM IMCN_MOLD
        WHERE MOLD_CODE = :moldCode AND ORGANIZATION_ID = :organizationId`,
      { moldCode, organizationId } as unknown as unknown[],
    ) as OracleRow[];
    return Number(rows[0]?.cnt ?? 0) > 0;
  }

  /** 등록 — 감사컬럼은 PB f_set_security_row('ALL') 과 같은 값으로 서버가 채운다. */
  async create(dto: MoldMasterUpsertDto, organizationId: number, userId: string) {
    if (await this.exists(dto.moldCode, organizationId)) {
      throw new ConflictException(`이미 등록된 S-PARTS 입니다 (${dto.moldCode}).`);
    }
    const columns = ['MOLD_CODE', 'ORGANIZATION_ID'];
    const values = [':moldCode', ':organizationId'];
    const binds: OracleRow = { moldCode: dto.moldCode, organizationId, userId };
    for (const [column, field] of EDITABLE) {
      columns.push(column);
      values.push(`:${field}`);
      binds[field] = dto[field] ?? null;
    }
    columns.push('ENTER_BY', 'ENTER_DATE', 'LAST_MODIFY_BY', 'LAST_MODIFY_DATE');
    values.push(':userId', 'SYSDATE', ':userId', 'SYSDATE');

    await this.dataSource.query(
      `INSERT INTO IMCN_MOLD (${columns.join(', ')}) VALUES (${values.join(', ')})`,
      binds as unknown as unknown[],
    );
    return { moldCode: dto.moldCode };
  }

  /** 수정 — PB f_set_security_row('MODIFY') 와 같이 LAST_MODIFY_* 만 갱신한다. */
  async update(dto: MoldMasterUpsertDto, organizationId: number, userId: string) {
    if (!await this.exists(dto.moldCode, organizationId)) {
      throw new NotFoundException(`S-PARTS 를 찾을 수 없습니다 (${dto.moldCode}).`);
    }
    const sets: string[] = [];
    const binds: OracleRow = { moldCode: dto.moldCode, organizationId, userId };
    for (const [column, field] of EDITABLE) {
      sets.push(`${column} = :${field}`);
      binds[field] = dto[field] ?? null;
    }
    sets.push('LAST_MODIFY_BY = :userId', 'LAST_MODIFY_DATE = SYSDATE');

    await this.dataSource.query(
      `UPDATE IMCN_MOLD SET ${sets.join(', ')}
        WHERE MOLD_CODE = :moldCode AND ORGANIZATION_ID = :organizationId`,
      binds as unknown as unknown[],
    );
    return { moldCode: dto.moldCode };
  }

  /**
   * 연쇄삭제 — PB 'DELETE' 분기 → PKG_MES_MAC.SP_MOLD_DELETE_CASCADE 전환.
   * 단가·부족이력·대여·출고·수리·입고·재고를 먼저 지우고 마스터를 지운다.
   */
  async remove(dto: MoldCodeDto, organizationId: number) {
    return this.tx.run(async (qr) => {
      const result = await qr.query(
        `DECLARE
           v_result NUMBER;
         BEGIN
           PKG_MES_MAC.SP_MOLD_DELETE_CASCADE(:moldCode, :organizationId, v_result);
           IF v_result < 0 THEN
             RAISE_APPLICATION_ERROR(-20010, 'MOLD_NOT_FOUND');
           END IF;
         END;`,
        { moldCode: dto.moldCode, organizationId } as unknown as unknown[],
      ).catch((error: unknown) => {
        const message = error instanceof Error ? error.message : String(error);
        if (message.includes('MOLD_NOT_FOUND')) {
          throw new NotFoundException(`S-PARTS 를 찾을 수 없습니다 (${dto.moldCode}).`);
        }
        throw error;
      });
      void result;
      return { moldCode: dto.moldCode, deleted: true };
    });
  }

  /**
   * 품목 일괄생성 — PB cb_1('Generate Item') → PKG_MES_MAC.SP_MOLD_GENERATE_ITEM 전환.
   * 아직 품목이 없는 S-PARTS 만 만든다. 이미 있으면 건너뛰므로 여러 번 눌러도 안전하다.
   */
  async generateItems(organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      const before = await qr.query(
        `SELECT COUNT(*) AS "cnt" FROM ID_ITEM WHERE ORGANIZATION_ID = :organizationId`,
        { organizationId } as unknown as unknown[],
      ) as OracleRow[];
      await qr.query(
        `DECLARE
           v_result NUMBER;
         BEGIN
           PKG_MES_MAC.SP_MOLD_GENERATE_ITEM(:organizationId, :userId, v_result);
         END;`,
        { organizationId, userId } as unknown as unknown[],
      );
      const after = await qr.query(
        `SELECT COUNT(*) AS "cnt" FROM ID_ITEM WHERE ORGANIZATION_ID = :organizationId`,
        { organizationId } as unknown as unknown[],
      ) as OracleRow[];
      return { created: Number(after[0]?.cnt ?? 0) - Number(before[0]?.cnt ?? 0) };
    });
  }
}
