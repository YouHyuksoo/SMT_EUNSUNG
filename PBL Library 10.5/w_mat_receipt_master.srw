HA$PBExportHeader$w_mat_receipt_master.srw
$PBExportComments$Material Receipt Master
forward
global type w_mat_receipt_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mat_receipt_master
end type
type uo_dateend from uo_ymd_calendar within w_mat_receipt_master
end type
type ddlb_item_code from uo_item_code within w_mat_receipt_master
end type
type st_3 from so_statictext within w_mat_receipt_master
end type
type st_4 from so_statictext within w_mat_receipt_master
end type
type rb_arrival from so_radiobutton within w_mat_receipt_master
end type
type rb_receipt from so_radiobutton within w_mat_receipt_master
end type
type ddlb_supplier_code from uo_supplier_code within w_mat_receipt_master
end type
type st_1 from so_statictext within w_mat_receipt_master
end type
type st_14 from so_statictext within w_mat_receipt_master
end type
type sle_item_name from so_singlelineedit within w_mat_receipt_master
end type
type tab_1 from tab within w_mat_receipt_master
end type
type tabpage_1 from userobject within tab_1
end type
type st_13 from so_statictext within tabpage_1
end type
type uo_receipt_date from uo_ymd_calendar within tabpage_1
end type
type pb_1 from so_commandbutton within tabpage_1
end type
type cb_gen_lot_no from so_commandbutton within tabpage_1
end type
type sle_receipt_lot_no from so_singlelineedit within tabpage_1
end type
type st_12 from so_statictext within tabpage_1
end type
type cbx_2 from so_checkbox within tabpage_1
end type
type st_location_code from so_statictext within tabpage_1
end type
type ddlb_location_code from uo_basecode within tabpage_1
end type
type cbx_1 from so_checkbox within tabpage_1
end type
type cb_batch from so_commandbutton within tabpage_1
end type
type tabpage_1 from userobject within tab_1
st_13 st_13
uo_receipt_date uo_receipt_date
pb_1 pb_1
cb_gen_lot_no cb_gen_lot_no
sle_receipt_lot_no sle_receipt_lot_no
st_12 st_12
cbx_2 cbx_2
st_location_code st_location_code
ddlb_location_code ddlb_location_code
cbx_1 cbx_1
cb_batch cb_batch
end type
type tabpage_2 from userobject within tab_1
end type
type cb_1 from so_commandbutton within tabpage_2
end type
type cb_divide from so_commandbutton within tabpage_2
end type
type cb_generate from so_commandbutton within tabpage_2
end type
type tabpage_2 from userobject within tab_1
cb_1 cb_1
cb_divide cb_divide
cb_generate cb_generate
end type
type tabpage_3 from userobject within tab_1
end type
type cb_print from so_commandbutton within tabpage_3
end type
type cb_preview from so_commandbutton within tabpage_3
end type
type cbx_dialog from so_checkbox within tabpage_3
end type
type em_copy from so_editmask within tabpage_3
end type
type st_2 from so_statictext within tabpage_3
end type
type tabpage_3 from userobject within tab_1
cb_print cb_print
cb_preview cb_preview
cbx_dialog cbx_dialog
em_copy em_copy
st_2 st_2
end type
type tabpage_4 from userobject within tab_1
end type
type st_10 from so_statictext within tabpage_4
end type
type ddlb_relocate_line_type from uo_line_type within tabpage_4
end type
type cb_2 from so_commandbutton within tabpage_4
end type
type st_9 from so_statictext within tabpage_4
end type
type uo_relocate_dateset from uo_ymd_calendar within tabpage_4
end type
type st_8 from so_statictext within tabpage_4
end type
type ddlb_relocate_supplier from uo_supplier_code within tabpage_4
end type
type st_7 from so_statictext within tabpage_4
end type
type ddlb_relocate_item from uo_item_code within tabpage_4
end type
type st_6 from so_statictext within tabpage_4
end type
type uo_relocate_end from uo_ymd_calendar within tabpage_4
end type
type uo_relocate_start from uo_ymd_calendar within tabpage_4
end type
type tabpage_4 from userobject within tab_1
st_10 st_10
ddlb_relocate_line_type ddlb_relocate_line_type
cb_2 cb_2
st_9 st_9
uo_relocate_dateset uo_relocate_dateset
st_8 st_8
ddlb_relocate_supplier ddlb_relocate_supplier
st_7 st_7
ddlb_relocate_item ddlb_relocate_item
st_6 st_6
uo_relocate_end uo_relocate_end
uo_relocate_start uo_relocate_start
end type
type tab_1 from tab within w_mat_receipt_master
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type
type sle_material_mfs from so_singlelineedit within w_mat_receipt_master
end type
type material_mfs_t from so_statictext within w_mat_receipt_master
end type
type rb_arrival_bad from so_radiobutton within w_mat_receipt_master
end type
type sle_invoice_no from so_singlelineedit within w_mat_receipt_master
end type
type st_invoice_no from so_statictext within w_mat_receipt_master
end type
type st_5 from so_statictext within w_mat_receipt_master
end type
type ddlb_location_code_cond from uo_basecode within w_mat_receipt_master
end type
type st_11 from so_statictext within w_mat_receipt_master
end type
type ddlb_inspect_result from uo_basecode within w_mat_receipt_master
end type
type gb_1 from so_groupbox within w_mat_receipt_master
end type
type gb_2 from so_groupbox within w_mat_receipt_master
end type
end forward

global type w_mat_receipt_master from w_main_root
integer width = 5152
integer height = 2952
string title = "Material Receipt Master"
uo_dateset uo_dateset
uo_dateend uo_dateend
ddlb_item_code ddlb_item_code
st_3 st_3
st_4 st_4
rb_arrival rb_arrival
rb_receipt rb_receipt
ddlb_supplier_code ddlb_supplier_code
st_1 st_1
st_14 st_14
sle_item_name sle_item_name
tab_1 tab_1
sle_material_mfs sle_material_mfs
material_mfs_t material_mfs_t
rb_arrival_bad rb_arrival_bad
sle_invoice_no sle_invoice_no
st_invoice_no st_invoice_no
st_5 st_5
ddlb_location_code_cond ddlb_location_code_cond
st_11 st_11
ddlb_inspect_result ddlb_inspect_result
gb_1 gb_1
gb_2 gb_2
end type
global w_mat_receipt_master w_mat_receipt_master

type variables
string ivs_preview_yn
end variables

