HA$PBExportHeader$w_pln_product_delivery_master.srw
$PBExportComments$Planning Master Plan  Master
forward
global type w_pln_product_delivery_master from w_main_root
end type
type st_5 from so_statictext within w_pln_product_delivery_master
end type
type st_3 from statictext within w_pln_product_delivery_master
end type
type ddlb_customer_code from uo_customer_code within w_pln_product_delivery_master
end type
type sle_lot_no from so_singlelineedit within w_pln_product_delivery_master
end type
type cb_8 from so_commandbutton within w_pln_product_delivery_master
end type
type st_yyyymm from so_statictext within w_pln_product_delivery_master
end type
type cb_9 from so_commandbutton within w_pln_product_delivery_master
end type
type uo_dateend from uo_ymd_calendar within w_pln_product_delivery_master
end type
type uo_dateset from uo_ymd_calendar within w_pln_product_delivery_master
end type
type tab_1 from tab within w_pln_product_delivery_master
end type
type tabpage_1 from userobject within tab_1
end type
type em_plan_qty from so_editmask within tabpage_1
end type
type cb_1 from so_commandbutton within tabpage_1
end type
type tabpage_1 from userobject within tab_1
em_plan_qty em_plan_qty
cb_1 cb_1
end type
type tabpage_2 from userobject within tab_1
end type
type cb_17 from so_commandbutton within tabpage_2
end type
type cb_2 from so_commandbutton within tabpage_2
end type
type tabpage_2 from userobject within tab_1
cb_17 cb_17
cb_2 cb_2
end type
type tab_1 from tab within w_pln_product_delivery_master
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type rb_1 from so_radiobutton within w_pln_product_delivery_master
end type
type rb_3 from so_radiobutton within w_pln_product_delivery_master
end type
type rb_4 from so_radiobutton within w_pln_product_delivery_master
end type
type rb_5 from so_radiobutton within w_pln_product_delivery_master
end type
type ddlb_model_name from uo_set_model_name_ddlb within w_pln_product_delivery_master
end type
type st_4 from so_statictext within w_pln_product_delivery_master
end type
type rb_master_plan from so_radiobutton within w_pln_product_delivery_master
end type
type rb_month_plan from so_radiobutton within w_pln_product_delivery_master
end type
type rb_list from so_radiobutton within w_pln_product_delivery_master
end type
type gb_1 from so_groupbox within w_pln_product_delivery_master
end type
type gb_2 from so_groupbox within w_pln_product_delivery_master
end type
end forward

global type w_pln_product_delivery_master from w_main_root
integer width = 6569
integer height = 3784
string title = "Product Sale Plan"
st_5 st_5
st_3 st_3
ddlb_customer_code ddlb_customer_code
sle_lot_no sle_lot_no
cb_8 cb_8
st_yyyymm st_yyyymm
cb_9 cb_9
uo_dateend uo_dateend
uo_dateset uo_dateset
tab_1 tab_1
rb_1 rb_1
rb_3 rb_3
rb_4 rb_4
rb_5 rb_5
ddlb_model_name ddlb_model_name
st_4 st_4
rb_master_plan rb_master_plan
rb_month_plan rb_month_plan
rb_list rb_list
gb_1 gb_1
gb_2 gb_2
end type
global w_pln_product_delivery_master w_pln_product_delivery_master

