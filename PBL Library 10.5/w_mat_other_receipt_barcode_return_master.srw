HA$PBExportHeader$w_mat_other_receipt_barcode_return_master.srw
$PBExportComments$Material Mass Issue Return Master
forward
global type w_mat_other_receipt_barcode_return_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mat_other_receipt_barcode_return_master
end type
type uo_dateend from uo_ymd_calendar within w_mat_other_receipt_barcode_return_master
end type
type ddlb_item_code from uo_item_code within w_mat_other_receipt_barcode_return_master
end type
type st_3 from so_statictext within w_mat_other_receipt_barcode_return_master
end type
type st_4 from so_statictext within w_mat_other_receipt_barcode_return_master
end type
type st_status from so_statictext within w_mat_other_receipt_barcode_return_master
end type
type sle_our_barcode from so_singlelineedit within w_mat_other_receipt_barcode_return_master
end type
type st_2 from so_statictext within w_mat_other_receipt_barcode_return_master
end type
type sle_material_mfs from so_singlelineedit within w_mat_other_receipt_barcode_return_master
end type
type st_6 from so_statictext within w_mat_other_receipt_barcode_return_master
end type
type sle_qty from so_singlelineedit within w_mat_other_receipt_barcode_return_master
end type
type st_7 from so_statictext within w_mat_other_receipt_barcode_return_master
end type
type pb_2 from so_commandbutton within w_mat_other_receipt_barcode_return_master
end type
type cbx_sound_on from so_checkbox within w_mat_other_receipt_barcode_return_master
end type
type sle_comments from so_singlelineedit within w_mat_other_receipt_barcode_return_master
end type
type st_1 from so_statictext within w_mat_other_receipt_barcode_return_master
end type
type gb_4 from so_groupbox within w_mat_other_receipt_barcode_return_master
end type
type gb_1 from so_groupbox within w_mat_other_receipt_barcode_return_master
end type
type gb_3 from so_groupbox within w_mat_other_receipt_barcode_return_master
end type
end forward

global type w_mat_other_receipt_barcode_return_master from w_main_root
integer height = 3228
string title = "Material Receipt Barcode Return Master"
uo_dateset uo_dateset
uo_dateend uo_dateend
ddlb_item_code ddlb_item_code
st_3 st_3
st_4 st_4
st_status st_status
sle_our_barcode sle_our_barcode
st_2 st_2
sle_material_mfs sle_material_mfs
st_6 st_6
sle_qty sle_qty
st_7 st_7
pb_2 pb_2
cbx_sound_on cbx_sound_on
sle_comments sle_comments
st_1 st_1
gb_4 gb_4
gb_1 gb_1
gb_3 gb_3
end type
global w_mat_other_receipt_barcode_return_master w_mat_other_receipt_barcode_return_master

type variables
string lvs_our_barcode , lvs_item_code , lvs_lot_no , lvs_comments
int     lvi_pos1 , lvi_pos2 
long   lvl_receipt_qty , lvl_row
datetime lvdt_receipt_date
double lvdb_receipt_sequence

end variables

on w_mat_other_receipt_barcode_return_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.ddlb_item_code=create ddlb_item_code
this.st_3=create st_3
this.st_4=create st_4
this.st_status=create st_status
this.sle_our_barcode=create sle_our_barcode
this.st_2=create st_2
this.sle_material_mfs=create sle_material_mfs
this.st_6=create st_6
this.sle_qty=create sle_qty
this.st_7=create st_7
this.pb_2=create pb_2
this.cbx_sound_on=create cbx_sound_on
this.sle_comments=create sle_comments
this.st_1=create st_1
this.gb_4=create gb_4
this.gb_1=create gb_1
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.ddlb_item_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.st_status
this.Control[iCurrent+7]=this.sle_our_barcode
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.sle_material_mfs
this.Control[iCurrent+10]=this.st_6
this.Control[iCurrent+11]=this.sle_qty
this.Control[iCurrent+12]=this.st_7
this.Control[iCurrent+13]=this.pb_2
this.Control[iCurrent+14]=this.cbx_sound_on
this.Control[iCurrent+15]=this.sle_comments
this.Control[iCurrent+16]=this.st_1
this.Control[iCurrent+17]=this.gb_4
this.Control[iCurrent+18]=this.gb_1
this.Control[iCurrent+19]=this.gb_3
end on

