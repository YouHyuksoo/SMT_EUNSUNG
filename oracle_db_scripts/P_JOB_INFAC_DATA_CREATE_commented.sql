CREATE OR REPLACE PROCEDURE P_JOB_INFAC_DATA_CREATE
  /* ================================================================
   * 프로시저명  : P_JOB_INFAC_DATA_CREATE
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2011-00-00
   * 수정이력:
   *   2011-00-00 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
 *   2026-10-11 - AI(Claude)      - 공정출고 생성을 P_WIP_ISSUE_CREATE 호출로 바꿈 (전 고객 대상)
   * ================================================================
   * [AI 분석] 기능 설명:
   *   업무 기준 데이터 또는 바코드를 생성하고 대상 테이블에 등록한다.
   *   시퀀스, 현재일자, 입력 파라미터 등 원본 생성 규칙을 그대로 사용한다.
   *   정상 처리 또는 오류 결과는 원본 OUT 파라미터/예외 처리 흐름을 따른다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   없음
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ESEAI_M107_TEMP - 원본 로직 참조 테이블
   *   ID_ITEM - Item Master
   *   IM_ITEM_INVENTORY - Item Inventory Master
   *   IM_ITEM_WORKSTAGE_INVENTORY - Item Inventory Master
   *   IM_ITEM_WORKSTAGE_ISSUE - Item Issue Master
   *   IP_PRODUCT_FG_INVENTORY - 원본 로직 참조 테이블
   *   IP_PRODUCT_MODEL_MASTER - 원본 로직 참조 테이블
   *   IP_PRODUCT_PACK_MASTER - 원본 로직 참조 테이블
   *   IP_PRODUCT_RUN_CARD - 원본 로직 참조 테이블
   *   ISYS_BATCHJOBERRLOG - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   FROM
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_JOB_INFAC_DATA_CREATE(...)
   * ================================================================ */
IS

   lvl_count1     number default 0 ; -- [AI] 내부 처리용 변수
   lvl_count2     number default 0 ; -- [AI] 내부 처리용 변수
   lvs_message    varchar2(200); -- [AI] 내부 처리용 변수

BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.

-------------------------------------------------------------------
--  공정출고생성 
--  E2011000050 제외
-------------------------------------------------------------------

-- 2026-10-11: 고객 IP 제품 × 공급사 IP 자재만 만들던 공정출고를 모든 고객 제품으로 넓혔다.
--   예전에는 나머지 포장에 처리 표시만 해서 다른 고객 자재의 공정재고가 줄지 않았다.
--   생성 규칙(BOM 말단 자재 × 누적 소요량)과 처리 표시는 P_WIP_ISSUE_CREATE 가 맡는다 (2023-07-01 이후 포장만).
P_WIP_ISSUE_CREATE(TO_DATE('20230701', 'YYYYMMDD'));

