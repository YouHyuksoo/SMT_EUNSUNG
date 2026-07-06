HA$PBExportHeader$w_com_carrying_out_master.srw
$PBExportComments$Material Receipt Master
forward
global type w_com_carrying_out_master from w_main_root
end type
type uo_dateend from uo_ymd_calendar within w_com_carrying_out_master
end type
type ddlb_item_code from uo_item_code within w_com_carrying_out_master
end type
type st_3 from so_statictext within w_com_carrying_out_master
end type
type st_4 from so_statictext within w_com_carrying_out_master
end type
type rb_list from so_radiobutton within w_com_carrying_out_master
end type
type rb_receipt from so_radiobutton within w_com_carrying_out_master
end type
type ddlb_supplier_code from uo_supplier_code within w_com_carrying_out_master
end type
type st_1 from so_statictext within w_com_carrying_out_master
end type
type st_5 from so_statictext within w_com_carrying_out_master
end type
type sle_1 from so_singlelineedit within w_com_carrying_out_master
end type
type tab_1 from tab within w_com_carrying_out_master
end type
type tabpage_1 from userobject within tab_1
end type
type cb_5 from so_commandbutton within tabpage_1
end type
type cb_4 from so_commandbutton within tabpage_1
end type
type cb_3 from so_commandbutton within tabpage_1
end type
type rb_6 from so_radiobutton within tabpage_1
end type
type rb_5 from so_radiobutton within tabpage_1
end type
type rb_4 from so_radiobutton within tabpage_1
end type
type sle_group_no from so_singlelineedit within tabpage_1
end type
type cb_group_no from so_commandbutton within tabpage_1
end type
type cb_2 from so_commandbutton within tabpage_1
end type
type tabpage_1 from userobject within tab_1
cb_5 cb_5
cb_4 cb_4
cb_3 cb_3
rb_6 rb_6
rb_5 rb_5
rb_4 rb_4
sle_group_no sle_group_no
cb_group_no cb_group_no
cb_2 cb_2
end type
type tabpage_2 from userobject within tab_1
end type
type rb_3 from so_radiobutton within tabpage_2
end type
type rb_2 from so_radiobutton within tabpage_2
end type
type rb_1 from so_radiobutton within tabpage_2
end type
type cb_print from so_commandbutton within tabpage_2
end type
type cb_preview from so_commandbutton within tabpage_2
end type
type cbx_dialog from so_checkbox within tabpage_2
end type
type em_copy from so_editmask within tabpage_2
end type
type st_2 from so_statictext within tabpage_2
end type
type tabpage_2 from userobject within tab_1
rb_3 rb_3
rb_2 rb_2
rb_1 rb_1
cb_print cb_print
cb_preview cb_preview
cbx_dialog cbx_dialog
em_copy em_copy
st_2 st_2
end type
type tabpage_3 from userobject within tab_1
end type
type rb_gt from so_radiobutton within tabpage_3
end type
type rb_all from so_radiobutton within tabpage_3
end type
type cb_1 from so_commandbutton within tabpage_3
end type
type tabpage_3 from userobject within tab_1
rb_gt rb_gt
rb_all rb_all
cb_1 cb_1
end type
type tab_1 from tab within w_com_carrying_out_master
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
type ddlb_carrying_out_type from uo_basecode within w_com_carrying_out_master
end type
type st_6 from so_statictext within w_com_carrying_out_master
end type
type uo_dateset from uo_ymd_calendar within w_com_carrying_out_master
end type
type ddlb_dept_code from uo_department_code within w_com_carrying_out_master
end type
type st_7 from so_statictext within w_com_carrying_out_master
end type
type st_8 from so_statictext within w_com_carrying_out_master
end type
type sle_gen_new_group from so_singlelineedit within w_com_carrying_out_master
end type
type gb_1 from so_groupbox within w_com_carrying_out_master
end type
type gb_2 from so_groupbox within w_com_carrying_out_master
end type
end forward

global type w_com_carrying_out_master from w_main_root
integer width = 4791
integer height = 2952
string title = "Carrying OUT Invoice"
uo_dateend uo_dateend
ddlb_item_code ddlb_item_code
st_3 st_3
st_4 st_4
rb_list rb_list
rb_receipt rb_receipt
ddlb_supplier_code ddlb_supplier_code
st_1 st_1
st_5 st_5
sle_1 sle_1
tab_1 tab_1
ddlb_carrying_out_type ddlb_carrying_out_type
st_6 st_6
uo_dateset uo_dateset
ddlb_dept_code ddlb_dept_code
st_7 st_7
st_8 st_8
sle_gen_new_group sle_gen_new_group
gb_1 gb_1
gb_2 gb_2
end type
global w_com_carrying_out_master w_com_carrying_out_master

