HA$PBExportHeader$w_mat_current_inventory_master.srw
$PBExportComments$Material Current Inventory Master
forward
global type w_mat_current_inventory_master from w_main_root
end type
type st_1 from so_statictext within w_mat_current_inventory_master
end type
type ddlb_item_code from uo_item_code within w_mat_current_inventory_master
end type
type rb_summary from so_radiobutton within w_mat_current_inventory_master
end type
type rb_detail from so_radiobutton within w_mat_current_inventory_master
end type
type cb_close_all from so_commandbutton within w_mat_current_inventory_master
end type
type cb_release_all from so_commandbutton within w_mat_current_inventory_master
end type
type rb_all from so_radiobutton within w_mat_current_inventory_master
end type
type rb_gt from so_radiobutton within w_mat_current_inventory_master
end type
type ddlb_location_code from uo_basecode within w_mat_current_inventory_master
end type
type st_4 from so_statictext within w_mat_current_inventory_master
end type
type rb_matrix from so_radiobutton within w_mat_current_inventory_master
end type
type pb_move from so_commandbutton within w_mat_current_inventory_master
end type
type rb_simple from so_radiobutton within w_mat_current_inventory_master
end type
type st_5 from so_statictext within w_mat_current_inventory_master
end type
type sle_material_mfs from so_singlelineedit within w_mat_current_inventory_master
end type
type sle_receipt_slip_no from so_singlelineedit within w_mat_current_inventory_master
end type
type st_9 from so_statictext within w_mat_current_inventory_master
end type
type sle_our_barcode from so_singlelineedit within w_mat_current_inventory_master
end type
type st_11 from so_statictext within w_mat_current_inventory_master
end type
type em_unit_price from so_editmask within w_mat_current_inventory_master
end type
type st_8 from so_statictext within w_mat_current_inventory_master
end type
type st_6 from so_statictext within w_mat_current_inventory_master
end type
type ddlb_supplier_code from uo_supplier_name_code within w_mat_current_inventory_master
end type
type em_life_cycle from so_editmask within w_mat_current_inventory_master
end type
type st_3 from so_statictext within w_mat_current_inventory_master
end type
type rb_life_cycle from so_radiobutton within w_mat_current_inventory_master
end type
type sle_vendor_lotno from so_singlelineedit within w_mat_current_inventory_master
end type
type st_2 from so_statictext within w_mat_current_inventory_master
end type
type ddlb_inventory_type from uo_basecode within w_mat_current_inventory_master
end type
type st_7 from so_statictext within w_mat_current_inventory_master
end type
type sle_item_name from so_singlelineedit within w_mat_current_inventory_master
end type
type st_10 from so_statictext within w_mat_current_inventory_master
end type
type gb_2 from so_groupbox within w_mat_current_inventory_master
end type
type gb_1 from so_groupbox within w_mat_current_inventory_master
end type
type gb_4 from so_groupbox within w_mat_current_inventory_master
end type
type gb_5 from so_groupbox within w_mat_current_inventory_master
end type
end forward

global type w_mat_current_inventory_master from w_main_root
integer width = 5947
integer height = 3056
string title = "Current Inventory Query"
st_1 st_1
ddlb_item_code ddlb_item_code
rb_summary rb_summary
rb_detail rb_detail
cb_close_all cb_close_all
cb_release_all cb_release_all
rb_all rb_all
rb_gt rb_gt
ddlb_location_code ddlb_location_code
st_4 st_4
rb_matrix rb_matrix
pb_move pb_move
rb_simple rb_simple
st_5 st_5
sle_material_mfs sle_material_mfs
sle_receipt_slip_no sle_receipt_slip_no
st_9 st_9
sle_our_barcode sle_our_barcode
st_11 st_11
em_unit_price em_unit_price
st_8 st_8
st_6 st_6
ddlb_supplier_code ddlb_supplier_code
em_life_cycle em_life_cycle
st_3 st_3
rb_life_cycle rb_life_cycle
sle_vendor_lotno sle_vendor_lotno
st_2 st_2
ddlb_inventory_type ddlb_inventory_type
st_7 st_7
sle_item_name sle_item_name
st_10 st_10
gb_2 gb_2
gb_1 gb_1
gb_4 gb_4
gb_5 gb_5
end type
global w_mat_current_inventory_master w_mat_current_inventory_master

