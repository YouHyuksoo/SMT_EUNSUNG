# 서버 이름 변경 계획 — BJV-SVR (SET / SMT)

> 상태: **✅ 적용 완료 (2026-06-03)**. SET → BJV-SVR03, SMT → BJV-SVR01 변경 및 재부팅·검증 완료.
> 작성 근거: 2026-06-03 두 서버 원격 조사 결과(실측).

## ✅ 적용 결과 (2026-06-03)

| 서버 | 호스트명 | Oracle | 검증 |
|---|---|---|---|
| SET 10.10.20.200 | `BJV-SVR03` ✅ | listener.ora HOST→IP, local_listener→IP(scope=both) 적용 | DB OPEN/READ WRITE, 리스너 `xe` READY (established 22, refused 0) ✅ |
| SMT 10.10.10.200 | `BJV-SVR01` ✅ | 변경 없음(전부 IP) | DB OPEN/READ WRITE, 리스너 `xe` READY (refused 0) ✅ |

- 이름 충돌 없음(SET 먼저 BJV-SVR03 확정 후 SMT가 BJV-SVR01 차지).
- 재부팅 후 SMT는 인스턴스 기동(START_PENDING)에 ~2분 소요 후 정상 OPEN.
- **남은 작업(사용자측)**: 호스트명으로 접속하는 외부 클라이언트가 있으면 DNS/hosts 매핑 갱신
  (`BJV-SVR03→10.10.20.200`, `BJV-SVR01→10.10.10.200`, 옛 `BJV-SVR01→10.10.20.200` 제거).
- 백업 보존: 양 서버 `network\admin\*.bak_rename`. SET `tnsnames.ora`의 stale `WIN-1E6LRLGS50D`(XE 엔트리) 및 EM DB Console는 미손댐(선택 작업).

## 1. 변경 개요

| 서버 | IP | 현재 이름(As-Is) | 변경 이름(To-Be) | Oracle |
|---|---|---|---|---|
| R750 SET MES | 10.10.20.200 | `BJV-SVR01` | `BJV-SVR03` | 11g (`OraDb11g_home1`, SID=XE) |
| R440 SMT MES | 10.10.10.200 | `BJV-MES-SMT` | `BJV-SVR01` | 19c (`OraDB19Home1`, SID=XE) |

**⚠️ 이름 교차(재사용)**: `BJV-SVR01` 이 SET → SMT 로 **이동**한다. 동시에 두 서버가 `BJV-SVR01` 이 되면 안 되므로 **SET을 먼저 완료·검증한 뒤** SMT를 변경한다(순서 강제).

## 2. 실측 조사 결과 (근거)

**SET (10.10.20.200) — ORACLE_HOME `D:\app\Administrator\product\11.2.0\dbhome_1`**
- `listener.ora`: `(ADDRESS = (PROTOCOL = TCP)(HOST = BJV-SVR01)(PORT = 1521))` ← **호스트명 하드코딩, 수정 필요**
- `tnsnames.ora`: `XE` 엔트리가 `HOST = WIN-1E6LRLGS50D` (더 오래된 옛 이름, **기존부터 stale**) — 본 변경과 무관, 별도 플래그
- `sqlnet.ora`: 호스트명 없음
- DB `local_listener` = **비어있음(기본값)** → 재기동 시 현재 호스트명으로 자동 등록, 이름변경 후 정상
- `service_names` = `XE`
- 도메인: **WORKGROUP** (미가입)
- 부가: `OracleDBConsoleXE`(EM DB Console) 실행 중 — 호스트명 기반 설정폴더라 rename 시 깨짐. MES 운영엔 무관, 필요 시 `emca` 재구성

**SMT (10.10.10.200) — ORACLE_HOME `D:\WINDOWS.X64_193000_db_home`**
- `listener.ora`: `(HOST = 10.10.10.200)` ← **IP, 영향 없음**
- `tnsnames.ora`: 모든 엔트리 `HOST = 10.10.10.200` ← **IP, 영향 없음**
- `sqlnet.ora`: 호스트명 없음
- DB `local_listener` = `(ADDRESS=(PROTOCOL=TCP)(HOST=10.10.10.200)(PORT=1521))` ← **IP, 영향 없음**
- `service_names` = `XE`
- 도메인: **WORKGROUP** (미가입)

**이 MES 앱(WebDisplayBJ)**: `config/database.json` 이 두 DB를 **IP로 접속**(10.10.20.200 / 10.10.10.200) → 이름 변경 영향 **없음**.

## 3. 변경 대상 정리

