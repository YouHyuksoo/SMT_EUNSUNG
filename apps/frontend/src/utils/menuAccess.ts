// 메뉴 접근 허용 여부를 한 곳에서 판정하는 RBAC 헬퍼

/**
 * 메뉴 코드 접근 허용 여부.
 *
 * 판정 순서.
 * 1. ADMIN은 항상 통과한다.
 * 2. 권한 코드가 없는 경로는 권한 체크 대상이 아니다.
 * 3. 허용 목록이 비어 있으면 '메뉴권한 미연동' 상태로 보고 전체 허용한다.
 *    (백엔드가 아직 allowedMenus를 빈 배열로 내려준다 — auth.service.ts)
 * 4. 그 외에는 허용 목록에 있는 코드만 통과한다.
 */
export function isMenuAllowed(
  code: string | undefined | null,
  allowedMenus: string[],
  isAdmin: boolean,
): boolean {
  if (isAdmin) return true;
  if (!code) return true;
  if (allowedMenus.length === 0) return true;
  return allowedMenus.includes(code);
}
