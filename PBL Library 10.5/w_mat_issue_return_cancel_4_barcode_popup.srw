HA$PBExportHeader$w_mat_issue_return_cancel_4_barcode_popup.srw
$PBExportComments$Purchase Order Lot Divide Popup
forward
global type w_mat_issue_return_cancel_4_barcode_popup from w_none_dw_popup_root
end type
type st_origin from so_statictext within w_mat_issue_return_cancel_4_barcode_popup
end type
type sle_our_barcode from so_singlelineedit within w_mat_issue_return_cancel_4_barcode_popup
end type
type mle_log from multilineedit within w_mat_issue_return_cancel_4_barcode_popup
end type
type st_status from statictext within w_mat_issue_return_cancel_4_barcode_popup
end type
type st_1 from statictext within w_mat_issue_return_cancel_4_barcode_popup
end type
type em_count from so_editmask within w_mat_issue_return_cancel_4_barcode_popup
end type
type gb_1 from so_groupbox within w_mat_issue_return_cancel_4_barcode_popup
end type
end forward

global type w_mat_issue_return_cancel_4_barcode_popup from w_none_dw_popup_root
integer width = 3241
integer height = 1568
st_origin st_origin
sle_our_barcode sle_our_barcode
mle_log mle_log
st_status st_status
st_1 st_1
em_count em_count
gb_1 gb_1
end type
global w_mat_issue_return_cancel_4_barcode_popup w_mat_issue_return_cancel_4_barcode_popup

on w_mat_issue_return_cancel_4_barcode_popup.create
int iCurrent
call super::create
this.st_origin=create st_origin
this.sle_our_barcode=create sle_our_barcode
this.mle_log=create mle_log
this.st_status=create st_status
this.st_1=create st_1
this.em_count=create em_count
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_origin
this.Control[iCurrent+2]=this.sle_our_barcode
this.Control[iCurrent+3]=this.mle_log
this.Control[iCurrent+4]=this.st_status
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.em_count
this.Control[iCurrent+7]=this.gb_1
end on

on w_mat_issue_return_cancel_4_barcode_popup.destroy
call super::destroy
destroy(this.st_origin)
destroy(this.sle_our_barcode)
destroy(this.mle_log)
destroy(this.st_status)
destroy(this.st_1)
destroy(this.em_count)
destroy(this.gb_1)
end on

event ue_post_open;call super::ue_post_open;sle_our_barcode.setfocus()
end event

event clicked;call super::clicked;sle_our_barcode.setfocus()
end event

event open;call super::open;sle_our_barcode.setfocus()
st_status.text =f_msg( "$$HEX18$$e8cd8cc160d5200090c7acc0200014bc54cfdcb47cb92000a4c294ce200058d538c194c6$$ENDHEX$$",'S')
end event

