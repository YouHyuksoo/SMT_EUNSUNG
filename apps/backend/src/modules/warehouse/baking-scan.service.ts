/**
 * @file src/modules/warehouse/baking-scan.service.ts
 * @description 261 베이킹이력관리 — PB `w_mat_baking_dehumi_scan_master` 이식 (**쓰기**)
 *
 * 초보자 가이드:
 * 1. **자재를 챔버에 넣고 꺼내는 화면이다.** 세 종류가 있다 —
 *    `B` 베이킹실(습기를 굽는다) · `V` 진공포장 · `D` 제습함.
 *    조회 쪽은 이미 262·263·264 화면으로 옮겨져 있고, 여기는 **넣기·꺼내기**다.
 *    실측 이력 18,355건 (V 9,344 · D 8,778 · B 233), 2026-09-28 까지 쌓이고 있다.
 * 2. **MSL 시계가 함께 움직인다** — 이게 이 화면의 핵심이다. MSL 은 습기에 민감한
 *    부품이 공기에 노출된 누적 시간이고, 그 시간이 넘으면 출고할 수 없다 (238 검사).
 *    챔버 종류마다 시계가 다르게 움직인다 (PB 그대로):
 *
 *        넣을 때   B: 남은시간 = 지난시간 (기록만 하고 시계는 그대로)
 *                  V·D: 지난시간 += (지금 − 개봉시각) × 24 → 개봉시각을 지운다
 *                       (챔버에 들어간 동안은 노출되지 않으므로 시계를 멈춘다)
 *        꺼낼 때   B: **지난시간 = 0.01 로 초기화** (구웠으니 습기가 빠졌다)
 *                  V: 진공 종료시각만 남긴다
 *                  D: **개봉시각 = 지금** (꺼낸 순간부터 다시 노출된다)
 *
 *    `0.01` 은 0 이 아니다 — PB 주석에 이유가 적혀 있다 (0 이면 "한 번도 노출되지
 *    않음" 과 구분되지 않는다). 그대로 둔다.
 * 3. **넣기 전 거절 조건 둘** (PB 그대로): 폐기된 릴(`REEL_DESTROY_YN='Y'`) ·
 *    라인에 투입 중인 릴(`IB_PRODUCT_PLANDATA.ACTIVE_YN='Y'`).
 * 4. **꺼내기는 "넣어 둔 것" 이 있어야 한다** — 같은 품목·롯트로 `OUTPUT_SCAN_DATE` 가
 *    비어 있는 건이 있어야 꺼낼 수 있다.
 * 5. **재고 표에도 날짜를 남긴다** (`IM_ITEM_INVENTORY.BAKING_DATE` ·
 *    `VACUUM_DATE` · `DEHUMIDIFY_DATE`) — 넣을 때만 쓴다.
 * 6. **`dw_1.update()` 는 무동작이다.** 대상 표는 `IM_ITEM_BAKING_MASTER` 지만
 *    편집 가능한 열이 하나도 갱신 대상이 아니다 (실측). 옮기지 않았다.
 * 7. **쓰기는 실행하지 않고 parse 로만 검증했다** (사용자 결정).
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { likePrefix } from '@smt/shared';
import { limited, ROW_LIMIT } from '../../shared/row-limit';
import { TransactionService } from '../../shared/transaction.service';
import { BakingScanDto, BakingHistoryQueryDto } from './warehouse.dto';
import { affectedRows } from '../../common/utils/affected-rows.util';

type Row = Record<string, unknown>;

/**
 * 챔버 종류별 부수 효과. 표로 두면 어느 종류에 무엇이 일어나는지 한눈에 보인다
 * (파일 머리 2번의 설명과 같은 순서다).
 */