on w_pln_product_delivery_master.create
int iCurrent
call super::create
this.st_5=create st_5
this.st_3=create st_3
this.ddlb_customer_code=create ddlb_customer_code
this.sle_lot_no=create sle_lot_no
this.cb_8=create cb_8
this.st_yyyymm=create st_yyyymm
this.cb_9=create cb_9
this.uo_dateend=create uo_dateend
this.uo_dateset=create uo_dateset
this.tab_1=create tab_1
this.rb_1=create rb_1
this.rb_3=create rb_3
this.rb_4=create rb_4
this.rb_5=create rb_5
this.ddlb_model_name=create ddlb_model_name
this.st_4=create st_4
this.rb_master_plan=create rb_master_plan
this.rb_month_plan=create rb_month_plan
this.rb_list=create rb_list
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_5
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.ddlb_customer_code
this.Control[iCurrent+4]=this.sle_lot_no
this.Control[iCurrent+5]=this.cb_8
this.Control[iCurrent+6]=this.st_yyyymm
this.Control[iCurrent+7]=this.cb_9
this.Control[iCurrent+8]=this.uo_dateend
this.Control[iCurrent+9]=this.uo_dateset
this.Control[iCurrent+10]=this.tab_1
this.Control[iCurrent+11]=this.rb_1
this.Control[iCurrent+12]=this.rb_3
this.Control[iCurrent+13]=this.rb_4
this.Control[iCurrent+14]=this.rb_5
this.Control[iCurrent+15]=this.ddlb_model_name
this.Control[iCurrent+16]=this.st_4
this.Control[iCurrent+17]=this.rb_master_plan
this.Control[iCurrent+18]=this.rb_month_plan
this.Control[iCurrent+19]=this.rb_list
this.Control[iCurrent+20]=this.gb_1
this.Control[iCurrent+21]=this.gb_2
end on

on w_pln_product_delivery_master.destroy
call super::destroy
destroy(this.st_5)
destroy(this.st_3)
destroy(this.ddlb_customer_code)
destroy(this.sle_lot_no)
destroy(this.cb_8)
destroy(this.st_yyyymm)
destroy(this.cb_9)
destroy(this.uo_dateend)
destroy(this.uo_dateset)
destroy(this.tab_1)
destroy(this.rb_1)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.rb_5)
destroy(this.ddlb_model_name)
destroy(this.st_4)
destroy(this.rb_master_plan)
destroy(this.rb_month_plan)
destroy(this.rb_list)
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
Ivs_resize_type                      = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

 ivs_dw_1_deleteselected_yn = 'N' 
 
ivs_dw_1_retrice_cancel_popup_open = 'Y'
ivs_dw_2_retrice_cancel_popup_open = 'Y'
ivs_dw_3_retrice_cancel_popup_open = 'Y'
ivs_dw_4_retrice_cancel_popup_open = 'N'
ivs_dw_5_retrice_cancel_popup_open = 'N'

ivs_dw_1_selected_row_yn = 'N'

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

end event

event ue_data_control;call super::ue_data_control;Long row , lvdb_seq
String  lvs_mfs

choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
		  if rb_master_plan.checked = true then 
		
				dw_1.reset()
				dw_1.retrieve( uo_dateset.text() , uo_dateend.text() ,ddlb_model_name.getcode() +'%',  gvi_organization_id)
				dw_1.setfocus()		
			elseif rb_month_plan.checked = true then 
				dw_2.reset()
				dw_2.retrieve( string(uo_dateset.text() , 'yyyymm')  , ddlb_model_name.getcode() +'%',  gvi_organization_id)
				dw_2.setfocus()		
			elseIF rb_LIST.CHECKED = TRUE THEN
	    		     dw_3.retrieve( ddlb_model_name.getcode() +'%', uo_dateset.text() , uo_dateend.text() ,  sle_lot_no.text+'%' , gvi_organization_id)	
			else
		    	     dw_4.retrieve(  uo_dateset.text() , uo_dateend.text() , ddlb_model_name.getcode() +'%',  gvi_organization_id)						
						
			end if 
			
	case 'INSERT'	
		
		 IF rb_master_plan.CHECKED = TRUE THEN 
					dw_1.ENABLED = TRUE
					ROW = dw_1.INSERTROW(dw_1.GETROW())
					dw_1.SCROLLTOROW(ROW)
					F_SET_SECURITY_ROW(dw_1 , ROW ,'ALL')
					
					dw_1.object.plan_date[row] = f_t_sysdate()		
					lvdb_seq = double(f_get_sequence( 'seq_plan_date_sequence'))
					dw_1.object.plan_sequence[row] = 	lvdb_seq
					dw_1.object.mfs[row] = 	'MI'+STRING(lvdb_seq)
				
					dw_1.object.line_code[row] = 	'*'	
					dw_1.object.parent_item_code[row] = '*'
					dw_1.object.item_code[row] = '*'
					dw_1.object.model_suffix[row] = '*'
					dw_1.object.actual_qty[row] = 0
					dw_1.object.plan_qty_d1[row] = 0
					dw_1.object.plan_qty_d2[row] = 0
					dw_1.object.plan_qty_d3[row] = 0
					dw_1.object.plan_time1[row] = 0
					dw_1.object.plan_time2[row] = 0
					dw_1.object.plan_time3[row] = 0
					dw_1.object.plan_time4[row] = 0						
					dw_1.object.plan_time5[row] = 0
					dw_1.object.plan_time6[row] = 0						
					dw_1.object.plan_time7[row] = 0
					dw_1.object.plan_time8[row] = 0
					dw_1.object.plan_time9[row] = 0
					dw_1.object.plan_time10[row] = 0						
					
				ELSE
					
							dw_2.ENABLED = TRUE
							ROW = dw_2.INSERTROW(dw_2.GETROW())
							dw_2.SCROLLTOROW(ROW)
							F_SET_SECURITY_ROW(dw_2 , ROW ,'ALL')
							dw_2.object.plan_ym[row] =  string( f_t_sysdate() , 'yyyymm') 					
					
					
				END IF 
	case 'APPEND'		
		
		
		 IF rb_master_plan.CHECKED = TRUE THEN 	
						 
					dw_1.ENABLED = TRUE
					ROW = dw_1.INSERTROW(dw_1.GETROW())
					dw_1.SCROLLTOROW(ROW)
					F_SET_SECURITY_ROW(dw_1 , ROW ,'ALL')
					
					dw_1.object.plan_date[row] = f_t_sysdate()		
					lvdb_seq = double(f_get_sequence( 'seq_plan_date_sequence'))
					dw_1.object.plan_sequence[row] = 	lvdb_seq
					 dw_1.object.mfs[row] = 	'DO'+STRING(lvdb_seq)
					dw_1.object.line_code[row] = 	'*'		
					dw_1.object.actual_qty[row] = 0
					dw_1.object.plan_qty_d1[row] = 0
					dw_1.object.plan_qty_d2[row] = 0
					dw_1.object.plan_qty_d3[row] = 0
					dw_1.object.parent_item_code[row] = '*'
					dw_1.object.model_suffix[row] = '*'
					dw_1.object.item_code[row] = '*'			
					
					dw_1.object.plan_time1[row] = 0
					dw_1.object.plan_time2[row] = 0
					dw_1.object.plan_time3[row] = 0
					dw_1.object.plan_time4[row] = 0						
					dw_1.object.plan_time5[row] = 0
					dw_1.object.plan_time6[row] = 0						
					dw_1.object.plan_time7[row] = 0
					dw_1.object.plan_time8[row] = 0
					dw_1.object.plan_time9[row] = 0
					dw_1.object.plan_time10[row] = 0						
			
		ELSE
							dw_2.ENABLED = TRUE
							ROW = dw_2.INSERTROW(dw_2.GETROW())
							dw_2.SCROLLTOROW(ROW)
							F_SET_SECURITY_ROW(dw_2 , ROW ,'ALL')
							dw_2.object.plan_ym[row] =  string( f_t_sysdate() , 'yyyymm') 							
			
		END IF 
			
	case 'DELETE'
				
				IF rb_master_plan.CHECKED = TRUE THEN 	
					
					if dw_1.AcceptText() = -1 then
						return
					end if
				
					if dw_1.getrow() < 1 then return
				
						MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
						IF MSG = 1 THEN
							Gvl_row_deleted = dw_1.GetRow()			
							dw_1.DELETEROW(Gvl_row_deleted)		
							dw_1.SetFocus()
							ROW = dw_1.GetRow()
							dw_1.ScrollToRow(row)
							dw_1.SetColumn(1)
						END IF
				ELSE
				
					if dw_2.AcceptText() = -1 then
						return
					end if
				
					if dw_2.getrow() < 1 then return
				
						MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
						IF MSG = 1 THEN
							Gvl_row_deleted = dw_2.GetRow()			
							dw_2.DELETEROW(Gvl_row_deleted)		
							dw_2.SetFocus()
							ROW = dw_2.GetRow()
							dw_2.ScrollToRow(row)
							dw_2.SetColumn(1)
						END IF				
				
				END IF 
					
					
	case 'ROWCOPY'
		
			dw_1.SELECTROW(0 , FALSE)
			lvdb_seq = double(f_get_sequence( 'seq_plan_date_sequence'))
			dw_1.object.plan_sequence[GVL_ROWCOPY_ROW] = 	lvdb_seq
			dw_1.object.actual_qty[GVL_ROWCOPY_ROW] = 0
			dw_1.SCROLLTOROW(GVL_ROWCOPY_ROW)										
			dw_1.SELECTROW(GVL_ROWCOPY_ROW , TRUE)
			
	case 'UPDATE'
		
			IF dw_1.UPDATE() < 0 or DW_2.UPDATE() < 0 OR dw_3.UPDATE() < 0  OR dw_4.UPDATE() < 0 THEN
			  	 ROLLBACK;
				 RETURN 
			ELSE
				 COMMIT;
	                F_RETRIEVE()
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
				 
			END IF

	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_pln_product_delivery_master
