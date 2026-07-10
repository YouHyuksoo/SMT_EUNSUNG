/**
 * @file DisplayOption.tsx
 * @description 옵션 설정 화면 (Screen 18) 메인 컨테이너. 5탭 UI.
 * 초보자 가이드: DisplayLayout으로 감싸고, 모니터링 전용 옵션 탭을 전환한다.
 */
'use client';

import { useState } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import { useTranslations } from 'next-intl';
import dynamic from 'next/dynamic';
import DisplayLayout from '../../DisplayLayout';
import PageRollingPanel from './PageRollingPanel';
import DatabasePanel from './DatabasePanel';
import AutoLaunchPanel from './AutoLaunchPanel';
import CardManagerPanel from './CardManagerPanel';

const AiTrainingPanel = dynamic(() => import('./panels/AiTrainingPanel'), { ssr: false });

type Tab =
  | 'rolling'
  | 'database'
  | 'autolaunch'
  | 'cards'
  | 'aiTraining';

const TAB_KEYS: { key: Tab; labelKey: string }[] = [
  { key: 'rolling', labelKey: 'pageRolling' },
  { key: 'database', labelKey: 'dbSettings' },
  { key: 'autolaunch', labelKey: 'autoLaunch' },
  { key: 'cards', labelKey: 'cardManage' },
  { key: 'aiTraining', labelKey: 'aiTraining' },
];

interface DisplayOptionProps {
  screenId: string;
}

export default function DisplayOption({ screenId }: DisplayOptionProps) {
  const router = useRouter();
  const searchParams = useSearchParams();
  const initialTab = TAB_KEYS.some((tab) => tab.key === searchParams.get('tab'))
    ? searchParams.get('tab') as Tab
    : 'rolling';
  const [activeTab, setActiveTab] = useState<Tab>(initialTab);
  const t = useTranslations('option');

  const selectTab = (tab: Tab) => {
    setActiveTab(tab);
    router.replace(tab === 'rolling' ? '/display/18' : `/display/18?tab=${tab}`, { scroll: false });
  };

  return (
    <DisplayLayout screenId={screenId}>
      <div className="flex h-full flex-col overflow-hidden">
        {/* 탭 헤더 */}
        <div className="flex border-b border-zinc-200 bg-zinc-50 dark:border-zinc-700 dark:bg-zinc-900">
          {TAB_KEYS.map(({ key, labelKey }) => (
            <button
              key={key}
              onClick={() => selectTab(key)}
              className={`px-6 py-3 text-sm font-medium transition-colors ${
                activeTab === key
                  ? 'border-b-2 border-blue-600 text-blue-600 dark:border-blue-400 dark:text-blue-400'
                  : 'text-zinc-500 hover:text-zinc-700 dark:text-zinc-400 dark:hover:text-zinc-200'
              }`}
            >
              {t(labelKey)}
            </button>
          ))}
        </div>

        {/* 탭 콘텐츠 */}
        <div className="min-h-0 flex-1 overflow-auto">
          {activeTab === 'rolling' && <PageRollingPanel />}
          {activeTab === 'database' && <DatabasePanel />}
          {activeTab === 'autolaunch' && <AutoLaunchPanel />}
          {activeTab === 'cards' && <CardManagerPanel />}
          {activeTab === 'aiTraining' && <div className="h-full"><AiTrainingPanel /></div>}
        </div>
      </div>
    </DisplayLayout>
  );
}
