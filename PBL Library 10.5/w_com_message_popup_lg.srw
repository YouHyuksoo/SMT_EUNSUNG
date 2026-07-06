HA$PBExportHeader$w_com_message_popup_lg.srw
$PBExportComments$$$HEX7$$38bb90c7b8d3d1c908c7c4b3b0c6$$ENDHEX$$
forward
global type w_com_message_popup_lg from window
end type
type st_vendor_code from statictext within w_com_message_popup_lg
end type
type st_vendor_lot from statictext within w_com_message_popup_lg
end type
type st_3 from statictext within w_com_message_popup_lg
end type
type st_2 from statictext within w_com_message_popup_lg
end type
type p_1 from picture within w_com_message_popup_lg
end type
type st_1 from statictext within w_com_message_popup_lg
end type
type cb_2 from commandbutton within w_com_message_popup_lg
end type
type r_1 from rectangle within w_com_message_popup_lg
end type
type ln_1 from line within w_com_message_popup_lg
end type
type ln_2 from line within w_com_message_popup_lg
end type
end forward

global type w_com_message_popup_lg from window
integer x = 827
integer y = 576
integer width = 4105
integer height = 1696
boolean titlebar = true
string title = "Information !!"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 12632256
st_vendor_code st_vendor_code
st_vendor_lot st_vendor_lot
st_3 st_3
st_2 st_2
p_1 p_1
st_1 st_1
cb_2 cb_2
r_1 r_1
ln_1 ln_1
ln_2 ln_2
end type
global w_com_message_popup_lg w_com_message_popup_lg

on w_com_message_popup_lg.create
this.st_vendor_code=create st_vendor_code
this.st_vendor_lot=create st_vendor_lot
this.st_3=create st_3
this.st_2=create st_2
this.p_1=create p_1
this.st_1=create st_1
this.cb_2=create cb_2
this.r_1=create r_1
this.ln_1=create ln_1
this.ln_2=create ln_2
this.Control[]={this.st_vendor_code,&
this.st_vendor_lot,&
this.st_3,&
this.st_2,&
this.p_1,&
this.st_1,&
this.cb_2,&
this.r_1,&
this.ln_1,&
this.ln_2}
end on

on w_com_message_popup_lg.destroy
destroy(this.st_vendor_code)
destroy(this.st_vendor_lot)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.p_1)
destroy(this.st_1)
destroy(this.cb_2)
destroy(this.r_1)
destroy(this.ln_1)
destroy(this.ln_2)
end on

event open;
string   lvs_param, lvs_vendor_code, lvs_vendor_lot
integer lvi_pos

this.setredraw( false)
//f_set_layered_window( handle(this) , 85 )
//Gst_return.gvb_return = false

lvs_param = message.stringparm

lvi_pos = pos(lvs_param,'|')
lvs_vendor_code =  left(lvs_param, lvi_pos -1)
lvs_vendor_lot    =  mid(lvs_param, lvi_pos+1)

st_vendor_code.text = lvs_vendor_code
st_vendor_lot.text    = lvs_vendor_lot

this.setredraw( true)



end event

event key;IF key = keyescape! THEN 
	CB_2.TRIGGEREVENT('CLICKED')
END IF

end event

event activate;//===============================
// CENTER POSITION
//===============================
long llX, llY, llXRes, llYRes

IF GetEnvironment ( lEnv ) = 1 THEN
	// Get current screen settings
	llXRes = lEnv.ScreenWidth
	llYRes = lEnv.ScreenHeight
ELSE
	//Default to 1024/768
	llXRes = 1024
	llYRes = 768
END IF

// Convert pixels to PB units
llXRes = PixelsToUnits ( llXRes, XPixelsToUnits! )
llYRes = PixelsToUnits ( llYRes, YPixelsToUnits! )
// Is this window too wide for the current resolution ???
IF llXRes <= this.Width THEN
// Move window to leftmost position
llX = 0
ELSE
// Center window horizontally
llX = (llXRes - this.Width) / 2
END IF
// Is this window too high for the current resolution ???
IF llYRes <= this.Height THEN
// Move window to topmost position
llY = 0 
ELSE
// Center window vertically
llY = (llYRes - this.Height) / 2
END IF

//this.visible = true

this.x = llX 
this.y = llY// -120
end event

type st_vendor_code from statictext within w_com_message_popup_lg
integer x = 992
integer y = 652
integer width = 1829
integer height = 168
integer textsize = -20
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "*"
boolean focusrectangle = false
end type

type st_vendor_lot from statictext within w_com_message_popup_lg
integer x = 992
integer y = 996
integer width = 1829
integer height = 168
integer textsize = -20
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "*"
boolean focusrectangle = false
end type

type st_3 from statictext within w_com_message_popup_lg
integer x = 128
integer y = 996
integer width = 759
integer height = 168
integer textsize = -20
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Vender Lot"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_com_message_popup_lg
integer x = 119
integer y = 652
integer width = 809
integer height = 168
integer textsize = -20
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Vender Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type p_1 from picture within w_com_message_popup_lg
integer x = 2971
integer y = 480
integer width = 1029
integer height = 792
string picturename = "stop_lg.jpg"
boolean focusrectangle = false
end type

type st_1 from statictext within w_com_message_popup_lg
integer x = 41
integer y = 72
integer width = 4000
integer height = 320
integer textsize = -48
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 65535
string text = "$$HEX9$$94cd01c831c1200000adacb9200090c7acc7$$ENDHEX$$"
alignment alignment = center!
long bordercolor = 16777215
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_com_message_popup_lg
integer x = 1733
integer y = 1360
integer width = 640
integer height = 128
integer taborder = 20
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Close"
end type

event clicked;Close(parent)
end event

type r_1 from rectangle within w_com_message_popup_lg
long linecolor = 33554432
integer linethickness = 4
long fillcolor = 12632256
integer x = 82
integer y = 524
integer width = 2816
integer height = 712
end type

type ln_1 from line within w_com_message_popup_lg
long linecolor = 33554432
integer linethickness = 4
integer beginx = 87
integer beginy = 880
integer endx = 2898
integer endy = 880
end type

type ln_2 from line within w_com_message_popup_lg
long linecolor = 33554432
integer linethickness = 4
integer beginx = 937
integer beginy = 528
integer endx = 937
integer endy = 1236
end type

