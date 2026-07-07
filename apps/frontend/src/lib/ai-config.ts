import fs from 'fs/promises';
import path from 'path';

export interface ProviderSetting {
  providerId: string;
  enabled: boolean;
  apiKey: string | null;
  defaultModelId: string | null;
  sqlSystemPrompt: string | null;
  analysisPrompt: string | null;
}

export interface PersonaSetting {
  personaId: string;
  name: string;
  description: string | null;
  icon: string | null;
  systemPrompt: string;
  isDefault: boolean;
  isActive: boolean;
  sortOrder: number;
}

export interface AiConfig {
  providers: ProviderSetting[];
  personas: PersonaSetting[];
}

const DEFAULT_CONFIG: AiConfig = {
  providers: [
    { providerId: 'claude', enabled: false, apiKey: null, defaultModelId: 'claude-opus-4-6', sqlSystemPrompt: null, analysisPrompt: null },
    { providerId: 'gemini', enabled: false, apiKey: null, defaultModelId: 'gemini-2.0-flash', sqlSystemPrompt: null, analysisPrompt: null },
    { providerId: 'mistral', enabled: false, apiKey: null, defaultModelId: 'mistral-large-latest', sqlSystemPrompt: null, analysisPrompt: null },
    { providerId: 'kimi', enabled: false, apiKey: null, defaultModelId: 'kimi-k2-0905-preview', sqlSystemPrompt: null, analysisPrompt: null },
  ],
  personas: [
    {
      personaId: 'p_default',
      name: 'MES Analyst',
      description: 'Summarizes and interprets MES data objectively.',
      icon: 'BarChart3',
      systemPrompt: 'You are an MES data analyst. Summarize results objectively around charts and numeric trends. Highlight outliers without emotional wording, and explain with numbers and ratios.',
      isDefault: true,
      isActive: true,
      sortOrder: 0,
    },
    {
      personaId: 'p_manager',
      name: 'Line Manager',
      description: 'Provides direct operational insights for decisions.',
      icon: 'ClipboardCheck',
      systemPrompt: 'You are an assistant for line managers. End each answer with 1 to 3 action suggestions. Use concise field-oriented language.',
      isDefault: false,
      isActive: true,
      sortOrder: 1,
    },
    {
      personaId: 'p_quality',
      name: 'Quality Engineer',
      description: 'Focuses on FPY and quality trend signals.',
      icon: 'ShieldCheck',
      systemPrompt: 'Answer from a quality engineering perspective. Prioritize FPY warning signals, and focus on statistical significance and time trends.',
      isDefault: false,
      isActive: true,
      sortOrder: 2,
    },
  ],
};

const CONFIG_PATH = path.join(process.cwd(), 'data', 'ai-config.json');

export async function getAiConfig(): Promise<AiConfig> {
  try {
    const raw = await fs.readFile(CONFIG_PATH, 'utf-8');
    const parsed = JSON.parse(raw) as Partial<AiConfig>;
    return {
      providers: parsed.providers ?? DEFAULT_CONFIG.providers,
      personas: parsed.personas ?? DEFAULT_CONFIG.personas,
    };
  } catch {
    return structuredClone(DEFAULT_CONFIG);
  }
}

export async function saveAiConfig(config: AiConfig): Promise<void> {
  const dir = path.dirname(CONFIG_PATH);
  await fs.mkdir(dir, { recursive: true });
  await fs.writeFile(CONFIG_PATH, JSON.stringify(config, null, 2), 'utf-8');
}
