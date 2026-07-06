HA$PBExportHeader$w_mat_item_safety_inventory_popup.srw
$PBExportComments$$$HEX8$$6cade4b9e8b200ac20c1ddd01dd3c5c5$$ENDHEX$$
forward
global type w_mat_item_safety_inventory_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_mat_item_safety_inventory_popup
end type
type cb_select from so_commandbutton within w_mat_item_safety_inventory_popup
end type
type st_item_code from so_statictext within w_mat_item_safety_inventory_popup
end type
type ddlb_item_code from uo_item_code within w_mat_item_safety_inventory_popup
end type
type sle_supplier_name from so_singlelineedit within w_mat_item_safety_inventory_popup
end type
type st_14 from so_statictext within w_mat_item_safety_inventory_popup
end type
type sle_1 from so_singlelineedit within w_mat_item_safety_inventory_popup
end type
type st_1 from so_statictext within w_mat_item_safety_inventory_popup
end type
type st_4 from so_statictext within w_mat_item_safety_inventory_popup
end type
type ddlb_location_code from uo_basecode within w_mat_item_safety_inventory_popup
end type
type gb_2 from so_groupbox within w_mat_item_safety_inventory_popup
end type
type gb_3 from so_groupbox within w_mat_item_safety_inventory_popup
end type
end forward

global type w_mat_item_safety_inventory_popup from w_popup_root
integer width = 4055
integer height = 2232
string title = "Material Item Popup"
cb_retrieve cb_retrieve
cb_select cb_select
st_item_code st_item_code
ddlb_item_code ddlb_item_code
sle_supplier_name sle_supplier_name
st_14 st_14
sle_1 sle_1
st_1 st_1
st_4 st_4
ddlb_location_code ddlb_location_code
gb_2 gb_2
gb_3 gb_3
end type
global w_mat_item_safety_inventory_popup w_mat_item_safety_inventory_popup

on w_mat_item_safety_inventory_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.st_item_code=create st_item_code
this.ddlb_item_code=create ddlb_item_code
this.sle_supplier_name=create sle_supplier_name
this.st_14=create st_14
this.sle_1=create sle_1
this.st_1=create st_1
this.st_4=create st_4
this.ddlb_location_code=create ddlb_location_code
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.st_item_code
this.Control[iCurrent+4]=this.ddlb_item_code
this.Control[iCurrent+5]=this.sle_supplier_name
this.Control[iCurrent+6]=this.st_14
this.Control[iCurrent+7]=this.sle_1
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.ddlb_location_code
this.Control[iCurrent+11]=this.gb_2
this.Control[iCurrent+12]=this.gb_3
end on

on w_mat_item_safety_inventory_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.st_item_code)
destroy(this.ddlb_item_code)
destroy(this.sle_supplier_name)
destroy(this.st_14)
destroy(this.sle_1)
destroy(this.st_1)
destroy(this.st_4)
destroy(this.ddlb_location_code)
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

type p_title from w_popup_root`p_title within w_mat_item_safety_inventory_popup
integer width = 4041
end type

type cb_sort from w_popup_root`cb_sort within w_mat_item_safety_inventory_popup
boolean visible = true
integer x = 2775
integer y = 312
integer height = 176
end type

type cb_close from w_popup_root`cb_close within w_mat_item_safety_inventory_popup
boolean visible = true
integer x = 3611
integer y = 312
integer height = 176
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_mat_item_safety_inventory_popup
boolean visible = true
integer x = 5
integer y = 556
integer width = 4041
end type

type dw_1 from w_popup_root`dw_1 within w_mat_item_safety_inventory_popup
boolean visible = true
integer y = 660
integer width = 4041
integer height = 1504
boolean titlebar = true
string title = "Material Item Inventory List"
string dataobject = "d_mat_current_inventory_4_safety_lst_tree"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
cb_select.triggerevent(clicked!)
end event

type dw_2 from w_popup_root`dw_2 within w_mat_item_safety_inventory_popup
integer y = 660
end type

type dw_3 from w_popup_root`dw_3 within w_mat_item_safety_inventory_popup
integer y = 736
end type

type cb_retrieve from so_commandbutton within w_mat_item_safety_inventory_popup
integer x = 3054
integer y = 312
integer width = 274
integer height = 176
integer taborder = 70
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;dw_1.retrieve(ddlb_item_code.text() + '%', ddlb_location_code.getcode()+'%' ,  gvi_organization_id)

end event

type cb_select from so_commandbutton within w_mat_item_safety_inventory_popup
integer x = 3333
integer y = 312
integer width = 274
integer height = 176
integer taborder = 80
boolean bringtotop = true
string text = "Select"
boolean default = true
end type

event clicked;if dw_1.getrow() < 1 then 
	gst_return.gvb_return = false
	return -1 
end if 

gst_return.gvb_return = true 
message.stringparm = dw_1.object.material_mfs[dw_1.getrow()]
gst_return.gvs_return[1] = dw_1.object.item_code[dw_1.getrow()]
gst_return.gvs_return[2] = dw_1.object.item_name[dw_1.getrow()]
gst_return.gvs_return[3] = dw_1.object.item_spec[dw_1.getrow()]
//gst_return.gvs_return[4] = dw_1.object.supplier_code[dw_1.getrow()]
//gst_return.gvs_return[5] = dw_1.object.supplier_name[dw_1.getrow()]
gst_return.gvs_return[6] = dw_1.object.line_type[dw_1.getrow()]
gst_return.gvs_return[7] = dw_1.object.item_uom[dw_1.getrow()]
//gst_return.gvs_return[9] = dw_1.object.item_type[dw_1.getrow()]


 
closewithreturn(parent , message.stringparm)



end event

type st_item_code from so_statictext within w_mat_item_safety_inventory_popup
integer x = 32
integer y = 324
integer width = 466
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mat_item_safety_inventory_popup
integer x = 32
integer y = 404
integer width = 466
integer taborder = 20
boolean bringtotop = true
end type

type sle_supplier_name from so_singlelineedit within w_mat_item_safety_inventory_popup
integer x = 503
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

type st_14 from so_statictext within w_mat_item_safety_inventory_popup
integer x = 503
integer y = 324
integer width = 421
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Item Name"
end type

type sle_1 from so_singlelineedit within w_mat_item_safety_inventory_popup
integer x = 928
integer y = 404
integer width = 549
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

type st_1 from so_statictext within w_mat_item_safety_inventory_popup
integer x = 928
integer y = 324
integer width = 549
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Item Spec"
end type

type st_4 from so_statictext within w_mat_item_safety_inventory_popup
integer x = 1481
integer y = 324
integer width = 558
integer height = 68
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Location Code"
end type

type ddlb_location_code from uo_basecode within w_mat_item_safety_inventory_popup
integer x = 1481
integer y = 404
integer width = 558
integer taborder = 50
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'LOCATION CODE')
end event

type gb_2 from so_groupbox within w_mat_item_safety_inventory_popup
integer x = 5
integer y = 216
integer width = 2048
integer height = 328
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_mat_item_safety_inventory_popup
integer x = 2752
integer y = 216
integer width = 1152
integer height = 328
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

