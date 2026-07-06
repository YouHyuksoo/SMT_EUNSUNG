HA$PBExportHeader$w_mat_dehumi_scan_query.srw
forward
global type w_mat_dehumi_scan_query from w_main_root
end type
type st_11 from so_statictext within w_mat_dehumi_scan_query
end type
type sle_our_barcode from so_singlelineedit within w_mat_dehumi_scan_query
end type
type st_1 from so_statictext within w_mat_dehumi_scan_query
end type
type ddlb_item_code from uo_item_code within w_mat_dehumi_scan_query
end type
type sle_material_mfs from so_singlelineedit within w_mat_dehumi_scan_query
end type
type st_2 from so_statictext within w_mat_dehumi_scan_query
end type
type sle_chamber_code from so_singlelineedit within w_mat_dehumi_scan_query
end type
type st_chamber_code from so_statictext within w_mat_dehumi_scan_query
end type
type rb_backing from so_radiobutton within w_mat_dehumi_scan_query
end type
type rb_dehumi from so_radiobutton within w_mat_dehumi_scan_query
end type
type rb_vacuum from so_radiobutton within w_mat_dehumi_scan_query
end type
type gb_1 from so_groupbox within w_mat_dehumi_scan_query
end type
type gb_6 from so_groupbox within w_mat_dehumi_scan_query
end type
end forward

global type w_mat_dehumi_scan_query from w_main_root
integer width = 6647
integer height = 2748
string title = "Dehumi Stock Query"
string ivs_dw_2_use_focusindicator = "Y"
st_11 st_11
sle_our_barcode sle_our_barcode
st_1 st_1
ddlb_item_code ddlb_item_code
sle_material_mfs sle_material_mfs
st_2 st_2
sle_chamber_code sle_chamber_code
st_chamber_code st_chamber_code
rb_backing rb_backing
rb_dehumi rb_dehumi
rb_vacuum rb_vacuum
gb_1 gb_1
gb_6 gb_6
end type
global w_mat_dehumi_scan_query w_mat_dehumi_scan_query

type variables

string ivs_chamber_type, ivs_txn_type
end variables

on w_mat_dehumi_scan_query.create
int iCurrent
call super::create
this.st_11=create st_11
this.sle_our_barcode=create sle_our_barcode
this.st_1=create st_1
this.ddlb_item_code=create ddlb_item_code
this.sle_material_mfs=create sle_material_mfs
this.st_2=create st_2
this.sle_chamber_code=create sle_chamber_code
this.st_chamber_code=create st_chamber_code
this.rb_backing=create rb_backing
this.rb_dehumi=create rb_dehumi
this.rb_vacuum=create rb_vacuum
this.gb_1=create gb_1
this.gb_6=create gb_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_11
this.Control[iCurrent+2]=this.sle_our_barcode
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.ddlb_item_code
this.Control[iCurrent+5]=this.sle_material_mfs
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.sle_chamber_code
this.Control[iCurrent+8]=this.st_chamber_code
this.Control[iCurrent+9]=this.rb_backing
this.Control[iCurrent+10]=this.rb_dehumi
this.Control[iCurrent+11]=this.rb_vacuum
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.gb_6
end on

on w_mat_dehumi_scan_query.destroy
call super::destroy
destroy(this.st_11)
destroy(this.sle_our_barcode)
destroy(this.st_1)
destroy(this.ddlb_item_code)
destroy(this.sle_material_mfs)
destroy(this.st_2)
destroy(this.sle_chamber_code)
destroy(this.st_chamber_code)
destroy(this.rb_backing)
destroy(this.rb_dehumi)
destroy(this.rb_vacuum)
destroy(this.gb_1)
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
ivs_dw_2_use_focusindicator = 'Y' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

/****************************************
*  Menu Property
*****************************************
* ADMIN  ( All Control )
* MANAGE ( Manager )
* GUEST  ( Only Query )
* QUERY  ( Only Query  )
* DATA_CONTROL  ( Insert Delete Update )
* REPORT ( Report )
****************************************/
F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control

