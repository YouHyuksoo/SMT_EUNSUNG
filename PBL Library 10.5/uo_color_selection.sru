HA$PBExportHeader$uo_color_selection.sru
$PBExportComments$Color selector, with SLEs and HScrollBars for R,G,B
forward
global type uo_color_selection from userobject
end type
type st_3 from statictext within uo_color_selection
end type
type st_2 from statictext within uo_color_selection
end type
type st_1 from statictext within uo_color_selection
end type
type hsb_green from hscrollbar within uo_color_selection
end type
type hsb_red from hscrollbar within uo_color_selection
end type
type sle_blue from singlelineedit within uo_color_selection
end type
type sle_green from singlelineedit within uo_color_selection
end type
type sle_red from singlelineedit within uo_color_selection
end type
type hsb_blue from hscrollbar within uo_color_selection
end type
type rr_1 from roundrectangle within uo_color_selection
end type
end forward

global type uo_color_selection from userobject
integer width = 754
integer height = 460
boolean border = true
long backcolor = 78682240
long tabtextcolor = 33554432
event color_changed pbm_custom01
st_3 st_3
st_2 st_2
st_1 st_1
hsb_green hsb_green
hsb_red hsb_red
sle_blue sle_blue
sle_green sle_green
sle_red sle_red
hsb_blue hsb_blue
rr_1 rr_1
end type
global uo_color_selection uo_color_selection

type variables
int   ii_r, ii_g, ii_b
end variables

forward prototypes
public subroutine uf_set_rgb (long al_rgb)
public function long uf_get_rgb ()
end prototypes

public subroutine uf_set_rgb (long al_rgb);//////////////////////////////////////////////////////////////////////
//
// Function: uf_set_rgb
//
// Purpose: initialize the RGB values on this user object to the
//				long value that is passed to this function
//
//	Scope: public
//
//	Arguments: al_rgb		the RGB value that you want to use to set
//								the RGB values on this user object
//
//	Returns: none
//
//////////////////////////////////////////////////////////////////////

// set the red color value
ii_r = Mod (al_rgb, 256)
al_rgb = al_rgb / 256

// set the green color value
ii_g = Mod (al_rgb, 256)
al_rgb = al_rgb / 256

// set the blue color value
ii_b = Mod (al_rgb, 256)

// set the fill color on the 'test color palette' to the current RGB value
rr_1.fillcolor = rgb (ii_r, ii_g, ii_b)

// set the horizontal scrollbars to the correct positions
hsb_red.position = ii_r
hsb_green.position = ii_g
hsb_blue.position = ii_b

// set the red, green, and blue text values to the correct values.
sle_red.text = String (ii_r)
sle_green.text = String (ii_g)
sle_blue.text = String (ii_b)


end subroutine

public function long uf_get_rgb ();//////////////////////////////////////////////////////////////////////
//
// Function: uf_get_rgb
//
// Purpose: returns the current RGB value for this user object
//
//	Scope: public
//
//	Arguments: none	
//
//	Returns: long		the current RGB value for this user object
//
//////////////////////////////////////////////////////////////////////

return RGB (ii_r, ii_g, ii_b)
end function

on uo_color_selection.create
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.hsb_green=create hsb_green
this.hsb_red=create hsb_red
this.sle_blue=create sle_blue
this.sle_green=create sle_green
this.sle_red=create sle_red
this.hsb_blue=create hsb_blue
this.rr_1=create rr_1
this.Control[]={this.st_3,&
this.st_2,&
this.st_1,&
this.hsb_green,&
this.hsb_red,&
this.sle_blue,&
this.sle_green,&
this.sle_red,&
this.hsb_blue,&
this.rr_1}
end on

on uo_color_selection.destroy
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.hsb_green)
destroy(this.hsb_red)
destroy(this.sle_blue)
destroy(this.sle_green)
destroy(this.sle_red)
destroy(this.hsb_blue)
destroy(this.rr_1)
end on

type st_3 from statictext within uo_color_selection
integer x = 41
integer y = 324
integer width = 151
integer height = 72
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 16711680
long backcolor = 78682240
boolean enabled = false
string text = "Blue:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within uo_color_selection
integer x = 9
integer y = 228
integer width = 192
integer height = 72
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 65280
long backcolor = 78682240
boolean enabled = false
string text = "Green:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within uo_color_selection
integer x = 69
integer y = 136
integer width = 133
integer height = 72
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 255
long backcolor = 78682240
boolean enabled = false
string text = "Red:"
alignment alignment = right!
boolean focusrectangle = false
end type

