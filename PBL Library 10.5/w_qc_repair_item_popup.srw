HA$PBExportHeader$w_qc_repair_item_popup.srw
$PBExportComments$(Sal Customerr Query)-$$HEX5$$70ac98b798cc70c88cd6$$ENDHEX$$
forward
global type w_qc_repair_item_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_qc_repair_item_popup
end type
type cb_1 from so_commandbutton within w_qc_repair_item_popup
end type
type cb_2 from so_commandbutton within w_qc_repair_item_popup
end type
type cb_3 from so_commandbutton within w_qc_repair_item_popup
end type
type sle_run_no from so_singlelineedit within w_qc_repair_item_popup
end type
type st_mrm_no from statictext within w_qc_repair_item_popup
end type
type sle_qc_sequence from so_singlelineedit within w_qc_repair_item_popup
end type
type st_1 from statictext within w_qc_repair_item_popup
end type
type ddlb_item_code from uo_item_code within w_qc_repair_item_popup
end type
type st_2 from so_statictext within w_qc_repair_item_popup
end type
type sle_our_barcode from so_singlelineedit within w_qc_repair_item_popup
end type
type st_11 from so_statictext within w_qc_repair_item_popup
end type
type sle_material_mfs from so_singlelineedit within w_qc_repair_item_popup
end type
type st_5 from so_statictext within w_qc_repair_item_popup
end type
type gb_1 from so_groupbox within w_qc_repair_item_popup
end type
type gb_2 from so_groupbox within w_qc_repair_item_popup
end type
end forward

global type w_qc_repair_item_popup from w_popup_root
integer width = 5079
integer height = 2628
string title = "Customer Master Popup"
cb_retrieve cb_retrieve
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
sle_run_no sle_run_no
st_mrm_no st_mrm_no
sle_qc_sequence sle_qc_sequence
st_1 st_1
ddlb_item_code ddlb_item_code
st_2 st_2
sle_our_barcode sle_our_barcode
st_11 st_11
sle_material_mfs sle_material_mfs
st_5 st_5
gb_1 gb_1
gb_2 gb_2
end type
global w_qc_repair_item_popup w_qc_repair_item_popup

on w_qc_repair_item_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.sle_run_no=create sle_run_no
this.st_mrm_no=create st_mrm_no
this.sle_qc_sequence=create sle_qc_sequence
this.st_1=create st_1
this.ddlb_item_code=create ddlb_item_code
this.st_2=create st_2
this.sle_our_barcode=create sle_our_barcode
this.st_11=create st_11
this.sle_material_mfs=create sle_material_mfs
this.st_5=create st_5
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.cb_3
this.Control[iCurrent+5]=this.sle_run_no
this.Control[iCurrent+6]=this.st_mrm_no
this.Control[iCurrent+7]=this.sle_qc_sequence
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.ddlb_item_code
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.sle_our_barcode
this.Control[iCurrent+12]=this.st_11
this.Control[iCurrent+13]=this.sle_material_mfs
this.Control[iCurrent+14]=this.st_5
this.Control[iCurrent+15]=this.gb_1
this.Control[iCurrent+16]=this.gb_2
end on

on w_qc_repair_item_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.sle_run_no)
destroy(this.st_mrm_no)
destroy(this.sle_qc_sequence)
destroy(this.st_1)
destroy(this.ddlb_item_code)
destroy(this.st_2)
destroy(this.sle_our_barcode)
destroy(this.st_11)
destroy(this.sle_material_mfs)
destroy(this.st_5)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;dw_1.settransobject(sqlca)

SLE_RUN_NO.TEXT = MESSAGE.STRINGPARM
SLE_QC_SEQUENCE.TEXT = GST_RETURN.GVS_return[1]

CB_RETRIEVE.TRIGGEREVENT(CLICKED!)

end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
end if
end event

type p_title from w_popup_root`p_title within w_qc_repair_item_popup
integer width = 5079
end type

type cb_sort from w_popup_root`cb_sort within w_qc_repair_item_popup
integer x = 2615
integer y = 300
integer height = 172
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_qc_repair_item_popup
boolean visible = true
integer x = 4649
integer y = 296
integer width = 393
integer height = 172
integer taborder = 0
end type

