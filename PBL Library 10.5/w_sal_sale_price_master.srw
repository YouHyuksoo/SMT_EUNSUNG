HA$PBExportHeader$w_sal_sale_price_master.srw
$PBExportComments$Shipping Sale Price Master
forward
global type w_sal_sale_price_master from w_main_root
end type
type st_1 from so_statictext within w_sal_sale_price_master
end type
type ddlb_customer_code from uo_customer_code within w_sal_sale_price_master
end type
type ddlb_item_code from uo_item_code within w_sal_sale_price_master
end type
type st_3 from so_statictext within w_sal_sale_price_master
end type
type st_4 from so_statictext within w_sal_sale_price_master
end type
type sle_1 from so_singlelineedit within w_sal_sale_price_master
end type
type tab_1 from tab within w_sal_sale_price_master
end type
type tabpage_1 from userobject within tab_1
end type
type st_9 from so_statictext within tabpage_1
end type
type sle_sale_price_type from so_singlelineedit within tabpage_1
end type
type cbx_auto_confirm from so_checkbox within tabpage_1
end type
type cbx_auto_save from so_checkbox within tabpage_1
end type
type cb_close from so_commandbutton within tabpage_1
end type
type cb_copy from so_commandbutton within tabpage_1
end type
type uo_close_date from uo_ymd_calendar within tabpage_1
end type
type st_2 from so_statictext within tabpage_1
end type
type tabpage_1 from userobject within tab_1
st_9 st_9
sle_sale_price_type sle_sale_price_type
cbx_auto_confirm cbx_auto_confirm
cbx_auto_save cbx_auto_save
cb_close cb_close
cb_copy cb_copy
uo_close_date uo_close_date
st_2 st_2
end type
type tabpage_2 from userobject within tab_1
end type
type cb_2 from so_commandbutton within tabpage_2
end type
type ddlb_after_customer from uo_customer_code within tabpage_2
end type
type ddlb_before_customer from uo_customer_code within tabpage_2
end type
type st_6 from so_statictext within tabpage_2
end type
type st_5 from so_statictext within tabpage_2
end type
type tabpage_2 from userobject within tab_1
cb_2 cb_2
ddlb_after_customer ddlb_after_customer
ddlb_before_customer ddlb_before_customer
st_6 st_6
st_5 st_5
end type
type tabpage_3 from userobject within tab_1
end type
type ddlb_dest_customer_code from uo_customer_code_name within tabpage_3
end type
type st_7 from so_statictext within tabpage_3
end type
type cb_1 from so_commandbutton within tabpage_3
end type
type tabpage_3 from userobject within tab_1
ddlb_dest_customer_code ddlb_dest_customer_code
st_7 st_7
cb_1 cb_1
end type
type tabpage_4 from userobject within tab_1
end type
type pb_1 from so_commandbutton within tabpage_4
end type
type cb_5 from so_commandbutton within tabpage_4
end type
type st_19 from so_statictext within tabpage_4
end type
type uo_apply_date from uo_ymd_calendar within tabpage_4
end type
type rb_decreease from so_radiobutton within tabpage_4
end type
type rb_increase from so_radiobutton within tabpage_4
end type
type em_discount from so_editmask within tabpage_4
end type
type st_18 from so_statictext within tabpage_4
end type
type tabpage_4 from userobject within tab_1
pb_1 pb_1
cb_5 cb_5
st_19 st_19
uo_apply_date uo_apply_date
rb_decreease rb_decreease
rb_increase rb_increase
em_discount em_discount
st_18 st_18
end type
type tab_1 from tab within w_sal_sale_price_master
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type
type ddlb_item_division from uo_item_division within w_sal_sale_price_master
end type
type st_8 from so_statictext within w_sal_sale_price_master
end type
type rb_1 from so_radiobutton within w_sal_sale_price_master
end type
type rb_2 from so_radiobutton within w_sal_sale_price_master
end type
type rb_3 from so_radiobutton within w_sal_sale_price_master
end type
type rb_4 from so_radiobutton within w_sal_sale_price_master
end type
type rb_5 from so_radiobutton within w_sal_sale_price_master
end type
type rb_6 from so_radiobutton within w_sal_sale_price_master
end type
type pb_2 from so_commandbutton within w_sal_sale_price_master
end type
type gb_1 from so_groupbox within w_sal_sale_price_master
end type
type gb_3 from so_groupbox within w_sal_sale_price_master
end type
type gb_2 from so_groupbox within w_sal_sale_price_master
end type
end forward

global type w_sal_sale_price_master from w_main_root
integer width = 4645
integer height = 2736
string title = "Product Sale Price Master"
st_1 st_1
ddlb_customer_code ddlb_customer_code
ddlb_item_code ddlb_item_code
st_3 st_3
st_4 st_4
sle_1 sle_1
tab_1 tab_1
ddlb_item_division ddlb_item_division
st_8 st_8
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
rb_5 rb_5
rb_6 rb_6
pb_2 pb_2
gb_1 gb_1
gb_3 gb_3
gb_2 gb_2
end type
global w_sal_sale_price_master w_sal_sale_price_master

