CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_IB_MNT_PARTLIB_MASTER_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IB_MNT_PARTLIB_MASTER 테이블의 INSERT 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IB_MNT_PARTLIB_MASTER - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.LINE_CODE - 신규/변경 후 라인 관련 값
   *   :NEW.MACHINE_CODE - 신규/변경 후 설비 관련 값
   *   :NEW.PARTNAME - 신규/변경 후 값 값
   *   :NEW.APPLY_LOCATION - 신규/변경 후 값 값
   *   :NEW.ORGANIZATION_ID - 신규/변경 후 값 값
   *   :NEW.PART_TYPE - 신규/변경 후 값 값
   *   :NEW.SIZE_L - 신규/변경 후 값 값
   *   :NEW.SIZE_W - 신규/변경 후 값 값
   *   :NEW.SIZE_T - 신규/변경 후 값 값
   *   :NEW.VISION_CODE - 신규/변경 후 값 값
   *   :NEW.NOZZLE_A - 신규/변경 후 값 값
   *   :NEW.NOZZLE_B - 신규/변경 후 값 값
   *   :NEW.SPEED_DETACT - 신규/변경 후 값 값
   *   :NEW.SPEED_MOUNT - 신규/변경 후 값 값
   *   :NEW.SPEED_PICKUP - 신규/변경 후 값 값
   *   :NEW.GAP_PICKUP - 신규/변경 후 값 값
   *   :NEW.GAP_MOUNT - 신규/변경 후 값 값
   *   :NEW.DETACT_ANGLE - 신규/변경 후 값 값
   *   :NEW.STYLE_VALUE - 신규/변경 후 값 값
   *   :NEW.RECOVERY_COUNT - 신규/변경 후 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IB_MNT_PARTLIB_MASTER - 업무 데이터 트리거 대상 테이블
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: INSERT 1회, UPDATE 1회, DELETE 1회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_IB_MNT_PARTLIB_MASTER_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_IB_MNT_PARTLIB_MASTER_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_IB_MNT_PARTLIB_MASTER_INS" 
BEFORE INSERT
ON IB_MNT_PARTLIB_MASTER
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE

PRAGMA AUTONOMOUS_TRANSACTION;

phase varchar2(10) ;
BEGIN


phase := '20' ;
   -----------------------------------------------------------------------------
   -- ？？？？？？？？？？？？？？？？？？？？？o？？
   --
   -----------------------------------------------------------------------------

   UPDATE IB_MNT_PARTLIB_MASTER
      SET IS_NEW_YN = 'N'
    WHERE     LINE_CODE = :NEW.LINE_CODE
          AND MACHINE_CODE = :NEW.MACHINE_CODE
          AND MASTER_YN <> 'Y'
          AND IS_NEW_YN = 'Y'
          AND PARTNAME = :NEW.PARTNAME
          AND APPLY_LOCATION = :NEW.APPLY_LOCATION
          AND ORGANIZATION_ID = :NEW.ORGANIZATION_ID;


   phase := '30' ;
   -------------------------------------------------------------------------------
   ---- ？？？？？？？？？
   -------------------------------------------------------------------------------
   DELETE FROM IB_MNT_PARTLIB_MASTER
    WHERE     LINE_CODE = :NEW.LINE_CODE
          AND MACHINE_CODE = :NEW.MACHINE_CODE
          AND MASTER_YN <> 'Y'

          AND APPLY_LOCATION = :NEW.APPLY_LOCATION
          AND PARTNAME = :NEW.PARTNAME
          AND (   LINE_CODE
               || MACHINE_CODE
               || APPLY_LOCATION
               || PARTNAME
               || PART_TYPE
               || SIZE_L
               || SIZE_W
               || SIZE_T
               || VISION_CODE
               || NOZZLE_A
               || NOZZLE_B
               || SPEED_DETACT
               || SPEED_MOUNT
               || SPEED_PICKUP
               || GAP_PICKUP
               || GAP_MOUNT
               || DETACT_ANGLE
               || STYLE_VALUE
               || RECOVERY_COUNT
               || FIX_PICKUP_OFFSET_X
               || FIX_PICKUP_OFFSET_Y
               || FIX_PICKUP_OFFSET_Z
               || LAST_UPDATE_DATE
               || MATERIAL_FEEDER_PITCH
               || MATERIAL_REEL_SIZE
               || MATERIAL_PART_PER_REEL
               || NOZZLE_C
               || NOZZLE_D) =
                 (   :NEW.LINE_CODE
                  || :NEW.MACHINE_CODE
                  || :NEW.APPLY_LOCATION
                  || :NEW.PARTNAME
                  || :NEW.PART_TYPE
                  || :NEW.SIZE_L
                  || :NEW.SIZE_W
                  || :NEW.SIZE_T
                  || :NEW.VISION_CODE
                  || :NEW.NOZZLE_A
                  || :NEW.NOZZLE_B
                  || :NEW.SPEED_DETACT
                  || :NEW.SPEED_MOUNT
                  || :NEW.SPEED_PICKUP
                  || :NEW.GAP_PICKUP
                  || :NEW.GAP_MOUNT
                  || :NEW.DETACT_ANGLE
                  || :NEW.STYLE_VALUE
                  || :NEW.RECOVERY_COUNT
                  || :NEW.FIX_PICKUP_OFFSET_X
                  || :NEW.FIX_PICKUP_OFFSET_Y
                  || :NEW.FIX_PICKUP_OFFSET_Z
                  || :NEW.LAST_UPDATE_DATE
                  || :NEW.MATERIAL_FEEDER_PITCH
                  || :NEW.MATERIAL_REEL_SIZE
                  || :NEW.MATERIAL_PART_PER_REEL
                  || :NEW.NOZZLE_C
                  || :NEW.NOZZLE_D);

                    :NEW.IS_NEW_YN := 'Y';
      COMMIT ;
EXCEPTION
   WHEN OTHERS
   THEN
      ROLLBACK;
      RAISE_APPLICATION_ERROR (-20003, 'PHASE='||phase||' '||SQLERRM);
END TRG_IB_MNT_PARTLIB_MASTER_INS;
