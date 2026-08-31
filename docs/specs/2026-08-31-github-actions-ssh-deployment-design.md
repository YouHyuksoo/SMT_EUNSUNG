# GitHub Actions SSH 배포 설계

## 목표

`main` 브랜치에 반영된 은성전장 MES 모노레포를 GitHub-hosted Runner에서 지성 개발서버로 SSH 배포한다. 프론트엔드와 백엔드를 함께 빌드하고 PM2로 실행한 뒤 실제 HTTP 상태를 확인한다.

## 배포 대상

- 저장소: `YouHyuksoo/SMT_EUNSUNG` (Public)
- 서버: 지성 개발서버 `139.150.82.207:22` (Windows Server 2019)
- 기존 체크아웃: `D:\Project\SMT_EUNSUNG` (배포 입력으로 사용하지 않음)
- 배포 루트: `D:\Deploy\SMT_EUNSUNG`
- 프론트엔드: `eunsung-frontend`, `0.0.0.0:3100`
- 백엔드: `eunsung-backend`, `0.0.0.0:3003`
- 프로세스 관리자: PM2
- 패키지 관리자: `pnpm@10.28.1`

## 실행 구조

GitHub Actions는 `main` push와 관리자 수동 실행으로 시작한다. 표준 GitHub-hosted Runner가 이벤트의 정확한 `${GITHUB_SHA}`를 체크아웃하고, 고정된 SSH host key와 배포 전용 키로 지성 개발서버에 접속한다. 체크아웃을 압축해 `releases/<GITHUB_SHA>`로 전송하고, 서버에서 의존성 설치, shared/백엔드/프론트 빌드, PM2 전환, HTTP 상태 확인을 순서대로 수행한다. 배포 완료 후 release의 커밋 표식이 `${GITHUB_SHA}`와 같은지 검증한다.

PR 및 fork 이벤트에서는 배포 job을 실행하지 않는다. 동시 배포는 workflow concurrency로 직렬화한다. workflow 권한은 `contents: read`로 제한하고, 외부 Action은 검토된 commit SHA로 고정한다. `known_hosts`는 GitHub Secret의 host key로 만들고 `StrictHostKeyChecking=yes`를 강제한다. 가능하면 GitHub Environment와 `main` 보호 규칙을 적용하며 로그에는 secret 값을 출력하지 않는다.

## 서버 전용 설정

다음 파일은 Git에 포함하지 않고 서버에만 유지한다.

- `D:\Deploy\SMT_EUNSUNG\shared\backend.env`: 최초 구성 시 현재 로컬 파일을 안전하게 복사한다.
- `D:\Deploy\SMT_EUNSUNG\shared\frontend-database.json`: 기존 서버 설정을 최초 구성 시 복사한다.

배포 전에 두 파일의 존재, 일반 파일 여부, reparse point가 아님을 검사한다. 각 release를 빌드하기 전에 해당 위치로 복사하되 내용이나 자격증명은 Actions 로그에 출력하지 않는다.

## Release 및 rollback 정책

기존 `D:\Project\SMT_EUNSUNG` 작업 트리는 수정하거나 배포 입력으로 사용하지 않는다. 따라서 현재 존재하는 `sw.js`, 로그, `package-lock.json` 변경도 덮어쓰지 않는다. GitHub에서 받은 정확한 커밋을 `D:\Deploy\SMT_EUNSUNG\releases\<sha>`에 새로 풀어 기존 실행 산출물과 빌드를 격리한다.

release 디렉터리는 신규 빈 디렉터리만 허용하며 reparse point를 거부한다. 설치와 모든 빌드가 성공한 뒤 PM2의 `cwd`를 새 release로 전환한다. 재시작 또는 health 검증 실패 시 직전 정상 release로 PM2를 되돌리고 다시 health를 확인한다. 최근 정상 release 3개만 보존하는 정리는 별도 성공 단계에서만 수행한다.

## 프로세스 구성

루트 PM2 설정은 프론트엔드와 백엔드를 각각 독립 앱으로 정의한다. `eunsung-frontend`는 release의 `apps/frontend`를 `cwd`로 하여 Next.js production server를 `3100`에서 실행한다. `eunsung-backend`는 release의 `apps/backend`를 `cwd`로 하여 `dist/main.js`를 실행하며 애플리케이션이 고정 포트 `3003`을 사용한다. `NODE_ENV`, `TZ`, Oracle Client 경로, 로그 경로를 명시하고 앱별 재시작 정책을 둔다.

