HA$PBExportHeader$w_mat_current_inventory_search_master.srw
$PBExportComments$Material Current Inventory Master
forward
global type w_mat_current_inventory_search_master from w_main_root
end type
type st_1 from so_statictext within w_mat_current_inventory_search_master
end type
type ddlb_item_code from uo_item_code within w_mat_current_inventory_search_master
end type
type rb_summary from so_radiobutton within w_mat_current_inventory_search_master
end type
type rb_detail from so_radiobutton within w_mat_current_inventory_search_master
end type
type ddlb_location_code from uo_basecode within w_mat_current_inventory_search_master
end type
type st_4 from so_statictext within w_mat_current_inventory_search_master
end type
type st_5 from so_statictext within w_mat_current_inventory_search_master
end type
type sle_material_mfs from so_singlelineedit within w_mat_current_inventory_search_master
end type
type sle_our_barcode from so_singlelineedit within w_mat_current_inventory_search_master
end type
type st_11 from so_statictext within w_mat_current_inventory_search_master
end type
type st_6 from so_statictext within w_mat_current_inventory_search_master
end type
type ddlb_supplier_code from uo_supplier_name_code within w_mat_current_inventory_search_master
end type
type cbx_ignore_item from so_checkbox within w_mat_current_inventory_search_master
end type
type rb_all from so_radiobutton within w_mat_current_inventory_search_master
end type
type rb_gt from so_radiobutton within w_mat_current_inventory_search_master
end type
type gb_2 from so_groupbox within w_mat_current_inventory_search_master
end type
type gb_1 from so_groupbox within w_mat_current_inventory_search_master
end type
type gb_5 from so_groupbox within w_mat_current_inventory_search_master
end type
end forward

global type w_mat_current_inventory_search_master from w_main_root
integer width = 5426
integer height = 3056
string title = "Material Current Inventory Search  Master"
st_1 st_1
ddlb_item_code ddlb_item_code
rb_summary rb_summary
rb_detail rb_detail
ddlb_location_code ddlb_location_code
st_4 st_4
st_5 st_5
sle_material_mfs sle_material_mfs
sle_our_barcode sle_our_barcode
st_11 st_11
st_6 st_6
ddlb_supplier_code ddlb_supplier_code
cbx_ignore_item cbx_ignore_item
rb_all rb_all
rb_gt rb_gt
gb_2 gb_2
gb_1 gb_1
gb_5 gb_5
end type
global w_mat_current_inventory_search_master w_mat_current_inventory_search_master

type variables
int lvi_sign
end variables

on w_mat_current_inventory_search_master.create
int iCurrent
call super::create
this.st_1=create st_1
this.ddlb_item_code=create ddlb_item_code
this.rb_summary=create rb_summary
this.rb_detail=create rb_detail
this.ddlb_location_code=create ddlb_location_code
this.st_4=create st_4
this.st_5=create st_5
this.sle_material_mfs=create sle_material_mfs
this.sle_our_barcode=create sle_our_barcode
this.st_11=create st_11
this.st_6=create st_6
this.ddlb_supplier_code=create ddlb_supplier_code
this.cbx_ignore_item=create cbx_ignore_item
this.rb_all=create rb_all
this.rb_gt=create rb_gt
this.gb_2=create gb_2
this.gb_1=create gb_1
this.gb_5=create gb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.ddlb_item_code
this.Control[iCurrent+3]=this.rb_summary
this.Control[iCurrent+4]=this.rb_detail
this.Control[iCurrent+5]=this.ddlb_location_code
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.st_5
this.Control[iCurrent+8]=this.sle_material_mfs
this.Control[iCurrent+9]=this.sle_our_barcode
this.Control[iCurrent+10]=this.st_11
this.Control[iCurrent+11]=this.st_6
this.Control[iCurrent+12]=this.ddlb_supplier_code
this.Control[iCurrent+13]=this.cbx_ignore_item
this.Control[iCurrent+14]=this.rb_all
this.Control[iCurrent+15]=this.rb_gt
this.Control[iCurrent+16]=this.gb_2
this.Control[iCurrent+17]=this.gb_1
this.Control[iCurrent+18]=this.gb_5
end on

