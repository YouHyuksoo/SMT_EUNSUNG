/**
 * @file src/modules/jig/jig-repair-request.service.ts
 * @description 187 지그수리신청 — PB `w_mcn_jig_repair_request_master` 이식 (**쓰기**)
 *
 * 초보자 가이드:
 * 1. **고장난 지그를 "고쳐 달라"고 올리는 화면이다.** 지그를 고르고 사유를 적으면
 *    수리 신청이 한 건 생긴다. 실제로 고치고 마감하는 것은 **지그수리관리**
 *    (`/jig/repair`, 이미 이관됨) 화면이 한다.
 * 2. **같은 표를 둘이 나눠 쓴다** (`IMCN_JIG_REPAIR`). 신청 화면은 신청 항목만 만들고,
 *    수리 화면이 수리일·수리자·금액을 채워 마감한다. 그래서 여기서는
 *    **이미 수리가 시작된 건을 고치거나 지우지 않는다.**
 * 3. **드물게 쓰는 화면이다** (실측): 전 기간 12건, 마지막이 2026-04-21 이다.
 *    그래도 옮긴 이유는 고장 접수가 이 경로 말고 없기 때문이다.
 * 4. **신청번호는 시퀀스에서 받는다** (`SEQ_JIG_REPAIR_SEQUENCE`). PB 와 같다.
 * 5. **쓰기는 실행하지 않고 parse 로만 검증했다** (사용자 결정).
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { limited, ROW_LIMIT } from '../../shared/row-limit';
import { TransactionService } from '../../shared/transaction.service';
import {
  JigRepairRequestCreateDto,
  JigRepairRequestDeleteDto,
  JigRepairRequestQueryDto,
  JigRepairRequestUpdateDto,
  RepairableJigQueryDto,
} from './jig-repair-request.dto';

type Row = Record<string, unknown>;

/**
 * 신청 등록은 **직접 INSERT 하지 않고 DB 패키지에 맡긴다.**
 * `/jig/repair`(지그수리관리)가 이미 이 프로시저로 접수하고 있어서, 여기서 따로
 * INSERT 하면 채번과 초기 상태를 정하는 주체가 둘이 된다.
 * 실측 `REPAIR_STATUS` 는 `'R'`(수리중) 2건 · `'C'`(수리완료) 10건이고,
 * 초기값을 무엇으로 둘지는 이 프로시저가 정한다.
 */
const REQUEST_PROCEDURE = 'PKG_MES_MAC.SP_REPAIR_REQUEST';