type hsb_green from hscrollbar within uo_color_selection
integer x = 393
integer y = 232
integer width = 311
integer height = 44
integer taborder = 30
integer maxposition = 255
end type

on pageright;//////////////////////////////////////////////////////////////////////
// increment the green color value by 50
//////////////////////////////////////////////////////////////////////

if ii_g > 205 then
	ii_g = 255
else
	ii_g = ii_g + 50
end if
sle_green.text = String (ii_g)
this.position = ii_g

rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)
parent.TriggerEvent ("color_changed")
end on

on lineleft;/////////////////////////////////////////////////////////////////////
// Decrement the green color value by 10
/////////////////////////////////////////////////////////////////////

if ii_g < 10 then
	ii_g = 0
else
	ii_g = ii_g - 10
end if
sle_green.text = String (ii_g)
this.position = ii_g
rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)

parent.TriggerEvent ('color_changed')
end on

on lineright;//////////////////////////////////////////////////////////////////////
// increment the green color value by 10
//////////////////////////////////////////////////////////////////////

if ii_g > 245 then
	ii_g = 255
else
	ii_g = ii_g + 10
end if
sle_green.text = String (ii_g)
this.position = ii_g

rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)
parent.TriggerEvent ("color_changed")
end on

on moved;/////////////////////////////////////////////////////////////////////
// Change the green color value based on current position of scrollbar
/////////////////////////////////////////////////////////////////////

ii_g = this.position
sle_green.text = String (ii_g)

// Change the test palette color
rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)
parent.TriggerEvent ('color_changed')
end on

on pageleft;//////////////////////////////////////////////////////////////////////
// Decrement the green color value by 50
//////////////////////////////////////////////////////////////////////

if ii_g < 50 then
	ii_g = 0
else
	ii_g = ii_g - 50
end if
sle_green.text = String (ii_g)
this.position = ii_g

rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)
parent.TriggerEvent ("color_changed")
end on

type hsb_red from hscrollbar within uo_color_selection
integer x = 393
integer y = 140
integer width = 311
integer height = 44
integer taborder = 10
integer maxposition = 255
end type

on lineright;//////////////////////////////////////////////////////////////////////
// increment the red color value by 10
//////////////////////////////////////////////////////////////////////

if ii_r > 245 then
	ii_r = 255
else
	ii_r = ii_r + 10
end if
sle_red.text = String (ii_r)
this.position = ii_r

rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)
parent.TriggerEvent ("color_changed")
end on

on pageleft;//////////////////////////////////////////////////////////////////////
// Decrement the red color value by 50
//////////////////////////////////////////////////////////////////////

if ii_r < 50 then
	ii_r = 0
else
	ii_r = ii_r - 50
end if
sle_red.text = String (ii_r)
this.position = ii_r

rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)
parent.TriggerEvent ("color_changed")
end on

on lineleft;/////////////////////////////////////////////////////////////////////
// Decrement the red color value by 10
/////////////////////////////////////////////////////////////////////

if ii_r < 10 then
	ii_r = 0
else
	ii_r = ii_r - 10
end if
sle_red.text = String (ii_r)
this.position = ii_r
rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)

parent.TriggerEvent ('color_changed')
end on

on moved;/////////////////////////////////////////////////////////////////////
// Change the red color value based on current position of scrollbar
/////////////////////////////////////////////////////////////////////

ii_r = this.position
sle_red.text = String (ii_r)

// Change the test palette color
rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)
parent.TriggerEvent ('color_changed')
end on

on pageright;//////////////////////////////////////////////////////////////////////
// increment the red color value by 50
//////////////////////////////////////////////////////////////////////

if ii_r > 205 then
	ii_r = 255
else
	ii_r = ii_r + 50
end if
sle_red.text = String (ii_r)
this.position = ii_r

rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)
parent.TriggerEvent ("color_changed")
end on

type sle_blue from singlelineedit within uo_color_selection
integer x = 224
integer y = 324
integer width = 151
integer height = 72
integer taborder = 60
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string pointer = "arrow!"
long textcolor = 16777215
long backcolor = 16711680
string text = "0"
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

on getfocus;// select the text when this single line edit get focus

this.SelectText (1, Len (this.text))
end on

on modified;//////////////////////////////////////////////////////////////////////
// Change the blue color value based on the data entered
//////////////////////////////////////////////////////////////////////

