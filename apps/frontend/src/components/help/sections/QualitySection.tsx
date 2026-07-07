/**
 * @file QualitySection.tsx
 * @description 도움말 - 품질 관리 섹션. 화면 31, 37 설명.
 * 초보자 가이드: 솔더 페이스트, 온습도 관리 화면의 기능을 안내.
 */
import SectionWrapper from './SectionWrapper';
import ScreenCard from './ScreenCard';

export default function QualitySection() {
  return (
    <SectionWrapper id="quality" title="품질 관리" icon="✅">
      <div className="space-y-6">
        <p className="text-zinc-300">
          제조 공정의 품질 관련 항목을 모니터링합니다. 솔더 페이스트 사용 기한,
          온습도 환경 등을 실시간으로 감시합니다.
        </p>

        <ScreenCard
          screenId="31"
          title="Solder Paste 관리"
          titleEn="Solder Paste Management"
          route="/display/31"
          description="솔더 페이스트(납땜용 크림)의 사용 기한과 상태를 관리합니다. 개봉 후 유효 시간이 초과되면 경고를 표시하여 불량을 예방합니다."
          features={[
            '솔더 페이스트 사용 기한 모니터링',
            '개봉 후 경과 시간 추적',
            '유효기간 초과 항목 빨간색 경고',
            'NG 건수 상단 배너',
          ]}
          columns={['라인', '위치', '제품명', '개봉시간', '경과시간', '유효시간', '잔여시간', '판정']}
          refreshSeconds={30}
        />

        <ScreenCard
          screenId="37"
          title="온습도"
          titleEn="Temperature & Humidity"
          route="/display/37"
          description="작업장 내 온도와 습도를 실시간으로 모니터링합니다. 설정된 기준 범위를 벗어나면 경고를 표시하여 작업 환경을 관리합니다."
          features={[
            '센서별 온도/습도 실시간 표시',
            '기준 범위 초과 시 빨간색 경고',
            'NG 건수 배너 (기준 이탈 센서 수)',
            '온도/습도 상한·하한 기준값 표시',
          ]}
          columns={['라인', '위치', '온도', '습도', '온도기준', '습도기준', '판정']}
          refreshSeconds={30}
        />
      </div>
    </SectionWrapper>
  );
}
