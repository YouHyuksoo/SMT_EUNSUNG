/**
 * @file src/app/(authenticated)/master/part/types.ts
 * @description ID_ITEM API 계약 타입
 */

/** 품목 인터페이스 */
export interface Part {
  itemCode: string;
  itemName: string;
  itemNo?: string; // 품번 (Oracle PARTNO)
  custPartNo?: string; // 고객사 품번 (Oracle CUSTPARTNO)
  modelName?: string | null; // 차종
  modelSuffix?: string | null;
  itemType: string;
  itemClass: string;
  spec?: string;
  rev?: string; // 리비전 (Oracle REV)
  markingText?: string | null; // 마킹 문구
  itemUom?: string;
  color?: string | null; // 색상 (Oracle COLOR)
  safetyStock?: number; // 안전재고 (기본값: 0)
  lotUnitQty?: number; // LOT 단위수량 (Oracle LOTUNITQTY)
  boxQty?: number; // 박스 장입수량 (Oracle BOXQTY) (기본값: 0)
  minPackQty?: number; // 최소포장단위 수량 (기본값: 0)
  expiryDate?: number; // 유효기간 일 (Oracle EXPIRYDATE) (기본값: 0)
  expiryExtDays?: number; // 유효기간 연장 최대 일수 (Oracle EXPIRY_EXT_DAYS) (기본값: 0)
  packUnit?: number; // 팔레트 구성 단위(팔레트당 박스 수)
  storageLocation?: string; // 적재 로케이션 (창고 내 위치)
  remark?: string; // 비고 (Oracle REMARKS)
  imageUrl?: string | null;
  mesDisplayYn: string;
}
