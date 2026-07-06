HA$PBExportHeader$w_mcn_mold_purchase_order_master.srw
$PBExportComments$Material Purchase Order Master
forward
global type w_mcn_mold_purchase_order_master from w_main_root
end type
type st_1 from so_statictext within w_mcn_mold_purchase_order_master
end type
type ddlb_item_code from uo_item_code within w_mcn_mold_purchase_order_master
end type
type st_3 from so_statictext within w_mcn_mold_purchase_order_master
end type
type uo_dateset from uo_ymd_calendar within w_mcn_mold_purchase_order_master
end type
type uo_dateend from uo_ymd_calendar within w_mcn_mold_purchase_order_master
end type
type cb_group from so_commandbutton within w_mcn_mold_purchase_order_master
end type
type cb_cancel from so_commandbutton within w_mcn_mold_purchase_order_master
end type
type rb_lst from so_radiobutton within w_mcn_mold_purchase_order_master
end type
type rb_hst from so_radiobutton within w_mcn_mold_purchase_order_master
end type
type cb_preview from so_commandbutton within w_mcn_mold_purchase_order_master
end type
type cb_print from so_commandbutton within w_mcn_mold_purchase_order_master
end type
type cbx_dialog from so_checkbox within w_mcn_mold_purchase_order_master
end type
type em_copy from so_editmask within w_mcn_mold_purchase_order_master
end type
type st_2 from so_statictext within w_mcn_mold_purchase_order_master
end type
type st_4 from so_statictext within w_mcn_mold_purchase_order_master
end type
type ddlb_supplier_code from uo_supplier_code within w_mcn_mold_purchase_order_master
end type
type sle_item_name from so_singlelineedit within w_mcn_mold_purchase_order_master
end type
type st_14 from so_statictext within w_mcn_mold_purchase_order_master
end type
type sle_1 from so_singlelineedit within w_mcn_mold_purchase_order_master
end type
type st_5 from so_statictext within w_mcn_mold_purchase_order_master
end type
type ddlb_1 from uo_basecode within w_mcn_mold_purchase_order_master
end type
type st_6 from so_statictext within w_mcn_mold_purchase_order_master
end type
type gb_1 from so_groupbox within w_mcn_mold_purchase_order_master
end type
type gb_4 from so_groupbox within w_mcn_mold_purchase_order_master
end type
type gb_5 from so_groupbox within w_mcn_mold_purchase_order_master
end type
type gb_6 from so_groupbox within w_mcn_mold_purchase_order_master
end type
end forward

global type w_mcn_mold_purchase_order_master from w_main_root
integer width = 4754
integer height = 2712
string title = "Mold Purchase Order Master"
st_1 st_1
ddlb_item_code ddlb_item_code
st_3 st_3
uo_dateset uo_dateset
uo_dateend uo_dateend
cb_group cb_group
cb_cancel cb_cancel
rb_lst rb_lst
rb_hst rb_hst
cb_preview cb_preview
cb_print cb_print
cbx_dialog cbx_dialog
em_copy em_copy
st_2 st_2
st_4 st_4
ddlb_supplier_code ddlb_supplier_code
sle_item_name sle_item_name
st_14 st_14
sle_1 sle_1
st_5 st_5
ddlb_1 ddlb_1
st_6 st_6
gb_1 gb_1
gb_4 gb_4
gb_5 gb_5
gb_6 gb_6
end type
global w_mcn_mold_purchase_order_master w_mcn_mold_purchase_order_master

type variables
string ivs_preview_yn = 'N'
end variables

