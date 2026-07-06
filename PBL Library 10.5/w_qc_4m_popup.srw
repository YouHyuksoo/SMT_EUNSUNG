HA$PBExportHeader$w_qc_4m_popup.srw
$PBExportComments$(Sal Customerr Query)-$$HEX5$$70ac98b798cc70c88cd6$$ENDHEX$$
forward
global type w_qc_4m_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_qc_4m_popup
end type
type cb_select from so_commandbutton within w_qc_4m_popup
end type
type st_item_code from so_statictext within w_qc_4m_popup
end type
type sle_model_name from so_singlelineedit within w_qc_4m_popup
end type
type gb_2 from so_groupbox within w_qc_4m_popup
end type
type gb_3 from so_groupbox within w_qc_4m_popup
end type
end forward

global type w_qc_4m_popup from w_popup_root
integer width = 5006
integer height = 2984
string title = "4M Popup"
cb_retrieve cb_retrieve
cb_select cb_select
st_item_code st_item_code
sle_model_name sle_model_name
gb_2 gb_2
gb_3 gb_3
end type
global w_qc_4m_popup w_qc_4m_popup

on w_qc_4m_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.st_item_code=create st_item_code
this.sle_model_name=create sle_model_name
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.st_item_code
this.Control[iCurrent+4]=this.sle_model_name
this.Control[iCurrent+5]=this.gb_2
this.Control[iCurrent+6]=this.gb_3
end on

on w_qc_4m_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.st_item_code)
destroy(this.sle_model_name)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event open;call super::open;dw_1.settransobject(sqlca)
end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
	
end if
end event

event ue_post_open;call super::ue_post_open;sle_model_name.text = message.stringparm
cb_retrieve.triggerevent(clicked!)
end event

event activate;call super::activate;ivs_resize_type = 'DEFAULT'
end event

type p_title from w_popup_root`p_title within w_qc_4m_popup
integer x = 5
integer width = 5006
end type

type cb_sort from w_popup_root`cb_sort within w_qc_4m_popup
integer x = 3849
integer y = 260
integer height = 108
end type

type cb_close from w_popup_root`cb_close within w_qc_4m_popup
boolean visible = true
integer x = 4686
integer y = 260
integer height = 108
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_qc_4m_popup
boolean visible = true
integer x = 5
integer y = 428
integer width = 4974
end type

type dw_1 from w_popup_root`dw_1 within w_qc_4m_popup
boolean visible = true
integer y = 516
integer width = 2432
integer height = 2296
boolean titlebar = true
string title = "Keyitem  List"
string dataobject = "d_qc_4m_popup_lst"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
cb_select.triggerevent(clicked!)
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;if dw_1.getrow( ) < 1 then return 
dw_2.retrieve(  this.object.rowid[currentrow])
end event

type dw_2 from w_popup_root`dw_2 within w_qc_4m_popup
boolean visible = true
integer x = 2441
integer y = 528
integer width = 2537
integer height = 2284
string dataobject = "d_qc_4m_mst_popup"
end type

type dw_3 from w_popup_root`dw_3 within w_qc_4m_popup
integer y = 736
end type

type cb_retrieve from so_commandbutton within w_qc_4m_popup
boolean visible = false
integer x = 4128
integer y = 260
integer width = 274
integer height = 108
integer taborder = 70
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE(sle_model_name.text + '%'  , GVI_ORGANIZATION_ID )
end event

type cb_select from so_commandbutton within w_qc_4m_popup
boolean visible = false
integer x = 4407
integer y = 260
integer width = 274
integer height = 108
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

type st_item_code from so_statictext within w_qc_4m_popup
integer x = 59
integer y = 220
integer width = 896
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Model Name"
end type

type sle_model_name from so_singlelineedit within w_qc_4m_popup
integer x = 59
integer y = 308
integer width = 896
integer taborder = 30
boolean bringtotop = true
end type

type gb_2 from so_groupbox within w_qc_4m_popup
boolean visible = false
integer x = 5
integer y = 168
integer width = 983
integer height = 248
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_qc_4m_popup
boolean visible = false
integer x = 3826
integer y = 180
integer width = 1152
integer height = 232
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

