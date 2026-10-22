"use client";

/**
 * @file src/app/(authenticated)/quality/product-destroy/components/DestroyDetailFields.tsx
 * @description 공정폐기 등록의 팀별 불량 입력칸 (요청서 26.10.22 2번 시트 양식)
 *
 * 초보자 가이드:
 * 1. 생산1팀(SMT): 라인 · 불량유형 · 제품구분 · 주/야 · 검출공정 · 원인 · 작업자
 * 2. 생산2팀(조립): 불량구분1 · 제품구분(불량구분2) · 불량명 · 원인(근로자/설비) · 발생공정 · 검출공정 · 주/야 · 라인 · 작업자
 * 3. 코드칸은 모두 공통코드 선택이다. 작업자만 수기 입력 (요청서 "수기 입력 필요").
 * 4. 원인은 BAD CAUSE BY 코드 M(작업)·S(원자재)·E(설비) 중에서 고른다 — 월 요약의 설비이상/원자재/HUMAN 으로 묶인다.
 */
import { useMemo } from 'react';
import { Input, Select } from '@/components/ui';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import LineSelect from '@/components/shared/LineSelect';
import { useComCodeList } from '@/hooks/useComCode';
import { SHIFT_LABELS } from '../columns';
import { TEAM_CODE_GROUPS, type DestroyTeam } from '../types';

export interface DestroyDetail {
  lineCode: string;
  badReasonCode: string;
  productType: string;
  shiftCode: string;
  causeBy: string;
  detectProcessCode: string;
  occurProcessCode: string;
  badCategory: string;
  worker: string;
}

/** 지금 시각으로 주/야 기본값 — 08~19시는 주간 */
export const currentShift = () => {
  const hour = new Date().getHours();
  return hour >= 8 && hour < 20 ? 'A' : 'B';
};

export const emptyDetail = (): DestroyDetail => ({
  lineCode: '', badReasonCode: '', productType: '', shiftCode: currentShift(), causeBy: 'M',
  detectProcessCode: '', occurProcessCode: '', badCategory: '', worker: '',
});

/** 팀별 필수칸이 다 찼는지 */
export const isDetailComplete = (team: DestroyTeam, d: DestroyDetail) =>
  Boolean(d.badReasonCode && d.productType && d.shiftCode && d.causeBy && d.detectProcessCode && d.worker.trim()
    && (team === '1' || (d.badCategory && d.occurProcessCode)));

const SHIFT_OPTIONS = Object.entries(SHIFT_LABELS).map(([value, label]) => ({ value, label }));
/** 1팀은 설비/원자재/작업자, 2팀 양식은 근로자/설비 */
const CAUSE_CODES: Record<DestroyTeam, string[]> = { '1': ['M', 'S', 'E'], '2': ['M', 'E'] };

interface Props {
  team: DestroyTeam;
  value: DestroyDetail;
  onChange: (next: DestroyDetail) => void;
}

export default function DestroyDetailFields({ team, value, onChange }: Props) {
  const causeCodes = useComCodeList('BAD CAUSE BY');
  const causeOptions = useMemo(
    () => CAUSE_CODES[team].map(code => ({
      value: code,
      label: causeCodes.find(c => c.detailCode === code)?.codeName ?? code,
    })),
    [causeCodes, team],
  );
  const groups = TEAM_CODE_GROUPS[team];
  const set = <K extends keyof DestroyDetail>(key: K) => (next: DestroyDetail[K]) => onChange({ ...value, [key]: next });

  const line = <LineSelect key="line" aria-label="라인" labelPrefix="라인" value={value.lineCode} onChange={v => set('lineCode')(v)} className="w-36" />;
  const productType = (
    <ComCodeSelect key="productType" groupCode="DESTROY PRODUCT TYPE" includeAll={false} aria-label={team === '1' ? '제품구분' : '불량구분2'}
      placeholder={team === '1' ? '제품구분' : '불량구분2'} value={value.productType} onChange={v => set('productType')(v)} className="w-28" />
  );
  const badType = (
    <ComCodeSelect key="badType" groupCode={groups.badType} includeAll={false} aria-label={team === '1' ? '불량유형' : '불량명'}
      placeholder={team === '1' ? '불량유형' : '불량명'} value={value.badReasonCode} onChange={v => set('badReasonCode')(v)} className="w-36" />
  );
  const shift = (
    <Select key="shift" aria-label="주/야" placeholder="주/야" options={SHIFT_OPTIONS} value={value.shiftCode} onChange={v => set('shiftCode')(v)} className="w-24" />
  );
  const cause = (
    <Select key="cause" aria-label={team === '1' ? '원인' : '근로자/설비'} placeholder={team === '1' ? '원인' : '근로자/설비'}
      options={causeOptions} value={value.causeBy} onChange={v => set('causeBy')(v)} className="w-28" />
  );
  const detect = (
    <ComCodeSelect key="detect" groupCode={groups.process} includeAll={false} aria-label="검출공정" placeholder="검출공정"
      value={value.detectProcessCode} onChange={v => set('detectProcessCode')(v)} className="w-32" />
  );
  const worker = (
    <Input key="worker" aria-label="작업자" placeholder="작업자 (수기)" maxLength={6} value={value.worker}
      onChange={e => set('worker')(e.target.value)} className="w-32" />
  );

  if (team === '1') {
    return <div className="contents">{[line, badType, productType, shift, detect, cause, worker]}</div>;
  }
  return (
    <div className="contents">
      <ComCodeSelect groupCode="DESTROY BAD CATEGORY" includeAll={false} aria-label="불량구분1" placeholder="불량구분1"
        value={value.badCategory} onChange={v => set('badCategory')(v)} className="w-28" />
      {productType}
      {badType}
      {cause}
      <ComCodeSelect groupCode={groups.process} includeAll={false} aria-label="발생공정" placeholder="발생공정"
        value={value.occurProcessCode} onChange={v => set('occurProcessCode')(v)} className="w-32" />
      {detect}
      {shift}
      {line}
      {worker}
    </div>
  );
}
