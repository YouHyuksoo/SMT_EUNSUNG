/**
 * @file src/modules/ai-knowledge/ai-settings.service.ts
 * @description AI 설정 — env 형식 파일에서 읽고, 화면에서 "적용" 하면 파일을 고친 뒤 다시 읽는다.
 *
 * 초보자 가이드:
 * 1. **설정 파일**: `AI_ENV_PATH` (없으면 `<backend cwd>/data/ai/ai.env`).
 *    서버는 배포 때 릴리스 폴더가 바뀌므로 backend.env 에 공유 폴더 경로를 지정한다.
 * 2. **우선순위**: 설정 파일 값 → 백엔드 `.env`(process.env) → 코드 기본값.
 * 3. **적용**: 허용 키(ALLOWED_KEYS)의 줄만 바꾸고 다른 줄·주석·줄바꿈(CRLF)은 그대로 둔다. 쓰고 나서 즉시 다시 읽는다.
 * 4. **키 보안**: API 키 값은 화면으로 돌려주지 않는다. 등록 여부만 알려준다.
 */
import { BadRequestException, Injectable, Logger, OnModuleInit } from '@nestjs/common';
import * as fs from 'fs';
import * as path from 'path';
import * as dotenv from 'dotenv';

/** 화면에서 바꿀 수 있는 키 */
export const AI_SETTING_KEYS = [
  'AI_ENABLED',
  'AI_PROVIDER',
  'AI_MODEL',
  'AI_MODEL_FALLBACKS',
  'AI_EMBEDDING_PROVIDER',
  'AI_EMBEDDING_MODEL',
  'AI_EMBEDDING_DIMS',
  'AI_EMBEDDING_BASE_URL',
  'MISTRAL_API_KEY',
  'OPENAI_API_KEY',
  'OPENROUTER_API_KEY',
] as const;
export type AiSettingKey = (typeof AI_SETTING_KEYS)[number];

const SECRET_KEYS = new Set<string>(['MISTRAL_API_KEY', 'OPENAI_API_KEY', 'OPENROUTER_API_KEY']);

@Injectable()
export class AiSettingsService implements OnModuleInit {
  private readonly logger = new Logger(AiSettingsService.name);
  private values: Record<string, string> = {};

  onModuleInit() {
    this.reload();
  }

  /** 설정 파일 경로 */
  get filePath(): string {
    return process.env.AI_ENV_PATH || path.resolve(process.cwd(), 'data', 'ai', 'ai.env');
  }

  /** 설정 파일을 다시 읽는다. 파일이 없으면 빈 값(=process.env·기본값 사용) */
  reload(): void {
    try {
      this.values = fs.existsSync(this.filePath) ? dotenv.parse(fs.readFileSync(this.filePath)) : {};
    } catch (err: unknown) {
      this.values = {};
      this.logger.warn(`AI 설정 파일을 읽지 못함 (${this.filePath}): ${err instanceof Error ? err.message : String(err)}`);
    }
  }

  get(key: string, def = ''): string {
    const v = this.values[key] ?? process.env[key];
    return v === undefined || v === '' ? def : v;
  }

  /** 화면 표시용 — 키 값은 숨기고 등록 여부만 */
  snapshot(): { filePath: string; fileExists: boolean; values: Record<string, string>; keys: Record<string, boolean> } {
    const values: Record<string, string> = {};
    const keys: Record<string, boolean> = {};
    for (const k of AI_SETTING_KEYS) {
      if (SECRET_KEYS.has(k)) keys[k] = this.get(k) !== '';
      else values[k] = this.get(k);
    }
    return { filePath: this.filePath, fileExists: fs.existsSync(this.filePath), values, keys };
  }

  /**
   * 허용 키만 설정 파일에 반영하고 다시 읽는다.
   * 키 값이 빈 문자열이면 "바꾸지 않음" 으로 본다 (화면이 기존 키를 모르므로).
   */
  apply(updates: Partial<Record<string, string>>): void {
    const entries = Object.entries(updates).filter(([k, v]) => {
      if (!(AI_SETTING_KEYS as readonly string[]).includes(k)) throw new BadRequestException(`허용되지 않은 설정: ${k}`);
      if (typeof v !== 'string') return false;
      if (/[\r\n]/.test(v)) throw new BadRequestException(`줄바꿈이 들어간 값은 쓸 수 없습니다: ${k}`);
      return !(SECRET_KEYS.has(k) && v.trim() === '');
    }) as [string, string][];
    if (!entries.length) return;

    const file = this.filePath;
    fs.mkdirSync(path.dirname(file), { recursive: true });
    const original = fs.existsSync(file) ? fs.readFileSync(file, 'utf8') : '';
    const nl = original.includes('\r\n') ? '\r\n' : '\n';
    const lines = original === '' ? [] : original.split(/\r?\n/);
    const pending = new Map(entries.map(([k, v]) => [k, v.trim()]));

    const next = lines.map((line) => {
      const m = line.match(/^\s*([A-Z0-9_]+)\s*=/);
      if (!m || !pending.has(m[1])) return line;
      const v = pending.get(m[1])!;
      pending.delete(m[1]);
      return `${m[1]}=${v}`;
    });
    if (next.length && next[next.length - 1] === '') next.pop();
    for (const [k, v] of pending) next.push(`${k}=${v}`);

    fs.writeFileSync(file, next.join(nl) + nl, 'utf8');
    this.reload();
    this.logger.log(`AI 설정 적용: ${entries.map(([k]) => k).join(', ')}`);
  }
}
