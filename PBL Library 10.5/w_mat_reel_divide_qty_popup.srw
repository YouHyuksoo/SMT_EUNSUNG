HA$PBExportHeader$w_mat_reel_divide_qty_popup.srw
$PBExportComments$Purchase Order Lot Divide Popup
forward
global type w_mat_reel_divide_qty_popup from w_none_dw_popup_root
end type
type mle_log from multilineedit within w_mat_reel_divide_qty_popup
end type
type st_status from statictext within w_mat_reel_divide_qty_popup
end type
type dw_1 from so_datawindow within w_mat_reel_divide_qty_popup
end type
type st_1 from so_statictext within w_mat_reel_divide_qty_popup
end type
type em_total_qty from so_editmask within w_mat_reel_divide_qty_popup
end type
type pb_ok from so_commandbutton within w_mat_reel_divide_qty_popup
end type
type em_divide_qty from so_editmask within w_mat_reel_divide_qty_popup
end type
type st_2 from so_statictext within w_mat_reel_divide_qty_popup
end type
type pb_1 from so_commandbutton within w_mat_reel_divide_qty_popup
end type
end forward

global type w_mat_reel_divide_qty_popup from w_none_dw_popup_root
integer width = 2839
integer height = 1944
mle_log mle_log
st_status st_status
dw_1 dw_1
st_1 st_1
em_total_qty em_total_qty
pb_ok pb_ok
em_divide_qty em_divide_qty
st_2 st_2
pb_1 pb_1
end type
global w_mat_reel_divide_qty_popup w_mat_reel_divide_qty_popup

type variables
long lvl_row
end variables

on w_mat_reel_divide_qty_popup.create
int iCurrent
call super::create
this.mle_log=create mle_log
this.st_status=create st_status
this.dw_1=create dw_1
this.st_1=create st_1
this.em_total_qty=create em_total_qty
this.pb_ok=create pb_ok
this.em_divide_qty=create em_divide_qty
this.st_2=create st_2
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.mle_log
this.Control[iCurrent+2]=this.st_status
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.em_total_qty
this.Control[iCurrent+6]=this.pb_ok
this.Control[iCurrent+7]=this.em_divide_qty
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.pb_1
end on

on w_mat_reel_divide_qty_popup.destroy
call super::destroy
destroy(this.mle_log)
destroy(this.st_status)
destroy(this.dw_1)
destroy(this.st_1)
destroy(this.em_total_qty)
destroy(this.pb_ok)
destroy(this.em_divide_qty)
destroy(this.st_2)
destroy(this.pb_1)
end on

event open;call super::open;em_total_qty.text = message.stringparm
lvl_row = dw_1.insertrow(0)
em_divide_qty.setfocus( )
end event

