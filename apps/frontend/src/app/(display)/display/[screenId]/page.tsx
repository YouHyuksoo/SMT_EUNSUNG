/**
 * @file [screenId]/page.tsx
 * @description 디스플레이 화면 동적 라우트. screenId에 따라 적절한 화면 컴포넌트를 로드.
 * 초보자 가이드: URL의 screenId 파라미터로 SCREENS 레지스트리에서 화면 설정을 찾아 렌더링한다.
 * 제목은 클라이언트 컴포넌트에서 useTranslations으로 다국어 자동 적용.
 */
import { notFound } from 'next/navigation';
import { SCREENS } from '@/lib/screens';
import DisplayLayout from '@/components/display/DisplayLayout';
import DisplayPlaceholder from '@/components/display/DisplayPlaceholder';
import SmdProductionStatus from '@/components/display/screens/smd-status/SmdProductionStatus';
import DisplayOption from '@/components/display/screens/option/DisplayOption';
import SolderWarningStatus from '@/components/display/screens/solder-warning/SolderWarningStatus';
import MslWarningStatus from '@/components/display/screens/msl-warning/MslWarningStatus';
import MslWarningIssueStatus from '@/components/display/screens/msl-warning-issue/MslWarningIssueStatus';
import ProductionKpiStatus from '@/components/display/screens/production-kpi/ProductionKpiStatus';
import FoolproofStatus from '@/components/display/screens/foolproof-status/FoolproofStatus';
import SmdDualProductionStatus from '@/components/display/screens/smd-dual-production/SmdDualProductionStatus';
import SpiChartStatus from '@/components/display/screens/spi-chart/SpiChartStatus';
import AoiChartStatus from '@/components/display/screens/aoi-chart/AoiChartStatus';
import FctChartStatus from '@/components/display/screens/fct-chart/FctChartStatus';
import ProductionLineStatus from '@/components/display/screens/product-line/ProductionLineStatus';

interface PageProps {
  params: Promise<{ screenId: string }>;
}

export default async function DisplayPage({ params }: PageProps) {
  const { screenId } = await params;
  const screen = SCREENS[screenId];
  if (!screen) notFound();

  if (screenId === '21') {
    return <ProductionLineStatus screenId={screenId} />;
  }

  if (screenId === '24') {
    return <SmdProductionStatus screenId={screenId} />;
  }

  if (screenId === '18') {
    return <DisplayOption screenId={screenId} />;
  }

  if (screenId === '26') {
    return <ProductionKpiStatus screenId={screenId} />;
  }

  if (screenId === '29') {
    return <MslWarningStatus screenId={screenId} />;
  }

  if (screenId === '30') {
    return <MslWarningIssueStatus screenId={screenId} />;
  }

  if (screenId === '31') {
    return <SolderWarningStatus screenId={screenId} />;
  }

  if (screenId === '25') {
    return <FoolproofStatus screenId={screenId} />;
  }

  if (screenId === '27') {
    return <SmdDualProductionStatus screenId={screenId} />;
  }

  if (screenId === '40') {
    return <SpiChartStatus screenId={screenId} />;
  }

  if (screenId === '41') {
    return <AoiChartStatus screenId={screenId} />;
  }

  if (screenId === '42') {
    return <FctChartStatus screenId={screenId} />;
  }

  return (
    <DisplayLayout title={screen.title}>
      <DisplayPlaceholder screenId={screenId} />
    </DisplayLayout>
  );
}
