HA$PBExportHeader$w_pln_workstage_master.srw
$PBExportComments$Line Master
forward
global type w_pln_workstage_master from w_main_root
end type
type st_workstage_code from statictext within w_pln_workstage_master
end type
type st_5 from so_statictext within w_pln_workstage_master
end type
type sle_1 from so_singlelineedit within w_pln_workstage_master
end type
type ddlb_workstage_code from uo_workstage_code_all within w_pln_workstage_master
end type
type st_line_code from statictext within w_pln_workstage_master
end type
type ddlb_line_code from uo_line_code within w_pln_workstage_master
end type
type gb_1 from so_groupbox within w_pln_workstage_master
end type
end forward

global type w_pln_workstage_master from w_main_root
integer width = 4626
integer height = 2852
string title = "Product Workstage Master"
st_workstage_code st_workstage_code
st_5 st_5
sle_1 sle_1
ddlb_workstage_code ddlb_workstage_code
st_line_code st_line_code
ddlb_line_code ddlb_line_code
gb_1 gb_1
end type
global w_pln_workstage_master w_pln_workstage_master

on w_pln_workstage_master.create
int iCurrent
call super::create
this.st_workstage_code=create st_workstage_code
this.st_5=create st_5
this.sle_1=create sle_1
this.ddlb_workstage_code=create ddlb_workstage_code
this.st_line_code=create st_line_code
this.ddlb_line_code=create ddlb_line_code
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_workstage_code
this.Control[iCurrent+2]=this.st_5
this.Control[iCurrent+3]=this.sle_1
this.Control[iCurrent+4]=this.ddlb_workstage_code
this.Control[iCurrent+5]=this.st_line_code
this.Control[iCurrent+6]=this.ddlb_line_code
this.Control[iCurrent+7]=this.gb_1
end on

on w_pln_workstage_master.destroy
call super::destroy
destroy(this.st_workstage_code)
destroy(this.st_5)
destroy(this.sle_1)
destroy(this.ddlb_workstage_code)
destroy(this.st_line_code)
destroy(this.ddlb_line_code)
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
Ivs_resize_type                      = 'MASTER_DETAIL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


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

dw_1.sharedata(dw_2)
end event

event ue_data_control;call super::ue_data_control;long row
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
			dw_1.retrieve( ddlb_line_code.getcode( )+'%' ,  ddlb_workstage_code.text() + '%', gvi_organization_id)
			dw_1.setfocus()
			
	case 'INSERT'		
			f_set_column_initial_value( dw_2, dw_2.getrow() , 'ALL' )
			
	case 'APPEND'		
			f_set_column_initial_value( dw_2, 0 , 'ALL' )
			
	case 'DELETE'
		
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
			
	case 'UPDATE'
		
			if dw_2.update() < 0 then
				rollback;
			else
				commit;
				f_msg_mdi_help(f_msg_st(170))
			end if
			
	case else
end choose
end event

type dw_5 from w_main_root`dw_5 within w_pln_workstage_master
integer y = 316
end type

type dw_4 from w_main_root`dw_4 within w_pln_workstage_master
integer y = 316
end type

type dw_3 from w_main_root`dw_3 within w_pln_workstage_master
boolean visible = false
integer y = 316
boolean enabled = false
boolean maxbox = false
end type

type dw_2 from w_main_root`dw_2 within w_pln_workstage_master
integer y = 1072
integer width = 4539
integer height = 796
string dataobject = "d_pln_workstage_mst"
end type

type dw_1 from w_main_root`dw_1 within w_pln_workstage_master
integer y = 316
integer width = 4544
integer height = 752
boolean titlebar = true
string title = "Workstage List"
string dataobject = "d_pln_workstage_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;dw_2.scrolltorow( currentrow)
end event

type uo_tabpages from w_main_root`uo_tabpages within w_pln_workstage_master
end type

type st_workstage_code from statictext within w_pln_workstage_master
integer x = 727
integer y = 92
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
string text = "Workstage Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_5 from so_statictext within w_pln_workstage_master
integer x = 1362
integer y = 92
integer width = 608
integer height = 68
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
boolean enabled = false
string text = "Workstage Name"
end type

type sle_1 from so_singlelineedit within w_pln_workstage_master
integer x = 1362
integer y = 172
integer width = 608
integer height = 84
integer taborder = 50
boolean bringtotop = true
textcase textcase = upper!
end type

event modified;call super::modified;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

LVS_COLUMN = "WORKSTAGE_NAME"

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

SELECTED_DATA_WINDOW.SETFILTER('')
SELECTED_DATA_WINDOW.FILTER()

IF THIS.TEXT = '' THEN 
	SELECTED_DATA_WINDOW.SETFILTER('')
	SELECTED_DATA_WINDOW.FILTER()
	RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
SELECTED_DATA_WINDOW.FILTER()
F_MSG_MDI_HELP( STRING( SELECTED_DATA_WINDOW.ROWCOUNT() ) + " Found")
end event

type ddlb_workstage_code from uo_workstage_code_all within w_pln_workstage_master
integer x = 727
integer y = 172
integer taborder = 60
boolean bringtotop = true
end type

type st_line_code from statictext within w_pln_workstage_master
integer x = 82
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
string text = "Line Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_line_code from uo_line_code within w_pln_workstage_master
integer x = 82
integer y = 172
integer taborder = 50
boolean bringtotop = true
end type

type gb_1 from so_groupbox within w_pln_workstage_master
integer x = 18
integer width = 2624
integer height = 304
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

