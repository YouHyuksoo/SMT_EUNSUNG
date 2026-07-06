import koMessages from '@/i18n/messages/ko.json';
import enMessages from '@/i18n/messages/en.json';
import esMessages from '@/i18n/messages/es.json';
import viMessages from '@/i18n/messages/vi.json';
import { SCREENS } from '@/lib/screens';
import { KEYS } from './storage';

const allMessages: Record<string, Record<string, unknown>> = {
  ko: koMessages,
  en: enMessages,
  es: esMessages,
  vi: viMessages,
};

function getLocale(): string {
  if (typeof window === 'undefined') return 'ko';
  return localStorage.getItem(KEYS.LOCALE) ?? 'ko';
}

export function t(key: string, params?: Record<string, string | number>): string {
  const locale = getLocale();
  const messages = allMessages[locale] ?? allMessages.ko;
  const parts = key.split('.');
  let value: unknown = messages;

  for (const part of parts) {
    if (!value || typeof value !== 'object') return key;
    value = (value as Record<string, unknown>)[part];
  }

  if (typeof value !== 'string') return key;
  if (!params) return value;

  return Object.entries(params).reduce(
    (text, [name, paramValue]) => text.replaceAll(`{${name}}`, String(paramValue)),
    value,
  );
}

export function getScreenTitle(shortcut: { id?: string; url: string; title: string }): string {
  const displayMatch = shortcut.url.match(/\/display\/(\d+)/);
  if (!displayMatch) return shortcut.title;

  const screen = SCREENS[displayMatch[1]];
  if (!screen) return shortcut.title;

  return localizedTitle(screen);
}

function localizedTitle(screen: { title: string; titleKo: string; titleEs?: string; titleVi?: string }): string {
  const locale = getLocale();
  if (locale === 'ko') return screen.titleKo;
  if (locale === 'es' && screen.titleEs) return screen.titleEs;
  if (locale === 'vi' && screen.titleVi) return screen.titleVi;
  return screen.title;
}
