HA$PBExportHeader$w_menu_master.srw
$PBExportComments$Dynamic Menu Manager
forward
global type w_menu_master from w_main_root
end type
type cb_extract_menu from commandbutton within w_menu_master
end type
type st_1 from statictext within w_menu_master
end type
type cb_apply from commandbutton within w_menu_master
end type
type rb_all from radiobutton within w_menu_master
end type
type rb_visible_y from radiobutton within w_menu_master
end type
type rb_visible_n from radiobutton within w_menu_master
end type
type ddlb_menu_id from uo_basecode within w_menu_master
end type
type gb_1 from so_groupbox within w_menu_master
end type
type gb_2 from so_groupbox within w_menu_master
end type
end forward

global type w_menu_master from w_main_root
integer width = 5010
integer height = 3956
string title = "Dual Language"
cb_extract_menu cb_extract_menu
st_1 st_1
cb_apply cb_apply
rb_all rb_all
rb_visible_y rb_visible_y
rb_visible_n rb_visible_n
ddlb_menu_id ddlb_menu_id
gb_1 gb_1
gb_2 gb_2
end type
global w_menu_master w_menu_master

on w_menu_master.create
int iCurrent
call super::create
this.cb_extract_menu=create cb_extract_menu
this.st_1=create st_1
this.cb_apply=create cb_apply
this.rb_all=create rb_all
this.rb_visible_y=create rb_visible_y
this.rb_visible_n=create rb_visible_n
this.ddlb_menu_id=create ddlb_menu_id
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_extract_menu
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_apply
this.Control[iCurrent+4]=this.rb_all
this.Control[iCurrent+5]=this.rb_visible_y
this.Control[iCurrent+6]=this.rb_visible_n
this.Control[iCurrent+7]=this.ddlb_menu_id
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.gb_2
end on

on w_menu_master.destroy
call super::destroy
destroy(this.cb_extract_menu)
destroy(this.st_1)
destroy(this.cb_apply)
destroy(this.rb_all)
destroy(this.rb_visible_y)
destroy(this.rb_visible_n)
destroy(this.ddlb_menu_id)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event activate;call super::activate;/***************************************
* $$HEX17$$08c7c4b324c115c8d0c5200000ad5cd52000acc06dd544c720004bc105d35cd5e4b2$$ENDHEX$$
*
*
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20051101'
Gst_set.last_modify_date = '20051101'
Gst_set.Report_window    = False  // Report Window  True / Flase

/*****************************************
* Data WIndow Property
******************************************/
Ivs_resize_type    = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

/****************************************
* Menu Property $$HEX6$$54ba74b2200078d5e4b4c1b9$$ENDHEX$$
*****************************************
* ADMIN     : ADMIN  ( $$HEX5$$04c8b4ccacc0a9c62000$$ENDHEX$$)
* $$HEX8$$00adacb9200020002000200020002000$$ENDHEX$$: MANAGE ( $$HEX8$$04c854ba74b2acc0a9c600aca5b22000$$ENDHEX$$)
* $$HEX7$$acc0a9c690c72000200020002000$$ENDHEX$$: GUEST  ( $$HEX11$$30ae08cd2000f1b45db8200070c88cd6200000aca5b2$$ENDHEX$$)
* $$HEX8$$70c88cd6200020002000200020002000$$ENDHEX$$: QUERY  ( $$HEX10$$15c8f4bc70c88cd6ccb9200000aca5b220002000$$ENDHEX$$)
* $$HEX5$$70b374c7c0d070c891c7$$ENDHEX$$: DATA_CONTROL  ( $$HEX12$$85c725b8200018c215c82000adc01cc8200024c115c82000$$ENDHEX$$)
* $$HEX7$$08b8ecd3b8d22000200020002000$$ENDHEX$$: REPORT ( $$HEX4$$08b8ecd3b8d22000$$ENDHEX$$, $$HEX5$$9ccd25b800adacb92000$$ENDHEX$$)
****************************************/

F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control

/****************************************
* 
****************************************/

end event

