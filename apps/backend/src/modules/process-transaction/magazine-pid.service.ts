/**
 * @file src/modules/process-transaction/magazine-pid.service.ts
 * @description 231 매거진-PID 매핑관리 — PB `w_pln_product_barcode_create_master` 이식 (**쓰기**)
 *
 * 초보자 가이드:
 * 1. **어느 상자에 어느 기판이 들어갔는지 적는 화면이다.** 매거진 라벨을 먼저 찍고,
 *    그 상자에 담는 기판의 PID(제품 일련번호)를 하나씩 찍는다. 찍을 때마다
 *    `IP_PRODUCT_2D_BARCODE` 에 한 행이 생긴다 — 이 행이 그 기판의 출생기록이다.
 * 2. **PID 는 10자 이상이어야 한다** (PB 검사 그대로). 짧으면 스캐너가 덜 읽은 것이다.
 * 3. **같은 PID 를 두 번 찍으면 거절한다.** PB 는 화면에 뿌려진 목록에서만 찾아
 *    **다른 상자에 이미 들어간 PID 를 잡지 못했다.** 여기서는 원장 전체를 본다 —
 *    같은 기판이 두 상자에 들어갔다고 기록되면 추적이 끊긴다.
 * 4. **취소는 행을 지운다** (PB `rb_cancel` 그대로). 잘못 찍었을 때 되돌리는 수단이다.
 * 5. **이 표는 1억 8천만 행이다** (실측 180,632,818). 그래서 조회는 반드시
 *    인덱스를 타는 컬럼으로 시작한다 — `SERIAL_NO`(단건 확인)와
 *    `MAGAZINE_NO`(상자별 목록) 둘 다 인덱스가 있다. **두 컬럼에 NVL 을 씌우지 않는다.**
 * 6. **엑셀 일괄등록 팝업은 옮기지 않았다.** PB 는 엑셀 파일을 읽어 한 번에 넣는데,
 *    파일 업로드·검증 규칙이 따로 필요하다. 스캔 경로부터 맞추고 뒤에 붙인다.
 * 7. **쓰기는 실행하지 않고 parse 로만 검증했다** (사용자 결정).
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { limited, ROW_LIMIT } from '../../shared/row-limit';
import { TransactionService } from '../../shared/transaction.service';
import {
  MagazinePidCancelDto,
  MagazinePidMapDto,
  MagazinePidQueryDto,
} from './magazine-label.dto';

type Row = Record<string, unknown>;

/** PB `len(LVS_PID) < 10` — 스캐너가 덜 읽은 바코드를 막는다. */
const PID_MIN_LENGTH = 10;

/** PB `rb_normal` / `rb_repair` 가 정하던 `BARCODE_STATUS`. */
const BARCODE_STATUS = { normal: 'N', repair: 'R' } as const;