on w_mat_receipt_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.ddlb_item_code=create ddlb_item_code
this.st_3=create st_3
this.st_4=create st_4
this.rb_arrival=create rb_arrival
this.rb_receipt=create rb_receipt
this.ddlb_supplier_code=create ddlb_supplier_code
this.st_1=create st_1
this.st_14=create st_14
this.sle_item_name=create sle_item_name
this.tab_1=create tab_1
this.sle_material_mfs=create sle_material_mfs
this.material_mfs_t=create material_mfs_t
this.rb_arrival_bad=create rb_arrival_bad
this.sle_invoice_no=create sle_invoice_no
this.st_invoice_no=create st_invoice_no
this.st_5=create st_5
this.ddlb_location_code_cond=create ddlb_location_code_cond
this.st_11=create st_11
this.ddlb_inspect_result=create ddlb_inspect_result
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.ddlb_item_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.rb_arrival
this.Control[iCurrent+7]=this.rb_receipt
this.Control[iCurrent+8]=this.ddlb_supplier_code
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.st_14
this.Control[iCurrent+11]=this.sle_item_name
this.Control[iCurrent+12]=this.tab_1
this.Control[iCurrent+13]=this.sle_material_mfs
this.Control[iCurrent+14]=this.material_mfs_t
this.Control[iCurrent+15]=this.rb_arrival_bad
this.Control[iCurrent+16]=this.sle_invoice_no
this.Control[iCurrent+17]=this.st_invoice_no
this.Control[iCurrent+18]=this.st_5
this.Control[iCurrent+19]=this.ddlb_location_code_cond
this.Control[iCurrent+20]=this.st_11
this.Control[iCurrent+21]=this.ddlb_inspect_result
this.Control[iCurrent+22]=this.gb_1
this.Control[iCurrent+23]=this.gb_2
end on

on w_mat_receipt_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.ddlb_item_code)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.rb_arrival)
destroy(this.rb_receipt)
destroy(this.ddlb_supplier_code)
destroy(this.st_1)
destroy(this.st_14)
destroy(this.sle_item_name)
destroy(this.tab_1)
destroy(this.sle_material_mfs)
destroy(this.material_mfs_t)
destroy(this.rb_arrival_bad)
destroy(this.sle_invoice_no)
destroy(this.st_invoice_no)
destroy(this.st_5)
destroy(this.ddlb_location_code_cond)
destroy(this.st_11)
destroy(this.ddlb_inspect_result)
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
F_MENU_CONTROL('DATA_CONTROL_MODIFY' ,TRUE)  // All Data Control





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
			dw_5.reset()
			
			if rb_arrival.checked = true  then 
				dw_1.retrieve(ddlb_item_code.text() + '%', ddlb_supplier_code.text +'%',uo_dateset.text() , uo_dateend.text(),  sle_material_mfs.text+'%'  ,'%'+sle_invoice_no.text+ '%' , ddlb_inspect_result.getcode()+ '%' , gvi_organization_id)				
			elseif rb_arrival_bad.checked = true  then 
			    dw_5.retrieve(ddlb_item_code.text() + '%', ddlb_supplier_code.text +'%', uo_dateset.text(), uo_dateend.text(),  sle_material_mfs.text+'%' , '%' , gvi_organization_id)
			else
				dw_3.retrieve(ddlb_item_code.text() + '%', ddlb_supplier_code.text +'%' , uo_dateset.text() , uo_dateend.text() ,ddlb_location_code_cond.text()+'%' , '%'+sle_invoice_no.text+ '%'  , gvi_organization_id)
			end if 
	 
   case 'UPDATE'
		
		if rb_arrival.checked = true then 
				 
				msg = f_msgbox(1160)
				if msg = 1 then 
				else
					return 
				end if 
				
				if dw_1.update() < 0 then 
					rollback;
					return
				else
					commit ;
					f_msg_mdi_help(f_msg_st(9026))					
				end if 				
				
				if dw_2.rowcount() = 0 then return 
				
				dw_2.accepttext()				
				if  dw_2.update() < 0 then 
					rollback; 
					dw_2.reset()
					f_msg_mdi_help(f_msg_st(9026))
				else
					commit; 
					dw_2.reset()	
					f_msg_mdi_help(f_msg_st(170))
				end if 
				
				
			elseif rb_arrival_bad.checked = true then 
				 
				msg = f_msgbox(1160)
				if msg = 1 then 
				else
					return 
				end if 
				
				if  dw_5.update() < 0  then 
					rollback;
					return
				else
					commit ;
					f_msg_mdi_help(f_msg_st(9026))					
				end if 				
				
				if dw_2.rowcount() = 0 then return 
				
				dw_2.accepttext()				
				if  dw_2.update() < 0 then 
					rollback; 
					dw_2.reset()
					f_msg_mdi_help(f_msg_st(9026))
				else
					commit; 
					dw_2.reset()	
					f_msg_mdi_help(f_msg_st(170))
				end if 

		else
		
				IF dw_3.UPDATE() < 0  THEN
					 ROLLBACK;
				ELSE
					 COMMIT;
					 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
				END IF
				
		end if 
	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mat_receipt_master
integer y = 584
integer width = 4544
integer height = 1128
integer taborder = 0
boolean titlebar = true
string title = "Mass Material Arrival Bad List"
string dataobject = "d_mat_arrival_bad_4_receipt_lst_tree"
end type

type dw_4 from w_main_root`dw_4 within w_mat_receipt_master
integer y = 584
integer width = 4544
integer height = 1124
integer taborder = 0
boolean titlebar = true
string title = "Material Receipt Invoice Report"
string dataobject = "d_mat_receipt_invoice_rpt"
end type

type dw_3 from w_main_root`dw_3 within w_mat_receipt_master
integer y = 584
integer width = 4544
integer height = 1120
integer taborder = 0
boolean titlebar = true
string title = "Material Receipt List"
string dataobject = "d_mat_receipt_hst"
end type

event dw_3::itemchanged;call super::itemchanged;this.accepttext( )

if  dwo.name = 'unit_price' or dwo.name = 'exchange_rate'  then 
	
	this.object.receipt_amt[row] = this.object.receipt_qty[row] *this.object.unit_price[row] *this.object.exchange_rate[row]
	this.object.foreign_receipt_amt[row] = this.object.receipt_qty[row] *this.object.unit_price[row] 
end if
end event

type dw_2 from w_main_root`dw_2 within w_mat_receipt_master
integer y = 1720
integer width = 4549
integer height = 712
integer taborder = 0
boolean titlebar = true
string title = "Material Receipt List"
string dataobject = "d_mat_receipt_lst"
boolean hsplitscroll = false
boolean livescroll = false
borderstyle borderstyle = styleraised!
end type

type dw_1 from w_main_root`dw_1 within w_mat_receipt_master
integer y = 584
integer width = 4544
integer height = 1128
integer taborder = 0
boolean titlebar = true
string title = "Mass Material Arrival List"
string dataobject = "d_mat_arrival_4_receipt_lst_tree"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_mat_receipt_master
integer taborder = 0
end type

type uo_dateset from uo_ymd_calendar within w_mat_receipt_master
event destroy ( )
integer x = 1710
integer y = 160
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_receipt_master
event destroy ( )
integer x = 2126
integer y = 160
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_item_code from uo_item_code within w_mat_receipt_master
integer x = 750
integer y = 160
integer width = 517
integer taborder = 0
boolean bringtotop = true
end type

type st_3 from so_statictext within w_mat_receipt_master
integer x = 750
integer y = 80
integer width = 517
boolean bringtotop = true
string text = "Item Code"
end type