PM2 실행 계정과 홈은 현재 운영 계정 `Administrator`, `PM2_HOME=C:\Users\Administrator\.pm2`로 고정하고 `pm2 save`로 프로세스 목록을 보존한다. Windows 재부팅 자동 시작은 기존 PM2 서비스 유무를 확인한 후 별도 초기 구성 단계에서 검증한다. 배포 전용 최소권한 계정이 더 안전하지만, 첫 구성은 기존 PM2 운영 계정과의 충돌을 피하기 위해 관리자 계정에 별도 키를 등록한다. 이 키는 서버 전체 관리자 권한을 가지므로 저장소 Environment 보호와 즉시 폐기 가능한 전용 키 사용을 필수로 한다.

배포 빌드가 모두 성공한 뒤에만 두 프로세스를 전환한다. 한쪽 빌드가 실패하면 기존 프로세스는 유지한다.

## Windows 원격 실행 계약

SSH 명령은 `powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -File <검토된 임시 스크립트>` 형태로 실행한다. 긴 inline 명령을 만들지 않고 저장소의 배포 스크립트를 전송해 실행한다. 스크립트는 `$ErrorActionPreference = 'Stop'`을 설정하고 모든 native command 뒤에서 `$LASTEXITCODE`를 검사한다.

비대화형 SSH에서 다음 절대 경로 또는 검증된 해석 결과를 고정한다.

- Node: `C:\Program Files\nodejs\node.exe` (지원 버전 검증)
- Git: `Get-Command git -All`로 확인
- pnpm: `C:\Users\Administrator\AppData\Roaming\npm\pnpm.cmd`
- PM2: `C:\Users\Administrator\AppData\Roaming\npm\pm2.cmd`
- PM2 home: `C:\Users\Administrator\.pm2`

pnpm이 없으면 초기 구성에서만 `npm install --global pnpm@10.28.1`을 실행하고 새 SSH 세션에서 버전을 재검증한다. 일반 배포는 도구를 설치하거나 업그레이드하지 않는다.

## 설치 및 빌드

각 release에서 다음을 exit code와 함께 순차 실행한다.

1. `pnpm --version`이 `10.28.1`인지 확인
2. `pnpm install --frozen-lockfile`
3. `pnpm --filter @smt/shared build`
4. `pnpm --filter @eunsung/backend build`
5. `pnpm --filter @eunsung/frontend build`

Node는 프로젝트 지원 범위와 실제 빌드 성공 여부를 확인한다. 최초 배포 전에 현재 `v26.5.1`로 검증하고 호환되지 않으면 Node 22 LTS를 별도 승인 후 설치한다.

## 실패 처리와 검증

- 필수 도구 또는 설정 파일 누락: 즉시 실패
- dirty worktree 또는 non-fast-forward: 즉시 실패
- 의존성 설치/빌드 실패: PM2 재시작 금지
- PM2 재시작 실패: 해당 앱 로그 출력 후 실패
- 상태 확인 실패: rollback 후 두 앱의 최근 PM2 로그와 상태 출력하고 실패

상태 확인은 각 요청에 timeout을 두고 제한된 횟수만 재시도한다. 프론트 `http://localhost:3100`은 정상 HTTP 응답을 확인한다. 백엔드 `http://localhost:3003/api/v1/health`는 HTTP 200만 보지 않고 JSON의 `status == "ok"`와 `database.status == "connected"`를 모두 확인한다. 추가로 PM2 앱 상태가 `online`인지, `3100`과 `3003`의 listening PID가 해당 PM2 프로세스인지 확인한다.

## 초기 구성

1. 이 저장소 전용 Ed25519 SSH 키를 생성한다.
2. 공개키를 지성 개발서버 `administrators_authorized_keys`에 등록하고 Windows OpenSSH 요구 ACL을 적용한다.
3. 키 인증과 SSH host key를 검증한다.
4. GitHub Secrets에 host, port, user, private key, host key를 등록한다.
5. 서버 shared 영역에 백엔드 `.env`와 프론트 DB 설정을 배치한다.
6. 비대화형 SSH에서 Node, Git, pnpm, PM2, Oracle Client 경로와 버전을 검증한다.
7. workflow와 PM2 설정을 반영한 뒤 수동 배포로 최초 검증한다.
8. 최초 성공 후 `main` push 자동 배포를 확인한다.

## 완료 기준

- 비밀번호 없이 전용 SSH 키로 서버 접속 성공
- GitHub Actions에서 프론트/백엔드 빌드 성공
- 두 PM2 프로세스가 `online`
- 서버 로컬에서 `3100`과 `3003` 상태 확인 성공
- 배포된 release 표식이 workflow의 `${GITHUB_SHA}`와 일치
- health 실패를 유도했을 때 직전 정상 release로 rollback
- 실패 시 Action이 성공으로 오인되지 않고 원인 로그를 제공
- 기존 서버 전용 설정 및 unrelated 프로젝트 파일이 보존됨