integer y = 356
end type

type dw_4 from w_main_root`dw_4 within w_pln_product_delivery_master
integer y = 356
integer width = 626
integer height = 532
boolean titlebar = true
boolean hscrollbar = false
end type

type dw_3 from w_main_root`dw_3 within w_pln_product_delivery_master
integer y = 356
integer width = 626
integer height = 1396
boolean titlebar = true
end type

type dw_2 from w_main_root`dw_2 within w_pln_product_delivery_master
integer y = 356
integer width = 3557
integer height = 1396
boolean titlebar = true
string title = "Delivery Month Master Plan"
string dataobject = "d_pln_delivery_month_master_plan_lst"
end type

type dw_1 from w_main_root`dw_1 within w_pln_product_delivery_master
integer y = 356
integer width = 6487
integer height = 1396
boolean titlebar = true
string title = "Delivery Master Plan List"
string dataobject = "d_pln_delivery_master_plan_lst_tree"
end type

event dw_1::itemchanged;call super::itemchanged;if row < 1 then return 

if mid( dwo.name , 1,9) = 'plan_time' then 	
	this.object.plan_qty_calc[row] = this.object.plan_time1[row]+this.object.plan_time2[row]+this.object.plan_time3[row]+this.object.plan_time4[row]+this.object.plan_time5[row]+this.object.plan_time6[row]+this.object.plan_time7[row]+this.object.plan_time8[row]+this.object.plan_time9[row]+this.object.plan_time10[row]
end if 
end event

event dw_1::rbuttondown;call super::rbuttondown;if row < 1 then return 
open( w_des_model_master_popup )

if Gst_return.gvb_return = true then 
	this.object.model_name[row] = message.stringparm
	this.object.model_suffix[row] = Gst_return.Gvs_return[3] 
	this.object.item_code[row] = Gst_return.Gvs_return[4]
end if 
end event

event dw_1::buttonclicked;call super::buttonclicked;if dwo.name = 'b_model' then 

	if row < 1 then return 
	open( w_des_model_master_popup )
	
	if Gst_return.gvb_return = true then 
		this.object.model_name[row] = message.stringparm
		this.object.model_suffix[row] = Gst_return.Gvs_return[3] 
		this.object.item_code[row] = Gst_return.Gvs_return[4]
	end if 
	
end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_pln_product_delivery_master
end type

type st_5 from so_statictext within w_pln_product_delivery_master
integer x = 2720
integer y = 96
integer width = 562
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Lot No"
end type

type st_3 from statictext within w_pln_product_delivery_master
integer x = 3282
integer y = 96
integer width = 535
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Customer Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_customer_code from uo_customer_code within w_pln_product_delivery_master
integer x = 3287
integer y = 168
integer width = 535
integer height = 1936
integer taborder = 40
boolean bringtotop = true
boolean autohscroll = true
boolean hscrollbar = true
end type

type sle_lot_no from so_singlelineedit within w_pln_product_delivery_master
integer x = 2720
integer y = 168
integer width = 562
integer height = 84
integer taborder = 50
boolean bringtotop = true
end type

