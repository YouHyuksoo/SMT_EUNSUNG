CREATE OR REPLACE PROCEDURE "P_CHECK_MSL_LEVEL" (
  /* ================================================================
   * 프로시저명  : P_CHECK_MSL_LEVEL
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   품목 코드 기준으로 MSL 레벨과 ECO 대상 여부를 확인한다.
   *   ID_ITEM에서 MSL_LEVEL 또는 ECO_CHECK_YN이 의미 있는 품목만 조회한다.
   *   ECO 대상이면 메시지 함수를 통해 영문 안내 문구를 조합해 반환한다.
   *   대상 데이터가 없으면 기본값 *을 반환한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_ITEM_CODE  (IN, VARCHAR2) - 조회할 품목 코드
   *   P_RETURN     (OUT, VARCHAR2) - MSL/ECO 안내 메시지 또는 *
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ID_ITEM - 품목 마스터
   *     조건: ITEM_CODE 일치 및 MSL_LEVEL 존재 또는 ECO_CHECK_YN = 'Y'
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_MSG - ECO 안내 메시지 다국어 문구 조회
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN NO_DATA_FOUND - 조회 대상이 없으면 P_RETURN에 *을 설정하고 종료한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 1회, ELSIF 2회 / 반복문: 없음
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   EXEC P_CHECK_MSL_LEVEL('ITEM001', :P_RETURN)
   * ================================================================ */
   p_item_code   IN     VARCHAR2,
   p_return         OUT VARCHAR2)
IS
   lvs_msl_level   VARCHAR2 (10); -- [AI] 품목의 MSL 레벨 값
   lvs_eco_check   VARCHAR2 (10); -- [AI] 품목의 ECO 대상 여부
BEGIN
   -- [AI] 품목 마스터에서 MSL 레벨과 ECO 대상 여부를 조회한다.
   SELECT NVL (msl_level, '*'), NVL (ECO_CHECK_YN, '*')
     INTO lvs_msl_level, lvs_eco_check
     FROM id_item
    WHERE item_code = p_item_code
          AND (msl_level IS NOT NULL OR NVL (eco_check_yn, 'N') = 'Y');


   -- [AI] MSL/ECO 조합에 따라 호출부 안내 메시지를 구성한다.
   IF lvs_msl_level = '*' AND lvs_eco_check = 'N'
   THEN
      p_return := '*';
   ELSIF lvs_msl_level = '*' AND lvs_eco_check = 'Y'
   THEN
      p_return :=
            'MSL Level ' || lvs_msl_level || f_msg(' Is ECO item ','E',1);
       --   'MSL 레벨은 ' || lvs_msl_level || ' 이고 ECO 대상입니다 ';
   ELSIF lvs_msl_level <> '*' AND lvs_eco_check = 'Y'
   THEN
      p_return :=
           'MSL Level ' || lvs_msl_level || f_msg(' Is ECO item ','E',1);
       --  'MSL 레벨은 ' || lvs_msl_level || ' 이고 ECO 대상입니다 ';
   END IF;


   RETURN;
EXCEPTION
   -- [AI] MSL/ECO 대상 품목이 없으면 기본값을 반환한다.
   WHEN NO_DATA_FOUND
   THEN
      p_return := '*';
      RETURN;
END;
