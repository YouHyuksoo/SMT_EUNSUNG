/**
 * @file packages/shared/src/tracking/required-filter.ts
 * @description 추적 조회의 필수조건 규칙. 프론트(조회 버튼 차단)와 백엔드(요청 거부)가
 *              같은 판정을 쓴다.
 *
 * 왜 한 곳에 두는가:
 * 추적 화면이 읽는 표는 실측으로 이만큼 크다 (2026-09 기준).
 *
 *     IP_PRODUCT_2D_BARCODE        180,403,900
 *     IQ_MACHINE_INSPECT_DATA_AOI  175,188,481
 *     IQ_MACHINE_INSPECT_AOI       116,341,116
 *     IQ_MACHINE_INSPECT_DATA_SPI  108,312,766
 *     IQ_MACHINE_INSPECT_DATA_MK   106,459,417
 *     IQ_MACHINE_INSPECT_SPI       100,515,098
 *
 * 조건 없이 열면 화면이 아니라 DB 가 멈춘다. PB 는 `값 + '%'` 관례로 빈 입력을
 * `'%'` 로 보냈으므로 **조건 없는 전체 조회가 실제로 가능했다.** 그것을 그대로
 * 옮기면 안 된다.
 *
 * 판정 기준은 '어느 표를 끌고 도는가'(driving table)다. 이름이 큰 표가 아니라
 * WHERE 가 처음 좁히는 표가 비용을 정한다. 실측 인덱스:
 *
 *     IP_PRODUCT_2D_BARCODE        (SERIAL_NO) · (RUN_NO, SERIAL_NO)
 *     IQ_MACHINE_INSPECT_SPI       (INSPECT_DATE, PID) · (PID, INSPECT_DATE)
 *     IQ_MACHINE_INSPECT_DATA_SPI  (INSPECT_DATE, PID) · (PID, INSPECT_DATE) · (RUN_NO)
 *     IQ_MACHINE_INSPECT_DATA_AOI  (INSPECT_DATE, PID) · (PID, INSPECT_DATE) · (RUN_NO)
 *     IQ_MACHINE_INSPECT_DATA_MK   (PID) · (RUN_NO)
 *     IB_SMT_CHECKHIST             (LOT_NO, CHECK_TYPE, CHECK_STATUS) · (CHECK_DATE, ...) · (RUN_NO)
 *
 * 즉 키 하나(제조번호·PID·Run No)가 있으면 인덱스 한 번으로 끝난다. 키가 없으면
 * **기간이 닫혀 있고 라인이 지정돼야** 인덱스 구간 스캔이 된다.
 */
/** 추적 조회가 받는 조건. 전부 optional 이고, 이 중 무엇이 채워졌는지로 판정한다. */
export interface TrackingFilterInput {
    /** 자재 제조번호 (IB_SMT_CHECKHIST.LOT_NO) */
    lotNo?: string | null;
    /** PID = 2D 바코드 일련번호 (IP_PRODUCT_2D_BARCODE.SERIAL_NO) */
    serialNo?: string | null;
    /** 롯트카드 번호 */
    runNo?: string | null;
    /** 매거진 번호. 조회 화면 323(PID 정보조회)이 이것만으로도 열릴 수 있어야 한다. */
    magazineNo?: string | null;
    /** 기간 시작 (YYYY-MM-DD 또는 ISO) */
    dateFrom?: string | null;
    /** 기간 종료 */
    dateTo?: string | null;
    /** 라인코드 */
    lineCode?: string | null;
}
/**
 * 판정 결과.
 *
 * 판별 유니온(`{ok:true} | {ok:false; reason}`) 으로 두지 않는다 — 백엔드
 * tsconfig 가 `strictNullChecks: false` 라 유니온 좁히기가 동작하지 않아
 * `verdict.reason` 이 컴파일 오류가 된다 (실측 TS2339). 양쪽에서 쓰는 타입이므로
 * 더 느슨한 쪽에 맞춘다.
 */
export interface TrackingFilterVerdict {
    ok: boolean;
    /** ok 가 false 일 때만 채워진다. 화면에 그대로 띄울 문장이다. */
    reason?: string;
}
/**
 * 키 없이 기간으로 여는 경우 허용하는 최대 기간(일).
 * 31일은 '한 달 조회'를 막지 않는 가장 짧은 값이다. 실측 인덱스가
 * (INSPECT_DATE, PID) 선두라 기간이 닫혀 있으면 구간 스캔으로 끝난다.
 */
export declare const TRACKING_DATE_RANGE_MAX_DAYS = 31;
/** 화면에 그대로 띄우는 안내 문구. 프론트·백엔드가 같은 문장을 쓴다. */
export declare const TRACKING_FILTER_HINT: string;
/**
 * 추적 조회를 허용할지 판정한다.
 *
 * 1. 키(제조번호·PID·Run No·매거진) 가 하나라도 있으면 통과. 인덱스 단건 조회다.
 * 2. 키가 없으면 라인 + 닫힌 기간이 모두 있어야 하고 기간이 상한 안이어야 한다.
 * 3. 그 외는 거부한다. **거부 사유를 문장으로 돌려준다** — "조회 실패" 만 띄우면
 *    사용자가 무엇을 채워야 하는지 알 수 없다.
 */
export declare function checkTrackingFilter(input: TrackingFilterInput): TrackingFilterVerdict;
/**
 * LIKE 와일드카드 이스케이프 문자. SQL 쪽에 `ESCAPE '\'` 를 함께 적어야 한다.
 */
export declare const LIKE_ESCAPE = "\\";
/**
 * PB 의 `값 + '%'`(앞부분 일치) 조건을 만든다.
 *
 * **입력에 든 `%`·`_` 를 먼저 escape 한다.** 이 관례를 그대로 옮기면 사용자가
 * 모델명 칸에 `%` 한 글자를 넣는 순간 조건이 `'%%'` 가 되어 전체 스캔이 된다.
 * `_` 한 글자도 `'_%'` 가 되어 같은 일이 벌어진다. checkTrackingFilter 는 값이
 * 정확히 `'%'` 인 경우만 비었다고 보므로 그 둘을 걸러내지 못한다 — 두 방어가
 * 서로 다른 일을 한다.
 *
 * 빈 값이면 `'%'`(전체)를 그대로 돌려준다. 그 판단은 호출부가 아니라 여기서 한다.
 *
 * @example likePrefix('AAF')  → 'AAF%'
 * @example likePrefix('10%')  → '10\\%%'   (10% 로 시작하는 것만)
 * @example likePrefix('')     → '%'
 */
export declare function likePrefix(value?: string | null): string;
//# sourceMappingURL=required-filter.d.ts.map