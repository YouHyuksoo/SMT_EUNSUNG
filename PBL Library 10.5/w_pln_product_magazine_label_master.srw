HA$PBExportHeader$w_pln_product_magazine_label_master.srw
$PBExportComments$$$HEX17$$b9c278c7d0c658c7a8ba78b3d0c5200000b35cd52000b9d231c144c7200000adacb9$$ENDHEX$$
forward
global type w_pln_product_magazine_label_master from w_main_root
end type
type ddlb_model_name from uo_model_name_ddlb within w_pln_product_magazine_label_master
end type
type st_3 from so_statictext within w_pln_product_magazine_label_master
end type
type st_7 from so_statictext within w_pln_product_magazine_label_master
end type
type cb_print from so_commandbutton within w_pln_product_magazine_label_master
end type
type st_status from so_statictext within w_pln_product_magazine_label_master
end type
type cb_destroy from so_commandbutton within w_pln_product_magazine_label_master
end type
type cb_reprint from so_commandbutton within w_pln_product_magazine_label_master
end type
type ddlb_result_workstage_code from uo_workstage_code_all within w_pln_product_magazine_label_master
end type
type st_mrm_no from so_statictext within w_pln_product_magazine_label_master
end type
type sle_model_name from so_singlelineedit within w_pln_product_magazine_label_master
end type
type sle_magazine_label_no from so_singlelineedit within w_pln_product_magazine_label_master
end type
type st_1 from so_statictext within w_pln_product_magazine_label_master
end type
type st_10 from so_statictext within w_pln_product_magazine_label_master
end type
type st_11 from so_statictext within w_pln_product_magazine_label_master
end type
type ddlb_workstage_code from uo_workstage_code_all within w_pln_product_magazine_label_master
end type
type st_2 from so_statictext within w_pln_product_magazine_label_master
end type
type sle_destroy_magazine_no from so_singlelineedit within w_pln_product_magazine_label_master
end type
type sle_user_id from so_singlelineedit within w_pln_product_magazine_label_master
end type
type st_user_id from so_statictext within w_pln_product_magazine_label_master
end type
type sle_user_name from so_singlelineedit within w_pln_product_magazine_label_master
end type
type em_1 from so_editmask within w_pln_product_magazine_label_master
end type
type em_2 from so_editmask within w_pln_product_magazine_label_master
end type
type ddlb_result_line_code from uo_line_code_smt_dd within w_pln_product_magazine_label_master
end type
type cbx_auto_print from so_checkbox within w_pln_product_magazine_label_master
end type
type cb_split from so_commandbutton within w_pln_product_magazine_label_master
end type
type ddlb_line_code from uo_line_code_dd within w_pln_product_magazine_label_master
end type
type sle_run_no from so_singlelineedit within w_pln_product_magazine_label_master
end type
type st_19 from so_statictext within w_pln_product_magazine_label_master
end type
type sle_run_no_cond from so_singlelineedit within w_pln_product_magazine_label_master
end type
type st_8 from so_statictext within w_pln_product_magazine_label_master
end type
type em_lot_size from so_editmask within w_pln_product_magazine_label_master
end type
type ddlb_pcb_item from uo_basecode within w_pln_product_magazine_label_master
end type
type gb_5 from so_groupbox within w_pln_product_magazine_label_master
end type
type gb_3 from so_groupbox within w_pln_product_magazine_label_master
end type
type gb_6 from so_groupbox within w_pln_product_magazine_label_master
end type
type dw_6 from so_datawindow within w_pln_product_magazine_label_master
end type
type cbx_repair_label from so_checkbox within w_pln_product_magazine_label_master
end type
type st_4 from so_statictext within w_pln_product_magazine_label_master
end type
type st_5 from so_statictext within w_pln_product_magazine_label_master
end type
type st_6 from so_statictext within w_pln_product_magazine_label_master
end type
type st_9 from so_statictext within w_pln_product_magazine_label_master
end type
type gb_1 from so_groupbox within w_pln_product_magazine_label_master
end type
type gb_2 from so_groupbox within w_pln_product_magazine_label_master
end type
end forward

global type w_pln_product_magazine_label_master from w_main_root
integer width = 6331
integer height = 3420
string title = "Magazine Label Master"
long backcolor = 16777215
string icon = "Form!"
string ivs_dw_2_selected_row_yn = "Y"
ddlb_model_name ddlb_model_name
st_3 st_3
st_7 st_7
cb_print cb_print
st_status st_status
cb_destroy cb_destroy
cb_reprint cb_reprint
ddlb_result_workstage_code ddlb_result_workstage_code
st_mrm_no st_mrm_no
sle_model_name sle_model_name
sle_magazine_label_no sle_magazine_label_no
st_1 st_1
st_10 st_10
st_11 st_11
ddlb_workstage_code ddlb_workstage_code
st_2 st_2
sle_destroy_magazine_no sle_destroy_magazine_no
sle_user_id sle_user_id
st_user_id st_user_id
sle_user_name sle_user_name
em_1 em_1
em_2 em_2
ddlb_result_line_code ddlb_result_line_code
cbx_auto_print cbx_auto_print
cb_split cb_split
ddlb_line_code ddlb_line_code
sle_run_no sle_run_no
st_19 st_19
sle_run_no_cond sle_run_no_cond
st_8 st_8
em_lot_size em_lot_size
ddlb_pcb_item ddlb_pcb_item
gb_5 gb_5
gb_3 gb_3
gb_6 gb_6
dw_6 dw_6
cbx_repair_label cbx_repair_label
st_4 st_4
st_5 st_5
st_6 st_6
st_9 st_9
gb_1 gb_1
gb_2 gb_2
end type
global w_pln_product_magazine_label_master w_pln_product_magazine_label_master

type variables
string IVS_LINE_CODE, IVS_WORKSTAGE_CODE , IVS_RUN_NO , IVS_MASTER_MODEL_NAME  , IVS_PCB_ITEM , IVS_MAGAZINE_LABEL_NO , IVS_MAGAZINE_SET_NO
end variables

on w_pln_product_magazine_label_master.create
int iCurrent
call super::create
this.ddlb_model_name=create ddlb_model_name
this.st_3=create st_3
this.st_7=create st_7
this.cb_print=create cb_print
this.st_status=create st_status
this.cb_destroy=create cb_destroy
this.cb_reprint=create cb_reprint
this.ddlb_result_workstage_code=create ddlb_result_workstage_code
this.st_mrm_no=create st_mrm_no
this.sle_model_name=create sle_model_name
this.sle_magazine_label_no=create sle_magazine_label_no
this.st_1=create st_1
this.st_10=create st_10
this.st_11=create st_11
this.ddlb_workstage_code=create ddlb_workstage_code
this.st_2=create st_2
this.sle_destroy_magazine_no=create sle_destroy_magazine_no
this.sle_user_id=create sle_user_id
this.st_user_id=create st_user_id
this.sle_user_name=create sle_user_name
this.em_1=create em_1
this.em_2=create em_2
this.ddlb_result_line_code=create ddlb_result_line_code
this.cbx_auto_print=create cbx_auto_print
this.cb_split=create cb_split
this.ddlb_line_code=create ddlb_line_code
this.sle_run_no=create sle_run_no
this.st_19=create st_19
this.sle_run_no_cond=create sle_run_no_cond
this.st_8=create st_8
this.em_lot_size=create em_lot_size
this.ddlb_pcb_item=create ddlb_pcb_item
this.gb_5=create gb_5
this.gb_3=create gb_3
this.gb_6=create gb_6
this.dw_6=create dw_6
this.cbx_repair_label=create cbx_repair_label
this.st_4=create st_4
this.st_5=create st_5
this.st_6=create st_6
this.st_9=create st_9
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_model_name
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_7
this.Control[iCurrent+4]=this.cb_print
this.Control[iCurrent+5]=this.st_status
this.Control[iCurrent+6]=this.cb_destroy
this.Control[iCurrent+7]=this.cb_reprint
this.Control[iCurrent+8]=this.ddlb_result_workstage_code
this.Control[iCurrent+9]=this.st_mrm_no
this.Control[iCurrent+10]=this.sle_model_name
this.Control[iCurrent+11]=this.sle_magazine_label_no
this.Control[iCurrent+12]=this.st_1
this.Control[iCurrent+13]=this.st_10
this.Control[iCurrent+14]=this.st_11
this.Control[iCurrent+15]=this.ddlb_workstage_code
this.Control[iCurrent+16]=this.st_2
this.Control[iCurrent+17]=this.sle_destroy_magazine_no
this.Control[iCurrent+18]=this.sle_user_id
this.Control[iCurrent+19]=this.st_user_id
this.Control[iCurrent+20]=this.sle_user_name
this.Control[iCurrent+21]=this.em_1
this.Control[iCurrent+22]=this.em_2
this.Control[iCurrent+23]=this.ddlb_result_line_code
this.Control[iCurrent+24]=this.cbx_auto_print
this.Control[iCurrent+25]=this.cb_split
this.Control[iCurrent+26]=this.ddlb_line_code
this.Control[iCurrent+27]=this.sle_run_no
this.Control[iCurrent+28]=this.st_19
this.Control[iCurrent+29]=this.sle_run_no_cond
this.Control[iCurrent+30]=this.st_8
this.Control[iCurrent+31]=this.em_lot_size
this.Control[iCurrent+32]=this.ddlb_pcb_item
this.Control[iCurrent+33]=this.gb_5
this.Control[iCurrent+34]=this.gb_3
this.Control[iCurrent+35]=this.gb_6
this.Control[iCurrent+36]=this.dw_6
this.Control[iCurrent+37]=this.cbx_repair_label
this.Control[iCurrent+38]=this.st_4
this.Control[iCurrent+39]=this.st_5
this.Control[iCurrent+40]=this.st_6
this.Control[iCurrent+41]=this.st_9
this.Control[iCurrent+42]=this.gb_1
this.Control[iCurrent+43]=this.gb_2
end on

