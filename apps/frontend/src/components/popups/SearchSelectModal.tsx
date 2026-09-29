"use client";

/**
 * @file src/components/popups/SearchSelectModal.tsx
 * @description PB 검색선택 팝업 엔진 — 카탈로그 정의 하나로 팝업 하나가 된다
 *
 * PB 검색선택 팝업은 구조가 전부 같다: 필터 입력 N개 + 그리드 1개 + 선택/취소.
 * 그래서 팝업마다 파일을 만들지 않고, `@smt/shared` 의 카탈로그 엔트리
 * (제목·필터·컬럼·쿼리명)를 받아 이 엔진이 렌더한다. 조회는 공용 팝업조회 API
 * (`/popup-search/{query}`)가 처리하며, SQL 은 백엔드 화이트리스트에만 있다.
 *
 * 반환값:
 * PB 는 `CloseWithReturn` 으로 한 값을, 전역구조체(`gst_return.gvs_return[n]`)로는
 * 여러 값을 돌려줬다. 그래서 `onSelect` 는 **선택 행 객체 전체**를 넘긴다.
 * 카탈로그의 `returnColumns` 는 PB 가 돌려주던 필드와 그 순서를 기록한 것이다.
 *
 * 사용 예:
 *   <SearchSelectModal
 *     popupId="supplier-search"
 *     isOpen={open}
 *     onClose={() => setOpen(false)}
 *     onSelect={(row) => setSupplierCode(String(row.supplierCode ?? ""))}
 *   />
 */

import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import { useTranslation } from "react-i18next";
import { Search } from "lucide-react";
import { ColumnDef } from "@tanstack/react-table";
import { findPopupById, type PopupEntry, type PopupFilter } from "@smt/shared";
import { Modal, Button, Input, Select } from "@/components/ui";
import ComCodeSelect from "@/components/shared/ComCodeSelect";
import DateFilter from "@/components/shared/DateFilter";
import DataGrid from "@/components/data-grid/DataGrid";
import api from "@/services/api";

export type PopupRow = Record<string, unknown>;

interface SearchSelectModalProps {
  /** 카탈로그 엔트리 id (`@smt/shared` POPUP_CATALOG) */
  popupId: string;
  isOpen: boolean;
  onClose: () => void;
  /** 행 선택 — 선택 행 전체를 넘긴다 (PB 전역구조체 다중 반환 대응) */
  onSelect: (row: PopupRow) => void;
  /** 필터 초기값 (PB `OpenWithParm` 인자에 해당). 열 때마다 이 값으로 되돌아간다 */
  initialFilters?: Record<string, string>;
  /** 모달 폭. 컬럼이 많으면 키운다 */
  size?: "lg" | "xl" | "2xl";
  /** 그리드 페이지당 행 수 */
  pageSize?: number;
}

function emptyFilters(entry: PopupEntry | undefined, initial?: Record<string, string>) {
  const values: Record<string, string> = {};
  for (const filter of entry?.filters ?? []) {
    values[filter.key] = initial?.[filter.key] ?? "";
  }
  return values;
}

export default function SearchSelectModal(props: SearchSelectModalProps) {
  const { t } = useTranslation();
  const entry = findPopupById(props.popupId);

  if (!entry) {
    // 카탈로그에 없는 id 는 개발 시점 오류다. 빈 모달을 띄우는 대신 원인을 보여준다.
    return (
      <Modal
        isOpen={props.isOpen}
        onClose={props.onClose}
        title={t("common.error", "오류")}
        size="sm"
      >
        <p className="text-sm text-danger">
          등록되지 않은 팝업입니다: {props.popupId} — components/popups 카탈로그를 확인하세요.
        </p>
      </Modal>
    );
  }

  // 열 때마다 필터를 초기값으로 되돌린다. 이펙트에서 setState 로 되돌리는 대신 key 로
  // 본문을 새로 마운트한다 (React Compiler 가 이펙트 내 동기 setState 를 금지한다).
  const resetKey = `${props.popupId}:${JSON.stringify(props.initialFilters ?? {})}:${props.isOpen}`;
  return <SearchSelectBody key={resetKey} {...props} entry={entry} />;
}

interface SearchSelectBodyProps extends SearchSelectModalProps {
  entry: PopupEntry;
}

