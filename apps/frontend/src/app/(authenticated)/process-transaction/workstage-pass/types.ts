export type WorkstagePassMode = 'wait' | 'history' | 'inventory' | 'today' | 'workstageSummary';
export interface WorkstagePassRow {
  ioDate?: string; actualDate?: string; ioSequence?: number; runNo?: string; itemCode?: string; serialNo?: string;
  lineCode?: string; workstageCode?: string; ioDeficit?: string; ioQty?: number; outDate?: string;
  modelName?: string; modelSuffix?: string; workstageType?: string; lotNo?: string; wipSeq?: number;
}
