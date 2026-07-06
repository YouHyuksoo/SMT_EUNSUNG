HA$PBExportHeader$w_mat_keyitem_popup.srw
$PBExportComments$LG$$HEX7$$fcc894c690c7acc7acb9a4c2b8d2$$ENDHEX$$
forward
global type w_mat_keyitem_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_mat_keyitem_popup
end type
type cb_select from so_commandbutton within w_mat_keyitem_popup
end type
type st_item_code from so_statictext within w_mat_keyitem_popup
end type
type ddlb_item_code from uo_item_code within w_mat_keyitem_popup
end type
type gb_2 from so_groupbox within w_mat_keyitem_popup
end type
type gb_3 from so_groupbox within w_mat_keyitem_popup
end type
end forward

global type w_mat_keyitem_popup from w_popup_root
integer width = 4530
integer height = 2232
string title = "Material Item Popup"
cb_retrieve cb_retrieve
cb_select cb_select
st_item_code st_item_code
ddlb_item_code ddlb_item_code
gb_2 gb_2
gb_3 gb_3
end type
global w_mat_keyitem_popup w_mat_keyitem_popup

on w_mat_keyitem_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.st_item_code=create st_item_code
this.ddlb_item_code=create ddlb_item_code
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.st_item_code
this.Control[iCurrent+4]=this.ddlb_item_code
this.Control[iCurrent+5]=this.gb_2
this.Control[iCurrent+6]=this.gb_3
end on

on w_mat_keyitem_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.st_item_code)
destroy(this.ddlb_item_code)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event open;call super::open;dw_1.settransobject(sqlca)
end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
	
end if
end event

event ue_post_open;call super::ue_post_open;cb_retrieve.triggerevent(clicked!)
end event

type p_title from w_popup_root`p_title within w_mat_keyitem_popup
integer x = 5
integer width = 4517
end type

type cb_sort from w_popup_root`cb_sort within w_mat_keyitem_popup
integer x = 3374
integer y = 352
end type

type cb_close from w_popup_root`cb_close within w_mat_keyitem_popup
boolean visible = true
integer x = 4210
integer y = 352
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_mat_keyitem_popup
boolean visible = true
integer x = 5
integer y = 556
integer width = 4517
end type

type dw_1 from w_popup_root`dw_1 within w_mat_keyitem_popup
boolean visible = true
integer y = 660
integer width = 4517
integer height = 1504
boolean titlebar = true
string title = "Keyitem  List"
string dataobject = "d_mat_keyitem_lst"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
cb_select.triggerevent(clicked!)
end event

type dw_2 from w_popup_root`dw_2 within w_mat_keyitem_popup
integer y = 660
end type

type dw_3 from w_popup_root`dw_3 within w_mat_keyitem_popup
integer y = 736
end type

type cb_retrieve from so_commandbutton within w_mat_keyitem_popup
boolean visible = false
integer x = 3653
integer y = 352
integer width = 274
integer height = 100
integer taborder = 70
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE()
//DW_1.RETRIEVE( ddlb_item_code.text + '%'  , GVI_ORGANIZATION_ID )
end event

type cb_select from so_commandbutton within w_mat_keyitem_popup
boolean visible = false
integer x = 3931
integer y = 352
integer width = 274
integer height = 100
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
message.stringparm = dw_1.object.item_code[dw_1.getrow()]
 
closewithreturn(parent , message.stringparm)

end event

type st_item_code from so_statictext within w_mat_keyitem_popup
boolean visible = false
integer x = 32
integer y = 332
integer width = 905
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mat_keyitem_popup
boolean visible = false
integer x = 32
integer y = 404
integer width = 905
integer taborder = 20
boolean bringtotop = true
end type

type gb_2 from so_groupbox within w_mat_keyitem_popup
boolean visible = false
integer x = 5
integer y = 216
integer width = 983
integer height = 328
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_mat_keyitem_popup
boolean visible = false
integer x = 3351
integer y = 212
integer width = 1152
integer height = 328
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

