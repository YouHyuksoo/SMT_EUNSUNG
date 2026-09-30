/**
 * @file src/modules/warehouse/issue-return.service.ts
 * @description 250 출고바코드반품(양산/벌크)관리 — PB
 *              `w_mat_other_mass_issue_barcode_return_master` 이식 (**쓰기**)
 *
 * 초보자 가이드:
 * 1. **라인에서 쓰다 남은 자재를 창고로 되돌리는 화면이다.** 릴에 붙은 바코드를 찍고
 *    남은 수량을 넣으면, 그 바코드가 다시 창고 재고가 되고 출고 원장에 **마이너스
 *    출고** 한 건이 들어간다.
 * 2. **반품하면 바코드의 수량이 바뀐다.** 1,000개짜리로 나간 릴에 300개가 남아
 *    돌아오면 그 바코드는 **300개짜리로 다시 쓰인다** — `SCAN_QTY` 를 고치고
 *    `ITEM_BARCODE` 를 `품목-롯트-수량` 으로 다시 만든다 (PB 그대로).
 *    원래 수량은 `LAST_SCAN_QTY` 에 남는다.
 * 3. **로스를 함께 기록한다.** 반품 수량과 실사 수량의 차이가 `IM_ITEM_ISSUE_LOSS`
 *    한 줄로 남는다 (실측 32,933건, 2026-09-28 까지 쌓이고 있다).
 * 4. **출고되지 않은 바코드는 반품할 수 없다** (PB 가드). `ISSUE_COMPARE_YN='N'`
 *    이면 아직 라인에 나간 적이 없다는 뜻이다.
 * 5. **라인코드는 그 롯트가 마지막으로 나간 라인에서 찾는다** (PB 그대로:
 *    `ISSUE_DEFICIT='3' AND ISSUE_ACCOUNT <> 'M009'` 중 가장 늦게 등록된 건).
 *    못 찾으면 화면에서 직접 넣는다.
 * 6. **옮긴 것은 '양산반품 정상' 모드 하나다** (실측 근거):
 *      · 반품된 바코드 6,474건 중 **`LABEL_TYPE` 이 'R'(리볼)·'B'(벌크) 인 것이 0건**
 *        이다 (null 6,467 · 'N' 7). `VENDOR_LOTNO` 에도 'REBALL'·'BULK' 가 없다.
 *        → 벌크·리볼대기·롬카피·외주반품 모드는 이 현장에서 쓰이지 않는다.
 *      · 이 경로가 만든 출고행(`ISSUE_ACCOUNT='M001'` · `ITEM_TYPE='T'` ·
 *        `WORKSTAGE_CODE='*'`)은 최근 1년 3,330건으로 **지금도 쓰인다.**
 *      · 불량반품(`cbx_bad_yn`)은 DataWindow 로 행을 넣는 다른 경로라 뺐다 —
 *        실데이터에서 정상반품과 갈라낼 표시를 찾지 못했다.
 * 7. **PB 의 죽은 변수 하나를 그대로 둔다.** `LVS_MODEL_NAME` 은 대입되는 곳이
 *    한 군데도 없어 빈 값이 들어간다 (237 의 `lvd_unit_price` 와 같은 유형).
 *    원장에 이미 그렇게 쌓여 있으므로 바꾸지 않는다.
 * 8. **쓰기는 실행하지 않고 parse 로만 검증했다** (사용자 결정).
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { likePrefix } from '@smt/shared';
import { limited, ROW_LIMIT } from '../../shared/row-limit';
import { TransactionService } from '../../shared/transaction.service';
import { IssueReturnLookupDto, IssueReturnDto, IssueReturnQueryDto } from './warehouse.dto';
import { affectedRows } from '../../common/utils/affected-rows.util';

type Row = Record<string, unknown>;

/** PB 가 이 경로에서 고정으로 넣던 값. */
const FIXED = {
  /** 4 = 반납 (수량이 음수다) */
  issueDeficit: 4,
  issueStatus: 'N',
  issueType: 'N',
  /** 반품 전용 출고계정 (실측 이 경로가 만든 3,330건이 전부 M001) */
  issueAccount: 'M001',
  /** 'T' = 반품 (실측 전부 T) */
  itemType: 'T',
  workstageCode: '*',
  machineCode: '*',
  mfs: '*',
  workOrderNo: '*',
  parentItemCode: '*',
  pcbItem: '*',
  closeYn: 'N',
} as const;

