CREATE OR REPLACE PROCEDURE "P_CREATE_FG_PALLET_BARCODE" (
  /* ================================================================
   * 프로시저명  : P_CREATE_FG_PALLET_BARCODE
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   완제품 팔레트 번호를 생성하고 IP_PRODUCT_FG_PALLET 마스터에 등록한다.
   *   현재일자, 고정 사이트 코드 KV, SEQ_FG_PALLET_NO_SEQ 시퀀스를 조합해 팔레트 바코드를 만든다.
   *   신규 팔레트 수량은 0으로 생성하고 정상 시 생성된 팔레트 번호를 메시지로 반환한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_MODEL   (IN, VARCHAR2) - 팔레트 대상 모델명
   *   P_SUFFIX  (IN, VARCHAR2) - 모델 서픽스, NULL이면 *로 저장
   *   P_OUT     (OUT, VARCHAR2) - 처리 결과, OK 또는 NG
   *   P_MSG     (OUT, VARCHAR2) - 생성 팔레트 번호 또는 오류 메시지
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_FG_PALLET - 파렛트 작업 마스터
   * ================================================================
   * [AI 분석] 호출 객체:
   *   SEQ_FG_PALLET_NO_SEQ - 팔레트 번호 순번 생성 시퀀스
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN OTHERS - ROLLBACK 후 P_OUT에 NG, P_MSG에 오류 메시지를 설정한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 없음
   *   DML: INSERT 1회
   *   주의: AUTONOMOUS_TRANSACTION, COMMIT 및 ROLLBACK 포함
   * ================================================================
   * 사용 예시:
   *   EXEC P_CREATE_FG_PALLET_BARCODE('MODEL01', 'SFX', :P_OUT, :P_MSG)
   * ================================================================ */
p_model varchar2, p_suffix varchar2,  p_out out varchar2, p_msg out varchar2 ) is

  Pragma autonomous_transaction ;

  lvs_seq  varchar2(5); -- [AI] 팔레트 번호용 5자리 시퀀스 문자열
  lvs_site varchar2(4); -- [AI] 팔레트 번호에 포함할 사이트 코드
  lvs_date varchar2(8); -- [AI] 팔레트 번호에 포함할 생성일자
  lvs_barcode varchar2(30); -- [AI] 최종 생성 팔레트 바코드
  lvl_pack_unit_qty number ; -- [AI] 포장 단위 수량 변수, 현재 로직에서는 미사용

begin
    --SEQ_FG_PALLET_NO_SEQ
    -- DDGZ + 날짜 + SEQ
    -- [AI] 시퀀스, 사이트 코드, 현재일자를 조합해 팔레트 번호 구성 요소를 만든다.
    lvs_seq  := trim(to_char( SEQ_FG_PALLET_NO_SEQ.NEXTVAL,'FM00000')) ;
    lvs_site := 'KV' ;
    lvs_date := to_char( sysdate,'yyyymmdd') ;

    lvs_barcode := lvs_date||lvs_site||lvs_seq ;

    -- [AI] 생성된 팔레트 번호로 완제품 팔레트 마스터를 등록한다.
    insert into ip_product_fg_pallet (

      pallet_no,
      pallet_date,
      model_name,
      model_suffix,
      pallet_qty,

      enter_by,
      enter_date,
      last_modify_by,
      last_modify_date,
      organization_id

    ) values (
      lvs_barcode,
      sysdate,
      p_model,
      nvl(p_suffix,'*'),
      0,
      'PRC',
      sysdate,
      'PRC',
      sysdate,
      1
    );


    -- [AI] 팔레트 생성 결과를 확정한다.
    commit ;

    p_out := 'OK' ;
    p_msg := lvs_barcode;
exception
  -- [AI] 오류 발생 시 팔레트 생성을 되돌리고 실패 메시지를 반환한다.
  when others then
    rollback ;
    p_out := 'NG' ;
    p_msg := 'P_CREATE_FG_PALLET_BARCODE'||substr(sqlerrm,1,100);
end P_CREATE_FG_PALLET_BARCODE;