on w_mat_current_inventory_master.create
int iCurrent
call super::create
this.st_1=create st_1
this.ddlb_item_code=create ddlb_item_code
this.rb_summary=create rb_summary
this.rb_detail=create rb_detail
this.cb_close_all=create cb_close_all
this.cb_release_all=create cb_release_all
this.rb_all=create rb_all
this.rb_gt=create rb_gt
this.ddlb_location_code=create ddlb_location_code
this.st_4=create st_4
this.rb_matrix=create rb_matrix
this.pb_move=create pb_move
this.rb_simple=create rb_simple
this.st_5=create st_5
this.sle_material_mfs=create sle_material_mfs
this.sle_receipt_slip_no=create sle_receipt_slip_no
this.st_9=create st_9
this.sle_our_barcode=create sle_our_barcode
this.st_11=create st_11
this.em_unit_price=create em_unit_price
this.st_8=create st_8
this.st_6=create st_6
this.ddlb_supplier_code=create ddlb_supplier_code
this.em_life_cycle=create em_life_cycle
this.st_3=create st_3
this.rb_life_cycle=create rb_life_cycle
this.sle_vendor_lotno=create sle_vendor_lotno
this.st_2=create st_2
this.ddlb_inventory_type=create ddlb_inventory_type
this.st_7=create st_7
this.sle_item_name=create sle_item_name
this.st_10=create st_10
this.gb_2=create gb_2
this.gb_1=create gb_1
this.gb_4=create gb_4
this.gb_5=create gb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.ddlb_item_code
this.Control[iCurrent+3]=this.rb_summary
this.Control[iCurrent+4]=this.rb_detail
this.Control[iCurrent+5]=this.cb_close_all
this.Control[iCurrent+6]=this.cb_release_all
this.Control[iCurrent+7]=this.rb_all
this.Control[iCurrent+8]=this.rb_gt
this.Control[iCurrent+9]=this.ddlb_location_code
this.Control[iCurrent+10]=this.st_4
this.Control[iCurrent+11]=this.rb_matrix
this.Control[iCurrent+12]=this.pb_move
this.Control[iCurrent+13]=this.rb_simple
this.Control[iCurrent+14]=this.st_5
this.Control[iCurrent+15]=this.sle_material_mfs
this.Control[iCurrent+16]=this.sle_receipt_slip_no
this.Control[iCurrent+17]=this.st_9
this.Control[iCurrent+18]=this.sle_our_barcode
this.Control[iCurrent+19]=this.st_11
this.Control[iCurrent+20]=this.em_unit_price
this.Control[iCurrent+21]=this.st_8
this.Control[iCurrent+22]=this.st_6
this.Control[iCurrent+23]=this.ddlb_supplier_code
this.Control[iCurrent+24]=this.em_life_cycle
this.Control[iCurrent+25]=this.st_3
this.Control[iCurrent+26]=this.rb_life_cycle
this.Control[iCurrent+27]=this.sle_vendor_lotno
this.Control[iCurrent+28]=this.st_2
this.Control[iCurrent+29]=this.ddlb_inventory_type
this.Control[iCurrent+30]=this.st_7
this.Control[iCurrent+31]=this.sle_item_name
this.Control[iCurrent+32]=this.st_10
this.Control[iCurrent+33]=this.gb_2
this.Control[iCurrent+34]=this.gb_1
this.Control[iCurrent+35]=this.gb_4
this.Control[iCurrent+36]=this.gb_5
end on

on w_mat_current_inventory_master.destroy
call super::destroy
destroy(this.st_1)
destroy(this.ddlb_item_code)
destroy(this.rb_summary)
destroy(this.rb_detail)
destroy(this.cb_close_all)
destroy(this.cb_release_all)
destroy(this.rb_all)
destroy(this.rb_gt)
destroy(this.ddlb_location_code)
destroy(this.st_4)
destroy(this.rb_matrix)
destroy(this.pb_move)
destroy(this.rb_simple)
destroy(this.st_5)
destroy(this.sle_material_mfs)
destroy(this.sle_receipt_slip_no)
destroy(this.st_9)
destroy(this.sle_our_barcode)
destroy(this.st_11)
destroy(this.em_unit_price)
destroy(this.st_8)
destroy(this.st_6)
destroy(this.ddlb_supplier_code)
destroy(this.em_life_cycle)
destroy(this.st_3)
destroy(this.rb_life_cycle)
destroy(this.sle_vendor_lotno)
destroy(this.st_2)
destroy(this.ddlb_inventory_type)
destroy(this.st_7)
destroy(this.sle_item_name)
destroy(this.st_10)
destroy(this.gb_2)
destroy(this.gb_1)
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
Ivs_resize_type                      = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


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

