/**
 * @file src/modules/ai/ai.controller.ts
 * @description AI 채팅 컨트롤러
 * - GET  /ai/status      : 활성화/provider/model/키설정여부
 * - POST /ai/chat         : 데이터 질의(text-to-SQL) 통합 — 일반대화 폴백
 * - POST /ai/execute-sql  : 쓰기 SQL 실행 요청 — 은성은 SELECT 전용이라 항상 거절
 * - GET  /ai/settings    : AI 설정(env 파일) 조회 — 키 값은 등록 여부만
 * - PUT  /ai/settings    : AI 설정 적용 — 파일을 고치고 즉시 다시 읽는다
 * - POST /ai/chat/feedback   : 응답 좋아요/싫어요 저장
 * - DELETE /ai/chat/feedback/:id : 좋아요/싫어요 취소
 */
import { Controller, Get, Post, Put, Delete, Body, Param, ParseIntPipe, BadRequestException, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { AiService } from './ai.service';
import { AiSqlService } from './ai-sql.service';
import { AiCatalogService } from './ai-catalog.service';
import { AiFeedbackService } from './ai-feedback.service';
import { EmbeddingService } from '../ai-knowledge/embedding.service';
import { AiSettingsService } from '../ai-knowledge/ai-settings.service';
import { AiChatDto, AiExecuteSqlDto, AiTestDto, AiEmbeddingTestDto, AiChatFeedbackDto } from './dto/ai-chat.dto';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';

@Controller('ai')
@UseGuards(JwtAuthGuard)
export class AiController {
  constructor(
    private readonly aiService: AiService,
    private readonly aiSqlService: AiSqlService,
    private readonly aiCatalogService: AiCatalogService,
    private readonly embeddingService: EmbeddingService,
    private readonly aiFeedbackService: AiFeedbackService,
    private readonly aiSettings: AiSettingsService,
  ) {}

  @Get('status')
  getStatus() {
    return this.aiService.getStatus();
  }

  @Get('settings')
  getSettings() {
    return this.aiSettings.snapshot();
  }

  @Put('settings')
  applySettings(@Body() body: Record<string, string>) {
    this.aiSettings.apply(body ?? {});
    return this.aiSettings.snapshot();
  }

  @Post('chat')
  chat(@Body() dto: AiChatDto, @OrganizationId() organizationId: number | undefined) {
    return this.aiSqlService.process(dto.messages, dto.knowledgeContext, organizationId);
  }

  @Post('chat/feedback')
  async createFeedback(
    @Body() dto: AiChatFeedbackDto,
    @OrganizationId() organizationId: number | undefined,
    @UserId() userId: string | undefined,
  ) {
    if (!organizationId) throw new BadRequestException('조직 정보가 없습니다.');
    return this.aiFeedbackService.create(dto, organizationId, userId ?? 'unknown');
  }

  @Delete('chat/feedback/:id')
  async deleteFeedback(@Param('id', ParseIntPipe) id: number, @OrganizationId() organizationId: number | undefined) {
    if (!organizationId) throw new BadRequestException('조직 정보가 없습니다.');
    return this.aiFeedbackService.remove(id, organizationId);
  }

  @Post('execute-sql')
  executeSql(@Body() dto: AiExecuteSqlDto) {
    return this.aiSqlService.executeApproved(dto.sql);
  }

  @Post('test')
  test(@Body() dto: AiTestDto) {
    return this.aiService.test(dto.provider, dto.model ?? '', dto.apiKey);
  }

  @Post('embedding/test')
  testEmbedding(@Body() dto: AiEmbeddingTestDto) {
    return this.embeddingService.test(dto.provider, dto.model, Number(dto.dims), dto.apiKey);
  }

  /** 테이블 카탈로그(docs/database/ai-table-catalog.md)를 실제 DB와 동기화 — 누락 테이블 추가, 사람이 쓴 설명/관계 보존.
   *  카탈로그는 docs 문서라 편집은 git/에디터로 하고, 스키마 변경 시 이 엔드포인트로 새 테이블만 채운다. */
  @Post('catalog/sync')
  syncCatalog() {
    return this.aiCatalogService.syncFromDb();
  }
}
