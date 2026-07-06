HA$PBExportHeader$w_web_browser.srw
forward
global type w_web_browser from w_main_root
end type
type ole_web from olecustomcontrol within w_web_browser
end type
type pb_goto from so_picturebutton within w_web_browser
end type
type pb_2 from so_picturebutton within w_web_browser
end type
type pb_3 from so_picturebutton within w_web_browser
end type
type pb_4 from so_picturebutton within w_web_browser
end type
type pb_next from so_picturebutton within w_web_browser
end type
type pb_6 from so_picturebutton within w_web_browser
end type
type ddlb_url from so_dropdownlistbox within w_web_browser
end type
type hpb_progress from hprogressbar within w_web_browser
end type
type pb_1 from picturebutton within w_web_browser
end type
type cb_1 from commandbutton within w_web_browser
end type
end forward

global type w_web_browser from w_main_root
string title = "Internet Browser"
ole_web ole_web
pb_goto pb_goto
pb_2 pb_2
pb_3 pb_3
pb_4 pb_4
pb_next pb_next
pb_6 pb_6
ddlb_url ddlb_url
hpb_progress hpb_progress
pb_1 pb_1
cb_1 cb_1
end type
global w_web_browser w_web_browser

on w_web_browser.create
int iCurrent
call super::create
this.ole_web=create ole_web
this.pb_goto=create pb_goto
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_4=create pb_4
this.pb_next=create pb_next
this.pb_6=create pb_6
this.ddlb_url=create ddlb_url
this.hpb_progress=create hpb_progress
this.pb_1=create pb_1
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ole_web
this.Control[iCurrent+2]=this.pb_goto
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.pb_3
this.Control[iCurrent+5]=this.pb_4
this.Control[iCurrent+6]=this.pb_next
this.Control[iCurrent+7]=this.pb_6
this.Control[iCurrent+8]=this.ddlb_url
this.Control[iCurrent+9]=this.hpb_progress
this.Control[iCurrent+10]=this.pb_1
this.Control[iCurrent+11]=this.cb_1
end on

on w_web_browser.destroy
call super::destroy
destroy(this.ole_web)
destroy(this.pb_goto)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.pb_next)
destroy(this.pb_6)
destroy(this.ddlb_url)
destroy(this.hpb_progress)
destroy(this.pb_1)
destroy(this.cb_1)
end on

event resize;call super::resize;ole_web.Width = newwidth
ole_web.height = newheight - ole_web.y

ddlb_url.width = newwidth - ( hpb_progress.width + pb_goto.width )
hpb_progress.x = ddlb_url.x + ddlb_url.width
pb_goto.x = hpb_progress.x + hpb_progress.width
end event

type dw_5 from w_main_root`dw_5 within w_web_browser
integer y = 220
end type

type dw_4 from w_main_root`dw_4 within w_web_browser
integer y = 220
end type

type dw_3 from w_main_root`dw_3 within w_web_browser
integer y = 220
end type

type dw_2 from w_main_root`dw_2 within w_web_browser
integer y = 220
end type