type variables
string ivs_preview_yn
end variables

on w_com_carrying_out_master.create
int iCurrent
call super::create
this.uo_dateend=create uo_dateend
this.ddlb_item_code=create ddlb_item_code
this.st_3=create st_3
this.st_4=create st_4
this.rb_list=create rb_list
this.rb_receipt=create rb_receipt
this.ddlb_supplier_code=create ddlb_supplier_code
this.st_1=create st_1
this.st_5=create st_5
this.sle_1=create sle_1
this.tab_1=create tab_1
this.ddlb_carrying_out_type=create ddlb_carrying_out_type
this.st_6=create st_6
this.uo_dateset=create uo_dateset
this.ddlb_dept_code=create ddlb_dept_code
this.st_7=create st_7
this.st_8=create st_8
this.sle_gen_new_group=create sle_gen_new_group
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateend
this.Control[iCurrent+2]=this.ddlb_item_code
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.rb_list
this.Control[iCurrent+6]=this.rb_receipt
this.Control[iCurrent+7]=this.ddlb_supplier_code
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.st_5
this.Control[iCurrent+10]=this.sle_1
this.Control[iCurrent+11]=this.tab_1
this.Control[iCurrent+12]=this.ddlb_carrying_out_type
this.Control[iCurrent+13]=this.st_6
this.Control[iCurrent+14]=this.uo_dateset
this.Control[iCurrent+15]=this.ddlb_dept_code
this.Control[iCurrent+16]=this.st_7
this.Control[iCurrent+17]=this.st_8
this.Control[iCurrent+18]=this.sle_gen_new_group
this.Control[iCurrent+19]=this.gb_1
this.Control[iCurrent+20]=this.gb_2
end on

on w_com_carrying_out_master.destroy
call super::destroy
destroy(this.uo_dateend)
destroy(this.ddlb_item_code)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.rb_list)
destroy(this.rb_receipt)
destroy(this.ddlb_supplier_code)
destroy(this.st_1)
destroy(this.st_5)
destroy(this.sle_1)
destroy(this.tab_1)
destroy(this.ddlb_carrying_out_type)
destroy(this.st_6)
destroy(this.uo_dateset)
destroy(this.ddlb_dept_code)
destroy(this.st_7)
destroy(this.st_8)
destroy(this.sle_gen_new_group)
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
F_MENU_CONTROL('DATA_CONTROL' ,TRUE)  // All Data Control





end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