type st_4 from so_statictext within w_mat_receipt_master
integer x = 1714
integer y = 80
integer width = 814
boolean bringtotop = true
string text = "Date"
end type

type rb_arrival from so_radiobutton within w_mat_receipt_master
integer x = 55
integer y = 60
integer width = 617
boolean bringtotop = true
string text = "Arrival List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1
tab_1.tabpage_1.cb_batch.enabled = true 

tab_1.tabpage_2.cb_generate.enabled = false


tab_1.tabpage_1.sle_receipt_lot_no.enabled = false
tab_1.tabpage_1.cb_gen_lot_no.enabled = false

tab_1.tabpage_1.ddlb_location_code.text = 'M01'
end event

type rb_receipt from so_radiobutton within w_mat_receipt_master
integer x = 55
integer y = 200
integer width = 617
boolean bringtotop = true
string text = "Receipt List"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3
tab_1.tabpage_1.cb_batch.enabled = false
tab_1.tabpage_2.cb_generate.enabled = True


tab_1.tabpage_1.sle_receipt_lot_no.enabled = true
tab_1.tabpage_1.cb_gen_lot_no.enabled = true

tab_1.tabpage_1.ddlb_location_code.text = '%'
end event

type ddlb_supplier_code from uo_supplier_code within w_mat_receipt_master
integer x = 1271
integer y = 160
integer width = 439
integer taborder = 0
boolean bringtotop = true
end type

type st_1 from so_statictext within w_mat_receipt_master
integer x = 1271
integer y = 80
integer width = 439
boolean bringtotop = true
string text = "Supplier Code"
end type

type st_14 from so_statictext within w_mat_receipt_master
integer x = 2981
integer y = 88
integer width = 439
integer height = 56
boolean bringtotop = true
string text = "Item Name"
end type

type sle_item_name from so_singlelineedit within w_mat_receipt_master
integer x = 2981
integer y = 160
integer width = 439
integer height = 84
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

type tab_1 from tab within w_mat_receipt_master
event create ( )
event destroy ( )
integer x = 5
integer y = 300
integer width = 4229
integer height = 284
boolean bringtotop = true
integer textsize = -8
integer weight = 400
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
tabpage_4 tabpage_4
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
end on

type tabpage_1 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 4192
integer height = 156
long backcolor = 15780518
string text = "Process"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Regenerate5!"
long picturemaskcolor = 536870912
st_13 st_13
uo_receipt_date uo_receipt_date
pb_1 pb_1
cb_gen_lot_no cb_gen_lot_no
sle_receipt_lot_no sle_receipt_lot_no
st_12 st_12
cbx_2 cbx_2
st_location_code st_location_code
ddlb_location_code ddlb_location_code
cbx_1 cbx_1
cb_batch cb_batch
end type

on tabpage_1.create
this.st_13=create st_13
this.uo_receipt_date=create uo_receipt_date
this.pb_1=create pb_1
this.cb_gen_lot_no=create cb_gen_lot_no
this.sle_receipt_lot_no=create sle_receipt_lot_no
this.st_12=create st_12
this.cbx_2=create cbx_2
this.st_location_code=create st_location_code
this.ddlb_location_code=create ddlb_location_code
this.cbx_1=create cbx_1
this.cb_batch=create cb_batch
this.Control[]={this.st_13,&
this.uo_receipt_date,&
this.pb_1,&
this.cb_gen_lot_no,&
this.sle_receipt_lot_no,&
this.st_12,&
this.cbx_2,&
this.st_location_code,&
this.ddlb_location_code,&
this.cbx_1,&
this.cb_batch}
end on

on tabpage_1.destroy
destroy(this.st_13)
destroy(this.uo_receipt_date)
destroy(this.pb_1)
destroy(this.cb_gen_lot_no)
destroy(this.sle_receipt_lot_no)
destroy(this.st_12)
destroy(this.cbx_2)
destroy(this.st_location_code)
destroy(this.ddlb_location_code)
destroy(this.cbx_1)
destroy(this.cb_batch)
end on

type st_13 from so_statictext within tabpage_1
integer x = 590
integer width = 448
integer height = 64
boolean bringtotop = true
integer weight = 700
long backcolor = 15780518
string text = "Receipt Date"
end type

type uo_receipt_date from uo_ymd_calendar within tabpage_1
event destroy ( )
integer x = 603
integer y = 64
integer height = 76
integer taborder = 70
boolean bringtotop = true
end type

on uo_receipt_date.destroy
call uo_ymd_calendar::destroy
end on

type pb_1 from so_commandbutton within tabpage_1
integer x = 2565
integer y = 32
integer width = 480
integer height = 112
integer taborder = 50
string text = "Barcode Scan"
end type

event clicked;call super::clicked;open(w_mat_item_receipt_barcode_scan_popup)
end event

type cb_gen_lot_no from so_commandbutton within tabpage_1
integer x = 3584
integer y = 16
integer width = 443
integer height = 120
integer taborder = 130
boolean enabled = false
string text = "Gen Lot No"
end type

event clicked;call super::clicked;sle_receipt_lot_no.text = string(f_get_any_no( 'RECEIPT_LOT_NO'))


long i
do
	i++
	
	if dw_3.object.check_yn[i] = 'Y' then
		
		dw_3.object.receipt_lot_no[i] = sle_receipt_lot_no.text
		
	else
		continue
	end if
	
loop until i = dw_3.rowcount()


msg = f_msgbox1(1161,this.text)
if msg = 1 then 
else
	return 
end if 
if  dw_3.update() < 0 then 
	rollback; 
	f_msg_mdi_help(f_msg_st(9026))
else
	commit; 
	f_msg_mdi_help(f_msg_st(170))
end if 




end event

type sle_receipt_lot_no from so_singlelineedit within tabpage_1
integer x = 3077
integer y = 64
integer taborder = 130
boolean enabled = false
end type

type st_12 from so_statictext within tabpage_1
integer x = 3077
integer height = 60
long backcolor = 15780518
string text = "Receipt Lot No"
end type

type cbx_2 from so_checkbox within tabpage_1
integer x = 23
integer y = 76
integer width = 613
long backcolor = 15780518
boolean enabled = false
string text = "Use Material MFS"
end type

event constructor;call super::constructor;if Gvs_use_material_mfs = 'Y' then 
	this.checked = true 
else
	this.checked = false
end if
end event

type st_location_code from so_statictext within tabpage_1
integer x = 1042
integer y = 4
integer width = 1019
integer height = 60
long backcolor = 15780518
string text = "Location Code"
end type

type ddlb_location_code from uo_basecode within tabpage_1
integer x = 1033
integer y = 60
integer width = 1019
integer height = 1056
integer taborder = 30
end type

event constructor;call super::constructor;this.redraw( 'MATERIAL LOCATION CODE')
THIS.TEXT = 'M01'
end event

type cbx_1 from so_checkbox within tabpage_1
integer x = 23
integer width = 613
long backcolor = 15780518
boolean enabled = false
string text = "Use HUB Warehouse"
end type

