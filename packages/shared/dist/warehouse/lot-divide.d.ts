/**
 * @file packages/shared/src/warehouse/lot-divide.ts
 * @description 자재 롯트/릴 분할 규칙 — 프론트·백엔드가 함께 쓴다 (PB 240).
 *
 * 초보자 가이드:
 * 1. **릴 하나를 여러 조각으로 쪼개는 규칙이다.** 3,000개 릴을 1,000/1,000/1,000 으로
 *    나누면 릴이 세 개가 된다.
 * 2. **원본 릴은 없어지지 않는다 — 마지막 조각이 된다.** PB 는 조각 N개 중
 *    **앞 N-1개만 새 바코드로 만들고**, 원본 바코드의 수량을 마지막 조각 수량으로
 *    고친다 (실측 PB 1441행 `if i = Upperbound - 1 then exit` + 1455행
 *    `LVL_QTY = ivl_divide_qty[upperbound]`).
 *    이 한 칸 차이를 놓치면 **수량이 한 조각만큼 늘어난다** — 재고가 부풀어 오른다.
 * 3. **조각이 하나면 분할이 아니다.** PB 는 `Upperbound = 1` 이면 아무것도 하지
 *    않는다. 새 바코드도, 원본 수량 변경도 없다.
 * 4. **수량 합은 원본과 같아야 한다.** PB 는 이것을 검사하지 않아 사용자가 잘못
 *    적으면 재고가 늘거나 줄었다. 여기서는 맞는지 확인할 수 있게 값을 낸다.
 * 5. **롯트번호는 235·243 과 같은 방식이다** — 3글자 날짜코드 + 시퀀스.
 *    분할은 시퀀스를 **5자리로 0 채움** 한다 (PB `STRING(seq,'00000')`).
 */
/** 분할 계획 한 건. */
export interface LotDividePlan {
    /** 새 바코드로 만들 조각 수량들 (앞 N-1개). */
    newPieces: number[];
    /** 원본 바코드가 갖게 되는 수량 (마지막 조각). */
    originalPiece: number;
    /** 조각 전체 수량 합. 원본 수량과 같아야 한다. */
    totalQty: number;
    /** 조각 개수 (= `newPieces.length + 1`). */
    pieceCount: number;
}
export interface LotDivideVerdict {
    /** `reel-plan.ts` 와 같은 이유로 판별 유니온을 쓰지 않는다. */
    ok: boolean;
    reason?: string;
}
/** 한 번에 쪼갤 수 있는 최대 조각 수. PB 에는 상한이 없었다. */
export declare const LOT_DIVIDE_MAX = 200;
/**
 * 분할할 수 있는지 본다.
 *
 * @param divideQty 조각 수량 목록
 * @param originQty 원본 릴 수량. 주면 합이 맞는지도 본다.
 */
export declare function checkLotDivide(divideQty: readonly number[] | null | undefined, originQty?: number | null): LotDivideVerdict;
/**
 * 분할 계획을 만든다.
 *
 * **앞 N-1 조각만 새 바코드가 되고 마지막 조각은 원본 바코드가 된다** (파일 머리 2번).
 *
 * @throws 분할할 수 없는 입력일 때
 */
export declare function planLotDivide(divideQty: readonly number[], originQty?: number | null): LotDividePlan;
/**
 * 분할 롯트번호 = 3글자 날짜코드 + 시퀀스를 **5자리로 0 채움**
 * (PB `F_YMD_SYSDATE() + TRIM(STRING(seq,'00000'))`).
 *
 * 235·243 의 롯트번호와 앞부분 규칙은 같고 0 채움만 다르다.
 */
export declare function buildDivideLotNo(datePrefix: string, sequence: number | string): string;
/** 분할 바코드 = `품목코드-롯트번호-수량` (PB 문자열 연결 그대로). */
export declare function buildDivideBarcode(itemCode: string, lotNo: string, qty: number): string;
//# sourceMappingURL=lot-divide.d.ts.map