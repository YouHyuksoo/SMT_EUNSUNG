PROCEDURE "P_CHECK_CABLE_MANAGE" ( p_barcode_target  in varchar2
                                                 ,p_mcn_id          in varchar2
                                                 ,p_position        in varchar2
                                                 ,p_barcode_source  in varchar2
                                                 ,p_action_type     in varchar2
                                                 ,p_out            out varchar2
                                                 )  is
  lvl_count number ;
  --교체 작업시 사용
  lvs_mcn_id   varchar2(30);
  lvs_position varchar2(20);

  lvs_msg      varchar2(30);

begin
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
      when others then
         p_out := 'NG-'||F_MSG('관라자 확인용 :','C',1)||lvs_msg||' '||substr(sqlerrm,1,100);
         rollback ;
         return ;
    end ;

    commit ;
    p_out := f_msg('OK-교체완료','C',1) ;

  end if ;

end P_CHECK_CABLE_MANAGE;