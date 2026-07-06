HA$PBExportHeader$w_mat_request_master.srw
$PBExportComments$Material Request Master
forward
global type w_mat_request_master from w_main_root
end type
type st_1 from so_statictext within w_mat_request_master
end type
type ddlb_item_code from uo_item_code within w_mat_request_master
end type
type st_3 from so_statictext within w_mat_request_master
end type
type uo_dateset from uo_ymd_calendar within w_mat_request_master
end type
type uo_dateend from uo_ymd_calendar within w_mat_request_master
end type
type rb_all from so_radiobutton within w_mat_request_master
end type
type rb_wait from so_radiobutton within w_mat_request_master
end type
type rb_complete from so_radiobutton within w_mat_request_master
end type
type cb_preview from so_commandbutton within w_mat_request_master
end type
type cbx_dialog from so_checkbox within w_mat_request_master
end type
type em_copy from so_editmask within w_mat_request_master
end type
type st_4 from so_statictext within w_mat_request_master
end type
type cb_print from so_commandbutton within w_mat_request_master
end type
type ddlb_department_code from uo_department_code within w_mat_request_master
end type
type st_2 from so_statictext within w_mat_request_master
end type
type rb_inventory_list from so_radiobutton within w_mat_request_master
end type
type rb_request_list from so_radiobutton within w_mat_request_master
end type
type cb_group_no from so_commandbutton within w_mat_request_master
end type
type sle_group_no from so_singlelineedit within w_mat_request_master
end type
type gb_1 from so_groupbox within w_mat_request_master
end type
type gb_4 from so_groupbox within w_mat_request_master
end type
type gb_6 from so_groupbox within w_mat_request_master
end type
type gb_2 from so_groupbox within w_mat_request_master
end type
end forward

global type w_mat_request_master from w_main_root
integer width = 4736
integer height = 2904
string title = "Repair Material Request"
st_1 st_1
ddlb_item_code ddlb_item_code
st_3 st_3
uo_dateset uo_dateset
uo_dateend uo_dateend
rb_all rb_all
rb_wait rb_wait
rb_complete rb_complete
cb_preview cb_preview
cbx_dialog cbx_dialog
em_copy em_copy
st_4 st_4
cb_print cb_print
ddlb_department_code ddlb_department_code
st_2 st_2
rb_inventory_list rb_inventory_list
rb_request_list rb_request_list
cb_group_no cb_group_no
sle_group_no sle_group_no
gb_1 gb_1
gb_4 gb_4
gb_6 gb_6
gb_2 gb_2
end type
global w_mat_request_master w_mat_request_master

type variables
string ivs_preview_yn = 'N' 	
end variables

on w_mat_request_master.create
int iCurrent
call super::create
this.st_1=create st_1
this.ddlb_item_code=create ddlb_item_code
this.st_3=create st_3
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.rb_all=create rb_all
this.rb_wait=create rb_wait
this.rb_complete=create rb_complete
this.cb_preview=create cb_preview
this.cbx_dialog=create cbx_dialog
this.em_copy=create em_copy
this.st_4=create st_4
this.cb_print=create cb_print
this.ddlb_department_code=create ddlb_department_code
this.st_2=create st_2
this.rb_inventory_list=create rb_inventory_list
this.rb_request_list=create rb_request_list
this.cb_group_no=create cb_group_no
this.sle_group_no=create sle_group_no
this.gb_1=create gb_1
this.gb_4=create gb_4
this.gb_6=create gb_6
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.ddlb_item_code
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.uo_dateset
this.Control[iCurrent+5]=this.uo_dateend
this.Control[iCurrent+6]=this.rb_all
this.Control[iCurrent+7]=this.rb_wait
this.Control[iCurrent+8]=this.rb_complete
this.Control[iCurrent+9]=this.cb_preview
this.Control[iCurrent+10]=this.cbx_dialog
this.Control[iCurrent+11]=this.em_copy
this.Control[iCurrent+12]=this.st_4
this.Control[iCurrent+13]=this.cb_print
this.Control[iCurrent+14]=this.ddlb_department_code
this.Control[iCurrent+15]=this.st_2
this.Control[iCurrent+16]=this.rb_inventory_list
this.Control[iCurrent+17]=this.rb_request_list
this.Control[iCurrent+18]=this.cb_group_no
this.Control[iCurrent+19]=this.sle_group_no
this.Control[iCurrent+20]=this.gb_1
this.Control[iCurrent+21]=this.gb_4
this.Control[iCurrent+22]=this.gb_6
this.Control[iCurrent+23]=this.gb_2
end on

