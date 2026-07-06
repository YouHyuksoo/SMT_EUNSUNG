HA$PBExportHeader$w_set_filter.srw
forward
global type w_set_filter from w_popup_root
end type
type lb_column from listbox within w_set_filter
end type
type mle_text from multilineedit within w_set_filter
end type
type cb_3 from so_commandbutton within w_set_filter
end type
type cb_4 from so_commandbutton within w_set_filter
end type
type cb_5 from so_commandbutton within w_set_filter
end type
type cb_6 from so_commandbutton within w_set_filter
end type
type cb_7 from so_commandbutton within w_set_filter
end type
type cb_8 from so_commandbutton within w_set_filter
end type
type cb_9 from so_commandbutton within w_set_filter
end type
type cb_10 from so_commandbutton within w_set_filter
end type
type cb_11 from so_commandbutton within w_set_filter
end type
type cb_12 from so_commandbutton within w_set_filter
end type
type cb_13 from so_commandbutton within w_set_filter
end type
type cb_14 from so_commandbutton within w_set_filter
end type
type cb_15 from so_commandbutton within w_set_filter
end type
type cb_16 from so_commandbutton within w_set_filter
end type
type cb_1 from so_commandbutton within w_set_filter
end type
type cb_2 from so_commandbutton within w_set_filter
end type
type sle_window_name from so_singlelineedit within w_set_filter
end type
type st_1 from so_statictext within w_set_filter
end type
type sle_datawindow_name from so_singlelineedit within w_set_filter
end type
type st_2 from so_statictext within w_set_filter
end type
type cb_17 from so_commandbutton within w_set_filter
end type
type cb_18 from so_commandbutton within w_set_filter
end type
type cb_19 from so_commandbutton within w_set_filter
end type
type cb_20 from so_commandbutton within w_set_filter
end type
type cb_21 from so_commandbutton within w_set_filter
end type
type st_3 from statictext within w_set_filter
end type
type st_4 from statictext within w_set_filter
end type
type gb_1 from so_groupbox within w_set_filter
end type
type gb_2 from so_groupbox within w_set_filter
end type
end forward

global type w_set_filter from w_popup_root
integer width = 3022
integer height = 2216
lb_column lb_column
mle_text mle_text
cb_3 cb_3
cb_4 cb_4
cb_5 cb_5
cb_6 cb_6
cb_7 cb_7
cb_8 cb_8
cb_9 cb_9
cb_10 cb_10
cb_11 cb_11
cb_12 cb_12
cb_13 cb_13
cb_14 cb_14
cb_15 cb_15
cb_16 cb_16
cb_1 cb_1
cb_2 cb_2
sle_window_name sle_window_name
st_1 st_1
sle_datawindow_name sle_datawindow_name
st_2 st_2
cb_17 cb_17
cb_18 cb_18
cb_19 cb_19
cb_20 cb_20
cb_21 cb_21
st_3 st_3
st_4 st_4
gb_1 gb_1
gb_2 gb_2
end type
global w_set_filter w_set_filter

type variables
DATAWINDOW ARG_DW

end variables

on w_set_filter.create
int iCurrent
call super::create
this.lb_column=create lb_column
this.mle_text=create mle_text
this.cb_3=create cb_3
this.cb_4=create cb_4
this.cb_5=create cb_5
this.cb_6=create cb_6
this.cb_7=create cb_7
this.cb_8=create cb_8
this.cb_9=create cb_9
this.cb_10=create cb_10
this.cb_11=create cb_11
this.cb_12=create cb_12
this.cb_13=create cb_13
this.cb_14=create cb_14
this.cb_15=create cb_15
this.cb_16=create cb_16
this.cb_1=create cb_1
this.cb_2=create cb_2
this.sle_window_name=create sle_window_name
this.st_1=create st_1
this.sle_datawindow_name=create sle_datawindow_name
this.st_2=create st_2
this.cb_17=create cb_17
this.cb_18=create cb_18
this.cb_19=create cb_19
this.cb_20=create cb_20
this.cb_21=create cb_21
this.st_3=create st_3
this.st_4=create st_4
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.lb_column
this.Control[iCurrent+2]=this.mle_text
this.Control[iCurrent+3]=this.cb_3
this.Control[iCurrent+4]=this.cb_4
this.Control[iCurrent+5]=this.cb_5
this.Control[iCurrent+6]=this.cb_6
this.Control[iCurrent+7]=this.cb_7
this.Control[iCurrent+8]=this.cb_8
this.Control[iCurrent+9]=this.cb_9
this.Control[iCurrent+10]=this.cb_10
this.Control[iCurrent+11]=this.cb_11
this.Control[iCurrent+12]=this.cb_12
this.Control[iCurrent+13]=this.cb_13
this.Control[iCurrent+14]=this.cb_14
this.Control[iCurrent+15]=this.cb_15
this.Control[iCurrent+16]=this.cb_16
this.Control[iCurrent+17]=this.cb_1
this.Control[iCurrent+18]=this.cb_2
this.Control[iCurrent+19]=this.sle_window_name
this.Control[iCurrent+20]=this.st_1
this.Control[iCurrent+21]=this.sle_datawindow_name
this.Control[iCurrent+22]=this.st_2
this.Control[iCurrent+23]=this.cb_17
this.Control[iCurrent+24]=this.cb_18
this.Control[iCurrent+25]=this.cb_19
this.Control[iCurrent+26]=this.cb_20
this.Control[iCurrent+27]=this.cb_21
this.Control[iCurrent+28]=this.st_3
this.Control[iCurrent+29]=this.st_4
this.Control[iCurrent+30]=this.gb_1
this.Control[iCurrent+31]=this.gb_2
end on

