/**
 * @file src/modules/warehouse/solder-label.service.ts
 * @description 243 솔더라벨 발행 — PB w_mat_receipt_slip_master_onetek_solder 이식 (**쓰기**)
 *
 * 초보자 가이드:
 * 1. **솔더 한 통에 붙일 라벨을 만드는 화면이다.** 전표(`IM_ITEM_RECEIPT_SLIP`)를
 *    새로 만들고, 그 전표에 딸린 라벨 장수만큼 바코드(`IM_ITEM_RECEIPT_BARCODE`)를
 *    넣는다. **입고 원장에는 넣지 않는다** — 입고는 그 라벨을 나중에 대조할 때 생긴다
 *    (237 화면). 235 와 다른 점이다.
 * 2. **바코드 체계가 235·237 과 다르다.** 자재 바코드는 `품목코드-롯트번호-수량`
 *    인데 솔더 라벨은 11자 고정이다:
 *        `종류(1) + YYMMDD(6) + 그날 일련번호(3) + 공장코드(1)` → 예 `S260928120A`
 *    실측 최근 1년 7,681장이 전부 11자다 (`S251001001B ~ S260916120A`).
 *    규칙은 `@smt/shared` 의 `solder-label.ts` 에 있고 단위테스트 17건으로 못 박혀
 *    있다 — 이 경로는 운영 원장에 쓰기 때문에 실행 검증을 할 수 없다.
 * 3. **롯트번호는 235 와 같은 방식이다** (3글자 날짜코드 + `SEQ_MATERIAL_BARCODE`).
 *    바코드와 롯트번호가 서로 다른 체계인 것이 이 화면에서 가장 헷갈리는 부분이다.
 * 4. **일련번호는 시퀀스가 아니라 "그날 최대값 + 1" 이다** (PB 그대로:
 *    `NVL(TO_NUMBER(SUBSTR(MAX(item_barcode), 8, 3)), 0)`). 읽고 더하는 방식이라
 *    동시에 두 사람이 발행하면 같은 번호가 나온다. `ITEM_BARCODE` 의 유일 인덱스는
 *    `(ITEM_BARCODE, SUPPLIER_BARCODE, ORGANIZATION_ID)` 복합이고 발행 시점의
 *    `SUPPLIER_BARCODE` 가 NULL 이라 **Oracle 이 유일성을 강제하지 않는다** (실측).
 *    그래서 INSERT 문 안에 `NOT EXISTS` 를 넣어 중복을 막고, 한 장이라도 0행이면
 *    트랜잭션 전체를 되돌린다 (237 의 조건부 UPDATE 와 같은 관용구다).
 * 5. **PB 가 검사만 하고 막지 않던 곳을 막았다.** PB 는 `일련 + 장수 > 999` 를 보고
 *    화면에 글만 쓰고 `return` 을 빠뜨려 그대로 진행한다 (실측 1512행). 세 자리가
 *    넘치면 `SUBSTR(…,8,3)` 이 다음 날 번호를 잘못 읽어 바코드가 겹친다 — 거절한다.
 * 6. **옮기지 않은 것** (실측 근거):
 *      · `wf_ok_slip_receipt` (전표번호를 받아 발행하는 갈래) — 그쪽은 공장코드를
 *        붙이지 않아 10자 바코드를 만든다. 최근 1년 데이터에 **10자가 한 장도 없다**
 *        (7,681장 전부 11자) → 현장에서 쓰이지 않는 갈래다.
 *      · `wf_receipt_barcode` (입고대조 스캔) — 237 과 같은 동작이다. 같은 표에 같은
 *        방식으로 쓰므로 237 `/warehouse/barcode-receipt/compare` 를 쓴다. 243 쪽은
 *        협력사 바코드를 `_s` 없는 함수로 풀고 일치 판정을 `POS(...) > 0`(부분일치)로
 *        하는 것만 다른데, 237 의 등호 비교가 더 엄격하다.
 *      · `d_mat_tb_vis_inout_issueno_hub` — `TB_VIS_INOUT_ISSUENO_HUB` 가 이 DB 에
 *        없고 PB 에서도 우클릭 하나만 살아 있다 (235 와 같은 판정).
 *      · `sle_proddate` (생산일 입력) — PB 가 값을 읽어 변수에 담기만 하고 어디에도
 *        쓰지 않는다 (실측 1504행).
 * 7. **쓰기는 실행하지 않고 parse 로만 검증했다** (사용자 결정).
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import {
  checkReelPlan,
  checkSolderLabelPlan,
  likePrefix,
  planReelQuantities,
  planSolderBarcodes,
  solderTypeCode,
  totalReelQty,
} from '@smt/shared';
import { limited, ROW_LIMIT } from '../../shared/row-limit';
import { TransactionService } from '../../shared/transaction.service';
import {
  SolderLabelIssueDto,
  SolderLabelSlipQueryDto,
  SolderLabelBarcodeQueryDto,
} from './warehouse.dto';

type Row = Record<string, unknown>;

/** 뽑을 수 있는 시퀀스 이름. 235 와 같은 이유로 화이트리스트로 제한한다. */
const SEQUENCES = {
  /** 전표 순번. 전표번호는 `YYMMDD` + 이 값이다. */
  receiptSlip: 'SEQ_RECEIPT_SLIP',
  /** 자재 롯트번호. 장마다 하나씩 뽑는다. */
  materialBarcode: 'SEQ_MATERIAL_BARCODE',
} as const;

