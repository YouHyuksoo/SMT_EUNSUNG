CREATE OR REPLACE PROCEDURE "P_CHECK_CABLE_MANAGE" ( p_barcode_target  in varchar2
  /* ================================================================
   * 프로시저명  : P_CHECK_CABLE_MANAGE
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   입력 조건을 기준으로 업무 데이터의 유효성 또는 상태를 확인한다.
   *   조회 결과와 원본 분기 조건에 따라 OUT 파라미터 또는 상태 값을 설정한다.
   *   호출부가 결과 코드와 메시지로 후속 처리를 판단할 수 있게 한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_BARCODE_TARGET - 원본 선언부 기준 입력/출력 파라미터
   *   P_MCN_ID - 원본 선언부 기준 입력/출력 파라미터
   *   P_POSITION - 원본 선언부 기준 입력/출력 파라미터
   *   P_BARCODE_SOURCE - 원본 선언부 기준 입력/출력 파라미터
   *   P_ACTION_TYPE - 원본 선언부 기준 입력/출력 파라미터
   *   P_OUT - 원본 선언부 기준 입력/출력 파라미터
   *   PB - 원본 선언부 기준 입력/출력 파라미터
   *   PDA - 원본 선언부 기준 입력/출력 파라미터
   *   PC - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IMCN_JIG_CABLE - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_MSG
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_CHECK_CABLE_MANAGE(...)
   * ================================================================ */
                                                 ,p_mcn_id          in varchar2
                                                 ,p_position        in varchar2
                                                 ,p_barcode_source  in varchar2
                                                 ,p_action_type     in varchar2
                                                 ,p_out            out varchar2
                                                 )  is
  lvl_count number ; -- [AI] 내부 처리용 변수
  --교체 작업시 사용
  lvs_mcn_id   varchar2(30); -- [AI] 내부 처리용 변수
  lvs_position varchar2(20); -- [AI] 내부 처리용 변수

  lvs_msg      varchar2(30); -- [AI] 내부 처리용 변수