event constructor;call super::constructor;IF Gvs_use_hub_warehouse = 'Y' then
	this.checked = true
else
	this.checked = false	
end if
end event

type cb_batch from so_commandbutton within tabpage_1
integer x = 2071
integer y = 32
integer width = 480
integer height = 112
integer taborder = 40
boolean bringtotop = true
string text = "Batch Receipt"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 

datawindow ivdw_datawindow


if rb_arrival.checked = true then 
     ivdw_datawindow = dw_1
elseif rb_arrival_bad.checked = true then 
     ivdw_datawindow = dw_5	
else
	  ivdw_datawindow = ivdw_datawindow
end if 


if ivdw_datawindow.rowcount() = 0 then return 

long i , j , lvl_receipt_seq , lvi_return , lvi_count
string lvs_item_code, lvs_supplier_code, lvs_origin_supplier_code , lvs_line_type, lvs_currency , lvs_receipt_lot_no , lvs_arrival_location_code , lvs_location_code , lvs_invoice_no
Decimal  lvd_unit_price, lvd_exchange_rate , lvl_receipt_qty , lvd_material_cost , lvf_tariff_rate
datetime lvd_receipt_date

lvd_receipt_date = uo_receipt_date.text()
lvs_location_code =  ddlb_location_code.getcode()
if lvs_location_code = '*' or lvs_location_code = '%' or lvs_location_code = '' or isnull(lvs_location_code) then 
	
	f_msgbox1(102 , st_location_code.text )
	return 
end if 

msg = f_msgbox1(1161,this.text)
if msg = 1 then 
else
	return 
end if 

ivdw_datawindow.accepttext()
dw_2.reset( )

lvs_receipt_lot_no= f_get_any_no( 'RECEIPT_LOT_NO')

open(w_progress_popup)
w_progress_popup.f_set_range(1 , ivdw_datawindow.rowcount( ) )
w_progress_popup.f_setstep(1)


for i = 1 to ivdw_datawindow.rowcount() 
	if ivdw_datawindow.object.check_yn[i] = 'Y' then 
		
		lvs_arrival_location_code = ivdw_datawindow.object.arrival_location_code[i] 
		//============================================		
		//$$HEX35$$c8d50cbe3dcce0ac7cb92000b4c6f0c558d5e0ac200004d6acc72000c4b329cc74c72000c8d50cbe3dcce0ac200074c774ba200085c7e0ac7cb9200060d518c22000c6c54cc7$$ENDHEX$$
		//$$HEX17$$b4b080bd3dcce0ac5cb8200074c7d9b32000c4d6200085c7e0ac200000aca5b22000$$ENDHEX$$
		//============================================				
		if lvs_arrival_location_code ='HUB' and Gvs_use_hub_warehouse = 'Y' then
			continue
		end if
		
		
		if Gvs_unit_price_check_yn = "Y" and ivdw_datawindow.object.unit_price_cfm[i]  < 0 then 
			continue
		end if 
	
		//============================================		
		j = dw_2.insertrow(0)
		f_set_security_row(dw_2, j , 'ALL')
		
		
		dw_2.object.receipt_date[j] = lvd_receipt_date  // f_t_sysdate()
		lvl_receipt_seq = f_get_sequence('seq_mat_receipt')
		dw_2.object.receipt_sequence[j] = long(lvl_receipt_seq)
		dw_2.object.receipt_deficit[j] = '1'
		dw_2.object.receipt_status[j] = 'N'	
		
//		if ivdw_datawindow.object.iqc_inspect_handling[i] = 'U' then 
//		   dw_2.object.receipt_type[j] = 'A'	
//		else
		   dw_2.object.receipt_type[j] = 'N'	
