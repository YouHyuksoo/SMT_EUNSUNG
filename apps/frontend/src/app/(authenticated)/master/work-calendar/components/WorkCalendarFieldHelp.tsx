"use client";

/**
 * @file master/work-calendar/components/WorkCalendarFieldHelp.tsx
 * @description 작업달력(근무캘린더) 화면 입력 필드별 ? 도움말 정의 + Field 래퍼.
 *              품목관리(part)의 PartFieldHelp 패턴을 복제했다.
 *
 * 초보자 가이드:
 * 1. WORK_CALENDAR_FIELD_HELP: 필드키 → { db, description } 매핑. db는 실제 Oracle 컬럼.
 * 2. Field / FieldLabel: 라벨 옆에 HelpTooltip(? 아이콘)을 붙이는 래퍼.
 * 3. FieldInput: @/components/ui 의 Input 을 감싼 편의 래퍼.
 *    native <select>, <input type="time"> 등은 Field 로 감싸 children 으로 둔다.
 * 4. 대상 테이블: WORK_CALENDARS / WORK_CALENDAR_DAYS / SHIFT_PATTERNS.
 */
import type { ReactNode } from "react";
import { useTranslation } from "react-i18next";
import { Input } from "@/components/ui";
import type { InputProps } from "@/components/ui";
import { HelpTooltip } from "@/components/shared";

export const WORK_CALENDAR_FIELD_HELP = {
  // 전사 월력 (IP_PRODUCT_COMPANY_CALENDAR) / 라인 예외 (IP_PRODUCT_LINE_CALENDAR)
  dayType: { db: "IP_PRODUCT_COMPANY_CALENDAR.DAY_TYPE", description: "근무/휴무/반일/특근 구분입니다. 휴무(OFF)로 지정하면 HOLIDAY_YN이 'Y'로 함께 설정됩니다." },
  offReason: { db: "IP_PRODUCT_COMPANY_CALENDAR.OFF_REASON", description: "휴무 사유입니다. 근무유형이 휴무일 때만 입력합니다." },
  workMinutes: { db: "IP_PRODUCT_COMPANY_CALENDAR.WORK_MINUTES", description: "그날의 순근무분입니다. 비워두면 교대시간 마스터에서 자동 계산됩니다." },
  otMinutes: { db: "IP_PRODUCT_COMPANY_CALENDAR.OT_MINUTES", description: "그날의 잔업분입니다." },
  confirmYn: { db: "IP_PRODUCT_COMPANY_CALENDAR.CONFIRM_YN", description: "확정 여부입니다. 확정된 일자는 수정·생성·복사가 차단됩니다." },
  comment: { db: "IP_PRODUCT_COMPANY_CALENDAR.CALENDAR_COMMENT", description: "월력 비고입니다." },
  lineCode: { db: "IP_PRODUCT_LINE_CALENDAR.LINE_CODE", description: "라인 예외 월력의 대상 라인입니다. 해당 (일자, 라인) 행이 있으면 전사 월력을 덮어씁니다." },

  // 교대시간 (IP_SHIFT_TIME_MASTER)
  dateset: { db: "IP_SHIFT_TIME_MASTER.DATESET", description: "교대시간 적용 시작일입니다. 등록 후에는 변경할 수 없습니다." },
  dateend: { db: "IP_SHIFT_TIME_MASTER.DATEEND", description: "교대시간 적용 종료일입니다. 비우면 무기한입니다." },
  dayTimeStart: { db: "IP_SHIFT_TIME_MASTER.DAY_TIME_START", description: "주간 교대 시작 시각입니다." },
  dayTimeEnd: { db: "IP_SHIFT_TIME_MASTER.DAY_TIME_END", description: "주간 교대 종료 시각입니다." },
  dayBreakMinutes: { db: "IP_SHIFT_TIME_MASTER.DAY_BREAK_MINUTES", description: "주간 교대의 휴식시간(분)입니다. 순근무분 계산에서 차감됩니다." },
  nightTimeStart: { db: "IP_SHIFT_TIME_MASTER.NIGHT_TIME_START", description: "야간 교대 시작 시각입니다. 자정을 넘길 수 있습니다." },
  nightTimeEnd: { db: "IP_SHIFT_TIME_MASTER.NIGHT_TIME_END", description: "야간 교대 종료 시각입니다." },
  nightBreakMinutes: { db: "IP_SHIFT_TIME_MASTER.NIGHT_BREAK_MINUTES", description: "야간 교대의 휴식시간(분)입니다." },
} as const;

export type WorkCalendarFieldKey = keyof typeof WORK_CALENDAR_FIELD_HELP;

type FieldBaseProps = {
  field: WorkCalendarFieldKey;
  label: string;
  required?: boolean;
  className?: string;
  children: ReactNode;
};

export function FieldLabel({ field, label, required }: Omit<FieldBaseProps, "children" | "className">) {
  const { t } = useTranslation();
  const help = WORK_CALENDAR_FIELD_HELP[field];

  return (
    <label className="mb-1 flex items-center gap-1 text-xs font-medium text-text-muted dark:text-gray-400">
      <span>{label}</span>
      {required && <span className="text-red-500">*</span>}
      <HelpTooltip description={t(`master.workCalendar.fieldHelp.${field}`, help.description)} db={help.db} dataField={field} />
    </label>
  );
}

export function Field({ field, label, required, className = "", children }: FieldBaseProps) {
  return (
    <div className={className}>
      <FieldLabel field={field} label={label} required={required} />
      {children}
    </div>
  );
}

type FieldInputProps = Omit<InputProps, "label"> & {
  field: WorkCalendarFieldKey;
  label: string;
  wrapperClassName?: string;
};

export function FieldInput({ field, label, required, wrapperClassName, ...props }: FieldInputProps) {
  return (
    <Field field={field} label={label} required={required} className={wrapperClassName}>
      <Input {...props} required={required} fullWidth />
    </Field>
  );
}
