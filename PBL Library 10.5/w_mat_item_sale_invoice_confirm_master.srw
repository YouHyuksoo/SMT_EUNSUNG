HA$PBExportHeader$w_mat_item_sale_invoice_confirm_master.srw
$PBExportComments$Product Sale Invoice Master
forward
global type w_mat_item_sale_invoice_confirm_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mat_item_sale_invoice_confirm_master
end type
type uo_dateend from uo_ymd_calendar within w_mat_item_sale_invoice_confirm_master
end type
type st_1 from statictext within w_mat_item_sale_invoice_confirm_master
end type
type ddlb_customer_code from uo_customer_code within w_mat_item_sale_invoice_confirm_master
end type
type st_2 from so_statictext within w_mat_item_sale_invoice_confirm_master
end type
type rb_sale_invoice_list from so_radiobutton within w_mat_item_sale_invoice_confirm_master
end type
type rb_sale_invoice_history from so_radiobutton within w_mat_item_sale_invoice_confirm_master
end type
type cb_cancel from so_commandbutton within w_mat_item_sale_invoice_confirm_master
end type
type cb_confirm from so_commandbutton within w_mat_item_sale_invoice_confirm_master
end type
type gb_2 from so_groupbox within w_mat_item_sale_invoice_confirm_master
end type
type gb_5 from so_groupbox within w_mat_item_sale_invoice_confirm_master
end type
type gb_1 from so_groupbox within w_mat_item_sale_invoice_confirm_master
end type
end forward

global type w_mat_item_sale_invoice_confirm_master from w_main_root
integer width = 5065
integer height = 3840
string title = "Item Sale Invoice Master"
uo_dateset uo_dateset
uo_dateend uo_dateend
st_1 st_1
ddlb_customer_code ddlb_customer_code
st_2 st_2
rb_sale_invoice_list rb_sale_invoice_list
rb_sale_invoice_history rb_sale_invoice_history
cb_cancel cb_cancel
cb_confirm cb_confirm
gb_2 gb_2
gb_5 gb_5
gb_1 gb_1
end type
global w_mat_item_sale_invoice_confirm_master w_mat_item_sale_invoice_confirm_master

on w_mat_item_sale_invoice_confirm_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_1=create st_1
this.ddlb_customer_code=create ddlb_customer_code
this.st_2=create st_2
this.rb_sale_invoice_list=create rb_sale_invoice_list
this.rb_sale_invoice_history=create rb_sale_invoice_history
this.cb_cancel=create cb_cancel
this.cb_confirm=create cb_confirm
this.gb_2=create gb_2
this.gb_5=create gb_5
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.ddlb_customer_code
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.rb_sale_invoice_list
this.Control[iCurrent+7]=this.rb_sale_invoice_history
this.Control[iCurrent+8]=this.cb_cancel
this.Control[iCurrent+9]=this.cb_confirm
this.Control[iCurrent+10]=this.gb_2
this.Control[iCurrent+11]=this.gb_5
this.Control[iCurrent+12]=this.gb_1
end on

on w_mat_item_sale_invoice_confirm_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_1)
destroy(this.ddlb_customer_code)
destroy(this.st_2)
destroy(this.rb_sale_invoice_list)
destroy(this.rb_sale_invoice_history)
destroy(this.cb_cancel)
destroy(this.cb_confirm)
destroy(this.gb_2)
destroy(this.gb_5)
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

event ue_post_open;call super::ue_post_open;uo_dateset.settext(string(f_t_sysdate(), 'yyyy/mm')+'/01')
/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

event ue_data_control;call super::ue_data_control;long row
choose case gvs_ue_data_control
		
	case 'RETRIEVE'		
			dw_1.reset()
			if rb_sale_invoice_list.checked = true then 			
		    dw_1.retrieve(uo_dateset.text() , uo_dateend.text(),ddlb_customer_code.text + '%' ,  gvi_organization_id)
		else
			dw_2.reset()			
			dw_2.retrieve(uo_dateset.text() , uo_dateend.text(), ddlb_customer_code.text + '%', gvi_organization_id)
		end if 

	case 'UPDATE'
		

	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mat_item_sale_invoice_confirm_master
integer y = 324
integer height = 376
end type

