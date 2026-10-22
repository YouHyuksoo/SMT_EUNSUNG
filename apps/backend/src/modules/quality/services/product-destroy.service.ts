/**
 * @file src/modules/quality/services/product-destroy.service.ts
 * @description 공정폐기관리 — PB w_pln_product_pcb_destroy_master 이식
 *
 * 폐기는 행 삭제가 아니라 **이력 적재**다. IP_PRODUCT_WORK_QC 에
 * QC_INSPECT_HANDLING='D'(폐기), RECEIPT_DEFICIT='1'(입고) 행을 시리얼당 1건 INSERT 한다.
 * 같은 테이블을 공정수리이력조회(repair-history)도 쓴다.
 *
 * PB 원본과의 의도적 차이 (사용자 합의):
 * - Issue Cancel 이 원본에서는 WHERE 에 QC_SEQUENCE 가 빠져 있어 해당 시리얼의 모든 행이
 *   되돌아갔다. Issue 와 대칭이 되도록 QC_SEQUENCE 조건을 넣었다.
 * - 폐기이력 종료일이 원본에서는 `QC_DATE <= :dateEnd`(자정)라 종료일 당일이 빠졌다.
 *   공정수리이력조회와 동일하게 `< :dateEnd + 1` 로 맞춰 종료일을 포함한다.
 *
 * 2026-10-22 요청(MES 개선요청사항 26.10.22):
 * - 팀(생산1팀 SMT / 생산2팀 조립)마다 다른 불량 양식 — 불량유형·제품구분·주야·원인·발생/검출공정·작업자.
 * - 바코드 미각인 제품은 품번 + 수량으로 등록한다. 시리얼 칸에는 'NOSN-<QC순번>' 을 넣는다
 *   (PK 가 시리얼을 요구하고, 트리거가 시리얼로 2D 바코드를 갱신하므로 실제 시리얼과 겹치지 않는 값).
 * - 등록 시점 단가·금액을 남긴다: 구매단가가 있으면 그것, 없으면 BOM 말단 자재원가 합.
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource, QueryRunner } from 'typeorm';
import { parseDateStart } from '../../../shared/date.util';
import { TransactionService } from '../../../shared/transaction.service';
import {
  ProductDestroyExecuteDto,
  ProductDestroyHistoryQueryDto,
  ProductDestroyIssueDto,
  ProductDestroySummaryQueryDto,
} from '../dto/product-destroy.dto';
import { namedBinds } from '../../../common/utils/named-binds.util';
import { DESTROY_UNIT_PRICE_SQL } from './destroy-price.sql';

type OracleRow = Record<string, unknown>;

/** 시리얼 단건 조회 결과에서 쓰는 불량구분 — 1=입고(폐기대상), 2=반품(Issue 처리됨) */
const DEFICIT_RECEIPT = '1';
const DEFICIT_ISSUE = '2';
/** 바코드 미각인(품번 + 수량) 폐기의 시리얼 접두어 */
const NO_SERIAL_PREFIX = 'NOSN-';

/** 팀별 불량유형·공정 코드형 */
const TEAM_CODE_TYPES: Record<string, { badType: string; process: string }> = {
  '1': { badType: 'DESTROY BAD TYPE SMT', process: 'DESTROY PROCESS SMT' },
  '2': { badType: 'DESTROY BAD TYPE ASSY', process: 'DESTROY PROCESS ASSY' },
};

interface DestroyItemInfo {
  itemCode: string;
  modelName: string | null;
  modelSuffix: string | null;
}

interface DestroyRowInput extends DestroyItemInfo {
  serialNo: string;
  qcSequence: number;
  qty: number;
  lineCode: string;
  workstageCode: string;
}

export interface DestroyOutcome {
  serialNo: string;
  status: 'OK' | 'SKIP' | 'FAIL';
  reason?: string;
  qcSequence?: number;
}

