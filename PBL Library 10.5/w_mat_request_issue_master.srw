HA$PBExportHeader$w_mat_request_issue_master.srw
$PBExportComments$Material Request Issue Master
forward
global type w_mat_request_issue_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mat_request_issue_master
end type
type uo_dateend from uo_ymd_calendar within w_mat_request_issue_master
end type
type ddlb_item_code from uo_item_code within w_mat_request_issue_master
end type
type st_3 from so_statictext within w_mat_request_issue_master
end type
type st_4 from so_statictext within w_mat_request_issue_master
end type
type rb_purchase from so_radiobutton within w_mat_request_issue_master
end type
type rb_departure from so_radiobutton within w_mat_request_issue_master
end type
type cb_set from so_commandbutton within w_mat_request_issue_master
end type
type ddlb_location_code from uo_basecode within w_mat_request_issue_master
end type
type st_5 from so_statictext within w_mat_request_issue_master
end type
type gb_1 from so_groupbox within w_mat_request_issue_master
end type
type gb_2 from so_groupbox within w_mat_request_issue_master
end type
type gb_3 from so_groupbox within w_mat_request_issue_master
end type
end forward

global type w_mat_request_issue_master from w_main_root
integer width = 4768
integer height = 2532
string title = "Material Request Issue Master"
uo_dateset uo_dateset
uo_dateend uo_dateend
ddlb_item_code ddlb_item_code
st_3 st_3
st_4 st_4
rb_purchase rb_purchase
rb_departure rb_departure
cb_set cb_set
ddlb_location_code ddlb_location_code
st_5 st_5
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_mat_request_issue_master w_mat_request_issue_master

type variables

end variables

on w_mat_request_issue_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.ddlb_item_code=create ddlb_item_code
this.st_3=create st_3
this.st_4=create st_4
this.rb_purchase=create rb_purchase
this.rb_departure=create rb_departure
this.cb_set=create cb_set
this.ddlb_location_code=create ddlb_location_code
this.st_5=create st_5
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.ddlb_item_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.rb_purchase
this.Control[iCurrent+7]=this.rb_departure
this.Control[iCurrent+8]=this.cb_set
this.Control[iCurrent+9]=this.ddlb_location_code
this.Control[iCurrent+10]=this.st_5
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.gb_2
this.Control[iCurrent+13]=this.gb_3
end on

on w_mat_request_issue_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.ddlb_item_code)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.rb_purchase)
destroy(this.rb_departure)
destroy(this.cb_set)
destroy(this.ddlb_location_code)
destroy(this.st_5)
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
Ivs_resize_type                      = 'MASTER_DETAIL_135_24'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


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
F_MENU_CONTROL('DATA_CONTROL_MODIFY' ,TRUE)  // All Data Control





end event

event ue_post_open;call super::ue_post_open;

/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
uo_dateset.settext(string(f_t_sysdate(), 'yyyy/mm')+'/01')
end event

event ue_data_control;call super::ue_data_control;long row
string lvs_date
double lvd_seq
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
			dw_1.reset()
			dw_2.reset()
			dw_3.reset()
			if    rb_purchase.checked   then 
			    dw_1.retrieve(  uo_dateset.text() , uo_dateend.text(), ddlb_item_code.text() + '%',   gvi_organization_id)
			else
				dw_3.retrieve( uo_dateset.text() , uo_dateend.text(),  ddlb_item_code.text() + '%',   gvi_organization_id)
			end if 
			

		
		
	case 'UPDATE'
		
			if dw_2.rowcount() <  1 then return 
			
			msg = f_msgbox(1170)
			if msg = 1 then 
			else 
				return 
			end if 
			
			if dw_1.update() < 0  or dw_2.update() < 0 then 
				rollback ; 
				f_msg_mdi_help(f_msg_st(9026))
			else
				commit ; 
				f_msg_mdi_help(f_msg_st(170))
				f_retrieve()
			end if 
		     
	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mat_request_issue_master
integer y = 292
end type

type dw_4 from w_main_root`dw_4 within w_mat_request_issue_master
integer y = 292
boolean hscrollbar = false
boolean vscrollbar = false
end type

type dw_3 from w_main_root`dw_3 within w_mat_request_issue_master
integer y = 292
integer width = 4544
integer height = 1356
boolean titlebar = true
string title = "Material Issue List"
string dataobject = "d_mat_issue_4_request_issue_lst"
end type

type dw_2 from w_main_root`dw_2 within w_mat_request_issue_master
integer y = 1652
integer width = 4549
integer height = 672
string dataobject = "d_mat_issue_batch"
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_2::rbuttondown;call super::rbuttondown;if dwo.name = 'supplier_code' then 	
	open(w_com_supplier_popup)
	if message.stringparm = '' then 
	else
		this.object.supplier_code[row] = message.stringparm
		this.trigger event itemchanged(row, this.object.supplier_code, this.object.supplier_code[row])
	end if 
	
end if 
end event

type dw_1 from w_main_root`dw_1 within w_mat_request_issue_master
integer y = 292
integer width = 4544
integer height = 1356
boolean titlebar = true
string title = "Material Request List"
string dataobject = "d_mat_issue_request_4_issue_lst"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_mat_request_issue_master
end type

type uo_dateset from uo_ymd_calendar within w_mat_request_issue_master
event destroy ( )
integer x = 759
integer y = 160
integer taborder = 30
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_request_issue_master
event destroy ( )
integer x = 1175
integer y = 160
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_item_code from uo_item_code within w_mat_request_issue_master
integer x = 1595
integer y = 160
integer width = 672
integer taborder = 20
boolean bringtotop = true
end type