on w_mcn_mold_purchase_order_master.create
int iCurrent
call super::create
this.st_1=create st_1
this.ddlb_item_code=create ddlb_item_code
this.st_3=create st_3
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.cb_group=create cb_group
this.cb_cancel=create cb_cancel
this.rb_lst=create rb_lst
this.rb_hst=create rb_hst
this.cb_preview=create cb_preview
this.cb_print=create cb_print
this.cbx_dialog=create cbx_dialog
this.em_copy=create em_copy
this.st_2=create st_2
this.st_4=create st_4
this.ddlb_supplier_code=create ddlb_supplier_code
this.sle_item_name=create sle_item_name
this.st_14=create st_14
this.sle_1=create sle_1
this.st_5=create st_5
this.ddlb_1=create ddlb_1
this.st_6=create st_6
this.gb_1=create gb_1
this.gb_4=create gb_4
this.gb_5=create gb_5
this.gb_6=create gb_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.ddlb_item_code
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.uo_dateset
this.Control[iCurrent+5]=this.uo_dateend
this.Control[iCurrent+6]=this.cb_group
this.Control[iCurrent+7]=this.cb_cancel
this.Control[iCurrent+8]=this.rb_lst
this.Control[iCurrent+9]=this.rb_hst
this.Control[iCurrent+10]=this.cb_preview
this.Control[iCurrent+11]=this.cb_print
this.Control[iCurrent+12]=this.cbx_dialog
this.Control[iCurrent+13]=this.em_copy
this.Control[iCurrent+14]=this.st_2
this.Control[iCurrent+15]=this.st_4
this.Control[iCurrent+16]=this.ddlb_supplier_code
this.Control[iCurrent+17]=this.sle_item_name
this.Control[iCurrent+18]=this.st_14
this.Control[iCurrent+19]=this.sle_1
this.Control[iCurrent+20]=this.st_5
this.Control[iCurrent+21]=this.ddlb_1
this.Control[iCurrent+22]=this.st_6
this.Control[iCurrent+23]=this.gb_1
this.Control[iCurrent+24]=this.gb_4
this.Control[iCurrent+25]=this.gb_5
this.Control[iCurrent+26]=this.gb_6
end on

on w_mcn_mold_purchase_order_master.destroy
call super::destroy
destroy(this.st_1)
destroy(this.ddlb_item_code)
destroy(this.st_3)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.cb_group)
destroy(this.cb_cancel)
destroy(this.rb_lst)
destroy(this.rb_hst)
destroy(this.cb_preview)
destroy(this.cb_print)
destroy(this.cbx_dialog)
destroy(this.em_copy)
destroy(this.st_2)
destroy(this.st_4)
destroy(this.ddlb_supplier_code)
destroy(this.sle_item_name)
destroy(this.st_14)
destroy(this.sle_1)
destroy(this.st_5)
destroy(this.ddlb_1)
destroy(this.st_6)
destroy(this.gb_1)
destroy(this.gb_4)
destroy(this.gb_5)
destroy(this.gb_6)
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
F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control





end event

event ue_post_open;call super::ue_post_open;

/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
uo_dateset.settext(string(f_t_sysdate(), 'yyyy/mm')+'/01')
end event

event ue_data_control;call super::ue_data_control;Long row
String lvs_date
choose case gvs_ue_data_control
		
	case 'RETRIEVE'			
		dw_1.reset()
		dw_2.reset()
		dw_3.reset()
		
		if rb_lst.checked then 
			dw_1.retrieve(ddlb_supplier_code.text+'%' , ddlb_item_code.text() + '%',  uo_dateset.text() , uo_dateend.text(),  gvi_organization_id)
		else
			dw_3.retrieve(ddlb_supplier_code.text+'%' , ddlb_item_code.text() + '%',  uo_dateset.text() , uo_dateend.text(),  gvi_organization_id)
		end if
		
	case 'INSERT'
		
			DW_2.ENABLED = TRUE
			ROW = DW_2.INSERTROW(DW_2.GETROW())
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')
			dw_2.object.delivery_date[row] = f_t_sysdate()
			dw_2.object.purchase_order_date[row]  = f_t_sysdate()	
			lvs_date = string(dw_2.object.purchase_order_date[row],'yyyymmdd') + string( f_get_sequence( 'SEQ_PURCHASE_ORDER_NO'),'000')
			dw_2.object.order_no[row] = lvs_date
			lvs_date = string(f_t_sysdate(),'yyyymmdd') + string( f_get_sequence( 'SEQ_PURCHASE_ORDER_NO'),'000')			
			dw_2.object.order_group_no[row] = lvs_date
			
	case 'APPEND'		
			DW_2.ENABLED = TRUE
			ROW = DW_2.INSERTROW(DW_2.GETROW())
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')	
			dw_2.object.delivery_date[row] = f_t_sysdate()
			dw_2.object.purchase_order_date[row]  = f_t_sysdate()	
               lvs_date = string(dw_2.object.purchase_order_date[row],'yyyymmdd') + string( f_get_sequence( 'SEQ_PURCHASE_ORDER_NO'),'000')
			dw_2.object.order_no[row] = lvs_date
			lvs_date = string(f_t_sysdate(),'yyyymmdd') + string( f_get_sequence( 'SEQ_PURCHASE_ORDER_NO'),'000')			
			dw_2.object.order_group_no[row] = lvs_date
			
	case 'DELETE'
		
		  	if DW_2.AcceptText() = -1 then
				return
			end if
			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
				Gvl_row_deleted = DW_2.GetRow()			
				DW_2.DELETEROW(Gvl_row_deleted)		
				DW_2.SetFocus()
				ROW = DW_2.GetRow()
				DW_2.ScrollToRow(row)
				DW_2.SetColumn(1)
			END IF
			
	case 'UPDATE'
		
			IF DW_2.UPDATE() < 0 THEN
			  	 ROLLBACK;
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			END IF
               F_RETRIEVE()
	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mcn_mold_purchase_order_master