on w_pln_product_magazine_label_master.destroy
call super::destroy
destroy(this.ddlb_model_name)
destroy(this.st_3)
destroy(this.st_7)
destroy(this.cb_print)
destroy(this.st_status)
destroy(this.cb_destroy)
destroy(this.cb_reprint)
destroy(this.ddlb_result_workstage_code)
destroy(this.st_mrm_no)
destroy(this.sle_model_name)
destroy(this.sle_magazine_label_no)
destroy(this.st_1)
destroy(this.st_10)
destroy(this.st_11)
destroy(this.ddlb_workstage_code)
destroy(this.st_2)
destroy(this.sle_destroy_magazine_no)
destroy(this.sle_user_id)
destroy(this.st_user_id)
destroy(this.sle_user_name)
destroy(this.em_1)
destroy(this.em_2)
destroy(this.ddlb_result_line_code)
destroy(this.cbx_auto_print)
destroy(this.cb_split)
destroy(this.ddlb_line_code)
destroy(this.sle_run_no)
destroy(this.st_19)
destroy(this.sle_run_no_cond)
destroy(this.st_8)
destroy(this.em_lot_size)
destroy(this.ddlb_pcb_item)
destroy(this.gb_5)
destroy(this.gb_3)
destroy(this.gb_6)
destroy(this.dw_6)
destroy(this.cbx_repair_label)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.st_9)
destroy(this.gb_1)
destroy(this.gb_2)
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
//st_status.width = dw_1.width
//st_status.width = newwidth 
//st_status.width = ii_win_width 
dw_6.SETTRANSOBJECT(SQLCA)


F_SET_COLUMN_DDDW(DW_3)
F_SET_COLUMN_DDDW(DW_4)

F_SET_COLUMN_DDDW(DW_6)

end event

event ue_data_control;call super::ue_data_control;Long ROW
STRING LVS_SETYN
STRING lvsa_transfer_type[]

CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
	
	
					dw_1.reset()
					//dw_1.RETRIEVE( sle_run_no.text ,  GVI_ORGANIZATION_ID )
					//2018.04.09 $$HEX17$$e4b970acc4c9200044c720007dc7c8c544c74cb5200070c88cd6200048c528b42000$$ENDHEX$$?  $$HEX9$$48c518b494b28cac2000deb994b2c0c92000$$ENDHEX$$? $$HEX8$$18b494b28cac2000deb994b2c0c92000$$ENDHEX$$
					dw_1.RETRIEVE(ivs_run_no, GVI_ORGANIZATION_ID) 
					dw_1.SETFOCUS()	
			
		
	CASE 'UPDATE'
		


	CASE ELSE
END CHOOSE


end event

event resize;call super::resize;DW_5.WIdth = DW_1.WIdth


st_status.width = newwidth 
end event

type dw_5 from w_main_root`dw_5 within w_pln_product_magazine_label_master
integer x = 3666
integer y = 436
integer width = 2610
integer height = 1172
integer taborder = 0
boolean titlebar = true
string dataobject = "d_pln_product_magazine_destroy_label_rpt"
end type

type dw_4 from w_main_root`dw_4 within w_pln_product_magazine_label_master
integer x = 3666
integer y = 436
integer width = 2610
integer height = 1164
integer taborder = 0
boolean titlebar = true
string title = "NG Label"
string dataobject = "d_pln_product_magazine_ng_label_rpt"
end type

type dw_3 from w_main_root`dw_3 within w_pln_product_magazine_label_master
integer x = 3666
integer y = 436
integer width = 2610
integer height = 1164
integer taborder = 0
boolean titlebar = true
string title = "Good Label"
string dataobject = "d_pln_product_magazine_label_rpt"
end type

type dw_2 from w_main_root`dw_2 within w_pln_product_magazine_label_master
integer x = 3666
integer y = 436
integer width = 2610
integer height = 1164
integer taborder = 0
boolean titlebar = true
string title = "Repair Good Label"
string dataobject = "d_pln_product_magazine_repair_label_rpt"
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

type dw_1 from w_main_root`dw_1 within w_pln_product_magazine_label_master
integer x = 3666
integer y = 436
integer width = 2610
integer height = 1164
integer taborder = 0
boolean titlebar = true
string title = "Magazine List"
string dataobject = "d_pln_product_run_card_io_by_run_no_lst"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type uo_tabpages from w_main_root`uo_tabpages within w_pln_product_magazine_label_master
integer x = 23
integer y = 3672
integer taborder = 0
end type

type ddlb_model_name from uo_model_name_ddlb within w_pln_product_magazine_label_master
integer x = 1673
integer y = 920
integer width = 1029
integer height = 1748
integer taborder = 50
boolean bringtotop = true
integer textsize = -14
end type

event selectionchanged;call super::selectionchanged;sle_run_no.setfocus()
end event

type st_3 from so_statictext within w_pln_product_magazine_label_master
integer x = 1673
integer y = 812
integer width = 1029
integer height = 76
boolean bringtotop = true
integer textsize = -14
integer weight = 700
long textcolor = 134217729
long backcolor = 16777215
string text = "Master Model Name"
end type

type st_7 from so_statictext within w_pln_product_magazine_label_master
integer x = 1275
integer y = 536
integer width = 613
integer height = 64
boolean bringtotop = true
long textcolor = 134217729
string text = "Line Code"
end type

type cb_print from so_commandbutton within w_pln_product_magazine_label_master
integer x = 805
integer y = 2048
integer width = 901
integer height = 128
integer taborder = 100
boolean bringtotop = true
boolean italic = true
string text = "Print Label"
end type

event clicked;call super::clicked;STRING LVS_MAGAZINE_LABEL_NO , LVS_RUN_NO , LVS_MODEL_NAME , LVS_MODEL_SUFFIX , LVS_USER_ID , LVS_MAGAZINE_BOX_NO 
STRING LVS_LINE_CODE ,LVS_WORKSTAGE_CODE, LVS_PCB_ITEM  , LVS_ITEM_CODE , lvs_label_type
LONG LVL_LOT_QTY , LVL_LOT_QTY_SUM , LVL_LOT_SIZE , I , LVL_NG_QTY , LVL_OK_INCLUDE_QTY , LVL_DESTROY_QTY , LVL_MAGAZINE_QTY , LVL_REPAIR_QTY
DOUBLE LVDB_REECEIPT_SEQUENCE
//==================================================
//
//==================================================
dw_6.accepttext( )

 if sle_user_id.text = '' then  
	f_msg("$$HEX14$$91c7c5c590c7200014bc54cfdcb47cb92000a4c294ce58d538c194c6$$ENDHEX$$","P")
	sle_user_id.setfocus( )
	return 
end if 
  
//====================================================
//
//====================================================
LVS_LINE_CODE =  ddlb_result_line_code.GETCODE() 
LVS_WORKSTAGE_CODE =ddlb_result_workstage_code.getcode()
LVS_PCB_ITEM         = ddlb_pcb_item.getcode()
LVS_RUN_NO           = sle_run_no.text
LVS_MODEL_SUFFIX = '*'
//LVS_USER_ID =  MID( SLE_USER_ID.TEXT , 1,  POS ( SLE_USER_ID.TEXT , '@' , 1) -1 )
LVS_USER_ID = SLE_USER_ID.TEXT 
//===================================================
//
//===================================================


IF LVS_RUN_NO = ''  or LVS_RUN_NO = '%' or isnull(LVS_RUN_NO) THEN 
	f_msgbox1(102  ,f_get_dual_lang_text ( gvs_language , 'RUN NO'))
	RETURN 
END IF 

IF LVS_LINE_CODE = ''  or LVS_LINE_CODE = '%' or isnull(LVS_LINE_CODE) THEN 
	f_msgbox1(102  ,f_get_dual_lang_text ( gvs_language , 'LINE CODE'))
	RETURN 
END IF 

IF LVS_WORKSTAGE_CODE = ''  or LVS_WORKSTAGE_CODE = '%' or isnull(LVS_WORKSTAGE_CODE) THEN 
	f_msgbox1(102  ,f_get_dual_lang_text ( gvs_language , 'WORKSTAGE CODE'))
	RETURN 
END IF 
IF LVS_PCB_ITEM = ''  or LVS_PCB_ITEM = '%' or isnull(LVS_PCB_ITEM) THEN 
	f_msgbox1(102  ,f_get_dual_lang_text ( gvs_language , 'PCB ITEM'))
	RETURN 
END IF 
//====================================================
//
//====================================================
//SELECT SUM(LOT_QTY) INTO :LVL_LOT_QTY_SUM
//	FROM IP_PRODUCT_RUN_CARD_IO
// WHERE RUN_NO = :LVS_RUN_NO
//	  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID  ;
//
//IF F_SQL_CHECK() < 0 THEN 
//	RETURN 
//END IF  

