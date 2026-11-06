/**
 * @file src/app/(authenticated)/master/part/components/PartFormPanel.tsx
 * @description 품목 추가/수정 오른쪽 패널 — ID_ITEM 109개 컬럼 전부.
 *
 * 초보자 가이드:
 * 1. **칸은 컬럼 목록(@smt/shared ITEM_MASTER_COLUMNS)으로 그린다.** 구역(기본정보·분류·구매 …)도
 *    목록에 적혀 있다. 컬럼을 늘리면 목록만 고치면 된다.
 * 2. **키(품목코드)는 수정 때 잠긴다.** 조직·등록/수정 이력·라우팅번호는 표시만 한다
 *    (라우팅번호를 바꾸면 DB 트리거가 재고 행을 지운다).
 * 3. **구입유형·공급상·고객을 바꿔 저장하면 DB 트리거가 연결 테이블을 고친다.** 저장 전에 확인을 받는다.
 *    서버는 값이 바뀐 컬럼만 UPDATE 한다.
 * 4. **API**: POST /master/parts (등록), PUT /master/parts/:itemCode (수정)
 */

"use client";

import { useState, useEffect, useMemo, useRef } from "react";
import { useTranslation } from "react-i18next";
import {
  ITEM_MASTER_CASCADE_COLUMNS,
  ITEM_MASTER_COLUMNS,
  ITEM_MASTER_SECTIONS,
  itemMasterDefaults,
  type ItemMasterColumn,
} from "@smt/shared";
import { Button, ConfirmModal } from "@/components/ui";
import api from "@/services/api";
import { Part } from "../types";
import { ItemField, kstDate, kstDateTime, ORDERED_ITEM_COLUMNS } from "./PartFieldHelp";

interface Props {
  editingPart: Part | null;
  onClose: () => void;
  onSave: () => void;
  /** 슬라이드 인 애니메이션 적용 여부 (기본: true) */
  animate?: boolean;
  /** 작성 중(저장 안 됨) 여부를 부모에 보고 — 행 전환 시 유실 방어용 */
  onDirtyChange?: (dirty: boolean) => void;
}

type FormState = Record<string, string>;

/** 넓은 칸 — 두 칸을 차지한다 */
const WIDE = new Set(["itemName", "spec", "imageUrl", "remark", "ecoCheckComments", "hsName", "hsSpec", "hsNameSale"]);

const todayKst = () => new Date().toLocaleDateString("sv-SE", { timeZone: "Asia/Seoul" });

/** 행 값 → 폼 문자열 */
function toFormValue(col: ItemMasterColumn, value: unknown): string {
  if (value === null || value === undefined) return "";
  if (col.type === "date") return col.section === "audit" ? kstDateTime(value) : kstDate(value);
  return String(value);
}

/** editingPart 로부터 폼 초기값. 등록이면 등록 기본값을 채운다. */
function buildForm(editingPart: Part | null): FormState {
  const row = editingPart as unknown as Record<string, unknown> | null;
  const defaults = itemMasterDefaults(todayKst());
  const form: FormState = {};
  for (const col of ITEM_MASTER_COLUMNS) {
    form[col.key] = row ? toFormValue(col, row[col.key]) : String(defaults[col.key] ?? "");
  }
  return form;
}

/** 폼 문자열 → API 값. 숫자는 Number, 빈 칸은 숫자·날짜면 null, 문자면 '' (서버가 NULL 로 바꾼다). */
function toPayloadValue(col: ItemMasterColumn, value: string): string | number | null {
  const text = value.trim();
  if (col.type === "number") return text === "" ? null : Number(text);
  if (col.type === "date") return text === "" ? null : text;
  return text;
}

