HA$PBExportHeader$w_mat_sub_issue_master.srw
$PBExportComments$Material Mass Issue Master
forward
global type w_mat_sub_issue_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mat_sub_issue_master
end type
type uo_dateend from uo_ymd_calendar within w_mat_sub_issue_master
end type
type ddlb_item_code from uo_item_code within w_mat_sub_issue_master
end type
type st_3 from so_statictext within w_mat_sub_issue_master
end type
type st_4 from so_statictext within w_mat_sub_issue_master
end type
type rb_purchase from so_radiobutton within w_mat_sub_issue_master
end type
type rb_departure from so_radiobutton within w_mat_sub_issue_master
end type
type cb_set from so_commandbutton within w_mat_sub_issue_master
end type
type ddlb_line_code from uo_line_code within w_mat_sub_issue_master
end type
type st_1 from so_statictext within w_mat_sub_issue_master
end type
type ddlb_workstage_code from uo_workstage_code_all within w_mat_sub_issue_master
end type
type st_2 from so_statictext within w_mat_sub_issue_master
end type
type ddlb_issue_account from uo_basecode within w_mat_sub_issue_master
end type
type st_5 from so_statictext within w_mat_sub_issue_master
end type
type cbx_issue_type from checkbox within w_mat_sub_issue_master
end type
type cbx_apply_issue_packing_qty from checkbox within w_mat_sub_issue_master
end type
type st_8 from so_statictext within w_mat_sub_issue_master
end type
type sle_material_mfs from so_singlelineedit within w_mat_sub_issue_master
end type
type rb_all from so_radiobutton within w_mat_sub_issue_master
end type
type rb_gt from so_radiobutton within w_mat_sub_issue_master
end type
type gb_1 from so_groupbox within w_mat_sub_issue_master
end type
type gb_2 from so_groupbox within w_mat_sub_issue_master
end type
type gb_3 from so_groupbox within w_mat_sub_issue_master
end type
type gb_4 from so_groupbox within w_mat_sub_issue_master
end type
type gb_5 from so_groupbox within w_mat_sub_issue_master
end type
end forward

global type w_mat_sub_issue_master from w_main_root
integer width = 4878
integer height = 3120
string title = "Material Sub Material Issue Master"
uo_dateset uo_dateset
uo_dateend uo_dateend
ddlb_item_code ddlb_item_code
st_3 st_3
st_4 st_4
rb_purchase rb_purchase
rb_departure rb_departure
cb_set cb_set
ddlb_line_code ddlb_line_code
st_1 st_1
ddlb_workstage_code ddlb_workstage_code
st_2 st_2
ddlb_issue_account ddlb_issue_account
st_5 st_5
cbx_issue_type cbx_issue_type
cbx_apply_issue_packing_qty cbx_apply_issue_packing_qty
st_8 st_8
sle_material_mfs sle_material_mfs
rb_all rb_all
rb_gt rb_gt
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
gb_5 gb_5
end type
global w_mat_sub_issue_master w_mat_sub_issue_master

on w_mat_sub_issue_master.create
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
this.ddlb_line_code=create ddlb_line_code
this.st_1=create st_1
this.ddlb_workstage_code=create ddlb_workstage_code
this.st_2=create st_2
this.ddlb_issue_account=create ddlb_issue_account
this.st_5=create st_5
this.cbx_issue_type=create cbx_issue_type
this.cbx_apply_issue_packing_qty=create cbx_apply_issue_packing_qty
this.st_8=create st_8
this.sle_material_mfs=create sle_material_mfs
this.rb_all=create rb_all
this.rb_gt=create rb_gt
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_5=create gb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.ddlb_item_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.rb_purchase
this.Control[iCurrent+7]=this.rb_departure
this.Control[iCurrent+8]=this.cb_set
this.Control[iCurrent+9]=this.ddlb_line_code
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.ddlb_workstage_code
this.Control[iCurrent+12]=this.st_2
this.Control[iCurrent+13]=this.ddlb_issue_account
this.Control[iCurrent+14]=this.st_5
this.Control[iCurrent+15]=this.cbx_issue_type
this.Control[iCurrent+16]=this.cbx_apply_issue_packing_qty
this.Control[iCurrent+17]=this.st_8
this.Control[iCurrent+18]=this.sle_material_mfs
this.Control[iCurrent+19]=this.rb_all
this.Control[iCurrent+20]=this.rb_gt
this.Control[iCurrent+21]=this.gb_1
this.Control[iCurrent+22]=this.gb_2
this.Control[iCurrent+23]=this.gb_3
this.Control[iCurrent+24]=this.gb_4
this.Control[iCurrent+25]=this.gb_5
end on

