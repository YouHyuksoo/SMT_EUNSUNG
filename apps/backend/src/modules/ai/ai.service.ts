/**
 * @file src/modules/ai/ai.service.ts
 * @description AI 채팅 서비스 — provider 추상화(Mistral/OpenAI)
 *
 * - provider/model/활성화: SYS_CONFIGS AI 그룹(AI_PROVIDER/AI_MODEL/AI_ENABLED)
 * - API 키: SYS_CONFIGS(AI_MISTRAL_KEY/AI_OPENAI_KEY, UI 입력) 우선, 없으면 .env(MISTRAL_API_KEY/OPENAI_API_KEY)
 * - complete(): provider 분기 + 429 자동 재시도. 1·2단계 공통.
 * - test(): 입력 키/provider/model로 즉석 연결 확인
 */
import { Injectable, BadRequestException, Logger } from '@nestjs/common';
import { Mistral } from '@mistralai/mistralai';
import { AiSettingsService } from '../ai-knowledge/ai-settings.service';
import { AiChatAttachmentDto, AiChatMessageDto } from './dto/ai-chat.dto';

const SYSTEM_PROMPT =
  '당신은 은성전장 MES(제조실행시스템) 운영을 돕는 AI 비서입니다. 한국어로 간결하고 정확하게 답합니다.';

const PROVIDER_DEFAULT_MODEL: Record<string, string> = {
  mistral: 'mistral-medium-latest',
  openai: 'gpt-4o-mini',
  openrouter: 'nvidia/nemotron-3-super-120b-a12b:free',
};

/** OpenRouter 대체 모델 기본값 (2026-10-01 응답 확인된 무료 모델) — AI_MODEL_FALLBACKS 로 바꾼다 */
const OPENROUTER_DEFAULT_FALLBACKS = [
  'inclusionai/ling-3.0-flash-sante:free',
  'google/gemma-4-31b-it:free',
];

type LlmMessage = { role: 'system' | 'user' | 'assistant'; content: string; attachments?: AiChatAttachmentDto[] };
type OpenAIContentPart =
  | { type: 'text'; text: string }
  | { type: 'image_url'; image_url: { url: string } };
type OpenAIMessage = { role: 'system' | 'user' | 'assistant'; content: string | OpenAIContentPart[] };

@Injectable()
export class AiService {
  private readonly logger = new Logger(AiService.name);

  constructor(private readonly settings: AiSettingsService) {}

  /** 설정: AI 설정 파일(AI_ENV_PATH) → 백엔드 .env → 기본값 (ai-settings.service) */
  private async getConfigValue(configKey: string, def: string): Promise<string> {
    return this.settings.get(configKey, def);
  }

  /** 키: AI 설정 파일 또는 .env 의 {PROVIDER}_API_KEY */
  private async getApiKey(provider: string): Promise<string | undefined> {
    const key = provider === 'openai' ? 'OPENAI_API_KEY' : provider === 'openrouter' ? 'OPENROUTER_API_KEY' : 'MISTRAL_API_KEY';
    return this.settings.get(key) || undefined;
  }

  /** config 탭 표시용 상태 (키 원문은 반환하지 않는다) */
  async getStatus() {
    const [enabled, provider] = await Promise.all([
      this.getConfigValue('AI_ENABLED', 'Y'),
      this.getConfigValue('AI_PROVIDER', 'mistral'),
    ]);
    const model = await this.getConfigValue('AI_MODEL', PROVIDER_DEFAULT_MODEL[provider] ?? 'mistral-medium-latest');
    const apiKey = await this.getApiKey(provider);
    return {
      enabled: enabled === 'Y',
      provider,
      model,
      keyConfigured: !!apiKey,
    };
  }

  /** LLM 호출 코어 (provider 분기 + 429 재시도). 호출자가 전체 messages(system 포함)를 구성한다. */
  async complete(messages: LlmMessage[]): Promise<string> {
    const enabled = await this.getConfigValue('AI_ENABLED', 'Y');
    if (enabled !== 'Y') {
      throw new BadRequestException('AI 채팅이 비활성화되어 있습니다. 시스템 환경설정에서 AI를 활성화해 주세요.');
    }
    const provider = await this.getConfigValue('AI_PROVIDER', 'mistral');
    const model = await this.getConfigValue('AI_MODEL', PROVIDER_DEFAULT_MODEL[provider] ?? 'mistral-medium-latest');
    const apiKey = await this.getApiKey(provider);
    if (!apiKey) {
      throw new BadRequestException(`${provider} API 키가 설정되지 않았습니다. 시스템 환경설정 > AI에서 키를 등록해 주세요.`);
    }

    for (let attempt = 0; attempt < 3; attempt += 1) {
      try {
        return await this.callProvider(provider, model, apiKey, messages);
      } catch (error: unknown) {
        const detail = error instanceof Error ? error.message : String(error);
        const statusCode = typeof error === 'object' && error !== null ? Reflect.get(error, 'statusCode') : undefined;
        const isRate = /429|rate ?limit|too many/i.test(detail) || statusCode === 429;
        // 무료 모델 상류 장애(과부하·중도 끊김·게이트웨이 오류)도 일시적이라 다시 시도한다
        const isTransient = isRate || /overloaded|aborted|upstream|timed? ?out|\b50[234]\b/i.test(detail);
        if (isTransient && attempt < 2) {
          await new Promise((r) => setTimeout(r, 1500 * (attempt + 1)));
          continue;
        }
        this.logger.error(`${provider} 호출 실패: ${detail}`);
        throw new BadRequestException(
          isRate
            ? 'AI 요청이 많아 처리하지 못했습니다. 잠시 후 다시 시도해 주세요. (rate limit)'
            : `AI 응답 생성 실패: ${detail}`,
        );
      }
    }
    throw new BadRequestException('AI 응답 생성에 실패했습니다.');
  }