//		end if 
		lvl_receipt_qty = ivdw_datawindow.object.arrival_qty[i]
		dw_2.object.receipt_qty[j] = lvl_receipt_qty
		
		if Gvs_material_receipt_auto_confirm = 'Y' then
			
			dw_2.object.confirm_yn[j] = 'Y'
			dw_2.object.confirm_date[j] = lvd_receipt_date  //f_t_sysdate()
		else
			dw_2.object.confirm_yn[j] = 'N'
		end if 		
		//==========================================
		//$$HEX33$$90c7d9b39ccde0ac88d47cc72000bdacb0c62000d0c6acc7ccb87cb920006fb8b8d2c4bc5cb8200000adacb958d5c0c94ac594b2e4b220005cc6d0b058d574ba2000$$ENDHEX$$
		//$$HEX16$$90c7d9b39ccde0acdcc2d0c594b220006fb8b8d2c4bc5cb820009ccde0ac2000$$ENDHEX$$
		//$$HEX29$$98ccacb9200060d518c22000c6c530ae200084b538bbd0c52000d0c6acc7ccb820006fb8b8d288bc38d600ac200058c7f8bb00ac2000c6c5e4b2$$ENDHEX$$
		//==========================================
		if ivdw_datawindow.object.auto_issue_yn[i] = 'Y' then
			dw_2.object.material_mfs[j] = '*' 
		else
			dw_2.object.material_mfs[j] = ivdw_datawindow.object.material_mfs[i]
		end if
		//=========================================
		// $$HEX20$$d0c6acc7ccb820001cc870c888bc38d67cb9200004c758ce200015c8f4bc5cb8200000b3b4cc2000$$ENDHEX$$
		//=========================================		
		if gvs_material_mfs_replace_location_code = "Y" then
				dw_2.object.material_mfs[j] =  lvs_location_code
		else
			
			if Gvs_use_material_mfs = 'Y' then
				dw_2.object.material_mfs[j] = ivdw_datawindow.object.material_mfs[i]			
			else
				dw_2.object.material_mfs[j] = '*'
			end if
		end if 
		dw_2.object.mfs[j] = ivdw_datawindow.object.mfs[i]
		
		
		//========================================
		//  invoice no check
		//  $$HEX32$$a1c154d6e8b2200088bc38d6200000ac200074c7f8bb200085c7e0ac200015c8f4bcd0c52000e4b4b4c5200088c794b2c0c9200080acacc020005cd5e4b22000$$ENDHEX$$.
		//========================================
			lvi_count = 0;
			lvs_invoice_no      =  ivdw_datawindow.object.invoice_no[i]
			lvs_item_code      = ivdw_datawindow.object.item_code[i]
			lvs_supplier_code = ivdw_datawindow.object.supplier_code[i]
			
			
			select count(*) 
			  into :lvi_count 
			from im_item_receipt 
		   where item_code      = :lvs_item_code
			  and supplier_code = :lvs_supplier_code
			  and receipt_date >= trunc(sysdate -30)
			  and invoice_no     = :lvs_invoice_no
			  and location_code = :lvs_location_code
			  and receipt_status <> 'C'
			  and receipt_deficit <> '2'
			  and organization_id = :gvi_organization_id ;
				
			  if f_sql_check() < 0 then 
				return 
			  end if 
				  
			if lvi_count = 0 then 
					dw_2.object.invoice_no[j] =lvs_invoice_no
			else
				f_msgbox1(813 ," "+lvs_invoice_no+" "+ lvs_item_code +" "+lvs_supplier_code +" " +lvs_location_code)
				close(w_progress_popup)
				dw_2.reset()
				return 
			end if 		
		
		dw_2.object.order_type[j] = ivdw_datawindow.object.order_type[i]

		
		dw_2.object.arrival_date[j] = ivdw_datawindow.object.arrival_date[i]
		dw_2.object.arrival_seq_no[j] = ivdw_datawindow.object.arrival_seq_no[i]			
		
		lvs_item_code = ivdw_datawindow.object.item_code[i]
		lvs_supplier_code =  ivdw_datawindow.object.supplier_code[i]
		lvs_origin_supplier_code=  ivdw_datawindow.object.origin_supplier_code[i]
		lvs_line_type = ivdw_datawindow.object.line_type[i]
		dw_2.object.item_code[j] = lvs_item_code 
		dw_2.object.item_name[j] = ivdw_datawindow.object.item_name[i]
		dw_2.object.item_spec[j] = ivdw_datawindow.object.item_spec[i]
		dw_2.object.incidental_expense_code[j] = ivdw_datawindow.object.incidental_expense_code[i]		
		dw_2.object.line_type[j] = lvs_line_type		
		dw_2.object.location_code[j] =lvs_location_code
		
		if lvs_line_type = 'P' then 
			lvf_tariff_rate = f_get_tariff_rate( lvs_item_code)
		end if
		
		dw_2.object.receipt_lot_no[j] = lvs_receipt_lot_no		
		dw_2.object.interface_yn[j] = 'N'
		//=============================================================
		// $$HEX19$$6cade4b9e8b200ac20002000b9c278c71cb42000e8b200ac7cb9200070c88cd620005cd5e4b2$$ENDHEX$$
		//=============================================================		

		if Gvs_unit_price_check_yn ="Y" or isnull(Gvs_unit_price_check_yn) then
			
					lvd_unit_price = f_get_item_unit_price_confirm(lvs_supplier_code,lvs_item_code , lvs_line_type, f_t_sysdate())
					
					if ( lvd_unit_price <= 0 or isnull(lvd_unit_price) ) and lvs_line_type <> 'F' then 

						close(w_progress_popup)
						dw_2.reset()
						return 
					else
						dw_2.object.unit_price[j] = lvd_unit_price 
					end if
					
					lvs_currency = gst_return.gvs_return[1]
					
					gst_return.gvs_return[1] = ''		
					if ( lvs_currency  = '' or isnull( lvs_currency  ) ) and lvs_line_type <> 'F' then 
						dw_2.reset()			
						close(w_progress_popup)
						messagebox('Notify','Return currency is error!')
						return 
					else
						dw_2.object.currency[j] = lvs_currency
					end if 
					
					lvd_exchange_rate = gst_return.gvf_return[1]
					gst_return.gvf_return[1] = 0 
					
					if ( lvd_exchange_rate <= 0 or isnull( lvd_exchange_rate )) and lvs_line_type <> 'F' then 
						dw_2.reset()			
						close(w_progress_popup)
						messagebox('Notify','Return exchange rate is error!')
						return 
					else
						dw_2.object.exchange_rate[j] = lvd_exchange_rate
					end if 		
					
					dw_2.object.delivery[j] = gst_return.gvs_return[2]		
					
		else //$$HEX13$$6cade4b9e8b200ac2000b4cc6cd0200018c2d9b374c774ba2000$$ENDHEX$$

			lvd_unit_price = ivdw_datawindow.object.unit_price[i] 
			lvs_currency = ivdw_datawindow.object.currency[i] 
			if isnull(ivdw_datawindow.object.exchange_rate[i]) then 
				lvd_exchange_rate  = 1
			else
				lvd_exchange_rate = ivdw_datawindow.object.exchange_rate[i]
			end if
			
			dw_2.object.unit_price[j] = lvd_unit_price 
			dw_2.object.currency[j] = lvs_currency
			dw_2.object.exchange_rate[j] = lvd_exchange_rate
		end if 
		

		dw_2.object.material_cost[j] =lvd_material_cost
		dw_2.object.receipt_amt[j] = lvl_receipt_qty * lvd_unit_price * lvd_exchange_rate
		dw_2.object.tariff_amt[j]  = Round(dw_2.object.receipt_amt[j]  * lvf_tariff_rate / 100 , 3)
		
		
		dw_2.object.material_cost_amt[j] = lvl_receipt_qty * lvd_material_cost
		dw_2.object.foreign_receipt_amt[j] =   lvl_receipt_qty * lvd_unit_price		

		dw_2.object.supplier_code[j] = lvs_supplier_code 
		dw_2.object.supplier_name[j] = ivdw_datawindow.object.supplier_name[i]
		
		dw_2.object.origin_supplier_code[j] = lvs_origin_supplier_code 
		
		//=================================
		// $$HEX13$$8cd6c4ac2000dcc2a4c25cd1200078c730d198d374c7a4c22000$$ENDHEX$$interface
		// return : work_no
		//=================================
		if Gvs_interface_yn = 'N' then
		else
//			lvi_return = sqlca.f_interface_receipt(   f_t_sysdate() , &
//																  lvl_receipt_seq , &
//																'1' , &
//																lvs_line_type , &										
//																lvs_supplier_code,  &
//																lvl_receipt_qty * lvd_unit_price * lvd_exchange_rate , &
//																lvl_receipt_qty * lvd_unit_price,  &
//																lvd_exchange_rate, &
//																lvs_currency, &
//																Gvs_user_id,&
//																f_t_sysdate(),  &
//																0 , &
//																Gvi_organization_id ) ;
																
																
			
			if f_sql_check() < 0 then
				return
			end if ;
			
			if lvi_return < 0 then 
				Messagebox("Notify" , "Intrface Error")
				rollback;
				return
				
				
			elseif lvi_return = 0 then 
			else
				
						dw_2.object.interface_date[j] = f_t_sysdate()
						dw_2.object.interface_yn[j] = 'Y'
						dw_2.object.interface_work_no[j] = lvi_return
				
			end if
		end if
		
//=================================		
	end if 
w_progress_popup.f_stepit()

next 
close(w_progress_popup)

if dw_2.rowcount() = 0 then return 
dw_2.accepttext()

msg = f_msgbox1(1161,this.text)
if msg = 1 then 
else
	dw_2.reset()
	return 
end if 
if  dw_2.update() < 0 then 
	rollback; 
	dw_2.reset()
	f_msg_mdi_help(f_msg_st(9026))
else
	commit; 
	dw_2.reset()	
	f_msg_mdi_help(f_msg_st(170))
end if 
f_retrieve()


end event

type tabpage_2 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 4192
integer height = 156
long backcolor = 15780518
string text = "Lot Manage"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Horizontal!"
long picturemaskcolor = 536870912
cb_1 cb_1
cb_divide cb_divide
cb_generate cb_generate
end type

