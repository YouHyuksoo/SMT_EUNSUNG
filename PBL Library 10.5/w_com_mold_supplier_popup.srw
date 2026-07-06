HA$PBExportHeader$w_com_mold_supplier_popup.srw
$PBExportComments$(Sal Customerr Query)-$$HEX5$$70ac98b798cc70c88cd6$$ENDHEX$$
forward
global type w_com_mold_supplier_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_com_mold_supplier_popup
end type
type cb_select from so_commandbutton within w_com_mold_supplier_popup
end type
type st_14 from so_statictext within w_com_mold_supplier_popup
end type
type sle_supplier_name from so_singlelineedit within w_com_mold_supplier_popup
end type
type sle_supplier_code from so_singlelineedit within w_com_mold_supplier_popup
end type
type st_1 from so_statictext within w_com_mold_supplier_popup
end type
type gb_1 from so_groupbox within w_com_mold_supplier_popup
end type
type gb_2 from so_groupbox within w_com_mold_supplier_popup
end type
end forward

global type w_com_mold_supplier_popup from w_popup_root
integer width = 3721
integer height = 2112
string title = "Customer Master Popup"
cb_retrieve cb_retrieve
cb_select cb_select
st_14 st_14
sle_supplier_name sle_supplier_name
sle_supplier_code sle_supplier_code
st_1 st_1
gb_1 gb_1
gb_2 gb_2
end type
global w_com_mold_supplier_popup w_com_mold_supplier_popup

on w_com_mold_supplier_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.st_14=create st_14
this.sle_supplier_name=create sle_supplier_name
this.sle_supplier_code=create sle_supplier_code
this.st_1=create st_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.st_14
this.Control[iCurrent+4]=this.sle_supplier_name
this.Control[iCurrent+5]=this.sle_supplier_code
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.gb_2
end on

on w_com_mold_supplier_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.st_14)
destroy(this.sle_supplier_name)
destroy(this.sle_supplier_code)
destroy(this.st_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;dw_1.settransobject(sqlca)
IVD_SELECTED_DATA_WINDOW = DW_1
f_child_dw3(dw_1, 'business_type', gvs_language, string(gvi_organization_id), 'BUSINESS TYPE')
CB_RETRIEVE.TRIGGEREVENT(CLICKED!)
SLE_supplier_code.SETFOCUS()
end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
end if
end event

type p_title from w_popup_root`p_title within w_com_mold_supplier_popup
integer x = 5
integer width = 3707
end type

type cb_sort from w_popup_root`cb_sort within w_com_mold_supplier_popup
boolean visible = true
integer x = 2519
integer y = 312
integer height = 132
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_com_mold_supplier_popup
boolean visible = true
integer x = 3355
integer y = 312
integer height = 132
integer taborder = 0
end type

type st_msg from w_popup_root`st_msg within w_com_mold_supplier_popup
boolean visible = true
integer y = 520
integer width = 3707
end type

type dw_1 from w_popup_root`dw_1 within w_com_mold_supplier_popup
boolean visible = true
integer y = 616
integer width = 3707
integer height = 1412
integer taborder = 30
string dataobject = "d_com_mold_supplier_popup"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
cb_select.triggerevent(clicked!)
end event

type dw_2 from w_popup_root`dw_2 within w_com_mold_supplier_popup
boolean visible = true
integer y = 784
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_com_mold_supplier_popup
integer y = 628
end type

type cb_retrieve from so_commandbutton within w_com_mold_supplier_popup
integer x = 2798
integer y = 312
integer width = 274
integer height = 132
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE(  SLE_supplier_code.TEXT+'%' ,  '%'+SLE_supplier_NAME.TEXT+'%' , GVI_ORGANIZATION_ID )
end event

type cb_select from so_commandbutton within w_com_mold_supplier_popup
integer x = 3077
integer y = 312
integer width = 274
integer height = 132
boolean bringtotop = true
string text = "Select"
boolean default = true
end type

event clicked;IF DW_1.GETROW() = 0  THEN 
	RETURN -1
END IF
gst_return.gvb_return = true
MESSAGE.STRINGPARM = DW_1.GETITEMSTRING( DW_1.GETROW() , 'supplier_code')
gst_return.gvs_return[1] = dw_1.getitemstring(dw_1.getrow(), 'supplier_name')
CLOSEWITHRETURN(PARENT , MESSAGE.STRINGPARM )
end event

type st_14 from so_statictext within w_com_mold_supplier_popup
integer x = 517
integer y = 280
integer width = 681
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Supplier Name"
end type

type sle_supplier_name from so_singlelineedit within w_com_mold_supplier_popup
event ue_editchange pbm_enchange
integer x = 517
integer y = 368
integer width = 681
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
STRING LVS_VALUE , LVS_COLUMN = "SUPPLIER_NAME"

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

type sle_supplier_code from so_singlelineedit within w_com_mold_supplier_popup
event ue_editchange pbm_enchange
integer x = 27
integer y = 368
integer width = 485
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer weight = 700
string pointer = "HyperLink!"
textcase textcase = upper!
end type

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN = "supplier_code"

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

IVD_SELECTED_DATA_WINDOW.SETFILTER('')
IVD_SELECTED_DATA_WINDOW.FILTER()

IF THIS.TEXT = '' THEN 
	IVD_SELECTED_DATA_WINDOW.SETFILTER('')
	IVD_SELECTED_DATA_WINDOW.FILTER()
	RETURN
ELSE
	LVS_VALUE = UPPER( '%'+this.text+'%' )
END IF

IVD_SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
IVD_SELECTED_DATA_WINDOW.FILTER()



end event

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

event modified;IVD_SELECTED_DATA_WINDOW.SETFOCUS()
end event

type st_1 from so_statictext within w_com_mold_supplier_popup
integer x = 27
integer y = 280
integer width = 485
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Supplier Code"
end type

type gb_1 from so_groupbox within w_com_mold_supplier_popup
integer x = 2450
integer y = 204
integer width = 1248
integer height = 304
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_com_mold_supplier_popup
integer y = 204
integer width = 1216
integer height = 304
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

