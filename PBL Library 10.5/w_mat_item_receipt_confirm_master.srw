HA$PBExportHeader$w_mat_item_receipt_confirm_master.srw
$PBExportComments$Shipping Receipt Confirm Master
forward
global type w_mat_item_receipt_confirm_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mat_item_receipt_confirm_master
end type
type uo_dateend from uo_ymd_calendar within w_mat_item_receipt_confirm_master
end type
type st_2 from so_statictext within w_mat_item_receipt_confirm_master
end type
type st_3 from so_statictext within w_mat_item_receipt_confirm_master
end type
type cb_confirm from so_commandbutton within w_mat_item_receipt_confirm_master
end type
type cb_cancel from so_commandbutton within w_mat_item_receipt_confirm_master
end type
type rb_confirm from so_radiobutton within w_mat_item_receipt_confirm_master
end type
type rb_cancel from so_radiobutton within w_mat_item_receipt_confirm_master
end type
type st_invoice_no from so_statictext within w_mat_item_receipt_confirm_master
end type
type sle_invoice_no from so_singlelineedit within w_mat_item_receipt_confirm_master
end type
type st_5 from so_statictext within w_mat_item_receipt_confirm_master
end type
type ddlb_location_code from uo_basecode within w_mat_item_receipt_confirm_master
end type
type ddlb_item_code from uo_item_code within w_mat_item_receipt_confirm_master
end type
type gb_1 from so_groupbox within w_mat_item_receipt_confirm_master
end type
type gb_2 from so_groupbox within w_mat_item_receipt_confirm_master
end type
type gb_3 from so_groupbox within w_mat_item_receipt_confirm_master
end type
type gb_4 from so_groupbox within w_mat_item_receipt_confirm_master
end type
end forward

global type w_mat_item_receipt_confirm_master from w_main_root
integer width = 4608
integer height = 2852
string title = "Shipping Receipt Confirm Master"
uo_dateset uo_dateset
uo_dateend uo_dateend
st_2 st_2
st_3 st_3
cb_confirm cb_confirm
cb_cancel cb_cancel
rb_confirm rb_confirm
rb_cancel rb_cancel
st_invoice_no st_invoice_no
sle_invoice_no sle_invoice_no
st_5 st_5
ddlb_location_code ddlb_location_code
ddlb_item_code ddlb_item_code
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
end type
global w_mat_item_receipt_confirm_master w_mat_item_receipt_confirm_master

on w_mat_item_receipt_confirm_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_2=create st_2
this.st_3=create st_3
this.cb_confirm=create cb_confirm
this.cb_cancel=create cb_cancel
this.rb_confirm=create rb_confirm
this.rb_cancel=create rb_cancel
this.st_invoice_no=create st_invoice_no
this.sle_invoice_no=create sle_invoice_no
this.st_5=create st_5
this.ddlb_location_code=create ddlb_location_code
this.ddlb_item_code=create ddlb_item_code
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.cb_confirm
this.Control[iCurrent+6]=this.cb_cancel
this.Control[iCurrent+7]=this.rb_confirm
this.Control[iCurrent+8]=this.rb_cancel
this.Control[iCurrent+9]=this.st_invoice_no
this.Control[iCurrent+10]=this.sle_invoice_no
this.Control[iCurrent+11]=this.st_5
this.Control[iCurrent+12]=this.ddlb_location_code
this.Control[iCurrent+13]=this.ddlb_item_code
this.Control[iCurrent+14]=this.gb_1
this.Control[iCurrent+15]=this.gb_2
this.Control[iCurrent+16]=this.gb_3
this.Control[iCurrent+17]=this.gb_4
end on

on w_mat_item_receipt_confirm_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.cb_confirm)
destroy(this.cb_cancel)
destroy(this.rb_confirm)
destroy(this.rb_cancel)
destroy(this.st_invoice_no)
destroy(this.sle_invoice_no)
destroy(this.st_5)
destroy(this.ddlb_location_code)
destroy(this.ddlb_item_code)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
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
F_MENU_CONTROL('DATA_CONTROL' , FALSE)  // All Data Control




end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

event ue_data_control;call super::ue_data_control;long row
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		     if rb_confirm.checked = true then 
				dw_1.retrieve( uo_dateset.text(), uo_dateend.text(), ddlb_item_code.text() + '%', sle_invoice_no.text+ '%' , ddlb_location_code.getcode() + '%' ,  gvi_organization_id)
				dw_1.setfocus()
			else
				dw_2.retrieve( uo_dateset.text(), uo_dateend.text(), ddlb_item_code.text() + '%', sle_invoice_no.text+ '%' , ddlb_location_code.getcode() + '%' , gvi_organization_id)
				dw_2.setfocus()
			end if
			
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

type dw_5 from w_main_root`dw_5 within w_mat_item_receipt_confirm_master
integer y = 316
end type

type dw_4 from w_main_root`dw_4 within w_mat_item_receipt_confirm_master
integer y = 316
end type

type dw_3 from w_main_root`dw_3 within w_mat_item_receipt_confirm_master
integer y = 608
integer width = 4544
integer height = 1388
end type

type dw_2 from w_main_root`dw_2 within w_mat_item_receipt_confirm_master
integer y = 316
integer width = 4544
integer height = 2428
boolean titlebar = true
string title = "Material Receipt Confirm Cancel Master"
string dataobject = "d_mat_item_receipt_confirm_cancel_lst"
boolean minbox = true
boolean hsplitscroll = false
end type