on tabpage_2.create
this.cb_1=create cb_1
this.cb_divide=create cb_divide
this.cb_generate=create cb_generate
this.Control[]={this.cb_1,&
this.cb_divide,&
this.cb_generate}
end on

on tabpage_2.destroy
destroy(this.cb_1)
destroy(this.cb_divide)
destroy(this.cb_generate)
end on

type cb_1 from so_commandbutton within tabpage_2
integer x = 869
integer y = 32
integer width = 430
integer height = 100
integer taborder = 130
boolean bringtotop = true
string text = "Lot Merge"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 

datawindow ivdw_datawindow

if rb_arrival.checked = true then 
     ivdw_datawindow = dw_1
elseif rb_arrival_bad.checked = true then 
     ivdw_datawindow = dw_5	
else
	  ivdw_datawindow = ivdw_datawindow
end if 


if ivdw_datawindow.rowcount() < 1  then return 
long i , j = 0 , lvl_row[2], k= 1
Decimal  lvd_qty

for i = 1 to ivdw_datawindow.rowcount()
	
	 if ivdw_datawindow.object.check_yn[i] = 'Y' then 
		j++
	 else
		
	 end if
next

if j <> 2 then 
	messagebox('Notify','You have to select two records, please do again!')
	return 
end if 

for i = 1 to ivdw_datawindow.rowcount()
	
	if ivdw_datawindow.object.check_yn[i] = 'Y' then 
		lvl_row[k] = ivdw_datawindow.object.selected_row[i]
		k++
	end if 
	
next


msg = f_msgbox1( 1161 , this.text )
if msg = 1 then 
else
	return
end if

if ivdw_datawindow.object.item_code[lvl_row[1]]  = ivdw_datawindow.object.item_code[lvl_row[2]]   and ivdw_datawindow.object.arrival_date[lvl_row[1]]  = ivdw_datawindow.object.arrival_date[lvl_row[2]]   and ivdw_datawindow.object.arrival_seq_no_origin[lvl_row[1]]  = ivdw_datawindow.object.arrival_seq_no_origin[lvl_row[2]]   then
	
	lvd_qty =  ivdw_datawindow.object.arrival_qty[lvl_row[1]] + ivdw_datawindow.object.arrival_qty[lvl_row[2]]
	
	ivdw_datawindow.object.arrival_qty[lvl_row[1]]  = lvd_qty
	ivdw_datawindow.object.arrival_amt[lvl_row[1]]  = ivdw_datawindow.object.unit_price[lvl_row[1]]  * ivdw_datawindow.object.arrival_qty[lvl_row[1]] 
	ivdw_datawindow.object.arrival_seq_no[lvl_row[1]]  =ivdw_datawindow.object.arrival_seq_no_origin[lvl_row[1]] 
	ivdw_datawindow.deleterow(lvl_row[2])
	
			IF ivdw_datawindow.UPDATE() < 0  THEN
			  	 ROLLBACK;
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			END IF
	
else
	messagebox('Notify','This two records are not match!')
	return 
end if 

	
end event

type cb_divide from so_commandbutton within tabpage_2
integer x = 434
integer y = 32
integer width = 430
integer height = 100
integer taborder = 120
boolean bringtotop = true
string text = "Lot Divide"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 
long i , j 
Decimal  lvd_arrival_qty, lvd_new_qty

datawindow ivdw_datawindow

if rb_arrival.checked = true then 
     ivdw_datawindow = dw_1
elseif rb_arrival_bad.checked = true then 
     ivdw_datawindow = dw_5	
else
	  ivdw_datawindow = ivdw_datawindow
end if 

if ivdw_datawindow.rowcount() < 1  then return 

Do
	i++
	if ivdw_datawindow.object.check_yn[i] = 'Y' then 
		j++
	end if
		
loop until i  = ivdw_datawindow.rowcount() 
	
if j <> 1 then 	
	Messagebox("Nofity" , "Please check mark just one row")
	return
end if
		
		Long lvl_old_row
		//=======================================================
		// 
		//=======================================================
		if ivdw_datawindow.object.check_yn[ivdw_datawindow.getrow()] = 'Y'  and ivdw_datawindow.object.inspect_result[ivdw_datawindow.getrow()] = 'P'  then 
			
			lvl_old_row = ivdw_datawindow.getrow()
		else
			Return
		end if
		
		lvd_arrival_qty = ivdw_datawindow.object.arrival_qty[lvl_old_row]
		openwithparm(w_qc_iqc_lot_popup,lvd_arrival_qty)
		
		if gst_return.gvb_return = true then 
			
			lvd_new_qty =message.doubleparm

		else
			Return
		end if 
		
		if lvd_new_qty >=  lvd_arrival_qty then 
			messagebox('Notify','Divide qty should not be larger than the origin one!')
			return 
		end if 
		
		Long lvs_rows
		
		ivdw_datawindow.object.arrival_qty[lvl_old_row] = lvd_arrival_qty - lvd_new_qty
		ivdw_datawindow.object.arrival_amt[lvl_old_row] = ivdw_datawindow.object.arrival_qty[lvl_old_row]  * ivdw_datawindow.object.unit_price[lvl_old_row] 				
		ivdw_datawindow.object.check_yn[lvl_old_row] = 'N'
		ivdw_datawindow.object.lot_div_yn[lvl_old_row] = 'Y'		
		
		//====================================================================
		
		ivdw_datawindow.rowscopy(lvl_old_row, lvl_old_row, Primary!, ivdw_datawindow,lvl_old_row,Primary!)		

		ivdw_datawindow.object.arrival_qty[lvl_old_row] = lvd_new_qty
		ivdw_datawindow.object.arrival_amt[lvl_old_row] = ivdw_datawindow.object.arrival_qty[lvl_old_row]  * ivdw_datawindow.object.unit_price[lvl_old_row] 		
		ivdw_datawindow.object.check_yn[lvl_old_row] = 'N'
		ivdw_datawindow.object.lot_div_yn[lvl_old_row] = 'Y'		
		ivdw_datawindow.object.arrival_seq_no[lvl_old_row] =  f_get_sequence( 'seq_mat_arrival')
		
IF ivdw_datawindow.UPDATE() < 0  THEN
	 ROLLBACK;
ELSE
	 COMMIT;
	 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
END IF
end event

type cb_generate from so_commandbutton within tabpage_2
integer x = 23
integer y = 32
integer width = 407
integer height = 100
integer taborder = 70
boolean bringtotop = true
boolean enabled = false
string text = "Generate"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 
if dw_3.rowcount() < 1 then return 
long i , j 
string lvs_supplier_code, lvs_date
msg = f_msgbox1(1161,this.text)
if msg = 1 then 
else
	return 
end if 
for i = 1 to dw_3.rowcount() 
	
	if dw_3.object.check_yn[i] = 'Y' and  ( dw_3.object.receipt_expense_cost[i] = 0  or isnull(dw_3.object.receipt_expense_cost[i]) ) then 
		continue
	elseif dw_3.object.check_yn[i] = 'Y' and  dw_3.object.receipt_expense_cost[i] <> 0 then 
		messagebox('Notify','Receipt expemse cost is exists, so you can not generate Receipt lot no!')
		return 
	end if 
