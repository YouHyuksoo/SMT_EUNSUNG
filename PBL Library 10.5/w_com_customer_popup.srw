HA$PBExportHeader$w_com_customer_popup.srw
$PBExportComments$(Sal Customerr Query)-$$HEX5$$70ac98b798cc70c88cd6$$ENDHEX$$
forward
global type w_com_customer_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_com_customer_popup
end type
type cb_select from so_commandbutton within w_com_customer_popup
end type
type st_14 from so_statictext within w_com_customer_popup
end type
type sle_customer_name from so_singlelineedit within w_com_customer_popup
end type
type sle_customer_code from so_singlelineedit within w_com_customer_popup
end type
type st_1 from so_statictext within w_com_customer_popup
end type
type gb_1 from so_groupbox within w_com_customer_popup
end type
type gb_2 from so_groupbox within w_com_customer_popup
end type
end forward

global type w_com_customer_popup from w_popup_root
integer width = 3813
integer height = 2628
string title = "Customer Master Popup"
cb_retrieve cb_retrieve
cb_select cb_select
st_14 st_14
sle_customer_name sle_customer_name
sle_customer_code sle_customer_code
st_1 st_1
gb_1 gb_1
gb_2 gb_2
end type
global w_com_customer_popup w_com_customer_popup

on w_com_customer_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.st_14=create st_14
this.sle_customer_name=create sle_customer_name
this.sle_customer_code=create sle_customer_code
this.st_1=create st_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.st_14
this.Control[iCurrent+4]=this.sle_customer_name
this.Control[iCurrent+5]=this.sle_customer_code
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.gb_2
end on

