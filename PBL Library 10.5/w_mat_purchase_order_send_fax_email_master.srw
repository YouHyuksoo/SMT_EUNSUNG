HA$PBExportHeader$w_mat_purchase_order_send_fax_email_master.srw
$PBExportComments$Material Purchase Order Master
forward
global type w_mat_purchase_order_send_fax_email_master from w_main_root
end type
type st_1 from so_statictext within w_mat_purchase_order_send_fax_email_master
end type
type ddlb_item_code from uo_item_code within w_mat_purchase_order_send_fax_email_master
end type
type st_3 from so_statictext within w_mat_purchase_order_send_fax_email_master
end type
type uo_dateset from uo_ymd_calendar within w_mat_purchase_order_send_fax_email_master
end type
type st_4 from so_statictext within w_mat_purchase_order_send_fax_email_master
end type
type ddlb_supplier_code from uo_supplier_code within w_mat_purchase_order_send_fax_email_master
end type
type sle_item_name from so_singlelineedit within w_mat_purchase_order_send_fax_email_master
end type
type st_14 from so_statictext within w_mat_purchase_order_send_fax_email_master
end type
type sle_1 from so_singlelineedit within w_mat_purchase_order_send_fax_email_master
end type
type st_5 from so_statictext within w_mat_purchase_order_send_fax_email_master
end type
type uo_dateend from uo_ymdend_calendar within w_mat_purchase_order_send_fax_email_master
end type
type tab_1 from tab within w_mat_purchase_order_send_fax_email_master
end type
type tabpage_4 from userobject within tab_1
end type
type cbx_show_price from so_checkbox within tabpage_4
end type
type cb_1 from so_commandbutton within tabpage_4
end type
type cb_print from so_commandbutton within tabpage_4
end type
type cb_preview from so_commandbutton within tabpage_4
end type
type st_6 from so_statictext within tabpage_4
end type
type ddlb_1 from uo_basecode within tabpage_4
end type
type cbx_dialog from so_checkbox within tabpage_4
end type
type em_copy from so_editmask within tabpage_4
end type
type st_2 from so_statictext within tabpage_4
end type
type tabpage_4 from userobject within tab_1
cbx_show_price cbx_show_price
cb_1 cb_1
cb_print cb_print
cb_preview cb_preview
st_6 st_6
ddlb_1 ddlb_1
cbx_dialog cbx_dialog
em_copy em_copy
st_2 st_2
end type
type tab_1 from tab within w_mat_purchase_order_send_fax_email_master
tabpage_4 tabpage_4
end type
type sle_order_group_no from so_singlelineedit within w_mat_purchase_order_send_fax_email_master
end type
type st_7 from so_statictext within w_mat_purchase_order_send_fax_email_master
end type
type gb_1 from so_groupbox within w_mat_purchase_order_send_fax_email_master
end type
end forward

global type w_mat_purchase_order_send_fax_email_master from w_main_root
integer width = 4498
integer height = 3072
string title = "Material Purchase Order Master"
st_1 st_1
ddlb_item_code ddlb_item_code
st_3 st_3
uo_dateset uo_dateset
st_4 st_4
ddlb_supplier_code ddlb_supplier_code
sle_item_name sle_item_name
st_14 st_14
sle_1 sle_1
st_5 st_5
uo_dateend uo_dateend
tab_1 tab_1
sle_order_group_no sle_order_group_no
st_7 st_7
gb_1 gb_1
end type
global w_mat_purchase_order_send_fax_email_master w_mat_purchase_order_send_fax_email_master

type variables
string ivs_preview_yn = 'N'
string ivs_order_group_no[]
end variables

