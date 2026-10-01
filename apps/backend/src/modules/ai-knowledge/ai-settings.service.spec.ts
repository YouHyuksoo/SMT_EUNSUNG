import * as fs from 'fs';
import * as os from 'os';
import * as path from 'path';
import { AiSettingsService } from './ai-settings.service';

describe('AiSettingsService', () => {
  let dir: string;
  let file: string;
  const prevPath = process.env.AI_ENV_PATH;

  beforeEach(() => {
    dir = fs.mkdtempSync(path.join(os.tmpdir(), 'ai-settings-'));
    file = path.join(dir, 'ai.env');
    process.env.AI_ENV_PATH = file;
  });

  afterEach(() => {
    process.env.AI_ENV_PATH = prevPath;
    fs.rmSync(dir, { recursive: true, force: true });
  });

  it('적용하면 해당 줄만 바꾸고 주석·다른 줄·CRLF 를 보존한 뒤 즉시 다시 읽는다', () => {
    fs.writeFileSync(file, '# AI 설정\r\nAI_PROVIDER=mistral\r\nOTHER=keep\r\n');
    const s = new AiSettingsService();
    s.onModuleInit();
    expect(s.get('AI_PROVIDER')).toBe('mistral');

    s.apply({ AI_PROVIDER: 'openai', AI_MODEL: 'gpt-4o-mini' });

    expect(fs.readFileSync(file, 'utf8')).toBe('# AI 설정\r\nAI_PROVIDER=openai\r\nOTHER=keep\r\nAI_MODEL=gpt-4o-mini\r\n');
    expect(s.get('AI_PROVIDER')).toBe('openai');
    expect(s.get('AI_MODEL')).toBe('gpt-4o-mini');
  });

  it('키 칸이 비어 있으면 기존 키를 유지하고, 화면 응답에는 키 값 대신 등록 여부만 준다', () => {
    fs.writeFileSync(file, 'MISTRAL_API_KEY=secret-1\n');
    const s = new AiSettingsService();
    s.onModuleInit();

    s.apply({ MISTRAL_API_KEY: '', AI_ENABLED: 'Y' });

    expect(s.get('MISTRAL_API_KEY')).toBe('secret-1');
    const snap = s.snapshot();
    expect(snap.keys.MISTRAL_API_KEY).toBe(true);
    expect(JSON.stringify(snap)).not.toContain('secret-1');
  });

  it('허용되지 않은 키·줄바꿈 값은 거절한다', () => {
    const s = new AiSettingsService();
    s.onModuleInit();
    expect(() => s.apply({ ORACLE_PASSWORD: 'x' })).toThrow();
    expect(() => s.apply({ AI_MODEL: 'a\nORACLE_PASSWORD=x' })).toThrow();
  });

  it('설정 파일이 없으면 process.env → 기본값 순으로 읽는다', () => {
    const prev = process.env.AI_MODEL;
    process.env.AI_MODEL = 'from-env';
    const s = new AiSettingsService();
    s.onModuleInit();
    expect(s.get('AI_MODEL', 'def')).toBe('from-env');
    expect(s.get('AI_EMBEDDING_MODEL', 'def')).toBe('def');
    process.env.AI_MODEL = prev;
  });
});