on w_mat_sub_issue_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.ddlb_item_code)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.rb_purchase)
destroy(this.rb_departure)
destroy(this.cb_set)
destroy(this.ddlb_line_code)
destroy(this.st_1)
destroy(this.ddlb_workstage_code)
destroy(this.st_2)
destroy(this.ddlb_issue_account)
destroy(this.st_5)
destroy(this.cbx_issue_type)
destroy(this.cbx_apply_issue_packing_qty)
destroy(this.st_8)
destroy(this.sle_material_mfs)
destroy(this.rb_all)
destroy(this.rb_gt)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_5)
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
F_MENU_CONTROL('DATA_CONTROL_MODIFY' , TRUE)  // All Data Control





end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
uo_dateset.settext(string(f_t_sysdate(), 'yyyy/mm')+'/01')
end event

event ue_data_control;call super::ue_data_control;long row , lvi_sign
string lvs_date
double lvd_seq
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
			dw_1.reset()
			dw_2.reset()
			
			    if rb_all.checked = true then 
				lvi_sign = -2
			    elseif rb_gt.checked = true then 
					lvi_sign = 1
			    end if
			
			if    rb_purchase.checked   then 
			    dw_1.retrieve(   ddlb_item_code.text() + '%',sle_material_mfs.text+'%' ,   lvi_sign , gvi_organization_id)
			else
				dw_3.retrieve( uo_dateset.text() , uo_dateend.text(), '%', '%' ,  ddlb_item_code.text() + '%',   gvi_organization_id)
			end if 
			
	case 'UPDATE'
		
			IF DW_2.UPDATE() < 0   THEN
			  	 ROLLBACK;
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
	                F_RETRIEVE()
			END IF

	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mat_sub_issue_master
integer y = 532
end type

type dw_4 from w_main_root`dw_4 within w_mat_sub_issue_master
integer y = 532
boolean hscrollbar = false
boolean vscrollbar = false
end type

type dw_3 from w_main_root`dw_3 within w_mat_sub_issue_master
integer y = 532
integer width = 4544
integer height = 1204
boolean titlebar = true
string title = "Sub Material Issue List"
string dataobject = "d_mat_sub_issue_lst"
end type

type dw_2 from w_main_root`dw_2 within w_mat_sub_issue_master
integer y = 1740
integer width = 4549
integer height = 900
boolean titlebar = true
string title = "Issue List"
string dataobject = "d_mat_mass_issue_lst"
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_2::itemchanged;call super::itemchanged;string lvs_return
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

event dw_2::rbuttondown;call super::rbuttondown;//if dwo.name = 'supplier_code' then 	
//	openwithparm(w_mat_item_popup , string(this.object.item_code[row]))	
//	if  gst_return.gvb_return  = true then
//	   this.object.supplier_code[row] = gst_return.gvs_return[4] 
//	   this.object.supplier_name[row] = gst_return.gvs_return[5] 	
//	end if
//	gst_return.gvs_return[4]  = ''
//	gst_return.gvs_return[5]  = ''	
//end if
end event

type dw_1 from w_main_root`dw_1 within w_mat_sub_issue_master
integer y = 532
integer width = 4544
integer height = 1204
boolean titlebar = true
string title = "Sub Material Current Inventory List"
string dataobject = "d_mat_current_inventory_4_submaterial_issu_lst"
end type

type uo_dateset from uo_ymd_calendar within w_mat_sub_issue_master
event destroy ( )
integer x = 901
integer y = 160
integer taborder = 30
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_sub_issue_master
event destroy ( )
integer x = 1317
integer y = 160
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_item_code from uo_item_code within w_mat_sub_issue_master
integer x = 1733
integer y = 160
integer width = 553
integer taborder = 20
boolean bringtotop = true
end type

type st_3 from so_statictext within w_mat_sub_issue_master
integer x = 1742
integer y = 88
integer width = 553
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type st_4 from so_statictext within w_mat_sub_issue_master
integer x = 905
integer y = 88
integer width = 814
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Issue Date"
end type

