// 작업지시관리 — IP_PRODUCT_RUN_CARD CRUD
//
// PowerBuilder 원본 w_product_run_card 를 기준으로 한다.
//  - 채번: F_GET_NEW_RUN_NO(RUN_DATE, MODEL_NAME, LINE_CODE, SHIFT_CODE, ORG) — 저장 시점에만 호출
//  - 삭제 가드: IP_PRODUCT_2D_BARCODE 에 PID 매핑이 있으면 차단 (PB srw:513~528)
//              삭제 시 IP_PRODUCT_SMD_PLAN 의 MFS 연결 해제 (PB srw:585~592)
import { BadRequestException, ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { EntityManager, Repository } from 'typeorm';
import { ProductRunCard } from '../../entities/product-run-card.entity';
import { RunCardUpsertDto } from './run-card.dto';

const ORG = 1;
const DEFAULT_USER = 'ADMIN';
/** TO_DATE 에 넘기기 전 형식을 막아 ORA-01861 이 500 으로 새는 것을 방지한다. */
const DATE_PATTERN = /^\d{4}-\d{2}-\d{2}$/;

function assertDate(value: string | undefined, field: string): asserts value is string {
  if (!value) throw new BadRequestException(`${field} 는 필수입니다.`);
  if (!DATE_PATTERN.test(value) || Number.isNaN(Date.parse(value))) {
    throw new BadRequestException(`${field} 형식이 올바르지 않습니다 (YYYY-MM-DD): ${value}`);
  }
}
const LIST_LIMIT = 500;
/** SEQ_RUN_NO_SEQUENCE 는 MAX_VALUE=4095, CYCLE=Y 라 순환한다. PK 충돌 시 재채번한다. */
const RUN_NO_RETRY = 5;

export interface RunCardRow {
  runNo: string; runDate: string; lotNo: string; itemCode: string; itemName: string | null;
  itemSpec: string | null; unit: string | null; modelName: string; modelSpec: string | null;
  customerName: string | null; lineCode: string; lineName: string | null; lotSize: number;
  charger: string; shiftCode: string | null; markingNo: string | null; pcbSupplierCode: string | null;
  runStatus: string | null; carrierSize: number | null; productRunType: string | null;
  arrayType: string | null; activeYn: string | null; parentItemCode: string | null;
  pcbItem: string | null; masterModelName: string | null; mfsGroupNo: string | null;
  revision: string | null; modelClass: string | null; pcbWeek: string | null; comments: string | null;
  pidCount: number; resultCount: number;
  updatedBy: string | null; updatedAt: string | null;
}

export interface RunCardSearch {
  fromDate: string; toDate: string;
  runNo?: string; modelName?: string; lineCode?: string; lotNo?: string;
}

@Injectable()
export class RunCardService {
  constructor(
    @InjectRepository(ProductRunCard)
    private readonly repo: Repository<ProductRunCard>,
  ) {}

  private q<T = Record<string, unknown>>(sql: string, params: unknown[] = []): Promise<T[]> {
    return this.repo.manager.query(sql, params);
  }

  /** 목록 — PB 화면의 Where Condition(기간 + Run No/Model/Line/Lot like)과 동일 */
  async list(search: RunCardSearch): Promise<RunCardRow[]> {
    assertDate(search.fromDate, 'fromDate');
    assertDate(search.toDate, 'toDate');
    const params: unknown[] = [search.fromDate, search.toDate];
    let where = `r.ORGANIZATION_ID = ${ORG}
      AND r.RUN_DATE >= TO_DATE(:1,'YYYY-MM-DD') AND r.RUN_DATE < TO_DATE(:2,'YYYY-MM-DD') + 1`;

    const like = (column: string, value?: string) => {
      if (!value) return;
      params.push(`%${value.toUpperCase()}%`);
      where += ` AND UPPER(${column}) LIKE :${params.length}`;
    };
    like('r.RUN_NO', search.runNo);
    like('r.MODEL_NAME', search.modelName);
    like('NVL(r.LOT_NO,\'*\')', search.lotNo);
    if (search.lineCode) {
      params.push(search.lineCode);
      where += ` AND r.LINE_CODE = :${params.length}`;
    }

    const rows = await this.q(this.selectSql(where), params);
    return rows.map((r) => this.toRow(r));
  }

  /** 단건 조회 — 기간 조건 없이 PK 로만 찾는다 */
  async detail(runNo: string): Promise<RunCardRow> {
    const rows = await this.q(this.selectSql(`r.ORGANIZATION_ID = ${ORG} AND r.RUN_NO = :1`), [runNo]);
    if (rows.length === 0) throw new NotFoundException(`작업지시 ${runNo} 를 찾을 수 없습니다.`);
    return this.toRow(rows[0]);
  }

  /** 목록·단건이 공유하는 SELECT 본문 */
  private selectSql(where: string): string {
    return `SELECT * FROM (
        SELECT r.RUN_NO AS "runNo",
               TO_CHAR(r.RUN_DATE,'YYYY-MM-DD') AS "runDate",
               r.LOT_NO AS "lotNo", r.ITEM_CODE AS "itemCode",
               (SELECT MAX(i.ITEM_NAME) FROM ID_ITEM i WHERE i.ITEM_CODE=r.ITEM_CODE AND i.ORGANIZATION_ID=r.ORGANIZATION_ID) AS "itemName",
               (SELECT MAX(i.ITEM_SPEC) FROM ID_ITEM i WHERE i.ITEM_CODE=r.ITEM_CODE AND i.ORGANIZATION_ID=r.ORGANIZATION_ID) AS "itemSpec",
               (SELECT MAX(i.ITEM_UOM) FROM ID_ITEM i WHERE i.ITEM_CODE=r.ITEM_CODE AND i.ORGANIZATION_ID=r.ORGANIZATION_ID) AS "unit",
               r.MODEL_NAME AS "modelName",
               (SELECT MAX(m.MODEL_SPEC) FROM IP_PRODUCT_MODEL_MASTER m WHERE m.MODEL_NAME=r.MODEL_NAME AND m.ORGANIZATION_ID=r.ORGANIZATION_ID) AS "modelSpec",
               (SELECT MAX(m.CUSTOMER_NAME) FROM IP_PRODUCT_MODEL_MASTER m WHERE m.MODEL_NAME=r.MODEL_NAME AND m.ORGANIZATION_ID=r.ORGANIZATION_ID) AS "customerName",
               r.LINE_CODE AS "lineCode",
               (SELECT MAX(l.LINE_NAME) FROM IP_PRODUCT_LINE l WHERE l.LINE_CODE=r.LINE_CODE AND l.ORGANIZATION_ID=r.ORGANIZATION_ID) AS "lineName",
               r.LOT_SIZE AS "lotSize", r.CHARGER AS "charger", r.SHIFT_CODE AS "shiftCode",
               r.MARKING_NO AS "markingNo", r.PCB_SUPPLIER_CODE AS "pcbSupplierCode",
               r.RUN_STATUS AS "runStatus", r.CARRIER_SIZE AS "carrierSize",
               r.PRODUCT_RUN_TYPE AS "productRunType", r.ARRAY_TYPE AS "arrayType",
               r.ACTIVE_YN AS "activeYn", r.PARENT_ITEM_CODE AS "parentItemCode",
               r.PCB_ITEM AS "pcbItem", r.MASTER_MODEL_NAME AS "masterModelName",
               r.MFS_GROUP_NO AS "mfsGroupNo", r.REVISION AS "revision",
               r.MODEL_CLASS AS "modelClass", r.PCB_WEEK AS "pcbWeek", r.COMMENTS AS "comments",
               (SELECT COUNT(*) FROM IP_PRODUCT_2D_BARCODE b WHERE b.RUN_NO=r.RUN_NO AND b.ORGANIZATION_ID=r.ORGANIZATION_ID) AS "pidCount",
               (SELECT COUNT(*) FROM IP_PRODUCT_WORK_RESULT w WHERE w.RUN_NO=r.RUN_NO AND w.ORGANIZATION_ID=r.ORGANIZATION_ID) AS "resultCount",
               NVL(r.LAST_MODIFY_BY, r.ENTER_BY) AS "updatedBy",
               TO_CHAR(NVL(r.LAST_MODIFY_DATE, r.ENTER_DATE),'YYYY-MM-DD HH24:MI') AS "updatedAt"
          FROM IP_PRODUCT_RUN_CARD r
         WHERE ${where}
         ORDER BY r.RUN_DATE DESC, r.RUN_NO
      ) WHERE ROWNUM <= ${LIST_LIMIT}`;
  }

  /** 등록 — RUN_NO 는 F_GET_NEW_RUN_NO 로 서버 채번 */
  async create(dto: RunCardUpsertDto): Promise<{ runNo: string }> {
    assertDate(dto.runDate, 'runDate');
    const user = dto.userId || DEFAULT_USER;
    return this.repo.manager.transaction(async (m) => {
      for (let attempt = 0; attempt < RUN_NO_RETRY; attempt += 1) {
        const runNo = await this.generateRunNo(m, dto);
        const dup: Array<{ CNT: number }> = await m.query(
          `SELECT COUNT(*) AS CNT FROM IP_PRODUCT_RUN_CARD WHERE RUN_NO = :1 AND ORGANIZATION_ID = ${ORG}`,
          [runNo],
        );
        if (Number(dup[0]?.CNT ?? 0) > 0) continue;
        await this.insert(m, runNo, dto, user);
        return { runNo };
      }
      throw new ConflictException('작업지시번호 채번에 실패했습니다. 잠시 후 다시 시도해 주세요.');
    });
  }

  /** 수정 — RUN_NO 는 변경하지 않는다 */
  async update(dto: RunCardUpsertDto): Promise<{ runNo: string }> {
    if (!dto.runNo) throw new BadRequestException('runNo 는 필수입니다.');
    assertDate(dto.runDate, 'runDate');
    const user = dto.userId || DEFAULT_USER;
    const affected: Array<{ CNT: number }> = await this.q(
      `SELECT COUNT(*) AS CNT FROM IP_PRODUCT_RUN_CARD WHERE RUN_NO = :1 AND ORGANIZATION_ID = ${ORG}`,
      [dto.runNo],
    );
    if (Number(affected[0]?.CNT ?? 0) === 0) {
      throw new NotFoundException(`작업지시 ${dto.runNo} 를 찾을 수 없습니다.`);
    }
    await this.q(
      `UPDATE IP_PRODUCT_RUN_CARD
          SET RUN_DATE = TO_DATE(:1,'YYYY-MM-DD'), LOT_NO = :2, ITEM_CODE = :3, MODEL_NAME = :4,
              LINE_CODE = :5, LOT_SIZE = :6, CHARGER = :7, SHIFT_CODE = :8, MARKING_NO = :9,
              PCB_SUPPLIER_CODE = :10, RUN_STATUS = :11, CARRIER_SIZE = :12, PRODUCT_RUN_TYPE = :13,
              ARRAY_TYPE = :14, ACTIVE_YN = :15, PARENT_ITEM_CODE = :16, PCB_ITEM = :17,
              MASTER_MODEL_NAME = :18, MFS_GROUP_NO = :19, REVISION = :20, MODEL_CLASS = :21,
              PCB_WEEK = :22, COMMENTS = :23, LAST_MODIFY_BY = :24, LAST_MODIFY_DATE = SYSDATE
        WHERE RUN_NO = :25 AND ORGANIZATION_ID = ${ORG}`,
      [...this.editableParams(dto), user, dto.runNo],
    );
    return { runNo: dto.runNo };
  }

  /**
   * 삭제 — PB 원본과 동일한 가드
   *  1) IP_PRODUCT_2D_BARCODE 에 PID 매핑이 있으면 차단
   *  2) IP_PRODUCT_WORK_RESULT 에 작업실적이 있으면 차단 (웹 실적관리에서 생성한 자식)
   *  3) 통과 시 IP_PRODUCT_SMD_PLAN 의 MFS 연결 해제 후 삭제
   */
  async remove(runNo: string): Promise<{ runNo: string }> {
    return this.repo.manager.transaction(async (m) => {
      const exists: Array<{ CNT: number }> = await m.query(
        `SELECT COUNT(*) AS CNT FROM IP_PRODUCT_RUN_CARD WHERE RUN_NO = :1 AND ORGANIZATION_ID = ${ORG}`,
        [runNo],
      );
      if (Number(exists[0]?.CNT ?? 0) === 0) {
        throw new NotFoundException(`작업지시 ${runNo} 를 찾을 수 없습니다.`);
      }

      const guards: Array<{ PID_CNT: number; RESULT_CNT: number; DETAIL_CNT: number }> = await m.query(
        `SELECT
           (SELECT COUNT(*) FROM IP_PRODUCT_2D_BARCODE WHERE RUN_NO = :1 AND ORGANIZATION_ID = ${ORG}) AS PID_CNT,
           (SELECT COUNT(*) FROM IP_PRODUCT_WORK_RESULT WHERE RUN_NO = :1 AND ORGANIZATION_ID = ${ORG}) AS RESULT_CNT,
           (SELECT COUNT(*) FROM IP_PRODUCT_RUN_CARD_DETAIL WHERE RUN_NO = :1 AND ORGANIZATION_ID = ${ORG}) AS DETAIL_CNT
         FROM DUAL`,
        [runNo],
      );
      const pid = Number(guards[0]?.PID_CNT ?? 0);
      const result = Number(guards[0]?.RESULT_CNT ?? 0);
      const detail = Number(guards[0]?.DETAIL_CNT ?? 0);
      const blocked: string[] = [];
      if (pid > 0) blocked.push(`PID ${pid}건`);
      if (result > 0) blocked.push(`작업실적 ${result}건`);
      if (detail > 0) blocked.push(`런카드 상세 ${detail}건`);
      if (blocked.length > 0) {
        throw new ConflictException(`연결된 데이터가 있어 삭제할 수 없습니다: ${blocked.join(', ')}`);
      }

      // SMD 계획 연결 해제 (PB 원본과 동일)
      await m.query(
        `UPDATE IP_PRODUCT_SMD_PLAN SET PLAN_STATUS = 'W', MFS = '*'
          WHERE MFS = :1 AND ORGANIZATION_ID = ${ORG}`,
        [runNo],
      );
      await m.query(
        `DELETE FROM IP_PRODUCT_RUN_CARD WHERE RUN_NO = :1 AND ORGANIZATION_ID = ${ORG}`,
        [runNo],
      );
      return { runNo };
    });
  }

  /** PB 와 동일하게 저장 시점에만 채번한다 (시퀀스 소모 방지) */
  private async generateRunNo(m: EntityManager, dto: RunCardUpsertDto): Promise<string> {
    const rows: Array<{ RUN_NO: string }> = await m.query(
      `SELECT F_GET_NEW_RUN_NO(TO_DATE(:1,'YYYY-MM-DD'), :2, :3, :4, ${ORG}) AS RUN_NO FROM DUAL`,
      [dto.runDate, dto.modelName, dto.lineCode, dto.shiftCode ?? 'A'],
    );
    const runNo = rows[0]?.RUN_NO;
    if (!runNo) throw new ConflictException('작업지시번호 채번에 실패했습니다.');
    return runNo;
  }

  private insert(m: EntityManager, runNo: string, dto: RunCardUpsertDto, user: string) {
    return m.query(
      // 바인드는 등장 순서로 매핑되므로 VALUES 절의 순서와 params 배열 순서를 일치시킨다.
      `INSERT INTO IP_PRODUCT_RUN_CARD
         (ORGANIZATION_ID, RUN_DATE, LOT_NO, ITEM_CODE, MODEL_NAME, LINE_CODE, LOT_SIZE,
          CHARGER, SHIFT_CODE, MARKING_NO, PCB_SUPPLIER_CODE, RUN_STATUS, CARRIER_SIZE,
          PRODUCT_RUN_TYPE, ARRAY_TYPE, ACTIVE_YN, PARENT_ITEM_CODE, PCB_ITEM, MASTER_MODEL_NAME,
          MFS_GROUP_NO, REVISION, MODEL_CLASS, PCB_WEEK, COMMENTS,
          ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE, RUN_NO)
       VALUES
         (${ORG}, TO_DATE(:1,'YYYY-MM-DD'), :2, :3, :4, :5, :6, :7, :8, :9, :10, :11, :12,
          :13, :14, :15, :16, :17, :18, :19, :20, :21, :22, :23, :24, SYSDATE, :25, SYSDATE, :26)`,
      [...this.editableParams(dto), user, user, runNo],
    );
  }

  /** UPDATE/INSERT 공통 바인드 (1~23번) — 순서를 바꾸면 두 쿼리를 함께 고쳐야 한다 */
  private editableParams(dto: RunCardUpsertDto): unknown[] {
    return [
      dto.runDate, dto.lotNo, dto.itemCode, dto.modelName, dto.lineCode, dto.lotSize, dto.charger,
      dto.shiftCode ?? null, dto.markingNo ?? null, dto.pcbSupplierCode ?? null, dto.runStatus ?? null,
      dto.carrierSize ?? null, dto.productRunType ?? null, dto.arrayType ?? null, dto.activeYn ?? 'N',
      dto.parentItemCode ?? null, dto.pcbItem ?? null, dto.masterModelName ?? null,
      dto.mfsGroupNo ?? null, dto.revision ?? null, dto.modelClass ?? null, dto.pcbWeek ?? null,
      dto.comments ?? null,
    ];
  }

  private toRow(r: Record<string, unknown>): RunCardRow {
    const str = (v: unknown) => (v == null ? null : String(v));
    const num = (v: unknown) => (v == null ? null : Number(v));
    return {
      runNo: String(r.runNo), runDate: String(r.runDate ?? ''), lotNo: String(r.lotNo ?? ''),
      itemCode: String(r.itemCode ?? ''), itemName: str(r.itemName), itemSpec: str(r.itemSpec),
      unit: str(r.unit), modelName: String(r.modelName ?? ''), modelSpec: str(r.modelSpec),
      customerName: str(r.customerName), lineCode: String(r.lineCode ?? ''), lineName: str(r.lineName),
      lotSize: Number(r.lotSize ?? 0), charger: String(r.charger ?? ''), shiftCode: str(r.shiftCode),
      markingNo: str(r.markingNo), pcbSupplierCode: str(r.pcbSupplierCode), runStatus: str(r.runStatus),
      carrierSize: num(r.carrierSize), productRunType: str(r.productRunType), arrayType: str(r.arrayType),
      activeYn: str(r.activeYn), parentItemCode: str(r.parentItemCode), pcbItem: str(r.pcbItem),
      masterModelName: str(r.masterModelName), mfsGroupNo: str(r.mfsGroupNo), revision: str(r.revision),
      modelClass: str(r.modelClass), pcbWeek: str(r.pcbWeek), comments: str(r.comments),
      pidCount: Number(r.pidCount ?? 0), resultCount: Number(r.resultCount ?? 0),
      updatedBy: str(r.updatedBy), updatedAt: str(r.updatedAt),
    };
  }
}
