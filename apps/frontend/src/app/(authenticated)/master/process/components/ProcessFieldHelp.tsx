"use client";

import { useMemo, type ComponentProps, type ReactNode } from "react";
import { useTranslation } from "react-i18next";
import { Input, Select } from "@/components/ui";
import type { InputProps, SelectProps } from "@/components/ui";
import { ComCodeSelect, HelpTooltip } from "@/components/shared";
import { useComCodeOptions } from "@/hooks/useComCode";

const T = "IP_PRODUCT_WORKSTAGE";

export const PROCESS_FIELD_HELP = {
  /* ── 기본 ── */
  processCode: { db: `${T}.WORKSTAGE_CODE`, description: "MES 내부에서 공정을 식별하는 고유 코드입니다. 등록 후에는 변경할 수 없습니다." },
  processName: { db: `${T}.WORKSTAGE_NAME`, description: "현장에서 식별할 공정명입니다." },
  processType: { db: `${T}.WORKSTAGE_TYPE`, description: "공정의 유형입니다. 일반/최종/검사 공정으로 구분하며, 최종공정은 완제품 실적 집계 기준이 됩니다." },
  sortOrder: { db: `${T}.WORKSTAGE_SORT_ORDER`, description: "공정 흐름 순서입니다. 작은 값이 먼저 표시되고 먼저 진행됩니다." },
  startYn: { db: `${T}.WORKSTAGE_START_YN`, description: "생산 흐름의 시작 공정인지 여부입니다. 시작 공정에서 투입 실적이 생성됩니다." },
  codeGroup: { db: `${T}.WORKSTAGE_CODE_GROUP`, description: "공정이 속한 큰 묶음입니다 (SMT, 후공정, 패킹, 수리실, 창고)." },
  workstageStatus: { db: `${T}.WORKSTAGE_STATUS`, description: "공정의 현재 상태 코드입니다. 작업중/정지/수리 등 현장 상황을 나타냅니다." },
  lineCode: { db: `${T}.LINE_CODE`, description: "공정이 소속된 생산 라인입니다. '*'는 라인 무관(공용 공정)을 뜻합니다." },
  departmentCode: { db: `${T}.DEPARTMENT_CODE`, description: "공정을 담당하는 부서입니다." },
  shiftCode: { db: `${T}.SHIFT_CODE`, description: "공정의 기본 교대조입니다." },
  machineCode: { db: `${T}.MACHINE_CODE`, description: "공정을 대표하는 설비입니다. 배치된 설비 목록과 별개로, 실적 집계 시 기준이 되는 대표 설비를 지정합니다." },
  costCenterCode: { db: `${T}.COST_CENTER_CODE`, description: "원가 집계 단위인 코스트센터 코드입니다." },
  mesDisplayGroup: { db: `${T}.MES_DISPLAY_GROUP`, description: "모니터링 화면에서 공정을 묶어 표시할 그룹입니다. '*'는 그룹 미지정입니다." },
  actualPlcAddress: { db: `${T}.ACTUAL_PLC_ADDRESS`, description: "실적 수집에 사용하는 PLC 주소입니다." },

  /* ── 표준시간 / 생산성 ── */
  stValue: { db: `${T}.ST_VALUE`, description: "정상 근무시간(ST)입니다." },
  otValue: { db: `${T}.OT_VALUE`, description: "초과 근무시간(OT)입니다." },
  standardQty: { db: `${T}.STANDARD_QTY`, description: "표준 생산 수량입니다." },
  uphValue: { db: `${T}.UPH_VALUE`, description: "시간당 생산량(Units Per Hour)입니다. 생산능력 계산의 기준입니다." },
  capacity: { db: `${T}.CAPACITY`, description: "공정의 생산능력입니다." },
  capacityUom: { db: `${T}.CAPACITY_UOM`, description: "생산능력의 단위입니다 (ST=수량, KG=중량)." },
  useRate: { db: `${T}.USE_RATE`, description: "공정 가동률(%)입니다." },
  waitTime: { db: `${T}.WORKSTAGE_WAIT_TIME`, description: "공정 대기 시간입니다." },
  moveTime: { db: `${T}.WORKSTAGE_MOVE_TIME`, description: "다음 공정으로의 이동 시간입니다." },
  prepareTime: { db: `${T}.WORKSTAGE_PREPARE_TIME`, description: "작업 준비(셋업) 시간입니다." },
  totalWorkTime: { db: `${T}.TOTAL_WORK_TIME`, description: "대기·이동·준비를 포함한 총 작업시간입니다." },
  workerWorkTime: { db: `${T}.WORKSTAGE_WORKER_WORK_TIME`, description: "작업자 기준 순수 작업시간입니다." },
  machineWorkTime: { db: `${T}.WORKSTAGE_MACHINE_WORK_TIME`, description: "설비 기준 순수 가동시간입니다." },
  workerQty: { db: `${T}.WORKSTAGE_WORKER_QTY`, description: "공정에 투입되는 표준 작업자 수입니다." },
  machineQty: { db: `${T}.WORKSTAGE_MACHINE_QTY`, description: "공정에 투입되는 표준 설비 대수입니다." },
  workingEfficiency: { db: `${T}.WORKING_EFFICIENCY`, description: "작업자 효율(%)입니다." },
  machineEfficiency: { db: `${T}.MACHINE_EFFICIENCY`, description: "설비 효율(%)입니다." },

  /* ── 원가율 ── */
  wageRate: { db: `${T}.WAGE_RATE`, description: "시간당 노무비 단가(임률)입니다." },
  expenseRate: { db: `${T}.EXPENSE_RATE`, description: "시간당 경비 단가(경비율)입니다." },
  machineryRate: { db: `${T}.MACHINERY_RATE`, description: "시간당 기계경비 단가입니다." },

  /* ── 불량관리 ── */
  badRateControl: { db: `${T}.BAD_RATE_CONTROL`, description: "이 공정에서 불량률을 통제할지 여부입니다. 통제함으로 설정하면 최대 허용 불량률을 초과할 때 경고합니다." },
  badMaxRate: { db: `${T}.BAD_MAX_RATE`, description: "허용 가능한 최대 불량률(%)입니다. 불량률 통제함일 때만 의미가 있습니다." },
  badQtyExtractYn: { db: `${T}.BAD_QTY_EXTRACT_YN`, description: "실적 집계 시 불량수량을 별도로 추출할지 여부입니다." },

  /* ── 기타 ── */
  genSubMfsYn: { db: `${T}.GEN_SUB_MFS_YN`, description: "공정 완료 시 하위 반제품을 자동 생성할지 여부입니다." },
  assyExpYn: { db: `${T}.ASSY_EXP_YN`, description: "원가 계산 시 조립비를 반영할지 여부입니다." },
} as const;

