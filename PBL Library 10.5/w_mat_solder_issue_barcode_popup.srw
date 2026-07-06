HA$PBExportHeader$w_mat_solder_issue_barcode_popup.srw
$PBExportComments$Purchase Order Lot Divide Popup
forward
global type w_mat_solder_issue_barcode_popup from w_none_dw_popup_root
end type
type cb_2 from so_commandbutton within w_mat_solder_issue_barcode_popup
end type
type sle_barcode from singlelineedit within w_mat_solder_issue_barcode_popup
end type
type em_count from so_editmask within w_mat_solder_issue_barcode_popup
end type
type gb_1 from so_groupbox within w_mat_solder_issue_barcode_popup
end type
end forward

global type w_mat_solder_issue_barcode_popup from w_none_dw_popup_root
integer width = 1801
integer height = 1012
cb_2 cb_2
sle_barcode sle_barcode
em_count em_count
gb_1 gb_1
end type
global w_mat_solder_issue_barcode_popup w_mat_solder_issue_barcode_popup

on w_mat_solder_issue_barcode_popup.create
int iCurrent
call super::create
this.cb_2=create cb_2
this.sle_barcode=create sle_barcode
this.em_count=create em_count
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.sle_barcode
this.Control[iCurrent+3]=this.em_count
this.Control[iCurrent+4]=this.gb_1
end on

on w_mat_solder_issue_barcode_popup.destroy
call super::destroy
destroy(this.cb_2)
destroy(this.sle_barcode)
destroy(this.em_count)
destroy(this.gb_1)
end on

event open;call super::open;sle_barcode.setfocus()
end event

event activate;call super::activate;sle_barcode.setfocus()
end event

type p_title from w_none_dw_popup_root`p_title within w_mat_solder_issue_barcode_popup
integer x = 5
end type

type cb_close from w_none_dw_popup_root`cb_close within w_mat_solder_issue_barcode_popup
boolean visible = true
integer x = 882
integer y = 720
integer taborder = 0
integer weight = 400
end type

type st_msg from w_none_dw_popup_root`st_msg within w_mat_solder_issue_barcode_popup
boolean visible = true
integer x = 9
integer y = 836
end type

type cb_2 from so_commandbutton within w_mat_solder_issue_barcode_popup
integer x = 603
integer y = 720
integer width = 274
integer height = 100
boolean bringtotop = true
integer weight = 400
string text = "Clear"
end type

event clicked;call super::clicked;sle_barcode.text  = ''
sle_barcode.setfocus()
end event

type sle_barcode from singlelineedit within w_mat_solder_issue_barcode_popup
integer x = 87
integer y = 308
integer width = 1632
integer height = 152
integer taborder = 10
boolean bringtotop = true
integer textsize = -20
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
boolean hideselection = false
end type

event modified;string lvs_SOLDER_LOT_NO
Long lvi_count , lvi_return 

lvs_SOLDER_LOT_NO = sle_barcode.text 

select count(*) into  :lvi_count
  from IM_ITEM_SOLDER_MASTER
where SOLDER_LOT_NO = :lvs_SOLDER_LOT_NO
   and organization_id = :gvi_organization_id  ;
	
if f_sql_check() < 0 then 
	st_msg.text = "Error"
	return
end if

if lvi_count = 0 then 
	
	st_msg.text = f_msg_st1(813 , this.text )
	f_msgbox(117) 
	this.text = ''
	return 
//=========================================
//
//=========================================
else

		Gvs_Ue_DATA_control = 'INSERT'
		lvi_return = w_mat_solder_receipt_issue_master.wf_insert( this.text , 'I')
		
		if lvi_return < 0 then 
			st_msg.text = "NG"
			this.text = ''			
		else
			st_msg.text = "OK"
			this.text = ''
			em_count.text= string( long(em_count.text) +1  )
		end if 
end if 

this.setfocus()

end event

type em_count from so_editmask within w_mat_solder_issue_barcode_popup
integer x = 681
integer y = 496
integer height = 152
boolean bringtotop = true
integer textsize = -20
string text = "0"
alignment alignment = center!
string mask = "##0"
end type

type gb_1 from so_groupbox within w_mat_solder_issue_barcode_popup
integer x = 41
integer y = 224
integer width = 1723
integer height = 480
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