on w_mat_other_receipt_barcode_return_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.ddlb_item_code)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_status)
destroy(this.sle_our_barcode)
destroy(this.st_2)
destroy(this.sle_material_mfs)
destroy(this.st_6)
destroy(this.sle_qty)
destroy(this.st_7)
destroy(this.pb_2)
destroy(this.cbx_sound_on)
destroy(this.sle_comments)
destroy(this.st_1)
destroy(this.gb_4)
destroy(this.gb_1)
destroy(this.gb_3)
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
Ivs_resize_type                      = 'MASTER_DETAIL_12T'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default


 ivs_dw_2_retrice_cancel_popup_open = 'N'
 ivs_dw_3_retrice_cancel_popup_open = 'N'
 ivs_dw_4_retrice_cancel_popup_open = 'N'
 ivs_dw_5_retrice_cancel_popup_open = 'N'
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
st_status.width = dw_1.width + dw_2.width
sle_our_barcode.setfocus()
f_set_column_dddw( dw_2 )
end event

event ue_data_control;call super::ue_data_control;choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		

			dw_1.reset()
			dw_1.retrieve(uo_dateset.text() , uo_dateend.text() , ddlb_item_code.text() + '%',   sle_material_mfs.text+'%' ,  gvi_organization_id)
			sle_our_barcode.setfocus()
	case 'INSERT'
			
			lvl_row = dw_2.insertrow(1)
			
	case else
end choose

end event

event open;call super::open;sle_our_barcode.setfocus()
end event

event clicked;call super::clicked;sle_our_barcode.setfocus()
end event

event resize;call super::resize;st_status.width = dw_1.width + dw_2.width
end event

type dw_5 from w_main_root`dw_5 within w_mat_other_receipt_barcode_return_master
integer y = 1096
integer width = 2267
integer height = 752
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_mat_other_receipt_barcode_return_master
integer y = 1096
integer width = 2267
integer height = 752
integer taborder = 0
end type

type dw_3 from w_main_root`dw_3 within w_mat_other_receipt_barcode_return_master
integer y = 1096
integer width = 2880
integer height = 752
integer taborder = 0
boolean titlebar = true
end type

type dw_2 from w_main_root`dw_2 within w_mat_other_receipt_barcode_return_master
integer x = 2912
integer y = 1096
integer width = 1637
integer height = 952
integer taborder = 0
boolean titlebar = true
string title = "Receipt Return Scan History"
string dataobject = "d_mat_receipt_4_barcode_compare_view"
borderstyle borderstyle = styleraised!
end type

event dw_2::clicked;call super::clicked;sle_our_barcode.setfocus()
end event

type dw_1 from w_main_root`dw_1 within w_mat_other_receipt_barcode_return_master
integer y = 1096
integer width = 2898
integer height = 952
integer taborder = 0
boolean titlebar = true
string title = "Receipt Return List"
string dataobject = "d_mat_receipt_4_barcode_return_lst"
end type

event dw_1::clicked;call super::clicked;sle_our_barcode.setfocus()
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_other_receipt_barcode_return_master
integer taborder = 0
end type

type uo_dateset from uo_ymd_calendar within w_mat_other_receipt_barcode_return_master
event destroy ( )
integer x = 55
integer y = 428
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_other_receipt_barcode_return_master
event destroy ( )
integer x = 471
integer y = 428
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_item_code from uo_item_code within w_mat_other_receipt_barcode_return_master
integer x = 887
integer y = 428
integer width = 530
integer height = 676
integer taborder = 0
boolean bringtotop = true
end type

