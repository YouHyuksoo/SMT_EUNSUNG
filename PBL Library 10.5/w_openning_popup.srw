HA$PBExportHeader$w_openning_popup.srw
forward
global type w_openning_popup from window
end type
type mle_message from multilineedit within w_openning_popup
end type
type pb_1 from picturebutton within w_openning_popup
end type
type p_2 from picture within w_openning_popup
end type
type p_1 from picture within w_openning_popup
end type
end forward

global type w_openning_popup from window
integer width = 2761
integer height = 1684
windowtype windowtype = popup!
long backcolor = 16777215
string icon = "AppIcon!"
boolean clientedge = true
event ue_post_open ( )
mle_message mle_message
pb_1 pb_1
p_2 p_2
p_1 p_1
end type
global w_openning_popup w_openning_popup

event open;//===============================
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

//this.visible = false

this.x = llX 
this.y = llY -300

animatewindow(handle(this),500, 524288 )  //fade 
//animatewindow(handle(this),500, 262148 )  //$$HEX8$$04c7d0c51cc1200044c598b75cb82000$$ENDHEX$$
//262145 $$HEX5$$7cc6bdcad0c51cc12000$$ENDHEX$$-> $$HEX5$$24c678b9bdca3cc75cb8$$ENDHEX$$
//262146 $$HEX6$$24c678b9bdcad0c51cc12000$$ENDHEX$$-> $$HEX4$$7cc6bdca3cc75cb8$$ENDHEX$$
this.visible = TRUE
this.setredraw( true)

//================================================
//
//================================================
//[instance variable]  
//CONSTANT LONG AW_HOR_POSITIVE = 1
//CONSTANT LONG AW_HOR_NEGATIVE = 2
//CONSTANT LONG AW_VER_POSITIVE = 4
//CONSTANT LONG AW_VER_NEGATIVE = 8
//CONSTANT LONG AW_CENTER = 16
//CONSTANT LONG AW_HIDE = 65536
//CONSTANT LONG AW_ACTIVATE = 131072
//CONSTANT LONG AW_SLIDE = 262144
//CONSTANT LONG AW_BLEND = 524288  
//
//[powerscript, open event]
//// slide right to left
//AnimateWindow ( Handle( this ),500,AW_HOR_NEGATIVE) 
//
//// slide left to right
//AnimateWindow ( Handle( this ),500,AW_HOR_POSITIVE)
//
//// slide top to bottom
//AnimateWindow ( Handle( this ),500,AW_VER_POSITIVE)
//
//// slide bottom to top
//AnimateWindow ( Handle( this ),500,AW_VER_NEGATIVE)
//
//// from center expand
//AnimateWindow ( Handle( this ),500,AW_CENTER)
//
//// reveal diagonnally
//AnimateWindow ( Handle( this ),500,AW_VER_NEGATIVE + AW_HOR_NEGATIVE)
end event

on w_openning_popup.create
this.mle_message=create mle_message
this.pb_1=create pb_1
this.p_2=create p_2
this.p_1=create p_1
this.Control[]={this.mle_message,&
this.pb_1,&
this.p_2,&
this.p_1}
end on

on w_openning_popup.destroy
destroy(this.mle_message)
destroy(this.pb_1)
destroy(this.p_2)
destroy(this.p_1)
end on

type mle_message from multilineedit within w_openning_popup
integer x = 1627
integer y = 812
integer width = 1102
integer height = 692
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 65280
long backcolor = 0
borderstyle borderstyle = stylelowered!
end type

type pb_1 from picturebutton within w_openning_popup
integer x = 2610
integer y = 1520
integer width = 101
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean default = true
boolean originalsize = true
string picturename = "Exit!"
boolean map3dcolors = true
end type

event clicked;Close(parent)
end event

type p_2 from picture within w_openning_popup
integer x = 1632
integer y = 20
integer width = 1079
integer height = 756
string picturename = "OPENNING_RIGHT.JPG"
boolean focusrectangle = false
end type

type p_1 from picture within w_openning_popup
integer x = 23
integer y = 20
integer width = 1600
integer height = 1596
string picturename = "Openning.jpg"
boolean focusrectangle = false
end type