  private async callProvider(provider: string, model: string, apiKey: string, messages: LlmMessage[]): Promise<string> {
    switch (provider) {
      case 'openai':
        return this.callOpenAI(model, apiKey, messages);
      case 'openrouter':
        return this.callOpenRouter(model, apiKey, messages);
      default:
        return this.callMistral(model, apiKey, messages);
    }
  }

  private async callMistral(model: string, apiKey: string, messages: LlmMessage[]): Promise<string> {
    if (this.hasImageAttachments(messages)) {
      throw new BadRequestException('현재 Mistral 설정은 이미지 첨부 분석을 지원하지 않습니다. OpenAI 또는 vision 지원 OpenRouter 모델로 변경해 주세요.');
    }
    const client = new Mistral({ apiKey });
    const res = await client.chat.complete({ model, messages });
    const content = res.choices?.[0]?.message?.content;
    return typeof content === 'string' ? content : '';
  }

  /** OpenAI 호환 Chat Completions 호출 (OpenAI / OpenRouter 공통) */
  private async callOpenAICompatible(
    url: string,
    label: string,
    model: string,
    apiKey: string,
    messages: LlmMessage[],
    extraHeaders: Record<string, string> = {},
    extraBody: Record<string, unknown> = {},
  ): Promise<string> {
    const providerMessages = this.toOpenAICompatibleMessages(messages);
    const res = await fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${apiKey}`, ...extraHeaders },
      body: JSON.stringify({ model, messages: providerMessages, ...extraBody }),
    });
    if (!res.ok) {
      const body = await res.text();
      throw new Error(`${label} ${res.status}: ${body.slice(0, 200)}`);
    }
    const data = (await res.json()) as {
      choices?: { message?: { content?: string } }[];
      error?: { message?: string };
    };
    // OpenRouter는 HTTP 200으로도 본문에 error를 담아 줄 수 있다.
    if (data.error?.message) throw new Error(`${label}: ${data.error.message}`);
    return data.choices?.[0]?.message?.content ?? '';
  }

  private async callOpenAI(model: string, apiKey: string, messages: LlmMessage[]): Promise<string> {
    return this.callOpenAICompatible('https://api.openai.com/v1/chat/completions', 'OpenAI', model, apiKey, messages);
  }

  /**
   * OpenRouter — 무료 모델은 상류 혼잡(429/overloaded)이 잦아 대체 모델 목록(models)을 함께 보낸다.
   * 첫 모델이 실패하면 OpenRouter 가 다음 모델로 자동 전환한다. 목록은 AI_MODEL_FALLBACKS(쉼표 구분).
   */
  private async callOpenRouter(model: string, apiKey: string, messages: LlmMessage[]): Promise<string> {
    const fallbacks = this.settings
      .get('AI_MODEL_FALLBACKS', OPENROUTER_DEFAULT_FALLBACKS.join(','))
      .split(',')
      .map((m) => m.trim())
      .filter((m) => m && m !== model);
    return this.callOpenAICompatible(
      'https://openrouter.ai/api/v1/chat/completions',
      'OpenRouter',
      model,
      apiKey,
      messages,
      { 'X-Title': 'EUNSUNG MES' },
      // OpenRouter 는 models 최대 3개
      fallbacks.length ? { models: [model, ...fallbacks].slice(0, 3) } : {},
    );
  }

  /** 입력 키/provider/model로 즉석 연결 확인 (키 미입력 시 저장된 키 사용) */
  async test(provider: string, model: string, apiKey?: string): Promise<{ ok: boolean; message: string }> {
    const source = apiKey?.trim() ? 'input' : 'config/.env';
    const key = apiKey?.trim() || (await this.getApiKey(provider));
    if (!key) return { ok: false, message: `API 키가 없습니다. (provider=${provider}, source=${source})` };
    const m = model || PROVIDER_DEFAULT_MODEL[provider] || 'mistral-large-latest';
    try {
      const content = await this.callProvider(provider, m, key, [{ role: 'user', content: 'Reply with: OK' }]);
      return { ok: true, message: `연결 성공 (${provider}/${m}): ${content.slice(0, 60)}` };
    } catch (error: unknown) {
      const msg = error instanceof Error ? error.message.slice(0, 160) : '연결 실패';
      return { ok: false, message: `[${provider}/${m}, key=${source}/${key.length}자] ${msg}` };
    }
  }

  /** 일반 대화 채팅 (system 프롬프트 주입) */
  async chat(messages: AiChatMessageDto[]): Promise<{ content: string }> {
    const content = await this.complete([{ role: 'system', content: SYSTEM_PROMPT }, ...messages]);
    return { content };
  }

  private hasImageAttachments(messages: LlmMessage[]): boolean {
    return messages.some((message) => (message.attachments ?? []).some((attachment) => attachment.type === 'image'));
  }

  private toOpenAICompatibleMessages(messages: LlmMessage[]): OpenAIMessage[] {
    return messages.map((message) => {
      const images = (message.attachments ?? []).filter((attachment) => attachment.type === 'image');
      if (images.length === 0) return { role: message.role, content: message.content };
      const parts: OpenAIContentPart[] = [
        { type: 'text', text: message.content || '첨부 이미지를 분석해 주세요.' },
        ...images.map((image) => ({ type: 'image_url' as const, image_url: { url: image.dataUrl } })),
      ];
      return { role: message.role, content: parts };
    });
  }
}
