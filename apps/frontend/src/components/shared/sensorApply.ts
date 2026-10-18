/**
 * @file components/shared/sensorApply.ts
 * @description 완제품 실적(IP_PRODUCT_RESULT)의 공정재고 반영 상태 판정 — 실적 화면들이 함께 쓴다.
 *
 * sensorApplyYn(WORKSTAGE_ISSUE_YN): Y=반영 / N=미반영(재시도 대상) / X=해당 없음(조립라인 아님·전환 전) / C=취소로 되돌림
 * 공정재고(제품 입고 + 반제품·자재 소모)는 조립라인 완료 실적만 움직인다. 가공·수리 라인 실적은 X 로 기록된다.
 */

/** 완료 실적인데 공정재고에 아직 반영되지 않아 [실적반영] 재시도가 필요한가 */
export function isSensorPending(resultStatus: string | null | undefined, sensorApplyYn: string | null | undefined): boolean {
  return resultStatus === 'DONE' && (sensorApplyYn ?? 'N') === 'N';
}
