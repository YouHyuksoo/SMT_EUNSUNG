jest.mock('@mistralai/mistralai', () => ({ Mistral: jest.fn() }));

import { BadRequestException } from '@nestjs/common';
import { AiService } from './ai.service';

describe('AiService multimodal chat payloads', () => {
  const createService = (values: Record<string, string>) => {
    // AI 설정은 ai-settings.service(env 파일) 에서 온다 — get(key, def) 만 흉내낸다
    const settings = { get: (key: string, def = "") => values[key] ?? def };
    return new AiService(settings as any);
  };

  beforeEach(() => {
    jest.restoreAllMocks();
  });

  it('OpenAI-compatible providers send image attachments as chat content parts', async () => {
    const fetchMock = jest.spyOn(globalThis, 'fetch' as any).mockResolvedValue({
      ok: true,
      json: async () => ({ choices: [{ message: { content: '이미지 분석 결과' } }] }),
    } as any);
    const service = createService({
      AI_ENABLED: 'Y',
      AI_PROVIDER: 'openai',
      AI_MODEL: 'gpt-4o-mini',
      OPENAI_API_KEY: 'test-key',
    });

    const result = await service.complete([
      { role: 'user', content: '이 이미지를 분석해줘', attachments: [{ type: 'image', name: 'part.png', mimeType: 'image/png', dataUrl: 'data:image/png;base64,AAAA' }] },
    ]);

    expect(result).toBe('이미지 분석 결과');
    const requestInit = fetchMock.mock.calls[0][1] as RequestInit;
    const body = JSON.parse(String(requestInit.body));
    expect(body.messages[0].content).toEqual([
      { type: 'text', text: '이 이미지를 분석해줘' },
      { type: 'image_url', image_url: { url: 'data:image/png;base64,AAAA' } },
    ]);
  });

  it('Mistral provider rejects image attachments with a clear message', async () => {
    const service = createService({
      AI_ENABLED: 'Y',
      AI_PROVIDER: 'mistral',
      AI_MODEL: 'mistral-large-latest',
      MISTRAL_API_KEY: 'test-key',
    });

    await expect(
      service.complete([
        { role: 'user', content: '이미지 분석', attachments: [{ type: 'image', name: 'part.png', mimeType: 'image/png', dataUrl: 'data:image/png;base64,AAAA' }] },
      ]),
    ).rejects.toThrow(BadRequestException);
  });
});
