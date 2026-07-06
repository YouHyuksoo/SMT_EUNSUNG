HA$PBExportHeader$w_qc_led_inspect_condition_master.srw
$PBExportComments$Line Master
forward
global type w_qc_led_inspect_condition_master from w_main_root
end type
type st_mrm_no from statictext within w_qc_led_inspect_condition_master
end type
type sle_model_name from so_singlelineedit within w_qc_led_inspect_condition_master
end type
type gb_1 from so_groupbox within w_qc_led_inspect_condition_master
end type
end forward

global type w_qc_led_inspect_condition_master from w_main_root
integer width = 4571
integer height = 2748
string title = "QC INSPECTION CONDITION"
st_mrm_no st_mrm_no
sle_model_name sle_model_name
gb_1 gb_1
end type
global w_qc_led_inspect_condition_master w_qc_led_inspect_condition_master

on w_qc_led_inspect_condition_master.create
int iCurrent
call super::create
this.st_mrm_no=create st_mrm_no
this.sle_model_name=create sle_model_name
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_mrm_no
this.Control[iCurrent+2]=this.sle_model_name
this.Control[iCurrent+3]=this.gb_1
end on

on w_qc_led_inspect_condition_master.destroy
call super::destroy
destroy(this.st_mrm_no)
destroy(this.sle_model_name)
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

event ue_data_control;call super::ue_data_control;Long ROW
STRING LVS_SETYN
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		     dw_1.reset()
			dw_1.RETRIEVE(  sle_model_name.text+'%' ,GVI_ORGANIZATION_ID )
			dw_1.SETFOCUS()
				
	CASE 'INSERT'
	
			row = dw_1.insertrow(dw_1.getrow())
			dw_1.scrolltorow(row)
			f_set_security_row(dw_1 , row , 'ALL')
			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
	CASE 'APPEND'
	
			row = dw_1.insertrow(0)
			dw_1.scrolltorow(row)
			f_set_security_row(dw_1 , row , 'ALL')
			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )	
	CASE 'DELETE'
		
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
			
	CASE 'UPDATE'
		
		dw_1.ACCEPTTEXT()
 
	      IF dw_1.UPDATE() < 0 THEN
				ROLLBACK;
				RETURN
		ELSE
				 COMMIT;
       			 F_MSG_MDI_HELP ( F_MSG_ST(170)	 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
		END IF

	CASE ELSE
END CHOOSE


end event

type dw_5 from w_main_root`dw_5 within w_qc_led_inspect_condition_master
integer y = 316
end type

type dw_4 from w_main_root`dw_4 within w_qc_led_inspect_condition_master
integer y = 316
end type

type dw_3 from w_main_root`dw_3 within w_qc_led_inspect_condition_master
integer y = 316
integer width = 4544
integer height = 1388
end type

type dw_2 from w_main_root`dw_2 within w_qc_led_inspect_condition_master
integer y = 316
integer width = 4549
integer height = 828
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_qc_led_inspect_condition_master
integer x = 9
integer y = 320
integer width = 4544
integer height = 2328
boolean titlebar = true
string title = "LED Inspect Condition"
string dataobject = "d_qc_led_inspect_condition_lst"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_qc_led_inspect_condition_master
end type

type st_mrm_no from statictext within w_qc_led_inspect_condition_master
integer x = 69
integer y = 104
integer width = 654
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

type sle_model_name from so_singlelineedit within w_qc_led_inspect_condition_master
integer x = 37
integer y = 200
integer width = 695
integer taborder = 30
boolean bringtotop = true
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

SELECTED_DATA_WINDOW.SETFILTER('')
SELECTED_DATA_WINDOW.FILTER()

LVS_COLUMN = 'MODEL_NAME'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    SELECTED_DATA_WINDOW.SETFILTER('')
    SELECTED_DATA_WINDOW.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
SELECTED_DATA_WINDOW.FILTER()
F_MSG_MDI_HELP( STRING( SELECTED_DATA_WINDOW.ROWCOUNT() ) + " Found" )
end event

event rbuttondown;call super::rbuttondown;OPEN(w_des_set_item_popup)

IF Gst_return.Gvb_return = true then 
	THIS.TEXT = Gst_return.Gvs_return[9] 
END IF 
end event

type gb_1 from so_groupbox within w_qc_led_inspect_condition_master
integer x = 9
integer width = 763
integer height = 304
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