type st_3 from so_statictext within w_mat_other_receipt_barcode_return_master
integer x = 887
integer y = 344
integer width = 530
integer height = 72
boolean bringtotop = true
string text = "Item Code"
end type

type st_4 from so_statictext within w_mat_other_receipt_barcode_return_master
integer x = 59
integer y = 344
integer width = 814
integer height = 72
boolean bringtotop = true
string text = "Receipt Date"
end type

type st_status from so_statictext within w_mat_other_receipt_barcode_return_master
integer width = 4690
integer height = 248
boolean bringtotop = true
integer textsize = -36
integer weight = 700
long textcolor = 65535
long backcolor = 16711680
string text = "Message"
end type

type sle_our_barcode from so_singlelineedit within w_mat_other_receipt_barcode_return_master
integer x = 814
integer y = 824
integer width = 1591
integer height = 104
integer taborder = 10
boolean bringtotop = true
integer textsize = -12
textcase textcase = upper!
end type

event modified;call super::modified;lvs_comments = sle_comments.text 

if this.text = '' or isnull(this.text) then 
   sle_our_barcode.setfocus( )
   return 
end if 

lvs_our_barcode = sle_our_barcode.text 

//==================================================
//  $$HEX6$$88d4a9ba200054cfdcb42000$$ENDHEX$$
//  - $$HEX15$$6cad84bd90c700ac2000c6c53cc774ba200024c658b9200098ccacb92000$$ENDHEX$$
//==================================================
//
//lvi_pos1 =  pos(lvs_our_barcode , '-' , 7 ) 
//
//if  lvi_pos1 <= 0 then 
//	f_msgbox1(1175 ,lvs_our_barcode )
//	sle_our_barcode.text = ''
//	sle_our_barcode.setfocus()
//	return -1 
//end if 
//
////=================================================
////
////=================================================
//
//lvs_item_code = trim( mid( lvs_our_barcode , 1 ,  lvi_pos1 -1 ))
	SELECT  f_get_item_code_from_barcode (:lvs_our_barcode) 
	INTO :lvs_item_code
	FROM DUAL ; 
	
	IF F_SQL_CHECK() < 0 THEN 
		sle_our_barcode.selecttext( 1,100)	
	END IF 	 
	
	if  lvs_item_code = '' then 
		
		f_play_sound("$$HEX5$$88d4a9baf8bbf1b45db8$$ENDHEX$$.wav")
		f_msgbox1(1175 ,lvs_our_barcode )
		sle_our_barcode.setfocus()
		sle_our_barcode.selecttext( 1,100)
		return 
	end if 
if f_check_item_exists( lvs_item_code , f_t_sysdate())  <= 0 then 
	f_play_sound("$$HEX5$$88d4a9baf8bbf1b45db8$$ENDHEX$$.wav")	
	f_msgbox(9041) //$$HEX10$$fcd3a9bac8b9a4c230d12000f8bbf1b45db82000$$ENDHEX$$
	st_status.text =f_msg_st(9041)
	sle_our_barcode.text = ''
	sle_our_barcode.setfocus()
     return -1
end if 

//==================================================
// $$HEX6$$6fb8b8d2200088bc38d62000$$ENDHEX$$
//==================================================
//lvi_pos2 =  pos(lvs_our_barcode , '-' , lvi_pos1+1 ) 
//
//if  lvi_pos2 <= 0 then 
//	f_msgbox1(1175 ,lvs_our_barcode )
//	sle_our_barcode.text = ''
//	sle_our_barcode.setfocus()
//	return -1 
//end if 
//
//lvs_lot_no = trim( mid( lvs_our_barcode , lvi_pos1+1 ,   lvi_pos2 - lvi_pos1 -1 ))
//if lvs_lot_no = ''  then 
//	st_status.text = "$$HEX15$$6fb8b8d288bc38d600ac20002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$"
//	sle_our_barcode.text = ''
//	sle_our_barcode.setfocus()
//	return -1
//end if 
SELECT  F_GET_LOT_NO_FROM_BARCODE (:lvs_our_barcode ) 
	INTO :lvs_lot_no
	FROM DUAL ; 
	
	IF F_SQL_CHECK() < 0 THEN 
		sle_our_barcode.selecttext( 1,100)	
	END IF 	 

	if lvs_lot_no = ''  then 
		st_status.text =f_msg( "$$HEX15$$6fb8b8d288bc38d600ac20002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$",'S')
		sle_our_barcode.setfocus()
		sle_our_barcode.selecttext( 1,100)	
		return
	end if 
