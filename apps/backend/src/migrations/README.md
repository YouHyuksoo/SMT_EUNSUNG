# Backend SQL Migrations

이 디렉토리의 `.sql` 파일은 TypeORM `migrations:run` 으로 자동 실행되지 **않습니다**.
운영자가 직접 적용해야 하며, 누락 시 backend 가 시퀀스/인덱스 부재로 `ORA-02289` 등의 런타임 에러를 일으킵니다.

## 적용 절차

```powershell
pnpm --filter @eunsung/backend exec oracle-db apply src/migrations/<file>.sql --site ESDBext
```

또는 직접 SQL\*Plus / SQL Developer 로 실행합니다.

## 스키마 문서 갱신 필수

테이블, 컬럼, PK, FK, UK, CHECK 제약, 컬럼 기본값, 컬럼 주석, `COM_CODES` 기반 코드 도메인을 변경하는 마이그레이션을 추가하거나 적용하면 반드시 아래 명령으로 DB 스키마/ERD 문서를 갱신합니다.

```powershell
python tools/generate_db_schema_doc.py
```

갱신 대상:

- `docs/database/schema-erd.md`

스키마 변경 작업은 마이그레이션 SQL만으로 완료된 것으로 보지 않습니다. 문서 갱신 결과를 같은 작업 범위에 포함하고, 검증 로그에 문서 재생성 명령을 남깁니다.

## 미적용 환경 감지

시퀀스/인덱스 미존재 환경에 backend 가 배포되면 첫 관련 INSERT 시점에 다음과 같은 에러가 발생할 수 있습니다.

```
ORA-02289: sequence does not exist
```

배포 후 smoke test 로 해당 기능의 정상 응답을 확인하세요.