type cb_8 from so_commandbutton within w_pln_product_delivery_master
integer x = 997
integer y = 88
integer width = 87
integer height = 72
integer taborder = 40
boolean bringtotop = true
string text = "<"
end type

event clicked;call super::clicked;uo_dateset.settext (string(RelativeDate( Date(uo_dateset.text()) , -1 )))
uo_dateend.settext( string(RelativeDate( Date(uo_dateend.text()) , -1 )))
end event

type st_yyyymm from so_statictext within w_pln_product_delivery_master
integer x = 1097
integer y = 96
integer width = 603
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Delivery Plan Date"
end type

type cb_9 from so_commandbutton within w_pln_product_delivery_master
integer x = 1714
integer y = 92
integer width = 87
integer height = 72
integer taborder = 50
boolean bringtotop = true
string text = ">"
end type

event clicked;call super::clicked;uo_dateset.settext (string(RelativeDate( Date(uo_dateset.text()) , 1 )))
uo_dateend.settext( string(RelativeDate( Date(uo_dateend.text()) , 1 )))
end event

type uo_dateend from uo_ymd_calendar within w_pln_product_delivery_master
integer x = 1399
integer y = 168
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateset from uo_ymd_calendar within w_pln_product_delivery_master
integer x = 992
integer y = 168
integer taborder = 60
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type tab_1 from tab within w_pln_product_delivery_master
event create ( )
event destroy ( )
integer x = 3881
integer y = 8
integer width = 1778
integer height = 320
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
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

type tabpage_1 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 1742
integer height = 192
long backcolor = 15780518
string text = "Process"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Regenerate5!"
long picturemaskcolor = 536870912
em_plan_qty em_plan_qty
cb_1 cb_1
end type

on tabpage_1.create
this.em_plan_qty=create em_plan_qty
this.cb_1=create cb_1
this.Control[]={this.em_plan_qty,&
this.cb_1}
end on

on tabpage_1.destroy
destroy(this.em_plan_qty)
destroy(this.cb_1)
end on

type em_plan_qty from so_editmask within tabpage_1
integer x = 37
integer y = 104
integer taborder = 30
string text = "0"
string mask = "###,##0"
boolean spin = true
double increment = 1
end type

type cb_1 from so_commandbutton within tabpage_1
integer x = 480
integer y = 20
integer width = 498
integer height = 156
integer taborder = 30
string text = "Set Plan By Qty"
end type

event clicked;call super::clicked;if dw_1.getrow() < 1 then return 

dw_1.object.plan_time1[dw_1.getrow()] = Long( em_plan_qty.text ) 
dw_1.object.plan_time2[dw_1.getrow()] = Long( em_plan_qty.text ) 
dw_1.object.plan_time3[dw_1.getrow()] = Long( em_plan_qty.text ) 
dw_1.object.plan_time4[dw_1.getrow()] = Long( em_plan_qty.text ) 
dw_1.object.plan_time5[dw_1.getrow()] = Long( em_plan_qty.text ) 
dw_1.object.plan_time6[dw_1.getrow()] = Long( em_plan_qty.text ) 
dw_1.object.plan_time7[dw_1.getrow()] = Long( em_plan_qty.text ) 
dw_1.object.plan_time8[dw_1.getrow()] = Long( em_plan_qty.text ) 
dw_1.object.plan_time9[dw_1.getrow()] = Long( em_plan_qty.text ) 
dw_1.object.plan_time10[dw_1.getrow()] = Long( em_plan_qty.text) 

end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 1742
integer height = 192
long backcolor = 12632256
string text = "Excel"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Custom004!"
long picturemaskcolor = 536870912
cb_17 cb_17
cb_2 cb_2
end type

on tabpage_2.create
this.cb_17=create cb_17
this.cb_2=create cb_2
this.Control[]={this.cb_17,&
this.cb_2}
end on

on tabpage_2.destroy
destroy(this.cb_17)
destroy(this.cb_2)
end on

type cb_17 from so_commandbutton within tabpage_2
integer x = 59
integer y = 20
integer width = 553
integer height = 156
integer taborder = 80
boolean bringtotop = true
string text = "Import From Excel"
end type