event ue_data_control;call super::ue_data_control;long row
string lvs_date
double lvd_seq
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
			dw_1.reset()
			dw_2.reset()
			dw_3.reset()
			if rb_list.checked = true  then 
			    dw_1.retrieve(ddlb_item_code.text() + '%', ddlb_supplier_code.text +'%', uo_dateset.text(), uo_dateend.text(),  ddlb_carrying_out_type.getcode( )+'%' ,  ddlb_dept_code.getcode( )+'%' ,  sle_gen_new_group.text +'%' , gvi_organization_id)
			else
				dw_3.retrieve(ddlb_item_code.text() + '%', ddlb_supplier_code.text +'%',uo_dateset.text() , uo_dateend.text(),   ddlb_carrying_out_type.getcode( )+'%' , sle_gen_new_group.text +'%' ,  gvi_organization_id)
			end if 
	
    case 'INSERT'
		
		
			if tab_1.tabpage_1.sle_group_no.text = '' or isnull(tab_1.tabpage_1.sle_group_no.text) then 
				tab_1.tabpage_1.cb_group_no.triggerevent(clicked!)
			end if 
			ROW = DW_2.INSERTROW(DW_2.GETROW())
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')
			lvd_seq = f_get_sequence('seq_carrying_out')
			lvs_date = string(f_t_sysdate(),'yyyymmdd') + string(lvd_seq)
			dw_2.object.carrying_out_date[row] = f_sysdate()
			dw_2.object.carrying_out_seq[row] = lvd_seq
			dw_2.object.invoice_no[row] = lvs_date+string(lvd_seq)		

			dw_2.object.bring_in_yn[row] = 'Y' //$$HEX8$$18bc85c774d57cc5200058d594b2c0c9$$ENDHEX$$
			dw_2.object.confirm_yn[row] = 'N'			
			dw_2.object.complete_yn[row] = 'N'						
			dw_2.object.gate_guard_confirm_yn[row] = 'N'									
			dw_2.object.car_no[row] = '*'					
			dw_2.object.carrying_out_group_no[row] = tab_1.tabpage_1.sle_group_no.text
			dw_2.object.request_status[row] = 'W'			
		
			
	case 'APPEND'	
		
			if tab_1.tabpage_1.sle_group_no.text = '' or isnull(tab_1.tabpage_1.sle_group_no.text) then 
				tab_1.tabpage_1.cb_group_no.triggerevent(clicked!)
			end if 		
			
			ROW = DW_2.INSERTROW(DW_2.GETROW())
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')	
			lvd_seq = f_get_sequence('seq_carrying_out')
			lvs_date = string(f_t_sysdate(),'yyyymmdd') + string(lvd_seq)
			dw_2.object.carrying_out_date[row] = f_t_sysdate()
			dw_2.object.carrying_out_seq[row] = lvd_seq
			dw_2.object.invoice_no[row] = lvs_date+string(lvd_seq)		
			
			dw_2.object.bring_in_yn[row] = 'Y' //$$HEX8$$18bc85c774d57cc5200058d594b2c0c9$$ENDHEX$$
			dw_2.object.confirm_yn[row] = 'N'
			dw_2.object.complete_yn[row] = 'N'
			dw_2.object.gate_guard_confirm_yn[row] = 'N'
			dw_2.object.car_no[row] = '*'
			dw_2.object.carrying_out_group_no[row] = tab_1.tabpage_1.sle_group_no.text			
			dw_2.object.request_status[row] = 'W'						
	case 'DELETE'
		
		  	if DW_1.AcceptText() = -1 then
				return
			end if
			
			if dw_1.object.confirm_yn[dw_1.getrow()] = 'Y' or dw_1.object.complete_yn[dw_1.getrow()] = 'Y' then
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
   case 'UPDATE'
		
		
				dw_1.accepttext()
				dw_2.accepttext()				
				msg = f_msgbox(1170)
				if msg = 1 then 
				else
					return 
				end if 
				
				if  dw_1.update() < 0 or dw_2.update() < 0 then 
					rollback; 
					f_msg_mdi_help(f_msg_st(9026))
				else
					commit; 
					f_msg_mdi_help(f_msg_st(170))
					DW_1.RESET()
					dw_1.retrieve(ddlb_item_code.text() + '%', ddlb_supplier_code.text +'%', uo_dateset.text(), uo_dateend.text(),  ddlb_carrying_out_type.getcode( )+'%' ,  ddlb_dept_code.getcode( )+'%' ,  sle_gen_new_group.text +'%' ,gvi_organization_id)
				end if 
				
	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_com_carrying_out_master
integer y = 596
end type

type dw_4 from w_main_root`dw_4 within w_com_carrying_out_master
integer y = 596
integer width = 4544
integer height = 1124
boolean titlebar = true
string title = "Material Receipt Invoice Report"
string dataobject = "d_man_carrying_out_invoice_rpt"
end type

type dw_3 from w_main_root`dw_3 within w_com_carrying_out_master
integer y = 596
integer width = 4544
integer height = 1120
boolean titlebar = true
string title = "Carrying OUT History"
string dataobject = "d_man_carrying_out_hst"
end type

event dw_3::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return

dw_2.retrieve( this.object.rowid[currentrow])
end event

