HA$PBExportHeader$w_mat_item_vendor_popup.srw
$PBExportComments$$$HEX10$$fcc894c690c7acc7c5c5b4cc20c1ddd01dd3c5c5$$ENDHEX$$
forward
global type w_mat_item_vendor_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_mat_item_vendor_popup
end type
type cb_select from so_commandbutton within w_mat_item_vendor_popup
end type
type st_item_code from so_statictext within w_mat_item_vendor_popup
end type
type ddlb_item_code from uo_item_code within w_mat_item_vendor_popup
end type
type gb_2 from so_groupbox within w_mat_item_vendor_popup
end type
type gb_3 from so_groupbox within w_mat_item_vendor_popup
end type
end forward

global type w_mat_item_vendor_popup from w_popup_root
integer width = 1934
integer height = 1040
string title = "Vendor Code Popup"
cb_retrieve cb_retrieve
cb_select cb_select
st_item_code st_item_code
ddlb_item_code ddlb_item_code
gb_2 gb_2
gb_3 gb_3
end type
global w_mat_item_vendor_popup w_mat_item_vendor_popup

type variables
String ivs_item_code
end variables

on w_mat_item_vendor_popup.create
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

on w_mat_item_vendor_popup.destroy
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

event ue_post_open;call super::ue_post_open; ivs_item_code          = Gst_return.gvs_return[1]
ddlb_item_code.text  = Gst_return.gvs_return[1]

cb_retrieve.triggerevent(clicked!)

end event

type p_title from w_popup_root`p_title within w_mat_item_vendor_popup
integer width = 3625
integer height = 140
end type

type cb_sort from w_popup_root`cb_sort within w_mat_item_vendor_popup
integer x = 791
integer y = 232
integer taborder = 30
end type

type cb_close from w_popup_root`cb_close within w_mat_item_vendor_popup
boolean visible = true
integer x = 1627
integer y = 232
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_mat_item_vendor_popup
boolean visible = true
integer x = 5
integer y = 396
integer width = 3625
integer height = 68
end type

type dw_1 from w_popup_root`dw_1 within w_mat_item_vendor_popup
boolean visible = true
integer x = 5
integer y = 472
integer width = 1920
integer height = 472
integer taborder = 70
boolean titlebar = true
string title = "Vendor Code List"
string dataobject = "d_mat_item_vendor_popup"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
cb_select.triggerevent(clicked!)
end event

type dw_2 from w_popup_root`dw_2 within w_mat_item_vendor_popup
integer x = 14
integer y = 576
integer height = 268
integer taborder = 80
end type

type dw_3 from w_popup_root`dw_3 within w_mat_item_vendor_popup
integer x = 14
integer y = 652
integer height = 268
integer taborder = 90
end type

type cb_retrieve from so_commandbutton within w_mat_item_vendor_popup
boolean visible = false
integer x = 1070
integer y = 232
integer width = 274
integer height = 100
integer taborder = 50
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE( ivs_item_code , GVI_ORGANIZATION_ID )
end event

type cb_select from so_commandbutton within w_mat_item_vendor_popup
integer x = 1344
integer y = 232
integer width = 274
integer height = 100
integer taborder = 60
boolean bringtotop = true
string text = "Select"
boolean default = true
end type

event clicked;if dw_1.getrow() < 1 then 
	gst_return.gvb_return = false
	return -1 
end if 

gst_return.gvb_return = true 
message.stringparm = dw_1.object.vendor_code1[dw_1.getrow()]
//gst_return.gvs_return[1] = dw_1.object.vendor_code1[dw_1.getrow()]
 
closewithreturn(parent , message.stringparm)


end event

type st_item_code from so_statictext within w_mat_item_vendor_popup
integer x = 32
integer y = 200
integer width = 677
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mat_item_vendor_popup
integer x = 32
integer y = 272
integer width = 681
integer taborder = 0
boolean bringtotop = true
end type

type gb_2 from so_groupbox within w_mat_item_vendor_popup
integer x = 5
integer y = 132
integer width = 754
integer height = 256
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_mat_item_vendor_popup
integer x = 768
integer y = 132
integer width = 1152
integer height = 256
integer taborder = 40
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

