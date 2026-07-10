/**
 * @file src/modules/ai/ai-sql.service.ts
 * @description text-to-SQL 파이프라인 (2단계: MES 데이터 질의)
 *
 * 흐름: 테이블 선택(LLM) → SQL 생성(LLM) → 검증 → SELECT 실행+분석 / INSERT·UPDATE 승인대기
 * LLM 호출은 AiService.complete(Mistral)를 재사용한다.
 */
import { Injectable, BadRequestException, Logger } from '@nestjs/common';
import { InjectDataSource } from '@nestjs/typeorm';
import { DataSource } from 'typeorm';
import { AiService } from './ai.service';
import { AiCatalogService } from './ai-catalog.service';
import { SchemaInfoService } from './schema-info.service';
import { SqlValidatorService } from './sql-validator.service';
import { AiChatMessageDto, AiKnowledgeContextDto } from './dto/ai-chat.dto';
import { AiKnowledgeService, KnowledgeSearchResult } from '../ai-knowledge/ai-knowledge.service';
import { KnowledgeIntent, KnowledgePipelineService } from './knowledge-pipeline.service';

export interface AiKnowledgeSourceSummary {
  chunkId: string;
  sourcePath: string;
  menuCode?: string;
  audience?: string;
  title?: string;
  heading?: string;
  score: number;
}

export interface AiSqlResult {
  content: string;
  sql?: string;
  executed?: boolean;
  rowCount?: number;
  requiresApproval?: boolean;
  /** 답변 근거로 사용한 RAG 지식 청크 요약 (검색 결과가 있을 때만) */
  sources?: AiKnowledgeSourceSummary[];
}

type AiChatRouteMode = 'auto' | 'mes' | 'help' | 'do' | 'web';

const TABLE_SELECT_PROMPT = `당신은 HANES MES 데이터베이스에서 사용자 질문에 답할 테이블을 고르는 도우미입니다.
규칙:
1. 아래 테이블 목록에서 질문에 답하는 데 필요한 테이블을 고릅니다(최대 6개).
2. 회사·거래처·인물(대표/담당자/작업자/검사자)·품목·생산·재고·출하·품질·설비 등 MES에 저장된 정보를 묻는 질문이면, 일반 상식으로 답할 수 있어 보여도 반드시 관련 테이블을 선택하세요. (예: 사람 이름으로 소속·대표 여부를 묻는 질문은 회사·거래처 마스터의 대표자명 등으로 조회)
3. 같은 성격의 정보가 여러 테이블에 나뉘어 있을 수 있으면(예: 자사 정보와 거래처 정보, 자재와 제품) 코멘트를 보고 후보 테이블을 모두 선택하세요. 단어 하나(예: "회사")만 보고 한 테이블로 단정하지 마세요.
4. 인사·잡담 등 데이터와 전혀 무관한 경우에만 빈 배열 []을 응답합니다.
5. 반드시 JSON 배열로만 응답합니다. 예: ["PARTNER_MASTERS","COMPANY_MASTERS"]
다른 설명 없이 JSON 배열만 출력하세요.`;

const SQL_GEN_PROMPT = `당신은 Oracle SQL 생성 AI입니다.
규칙:
- 반드시 아래 '테이블 스키마'에 제시된 테이블·컬럼만 사용하세요. 목록에 없는 테이블/뷰/컬럼을 추측하거나 만들어내지 마세요. 필요한 데이터가 스키마에 없으면 NO_SQL로 응답하세요.
- Oracle 문법. 식별자는 대문자(따옴표 없이).
- 멀티테넌시 필터는 메인(FROM) 테이블에만 한 번 적용: WHERE <메인별칭>.COMPANY='40' AND <메인별칭>.PLANT_CD='1000'.
  JOIN된 테이블에는 동일 조건을 중복으로 넣지 마세요. JOIN ON 절에서 COMPANY/PLANT_CD를 연결했다면 그것으로 충분합니다.
- 컬럼 의미는 각 컬럼 뒤 주석(-- 설명)으로 판단하고, 질문 속 단어를 의미가 맞는 컬럼에 매핑하세요.
  (예: "대표/사장"은 대표자명 컬럼, "회사/업체/거래처"는 회사명·거래처명 컬럼) 조건 컬럼을 임의로 고르지 마세요.
- JOIN이 필요하면 '테이블 관계(JOIN 키)' 섹션에 제시된 키로 연결하세요. 관계 섹션에 없는 임의 컬럼으로 JOIN을 추측하지 마세요.
- 이름·명칭 등 텍스트 검색은 정확일치(=) 대신 LIKE '%값%'를 사용하세요.
- 검색값에서 한국어 조사(은/는/이/가/을/를/에/의/와/과/도)를 제거하고 핵심 단어만 사용하세요. 예: "정의선이" → "정의선".
- 조회는 SELECT. 등록은 INSERT, 수정은 UPDATE(UPDATE는 WHERE 필수). DELETE/DDL 절대 금지.
- 단일 쿼리만. 세미콜론으로 여러 쿼리를 연결하지 마세요.
- 데이터 작업이 불필요한 일반 대화면 "NO_SQL"만 응답.
- SQL만 출력(코드블록·설명 없이). 또는 "NO_SQL".`;

