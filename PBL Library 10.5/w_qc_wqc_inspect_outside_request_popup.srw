HA$PBExportHeader$w_qc_wqc_inspect_outside_request_popup.srw
forward
global type w_qc_wqc_inspect_outside_request_popup from w_popup_root
end type
type cb_retrieve from commandbutton within w_qc_wqc_inspect_outside_request_popup
end type
type cb_select from commandbutton within w_qc_wqc_inspect_outside_request_popup
end type
type sle_item_code from singlelineedit within w_qc_wqc_inspect_outside_request_popup
end type
type st_2 from statictext within w_qc_wqc_inspect_outside_request_popup
end type
type sle_item_name from singlelineedit within w_qc_wqc_inspect_outside_request_popup
end type
type st_1 from statictext within w_qc_wqc_inspect_outside_request_popup
end type
type st_7 from statictext within w_qc_wqc_inspect_outside_request_popup
end type
type sle_1 from singlelineedit within w_qc_wqc_inspect_outside_request_popup
end type
type ddlb_bring_in_yn from uo_basecode within w_qc_wqc_inspect_outside_request_popup
end type
type st_3 from statictext within w_qc_wqc_inspect_outside_request_popup
end type
type ddlb_carrying_out_by from uo_user_id_name within w_qc_wqc_inspect_outside_request_popup
end type
type st_4 from statictext within w_qc_wqc_inspect_outside_request_popup
end type
type ddlb_carrying_out_receiptor from uo_supplier_code within w_qc_wqc_inspect_outside_request_popup
end type
type st_5 from statictext within w_qc_wqc_inspect_outside_request_popup
end type
type cb_group_no from so_commandbutton within w_qc_wqc_inspect_outside_request_popup
end type
type sle_group_no from so_singlelineedit within w_qc_wqc_inspect_outside_request_popup
end type
type gb_2 from so_groupbox within w_qc_wqc_inspect_outside_request_popup
end type
type gb_3 from so_groupbox within w_qc_wqc_inspect_outside_request_popup
end type
type gb_1 from so_groupbox within w_qc_wqc_inspect_outside_request_popup
end type
end forward

global type w_qc_wqc_inspect_outside_request_popup from w_popup_root
integer width = 3913
integer height = 2256
cb_retrieve cb_retrieve
cb_select cb_select
sle_item_code sle_item_code
st_2 st_2
sle_item_name sle_item_name
st_1 st_1
st_7 st_7
sle_1 sle_1
ddlb_bring_in_yn ddlb_bring_in_yn
st_3 st_3
ddlb_carrying_out_by ddlb_carrying_out_by
st_4 st_4
ddlb_carrying_out_receiptor ddlb_carrying_out_receiptor
st_5 st_5
cb_group_no cb_group_no
sle_group_no sle_group_no
gb_2 gb_2
gb_3 gb_3
gb_1 gb_1
end type
global w_qc_wqc_inspect_outside_request_popup w_qc_wqc_inspect_outside_request_popup

type variables
datawindow idw_parm
end variables

on w_qc_wqc_inspect_outside_request_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.sle_item_code=create sle_item_code
this.st_2=create st_2
this.sle_item_name=create sle_item_name
this.st_1=create st_1
this.st_7=create st_7
this.sle_1=create sle_1
this.ddlb_bring_in_yn=create ddlb_bring_in_yn
this.st_3=create st_3
this.ddlb_carrying_out_by=create ddlb_carrying_out_by
this.st_4=create st_4
this.ddlb_carrying_out_receiptor=create ddlb_carrying_out_receiptor
this.st_5=create st_5
this.cb_group_no=create cb_group_no
this.sle_group_no=create sle_group_no
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.sle_item_code
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.sle_item_name
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.st_7
this.Control[iCurrent+8]=this.sle_1
this.Control[iCurrent+9]=this.ddlb_bring_in_yn
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.ddlb_carrying_out_by
this.Control[iCurrent+12]=this.st_4
this.Control[iCurrent+13]=this.ddlb_carrying_out_receiptor
this.Control[iCurrent+14]=this.st_5
this.Control[iCurrent+15]=this.cb_group_no
this.Control[iCurrent+16]=this.sle_group_no
this.Control[iCurrent+17]=this.gb_2
this.Control[iCurrent+18]=this.gb_3
this.Control[iCurrent+19]=this.gb_1
end on

on w_qc_wqc_inspect_outside_request_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.sle_item_code)
destroy(this.st_2)
destroy(this.sle_item_name)
destroy(this.st_1)
destroy(this.st_7)
destroy(this.sle_1)
destroy(this.ddlb_bring_in_yn)
destroy(this.st_3)
destroy(this.ddlb_carrying_out_by)
destroy(this.st_4)
destroy(this.ddlb_carrying_out_receiptor)
destroy(this.st_5)
destroy(this.cb_group_no)
destroy(this.sle_group_no)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_1)
end on

event activate;call super::activate;//===============================
//
//===============================
IVS_RESIZE_TYPE = 'NORMAL'
IVS_MOUSEMOVE_YN = 'N'

