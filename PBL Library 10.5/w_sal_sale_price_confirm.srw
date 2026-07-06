HA$PBExportHeader$w_sal_sale_price_confirm.srw
$PBExportComments$Shipping Sale Price Master
forward
global type w_sal_sale_price_confirm from w_main_root
end type
type st_1 from so_statictext within w_sal_sale_price_confirm
end type
type ddlb_customer_code from uo_customer_code within w_sal_sale_price_confirm
end type
type ddlb_item_code from uo_item_code within w_sal_sale_price_confirm
end type
type st_3 from so_statictext within w_sal_sale_price_confirm
end type
type cb_confirm from so_commandbutton within w_sal_sale_price_confirm
end type
type cb_cancel from so_commandbutton within w_sal_sale_price_confirm
end type
type rb_wait from so_radiobutton within w_sal_sale_price_confirm
end type
type rb_confirmed from so_radiobutton within w_sal_sale_price_confirm
end type
type gb_1 from so_groupbox within w_sal_sale_price_confirm
end type
type gb_3 from so_groupbox within w_sal_sale_price_confirm
end type
type gb_2 from so_groupbox within w_sal_sale_price_confirm
end type
end forward

global type w_sal_sale_price_confirm from w_main_root
integer width = 4608
integer height = 2632
string title = "Sale Price Confirm"
st_1 st_1
ddlb_customer_code ddlb_customer_code
ddlb_item_code ddlb_item_code
st_3 st_3
cb_confirm cb_confirm
cb_cancel cb_cancel
rb_wait rb_wait
rb_confirmed rb_confirmed
gb_1 gb_1
gb_3 gb_3
gb_2 gb_2
end type
global w_sal_sale_price_confirm w_sal_sale_price_confirm

on w_sal_sale_price_confirm.create
int iCurrent
call super::create
this.st_1=create st_1
this.ddlb_customer_code=create ddlb_customer_code
this.ddlb_item_code=create ddlb_item_code
this.st_3=create st_3
this.cb_confirm=create cb_confirm
this.cb_cancel=create cb_cancel
this.rb_wait=create rb_wait
this.rb_confirmed=create rb_confirmed
this.gb_1=create gb_1
this.gb_3=create gb_3
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.ddlb_customer_code
this.Control[iCurrent+3]=this.ddlb_item_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.cb_confirm
this.Control[iCurrent+6]=this.cb_cancel
this.Control[iCurrent+7]=this.rb_wait
this.Control[iCurrent+8]=this.rb_confirmed
this.Control[iCurrent+9]=this.gb_1
this.Control[iCurrent+10]=this.gb_3
this.Control[iCurrent+11]=this.gb_2
end on

on w_sal_sale_price_confirm.destroy
call super::destroy
destroy(this.st_1)
destroy(this.ddlb_customer_code)
destroy(this.ddlb_item_code)
destroy(this.st_3)
destroy(this.cb_confirm)
destroy(this.cb_cancel)
destroy(this.rb_wait)
destroy(this.rb_confirmed)
destroy(this.gb_1)
destroy(this.gb_3)
destroy(this.gb_2)
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
Ivs_resize_type                      = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


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
F_MENU_CONTROL('DATA_CONTROL' , FALSE)  // All Data Control





end event

event ue_post_open;call super::ue_post_open;

/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

event ue_data_control;call super::ue_data_control;long row

string lvs_confirm_status

		if rb_wait.checked = true then 
			lvs_confirm_status = 'N'
		else
			lvs_confirm_status = 'Y'			
		end if
		

choose case gvs_ue_data_control
		
	case 'RETRIEVE'
			dw_1.reset()
			dw_1.retrieve(ddlb_item_code.text +'%' , ddlb_customer_code.text + '%', lvs_confirm_status ,  gvi_organization_id)
		

	case 'UPDATE'
		
			IF DW_1.UPDATE() < 0  THEN
			  	 ROLLBACK;
			ELSE
				 COMMIT;
				f_msg_mdi_help(f_msg_st(170))
	               F_RETRIEVE()
			END IF

	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_sal_sale_price_confirm
integer y = 316
end type

