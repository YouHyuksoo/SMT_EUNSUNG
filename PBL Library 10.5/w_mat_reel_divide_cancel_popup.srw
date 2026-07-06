HA$PBExportHeader$w_mat_reel_divide_cancel_popup.srw
$PBExportComments$Purchase Order Lot Divide Popup
forward
global type w_mat_reel_divide_cancel_popup from w_none_dw_popup_root
end type
type st_origin from so_statictext within w_mat_reel_divide_cancel_popup
end type
type sle_our_barcode from so_singlelineedit within w_mat_reel_divide_cancel_popup
end type
type mle_log from multilineedit within w_mat_reel_divide_cancel_popup
end type
type st_status from statictext within w_mat_reel_divide_cancel_popup
end type
type gb_1 from so_groupbox within w_mat_reel_divide_cancel_popup
end type
end forward

global type w_mat_reel_divide_cancel_popup from w_none_dw_popup_root
integer width = 3241
integer height = 1584
st_origin st_origin
sle_our_barcode sle_our_barcode
mle_log mle_log
st_status st_status
gb_1 gb_1
end type
global w_mat_reel_divide_cancel_popup w_mat_reel_divide_cancel_popup

type variables
string lvs_origin_item_barcode , lvs_our_barcode , lvs_item_code , lvs_lot_no , lvs_origin_lot_no
long lvl_scan_qty_sum , lvi_pos1 , lvi_pos2
double lvdb_lot_divide_sequence
end variables

on w_mat_reel_divide_cancel_popup.create
int iCurrent
call super::create
this.st_origin=create st_origin
this.sle_our_barcode=create sle_our_barcode
this.mle_log=create mle_log
this.st_status=create st_status
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_origin
this.Control[iCurrent+2]=this.sle_our_barcode
this.Control[iCurrent+3]=this.mle_log
this.Control[iCurrent+4]=this.st_status
this.Control[iCurrent+5]=this.gb_1
end on

on w_mat_reel_divide_cancel_popup.destroy
call super::destroy
destroy(this.st_origin)
destroy(this.sle_our_barcode)
destroy(this.mle_log)
destroy(this.st_status)
destroy(this.gb_1)
end on

event ue_post_open;call super::ue_post_open;sle_our_barcode.setfocus()
f_play_sound("$$HEX6$$e8cd8cc1acc2bdb9a4c294ce$$ENDHEX$$.wav")
end event

event clicked;call super::clicked;sle_our_barcode.setfocus()
end event

event open;call super::open;sle_our_barcode.setfocus()
triggerevent("ue_post_open")
end event

