/**
 * @file src/modules/quality/services/product-destroy.service.ts
 * @description 공정폐기관리 — PB w_pln_product_pcb_destroy_master 이식
 *
 * 폐기는 **공정폐기 원장(IP_PRODUCT_DESTROY)** 에 쌓는다 (2026-10-27).
 * PB 는 수리판정 테이블 IP_PRODUCT_WORK_QC 에 검사처리 'D' 행을 넣었지만,
 * 사용자 지시("WORK_QC 는 수리판정일 뿐이고 폐기이력은 따로 재고처럼 모아야")로 원장을 따로 둔다.
 * 이 서비스는 IP_PRODUCT_WORK_QC 를 읽지도 쓰지도 않는다 (옛 D 행은 마이그레이션이 원장으로 옮겼다).
 *
 * 원장 한 행 = 폐기 1건. 상태(DESTROY_STATUS)로 재고처럼 관리한다.
 *   D 폐기보관(폐기 재고) → R 반품(재고에서 나감) — 반품취소로 D 로 되돌린다
 *   C 취소 — 잘못 등록한 폐기. 행은 지우지 않고 취소일시·취소자·사유를 남긴다.
 *            폐기현황 집계와 폐기 재고에서 빠진다.
 *
 * 2026-10-22 요청(MES 개선요청사항 26.10.22):
 * - 팀(생산1팀 SMT / 생산2팀 조립)마다 다른 불량 양식 — 불량유형·제품구분·주야·원인·발생/검출공정·작업자.
 * - 바코드 미각인 제품은 품번 + 수량으로 등록한다 (시리얼 칸은 비운다).
 * - 등록 시점 단가·금액을 남긴다: 구매단가가 있으면 그것, 없으면 BOM 말단 자재원가 합.
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource, QueryRunner } from 'typeorm';
import { parseDateStart } from '../../../shared/date.util';
import { TransactionService } from '../../../shared/transaction.service';
import {
  ProductDestroyCancelDto,
  ProductDestroyExecuteDto,
  ProductDestroyHistoryQueryDto,
  ProductDestroyIssueDto,
  ProductDestroySummaryQueryDto,
} from '../dto/product-destroy.dto';
import { namedBinds } from '../../../common/utils/named-binds.util';
import { DESTROY_UNIT_PRICE_SQL } from './destroy-price.sql';

type OracleRow = Record<string, unknown>;

/** 원장 상태 (공통코드 DESTROY STATUS) */
export const DESTROY_STATUS = { stored: 'D', returned: 'R', cancelled: 'C' } as const;

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
  serialNo: string | null;
  destroySeq: number;
  qty: number;
  lineCode: string;
  workstageCode: string;
}

export interface DestroyOutcome {
  /** 시리얼, 품번 등록이면 품번 */
  serialNo: string;
  status: 'OK' | 'SKIP' | 'FAIL';
  reason?: string;
  destroySeq?: number;
}

