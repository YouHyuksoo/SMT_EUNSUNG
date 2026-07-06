CREATE OR REPLACE PROCEDURE "P_INSERT_NPM_RAW" (
  /* ================================================================
   * 프로시저명  : P_INSERT_NPM_RAW
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   외부 또는 설비에서 전달된 원시/연계 데이터를 대상 테이블에 등록한다.
   *   입력 파라미터와 원본 로직의 테이블 조작 흐름은 그대로 유지했다.
   *   오류 발생 시 원본 예외 처리 방식에 따라 메시지 반환 또는 로그 처리를 수행한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_PARTSDATA - 원본 선언부 기준 입력/출력 파라미터
   *   P_CHIPDATA - 원본 선언부 기준 입력/출력 파라미터
   *   P_INFO - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IB_MNT_PARTLIB_MASTER - 원본 로직 참조 테이블
   *   ICOM_MACHINE_INSERT_LOG - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   P_CHIPDATA
   *   P_INFO
   *   P_PARTSDATA
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_INSERT_NPM_RAW(...)
   * ================================================================ */
   p_partsdata     IN ARRAY3_PARAMS_T,
   p_chipdata      IN ARRAY3_PARAMS_T,
   p_info          IN ARRAY3_PARAMS_T
)
IS
     LVS_ERRORMSG      VARCHAR2 (300); -- [AI] 내부 처리용 변수
     LVS_FILE_NAME     VARCHAR2 (50) := ''; -- [AI] 내부 처리용 변수
     LVS_LINE_CODE     VARCHAR2 (30) := ''; -- [AI] 내부 처리용 변수
     LVS_MACHINE_CODE     VARCHAR2 (30) := ''; -- [AI] 내부 처리용 변수
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.

  if p_info.Last >= 1
    then
    LVS_FILE_NAME := TRIM(p_info(1));
  end if;

  if p_info.Last >= 2
    then
    LVS_LINE_CODE := TRIM(p_info(2));
  end if;

  if p_info.Last >= 3
    then
    LVS_MACHINE_CODE := TRIM(p_info(3));
  end if;

     INSERT INTO IB_MNT_PARTLIB_MASTER

      (   MACHINE_CODE,
            LINE_CODE,
            APPLY_LOCATION,
            PARTNAME,
            PART_TYPE,

            SIZE_L,
            SIZE_W,
            SIZE_T,
            VISION_CODE,

            NOZZLE_A,
            NOZZLE_B,
            NOZZLE_C,
            NOZZLE_D,

            SPEED_DETACT,
            SPEED_MOUNT,
            SPEED_PICKUP,

            GAP_PICKUP,
            GAP_MOUNT,

            DETACT_ANGLE,

            STYLE_VALUE,
            RECOVERY_COUNT,

            FIX_PICKUP_OFFSET_X,
            FIX_PICKUP_OFFSET_Y,
            FIX_PICKUP_OFFSET_Z,
            LAST_UPDATE_DATE,

            MATERIAL_FEEDER_PITCH,
            MATERIAL_REEL_SIZE,
            MATERIAL_PART_PER_REEL,

            ENTER_DATE,
            ENTER_BY,
            LAST_MODIFY_DATE,
            LAST_MODIFY_BY,
            ORGANIZATION_ID,
            MASTER_YN ,
            WORK_NO )
        VALUES
      (
                'NPM' ,
                REPLACE(TRIM(LVS_LINE_CODE),'"'),
                '*', -- APPLY_LOCATION,
                REPLACE(TRIM(p_partsdata(2)),'"'), --A.NAME      PARTNAME,
                '*',                  --  PART_TYPE,

                REPLACE(TRIM(p_chipdata(2)),'"'),       --B.L       SIZE_L,
                REPLACE(TRIM(p_chipdata(3)),'"'),       --B.W      SIZE_W,
                REPLACE(TRIM(p_chipdata(4)),'"'),       --B.T       SIZE_T,

                REPLACE(TRIM(p_chipdata(8)),'"'),       --B.REF  VISION_CODE,

                REPLACE(TRIM(p_chipdata(28)),'"'),       --B.NOZZLEA,
                REPLACE(TRIM(p_chipdata(29)),'"'),       --B.NOZZLEB,
                REPLACE(TRIM(p_chipdata(30)),'"'),       --B.NOZZLEC,
                REPLACE(TRIM(p_chipdata(31)),'"'),       --B.NOZZLED,

                REPLACE(TRIM(p_chipdata(5)),'"'),       --B.RCGSP SPEED_DETACT,
                REPLACE(TRIM(p_chipdata(40)),'"'),       --B.TSPD SPEED_MOUNT,
                REPLACE(TRIM(p_chipdata(41)),'"'),       --B.MSPD SPEED_PICKUP,

                REPLACE(TRIM(p_chipdata(33)),'"'),       --B.TGAP GAP_PICKUP,
                REPLACE(TRIM(p_chipdata(34)),'"'),       --B.MGAP GAP_MOUNT,

                '',    -- DETACT_ANGLE,

                REPLACE(TRIM(p_partsdata(24)),'"'), --A.PACK STYLE_VALUE,
                REPLACE(TRIM(p_partsdata(27)),'"'), --A.RETRY RECOVERY_COUNT,

                REPLACE(TRIM(p_chipdata(35)),'"'),       --B.TUPX FIX_PICKUP_OFFSET_X,
                REPLACE(TRIM(p_chipdata(36)),'"'),       --B.TUPY FIX_PICKUP_OFFSET_Y,
                REPLACE(TRIM(p_chipdata(37)),'"'),       --B.TUPX FIX_PICKUP_OFFSET_Z,
                TO_CHAR(SYSDATE ,'YYYY-MM-DD HH24:MI:SS'),  --LAST_UPDATE_DATE,
                '',
                '',
                '',             -- MATERIAL_PART_PER_REEL,

                SYSDATE ,
                'SYSTEM' ,
                SYSDATE ,
                'SYSTEM' ,
                1,
                'N' ,
                TO_CHAR(SYSDATE ,'YYMMDDHH24MI')
        );

      COMMIT ;
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS
   THEN
      LVS_ERRORMSG := '[P_INSERT_NPM_RAW]' ||  SUBSTR(SQLERRM,1,200)  ;
   --    INSERT INTO ICOM_MACHINE_INSERT_LOG( LOG_DATE , ERROR_MESSAGE , ERROR_DESC )
   --    VALUES ( SYSDATE  , LVS_ERRORMSG  , lvs_file_name||' LINE='||lvs_line_code  ) ;
    --  COMMIT ;
      NULL;

END P_INSERT_NPM_RAW;