event ue_post_open;call super::ue_post_open;

/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())



end event

event ue_data_control;call super::ue_data_control;Long row , lvi_sign
String lvs_date
choose case gvs_ue_data_control
		
	case 'RETRIEVE'		
		
			    if rb_all.checked = true then 
					lvi_sign = -2
			    elseif rb_gt.checked = true then 
					lvi_sign = 1
			    end if
		     
				if rb_summary.checked = true then 
					dw_1.retrieve(ddlb_item_code.text() + '%', sle_material_mfs.text+'%' ,  lvi_sign ,ddlb_supplier_code.getcode()+'%'  , ddlb_location_code.getcode()+'%' ,  gvs_language ,ddlb_inventory_type.getcode()+'%' ,  gvi_organization_id)
				elseif rb_detail.checked = true then 
					dw_2.retrieve(ddlb_item_code.text() + '%', sle_material_mfs.text+'%' , ddlb_supplier_code.getcode()+'%' , ddlb_location_code.getcode()+'%' ,  lvi_sign , sle_vendor_lotno.text+'%' ,ddlb_inventory_type.getcode()+'%' , '%'+sle_item_name.text+'%' ,  gvi_organization_id)				
				elseif rb_matrix.checked = true then 
					dw_3.retrieve( ddlb_item_code.text()+'%' , '%'+sle_material_mfs.text+'%'  ,  lvi_sign ,ddlb_location_code.getcode()+'%' ,  DEC(em_unit_price.TEXT) ,  ddlb_supplier_code.getcode()+'%' ,  GVi_organization_id )									
				elseif rb_simple.checked = true then 
					dw_4.retrieve( ddlb_item_code.text()+'%' , '%'+sle_material_mfs.text+'%'  , lvi_sign , ddlb_location_code.getcode()+'%' ,   ddlb_supplier_code.getcode()+'%' ,  '%'+sle_item_name.text+'%' ,  GVi_organization_id )
				else
					
					DW_5.RETrieve( ddlb_item_code.text() + '%' , sle_material_mfs.text+'%' ,  ddlb_supplier_code.getcode()+'%' ,  long( em_life_cycle.text ) , '%'+sle_item_name.text+'%' , GVI_ORGANIZATION_ID)
				end if

	case 'UPDATE'
		
			IF DW_2.UPDATE() < 0 THEN
			  	 ROLLBACK;
			ELSE
				COMMIT;
				F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
				F_RETRIEVE()				 
			END IF

	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mat_current_inventory_master
integer y = 576
integer width = 3799
integer height = 1532
boolean titlebar = true
string title = "Life Cycle Over"
string dataobject = "d_mat_current_inventory_over_lifecycle_lst"
end type

type dw_4 from w_main_root`dw_4 within w_mat_current_inventory_master
integer y = 576
integer width = 3799
integer height = 1532
boolean titlebar = true
string dataobject = "d_mat_current_inventory_simple_lst"
end type

type dw_3 from w_main_root`dw_3 within w_mat_current_inventory_master
integer y = 576
integer width = 3799
integer height = 1532
boolean titlebar = true
string dataobject = "d_mat_current_inventory_high_price_lst"
end type

type dw_2 from w_main_root`dw_2 within w_mat_current_inventory_master
integer y = 576
integer width = 3799
integer height = 1532
boolean titlebar = true
string title = "Material Current Inventory Detail List"
string dataobject = "d_mat_current_inventory_detail_lst_tree"
end type

event dw_2::doubleclicked;call super::doubleclicked;if row >=1 then 
	
	openwithparm(w_mat_item_barcode_inventory_popup , string(this.object.item_code[this.getrow()]))
	
end if 	
end event

type dw_1 from w_main_root`dw_1 within w_mat_current_inventory_master
integer y = 576
integer width = 4645
integer height = 1536
boolean titlebar = true
string title = "Material Current Inventory List"
string dataobject = "d_mat_current_inventory_lst_tree_test"
end type

event dw_1::doubleclicked;call super::doubleclicked;if row >= 1 then 
	
	openwithparm(w_mat_item_inventory_popup , string(this.object.item_code[this.getrow()]))
	