type p_title from w_none_dw_popup_root`p_title within w_mat_reel_divide_qty_popup
integer width = 2807
end type

type cb_close from w_none_dw_popup_root`cb_close within w_mat_reel_divide_qty_popup
boolean visible = true
integer x = 1385
integer y = 1720
integer width = 521
integer height = 128
integer taborder = 0
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_none_dw_popup_root`st_msg within w_mat_reel_divide_qty_popup
boolean visible = true
integer y = 0
end type

type mle_log from multilineedit within w_mat_reel_divide_qty_popup
integer x = 1303
integer y = 568
integer width = 1504
integer height = 964
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

type st_status from statictext within w_mat_reel_divide_qty_popup
integer y = 1544
integer width = 2807
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

type dw_1 from so_datawindow within w_mat_reel_divide_qty_popup
integer x = 23
integer y = 548
integer width = 1253
integer height = 980
integer taborder = 1
boolean bringtotop = true
string title = "Qty Divide"
string dataobject = "d_mat_slip_receipt_qty_divide_pop"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
borderstyle borderstyle = stylebox!
end type

event itemchanged;this.accepttext()

if isnull(data) or string(data ) = '' or long(data )= 0 then 
	dw_1.deleterow(row)
	return 
end if 

long i ,  lvl_qty = 0 
do
	i++
	lvl_qty = lvl_qty + long(dw_1.object.qty[i])
	
loop until i = dw_1.rowcount()


if long(em_total_qty.text) = lvl_qty then 
	
elseif long(em_total_qty.text) < lvl_qty then 
	 st_status.text = f_msg("$$HEX5$$18c2c9b7200008cdfcac$$ENDHEX$$",'S')
	 return
else
	
	lvl_row = dw_1.insertrow(0)
	dw_1.scrolltorow( lvl_row)
	dw_1.setfocus( )
	dw_1.object.qty[lvl_row] =long(em_total_qty.text) - lvl_qty

end if 
end event

type st_1 from so_statictext within w_mat_reel_divide_qty_popup
integer x = 59
integer y = 260
integer width = 631
integer height = 100
boolean bringtotop = true
integer textsize = -16
long textcolor = 65535
string text = "Total Qty"
alignment alignment = right!
end type

type em_total_qty from so_editmask within w_mat_reel_divide_qty_popup
integer x = 713
integer y = 252
integer width = 567
integer height = 120
boolean bringtotop = true
integer textsize = -14
string text = "0"
string mask = "###,###,##0"
end type

type pb_ok from so_commandbutton within w_mat_reel_divide_qty_popup
integer x = 855
integer y = 1720
boolean bringtotop = true
string text = "OK"
end type

event clicked;call super::clicked;int i  , j 
long lvl_total
dw_1.accepttext( )
//==============================================
//
//==============================================
do
	i++
	 if long(dw_1.object.qty[i])  = 0 or isnull(dw_1.object.qty[i])  then 
		continue
	 else
		j++
		lvl_total = lvl_total +  long( dw_1.object.qty[i])
	     w_mat_receipt_barcode_divide_master.ivl_divide_qty[j] = long( dw_1.object.qty[i])
	 end if 

loop until i = dw_1.rowcount( )


if long(em_total_qty.text) = lvl_total then 
	close(parent)
else
	f_msgbox1(1175 , "QTY")
	return 
end if 
end event

type em_divide_qty from so_editmask within w_mat_reel_divide_qty_popup
integer x = 713
integer y = 384
integer width = 567
integer height = 120
integer taborder = 10
boolean bringtotop = true
integer textsize = -14
string text = "0"
string mask = "###,###,###"
boolean spin = true
end type

type st_2 from so_statictext within w_mat_reel_divide_qty_popup
integer x = 59
integer y = 400
integer width = 631
integer height = 100
boolean bringtotop = true
integer textsize = -16
long textcolor = 65535
string text = "Divide Qty"
alignment alignment = right!
end type

type pb_1 from so_commandbutton within w_mat_reel_divide_qty_popup
integer x = 1614
integer y = 300
integer width = 658
integer height = 184
integer taborder = 11
boolean bringtotop = true
string text = "Divide"
end type

event clicked;call super::clicked;int lvi_qty , i , lvi_add

if em_divide_qty.text = '' or isnull(em_divide_qty.text) or em_divide_qty.text = '0'  then
	return 
end if 

lvi_qty =  truncate( Long(em_total_qty.text) / long(em_divide_qty.text) , 0 ) 

dw_1.reset()
do
	i++
	
	lvl_row = dw_1.insertrow(0)
	dw_1.scrolltorow( lvl_row)
	dw_1.setfocus( )
	dw_1.object.qty[lvl_row] = long(em_divide_qty.text)
	
loop until i = lvi_qty

if mod( Long(em_total_qty.text) ,  long(em_divide_qty.text)  )  > 0 then 
	
	lvl_row = dw_1.insertrow(0)
	dw_1.scrolltorow( lvl_row)
	dw_1.setfocus( )
	dw_1.object.qty[lvl_row] = mod( Long(em_total_qty.text) ,  long(em_divide_qty.text)  )

end if 
end event

