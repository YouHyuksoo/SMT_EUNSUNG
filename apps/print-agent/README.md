# EUNSUNG Print Agent

EUNSUNG Print Agent는 은성 MES 작업자 PC에서 실행되는 로컬 출력 브릿지입니다. HANES Print Agent 를 가져와 은성용으로 바꾸고 BarTender 출력을 더했습니다.

웹 화면은 라벨을 PNG로 먼저 렌더링하고, 이 agent의 localhost API로 전송합니다. Agent는 라벨 디자인을 해석하지 않고 Windows 프린터 드라이버에 이미지를 전달합니다.

## 실행

```powershell
cd apps/print-agent
go run ./cmd/eunsung-print-agent
```

기본 주소는 `http://127.0.0.1:37111` 입니다.

Windows에서는 실행 후 시스템 트레이에 상주합니다. 트레이 아이콘 우클릭 메뉴는 다음 기능을 제공합니다.

- `상태 보기`: agent 실행 상태와 listen 주소 표시
- `설정`: 기본 브라우저로 agent 자체 설정관리 화면 열기
- `프린터 보기`: 현재 Windows 프린터 목록 표시
- `종료`: HTTP 서버와 tray agent 종료

## API

- `GET /health`
- `GET /printers`
- `GET /config`
- `POST /config`
- `GET /settings`
- `POST /print`
- `POST /print/bartender`
- `POST /test-print`

`POST /print` payload:

```json
{
  "jobId": "LBL2606170001",
  "printerName": "ZDesigner",
  "format": "png",
  "widthMm": 60,
  "heightMm": 40,
  "copies": 1,
  "contentBase64": "..."
}
```

`POST /print/bartender` payload (박스라벨):

```json
{
  "jobId": "BOX-M1590-...",
  "printerName": "",
  "copies": 1,
  "fileName": "양식.btw",
  "templateBase64": "...",
  "values": { "V1": "M1590-210601-001", "V7": "박스 바코드" }
}
```

- PB(`w_com_bartneder_form_popup`)와 같이 양식을 열고, 값이 비었거나 `NOTFOUND` 인 칸은 넣지 않고, `SetNamedSubStringValue` 로 값을 넣은 뒤 매수만큼 `PrintOut` 한다.
- `printerName` 이 비면 양식에 저장된 프린터로 찍는다. 에이전트 `defaultPrinter` 는 PNG 출력에만 쓴다.
- `exportPath` 를 주면 출력 대신 PNG 로 내보낸다 (확인용).
- 작업자 PC 에 BarTender (Automation 이상 에디션) 가 설치돼 있어야 한다. PowerShell 로 BarTender ActiveX 를 부르며, 형식 정보가 없어 모든 호출을 `InvokeMember` 로 한다. 64비트에 등록이 없으면 32비트 PowerShell 로 다시 부른다.
- 한 번에 한 작업만 돌린다. 양식 파일은 작업마다 임시 폴더에 쓰고 끝나면 지운다.

## 설정 파일

설정은 사용자 설정 디렉터리 아래 `EUNSUNG/print-agent/config.json`에 저장됩니다.

브라우저에서 `http://127.0.0.1:37111/settings`를 열면 agent가 직접 제공하는 설정관리 화면을 사용할 수 있습니다. 이 화면에서 agent 상태 확인, 프린터 목록 조회, 기본 프린터 저장, 테스트 출력, 허용 Origin, token, 로그 폴더, payload 제한을 관리합니다.

주요 값:

- `listenAddress`: 기본 `127.0.0.1:37111`
- `allowedOrigins`: 은성 MES 웹 origin 허용 목록
- `token`: 설정하면 요청 header `X-EUNSUNG-Print-Token` 또는 `Authorization: Bearer ...`로 검증
- `defaultPrinter`: `printerName`이 비어 있을 때 사용할 프린터
- `maxPayloadBytes`: PNG 출력 payload 최대 크기
- `logDir`: 출력 로그 jsonl 저장 폴더

`listenAddress` 변경은 실행 중인 HTTP 서버 포트를 즉시 바꾸지 않습니다. 설정 파일에 저장한 뒤 agent를 재시작해야 적용됩니다. `/config` 응답의 `effectiveListenAddress`는 현재 실행 중인 주소, `restartRequired`는 저장값과 실행값이 달라 재시작이 필요한지 여부입니다.

## 검증

```powershell
cd apps/print-agent
go test ./...
# BarTender 가 설치된 PC 에서 실제 양식을 PNG 로 내보내 확인 (test.btw, job.json 이 있는 폴더)
$env:EUNSUNG_BARTENDER_IT='C:\temp\bt'; go test ./internal/printer -run BarTenderExport -v
```

## 브라우저 로컬 네트워크 접근 정책 자동 등록 (2026-09-09)

https 로 서비스되는 MES(예: `https://mes.eunsung.example`)에서 브라우저가 이 에이전트(127.0.0.1)에 접근하려면
Chrome/Edge 가 "로컬 네트워크 접근 허용" 을 사용자에게 묻는다. 에이전트는 기동 시와 설정 저장 시 허용 Origin 중
**https origin** 을 아래 정책 키(HKCU, 관리자 권한 불필요)에 자동 등록해 확인창 없이 허용되게 한다.

- `HKCU\SOFTWARE\Policies\Google\Chrome\LocalNetworkAccessAllowedForUrls`
- `HKCU\SOFTWARE\Policies\Microsoft\Edge\LocalNetworkAccessAllowedForUrls`

브라우저는 재시작(또는 `chrome://policy` 새로고침) 후 반영한다. http 공인 주소 페이지는 브라우저가 "비보안 컨텍스트"
사유로 loopback 요청을 정책과 무관하게 차단하므로(Chrome 153 실측) 반드시 https 로 접속해야 한다.

빌드(창 없는 트레이 앱): `go build -trimpath -ldflags "-H=windowsgui -s -w" -o release/eunsung-print-agent.exe ./cmd/eunsung-print-agent`
배포본은 `apps/print-agent/release/eunsung-print-agent.exe` 로 git 에 포함한다(MES 백엔드가 이 경로를 우선 탐색).
