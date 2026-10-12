/**
 * @file src/modules/mold/mold-repair.service.ts
 * @description S-PARTS 수리 — PB w_mcn_mold_repair_request_master + w_mcn_mold_repair_master 이식
 *
 * 초보자 가이드:
 * 1. **두 화면이 같은 테이블(IMCN_MOLD_REPAIR)을 본다.** 상태로 갈린다 —
 *    신청관리는 접수를 만들고, 수리관리는 그 건의 처리 내용을 채운다.
 * 2. **상태 흐름은 PB 그대로다**: 접수 'R'(신청) → 처리 'P'(수리중) → 확정 'C'(수리완료).
 *    되돌리기는 'R' 로 되돌린다. 화면이 임의 상태를 넣지 못하도록 전환은 action 으로만 받는다.
 * 3. **수리항번은 SEQ_MOLD_REPAIR_SEQUENCE 로 채번한다.** PB 와 같은 시퀀스다.
 * 4. **수리주기(REPAIR_TERM)는 계산값이다** — 오늘 − 마지막 입고일. PB 가 대상 목록에서
 *    이 값으로 오래된 것을 찾게 해 뒀다.
 * 5. **IMCN_MOLD_REPAIR_ITEM 은 수리 1건에 품목 1행만 담긴다.**
 *    기본키가 (S-PARTS 코드, 수리항번, ORGANIZATION_ID)까지라 품목코드가 키에 없다.
 *    그래서 등록은 있으면 갱신, 없으면 삽입으로 처리한다.
 */
import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { TransactionService } from '../../shared/transaction.service';
import {
  MoldRepairItemQueryDto,
  MoldRepairItemUpsertDto,
  MoldRepairQueryDto,
  MoldRepairRequestDto,
  MoldRepairStatusDto,
  MoldRepairTargetQueryDto,
  MoldRepairUpdateDto,
} from './mold-repair.dto';
import { namedBinds } from '../../common/utils/named-binds.util';

type OracleRow = Record<string, unknown>;

/** 수리 처리에서 사용자가 값을 넣는 컬럼 */
const UPDATABLE: Array<[column: string, field: keyof MoldRepairUpdateDto]> = [
  ['REPAIR_BY', 'repairBy'], ['REPAIR_VENDOR_CODE', 'repairVendorCode'],
  ['REPAIR_REASON_CODE', 'repairReasonCode'], ['REPAIR_COMMENTS', 'repairComments'],
  ['CURRENCY', 'currency'], ['APPLY_MACHINE_CODE', 'applyMachineCode'],
  ['LINE_CODE', 'lineCode'], ['REPAIR_QTY', 'repairQty'], ['REPAIR_AMT', 'repairAmt'],
  ['REPAIR_TIME', 'repairTime'],
];

