HA$PBExportHeader$w_com_interlock_inspect_condition_master.srw
$PBExportComments$Line Master
forward
global type w_com_interlock_inspect_condition_master from w_main_root
end type
type st_line_code from statictext within w_com_interlock_inspect_condition_master
end type
type ddlb_line_code from uo_line_code within w_com_interlock_inspect_condition_master
end type
type cb_1 from so_commandbutton within w_com_interlock_inspect_condition_master
end type
type ddlb_from_line_code from uo_line_code within w_com_interlock_inspect_condition_master
end type
type ddlb_to_line_code from uo_line_code within w_com_interlock_inspect_condition_master
end type
type st_1 from statictext within w_com_interlock_inspect_condition_master
end type
type st_2 from statictext within w_com_interlock_inspect_condition_master
end type
type gb_1 from so_groupbox within w_com_interlock_inspect_condition_master
end type
type gb_2 from so_groupbox within w_com_interlock_inspect_condition_master
end type
end forward

global type w_com_interlock_inspect_condition_master from w_main_root
integer width = 4571
integer height = 2748
string title = "Interlock Inspect Condition Master"
st_line_code st_line_code
ddlb_line_code ddlb_line_code
cb_1 cb_1
ddlb_from_line_code ddlb_from_line_code
ddlb_to_line_code ddlb_to_line_code
st_1 st_1
st_2 st_2
gb_1 gb_1
gb_2 gb_2
end type
global w_com_interlock_inspect_condition_master w_com_interlock_inspect_condition_master

on w_com_interlock_inspect_condition_master.create
int iCurrent
call super::create
this.st_line_code=create st_line_code
this.ddlb_line_code=create ddlb_line_code
this.cb_1=create cb_1
this.ddlb_from_line_code=create ddlb_from_line_code
this.ddlb_to_line_code=create ddlb_to_line_code
this.st_1=create st_1
this.st_2=create st_2
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_line_code
this.Control[iCurrent+2]=this.ddlb_line_code
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.ddlb_from_line_code
this.Control[iCurrent+5]=this.ddlb_to_line_code
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.gb_2
end on

on w_com_interlock_inspect_condition_master.destroy
call super::destroy
destroy(this.st_line_code)
destroy(this.ddlb_line_code)
destroy(this.cb_1)
destroy(this.ddlb_from_line_code)
destroy(this.ddlb_to_line_code)
destroy(this.st_1)
destroy(this.st_2)
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

end event

event ue_data_control;call super::ue_data_control;long row
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
			dw_1.retrieve( ddlb_line_code.getcode() + '%', gvi_organization_id)
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

type dw_5 from w_main_root`dw_5 within w_com_interlock_inspect_condition_master
integer y = 316
end type

type dw_4 from w_main_root`dw_4 within w_com_interlock_inspect_condition_master
integer y = 316
end type

type dw_3 from w_main_root`dw_3 within w_com_interlock_inspect_condition_master
integer y = 316
integer width = 4544
integer height = 1388
end type

type dw_2 from w_main_root`dw_2 within w_com_interlock_inspect_condition_master
integer y = 316
integer width = 4549
integer height = 828
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_com_interlock_inspect_condition_master
integer x = 9
integer y = 320
integer width = 4544
integer height = 2328
boolean titlebar = true
string dataobject = "d_com_interlock_inspect_condition_lst"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_com_interlock_inspect_condition_master
end type

type st_line_code from statictext within w_com_interlock_inspect_condition_master
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

type ddlb_line_code from uo_line_code within w_com_interlock_inspect_condition_master
integer x = 69
integer y = 184
integer taborder = 20
boolean bringtotop = true
end type

type cb_1 from so_commandbutton within w_com_interlock_inspect_condition_master
integer x = 2272
integer y = 120
integer height = 108
integer taborder = 20
boolean bringtotop = true
string text = "Copy"
end type

event clicked;call super::clicked;STRING lvs_from_line_code , lvs_to_line_code

lvs_from_line_code = ddlb_from_line_code.text()
lvs_to_line_code = ddlb_to_line_code.text()

  INSERT INTO "IQ_INTERLOCK_CHECK_CONDITION"  
         ( "LINE_CODE",   
           "WORKSTAGE_CODE",   
           "MACHINE_CODE",   
           "INTERLOCK_CHECK_TYPE",   
           "CHECK_LIMT_TIME",   
           "ENTER_DATE",   
           "ENTER_BY",   
           "LAST_MODIFY_DATE",   
           "LAST_MODIFY_BY",   
           "ORGANIZATION_ID",   
           "CHECK_SEQUENCE",   
           "ITEM_CODE" )  
     SELECT :lvs_to_line_code ,
            "IQ_INTERLOCK_CHECK_CONDITION"."WORKSTAGE_CODE",   
            "IQ_INTERLOCK_CHECK_CONDITION"."MACHINE_CODE",   
            "IQ_INTERLOCK_CHECK_CONDITION"."INTERLOCK_CHECK_TYPE",   
            "IQ_INTERLOCK_CHECK_CONDITION"."CHECK_LIMT_TIME",   
            "IQ_INTERLOCK_CHECK_CONDITION"."ENTER_DATE",   
            "IQ_INTERLOCK_CHECK_CONDITION"."ENTER_BY",   
            "IQ_INTERLOCK_CHECK_CONDITION"."LAST_MODIFY_DATE",   
            "IQ_INTERLOCK_CHECK_CONDITION"."LAST_MODIFY_BY",   
            "IQ_INTERLOCK_CHECK_CONDITION"."ORGANIZATION_ID",   
            "IQ_INTERLOCK_CHECK_CONDITION"."CHECK_SEQUENCE",   
            "IQ_INTERLOCK_CHECK_CONDITION"."ITEM_CODE"  
       FROM "IQ_INTERLOCK_CHECK_CONDITION"
   WHERE LINE_CODE = :lvs_from_line_code 
	   AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
		
		IF F_SQL_CHECK() < 0 THEN 
			RETURN 
		END IF 
		
COMMIT ;
F_MSGBOX(170)
end event

type ddlb_from_line_code from uo_line_code within w_com_interlock_inspect_condition_master
integer x = 882
integer y = 184
integer height = 1744
integer taborder = 30
boolean bringtotop = true
end type

type ddlb_to_line_code from uo_line_code within w_com_interlock_inspect_condition_master
integer x = 1545
integer y = 184
integer height = 1744
integer taborder = 40
boolean bringtotop = true
end type

type st_1 from statictext within w_com_interlock_inspect_condition_master
integer x = 882
integer y = 100
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
string text = "From Line Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_com_interlock_inspect_condition_master
integer x = 1545
integer y = 96
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
string text = "To Line Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from so_groupbox within w_com_interlock_inspect_condition_master
integer x = 809
integer width = 2021
integer height = 304
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_com_interlock_inspect_condition_master
integer x = 9
integer width = 786
integer height = 304
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

