HA$PBExportHeader$w_prd_fg_magazine_divide.srw
$PBExportComments$(Item Query)-$$HEX4$$80bd88d470c88cd6$$ENDHEX$$
forward
global type w_prd_fg_magazine_divide from w_popup_root
end type
type cb_select from commandbutton within w_prd_fg_magazine_divide
end type
type st_2 from so_statictext within w_prd_fg_magazine_divide
end type
type sle_magazine from so_singlelineedit within w_prd_fg_magazine_divide
end type
type em_qty from so_editmask within w_prd_fg_magazine_divide
end type
type em_div from so_editmask within w_prd_fg_magazine_divide
end type
type gb_1 from so_groupbox within w_prd_fg_magazine_divide
end type
type gb_2 from so_groupbox within w_prd_fg_magazine_divide
end type
end forward

global type w_prd_fg_magazine_divide from w_popup_root
integer width = 3323
integer height = 1228
string title = "Location Barcode Popup"
cb_select cb_select
st_2 st_2
sle_magazine sle_magazine
em_qty em_qty
em_div em_div
gb_1 gb_1
gb_2 gb_2
end type
global w_prd_fg_magazine_divide w_prd_fg_magazine_divide

on w_prd_fg_magazine_divide.create
int iCurrent
call super::create
this.cb_select=create cb_select
this.st_2=create st_2
this.sle_magazine=create sle_magazine
this.em_qty=create em_qty
this.em_div=create em_div
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_select
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.sle_magazine
this.Control[iCurrent+4]=this.em_qty
this.Control[iCurrent+5]=this.em_div
this.Control[iCurrent+6]=this.gb_1
this.Control[iCurrent+7]=this.gb_2
end on

on w_prd_fg_magazine_divide.destroy
call super::destroy
destroy(this.cb_select)
destroy(this.st_2)
destroy(this.sle_magazine)
destroy(this.em_qty)
destroy(this.em_div)
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

type p_title from w_popup_root`p_title within w_prd_fg_magazine_divide
integer width = 3314
integer height = 188
integer textsize = -24
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
long textcolor = 16777215
long backcolor = 16777215
string text = "Magazine Divide"
end type

type cb_sort from w_popup_root`cb_sort within w_prd_fg_magazine_divide
integer x = 1979
integer y = 292
integer height = 144
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_prd_fg_magazine_divide
boolean visible = true
integer x = 2962
integer y = 292
integer width = 315
integer height = 144
integer taborder = 0
end type

event cb_close::clicked;call super::clicked;//gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_prd_fg_magazine_divide
boolean visible = true
integer y = 488
integer width = 3314
end type

type dw_1 from w_popup_root`dw_1 within w_prd_fg_magazine_divide
boolean visible = true
integer y = 580
integer width = 3310
integer height = 552
integer taborder = 0
string dataobject = "d_product_fg_inventory_divide"
end type

type dw_2 from w_popup_root`dw_2 within w_prd_fg_magazine_divide
boolean visible = true
integer y = 588
integer width = 1847
integer height = 400
integer taborder = 0
string dataobject = "d_product_fg_magazine_label_rpt"
end type