integer y = 540
integer height = 424
end type

type dw_4 from w_main_root`dw_4 within w_mcn_mold_purchase_order_master
integer y = 532
integer width = 4544
integer height = 1184
boolean titlebar = true
string title = "Purchase Order Sheet"
string dataobject = "d_mcn_mold_purchase_order_rpt"
end type

type dw_3 from w_main_root`dw_3 within w_mcn_mold_purchase_order_master
integer y = 532
integer width = 4544
integer height = 1172
boolean titlebar = true
string title = "Material Purchase Order History"
string dataobject = "d_mcn_mold_purchase_order_group_lst"
end type

event dw_3::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return
dw_4.retrieve(this.object.order_group_no[currentrow], this.object.supplier_code[currentrow], gvi_organization_id)
					

end event

event dw_3::doubleclicked;call super::doubleclicked;if row < 1 then return
dw_4.retrieve(this.object.order_group_no[row], this.object.supplier_code[row], gvi_organization_id)
					

end event

type dw_2 from w_main_root`dw_2 within w_mcn_mold_purchase_order_master
integer y = 1720
integer width = 4535
integer height = 552
string dataobject = "d_mcn_mold_purchase_order_mst"
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_2::rbuttondown;call super::rbuttondown;string lvs_return  , lvs_currency , lvs_delivery
Decimal lvf_unit_price

if dwo.name = 'mold_code' then 
	
	open(w_mcn_mold_popup)	
	
	if  gst_return.gvb_return  = true then
		
	   this.object.mold_code[row] = message.stringparm
	   this.object.mold_name[row] = Gst_return.gvs_return[1] 		
	   this.object.mold_spec[row] = Gst_return.gvs_return[2] 		
		
        this.object.supplier_code[row]  = Gst_return.gvs_return[3] 		
        this.object.supplier_name[row] = Gst_return.gvs_return[4] 		

		THIS.OBJECT.CURRENCY[ROW]    = ''
		THIS.OBJECT.UNIT_PRICE[ROW] = 0 
		THIS.OBJECT.ORDER_AMT[ROW]    = 0	
		
		//$$HEX22$$1cbcfcc8dcc294b22000e8b200ac2000b9c278c7ecc580bd7cb9200080acacc058d5c0c920004ac594b2e4b2$$ENDHEX$$.
		LVF_UNIT_PRICE = f_get_mold_unit_price( this.object.supplier_code[row] , this.object.mold_code[row]  )			
     
	     IF LVF_UNIT_PRICE < 0 THEN 
			RETURN 1
		END IF
		
		THIS.OBJECT.UNIT_PRICE[ROW] = LVF_UNIT_PRICE
		THIS.OBJECT.CURRENCY[ROW]   = gst_return.gvs_return[1]
		gst_return.gvs_return[1] = ''
		gst_return.gvs_return[2] = ''
		gst_return.gvs_return[3] = ''
		gst_return.gvs_return[4] = ''		
		
	end if
			
END IF

end event

event dw_2::itemchanged;call super::itemchanged;IF DWO.NAME = 'order_qty' THEN
	
   THIS.OBJECT.order_amt[ROW]  = THIS.OBJECT.unit_price[ROW] * THIS.OBJECT.order_qty[ROW]
	
END IF 
end event

type dw_1 from w_main_root`dw_1 within w_mcn_mold_purchase_order_master
integer y = 532
integer width = 4544
integer height = 1184
boolean titlebar = true
string title = "Mold Purchase Order List"
string dataobject = "d_mcn_mold_purchase_order_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;IF CURRENTROW = 0 THEN RETURN
DW_2.RETRIEVE( DW_1.GETITEMSTRING( CURRENTROW , 'ROWID' ) )

end event

event dw_1::doubleclicked;call super::doubleclicked;IF ROW < 1  THEN RETURN
DW_2.RETRIEVE( DW_1.GETITEMSTRING( ROW , 'ROWID' ) )

end event