event clicked;call super::clicked;dw_1.reset()
dw_1.importclipboard( )

int i
do
	
	i++
	
	F_SET_SECURITY_ROW(dw_1 , i ,'ALL')
	dw_1.object.plan_status[i] = 'N'
	dw_1.object.plan_transfer_yn[i] = 'N'
	dw_1.object.lot_divide_yn[i] = 'N'
	dw_1.object.customer_code[i] = '*'

loop until i = dw_1.rowcount( )
end event

type cb_2 from so_commandbutton within tabpage_2
integer x = 613
integer y = 24
integer width = 613
integer height = 156
integer taborder = 170
boolean bringtotop = true
string text = "Form Save"
end type

event clicked;Datawindow ivdw_data_window
string     docname, named 
Long iret
ivdw_data_window = dw_1 
if isvalid(ivdw_data_window) then 
	
	if ivdw_data_window.getrow() < 1 then  
		dw_1.insertrow(0)
	end if
	
else
	return
end if

		SETPOINTER(HOURGLASS!)		
		iret = GetFileSaveName("Select Excel File ("+ivdw_data_window.classname()+")" , docname, named, "xls", "Excel Files (*.xls),*.xls")		

              IF iret =1 THEN 
		         uf_save_dw_as_excel( ivdw_data_window  , docname )
		ELSE
			RETURN
		END IF
		
//=================================================

end event

type rb_1 from so_radiobutton within w_pln_product_delivery_master
integer x = 997
integer y = 252
integer width = 334
integer height = 64
boolean bringtotop = true
integer weight = 700
string text = "Today"
end type

event clicked;call super::clicked;uo_dateend.settext( string(f_t_sysdate()) )
end event

type rb_3 from so_radiobutton within w_pln_product_delivery_master
integer x = 1280
integer y = 252
integer width = 315
integer height = 64
boolean bringtotop = true
integer weight = 700
string text = "1 Week"
end type

event clicked;call super::clicked;uo_dateend.settext( string(f_v_sysdate(-7)) )
end event

type rb_4 from so_radiobutton within w_pln_product_delivery_master
integer x = 1600
integer y = 252
integer width = 315
integer height = 64
boolean bringtotop = true
integer weight = 700
string text = "2 Week"
end type

event clicked;call super::clicked;uo_dateend.settext( string(f_v_sysdate(-14)) )
end event

type rb_5 from so_radiobutton within w_pln_product_delivery_master
integer x = 1915
integer y = 252
integer width = 315
integer height = 64
boolean bringtotop = true
integer weight = 700
string text = "4 Week"
end type

event clicked;call super::clicked;uo_dateend.settext( string(f_v_sysdate(-28)) )
end event

type ddlb_model_name from uo_set_model_name_ddlb within w_pln_product_delivery_master
integer x = 1829
integer y = 168
integer width = 887
integer height = 1936
integer taborder = 50
boolean bringtotop = true
end type

type st_4 from so_statictext within w_pln_product_delivery_master
integer x = 1833
integer y = 96
integer width = 887
integer height = 68
boolean bringtotop = true
string text = "Model Name"
end type

type rb_master_plan from so_radiobutton within w_pln_product_delivery_master
integer x = 78
integer y = 76
integer width = 704
boolean bringtotop = true
string text = "Delivery Plan Master"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1
end event

type rb_month_plan from so_radiobutton within w_pln_product_delivery_master
integer x = 78
integer y = 160
integer width = 704
boolean bringtotop = true
string text = "Delivery Plan Monthly Master"
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
selected_data_window = dw_2
end event

type rb_list from so_radiobutton within w_pln_product_delivery_master
integer x = 78
integer y = 240
integer width = 754
boolean bringtotop = true
string text = "Delivery Daily Plan / Actual  List"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3
end event

type gb_1 from so_groupbox within w_pln_product_delivery_master
integer x = 965
integer y = 8
integer width = 2889
integer height = 320
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_pln_product_delivery_master
integer y = 8
integer width = 946
integer height = 324
integer taborder = 40
string text = "Category"
end type

