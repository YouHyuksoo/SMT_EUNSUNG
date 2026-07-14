#!/usr/bin/env python3
"""Export read-only INFINITY21_JSMES schema metadata to JSON and Markdown."""

from __future__ import annotations

import argparse
import datetime as dt
import json
import os
import re
import subprocess
from collections import defaultdict
from pathlib import Path
from typing import Any, Iterable

import oracledb


OWNER = "INFINITY21_JSMES"
DEFAULT_SITE = "ESDBext"
CONFIG_PATH = Path.home() / ".oracle_db_config.json"
ROOT = Path(__file__).resolve().parents[2]
DEFAULT_JSON = ROOT / "docs/database/generated/infinity21-jsmes-schema.json"
DEFAULT_MARKDOWN = ROOT / "docs/database/infinity21-jsmes-table-catalog.md"


DOMAIN_PREFIXES = {
    "IA_": "인터페이스",
    "IB_": "인터페이스",
    "IF_": "인터페이스",
    "II_": "인터페이스",
    "IM_": "자재/품목",
    "IP_": "생산",
    "IQ_": "품질",
    "IR_": "리포트",
    "IRPT_": "리포트",
    "ISYS_": "시스템/기준정보",
    "IV_": "재고",
}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--site", default=DEFAULT_SITE)
    parser.add_argument("--json-output", type=Path, default=DEFAULT_JSON)
    parser.add_argument("--markdown-output", type=Path, default=DEFAULT_MARKDOWN)
    return parser.parse_args()


def load_profile(site: str) -> dict[str, Any]:
    config = json.loads(CONFIG_PATH.read_text(encoding="utf-8"))
    try:
        return config["profiles"][site]
    except KeyError as exc:
        raise SystemExit(f"Oracle profile not found: {site}") from exc


def connect(profile: dict[str, Any]) -> oracledb.Connection:
    if profile.get("thick"):
        candidates = [
            os.environ.get("ORACLE_CLIENT_LIB"),
            r"C:\Util\WINDOWS.X64_193000_db_home\bin",
        ]
        for candidate in candidates:
            if candidate and Path(candidate).is_dir():
                try:
                    oracledb.init_oracle_client(lib_dir=candidate)
                except oracledb.ProgrammingError:
                    pass
                break
    dsn = oracledb.makedsn(
        profile["host"],
        profile["port"],
        service_name=profile["service_name"],
    )
    return oracledb.connect(
        user=profile["user"], password=profile["password"], dsn=dsn
    )


def rows(cursor: oracledb.Cursor, sql: str) -> list[dict[str, Any]]:
    cursor.execute(sql)
    columns = [column[0].lower() for column in cursor.description]
    return [dict(zip(columns, row)) for row in cursor.fetchall()]


def group(items: Iterable[dict[str, Any]], key: str) -> dict[str, list[dict[str, Any]]]:
    result: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for item in items:
        result[str(item[key])].append(item)
    return dict(result)


def domain_for(table_name: str) -> str:
    for prefix in sorted(DOMAIN_PREFIXES, key=len, reverse=True):
        if table_name.startswith(prefix):
            return DOMAIN_PREFIXES[prefix]
    upper = table_name.upper()
    if any(token in upper for token in ("LOG", "HIST", "HISTORY", "AUDIT")):
        return "이력/로그"
    if any(token in upper for token in ("SHIP", "DELIVERY", "CUSTOMER_ORDER")):
        return "출하"
    if any(token in upper for token in ("MAT_", "ITEM", "BOM")):
        return "자재/품목"
    if any(token in upper for token in ("PROD", "WORK", "ROUTING", "PROCESS")):
        return "생산"
    return "미분류"


def git_commit() -> str:
    return subprocess.check_output(
        ["git", "rev-parse", "--short", "HEAD"], cwd=ROOT, text=True
    ).strip()


def code_references(table_names: set[str]) -> dict[str, list[str]]:
    references: dict[str, set[str]] = defaultdict(set)
    roots = [ROOT / "apps/backend/src", ROOT / "apps/frontend/src"]
    extensions = {".ts", ".tsx", ".js", ".mjs", ".sql"}
    token_pattern = re.compile(r"\b[A-Z][A-Z0-9_$#]{2,}\b")
    for source_root in roots:
        if not source_root.exists():
            continue
        for path in source_root.rglob("*"):
            if not path.is_file() or path.suffix.lower() not in extensions:
                continue
            try:
                content = path.read_text(encoding="utf-8", errors="ignore").upper()
            except OSError:
                continue
            matched = table_names.intersection(token_pattern.findall(content))
            relative = path.relative_to(ROOT).as_posix()
            for table_name in matched:
                references[table_name].add(relative)
    return {name: sorted(paths) for name, paths in references.items()}