type uo_tabpages from w_main_root`uo_tabpages within w_mcn_mold_purchase_order_master
end type

type st_1 from so_statictext within w_mcn_mold_purchase_order_master
integer x = 1106
integer y = 92
integer width = 507
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mcn_mold_purchase_order_master
integer x = 1106
integer y = 164
integer width = 507
integer taborder = 20
boolean bringtotop = true
end type

type st_3 from so_statictext within w_mcn_mold_purchase_order_master
integer x = 1627
integer y = 92
integer width = 805
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Delivery Date"
end type

type uo_dateset from uo_ymd_calendar within w_mcn_mold_purchase_order_master
integer x = 1623
integer y = 164
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mcn_mold_purchase_order_master
integer x = 2039
integer y = 164
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type cb_group from so_commandbutton within w_mcn_mold_purchase_order_master
integer x = 27
integer y = 392
integer width = 315
integer height = 100
integer taborder = 50
boolean bringtotop = true
string text = "Generate"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 
if dw_1.rowcount() < 1 then return 
long i , j 
string lvs_supplier_code, lvs_date
msg = f_msgbox1(1161,this.text)
if msg = 1 then 
else
	return 
end if 
for i = 1 to dw_1.rowcount() 
	
	if dw_1.object.check_yn[i] = 'Y' and  dw_1.object.arrival_qty[i] = 0 then 
		lvs_supplier_code = dw_1.object.supplier_code[i]
		exit 
	elseif dw_1.object.check_yn[i] = 'Y' and  dw_1.object.arrival_qty[i] <> 0 then 
		//mes sagebox('Notify','Arrival qty is exists, so you can not generate order group no!')
		f_msg( 'Arrival qty is exists, so you can not generate order group no!', 'P') 
		return 
	end if 
next
//if i > 1 then 	
	for j =  i   to dw_1.rowcount()
		if dw_1.object.check_yn[j] = 'Y'  and dw_1.object.arrival_qty[i] = 0 then 
			if lvs_supplier_code <> dw_1.object.supplier_code[j] then 
				//mes sagebox('Notify','Supplier code should be the same, please try it again.')
				f_msg( 'Supplier code should be the same, please try it again.', 'P') 
				return 
			end if 
		elseif dw_1.object.check_yn[i] = 'Y' and  dw_1.object.arrival_qty[i] <> 0 then 
		      //mes sagebox('Notify','Arrival qty is exists, so you can not generate order group no!')
			 f_msg('Arrival qty is exists, so you can not generate order group no!','P')
		    return 
		end if
	next
//else
//	message box('Notify','Please select records, first!')
//	return 
//end if 
lvs_date = string(f_t_sysdate(),'yyyymmdd') + string( f_get_sequence( 'SEQ_PURCHASE_ORDER_NO'),'000')
for i = 1 to dw_1.rowcount() 
	if dw_1.object.check_yn[i] = 'Y' and dw_1.object.arrival_qty[i] = 0  then 
		dw_1.object.order_group_no[i] = lvs_date
	end if 
next
if dw_1.update() < 0 then 
	rollback ; 
	f_msg_mdi_help(f_msg_st(9026))
else
	commit ; 
	f_msg_mdi_help(f_msg_st(170))
	f_retrieve()
end if 
	

		
		
	
end event

type cb_cancel from so_commandbutton within w_mcn_mold_purchase_order_master
integer x = 347
integer y = 392
integer width = 315
integer height = 100
integer taborder = 60
boolean bringtotop = true
string text = "Cancel"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 
if dw_1.rowcount() < 1 then return 
long  i 
for i = 1 to dw_1.rowcount() 
	if dw_1.object.check_yn[i] = 'Y' then 
		if isnull(dw_1.object.order_group_no[i]) then 
			//mess agebox('Notify','Order group no is null, please try it again')
			f_msg( 'Order group no is null, please try it again','P')
			return 
		else
			dw_1.object.order_group_no[i] = ''
		end if 
	end if 
next
if dw_1.update() < 0 then 
	rollback; 
	f_msg_mdi_help(f_msg_st(9026))
else
	commit ; 
	f_msg_mdi_help(f_msg_st(170))
	f_retrieve()
end if 
end event

type rb_lst from so_radiobutton within w_mcn_mold_purchase_order_master
integer x = 37
integer y = 84
integer width = 507
boolean bringtotop = true
integer weight = 700
string text = "Order List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1

cb_preview.enabled = false
cb_print.enabled = false

end event

type rb_hst from so_radiobutton within w_mcn_mold_purchase_order_master
integer x = 37
integer y = 180
integer width = 507
boolean bringtotop = true
integer weight = 700
string text = "Order History"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3
cb_preview.enabled = true
cb_print.enabled = true
end event

type cb_preview from so_commandbutton within w_mcn_mold_purchase_order_master
integer x = 1961
integer y = 392
integer width = 315
integer height = 100
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
string text = "Preview"
end type

event clicked;call super::clicked;if rb_hst.checked = true then 
	if  ivs_preview_yn = 'Y' THEN 
		ivs_preview_yn = 'N' 	
		dw_3.bringtotop = TRUE
	else
		ivs_preview_yn = 'Y' 	
		dw_4.bringtotop = TRUE			
		if dw_4.Describe("DataWindow.Print.Preview") = '!' or dw_4.Describe("DataWindow.Print.Preview") = '?' then
		else
			 dw_4.Modify("DataWindow.Print.Preview=yes")
			 dw_4.Modify("DataWindow.Print.Preview.Rulers=yes")
		end if		
	end if
end if
	
end event

type cb_print from so_commandbutton within w_mcn_mold_purchase_order_master
integer x = 2277
integer y = 392
integer width = 315
integer height = 100
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
string text = "Print"
end type

event clicked;call super::clicked;Int		i, lvi_cnt , rows

If dw_4.rowcount() < 1 Then Return

//DO
//   rows++

//   if dw_3.object.check_yn[rows] = 'Y' then		
		
		
//      dw_4.retrieve(dw_3.object.shipping_date[rows], dw_3.object.shipping_date[rows], &
//					     dw_3.object.customer_code[rows] + '%', dw_3.object.shipping_type[rows] + '%', &
//					     dw_3.object.invoice_no[rows] + '%', gvi_organization_id)
		
		lvi_cnt = Integer(em_copy.text)
		If lvi_cnt > 0 Then
			If rb_hst.checked = True Then
				For i = 1 To lvi_cnt
					
					if cbx_dialog.checked = true then 
						dw_4.print(false, True)
					else
						dw_4.print(false, False)						
					end if
				Next
			End If
		End If
//	else
//		continue
//	end if

//LOOP UNTIL ROWS = DW_3.ROWCOUNT()
end event

type cbx_dialog from so_checkbox within w_mcn_mold_purchase_order_master
integer x = 1065
integer y = 412
integer width = 393
boolean bringtotop = true
integer weight = 700
string text = "Show Dialog"
end type

type em_copy from so_editmask within w_mcn_mold_purchase_order_master
integer x = 745
integer y = 424
integer width = 311
integer taborder = 30
boolean bringtotop = true
string text = "1"
string mask = "##0"
boolean spin = true
end type

type st_2 from so_statictext within w_mcn_mold_purchase_order_master
integer x = 745
integer y = 360
integer width = 311
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Print Copy"
end type

type st_4 from so_statictext within w_mcn_mold_purchase_order_master
integer x = 594
integer y = 84
integer width = 507
boolean bringtotop = true
integer weight = 700
string text = "Supplier Code"
end type

type ddlb_supplier_code from uo_supplier_code within w_mcn_mold_purchase_order_master
integer x = 594
integer y = 164
integer width = 507
integer taborder = 30
boolean bringtotop = true
end type

type sle_item_name from so_singlelineedit within w_mcn_mold_purchase_order_master
integer x = 2455
integer y = 164
integer width = 590
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

type st_14 from so_statictext within w_mcn_mold_purchase_order_master
integer x = 2455
integer y = 96
integer width = 590
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Item Name"
end type

type sle_1 from so_singlelineedit within w_mcn_mold_purchase_order_master
integer x = 3049
integer y = 164
integer width = 590
integer height = 84
integer taborder = 50
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

LVS_COLUMN = 'ITEM_SPEC'
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

type st_5 from so_statictext within w_mcn_mold_purchase_order_master
integer x = 3049
integer y = 96
integer width = 590
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Item Spec"
end type

type ddlb_1 from uo_basecode within w_mcn_mold_purchase_order_master
integer x = 1536
integer y = 416
integer width = 398
integer height = 360
integer taborder = 70
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'LANGUAGE')
end event

type st_6 from so_statictext within w_mcn_mold_purchase_order_master
integer x = 1536
integer y = 356
integer width = 398
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Language"
end type

type gb_1 from so_groupbox within w_mcn_mold_purchase_order_master
integer x = 571
integer y = 4
integer width = 3104
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_4 from so_groupbox within w_mcn_mold_purchase_order_master
integer y = 308
integer width = 681
integer height = 220
integer taborder = 40
integer weight = 700
long textcolor = 16711680
string text = "Order Group"
end type

type gb_5 from so_groupbox within w_mcn_mold_purchase_order_master
integer y = 4
integer width = 567
integer height = 300
integer taborder = 50
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_6 from so_groupbox within w_mcn_mold_purchase_order_master
integer x = 686
integer y = 308
integer width = 1975
integer height = 220
integer taborder = 50
integer weight = 700
long textcolor = 16711680
string text = "Print Copy"
end type

