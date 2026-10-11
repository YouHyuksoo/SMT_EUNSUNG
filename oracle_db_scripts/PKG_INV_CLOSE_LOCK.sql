-- 2026-10-11 재고마감 잠금
-- 마감한 기간으로 입출고·조정 원장이 들어오거나(INSERT), 수량·날짜·키가 바뀌거나(UPDATE), 지워지면(DELETE)
-- 거절한다. 웹·PDA·PB·DB 잡이 모두 같은 원장에 쓰므로 DB 에서 막는다.
--
-- 판단: 재고 종류마다 "마지막 마감월의 종료일"(closed_through)을 구하고, 원장 날짜가 그날 이하면 마감된 기간이다.
--   마감은 첫 달이거나 마지막 마감월의 다음 달만 할 수 있어(백엔드 서비스가 강제) 마감월이 끊기지 않으므로
--   마지막 마감월의 종료일 하나로 판단할 수 있다. 기간은 ISYS_INVENTORY_CLOSE_DATE(없으면 달력 월) —
--   백엔드 close-period.ts 와 같은 F_GET_INVENTORY_CLOSE_DATE 를 쓴다.
--     자재 MAT: ISYS_INVENTORY_CLOSE_DATE.CLOSE_YN = 'Y'
--     공정 WIP: IM_ITEM_WORKSTAGE_INV_CLOSE 에 그 달 행이 있음
--     제품 FG : IP_PRODUCT_FG_INV_CLOSE_MONTH.CLOSE_YN = 'Y'
-- 상태만 바꾸는 UPDATE(입고취소·출고취소가 원 행에 'C' 를 찍는 것 등)는 막지 않는다 — 트리거가 수량·날짜·키
-- 칼럼 UPDATE 에만 걸린다. 오류 번호는 -20090.

CREATE OR REPLACE PACKAGE PKG_INV_CLOSE_LOCK AS
   /** 그 재고 종류의 마지막 마감월 종료일(날짜만). 마감한 달이 없으면 NULL. */
   FUNCTION closed_through (p_kind IN VARCHAR2, p_org IN NUMBER) RETURN DATE;

   /** 원장 날짜가 마감된 기간이면 -20090 으로 거절한다. */
   PROCEDURE assert_open (p_date IN DATE, p_through IN DATE, p_ledger IN VARCHAR2);
END PKG_INV_CLOSE_LOCK;
/

CREATE OR REPLACE PACKAGE BODY PKG_INV_CLOSE_LOCK AS
   FUNCTION closed_through (p_kind IN VARCHAR2, p_org IN NUMBER) RETURN DATE IS
      v_ym VARCHAR2(6);
   BEGIN
      IF p_kind = 'MAT' THEN
         SELECT MAX(close_yyyymm) INTO v_ym FROM isys_inventory_close_date
          WHERE organization_id = p_org AND close_yn = 'Y';
      ELSIF p_kind = 'WIP' THEN
         SELECT MAX(close_yyyymm) INTO v_ym FROM im_item_workstage_inv_close
          WHERE organization_id = p_org;
      ELSIF p_kind = 'FG' THEN
         SELECT MAX(close_yyyymm) INTO v_ym FROM ip_product_fg_inv_close_month
          WHERE organization_id = p_org AND close_yn = 'Y';
      END IF;
      IF v_ym IS NULL THEN
         RETURN NULL;
      END IF;
      RETURN TRUNC(f_get_inventory_close_date(v_ym, 'END', p_org));
   END closed_through;

   PROCEDURE assert_open (p_date IN DATE, p_through IN DATE, p_ledger IN VARCHAR2) IS
   BEGIN
      IF p_date IS NOT NULL AND p_through IS NOT NULL AND TRUNC(p_date) <= p_through THEN
         RAISE_APPLICATION_ERROR(-20090,
            p_ledger || ' ' || TO_CHAR(p_date, 'YYYY-MM-DD') || ' 은 재고마감된 기간입니다 ('
            || TO_CHAR(p_through, 'YYYY-MM-DD') || ' 까지 마감). 마감을 취소하거나 마감 이후 날짜로 넣으세요.');
      END IF;
   END assert_open;
END PKG_INV_CLOSE_LOCK;
/

