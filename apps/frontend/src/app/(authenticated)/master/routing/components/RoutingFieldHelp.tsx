"use client";

import type { ReactNode } from "react";
import { useTranslation } from "react-i18next";
import { Input } from "@/components/ui";
import type { InputProps } from "@/components/ui";
import { HelpTooltip } from "@/components/shared";

export const ROUTING_FIELD_HELP = {
  routingCode: { db: "IP_ROUTING_GROUPS.ROUTING_CODE", description: "라우팅 그룹의 고유 코드입니다. 등록 후에는 변경할 수 없습니다." },
  routingName: { db: "IP_ROUTING_GROUPS.ROUTING_NAME", description: "라우팅 그룹을 목록에서 식별할 명칭입니다." },
  itemCode: { db: "IP_ROUTING_GROUPS.ITEM_CODE", description: "이 라우팅 그룹이 적용되는 상위 품목입니다. 품목마다 활성 라우팅은 하나만 둘 수 있습니다." },
  description: { db: "IP_ROUTING_GROUPS.DESCRIPTION", description: "라우팅 그룹에 대한 참고 설명입니다." },
  useYn: { db: "IP_ROUTING_GROUPS.USE_YN", description: "라우팅 그룹 또는 공정을 사용할지 지정합니다." },
  seq: { db: "IP_ROUTING_PROCESSES.PROCESS_SEQ", description: "공정 진행 순번입니다. 신규 등록 시 보통 마지막 순번에 10을 더합니다." },
  workstageCode: { db: "IP_ROUTING_PROCESSES.WORKSTAGE_CODE", description: "공정 마스터에서 선택한 공정 코드입니다. 공정명은 선택한 코드에서 표시됩니다." },
  executionType: { db: "IP_ROUTING_PROCESSES.EXECUTION_TYPE", description: "INTERNAL은 내작, SUBCON은 외주 공정입니다." },
  jobOrderYn: { db: "IP_ROUTING_PROCESSES.JOB_ORDER_YN", description: "이 공정에 생산 작업지시를 생성할지 지정합니다." },
  subconSupplierCode: { db: "IP_ROUTING_PROCESSES.SUBCON_SUPPLIER_CODE", description: "SUBCON 외주 공정의 공급처입니다. 외주일 때 필수이며 INTERNAL이면 저장하지 않습니다." },
  standardTime: { db: "IP_ROUTING_PROCESSES.STANDARD_TIME", description: "단위 작업에 필요한 표준시간입니다. 0 이상의 값을 입력합니다." },
  setupTime: { db: "IP_ROUTING_PROCESSES.SETUP_TIME", description: "공정 시작 전 준비시간입니다. 0 이상의 값을 입력합니다." },
  childItemCode: { db: "IP_ROUTING_MATERIALS.CHILD_ITEM_CODE", description: "현재 유효 BOM에서 가져온 하위 자재입니다. 라우팅 그룹 안에서 한 공정에만 배정할 수 있습니다." },
  allocQty: { db: "IP_ROUTING_MATERIALS.ALLOC_QTY", description: "선택 공정에 배정할 투입수량입니다. 0보다 커야 합니다." },
  issueMethod: { db: "IP_ROUTING_MATERIALS.ISSUE_METHOD", description: "BACKFLUSH는 실적 시 자동 차감, PRE_ISSUE는 작업 전 선투입입니다." },
} as const;

export type RoutingFieldKey = keyof typeof ROUTING_FIELD_HELP;

/**
 * 라벨 + ? 도움말 툴팁. native select·체크박스·읽기전용 표시 등
 * 다양한 입력 위젯 위에 라벨만 붙이는 경우에 사용한다.
 */
export function FieldLabel({
  field,
  label,
  required,
  className = "block text-sm font-medium text-text dark:text-gray-300 mb-1",
}: {
  field: RoutingFieldKey;
  label: string;
  required?: boolean;
  className?: string;
}) {
  const { t } = useTranslation();
  const help = ROUTING_FIELD_HELP[field];

  return (
    <label className={`flex items-center gap-1 ${className}`}>
      <span>{label}</span>
      {required && <span className="text-red-500">*</span>}
      <HelpTooltip description={t(`master.routing.fieldHelp.${field}`, help.description)} db={help.db} dataField={field} />
    </label>
  );
}

export function Field({
  field,
  label,
  required,
  className = "",
  children,
}: {
  field: RoutingFieldKey;
  label: string;
  required?: boolean;
  className?: string;
  children: ReactNode;
}) {
  return (
    <div className={className}>
      <FieldLabel field={field} label={label} required={required} />
      {children}
    </div>
  );
}

type FieldInputProps = Omit<InputProps, "label"> & {
  field: RoutingFieldKey;
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
