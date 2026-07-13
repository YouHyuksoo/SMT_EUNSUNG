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
import { OracleModule } from './common/modules/oracle.module';
import configuration from './config/configuration';

// 기능 모듈 (은성화 진행하며 하나씩 추가)
import { AuthModule } from './modules/auth/auth.module';
import { OeeModule } from './modules/oee/oee.module';
import { MenuCategoriesModule } from './modules/menu-categories/menu-categories.module';
import { SystemModule } from './modules/system/system.module';
import { SchedulerModule } from './modules/scheduler/scheduler.module';
import { UserModule } from './modules/user/user.module';
import { MasterCodeModule } from './modules/master/master-code.module';
import { MasterCompanyModule } from './modules/master/master-company.module';
import { MasterDepartmentModule } from './modules/master/master-department.module';
import { MasterPartModule } from './modules/master/master-part.module';
import { MasterEquipModule } from './modules/master/master-equip.module';
import { MasterBomModule } from './modules/master/master-bom.module';
import { MasterPartnerModule } from './modules/master/master-partner.module';
import { MasterProdLineModule } from './modules/master/master-prod-line.module';
import { MasterWorkerModule } from './modules/master/master-worker.module';
import { MasterWorkInstructionModule } from './modules/master/master-work-instruction.module';
import { MasterWorkCalendarModule } from './modules/master/master-work-calendar.module';
import { MasterLabelModule } from './modules/master/master-label.module';
import { MasterProcessCapaModule } from './modules/master/master-process-capa.module';
import { MasterProcessModule } from './modules/master/master-process.module';
import { MasterRoutingModule } from './modules/master/master-routing.module';
import { MasterRoutingGroupModule } from './modules/master/master-routing-group.module';
import { DashboardModule } from './modules/dashboard/dashboard.module';
import { AttachmentModule } from './modules/attachment/attachment.module';
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

    // OracleService (패키지/프로시저 실행 등 raw Oracle 헬퍼)
    OracleModule,

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

    // 시스템 스케줄러 (/scheduler/jobs, /scheduler/logs)
    SchedulerModule,

    // 사용자 관리 (/users) — ISYS_USERS 기반
    UserModule,

    // 기준정보 공통코드 (/master/com-codes)
    MasterCodeModule,

    // 기준정보 회사정보 (/master/companies) — ISYS_ORGANIZATION 기반
    MasterCompanyModule,

    // 시스템 부서정보 (/system/departments) — ISYS_DEPARTMENT 기반
    MasterDepartmentModule,

    // 기준정보 품목정보 (/master/parts) — ID_ITEM 기반
    MasterPartModule,

    // 기준정보 설비정보 (/equipment/equips) — IMCN_MACHINE 기반
    MasterEquipModule,

    // 기준정보 BOM (/master/boms) — ID_ENG_BOM 기반
    MasterBomModule,

    // 기준정보 거래처정보 (/master/partners)
    MasterPartnerModule,

    // 기준정보 생산라인정보 (/master/prod-lines)
    MasterProdLineModule,

    // 기준정보 작업자정보 (/master/workers)
    MasterWorkerModule,

    // 기준정보 작업지도서 (/master/work-instructions)
    MasterWorkInstructionModule,

    // 기준정보 생산월력 (/master/work-calendars)
    MasterWorkCalendarModule,

    // 기준정보 라벨 템플릿 (/master/label-templates)
    MasterLabelModule,

    // 기준정보 공정 CAPA (/master/process-capas)
    MasterProcessCapaModule,

    // 기준정보 공정마스터 (/master/processes)
    MasterProcessModule,

    // 기준정보 공정라우팅 (/master/routings)
    MasterRoutingModule,

    // 기준정보 라우팅 그룹 (/master/routing-groups)
    MasterRoutingGroupModule,

    // 대시보드 (/dashboard/summary)
    DashboardModule,
    AttachmentModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