type st_3 from so_statictext within w_mat_request_issue_master
integer x = 1595
integer y = 80
integer width = 672
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type st_4 from so_statictext within w_mat_request_issue_master
integer x = 763
integer y = 80
integer width = 814
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Issue Request Date"
end type

type rb_purchase from so_radiobutton within w_mat_request_issue_master
integer x = 59
integer y = 84
integer width = 631
boolean bringtotop = true
integer weight = 700
string text = "Issue Request List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1

cb_set.enabled = true


end event

type rb_departure from so_radiobutton within w_mat_request_issue_master
integer x = 59
integer y = 176
integer width = 558
boolean bringtotop = true
integer weight = 700
string text = "Issue History"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3

cb_set.enabled = false

end event

type cb_set from so_commandbutton within w_mat_request_issue_master
integer x = 2885
integer y = 128
integer width = 581
integer height = 120
integer taborder = 30
boolean bringtotop = true
string text = "Batch Issue"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 
if dw_1.rowcount() < 1 then return 
long n = 1  , i = 1  ,lvl_issue_seq

string  lvs_location_code, lvs_item_type, lvs_supplier_code
Decimal lvd_inventory_price, lvl_inventory_qty , lvf_issue_qty , lvf_issue_price , lvf_request_qty ,lvf_issue_remain_qty

dw_1.accepttext()
msg = f_msgbox1(1161,this.text)
if msg = 1 then 
else 
	return 
end if 

lvs_location_code = ddlb_location_code.getcode()

for i = 1 to dw_1.rowcount()
	if dw_1.object.check_yn[i] =  'Y'  then 
	else 
		continue 
	end if 	
	n = dw_2.insertrow(0)
	dw_2.scrolltorow(n)
	f_set_security_row(dw_2, n, 'ALL')
	dw_2.object.issue_date[n] = f_t_sysdate()	
	lvl_issue_seq = long(f_get_sequence('seq_mat_issue'))
	dw_2.object.issue_sequence[n] = lvl_issue_seq
	
     
	dw_2.object.item_code[n] = dw_1.object.item_code[i]
	
	lvs_item_type = f_get_item_type_from_item(   dw_1.object.item_code[i]  ) 	
	dw_2.object.item_type[n]  = lvs_item_type
	dw_2.object.line_type[n]   = dw_1.object.line_type[i]
	
	dw_2.object.item_name[n] = dw_1.object.item_name[i]
	dw_2.object.item_spec[n] = dw_1.object.item_spec[i]
	dw_2.object.item_uom[n] = dw_1.object.item_uom[i]	
	
	dw_2.object.material_mfs[n] = dw_1.object.material_mfs[i]
	dw_2.object.workstage_code[n] = dw_1.object.workstage_code[i]
	dw_2.object.issue_deficit[n] = '3'
	
	lvf_request_qty = dw_1.object.request_qty[i]	
	lvf_issue_qty = dw_1.object.issue_qty[i]
	lvf_issue_remain_qty = dw_1.object.issue_remain_qty[i]
	dw_2.object.issue_qty[n] = lvf_issue_remain_qty

	dw_2.object.mfs[n] = dw_1.object.mfs[i]	
	dw_2.object.line_code[n] = dw_1.object.line_code[i]
	dw_2.object.issue_type[n] = 'R'
	dw_2.object.issue_status[n] = 'N'
	dw_2.object.issue_account[n] = dw_1.object.issue_account[i]
	dw_2.object.location_code[n] = lvs_location_code
	
	
	dw_2.object.work_order_no[n] = string( F_GET_SEQUENCE( 'SEQ_WORK_ORDER_NO'))
	dw_1.object.issue_date[i] = f_t_sysdate()

	if  lvf_request_qty = lvf_issue_qty + lvf_issue_remain_qty then 
		dw_1.object.issue_qty[i] = dw_1.object.issue_qty[i] + lvf_issue_remain_qty
		dw_1.object.request_status[i] = 'C'  //COMPLETED
	else
		dw_1.object.issue_qty[i] = dw_1.object.issue_qty[i] + lvf_issue_remain_qty
	end if
//===================================================
// $$HEX9$$9ccde0ace8b200ac200000ac38c824c630ae$$ENDHEX$$
//===================================================
	lvf_issue_price = f_get_item_inventory_price(dw_1.object.item_code[i] , dw_1.object.line_type[i] ,dw_1.object.material_mfs[i]  )
	if lvf_issue_price <= 0 then 
		Return
	end if 
	
	dw_2.object.issue_price[n] = lvf_issue_price
	dw_2.object.issue_amt[n]  = lvf_issue_price * lvf_issue_remain_qty


next



end event

type ddlb_location_code from uo_basecode within w_mat_request_issue_master
integer x = 2277
integer y = 160
integer width = 489
integer taborder = 50
boolean bringtotop = true
boolean allowedit = false
end type

event constructor;call super::constructor;this.redraw( 'MATERIAL LOCATION CODE')
end event

type st_5 from so_statictext within w_mat_request_issue_master
integer x = 2277
integer y = 84
integer width = 489
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Location Code"
end type

type gb_1 from so_groupbox within w_mat_request_issue_master
integer x = 9
integer width = 699
integer height = 284
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_mat_request_issue_master
integer x = 718
integer width = 2066
integer height = 284
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_mat_request_issue_master
integer x = 2839
integer width = 654
integer height = 284
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