function SearchSelectBody({
  entry,
  isOpen,
  onClose,
  onSelect,
  initialFilters,
  size = "xl",
  pageSize = 15,
}: SearchSelectBodyProps) {
  const { t } = useTranslation();
  const queryName = entry.query;

  const [values, setValues] = useState<Record<string, string>>(() =>
    emptyFilters(entry, initialFilters),
  );
  const [rows, setRows] = useState<PopupRow[]>([]);
  // 열리면 곧바로 조회하므로 로딩으로 시작한다 (이펙트에서 동기 setState 를 하지 않기 위함)
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const firstFieldRef = useRef<HTMLInputElement>(null);

  /** 조회만 하고 상태는 건드리지 않는다 — 호출한 쪽이 시점을 정한다 */
  const runSearch = useCallback(
    async (filters: Record<string, string>): Promise<{ rows: PopupRow[]; error: string | null }> => {
      if (!queryName) return { rows: [], error: null };
      try {
        const params: Record<string, string | number> = { limit: 200 };
        for (const [key, value] of Object.entries(filters)) {
          if (value.trim()) params[key] = value.trim();
        }
        const res = await api.get(`/popup-search/${queryName}`, { params });
        const raw = res.data?.data;
        return { rows: Array.isArray(raw) ? raw : (raw?.data ?? []), error: null };
      } catch {
        return { rows: [], error: t("common.loadFailed", "조회에 실패했습니다.") };
      }
    },
    [queryName, t],
  );

  /** 모달이 열리면 한 번 조회한다 (PB 도 팝업을 열면서 Retrieve 한다) */
  useEffect(() => {
    if (!isOpen) return;
    let cancelled = false;
    void (async () => {
      const result = await runSearch(emptyFilters(entry, initialFilters));
      if (cancelled) return;
      setRows(result.rows);
      setError(result.error);
      setLoading(false);
    })();
    return () => {
      cancelled = true;
    };
  }, [isOpen, entry, initialFilters, runSearch]);

  const handleSearch = useCallback(() => {
    setLoading(true);
    void runSearch(values).then((result) => {
      setRows(result.rows);
      setError(result.error);
      setLoading(false);
    });
  }, [runSearch, values]);

  const setValue = useCallback((key: string, value: string) => {
    setValues((prev) => ({ ...prev, [key]: value }));
  }, []);

  const columns = useMemo<ColumnDef<PopupRow, unknown>[]>(
    () =>
      (entry.columns ?? []).map((column) => ({
        accessorKey: column.key,
        header: column.label,
        size: column.width,
        meta: column.align ? { align: column.align } : undefined,
      })),
    [entry],
  );

  const handleRowClick = useCallback(
    (row: PopupRow) => {
      onSelect(row);
      onClose();
    },
    [onSelect, onClose],
  );

  return (
    <Modal isOpen={isOpen} onClose={onClose} title={entry.title} size={size}>
      <div className="flex flex-wrap items-end gap-2 mb-3">
        {(entry.filters ?? []).map((filter) => (
          <FilterField
            key={filter.key}
            filter={filter}
            value={values[filter.key] ?? ""}
            onChange={(value) => setValue(filter.key, value)}
            onEnter={handleSearch}
            inputRef={filter.autoFocus ? firstFieldRef : undefined}
          />
        ))}
        <Button onClick={handleSearch} className="flex-shrink-0">
          <Search className="w-4 h-4 mr-1" />
          {t("common.search")}
        </Button>
      </div>

      {error && <p className="mb-2 text-sm text-danger">{error}</p>}

      <DataGrid
        data={rows}
        columns={columns}
        isLoading={loading}
        pageSize={pageSize}
        onRowClick={handleRowClick}
        enableColumnFilter={false}
        emptyMessage={t("common.noData", "데이터가 없습니다.")}
      />
    </Modal>
  );
}

interface FilterFieldProps {
  filter: PopupFilter;
  value: string;
  onChange: (value: string) => void;
  onEnter: () => void;
  inputRef?: React.RefObject<HTMLInputElement | null>;
}

/** 필터 하나를 카탈로그의 `type` 에 맞는 공용 컴포넌트로 렌더한다 */
function FilterField({ filter, value, onChange, onEnter, inputRef }: FilterFieldProps) {
  if (filter.type === "com-code") {
    return (
      <ComCodeSelect
        groupCode={filter.groupCode ?? ""}
        value={value}
        onChange={(next) => onChange(next)}
        labelPrefix={filter.label}
        className="w-40 flex-shrink-0"
      />
    );
  }
  if (filter.type === "select") {
    return (
      <Select
        options={[{ value: "", label: filter.label }, ...(filter.options ?? [])]}
        value={value}
        onChange={(next) => onChange(next)}
        className="w-40 flex-shrink-0"
      />
    );
  }
  if (filter.type === "date") {
    return <DateFilter value={value} onChange={onChange} className="flex-shrink-0" />;
  }
  return (
    <Input
      ref={inputRef}
      placeholder={filter.label}
      value={value}
      onChange={(e) => onChange(e.target.value)}
      onKeyDown={(e) => {
        if (e.key === "Enter") onEnter();
      }}
      className="w-44 flex-shrink-0"
    />
  );
}
