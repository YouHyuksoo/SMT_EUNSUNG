HA$PBExportHeader$w_pln_product_magazine_label_split_master.srw
$PBExportComments$$$HEX17$$b9c278c7d0c658c7a8ba78b3d0c5200000b35cd52000b9d231c144c7200000adacb9$$ENDHEX$$
forward
global type w_pln_product_magazine_label_split_master from w_main_root
end type
type ddlb_model_name from uo_model_name_ddlb within w_pln_product_magazine_label_split_master
end type
type st_3 from so_statictext within w_pln_product_magazine_label_split_master
end type
type st_7 from so_statictext within w_pln_product_magazine_label_split_master
end type
type st_status from so_statictext within w_pln_product_magazine_label_split_master
end type
type ddlb_result_workstage_code from uo_workstage_code_all within w_pln_product_magazine_label_split_master
end type
type sle_user_id from so_singlelineedit within w_pln_product_magazine_label_split_master
end type
type st_user_id from so_statictext within w_pln_product_magazine_label_split_master
end type
type sle_user_name from so_singlelineedit within w_pln_product_magazine_label_split_master
end type
type ddlb_result_line_code from uo_line_code_smt_dd within w_pln_product_magazine_label_split_master
end type
type st_14 from so_statictext within w_pln_product_magazine_label_split_master
end type
type sle_magazine_no_split from so_singlelineedit within w_pln_product_magazine_label_split_master
end type
type cbx_auto_print from so_checkbox within w_pln_product_magazine_label_split_master
end type
type cb_split from so_commandbutton within w_pln_product_magazine_label_split_master
end type
type ddlb_pcb_item from uo_basecode within w_pln_product_magazine_label_split_master
end type
type st_4 from so_statictext within w_pln_product_magazine_label_split_master
end type
type em_lot_qty from so_editmask within w_pln_product_magazine_label_split_master
end type
type st_5 from so_statictext within w_pln_product_magazine_label_split_master
end type
type st_9 from so_statictext within w_pln_product_magazine_label_split_master
end type
type em_lot_divide_qty from so_editmask within w_pln_product_magazine_label_split_master
end type
type em_ng_qty from so_editmask within w_pln_product_magazine_label_split_master
end type
type em_destroy_qty from so_editmask within w_pln_product_magazine_label_split_master
end type
type st_6 from so_statictext within w_pln_product_magazine_label_split_master
end type
type st_12 from so_statictext within w_pln_product_magazine_label_split_master
end type
type st_1 from so_statictext within w_pln_product_magazine_label_split_master
end type
type gb_2 from so_groupbox within w_pln_product_magazine_label_split_master
end type
type gb_3 from so_groupbox within w_pln_product_magazine_label_split_master
end type
end forward

global type w_pln_product_magazine_label_split_master from w_main_root
integer width = 5417
integer height = 3332
string title = "Magazine Label Split Master"
string icon = "Form!"
string ivs_dw_2_selected_row_yn = "Y"
ddlb_model_name ddlb_model_name
st_3 st_3
st_7 st_7
st_status st_status
ddlb_result_workstage_code ddlb_result_workstage_code
sle_user_id sle_user_id
st_user_id st_user_id
sle_user_name sle_user_name
ddlb_result_line_code ddlb_result_line_code
st_14 st_14
sle_magazine_no_split sle_magazine_no_split
cbx_auto_print cbx_auto_print
cb_split cb_split
ddlb_pcb_item ddlb_pcb_item
st_4 st_4
em_lot_qty em_lot_qty
st_5 st_5
st_9 st_9
em_lot_divide_qty em_lot_divide_qty
em_ng_qty em_ng_qty
em_destroy_qty em_destroy_qty
st_6 st_6
st_12 st_12
st_1 st_1
gb_2 gb_2
gb_3 gb_3
end type
global w_pln_product_magazine_label_split_master w_pln_product_magazine_label_split_master

type variables
string IVS_LINE_CODE, IVS_WORKSTAGE_CODE , IVS_RUN_NO , IVS_ITEM_CODE , IVS_PCB_ITEM ,IVS_MODEL_NAME , IVS_MODEL_SUFFIX
string IVS_MAGAZINE_LABEL_NO , IVS_MAGAZINE_SET_NO 
end variables

on w_pln_product_magazine_label_split_master.create
int iCurrent
call super::create
this.ddlb_model_name=create ddlb_model_name
this.st_3=create st_3
this.st_7=create st_7
this.st_status=create st_status
this.ddlb_result_workstage_code=create ddlb_result_workstage_code
this.sle_user_id=create sle_user_id
this.st_user_id=create st_user_id
this.sle_user_name=create sle_user_name
this.ddlb_result_line_code=create ddlb_result_line_code
this.st_14=create st_14
this.sle_magazine_no_split=create sle_magazine_no_split
this.cbx_auto_print=create cbx_auto_print
this.cb_split=create cb_split
this.ddlb_pcb_item=create ddlb_pcb_item
this.st_4=create st_4
this.em_lot_qty=create em_lot_qty
this.st_5=create st_5
this.st_9=create st_9
this.em_lot_divide_qty=create em_lot_divide_qty
this.em_ng_qty=create em_ng_qty
this.em_destroy_qty=create em_destroy_qty
this.st_6=create st_6
this.st_12=create st_12
this.st_1=create st_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_model_name
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_7
this.Control[iCurrent+4]=this.st_status
this.Control[iCurrent+5]=this.ddlb_result_workstage_code
this.Control[iCurrent+6]=this.sle_user_id
this.Control[iCurrent+7]=this.st_user_id
this.Control[iCurrent+8]=this.sle_user_name
this.Control[iCurrent+9]=this.ddlb_result_line_code
this.Control[iCurrent+10]=this.st_14
this.Control[iCurrent+11]=this.sle_magazine_no_split
this.Control[iCurrent+12]=this.cbx_auto_print
this.Control[iCurrent+13]=this.cb_split
this.Control[iCurrent+14]=this.ddlb_pcb_item
this.Control[iCurrent+15]=this.st_4
this.Control[iCurrent+16]=this.em_lot_qty
this.Control[iCurrent+17]=this.st_5
this.Control[iCurrent+18]=this.st_9
this.Control[iCurrent+19]=this.em_lot_divide_qty
this.Control[iCurrent+20]=this.em_ng_qty
this.Control[iCurrent+21]=this.em_destroy_qty
this.Control[iCurrent+22]=this.st_6
this.Control[iCurrent+23]=this.st_12
this.Control[iCurrent+24]=this.st_1
this.Control[iCurrent+25]=this.gb_2
this.Control[iCurrent+26]=this.gb_3
end on

