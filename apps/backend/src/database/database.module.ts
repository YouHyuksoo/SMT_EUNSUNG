/**
 * @file database/database.module.ts
 * @description Main Database Module - Oracle as Primary (자동 재연결 지원)
 *
 * 초보자 가이드:
 * 1. **retryAttempts**: 초기 연결 실패 시 재시도 횟수
 * 2. **poolPingInterval**: 풀 커넥션 유효성 검사 주기(초) — 끊긴 연결 자동 감지
 * 3. **connectTimeout**: 개별 연결 시 타임아웃(초) — 네트워크 지연 대응
 * 4. **expireTime**: 유휴 커넥션 만료 시간(초) — 오래된 연결 자동 정리
 */

import { Module, Global, Logger } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { SqlDebugTypeormLogger } from '../common/sql-debug/typeorm-sql-debug.logger';
import { IsysUser } from '../entities/isys-user.entity';
import { IsysOrganization } from '../entities/isys-organization.entity';
import { OeeResource } from '../entities/oee-resource.entity';
import { OeeDowntimeReason } from '../entities/oee-downtime-reason.entity';
import { OeeOperationLog } from '../entities/oee-operation-log.entity';
import { MenuCategory } from '../entities/menu-category.entity';
import { MenuCategoryItem } from '../entities/menu-category-item.entity';
import { CommConfig } from '../entities/comm-config.entity';
import { SysConfig } from '../entities/sys-config.entity';
import { ActivityLog } from '../entities/activity-log.entity';
import { TrainingPlan } from '../entities/training-plan.entity';
import { TrainingResult } from '../entities/training-result.entity';
import { DocumentMaster } from '../entities/document-master.entity';
import { PdaRole } from '../entities/pda-role.entity';
import { PdaRoleMenu } from '../entities/pda-role-menu.entity';
import { ImprRequest } from '../entities/impr-request.entity';

@Global()
@Module({
  imports: [
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => {
        const logger = new Logger('DatabaseModule');
        const host = configService.get<string>('ORACLE_HOST', 'localhost');
        const port = configService.get<number>('ORACLE_PORT', 1521);

        logger.log(`Oracle DB 연결: ${host}:${port}`);

        return {
          type: 'oracle',
          host,
          port,
          username: configService.get<string>('ORACLE_USER', 'HNSMES'),
          password: configService.get<string>('ORACLE_PASSWORD', 'your-oracle-password'),
          ...(configService.get<string>('ORACLE_SID')
            ? { sid: configService.get<string>('ORACLE_SID') }
            : { serviceName: configService.get<string>('ORACLE_SERVICE_NAME', 'JSHNSMES') }),
          synchronize: false,
          logging: ['query', 'error', 'warn'],
          logger: new SqlDebugTypeormLogger(),
          maxQueryExecutionTime: 3000,
          // 로그인 단계에서는 은성 인증 엔티티만 로드한다.
          // 화면을 은성화하며 필요한 엔티티를 이 배열에 추가한다.
          entities: [
            IsysUser,
            IsysOrganization,
            OeeResource,
            OeeDowntimeReason,
            OeeOperationLog,
            MenuCategory,
            MenuCategoryItem,
            CommConfig,
            SysConfig,
            ActivityLog,
            TrainingPlan,
            TrainingResult,
            DocumentMaster,
            PdaRole,
            PdaRoleMenu,
            ImprRequest,
          ],
          migrations: [],
          migrationsRun: false,

          // 초기 연결 재시도 — 서버 시작 시 DB가 아직 안 올라온 경우 대응
          retryAttempts: 15,
          retryDelay: 5000,

          // oracledb 연결 풀 옵션 — DB 끊김 후 자동 복구 핵심 설정
          extra: {
            poolMax: 10,
            poolMin: 2,
            poolIncrement: 1,
            poolTimeout: 60,          // 유휴 커넥션 대기 시간(초)
            queueTimeout: 30000,      // 풀 가득 찼을 때 대기 시간(ms)
            stmtCacheSize: 30,
            connectTimeout: 10,       // 개별 연결 타임아웃(초) — 네트워크 끊김 빠른 감지
            expireTime: 30,           // 유휴 커넥션 만료(초) — 끊긴 연결 자동 정리
            poolPingInterval: 10,     // 사용 전 커넥션 핑 검사 주기(초) — 죽은 연결 감지
          },
          metadataTableName: 'typeorm_metadata',
        };
      },
    }),
  ],
  exports: [TypeOrmModule],
})
export class DatabaseModule {}
