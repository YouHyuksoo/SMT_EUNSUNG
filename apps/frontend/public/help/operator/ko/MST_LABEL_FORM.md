# 제품별 라벨양식 관리 운영 가이드

## 데이터 원본

- 라벨 양식: `ISYS_LABEL_FORM` (키: `MODEL_NAME` + `LABEL_FORM_NO` + `ORGANIZATION_ID`, DB PK 없음)
- 양식 파일: `LABEL_SYNTAX` (BLOB, BarTender `.btw`), 미리보기 이미지: `LABEL_IMAGE` (BLOB)
- 유형: 공통코드 `LABEL FORM TYPE`, 사용: `USE FLAG`, 값 칸 항목: `LABEL STEP`
- 메뉴 코드: `MST_LABEL_FORM`

## 동작

- 라벨 발행은 `MODEL_NAME` + `LABEL_FORM_TYPE` 으로 양식 하나를 고른다. 그래서 모델·유형별로 하나만 저장되게 막는다 (등록·수정·복사 모두).

- 미리보기 값은 값이 있는 칸만 `F_GEN_LABEL_DATA_4_BARTENDER('', 모델, 유형, 'Vn', SYSDATE, '1', 'PREVIEW', '')` 로 만든다.
- 양식 파일을 올리면 `LABEL_FORM_NAME` 을 파일 이름으로 바꾼다. 이미지는 이름을 바꾸지 않는다.
- 파일은 10MB 까지 올릴 수 있다.
- 다른 모델로 복사는 한 트랜잭션으로 넣는다. 대상 모델에 같은 양식번호가 하나라도 있으면 전부 넣지 않는다.
- 라벨 출력은 이 화면에 없다. 출력하는 화면이 `ISYS_LABEL_FORM` 을 읽는다.
