---
sources:
  - PBL Library 10.5/*.srd
  - PBL Library 10.5/f_set_column_dddw.srf
  - docs/database/generated/pb-dddw-inventory.json
verifiedCommit: ae19adf
---

# PB DataWindow DDDW(vd_*) 인벤토리

PowerBuilder 화면을 웹으로 이관할 때, 코드·기준정보 컬럼이 **무엇을 원천으로 하는지**
판정하는 기준 자료다. PB DataWindow는 코드 컬럼에 DropDownDataWindow(DDDW)를 붙여
저장값은 코드, 화면에는 뜻을 보여준다. 이걸 놓치면 웹 그리드에 `P`, `M01` 같은 원시
코드가 그대로 노출된다.

- 생성: `python ~/.claude/skills/powerbuilder/scripts/pb_dddw_inventory.py --source-dir "PBL Library 10.5" --output docs/database/generated/pb-dddw-inventory.json`
- 기계 판독용 원본: `generated/pb-dddw-inventory.json`
- 변환 규칙: `powerbuilder` 스킬의 `references/conversion-patterns.md` — "코드 컬럼 표시값 변환(DDDW)"

## 이름으로 성격을 추정하지 않는다

성격은 그 DDDW 객체의 `FROM` 절이 결정한다. 이름과 실제가 어긋나는 사례가 있다.

- `vd_material_location_code` — 이름은 기준정보처럼 보이지만 `ISYS_BASECODE`를 읽는 **공통코드**다.
- `vd_line_code` / `vd_workstage_code` — 공통코드가 아니라 각자 전용 **기준정보 마스터**를 읽는다.
- `vd_standard_code` 계열 — `ISYS_CODE_MASTER`를 읽는 **다단 코드마스터**로, 공통코드와 다른 체계다.

| `kind` | 원천 | 웹 대응 |
|---|---|---|
| `basecode` | `ISYS_BASECODE` | 공통코드 조회 훅 / 공통코드 셀렉트 |
| `codemaster` | `ISYS_CODE_MASTER` (CODE_GROUP 3계층) | 계층 인자를 그대로 넘기는 전용 조회. 공통코드 훅으로 대체 금지 |
| `master` | 업무 마스터 테이블 | 해당 기준정보 Select / 조회 API |

## 인벤토리

`PBL Library 10.5` 기준. `retrieve 인자`는 웹에서 같은 목록을 가져올 때 필요한 파라미터와
같다 (`ORG`=테넌트, `LANG`=UI 언어, `CODE_TYPE`/`CODE_GROUP`=코드 구분값).

| DDDW | 정의 | 성격 | 원천 테이블 | retrieve 인자 | 사용 파일 | 컬럼 바인딩 |
|---|---|---|---|---|---|---|
| `vd_basecode` | O | basecode | ISYS_BASECODE | LANG, ORG, CODE_TYPE | 710 | 2607 |
| `vd_line_code` | O | master | IP_PRODUCT_LINE | ORG | 265 | 286 |
| `vd_workstage_code` | O | master | IP_PRODUCT_WORKSTAGE | ORG | 175 | 192 |
| `vd_user_name` | O | master | ISYS_USERS | ORG | 40 | 77 |
| `vd_organization_name` | O | master | ISYS_ORGANIZATION | - | 62 | 62 |
| `vd_machine_code` | O | master | IMCN_MACHINE | ORG | 46 | 46 |
| `vd_supplier_code` | O | master | ICOM_SUPPLIER | ORG | 28 | 41 |
| `vd_basecode_label_step` | O | basecode | ISYS_BASECODE | LANG, ORG | 2 | 40 |
| `vd_department_code` | O | master | ISYS_DEPARTMENT | LANGUAGE, ORG | 23 | 25 |
| `vd_customer_code` | O | master | ICOM_CUSTOMER | ORG | 15 | 15 |
| `vd_product_class_code` | O | master | ID_PRODUCT_CLASS | - | 13 | 13 |
| `vd_mold_location_code` | **없음** | - | - | - | 12 | 12 |
| `vd_wqc_standard_code` | O | codemaster | ISYS_CODE_MASTER | LANG, ORG | 12 | 12 |
| `vd_standard_code` | O | codemaster | ISYS_CODE_MASTER | LANG, ORG, CODE_TYPE, CODE_GROUP, CODE_GROUP_SECOND, CODE_GROUP_THIRD | 11 | 11 |
| `vd_workstage_routing_code` | O | master | IP_PRODUCT_ROUTING_MASTER | ORG | 11 | 11 |
| `vd_model_name` | **없음** | - | - | - | 10 | 10 |
| `vd_window_name` | O | master | ISYS_WINDOW | LANGUAGE, ORGANIZATION_ID | 6 | 8 |
| `vd_location_barcode` | O | master | IB_MACHINE_LOCATION | ORG | 7 | 7 |
| `vd_oqc_standard_code` | O | codemaster | ISYS_CODE_MASTER | LANG, ORG | 6 | 6 |
| `vd_set_item_code` | O | master | ID_ITEM | ORG | 6 | 6 |
| `vd_set_item_yn` | **없음** | - | - | - | 6 | 6 |
| `vd_item_class_code` | O | master | ID_ITEM_CLASS | - | 4 | 4 |
| `vd_material_location_code` | O | basecode | ISYS_BASECODE | LANG, ORG | 4 | 4 |
| `vd_account_code_all` | **없음** | - | - | - | 1 | 2 |
| `vd_iqc_standard_code` | O | codemaster | ISYS_CODE_MASTER | LANG, ORG | 2 | 2 |
| `vd_smt_machine_code` | O | master | IB_LINE_MASTER | ORG | 2 | 2 |
| `vd_company_code` | O | master | ISYS_COMPANY | - | 1 | 1 |
| `vd_customer_model_name` | **없음** | - | - | - | 1 | 1 |
| `vd_item_code` | O | master | ID_ITEM | ORG | 1 | 1 |
| `vd_mfs_revision` | **없음** | - | - | - | 1 | 1 |
| `vd_model_suffix_by_model` | O | master | ID_ITEM | MODEL_NAME, ORG | 1 | 1 |
| `vd_mold_code` | **없음** | - | - | - | 1 | 1 |
| `vd_mold_warehouse_code` | **없음** | - | - | - | 1 | 1 |
| `vd_plc_address_code` | **없음** | - | - | - | 1 | 1 |
| `vd_supplier_code_by_item` | **없음** | - | - | - | 1 | 1 |
| `vd_table_column_select` | O | master | USER_TAB_COLUMNS | LANGUAGE, TABLE_NAME | 1 | 1 |
| `vd_wqc_line_status_code` | O | codemaster | ISYS_CODE_MASTER | LANG, ORG | 1 | 1 |

합계: DDDW 37종 / 컬럼 바인딩 3,518건. 그중 `vd_basecode` 한 종이 2,607건(74%)이다.

## `vd_basecode`의 CODE_TYPE 도출

`vd_basecode`는 코드타입을 인자로 받는데, 그 값은 `f_set_column_dddw`가 **컬럼 이름에서
기계적으로 만든다.**

```
CODE_TYPE = UPPER(컬럼명의 '_' → ' ')
끝 2글자가 숫자면 떼어낸다   (같은 화면에 같은 코드 컬럼이 둘 이상일 때 쓰는 접미어)
```

예: `business_status` → `BUSINESS STATUS`, `inspect_method_01` → `INSPECT METHOD`

표시 문구는 언어에 따라 달라진다 — 한국어를 하드코딩하면 다국어에서 틀린다.

```sql
SELECT CODE_NAME,
       DECODE(:ARG_LANG, 'K', CODE_MEAN_KOR, 'E', CODE_MEAN_ENG, CODE_MEAN_LOCAL) AS CODE_MEAN
  FROM ISYS_BASECODE
 WHERE CODE_TYPE = :ARG_CODE_TYPE
   AND ORGANIZATION_ID = :ARG_ORG
```

## 정의를 못 찾은 DDDW

참조는 되는데 `PBL Library 10.5`에 객체가 없는 것들이다. 해당 컬럼을 이관할 때는
원천을 확정하기 전까지 임의로 옮기지 않는다.

| DDDW | 사용 파일 | 바인딩 | 확인 결과 |
|---|---|---|---|
| `vd_model_name` | 10 | 10 | `EUNSUNG_MES/vd_model_name.srd`에 있음 — `SELECT DISTINCT MODEL_NAME, MODEL_SUFFIX FROM IP_PRODUCT_MODEL_MASTER` (인자 없음) |
| `vd_mold_location_code` | 12 | 12 | 두 export 폴더 모두 없음 |
| `vd_set_item_yn` | 6 | 6 | 두 export 폴더 모두 없음 |
| `vd_account_code_all` | 1 | 2 | 두 export 폴더 모두 없음 |
| `vd_customer_model_name` / `vd_mfs_revision` / `vd_mold_code` / `vd_mold_warehouse_code` / `vd_plc_address_code` / `vd_supplier_code_by_item` | 각 1 | 각 1 | 두 export 폴더 모두 없음 |

`vd_model_name` 외 9종은 이 저장소의 PB export에 정의가 없다. 다른 PBL에서 export가
누락됐을 수 있으므로, 해당 컬럼이 걸린 화면을 이관할 때 원본 PBL을 확인한다.

## 갱신

PB 소스가 바뀌면 위 생성 명령을 다시 돌리고 `verifiedCommit`을 재스탬프한다.
대소문자만 다른 참조(`vd_Line_code` 등)는 생성기가 하나로 합친다.
