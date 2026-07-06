HA$PBExportHeader$w_mat_workorder_not_issued_popup.srw
$PBExportComments$$$HEX9$$f8bb9ccde0ac08c615c818c2c9b770c88cd6$$ENDHEX$$
forward
global type w_mat_workorder_not_issued_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_mat_workorder_not_issued_popup
end type
type st_item_code from so_statictext within w_mat_workorder_not_issued_popup
end type
type ddlb_item_code from uo_item_code within w_mat_workorder_not_issued_popup
end type
type sle_item_name from so_singlelineedit within w_mat_workorder_not_issued_popup
end type
type st_14 from so_statictext within w_mat_workorder_not_issued_popup
end type
type sle_item_spec from so_singlelineedit within w_mat_workorder_not_issued_popup
end type
type st_1 from so_statictext within w_mat_workorder_not_issued_popup
end type
type gb_2 from so_groupbox within w_mat_workorder_not_issued_popup
end type
type gb_3 from so_groupbox within w_mat_workorder_not_issued_popup
end type
end forward

global type w_mat_workorder_not_issued_popup from w_popup_root
integer width = 3918
integer height = 2232
string title = "Material Item Popup"
cb_retrieve cb_retrieve
st_item_code st_item_code
ddlb_item_code ddlb_item_code
sle_item_name sle_item_name
st_14 st_14
sle_item_spec sle_item_spec
st_1 st_1
gb_2 gb_2
gb_3 gb_3
end type
global w_mat_workorder_not_issued_popup w_mat_workorder_not_issued_popup

on w_mat_workorder_not_issued_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.st_item_code=create st_item_code
this.ddlb_item_code=create ddlb_item_code
this.sle_item_name=create sle_item_name
this.st_14=create st_14
this.sle_item_spec=create sle_item_spec
this.st_1=create st_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.st_item_code
this.Control[iCurrent+3]=this.ddlb_item_code
this.Control[iCurrent+4]=this.sle_item_name
this.Control[iCurrent+5]=this.st_14
this.Control[iCurrent+6]=this.sle_item_spec
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.gb_2
this.Control[iCurrent+9]=this.gb_3
end on

on w_mat_workorder_not_issued_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.st_item_code)
destroy(this.ddlb_item_code)
destroy(this.sle_item_name)
destroy(this.st_14)
destroy(this.sle_item_spec)
destroy(this.st_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event open;call super::open;dw_1.settransobject(sqlca)
ddlb_item_code.text = message.stringparm
cb_retrieve.triggerevent(CLICKED!)

end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
	
end if
end event

type p_title from w_popup_root`p_title within w_mat_workorder_not_issued_popup
integer width = 3909
end type

type cb_sort from w_popup_root`cb_sort within w_mat_workorder_not_issued_popup
boolean visible = true
integer x = 3040
integer y = 356
end type

type cb_close from w_popup_root`cb_close within w_mat_workorder_not_issued_popup
boolean visible = true
integer x = 3598
integer y = 356
end type

type st_msg from w_popup_root`st_msg within w_mat_workorder_not_issued_popup
boolean visible = true
integer x = 5
integer y = 556
integer width = 3899
end type

type dw_1 from w_popup_root`dw_1 within w_mat_workorder_not_issued_popup
boolean visible = true
integer y = 648
integer width = 3899
integer height = 1504
boolean titlebar = true
string title = "Material Item List"
string dataobject = "d_mat_work_order_not_issued_lst_tree"
end type

type dw_2 from w_popup_root`dw_2 within w_mat_workorder_not_issued_popup
integer y = 648
end type

type dw_3 from w_popup_root`dw_3 within w_mat_workorder_not_issued_popup
integer y = 648
end type

type cb_retrieve from so_commandbutton within w_mat_workorder_not_issued_popup
integer x = 3319
integer y = 356
integer width = 274
integer height = 100
integer taborder = 70
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE( ddlb_item_code.text , GVI_ORGANIZATION_ID )
end event

type st_item_code from so_statictext within w_mat_workorder_not_issued_popup
integer x = 32
integer y = 332
integer width = 466
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mat_workorder_not_issued_popup
integer x = 32
integer y = 404
integer width = 466
integer taborder = 20
boolean bringtotop = true
end type

type sle_item_name from so_singlelineedit within w_mat_workorder_not_issued_popup
integer x = 517
integer y = 404
integer width = 421
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer weight = 700
string pointer = "HyperLink!"
textcase textcase = upper!
end type

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN = "ITEM_NAME"

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

type st_14 from so_statictext within w_mat_workorder_not_issued_popup
integer x = 517
integer y = 316
integer width = 421
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Item Name"
end type

type sle_item_spec from so_singlelineedit within w_mat_workorder_not_issued_popup
integer x = 951
integer y = 404
integer width = 421
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer weight = 700
string pointer = "HyperLink!"
textcase textcase = upper!
end type

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN = "ITEM_SPEC"

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

type st_1 from so_statictext within w_mat_workorder_not_issued_popup
integer x = 951
integer y = 316
integer width = 421
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Item Spec"
end type

type gb_2 from so_groupbox within w_mat_workorder_not_issued_popup
integer x = 5
integer y = 216
integer width = 1394
integer height = 328
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_mat_workorder_not_issued_popup
integer x = 3017
integer y = 216
integer width = 882
integer height = 328
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

