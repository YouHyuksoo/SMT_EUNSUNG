# OEE MOBILE write path 후속 검증

- 작성일: 2026-08-08
- 대상 DB: `EUNSUNG_DEV_ESDBPDB`, schema `INFINITY21_JSMES`
- 검증 리소스: SMT LINE `01`
- 검증 작업자: `ADMIN`
- 검증 사유: `A`
- 결과: 시작·종료·동일 request replay 성공, 검증 데이터 정리 완료

## API 검증

1. `POST /api/v1/oee/mobile/downtime/start`: 201, 이벤트 `21` 생성
2. 같은 시작 request ID로 재호출: 201, 같은 이벤트 `21` 반환
3. 상태 조회: `DOWNTIME`, open event `21`
4. `POST /api/v1/oee/mobile/downtime/end`: 201, 이벤트 `21` 종료
5. 같은 종료 request ID로 재호출: 201, 같은 이벤트 `21` 반환
6. 상태 조회: `RUNNING`, open event 없음, 현재 업무일 이력 1건

## Oracle 확인·정리

- 이벤트 `21`의 `PROCESS_CODE='SMT'`, `RESOURCE_TYPE='LINE'`, `RESOURCE_CODE='01'`을 확인했다.
- 업무일은 `2026-08-08`, 근무구간은 실행 시각 기준 `C`였다.
- 시작·종료 request ID와 `EVENT_STATE='CLOSED'`를 확인했다.
- 이벤트 ID와 두 request ID를 모두 조건으로 사용해 검증 이벤트 한 건만 삭제했다.
- 삭제 후 같은 이벤트 ID 또는 request ID를 가진 행은 0건이다.
- 최종 상태 API는 `RUNNING`, open event 없음, 이력 0건을 반환했다.
