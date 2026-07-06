HA$PBExportHeader$w_prd_fg_inv_loc_move.srw
$PBExportComments$$$HEX9$$1cc888d4acc7e0ac20003dcce0ac74c7d9b3$$ENDHEX$$
forward
global type w_prd_fg_inv_loc_move from w_popup_root
end type
type cb_select from commandbutton within w_prd_fg_inv_loc_move
end type
type st_2 from so_statictext within w_prd_fg_inv_loc_move
end type
type sle_barcode from so_singlelineedit within w_prd_fg_inv_loc_move
end type
type sle_location from so_singlelineedit within w_prd_fg_inv_loc_move
end type
type ddlb_location from uo_basecode within w_prd_fg_inv_loc_move
end type
type st_1 from so_statictext within w_prd_fg_inv_loc_move
end type
type st_3 from so_statictext within w_prd_fg_inv_loc_move
end type
type gb_1 from so_groupbox within w_prd_fg_inv_loc_move
end type
type gb_2 from so_groupbox within w_prd_fg_inv_loc_move
end type
end forward

global type w_prd_fg_inv_loc_move from w_popup_root
string tag = "w_prd_fg_inv_loc_move"
integer width = 3328
integer height = 764
string title = "Inventory Location Move Popup"
cb_select cb_select
st_2 st_2
sle_barcode sle_barcode
sle_location sle_location
ddlb_location ddlb_location
st_1 st_1
st_3 st_3
gb_1 gb_1
gb_2 gb_2
end type
global w_prd_fg_inv_loc_move w_prd_fg_inv_loc_move

on w_prd_fg_inv_loc_move.create
int iCurrent
call super::create
this.cb_select=create cb_select
this.st_2=create st_2
this.sle_barcode=create sle_barcode
this.sle_location=create sle_location
this.ddlb_location=create ddlb_location
this.st_1=create st_1
this.st_3=create st_3
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_select
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.sle_barcode
this.Control[iCurrent+4]=this.sle_location
this.Control[iCurrent+5]=this.ddlb_location
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.gb_2
end on

on w_prd_fg_inv_loc_move.destroy
call super::destroy
destroy(this.cb_select)
destroy(this.st_2)
destroy(this.sle_barcode)
destroy(this.sle_location)
destroy(this.ddlb_location)
destroy(this.st_1)
destroy(this.st_3)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;dw_1.settransobject(sqlca)

//sle_Line_code.TEXT = message.stringparm
//sle_machine_code.TEXT = Gst_return.gvs_return[1]
//
//CB_RETRIEVE.TRIGGEREVENT(CLICKED!)
//
//
end event

event key;call super::key;//if key = keyf1! then 
//   cb_retrieve.triggerevent(clicked!)
//end if
end event

type p_title from w_popup_root`p_title within w_prd_fg_inv_loc_move
integer width = 3314
integer height = 188
integer textsize = -24
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
long textcolor = 16777215
long backcolor = 16777215
string text = "Inventory Location Move"
end type

type cb_sort from w_popup_root`cb_sort within w_prd_fg_inv_loc_move
integer x = 1979
integer y = 292
integer height = 144
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_prd_fg_inv_loc_move
boolean visible = true
integer x = 2962
integer y = 292
integer width = 315
integer height = 144
integer taborder = 0
end type

event cb_close::clicked;call super::clicked;//gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_prd_fg_inv_loc_move
boolean visible = true
integer y = 496
integer width = 3314
integer height = 140
integer textsize = -14
end type

type dw_1 from w_popup_root`dw_1 within w_prd_fg_inv_loc_move
integer x = 1321
integer y = 852
integer width = 1888
integer height = 164
integer taborder = 0
end type

type dw_2 from w_popup_root`dw_2 within w_prd_fg_inv_loc_move
integer x = 5
integer y = 580
integer width = 1033
integer height = 400
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_prd_fg_inv_loc_move
integer y = 864
integer taborder = 30
end type

type cb_select from commandbutton within w_prd_fg_inv_loc_move
integer x = 2615
integer y = 292
integer width = 357
integer height = 144
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "MOVE"
boolean default = true
end type

event clicked;//=================================================
//Unpack $$HEX3$$7cc74cb52000$$ENDHEX$$
//=================================================
string lvs_out , lvs_outmsg, lvs_barcode, lvs_location, lvs_commit, lvs_to_location 
long lvl_txn_type, lvl_row
lvs_out = space(4000)
lvs_outmsg = space(4000)

lvs_barcode = sle_barcode.text 
lvs_commit = 'Y' 

if lvs_barcode = '' or isnull(lvs_barcode) then 
	f_msg('$$HEX15$$74c7d9b360d5200014bc54cfdcb47cb9200085c725b8200058d538c194c6$$ENDHEX$$','P')
	sle_barcode.text = '' 
	sle_location.text = ''
	sle_barcode.setfocus() 
	return 