type rb_purchase from so_radiobutton within w_mat_sub_issue_master
integer x = 59
integer y = 84
integer width = 658
boolean bringtotop = true
integer weight = 700
string text = "Current Inventory List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1

cb_set.enabled = true


end event

type rb_departure from so_radiobutton within w_mat_sub_issue_master
integer x = 59
integer y = 184
integer width = 777
boolean bringtotop = true
integer weight = 700
string text = "Sub Issue  History"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3

cb_set.enabled = false

end event

type cb_set from so_commandbutton within w_mat_sub_issue_master
integer x = 1705
integer y = 376
integer width = 489
integer height = 112
integer taborder = 30
boolean bringtotop = true
string text = "Batch Select"
end type

event clicked;call super::clicked;Decimal lvf_issue_qty
long n = 1  , i = 1 

if f_object_role_check() = false then return 

if dw_1.rowcount() < 1 then return 
if ddlb_issue_account.text = '%' OR ISNULL(ddlb_issue_account.text) then
	Messagebox("Notify" , "Issue Account Invalid")
	Return
end if 



dw_1.accepttext()


if ddlb_line_code.getcode() = '%' or isnull(ddlb_line_code.getcode()) or ddlb_workstage_code.getcode() = '%' or isnull(ddlb_workstage_code.getcode()) then 
	Messagebox("Notify" , "Please Choose a Line Code and Workstage Code")
	return
end if

msg = f_msgbox1(1161,this.text)
if msg = 1 then 
else 
	return 
end if 

for i = 1 to dw_1.rowcount()
	
	if dw_1.object.check_yn[i] =  'Y'  then 
	else 
		continue 
	end if 	
	
	n = dw_2.insertrow(0)
	dw_2.scrolltorow(n)
	f_set_security_row(dw_2, n, 'ALL')
	
	dw_2.object.work_order_no[n] = '*'
	dw_2.object.issue_date[n] = f_t_sysdate()	
	dw_2.object.issue_sequence[n] = double(f_get_sequence('seq_mat_issue'))
	
	dw_2.object.item_type[n] = dw_1.object.item_type[i]
	dw_2.object.item_code[n] = dw_1.object.item_code[i]
	dw_2.object.item_name[n] = dw_1.object.item_name[i]
	dw_2.object.item_spec[n] = dw_1.object.item_spec[i]
	dw_2.object.item_uom[n] = dw_1.object.item_uom[i]		
     dw_2.object.line_code[n]            = ddlb_line_code.getcode()
	dw_2.object.workstage_code[n] = ddlb_workstage_code.getcode()
	
	//=============================================
	// $$HEX15$$ecd3a5c7e8b204c7200001c8a9c620009ccde0ac7cc72000bdacb0c62000$$ENDHEX$$
	//=============================================
	if cbx_apply_issue_packing_qty.checked = true then 
		
		lvf_issue_qty  = f_get_item_issue_packing_qty( dw_1.object.item_code[i] , dw_1.object.issue_qty[i] , Gvi_organization_id )
	else
		lvf_issue_qty = dw_1.object.issue_qty[i]
	end if
	
	dw_2.object.issue_qty[n] =lvf_issue_qty

	//==============================================
     if 	dw_1.object.issue_qty[i] < 0 THEN 
		dw_2.object.issue_deficit[n] = '4'		
	else
		dw_2.object.issue_deficit[n] = '3'
	end if
	
	dw_2.object.issue_status[n] = 'N'
	
	if cbx_issue_type.checked = true then
		dw_2.object.issue_type[n] = 'N' //$$HEX5$$15c8c1c09ccde0ac2000$$ENDHEX$$
	else
		dw_2.object.issue_type[n] = 'E' //$$HEX7$$30aec0d09ccde0ac200009000900$$ENDHEX$$
	end if
	dw_2.object.issue_account[n] = ddlb_issue_account.getcode()

	
	dw_2.object.line_type[n] = dw_1.object.line_type[i]
	
	dw_2.object.mfs[n] = '*'
	dw_2.object.material_mfs[n] = dw_1.object.material_mfs[i]
	
	dw_2.object.issue_amt[n] = lvf_issue_qty * dw_1.object.inventory_price[i]
	dw_2.object.issue_price[n]  = dw_1.object.inventory_price[i]
	dw_2.object.location_code[n] = dw_1.object.location_code[i]
	
next



end event