@Injectable()
export class JigRepairRequestService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  // ───────────────────────────────── 조회

  /** 수리 신청 목록 (PB `d_mcn_jig_repair_request_lst`). */
  async findRequests(query: JigRepairRequestQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT r.JIG_CODE            AS "jigCode",
              j.JIG_NAME            AS "jigName",
              j.JIG_TYPE            AS "jigType",
              r.JIG_LOT_NO          AS "jigLotNo",
              r.REPAIR_SEQUENCE     AS "repairSequence",
              r.REPAIR_STATUS       AS "repairStatus",
              r.REPAIR_REASON_CODE  AS "repairReasonCode",
              r.REPAIR_VENDOR_CODE  AS "repairVendorCode",
              r.REPAIR_BY           AS "repairBy",
              r.REPAIR_TIME         AS "repairTime",
              r.REPAIR_AMT          AS "repairAmt",
              r.CURRENCY            AS "currency",
              r.COMMENTS            AS "comments",
              r.REPAIR_COMMENTS     AS "repairComments",
              r.ENTER_BY            AS "enterBy",
              TO_CHAR(r.REPAIR_REQUEST_DATE, 'YYYY-MM-DD') AS "repairRequestDate",
              TO_CHAR(r.REPAIR_DATE, 'YYYY-MM-DD')         AS "repairDate",
              TO_CHAR(r.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "enterDate"
         FROM IMCN_JIG_REPAIR r
         LEFT JOIN IMCN_JIG j
                ON j.JIG_CODE = r.JIG_CODE
               AND j.ORGANIZATION_ID = r.ORGANIZATION_ID
        WHERE r.ORGANIZATION_ID = :organizationId
          AND r.REPAIR_REQUEST_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND r.REPAIR_REQUEST_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND NVL(r.JIG_CODE, '*') LIKE :jigCode
          AND NVL(r.REPAIR_STATUS, '*') LIKE :repairStatus
        ORDER BY r.REPAIR_REQUEST_DATE DESC, r.REPAIR_SEQUENCE DESC
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        organizationId,
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        jigCode: this.like(query.jigCode),
        repairStatus: this.like(query.repairStatus),
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /** 신청할 수 있는 지그 목록 (PB `d_mcn_jig_inventory_4_repair_lst`). */
  async findRepairableJigs(query: RepairableJigQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT j.JIG_CODE        AS "jigCode",
              j.JIG_NAME        AS "jigName",
              j.JIG_TYPE        AS "jigType",
              j.JIG_MODEL_NAME  AS "jigModelName",
              j.LINE_CODE       AS "lineCode",
              ln.LINE_NAME      AS "lineName",
              j.WORKSTAGE_CODE  AS "workstageCode",
              j.USE_STATUS      AS "useStatus",
              j.CAPACITY        AS "capacity",
              j.USE_RATE        AS "useRate",
              j.CUSTOMER_CODE   AS "customerCode",
              j.MANUAL_LOCATION_COMMENT AS "locationComment",
              TO_CHAR(j.ACQUISITION_DATE, 'YYYY-MM-DD') AS "acquisitionDate",
              -- 이 지그에 아직 끝나지 않은 신청이 있으면 알려 준다 (중복 신청 방지).
              (SELECT COUNT(*) FROM IMCN_JIG_REPAIR x
                WHERE x.JIG_CODE = j.JIG_CODE
                  AND x.ORGANIZATION_ID = j.ORGANIZATION_ID
                  AND x.REPAIR_DATE IS NULL) AS "openRequestCount"
         FROM IMCN_JIG j
         LEFT JOIN IP_PRODUCT_LINE ln
                ON ln.LINE_CODE = j.LINE_CODE
               AND ln.ORGANIZATION_ID = j.ORGANIZATION_ID
        WHERE j.ORGANIZATION_ID = :organizationId
          AND NVL(j.JIG_CODE, '*') LIKE :jigCode
          AND NVL(j.JIG_TYPE, '*') LIKE :jigType
          AND NVL(j.LINE_CODE, '*') LIKE :lineCode
        ORDER BY j.JIG_CODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        organizationId,
        jigCode: this.like(query.jigCode),
        jigType: this.like(query.jigType),
        lineCode: this.like(query.lineCode),
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  // ───────────────────────────────── 신청 (쓰기)

  /**
   * 수리 신청을 만든다 (**쓰기**).
   *
   * **채번·초기상태·검증을 DB 패키지가 한다** — `PKG_MES_MAC.SP_REPAIR_REQUEST`.
   * 지그수리관리 화면이 쓰는 것과 같은 경로라 두 화면이 같은 규칙으로 접수한다.
   * 신청일도 프로시저가 넣으므로 화면에서 받지 않는다.
   */
  async createRequest(
    dto: JigRepairRequestCreateDto,
    organizationId: number,
    userId: string,
  ) {
    return this.tx.run(async (qr) => {
      await qr
        .query(
          `DECLARE
             v_result NUMBER;
           BEGIN
             ${REQUEST_PROCEDURE}(:jigCode, :jigLotNo, :repairReasonCode,
               :repairVendorCode, :comments, :currency, :organizationId, :userId, v_result);
             IF v_result < 0 THEN
               RAISE_APPLICATION_ERROR(-20006, 'JIG_REPAIR_REQUEST_FAILED:' || v_result);
             END IF;
           END;`,
          {
            jigCode: dto.jigCode.trim(),
            jigLotNo: (dto.jigLotNo ?? '').trim(),
            repairReasonCode: dto.repairReasonCode,
            repairVendorCode: dto.repairVendorCode ?? null,
            comments: dto.comments ?? null,
            currency: dto.currency ?? null,
            organizationId,
            userId,
          } as unknown as unknown[],
        )
        .catch((error: unknown) => {
          const message = error instanceof Error ? error.message : String(error);
          if (/JIG_REPAIR_REQUEST_FAILED/.test(message)) {
            throw new BadRequestException(`등록되지 않은 지그입니다: ${dto.jigCode}`);
          }
          throw error;
        });

      // 방금 접수된 건을 돌려준다 (OUT 바인드 대신 최신 1건 조회 — 저장소 관례).
      const saved = (await qr.query(
        `SELECT * FROM (
           SELECT REPAIR_SEQUENCE AS "repairSequence",
                  REPAIR_STATUS   AS "repairStatus",
                  TO_CHAR(REPAIR_REQUEST_DATE, 'YYYY-MM-DD') AS "repairRequestDate"
             FROM IMCN_JIG_REPAIR
            WHERE JIG_CODE = :jigCode
              AND ORGANIZATION_ID = :organizationId
            ORDER BY REPAIR_SEQUENCE DESC
         ) WHERE ROWNUM = 1`,
        { jigCode: dto.jigCode.trim(), organizationId } as unknown as unknown[],
      )) as Row[];
      return { jigCode: dto.jigCode.trim(), ...(saved[0] ?? {}) };
    });
  }

  /**
   * 신청 내용을 고친다 (**쓰기**).
   *
   * **수리가 시작된 건은 고치지 않는다** — `REPAIR_DATE` 가 채워졌으면 수리관리
   * 화면이 처리한 것이다. 조건을 UPDATE 문 안에 둬서 조회-수정 사이 경쟁도 막는다.
   */
  async updateRequest(
    dto: JigRepairRequestUpdateDto,
    organizationId: number,
    userId: string,
  ) {
    return this.tx.run(async (qr) => {
      const updated = await qr.query(
        `UPDATE IMCN_JIG_REPAIR
            SET REPAIR_REASON_CODE = :repairReasonCode,
                REPAIR_REQUEST_DATE = TO_DATE(:repairRequestDate, 'YYYY-MM-DD'),
                REPAIR_VENDOR_CODE = :repairVendorCode,
                COMMENTS = :comments,
                JIG_LOT_NO = :jigLotNo,
                LAST_MODIFY_BY = :userId,
                LAST_MODIFY_DATE = SYSDATE
          WHERE JIG_CODE = :jigCode
            AND REPAIR_SEQUENCE = :repairSequence
            AND ORGANIZATION_ID = :organizationId
            AND REPAIR_DATE IS NULL`,
        {
          repairReasonCode: dto.repairReasonCode,
          repairRequestDate: dto.repairRequestDate,
          repairVendorCode: dto.repairVendorCode ?? null,
          comments: dto.comments ?? null,
          jigLotNo: dto.jigLotNo ?? null,
          userId,
          jigCode: dto.jigCode.trim(),
          repairSequence: dto.repairSequence,
          organizationId,
        } as unknown as unknown[],
      );
      const affected = Number(
        (updated as { rowsAffected?: number })?.rowsAffected ?? 0,
      );
      if (affected !== 1) {
        throw new BadRequestException(
          '고칠 수 없는 신청입니다 (없거나 이미 수리가 시작됐습니다).',
        );
      }
      return { jigCode: dto.jigCode.trim(), repairSequence: dto.repairSequence };
    });
  }

  /** 신청을 취소한다 (**쓰기**). 수리가 시작된 건은 지우지 않는다. */
  async deleteRequest(dto: JigRepairRequestDeleteDto, organizationId: number) {
    return this.tx.run(async (qr) => {
      const deleted = await qr.query(
        `DELETE FROM IMCN_JIG_REPAIR
          WHERE JIG_CODE = :jigCode
            AND REPAIR_SEQUENCE = :repairSequence
            AND ORGANIZATION_ID = :organizationId
            AND REPAIR_DATE IS NULL`,
        {
          jigCode: dto.jigCode.trim(),
          repairSequence: dto.repairSequence,
          organizationId,
        } as unknown as unknown[],
      );
      const affected = Number(
        (deleted as { rowsAffected?: number })?.rowsAffected ?? 0,
      );
      if (affected !== 1) {
        throw new BadRequestException(
          '지울 수 없는 신청입니다 (없거나 이미 수리가 시작됐습니다).',
        );
      }
      return { jigCode: dto.jigCode.trim(), repairSequence: dto.repairSequence };
    });
  }

  private like(value?: string) {
    const trimmed = (value ?? '').trim();
    return trimmed ? `%${trimmed}%` : '%';
  }
}
