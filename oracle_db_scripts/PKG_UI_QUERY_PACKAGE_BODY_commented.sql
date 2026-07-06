CREATE OR REPLACE PACKAGE BODY
  /* ================================================================
   * 패키지 본문명  : PKG_UI_QUERY
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   UI 화면 조회에 필요한 공통 커서/조회 로직을 제공하는 패키지이다.
   *   화면별 반복 SQL을 패키지 단위로 묶어 관리한다.
   * ================================================================
   * [AI 분석] 공개/구현 객체:
   *   FUNCTION FN_LOSS_RATE - 패키지 내 업무 처리 단위
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_MACHINE_INSPECT_PICKUP - 검사 관련 조회 또는 변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   패키지 본문 내 각 PROCEDURE/FUNCTION의 EXCEPTION 블록 또는 호출부 표준 예외 처리를 따른다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 6회 / 반복문: 3회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   EXEC PKG_UI_QUERY.<PROCEDURE_NAME>(...);
   *   SELECT {clean(name)}.<FUNCTION_NAME>(...) FROM DUAL;
   * ================================================================ */
 "PKG_UI_QUERY" is

FUNCTION FN_LOSS_RATE RETURN T_LOSS_RATE_T PIPELINED IS
 R_TBL T_LOSS_RATE_R;
 R_CNT NUMBER := 0 ;  --RECORD COUNT

 R_LINE VARCHAR2(20) := null ;
BEGIN
   FOR C01 IN (

                          SELECT LINE_CODE,
                                 NVL(MACHINE_CODE,LINE_CODE||' LINE_TTL') MACHINE_CODE,
                                 TRUNC(AVG(TACT_TIME),2) TACT_TIME,
                                 TRUNC(1 - (SUM(PICKERROR) + SUM(VISIONERROR)) / SUM(PICKUP),4) as RATE
                            FROM IQ_MACHINE_INSPECT_PICKUP T
                           GROUP BY ROLLUP (LINE_CODE, MACHINE_CODE)
                           HAVING LINE_CODE IS NOT NULL

                 )
   LOOP


     IF NVL(R_LINE,'X') <> C01.LINE_CODE THEN
       IF R_LINE <> 'X' THEN
         PIPE ROW (R_TBL);

         R_TBL.LINE_CODE := NULL ;
         R_TBL.VAL_M1:= NULL ;
         R_TBL.VAL_M2:= NULL ;
         R_TBL.VAL_M3 := NULL ;
         R_TBL.VAL_M4 := NULL ;
         R_TBL.VAL_M5 := NULL ;
         R_TBL.VAL_M6 := NULL ;
         R_TBL.VAL_TTL := NULL ;
         R_TBL.RATE_M1 := NULL ;
         R_TBL.RATE_M2 := NULL ;
         R_TBL.RATE_M3 := NULL ;
         R_TBL.RATE_M4 := NULL ;
         R_TBL.RATE_M5 := NULL ;
         R_TBL.RATE_M6 := NULL ;
         R_TBL.RATE_TTL := NULL ;

       END IF ;
       --?????????
       R_LINE := C01.LINE_CODE ;
     END IF ;


     IF C01.MACHINE_CODE = 'M1' THEN
        R_TBL.LINE_CODE := C01.LINE_CODE ;
        R_TBL.VAL_M1    := C01.TACT_TIME ;
        R_TBL.RATE_M1   := C01.RATE      ;
     ELSIF C01.MACHINE_CODE = 'M2' THEN
        R_TBL.LINE_CODE := C01.LINE_CODE ;
        R_TBL.VAL_M2    := C01.TACT_TIME ;
        R_TBL.RATE_M2   := C01.RATE      ;
     ELSIF C01.MACHINE_CODE = 'M3' THEN
        R_TBL.LINE_CODE := C01.LINE_CODE ;
        R_TBL.VAL_M3    := C01.TACT_TIME ;
        R_TBL.RATE_M3   := C01.RATE      ;
     ELSIF C01.MACHINE_CODE = 'M4' THEN
        R_TBL.LINE_CODE := C01.LINE_CODE ;
        R_TBL.VAL_M4    := C01.TACT_TIME ;
        R_TBL.RATE_M4   := C01.RATE      ;
     ELSIF C01.MACHINE_CODE = 'M5' THEN
        R_TBL.LINE_CODE := C01.LINE_CODE ;
        R_TBL.VAL_M5    := C01.TACT_TIME ;
        R_TBL.RATE_M5   := C01.RATE      ;
     ELSIF C01.MACHINE_CODE = 'M6' THEN
        R_TBL.LINE_CODE := C01.LINE_CODE ;
        R_TBL.VAL_M6    := C01.TACT_TIME ;
        R_TBL.RATE_M6   := C01.RATE      ;
     ELSE
        R_TBL.LINE_CODE := C01.LINE_CODE  ;
        R_TBL.VAL_TTL    := C01.TACT_TIME ;
        R_TBL.RATE_TTL   := C01.RATE      ;
     END IF ;


   END LOOP ;

   PIPE ROW (R_TBL);

   RETURN ;
EXCEPTION
   WHEN OTHERS THEN

           raise_application_error(-20001,sqlerrm);
END ;

end PKG_UI_QUERY;
