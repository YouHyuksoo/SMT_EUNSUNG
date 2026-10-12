/**
 * @file src/modules/warehouse/barcode-issue.service.ts
 * @description 238 자재바코드출고관리 — PB `w_mat_other_issue_barcode_master` 이식 (**쓰기**)
 *
 * 초보자 가이드:
 * 1. **자재를 라인으로 내보내는(출고대조) 화면이다.** 릴 바코드를 찍으면 그 릴이
 *    "라인으로 나갔다"로 표시되고 출고 원장에 한 건이 들어간다. 자재창고에서 가장
 *    많이 쓰는 화면이다 — 최근 90일 81,322건, 작업자 9명 이상이 찍는다 (실측).
 * 2. **찍기 전에 검사가 열 몇 가지 지난다.** 순서가 뜻을 정한다 — 예를 들어 FIFO
 *    경고는 "이미 출고된 바코드" 거절 **뒤에** 와야 한다. 앞에 오면 이미 나간 릴에
 *    엉뚱하게 FIFO 경고가 떠서 현장이 원인을 못 찾는다. 그래서 검사 순서를
 *    `evaluateScan` 한 곳에 배열로 적어 두고 **화면과 서버가 같은 순서를 쓴다.**
 * 3. **검사는 크게 두 종류다.**
 *      항상 하는 것 — 품목 유효기간 · 보류 · 입고대조 여부 · 중복 출고 · 수량
 *      켜고 끄는 것 — FIFO · MSL 시간 · PCB 코팅 · 장기재고 · 수명주기
 *    PB 체크박스 기본값을 그대로 옮겼다 (FIFO·MSL·PCB 코팅이 기본 ON).
 * 4. **FIFO(선입선출) 검사가 이 화면의 핵심이다.** 지금 찍은 릴보다 먼저 들어온
 *    릴이 창고에 남아 있으면 거절한다. PB 는 세 갈래로 본다:
 *      · PCB 품목 — 제조주차가 더 이른 릴이 있으면 거절
 *      · MOQ(최소 포장수량)보다 적게 남은 릴을 찍었을 때 — 제조일이 더 이른
 *        잔량 릴이 있으면 거절
 *      · 그 밖 — 잔량 릴이 있거나 제조일이 더 이른 릴이 있으면 거절
 *    세 갈래 모두 **베이킹 중인 릴은 뺀다** (`BAKING_START_DATE` 는 있고
 *    `BAKING_END_DATE` 는 없는 것) — 꺼낼 수 없는 릴이라 순서를 막으면 안 된다.
 * 5. **옮기지 않은 것** (실측 근거):
 *      · **FIFO 강제통과 비밀번호** — `ISYS_CONFIG.FIFO_ISSUE_PASSWORD='0402'` 로
 *        평문 4자리를 넣으면 FIFO 거절을 뚫을 수 있었다. 원장 쓰기 게이트를 평문
 *        비밀번호로 여는 장치는 옮기지 않는다. FIFO 위반은 거절로 둔다 —
 *        강제 출고가 업무상 필요하면 권한으로 다뤄야 한다.
 *      · `rb_request` 자재요청 모드 — `IM_ITEM_REQUEST` 가 **7행**이고
 *        `dw_3.update()` 는 갱신 가능한 열이 없어 무동작이다.
 *      · `rb_issue_plan` 출고계획 모드 — `ID_ENG_BOM_TEMP`(3,360,611행)를 읽는데
 *        선두 인덱스가 `SESSION_ID` 인 **세션 임시표**다. 웹이 PB 세션의 행을 읽을
 *        방법이 없다.
 *      · `rb_smt_bom_report` — 인쇄용 DataWindow.
 *      · 반품 3모드(`rb_compare_return`·`rb_mass_return`·
 *        `rb_mass_reball_wait_return`) — 250 출고바코드반품에서 다뤘다.
 *      · 협력사 바코드 대조 — `ISYS_CONFIG` 에 `MATERIAL_ISSUE_COMPARE_YN` 이
 *        **없어서** PB 에서도 안 탄다 (237 의 `RECEIPT_VENDOR_INFO_CHECK` 와 같은 유형).
 *      · `dw_5.update()` · `dw_9` 피딩수량 — 앞은 갱신 대상이 없고, 뒤는
 *        피딩 계획이라 이 화면의 업무가 아니다.
 * 6. **PB 결함 하나는 경고로만 옮겼다.** 불량재고(창고 M02) 검사가 PB 에서
 *    `count(*)` 를 `lvi_count` 에 넣고 **`lvi_bad_count`** 를 보는데 그 변수는
 *    대입되는 곳이 없다 — 항상 0 이라 **한 번도 걸린 적이 없다.** 지금 거절로 켜면
 *    지금까지 나가던 것이 막히므로, 값을 함께 내되 **경고**로만 둔다.
 * 7. **DB 함수는 그대로 호출한다** — `F_GET_PREPARE_BARCODE` ·
 *    `F_GET_ITEM_CODE_FROM_BARCODE` · `F_GET_LOT_NO_FROM_BARCODE` ·
 *    `F_CHECK_PCB_COATING_DATE` · `F_GET_MAT_MSL_MAX_TIME` ·
 *    `F_GET_MSL_PASSED_TIME` 전부 PB 가 SQL 안에서 부르고 DB 에 VALID 로 있다.
 *    반대로 `f_check_item_inventory_hold_yn` · `f_check_item_barcode_hold_yn` ·
 *    `f_check_item_exists` 는 **PB 함수**라 본문 SQL 을 인라인했다.
 * 8. **쓰기는 실행하지 않고 parse 로만 검증했다** (사용자 결정).
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { likePrefix } from '@smt/shared';
import { limited, ROW_LIMIT } from '../../shared/row-limit';
import { TransactionService } from '../../shared/transaction.service';
import {
  BarcodeIssueDto,
  BarcodeIssueHistoryQueryDto,
  BarcodeIssueScanDto,
  BarcodeIssueWaitingQueryDto,
  KittingBomQueryDto,
} from './warehouse.dto';
import { affectedRows } from '../../common/utils/affected-rows.util';
import { namedBinds } from '../../common/utils/named-binds.util';

type Row = Record<string, unknown>;

/** PB 가 이 경로에서 고정으로 넣던 값. */
const FIXED = {
  /** 3 = 출고 (수량이 양수다) */
  issueDeficit: 3,
  issueStatus: 'N',
  issueType: 'N',
  issueAccount: 'M001',
  /** 'T' = 바코드 출고 (실측 이 경로 전부 T) */
  itemType: 'T',
  machineCode: '*',
  workOrderNo: '*',
  parentItemCode: '*',
  closeYn: 'N',
  /** 키팅 모드의 출고구분 (PB `LVS_ISSUE_DIVISION = 'K'`) */
  issueDivisionKitting: 'K',
} as const;

