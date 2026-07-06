HA$PBExportHeader$w_pln_fg_delivery_info_input_popup.srw
$PBExportComments$$$HEX16$$a9b088d42000fcc828ccf1b458c7200015c8f4bc200085c725b820001bbc30ae$$ENDHEX$$
forward
global type w_pln_fg_delivery_info_input_popup from w_none_dw_popup_root
end type
type st_origin from so_statictext within w_pln_fg_delivery_info_input_popup
end type
type sle_pack_barcode from so_singlelineedit within w_pln_fg_delivery_info_input_popup
end type
type st_status from statictext within w_pln_fg_delivery_info_input_popup
end type
type st_model from so_statictext within w_pln_fg_delivery_info_input_popup
end type
type st_1 from so_statictext within w_pln_fg_delivery_info_input_popup
end type
type st_2 from so_statictext within w_pln_fg_delivery_info_input_popup
end type
type st_partno from so_statictext within w_pln_fg_delivery_info_input_popup
end type
type st_3 from so_statictext within w_pln_fg_delivery_info_input_popup
end type
type st_pack_qty from so_statictext within w_pln_fg_delivery_info_input_popup
end type
type st_4 from so_statictext within w_pln_fg_delivery_info_input_popup
end type
type uo_delivery_date from uo_ymd_calendar within w_pln_fg_delivery_info_input_popup
end type
type st_5 from so_statictext within w_pln_fg_delivery_info_input_popup
end type
type sle_pcb_week from so_singlelineedit within w_pln_fg_delivery_info_input_popup
end type
type st_6 from so_statictext within w_pln_fg_delivery_info_input_popup
end type
type sle_prod_week from so_singlelineedit within w_pln_fg_delivery_info_input_popup
end type
type st_7 from so_statictext within w_pln_fg_delivery_info_input_popup
end type
type sle_customer_model from so_singlelineedit within w_pln_fg_delivery_info_input_popup
end type
type st_8 from so_statictext within w_pln_fg_delivery_info_input_popup
end type
type sle_fpcb_rev from so_singlelineedit within w_pln_fg_delivery_info_input_popup
end type
type st_9 from so_statictext within w_pln_fg_delivery_info_input_popup
end type
type sle_pack_charger from so_singlelineedit within w_pln_fg_delivery_info_input_popup
end type
type st_10 from so_statictext within w_pln_fg_delivery_info_input_popup
end type
type mle_notes from so_multilineedit within w_pln_fg_delivery_info_input_popup
end type
type cb_update from so_commandbutton within w_pln_fg_delivery_info_input_popup
end type
type sle_qc_pack_charger from so_singlelineedit within w_pln_fg_delivery_info_input_popup
end type
type st_11 from so_statictext within w_pln_fg_delivery_info_input_popup
end type
type gb_1 from so_groupbox within w_pln_fg_delivery_info_input_popup
end type
end forward

global type w_pln_fg_delivery_info_input_popup from w_none_dw_popup_root
integer width = 2277
integer height = 2188
st_origin st_origin
sle_pack_barcode sle_pack_barcode
st_status st_status
st_model st_model
st_1 st_1
st_2 st_2
st_partno st_partno
st_3 st_3
st_pack_qty st_pack_qty
st_4 st_4
uo_delivery_date uo_delivery_date
st_5 st_5
sle_pcb_week sle_pcb_week
st_6 st_6
sle_prod_week sle_prod_week
st_7 st_7
sle_customer_model sle_customer_model
st_8 st_8
sle_fpcb_rev sle_fpcb_rev
st_9 st_9
sle_pack_charger sle_pack_charger
st_10 st_10
mle_notes mle_notes
cb_update cb_update
sle_qc_pack_charger sle_qc_pack_charger
st_11 st_11
gb_1 gb_1
end type
global w_pln_fg_delivery_info_input_popup w_pln_fg_delivery_info_input_popup

