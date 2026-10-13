/**
 * @file components/shared/sensorApply.ts
 * @description 실적(IP_PRODUCT_WORK_RESULT)의 센서 실적 반영 상태 판정 — 실적 화면들이 함께 쓴다.
 *
 * SENSOR_APPLY_YN: Y=반영 / N=미반영(재시도 대상) / X=해당 없음(SMT 가 아닌 라인) / C=취소로 차감됨
 * 센서 누적 프로시저는 SMT 피더 계획이 있는 라인에서만 쌓이므로, 조립·가공 라인 실적은 X 로 기록된다.
 */

/** 완료 실적인데 센서에 아직 반영되지 않아 [실적반영] 재시도가 필요한가 */
export function isSensorPending(resultStatus: string | null | undefined, sensorApplyYn: string | null | undefined): boolean {
  return resultStatus === 'DONE' && (sensorApplyYn ?? 'N') === 'N';
}
