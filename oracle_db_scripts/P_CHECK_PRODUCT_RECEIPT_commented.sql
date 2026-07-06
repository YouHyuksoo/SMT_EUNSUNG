CREATE OR REPLACE PROCEDURE "P_CHECK_PRODUCT_RECEIPT" (
  /* ================================================================
   * 프로시저명  : P_CHECK_PRODUCT_RECEIPT
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
   *   EXEC P_CHECK_PRODUCT_RECEIPT(...)
   * ================================================================ */
   P_BARCODE   IN     VARCHAR2,
   P_DEFICIT   IN     VARCHAR2,
   P_OUT          OUT VARCHAR2,
   P_MSG          OUT VARCHAR2)
IS
    LVI_BARCODE           VARCHAR2 (500); -- [AI] 내부 처리용 변수

   LVI_COUNT              NUMBER; -- [AI] 내부 처리용 변수
   LVI_POWER_CHECK        NUMBER; -- [AI] 내부 처리용 변수
   LVI_VERIFY_CHECK       NUMBER; -- [AI] 내부 처리용 변수
   LVS_NO_POWER_SERIAL    VARCHAR2 (500); -- [AI] 내부 처리용 변수
   LVS_NO_VERIFY_SERIAL   VARCHAR2 (500); -- [AI] 내부 처리용 변수
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.

    -- magazine row label에 대한 magazine no을 돌려준다 (IVI 자리 그외는 12자리)
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
    ----------------------------------------------------------------------------

   IF P_DEFICIT = 'N'
   THEN

      BEGIN -- 2016/06/09 SHS, MAGAZIN 미 구성 품에 대해 error 처리
         SELECT COUNT (*)
           INTO LVI_COUNT
           FROM IP_PRODUCT_2D_BARCODE
          WHERE MAGAZINE_NO = LVI_BARCODE;
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND
         THEN
            P_OUT := 'NG';
      END;

      IF NVL (LVI_COUNT, 0) = 0
      THEN
         P_OUT := 'NG';
         P_MSG := LVI_BARCODE||f_msg(' : PID Mapping Info Notfound.','C',1);
        -- P_MSG := LVI_BARCODE||' : 매거진 라벨에 매핑된 PID가 없습니다.';

   -- test shs
   --        insert into shs_temp (a, enter_date, enter_by)
   --        select 'R >'||P_BARCODE||', '||'M >'||LVI_BARCODE,
   --               sysdate,
   --               'P_CHECK_PRODUCT_RECEIPT'
   --          from dual;
   --        commit;

         RETURN;
      END IF;


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
      END;

      IF NVL (LVI_COUNT, 0) > 0
      THEN
         P_OUT := 'NG';
         P_MSG := f_msg('Already receipted. check please!','C',1) ; -- '이미 입고 되었습니다. 확인하세요!!';
         RETURN;
      END IF;


      LVI_COUNT := 0;

      BEGIN
         SELECT COUNT (*)
           INTO LVI_COUNT
           FROM IP_PRODUCT_2D_BARCODE
          WHERE MAGAZINE_NO = LVI_BARCODE AND SHIPPING_DEFICIT IS NULL;
      EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN NO_DATA_FOUND
         THEN
            P_OUT := 'NG';
      END;

      IF NVL (LVI_COUNT, 0) = 0
      THEN
         P_OUT := 'NG';
         P_MSG :=  f_msg('Already receipted or shipped','C',1) ; --'이미 입고 또는 출하된 매거진 입니다.';
         RETURN;
      END IF;

     LVI_COUNT := 0;

      -------------------------------------------------------------

      UPDATE IP_PRODUCT_2D_BARCODE
         SET SHIPPING_DEFICIT = '1', RECEIPT_DATE = SYSDATE
       WHERE MAGAZINE_NO = LVI_BARCODE;

      P_OUT := 'OK';
      P_MSG := 'OK.'||'(QTY:'||to_char(sql%rowcount)||')';  -- 2016/05/31 SHS, 입고처리 수량 메세지 추가

      COMMIT;

      RETURN;
   --------------------------------------------------------------
   -- 취소
   ---------------------------------------------------------------
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
      END;

      IF NVL (LVI_COUNT, 0) > 0
      THEN
         P_OUT := 'NG';
         P_MSG := 
              f_msg('Already Shipped. Can`t Canel (Do Cancel and Continue)','C',1) ;
            --'이미 출하되어 취소불가 (출하취소하고 작업하세요).';
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
            P_MSG := f_msg('Not yet receipt','C',1) ; --'입고된 매거진이 아닙니다';
      END;

      IF NVL (LVI_COUNT, 0) = 0
      THEN
         P_OUT := 'NG';
          P_MSG := f_msg('Not yet receipt','C',1) ; --'입고된 매거진이 아닙니다';
         RETURN;
      END IF;

      --입고 상태로 전환
      UPDATE IP_PRODUCT_2D_BARCODE
         SET SHIPPING_DEFICIT = NULL, RECEIPT_DATE = SYSDATE
       WHERE MAGAZINE_NO = LVI_BARCODE;

      P_OUT := 'OK';
      P_MSG := 'OK.'||'CANEL QTY:'||to_char(sql%rowcount)||')';  -- 2016/05/31 SHS, 입고처리 수량 메세지 추가
      COMMIT;

   END IF;

EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN NO_DATA_FOUND
   THEN
      P_OUT := 'NG';
      P_MSG := f_msg('Not yet receipt','C',1) ; --'입고된 매가진 정보가 없습니다';
      RETURN;
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS
   THEN
      RAISE_APPLICATION_ERROR (-20003, SQLERRM);
END ;