on w_mat_purchase_order_send_fax_email_master.create
int iCurrent
call super::create
this.st_1=create st_1
this.ddlb_item_code=create ddlb_item_code
this.st_3=create st_3
this.uo_dateset=create uo_dateset
this.st_4=create st_4
this.ddlb_supplier_code=create ddlb_supplier_code
this.sle_item_name=create sle_item_name
this.st_14=create st_14
this.sle_1=create sle_1
this.st_5=create st_5
this.uo_dateend=create uo_dateend
this.tab_1=create tab_1
this.sle_order_group_no=create sle_order_group_no
this.st_7=create st_7
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.ddlb_item_code
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.uo_dateset
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.ddlb_supplier_code
this.Control[iCurrent+7]=this.sle_item_name
this.Control[iCurrent+8]=this.st_14
this.Control[iCurrent+9]=this.sle_1
this.Control[iCurrent+10]=this.st_5
this.Control[iCurrent+11]=this.uo_dateend
this.Control[iCurrent+12]=this.tab_1
this.Control[iCurrent+13]=this.sle_order_group_no
this.Control[iCurrent+14]=this.st_7
this.Control[iCurrent+15]=this.gb_1
end on

on w_mat_purchase_order_send_fax_email_master.destroy
call super::destroy
destroy(this.st_1)
destroy(this.ddlb_item_code)
destroy(this.st_3)
destroy(this.uo_dateset)
destroy(this.st_4)
destroy(this.ddlb_supplier_code)
destroy(this.sle_item_name)
destroy(this.st_14)
destroy(this.sle_1)
destroy(this.st_5)
destroy(this.uo_dateend)
destroy(this.tab_1)
destroy(this.sle_order_group_no)
destroy(this.st_7)
destroy(this.gb_1)
end on

event activate;call super::activate;/***************************************
* Window Default Property 
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20051101'
Gst_set.last_modify_date = '20051101'
Gst_set.Report_window    = False  // Report Window  True / Flase

/*****************************************
* Data Window Property
******************************************/
Ivs_resize_type                      = 'MASTER_DETAIL_12T_3B'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

/****************************************
* Menu Property 
*****************************************
* ADMIN  ( All Control )
* MANAGE ( Manager )
* GUEST  ( Only Query )
* QUERY  ( Only Query  )
* DATA_CONTROL  ( Insert Delete Update )
* REPORT ( Report )
****************************************/
F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control





end event

event ue_post_open;call super::ue_post_open;

/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
uo_dateset.settext(string(f_t_sysdate(), 'yyyy/mm')+'/01')
end event

event ue_data_control;call super::ue_data_control;Long row
String lvs_date
choose case gvs_ue_data_control
		
	case 'RETRIEVE'			
		dw_1.reset()
		dw_2.reset()

		dw_1.retrieve(ddlb_supplier_code.text+'%' , ddlb_item_code.text() + '%',  uo_dateset.text() , uo_dateend.text(),  gvi_organization_id)


end choose

end event

type dw_5 from w_main_root`dw_5 within w_mat_purchase_order_send_fax_email_master
integer y = 572
integer height = 320
end type

type dw_4 from w_main_root`dw_4 within w_mat_purchase_order_send_fax_email_master
integer y = 572
integer height = 320
end type

type dw_3 from w_main_root`dw_3 within w_mat_purchase_order_send_fax_email_master
integer y = 2104
integer width = 4434
integer height = 844
boolean titlebar = true
string dataobject = "d_mat_purchase_order_landscape_all_rpt"
end type

event dw_3::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return
dw_4.retrieve(this.object.order_group_no[currentrow], this.object.supplier_code[currentrow], gvi_organization_id)
					

end event

event dw_3::doubleclicked;call super::doubleclicked;if row < 1 then return
dw_4.retrieve(this.object.order_group_no[row], this.object.supplier_code[row], gvi_organization_id)
					

end event

type dw_2 from w_main_root`dw_2 within w_mat_purchase_order_send_fax_email_master
integer x = 2217
integer y = 572
integer width = 2213
integer height = 1528
boolean titlebar = true
string title = "Material Purchase Order List"
string dataobject = "d_mat_purchase_order_group_detail_4_send_fax_email_lst"
end type

