/**
 * @file src/modules/warehouse/barcode-reprint.service.ts
 * @description 241 자재바코드재발행 — PB `w_mat_receipt_barcode_reprint_master` 이식 (**쓰기**)
 *
 * 초보자 가이드:
 * 1. **라벨이 찢어지거나 수량이 달라졌을 때 바코드를 다시 만드는 화면이다.**
 *    새 수량으로 `품목-롯트-수량` 바코드를 다시 만들고 라벨을 다시 뽑는다.
 * 2. **250 반품과 하는 일이 겹친다.** 둘 다 출고대조를 풀고 `ISSUE_RETURN_YN='Y'` 를
 *    세우고 바코드를 새 수량으로 다시 만든다. **다른 점은 원장이다** —
 *    250 은 출고 원장에 마이너스 출고와 로스를 남기지만, 이 화면은 **원장을 건드리지
 *    않는다.** 라벨만 다시 만드는 자리다. 수량이 실제로 줄어 재고에 반영해야 하면
 *    250 을 써야 한다.
 * 3. **PB 의 WHERE 에 품목코드가 빠져 있었다.** PB 는 `WHERE LOT_NO = :lot AND
 *    ORGANIZATION_ID = ...` 로만 걸어 같은 롯트번호를 쓰는 다른 품목까지 함께
 *    고쳐질 수 있었다. 지금 데이터에서는 롯트번호가 품목에 걸쳐 유일해서
 *    (실측 1,931,961 롯트 중 두 품목이 공유하는 것 **0건**) 사고가 없었지만,
 *    품목코드를 함께 걸어 구멍을 닫았다.
 * 4. **옮기지 않은 것** (실측 근거):
 *      · 라벨 인쇄 DataWindow 3개 — PB 런타임 인쇄다.
 *      · `dw_1.update()` 갈래 — 그쪽은 `RECEIPT_TYPE='R'`(재생) 을 세우는데
 *        실데이터에 `'R'` 이 **0건**이다 (N 1,931,958 · null 2 · T 1).
 *        한 번도 쓰이지 않은 경로다.
 * 5. **쓰기는 실행하지 않고 parse 로만 검증했다** (사용자 결정).
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { likePrefix } from '@smt/shared';
import { limited, ROW_LIMIT } from '../../shared/row-limit';
import { TransactionService } from '../../shared/transaction.service';
import { BarcodeReprintDto, BarcodeReprintQueryDto } from './warehouse.dto';
import { affectedRows } from '../../common/utils/affected-rows.util';

type Row = Record<string, unknown>;

@Injectable()
export class BarcodeReprintService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  /**
   * 재발행 대상 바코드 (PB `d_mat_rceipt_barcode_4_reprint_lst`).
   *
   * PB 조건을 그대로 둔다. 전표번호·협력사바코드·자재바코드는 `NVL(..., '*')` 로
   * 감싸는데, NULL 이 들어 있는 열이라 감싸지 않으면 그 행이 빠진다.
   */
  async findReprintable(query: BarcodeReprintQueryDto, organizationId: number) {
    // **키를 하나는 받아야 한다.** 조건 없이 훑으면 1,902,554행을 보느라 12.22초가
    // 걸리고 상한에서 잘린 임의의 10,000행이 나온다 (실측). PB 도 같은 모양이었지만
    // 라벨을 다시 뽑을 릴은 이미 정해져 있으므로 키가 없을 이유가 없다.
    const keys = [query.itemCode, query.barcode, query.lotNo, query.slipNo,
      query.supplierBarcode].filter((v) => (v ?? '').trim().length > 0);
    if (keys.length === 0) {
      throw new BadRequestException(
        '품목코드·바코드·롯트번호·전표번호 중 하나는 넣으세요.',
      );
    }
    const rows = (await this.dataSource.query(
      `SELECT b.ITEM_BARCODE              AS "itemBarcode",
              b.ITEM_CODE                 AS "itemCode",
              i.ITEM_NAME                 AS "itemName",
              i.ITEM_SPEC                 AS "itemSpec",
              b.LOT_NO                    AS "lotNo",
              b.SCAN_QTY                  AS "scanQty",
              b.NEW_SCAN_QTY              AS "newScanQty",
              b.LAST_SCAN_QTY             AS "lastScanQty",
              b.RECEIPT_SLIP_NO           AS "receiptSlipNo",
              b.SUPPLIER_CODE             AS "supplierCode",
              b.SUPPLIER_BARCODE          AS "supplierBarcode",
              NVL(b.RECEIPT_COMPARE_YN, 'N')  AS "receiptCompareYn",
              NVL(b.ISSUE_COMPARE_YN, 'N')    AS "issueCompareYn",
              NVL(b.ISSUE_RETURN_YN, 'N')     AS "issueReturnYn",
              NVL(b.HOLDING_YN, 'N')          AS "holdingYn",
              b.LABEL_TYPE                AS "labelType",
              b.RECEIPT_TYPE              AS "receiptType",
              b.INVENTORY_TYPE            AS "inventoryType",
              b.LINE_CODE                 AS "lineCode",
              b.MSL_PASSED_TIME           AS "mslPassedTime",
              TO_CHAR(b.SCAN_DATE, 'YYYY-MM-DD HH24:MI:SS')       AS "scanDate",
              TO_CHAR(b.ISSUE_RETURN_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "issueReturnDate",
              b.ENTER_BY                  AS "enterBy"
         FROM IM_ITEM_RECEIPT_BARCODE b
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = b.ITEM_CODE
               AND i.ORGANIZATION_ID = b.ORGANIZATION_ID
        WHERE b.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND NVL(b.RECEIPT_SLIP_NO, '*') LIKE :slipNo ESCAPE '\\'
          AND NVL(b.SUPPLIER_BARCODE, '*') LIKE :supplierBarcode ESCAPE '\\'
          AND NVL(b.ITEM_BARCODE, '*') LIKE :barcode ESCAPE '\\'
          AND b.LOT_NO LIKE :lotNo ESCAPE '\\'
          AND NVL(b.BARCODE_STATUS, '*') <> 'C'
          AND b.ORGANIZATION_ID = :organizationId
        ORDER BY b.SCAN_DATE DESC, b.ITEM_BARCODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        itemCode: likePrefix(query.itemCode),
        slipNo: likePrefix(query.slipNo),
        supplierBarcode: likePrefix(query.supplierBarcode),
        barcode: likePrefix(query.barcode),
        lotNo: likePrefix(query.lotNo),
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /**
   * 바코드를 새 수량으로 다시 만든다 (**쓰기**).
   *
   * **원장은 건드리지 않는다** (파일 머리 2번). 수량이 실제로 줄어 재고에 반영해야
   * 하면 250 출고바코드반품을 써야 한다.
   */
  async reprint(dto: BarcodeReprintDto, organizationId: number, userId: string) {
    const qty = Number(dto.newQty);
    if (!Number.isFinite(qty) || qty <= 0) {
      throw new BadRequestException('새 수량은 1 이상이어야 합니다.');
    }

    const parsed = ((await this.dataSource.query(
      `SELECT F_GET_PREPARE_BARCODE(:barcode)  AS "clean",
              F_GET_ITEM_CODE_FROM_BARCODE(
                F_GET_PREPARE_BARCODE(:barcode)) AS "itemCode",
              F_GET_LOT_NO_FROM_BARCODE(
                F_GET_PREPARE_BARCODE(:barcode)) AS "lotNo"
         FROM DUAL`,
      { barcode: dto.barcode } as unknown as unknown[],
    )) as Row[])[0] ?? {};
    const itemCode = (parsed.itemCode as string) || '';
    const lotNo = (parsed.lotNo as string) || '';
    if (!itemCode || !lotNo) {
      throw new BadRequestException(`바코드에서 품목·롯트를 찾을 수 없습니다: ${dto.barcode}`);
    }

    return this.tx.run(async (qr) => {
      const result = await qr.query(
        `UPDATE IM_ITEM_RECEIPT_BARCODE
            SET ISSUE_COMPARE_YN        = 'N',
                ISSUE_COMPARE_DATE      = NULL,
                ISSUE_COMPARE_BY        = NULL,
                SUPPLIER_BARCODE        = '*',
                ISSUE_RETURN_YN         = 'Y',
                ISSUE_RETURN_DATE       = SYSDATE,
                SCAN_QTY                = :newQty,
                LAST_SCAN_QTY           = SCAN_QTY,
                LAST_ISSUE_COMPARE_DATE = ISSUE_COMPARE_DATE,
                LAST_ISSUE_COMPARE_BY   = ISSUE_COMPARE_BY,
                ITEM_BARCODE            = :itemCode || '-' || :lotNo || '-' || :newQty,
                LAST_MODIFY_DATE        = SYSDATE,
                LAST_MODIFY_BY          = :userId
          WHERE LOT_NO = :lotNo
            -- PB 에는 품목코드 조건이 없었다 (파일 머리 3번). 함께 걸어 구멍을 닫았다.
            AND ITEM_CODE = :itemCode
            AND ORGANIZATION_ID = :organizationId
            AND NVL(BARCODE_STATUS, '*') <> 'C'`,
        {
          newQty: qty, itemCode, lotNo, userId, organizationId,
        } as unknown as unknown[],
      );
      const rows = Number(affectedRows(result) ?? 0);
      if (rows !== 1) {
        throw new BadRequestException(
          `다시 만들 바코드를 찾을 수 없습니다: ${itemCode}-${lotNo}`
          + ' (취소된 바코드일 수 있습니다).',
        );
      }
      return {
        itemCode,
        lotNo,
        newQty: qty,
        newBarcode: `${itemCode}-${lotNo}-${qty}`,
        rows,
      };
    });
  }
}