next

lvs_date =  f_get_any_no( 'RECEIPT_LOT_NO')
for i = 1 to dw_3.rowcount() 
	
	if dw_3.object.check_yn[i] = 'Y' and ( dw_3.object.receipt_expense_cost[i] = 0  or isnull(dw_3.object.receipt_expense_cost[i] ))  then 
		dw_3.object.receipt_lot_no[i] = lvs_date
	end if 
	
next

if dw_3.update() < 0 then 
	rollback ; 
	f_msg_mdi_help(f_msg_st(9026))
else
	commit ; 
	f_msg_mdi_help(f_msg_st(170))
	f_retrieve()
end if 
	

		
		
	
end event

type tabpage_3 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 4192
integer height = 156
long backcolor = 15780518
string text = "Print"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Print!"
long picturemaskcolor = 12632256
cb_print cb_print
cb_preview cb_preview
cbx_dialog cbx_dialog
em_copy em_copy
st_2 st_2
end type

on tabpage_3.create
this.cb_print=create cb_print
this.cb_preview=create cb_preview
this.cbx_dialog=create cbx_dialog
this.em_copy=create em_copy
this.st_2=create st_2
this.Control[]={this.cb_print,&
this.cb_preview,&
this.cbx_dialog,&
this.em_copy,&
this.st_2}
end on

on tabpage_3.destroy
destroy(this.cb_print)
destroy(this.cb_preview)
destroy(this.cbx_dialog)
destroy(this.em_copy)
destroy(this.st_2)
end on

type cb_print from so_commandbutton within tabpage_3
integer x = 1038
integer y = 28
integer width = 361
integer height = 108
integer taborder = 100
boolean bringtotop = true
string text = "Print"
end type

event clicked;call super::clicked;Int		i, lvi_cnt , rows

If dw_5.rowcount() < 1 Then Return

		lvi_cnt = Integer(em_copy.text)
		If lvi_cnt > 0 Then
			If rb_receipt.checked = True Then
				For i = 1 To lvi_cnt
					
					if cbx_dialog.checked = true then 
						dw_4.print(false, True)
					else
						dw_4.print(false, False)						
					end if
				Next
			End If
		End If

end event

type cb_preview from so_commandbutton within tabpage_3
integer x = 672
integer y = 28
integer width = 361
integer height = 108
integer taborder = 60
boolean bringtotop = true
string text = "Preview"
end type

event clicked;call super::clicked;if rb_receipt.checked = true then 
	if  ivs_preview_yn = 'Y' THEN 
		ivs_preview_yn = 'N' 	
		dw_3.bringtotop = TRUE
	else
		ivs_preview_yn = 'Y' 	
		dw_4.bringtotop = TRUE	
		
		dw_4.retrieve( dw_3.object.receipt_lot_no[dw_3.getrow()] , gvi_organization_id )
			  
		if dw_4.Describe("DataWindow.Print.Preview") = '!' or dw_4.Describe("DataWindow.Print.Preview") = '?' then
		else
			 dw_4.Modify("DataWindow.Print.Preview=yes")
			dw_4.Modify("DataWindow.Print.Preview.Rulers=yes")
		end if		
	end if
end if
	
end event

type cbx_dialog from so_checkbox within tabpage_3
integer x = 1417
integer y = 36
integer width = 393
boolean bringtotop = true
long backcolor = 15780518
string text = "Show Dialog"
end type

type em_copy from so_editmask within tabpage_3
integer x = 352
integer y = 40
integer width = 311
integer taborder = 60
boolean bringtotop = true
string text = "1"
string mask = "##0"
boolean spin = true
end type

type st_2 from so_statictext within tabpage_3
integer x = 27
integer y = 52
integer width = 311
integer height = 56
boolean bringtotop = true
long backcolor = 15780518
string text = "Print Copy"
end type

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 4192
integer height = 156
long backcolor = 15780518
string text = "Relocate"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Redo!"
long picturemaskcolor = 536870912
st_10 st_10
ddlb_relocate_line_type ddlb_relocate_line_type
cb_2 cb_2
st_9 st_9
uo_relocate_dateset uo_relocate_dateset
st_8 st_8
ddlb_relocate_supplier ddlb_relocate_supplier
st_7 st_7
ddlb_relocate_item ddlb_relocate_item
st_6 st_6
uo_relocate_end uo_relocate_end
uo_relocate_start uo_relocate_start
end type

on tabpage_4.create
this.st_10=create st_10
this.ddlb_relocate_line_type=create ddlb_relocate_line_type
this.cb_2=create cb_2
this.st_9=create st_9
this.uo_relocate_dateset=create uo_relocate_dateset
this.st_8=create st_8
this.ddlb_relocate_supplier=create ddlb_relocate_supplier
this.st_7=create st_7
this.ddlb_relocate_item=create ddlb_relocate_item
this.st_6=create st_6
this.uo_relocate_end=create uo_relocate_end
this.uo_relocate_start=create uo_relocate_start
this.Control[]={this.st_10,&
this.ddlb_relocate_line_type,&
this.cb_2,&
this.st_9,&
this.uo_relocate_dateset,&
this.st_8,&
this.ddlb_relocate_supplier,&
this.st_7,&
this.ddlb_relocate_item,&
this.st_6,&
this.uo_relocate_end,&
this.uo_relocate_start}
end on

on tabpage_4.destroy
destroy(this.st_10)
destroy(this.ddlb_relocate_line_type)
destroy(this.cb_2)
destroy(this.st_9)
destroy(this.uo_relocate_dateset)
destroy(this.st_8)
destroy(this.ddlb_relocate_supplier)
destroy(this.st_7)
destroy(this.ddlb_relocate_item)
destroy(this.st_6)
destroy(this.uo_relocate_end)
destroy(this.uo_relocate_start)
end on

type st_10 from so_statictext within tabpage_4
integer x = 1797
integer y = 8
integer width = 539
integer height = 60
long backcolor = 15780518
string text = "Line Type"
end type

type ddlb_relocate_line_type from uo_line_type within tabpage_4
integer x = 1797
integer y = 72
integer width = 544
integer taborder = 20
end type

type cb_2 from so_commandbutton within tabpage_4
integer x = 2761
integer y = 64
integer width = 485
integer height = 92
integer taborder = 30
string text = "Price Relocate"
end type

event clicked;call super::clicked;int lvi_count
string lvs_item_code , lvs_supplier_code , lvs_line_type , lvs_currency
Decimal lvf_new_price
Datetime lvdt_dateset , lvdt_receipt_dateset , lvdt_receipt_dateend

//===================================
//
//===================================

lvs_item_code  = ddlb_relocate_item.text
lvs_supplier_code  = ddlb_relocate_supplier.text
lvs_line_type =ddlb_relocate_line_type.getcode()
lvdt_dateset = uo_relocate_dateset.text()

lvdt_receipt_dateset = uo_relocate_start.text()
lvdt_receipt_dateend= uo_relocate_end.text()