const ANALYSIS_PROMPT = `당신은 HANES MES 데이터 분석 AI입니다. 한국어 마크다운으로 답합니다.
규칙:
- 반드시 실행 SQL 결과(JSON)와 참고 문서에 있는 내용만 사용하세요. 모델이 학습한 일반 지식으로 절차, 규칙, 원인, API, 상태값을 보태지 마세요.
- 결과와 참고 문서에 없는 내용은 "제공된 출처에서는 확인되지 않습니다"라고 답하세요.
- 질문에 바로 답한 뒤, 조회 조건과 확인한 데이터를 기준으로 설명하세요.
- 결과가 있으면 핵심 요약, 조회 조건, 확인한 데이터, 판단 근거, 추가 확인 순서로 정리하세요.
- 데이터는 필요한 경우 마크다운 표로 정리하되, 표만 던지지 말고 사용자가 어떻게 해석해야 하는지 설명하세요.
- 결과가 0건이면 "조회 결과가 없습니다"라고 답하고, 확인한 조회 조건과 사용자가 다시 확인할 만한 조건을 짧게 덧붙이세요.
- 결과에 없는 데이터를 지어내지 마세요.`;

const GENERAL_PROMPT =
  '당신은 HANES MES(제조실행시스템) 운영을 돕는 AI 비서입니다. 한국어로 정확하고 실무자가 바로 판단할 수 있게 답합니다. ' +
  '반드시 제공된 도움말/문서 출처에 있는 내용만 사용하세요. 출처에 없는 절차, 규칙, API, 상태값, 원인을 모델 지식으로 보태면 안 됩니다. ' +
  '출처에서 확인되지 않는 내용은 "제공된 출처에서는 확인되지 않습니다"라고 답하세요. ' +
  '질문에 바로 답한 뒤, 필요한 경우 확인한 근거, 업무 영향, 다음 확인 항목을 함께 제시하세요. ' +
  '단순한 한 줄 답변으로 끝내지 말고 어떤 기준으로 판단했는지 설명하세요. ' +
  '회사·거래처·인물·품목·생산·재고 등 MES에 있을 법한 정보는 학습된 일반 지식으로 추측해 답하지 마세요. ' +
  'MES 데이터로 확인이 필요한 질문이면 "MES 데이터에서 확인이 필요합니다"라고 안내하세요.';

const NO_KNOWLEDGE_RESPONSE =
  '도움말/문서 출처를 찾지 못했습니다. 현재 설정에서는 출처 없는 LLM 일반지식 답변을 생성하지 않습니다. 관련 도움말을 추가하거나 임베딩 재생성을 실행한 뒤 다시 질문해 주세요.';

@Injectable()
export class AiSqlService {
  private readonly logger = new Logger(AiSqlService.name);

  constructor(
    private readonly aiService: AiService,
    private readonly catalog: AiCatalogService,
    private readonly schemaInfo: SchemaInfoService,
    private readonly validator: SqlValidatorService,
    private readonly knowledge: AiKnowledgeService,
    private readonly knowledgePipeline: KnowledgePipelineService,
    @InjectDataSource() private readonly dataSource: DataSource,
  ) {}