export type ProcessFieldKey = keyof typeof PROCESS_FIELD_HELP;

type FieldBaseProps = {
  field: ProcessFieldKey;
  label: string;
  required?: boolean;
  className?: string;
  children: ReactNode;
};

export function FieldLabel({ field, label, required }: Omit<FieldBaseProps, "children" | "className">) {
  const { t } = useTranslation();
  const help = PROCESS_FIELD_HELP[field];

  return (
    <label className="mb-1.5 flex items-center gap-1 text-sm font-medium text-text">
      <span>{label}</span>
      {required && <span className="text-red-500">*</span>}
      <HelpTooltip description={t(`master.process.fieldHelp.${field}`, help.description)} db={help.db} dataField={field} />
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
  field: ProcessFieldKey;
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

type FieldSelectProps = Omit<SelectProps, "label"> & {
  field: ProcessFieldKey;
  label: string;
  wrapperClassName?: string;
};

export function FieldSelect({ field, label, required, wrapperClassName, ...props }: FieldSelectProps) {
  return (
    <Field field={field} label={label} required={required} className={wrapperClassName}>
      <Select {...props} required={required} fullWidth />
    </Field>
  );
}

type FieldComCodeSelectProps = Omit<ComponentProps<typeof ComCodeSelect>, "label"> & {
  field: ProcessFieldKey;
  label: string;
  wrapperClassName?: string;
};

export function FieldComCodeSelect({ field, label, required, wrapperClassName, ...props }: FieldComCodeSelectProps) {
  return (
    <Field field={field} label={label} required={required} className={wrapperClassName}>
      <ComCodeSelect {...props} required={required} fullWidth />
    </Field>
  );
}

type FieldCodeSelectProps = {
  field: ProcessFieldKey;
  label: string;
  /** ISYS_BASECODE.CODE_TYPE (공백 포함 표기 그대로) */
  groupCode: string;
  value: string;
  onChange: (value: string) => void;
  required?: boolean;
  /** 코드표에는 없지만 현장에서 통용되는 관례값 (예: LINE_CODE의 '*' = 라인 무관) */
  sentinel?: { value: string; label: string };
  showCode?: boolean;
  wrapperClassName?: string;
};

/**
 * 공통코드 선택 필드.
 *
 * IP_PRODUCT_WORKSTAGE의 실데이터에는 코드표에 없는 값이 남아 있다(예: WORKSTAGE_CODE_GROUP='N').
 * 그런 값을 옵션에 포함하지 않으면 select가 첫 옵션을 대신 보여줘 **저장된 값이 조용히 바뀐 것처럼**
 * 보이므로, 현재 값은 항상 선택 가능한 옵션으로 노출한다.
 */
export function FieldCodeSelect({
  field,
  label,
  groupCode,
  value,
  onChange,
  required,
  sentinel,
  showCode,
  wrapperClassName,
}: FieldCodeSelectProps) {
  const { t } = useTranslation();
  const codes = useComCodeOptions(groupCode, false, showCode);

  const options = useMemo(() => {
    const opts = [...codes];
    if (sentinel && !opts.some((o) => o.value === sentinel.value)) {
      opts.unshift(sentinel);
    }
    if (!required) {
      opts.unshift({ value: "", label: t("common.none", { defaultValue: "지정 안 함" }) });
    }
    if (value && !opts.some((o) => o.value === value)) {
      opts.push({
        value,
        label: `${value} (${t("common.unregisteredCode", { defaultValue: "미등록 코드" })})`,
      });
    }
    return opts;
  }, [codes, sentinel, required, value, t]);

  return (
    <Field field={field} label={label} required={required} className={wrapperClassName}>
      <Select options={options} value={value} onChange={onChange} required={required} fullWidth />
    </Field>
  );
}
