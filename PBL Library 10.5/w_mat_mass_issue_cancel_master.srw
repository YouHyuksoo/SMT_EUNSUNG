HA$PBExportHeader$w_mat_mass_issue_cancel_master.srw
$PBExportComments$Material Mass Issue Master
forward
global type w_mat_mass_issue_cancel_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mat_mass_issue_cancel_master
end type
type uo_dateend from uo_ymd_calendar within w_mat_mass_issue_cancel_master
end type
type st_4 from so_statictext within w_mat_mass_issue_cancel_master
end type
type rb_issue_cancel from so_radiobutton within w_mat_mass_issue_cancel_master
end type
type rb_departure from so_radiobutton within w_mat_mass_issue_cancel_master
end type
type cb_set from so_commandbutton within w_mat_mass_issue_cancel_master
end type
type st_1 from so_statictext within w_mat_mass_issue_cancel_master
end type
type st_2 from so_statictext within w_mat_mass_issue_cancel_master
end type
type ddlb_mfs from uo_mfs_workorder within w_mat_mass_issue_cancel_master
end type
type ddlb_workstage_code from uo_workstage_code_all within w_mat_mass_issue_cancel_master
end type
type ddlb_item_code from uo_item_code within w_mat_mass_issue_cancel_master
end type
type st_5 from so_statictext within w_mat_mass_issue_cancel_master
end type
type uo_cancel_date from uo_ymd_calendar within w_mat_mass_issue_cancel_master
end type
type st_7 from so_statictext within w_mat_mass_issue_cancel_master
end type
type cbx_allow_last_mm_cancel from so_checkbox within w_mat_mass_issue_cancel_master
end type
type ddlb_line_code from uo_line_code within w_mat_mass_issue_cancel_master
end type
type st_8 from so_statictext within w_mat_mass_issue_cancel_master
end type
type sle_invoice_no from so_singlelineedit within w_mat_mass_issue_cancel_master
end type
type st_14 from so_statictext within w_mat_mass_issue_cancel_master
end type
type sle_material_mfs from so_singlelineedit within w_mat_mass_issue_cancel_master
end type
type st_3 from so_statictext within w_mat_mass_issue_cancel_master
end type
type ddlb_location_code from uo_basecode within w_mat_mass_issue_cancel_master
end type
type st_9 from so_statictext within w_mat_mass_issue_cancel_master
end type
type pb_1 from so_commandbutton within w_mat_mass_issue_cancel_master
end type
type ddlb_change_location from uo_basecode within w_mat_mass_issue_cancel_master
end type
type st_10 from so_statictext within w_mat_mass_issue_cancel_master
end type
type gb_1 from so_groupbox within w_mat_mass_issue_cancel_master
end type
type gb_2 from so_groupbox within w_mat_mass_issue_cancel_master
end type
type gb_3 from so_groupbox within w_mat_mass_issue_cancel_master
end type
end forward

global type w_mat_mass_issue_cancel_master from w_main_root
integer width = 5591
integer height = 2964
string title = "Material Issue Cancel Master"
uo_dateset uo_dateset
uo_dateend uo_dateend
st_4 st_4
rb_issue_cancel rb_issue_cancel
rb_departure rb_departure
cb_set cb_set
st_1 st_1
st_2 st_2
ddlb_mfs ddlb_mfs
ddlb_workstage_code ddlb_workstage_code
ddlb_item_code ddlb_item_code
st_5 st_5
uo_cancel_date uo_cancel_date
st_7 st_7
cbx_allow_last_mm_cancel cbx_allow_last_mm_cancel
ddlb_line_code ddlb_line_code
st_8 st_8
sle_invoice_no sle_invoice_no
st_14 st_14
sle_material_mfs sle_material_mfs
st_3 st_3
ddlb_location_code ddlb_location_code
st_9 st_9
pb_1 pb_1
ddlb_change_location ddlb_change_location
st_10 st_10
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_mat_mass_issue_cancel_master w_mat_mass_issue_cancel_master