  async process(
    messages: AiChatMessageDto[],
    knowledgeContext?: AiKnowledgeContextDto,
  ): Promise<AiSqlResult> {
    const rawUserMessage = [...messages].reverse().find((m) => m.role === 'user')?.content ?? '';
    const route = this.parseRouteMode(rawUserMessage);
    const userMessage = route.message;
    if (!userMessage.trim()) return { content: '질문을 입력해 주세요.' };
    if (route.mode === 'web') {
      return {
        content:
          '/WEB 외부 웹 검색은 현재 HANES 백엔드 AI 채팅 파이프라인에 연결되어 있지 않습니다. MES 데이터는 /MES, 화면 도움말은 /HELP로 질문해 주세요.',
      };
    }

    let knowledgePrompt = '';
    let knowledgeChunks: KnowledgeSearchResult[] = [];
    let knowledgeIntent: KnowledgeIntent = 'usage';
    try {
      const pipelineResult = await this.knowledgePipeline.retrieve(userMessage, knowledgeContext);
      knowledgePrompt = pipelineResult.prompt;
      knowledgeChunks = pipelineResult.chunks;
      knowledgeIntent = pipelineResult.intent;
    } catch (error: unknown) {
      this.logger.warn(`지식 파이프라인 실패, 단일 검색 폴백: ${error instanceof Error ? error.message : String(error)}`);
      try {
        knowledgeChunks = await this.knowledge.search(userMessage, knowledgeContext, 5);
        knowledgePrompt = this.knowledge.formatContext(knowledgeChunks);
      } catch (fallbackError: unknown) {
        this.logger.warn(`AI 지식 검색 실패: ${fallbackError instanceof Error ? fallbackError.message : String(fallbackError)}`);
      }
    }

    const effectiveMessages = this.replaceLastUserMessage(messages, userMessage);
    const result = await this.processWithKnowledge(
      userMessage,
      effectiveMessages,
      knowledgePrompt,
      knowledgeContext,
      knowledgeIntent,
      route.mode,
    );
    return this.withSources(result, knowledgeChunks);
  }

  /** 검색된 지식 청크를 응답의 sources 필드로 병합(청크가 없으면 그대로 반환) */
  private withSources(result: AiSqlResult, chunks: KnowledgeSearchResult[]): AiSqlResult {
    if (chunks.length === 0) return result;
    return {
      ...result,
      sources: chunks.map((chunk) => ({
        chunkId: chunk.chunkId,
        sourcePath: chunk.sourcePath,
        menuCode: chunk.menuCode,
        audience: chunk.audience,
        title: chunk.title,
        heading: chunk.heading,
        score: chunk.score,
      })),
    };
  }

  /** 기존 process()의 테이블선택→SQL생성→실행/일반대화 분기 로직(변경 없음, knowledgePrompt를 인자로 받도록만 조정) */
  private async processWithKnowledge(
    userMessage: string,
    messages: AiChatMessageDto[],
    knowledgePrompt: string,
    knowledgeContext?: AiKnowledgeContextDto,
    knowledgeIntent: KnowledgeIntent = 'usage',
    routeMode: AiChatRouteMode = 'auto',
  ): Promise<AiSqlResult> {
    if (routeMode === 'help') {
      return this.generalChat(messages, knowledgePrompt, knowledgeContext, knowledgeIntent);
    }

    // [1단계] 관련 테이블 선택 (없으면 일반 대화)
    const tables = await this.selectTables(userMessage);
    if (tables.length === 0) return this.generalChat(messages, knowledgePrompt, knowledgeContext, knowledgeIntent);

    // [2단계] SQL 생성 (스키마 + 카탈로그 관계(JOIN 키) 주입)
    const schemaText = await this.schemaInfo.getSchemaText(tables);
    const relations = await this.catalog.getRelationsText(tables);
    const rawSql = await this.generateSql(userMessage, relations ? `${schemaText}\n\n${relations}` : schemaText);
    if (!rawSql) return this.generalChat(messages, knowledgePrompt, knowledgeContext, knowledgeIntent);

    // [검증]
    const v = this.validator.validate(rawSql);
    const sql = this.validator.stripFences(rawSql);
    if (!v.valid) {
      return { content: `생성된 SQL이 보안 정책에 위배됩니다: ${v.error}`, sql };
    }

    // 쓰기: 승인 대기 (실행하지 않음)
    if (v.kind === 'write') {
      return {
        content: '아래 데이터 변경 작업을 검토하고, 실행하려면 승인해 주세요.',
        sql,
        requiresApproval: true,
      };
    }

    // 조회: 즉시 실행 + 분석
    try {
      const rows = await this.runSelect(sql);
      const analysis = await this.analyze(userMessage, sql, rows, knowledgePrompt, knowledgeContext, knowledgeIntent);
      return { content: analysis, sql, executed: true, rowCount: rows.length };
    } catch (error: unknown) {
      this.logger.error(
        `SELECT 실행 실패: ${error instanceof Error ? error.message : String(error)}`,
      );
      return {
        content: `조회 실행 중 오류가 발생했습니다: ${error instanceof Error ? error.message : '알 수 없음'}`,
        sql,
      };
    }
  }