LVL_LOT_SIZE = f_get_lot_size_by_run_no( LVS_RUN_NO) 

//===================================================
//
//===================================================
msg = f_msgbox1(1160 , this.text)

if msg = 1 then 
else
	return 
end if 

IVS_MAGAZINE_SET_NO =   LVS_LINE_CODE+F_YMD_SYSDATE()+ STRING(F_GET_SEQUENCE( 'SEQ_MAGAZINE_LABEL_SEQUENCE') , '0000') 
DO
	
	I++

			LVL_LOT_QTY = 0
			LVL_NG_QTY = 0
			LVL_OK_INCLUDE_QTY = 0
			LVL_DESTROY_QTY = 0
			LVL_REPAIR_QTY = 0 
			LVL_MAGAZINE_QTY = 0 
			
			LVS_MODEL_NAME   = dw_6.object.model_name[i]
			LVS_ITEM_CODE      = dw_6.object.item_code[i]
			LVL_LOT_QTY             = dw_6.object.ok_qty[i]
			LVL_NG_QTY               = dw_6.object.ng_qty[i]
			LVL_OK_INCLUDE_QTY = dw_6.object.ok_include_qty[i] // $$HEX29$$88bdc9b774c720001cbcddc0200088d5c0c9ccb92000b4c508b874c72000d0c5200091c588d4c4b3200056c1ecc5200088c73cc7c0bb5cb82000$$ENDHEX$$
			LVL_DESTROY_QTY      = dw_6.object.destroy_qty[i]
			
			
			LVL_REPAIR_QTY      = dw_6.object.repair_qty[i]
			LVL_MAGAZINE_QTY      = dw_6.object.magazine_qty[i]
			
			//$$HEX15$$85c725b81cb4200012ac74c72000c6c53cc774ba2000a4c2b5d020000900$$ENDHEX$$
			
			IF LVL_LOT_qty = 0 and LVL_NG_QTY = 0 THEN 
				CONTINUE
			END IF 
			
			//====================================================
			//
			//====================================================
			IF LVS_MODEL_NAME = '' OR LVS_MODEL_SUFFIX = '' THEN 
				f_msgbox1(102  ,f_get_dual_lang_text ( gvs_language , 'MODEL NAME'))
				RETURN 
			END IF 

			IF LVL_LOT_QTY < 0 THEN 
				f_msgbox1(102  ,f_get_dual_lang_text ( gvs_language , 'LOT QTY'))
				RETURN 
			END IF 
			
			//====================================================
			//  $$HEX15$$18c2acb9c4d6200091c588d420007cb7a8bc20006cad84bd200012ac2000$$ENDHEX$$
			//====================================================
			
			IF cbx_repair_label.checked = true then 
				lvs_label_type = 'R'
			else
				lvs_label_type = 'P'
			end if 
				
			// LVL_MAGAZINE_QTY = $$HEX14$$74c7f8bb2000ddc031c11cb4200054ba70acc4c9200018c2c9b72000$$ENDHEX$$, LVL_LOT_QTY = $$HEX4$$74c788bcd0c52000$$ENDHEX$$ok $$HEX7$$98ccacb91cb4200018c2c9b72000$$ENDHEX$$
			IF LVL_MAGAZINE_QTY + LVL_LOT_QTY  +  LVL_NG_QTY + LVL_OK_INCLUDE_QTY  > LVL_LOT_SIZE THEN 
				
				f_msg( "$$HEX27$$1dcd2000e4b970acc4c9200018c2c9b774c720006fb8b8d2200018c2c9b744c7200008cdfcac200060d518c22000c6c5b5c2c8b2e4b2$$ENDHEX$$" , "P") 
				return 
				
			END IF 
			IF LVL_LOT_QTY > 0 THEN 
			//=====================================================
			// $$HEX10$$91c588d42000e4b970acc4c920007cb7a8bc2000$$ENDHEX$$
			//=====================================================
				
//			SELECT  F_GET_NEW_MAGAZINE_NO( :LVS_LINE_CODE ,  :LVS_MODEL_NAME ) 	
//				INTO :LVS_MAGAZINE_LABEL_NO 
//			FROM DUAL ;
//			
//			IF F_SQL_CHECK() < 0 THEN
//				RETURN 
//			END IF 
		
								
			LVS_MAGAZINE_LABEL_NO =   LVS_LINE_CODE+F_YMD_SYSDATE()+ STRING(F_GET_SEQUENCE( 'SEQ_MAGAZINE_LABEL_SEQUENCE') , '0000') 
			
			
			LVDB_REECEIPT_SEQUENCE = F_GET_SEQUENCE('SEQ_MAGAZINE_RECEIPT_SEQUENCE') 

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
									TRANSFER_MODEL_NAME ,
									TRANSFER_MODEL_SUFFIX,
									OK_INCLUDE_QTY,
									BAD_QTY ,
									DESTROY_QTY,
									MAGAZINE_SET_NO,
									MFS_GROUP_NO, 
									ORIGIN_MAGAZINE_LABEL_NO, 
									PARENT_MAGAZINE_LABEL_NO)  
					  VALUES (  
								:LVS_RUN_NO,   
								SYSDATE , //RUN_DATE,   
								:LVDB_REECEIPT_SEQUENCE  ,
								:LVS_ITEM_CODE , //ITEM_CODE,   
								:LVS_MODEL_NAME,   
								:LVS_MODEL_SUFFIX,   
								:LVS_LINE_CODE,   
								:LVS_WORKSTAGE_CODE,   
								'1' , //IO_DEFICIT,   
								:LVL_LOT_QTY , //IN_QTY,   
								:GVI_ORGANIZATION_ID , //ORGANIZATION_ID,   
								SYSDATE , //ENTER_DATE,   
								:LVS_USER_ID , //ENTER_BY,   
								SYSDATE , //LAST_MODIFY_DATE,   
								:GVS_USER_ID , //LAST_MODIFY_BY,   
								:LVS_LINE_CODE , //LAST_LINE_CODE,   
								:LVS_WORKSTAGE_CODE , //LAST_WORKSTAGE_CODE,   
								:LVS_MAGAZINE_LABEL_NO,
								:LVS_PCB_ITEM,
								'N' , // RECEIPT STATUS
								'N' , //RECEIPT_CONFIRM_YN
								 'R' , //TRANSACTION_TYPE
								 :LVDB_REECEIPT_SEQUENCE ,
								 'P'  , //'P',
								 :LVS_MODEL_NAME ,
								 :LVS_MODEL_SUFFIX, 
								 0,
								 0,
								 NVL(:LVL_DESTROY_QTY , 0),
								 :IVS_MAGAZINE_SET_NO,
								 '',
								:LVS_MAGAZINE_LABEL_NO, //ORGINAL MAGAZINE LABEL NO $$HEX10$$74c7c4d62000c4ac8dc1200030b57cb710ac2000$$ENDHEX$$
								 '*') ;
						
					 IF F_SQL_CHECK() < 0 THEN 
						RETURN 
					END IF 

					//==================================================
					// $$HEX13$$91c588d42000e4b970acc4c920007cb7a8bc20009ccd25b82000$$ENDHEX$$
					//==================================================
					dw_3.bringtotop = true 
					
					dw_3.retrieve( LVS_MAGAZINE_LABEL_NO , 'NEW'  , GVI_ORGANIZATION_ID, gvs_language  ) 
					f_set_column_dddw(dw_3)
					//messagebox(gvs_language, 'LANG')

					if dw_3.rowcount( ) < 1 then 
						  st_status.text = f_msg_st1(108 , 'Print' ) // @  $$HEX8$$e4c228d3200088d5b5c2c8b2e4b22000$$ENDHEX$$. 
						  f_msg_mdi_help(LVS_LINE_CODE+' '+LVS_WORKSTAGE_CODE+' '+LVS_PCB_ITEM+' $$HEX14$$7cb7a8bc20009ccd25b8d0c52000e4c228d3200088d5b5c2c8b2e4b2$$ENDHEX$$' ) 
						  dw_1.bringtotop = true 
					else
							
							dw_3.print( false )
							st_status.text = "OK"
							dw_1.bringtotop = true 
					end if 
			END IF 
			
			
			  IF LVL_REPAIR_QTY > 0 THEN 
			//=====================================================
			// $$HEX13$$18c2acb9200091c588d42000e4b970acc4c920007cb7a8bc2000$$ENDHEX$$
			//=====================================================