on w_mat_current_inventory_search_master.destroy
call super::destroy
destroy(this.st_1)
destroy(this.ddlb_item_code)
destroy(this.rb_summary)
destroy(this.rb_detail)
destroy(this.ddlb_location_code)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.sle_material_mfs)
destroy(this.sle_our_barcode)
destroy(this.st_11)
destroy(this.st_6)
destroy(this.ddlb_supplier_code)
destroy(this.cbx_ignore_item)
destroy(this.rb_all)
destroy(this.rb_gt)
destroy(this.gb_2)
destroy(this.gb_1)
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
Ivs_resize_type                      = 'MASTER_DETAIL_12T_3B'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


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

event ue_data_control;call super::ue_data_control;choose case gvs_ue_data_control
		
	case 'RETRIEVE'		
		
				if rb_all.checked = true then 
					lvi_sign = -2
			    elseif rb_gt.checked = true then 
					lvi_sign = 1
			    end if
			
				if rb_summary.checked = true then 

					dw_1.retrieve(ddlb_item_code.text() + '%', sle_material_mfs.text+'%' , ddlb_location_code.getcode()+'%' , ddlb_supplier_code.getcode()+'%'  , lvi_sign ,  gvi_organization_id)
	
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

type dw_5 from w_main_root`dw_5 within w_mat_current_inventory_search_master
integer y = 344
integer width = 2770
integer height = 952
boolean titlebar = true
string title = "Life Cycle Over"
string dataobject = "d_mat_current_inventory_over_lifecycle_lst"
end type

type dw_4 from w_main_root`dw_4 within w_mat_current_inventory_search_master
integer y = 344
integer width = 2775
integer height = 960
boolean titlebar = true
end type

type dw_3 from w_main_root`dw_3 within w_mat_current_inventory_search_master
integer x = 27
integer y = 1316
integer width = 5335
integer height = 1624
boolean titlebar = true
string title = "Detail List"
string dataobject = "d_mat_current_inventory_detail_4_search"
end type

type dw_2 from w_main_root`dw_2 within w_mat_current_inventory_search_master
integer x = 2775
integer y = 344
integer width = 2597
integer height = 960
boolean titlebar = true
string title = "Location Summary List"
string dataobject = "d_mat_current_inventory_loc_sum_4_search"
end type

event dw_2::doubleclicked;call super::doubleclicked;if row >=1 then 
	
	openwithparm(w_mat_item_barcode_inventory_popup , string(this.object.item_code[this.getrow()]))
	
end if 	
end event

event dw_2::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 

if cbx_ignore_item.checked = true then 
		dw_3.retrieve( '%' ,  this.object.location_address_rack[currentrow] , this.object.supplier_code[currentrow] ,  gvi_organization_id)			
else

	dw_3.retrieve( this.object.item_code[currentrow] ,  this.object.location_address_rack[currentrow] ,  this.object.supplier_code[currentrow] ,  gvi_organization_id)			
end if 
		
end event