on w_set_filter.destroy
call super::destroy
destroy(this.lb_column)
destroy(this.mle_text)
destroy(this.cb_3)
destroy(this.cb_4)
destroy(this.cb_5)
destroy(this.cb_6)
destroy(this.cb_7)
destroy(this.cb_8)
destroy(this.cb_9)
destroy(this.cb_10)
destroy(this.cb_11)
destroy(this.cb_12)
destroy(this.cb_13)
destroy(this.cb_14)
destroy(this.cb_15)
destroy(this.cb_16)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.sle_window_name)
destroy(this.st_1)
destroy(this.sle_datawindow_name)
destroy(this.st_2)
destroy(this.cb_17)
destroy(this.cb_18)
destroy(this.cb_19)
destroy(this.cb_20)
destroy(this.cb_21)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;ARG_DW = MESSAGE.POWEROBJECTPARM
SLE_WINDOW_NAME.TEXT = SELECTED_WINDOW.CLASSNAME()
sle_datawindow_name.text= gst_return.gvs_return[1]

IVS_MOUSEMOVE_YN = 'N'

IVD_SELECTED_DATA_WINDOW.retrieve(  UPPER(SLE_WINDOW_NAME.TEXT) , UPPER(sle_datawindow_name.text) , gvi_organization_id ) 

String   	lvs_col_name , lvs_col_mean
Integer		lvi_count

lb_column.Reset()

Gst_dw_colinfo.i_dw_colcount = 0
Gst_dw_colinfo.i_dw_colcount=Integer(  ARG_DW.Describe("DataWindow.Column.Count"))

For lvi_count = 1 to Gst_dw_colinfo.i_dw_colcount
	
	lvs_col_name = ''
	
	lvs_col_name	= ARG_DW.Describe('#'+String(lvi_count)+".Name")	
	lvs_col_mean   = ARG_DW.Describe(lvs_col_name+"_t.Text")	
	
	lb_column.additem(lvs_col_name+'('+lvs_col_mean+')')

Next
end event

type p_title from w_popup_root`p_title within w_set_filter
integer width = 2994
end type

type cb_sort from w_popup_root`cb_sort within w_set_filter
boolean visible = true
integer x = 1422
integer y = 1340
integer weight = 400
end type

type cb_close from w_popup_root`cb_close within w_set_filter
boolean visible = true
integer x = 2501
integer y = 296
end type

type st_msg from w_popup_root`st_msg within w_set_filter
boolean visible = true
integer x = 9
integer y = 484
integer width = 2994
end type

type dw_1 from w_popup_root`dw_1 within w_set_filter
boolean visible = true
integer y = 1456
integer width = 3013
integer height = 668
boolean titlebar = true
string title = "Filter Text"
string dataobject = "d_data_filter_popup"
end type

event dw_1::itemchanged;call super::itemchanged;if THIS.AcceptText() = -1 then
	return
end if

//=============================================
// $$HEX11$$c0bcbdacacc06dd52000eccefcb712ac200024c115c8$$ENDHEX$$
//=============================================
F_SET_SECURITY_ROW( THIS , ROW , 'ALL' )

end event

type dw_2 from w_popup_root`dw_2 within w_set_filter
integer y = 2200
end type