on w_com_customer_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.st_14)
destroy(this.sle_customer_name)
destroy(this.sle_customer_code)
destroy(this.st_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;dw_1.settransobject(sqlca)
IVD_SELECTED_DATA_WINDOW = DW_1
f_child_dw3(dw_1, 'business_type', gvs_language, string(gvi_organization_id), 'BUSINESS TYPE')
CB_RETRIEVE.TRIGGEREVENT(CLICKED!)
SLE_customer_code.SETFOCUS()
end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
end if
end event

type p_title from w_popup_root`p_title within w_com_customer_popup
integer width = 3803
end type

type cb_sort from w_popup_root`cb_sort within w_com_customer_popup
boolean visible = true
integer x = 2615
integer y = 300
integer height = 172
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_com_customer_popup
boolean visible = true
integer x = 3451
integer y = 300
integer height = 172
integer taborder = 0
end type

event cb_close::clicked;call super::clicked;GST_RETURN.GVB_RETURN = FALSE
end event

type st_msg from w_popup_root`st_msg within w_com_customer_popup
boolean visible = true
integer y = 536
integer width = 3803
end type

type dw_1 from w_popup_root`dw_1 within w_com_customer_popup
boolean visible = true
integer y = 632
integer width = 3803
integer height = 1912
integer taborder = 30
boolean titlebar = true
string title = "Customer List"
string dataobject = "d_com_customer_popup"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
cb_select.triggerevent(clicked!)
end event

type dw_2 from w_popup_root`dw_2 within w_com_customer_popup
boolean visible = true
integer y = 800
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_com_customer_popup
integer y = 640
end type

type cb_retrieve from so_commandbutton within w_com_customer_popup
integer x = 2894
integer y = 300
integer width = 274
integer height = 172
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;string lvs_sale_charge
				if Gvs_use_sale_charge_condition = 'Y' and Gvi_user_level < 8 then
					lvs_sale_charge = Gvs_user_id
				else
					lvs_sale_charge = '%'
				end if
				
DW_1.RETRIEVE(  SLE_customer_code.TEXT+'%' ,  '%'+SLE_customer_NAME.TEXT+'%' , lvs_sale_charge , GVI_ORGANIZATION_ID )
end event

type cb_select from so_commandbutton within w_com_customer_popup
integer x = 3173
integer y = 300
integer width = 274
integer height = 172
boolean bringtotop = true
string text = "Select"
boolean default = true
end type

event clicked;IF DW_1.GETROW() = 0  THEN 
	GST_RETURN.GVB_RETURN = FALSE
	RETURN -1
END IF
GST_RETURN.GVB_RETURN = TRUE
MESSAGE.STRINGPARM = DW_1.GETITEMSTRING( DW_1.GETROW() , 'customer_code')
GST_RETURN.GVS_RETURN[1] = DW_1.GETITEMSTRING( DW_1.GETROW() , 'customer_name')
GST_RETURN.GVS_RETURN[2] = DW_1.GETITEMSTRING( DW_1.GETROW() , 'credit_grade')

GST_RETURN.GVS_RETURN[3] = DW_1.GETITEMSTRING( DW_1.GETROW() , 'nation_code')

GST_RETURN.GVS_RETURN[4] = DW_1.GETITEMSTRING( DW_1.GETROW() , 'address')
GST_RETURN.GVS_RETURN[5] = DW_1.GETITEMSTRING( DW_1.GETROW() , 'tel_no')
GST_RETURN.GVS_RETURN[6] = DW_1.GETITEMSTRING( DW_1.GETROW() , 'fax_no')

GST_RETURN.GVF_RETURN[1] = DW_1.GETITEMDECIMAL( DW_1.GETROW() , 'credit_amount')
GST_RETURN.GVF_RETURN[2] = DW_1.GETITEMDECIMAL( DW_1.GETROW() , 'volume_dc_rate')

CLOSEWITHRETURN(PARENT , MESSAGE.STRINGPARM )
end event

type st_14 from so_statictext within w_com_customer_popup
integer x = 512
integer y = 296
integer width = 681
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Customer Name"
end type

type sle_customer_name from so_singlelineedit within w_com_customer_popup
event ue_editchange pbm_enchange
integer x = 512
integer y = 376
integer width = 681
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer weight = 700
string pointer = "HyperLink!"
textcase textcase = upper!
end type

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN = "CUSTOMER_NAME"

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

IVD_SELECTED_DATA_WINDOW.SETFILTER('')
IVD_SELECTED_DATA_WINDOW.FILTER()

IF THIS.TEXT = '' THEN 
	IVD_SELECTED_DATA_WINDOW.SETFILTER('')
	IVD_SELECTED_DATA_WINDOW.FILTER()
	RETURN
ELSE
	LVS_VALUE =  UPPER( '%'+this.text+'%' )
END IF

IVD_SELECTED_DATA_WINDOW.SETFILTER( "UPPER("+LVS_COLUMN+")"  +" LIKE '"+LVS_VALUE+"'")
IVD_SELECTED_DATA_WINDOW.FILTER()

end event

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

type sle_customer_code from so_singlelineedit within w_com_customer_popup
event ue_editchange pbm_enchange
integer x = 27
integer y = 376
integer width = 480
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer weight = 700
string pointer = "HyperLink!"
textcase textcase = upper!
end type

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN = "CUSTOMER_CODE"

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

IVD_SELECTED_DATA_WINDOW.SETFILTER('')
IVD_SELECTED_DATA_WINDOW.FILTER()

IF THIS.TEXT = '' THEN 
	IVD_SELECTED_DATA_WINDOW.SETFILTER('')
	IVD_SELECTED_DATA_WINDOW.FILTER()
	RETURN
ELSE
	LVS_VALUE = UPPER( '%'+this.text+'%' )
END IF

IVD_SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
IVD_SELECTED_DATA_WINDOW.FILTER()



end event

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

event modified;IVD_SELECTED_DATA_WINDOW.SETFOCUS()
end event

type st_1 from so_statictext within w_com_customer_popup
integer x = 27
integer y = 296
integer width = 480
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Customer Code"
end type

type gb_1 from so_groupbox within w_com_customer_popup
integer x = 2546
integer y = 220
integer width = 1248
integer height = 304
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_com_customer_popup
integer y = 220
integer width = 1216
integer height = 304
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