-- 원장마다 compound trigger 하나. 마감 종료일은 문장마다 조직별로 한 번만 읽는다
-- (생산투입 잡은 한 문장에 수천 행을 넣는다).

CREATE OR REPLACE TRIGGER TRG_IM_ITEM_RECEIPT_LOCK
   FOR INSERT OR DELETE OR UPDATE OF receipt_date, receipt_qty, item_code, material_mfs, location_code, line_type
   ON im_item_receipt
   COMPOUND TRIGGER
   TYPE t_map IS TABLE OF DATE INDEX BY PLS_INTEGER;
   g_through t_map;
   FUNCTION through (p_org NUMBER) RETURN DATE IS
   BEGIN
      IF NOT g_through.EXISTS(p_org) THEN g_through(p_org) := pkg_inv_close_lock.closed_through('MAT', p_org); END IF;
      RETURN g_through(p_org);
   END;
   BEFORE EACH ROW IS
   BEGIN
      IF INSERTING OR UPDATING THEN pkg_inv_close_lock.assert_open(:NEW.receipt_date, through(:NEW.organization_id), '자재입고'); END IF;
      IF DELETING OR UPDATING THEN pkg_inv_close_lock.assert_open(:OLD.receipt_date, through(:OLD.organization_id), '자재입고'); END IF;
   END BEFORE EACH ROW;
END TRG_IM_ITEM_RECEIPT_LOCK;
/

CREATE OR REPLACE TRIGGER TRG_IM_ITEM_ISSUE_LOCK
   FOR INSERT OR DELETE OR UPDATE OF issue_date, issue_qty, item_code, material_mfs, location_code, line_type, issue_account
   ON im_item_issue
   COMPOUND TRIGGER
   TYPE t_map IS TABLE OF DATE INDEX BY PLS_INTEGER;
   g_through t_map;
   FUNCTION through (p_org NUMBER) RETURN DATE IS
   BEGIN
      IF NOT g_through.EXISTS(p_org) THEN g_through(p_org) := pkg_inv_close_lock.closed_through('MAT', p_org); END IF;
      RETURN g_through(p_org);
   END;
   BEFORE EACH ROW IS
   BEGIN
      IF INSERTING OR UPDATING THEN pkg_inv_close_lock.assert_open(:NEW.issue_date, through(:NEW.organization_id), '자재출고'); END IF;
      IF DELETING OR UPDATING THEN pkg_inv_close_lock.assert_open(:OLD.issue_date, through(:OLD.organization_id), '자재출고'); END IF;
   END BEFORE EACH ROW;
END TRG_IM_ITEM_ISSUE_LOCK;
/

CREATE OR REPLACE TRIGGER TRG_IM_WS_RECEIPT_LOCK
   FOR INSERT OR DELETE OR UPDATE OF receipt_date, receipt_qty, item_code
   ON im_item_workstage_receipt
   COMPOUND TRIGGER
   TYPE t_map IS TABLE OF DATE INDEX BY PLS_INTEGER;
   g_through t_map;
   FUNCTION through (p_org NUMBER) RETURN DATE IS
   BEGIN
      IF NOT g_through.EXISTS(p_org) THEN g_through(p_org) := pkg_inv_close_lock.closed_through('WIP', p_org); END IF;
      RETURN g_through(p_org);
   END;
   BEFORE EACH ROW IS
   BEGIN
      IF INSERTING OR UPDATING THEN pkg_inv_close_lock.assert_open(:NEW.receipt_date, through(:NEW.organization_id), '공정입고'); END IF;
      IF DELETING OR UPDATING THEN pkg_inv_close_lock.assert_open(:OLD.receipt_date, through(:OLD.organization_id), '공정입고'); END IF;
   END BEFORE EACH ROW;
END TRG_IM_WS_RECEIPT_LOCK;
/