const CHAMBER_EFFECT = {
  B: {
    label: '베이킹실',
    /** 넣을 때 바코드에 적용할 SET 절 */
    inputSet: `MSL_REMAIN_TIME = MSL_PASSED_TIME,
                BAKING_START_DATE = SYSDATE,
                BAKING_END_DATE = NULL,
                MSL_OPEN_DATE = NULL`,
    /** 꺼낼 때 바코드에 적용할 SET 절. 0.01 은 PB 값 그대로다. */
    outputSet: `BAKING_END_DATE = SYSDATE,
                MSL_PASSED_TIME = 0.01`,
    /** 넣을 때 재고 표에 남길 날짜 열 */
    inventoryColumn: 'BAKING_DATE',
  },
  V: {
    label: '진공포장',
    inputSet: `MSL_PASSED_TIME = NVL(MSL_PASSED_TIME, 0)
                  + ((SYSDATE - NVL(MSL_OPEN_DATE, SYSDATE)) * 24),
                MSL_OPEN_DATE = NULL,
                VACUUM_START_DATE = SYSDATE,
                VACUUM_END_DATE = SYSDATE`,
    outputSet: 'VACUUM_END_DATE = SYSDATE',
    inventoryColumn: 'VACUUM_DATE',
  },
  D: {
    label: '제습함',
    inputSet: `MSL_PASSED_TIME = NVL(MSL_PASSED_TIME, 0)
                  + ((SYSDATE - NVL(MSL_OPEN_DATE, SYSDATE)) * 24),
                MSL_OPEN_DATE = NULL,
                DEHUMIDIFY_START_DATE = SYSDATE,
                DEHUMIDIFY_END_DATE = NULL`,
    // 꺼내면 그 순간부터 다시 공기에 노출된다 — 개봉시각을 새로 찍는다.
    outputSet: `MSL_OPEN_DATE = SYSDATE,
                DEHUMIDIFY_END_DATE = SYSDATE`,
    inventoryColumn: 'DEHUMIDIFY_DATE',
  },
} as const;

type ChamberKind = keyof typeof CHAMBER_EFFECT;

