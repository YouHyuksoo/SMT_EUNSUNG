HA$PBExportHeader$w_mat_new_item_set_msl_location_popup.srw
$PBExportComments$$$HEX8$$6cade4b9e8b200ac20c1ddd01dd3c5c5$$ENDHEX$$
forward
global type w_mat_new_item_set_msl_location_popup from w_popup_root
end type
type cb_insert from so_commandbutton within w_mat_new_item_set_msl_location_popup
end type
type sle_item_code from so_singlelineedit within w_mat_new_item_set_msl_location_popup
end type
type pb_retrieve from so_commandbutton within w_mat_new_item_set_msl_location_popup
end type
type pb_qty1 from so_commandbutton within w_mat_new_item_set_msl_location_popup
end type
type pb_qty2 from so_commandbutton within w_mat_new_item_set_msl_location_popup
end type
type pb_qty3 from so_commandbutton within w_mat_new_item_set_msl_location_popup
end type
type st_1 from statictext within w_mat_new_item_set_msl_location_popup
end type
type gb_3 from so_groupbox within w_mat_new_item_set_msl_location_popup
end type
type gb_1 from so_groupbox within w_mat_new_item_set_msl_location_popup
end type
end forward

global type w_mat_new_item_set_msl_location_popup from w_popup_root
integer width = 4123
integer height = 1336
cb_insert cb_insert
sle_item_code sle_item_code
pb_retrieve pb_retrieve
pb_qty1 pb_qty1
pb_qty2 pb_qty2
pb_qty3 pb_qty3
st_1 st_1
gb_3 gb_3
gb_1 gb_1
end type
global w_mat_new_item_set_msl_location_popup w_mat_new_item_set_msl_location_popup

on w_mat_new_item_set_msl_location_popup.create
int iCurrent
call super::create
this.cb_insert=create cb_insert
this.sle_item_code=create sle_item_code
this.pb_retrieve=create pb_retrieve
this.pb_qty1=create pb_qty1
this.pb_qty2=create pb_qty2
this.pb_qty3=create pb_qty3
this.st_1=create st_1
this.gb_3=create gb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_insert
this.Control[iCurrent+2]=this.sle_item_code
this.Control[iCurrent+3]=this.pb_retrieve
this.Control[iCurrent+4]=this.pb_qty1
this.Control[iCurrent+5]=this.pb_qty2
this.Control[iCurrent+6]=this.pb_qty3
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.gb_3
this.Control[iCurrent+9]=this.gb_1
end on

on w_mat_new_item_set_msl_location_popup.destroy
call super::destroy
destroy(this.cb_insert)
destroy(this.sle_item_code)
destroy(this.pb_retrieve)
destroy(this.pb_qty1)
destroy(this.pb_qty2)
destroy(this.pb_qty3)
destroy(this.st_1)
destroy(this.gb_3)
destroy(this.gb_1)
end on

event open;call super::open;dw_1.settransobject(sqlca)
sle_item_code.text = message.stringparm 
pb_retrieve.triggerevent( CLICKED!)
end event

event ue_post_open;call super::ue_post_open;dw_1.retrieve( sle_item_code.text , gvi_organization_id  )
end event

event key;call super::key;if key = keyf1! then 
    pb_qty1.triggerevent(clicked!)
elseif key = keyf2! then 
    pb_qty2.triggerevent(clicked!)
elseif key = keyf3! then 
    pb_qty3.triggerevent(clicked!)	 
end if
end event

type p_title from w_popup_root`p_title within w_mat_new_item_set_msl_location_popup
integer width = 4128
end type

type cb_sort from w_popup_root`cb_sort within w_mat_new_item_set_msl_location_popup
integer x = 3643
integer y = 12
integer height = 132
end type

