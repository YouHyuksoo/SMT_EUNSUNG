# 은성 전장 OEE 관리 매뉴얼(PPT) — 결정 기록

작성일 2026-09-11

## 결정 #1 — 대상 메뉴는 `menuConfig.ts`를 단일 출처로 삼는다

사용자 요청은 "기준정보 중 라우팅관리·작업지도서관리·창고관리 제외", "OEE 관리 중 공정별
OEE 종합·OEE 종합 현황 제외"다. 메뉴 라벨은 `apps/frontend/src/locales/ko.json`, 구성은
`apps/frontend/src/config/menuConfig.ts`에 있으므로 두 파일을 대조해 20개 화면을 확정했다.

제외 대상 코드. `MST_ROUTING` · `MST_WORK_INST` · `MST_WAREHOUSE` · `OEE_DASHBOARD` ·
`OEE_OVERALL_STATUS`.

사이드바에 없는 화면(`OEE_MST_RESOURCE` OEE 라인 관리, `equip-ops-analysis`)은 메뉴에서
숨긴 화면이라 매뉴얼에서도 뺀다.

## 결정 #2 — 산출물은 `docs/presentations/`에 둔다

`docs/README.md` 특화 폴더 등록부가 "발표·데모용 렌더 산출물(HTML·PDF·PPTX)"을
`presentations/`로 지정한다. 명명규칙 `YYYY-MM-DD-주제` 를 따라
`2026-09-11-eunsung-oee-manual.pptx`로 만든다. 작업 기록(이 문서와 checklist)은 기록형인
`docs/reports/2026-09-11-oee-manual/`에 둔다.

## 결정 #3 — 슬라이드는 화면당 1장, 좌 캡처 / 우 절차

사용자 선택. 캡처 위에 번호 마커(①②③)를 얹고 오른쪽 절차 문장에 같은 번호를 달아
시선이 한 번에 연결되게 한다. 화면당 2장(캡처 전면 + 절차)은 40장이 넘어 반려했다.

## 결정 #4 — 캡처는 Playwright로 직접 수행한다

사용자 선택. `claude-in-chrome`은 이번 세션에서 사용자가 확장 설치를 거부해 쓰지 않는다.
dev 서버(localhost:3100)는 사용자가 이미 띄워둔 것을 쓰고, 임의로 서버를 기동하지 않는다
(CLAUDE.md Execution & Verification).

캡처는 로그인이 필요하다. 로그인은 `ISYS_USERS.USER_ID` + 평문 `PASSWORD` 비교이고
(`auth.service.ts:74`), USER_LEVEL 9인 ADMIN 계정만 전 메뉴를 볼 수 있다 — 일반 사용자도
메뉴가 보이도록 고친 커밋(`0673e25`) 이후에는 LV 무관하게 전체 메뉴가 보이지만, 매뉴얼은
관리자 기준 화면으로 통일한다.

## 결정 #5 — 캡처 원본은 스크래치패드에 두고 PPT에 임베드한다

`docs/` 등록부에 이미지 자산 폴더가 없다(규정 2: 등록부에 없는 폴더 생성 금지). PPTX에
이미지가 포함되므로 원본은 세션 스크래치패드에 두고 산출물만 저장소에 남긴다. 재캡처가
필요하면 이 문서의 화면 목록과 checklist 순번으로 다시 만든다.
