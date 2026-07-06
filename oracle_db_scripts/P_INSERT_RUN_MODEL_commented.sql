CREATE OR REPLACE PROCEDURE "P_INSERT_RUN_MODEL" (p_line_code        IN     VARCHAR2,
  /* ================================================================
   * 프로시저명  : P_INSERT_RUN_MODEL
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   라인/공정/모델/품목 기준의 Run 모델 정보를 등록한다.
   *   동일 모델과 조건이 이미 존재하는지 확인한 뒤 필요 시 IP_PRODUCT_RUN_MODEL에 등록한다.
   *   동일 모델에 대해서는 마스터 샘플 흐름을 생략하려는 로직을 포함한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_LINE_CODE (IN, VARCHAR2) - 라인 코드
   *   P_WORKSTAGE_CODE (IN, VARCHAR2) - 공정 코드
   *   P_MODEL_NAME (IN, VARCHAR2) - 모델명
   *   P_ITEM_CODE (IN, VARCHAR2) - 품목 코드
   *   P_PCB_ITEM (IN, VARCHAR2) - PCB Top/Bottom 구분
   *   P_RUN_NO (IN, VARCHAR2) - Run No
   *   P_CHILD_ITEM_CODE (IN, VARCHAR2) - 자부품 코드
   *   P_OUT (OUT, VARCHAR2) - 처리 결과
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_RUN_MODEL - 라인/공정별 Run 모델 관리 테이블
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN OTHERS/NO_DATA_FOUND 등 원본 예외 처리 흐름을 유지한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 로직 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_INSERT_RUN_MODEL('L1','W010','MODEL','ITEM','T','RUN','CHILD',:P_OUT)
   * ================================================================ */
                                                    p_workstage_code   IN     VARCHAR2, -- [AI] 내부 처리용 변수
                                                    p_model_name       IN     VARCHAR2, -- [AI] 내부 처리용 변수
                                                    p_item_code        IN     VARCHAR2, -- [AI] 내부 처리용 변수
                                                    p_pcb_item         IN     VARCHAR2, -- [AI] 내부 처리용 변수
                                                    p_run_no           IN     VARCHAR2, -- [AI] 내부 처리용 변수
                                                    p_child_item_code  IN     VARCHAR2, -- [AI] 내부 처리용 변수
                                                    p_out              OUT    VARCHAR2) -- [AI] 내부 처리용 변수
IS

    lvl_count      NUMBER; -- [AI] 내부 처리용 변수

BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.

--------------------------------------------------------------------------
-- 2016/10/12 SHS, 동일모델에 대해서는 Master sample을 흘리지 않음 
--------------------------------------------------------------------------

    BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
      
       SELECT nvl(sum(1),0)
         INTO lvl_count
         FROM ip_product_run_model
        WHERE organization_id = 1
          AND LINE_CODE       = p_line_code
          AND WORKSTAGE_CODE  = p_workstage_code
          AND MODEL_NAME      = p_model_name
          AND ITEM_CODE       = p_item_code
          AND PCB_ITEM||'*'   = decode(p_pcb_item,'T','T','B','B','')||'*';
    
    EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
       WHEN OTHERS THEN        
            lvl_count := 0;
            
    END;
 
--------------------------------------------------------------------------
-- 2016/08/19 SHS, 매거진 모델 매칭을 위한 공정APP 등록 모듈 
--------------------------------------------------------------------------
      
    IF lvl_count = 0 THEN   

       DELETE FROM ip_product_run_model
        WHERE organization_id = 1
          AND LINE_CODE       = p_line_code
          AND WORKSTAGE_CODE  = p_workstage_code;
       
       
       INSERT INTO ip_product_run_model (
                                         organization_id,
                                         line_code,
                                         workstage_code,
                                         model_name,
                                         item_code,
                                         pcb_item,
                                         run_no,

                                         enter_date,
                                         enter_by,
                                         last_modify_date,
                                         last_modify_by,
                                         child_item_code
                                         )
         VALUES   (
                   1,
                   p_line_code,
                   p_workstage_code,
                   p_model_name,
                   p_item_code,
                   decode(p_pcb_item,'T','T','B','B',''),
                   p_run_no,

                   SYSDATE,
                   'MAGAZINE APP',
                   SYSDATE,
                   'MAGAZINE APP',
                   p_child_item_code
                   );

    END IF;
    
    p_out := 'OK';
    
    COMMIT;
    
EXCEPTION
  
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
    WHEN OTHERS THEN
      
        ROLLBACK;
        p_out := 'ERROR';
        
        RETURN;
        
END;