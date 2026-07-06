HA$PBExportHeader$w_updateend_message_ontime.srw
$PBExportComments$$$HEX13$$7cc715c8dcc204acd9b348c5200054ba38c1c0c97cb99ccd25b8$$ENDHEX$$
forward
global type w_updateend_message_ontime from window
end type
type p_2 from picture within w_updateend_message_ontime
end type
type st_7 from so_statictext within w_updateend_message_ontime
end type
type st_rows from so_statictext within w_updateend_message_ontime
end type
type cb_2 from commandbutton within w_updateend_message_ontime
end type
type cb_1 from commandbutton within w_updateend_message_ontime
end type
type st_6 from statictext within w_updateend_message_ontime
end type
type st_5 from so_statictext within w_updateend_message_ontime
end type
type sle_delete from so_singlelineedit within w_updateend_message_ontime
end type
type sle_update from so_singlelineedit within w_updateend_message_ontime
end type
type sle_insert from so_singlelineedit within w_updateend_message_ontime
end type
type st_3 from so_statictext within w_updateend_message_ontime
end type
type st_2 from so_statictext within w_updateend_message_ontime
end type
type st_1 from so_statictext within w_updateend_message_ontime
end type
type p_1 from picture within w_updateend_message_ontime
end type
type pb_info_msg from so_picturebutton within w_updateend_message_ontime
end type
type gb_1 from so_groupbox within w_updateend_message_ontime
end type
type st_4 from statictext within w_updateend_message_ontime
end type
end forward

global type w_updateend_message_ontime from window
integer x = 1074
integer y = 840
integer width = 1879
integer height = 616
windowtype windowtype = response!
long backcolor = 15780518
boolean center = true
p_2 p_2
st_7 st_7
st_rows st_rows
cb_2 cb_2
cb_1 cb_1
st_6 st_6
st_5 st_5
sle_delete sle_delete
sle_update sle_update
sle_insert sle_insert
st_3 st_3
st_2 st_2
st_1 st_1
p_1 p_1
pb_info_msg pb_info_msg
gb_1 gb_1
st_4 st_4
end type
global w_updateend_message_ontime w_updateend_message_ontime

event open;Gvf_time = message.doubleparm

if  UpperBound(Gst_return.Gvf_return) = 0 then 
	sle_insert.text   = String(0 , '###,##0')
	sle_update.text = String(0 , '###,##0')
	sle_delete.text  = String(0 , '###,##0')
     st_rows.text =  string( 0 , '###,##0')	
else
	sle_insert.text   = String(Gst_return.Gvf_return[1] , '###,##0')
	sle_update.text = String(Gst_return.Gvf_return[2], '###,##0')
	sle_delete.text  = String(Gst_return.Gvf_return[3], '###,##0')	
     st_rows.text =  string( Gst_return.Gvf_return[1] + Gst_return.Gvf_return[2] + Gst_return.Gvf_return[3]  , '###,##0')	
end if


TIMER(Gvf_time )
end event

event close;Gst_return.Gvf_return[1] = 0
Gst_return.Gvf_return[2] = 0
Gst_return.Gvf_return[3] =0 

Timer(0)

end event

on w_updateend_message_ontime.create
this.p_2=create p_2
this.st_7=create st_7
this.st_rows=create st_rows
this.cb_2=create cb_2
this.cb_1=create cb_1
this.st_6=create st_6
this.st_5=create st_5
this.sle_delete=create sle_delete
this.sle_update=create sle_update
this.sle_insert=create sle_insert
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.p_1=create p_1
this.pb_info_msg=create pb_info_msg
this.gb_1=create gb_1
this.st_4=create st_4
this.Control[]={this.p_2,&
this.st_7,&
this.st_rows,&
this.cb_2,&
this.cb_1,&
this.st_6,&
this.st_5,&
this.sle_delete,&
this.sle_update,&
this.sle_insert,&
this.st_3,&
this.st_2,&
this.st_1,&
this.p_1,&
this.pb_info_msg,&
this.gb_1,&
this.st_4}
end on

