# GitHub Actions SSH 배포 설계

## 목표

`main` 브랜치에 반영된 은성전장 MES 모노레포를 GitHub-hosted Runner에서 지성 개발서버로 SSH 배포한다. 프론트엔드와 백엔드를 함께 빌드하고 PM2로 실행한 뒤 실제 HTTP 상태를 확인한다.

## 배포 대상

- 저장소: `YouHyuksoo/SMT_EUNSUNG` (Public)
- 서버: 지성 개발서버 `139.150.82.207:22` (Windows Server 2019)
- 배포 루트: `D:\Project\SMT_EUNSUNG`
- 프론트엔드: `eunsung-frontend`, `0.0.0.0:3100`
- 백엔드: `eunsung-backend`, `0.0.0.0:3003`
- 프로세스 관리자: PM2
- 패키지 관리자: `pnpm@10.28.1`

## 실행 구조

GitHub Actions는 `main` push와 관리자 수동 실행으로 시작한다. 표준 GitHub-hosted Runner가 저장소를 체크아웃하고, 고정된 SSH host key와 배포 전용 키로 지성 개발서버에 접속한다. 서버에서 배포 전 점검, 소스 동기화, 의존성 설치, shared/백엔드/프론트 빌드, PM2 재시작, HTTP 상태 확인을 순서대로 수행한다.

PR 및 fork 이벤트에서는 배포 job을 실행하지 않는다. 동시 배포는 workflow concurrency로 직렬화한다.

## 서버 전용 설정

다음 파일은 Git에 포함하지 않고 서버에만 유지한다.

- `apps/backend/.env`: 최초 구성 시 현재 로컬 파일을 서버에 안전하게 복사한다.
- `apps/frontend/config/database.json`: 서버에 존재하는 파일을 계속 사용한다.

배포 전에 두 파일의 존재 여부를 검사한다. 내용이나 자격증명은 Actions 로그에 출력하지 않는다.

## 소스 동기화 정책

기존 서버 경로를 사용하되 무조건적인 `git reset --hard`는 금지한다. tracked 변경 또는 허용 목록 밖의 untracked 파일이 있으면 배포를 중단한다. 런타임 로그와 서버 전용 설정처럼 명시적으로 허용한 항목만 배포 전 점검에서 제외한다.

정상 상태에서는 `origin/main`을 fetch하고 fast-forward 방식으로만 동기화한다. 이력이 갈라졌거나 파일 충돌 가능성이 있으면 자동 병합하지 않고 실패 처리한다.

## 프로세스 구성

루트 PM2 설정은 프론트엔드와 백엔드를 각각 독립 앱으로 정의한다. 프론트엔드는 Next.js production server를 `3100`에서 실행하고, 백엔드는 컴파일된 NestJS 엔트리를 `3003`에서 실행한다. 로그와 재시작 정책은 앱별로 분리한다.

배포 빌드가 모두 성공한 뒤에만 두 프로세스를 재시작한다. 한쪽 빌드가 실패하면 기존 프로세스는 유지한다.

## 실패 처리와 검증

- 필수 도구 또는 설정 파일 누락: 즉시 실패
- dirty worktree 또는 non-fast-forward: 즉시 실패
- 의존성 설치/빌드 실패: PM2 재시작 금지
- PM2 재시작 실패: 해당 앱 로그 출력 후 실패
- 상태 확인 실패: 두 앱의 최근 PM2 로그와 상태 출력 후 실패

상태 확인은 프론트 `http://localhost:3100`과 인증이 필요 없는 백엔드 health endpoint를 사용한다. 백엔드에 적절한 endpoint가 없으면 배포 전용 read-only health endpoint를 추가한다.

## 초기 구성

1. 배포 전용 Ed25519 SSH 키를 생성한다.
2. 공개키를 지성 개발서버 관리자 OpenSSH 키 저장소에 등록한다.
3. 키 인증과 SSH host key를 검증한다.
4. GitHub Secrets에 host, port, user, private key, host key를 등록한다.
5. 서버에 백엔드 `.env`를 배치하고 pnpm 실행 경로를 확정한다.
6. workflow와 PM2 설정을 반영한 뒤 수동 배포로 최초 검증한다.
7. 최초 성공 후 `main` push 자동 배포를 확인한다.

## 완료 기준

- 비밀번호 없이 전용 SSH 키로 서버 접속 성공
- GitHub Actions에서 프론트/백엔드 빌드 성공
- 두 PM2 프로세스가 `online`
- 서버 로컬에서 `3100`과 `3003` 상태 확인 성공
- 실패 시 Action이 성공으로 오인되지 않고 원인 로그를 제공
- 기존 서버 전용 설정 및 unrelated 프로젝트 파일이 보존됨