type dw_2 from w_main_root`dw_2 within w_com_carrying_out_master
integer y = 1716
integer width = 4549
integer height = 840
boolean titlebar = true
string title = "Carrying OUT Master"
string dataobject = "d_man_carrying_out_mst"
boolean hsplitscroll = false
boolean livescroll = false
borderstyle borderstyle = styleraised!
end type

event dw_2::itemchanged;call super::itemchanged;string lvs_return
//if dwo.name = 'carrying_out_receiptor' then 
//	lvs_return = f_get_supplier_name(data , gvi_organization_id)
//	if lvs_return = 'ERROR' then 
//		return 1 
//	end if  
//	if lvs_return = 'NOTFOUND' then 
//		return 1 
//	end if
//	
//	this.object.comments[row] = this.object.comments[row] + '  '+lvs_return 
//end if 
//
//if dwo.name = 'carrying_out_item' then 
//	
//     lvs_return = f_set_item_name_spec_uom( this , row , this.object.carrying_out_item[row] )		
//
//	if 	lvs_return = 'ERROR' THEN 
//		return 1
//	end if	
//		
//	if lvs_return = 'NOTFOUND' then 
//		return 1  
//	end if 		
//end if

if dwo.name = 'carrying_out_type' then 
	
	if data = 'C'  then //$$HEX10$$80acacc058c7b0b874ba200090c7d9b324c115c8$$ENDHEX$$
		this.object.carrying_out_division[row] = 'I' // $$HEX4$$d0c690c7acc72000$$ENDHEX$$
	end if 
end if 
end event

event dw_2::rbuttondown;call super::rbuttondown;//========================================================
//
//========================================================
if dwo.name = 'carrying_out_receiptor' then 
	open(w_com_supplier_popup)
	if message.stringparm = '' then 
	else
		this.object.carrying_out_receiptor[row] = message.stringparm

	end if
end if 
//========================================================
//
//========================================================
if dwo.name = 'carrying_out_item' then 
	
	if this.object.carrying_out_division[row] = 'A'  OR this.object.carrying_out_division[row] = 'P'  then 
	//$$HEX10$$18bc1cc888d420001cc888d4200074c774ba2000$$ENDHEX$$
			open(w_des_item_popup)
			if gst_return.gvb_return = false then 
			else
				this.object.carrying_out_item[row] = MESSAGE.STRINGPARM
				this.object.carrying_out_item_spec[row] = gst_return.gvs_return[4] 
			end if 
			gst_return.gvs_return[4] = ''	
			
//========================================================
//
//========================================================
	elseif this.object.carrying_out_division[row] = 'I'  then 
	//$$HEX7$$d0c6acc7ccb8200074c774ba2000$$ENDHEX$$
	
		if this.object.carrying_out_type[row] = 'C' then //$$HEX15$$80acacc058c7b0b8200074ba1cc12000d0c6acc7ccb8200074c774ba2000$$ENDHEX$$
		
		open(w_qc_wqc_inspect_outside_request_popup)
			if gst_return.gvb_return = false then 
			else
				this.object.carrying_out_item[row] = gst_return.gvs_return[1] 
				this.object.carrying_out_item_spec[row] = gst_return.gvs_return[3] 
				this.object.carrying_out_qty[row] = gst_return.gvf_return[1] 				
			end if 
			gst_return.gvs_return[1] = ''
			gst_return.gvs_return[3] = ''
		
		
		else
			//$$HEX10$$80acacc058c7b0b800ac200044c5c8b274ba2000$$ENDHEX$$
			open(w_des_item_popup)
			if gst_return.gvb_return = false then 
			else
				this.object.carrying_out_item[row] = MESSAGE.STRINGPARM
				this.object.carrying_out_item_spec[row] = gst_return.gvs_return[4] 
			end if 
			gst_return.gvs_return[4] = ''
		end if 
//========================================================
////$$HEX6$$24c144be200074c774ba2000$$ENDHEX$$
//========================================================
	elseif this.object.carrying_out_division[row] = 'M'  then 
		
		open( w_mcn_master_popup)
			if gst_return.gvb_return = false then 
			else
				this.object.carrying_out_item[row] =message.stringparm
				this.object.carrying_out_item_spec[row] = gst_return.gvs_return[1] 
			end if 
			gst_return.gvs_return[1] = ''
//========================================================
// //$$HEX11$$08ae15d62000c0c9f8ad200034d2200074c774ba2000$$ENDHEX$$
//========================================================		
	elseif  this.object.carrying_out_division[row] = 'J'  or this.object.carrying_out_division[row] = 'T' then
		
		open(w_mcn_mold_popup)
			if gst_return.gvb_return = false then 
			else
				this.object.carrying_out_item[row] = message.stringparm
				this.object.carrying_out_item_spec[row] = gst_return.gvs_return[1] 
			end if 
			gst_return.gvs_return[1] = ''
	else
		
	end if
			
end if 
//===============================================		
if dwo.name = 'carrying_out_by' then 
	
	open(w_user_popup )
	
	if message.stringparm = '' then 
	else
		
		this.object.carrying_out_by[row] = message.stringparm

	end if
	
end if		

if dwo.name = 'confirm_by' then 
	
	open(w_user_4_bring_in_out_confirm_popup )
	
	if message.stringparm = '' then 
	else

		if Gst_return.gvs_return[1] = 'Y' then
			this.object.confirm_by[row] = message.stringparm			
			this.object.confirm_yn[row] = 'Y'
			this.object.confirm_date[row] = f_sysdate()
		else
			this.object.confirm_by[row] = message.stringparm						
			this.object.confirm_yn[row] = 'N'			
		end if 

	end if
	
end if		

if dwo.name = 'confirm_by2' then 
	
	open(w_user_4_bring_in_out_confirm_popup )
	
	if message.stringparm = '' then 
	else

		if Gst_return.gvs_return[1] = 'Y' then
			this.object.confirm_by2[row] = message.stringparm			
			this.object.confirm_yn2[row] = 'Y'
			this.object.confirm_date2[row] = f_sysdate()
		else
			this.object.confirm_by2[row] = message.stringparm						
			this.object.confirm_yn2[row] = 'N'			
		end if 

	end if
	
end if		
end event

type dw_1 from w_main_root`dw_1 within w_com_carrying_out_master
integer y = 596
integer width = 4544
integer height = 1128
boolean titlebar = true
string title = "Carrying OUT List"
string dataobject = "d_man_carrying_out_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return
dw_2.retrieve( this.object.rowid[currentrow])

