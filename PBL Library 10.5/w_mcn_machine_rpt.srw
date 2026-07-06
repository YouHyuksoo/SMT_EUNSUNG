HA$PBExportHeader$w_mcn_machine_rpt.srw
forward
global type w_mcn_machine_rpt from w_main_root
end type
type sle_machine_name from so_singlelineedit within w_mcn_machine_rpt
end type
type st_1 from so_statictext within w_mcn_machine_rpt
end type
type st_2 from so_statictext within w_mcn_machine_rpt
end type
type rb_machine_list from so_radiobutton within w_mcn_machine_rpt
end type
type rb_operation from so_radiobutton within w_mcn_machine_rpt
end type
type st_4 from so_statictext within w_mcn_machine_rpt
end type
type uo_dateset from uo_ymd_calendar within w_mcn_machine_rpt
end type
type uo_dateend from uo_ymd_calendar within w_mcn_machine_rpt
end type
type rb_machine_card from so_radiobutton within w_mcn_machine_rpt
end type
type rb_barcode from so_radiobutton within w_mcn_machine_rpt
end type
type ddlb_machine_type from uo_basecode within w_mcn_machine_rpt
end type
type st_3 from so_statictext within w_mcn_machine_rpt
end type
type ddlb_machine_code from uo_machine_code within w_mcn_machine_rpt
end type
type gb_where_condition from groupbox within w_mcn_machine_rpt
end type
type gb_1 from so_groupbox within w_mcn_machine_rpt
end type
end forward

global type w_mcn_machine_rpt from w_main_root
integer width = 5083
integer height = 2796
string title = "Machine Report"
sle_machine_name sle_machine_name
st_1 st_1
st_2 st_2
rb_machine_list rb_machine_list
rb_operation rb_operation
st_4 st_4
uo_dateset uo_dateset
uo_dateend uo_dateend
rb_machine_card rb_machine_card
rb_barcode rb_barcode
ddlb_machine_type ddlb_machine_type
st_3 st_3
ddlb_machine_code ddlb_machine_code
gb_where_condition gb_where_condition
gb_1 gb_1
end type
global w_mcn_machine_rpt w_mcn_machine_rpt

type variables

end variables

on w_mcn_machine_rpt.create
int iCurrent
call super::create
this.sle_machine_name=create sle_machine_name
this.st_1=create st_1
this.st_2=create st_2
this.rb_machine_list=create rb_machine_list
this.rb_operation=create rb_operation
this.st_4=create st_4
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.rb_machine_card=create rb_machine_card
this.rb_barcode=create rb_barcode
this.ddlb_machine_type=create ddlb_machine_type
this.st_3=create st_3
this.ddlb_machine_code=create ddlb_machine_code
this.gb_where_condition=create gb_where_condition
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_machine_name
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.rb_machine_list
this.Control[iCurrent+5]=this.rb_operation
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.uo_dateset
this.Control[iCurrent+8]=this.uo_dateend
this.Control[iCurrent+9]=this.rb_machine_card
this.Control[iCurrent+10]=this.rb_barcode
this.Control[iCurrent+11]=this.ddlb_machine_type
this.Control[iCurrent+12]=this.st_3
this.Control[iCurrent+13]=this.ddlb_machine_code
this.Control[iCurrent+14]=this.gb_where_condition
this.Control[iCurrent+15]=this.gb_1
end on

on w_mcn_machine_rpt.destroy
call super::destroy
destroy(this.sle_machine_name)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.rb_machine_list)
destroy(this.rb_operation)
destroy(this.st_4)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.rb_machine_card)
destroy(this.rb_barcode)
destroy(this.ddlb_machine_type)
destroy(this.st_3)
destroy(this.ddlb_machine_code)
destroy(this.gb_where_condition)
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
/*****************************************
* Data Window Property
******************************************/
Ivs_resize_type                      = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


/*****************************************
* Data Window Property
******************************************/
ivs_dw_1_use_focusindicator = 'N' //Focus Indicator Show / Hide Property
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
F_MENU_CONTROL('REPORT' , True)  // All Data Control





end event

event ue_data_control;call super::ue_data_control;Long ROW
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		if rb_machine_list.checked = true then 
			dw_1.retrieve(  ddlb_machine_code.getcode()+'%' ,ddlb_machine_type.getcode( )+'%' , gvi_organization_id )
			dw_1.setfocus()
		elseif rb_operation.checked = true then 
			dw_2.retrieve(  ddlb_machine_code.getcode()+'%' ,ddlb_machine_type.getcode( )+'%' , uo_dateset.text() , uo_dateend.text() , gvi_organization_id )
			dw_2.setfocus()			
		elseif rb_machine_card.checked = true then 
			dw_3.retrieve( ddlb_machine_code.getcode()+'%' ,ddlb_machine_type.getcode( )+'%' ,  gvi_organization_id )
			dw_3.setfocus()	
	
		else
			dw_5.retrieve( ddlb_machine_type.getcode( )+'%' ,  gvi_organization_id )
			dw_5.setfocus()				
		end if
	CASE ELSE
