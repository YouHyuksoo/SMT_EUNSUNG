/**
 * @file src/modules/warehouse/barcode-divide.service.ts
 * @description 240 자재분할관리 — PB `w_mat_receipt_barcode_divide_master` 이식 (**쓰기**)
 *
 * 초보자 가이드:
 * 1. **릴 하나를 여러 조각으로 쪼개는 화면이다.** 3,000개 릴을 1,200/800/1,000 으로
 *    나누면 릴이 세 개가 된다. 현장에서 많이 쓴다 — 분할된 바코드가 **369,463건**
 *    (2021-01-27 ~ 2026-09-28), 최근 1년 쌍이 84,353건, 작업자 11명 (실측).
 * 2. **원본 릴은 없어지지 않는다 — 마지막 조각이 된다.** 조각 N개 중 **앞 N-1개만**
 *    새 바코드가 되고, 원본 바코드의 수량이 마지막 조각 수량으로 바뀐다. 이 규칙을
 *    한 칸 틀리면 **재고가 한 조각만큼 늘어난다.** 그래서 계산을 `@smt/shared` 의
 *    `planLotDivide` 로 빼고 단위테스트 14건으로 못 박았다.
 * 3. **분할은 출고 원장에 쌍으로 남는다** (PB 그대로, 실측과 정확히 일치):
 *        조각마다  구분 3(+수량, MFS=원본롯트) 과 구분 4(−수량, MFS=새롯트) 한 쌍
 *        계정 `M016` · 라인 `'00'` · 공정 `'W00'` · 비고 `'LOT DIVIDE'`
 *    실측: 최근 1년 M016/W00 가 구분 3 **84,353건** / 구분 4 **84,354건** — 쌍이다.
 *    재고 자체가 움직이는 것이 아니라 **롯트가 갈라진 것**을 원장에 남기는 것이다.
 * 4. **새 롯트번호는 3글자 날짜코드 + 시퀀스 5자리다** (`69S00042`). 235·243 과
 *    앞부분 규칙은 같고 0 채움만 다르다 (PB `STRING(seq,'00000')`).
 * 5. **PB 가 검사하지 않던 것을 막았다.** 조각 수량 합이 릴 수량과 다르면 거절한다 —
 *    PB 는 그냥 넣어서 재고가 늘거나 줄었다 (235 에서 넣은 검사와 같은 성격).
 * 6. **옮기지 않은 것** (실측 근거):
 *      · 라벨 인쇄 DataWindow 5개 (`d_mat_receipt_lot_*_rpt`) — PB 런타임 인쇄다.
 *      · `d_mat_rceipt_barcode_4_slip_lst` 조회 — 235·243 에서 이미 다룬 목록이다.
 *      · 릴분할(`rb_reel`)과 롯트분할(`rb_lot`)의 차이는 **롯트번호 0 채움과
 *        분할사유 접미(`' REEL'`)뿐**이라 한 경로로 합치고 갈래를 인자로 받는다.
 * 7. **쓰기는 실행하지 않고 parse 로만 검증했다** (사용자 결정).
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import {
  buildDivideBarcode,
  buildDivideLotNo,
  checkLotDivide,
  likePrefix,
  planLotDivide,
} from '@smt/shared';
import { DataSource } from 'typeorm';
import { limited, ROW_LIMIT } from '../../shared/row-limit';
import { TransactionService } from '../../shared/transaction.service';
import { BarcodeDivideDto, BarcodeDivideQueryDto } from './warehouse.dto';

type Row = Record<string, unknown>;

/** 뽑을 수 있는 시퀀스. 이름을 SQL 에 문자열로 넣으면 주입 통로가 된다. */
const SEQUENCES = {
  /** 분할 묶음 번호. 한 번 나눌 때 조각들이 같은 값을 갖는다. */
  lotDivide: 'SEQ_LOT_DIVIDE_SEQUENCE',
  /** 새 롯트번호. 조각마다 하나씩 뽑는다. */
  materialBarcode: 'SEQ_MATERIAL_BARCODE',
} as const;

/** PB 가 분할 출고행에 고정으로 넣던 값. */
const FIXED = {
  issueAccount: 'M016',
  lineCode: '00',
  workstageCode: 'W00',
  comments: 'LOT DIVIDE',
  itemType: 'T',
  issueStatus: 'N',
  issueType: 'N',
  machineCode: '*',
  workOrderNo: '*',
  parentItemCode: '*',
  closeYn: 'N',
} as const;