on w_sal_sale_price_master.create
int iCurrent
call super::create
this.st_1=create st_1
this.ddlb_customer_code=create ddlb_customer_code
this.ddlb_item_code=create ddlb_item_code
this.st_3=create st_3
this.st_4=create st_4
this.sle_1=create sle_1
this.tab_1=create tab_1
this.ddlb_item_division=create ddlb_item_division
this.st_8=create st_8
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.rb_5=create rb_5
this.rb_6=create rb_6
this.pb_2=create pb_2
this.gb_1=create gb_1
this.gb_3=create gb_3
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.ddlb_customer_code
this.Control[iCurrent+3]=this.ddlb_item_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.sle_1
this.Control[iCurrent+7]=this.tab_1
this.Control[iCurrent+8]=this.ddlb_item_division
this.Control[iCurrent+9]=this.st_8
this.Control[iCurrent+10]=this.rb_1
this.Control[iCurrent+11]=this.rb_2
this.Control[iCurrent+12]=this.rb_3
this.Control[iCurrent+13]=this.rb_4
this.Control[iCurrent+14]=this.rb_5
this.Control[iCurrent+15]=this.rb_6
this.Control[iCurrent+16]=this.pb_2
this.Control[iCurrent+17]=this.gb_1
this.Control[iCurrent+18]=this.gb_3
this.Control[iCurrent+19]=this.gb_2
end on

on w_sal_sale_price_master.destroy
call super::destroy
destroy(this.st_1)
destroy(this.ddlb_customer_code)
destroy(this.ddlb_item_code)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.sle_1)
destroy(this.tab_1)
destroy(this.ddlb_item_division)
destroy(this.st_8)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.rb_5)
destroy(this.rb_6)
destroy(this.pb_2)
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

end event

event ue_data_control;call super::ue_data_control;long row
STRING lvs_sale_charge
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
			    if Gvs_use_sale_charge_condition = 'Y' and Gvi_user_level < 8 then
					lvs_sale_charge = Gvs_user_id
				else
					lvs_sale_charge = '%'
				end if
			
			dw_1.reset()
			DW_3.reset()
			dw_1.retrieve(ddlb_item_code.text +'%' , ddlb_customer_code.text + '%', ddlb_item_division.getcode()+'%' , lvs_sale_charge , gvi_organization_id)
			DW_3.setfocus()
			
	case 'INSERT'
		
			DW_3.ENABLED = TRUE
			ROW = DW_3.INSERTROW(0)
			DW_3.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_3 , ROW ,'ALL')
			DW_3.object.dateset[row]  = f_t_sysdate()
			DW_3.object.dateend[row]= date('2999/12/31')
			
			IF Gvs_prod_sale_price_auto_confirm = 'Y' then
				DW_3.object.price_change_confirm_yn[row]= 'Y'			
				DW_3.object.confirm_by[row] = Gvs_user_id
				DW_3.object.confirm_date[row] = f_t_sysdate()
			else
				DW_3.object.price_change_confirm_yn[row]= 'N'			
			end if
			
			DW_3.object.price_type[row]= 'F'	 //$$HEX4$$55d615c8e8b200ac$$ENDHEX$$
			DW_3.object.product_line_type[row]= 'T' //$$HEX2$$90c791c7$$ENDHEX$$
			DW_3.object.price_change_reason[row]= 'N'
			DW_3.object.sale_currency[row]= Gvs_currency
			DW_3.object.sale_charge[row]= Gvs_user_id
	case 'APPEND'		
		
			DW_3.ENABLED = TRUE
			ROW = DW_3.INSERTROW(DW_3.GETROW())
			DW_3.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_3 , ROW ,'ALL')
			DW_3.object.dateset[row]  = f_t_sysdate()
			DW_3.object.dateend[row]= date('2999/12/31')
			
			IF Gvs_prod_sale_price_auto_confirm = 'Y' then
				DW_3.object.price_change_confirm_yn[row]= 'Y'			
				DW_3.object.confirm_by[row] = Gvs_user_id
				DW_3.object.confirm_date[row] = f_t_sysdate()
			else
				DW_3.object.price_change_confirm_yn[row]= 'N'			
			end if
			
			DW_3.object.price_type[row]= 'F'						
			DW_3.object.product_line_type[row]= 'T'
			DW_3.object.price_change_reason[row]= 'N'
			DW_3.object.sale_currency[row]= Gvs_currency
			DW_3.object.sale_charge[row]= Gvs_user_id
			
	case 'DELETE'
		
		  	if DW_3.AcceptText() = -1 then
				return
			end if
			
			if Gvs_prod_sale_price_auto_confirm = 'Y' then 
			else
			
				if DW_3.object.price_change_confirm_yn[DW_3.getrow()] = 'Y' then
					Messagebox("Notify" , "Aready Confirmed Can`t Delete")
					return
				end if
			end if
			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
                      DW_3.deleterow( DW_3.getrow( ) )
			END IF
			
			msg = f_msgbox(1170) 
			if msg = 1 then 
				f_update()
			else
				f_retrieve()
			end if 
			
	case 'UPDATE'
		
			IF  DW_3.UPDATE() < 0  THEN
			  	 ROLLBACK;
			ELSE
				 COMMIT;
 				 f_msg_mdi_help( f_msg_st( 170) ) //$$HEX7$$00c8a5c718b4c8c5b5c2c8b2e4b2$$ENDHEX$$
				 f_retrieve()
			END IF

	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_sal_sale_price_master
