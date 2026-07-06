CREATE OR REPLACE PROCEDURE "P_CHECK_BARCODE" 
   (
  /* ================================================================
   * 프로시저명  : P_CHECK_BARCODE
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   품목 바코드와 조직 기준으로 ID_ITEM 등록 건수를 확인한다.
   *   등록 건수가 0이면 오류 코드 1, 2건 이상이면 오류 코드 2를 반환한다.
   *   1건인 경우 초기값 0을 유지하여 정상 바코드로 판단한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_BARCODE          (IN, VARCHAR2) - 확인할 품목 바코드
   *   P_ORGANIZATION_ID  (IN, NUMBER) - 조직 ID
   *   P_ERR              (OUT, VARCHAR2) - 결과 코드, 0 정상, 1 미등록, 2 중복
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ID_ITEM - 품목 마스터
   *     조건: BARCODE, ORGANIZATION_ID 일치
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN NO_DATA_FOUND - NOT FOUND 메시지로 ORA-20003 발생
   *   WHEN OTHERS - 원 오류 메시지로 ORA-20003 발생
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 없음
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   EXEC P_CHECK_BARCODE('BARCODE001', 82, :P_ERR)
   * ================================================================ */
 p_barcode           IN  varchar2 ,
     p_organization_id   IN  NUMBER ,
     p_err               OUT varchar2)
   IS
   LVI_COUNT               NUMBER; -- [AI] 바코드와 조직 기준 품목 등록 건수

BEGIN

   -- [AI] 기본 결과를 정상 코드로 초기화한다.
   p_err := 0;

   -- [AI] 입력 바코드와 조직에 해당하는 품목 건수를 조회한다.
   SELECT COUNT(*)
   INTO LVI_COUNT
   FROM ID_ITEM
   WHERE BARCODE = p_barcode AND
         ORGANIZATION_ID = p_organization_id;


  -- [AI] 미등록 또는 중복 등록 여부에 따라 오류 코드를 반환한다.
  IF LVI_COUNT = 0 THEN

      p_err := 1;
      RETURN;

  ELSE IF LVI_COUNT > 1 THEN

      p_err := 2;
      RETURN;


  END IF;
  END IF;


EXCEPTION
   -- [AI] 데이터 미존재 예외 발생 시 NOT FOUND 메시지로 변환한다.
   WHEN no_data_found then
       raise_application_error( -20003 , 'NOT FOUND'||sqlerrm ) ;
   -- [AI] 기타 오류를 애플리케이션 오류로 변환한다.
   WHEN others THEN
       raise_application_error( -20003 , sqlerrm ) ;
END;
