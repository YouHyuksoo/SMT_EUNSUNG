HA$PBExportHeader$w_zetprint.srw
$PBExportComments$printer Module
forward
global type w_zetprint from w_popup_root
end type
type em_top from so_editmask within w_zetprint
end type
type em_rgt from so_editmask within w_zetprint
end type
type cb_printset from so_commandbutton within w_zetprint
end type
type st_7 from so_statictext within w_zetprint
end type
type rb_page from so_radiobutton within w_zetprint
end type
type rb_2 from so_radiobutton within w_zetprint
end type
type rb_1 from so_radiobutton within w_zetprint
end type
type sle_pages from so_singlelineedit within w_zetprint
end type
type st_4 from so_statictext within w_zetprint
end type
type st_5 from so_statictext within w_zetprint
end type
type cb_4 from so_commandbutton within w_zetprint
end type
type cb_print from so_commandbutton within w_zetprint
end type
type st_8 from so_statictext within w_zetprint
end type
type em_copies from so_editmask within w_zetprint
end type
type em_botm from so_editmask within w_zetprint
end type
type em_lft from so_editmask within w_zetprint
end type
type ddlb_type from so_dropdownlistbox within w_zetprint
end type
type st_9 from so_statictext within w_zetprint
end type
type st_11 from so_statictext within w_zetprint
end type
type ddlb_paper from so_dropdownlistbox within w_zetprint
end type
type st_12 from so_statictext within w_zetprint
end type
type st_13 from so_statictext within w_zetprint
end type
type gb_3 from so_groupbox within w_zetprint
end type
type gb_4 from so_groupbox within w_zetprint
end type
type gb_5 from so_groupbox within w_zetprint
end type
type cb_cancel from so_commandbutton within w_zetprint
end type
type ddplb_printers from dropdownpicturelistbox within w_zetprint
end type
type st_1 from so_statictext within w_zetprint
end type
type sle_port from so_singlelineedit within w_zetprint
end type
type st_2 from so_statictext within w_zetprint
end type
type sle_driver from so_singlelineedit within w_zetprint
end type
type p_1 from picture within w_zetprint
end type
type pb_1 from picturebutton within w_zetprint
end type
type pb_2 from picturebutton within w_zetprint
end type
type pb_3 from picturebutton within w_zetprint
end type
type pb_4 from picturebutton within w_zetprint
end type
type st_3 from so_statictext within w_zetprint
end type
type hsb_1 from hscrollbar within w_zetprint
end type
type st_6 from so_statictext within w_zetprint
end type
type gb_1 from so_groupbox within w_zetprint
end type
type gb_2 from so_groupbox within w_zetprint
end type
end forward

global type w_zetprint from w_popup_root
integer width = 2802
integer height = 1708
boolean minbox = true
windowtype windowtype = popup!
boolean contexthelp = false
em_top em_top
em_rgt em_rgt
cb_printset cb_printset
st_7 st_7
rb_page rb_page
rb_2 rb_2
rb_1 rb_1
sle_pages sle_pages
st_4 st_4
st_5 st_5
cb_4 cb_4
cb_print cb_print
st_8 st_8
em_copies em_copies
em_botm em_botm
em_lft em_lft
ddlb_type ddlb_type
st_9 st_9
st_11 st_11
ddlb_paper ddlb_paper
st_12 st_12
st_13 st_13
gb_3 gb_3
gb_4 gb_4
gb_5 gb_5
cb_cancel cb_cancel
ddplb_printers ddplb_printers
st_1 st_1
sle_port sle_port
st_2 st_2
sle_driver sle_driver
p_1 p_1
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
pb_4 pb_4
st_3 st_3
hsb_1 hsb_1
st_6 st_6
gb_1 gb_1
gb_2 gb_2
end type
global w_zetprint w_zetprint

type variables
datawindow dw_target
long mpage
long nxt = 0, c =1
long last_p
string dws_zoom
end variables

