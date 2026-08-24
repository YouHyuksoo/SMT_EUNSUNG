/**
 * @file src/app/(authenticated)/master/company/types.ts
 * @description 회사마스터 + 사업장 타입 정의
 */

export interface Company {
  companyCode: string;
  plant: string;
  plantName?: string;
  companyName: string;
  bizNo?: string;
  ceoName?: string;
  address?: string;
  tel?: string;
  fax?: string;
  email?: string;
  remark?: string;
  useYn: string;
}

export interface Plant {
  plantCode: string;
  shopCode?: string;
  lineCode?: string;
  cellCode?: string;
  plantName: string;
  plantType?: string;
  sortOrder: number;
  useYn: string;
  company?: string;
  plantCd?: string;
}

export const getCompanyKey = (company: Pick<Company, "companyCode" | "plant">) =>
  `${company.companyCode}::${company.plant || "-"}`;

export const getPlantKey = (
  plant: Pick<Plant, "plantCode" | "shopCode" | "lineCode" | "cellCode">,
) =>
  [plant.plantCode, plant.shopCode || "-", plant.lineCode || "-", plant.cellCode || "-"].join("::");

/** PLANTS 복합키를 API 경로에 넣을 때 각 segment를 개별 인코딩한다. */
export const getPlantPath = (
  plant: Pick<Plant, "plantCode" | "shopCode" | "lineCode" | "cellCode">,
) =>
  [plant.plantCode, plant.shopCode || "-", plant.lineCode || "-", plant.cellCode || "-"]
    .map((segment) => encodeURIComponent(segment))
    .join("/");
