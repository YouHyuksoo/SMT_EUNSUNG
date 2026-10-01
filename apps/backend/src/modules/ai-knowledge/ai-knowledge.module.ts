/**
 * @file src/modules/ai-knowledge/ai-knowledge.module.ts
 * @description SQLite/sqlite-vec 기반 AI 문서 지식 검색 모듈.
 */
import { Module } from '@nestjs/common';
import { AiKnowledgeController } from './ai-knowledge.controller';
import { AiKnowledgeService } from './ai-knowledge.service';
import { EmbeddingService } from './embedding.service';
import { AiSettingsService } from './ai-settings.service';

@Module({
  controllers: [AiKnowledgeController],
  providers: [AiKnowledgeService, EmbeddingService, AiSettingsService],
  exports: [AiKnowledgeService, EmbeddingService, AiSettingsService],
})
export class AiKnowledgeModule {}
