HA$PBExportHeader$w_mat_current_inventory_time.srw
$PBExportComments$Material Current Inventory Master
forward
global type w_mat_current_inventory_time from w_main_root
end type
type st_1 from so_statictext within w_mat_current_inventory_time
end type
type ddlb_item_code from uo_item_code within w_mat_current_inventory_time
end type
type rb_summary from so_radiobutton within w_mat_current_inventory_time
end type
type rb_all from so_radiobutton within w_mat_current_inventory_time
end type
type rb_gt from so_radiobutton within w_mat_current_inventory_time
end type
type ddlb_location_code from uo_basecode within w_mat_current_inventory_time
end type
type st_4 from so_statictext within w_mat_current_inventory_time
end type
type st_5 from so_statictext within w_mat_current_inventory_time
end type
type sle_material_mfs from so_singlelineedit within w_mat_current_inventory_time
end type
type sle_our_barcode from so_singlelineedit within w_mat_current_inventory_time
end type
type st_11 from so_statictext within w_mat_current_inventory_time
end type
type st_6 from so_statictext within w_mat_current_inventory_time
end type
type ddlb_supplier_code from uo_supplier_name_code within w_mat_current_inventory_time
end type
type uo_date from uo_ymdend_calendar within w_mat_current_inventory_time
end type
type em_time from so_editmask within w_mat_current_inventory_time
end type
type gb_2 from so_groupbox within w_mat_current_inventory_time
end type
type gb_1 from so_groupbox within w_mat_current_inventory_time
end type
type gb_5 from so_groupbox within w_mat_current_inventory_time
end type
end forward

global type w_mat_current_inventory_time from w_main_root
integer width = 5376
integer height = 3056
string title = "Material Current Inventory Time"
st_1 st_1
ddlb_item_code ddlb_item_code
rb_summary rb_summary
rb_all rb_all
rb_gt rb_gt
ddlb_location_code ddlb_location_code
st_4 st_4
st_5 st_5
sle_material_mfs sle_material_mfs
sle_our_barcode sle_our_barcode
st_11 st_11
st_6 st_6
ddlb_supplier_code ddlb_supplier_code
uo_date uo_date
em_time em_time
gb_2 gb_2
gb_1 gb_1
gb_5 gb_5
end type
global w_mat_current_inventory_time w_mat_current_inventory_time

on w_mat_current_inventory_time.create
int iCurrent
call super::create
this.st_1=create st_1
this.ddlb_item_code=create ddlb_item_code
this.rb_summary=create rb_summary
this.rb_all=create rb_all
this.rb_gt=create rb_gt
this.ddlb_location_code=create ddlb_location_code
this.st_4=create st_4
this.st_5=create st_5
this.sle_material_mfs=create sle_material_mfs
this.sle_our_barcode=create sle_our_barcode
this.st_11=create st_11
this.st_6=create st_6
this.ddlb_supplier_code=create ddlb_supplier_code
this.uo_date=create uo_date
this.em_time=create em_time
this.gb_2=create gb_2
this.gb_1=create gb_1
this.gb_5=create gb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.ddlb_item_code
this.Control[iCurrent+3]=this.rb_summary
this.Control[iCurrent+4]=this.rb_all
this.Control[iCurrent+5]=this.rb_gt
this.Control[iCurrent+6]=this.ddlb_location_code
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.st_5
this.Control[iCurrent+9]=this.sle_material_mfs
this.Control[iCurrent+10]=this.sle_our_barcode
this.Control[iCurrent+11]=this.st_11
this.Control[iCurrent+12]=this.st_6
this.Control[iCurrent+13]=this.ddlb_supplier_code
this.Control[iCurrent+14]=this.uo_date
this.Control[iCurrent+15]=this.em_time
this.Control[iCurrent+16]=this.gb_2
this.Control[iCurrent+17]=this.gb_1
this.Control[iCurrent+18]=this.gb_5
end on

on w_mat_current_inventory_time.destroy
call super::destroy
destroy(this.st_1)
destroy(this.ddlb_item_code)
destroy(this.rb_summary)
destroy(this.rb_all)
destroy(this.rb_gt)
destroy(this.ddlb_location_code)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.sle_material_mfs)
destroy(this.sle_our_barcode)
destroy(this.st_11)
destroy(this.st_6)
destroy(this.ddlb_supplier_code)
destroy(this.uo_date)
destroy(this.em_time)
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


uo_date.triggerevent('ue_activate')



end event

event ue_data_control;call super::ue_data_control;Long row , lvi_sign
String lvs_date
choose case gvs_ue_data_control
		
	case 'RETRIEVE'		
		
		        
				
				
				
				  
				if rb_summary.checked = true then 
					dw_1.retrieve(ddlb_item_code.text() + '%', sle_material_mfs.text+'%' ,  lvi_sign ,ddlb_supplier_code.getcode()+'%'  , ddlb_location_code.getcode()+'%' ,   gvi_organization_id , uo_date.uf_get_ymd_str() + em_time.text + '0000'  )
				end if



	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mat_current_inventory_time