type p_title from w_none_dw_popup_root`p_title within w_mat_issue_return_cancel_4_barcode_popup
integer width = 3232
end type

type cb_close from w_none_dw_popup_root`cb_close within w_mat_issue_return_cancel_4_barcode_popup
boolean visible = true
integer x = 1339
integer y = 1360
integer width = 521
integer height = 120
integer taborder = 0
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_none_dw_popup_root`st_msg within w_mat_issue_return_cancel_4_barcode_popup
boolean visible = true
integer y = 0
end type

type st_origin from so_statictext within w_mat_issue_return_cancel_4_barcode_popup
integer x = 274
integer y = 636
integer width = 933
integer height = 108
boolean bringtotop = true
integer textsize = -14
integer weight = 700
string text = "Our Barcode"
end type

type sle_our_barcode from so_singlelineedit within w_mat_issue_return_cancel_4_barcode_popup
integer x = 69
integer y = 756
integer width = 1563
integer height = 136
integer taborder = 10
boolean bringtotop = true
integer textsize = -14
textcase textcase = upper!
end type

event modified;call super::modified;string lvs_our_barcode , lvs_item_code , lvs_lot_no , lvs_material_mfs
int     lvi_pos1 , lvi_pos2 
long   lvl_issue_qty
datetime lvdt_issue_date
double lvdb_issue_sequence

if this.text = '' or isnull(this.text) then 
   sle_our_barcode.setfocus( )
   return 
end if 

lvs_our_barcode = sle_our_barcode.text 

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
//	return 
//end if 
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
//	if lvs_lot_no = ''  then 
//		st_status.text = f_msg("$$HEX15$$6fb8b8d288bc38d600ac20002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$",'S')
//		sle_our_barcode.setfocus()
//		sle_our_barcode.selecttext( 1,100)	
//		return
//	end if 
//else
//	
//		lvs_lot_no = trim( mid( lvs_our_barcode , lvi_pos1+1 ,   lvi_pos2 - lvi_pos1 -1 ))
//		if lvs_lot_no = ''  then 
//			st_status.text = f_msg("$$HEX15$$6fb8b8d288bc38d600ac20002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$",'S')
//			sle_our_barcode.setfocus()
//			sle_our_barcode.selecttext( 1,100)	
//			return
//		end if 
//
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
// $$HEX17$$14bc54cfdcb4200074c725b82000200074c8acc7200020c734bb2000b4cc6cd02000$$ENDHEX$$
//===================================

int lvi_count

	 select count(*) into :lvi_count 
	  from im_item_receipt_barcode
	where item_code          = :lvs_item_code
	    and lot_no              =  :lvs_lot_no
		and issue_compare_yn = 'N'
		and organization_id        = :gvi_organization_id ;
		
	if f_sql_check() < 0 then
		this.text = ''
		sle_our_barcode.setfocus()
		return 
	end if 

//=============================
// $$HEX10$$74c725b874c7200074c8acc7200058d574ba2000$$ENDHEX$$
//=============================
if lvi_count > 0 then 
	
		if f_check_item_exists( lvs_item_code , f_t_sysdate())  <= 0 then 
			f_msgbox(9041) //$$HEX10$$fcd3a9bac8b9a4c230d12000f8bbf1b45db82000$$ENDHEX$$
			sle_our_barcode.setfocus()
			sle_our_barcode.selecttext( 1,100)	
		end if 
		
		//==================================
		//  $$HEX11$$7cc790c7200085c7e0ac6dd588bc200070c88cd62000$$ENDHEX$$
		//==================================

		SELECT   material_mfs, issue_date, issue_sequence
		  INTO   :lvs_material_mfs, :lvdt_issue_date, :lvdb_issue_sequence
		  FROM   im_item_issue
		 WHERE          material_mfs = :lvs_lot_no
		 			AND item_code = :lvs_item_code
					AND issue_status <> 'C'
					AND issue_deficit = '4'
					AND enter_date =
							 (SELECT   MAX (enter_date)
								 FROM   im_item_issue
								WHERE       material_mfs = :lvs_lot_no
										  AND item_code     = :lvs_item_code
										  AND issue_status <> 'C'
										  AND issue_deficit = '4'
										  AND organization_id = :gvi_organization_id)
					AND organization_id = :gvi_organization_id;
			  
		 if f_sql_check() < 0 then 
			this.text = ''
			sle_our_barcode.setfocus()
			return 
		 end if 	
//==========================================================
// $$HEX16$$7cb778c7d0c520009ccde0ac1cb42000c1c0dcd05cb8200018b4ccb3bdb92000$$ENDHEX$$
//==========================================================
	update im_item_receipt_barcode 
	     set issue_compare_yn = 'Y'  , 
		      issue_return_yn = 'N' ,
			 scan_qty = DECODE(  NVL(last_scan_qty ,0) , 0 , scan_qty , NVL(last_scan_qty ,0) ),  //$$HEX10$$74c704c818c2c9b73cc75cb82000f5bc6cad2000$$ENDHEX$$
			 issue_compare_date = nvl( LAST_ISSUE_COMPARE_DATE ,issue_compare_date )  ,
			 issue_compare_by   =  nvl( last_issue_compare_by  , issue_compare_by ) 
	 where  item_code               = :lvs_item_code
	    and lot_no                   =  :lvs_lot_no
		and issue_compare_yn = 'N'
		and organization_id        = :gvi_organization_id ;
		
	if f_sql_check() < 0 then
		this.text = ''
		sle_our_barcode.setfocus()
		return 
	end if 	 
	//===================================================
	//
	//===================================================
		if f_mat_issue_cancel( lvs_material_mfs , lvdt_issue_date , lvdb_issue_sequence , 0 , f_t_sysdate() ) < 0 then 
			st_status.text =f_msg_st1(173 , this.text )
			mle_log.text = f_msg_st1(173 , this.text )+" "+this.text+'~r~n'+mle_log.text
			rollback;
		else
			mle_log.text = this.text+'~r~n'+mle_log.text
			st_status.text =f_msg_st1(107 , this.text )
			em_count.text = string( long(em_count.text) +1 )
			f_play_sound("$$HEX4$$00c8a5c731c1f5ac$$ENDHEX$$.wav")
			commit ;
		end if 
//==============================================
//
//==============================================
else 

	st_status.text = "NG"
	f_msgbox(117 )
	mle_log.text =this.text+"  "+f_msg_st(117) +'~r~n'+mle_log.text		
	this.text = ''
	sle_our_barcode.setfocus()
	return 

end if 

sle_our_barcode.text = ''
sle_our_barcode.setfocus()
end event

type mle_log from multilineedit within w_mat_issue_return_cancel_4_barcode_popup
integer x = 1691
integer y = 220
integer width = 1527
integer height = 916
boolean bringtotop = true
integer textsize = -18
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

type st_status from statictext within w_mat_issue_return_cancel_4_barcode_popup
integer y = 1156
integer width = 3223
integer height = 188
boolean bringtotop = true
integer textsize = -14
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

type st_1 from statictext within w_mat_issue_return_cancel_4_barcode_popup
integer x = 41
integer y = 908
integer width = 686
integer height = 116
boolean bringtotop = true
integer textsize = -18
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Total Count"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_count from so_editmask within w_mat_issue_return_cancel_4_barcode_popup
integer x = 782
integer y = 904
integer width = 544
integer height = 124
boolean bringtotop = true
integer textsize = -16
string text = "0"
end type

type gb_1 from so_groupbox within w_mat_issue_return_cancel_4_barcode_popup
integer x = 18
integer y = 204
integer width = 1650
integer height = 924
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