on w_mat_request_master.destroy
call super::destroy
destroy(this.st_1)
destroy(this.ddlb_item_code)
destroy(this.st_3)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.rb_all)
destroy(this.rb_wait)
destroy(this.rb_complete)
destroy(this.cb_preview)
destroy(this.cbx_dialog)
destroy(this.em_copy)
destroy(this.st_4)
destroy(this.cb_print)
destroy(this.ddlb_department_code)
destroy(this.st_2)
destroy(this.rb_inventory_list)
destroy(this.rb_request_list)
destroy(this.cb_group_no)
destroy(this.sle_group_no)
destroy(this.gb_1)
destroy(this.gb_4)
destroy(this.gb_6)
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
F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control





end event

event ue_post_open;call super::ue_post_open;

/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

event ue_data_control;call super::ue_data_control;Long row , lvl_seq

choose case gvs_ue_data_control
		
	case 'RETRIEVE'			
		
		if rb_inventory_list.checked = true then 
			dw_1.retrieve(ddlb_item_code.text() + '%',  gvi_organization_id)	
		else
			dw_4.retrieve(uo_dateset.text() , uo_dateend.text(), ddlb_item_code.text() + '%',ddlb_department_code.text + '%',  gvi_organization_id)		
		end if
		
	case 'INSERT'
		
		
			if sle_group_no.text = '' or isnull(sle_group_no.text) then 
				cb_group_no.triggerevent( clicked!)		
			end if
		
			DW_2.ENABLED = TRUE
			ROW = DW_2.INSERTROW(DW_2.GETROW())
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')
			dw_2.object.request_date[row] = f_t_sysdate()		
			lvl_seq = long(f_get_sequence( 'seq_mat_issue_request'))
			dw_2.object.request_sequence[row] = lvl_seq	
			dw_2.object.request_status[row] = 'R'
			dw_2.object.request_deficit[row] = '1'
			dw_2.object.issue_date[row] = f_t_sysdate()
			dw_2.object.issue_status[row] = 'N'
			dw_2.object.department_code[row] = Gvs_department_code
		
		if dw_1.getrow() > 0 then
			if  dw_1.object.warehouse_type[dw_1.getrow()] = 'INTERNAL' then
				dw_2.object.material_mfs[row] = dw_1.object.material_mfs[dw_1.getrow()] 
				dw_2.object.item_code[row] = dw_1.object.item_code[dw_1.getrow()]
				dw_2.object.line_type[row] = dw_1.object.line_type[dw_1.getrow()] 
			end if 
		 end if
			
			dw_2.object.request_group_no[row] = sle_group_no.text
			
	case 'APPEND'	
		
			if sle_group_no.text = '' or isnull(sle_group_no.text) then 
				cb_group_no.triggerevent( clicked!)		
			end if		
			DW_2.ENABLED = TRUE
			ROW = DW_2.INSERTROW(DW_2.GETROW())
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')	
			dw_2.object.request_date[row] = f_t_sysdate()
	
			lvl_seq =  long(f_get_sequence( 'seq_mat_issue_request'))
			dw_2.object.request_sequence[row] = lvl_seq
			dw_2.object.request_status[row] = 'R'
			dw_2.object.request_deficit[row] = '1'
			dw_2.object.issue_date[row] = f_t_sysdate()
			dw_2.object.issue_status[row] = 'N'
			dw_2.object.department_code[row] = Gvs_department_code
			dw_2.object.request_group_no[row] = sle_group_no.text			 
			  
		if dw_1.getrow() > 0 and dw_1.object.warehouse_type[dw_1.getrow()] = 'INTERNAL' then
			dw_2.object.material_mfs[row] = dw_1.object.material_mfs[dw_1.getrow()] 
			dw_2.object.item_code[row] = dw_1.object.item_code[dw_1.getrow()]
			dw_2.object.line_type[row] = dw_1.object.line_type[dw_1.getrow()] 
		 end if
		 
	case 'DELETE'
		
		  	if DW_2.AcceptText() = -1 then
				return
			end if
			
			if dw_2.object.request_status[dw_2.getrow()] = 'C' then
				Messagebox("Notify" , "Aready Issued Can`t Delete")
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
           
	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mat_request_master