-------------------------------------------------------------------
--  원자재 창고재고 생성 
-------------------------------------------------------------------
    INSERT INTO eseai_m107_temp (
                                dt_if,
                                cd_sl,
                                cd_item,
                                yn_process,
                                dc_errormsg,
                                qt_im,
                                dts_create,
                                transfer_date,
                                transfer_yn )
                         SELECT TO_CHAR(SYSDATE , 'YYYYMMDD') AS dt_if,
                                'ESEM' AS cd_sl ,
                                ITEM_CODE AS cd_item ,
                                NULL AS yn_process,
                                NULL AS dc_errormsg,
                                SUM( INVENTORY_QTY ) AS qt_im,
                                TO_CHAR(SYSDATE , 'HH24:MI:SS') AS dts_create ,
                                NULL AS transfer_date ,
                                'N' transfer_yn
                           FROM IM_ITEM_INVENTORY
                          WHERE ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE SUPPLIER_CODE = 'IP'  )
                          GROUP BY ITEM_CODE ;
       -------------------------------------------------------------------
       --  원자재 공정재고 생성 
       --
       -------------------------------------------------------------------
    INSERT INTO eseai_m107_temp (
                                dt_if,
                                cd_sl,
                                cd_item,
                                yn_process,
                                dc_errormsg,
                                qt_im,
                                dts_create,
                                transfer_date,
                                transfer_yn )
                         SELECT TO_CHAR(SYSDATE , 'YYYYMMDD') AS dt_if,
                                'ESEF' AS cd_sl ,
                                ITEM_CODE AS cd_item ,
                                NULL AS yn_process,
                                NULL AS dc_errormsg,
                                SUM( INVENTORY_QTY ) AS qt_im,
                                TO_CHAR(SYSDATE , 'HH24:MI:SS') AS dts_create ,
                                NULL AS transfer_date ,
                                'N' transfer_yn
                           FROM IM_ITEM_WORKSTAGE_INVENTORY
                          WHERE ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE SUPPLIER_CODE = 'IP'  )
                          GROUP BY ITEM_CODE ;
 
      -------------------------------------------------------------------
      --  제품 공정재고 생성 
      --  E2011000050  제외
      -------------------------------------------------------------------
    INSERT INTO eseai_m107_temp (
                                dt_if,
                                cd_sl,
                                cd_item,
                                yn_process,
                                dc_errormsg,
                                qt_im,
                                dts_create,
                                transfer_date,
                                transfer_yn
                                )
                                
                        SELECT  TO_CHAR(SYSDATE , 'YYYYMMDD') AS dt_if,
                                'ESEG'  cd_sl,
                                cd_item,
                                NULL yn_process,
                                NULL dc_errormsg,
                                SUM(qt_im) qt_im,
                                TO_CHAR(SYSDATE , 'HH24:MI:SS') AS dts_create,
                                NULL transfer_date,
                                'N' transfer_yn
                            FROM 
                            (     
                                  SELECT 
                                        PART_NO AS cd_item ,
                                        SUM( PACKING_PCS_QTY ) AS qt_im
                                     
                                   FROM IP_PRODUCT_PACK_MASTER
                                  WHERE MODEL_NAME  IN ( SELECT MODEL_NAME FROM IP_PRODUCT_MODEL_MASTER WHERE CUSTOMER_CODE = 'IP'  )
                                    AND MODEL_NAME NOT IN ( 'DANA-LPS-680pF')
                                    AND RECEIPT_FLAG = 'N'
                                    AND PACKING_PCS_QTY > 0 
                                  GROUP BY PART_NO 
                                                          
                                     UNION ALL
                                     
                                 SELECT 
                                        ITEM_CODE AS cd_item ,
                                        SUM( QTY ) AS qt_im
                                   FROM IP_PRODUCT_FG_INVENTORY
                                  WHERE MODEL_NAME  IN ( SELECT MODEL_NAME FROM IP_PRODUCT_MODEL_MASTER WHERE CUSTOMER_CODE = 'IP'  )
                                    AND MODEL_NAME NOT IN ( 'DANA-LPS-680pF')
                                    AND NVL(QTY ,0) > 0 
                                  GROUP BY ITEM_CODE 
                                  )
                              WHERE CD_ITEM NOT IN ( 'E2011000050')    
                              GROUP BY  cd_item   ;
       -------------------------------------------------------------------
       -- insert log 생성
       -------------------------------------------------------------------

      lvs_message := 'INSERT => '||to_char(lvl_count1)||', UPDATE => '||to_char(lvl_count2);

      insert into isys_batchjoberrlog ( 
                                        batch_job_seq ,
                                        organization_id,
                                        batch_job_process_name,
                                        batch_job_object_name,
                                        batch_job_status_code,
                                        batch_job_remark,
                                        enter_by,
                                        log_date  
                                      )
                               values (
                                        null,
                                        1,
                                        'INFAC_DATA_CREATE',
                                        'P_JOB_INFAC_DATA_CREATE',
                                        'CREATE OK',
                                        lvs_message,
                                        'JOB',
                                        sysdate
                                      );

      COMMIT;


-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------
EXCEPTION

   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
 WHEN OTHERS THEN

      lvs_message := substr(SQLERRM, 1, 200);

      insert into isys_batchjoberrlog ( 
                                        batch_job_seq ,
                                        organization_id,
                                        batch_job_process_name,
                                        batch_job_object_name,
                                        batch_job_status_code,
                                        batch_job_remark,
                                        enter_by,
                                        log_date  
                                      )
                               values (
                                        null,
                                        1,
                                        'INFAC_DATA_CREATE',
                                        'P_JOB_INFAC_DATA_CREATE',
                                        'CREATE NG',
                                        lvs_message,
                                        'JOB',
                                        sysdate
                                      );

      commit;

END;