begin
   -- [AI] 주요 업무 처리 로직을 시작한다.
  /**********************************************************************/
  /* action type 3 장착  ( target 을 3 (장착 ) 한다.
  /*             4 회수  ( target 을 4 (회수 ) 한다.
  /*             9 교체  ( source 를 4 ( 회수 ) 하고 , target 을 3 ( 장착 ) 한다.

    CABLE STATUS  1  양품재고
    CABLE STATUS  2  불량재고
    CABLE STATUS  3  장착사용
    CABLE STATUS  4  장착대기

    Action

    CABLE TXN TYPE  1  입고          PB UI
    CABLE TXN TYPE  2  현장출고       PB UI
    CABLE TXN TYPE  3  장착          PDA     --현장 출고 된 케이블만 장착 가능 cable status 4 ( 장착 대기 )
    CABLE TXN TYPE  4  회수          PDA     --장착 사용중인것만 회수 가능 cable status 3 ( 장착 사용 )
    CABLE TXN TYPE  5  양품반납       PB UI    -- cable status 4 인것만 반납 가능
    CABLE TXN TYPE  6  불량반납       PB UI    -- cable status 4 인것만 반납 가능

  /**********************************************************************/
  if p_action_type = '3' then  --장착

    --1. 장착 위치가 비워 있는지 확인
    select count(1)
      into lvl_count
      from imcn_jig_cable x
     where x.mcn_id       = p_mcn_id
       and x.mcn_position = p_position ;

    if lvl_count > 0 then
      p_out := 'NG-'||p_mcn_id||' '||p_position||F_MSG(' 에 이미 다른 케이블이 사용중 입니다. 회수 부터 진행 하세요','C',1) ;
      return ;
    end if ;

    --2. 해당 바코드가 장착 가능 상태인지 확인
    select count(1)
      into lvl_count
      from imcn_jig_cable x
     where x.cable_barcode = p_barcode_target
       and x.cable_status  = '4'  ;  --장착 대기 상태

    if lvl_count = 0 then
      p_out := 'NG-'||length(p_barcode_target)||F_MSG(' 는 장착 대기 상태가 아닙니다. 공정출고가 되어있는지 확인 하세요','C',1);
      return ;
    end if ;

    --장착 작업 시작
    begin
      update imcn_jig_cable x
         set x.cable_status = '3' --장착사용중
            ,x.io_deficit   = '3' --장착작업
            ,x.mcn_id       = p_mcn_id
            ,x.mcn_position = p_position
            ,x.install_date = sysdate
            ,x.release_date = null     --회수일자는 리셋
            ,x.apply_date   = decode(x.apply_date,null,sysdate,x.apply_date) --최초 사용일자 만들기
            ,x.expire_date  = decode(x.apply_date,null,sysdate,x.apply_date) + nvl(x.life_cycle,1)
            ,x.last_modify_date = sysdate
       where x.cable_barcode = p_barcode_target
         and x.cable_status  in ( '1',  '4')  --양품재고, 장착대기 상태
       ;
    exception
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      when others then
         p_out := 'NG-'||F_MSG(F_MSG('관라자 확인용 :','C',1),'C',1)||substr(sqlerrm,1,100);
         rollback ;
         return ;
    end ;

    commit ;
    p_out := 'OK-장착완료' ;


  elsif p_action_type = '4' then  --회수
    --1. 해당 케이블이 장착 상태인지 확인
    select count(1)
      into lvl_count
      from imcn_jig_cable x
     where x.cable_barcode = p_barcode_target
       and x.cable_status  = '3'  ;

    if lvl_count = 0 then
      p_out := 'NG-'||p_barcode_target||' '||p_position||F_MSG(' 장착 사용중이 아닙니다. 확인 하세요!','C',1);
      return ;
    end if ;

    --2. 회수를 한다
    begin

      update imcn_jig_cable x
         set x.cable_status = '4' --장착대기로
            ,x.io_deficit   = '4' --회수작업
            ,x.mcn_id       = null
            ,x.mcn_position = null
            ,x.release_date = sysdate
            ,x.last_modify_date = sysdate
       where x.cable_barcode = p_barcode_target
         and x.cable_status  = '3' --장착상태
       ;

    exception
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      when others then
         p_out := 'NG-'||F_MSG('관라자 확인용 :','C',1)||substr(sqlerrm,1,100);
         rollback ;
         return ;
    end ;

    commit ;
    p_out := f_msg('OK-회수완료','C',1) ;

  elsif p_action_type = '9' then
    /**********************************
    * 회수 / 장착  교체작업
    ***********************************/
    --1. 해당 케이블이 장착 상태인지 확인
    select count(1)
      into lvl_count
      from imcn_jig_cable x
     where x.cable_barcode = p_barcode_source
       and x.cable_status  = '3' --장착 사용상태
     ;

    if lvl_count = 0 then
      p_out := 'NG-'||f_msg('회수할 케이블 은 장착 사용중 상태여야 합니다. 확인 하세요!','C',1);
      return ;
    end if ;

    --2. 해당 바코드가 장착 가능 상태인지 확인
    select count(1)
      into lvl_count
      from imcn_jig_cable x
     where x.cable_barcode = p_barcode_target
       and x.cable_status  IN ('1',  '4')  ;  --장착 대기 상태

    if lvl_count = 0 then
      p_out := 'NG-'||f_msg('장착할  케이블 은 장착대기 상태가 아닙니다. 확인 하세요!','C',1);
      return ;
    end if ;

    --3. 기 사용중인 바ㅗ드의 PC , 위치 를 가져온다
    lvs_msg := '30';

    select x.mcn_id  , x.mcn_position
      into lvs_mcn_id, lvs_position
      from imcn_jig_cable x
     where x.cable_barcode = p_barcode_source
       and x.cable_status  = '3' --장착 사용상태
    ;

    /*회수*/
    begin
      lvs_msg := '40';
      update imcn_jig_cable x
         set x.cable_status = '4' --장착대기로
            ,x.io_deficit   = '4' --회수작업
            ,x.mcn_id       = null
            ,x.mcn_position = null
            ,x.release_date = sysdate
            ,x.last_modify_date = sysdate
       where x.cable_barcode = p_barcode_source
         and x.cable_status  = '3' --장착상태
       ;
      lvs_msg := '50';
      update imcn_jig_cable x
         set x.cable_status = '3' --장착사용중
            ,x.io_deficit   = '3' --장착작업
            ,x.mcn_id       = lvs_mcn_id
            ,x.mcn_position = lvs_position
            ,x.install_date = sysdate
            ,x.release_date = null
            ,x.apply_date   = decode(x.apply_date,null,sysdate,x.apply_date)  --최초 사용일자 만들기
            ,x.expire_date  = decode(x.apply_date,null,sysdate,x.apply_date) + nvl(x.life_cycle,1)
            ,x.last_modify_date = sysdate
       where x.cable_barcode = p_barcode_target
         and x.cable_status  in ( '1', '4')  --양품재고,장착대기 상태
       ;

    exception
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
      when others then
         p_out := 'NG-'||F_MSG('관라자 확인용 :','C',1)||lvs_msg||' '||substr(sqlerrm,1,100);
         rollback ;
         return ;
    end ;

    commit ;
    p_out := f_msg('OK-교체완료','C',1) ;

  end if ;

end P_CHECK_CABLE_MANAGE;