type dw_4 from w_main_root`dw_4 within w_sal_sale_price_confirm
integer y = 316
end type

type dw_3 from w_main_root`dw_3 within w_sal_sale_price_confirm
integer y = 320
boolean maxbox = false
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_2 from w_main_root`dw_2 within w_sal_sale_price_confirm
integer y = 320
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_sal_sale_price_confirm
integer y = 320
integer width = 4544
integer height = 1720
boolean titlebar = true
string title = "Product Sale Price List"
string dataobject = "d_sal_sale_price_4_confirm_lst"
end type

event dw_1::itemchanged;call super::itemchanged;datetime lvdt_null
setnull(lvdt_null)
if dwo.name= 'price_change_confirm_yn' then 
	
	if dw_1.object.price_change_confirm_yn[row] = 'Y' then

	dw_1.object.confirm_by[row] = Gvs_user_id
	dw_1.object.confirm_date[row] = f_sysdate()		
		
	else
		dw_1.object.confirm_by[row] = ''
		dw_1.object.confirm_date[row] = lvdt_null
	
	end if
	
end if
end event

type uo_tabpages from w_main_root`uo_tabpages within w_sal_sale_price_confirm
end type

type st_1 from so_statictext within w_sal_sale_price_confirm
integer x = 539
integer y = 104
integer width = 480
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Customer Code"
end type

type ddlb_customer_code from uo_customer_code within w_sal_sale_price_confirm
integer x = 539
integer y = 164
integer width = 480
integer taborder = 20
boolean bringtotop = true
end type

type ddlb_item_code from uo_item_code within w_sal_sale_price_confirm
integer x = 46
integer y = 164
integer width = 489
integer taborder = 40
boolean bringtotop = true
end type

type st_3 from so_statictext within w_sal_sale_price_confirm
integer x = 46
integer y = 104
integer width = 489
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type cb_confirm from so_commandbutton within w_sal_sale_price_confirm
integer x = 1861
integer y = 116
integer width = 411
integer height = 104
integer taborder = 60
boolean bringtotop = true
string text = "All Confirm"
end type

event clicked;call super::clicked;long i , j
if dw_1.getrow() < 1 then return
do
	i++
	if dw_1.object.check_yn[i] = 'Y' then 
	else
		continue
	end if
	
	dw_1.object.price_change_confirm_yn[i] = 'Y'
	dw_1.object.confirm_by[i] = Gvs_user_id
	dw_1.object.confirm_date[i] = f_sysdate()
	j++
loop until i = dw_1.rowcount()


if j > 0 then 
	
	msg = f_msgbox(1170)
	if msg = 1 then 
		f_update()
	else
		f_msg_mdi_help( f_msg_st( 9026) )		
	end if ;
else
	f_msg_mdi_help( f_msg_st( 9026) )
end if
end event

type cb_cancel from so_commandbutton within w_sal_sale_price_confirm
integer x = 2277
integer y = 116
integer width = 411
integer height = 104
integer taborder = 70
boolean bringtotop = true
boolean enabled = false
string text = "All Cancel"
end type

event clicked;call super::clicked;long i , j
datetime lvdt_null

setnull(lvdt_null)
if dw_1.getrow() < 1 then return
do
	i++
	if dw_1.object.check_yn[i] = 'Y' then 
	else
		continue
	end if
	
	dw_1.object.price_change_confirm_yn[i] = 'N'
	
	dw_1.object.confirm_by[i] = ''
	dw_1.object.confirm_date[i] = lvdt_null
	j++
loop until i = dw_1.rowcount()

if j > 0 then 
	
	msg = f_msgbox(1170)
	if msg = 1 then 
		f_update()
	else
		f_msg_mdi_help( f_msg_st( 9026) )		
	end if ;
else
	f_msg_mdi_help( f_msg_st( 9026) )
end if
end event

type rb_wait from so_radiobutton within w_sal_sale_price_confirm
integer x = 1216
integer y = 80
boolean bringtotop = true
integer weight = 700
string text = "Wait"
boolean checked = true
end type

event clicked;call super::clicked;cb_confirm.enabled = true
cb_cancel.enabled = false

end event

type rb_confirmed from so_radiobutton within w_sal_sale_price_confirm
integer x = 1216
integer y = 184
boolean bringtotop = true
integer weight = 700
string text = "Confirmed"
end type

event clicked;call super::clicked;cb_confirm.enabled = false
cb_cancel.enabled = true
end event

type gb_1 from so_groupbox within w_sal_sale_price_confirm
integer y = 4
integer width = 1115
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_sal_sale_price_confirm
integer x = 1797
integer width = 951
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_sal_sale_price_confirm
integer x = 1115
integer width = 677
integer height = 300
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Confirm/Cancel"
end type