//===================================
// $$HEX16$$85c7e0ac200074c725b82000200074c8acc7200020c734bb2000b4cc6cd02000$$ENDHEX$$
//===================================

int lvi_count

	 select count(*) into :lvi_count 
	  from im_item_receipt_barcode
	where item_code          = :lvs_item_code
		and lot_no               = :lvs_lot_no
		and receipt_compare_yn = 'Y'
		and issue_compare_yn = 'N'
		and organization_id        = :gvi_organization_id ;
		
	if f_sql_check() < 0 then
		this.text = ''
		sle_our_barcode.setfocus()
		return 
	end if 

//=============================
// $$HEX14$$85c7e0ac1cb4200074c725b874c7200074c8acc7200058d574ba2000$$ENDHEX$$
//=============================
if lvi_count > 0 then 
	
		//==================================
		// $$HEX14$$85c7e0ac20007cc790c7200085c7e0ac6dd588bc200070c88cd62000$$ENDHEX$$
		//==================================
		select receipt_date , receipt_sequence
			into :lvdt_receipt_date , :lvdb_receipt_sequence
			from im_item_receipt 
		 where item_code          = :lvs_item_code
		      and material_mfs                = :lvs_lot_no 
		      and receipt_status <> 'C' 
		      and receipt_deficit = '1'
			  and enter_date = ( select max(enter_date) from  im_item_receipt 
									 where item_code          = :lvs_item_code
											and material_mfs  = :lvs_lot_no 
											and receipt_status <> 'C' 
											and receipt_deficit = '1'
											 and organization_id = :gvi_organization_id
									   )
			  and organization_id = :gvi_organization_id ;
			  
		 if f_sql_check() < 0 then 
			this.text = ''
			sle_our_barcode.setfocus()
			return 
		 end if 	
 else 

		st_status.text = "NG $$HEX26$$14bc54cfdcb42000ddc031c131c1200074c725b874c72000c6c570ac98b020009ccde0ac1cb42000c1c0dcd0200085c7c8b2e4b2$$ENDHEX$$."
		f_msgbox(117 )
		sle_our_barcode.setfocus()
		return 

end if 
sle_qty.setfocus()
end event

event getfocus;call super::getfocus;this.selecttext(1,200)
end event

type st_2 from so_statictext within w_mat_other_receipt_barcode_return_master
integer x = 91
integer y = 828
integer width = 686
integer height = 100
boolean bringtotop = true
integer textsize = -12
long textcolor = 16711680
string text = "Our Barcode"
alignment alignment = right!
end type

type sle_material_mfs from so_singlelineedit within w_mat_other_receipt_barcode_return_master
integer x = 1426
integer y = 428
integer height = 88
boolean bringtotop = true
end type

type st_6 from so_statictext within w_mat_other_receipt_barcode_return_master
integer x = 1435
integer y = 344
integer height = 72
boolean bringtotop = true
string text = "Material MFS"
end type

type sle_qty from so_singlelineedit within w_mat_other_receipt_barcode_return_master
integer x = 814
integer y = 932
integer width = 425
integer height = 100
boolean bringtotop = true
integer textsize = -12
textcase textcase = upper!
end type

event getfocus;call super::getfocus;this.selecttext(1,200)
end event