type ddlb_line_code from uo_line_code within w_mat_sub_issue_master
integer x = 2766
integer y = 160
integer width = 503
integer taborder = 40
boolean bringtotop = true
end type

type st_1 from so_statictext within w_mat_sub_issue_master
integer x = 2766
integer y = 88
integer width = 503
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Line Code"
end type

type ddlb_workstage_code from uo_workstage_code_all within w_mat_sub_issue_master
integer x = 3269
integer y = 160
integer width = 562
integer taborder = 40
boolean bringtotop = true
end type

type st_2 from so_statictext within w_mat_sub_issue_master
integer x = 3269
integer y = 88
integer width = 562
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Workstage Code"
end type

type ddlb_issue_account from uo_basecode within w_mat_sub_issue_master
integer x = 3835
integer y = 160
integer width = 567
integer height = 832
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'ISSUE ACCOUNT')
end event

event selectionchanged;call super::selectionchanged;//================================
// $$HEX40$$91c5b0c0200010b694b2200091c5b0c088bdc9b720007cc7bdacb0c6d0c5ccb920009ccde0ac20c715d644c7200015c8c1c09ccde0ac40c6200030aec0d09ccde0ac5cb820006cad84bd58d5ecc52000$$ENDHEX$$
// $$HEX8$$9ccde0ac200060d518c2200088c74cc7$$ENDHEX$$.
// $$HEX23$$f8ad78c62000c4ac15c840c72000a8ba50b420009ccde0ac20c715d674c7200030aec0d05cb8200024c115c828b4$$ENDHEX$$.
//$$HEX39$$30aec0d05cb8200024c115c81cb42000bdacb0c6d0c594b220009ccde0ac98ccacb9c4d62000f5ac15c885c7e0ac5cb82000a1c788d7c0c920004ac53cc7c0bb5cb82000f5ac15c8acc7e0ac5cb8$$ENDHEX$$
//$$HEX8$$ddc031c118b4c0c920004ac54cc72000$$ENDHEX$$.
//================================
if this.getcode() = 'M001' or this.getcode() = 'M002' then
  cbx_issue_type.enabled = true 
  cbx_issue_type.checked = true	  
else
  cbx_issue_type.checked = false
  cbx_issue_type.enabled = false
end if
end event

type st_5 from so_statictext within w_mat_sub_issue_master
integer x = 3835
integer y = 92
integer width = 567
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Issue Account"
end type

type cbx_issue_type from checkbox within w_mat_sub_issue_master
integer x = 73
integer y = 400
integer width = 489
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Normal Issue"
boolean checked = true
end type

type cbx_apply_issue_packing_qty from checkbox within w_mat_sub_issue_master
integer x = 658
integer y = 400
integer width = 704
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Apply Issue Packing Qty"
boolean checked = true
end type

type st_8 from so_statictext within w_mat_sub_issue_master
integer x = 2295
integer y = 84
integer width = 448
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Material MFS"
end type

type sle_material_mfs from so_singlelineedit within w_mat_sub_issue_master
integer x = 2290
integer y = 160
integer width = 448
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

dw_1.SETFILTER('')
dw_1.FILTER()

LVS_COLUMN = 'ITEM_NAME'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_1.SETFILTER('')
    dw_1.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

dw_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found" )
end event

type rb_all from so_radiobutton within w_mat_sub_issue_master
integer x = 2304
integer y = 388
integer width = 343
boolean bringtotop = true
integer weight = 700
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.setfilter( '')
dw_1.filter( )
end event

type rb_gt from so_radiobutton within w_mat_sub_issue_master
integer x = 2784
integer y = 388
integer width = 558
boolean bringtotop = true
integer weight = 700
string text = "Inventory Qty > 0"
end type

event clicked;call super::clicked;dw_1.setfilter('inventory_qty > 0 ')
dw_1.filter( )
end event

type gb_1 from so_groupbox within w_mat_sub_issue_master
integer x = 9
integer width = 841
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_mat_sub_issue_master
integer x = 2757
integer width = 1710
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Destination"
end type

type gb_3 from so_groupbox within w_mat_sub_issue_master
integer y = 312
integer width = 2231
integer height = 204
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_4 from so_groupbox within w_mat_sub_issue_master
integer x = 859
integer width = 1897
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_5 from so_groupbox within w_mat_sub_issue_master
integer x = 2240
integer y = 308
integer width = 1216
integer height = 212
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Filter"
end type