| 서버 | 수정 파일/항목 | 변경 내용 | 필수? |
|---|---|---|---|
| SET | `...\network\admin\listener.ora` | `HOST = BJV-SVR01` → `HOST = 10.10.20.200` (IP, rename 무관하게 견고) | **필수** |
| SET | Windows 컴퓨터 이름 | `BJV-SVR01` → `BJV-SVR03` (+재부팅) | **필수** |
| SMT | Windows 컴퓨터 이름 | `BJV-MES-SMT` → `BJV-SVR01` (+재부팅) | **필수** |
| SMT | Oracle 설정 | **변경 없음** (전부 IP) | - |
| SET | `tnsnames.ora` XE→`WIN-1E6LRLGS50D` | (선택) IP로 정정 | 선택 |
| SET | EM DB Console | (선택) `emca` 재구성 | 선택 |

> listener.ora를 **호스트명(BJV-SVR03)이 아닌 IP**로 바꾸는 이유: 재부팅 전/후 어느 시점에도 바인딩이 유효 → 재부팅 한 번으로 깔끔하게 끝남. (이름으로 넣으면 재부팅 후에만 해석되어 순서가 까다로워짐.)

## 4. 🔴 적용 전 필수 확인 (BLOCKING GATE — 사용자 확인 필요)

이름 해석(name resolution) 때문에 **잘못된 DB에 조용히 연결**될 수 있다. 적용 전 반드시 확인:

1. **호스트명으로 DB에 접속하는 클라이언트가 있는가?**
   - 다른 서버/PC의 `tnsnames.ora`, 앱 연결문자열, ODBC DSN, 배치 등에서 `BJV-SVR01` 또는 `BJV-MES-SMT` 를 **이름으로** 참조하는지.
   - 본 MES 앱은 IP라 안전하나, **다른 클라이언트는 여기서 확인 불가** → 사용자 확인 필수.
   - SMT가 `BJV-SVR01` 이 된 뒤, 옛 `BJV-SVR01`(SET) 을 이름으로 찾던 클라이언트는 **10.10.10.200(SMT, 다른 DB)** 로 붙는다.

2. **DNS / hosts / WINS 레코드 갱신 계획**:
   - 기존 `BJV-SVR01 → 10.10.20.200` 레코드 **제거/재지정**
   - 신규 `BJV-SVR03 → 10.10.20.200` 추가
   - 신규 `BJV-SVR01 → 10.10.10.200` 확인/추가
   - 사내 DNS 서버 사용 시 정적 레코드 직접 수정. 클라이언트 hosts 파일에 박혀있으면 각각 수정.

3. **변경 시점**: MES 가동 중단 가능한 시간대인가(재부팅 2회 발생).

> 위 3개가 정리되기 전에는 Phase A/B를 실행하지 않는다.

## 5. 실행 스크립트 (지시 시 순서대로 실행)

모든 명령은 로컬에서 `remote-ssh.py` 헬퍼로 원격 실행. SET/SMT 비밀번호: `admin12#`.

### Phase 0 — 백업 (양쪽 동시 가능, 비파괴)

```powershell
# SET 백업
python C:/Users/hsyou/.claude/scripts/remote-ssh.py --host 10.10.20.200 --port 22 --user administrator --password 'admin12#' exec 'powershell -command "$d=''D:\app\Administrator\product\11.2.0\dbhome_1\network\admin''; Copy-Item $d\listener.ora $d\listener.ora.bak_rename -Force; Copy-Item $d\tnsnames.ora $d\tnsnames.ora.bak_rename -Force; Get-Content $d\listener.ora.bak_rename"'

# SMT 백업 (Oracle 변경 없지만 안전상)
python C:/Users/hsyou/.claude/scripts/remote-ssh.py --host 10.10.10.200 --port 22 --user administrator --password 'admin12#' exec 'powershell -command "$d=''D:\WINDOWS.X64_193000_db_home\network\admin''; Copy-Item $d\listener.ora $d\listener.ora.bak_rename -Force; Copy-Item $d\tnsnames.ora $d\tnsnames.ora.bak_rename -Force"'
```

### Phase A — SET 서버 (BJV-SVR01 → BJV-SVR03)

**A-1. listener.ora HOST 수정 (BJV-SVR01 → IP)**
```powershell
python C:/Users/hsyou/.claude/scripts/remote-ssh.py --host 10.10.20.200 --port 22 --user administrator --password 'admin12#' exec 'powershell -command "$f=''D:\app\Administrator\product\11.2.0\dbhome_1\network\admin\listener.ora''; (Get-Content $f -Raw) -replace ''HOST = BJV-SVR01'',''HOST = 10.10.20.200'' | Set-Content $f -Encoding ASCII; Get-Content $f"'
```
→ 출력에 `(HOST = 10.10.20.200)` 확인.

