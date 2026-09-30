/**
 * @file src/modules/inventory-query/inventory-check.service.ts
 * @description 272 자재재고조사 (**쓰기**) · 274 자재바코드스캔실사 (조회) —
 *              PB `w_mat_inventory_check_master` · `w_mat_barcode_check_master` 이식
 *
 * 초보자 가이드:
 * 1. **실사(實査)는 장부와 실제를 맞추는 일이다.** 창고에 가서 센 수량을 적고,
 *    장부와 다르면 그 차이만큼 원장을 조정한다.
 * 2. **272 는 품목·롯트 단위로 센다.** 실사수량을 적으면 차이만큼 조정 출고를 만든다:
 *        차이 > 0 (실제가 더 많다) → 구분 3, 바코드를 "나간 것" 으로 표시
 *        차이 < 0 (실제가 적다)   → 구분 4, 바코드를 "돌아온 것" 으로 표시
 *    조정 출고는 계정 `M009` · 비고 `INVENTORY ADJUST` 로 남는다 (PB 그대로).
 *    날짜는 `F_GET_INVENTORY_CLOSE_DATE(마감월, 'END'|'LAST', 조직)` 이 정한다 —
 *    조정은 **마감월의 마지막 날짜로 들어가야** 그 달 수불이 맞는다.
 * 3. **이 현장은 실사를 아직 돌린 적이 없다** (실측):
 *        `IM_ITEM_INVENTORY_CHECK`       0행
 *        `IM_ITEM_INVENTORY_CHECK_EXCEL` 0행
 *        `IM_ITEM_INVENTORY_CHECK_BCD`   1행 (2020-10, 6년 전)
 *        출고 원장에 계정 `M009` 가 **0건** (M001 1,897,372 · M016 722,578 뿐)
 *    구조는 옮겨 두고 이 사실을 화면에 적었다 — 빈 화면만 보면 헷갈린다.
 * 4. **274 는 조회만 옮겼다.** 그쪽 쓰기 경로는 실사에서 발견된 무전표 바코드를
 *    **가상 입고로 만드는 것**인데 (`INSERT INTO IM_ITEM_RECEIPT`,
 *    `SUPPLIER_CODE='LGE'` 하드코딩), 6년간 쓰이지 않은 경로다. 검증할 수 없는
 *    원장 생성 코드를 미리 만들어 두는 것은 위험만 늘린다 — 필요해지면 그때
 *    실측을 다시 하고 붙인다.
 * 5. **쓰기는 실행하지 않고 parse 로만 검증했다** (사용자 결정).
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { likePrefix } from '@smt/shared';
import { limited, ROW_LIMIT } from '../../shared/row-limit';
import { TransactionService } from '../../shared/transaction.service';
import {
  BarcodeCheckQueryDto,
  InventoryAdjustDto,
  InventoryCheckQueryDto,
} from './inventory-query.dto';
import { affectedRows } from '../../common/utils/affected-rows.util';

type Row = Record<string, unknown>;

/** PB 가 조정 출고에 고정으로 넣던 값. */
const ADJUST = {
  /** 재고조정 전용 계정 (실측 원장에 0건 — 아직 한 번도 조정하지 않았다) */
  issueAccount: 'M009',
  comments: 'INVENTORY ADJUST',
  itemType: 'T',
  issueStatus: 'N',
  issueType: 'E',
  virtualReceiptYn: 'N',
  lineCode: '*',
  workstageCode: '*',
  machineCode: '*',
  supplierCode: '*',
  invoiceNo: '*',
  madeBy: '*',
  parentItemCode: '*',
} as const;

