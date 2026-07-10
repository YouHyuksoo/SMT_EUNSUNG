"use client";

import type { ReactNode } from "react";
import { useTranslation } from "react-i18next";
import { Input, Select } from "@/components/ui";
import type { InputProps, SelectProps } from "@/components/ui";
import { HelpTooltip } from "@/components/shared";

export const PROD_LINE_FIELD_HELP = {
  lineCode: { db: "IP_PRODUCT_LINE.LINE_CODE", description: "MES 내부에서 생산라인을 식별하는 고유 코드입니다. 등록 후에는 변경할 수 없습니다." },
  lineName: { db: "IP_PRODUCT_LINE.LINE_NAME", description: "현장에서 식별할 생산라인 이름입니다." },
  lineDivision: { db: "IP_PRODUCT_LINE.LINE_DIVISION", description: "SMT, 조립라인, 검사라인, 가공공정 등 라인의 성격을 구분하는 코드입니다." },
  lineCodeGroup: { db: "IP_PRODUCT_LINE.LINE_CODE_GROUP", description: "라인을 묶는 그룹 코드입니다. (예: SMD, ASM, SUB, INSP, COMMON)" },
  lineProductDivision: { db: "IP_PRODUCT_LINE.LINE_PRODUCT_DIVISION", description: "이 라인에서 생산하는 제품의 사급 구분입니다. 고정/자작/유상/무상." },
  lineStatus: { db: "IP_PRODUCT_LINE.LINE_STATUS", description: "라인의 현재 운전 상태입니다. 정상, 고장, 정지, 모델변경 등." },
  capacity: { db: "IP_PRODUCT_LINE.CAPACITY", description: "라인의 용량입니다. 단위는 용량단위 항목으로 지정합니다." },
  capacityUom: { db: "IP_PRODUCT_LINE.CAPACITY_UOM", description: "용량 값의 단위입니다. (KG 또는 ST)" },
  uphValue: { db: "IP_PRODUCT_LINE.UPH_VALUE", description: "이 라인의 시간당 생산량(UPH) 기준값입니다." },
  mesDisplayYn: { db: "IP_PRODUCT_LINE.MES_DISPLAY_YN", description: "현장 모니터링 화면(Display)에 이 라인을 노출할지 여부입니다." },
  mesDisplaySequence: { db: "IP_PRODUCT_LINE.MES_DISPLAY_SEQUENCE", description: "모니터링 화면에서의 표시 순서입니다. 작은 값이 먼저 표시됩니다." },
  activeYn: { db: "IP_PRODUCT_LINE.ACTIVE_YN", description: "라인의 가동 활성 상태입니다. Y=활성, N=대기. 마스터 사용여부가 아닙니다." },
  comments: { db: "IP_PRODUCT_LINE.COMMENTS", description: "생산라인 관리 참고사항입니다." },
} as const;

export type ProdLineFieldKey = keyof typeof PROD_LINE_FIELD_HELP;

type FieldBaseProps = {
  field: ProdLineFieldKey;
  label: string;
  required?: boolean;
  className?: string;
  children: ReactNode;
};

export function FieldLabel({ field, label, required }: Omit<FieldBaseProps, "children" | "className">) {
  const { t } = useTranslation();
  const help = PROD_LINE_FIELD_HELP[field];

  return (
    <label className="mb-1.5 flex items-center gap-1 text-sm font-medium text-text">
      <span>{label}</span>
      {required && <span className="text-red-500">*</span>}
      <HelpTooltip description={t(`master.prodLine.fieldHelp.${field}`, help.description)} db={help.db} dataField={field} />
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
  field: ProdLineFieldKey;
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
  field: ProdLineFieldKey;
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