end if 	
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_current_inventory_master
end type

type st_1 from so_statictext within w_mat_current_inventory_master
integer x = 1646
integer y = 108
integer width = 512
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mat_current_inventory_master
integer x = 1646
integer y = 176
integer width = 512
integer taborder = 20
boolean bringtotop = true
end type

type rb_summary from so_radiobutton within w_mat_current_inventory_master
integer x = 82
integer y = 76
boolean bringtotop = true
integer weight = 700
string text = "Summary"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
selected_data_window = dw_1


cb_close_all.enabled = false
cb_release_all.enabled = false

pb_move.enabled = false
end event

type rb_detail from so_radiobutton within w_mat_current_inventory_master
integer x = 82
integer y = 160
boolean bringtotop = true
integer weight = 700
string text = "Detail"
end type

event clicked;call super::clicked;dw_2.bringtotop = true
selected_data_window = dw_2

cb_close_all.enabled = true
cb_release_all.enabled = true

pb_move.enabled = true
end event

type cb_close_all from so_commandbutton within w_mat_current_inventory_master
integer x = 699
integer y = 396
integer width = 453
integer height = 136
integer taborder = 30
boolean bringtotop = true
boolean enabled = false
string text = "Close All"
end type

event clicked;call super::clicked;Long i


if rb_detail.checked = true then 

	do
		i++
		
		if dw_2.object.check_yn[i] = 'Y' then
		else
			continue
		end if 
		
		dw_2.object.inventory_hold[i]= 'C' 
	loop until i = dw_2.rowcount( )
	
elseif rb_simple.checked = true then 
	
	do
		i++
		
		if dw_4.object.check_yn[i] = 'Y' then
		else
			continue
		end if 
		
		dw_4.object.holding_yn[i]= 'Y' 
	loop until i = dw_4.rowcount( )	
end if 
f_update()
end event

type cb_release_all from so_commandbutton within w_mat_current_inventory_master
integer x = 1157
integer y = 396
integer width = 453
integer height = 136
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
string text = "Release All"
end type

event clicked;call super::clicked;//Long i
//do
//	i++
//	
//	if dw_2.object.check_yn[i] = 'Y' then
//	else
//		continue
//	end if 
//	
//	dw_2.object.inventory_hold[i]= 'N' 
//	
//loop until i = dw_2.rowcount( )

Long i


if rb_detail.checked = true then 

	do
		i++
		
		if dw_2.object.check_yn[i] = 'Y' then
		else
			continue
		end if 
		
		dw_2.object.inventory_hold[i]= 'N' 
		
		
		
	loop until i = dw_2.rowcount( )
elseif rb_simple.checked = true then 
	
	do
		i++
		
		if dw_4.object.check_yn[i] = 'Y' then
		else
			continue
		end if 
		
		dw_4.object.holding_yn[i]= 'N' 
		
	loop until i = dw_4.rowcount( )	
	
end if 

f_update()
end event

type rb_all from so_radiobutton within w_mat_current_inventory_master
integer x = 2190
integer y = 388
integer width = 457
integer height = 84
boolean bringtotop = true
integer weight = 700
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;selected_data_window.setfilter( '')
selected_data_window.filter( )
end event

type rb_gt from so_radiobutton within w_mat_current_inventory_master
integer x = 2190
integer y = 464
integer width = 590
integer height = 84
boolean bringtotop = true
integer weight = 700
string text = "Inventory Qty > 0"
end type

event clicked;call super::clicked;selected_data_window.setfilter('inventory_qty > 0 ')
selected_data_window.filter( )
end event

type ddlb_location_code from uo_basecode within w_mat_current_inventory_master
integer x = 3771
integer y = 172
integer width = 421
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'MATERIAL LOCATION CODE')
end event

type st_4 from so_statictext within w_mat_current_inventory_master
integer x = 3771
integer y = 100
integer width = 421
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Location Code"
end type

type rb_matrix from so_radiobutton within w_mat_current_inventory_master
integer x = 82
integer y = 244
boolean bringtotop = true
integer weight = 700
string text = "High Price"
end type

event clicked;call super::clicked;dw_3.bringtotop = true
selected_data_window = dw_3


cb_close_all.enabled = false
cb_release_all.enabled = false
pb_move.enabled = false
end event