dw_1.title = 'Dehumidification Summary'



end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

event ue_data_control;call super::ue_data_control;long   row

choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
		    ivs_chamber_type = 'D'
			 
		     dw_1.reset()
			 dw_2.reset()
			  
			dw_1.retrieve( ddlb_item_code.text( )  +'%' ,  sle_material_mfs.text+'%',   gvi_organization_id, ivs_chamber_type, sle_chamber_code.text+'%' )
			dw_1.setfocus()
			
	case else
		
end choose


end event

event open;call super::open;
 ivs_chamber_type = 'B'
 dw_1.title = 'Baking Summry'
end event

type dw_5 from w_main_root`dw_5 within w_mat_dehumi_scan_query
integer y = 316
end type

type dw_4 from w_main_root`dw_4 within w_mat_dehumi_scan_query
integer y = 316
end type

type dw_3 from w_main_root`dw_3 within w_mat_dehumi_scan_query
integer y = 316
integer width = 4366
integer height = 872
end type

type dw_2 from w_main_root`dw_2 within w_mat_dehumi_scan_query
integer y = 1324
integer width = 4370
integer height = 1284
boolean titlebar = true
string title = "Chamber Detail"
string dataobject = "d_mat_material_dehumi_query_lst"
end type

type dw_1 from w_main_root`dw_1 within w_mat_dehumi_scan_query
integer y = 312
integer width = 4375
integer height = 1004
boolean titlebar = true
string title = "Chamber Summary"
string dataobject = "d_mat_material_baking_dehumi_query_lst_summary"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;
if currentrow < 1 then return

dw_2.reset()			  
dw_2.retrieve( dw_1.object.item_code[currentrow], gvi_organization_id, dw_1.object.chamber_type[currentrow], dw_1.object.chamber_code[currentrow])

end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_dehumi_scan_query
end type

type st_11 from so_statictext within w_mat_dehumi_scan_query
integer x = 2258
integer y = 92
integer width = 960
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Barcode"
end type

type sle_our_barcode from so_singlelineedit within w_mat_dehumi_scan_query
integer x = 2258
integer y = 172
integer width = 960
integer height = 84
integer taborder = 70
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


//int lvi_pos1 , lvi_pos2
//string lvs_our_barcode  , lvs_item_code , lvs_lot_no 
//lvs_our_barcode = this.text 
//
//////=======================================
////// $$HEX11$$00cf3cd554cf200090c7acc778c72000bdacb0c62000$$ENDHEX$$
//////=======================================
//// IF MID (UPPER (lvs_our_barcode), 1, 1) = '['    THEN
////         SELECT  f_get_item_code_from_barcode (:lvs_our_barcode)|| '-' || f_get_lot_no_from_barcode (:lvs_our_barcode) || '-' || f_get_lot_qty_from_barcode (:lvs_our_barcode)
////		    INTO :lvs_our_barcode
////	       FROM DUAL ; 
////		
////		IF F_SQL_CHECK() < 0 THEN 
////				this.selecttext( 1,100)	
////		END IF 	 
////ELSE
////		 SELECT  f_get_prepare_barcode (:lvs_our_barcode)
////		     INTO :lvs_our_barcode
////	       FROM DUAL ; 
////		
////		IF F_SQL_CHECK() < 0 THEN 
////				this.selecttext( 1,100)	
////		END IF 	 
////END IF 
//
//
////===================================================
////
////===================================================
//lvi_pos1 =  pos(lvs_our_barcode , '-' , 7 ) 
//
//if  lvi_pos1 <= 0 then 
//	
//	f_msgbox1(1175 ,lvs_our_barcode )
//	sle_our_barcode.text = ''
//	sle_our_barcode.setfocus()
//	return -1 
//	
//end if 
//
////=================================================
////
////=================================================
//
//lvs_item_code = trim( mid( lvs_our_barcode , 1 ,  lvi_pos1 -1 ))
//
//if f_check_item_exists( lvs_item_code , f_t_sysdate())  <= 0 then 
//	f_play_sound("$$HEX5$$88d4a9baf8bbf1b45db8$$ENDHEX$$.wav")	
//	f_msgbox(9041) //$$HEX10$$fcd3a9bac8b9a4c230d12000f8bbf1b45db82000$$ENDHEX$$
//
//	sle_our_barcode.text = ''
//	sle_our_barcode.setfocus()
//	return -1
//end if 
//
////==================================================
//// $$HEX6$$6fb8b8d2200088bc38d62000$$ENDHEX$$
////==================================================
//lvi_pos2 =  pos(lvs_our_barcode , '-' , lvi_pos1+1 ) 
//
//if  lvi_pos2 <= 0 then 
//
//	lvs_lot_no = trim( mid( lvs_our_barcode , lvi_pos1+1 ,  100 ))	
//else
//	lvs_lot_no = trim( mid( lvs_our_barcode , lvi_pos1+1 ,   lvi_pos2 - lvi_pos1 -1 ))
//end if 
//
//if lvs_lot_no = ''  then 
//	sle_our_barcode.text = ''
//	sle_our_barcode.setfocus()
//	return -1
//end if 
//
//ddlb_item_code.text = lvs_item_code
//sle_material_mfs.text = lvs_lot_no
//this.selecttext( 1,100)
//f_retrieve()
//
////============================================================
////
////============================================================
//
//
//
//
//
end event

type st_1 from so_statictext within w_mat_dehumi_scan_query
integer x = 1175
integer y = 92
integer width = 512
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mat_dehumi_scan_query
integer x = 1175
integer y = 172
integer width = 512
integer taborder = 80
boolean bringtotop = true
end type

type sle_material_mfs from so_singlelineedit within w_mat_dehumi_scan_query
integer x = 1701
integer y = 172
integer width = 544
integer height = 84
integer taborder = 90
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

type st_2 from so_statictext within w_mat_dehumi_scan_query
integer x = 1696
integer y = 92
integer width = 544
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Material MFS"
end type

type sle_chamber_code from so_singlelineedit within w_mat_dehumi_scan_query
integer x = 750
integer y = 172
integer width = 411
integer height = 84
integer taborder = 90
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

type st_chamber_code from so_statictext within w_mat_dehumi_scan_query
integer x = 750
integer y = 92
integer width = 411
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Chamber Code"
end type

type rb_backing from so_radiobutton within w_mat_dehumi_scan_query
boolean visible = false
integer x = 78
integer y = 60
boolean bringtotop = true
string text = "Baking"
end type

event clicked;call super::clicked;
ivs_chamber_type = 'B'
 dw_1.title = 'Baking list'
 
 dw_1.reset()	
 dw_2.reset()	
end event

event constructor;call super::constructor;
 ivs_chamber_type = 'B'
 dw_1.title = 'Baking Summry'
end event

type rb_dehumi from so_radiobutton within w_mat_dehumi_scan_query
integer x = 78
integer y = 128
boolean bringtotop = true
string text = "Dehumidification"
boolean checked = true
end type

event clicked;call super::clicked;
 ivs_chamber_type = 'D'
 dw_1.title = 'Dehumidification Summary'
 
 dw_1.reset()	
 dw_2.reset()	
end event

type rb_vacuum from so_radiobutton within w_mat_dehumi_scan_query
boolean visible = false
integer x = 78
integer y = 196
boolean bringtotop = true
string text = "Vacuum Pacjing"
end type

event clicked;call super::clicked;
ivs_chamber_type = 'V'
 dw_1.title = 'Vacuum Packing Summary'
 
  dw_1.reset()	
 dw_2.reset()	
end event

type gb_1 from so_groupbox within w_mat_dehumi_scan_query
integer x = 686
integer width = 2615
integer height = 304
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_6 from so_groupbox within w_mat_dehumi_scan_query
integer x = 5
integer width = 667
integer height = 304
integer taborder = 10
string text = "Category"
end type