type dw_3 from w_popup_root`dw_3 within w_prd_fg_magazine_divide
integer y = 864
integer taborder = 30
end type

type cb_select from commandbutton within w_prd_fg_magazine_divide
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
string text = "Divide"
boolean default = true
end type

event clicked;long lvl_qty , lvl_divide_qty 

lvl_qty = long(em_qty.text)
lvl_divide_qty = long(em_div.text)


if lvl_qty < 1 then 
	f_msg ('$$HEX9$$84bd60d500aca5b22000acc7e0ac00ac2000$$ENDHEX$$0 $$HEX3$$85c7c8b2e4b2$$ENDHEX$$.','P')
	return 
end if 

if lvl_divide_qty < 1 or em_div.text = '' then
	f_msg('$$HEX13$$84bd60d5200018c2c9b744c7200085c725b8200058d538c194c6$$ENDHEX$$', 'P') 
    return
end if 

if lvl_qty = lvl_divide_qty then 
	f_msg('$$HEX23$$84bd60d5200018c2c9b7fcac200084bd60d5200000aca5b2200018c2c9b774c72000d9b37cc7200069d5c8b2e4b2$$ENDHEX$$','P') 
	return
end if 

if lvl_qty < lvl_divide_qty then 
	f_msg('$$HEX17$$84bd60d5200018c2c9b774c72000acc7e0ac18c2c9b7f4bce4b220007dd0c8b2e4b2$$ENDHEX$$.','P') 
	return 
end if 

//=================================================
//Unpack $$HEX3$$7cc74cb52000$$ENDHEX$$
//=================================================
string lvs_out , lvs_outmsg, lvs_barcode, lvs_location, lvs_commit
long lvl_txn_type, lvl_row
lvs_out = space(4000)
lvs_outmsg = space(4000)

lvs_barcode = sle_magazine.text 
lvs_commit = 'Y' 

//OUT $$HEX8$$c0bc18c294b2200048c5f0c40cc92000$$ENDHEX$$fETCH $$HEX2$$d0c51cc1$$ENDHEX$$
declare proc procedure for P_PRODUCT_FG_INV_DEVIDE ( :lvs_barcode , :lvl_divide_qty , :lvs_commit   ) 
using sqlca ; 

execute proc ; 
fetch proc into :lvs_out, :lvs_outmsg ; 
close proc ; 

if f_sql_check() < 0 then
	return
end if 

if lvs_out = 'NG' then 
	messagebox('NG',lvs_outmsg)
	st_msg.text = f_msg('$$HEX11$$84bd60d52000e4c228d3200058d500c6b5c2c8b2e4b2$$ENDHEX$$.','S') + ' ' +lvs_outmsg 
	
	sle_magazine.text = '' 
	sle_magazine.setfocus() 
	dw_1.reset()
	return
end if 

//Messagebox('Success', f_msg('$$HEX11$$84bd60d5200044c6ccb8200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$.','S') +'~r' + lvs_out +  '~r' + lvs_outmsg)
st_msg.text = f_msg('$$HEX11$$84bd60d5200044c6ccb8200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$.','S') 

dw_2.retrieve(lvs_barcode+'-A')
dw_2.print()
dw_2.retrieve(lvs_barcode+'-B')
dw_2.print()

dw_1.reset()
dw_2.reset()

em_qty.text = '0'
em_div.text = '0'

sle_magazine.text = '' 
sle_magazine.setfocus() 
end event

type st_2 from so_statictext within w_prd_fg_magazine_divide
integer x = 55
integer y = 280
integer width = 718
integer height = 56
boolean bringtotop = true
string text = "Magazine"
end type

type sle_magazine from so_singlelineedit within w_prd_fg_magazine_divide
integer x = 55
integer y = 356
integer width = 718
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
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

dw_1.retrieve(this.text)

if dw_1.rowcount() < 1 then 
	f_msg('$$HEX15$$84bd60d5200000aca5b25cd52000acc7e0ac00ac2000c6c5b5c2c8b2e4b2$$ENDHEX$$','P') 
	this.text = '' 
	this.setfocus()
end if 

select pack_type, 
       location_code, 
       qty, 
       pallet_flag
   into :lvs_pack_type, 
	     :lvs_location,
		 :lvl_qty, :lvs_pallet_flag 
  from ip_product_fg_inventory x
 where barcode = :this.text ; 
 
 em_qty.text = string(lvl_qty) 
 
 if f_sql_check() < 0 then 
	dw_1.reset() 
	this.text = ''
	this.setfocus()
end if 

end event

type em_qty from so_editmask within w_prd_fg_magazine_divide
integer x = 782
integer y = 360
integer taborder = 10
boolean bringtotop = true
boolean enabled = false
string text = "0"
string mask = "###,###"
end type

type em_div from so_editmask within w_prd_fg_magazine_divide
integer x = 1193
integer y = 360
integer taborder = 10
boolean bringtotop = true
string text = "0"
string mask = "###,###"
end type

type gb_1 from so_groupbox within w_prd_fg_magazine_divide
integer x = 9
integer y = 196
integer width = 1957
integer height = 284
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_prd_fg_magazine_divide
integer x = 2555
integer y = 196
integer width = 741
integer height = 284
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

