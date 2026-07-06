HA$PBExportHeader$st_uo_transparent.sru
forward
global type st_uo_transparent from statictext
end type
end forward

global type st_uo_transparent from statictext
integer width = 443
integer height = 100
integer textsize = -8
fontcharset fontcharset = ansi!
string facename = "Tahoma"
string text = "Text"
alignment alignment = center!
boolean focusrectangle = false
event ue_paint pbm_paint
end type
global st_uo_transparent st_uo_transparent

type variables
boolean ib_Painting
end variables

event ue_paint;if IsValid(this) then

	if ib_Painting then return 0
	ib_Painting = TRUE
	this.visible = false
	      do while yield() ; loop
	this.visible = true
	ib_painting=false

end if

return 0
end event

event constructor;call super::constructor;this.BackColor = 2^29
end event

on st_uo_transparent.create
end on

on st_uo_transparent.destroy
end on