if lvs_item_code = '%' or isnull(lvs_item_code) or lvs_supplier_code = '%' or isnull(lvs_supplier_code) or lvs_line_type = '%' or isnull(lvs_line_type) then
	Messagebox("Notify" , "Relocate condition invalid please check again!")
	return
end if 

//===================================
//
//===================================
select count(*) into :lvi_count
  from im_item_receipt 
 where supplier_code = :lvs_supplier_code
    and item_code = :lvs_item_code
    and line_type = :lvs_line_type
    and receipt_date  >= :lvdt_receipt_dateset
    and receipt_date  <= :lvdt_receipt_dateend	 
    and organization_id = :gvi_organization_id ;
	 
if f_sql_check() < 0 then 
	return
end if

if lvi_count < 1 then 
	Messagebox("Notify" , "Receipt data not found")
	return
else
	msg = f_msgbox1( 1161 , string(lvi_count)+"  Rows found "+this.text )
	if msg = 1 then 
	else
		return
	end if

end if 
//===================================
//
//===================================
lvi_count = 0 
select count(*) into :lvi_count
   from im_item_unit_price
where supplier_code = :lvs_supplier_code
    and item_code = :lvs_item_code
    and line_type = :lvs_line_type
    and dateset  <= trunc(sysdate)
    and dateend >= trunc(sysdate)	 
    and organization_id = :gvi_organization_id ;
	 
if f_sql_check() < 0 then 
	return
end if
	 
if lvi_count < 1 then 
	Messagebox("Notify" , "New Price Not Found")
	return
else
	
	lvf_new_price = f_get_item_unit_price_confirm( lvs_supplier_code , lvs_item_code , lvs_line_type , lvdt_dateset  )

	if lvf_new_price <= 0 then 
		Messagebox("Notify" ,lvs_supplier_code+"  "+lvs_item_code+ "  "+lvs_line_type+" New Price Invalid")
		return
	end if
	
end if
//==================================
//
//==================================
lvs_currency = gst_return.gvs_return[1] 

//==================================
//
//==================================
update im_item_receipt 
       set unit_price                 = :lvf_new_price , 
             receipt_amt              =  receipt_qty * :lvf_new_price * nvl(exchange_rate ,1), 
		   foreign_receipt_amt =  decode( currency , f_get_local_currency( organization_id ) , 0 , receipt_qty * :lvf_new_price ) ,
		   currency = :lvs_currency
 where supplier_code = :lvs_supplier_code
    and item_code        = :lvs_item_code
    and line_type          = :lvs_line_type
    and receipt_date  >= :lvdt_receipt_dateset
    and receipt_date  <= :lvdt_receipt_dateend	 
    and organization_id = :gvi_organization_id ;
	 
if f_sql_check() < 0 then 
	return
end if
//=================================
//
//=================================
msg = f_msgbox1(9014 , string(sqlca.sqlnrows))
if msg = 1 then
	commit ;
	Messagebox("Notify" , "Please Retry Material Inventory Close!")
else
	rollback;
end if
end event

type st_9 from so_statictext within tabpage_4
integer x = 2345
integer y = 8
integer width = 407
integer height = 60
long backcolor = 15780518
string text = "Apply Date"
end type

type uo_relocate_dateset from uo_ymd_calendar within tabpage_4
event destroy ( )
integer x = 2341
integer y = 72
integer taborder = 60
boolean bringtotop = true
end type

on uo_relocate_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_8 from so_statictext within tabpage_4
integer x = 1358
integer y = 12
integer width = 439
integer height = 60
boolean bringtotop = true
long backcolor = 15780518
string text = "Supplier Code"
end type

type ddlb_relocate_supplier from uo_supplier_code within tabpage_4
integer x = 1358
integer y = 72
integer width = 439
integer taborder = 30
boolean bringtotop = true
end type

type st_7 from so_statictext within tabpage_4
integer x = 846
integer y = 12
integer width = 517
integer height = 60
boolean bringtotop = true
long backcolor = 15780518
string text = "Item Code"
end type

type ddlb_relocate_item from uo_item_code within tabpage_4
integer x = 837
integer y = 72
integer width = 517
integer taborder = 30
boolean bringtotop = true
end type

type st_6 from so_statictext within tabpage_4
integer x = 5
integer y = 12
integer width = 837
integer height = 60
long backcolor = 15780518
string text = "Relocate Date"
end type

type uo_relocate_end from uo_ymd_calendar within tabpage_4
event destroy ( )
integer x = 425
integer y = 72
integer taborder = 50
boolean bringtotop = true
end type

on uo_relocate_end.destroy
call uo_ymd_calendar::destroy
end on

type uo_relocate_start from uo_ymd_calendar within tabpage_4
event destroy ( )
integer x = 14
integer y = 72
integer taborder = 40
boolean bringtotop = true
end type

on uo_relocate_start.destroy
call uo_ymd_calendar::destroy
end on

type sle_material_mfs from so_singlelineedit within w_mat_receipt_master
integer x = 2537
integer y = 160
integer width = 439
integer height = 84
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

type material_mfs_t from so_statictext within w_mat_receipt_master
integer x = 2537
integer y = 88
integer width = 439
integer height = 56
boolean bringtotop = true
string text = "Material MFS"
end type

type rb_arrival_bad from so_radiobutton within w_mat_receipt_master
integer x = 55
integer y = 132
integer width = 617
boolean bringtotop = true
string text = "Arrival List(BAD)"
end type

event clicked;call super::clicked;dw_5.bringtotop = true 
selected_data_window = dw_5
tab_1.tabpage_1.cb_batch.enabled = true 

tab_1.tabpage_2.cb_generate.enabled = false


tab_1.tabpage_1.sle_receipt_lot_no.enabled = false
tab_1.tabpage_1.cb_gen_lot_no.enabled = false


tab_1.tabpage_1.ddlb_location_code.text = 'M02'
end event

type sle_invoice_no from so_singlelineedit within w_mat_receipt_master
integer x = 4064
integer y = 164
integer width = 494
integer height = 84
integer taborder = 100
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

type st_invoice_no from so_statictext within w_mat_receipt_master
integer x = 4064
integer y = 84
integer width = 494
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Invoice No"
end type

type st_5 from so_statictext within w_mat_receipt_master
integer x = 3424
integer y = 84
integer width = 640
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Location Code"
end type

type ddlb_location_code_cond from uo_basecode within w_mat_receipt_master
integer x = 3424
integer y = 160
integer width = 640
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'MATERIAL LOCATION CODE')
end event

type st_11 from so_statictext within w_mat_receipt_master
integer x = 4553
integer y = 88
integer width = 494
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Inspect Result"
end type

type ddlb_inspect_result from uo_basecode within w_mat_receipt_master
integer x = 4571
integer y = 168
integer width = 485
integer height = 384
integer taborder = 50
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw('INSPECT RESULT')
end event

type gb_1 from so_groupbox within w_mat_receipt_master
integer width = 709
integer height = 300
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_mat_receipt_master
integer x = 709
integer width = 4384
integer height = 300
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