type pb_move from so_commandbutton within w_mat_current_inventory_master
integer x = 1623
integer y = 396
integer width = 453
integer height = 136
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
string text = "Move"
end type

event clicked;call super::clicked;if dw_2.rowcount() < 1 then return 
LONG i , j
Decimal lvf_issue_qty , lvf_inventory_qty
string lvs_material_mfs , lvs_location_code , lvs_dest_location_code, lvs_item_code , lvs_line_type , lvs_invoice_no 

lvs_invoice_no= string(f_t_sysdate(),'yyyymmdd') +string(f_get_sequence( 'SEQ_ISSUE_INVOICE_SEQUENCE') )

dw_2.accepttext ()
do
	i++
	
	if dw_2.object.check_yn[i] = 'Y' then 
	
		
		lvs_material_mfs  = dw_2.object.material_mfs[i]
		lvs_location_code= dw_2.object.location_code[i]
		lvs_dest_location_code= dw_2.object.dest_location_code[i]
		
		if lvs_dest_location_code = '*' then 
			f_msgbox1(102 ,f_get_dual_lang_text ( gvs_language ,  "Dest Location Code") )
			return
		end if 
		
		lvs_item_code= dw_2.object.item_code[i]
		lvs_line_type= dw_2.object.line_type[i]
		lvf_issue_qty= dw_2.object.move_qty[i]
		
		lvf_inventory_qty= dw_2.object.inventory_qty[i]		
		
		if lvf_inventory_qty < lvf_issue_qty then 
			Messagebox("Error" , "Issue Qty Invalid" )
			continue
		end if 
		
		if lvf_issue_qty <=0 then 
			Messagebox("Error" , "Issue Qty Invalid" )
			continue
		end if 
		
		if lvs_dest_location_code = '' or isnull(lvs_dest_location_code) then 
			Messagebox("Error" , "Location Code Invalid" )
			continue
		end if 
		
		f_mat_issue_4_move( lvs_location_code, lvs_dest_location_code ,lvs_material_mfs,lvs_item_code,lvs_line_type ,lvs_invoice_no , lvf_issue_qty)
		
	else
		continue
	end if 
	
	j++
loop until i = dw_2.rowcount()

if j > 0 then 
	msg = f_msgbox1(9014 , string(j) )
	if msg = 1 then
		f_update() ;
	else
		return
	end if
else
	msg = f_msgbox(9026)
	return
end if

f_retrieve()







end event

type rb_simple from so_radiobutton within w_mat_current_inventory_master
integer x = 82
integer y = 340
boolean bringtotop = true
integer weight = 700
string text = "Simple"
end type

event clicked;call super::clicked;dw_4.bringtotop = true
selected_data_window = dw_4

cb_close_all.enabled = true
cb_release_all.enabled = true

end event

type st_5 from so_statictext within w_mat_current_inventory_master
integer x = 2167
integer y = 108
integer width = 544
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Material MFS"
end type

type sle_material_mfs from so_singlelineedit within w_mat_current_inventory_master
integer x = 2167
integer y = 176
integer width = 544
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

type sle_receipt_slip_no from so_singlelineedit within w_mat_current_inventory_master
integer x = 4197
integer y = 168
integer width = 425
integer height = 84
integer taborder = 60
boolean bringtotop = true
end type

type st_9 from so_statictext within w_mat_current_inventory_master
integer x = 4197
integer y = 100
integer width = 425
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Slip No"
end type

type sle_our_barcode from so_singlelineedit within w_mat_current_inventory_master
integer x = 677
integer y = 176
integer width = 960
integer height = 84
integer taborder = 60
boolean bringtotop = true
end type

event modified;call super::modified;int lvi_pos1 , lvi_pos2
string lvs_our_barcode  , lvs_item_code , lvs_lot_no 
lvs_our_barcode = this.text 

//===================================================
//
//===================================================
SELECT  f_get_item_code_from_barcode (:lvs_our_barcode ) 
	INTO :lvs_item_code
   FROM DUAL ; 
	
if  lvs_item_code = '' then 
	
	f_msgbox1(1175 ,lvs_our_barcode )
	sle_our_barcode.text = ''
	sle_our_barcode.setfocus()
	return -1 
	
end if 

//=================================================
//
//=================================================