@Injectable()
export class ProductDestroyService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  /** 폐기이력 — 상태를 고르지 않으면 취소까지 모두 보인다 */
  async findHistory(query: ProductDestroyHistoryQueryDto, organizationId: number) {
    const binds: Record<string, unknown> = {
      organizationId,
      lineCode: this.like(query.lineCode),
      workstageCode: this.like(query.workstageCode),
      modelName: this.like(query.modelName),
      serialNo: this.like(query.serialNo),
      team: query.team ?? null,
      status: query.status ?? null,
      dateFrom: parseDateStart(query.dateFrom) ?? new Date(1900, 0, 1),
      dateTo: parseDateStart(query.dateTo) ?? new Date(9999, 11, 30),
    };
    const from = `
      FROM IP_PRODUCT_DESTROY d
      WHERE d.ORGANIZATION_ID = :organizationId
        AND NVL(d.LINE_CODE, '*') LIKE :lineCode
        AND NVL(d.WORKSTAGE_CODE, '*') LIKE :workstageCode
        AND NVL(d.MODEL_NAME, '*') LIKE :modelName
        AND NVL(d.SERIAL_NO, '*') LIKE :serialNo
        AND (:team IS NULL OR d.DESTROY_TEAM = :team)
        AND (:status IS NULL OR d.DESTROY_STATUS = :status)
        AND d.DESTROY_DATE >= :dateFrom
        AND d.DESTROY_DATE < :dateTo + 1`;
    const offset = (query.page - 1) * query.limit;
    const rows = await this.dataSource.query(
      `${this.selectList()} ${from}
       ORDER BY d.DESTROY_DATE DESC, d.DESTROY_SEQ DESC
       OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`,
      namedBinds({ ...binds, offset, limit: query.limit }),
    ) as OracleRow[];
    const totals = await this.dataSource.query(
      `SELECT COUNT(*) AS "total" ${from}`, namedBinds({ ...binds }),
    ) as OracleRow[];
    return { data: rows, total: Number(totals[0]?.total ?? 0), page: query.page, limit: query.limit };
  }

  /** PB dw_1 / dw_2 — 시리얼 하나의 폐기보관(D) / 반품(R) 현황 */
  async findBySerial(serialNo: string, organizationId: number) {
    const load = async (status: string): Promise<OracleRow[]> => await this.dataSource.query(
      `${this.selectList()}
       FROM IP_PRODUCT_DESTROY d
       WHERE d.ORGANIZATION_ID = :organizationId
         AND d.SERIAL_NO = :serialNo
         AND d.DESTROY_STATUS = '${status}'
       ORDER BY d.DESTROY_SEQ`,
      namedBinds({ organizationId, serialNo: serialNo.trim().toUpperCase() }),
    ) as OracleRow[];
    const [destroyList, issueList] = await Promise.all([load(DESTROY_STATUS.stored), load(DESTROY_STATUS.returned)]);
    return { destroyList, issueList };
  }

  /**
   * PB cb_2(Destroy) — 시리얼 목록을 순회하며 폐기를 등록한다.
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
    // WORKER_NAME 은 VARCHAR2(20 BYTE) — 한글은 글자당 3바이트
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
    // 취소되지 않은 폐기(보관·반품)가 있으면 이미 처리된 시리얼이다
    const existing = await qr.query(
      `SELECT DESTROY_SEQ AS "destroySeq" FROM IP_PRODUCT_DESTROY
        WHERE ORGANIZATION_ID = :organizationId AND SERIAL_NO = :serialNo
          AND DESTROY_STATUS <> '${DESTROY_STATUS.cancelled}'`,
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

    const destroySeq = await this.nextSequence(qr);
    await this.insertDestroy(qr, { ...info, serialNo, destroySeq, qty: 1, lineCode, workstageCode }, dto, organizationId, userId, prices);
    return { serialNo, status: 'OK', destroySeq };
  }

  /** 바코드 미각인 제품 — 품번 + 수량으로 1행, 시리얼은 비운다 */
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
    const destroySeq = await this.nextSequence(qr);
    await this.insertDestroy(qr, {
      ...info, serialNo: null, destroySeq, qty,
      lineCode: dto.lineCode?.trim() || '*',
      workstageCode: this.fallback(dto.fallbackWorkstageCode),
    }, dto, organizationId, userId, prices);
    return { serialNo: itemCode, status: 'OK', destroySeq };
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
    const rows = await qr.query(`SELECT SEQ_IP_PRODUCT_DESTROY.NEXTVAL AS "seq" FROM DUAL`) as OracleRow[];
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
      `INSERT INTO IP_PRODUCT_DESTROY (
         DESTROY_SEQ, ORGANIZATION_ID, DESTROY_DATE, DESTROY_STATUS,
         SERIAL_NO, ITEM_CODE, MODEL_NAME, MODEL_SUFFIX, DESTROY_QTY,
         LINE_CODE, WORKSTAGE_CODE,
         DESTROY_TEAM, BAD_REASON_CODE, DESTROY_PRODUCT_TYPE, DESTROY_BAD_CATEGORY,
         OCCUR_PROCESS_CODE, DETECT_PROCESS_CODE, BAD_CAUSE_BY, SHIFT_CODE, DEPARTMENT_CODE, WORKER_NAME,
         UNIT_PRICE, DESTROY_AMOUNT,
         ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE
       ) VALUES (
         :destroySeq, :organizationId, SYSDATE, '${DESTROY_STATUS.stored}',
         :serialNo, :itemCode, :modelName, :modelSuffix, :qty,
         :lineCode, :workstageCode,
         :team, :badReasonCode, :productType, :badCategory,
         :occurProcessCode, :detectProcessCode, :causeBy, :shiftCode, :departmentCode, :worker,
         :unitPrice, :amount,
         :userId, SYSDATE, :userId, SYSDATE
       )`,
      namedBinds({
        destroySeq: row.destroySeq, organizationId,
        serialNo: row.serialNo, itemCode: row.itemCode, modelName: row.modelName, modelSuffix: row.modelSuffix, qty: row.qty,
        lineCode: row.lineCode, workstageCode: row.workstageCode,
        team: dto.team, badReasonCode: dto.badReasonCode, productType: dto.productType,
        badCategory: dto.team === '2' ? dto.badCategory ?? null : null,
        occurProcessCode: dto.team === '2' ? dto.occurProcessCode ?? null : null,
        detectProcessCode: dto.detectProcessCode, causeBy: dto.causeBy, shiftCode: dto.shiftCode,
        departmentCode: dto.departmentCode, worker: dto.worker.trim(),
        unitPrice: price, amount, userId,
      }),
    );
  }

  /**
   * 팀별 월 폐기 요약 — 불량유형별(코드 순, 0건 포함) · 주야별 · 원인별 수량과 금액.
   * 취소(C)는 빼고, 수량은 DESTROY_QTY 합이다 (품번 + 수량 등록은 1행에 여러 개).
   */
  async summary(query: ProductDestroySummaryQueryDto, organizationId: number) {
    const codeTypes = TEAM_CODE_TYPES[query.team];
    const scope = `d.ORGANIZATION_ID = :organizationId AND d.DESTROY_STATUS <> '${DESTROY_STATUS.cancelled}'
               AND d.DESTROY_TEAM = :team
               AND d.DESTROY_DATE >= TO_DATE(:month || '-01', 'YYYY-MM-DD')
               AND d.DESTROY_DATE < ADD_MONTHS(TO_DATE(:month || '-01', 'YYYY-MM-DD'), 1)`;
    const binds = () => ({ organizationId, team: query.team, month: query.month });

    const byType = await this.dataSource.query(
      `SELECT c.CODE_NAME AS "code", c.CODE_MEAN_KOR AS "name",
              NVL(SUM(d.DESTROY_QTY), 0) AS "qty", NVL(SUM(d.DESTROY_AMOUNT), 0) AS "amount"
         FROM ISYS_BASECODE c
         LEFT JOIN IP_PRODUCT_DESTROY d
           ON d.BAD_REASON_CODE = c.CODE_NAME AND ${scope}
        WHERE c.CODE_TYPE = :codeType AND c.ORGANIZATION_ID = :organizationId
        GROUP BY c.CODE_NAME, c.CODE_MEAN_KOR
        ORDER BY c.CODE_NAME`,
      namedBinds({ ...binds(), codeType: codeTypes.badType }),
    ) as OracleRow[];
    const grouped = async (column: string) => await this.dataSource.query(
      `SELECT ${column} AS "key", NVL(SUM(d.DESTROY_QTY), 0) AS "qty", NVL(SUM(d.DESTROY_AMOUNT), 0) AS "amount"
         FROM IP_PRODUCT_DESTROY d WHERE ${scope} GROUP BY ${column}`,
      namedBinds(binds()),
    ) as OracleRow[];
    const [shiftRows, causeRows] = await Promise.all([grouped('d.SHIFT_CODE'), grouped('d.BAD_CAUSE_BY')]);

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

  /** PB cb_4(Issue) — 반품 처리: 폐기보관(D) → 반품(R) */
  async issue(dto: ProductDestroyIssueDto, organizationId: number, userId: string) {
    return this.changeStatus(dto.destroySeq, organizationId, DESTROY_STATUS.stored, DESTROY_STATUS.returned,
      'RETURN_DATE = SYSDATE, RETURN_BY = :userId', userId, '반품할 수 있는 폐기보관 건이 아닙니다.');
  }

  /** PB cb_5(Issue Cancel) — 반품 취소: 반품(R) → 폐기보관(D) */
  async issueCancel(dto: ProductDestroyIssueDto, organizationId: number, userId: string) {
    return this.changeStatus(dto.destroySeq, organizationId, DESTROY_STATUS.returned, DESTROY_STATUS.stored,
      'RETURN_DATE = NULL, RETURN_BY = NULL', userId, '반품된 건이 아닙니다.');
  }

  private async changeStatus(
    destroySeq: number,
    organizationId: number,
    from: string,
    to: string,
    setExtra: string,
    userId: string,
    notFound: string,
  ) {
    return this.tx.run(async qr => {
      const found = await qr.query(
        `SELECT DESTROY_STATUS AS "status" FROM IP_PRODUCT_DESTROY
          WHERE DESTROY_SEQ = :destroySeq AND ORGANIZATION_ID = :organizationId FOR UPDATE`,
        namedBinds({ destroySeq, organizationId }),
      ) as OracleRow[];
      if (found.length === 0) throw new BadRequestException('대상 폐기 건을 찾을 수 없습니다.');
      if (found[0].status !== from) throw new BadRequestException(notFound);
      await qr.query(
        `UPDATE IP_PRODUCT_DESTROY
            SET DESTROY_STATUS = '${to}', ${setExtra}, LAST_MODIFY_BY = :userId, LAST_MODIFY_DATE = SYSDATE
          WHERE DESTROY_SEQ = :destroySeq AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ destroySeq, organizationId, userId }),
      );
      return { destroySeq, destroyStatus: to };
    });
  }

  /**
   * 폐기 취소 — 잘못 등록한 폐기를 취소(C)로 바꾼다. 행은 지우지 않는다.
   * 이미 취소된 건은 건너뛴다. 폐기현황 집계와 폐기 재고에서 빠지고, 같은 시리얼을 다시 폐기할 수 있다.
   */
  async cancel(dto: ProductDestroyCancelDto, organizationId: number, userId: string) {
    const sequences = [...new Set(dto.destroySeqs)];
    if (sequences.length === 0) throw new BadRequestException('취소할 폐기 건을 고르세요.');
    const reason = dto.reason.trim();
    const where = `ORGANIZATION_ID = :organizationId AND DESTROY_STATUS <> '${DESTROY_STATUS.cancelled}'
                   AND DESTROY_SEQ IN (${sequences.map((_, index) => `:seq${index}`).join(', ')})`;
    // 드라이버가 bind 객체를 바꾸므로 호출마다 새로 만든다
    const keyBinds = () => ({ organizationId, ...Object.fromEntries(sequences.map((seq, index) => [`seq${index}`, seq])) });

    return this.tx.run(async qr => {
      const found = await qr.query(
        `SELECT DESTROY_SEQ AS "destroySeq" FROM IP_PRODUCT_DESTROY WHERE ${where} FOR UPDATE`,
        namedBinds(keyBinds()),
      ) as OracleRow[];
      if (found.length === 0) throw new BadRequestException('취소할 폐기 건이 없습니다. 이미 취소됐는지 확인하세요.');
      await qr.query(
        `UPDATE IP_PRODUCT_DESTROY
            SET DESTROY_STATUS = '${DESTROY_STATUS.cancelled}', CANCEL_DATE = SYSDATE, CANCEL_BY = :userId,
                CANCEL_REASON = :reason, LAST_MODIFY_BY = :userId, LAST_MODIFY_DATE = SYSDATE
          WHERE ${where}`,
        namedBinds({ ...keyBinds(), userId, reason }),
      );
      return { cancelled: found.length, skipped: sequences.length - found.length };
    });
  }

  private selectList(): string {
    return `
      SELECT d.DESTROY_SEQ AS "destroySeq",
             d.DESTROY_STATUS AS "destroyStatus",
             d.DESTROY_DATE AS "destroyDate",
             d.SERIAL_NO AS "serialNo",
             d.ITEM_CODE AS "itemCode",
             d.MODEL_NAME AS "modelName",
             d.MODEL_SUFFIX AS "modelSuffix",
             d.DESTROY_QTY AS "destroyQty",
             d.LINE_CODE AS "lineCode",
             d.WORKSTAGE_CODE AS "workstageCode",
             d.BAD_REASON_CODE AS "badReasonCode",
             NVL((SELECT MAX(b.CODE_MEAN_KOR) FROM ISYS_BASECODE b
                   WHERE b.CODE_TYPE IN ('DESTROY BAD TYPE SMT', 'DESTROY BAD TYPE ASSY')
                     AND b.CODE_NAME = d.BAD_REASON_CODE AND b.ORGANIZATION_ID = d.ORGANIZATION_ID),
                 (SELECT MAX(m.CODE_MEAN_KOR) FROM ISYS_CODE_MASTER m
                   WHERE m.CODE_TYPE = 'WQC BAD REASON CODE' AND m.CODE_NAME = d.BAD_REASON_CODE)) AS "badReasonName",
             d.DESTROY_TEAM AS "destroyTeam",
             d.DESTROY_PRODUCT_TYPE AS "destroyProductType",
             d.DESTROY_BAD_CATEGORY AS "destroyBadCategory",
             d.OCCUR_PROCESS_CODE AS "occurProcessCode",
             ${this.processName('d.OCCUR_PROCESS_CODE')} AS "occurProcessName",
             d.DETECT_PROCESS_CODE AS "detectProcessCode",
             ${this.processName('d.DETECT_PROCESS_CODE')} AS "detectProcessName",
             d.BAD_CAUSE_BY AS "badCauseBy",
             d.SHIFT_CODE AS "shiftCode",
             d.DEPARTMENT_CODE AS "departmentCode",
             (SELECT p.DEPARTMENT_NAME_KOR FROM ISYS_DEPARTMENT p
               WHERE p.DEPARTMENT_CODE = d.DEPARTMENT_CODE AND p.ORGANIZATION_ID = d.ORGANIZATION_ID) AS "departmentName",
             d.WORKER_NAME AS "workerName",
             d.UNIT_PRICE AS "unitPrice",
             d.DESTROY_AMOUNT AS "destroyAmount",
             d.RETURN_DATE AS "returnDate",
             d.RETURN_BY AS "returnBy",
             d.CANCEL_DATE AS "cancelDate",
             d.CANCEL_BY AS "cancelBy",
             d.CANCEL_REASON AS "cancelReason",
             d.COMMENTS AS "comments",
             d.ENTER_BY AS "enterBy",
             d.ENTER_DATE AS "enterDate"`;
  }

  /** 팀별 공정 코드형에서 이름을 찾는다 */
  private processName(column: string): string {
    return `(SELECT MAX(b.CODE_MEAN_KOR) FROM ISYS_BASECODE b
              WHERE b.CODE_TYPE = DECODE(d.DESTROY_TEAM, '1', '${TEAM_CODE_TYPES['1'].process}', '${TEAM_CODE_TYPES['2'].process}')
                AND b.CODE_NAME = ${column} AND b.ORGANIZATION_ID = d.ORGANIZATION_ID)`;
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
