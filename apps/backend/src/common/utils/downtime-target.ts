/**
 * @file common/utils/downtime-target.ts
 * @description 비가동 대상 설비 규칙 — 비가동을 다루는 모든 화면·API 가 같은 설비 집합을 쓰게 한다.
 *
 * 비가동의 주체는 설비다(ADR 0002). 같은 설비가 ES- 코드 행과 옛 시리얼 코드 행으로 두 번 들어 있어서
 * (2026-10-14 엑셀 업로드) 비가동 사유 연계·표준시간이 쓰는 ES- 코드만 대상으로 한다(2026-10-16 결정).
 * 옛 행은 지우지 않고 비가동 목록에서만 뺀다. 사용중(U)만, 온도계(TEMP)는 제외.
 */
export function downtimeTargetMachineSql(alias: string): string {
  return `${alias}.MACHINE_CODE LIKE 'ES-%' AND ${alias}.USE_STATUS = 'U' AND NVL(${alias}.MACHINE_TYPE, '-') <> 'TEMP'`;
}