integer y = 516
integer height = 348
end type

type dw_4 from w_main_root`dw_4 within w_mat_request_master
integer y = 516
integer width = 4114
integer height = 996
boolean titlebar = true
string title = "Material Request List"
string dataobject = "d_mat_issue_request_lst"
end type

event dw_4::rowfocuschanged;call super::rowfocuschanged;IF CURRENTROW = 0 THEN RETURN
//DW_2.reset()
//DW_3.reset()
DW_2.RETRIEVE( DW_4.GETITEMSTRING( CURRENTROW , 'ROWID' ) )
dw_3.retrieve(dw_4.object.request_group_no[currentrow], gvi_organization_id)
end event

event dw_4::doubleclicked;call super::doubleclicked;IF ROW < 1  THEN RETURN
//DW_2.reset()
//DW_3.reset()

dw_2.retrieve(dw_4.GETITEMSTRING( ROW , 'ROWID' ) )
dw_3.retrieve(dw_4.object.request_group_no[row], gvi_organization_id)

end event

type dw_3 from w_main_root`dw_3 within w_mat_request_master
integer y = 516
integer width = 4114
integer height = 996
boolean titlebar = true
string dataobject = "d_mat_request_rpt"
end type

type dw_2 from w_main_root`dw_2 within w_mat_request_master
integer x = 5
integer y = 1516
integer width = 4247
integer height = 792
string dataobject = "d_mat_issue_request_mst"
end type

event dw_2::itemchanged;call super::itemchanged;string lvs_return , lvs_item_code , lvs_supplier_code
Decimal lvd_qty , lvd_packing_qty, lvd_request_qty

if dwo.name = 'request_qty_org' then 
	lvs_item_code = this.object.item_code[row]
	lvd_qty = Dec(data)
	
	select issue_packing_qty 
		into   :lvd_packing_qty
		from  id_item
	 where item_code like :lvs_item_code 	
		and    dateset <= trunc(sysdate)
		and    dateend >= trunc(sysdate)
		and    organization_id = :gvi_organization_id ; 
		
	if f_sql_check() < 0 then return 
	
	if lvd_packing_qty > 0 then 
		lvd_request_qty = truncate(( lvd_qty / lvd_packing_qty) ,0) * lvd_packing_qty + lvd_packing_qty
	else
		return 
	end if 
	
	this.object.request_qty[row] = lvd_request_qty 

end if 

if dwo.name = 'item_code' then    
   lvs_return = f_set_item_name_spec_uom( this , row , this.object.item_code[row] )		
   if 	lvs_return = 'ERROR' THEN 
		return 1
   end if	
	if lvs_return = 'NOTFOUND' then 
		return 1  
	end if 		

end if
	
	


end event

event dw_2::rbuttondown;call super::rbuttondown;if dwo.name = 'item_code' then
	open(w_mat_item_popup )
	if gst_return.gvb_return = false then 
	else
		this.object.item_code[row] = gst_return.gvs_return[1]
		this.object.item_name[row] = gst_return.gvs_return[2]
		this.object.item_spec[row] = gst_return.gvs_return[3]	
		this.object.line_type[row] = gst_return.gvs_return[6]
	    this.object.item_uom[row] = gst_return.gvs_return[7]	
		 
		gst_return.gvs_return[1] = ''
		gst_return.gvs_return[2] = ''
		gst_return.gvs_return[3] = ''
		gst_return.gvs_return[6] = ''
		gst_return.gvs_return[7] = ''
		gst_return.gvs_return[8] = ''		 
		
	end if 

	
end if 
	
end event

event dw_2::dragdrop;call super::dragdrop;DATAWINDOW ldw_Source 
LONG Lvl_row , lvl_return

IF source.TypeOf() = DataWindow! THEN
   ldw_Source	= source
	
		IF ldw_Source  = THIS THEN 
		ELSE
			
				if row < 1 then // $$HEX15$$70c88cd61cb4200089d574c72000c6c544c72000bdacb0c6200085c725b8$$ENDHEX$$
					
					Lvl_row = this.insertrow(0)
					f_set_security_row( this , lvl_row , 'ALL')
					this.object.item_code[Lvl_row] = ldw_Source.object.item_code[ldw_Source.getrow()]	
					this.object.line_type[Lvl_row] = ldw_Source.object.line_type[ldw_Source.getrow()]					
					
					this.object.request_date[Lvl_row] =f_t_sysdate()	
					this.object.request_sequence[Lvl_row] = long(f_get_sequence( 'seq_mat_issue_request'))
					this.object.request_status[Lvl_row] ='W'
					this.object.request_deficit[Lvl_row] ='1'
					this.object.issue_date[Lvl_row] =f_t_sysdate()
					this.object.issue_status[Lvl_row] ='N'
				     this.object.department_code[lvl_row] = Gvs_department_code					
					
					trigger event itemchanged( lvl_row , this.object.item_code , this.object.item_code[Lvl_row] )
					
				else // $$HEX18$$74c7f8bb200070c88cd61cb4200089d5d0c5e4b22000dcb46db85cd52000bdacb0c62000$$ENDHEX$$

							f_set_security_row( this , row , 'ALL')
							this.object.item_code[row] = ldw_Source.object.item_code[ldw_Source.getrow()]			
							this.object.line_type[row] = ldw_Source.object.line_type[ldw_Source.getrow()]															
							
							this.object.request_date[row] =f_t_sysdate()	
							this.object.request_sequence[row] = long(f_get_sequence( 'seq_mat_issue_request'))
							this.object.request_status[row] ='W'
							this.object.request_deficit[row] ='1'
							this.object.issue_date[row] =f_t_sysdate()
							this.object.issue_status[row] ='N'
						     this.object.department_code[row] = Gvs_department_code										
							
							trigger event itemchanged( row , this.object.item_code , this.object.item_code[row] )							
				end if
		END IF		  
END IF

THIS.DRAG(END!)


end event

event dw_2::clicked;call super::clicked;if dwo.name = 'b_gen_mfs' then
	
	this.object.mfs[row] = string(f_sysdate() , 'yyyymmddhhmmss')
	
end if 
end event

type dw_1 from w_main_root`dw_1 within w_mat_request_master
integer y = 516
integer width = 4247
integer height = 996
boolean titlebar = true
string title = "Inventory List"
string dataobject = "d_mat_current_inventory_4_request_lst_tree"
end type