on w_mat_mass_issue_cancel_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_4=create st_4
this.rb_issue_cancel=create rb_issue_cancel
this.rb_departure=create rb_departure
this.cb_set=create cb_set
this.st_1=create st_1
this.st_2=create st_2
this.ddlb_mfs=create ddlb_mfs
this.ddlb_workstage_code=create ddlb_workstage_code
this.ddlb_item_code=create ddlb_item_code
this.st_5=create st_5
this.uo_cancel_date=create uo_cancel_date
this.st_7=create st_7
this.cbx_allow_last_mm_cancel=create cbx_allow_last_mm_cancel
this.ddlb_line_code=create ddlb_line_code
this.st_8=create st_8
this.sle_invoice_no=create sle_invoice_no
this.st_14=create st_14
this.sle_material_mfs=create sle_material_mfs
this.st_3=create st_3
this.ddlb_location_code=create ddlb_location_code
this.st_9=create st_9
this.pb_1=create pb_1
this.ddlb_change_location=create ddlb_change_location
this.st_10=create st_10
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.rb_issue_cancel
this.Control[iCurrent+5]=this.rb_departure
this.Control[iCurrent+6]=this.cb_set
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.ddlb_mfs
this.Control[iCurrent+10]=this.ddlb_workstage_code
this.Control[iCurrent+11]=this.ddlb_item_code
this.Control[iCurrent+12]=this.st_5
this.Control[iCurrent+13]=this.uo_cancel_date
this.Control[iCurrent+14]=this.st_7
this.Control[iCurrent+15]=this.cbx_allow_last_mm_cancel
this.Control[iCurrent+16]=this.ddlb_line_code
this.Control[iCurrent+17]=this.st_8
this.Control[iCurrent+18]=this.sle_invoice_no
this.Control[iCurrent+19]=this.st_14
this.Control[iCurrent+20]=this.sle_material_mfs
this.Control[iCurrent+21]=this.st_3
this.Control[iCurrent+22]=this.ddlb_location_code
this.Control[iCurrent+23]=this.st_9
this.Control[iCurrent+24]=this.pb_1
this.Control[iCurrent+25]=this.ddlb_change_location
this.Control[iCurrent+26]=this.st_10
this.Control[iCurrent+27]=this.gb_1
this.Control[iCurrent+28]=this.gb_2
this.Control[iCurrent+29]=this.gb_3
end on

on w_mat_mass_issue_cancel_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_4)
destroy(this.rb_issue_cancel)
destroy(this.rb_departure)
destroy(this.cb_set)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.ddlb_mfs)
destroy(this.ddlb_workstage_code)
destroy(this.ddlb_item_code)
destroy(this.st_5)
destroy(this.uo_cancel_date)
destroy(this.st_7)
destroy(this.cbx_allow_last_mm_cancel)
destroy(this.ddlb_line_code)
destroy(this.st_8)
destroy(this.sle_invoice_no)
destroy(this.st_14)
destroy(this.sle_material_mfs)
destroy(this.st_3)
destroy(this.ddlb_location_code)
destroy(this.st_9)
destroy(this.pb_1)
destroy(this.ddlb_change_location)
destroy(this.st_10)
destroy(this.gb_1)
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
* Menu Property 
*****************************************
* ADMIN  ( All Control )
* MANAGE ( Manager )
* GUEST  ( Only Query )
* QUERY  ( Only Query  )
* DATA_CONTROL  ( Insert Delete Update )
* REPORT ( Report )
****************************************/
F_MENU_CONTROL('DATA_CONTROL' , FALSE)  // All Data Control





end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
//uo_dateset.settext(string(f_t_sysdate(), 'yyyy/mm')+'/01')
end event