integer y = 476
end type

type dw_4 from w_main_root`dw_4 within w_sal_sale_price_master
integer y = 476
end type

type dw_3 from w_main_root`dw_3 within w_sal_sale_price_master
integer y = 1684
integer width = 4549
integer height = 588
string dataobject = "d_sal_sale_price_mst"
boolean maxbox = false
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_3::itemchanged;call super::itemchanged;string lvs_return 

if dwo.name = 'customer_code' then 
	lvs_return = f_get_customer_name(data)
	if lvs_return = 'ERROR' then 
		return  1 
	end if 
	if lvs_return = 'NOTFOUND'  then 
		return 1
	end if 
	this.object.customer_name[row] = lvs_return
end if 
end event

event dw_3::rbuttondown;call super::rbuttondown;if dwo.name = 'customer_code' then 
	open(w_com_customer_popup)
	if message.stringparm = '' then 
	else
		this.object.customer_code[row] = message.stringparm
		 this.trigger event itemchanged( row , this.object.customer_code , this.object.customer_code[row]  )
	end if 
end if 

if dwo.name = 'item_code' then 
	open(w_des_set_item_popup) 
	if gst_return.gvb_return = false then 
	else
		this.object.item_code[row] = MESSAGE.STRINGPARM
		this.object.item_name[row] = gst_return.gvs_return[3]
		this.object.item_spec[row] = gst_return.gvs_return[4]
		gst_return.gvs_return[3] = ''
		gst_return.gvs_return[4] = ''		
	end if 

end if 
		
	
end event

type dw_2 from w_main_root`dw_2 within w_sal_sale_price_master
integer x = 2217
integer y = 476
integer width = 2336
integer height = 1208
boolean titlebar = true
string dataobject = "d_des_bom_query_4_sale_price"
end type

event dw_2::clicked;call super::clicked;if  dwo.name = 'b_resize' then 
	
	this.bringtotop = true
	if dwo.text = '<' then
	
		dw_2.x = dw_3.x
		dw_2.width = dw_3.width
		dwo.text  = '>' 
	else
		
		dw_2.x = dw_1.x + dw_1.width
		dw_2.width = dw_1.width
		dwo.text = '<' 		
	end if
	
	
	
end if
end event

event dw_2::rbuttondown;call super::rbuttondown;if row < 1 then return


openwithparm(w_plan_routing_popup , string(this.object.route_no[row]))

if gst_return.gvb_return = true then
	
	this.object.route_no[row] = message.stringparm
	
else
end if
end event

type dw_1 from w_main_root`dw_1 within w_sal_sale_price_master
integer y = 476
integer width = 2217
integer height = 1208
boolean titlebar = true
string title = "Product Sale Price List"
string dataobject = "d_sal_sale_price_lst_tree"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;IF CURRENTROW = 0 THEN RETURN

if tab_1.tabpage_1.cbx_auto_save.checked = true then 
	IF DW_3.UPDATE() < 0  THEN
		 ROLLBACK;
	ELSE
		COMMIT;
	END IF
	
	 
end if

DW_3.RETRIEVE( DW_1.GETITEMSTRING( CURRENTROW , "ROWID" ) )

if DW_3.getrow() > 0 then 
	if DW_3.object.price_change_confirm_yn[DW_3.getrow()] = 'Y' then
	DW_3.enabled = false
	else
	DW_3.enabled = true
	end if
else
	DW_3.enabled = true	
end if

//==============================================
//
//==============================================

IF CURRENTROW < 1 THEN RETURN

DOUBLE LVDB_SESSION_ID
DW_2.RESET()


IF THIS.OBJECT.BOM_EXISTS_YN[CURRENTROW] = 'EXISTS' THEN
ELSE
	RETURN
END IF

IF  this.object.item_code[currentrow] = '%' THEN 
     F_MSGBOX(9050) //SET $$HEX9$$80bd88d444c7200085c725b858d538c194c6$$ENDHEX$$
	RETURN
END IF

//if cbx_show_hide.checked = true  then
	LVDB_SESSION_ID = F_BOM_QUERY_ALL_PRC( this.object.item_code[currentrow] , f_t_sysdate())
//else
//	LVDB_SESSION_ID = F_BOM_QUERY_PRC( this.object.item_code[currentrow] , f_t_sysdate())
//end if
IF LVDB_SESSION_ID <= 0 THEN
	ROLLBACK;
	f_msgbox1(9051 ,this.object.item_code[currentrow]  )    	
ELSE
		Decimal Lvf_exchange_rate = 1 
		
	     dw_2.RETRIEVE( LVDB_SESSION_ID ,  Gvs_currency , Lvf_exchange_rate , GVI_ORGANIZATION_ID )
		dw_2.SETFOCUS()
	ROLLBACK;
END IF

////$$HEX8$$00b3b4cc80bd88d420005cd4dcc22000$$ENDHEX$$
//IF CBX_SHOW_REPLACE_ITEM.CHECKED = TRUE THEN 
//	F_SET_REPLACE_ITEM_4_BOM_QUERY( dw_2 )
//	dw_2.RESETUPDATE()
//END IF

end event

event dw_1::doubleclicked;call super::doubleclicked;IF ROW < 1  THEN RETURN

