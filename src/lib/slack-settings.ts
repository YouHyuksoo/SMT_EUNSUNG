/**
 * @file src/lib/slack-settings.ts
 * @description
 * Slack / Teams ?뚮┝ ?ㅼ젙??JSON ?뚯씪濡????議고쉶?섎뒗 ?좏떥由ы떚?낅땲??
 * Oracle DB ?놁씠 data/slack-settings.json ?뚯씪??吏곸젒 ?ъ슜?⑸땲??
 *
 * 珥덈낫??媛?대뱶:
 * 1. **getSettings()**: ?꾩옱 ?ㅼ젙 議고쉶 (?뚯씪 ?놁쑝硫?湲곕낯媛?諛섑솚)
 * 2. **saveSettings()**: ?ㅼ젙??JSON ?뚯씪????? * 3. **????꾩튂**: ?꾨줈?앺듃 猷⑦듃??data/slack-settings.json
 * 4. Slack怨?Teams ?ㅼ젙???④퍡 ??λ맗?덈떎
 *
 * ?ъ슜 ??
 * ```typescript
 * import { getSettings, saveSettings } from '@/lib/slack-settings';
 * const settings = await getSettings();
 * await saveSettings({ ...settings, isEnabled: true });
 * ```
 */

import fs from 'fs/promises';
import path from 'path';

/** Slack / Teams ?듯빀 ?뚮┝ ?ㅼ젙 ???*/
export interface SlackSettings {
  // --- Slack ?ㅼ젙 ---
  /** Incoming Webhook URL */
  webhookUrl: string;
  /** ?뚮┝ 梨꾨꼸紐?(?쒖떆?? */
  channelName: string;
  /** Slack ?뚮┝ 留덉뒪??ON/OFF */
  isEnabled: boolean;
  /** ?⑷꺽瑜?湲됰씫 ?뚮┝ */
  notifyPassRateDrop: boolean;
  /** NG 湲됱쬆 ?뚮┝ */
  notifyNgSpike: boolean;
  /** ?쇱씤 ?뺤? ?뚮┝ */
  notifyLineStop: boolean;
  /** ?ㅻ퉬 ?댁긽 ?뚮┝ */
  notifyEquipmentDown: boolean;
  /** ?쇱씪 ?붿빟 由ы룷??*/
  notifyDailyReport: boolean;
  /** 湲닿툒 ??@channel 硫섏뀡 */
  mentionOnUrgent: boolean;
  /** ?쇱씪 由ы룷???꾩넚 ?쒓컙 (HH:mm) */
  dailyReportTime: string;
  // --- Teams ?ㅼ젙 ---
  /** Teams Incoming Webhook URL */
  teamsWebhookUrl: string;
  /** Teams 梨꾨꼸紐?(?쒖떆?? */
  teamsChannelName: string;
  /** Teams ?뚮┝ ON/OFF */
  teamsEnabled: boolean;
}

/** 湲곕낯 ?ㅼ젙媛?*/
const DEFAULT_SETTINGS: SlackSettings = {
  webhookUrl: '',
  channelName: '',
  isEnabled: false,
  notifyPassRateDrop: false,
  notifyNgSpike: false,
  notifyLineStop: false,
  notifyEquipmentDown: false,
  notifyDailyReport: false,
  mentionOnUrgent: false,
  dailyReportTime: '08:00',
  teamsWebhookUrl: '',
  teamsChannelName: '',
  teamsEnabled: false,
};

/** ?ㅼ젙 ?뚯씪 寃쎈줈 */
const SETTINGS_PATH = path.join(process.cwd(), 'data', 'slack-settings.json');

function normalizeSettings(settings: Partial<SlackSettings>): SlackSettings {
  return {
    webhookUrl: settings.webhookUrl ?? DEFAULT_SETTINGS.webhookUrl,
    channelName: settings.channelName ?? DEFAULT_SETTINGS.channelName,
    isEnabled: settings.isEnabled ?? DEFAULT_SETTINGS.isEnabled,
    notifyPassRateDrop: settings.notifyPassRateDrop ?? DEFAULT_SETTINGS.notifyPassRateDrop,
    notifyNgSpike: settings.notifyNgSpike ?? DEFAULT_SETTINGS.notifyNgSpike,
    notifyLineStop: settings.notifyLineStop ?? DEFAULT_SETTINGS.notifyLineStop,
    notifyEquipmentDown: settings.notifyEquipmentDown ?? DEFAULT_SETTINGS.notifyEquipmentDown,
    notifyDailyReport: settings.notifyDailyReport ?? DEFAULT_SETTINGS.notifyDailyReport,
    mentionOnUrgent: settings.mentionOnUrgent ?? DEFAULT_SETTINGS.mentionOnUrgent,
    dailyReportTime: settings.dailyReportTime ?? DEFAULT_SETTINGS.dailyReportTime,
    teamsWebhookUrl: settings.teamsWebhookUrl ?? DEFAULT_SETTINGS.teamsWebhookUrl,
    teamsChannelName: settings.teamsChannelName ?? DEFAULT_SETTINGS.teamsChannelName,
    teamsEnabled: settings.teamsEnabled ?? DEFAULT_SETTINGS.teamsEnabled,
  };
}

/**
 * ?꾩옱 Slack ?ㅼ젙 議고쉶
 * ?뚯씪???녾굅???쎄린 ?ㅽ뙣 ??湲곕낯媛?諛섑솚
 * @returns SlackSettings 媛앹껜
 */
export async function getSettings(): Promise<SlackSettings> {
  try {
    const raw = await fs.readFile(SETTINGS_PATH, 'utf-8');
    const parsed = JSON.parse(raw) as Partial<SlackSettings>;
    return normalizeSettings(parsed);
  } catch {
    return { ...DEFAULT_SETTINGS };
  }
}

/**
 * Slack ?ㅼ젙 ??? * data/ ?붾젆?좊━媛 ?놁쑝硫??먮룞 ?앹꽦
 * @param settings - ??ν븷 ?ㅼ젙 媛앹껜
 */
export async function saveSettings(settings: SlackSettings): Promise<void> {
  const dir = path.dirname(SETTINGS_PATH);
  await fs.mkdir(dir, { recursive: true });
  await fs.writeFile(SETTINGS_PATH, JSON.stringify(normalizeSettings(settings), null, 2), 'utf-8');
}