event ue_data_control;call super::ue_data_control;long row
string lvs_date
double lvd_seq
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
			dw_1.reset()
			if  rb_issue_cancel.checked   then 
			    dw_1.retrieve(  uo_dateset.text() , uo_dateend.text(),  ddlb_line_code.getcode()+'%'  ,  ddlb_mfs.text+'%' , ddlb_workstage_code.getcode()+'%' , ddlb_item_code.text + '%', '%' , sle_invoice_no.text+'%' ,  sle_material_mfs.text+'%' , ddlb_location_code.getcode()+'%' , gvi_organization_id)
			else
				dw_2.reset()
				dw_2.retrieve( uo_dateset.text() , uo_dateend.text(),ddlb_line_code.getcode()+'%' ,  ddlb_mfs.text+'%' , ddlb_workstage_code.getcode()+'%' , ddlb_item_code.text + '%', '%' , gvi_organization_id)
			end if 
	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mat_mass_issue_cancel_master
integer y = 536
end type

type dw_4 from w_main_root`dw_4 within w_mat_mass_issue_cancel_master
integer y = 536
boolean hscrollbar = false
boolean vscrollbar = false
end type

type dw_3 from w_main_root`dw_3 within w_mat_mass_issue_cancel_master
integer y = 536
end type

type dw_2 from w_main_root`dw_2 within w_mat_mass_issue_cancel_master
integer y = 536
integer width = 4544
integer height = 1564
boolean titlebar = true
string title = "Material Issue List"
string dataobject = "d_mat_issue_lst"
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_mat_mass_issue_cancel_master
integer y = 536
integer width = 4544
integer height = 1564
boolean titlebar = true
string title = "Material Issue Cancel List"
string dataobject = "d_mat_issue_cancel_lst"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_mat_mass_issue_cancel_master
end type

type uo_dateset from uo_ymd_calendar within w_mat_mass_issue_cancel_master
event destroy ( )
integer x = 837
integer y = 160
integer taborder = 30
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_mass_issue_cancel_master
event destroy ( )
integer x = 1253
integer y = 160
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_4 from so_statictext within w_mat_mass_issue_cancel_master
integer x = 841
integer y = 80
integer width = 814
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Issue Date"
end type

type rb_issue_cancel from so_radiobutton within w_mat_mass_issue_cancel_master
integer x = 59
integer y = 84
integer width = 631
boolean bringtotop = true
integer weight = 700
string text = "Mass Issue List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1

cb_set.enabled = true

end event

type rb_departure from so_radiobutton within w_mat_mass_issue_cancel_master
integer x = 59
integer y = 184
integer width = 677
boolean bringtotop = true
integer weight = 700
string text = "Mass Issue History List"
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
selected_data_window = dw_2



end event

type cb_set from so_commandbutton within w_mat_mass_issue_cancel_master
integer x = 631
integer y = 364
integer height = 120
integer taborder = 30
boolean bringtotop = true
string text = "Issue Cancel"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 
if dw_1.rowcount() < 1 then return 
long  i , j 
Datetime lvdt_issue_date , lvdt_cancel_date
String lvs_mfs , lvs_inspect_no , lvs_item_code
Double lvdb_work_order_no , lvl_issue_sequence

msg = f_msgbox1(1161,this.text)
if msg = 1 then 
else 
	return 
end if 

lvdt_cancel_date = uo_cancel_date.text()
do
	i++
    if dw_1.object.check_yn[i] = 'Y' then 
    else
		continue
	end if
	
		lvs_mfs = dw_1.object.mfs[i]	
		lvs_item_code  = dw_1.object.item_code[i]
		lvs_inspect_no   = dw_1.object.inspect_no[i]
		
		lvdt_issue_date = dw_1.object.issue_date[i]
		lvl_issue_sequence = dw_1.object.issue_sequence[i]
		lvdb_work_order_no = double(dw_1.object.work_order_no[i])
	
		//========================================
		// $$HEX21$$f9b2d4c674c704c82000e8cd8cc1200000aca5b2ecc580bd200058d6bdacc0bc18c2200080acacc02000$$ENDHEX$$
		// Gvs_allow_last_month_receipt_cancel 
		// $$HEX14$$85c7e0ac20009ccde0ac2000f5acb5d13cc75cb82000acc0a9c62000$$ENDHEX$$
		//========================================
		if  Gvs_allow_last_mm_receipt_cancel= 'Y' then 	
		else
			if  lvdt_issue_date < f_get_first_day() then 
				continue
			end if
		end if	
	
	//=================================================
	// $$HEX37$$88bdc9b720009ccde0ac94b2200088d4c8c958c7200080acacc010d315c8b0acfcac2000d0c5200058c774d520009ccde0ac200018b494b2200083ac74c7c0bb5cb8200074c7f8bb2000$$ENDHEX$$
	// $$HEX33$$80acacc010d304c82000bdcad0c5200044c6ccb820000cd598b7f8ad00ac200024c115c8200018b4b4c5200088c74cc72000f8adecb7c0bb5cb82000e8cd8cc1dcc2$$ENDHEX$$
	// $$HEX20$$0cd598b77cb97cb9200074d51cc8200058d5e0ac20009ccde0ac7cb92000e8cd8cc15cd5e4b22000$$ENDHEX$$
	//=================================================	
	if dw_1.object.issue_account[i] = 'M002' and dw_1.object.inspect_no[i] <> "" then
	
		if f_wqc_complete_cancel( lvs_item_code , lvs_inspect_no , gvi_organization_id )  < 0 then 
			
			Messagebox("Notify" , "WQC Inspect Conplete Cancel Failed")
			rollback;
			return
		end if
	end if 
	
	if f_mat_issue_cancel ( lvs_mfs , lvdt_issue_date ,  lvl_issue_sequence , lvdb_work_order_no , lvdt_cancel_date) < 0 then 
		
	   rollback;
	   return
	end if
	j++
loop until i = dw_1.rowcount()

if j > 0 then 
	commit ;
	f_msgbox(170)
	f_retrieve()
else
	Rollback;
	Return
end if
end event

type st_1 from so_statictext within w_mat_mass_issue_cancel_master
integer x = 3666
integer y = 80
integer width = 430
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "MFS"
end type

type st_2 from so_statictext within w_mat_mass_issue_cancel_master
integer x = 2665
integer y = 80
integer width = 471
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Workstage Code"
end type

type ddlb_mfs from uo_mfs_workorder within w_mat_mass_issue_cancel_master
integer x = 3666
integer y = 156
integer width = 430
integer taborder = 20
boolean bringtotop = true
end type

type ddlb_workstage_code from uo_workstage_code_all within w_mat_mass_issue_cancel_master
integer x = 2665
integer y = 156
integer width = 475
integer taborder = 50
boolean bringtotop = true
end type

type ddlb_item_code from uo_item_code within w_mat_mass_issue_cancel_master
integer x = 1673
integer y = 156
integer width = 498
integer taborder = 60
boolean bringtotop = true
end type

type st_5 from so_statictext within w_mat_mass_issue_cancel_master
integer x = 1664
integer y = 80
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type uo_cancel_date from uo_ymd_calendar within w_mat_mass_issue_cancel_master
integer x = 110
integer y = 420
integer taborder = 50
boolean bringtotop = true
end type

on uo_cancel_date.destroy
call uo_ymd_calendar::destroy
end on

type st_7 from so_statictext within w_mat_mass_issue_cancel_master
integer x = 110
integer y = 356
integer width = 416
integer height = 60
boolean bringtotop = true
string text = "Issue Cancel Date"
end type

type cbx_allow_last_mm_cancel from so_checkbox within w_mat_mass_issue_cancel_master
integer x = 1175
integer y = 380
integer width = 923
boolean bringtotop = true
integer weight = 700
string text = "Allow Last Month Receipt Cancel"
boolean automatic = false
boolean checked = true
end type

event constructor;call super::constructor;if Gvs_allow_last_mm_receipt_cancel = 'Y' then
	this.checked = true
else
	this.checked = false
end if
end event

type ddlb_line_code from uo_line_code within w_mat_mass_issue_cancel_master
integer x = 2176
integer y = 156
integer width = 480
integer height = 2044
integer taborder = 50
boolean bringtotop = true
long backcolor = 12639424
end type

type st_8 from so_statictext within w_mat_mass_issue_cancel_master
integer x = 2176
integer y = 80
integer width = 471
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Line Code"
end type

type sle_invoice_no from so_singlelineedit within w_mat_mass_issue_cancel_master
integer x = 3145
integer y = 156
integer width = 512
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

SELECTED_DATA_WINDOW.SETFILTER('')
SELECTED_DATA_WINDOW.FILTER()

LVS_COLUMN = 'ITEM_NAME'
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

type st_14 from so_statictext within w_mat_mass_issue_cancel_master
integer x = 3145
integer y = 80
integer width = 512
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Invoice No"
end type

type sle_material_mfs from so_singlelineedit within w_mat_mass_issue_cancel_master
integer x = 4101
integer y = 156
integer width = 517
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

type st_3 from so_statictext within w_mat_mass_issue_cancel_master
integer x = 4101
integer y = 80
integer width = 517
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Material MFS"
end type

type ddlb_location_code from uo_basecode within w_mat_mass_issue_cancel_master
integer x = 4626
integer y = 152
integer width = 462
integer taborder = 50
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'MATERIAL LOCATION CODE')
end event

type st_9 from so_statictext within w_mat_mass_issue_cancel_master
integer x = 4626
integer y = 72
integer width = 462
integer height = 76
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Location Code"
end type

type pb_1 from so_commandbutton within w_mat_mass_issue_cancel_master
integer x = 2935
integer y = 364
integer width = 649
integer height = 120
integer taborder = 40
boolean bringtotop = true
string text = "Issue Change Loaction"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 
if dw_1.rowcount() < 1 then return 
long  i , j 
Datetime lvdt_issue_date 
String lvs_mfs , lvs_inspect_no , lvs_item_code , lvs_change_location
Double lvdb_work_order_no , lvl_issue_sequence

lvs_change_location = ddlb_change_location.getcode()
if lvs_change_location = '%' or isnull(lvs_change_location) or lvs_change_location = '' then 
	Messagebox("$$HEX2$$55d678c7$$ENDHEX$$" , "$$HEX17$$c0bcbdac60d520003dcce0ac200054cfdcb47cb9200020c1ddd0200058d538c194c6$$ENDHEX$$" )
	return
end if 

msg = f_msgbox1(1161,this.text)
if msg = 1 then 
else 
	return 
end if 

do
	i++
    if dw_1.object.check_yn[i] = 'Y' then 
    else
		continue
	end if
	
		lvs_mfs = dw_1.object.mfs[i]	
		lvs_item_code  = dw_1.object.item_code[i]
		lvs_inspect_no   = dw_1.object.inspect_no[i]
		
		lvdt_issue_date = dw_1.object.issue_date[i]
		lvl_issue_sequence = dw_1.object.issue_sequence[i]
		lvdb_work_order_no = double(dw_1.object.work_order_no[i])
		
		if f_mat_issue_change_location ( lvdt_issue_date ,  lvl_issue_sequence , lvs_change_location ) < 0 then 		
			rollback;
			return
		end if
	j++
loop until i = dw_1.rowcount()

if j > 0 then 
	commit ;
	f_msgbox(170)
	f_retrieve()
else
	Rollback;
	Return
end if
end event

type ddlb_change_location from uo_basecode within w_mat_mass_issue_cancel_master
integer x = 2437
integer y = 416
integer width = 462
integer taborder = 60
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'MATERIAL LOCATION CODE')
end event

type st_10 from so_statictext within w_mat_mass_issue_cancel_master
integer x = 2437
integer y = 352
integer width = 462
integer height = 52
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Location Code"
end type

type gb_1 from so_groupbox within w_mat_mass_issue_cancel_master
integer x = 9
integer width = 773
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_mat_mass_issue_cancel_master
integer x = 795
integer width = 4315
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_mat_mass_issue_cancel_master
integer y = 308
integer width = 3621
integer height = 212
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