on w_zetprint.create
int iCurrent
call super::create
this.em_top=create em_top
this.em_rgt=create em_rgt
this.cb_printset=create cb_printset
this.st_7=create st_7
this.rb_page=create rb_page
this.rb_2=create rb_2
this.rb_1=create rb_1
this.sle_pages=create sle_pages
this.st_4=create st_4
this.st_5=create st_5
this.cb_4=create cb_4
this.cb_print=create cb_print
this.st_8=create st_8
this.em_copies=create em_copies
this.em_botm=create em_botm
this.em_lft=create em_lft
this.ddlb_type=create ddlb_type
this.st_9=create st_9
this.st_11=create st_11
this.ddlb_paper=create ddlb_paper
this.st_12=create st_12
this.st_13=create st_13
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_5=create gb_5
this.cb_cancel=create cb_cancel
this.ddplb_printers=create ddplb_printers
this.st_1=create st_1
this.sle_port=create sle_port
this.st_2=create st_2
this.sle_driver=create sle_driver
this.p_1=create p_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_4=create pb_4
this.st_3=create st_3
this.hsb_1=create hsb_1
this.st_6=create st_6
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_top
this.Control[iCurrent+2]=this.em_rgt
this.Control[iCurrent+3]=this.cb_printset
this.Control[iCurrent+4]=this.st_7
this.Control[iCurrent+5]=this.rb_page
this.Control[iCurrent+6]=this.rb_2
this.Control[iCurrent+7]=this.rb_1
this.Control[iCurrent+8]=this.sle_pages
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.st_5
this.Control[iCurrent+11]=this.cb_4
this.Control[iCurrent+12]=this.cb_print
this.Control[iCurrent+13]=this.st_8
this.Control[iCurrent+14]=this.em_copies
this.Control[iCurrent+15]=this.em_botm
this.Control[iCurrent+16]=this.em_lft
this.Control[iCurrent+17]=this.ddlb_type
this.Control[iCurrent+18]=this.st_9
this.Control[iCurrent+19]=this.st_11
this.Control[iCurrent+20]=this.ddlb_paper
this.Control[iCurrent+21]=this.st_12
this.Control[iCurrent+22]=this.st_13
this.Control[iCurrent+23]=this.gb_3
this.Control[iCurrent+24]=this.gb_4
this.Control[iCurrent+25]=this.gb_5
this.Control[iCurrent+26]=this.cb_cancel
this.Control[iCurrent+27]=this.ddplb_printers
this.Control[iCurrent+28]=this.st_1
this.Control[iCurrent+29]=this.sle_port
this.Control[iCurrent+30]=this.st_2
this.Control[iCurrent+31]=this.sle_driver
this.Control[iCurrent+32]=this.p_1
this.Control[iCurrent+33]=this.pb_1
this.Control[iCurrent+34]=this.pb_2
this.Control[iCurrent+35]=this.pb_3
this.Control[iCurrent+36]=this.pb_4
this.Control[iCurrent+37]=this.st_3
this.Control[iCurrent+38]=this.hsb_1
this.Control[iCurrent+39]=this.st_6
this.Control[iCurrent+40]=this.gb_1
this.Control[iCurrent+41]=this.gb_2
end on

on w_zetprint.destroy
call super::destroy
destroy(this.em_top)
destroy(this.em_rgt)
destroy(this.cb_printset)
destroy(this.st_7)
destroy(this.rb_page)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.sle_pages)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.cb_4)
destroy(this.cb_print)
destroy(this.st_8)
destroy(this.em_copies)
destroy(this.em_botm)
destroy(this.em_lft)
destroy(this.ddlb_type)
destroy(this.st_9)
destroy(this.st_11)
destroy(this.ddlb_paper)
destroy(this.st_12)
destroy(this.st_13)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_5)
destroy(this.cb_cancel)
destroy(this.ddplb_printers)
destroy(this.st_1)
destroy(this.sle_port)
destroy(this.st_2)
destroy(this.sle_driver)
destroy(this.p_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.st_3)
destroy(this.hsb_1)
destroy(this.st_6)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;//==================================
// $$HEX8$$04d5b0b930d1200000ac38c824c630ae$$ENDHEX$$
//==================================
long ll_place, i, k 
string  ls_prntrs  ,  ls_left
String ls_name, ls_driver, ls_port, ls_temp
ddplb_printers.reset()

ls_prntrs  = PrintGetPrinters ( )
k = upperbound(control)

FOR i= k to 1  STEP -1  

      ll_place=pos (ls_prntrs, "~n" ) 
		
	 IF 	ll_place = 0 and ls_prntrs <> '' then 
		
		     ddplb_printers.additem( ls_prntrs , 1 )		
			 exit 
			  
	else

			ls_left = Left (ls_prntrs, ll_place - 1)
			ddplb_printers.additem( ls_left , 1 )
			ls_prntrs = Mid (ls_prntrs, ll_place + 1)		
			
	end if

	 if ls_prntrs = '' OR ISNULL(ls_prntrs)  then
		exit
	end if		
	