if this.object.confirm_yn[currentrow] = 'Y' then
	tab_1.tabpage_2.cb_print.enabled = true
else
	tab_1.tabpage_2.cb_print.enabled = false
end if

end event

event dw_1::doubleclicked;call super::doubleclicked;if row < 1 then return

if this.object.confirm_yn[row] = 'Y' then
	tab_1.tabpage_2.cb_print.enabled = true
else
	tab_1.tabpage_2.cb_print.enabled = false
end if

end event

type uo_tabpages from w_main_root`uo_tabpages within w_com_carrying_out_master
end type

type uo_dateend from uo_ymd_calendar within w_com_carrying_out_master
event destroy ( )
integer x = 2126
integer y = 160
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_item_code from uo_item_code within w_com_carrying_out_master
integer x = 750
integer y = 160
integer width = 517
integer taborder = 20
boolean bringtotop = true
end type

type st_3 from so_statictext within w_com_carrying_out_master
integer x = 750
integer y = 80
integer width = 517
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type st_4 from so_statictext within w_com_carrying_out_master
integer x = 1714
integer y = 80
integer width = 814
boolean bringtotop = true
integer weight = 700
string text = "Date"
end type

type rb_list from so_radiobutton within w_com_carrying_out_master
integer x = 55
integer y = 80
integer width = 617
boolean bringtotop = true
integer weight = 700
string text = "Carrying OUT List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1




end event

type rb_receipt from so_radiobutton within w_com_carrying_out_master
integer x = 55
integer y = 184
integer width = 622
boolean bringtotop = true
integer weight = 700
string text = "Carrying OUT History"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3



end event

type ddlb_supplier_code from uo_supplier_code within w_com_carrying_out_master
integer x = 1271
integer y = 160
integer width = 439
integer taborder = 20
boolean bringtotop = true
end type

type st_1 from so_statictext within w_com_carrying_out_master
integer x = 1271
integer y = 80
integer width = 439
boolean bringtotop = true
integer weight = 700
string text = "Supplier Code"
end type

type st_5 from so_statictext within w_com_carrying_out_master
integer x = 2537
integer y = 84
integer width = 457
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Item Spec"
end type

type sle_1 from so_singlelineedit within w_com_carrying_out_master
integer x = 2537
integer y = 160
integer width = 457
integer height = 84
integer taborder = 60
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

LVS_COLUMN = 'CARRYING_OUT_ITEM_SPEC'
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

type tab_1 from tab within w_com_carrying_out_master
event create ( )
event destroy ( )
integer x = 5
integer y = 308
integer width = 4142
integer height = 284
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean fixedwidth = true
boolean raggedright = true
boolean focusonbuttondown = true
boolean powertips = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 4105
integer height = 156
long backcolor = 15780518
string text = "Process"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Regenerate5!"
long picturemaskcolor = 536870912
cb_5 cb_5
cb_4 cb_4
cb_3 cb_3
rb_6 rb_6
rb_5 rb_5
rb_4 rb_4
sle_group_no sle_group_no
cb_group_no cb_group_no
cb_2 cb_2
end type

on tabpage_1.create
this.cb_5=create cb_5
this.cb_4=create cb_4
this.cb_3=create cb_3
this.rb_6=create rb_6
this.rb_5=create rb_5
this.rb_4=create rb_4
this.sle_group_no=create sle_group_no
this.cb_group_no=create cb_group_no
this.cb_2=create cb_2
this.Control[]={this.cb_5,&
this.cb_4,&
this.cb_3,&
this.rb_6,&
this.rb_5,&
this.rb_4,&
this.sle_group_no,&
this.cb_group_no,&
this.cb_2}
end on

on tabpage_1.destroy
destroy(this.cb_5)
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.rb_6)
destroy(this.rb_5)
destroy(this.rb_4)
destroy(this.sle_group_no)
destroy(this.cb_group_no)
destroy(this.cb_2)
end on

type cb_5 from so_commandbutton within tabpage_1
integer x = 1883
integer y = 28
integer width = 443
integer height = 112
integer taborder = 40
string text = "Request"
end type

event clicked;call super::clicked;string lvs_group_no 
if dw_1.rowcount( ) < 1 then return

if dw_1.object.request_status[dw_1.getrow()] = 'R' and  dw_1.object.confirm_yn[dw_1.getrow()] = 'N'  then
		F_MSGBOX1(125 , "Request")
		return
end if 

if dw_1.object.confirm_yn[dw_1.getrow()] = 'Y' then
		F_MSGBOX1(125 , "Confirm")
		return
end if 

msg = f_msgbox1(1161 , this.text ) 
if msg = 1 then 
	
		lvs_group_no = dw_1.object.carrying_out_group_no[dw_1.getrow()]
		
		update iman_carrying_out set request_status = 'R'
		where carrying_out_group_no = :lvs_group_no
			 and NVL(request_status ,'W') = 'W'
			  OR NVL(request_status ,'B') = 'B'
			and NVL(confirm_yn , 'N' ) in (  'N'  , 'R' )
			 and organization_id = :gvi_organization_id ;
			 
		if f_sql_check() < 0 then 
			return 
		end if 
		commit ;
		
		f_retrieve()

end if 
end event

type cb_4 from so_commandbutton within tabpage_1
integer x = 1440
integer y = 28
integer width = 443
integer height = 112
integer taborder = 120
string text = "Group Change"
end type

event clicked;call super::clicked;if sle_group_no.text = '' or isnull(sle_group_no) then return 
if dw_1.object.confirm_yn[dw_1.getrow()]  = "Y" then
	f_msgbox1(821 , f_get_dual_lang_text(gvs_language , "Confirm"))
else
	dw_1.object.carrying_out_group_no[dw_1.getrow()] = sle_group_no.text
end if 


end event

type cb_3 from so_commandbutton within tabpage_1
integer x = 997
integer y = 28
integer width = 443
integer height = 112
integer taborder = 110
string text = "Copy"
end type

event clicked;call super::clicked;int lvi_row
String lvs_date
Double lvd_seq
string lvs_customer_order_no
   		   Msg= F_MSGBOX( 9016 ) 			
		   IF MSG = 1 THEN 
			
				dw_2.selectrow( 0 , FALSE)
				lvi_row  = dw_2.GetRow()
				
				dw_2.RowsCopy(dw_2.GetRow(), dw_2.GetRow(), Primary!, dw_2, dw_2.GetRow(), Primary!)
				dw_2.SCROLLTOROW(lvi_row)
				dw_2.SELECTROW(lvi_row , TRUE)
				lvd_seq = f_get_sequence('seq_carrying_out')
				lvs_date = string(f_t_sysdate(),'yyyymmdd') + string(lvd_seq)
				dw_2.object.carrying_out_date[lvi_row] = f_sysdate()
				dw_2.object.carrying_out_seq[lvi_row] = lvd_seq
				dw_2.object.invoice_no[lvi_row] = lvs_date+string(lvd_seq)	
			ELSE
				 RETURN
			END IF
end event

type rb_6 from so_radiobutton within tabpage_1
integer x = 3461
integer y = 20
integer width = 233
integer height = 56
boolean bringtotop = true
integer weight = 700
long backcolor = 15780518
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.setfilter( '')
dw_1.filter( )
end event

type rb_5 from so_radiobutton within tabpage_1
integer x = 3698
integer y = 80
integer width = 407
integer height = 56
boolean bringtotop = true
integer weight = 700
long backcolor = 15780518
string text = "Bring In = N"
end type

event clicked;call super::clicked;dw_1.setfilter("BRING_IN_YN ='"+"N"+"'")
dw_1.filter( )
end event

type rb_4 from so_radiobutton within tabpage_1
integer x = 3698
integer y = 20
integer width = 407
integer height = 56
boolean bringtotop = true
integer weight = 700
long backcolor = 15780518
string text = "Bring IN = Y"
end type

event clicked;call super::clicked;dw_1.setfilter("BRING_IN_YN ='"+"Y"+"'")
dw_1.filter( )
end event

type sle_group_no from so_singlelineedit within tabpage_1
integer x = 462
integer y = 44
integer taborder = 90
end type

type cb_group_no from so_commandbutton within tabpage_1
integer x = 5
integer y = 28
integer width = 443
integer height = 104
integer taborder = 80
string text = "Gen New Group"
end type

event clicked;call super::clicked;SLE_GROUP_NO.TEXT = STRING(F_T_SYSDATE(), 'yymmdd')+STRING(f_get_sequence( 'SEQ_CARRYING_OUT_GROUP' ))
end event

type cb_2 from so_commandbutton within tabpage_1
integer x = 2327
integer y = 28
integer width = 631
integer height = 112
integer taborder = 90
string text = "Show Inspect Request"
end type

event clicked;call super::clicked;//====================================================
//
//====================================================
		if ivs_set_column_dddw1 = 'Y' then 
		else
		   f_set_column_dddw( dw_1 )
		   ivs_set_column_dddw1 = 'Y'		
		end if
		
		if ivs_set_column_dddw2 = 'Y' then 
		else
		   f_set_column_dddw( dw_2 )
		   ivs_set_column_dddw2 = 'Y'		
		end if
		if ivs_set_column_dddw3 = 'Y' then 
		else
		   f_set_column_dddw( dw_3 )
		   ivs_set_column_dddw3 = 'Y'		
		end if
		if ivs_set_column_dddw4 = 'Y' then 
		else
		   f_set_column_dddw( dw_4 )
		   ivs_set_column_dddw4 = 'Y'		
		end if
		if ivs_set_column_dddw5 = 'Y' then 
		else
		   f_set_column_dddw( dw_5 )
		   ivs_set_column_dddw5 = 'Y'		
		end if
		
//====================================================
//
//====================================================		
openwithparm(w_qc_wqc_inspect_outside_request_popup , dw_2)
end event

type tabpage_2 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 4105
integer height = 156
long backcolor = 15780518
string text = "Print"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Print!"
long picturemaskcolor = 536870912
rb_3 rb_3
rb_2 rb_2
rb_1 rb_1
cb_print cb_print
cb_preview cb_preview
cbx_dialog cbx_dialog
em_copy em_copy
st_2 st_2
end type

on tabpage_2.create
this.rb_3=create rb_3
this.rb_2=create rb_2
this.rb_1=create rb_1
this.cb_print=create cb_print
this.cb_preview=create cb_preview
this.cbx_dialog=create cbx_dialog
this.em_copy=create em_copy
this.st_2=create st_2
this.Control[]={this.rb_3,&
this.rb_2,&
this.rb_1,&
this.cb_print,&
this.cb_preview,&
this.cbx_dialog,&
this.em_copy,&
this.st_2}
end on

on tabpage_2.destroy
destroy(this.rb_3)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.cb_print)
destroy(this.cb_preview)
destroy(this.cbx_dialog)
destroy(this.em_copy)
destroy(this.st_2)
end on

type rb_3 from so_radiobutton within tabpage_2
integer x = 1893
integer y = 48
integer width = 315
integer weight = 700
long backcolor = 15780518
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.setfilter( '')
dw_1.filter( )
end event

type rb_2 from so_radiobutton within tabpage_2
integer x = 2661
integer y = 48
integer width = 288
integer weight = 700
long backcolor = 15780518
string text = "Wait"
end type

event clicked;call super::clicked;dw_1.setfilter("confirm_yn <>'"+'Y'+"'")
dw_1.filter( )
end event

type rb_1 from so_radiobutton within tabpage_2
integer x = 2258
integer y = 48
integer width = 402
integer weight = 700
long backcolor = 15780518
string text = "Confirmed"
end type

event clicked;call super::clicked;dw_1.setfilter("confirm_yn = '"+'Y'+"'")
dw_1.filter( )
end event

type cb_print from so_commandbutton within tabpage_2
integer x = 1024
integer y = 32
integer width = 361
integer height = 108
integer taborder = 100
boolean bringtotop = true
string text = "Print"
end type

event clicked;call super::clicked;Int		i, lvi_cnt , rows

If dw_4.rowcount() < 1 Then Return

	if dw_1.object.confirm_yn[dw_1.getrow()] = 'Y' then

	else
		Messagebox("Notify" , "Not Confirmed Can`t Print Invoice")
		return		
	end if 

		lvi_cnt = Integer(em_copy.text)
		If lvi_cnt > 0 Then
			If rb_list.checked = True Then
					
					if cbx_dialog.checked = true then 
						
						openwithparm(w_zetprint , dw_4 )
						
					else
						For i = 1 To lvi_cnt						
							dw_4.print(false, False)						
						NEXT
					end if

			End If
		End If