type dw_1 from w_main_root`dw_1 within w_mat_purchase_order_send_fax_email_master
integer y = 572
integer width = 2213
integer height = 1528
boolean titlebar = true
string title = "Material Purchase Order Group List"
string dataobject = "d_mat_purchase_order_group_4_send_fax_email_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;IF CURRENTROW < 1  THEN RETURN
DW_2.RETRIEVE(    THIS.OBJECT.SUPPLIER_CODE[CURRENTROW] , THIS.OBJECT.ORDER_GROUP_NO[CURRENTROW] , GVI_ORGANIZATION_ID )

end event

event dw_1::doubleclicked;call super::doubleclicked;IF ROW < 1  THEN RETURN
DW_2.RETRIEVE(    DW_1.OBJECT.SUPPLIER_CODE[DW_1.GETROW()] , DW_1.OBJECT.ORDER_GROUP_NO[DW_1.GETROW()] , GVI_ORGANIZATION_ID )

end event

event dw_1::itemchanged;//return override
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_purchase_order_send_fax_email_master
end type

type st_1 from so_statictext within w_mat_purchase_order_send_fax_email_master
integer x = 466
integer y = 88
integer width = 631
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mat_purchase_order_send_fax_email_master
integer x = 466
integer y = 160
integer width = 631
integer taborder = 20
boolean bringtotop = true
end type

type st_3 from so_statictext within w_mat_purchase_order_send_fax_email_master
integer x = 1106
integer y = 88
integer width = 805
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Delivery Date"
end type

type uo_dateset from uo_ymd_calendar within w_mat_purchase_order_send_fax_email_master
integer x = 1102
integer y = 160
integer height = 84
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_4 from so_statictext within w_mat_purchase_order_send_fax_email_master
integer x = 23
integer y = 80
integer width = 439
boolean bringtotop = true
integer weight = 700
string text = "Supplier Code"
end type

type ddlb_supplier_code from uo_supplier_code within w_mat_purchase_order_send_fax_email_master
integer x = 23
integer y = 160
integer width = 439
integer taborder = 30
boolean bringtotop = true
end type

type sle_item_name from so_singlelineedit within w_mat_purchase_order_send_fax_email_master
integer x = 2336
integer y = 160
integer width = 402
integer height = 84
integer taborder = 40
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

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

	DW_1.SETFILTER('')
	DW_1.FILTER()
	
	LVS_COLUMN = 'ITEM_NAME'
	IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
		RETURN 
	END IF
	
	IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
		 DW_1.SETFILTER('')
		 DW_1.FILTER()	
		 RETURN
	ELSE
		LVS_VALUE = '%'+this.text+'%'
	END IF
	
	DW_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
	DW_1.FILTER()
	F_MSG_MDI_HELP( STRING( DW_1.ROWCOUNT() ) + " Found" )

	
	
end event

type st_14 from so_statictext within w_mat_purchase_order_send_fax_email_master
integer x = 2336
integer y = 92
integer width = 402
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Item Name"
end type

type sle_1 from so_singlelineedit within w_mat_purchase_order_send_fax_email_master
integer x = 2738
integer y = 160
integer width = 416
integer height = 84
integer taborder = 50
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

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN


	DW_1.SETFILTER('')
	DW_1.FILTER()
	
	LVS_COLUMN = 'ITEM_SPEC'
	IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
		RETURN 
	END IF
	
	IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
		 DW_1.SETFILTER('')
		 DW_1.FILTER()	
		 RETURN
	ELSE
		LVS_VALUE = '%'+this.text+'%'
	END IF
	
	DW_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
	DW_1.FILTER()
	F_MSG_MDI_HELP( STRING( DW_1.ROWCOUNT() ) + " Found" )

end event

type st_5 from so_statictext within w_mat_purchase_order_send_fax_email_master
integer x = 2738
integer y = 92
integer width = 416
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Item Spec"
end type

type uo_dateend from uo_ymdend_calendar within w_mat_purchase_order_send_fax_email_master
integer x = 1513
integer y = 156
integer height = 92
integer taborder = 70
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymdend_calendar::destroy
end on

type tab_1 from tab within w_mat_purchase_order_send_fax_email_master
event create ( )
event destroy ( )
integer y = 316
integer width = 3410
integer height = 248
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean fixedwidth = true
boolean raggedright = true
boolean focusonbuttondown = true
boolean powertips = true
integer selectedtab = 1
tabpage_4 tabpage_4
end type

on tab_1.create
this.tabpage_4=create tabpage_4
this.Control[]={this.tabpage_4}
end on

on tab_1.destroy
destroy(this.tabpage_4)
end on

type tabpage_4 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 3374
integer height = 120
long backcolor = 15780518
string text = "Print"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Print!"
long picturemaskcolor = 536870912
cbx_show_price cbx_show_price
cb_1 cb_1
cb_print cb_print
cb_preview cb_preview
st_6 st_6
ddlb_1 ddlb_1
cbx_dialog cbx_dialog
em_copy em_copy
st_2 st_2
end type

on tabpage_4.create
this.cbx_show_price=create cbx_show_price
this.cb_1=create cb_1
this.cb_print=create cb_print
this.cb_preview=create cb_preview
this.st_6=create st_6
this.ddlb_1=create ddlb_1
this.cbx_dialog=create cbx_dialog
this.em_copy=create em_copy
this.st_2=create st_2
this.Control[]={this.cbx_show_price,&
this.cb_1,&
this.cb_print,&
this.cb_preview,&
this.st_6,&
this.ddlb_1,&
this.cbx_dialog,&
this.em_copy,&
this.st_2}
end on

on tabpage_4.destroy
destroy(this.cbx_show_price)
destroy(this.cb_1)
destroy(this.cb_print)
destroy(this.cb_preview)
destroy(this.st_6)
destroy(this.ddlb_1)
destroy(this.cbx_dialog)
destroy(this.em_copy)
destroy(this.st_2)
end on

type cbx_show_price from so_checkbox within tabpage_4
integer x = 1902
integer y = 16
integer weight = 700
long backcolor = 15780518
string text = "Show Price"
end type

type cb_1 from so_commandbutton within tabpage_4
integer x = 3017
integer y = 12
integer width = 338
integer height = 100
integer taborder = 80
boolean bringtotop = true
string text = "Send Mail"
end type

event clicked;call super::clicked;long i
string lvs_return
if  ivs_preview_yn = 'Y' THEN 
	ivs_preview_yn = 'N' 	
	dw_3.bringtotop = TRUE
else
	ivs_preview_yn = 'Y' 	
	dw_3.bringtotop = TRUE		
	
	do
		i++
				if dw_1.object.check_yn[i] = 'Y' then
					ivs_order_group_no[1] = dw_1.object.order_group_no[i] 
					dw_3.retrieve( ivs_order_group_no, gvi_organization_id )
				else
					continue
				end if

				if dw_3.Describe("DataWindow.Print.Preview") = '!' or dw_3.Describe("DataWindow.Print.Preview") = '?' then
				else
					dw_3.Modify("DataWindow.Print.Preview=yes")
					dw_3.Modify("DataWindow.Print.Preview.Rulers=yes")
				end if		
			
				if string(dw_1.object.supplier_name[i]) = '' or isnull(string(dw_1.object.supplier_name[i])) then 
					Messagebox("Notify" , "Supplier Name Invalid!")
					return
				end if
				
				if string(dw_1.object.email_address[i]) = '' or isnull(string(dw_1.object.email_address[i])) then 
					Messagebox("Notify" , "E-Mail Address Invalid!")
					return
				end if
			
			  openwithparm(w_send_mail_dw_popup , dw_3)
			  
			  w_send_mail_dw_popup.sle_name.text =  string(dw_1.object.supplier_name[i])
			  w_send_mail_dw_popup.sle_email_address.text = string(dw_1.object.email_address[i])
			  w_send_mail_dw_popup.cb_send.triggerevent(clicked!)			
			
	loop until i = dw_1.rowcount( )
end if

	
end event

type cb_print from so_commandbutton within tabpage_4
integer x = 2697
integer y = 12
integer width = 315
integer height = 100
integer taborder = 70
boolean bringtotop = true
string text = "Print"
end type

event clicked;call super::clicked;Int		i, lvi_cnt , rows

If dw_3.rowcount() < 1 Then Return

if cbx_show_price.checked = true then 
	dw_3.object.unit_price.color = rgb(255,255,255)
	dw_3.object.purchase_amount.color = rgb(255,255,255)
	dw_3.object.purchase_amount_total.color = rgb(255,255,255)
else
	dw_3.object.unit_price.color = 0
	dw_3.object.purchase_amount.color = 0
	dw_3.object.purchase_amount_total.color = 0
end if


lvi_cnt = Integer(em_copy.text)
If lvi_cnt > 0 Then

		For i = 1 To lvi_cnt
			
			if cbx_dialog.checked = true then 
				dw_3.print(false, True)
			else
				dw_3.print(false, False)						
			end if
		Next

End If

end event

type cb_preview from so_commandbutton within tabpage_4
integer x = 2377
integer y = 12
integer width = 315
integer height = 100
integer taborder = 70
boolean bringtotop = true
string text = "Preview"
end type

event clicked;call super::clicked;
int i
ivs_order_group_no[] = {''}
do
	i++
	
	if dw_1.object.check_yn[i] = 'Y' then
		
		ivs_order_group_no[i] = dw_1.object.order_group_no[i]
		
	else
	end if
	
loop until i = dw_1.rowcount( )



if  ivs_preview_yn = 'Y' THEN 
	ivs_preview_yn = 'N' 	
	dw_3.bringtotop = TRUE
else
	ivs_preview_yn = 'Y' 	
	dw_3.bringtotop = TRUE		
	
	dw_3.retrieve( ivs_order_group_no[]  , gvi_organization_id )
	
	if dw_3.Describe("DataWindow.Print.Preview") = '!' or dw_3.Describe("DataWindow.Print.Preview") = '?' then
	else
		 dw_3.Modify("DataWindow.Print.Preview=yes")
		dw_3.Modify("DataWindow.Print.Preview.Rulers=yes")
	end if		
end if


if cbx_show_price.checked = true then 
	dw_3.object.unit_price.color = rgb(255,255,255)
	dw_3.object.purchase_amount.color = rgb(255,255,255)
	dw_3.object.purchase_amount_total.color = rgb(255,255,255)
else
	dw_3.object.unit_price.color = 0
	dw_3.object.purchase_amount.color = 0
	dw_3.object.purchase_amount_total.color = 0
end if

	
end event

type st_6 from so_statictext within tabpage_4
integer x = 658
integer y = 36
integer width = 334
integer height = 64
boolean bringtotop = true
integer weight = 700
long backcolor = 15780518
string text = "Language"
end type

type ddlb_1 from uo_basecode within tabpage_4
integer x = 1001
integer y = 28
integer width = 398
integer height = 360
integer taborder = 80
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'LANGUAGE')
end event

type cbx_dialog from so_checkbox within tabpage_4
integer x = 1445
integer y = 28
integer width = 393
integer height = 80
boolean bringtotop = true
integer weight = 700
long backcolor = 15780518
string text = "Show Dialog"
end type

type em_copy from so_editmask within tabpage_4
integer x = 320
integer y = 28
integer width = 311
integer taborder = 40
boolean bringtotop = true
string text = "1"
string mask = "##0"
boolean spin = true
end type

type st_2 from so_statictext within tabpage_4
integer y = 36
integer width = 311
integer height = 64
boolean bringtotop = true
integer weight = 700
long backcolor = 15780518
string text = "Print Copy"
end type

type sle_order_group_no from so_singlelineedit within w_mat_purchase_order_send_fax_email_master
integer x = 1925
integer y = 160
integer width = 411
integer height = 84
integer taborder = 50
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

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

	DW_1.SETFILTER('')
	DW_1.FILTER()
	
	LVS_COLUMN = 'ORDER_GROUP_NO'
	IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
		RETURN 
	END IF
	
	IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
		 DW_1.SETFILTER('')
		 DW_1.FILTER()	
		 RETURN
	ELSE
		LVS_VALUE = '%'+this.text+'%'
	END IF
	
	DW_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
	DW_1.FILTER()
	F_MSG_MDI_HELP( STRING( DW_1.ROWCOUNT() ) + " Found" )

end event

type st_7 from so_statictext within w_mat_purchase_order_send_fax_email_master
integer x = 1925
integer y = 88
integer width = 411
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Order Group No"
end type

type gb_1 from so_groupbox within w_mat_purchase_order_send_fax_email_master
integer width = 3191
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

