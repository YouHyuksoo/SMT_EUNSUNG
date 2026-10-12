/**
 * @file packages/shared/src/warehouse/solder-label.ts
 * @description 솔더 라벨 바코드 규칙 — 프론트·백엔드가 함께 쓴다 (PB 243).
 *
 * 초보자 가이드:
 * 1. **솔더 바코드는 자재 바코드와 체계가 다르다.** 235/237 의 자재 바코드는
 *    `품목코드-롯트번호-수량` 인데, 솔더 라벨은 짧은 **11자 고정**이다:
 *
 *        S  260928  120  A
 *        │  │       │    └ 공장코드 (1자, 'A' 또는 'B')
 *        │  │       └ 그날의 일련번호 (3자, 001~999)
 *        │  └ 발행일 YYMMDD (6자)
 *        └ 솔더 종류 (1자)
 *
 *    실측으로 최근 1년 7,681장이 **전부 11자**이고 `S251001001B ~ S260916120A`
 *    범위다 (공장 A 4,800 · B 2,881).
 * 2. **종류 1자는 `ID_ITEM.SOLDER_TYPE` 에서 오고 F 는 S 로 바꾼다** (PB 그대로).
 *    무연(F)을 'S' 로 찍는다는 뜻이다. 'P'(유연)는 그대로 쓴다.
 * 3. **일련번호는 그날 이미 찍힌 바코드의 최대값에서 이어 붙인다** —
 *    `NVL(TO_NUMBER(SUBSTR(MAX(item_barcode), 8, 3)), 0)`. 시퀀스가 아니라
 *    **읽고 더하는 방식**이라 동시에 발행하면 같은 번호가 나온다. 그래서 서버는
 *    넣을 때 중복을 문장 안에서 막아야 한다 (`solder-label.service.ts` 참고).
 * 4. **999를 넘으면 발행할 수 없다.** 세 자리가 넘치면 `SUBSTR(…,8,3)` 이 다음 날
 *    번호를 잘못 읽어 바코드가 겹친다. PB 는 이 경우 화면에 글만 쓰고 **계속
 *    진행한다** (`return` 을 빠뜨렸다 — 실측 PB 1512행). 여기서는 거절한다.
 * 5. **롯트번호는 자재와 같은 방식이다** (`reel-plan.ts` 의 `buildReelLotNo`) —
 *    3글자 날짜코드 + `SEQ_MATERIAL_BARCODE`. 바코드와 롯트번호가 서로 다른
 *    체계라는 점이 이 화면에서 가장 헷갈리는 부분이다.
 */
/** 그날 찍을 수 있는 마지막 일련번호. 세 자리를 넘기면 바코드가 겹친다. */
export declare const SOLDER_DAY_MAX = 999;
/** 라벨을 찍을 수 있는 공장코드 (PB `ddlb_factory` 목록 그대로). */
export declare const SOLDER_FACTORIES: readonly ["A", "B"];
export type SolderFactory = (typeof SOLDER_FACTORIES)[number];
export interface SolderLabelInput {
    /** `ID_ITEM.SOLDER_TYPE` 원본값 ('F' 또는 'P'). */
    solderType?: string | null;
    /** 발행일 `YYMMDD`. */
    dateYymmdd: string;
    /** 그날 이미 찍힌 마지막 일련번호. 아직 없으면 0. */
    lastSequence: number;
    /** 찍을 장수. */
    count: number;
    /** 공장코드. */
    factory: string;
}
export interface SolderLabelVerdict {
    /**
     * 판별 유니온으로 두지 않는다 — 백엔드 tsconfig 가 `strictNullChecks: false` 라
     * 유니온 좁히기가 동작하지 않는다 (`reel-plan.ts` 와 같은 이유).
     */
    ok: boolean;
    reason?: string;
}
/**
 * 바코드 앞 1자. PB `IF lvs_solder_type = 'F' THEN lvs_solder_type = 'S'` 그대로다.
 *
 * 값이 없으면 빈 문자열을 돌려준다 — PB 는 그 경우 발행을 멈춘다.
 */
export declare function solderTypeCode(solderType?: string | null): string;
/** 발행할 수 있는지 본다. 화면은 이 결과로 버튼을 막고, 서버는 같은 함수로 다시 본다. */
export declare function checkSolderLabelPlan(input: SolderLabelInput): SolderLabelVerdict;
/** 라벨 한 장의 바코드. `종류(1) + YYMMDD(6) + 일련(3) + 공장(1)` = 11자. */
export declare function buildSolderBarcode(typeCode: string, dateYymmdd: string, sequence: number, factory: string): string;
/**
 * 찍을 바코드 목록을 만든다. 일련번호는 `lastSequence + 1` 부터 이어 붙인다
 * (PB `lvl_solder_day_seq + i`, i 는 1부터).
 *
 * @throws 발행할 수 없는 입력일 때
 */
export declare function planSolderBarcodes(input: SolderLabelInput): string[];
//# sourceMappingURL=solder-label.d.ts.map