on w_pln_fg_delivery_info_input_popup.create
int iCurrent
call super::create
this.st_origin=create st_origin
this.sle_pack_barcode=create sle_pack_barcode
this.st_status=create st_status
this.st_model=create st_model
this.st_1=create st_1
this.st_2=create st_2
this.st_partno=create st_partno
this.st_3=create st_3
this.st_pack_qty=create st_pack_qty
this.st_4=create st_4
this.uo_delivery_date=create uo_delivery_date
this.st_5=create st_5
this.sle_pcb_week=create sle_pcb_week
this.st_6=create st_6
this.sle_prod_week=create sle_prod_week
this.st_7=create st_7
this.sle_customer_model=create sle_customer_model
this.st_8=create st_8
this.sle_fpcb_rev=create sle_fpcb_rev
this.st_9=create st_9
this.sle_pack_charger=create sle_pack_charger
this.st_10=create st_10
this.mle_notes=create mle_notes
this.cb_update=create cb_update
this.sle_qc_pack_charger=create sle_qc_pack_charger
this.st_11=create st_11
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_origin
this.Control[iCurrent+2]=this.sle_pack_barcode
this.Control[iCurrent+3]=this.st_status
this.Control[iCurrent+4]=this.st_model
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.st_partno
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.st_pack_qty
this.Control[iCurrent+10]=this.st_4
this.Control[iCurrent+11]=this.uo_delivery_date
this.Control[iCurrent+12]=this.st_5
this.Control[iCurrent+13]=this.sle_pcb_week
this.Control[iCurrent+14]=this.st_6
this.Control[iCurrent+15]=this.sle_prod_week
this.Control[iCurrent+16]=this.st_7
this.Control[iCurrent+17]=this.sle_customer_model
this.Control[iCurrent+18]=this.st_8
this.Control[iCurrent+19]=this.sle_fpcb_rev
this.Control[iCurrent+20]=this.st_9
this.Control[iCurrent+21]=this.sle_pack_charger
this.Control[iCurrent+22]=this.st_10
this.Control[iCurrent+23]=this.mle_notes
this.Control[iCurrent+24]=this.cb_update
this.Control[iCurrent+25]=this.sle_qc_pack_charger
this.Control[iCurrent+26]=this.st_11
this.Control[iCurrent+27]=this.gb_1
end on

on w_pln_fg_delivery_info_input_popup.destroy
call super::destroy
destroy(this.st_origin)
destroy(this.sle_pack_barcode)
destroy(this.st_status)
destroy(this.st_model)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_partno)
destroy(this.st_3)
destroy(this.st_pack_qty)
destroy(this.st_4)
destroy(this.uo_delivery_date)
destroy(this.st_5)
destroy(this.sle_pcb_week)
destroy(this.st_6)
destroy(this.sle_prod_week)
destroy(this.st_7)
destroy(this.sle_customer_model)
destroy(this.st_8)
destroy(this.sle_fpcb_rev)
destroy(this.st_9)
destroy(this.sle_pack_charger)
destroy(this.st_10)
destroy(this.mle_notes)
destroy(this.cb_update)
destroy(this.sle_qc_pack_charger)
destroy(this.st_11)
destroy(this.gb_1)
end on

event ue_post_open;call super::ue_post_open;sle_pack_barcode.text = message.stringparm
sle_pack_barcode.setfocus()
sle_pack_barcode.triggerevent(modified!)
//f_play_sound("$$HEX6$$e8cd8cc1acc2bdb9a4c294ce$$ENDHEX$$.wav")
end event

event clicked;call super::clicked;sle_pack_barcode.setfocus()
end event

event open;call super::open;sle_pack_barcode.setfocus()
triggerevent("ue_post_open")
end event

