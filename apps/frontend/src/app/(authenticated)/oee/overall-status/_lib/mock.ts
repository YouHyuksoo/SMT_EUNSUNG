/**
 * @file oee/overall-status/_lib/mock.ts
 * @description OEE 종합 현황 목업 데이터 — 산식 적용 전 화면 확인용
 *
 * 초보자 가이드:
 * 1. 라인명과 설비코드는 실제 마스터(IP_PRODUCT_LINE, IMCN_MACHINE) 값이지만
 *    가동율·성능율·양품율 수치는 전부 가짜다. 화면 헤더에 목업 배지를 상시 노출한다.
 * 2. 산식을 붙일 때는 이 파일의 상수를 API 응답으로 갈아끼우기만 하면 되도록,
 *    화면은 이 타입만 보고 그린다.
 */

/** 타일 상태 — 테두리·뱃지 색과 정지 점멸을 정한다 */
export type TileStatus = "RUN" | "WARN" | "STOP";

/** 가동율·성능율·양품율 (%) */
export interface OeeRates {
  availability: number;
  performance: number;
  quality: number;
}

export interface OeeMachine extends OeeRates {
  machineCode: string;
  machineName: string;
  status: TileStatus;
  /** 상태 부연 (정지 사유 등) */
  note: string;
}

export interface OeeLine extends OeeRates {
  lineCode: string;
  lineName: string;
  status: TileStatus;
  /** 라인 대표값 — 타일의 큰 숫자 */
  oee: number;
  note: string;
}

/** 상단 공장 종합 KPI — 라인 선택과 무관하게 고정이다 */
export interface FactoryKpi {
  labelKey: string;
  value: string;
  unit: string;
  tone: "normal" | "warn" | "bad";
}

export const MOCK_FACTORY_KPIS: FactoryKpi[] = [
  { labelKey: "oee.overallStatus.kpi.factoryOee", value: "78.4", unit: "%", tone: "normal" },
  { labelKey: "oee.overallStatus.kpi.availability", value: "86.7", unit: "%", tone: "normal" },
  { labelKey: "oee.overallStatus.kpi.performance", value: "87.2", unit: "%", tone: "warn" },
  { labelKey: "oee.overallStatus.kpi.quality", value: "98.0", unit: "%", tone: "normal" },
  { labelKey: "oee.overallStatus.kpi.firstPass", value: "94.1", unit: "%", tone: "warn" },
  { labelKey: "oee.overallStatus.kpi.downtimeOpen", value: "3", unit: "", tone: "bad" },
];

export const MOCK_LINES: OeeLine[] = [
  { lineCode: "01", lineName: "A라인", status: "RUN",  oee: 82.1, availability: 86.7, performance: 87.2, quality: 98.0, note: "정상" },
  { lineCode: "02", lineName: "B라인", status: "RUN",  oee: 84.6, availability: 88.2, performance: 90.1, quality: 97.5, note: "정상" },
  { lineCode: "03", lineName: "C라인", status: "WARN", oee: 73.0, availability: 79.4, performance: 85.3, quality: 96.2, note: "검사 재시도 증가" },
  { lineCode: "19", lineName: "WAVE",  status: "RUN",  oee: 88.0, availability: 91.5, performance: 92.4, quality: 98.6, note: "정상" },
  { lineCode: "20", lineName: "ICT",   status: "WARN", oee: 76.2, availability: 82.0, performance: 88.1, quality: 95.4, note: "조건 안정화 중" },
  { lineCode: "24", lineName: "ROUTER", status: "STOP", oee: 69.5, availability: 71.3, performance: 84.0, quality: 97.1, note: "무작업 진행 중" },
];

/** 라인코드 → 그 라인의 설비 목록 */
export const MOCK_MACHINES: Record<string, OeeMachine[]> = {
  "01": [
    { machineCode: "ES-CO-02", machineName: "ACS-700", status: "RUN",  availability: 86.7, performance: 87.2, quality: 98.0, note: "정상" },
    { machineCode: "ES-CO-08", machineName: "ACS-700", status: "RUN",  availability: 84.2, performance: 90.1, quality: 97.5, note: "정상" },
    { machineCode: "ES-CO-14", machineName: "ACS-700", status: "WARN", availability: 78.9, performance: 83.4, quality: 96.8, note: "CT 지연" },
    { machineCode: "ES-CO-21", machineName: "ACS-700", status: "STOP", availability: 0,    performance: 0,    quality: 0,    note: "무작업 12분 경과" },
  ],
  "02": [
    { machineCode: "ES-CO-03", machineName: "ACS-700", status: "RUN", availability: 89.1, performance: 91.0, quality: 98.2, note: "정상" },
    { machineCode: "ES-CO-09", machineName: "ACS-700", status: "RUN", availability: 87.4, performance: 89.3, quality: 97.1, note: "정상" },
    { machineCode: "ES-CO-15", machineName: "ACS-700", status: "RUN", availability: 88.0, performance: 90.2, quality: 97.3, note: "정상" },
  ],
  "03": [
    { machineCode: "ES-CO-04", machineName: "ACS-700", status: "WARN", availability: 79.4, performance: 85.3, quality: 96.2, note: "검사 재시도 7.7%" },
    { machineCode: "ES-CO-10", machineName: "ACS-700", status: "RUN",  availability: 83.6, performance: 88.0, quality: 97.0, note: "정상" },
  ],
  "19": [
    { machineCode: "ES-WV-01", machineName: "WAVE SOLDER", status: "RUN", availability: 91.5, performance: 92.4, quality: 98.6, note: "정상" },
    { machineCode: "ES-WV-02", machineName: "WAVE SOLDER", status: "RUN", availability: 90.2, performance: 91.8, quality: 98.4, note: "정상" },
  ],
  "20": [
    { machineCode: "ES-IC-01", machineName: "ICT TESTER", status: "WARN", availability: 82.0, performance: 88.1, quality: 95.4, note: "조건 안정화 중" },
    { machineCode: "ES-IC-02", machineName: "ICT TESTER", status: "RUN",  availability: 86.3, performance: 89.7, quality: 97.2, note: "정상" },
    { machineCode: "ES-IC-03", machineName: "ICT TESTER", status: "RUN",  availability: 85.1, performance: 88.9, quality: 96.9, note: "정상" },
  ],
  "24": [
    { machineCode: "ES-RT-01", machineName: "ROUTER", status: "STOP", availability: 0,    performance: 0,    quality: 0,    note: "작업자 부재 00:12" },
    { machineCode: "ES-RT-02", machineName: "ROUTER", status: "RUN",  availability: 88.4, performance: 90.6, quality: 97.8, note: "정상" },
  ],
};

/** 하단 경보 문구 — 산식 적용 시 실제 이벤트로 대체한다 */
export const MOCK_ALERT =
  "ES-RT-01 무작업 12분 경과(사유: 작업자 부재/통제가능) · ES-CO-04 검사 재시도율 7.7% — 직행율 저하 원인 1위";
