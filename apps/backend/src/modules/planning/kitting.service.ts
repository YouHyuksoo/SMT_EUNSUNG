/**
 * @file src/modules/planning/kitting.service.ts
 * @description 롯트카드-PID 매핑관리 — PB w_pln_product_pcb_kitting_scan_master 이식
 *
 * 초보자 가이드:
 * 1. **무엇을 하는 화면인가**: 작업지시(롯트카드) 하나에 실제 PCB 한 장씩(PID)을
 *    바코드로 찍어 붙인다. 이후 모든 공정·검사 이력이 이 PID 를 따라간다.
 * 2. **runNo 가 없으면 조회하지 않는다.** IP_PRODUCT_2D_BARCODE 는 약 1.8억 행이고
 *    RUN_NO 가 INDXIP_PRODUCT_2D_BARCODE2(RUN_NO, SERIAL_NO) 의 선두 컬럼이다.
 * 3. **스캔·취소·전체해제는 PKG_MES_PLN 안에 있다.** PB 화면과 웹이 같은 오브젝트를
 *    불러야 중복검사·모델매칭·QC 스캔 보호가 갈리지 않는다.
 * 4. **스캐너는 키보드 방식이다.** 별도 연동이 없고 입력 필드에 그대로 들어온다.
 */
import { BadRequestException, ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { TransactionService } from '../../shared/transaction.service';
import {
  KittingCancelDto,
  KittingClearDto,
  KittingPidQueryDto,
  KittingRunCardQueryDto,
  KittingScanDto,
} from './kitting.dto';
import { like } from './plan-shared';

type Row = Record<string, unknown>;

@Injectable()
export class KittingService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  /**
   * 롯트카드 목록 — PB d_ip_product_run_card_4_kitting_lst.
   * RUN_TYPE_CODE 는 내리지 않는다 — 38,899행 전부 NULL 이고 코드표도 없다.
   * 카드별 매핑 PID 수는 내리지 않는다 (PB 에도 없다). IP_PRODUCT_2D_BARCODE(1.8억 행)를
   * 카드마다 세면 전체 목록이 3분을 넘긴다. 선택한 카드의 PID 수는 PID 패널이 보여준다.
   */
  async findRunCards(query: KittingRunCardQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT c.RUN_NO AS "runNo",
              TO_CHAR(c.RUN_DATE, 'YYYY-MM-DD') AS "runDate",
              c.LOT_NO AS "lotNo", c.ITEM_CODE AS "itemCode",
              c.MODEL_NAME AS "modelName", c.MASTER_MODEL_NAME AS "masterModelName",
              c.LINE_CODE AS "lineCode", pl.LINE_NAME AS "lineName",
              c.MARKING_NO AS "markingNo", c.LOT_SIZE AS "lotSize",
              c.CARRIER_SIZE AS "carrierSize", c.ARRAY_TYPE AS "arrayType",
              c.RUN_STATUS AS "runStatus", rs.CODE_MEAN_KOR AS "runStatusName",
              c.PRODUCT_RUN_TYPE AS "productRunType",
              prt.CODE_MEAN_KOR AS "productRunTypeName",
              c.KITTING_DATE AS "kittingDate",
              c.MFS_GROUP_NO AS "mfsGroupNo", c.COMMENTS AS "comments",
              c.ENTER_BY AS "enterBy", c.ENTER_DATE AS "enterDate",
              c.LAST_MODIFY_BY AS "lastModifyBy", c.LAST_MODIFY_DATE AS "lastModifyDate"
         FROM IP_PRODUCT_RUN_CARD c
         LEFT JOIN IP_PRODUCT_LINE pl
                ON pl.LINE_CODE = c.LINE_CODE
               AND pl.ORGANIZATION_ID = c.ORGANIZATION_ID
         LEFT JOIN ISYS_BASECODE rs
                ON rs.CODE_TYPE = 'RUN STATUS' AND rs.CODE_NAME = c.RUN_STATUS
         LEFT JOIN ISYS_BASECODE prt
                ON prt.CODE_TYPE = 'PRODUCT RUN TYPE'
               AND prt.CODE_NAME = c.PRODUCT_RUN_TYPE
        WHERE c.ORGANIZATION_ID = :organizationId
          AND NVL(c.RUN_NO, '*') LIKE :runNo
          AND NVL(c.MFS_GROUP_NO, '*') LIKE :mfsGroupNo
        ORDER BY c.RUN_DATE DESC, c.RUN_NO DESC`,
      {
        organizationId,
        runNo: like(query.runNo),
        mfsGroupNo: like(query.mfsGroupNo),
      } as unknown as unknown[],
    )) as Row[];
    return { data: rows, total: rows.length };
  }

  /**
   * 매핑된 PID 목록 — PB d_pln_product_2d_barcode_4_kitting.
   * MODEL_CODE 는 PB 가 PID 7~11번째 다섯 글자를 떼어 보여준 것이다 (모델매칭 확인용).
   */
  async findPids(query: KittingPidQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT b.RUN_NO AS "runNo", b.SERIAL_NO AS "serialNo",
              SUBSTR(b.SERIAL_NO, 7, 5) AS "modelCode",
              b.LABEL_TEXT AS "labelText",
              b.MODEL_NAME AS "modelName", b.MODEL_SUFFIX AS "modelSuffix",
              b.ITEM_CODE AS "itemCode",
              b.LINE_CODE AS "lineCode",
              b.WORKSTAGE_CODE AS "workstageCode",
              b.RUN_DATE AS "runDate",
              b.MAGAZINE_NO AS "magazineNo", b.LOT_NO AS "lotNo",
              b.LOT_QTY AS "lotQty", b.ARRAY_TYPE AS "arrayType",
              b.CARRIER_SIZE AS "carrierSize",
              b.BARCODE_STATUS AS "barcodeStatus", bs.CODE_MEAN_KOR AS "barcodeStatusName",
              b.QC_SCAN_YN AS "qcScanYn", b.QC_SCAN_DATE AS "qcScanDate",
              b.ENTER_BY AS "enterBy", b.ENTER_DATE AS "enterDate",
              b.LAST_MODIFY_BY AS "lastModifyBy", b.LAST_MODIFY_DATE AS "lastModifyDate"
         FROM IP_PRODUCT_2D_BARCODE b
         LEFT JOIN ISYS_BASECODE bs
                ON bs.CODE_TYPE = 'BARCODE STATUS' AND bs.CODE_NAME = b.BARCODE_STATUS
        WHERE b.RUN_NO = :runNo
          AND b.ORGANIZATION_ID = :organizationId
        ORDER BY b.SERIAL_NO`,
      { runNo: query.runNo.trim(), organizationId } as unknown as unknown[],
    )) as Row[];
    return { data: rows, total: rows.length };
  }

  /**
   * 프로시저를 돌린다. 음수 결과는 marker 를 실은 ORA 예외로 올라오고
   * toError 가 이 화면의 말로 바꾼다. OUT 바인드는 쓰지 않는다.
   */
  private async runProcedure(
    qr: { query: (sql: string, params?: unknown[]) => Promise<unknown> },
    call: string,
    marker: string,
    binds: Record<string, unknown>,
    toError: (code: number) => Error,
  ) {
    await qr
      .query(
        `DECLARE
           v_result NUMBER;
         BEGIN
           ${call}
           IF v_result < 0 THEN
             RAISE_APPLICATION_ERROR(-20041, '${marker}:' || v_result);
           END IF;
         END;`,
        binds as unknown as unknown[],
      )
      .catch((error: unknown) => {
        const message = error instanceof Error ? error.message : String(error);
        const matched = new RegExp(`${marker}:(-?\\d+)`).exec(message);
        if (!matched) throw error;
        throw toError(Number(matched[1]));
      });
  }

  /** 스캔(매핑) — PKG_MES_PLN.SP_PLN_KITTING_SCAN. */
  async scan(dto: KittingScanDto, organizationId: number, userId: string) {
    const serialNo = dto.serialNo.trim();
    if (serialNo === '') throw new BadRequestException('PID 를 입력하세요.');
    return this.tx.run(async (qr) => {
      await this.runProcedure(
        qr,
        `PKG_MES_PLN.SP_PLN_KITTING_SCAN(
           :runNo, :serialNo, :modelMatching, :organizationId, :userId, v_result);`,
        'KITTING_SCAN_FAILED',
        {
          runNo: dto.runNo.trim(),
          serialNo,
          modelMatching: dto.modelMatching ?? 'N',
          organizationId,
          userId,
        },
        (code) => {
          if (code === -1) {
            return new NotFoundException(`작업지시를 찾을 수 없습니다: ${dto.runNo}`);
          }
          if (code === -2) {
            return new ConflictException(`이미 이 작업지시에 매핑된 PID 입니다: ${serialNo}`);
          }
          if (code === -3) {
            return new ConflictException(
              `모델이 일치하지 않습니다. PID 의 모델코드(${serialNo.slice(6, 11)})가`
              + ' 작업지시의 모델과 다릅니다.',
            );
          }
          if (code === -4) {
            return new ConflictException(
              `이 PID 는 다른 작업지시에 이미 매핑되어 있습니다: ${serialNo}`,
            );
          }
          return new BadRequestException(`매핑 실패 (${code})`);
        },
      );
      const rows = (await qr.query(
        `SELECT COUNT(*) AS CNT FROM IP_PRODUCT_2D_BARCODE
          WHERE RUN_NO = :runNo AND ORGANIZATION_ID = :organizationId`,
        { runNo: dto.runNo.trim(), organizationId } as unknown as unknown[],
      )) as Array<{ CNT: number }>;
      return { serialNo, pidCount: Number(rows?.[0]?.CNT ?? 0) };
    });
  }

  /** 취소 — PKG_MES_PLN.SP_PLN_KITTING_CANCEL. */
  async cancel(dto: KittingCancelDto, organizationId: number) {
    return this.tx.run(async (qr) => {
      await this.runProcedure(
        qr,
        `PKG_MES_PLN.SP_PLN_KITTING_CANCEL(
           :runNo, :serialNo, :organizationId, v_result);`,
        'KITTING_CANCEL_FAILED',
        {
          runNo: dto.runNo.trim(),
          serialNo: dto.serialNo.trim(),
          organizationId,
        },
        (code) => {
          if (code === -1) {
            return new NotFoundException(
              `이 작업지시에 그 PID 가 없습니다: ${dto.serialNo}`,
            );
          }
          return new ConflictException(
            `이미 QC 검사된 PID 는 매핑을 취소할 수 없습니다: ${dto.serialNo}`,
          );
        },
      );
      const rows = (await qr.query(
        `SELECT COUNT(*) AS CNT FROM IP_PRODUCT_2D_BARCODE
          WHERE RUN_NO = :runNo AND ORGANIZATION_ID = :organizationId`,
        { runNo: dto.runNo.trim(), organizationId } as unknown as unknown[],
      )) as Array<{ CNT: number }>;
      return { serialNo: dto.serialNo.trim(), pidCount: Number(rows?.[0]?.CNT ?? 0) };
    });
  }

  /** 전체 해제 — PKG_MES_PLN.SP_PLN_KITTING_CLEAR. */
  async clear(dto: KittingClearDto, organizationId: number) {
    return this.tx.run(async (qr) => {
      const before = (await qr.query(
        `SELECT COUNT(*) AS CNT FROM IP_PRODUCT_2D_BARCODE
          WHERE RUN_NO = :runNo AND ORGANIZATION_ID = :organizationId`,
        { runNo: dto.runNo.trim(), organizationId } as unknown as unknown[],
      )) as Array<{ CNT: number }>;

      await this.runProcedure(
        qr,
        `PKG_MES_PLN.SP_PLN_KITTING_CLEAR(:runNo, :organizationId, v_result);`,
        'KITTING_CLEAR_FAILED',
        { runNo: dto.runNo.trim(), organizationId },
        (code) => {
          if (code === -1) {
            return new NotFoundException(`작업지시를 찾을 수 없습니다: ${dto.runNo}`);
          }
          // 프로시저가 -2 * QC스캔건수 로 실어 보낸다
          return new ConflictException(
            `QC 검사된 PID ${Math.abs(code) / 2}건이 있어 전체 해제할 수 없습니다.`,
          );
        },
      );
      const after = (await qr.query(
        `SELECT COUNT(*) AS CNT FROM IP_PRODUCT_2D_BARCODE
          WHERE RUN_NO = :runNo AND ORGANIZATION_ID = :organizationId`,
        { runNo: dto.runNo.trim(), organizationId } as unknown as unknown[],
      )) as Array<{ CNT: number }>;
      return {
        deleted: Number(before?.[0]?.CNT ?? 0) - Number(after?.[0]?.CNT ?? 0),
      };
    });
  }
}
