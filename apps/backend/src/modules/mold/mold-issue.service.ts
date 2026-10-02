/**
 * @file src/modules/mold/mold-issue.service.ts
 * @description S-PARTS 출고 — PB w_mcn_mold_issue_master 이식
 *
 * 초보자 가이드:
 * 1. **출고 경로가 두 개다. PB 가 쓰는 시퀀스도 다르다.**
 *    - 재고에서 바로 출고 → `SEQ_MAT_ISSUE`
 *    - 청구건을 보고 출고  → `SEQ_MOLD_ISSUE_SEQUENCE`, 그리고 청구를 완료('C')로 바꾼다
 *    한 컬럼에 두 시퀀스를 섞는 게 이상해 보이지만 PB 그대로다. 웹에서 하나로 합치면
 *    PB 화면과 번호가 갈리므로 건드리지 않았다.
 * 2. **PB 기본값**: 출고일=오늘, 출고구분='3'(3출고), 출고상태='N'(정상).
 * 3. **출고계정은 필수다.** PB 는 비었거나 '%' 면 진행하지 않았다. 웹은 400 으로 막는다.
 * 4. **목록은 취소건을 뺀다** — PB 가 `ISSUE_STATUS <> 'C'` 조건을 걸었다.
 *    취소 이력은 재고관리 화면의 출고이력에서 본다.
 * 5. **취소는 행을 지우지 않는다.** PKG_MES_MAC.SP_MOLD_ISSUE_CANCEL 이
 *    원본을 'C' 로 바꾸고, 청구를 미처리('R')로 되돌리고, 상계행을 새로 넣는다.
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { TransactionService } from '../../shared/transaction.service';
import {
  MoldIssueCancelDto,
  MoldIssueCreateDto,
  MoldIssueFromRequestDto,
  MoldIssueQueryDto,
  MoldIssueRequestQueryDto,
  MoldIssueTargetQueryDto,
} from './mold-issue.dto';
import { namedBinds } from '../../common/utils/named-binds.util';

type OracleRow = Record<string, unknown>;

@Injectable()
export class MoldIssueService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  private like(value?: string): string {
    return `${(value ?? '').trim()}%`;
  }

  /** 목록 — PB d_mcn_mold_issue_lst (취소건 제외) */
  async find(query: MoldIssueQueryDto, organizationId: number) {
    const binds = {
      organizationId,
      dateFrom: query.dateFrom.slice(0, 10),
      dateTo: query.dateTo.slice(0, 10),
      moldCode: this.like(query.moldCode),
    };
    const body = `
      SELECT i.ISSUE_DATE AS "issueDate", i.ISSUE_SEQUENCE AS "issueSequence",
             i.MOLD_CODE AS "moldCode",
             m.MOLD_NAME AS "moldName", m.MOLD_SPEC AS "moldSpec",
             i.MOLD_VERSION AS "moldVersion", i.MOLD_SET_SERIAL AS "moldSetSerial",
             i.ISSUE_DEFICIT AS "issueDeficit", dft.CODE_MEAN_KOR AS "issueDeficitName",
             i.ISSUE_QTY AS "issueQty", i.ISSUE_PRICE AS "issuePrice",
             i.ISSUE_AMT AS "issueAmt",
             i.CURRENCY AS "currency", cur.CODE_MEAN_KOR AS "currencyName",
             i.ISSUE_STATUS AS "issueStatus", stt.CODE_MEAN_KOR AS "issueStatusName",
             i.MOLD_ISSUE_ACCOUNT AS "moldIssueAccount",
             acc.CODE_MEAN_KOR AS "moldIssueAccountName",
             i.WORKSTAGE_CODE AS "workstageCode", ws.WORKSTAGE_NAME AS "workstageName",
             i.LINE_CODE AS "lineCode", ln.LINE_NAME AS "lineName",
             i.MACHINE_CODE AS "machineCode", i.LOCATION_CODE AS "locationCode",
             i.SUPPLIER_CODE AS "supplierCode", sup.SUPPLIER_NAME AS "supplierName",
             i.LINE_TYPE AS "lineType", lnt.CODE_MEAN_KOR AS "lineTypeName",
             i.ENTER_BY AS "enterBy", i.ENTER_DATE AS "enterDate",
             i.LAST_MODIFY_BY AS "lastModifyBy", i.LAST_MODIFY_DATE AS "lastModifyDate"
        FROM IMCN_MOLD_ISSUE i
        LEFT JOIN IMCN_MOLD m
               ON m.MOLD_CODE = i.MOLD_CODE AND m.ORGANIZATION_ID = i.ORGANIZATION_ID
        LEFT JOIN ICOM_SUPPLIER sup
               ON sup.SUPPLIER_CODE = i.SUPPLIER_CODE
              AND sup.ORGANIZATION_ID = i.ORGANIZATION_ID
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
        LEFT JOIN ISYS_BASECODE cur
               ON cur.CODE_TYPE = 'CURRENCY' AND cur.CODE_NAME = i.CURRENCY
              AND cur.ORGANIZATION_ID = i.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE lnt
               ON lnt.CODE_TYPE = 'LINE TYPE' AND lnt.CODE_NAME = i.LINE_TYPE
              AND lnt.ORGANIZATION_ID = i.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE acc
               ON acc.CODE_TYPE = 'MOLD ISSUE ACCOUNT'
              AND acc.CODE_NAME = i.MOLD_ISSUE_ACCOUNT
              AND acc.ORGANIZATION_ID = i.ORGANIZATION_ID
       WHERE i.ISSUE_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
         AND i.ISSUE_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
         AND i.MOLD_CODE LIKE :moldCode
         AND i.ISSUE_STATUS <> 'C'
         AND i.ORGANIZATION_ID = :organizationId`;
    const page = query.page ?? 1;
    const limit = query.limit ?? 500;
    const totals = await this.dataSource.query(
      `SELECT COUNT(*) AS "total" FROM (${body}) source_rows`,
      namedBinds({ ...binds }),
    ) as OracleRow[];
    const rows = await this.dataSource.query(
      `${body} ORDER BY "issueDate" DESC, "issueSequence" DESC
       OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`,
      namedBinds({ ...binds, offset: (page - 1) * limit, limit }),
    ) as OracleRow[];
    return { data: rows, total: Number(totals[0]?.total ?? 0), page, limit };
  }

  /**
   * 출고 대상 재고 — PB d_mcn_mold_inventory_4_issue_lst.
   * PB 는 출고수량 기본값을 1 로 두고 시작한다(COMPUTE `1 ISSUE_QTY`). 그 값을 같이 내린다.
   */
  async findTargets(query: MoldIssueTargetQueryDto, organizationId: number) {
    return this.dataSource.query<OracleRow[]>(
      `SELECT m.MOLD_CODE AS "moldCode", m.MOLD_NAME AS "moldName",
              m.MOLD_SPEC AS "moldSpec", m.DRAWING_NO AS "drawingNo",
              m.MOLD_GROUP AS "moldGroup", grp.CODE_MEAN_KOR AS "moldGroupName",
              m.MOLD_TYPE AS "moldType", mtp.CODE_MEAN_KOR AS "moldTypeName",
              m.SUPPLIER_CODE AS "supplierCode", sup.SUPPLIER_NAME AS "supplierName",
              m.SAFETY_INVENTORY AS "safetyInventory",
              1 AS "issueQty",
              inv.INVENTORY_QTY AS "inventoryQty",
              inv.MOLD_VERSION AS "moldVersion", inv.MOLD_SET_SERIAL AS "moldSetSerial",
              inv.MOLD_ROW_QTY AS "moldRowQty",
              inv.MOLD_USEFULL_ROW_QTY AS "moldUsefullRowQty",
              inv.MOLD_USE_STATUS AS "moldUseStatus", ust.CODE_MEAN_KOR AS "moldUseStatusName",
              inv.MOLD_IN_OUT AS "moldInOut", mio.CODE_MEAN_KOR AS "moldInOutName",
              inv.MOLD_WAREHOUSE_CODE AS "moldWarehouseCode",
              inv.LOCATION_CODE AS "locationCode",
              inv.BREAK_VALUE AS "breakValue", inv.ACTUAL_VALUE AS "actualValue",
              inv.MACHINE_CODE AS "machineCode", inv.WORKSTAGE_CODE AS "workstageCode",
              inv.LINE_CODE AS "lineCode",
              PKG_MES_MAC.F_GET_MOLD_UNIT_PRICE(
                m.SUPPLIER_CODE, m.MOLD_CODE, m.ORGANIZATION_ID) AS "unitPrice"
         FROM IMCN_MOLD m
         JOIN IMCN_MOLD_INVENTORY inv
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
         LEFT JOIN ISYS_BASECODE ust
                ON ust.CODE_TYPE = 'MOLD USE STATUS' AND ust.CODE_NAME = inv.MOLD_USE_STATUS
               AND ust.ORGANIZATION_ID = inv.ORGANIZATION_ID
         LEFT JOIN ISYS_BASECODE mio
                ON mio.CODE_TYPE = 'MOLD IN OUT' AND mio.CODE_NAME = inv.MOLD_IN_OUT
               AND mio.ORGANIZATION_ID = inv.ORGANIZATION_ID
        WHERE m.MOLD_CODE LIKE :moldCode
          AND NVL(m.SUPPLIER_CODE, '*') LIKE :supplierCode
          AND NVL(inv.MOLD_USE_STATUS, '*') LIKE :moldUseStatus
          AND m.MOLD_CODE <> '*'
          AND m.ORGANIZATION_ID = :organizationId
        ORDER BY m.MOLD_CODE, inv.MOLD_VERSION, inv.MOLD_SET_SERIAL`,
      namedBinds({
        moldCode: this.like(query.moldCode),
        supplierCode: this.like(query.supplierCode),
        moldUseStatus: this.like(query.moldUseStatus),
        organizationId,
      }),
    );
  }

  /**
   * 출고 가능한 청구 — PB d_mcn_mold_request_4_issue_lst.
   * 미처리 청구('R')만 보고, 재고를 버전·SET번호까지 맞춰 붙인다.
   */
  async findRequests(query: MoldIssueRequestQueryDto, organizationId: number) {
    return this.dataSource.query<OracleRow[]>(
      `SELECT r.MOLD_CODE AS "moldCode",
              m.MOLD_NAME AS "moldName", m.MOLD_SPEC AS "moldSpec",
              r.MOLD_VERSION AS "moldVersion", r.MOLD_SET_SERIAL AS "moldSetSerial",
              r.REQUEST_DATE AS "requestDate", r.REQUEST_SEQUENCE AS "requestSequence",
              r.REQUEST_QTY AS "requestQty",
              r.REQUEST_STATUS AS "requestStatus", stt.CODE_MEAN_KOR AS "requestStatusName",
              r.ISSUE_DATE AS "issueDate", r.ISSUE_SEQUENCE AS "issueSequence",
              r.ISSUE_QTY AS "issueQty",
              inv.INVENTORY_QTY AS "inventoryQty", inv.LOCATION_CODE AS "locationCode",
              inv.SUPPLIER_CODE AS "supplierCode",
              r.ENTER_BY AS "enterBy", r.ENTER_DATE AS "enterDate"
         FROM IMCN_MOLD_REQUEST r
         JOIN IMCN_MOLD_INVENTORY inv
           ON inv.MOLD_CODE = r.MOLD_CODE
          AND inv.ORGANIZATION_ID = r.ORGANIZATION_ID
          AND inv.MOLD_VERSION = r.MOLD_VERSION
          AND inv.MOLD_SET_SERIAL = r.MOLD_SET_SERIAL
         LEFT JOIN IMCN_MOLD m
                ON m.MOLD_CODE = r.MOLD_CODE AND m.ORGANIZATION_ID = r.ORGANIZATION_ID
         LEFT JOIN ISYS_BASECODE stt
                ON stt.CODE_TYPE = 'REQUEST STATUS' AND stt.CODE_NAME = r.REQUEST_STATUS
               AND stt.ORGANIZATION_ID = r.ORGANIZATION_ID
        WHERE r.MOLD_CODE LIKE :moldCode
          AND r.REQUEST_STATUS = 'R'
          AND r.ORGANIZATION_ID = :organizationId
        ORDER BY r.REQUEST_DATE, r.REQUEST_SEQUENCE`,
      namedBinds({
        moldCode: this.like(query.moldCode),
        organizationId,
      }),
    );
  }

  private assertAccount(account: string) {
    const value = account.trim();
    if (!value || value === '%') {
      throw new BadRequestException('출고계정을 고르세요.');
    }
  }

  /** 재고 직접출고 — 항번은 SEQ_MAT_ISSUE (PB 와 같다) */
  async create(dto: MoldIssueCreateDto, organizationId: number, userId: string) {
    this.assertAccount(dto.moldIssueAccount);
    return this.tx.run(async (qr) => {
      const exists = await qr.query(
        `SELECT PKG_MES_MAC.F_CHECK_MOLD_EXISTS(:moldCode, :organizationId) AS "cnt" FROM DUAL`,
        namedBinds({ moldCode: dto.moldCode, organizationId }),
      ) as OracleRow[];
      if (Number(exists[0]?.cnt ?? -1) < 0) {
        throw new BadRequestException(`등록되지 않은 S-PARTS 입니다 (${dto.moldCode}).`);
      }
      const seq = await qr.query(
        `SELECT SEQ_MAT_ISSUE.NEXTVAL AS "seq" FROM DUAL`, [],
      ) as OracleRow[];
      const issueSequence = Number(seq[0]?.seq ?? 0);
      await this.insertIssue(qr, {
        issueSequence,
        organizationId,
        userId,
        moldCode: dto.moldCode,
        issueQty: dto.issueQty,
        moldIssueAccount: dto.moldIssueAccount,
        moldVersion: dto.moldVersion ?? null,
        moldSetSerial: dto.moldSetSerial ?? null,
        workstageCode: dto.workstageCode ?? null,
        lineCode: dto.lineCode ?? null,
        machineCode: dto.machineCode ?? null,
        locationCode: dto.locationCode ?? null,
        currency: dto.currency ?? null,
        lineType: dto.lineType ?? null,
        supplierCode: dto.supplierCode ?? null,
        issuePrice: dto.issuePrice ?? null,
      });
      return { issueSequence };
    });
  }

  /**
   * 청구건 출고 — 항번은 SEQ_MOLD_ISSUE_SEQUENCE (PB 가 이 경로에서만 쓰는 시퀀스),
   * 그리고 청구를 완료('C')로 바꾸고 출고일자·항번을 청구에 기록한다.
   */
  async createFromRequest(
    dto: MoldIssueFromRequestDto,
    organizationId: number,
    userId: string,
  ) {
    this.assertAccount(dto.moldIssueAccount);
    return this.tx.run(async (qr) => {
      const requests = await qr.query(
        `SELECT REQUEST_QTY AS "requestQty", REQUEST_STATUS AS "requestStatus"
           FROM IMCN_MOLD_REQUEST
          WHERE MOLD_CODE = :moldCode
            AND REQUEST_DATE = TO_DATE(:requestDate, 'YYYY-MM-DD')
            AND REQUEST_SEQUENCE = :requestSequence
            AND ORGANIZATION_ID = :organizationId`,
        namedBinds({
          moldCode: dto.moldCode,
          requestDate: dto.requestDate.slice(0, 10),
          requestSequence: dto.requestSequence,
          organizationId,
        }),
      ) as OracleRow[];
      if (requests.length === 0) {
        throw new BadRequestException('청구건을 찾을 수 없습니다.');
      }
      if (requests[0]?.requestStatus !== 'R') {
        throw new BadRequestException('이미 처리된 청구건입니다.');
      }

      const seq = await qr.query(
        `SELECT SEQ_MOLD_ISSUE_SEQUENCE.NEXTVAL AS "seq" FROM DUAL`, [],
      ) as OracleRow[];
      const issueSequence = Number(seq[0]?.seq ?? 0);
      await this.insertIssue(qr, {
        issueSequence,
        organizationId,
        userId,
        moldCode: dto.moldCode,
        issueQty: dto.issueQty,
        moldIssueAccount: dto.moldIssueAccount,
        moldVersion: dto.moldVersion ?? null,
        moldSetSerial: dto.moldSetSerial ?? null,
        workstageCode: dto.workstageCode ?? null,
        lineCode: dto.lineCode ?? null,
        machineCode: dto.machineCode ?? null,
        locationCode: null,
        currency: null,
        lineType: null,
        supplierCode: dto.supplierCode ?? null,
        issuePrice: null,
      });

      await qr.query(
        `UPDATE IMCN_MOLD_REQUEST
            SET REQUEST_STATUS   = 'C',
                ISSUE_DATE       = TRUNC(SYSDATE),
                ISSUE_SEQUENCE   = :issueSequence,
                ISSUE_QTY        = :issueQty,
                LAST_MODIFY_BY   = :userId,
                LAST_MODIFY_DATE = SYSDATE
          WHERE MOLD_CODE = :moldCode
            AND REQUEST_DATE = TO_DATE(:requestDate, 'YYYY-MM-DD')
            AND REQUEST_SEQUENCE = :requestSequence
            AND ORGANIZATION_ID = :organizationId`,
        namedBinds({
          issueSequence,
          issueQty: dto.issueQty,
          userId,
          moldCode: dto.moldCode,
          requestDate: dto.requestDate.slice(0, 10),
          requestSequence: dto.requestSequence,
          organizationId,
        }),
      );
      return { issueSequence };
    });
  }

  /** 두 출고 경로가 같은 INSERT 를 쓴다 — 차이는 채번한 시퀀스뿐이다. */
  private async insertIssue(
    qr: { query: (sql: string, params?: unknown[]) => Promise<unknown> },
    values: {
      issueSequence: number;
      organizationId: number;
      userId: string;
      moldCode: string;
      issueQty: number;
      moldIssueAccount: string;
      moldVersion: number | null;
      moldSetSerial: number | null;
      workstageCode: string | null;
      lineCode: string | null;
      machineCode: string | null;
      locationCode: string | null;
      currency: string | null;
      lineType: string | null;
      supplierCode: string | null;
      issuePrice: number | null;
    },
  ) {
    await qr.query(
      `INSERT INTO IMCN_MOLD_ISSUE (
         ISSUE_SEQUENCE, ISSUE_DATE, ORGANIZATION_ID, MOLD_CODE,
         ISSUE_DEFICIT, ISSUE_QTY, ISSUE_PRICE, ISSUE_AMT, CURRENCY, ISSUE_STATUS,
         WORKSTAGE_CODE, LINE_CODE, MACHINE_CODE, LOCATION_CODE,
         SUPPLIER_CODE, LINE_TYPE, MOLD_VERSION, MOLD_SET_SERIAL, MOLD_ISSUE_ACCOUNT,
         ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE
       )
       SELECT :issueSequence, TRUNC(SYSDATE), :organizationId, :moldCode,
              '3', :issueQty, resolved.ISSUE_PRICE,
              :issueQty * resolved.ISSUE_PRICE,
              NVL(:currency, resolved.CURRENCY), 'N',
              :workstageCode, :lineCode, :machineCode, :locationCode,
              :supplierCode, :lineType, :moldVersion, :moldSetSerial, :moldIssueAccount,
              :userId, SYSDATE, :userId, SYSDATE
         FROM (SELECT GREATEST(
                        NVL(:issuePrice,
                            PKG_MES_MAC.F_GET_MOLD_UNIT_PRICE(
                              :supplierCode, :moldCode, :organizationId)),
                        0) AS ISSUE_PRICE,
                      PKG_MES_MAC.F_GET_MOLD_UNIT_PRICE_CURR(
                        :supplierCode, :moldCode, :organizationId) AS CURRENCY
                 FROM DUAL) resolved`,
      namedBinds(values),
    );
  }

  /**
   * 취소 — PB f_mcn_mold_issue_cancel → PKG_MES_MAC.SP_MOLD_ISSUE_CANCEL 전환.
   * 원본을 'C' 로 바꾸고 청구를 미처리로 되돌린 뒤 상계행을 새로 넣는다.
   */
  async cancel(dto: MoldIssueCancelDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      await qr.query(
        `DECLARE
           v_result NUMBER;
         BEGIN
           PKG_MES_MAC.SP_MOLD_ISSUE_CANCEL(
             TO_DATE(:issueDate, 'YYYY-MM-DD'), :issueSequence,
             :organizationId, :userId, v_result);
           IF v_result < 0 THEN
             RAISE_APPLICATION_ERROR(-20013, 'MOLD_ISSUE_CANCEL_FAILED:' || v_result);
           END IF;
         END;`,
        namedBinds({
          issueDate: dto.issueDate.slice(0, 10),
          issueSequence: dto.issueSequence,
          organizationId,
          userId,
        }),
      ).catch((error: unknown) => {
        const message = error instanceof Error ? error.message : String(error);
        const matched = /MOLD_ISSUE_CANCEL_FAILED:(-?\d+)/.exec(message);
        if (!matched) throw error;
        throw new BadRequestException(
          matched[1] === '-2'
            ? '이미 취소된 출고건입니다.'
            : '출고건을 찾을 수 없습니다.',
        );
      });
      const rows = await qr.query(
        `SELECT MAX(ISSUE_SEQUENCE) AS "cancelSequence"
           FROM IMCN_MOLD_ISSUE
          WHERE ISSUE_DATE = TRUNC(SYSDATE) AND ISSUE_STATUS = 'C'
            AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ organizationId }),
      ) as OracleRow[];
      return { cancelSequence: Number(rows[0]?.cancelSequence ?? 0) };
    });
  }
}
