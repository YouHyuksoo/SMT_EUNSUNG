/**
 * @file src/modules/quality/services/wqc.service.ts
 * @description 공정품질검사이력관리 — PB w_qc_workstage_inspect_data_master_es 이식
 *
 * 초보자 가이드:
 * 1. **PID 스캔 1회 = 검사 1건.** 현장 스캐너는 키보드 방식이라 Enter 핸들러 하나면 된다.
 * 2. **라인·공정은 필수다.** PB 도 안 고르면 스캔을 받지 않았다.
 * 3. **취소는 최신 1건만 지운다.** 같은 PID 를 여러 공정에서 검사하므로
 *    PID·라인·공정이 같은 것 중 가장 최근 검사만 지운다 — PB 조건 그대로다.
 * 4. **불량원인 라벨은 F_GET_CODE_MASTER 로 읽는다.** PB 가 다국어를 그 함수로 처리했다.
 *    다만 이 DB 의 'VISUAL BAD REASON CODE' 코드표가 비어 있어 지금은 항상 NULL 이 온다 —
 *    화면은 원시 코드로 떨어진다(실제 값은 'OK'/'NG' 두 개뿐이다).
 * 5. 등록·취소 로직은 PKG_MES_QC.SP_WQC_SCAN / SP_WQC_CANCEL 에 있다.
 */
import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { TransactionService } from '../../../shared/transaction.service';
import {
  WqcByPidQueryDto,
  WqcCancelDto,
  WqcHistoryQueryDto,
  WqcScanDto,
} from '../dto/wqc.dto';

type OracleRow = Record<string, unknown>;

/** 목록·PID조회가 같은 컬럼을 쓴다 — 한 곳에만 둔다 */
const SELECT_COLUMNS = `
  w.INSPECT_DATE AS "inspectDate", w.INSPECT_SEQUENCE AS "inspectSequence",
  w.SERIAL_NO AS "serialNo",
  w.MODEL_NAME AS "modelName", w.MODEL_SUFFIX AS "modelSuffix",
  w.ITEM_CODE AS "itemCode",
  w.LINE_CODE AS "lineCode", ln.LINE_NAME AS "lineName",
  w.WORKSTAGE_CODE AS "workstageCode", ws.WORKSTAGE_NAME AS "workstageName",
  w.MACHINE_CODE AS "machineCode",
  w.WQC_DIVISION AS "wqcDivision", dvn.CODE_MEAN_KOR AS "wqcDivisionName",
  w.INSPECT_QTY AS "inspectQty", w.INSPECT_BAD_QTY AS "inspectBadQty",
  w.DEFECT_QTY AS "defectQty",
  w.BAD_REASON_CODE AS "badReasonCode",
  F_GET_CODE_MASTER('VISUAL BAD REASON CODE', w.BAD_REASON_CODE, :lang, w.ORGANIZATION_ID)
    AS "badReasonName",
  w.REPAIR_RESULT AS "repairResult", rep.CODE_MEAN_KOR AS "repairResultName",
  w.REPAIR_YN AS "repairYn", w.REPAIR_DATE AS "repairDate",
  w.LOCATION_INFOR AS "locationInfor",
  w.INSPECT_BY AS "inspectBy", w.COMMENTS AS "comments",
  w.WQC_INSPECT_NO AS "wqcInspectNo", w.WQC_INSPECT_RESULT AS "wqcInspectResult",
  w.COMPLETE_YN AS "completeYn",
  w.ENTER_BY AS "enterBy", w.ENTER_DATE AS "enterDate",
  w.LAST_MODIFY_BY AS "lastModifyBy", w.LAST_MODIFY_DATE AS "lastModifyDate"`;

const JOINS = `
  FROM IQ_PRODUCT_WQC w
  LEFT JOIN IP_PRODUCT_LINE ln
         ON ln.LINE_CODE = w.LINE_CODE AND ln.ORGANIZATION_ID = w.ORGANIZATION_ID
  LEFT JOIN IP_PRODUCT_WORKSTAGE ws
         ON ws.WORKSTAGE_CODE = w.WORKSTAGE_CODE
        AND ws.ORGANIZATION_ID = w.ORGANIZATION_ID
  LEFT JOIN ISYS_BASECODE dvn
         ON dvn.CODE_TYPE = 'WQC DIVISION' AND dvn.CODE_NAME = w.WQC_DIVISION
        AND dvn.ORGANIZATION_ID = w.ORGANIZATION_ID
  LEFT JOIN ISYS_BASECODE rep
         ON rep.CODE_TYPE = 'REPAIR RESULT' AND rep.CODE_NAME = w.REPAIR_RESULT
        AND rep.ORGANIZATION_ID = w.ORGANIZATION_ID`;