type cb_close from w_popup_root`cb_close within w_mat_new_item_set_msl_location_popup
boolean visible = true
integer x = 3589
integer y = 280
integer width = 485
integer height = 132
end type

event cb_close::clicked;call super::clicked;Gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_mat_new_item_set_msl_location_popup
boolean visible = true
integer x = 5
integer y = 484
integer width = 4128
end type

type dw_1 from w_popup_root`dw_1 within w_mat_new_item_set_msl_location_popup
boolean visible = true
integer y = 568
integer width = 4128
integer height = 668
boolean titlebar = true
string dataobject = "d_mat_item_4_new_item_popup"
end type

type dw_2 from w_popup_root`dw_2 within w_mat_new_item_set_msl_location_popup
integer y = 580
end type

type dw_3 from w_popup_root`dw_3 within w_mat_new_item_set_msl_location_popup
integer y = 668
end type

type cb_insert from so_commandbutton within w_mat_new_item_set_msl_location_popup
integer x = 1285
integer y = 280
integer width = 343
integer height = 144
integer taborder = 70
boolean bringtotop = true
string text = "Save"
end type

event clicked;call super::clicked;if dw_1.update() < 0 then 
	rollback;
else
	commit ;
end if 
end event

type sle_item_code from so_singlelineedit within w_mat_new_item_set_msl_location_popup
integer x = 219
integer y = 308
integer width = 672
integer taborder = 80
boolean bringtotop = true
end type

type pb_retrieve from so_commandbutton within w_mat_new_item_set_msl_location_popup
integer x = 923
integer y = 280
integer width = 366
integer height = 144
integer taborder = 80
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;call super::clicked;dw_1.retrieve( sle_item_code.text , gvi_organization_id )
end event

type pb_qty1 from so_commandbutton within w_mat_new_item_set_msl_location_popup
integer x = 1929
integer y = 280
integer width = 375
integer height = 144
integer taborder = 80
boolean bringtotop = true
string text = "Qty1 [F1]"
end type

event clicked;call super::clicked;if dw_1.getrow() > 0 then 
	
	ClosewithReturn( parent , string(dw_1.object.material_qty[dw_1.getrow()]))
	
end if 
end event

type pb_qty2 from so_commandbutton within w_mat_new_item_set_msl_location_popup
integer x = 2304
integer y = 280
integer width = 375
integer height = 144
integer taborder = 90
boolean bringtotop = true
string text = "Qty2[F2]"
end type

event clicked;call super::clicked;if dw_1.getrow() > 0 then 
	
	ClosewithReturn( parent , string(dw_1.object.material_qty2[dw_1.getrow()]))
	
end if 
end event

type pb_qty3 from so_commandbutton within w_mat_new_item_set_msl_location_popup
integer x = 2688
integer y = 280
integer width = 375
integer height = 144
integer taborder = 100
boolean bringtotop = true
string text = "Qty3[F3]"
end type

event clicked;call super::clicked;if dw_1.getrow() > 0 then 
	
	ClosewithReturn( parent , string(dw_1.object.material_qty3[dw_1.getrow()]))
	
end if 
end event

type st_1 from statictext within w_mat_new_item_set_msl_location_popup
integer x = 64
integer y = 32
integer width = 3995
integer height = 96
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "$$HEX36$$74c7200054ba38c1c0c994b22000fcac70ac200085c7e0ac74c725b874c72000c6c594b22000e0c2dcad200080bd88d47cc72000bdacb0c6d0c52000f4bcecc5d1c9c8b2e4b22000$$ENDHEX$$, $$HEX5$$3dcce0ac04c7e8cd2000$$ENDHEX$$, $$HEX7$$90c7acc75cd400c918c2c9b72000$$ENDHEX$$, MSL $$HEX15$$15c8f4bc7cb9200018c215c858d5e0ac200000c8a5c7200058d538c194c6$$ENDHEX$$"
boolean focusrectangle = false
end type

type gb_3 from so_groupbox within w_mat_new_item_set_msl_location_popup
integer x = 3525
integer y = 196
integer width = 571
integer height = 264
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_1 from so_groupbox within w_mat_new_item_set_msl_location_popup
integer x = 32
integer y = 216
integer width = 3470
integer height = 240
integer taborder = 30
long textcolor = 16711680
string text = "Process"
end type

