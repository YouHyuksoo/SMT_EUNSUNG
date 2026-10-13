/**
 * @file src/app/(authenticated)/product/pack/boxLabelPrint.ts
 * @description 박스라벨 BarTender 출력 — 백엔드에서 양식(.btw)과 V1~V20 값을 받아 작업자 PC 의 Print Agent 로 넘긴다
 *
 * 초보자 가이드:
 * 1. GET /product/pack/box-label 이 PB 와 같은 방법으로 박스의 양식 파일과 값을 만든다.
 * 2. Print Agent(127.0.0.1:37111) 가 BarTender 로 양식을 열어 값을 넣고 매수만큼 찍는다.
 * 3. 출력 설정(사용 여부·매수·프린터)은 PC 마다 다르므로 브라우저 localStorage 에 둔다.
 */
import api from "@/services/api";
import { printAgentBarTender, PrintAgentUnavailableError } from "@/services/print-agent";

const SETTINGS_KEY = "eunsung.pack.boxLabel";

export interface BoxLabelSettings {
  /** BarTender 로 박스라벨을 찍는다 (PB 기본값: 사용) */
  enabled: boolean;
  /** 포장완료 때 출력 매수 (재출력은 1장) */
  copies: number;
  /** 비우면 양식에 저장된 프린터 */
  printerName: string;
}

export const DEFAULT_BOX_LABEL_SETTINGS: BoxLabelSettings = { enabled: true, copies: 1, printerName: "" };

export function loadBoxLabelSettings(): BoxLabelSettings {
  try {
    const raw = localStorage.getItem(SETTINGS_KEY);
    return raw ? { ...DEFAULT_BOX_LABEL_SETTINGS, ...(JSON.parse(raw) as Partial<BoxLabelSettings>) } : DEFAULT_BOX_LABEL_SETTINGS;
  } catch {
    return DEFAULT_BOX_LABEL_SETTINGS;
  }
}

export function saveBoxLabelSettings(settings: BoxLabelSettings) {
  try { localStorage.setItem(SETTINGS_KEY, JSON.stringify(settings)); } catch { /* 저장 못 해도 이번 화면에서는 쓴다 */ }
}

interface BoxLabelPayload {
  packBarcode: string;
  modelName: string;
  fileName: string;
  templateBase64: string;
  values: Record<string, string>;
}

/** 박스라벨을 찍는다. 실패하면 사람이 읽을 메시지로 예외를 던진다 */
export async function printBoxLabel(packBarcode: string, copies: number, printerName: string) {
  let payload: BoxLabelPayload;
  try {
    const res = await api.get("/product/pack/box-label", { params: { packBarcode } });
    payload = res.data?.data as BoxLabelPayload;
  } catch (error: unknown) {
    const message = (error as { response?: { data?: { message?: string } } })?.response?.data?.message;
    throw new Error(message ?? "박스라벨 데이터를 가져오지 못했습니다.");
  }
  try {
    return await printAgentBarTender({
      jobId: `BOX-${Date.now()}`,
      printerName: printerName || undefined,
      copies,
      fileName: payload.fileName,
      templateBase64: payload.templateBase64,
      values: payload.values,
    });
  } catch (error: unknown) {
    if (error instanceof PrintAgentUnavailableError) {
      throw new Error("이 PC 에서 출력 에이전트가 실행 중이 아닙니다. 화면 위쪽 프린터 아이콘에서 Print Agent 를 설치·실행하세요.");
    }
    throw new Error(`BarTender 출력 실패: ${error instanceof Error ? error.message : String(error)}`);
  }
}
