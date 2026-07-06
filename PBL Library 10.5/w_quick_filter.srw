HA$PBExportHeader$w_quick_filter.srw
forward
global type w_quick_filter from w_popup_root
end type
type sle_column_name from so_singlelineedit within w_quick_filter
end type
type st_3 from so_statictext within w_quick_filter
end type
type sle_string from so_singlelineedit within w_quick_filter
end type
type st_1 from so_statictext within w_quick_filter
end type
type gb_2 from so_groupbox within w_quick_filter
end type
end forward

global type w_quick_filter from w_popup_root
integer width = 1504
integer height = 616
string title = "Quick Filter"
sle_column_name sle_column_name
st_3 st_3
sle_string sle_string
st_1 st_1
gb_2 gb_2
end type
global w_quick_filter w_quick_filter

type variables
DATAWINDOW ARG_DW

end variables

on w_quick_filter.create
int iCurrent
call super::create
this.sle_column_name=create sle_column_name
this.st_3=create st_3
this.sle_string=create sle_string
this.st_1=create st_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_column_name
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.sle_string
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.gb_2
end on

on w_quick_filter.destroy
call super::destroy
destroy(this.sle_column_name)
destroy(this.st_3)
destroy(this.sle_string)
destroy(this.st_1)
destroy(this.gb_2)
end on

event open;call super::open;ARG_DW = MESSAGE.POWEROBJECTPARM
sle_column_name.TEXT = GVS_COLUMNNAME
sle_string.setfocus( )
end event

type p_title from w_popup_root`p_title within w_quick_filter
integer width = 1481
end type

type cb_sort from w_popup_root`cb_sort within w_quick_filter
boolean visible = true
integer x = 110
integer y = 1480
integer taborder = 0
integer weight = 400
end type

type cb_close from w_popup_root`cb_close within w_quick_filter
boolean visible = true
integer x = 1179
integer y = 248
integer taborder = 0
end type

type st_msg from w_popup_root`st_msg within w_quick_filter
boolean visible = true
integer x = 9
integer y = 444
integer width = 1481
end type

type dw_1 from w_popup_root`dw_1 within w_quick_filter
boolean visible = true
integer y = 1684
integer width = 553
integer height = 436
integer taborder = 0
boolean titlebar = true
end type

type dw_2 from w_popup_root`dw_2 within w_quick_filter
integer y = 1684
integer width = 553
integer height = 436
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_quick_filter
integer y = 1684
integer width = 553
integer height = 436
integer taborder = 0
end type

type sle_column_name from so_singlelineedit within w_quick_filter
integer x = 576
integer y = 256
integer width = 585
boolean bringtotop = true
long backcolor = 65280
textcase textcase = upper!
boolean displayonly = true
end type

type st_3 from so_statictext within w_quick_filter
integer x = 50
integer y = 268
integer width = 512
boolean bringtotop = true
integer weight = 700
string text = "Column Name"
alignment alignment = right!
end type

type sle_string from so_singlelineedit within w_quick_filter
integer x = 576
integer y = 344
integer width = 585
integer taborder = 1
boolean bringtotop = true
textcase textcase = upper!
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

LVS_COLUMN = GVS_COLUMNNAME

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

ARG_DW.SETFILTER('')
ARG_DW.FILTER()

IF THIS.TEXT = '' THEN 
	ARG_DW.SETFILTER('')
	ARG_DW.FILTER()
	RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

ARG_DW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
ARG_DW.FILTER()
st_msg.text = STRING( ARG_DW.ROWCOUNT() ) + " Found"
end event

type st_1 from so_statictext within w_quick_filter
integer x = 50
integer y = 348
integer width = 512
boolean bringtotop = true
integer weight = 700
string text = "Filter String"
alignment alignment = right!
end type

type gb_2 from so_groupbox within w_quick_filter
integer x = 5
integer y = 200
integer width = 1472
integer height = 240
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

