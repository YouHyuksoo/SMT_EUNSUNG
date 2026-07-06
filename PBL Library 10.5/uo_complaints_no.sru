HA$PBExportHeader$uo_complaints_no.sru
forward
global type uo_complaints_no from dropdownlistbox
end type
type st_vendor from structure within uo_complaints_no
end type
end forward

type st_vendor from structure
	string		vendor_name
	string		vendor_name_eng
end type

global type uo_complaints_no from dropdownlistbox
integer width = 654
integer height = 692
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "Help!"
long textcolor = 33554432
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type
global uo_complaints_no uo_complaints_no

forward prototypes
public function string text ()
public subroutine settext (double arg_text)
end prototypes

public function string text ();RETURN THIS.TEXT
end function

public subroutine settext (double arg_text);THIS.SELECTITEM(THIS.ADDITEM(STRING(ARG_TEXT)))

end subroutine

on uo_complaints_no.create
end on

on uo_complaints_no.destroy
end on