@Injectable()
export class MoldRepairService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  private like(value?: string): string {
    return `${(value ?? '').trim()}%`;
  }

  /**
   * 수리 대상 목록 — PB d_mcn_mold_inventory_4_repair_lst.
   * 수리주기는 오늘 − 마지막 입고일이다(PB 계산식 그대로).
   */
  async findTargets(query: MoldRepairTargetQueryDto, organizationId: number) {
    return this.dataSource.query<OracleRow[]>(
      `SELECT m.MOLD_CODE AS "moldCode", m.MOLD_NAME AS "moldName",
              m.MOLD_SPEC AS "moldSpec", m.DRAWING_NO AS "drawingNo",
              m.MOLD_GROUP AS "moldGroup", grp.CODE_MEAN_KOR AS "moldGroupName",
              m.RAW_MATERIAL AS "rawMaterial", m.PUNCH_NO AS "punchNo",
              m.MOLD_LINE_TYPE AS "moldLineType",
              m.SAFETY_INVENTORY AS "safetyInventory",
              m.ORDER_LEADTIME AS "orderLeadtime", m.NATION_CODE AS "nationCode",
              m.SUPPLIER_CODE AS "supplierCode", sup.SUPPLIER_NAME AS "supplierName",
              m.LAST_RECEIPT_DATE AS "lastReceiptDate",
              m.LAST_ISSUE_DATE AS "lastIssueDate",
              m.COMMENTS AS "comments",
              inv.MOLD_VERSION AS "moldVersion", inv.MOLD_SET_SERIAL AS "moldSetSerial",
              inv.INVENTORY_QTY AS "inventoryQty",
              inv.MOLD_ROW_QTY AS "moldRowQty",
              inv.BREAK_VALUE AS "breakValue", inv.ACTUAL_VALUE AS "actualValue",
              inv.LOCATION_CODE AS "locationCode",
              inv.MOLD_USE_STATUS AS "moldUseStatus", ust.CODE_MEAN_KOR AS "moldUseStatusName",
              inv.RENT_STATUS AS "rentStatus", rst.CODE_MEAN_KOR AS "rentStatusName",
              inv.MOLD_IN_OUT AS "moldInOut", mio.CODE_MEAN_KOR AS "moldInOutName",
              inv.LAST_RECEIPT_DATE AS "inventoryLastReceiptDate",
              TRUNC(SYSDATE) - TRUNC(inv.LAST_RECEIPT_DATE) AS "repairTerm"
         FROM IMCN_MOLD m
         LEFT JOIN IMCN_MOLD_INVENTORY inv
                ON inv.MOLD_CODE = m.MOLD_CODE AND inv.ORGANIZATION_ID = m.ORGANIZATION_ID
         LEFT JOIN ICOM_SUPPLIER sup
                ON sup.SUPPLIER_CODE = m.SUPPLIER_CODE
               AND sup.ORGANIZATION_ID = m.ORGANIZATION_ID
         LEFT JOIN ISYS_BASECODE grp
                ON grp.CODE_TYPE = 'MOLD GROUP' AND grp.CODE_NAME = m.MOLD_GROUP
               AND grp.ORGANIZATION_ID = m.ORGANIZATION_ID
         LEFT JOIN ISYS_BASECODE ust
                ON ust.CODE_TYPE = 'MOLD USE STATUS' AND ust.CODE_NAME = inv.MOLD_USE_STATUS
               AND ust.ORGANIZATION_ID = m.ORGANIZATION_ID
         LEFT JOIN ISYS_BASECODE rst
                ON rst.CODE_TYPE = 'RENT STATUS' AND rst.CODE_NAME = inv.RENT_STATUS
               AND rst.ORGANIZATION_ID = m.ORGANIZATION_ID
         LEFT JOIN ISYS_BASECODE mio
                ON mio.CODE_TYPE = 'MOLD IN OUT' AND mio.CODE_NAME = inv.MOLD_IN_OUT
               AND mio.ORGANIZATION_ID = m.ORGANIZATION_ID
        WHERE m.MOLD_CODE LIKE :moldCode
          AND NVL(m.MOLD_GROUP, '*') LIKE :moldGroup
          AND m.MOLD_CODE <> '*'
          AND m.ORGANIZATION_ID = :organizationId
        ORDER BY m.MOLD_CODE, inv.MOLD_VERSION, inv.MOLD_SET_SERIAL`,
      namedBinds({
        moldCode: this.like(query.moldCode),
        moldGroup: this.like(query.moldGroup),
        organizationId,
      }),
    );
  }

  /** 수리 목록 — PB d_mcn_mold_repair_change_request_lst (신청일 기간) */
  async find(query: MoldRepairQueryDto, organizationId: number) {
    const binds = {
      organizationId,
      dateFrom: query.dateFrom.slice(0, 10),
      dateTo: query.dateTo.slice(0, 10),
      moldCode: this.like(query.moldCode),
      moldGroup: this.like(query.moldGroup),
      repairStatus: this.like(query.repairStatus),
      lineCode: this.like(query.lineCode),
    };
    const body = `
      SELECT r.MOLD_CODE AS "moldCode", r.REPAIR_SEQUENCE AS "repairSequence",
             m.MOLD_NAME AS "moldName",
             m.MOLD_GROUP AS "moldGroup", grp.CODE_MEAN_KOR AS "moldGroupName",
             r.MOLD_VERSION AS "moldVersion", r.MOLD_SET_SERIAL AS "moldSetSerial",
             r.REPAIR_REQUEST_DATE AS "repairRequestDate",
             r.REPAIR_DATE AS "repairDate",
             r.REPAIR_RECEIPT_DATE AS "repairReceiptDate",
             r.REPAIR_ISSUE_DATE AS "repairIssueDate",
             r.REPAIR_STATUS AS "repairStatus", stt.CODE_MEAN_KOR AS "repairStatusName",
             r.REPAIR_REASON_CODE AS "repairReasonCode",
             rsn.CODE_MEAN_KOR AS "repairReasonName",
             r.REPAIR_TYPE AS "repairType",
             r.REPAIR_VENDOR_CODE AS "repairVendorCode",
             vnd.SUPPLIER_NAME AS "repairVendorName",
             r.REPAIR_BY AS "repairBy",
             r.REPAIR_QTY AS "repairQty", r.REPAIR_AMT AS "repairAmt",
             r.REPAIR_TIME AS "repairTime",
             r.CURRENCY AS "currency", cur.CODE_MEAN_KOR AS "currencyName",
             r.APPLY_MACHINE_CODE AS "applyMachineCode",
             r.LINE_CODE AS "lineCode", ln.LINE_NAME AS "lineName",
             r.COMMENTS AS "comments", r.REPAIR_COMMENTS AS "repairComments",
             r.ENTER_BY AS "enterBy", r.ENTER_DATE AS "enterDate",
             r.LAST_MODIFY_BY AS "lastModifyBy", r.LAST_MODIFY_DATE AS "lastModifyDate"
        FROM IMCN_MOLD_REPAIR r
        JOIN IMCN_MOLD m
          ON m.MOLD_CODE = r.MOLD_CODE AND m.ORGANIZATION_ID = r.ORGANIZATION_ID
        LEFT JOIN ICOM_SUPPLIER vnd
               ON vnd.SUPPLIER_CODE = r.REPAIR_VENDOR_CODE
              AND vnd.ORGANIZATION_ID = r.ORGANIZATION_ID
        LEFT JOIN IP_PRODUCT_LINE ln
               ON ln.LINE_CODE = r.LINE_CODE AND ln.ORGANIZATION_ID = r.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE grp
               ON grp.CODE_TYPE = 'MOLD GROUP' AND grp.CODE_NAME = m.MOLD_GROUP
              AND grp.ORGANIZATION_ID = m.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE stt
               ON stt.CODE_TYPE = 'REPAIR STATUS' AND stt.CODE_NAME = r.REPAIR_STATUS
              AND stt.ORGANIZATION_ID = r.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE rsn
               ON rsn.CODE_TYPE = 'REPAIR REASON CODE'
              AND rsn.CODE_NAME = r.REPAIR_REASON_CODE
              AND rsn.ORGANIZATION_ID = r.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE cur
               ON cur.CODE_TYPE = 'CURRENCY' AND cur.CODE_NAME = r.CURRENCY
              AND cur.ORGANIZATION_ID = r.ORGANIZATION_ID
       WHERE r.MOLD_CODE LIKE :moldCode
         AND NVL(r.REPAIR_STATUS, '*') LIKE :repairStatus
         AND r.REPAIR_REQUEST_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
         AND r.REPAIR_REQUEST_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
         AND NVL(r.LINE_CODE, '*') LIKE :lineCode
         AND NVL(m.MOLD_GROUP, '*') LIKE :moldGroup
         AND r.ORGANIZATION_ID = :organizationId`;
    const page = query.page ?? 1;
    const limit = query.limit ?? 500;
    const totals = await this.dataSource.query(
      `SELECT COUNT(*) AS "total" FROM (${body}) source_rows`,
      namedBinds({ ...binds }),
    ) as OracleRow[];
    const rows = await this.dataSource.query(
      `${body} ORDER BY "repairRequestDate" DESC, "repairSequence" DESC
       OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`,
      namedBinds({ ...binds, offset: (page - 1) * limit, limit }),
    ) as OracleRow[];
    return { data: rows, total: Number(totals[0]?.total ?? 0), page, limit };
  }

  /** 접수(신청) — 신청일=오늘, 항번=SEQ_MOLD_REPAIR_SEQUENCE, 상태='R' */
  async request(dto: MoldRepairRequestDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      const exists = await qr.query(
        `SELECT PKG_MES_MAC.F_CHECK_MOLD_EXISTS(:moldCode, :organizationId) AS "cnt" FROM DUAL`,
        namedBinds({ moldCode: dto.moldCode, organizationId }),
      ) as OracleRow[];
      if (Number(exists[0]?.cnt ?? -1) < 0) {
        throw new BadRequestException(`등록되지 않은 S-PARTS 입니다 (${dto.moldCode}).`);
      }
      const seq = await qr.query(
        `SELECT SEQ_MOLD_REPAIR_SEQUENCE.NEXTVAL AS "seq" FROM DUAL`, [],
      ) as OracleRow[];
      const repairSequence = Number(seq[0]?.seq ?? 0);

      await qr.query(
        `INSERT INTO IMCN_MOLD_REPAIR (
           MOLD_CODE, REPAIR_SEQUENCE, ORGANIZATION_ID,
           REPAIR_REQUEST_DATE, REPAIR_STATUS,
           MOLD_VERSION, MOLD_SET_SERIAL,
           REPAIR_REASON_CODE, REPAIR_VENDOR_CODE, REPAIR_TYPE,
           APPLY_MACHINE_CODE, LINE_CODE, REPAIR_QTY, COMMENTS,
           ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE
         ) VALUES (
           :moldCode, :repairSequence, :organizationId,
           TRUNC(SYSDATE), 'R',
           :moldVersion, :moldSetSerial,
           :repairReasonCode, :repairVendorCode, :repairType,
           :applyMachineCode, :lineCode, :repairQty, :comments,
           :userId, SYSDATE, :userId, SYSDATE
         )`,
        namedBinds({
          moldCode: dto.moldCode,
          repairSequence,
          organizationId,
          moldVersion: dto.moldVersion ?? null,
          moldSetSerial: dto.moldSetSerial ?? null,
          repairReasonCode: dto.repairReasonCode ?? null,
          repairVendorCode: dto.repairVendorCode ?? null,
          repairType: dto.repairType ?? null,
          applyMachineCode: dto.applyMachineCode ?? null,
          lineCode: dto.lineCode ?? null,
          repairQty: dto.repairQty ?? null,
          comments: dto.comments ?? null,
          userId,
        }),
      );
      return { moldCode: dto.moldCode, repairSequence };
    });
  }

  private async currentStatus(moldCode: string, repairSequence: number, organizationId: number) {
    const rows = await this.dataSource.query(
      `SELECT REPAIR_STATUS AS "repairStatus" FROM IMCN_MOLD_REPAIR
        WHERE MOLD_CODE = :moldCode AND REPAIR_SEQUENCE = :repairSequence
          AND ORGANIZATION_ID = :organizationId`,
      namedBinds({ moldCode, repairSequence, organizationId }),
    ) as OracleRow[];
    if (rows.length === 0) {
      throw new NotFoundException(`수리건을 찾을 수 없습니다 (${moldCode}/${repairSequence}).`);
    }
    return String(rows[0]?.repairStatus ?? '');
  }

  /** 처리 내용 저장 — 상태를 'P'(수리중)로 올리고 수리일을 오늘로 찍는다(PB 와 같다). */
  async update(dto: MoldRepairUpdateDto, organizationId: number, userId: string) {
    const status = await this.currentStatus(dto.moldCode, dto.repairSequence, organizationId);
    if (status === 'C') {
      throw new BadRequestException('수리완료된 건은 수정할 수 없습니다.');
    }
    const sets: string[] = ["REPAIR_STATUS = 'P'", 'REPAIR_DATE = TRUNC(SYSDATE)'];
    const binds: OracleRow = {
      moldCode: dto.moldCode,
      repairSequence: dto.repairSequence,
      organizationId,
      userId,
    };
    for (const [column, field] of UPDATABLE) {
      if (dto[field] === undefined) continue;
      sets.push(`${column} = :${field}`);
      binds[field] = dto[field] ?? null;
    }
    for (const [column, field] of [
      ['REPAIR_RECEIPT_DATE', 'repairReceiptDate'],
      ['REPAIR_ISSUE_DATE', 'repairIssueDate'],
    ] as Array<[string, keyof MoldRepairUpdateDto]>) {
      if (dto[field] === undefined) continue;
      sets.push(`${column} = TO_DATE(:${field}, 'YYYY-MM-DD')`);
      binds[field] = String(dto[field]).slice(0, 10);
    }
    sets.push('LAST_MODIFY_BY = :userId', 'LAST_MODIFY_DATE = SYSDATE');

    await this.dataSource.query(
      `UPDATE IMCN_MOLD_REPAIR SET ${sets.join(', ')}
        WHERE MOLD_CODE = :moldCode AND REPAIR_SEQUENCE = :repairSequence
          AND ORGANIZATION_ID = :organizationId`,
      namedBinds(binds),
    );
    return { moldCode: dto.moldCode, repairSequence: dto.repairSequence, repairStatus: 'P' };
  }

  /**
   * 상태 전환 — PB cb_process('Confirm' → 'C') / pb_cancel('Cancel' → 'R').
   * 임의 상태를 넣지 못하도록 두 갈래만 받는다.
   */
  async changeStatus(dto: MoldRepairStatusDto, organizationId: number, userId: string) {
    const status = await this.currentStatus(dto.moldCode, dto.repairSequence, organizationId);
    const next = dto.action === 'confirm' ? 'C' : 'R';
    if (status === next) {
      throw new BadRequestException(
        next === 'C' ? '이미 수리완료된 건입니다.' : '이미 신청 상태입니다.',
      );
    }
    await this.dataSource.query(
      `UPDATE IMCN_MOLD_REPAIR
          SET REPAIR_STATUS    = :next,
              LAST_MODIFY_BY   = :userId,
              LAST_MODIFY_DATE = SYSDATE
        WHERE MOLD_CODE = :moldCode AND REPAIR_SEQUENCE = :repairSequence
          AND ORGANIZATION_ID = :organizationId`,
      namedBinds({
        next,
        userId,
        moldCode: dto.moldCode,
        repairSequence: dto.repairSequence,
        organizationId,
      }),
    );
    return { moldCode: dto.moldCode, repairSequence: dto.repairSequence, repairStatus: next };
  }

  /** 수리품목 — PB d_mcn_mold_repair_item_lst */
  async findItems(query: MoldRepairItemQueryDto, organizationId: number) {
    return this.dataSource.query<OracleRow[]>(
      `SELECT ri.MOLD_CODE AS "moldCode", ri.REPAIR_SEQUENCE AS "repairSequence",
              ri.REPAIR_ITEM_CODE AS "repairItemCode",
              i.ITEM_NAME AS "repairItemName", i.ITEM_SPEC AS "repairItemSpec",
              i.ITEM_UOM AS "repairItemUom",
              ri.REPAIR_ITEM_QTY AS "repairItemQty", ri.COMMENTS AS "comments",
              ri.ENTER_BY AS "enterBy", ri.ENTER_DATE AS "enterDate",
              ri.LAST_MODIFY_BY AS "lastModifyBy", ri.LAST_MODIFY_DATE AS "lastModifyDate"
         FROM IMCN_MOLD_REPAIR_ITEM ri
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = ri.REPAIR_ITEM_CODE
               AND i.ORGANIZATION_ID = ri.ORGANIZATION_ID
               AND i.DATESET <= TRUNC(SYSDATE) AND i.DATEEND >= TRUNC(SYSDATE)
        WHERE ri.MOLD_CODE = :moldCode AND ri.REPAIR_SEQUENCE = :repairSequence
          AND ri.ORGANIZATION_ID = :organizationId
        ORDER BY ri.REPAIR_ITEM_CODE`,
      namedBinds({
        moldCode: query.moldCode,
        repairSequence: query.repairSequence,
        organizationId,
      }),
    );
  }

  /**
   * 수리품목 저장 — 기본키에 품목코드가 없어 수리 1건당 1행이다.
   * 있으면 갱신하고 없으면 넣는다.
   */
  async saveItem(dto: MoldRepairItemUpsertDto, organizationId: number, userId: string) {
    const status = await this.currentStatus(dto.moldCode, dto.repairSequence, organizationId);
    if (status === 'C') {
      throw new BadRequestException('수리완료된 건의 품목은 바꿀 수 없습니다.');
    }
    return this.tx.run(async (qr) => {
      await qr.query(
        `MERGE INTO IMCN_MOLD_REPAIR_ITEM ri
         USING (SELECT :moldCode AS MOLD_CODE, :repairSequence AS REPAIR_SEQUENCE,
                       :organizationId AS ORGANIZATION_ID FROM DUAL) src
            ON (ri.MOLD_CODE = src.MOLD_CODE
                AND ri.REPAIR_SEQUENCE = src.REPAIR_SEQUENCE
                AND ri.ORGANIZATION_ID = src.ORGANIZATION_ID)
          WHEN MATCHED THEN UPDATE SET
               ri.REPAIR_ITEM_CODE  = :repairItemCode,
               ri.REPAIR_ITEM_QTY   = :repairItemQty,
               ri.COMMENTS          = :comments,
               ri.LAST_MODIFY_BY    = :userId,
               ri.LAST_MODIFY_DATE  = SYSDATE
          WHEN NOT MATCHED THEN INSERT (
               MOLD_CODE, REPAIR_SEQUENCE, ORGANIZATION_ID,
               REPAIR_ITEM_CODE, REPAIR_ITEM_QTY, COMMENTS,
               ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE
             ) VALUES (
               :moldCode, :repairSequence, :organizationId,
               :repairItemCode, :repairItemQty, :comments,
               :userId, SYSDATE, :userId, SYSDATE
             )`,
        namedBinds({
          moldCode: dto.moldCode,
          repairSequence: dto.repairSequence,
          organizationId,
          repairItemCode: dto.repairItemCode,
          repairItemQty: dto.repairItemQty ?? null,
          comments: dto.comments ?? null,
          userId,
        }),
      );
      return { moldCode: dto.moldCode, repairSequence: dto.repairSequence };
    });
  }
}