//				SELECT  F_GET_NEW_MAGAZINE_NO( :LVS_LINE_CODE ,  :LVS_MODEL_NAME ) 	
//					INTO :LVS_MAGAZINE_LABEL_NO 
//				FROM DUAL ;
//				
//				IF F_SQL_CHECK() < 0 THEN
//					RETURN 
//				END IF 
			
			LVS_MAGAZINE_LABEL_NO =   LVS_LINE_CODE+F_YMD_SYSDATE()+ STRING(F_GET_SEQUENCE( 'SEQ_MAGAZINE_LABEL_SEQUENCE') , '0000') 
			LVDB_REECEIPT_SEQUENCE = F_GET_SEQUENCE('SEQ_MAGAZINE_RECEIPT_SEQUENCE') 

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
									TRANSFER_MODEL_NAME ,
									TRANSFER_MODEL_SUFFIX,
									OK_INCLUDE_QTY,
									BAD_QTY ,
									DESTROY_QTY,
									MAGAZINE_SET_NO,
									MFS_GROUP_NO, 
									ORIGIN_MAGAZINE_LABEL_NO, 
									PARENT_MAGAZINE_LABEL_NO)  
					  VALUES (  
								:LVS_RUN_NO,   
								SYSDATE , //RUN_DATE,   
								:LVDB_REECEIPT_SEQUENCE  ,
								:LVS_ITEM_CODE , //ITEM_CODE,   
								:LVS_MODEL_NAME,   
								:LVS_MODEL_SUFFIX,   
								:LVS_LINE_CODE,   
								:LVS_WORKSTAGE_CODE,   
								'1' , //IO_DEFICIT,   
								:LVL_REPAIR_QTY , //IN_QTY,   
								:GVI_ORGANIZATION_ID , //ORGANIZATION_ID,   
								SYSDATE , //ENTER_DATE,   
								:LVS_USER_ID , //ENTER_BY,   
								SYSDATE , //LAST_MODIFY_DATE,   
								:GVS_USER_ID , //LAST_MODIFY_BY,   
								:LVS_LINE_CODE , //LAST_LINE_CODE,   
								:LVS_WORKSTAGE_CODE , //LAST_WORKSTAGE_CODE,   
								:LVS_MAGAZINE_LABEL_NO,
								:LVS_PCB_ITEM,
								'N' , // RECEIPT STATUS
								'N' , //RECEIPT_CONFIRM_YN
								 'R' , //TRANSACTION_TYPE
								 :LVDB_REECEIPT_SEQUENCE ,
								 'R' , //'P',
								 :LVS_MODEL_NAME ,
								 :LVS_MODEL_SUFFIX, 
								 0,
								 0,
								 NVL(:LVL_DESTROY_QTY , 0),
								 :IVS_MAGAZINE_SET_NO,
								 '', 
								 :LVS_MAGAZINE_LABEL_NO, 
								 '*') ;
						
					 IF F_SQL_CHECK() < 0 THEN 
						RETURN 
					END IF 

					//==================================================
					// $$HEX17$$18c2acb9c4d6200091c588d42000e4b970acc4c920007cb7a8bc20009ccd25b82000$$ENDHEX$$
					//==================================================
					dw_2.retrieve( LVS_MAGAZINE_LABEL_NO , 'NEW'  , GVI_ORGANIZATION_ID, gvs_language  ) 
					f_set_column_dddw(dw_2)
					if dw_2.rowcount( ) < 1 then 
						  st_status.text = f_msg_st1(108 , 'Print' ) // @  $$HEX8$$e4c228d3200088d5b5c2c8b2e4b22000$$ENDHEX$$. 
						  f_msg_mdi_help(LVS_LINE_CODE+' '+LVS_WORKSTAGE_CODE+' '+LVS_PCB_ITEM+' $$HEX14$$7cb7a8bc20009ccd25b8d0c52000e4c228d3200088d5b5c2c8b2e4b2$$ENDHEX$$' ) 
						  dw_1.bringtotop = true 
					else
						  f_set_column_dddw(dw_2)  
							dw_2.print( false )
							st_status.text = "OK"
							dw_1.bringtotop = true 
					end if 
			END IF 
			
			IF LVL_DESTROY_QTY > 0 THEN 
			//=====================================================
			// $$HEX8$$98d330ae88d4200020007cb7a8bc2000$$ENDHEX$$
			//=====================================================
//				SELECT  F_GET_NEW_MAGAZINE_NO( :LVS_LINE_CODE ,  :LVS_MODEL_NAME ) 	
//					INTO :LVS_MAGAZINE_LABEL_NO 
//				FROM DUAL ;
//				
//				IF F_SQL_CHECK() < 0 THEN
//					RETURN 
//				END IF 			
		
		     LVS_MAGAZINE_LABEL_NO =   LVS_LINE_CODE+F_YMD_SYSDATE()+ STRING(F_GET_SEQUENCE( 'SEQ_MAGAZINE_LABEL_SEQUENCE') , '0000') 
			LVDB_REECEIPT_SEQUENCE = F_GET_SEQUENCE('SEQ_MAGAZINE_RECEIPT_SEQUENCE') 

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
									TRANSFER_MODEL_NAME ,
									TRANSFER_MODEL_SUFFIX,
									OK_INCLUDE_QTY,
									BAD_QTY ,
									DESTROY_QTY,
									MAGAZINE_SET_NO,
									MFS_GROUP_NO, 
									ORIGIN_MAGAZINE_LABEL_NO, 
									PARENT_MAGAZINE_LABEL_NO
									)  
					  VALUES (  
								:LVS_RUN_NO,   
								SYSDATE , //RUN_DATE,   
								:LVDB_REECEIPT_SEQUENCE  ,
								:LVS_ITEM_CODE , //ITEM_CODE,   
								:LVS_MODEL_NAME,   
								:LVS_MODEL_SUFFIX,   
								:LVS_LINE_CODE,   
								:LVS_WORKSTAGE_CODE,   
								'1' , //IO_DEFICIT,   
								:LVL_DESTROY_QTY , //IN_QTY,   
								:GVI_ORGANIZATION_ID , //ORGANIZATION_ID,   
								SYSDATE , //ENTER_DATE,   
								:LVS_USER_ID , //ENTER_BY,   
								SYSDATE , //LAST_MODIFY_DATE,   
								:GVS_USER_ID , //LAST_MODIFY_BY,   
								:LVS_LINE_CODE , //LAST_LINE_CODE,   
								:LVS_WORKSTAGE_CODE , //LAST_WORKSTAGE_CODE,   
								:LVS_MAGAZINE_LABEL_NO,
								:LVS_PCB_ITEM,
								'N' , // RECEIPT STATUS
								'N' , //RECEIPT_CONFIRM_YN
								 'R' , //TRANSACTION_TYPE
								 :LVDB_REECEIPT_SEQUENCE ,
								 'D' , //'P',
								 :LVS_MODEL_NAME ,
								 :LVS_MODEL_SUFFIX, 
								 0,
								 0,
								 NVL(:LVL_DESTROY_QTY , 0),
								 :IVS_MAGAZINE_SET_NO,
								 '', 
								 :LVS_MAGAZINE_LABEL_NO, 
								 '*' ) ;
						
					 IF F_SQL_CHECK() < 0 THEN 
						RETURN 
					END IF 

					//==================================================
					// $$HEX14$$d0d330ae88d42000e4b970acc4c920007cb7a8bc20009ccd25b82000$$ENDHEX$$
					//==================================================
					dw_5.retrieve( LVS_MAGAZINE_LABEL_NO , 'NEW'  , GVI_ORGANIZATION_ID, gvs_language  ) 
					f_set_column_dddw(dw_5)
					if dw_5.rowcount( ) < 1 then 
						  st_status.text = f_msg_st1(108 , 'Print' ) // @  $$HEX8$$e4c228d3200088d5b5c2c8b2e4b22000$$ENDHEX$$. 
						  f_msg_mdi_help(LVS_LINE_CODE+' '+LVS_WORKSTAGE_CODE+' '+LVS_PCB_ITEM+' $$HEX14$$7cb7a8bc20009ccd25b8d0c52000e4c228d3200088d5b5c2c8b2e4b2$$ENDHEX$$' ) 
						  dw_1.bringtotop = true 
					else
						    f_set_column_dddw(dw_5)
							dw_5.print( false )
							st_status.text = "OK"
							dw_1.bringtotop = true 
					end if 
			END IF 			
			
			IF LVL_NG_QTY > 0 THEN 
			//=====================================================
			// $$HEX11$$88bdc9b788d42000e4b970acc4c920007cb7a8bc2000$$ENDHEX$$
			//=====================================================
