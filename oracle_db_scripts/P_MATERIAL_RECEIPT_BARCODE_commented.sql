CREATE OR REPLACE PROCEDURE "P_MATERIAL_RECEIPT_BARCODE" 
   (
  /* ================================================================
   * 프로시저명  : P_MATERIAL_RECEIPT_BARCODE
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   자재 입고 바코드와 조직 기준으로 사용 가능한 재고 바코드 건수를 확인한다.
   *   IM_ITEM_INVENTORY_BARCODE에서 상태가 0인 바코드를 조회한다.
   *   현재 조건문은 LVI_COUNT < 0을 검사하므로 실제로는 ELSE 경로의 결과 코드 2가 반환된다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_BARCODE          (IN, VARCHAR2) - 확인할 자재 입고 바코드
   *   P_ORGANIZATION_ID  (IN, NUMBER) - 조직 ID
   *   P_ERR              (OUT, VARCHAR2) - 처리 결과 코드
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IM_ITEM_INVENTORY_BARCODE - 자재 재고 바코드 테이블
   *     조건: ITEM_CODE_BARCODE, ORGANIZATION_ID, BARCODE_STATUS = '0'
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN NO_DATA_FOUND - NOT FOUND 메시지로 ORA-20003 발생
   *   WHEN OTHERS - 원 오류 메시지로 ORA-20003 발생
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 1회 / 반복문: 없음
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   EXEC P_MATERIAL_RECEIPT_BARCODE('MAT_BARCODE001', 82, :P_ERR)
   * ================================================================ */
 p_barcode           IN  varchar2 ,
     p_organization_id   IN  NUMBER ,
     p_err               OUT varchar2)
   IS
   LVI_COUNT               NUMBER; -- [AI] 자재 재고 바코드 조회 건수

BEGIN

   -- [AI] 기본 결과를 정상 코드로 초기화한다.
   p_err := 0;

   -- [AI] 입력 바코드와 조직에 해당하는 사용 가능 재고 바코드 건수를 조회한다.
   SELECT COUNT(*)
   INTO LVI_COUNT
   FROM im_item_inventory_barcode
   WHERE ITEM_CODE_BARCODE = p_barcode
     AND ORGANIZATION_ID = p_organization_id
     AND BARCODE_STATUS = '0';


  -- [AI] 조회 건수 기준으로 결과 코드를 반환한다.
  IF LVI_COUNT < 0 THEN

      p_err := 1;
      RETURN;

  ELSE
   --   UPDATE im_item_inventory_barcode

      p_err := 2;
      RETURN;


  END IF;


EXCEPTION
   -- [AI] 데이터 미존재 예외 발생 시 NOT FOUND 메시지로 변환한다.
   WHEN no_data_found then
       raise_application_error( -20003 , 'NOT FOUND'||sqlerrm ) ;
   -- [AI] 기타 오류를 애플리케이션 오류로 변환한다.
   WHEN others THEN
       raise_application_error( -20003 , sqlerrm ) ;
END;