if f_check_item_exists( lvs_item_code , f_t_sysdate())  <= 0 then 
	f_play_sound("$$HEX5$$88d4a9baf8bbf1b45db8$$ENDHEX$$.wav")	
	f_msgbox(9041) //$$HEX10$$fcd3a9bac8b9a4c230d12000f8bbf1b45db82000$$ENDHEX$$

	sle_our_barcode.text = ''
	sle_our_barcode.setfocus()
	return -1
end if 

//==================================================
// $$HEX6$$6fb8b8d2200088bc38d62000$$ENDHEX$$
//==================================================
	SELECT  F_GET_LOT_NO_FROM_BARCODE (:lvs_our_barcode ) 
	INTO :lvs_lot_no
	FROM DUAL ; 
	
	IF F_SQL_CHECK() < 0 THEN 
		sle_our_barcode.text = ''
		sle_our_barcode.setfocus()
	END IF 	 

if lvs_lot_no = ''  then 
	sle_our_barcode.text = ''
	sle_our_barcode.setfocus()
	return -1
end if 

ddlb_item_code.text = lvs_item_code
sle_material_mfs.text = lvs_lot_no
this.selecttext( 1,100)
f_retrieve()

end event

type st_11 from so_statictext within w_mat_current_inventory_master
integer x = 677
integer y = 108
integer width = 960
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 255
string text = "Barcode"
end type

type em_unit_price from so_editmask within w_mat_current_inventory_master
integer x = 4640
integer y = 176
integer width = 315
integer taborder = 90
boolean bringtotop = true
string text = "0"
string mask = "###,##0"
end type

type st_8 from so_statictext within w_mat_current_inventory_master
integer x = 4640
integer y = 100
integer width = 315
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Unit Price"
end type

type st_6 from so_statictext within w_mat_current_inventory_master
integer x = 2715
integer y = 100
integer width = 558
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Supplier Code"
end type

type ddlb_supplier_code from uo_supplier_name_code within w_mat_current_inventory_master
integer x = 2715
integer y = 176
integer width = 558
integer height = 1752
integer taborder = 20
boolean bringtotop = true
end type

type em_life_cycle from so_editmask within w_mat_current_inventory_master
integer x = 3387
integer y = 372
integer width = 261
integer height = 84
integer taborder = 100
boolean bringtotop = true
string text = "0"
string mask = "###,##0"
end type

type st_3 from so_statictext within w_mat_current_inventory_master
integer x = 2802
integer y = 384
integer width = 576
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Life Cycle Remain <= "
end type

type rb_life_cycle from so_radiobutton within w_mat_current_inventory_master
integer x = 82
integer y = 440
boolean bringtotop = true
integer weight = 700
string text = "Life Cycle"
end type

event clicked;call super::clicked;dw_5.bringtotop = true 
selected_data_window = dw_5
end event

type sle_vendor_lotno from so_singlelineedit within w_mat_current_inventory_master
integer x = 3278
integer y = 176
integer width = 485
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

type st_2 from so_statictext within w_mat_current_inventory_master
integer x = 3273
integer y = 104
integer width = 485
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Vendor Lot No"
end type

type ddlb_inventory_type from uo_basecode within w_mat_current_inventory_master
integer x = 4969
integer y = 168
integer width = 471
integer taborder = 50
boolean bringtotop = true
end type

event constructor;call super::constructor;THIS.REDRAW('INVENTORY TYPE')
end event

type st_7 from so_statictext within w_mat_current_inventory_master
integer x = 4992
integer y = 108
integer width = 453
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Inventory Type"
end type

type sle_item_name from so_singlelineedit within w_mat_current_inventory_master
integer x = 5445
integer y = 168
integer width = 425
integer height = 84
integer taborder = 70
boolean bringtotop = true
end type

type st_10 from so_statictext within w_mat_current_inventory_master
integer x = 5445
integer y = 72
integer width = 425
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Item Name"
end type

type gb_2 from so_groupbox within w_mat_current_inventory_master
integer x = 5
integer width = 631
integer height = 548
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_1 from so_groupbox within w_mat_current_inventory_master
integer x = 645
integer width = 5239
integer height = 320
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_4 from so_groupbox within w_mat_current_inventory_master
integer x = 654
integer y = 328
integer width = 1481
integer height = 228
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_5 from so_groupbox within w_mat_current_inventory_master
integer x = 2144
integer y = 328
integer width = 1966
integer height = 232
integer taborder = 50
integer weight = 700
long textcolor = 16711680
string text = "Filter"
end type

