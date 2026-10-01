HA$PBExportHeader$w_smt_recycle_check_rpt.srw
$PBExportComments$new a led project
forward
global type w_smt_recycle_check_rpt from w_main_root
end type
type sle_our_barcode from so_singlelineedit within w_smt_recycle_check_rpt
end type
type st_1 from statictext within w_smt_recycle_check_rpt
end type
type st_status from so_statictext within w_smt_recycle_check_rpt
end type
type em_ok from so_editmask within w_smt_recycle_check_rpt
end type
type em_ng from so_editmask within w_smt_recycle_check_rpt
end type
type st_2 from so_statictext within w_smt_recycle_check_rpt
end type
type st_3 from so_statictext within w_smt_recycle_check_rpt
end type
type ddlb_line_code from uo_line_code within w_smt_recycle_check_rpt
end type
type st_4 from statictext within w_smt_recycle_check_rpt
end type
type em_dateset from so_editmask within w_smt_recycle_check_rpt
end type
type em_dateend from so_editmask within w_smt_recycle_check_rpt
end type
type st_5 from statictext within w_smt_recycle_check_rpt
end type
type st_6 from statictext within w_smt_recycle_check_rpt
end type
type st_7 from statictext within w_smt_recycle_check_rpt
end type
type gb_2 from so_groupbox within w_smt_recycle_check_rpt
end type
type gb_1 from so_groupbox within w_smt_recycle_check_rpt
end type
end forward

global type w_smt_recycle_check_rpt from w_main_root
integer width = 4983
integer height = 2276
string title = "Check Recycle Reel"
sle_our_barcode sle_our_barcode
st_1 st_1
st_status st_status
em_ok em_ok
em_ng em_ng
st_2 st_2
st_3 st_3
ddlb_line_code ddlb_line_code
st_4 st_4
em_dateset em_dateset
em_dateend em_dateend
st_5 st_5
st_6 st_6
st_7 st_7
gb_2 gb_2
gb_1 gb_1
end type
global w_smt_recycle_check_rpt w_smt_recycle_check_rpt

type variables
LONG LVL_ROW
end variables

on w_smt_recycle_check_rpt.create
int iCurrent
call super::create
this.sle_our_barcode=create sle_our_barcode
this.st_1=create st_1
this.st_status=create st_status
this.em_ok=create em_ok
this.em_ng=create em_ng
this.st_2=create st_2
this.st_3=create st_3
this.ddlb_line_code=create ddlb_line_code
this.st_4=create st_4
this.em_dateset=create em_dateset
this.em_dateend=create em_dateend
this.st_5=create st_5
this.st_6=create st_6
this.st_7=create st_7
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_our_barcode
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_status
this.Control[iCurrent+4]=this.em_ok
this.Control[iCurrent+5]=this.em_ng
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.ddlb_line_code
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.em_dateset
this.Control[iCurrent+11]=this.em_dateend
this.Control[iCurrent+12]=this.st_5
this.Control[iCurrent+13]=this.st_6
this.Control[iCurrent+14]=this.st_7
this.Control[iCurrent+15]=this.gb_2
this.Control[iCurrent+16]=this.gb_1
end on

on w_smt_recycle_check_rpt.destroy
call super::destroy
destroy(this.sle_our_barcode)
destroy(this.st_1)
destroy(this.st_status)
destroy(this.em_ok)
destroy(this.em_ng)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.ddlb_line_code)
destroy(this.st_4)
destroy(this.em_dateset)
destroy(this.em_dateend)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.st_7)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event activate;call super::activate;/***************************************
* Window Default Property 
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20051101'
Gst_set.last_modify_date = '20051101'
Gst_set.Report_window    = True  // Report Window  True / Flase

/*****************************************
* Data Window Property
******************************************/
Ivs_resize_type                      = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

/****************************************
* Menu Property 
*****************************************
* ADMIN  ( All Control )
* MANAGE ( Manager )
* GUEST  ( Only Query )
* QUERY  ( Only Query  )
* DATA_CONTROL  ( Insert Delete Update )
* REPORT ( Report )
****************************************/
F_MENU_CONTROL('REPORT' , TRUE)  // All Data Control
end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
st_status.width = dw_1.width
sle_our_barcode.setfocus()
end event