type p_title from w_none_dw_popup_root`p_title within w_mat_reel_divide_cancel_popup
integer width = 3232
end type

type cb_close from w_none_dw_popup_root`cb_close within w_mat_reel_divide_cancel_popup
boolean visible = true
integer x = 1294
integer y = 1352
integer width = 521
integer height = 120
integer taborder = 0
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_none_dw_popup_root`st_msg within w_mat_reel_divide_cancel_popup
boolean visible = true
integer y = 0
end type

type st_origin from so_statictext within w_mat_reel_divide_cancel_popup
integer x = 283
integer y = 716
integer width = 933
integer height = 108
boolean bringtotop = true
integer textsize = -14
integer weight = 700
string text = "Our Barcode"
end type

type sle_our_barcode from so_singlelineedit within w_mat_reel_divide_cancel_popup
integer x = 87
integer y = 836
integer width = 1289
integer height = 136
integer taborder = 10
boolean bringtotop = true
integer textsize = -14
textcase textcase = upper!
end type

event modified;call super::modified;if this.text = '' or isnull(this.text) then 
   this.setfocus( )
   return
else
	lvs_our_barcode = this.text
end if 

////=======================================
//// $$HEX11$$00cf3cd554cf200090c7acc778c72000bdacb0c62000$$ENDHEX$$
////=======================================
// IF MID (UPPER (lvs_our_barcode), 1, 1) = '['    THEN
//         SELECT  f_get_item_code_from_barcode (:lvs_our_barcode)|| '-' || f_get_lot_no_from_barcode (:lvs_our_barcode) || '-' || f_get_lot_qty_from_barcode (:lvs_our_barcode)
//		    INTO :lvs_our_barcode
//	       FROM DUAL ; 
//		
//		IF F_SQL_CHECK() < 0 THEN 
//				sle_our_barcode.selecttext( 1,100)	
//		END IF 	 
//END IF 


//==================================================
//  $$HEX6$$88d4a9ba200054cfdcb42000$$ENDHEX$$
//==================================================
//lvi_pos1 =  pos(lvs_our_barcode , '-' , 7 ) 
//
//if  lvi_pos1 <= 0 then 
//	f_msgbox1(1175 ,lvs_our_barcode )
//	sle_our_barcode.setfocus()
//	sle_our_barcode.selecttext( 1,100)
//	return -1 
//end if 

//=================================================
//
//=================================================

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
	sle_our_barcode.setfocus()
	sle_our_barcode.selecttext( 1,100)	
	return -1
end if 
//==================================================
// $$HEX6$$6fb8b8d2200088bc38d62000$$ENDHEX$$
//==================================================
//lvi_pos2 =  pos(lvs_our_barcode , '-' , lvi_pos1+1 ) 
//
//if  lvi_pos2 <= 0 then 
//	
//	lvs_lot_no = trim( mid( lvs_our_barcode , lvi_pos1+1 ,  100 ))
//	
//	if lvs_lot_no = ''  then 
//		st_status.text = f_msg("$$HEX15$$6fb8b8d288bc38d600ac20002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$",'S')
//		f_msg("$$HEX15$$6fb8b8d288bc38d600ac20002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$",'P')
//		//mes sagebox("$$HEX2$$55d678c7$$ENDHEX$$" , "$$HEX15$$6fb8b8d288bc38d600ac20002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$")
//		sle_our_barcode.setfocus()
//		sle_our_barcode.selecttext( 1,100)	
//		return -1
//	end if 
//else
//	
//	lvs_lot_no = trim( mid( lvs_our_barcode , lvi_pos1+1 ,   lvi_pos2 - lvi_pos1 -1 ))
//	if lvs_lot_no = ''  then 
//		st_status.text = f_msg("$$HEX15$$6fb8b8d288bc38d600ac20002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$",'S')
//		
//		f_msg("$$HEX15$$6fb8b8d288bc38d600ac20002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$",'P')
//		//mes sagebox("$$HEX2$$55d678c7$$ENDHEX$$" , "$$HEX15$$6fb8b8d288bc38d600ac20002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$")
//		sle_our_barcode.setfocus()
//		sle_our_barcode.selecttext( 1,100)	
//		return -1
//	end if 
//
//end if 

SELECT  F_GET_LOT_NO_FROM_BARCODE (:lvs_our_barcode ) 
	INTO :lvs_lot_no
	FROM DUAL ; 
	
	IF F_SQL_CHECK() < 0 THEN 
		sle_our_barcode.selecttext( 1,100)	
	END IF 	 

	if lvs_lot_no = ''  then 
		f_msg( "$$HEX15$$6fb8b8d288bc38d600ac20002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$",'P')
		sle_our_barcode.setfocus()
		sle_our_barcode.selecttext( 1,100)	
		return
	end if 
//===================================================
// $$HEX11$$d0c66fb8b8d27cb9200094cd9ccd20005cd5e4b22000$$ENDHEX$$
//===================================================

int lvi_count

      select origin_lot_no , nvl(lot_divide_sequence,0)
		into :lvs_origin_lot_no  , :lvdb_lot_divide_sequence
	  from im_item_receipt_barcode
	where item_code =:lvs_item_code
		and lot_no = :lvs_lot_no
		and receipt_compare_yn = 'Y'
		and issue_compare_yn = 'N'
		and barcode_status <> 'C'
		and organization_id = :gvi_organization_id ;
		
	if f_sql_check() < 0 then
		this.text = ''
		this.setfocus()
		return 
	end if 
	
	
IF 	ISNULL(lvs_origin_lot_no) OR lvs_origin_lot_no = '' THEN 
	
	this.text = ''
	st_status.text = f_msg("$$HEX19$$14bc54cfdcb4200085c7e0ac200015c8f4bcd0c5200090c7ccb800ac2000c6c5b5c2c8b2e4b2$$ENDHEX$$",'S')
	f_msg("$$HEX19$$14bc54cfdcb4200085c7e0ac200015c8f4bcd0c5200090c7ccb800ac2000c6c5b5c2c8b2e4b2$$ENDHEX$$",'P')
	//mes sagebox("$$HEX2$$55d678c7$$ENDHEX$$" , "$$HEX19$$14bc54cfdcb4200085c7e0ac200015c8f4bcd0c5200090c7ccb800ac2000c6c5b5c2c8b2e4b2$$ENDHEX$$")
	this.setfocus()
	return 
	
END IF 
//=================================================
//
//=================================================

	select  sum(scan_qty) , count(*)
        into :lvl_scan_qty_sum , :lvi_count
	  from im_item_receipt_barcode
	where  origin_lot_no = :lvs_origin_lot_no
		and receipt_compare_yn = 'Y'
		and issue_compare_yn = 'N'
		and barcode_status <> 'C'
//		and lot_divide_yn = 'Y'
		and nvl(lot_divide_sequence,0) = :lvdb_lot_divide_sequence
		and organization_id = :gvi_organization_id ;	
		
	if f_sql_check() < 0 then 
			this.text = ''
			this.setfocus()
			return 
	end if 
	
if LEN(lvs_origin_lot_no) > 0 and lvi_count > 0 then 
	
else
	this.text = ''
	st_status.text = f_msg("$$HEX19$$14bc54cfdcb4200085c7e0ac200015c8f4bcd0c5200090c7ccb800ac2000c6c5b5c2c8b2e4b2$$ENDHEX$$",'S')
	f_msg("$$HEX19$$14bc54cfdcb4200085c7e0ac200015c8f4bcd0c5200090c7ccb800ac2000c6c5b5c2c8b2e4b2$$ENDHEX$$",'P')
	//mes sagebox("$$HEX2$$55d678c7$$ENDHEX$$" , "$$HEX19$$14bc54cfdcb4200085c7e0ac200015c8f4bcd0c5200090c7ccb800ac2000c6c5b5c2c8b2e4b2$$ENDHEX$$")
	this.setfocus()
	return 
end if 
//===================================================
// $$HEX13$$5cd51cacccb92000a8b030aee0ac2000e4b22000adc01cc82000$$ENDHEX$$
// $$HEX12$$d0c66fb8b8d294b2200084bd60d52000ecc580bd00ac2000$$ENDHEX$$N $$HEX15$$74c7c0bb5cb82000adc01cc8200048c518b4e0ac2000a8b094b2e4b22000$$ENDHEX$$
//===================================================

     delete from im_item_receipt_barcode 	
	where  origin_lot_no= :lvs_origin_lot_no
		and receipt_compare_yn = 'Y'
		and issue_compare_yn = 'N'
		and lot_divide_yn = 'Y'
		and barcode_status <> 'C'
		and nvl(lot_divide_sequence,0) = :lvdb_lot_divide_sequence
		;
	if f_sql_check() < 0 then
		this.text = ''
		this.setfocus()
		return 
	end if 
  //============================================
  //  $$HEX20$$a8b040c7200078d51cac7cb9200000acc0c9e0ac2000e4b2dcc22000f5bc6cad200098ccacb92000$$ENDHEX$$
  //============================================
    update im_item_receipt_barcode 
	     set scan_qty = :lvl_scan_qty_sum ,
		      item_barcode = :lvs_item_code||'-'||lot_no||'-'||:lvl_scan_qty_sum ,
			 lot_divide_yn = 'N' ,
			 lot_divide_sequence = null  ,
		  	 origin_lot_no = null
	where item_code =:lvs_item_code
    // 	and lot_no = :lvs_lot_no
		and origin_lot_no = :lvs_origin_lot_no 
		and receipt_compare_yn = 'Y'
		and issue_compare_yn = 'N'
		and barcode_status <> 'C' 

		and nvl(lot_divide_sequence,0) = :lvdb_lot_divide_sequence ;
	 
	if f_sql_check() < 0 then
		this.text = ''
		this.setfocus()
		return 
	end if 
	//===========================================
	//
	//===========================================
	
	f_mat_issue_4_lot_divide_cancel( lvs_item_code , lvdb_lot_divide_sequence ) 
	
	//===========================================
	mle_log.text = this.text+'~r~n'+mle_log.text
	st_status.text =f_msg_st1(107 , this.text )
	f_play_sound("$$HEX4$$00c8a5c731c1f5ac$$ENDHEX$$.wav")	
	COMMIT ; 

this.text = ''
this.setfocus()
end event

type mle_log from multilineedit within w_mat_reel_divide_cancel_popup
integer x = 1422
integer y = 220
integer width = 1797
integer height = 916
boolean bringtotop = true
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
boolean autohscroll = true
boolean autovscroll = true
borderstyle borderstyle = stylelowered!
end type

type st_status from statictext within w_mat_reel_divide_cancel_popup
integer x = 5
integer y = 1164
integer width = 3223
integer height = 160
boolean bringtotop = true
integer textsize = -20
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 65535
long backcolor = 16711680
string text = "Mesage"
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;sle_our_barcode.setfocus()
end event

type gb_1 from so_groupbox within w_mat_reel_divide_cancel_popup
integer x = 32
integer y = 484
integer width = 1367
integer height = 580
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