//				SELECT  F_GET_NEW_MAGAZINE_NO( :LVS_LINE_CODE ,  :LVS_MODEL_NAME ) 	
//					INTO :LVS_MAGAZINE_LABEL_NO 
//				FROM DUAL ;
//				
//				IF F_SQL_CHECK() < 0 THEN
//					RETURN 
//				END IF 
			
			LVS_MAGAZINE_LABEL_NO =   LVS_LINE_CODE+F_YMD_SYSDATE()+ STRING(F_GET_SEQUENCE( 'SEQ_MAGAZINE_LABEL_SEQUENCE') , '0000') 
			LVDB_REECEIPT_SEQUENCE = F_GET_SEQUENCE('SEQ_MAGAZINE_RECEIPT_SEQUENCE') 

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
									TRANSFER_MODEL_NAME ,
									TRANSFER_MODEL_SUFFIX,
									OK_INCLUDE_QTY ,
									DESTROY_QTY,
									MAGAZINE_SET_NO,
									MFS_GROUP_NO, 
									ORIGIN_MAGAZINE_LABEL_NO, 
									PARENT_MAGAZINE_LABEL_NO)  
					  VALUES (  
								:LVS_RUN_NO,   
								SYSDATE , //RUN_DATE,   
								:LVDB_REECEIPT_SEQUENCE  ,
								:LVS_ITEM_CODE , //ITEM_CODE,   
								:LVS_MODEL_NAME,   
								:LVS_MODEL_SUFFIX,   
								:LVS_LINE_CODE,   
								:LVS_WORKSTAGE_CODE,   
								'1' , //IO_DEFICIT,   
								:LVL_NG_QTY , //IN_QTY,   
								:GVI_ORGANIZATION_ID , //ORGANIZATION_ID,   
								SYSDATE , //ENTER_DATE,   
								:LVS_USER_ID , //ENTER_BY,   
								SYSDATE , //LAST_MODIFY_DATE,   
								:GVS_USER_ID , //LAST_MODIFY_BY,   
								:LVS_LINE_CODE , //LAST_LINE_CODE,   
								:LVS_WORKSTAGE_CODE , //LAST_WORKSTAGE_CODE,   
								:LVS_MAGAZINE_LABEL_NO,
								:LVS_PCB_ITEM,
								'N' , // RECEIPT STATUS
								'N' , //RECEIPT_CONFIRM_YN
								 'R' , //TRANSACTION_TYPE
								 :LVDB_REECEIPT_SEQUENCE ,
								 'B', //$$HEX3$$88bdc9b72000$$ENDHEX$$
								 :LVS_MODEL_NAME ,
								 '*' ,
								 nvl(:LVL_OK_INCLUDE_QTY,0),
								 NVL(:LVL_DESTROY_QTY , 0),
								 :IVS_MAGAZINE_SET_NO,
								 '', 
								 :LVS_MAGAZINE_LABEL_NO, 
								 '*'
								 ) ;
						
					 IF F_SQL_CHECK() < 0 THEN 
						RETURN 
					END IF 

					
					//==================================================
					// $$HEX13$$88bdc9b72000e4b970acc4c920007cb7a8bc20009ccd25b82000$$ENDHEX$$
					//==================================================
					dw_4.retrieve( LVS_MAGAZINE_LABEL_NO , 'NEW'  , GVI_ORGANIZATION_ID, gvs_language  ) 
					f_set_column_dddw(dw_4)
					if dw_4.rowcount( ) < 1 then 
						  st_status.text = f_msg_st1(108 , 'Print' ) // @  $$HEX8$$e4c228d3200088d5b5c2c8b2e4b22000$$ENDHEX$$. 
						  f_msg_mdi_help(LVS_LINE_CODE+' '+LVS_WORKSTAGE_CODE+' '+LVS_PCB_ITEM+' $$HEX14$$7cb7a8bc20009ccd25b8d0c52000e4c228d3200088d5b5c2c8b2e4b2$$ENDHEX$$' ) 
						  dw_1.bringtotop = true 
					else
					 	  f_set_column_dddw(dw_4)
							dw_4.print( false )
							st_status.text = "OK"
							dw_1.bringtotop = true 
					end if 
					
				END IF // NG QTY > 0 
	
	
	
		LOOP UNTIL  i = dw_6.rowcount()
		
//================================
//
//================================
COMMIT ;
sle_run_no.setfocus()
sle_run_no.triggerevent(modified!)
end event

type st_status from so_statictext within w_pln_product_magazine_label_master
integer y = 316
integer width = 4887
integer height = 104
boolean bringtotop = true
integer textsize = -14
integer weight = 700
long textcolor = 65535
long backcolor = 134217741
string text = "Message"
end type

type cb_destroy from so_commandbutton within w_pln_product_magazine_label_master
integer x = 2245
integer y = 2296
integer width = 1358
integer height = 128
boolean bringtotop = true
boolean italic = true
string text = "Lot Destroy"
end type

event clicked;call super::clicked;string LVS_LINE_CODE , LVS_WORKSTAGE_CODE , LVS_MAGAZINE_LABEL_NO , LVS_PCB_ITEM , LVS_MAGAZINE_SET_NO
LONG LVI_COUNT, LVI_IO_COUNT

if sle_destroy_magazine_no.text = '' then  
	f_msg("$$HEX13$$28d330ae60d520007cb7a8bc44c72000a4c294ce58d538c194c6$$ENDHEX$$","P")
	return 
end if 

LVS_MAGAZINE_LABEL_NO = sle_destroy_magazine_no.text  

if sle_destroy_magazine_no.text = '' then  
	return 
end if 
 
 
msg = f_msgbox1(1160 , "$$HEX23$$a8bae0b4200030ae5db874c72000adc01cc818b4e0ac2000acc7e0acc4b3200008cd30ae54d6200029b4c8b2e4b2$$ENDHEX$$! "+this.text)

if msg = 1 then 
	
	
           SELECT COUNT(*)  ,   MAX(LINE_CODE) , MAX(WORKSTAGE_CODE) , MAX(PCB_ITEM)  , MAX(MAGAZINE_SET_NO)
			 INTO :LVI_COUNT ,  :LVS_LINE_CODE , :LVS_WORKSTAGE_CODE , :LVS_PCB_ITEM , :LVS_MAGAZINE_SET_NO
			FROM  IP_PRODUCT_RUN_CARD_IO 
		 WHERE MAGAZINE_LABEL_NO = :LVS_MAGAZINE_LABEL_NO
			 AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;	
	
		IF F_SQL_CHECK() < 0 THEN 
			RETURN 
		END IF 			
		
		IF LVI_COUNT = 0  or LVS_MAGAZINE_SET_NO = '' THEN 
			st_status.text = f_msg("$$HEX30$$e4b970acc4c9200074c7d9b3200074c725b844c720003ecc44c718c22000c6c570ac98b0200074c7f8bb200085c7e0ac200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$","S")
			RETURN 
		END IF 
		
//=====================================================================
// workstage io $$HEX14$$d0c5200074c8acc7200058d574ba2000d0d330ae200088bd00ac2000$$ENDHEX$$
// 2018.04.10 $$HEX6$$7cc7e8b2200094cd00ac2000$$ENDHEX$$zethani
//=====================================================================
select count(*) 
  into :LVI_IO_COUNT 
  from ip_product_workstage_io x 
 where x.serial_no =:LVS_MAGAZINE_LABEL_NO ; 
 
IF F_SQL_CHECK() < 0 THEN 
	RETURN 
END IF 			

IF LVI_IO_COUNT > 0  THEN 
	st_status.text = f_msg("$$HEX16$$f5ac15c8200074c7d9b3200074c725b874c7200074c8acc7200069d5c8b2e4b2$$ENDHEX$$. $$HEX8$$d0d330ae200088bd00ac69d5c8b2e4b2$$ENDHEX$$. ","S")
	RETURN 
END IF 

//=====================================================================
// $$HEX9$$d0d330ae200058d594b270b320005cc62000$$ENDHEX$$? $$HEX17$$9ccd25b844c7200058d594b270acc0c92000adc01cc8200020b4200088b178c770b3$$ENDHEX$$.. $$HEX37$$f8adacb9e0ac200091c588d4200088bdc9b7200019ac74c720001cbc89d5dcc2200088bdc9b744c72000e8cd8cc174d5c4b3200091c588d474c7200019ac74c72000adc01cc828b42000$$ENDHEX$$
// WHY ? 
//=====================================================================
IF cbx_auto_print.CHECKED = TRUE THEN 

			dw_3.retrieve( LVS_MAGAZINE_SET_NO , F_GET_DUAL_LANG_TEXT( GVS_LANGUAGE , 'DESTROY')  , GVI_ORGANIZATION_ID , GVS_LANGUAGE ) 
			if dw_3.rowcount( ) < 1 then 
				  st_status.text = f_msg("$$HEX14$$7cb7a8bc20009ccd25b8d0c52000e4c228d3200088d5b5c2c8b2e4b2$$ENDHEX$$","S")
				dw_1.bringtotop = true 
			else
					dw_3.print( false )
					st_status.text =f_msg( "$$HEX11$$15c8c1c0200098ccacb9200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$","S")
			end if 
END IF 		
		
				//=================================================
				//  $$HEX14$$d0c698b720007cb7a8bc200031bcc5c5c4d620002000adc01cc82000$$ENDHEX$$
				//=================================================
				// $$HEX21$$d0c67cb7a8bc2000adc01cc8200058d5e0ac200031bcc5c544c7200058d594b2200074c720c794b22000$$ENDHEX$$? 
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
							  "PRODUCT_RUN_TYPE" , 
							  MAGAZINE_SET_NO, 
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
								"IP_PRODUCT_RUN_CARD_IO"."TRANSFER_MAGAZINE_LABEL_NO",   
								"IP_PRODUCT_RUN_CARD_IO"."BAD_QTY",   
								"IP_PRODUCT_RUN_CARD_IO"."DEACTIVE_DATE",   
								"IP_PRODUCT_RUN_CARD_IO"."WORKSTAGE_STOP_COUNT",   
								"IP_PRODUCT_RUN_CARD_IO"."CYCLE_TIME",   
								"IP_PRODUCT_RUN_CARD_IO"."ACTIVE_YN",   
								"IP_PRODUCT_RUN_CARD_IO"."DEFECT_QTY",   
								"IP_PRODUCT_RUN_CARD_IO"."PRODUCT_RUN_TYPE" ,
								IP_PRODUCT_RUN_CARD_IO.MAGAZINE_SET_NO, 
								ORIGIN_MAGAZINE_LABEL_NO, 
								PARENT_MAGAZINE_LABEL_NO
						 FROM "IP_PRODUCT_RUN_CARD_IO"  
						WHERE MAGAZINE_SET_NO = :LVS_MAGAZINE_SET_NO
						AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
				
						 IF F_SQL_CHECK() < 0 THEN 
							RETURN 
						END IF 
						
									
					  DELETE FROM  IP_PRODUCT_RUN_CARD_IO 
					 WHERE MAGAZINE_SET_NO = :LVS_MAGAZINE_SET_NO
							AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
						 ;	
							
					IF F_SQL_CHECK() < 0 THEN 
						RETURN 
					END IF 			
		
		COMMIT  ;
		
		ST_STATUS.TEXT = f_msg("$$HEX11$$15c8c1c0200098ccacb9200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$","S")	
	//	f_msgbox(170) 	