event ue_data_control;call super::ue_data_control;
CHOOSE CASE Gvs_Ue_DATA_control
		
	CASE 'RETRIEVE'
			DW_1.RESET( )
			DW_1.RETRIEVE( em_dateset.text , em_dateend.text , ddlb_line_code.getcode( )+'%' ,  gvi_organization_id )
			sle_our_barcode.setfocus()
	CASE 'INSERT'		
		
			LVL_ROW = DW_1.INSERTROW(0)
			DW_1.SCROLLTOROW(LVL_ROW)

			
	CASE ELSE
END CHOOSE
end event

event resize;call super::resize;st_status.width = dw_1.width
end event

type dw_5 from w_main_root`dw_5 within w_smt_recycle_check_rpt
integer y = 640
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_smt_recycle_check_rpt
integer y = 640
integer taborder = 0
boolean titlebar = true
end type

type dw_3 from w_main_root`dw_3 within w_smt_recycle_check_rpt
integer y = 640
integer taborder = 0
boolean titlebar = true
boolean controlmenu = true
boolean minbox = true
end type

type dw_2 from w_main_root`dw_2 within w_smt_recycle_check_rpt
integer y = 640
integer taborder = 0
boolean titlebar = true
string title = "Item"
boolean controlmenu = true
boolean minbox = true
end type

type dw_1 from w_main_root`dw_1 within w_smt_recycle_check_rpt
integer y = 640
integer width = 4640
integer height = 1356
integer taborder = 0
boolean titlebar = true
string dataobject = "d_smt_recycle_check_rpt"
boolean controlmenu = true
boolean minbox = true
end type

event dw_1::itemchanged;// OVER
end event