end event

type cb_preview from so_commandbutton within tabpage_2
integer x = 658
integer y = 32
integer width = 361
integer height = 108
integer taborder = 60
boolean bringtotop = true
string text = "Preview"
end type

event clicked;call super::clicked;if rb_list.checked = true then 
	if  ivs_preview_yn = 'Y' THEN 
		ivs_preview_yn = 'N' 	
		dw_1.bringtotop = TRUE
	else
		
		if dw_1.getrow() < 1 then return
		ivs_preview_yn = 'Y' 	
		dw_4.bringtotop = TRUE	
		dw_4.retrieve( dw_1.object.carrying_out_group_no[dw_1.getrow()] , gvi_organization_id )

		if dw_4.Describe("DataWindow.Print.Preview") = '!' or dw_4.Describe("DataWindow.Print.Preview") = '?' then
		else
		     dw_4.Modify("DataWindow.Print.Preview=yes")
			dw_4.Modify("DataWindow.Print.Preview.Rulers=yes")
		end if		
			//dw_4.object.ole_barcode.object.value(string(dw_1.object.carrying_out_group_no[dw_1.getrow()]))		  		
	end if
end if
	
end event

type cbx_dialog from so_checkbox within tabpage_2
integer x = 1403
integer y = 40
integer width = 393
boolean bringtotop = true
integer weight = 700
long backcolor = 15780518
string text = "Show Dialog"
end type