type st_msg from w_popup_root`st_msg within w_qc_repair_item_popup
boolean visible = true
integer x = 5
integer y = 532
integer width = 5083
end type

type dw_1 from w_popup_root`dw_1 within w_qc_repair_item_popup
boolean visible = true
integer y = 632
integer width = 5093
integer height = 1912
integer taborder = 30
boolean titlebar = true
string title = "Customer List"
string dataobject = "d_qc_repair_item_popup"
end type

event dw_1::rbuttondown;call super::rbuttondown;if dwo.name = 'item_code' then 
	
	open(	w_des_item_popup )
	if Gst_return.gvb_return = true then 
		this.object.item_code[row] = MESSAGE.STRINGPARM
	end if 
	
end if 
end event

type dw_2 from w_popup_root`dw_2 within w_qc_repair_item_popup
boolean visible = true
integer y = 800
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_qc_repair_item_popup
integer y = 640
end type

type cb_retrieve from so_commandbutton within w_qc_repair_item_popup
integer x = 3072
integer y = 292
integer width = 393
integer height = 172
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;call super::clicked;dw_1.retrieve( sle_run_no.text , sle_qc_sequence.text , gvi_organization_id )


end event

type cb_1 from so_commandbutton within w_qc_repair_item_popup
integer x = 3470
integer y = 292
integer width = 393
integer height = 172
integer taborder = 30
boolean bringtotop = true
string text = "Insert"
end type

event clicked;call super::clicked;long ll_row
ll_row = dw_1.insertrow(1)
dw_1.scrolltorow(ll_row)
F_SET_SECURITY_ROW(DW_1 , LL_ROW, 'ALL')

dw_1.object.run_no[ll_row] = sle_run_no.text
dw_1.object.qc_sequence[ll_row] = double(sle_qc_sequence.text)
dw_1.object.material_mfs[ll_row] = sle_material_mfs.text
dw_1.object.item_code[ll_row] = ddlb_item_code.text
end event

type cb_2 from so_commandbutton within w_qc_repair_item_popup
integer x = 3863
integer y = 292
integer width = 393
integer height = 172
integer taborder = 40
boolean bringtotop = true
string text = "Delete"
end type

event clicked;call super::clicked;if dw_1.getrow() < 1 then return
msg = f_msgbox1(1161 , this.text)
if msg = 1 then 
	dw_1.deleterow( dw_1.getrow())
end if 
end event

type cb_3 from so_commandbutton within w_qc_repair_item_popup
integer x = 4256
integer y = 296
integer width = 393
integer height = 172
integer taborder = 50
boolean bringtotop = true
string text = "Update"
end type

event clicked;call super::clicked;if dw_1.update() < 0 then 
	rollback;
else
	commit;
	f_msgbox(170)
end if 
end event

type sle_run_no from so_singlelineedit within w_qc_repair_item_popup
integer x = 46
integer y = 388
integer width = 443
integer taborder = 60
boolean bringtotop = true
textcase textcase = upper!
end type

type st_mrm_no from statictext within w_qc_repair_item_popup
integer x = 46
integer y = 308
integer width = 443
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Run No"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_qc_sequence from so_singlelineedit within w_qc_repair_item_popup
integer x = 498
integer y = 384
integer width = 347
integer taborder = 70
boolean bringtotop = true
textcase textcase = upper!
end type

type st_1 from statictext within w_qc_repair_item_popup
integer x = 498
integer y = 308
integer width = 347
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "QC Sequence"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_item_code from uo_item_code within w_qc_repair_item_popup
integer x = 1824
integer y = 384
integer width = 512
integer height = 1484
integer taborder = 30
boolean bringtotop = true
end type

type st_2 from so_statictext within w_qc_repair_item_popup
integer x = 1815
integer y = 308
integer width = 512
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type sle_our_barcode from so_singlelineedit within w_qc_repair_item_popup
integer x = 850
integer y = 384
integer width = 960
integer height = 84
integer taborder = 40
boolean bringtotop = true
end type

event modified;call super::modified;int lvi_pos1 , lvi_pos2
string lvs_our_barcode  , lvs_item_code , lvs_lot_no 
lvs_our_barcode = this.text 

////=======================================
//// $$HEX11$$00cf3cd554cf200090c7acc778c72000bdacb0c62000$$ENDHEX$$
////=======================================
// IF MID (UPPER (lvs_our_barcode), 1, 1) = '['    THEN
//         SELECT  f_get_item_code_from_barcode (:lvs_our_barcode)|| '-' || f_get_lot_no_from_barcode (:lvs_our_barcode) || '-' || f_get_lot_qty_from_barcode (:lvs_our_barcode)
//		    INTO :lvs_our_barcode
//	       FROM DUAL ; 
//		
//		IF F_SQL_CHECK() < 0 THEN 
//				this.selecttext( 1,100)	
//		END IF 	 
//ELSE
//		 SELECT  f_get_prepare_barcode (:lvs_our_barcode)
//		     INTO :lvs_our_barcode
//	       FROM DUAL ; 
//		
//		IF F_SQL_CHECK() < 0 THEN 
//				this.selecttext( 1,100)	
//		END IF 	 
//END IF 


//===================================================
//
//===================================================
//lvi_pos1 =  pos(lvs_our_barcode , '-' , 7 ) 
//
//if  lvi_pos1 <= 0 then 
//	
//	f_msgbox1(1175 ,lvs_our_barcode )
//	sle_our_barcode.text = ''
//	sle_our_barcode.setfocus()
//	return -1 
//	
//end if 

//=================================================
//
//=================================================

//lvs_item_code = trim( mid( lvs_our_barcode , 1 ,  lvi_pos1 -1 ))

	SELECT  f_get_item_code_from_barcode (:lvs_our_barcode) 
	INTO :lvs_item_code
	FROM DUAL ; 
	
	IF F_SQL_CHECK() < 0 THEN 
		sle_our_barcode.selecttext( 1,100)	
	END IF 	 
	
	if  lvs_item_code = '' then 
		
		f_play_sound("$$HEX5$$88d4a9baf8bbf1b45db8$$ENDHEX$$.wav")
		f_msgbox1(1175 ,lvs_our_barcode )
		sle_our_barcode.setfocus()
		sle_our_barcode.selecttext( 1,100)
		return 
	end if 
	

if f_check_item_exists( lvs_item_code , f_t_sysdate())  <= 0 then 
	f_play_sound("$$HEX5$$88d4a9baf8bbf1b45db8$$ENDHEX$$.wav")	
	f_msgbox(9041) //$$HEX10$$fcd3a9bac8b9a4c230d12000f8bbf1b45db82000$$ENDHEX$$

	sle_our_barcode.text = ''
	sle_our_barcode.setfocus()
	return -1
end if 

//==================================================
// $$HEX6$$6fb8b8d2200088bc38d62000$$ENDHEX$$
//==================================================
//lvi_pos2 =  pos(lvs_our_barcode , '-' , lvi_pos1+1 ) 
//
//if  lvi_pos2 <= 0 then 
//
//	lvs_lot_no = trim( mid( lvs_our_barcode , lvi_pos1+1 ,  100 ))	
//else
//	lvs_lot_no = trim( mid( lvs_our_barcode , lvi_pos1+1 ,   lvi_pos2 - lvi_pos1 -1 ))
//end if 
//
//if lvs_lot_no = ''  then 
//	sle_our_barcode.text = ''
//	sle_our_barcode.setfocus()
//	return -1
//end if 

SELECT  F_GET_LOT_NO_FROM_BARCODE (:lvs_our_barcode ) 
	INTO :lvs_lot_no
	FROM DUAL ; 
	
	IF F_SQL_CHECK() < 0 THEN 
		sle_our_barcode.selecttext( 1,100)	
	END IF 	 

	if lvs_lot_no = ''  then 
		f_msg( "$$HEX15$$6fb8b8d288bc38d600ac20002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$",'P')
		sle_our_barcode.setfocus()
		sle_our_barcode.selecttext( 1,100)	
		return
	end if 

ddlb_item_code.text = lvs_item_code
sle_material_mfs.text = lvs_lot_no
this.selecttext( 1,100)
f_retrieve()

end event

type st_11 from so_statictext within w_qc_repair_item_popup
integer x = 850
integer y = 308
integer width = 960
integer height = 68
boolean bringtotop = true
integer weight = 700
long textcolor = 255
string text = "Barcode"
end type

type sle_material_mfs from so_singlelineedit within w_qc_repair_item_popup
integer x = 2341
integer y = 384
integer width = 681
integer height = 84
integer taborder = 60
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

type st_5 from so_statictext within w_qc_repair_item_popup
integer x = 2331
integer y = 308
integer width = 681
integer height = 68
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Material MFS"
end type

type gb_1 from so_groupbox within w_qc_repair_item_popup
integer x = 3040
integer y = 216
integer width = 2025
integer height = 304
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_qc_repair_item_popup
integer y = 216
integer width = 3035
integer height = 304
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