type p_title from w_none_dw_popup_root`p_title within w_pln_fg_delivery_info_input_popup
integer width = 2240
end type

type cb_close from w_none_dw_popup_root`cb_close within w_pln_fg_delivery_info_input_popup
boolean visible = true
integer x = 1787
integer y = 264
integer width = 416
integer height = 224
integer taborder = 0
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_none_dw_popup_root`st_msg within w_pln_fg_delivery_info_input_popup
boolean visible = true
integer y = 0
string text = "Delivery Info"
end type

type st_origin from so_statictext within w_pln_fg_delivery_info_input_popup
integer x = 37
integer y = 268
integer width = 654
integer height = 108
boolean bringtotop = true
integer textsize = -14
integer weight = 700
string text = "Pack Barcode"
alignment alignment = left!
end type

type sle_pack_barcode from so_singlelineedit within w_pln_fg_delivery_info_input_popup
integer x = 37
integer y = 380
integer width = 1115
integer height = 108
integer taborder = 10
boolean bringtotop = true
integer textsize = -14
integer weight = 700
boolean enabled = false
textcase textcase = upper!
end type

event modified;call super::modified;if this.text = '' or isnull(this.text) then 
   this.setfocus( )
   return 
end if 
/******************************************
* $$HEX3$$74d5f9b22000$$ENDHEX$$Pack Barcode $$HEX8$$15c8f4bc7cb9200000ac38c828c6e4b2$$ENDHEX$$.
******************************************/
string lvs_barcode 
string lvs_model,lvs_part_no,lvs_delivery_date, lvs_pcb_week, lvs_prod_week, lvs_comments,lvs_pack_charger , lvs_qc_pack_charger, lvs_buyer_model, lvs_fcb_rev,lvs_pack_chargerr
long 	lvl_pack_qty 
//datetime lvd_date
		
lvs_barcode = this.text; 

select 
      y.model_name, 
	  y.customer_model_name, 
       x.part_no, 
       x.pack_qty, 
       //line_code, // $$HEX5$$7cb778c754cfdcb42000$$ENDHEX$$
       attr1,       	// $$HEX5$$9ccd58d57cc790c72000$$ENDHEX$$YYMMDD
       attr2,       	// PCB$$HEX4$$fcc828cc20002000$$ENDHEX$$1804
       attr3,       	// $$HEX8$$ddc0b0c0fcc828cc200020007cb778c7$$ENDHEX$$/$$HEX2$$fcc87cc5$$ENDHEX$$/$$HEX2$$d4c67cc7$$ENDHEX$$MDD/
       attr4,       	// COMMENT
                       //nvl(attr5,y.customer_model_name),        	// Buyer Model 
       attr6,       	// FCB Revision $$HEX8$$18c2bdc0200074d57cc5200068d52000$$ENDHEX$$
       nvl(attr7 , '-' )   ,  	// Customer
	   nvl(attr8 , '-' )    	// Customer
		 
//	  to_date(nvl(attr1,to_char(sysdate,'yymmdd')),'YYMMDD')
     
 into 	:lvs_model, 
         :lvs_buyer_model, 
		:lvs_part_no, 
		:lvl_pack_qty, 
		:lvs_delivery_date, 
		:lvs_pcb_week, 
		:lvs_prod_week, 
		:lvs_comments, 
//		:lvs_buyer_model, 
		:lvs_fcb_rev,
		:lvs_pack_charger ,
		:lvs_qc_pack_charger
//		:lvd_date
	 
 from ip_product_pack_master  x, 
        ip_product_model_master y
where pack_barcode = :lvs_barcode  
  and x.organization_id = :gvi_organization_id 
  and x.model_name = y.model_name
  and x.organization_id = y.organization_id ; 
  
if f_sql_check() < 0 then 
	return
end if 
//messagebox('a',lvs_model)
ST_MODEL.TEXT 		= lvs_model 
ST_PARTNO.TEXT 	= lvs_part_no
st_pack_qty.text		= string(lvl_pack_qty) + ' PCS'
sle_pcb_week.text		= lvs_pcb_week 
sle_prod_week.text 	= lvs_prod_week
sle_customer_model.text		= lvs_buyer_model
sle_fpcb_rev.text		= lvs_fcb_rev
sle_pack_charger.text		= lvs_pack_charger
sle_qc_pack_charger.text		= lvs_qc_pack_charger
mle_notes.text			= lvs_comments
//uo_delivery_date.settext (string(lvd_date,'yyyy/mm/dd')) 

end event

type st_status from statictext within w_pln_fg_delivery_info_input_popup
integer x = 5
integer y = 1936
integer width = 2240
integer height = 160
boolean bringtotop = true
integer textsize = -20
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 65535
long backcolor = 16711680
string text = "Mesage"
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;sle_pack_barcode.setfocus()
end event

type st_model from so_statictext within w_pln_fg_delivery_info_input_popup
integer x = 805
integer y = 636
boolean bringtotop = true
integer textsize = -11
integer weight = 700
long textcolor = 255
string text = "MODEL"
alignment alignment = left!
end type

type st_1 from so_statictext within w_pln_fg_delivery_info_input_popup
integer x = 224
integer y = 636
boolean bringtotop = true
integer textsize = -11
integer weight = 700
string text = "Model :"
alignment alignment = right!
end type

type st_2 from so_statictext within w_pln_fg_delivery_info_input_popup
integer x = 224
integer y = 848
boolean bringtotop = true
integer textsize = -11
integer weight = 700
string text = "Part No :"
alignment alignment = right!
end type

type st_partno from so_statictext within w_pln_fg_delivery_info_input_popup
integer x = 805
integer y = 848
boolean bringtotop = true
integer textsize = -11
integer weight = 700
long textcolor = 255
string text = "Part No"
alignment alignment = left!
end type

type st_3 from so_statictext within w_pln_fg_delivery_info_input_popup
integer x = 224
integer y = 960
boolean bringtotop = true
integer textsize = -11
integer weight = 700
string text = "Pack Qty :"
alignment alignment = right!
end type

type st_pack_qty from so_statictext within w_pln_fg_delivery_info_input_popup
integer x = 805
integer y = 960
boolean bringtotop = true
integer textsize = -11
integer weight = 700
long textcolor = 255
string text = "300"
alignment alignment = left!
end type

type st_4 from so_statictext within w_pln_fg_delivery_info_input_popup
integer x = 192
integer y = 1060
integer width = 530
boolean bringtotop = true
integer textsize = -11
integer weight = 700
string text = "Delivery Date :"
alignment alignment = right!
end type

type uo_delivery_date from uo_ymd_calendar within w_pln_fg_delivery_info_input_popup
integer x = 805
integer y = 1056
integer taborder = 20
boolean bringtotop = true
end type

on uo_delivery_date.destroy
call uo_ymd_calendar::destroy
end on

type st_5 from so_statictext within w_pln_fg_delivery_info_input_popup
integer x = 192
integer y = 1184
integer width = 530
boolean bringtotop = true
integer textsize = -11
integer weight = 700
string text = "PCB Week :"
alignment alignment = right!
end type

type sle_pcb_week from so_singlelineedit within w_pln_fg_delivery_info_input_popup
integer x = 805
integer y = 1184
integer width = 1358
integer taborder = 40
boolean bringtotop = true
integer textsize = -11
end type

type st_6 from so_statictext within w_pln_fg_delivery_info_input_popup
integer x = 192
integer y = 1304
integer width = 530
boolean bringtotop = true
integer textsize = -11
integer weight = 700
string text = "PROD. Week :"
alignment alignment = right!
end type

type sle_prod_week from so_singlelineedit within w_pln_fg_delivery_info_input_popup
integer x = 805
integer y = 1304
integer width = 1358
integer taborder = 50
boolean bringtotop = true
integer textsize = -11
end type

type st_7 from so_statictext within w_pln_fg_delivery_info_input_popup
integer x = 114
integer y = 744
integer width = 608
boolean bringtotop = true
integer textsize = -11
integer weight = 700
string text = "Customer Model :"
alignment alignment = right!
end type

type sle_customer_model from so_singlelineedit within w_pln_fg_delivery_info_input_popup
integer x = 805
integer y = 732
integer width = 1358
integer height = 96
integer taborder = 50
boolean bringtotop = true
integer textsize = -11
end type

type st_8 from so_statictext within w_pln_fg_delivery_info_input_popup
integer x = 192
integer y = 1412
integer width = 530
boolean bringtotop = true
integer textsize = -11
integer weight = 700
string text = "FPCB Rev. :"
alignment alignment = right!
end type

type sle_fpcb_rev from so_singlelineedit within w_pln_fg_delivery_info_input_popup
integer x = 805
integer y = 1412
integer width = 1358
integer taborder = 50
boolean bringtotop = true
integer textsize = -11
end type

type st_9 from so_statictext within w_pln_fg_delivery_info_input_popup
integer x = 192
integer y = 1524
integer width = 530
boolean bringtotop = true
integer textsize = -11
integer weight = 700
string text = "Pack Charger :"
alignment alignment = right!
end type

type sle_pack_charger from so_singlelineedit within w_pln_fg_delivery_info_input_popup
integer x = 805
integer y = 1520
integer width = 338
integer taborder = 60
boolean bringtotop = true
integer textsize = -11
end type

type st_10 from so_statictext within w_pln_fg_delivery_info_input_popup
integer x = 192
integer y = 1628
integer width = 530
boolean bringtotop = true
integer textsize = -11
integer weight = 700
string text = "Notes :"
alignment alignment = right!
end type

type mle_notes from so_multilineedit within w_pln_fg_delivery_info_input_popup
integer x = 805
integer y = 1620
integer width = 1358
integer height = 300
integer taborder = 70
boolean bringtotop = true
string text = "Note"
end type

type cb_update from so_commandbutton within w_pln_fg_delivery_info_input_popup
integer x = 1371
integer y = 264
integer width = 416
integer height = 224
integer taborder = 40
boolean bringtotop = true
string text = "Save"
end type

event clicked;call super::clicked;string lvs_barcode 
string lvs_model,lvs_part_no,lvs_delivery_date, lvs_pcb_week, lvs_prod_week, lvs_comments , lvs_qc_pack_charger , lvs_buyer_model, lvs_fcb_rev,lvs_pack_charger
long 	lvl_pack_qty 
datetime lvd_date


lvs_barcode=			sle_pack_barcode.text
lvs_pcb_week = 		sle_pcb_week.text 
lvs_prod_week = 		sle_prod_week.text
lvs_buyer_model=		sle_customer_model.text
lvs_fcb_rev=			sle_fpcb_rev.text	
lvs_pack_charger=			sle_pack_charger.text
lvs_comments=		mle_notes.text
lvd_date=				uo_delivery_date.text()  

update ip_product_pack_master
set		attr1=to_char(:lvd_date,'YYMMDD'),
		attr2=:lvs_pcb_week,
		attr3=:lvs_prod_week,
		attr4=:lvs_comments,
		attr5=:lvs_buyer_model,
		attr6=:lvs_fcb_rev, 
		attr7=:lvs_pack_charger,
		attr8=:lvs_qc_pack_charger
		
where pack_barcode =:lvs_barcode
and organization_id = :gvi_organization_id ; 

if f_sql_check() < 0 then 
	rollback ; 
	return
end if 

commit ; 

close(parent)
end event

type sle_qc_pack_charger from so_singlelineedit within w_pln_fg_delivery_info_input_popup
integer x = 1874
integer y = 1520
integer width = 279
integer taborder = 80
boolean bringtotop = true
integer textsize = -11
end type

type st_11 from so_statictext within w_pln_fg_delivery_info_input_popup
integer x = 1198
integer y = 1520
integer width = 635
boolean bringtotop = true
integer textsize = -11
integer weight = 700
string text = "QC Pack Charger :"
alignment alignment = right!
end type

type gb_1 from so_groupbox within w_pln_fg_delivery_info_input_popup
integer x = 14
integer y = 204
integer width = 2226
integer height = 320
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