end if 

sle_destroy_magazine_no.text = ''
sle_run_no.setfocus()
sle_run_no.triggerevent(modified!)

end event

type cb_reprint from so_commandbutton within w_pln_product_magazine_label_master
integer x = 2702
integer y = 2048
integer width = 901
integer height = 128
boolean bringtotop = true
boolean italic = true
string text = "RePrint"
end type

event clicked;call super::clicked;string LVS_MAGAZINE_LABEL_NO	

LVS_MAGAZINE_LABEL_NO =  dw_1.object.magazine_label_no[dw_1.getrow()]

		if dw_1.object.magazine_label_type[dw_1.getrow()] = 'B' then
			
			dw_4.retrieve( LVS_MAGAZINE_LABEL_NO , 'NEW'  , GVI_ORGANIZATION_ID, gvs_language  ) 
			f_set_column_dddw(dw_4)
			
			if dw_4.rowcount( ) < 1 then 
				  st_status.text = f_msg_st1(108 , 'Print' ) // @  $$HEX8$$e4c228d3200088d5b5c2c8b2e4b22000$$ENDHEX$$. 
				  f_msg_mdi_help(LVS_MAGAZINE_LABEL_NO+' $$HEX14$$7cb7a8bc20009ccd25b8d0c52000e4c228d3200088d5b5c2c8b2e4b2$$ENDHEX$$' ) 		
			else
				 
					dw_4.print( false )
					st_status.text = "Reprint OK"
			end if 
					

		else
			dw_3.retrieve( LVS_MAGAZINE_LABEL_NO , 'NEW'  , GVI_ORGANIZATION_ID, gvs_language  ) 
			f_set_column_dddw(dw_3)
			
			if dw_3.rowcount( ) < 1 then 
				  st_status.text = f_msg_st1(108 , 'Print' ) // @  $$HEX8$$e4c228d3200088d5b5c2c8b2e4b22000$$ENDHEX$$. 
				  f_msg_mdi_help(LVS_MAGAZINE_LABEL_NO+' $$HEX14$$7cb7a8bc20009ccd25b8d0c52000e4c228d3200088d5b5c2c8b2e4b2$$ENDHEX$$' ) 		
			else
				 
					dw_3.print( false )
					st_status.text = "Reprint OK"
			end if 
		end if 
			
sle_run_no.setfocus()
end event

event rbuttondown;call super::rbuttondown;dw_3.bringtotop = true 
end event

type ddlb_result_workstage_code from uo_workstage_code_all within w_pln_product_magazine_label_master
integer x = 1897
integer y = 612
integer width = 1024
integer height = 1816
integer taborder = 40
boolean bringtotop = true
boolean allowedit = true
end type

event constructor;call super::constructor;IVS_WORKSTAGE_CODE = Profilestring("WORKENV.INI","WORKSTAGE","WORKSTAGE_IO","")
THIS.SELECtitem(IVS_WORKSTAGE_CODE )

end event

event selectionchanged;call super::selectionchanged;f_jsSetProfileString ("WORKENV.INI", "WORKSTAGE", "WORKSTAGE_IO", THIS.GETCODE() )
sle_run_no.setfocus()
end event

type st_mrm_no from so_statictext within w_pln_product_magazine_label_master
integer x = 1294
integer y = 84
integer width = 526
integer height = 68
boolean bringtotop = true
long backcolor = 16777215
string text = "Model Name"
end type

type sle_model_name from so_singlelineedit within w_pln_product_magazine_label_master
integer x = 1298
integer y = 176
integer width = 526
integer height = 88
boolean bringtotop = true
end type

type sle_magazine_label_no from so_singlelineedit within w_pln_product_magazine_label_master
integer x = 1829
integer y = 176
integer width = 558
integer height = 88
boolean bringtotop = true
end type

type st_1 from so_statictext within w_pln_product_magazine_label_master
integer x = 1829
integer y = 84
integer width = 558
integer height = 68
boolean bringtotop = true
long backcolor = 16777215
string text = "Lot No"
end type

type st_10 from so_statictext within w_pln_product_magazine_label_master
integer x = 2971
integer y = 84
integer width = 1179
integer height = 68
boolean bringtotop = true
long backcolor = 16777215
string text = "Date"
end type

type st_11 from so_statictext within w_pln_product_magazine_label_master
integer x = 73
integer y = 84
integer width = 567
integer height = 68
boolean bringtotop = true
long backcolor = 16777215
string text = "Line Code"
end type

type ddlb_workstage_code from uo_workstage_code_all within w_pln_product_magazine_label_master
integer x = 658
integer y = 176
integer width = 635
integer height = 1616
boolean bringtotop = true
end type

event constructor;call super::constructor;IVS_WORKSTAGE_CODE = Profilestring("WORKENV.INI","WORKSTAGE","MAGAZINE","")
THIS.SELECtitem(IVS_WORKSTAGE_CODE )
end event

event selectionchanged;call super::selectionchanged;IVS_WORkstage_code = THIS.GETCODE()
f_jsSetProfileString ("WORKENV.INI", "WORKSTAGE", "MAGAZINE", THIS.GETCODE() )
end event

type st_2 from so_statictext within w_pln_product_magazine_label_master
integer x = 663
integer y = 84
integer width = 635
integer height = 68
boolean bringtotop = true
long backcolor = 16777215
string text = "Workstage Code"
end type

type sle_destroy_magazine_no from so_singlelineedit within w_pln_product_magazine_label_master
integer x = 1294
integer y = 2316
integer width = 910
integer height = 92
boolean bringtotop = true
end type

event getfocus;call super::getfocus;this.selecttext( 1, 100)
end event

event modified;call super::modified;cb_destroy.triggerevent(clicked!)
end event

type sle_user_id from so_singlelineedit within w_pln_product_magazine_label_master
integer x = 37
integer y = 612
integer width = 613
integer height = 84
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

sle_run_no.setfocus( )
end event

event getfocus;call super::getfocus;this.selecttext( 1, 100)
end event

type st_user_id from so_statictext within w_pln_product_magazine_label_master
integer x = 59
integer y = 516
integer width = 571
integer height = 76
boolean bringtotop = true
string text = "User ID"
end type

type sle_user_name from so_singlelineedit within w_pln_product_magazine_label_master
integer x = 658
integer y = 612
integer width = 521
integer height = 84
integer taborder = 30
boolean bringtotop = true
boolean displayonly = true
end type

type em_1 from so_editmask within w_pln_product_magazine_label_master
integer x = 2958
integer y = 180
integer width = 594
integer taborder = 30
boolean bringtotop = true
integer weight = 400
string text = ""
alignment alignment = left!
maskdatatype maskdatatype = datetimemask!
string mask = "yyyy/mm/dd hh:mm:ss"
boolean dropdowncalendar = true
end type

event constructor;call super::constructor;this.text =string( f_sysdate())
end event

type em_2 from so_editmask within w_pln_product_magazine_label_master
integer x = 3561
integer y = 180
integer width = 594
integer taborder = 40
boolean bringtotop = true
integer weight = 400
string text = ""
alignment alignment = left!
maskdatatype maskdatatype = datetimemask!
string mask = "yyyy/mm/dd hh:mm:ss"
boolean dropdowncalendar = true
end type

event constructor;call super::constructor;this.text =string( f_sysdate())
end event

type ddlb_result_line_code from uo_line_code_smt_dd within w_pln_product_magazine_label_master
integer x = 1275
integer y = 612
integer width = 613
integer height = 1448
integer taborder = 40
boolean bringtotop = true
boolean allowedit = true
integer limit = 30
end type

type cbx_auto_print from so_checkbox within w_pln_product_magazine_label_master
integer x = 4210
integer y = 172
integer width = 590
boolean bringtotop = true
long backcolor = 16777215
string text = "Auto Print"
boolean checked = true
end type

type cb_split from so_commandbutton within w_pln_product_magazine_label_master
integer x = 1755
integer y = 2044
integer width = 901
integer height = 128
integer taborder = 60
boolean bringtotop = true
boolean italic = true
boolean enabled = false
string text = "Lot Split ( Good + NG )"
end type

event clicked;call super::clicked;STRING LVS_MAGAZINE_LABEL_NO ,LVS_MAGAZINE_LABEL_NO1 , LVS_MAGAZINE_LABEL_NO2, LVS_LINE_CODE , LVS_WORKSTAGE_CODE , LVS_PCB_ITEM 
string LVS_MODEL_NAME , LVS_MODEL_SUFFIX , LVS_USER_ID , LVS_ITEM_CODE , LVS_MAGAZINE_LABEL_TYPE
LONG LVI_COUNT , LVL_LOT_QTY_SUM , i , LVL_LOT_QTY , LVL_NG_QTY

