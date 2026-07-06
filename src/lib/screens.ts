/**
 * Screen registry used by menu cards, auto-launch, and display routing.
 * Keep this file free of page-specific business logic.
 */
export interface ScreenConfig {
  id: string;
  title: string;
  titleKo: string;
  titleEs?: string;
  titleVi?: string;
  window: string;
  group: string;
  lineFilter?: boolean;
}

export const SCREENS: Record<string, ScreenConfig> = {
  '18': { id: '18', title: 'Display Option', titleKo: '디스플레이 옵션', titleEs: 'Configuracion de opciones', titleVi: 'Cai dat tuy chon', window: 'w_display_option', group: 'favorites' },

  '24': { id: '24', title: 'SMD Production Status', titleKo: 'SMD 생산현황', titleEs: 'Estado de produccion SMD', titleVi: 'Trang thai san xuat SMD', window: 'w_display_machine_status_smd', group: 'monitoring', lineFilter: true },
  '25': { id: '25', title: 'Foolproof Status', titleKo: '종합F/P현황', titleEs: 'Estado Foolproof', titleVi: 'Trang thai Foolproof', window: 'w_display_machine_foolproof_status', group: 'monitoring', lineFilter: true },
  '26': { id: '26', title: 'Line Production KPI', titleKo: '라인별생산현황', titleEs: 'KPI de produccion por linea', titleVi: 'KPI san xuat theo Line', window: 'w_display_product_kpi_status', group: 'monitoring', lineFilter: true },
  '27': { id: '27', title: 'SMD Dual Production Status', titleKo: 'SMD 듀얼생산현황', titleEs: 'Estado de produccion dual SMD', titleVi: 'Trang thai san xuat kep SMD', window: 'w_display_machine_status_single_smd', group: 'monitoring', lineFilter: true },

  '21': { id: '21', title: 'Product Production Status', titleKo: '제품생산현황', titleEs: 'Estado de produccion de productos', titleVi: 'Trang thai san xuat san pham', window: 'w_display_product_line_monitoring', group: 'monitoring', lineFilter: true },

  '29': { id: '29', title: 'MSL Warning List (Mount)', titleKo: 'MSL(장착기준)', titleEs: 'Lista de alertas MSL (montaje)', titleVi: 'Cảnh báo MSL (lắp đặt)', window: 'w_display_msl_warning_list', group: 'quality' },
  '30': { id: '30', title: 'MSL Warning List (Issue)', titleKo: 'MSL(출고기준)', titleEs: 'Lista de alertas MSL (emisión)', titleVi: 'Cảnh báo MSL (xuất kho)', window: 'w_display_msl_warning_list_issue_item', group: 'quality' },
  '31': { id: '31', title: 'Solder Paste Mgmt', titleKo: '솔더 페이스트 관리', titleEs: 'Gestion de pasta de soldadura', titleVi: 'Quan ly Solder Paste', window: 'w_display_solderpaste_mgmt', group: 'quality' },


  '40': { id: '40', title: 'SPI Chart Analysis', titleKo: 'SPI 차트분석', titleEs: 'Analisis de graficos SPI', titleVi: 'Phan tich bieu do SPI', window: 'w_display_spi_chart', group: 'charts' },
  '41': { id: '41', title: 'AOI Chart Analysis', titleKo: 'AOI 차트분석', titleEs: 'Analisis de graficos AOI', titleVi: 'Phan tich bieu do AOI', window: 'w_display_aoi_chart', group: 'charts' },
  '42': { id: '42', title: 'FCT Chart Analysis', titleKo: 'FCT 차트분석', titleEs: 'Analisis de graficos FCT', titleVi: 'Phan tich bieu do FCT', window: 'w_display_fct_chart', group: 'charts' },
  '43': { id: '43', title: 'VISION Chart Analysis', titleKo: 'VISION 차트분석', titleEs: 'Analisis de graficos VISION', titleVi: 'Phan tich bieu do VISION', window: 'w_display_vision_chart', group: 'charts' },

};

export function getLocalizedScreenTitle(screen: ScreenConfig, locale: string): string {
  if (locale === 'ko') return screen.titleKo;
  if (locale === 'es') return screen.titleEs ?? screen.title;
  if (locale === 'vi') return screen.titleVi ?? screen.title;
  return screen.title;
}