type em_copy from so_editmask within tabpage_2
integer x = 338
integer y = 44
integer width = 311
integer taborder = 60
boolean bringtotop = true
string text = "1"
string mask = "##0"
boolean spin = true
end type

type st_2 from so_statictext within tabpage_2
integer x = 14
integer y = 56
integer width = 311
integer height = 56
boolean bringtotop = true
integer weight = 700
long backcolor = 15780518
string text = "Print Copy"
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 4105
integer height = 156
long backcolor = 12632256
string text = "Complete"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Custom038!"
long picturemaskcolor = 536870912
rb_gt rb_gt
rb_all rb_all
cb_1 cb_1
end type

on tabpage_3.create
this.rb_gt=create rb_gt
this.rb_all=create rb_all
this.cb_1=create cb_1
this.Control[]={this.rb_gt,&
this.rb_all,&
this.cb_1}
end on

on tabpage_3.destroy
destroy(this.rb_gt)
destroy(this.rb_all)
destroy(this.cb_1)
end on

type rb_gt from so_radiobutton within tabpage_3
integer x = 1056
integer y = 36
integer width = 581
boolean bringtotop = true
integer weight = 700
string text = "Remain Qty = 0"
end type

event clicked;call super::clicked;dw_1.setfilter('remain_qty = 0 ')
dw_1.filter( )
end event