def join_columns(items: list[dict[str, Any]]) -> str:
    return ", ".join(str(item["column_name"]) for item in items) or "-"


def markdown_escape(value: Any) -> str:
    return str(value or "-").replace("|", "\\|").replace("\n", " ")


def main() -> None:
    args = parse_args()
    profile = load_profile(args.site)
    if profile.get("user", "").upper() != OWNER:
        raise SystemExit(
            f"Refusing export: profile owner is {profile.get('user')}, expected {OWNER}"
        )

    with connect(profile) as connection:
        with connection.cursor() as cursor:
            identity = rows(
                cursor,
                "SELECT USER owner, SYS_CONTEXT('USERENV','DB_NAME') db_name FROM DUAL",
            )[0]
            tables = rows(
                cursor,
                """
                SELECT t.table_name, t.num_rows, t.last_analyzed, c.comments
                  FROM user_tables t
                  LEFT JOIN user_tab_comments c ON c.table_name = t.table_name
                 ORDER BY t.table_name
                """,
            )
            columns = rows(
                cursor,
                """
                SELECT c.table_name, c.column_id, c.column_name, c.data_type,
                       c.data_length, c.data_precision, c.data_scale, c.nullable,
                       c.data_default, cc.comments
                  FROM user_tab_columns c
                  LEFT JOIN user_col_comments cc
                    ON cc.table_name = c.table_name AND cc.column_name = c.column_name
                 ORDER BY c.table_name, c.column_id
                """,
            )
            constraint_columns = rows(
                cursor,
                """
                SELECT c.table_name, c.constraint_name, c.constraint_type,
                       cc.column_name, cc.position
                  FROM user_constraints c
                  JOIN user_cons_columns cc ON cc.constraint_name = c.constraint_name
                 WHERE c.constraint_type IN ('P', 'U')
                 ORDER BY c.table_name, c.constraint_name, cc.position
                """,
            )
            foreign_keys = rows(
                cursor,
                """
                SELECT fk.constraint_name, fk.table_name, fkc.column_name,
                       pk.table_name referenced_table_name,
                       pkc.column_name referenced_column_name,
                       fkc.position, fk.delete_rule, fk.status
                  FROM user_constraints fk
                  JOIN user_cons_columns fkc ON fkc.constraint_name = fk.constraint_name
                  JOIN user_constraints pk ON pk.constraint_name = fk.r_constraint_name
                  JOIN user_cons_columns pkc
                    ON pkc.constraint_name = pk.constraint_name
                   AND pkc.position = fkc.position
                 WHERE fk.constraint_type = 'R'
                 ORDER BY fk.table_name, fk.constraint_name, fkc.position
                """,
            )
            dependencies = rows(
                cursor,
                """
                SELECT referenced_name table_name, name object_name, type object_type
                  FROM user_dependencies
                 WHERE referenced_owner = USER
                   AND referenced_type = 'TABLE'
                 ORDER BY referenced_name, type, name
                """,
            )
            objects = rows(
                cursor,
                """
                SELECT object_type, COUNT(*) object_count
                  FROM user_objects
                 GROUP BY object_type
                 ORDER BY object_type
                """,
            )

    table_names = {str(table["table_name"]) for table in tables}
    code_refs = code_references(table_names)
    columns_by_table = group(columns, "table_name")
    keys_by_table = group(constraint_columns, "table_name")
    fk_by_table = group(foreign_keys, "table_name")
    deps_by_table = group(dependencies, "table_name")
    inbound_fk: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for foreign_key in foreign_keys:
        inbound_fk[str(foreign_key["referenced_table_name"])].append(foreign_key)

    extracted_at = dt.datetime.now(dt.timezone(dt.timedelta(hours=9))).isoformat()
    catalog_tables = []
    for table in tables:
        name = str(table["table_name"])
        keys = keys_by_table.get(name, [])
        pk = [item for item in keys if item["constraint_type"] == "P"]
        unique = [item for item in keys if item["constraint_type"] == "U"]
        catalog_tables.append(
            {
                **table,
                "domain": domain_for(name),
                "columns": columns_by_table.get(name, []),
                "primary_key": pk,
                "unique_keys": unique,
                "foreign_keys": fk_by_table.get(name, []),
                "inbound_foreign_keys": inbound_fk.get(name, []),
                "database_references": deps_by_table.get(name, []),
                "code_references": code_refs.get(name, []),
            }
        )

    payload = {
        "metadata": {
            "site": args.site,
            "owner": identity["owner"],
            "database": identity["db_name"],
            "extracted_at": extracted_at,
            "verified_commit": git_commit(),
            "row_count_note": "USER_TABLES.NUM_ROWS statistics estimate; may be null or stale",
        },
        "object_counts": objects,
        "tables": catalog_tables,
    }
    args.json_output.parent.mkdir(parents=True, exist_ok=True)
    args.json_output.write_text(
        json.dumps(payload, ensure_ascii=False, indent=2, default=str) + "\n",
        encoding="utf-8",
    )

    domain_counts: dict[str, int] = defaultdict(int)
    for table in catalog_tables:
        domain_counts[str(table["domain"])] += 1

    lines = [
        "---",
        "sources:",
        "  - tools/database/export-infinity21-schema.py",
        "  - apps/backend/src/entities/",
        "  - apps/backend/src/modules/",
        "  - apps/frontend/src/lib/queries/",
        f"verifiedCommit: {git_commit()}",
        "---",
        "",
        "# INFINITY21_JSMES 테이블 카탈로그",
        "",
        f"- 추출 대상: `{identity['owner']}` @ `{identity['db_name']}` (`{args.site}`)",
        f"- 추출 시각: `{extracted_at}`",
        f"- 전체 테이블: **{len(catalog_tables)}개**",
        "- 행 수는 `USER_TABLES.NUM_ROWS` 통계 추정치이며 NULL이거나 오래되었을 수 있다.",
        "- 도메인은 명명 규칙 기반 1차 분류다. 업무 인터뷰와 코드/데이터 검증 후 확정한다.",
        "- 상세 컬럼·키·관계·참조 목록은 `generated/infinity21-jsmes-schema.json`에 있다.",
        "",
        "## 관계 신뢰도",
        "",
        "| 등급 | 판정 기준 |",
        "|---|---|",
        "| 확정 | Oracle FK/PK/UK 제약조건으로 확인 |",
        "| 검증 | PL/SQL·애플리케이션 조인과 실제 데이터로 확인 |",
        "| 추정 | 명명·컬럼·값 패턴만 일치 |",
        "| 미확정 | 근거 부족 또는 업무 확인 필요 |",
        "",
        "## 1차 도메인 분포",
        "",
        "| 도메인 | 테이블 수 |",
        "|---|---:|",
    ]
    for domain, count in sorted(domain_counts.items(), key=lambda item: (-item[1], item[0])):
        lines.append(f"| {domain} | {count} |")

    lines.extend(
        [
            "",
            "## 전체 테이블 인벤토리",
            "",
            "| 테이블 | 1차 도메인 | 용도 근거 | 행 수 추정 | PK | FK(나감/들어옴) | DB 참조 객체 | 코드 사용처 |",
            "|---|---|---|---:|---|---:|---:|---:|",
        ]
    )
    for table in catalog_tables:
        pk = join_columns(table["primary_key"])
        purpose = table["comments"] or "미확정"
        lines.append(
            "| {name} | {domain} | {purpose} | {rows} | {pk} | {outbound}/{inbound} | {deps} | {code} |".format(
                name=markdown_escape(table["table_name"]),
                domain=markdown_escape(table["domain"]),
                purpose=markdown_escape(purpose),
                rows=markdown_escape(table["num_rows"]),
                pk=markdown_escape(pk),
                outbound=len({item["constraint_name"] for item in table["foreign_keys"]}),
                inbound=len({item["constraint_name"] for item in table["inbound_foreign_keys"]}),
                deps=len({(item["object_type"], item["object_name"]) for item in table["database_references"]}),
                code=len(table["code_references"]),
            )
        )

    args.markdown_output.parent.mkdir(parents=True, exist_ok=True)
    args.markdown_output.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(
        json.dumps(
            {
                "success": True,
                "site": args.site,
                "owner": identity["owner"],
                "tables": len(catalog_tables),
                "json": str(args.json_output.relative_to(ROOT)),
                "markdown": str(args.markdown_output.relative_to(ROOT)),
            },
            ensure_ascii=False,
            indent=2,
        )
    )


if __name__ == "__main__":
    main()