@Injectable()
export class InventoryCheckService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  // ───────────────────────────────── 272 재고조사

  /**
   * 실사 대상·결과 (PB `d_mat_inventory_check_lst`).
   *
   * 실사표(`IM_ITEM_INVENTORY_CHECK`)에 담긴 장부수량과 실사수량, 그 차이를 본다.
   * **이 표는 0행이다** — 실사를 돌린 적이 없다.
   */
  async findCheckList(query: InventoryCheckQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT c.CLOSE_YYYYMM             AS "closeYyyymm",
              c.ITEM_CODE                AS "itemCode",
              i.ITEM_NAME                AS "itemName",
              i.ITEM_SPEC                AS "itemSpec",
              i.ITEM_UOM                 AS "itemUom",
              c.LINE_TYPE                AS "lineType",
              c.MATERIAL_MFS             AS "lotNo",
              c.LOCATION_CODE            AS "locationCode",
              c.INVENTORY_HOLD           AS "inventoryHold",
              c.INVENTORY_QTY            AS "bookQty",
              c.CHECK_INVENTORY_QTY      AS "checkQty",
              -- 차이 = 실사 − 장부. 양수면 실제가 더 많다는 뜻이다.
              NVL(c.CHECK_INVENTORY_QTY, 0) - NVL(c.INVENTORY_QTY, 0) AS "differenceQty",
              c.INVENTORY_PRICE          AS "inventoryPrice",
              c.INVENTORY_AMT            AS "inventoryAmt",
              c.COMMENTS                 AS "comments",
              c.ENTER_BY                 AS "enterBy",
              TO_CHAR(c.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')       AS "enterDate"
         FROM IM_ITEM_INVENTORY_CHECK c
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = c.ITEM_CODE
               AND i.ORGANIZATION_ID = c.ORGANIZATION_ID
        WHERE c.CLOSE_YYYYMM = :yyyymm
          AND c.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND NVL(c.MATERIAL_MFS, '*') LIKE :lotNo ESCAPE '\\'
          AND NVL(c.LOCATION_CODE, '*') LIKE :locationCode ESCAPE '\\'
          AND c.ORGANIZATION_ID = :organizationId
        ORDER BY c.ITEM_CODE, c.MATERIAL_MFS
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        yyyymm: query.yyyymm,
        itemCode: likePrefix(query.itemCode),
        lotNo: likePrefix(query.lotNo),
        locationCode: likePrefix(query.locationCode),
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /**
   * 조정 이력 (PB `d_mat_issue_by_adjust_lst`).
   *
   * 실사로 만들어진 조정 출고만 본다 — 계정이 `M009` 인 것.
   * **실측 0건**이다 (아직 조정한 적이 없다).
   */
  async findAdjustHistory(query: InventoryCheckQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT TO_CHAR(s.ISSUE_DATE, 'YYYY-MM-DD')  AS "issueDate",
              s.ISSUE_SEQUENCE           AS "issueSequence",
              s.ITEM_CODE                AS "itemCode",
              i.ITEM_NAME                AS "itemName",
              i.ITEM_SPEC                AS "itemSpec",
              s.MATERIAL_MFS             AS "lotNo",
              s.LOCATION_CODE            AS "locationCode",
              s.ISSUE_DEFICIT            AS "issueDeficit",
              s.ISSUE_QTY                AS "issueQty",
              s.ISSUE_PRICE              AS "issuePrice",
              s.ISSUE_AMT                AS "issueAmt",
              s.LINE_TYPE                AS "lineType",
              s.INVENTORY_TYPE           AS "inventoryType",
              s.COMMENTS                 AS "comments",
              s.ENTER_BY                 AS "enterBy",
              TO_CHAR(s.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')       AS "enterDate"
         FROM IM_ITEM_ISSUE s
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = s.ITEM_CODE
               AND i.ORGANIZATION_ID = s.ORGANIZATION_ID
        WHERE s.ISSUE_DATE >= TO_DATE(:yyyymm || '01', 'YYYYMMDD')
          AND s.ISSUE_DATE <  ADD_MONTHS(TO_DATE(:yyyymm || '01', 'YYYYMMDD'), 1)
          AND s.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          -- 실사 조정만 본다 (PB 고정조건).
          AND s.ISSUE_ACCOUNT = '${ADJUST.issueAccount}'
          AND s.ORGANIZATION_ID = :organizationId
        ORDER BY s.ISSUE_DATE DESC, s.ISSUE_SEQUENCE DESC
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        yyyymm: query.yyyymm,
        itemCode: likePrefix(query.itemCode),
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /**
   * 재고 조정 (**쓰기**). PB 의 실사 확정 경로다.
   *
   *   ① 차이만큼 바코드 원장의 상태를 바꾼다 (많으면 "나간 것", 적으면 "돌아온 것")
   *   ② 조정 출고를 한 건 넣는다 (계정 M009 · 비고 INVENTORY ADJUST)
   *
   * 날짜는 `F_GET_INVENTORY_CLOSE_DATE` 가 정한다 — 조정은 **마감월의 마지막
   * 날짜로** 들어가야 그 달 수불이 맞는다. SYSDATE 를 쓰면 다음 달로 새어 나간다.
   */
  async adjustInventory(
    dto: InventoryAdjustDto,
    organizationId: number,
    userId: string,
  ) {
    const diff = Number(dto.differenceQty);
    if (!Number.isFinite(diff) || diff === 0) {
      throw new BadRequestException('차이 수량이 0 이면 조정할 것이 없습니다.');
    }

    return this.tx.run(async (qr) => {
      const facts = ((await qr.query(
        `SELECT v.INVENTORY_TYPE          AS "inventoryType",
                v.LINE_TYPE               AS "lineType",
                v.LOCATION_CODE           AS "locationCode",
                v.INVENTORY_PRICE         AS "inventoryPrice",
                v.INVENTORY_QTY           AS "bookQty"
           FROM IM_ITEM_INVENTORY v
          WHERE v.ITEM_CODE = :itemCode
            AND v.MATERIAL_MFS = :lotNo
            AND v.ORGANIZATION_ID = :organizationId`,
        {
          itemCode: dto.itemCode, lotNo: dto.lotNo, organizationId,
        } as unknown as unknown[],
      )) as Row[])[0] ?? null;
      if (!facts) {
        throw new BadRequestException(
          `재고를 찾을 수 없습니다: ${dto.itemCode} / ${dto.lotNo}`,
        );
      }

      // ① 바코드 원장 상태. 차이의 부호가 방향을 정한다 (PB 그대로).
      const plus = diff > 0;
      const barcodeResult = await qr.query(
        plus
          ? `UPDATE IM_ITEM_RECEIPT_BARCODE
                SET RECEIPT_COMPARE_YN = 'Y',
                    ISSUE_COMPARE_YN   = 'Y',
                    ISSUE_COMPARE_DATE = F_GET_INVENTORY_CLOSE_DATE(:yyyymm, 'END',
                                                                    :organizationId),
                    ISSUE_COMPARE_BY   = 'ADJUST',
                    ISSUE_RETURN_YN    = 'N',
                    FEEDING_YN         = 'Y',
                    LAST_MODIFY_DATE   = SYSDATE,
                    LAST_MODIFY_BY     = :userId
              WHERE LOT_NO = :lotNo
                AND ITEM_CODE = :itemCode
                AND ORGANIZATION_ID = :organizationId`
          : `UPDATE IM_ITEM_RECEIPT_BARCODE
                SET RECEIPT_COMPARE_YN = 'Y',
                    ISSUE_COMPARE_YN   = 'N',
                    ISSUE_COMPARE_DATE = NULL,
                    ISSUE_COMPARE_BY   = NULL,
                    ISSUE_RETURN_YN    = 'Y',
                    ISSUE_RETURN_DATE  = F_GET_INVENTORY_CLOSE_DATE(:yyyymm, 'END',
                                                                    :organizationId),
                    FEEDING_YN         = 'N',
                    -- MSL 시계를 되돌리지 않으려고 투입일만 지운다 (PB 주석).
                    FEEDING_DATE       = NULL,
                    LAST_MODIFY_DATE   = SYSDATE,
                    LAST_MODIFY_BY     = :userId
              WHERE LOT_NO = :lotNo
                AND ITEM_CODE = :itemCode
                AND ORGANIZATION_ID = :organizationId`,
        {
          yyyymm: dto.yyyymm,
          organizationId,
          userId,
          lotNo: dto.lotNo,
          itemCode: dto.itemCode,
        } as unknown as unknown[],
      );

      // ② 조정 출고. 날짜는 마감월의 마지막 날이다 (파일 머리 2번).
      const issueResult = await qr.query(
        `INSERT INTO IM_ITEM_ISSUE
           (ISSUE_DATE, ISSUE_SEQUENCE, ORGANIZATION_ID,
            MFS, ITEM_CODE, LOCATION_CODE, ITEM_TYPE, LINE_CODE, WORKSTAGE_CODE,
            ISSUE_DEFICIT, ISSUE_QTY, ISSUE_STATUS, ISSUE_AMT, ISSUE_ACCOUNT,
            LINE_TYPE, COMMENTS, ISSUE_PRICE, VIRTUAL_RECEIPT_YN, ISSUE_TYPE,
            SUPPLIER_CODE, WORK_ORDER_NO,
            ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY,
            MACHINE_CODE, INVOICE_NO, MADE_BY, PARENT_ITEM_CODE, MATERIAL_MFS,
            INVENTORY_TYPE)
         VALUES
           (F_GET_INVENTORY_CLOSE_DATE(:yyyymm, 'END', :organizationId),
            SEQ_MAT_ISSUE.NEXTVAL, :organizationId,
            :lotNo, :itemCode, :locationCode, '${ADJUST.itemType}',
            '${ADJUST.lineCode}', '${ADJUST.workstageCode}',
            :deficit, :diff, '${ADJUST.issueStatus}', :inventoryPrice * :diff,
            '${ADJUST.issueAccount}',
            :lineType, '${ADJUST.comments}', :inventoryPrice,
            '${ADJUST.virtualReceiptYn}', '${ADJUST.issueType}',
            '${ADJUST.supplierCode}', 0,
            F_GET_INVENTORY_CLOSE_DATE(:yyyymm, 'LAST', :organizationId),
            :userId, SYSDATE, :userId,
            '${ADJUST.machineCode}', '${ADJUST.invoiceNo}', '${ADJUST.madeBy}',
            '${ADJUST.parentItemCode}', :lotNo,
            :inventoryType)`,
        {
          yyyymm: dto.yyyymm,
          organizationId,
          lotNo: dto.lotNo,
          itemCode: dto.itemCode,
          locationCode: dto.locationCode ?? (facts.locationCode as string) ?? null,
          deficit: plus ? '3' : '4',
          diff,
          inventoryPrice: Number(facts.inventoryPrice ?? 0),
          lineType: (facts.lineType as string) ?? null,
          userId,
          inventoryType: (facts.inventoryType as string) ?? null,
        } as unknown as unknown[],
      );

      return {
        itemCode: dto.itemCode,
        lotNo: dto.lotNo,
        yyyymm: dto.yyyymm,
        bookQty: Number(facts.bookQty ?? 0),
        differenceQty: diff,
        /** 3 = 실제가 더 많음 · 4 = 실제가 적음 */
        issueDeficit: plus ? 3 : 4,
        barcodeRows: Number(
          affectedRows(barcodeResult) ?? 0,
        ),
        issueRows: Number(
          affectedRows(issueResult) ?? 0,
        ),
      };
    });
  }

  // ───────────────────────────────── 274 바코드 스캔실사 (조회)

  /**
   * 바코드 실사 목록 (PB `d_mat_inventory_barcode_check_lst`).
   *
   * 실사 때 찍은 바코드와 그때의 수량이다. **실측 1행(2020-10)** — 6년 동안
   * 쓰이지 않았다.
   */
  async findBarcodeCheck(query: BarcodeCheckQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT c.CHECK_YYYYMM             AS "checkYyyymm",
              c.CHECK_TYPE               AS "checkType",
              c.LINE_CODE                AS "lineCode",
              c.ITEM_BARCODE             AS "itemBarcode",
              c.ORIGIN_ITEM_BARCODE      AS "originItemBarcode",
              c.ITEM_CODE                AS "itemCode",
              i.ITEM_NAME                AS "itemName",
              i.ITEM_SPEC                AS "itemSpec",
              c.LOT_NO                   AS "lotNo",
              c.BARCODE_QTY              AS "barcodeQty",
              c.INVENTORY_QTY            AS "inventoryQty",
              -- 찍은 수량과 장부 수량의 차이. 0 이 아니면 맞춰야 한다.
              NVL(c.BARCODE_QTY, 0) - NVL(c.INVENTORY_QTY, 0) AS "differenceQty",
              c.LABEL_TYPE               AS "labelType",
              c.LOCATION_CODE            AS "locationCode",
              c.LOCATION_ADDRESS         AS "locationAddress",
              c.UNIT_PRICE               AS "unitPrice",
              c.INVENTORY_AMT            AS "inventoryAmt",
              c.INVOICE_NO               AS "invoiceNo",
              c.CUSTOMER_CODE            AS "customerCode",
              c.RECEIPT_LABEL_TYPE       AS "receiptLabelType",
              c.ENTER_BY                 AS "enterBy",
              TO_CHAR(c.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')      AS "enterDate"
         FROM IM_ITEM_INVENTORY_CHECK_BCD c
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = c.ITEM_CODE
               AND i.ORGANIZATION_ID = c.ORGANIZATION_ID
        WHERE c.CHECK_YYYYMM LIKE :yyyymm ESCAPE '\\'
          AND NVL(c.ITEM_CODE, '*') LIKE :itemCode ESCAPE '\\'
          AND NVL(c.LINE_CODE, '*') LIKE :lineCode ESCAPE '\\'
          AND c.ORGANIZATION_ID = :organizationId
        ORDER BY c.CHECK_YYYYMM DESC, c.ITEM_CODE, c.LOT_NO
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        yyyymm: likePrefix(query.yyyymm),
        itemCode: likePrefix(query.itemCode),
        lineCode: likePrefix(query.lineCode),
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /**
   * 바코드 실사 요약 (PB `d_mat_inventory_barcode_check_sum_lst`).
   *
   * 품목별로 찍은 수량과 장부 수량을 합쳐 차이를 본다.
   */
  async findBarcodeCheckSummary(query: BarcodeCheckQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT c.CHECK_YYYYMM             AS "checkYyyymm",
              c.ITEM_CODE                AS "itemCode",
              i.ITEM_NAME                AS "itemName",
              i.ITEM_SPEC                AS "itemSpec",
              i.ITEM_UOM                 AS "itemUom",
              COUNT(*)                   AS "barcodeCount",
              SUM(NVL(c.BARCODE_QTY, 0))    AS "barcodeQty",
              SUM(NVL(c.INVENTORY_QTY, 0))  AS "inventoryQty",
              SUM(NVL(c.BARCODE_QTY, 0)) - SUM(NVL(c.INVENTORY_QTY, 0))
                                         AS "differenceQty",
              SUM(NVL(c.INVENTORY_AMT, 0))  AS "inventoryAmt"
         FROM IM_ITEM_INVENTORY_CHECK_BCD c
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = c.ITEM_CODE
               AND i.ORGANIZATION_ID = c.ORGANIZATION_ID
        WHERE c.CHECK_YYYYMM LIKE :yyyymm ESCAPE '\\'
          AND NVL(c.ITEM_CODE, '*') LIKE :itemCode ESCAPE '\\'
          AND c.ORGANIZATION_ID = :organizationId
        GROUP BY c.CHECK_YYYYMM, c.ITEM_CODE, i.ITEM_NAME, i.ITEM_SPEC, i.ITEM_UOM
        ORDER BY c.CHECK_YYYYMM DESC, c.ITEM_CODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        yyyymm: likePrefix(query.yyyymm),
        itemCode: likePrefix(query.itemCode),
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }
}