@Injectable()
export class BarcodeDivideService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  // ───────────────────────────────── 조회

  /**
   * 분할 이력 (PB `d_mat_receipt_barcode_4_lot_divide_lst` ·
   * `d_mat_rceipt_barcode_4_reel_divide_lst` — 두 DataWindow 가 같은 표를 본다).
   *
   * 분할된 바코드만 본다 (`LOT_DIVIDE_YN='Y'`). 같은 `LOT_DIVIDE_SEQUENCE` 를 가진
   * 것끼리 한 번의 분할이다 — 화면이 그 값으로 묶어 보여준다.
   */
  async findDivided(query: BarcodeDivideQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT b.ITEM_BARCODE              AS "itemBarcode",
              b.ITEM_CODE                 AS "itemCode",
              i.ITEM_NAME                 AS "itemName",
              i.ITEM_SPEC                 AS "itemSpec",
              b.LOT_NO                    AS "lotNo",
              b.ORIGIN_LOT_NO             AS "originLotNo",
              b.ORIGIN_ITEM_BARCODE       AS "originItemBarcode",
              b.SCAN_QTY                  AS "scanQty",
              b.NEW_SCAN_QTY              AS "newScanQty",
              b.LOT_DIVIDE_SEQUENCE       AS "lotDivideSequence",
              TO_CHAR(b.LOT_DIVIDE_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "lotDivideDate",
              b.REAL_DIVIDE_REASON        AS "divideReason",
              b.RECEIPT_SLIP_NO           AS "receiptSlipNo",
              b.SUPPLIER_CODE             AS "supplierCode",
              b.INVENTORY_TYPE            AS "inventoryType",
              b.LABEL_TYPE                AS "labelType",
              NVL(b.ISSUE_COMPARE_YN, 'N')  AS "issueCompareYn",
              NVL(b.HOLDING_YN, 'N')        AS "holdingYn",
              b.LINE_CODE                 AS "lineCode",
              b.FEEDING_MODEL             AS "feedingModel",
              b.MSL_PASSED_TIME           AS "mslPassedTime",
              b.ENTER_BY                  AS "enterBy",
              TO_CHAR(b.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')      AS "enterDate"
         FROM IM_ITEM_RECEIPT_BARCODE b
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = b.ITEM_CODE
               AND i.ORGANIZATION_ID = b.ORGANIZATION_ID
        WHERE b.LOT_DIVIDE_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND b.LOT_DIVIDE_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND b.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND b.LOT_NO LIKE :lotNo ESCAPE '\\'
          AND NVL(b.ORIGIN_LOT_NO, '*') LIKE :originLotNo ESCAPE '\\'
          -- 분할된 것만 본다 (PB 고정조건).
          AND NVL(b.LOT_DIVIDE_YN, 'N') = 'Y'
          AND b.ORGANIZATION_ID = :organizationId
        ORDER BY b.LOT_DIVIDE_DATE DESC, b.LOT_DIVIDE_SEQUENCE, b.ITEM_BARCODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        itemCode: likePrefix(query.itemCode),
        lotNo: likePrefix(query.lotNo),
        originLotNo: likePrefix(query.originLotNo),
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /**
   * 나눌 릴을 풀어 본다 (읽기 전용).
   *
   * 지금 릴에 있는 수량은 `DECODE(NVL(NEW_SCAN_QTY,0), 0, SCAN_QTY, NEW_SCAN_QTY)` 다
   * (PB 와 같은 식) — 한 번 나눈 릴을 또 나눌 수 있기 때문이다.
   */
  async lookupBarcode(barcode: string, organizationId: number) {
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
        dividable: false, reason: '바코드에서 품목·롯트를 찾을 수 없습니다.',
      };
    }

    const rows = (await this.dataSource.query(
      `SELECT b.ITEM_BARCODE                  AS "itemBarcode",
              b.RECEIPT_SLIP_NO               AS "receiptSlipNo",
              NVL(b.SUPPLIER_CODE, '*')       AS "supplierCode",
              b.FROM_SUPPLIER_CODE            AS "fromSupplierCode",
              NVL(b.RECEIPT_COMPARE_YN, 'N')  AS "receiptCompareYn",
              TO_CHAR(b.RECEIPT_COMPARE_DATE, 'YYYY-MM-DD') AS "receiptCompareDate",
              NVL(b.ISSUE_COMPARE_YN, 'N')    AS "issueCompareYn",
              TO_CHAR(b.ISSUE_COMPARE_DATE, 'YYYY-MM-DD')   AS "issueCompareDate",
              NVL(b.HOLDING_YN, 'N')          AS "holdingYn",
              NVL(b.REEL_DESTROY_YN, 'N')     AS "reelDestroyYn",
              b.RECEIPT_TYPE                  AS "receiptType",
              b.LABEL_TYPE                    AS "labelType",
              b.INVENTORY_TYPE                AS "inventoryType",
              b.LOCATION_CODE                 AS "feederLocationCode",
              b.FEEDER_SHAFT                  AS "feederShaft",
              b.LINE_CODE                     AS "lineCode",
              b.FEEDING_MODEL                 AS "feedingModel",
              NVL(b.FEEDING_YN, 'N')          AS "feedingYn",
              b.ISSUE_DIVISION                AS "issueDivision",
              b.MANUFACTURE_WEEK              AS "manufactureWeek",
              TO_CHAR(b.MANUFACTURE_DATE, 'YYYY-MM-DD')     AS "manufactureDate",
              TO_CHAR(b.PCB_COATING_DATE, 'YYYY-MM-DD')     AS "pcbCoatingDate",
              b.VENDOR_LOTNO                  AS "vendorLotNo",
              b.VENDOR_CODE                   AS "vendorCode",
              b.SUPPLIER_BARCODE              AS "supplierBarcode",
              b.MSL_PASSED_TIME               AS "mslPassedTime",
              b.MSL_REMAIN_TIME               AS "mslRemainTime",
              -- 한 번 나눈 릴을 또 나눌 수 있으므로 새 수량이 있으면 그쪽이 실제다.
              DECODE(NVL(b.NEW_SCAN_QTY, 0), 0, b.SCAN_QTY, b.NEW_SCAN_QTY) AS "currentQty",
              b.SCAN_QTY                      AS "scanQty",
              b.NEW_SCAN_QTY                  AS "newScanQty",
              i.ITEM_NAME                     AS "itemName",
              i.ITEM_SPEC                     AS "itemSpec"
         FROM IM_ITEM_RECEIPT_BARCODE b
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = b.ITEM_CODE
               AND i.ORGANIZATION_ID = b.ORGANIZATION_ID
        WHERE b.ITEM_CODE = :itemCode
          AND b.LOT_NO = :lotNo
          AND b.ORGANIZATION_ID = :organizationId`,
      { itemCode, lotNo, organizationId } as unknown as unknown[],
    )) as Row[];
    const info = rows[0] ?? null;

    const reason = !info
      ? `바코드가 원장에 없습니다: ${itemCode}-${lotNo}`
      : String(info.reelDestroyYn) === 'Y'
        ? '폐기된 릴은 나눌 수 없습니다.'
        : String(info.holdingYn) === 'Y'
          ? '보류된 바코드는 나눌 수 없습니다.'
          : Number(info.currentQty ?? 0) <= 0
            ? '릴 수량이 0 이하입니다.'
            : null;

    return {
      barcode: (parsed.clean as string) ?? barcode,
      itemCode,
      lotNo,
      barcodeRow: info,
      dividable: reason === null,
      reason,
    };
  }

  // ───────────────────────────────── 분할 (쓰기)

  /**
   * 릴을 나눈다 (**쓰기**). PB 롯트분할·릴분할 두 갈래를 한 경로로 합쳤다.
   *
   *   ① 분할 묶음 번호를 뽑는다
   *   ② 앞 N-1 조각마다 새 롯트번호를 뽑아 바코드를 한 건씩 넣는다
   *   ③ 조각마다 출고 원장에 **쌍**을 넣는다 (구분 3 +수량 / 구분 4 −수량)
   *   ④ 원본 바코드를 마지막 조각 수량으로 고친다
   */
  async divideBarcode(dto: BarcodeDivideDto, organizationId: number, userId: string) {
    const lookup = await this.lookupBarcode(dto.barcode, organizationId);
    if (!lookup.dividable) {
      throw new BadRequestException(lookup.reason ?? '나눌 수 없는 바코드입니다.');
    }
    const info = lookup.barcodeRow as Row;
    const originQty = Number(info.currentQty ?? 0);

    // 규칙은 화면과 같은 공유 함수를 쓴다 — 보여준 조각과 실제로 들어가는 조각이 같다.
    const verdict = checkLotDivide(dto.divideQty, originQty);
    if (!verdict.ok) throw new BadRequestException(verdict.reason);
    const plan = planLotDivide(dto.divideQty, originQty);

    return this.tx.run(async (qr) => {
      // 롯트번호 접두어는 235·243 과 같은 3글자 날짜코드다 (PB `f_ymd_sysdate()`).
      const prefixRows = (await qr.query(
        `SELECT SUBSTR(TO_CHAR(SYSDATE, 'YYYY'), 4, 1)
                || F_GET_MONTH_CODE2(TO_CHAR(SYSDATE, 'MM'))
                || F_GET_DAY_CODE(TO_CHAR(SYSDATE, 'DD')) AS "datePrefix",
                ${SEQUENCES.lotDivide}.NEXTVAL             AS "divideSequence"
           FROM DUAL`,
      )) as Row[];
      const datePrefix = String(prefixRows[0]?.datePrefix ?? '');
      const divideSequence = Number(prefixRows[0]?.divideSequence ?? 0);
      if (!datePrefix) {
        throw new BadRequestException('롯트번호 날짜코드를 만들 수 없습니다.');
      }

      // 조각 수만큼 롯트 시퀀스를 한 번에 뽑는다 (PB 는 조각마다 왕복했다).
      const lotSeqs = ((await qr.query(
        `SELECT ${SEQUENCES.materialBarcode}.NEXTVAL AS "seq"
           FROM DUAL
        CONNECT BY LEVEL <= :count`,
        { count: plan.newPieces.length } as unknown as unknown[],
      )) as Row[]).map((r) => Number(r.seq));

      // PB 분할사유: 릴분할이면 ' REEL' 이 붙는다.
      const divideReason = `${dto.divideReason ?? '*'}${dto.reel ? ' REEL' : ''}`;

      const created: { lotNo: string; itemBarcode: string; qty: number }[] = [];
      let barcodeRows = 0;
      let issueRows = 0;

      for (let i = 0; i < plan.newPieces.length; i += 1) {
        const qty = plan.newPieces[i];
        const lotNo = buildDivideLotNo(datePrefix, lotSeqs[i]);
        const itemBarcode = buildDivideBarcode(lookup.itemCode as string, lotNo, qty);
        created.push({ lotNo, itemBarcode, qty });

        // ② 새 바코드 한 건. PB 는 DataWindow 로 넣었고 열 값은 원본에서 물려받는다.
        // 중복을 문장 안에서 막는다 (243 과 같은 이유 — 유일 인덱스가 복합이다).
        const inserted = await qr.query(
          `INSERT INTO IM_ITEM_RECEIPT_BARCODE
             (ITEM_BARCODE, ITEM_CODE, LOT_NO, ORIGIN_LOT_NO, ORIGIN_ITEM_BARCODE,
              SCAN_QTY, NEW_SCAN_QTY, SCAN_DATE,
              RECEIPT_SLIP_NO, SUPPLIER_CODE, FROM_SUPPLIER_CODE, SUPPLIER_BARCODE,
              RECEIPT_COMPARE_YN, RECEIPT_COMPARE_DATE,
              ISSUE_COMPARE_YN, ISSUE_COMPARE_DATE, ISSUE_COMPARE_BY,
              BARCODE_STATUS, RECEIPT_TYPE, LABEL_TYPE, INVENTORY_TYPE,
              LOT_DIVIDE_YN, LOT_DIVIDE_DATE, LOT_DIVIDE_SEQUENCE, REAL_DIVIDE_REASON,
              LINE_CODE, FEEDING_MODEL, FEEDING_YN, FEEDER_SHAFT, LOCATION_CODE,
              ISSUE_DIVISION, MANUFACTURE_WEEK, MANUFACTURE_DATE, PCB_COATING_DATE,
              VENDOR_LOTNO, VENDOR_CODE, MSL_PASSED_TIME, MSL_REMAIN_TIME,
              ORGANIZATION_ID, ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
           SELECT :itemBarcode, :itemCode, :lotNo, :originLotNo, :originItemBarcode,
                  :qty, :qty, TRUNC(SYSDATE),
                  :receiptSlipNo, :supplierCode, :fromSupplierCode, :supplierBarcode,
                  'Y', TO_DATE(:receiptCompareDate, 'YYYY-MM-DD'),
                  'N', TO_DATE(:issueCompareDate, 'YYYY-MM-DD'), :userId,
                  'N', :receiptType, :labelType, :inventoryType,
                  'Y', SYSDATE, :divideSequence, :divideReason,
                  :lineCode, :feedingModel, :feedingYn, :feederShaft, :feederLocationCode,
                  :issueDivision, :manufactureWeek,
                  TO_DATE(:manufactureDate, 'YYYY-MM-DD'),
                  TO_DATE(:pcbCoatingDate, 'YYYY-MM-DD'),
                  :vendorLotNo, :vendorCode, :mslPassedTime, :mslRemainTime,
                  :organizationId, SYSDATE, :userId, SYSDATE, :userId
             FROM DUAL
            WHERE NOT EXISTS (
                    SELECT 1
                      FROM IM_ITEM_RECEIPT_BARCODE x
                     WHERE x.ITEM_CODE = :itemCode
                       AND x.LOT_NO = :lotNo
                       AND x.ORGANIZATION_ID = :organizationId)`,
          {
            itemBarcode,
            itemCode: lookup.itemCode,
            lotNo,
            originLotNo: lookup.lotNo,
            originItemBarcode: (info.itemBarcode as string) ?? lookup.barcode,
            qty,
            receiptSlipNo: (info.receiptSlipNo as string) ?? null,
            supplierCode: (info.supplierCode as string) ?? null,
            fromSupplierCode: (info.fromSupplierCode as string) ?? null,
            supplierBarcode: (info.supplierBarcode as string) ?? null,
            receiptCompareDate: (info.receiptCompareDate as string) ?? null,
            issueCompareDate: (info.issueCompareDate as string) ?? null,
            userId,
            receiptType: (info.receiptType as string) ?? null,
            labelType: (info.labelType as string) ?? null,
            inventoryType: (info.inventoryType as string) ?? null,
            divideSequence,
            divideReason,
            lineCode: (info.lineCode as string) ?? null,
            feedingModel: (info.feedingModel as string) ?? null,
            feedingYn: (info.feedingYn as string) ?? 'N',
            feederShaft: (info.feederShaft as string) ?? null,
            feederLocationCode: (info.feederLocationCode as string) ?? null,
            issueDivision: (info.issueDivision as string) ?? null,
            manufactureWeek: (info.manufactureWeek as string) ?? null,
            manufactureDate: (info.manufactureDate as string) ?? null,
            pcbCoatingDate: (info.pcbCoatingDate as string) ?? null,
            vendorLotNo: (info.vendorLotNo as string) ?? null,
            vendorCode: (info.vendorCode as string) ?? null,
            mslPassedTime: info.mslPassedTime ?? null,
            mslRemainTime: info.mslRemainTime ?? null,
            organizationId,
          } as unknown as unknown[],
        );
        const affected = Number(
          (inserted as { rowsAffected?: number })?.rowsAffected ?? 0,
        );
        if (affected !== 1) {
          throw new BadRequestException(
            `롯트번호 ${lotNo} 가 이미 있습니다. 다시 나누세요.`,
          );
        }
        barcodeRows += affected;

        // ③ 출고 원장 쌍. 재고가 움직이는 것이 아니라 롯트가 갈라진 것을 남긴다.
        for (const side of [
          { deficit: 3, qty, mfs: lookup.lotNo, materialMfs: lookup.lotNo },
          { deficit: 4, qty: -qty, mfs: lotNo, materialMfs: lotNo },
        ]) {
          const issued = await qr.query(
            `INSERT INTO IM_ITEM_ISSUE
               (ITEM_CODE, ISSUE_DATE, ISSUE_SEQUENCE, ORGANIZATION_ID,
                MFS, LOCATION_CODE, ITEM_TYPE, LINE_CODE, WORKSTAGE_CODE,
                ISSUE_DEFICIT, ISSUE_QTY, ISSUE_STATUS, ISSUE_AMT, ISSUE_ACCOUNT,
                LINE_TYPE, COMMENTS, ISSUE_PRICE, ISSUE_TYPE,
                SUPPLIER_CODE, WORK_ORDER_NO,
                ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY,
                MACHINE_CODE, INVOICE_NO, PARENT_ITEM_CODE, MATERIAL_MFS,
                CLOSE_YN, ISSUE_DIVISION, FEEDER_LOCATION_CODE,
                RECEIPT_DATE, INVENTORY_TYPE)
             VALUES
               (:itemCode, TRUNC(SYSDATE), SEQ_MAT_ISSUE.NEXTVAL, :organizationId,
                :mfs, :locationCode, '${FIXED.itemType}', '${FIXED.lineCode}',
                '${FIXED.workstageCode}',
                :deficit, :qty, '${FIXED.issueStatus}', 0, '${FIXED.issueAccount}',
                F_GET_LINE_TYPE_FROM_ITEM(:itemCode, :organizationId),
                '${FIXED.comments}', 0, '${FIXED.issueType}',
                :supplierCode, '${FIXED.workOrderNo}',
                SYSDATE, :userId, SYSDATE, :userId,
                '${FIXED.machineCode}', :receiptSlipNo,
                '${FIXED.parentItemCode}', :materialMfs,
                '${FIXED.closeYn}', :divideSequence, :feederLocationCode,
                TO_DATE(:receiptCompareDate, 'YYYY-MM-DD'), :inventoryType)`,
            {
              itemCode: lookup.itemCode,
              organizationId,
              mfs: side.mfs,
              locationCode: dto.locationCode ?? null,
              deficit: side.deficit,
              qty: side.qty,
              supplierCode: (info.supplierCode as string) ?? null,
              userId,
              receiptSlipNo: (info.receiptSlipNo as string) ?? null,
              materialMfs: side.materialMfs,
              divideSequence,
              feederLocationCode: (info.feederLocationCode as string) ?? null,
              receiptCompareDate: (info.receiptCompareDate as string) ?? null,
              inventoryType: (info.inventoryType as string) ?? null,
            } as unknown as unknown[],
          );
          issueRows += Number((issued as { rowsAffected?: number })?.rowsAffected ?? 0);
        }
      }

      // ④ 원본 바코드는 마지막 조각이 된다 (파일 머리 2번).
      const originalBarcode = buildDivideBarcode(
        lookup.itemCode as string, lookup.lotNo as string, plan.originalPiece,
      );
      const updated = await qr.query(
        `UPDATE IM_ITEM_RECEIPT_BARCODE
            SET SCAN_QTY            = :originalPiece,
                NEW_SCAN_QTY        = :originalPiece,
                LOT_DIVIDE_YN       = 'Y',
                LOT_DIVIDE_DATE     = SYSDATE,
                LOT_DIVIDE_SEQUENCE = :divideSequence,
                ORIGIN_LOT_NO       = :lotNo,
                REAL_DIVIDE_REASON  = :divideReason,
                ITEM_BARCODE        = :originalBarcode,
                INVENTORY_TYPE      = NVL(:inventoryType, INVENTORY_TYPE),
                LAST_MODIFY_DATE    = SYSDATE,
                LAST_MODIFY_BY      = :userId
          WHERE ITEM_CODE = :itemCode
            AND LOT_NO = :lotNo
            AND ORGANIZATION_ID = :organizationId`,
        {
          originalPiece: plan.originalPiece,
          divideSequence,
          lotNo: lookup.lotNo,
          divideReason,
          originalBarcode,
          inventoryType: (info.inventoryType as string) ?? null,
          userId,
          itemCode: lookup.itemCode,
          organizationId,
        } as unknown as unknown[],
      );
      const originalRows = Number(
        (updated as { rowsAffected?: number })?.rowsAffected ?? 0,
      );
      if (originalRows !== 1) {
        // 원본을 못 고치면 조각만 늘어나 재고가 부풀어 오른다 — 통째로 되돌린다.
        throw new BadRequestException('원본 바코드를 고치지 못했습니다. 다시 시도하세요.');
      }

      return {
        barcode: lookup.barcode,
        itemCode: lookup.itemCode,
        lotNo: lookup.lotNo,
        originQty,
        divideSequence,
        datePrefix,
        pieceCount: plan.pieceCount,
        totalQty: plan.totalQty,
        /** 새로 만들어진 바코드들. 라벨을 새로 붙여야 한다. */
        created,
        /** 원본 바코드가 갖게 된 수량과 새 바코드 문자열. */
        originalPiece: plan.originalPiece,
        originalBarcode,
        barcodeRows,
        issueRows,
        originalRows,
      };
    });
  }
}
