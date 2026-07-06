CREATE OR REPLACE PROCEDURE "SP_LOGON" 
   (
  /* ================================================================
   * 프로시저명  : SP_LOGON
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   사용자 ID, 비밀번호, 조직 기준으로 로그인 가능 여부를 확인한다.
   *   ISYS_USERS에서 일치 계정 건수를 먼저 확인하고, 존재하면 사용자 ID와 이름을 반환한다.
   *   인증 실패 시 P_PASS_YN에 N, 성공 시 Y를 설정한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_LOGNAME    (IN, VARCHAR2) - 로그인 사용자 ID
   *   P_PWD        (IN, VARCHAR2) - 로그인 비밀번호
   *   P_ORG        (IN, NUMBER) - 조직 ID
   *   P_USER_ID    (OUT, VARCHAR2) - 인증 성공 사용자 ID
   *   P_USER_NAME  (OUT, VARCHAR2) - 인증 성공 사용자명
   *   P_PASS_YN    (OUT, VARCHAR2) - 인증 성공 여부, Y 또는 N
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ISYS_USERS - 사용자 마스터
   *     조건: USER_ID, PASSWORD, ORGANIZATION_ID 일치
   * ================================================================
   * [AI 분석] 예외 처리:
   *   별도 EXCEPTION 절 없음 - 오류 발생 시 호출부로 전달된다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 1회 / 반복문: 없음
   *   DML: SELECT 2회
   * ================================================================
   * 사용 예시:
   *   EXEC SP_LOGON('USER01', 'PASSWORD', 82, :P_USER_ID, :P_USER_NAME, :P_PASS_YN)
   * ================================================================ */
 p_logname IN varchar2 ,
     p_pwd IN varchar2,
     p_org IN number,
     p_user_id out varchar2,
     p_user_name out varchar2,
     p_pass_yn out varchar2
     )
   IS
   lvi_rownumber                 integer; -- [AI] 인증 조건에 일치하는 사용자 건수

BEGIN
-- [AI] 사용자 ID와 이름 출력값을 기본값으로 초기화한다.
p_user_id:='Y';
p_user_name:='Y';
-- [AI] 입력 계정 정보와 조직에 일치하는 사용자 존재 여부를 확인한다.
select count(*)
into lvi_rownumber
from isys_users
where USER_ID = p_logname and
      PASSWORD = p_pwd and
      ORGANIZATION_ID = p_org;

-- [AI] 사용자 존재 여부에 따라 로그인 성공 여부를 반환한다.
if lvi_rownumber=0 then

p_pass_yn:='N';
return;

else

p_pass_yn:='Y';

-- [AI] 인증 성공 사용자의 ID와 이름을 조회한다.
select user_id,user_name
into p_user_id,p_user_name
from isys_users
where USER_ID = p_logname and
      PASSWORD = p_pwd    and
      ORGANIZATION_ID = p_org;

return;
end if;

END; -- Procedure
