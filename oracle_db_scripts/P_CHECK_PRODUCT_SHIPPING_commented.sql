CREATE OR REPLACE PROCEDURE "P_CHECK_PRODUCT_SHIPPING" (
  /* ================================================================
   * 프로시저명  : P_CHECK_PRODUCT_SHIPPING
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2016-05-12
   * 수정이력:
   *   2016-05-12 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   입력 조건을 기준으로 업무 데이터의 유효성 또는 상태를 확인한다.
   *   조회 결과와 원본 분기 조건에 따라 OUT 파라미터 또는 상태 값을 설정한다.
   *   호출부가 결과 코드와 메시지로 후속 처리를 판단할 수 있게 한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_BARCODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_DEFICIT - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   *   P_MSG - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_2D_BARCODE - 원본 로직 참조 테이블
   *   IP_PRODUCT_MODEL_MASTER - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_MAGAZINE_BARCODE
   *   F_MSG
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_CHECK_PRODUCT_SHIPPING(...)
   * ================================================================ */
   P_BARCODE   IN     VARCHAR2,
   P_DEFICIT   IN     VARCHAR2,
   P_OUT          OUT VARCHAR2,
   P_MSG          OUT VARCHAR2)
IS
   LVI_BARCODE           VARCHAR2 (100); -- [AI] 내부 처리용 변수

   LVI_COUNT             NUMBER; -- [AI] 내부 처리용 변수
   LVI_POWER_CHECK       NUMBER; -- [AI] 내부 처리용 변수
   LVS_NO_POWER_SERIAL   VARCHAR2 (100); -- [AI] 내부 처리용 변수
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.


    -- 2016/05/12 SHS
    BEGIN
         SELECT f_get_magazine_barcode(P_BARCODE)
           INTO LVI_BARCODE
           FROM DUAL;
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND
         THEN
            LVI_BARCODE := P_BARCODE;
      END;
    ---------------------------------------------------------------------------------

   IF P_DEFICIT = 'N'
   THEN
      BEGIN
         SELECT COUNT (*)
           INTO LVI_COUNT
           FROM IP_PRODUCT_2D_BARCODE
          WHERE MAGAZINE_NO = LVI_BARCODE AND SHIPPING_DEFICIT = '3';
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND
         THEN
            P_OUT := 'NG';
      END;

      IF NVL (LVI_COUNT, 0) > 0
      THEN
         P_OUT := 'NG';
         P_MSG := f_msg('It has already been shipped.','C',1) ; --' 이미 출하 되었습니다.';
         RETURN;
      END IF;

      LVI_COUNT := 0;

      BEGIN
         SELECT COUNT (*)
           INTO LVI_COUNT
           FROM IP_PRODUCT_2D_BARCODE
          WHERE MAGAZINE_NO = LVI_BARCODE AND SHIPPING_DEFICIT = '1';
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND
         THEN
            P_OUT := 'NG';
            P_MSG := f_msg('This is not waiting to be shipped','C',1)     ; -- '출하 대기중인 매거진이 아닙니다';
      END;

      IF NVL (LVI_COUNT, 0) = 0
      THEN
         P_OUT := 'NG';
         P_MSG := f_msg('This is not waiting to be shipped','C',1)     ; -- '출하 대기중인 매거진이 아닙니다';
         RETURN;
      END IF;



      -- SELECT COUNT (*), MAX (SERIAL_NO)
      --   INTO LVI_POWER_CHECK, LVS_NO_POWER_SERIAL
      --   FROM IP_PRODUCT_2D_BARCODE
      --  WHERE     MAGAZINE_NO = LVI_BARCODE
      --        AND POWER_CHECK_YN <> 'Y'                                 --POWER
      --        AND MODEL_NAME IN (SELECT MODEL_NAME
      --                             FROM IP_PRODUCT_MODEL_MASTER
      --                            WHERE CUSTOMER_CODE = 'DY');
      --
      --
      -- IF NVL (LVI_POWER_CHECK, 0) > 0
      -- THEN
      --    P_OUT := 'NG';
      --    P_MSG :=
      --       '파워검사 이력이 없는 제품이 들어 있습니다 확인하세요';
      --    RETURN;
      --  END IF;


      -------------------------------------------------------------
      --
      -------------------------------------------------------------

      UPDATE IP_PRODUCT_2D_BARCODE
         SET SHIPPING_DEFICIT = '3', SHIPPING_DATE = SYSDATE
       WHERE MAGAZINE_NO = LVI_BARCODE;

      P_OUT := 'OK';
      P_MSG := 'OK.'||'(QTY:'||to_char(sql%rowcount)||')';
      COMMIT;
   ELSE
      BEGIN
         SELECT COUNT (*)
           INTO LVI_COUNT
           FROM IP_PRODUCT_2D_BARCODE
          WHERE MAGAZINE_NO = LVI_BARCODE AND SHIPPING_DEFICIT = '3';
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND
         THEN
            P_OUT := 'NG';
            P_MSG := f_msg('Information Notfound','C',1) ; --'출하된 매거진 정보가 없습니다';
            RETURN;
      END;

      IF NVL (LVI_COUNT, 0) = 0
      THEN
         P_OUT := 'NG';
         P_MSG := f_msg('Information Notfound','C',1) ; --'출하된 매거진 정보가 없습니다';
         RETURN;
      END IF;


      UPDATE IP_PRODUCT_2D_BARCODE
         SET SHIPPING_DEFICIT = '1', SHIPPING_DATE = SYSDATE
       WHERE MAGAZINE_NO = LVI_BARCODE AND SHIPPING_DEFICIT = '3';

      P_OUT := 'OK';
      P_MSG := 'OK.'||'(Canel QTY:'||to_char(sql%rowcount)||')';  -- 2016/05/31 SHS, 취소처리 수량 메세지 추가
      COMMIT;
      RETURN;
   END IF;
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN NO_DATA_FOUND
   THEN
      P_OUT := 'NG';
      P_MSG := f_msg('Information Notfound','C',1) ; --'출하된 매거진 정보가 없습니다';
      RETURN;
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS
   THEN

      -- test shs
           

      RAISE_APPLICATION_ERROR (-20003, SQLERRM);
END P_CHECK_PRODUCT_SHIPPING;