type rb_all from so_radiobutton within tabpage_3
integer x = 594
integer y = 40
integer width = 389
boolean bringtotop = true
integer weight = 700
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.setfilter( '')
dw_1.filter( )
end event

type cb_1 from so_commandbutton within tabpage_3
integer x = 37
integer y = 28
integer height = 100
integer taborder = 70
string text = "Batch Complete"
end type

event clicked;call super::clicked;int i , j 

do
	
	i++
	if dw_1.object.check_yn[i] = 'Y' then
	else
		continue
	end if
	
	dw_1.object.complete_yn[i] = 'Y' 
	
	j++
loop until i = dw_1.rowcount( )	


msg = f_msgbox1( 9014 , string(j) )
if msg = 1 then 
	f_update()
else
end if 

f_retrieve()
end event

type ddlb_carrying_out_type from uo_basecode within w_com_carrying_out_master
integer x = 2999
integer y = 160
integer width = 539
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;THIS.REdraw( 'CARRYING OUT TYPE')
end event

type st_6 from so_statictext within w_com_carrying_out_master
integer x = 2999
integer y = 88
integer width = 539
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Carrying Out Type"
end type

type uo_dateset from uo_ymd_calendar within w_com_carrying_out_master
event destroy ( )
integer x = 1710
integer y = 160
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_dept_code from uo_department_code within w_com_carrying_out_master
integer x = 3547
integer y = 156
integer height = 1540
integer taborder = 50
boolean bringtotop = true
end type

type st_7 from so_statictext within w_com_carrying_out_master
integer x = 3547
integer y = 88
integer width = 608
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Department Code"
end type

type st_8 from so_statictext within w_com_carrying_out_master
integer x = 4155
integer y = 80
integer width = 457
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Gen New Group"
end type

type sle_gen_new_group from so_singlelineedit within w_com_carrying_out_master
integer x = 4174
integer y = 156
integer width = 457
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

type gb_1 from so_groupbox within w_com_carrying_out_master
integer width = 709
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_com_carrying_out_master
integer x = 718
integer width = 4000
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