@Injectable()
export class MagazinePidService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  // ───────────────────────────────── 조회

  /**
   * 매거진 라벨을 풀어 본다 (PB `dw_1`).
   *
   * 이 상자가 어느 런카드·모델의 것인지 알아야 PID 행에 채울 값이 정해진다.
   */
  async lookupMagazine(magazineLabelNo: string, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT io.MAGAZINE_LABEL_NO  AS "magazineLabelNo",
              io.RUN_NO             AS "runNo",
              io.ITEM_CODE          AS "itemCode",
              io.MODEL_NAME         AS "modelName",
              io.MODEL_SUFFIX       AS "modelSuffix",
              io.LINE_CODE          AS "lineCode",
              ln.LINE_NAME          AS "lineName",
              io.WORKSTAGE_CODE     AS "workstageCode",
              io.PCB_ITEM           AS "pcbItem",
              io.LOT_QTY            AS "lotQty",
              io.RUN_DATE           AS "runDate",
              TO_CHAR(io.RECEIPT_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "receiptDate"
         FROM IP_PRODUCT_RUN_CARD_IO io
         LEFT JOIN IP_PRODUCT_LINE ln
                ON ln.LINE_CODE = io.LINE_CODE
               AND ln.ORGANIZATION_ID = io.ORGANIZATION_ID
        WHERE io.MAGAZINE_LABEL_NO = :magazineLabelNo
          AND io.ORGANIZATION_ID = :organizationId`,
      { magazineLabelNo, organizationId } as unknown as unknown[],
    )) as Row[];

    const magazine = rows[0] ?? null;
    return {
      magazineLabelNo,
      magazine,
      reason: magazine ? null : '매거진 라벨을 찾을 수 없습니다.',
    };
  }

  /**
   * 이 상자에 들어간 PID 목록 (PB `dw_2`).
   *
   * `MAGAZINE_NO` 로 시작한다 — 이 컬럼에 인덱스(`INDXIP_PRODUCT_2D_BARCODE4`)가
   * 있어 1억 8천만 행에서도 상자 하나만 읽는다.
   */
  async findMappings(query: MagazinePidQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT b.SERIAL_NO      AS "serialNo",
              b.RUN_NO         AS "runNo",
              b.MAGAZINE_NO    AS "magazineNo",
              b.ITEM_CODE      AS "itemCode",
              b.MODEL_NAME     AS "modelName",
              b.MODEL_SUFFIX   AS "modelSuffix",
              b.LINE_CODE      AS "lineCode",
              b.WORKSTAGE_CODE AS "workstageCode",
              b.BARCODE_STATUS AS "barcodeStatus",
              b.QC_SCAN_YN     AS "qcScanYn",
              b.LOT_QTY        AS "lotQty",
              b.ENTER_BY       AS "enterBy",
              TO_CHAR(b.RUN_DATE, 'YYYY-MM-DD')                 AS "runDate",
              TO_CHAR(b.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')    AS "enterDate"
         FROM IP_PRODUCT_2D_BARCODE b
        WHERE b.MAGAZINE_NO = :magazineLabelNo
          AND b.ORGANIZATION_ID = :organizationId
        ORDER BY b.ENTER_DATE, b.SERIAL_NO
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        magazineLabelNo: query.magazineLabelNo,
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /**
   * PID 한 건이 이미 원장에 있는지 본다 (읽기 전용).
   *
   * PB 는 화면 목록에서만 찾아 **다른 상자에 들어간 PID 를 놓쳤다.** 여기서는
   * `SERIAL_NO` 인덱스로 원장 전체를 본다.
   */
  async lookupPid(serialNo: string, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT b.SERIAL_NO   AS "serialNo",
              b.MAGAZINE_NO AS "magazineNo",
              b.RUN_NO      AS "runNo",
              b.MODEL_NAME  AS "modelName",
              b.BARCODE_STATUS AS "barcodeStatus",
              TO_CHAR(b.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "enterDate"
         FROM IP_PRODUCT_2D_BARCODE b
        WHERE b.SERIAL_NO = :serialNo
          AND b.ORGANIZATION_ID = :organizationId
        FETCH FIRST 1 ROWS ONLY`,
      { serialNo, organizationId } as unknown as unknown[],
    )) as Row[];
    return rows[0] ?? null;
  }

  // ───────────────────────────────── 매핑 (쓰기)

  /** PID 한 건을 상자에 담는다 (**쓰기**). */
  async mapPid(dto: MagazinePidMapDto, organizationId: number, userId: string) {
    const serialNo = dto.serialNo.trim();
    if (serialNo.length < PID_MIN_LENGTH) {
      throw new BadRequestException(
        `PID 가 ${PID_MIN_LENGTH}자보다 짧습니다. 다시 찍으세요: ${serialNo}`,
      );
    }

    const lookup = await this.lookupMagazine(dto.magazineLabelNo, organizationId);
    if (!lookup.magazine) {
      throw new BadRequestException(lookup.reason ?? '매거진 라벨을 찾을 수 없습니다.');
    }
    const magazine = lookup.magazine as Row;

    const existing = await this.lookupPid(serialNo, organizationId);
    if (existing) {
      throw new BadRequestException(
        `이미 등록된 PID 입니다 (상자 ${String(existing.magazineNo ?? '-')}).`,
      );
    }

    const barcodeStatus = dto.repair ? BARCODE_STATUS.repair : BARCODE_STATUS.normal;

    return this.tx.run(async (qr) => {
      const result = await qr.query(
        `INSERT INTO IP_PRODUCT_2D_BARCODE
           (SERIAL_NO, RUN_NO, RUN_DATE, ITEM_CODE, MODEL_NAME, MODEL_SUFFIX,
            LINE_CODE, WORKSTAGE_CODE, MAGAZINE_NO, BARCODE_STATUS, QC_SCAN_YN,
            LOT_QTY, ORGANIZATION_ID, ENTER_DATE, ENTER_BY,
            LAST_MODIFY_DATE, LAST_MODIFY_BY)
         SELECT :serialNo, :runNo, :runDate, :itemCode, :modelName, :modelSuffix,
                :lineCode, :workstageCode, :magazineNo, :barcodeStatus, 'N',
                1, :organizationId, SYSDATE, :userId,
                SYSDATE, :userId
           FROM DUAL
          WHERE NOT EXISTS (
                  SELECT 1 FROM IP_PRODUCT_2D_BARCODE x
                   WHERE x.SERIAL_NO = :serialNo
                     AND x.ORGANIZATION_ID = :organizationId)`,
        {
          serialNo,
          runNo: String(magazine.runNo ?? ''),
          runDate: (magazine.runDate as Date) ?? null,
          itemCode: String(magazine.itemCode ?? ''),
          modelName: String(magazine.modelName ?? ''),
          modelSuffix: (magazine.modelSuffix as string) ?? null,
          lineCode: String(magazine.lineCode ?? ''),
          workstageCode: String(magazine.workstageCode ?? ''),
          magazineNo: dto.magazineLabelNo,
          barcodeStatus,
          organizationId,
          userId,
        } as unknown as unknown[],
      );
      const affected = Number(
        (result as { rowsAffected?: number })?.rowsAffected ?? 0,
      );
      if (affected !== 1) {
        // 조회와 INSERT 사이에 다른 자리에서 같은 PID 를 찍은 것이다.
        throw new BadRequestException(`이미 등록된 PID 입니다: ${serialNo}`);
      }
      return { serialNo, magazineLabelNo: dto.magazineLabelNo, barcodeStatus };
    });
  }

  /**
   * 잘못 찍은 PID 를 뺀다 (**쓰기**).
   *
   * **이 상자에 들어간 것만** 지운다. 상자 조건을 빼면 다른 상자의 기록까지
   * 지울 수 있다.
   */
  async cancelPid(dto: MagazinePidCancelDto, organizationId: number) {
    const serialNo = dto.serialNo.trim();
    return this.tx.run(async (qr) => {
      const result = await qr.query(
        `DELETE FROM IP_PRODUCT_2D_BARCODE
          WHERE SERIAL_NO = :serialNo
            AND MAGAZINE_NO = :magazineLabelNo
            AND ORGANIZATION_ID = :organizationId
            -- 공정·검사가 이미 읽어 간 기록은 지우지 않는다 (PB 는 막지 않았다).
            AND NVL(QC_SCAN_YN, 'N') <> 'Y'`,
        {
          serialNo,
          magazineLabelNo: dto.magazineLabelNo,
          organizationId,
        } as unknown as unknown[],
      );
      const affected = Number(
        (result as { rowsAffected?: number })?.rowsAffected ?? 0,
      );
      if (affected !== 1) {
        throw new BadRequestException(
          `이 상자에서 뺄 수 없는 PID 입니다 (없거나 이미 검사에 쓰였습니다): ${serialNo}`,
        );
      }
      return { serialNo, magazineLabelNo: dto.magazineLabelNo, deletedRows: affected };
    });
  }
}
