/**
 * @file src/modules/master/master-work-calendar.module.ts
 * @description 은성전장 생산월력(Work Calendar) API만 활성화하는 좁은 모듈.
 */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { WorkCalendar } from '../../entities/work-calendar.entity';
import { WorkCalendarDay } from '../../entities/work-calendar-day.entity';
import { ShiftPattern } from '../../entities/shift-pattern.entity';
import { ProcessMaster } from '../../entities/process-master.entity';
import { WorkCalendarController } from './controllers/work-calendar.controller';
import { WorkCalendarService } from './services/work-calendar.service';

@Module({
  imports: [TypeOrmModule.forFeature([WorkCalendar, WorkCalendarDay, ShiftPattern, ProcessMaster])],
  controllers: [WorkCalendarController],
  providers: [WorkCalendarService],
  exports: [WorkCalendarService],
})
export class MasterWorkCalendarModule {}