if tab_1.tabpage_1.cbx_auto_save.checked = true then 
	IF DW_3.UPDATE() < 0  THEN
		 ROLLBACK;
	ELSE
		COMMIT;
	END IF
	
	 
end if

DW_3.RETRIEVE( DW_1.GETITEMSTRING( ROW , "ROWID" ) )

if DW_3.getrow() > 0 then 

	if DW_3.object.price_change_confirm_yn[DW_3.getrow()] = 'Y' then
		DW_3.enabled = false
	else
		DW_3.enabled = true
	end if
else
		DW_3.enabled = true
end if
end event

event dw_1::rbuttondown;call super::rbuttondown;if dwo.name = 'customer_code' then 
	open(w_com_customer_popup)
	if message.stringparm = '' then 
	else
		this.object.customer_code[row] = message.stringparm
		 this.trigger event itemchanged( row , this.object.customer_code , this.object.customer_code[row]  )
	end if 
end if 

end event

type uo_tabpages from w_main_root`uo_tabpages within w_sal_sale_price_master
end type

type st_1 from so_statictext within w_sal_sale_price_master
integer x = 549
integer y = 84
integer width = 480
integer height = 60
boolean bringtotop = true
string text = "Customer Code"
end type

type ddlb_customer_code from uo_customer_code within w_sal_sale_price_master
integer x = 549
integer y = 164
integer width = 480
integer taborder = 20
boolean bringtotop = true
end type

type ddlb_item_code from uo_item_code within w_sal_sale_price_master
integer x = 18
integer y = 164
integer width = 526
integer taborder = 40
boolean bringtotop = true
end type

type st_3 from so_statictext within w_sal_sale_price_master
integer x = 18
integer y = 84
integer width = 526
integer height = 60
boolean bringtotop = true
string text = "Item Code"
end type

type st_4 from so_statictext within w_sal_sale_price_master
integer x = 1029
integer y = 84
integer width = 608
integer height = 68
boolean bringtotop = true
long textcolor = 16711680
boolean enabled = false
string text = "Item Spec"
end type

type sle_1 from so_singlelineedit within w_sal_sale_price_master
integer x = 1029
integer y = 164
integer width = 608
integer height = 84
integer taborder = 50
boolean bringtotop = true
textcase textcase = upper!
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

LVS_COLUMN = "ITEM_SPEC"

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

DW_1.SETFILTER('')
DW_1.FILTER()

IF THIS.TEXT = '' THEN 
	DW_1.SETFILTER('')
	DW_1.FILTER()
	RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

DW_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
DW_1.FILTER()
F_MSG_MDI_HELP( STRING( DW_1.ROWCOUNT() ) + " Found")
end event

type tab_1 from tab within w_sal_sale_price_master
event create ( )
event destroy ( )
integer x = 2162
integer y = 4
integer width = 2363
integer height = 308
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
end on

type tabpage_1 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 2327
integer height = 180
long backcolor = 15780518
string text = "Process"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Regenerate5!"
long picturemaskcolor = 12632256
st_9 st_9
sle_sale_price_type sle_sale_price_type
cbx_auto_confirm cbx_auto_confirm
cbx_auto_save cbx_auto_save
cb_close cb_close
cb_copy cb_copy
uo_close_date uo_close_date
st_2 st_2
end type

on tabpage_1.create
this.st_9=create st_9
this.sle_sale_price_type=create sle_sale_price_type
this.cbx_auto_confirm=create cbx_auto_confirm
this.cbx_auto_save=create cbx_auto_save
this.cb_close=create cb_close
this.cb_copy=create cb_copy
this.uo_close_date=create uo_close_date
this.st_2=create st_2
this.Control[]={this.st_9,&
this.sle_sale_price_type,&
this.cbx_auto_confirm,&
this.cbx_auto_save,&
this.cb_close,&
this.cb_copy,&
this.uo_close_date,&
this.st_2}
end on

on tabpage_1.destroy
destroy(this.st_9)
destroy(this.sle_sale_price_type)
destroy(this.cbx_auto_confirm)
destroy(this.cbx_auto_save)
destroy(this.cb_close)
destroy(this.cb_copy)
destroy(this.uo_close_date)
destroy(this.st_2)
end on

type st_9 from so_statictext within tabpage_1
integer x = 814
integer y = 104
integer width = 375
integer height = 60
long backcolor = 15780518
string text = "Sale Prce Type"
alignment alignment = right!
end type

type sle_sale_price_type from so_singlelineedit within tabpage_1
integer x = 1216
integer y = 96
integer width = 155
integer taborder = 50
boolean enabled = false
end type

event constructor;call super::constructor;this.text = Gvs_product_sale_price_type
end event

type cbx_auto_confirm from so_checkbox within tabpage_1
integer x = 1216
integer y = 20
integer width = 503
integer height = 64
boolean bringtotop = true
long backcolor = 15780518
boolean enabled = false
string text = "Auto Confirm"
end type

event constructor;call super::constructor;if Gvs_prod_sale_price_auto_confirm = 'Y' then
	this.checked = true
else
	this.checked = false
end if
end event

type cbx_auto_save from so_checkbox within tabpage_1
integer x = 805
integer y = 20
integer width = 393
integer height = 64
boolean bringtotop = true
long backcolor = 15780518
string text = "Auto Save"
end type

type cb_close from so_commandbutton within tabpage_1
integer x = 466
integer y = 92
integer width = 320
integer height = 84
integer taborder = 40
boolean bringtotop = true
string text = "Close"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 
if DW_3.rowcount() < 1 then return 
datetime lvdt_close_date, lvdt_dateset, lvdt_dateend
lvdt_close_date      =      uo_close_date.text()
lvdt_dateset           =      DW_3.object.dateset[1]
lvdt_dateend          =      DW_3.object.dateend[1]
if lvdt_close_date > lvdt_dateset  and   lvdt_close_date < lvdt_dateend then 
	dw_3.object.dateend[1] = lvdt_close_date
else
	messagebox('Notify','The close date is invalid!')
	return 
end if 


end event

type cb_copy from so_commandbutton within tabpage_1
integer x = 466
integer y = 4
integer width = 320
integer height = 84
integer taborder = 50
boolean bringtotop = true
string text = "Copy"
end type

event clicked;call super::clicked;Datetime lvdt_null
setnull(lvdt_null)

if f_object_role_check() = false then return 
if dw_3.rowcount() < 1   then return 

dw_3.enabled = true
dw_3.rowscopy(1,1,Primary!, dw_3, 1, Primary!)

dw_3.object.product_sale_price[1] = 0 
dw_3.object.price_change_confirm_yn[1] = 'N'
dw_3.object.confirm_date[1] = lvdt_null

dw_3.object.dateset[1] =   f_t_sysdate()
dw_3.object.dateend[1] = date('2999-12-31')
end event

type uo_close_date from uo_ymd_calendar within tabpage_1
event destroy ( )
integer x = 37
integer y = 92
integer taborder = 40
boolean bringtotop = true
end type

on uo_close_date.destroy
call uo_ymd_calendar::destroy
end on

type st_2 from so_statictext within tabpage_1
integer x = 27
integer y = 24
integer width = 402
integer height = 72
boolean bringtotop = true
long backcolor = 15780518
string text = "Close Date"
end type

type tabpage_2 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 2327
integer height = 180
long backcolor = 15780518
string text = "Customer Change"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "EditObject!"
long picturemaskcolor = 12632256
cb_2 cb_2
ddlb_after_customer ddlb_after_customer
ddlb_before_customer ddlb_before_customer
st_6 st_6
st_5 st_5
end type

on tabpage_2.create
this.cb_2=create cb_2
this.ddlb_after_customer=create ddlb_after_customer
this.ddlb_before_customer=create ddlb_before_customer
this.st_6=create st_6
this.st_5=create st_5
this.Control[]={this.cb_2,&
this.ddlb_after_customer,&
this.ddlb_before_customer,&
this.st_6,&
this.st_5}
end on

on tabpage_2.destroy
destroy(this.cb_2)
destroy(this.ddlb_after_customer)
destroy(this.ddlb_before_customer)
destroy(this.st_6)
destroy(this.st_5)
end on

type cb_2 from so_commandbutton within tabpage_2
integer x = 1138
integer y = 36
integer width = 512
integer height = 136
integer taborder = 60
boolean bringtotop = true
string text = "Customer Change"
end type

event clicked;call super::clicked;STRING  LVS_AFTER_CUSTOMER , LVS_BEFORE_CUSTOMER

LVS_AFTER_CUSTOMER  = ddlb_after_CUSTOMER.text
LVS_BEFORE_CUSTOMER= ddlb_before_CUSTOMER.text

if LVS_BEFORE_CUSTOMER  = '' or LVS_BEFORE_CUSTOMER = '%' then
   Return
end if 

if LVS_AFTER_CUSTOMER  = '' or LVS_AFTER_CUSTOMER = '%' then
   Return
end if 

if LVS_AFTER_CUSTOMER =  LVS_BEFORE_CUSTOMER then
   Return
end if 

MSG = F_MSGBOX1( 1161 ,LVS_BEFORE_CUSTOMER+'  => '+ LVS_AFTER_CUSTOMER+'   ' +THIS.TEXT )
IF MSG = 1 THEN 
ELSE
	RETURN
END IF

UPDATE IS_PRODUCT_SALE_PRICE SET CUSTOMER_CODE = :LVS_AFTER_CUSTOMER
  WHERE CUSTOMER_CODE   = :LVS_BEFORE_CUSTOMER
     AND DATESET <= TRUNC(SYSDATE)
     AND DATEEND >= TRUNC(SYSDATE)	  
     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	  
IF F_SQL_CHECK() < 0 THEN 
	RETURN
END IF

MSG = F_MSGBOX( 1170 )

IF MSG = 1 THEN 
	COMMIT ;
	F_MSG_MDI_HELP( F_MSG_ST( 170) )
ELSE
	ROLLBACK ;
END IF
end event

type ddlb_after_customer from uo_customer_code within tabpage_2
integer x = 576
integer y = 84
integer width = 549
integer taborder = 40
boolean bringtotop = true
end type

type ddlb_before_customer from uo_customer_code within tabpage_2
integer x = 9
integer y = 84
integer width = 562
integer taborder = 30
boolean bringtotop = true
end type

type st_6 from so_statictext within tabpage_2
integer x = 9
integer y = 20
integer width = 562
integer height = 64
boolean bringtotop = true
integer weight = 700
long backcolor = 15780518
string text = "Before Customer"
end type

type st_5 from so_statictext within tabpage_2
integer x = 576
integer y = 20
integer width = 549
integer height = 64
boolean bringtotop = true
integer weight = 700
long backcolor = 15780518
string text = "After Customer"
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2327
integer height = 180
long backcolor = 12632256
string text = "Price Management"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Compile!"
long picturemaskcolor = 12632256
ddlb_dest_customer_code ddlb_dest_customer_code
st_7 st_7
cb_1 cb_1
end type

on tabpage_3.create
this.ddlb_dest_customer_code=create ddlb_dest_customer_code
this.st_7=create st_7
this.cb_1=create cb_1
this.Control[]={this.ddlb_dest_customer_code,&
this.st_7,&
this.cb_1}
end on

on tabpage_3.destroy
destroy(this.ddlb_dest_customer_code)
destroy(this.st_7)
destroy(this.cb_1)
end on

type ddlb_dest_customer_code from uo_customer_code_name within tabpage_3
integer x = 46
integer y = 88
integer width = 1070
integer height = 1468
integer taborder = 50
end type

type st_7 from so_statictext within tabpage_3
integer x = 46
integer y = 12
integer width = 1070
integer height = 64
boolean bringtotop = true
integer weight = 700
string text = "Customer Code"
end type

type cb_1 from so_commandbutton within tabpage_3
integer x = 1134
integer y = 28
integer height = 136
integer taborder = 50
string text = "Dupulicate"
end type

event clicked;call super::clicked;Datetime lvdt_null
setnull(lvdt_null)

if f_object_role_check() = false then return 
if DW_3.rowcount() < 1   then return 

DW_3.enabled = true
DW_3.rowscopy(1,1,Primary!, DW_3, 1, Primary!)

DW_3.object.customer_code[1] =   ddlb_dest_customer_code.getcode()

DW_3.object.dateset[1] =   f_t_sysdate()
DW_3.object.dateend[1] = date('2999-12-31')
end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2327
integer height = 180
long backcolor = 15780518
string text = "Price Change"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Compute5!"
long picturemaskcolor = 12632256
pb_1 pb_1
cb_5 cb_5
st_19 st_19
uo_apply_date uo_apply_date
rb_decreease rb_decreease
rb_increase rb_increase
em_discount em_discount
st_18 st_18
end type

on tabpage_4.create
this.pb_1=create pb_1
this.cb_5=create cb_5
this.st_19=create st_19
this.uo_apply_date=create uo_apply_date
this.rb_decreease=create rb_decreease
this.rb_increase=create rb_increase
this.em_discount=create em_discount
this.st_18=create st_18
this.Control[]={this.pb_1,&
this.cb_5,&
this.st_19,&
this.uo_apply_date,&
this.rb_decreease,&
this.rb_increase,&
this.em_discount,&
this.st_18}
end on

on tabpage_4.destroy
destroy(this.pb_1)
destroy(this.cb_5)
destroy(this.st_19)
destroy(this.uo_apply_date)
destroy(this.rb_decreease)
destroy(this.rb_increase)
destroy(this.em_discount)
destroy(this.st_18)
end on

type pb_1 from so_commandbutton within tabpage_4
integer x = 1842
integer y = 32
integer width = 402
integer height = 116
integer taborder = 60
string text = "Excel"
end type

event clicked;call super::clicked;open(w_sal_sale_price_excel_from_popup)
end event

type cb_5 from so_commandbutton within tabpage_4
integer x = 1435
integer y = 32
integer width = 402
integer height = 116
integer taborder = 50
string text = "Change"
end type

event clicked;call super::clicked;INT I , J 
STRING LVS_ROWID
DATETIME LVDT_DATESET , LVDT_DATEEND , LVDT_CONFIRM_DATE , LVDT_APPLY_DATE
STRING LVS_ITEM_CODE,LVS_CUSTOMER_CODE, LVS_PRODUCT_LINE_TYPE,LVS_SALE_CURRENCY,  LVS_PRICE_TYPE  
STRING LVS_PRICE_CHANGE_REASON,LVS_CONFIRM_BY, LVS_PRICE_CHANGE_CONFIRM_YN
DOUBLE  LVF_TAX_RATE,   LVF_STANDARD_SALE_PRICE , LVF_NEW_PRODUCT_SALE_PRICE , LVF_PRODUCT_SALE_PRICE
						
						
 DECLARE CL1 CURSOR FOR  
      SELECT DATESET,   
			ITEM_CODE,   
			CUSTOMER_CODE,   
			PRODUCT_LINE_TYPE,   
			SALE_CURRENCY,   
			PRODUCT_SALE_PRICE,   
			TAX_RATE,   
			PRICE_TYPE,   
			STANDARD_SALE_PRICE

    FROM IS_PRODUCT_SALE_PRICE 
  WHERE ROWID = :LVS_ROWID
	 AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;

if  dec(em_discount.text) = 100  or dec(em_discount.text) < 0 then
	f_msgbox(9026) 
	return
end if

//========================================
//
//========================================

DO
	I++
	
	IF DW_1.OBJECT.CHECK_YN[I] = 'Y' THEN
		
		LVS_ROWID = DW_1.OBJECT.ROWID[I]
		
	ELSE
		CONTINUE
	END IF 
	
	OPEN CL1 ;
	FETCH CL1 INTO      :LVDT_DATESET,   
						:LVS_ITEM_CODE,   
						:LVS_CUSTOMER_CODE,   
						:LVS_PRODUCT_LINE_TYPE,   
						:LVS_SALE_CURRENCY,   
						:LVF_PRODUCT_SALE_PRICE,   
						:LVF_TAX_RATE,   
						:LVS_PRICE_TYPE,   
						:LVF_STANDARD_SALE_PRICE;
						
			IF F_SQL_CHECK() < 0 THEN 
				CLOSE CL1;
				EXIT
			END IF 
			
			IF SQLCA.SQLCODE = 100 THEN 
				CLOSE CL1;
				EXIT
			END IF 
			
		if rb_increase.checked = true then 
			LVF_NEW_PRODUCT_SALE_PRICE= LVF_PRODUCT_SALE_PRICE+ ( LVF_PRODUCT_SALE_PRICE* dec( em_discount.text ) / 100 )
			LVS_PRICE_CHANGE_REASON = 'I'
		else
			LVF_NEW_PRODUCT_SALE_PRICE = LVF_PRODUCT_SALE_PRICE - (LVF_PRODUCT_SALE_PRICE * dec( em_discount.text ) / 100 )	
			LVS_PRICE_CHANGE_REASON = 'D'
		end if 			
			
		lvdt_apply_date = uo_apply_date.text()

		  INSERT INTO "IS_PRODUCT_SALE_PRICE"  
				 ( "DATESET",   
				   "ITEM_CODE",   
				   "CUSTOMER_CODE",   
				   "PRODUCT_LINE_TYPE",   
				   "ORGANIZATION_ID",   
				   "SALE_CURRENCY",   
				   "PRODUCT_SALE_PRICE",   
				   "TAX_RATE",   
				   "PRICE_TYPE",   
				   "STANDARD_SALE_PRICE",   
				   "DATEEND",   
				   "PRICE_CHANGE_REASON",   
				   "CONFIRM_BY",   
				   "PRICE_CHANGE_CONFIRM_YN",   
				   "CONFIRM_DATE",   
				   "ENTER_DATE",   
				   "ENTER_BY",   
				   "LAST_MODIFY_DATE",   
				   "LAST_MODIFY_BY" )  
		  VALUES (  :LVDT_APPLY_DATE , //LVDT_DATESET,   
					:LVS_ITEM_CODE,   
					:LVS_CUSTOMER_CODE,   
					:LVS_PRODUCT_LINE_TYPE,   
					:GVI_ORGANIZATION_ID ,
					:LVS_SALE_CURRENCY,   
					:LVF_NEW_PRODUCT_SALE_PRICE,   
					:LVF_TAX_RATE,   
					:LVS_PRICE_TYPE,   
					:LVF_STANDARD_SALE_PRICE,   
					TO_DATE( '99991231' , 'YYYYMMDD') , //:LVDT_DATEEND,   
					:LVS_PRICE_CHANGE_REASON,   
					'' , //:LVS_CONFIRM_BY,   
					'N' , //:LVS_PRICE_CHANGE_CONFIRM_YN,   
					:LVDT_CONFIRM_DATE ,
					SYSDATE ,:GVS_USER_ID , SYSDATE , :GVS_USER_ID )  ;
					
		CLOSE CL1;
		J++
LOOP UNTIL I = DW_1.ROWCOUNT()

IF J > 0 THEN  

	MSG = F_MSGBOX(1170)
	IF MSG = 1 THEN 
			COMMIT ;
	ELSE
			ROLLBACK;
	END IF 
ELSE
	ROLLBACK;
END IF 

end event

type st_19 from so_statictext within tabpage_4
integer x = 978
integer y = 24
integer width = 407
integer height = 76
boolean bringtotop = true
integer weight = 700
long backcolor = 15780518
string text = "Apply Date"
end type

type uo_apply_date from uo_ymd_calendar within tabpage_4
integer x = 978
integer y = 80
integer height = 76
integer taborder = 60
boolean bringtotop = true
end type

on uo_apply_date.destroy
call uo_ymd_calendar::destroy
end on

type rb_decreease from so_radiobutton within tabpage_4
integer x = 581
integer y = 104
integer width = 379
integer height = 44
integer weight = 700
long backcolor = 15780518
string text = "Decrease"
end type

type rb_increase from so_radiobutton within tabpage_4
integer x = 581
integer y = 40
integer width = 379
integer height = 56
integer weight = 700
long backcolor = 15780518
string text = "Increase"
boolean checked = true
end type

type em_discount from so_editmask within tabpage_4
integer x = 238
integer y = 60
integer width = 325
integer taborder = 110
string mask = "##0.0"
end type

type st_18 from so_statictext within tabpage_4
integer x = 18
integer y = 68
integer width = 224
integer height = 56
integer weight = 700
long backcolor = 15780518
string text = "Rate"
end type

type ddlb_item_division from uo_item_division within w_sal_sale_price_master
integer x = 1641
integer y = 164
integer width = 494
integer taborder = 20
boolean bringtotop = true
end type

type st_8 from so_statictext within w_sal_sale_price_master
integer x = 1637
integer y = 88
integer width = 480
integer height = 60
boolean bringtotop = true
string text = "Item Division"
end type

type rb_1 from so_radiobutton within w_sal_sale_price_master
integer x = 37
integer y = 368
integer width = 425
integer height = 64
boolean bringtotop = true
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;DW_1.SETFILTER('')
DW_1.FILTER()


end event

type rb_2 from so_radiobutton within w_sal_sale_price_master
integer x = 361
integer y = 364
integer width = 425
integer height = 64
boolean bringtotop = true
string text = "Running  Only"
end type

event clicked;call super::clicked;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

LVS_COLUMN = "STATUS"

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

DW_1.SETFILTER('')
DW_1.FILTER()

IF THIS.TEXT = '' THEN 
	DW_1.SETFILTER('')
	DW_1.FILTER()
	RETURN
END IF

DW_1.SETFILTER( LVS_COLUMN  +" = 'RUNNING'")
DW_1.FILTER()
F_MSG_MDI_HELP( STRING( DW_1.ROWCOUNT() ) + " Found")

DW_1.Sort( )
end event

type rb_3 from so_radiobutton within w_sal_sale_price_master
integer x = 896
integer y = 372
integer width = 425
integer height = 64
boolean bringtotop = true
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;DW_2.SETFILTER('')
DW_2.FILTER()


end event

type rb_4 from so_radiobutton within w_sal_sale_price_master
integer x = 1294
integer y = 372
integer width = 425
integer height = 64
boolean bringtotop = true
string text = "Line Type=T"
end type

event clicked;call super::clicked;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

LVS_COLUMN = "LINE_TYPE"

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

DW_2.SETFILTER('')
DW_2.FILTER()

IF THIS.TEXT = '' THEN 
	DW_2.SETFILTER('')
	DW_2.FILTER()
	RETURN
END IF

DW_2.SETFILTER( LVS_COLUMN  +" = 'T'")
DW_2.FILTER()
F_MSG_MDI_HELP( STRING( DW_2.ROWCOUNT() ) + " Found")

DW_2.Sort( )
end event

type rb_5 from so_radiobutton within w_sal_sale_price_master
integer x = 1783
integer y = 368
integer width = 425
integer height = 64
boolean bringtotop = true
string text = "Line Type=M"
end type

event clicked;call super::clicked;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

LVS_COLUMN = "LINE_TYPE"

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

DW_2.SETFILTER('')
DW_2.FILTER()

IF THIS.TEXT = '' THEN 
	DW_2.SETFILTER('')
	DW_2.FILTER()
	RETURN
END IF

DW_2.SETFILTER( LVS_COLUMN  +" = 'M'")
DW_2.FILTER()
F_MSG_MDI_HELP( STRING( DW_2.ROWCOUNT() ) + " Found")

DW_2.Sort( )
end event

type rb_6 from so_radiobutton within w_sal_sale_price_master
integer x = 2240
integer y = 368
integer width = 425
integer height = 64
boolean bringtotop = true
string text = "Line Type= D"
end type

event clicked;call super::clicked;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

LVS_COLUMN = "LINE_TYPE"

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

DW_2.SETFILTER('')
DW_2.FILTER()

IF THIS.TEXT = '' THEN 
	DW_2.SETFILTER('')
	DW_2.FILTER()
	RETURN
END IF

DW_2.SETFILTER( LVS_COLUMN  +" = 'D'")
DW_2.FILTER()
F_MSG_MDI_HELP( STRING( DW_2.ROWCOUNT() ) + " Found")

DW_2.Sort( )
end event

type pb_2 from so_commandbutton within w_sal_sale_price_master
integer x = 2825
integer y = 336
integer width = 379
integer height = 116
integer taborder = 60
boolean bringtotop = true
string text = "Price Check"
end type

event clicked;call super::clicked;string lvs_item_code , lvs_item_code_inc

declare cl1 cursor for
select item_code 
 from is_product_sale_price 
where dateset <= trunc(sysdate)
    and dateend >= trunc(sysdate)
    and organization_id = :gvi_organization_id 
group by customer_code , item_code , product_line_type , organization_id
having count(*) > 1  ;	 
	 
open cl1 ;

do 
	fetch cl1 into :lvs_item_code  ;
	
	if f_sql_check() < 0 then 
		close cl1;
		exit
	end if 
	
	if sqlca.sqlcode = 100 then 
		close cl1 ;
		exit
	end if 
	
	lvs_item_code_inc = lvs_item_code_inc + lvs_item_code+'~r~n'
	
loop until 1 =2

if lvs_item_code_inc = '' or isnull(lvs_item_code_inc) then 
	
	f_msgbox(117) 
	
else
	
	messagebox("Check" , lvs_item_code_inc ) 
	
end if 
end event

type gb_1 from so_groupbox within w_sal_sale_price_master
integer x = 859
integer y = 304
integer width = 1893
integer height = 156
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "BOM Filter"
end type

type gb_3 from so_groupbox within w_sal_sale_price_master
integer y = 4
integer width = 2149
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_sal_sale_price_master
integer y = 304
integer width = 855
integer height = 156
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Filter"
end type