end if 

lvs_to_location = ddlb_location.getcode()

if lvs_to_location = '%' or isnull(lvs_to_location) or lvs_to_location = '' then 
	f_msg('$$HEX14$$74c7d9b360d5200004c758ce7cb9200020c1ddd0200058d538c194c6$$ENDHEX$$!','P')
	return 
end if 

//OUT $$HEX8$$c0bc18c294b2200048c5f0c40cc92000$$ENDHEX$$fETCH $$HEX2$$d0c51cc1$$ENDHEX$$
declare proc procedure for P_PRODUCT_FG_INV_MOVE ( :lvs_barcode , :lvs_to_location , :lvs_commit   ) 
using sqlca ; 

execute proc ; 
fetch proc into :lvs_out, :lvs_outmsg ; 
close proc ; 

if f_sql_check() < 0 then
	return
end if 

if lvs_out = 'NG' then 
	messagebox('NG',lvs_outmsg)
	st_msg.text = f_msg('$$HEX14$$acc7f5ac74c7d9b344c72000e4c228d3200058d500c6b5c2c8b2e4b2$$ENDHEX$$.','S') + ' ' +lvs_outmsg 
	
	sle_barcode.text = '' 
	sle_location.text = ''
	sle_barcode.setfocus() 

	return
end if 

st_msg.text = lvs_out + '  ' + lvs_outmsg + f_msg(' Move Sucess','S') 
sle_barcode.text = '' 
sle_location.text = ''
sle_barcode.setfocus() 


end event

type st_2 from so_statictext within w_prd_fg_inv_loc_move
integer x = 55
integer y = 256
integer width = 1019
integer height = 84
boolean bringtotop = true
integer textsize = -12
string text = "Barcode"
end type

type sle_barcode from so_singlelineedit within w_prd_fg_inv_loc_move
integer x = 55
integer y = 360
integer width = 1019
integer height = 104
integer taborder = 10
boolean bringtotop = true
integer textsize = -12
integer weight = 700
string pointer = "h_beam.cur"
long textcolor = 65280
long backcolor = 0
textcase textcase = upper!
end type

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

event ue_editchange;long HMC, VL
HMC = ImmGetContext( handle(parent) )

VL = ImmSetConversionStatus(  HMC, 0, 0)

ImmReleaseContext( HMC, VL) 
end event

event modified;call super::modified;if this.text = '' or isnull(this.text) then 
	return 
end if

string lvs_pack_type, lvs_location,lvs_pallet_flag
long   lvl_qty

select pack_type, 
         location_code, 
         qty, 
         pallet_flag
   into :lvs_pack_type, 
	     :lvs_location,
		 :lvl_qty, :lvs_pallet_flag 
  from ip_product_fg_inventory x
 where barcode = :this.text ; 
 
 if f_sql_check() < 0 then 

	this.text = ''
	this.setfocus()
	return 
end if 

if lvs_pallet_flag = 'Y' then 
	f_msg ( '$$HEX16$$74c7f8bb20000cd31bb8c0d074c7d5c920001cb42000acc7e0ac85c7c8b2e4b2$$ENDHEX$$. ','P') 
	
	this.text = ''
	this.setfocus()
	return 
end if 

sle_location.text = lvs_location 
 
end event

type sle_location from so_singlelineedit within w_prd_fg_inv_loc_move
integer x = 1083
integer y = 360
integer height = 104
integer taborder = 20
boolean bringtotop = true
integer textsize = -12
boolean enabled = false
end type

type ddlb_location from uo_basecode within w_prd_fg_inv_loc_move
integer x = 1586
integer y = 356
integer taborder = 30
boolean bringtotop = true
integer textsize = -12
integer weight = 400
end type

event constructor;call super::constructor;redraw('PRODUCT LOCATION CODE') 
end event

type st_1 from so_statictext within w_prd_fg_inv_loc_move
integer x = 1083
integer y = 256
integer height = 84
boolean bringtotop = true
integer textsize = -12
string text = "Location"
end type

type st_3 from so_statictext within w_prd_fg_inv_loc_move
integer x = 1586
integer y = 256
integer width = 731
integer height = 84
boolean bringtotop = true
integer textsize = -12
string text = "Target Location"
end type

type gb_1 from so_groupbox within w_prd_fg_inv_loc_move
integer x = 9
integer y = 196
integer width = 2533
integer height = 284
integer weight = 700
long textcolor = 16711680
string text = "Condition"
end type

type gb_2 from so_groupbox within w_prd_fg_inv_loc_move
integer x = 2555
integer y = 196
integer width = 741
integer height = 284
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

