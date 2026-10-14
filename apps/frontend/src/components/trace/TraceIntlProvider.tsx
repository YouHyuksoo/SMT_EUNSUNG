/**
 * @file src/components/trace/TraceIntlProvider.tsx
 * @description 정추적·역추적 화면 전용 next-intl 프로바이더.
 *
 * 초보자 가이드:
 * - 추적 화면 컴포넌트는 webdisplay 에서 가져와 next-intl(useTranslations)을 쓴다.
 *   업무 화면(authenticated)은 react-i18next 라서 이 프로바이더로 감싼다.
 * - 메시지는 ./messages/{ko,en,es,vi}.json (추적 화면에서 쓰는 키만). 업무 화면 언어를 따르고
 *   중국어(zh)처럼 메시지가 없는 언어는 영어로 보인다.
 */
'use client';

import { NextIntlClientProvider } from 'next-intl';
import { useTranslation } from 'react-i18next';
import ko from './messages/ko.json';
import en from './messages/en.json';
import es from './messages/es.json';
import vi from './messages/vi.json';

const MESSAGES = { ko, en, es, vi } as const;
type TraceLocale = keyof typeof MESSAGES;

export default function TraceIntlProvider({ children }: { children: React.ReactNode }) {
  const { i18n } = useTranslation();
  const lang = (i18n.language || 'ko').slice(0, 2);
  const locale: TraceLocale = lang in MESSAGES ? (lang as TraceLocale) : 'en';

  return (
    <NextIntlClientProvider
      locale={locale}
      timeZone={Intl.DateTimeFormat().resolvedOptions().timeZone}
      messages={MESSAGES[locale]}
    >
      {children}
    </NextIntlClientProvider>
  );
}