type dw_3 from w_popup_root`dw_3 within w_set_filter
integer y = 2208
end type

type lb_column from listbox within w_set_filter
integer x = 1815
integer y = 644
integer width = 1189
integer height = 656
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;string lvs_item
lvs_item = THIS.SelectedItem ( )


IF  POS( lvs_item , '(' ) <= 0  THEN 

mle_text.text = mle_text.text + ''
mle_text.setfocus()

ELSE
 
 mle_text.text = mle_text.text + TRIM(MID( lvs_item,  1, POS( lvs_item , '(' ) -1 ))
 mle_text.setfocus()

END IF

end event

type mle_text from multilineedit within w_set_filter
integer x = 521
integer y = 648
integer width = 1294
integer height = 652
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
boolean autohscroll = true
boolean autovscroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_3 from so_commandbutton within w_set_filter
integer x = 41
integer y = 684
integer width = 224
integer taborder = 100
boolean bringtotop = true
string text = ">"
end type

event clicked;call super::clicked;mle_text.text = mle_text.text + this.text
end event

type cb_4 from so_commandbutton within w_set_filter
integer x = 41
integer y = 764
integer width = 224
integer taborder = 110
boolean bringtotop = true
string text = "<"
end type

event clicked;call super::clicked;mle_text.text = mle_text.text + this.text
end event

type cb_5 from so_commandbutton within w_set_filter
integer x = 41
integer y = 840
integer width = 224
integer taborder = 120
boolean bringtotop = true
string text = "="
end type

event clicked;call super::clicked;mle_text.text = mle_text.text + this.text
end event

type cb_6 from so_commandbutton within w_set_filter
integer x = 41
integer y = 920
integer width = 224
integer taborder = 130
boolean bringtotop = true
string text = "<>"
end type

event clicked;call super::clicked;mle_text.text = mle_text.text + this.text
end event

type cb_7 from so_commandbutton within w_set_filter
integer x = 41
integer y = 1004
integer width = 224
integer taborder = 140
boolean bringtotop = true
integer weight = 400
string text = "("
end type

event clicked;call super::clicked;mle_text.text = mle_text.text + this.text
end event

type cb_8 from so_commandbutton within w_set_filter
integer x = 41
integer y = 1084
integer width = 224
integer taborder = 150
boolean bringtotop = true
integer weight = 400
string text = ")"
end type

event clicked;call super::clicked;mle_text.text = mle_text.text + this.text
end event

type cb_9 from so_commandbutton within w_set_filter
integer x = 41
integer y = 1164
integer width = 224
integer taborder = 160
boolean bringtotop = true
integer weight = 400
string text = "~'"
end type

event clicked;call super::clicked;mle_text.text = mle_text.text + this.text
end event

type cb_10 from so_commandbutton within w_set_filter
integer x = 274
integer y = 1004
integer width = 224
integer taborder = 150
boolean bringtotop = true
integer weight = 400
string text = "OR"
end type

event clicked;call super::clicked;mle_text.text = mle_text.text + this.text
end event

type cb_11 from so_commandbutton within w_set_filter
integer x = 274
integer y = 1084
integer width = 224
integer taborder = 160
boolean bringtotop = true
integer weight = 400
string text = "AND"
end type

event clicked;call super::clicked;mle_text.text = mle_text.text + this.text
end event

type cb_12 from so_commandbutton within w_set_filter
integer x = 274
integer y = 1164
integer width = 224
integer taborder = 170
boolean bringtotop = true
integer weight = 400
string text = "LIKE"
end type

event clicked;call super::clicked;mle_text.text = mle_text.text + this.text
end event

type cb_13 from so_commandbutton within w_set_filter
integer x = 270
integer y = 688
integer width = 224
integer taborder = 120
boolean bringtotop = true
string text = ">="
end type

event clicked;call super::clicked;mle_text.text = mle_text.text + this.text
end event

type cb_14 from so_commandbutton within w_set_filter
integer x = 270
integer y = 768
integer width = 224
integer taborder = 130
boolean bringtotop = true
string text = "<="
end type

event clicked;call super::clicked;mle_text.text = mle_text.text + this.text
end event

type cb_15 from so_commandbutton within w_set_filter
integer x = 270
integer y = 844
integer width = 224
integer taborder = 140
boolean bringtotop = true
integer weight = 400
string text = "%"
end type

event clicked;call super::clicked;mle_text.text = mle_text.text + this.text
end event

type cb_16 from so_commandbutton within w_set_filter
integer x = 270
integer y = 924
integer width = 224
integer taborder = 150
boolean bringtotop = true
integer weight = 400
string text = "IN"
end type

event clicked;call super::clicked;mle_text.text = mle_text.text + this.text
end event

type cb_1 from so_commandbutton within w_set_filter
integer x = 1957
integer y = 296
integer width = 274
integer height = 100
integer taborder = 30
boolean bringtotop = true
string text = "Verify"
end type

event clicked;call super::clicked;
if trim(mle_text.text) = '' then 
	ARG_DW.SetFilter("")		

else
	
	ARG_DW.SetFilter(mle_text.text)		

end if
end event

type cb_2 from so_commandbutton within w_set_filter
integer x = 2226
integer y = 296
integer width = 274
integer height = 100
integer taborder = 40
boolean bringtotop = true
string text = "Apply"
boolean default = true
end type

event clicked;call super::clicked;//STRING null_str
//SetNull(null_str)

if trim(mle_text.text) = '' then 
	ARG_DW.SetFilter("")		
	ARG_DW.Filter()	
	
else
	
	ARG_DW.SetFilter(mle_text.text)		
	ARG_DW.Filter()

end if
end event

type sle_window_name from so_singlelineedit within w_set_filter
integer x = 567
integer y = 276
integer width = 1093
integer taborder = 30
boolean bringtotop = true
textcase textcase = upper!
boolean displayonly = true
end type

type st_1 from so_statictext within w_set_filter
integer x = 41
integer y = 280
boolean bringtotop = true
integer weight = 700
string text = "Window Name"
alignment alignment = right!
end type

type sle_datawindow_name from so_singlelineedit within w_set_filter
integer x = 567
integer y = 360
integer width = 366
integer taborder = 40
boolean bringtotop = true
textcase textcase = upper!
boolean displayonly = true
end type

type st_2 from so_statictext within w_set_filter
integer x = 41
integer y = 360
integer width = 512
boolean bringtotop = true
integer weight = 700
string text = "Data Window Name"
alignment alignment = right!
end type

type cb_17 from so_commandbutton within w_set_filter
integer x = 41
integer y = 1340
integer width = 274
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer weight = 400
string text = "Insert"
end type

event clicked;call super::clicked;long  lvl_row
lvl_row = dw_1.insertrow(0)
IVD_SELECTED_DATA_WINDOW.setitem( lvl_row , 'window_name' , sle_window_name.text )
IVD_SELECTED_DATA_WINDOW.setitem( lvl_row , 'datawindow_name' , sle_datawindow_name.text )
IVD_SELECTED_DATA_WINDOW.setitem( lvl_row , 'filter_text' , mle_text.text )

IVD_SELECTED_DATA_WINDOW.trigger event ITEMCHANGED( lvl_row , IVD_SELECTED_DATA_WINDOW.object.filter_text , IVD_SELECTED_DATA_WINDOW.object.filter_text[lvl_row])  
end event

type cb_18 from so_commandbutton within w_set_filter
integer x = 315
integer y = 1340
integer width = 274
integer height = 100
integer taborder = 60
boolean bringtotop = true
integer weight = 400
string text = "Delete"
end type

event clicked;call super::clicked;IVD_SELECTED_DATA_WINDOW.deleterow(IVD_SELECTED_DATA_WINDOW.getrow())
end event

type cb_19 from so_commandbutton within w_set_filter
integer x = 594
integer y = 1340
integer width = 274
integer height = 100
integer taborder = 70
boolean bringtotop = true
integer weight = 400
string text = "Update"
end type

event clicked;call super::clicked;if IVD_SELECTED_DATA_WINDOW.update() < 0 then 
	rollback ;
	st_msg.text = "Save Failed"
else
	commit ;
	st_msg.text = "Save Success!"
end if
end event

type cb_20 from so_commandbutton within w_set_filter
integer x = 869
integer y = 1340
integer width = 274
integer height = 100
integer taborder = 80
boolean bringtotop = true
integer weight = 400
string text = "Apply"
end type

event clicked;call super::clicked;//STRING null_str
//SetNull(null_str)

if IVD_SELECTED_DATA_WINDOW.getrow() < 1 then return 

if trim(IVD_SELECTED_DATA_WINDOW.object.filter_text[IVD_SELECTED_DATA_WINDOW.getrow()]) = '' or isnull(trim(IVD_SELECTED_DATA_WINDOW.object.filter_text[IVD_SELECTED_DATA_WINDOW.getrow()]) ) then 
	ARG_DW.SetFilter("")		
	ARG_DW.Filter()	
	
else
	
	ARG_DW.SetFilter(trim(IVD_SELECTED_DATA_WINDOW.object.filter_text[IVD_SELECTED_DATA_WINDOW.getrow()])  )		
	ARG_DW.Filter()

end if
end event

type cb_21 from so_commandbutton within w_set_filter
integer x = 1143
integer y = 1340
integer width = 274
integer height = 100
integer taborder = 90
boolean bringtotop = true
integer weight = 400
string text = "Default"
end type

event clicked;call super::clicked;ARG_DW.SetFilter("")		
ARG_DW.Filter()	
end event

type st_3 from statictext within w_set_filter
integer x = 1819
integer y = 576
integer width = 1179
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Column Name"
boolean focusrectangle = false
end type

type st_4 from statictext within w_set_filter
integer x = 530
integer y = 576
integer width = 1285
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Expression "
boolean focusrectangle = false
end type

type gb_1 from so_groupbox within w_set_filter
integer x = 1682
integer y = 200
integer width = 1307
integer height = 280
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_set_filter
integer x = 5
integer y = 200
integer width = 1673
integer height = 280
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

