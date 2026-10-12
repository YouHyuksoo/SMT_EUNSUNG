"use strict";
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
Object.defineProperty(exports, "__esModule", { value: true });
exports.SOLDER_FACTORIES = exports.SOLDER_DAY_MAX = void 0;
exports.solderTypeCode = solderTypeCode;
exports.checkSolderLabelPlan = checkSolderLabelPlan;
exports.buildSolderBarcode = buildSolderBarcode;
exports.planSolderBarcodes = planSolderBarcodes;
/** 그날 찍을 수 있는 마지막 일련번호. 세 자리를 넘기면 바코드가 겹친다. */
exports.SOLDER_DAY_MAX = 999;
/** 라벨을 찍을 수 있는 공장코드 (PB `ddlb_factory` 목록 그대로). */
exports.SOLDER_FACTORIES = ['A', 'B'];
/**
 * 바코드 앞 1자. PB `IF lvs_solder_type = 'F' THEN lvs_solder_type = 'S'` 그대로다.
 *
 * 값이 없으면 빈 문자열을 돌려준다 — PB 는 그 경우 발행을 멈춘다.
 */
function solderTypeCode(solderType) {
    const raw = String(solderType ?? '').trim().toUpperCase();
    if (raw === '' || raw === '*')
        return '';
    return raw === 'F' ? 'S' : raw;
}
/** 발행할 수 있는지 본다. 화면은 이 결과로 버튼을 막고, 서버는 같은 함수로 다시 본다. */
function checkSolderLabelPlan(input) {
    if (!solderTypeCode(input.solderType)) {
        return { ok: false, reason: '품목에 솔더 종류(SOLDER_TYPE)가 없습니다.' };
    }
    if (!/^\d{6}$/.test(String(input.dateYymmdd ?? ''))) {
        return { ok: false, reason: '발행일이 YYMMDD 6자리가 아닙니다.' };
    }
    if (!exports.SOLDER_FACTORIES.includes(input.factory)) {
        return {
            ok: false,
            reason: `공장코드는 ${exports.SOLDER_FACTORIES.join('·')} 중 하나여야 합니다.`,
        };
    }
    if (!Number.isInteger(input.count) || input.count <= 0) {
        return { ok: false, reason: '발행 장수를 1 이상 넣으세요.' };
    }
    const last = Number(input.lastSequence ?? 0);
    if (!Number.isInteger(last) || last < 0) {
        return { ok: false, reason: '마지막 일련번호가 올바르지 않습니다.' };
    }
    // PB 가 검사만 하고 막지 않던 조건이다 (파일 머리 4번).
    if (last + input.count > exports.SOLDER_DAY_MAX) {
        return {
            ok: false,
            reason: `하루 ${exports.SOLDER_DAY_MAX}장까지만 찍을 수 있습니다`
                + ` (오늘 ${last}장 발행됨 · 요청 ${input.count}장).`,
        };
    }
    return { ok: true };
}
/** 라벨 한 장의 바코드. `종류(1) + YYMMDD(6) + 일련(3) + 공장(1)` = 11자. */
function buildSolderBarcode(typeCode, dateYymmdd, sequence, factory) {
    return `${typeCode}${dateYymmdd}${String(sequence).padStart(3, '0')}${factory}`;
}
/**
 * 찍을 바코드 목록을 만든다. 일련번호는 `lastSequence + 1` 부터 이어 붙인다
 * (PB `lvl_solder_day_seq + i`, i 는 1부터).
 *
 * @throws 발행할 수 없는 입력일 때
 */
function planSolderBarcodes(input) {
    const verdict = checkSolderLabelPlan(input);
    if (!verdict.ok)
        throw new Error(verdict.reason);
    const typeCode = solderTypeCode(input.solderType);
    return Array.from({ length: input.count }, (_, i) => buildSolderBarcode(typeCode, input.dateYymmdd, input.lastSequence + i + 1, input.factory));
}