/** 한 건의 검사 결과. */
export interface ScanCheck {
  /** 검사 이름 (화면이 목록으로 보여준다) */
  key: string;
  label: string;
  /** 'pass' 통과 · 'reject' 거절 · 'warn' 경고(통과) · 'skip' 끔 */
  result: 'pass' | 'reject' | 'warn' | 'skip';
  detail?: string;
}

@Injectable()
export class BarcodeIssueService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  // ───────────────────────────────── 조회

  /**
   * 출고 이력 (PB `d_mat_issue_4_barcode_compare_view`).
   *
   * **이 목록은 편집할 수 없다** — PB DataWindow 에 갱신 대상 표가 없고, 편집 가능한
   * 열은 타이핑해도 버려진다 (실측).
   */
  async findIssues(query: BarcodeIssueHistoryQueryDto, organizationId: number) {
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
              s.ORIGIN_MFS                AS "supplierBarcode",
              s.LINE_CODE                 AS "lineCode",
              F_GET_LINE_NAME(s.LINE_CODE, 1)          AS "lineName",
              s.WORKSTAGE_CODE            AS "workstageCode",
              s.FEEDER_LOCATION_CODE      AS "feederLocationCode",
              s.ISSUE_DIVISION            AS "issueDivision",
              s.MODEL_NAME                AS "modelName",
              s.INVENTORY_TYPE            AS "inventoryType",
              s.MSL_PASSED_TIME           AS "mslPassedTime",
              s.LOCATION_CODE             AS "locationCode",
              s.MFS                       AS "mfs",
              s.INVOICE_NO                AS "receiptSlipNo",
              s.SUPPLIER_CODE             AS "supplierCode",
              s.LINE_TYPE                 AS "lineType",
              s.ISSUE_STATUS              AS "issueStatus",
              s.ENTER_BY                  AS "enterBy",
              TO_CHAR(s.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')        AS "enterDate"
         FROM IM_ITEM_ISSUE s
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = s.ITEM_CODE
               AND i.ORGANIZATION_ID = s.ORGANIZATION_ID
        WHERE s.ISSUE_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND s.ISSUE_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND s.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND NVL(s.MATERIAL_MFS, '*') LIKE :lotNo ESCAPE '\\'
          AND NVL(s.LINE_CODE, '*') LIKE :lineCode ESCAPE '\\'
          AND NVL(s.WORKSTAGE_CODE, '*') LIKE :workstageCode ESCAPE '\\'
          AND NVL(s.MODEL_NAME, '*') LIKE :modelName ESCAPE '\\'
          -- 출고만 본다 (반품은 250 화면이다).
          AND s.ISSUE_DEFICIT = '${FIXED.issueDeficit}'
          AND s.ORGANIZATION_ID = :organizationId
        ORDER BY s.ISSUE_DATE DESC, s.ISSUE_SEQUENCE DESC
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        itemCode: likePrefix(query.itemCode),
        lotNo: likePrefix(query.lotNo),
        lineCode: likePrefix(query.lineCode),
        workstageCode: likePrefix(query.workstageCode),
        modelName: likePrefix(query.modelName),
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }

  /**
   * 출고 대기 바코드 — 입고대조는 됐고 아직 라인으로 안 나간 릴.
   *
   * PB 고정조건을 유지한다: `RECEIPT_COMPARE_YN='Y'`(입고된 것) ·
   * `ISSUE_COMPARE_YN<>'Y'`(아직 안 나간 것) · `BARCODE_STATUS<>'C'`(취소 아님).
   */
  async findWaiting(query: BarcodeIssueWaitingQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT b.ITEM_BARCODE              AS "itemBarcode",
              b.ITEM_CODE                 AS "itemCode",
              i.ITEM_NAME                 AS "itemName",
              i.ITEM_SPEC                 AS "itemSpec",
              i.ITEM_CLASS                AS "itemClass",
              i.MSL_LEVEL                 AS "mslLevel",
              NVL(i.MATERIAL_QTY, 0)      AS "moqQty",
              b.LOT_NO                    AS "lotNo",
              DECODE(NVL(b.NEW_SCAN_QTY, 0), 0, b.SCAN_QTY, b.NEW_SCAN_QTY) AS "currentQty",
              b.SCAN_QTY                  AS "scanQty",
              b.RECEIPT_SLIP_NO           AS "receiptSlipNo",
              b.SUPPLIER_CODE             AS "supplierCode",
              b.INVENTORY_TYPE            AS "inventoryType",
              b.LABEL_TYPE                AS "labelType",
              b.MANUFACTURE_WEEK          AS "manufactureWeek",
              TO_CHAR(b.MANUFACTURE_DATE, 'YYYY-MM-DD')      AS "manufactureDate",
              TO_CHAR(b.RECEIPT_COMPARE_DATE, 'YYYY-MM-DD')  AS "receiptCompareDate",
              b.HOLDING_YN                AS "holdingYn",
              b.LINE_CODE                 AS "lineCode",
              b.WORKSTAGE_CODE            AS "workstageCode",
              -- 베이킹 중인 릴은 꺼낼 수 없다 (FIFO 판정에서도 뺀다).
              CASE WHEN b.BAKING_START_DATE IS NOT NULL
                    AND b.BAKING_END_DATE IS NULL
                   THEN 'Y' ELSE 'N' END  AS "bakingYn",
              TO_CHAR(b.SCAN_DATE, 'YYYY-MM-DD HH24:MI:SS')  AS "scanDate"
         FROM IM_ITEM_RECEIPT_BARCODE b
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = b.ITEM_CODE
               AND i.ORGANIZATION_ID = b.ORGANIZATION_ID
        WHERE b.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND b.ITEM_BARCODE LIKE :barcode ESCAPE '\\'
          AND b.LOT_NO LIKE :lotNo ESCAPE '\\'
          -- PB 고정조건
          AND NVL(b.RECEIPT_COMPARE_YN, 'N') = 'Y'
          AND NVL(b.ISSUE_COMPARE_YN, 'N') <> 'Y'
          AND NVL(b.BARCODE_STATUS, '*') <> 'C'
          AND NVL(b.LOT_DIVIDE_YN, 'N') = 'N'
          AND b.ORGANIZATION_ID = :organizationId
        ORDER BY b.SCAN_DATE, b.ITEM_BARCODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        itemCode: likePrefix(query.itemCode),
        barcode: likePrefix(query.barcode),
        lotNo: likePrefix(query.lotNo),
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }

  /**
   * 키팅 BOM (PB `d_des_smt_bom_4_item_kitting_lst2`).
   *
   * 모델에 들어가는 자재 목록이다. 대체품(`ID_ENG_BOM_SMT_REPLACE`)을 함께 낸다 —
   * 대체품으로 찍어도 통과해야 하기 때문이다.
   */
  async findKittingBom(query: KittingBomQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT b.MODEL_NAME                AS "modelName",
              b.PARENT_ITEM_CODE          AS "parentItemCode",
              b.CHILD_ITEM_CODE           AS "itemCode",
              i.ITEM_NAME                 AS "itemName",
              i.ITEM_SPEC                 AS "itemSpec",
              i.ITEM_CLASS                AS "itemClass",
              b.ITEM_UNIT_QTY             AS "bomQty",
              b.LINE_CODE                 AS "lineCode",
              b.WORKSTAGE_CODE            AS "workstageCode",
              -- 피더 위치는 LOCATION_CODE 다. LOCATION_INFO 에는 회로 기호가
              -- 함께 들어 있어(R2016,R2022 처럼) 화면이 같이 보여준다.
              b.LOCATION_CODE             AS "feederLocationCode",
              b.LOCATION_INFO             AS "locationInfo",
              b.FEEDER_SHAFT              AS "feederShaft",
              b.PCB_ITEM                  AS "pcbItem",
              b.MARKING_NO                AS "markingNo",
              b.VERSION                   AS "bomVersion",
              -- 대체품이 있으면 함께 본다 (대체품으로 찍어도 통과한다).
              ( SELECT LISTAGG(r.REPLACE_ITEM_CODE, ', ')
                         WITHIN GROUP (ORDER BY r.REPLACE_ITEM_CODE)
                  FROM ID_ENG_BOM_SMT_REPLACE r
                 WHERE r.PARENT_ITEM_CODE = b.PARENT_ITEM_CODE
                   AND r.CHILD_ITEM_CODE = b.CHILD_ITEM_CODE
                   AND r.ORGANIZATION_ID = b.ORGANIZATION_ID ) AS "replaceItems"
         FROM ID_ENG_BOM_SMT b
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = b.CHILD_ITEM_CODE
               AND i.ORGANIZATION_ID = b.ORGANIZATION_ID
        WHERE b.MODEL_NAME = :modelName
          AND NVL(b.LINE_CODE, '*') LIKE :lineCode ESCAPE '\\'
          -- BOM 에도 유효기간이 있다. 빼면 지나간 판번이 함께 나온다.
          AND b.DATESET <= TRUNC(SYSDATE)
          AND b.DATEEND >= TRUNC(SYSDATE)
          AND b.ORGANIZATION_ID = :organizationId
        ORDER BY b.WORKSTAGE_CODE, b.LOCATION_CODE, b.CHILD_ITEM_CODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        modelName: query.modelName,
        lineCode: likePrefix(query.lineCode),
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }

  /**
   * FIFO 위반 후보 — 지금 찍은 릴보다 먼저 써야 하는 릴 목록
   * (PB `d_mat_inventory_fifo_check_lst`, 거절 뒤에 띄우는 표).
   *
   * 거절 이유를 눈으로 확인할 수 있어야 하므로 **목록으로** 낸다. 조건은 FIFO
   * 판정과 같다 (파일 머리 4번).
   */
  async findFifoCandidates(
    itemCode: string,
    lotNo: string,
    inventoryType: string | null,
    organizationId: number,
  ) {
    const rows = (await this.dataSource.query(
      `SELECT b.ITEM_BARCODE              AS "itemBarcode",
              b.LOT_NO                    AS "lotNo",
              b.SCAN_QTY                  AS "scanQty",
              b.MANUFACTURE_WEEK          AS "manufactureWeek",
              TO_CHAR(b.MANUFACTURE_DATE, 'YYYY-MM-DD')      AS "manufactureDate",
              TO_CHAR(b.RECEIPT_COMPARE_DATE, 'YYYY-MM-DD')  AS "receiptCompareDate",
              b.INVENTORY_TYPE            AS "inventoryType",
              b.LABEL_TYPE                AS "labelType",
              v.INVENTORY_QTY             AS "inventoryQty",
              v.LOCATION_CODE             AS "locationCode"
         FROM IM_ITEM_RECEIPT_BARCODE b
         JOIN IM_ITEM_INVENTORY v
           ON v.ITEM_CODE = b.ITEM_CODE
          AND v.MATERIAL_MFS = b.LOT_NO
          AND v.LOCATION_CODE = 'M01'
          AND v.INVENTORY_QTY > 0
          AND v.ORGANIZATION_ID = b.ORGANIZATION_ID
        WHERE b.ITEM_CODE = :itemCode
          AND b.LOT_NO <> :lotNo
          AND NVL(b.RECEIPT_COMPARE_YN, 'N') = 'Y'
          AND NVL(b.ISSUE_COMPARE_YN, 'N') = 'N'
          AND NVL(b.REEL_DESTROY_YN, 'N') = 'N'
          AND NVL(b.LABEL_TYPE, 'N') = 'N'
          AND NVL(b.INVENTORY_TYPE, '*') = NVL(:inventoryType, '*')
          -- 베이킹 중인 릴은 꺼낼 수 없으니 순서를 막지 않는다 (PB 조건 그대로).
          AND NOT (b.BAKING_START_DATE IS NOT NULL AND b.BAKING_END_DATE IS NULL)
          AND b.ORGANIZATION_ID = :organizationId
        ORDER BY b.MANUFACTURE_DATE, b.MANUFACTURE_WEEK, b.LOT_NO
        FETCH FIRST 200 ROWS ONLY`,
      namedBinds({ itemCode, lotNo, inventoryType, organizationId }),
    )) as Row[];
    return limited(rows);
  }

  // ───────────────────────────────── 스캔 판정 (읽기)

  /**
   * 찍은 바코드가 출고 가능한지 **PB 와 같은 순서로** 본다 (읽기 전용).
   *
   * 화면은 이 결과로 버튼을 막고 거절 사유를 보여주고, 쓰기 경로는 **같은 함수를
   * 다시 불러** 판정한다. 그래서 화면이 보여준 사유와 서버가 내는 사유가 같다.
   */
  async evaluateScan(dto: BarcodeIssueScanDto, organizationId: number) {
    const checks: ScanCheck[] = [];
    const add = (
      key: string, label: string, result: ScanCheck['result'], detail?: string,
    ) => { checks.push({ key, label, result, detail }); };
    const firstReject = () => checks.find((c) => c.result === 'reject') ?? null;

    // ① 라인·공정은 PB 가 맨 앞에서 요구한다.
    /**
     * 켜고 끄는 검사의 기본값을 **여기서** 정한다.
     *
     * DTO 의 `@Transform` 에만 맡기면 컨트롤러를 거치지 않는 호출(다른 서비스가
     * 부르거나 시험 하네스)에서 `undefined` 가 그대로 넘어와 **안전한 기본값이
     * 꺼진다.** PB 체크박스 기본값(FIFO·MSL·PCB 코팅 ON)을 서비스가 보장한다.
     */
    const on = {
      fifo: dto.checkFifo ?? true,
      mslTime: dto.checkMslTime ?? true,
      pcbCoating: dto.checkPcbCoating ?? true,
      longTerm: dto.checkLongTermInventory ?? false,
      lifeCycle: dto.checkLifeCycle ?? false,
    };

    if (!dto.lineCode?.trim()) add('line', '라인', 'reject', '라인을 고르세요.');
    else add('line', '라인', 'pass', dto.lineCode);
    if (!dto.workstageCode?.trim()) {
      add('workstage', '공정', 'reject', '공정을 고르세요.');
    } else add('workstage', '공정', 'pass', dto.workstageCode);

    // ② 바코드를 정제하고 품목·롯트를 뽑는다. PB 와 같은 DB 함수를 쓴다.
    const parsed = ((await this.dataSource.query(
      `SELECT F_GET_PREPARE_BARCODE(:barcode)                 AS "clean",
              F_GET_ITEM_CODE_FROM_BARCODE(
                F_GET_PREPARE_BARCODE(:barcode))              AS "itemCode",
              F_GET_LOT_NO_FROM_BARCODE(
                F_GET_PREPARE_BARCODE(:barcode))              AS "lotNo"
         FROM DUAL`,
      namedBinds({ barcode: dto.barcode }),
    )) as Row[])[0] ?? {};
    const itemCode = (parsed.itemCode as string) || '';
    const lotNo = (parsed.lotNo as string) || '';
    if (!itemCode) add('itemCode', '품목 해석', 'reject', '바코드에서 품목을 찾을 수 없습니다.');
    else add('itemCode', '품목 해석', 'pass', itemCode);
    if (!lotNo) add('lotNo', '롯트 해석', 'reject', '바코드에서 롯트를 찾을 수 없습니다.');
    else add('lotNo', '롯트 해석', 'pass', lotNo);

    if (!itemCode || !lotNo) {
      return {
        barcode: (parsed.clean as string) ?? dto.barcode,
        itemCode: itemCode || null, lotNo: lotNo || null,
        item: null, barcodeRow: null, checks,
        issuable: false, reason: firstReject()?.detail ?? null,
      };
    }

    // ③ 한 번에 필요한 사실을 모은다 — 품목 기준정보 · 보류 · 바코드 원장 · 수명.
    const facts = ((await this.dataSource.query(
      `SELECT i.ITEM_NAME                 AS "itemName",
              i.ITEM_SPEC                 AS "itemSpec",
              i.ITEM_CLASS                AS "itemClass",
              i.MSL_LEVEL                 AS "mslLevel",
              NVL(i.MATERIAL_QTY, 0)      AS "moqQty",
              NVL(i.LIFE_CYCLE, 365)      AS "lifeCycle",
              NVL(i.ECO_CHECK_YN, 'N')    AS "ecoCheckYn",
              i.ECO_CHECK_COMMENTS        AS "ecoCheckComments",
              i.LINE_TYPE                 AS "lineType",
              i.SUPPLIER_CODE             AS "itemSupplierCode",
              -- PB f_check_item_exists 를 인라인한 것이다 (품목 유효기간).
              CASE WHEN i.DATESET <= TRUNC(SYSDATE)
                    AND i.DATEEND >= TRUNC(SYSDATE)
                   THEN 'Y' ELSE 'N' END  AS "itemValidYn",
              -- PB f_check_item_inventory_hold_yn('M01') 인라인: 'C' 면 보류다.
              ( SELECT CASE WHEN MAX(v.INVENTORY_HOLD) = 'C' THEN 'Y' ELSE 'N' END
                  FROM IM_ITEM_INVENTORY v
                 WHERE v.ITEM_CODE = i.ITEM_CODE
                   AND v.LOCATION_CODE = 'M01'
                   AND v.ORGANIZATION_ID = i.ORGANIZATION_ID ) AS "inventoryHoldYn",
              -- PB f_check_item_barcode_hold_yn 인라인: 'N' 이 아니면 보류다.
              ( SELECT CASE WHEN NVL(MAX(x.HOLDING_YN), 'N') = 'N' THEN 'N' ELSE 'Y' END
                  FROM IM_ITEM_RECEIPT_BARCODE x
                 WHERE x.ITEM_CODE = i.ITEM_CODE
                   AND x.LOT_NO = :lotNo
                   AND x.ORGANIZATION_ID = i.ORGANIZATION_ID ) AS "barcodeHoldYn",
              -- 불량 창고(M02)에 이 롯트가 남아 있나. PB 는 검사만 하고 쓰지 않는다
              -- (파일 머리 6번) — 경고로만 낸다.
              ( SELECT COUNT(*)
                  FROM IM_ITEM_INVENTORY v2
                 WHERE v2.MATERIAL_MFS = :lotNo
                   AND v2.INVENTORY_QTY > 0
                   AND v2.LOCATION_CODE = 'M02'
                   AND v2.ORGANIZATION_ID = i.ORGANIZATION_ID ) AS "badInventoryCount",
              -- 수명주기: 마지막 입고로부터 지난 날수
              ( SELECT TRUNC(SYSDATE - NVL(MAX(v3.LAST_RECEIPT_DATE), MAX(v3.ENTER_DATE)), 0)
                  FROM IM_ITEM_INVENTORY v3
                 WHERE v3.ITEM_CODE = i.ITEM_CODE
                   AND v3.MATERIAL_MFS = :lotNo
                   AND v3.ORGANIZATION_ID = i.ORGANIZATION_ID ) AS "lifeCyclePassed",
              -- 장기재고: 최근 12개월 안에 입고된 재고가 있나 (PB 와 같은 식)
              ( SELECT COUNT(*)
                  FROM IM_ITEM_INVENTORY v4
                 WHERE v4.LAST_RECEIPT_DATE > ADD_MONTHS(TRUNC(SYSDATE), -12)
                   AND v4.ITEM_CODE = i.ITEM_CODE
                   AND v4.MATERIAL_MFS = :lotNo
                   AND v4.ORGANIZATION_ID = i.ORGANIZATION_ID ) AS "recentInventoryCount"
         FROM ID_ITEM i
        WHERE i.ITEM_CODE = :itemCode
          AND i.ORGANIZATION_ID = :organizationId`,
      namedBinds({ itemCode, lotNo, organizationId }),
    )) as Row[])[0] ?? null;

    if (!facts) {
      add('item', '품목 기준정보', 'reject', `품목을 찾을 수 없습니다: ${itemCode}`);
      return {
        barcode: (parsed.clean as string) ?? dto.barcode, itemCode, lotNo,
        item: null, barcodeRow: null, checks,
        issuable: false, reason: firstReject()?.detail ?? null,
      };
    }

    const ledger = ((await this.dataSource.query(
      `SELECT b.RECEIPT_SLIP_NO                        AS "receiptSlipNo",
              NVL(b.SUPPLIER_CODE, '*')                AS "supplierCode",
              NVL(b.RECEIPT_COMPARE_YN, 'N')           AS "receiptCompareYn",
              NVL(b.ISSUE_COMPARE_YN, 'N')             AS "issueCompareYn",
              NVL(b.ISSUE_RETURN_YN, 'N')              AS "issueReturnYn",
              NVL(b.LABEL_TYPE, 'N')                   AS "labelType",
              b.INVENTORY_TYPE                         AS "inventoryType",
              b.MANUFACTURE_WEEK                       AS "manufactureWeek",
              TO_CHAR(b.MANUFACTURE_DATE, 'YYYY-MM-DD')     AS "manufactureDate",
              TO_CHAR(b.RECEIPT_COMPARE_DATE, 'YYYY-MM-DD') AS "receiptCompareDate",
              TO_CHAR(b.PCB_COATING_DATE, 'YYYY-MM-DD')     AS "pcbCoatingDate",
              b.ITEM_BARCODE                           AS "itemBarcode",
              DECODE(NVL(b.NEW_SCAN_QTY, 0), 0, b.SCAN_QTY, b.NEW_SCAN_QTY) AS "issueQty",
              b.SCAN_QTY                               AS "scanQty",
              CASE WHEN b.BAKING_START_DATE IS NOT NULL
                    AND b.BAKING_END_DATE IS NULL
                   THEN 'Y' ELSE 'N' END               AS "bakingYn",
              -- MSL 등급이 3 이상인 품목만 시간 검사를 한다 (PB msl_level > '2').
              F_GET_MSL_PASSED_TIME(b.ITEM_BARCODE)    AS "mslPassedTime",
              NVL(F_GET_MAT_MSL_MAX_TIME(b.ITEM_CODE), 0) AS "mslMaxTime",
              -- PCB 코팅일이 기간 안인가 (PB 와 같은 DB 함수).
              F_CHECK_PCB_COATING_DATE(b.ITEM_CODE, b.PCB_COATING_DATE, b.ORGANIZATION_ID)
                                                       AS "pcbCoatingOkYn"
         FROM IM_ITEM_RECEIPT_BARCODE b
        WHERE b.ITEM_CODE = :itemCode
          AND b.LOT_NO = :lotNo
          AND b.ORGANIZATION_ID = :organizationId`,
      namedBinds({ itemCode, lotNo, organizationId }),
    )) as Row[])[0] ?? null;

    // ④ 검사를 PB 순서대로 쌓는다.
    add('itemValid', '품목 유효기간',
      String(facts.itemValidYn) === 'Y' ? 'pass' : 'reject',
      String(facts.itemValidYn) === 'Y' ? undefined : '사용 기간이 지난 품목입니다.');

    if (String(facts.ecoCheckYn) === 'Y') {
      add('eco', '4M 변경', 'warn',
        (facts.ecoCheckComments as string) ?? '4M 변경 품목입니다.');
    } else add('eco', '4M 변경', 'pass');

    add('inventoryHold', '재고 보류',
      String(facts.inventoryHoldYn) === 'Y' ? 'reject' : 'pass',
      String(facts.inventoryHoldYn) === 'Y' ? '보류된 재고입니다.' : undefined);

    // PB 는 이 검사를 켜지 못한 상태다 (파일 머리 6번) — 경고로만 낸다.
    add('badInventory', '불량 재고',
      Number(facts.badInventoryCount ?? 0) > 0 ? 'warn' : 'pass',
      Number(facts.badInventoryCount ?? 0) > 0
        ? `불량 창고(M02)에 같은 롯트가 ${facts.badInventoryCount}건 있습니다.`
        : undefined);

    add('barcodeHold', '바코드 보류',
      String(facts.barcodeHoldYn) === 'Y' ? 'reject' : 'pass',
      String(facts.barcodeHoldYn) === 'Y' ? '보류된 바코드입니다.' : undefined);

    if (!ledger) {
      add('ledger', '바코드 원장', 'reject', `발행 이력이 없는 바코드입니다: ${itemCode}-${lotNo}`);
    } else {
      add('ledger', '바코드 원장', 'pass', ledger.itemBarcode as string);
      add('slip', '전표번호', ledger.receiptSlipNo ? 'pass' : 'reject',
        ledger.receiptSlipNo ? String(ledger.receiptSlipNo) : '전표번호가 없는 바코드입니다.');
      const qty = Number(ledger.issueQty ?? 0);
      add('qty', '수량', qty > 0 ? 'pass' : 'reject',
        qty > 0 ? qty.toLocaleString() : '수량이 0 이하입니다.');
      add('receiptCompare', '입고대조',
        String(ledger.receiptCompareYn) === 'Y' ? 'pass' : 'reject',
        String(ledger.receiptCompareYn) === 'Y'
          ? undefined
          : '입고대조가 안 된 바코드는 출고할 수 없습니다.');
      // 이 두 검사 **뒤에** FIFO 가 와야 한다 (파일 머리 2번).
      add('issueCompare', '중복 출고',
        String(ledger.issueCompareYn) === 'Y' ? 'reject' : 'pass',
        String(ledger.issueCompareYn) === 'Y' ? '이미 출고된 바코드입니다.' : undefined);
    }

    // ⑤ 켜고 끄는 검사들. 앞에서 이미 거절됐으면 더 보지 않는다 — PB 도 그 자리에서
    // 돌아가므로, 거절 뒤에 엉뚱한 사유가 붙으면 현장이 원인을 잘못 읽는다.
    const rejectedAlready = firstReject() !== null;
    const itemClass = String(facts.itemClass ?? '');

    // PCB 코팅
    if (!on.pcbCoating) add('pcbCoating', 'PCB 코팅', 'skip');
    else if (rejectedAlready || itemClass !== 'PCB') {
      add('pcbCoating', 'PCB 코팅', itemClass === 'PCB' ? 'skip' : 'pass',
        itemClass === 'PCB' ? undefined : 'PCB 품목이 아닙니다.');
    } else {
      const ok = String(ledger?.pcbCoatingOkYn ?? '') === 'Y';
      add('pcbCoating', 'PCB 코팅', ok ? 'pass' : 'reject',
        ok ? String(ledger?.pcbCoatingDate ?? '') : 'PCB 코팅일이 기간을 넘었습니다.');
    }

    // FIFO
    let fifoCount = 0;
    if (!on.fifo) add('fifo', 'FIFO 선입선출', 'skip');
    else if (rejectedAlready || !ledger) add('fifo', 'FIFO 선입선출', 'skip');
    else {
      fifoCount = await this.countFifoViolations(
        { itemCode, lotNo, itemClass, ledger, moqQty: Number(facts.moqQty ?? 0) },
        organizationId,
      );
      add('fifo', 'FIFO 선입선출', fifoCount > 0 ? 'reject' : 'pass',
        fifoCount > 0
          ? '먼저 써야 할 릴이 창고에 남아 있습니다. FIFO 목록을 확인하세요.'
          : undefined);
    }

    // 장기재고 (최근 12개월 입고가 없으면 거절 — PB 와 같다)
    if (!on.longTerm) add('longTerm', '장기재고', 'skip');
    else {
      const recent = Number(facts.recentInventoryCount ?? 0);
      add('longTerm', '장기재고', recent > 0 ? 'pass' : 'reject',
        recent > 0 ? undefined : '12개월이 넘은 재고입니다. 품질 확인을 받으세요.');
    }

    // MSL 시간 (등급 3 이상만)
    if (!on.mslTime) add('msl', 'MSL 시간', 'skip');
    else {
      const level = String(facts.mslLevel ?? '');
      if (!(level > '2')) add('msl', 'MSL 시간', 'pass', `MSL ${level || '없음'}`);
      else {
        const maxTime = Number(ledger?.mslMaxTime ?? 0);
        const passed = Number(ledger?.mslPassedTime ?? 0);
        add('msl', 'MSL 시간', maxTime >= passed ? 'pass' : 'reject',
          maxTime >= passed
            ? `남은 시간 ${Math.round(maxTime - passed)}`
            : 'MSL 허용 시간을 넘었습니다.');
      }
    }

    // 수명주기
    if (!on.lifeCycle) add('lifeCycle', '수명주기', 'skip');
    else {
      const limit = Number(facts.lifeCycle ?? 365);
      const passed = Number(facts.lifeCyclePassed ?? 0);
      add('lifeCycle', '수명주기', passed <= limit ? 'pass' : 'reject',
        passed <= limit
          ? `남은 일수 ${limit - passed}`
          : `수명주기(${limit}일)를 ${passed - limit}일 넘었습니다.`);
    }

    const reject = firstReject();
    return {
      barcode: (parsed.clean as string) ?? dto.barcode,
      itemCode,
      lotNo,
      item: facts,
      barcodeRow: ledger,
      checks,
      fifoCount,
      issuable: reject === null,
      reason: reject?.detail ?? null,
    };
  }

  /**
   * FIFO 위반 건수. PB 의 세 갈래를 그대로 옮겼다 (파일 머리 4번).
   *
   * 한 건이라도 있으면 거절이므로 `ROWNUM = 1` 로 끊는다 (PB 와 같다) — 1,902,554행
   * 표를 다 세지 않는다.
   */
  private async countFifoViolations(
    ctx: { itemCode: string; lotNo: string; itemClass: string; ledger: Row; moqQty: number },
    organizationId: number,
  ): Promise<number> {
    const { itemCode, lotNo, itemClass, ledger, moqQty } = ctx;
    const inventoryType = (ledger.inventoryType as string) ?? null;

    /** 세 갈래가 공유하는 조건. */
    const common = `AND NVL(b.RECEIPT_COMPARE_YN, 'N') = 'Y'
          AND NVL(b.ISSUE_COMPARE_YN, 'N') = 'N'
          AND NVL(b.LABEL_TYPE, 'N') = 'N'
          AND NVL(b.INVENTORY_TYPE, '*') = NVL(:inventoryType, '*')
          AND b.LOT_NO IN ( SELECT v.MATERIAL_MFS
                              FROM IM_ITEM_INVENTORY v
                             WHERE v.ITEM_CODE = :itemCode
                               AND v.LOCATION_CODE = 'M01'
                               AND v.INVENTORY_QTY > 0
                               AND v.ORGANIZATION_ID = :organizationId )
          -- 베이킹 중인 릴은 꺼낼 수 없으니 순서를 막지 않는다.
          AND NOT (b.BAKING_START_DATE IS NOT NULL AND b.BAKING_END_DATE IS NULL)
          AND b.ORGANIZATION_ID = :organizationId
          AND ROWNUM = 1`;

    const count = async (extra: string, binds: Record<string, unknown>) => {
      const rows = (await this.dataSource.query(
        `SELECT COUNT(*) AS "cnt"
           FROM IM_ITEM_RECEIPT_BARCODE b
          WHERE b.ITEM_CODE = :itemCode
            ${extra}
          ${common}`,
        namedBinds({ itemCode, inventoryType, organizationId, ...binds }),
      )) as Row[];
      return Number(rows[0]?.cnt ?? 0);
    };

    // 갈래 1 — PCB: 제조주차가 더 이른 릴이 남아 있으면 거절.
    if (itemClass === 'PCB') {
      return count(
        `AND b.LOT_NO <> :lotNo
          AND b.MANUFACTURE_WEEK < :manufactureWeek`,
        { lotNo, manufactureWeek: (ledger.manufactureWeek as string) ?? null },
      );
    }

    const scanQty = Number(ledger.scanQty ?? 0);
    const compareDate = (ledger.receiptCompareDate as string) ?? null;

    // 갈래 2 — MOQ 보다 적게 남은 릴을 찍었다: 제조일이 더 이른 잔량 릴이 있으면 거절.
    if (moqQty > scanQty && moqQty > 0) {
      return count(
        `AND b.LOT_NO <> :lotNo
          AND NVL(b.REEL_DESTROY_YN, 'N') = 'N'
          AND TRUNC(b.MANUFACTURE_DATE) < TRUNC(TO_DATE(:compareDate, 'YYYY-MM-DD'))
          AND b.SCAN_QTY < :moqQty`,
        { lotNo, compareDate, moqQty },
      );
    }

    // 갈래 3 — 그 밖: 먼저 잔량 릴을 보고, 없으면 제조일이 더 이른 릴을 본다.
    if (moqQty > 0) {
      const remnant = await count(
        `AND NVL(b.REEL_DESTROY_YN, 'N') = 'N'
          AND b.SCAN_QTY < :moqQty`,
        { moqQty },
      );
      if (remnant > 0) return remnant;
    }
    return count(
      `AND b.LOT_NO <> :lotNo
          AND NVL(b.REEL_DESTROY_YN, 'N') = 'N'
          AND TRUNC(b.MANUFACTURE_DATE) < TRUNC(TO_DATE(:compareDate, 'YYYY-MM-DD'))`,
      { lotNo, compareDate },
    );
  }

  // ───────────────────────────────── 출고대조 (쓰기)

  /**
   * 출고대조 + 출고 기록 (**쓰기**). PB `wf_issue_barcode('N')` 에 대응한다.
   *
   * 판정은 `evaluateScan` 을 **다시 불러서** 한다 — 화면을 우회할 수 있고, 미리 본
   * 시점과 실제 출고 시점 사이에 FIFO·MSL 상황이 바뀔 수 있다.
   */
  async issueBarcode(dto: BarcodeIssueDto, organizationId: number, userId: string) {
    const verdict = await this.evaluateScan(dto, organizationId);
    if (!verdict.issuable) {
      throw new BadRequestException(verdict.reason ?? '출고할 수 없는 바코드입니다.');
    }
    const ledger = verdict.barcodeRow as Row;
    const facts = verdict.item as Row;
    const issueQty = Number(ledger.issueQty ?? 0);

    return this.tx.run(async (qr) => {
      // **중복 출고를 문장 안에서 막는다** — 같은 릴을 두 사람이 동시에 찍어도
      // 한쪽만 1행을 바꾼다 (237·250 과 같은 관용구).
      const updated = await qr.query(
        `UPDATE IM_ITEM_RECEIPT_BARCODE
            SET ISSUE_COMPARE_YN   = 'Y',
                ISSUE_COMPARE_DATE = SYSDATE,
                ISSUE_COMPARE_BY   = :userId,
                ISSUE_RETURN_YN    = 'N',
                LINE_CODE          = :lineCode,
                FEEDING_MODEL      = :modelName,
                WORKSTAGE_CODE     = :workstageCode,
                LOCATION_CODE      = :feederLocationCode,
                FEEDING_YN         = 'N',
                FEEDING_DATE       = NULL,
                LAST_MODIFY_DATE   = SYSDATE,
                LAST_MODIFY_BY     = :userId
          WHERE LOT_NO = :lotNo
            AND ITEM_CODE = :itemCode
            AND ORGANIZATION_ID = :organizationId
            AND NVL(ISSUE_COMPARE_YN, 'N') <> 'Y'
            AND NVL(RECEIPT_COMPARE_YN, 'N') = 'Y'`,
        namedBinds({
          userId,
          lineCode: dto.lineCode.trim(),
          modelName: dto.modelName ?? null,
          workstageCode: dto.workstageCode.trim(),
          feederLocationCode: dto.feederLocationCode ?? null,
          lotNo: verdict.lotNo,
          itemCode: verdict.itemCode,
          organizationId,
        }),
      );
      const barcodeRows = Number(
        affectedRows(updated) ?? 0,
      );
      if (barcodeRows !== 1) {
        throw new BadRequestException(
          '출고 대상이 아닙니다 (이미 출고됐거나 입고대조가 안 된 바코드).',
        );
      }

      const inserted = await qr.query(
        `INSERT INTO IM_ITEM_ISSUE
           (ITEM_CODE, ISSUE_DATE, ISSUE_SEQUENCE, ORGANIZATION_ID,
            MFS, LOCATION_CODE, ITEM_TYPE, LINE_CODE, WORKSTAGE_CODE,
            ISSUE_DEFICIT, ISSUE_QTY, ISSUE_STATUS, ISSUE_AMT, ISSUE_ACCOUNT,
            LINE_TYPE, COMMENTS, ISSUE_PRICE, VIRTUAL_RECEIPT_YN, ISSUE_TYPE,
            SUPPLIER_CODE, WORK_ORDER_NO,
            ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY,
            MACHINE_CODE, INVOICE_NO, MADE_BY, PARENT_ITEM_CODE, MATERIAL_MFS,
            CLOSE_YN, BARCODE, ORIGIN_MFS, FEEDER_LOCATION_CODE,
            ISSUE_DIVISION, MODEL_NAME, INVENTORY_TYPE, MSL_PASSED_TIME)
         VALUES
           (:itemCode, TRUNC(SYSDATE), SEQ_MAT_ISSUE.NEXTVAL, :organizationId,
            NVL(:mfs, '*'), :locationCode, '${FIXED.itemType}', :lineCode,
            :workstageCode,
            ${FIXED.issueDeficit}, :issueQty, '${FIXED.issueStatus}', 0,
            '${FIXED.issueAccount}',
            :lineType, NULL, 0, NULL, '${FIXED.issueType}',
            :supplierCode, '${FIXED.workOrderNo}',
            SYSDATE, :userId, SYSDATE, :userId,
            '${FIXED.machineCode}', :receiptSlipNo, NULL,
            '${FIXED.parentItemCode}', :lotNo,
            '${FIXED.closeYn}', :barcode, :supplierBarcode, :feederLocationCode,
            :issueDivision, :modelName, :inventoryType,
            F_GET_MSL_PASSED_TIME(:barcode))`,
        namedBinds({
          itemCode: verdict.itemCode,
          organizationId,
          mfs: dto.mfs ?? null,
          locationCode: dto.locationCode ?? null,
          lineCode: dto.lineCode.trim(),
          workstageCode: dto.workstageCode.trim(),
          issueQty,
          lineType: (facts.lineType as string) ?? null,
          supplierCode: (ledger.supplierCode as string) ?? null,
          userId,
          receiptSlipNo: (ledger.receiptSlipNo as string) ?? null,
          lotNo: verdict.lotNo,
          barcode: verdict.barcode,
          supplierBarcode: dto.supplierBarcode ?? null,
          feederLocationCode: dto.feederLocationCode ?? null,
          // 키팅 모드면 'K' 다 (PB `LVS_ISSUE_DIVISION`).
          issueDivision: dto.kitting ? FIXED.issueDivisionKitting : (dto.issueDivision ?? null),
          modelName: dto.modelName ?? null,
          inventoryType: (ledger.inventoryType as string) ?? null,
        }),
      );

      return {
        barcode: verdict.barcode,
        itemCode: verdict.itemCode,
        lotNo: verdict.lotNo,
        issueQty,
        lineCode: dto.lineCode.trim(),
        workstageCode: dto.workstageCode.trim(),
        modelName: dto.modelName ?? null,
        issueDivision: dto.kitting ? FIXED.issueDivisionKitting : (dto.issueDivision ?? null),
        warnings: verdict.checks.filter((c) => c.result === 'warn'),
        barcodeRows,
        issueRows: Number(affectedRows(inserted) ?? 0),
      };
    });
  }
}
