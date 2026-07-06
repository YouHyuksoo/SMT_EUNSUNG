HA$PBExportHeader$w_mat_purchase_order_4_repair_master.srw
forward
global type w_mat_purchase_order_4_repair_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mat_purchase_order_4_repair_master
end type
type uo_dateend from uo_ymd_calendar within w_mat_purchase_order_4_repair_master
end type
type ddlb_item_code from uo_item_code within w_mat_purchase_order_4_repair_master
end type
type st_3 from so_statictext within w_mat_purchase_order_4_repair_master
end type
type st_4 from so_statictext within w_mat_purchase_order_4_repair_master
end type
type cb_batch from so_commandbutton within w_mat_purchase_order_4_repair_master
end type
type cb_preview from so_commandbutton within w_mat_purchase_order_4_repair_master
end type
type cb_print from so_commandbutton within w_mat_purchase_order_4_repair_master
end type
type cbx_dialog from so_checkbox within w_mat_purchase_order_4_repair_master
end type
type em_copy from so_editmask within w_mat_purchase_order_4_repair_master
end type
type st_2 from so_statictext within w_mat_purchase_order_4_repair_master
end type
type ddlb_mfs from uo_mfs_this_month within w_mat_purchase_order_4_repair_master
end type
type st_1 from so_statictext within w_mat_purchase_order_4_repair_master
end type
type cb_1 from so_commandbutton within w_mat_purchase_order_4_repair_master
end type
type rb_all from so_radiobutton within w_mat_purchase_order_4_repair_master
end type
type rb_material from so_radiobutton within w_mat_purchase_order_4_repair_master
end type
type cb_2 from so_commandbutton within w_mat_purchase_order_4_repair_master
end type
type em_level from so_editmask within w_mat_purchase_order_4_repair_master
end type
type rb_level from so_radiobutton within w_mat_purchase_order_4_repair_master
end type
type ddlb_supplier_code from uo_supplier_code within w_mat_purchase_order_4_repair_master
end type
type st_5 from so_statictext within w_mat_purchase_order_4_repair_master
end type
type gb_2 from so_groupbox within w_mat_purchase_order_4_repair_master
end type
type gb_3 from so_groupbox within w_mat_purchase_order_4_repair_master
end type
type gb_6 from so_groupbox within w_mat_purchase_order_4_repair_master
end type
type gb_1 from so_groupbox within w_mat_purchase_order_4_repair_master
end type
type gb_4 from so_groupbox within w_mat_purchase_order_4_repair_master
end type
end forward

global type w_mat_purchase_order_4_repair_master from w_main_root
integer width = 4485
integer height = 2984
string title = "Repair Material Purchase Order Master"
uo_dateset uo_dateset
uo_dateend uo_dateend
ddlb_item_code ddlb_item_code
st_3 st_3
st_4 st_4
cb_batch cb_batch
cb_preview cb_preview
cb_print cb_print
cbx_dialog cbx_dialog
em_copy em_copy
st_2 st_2
ddlb_mfs ddlb_mfs
st_1 st_1
cb_1 cb_1
rb_all rb_all
rb_material rb_material
cb_2 cb_2
em_level em_level
rb_level rb_level
ddlb_supplier_code ddlb_supplier_code
st_5 st_5
gb_2 gb_2
gb_3 gb_3
gb_6 gb_6
gb_1 gb_1
gb_4 gb_4
end type
global w_mat_purchase_order_4_repair_master w_mat_purchase_order_4_repair_master

type variables
string ivs_flag =  'N'
string ivs_preview_yn = 'N' 	
end variables

