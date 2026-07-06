HA$PBExportHeader$w_mat_arrival_master.srw
$PBExportComments$Material Arrival Master
forward
global type w_mat_arrival_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mat_arrival_master
end type
type uo_dateend from uo_ymd_calendar within w_mat_arrival_master
end type
type ddlb_item_code from uo_item_code within w_mat_arrival_master
end type
type st_3 from so_statictext within w_mat_arrival_master
end type
type st_4 from so_statictext within w_mat_arrival_master
end type
type rb_departure from so_radiobutton within w_mat_arrival_master
end type
type rb_arrival from so_radiobutton within w_mat_arrival_master
end type
type cb_batch from so_commandbutton within w_mat_arrival_master
end type
type ddlb_supplier_code from uo_supplier_code within w_mat_arrival_master
end type
type st_1 from so_statictext within w_mat_arrival_master
end type
type cb_cancel from so_commandbutton within w_mat_arrival_master
end type
type cbx_departure_subsitute_arrival from so_checkbox within w_mat_arrival_master
end type
type sle_invoice_no from so_singlelineedit within w_mat_arrival_master
end type
type st_2 from so_statictext within w_mat_arrival_master
end type
type gb_1 from so_groupbox within w_mat_arrival_master
end type
type gb_2 from so_groupbox within w_mat_arrival_master
end type
type gb_3 from so_groupbox within w_mat_arrival_master
end type
end forward

global type w_mat_arrival_master from w_main_root
integer width = 4681
integer height = 2848
string title = "Material Arrival Master"
uo_dateset uo_dateset
uo_dateend uo_dateend
ddlb_item_code ddlb_item_code
st_3 st_3
st_4 st_4
rb_departure rb_departure
rb_arrival rb_arrival
cb_batch cb_batch
ddlb_supplier_code ddlb_supplier_code
st_1 st_1
cb_cancel cb_cancel
cbx_departure_subsitute_arrival cbx_departure_subsitute_arrival
sle_invoice_no sle_invoice_no
st_2 st_2
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_mat_arrival_master w_mat_arrival_master

on w_mat_arrival_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.ddlb_item_code=create ddlb_item_code
this.st_3=create st_3
this.st_4=create st_4
this.rb_departure=create rb_departure
this.rb_arrival=create rb_arrival
this.cb_batch=create cb_batch
this.ddlb_supplier_code=create ddlb_supplier_code
this.st_1=create st_1
this.cb_cancel=create cb_cancel
this.cbx_departure_subsitute_arrival=create cbx_departure_subsitute_arrival
this.sle_invoice_no=create sle_invoice_no
this.st_2=create st_2
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.ddlb_item_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.rb_departure
this.Control[iCurrent+7]=this.rb_arrival
this.Control[iCurrent+8]=this.cb_batch
this.Control[iCurrent+9]=this.ddlb_supplier_code
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.cb_cancel
this.Control[iCurrent+12]=this.cbx_departure_subsitute_arrival
this.Control[iCurrent+13]=this.sle_invoice_no
this.Control[iCurrent+14]=this.st_2
this.Control[iCurrent+15]=this.gb_1
this.Control[iCurrent+16]=this.gb_2
this.Control[iCurrent+17]=this.gb_3
end on

on w_mat_arrival_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.ddlb_item_code)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.rb_departure)
destroy(this.rb_arrival)
destroy(this.cb_batch)
destroy(this.ddlb_supplier_code)
destroy(this.st_1)
destroy(this.cb_cancel)
destroy(this.cbx_departure_subsitute_arrival)
destroy(this.sle_invoice_no)
destroy(this.st_2)
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
Ivs_resize_type                      = 'MASTER_DETAIL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


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
F_MENU_CONTROL('DATA_CONTROL_MODIFY' , TRUE)  // All Data Control





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
			if rb_departure.checked = true  then 
			    dw_1.retrieve(ddlb_item_code.text() + '%', ddlb_supplier_code.text +'%', uo_dateset.text(), uo_dateend.text(), sle_invoice_no.text+'%' , gvi_organization_id)
			else
				dw_3.retrieve(ddlb_item_code.text() + '%', ddlb_supplier_code.text +'%', uo_dateset.text() , uo_dateend.text(), sle_invoice_no.text+'%' ,  gvi_organization_id)
			end if 
	
