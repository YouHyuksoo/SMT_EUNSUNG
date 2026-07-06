HA$PBExportHeader$w_mat_smt_checkhist_popup.srw
$PBExportComments$$$HEX8$$6cade4b9e8b200ac20c1ddd01dd3c5c5$$ENDHEX$$
forward
global type w_mat_smt_checkhist_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_mat_smt_checkhist_popup
end type
type cb_select from so_commandbutton within w_mat_smt_checkhist_popup
end type
type st_material_mfs from so_statictext within w_mat_smt_checkhist_popup
end type
type sle_material_mfs from so_singlelineedit within w_mat_smt_checkhist_popup
end type
type gb_2 from so_groupbox within w_mat_smt_checkhist_popup
end type
type gb_3 from so_groupbox within w_mat_smt_checkhist_popup
end type
end forward

global type w_mat_smt_checkhist_popup from w_popup_root
integer width = 3424
integer height = 2232
string title = "Smtl Check Hist Popup"
long backcolor = 16777215
cb_retrieve cb_retrieve
cb_select cb_select
st_material_mfs st_material_mfs
sle_material_mfs sle_material_mfs
gb_2 gb_2
gb_3 gb_3
end type
global w_mat_smt_checkhist_popup w_mat_smt_checkhist_popup

on w_mat_smt_checkhist_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.st_material_mfs=create st_material_mfs
this.sle_material_mfs=create sle_material_mfs
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.st_material_mfs
this.Control[iCurrent+4]=this.sle_material_mfs
this.Control[iCurrent+5]=this.gb_2
this.Control[iCurrent+6]=this.gb_3
end on

on w_mat_smt_checkhist_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.st_material_mfs)
destroy(this.sle_material_mfs)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event open;call super::open;dw_1.settransobject(sqlca)
sle_material_mfs.text = message.stringparm
  cb_retrieve.triggerevent(clicked!)
end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
	
end if
end event

type p_title from w_popup_root`p_title within w_mat_smt_checkhist_popup
integer width = 3392
long backcolor = 16777215
end type

type cb_sort from w_popup_root`cb_sort within w_mat_smt_checkhist_popup
integer x = 2267
integer y = 356
integer taborder = 30
end type

type cb_close from w_popup_root`cb_close within w_mat_smt_checkhist_popup
boolean visible = true
integer x = 3104
integer y = 356
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_mat_smt_checkhist_popup
boolean visible = true
integer x = 5
integer y = 556
integer width = 3392
long backcolor = 16777215
borderstyle borderstyle = stylebox!
end type

type dw_1 from w_popup_root`dw_1 within w_mat_smt_checkhist_popup
boolean visible = true
integer y = 660
integer width = 3392
integer height = 1504
integer taborder = 70
string title = "Smtl Check Hist"
string dataobject = "d_mat_smt_checkhist_popup"
borderstyle borderstyle = stylebox!
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
cb_select.triggerevent(clicked!)
end event

type dw_2 from w_popup_root`dw_2 within w_mat_smt_checkhist_popup
integer y = 660
integer taborder = 80
end type

type dw_3 from w_popup_root`dw_3 within w_mat_smt_checkhist_popup
integer y = 736
integer taborder = 90
end type

type cb_retrieve from so_commandbutton within w_mat_smt_checkhist_popup
boolean visible = false
integer x = 2546
integer y = 356
integer width = 274
integer height = 100
integer taborder = 50
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE( sle_material_mfs.text  )
end event

type cb_select from so_commandbutton within w_mat_smt_checkhist_popup
boolean visible = false
integer x = 2825
integer y = 356
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

type st_material_mfs from so_statictext within w_mat_smt_checkhist_popup
integer x = 224
integer y = 316
integer height = 68
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
string text = "Lot No"
end type

type sle_material_mfs from so_singlelineedit within w_mat_smt_checkhist_popup
integer x = 224
integer y = 404
integer height = 84
boolean bringtotop = true
boolean enabled = false
end type

type gb_2 from so_groupbox within w_mat_smt_checkhist_popup
integer x = 5
integer y = 216
integer width = 983
integer height = 328
integer taborder = 20
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_mat_smt_checkhist_popup
boolean visible = false
integer x = 2245
integer y = 216
integer width = 1152
integer height = 328
integer taborder = 40
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
string text = "Process"
end type