type dw_1 from w_main_root`dw_1 within w_mat_current_inventory_search_master
integer x = 9
integer y = 344
integer width = 2770
integer height = 964
boolean titlebar = true
string title = "Material Current Inventory List"
string dataobject = "d_mat_total_inventory_4_serach"
end type

event dw_1::doubleclicked;call super::doubleclicked;if row >= 1 then 
	
	

	openwithparm(w_mat_item_inventory_popup , string(this.object.item_code[this.getrow()]))
	
end if 	
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
dw_2.retrieve(this.object.item_code[currentrow]  ,  	string(this.object.supplier_code[currentrow])  , lvi_sign , gvi_organization_id)   		
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_current_inventory_search_master
end type

type st_1 from so_statictext within w_mat_current_inventory_search_master
integer x = 1646
integer y = 108
integer width = 512
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mat_current_inventory_search_master
integer x = 1646
integer y = 176
integer width = 512
integer taborder = 20
boolean bringtotop = true
end type

type rb_summary from so_radiobutton within w_mat_current_inventory_search_master
integer x = 55
integer y = 88
boolean bringtotop = true
integer weight = 700
string text = "Summary"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
selected_data_window = dw_1

end event

type rb_detail from so_radiobutton within w_mat_current_inventory_search_master
integer x = 55
integer y = 196
boolean bringtotop = true
integer weight = 700
string text = "Detail"
end type

event clicked;call super::clicked;dw_4.bringtotop = true
selected_data_window = dw_4

end event

type ddlb_location_code from uo_basecode within w_mat_current_inventory_search_master
integer x = 3493
integer y = 176
integer width = 558
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'MATERIAL LOCATION CODE')
end event

type st_4 from so_statictext within w_mat_current_inventory_search_master
integer x = 3493
integer y = 104
integer width = 558
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Location Code"
end type

type st_5 from so_statictext within w_mat_current_inventory_search_master
integer x = 2167
integer y = 108
integer width = 544
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Material MFS"
end type

type sle_material_mfs from so_singlelineedit within w_mat_current_inventory_search_master
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

type sle_our_barcode from so_singlelineedit within w_mat_current_inventory_search_master
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

//=======================================
// $$HEX11$$00cf3cd554cf200090c7acc778c72000bdacb0c62000$$ENDHEX$$
//=======================================
 IF MID (UPPER (lvs_our_barcode), 1, 1) = '['    THEN
         SELECT  f_get_item_code_from_barcode (:lvs_our_barcode)|| '-' || f_get_lot_no_from_barcode (:lvs_our_barcode) || '-' || f_get_lot_qty_from_barcode (:lvs_our_barcode)
		    INTO :lvs_our_barcode
	       FROM DUAL ; 
		
		IF F_SQL_CHECK() < 0 THEN 
				this.selecttext( 1,100)	
		END IF 	 
ELSE
		 SELECT  f_get_prepare_barcode (:lvs_our_barcode)
		     INTO :lvs_our_barcode
	       FROM DUAL ; 
		
		IF F_SQL_CHECK() < 0 THEN 
				this.selecttext( 1,100)	
		END IF 	 
END IF 


//===================================================
//
//===================================================
lvi_pos1 =  pos(lvs_our_barcode , '-' , 1 ) 

if  lvi_pos1 <= 0 then 
	
	f_msgbox1(1175 ,lvs_our_barcode )
	sle_our_barcode.text = ''
	sle_our_barcode.setfocus()
	return -1 
	
end if 

//=================================================
//
//=================================================

lvs_item_code = trim( mid( lvs_our_barcode , 1 ,  lvi_pos1 -1 ))

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
lvi_pos2 =  pos(lvs_our_barcode , '-' , lvi_pos1+1 ) 

if  lvi_pos2 <= 0 then 

	lvs_lot_no = trim( mid( lvs_our_barcode , lvi_pos1+1 ,  100 ))	
else
	lvs_lot_no = trim( mid( lvs_our_barcode , lvi_pos1+1 ,   lvi_pos2 - lvi_pos1 -1 ))
end if 

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

type st_11 from so_statictext within w_mat_current_inventory_search_master
integer x = 677
integer y = 108
integer width = 960
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 255
string text = "Barcode"
end type

type st_6 from so_statictext within w_mat_current_inventory_search_master
integer x = 2715
integer y = 100
integer width = 795
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Supplier Code"
end type

type ddlb_supplier_code from uo_supplier_name_code within w_mat_current_inventory_search_master
integer x = 2715
integer y = 176
integer height = 1752
integer taborder = 20
boolean bringtotop = true
end type

type cbx_ignore_item from so_checkbox within w_mat_current_inventory_search_master
integer x = 4827
integer y = 40
boolean bringtotop = true
string text = "Ignore Item"
end type

type rb_all from so_radiobutton within w_mat_current_inventory_search_master
integer x = 4174
integer y = 92
integer width = 457
integer height = 84
boolean bringtotop = true
integer weight = 700
string text = "All"
boolean checked = true
end type

type rb_gt from so_radiobutton within w_mat_current_inventory_search_master
integer x = 4174
integer y = 200
integer width = 590
integer height = 84
boolean bringtotop = true
integer weight = 700
string text = "Inventory Qty > 0"
end type

type gb_2 from so_groupbox within w_mat_current_inventory_search_master
integer x = 5
integer width = 631
integer height = 324
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_1 from so_groupbox within w_mat_current_inventory_search_master
integer x = 649
integer width = 3465
integer height = 320
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_5 from so_groupbox within w_mat_current_inventory_search_master
integer x = 4128
integer width = 1221
integer height = 320
integer taborder = 60
integer weight = 700
long textcolor = 16711680
string text = "Option"
end type

