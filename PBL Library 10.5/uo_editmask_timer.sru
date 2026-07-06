HA$PBExportHeader$uo_editmask_timer.sru
forward
global type uo_editmask_timer from userobject
end type
type em_1 from editmask within uo_editmask_timer
end type
end forward

global type uo_editmask_timer from userobject
integer width = 603
integer height = 80
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
em_1 em_1
end type
global uo_editmask_timer uo_editmask_timer

forward prototypes
public subroutine settext (string arg_text)
public function datetime getdate ()
end prototypes

public subroutine settext (string arg_text);em_1.text = arg_text
end subroutine

public function datetime getdate ();return datetime( date(mid(em_1.text,1,10)))
end function

on uo_editmask_timer.create
this.em_1=create em_1
this.Control[]={this.em_1}
end on

on uo_editmask_timer.destroy
destroy(this.em_1)
end on

type em_1 from editmask within uo_editmask_timer
integer width = 599
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datetimemask!
string mask = "yyyy/mm/dd hh:mm:ss"
end type

