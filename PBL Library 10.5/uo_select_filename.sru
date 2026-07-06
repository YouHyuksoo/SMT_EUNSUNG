HA$PBExportHeader$uo_select_filename.sru
forward
global type uo_select_filename from userobject
end type
type cb_1 from so_commandbutton within uo_select_filename
end type
type sle_filename from so_singlelineedit within uo_select_filename
end type
end forward

global type uo_select_filename from userobject
integer width = 2437
integer height = 100
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
cb_1 cb_1
sle_filename sle_filename
end type
global uo_select_filename uo_select_filename

forward prototypes
public function string text ()
public subroutine settext (string arg_text)
end prototypes

public function string text ();return sle_filename.text
end function

public subroutine settext (string arg_text);sle_filename.text = arg_text
end subroutine

on uo_select_filename.create
this.cb_1=create cb_1
this.sle_filename=create sle_filename
this.Control[]={this.cb_1,&
this.sle_filename}
end on

on uo_select_filename.destroy
destroy(this.cb_1)
destroy(this.sle_filename)
end on

type cb_1 from so_commandbutton within uo_select_filename
integer x = 2085
integer width = 347
integer height = 92
integer taborder = 20
string text = "Select File"
end type

event clicked;call super::clicked;string docpath, docname[]

integer i, li_cnt, li_rtn, li_filenum

li_rtn = GetFileOpenName("Select File",  docpath, docname[], "PBL", &
   + "PBL Files (*.PBL),*.PBL," &
   + "All Files (*.*), *.*",  "", 18)

sle_filename.text = ""

IF li_rtn < 1 THEN return

li_cnt = Upperbound(docname)

// if only one file is picked, docpath contains the 

// path and file name

if li_cnt = 1 then

   sle_filename.text = string(docpath)

else

    return

end if


end event

type sle_filename from so_singlelineedit within uo_select_filename
integer x = 14
integer width = 2066
integer height = 88
integer taborder = 10
integer weight = 700
end type

