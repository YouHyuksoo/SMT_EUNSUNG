/**
 * @file src/app.module.ts
 * @description 애플리케이션 루트 모듈 (은성전장).
 *
 * 현재는 로그인부터 살리는 단계이므로 auth 경로에 필요한 모듈만 활성화한다.
 * HANES에서 통째로 복사한 전체 모듈 구성은 `app.module.full.ts.bak`에 보존되어 있으며,
 * 화면을 하나씩 은성화하면서 아래 imports에 모듈을 되살린다.
 *
 * 초보자 가이드:
 * 1. **ConfigModule**: 환경변수 로드 (.env)
 * 2. **DatabaseModule**: TypeORM + Oracle(은성 외부) 연결 (글로벌)
 * 3. **AuthModule**: ISYS_USERS 기반 로그인
 */
import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { DatabaseModule } from './database/database.module';
import configuration from './config/configuration';

// 기능 모듈 (은성화 진행하며 하나씩 추가)
import { AuthModule } from './modules/auth/auth.module';
import { OeeModule } from './modules/oee/oee.module';
import { MenuCategoriesModule } from './modules/menu-categories/menu-categories.module';
import { SystemModule } from './modules/system/system.module';
import { MasterCodeModule } from './modules/master/master-code.module';
import { MasterCompanyModule } from './modules/master/master-company.module';
import { SharedModule } from './shared/shared.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: ['.env.local', '.env'],
      load: [configuration],
    }),

    // 데이터베이스 (글로벌) - TypeORM + Oracle(은성 외부)
    DatabaseModule,

    // 전역 공유 서비스 (TransactionService, NumberingService 등)
    SharedModule,

    // 인증 (로그인)
    AuthModule,

    // OEE (설비종합효율) — 입력·마스터
    OeeModule,

    // 메뉴 카테고리 관리 (/system/menu-categories)
    MenuCategoriesModule,

    // 시스템관리 (/system/comm-configs 통신설정, 환경설정, 활동로그, 문서, ER뷰 등)
    SystemModule,

    // 기준정보 공통코드 (/master/com-codes)
    MasterCodeModule,

    // 기준정보 회사정보 (/master/companies) — ISYS_ORGANIZATION 기반
    MasterCompanyModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