end event

event ue_post_open;call super::ue_post_open;cb_retrieve.triggerevent(clicked!)
end event

event open;call super::open;idw_parm = message.powerobjectparm
end event

type p_title from w_popup_root`p_title within w_qc_wqc_inspect_outside_request_popup
integer width = 3913
end type

type cb_sort from w_popup_root`cb_sort within w_qc_wqc_inspect_outside_request_popup
boolean visible = true
integer x = 32
integer y = 660
integer width = 366
end type

type cb_close from w_popup_root`cb_close within w_qc_wqc_inspect_outside_request_popup
boolean visible = true
integer x = 2309
integer y = 656
integer width = 366
end type

type st_msg from w_popup_root`st_msg within w_qc_wqc_inspect_outside_request_popup
boolean visible = true
integer y = 476
integer width = 3913
end type

type dw_1 from w_popup_root`dw_1 within w_qc_wqc_inspect_outside_request_popup
boolean visible = true
integer y = 836
integer width = 3913
integer height = 1288
boolean titlebar = true
string title = "WQC Inspect Result List"
string dataobject = "d_qc_wqc_inspect_outside_reuqest_popup"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
cb_select.triggerevent(clicked!)
end event

type dw_2 from w_popup_root`dw_2 within w_qc_wqc_inspect_outside_request_popup
boolean visible = true
integer y = 840
integer width = 425
integer height = 324
end type

