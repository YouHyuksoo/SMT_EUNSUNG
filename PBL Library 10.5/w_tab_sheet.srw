HA$PBExportHeader$w_tab_sheet.srw
forward
global type w_tab_sheet from window
end type
type tab_1 from tab within w_tab_sheet
end type
type tab_1 from tab within w_tab_sheet
end type
end forward

global type w_tab_sheet from window
integer width = 3141
integer height = 204
windowtype windowtype = popup!
long backcolor = 15780518
string icon = "AppIcon!"
tab_1 tab_1
end type
global w_tab_sheet w_tab_sheet

type prototypes
Function ulong SetCapture(ulong hWnd) Library "USER32.DLL"
Function BOOLEAN ReleaseCapture() Library "USER32.DLL"
end prototypes

type variables
Boolean ib_mousecaptured
end variables

forward prototypes
public function integer of_capturemouse ()
public function integer of_releasemouse ()
public function boolean of_ismousecaptured ()
end prototypes

public function integer of_capturemouse ();
if of_ismousecaptured() then Return -1

SetCapture(handle(this))

ib_mousecaptured = TRUE

return 1
end function

public function integer of_releasemouse ();
if NOT of_ismousecaptured() then return -1

	ReleaseCapture()
	ib_mousecaptured = FALSE

Return 1
end function

public function boolean of_ismousecaptured ();return ib_mousecaptured
end function

on w_tab_sheet.create
this.tab_1=create tab_1
this.Control[]={this.tab_1}
end on

on w_tab_sheet.destroy
destroy(this.tab_1)
end on

event resize;tab_1.width = this.width - tab_1.x

end event

event mousemove;//if NOT of_ismousecaptured() then 
//	
//	of_capturemouse()
//	SetRedraw(true)
//		
//else
//	
//	if xpos < 0 or ypos < 0 or xpos > width or ypos > height then
//	
//		of_releasemouse()
//		
//         this.height = 0
//		
//	end if
//
//end if
//
//
end event

type tab_1 from tab within w_tab_sheet
event mousemove pbm_mousemove
integer width = 3122
integer height = 144
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 134217730
boolean raggedright = true
boolean focusonbuttondown = true
boolean powertips = true
boolean boldselectedtext = true
boolean createondemand = true
integer selectedtab = 1
end type

event mousemove;//if NOT of_ismousecaptured() then 
//	
//	of_capturemouse()
//	SetRedraw(true)
//		
//else
//	
//	if xpos < 0 or ypos < 0 or xpos > width or ypos > height then
//	
//		of_releasemouse()
//         w_tab_sheet.height = 0
//
//	end if
//
//end if
end event

event selectionchanged;uo_tabpage tabpage

if newindex < 1 then return

tabpage = this.Control[newindex]

if isvalid(tabpage.ivw_openedwindow) then 
	Opensheet( tabpage.ivw_openedwindow  , w_main_frame , Gvi_opensheet_position , Layered!)
end if 

w_tab_sheet.bringtotop = true



end event

event doubleclicked;uo_tabpage tabpage
f_msg_mdi_help(string(index))
if index < 1 then return

tabpage = this.Control[index]

if isvalid(tabpage.ivw_openedwindow) then 
	Opensheet( tabpage.ivw_openedwindow  , w_main_frame , Gvi_opensheet_position , Layered!)
end if 

end event

event clicked;uo_tabpage tabpage

if this.Selectedtab < 1 then return

tabpage = this.Control[this.Selectedtab]

if isvalid(tabpage.ivw_openedwindow) then 
	Opensheet( tabpage.ivw_openedwindow  , w_main_frame , Gvi_opensheet_position , Layered!)
end if 
w_tab_sheet.bringtotop = true
end event

