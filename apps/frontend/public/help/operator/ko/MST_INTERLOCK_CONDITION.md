# 인터락조건관리 운영 가이드

## 데이터 원본

- 인터락 조건: `IQ_INTERLOCK_CHECK_CONDITION` (PK 없음 — 화면은 ROWID 로 행을 찾는다)
- 검사유형: 공통코드 `INTERLOCK CHECK TYPE`
- 변경 이력: `IQ_INTERLOCK_CHECK_COND_LOG` (트리거 `TRG_IQ_INTERLOCK_CHK_COND_UPD`, `TRG_IQ_INTERLOCK_CHK_COND_DEL` 이 수정·삭제 때 남긴다)
- 메뉴 코드: `MST_INTERLOCK_CONDITION`

## 저장 영향

- 공정통과 등록은 그 라인·공정의 사용 중인 조건(`NVL(USE_YN,'Y')='Y'`)을 `CHECK_SEQUENCE` 순서로 읽어 `P_INTERLOCK_CHECK` 를 부른다. 하나라도 NG 면 통과를 막는다.
- 조건을 지우거나 미사용으로 바꾸면 바로 다음 공정통과부터 그 검사를 하지 않는다.
- 라인 복사는 대상 라인에 같은 공정·설비·검사유형·품목 조건이 없을 때만 넣는다. 등록자·등록일은 복사한 사람과 시각이다.
