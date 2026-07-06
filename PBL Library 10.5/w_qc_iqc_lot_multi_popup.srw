HA$PBExportHeader$w_qc_iqc_lot_multi_popup.srw
$PBExportComments$Lqc Lot Divide Popup
forward
global type w_qc_iqc_lot_multi_popup from w_none_dw_popup_root
end type
type cb_2 from so_commandbutton within w_qc_iqc_lot_multi_popup
end type
type em_origin from so_editmask within w_qc_iqc_lot_multi_popup
end type
type st_origin from so_statictext within w_qc_iqc_lot_multi_popup
end type
type em_new from so_editmask within w_qc_iqc_lot_multi_popup
end type
type st_new from so_statictext within w_qc_iqc_lot_multi_popup
end type
type em_result from so_editmask within w_qc_iqc_lot_multi_popup
end type
type em_count from so_editmask within w_qc_iqc_lot_multi_popup
end type
type st_1 from so_statictext within w_qc_iqc_lot_multi_popup
end type
type gb_1 from so_groupbox within w_qc_iqc_lot_multi_popup
end type
end forward

global type w_qc_iqc_lot_multi_popup from w_none_dw_popup_root
integer width = 1888
integer height = 1232
cb_2 cb_2
em_origin em_origin
st_origin st_origin
em_new em_new
st_new st_new
em_result em_result
em_count em_count
st_1 st_1
gb_1 gb_1
end type
global w_qc_iqc_lot_multi_popup w_qc_iqc_lot_multi_popup

on w_qc_iqc_lot_multi_popup.create
int iCurrent
call super::create
this.cb_2=create cb_2
this.em_origin=create em_origin
this.st_origin=create st_origin
this.em_new=create em_new
this.st_new=create st_new
this.em_result=create em_result
this.em_count=create em_count
this.st_1=create st_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.em_origin
this.Control[iCurrent+3]=this.st_origin
this.Control[iCurrent+4]=this.em_new
this.Control[iCurrent+5]=this.st_new
this.Control[iCurrent+6]=this.em_result
this.Control[iCurrent+7]=this.em_count
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.gb_1
end on

on w_qc_iqc_lot_multi_popup.destroy
call super::destroy
destroy(this.cb_2)
destroy(this.em_origin)
destroy(this.st_origin)
destroy(this.em_new)
destroy(this.st_new)
destroy(this.em_result)
destroy(this.em_count)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;call super::open;em_origin.text = trim(string(message.doubleparm))
em_new.setfocus()
end event

type p_title from w_none_dw_popup_root`p_title within w_qc_iqc_lot_multi_popup
integer width = 1874
end type

type cb_close from w_none_dw_popup_root`cb_close within w_qc_iqc_lot_multi_popup
boolean visible = true
integer x = 965
integer y = 988
integer taborder = 0
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_none_dw_popup_root`st_msg within w_qc_iqc_lot_multi_popup
boolean visible = true
integer y = 0
end type

type cb_2 from so_commandbutton within w_qc_iqc_lot_multi_popup
integer x = 686
integer y = 988
integer width = 274
integer height = 100
integer taborder = 20
boolean bringtotop = true
string text = "Ok"
boolean default = true
end type

event clicked;call super::clicked;if long(em_count.text) = 0 or double(em_new.text) <= 0 then 
	return
end if

gst_return.gvb_return = true 
////gst_return.gvf_return[1] = dec(em_new.text)
////close(parent)

if  truncate(double(em_origin.text) / double(em_new.text) , 0 )  < long(em_count.text) then 
	MESSAGEBOX("Notify" , "Lot Count Invalid")
	return
end if

message.doubleparm        = Double(em_new.text)
Gst_return.Gvf_return[1] = Double(em_count.text)

closewithreturn(parent, message.doubleparm )
end event

type em_origin from so_editmask within w_qc_iqc_lot_multi_popup
integer x = 832
integer y = 380
integer width = 617
boolean bringtotop = true
string text = ""
maskdatatype maskdatatype = decimalmask!
string mask = "###,###,##0.####"
end type

type st_origin from so_statictext within w_qc_iqc_lot_multi_popup
integer x = 270
integer y = 384
integer width = 535
boolean bringtotop = true
integer weight = 700
string text = "Original Qty"
alignment alignment = right!
end type

type em_new from so_editmask within w_qc_iqc_lot_multi_popup
event ue_editchange pbm_enchange
integer x = 832
integer y = 464
integer width = 617
integer taborder = 10
boolean bringtotop = true
string text = ""
maskdatatype maskdatatype = decimalmask!
string mask = "###,###,##0.####"
end type

event ue_editchange;em_result.text = string(Dec(em_origin.text) - Dec(this.text))

if double(em_new.text) <= 0 then 
	return
else
	em_count.text = string( truncate(double(em_origin.text) / double(em_new.text) , 0 ) ) 
end if
end event

type st_new from so_statictext within w_qc_iqc_lot_multi_popup
integer x = 270
integer y = 472
integer width = 535
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "New Qty"
alignment alignment = right!
end type

type em_result from so_editmask within w_qc_iqc_lot_multi_popup
integer x = 832
integer y = 564
integer width = 617
boolean bringtotop = true
long backcolor = 12632256
string text = ""
maskdatatype maskdatatype = decimalmask!
string mask = "###,###,##0.####"
end type

type em_count from so_editmask within w_qc_iqc_lot_multi_popup
integer x = 832
integer y = 656
integer width = 617
integer taborder = 20
boolean bringtotop = true
maskdatatype maskdatatype = decimalmask!
string mask = "###,###,##0"
end type

type st_1 from so_statictext within w_qc_iqc_lot_multi_popup
integer x = 270
integer y = 664
integer width = 535
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Count"
alignment alignment = right!
end type

type gb_1 from so_groupbox within w_qc_iqc_lot_multi_popup
integer x = 238
integer y = 256
integer width = 1371
integer height = 612
end type