event dw_1::clicked;call super::clicked;IF UPPER(DWO.TYPE) = 'COLUMN' THEN
	DRAG(BEGIN!)
END IF
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_request_master
end type

type st_1 from so_statictext within w_mat_request_master
integer x = 1614
integer y = 92
integer width = 617
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mat_request_master
integer x = 1614
integer y = 164
integer width = 617
integer taborder = 20
boolean bringtotop = true
end type

type st_3 from so_statictext within w_mat_request_master
integer x = 800
integer y = 92
integer width = 809
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Issue Request Date"
end type

type uo_dateset from uo_ymd_calendar within w_mat_request_master
integer x = 791
integer y = 160
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_request_master
integer x = 1202
integer y = 164
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type rb_all from so_radiobutton within w_mat_request_master
integer x = 69
integer y = 400
integer width = 375
boolean bringtotop = true
integer weight = 700
string text = "All "
boolean checked = true
end type

event clicked;call super::clicked;
	dw_4.setfilter('')
	dw_4.filter()

end event

type rb_wait from so_radiobutton within w_mat_request_master
integer x = 526
integer y = 400
integer width = 375
boolean bringtotop = true
integer weight = 700
string text = "Request"
end type

event clicked;call super::clicked;
	dw_4.setfilter("request_status = 'R' ")
	dw_4.filter()

end event

type rb_complete from so_radiobutton within w_mat_request_master
integer x = 928
integer y = 396
integer width = 375
boolean bringtotop = true
integer weight = 700
string text = "Complete"
end type