END CHOOSE
end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_mcn_machine_rpt
integer y = 316
integer width = 4507
integer height = 2120
boolean titlebar = true
string dataobject = "d_mcn_machine_barcode_rpt"
end type

type dw_4 from w_main_root`dw_4 within w_mcn_machine_rpt
integer y = 316
integer width = 4507
integer height = 2120
boolean titlebar = true
end type

type dw_3 from w_main_root`dw_3 within w_mcn_machine_rpt
integer y = 316
integer width = 4507
integer height = 2120
boolean titlebar = true
string dataobject = "d_mcn_machine_card_rpt"
end type

event dw_3::rowfocuschanged;call super::rowfocuschanged;string lvs_filename

if currentrow < 1 then return
this.object.p_image.filename = ''
lvs_filename = f_download_machine_rtn_filename( this.object.machine_code[currentrow] )

this.object.p_image.filename = lvs_filename
end event

type dw_2 from w_main_root`dw_2 within w_mcn_machine_rpt
integer y = 316
integer width = 4507
integer height = 2120
integer taborder = 0
boolean titlebar = true
string dataobject = "d_mcn_daily_operation_rpt"
end type

type dw_1 from w_main_root`dw_1 within w_mcn_machine_rpt
integer y = 316
integer width = 4507
integer height = 2120
integer taborder = 0
boolean titlebar = true
string title = "Machine List"
string dataobject = "d_mcn_machine_rpt"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_mcn_machine_rpt
end type

type sle_machine_name from so_singlelineedit within w_mcn_machine_rpt
integer x = 2405
integer y = 172
integer width = 640
integer height = 84
integer taborder = 10
boolean bringtotop = true
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

SELECTED_DATA_WINDOW.SETFILTER('')
SELECTED_DATA_WINDOW.FILTER()

LVS_COLUMN = 'MACHINE_NAME'
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

type st_1 from so_statictext within w_mcn_machine_rpt
integer x = 1563
integer y = 92
integer width = 837
boolean bringtotop = true
integer weight = 700
string text = "Machine Code"
end type

type st_2 from so_statictext within w_mcn_machine_rpt
integer x = 2405
integer y = 92
integer width = 640
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Machine Name"
end type

type rb_machine_list from so_radiobutton within w_mcn_machine_rpt
integer x = 105
integer y = 72
integer width = 581
boolean bringtotop = true
integer weight = 700
string text = "Machine List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
selected_data_window = dw_1

end event

type rb_operation from so_radiobutton within w_mcn_machine_rpt
integer x = 105
integer y = 168
integer width = 581
boolean bringtotop = true
integer weight = 700
string text = "Daily Operation"
end type

event clicked;call super::clicked;dw_2.bringtotop = true
selected_data_window = dw_2

end event

type st_4 from so_statictext within w_mcn_machine_rpt
integer x = 3058
integer y = 88
integer width = 814
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Plan Date"
end type

type uo_dateset from uo_ymd_calendar within w_mcn_machine_rpt
event destroy ( )
integer x = 3054
integer y = 168
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mcn_machine_rpt
event destroy ( )
integer x = 3470
integer y = 168
integer taborder = 60
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type rb_machine_card from so_radiobutton within w_mcn_machine_rpt
integer x = 763
integer y = 72
integer width = 581
boolean bringtotop = true
integer weight = 700
string text = "Machine Card"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3
end event

type rb_barcode from so_radiobutton within w_mcn_machine_rpt
integer x = 759
integer y = 168
integer width = 672
boolean bringtotop = true
integer weight = 700
string text = "Machine Barcode"
end type

event clicked;call super::clicked;dw_5.bringtotop = true
selected_data_window = dw_5
end event

type ddlb_machine_type from uo_basecode within w_mcn_machine_rpt
integer x = 3913
integer y = 168
integer width = 695
integer height = 896
integer taborder = 20
boolean bringtotop = true
boolean hscrollbar = true
end type

event constructor;call super::constructor;this.redraw( 'MACHINE TYPE')
end event

type st_3 from so_statictext within w_mcn_machine_rpt
integer x = 3886
integer y = 84
integer width = 571
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Machine Type"
end type

type ddlb_machine_code from uo_machine_code within w_mcn_machine_rpt
integer x = 1563
integer y = 172
integer width = 837
integer height = 1928
integer taborder = 20
boolean bringtotop = true
end type

type gb_where_condition from groupbox within w_mcn_machine_rpt
integer x = 1536
integer width = 3145
integer height = 304
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Where Condition"
end type

type gb_1 from so_groupbox within w_mcn_machine_rpt
integer width = 1513
integer height = 304
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

