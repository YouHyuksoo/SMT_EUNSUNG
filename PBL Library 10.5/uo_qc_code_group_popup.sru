HA$PBExportHeader$uo_qc_code_group_popup.sru
forward
global type uo_qc_code_group_popup from dropdownlistbox
end type
type st_vendor from structure within uo_qc_code_group_popup
end type
end forward

type st_vendor from structure
	string		vendor_name
	string		vendor_name_eng
end type

global type uo_qc_code_group_popup from dropdownlistbox
integer width = 850
integer height = 692
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean allowedit = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type
global uo_qc_code_group_popup uo_qc_code_group_popup

forward prototypes
public function string text ()
public subroutine settext (double arg_text)
end prototypes

public function string text ();RETURN THIS.TEXT
end function

public subroutine settext (double arg_text);THIS.SELECTITEM(THIS.ADDITEM(STRING(ARG_TEXT)))

end subroutine

on uo_qc_code_group_popup.create
end on

on uo_qc_code_group_popup.destroy
end on