type dw_1 from w_main_root`dw_1 within w_web_browser
integer y = 220
end type

type ole_web from olecustomcontrol within w_web_browser
event statustextchange ( string text )
event progresschange ( long progress,  long progressmax )
event commandstatechange ( long command,  boolean enable )
event downloadbegin ( )
event downloadcomplete ( )
event titlechange ( string text )
event propertychange ( string szproperty )
event beforenavigate2 ( oleobject pdisp,  any url,  any flags,  any targetframename,  any postdata,  any headers,  ref boolean cancel )
event newwindow2 ( ref oleobject ppdisp,  ref boolean cancel )
event navigatecomplete2 ( oleobject pdisp,  any url )
event documentcomplete ( oleobject pdisp,  any url )
event onquit ( )
event onvisible ( boolean ocx_visible )
event ontoolbar ( boolean toolbar )
event onmenubar ( boolean menubar )
event onstatusbar ( boolean statusbar )
event onfullscreen ( boolean fullscreen )
event ontheatermode ( boolean theatermode )
event windowsetresizable ( boolean resizable )
event windowsetleft ( long left )
event windowsettop ( long top )
event windowsetwidth ( long ocx_width )
event windowsetheight ( long ocx_height )
event windowclosing ( boolean ischildwindow,  ref boolean cancel )
event clienttohostwindow ( ref long cx,  ref long cy )
event setsecurelockicon ( long securelockicon )
event filedownload ( ref boolean cancel )
event navigateerror ( oleobject pdisp,  any url,  any frame,  any statuscode,  ref boolean cancel )
event printtemplateinstantiation ( oleobject pdisp )
event printtemplateteardown ( oleobject pdisp )
event updatepagestatus ( oleobject pdisp,  any npage,  any fdone )
event privacyimpactedstatechange ( boolean bimpacted )
integer x = 5
integer y = 216
integer width = 2633
integer height = 1236
integer taborder = 20
boolean bringtotop = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
string binarykey = "w_web_browser.win"
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
end type

event statustextchange(string text);f_msg_mdi_help( text )
end event

event progresschange(long progress, long progressmax);hpb_progress.setrange(0 , progressmax )
hpb_progress.position = Progress
end event

event titlechange(string text);Parent.title = text
end event

event beforenavigate2(oleobject pdisp, any url, any flags, any targetframename, any postdata, any headers, ref boolean cancel);ddlb_url.text = url
end event

event documentcomplete(oleobject pdisp, any url);f_msg_mdi_help("Document Complete "+ url )
end event

event navigateerror(oleobject pdisp, any url, any frame, any statuscode, ref boolean cancel);f_msg_mdi_help( string(statuscode))
end event

type pb_goto from so_picturebutton within w_web_browser
integer x = 2542
integer y = 12
integer width = 101
integer height = 88
integer taborder = 50
boolean bringtotop = true
boolean default = true
boolean originalsize = false
string picturename = "Globals!"
string powertiptext = "Go to"
end type

event clicked;call super::clicked;ole_web.Object.Navigate( ddlb_url.text)
end event

type pb_2 from so_picturebutton within w_web_browser
integer x = 14
integer y = 112
integer width = 101
integer height = 88
integer taborder = 60
boolean bringtotop = true
boolean originalsize = false
string picturename = "Continue!"
string powertiptext = "Refresh"
end type

event clicked;call super::clicked;if ddlb_url.text = '' then 
else
	ole_web.Object.Refresh()
end if
end event

type pb_3 from so_picturebutton within w_web_browser
integer x = 114
integer y = 112
integer width = 101
integer height = 88
integer taborder = 60
boolean bringtotop = true
boolean originalsize = false
string picturename = "RetrieveCancel!"
string powertiptext = "Stop"
end type

event clicked;call super::clicked;ole_web.Object.Stop()
end event

type pb_4 from so_picturebutton within w_web_browser
integer x = 224
integer y = 112
integer width = 101
integer height = 88
integer taborder = 70
boolean bringtotop = true
boolean originalsize = false
string picturename = "Prior!"
string powertiptext = "Prior"
end type

event clicked;call super::clicked;ole_web.Object.Goback()
end event

type pb_next from so_picturebutton within w_web_browser
integer x = 329
integer y = 112
integer width = 101
integer height = 88
integer taborder = 80
boolean bringtotop = true
boolean originalsize = false
string picturename = "Next!"
string powertiptext = "Next"
end type

event clicked;call super::clicked;ole_web.Object.GoForward()
end event

type pb_6 from so_picturebutton within w_web_browser
integer x = 430
integer y = 112
integer width = 101
integer height = 88
integer taborder = 80
boolean bringtotop = true
boolean originalsize = false
string picturename = "Library!"
string powertiptext = "Home"
end type

event clicked;call super::clicked;ole_web.Object.Gohome()
end event

type ddlb_url from so_dropdownlistbox within w_web_browser
integer x = 151
integer y = 12
integer width = 1952
integer height = 1120
integer taborder = 60
boolean bringtotop = true
boolean allowedit = true
boolean autohscroll = true
boolean hscrollbar = true
boolean vscrollbar = true
string item[] = {"http://www.daum.net","http://gsc.cov-net.com:5800","http://www.jisheng.co.kr"}
end type

event selectionchanged;call super::selectionchanged;pb_goto.triggerevent(clicked!)
end event

type hpb_progress from hprogressbar within w_web_browser
integer x = 2112
integer y = 20
integer width = 425
integer height = 72
boolean bringtotop = true
end type

type pb_1 from picturebutton within w_web_browser
integer x = 18
integer y = 8
integer width = 101
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean originalsize = true
string picturename = "TreeView!"
alignment htextalign = left!
end type

event clicked;string 	ls_item , is_path
long		ll_total, i
string	ls_full, named
int		file_ok


file_ok = GetFileOpenName("Select File", ls_full, named, "XLS", "Excel Files (*.XLS),*.XLS")
if file_ok <> 1 then
	return
end if

is_path			=	left(ls_full, len(ls_full) - len(named))

if is_path = "" then 
	f_msgbox(156)
	//("$$HEX2$$55d678c7$$ENDHEX$$","$$HEX15$$54d67cc7200088c794b2200004c758ce7cb9200085c725b858d538c194c6$$ENDHEX$$...!")
else
	ddlb_url.text	=	is_path+named
     ddlb_url.triggerevent( selectionchanged!)
end if


end event

type cb_1 from commandbutton within w_web_browser
integer x = 544
integer y = 108
integer width = 402
integer height = 92
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "none"
end type

event clicked;Int rtn
in_inet = create n_inet
in_ir   = create n_ir

rtn = in_inet.geturl( 'http://www.getanyip.com/?q=ip' , in_ir )

if rtn = 0 then 
	Messagebox("Notify" ,  "End of file; too many rows" )
elseif rtn = -1  then  
	Messagebox("Notify" ,  "No rows" )
elseif rtn = -2  then 
	Messagebox("Notify" , "Empty file" )
elseif rtn = -3  then 
	Messagebox("Notify" ,  "Invalid argument" )
elseif rtn = -4  then 
	Messagebox("Notify" ,  "Invalid input" )
elseif rtn = -5  then 
	Messagebox("Notify" ,  "Could not open the file" )
elseif rtn = -6  then 
	Messagebox("Notify" ,  "Could not close the file" )
elseif rtn = -7  then 
	Messagebox("Notify" ,  "Error reading the text" )
elseif rtn = -8  then 
	Messagebox("Notify" ,  "Not a TXT file" )
elseif rtn = -9  then 
	Messagebox("Notify" ,  "The user canceled the import" )
elseif rtn = -10 then 
	Messagebox("Notify" , "Unsupported dBase file format (not version 2 or 3)" )
end if 

end event


Start of PowerBuilder Binary Data Section : Do NOT Edit
0Ew_web_browser.bin 
2400000a00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff00000001000000000000000000000000000000000000000000000000000000002992260001c8041400000003000001800000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000102001affffffff00000002ffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000009c00000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000001001affffffffffffffff000000038856f96111d0340ac0006ba9a205d74f000000002992260001c804142992260001c80414000000000000000000000000004f00430054004e004e00450053005400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000030000009c000000000000000100000002fffffffe0000000400000005fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
28ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000004c00003b8800001ff00000000000000000000000000000000000000000000000000000004c0000000000000000000000010057d0e011cf3573000869ae62122e2b00000008000000000000004c0002140100000000000000c0460000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004c00003b8800001ff00000000000000000000000000000000000000000000000000000004c0000000000000000000000010057d0e011cf3573000869ae62122e2b00000008000000000000004c0002140100000000000000c0460000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1Ew_web_browser.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