**A-2. 리스너 재시작 + 정상 확인 (재부팅 전 사전 검증)**
```powershell
python C:/Users/hsyou/.claude/scripts/remote-ssh.py --host 10.10.20.200 --port 22 --user administrator --password 'admin12#' exec 'net stop OracleOraDb11g_home1TNSListener & net start OracleOraDb11g_home1TNSListener & D:\app\Administrator\product\11.2.0\dbhome_1\bin\lsnrctl status'
```
→ `XE` 서비스가 listener에 등록(READY)되는지 확인. 안 되면 중단·롤백.

**A-3. 컴퓨터 이름 변경 + 재부팅**
```powershell
python C:/Users/hsyou/.claude/scripts/remote-ssh.py --host 10.10.20.200 --port 22 --user administrator --password 'admin12#' exec 'powershell -command "Rename-Computer -NewName BJV-SVR03 -Force; shutdown /r /t 5"'
```
→ SSH 끊김. 1~3분 대기 후 재접속.

**A-4. 재부팅 후 검증**
```powershell
python C:/Users/hsyou/.claude/scripts/remote-ssh.py --host 10.10.20.200 --port 22 --user administrator --password 'admin12#' exec 'hostname & echo --- & sc query OracleServiceXE | findstr STATE & sc query OracleOraDb11g_home1TNSListener | findstr STATE & echo --- & D:\app\Administrator\product\11.2.0\dbhome_1\bin\lsnrctl status'
```
→ `BJV-SVR03`, OracleServiceXE/리스너 RUNNING, 리스너에 XE READY 확인.
→ DB 접속 확인: `(echo select 1 from dual; & echo exit) | sqlplus -s / as sysdba`

**A-5. SET 완료 확인 후에만 Phase B 진행.** (DNS: `BJV-SVR03 → 10.10.20.200` 등록, 옛 `BJV-SVR01` 레코드 제거)

### Phase B — SMT 서버 (BJV-MES-SMT → BJV-SVR01)

> Phase A가 완전히 끝나 `BJV-SVR01` 이름이 SET에서 해제된 뒤에만 실행.

**B-1. 컴퓨터 이름 변경 + 재부팅** (Oracle 파일 수정 불필요)
```powershell
python C:/Users/hsyou/.claude/scripts/remote-ssh.py --host 10.10.10.200 --port 22 --user administrator --password 'admin12#' exec 'powershell -command "Rename-Computer -NewName BJV-SVR01 -Force; shutdown /r /t 5"'
```

**B-2. 재부팅 후 검증**
```powershell
python C:/Users/hsyou/.claude/scripts/remote-ssh.py --host 10.10.10.200 --port 22 --user administrator --password 'admin12#' exec 'hostname & echo --- & sc query OracleServiceXE | findstr STATE & sc query OracleOraDB19Home1TNSListener | findstr STATE & echo --- & D:\WINDOWS.X64_193000_db_home\bin\lsnrctl status'
```
→ `BJV-SVR01`, 서비스 RUNNING, 리스너 XE READY 확인.

**B-3. DNS: `BJV-SVR01 → 10.10.10.200` 확인/등록.**

### Phase C — 최종 검증
- 이 MES 앱에서 두 화면 모두 데이터 정상 표시(IP 접속이라 영향 없어야 함).
- 호스트명으로 붙던 클라이언트(있다면)들이 올바른 DB로 연결되는지 확인.

## 6. 롤백

각 서버 독립 롤백 가능:
- **listener.ora**: `Copy-Item ...\listener.ora.bak_rename ...\listener.ora -Force` 후 리스너 재시작.
- **컴퓨터 이름**: `Rename-Computer -NewName <원래이름> -Force; shutdown /r /t 5`.
- 워크그룹이라 AD 정리 불필요. DNS 레코드도 원복.

## 7. 비고 (선택 작업)
- SET `tnsnames.ora` 의 `XE`→`WIN-1E6LRLGS50D` 는 기존부터 깨진 stale 엔트리. 원하면 `HOST = 10.10.20.200` 으로 정정.
- SET EM DB Console(`OracleDBConsoleXE`)은 rename 후 미동작. 사용 안 하면 무시, 사용 시 `emca -config dbcontrol db` 재구성.