type uo_tabpages from w_main_root`uo_tabpages within w_smt_recycle_check_rpt
integer taborder = 0
end type

type sle_our_barcode from so_singlelineedit within w_smt_recycle_check_rpt
integer x = 1115
integer y = 216
integer width = 1189
integer taborder = 1
boolean bringtotop = true
textcase textcase = upper!
end type

event modified;call super::modified; INT LVI_COUNT  , LVI_CHECK
 STRING LVS_STATUS  , LVS_MESSAGE , LVS_LOCATION_CODE , LVS_LOT_NAME , LVS_LINE_CODE , lvs_our_barcode , LVS_LINE_CODE_COND, lvs_reel_destroy_yn
 DATE  LVDT_CHECK_DATE 
 
 lvs_our_barcode = upper(sle_our_barcode.text)

 if LEN( THIS.TEXT) < 15 THEN 
	st_status.text = f_msg("$$HEX12$$6fb8b8d2200014bc54cfdcb400ac200044c5d9b2c8b2e4b2$$ENDHEX$$",'S')
	sle_our_barcode.setfocus()
	sle_our_barcode.selecttext( 1,100)
	st_status.backcolor = 255
	return 
end if 

//LVS_LINE_CODE_COND = ddlb_line_code.getcode()
//IF LVS_LINE_CODE_COND = '' OR ISNULL(LVS_LINE_CODE_COND) OR LVS_LINE_CODE_COND = '%' THEN 
//	MESSA GEBOX("$$HEX2$$55d678c7$$ENDHEX$$" , "$$HEX13$$7cb778c744c720003cba00c8200020c1ddd0200058d538c194c6$$ENDHEX$$")
//	DDLB_LINE_CODE.SETFOCUS()
//	RETURN 
//END IF 

LVI_CHECK = 0 ;
//=========================================
//
//=========================================
SELECT COUNT(*) 
    INTO :LVI_CHECK
   FROM ib_recycle_checkhist
 WHERE scan_partname = :lvs_our_barcode
  //   and line_code = :LVS_LINE_CODE_COND
     and check_status = 'P'  ;
 
 IF F_SQL_CHECK() < 0 THEN 
	RETURN 
	sle_our_barcode.selecttext( 1,100)
	sle_our_barcode.setfocus()
END IF  
 
IF  LVI_CHECK > 0 THEN 
	ST_STATUS.text =f_msg( "$$HEX10$$74c7f8bb200080acacc0200088d5b5c2c8b2e4b2$$ENDHEX$$",'S')
	sle_our_barcode.selecttext( 1,100)
	sle_our_barcode.setfocus()
	F_PLAY_SOUND('call1.wav')
	return 
END IF 

//====================================================================
// $$HEX12$$90c7acc7c1c0dcd044c7200070c88cd620005cd5e4b22000$$ENDHEX$$
//====================================================================
         
   SELECT COUNT(*), MAX(NVL(REEL_DESTROY_YN,'N'))
       INTO :LVI_COUNT, :lvs_reel_destroy_yn
      FROM IM_ITEM_RECEIPT_BARCODE
    WHERE ITEM_BARCODE =  :lvs_our_barcode;
		
IF F_SQL_CHECK() < 0 THEN 
	RETURN 
	sle_our_barcode.selecttext( 1,100)
	sle_our_barcode.setfocus()
END IF  
 
IF  LVI_COUNT = 0 THEN 
	ST_STATUS.text =f_msg( 'NG : $$HEX14$$14bc54cfdcb47cb920003ecc44c7200018c22000c6c5b5c2c8b2e4b2$$ENDHEX$$', 'S')
	sle_our_barcode.selecttext( 1,100)
	sle_our_barcode.setfocus()
	F_PLAY_SOUND('call1.wav')
	return 
END IF	

IF  lvs_reel_destroy_yn = 'Y' THEN 
	ST_STATUS.text =f_msg( 'NG : $$HEX14$$74c7f8bb200085c8ccb81cb4200014bc54cfdcb4200085c7c8b2e4b2$$ENDHEX$$', 'S')
	sle_our_barcode.selecttext( 1,100)
	sle_our_barcode.setfocus()
	F_PLAY_SOUND('call1.wav')
	return 
END IF	

//====================================================================
// $$HEX14$$a0bc74c7b9d0200085c7e0ac44c7200070c88cd620005cd5e4b22000$$ENDHEX$$
//====================================================================
         
SELECT COUNT(*), 
             MAX(DECODE(CHAMBER_TYPE, 'B', '$$HEX3$$a0bc74c7b9d0$$ENDHEX$$', 'D', '$$HEX3$$1cc8b5c268d5$$ENDHEX$$', 'V', '$$HEX4$$c4c9f5acecd3a5c7$$ENDHEX$$', CHAMBER_TYPE) || ' $$HEX6$$acc7e0ac200085c7c8b2e4b2$$ENDHEX$$')
	INTO :LVI_COUNT, :LVS_MESSAGE
   FROM IM_ITEM_BAKING_MASTER
 WHERE ITEM_BARCODE     =  :lvs_our_barcode
      AND INPUT_SCAN_DATE  IS NOT NULL
      AND OUTPUT_SCAN_DATE IS NULL;
		
IF F_SQL_CHECK() < 0 THEN 
	RETURN 
	sle_our_barcode.selecttext( 1,100)
	sle_our_barcode.setfocus()
END IF  
 
IF  LVI_COUNT > 0 THEN 
	ST_STATUS.text =f_msg( 'NG : ' + LVS_MESSAGE, 'S')
	sle_our_barcode.selecttext( 1,100)
	sle_our_barcode.setfocus()
	F_PLAY_SOUND('call1.wav')
	return 
END IF	

//====================================================================
// $$HEX14$$b4b950ad58d6200074c725b844c7200070c88cd620005cd5e4b22000$$ENDHEX$$
//====================================================================

LVI_CHECK = 0 ;

SELECT 1  ,   CHECK_DATE ,  LOCATION_CODE  , NVL(LINE_CODE, '*') , LOT_NAME 
    INTO :LVI_COUNT  , :LVDT_CHECK_DATE , :LVS_LOCATION_CODE , :LVS_LINE_CODE , :LVS_LOT_NAME
  FROM IB_SMT_CHECKHIST 
 WHERE ( SCAN_PARTNAME = :lvs_our_barcode OR old_barcode = :lvs_our_barcode )
     AND CHECK_STATUS = 'P' 
	AND CHECK_TYPE      = '2' //REEL CHANGE
//	AND LINE_CODE = :LVS_LINE_CODE_COND
     AND ROWNUM = 1 ;
 
 IF F_SQL_CHECK() < 0 THEN 
	sle_our_barcode.setfocus()
	sle_our_barcode.selecttext( 1,100)
	st_status.backcolor = 255
	RETURN 
END IF  

IF TRIM(LVS_LINE_CODE) = '' OR ISNULL(LVS_LINE_CODE) THEN
	LVS_LINE_CODE = '*'
END IF

ddlb_line_code.text = LVS_LINE_CODE

IF LVI_COUNT > 0  THEN 
	LVS_STATUS = 'P' 
	LVS_MESSAGE = f_msg('OK : REEL $$HEX13$$50adb4cc200074c725b874c7200074c8acc7200069d5c8b2e4b2$$ENDHEX$$','S')
	ST_STATUS.TEXT = 'OK'
	EM_OK.TEXT  = STRING(LONG(EM_OK.TEXT )+ 1)
	
ELSE
	
			//====================================================================
			// $$HEX13$$2cd285c7200074c725b844c7200070c88cd620005cd5e4b22000$$ENDHEX$$
			//====================================================================
			LVI_CHECK = 0 ;
			SELECT 1  ,   CHECK_DATE ,  LOCATION_CODE  , LINE_CODE , LOT_NAME 
				 INTO :LVI_COUNT  , :LVDT_CHECK_DATE , :LVS_LOCATION_CODE , :LVS_LINE_CODE , :LVS_LOT_NAME
			  FROM IB_SMT_CHECKHIST 
			 WHERE ( SCAN_PARTNAME = :lvs_our_barcode OR old_barcode = :lvs_our_barcode )
				AND CHECK_STATUS = 'P' 
				AND CHECK_TYPE     = '1'  //CCS
		//		AND LINE_CODE = :LVS_LINE_CODE_COND
				AND ROWNUM = 1 ;
			 
			 IF F_SQL_CHECK() < 0 THEN 
				sle_our_barcode.setfocus()
				sle_our_barcode.selecttext( 1,100)
				st_status.backcolor = 255
				RETURN 
			END IF  	
			
			IF LVI_COUNT > 0  THEN 
				LVS_STATUS = 'P' 
				LVS_MESSAGE = f_msg('OK : CCS$$HEX13$$a5c729cc200074c725b874c7200074c8acc7200069d5c8b2e4b2$$ENDHEX$$','S')
				ST_STATUS.TEXT = 'OK'
				st_status.backcolor = 255
				EM_OK.TEXT  = STRING(LONG(EM_OK.TEXT )+ 1)
			ELSE
				LVS_STATUS ='E'  
				LVS_MESSAGE = f_msg('NG : CCS$$HEX6$$a5c729cc200010b694b22000$$ENDHEX$$REEL$$HEX11$$50adb4cc200074c725b874c72000c6c5b5c2c8b2e4b2$$ENDHEX$$.','S')
				ST_STATUS.TEXT = 'NG'
				st_status.backcolor = 255
				EM_NG.TEXT  = STRING(LONG(EM_NG.TEXT )+ 1)
				F_PLAY_SOUND('call1.wav')
			END IF 
END IF 


		F_INSERT()
		
		dw_1.object.check_date[lvl_row]        = f_sysdate()
		dw_1.object.check_sequence[lvl_row] =  f_get_sequence( 'SEQ_RECYCLE_CHECK_SEQ')
		dw_1.object.check_status[lvl_row]      = LVS_STATUS
		dw_1.object.check_msg[lvl_row]        = LVS_MESSAGE
		dw_1.object.check_by[lvl_row]           = GVS_USER_ID
		dw_1.object.scan_partname[lvl_row]  = this.text
		
		dw_1.object.enter_date[lvl_row]        = f_sysdate()
		dw_1.object.organization_id[lvl_row]  = gvi_organization_id
		
		dw_1.object.line_code[lvl_row]       = LVS_LINE_CODE
		dw_1.object.model_name[lvl_row]  = LVS_LOT_NAME
		dw_1.object.location_code[lvl_row]  =LVS_LOCATION_CODE
		dw_1.object.feeding_date[lvl_row]  = lvdt_CHECK_DATE
		
//==========================================
//
//==========================================

if dw_1.update() < 0 then 
	rollback;
else
	commit ;
	
		// 20161130 SHS, $$HEX9$$b4b92000acc0a9c644c6ccb8200098ccacb9$$ENDHEX$$
	
    select nvl(reel_destroy_yn,'N')
	   into :lvs_reel_destroy_yn
	 from im_item_receipt_barcode
    where item_barcode = :lvs_our_barcode;
	
	if (sqlca.sqlcode >= 0 and sqlca.sqlcode <> 100 and  lvs_reel_destroy_yn = 'N' )  then
	
	   UPDATE im_item_receipt_barcode
             SET reel_destroy_yn  = 'Y',
				  reel_destroy_date = sysdate,
                    msl_passed_time = nvl(msl_passed_time,0) + ((sysdate - nvl(MSL_OPEN_DATE,sysdate)) * 24),   // feeding_date
                    last_modify_date = sysdate,
				  MSL_OPEN_DATE = NULL			  
        WHERE item_barcode =:lvs_our_barcode;
		 
	   commit;	 
	
     end if
	  
end if 

ddlb_line_code.text = ''
sle_our_barcode.text = ''
sle_our_barcode.setfocus()
st_status.backcolor = rgb(0,0,255)

end event

type st_1 from statictext within w_smt_recycle_check_rpt
integer x = 1115
integer y = 140
integer width = 1189
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Our Barcode"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_status from so_statictext within w_smt_recycle_check_rpt
integer y = 384
integer width = 4123
integer height = 244
boolean bringtotop = true
integer textsize = -36
long textcolor = 65535
long backcolor = 16711680
string text = "WAIT"
end type

type em_ok from so_editmask within w_smt_recycle_check_rpt
integer x = 3145
integer y = 112
integer width = 626
integer height = 248
integer taborder = 20
boolean bringtotop = true
integer textsize = -36
string text = "0"
string mask = "##,##0"
end type

type em_ng from so_editmask within w_smt_recycle_check_rpt
integer x = 3803
integer y = 108
integer width = 626
integer height = 248
integer taborder = 30
boolean bringtotop = true
integer textsize = -36
string text = "0"
string mask = "##,##0"
end type

type st_2 from so_statictext within w_smt_recycle_check_rpt
integer x = 3145
integer y = 16
integer width = 626
boolean bringtotop = true
integer textsize = -12
long textcolor = 65535
long backcolor = 16711680
string text = "OK"
end type

type st_3 from so_statictext within w_smt_recycle_check_rpt
integer x = 3803
integer y = 16
integer width = 626
boolean bringtotop = true
integer textsize = -12
long backcolor = 255
string text = "NG"
end type

type ddlb_line_code from uo_line_code within w_smt_recycle_check_rpt
integer x = 2318
integer y = 212
integer height = 1412
integer taborder = 11
boolean bringtotop = true
boolean allowedit = true
end type

event selectionchanged;call super::selectionchanged;sle_our_barcode.SETFOCUS()
end event

type st_4 from statictext within w_smt_recycle_check_rpt
integer x = 2322
integer y = 132
integer width = 631
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Line Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_dateset from so_editmask within w_smt_recycle_check_rpt
integer x = 206
integer y = 168
integer width = 791
integer taborder = 30
boolean bringtotop = true
string text = ""
alignment alignment = left!
maskdatatype maskdatatype = datetimemask!
string mask = "yyyy/mm/dd hh:mm:ss"
boolean dropdowncalendar = true
end type

event constructor;call super::constructor;this.text =string( f_sysdate())
end event

type em_dateend from so_editmask within w_smt_recycle_check_rpt
integer x = 206
integer y = 248
integer width = 791
integer taborder = 40
boolean bringtotop = true
string text = ""
alignment alignment = left!
maskdatatype maskdatatype = datetimemask!
string mask = "yyyy/mm/dd hh:mm:ss"
boolean dropdowncalendar = true
end type

event constructor;call super::constructor;this.text =string( f_sysdate())
end event

type st_5 from statictext within w_smt_recycle_check_rpt
integer x = 206
integer y = 88
integer width = 791
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Check Date"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_6 from statictext within w_smt_recycle_check_rpt
integer x = 41
integer y = 248
integer width = 151
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "to"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_7 from statictext within w_smt_recycle_check_rpt
integer x = 41
integer y = 180
integer width = 151
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "from"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_2 from so_groupbox within w_smt_recycle_check_rpt
integer width = 1019
integer height = 364
string text = "Barcode Scan"
end type

type gb_1 from so_groupbox within w_smt_recycle_check_rpt
integer x = 1038
integer width = 2057
integer height = 364
integer taborder = 10
string text = "Barcode Scan"
end type