  /** 승인된 INSERT/UPDATE 실행 (재검증 필수) */
  async executeApproved(rawSql: string): Promise<AiSqlResult> {
    const v = this.validator.validate(rawSql);
    if (!v.valid) throw new BadRequestException(`SQL 검증 실패: ${v.error}`);
    if (v.kind !== 'write') {
      throw new BadRequestException('승인 실행은 INSERT/UPDATE 문만 가능합니다.');
    }
    const sql = this.validator.stripFences(rawSql);
    try {
      const result = await this.dataSource.query(sql);
      const affected = Array.isArray(result) ? result.length : (result?.affectedRows ?? 0);
      return { content: `실행이 완료되었습니다. (영향받은 행: ${affected})`, sql, executed: true };
    } catch (error: unknown) {
      this.logger.error(
        `승인 SQL 실행 실패: ${error instanceof Error ? error.message : String(error)}`,
      );
      throw new BadRequestException(
        `실행 중 오류가 발생했습니다: ${error instanceof Error ? error.message : '알 수 없음'}`,
      );
    }
  }

  private async selectTables(userMessage: string): Promise<string[]> {
    // 카탈로그 파일(큐레이션) 우선, 없으면 DB 폴백
    const { catalog, tables } =
      (await this.catalog.getSelectionCatalog()) ?? (await this.schemaInfo.getSelectionCatalog());
    const res = await this.aiService.complete([
      { role: 'system', content: TABLE_SELECT_PROMPT },
      { role: 'user', content: `## 테이블 카탈로그 (형식: 테이블명: 설명)\n${catalog}\n\n## 질문\n${userMessage}` },
    ]);
    const valid = new Set(tables.map((t) => t.toUpperCase()));
    try {
      const start = res.indexOf('[');
      const end = res.lastIndexOf(']');
      if (start === -1 || end === -1) return [];
      const arr = JSON.parse(res.slice(start, end + 1)) as unknown[];
      if (!Array.isArray(arr)) return [];
      return arr
        .map((t) => String(t).toUpperCase())
        .filter((t) => valid.has(t))
        .slice(0, 6);
    } catch {
      return [];
    }
  }

  private async generateSql(userMessage: string, schemaText: string): Promise<string | null> {
    const res = await this.aiService.complete([
      { role: 'system', content: SQL_GEN_PROMPT },
      {
        role: 'user',
        content: `## 테이블 스키마\n${schemaText}\n\n## 질문\n${userMessage}\n\nOracle SQL 한 개를 생성하세요. 데이터 작업이 불필요하면 NO_SQL.`,
      },
    ]);
    const trimmed = res.trim();
    if (!trimmed || /^NO_SQL/i.test(this.validator.stripFences(trimmed))) return null;
    return trimmed;
  }

  private async runSelect(sql: string): Promise<Record<string, unknown>[]> {
    const base = sql.replace(/;\s*$/, '');
    const limited = /\bROWNUM\b|\bFETCH\s+FIRST\b/i.test(base)
      ? base
      : `SELECT * FROM (${base}) WHERE ROWNUM <= 100`;
    return this.dataSource.query(limited);
  }

  private parseRouteMode(rawMessage: string): { mode: AiChatRouteMode; message: string } {
    const trimmed = rawMessage.trim();
    const match = /^\/(MES|HELP|DO|WEB)\b\s*/i.exec(trimmed);
    if (!match) return { mode: 'auto', message: rawMessage };
    const mode = match[1].toLowerCase() as AiChatRouteMode;
    return { mode, message: trimmed.slice(match[0].length).trim() };
  }

  private replaceLastUserMessage(messages: AiChatMessageDto[], content: string): AiChatMessageDto[] {
    const lastUserIndex = messages.map((m) => m.role).lastIndexOf('user');
    if (lastUserIndex === -1) return messages;
    return messages.map((message, index) => (index === lastUserIndex ? { ...message, content } : message));
  }

