HA$PBExportHeader$w_pln_product_model_st_master.srw
$PBExportComments$Line Master
forward
global type w_pln_product_model_st_master from w_main_root
end type
type st_line_code from statictext within w_pln_product_model_st_master
end type
type ddlb_line_code from uo_line_code within w_pln_product_model_st_master
end type
type sle_model_name from so_singlelineedit within w_pln_product_model_st_master
end type
type st_mrm_no from statictext within w_pln_product_model_st_master
end type
type cb_1 from so_commandbutton within w_pln_product_model_st_master
end type
type cb_2 from so_commandbutton within w_pln_product_model_st_master
end type
type cb_3 from so_commandbutton within w_pln_product_model_st_master
end type
type cb_4 from so_commandbutton within w_pln_product_model_st_master
end type
type gb_1 from so_groupbox within w_pln_product_model_st_master
end type
end forward

global type w_pln_product_model_st_master from w_main_root
integer width = 5509
integer height = 2748
string title = "Product ST Master"
st_line_code st_line_code
ddlb_line_code ddlb_line_code
sle_model_name sle_model_name
st_mrm_no st_mrm_no
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
cb_4 cb_4
gb_1 gb_1
end type
global w_pln_product_model_st_master w_pln_product_model_st_master

on w_pln_product_model_st_master.create
int iCurrent
call super::create
this.st_line_code=create st_line_code
this.ddlb_line_code=create ddlb_line_code
this.sle_model_name=create sle_model_name
this.st_mrm_no=create st_mrm_no
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.cb_4=create cb_4
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_line_code
this.Control[iCurrent+2]=this.ddlb_line_code
this.Control[iCurrent+3]=this.sle_model_name
this.Control[iCurrent+4]=this.st_mrm_no
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.cb_3
this.Control[iCurrent+8]=this.cb_4
this.Control[iCurrent+9]=this.gb_1
end on

on w_pln_product_model_st_master.destroy
call super::destroy
destroy(this.st_line_code)
destroy(this.ddlb_line_code)
destroy(this.sle_model_name)
destroy(this.st_mrm_no)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.cb_4)
destroy(this.gb_1)
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

end event

event ue_data_control;call super::ue_data_control;long row
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
			dw_1.retrieve( ddlb_line_code.getcode() + '%',   sle_model_name.text+'%' , gvi_organization_id)
			dw_1.setfocus()
			
	case 'INSERT'		
			f_set_column_initial_value( dw_1, dw_1.getrow() , 'ALL' )
	case 'APPEND'		
			f_set_column_initial_value( dw_1, 0 , 'ALL' )
	case 'DELETE'
		
		  	if dw_1.getrow() < 1 then return 
			  
			msg =f_msgbox(1003)
			if msg = 1 then
				gvl_row_deleted = dw_1.getrow()			
				dw_1.deleterow(gvl_row_deleted)		
				dw_1.setfocus()
				row = dw_1.getrow()
				dw_1.scrolltorow(row)
				dw_1.setcolumn(1)
			end if
			
	case 'UPDATE'
		
			if dw_1.update() < 0 then
				rollback;
			else
				commit;
				f_msg_mdi_help(f_msg_st(170))
			end if
			
	case else
end choose


end event

type dw_5 from w_main_root`dw_5 within w_pln_product_model_st_master
integer y = 316
end type

type dw_4 from w_main_root`dw_4 within w_pln_product_model_st_master
integer y = 316
end type

type dw_3 from w_main_root`dw_3 within w_pln_product_model_st_master
integer y = 316
integer width = 4544
end type

type dw_2 from w_main_root`dw_2 within w_pln_product_model_st_master
integer y = 316
integer width = 4549
integer height = 1196
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_pln_product_model_st_master
integer y = 316
integer width = 4544
integer height = 2328
boolean titlebar = true
string title = "Model ST List"
string dataobject = "d_pln_product_model_st_lst"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_pln_product_model_st_master
end type

type st_line_code from statictext within w_pln_product_model_st_master
integer x = 69
integer y = 104
integer width = 631
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Line Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_line_code from uo_line_code within w_pln_product_model_st_master
integer x = 69
integer y = 184
integer taborder = 20
boolean bringtotop = true
end type

type sle_model_name from so_singlelineedit within w_pln_product_model_st_master
integer x = 718
integer y = 184
integer width = 603
integer taborder = 40
boolean bringtotop = true
end type

type st_mrm_no from statictext within w_pln_product_model_st_master
integer x = 718
integer y = 92
integer width = 603
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Model Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_1 from so_commandbutton within w_pln_product_model_st_master
integer x = 1339
integer y = 176
integer height = 88
integer taborder = 20
boolean bringtotop = true
string text = "Generate"
end type

event clicked;call super::clicked;STRING LVS_LINE_CODE,   LVS_PCB_ITEM 
DECIMAL   LVF_ASSY_ST  , LVF_PRODUCT_ST

LVS_LINE_CODE = DDLB_line_code.TExt 
LVS_PCB_ITEM = '*' 