//    case 'INSERT'
//		
//			ROW = DW_2.INSERTROW(DW_2.GETROW())
//			DW_2.SCROLLTOROW(ROW)
//			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')
//			lvd_seq = f_get_sequence('seq_mat_arrival')
//			lvs_date = string(f_t_sysdate(),'yyyymmdd') + string(lvd_seq)
//			dw_2.object.arrival_date[row] = f_t_sysdate()
//			dw_2.object.inspect_date[row] = f_t_sysdate()
//			dw_2.object.arrival_seq_no[row] = lvd_seq
//			dw_2.object.invoice_no[row] = lvs_date
//			dw_2.object.order_no[row] = lvs_date
//			dw_2.object.mfs[row] = lvs_date
//			dw_2.object.arrival_status[row] = 'N'
//			dw_2.object.inspect_result[row]  = 'P'
//			dw_2.object.inspect_rule[row]  = 'P'			
//			
//	case 'APPEND'		
//			
//			ROW = DW_2.INSERTROW(DW_2.GETROW())
//			DW_2.SCROLLTOROW(ROW)
//			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')	
//			lvd_seq = f_get_sequence('seq_mat_arrival')
//			lvs_date = string(f_t_sysdate(),'yyyymmdd') + string(lvd_seq)
//			dw_2.object.arrival_date[row] = f_t_sysdate()
//			dw_2.object.inspect_date[row] = f_t_sysdate()
//			dw_2.object.arrival_seq_no[row] = lvd_seq
//			dw_2.object.invoice_no[row] = lvs_date
//			dw_2.object.order_no[row] = lvs_date
//			dw_2.object.mfs[row] = lvs_date
//			dw_2.object.arrival_status[row] = 'N'
//			dw_2.object.inspect_result[row]  = 'P'
//			dw_2.object.inspect_rule[row]  = 'P'
//			
//	case 'DELETE'
//		
//		  	if DW_2.AcceptText() = -1 then
//				return
//			end if
//			
//			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
//			IF MSG = 1 THEN
//				Gvl_row_deleted = DW_2.GetRow()			
//				DW_2.DELETEROW(Gvl_row_deleted)		
//				DW_2.SetFocus()
//				ROW = DW_2.GetRow()
//				DW_2.ScrollToRow(row)
//				DW_2.SetColumn(1)
//			END IF		 
   case 'UPDATE'
		
			IF DW_2.UPDATE() < 0  THEN
			  	 ROLLBACK;
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			END IF
               F_RETRIEVE()
	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mat_arrival_master
integer y = 316
end type

type dw_4 from w_main_root`dw_4 within w_mat_arrival_master
integer y = 316
end type

type dw_3 from w_main_root`dw_3 within w_mat_arrival_master
integer y = 308
integer width = 4544
integer height = 1532
boolean titlebar = true
string title = "Material Arrival List"
string dataobject = "d_mat_arrival_lst"
end type