event ue_data_control;call super::ue_data_control;Long ROW
String lvs_visible_yn
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		
		     if rb_all.checked = true then 
				lvs_visible_yn = '%'
			elseif rb_visible_y.checked = true then 
				lvs_visible_yn = 'Y%'
				
			elseif rb_visible_n.checked = true then 
				lvs_visible_yn = 'N%'
			end if
				
			DW_1.RETRIEVE( ddlb_menu_id.getcode()+'%' , lvs_visible_yn ,Gvi_organization_id )
               DW_1.SETFOCUS()
			
	CASE 'INSERT'
		
			ROW = DW_1.INSERTROW(DW_1.GETROW())
			DW_1.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_1 , ROW , 'ALL')
			
	CASE 'APPEND'
		
			ROW = DW_1.INSERTROW(0)
			DW_1.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_1 , ROW , 'ALL')	
			
	CASE 'DELETE'
			if DW_1.AcceptText() = -1 then
				return
			end if
			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
				Gvl_row_deleted = DW_1.GetRow()			
				DW_1.DELETEROW(Gvl_row_deleted)		
				DW_1.SetFocus()
				ROW = DW_1.GetRow()
				DW_1.ScrollToRow(row)
				DW_1.SetColumn(1)
			END IF
						
	CASE 'UPDATE'
		
          	IF DW_1.UPDATE() < 0 THEN
				ROLLBACK;
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( "Update Complete" ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			END IF
			
			
			
	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_menu_master
integer y = 292
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_menu_master
integer y = 292
integer taborder = 50
end type

type dw_3 from w_main_root`dw_3 within w_menu_master
integer y = 292
integer taborder = 60
end type

type dw_2 from w_main_root`dw_2 within w_menu_master
integer y = 292
integer taborder = 70
end type

type dw_1 from w_main_root`dw_1 within w_menu_master
integer y = 292
integer width = 4507
integer height = 2216
integer taborder = 0
boolean titlebar = true
string title = "Menu List"
string dataobject = "d_dynamic_menu"
end type

type cb_extract_menu from commandbutton within w_menu_master
integer x = 1806
integer y = 124
integer width = 599
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Extract Menu"
end type

event clicked;Gvi_menu_order = 0 ; Gvi_menu_level = 0 ; Gvi_menu_index = 0

//if Gvs_language <> 'E' then 
//	f_msgbox(101)
//	return
//end if

MSG = F_MSGBOX1( 1161 , THIS.TEXT )
IF MSG = 1 THEN 
ELSE
	RETURN
END IF

open(w_progress_popup)

w_progress_popup.f_set_range( 0 ,  upperbound(W_MAIN_FRAME.menuid .item[]) )
w_progress_popup.f_setstep(1)

f_get_dynamic_menu( W_MAIN_FRAME.menuid  ,W_MAIN_FRAME.menuid )

Close(w_progress_popup)

MSG = F_MSGBOX( 1170 )
IF MSG = 1 THEN 
	COMMIT ;
ELSE
	ROLLBACK ;
END IF ;
end event

type st_1 from statictext within w_menu_master
integer x = 50
integer y = 64
integer width = 1157
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Menu List"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_apply from commandbutton within w_menu_master
integer x = 2405
integer y = 124
integer width = 498
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Apply"
end type

event clicked;if dw_1.modifiedcount() > 0 or dw_1.deletedcount() > 0 then 
	f_update()
else
	
end if 

gds_menu.retrieve(gvi_organization_id)	
if gds_menu.rowcount() < 1 then 
	Messagebox("Notify" , "Menu Data Not Found")	
	Return
end if
f_dual_lang_change_menu( w_main_frame.menuid )
end event

type rb_all from radiobutton within w_menu_master
integer x = 1262
integer y = 48
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "All"
boolean checked = true
end type

event clicked;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
SELECTED_DATA_WINDOW.SETFILTER('')
SELECTED_DATA_WINDOW.FILTER()
end event

type rb_visible_y from radiobutton within w_menu_master
integer x = 1262
integer y = 124
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Visible = Y"
end type

event clicked;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN = "MENU_VISIBLE_YN"

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

SELECTED_DATA_WINDOW.SETFILTER('')
SELECTED_DATA_WINDOW.FILTER()
LVS_VALUE = '%Y%'
SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
SELECTED_DATA_WINDOW.FILTER()

end event

type rb_visible_n from radiobutton within w_menu_master
integer x = 1262
integer y = 200
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Visible = N"
end type

event clicked;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN = "MENU_VISIBLE_YN"

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

SELECTED_DATA_WINDOW.SETFILTER('')
SELECTED_DATA_WINDOW.FILTER()

LVS_VALUE = '%N%'
SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
SELECTED_DATA_WINDOW.FILTER()

end event

type ddlb_menu_id from uo_basecode within w_menu_master
integer x = 91
integer y = 152
integer width = 1138
integer taborder = 20
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'SYSTEM MENU ID')
end event

type gb_1 from so_groupbox within w_menu_master
integer x = 1778
integer width = 1157
integer height = 288
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_menu_master
integer width = 1755
integer height = 288
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