LVF_ASSY_ST = 0
LVF_PRODUCT_ST = 0 

  INSERT INTO "IP_PRODUCT_MODEL_ST_MASTER"  
         ( "MODEL_NAME",   
           "LINE_CODE",   
           "PCB_ITEM",   
           "ASSY_ST",   
           "PRODUCT_ST",   
           "ENTER_BY",   
           "ENTER_DATE",   
           "LAST_MODIFY_BY",   
           "LAST_MODIFY_DATE",   
           "ORGANIZATION_ID" )  
  SELECT  "MODEL_NAME",   
			:LVS_LINE_CODE,   
			:LVS_PCB_ITEM ,
			:LVF_ASSY_ST  ,
			:LVF_PRODUCT_ST,
			"ENTER_BY",   
			"ENTER_DATE",   
			"LAST_MODIFY_BY",   
			"LAST_MODIFY_DATE",   
			"ORGANIZATION_ID"
	 FROM IP_PRODUCT_MODEL_MASTER
   WHERE  MODEL_NAME   NOT IN ( SELECT MODEL_NAME  FROM IP_PRODUCT_MODEL_ST_MASTER )  ;
	
IF F_SQL_CHECK() < 0 THEN 
	RETURN 
END IF 
COMMIT ;
  

end event

type cb_2 from so_commandbutton within w_pln_product_model_st_master
integer x = 1947
integer y = 112
integer height = 124
integer taborder = 20
boolean bringtotop = true
string text = "Paste"
end type

event clicked;call super::clicked;long i 

dw_1.importclipboard( )

do
	i++
	
	f_set_security_row( dw_1, i , 'ALL')

loop until i = dw_1.rowcount( )
end event

type cb_3 from so_commandbutton within w_pln_product_model_st_master
integer x = 2487
integer y = 112
integer height = 124
integer taborder = 30
boolean bringtotop = true
string text = "Create Top All"
end type

event clicked;call super::clicked;STRING LVS_LINE_CODE
LVS_LINE_CODE = ddlb_line_code.GETCODE()
  INSERT INTO IP_PRODUCT_MODEL_ST_MASTER  
         ( MODEL_NAME,   
           LINE_CODE,   
           PCB_ITEM,   
           ASSY_ST,   
           PRODUCT_ST,   
           ENTER_BY,   
           ENTER_DATE,   
           LAST_MODIFY_BY,   
           LAST_MODIFY_DATE,   
           ORGANIZATION_ID,   
           WORKSTAGE_CODE )
SELECT  A.MODEL_NAME,   
           B.LINE_CODE,   
           'T' PCB_ITEM,   
           0 ASSY_ST,   
           0 PRODUCT_ST,   
           A.ENTER_BY,   
           A.ENTER_DATE,   
           A.LAST_MODIFY_BY,   
           A.LAST_MODIFY_DATE,   
           A.ORGANIZATION_ID,   
           '*' WORKSTAGE_CODE  			 
 FROM IP_PRODUCT_MODEL_MASTER A , IP_PRODUCT_LINE  B
 WHERE B.LINE_CODE LIKE :LVS_LINE_CODE ;
 
 IF F_SQL_CHECK() < 0 THEN 
	RETURN 
END IF 

COMMIT ; 
 
end event

type cb_4 from so_commandbutton within w_pln_product_model_st_master
integer x = 3026
integer y = 116
integer height = 124
integer taborder = 40
boolean bringtotop = true
string text = "Create Bttom All"
end type

event clicked;call super::clicked;STRING LVS_LINE_CODE
LVS_LINE_CODE = ddlb_line_code.GETCODE()
  INSERT INTO IP_PRODUCT_MODEL_ST_MASTER  
         ( MODEL_NAME,   
           LINE_CODE,   
           PCB_ITEM,   
           ASSY_ST,   
           PRODUCT_ST,   
           ENTER_BY,   
           ENTER_DATE,   
           LAST_MODIFY_BY,   
           LAST_MODIFY_DATE,   
           ORGANIZATION_ID,   
           WORKSTAGE_CODE )
SELECT  A.MODEL_NAME,   
           B.LINE_CODE,   
           'B' PCB_ITEM,   
           0 ASSY_ST,   
           0 PRODUCT_ST,   
           A.ENTER_BY,   
           A.ENTER_DATE,   
           A.LAST_MODIFY_BY,   
           A.LAST_MODIFY_DATE,   
           A.ORGANIZATION_ID,   
           '*' WORKSTAGE_CODE  			 
 FROM IP_PRODUCT_MODEL_MASTER A , IP_PRODUCT_LINE  B
 WHERE B.LINE_CODE LIKE :LVS_LINE_CODE ;
 
 IF F_SQL_CHECK() < 0 THEN 
	RETURN 
END IF 

COMMIT ; 
 
 
end event

type gb_1 from so_groupbox within w_pln_product_model_st_master
integer x = 9
integer width = 1893
integer height = 304
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

