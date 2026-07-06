HA$PBExportHeader$w_mcn_mold_location_popup.srw
$PBExportComments$(Sal Customerr Query)-$$HEX5$$70ac98b798cc70c88cd6$$ENDHEX$$
forward
global type w_mcn_mold_location_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_mcn_mold_location_popup
end type
type cb_select from so_commandbutton within w_mcn_mold_location_popup
end type
type st_14 from so_statictext within w_mcn_mold_location_popup
end type
type sle_mold_code from so_singlelineedit within w_mcn_mold_location_popup
end type
type rb_all from so_radiobutton within w_mcn_mold_location_popup
end type
type rb_oneself from so_radiobutton within w_mcn_mold_location_popup
end type
type rb_outside from so_radiobutton within w_mcn_mold_location_popup
end type
type ddlb_mold_group from uo_basecode within w_mcn_mold_location_popup
end type
type st_4 from so_statictext within w_mcn_mold_location_popup
end type
type gb_1 from so_groupbox within w_mcn_mold_location_popup
end type
type gb_2 from so_groupbox within w_mcn_mold_location_popup
end type
type gb_3 from so_groupbox within w_mcn_mold_location_popup
end type
end forward

global type w_mcn_mold_location_popup from w_popup_root
integer width = 3730
integer height = 2128
string title = "Mold / Tool Master Popup"
cb_retrieve cb_retrieve
cb_select cb_select
st_14 st_14
sle_mold_code sle_mold_code
rb_all rb_all
rb_oneself rb_oneself
rb_outside rb_outside
ddlb_mold_group ddlb_mold_group
st_4 st_4
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_mcn_mold_location_popup w_mcn_mold_location_popup

on w_mcn_mold_location_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.st_14=create st_14
this.sle_mold_code=create sle_mold_code
this.rb_all=create rb_all
this.rb_oneself=create rb_oneself
this.rb_outside=create rb_outside
this.ddlb_mold_group=create ddlb_mold_group
this.st_4=create st_4
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.st_14
this.Control[iCurrent+4]=this.sle_mold_code
this.Control[iCurrent+5]=this.rb_all
this.Control[iCurrent+6]=this.rb_oneself
this.Control[iCurrent+7]=this.rb_outside
this.Control[iCurrent+8]=this.ddlb_mold_group
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.gb_2
this.Control[iCurrent+12]=this.gb_3
end on

on w_mcn_mold_location_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.st_14)
destroy(this.sle_mold_code)
destroy(this.rb_all)
destroy(this.rb_oneself)
destroy(this.rb_outside)
destroy(this.ddlb_mold_group)
destroy(this.st_4)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event open;call super::open;dw_1.settransobject(sqlca)
IVD_SELECTED_DATA_WINDOW = DW_1
CB_RETRIEVE.TRIGGEREVENT(CLICKED!)

end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
end if
end event

type p_title from w_popup_root`p_title within w_mcn_mold_location_popup
integer width = 3707
end type

type cb_sort from w_popup_root`cb_sort within w_mcn_mold_location_popup
boolean visible = true
integer x = 2519
integer y = 296
integer height = 168
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_mcn_mold_location_popup
boolean visible = true
integer x = 3355
integer y = 296
integer height = 168
integer taborder = 0
end type

type st_msg from w_popup_root`st_msg within w_mcn_mold_location_popup
boolean visible = true
integer y = 528
integer width = 3707
end type

type dw_1 from w_popup_root`dw_1 within w_mcn_mold_location_popup
boolean visible = true
integer y = 628
integer width = 3707
integer height = 1412
integer taborder = 30
boolean titlebar = true
string title = "Mold Location List"
string dataobject = "d_mcn_mold_location_popup"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
cb_select.triggerevent(clicked!)
end event

type dw_2 from w_popup_root`dw_2 within w_mcn_mold_location_popup
boolean visible = true
integer y = 792
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_mcn_mold_location_popup
integer y = 640
end type

type cb_retrieve from so_commandbutton within w_mcn_mold_location_popup
integer x = 2798
integer y = 296
integer width = 274
integer height = 168
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE( ddlb_mold_group.getcode( )+'%' ,  '%'+sle_mold_code.TEXT+'%' , GVI_ORGANIZATION_ID )
end event

type cb_select from so_commandbutton within w_mcn_mold_location_popup
integer x = 3077
integer y = 296
integer width = 274
integer height = 168
boolean bringtotop = true
string text = "Select"
boolean default = true
end type

event clicked;IF DW_1.GETROW() = 0  THEN 
	RETURN -1
END IF
gst_return.gvb_return = true
MESSAGE.STRINGPARM    = DW_1.GETITEMSTRING( DW_1.GETROW() , 'mold_location_code')
CLOSEWITHRETURN(PARENT , MESSAGE.STRINGPARM )
end event

type st_14 from so_statictext within w_mcn_mold_location_popup
integer x = 498
integer y = 292
integer width = 466
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Mold Code"
end type

type sle_mold_code from so_singlelineedit within w_mcn_mold_location_popup
event ue_editchange pbm_enchange
integer x = 498
integer y = 380
integer width = 466
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer weight = 700
string pointer = "HyperLink!"
textcase textcase = upper!
end type

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN = "MOLD_CODE"

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

IVD_SELECTED_DATA_WINDOW.SETFILTER('')
IVD_SELECTED_DATA_WINDOW.FILTER()

IF THIS.TEXT = '' THEN 
	IVD_SELECTED_DATA_WINDOW.SETFILTER('')
	IVD_SELECTED_DATA_WINDOW.FILTER()
	RETURN
ELSE
	LVS_VALUE =  UPPER( '%'+this.text+'%' )
END IF

IVD_SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
IVD_SELECTED_DATA_WINDOW.FILTER()

end event

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

type rb_all from so_radiobutton within w_mcn_mold_location_popup
integer x = 1106
integer y = 344
integer width = 293
boolean bringtotop = true
integer weight = 700
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.setfilter( '')
dw_1.filter( )
end event

type rb_oneself from so_radiobutton within w_mcn_mold_location_popup
integer x = 1522
integer y = 344
integer width = 384
boolean bringtotop = true
integer weight = 700
string text = "Empty"
end type

event clicked;call super::clicked;dw_1.setfilter("isnull(mold_code) or mold_code = ''")
dw_1.filter( )
end event

type rb_outside from so_radiobutton within w_mcn_mold_location_popup
integer x = 1989
integer y = 344
integer width = 434
boolean bringtotop = true
integer weight = 700
string text = "Not Empty"
end type

event clicked;call super::clicked;dw_1.setfilter("not isnull(mold_code)")
dw_1.filter( )
end event

type ddlb_mold_group from uo_basecode within w_mcn_mold_location_popup
integer x = 32
integer y = 380
integer width = 462
integer taborder = 110
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'MOLD GROUP')
end event

event selectionchanged;call super::selectionchanged;CB_RETRIEVE.TRIGGEREVENT(CLICKED!)
end event

type st_4 from so_statictext within w_mcn_mold_location_popup
integer x = 32
integer y = 292
integer width = 462
integer height = 76
boolean bringtotop = true
integer weight = 700
string text = "Mold Group"
end type

type gb_1 from so_groupbox within w_mcn_mold_location_popup
integer x = 2450
integer y = 212
integer width = 1248
integer height = 304
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_mcn_mold_location_popup
integer x = 1051
integer y = 208
integer width = 1390
integer height = 304
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Filter"
end type

type gb_3 from so_groupbox within w_mcn_mold_location_popup
integer y = 212
integer width = 1033
integer height = 304
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

