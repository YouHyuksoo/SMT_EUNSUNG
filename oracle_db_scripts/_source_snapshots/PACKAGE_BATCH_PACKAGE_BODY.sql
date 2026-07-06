PACKAGE BODY "PACKAGE_BATCH" is

  procedure p_daily is
  begin
      /***********************
      * 매일 00:01 에 작업 시작 함  씨펄
      ************************/

      ------------------------------------------------
      -- 장기 재고 플래그 설정 YHS
      ------------------------------------------------
      BEGIN

      update ip_product_2d_barcode set longterm_yn = 'Y'
       where receipt_date < sysdate - 60
           and NVL(longterm_yn , 'N') = 'N'
           and organization_id  = 1 ;


      COMMIT ;

    EXCEPTION WHEN OTHERS THEN

              p_job_errorlog(920,1,'DAILY BATCHJOB','PACKAGE_BATCH',substr(sqlerrm,1,200),'JOB') ;
            --   raise_application_error(-20099,'TRG NG : '||substr(sqlerrm,1,150));
         NULL ;
     END ;
      /************************
      * 실행할 프로시저를 호출
      ************************/


  end p_daily ;

end PACKAGE_BATCH;