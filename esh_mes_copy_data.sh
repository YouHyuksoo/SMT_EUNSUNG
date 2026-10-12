#!/bin/bash
# esh_mes 기준정보 데이터 복사 — ESDBPDB(ES_JSIDC) → esh_mes
# 대상 8개 테이블 / 4,849건. 실적·이벤트성 2개(IP_EQUIP_DOWNTIME_RESULT, OEE_DOWNTIME_EVENT)는 제외한다.
#
# 선행 조건: esh_mes_apply_all.sql 로 테이블이 먼저 생성돼 있어야 한다.
# 이 스크립트는 APPEND 방식이라 기존 데이터를 지우지 않는다. 재실행 시 PK 중복이 나면
# --skip-duplicates 를 붙여 이미 있는 행을 건너뛴다.
set -u
CONN=~/.claude/skills/oracle-db/scripts/copy_table_sequential.py
SKIP=${SKIP_DUP:-}          # SKIP_DUP=--skip-duplicates 로 재실행 가능

TABLES=(
  IP_EQUIP_DOWNTIME_REASON        # 사유코드 10
  IP_EQUIP_DOWNTIME_MAP           # 사유 연계 헤더 120
  IP_EQUIP_DOWNTIME_MAP_DTL       # 사유 연계 상세 1,200
  IP_PRODUCT_ST_MASTER            # 표준시간 3,421
  IP_PRODUCT_CALENDAR_SHIFT       # 일자별 교대 46
  IP_PRODUCT_CALENDAR_BREAK       # 일자별 휴게 46
  IP_SHIFT_TIME_BREAK             # 교대 휴게구간 4
  IP_PRODUCT_CALENDAR_LINE_RUN    # 라인 추가 운영 2
)

fail=0
for t in "${TABLES[@]}"; do
  echo "=== $t"
  python3 "$CONN" "$t" --from ES_JSIDC --to esh_mes $SKIP || { echo "!! $t 실패"; fail=$((fail+1)); }
done
echo
echo "완료 — 실패 $fail개"