NEXT

ddplb_printers.selectitem(PrintGetPrinter(),0)

ls_prntrs = ''
ls_prntrs = ddplb_printers.text

ll_place=pos (ls_prntrs, "~t")
ls_name=left(ls_prntrs, ll_place -1)
PrintSetPrinter (ls_name)

ls_temp=mid(ls_prntrs, ll_place +1)
ll_place=pos (ls_temp, "~t")
ls_driver=left(ls_temp, ll_place -1)
ls_port=mid(ls_temp, ll_place +1)

sle_port.text=ls_port
sle_driver.text=ls_driver


//****************************************
//$$HEX18$$a8ba200008c7c4b3b0c6d0c51cc1200004d5b0b9b8d2200058d5e0ac90c758d594b22000$$ENDHEX$$DW$$HEX4$$44c7200020002000$$ENDHEX$$*
//Openwithparm(win,dw_1)$$HEX5$$3cc75cb82000acc0a9c6$$ENDHEX$$*
//****************************************
dw_target = message.powerobjectparm
if isValid(dw_target) then 
	
	if dw_target.Describe("DataWindow.Print.Preview") = '!' or dw_target.Describe("DataWindow.Print.Preview") = '?' then
	else
		dw_target.Modify("DataWindow.Print.Preview=yes")
		dw_target.Modify("DataWindow.Print.Preview.Rulers=yes")
	end if
	
else
	return 
end if

//***********************************
// $$HEX9$$a9c6c0c92000acc074c788c9200020c1ddd0$$ENDHEX$$
//***********************************
  string l
  
  l = dw_target.Describe("datawindow.print.paper.size")
  ddlb_paper.selectitem((long(l) + 1))
  
  if (long(l) + 1) = 1 then 
	 ddlb_paper.selectitem(1)
  end if
  
  ddlb_paper.triggerevent('selectionchanged')
//***********************************
// $$HEX9$$00ac5cb8200038c15cb8200020c1ddd02000$$ENDHEX$$
//***********************************
  l = dw_target.Describe("datawindow.print.orientation")
  ddlb_type.selectitem((long(l) + 1))
  
//***********************************
// $$HEX9$$f5bcacc060d5200018c2200020c1ddd02000$$ENDHEX$$
//***********************************
  l = dw_target.Describe("datawindow.print.copies")
  em_copies.text = l
  
//***********************************
// $$HEX5$$0cc9200020c1ddd02000$$ENDHEX$$
//***********************************
  l = dw_target.Describe("datawindow.zoom")
  dws_zoom = l
  
//***********************************
//$$HEX2$$ecc531bc$$ENDHEX$$
//***********************************
  l = dw_target.Describe("datawindow.print.margin.Top")
  em_top.text = l
  l = dw_target.Describe("datawindow.print.margin.Bottom")
  em_botm.text = l
  l = dw_target.Describe("datawindow.print.margin.Left")
  em_lft.text = l
  l = dw_target.Describe("datawindow.print.margin.Right")
  em_rgt.text = l
     
 //**********************************
 // $$HEX5$$9ccd25b8200094bc04c7$$ENDHEX$$
 //**********************************
  l = dw_target.Describe("datawindow.print.page.range")
  sle_pages.text = l

  l = '' 
  dw_target.Modify("datawindow.print.page.range = '" + l + "'" )
end event

event resize;RETURN
end event

event close;call super::close;if dw_target.Describe("DataWindow.Print.Preview") = '!' or &
	dw_target.Describe("DataWindow.Print.Preview") = '?' then
else
	dw_target.Modify("DataWindow.Print.Preview=NO")
end if

end event

type p_title from w_popup_root`p_title within w_zetprint
integer width = 2779
end type

type cb_sort from w_popup_root`cb_sort within w_zetprint
integer x = 567
integer y = 1788
end type

type cb_close from w_popup_root`cb_close within w_zetprint
boolean visible = true
integer x = 2423
integer y = 1420
integer width = 361
end type

event cb_close::clicked;call super::clicked;ChangeDirectory ( Gvs_default_directory )
end event

type st_msg from w_popup_root`st_msg within w_zetprint
boolean visible = true
integer y = 1540
integer width = 2802
integer height = 80
end type