CREATE OR REPLACE TRIGGER TRG_IM_WS_ISSUE_LOCK
   FOR INSERT OR DELETE OR UPDATE OF issue_date, issue_qty, item_code
   ON im_item_workstage_issue
   COMPOUND TRIGGER
   TYPE t_map IS TABLE OF DATE INDEX BY PLS_INTEGER;
   g_through t_map;
   FUNCTION through (p_org NUMBER) RETURN DATE IS
   BEGIN
      IF NOT g_through.EXISTS(p_org) THEN g_through(p_org) := pkg_inv_close_lock.closed_through('WIP', p_org); END IF;
      RETURN g_through(p_org);
   END;
   BEFORE EACH ROW IS
   BEGIN
      IF INSERTING OR UPDATING THEN pkg_inv_close_lock.assert_open(:NEW.issue_date, through(:NEW.organization_id), '공정출고'); END IF;
      IF DELETING OR UPDATING THEN pkg_inv_close_lock.assert_open(:OLD.issue_date, through(:OLD.organization_id), '공정출고'); END IF;
   END BEFORE EACH ROW;
END TRG_IM_WS_ISSUE_LOCK;
/

CREATE OR REPLACE TRIGGER TRG_FG_RECEIPT_LOCK
   FOR INSERT OR DELETE OR UPDATE OF receipt_date, qty, barcode, location_code, model_name, model_suffix, item_code
   ON ip_product_fg_receipt
   COMPOUND TRIGGER
   TYPE t_map IS TABLE OF DATE INDEX BY PLS_INTEGER;
   g_through t_map;
   FUNCTION through (p_org NUMBER) RETURN DATE IS
   BEGIN
      IF NOT g_through.EXISTS(p_org) THEN g_through(p_org) := pkg_inv_close_lock.closed_through('FG', p_org); END IF;
      RETURN g_through(p_org);
   END;
   BEFORE EACH ROW IS
   BEGIN
      IF INSERTING OR UPDATING THEN pkg_inv_close_lock.assert_open(:NEW.receipt_date, through(:NEW.organization_id), '제품입고'); END IF;
      IF DELETING OR UPDATING THEN pkg_inv_close_lock.assert_open(:OLD.receipt_date, through(:OLD.organization_id), '제품입고'); END IF;
   END BEFORE EACH ROW;
END TRG_FG_RECEIPT_LOCK;
/

CREATE OR REPLACE TRIGGER TRG_FG_ISSUE_LOCK
   FOR INSERT OR DELETE OR UPDATE OF issue_date, qty, barcode, location_code, model_name, model_suffix, item_code
   ON ip_product_fg_issue
   COMPOUND TRIGGER
   TYPE t_map IS TABLE OF DATE INDEX BY PLS_INTEGER;
   g_through t_map;
   FUNCTION through (p_org NUMBER) RETURN DATE IS
   BEGIN
      IF NOT g_through.EXISTS(p_org) THEN g_through(p_org) := pkg_inv_close_lock.closed_through('FG', p_org); END IF;
      RETURN g_through(p_org);
   END;
   BEFORE EACH ROW IS
   BEGIN
      IF INSERTING OR UPDATING THEN pkg_inv_close_lock.assert_open(:NEW.issue_date, through(:NEW.organization_id), '제품출고'); END IF;
      IF DELETING OR UPDATING THEN pkg_inv_close_lock.assert_open(:OLD.issue_date, through(:OLD.organization_id), '제품출고'); END IF;
   END BEFORE EACH ROW;
END TRG_FG_ISSUE_LOCK;
/

CREATE OR REPLACE TRIGGER TRG_FG_ADJUST_LOCK
   FOR INSERT OR DELETE OR UPDATE OF adjust_date, adjust_qty
   ON ip_product_fg_adjust
   COMPOUND TRIGGER
   TYPE t_map IS TABLE OF DATE INDEX BY PLS_INTEGER;
   g_through t_map;
   FUNCTION through (p_org NUMBER) RETURN DATE IS
   BEGIN
      IF NOT g_through.EXISTS(p_org) THEN g_through(p_org) := pkg_inv_close_lock.closed_through('FG', p_org); END IF;
      RETURN g_through(p_org);
   END;
   BEFORE EACH ROW IS
   BEGIN
      IF INSERTING OR UPDATING THEN pkg_inv_close_lock.assert_open(:NEW.adjust_date, through(:NEW.organization_id), '제품재고조정'); END IF;
      IF DELETING OR UPDATING THEN pkg_inv_close_lock.assert_open(:OLD.adjust_date, through(:OLD.organization_id), '제품재고조정'); END IF;
   END BEFORE EACH ROW;
END TRG_FG_ADJUST_LOCK;
/