@Injectable()
export class IssueReturnService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  // ───────────────────────────────── 조회

  /**
   * 반품 이력 (PB `d_mat_issue_4_barcode_return_lst`).
   *
   * 이 경로가 만든 마이너스 출고만 본다 — `ISSUE_DEFICIT='4'` 이고 계정이 반품 계정이다.
   * 로스는 `findLosses` 로 따로 본다 (목록에 붙이면 느려진다 — 아래 주석 참고).
   */
  async findReturns(query: IssueReturnQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT TO_CHAR(s.ISSUE_DATE, 'YYYY-MM-DD')  AS "issueDate",
              s.ISSUE_SEQUENCE            AS "issueSequence",
              s.ITEM_CODE                 AS "itemCode",
              i.ITEM_NAME                 AS "itemName",
              i.ITEM_SPEC                 AS "itemSpec",
              i.ITEM_UOM                  AS "itemUom",
              s.ISSUE_QTY                 AS "issueQty",
              s.MATERIAL_MFS              AS "lotNo",
              s.BARCODE                   AS "barcode",
              s.LINE_CODE                 AS "lineCode",
              F_GET_LINE_NAME(s.LINE_CODE, 1)          AS "lineName",
              s.INVOICE_NO                AS "receiptSlipNo",
              s.SUPPLIER_CODE             AS "supplierCode",
              s.LOCATION_CODE             AS "locationCode",
              s.ISSUE_ACCOUNT             AS "issueAccount",
              s.ISSUE_DIVISION            AS "issueDivision",
              s.FEEDER_SHAFT              AS "feederShaft",
              s.INVENTORY_TYPE            AS "inventoryType",
              s.ENTER_BY                  AS "enterBy",
              TO_CHAR(s.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')        AS "enterDate",
              -- **로스 수량을 여기서 붙이지 않는다.** PB 에 없던 편의 열이었는데
              -- IM_ITEM_ISSUE_LOSS(32,933행)를 반품 한 줄마다 훑느라 4,085건 조회가
              -- **10.02초**가 됐다 (실측). 로스는 별도 조회로 본다.
              NULL                        AS "lossQty"
         FROM IM_ITEM_ISSUE s
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = s.ITEM_CODE
               AND i.ORGANIZATION_ID = s.ORGANIZATION_ID
        WHERE s.ISSUE_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND s.ISSUE_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND s.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND NVL(s.MATERIAL_MFS, '*') LIKE :lotNo ESCAPE '\\'
          AND NVL(s.LINE_CODE, '*') LIKE :lineCode ESCAPE '\\'
          -- 반품만 본다 (PB 고정조건).
          AND s.ISSUE_DEFICIT = '${FIXED.issueDeficit}'
          AND s.ISSUE_ACCOUNT = '${FIXED.issueAccount}'
          AND s.ORGANIZATION_ID = :organizationId
        ORDER BY s.ISSUE_DATE DESC, s.ISSUE_SEQUENCE DESC
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        itemCode: likePrefix(query.itemCode),
        lotNo: likePrefix(query.lotNo),
        lineCode: likePrefix(query.lineCode),
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /**
   * 찍은 바코드를 풀어 본다 (읽기 전용). PB 가 스캔 직후에 하던 조회다.
   *
   * 현재 수량은 `DECODE(NVL(NEW_SCAN_QTY,0), 0, SCAN_QTY, NEW_SCAN_QTY)` 다 —
   * 분할·조정으로 새 수량이 붙었으면 그쪽이 실제 수량이다 (PB 그대로).
   */
  async lookupBarcode(dto: IssueReturnLookupDto, organizationId: number) {
    const parsed = ((await this.dataSource.query(
      `SELECT F_GET_ITEM_CODE_FROM_BARCODE(:barcode)  AS "itemCode",
              F_GET_LOT_NO_FROM_BARCODE(:barcode)     AS "lotNo"
         FROM DUAL`,
      { barcode: dto.barcode } as unknown as unknown[],
    )) as Row[])[0] ?? {};
    const itemCode = (parsed.itemCode as string) || '';
    const lotNo = (parsed.lotNo as string) || '';
    if (!itemCode || !lotNo) {
      return { itemCode: itemCode || null, lotNo: lotNo || null, barcodeRow: null,
        lastIssueLineCode: null, returnable: false,
        reason: '바코드에서 품목·롯트를 찾을 수 없습니다.' };
    }

    const rows = (await this.dataSource.query(
      `SELECT b.RECEIPT_SLIP_NO                 AS "receiptSlipNo",
              NVL(b.SUPPLIER_CODE, '*')         AS "supplierCode",
              NVL(b.ISSUE_COMPARE_YN, 'N')      AS "issueCompareYn",
              NVL(b.ISSUE_RETURN_YN, 'N')       AS "issueReturnYn",
              NVL(b.WORKSTAGE_CODE, '*')        AS "workstageCode",
              NVL(b.LABEL_TYPE, 'N')            AS "labelType",
              NVL(b.FEEDER_SHAFT, '*')          AS "feederShaft",
              NVL(b.ISSUE_DIVISION, '*')        AS "issueDivision",
              NVL(b.LOCATION_CODE, '*')         AS "feederLocationCode",
              b.INVENTORY_TYPE                  AS "inventoryType",
              b.ITEM_BARCODE                    AS "itemBarcode",
              -- 지금 이 릴에 있는 수량 (PB 와 같은 식).
              DECODE(NVL(b.NEW_SCAN_QTY, 0), 0, b.SCAN_QTY, b.NEW_SCAN_QTY) AS "currentQty",
              b.SCAN_QTY                        AS "scanQty",
              b.NEW_SCAN_QTY                    AS "newScanQty",
              i.ITEM_NAME                       AS "itemName",
              i.ITEM_SPEC                       AS "itemSpec"
         FROM IM_ITEM_RECEIPT_BARCODE b
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = b.ITEM_CODE
               AND i.ORGANIZATION_ID = b.ORGANIZATION_ID
        WHERE b.ITEM_CODE = :itemCode
          AND b.LOT_NO = :lotNo
          AND b.ORGANIZATION_ID = :organizationId`,
      { itemCode, lotNo, organizationId } as unknown as unknown[],
    )) as Row[];
    const barcodeRow = rows[0] ?? null;

    // PB: 이 롯트가 마지막으로 나간 라인을 찾는다. 못 찾으면 화면에서 직접 넣는다.
    const lines = (await this.dataSource.query(
      `SELECT MAX(s.LINE_CODE) AS "lineCode"
         FROM IM_ITEM_ISSUE s
        WHERE s.ITEM_CODE = :itemCode
          AND s.MATERIAL_MFS = :lotNo
          AND s.ISSUE_DEFICIT = '3'
          AND s.ISSUE_ACCOUNT <> 'M009'
          AND s.ENTER_DATE = ( SELECT MAX(x.ENTER_DATE)
                                 FROM IM_ITEM_ISSUE x
                                WHERE x.ITEM_CODE = :itemCode
                                  AND x.MATERIAL_MFS = :lotNo
                                  AND x.ISSUE_DEFICIT = '3'
                                  AND x.ISSUE_ACCOUNT <> 'M009' )`,
      { itemCode, lotNo } as unknown as unknown[],
    )) as Row[];

    const reason = !barcodeRow
      ? `바코드가 원장에 없습니다: ${itemCode}-${lotNo}`
      : !barcodeRow.receiptSlipNo
        ? '전표번호가 없는 바코드입니다.'
        : String(barcodeRow.issueCompareYn) === 'N'
          ? '아직 라인으로 나가지 않은 바코드라 반품할 수 없습니다.'
          : null;

    return {
      itemCode,
      lotNo,
      barcodeRow,
      lastIssueLineCode: (lines[0]?.lineCode as string) ?? null,
      returnable: reason === null,
      reason,
    };
  }

  /**
   * 로스 목록 (`IM_ITEM_ISSUE_LOSS`).
   *
   * 반품할 때 반품 수량과 실사 수량의 차이가 한 줄씩 쌓인다 (실측 32,933건).
   * 반품 목록에 상관 서브쿼리로 붙였더니 **10초**가 걸려 따로 뗐다 — 표가 작아서
   * 기간으로 바로 읽으면 빠르다.
   */
  async findLosses(query: IssueReturnQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT TO_CHAR(l.ISSUE_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "issueDate",
              l.ISSUE_SEQUENCE            AS "issueSequence",
              l.ITEM_CODE                 AS "itemCode",
              i.ITEM_NAME                 AS "itemName",
              i.ITEM_SPEC                 AS "itemSpec",
              l.MATERIAL_MFS              AS "lotNo",
              l.MODEL_NAME                AS "modelName",
              l.LINE_CODE                 AS "lineCode",
              F_GET_LINE_NAME(l.LINE_CODE, 1)          AS "lineName",
              l.ISSUE_QTY                 AS "lossQty",
              l.ENTER_BY                  AS "enterBy",
              TO_CHAR(l.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')        AS "enterDate"
         FROM IM_ITEM_ISSUE_LOSS l
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = l.ITEM_CODE
               AND i.ORGANIZATION_ID = l.ORGANIZATION_ID
        WHERE l.ISSUE_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND l.ISSUE_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND l.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND NVL(l.MATERIAL_MFS, '*') LIKE :lotNo ESCAPE '\\'
          AND NVL(l.LINE_CODE, '*') LIKE :lineCode ESCAPE '\\'
          AND l.ORGANIZATION_ID = :organizationId
        ORDER BY l.ISSUE_DATE DESC
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        itemCode: likePrefix(query.itemCode),
        lotNo: likePrefix(query.lotNo),
        lineCode: likePrefix(query.lineCode),
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  // ───────────────────────────────── 반품 (쓰기)

  /**
   * 양산반품 (**쓰기**). PB 의 `RB_MASS_RETURN` + 불량 아님 경로다.
   *
   *   ① 바코드 원장을 되돌린다 (출고대조 해제 · 반품표시 · 수량·바코드 재생성)
   *   ② 출고 원장에 **마이너스 출고**를 한 건 넣는다
   *   ③ 반품 수량과 실사 수량의 차이를 로스로 한 줄 남긴다
   */
  async returnBarcode(dto: IssueReturnDto, organizationId: number, userId: string) {
    const returnQty = Number(dto.returnQty);
    if (!Number.isFinite(returnQty) || returnQty <= 0) {
      throw new BadRequestException('반품 수량은 1 이상이어야 합니다.');
    }
    const actualQty = Number(dto.actualQty ?? returnQty);
    if (!Number.isFinite(actualQty) || actualQty < 0) {
      throw new BadRequestException('실사 수량은 0 이상이어야 합니다.');
    }
    if (!dto.lineCode?.trim()) {
      throw new BadRequestException('라인코드가 필요합니다.');
    }

    const lookup = await this.lookupBarcode({ barcode: dto.barcode }, organizationId);
    if (!lookup.returnable) {
      throw new BadRequestException(lookup.reason ?? '반품할 수 없는 바코드입니다.');
    }
    const info = lookup.barcodeRow as Row;

    return this.tx.run(async (qr) => {
      // ① 바코드 원장을 되돌린다. **아직 반품되지 않은 것만** 바꾼다 —
      // 두 사람이 같은 릴을 동시에 찍어도 한쪽만 1행을 바꾼다 (237 과 같은 관용구).
      const updated = await qr.query(
        `UPDATE IM_ITEM_RECEIPT_BARCODE
            SET ISSUE_COMPARE_YN        = 'N',
                ISSUE_COMPARE_DATE      = NULL,
                ISSUE_COMPARE_BY        = NULL,
                SUPPLIER_BARCODE        = '*',
                ISSUE_RETURN_YN         = 'Y',
                ISSUE_RETURN_DATE       = SYSDATE,
                SCAN_QTY                = :returnQty,
                LAST_SCAN_QTY           = SCAN_QTY,
                LAST_ISSUE_COMPARE_DATE = ISSUE_COMPARE_DATE,
                LAST_ISSUE_COMPARE_BY   = ISSUE_COMPARE_BY,
                -- 남은 수량으로 바코드를 다시 만든다 (PB 문자열 연결 그대로).
                ITEM_BARCODE            = :itemCode || '-' || :lotNo || '-' || :returnQty,
                FEEDING_YN              = 'N',
                NEW_SCAN_QTY            = 0,
                FEEDER_SHAFT            = '',
                ISSUE_DIVISION          = '',
                LOCATION_CODE           = '',
                FEEDING_GROUP_NO        = '',
                LAST_MODIFY_BY          = :userId,
                LAST_MODIFY_DATE        = SYSDATE
          WHERE ITEM_CODE = :itemCode
            AND LOT_NO = :lotNo
            AND ORGANIZATION_ID = :organizationId
            AND NVL(ISSUE_COMPARE_YN, 'N') = 'Y'`,
        {
          returnQty,
          itemCode: lookup.itemCode,
          lotNo: lookup.lotNo,
          userId,
          organizationId,
        } as unknown as unknown[],
      );
      const barcodeRows = Number(
        affectedRows(updated) ?? 0,
      );
      if (barcodeRows !== 1) {
        throw new BadRequestException(
          '반품 대상이 아닙니다 (이미 반품됐거나 출고되지 않은 바코드).',
        );
      }

      // ② 마이너스 출고. 열 목록과 고정값은 PB 그대로다.
      const issued = await qr.query(
        `INSERT INTO IM_ITEM_ISSUE
           (ITEM_CODE, ISSUE_DATE, ISSUE_SEQUENCE, ORGANIZATION_ID,
            MFS, LOCATION_CODE, ITEM_TYPE, LINE_CODE, WORKSTAGE_CODE,
            ISSUE_DEFICIT, ISSUE_QTY, ISSUE_STATUS, ISSUE_AMT, ISSUE_ACCOUNT,
            LINE_TYPE, COMMENTS, ISSUE_PRICE, VIRTUAL_RECEIPT_YN, ISSUE_TYPE,
            SUPPLIER_CODE, WORK_ORDER_NO,
            ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY,
            MACHINE_CODE, INVOICE_NO, MADE_BY, PARENT_ITEM_CODE, MATERIAL_MFS,
            CLOSE_YN, BARCODE, FEEDER_SHAFT, ISSUE_DIVISION,
            FEEDER_LOCATION_CODE, MODEL_NAME, PCB_ITEM, INVENTORY_TYPE)
         VALUES
           (:itemCode, TRUNC(SYSDATE), SEQ_MAT_ISSUE.NEXTVAL, :organizationId,
            '${FIXED.mfs}', :locationCode, '${FIXED.itemType}', :lineCode,
            '${FIXED.workstageCode}',
            ${FIXED.issueDeficit}, :returnQty * -1, '${FIXED.issueStatus}', 0,
            '${FIXED.issueAccount}',
            F_GET_LINE_TYPE_FROM_ITEM(:itemCode, :organizationId),
            NULL, 0, NULL, '${FIXED.issueType}',
            F_GET_MAX_SUPPLIER_BY_ITEM(:itemCode, :organizationId),
            '${FIXED.workOrderNo}',
            SYSDATE, :userId, SYSDATE, :userId,
            '${FIXED.machineCode}', :receiptSlipNo, NULL,
            '${FIXED.parentItemCode}', :lotNo,
            '${FIXED.closeYn}', :barcode, :feederShaft, :issueDivision,
            -- PB LVS_MODEL_NAME 은 대입되는 곳이 없어 빈 값이 들어간다 (파일 머리 7번).
            :feederLocationCode, NULL, '${FIXED.pcbItem}', :inventoryType)`,
        {
          itemCode: lookup.itemCode,
          organizationId,
          locationCode: dto.locationCode ?? null,
          lineCode: dto.lineCode.trim(),
          returnQty,
          userId,
          receiptSlipNo: (info.receiptSlipNo as string) ?? null,
          lotNo: lookup.lotNo,
          barcode: dto.barcode,
          feederShaft: (info.feederShaft as string) ?? null,
          issueDivision: (info.issueDivision as string) ?? null,
          feederLocationCode: (info.feederLocationCode as string) ?? null,
          inventoryType: (info.inventoryType as string) ?? null,
        } as unknown as unknown[],
      );

      // ③ 로스 (반품 수량 − 실사 수량). PB 와 같은 식이다.
      const loss = await qr.query(
        `INSERT INTO IM_ITEM_ISSUE_LOSS
           (ISSUE_DATE, ISSUE_SEQUENCE, ITEM_CODE, MATERIAL_MFS,
            MODEL_NAME, LINE_CODE, ISSUE_QTY,
            ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY, ORGANIZATION_ID)
         VALUES
           (SYSDATE, SEQ_MAT_ISSUE.NEXTVAL, :itemCode, :lotNo,
            NULL, :lineCode, :lossQty,
            SYSDATE, :userId, SYSDATE, :userId, :organizationId)`,
        {
          itemCode: lookup.itemCode,
          lotNo: lookup.lotNo,
          lineCode: dto.lineCode.trim(),
          lossQty: returnQty - actualQty,
          userId,
          organizationId,
        } as unknown as unknown[],
      );

      return {
        barcode: dto.barcode,
        itemCode: lookup.itemCode,
        lotNo: lookup.lotNo,
        returnQty,
        actualQty,
        lossQty: returnQty - actualQty,
        /** 반품 뒤 이 릴에 붙는 새 바코드 */
        newBarcode: `${lookup.itemCode}-${lookup.lotNo}-${returnQty}`,
        previousQty: Number(info.currentQty ?? 0),
        lineCode: dto.lineCode.trim(),
        barcodeRows,
        issueRows: Number(affectedRows(issued) ?? 0),
        lossRows: Number(affectedRows(loss) ?? 0),
      };
    });
  }
}
