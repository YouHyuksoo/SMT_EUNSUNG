/**
 * @file src/app/(authenticated)/purchase/skipped-bom.ts
 * @description 477 소요량 전개·478 발주계획 생성에서 BOM 이 없어 건너뛴 품목 안내 문구.
 * 전개는 그 품목만 빼고 끝까지 진행되므로, 무엇이 빠졌는지 사용자에게 알려야 한다.
 */
import toast from 'react-hot-toast';

export function notifySkippedBom(items: unknown): void {
  const list = Array.isArray(items) ? items.map(String) : [];
  if (list.length === 0) return;
  const shown = list.slice(0, 5).join(', ');
  toast.error(
    `BOM 이 없어 ${list.length}개 품목은 빼고 전개했습니다: ${shown}${list.length > 5 ? ' …' : ''}`,
    { duration: 10000 },
  );
}
