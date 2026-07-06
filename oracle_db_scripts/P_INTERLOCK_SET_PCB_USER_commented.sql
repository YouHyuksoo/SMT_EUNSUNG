CREATE OR REPLACE PROCEDURE "P_INTERLOCK_SET_PCB_USER" (
  /* ================================================================
   * 프로시저명  : P_INTERLOCK_SET_PCB_USER
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   사용자가 스캔한 PCB 정보를 IP_PRODUCT_PCB_SCAN_MASTER에 등록한다.
   *   라인, 공정, 설비, 품목, 공급처, 수량, PCB 바코드, Run No, 모델명과 사용자 정보를 저장한다.
   *   정상 등록 시 OK를 반환하고 COMMIT한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_LINE_CODE       (IN, VARCHAR2) - 라인 코드
   *   P_WORKSTAGE_CODE  (IN, VARCHAR2) - 공정 코드
   *   P_MACHINE_CODE    (IN, VARCHAR2) - 설비 코드
   *   P_ITEM_CODE       (IN, VARCHAR2) - PCB 품목 코드
   *   P_SUPPLIER_CODE   (IN, VARCHAR2) - 공급처 코드
   *   P_LOT_QTY         (IN, NUMBER) - LOT 수량
   *   P_PCB_BARCODE     (IN, VARCHAR2) - PCB 바코드
   *   P_RUN_NO          (IN, VARCHAR2) - Run No
   *   P_MODEL_NAME      (IN, VARCHAR2) - 모델명
   *   P_OUT             (OUT, VARCHAR2) - 처리 결과, OK 또는 ERROR
   *   P_USERID          (IN, VARCHAR2) - 스캔 사용자 ID
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_PCB_SCAN_MASTER - PCB 스캔 마스터 테이블
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN OTHERS - P_OUT에 ERROR를 설정하고 종료한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 없음
   *   DML: INSERT 1회
   *   주의: COMMIT 포함
   * ================================================================
   * 사용 예시:
   *   EXEC P_INTERLOCK_SET_PCB_USER('L1','W010','MC01','ITEM','SUP',1,'PCB','RUN','MODEL',:P_OUT,'USER')
   * ================================================================ */
P_LINE_CODE        IN     VARCHAR2,
                                                     P_WORKSTAGE_CODE   IN     VARCHAR2,
                                                     P_MACHINE_CODE     IN     VARCHAR2,
                                                     P_ITEM_CODE        IN     VARCHAR2,
                                                     P_SUPPLIER_CODE    IN     VARCHAR2,
                                                     P_LOT_QTY          IN     NUMBER,
                                                     P_PCB_BARCODE      IN     VARCHAR2,
                                                     P_RUN_NO           IN     VARCHAR2,
                                                     P_MODEL_NAME       IN     VARCHAR2,
                                                     P_OUT              OUT    VARCHAR2,
                                                     P_USERID           IN     VARCHAR2
                                                   )
IS

    LVS_PART_NO   VARCHAR2(100); -- [AI] 예비 품번 변수, 현재 로직에서는 미사용
    LVL_COUNT     NUMBER; -- [AI] 예비 카운트 변수, 현재 로직에서는 미사용

BEGIN

    -- [AI] 사용자 스캔 PCB 정보를 PCB 스캔 마스터에 등록한다.
    INSERT INTO IP_PRODUCT_PCB_SCAN_MASTER (LINE_CODE,
                                            WORKSTAGE_CODE,
                                            MACHINE_CODE,
                                            PCB_BARCODE,
                                            ITEM_CODE,
                                            RUN_NO,
                                            SUPPLIER_CODE,
                                            LOT_QTY,
                                            ORGANIZATION_ID,
                                            ENTER_DATE,
                                            ENTER_BY,
                                            LAST_MODIFY_DATE,
                                            LAST_MODIFY_BY,
                                            SCAN_DATE,
                                            SCAN_BY,
                                            MODEL_NAME)
      VALUES   (
                P_LINE_CODE,
                P_WORKSTAGE_CODE,
                P_MACHINE_CODE,
                P_PCB_BARCODE,
                P_ITEM_CODE,
                P_RUN_NO,
                P_SUPPLIER_CODE,
                P_LOT_QTY,
                1,
                SYSDATE,
                P_USERID,
                SYSDATE,
                P_USERID,
                SYSDATE,
                P_USERID,
                P_MODEL_NAME
                );

    -- [AI] 정상 처리 결과를 반환하고 등록 내용을 확정한다.
    P_OUT := 'OK';
    COMMIT ;
    RETURN;

EXCEPTION

    -- [AI] 오류 발생 시 실패 결과를 반환한다.
    WHEN OTHERS THEN
        P_OUT := 'ERROR';
        RETURN;

END;