  private async analyze(
    userMessage: string,
    sql: string,
    rows: Record<string, unknown>[],
    knowledgePrompt = '',
    knowledgeContext?: AiKnowledgeContextDto,
    knowledgeIntent: KnowledgeIntent = 'usage',
  ): Promise<string> {
    const json = JSON.stringify(rows).slice(0, 9000);
    return this.aiService.complete([
      {
        role: 'system',
        content: [ANALYSIS_PROMPT, this.formatPersonaPrompt(knowledgeContext), this.formatIntentPrompt(knowledgeIntent)]
          .filter(Boolean)
          .join('\n\n'),
      },
      {
        role: 'user',
        content: `${knowledgePrompt ? `## 참고 문서\n${knowledgePrompt}\n\n` : ''}## 질문\n${userMessage}\n\n## 실행 SQL\n${sql}\n\n## 결과 행 수: ${rows.length}\n\n## 결과(JSON, 최대 100행)\n${json}\n\n위 결과를 분석해 한국어 마크다운으로 답하세요. 문서를 참고했다면 마지막에 근거를 짧게 표시하세요.`,
      },
    ]);
  }

  private async generalChat(
    messages: AiChatMessageDto[],
    knowledgePrompt = '',
    knowledgeContext?: AiKnowledgeContextDto,
    knowledgeIntent: KnowledgeIntent = 'usage',
  ): Promise<AiSqlResult> {
    if (!knowledgePrompt.trim()) {
      return { content: NO_KNOWLEDGE_RESPONSE };
    }
    const personaPrompt = this.formatPersonaPrompt(knowledgeContext);
    const knowledgeSystem = knowledgePrompt
      ? `아래 참고 문서만 답변 근거로 사용할 수 있습니다. 선택된 페르소나에 맞는 출처를 먼저 반영하고, 다른 문서는 보조 근거로 사용하세요. 참고 문서에 없는 내용은 절대 추가하지 말고 "제공된 출처에서는 확인되지 않습니다"라고 답하세요. 참고한 문서가 있으면 확인한 근거로 표시하세요.\n\n## 참고 문서\n${knowledgePrompt}`
      : '';
    const systemParts = [GENERAL_PROMPT, personaPrompt, this.formatIntentPrompt(knowledgeIntent), knowledgeSystem]
      .filter(Boolean)
      .join('\n\n');
    const content = await this.aiService.complete([
      { role: 'system', content: systemParts },
      ...messages,
    ]);
    return { content };
  }

  /** 검색 파이프라인이 분류한 질문 의도별 답변 지침 (근거 섹션을 어떤 순서/관점으로 활용할지 지시) */
  private formatIntentPrompt(intent: KnowledgeIntent): string {
    switch (intent) {
      case 'workflow':
        return '이 질문은 업무 흐름(전후관계) 질문입니다. "워크플로우 전후 단계" 섹션을 근거로 선행 단계 → 현재 단계 → 후행 단계 순서로 답하고, 각 단계의 메뉴 이름을 명시하세요.';
      case 'troubleshoot':
        return '이 질문은 문제 해결 질문입니다. "문제 해결" 섹션과 문서 근거로 증상 → 원인 후보 → 확인/조치 순서로 답하세요. 선행 조건 미충족 가능성을 우선 확인하세요.';
      case 'engineer':
        return '이 질문은 기술 구조 질문입니다. 비즈니스 로직 문서를 근거로 테이블/API/상태 전이를 중심으로 답하세요.';
      default:
        return '';
    }
  }

  private formatPersonaPrompt(knowledgeContext?: AiKnowledgeContextDto): string {
    switch (knowledgeContext?.persona) {
      case 'operator':
        return '현재 페르소나: 운영관리자. 운영자 도움말과 운영 절차를 우선하고, 취소/복원/인터록/장애 조치와 업무 영향을 분명히 설명하세요.';
      case 'engineer':
        return '현재 페르소나: 시스템엔지니어. 비즈니스 로직, API, 서비스 메서드, DB 테이블, 트랜잭션 흐름을 근거 중심으로 설명하세요.';
      default:
        return '현재 페르소나: 일반사용자. 사용자 도움말을 우선하고, 화면 사용 순서와 처리 전 확인사항을 쉬운 업무 용어로 설명하세요.';
    }
  }
}