on w_pln_product_magazine_label_split_master.destroy
call super::destroy
destroy(this.ddlb_model_name)
destroy(this.st_3)
destroy(this.st_7)
destroy(this.st_status)
destroy(this.ddlb_result_workstage_code)
destroy(this.sle_user_id)
destroy(this.st_user_id)
destroy(this.sle_user_name)
destroy(this.ddlb_result_line_code)
destroy(this.st_14)
destroy(this.sle_magazine_no_split)
destroy(this.cbx_auto_print)
destroy(this.cb_split)
destroy(this.ddlb_pcb_item)
destroy(this.st_4)
destroy(this.em_lot_qty)
destroy(this.st_5)
destroy(this.st_9)
destroy(this.em_lot_divide_qty)
destroy(this.em_ng_qty)
destroy(this.em_destroy_qty)
destroy(this.st_6)
destroy(this.st_12)
destroy(this.st_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event activate;call super::activate;/***************************************
* Window Default Property 
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20051101'
Gst_set.last_modify_date = '20051101'
Gst_set.Report_window    = False  // Report Window  True / Flase

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
*  Menu Property
*****************************************
* ADMIN  ( All Control )
* MANAGE ( Manager )
* GUEST  ( Only Query )
* QUERY  ( Only Query  )
* DATA_CONTROL  ( Insert Delete Update )
* REPORT ( Report )
****************************************/
F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control




end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
st_status.width = THIS.width

F_SET_COLUMN_DDDW(DW_3)
F_SET_COLUMN_DDDW(DW_4)

end event

event ue_data_control;call super::ue_data_control;CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'

	CASE ELSE
END CHOOSE


end event

event resize;call super::resize;st_status.width = THIS.width

end event

type dw_5 from w_main_root`dw_5 within w_pln_product_magazine_label_split_master
integer x = 1422
integer y = 128
integer width = 3191
integer height = 1164
integer taborder = 0
boolean titlebar = true
end type

type dw_4 from w_main_root`dw_4 within w_pln_product_magazine_label_split_master
integer x = 1422
integer y = 128
integer width = 3191
integer height = 1164
integer taborder = 0
boolean titlebar = true
string dataobject = "d_pln_product_magazine_ng_label_rpt"
end type

type dw_3 from w_main_root`dw_3 within w_pln_product_magazine_label_split_master
integer x = 1422
integer y = 128
integer width = 3191
integer height = 1164
integer taborder = 0
boolean titlebar = true
string dataobject = "d_pln_product_magazine_label_rpt"
end type

type dw_2 from w_main_root`dw_2 within w_pln_product_magazine_label_split_master
integer x = 1422
integer y = 128
integer width = 3191
integer height = 1164
integer taborder = 0
boolean titlebar = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_2::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
if this.object.magazine_label_type[currentrow] = 'B' then 
	dw_4.retrieve( THIS.OBJECT.MAGAZINE_LABEL_NO[CURRENTROW] , f_get_dual_lang_text(GVS_LANGUAGE , "REPRINT" ) , GVI_ORGANIZATION_ID  ) 
else
	dw_3.retrieve( THIS.OBJECT.MAGAZINE_LABEL_NO[CURRENTROW] , f_get_dual_lang_text(GVS_LANGUAGE , "REPRINT" ) , GVI_ORGANIZATION_ID  ) 
end if 

end event

type dw_1 from w_main_root`dw_1 within w_pln_product_magazine_label_split_master
integer x = 1422
integer y = 128
integer width = 3191
integer height = 1164
integer taborder = 0
boolean titlebar = true
string title = "Magazine List"
string dataobject = "d_pln_product_run_card_io_by_run_no_lst"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type uo_tabpages from w_main_root`uo_tabpages within w_pln_product_magazine_label_split_master
integer taborder = 0
end type

type ddlb_model_name from uo_model_name_ddlb within w_pln_product_magazine_label_split_master
integer x = 567
integer y = 780
integer width = 768
integer height = 1748
integer taborder = 50
boolean bringtotop = true
end type

type st_3 from so_statictext within w_pln_product_magazine_label_split_master
integer x = 50
integer y = 784
integer width = 507
integer height = 76
boolean bringtotop = true
long textcolor = 0
string text = "Master Model Name"
alignment alignment = right!
end type

type st_7 from so_statictext within w_pln_product_magazine_label_split_master
integer x = 91
integer y = 344
integer width = 407
integer height = 76
boolean bringtotop = true
long textcolor = 134217729
string text = "Line Code"
alignment alignment = right!
end type

type st_status from so_statictext within w_pln_product_magazine_label_split_master
integer width = 4887
integer height = 104
boolean bringtotop = true
integer textsize = -14
integer weight = 700
long textcolor = 65535
long backcolor = 134217741
string text = "Message"
end type

type ddlb_result_workstage_code from uo_workstage_code_all within w_pln_product_magazine_label_split_master
integer x = 567
integer y = 428
integer width = 768
integer height = 1816
integer taborder = 40
boolean bringtotop = true
boolean allowedit = true
end type

event constructor;call super::constructor;
IVS_WORKSTAGE_CODE = Profilestring("WORKENV.INI","WORKSTAGE","WORKSTAGE_MAGAZINE","")
THIS.SELECtitem(IVS_WORKSTAGE_CODE )

end event

event selectionchanged;call super::selectionchanged;f_jsSetProfileString ("WORKENV.INI", "WORKSTAGE", "WORKSTAGE_MAGAZINE", THIS.GETCODE() )
IVS_WORkstage_code = THIS.GETCODE()

end event

type sle_user_id from so_singlelineedit within w_pln_product_magazine_label_split_master
integer x = 571
integer y = 228
integer width = 443
integer height = 92
integer taborder = 10
boolean bringtotop = true
textcase textcase = upper!
end type

event modified;call super::modified;STRING LVS_USER_NAME , LVS_USER_ID 
INT LVI_POS 

LVI_POS = POS( THIS.TEXT  , '@' , 1 ) 
IF LVI_POS <= 0 THEN 
	LVI_POS = 100
END IF 

LVS_USER_ID  = MID( THIS.TEXT , 1 ,  LVI_POS -1 )

SELECT USER_NAME INTO :LVS_USER_NAME 
 FROM ISYS_USERS 
 WHERE USER_ID = :LVS_USER_ID
   AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID  ;


sle_user_name.text = LVS_USER_NAME

sle_magazine_no_split.setfocus( )
end event

event getfocus;call super::getfocus;this.selecttext( 1, 100)
end event

type st_user_id from so_statictext within w_pln_product_magazine_label_split_master
integer x = 96
integer y = 232
integer width = 407
integer height = 76
boolean bringtotop = true
string text = "User ID"
alignment alignment = right!
end type

type sle_user_name from so_singlelineedit within w_pln_product_magazine_label_split_master
integer x = 1024
integer y = 228
integer width = 315
integer height = 92
integer taborder = 30
boolean bringtotop = true
boolean displayonly = true
end type

type ddlb_result_line_code from uo_line_code_smt_dd within w_pln_product_magazine_label_split_master
integer x = 567
integer y = 328
integer width = 768
integer height = 1448
integer taborder = 40
boolean bringtotop = true
boolean allowedit = true
integer limit = 30
end type

event constructor;call super::constructor;IVS_LINE_CODE = Profilestring("WORKENV.INI","LINE","WORKSTAGE_MAGAZINE","")
THIS.SELECtitem(IVS_LINE_CODE )


end event

event selectionchanged;call super::selectionchanged;f_jsSetProfileString ("WORKENV.INI", "LINE", "WORKSTAGE_MAGAZINE", THIS.GETCODE() )

IVS_LINE_CODE = THIS.GETCODE()
end event

type st_14 from so_statictext within w_pln_product_magazine_label_split_master
integer x = 50
integer y = 692
integer width = 507
boolean bringtotop = true
long textcolor = 255
string text = "Magazine Label Scan"
alignment alignment = right!
end type

type sle_magazine_no_split from so_singlelineedit within w_pln_product_magazine_label_split_master
integer x = 567
integer y = 676
integer width = 768
integer height = 92
integer taborder = 120
boolean bringtotop = true
end type

event getfocus;call super::getfocus;this.selecttext( 1, 100)
end event

event modified;call super::modified;if  f_check_run_no( this.text ) < 0 then 
	f_msgbox(174)
	return 
end if 

//======================================
//
//======================================
LONG LVL_LOT_SIZE , I
IVS_ITEM_CODE = '' 
IVS_PCB_ITEM  = ''
IVS_MODEL_NAME = ''
IVS_MODEL_SUFFIX = ''

IVS_MAGAZINE_LABEL_NO = THIS.TEXT 

SELECT  line_code , model_name  , lot_qty  , pcb_item , model_suffix , run_no
   INTO  :IVS_LINE_CODE  , :IVS_MODEL_NAME , :LVL_LOT_SIZE , :IVS_PCB_ITEM  , :IVS_MODEL_SUFFIX , :IVS_RUN_NO
  FROM IP_PRODUCT_RUN_CARD_IO
 WHERE MAGAZINE_LABEL_NO =  :IVS_MAGAZINE_LABEL_NO
     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
 
 IF F_SQL_CHECK() < 0 THEN 
	RETURN 
END IF 


dw_1.reset()
dw_1.RETRIEVE( IVS_RUN_NO ,  GVI_ORGANIZATION_ID )

//======================================
//
//======================================
ddlb_result_line_code.text = IVS_LINE_CODE
ddlb_model_name.text      = IVS_MODEL_NAME
ddlb_pcb_item.text = IVS_PCB_ITEM
em_lot_qty.text =string(LVL_LOT_SIZE)
em_lot_divide_qty.setfocus()

end event

type cbx_auto_print from so_checkbox within w_pln_product_magazine_label_split_master
integer x = 576
integer y = 1340
integer width = 416
boolean bringtotop = true
string text = "Auto Print"
boolean checked = true
end type

type cb_split from so_commandbutton within w_pln_product_magazine_label_split_master
integer x = 178
integer y = 1464
integer width = 1143
integer height = 212
integer taborder = 60
boolean bringtotop = true
boolean italic = true
string text = "Lot Split"
end type

event clicked;call super::clicked;STRING LVS_MAGAZINE_LABEL_NO ,LVS_MAGAZINE_LABEL_NO1 , LVS_MAGAZINE_LABEL_NO2 , LVS_MAGAZINE_LABEL_NO3 , LVS_MAGAZINE_LABEL_NO4
string LVS_USER_ID , LVS_MAGAZINE_LABEL_TYPE
LONG LVI_COUNT , LVL_LOT_QTY , LVL_LOT_DIVIDE_QTY , LVL_NG_QTY , LVL_DESTROY_QTY

if sle_magazine_no_split.text = '' then  
	f_msg( "$$HEX14$$84bd60d5200060d520007cb7a8bc44c72000a4c294ce58d538c194c6$$ENDHEX$$","P")
	return 
end if 

LVL_LOT_QTY =  LONG(EM_LOT_QTY.TEXT)
LVL_LOT_DIVIDE_QTY   =  LONG(EM_LOT_DIVIDE_QTY.TEXT)
LVL_NG_QTY   =  LONG(EM_NG_QTY.TEXT)
LVL_DESTROY_QTY   =  LONG(EM_DESTROY_QTY.TEXT)


if ( em_lot_divide_qty.text = '' or long(em_lot_divide_qty.text) = 0 )  then 
	/*$$HEX18$$04c8c9b72000d0d330ae200004c8c9b7200088bdc9b720007cc72000bdacb0c694b22000$$ENDHEX$$? */
	if ( lvl_lot_divide_qty + lvl_ng_qty + LVL_DESTROY_QTY ) <> LVL_LOT_QTY then  
		f_msg( "$$HEX15$$84bd60d5200060d5200018c2c9b744c7200055d678c7200058d538c194c6$$ENDHEX$$","P")
		return 
	end if
end if 

msg = f_msgbox1(1161 ,  this.text ) 

if msg = 1 then  
else
	return 
end if 
//====================================================
//
//====================================================
IVS_LINE_CODE =  ddlb_result_line_code.GETCODE() 
IVS_WORKSTAGE_CODE =ddlb_result_workstage_code.getcode()
IVS_PCB_ITEM         = ddlb_pcb_item.getcode()
IVS_MODEL_SUFFIX = ddlb_model_name.getcode()
//LVS_USER_ID =  MID( SLE_USER_ID.TEXT , 1,  POS ( SLE_USER_ID.TEXT , '@' , 1) -1 )
LVS_USER_ID =  sle_user_id.text 
LVS_MAGAZINE_LABEL_NO = sle_magazine_no_split.text  
IVS_ITEM_CODE       = ''

LVL_LOT_QTY =  LONG(EM_LOT_QTY.TEXT)
LVL_LOT_DIVIDE_QTY   =  LONG(EM_LOT_DIVIDE_QTY.TEXT)
LVL_NG_QTY   =  LONG(EM_NG_QTY.TEXT)
LVL_DESTROY_QTY   =  LONG(EM_DESTROY_QTY.TEXT)

//============================================
//
//============================================
IF ISNULL(LVL_LOT_QTY) THEN 
	LVL_LOT_QTY = 0 
END IF 

IF ISNULL(LVL_NG_QTY)  THEN 
	LVL_NG_QTY = 0 
END IF 

IF ISNULL(LVL_DESTROY_QTY) THEN 
	LVL_DESTROY_QTY = 0 
END IF 



IF LVL_LOT_QTY < LVL_LOT_DIVIDE_QTY + LVL_NG_QTY +LVL_DESTROY_QTY THEN 
	F_MSG("$$HEX13$$85c725b818c2c9b774c7200098c7bbba18b4c8c5b5c2c8b2e4b2$$ENDHEX$$" , 'P' )
	RETURN 
	
END IF 
//====================================================
//
//====================================================

IF LVS_MAGAZINE_LABEL_NO = ''  or LVS_MAGAZINE_LABEL_NO = '%' or isnull(LVS_MAGAZINE_LABEL_NO) THEN 
	f_msgbox1(102  ,f_get_dual_lang_text ( gvs_language , 'MAGAZINE LABEL NO'))
	RETURN 
END IF 

IF IVS_LINE_CODE = ''  or IVS_LINE_CODE = '%' or isnull(IVS_LINE_CODE) THEN 
	f_msgbox1(102  ,f_get_dual_lang_text ( gvs_language , 'LINE CODE'))
	RETURN 
END IF 

IF IVS_WORKSTAGE_CODE = ''  or IVS_WORKSTAGE_CODE = '%' or isnull(IVS_WORKSTAGE_CODE) THEN 
	f_msgbox1(102  ,f_get_dual_lang_text ( gvs_language , 'WORKSTAGE CODE'))
	RETURN 
END IF 
IF IVS_PCB_ITEM = ''  or IVS_PCB_ITEM = '%' or isnull(IVS_PCB_ITEM) THEN 
	f_msgbox1(102  ,f_get_dual_lang_text ( gvs_language , 'PCB ITEM'))
	RETURN 
END IF 

IF IVS_MODEL_NAME = '' OR IVS_MODEL_NAME = '' THEN 
	f_msgbox1(102  ,f_get_dual_lang_text ( gvs_language , 'MODEL NAME'))
	RETURN 
END IF 

//==================================================
//
//==================================================
SELECT 1,  LOT_QTY , ITEM_CODE
    INTO :LVI_COUNT , :LVL_LOT_QTY , :IVS_ITEM_CODE
	FROM IP_PRODUCT_RUN_CARD_IO
 WHERE MAGAZINE_LABEL_NO = :LVS_MAGAZINE_LABEL_NO
	  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID  ;

    IF F_SQL_CHECK() < 0 THEN 
		RETURN 
	END IF 
		
IF LVI_COUNT = 0  THEN 
	st_status.text = f_msg("$$HEX19$$f1b45db81cb42000e4b970acc4c9ccb9200084bd60d5200060d518c2200088c7b5c2c8b2e4b2$$ENDHEX$$. $$HEX19$$e4b970acc4c9200074c7d9b3200074c725b844c720003ecc44c718c22000c6c5b5c2c8b2e4b2$$ENDHEX$$","S")
	RETURN 
END IF 
 
msg = f_msgbox1(1160 , this.text)

if msg = 1 then 
else
	return 
end if 

IVS_MAGAZINE_SET_NO =   IVS_LINE_CODE+F_YMD_SYSDATE()+ STRING(F_GET_SEQUENCE( 'SEQ_MAGAZINE_LABEL_SEQUENCE') , '0000') 
//============================================================
//
//============================================================

		IF LVL_LOT_QTY - ( LVL_LOT_DIVIDE_QTY + LVL_NG_QTY +LVL_DESTROY_QTY  ) > 0  THEN 


				
//			SELECT  F_GET_NEW_MAGAZINE_NO( :IVS_LINE_CODE ,  :IVS_MODEL_NAME ) 	
//				INTO :LVS_MAGAZINE_LABEL_NO1 
//			FROM DUAL ;
//			
//			IF F_SQL_CHECK() < 0 THEN
//				RETURN 
//			END IF 


		LVS_MAGAZINE_LABEL_NO1 =  IVS_LINE_CODE+F_YMD_SYSDATE()+ STRING(F_GET_SEQUENCE( 'SEQ_MAGAZINE_LABEL_SEQUENCE') , '0000') 

		//==========================================		
	    // $$HEX18$$84bd60d52000200015c8c1c0200018c2c9b7200084bd60d5c4d62000d0c618c2c9b72000$$ENDHEX$$
		//==========================================
		INSERT INTO IP_PRODUCT_RUN_CARD_IO  
					( RUN_NO,   
					RECEIPT_DATE,   
					RECEIPT_SEQUENCE ,
					ITEM_CODE,   
					MODEL_NAME,   
					MODEL_SUFFIX,   
					LINE_CODE,   
					WORKSTAGE_CODE,   
					RECEIPT_DEFICIT,   
					LOT_QTY ,
					ORGANIZATION_ID,   
					ENTER_DATE,   
					ENTER_BY,   
					LAST_MODIFY_DATE,   
					LAST_MODIFY_BY,   
					LAST_LINE_CODE,   
					LAST_WORKSTAGE_CODE,   
					MAGAZINE_LABEL_NO,
					PCB_ITEM,
					RECEIPT_STATUS,
					RECEIPT_CONFIRM_YN,
					TRANSACTION_TYPE,
					TRANSACTION_NO,
					MAGAZINE_LABEL_TYPE,
					MAGAZINE_SET_NO,
					MFS_GROUP_NO, 
					ORIGIN_MAGAZINE_LABEL_NO, 
					PARENT_MAGAZINE_LABEL_NO
					)  
				  
		 SELECT RUN_NO,   
					SYSDATE , //RECEIPT_DATE,   
					SEQ_MAGAZINE_RECEIPT_SEQUENCE.NEXTVAL ,
					ITEM_CODE,   
					MODEL_NAME,   
					MODEL_SUFFIX,   
					:IVS_LINE_CODE , //LINE_CODE,   
					:IVS_WORKSTAGE_CODE , //WORKSTAGE_CODE,   
					RECEIPT_DEFICIT,   
					ABS(LOT_QTY) - ( :LVL_LOT_DIVIDE_QTY + :LVL_NG_QTY + :LVL_DESTROY_QTY )  , // $$HEX8$$84bd60d5200060d5200018c2c9b72000$$ENDHEX$$+ $$HEX6$$88bdc9b7200018c2c9b72000$$ENDHEX$$+ $$HEX16$$d0d330ae18c2c9b7200044c720007cbee0ac20007cb7a8bc2000ddc031c12000$$ENDHEX$$
					ORGANIZATION_ID,   
					SYSDATE ENTER_DATE,   
					:GVS_USER_ID ,   
					SYSDATE LAST_MODIFY_DATE,   
					LAST_MODIFY_BY,   
					LAST_LINE_CODE,   
					LAST_WORKSTAGE_CODE,   
					:LVS_MAGAZINE_LABEL_NO1,
					PCB_ITEM ,
					RECEIPT_STATUS,
					RECEIPT_CONFIRM_YN,
					TRANSACTION_TYPE,
					TRANSACTION_NO,
					MAGAZINE_LABEL_TYPE,
					:IVS_MAGAZINE_SET_NO,
					MFS_GROUP_NO, 
					ORIGIN_MAGAZINE_LABEL_NO, 
					MAGAZINE_LABEL_NO
		  FROM IP_PRODUCT_RUN_CARD_IO 
		WHERE MAGAZINE_LABEL_NO = :LVS_MAGAZINE_LABEL_NO 
			  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
			 
				IF F_SQL_CHECK() < 0 THEN 
					RETURN 
				END IF 		

				//========================================================================================
				//
				//========================================================================================
				IF cbx_auto_print.CHECKED = TRUE THEN 
				
							dw_3.retrieve( LVS_MAGAZINE_LABEL_NO1 , f_get_dual_lang_text(GVS_LANGUAGE , "SPLIT" ) , GVI_ORGANIZATION_ID , gvs_language ) 
						
							if dw_3.rowcount( ) < 1 then 
								  st_status.text = f_msg("$$HEX14$$7cb7a8bc20009ccd25b8d0c52000e4c228d3200088d5b5c2c8b2e4b2$$ENDHEX$$","S")
								  dw_1.bringtotop = true 
							else
									dw_3.print( true )
									st_status.text = f_msg("$$HEX11$$15c8c1c0200098ccacb9200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$","S")
							end if 
				END IF 
		END  IF 
		//==========================================		
	    // $$HEX3$$84bd60d52000$$ENDHEX$$2 $$HEX16$$84bd60d5200060d5200018c2c9b774c7200088c73cc774ba2000ddc031c12000$$ENDHEX$$
		//==========================================
		
		IF LVL_LOT_DIVIDE_QTY > 0  THEN 
			
				
//			SELECT  F_GET_NEW_MAGAZINE_NO( :IVS_LINE_CODE ,  :IVS_MODEL_NAME ) 	
//				INTO :LVS_MAGAZINE_LABEL_NO2 
//			FROM DUAL ;
//			
//			IF F_SQL_CHECK() < 0 THEN
//				RETURN 
//			END IF 			
			
			
			 LVS_MAGAZINE_LABEL_NO2 =  IVS_LINE_CODE+F_YMD_SYSDATE()+  STRING(F_GET_SEQUENCE( 'SEQ_MAGAZINE_LABEL_SEQUENCE') , '0000') 
				INSERT INTO IP_PRODUCT_RUN_CARD_IO  
							( RUN_NO,   
							RECEIPT_DATE,   
							RECEIPT_SEQUENCE ,
							ITEM_CODE,   
							MODEL_NAME,   
							MODEL_SUFFIX,   
							LINE_CODE,   
							WORKSTAGE_CODE,   
							RECEIPT_DEFICIT,   
							LOT_QTY ,
							ORGANIZATION_ID,   
							ENTER_DATE,   
							ENTER_BY,   
							LAST_MODIFY_DATE,   
							LAST_MODIFY_BY,   
							LAST_LINE_CODE,   
							LAST_WORKSTAGE_CODE,   
							MAGAZINE_LABEL_NO,
							PCB_ITEM,
							RECEIPT_STATUS,
							RECEIPT_CONFIRM_YN,
							TRANSACTION_TYPE,
							TRANSACTION_NO,
							MAGAZINE_LABEL_TYPE,
							MAGAZINE_SET_NO,
							MFS_GROUP_NO, 
							ORIGIN_MAGAZINE_LABEL_NO, 
							PARENT_MAGAZINE_LABEL_NO
							)  
						  
				 SELECT RUN_NO,   
							SYSDATE , //RECEIPT_DATE,   
							SEQ_MAGAZINE_RECEIPT_SEQUENCE.NEXTVAL ,
							ITEM_CODE,   
							MODEL_NAME,   
							MODEL_SUFFIX,   
							:IVS_LINE_CODE , //LINE_CODE,   
							:IVS_WORKSTAGE_CODE , //WORKSTAGE_CODE,   
							RECEIPT_DEFICIT,   
							:LVL_LOT_DIVIDE_QTY , 
							ORGANIZATION_ID,   
							SYSDATE ENTER_DATE,   
							:GVS_USER_ID ,   
							SYSDATE LAST_MODIFY_DATE,   
							LAST_MODIFY_BY,   
							LAST_LINE_CODE,   
							LAST_WORKSTAGE_CODE,   
							:LVS_MAGAZINE_LABEL_NO2,
							PCB_ITEM ,
							RECEIPT_STATUS,
							RECEIPT_CONFIRM_YN,
							TRANSACTION_TYPE,
							TRANSACTION_NO,
							MAGAZINE_LABEL_TYPE, //$$HEX4$$15c8c1c088d42000$$ENDHEX$$
							:IVS_MAGAZINE_SET_NO,
							MFS_GROUP_NO, 
							ORIGIN_MAGAZINE_LABEL_NO, 
							MAGAZINE_LABEL_NO
				  FROM IP_PRODUCT_RUN_CARD_IO 
				WHERE MAGAZINE_LABEL_NO = :LVS_MAGAZINE_LABEL_NO 
					AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID
					AND ROWNUM = 1;
					 
						IF F_SQL_CHECK() < 0 THEN 
							RETURN 
						END IF 		
	
				//========================================================================================
				//
				//========================================================================================
				IF cbx_auto_print.CHECKED = TRUE THEN 
				
									
										dw_3.retrieve( LVS_MAGAZINE_LABEL_NO2 ,  f_get_dual_lang_text(GVS_LANGUAGE , "SPLIT" ), GVI_ORGANIZATION_ID, gvs_language  ) 
									
										if dw_3.rowcount( ) < 1 then 
											  st_status.text = f_msg("$$HEX14$$7cb7a8bc20009ccd25b8d0c52000e4c228d3200088d5b5c2c8b2e4b2$$ENDHEX$$","S")
											  dw_1.bringtotop = true 
										else
												dw_3.print( true )
												st_status.text = f_msg("$$HEX11$$15c8c1c0200098ccacb9200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$","S")
										end if 
					END IF 
				
				
			END IF // $$HEX12$$88bd60d560d5200018c2c9b774c7200088c73cc774ba2000$$ENDHEX$$
			//=================================================	
			//$$HEX11$$88bdc9b7200018c2c9b774c7200088c73cc774ba2000$$ENDHEX$$
			//=================================================
		     IF LVL_NG_QTY > 0 THEN  
				
//					SELECT  F_GET_NEW_MAGAZINE_NO( :IVS_LINE_CODE ,  :IVS_MODEL_NAME ) 	
//						INTO :LVS_MAGAZINE_LABEL_NO3 
//					FROM DUAL ;
//					
//					IF F_SQL_CHECK() < 0 THEN
//						RETURN 
//					END IF 							
						
				
				     LVS_MAGAZINE_LABEL_NO3 =  IVS_LINE_CODE+F_YMD_SYSDATE()+  STRING(F_GET_SEQUENCE( 'SEQ_MAGAZINE_LABEL_SEQUENCE') , '0000') 
					INSERT INTO IP_PRODUCT_RUN_CARD_IO  
								( RUN_NO,   
								RECEIPT_DATE,   
								RECEIPT_SEQUENCE ,
								ITEM_CODE,   
								MODEL_NAME,   
								MODEL_SUFFIX,   
								LINE_CODE,   
								WORKSTAGE_CODE,   
								RECEIPT_DEFICIT,   
								LOT_QTY ,
								ORGANIZATION_ID,   
								ENTER_DATE,   
								ENTER_BY,   
								LAST_MODIFY_DATE,   
								LAST_MODIFY_BY,   
								LAST_LINE_CODE,   
								LAST_WORKSTAGE_CODE,   
								MAGAZINE_LABEL_NO,
								PCB_ITEM,
								RECEIPT_STATUS,
								RECEIPT_CONFIRM_YN,
								TRANSACTION_TYPE,
								TRANSACTION_NO,
								MAGAZINE_LABEL_TYPE,
								MAGAZINE_SET_NO,
								MFS_GROUP_NO,
								ORIGIN_MAGAZINE_LABEL_NO, 
								PARENT_MAGAZINE_LABEL_NO
								)  
							  
					 SELECT RUN_NO,   
								SYSDATE , //RECEIPT_DATE,   
								SEQ_MAGAZINE_RECEIPT_SEQUENCE.NEXTVAL ,
								ITEM_CODE,   
								MODEL_NAME,   
								MODEL_SUFFIX,   
								:IVS_LINE_CODE , //LINE_CODE,   
								:IVS_WORKSTAGE_CODE , //WORKSTAGE_CODE,   
								RECEIPT_DEFICIT,   
								:LVL_NG_QTY , 
								ORGANIZATION_ID,   
								SYSDATE ENTER_DATE,   
								:GVS_USER_ID ,   
								SYSDATE LAST_MODIFY_DATE,   
								LAST_MODIFY_BY,   
								LAST_LINE_CODE,   
								LAST_WORKSTAGE_CODE,   
								:LVS_MAGAZINE_LABEL_NO3,
								PCB_ITEM ,
								RECEIPT_STATUS,
								RECEIPT_CONFIRM_YN,
								TRANSACTION_TYPE,
								TRANSACTION_NO,
								'B', //$$HEX4$$88bdc9b788d42000$$ENDHEX$$
								:IVS_MAGAZINE_SET_NO,
								MFS_GROUP_NO, 
								ORIGIN_MAGAZINE_LABEL_NO, 
								MAGAZINE_LABEL_NO
					  FROM IP_PRODUCT_RUN_CARD_IO 
					WHERE MAGAZINE_LABEL_NO = :LVS_MAGAZINE_LABEL_NO 
						AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID
						AND ROWNUM = 1;
						 
							IF F_SQL_CHECK() < 0 THEN 
								RETURN 
							END IF 		
				
							//========================================================================================
							//
							//========================================================================================
							IF cbx_auto_print.CHECKED = TRUE THEN 
							
										 dw_4.retrieve( LVS_MAGAZINE_LABEL_NO3 ,  f_get_dual_lang_text(GVS_LANGUAGE , "SPLIT" ), GVI_ORGANIZATION_ID , gvs_language ) 
												
													if dw_4.rowcount( ) < 1 then 
														  st_status.text = f_msg("$$HEX14$$7cb7a8bc20009ccd25b8d0c52000e4c228d3200088d5b5c2c8b2e4b2$$ENDHEX$$","S")
														  dw_1.bringtotop = true 
													else
															dw_4.print( true )
															st_status.text = f_msg("$$HEX11$$15c8c1c0200098ccacb9200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$","S")
													end if 							
													
							END IF 		

			END IF ;  //$$HEX13$$88bdc9b7200018c2c9b7d0c5200000b35cd520007cb7a8bc2000$$ENDHEX$$
			
			//=================================================	
			//$$HEX12$$d0d330ae2000200018c2c9b774c7200088c73cc774ba2000$$ENDHEX$$
			//=================================================
		     IF LVL_DESTROY_QTY > 0 THEN  
				
//				
//					SELECT  F_GET_NEW_MAGAZINE_NO( :IVS_LINE_CODE ,  :IVS_MODEL_NAME ) 	
//						INTO :LVS_MAGAZINE_LABEL_NO4 
//					FROM DUAL ;
//					
//					IF F_SQL_CHECK() < 0 THEN
//						RETURN 
//					END IF 							
										
				
				
				
				
				     LVS_MAGAZINE_LABEL_NO4 =  IVS_LINE_CODE+F_YMD_SYSDATE()+  STRING(F_GET_SEQUENCE( 'SEQ_MAGAZINE_LABEL_SEQUENCE') , '0000') 
					INSERT INTO IP_PRODUCT_RUN_CARD_IO  
								( RUN_NO,   
								RECEIPT_DATE,   
								RECEIPT_SEQUENCE ,
								ITEM_CODE,   
								MODEL_NAME,   
								MODEL_SUFFIX,   
								LINE_CODE,   
								WORKSTAGE_CODE,   
								RECEIPT_DEFICIT,   
								LOT_QTY ,
								ORGANIZATION_ID,   
								ENTER_DATE,   
								ENTER_BY,   
								LAST_MODIFY_DATE,   
								LAST_MODIFY_BY,   
								LAST_LINE_CODE,   
								LAST_WORKSTAGE_CODE,   
								MAGAZINE_LABEL_NO,
								PCB_ITEM,
								RECEIPT_STATUS,
								RECEIPT_CONFIRM_YN,
								TRANSACTION_TYPE,
								TRANSACTION_NO,
								MAGAZINE_LABEL_TYPE,
								MAGAZINE_SET_NO,
								MFS_GROUP_NO,
								ORIGIN_MAGAZINE_LABEL_NO, 
								PARENT_MAGAZINE_LABEL_NO
								)  
							  
					 SELECT RUN_NO,   
								SYSDATE , //RECEIPT_DATE,   
								SEQ_MAGAZINE_RECEIPT_SEQUENCE.NEXTVAL ,
								ITEM_CODE,   
								MODEL_NAME,   
								MODEL_SUFFIX,   
								:IVS_LINE_CODE , //LINE_CODE,   
								:IVS_WORKSTAGE_CODE , //WORKSTAGE_CODE,   
								RECEIPT_DEFICIT,   
								:LVL_DESTROY_QTY , 
								ORGANIZATION_ID,   
								SYSDATE ENTER_DATE,   
								:GVS_USER_ID ,   
								SYSDATE LAST_MODIFY_DATE,   
								LAST_MODIFY_BY,   
								LAST_LINE_CODE,   
								LAST_WORKSTAGE_CODE,   
								:LVS_MAGAZINE_LABEL_NO4,
								PCB_ITEM ,
								RECEIPT_STATUS,
								RECEIPT_CONFIRM_YN,
								TRANSACTION_TYPE,
								TRANSACTION_NO,
								'D', //$$HEX5$$98d330ae88d420002000$$ENDHEX$$
								:IVS_MAGAZINE_SET_NO,
								MFS_GROUP_NO, 
								ORIGIN_MAGAZINE_LABEL_NO, 
								MAGAZINE_LABEL_NO
					  FROM IP_PRODUCT_RUN_CARD_IO 
					WHERE MAGAZINE_LABEL_NO = :LVS_MAGAZINE_LABEL_NO 
						AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID
						AND ROWNUM = 1;
						 
							IF F_SQL_CHECK() < 0 THEN 
								RETURN 
							END IF 		
				
							//========================================================================================
							//
							//========================================================================================
							IF cbx_auto_print.CHECKED = TRUE THEN 
							
										 dw_4.retrieve( LVS_MAGAZINE_LABEL_NO4 ,  f_get_dual_lang_text(GVS_LANGUAGE , "SPLIT" ), GVI_ORGANIZATION_ID , gvs_language ) 
												
													if dw_4.rowcount( ) < 1 then 
														  st_status.text = f_msg("$$HEX14$$7cb7a8bc20009ccd25b8d0c52000e4c228d3200088d5b5c2c8b2e4b2$$ENDHEX$$","S")
														  dw_1.bringtotop = true 
													else
															dw_4.print( true )
															st_status.text = f_msg("$$HEX11$$15c8c1c0200098ccacb9200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$","S")
													end if 							
													
							END IF 		

			END IF ;  //$$HEX16$$88bdc9b7200018c2c9b7d0c5200000b35cd520007cb7a8bc2000090009000900$$ENDHEX$$
			

//=================================================
//  $$HEX14$$d0c698b720007cb7a8bc200031bcc5c5c4d620002000adc01cc82000$$ENDHEX$$
//=================================================
				  INSERT INTO "IP_PRODUCT_RUN_CARD_IO_BACK"  
							( "RECEIPT_DATE",   
							  "RECEIPT_SEQUENCE",   
							  "RUN_NO",   
							  "ITEM_CODE",   
							  "MODEL_NAME",   
							  "MODEL_SUFFIX",   
							  "LINE_CODE",   
							  "WORKSTAGE_CODE",   
							  "RECEIPT_DEFICIT",   
							  "LOT_QTY",   
							  "LAST_WORKSTAGE_CODE",   
							  "MAGAZINE_LABEL_NO",   
							  "PCB_ITEM",   
							  "RECEIPT_CONFIRM_YN",   
							  "RECEIPT_CONFIRM_DATE",   
							  "RECEIPT_CONFIRM_BY",   
							  "RECEIPT_STATUS",   
							  "ORGANIZATION_ID",   
							  "ENTER_DATE",   
							  "ENTER_BY",   
							  "LAST_MODIFY_DATE",   
							  "LAST_MODIFY_BY",   
							  "LAST_LINE_CODE",   
							  "TRANSACTION_TYPE",   
							  "TRANSACTION_NO",   
							  "TRANSACTION_YN",   
							  "MAGAZINE_LABEL_TYPE",   
							  "RETURN_CONFIRM_YN",   
							  "RETURN_CONFIRM_DATE",   
							  "IN_DATE",   
							  "OUT_DATE",   
							  "OUT_QTY",   
							  "RUN_DATE",   
							  "ACTIVE_DATE",   
							  "IN_QTY",   
							  "IO_DEFICIT",   
							  "TRANSFER_MODEL_NAME",   
							  "TRANSFER_MODEL_SUFFIX",   
							  "TRANSFER_MAGAZINE_LABEL_NO",   
							  "BAD_QTY",   
							  "DEACTIVE_DATE",   
							  "WORKSTAGE_STOP_COUNT",   
							  "CYCLE_TIME",   
							  "ACTIVE_YN",   
							  "DEFECT_QTY",   
							  "PRODUCT_RUN_TYPE", 
							  ORIGIN_MAGAZINE_LABEL_NO, 
							  PARENT_MAGAZINE_LABEL_NO)  
					  SELECT "IP_PRODUCT_RUN_CARD_IO"."RECEIPT_DATE",   
								"IP_PRODUCT_RUN_CARD_IO"."RECEIPT_SEQUENCE",   
								"IP_PRODUCT_RUN_CARD_IO"."RUN_NO",   
								"IP_PRODUCT_RUN_CARD_IO"."ITEM_CODE",   
								"IP_PRODUCT_RUN_CARD_IO"."MODEL_NAME",   
								"IP_PRODUCT_RUN_CARD_IO"."MODEL_SUFFIX",   
								"IP_PRODUCT_RUN_CARD_IO"."LINE_CODE",   
								"IP_PRODUCT_RUN_CARD_IO"."WORKSTAGE_CODE",   
								"IP_PRODUCT_RUN_CARD_IO"."RECEIPT_DEFICIT",   
								"IP_PRODUCT_RUN_CARD_IO"."LOT_QTY",   
								"IP_PRODUCT_RUN_CARD_IO"."LAST_WORKSTAGE_CODE",   
								"IP_PRODUCT_RUN_CARD_IO"."MAGAZINE_LABEL_NO",   
								"IP_PRODUCT_RUN_CARD_IO"."PCB_ITEM",   
								"IP_PRODUCT_RUN_CARD_IO"."RECEIPT_CONFIRM_YN",   
								"IP_PRODUCT_RUN_CARD_IO"."RECEIPT_CONFIRM_DATE",   
								"IP_PRODUCT_RUN_CARD_IO"."RECEIPT_CONFIRM_BY",   
								"IP_PRODUCT_RUN_CARD_IO"."RECEIPT_STATUS",   
								"IP_PRODUCT_RUN_CARD_IO"."ORGANIZATION_ID",   
								"IP_PRODUCT_RUN_CARD_IO"."ENTER_DATE",   
								"IP_PRODUCT_RUN_CARD_IO"."ENTER_BY",   
								"IP_PRODUCT_RUN_CARD_IO"."LAST_MODIFY_DATE",   
								"IP_PRODUCT_RUN_CARD_IO"."LAST_MODIFY_BY",   
								"IP_PRODUCT_RUN_CARD_IO"."LAST_LINE_CODE",   
								"IP_PRODUCT_RUN_CARD_IO"."TRANSACTION_TYPE",   
								"IP_PRODUCT_RUN_CARD_IO"."TRANSACTION_NO",   
								"IP_PRODUCT_RUN_CARD_IO"."TRANSACTION_YN",   
								"IP_PRODUCT_RUN_CARD_IO"."MAGAZINE_LABEL_TYPE",   
								"IP_PRODUCT_RUN_CARD_IO"."RETURN_CONFIRM_YN",   
								"IP_PRODUCT_RUN_CARD_IO"."RETURN_CONFIRM_DATE",   
								"IP_PRODUCT_RUN_CARD_IO"."IN_DATE",   
								"IP_PRODUCT_RUN_CARD_IO"."OUT_DATE",   
								"IP_PRODUCT_RUN_CARD_IO"."OUT_QTY",   
								"IP_PRODUCT_RUN_CARD_IO"."RUN_DATE",   
								"IP_PRODUCT_RUN_CARD_IO"."ACTIVE_DATE",   
								"IP_PRODUCT_RUN_CARD_IO"."IN_QTY",   
								"IP_PRODUCT_RUN_CARD_IO"."IO_DEFICIT",   
								"IP_PRODUCT_RUN_CARD_IO"."TRANSFER_MODEL_NAME",   
								"IP_PRODUCT_RUN_CARD_IO"."TRANSFER_MODEL_SUFFIX",   
								:LVS_MAGAZINE_LABEL_NO1|| ',' ||:LVS_MAGAZINE_LABEL_NO2||:LVS_MAGAZINE_LABEL_NO3|| ',' ||:LVS_MAGAZINE_LABEL_NO4 ,  // "IP_PRODUCT_RUN_CARD_IO"."TRANSFER_MAGAZINE_LABEL_NO",   
								"IP_PRODUCT_RUN_CARD_IO"."BAD_QTY",   
								"IP_PRODUCT_RUN_CARD_IO"."DEACTIVE_DATE",   
								"IP_PRODUCT_RUN_CARD_IO"."WORKSTAGE_STOP_COUNT",   
								"IP_PRODUCT_RUN_CARD_IO"."CYCLE_TIME",   
								"IP_PRODUCT_RUN_CARD_IO"."ACTIVE_YN",   
								"IP_PRODUCT_RUN_CARD_IO"."DEFECT_QTY",   
								"IP_PRODUCT_RUN_CARD_IO"."PRODUCT_RUN_TYPE", 
								ORIGIN_MAGAZINE_LABEL_NO, 
								PARENT_MAGAZINE_LABEL_NO
						 FROM "IP_PRODUCT_RUN_CARD_IO"  
						WHERE MAGAZINE_LABEL_NO = :LVS_MAGAZINE_LABEL_NO
						AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
				
						 IF F_SQL_CHECK() < 0 THEN 
							RETURN 
						END IF 
						
	                       //============================================
						//
						//============================================
						
						DELETE FROM IP_PRODUCT_RUN_CARD_IO
						WHERE MAGAZINE_LABEL_NO = :LVS_MAGAZINE_LABEL_NO
							AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
							 
						 IF F_SQL_CHECK() < 0 THEN 
							RETURN 
						END IF 
			
				//=================================================
				//
				//=================================================
				
					 UPDATE IP_PRODUCT_RUN_CARD_IO
					       SET TRANSFER_MAGAZINE_LABEL_NO = :LVS_MAGAZINE_LABEL_NO
					  WHERE MAGAZINE_LABEL_NO IN (  :LVS_MAGAZINE_LABEL_NO1 , :LVS_MAGAZINE_LABEL_NO2 , :LVS_MAGAZINE_LABEL_NO3 , :LVS_MAGAZINE_LABEL_NO4 )
						 AND ORGANIZATION_ID      = :GVI_ORGANIZATION_ID	 ;
						 
					 IF F_SQL_CHECK() < 0 THEN 
						RETURN 
					END IF 	


	//==============================================
	// $$HEX7$$ccc66cd0a4c24cd174c7c0c92000$$ENDHEX$$IO $$HEX17$$e0c2dcad200014bc54cfdcb45cb82000acc7e0ac200084bd60d5200098ccacb92000$$ENDHEX$$2018.04.11
	//==============================================
	string lvs_out , lvs_outmsg, lvs_barcode, lvs_location, lvs_commit
	long  lvl_row
	lvs_out = space(4000)
	lvs_outmsg = space(4000)
	
	declare proc procedure for PS_PROD_WS_IO_SPLIT_MAGAZINE (:GVI_ORGANIZATION_ID,  :LVS_MAGAZINE_LABEL_NO ) 
	using sqlca ; 
	
	execute proc ; 
	fetch proc into :lvs_out, :lvs_outmsg ; 
	close proc ; 
	
	if f_sql_check() < 0 then
		return
	end if 

	if lvs_out = 'NG' then 
		//$$HEX22$$b4c5a4b52000d0c678c73cc75cb82000adc01cc8200058d5c0c92000bbba58d5e0ac2000acb934d128b42000$$ENDHEX$$
		//$$HEX8$$d0c678c7200054badcc2c0c994b22000$$ENDHEX$$lvs_outmsg 	
		f_play_mp3("shibai.mp3")
		Messagebox( 'NG', lvs_outmsg )
		return 
	else 
		//$$HEX3$$31c1f5ac2000$$ENDHEX$$
			f_play_mp3("chenggong.mp3") 
	end if 
//===============================================
//
//===============================================


//	  lvl_row = dw_1.insertrow(1)
//		
//	  dw_1.object.model_name[lvl_row] = lvs_model_name 
//	  dw_1.object.model_suffix[lvl_row] = lvs_model_suffix
//	  dw_1.object.line_code[lvl_row] = lvs_line_code
//	  dw_1.object.workstage_code[lvl_row] = lvs_workstage_code
//	  dw_1.object.item_code[lvl_row] = lvs_item_code
//	  dw_1.object.serial_no[lvl_row] = lvs_pid
//	  dw_1.object.io_date[lvl_row] = f_sysdate()
//	  dw_1.object.io_qty[lvl_row] =LVL_IO_QTY
//	  dw_1.object.io_deficit[lvl_row] = 'I'
//






sle_magazine_no_split.text = ''
em_lot_divide_qty.text = ''
EM_NG_QTY.TEXT = ''
EM_DESTROY_QTY.TEXT = ''
em_lot_qty.text = ''
sle_magazine_no_split.setfocus()

ST_STATUS.TEXT = f_msg("$$HEX11$$15c8c1c0200098ccacb9200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$","S")	

COMMIT ;
dw_1.reset()
dw_1.RETRIEVE( IVS_RUN_NO ,  GVI_ORGANIZATION_ID )


f_msgbox(170) 
end event

type ddlb_pcb_item from uo_basecode within w_pln_product_magazine_label_split_master
integer x = 567
integer y = 872
integer width = 768
integer taborder = 60
boolean bringtotop = true
boolean allowedit = true
end type

event constructor;call super::constructor;this.redraw('TOP BOTTOM')
end event

type st_4 from so_statictext within w_pln_product_magazine_label_split_master
integer x = 50
integer y = 868
integer width = 507
integer height = 76
boolean bringtotop = true
long textcolor = 0
string text = "PCB Item"
alignment alignment = right!
end type

type em_lot_qty from so_editmask within w_pln_product_magazine_label_split_master
integer x = 567
integer y = 968
integer width = 768
integer taborder = 70
boolean bringtotop = true
string text = ""
string mask = "###,###"
end type

type st_5 from so_statictext within w_pln_product_magazine_label_split_master
integer x = 50
integer y = 972
integer width = 507
integer height = 76
boolean bringtotop = true
long textcolor = 0
string text = "Lot Qty"
alignment alignment = right!
end type

type st_9 from so_statictext within w_pln_product_magazine_label_split_master
integer x = 50
integer y = 1072
integer width = 507
integer height = 76
boolean bringtotop = true
long textcolor = 16711680
string text = "Lot Divide Qty"
alignment alignment = right!
end type

type em_lot_divide_qty from so_editmask within w_pln_product_magazine_label_split_master
integer x = 567
integer y = 1060
integer width = 768
integer taborder = 80
boolean bringtotop = true
string text = ""
string mask = "###,###"
end type

type em_ng_qty from so_editmask within w_pln_product_magazine_label_split_master
integer x = 567
integer y = 1152
integer width = 768
integer taborder = 90
boolean bringtotop = true
string text = ""
string mask = "###,###"
end type

type em_destroy_qty from so_editmask within w_pln_product_magazine_label_split_master
integer x = 567
integer y = 1240
integer width = 768
integer taborder = 100
boolean bringtotop = true
string text = ""
string mask = "###,###"
end type

type st_6 from so_statictext within w_pln_product_magazine_label_split_master
integer x = 50
integer y = 1164
integer width = 507
integer height = 76
boolean bringtotop = true
long textcolor = 16711680
string text = "Lot NG Qty"
alignment alignment = right!
end type

type st_12 from so_statictext within w_pln_product_magazine_label_split_master
integer x = 50
integer y = 1248
integer width = 507
integer height = 76
boolean bringtotop = true
long textcolor = 16711680
string text = "Lot Destroy Qty"
alignment alignment = right!
end type

type st_1 from so_statictext within w_pln_product_magazine_label_split_master
integer x = 91
integer y = 436
integer width = 407
integer height = 76
boolean bringtotop = true
long textcolor = 134217729
string text = "Workstage Code"
alignment alignment = right!
end type

type gb_2 from so_groupbox within w_pln_product_magazine_label_split_master
integer x = 14
integer y = 612
integer width = 1399
integer height = 1120
long textcolor = 16711680
string text = "Magazine Split"
end type

type gb_3 from so_groupbox within w_pln_product_magazine_label_split_master
integer x = 9
integer y = 108
integer width = 1399
integer height = 492
long textcolor = 16711680
string text = "Result"
end type

