"use client";

import type { ComponentProps, ReactNode } from "react";
import { useTranslation } from "react-i18next";
import { Input } from "@/components/ui";
import type { InputProps } from "@/components/ui";
import { ComCodeSelect, LineSelect, HelpTooltip } from "@/components/shared";

export const EQUIP_FIELD_HELP = {
  equipCode: { db: "IMCN_MACHINE.MACHINE_CODE", description: "MES 내부에서 설비를 식별하는 고유 코드입니다. 등록 후에는 변경할 수 없습니다." },
  equipName: { db: "IMCN_MACHINE.MACHINE_NAME", description: "현장에서 설비를 식별할 설비명입니다." },
  equipType: { db: "IMCN_MACHINE.MACHINE_TYPE", description: "은성전장 설비 유형 코드입니다." },
  commType: { db: "IMCN_MACHINE (화면 호환 필드)", description: "IMCN_MACHINE에는 별도 통신방식 컬럼이 없어 화면 호환용으로 표시합니다." },
  lineCode: { db: "IMCN_MACHINE.LINE_CODE", description: "설비가 배치된 생산 라인입니다." },
  ipAddress: { db: "IMCN_MACHINE.IP_ADDRESS", description: "TCP·MQTT 통신 시 설비에 접속할 IP 주소입니다." },
  port: { db: "IMCN_MACHINE.PORT_NO", description: "TCP·MQTT 통신 시 설비에 접속할 포트 번호입니다." },
  mqttTopic: { db: "IMCN_MACHINE (미저장)", description: "IMCN_MACHINE에는 MQTT 토픽 저장 컬럼이 없습니다." },
  serialPort: { db: "IMCN_MACHINE.SCANNER_PORT", description: "시리얼 통신 시 사용할 포트(예: COM1)입니다." },
  baudRate: { db: "IMCN_MACHINE (미저장)", description: "IMCN_MACHINE에는 통신 보율 저장 컬럼이 없습니다." },
  maker: { db: "IMCN_MACHINE.SUPPLIER_CODE", description: "설비 공급처 코드입니다." },
  modelName: { db: "IMCN_MACHINE.MACHINE_MODEL_NAME", description: "설비의 모델명입니다." },
  imageUrl: { db: "IMCN_MACHINE.MACHINE_IMAGE_FILE_NAME", description: "설비 사진 파일 경로입니다." },
} as const;

export type EquipFieldKey = keyof typeof EQUIP_FIELD_HELP;

type FieldBaseProps = {
  field: EquipFieldKey;
  label: string;
  required?: boolean;
  className?: string;
  children: ReactNode;
};

export function FieldLabel({ field, label, required }: Omit<FieldBaseProps, "children" | "className">) {
  const { t } = useTranslation();
  const help = EQUIP_FIELD_HELP[field];

  return (
    <label className="mb-1.5 flex items-center gap-1 text-sm font-medium text-text">
      <span>{label}</span>
      {required && <span className="text-red-500">*</span>}
      <HelpTooltip description={t(`master.equip.fieldHelp.${field}`, help.description)} db={help.db} dataField={field} />
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
  field: EquipFieldKey;
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
  field: EquipFieldKey;
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

type FieldLineSelectProps = Omit<ComponentProps<typeof LineSelect>, "label"> & {
  field: EquipFieldKey;
  label: string;
  wrapperClassName?: string;
};

export function FieldLineSelect({ field, label, required, wrapperClassName, ...props }: FieldLineSelectProps) {
  return (
    <Field field={field} label={label} required={required} className={wrapperClassName}>
      <LineSelect {...props} required={required} fullWidth />
    </Field>
  );
}
