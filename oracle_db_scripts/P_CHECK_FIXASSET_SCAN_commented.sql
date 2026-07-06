CREATE OR REPLACE PROCEDURE "P_CHECK_FIXASSET_SCAN" ( p_location in varchar2 default '*' , p_type in varchar2 default '*'  , P_AssetCode varchar2,  p_qty in number default 1 , p_out out varchar2, p_msg out varchar2) is
  /* ================================================================
   * 프로시저명  : P_CHECK_FIXASSET_SCAN
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2017-02-20
   * 수정이력:
   *   2017-02-20 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   입력 조건을 기준으로 상태 또는 기준 데이터의 유효성을 확인한다.
   *   조회 결과와 원본 분기 조건에 따라 OUT 파라미터 또는 관련 상태 값을 설정한다.
   *   호출부가 결과 코드와 메시지로 후속 처리를 판단할 수 있게 한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_LOCATION - 원본 선언부 기준 입력/출력 파라미터
   *   P_TYPE - 원본 선언부 기준 입력/출력 파라미터
   *   P_ASSETCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_QTY - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   *   P_MSG - 원본 선언부 기준 입력/출력 파라미터
   *   PDA - 원본 선언부 기준 입력/출력 파라미터
   *   PDA - 원본 선언부 기준 입력/출력 파라미터
   *   P_TYPE - 원본 선언부 기준 입력/출력 파라미터
   *   P_ASSETCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_ASSETCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_ASSETCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_LOCATION - 원본 선언부 기준 입력/출력 파라미터
   *   P_ASSETCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_LOCATION - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   *   P_MSG - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IMCN_JIG - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_CHECK_FIXASSET_SCAN(...)
   * ================================================================ */
   --PDA 고정자산 스캔 
   --PDA 2017.02.20 
   
   
LVI_COUNT NUMBER ; -- [AI] 내부 처리용 변수

begin
   -- [AI] 주요 업무 처리 로직을 시작한다.
  
 
  if p_type = 'F' then 
  
  
    SELECT COUNT(*) INTO LVI_COUNT FROM IMCN_JIG WHERE JIG_LOT_NO = P_ASSETCODE 
      AND JIG_TYPE = 'F' ;
      
      
      IF LVI_COUNT > 0 THEN 
        NULL  ;
      ELSE
        
  
            INSERT INTO  IMCN_JIG
            (
            JIG_CODE,
            ORGANIZATION_ID,
            JIG_NAME,
            JIG_TYPE,
            CAPACITY,
            RESERVED_CAPACITY,
            ACQUISITION_DATE,
            ACQUISITION_TYPE,
            JIG_MODEL_NAME,
            LINE_CODE,
            CUSTOMER_CODE,
            USE_STATUS,
            MANUAL_LOCATION_COMMENT,
            NATION_CODE,
            WORKSTAGE_CODE,
            ENTER_BY,
            ENTER_DATE,
            LAST_MODIFY_BY,
            LAST_MODIFY_DATE,
            USE_RATE,
            UPH_VALUE,
            CAPACITY_UOM,
            SUPPLIER_CODE,
            JIG_STATUS,
            JIG_IMAGE,
            JIG_IMAGE_FILE_NAME,
            USE_TPM_YN,
            JIG_LOT_NO,
            MACHINE_CODE,
            BREAK_VALUE,
            HIT_VALUE,
            JIG_SPEC,
            ITEM_CODE,
            LOCATION_ADDRESS,
            SOLDER_TYPE,
            USE_NSNP_YN,
            MANAGEMENT_COMMNETS,
            RECEIPT_DATE,
            LAST_INSPECT_DATE,
            ISSUE_DATE,
            DESTROY_DATE,
            TENSION_CHECK_YN
          )
          VALUES
          (
            P_AssetCode , --JIG_CODE,
            1 , --ORGANIZATION_ID,
            P_AssetCode, --JIG_NAME,
            'F' , --JIG_TYPE,
            NULL , -- CAPACITY,
            NULL , --RESERVED_CAPACITY,
            SYSDATE , --ACQUISITION_DATE,
            'N'  , --ACQUISITION_TYPE,
            P_ASSETCODE  , --JIG_MODEL_NAME,
            P_LOCATION  , --LINE_CODE,
            '*'  , --CUSTOMER_CODE,
            'Y'  , --USE_STATUS,
            '*', --MANUAL_LOCATION_COMMENT,
            '*', --NATION_CODE,
            '*', --WORKSTAGE_CODE,
            'SYSTEM' , --ENTER_BY,
            SYSDATE , --ENTER_DATE,
            'SYSTEM' , --LAST_MODIFY_BY,
            SYSDATE , --LAST_MODIFY_DATE,
            100 , --USE_RATE,
            0 , --UPH_VALUE,
            NULL , --CAPACITY_UOM,
            '*' , --SUPPLIER_CODE,
            'N' , --JIG_STATUS,
            NULL , --JIG_IMAGE,
            NULL , --JIG_IMAGE_FILE_NAME,
            'Y' , --USE_TPM_YN,
            P_ASSETCODE , --JIG_LOT_NO,
            '*' , --MACHINE_CODE,
            0 , --BREAK_VALUE,
            0 , --HIT_VALUE,
            '*' , --JIG_SPEC,
            '*' , --ITEM_CODE,
            P_LOCATION , --LOCATION_ADDRESS,
            NULL , --SOLDER_TYPE,
            'N' , --USE_NSNP_YN,
            NULL , --MANAGEMENT_COMMNETS,
            NULL , --RECEIPT_DATE,
            NULL , --LAST_INSPECT_DATE,
            NULL , --ISSUE_DATE,
            NULL , --DESTROY_DATE,
            'N'  --TENSION_CHECK_YN
          );
  END IF ;
  
  commit ;
  end if ;
  
  
   p_out := 'OK';
   p_msg := P_AssetCode||chr(10)||'P_CHECK_FIXASSET_SCAN'  ; 
  
end P_CHECK_FIXASSET_SCAN;