if sle_run_no.text = '' then  
	f_msg( "$$HEX14$$84bd60d5200060d520007cb7a8bc44c72000a4c294ce58d538c194c6$$ENDHEX$$","P")
	return 
end if 

msg = f_msgbox1(1161 ,  this.text ) 

if msg = 1 then  
else
	return 
end if 
//====================================================
//
//====================================================
LVS_LINE_CODE =  ddlb_result_line_code.GETCODE() 
LVS_WORKSTAGE_CODE =ddlb_result_workstage_code.getcode()
LVS_PCB_ITEM         = ddlb_pcb_item.getcode()
LVS_MODEL_SUFFIX = '*'
//LVS_USER_ID =  MID( SLE_USER_ID.TEXT , 1,  POS ( SLE_USER_ID.TEXT , '@' , 1) -1 )
//$$HEX9$$74c774ac200034bbc7c578c7c0c994c62000$$ENDHEX$$? 
//2018.04.09 $$HEX3$$18c215c82000$$ENDHEX$$
lvs_user_id = sle_user_id.text 
LVS_MAGAZINE_LABEL_NO = sle_run_no.text  

//====================================================
//
//====================================================

IF LVS_MAGAZINE_LABEL_NO = ''  or LVS_MAGAZINE_LABEL_NO = '%' or isnull(LVS_MAGAZINE_LABEL_NO) THEN 
	f_msgbox1(102  ,f_get_dual_lang_text ( gvs_language , 'MAGAZINE LABEL NO'))
	RETURN 
END IF 

IF LVS_LINE_CODE = ''  or LVS_LINE_CODE = '%' or isnull(LVS_LINE_CODE) THEN 
	f_msgbox1(102  ,f_get_dual_lang_text ( gvs_language , 'LINE CODE'))
	RETURN 
END IF 

IF LVS_WORKSTAGE_CODE = ''  or LVS_WORKSTAGE_CODE = '%' or isnull(LVS_WORKSTAGE_CODE) THEN 
	f_msgbox1(102  ,f_get_dual_lang_text ( gvs_language , 'WORKSTAGE CODE'))
	RETURN 
END IF 
IF LVS_PCB_ITEM = ''  or LVS_PCB_ITEM = '%' or isnull(LVS_PCB_ITEM) THEN 
	f_msgbox1(102  ,f_get_dual_lang_text ( gvs_language , 'PCB ITEM'))
	RETURN 
END IF 
//==================================================
//
//==================================================
SELECT COUNT(*) ,  SUM(LOT_QTY)
    INTO :LVI_COUNT , :LVL_LOT_QTY_SUM
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

IVS_MAGAZINE_SET_NO =   LVS_LINE_CODE+F_YMD_SYSDATE()+ STRING(F_GET_SEQUENCE( 'SEQ_MAGAZINE_LABEL_SEQUENCE') , '0000') 
//============================================================
//
//============================================================
DO
	
	I++

			LVS_MODEL_NAME   = dw_6.object.model_name[i]
			LVS_ITEM_CODE      = dw_6.object.item_code[i]
			LVL_LOT_QTY          = dw_6.object.ok_qty[i]
			LVL_NG_QTY            = dw_6.object.ng_qty[i]
			
			IF LVL_NG_QTY > 0 THEN 				
				LVS_MAGAZINE_LABEL_TYPE = 'B' //$$HEX7$$88bdc9b720000900090009000900$$ENDHEX$$
			ELSE
				LVS_MAGAZINE_LABEL_TYPE = 'P' //$$HEX3$$91c588d42000$$ENDHEX$$
			END IF 
			
//			LVL_OK_INCLUDE_QTY = dw_6.object.ok_include_qty[i]
//			LVL_DESTROY_QTY      = dw_6.object.destroy_qty[i]
			//====================================================
			//
			//====================================================
			IF LVS_MODEL_NAME = '' OR LVS_MODEL_SUFFIX = '' THEN 
				f_msgbox1(102  ,f_get_dual_lang_text ( gvs_language , 'MODEL NAME'))
				RETURN 
			END IF 
			
			
//				SELECT  F_GET_NEW_MAGAZINE_NO( :LVS_LINE_CODE ,  :LVS_MODEL_NAME ) 	
//					INTO :LVS_MAGAZINE_LABEL_NO1 
//				FROM DUAL ;
//				
//				IF F_SQL_CHECK() < 0 THEN
//					RETURN 
//				END IF 		

		LVS_MAGAZINE_LABEL_NO1 =  LVS_LINE_CODE+F_YMD_SYSDATE()+ STRING(F_GET_SEQUENCE( 'SEQ_MAGAZINE_LABEL_SEQUENCE') , '0000') 

		//==========================================		
	    // $$HEX3$$84bd60d52000$$ENDHEX$$
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
					PARENT_MAGAZINE_LABEL_NO)  
				  
		 SELECT RUN_NO,   
					SYSDATE , //RECEIPT_DATE,   
					SEQ_MAGAZINE_RECEIPT_SEQUENCE.NEXTVAL ,
					ITEM_CODE,   
					MODEL_NAME,   
					MODEL_SUFFIX,   
					LINE_CODE,   
					WORKSTAGE_CODE,   
					RECEIPT_DEFICIT,   
					ABS(LOT_QTY) - :LVL_NG_QTY  ,
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
					ORIGIN_MAGAZINE_LABEL_NO, //Origin magazine 
					MAGAZINE_LABEL_NO             //Parent Magazine 
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
				
							dw_3.retrieve( LVS_MAGAZINE_LABEL_NO1 , f_get_dual_lang_text(GVS_LANGUAGE , "SPLIT" ) , GVI_ORGANIZATION_ID, GVS_LANGUAGE  ) 
						     f_set_column_dddw(dw_3)
							if dw_3.rowcount( ) < 1 then 
								  st_status.text = f_msg("$$HEX14$$7cb7a8bc20009ccd25b8d0c52000e4c228d3200088d5b5c2c8b2e4b2$$ENDHEX$$","S")
								  dw_1.bringtotop = true 
							else
								    f_set_column_dddw(dw_3)
									dw_3.print( true )
									st_status.text = f_msg("$$HEX11$$15c8c1c0200098ccacb9200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$","S")
							end if 
				END IF 


//				SELECT  F_GET_NEW_MAGAZINE_NO( :LVS_LINE_CODE ,  :LVS_MODEL_NAME ) 	
//					INTO :LVS_MAGAZINE_LABEL_NO2 
//				FROM DUAL ;
//				
//				IF F_SQL_CHECK() < 0 THEN
//					RETURN 
//				END IF 		


          LVS_MAGAZINE_LABEL_NO2 =  LVS_LINE_CODE+F_YMD_SYSDATE()+  STRING(F_GET_SEQUENCE( 'SEQ_MAGAZINE_LABEL_SEQUENCE') , '0000') 

		//==========================================		
	    // $$HEX3$$84bd60d52000$$ENDHEX$$2
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
					ORIGIN_MAGAZINE_LABEL_NO,            //Origin magazine 
					PARENT_MAGAZINE_LABEL_NO             //Parent Magazine 
					)  
				  
		 SELECT RUN_NO,   
					SYSDATE , //RECEIPT_DATE,   
					SEQ_MAGAZINE_RECEIPT_SEQUENCE.NEXTVAL ,
					ITEM_CODE,   
					MODEL_NAME,   
					MODEL_SUFFIX,   
					LINE_CODE,   
					WORKSTAGE_CODE,   
					RECEIPT_DEFICIT,   
					:LVL_NG_QTY , 
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
					:LVS_MAGAZINE_LABEL_TYPE,
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
				
							dw_3.retrieve( LVS_MAGAZINE_LABEL_NO2 ,  f_get_dual_lang_text(GVS_LANGUAGE , "SPLIT" ), GVI_ORGANIZATION_ID  ) 
						    f_set_column_dddw(dw_3)
							if dw_3.rowcount( ) < 1 then 
								  st_status.text = f_msg("$$HEX14$$7cb7a8bc20009ccd25b8d0c52000e4c228d3200088d5b5c2c8b2e4b2$$ENDHEX$$","S")
								  dw_1.bringtotop = true 
							else
								f_set_column_dddw(dw_3)
									dw_3.print( true )
									st_status.text = f_msg("$$HEX11$$15c8c1c0200098ccacb9200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$","S")
							end if 
				END IF 
				
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
								:LVS_MAGAZINE_LABEL_NO1|| ',' ||:LVS_MAGAZINE_LABEL_NO2 ,  // "IP_PRODUCT_RUN_CARD_IO"."TRANSFER_MAGAZINE_LABEL_NO",   
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
					  WHERE MAGAZINE_LABEL_NO IN (  :LVS_MAGAZINE_LABEL_NO1 , :LVS_MAGAZINE_LABEL_NO2 )
						 AND ORGANIZATION_ID      = :GVI_ORGANIZATION_ID	 ;
						 
					 IF F_SQL_CHECK() < 0 THEN 
						RETURN 
					END IF 	
	
		LOOP UNTIL  i = dw_6.rowcount()

sle_run_no.text = ''
ST_STATUS.TEXT = f_msg("$$HEX11$$15c8c1c0200098ccacb9200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$","S")	