@Injectable()
export class BakingScanService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  // ───────────────────────────────── 조회

  /**
   * 챔버 입출고 이력 (PB `d_mat_material_baking_dehumi_scan_lst`).
   *
   * 262·263·264 는 **지금 들어가 있는 것**만 보지만, 여기는 넣고 꺼낸 이력을 다 본다.
   */
  async findHistory(query: BakingHistoryQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT m.CHAMBER_TYPE             AS "chamberType",
              m.CHAMBER_CODE             AS "chamberCode",
              m.CHAMBER_LOCATION         AS "chamberLocation",
              m.ITEM_CODE                AS "itemCode",
              i.ITEM_NAME                AS "itemName",
              i.ITEM_SPEC                AS "itemSpec",
              i.MSL_LEVEL                AS "mslLevel",
              m.ITEM_BARCODE             AS "itemBarcode",
              m.LOT_NO                   AS "lotNo",
              m.LOT_QTY                  AS "lotQty",
              TO_CHAR(m.INPUT_SCAN_DATE, 'YYYY-MM-DD HH24:MI:SS')  AS "inputScanDate",
              TO_CHAR(m.OUTPUT_SCAN_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "outputScanDate",
              -- 챔버에 머문 시간. 아직 안 꺼냈으면 지금까지다.
              ROUND((NVL(m.OUTPUT_SCAN_DATE, SYSDATE) - m.INPUT_SCAN_DATE) * 24, 2)
                                         AS "stayHours",
              CASE WHEN m.OUTPUT_SCAN_DATE IS NULL THEN 'Y' ELSE 'N' END AS "inChamberYn",
              m.SCAN_BY                  AS "scanBy",
              m.ENTER_BY                 AS "enterBy",
              TO_CHAR(m.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')       AS "enterDate"
         FROM IM_ITEM_BAKING_MASTER m
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = m.ITEM_CODE
               AND i.ORGANIZATION_ID = m.ORGANIZATION_ID
        WHERE m.INPUT_SCAN_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND m.INPUT_SCAN_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND NVL(m.CHAMBER_TYPE, '*') LIKE :chamberType ESCAPE '\\'
          AND m.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND NVL(m.LOT_NO, '*') LIKE :lotNo ESCAPE '\\'
          AND NVL(m.CHAMBER_CODE, '*') LIKE :chamberCode ESCAPE '\\'
          AND m.ORGANIZATION_ID = :organizationId
        ORDER BY m.INPUT_SCAN_DATE DESC
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        chamberType: likePrefix(query.chamberType),
        itemCode: likePrefix(query.itemCode),
        lotNo: likePrefix(query.lotNo),
        chamberCode: likePrefix(query.chamberCode),
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /**
   * 찍은 바코드를 풀어 본다 (읽기 전용).
   *
   * 지금 이 릴이 챔버에 들어가 있는지, 넣기·꺼내기가 각각 되는지 낸다.
   */
  async lookupBarcode(barcode: string, chamberType: string, organizationId: number) {
    const parsed = ((await this.dataSource.query(
      `SELECT F_GET_PREPARE_BARCODE(:barcode)  AS "clean",
              F_GET_ITEM_CODE_FROM_BARCODE(
                F_GET_PREPARE_BARCODE(:barcode)) AS "itemCode",
              F_GET_LOT_NO_FROM_BARCODE(
                F_GET_PREPARE_BARCODE(:barcode)) AS "lotNo"
         FROM DUAL`,
      { barcode } as unknown as unknown[],
    )) as Row[])[0] ?? {};
    const itemCode = (parsed.itemCode as string) || '';
    const lotNo = (parsed.lotNo as string) || '';
    if (!itemCode || !lotNo) {
      return {
        barcode: (parsed.clean as string) ?? barcode,
        itemCode: null, lotNo: null, barcodeRow: null,
        canInput: false, canOutput: false,
        reason: '바코드에서 품목·롯트를 찾을 수 없습니다.',
      };
    }

    const info = ((await this.dataSource.query(
      `SELECT b.ITEM_BARCODE                  AS "itemBarcode",
              DECODE(NVL(b.NEW_SCAN_QTY, 0), 0, b.SCAN_QTY, b.NEW_SCAN_QTY) AS "lotQty",
              NVL(b.REEL_DESTROY_YN, 'N')     AS "reelDestroyYn",
              b.MSL_PASSED_TIME               AS "mslPassedTime",
              b.MSL_REMAIN_TIME               AS "mslRemainTime",
              TO_CHAR(b.MSL_OPEN_DATE, 'YYYY-MM-DD HH24:MI:SS')  AS "mslOpenDate",
              i.ITEM_NAME                     AS "itemName",
              i.ITEM_SPEC                     AS "itemSpec",
              i.MSL_LEVEL                     AS "mslLevel",
              -- 라인에 투입 중이면 챔버에 넣을 수 없다 (PB 가드).
              ( SELECT COUNT(*)
                  FROM IB_PRODUCT_PLANDATA p
                 WHERE p.ACTIVE_YN = 'Y'
                   AND p.ITEM_BARCODE = b.ITEM_BARCODE ) AS "activePlanCount",
              -- 지금 이 챔버 종류에 들어가 있는 건 (꺼낼 수 있는지).
              ( SELECT COUNT(*)
                  FROM IM_ITEM_BAKING_MASTER m
                 WHERE m.ITEM_CODE = b.ITEM_CODE
                   AND m.LOT_NO = b.LOT_NO
                   AND m.OUTPUT_SCAN_DATE IS NULL
                   AND m.ORGANIZATION_ID = b.ORGANIZATION_ID ) AS "openCount"
         FROM IM_ITEM_RECEIPT_BARCODE b
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = b.ITEM_CODE
               AND i.ORGANIZATION_ID = b.ORGANIZATION_ID
        WHERE b.ITEM_CODE = :itemCode
          AND b.LOT_NO = :lotNo
          AND b.ORGANIZATION_ID = :organizationId`,
      { itemCode, lotNo, organizationId } as unknown as unknown[],
    )) as Row[])[0] ?? null;

    const openCount = Number(info?.openCount ?? 0);
    const inputReason = !info
      ? `바코드가 원장에 없습니다: ${itemCode}-${lotNo}`
      : String(info.reelDestroyYn) === 'Y'
        ? '폐기된 릴은 챔버에 넣을 수 없습니다.'
        : Number(info.activePlanCount ?? 0) > 0
          ? '라인에 투입 중인 릴은 챔버에 넣을 수 없습니다.'
          : openCount > 0
            ? '이미 챔버에 들어가 있습니다. 먼저 꺼내세요.'
            : null;
    const outputReason = !info
      ? `바코드가 원장에 없습니다: ${itemCode}-${lotNo}`
      : openCount === 0
        ? '챔버에 들어가 있지 않습니다 (넣은 기록이 없습니다).'
        : null;

    return {
      barcode: (parsed.clean as string) ?? barcode,
      itemCode,
      lotNo,
      chamberType,
      barcodeRow: info,
      openCount,
      canInput: inputReason === null,
      canOutput: outputReason === null,
      inputReason,
      outputReason,
      reason: null,
    };
  }

  // ───────────────────────────────── 넣기·꺼내기 (쓰기)

  /**
   * 챔버에 넣거나 꺼낸다 (**쓰기**).
   *
   * MSL 시계가 챔버 종류마다 다르게 움직인다 (파일 머리 2번) — `CHAMBER_EFFECT` 표가
   * 그 규칙을 담고 있고, SQL 조각을 그대로 붙인다. 산술을 TypeScript 로 옮기면
   * PB 와 값이 갈린다.
   */
  async scan(dto: BakingScanDto, organizationId: number, userId: string) {
    const kind = dto.chamberType as ChamberKind;
    const effect = CHAMBER_EFFECT[kind];
    if (!effect) {
      throw new BadRequestException(`알 수 없는 챔버 종류입니다: ${dto.chamberType}`);
    }

    const lookup = await this.lookupBarcode(dto.barcode, dto.chamberType, organizationId);
    const info = lookup.barcodeRow as Row | null;
    if (!info) {
      throw new BadRequestException(lookup.inputReason ?? '바코드를 찾을 수 없습니다.');
    }

    if (dto.direction === 'IN') {
      if (!lookup.canInput) {
        throw new BadRequestException(lookup.inputReason ?? '넣을 수 없습니다.');
      }
      return this.tx.run(async (qr) => {
        const inserted = await qr.query(
          `INSERT INTO IM_ITEM_BAKING_MASTER
             (CHAMBER_CODE, CHAMBER_TYPE, CHAMBER_LOCATION,
              INPUT_SCAN_DATE, OUTPUT_SCAN_DATE, SCAN_BY,
              ITEM_CODE, ITEM_BARCODE, LOT_NO, LOT_QTY,
              ORGANIZATION_ID, ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
           SELECT :chamberCode, :chamberType, :chamberLocation,
                  SYSDATE, NULL, :userId,
                  :itemCode, :itemBarcode, :lotNo, :lotQty,
                  :organizationId, SYSDATE, :userId, SYSDATE, :userId
             FROM DUAL
            -- 같은 릴을 두 번 찍어도 한 번만 들어간다 (PB 에 없던 방어).
            WHERE NOT EXISTS (
                    SELECT 1
                      FROM IM_ITEM_BAKING_MASTER x
                     WHERE x.ITEM_CODE = :itemCode
                       AND x.LOT_NO = :lotNo
                       AND x.OUTPUT_SCAN_DATE IS NULL
                       AND x.ORGANIZATION_ID = :organizationId)`,
          {
            chamberCode: dto.chamberCode,
            chamberType: dto.chamberType,
            chamberLocation: dto.chamberLocation ?? null,
            userId,
            itemCode: lookup.itemCode,
            itemBarcode: (info.itemBarcode as string) ?? lookup.barcode,
            lotNo: lookup.lotNo,
            lotQty: Number(info.lotQty ?? 0),
            organizationId,
          } as unknown as unknown[],
        );
        const masterRows = Number(
          affectedRows(inserted) ?? 0,
        );
        if (masterRows !== 1) {
          throw new BadRequestException('이미 챔버에 들어가 있습니다. 먼저 꺼내세요.');
        }

        // MSL 시계를 챔버 종류에 맞게 움직인다.
        const barcodeResult = await qr.query(
          `UPDATE IM_ITEM_RECEIPT_BARCODE
              SET ${effect.inputSet},
                  LAST_MODIFY_DATE = SYSDATE,
                  LAST_MODIFY_BY = :userId
            WHERE ITEM_CODE = :itemCode
              AND LOT_NO = :lotNo
              AND ORGANIZATION_ID = :organizationId`,
          {
            userId, itemCode: lookup.itemCode, lotNo: lookup.lotNo, organizationId,
          } as unknown as unknown[],
        );

        const inventoryResult = await qr.query(
          `UPDATE IM_ITEM_INVENTORY
              SET ${effect.inventoryColumn} = SYSDATE
            WHERE ITEM_CODE = :itemCode
              AND MATERIAL_MFS = :lotNo
              AND ORGANIZATION_ID = :organizationId`,
          {
            itemCode: lookup.itemCode, lotNo: lookup.lotNo, organizationId,
          } as unknown as unknown[],
        );

        return {
          direction: 'IN' as const,
          chamberType: dto.chamberType,
          chamberLabel: effect.label,
          chamberCode: dto.chamberCode,
          itemCode: lookup.itemCode,
          lotNo: lookup.lotNo,
          lotQty: Number(info.lotQty ?? 0),
          masterRows,
          barcodeRows: Number(
            affectedRows(barcodeResult) ?? 0,
          ),
          inventoryRows: Number(
            affectedRows(inventoryResult) ?? 0,
          ),
        };
      });
    }

    // 꺼내기
    if (!lookup.canOutput) {
      throw new BadRequestException(lookup.outputReason ?? '꺼낼 수 없습니다.');
    }
    return this.tx.run(async (qr) => {
      // **꺼낸 표시를 UPDATE 조건에 넣는다** — 두 번 찍어도 한 번만 꺼내진다.
      const closed = await qr.query(
        `UPDATE IM_ITEM_BAKING_MASTER
            SET OUTPUT_SCAN_DATE = SYSDATE,
                LAST_MODIFY_DATE = SYSDATE,
                LAST_MODIFY_BY = :userId
          WHERE ITEM_CODE = :itemCode
            AND LOT_NO = :lotNo
            AND OUTPUT_SCAN_DATE IS NULL
            AND CHAMBER_TYPE = :chamberType
            AND CHAMBER_CODE = :chamberCode
            AND ORGANIZATION_ID = :organizationId`,
        {
          userId,
          itemCode: lookup.itemCode,
          lotNo: lookup.lotNo,
          chamberType: dto.chamberType,
          chamberCode: dto.chamberCode,
          organizationId,
        } as unknown as unknown[],
      );
      const masterRows = Number(affectedRows(closed) ?? 0);
      if (masterRows < 1) {
        throw new BadRequestException(
          '이 챔버에 들어 있는 기록이 없습니다 (챔버 번호를 확인하세요).',
        );
      }

      const barcodeResult = await qr.query(
        `UPDATE IM_ITEM_RECEIPT_BARCODE
            SET ${effect.outputSet},
                LAST_MODIFY_DATE = SYSDATE,
                LAST_MODIFY_BY = :userId
          WHERE ITEM_CODE = :itemCode
            AND LOT_NO = :lotNo
            AND ORGANIZATION_ID = :organizationId`,
        {
          userId, itemCode: lookup.itemCode, lotNo: lookup.lotNo, organizationId,
        } as unknown as unknown[],
      );

      return {
        direction: 'OUT' as const,
        chamberType: dto.chamberType,
        chamberLabel: effect.label,
        chamberCode: dto.chamberCode,
        itemCode: lookup.itemCode,
        lotNo: lookup.lotNo,
        masterRows,
        barcodeRows: Number(
          affectedRows(barcodeResult) ?? 0,
        ),
        /** 베이킹에서 꺼내면 MSL 시계가 초기화된다 (PB 값 0.01). */
        mslReset: kind === 'B',
      };
    });
  }
}