export default function PartFormPanel({ editingPart, onClose, onSave, animate = true, onDirtyChange }: Props) {
  const { t } = useTranslation();
  const isEdit = !!editingPart;

  const [form, setForm] = useState<FormState>(() => buildForm(editingPart));
  const initialFormRef = useRef(form);
  const [saving, setSaving] = useState(false);
  const [cascadeConfirm, setCascadeConfirm] = useState<string[] | null>(null);

  // editingPart 변경 시 폼 리셋
  useEffect(() => {
    const init = buildForm(editingPart);
    setForm(init);
    initialFormRef.current = init;
  }, [editingPart]);

  const dirty = useMemo(
    () => JSON.stringify(form) !== JSON.stringify(initialFormRef.current),
    [form],
  );
  useEffect(() => {
    onDirtyChange?.(dirty);
  }, [dirty, onDirtyChange]);
  useEffect(() => () => onDirtyChange?.(false), [onDirtyChange]);

  const setField = (key: string, value: string) => setForm((prev) => ({ ...prev, [key]: value }));

  /** 이 칸을 고칠 수 있는가 */
  const editable = (col: ItemMasterColumn) =>
    col.edit === "always" || (col.edit === "create" && !isEdit);

  /** 등록창에서 반드시 넣어야 하는 칸 — NOT NULL 컬럼 */
  const missing = ITEM_MASTER_COLUMNS.filter(
    (col) => col.required && editable(col) && form[col.key].trim() === "",
  );
  const canSave = !saving && missing.length === 0;

  const submit = async () => {
    setSaving(true);
    try {
      const payload: Record<string, string | number | null> = {};
      for (const col of ITEM_MASTER_COLUMNS) {
        if (!editable(col)) continue;
        payload[col.key] = toPayloadValue(col, form[col.key]);
      }
      if (isEdit && editingPart?.itemCode) {
        await api.put(`/master/parts/${encodeURIComponent(editingPart.itemCode)}`, payload);
      } else {
        await api.post("/master/parts", payload);
      }
      onDirtyChange?.(false);
      onSave();
      onClose();
    } catch {
      // 에러는 api 인터셉터에서 처리
    } finally {
      setSaving(false);
    }
  };

  const handleSubmit = () => {
    if (!canSave) return;
    // 바꾸면 DB 트리거가 다른 테이블을 고치는 컬럼 — 수정에서 값이 바뀌었으면 먼저 확인
    const changedCascade = isEdit
      ? ITEM_MASTER_COLUMNS.filter(
        (col) => ITEM_MASTER_CASCADE_COLUMNS.includes(col.column)
          && form[col.key] !== initialFormRef.current[col.key],
      ).map((col) => `${col.label}: ${initialFormRef.current[col.key] || "(없음)"} → ${form[col.key] || "(없음)"}`)
      : [];
    if (changedCascade.length > 0) {
      setCascadeConfirm(changedCascade);
      return;
    }
    void submit();
  };

  return (
    <>
      <div
        className={`w-[560px] border-l border-border bg-background flex flex-col h-full overflow-hidden shadow-2xl text-xs ${animate ? "animate-slide-in-right" : ""}`}
      >
        {/* 헤더 */}
        <div className="px-5 py-3 border-b border-border flex items-center justify-between flex-shrink-0">
          <div>
            <h2 className="text-sm font-bold text-text">
              {isEdit ? t("master.part.editPart") : t("master.part.addPart")}
            </h2>
            {missing.length > 0 && (
              <p className="mt-0.5 text-xs text-text-muted">
                필수: {missing.map((col) => col.label).join(", ")}
              </p>
            )}
          </div>
          <div className="flex items-center gap-2">
            <Button size="sm" variant="secondary" onClick={onClose}>{t("common.cancel")}</Button>
            <Button size="sm" onClick={handleSubmit} disabled={!canSave}>
              {saving ? t("common.saving") : t("common.save", "저장")}
            </Button>
          </div>
        </div>

        {/* 본문 (스크롤 가능) — 구역별 */}
        <div className="flex-1 overflow-y-auto px-5 py-3 space-y-5">
          {ITEM_MASTER_SECTIONS.map((section) => {
            const cols = ORDERED_ITEM_COLUMNS.filter((col) => col.section === section.key);
            // 이력 구역은 수정할 때만 보인다 (등록 전에는 값이 없다)
            if (section.key === "audit" && !isEdit) return null;
            return (
              <div key={section.key}>
                <h3 className="text-xs font-semibold text-text-muted mb-2">{section.label}</h3>
                <div className="grid grid-cols-2 gap-3">
                  {cols.map((col) => (
                    <ItemField
                      key={col.key}
                      col={col}
                      value={form[col.key]}
                      onChange={(value) => setField(col.key, value)}
                      readOnly={!editable(col)}
                      required={col.required && editable(col)}
                      className={WIDE.has(col.key) ? "col-span-2" : ""}
                    />
                  ))}
                </div>
              </div>
            );
          })}
        </div>
      </div>

      <ConfirmModal
        isOpen={!!cascadeConfirm}
        onClose={() => setCascadeConfirm(null)}
        onConfirm={() => {
          setCascadeConfirm(null);
          void submit();
        }}
        title="연결 정보도 함께 바뀝니다"
        message={`${(cascadeConfirm ?? []).join("\n")}\n\n이 값을 바꾸면 DB 트리거가 BOM 의 구입유형, 구매 품목·단가의 공급상 정보를 함께 고칩니다. 저장할까요?`}
      />
    </>
  );
}