event modified;call super::modified;		//==================================================
		//  $$HEX6$$85c7e0ac200018c2c9b72000$$ENDHEX$$
		//==================================================
		lvl_receipt_qty = long( sle_qty.text )
		
		if lvl_receipt_qty <=0 then 
			st_status.text = "$$HEX15$$85c7e0ac18c2c9b774c720002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$"	
			sle_our_barcode.setfocus()
			sle_our_barcode.selecttext( 1,100)	
			return
		end if 
	
			UPDATE im_item_receipt_barcode 
		   	     SET receipt_compare_yn = 'N' , 
					   receipt_compare_date = null , 
					   return_yn = 'Y' ,
					   comments = :lvs_comments,
					   return_date = sysdate
			 where item_code          = :lvs_item_code
		         and lot_no                  = :lvs_lot_no 
				and receipt_compare_yn = 'Y'
				and organization_id        = :gvi_organization_id ;
				
			if f_sql_check() < 0 then
				st_status.text = "$$HEX12$$85c7e0ace8cd8cc1200018b4c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$"	
				sle_our_barcode.setfocus()
				sle_our_barcode.selecttext( 1,100)	
				return
			end if 
	//===================================================
	//
	//===================================================
	      
		if   f_mat_receipt_return( f_t_sysdate() , lvdt_receipt_date , lvdb_receipt_sequence , long( sle_qty.text ) , 'M01') < 0  then 
			st_status.text =f_msg_st1(173 , this.text )
			rollback;
		else
			st_status.text =f_msg_st1(107 , this.text )
			commit ;
		end if 
		
//==============================================
//
//==============================================
//==============================================
//
//==============================================


	dw_2.object.item_code[lvl_row] = lvs_item_code
	dw_2.object.receipt_qty[lvl_row] = lvl_receipt_qty
	dw_2.object.material_mfs[lvl_row] = lvs_lot_no
	

f_play_sound("$$HEX4$$00c8a5c731c1f5ac$$ENDHEX$$.wav")
st_status.text = '$$HEX10$$15c8c1c098ccacb9200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$'
sle_our_barcode.text = ''
sle_our_barcode.setfocus()
end event

type st_7 from so_statictext within w_mat_other_receipt_barcode_return_master
integer x = 238
integer y = 944
integer width = 539
integer height = 100
boolean bringtotop = true
integer textsize = -12
long textcolor = 0
string text = "Qty"
alignment alignment = right!
end type

type pb_2 from so_commandbutton within w_mat_other_receipt_barcode_return_master
integer x = 2112
integer y = 428
integer width = 475
integer height = 112
integer taborder = 50
boolean bringtotop = true
string text = "Clear"
end type

event clicked;call super::clicked;
sle_our_barcode.text = ""

end event

type cbx_sound_on from so_checkbox within w_mat_other_receipt_barcode_return_master
integer x = 2130
integer y = 328
boolean bringtotop = true
string text = "Sound ON"
boolean checked = true
end type

type sle_comments from so_singlelineedit within w_mat_other_receipt_barcode_return_master
integer x = 814
integer y = 708
integer width = 1591
integer height = 112
integer taborder = 40
boolean bringtotop = true
end type

event modified;call super::modified;sle_our_barcode.setfocus()
end event

type st_1 from so_statictext within w_mat_other_receipt_barcode_return_master
integer x = 96
integer y = 716
integer width = 686
integer height = 100
boolean bringtotop = true
integer textsize = -12
long textcolor = 0
string text = "Comments"
alignment alignment = right!
end type

type gb_4 from so_groupbox within w_mat_other_receipt_barcode_return_master
integer x = 9
integer y = 584
integer width = 2679
integer height = 480
integer weight = 700
long textcolor = 16711680
string text = "Scan Receipt"
end type

type gb_1 from so_groupbox within w_mat_other_receipt_barcode_return_master
integer x = 23
integer y = 264
integer width = 1970
integer height = 300
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_mat_other_receipt_barcode_return_master
integer x = 2011
integer y = 264
integer width = 672
integer height = 308
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