COMMIT ;
f_msgbox(170) 
sle_run_no.setfocus()
end event

type ddlb_line_code from uo_line_code_dd within w_pln_product_magazine_label_master
integer x = 82
integer y = 176
integer width = 571
integer height = 828
integer taborder = 20
boolean bringtotop = true
end type

event constructor;call super::constructor;ivs_line_code = Profilestring("WORKENV.INI","LINE","MAGAZINE","")

THIS.SELECtitem(IVS_LINE_CODE )


end event

event selectionchanged;call super::selectionchanged;IVS_LINE_CODE = THIS.GETCODE()

f_jsSetProfileString ("WORKENV.INI", "LINE", "MAGAZINE", THIS.GETCODE() )

end event

type sle_run_no from so_singlelineedit within w_pln_product_magazine_label_master
integer x = 110
integer y = 908
integer width = 1554
integer height = 152
integer taborder = 40
boolean bringtotop = true
integer textsize = -16
long backcolor = 12639424
end type

event modified;call super::modified;if  f_check_run_no( this.text ) < 0 then 
	f_msgbox(174)
	return 
end if 
//========================================
// $$HEX9$$08cd30ae54d680c8200069d5dcc2f9b22000$$ENDHEX$$instance variable 
// 2018.04.09 
//========================================
IVS_LINE_CODE = '' 
IVS_MASTER_MODEL_NAME = '' 
IVS_PCB_ITEM = '' 

//======================================
// $$HEX18$$f0b715c8f4bc5cb8200080bd30d1200018c2c9b72000a8ba78b3f1b4200070c88cd62000$$ENDHEX$$
//======================================
LONG LVL_LOT_SIZE , I
STRING LVS_RUN_NO 

IVS_RUN_NO = THIS.TEXT 

SELECT  line_code , master_model_name  , lot_size  , pcb_item
   INTO  :IVS_LINE_CODE  , :IVS_MASTER_MODEL_NAME , :LVL_LOT_SIZE , :IVS_PCB_ITEM 
  FROM IP_PRODUCT_RUN_CARD 
 WHERE RUN_NO =  :IVS_RUN_NO ;
 
 IF F_SQL_CHECK() < 0 THEN 
	RETURN 
END IF 

//====================================================
//  $$HEX21$$f0b788bc38d6200000ac2000c6c53cc774ba2000e4b970acc4c9200088bc38d65cb82000b4cc6cd02000$$ENDHEX$$
//====================================================
IF IVS_MASTER_MODEL_NAME = '' OR ISNULL(IVS_MASTER_MODEL_NAME) THEN 
	/*IVS RUN NO $$HEX19$$7cb920007dc7b4c540c62000e4b970acc4c9200088bc38d67cb9200000b3b4cc74d50cc92000$$ENDHEX$$2017.04.09*/
	SELECT  line_code , master_model_name  , lot_size  , pcb_item, run_no
		INTO  :IVS_LINE_CODE  , :IVS_MASTER_MODEL_NAME , :LVL_LOT_SIZE , :IVS_PCB_ITEM , :LVS_RUN_NO
	  FROM IP_PRODUCT_RUN_CARD 
	 WHERE RUN_NO =  ( SELECT MAX(RUN_NO) FROM IP_PRODUCT_RUN_CARD_IO WHERE MAGAZINE_LABEL_NO = :IVS_RUN_NO )  ;
	 
	 IF F_SQL_CHECK() < 0 THEN 
		RETURN 
	END IF 	
	
	
	IVS_RUN_NO = LVS_RUN_NO
END IF 



//======================================
//
//======================================
ddlb_result_line_code.text = IVS_LINE_CODE
ddlb_model_name.text      = IVS_MASTER_MODEL_NAME
ddlb_pcb_item.text            = IVS_PCB_ITEM
em_lot_size.text =string(LVL_LOT_SIZE)

//em_lot_qty.text  = string( f_get_magazine_size(IVS_MASTER_MODEL_NAME ))

dw_6.reset()
dw_6.RETRIEVE(  IVS_MASTER_MODEL_NAME , IVS_RUN_NO , GVI_ORGANIZATION_ID )
dw_6.SETFOCUS()

if dw_6.rowcount( ) < 1 then 
	THIS.TEXT = ''
	f_msg( "$$HEX20$$00b35cd4a8ba78b3200085ba74c72000a8ba78b32000c8b9a4c230d1d0c52000c6c5b5c2c8b2e4b2$$ENDHEX$$" , 'P' ) 
	THIS.SETFOCUS()
	return 
end if 
//=======================================
//  ok $$HEX6$$18c2c9b7200090c7d9b32000$$ENDHEX$$
//=======================================
do
	i++
	dw_6.object.lot_qty[i] =lvl_lot_size
	dw_6.object.ok_qty[i] = dw_6.object.lot_qty[i] - dw_6.object.magazine_qty[i]
	
loop until i = dw_6.rowcount() 
dw_6.accepttext( )
f_retrieve()

end event

type st_19 from so_statictext within w_pln_product_magazine_label_master
integer x = 110
integer y = 800
integer width = 1554
integer height = 100
boolean bringtotop = true
integer textsize = -14
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
string text = "Run No/Magazine Label Scan "
end type

type sle_run_no_cond from so_singlelineedit within w_pln_product_magazine_label_master
integer x = 2395
integer y = 176
integer width = 558
integer height = 88
integer taborder = 30
boolean bringtotop = true
end type

type st_8 from so_statictext within w_pln_product_magazine_label_master
integer x = 2395
integer y = 84
integer width = 558
integer height = 68
boolean bringtotop = true
long backcolor = 16777215
string text = "Run No"
end type

type em_lot_size from so_editmask within w_pln_product_magazine_label_master
integer x = 2715
integer y = 916
integer width = 544
integer height = 128
integer taborder = 110
boolean bringtotop = true
integer textsize = -14
integer weight = 400
boolean enabled = false
string mask = "###,##0"
end type

type ddlb_pcb_item from uo_basecode within w_pln_product_magazine_label_master
integer x = 2935
integer y = 612
integer width = 521
integer taborder = 60
boolean bringtotop = true
boolean allowedit = true
end type

event constructor;call super::constructor;this.redraw('TOP BOTTOM')
end event

event selectionchanged;call super::selectionchanged;sle_run_no.setfocus()
end event

type gb_5 from so_groupbox within w_pln_product_magazine_label_master
integer x = 9
integer width = 4178
integer height = 304
long textcolor = 16711680
long backcolor = 16777215
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_pln_product_magazine_label_master
integer x = 1230
integer y = 440
integer width = 2405
integer height = 352
long textcolor = 16711680
string text = "Run Card Information"
end type

type gb_6 from so_groupbox within w_pln_product_magazine_label_master
integer x = 5
integer y = 2224
integer width = 3621
integer height = 252
integer taborder = 50
long textcolor = 16711680
long backcolor = 16777215
end type

type dw_6 from so_datawindow within w_pln_product_magazine_label_master
integer x = 46
integer y = 1204
integer width = 3561
integer height = 816
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = ""
string dataobject = "d_pln_product_model_by_master_model_lst"
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
borderstyle borderstyle = stylebox!
end type

event itemchanged;//OVER 
this.accepttext()

if dwo.name = 'ng_qty' or dwo.name = 'destroy_qty' or dwo.name = 'ok_include_qty' then	
	
	    this.object.ok_qty[row] = this.object.lot_qty[row]   -   ( this.object.ng_qty[row] + this.object.ok_include_qty[row] + this.object.destroy_qty[row]  + this.object.repair_qty[row]  +  this.object.magazine_qty[row]     ) 
	
end if 
end event

type cbx_repair_label from so_checkbox within w_pln_product_magazine_label_master
integer x = 59
integer y = 2052
integer width = 690
integer height = 112
boolean bringtotop = true
integer textsize = -14
long backcolor = 16777215
string text = "Repair Label"
end type

type st_4 from so_statictext within w_pln_product_magazine_label_master
integer x = 87
integer y = 2308
integer width = 1138
integer height = 112
boolean bringtotop = true
integer textsize = -14
long textcolor = 255
long backcolor = 16777215
string text = "Destroy Magazine Label Scan"
alignment alignment = right!
end type

type st_5 from so_statictext within w_pln_product_magazine_label_master
integer x = 1893
integer y = 536
integer width = 1024
integer height = 64
boolean bringtotop = true
long textcolor = 134217729
string text = "Workstage Code"
end type

type st_6 from so_statictext within w_pln_product_magazine_label_master
integer x = 658
integer y = 516
integer width = 521
integer height = 76
boolean bringtotop = true
string text = "User Name"
end type

type st_9 from so_statictext within w_pln_product_magazine_label_master
integer x = 2935
integer y = 536
integer width = 521
integer height = 64
boolean bringtotop = true
string text = "PCB Item"
end type

type gb_1 from so_groupbox within w_pln_product_magazine_label_master
integer y = 1080
integer width = 3630
integer height = 1132
integer taborder = 70
long textcolor = 16711680
long backcolor = 16777215
end type

type gb_2 from so_groupbox within w_pln_product_magazine_label_master
integer x = 9
integer y = 436
integer width = 1207
integer height = 352
integer taborder = 40
long textcolor = 16711680
string text = "Worker Information"
end type

