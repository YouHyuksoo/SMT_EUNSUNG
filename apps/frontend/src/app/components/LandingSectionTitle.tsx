/**
 * @file src/app/components/LandingSectionTitle.tsx
 * @description 랜딩페이지 섹션 제목 - 영문 라벨(primary) + 한글 제목, 좌측 정렬
 */

export default function LandingSectionTitle({ ko, en }: { ko: string; en: string }) {
  return (
    <div className="mb-10">
      <p className="text-xs font-semibold tracking-[0.2em] text-primary mb-3">{en}</p>
      <h2 className="text-3xl lg:text-4xl font-bold text-text">{ko}</h2>
    </div>
  );
}