on w_mat_purchase_order_4_repair_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.ddlb_item_code=create ddlb_item_code
this.st_3=create st_3
this.st_4=create st_4
this.cb_batch=create cb_batch
this.cb_preview=create cb_preview
this.cb_print=create cb_print
this.cbx_dialog=create cbx_dialog
this.em_copy=create em_copy
this.st_2=create st_2
this.ddlb_mfs=create ddlb_mfs
this.st_1=create st_1
this.cb_1=create cb_1
this.rb_all=create rb_all
this.rb_material=create rb_material
this.cb_2=create cb_2
this.em_level=create em_level
this.rb_level=create rb_level
this.ddlb_supplier_code=create ddlb_supplier_code
this.st_5=create st_5
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_6=create gb_6
this.gb_1=create gb_1
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.ddlb_item_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.cb_batch
this.Control[iCurrent+7]=this.cb_preview
this.Control[iCurrent+8]=this.cb_print
this.Control[iCurrent+9]=this.cbx_dialog
this.Control[iCurrent+10]=this.em_copy
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.ddlb_mfs
this.Control[iCurrent+13]=this.st_1
this.Control[iCurrent+14]=this.cb_1
this.Control[iCurrent+15]=this.rb_all
this.Control[iCurrent+16]=this.rb_material
this.Control[iCurrent+17]=this.cb_2
this.Control[iCurrent+18]=this.em_level
this.Control[iCurrent+19]=this.rb_level
this.Control[iCurrent+20]=this.ddlb_supplier_code
this.Control[iCurrent+21]=this.st_5
this.Control[iCurrent+22]=this.gb_2
this.Control[iCurrent+23]=this.gb_3
this.Control[iCurrent+24]=this.gb_6
this.Control[iCurrent+25]=this.gb_1
this.Control[iCurrent+26]=this.gb_4
end on

on w_mat_purchase_order_4_repair_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.ddlb_item_code)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.cb_batch)
destroy(this.cb_preview)
destroy(this.cb_print)
destroy(this.cbx_dialog)
destroy(this.em_copy)
destroy(this.st_2)
destroy(this.ddlb_mfs)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.rb_all)
destroy(this.rb_material)
destroy(this.cb_2)
destroy(this.em_level)
destroy(this.rb_level)
destroy(this.ddlb_supplier_code)
destroy(this.st_5)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_6)
destroy(this.gb_1)
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
Ivs_resize_type                      = 'MASTER_DETAIL_12T_3B'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

ivs_dw_1_deleteselected_yn = 'N'
ivs_dw_2_deleteselected_yn = 'N'
ivs_dw_3_deleteselected_yn = 'Y'
ivs_dw_4_deleteselected_yn = 'N'
ivs_dw_5_deleteselected_yn = 'N'

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
F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control





end event