@Injectable()
export class WqcService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  private like(value?: string): string {
    return `${(value ?? '').trim()}%`;
  }

  /** 이력 — PB d_qc_wqc_inspect_bad_hst_es */
  async findHistory(query: WqcHistoryQueryDto, organizationId: number, lang: string) {
    const binds = {
      organizationId,
      lang,
      dateFrom: query.dateFrom.slice(0, 10),
      dateTo: query.dateTo.slice(0, 10),
      lineCode: this.like(query.lineCode),
      workstageCode: this.like(query.workstageCode),
      modelName: this.like(query.modelName),
      serialNo: this.like(query.serialNo),
    };
    const body = `
      SELECT ${SELECT_COLUMNS}
      ${JOINS}
       WHERE w.INSPECT_DATE >= TRUNC(TO_DATE(:dateFrom, 'YYYY-MM-DD'))
         AND w.INSPECT_DATE < TRUNC(TO_DATE(:dateTo, 'YYYY-MM-DD') + 1)
         AND NVL(w.LINE_CODE, '*') LIKE :lineCode
         AND NVL(w.WORKSTAGE_CODE, '*') LIKE :workstageCode
         AND NVL(w.MODEL_NAME, '*') LIKE :modelName
         AND NVL(w.SERIAL_NO, '*') LIKE :serialNo
         AND w.ORGANIZATION_ID = :organizationId`;
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

  /** 선택 PID 의 검사내역 — PB d_qc_visual_inspect_bad_lst_es */
  async findByPid(query: WqcByPidQueryDto, organizationId: number, lang: string) {
    return this.dataSource.query(
      `SELECT ${SELECT_COLUMNS}
       ${JOINS}
        WHERE w.SERIAL_NO = :serialNo AND w.ORGANIZATION_ID = :organizationId
        ORDER BY w.INSPECT_DATE DESC, w.INSPECT_SEQUENCE DESC`,
      { serialNo: query.serialNo, organizationId, lang } as unknown as unknown[],
    ) as Promise<OracleRow[]>;
  }

  /** 등록 — PKG_MES_QC.SP_WQC_SCAN. PID 가 없으면 400 으로 막는다. */
  async scan(dto: WqcScanDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      await qr.query(
        `DECLARE
           v_result NUMBER;
         BEGIN
           PKG_MES_QC.SP_WQC_SCAN(
             :serialNo, :lineCode, :workstageCode, :machineCode,
             :badReasonCode, :comments, :organizationId, :userId, v_result);
           IF v_result < 0 THEN
             RAISE_APPLICATION_ERROR(-20023, 'WQC_SCAN_FAILED');
           END IF;
         END;`,
        {
          serialNo: dto.serialNo,
          lineCode: dto.lineCode,
          workstageCode: dto.workstageCode,
          machineCode: dto.machineCode ?? null,
          badReasonCode: dto.badReasonCode,
          comments: dto.comments ?? null,
          organizationId,
          userId,
        } as unknown as unknown[],
      ).catch((error: unknown) => {
        const message = error instanceof Error ? error.message : String(error);
        if (message.includes('WQC_SCAN_FAILED')) {
          throw new BadRequestException(`등록되지 않은 PID 입니다 (${dto.serialNo}).`);
        }
        throw error;
      });
      const rows = await qr.query(
        `SELECT MAX(INSPECT_SEQUENCE) AS "inspectSequence" FROM IQ_PRODUCT_WQC
          WHERE SERIAL_NO = :serialNo AND ORGANIZATION_ID = :organizationId`,
        { serialNo: dto.serialNo, organizationId } as unknown as unknown[],
      ) as OracleRow[];
      return {
        serialNo: dto.serialNo,
        inspectSequence: Number(rows[0]?.inspectSequence ?? 0),
      };
    });
  }

  /** 취소 — PKG_MES_QC.SP_WQC_CANCEL. 같은 PID·라인·공정의 최신 1건만 지운다. */
  async cancel(dto: WqcCancelDto, organizationId: number) {
    return this.tx.run(async (qr) => {
      await qr.query(
        `DECLARE
           v_result NUMBER;
         BEGIN
           PKG_MES_QC.SP_WQC_CANCEL(
             :serialNo, :lineCode, :workstageCode, :organizationId, v_result);
           IF v_result < 0 THEN
             RAISE_APPLICATION_ERROR(-20024, 'WQC_CANCEL_NOT_FOUND');
           END IF;
         END;`,
        {
          serialNo: dto.serialNo,
          lineCode: dto.lineCode,
          workstageCode: dto.workstageCode,
          organizationId,
        } as unknown as unknown[],
      ).catch((error: unknown) => {
        const message = error instanceof Error ? error.message : String(error);
        if (message.includes('WQC_CANCEL_NOT_FOUND')) {
          throw new NotFoundException('취소할 검사내역이 없습니다.');
        }
        throw error;
      });
      return { serialNo: dto.serialNo, deleted: true };
    });
  }
}