on w_updateend_message_ontime.destroy
destroy(this.p_2)
destroy(this.st_7)
destroy(this.st_rows)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.sle_delete)
destroy(this.sle_update)
destroy(this.sle_insert)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.p_1)
destroy(this.pb_info_msg)
destroy(this.gb_1)
destroy(this.st_4)
end on

event timer;Close(This)
end event

type p_2 from picture within w_updateend_message_ontime
integer x = 32
integer y = 48
integer width = 96
integer height = 80
boolean originalsize = true
string picturename = "exclamation.gif"
boolean focusrectangle = false
end type

type st_7 from so_statictext within w_updateend_message_ontime
integer x = 1371
integer y = 64
integer width = 457
integer textsize = -10
integer weight = 700
long backcolor = 134217739
string text = "Rows Changed"
alignment alignment = right!
end type

type st_rows from so_statictext within w_updateend_message_ontime
integer x = 1088
integer y = 56
integer width = 265
integer textsize = -10
integer weight = 700
long backcolor = 134217739
end type

type cb_2 from commandbutton within w_updateend_message_ontime
integer x = 1486
integer y = 332
integer width = 343
integer height = 92
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Close"
end type

event clicked;Timer(0)
Close(Parent)
end event

type cb_1 from commandbutton within w_updateend_message_ontime
integer x = 1486
integer y = 232
integer width = 343
integer height = 92
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Hold"
boolean default = true
end type

event clicked;timer(10)
end event

type st_6 from statictext within w_updateend_message_ontime
integer x = 151
integer y = 56
integer width = 923
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 134217739
string text = "Update Result Information Total "
boolean focusrectangle = false
end type

type st_5 from so_statictext within w_updateend_message_ontime
integer x = 14
integer y = 176
integer width = 1847
integer height = 16
integer textsize = -10
boolean border = true
borderstyle borderstyle = stylelowered!
end type

type sle_delete from so_singlelineedit within w_updateend_message_ontime
integer x = 1152
integer y = 448
integer width = 283
integer textsize = -10
long backcolor = 15780518
boolean border = false
borderstyle borderstyle = stylebox!
end type

type sle_update from so_singlelineedit within w_updateend_message_ontime
integer x = 1152
integer y = 352
integer width = 283
integer textsize = -10
long backcolor = 15780518
boolean border = false
borderstyle borderstyle = stylebox!
end type

type sle_insert from so_singlelineedit within w_updateend_message_ontime
integer x = 1152
integer y = 260
integer width = 283
integer textsize = -10
long backcolor = 15780518
boolean border = false
borderstyle borderstyle = stylebox!
end type

type st_3 from so_statictext within w_updateend_message_ontime
integer x = 507
integer y = 448
integer width = 457
integer textsize = -10
integer weight = 700
long textcolor = 255
long backcolor = 15780518
string text = "Delete Row(s)"
alignment alignment = right!
end type

type st_2 from so_statictext within w_updateend_message_ontime
integer x = 507
integer y = 348
integer width = 457
integer textsize = -10
integer weight = 700
long textcolor = 16711680
long backcolor = 15780518
string text = "Update Row(s)"
alignment alignment = right!
end type

type st_1 from so_statictext within w_updateend_message_ontime
integer x = 507
integer y = 260
integer width = 457
integer textsize = -10
integer weight = 700
long backcolor = 15780518
string text = "Insert Row(s)"
alignment alignment = right!
end type

type p_1 from picture within w_updateend_message_ontime
integer x = 91
integer y = 236
integer width = 297
integer height = 320
boolean originalsize = true
string picturename = "diskcd.gif"
boolean focusrectangle = false
end type

type pb_info_msg from so_picturebutton within w_updateend_message_ontime
integer x = 27
integer y = 224
integer width = 411
integer height = 348
integer textsize = -10
vtextalign vtextalign = multiline!
end type

type gb_1 from so_groupbox within w_updateend_message_ontime
integer x = 471
integer y = 196
integer width = 983
integer height = 376
integer taborder = 10
integer textsize = -10
integer weight = 700
long backcolor = 15780518
end type

type st_4 from statictext within w_updateend_message_ontime
integer x = 14
integer y = 16
integer width = 1847
integer height = 140
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 134217739
boolean focusrectangle = false
end type