integer y = 512
integer width = 3799
integer height = 1536
boolean titlebar = true
string title = "Life Cycle Over"
end type

type dw_4 from w_main_root`dw_4 within w_mat_current_inventory_time
integer y = 512
integer width = 3799
integer height = 1532
boolean titlebar = true
end type

type dw_3 from w_main_root`dw_3 within w_mat_current_inventory_time
integer y = 512
integer width = 3799
integer height = 1532
boolean titlebar = true
end type

type dw_2 from w_main_root`dw_2 within w_mat_current_inventory_time
integer y = 512
integer width = 3799
integer height = 1532
boolean titlebar = true
string title = "Material Current Inventory Detail List"
end type

event dw_2::doubleclicked;call super::doubleclicked;if row >=1 then 
	
	openwithparm(w_mat_item_barcode_inventory_popup , string(this.object.item_code[this.getrow()]))
	
end if 	
end event

type dw_1 from w_main_root`dw_1 within w_mat_current_inventory_time
integer y = 512
integer width = 3799
integer height = 1536
boolean titlebar = true
string title = "Material Current Inventory List"
string dataobject = "d_mat_current_inventory_lst_time"
end type

event dw_1::doubleclicked;call super::doubleclicked;if row >= 1 then 
	
	openwithparm(w_mat_item_barcode_inventory_popup , string(this.object.item_code[this.getrow()]))
	
end if 	
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_current_inventory_time
end type

type st_1 from so_statictext within w_mat_current_inventory_time
integer x = 1705
integer y = 108
integer width = 512
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mat_current_inventory_time
integer x = 1705
integer y = 176
integer width = 512
integer taborder = 20
boolean bringtotop = true
end type

type rb_summary from so_radiobutton within w_mat_current_inventory_time
integer x = 82
integer y = 64
boolean bringtotop = true
integer weight = 700
string text = "Time Query"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
selected_data_window = dw_1


//cb_close_all.enabled = false
//cb_release_all.enabled = false

//pb_move.enabled = false
end event

type rb_all from so_radiobutton within w_mat_current_inventory_time
integer x = 55
integer y = 384
integer width = 457
boolean bringtotop = true
integer weight = 700
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;selected_data_window.setfilter( '')
selected_data_window.filter( )
end event

type rb_gt from so_radiobutton within w_mat_current_inventory_time
integer x = 338
integer y = 384
integer width = 590
boolean bringtotop = true
integer weight = 700
string text = "Inventory Qty > 0"
end type

event clicked;call super::clicked;selected_data_window.setfilter('inventory_qty > 0 ')
selected_data_window.filter( )
end event

type ddlb_location_code from uo_basecode within w_mat_current_inventory_time
integer x = 3552
integer y = 176
integer width = 558
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'MATERIAL LOCATION CODE')
end event

type st_4 from so_statictext within w_mat_current_inventory_time
integer x = 3525
integer y = 108
integer width = 558
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Location Code"
end type

type st_5 from so_statictext within w_mat_current_inventory_time
integer x = 2226
integer y = 108
integer width = 544
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Material MFS"
end type

type sle_material_mfs from so_singlelineedit within w_mat_current_inventory_time
integer x = 2226
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

type sle_our_barcode from so_singlelineedit within w_mat_current_inventory_time
integer x = 736
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

type st_11 from so_statictext within w_mat_current_inventory_time
integer x = 736
integer y = 108
integer width = 960
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 255
string text = "Barcode"
end type

type st_6 from so_statictext within w_mat_current_inventory_time
integer x = 2775
integer y = 100
integer width = 795
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Supplier Code"
end type

type ddlb_supplier_code from uo_supplier_name_code within w_mat_current_inventory_time
integer x = 2775
integer y = 176
integer height = 1752
integer taborder = 20
boolean bringtotop = true
end type

type uo_date from uo_ymdend_calendar within w_mat_current_inventory_time
integer x = 32
integer y = 172
integer taborder = 110
boolean bringtotop = true
end type

on uo_date.destroy
call uo_ymdend_calendar::destroy
end on

event ue_activate;call super::ue_activate;string lvs_date 

select to_char(sysdate,'yyyy/mm/dd')
   into :lvs_date 
  from dual ; 


this.settext (lvs_date) 
end event

event constructor;call super::constructor;this.triggerevent('ue_activate')
end event

type em_time from so_editmask within w_mat_current_inventory_time
integer x = 443
integer y = 176
integer width = 233
integer height = 84
integer taborder = 120
boolean bringtotop = true
alignment alignment = left!
string mask = "00"
boolean spin = true
string minmax = "0~~23"
end type

event constructor;call super::constructor;this.text = '06'
end event

type gb_2 from so_groupbox within w_mat_current_inventory_time
integer x = 5
integer width = 699
integer height = 320
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_1 from so_groupbox within w_mat_current_inventory_time
integer x = 709
integer width = 3474
integer height = 320
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_5 from so_groupbox within w_mat_current_inventory_time
integer x = 9
integer y = 324
integer width = 1966
integer height = 172
integer taborder = 50
integer weight = 700
long textcolor = 16711680
string text = "Filter"
end type