int	li_new_value


if IsNumber (this.text) then
	li_new_value = Integer (this.text)
	if li_new_value < 0 or li_new_value > 255 then
		Beep (1)
		this.text = String (ii_b)
	else
		ii_b = li_new_value
		rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)
		hsb_blue.position = ii_b
		parent.TriggerEvent ("color_changed")
	end if
else
	Beep (1)
	this.text = String (ii_b)
end if


end on

type sle_green from singlelineedit within uo_color_selection
integer x = 224
integer y = 228
integer width = 151
integer height = 76
integer taborder = 40
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string pointer = "arrow!"
long textcolor = 16777215
long backcolor = 65280
string text = "0"
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

on getfocus;// select the text when this single line edit get focus

this.SelectText (1, Len (this.text))
end on

on modified;//////////////////////////////////////////////////////////////////////
// Change the green color value based on the data entered
//////////////////////////////////////////////////////////////////////

int	li_new_value


if IsNumber (this.text) then
	li_new_value = Integer (this.text)
	if li_new_value < 0 or li_new_value > 255 then
		Beep (1)
		this.text = String (ii_g)
	else
		ii_g = li_new_value
		rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)
		hsb_green.position = ii_g
		parent.TriggerEvent ("color_changed")
	end if
else
	Beep (1)
	this.text = String (ii_g)
end if


end on

type sle_red from singlelineedit within uo_color_selection
integer x = 224
integer y = 136
integer width = 151
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string pointer = "arrow!"
long textcolor = 16777215
long backcolor = 255
string text = "0"
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

on getfocus;// select the text when this single line edit get focus

this.SelectText (1, Len (this.text))
end on

on modified;//////////////////////////////////////////////////////////////////////
// Change the red color value based on the data entered
//////////////////////////////////////////////////////////////////////

int	li_new_value


if IsNumber (this.text) then
	li_new_value = Integer (this.text)
	if li_new_value < 0 or li_new_value > 255 then
		Beep (1)
		this.text = String (ii_r)
	else
		ii_r = li_new_value
		rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)
		hsb_red.position = ii_r
		parent.TriggerEvent ("color_changed")
	end if
else
	Beep (1)
	this.text = String (ii_r)
end if


end on

type hsb_blue from hscrollbar within uo_color_selection
integer x = 389
integer y = 328
integer width = 311
integer height = 44
integer taborder = 50
integer maxposition = 255
end type

on pageright;//////////////////////////////////////////////////////////////////////
// increment the blue color value by 50
//////////////////////////////////////////////////////////////////////

if ii_b > 205 then
	ii_b = 255
else
	ii_b = ii_b + 50
end if
sle_blue.text = String (ii_b)
this.position = ii_b

rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)
parent.TriggerEvent ("color_changed")
end on

on lineleft;/////////////////////////////////////////////////////////////////////
// Decrement the blue color value by 10
/////////////////////////////////////////////////////////////////////

if ii_b < 10 then
	ii_b = 0
else
	ii_b = ii_b - 10
end if
sle_blue.text = String (ii_b)
this.position = ii_b

rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)
parent.TriggerEvent ('color_changed')
end on

on lineright;//////////////////////////////////////////////////////////////////////
// increment the blue color value by 10
//////////////////////////////////////////////////////////////////////

if ii_b > 245 then
	ii_b = 255
else
	ii_b = ii_b + 10
end if
sle_blue.text = String (ii_b)
this.position = ii_b

rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)
parent.TriggerEvent ("color_changed")
end on

on moved;/////////////////////////////////////////////////////////////////////
// Change the blue color value based on current position of scrollbar
/////////////////////////////////////////////////////////////////////

ii_b = this.position
sle_blue.text = String (ii_b)

// Change the test palette color
rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)
parent.TriggerEvent ('color_changed')
end on

on pageleft;//////////////////////////////////////////////////////////////////////
// Decrement the blue color value by 50
//////////////////////////////////////////////////////////////////////

if ii_b < 50 then
	ii_b = 0
else
	ii_b = ii_b - 50
end if
sle_blue.text = String (ii_b)
this.position = ii_b

rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)
parent.TriggerEvent ("color_changed")
end on

type rr_1 from roundrectangle within uo_color_selection
long linecolor = 1090519039
integer linethickness = 4
long fillcolor = 16777215
integer x = 224
integer y = 24
integer width = 274
integer height = 76
integer cornerheight = 445
integer cornerwidth = 40
end type

