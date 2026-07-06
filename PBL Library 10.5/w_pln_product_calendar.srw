HA$PBExportHeader$w_pln_product_calendar.srw
$PBExportComments$Line Master
forward
global type w_pln_product_calendar from w_main_root
end type
type st_mrm_no from statictext within w_pln_product_calendar
end type
type sle_model_name from so_singlelineedit within w_pln_product_calendar
end type
type cb_1 from so_commandbutton within w_pln_product_calendar
end type
type rb_year from so_radiobutton within w_pln_product_calendar
end type
type rb_daily from so_radiobutton within w_pln_product_calendar
end type
type rb_1 from so_radiobutton within w_pln_product_calendar
end type
type gb_1 from so_groupbox within w_pln_product_calendar
end type
type gb_2 from so_groupbox within w_pln_product_calendar
end type
end forward

global type w_pln_product_calendar from w_main_root
integer width = 4571
integer height = 2748
string title = "Product Carendar"
st_mrm_no st_mrm_no
sle_model_name sle_model_name
cb_1 cb_1
rb_year rb_year
rb_daily rb_daily
rb_1 rb_1
gb_1 gb_1
gb_2 gb_2
end type
global w_pln_product_calendar w_pln_product_calendar

on w_pln_product_calendar.create
int iCurrent
call super::create
this.st_mrm_no=create st_mrm_no
this.sle_model_name=create sle_model_name
this.cb_1=create cb_1
this.rb_year=create rb_year
this.rb_daily=create rb_daily
this.rb_1=create rb_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_mrm_no
this.Control[iCurrent+2]=this.sle_model_name
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.rb_year
this.Control[iCurrent+5]=this.rb_daily
this.Control[iCurrent+6]=this.rb_1
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.gb_2
end on

on w_pln_product_calendar.destroy
call super::destroy
destroy(this.st_mrm_no)
destroy(this.sle_model_name)
destroy(this.cb_1)
destroy(this.rb_year)
destroy(this.rb_daily)
destroy(this.rb_1)
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

event ue_data_control;call super::ue_data_control;Long ROW
STRING LVS_SETYN
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		
			IF rb_year.CHecked = TRUE THEN 
			
				DW_1.RETRIEVE(  sle_model_name.text+'%' ,GVI_ORGANIZATION_ID )
				DW_1.SETFOCUS()
			
		ELSEIF RB_DAILY.CHECKED = TRUE THEN 
				DW_2.RETRIEVE(  )
				DW_2.SETFOCUS()			
			ELSE
				
				DW_3.RETRIEVE()
			END IF
				
	CASE 'INSERT'
		
			IF  rb_year.CHecked = TRUE THEN 
		
				row = dw_1.insertrow(dw_1.getrow())
				dw_1.scrolltorow(row)
				f_set_security_row(dw_1 , row , 'ALL')
				F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
				
			ELSEIF RB_DAILY.CHECKED = TRUE THEN 
				row = dw_2.insertrow(dw_2.getrow())
				dw_2.scrolltorow(row)
				f_set_security_row(dw_2 , row , 'ALL')
				F_MSG_MDI_HELP ( F_MSG_ST(152)	 )				
				
			ELSE
				row = dw_3.insertrow(dw_3.getrow())
				dw_3.scrolltorow(row)
				f_set_security_row(dw_3 , row , 'ALL')
				F_MSG_MDI_HELP ( F_MSG_ST(152)	 )						
				
			END IF 
	CASE 'APPEND'
	
			IF  rb_year.CHecked = TRUE THEN 
		
				row = dw_1.insertrow(dw_1.getrow())
				dw_1.scrolltorow(row)
				f_set_security_row(dw_1 , row , 'ALL')
				F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
				
			ELSE
				row = dw_2.insertrow(dw_2.getrow())
				dw_2.scrolltorow(row)
				f_set_security_row(dw_2 , row , 'ALL')
				F_MSG_MDI_HELP ( F_MSG_ST(152)	 )				
				
			END IF 
			
	CASE 'DELETE'
		
		
				IF  rb_year.CHecked = TRUE THEN 
				
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
					ELSEIF RB_DAILY.CHECKED = TRUE THEN 
					
					if dw_2.getrow() < 1 then return 
					
							msg =f_msgbox(1003)
							if msg = 1 then
								gvl_row_deleted = dw_2.getrow()			
								dw_2.deleterow(gvl_row_deleted)		
								dw_2.setfocus()
								row = dw_2.getrow()
								dw_2.scrolltorow(row)
								dw_2.setcolumn(1)
							end if		
					
					ELSE
					if dw_3.getrow() < 1 then return 
					
							msg =f_msgbox(1003)
							if msg = 1 then
								gvl_row_deleted = dw_3.getrow()			
								dw_3.deleterow(gvl_row_deleted)		
								dw_3.setfocus()
								row = dw_3.getrow()
								dw_3.scrolltorow(row)
								dw_3.setcolumn(1)
							end if										
						
				END IF 
	CASE 'UPDATE'
		
				DW_1.ACCEPTTEXT()

				IF DW_1.UPDATE() < 0 OR  DW_2.UPDATE() < 0  OR DW_3.UPDATE() < 0 THEN
					ROLLBACK;
				ELSE
					 COMMIT;
					 F_MSG_MDI_HELP ( F_MSG_ST(170)	 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
				END IF

	CASE ELSE
END CHOOSE


end event

type dw_5 from w_main_root`dw_5 within w_pln_product_calendar
integer y = 316
end type

type dw_4 from w_main_root`dw_4 within w_pln_product_calendar
integer y = 316
end type

type dw_3 from w_main_root`dw_3 within w_pln_product_calendar
integer y = 316
integer width = 4174
integer height = 1924
boolean titlebar = true
string dataobject = "d_worktime_range_lst"
end type

type dw_2 from w_main_root`dw_2 within w_pln_product_calendar
integer y = 316
integer width = 4507
integer height = 1988
boolean titlebar = true
string title = "Work Time"
string dataobject = "d_pln_product_work_time_lst"
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_pln_product_calendar
integer y = 316
integer width = 4507
integer height = 1988
boolean titlebar = true
string title = "Calendar"
string dataobject = "d_pln_product_calendar_lst"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_pln_product_calendar
end type

type st_mrm_no from statictext within w_pln_product_calendar
integer x = 1819
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

type sle_model_name from so_singlelineedit within w_pln_product_calendar
integer x = 1787
integer y = 200
integer width = 695
integer taborder = 30
boolean bringtotop = true
end type

type cb_1 from so_commandbutton within w_pln_product_calendar
integer x = 2546
integer y = 108
integer height = 124
integer taborder = 20
boolean bringtotop = true
string text = "Paste Excel"
end type

event clicked;call super::clicked;dw_1.reset()
dw_1.importclipboard( )



end event

type rb_year from so_radiobutton within w_pln_product_calendar
integer x = 128
integer y = 76
boolean bringtotop = true
string text = "Year"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1
end event

type rb_daily from so_radiobutton within w_pln_product_calendar
integer x = 128
integer y = 184
boolean bringtotop = true
string text = "Daily Time"
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
selected_data_window = dw_2
end event

type rb_1 from so_radiobutton within w_pln_product_calendar
integer x = 873
integer y = 72
boolean bringtotop = true
string text = "Time Zone"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3
end event

type gb_1 from so_groupbox within w_pln_product_calendar
integer width = 1463
integer height = 304
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_pln_product_calendar
integer x = 1760
integer width = 1385
integer height = 304
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

