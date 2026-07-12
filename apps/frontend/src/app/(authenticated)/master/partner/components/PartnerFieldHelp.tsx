"use client";

import type { ComponentProps, ReactNode } from "react";
import { useTranslation } from "react-i18next";
import { Input } from "@/components/ui";
import type { InputProps } from "@/components/ui";
import { ComCodeSelect, HelpTooltip } from "@/components/shared";

export const PARTNER_FIELD_HELP = {
  partnerCode: { db: "ICOM_SUPPLIER.SUPPLIER_CODE", description: "공급사를 식별하는 고유 코드입니다. 등록 후에는 변경할 수 없습니다." },
  partnerType: { db: "ICOM_SUPPLIER", description: "공급사 테이블을 사용하므로 SUPPLIER로 고정됩니다." },
  partnerName: { db: "ICOM_SUPPLIER.SUPPLIER_NAME", description: "공급사 이름입니다." },
  bizNo: { db: "ICOM_SUPPLIER.BUSINESS_NO", description: "사업자등록번호입니다." },
  ceoName: { db: "ICOM_SUPPLIER.OWNER_NAME", description: "대표자 이름입니다." },
  address: { db: "ICOM_SUPPLIER.ADDRESS", description: "공급사 주소입니다." },
  tel: { db: "ICOM_SUPPLIER.TEL_NO", description: "대표 전화번호입니다." },
  fax: { db: "ICOM_SUPPLIER.FAX_NO", description: "팩스번호입니다." },
  email: { db: "ICOM_SUPPLIER.EMAIL_ADDRESS", description: "대표 이메일 주소입니다." },
  contactPerson: { db: "ICOM_SUPPLIER.SUPPLIER_CHARGE_NAME", description: "연락 담당자 이름입니다." },
  remark: { db: "ICOM_SUPPLIER (미지원)", description: "ICOM_SUPPLIER에는 비고 컬럼이 없어 저장되지 않습니다." },
  useYn: { db: "ICOM_SUPPLIER.BUSINESS_STATUS", description: "A는 사용, 그 외 값은 미사용으로 표시합니다." },
} as const;

export type PartnerFieldKey = keyof typeof PARTNER_FIELD_HELP;

type FieldBaseProps = {
  field: PartnerFieldKey;
  label: string;
  required?: boolean;
  className?: string;
  children: ReactNode;
};

export function FieldLabel({ field, label, required }: Omit<FieldBaseProps, "children" | "className">) {
  const { t } = useTranslation();
  const help = PARTNER_FIELD_HELP[field];

  return (
    <label className="mb-1.5 flex items-center gap-1 text-sm font-medium text-text">
      <span>{label}</span>
      {required && <span className="text-red-500">*</span>}
      <HelpTooltip description={t(`master.partner.fieldHelp.${field}`, help.description)} db={help.db} dataField={field} />
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
  field: PartnerFieldKey;
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

type FieldComCodeSelectProps = Omit<ComponentProps<typeof ComCodeSelect>, "label"> & {
  field: PartnerFieldKey;
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

type FieldYnRadioProps = {
  field: PartnerFieldKey;
  label: string;
  value: string;
  onChange: (value: string) => void;
};

export function FieldYnRadio({ field, label, value, onChange }: FieldYnRadioProps) {
  return (
    <Field field={field} label={label}>
      <div className="flex h-[34px] items-center gap-3">
        {[
          { v: "Y", l: "Y", cls: "text-green-600 dark:text-green-400" },
          { v: "N", l: "N", cls: "text-red-500 dark:text-red-400" },
        ].map(opt => (
          <label key={opt.v} className={`flex cursor-pointer items-center gap-1.5 text-xs ${value === opt.v ? `${opt.cls} font-semibold` : "text-text-muted"}`}>
            <input
              type="radio"
              checked={value === opt.v}
              onChange={() => onChange(opt.v)}
              className="h-3.5 w-3.5 accent-primary"
            />
            {opt.l}
          </label>
        ))}
      </div>
    </Field>
  );
}
