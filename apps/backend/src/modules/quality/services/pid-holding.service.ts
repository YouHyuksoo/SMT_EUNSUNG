/**
 * @file src/modules/quality/services/pid-holding.service.ts
 * @description PID 홀딩관리 + PCB 이슈발생스캔관리 —
 *              PB w_pln_product_barcode_holding · w_pln_product_pid_issue_scan_master 이식
 *
 * 초보자 가이드:
 * 1. **`IP_PRODUCT_2D_BARCODE` 는 1억 8천만 행이다.** 인덱스가 있는 컬럼은
 *    SERIAL_NO(유니크) · RUN_NO · MAGAZINE_NO · BOX_NO 뿐이다.
 *    MODEL_NAME · LINE_CODE · BARCODE_STATUS 에는 인덱스가 없다.
 *
 *    PB 는 조건 없이도 조회가 됐지만 현장에서 늘 PID 를 찍어 썼다. 웹에서 그대로 열어두면
 *    조회 한 번에 운영 DB 를 전부 훑는다. **그래서 인덱스 있는 넷 중 최소 하나를 요구한다.**
 *    결과를 잘라서 주지 않는다 — 홀딩 화면에서 잘린 목록은 "그 PID 가 없다" 와 구분이 안 된다.
 *
 * 2. **홀딩은 BARCODE_STATUS 를 바꾸는 것뿐이다** — 'H' 홀딩 / 'N' 정상. PB 도 같다.
 *    PB 는 그리드에서 체크한 행을 한 번에 바꿨으므로 여러 PID 를 받는다.
 *
 * 3. **PCB 이슈발생스캔은 다른 테이블이다** — `IP_PRODUCT_ISSUE_PID_SCAN`(0행).
 *    1억 8천만 행 테이블과 무관하므로 기간 조회로 충분하다.
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { TransactionService } from '../../../shared/transaction.service';
import {
  PID_HOLDING_REQUIRED_FILTERS,
  PidHoldingQueryDto,
  PidHoldingUpdateDto,
  PidIssueScanByPidDto,
  PidIssueScanHistoryQueryDto,
} from '../dto/pid-holding.dto';

type OracleRow = Record<string, unknown>;

@Injectable()
export class PidHoldingService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  private like(value?: string): string {
    return `${(value ?? '').trim()}%`;
  }

  /**
   * 목록 — PB d_pln_product_2d_barcode_4_holding.
   * 인덱스 있는 조건 하나가 없으면 400 으로 막는다. 이유를 문구에 적어 돌려준다.
   */
  async find(query: PidHoldingQueryDto, organizationId: number) {
    const given = PID_HOLDING_REQUIRED_FILTERS.filter(
      (key) => (query[key] ?? '').trim() !== '',
    );
    if (given.length === 0) {
      throw new BadRequestException(
        'PID · RUN번호 · 매거진번호 · BOX번호 중 최소 하나를 입력하세요. '
        + '제품바코드는 1억 8천만 행이라 이 조건 없이는 조회할 수 없습니다.',
      );
    }

    const binds: OracleRow = {
      organizationId,
      modelName: this.like(query.modelName),
      lineCode: this.like(query.lineCode),
      barcodeStatus: this.like(query.barcodeStatus),
    };
    // 인덱스 조건은 준 것만 WHERE 에 넣는다 — 안 준 것을 '%' 로 채우면 인덱스를 못 쓴다.
    const indexed: string[] = [];
    if ((query.serialNo ?? '').trim()) {
      indexed.push('b.SERIAL_NO LIKE :serialNo');
      binds.serialNo = this.like(query.serialNo);
    }
    if ((query.runNo ?? '').trim()) {
      indexed.push('b.RUN_NO LIKE :runNo');
      binds.runNo = this.like(query.runNo);
    }
    if ((query.magazineNo ?? '').trim()) {
      indexed.push('b.MAGAZINE_NO LIKE :magazineNo');
      binds.magazineNo = this.like(query.magazineNo);
    }
    if ((query.boxNo ?? '').trim()) {
      indexed.push('b.BOX_NO LIKE :boxNo');
      binds.boxNo = this.like(query.boxNo);
    }

    const body = `
      SELECT b.SERIAL_NO AS "serialNo", b.RUN_NO AS "runNo",
             b.MODEL_NAME AS "modelName", b.MODEL_SUFFIX AS "modelSuffix",
             b.ITEM_CODE AS "itemCode", i.ITEM_NAME AS "itemName",
             b.LINE_CODE AS "lineCode", ln.LINE_NAME AS "lineName",
             b.MAGAZINE_NO AS "magazineNo", b.BOX_NO AS "boxNo",
             b.BARCODE_STATUS AS "barcodeStatus", bst.CODE_MEAN_KOR AS "barcodeStatusName",
             b.ACTUAL_DATE AS "actualDate", b.SHIFT_CODE AS "shiftCode",
             b.RECEIPT_DATE AS "receiptDate", b.SHIPPING_DATE AS "shippingDate",
             b.SHIPPING_DEFICIT AS "shippingDeficit",
             b.ENTER_BY AS "enterBy", b.ENTER_DATE AS "enterDate",
             b.LAST_MODIFY_BY AS "lastModifyBy", b.LAST_MODIFY_DATE AS "lastModifyDate"
        FROM IP_PRODUCT_2D_BARCODE b
        LEFT JOIN ID_ITEM i
               ON i.ITEM_CODE = b.ITEM_CODE AND i.ORGANIZATION_ID = b.ORGANIZATION_ID
        LEFT JOIN IP_PRODUCT_LINE ln
               ON ln.LINE_CODE = b.LINE_CODE AND ln.ORGANIZATION_ID = b.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE bst
               ON bst.CODE_TYPE = 'BARCODE STATUS' AND bst.CODE_NAME = b.BARCODE_STATUS
              AND bst.ORGANIZATION_ID = b.ORGANIZATION_ID
       WHERE ${indexed.join('\n         AND ')}
         AND NVL(b.MODEL_NAME, '*') LIKE :modelName
         AND NVL(b.LINE_CODE, '*') LIKE :lineCode
         AND NVL(b.BARCODE_STATUS, '*') LIKE :barcodeStatus
         AND b.ORGANIZATION_ID = :organizationId`;
    const page = query.page ?? 1;
    const limit = query.limit ?? 500;
    const totals = await this.dataSource.query(
      `SELECT COUNT(*) AS "total" FROM (${body}) source_rows`,
      { ...binds } as unknown as unknown[],
    ) as OracleRow[];
    const rows = await this.dataSource.query(
      `${body} ORDER BY "serialNo"
       OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`,
      { ...binds, offset: (page - 1) * limit, limit } as unknown as unknown[],
    ) as OracleRow[];
    return { data: rows, total: Number(totals[0]?.total ?? 0), page, limit };
  }

  /**
   * 홀딩 / 홀딩해제 — PB cb_hold / cb_release.
   * SERIAL_NO 는 유니크 인덱스라 건마다 단건 갱신이고, 전부 한 트랜잭션에서 처리한다.
   */
  async updateStatus(dto: PidHoldingUpdateDto, organizationId: number, userId: string) {
    const serials = [...new Set(dto.serialNos.map((value) => value.trim()).filter(Boolean))];
    if (serials.length === 0) {
      throw new BadRequestException('바꿀 PID 를 고르세요.');
    }
    return this.tx.run(async (qr) => {
      // 사후에 COUNT 로 세면 "이미 그 값이던 행" 과 "없는 행" 을 구분할 수 없다.
      // 그래서 바꾸기 전에 대상 상태를 읽어 두고, 실제로 값이 달라진 것만 센다.
      const before = await qr.query(
        `SELECT SERIAL_NO AS "serialNo", BARCODE_STATUS AS "barcodeStatus"
           FROM IP_PRODUCT_2D_BARCODE
          WHERE SERIAL_NO IN (${serials.map((_, i) => `:s${i}`).join(', ')})
            AND ORGANIZATION_ID = :organizationId`,
        {
          ...Object.fromEntries(serials.map((value, i) => [`s${i}`, value])),
          organizationId,
        } as unknown as unknown[],
      ) as OracleRow[];
      const existing = new Map(
        before.map((row) => [String(row.serialNo), String(row.barcodeStatus ?? '')]),
      );

      for (const serialNo of serials) {
        if (!existing.has(serialNo)) continue;   // 없는 PID 는 건너뛴다
        await qr.query(
          `UPDATE IP_PRODUCT_2D_BARCODE
              SET BARCODE_STATUS   = :barcodeStatus,
                  LAST_MODIFY_BY   = :userId,
                  LAST_MODIFY_DATE = SYSDATE
            WHERE SERIAL_NO = :serialNo AND ORGANIZATION_ID = :organizationId`,
          {
            barcodeStatus: dto.barcodeStatus,
            userId,
            serialNo,
            organizationId,
          } as unknown as unknown[],
        );
      }

      const changed = [...existing.entries()]
        .filter(([, status]) => status !== dto.barcodeStatus).length;
      const missing = serials.filter((serialNo) => !existing.has(serialNo)).length;
      return {
        requested: serials.length,
        changed,                 // 실제로 값이 달라진 건수
        alreadySet: existing.size - changed,
        missing,                 // 그 PID 가 없어 건너뛴 건수
        barcodeStatus: dto.barcodeStatus,
      };
    });
  }

  /** PCB 이슈 스캔 이력 — PB d_qc_pid_issue_scan_hist */
  async findIssueScans(query: PidIssueScanHistoryQueryDto, organizationId: number) {
    const binds = {
      organizationId,
      dateFrom: query.dateFrom.slice(0, 10),
      dateTo: query.dateTo.slice(0, 10),
      serialNo: this.like(query.serialNo),
      modelName: this.like(query.modelName),
      itemCode: this.like(query.itemCode),
      pidIssueType: this.like(query.pidIssueType),
      location: this.like(query.location),
    };
    const body = `
      SELECT s.SERIAL_NO AS "serialNo", s.SCAN_DATE AS "scanDate",
             s.PID_ISSUE_TYPE AS "pidIssueType",
             s.MODEL_NAME AS "modelName", s.MODEL_SUFFIX AS "modelSuffix",
             s.ITEM_CODE AS "itemCode", i.ITEM_NAME AS "itemName",
             s.LINE_CODE AS "lineCode", ln.LINE_NAME AS "lineName",
             s.LOCATION AS "location",
             s.CLEAN_CHARGER AS "cleanCharger", s.INSPECT_CHARGER AS "inspectCharger",
             s.COMMENTS AS "comments",
             s.ENTER_BY AS "enterBy", s.ENTER_DATE AS "enterDate",
             s.LAST_MODIFY_BY AS "lastModifyBy", s.LAST_MODIFY_DATE AS "lastModifyDate"
        FROM IP_PRODUCT_ISSUE_PID_SCAN s
        LEFT JOIN ID_ITEM i
               ON i.ITEM_CODE = s.ITEM_CODE AND i.ORGANIZATION_ID = s.ORGANIZATION_ID
        LEFT JOIN IP_PRODUCT_LINE ln
               ON ln.LINE_CODE = s.LINE_CODE AND ln.ORGANIZATION_ID = s.ORGANIZATION_ID
       WHERE s.SCAN_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
         AND s.SCAN_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
         AND NVL(s.SERIAL_NO, '*') LIKE :serialNo
         AND NVL(s.MODEL_NAME, '*') LIKE :modelName
         AND NVL(s.ITEM_CODE, '*') LIKE :itemCode
         AND NVL(s.PID_ISSUE_TYPE, '*') LIKE :pidIssueType
         AND NVL(s.LOCATION, '*') LIKE :location
         AND s.ORGANIZATION_ID = :organizationId`;
    const page = query.page ?? 1;
    const limit = query.limit ?? 500;
    const totals = await this.dataSource.query(
      `SELECT COUNT(*) AS "total" FROM (${body}) source_rows`,
      { ...binds } as unknown as unknown[],
    ) as OracleRow[];
    const rows = await this.dataSource.query(
      `${body} ORDER BY "scanDate" DESC, "serialNo"
       OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`,
      { ...binds, offset: (page - 1) * limit, limit } as unknown as unknown[],
    ) as OracleRow[];
    return { data: rows, total: Number(totals[0]?.total ?? 0), page, limit };
  }

  /** 선택 PID 의 이슈 스캔 내역 — PB d_qc_pid_issue_scan_lst (SERIAL_NO 등호) */
  async findIssueScansByPid(query: PidIssueScanByPidDto, organizationId: number) {
    return this.dataSource.query(
      `SELECT s.SERIAL_NO AS "serialNo", s.SCAN_DATE AS "scanDate",
              s.PID_ISSUE_TYPE AS "pidIssueType",
              s.MODEL_NAME AS "modelName", s.MODEL_SUFFIX AS "modelSuffix",
              s.ITEM_CODE AS "itemCode", i.ITEM_NAME AS "itemName",
              s.LINE_CODE AS "lineCode", s.LOCATION AS "location",
              s.CLEAN_CHARGER AS "cleanCharger", s.INSPECT_CHARGER AS "inspectCharger",
              s.COMMENTS AS "comments",
              s.ENTER_BY AS "enterBy", s.ENTER_DATE AS "enterDate"
         FROM IP_PRODUCT_ISSUE_PID_SCAN s
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = s.ITEM_CODE AND i.ORGANIZATION_ID = s.ORGANIZATION_ID
        WHERE s.SERIAL_NO = :serialNo AND s.ORGANIZATION_ID = :organizationId
        ORDER BY s.SCAN_DATE DESC`,
      { serialNo: query.serialNo, organizationId } as unknown as unknown[],
    ) as Promise<OracleRow[]>;
  }
}
