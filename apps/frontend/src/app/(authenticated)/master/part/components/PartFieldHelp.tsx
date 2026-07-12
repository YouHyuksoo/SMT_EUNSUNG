"use client";

import type { ComponentProps, ReactNode } from "react";
import { useTranslation } from "react-i18next";
import { Input, Select } from "@/components/ui";
import type { InputProps, SelectProps } from "@/components/ui";
import { ComCodeSelect, HelpTooltip } from "@/components/shared";

export const PART_FIELD_HELP = {
  itemCode: { db: "ID_ITEM.ITEM_CODE", description: "MES 내부에서 품목을 식별하는 고유 코드입니다." },
  itemNo: { db: "ID_ITEM.PART_NO", description: "도면, ERP, 고객 문서에서 쓰는 품번입니다." },
  itemName: { db: "ID_ITEM.ITEM_NAME", description: "현장에서 식별할 품목명입니다." },
  custPartNo: { db: "ID_ITEM.CUSTOMER_PART_NO", description: "고객사가 사용하는 품번입니다." },
  rev: { db: "ID_ITEM.ABC_GRADE", description: "품목 등급 값입니다." },
  markingText: { db: "ID_ITEM.BARCODE", description: "바코드 또는 마킹에 사용하는 값입니다." },
  itemType: { db: "ID_ITEM.ITEM_TYPE", description: "ISYS_BASECODE의 ITEM TYPE 코드입니다." },
  itemClass: { db: "ID_ITEM.ITEM_CLASS", description: "ISYS_BASECODE의 ITEM CLASS 코드입니다." },
  modelName: { db: "ID_ITEM.MODEL_NAME", description: "차량 모델 또는 차종을 구분하는 품목 관리 특성입니다." },
  modelSuffix: { db: "ID_ITEM.MODEL_SUFFIX", description: "모델 접미 구분값이며 대응 공통코드 그룹은 없습니다." },
  spec: { db: "ID_ITEM.ITEM_SPEC", description: "품목 규격, 사양, 치수 등 보조 설명입니다." },
  color: { db: "ID_ITEM.MODEL_COLOR", description: "전선색 등 품목 색상 정보입니다." },
  itemUom: { db: "ID_ITEM.ITEM_UOM", description: "ISYS_BASECODE의 ITEM UOM 코드입니다." },
  mesDisplayYn: { db: "ID_ITEM.MES_DISPLAY_YN", description: "MES 화면 표시 여부입니다." },
  boxQty: { db: "ID_ITEM.ISSUE_PACKING_QTY", description: "박스 하나에 장입하는 기준 수량입니다." },
  minPackQty: { db: "ID_ITEM.MATERIAL_QTY2", description: "자재 불출 시 최소 단위로 취급할 수량입니다." },
  lotUnitQty: { db: "ID_ITEM.MATERIAL_QTY", description: "생산 공정품을 묶음 단위로 처리할 기준 수량입니다." },
  safetyStock: { db: "ID_ITEM.SAFETY_INVENTORY", description: "재고 부족 판단에 쓰는 기준 수량입니다." },
  expiryDate: { db: "ID_ITEM.LIFE_CYCLE", description: "입고 또는 제조 기준 유효기간 일수입니다." },
  expiryExtDays: { db: "ID_ITEM.MSL_MAX_TIME", description: "품질 판단 후 유효기간을 연장할 수 있는 최대 일수입니다." },
  packUnit: { db: "ID_ITEM.CARRIER_SIZE", description: "팔레트 또는 상위 포장 단위 구성 기준입니다." },
  storageLocation: { db: "ID_ITEM.LOCATION_ADDRESS", description: "품목별 기본 적재 위치입니다." },
  imageUrl: { db: "ID_ITEM.FEEDER_LAYOUT_COMMENTS", description: "품목 이미지 경로로 사용하는 컬럼입니다." },
  remark: { db: "ID_ITEM.COMMENTS", description: "품목 관리 참고사항입니다." },
} as const;

export type PartFieldKey = keyof typeof PART_FIELD_HELP;

type FieldBaseProps = {
  field: PartFieldKey;
  label: string;
  required?: boolean;
  className?: string;
  children: ReactNode;
};

export function FieldLabel({ field, label, required }: Omit<FieldBaseProps, "children" | "className">) {
  const { t } = useTranslation();
  const help = PART_FIELD_HELP[field];

  return (
    <label className="mb-1.5 flex items-center gap-1 text-sm font-medium text-text">
      <span>{label}</span>
      {required && <span className="text-red-500">*</span>}
      <HelpTooltip description={t(`master.part.fieldHelp.${field}`, help.description)} db={help.db} dataField={field} />
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
  field: PartFieldKey;
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
  field: PartFieldKey;
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
  field: PartFieldKey;
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
  field: PartFieldKey;
  label: string;
  value: string;
  onChange: (value: string) => void;
};

export function FieldYnRadio({ field, label, value, onChange }: FieldYnRadioProps) {
  return (
    <Field field={field} label={label}>
      <div className="flex h-10 items-center gap-3">
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
