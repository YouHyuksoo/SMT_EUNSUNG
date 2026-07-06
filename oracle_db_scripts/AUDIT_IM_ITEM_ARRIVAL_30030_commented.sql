CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : AUDIT_IM_ITEM_ARRIVAL_30030
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IM_ITEM_ARRIVAL 테이블의 INSERT 발생 시 변경 이력 또는 감사 로그를 자동 기록한다.
   *   원본 로직 기준으로 변경 전후 값과 처리 정보를 보조 테이블에 남기는 트리거로 추정된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 
NEW.arrival_status = 'A'
      
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IM_ITEM_ARRIVAL - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.ARRIVAL_STATUS - 신규/변경 후 상태 관련 값
   *   :NEW.ORGANIZATION_ID - 신규/변경 후 값 값
   *   :NEW.ENTER_BY - 신규/변경 후 값 값
   *   :NEW.LAST_MODIFY_BY - 신규/변경 후 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IM_ITEM_ARRIVAL - 품목 관련 트리거 대상 테이블
   *   ISYS_AUDIT_MESSAGE - 업무 데이터 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   명시적 EXCEPTION 블록 없음 - 호출부/Oracle 표준 예외 처리를 따른다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회, ELSIF 1회 / 반복문: 0회
   *   DML: INSERT 3회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'AUDIT_IM_ITEM_ARRIVAL_30030';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'AUDIT_IM_ITEM_ARRIVAL_30030';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."AUDIT_IM_ITEM_ARRIVAL_30030" 
 BEFORE
  INSERT
 ON im_item_arrival
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
 WHEN (
NEW.arrival_status = 'A'
      ) BEGIN
   IF NVL (:NEW.arrival_status, 'N') = 'N'
   THEN
      INSERT INTO "ISYS_AUDIT_MESSAGE"
                  (audit_message_id,
                   audit_date,
                   organization_id,
                   msg_id,
                   confirm_yn,
                   confirm_by,
                   confirm_date,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by
                  )
           VALUES (seq_audit_msg_sequence.NEXTVAL,
                   TRUNC (SYSDATE),
                   :NEW.organization_id,
                   30030, --'ITEM ARRIVAL'
                   'N',
                   NULL,
                   NULL,
                   SYSDATE,
                   :NEW.enter_by,
                   SYSDATE,
                   :NEW.last_modify_by
                  );
   ELSIF :NEW.arrival_status = 'C'
   THEN
      INSERT INTO "ISYS_AUDIT_MESSAGE"
                  (audit_message_id,
                   audit_date,
                   organization_id,
                   msg_id,
                   confirm_yn,
                   confirm_by,
                   confirm_date,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by
                  )
           VALUES (seq_audit_msg_sequence.NEXTVAL,
                   TRUNC (SYSDATE),
                   :NEW.organization_id,
                   40030, --'ITEM ARRIVAL CANCELED'
                   'N',
                   NULL,
                   NULL,
                   SYSDATE,
                   :NEW.enter_by,
                   SYSDATE,
                   :NEW.last_modify_by
                  );
   END IF;
END;