type dw_4 from w_main_root`dw_4 within w_mat_item_sale_invoice_confirm_master
integer y = 324
integer height = 376
end type

type dw_3 from w_main_root`dw_3 within w_mat_item_sale_invoice_confirm_master
integer y = 324
integer height = 376
end type

type dw_2 from w_main_root`dw_2 within w_mat_item_sale_invoice_confirm_master
integer y = 324
integer width = 4535
integer height = 1788
boolean titlebar = true
string title = "Item Sale Invoice Confirm History"
string dataobject = "d_mat_item_sale_invoice_4_history_lst"
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_2::itemchanged;call super::itemchanged;if dwo.name = 'check_yn' then 
	this.accepttext()
	if data= 'Y' then
		
		this.object.invoice_open_yn[row] = 'R'
		
	else
		
		this.object.invoice_open_yn[row] = 'Y'
		
	end if
	
end if

end event

type dw_1 from w_main_root`dw_1 within w_mat_item_sale_invoice_confirm_master
integer y = 324
integer width = 4535
integer height = 1788
boolean titlebar = true
string title = "Item Sale Invoice List"
string dataobject = "d_mat_item_sale_invoice_4_confirm_lst"
end type

event dw_1::itemchanged;call super::itemchanged;if dwo.name = 'check_yn' then 
	this.accepttext()
	if data= 'Y' then
		
		this.object.invoice_open_yn[row] = 'Y'
		
	else
		
		this.object.invoice_open_yn[row] = 'R'
		
	end if
	
end if

end event

type uo_dateset from uo_ymd_calendar within w_mat_item_sale_invoice_confirm_master
event destroy ( )
integer x = 759
integer y = 160
integer width = 402
integer taborder = 110
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_item_sale_invoice_confirm_master
event destroy ( )
integer x = 1161
integer y = 160
integer width = 402
integer taborder = 120
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_1 from statictext within w_mat_item_sale_invoice_confirm_master
integer x = 759
integer y = 84
integer width = 786
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
string text = "Invoice Date"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_customer_code from uo_customer_code within w_mat_item_sale_invoice_confirm_master
integer x = 1563
integer y = 160
integer width = 485
integer taborder = 30
boolean bringtotop = true
end type

type st_2 from so_statictext within w_mat_item_sale_invoice_confirm_master
integer x = 1563
integer y = 96
integer width = 485
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Customer Code"
end type

type rb_sale_invoice_list from so_radiobutton within w_mat_item_sale_invoice_confirm_master
integer x = 37
integer y = 84
integer width = 654
boolean bringtotop = true
integer weight = 700
string text = "Sale Invoice List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1
cb_confirm.enabled = true
cb_cancel.enabled = false



end event

type rb_sale_invoice_history from so_radiobutton within w_mat_item_sale_invoice_confirm_master
integer x = 37
integer y = 176
integer width = 654
boolean bringtotop = true
integer weight = 700
string text = "Sale Invoice History"
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
selected_data_window = dw_2
cb_confirm.enabled = false
cb_cancel.enabled = true




end event

type cb_cancel from so_commandbutton within w_mat_item_sale_invoice_confirm_master
integer x = 2601
integer y = 108
integer width = 471
integer height = 120
integer taborder = 30
boolean bringtotop = true
boolean enabled = false
string text = "Cancel"
end type

event clicked;call super::clicked;IF DW_2.UPDATE() < 0 THEN
	 ROLLBACK;
ELSE
	 COMMIT;
	 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
      F_RETRIEVE()
END IF              
end event

type cb_confirm from so_commandbutton within w_mat_item_sale_invoice_confirm_master
integer x = 2135
integer y = 108
integer width = 471
integer height = 120
integer taborder = 40
boolean bringtotop = true
string text = "Confirm"
end type

event clicked;call super::clicked;IF DW_1.UPDATE() < 0 THEN
	 ROLLBACK;
ELSE
	 COMMIT;
	 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
	  F_RETRIEVE()
END IF              
end event

type gb_2 from so_groupbox within w_mat_item_sale_invoice_confirm_master
integer x = 2085
integer width = 1038
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_5 from so_groupbox within w_mat_item_sale_invoice_confirm_master
integer y = 4
integer width = 722
integer height = 300
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_1 from so_groupbox within w_mat_item_sale_invoice_confirm_master
integer x = 722
integer y = 4
integer width = 1353
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

