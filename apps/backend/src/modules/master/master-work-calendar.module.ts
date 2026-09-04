/**
 * @file src/modules/master/master-work-calendar.module.ts
 * @description 은성전장 생산월력(IP_ 모델) + 교대시간 API만 활성화하는 좁은 모듈.
 */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ProductCompanyCalendar } from '../../entities/product-company-calendar.entity';
import { ProductLineCalendar } from '../../entities/product-line-calendar.entity';
import { ProductCalendarShift } from '../../entities/product-calendar-shift.entity';
import { ProductCalendarBreak } from '../../entities/product-calendar-break.entity';
import { ShiftTimeMaster } from '../../entities/shift-time-master.entity';
import { ShiftTimeBreak } from '../../entities/shift-time-break.entity';
import { WorkCalendarController } from './controllers/work-calendar.controller';
import { ShiftTimeController } from './controllers/shift-time.controller';
import { WorkCalendarService } from './services/work-calendar.service';
import { ShiftTimeService } from './services/shift-time.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      ProductCompanyCalendar,
      ProductLineCalendar,
      ProductCalendarShift,
      ProductCalendarBreak,
      ShiftTimeMaster,
      ShiftTimeBreak,
    ]),
  ],
  controllers: [WorkCalendarController, ShiftTimeController],
  providers: [WorkCalendarService, ShiftTimeService],
  exports: [WorkCalendarService, ShiftTimeService],
})
export class MasterWorkCalendarModule {}
