HA$PBExportHeader$w_qc_aoi_review_r_tf_popup.srw
$PBExportComments$LG$$HEX7$$fcc894c690c7acc7acb9a4c2b8d2$$ENDHEX$$
forward
global type w_qc_aoi_review_r_tf_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_qc_aoi_review_r_tf_popup
end type
type sle_barcode from so_singlelineedit within w_qc_aoi_review_r_tf_popup
end type
type st_1 from so_statictext within w_qc_aoi_review_r_tf_popup
end type
type gb_2 from so_groupbox within w_qc_aoi_review_r_tf_popup
end type
type gb_3 from so_groupbox within w_qc_aoi_review_r_tf_popup
end type
end forward

global type w_qc_aoi_review_r_tf_popup from w_popup_root
integer width = 4530
integer height = 2232
string title = "Material Item Popup"
cb_retrieve cb_retrieve
sle_barcode sle_barcode
st_1 st_1
gb_2 gb_2
gb_3 gb_3
end type
global w_qc_aoi_review_r_tf_popup w_qc_aoi_review_r_tf_popup

on w_qc_aoi_review_r_tf_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.sle_barcode=create sle_barcode
this.st_1=create st_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.sle_barcode
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.gb_2
this.Control[iCurrent+5]=this.gb_3
end on

on w_qc_aoi_review_r_tf_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.sle_barcode)
destroy(this.st_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event open;call super::open;dw_1.settransobject(sqlca)
sle_barcode.text = message.stringparm
end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
	
end if
end event

type p_title from w_popup_root`p_title within w_qc_aoi_review_r_tf_popup
integer x = 5
integer width = 4517
end type

type cb_sort from w_popup_root`cb_sort within w_qc_aoi_review_r_tf_popup
integer x = 3950
integer y = 16
integer width = 558
integer height = 132
end type

type cb_close from w_popup_root`cb_close within w_qc_aoi_review_r_tf_popup
boolean visible = true
integer x = 3886
integer y = 304
integer width = 558
integer height = 132
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_qc_aoi_review_r_tf_popup
boolean visible = true
integer y = 532
integer width = 4517
end type

type dw_1 from w_popup_root`dw_1 within w_qc_aoi_review_r_tf_popup
boolean visible = true
integer y = 644
integer width = 4517
integer height = 1304
boolean titlebar = true
string title = "Keyitem  List"
string dataobject = "d_qc_machine_inspect_data_4_ng_only_aoi_i_tf_popup"
end type

type dw_2 from w_popup_root`dw_2 within w_qc_aoi_review_r_tf_popup
integer y = 660
end type

type dw_3 from w_popup_root`dw_3 within w_qc_aoi_review_r_tf_popup
integer y = 736
end type

type cb_retrieve from so_commandbutton within w_qc_aoi_review_r_tf_popup
integer x = 3369
integer y = 304
integer width = 503
integer height = 132
integer taborder = 70
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE(  '%'  , sle_barcode.text)
end event

type sle_barcode from so_singlelineedit within w_qc_aoi_review_r_tf_popup
integer x = 64
integer y = 372
integer width = 731
integer taborder = 20
boolean bringtotop = true
end type

type st_1 from so_statictext within w_qc_aoi_review_r_tf_popup
integer x = 64
integer y = 284
integer width = 731
boolean bringtotop = true
string text = "Barcode"
end type

type gb_2 from so_groupbox within w_qc_aoi_review_r_tf_popup
boolean visible = false
integer y = 184
integer width = 855
integer height = 328
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_qc_aoi_review_r_tf_popup
boolean visible = false
integer x = 3301
integer y = 184
integer width = 1189
integer height = 328
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