event clicked;call super::clicked;
	dw_4.setfilter("request_status = 'C'")
	dw_4.filter()

end event

type cb_preview from so_commandbutton within w_mat_request_master
integer x = 3589
integer y = 76
integer width = 407
integer height = 100
integer taborder = 80
boolean bringtotop = true
string text = "Preview"
end type

event clicked;call super::clicked;
	if  ivs_preview_yn = 'Y' THEN 
		ivs_preview_yn = 'N' 	
		dw_4.bringtotop = TRUE
	else
		ivs_preview_yn = 'Y' 	
		dw_3.bringtotop = TRUE			
		if dw_3.Describe("DataWindow.Print.Preview") = '!' or dw_3.Describe("DataWindow.Print.Preview") = '?' then
		else
			 dw_3.Modify("DataWindow.Print.Preview=yes")
			 dw_3.Modify("DataWindow.Print.Preview.Rulers=yes")
		end if		
	end if


	
end event

type cbx_dialog from so_checkbox within w_mat_request_master
integer x = 2953
integer y = 192
integer width = 421
boolean bringtotop = true
integer weight = 700
string text = "Show Dialog"
end type

type em_copy from so_editmask within w_mat_request_master
integer x = 3282
integer y = 96
integer width = 288
integer taborder = 50
boolean bringtotop = true
string text = "1"
string mask = "##0"
boolean spin = true
end type

type st_4 from so_statictext within w_mat_request_master
integer x = 2958
integer y = 104
integer width = 329
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Print Copy"
end type

type cb_print from so_commandbutton within w_mat_request_master
integer x = 3589
integer y = 180
integer width = 407
integer height = 100
integer taborder = 80
boolean bringtotop = true
string text = "Print"
end type

event clicked;call super::clicked;Int		i, lvi_cnt , rows
If dw_3.rowcount() < 1 Then Return		
lvi_cnt = Integer(em_copy.text)
If lvi_cnt > 0 Then			
		For i = 1 To lvi_cnt					
			if cbx_dialog.checked = true then 
				dw_3.print(false, True)
			else
				dw_3.print(false, False)						
			end if
		Next			
End If

end event

type ddlb_department_code from uo_department_code within w_mat_request_master
integer x = 2240
integer y = 164
integer width = 494
integer taborder = 30
boolean bringtotop = true
end type

type st_2 from so_statictext within w_mat_request_master
integer x = 2240
integer y = 92
integer width = 494
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Department Code"
end type

type rb_inventory_list from so_radiobutton within w_mat_request_master
integer x = 46
integer y = 84
integer width = 645
boolean bringtotop = true
integer weight = 700
string text = "Inventory List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
selected_data_window = dw_1
end event

type rb_request_list from so_radiobutton within w_mat_request_master
integer x = 46
integer y = 192
integer width = 645
boolean bringtotop = true
integer weight = 700
string text = "Request List"
end type

event clicked;call super::clicked;dw_4.bringtotop = true
selected_data_window = dw_4
end event

type cb_group_no from so_commandbutton within w_mat_request_master
integer x = 1664
integer y = 372
integer width = 443
integer height = 120
integer taborder = 90
boolean bringtotop = true
string text = "Gen New Group"
end type

event clicked;call super::clicked;SLE_GROUP_NO.TEXT = STRING(F_T_SYSDATE(), 'yymmdd')+STRING(f_get_sequence( 'seq_mat_issue_request' ))
end event

type sle_group_no from so_singlelineedit within w_mat_request_master
integer x = 2117
integer y = 396
integer taborder = 100
boolean bringtotop = true
boolean displayonly = true
end type

type gb_1 from so_groupbox within w_mat_request_master
integer x = 745
integer width = 2171
integer height = 320
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_4 from so_groupbox within w_mat_request_master
integer y = 332
integer width = 1646
integer height = 176
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Request Status Filter"
end type

type gb_6 from so_groupbox within w_mat_request_master
integer x = 2917
integer width = 1111
integer height = 320
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Print Copy"
end type

type gb_2 from so_groupbox within w_mat_request_master
integer width = 736
integer height = 320
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