type dw_2 from w_main_root`dw_2 within w_mat_arrival_master
integer y = 1844
integer width = 4535
integer height = 780
string dataobject = "d_mat_arrival_mst"
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_mat_arrival_master
integer y = 308
integer width = 4544
integer height = 1532
boolean titlebar = true
string title = "Material Daparture List"
string dataobject = "d_mat_departure_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;IF CURRENTROW = 0 THEN RETURN
//DW_2.RETRIEVE( DW_1.GETITEMSTRING( CURRENTROW , 'ROWID' ) )

end event

event dw_1::doubleclicked;call super::doubleclicked;IF ROW < 1  THEN RETURN
DW_2.RETRIEVE( DW_1.GETITEMSTRING( ROW , 'ROWID' ) )

end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_arrival_master
end type

type uo_dateset from uo_ymd_calendar within w_mat_arrival_master
event destroy ( )
integer x = 1888
integer y = 160
integer taborder = 30
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_arrival_master
event destroy ( )
integer x = 2304
integer y = 160
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_item_code from uo_item_code within w_mat_arrival_master
integer x = 750
integer y = 160
integer width = 558
integer taborder = 20
boolean bringtotop = true
end type

type st_3 from so_statictext within w_mat_arrival_master
integer x = 750
integer y = 80
integer width = 558
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type st_4 from so_statictext within w_mat_arrival_master
integer x = 1893
integer y = 80
integer width = 814
boolean bringtotop = true
integer weight = 700
string text = "Purchase Order Date"
end type

type rb_departure from so_radiobutton within w_mat_arrival_master
integer x = 59
integer y = 76
integer width = 631
boolean bringtotop = true
integer weight = 700
string text = "Departure List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1
cb_batch.enabled = true 
cb_cancel.enabled = false


end event

type rb_arrival from so_radiobutton within w_mat_arrival_master
integer x = 59
integer y = 184
integer width = 631
boolean bringtotop = true
integer weight = 700
string text = "Arrival List"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3
cb_batch.enabled = false
cb_cancel.enabled = true
end event

type cb_batch from so_commandbutton within w_mat_arrival_master
integer x = 3666
integer y = 164
integer width = 421
integer height = 116
integer taborder = 30
boolean bringtotop = true
string text = "Batch Select"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 
if dw_1.rowcount() = 0 then return 
long i 

dw_1.accepttext()
for i = 1 to dw_1.rowcount() 
	if dw_1.object.check_yn[i] = 'Y' then 
		dw_1.object.arrival_type[i] = 'A' 
//		dw_1.object.arrival_date[i] = f_t_sysdate()
	end if 
next 

msg = f_msgbox(1170)
if msg = 1 then 
	if dw_1.update() < 0 then 
		rollback; 
		f_msg_mdi_help(f_msg_st(9026))
	else
		commit; 
		f_msg_mdi_help(f_msg_st(170))
		f_retrieve()
	end if 
else
		f_retrieve()	
end if
end event

type ddlb_supplier_code from uo_supplier_code within w_mat_arrival_master
integer x = 1307
integer y = 160
integer width = 576
integer taborder = 20
boolean bringtotop = true
end type

type st_1 from so_statictext within w_mat_arrival_master
integer x = 1307
integer y = 80
integer width = 576
boolean bringtotop = true
integer weight = 700
string text = "Supplier Code"
end type

type cb_cancel from so_commandbutton within w_mat_arrival_master
integer x = 4091
integer y = 164
integer width = 421
integer height = 116
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
string text = "Cancel"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 
if dw_3.rowcount() = 0 then return 
long i ,  j 

if cbx_departure_subsitute_arrival.checked = true then 
	
	Messagebox("Notify" , "Use the departure cancel program!")
	return
end if


msg = f_msgbox1(1161,this.text)
if msg = 1 then 
	for i = 1 to dw_3.rowcount() 
		if dw_3.object.check_yn[i] = 'Y' then 
		   if (dw_3.object.inspect_result[i] = 'P' OR dw_3.object.inspect_result[i] = 'U' ) and dw_3.object.inspect_rule[i] = 'I'  then
			   MESSAGEBOX("$$HEX2$$668b4a54$$ENDHEX$$","IQC$$HEX28$$a17b06742d4ec068e567d37e9c67c55f7b983a4e497b855f16620d4e08543c684d62fd80db8f4c88646bcd645c4f0cfff78be5670b772c7b$$ENDHEX$$"+STRING(i)+"$$HEX1$$4c88$$ENDHEX$$")
				continue
			elseif dw_3.object.arrival_type[i] = 'A' then 
				dw_3.object.arrival_type[i] = 'D'
				j++
			end if 
		end if 	
	next
end if 

msg = f_msgbox(1170)
if msg = 1 then 
	
	if dw_3.update() < 0 then 
		rollback; 
		f_msg_mdi_help(f_msg_st(9026))	
	else
		commit ; 
		f_msg_mdi_help(f_msg_st(170))	
		f_retrieve()
	end if 
else
	f_retrieve()	
end if 



end event

type cbx_departure_subsitute_arrival from so_checkbox within w_mat_arrival_master
integer x = 3680
integer y = 60
integer width = 759
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Substitute for the arrival"
end type

event constructor;call super::constructor;if Gvs_substitute_for_arrival = 'Y' then
	this.checked = True
else
	this.checked = False	
end if
end event

type sle_invoice_no from so_singlelineedit within w_mat_arrival_master
integer x = 2729
integer y = 160
integer taborder = 40
boolean bringtotop = true
textcase textcase = upper!
end type

type st_2 from so_statictext within w_mat_arrival_master
integer x = 2729
integer y = 68
boolean bringtotop = true
integer weight = 700
string text = "Invoice No"
end type

type gb_1 from so_groupbox within w_mat_arrival_master
integer x = 9
integer width = 699
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_mat_arrival_master
integer x = 713
integer width = 2555
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_mat_arrival_master
integer x = 3616
integer width = 923
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