/** PB 가 고정으로 넣던 값. */
const FIXED = {
  receiptType: 'N',
  receiptStatus: 'N',
  barcodeStatus: 'N',
  receiptCompareYn: 'N',
  holdingYn: 'N',
  lotDivideYn: 'N',
  returnYn: 'N',
  labelType: 'N',
} as const;

@Injectable()
export class SolderLabelService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  // ───────────────────────────────── 조회

  /**
   * 솔더 전표 목록 (PB `d_mat_receipt_slip_lst_solder`).
   *
   * **이 표는 편집할 수 없다.** PB 가 `dw_1.update()` 를 부르지만 18개 컬럼이
   * 전부 `tabsequence=32766`(편집 불가)이라 바뀔 값이 없다 — 발행 직후에 만든 행을
   * 저장하는 용도였다 (실측).
   */
  async findSlips(query: SolderLabelSlipQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT s.RECEIPT_SLIP_NO                        AS "receiptSlipNo",
              TO_CHAR(s.RECEIPT_DATE, 'YYYY-MM-DD')    AS "receiptDate",
              s.RECEIPT_SEQUENCE                       AS "receiptSequence",
              s.ITEM_CODE                              AS "itemCode",
              i.ITEM_NAME                              AS "itemName",
              i.ITEM_SPEC                              AS "itemSpec",
              i.SOLDER_TYPE                            AS "solderType",
              s.REEL_QTY                               AS "reelQty",
              s.RECEIPT_UNIT_QTY                       AS "receiptUnitQty",
              s.RECEIPT_SUM_QTY                        AS "receiptSumQty",
              s.RECEIPT_BARCODE                        AS "receiptBarcode",
              s.RECEIPT_TYPE                           AS "receiptType",
              s.RECEIPT_STATUS                         AS "receiptStatus",
              s.SUPPLIER_CODE                          AS "supplierCode",
              F_GET_SUPPLIER_NAME(s.SUPPLIER_CODE, s.ORGANIZATION_ID) AS "supplierName",
              s.FROM_SUPPLIER_CODE                     AS "fromSupplierCode",
              s.ECO_ITEM_YN                            AS "ecoItemYn",
              s.ENTER_BY                               AS "enterBy",
              TO_CHAR(s.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')          AS "enterDate"
         FROM IM_ITEM_RECEIPT_SLIP s
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = s.ITEM_CODE
               AND i.ORGANIZATION_ID = s.ORGANIZATION_ID
        WHERE s.RECEIPT_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND s.RECEIPT_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND s.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND s.RECEIPT_SLIP_NO LIKE :slipNo ESCAPE '\\'
          -- 솔더 화면이므로 솔더 품목만 본다. PB 는 화면 전용 품목 선택으로 걸렀다.
          AND i.ITEM_CLASS = 'SOLDER'
          AND s.ORGANIZATION_ID = :organizationId
        ORDER BY s.RECEIPT_DATE DESC, s.RECEIPT_SLIP_NO
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        itemCode: likePrefix(query.itemCode),
        slipNo: likePrefix(query.slipNo),
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /**
   * 고른 전표로 발행된 라벨 목록 (PB `d_mat_rceipt_barcode_4_slip_lst`).
   *
   * 라벨 인쇄는 이 목록을 그대로 쓴다 — PB 리포트 DataWindow 는 같은 자료를
   * 종이 모양으로 배치한 것뿐이라 별도 조회가 필요하지 않다.
   */
  async findSlipBarcodes(query: SolderLabelBarcodeQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT b.ITEM_BARCODE                           AS "itemBarcode",
              b.LOT_NO                                 AS "lotNo",
              b.ORIGIN_LOT_NO                          AS "originLotNo",
              b.SCAN_QTY                               AS "scanQty",
              TO_CHAR(b.SCAN_DATE, 'YYYY-MM-DD HH24:MI:SS')           AS "scanDate",
              TO_CHAR(b.VALID_DATE, 'YYYY-MM-DD')      AS "validDate",
              b.ITEM_CODE                              AS "itemCode",
              b.RECEIPT_SLIP_NO                        AS "receiptSlipNo",
              b.RECEIPT_TYPE                           AS "receiptType",
              b.BARCODE_STATUS                         AS "barcodeStatus",
              b.RECEIPT_COMPARE_YN                     AS "receiptCompareYn",
              b.HOLDING_YN                             AS "holdingYn",
              b.LABEL_TYPE                             AS "labelType",
              b.SUPPLIER_CODE                          AS "supplierCode",
              b.ENTER_BY                               AS "enterBy",
              TO_CHAR(b.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')          AS "enterDate"
         FROM IM_ITEM_RECEIPT_BARCODE b
        WHERE b.RECEIPT_SLIP_NO = :slipNo
          AND b.ITEM_CODE = :itemCode
          -- PB 고정조건: 취소된 라벨은 빼고 본다.
          AND NVL(b.BARCODE_STATUS, '*') <> 'C'
          AND b.ORGANIZATION_ID = :organizationId
        ORDER BY b.ITEM_BARCODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        slipNo: query.slipNo,
        itemCode: query.itemCode,
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /**
   * 발행 전에 화면이 알아야 하는 것 (읽기 전용).
   *
   * 품목의 솔더 종류와 **그날 이미 찍힌 마지막 일련번호**를 낸다. 화면은 이 값으로
   * 찍힐 바코드를 미리 보여준다 — 서버가 실제로 쓰는 것과 같은 공유 함수를 쓴다.
   *
   * 미리 보기와 실제 발행 사이에 다른 사람이 찍으면 번호가 달라진다. 그래서
   * 발행은 이 값을 **다시 읽어서** 계산한다 (여기 값을 믿지 않는다).
   */
  async findIssueContext(itemCode: string, factory: string, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT i.ITEM_CODE            AS "itemCode",
              i.ITEM_NAME            AS "itemName",
              i.ITEM_SPEC            AS "itemSpec",
              i.ITEM_CLASS           AS "itemClass",
              i.SOLDER_TYPE          AS "solderType",
              NVL(i.MATERIAL_QTY, 0) AS "materialQty"
         FROM ID_ITEM i
        WHERE i.ITEM_CODE = :itemCode
          AND i.ORGANIZATION_ID = :organizationId`,
      { itemCode, organizationId } as unknown as unknown[],
    )) as Row[];
    const item = rows[0] ?? null;
    const typeCode = solderTypeCode(item?.solderType as string);

    const seq = await this.readDaySequence(this.dataSource, typeCode, organizationId);
    return {
      item,
      solderTypeCode: typeCode,
      factory,
      ...seq,
    };
  }

  /**
   * 그날 이미 찍힌 마지막 일련번호와 오늘 날짜(YYMMDD).
   *
   * PB 와 **같은 문장**이다. `LIKE 종류||YYMMDD||'%'` 로 그날 것만 모아
   * `SUBSTR(MAX(item_barcode), 8, 3)` 을 숫자로 읽는다. 종류코드가 없으면
   * 발행할 수 없으니 0 으로 둔다.
   */
  private async readDaySequence(
    runner: { query: (sql: string, binds?: unknown[]) => Promise<unknown> },
    typeCode: string,
    organizationId: number,
  ): Promise<{ lastSequence: number; dateYymmdd: string }> {
    const rows = (await runner.query(
      `SELECT NVL(TO_NUMBER(SUBSTR(MAX(b.ITEM_BARCODE), 8, 3)), 0) AS "lastSequence",
              TO_CHAR(SYSDATE, 'YYMMDD')                           AS "dateYymmdd"
         FROM IM_ITEM_RECEIPT_BARCODE b
        WHERE b.ITEM_BARCODE LIKE :typeCode || TO_CHAR(SYSDATE, 'YYMMDD') || '%'
          AND b.ORGANIZATION_ID = :organizationId`,
      { typeCode: typeCode || '~none~', organizationId } as unknown as unknown[],
    )) as Row[];
    return {
      lastSequence: Number(rows[0]?.lastSequence ?? 0),
      dateYymmdd: String(rows[0]?.dateYymmdd ?? ''),
    };
  }

  /** 시퀀스에서 값을 n개 뽑는다 (235 와 같은 방식). */
  private async nextSequences(
    qr: { query: (sql: string, binds?: unknown[]) => Promise<unknown> },
    name: (typeof SEQUENCES)[keyof typeof SEQUENCES],
    count: number,
  ): Promise<number[]> {
    const rows = (await qr.query(
      `SELECT ${name}.NEXTVAL AS "seq"
         FROM DUAL
      CONNECT BY LEVEL <= :count`,
      { count } as unknown as unknown[],
    )) as Row[];
    return rows.map((r) => Number(r.seq));
  }

  // ───────────────────────────────── 발행 (쓰기)

  /**
   * 전표를 새로 만들고 솔더 라벨을 발행한다 (**쓰기**).
   *
   * PB `wf_no_slip_receipt` 에 대응한다. 흐름:
   *   1. 품목의 솔더 종류를 확인한다 (없으면 거절 — PB 도 멈춘다)
   *   2. 장수·수량 계획을 만든다 (규칙은 235 와 같은 `@smt/shared` 함수)
   *   3. 그날 마지막 일련번호를 읽고 999 상한을 본다
   *   4. 전표 한 건 + 라벨 장수만큼 바코드를 한 트랜잭션에 넣는다
   *
   * **입고 원장에는 넣지 않는다** — 입고는 237 대조 때 생긴다.
   */
  async issueLabels(dto: SolderLabelIssueDto, organizationId: number, userId: string) {
    // 장수·수량 규칙은 235 와 같다 (수동 목록이 있으면 그것, 없으면 릴 장수 × 단위수량).
    const planInput = {
      reelQty: dto.reelQty,
      unitQty: dto.unitQty,
      divideQty: dto.divideQty,
    };
    const planVerdict = checkReelPlan(planInput);
    if (!planVerdict.ok) throw new BadRequestException(planVerdict.reason);
    const quantities = planReelQuantities(planInput);
    const totalQty = totalReelQty(planInput);

    // PB 는 총수량을 사용자가 따로 적게 하고 맞는지 보지 않았다. 어긋나면 전표 총수량과
    // 라벨 수량 합이 달라지므로 거절한다 (235 에서 넣은 검사와 같은 성격이다).
    if (dto.totalQty !== undefined && Number(dto.totalQty) !== totalQty) {
      throw new BadRequestException(
        `라벨 수량 합(${totalQty.toLocaleString()})이 총수량`
        + `(${Number(dto.totalQty).toLocaleString()})과 다릅니다.`,
      );
    }

    return this.tx.run(async (qr) => {
      const items = (await qr.query(
        `SELECT i.SOLDER_TYPE AS "solderType",
                i.ITEM_CLASS  AS "itemClass"
           FROM ID_ITEM i
          WHERE i.ITEM_CODE = :itemCode
            AND i.ORGANIZATION_ID = :organizationId`,
        { itemCode: dto.itemCode, organizationId } as unknown as unknown[],
      )) as Row[];
      if (items.length === 0) {
        throw new BadRequestException(`품목을 찾을 수 없습니다: ${dto.itemCode}`);
      }
      const typeCode = solderTypeCode(items[0].solderType as string);

      // 미리 보기 때 읽은 값을 믿지 않고 **다시 읽는다** — 그 사이에 누가 찍었을 수 있다.
      const { lastSequence, dateYymmdd } =
        await this.readDaySequence(qr, typeCode, organizationId);

      const labelInput = {
        solderType: items[0].solderType as string,
        dateYymmdd,
        lastSequence,
        count: quantities.length,
        factory: dto.factory,
      };
      const labelVerdict = checkSolderLabelPlan(labelInput);
      if (!labelVerdict.ok) throw new BadRequestException(labelVerdict.reason);
      const barcodes = planSolderBarcodes(labelInput);

      // 전표번호는 `YYMMDD` + 전표 순번이다 (PB 그대로).
      const [slipSeq] = await this.nextSequences(qr, SEQUENCES.receiptSlip, 1);
      const slipNo = `${dateYymmdd}${slipSeq}`;

      const slipResult = await qr.query(
        `INSERT INTO IM_ITEM_RECEIPT_SLIP
           (RECEIPT_SLIP_NO, RECEIPT_DATE, RECEIPT_SEQUENCE, ITEM_CODE,
            REEL_QTY, RECEIPT_UNIT_QTY, RECEIPT_SUM_QTY, RECEIPT_BARCODE,
            RECEIPT_TYPE, RECEIPT_STATUS, SUPPLIER_CODE, FROM_SUPPLIER_CODE,
            ORGANIZATION_ID, ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
         VALUES
           (:slipNo, TRUNC(SYSDATE), :slipSequence, :itemCode,
            :reelCount, :unitQty, :totalQty, :supplierBarcode,
            '${FIXED.receiptType}', '${FIXED.receiptStatus}',
            :supplierCode, :supplierCode,
            :organizationId, SYSDATE, :userId, SYSDATE, :userId)`,
        {
          slipNo,
          slipSequence: slipSeq,
          itemCode: dto.itemCode,
          reelCount: quantities.length,
          unitQty: dto.unitQty ?? null,
          totalQty,
          supplierBarcode: dto.supplierBarcode ?? null,
          supplierCode: dto.supplierCode ?? null,
          organizationId,
          userId,
        } as unknown as unknown[],
      );

      const lotSeqs = await this.nextSequences(
        qr, SEQUENCES.materialBarcode, quantities.length,
      );
      // 롯트번호 접두어는 235 와 같은 3글자 날짜코드다 (PB `f_ymd_sysdate()`).
      const prefixRows = (await qr.query(
        `SELECT SUBSTR(TO_CHAR(SYSDATE, 'YYYY'), 4, 1)
                || F_GET_MONTH_CODE2(TO_CHAR(SYSDATE, 'MM'))
                || F_GET_DAY_CODE(TO_CHAR(SYSDATE, 'DD')) AS "datePrefix"
           FROM DUAL`,
      )) as Row[];
      const datePrefix = String(prefixRows[0]?.datePrefix ?? '');
      if (!datePrefix) {
        throw new BadRequestException('롯트번호 날짜코드를 만들 수 없습니다.');
      }

      let barcodeRows = 0;
      for (let i = 0; i < barcodes.length; i += 1) {
        const lotNo = `${datePrefix}${lotSeqs[i]}`;
        // **중복을 문장 안에서 막는다** (파일 머리 4번). 유일 인덱스가 복합이라
        // Oracle 이 막아 주지 않으므로 여기서 본다.
        const result = await qr.query(
          `INSERT INTO IM_ITEM_RECEIPT_BARCODE
             (ITEM_BARCODE, LOT_NO, ORIGIN_LOT_NO, SCAN_QTY, SCAN_DATE, VALID_DATE,
              ITEM_CODE, RECEIPT_SLIP_NO, RECEIPT_TYPE, SUPPLIER_CODE,
              BARCODE_STATUS, RECEIPT_COMPARE_YN, HOLDING_YN, LOT_DIVIDE_YN,
              RETURN_YN, LABEL_TYPE,
              ORGANIZATION_ID, ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
           SELECT :itemBarcode, :lotNo, :lotNo, :scanQty, SYSDATE,
                  TO_DATE(:validDate, 'YYYY-MM-DD'),
                  :itemCode, :slipNo, '${FIXED.receiptType}', :supplierCode,
                  '${FIXED.barcodeStatus}', '${FIXED.receiptCompareYn}',
                  '${FIXED.holdingYn}', '${FIXED.lotDivideYn}',
                  '${FIXED.returnYn}', '${FIXED.labelType}',
                  :organizationId, SYSDATE, :userId, SYSDATE, :userId
             FROM DUAL
            WHERE NOT EXISTS (
                    SELECT 1
                      FROM IM_ITEM_RECEIPT_BARCODE x
                     WHERE x.ITEM_BARCODE = :itemBarcode
                       AND x.ORGANIZATION_ID = :organizationId)`,
          {
            itemBarcode: barcodes[i],
            lotNo,
            scanQty: quantities[i],
            validDate: dto.validDate ?? null,
            itemCode: dto.itemCode,
            slipNo,
            supplierCode: dto.supplierCode ?? null,
            organizationId,
            userId,
          } as unknown as unknown[],
        );
        const affected = Number((result as { rowsAffected?: number })?.rowsAffected ?? 0);
        if (affected !== 1) {
          // 다른 사람이 같은 번호를 먼저 찍었다. 반쪽만 들어가면 라벨과 전표가
          // 어긋나므로 트랜잭션 전체를 되돌린다.
          throw new BadRequestException(
            `바코드 ${barcodes[i]} 가 이미 있습니다. 다시 발행하세요.`,
          );
        }
        barcodeRows += affected;
      }

      return {
        slipNo,
        itemCode: dto.itemCode,
        solderTypeCode: typeCode,
        factory: dto.factory,
        dateYymmdd,
        datePrefix,
        issued: barcodes.length,
        totalQty,
        slipRows: Number((slipResult as { rowsAffected?: number })?.rowsAffected ?? 0),
        barcodeRows,
        firstBarcode: barcodes[0] ?? null,
        lastBarcode: barcodes[barcodes.length - 1] ?? null,
      };
    });
  }
}