type dw_3 from w_popup_root`dw_3 within w_qc_wqc_inspect_outside_request_popup
boolean visible = true
integer y = 840
integer width = 425
integer height = 324
end type

type cb_retrieve from commandbutton within w_qc_wqc_inspect_outside_request_popup
integer x = 402
integer y = 660
integer width = 366
integer height = 100
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve"
end type

event clicked;dw_1.reset( )
DW_1.RETRIEVE(   sle_item_code.text+'%' ,  GVI_ORGANIZATION_ID  )
end event

type cb_select from commandbutton within w_qc_wqc_inspect_outside_request_popup
integer x = 1765
integer y = 656
integer width = 366
integer height = 100
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Select"
boolean default = true
end type

event clicked;long i  , rows
double lvd_seq
if dw_1.getrow() < 1 then 
	gst_return.gvb_return = false
	return -1 
end if 



if  ddlb_bring_in_yn.GETcode( ) = '' or isnull(ddlb_bring_in_yn.GETcode( )) then 
	Messagebox("Notify" , "Bring In YN Invalid" )
	return
end if

if  ddlb_carrying_out_receiptor.text = '' or isnull(ddlb_carrying_out_receiptor.text) then 
	Messagebox("Notify" , "Receiptor Invalid" )
	return
end if

if  ddlb_carrying_out_by.text = '' or isnull(ddlb_carrying_out_by.text) then 
	Messagebox("Notify" , "Carrying Out By Invalid" )
	return
end if

if  sle_group_no.text = '' or isnull(sle_group_no.text) then 
	msg = Messagebox("Notify" , "Carrying Out Group No Invalid Do You wish to Generate ?"  , stopsign! , yesno!)
	
	if msg = 1 then 
		
		cb_group_no.triggerevent( clicked!)
		
	else
		return
	end if
end if


 do
	
	i++
	
	
	if dw_1.object.check_yn[i] = 'Y' then 
	else
		continue
	end if
	
	dw_2.reset( )
			
	 rows = idw_parm.insertrow(0)
        F_SET_SECURITY_ROW(idw_parm , i , 'ALL')		
	
		idw_parm.object.carrying_out_type[rows] = 'C'
		idw_parm.object.carrying_out_division[rows] = 'I'	
		idw_parm.object.carrying_out_receiptor[rows] = ddlb_carrying_out_receiptor.text
		idw_parm.object.carrying_out_by[rows] = ddlb_carrying_out_by.getcode()
		idw_parm.object.bring_in_yn[rows] =	ddlb_bring_in_yn.getcode( )
		
		idw_parm.object.carrying_out_item[rows] =	dw_1.object.item_code[i]
		idw_parm.object.carrying_out_item_spec[rows] =	dw_1.object.item_spec[i]
		idw_parm.object.carrying_out_qty[rows] =	dw_1.object.inspect_bad_qty[i]	
		
		
		lvd_seq = f_get_sequence('seq_carrying_out')
		idw_parm.object.carrying_out_date[rows] = f_t_sysdate()
		idw_parm.object.carrying_out_seq[rows] = lvd_seq
		idw_parm.object.invoice_no[rows] = STRING(f_t_sysdate(),'YYYYMMDD')+STRING(lvd_seq)		
		
		idw_parm.object.gate_guard_confirm_yn[rows] = 'N'									
		idw_parm.object.car_no[rows] = '*'					
		idw_parm.object.carrying_out_group_no[rows] = sle_group_no.text
		idw_parm.object.confirm_yn[rows] = 'N'			
		idw_parm.object.complete_yn[rows] = 'N'					
	
loop until i = dw_1.rowcount( )
 
 
close(parent)



end event

type sle_item_code from singlelineedit within w_qc_wqc_inspect_outside_request_popup
event ue_editchange pbm_enchange
integer x = 23
integer y = 348
integer width = 603
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event ue_editchange;STRING LVS_item_name
DW_1.SETFILTER('')
DW_1.FILTER()

IF THIS.TEXT = '' THEN 
	
	IVD_SELECTED_DATA_WINDOW.SETFILTER('')
	IVD_SELECTED_DATA_WINDOW.FILTER()	
	RETURN 
ELSE
	LVS_item_name = '%'+this.text+'%'
END IF

DW_1.SETFILTER("item_code LIKE '"+LVS_item_name+"'")
DW_1.FILTER()

end event

type st_2 from statictext within w_qc_wqc_inspect_outside_request_popup
integer x = 23
integer y = 284
integer width = 603
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Item Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_item_name from singlelineedit within w_qc_wqc_inspect_outside_request_popup
event ue_editchange pbm_enchange
integer x = 631
integer y = 348
integer width = 398
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean autohscroll = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event ue_editchange;STRING LVS_item_name
DW_1.SETFILTER('')
DW_1.FILTER()

IF THIS.TEXT = '' THEN 
	
	IVD_SELECTED_DATA_WINDOW.SETFILTER('')
	IVD_SELECTED_DATA_WINDOW.FILTER()	
	RETURN 
ELSE
	LVS_item_name = '%'+this.text+'%'
END IF

DW_1.SETFILTER("item_name LIKE '"+LVS_item_name+"'")
DW_1.FILTER()

end event

type st_1 from statictext within w_qc_wqc_inspect_outside_request_popup
integer x = 631
integer y = 280
integer width = 398
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Item Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_7 from statictext within w_qc_wqc_inspect_outside_request_popup
integer x = 1029
integer y = 280
integer width = 494
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Item Spec"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_qc_wqc_inspect_outside_request_popup
event ue_editchange pbm_enchange
integer x = 1033
integer y = 348
integer width = 494
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean autohscroll = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event ue_editchange;STRING LVS_item_name
DW_1.SETFILTER('')
DW_1.FILTER()

IF THIS.TEXT = '' THEN 
	
	IVD_SELECTED_DATA_WINDOW.SETFILTER('')
	IVD_SELECTED_DATA_WINDOW.FILTER()	
	RETURN 
ELSE
	LVS_item_name = '%'+this.text+'%'
END IF

DW_1.SETFILTER("item_spec LIKE '"+LVS_item_name+"'")
DW_1.FILTER()

end event

type ddlb_bring_in_yn from uo_basecode within w_qc_wqc_inspect_outside_request_popup
integer x = 2875
integer y = 340
integer width = 494
integer height = 676
integer taborder = 80
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'BRING IN YN')
end event

type st_3 from statictext within w_qc_wqc_inspect_outside_request_popup
integer x = 2880
integer y = 268
integer width = 494
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Bring In YN"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_carrying_out_by from uo_user_id_name within w_qc_wqc_inspect_outside_request_popup
integer x = 2258
integer y = 340
integer height = 676
integer taborder = 80
boolean bringtotop = true
end type

type st_4 from statictext within w_qc_wqc_inspect_outside_request_popup
integer x = 2267
integer y = 276
integer width = 608
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Carrying Out By"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_carrying_out_receiptor from uo_supplier_code within w_qc_wqc_inspect_outside_request_popup
integer x = 1659
integer y = 340
integer width = 594
integer taborder = 20
boolean bringtotop = true
end type

type st_5 from statictext within w_qc_wqc_inspect_outside_request_popup
integer x = 1669
integer y = 272
integer width = 608
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Carryin Out Receiptor"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_group_no from so_commandbutton within w_qc_wqc_inspect_outside_request_popup
integer x = 782
integer y = 656
integer width = 443
integer height = 104
integer taborder = 90
boolean bringtotop = true
string text = "Gen New Group"
end type

event clicked;call super::clicked;SLE_GROUP_NO.TEXT = STRING(F_T_SYSDATE(), 'yymmdd')+STRING(f_get_sequence( 'SEQ_CARRYING_OUT_GROUP' ))
end event

type sle_group_no from so_singlelineedit within w_qc_wqc_inspect_outside_request_popup
integer x = 1239
integer y = 668
integer taborder = 100
boolean bringtotop = true
boolean displayonly = true
end type

type gb_2 from so_groupbox within w_qc_wqc_inspect_outside_request_popup
integer x = 1623
integer y = 204
integer width = 1769
integer height = 260
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Default Values"
end type

type gb_3 from so_groupbox within w_qc_wqc_inspect_outside_request_popup
integer y = 564
integer width = 2702
integer height = 260
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_1 from so_groupbox within w_qc_wqc_inspect_outside_request_popup
integer y = 208
integer width = 1618
integer height = 260
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