type dw_1 from w_main_root`dw_1 within w_mat_item_receipt_confirm_master
integer y = 316
integer width = 4544
integer height = 2428
boolean titlebar = true
string title = "Material Receipt Confirm Master"
string dataobject = "d_mat_item_receipt_confirm_lst"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_mat_item_receipt_confirm_master
end type

type uo_dateset from uo_ymd_calendar within w_mat_item_receipt_confirm_master
event destroy ( )
integer x = 1029
integer y = 160
integer taborder = 60
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_item_receipt_confirm_master
event destroy ( )
integer x = 1431
integer y = 160
integer taborder = 70
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_2 from so_statictext within w_mat_item_receipt_confirm_master
integer x = 1029
integer y = 96
integer width = 818
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Receipt Date"
end type

type st_3 from so_statictext within w_mat_item_receipt_confirm_master
integer x = 1833
integer y = 96
integer width = 480
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type cb_confirm from so_commandbutton within w_mat_item_receipt_confirm_master
integer x = 3497
integer y = 136
integer width = 384
integer height = 112
integer taborder = 90
boolean bringtotop = true
string text = "Confirm"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 
if dw_1.rowcount() < 1 then return 
long i , j 
for i = 1 to dw_1.rowcount() 
	if dw_1.object.check_yn[i] = 'Y' then 
		dw_1.object.confirm_yn[i] = 'Y'
		dw_1.object.confirm_date[i] = f_t_sysdate()
		dw_1.object.confirm_by[i] = gvs_user_id
	end if 
	j++
next
if j > 0 then 
	if dw_1.update() < 0 then 
		rollback ; 
		f_msg_mdi_help( "Update Error!" )
	else
		commit ; 
		f_msg_mdi_help("Update Success!" )
		f_retrieve()
	end if 
end if 

end event

type cb_cancel from so_commandbutton within w_mat_item_receipt_confirm_master
integer x = 3877
integer y = 136
integer width = 384
integer height = 112
integer taborder = 100
boolean bringtotop = true
boolean enabled = false
string text = "Cancel"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 
if dw_2.rowcount() < 1 then return 
long i , j 
datetime lvdt_date
setnull(lvdt_date)
for i = 1 to dw_2.rowcount() 
	if dw_2.object.check_yn[i] = 'Y' then 
		dw_2.object.confirm_yn[i] = 'N'
		dw_2.object.confirm_date[i] = lvdt_date
		dw_2.object.confirm_by[i] = ''
	end if 
	j++
next
if j > 0 then 
	if dw_2.update() < 0 then 
		rollback ; 
		f_msg_mdi_help( "Update Error!" )
	else
		commit ; 
		f_msg_mdi_help("Update Success!" )
		f_retrieve()
	end if 
end if 

end event

type rb_confirm from so_radiobutton within w_mat_item_receipt_confirm_master
integer x = 46
integer y = 96
integer width = 855
boolean bringtotop = true
integer weight = 700
string text = "Item Receipt Confirm List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
selected_data_window = dw_1
cb_confirm.enabled = true 
cb_cancel.enabled = false


end event

type rb_cancel from so_radiobutton within w_mat_item_receipt_confirm_master
integer x = 46
integer y = 200
integer width = 855
boolean bringtotop = true
integer weight = 700
string text = "Item Receipt Cancel List"
end type

event clicked;call super::clicked;dw_2.bringtotop = true
selected_data_window = dw_2
cb_confirm.enabled = false 
cb_cancel.enabled = true
end event

type st_invoice_no from so_statictext within w_mat_item_receipt_confirm_master
integer x = 2903
integer y = 88
integer width = 494
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Invoice No"
end type

type sle_invoice_no from so_singlelineedit within w_mat_item_receipt_confirm_master
integer x = 2912
integer y = 164
integer width = 494
integer height = 84
integer taborder = 90
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

event modified;call super::modified;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

DW_3.SETFILTER('')
DW_3.FILTER()

LVS_COLUMN = 'RECEIPT_LOT_NO'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    DW_3.SETFILTER('')
    DW_3.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

DW_3.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
DW_3.FILTER()
F_MSG_MDI_HELP( STRING( DW_3.ROWCOUNT() ) + " Found" )
end event

type st_5 from so_statictext within w_mat_item_receipt_confirm_master
integer x = 2391
integer y = 92
integer width = 512
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Location Code"
end type

type ddlb_location_code from uo_basecode within w_mat_item_receipt_confirm_master
integer x = 2391
integer y = 168
integer width = 512
integer taborder = 80
boolean bringtotop = true
boolean allowedit = false
end type

event constructor;call super::constructor;this.redraw( 'MATERIAL LOCATION CODE')
end event

type ddlb_item_code from uo_item_code within w_mat_item_receipt_confirm_master
integer x = 1851
integer y = 164
integer taborder = 20
boolean bringtotop = true
end type

type gb_1 from so_groupbox within w_mat_item_receipt_confirm_master
integer x = 965
integer width = 2450
integer height = 304
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_mat_item_receipt_confirm_master
integer width = 969
integer height = 304
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_3 from so_groupbox within w_mat_item_receipt_confirm_master
integer x = 9
integer y = 656
integer width = 1445
integer height = 304
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_4 from so_groupbox within w_mat_item_receipt_confirm_master
integer x = 3424
integer y = 8
integer width = 896
integer height = 304
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