type dw_1 from w_popup_root`dw_1 within w_zetprint
integer y = 1788
boolean titlebar = true
boolean maxbox = true
end type

event dw_1::printend;call super::printend;st_msg.text = string(pagesprinted) + ' Pages Printed'
end event

event dw_1::printpage;call super::printpage;st_msg.text = string(pagenumber)+ '/' + string(mpage) + ' Page'
end event

event dw_1::printstart;call super::printstart;mpage = pagesmax
end event

type dw_2 from w_popup_root`dw_2 within w_zetprint
integer x = 18
integer y = 1788
end type

type dw_3 from w_popup_root`dw_3 within w_zetprint
integer y = 1796
end type

type em_top from so_editmask within w_zetprint
event ue_change pbm_enchange
integer x = 933
integer y = 1076
integer width = 247
integer taborder = 40
boolean bringtotop = true
string pointer = "HyperLink!"
string mask = "####0"
string displaydata = ""
string minmax = "1~~9991"
end type

event ue_change;string l 
l = text 
dw_target.Modify("datawindow.print.margin.top = " + "'" + l + "'")
end event

event modified;string l 
l = text 
dw_target.Modify("datawindow.print.margin.top = " + "'" + l + "'")
end event

type em_rgt from so_editmask within w_zetprint
event ue_change pbm_enchange
integer x = 933
integer y = 1180
integer width = 247
integer taborder = 40
boolean bringtotop = true
string pointer = "HyperLink!"
string mask = "####0"
string displaydata = ""
string minmax = "1~~9991"
end type

event ue_change;string l 
l = text 
dw_target.Modify("datawindow.print.margin.right = " + "'" + l + "'")

end event

event modified;string l 
l = text 
dw_target.Modify("datawindow.print.margin.right = " + "'" + l + "'")

end event

type cb_printset from so_commandbutton within w_zetprint
integer x = 1984
integer y = 1420
integer width = 443
integer height = 100
integer taborder = 10
boolean bringtotop = true
string pointer = "HyperLink!"
string text = "Print(Set)"
end type

event clicked;//==========================================================================================
// table $$HEX34$$d0c52000f1b45db81cb4200070b374c7c0d0200008c7c4b3b0c6200030bc28c744c7200070c88cd658d5ecc5200074d5f9b2200030bc28c75cb8200070c815c85cd5e4b2$$ENDHEX$$.
// table name : jdwzoom
//
//==========================================================================================

String Active_window , Active_dw ,Vs_ot ,Vs_style , LVs_Window_zoom, Ls_Zoom
Active_window = selected_window.classname()
Active_dw = dw_target.classname()

select style , zoom_is , Window_zoom_is
  into :Vs_ot , :Ls_zoom , :LVs_Window_zoom
  from isys_DWZOOM
 where UPPER(window_name) = UPPER(:Active_window)
   and UPPER(DATAWINDOW_NAME)     = UPPER(:Active_dw) 
	and ORGANIZATION_ID  = :GVI_ORGANIZATION_ID;

IF  F_SQL_CHECK() < 1 THEN 
	RETURN
END IF

if sqlca.sqlnrows < 1 then 
else
	
	string s_var
	s_var = "Datawindow.Zoom=" + trim(ls_zoom)
	dw_target.Modify(s_var)

	Vs_style = "datawindow.print.orientation = "+Vs_ot
	dw_target.modify(Vs_style)
end if

cb_print.visible = true
this.visible =false

dw_target.print(false)

cb_print.visible = false
this.visible = true
timer(0)
cb_close.triggerevent('clicked')
end event

type st_7 from so_statictext within w_zetprint
integer x = 1842
integer y = 1064
integer width = 928
integer height = 200
boolean bringtotop = true
integer weight = 700
long textcolor = 8388736
boolean enabled = false
string text = "Please Insert Page Number Or Page Range.  ex ) 1, 3, 5-12"
end type

type rb_page from so_radiobutton within w_zetprint
integer x = 1851
integer y = 932
integer width = 407
integer height = 76
boolean bringtotop = true
integer weight = 700
string pointer = "HyperLink!"
string text = "Pages"
end type

event clicked;sle_pages.enabled = True
end event

type rb_2 from so_radiobutton within w_zetprint
integer x = 1851
integer y = 844
integer width = 635
integer height = 76
boolean bringtotop = true
integer weight = 700
string pointer = "HyperLink!"
string text = "Current Page"
end type

event clicked;string tmp , lvs_return
long row
row = dw_target.getrow()
tmp = dw_target.describe("evaluate('page()',"+string(row)+")")
dw_target.object.datawindow.print.page.range = tmp

sle_pages.enabled = False
end event

type rb_1 from so_radiobutton within w_zetprint
integer x = 1851
integer y = 760
integer width = 635
integer height = 76
boolean bringtotop = true
integer weight = 700
string pointer = "HyperLink!"
string text = "All"
boolean checked = true
end type

event clicked;string l
l = '' 
dw_target.Modify("datawindow.print.page.range = '" + l + "'" )
sle_pages.enabled = False
end event

type sle_pages from so_singlelineedit within w_zetprint
integer x = 2272
integer y = 932
integer width = 485
integer taborder = 200
boolean bringtotop = true
boolean enabled = false
boolean autohscroll = false
end type

event modified;string l
l = text 
dw_target.Modify("datawindow.print.page.range = '" + l + "'" )

end event

type st_4 from so_statictext within w_zetprint
integer x = 567
integer y = 1188
integer width = 357
integer height = 72
boolean bringtotop = true
integer weight = 700
string pointer = "HyperLink!"
boolean enabled = false
string text = "Right"
alignment alignment = right!
end type

type st_5 from so_statictext within w_zetprint
integer x = 1193
integer y = 1080
integer width = 320
integer height = 60
boolean bringtotop = true
integer weight = 700
string pointer = "HyperLink!"
boolean enabled = false
string text = "Left"
alignment alignment = right!
end type

type cb_4 from so_commandbutton within w_zetprint
integer x = 2427
integer y = 280
integer width = 334
integer height = 104
integer taborder = 30
boolean bringtotop = true
string pointer = "HyperLink!"
string text = "Setup"
end type

event clicked;printsetupPrinter()
end event

type cb_print from so_commandbutton within w_zetprint
integer x = 1545
integer y = 1420
integer width = 443
integer height = 100
integer taborder = 10
boolean bringtotop = true
string pointer = "HyperLink!"
string text = "Print"
end type

event clicked;st_msg.text = 'Priting...'
string lvs_return
cb_cancel.visible = true
this.visible =false
//**********************************
// $$HEX2$$9ccd25b8$$ENDHEX$$
//**********************************

if rb_page.checked = true then 
//	lvs_return = dw_target.Modify("datawindow.print.page.range = '" + l + "'" )
	dw_target.Object.DataWindow.Print.Page.Range= sle_pages.text
end if 


dw_target.print(false)


//**********************************
cb_cancel.visible = false
this.visible = true

//**********************************
//$$HEX2$$ebb230ae$$ENDHEX$$
//**********************************

cb_close.triggerevent('clicked')
end event

type st_8 from so_statictext within w_zetprint
integer x = 567
integer y = 1400
integer width = 297
integer height = 76
boolean bringtotop = true
integer weight = 700
string pointer = "HyperLink!"
boolean enabled = false
string text = "Copy"
alignment alignment = right!
end type

type em_copies from so_editmask within w_zetprint
integer x = 878
integer y = 1380
integer height = 92
integer taborder = 160
boolean bringtotop = true
integer textsize = -9
string pointer = "HyperLink!"
string text = "1"
string mask = "###,##0"
boolean spin = true
string displaydata = "~b"
string minmax = "1~~99999"
end type

event modified;string l 
l = text 
dw_target.Modify("datawindow.print.copies = " + "'" + l + "'")
end event

type em_botm from so_editmask within w_zetprint
event ue_change pbm_enchange
integer x = 1513
integer y = 1180
integer width = 247
integer taborder = 30
boolean bringtotop = true
string pointer = "HyperLink!"
string mask = "####0"
string displaydata = ""
string minmax = "1~~9991"
end type

event ue_change;string l 
l = text 
dw_target.Modify("datawindow.print.margin.bottom = " + "'" + l + "'")

end event

event modified;string l 
l = text 
dw_target.Modify("datawindow.print.margin.bottom = " + "'" + l + "'")

end event

type em_lft from so_editmask within w_zetprint
event ue_change pbm_enchange
integer x = 1513
integer y = 1072
integer width = 247
integer taborder = 50
boolean bringtotop = true
string pointer = "HyperLink!"
string mask = "####0"
string displaydata = ""
string minmax = "1~~9991"
end type

event ue_change;string l 
l = text 
dw_target.Modify("datawindow.print.margin.left = " + "'" + l + "'")
end event

event modified;string l 
l = text 
dw_target.Modify("datawindow.print.margin.left = " + "'" + l + "'")

end event

type ddlb_type from so_dropdownlistbox within w_zetprint
integer x = 855
integer y = 856
integer width = 864
integer height = 384
integer taborder = 210
boolean bringtotop = true
string pointer = "HyperLink!"
boolean vscrollbar = true
string item[] = {"0 :Default System","1 :LandScape","2 :Portrait"}
end type

event selectionchanged;string l
l = mid(text,1,1)
dw_target.Modify("datawindow.print.Orientation = " + "'" + l + "'")
end event

type st_9 from so_statictext within w_zetprint
integer x = 553
integer y = 860
integer width = 293
integer height = 76
boolean bringtotop = true
integer weight = 700
string pointer = "HyperLink!"
boolean enabled = false
string text = "Type"
alignment alignment = right!
end type

type st_11 from so_statictext within w_zetprint
integer x = 567
integer y = 296
integer width = 370
integer height = 76
boolean bringtotop = true
integer weight = 700
string pointer = "HyperLink!"
boolean enabled = false
string text = "Printer"
alignment alignment = right!
end type

type ddlb_paper from so_dropdownlistbox within w_zetprint
integer x = 855
integer y = 740
integer width = 864
integer height = 768
integer taborder = 260
boolean bringtotop = true
string pointer = "HyperLink!"
boolean vscrollbar = true
string item[] = {"00: Default Your System","01: Letter 8 1/2 x 11 in","02: LetterSmall 8 1/2 x 11 in","03: Tabloid 17 x 11 inches","04: Ledger 17 x 11 inches","05: Legal 8 1/2 x 14 in","06: Statement 5 1/2 x 8 1/2 in","07: Executive 7","08: A3 297 x 420 mm","09: A4 210 x 297 mm","10: A4 Small 210 x 297 mm","11: A5 148 x 210 mm","12: B4","13: B5"}
end type

event selectionchanged;string l
l = string(long(mid(text,1,2)))
dw_target.Modify("datawindow.print.paper.size = " + "'" + l + "'")
end event

type st_12 from so_statictext within w_zetprint
integer x = 567
integer y = 1088
integer width = 357
integer height = 64
boolean bringtotop = true
integer weight = 700
string pointer = "HyperLink!"
boolean enabled = false
string text = "Top"
alignment alignment = right!
end type

type st_13 from so_statictext within w_zetprint
integer x = 1193
integer y = 1196
integer width = 320
integer height = 52
boolean bringtotop = true
integer weight = 700
string pointer = "HyperLink!"
boolean enabled = false
string text = "Bottom"
alignment alignment = right!
end type

type gb_3 from so_groupbox within w_zetprint
integer x = 539
integer y = 1300
integer width = 837
integer height = 224
integer taborder = 190
integer weight = 700
long textcolor = 16711680
string text = "Print  Number of Sheet"
end type

type gb_4 from so_groupbox within w_zetprint
integer x = 1797
integer y = 640
integer width = 987
integer height = 652
integer taborder = 50
integer weight = 700
long textcolor = 16711680
string text = "Range"
end type

type gb_5 from so_groupbox within w_zetprint
integer x = 539
integer y = 200
integer width = 2240
integer height = 416
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Printer Property"
end type

type cb_cancel from so_commandbutton within w_zetprint
integer x = 1545
integer y = 1420
integer width = 443
integer height = 100
integer taborder = 10
fontcharset fontcharset = hangeul!
string text = "Cancel"
end type

event clicked;dw_target.printcancel()
visible = false
cb_print.visible = true

end event

type ddplb_printers from dropdownpicturelistbox within w_zetprint
integer x = 965
integer y = 284
integer width = 1449
integer height = 832
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean autohscroll = true
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
string picturename[] = {"Print!"}
long picturemaskcolor = 536870912
end type

event selectionchanged;long ll_place
string ls_prntrs , ls_name , ls_temp , ls_driver , ls_port

ls_prntrs = ''
ls_prntrs = this.text

ll_place=pos (ls_prntrs, "~t")
ls_name=left(ls_prntrs, ll_place -1)
PrintSetPrinter (ls_name)

ls_temp=mid(ls_prntrs, ll_place +1)
ll_place=pos (ls_temp, "~t")
ls_driver=left(ls_temp, ll_place -1)
ls_port=mid(ls_temp, ll_place +1)

sle_port.text=ls_port
sle_driver.text=ls_driver


end event

type st_1 from so_statictext within w_zetprint
integer x = 567
integer y = 384
integer width = 370
integer height = 76
boolean bringtotop = true
integer weight = 700
string pointer = "HyperLink!"
boolean enabled = false
string text = "Port"
alignment alignment = right!
end type

type sle_port from so_singlelineedit within w_zetprint
integer x = 965
integer y = 388
integer width = 503
integer taborder = 40
boolean bringtotop = true
long backcolor = 12632256
end type

type st_2 from so_statictext within w_zetprint
integer x = 567
integer y = 484
integer width = 370
integer height = 76
boolean bringtotop = true
integer weight = 700
string pointer = "HyperLink!"
boolean enabled = false
string text = "Printer Driver"
alignment alignment = right!
end type

type sle_driver from so_singlelineedit within w_zetprint
integer x = 965
integer y = 476
integer width = 503
integer taborder = 50
boolean bringtotop = true
long backcolor = 12632256
end type

type p_1 from picture within w_zetprint
integer x = 27
integer y = 228
integer width = 475
integer height = 392
boolean bringtotop = true
string picturename = "print_left.gif"
boolean focusrectangle = false
end type

type pb_1 from picturebutton within w_zetprint
integer x = 1554
integer y = 1316
integer width = 101
integer height = 88
integer taborder = 200
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "VCRFirst!"
alignment htextalign = left!
string powertiptext = "First Page"
end type

event clicked;dw_target.scrolltorow( 1)
end event

type pb_2 from picturebutton within w_zetprint
integer x = 1659
integer y = 1316
integer width = 101
integer height = 88
integer taborder = 210
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "VCRPrior!"
alignment htextalign = left!
string powertiptext = "Prev Page"
end type

event clicked;dw_target.scrollpriorpage( )
end event

type pb_3 from picturebutton within w_zetprint
integer x = 1765
integer y = 1316
integer width = 101
integer height = 88
integer taborder = 210
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "VCRNext!"
alignment htextalign = left!
string powertiptext = "Next page"
end type

event clicked;dw_target.scrollnextpage( )
end event

type pb_4 from picturebutton within w_zetprint
integer x = 1870
integer y = 1316
integer width = 101
integer height = 88
integer taborder = 210
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "VCRLast!"
alignment htextalign = left!
string powertiptext = "Last Page"
end type

event clicked;dw_target.scrolltorow( dw_target.rowcount())
end event

type st_3 from so_statictext within w_zetprint
integer x = 558
integer y = 748
integer width = 293
integer height = 64
boolean bringtotop = true
integer weight = 700
string pointer = "HyperLink!"
boolean enabled = false
string text = "Paper"
alignment alignment = right!
end type

type hsb_1 from hscrollbar within w_zetprint
integer x = 50
integer y = 1452
integer width = 457
integer height = 64
boolean bringtotop = true
integer maxposition = 100
integer position = 50
end type

event lineright;if isnull(Gvs_zoom_size) or integer(Gvs_zoom_size) = 0 then 
	Gvs_zoom_size = '100'
end if
Gvs_zoom_size = string(integer(Gvs_zoom_size)+1)
f_set_zoom(selected_data_window,Gvs_zoom_size)
st_msg.text = Gvs_zoom_size+'%'
end event

event lineleft;if isnull(Gvs_zoom_size) or integer(Gvs_zoom_size) = 0 then 
	Gvs_zoom_size = '100'
end if
Gvs_zoom_size = string(integer(Gvs_zoom_size)-1)
f_set_zoom(selected_data_window,Gvs_zoom_size)
st_msg.text = Gvs_zoom_size+'%'
end event

type st_6 from so_statictext within w_zetprint
integer x = 23
integer y = 1368
boolean bringtotop = true
integer weight = 700
string text = "Zoom Setup"
end type

type gb_1 from so_groupbox within w_zetprint
integer x = 539
integer y = 1000
integer width = 1243
integer height = 292
integer taborder = 200
integer weight = 700
long textcolor = 16711680
string text = "Space Control"
end type

type gb_2 from so_groupbox within w_zetprint
integer x = 539
integer y = 644
integer width = 1243
integer height = 336
integer taborder = 240
integer weight = 700
long textcolor = 16711680
string text = "Print Condition"
end type

