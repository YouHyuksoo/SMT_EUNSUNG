HA$PBExportHeader$w_mat_slip_cancel_popup.srw
$PBExportComments$Purchase Order Lot Divide Popup
forward
global type w_mat_slip_cancel_popup from w_none_dw_popup_root
end type
type st_origin from so_statictext within w_mat_slip_cancel_popup
end type
type sle_slip_no from so_singlelineedit within w_mat_slip_cancel_popup
end type
type mle_log from multilineedit within w_mat_slip_cancel_popup
end type
type st_status from statictext within w_mat_slip_cancel_popup
end type
type gb_1 from so_groupbox within w_mat_slip_cancel_popup
end type
end forward

global type w_mat_slip_cancel_popup from w_none_dw_popup_root
integer width = 3241
integer height = 1584
st_origin st_origin
sle_slip_no sle_slip_no
mle_log mle_log
st_status st_status
gb_1 gb_1
end type
global w_mat_slip_cancel_popup w_mat_slip_cancel_popup

on w_mat_slip_cancel_popup.create
int iCurrent
call super::create
this.st_origin=create st_origin
this.sle_slip_no=create sle_slip_no
this.mle_log=create mle_log
this.st_status=create st_status
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_origin
this.Control[iCurrent+2]=this.sle_slip_no
this.Control[iCurrent+3]=this.mle_log
this.Control[iCurrent+4]=this.st_status
this.Control[iCurrent+5]=this.gb_1
end on

on w_mat_slip_cancel_popup.destroy
call super::destroy
destroy(this.st_origin)
destroy(this.sle_slip_no)
destroy(this.mle_log)
destroy(this.st_status)
destroy(this.gb_1)
end on

event ue_post_open;call super::ue_post_open;sle_slip_no.setfocus()
f_play_sound("$$HEX6$$e8cd8cc1acc2bdb9a4c294ce$$ENDHEX$$.wav")
end event

event clicked;call super::clicked;sle_slip_no.setfocus()
end event

event open;call super::open;sle_slip_no.setfocus()
triggerevent("ue_post_open")
end event

type p_title from w_none_dw_popup_root`p_title within w_mat_slip_cancel_popup
integer width = 3232
end type

type cb_close from w_none_dw_popup_root`cb_close within w_mat_slip_cancel_popup
boolean visible = true
integer x = 1294
integer y = 1352
integer width = 521
integer height = 120
integer taborder = 0
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_none_dw_popup_root`st_msg within w_mat_slip_cancel_popup
boolean visible = true
integer y = 0
end type

type st_origin from so_statictext within w_mat_slip_cancel_popup
integer x = 265
integer y = 436
integer width = 933
integer height = 108
boolean bringtotop = true
integer textsize = -14
integer weight = 700
string text = "Slip No"
end type

type sle_slip_no from so_singlelineedit within w_mat_slip_cancel_popup
integer x = 265
integer y = 556
integer width = 933
integer height = 136
integer taborder = 10
boolean bringtotop = true
integer textsize = -18
textcase textcase = upper!
end type

event modified;call super::modified;if this.text = '' or isnull(this.text) then 
   sle_slip_no.setfocus( )
   return 
end if 

//===================================
// $$HEX9$$74c8acc7200020c734bb2000b4cc6cd02000$$ENDHEX$$
//===================================
if f_check_slip_exists( this.text)  < 1 then
	st_status.text = f_msg("$$HEX9$$acc2bdb974c72000c6c5b5c2c8b2e4b22000$$ENDHEX$$: NG",'S')
	f_msgbox(117 )
	mle_log.text =this.text+"  "+f_msg_st(117) +'~r~n'+mle_log.text		
	this.text = ''
	sle_slip_no.setfocus()
	return 
end if 
//===================================================
// $$HEX22$$14bc54cfdcb4d0c5200074c7f8bb200085c7e0ac200018b4c8c594b2c0c9200098cc6cd020005cd5e4b22000$$ENDHEX$$
//===================================================

int lvi_count

select count(*) into :lvi_count 
  from im_item_receipt_barcode
where receipt_slip_no = :this.text 
   and receipt_compare_yn = 'Y'
   and barcode_status <> 'C'
   and organization_id = :gvi_organization_id ;
	
if f_sql_check() < 0 then
	this.text = ''
	sle_slip_no.setfocus()
	return 
end if 

//==================================================
//
//================================================

if lvi_count > 0 then 
	f_msgbox1(125 , f_get_dual_lang_text( GVS_LANGUAGE ,  "RECEIPT") )
	mle_log.text =this.text+"  "+f_msg_st1(125 ,  f_get_dual_lang_text( GVS_LANGUAGE ,  "RECEIPT")) +'~r~n'+mle_log.text	
	this.text = ''
	sle_slip_no.setfocus()
	return 
end if 
//===================================================
//
//===================================================
int lvi_return 
lvi_return = f_mat_receipt_slip_cancel(this.text)

if lvi_return < 0 then 
	
    st_status.text =f_msg_st1(173 , this.text )
	 f_play_sound("$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav")	
	ROLLBACK;
else
	mle_log.text = this.text+'~r~n'+mle_log.text
	st_status.text =f_msg_st1(107 , this.text )
	f_play_sound("$$HEX4$$00c8a5c731c1f5ac$$ENDHEX$$.wav")	
	COMMIT ;
end if 

this.text = ''
sle_slip_no.setfocus()
end event

type mle_log from multilineedit within w_mat_slip_cancel_popup
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

type st_status from statictext within w_mat_slip_cancel_popup
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

event clicked;sle_slip_no.setfocus()
end event

type gb_1 from so_groupbox within w_mat_slip_cancel_popup
integer x = 14
integer y = 204
integer width = 1367
integer height = 580
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

