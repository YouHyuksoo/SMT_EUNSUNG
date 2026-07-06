CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_MM_MFS_ISSUE_QTY
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   입력 파라미터와 기준 테이블을 이용해 업무 코드, 명칭, 수량, 상태 등의 조회 값을 반환한다.
   *   조회 실패 또는 예외 상황에서는 원본 로직에 정의된 기본값/NULL/오류 처리를 따른다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   AS_MATERIAL_MFS  (IN, VARCHAR2) - 제조/공급 구분
   *   AS_LOCATION_CODE  (IN, VARCHAR2) - 위치 코드
   *   AS_ITEM_CODE  (IN, VARCHAR2) - 품목 코드
   *   AS_YYYYMM  (IN, VARCHAR2) - 함수 입력값
   *   AS_LINE_TYPE  (IN, VARCHAR2) - 라인 관련 값
   *   AS_FLAG  (IN, VARCHAR2) - 함수 입력값
   *   ADT_DATESET  (IN, DATE) - 함수 입력값
   *   ADT_DATEEND  (IN, DATE) - 함수 입력값
   *   AI_ORG  (IN, NUMBER) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   NUMBER - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IM_ITEM_ISSUE - 품목 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회, ELSIF 3회 / 반복문: 0회
   *   DML: SELECT 5회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_MM_MFS_ISSUE_QTY(...) FROM DUAL;
   * ================================================================ */
 "F_GET_MM_MFS_ISSUE_QTY" (as_material_mfs    IN VARCHAR2,
/* Formatted on 2-2-2015 20:58:22 (QP5 v5.126) */
                                 as_location_code   IN VARCHAR2,
                                 as_item_code       IN VARCHAR2,
                                 as_yyyymm          IN VARCHAR2,
                                 as_line_type       IN VARCHAR2,
                                 as_flag            IN VARCHAR2,
                                 adt_dateset        IN DATE,
                                 adt_dateend        IN DATE,
                                 ai_org             IN NUMBER)
    RETURN NUMBER
IS
    al_issue_qty   NUMBER;
    lvdt_start     DATE;
    lvdt_end       DATE;
BEGIN
    IF as_flag = 'M'
    THEN
        SELECT   NVL (SUM (issue_qty), 0)
          INTO   al_issue_qty
          FROM   im_item_issue
         WHERE   material_mfs = as_material_mfs
             AND item_code = as_item_code
             AND line_type = as_line_type
             AND location_code = as_location_code
             AND issue_account LIKE 'M001'
             AND ENTER_DATE BETWEEN adt_dateset AND adt_dateend
             AND organization_id = ai_org;
    --             issue_status <> 'C';
    ELSIF as_flag = 'B'
    THEN
        SELECT   NVL (SUM (issue_qty), 0)
          INTO   al_issue_qty
          FROM   im_item_issue
         WHERE   ENTER_DATE BETWEEN adt_dateset AND adt_dateend
             AND material_mfs = as_material_mfs
             AND item_code = as_item_code
             AND line_type = as_line_type
             AND location_code = as_location_code
             AND issue_account LIKE 'M002'
             AND organization_id = ai_org;
    --             issue_status <> 'C';
    ELSIF as_flag = 'F'
    THEN
        SELECT   NVL (SUM (issue_qty), 0)
          INTO   al_issue_qty
          FROM   im_item_issue
         WHERE   item_code = as_item_code
             AND line_type = as_line_type
             AND material_mfs = as_material_mfs
             AND location_code = as_location_code
             AND ENTER_DATE BETWEEN adt_dateset AND adt_dateend
             AND issue_account LIKE 'M003'
             AND organization_id = ai_org;
    --             issue_status <> 'C';
    ELSIF as_flag = 'E'
    THEN
        SELECT   NVL (SUM (issue_qty), 0)
          INTO   al_issue_qty
          FROM   im_item_issue
         WHERE   ENTER_DATE BETWEEN adt_dateset AND adt_dateend
             AND material_mfs = as_material_mfs
             AND item_code = as_item_code
             AND line_type = as_line_type
             AND location_code = as_location_code
             AND issue_account NOT IN ('M001', 'M002', 'M003')
             AND organization_id = ai_org;
    --             issue_status <> 'C';
    
    ELSE
        SELECT   NVL (SUM (issue_qty), 0)
          INTO   al_issue_qty
          FROM   im_item_issue
         WHERE   ENTER_DATE BETWEEN adt_dateset AND adt_dateend
             AND material_mfs = as_material_mfs
             AND item_code = as_item_code
             AND line_type = as_line_type
             AND location_code = as_location_code
             AND organization_id = ai_org;
    --             issue_status <> 'C';
    END IF;

    RETURN NVL (al_issue_qty, 0);
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        raise_application_error (-20003, 'NO DATA FOUND FLAG=' || as_flag || 'YYYYMM=' || as_yyyymm || '  ' || SQLERRM);
    WHEN OTHERS
    THEN
        raise_application_error (-20003, 'YYYYMM=' || as_yyyymm || '  ' || SQLERRM);
END;
