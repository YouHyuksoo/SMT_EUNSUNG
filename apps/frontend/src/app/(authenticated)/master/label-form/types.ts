/**
 * @file src/app/(authenticated)/master/label-form/types.ts
 * @description 제품별 라벨양식 관리 타입 — ISYS_LABEL_FORM
 */
export interface LabelForm {
  modelName: string;
  labelFormNo: number;
  /** 양식 파일(.btw) 이름 — 파일을 올리면 그 이름으로 바뀐다 */
  labelFormName: string | null;
  /** 공통코드 LABEL FORM TYPE (B 박스 / P 팔레트 / R 입고전표) */
  labelFormType: string;
  /** 공통코드 USE FLAG */
  useFlag: string | null;
  comments: string | null;
  /** 저장된 양식 파일 크기(byte), 0 이면 없음 */
  syntaxSize: number;
  /** 저장된 미리보기 이미지 크기(byte), 0 이면 없음 */
  imageSize: number;
  enterDate: string | null;
  enterBy: string | null;
  lastModifyDate: string | null;
  lastModifyBy: string | null;
}

/** V1~V20 한 칸 */
export interface LabelValueSlot {
  key: string;
  /** 공통코드 LABEL STEP 또는 고정 문자 */
  value: string | null;
  /** 지금 시점 기준 미리보기 값 */
  preview: string | null;
}

export const labelFormKey = (f: Pick<LabelForm, "modelName" | "labelFormNo">) => `${f.modelName}::${f.labelFormNo}`;