event ue_post_open;call super::ue_post_open;/****************************************
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
			dw_1.retrieve( uo_dateset.text() , uo_dateend.text(), ddlb_mfs.text+'%' , ddlb_item_code.text+'%' ,  gvi_organization_id)
			
    case 'INSERT'
		
			ROW = DW_3.INSERTROW(DW_3.GETROW())
			DW_3.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_3 , ROW ,'ALL')
			lvd_seq = f_get_sequence('seq_work_order_no')	
			dw_3.object.plan_yyyymm[row] = string(f_t_sysdate(),'yyyymm')
			dw_3.object.work_order_no[row] =string(f_t_sysdate(),'yyyymmdd') + string(lvd_seq,'000')
			dw_3.object.plan_date[row] = f_t_sysdate()
			dw_3.object.issue_type[row] = 'N'
			dw_3.object.issue_division[row] = 'N'
			dw_3.object.issue_account[row] = 'M001'
			dw_3.object.issue_status[row] = 'N'
			dw_3.object.work_order_type[row] = 'M' //$$HEX5$$18c2d9b3ddc031c12000$$ENDHEX$$
			dw_3.object.issue_qty[row] = 0
			dw_3.object.issue_date[row] = f_t_sysdate()
			
	case 'APPEND'					
			ROW = DW_3.INSERTROW(0)
			DW_3.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_3 , ROW ,'ALL')
			lvd_seq = f_get_sequence('seq_work_order_no')	
			dw_3.object.plan_yyyymm[row] = string(f_t_sysdate(),'yyyymm')
			dw_3.object.work_order_no[row] =string(f_t_sysdate(),'yyyymmdd') + string(lvd_seq,'000')
			dw_3.object.plan_date[row] = f_t_sysdate()
			dw_3.object.issue_type[row] = 'N'
			dw_3.object.issue_division[row] = 'N'  // $$HEX11$$ddc0b0c0c4ac8dd6c6c594b291c7c5c5c0c9dcc22000$$ENDHEX$$
			dw_3.object.issue_account[row] = 'M001'
			dw_3.object.issue_status[row] = 'N'
			dw_3.object.work_order_type[row] = 'M'
			dw_3.object.issue_qty[row] = 0
			dw_3.object.issue_date[row] = f_t_sysdate()
	case 'DELETE'		
		  	if DW_3.AcceptText() = -1 then
				return
			end if			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
				Gvl_row_deleted = DW_3.GetRow()			
				DW_3.DELETEROW(Gvl_row_deleted)		
				DW_3.SetFocus()
				ROW = DW_3.GetRow()
				DW_3.ScrollToRow(row)
				DW_3.SetColumn(1)
			END IF		 
   case 'UPDATE'
		
			IF DW_3.UPDATE() < 0  THEN
			  	 ROLLBACK;
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
//				 cb_preview.triggerevent(clicked!)
                   F_RETRIEVE()
			END IF              
	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mat_purchase_order_4_repair_master
integer y = 516
end type

type dw_4 from w_main_root`dw_4 within w_mat_purchase_order_4_repair_master
integer y = 516
integer width = 4439
integer height = 1188
boolean titlebar = true
string dataobject = "d_mat_purchase_order_landscape_4_repair_rpt"
end type

type dw_3 from w_main_root`dw_3 within w_mat_purchase_order_4_repair_master
integer y = 1708
integer width = 4439
integer height = 1164
boolean titlebar = true
string title = "Repair Purchase Order List"
string dataobject = "d_mat_purchase_order_4_repair_mst"
end type

event dw_3::rbuttondown;call super::rbuttondown;if dwo.name = 'item_code' then
	open(w_mat_item_popup)
	if gst_return.gvb_return = false then 
	else
		this.object.item_code[row] = gst_return.gvs_return[1]
		this.object.item_name[row] = gst_return.gvs_return[2]
		this.object.item_spec[row] = gst_return.gvs_return[3]	
		this.object.virtual_receipt_yn[row] = gst_return.gvs_return[8]	
		this.object.item_uom[row] = gst_return.gvs_return[7]	
		this.object.item_type[row] = gst_return.gvs_return[9]	
		this.object.line_type[row] = gst_return.gvs_return[6]		    
		gst_return.gvs_return[1] = ''
		gst_return.gvs_return[2] = ''
		gst_return.gvs_return[3] = ''
		gst_return.gvs_return[6] = ''
		gst_return.gvs_return[7] = ''
		gst_return.gvs_return[8] = ''	
		gst_return.gvs_return[9] = ''		
	end if 
	
end if 

end event

event dw_3::doubleclicked;call super::doubleclicked;if row < 1 then 
	cb_preview.enabled = false
	cb_print.enabled = false
	return 
end if
dw_4.retrieve(this.object.arg_order_group_no[row] , this.object.mfs[row], gvi_organization_id)

if dw_4.rowcount() > 0 then 
   cb_preview.enabled = True
   cb_print.enabled = True
else
   cb_preview.enabled = false
   cb_print.enabled = false
end if
end event

event dw_3::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then 
	cb_preview.enabled = false
	cb_print.enabled = false
	return 
end if
dw_4.retrieve( this.object.order_group_no[currentrow] ,  this.object.mfs[currentrow], gvi_organization_id)

if dw_4.rowcount() > 0 then 
   cb_preview.enabled = True
   cb_print.enabled = True
else

end if
end event

type dw_2 from w_main_root`dw_2 within w_mat_purchase_order_4_repair_master
integer x = 2222
integer y = 512
integer width = 2222
integer height = 1188
boolean titlebar = true
string title = "Repair Material Request List"
string dataobject = "d_pln_work_order_4_repair_lst"
end type

event dw_2::clicked;call super::clicked;if  dwo.name = 'b_resize' then 
	
	this.bringtotop = true
	if dwo.text = '<' then
	
		dw_2.x = dw_3.x
		dw_2.width = dw_3.width
		dwo.text  = '>' 
	else
		
		dw_2.x = dw_1.x + dw_1.width
		dw_2.width = dw_1.width
		dwo.text = '<' 		
	end if
	
	
	
end if
end event

type dw_1 from w_main_root`dw_1 within w_mat_purchase_order_4_repair_master
integer y = 516
integer width = 2222
integer height = 1188
boolean titlebar = true
string title = "Repair Master Plan"
string dataobject = "d_pln_master_plan_4_repair_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
long lvl_session_id 
string lvs_mfs , lvs_item_code

lvs_mfs = dw_1.object.mfs[currentrow]	
setpointer(hourglass!)


dw_2.retrieve( uo_dateset.text() , uo_dateend.text(),  lvs_mfs , '%' ,  gvi_organization_id)		
dw_3.retrieve( uo_dateset.text() , uo_dateend.text(),  lvs_mfs ,  gvi_organization_id)		


end event

event dw_1::doubleclicked;call super::doubleclicked;if row < 1 then return 
long lvl_session_id 
string lvs_mfs , lvs_item_code

lvs_mfs = dw_1.object.mfs[row]	
setpointer(hourglass!)

dw_2.retrieve( uo_dateset.text() , uo_dateend.text(),  lvs_mfs , '%' ,  gvi_organization_id)		
dw_3.retrieve( uo_dateset.text() , uo_dateend.text(),  lvs_mfs,  gvi_organization_id)		

end event

type uo_dateset from uo_ymd_calendar within w_mat_purchase_order_4_repair_master
event destroy ( )
integer x = 41
integer y = 160
integer taborder = 30
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_purchase_order_4_repair_master
event destroy ( )
integer x = 457
integer y = 160
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_item_code from uo_item_code within w_mat_purchase_order_4_repair_master
integer x = 1326
integer y = 160
integer width = 485
integer taborder = 20
boolean bringtotop = true
end type

type st_3 from so_statictext within w_mat_purchase_order_4_repair_master
integer x = 1326
integer y = 80
integer width = 485
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type st_4 from so_statictext within w_mat_purchase_order_4_repair_master
integer x = 46
integer y = 80
integer width = 814
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Plan Date"
end type

type cb_batch from so_commandbutton within w_mat_purchase_order_4_repair_master
integer x = 1870
integer y = 52
integer width = 480
integer height = 108
integer taborder = 30
boolean bringtotop = true
string text = "Batch Select"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 
if dw_1.rowcount() < 1 or dw_2.rowcount() < 1 then return 
Long  i , j
Decimal lvf_plan_qty, lvf_model_unit_qty
string lvs_item_code, lvs_date , lvs_parent_item_code , lvs_supplier_code

lvs_supplier_code = ddlb_supplier_code.text

IF lvs_supplier_code = '%' or lvs_supplier_code = '' then 
	Messagebox("Notify" , "Supplier Code Invalid")
	return
end if

if dw_3.rowcount( ) > 0 then 

   Messagebox("Notify" , "Request Data Aready Exists!" )
	
end if

msg = f_msgbox1(1161,this.text)
if msg = 1 then 
else 
	return 
end if 

open(w_progress_popup)
w_progress_popup.f_set_range( 0 , dw_2.rowcount()  )
w_progress_popup.f_setstep(1)

if Gvs_material_request_ignore_actual = 'N' then
	lvf_plan_qty = dw_1.object.order_qty[dw_1.getrow()] - dw_1.object.product_actual_qty[dw_1.getrow()]
else
	lvf_plan_qty = dw_1.object.order_qty[dw_1.getrow()] 
end if
//===================================================================
//
//===================================================================


for i = 1 to dw_2.rowcount() 
	
	if dw_2.object.check_yn[i] = 'Y' then 
		j = dw_3.insertrow(1)
		f_set_security_row(dw_3, j , 'ALL')
		

			dw_3.object.purchase_order_date[j]  = f_t_sysdate()	
			
			lvs_date = string(dw_3.object.purchase_order_date[j],'yyyymmdd') + string( f_get_sequence( 'SEQ_PURCHASE_ORDER_NO'),'000')
			
			dw_3.object.order_no[j] = lvs_date
			
			dw_3.object.order_group_no[j] = dw_2.object.mfs[j]

			
			dw_3.object.delivery_date[j] = f_t_sysdate()
			
			dw_3.object.supplier_code[j] = lvs_supplier_code
			

			dw_3.object.order_qty[j] = dw_2.object.issue_remain_qty[j]
			dw_3.object.arrival_qty[j] = 0 
			dw_3.object.order_type[j] = 'M'
		
			dw_3.object.item_code[j] = dw_2.object.item_code[i]
			dw_3.object.line_type[j] = dw_2.object.line_type[i]
			dw_3.object.mfs[j] =  dw_2.object.mfs[j]
//			dw_3.object.material_mfs[j] = '*'
			dw_3.object.delivery[j] = '2'			
			
			dw_3.object.order_type[j] = 'R'	//$$HEX9$$04c7c1d018c2acb990c7acc720001cbcfcc8$$ENDHEX$$
		w_progress_popup.f_stepit()
		w_progress_popup.f_set_message( lvs_item_code )
		
	end if 
next
close(w_progress_popup)

msg = f_msgbox(1170)
if msg = 1 then 
	f_update()
else
	return
end if
end event

type cb_preview from so_commandbutton within w_mat_purchase_order_4_repair_master
integer x = 3959
integer y = 64
integer width = 402
integer height = 100
integer taborder = 70
boolean bringtotop = true
string text = "Preview"
end type

event clicked;call super::clicked;if  ivs_preview_yn = 'Y' THEN 
	 ivs_preview_yn = 'N' 	
	dw_4.bringtotop = false
	dw_3.bringtotop = true 	
else		
	
//	if dw_4.getrow() < 1 then return
//	dw_4.retrieve(dw_3.object.mfs[dw_3.getrow()], gvi_organization_id)

	ivs_preview_yn = 'Y' 	
	dw_4.bringtotop = true			
	dw_3.bringtotop = false
	
	if dw_4.Describe("DataWindow.Print.Preview") = '!' or dw_4.Describe("DataWindow.Print.Preview") = '?' then
	else
		 dw_4.Modify("DataWindow.Print.Preview=yes")
		 dw_4.Modify("DataWindow.Print.Preview.Rulers=yes")
	end if		
end if

	
end event

type cb_print from so_commandbutton within w_mat_purchase_order_4_repair_master
integer x = 3959
integer y = 168
integer width = 402
integer height = 100
integer taborder = 80
boolean bringtotop = true
string text = "Print"
end type

event clicked;call super::clicked;Int		i, lvi_cnt , rows

If dw_4.rowcount() < 1 Then Return
lvi_cnt = Integer(em_copy.text)
If lvi_cnt > 0 Then		
		For i = 1 To lvi_cnt					
			if cbx_dialog.checked = true then 
				dw_4.print(false, True)
			else
				dw_4.print(false, False)						
			end if
		Next
End If	


end event

type cbx_dialog from so_checkbox within w_mat_purchase_order_4_repair_master
integer x = 3511
integer y = 204
integer width = 421
integer height = 84
boolean bringtotop = true
integer weight = 700
string text = "Show Dialog"
end type

type em_copy from so_editmask within w_mat_purchase_order_4_repair_master
integer x = 3511
integer y = 128
integer width = 270
integer taborder = 40
boolean bringtotop = true
string text = "1"
string mask = "##0"
boolean spin = true
end type

type st_2 from so_statictext within w_mat_purchase_order_4_repair_master
integer x = 3511
integer y = 68
integer width = 421
integer height = 52
boolean bringtotop = true
integer weight = 700
string text = "Print Copy"
alignment alignment = left!
end type

type ddlb_mfs from uo_mfs_this_month within w_mat_purchase_order_4_repair_master
integer x = 873
integer y = 160
integer width = 448
integer height = 828
integer taborder = 40
boolean bringtotop = true
end type

type st_1 from so_statictext within w_mat_purchase_order_4_repair_master
integer x = 878
integer y = 80
integer width = 443
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "MFS"
end type

type cb_1 from so_commandbutton within w_mat_purchase_order_4_repair_master
integer x = 1870
integer y = 164
integer width = 480
integer height = 108
integer taborder = 50
boolean bringtotop = true
string text = "Batch Cancel"
end type

event clicked;call super::clicked;int i , j
string lvs_rowid

if dw_3.getrow() < 1 then 
	return
end if 

do
	i++
	
	if dw_3.object.check_yn[i] = 'Y' then 
	else
		continue
	end if
	
	lvs_rowid = dw_3.object.rowid[i]
	
	delete from im_item_purchase_order
	where rowid = :lvs_rowid 
	    and arrival_qty  = 0 ;
	
	if f_sql_check() < 0 then 
		return
	end if
	
	j++
loop until i = dw_3.rowcount( )


if j > 0 then 
	
	msg = f_msgbox( 1170 )
	if msg = 1 then 
		commit ;
		f_retrieve()
	else
		rollback;
	end if
	
end if 
end event

type rb_all from so_radiobutton within w_mat_purchase_order_4_repair_master
integer x = 2921
integer y = 64
integer width = 375
integer height = 64
boolean bringtotop = true
integer weight = 700
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;dw_2.setfilter( '')
dw_2.filter( )

em_level.enabled = false
end event

type rb_material from so_radiobutton within w_mat_purchase_order_4_repair_master
integer x = 2921
integer y = 140
integer width = 375
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Material"
end type

event clicked;call super::clicked;dw_2.setfilter("line_type <> '"+"T"+"'")
dw_2.filter( )

em_level.enabled = false
end event

type cb_2 from so_commandbutton within w_mat_purchase_order_4_repair_master
integer x = 2409
integer y = 160
integer width = 453
integer height = 108
integer taborder = 60
boolean bringtotop = true
string text = "View Issue Plan"
end type

event clicked;call super::clicked;if dw_2.getrow() < 1 then return


openwithparm( w_mat_workorder_not_issued_popup , string(dw_2.object.child_item_code[dw_2.getrow() ] ))
end event

type em_level from so_editmask within w_mat_purchase_order_4_repair_master
integer x = 3227
integer y = 204
integer width = 187
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
string text = "1"
alignment alignment = center!
string mask = "##0"
boolean spin = true
end type

event modified;call super::modified;if rb_level.checked = true then 
	dw_2.setfilter(" RIGHT(BOM_LEVEL,1) = '"+this.text+"'")
	dw_2.filter( )
end if
end event

type rb_level from so_radiobutton within w_mat_purchase_order_4_repair_master
integer x = 2921
integer y = 204
integer width = 283
boolean bringtotop = true
integer weight = 700
string text = "LVL"
end type

event clicked;call super::clicked;em_level.enabled = true
end event

type ddlb_supplier_code from uo_supplier_code within w_mat_purchase_order_4_repair_master
integer x = 119
integer y = 396
integer taborder = 20
boolean bringtotop = true
end type

type st_5 from so_statictext within w_mat_purchase_order_4_repair_master
integer x = 119
integer y = 320
integer width = 457
boolean bringtotop = true
integer weight = 700
string text = "Supplier Code"
end type

type gb_2 from so_groupbox within w_mat_purchase_order_4_repair_master
integer x = 9
integer width = 1833
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_mat_purchase_order_4_repair_master
integer x = 2894
integer width = 544
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "BOM Filter"
end type

type gb_6 from so_groupbox within w_mat_purchase_order_4_repair_master
integer x = 3451
integer width = 946
integer height = 300
integer taborder = 60
integer weight = 700
long textcolor = 16711680
string text = "Print Copy"
end type

type gb_1 from so_groupbox within w_mat_purchase_order_4_repair_master
integer x = 1829
integer height = 300
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_4 from so_groupbox within w_mat_purchase_order_4_repair_master
integer x = 2386
integer width = 498
integer height = 300
integer taborder = 40
integer weight = 700
long textcolor = 16711680
string text = "View Option"
end type