@Injectable()
export class ProductDestroyService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  /** PB d_pln_product_destroy_hst — 폐기이력 */
  async findHistory(query: ProductDestroyHistoryQueryDto, organizationId: number) {
    const binds: Record<string, unknown> = {
      organizationId,
      lineCode: this.like(query.lineCode),
      workstageCode: this.like(query.workstageCode),
      modelName: this.like(query.modelName),
      serialNo: this.like(query.serialNo),
      team: query.team ?? null,
      dateFrom: parseDateStart(query.dateFrom) ?? new Date(1900, 0, 1),
      dateTo: parseDateStart(query.dateTo) ?? new Date(9999, 11, 30),
    };
    const from = `
      FROM IP_PRODUCT_WORK_QC qc
      WHERE qc.ORGANIZATION_ID = :organizationId
        AND qc.QC_INSPECT_HANDLING = 'D'
        AND NVL(qc.LINE_CODE, '*') LIKE :lineCode
        AND NVL(qc.WORKSTAGE_CODE, '*') LIKE :workstageCode
        AND NVL(qc.MODEL_NAME, '*') LIKE :modelName
        AND NVL(qc.SERIAL_NO, '*') LIKE :serialNo
        AND (:team IS NULL OR qc.DESTROY_TEAM = :team)
        AND qc.QC_DATE >= :dateFrom
        AND qc.QC_DATE < :dateTo + 1`;
    const select = `${this.selectList()} ${from}
      ORDER BY qc.QC_DATE DESC, qc.QC_SEQUENCE DESC
      OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`;
    const offset = (query.page - 1) * query.limit;
    const rows = await this.dataSource.query(
      select, namedBinds({ ...binds, offset, limit: query.limit }),
    ) as OracleRow[];
    const totals = await this.dataSource.query(
      `SELECT COUNT(*) AS "total" ${from}`, namedBinds(binds),
    ) as OracleRow[];
    return { data: rows, total: Number(totals[0]?.total ?? 0), page: query.page, limit: query.limit };
  }

  /** PB dw_1 / dw_2 — 시리얼 하나의 폐기(1) / 반품(2) 현황 */
  async findBySerial(serialNo: string, organizationId: number) {
    const binds = { organizationId, serialNo: this.like(serialNo) };
    const load = async (deficit: string): Promise<OracleRow[]> => await this.dataSource.query(
      `${this.selectList()}
       FROM IP_PRODUCT_WORK_QC qc
       WHERE qc.ORGANIZATION_ID = :organizationId
         AND qc.SERIAL_NO LIKE :serialNo
         AND qc.RECEIPT_DEFICIT = '${deficit}'
       ORDER BY qc.QC_SEQUENCE`,
      namedBinds(binds),
    ) as OracleRow[];
    const [destroyList, issueList] = await Promise.all([load(DEFICIT_RECEIPT), load(DEFICIT_ISSUE)]);
    return { destroyList, issueList };
  }

  /**
   * PB cb_2(Destroy) — 시리얼 목록을 순회하며 폐기 이력을 등록한다.
   * PB 는 행마다 OK/FAIL 을 찍고 계속 진행하므로 전체 롤백하지 않는다.
   * 다만 시리얼(또는 품번) 1건의 처리는 트랜잭션으로 묶어 부분 저장을 막는다.
   */
  async destroy(dto: ProductDestroyExecuteDto, organizationId: number, userId: string) {
    const serials = [...new Set((dto.serialNos ?? []).map(s => s.trim().toUpperCase()).filter(Boolean))];
    const items = (dto.items ?? []).map(i => ({ itemCode: i.itemCode.trim(), qty: i.qty })).filter(i => i.itemCode);
    if (serials.length === 0 && items.length === 0) throw new BadRequestException('폐기할 시리얼이나 품번이 없습니다.');
    this.validateTeamFields(dto);

    const prices = new Map<string, number | null>();
    const results: DestroyOutcome[] = [];
    for (const serialNo of serials) {
      try {
        results.push(await this.tx.run(qr => this.destroyOne(qr, serialNo, dto, organizationId, userId, prices)));
      } catch (error: unknown) {
        results.push({ serialNo, status: 'FAIL', reason: this.message(error) });
      }
    }
    for (const item of items) {
      try {
        results.push(await this.tx.run(qr => this.destroyItem(qr, item.itemCode, item.qty, dto, organizationId, userId, prices)));
      } catch (error: unknown) {
        results.push({ serialNo: item.itemCode, status: 'FAIL', reason: this.message(error) });
      }
    }
    return {
      ok: results.filter(r => r.status === 'OK').length,
      skip: results.filter(r => r.status === 'SKIP').length,
      fail: results.filter(r => r.status === 'FAIL').length,
      results,
    };
  }

  private validateTeamFields(dto: ProductDestroyExecuteDto) {
    if (dto.team === '2' && (!dto.badCategory || !dto.occurProcessCode)) {
      throw new BadRequestException('생산2팀은 불량구분1과 발생공정을 골라야 합니다.');
    }
    // CHARGER 는 VARCHAR2(20 BYTE) — 한글은 글자당 3바이트
    if (Buffer.byteLength(dto.worker.trim(), 'utf8') > 20) {
      throw new BadRequestException('작업자 이름이 너무 깁니다. (한글 6자까지)');
    }
  }

  private async destroyOne(
    qr: QueryRunner,
    serialNo: string,
    dto: ProductDestroyExecuteDto,
    organizationId: number,
    userId: string,
    prices: Map<string, number | null>,
  ): Promise<DestroyOutcome> {
    // PB: dw_1.retrieve 결과가 있으면 이미 처리된 것으로 보고 건너뛴다
    const existing = await qr.query(
      `SELECT QC_SEQUENCE AS "qcSequence" FROM IP_PRODUCT_WORK_QC
        WHERE ORGANIZATION_ID = :organizationId AND SERIAL_NO = :serialNo
          AND RECEIPT_DEFICIT = '${DEFICIT_RECEIPT}'`,
      namedBinds({ organizationId, serialNo }),
    ) as OracleRow[];
    if (existing.length > 0) {
      return { serialNo, status: 'SKIP', reason: '이미 폐기 처리된 시리얼입니다.' };
    }

    // PB: IP_PRODUCT_2D_BARCODE 에서 품목/모델을 가져온다. 없으면 화면에서 고른 품번을 쓴다.
    const barcode = await qr.query(
      `SELECT DISTINCT ITEM_CODE AS "itemCode", MODEL_NAME AS "modelName", MODEL_SUFFIX AS "modelSuffix"
         FROM IP_PRODUCT_2D_BARCODE
        WHERE SERIAL_NO = :serialNo AND ORGANIZATION_ID = :organizationId`,
      namedBinds({ serialNo, organizationId }),
    ) as OracleRow[];
    let info: DestroyItemInfo | null = barcode.length > 0
      ? {
        itemCode: String(barcode[0].itemCode),
        modelName: (barcode[0].modelName as string | null) ?? null,
        modelSuffix: (barcode[0].modelSuffix as string | null) ?? null,
      }
      : null;
    if (!info && dto.fallbackItemCode) info = await this.loadItem(qr, dto.fallbackItemCode, organizationId);
    if (!info) {
      return { serialNo, status: 'FAIL', reason: '시리얼의 품목/모델 정보를 찾을 수 없습니다. 품번을 골라 주세요.' };
    }

    // PB: 최신 공정이력(MAX(WIP_SEQ))의 라인/공정. 화면에서 라인을 골랐으면 그 라인을 쓴다.
    const io = await qr.query(
      `SELECT LINE_CODE AS "lineCode", WORKSTAGE_CODE AS "workstageCode"
         FROM IP_PRODUCT_WORKSTAGE_IO
        WHERE SERIAL_NO = :serialNo
          AND WIP_SEQ = (SELECT MAX(WIP_SEQ) FROM IP_PRODUCT_WORKSTAGE_IO WHERE SERIAL_NO = :serialNo)`,
      namedBinds({ serialNo }),
    ) as OracleRow[];
    const lineCode = dto.lineCode?.trim() || String(io[0]?.lineCode ?? '*');
    const workstageCode = String(io[0]?.workstageCode ?? this.fallback(dto.fallbackWorkstageCode));

    const qcSequence = await this.nextSequence(qr);
    await this.insertDestroy(qr, { ...info, serialNo, qcSequence, qty: 1, lineCode, workstageCode }, dto, organizationId, userId, prices);
    return { serialNo, status: 'OK', qcSequence };
  }

  /** 바코드 미각인 제품 — 품번 + 수량으로 1행 */
  private async destroyItem(
    qr: QueryRunner,
    itemCode: string,
    qty: number,
    dto: ProductDestroyExecuteDto,
    organizationId: number,
    userId: string,
    prices: Map<string, number | null>,
  ): Promise<DestroyOutcome> {
    const info = await this.loadItem(qr, itemCode, organizationId);
    if (!info) return { serialNo: itemCode, status: 'FAIL', reason: '품번을 찾을 수 없습니다.' };
    const qcSequence = await this.nextSequence(qr);
    const serialNo = `${NO_SERIAL_PREFIX}${qcSequence}`;
    await this.insertDestroy(qr, {
      ...info, serialNo, qcSequence, qty,
      lineCode: dto.lineCode?.trim() || '*',
      workstageCode: this.fallback(dto.fallbackWorkstageCode),
    }, dto, organizationId, userId, prices);
    return { serialNo, status: 'OK', qcSequence };
  }

  private async loadItem(qr: QueryRunner, itemCode: string, organizationId: number): Promise<DestroyItemInfo | null> {
    const rows = await qr.query(
      `SELECT ITEM_CODE AS "itemCode", MODEL_NAME AS "modelName", MODEL_SUFFIX AS "modelSuffix"
         FROM ID_ITEM WHERE ITEM_CODE = :itemCode AND ORGANIZATION_ID = :organizationId`,
      namedBinds({ itemCode: itemCode.trim(), organizationId }),
    ) as OracleRow[];
    if (rows.length === 0) return null;
    return {
      itemCode: String(rows[0].itemCode),
      modelName: (rows[0].modelName as string | null) ?? null,
      modelSuffix: (rows[0].modelSuffix as string | null) ?? null,
    };
  }

  private async nextSequence(qr: QueryRunner): Promise<number> {
    const rows = await qr.query(`SELECT SEQ_QC_REPAIR_SEQUENCE.NEXTVAL AS "seq" FROM DUAL`) as OracleRow[];
    return Number(rows[0].seq);
  }

  /** 폐기 단가 — 구매단가, 없으면 BOM 말단 자재원가 합. 같은 요청 안에서는 품번별로 한 번만 계산한다 */
  private async unitPrice(qr: QueryRunner, itemCode: string, organizationId: number, cache: Map<string, number | null>) {
    if (cache.has(itemCode)) return cache.get(itemCode) ?? null;
    const rows = await qr.query(
      DESTROY_UNIT_PRICE_SQL,
      namedBinds({ itemCode, organizationId, baseDate: this.today() }),
    ) as OracleRow[];
    const own = rows[0]?.ownPrice;
    const bom = rows[0]?.bomPrice;
    const price = own != null ? Number(own) : bom != null ? Number(bom) : null;
    cache.set(itemCode, price);
    return price;
  }

  private async insertDestroy(
    qr: QueryRunner,
    row: DestroyRowInput,
    dto: ProductDestroyExecuteDto,
    organizationId: number,
    userId: string,
    prices: Map<string, number | null>,
  ) {
    const price = await this.unitPrice(qr, row.itemCode, organizationId, prices);
    const amount = price == null ? null : Math.round(price * row.qty * 100) / 100;
    await qr.query(
      `INSERT INTO IP_PRODUCT_WORK_QC (
         QC_SEQUENCE, SERIAL_NO, ORGANIZATION_ID,
         ITEM_CODE, MODEL_NAME, MODEL_SUFFIX,
         LINE_CODE, WORKSTAGE_CODE, MACHINE_CODE,
         REPAIR_LINE_CODE, REPAIR_WORKSTAGE_CODE, LOCATION_CODE,
         BAD_REASON_CODE, QC_RESULT, RECEIPT_DEFICIT, QC_INSPECT_HANDLING, DEPARTMENT_CODE,
         DESTROY_TEAM, DESTROY_PRODUCT_TYPE, DESTROY_BAD_CATEGORY, OCCUR_PROCESS_CODE, DETECT_PROCESS_CODE,
         BAD_CAUSE_BY, DESTROY_UNIT_PRICE, DESTROY_AMOUNT,
         BAD_QTY, DEFECT_QTY, QC_DATE, SHIFT_CODE,
         CHARGER, REPAIR_BY, ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE
       ) VALUES (
         :qcSequence, :serialNo, :organizationId,
         :itemCode, :modelName, :modelSuffix,
         :lineCode, :workstageCode, '*',
         '*', '*', '* *',
         :badReasonCode, 'N', '${DEFICIT_RECEIPT}', 'D', :departmentCode,
         :team, :productType, :badCategory, :occurProcessCode, :detectProcessCode,
         :causeBy, :unitPrice, :amount,
         :qty, :qty, SYSDATE, :shiftCode,
         :worker, :userId, :userId, SYSDATE, :userId, SYSDATE
       )`,
      namedBinds({
        qcSequence: row.qcSequence, serialNo: row.serialNo, organizationId,
        itemCode: row.itemCode, modelName: row.modelName, modelSuffix: row.modelSuffix,
        lineCode: row.lineCode, workstageCode: row.workstageCode,
        badReasonCode: dto.badReasonCode, departmentCode: dto.departmentCode,
        team: dto.team, productType: dto.productType,
        badCategory: dto.team === '2' ? dto.badCategory ?? null : null,
        occurProcessCode: dto.team === '2' ? dto.occurProcessCode ?? null : null,
        detectProcessCode: dto.detectProcessCode,
        causeBy: dto.causeBy, unitPrice: price, amount,
        qty: row.qty, shiftCode: dto.shiftCode, worker: dto.worker.trim(), userId,
      }),
    );
  }

  /**
   * 팀별 월 폐기 요약 — 불량유형별(코드 순, 0건 포함) · 주야별 · 원인별 수량과 금액.
   * 수량은 BAD_QTY 합이다 (품번 + 수량 등록은 1행에 여러 개).
   */
  async summary(query: ProductDestroySummaryQueryDto, organizationId: number) {
    const codeTypes = TEAM_CODE_TYPES[query.team];
    const scope = `qc.ORGANIZATION_ID = :organizationId AND qc.QC_INSPECT_HANDLING = 'D'
               AND qc.DESTROY_TEAM = :team
               AND qc.QC_DATE >= TO_DATE(:month || '-01', 'YYYY-MM-DD')
               AND qc.QC_DATE < ADD_MONTHS(TO_DATE(:month || '-01', 'YYYY-MM-DD'), 1)`;
    const binds = { organizationId, team: query.team, month: query.month };

    const byType = await this.dataSource.query(
      `SELECT c.CODE_NAME AS "code", c.CODE_MEAN_KOR AS "name",
              NVL(SUM(qc.BAD_QTY), 0) AS "qty", NVL(SUM(qc.DESTROY_AMOUNT), 0) AS "amount"
         FROM ISYS_BASECODE c
         LEFT JOIN IP_PRODUCT_WORK_QC qc
           ON qc.BAD_REASON_CODE = c.CODE_NAME AND ${scope}
        WHERE c.CODE_TYPE = :codeType AND c.ORGANIZATION_ID = :organizationId
        GROUP BY c.CODE_NAME, c.CODE_MEAN_KOR
        ORDER BY c.CODE_NAME`,
      namedBinds({ ...binds, codeType: codeTypes.badType }),
    ) as OracleRow[];
    const grouped = async (column: string) => await this.dataSource.query(
      `SELECT ${column} AS "key", NVL(SUM(qc.BAD_QTY), 0) AS "qty", NVL(SUM(qc.DESTROY_AMOUNT), 0) AS "amount"
         FROM IP_PRODUCT_WORK_QC qc WHERE ${scope} GROUP BY ${column}`,
      namedBinds(binds),
    ) as OracleRow[];
    const [shiftRows, causeRows] = await Promise.all([grouped('qc.SHIFT_CODE'), grouped('qc.BAD_CAUSE_BY')]);

    const bucket = (rows: OracleRow[], buckets: { key: string; name: string; match: (key: string) => boolean }[]) =>
      buckets.map(b => {
        const hit = rows.filter(r => b.match(String(r.key ?? '')));
        return {
          key: b.key,
          name: b.name,
          qty: hit.reduce((sum, r) => sum + Number(r.qty), 0),
          amount: hit.reduce((sum, r) => sum + Number(r.amount), 0),
        };
      });
    return {
      byType: byType.map(r => ({ code: String(r.code), name: String(r.name ?? r.code), qty: Number(r.qty), amount: Number(r.amount) })),
      byShift: bucket(shiftRows, [
        { key: 'A', name: '주간', match: key => key !== 'B' },
        { key: 'B', name: '야간', match: key => key === 'B' },
      ]),
      byCause: bucket(causeRows, [
        { key: 'E', name: '설비이상', match: key => key === 'E' },
        { key: 'S', name: '원자재', match: key => key === 'S' },
        { key: 'M', name: 'HUMAN', match: key => key !== 'E' && key !== 'S' },
      ]),
    };
  }

  /** PB cb_4(Issue) — 반품 처리 */
  async issue(dto: ProductDestroyIssueDto, organizationId: number) {
    return this.toggleDeficit(dto, organizationId, DEFICIT_ISSUE, 'SYSDATE');
  }

  /** PB cb_5(Issue Cancel) — 반품 취소. 원본과 달리 QC_SEQUENCE 로 1건만 되돌린다. */
  async issueCancel(dto: ProductDestroyIssueDto, organizationId: number) {
    return this.toggleDeficit(dto, organizationId, DEFICIT_RECEIPT, 'NULL');
  }

  private async toggleDeficit(
    dto: ProductDestroyIssueDto,
    organizationId: number,
    deficit: string,
    repairDate: 'SYSDATE' | 'NULL',
  ) {
    const key = { serialNo: dto.serialNo, qcSequence: dto.qcSequence, organizationId };
    const found = await this.dataSource.query(
      `SELECT RECEIPT_DEFICIT AS "deficit" FROM IP_PRODUCT_WORK_QC
        WHERE SERIAL_NO = :serialNo AND QC_SEQUENCE = :qcSequence AND ORGANIZATION_ID = :organizationId`,
      namedBinds(key),
    ) as OracleRow[];
    if (found.length === 0) throw new BadRequestException('대상 이력을 찾을 수 없습니다.');
    if (found[0].deficit === deficit) throw new BadRequestException('이미 해당 상태입니다.');

    await this.dataSource.query(
      `UPDATE IP_PRODUCT_WORK_QC
          SET RECEIPT_DEFICIT = '${deficit}', REPAIR_DATE = ${repairDate}
        WHERE SERIAL_NO = :serialNo AND QC_SEQUENCE = :qcSequence AND ORGANIZATION_ID = :organizationId`,
      namedBinds(key),
    );
    return { serialNo: dto.serialNo, qcSequence: dto.qcSequence, receiptDeficit: deficit };
  }

  private selectList(): string {
    return `
      SELECT qc.QC_SEQUENCE AS "qcSequence",
             qc.SERIAL_NO AS "serialNo",
             qc.ITEM_CODE AS "itemCode",
             qc.MODEL_NAME AS "modelName",
             qc.MODEL_SUFFIX AS "modelSuffix",
             qc.LINE_CODE AS "lineCode",
             qc.WORKSTAGE_CODE AS "workstageCode",
             qc.BAD_REASON_CODE AS "badReasonCode",
             NVL((SELECT MAX(b.CODE_MEAN_KOR) FROM ISYS_BASECODE b
                   WHERE b.CODE_TYPE IN ('DESTROY BAD TYPE SMT', 'DESTROY BAD TYPE ASSY')
                     AND b.CODE_NAME = qc.BAD_REASON_CODE AND b.ORGANIZATION_ID = qc.ORGANIZATION_ID),
                 (SELECT MAX(m.CODE_MEAN_KOR) FROM ISYS_CODE_MASTER m
                   WHERE m.CODE_TYPE = 'WQC BAD REASON CODE' AND m.CODE_NAME = qc.BAD_REASON_CODE)) AS "badReasonName",
             qc.DESTROY_TEAM AS "destroyTeam",
             qc.DESTROY_PRODUCT_TYPE AS "destroyProductType",
             qc.DESTROY_BAD_CATEGORY AS "destroyBadCategory",
             qc.OCCUR_PROCESS_CODE AS "occurProcessCode",
             ${this.processName('qc.OCCUR_PROCESS_CODE')} AS "occurProcessName",
             qc.DETECT_PROCESS_CODE AS "detectProcessCode",
             ${this.processName('qc.DETECT_PROCESS_CODE')} AS "detectProcessName",
             qc.BAD_CAUSE_BY AS "badCauseBy",
             qc.DESTROY_UNIT_PRICE AS "destroyUnitPrice",
             qc.DESTROY_AMOUNT AS "destroyAmount",
             qc.QC_RESULT AS "qcResult",
             qc.RECEIPT_DEFICIT AS "receiptDeficit",
             qc.QC_INSPECT_HANDLING AS "qcInspectHandling",
             qc.DEPARTMENT_CODE AS "departmentCode",
             (SELECT d.DEPARTMENT_NAME_KOR FROM ISYS_DEPARTMENT d
               WHERE d.DEPARTMENT_CODE = qc.DEPARTMENT_CODE AND d.ORGANIZATION_ID = qc.ORGANIZATION_ID) AS "departmentName",
             qc.BAD_QTY AS "badQty",
             qc.DEFECT_QTY AS "defectQty",
             qc.QC_DATE AS "qcDate",
             qc.REPAIR_DATE AS "repairDate",
             qc.SHIFT_CODE AS "shiftCode",
             qc.CHARGER AS "charger",
             qc.REPAIR_BY AS "repairBy",
             qc.LOCATION_CODE AS "locationCode",
             qc.COMMENTS AS "comments",
             qc.ENTER_BY AS "enterBy",
             qc.ENTER_DATE AS "enterDate",
             qc.ORGANIZATION_ID AS "organizationId"`;
  }

  /** 팀별 공정 코드형에서 이름을 찾는다 */
  private processName(column: string): string {
    return `(SELECT MAX(b.CODE_MEAN_KOR) FROM ISYS_BASECODE b
              WHERE b.CODE_TYPE = DECODE(qc.DESTROY_TEAM, '1', '${TEAM_CODE_TYPES['1'].process}', '${TEAM_CODE_TYPES['2'].process}')
                AND b.CODE_NAME = ${column} AND b.ORGANIZATION_ID = qc.ORGANIZATION_ID)`;
  }

  /** 서버 시각은 KST 고정(main.ts) — 오늘 'YYYY-MM-DD' */
  private today(): string {
    const now = new Date();
    return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`;
  }

  /** PB: 드롭다운이 비었거나 전체('%')면 '*' 를 쓴다 */
  private fallback(value?: string): string {
    const trimmed = value?.trim();
    return !trimmed || trimmed === '%' ? '*' : trimmed;
  }

  private like(value?: string): string {
    const trimmed = value?.trim();
    return trimmed ? `${trimmed}%` : '%';
  }

  private message(error: unknown): string {
    if (error instanceof BadRequestException) return error.message;
    return error instanceof Error ? error.message : '알 수 없는 오류';
  }
}
