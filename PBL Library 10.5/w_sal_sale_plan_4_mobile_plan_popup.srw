HA$PBExportHeader$w_sal_sale_plan_4_mobile_plan_popup.srw
$PBExportComments$$$HEX10$$f9b2d4c6c4ac8dd61cc888bc20c1ddd01dd3c5c5$$ENDHEX$$
forward
global type w_sal_sale_plan_4_mobile_plan_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_sal_sale_plan_4_mobile_plan_popup
end type
type cb_select from so_commandbutton within w_sal_sale_plan_4_mobile_plan_popup
end type
type st_3 from so_statictext within w_sal_sale_plan_4_mobile_plan_popup
end type
type st_2 from statictext within w_sal_sale_plan_4_mobile_plan_popup
end type
type ddlb_customer_code from uo_customer_code within w_sal_sale_plan_4_mobile_plan_popup
end type
type cbx_auto_confirm from so_checkbox within w_sal_sale_plan_4_mobile_plan_popup
end type
type cb_divide from so_commandbutton within w_sal_sale_plan_4_mobile_plan_popup
end type
type cb_lot_save from so_commandbutton within w_sal_sale_plan_4_mobile_plan_popup
end type
type cb_1 from so_commandbutton within w_sal_sale_plan_4_mobile_plan_popup
end type
type rb_diff from so_radiobutton within w_sal_sale_plan_4_mobile_plan_popup
end type
type rb_all from so_radiobutton within w_sal_sale_plan_4_mobile_plan_popup
end type
type rb_1 from so_radiobutton within w_sal_sale_plan_4_mobile_plan_popup
end type
type uo_dateset from uo_ymd_calendar within w_sal_sale_plan_4_mobile_plan_popup
end type
type uo_dateend from uo_ymd_calendar within w_sal_sale_plan_4_mobile_plan_popup
end type
type st_1 from so_statictext within w_sal_sale_plan_4_mobile_plan_popup
end type
type rb_2 from so_radiobutton within w_sal_sale_plan_4_mobile_plan_popup
end type
type rb_3 from so_radiobutton within w_sal_sale_plan_4_mobile_plan_popup
end type
type rb_4 from so_radiobutton within w_sal_sale_plan_4_mobile_plan_popup
end type
type rb_5 from so_radiobutton within w_sal_sale_plan_4_mobile_plan_popup
end type
type ddlb_item_code from uo_item_code within w_sal_sale_plan_4_mobile_plan_popup
end type
type gb_1 from so_groupbox within w_sal_sale_plan_4_mobile_plan_popup
end type
type gb_2 from so_groupbox within w_sal_sale_plan_4_mobile_plan_popup
end type
type gb_6 from so_groupbox within w_sal_sale_plan_4_mobile_plan_popup
end type
type gb_3 from so_groupbox within w_sal_sale_plan_4_mobile_plan_popup
end type
type gb_4 from so_groupbox within w_sal_sale_plan_4_mobile_plan_popup
end type
end forward

global type w_sal_sale_plan_4_mobile_plan_popup from w_popup_root
integer width = 4210
integer height = 2508
string title = "Sale Plan Popup"
boolean contexthelp = false
cb_retrieve cb_retrieve
cb_select cb_select
st_3 st_3
st_2 st_2
ddlb_customer_code ddlb_customer_code
cbx_auto_confirm cbx_auto_confirm
cb_divide cb_divide
cb_lot_save cb_lot_save
cb_1 cb_1
rb_diff rb_diff
rb_all rb_all
rb_1 rb_1
uo_dateset uo_dateset
uo_dateend uo_dateend
st_1 st_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
rb_5 rb_5
ddlb_item_code ddlb_item_code
gb_1 gb_1
gb_2 gb_2
gb_6 gb_6
gb_3 gb_3
gb_4 gb_4
end type
global w_sal_sale_plan_4_mobile_plan_popup w_sal_sale_plan_4_mobile_plan_popup

on w_sal_sale_plan_4_mobile_plan_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.st_3=create st_3
this.st_2=create st_2
this.ddlb_customer_code=create ddlb_customer_code
this.cbx_auto_confirm=create cbx_auto_confirm
this.cb_divide=create cb_divide
this.cb_lot_save=create cb_lot_save
this.cb_1=create cb_1
this.rb_diff=create rb_diff
this.rb_all=create rb_all
this.rb_1=create rb_1
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_1=create st_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.rb_5=create rb_5
this.ddlb_item_code=create ddlb_item_code
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_6=create gb_6
this.gb_3=create gb_3
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.ddlb_customer_code
this.Control[iCurrent+6]=this.cbx_auto_confirm
this.Control[iCurrent+7]=this.cb_divide
this.Control[iCurrent+8]=this.cb_lot_save
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.rb_diff
this.Control[iCurrent+11]=this.rb_all
this.Control[iCurrent+12]=this.rb_1
this.Control[iCurrent+13]=this.uo_dateset
this.Control[iCurrent+14]=this.uo_dateend
this.Control[iCurrent+15]=this.st_1
this.Control[iCurrent+16]=this.rb_2
this.Control[iCurrent+17]=this.rb_3
this.Control[iCurrent+18]=this.rb_4
this.Control[iCurrent+19]=this.rb_5
this.Control[iCurrent+20]=this.ddlb_item_code
this.Control[iCurrent+21]=this.gb_1
this.Control[iCurrent+22]=this.gb_2
this.Control[iCurrent+23]=this.gb_6
this.Control[iCurrent+24]=this.gb_3
this.Control[iCurrent+25]=this.gb_4
end on

on w_sal_sale_plan_4_mobile_plan_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.ddlb_customer_code)
destroy(this.cbx_auto_confirm)
destroy(this.cb_divide)
destroy(this.cb_lot_save)
destroy(this.cb_1)
destroy(this.rb_diff)
destroy(this.rb_all)
destroy(this.rb_1)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.rb_5)
destroy(this.ddlb_item_code)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_6)
destroy(this.gb_3)
destroy(this.gb_4)
end on

event open;call super::open;dw_1.settransobject(sqlca)

ddlb_item_code.text =message.stringparm

cb_retrieve.triggerevent(CLICKED!)
IVS_MOUSEMOVE_YN = 'N'
end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
	
end if
end event

type p_title from w_popup_root`p_title within w_sal_sale_plan_4_mobile_plan_popup
integer width = 4210
end type

type cb_sort from w_popup_root`cb_sort within w_sal_sale_plan_4_mobile_plan_popup
boolean visible = true
integer x = 3026
integer y = 352
end type

type cb_close from w_popup_root`cb_close within w_sal_sale_plan_4_mobile_plan_popup
boolean visible = true
integer x = 3863
integer y = 352
end type

type st_msg from w_popup_root`st_msg within w_sal_sale_plan_4_mobile_plan_popup
boolean visible = true
integer x = 5
integer y = 704
integer width = 4210
end type

type dw_1 from w_popup_root`dw_1 within w_sal_sale_plan_4_mobile_plan_popup
boolean visible = true
integer y = 796
integer width = 4210
integer height = 1368
boolean titlebar = true
string title = "Sale Plan List"
string dataobject = "d_sal_product_sale_plan_4_mobilization_lst_tree"
end type

type dw_2 from w_popup_root`dw_2 within w_sal_sale_plan_4_mobile_plan_popup
boolean visible = true
integer y = 800
end type

type dw_3 from w_popup_root`dw_3 within w_sal_sale_plan_4_mobile_plan_popup
integer x = 9
integer y = 808
end type

type cb_retrieve from so_commandbutton within w_sal_sale_plan_4_mobile_plan_popup
integer x = 3305
integer y = 352
integer width = 274
integer height = 100
integer taborder = 70
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;SETPOINTER(HOURGLASS!)
dw_1.retrieve( uo_dateset.text() , uo_dateend.text() , ddlb_item_code.text+'%',ddlb_customer_code.text+'%' , gvi_organization_id)
dw_1.setfocus()
end event

type cb_select from so_commandbutton within w_sal_sale_plan_4_mobile_plan_popup
integer x = 3584
integer y = 352
integer width = 274
integer height = 100
integer taborder = 80
boolean bringtotop = true
string text = "Select"
boolean default = true
end type

event clicked;STRING LVS_ROWID , lvs_confirm_yn
DATETIME lvdt_confirm_date , lvdt_null
LONG I 

if dw_1.getrow() < 1 then 
	return
end if

MSG = F_MSGBOX1( 1161 , THIS.TEXT )
IF MSG = 1 THEN 
ELSE
	RETURN
END IF

if cbx_auto_confirm.checked = true then 
	lvs_confirm_yn = 'Y'
	lvdt_confirm_date = f_t_sysdate()
else
	lvs_confirm_yn = 'N'
	Setnull( lvdt_null )
	lvdt_confirm_date = lvdt_null
end if

DO
  I++
  
  IF dw_1.object.check_yn[i] = 'Y' and ( dw_1.object.plan_transfer_yn[i] = 'N' or isnull(dw_1.object.plan_transfer_yn[i])) then 
  else
	continue
   end if
	
 if dw_1.object.line_code[i] = '' OR ISNULL(	dw_1.object.line_code[i] ) then
    Messagebox("Notify" , "Line Code Invalid Please Check Line Code in Item Master ")	
	continue
end if

  lvs_rowid = dw_1.object.rowid[i]
	
  INSERT INTO IP_PRODUCT_MOBILIZATION  
         ( PLAN_YYYYMM,   
		PLAN_DATE,   
		ITEM_CODE,   
		PLAN_PRIORITY,	  
		ORGANIZATION_ID,  
		PRODUCT_LINE_TYPE,	  			  
		MODEL_DELIVERY_CODE,
		LINE_CODE ,
		WORKSTAGE_CODE,
		SALE_PLAN_TYPE,
		ORDER_QTY,   
		CUSTOMER_CODE,  
		CUSTOMER_ORDER_NO,  			  
		CONFIRM_YN,   
		CONFIRM_DATE,   
		WORK_DIVISION,	  
		PLAN_TRANSFER_YN,   
		PLAN_TRANSFER_DATE,   			  
		SHIPPING_ACCOUNT,	  
		DELIVERY_DATE,
		TOTAL_INVENTORY_QTY,
		INVENTORY_QTY,
		SAFETY_INVENTORY_QTY,		 
		ENTER_BY,   
		ENTER_DATE,   
		LAST_MODIFY_BY,   
		LAST_MODIFY_DATE , CUSTOMER_ORDER_NO_ORIGIN , MFS)  

SELECT A.PLAN_YYYYMM,   
		A.PLAN_DATE,   
		A.ITEM_CODE,   
		A.PLAN_PRIORITY,	  
		A.ORGANIZATION_ID,   
		A.PRODUCT_LINE_TYPE,	  
		A.MODEL_DELIVERY_CODE,		  
		B.LINE_CODE , //LINE CODE,		
		F_GET_WORKSTAGE_CODE_FROM_BOM( '%' , A.ITEM_CODE , TRUNC(A.PLAN_DATE) , A.ORGANIZATION_ID ) WORKSTAGE_CODE ,
		A.SALE_PLAN_TYPE ,
		A.ORDER_QTY,   
		A.CUSTOMER_CODE,   
		A.CUSTOMER_ORDER_NO,  			  			  
		:lvs_confirm_yn ,     //CONFIRM_YN,   
		:lvdt_confirm_date , //CONFIRM_DATE,   
		A.WORK_DIVISION,	  			  
		A.PLAN_TRANSFER_YN,   
		NULL ,	  
		A.SHIPPING_ACCOUNT,
		A.DELIVERY_DATE ,
		0 , 0 , 0 ,
		:GVS_USER_ID,
		SYSDATE,
		:GVS_USER_ID,
		SYSDATE , A.CUSTOMER_ORDER_NO_ORIGIN , MFS
 FROM IS_PRODUCT_SALE_PLAN A, ID_ITEM B
 WHERE A.ROWID = :LVS_ROWID 
	AND A.ITEM_CODE = B.ITEM_CODE
	AND B.LINE_CODE IS NOT NULL
	AND A.ORGANIZATION_ID = B.ORGANIZATION_ID ;
	
IF F_SQL_CHECK() < 0 THEN
	RETURN
END IF

//===========================================
//
//===========================================
	UPDATE IS_PRODUCT_SALE_PLAN 
	       SET PLAN_TRANSFER_YN = 'Y'
	 WHERE ROWID = :LVS_ROWID ;
	
		IF F_SQL_CHECK() < 0 THEN
			RETURN
		END IF
LOOP UNTIL I = dw_1.ROWCOUNT() 

//===========================================

MSG = F_MSGBOX( 1170 )
IF MSG = 1 THEN 
	COMMIT ;
	F_MSGBOX(170)
	F_MSG_MDI_HELP( F_MSG_ST( 170) )
	F_RETRIEVE()
ELSE
	ROLLBACK;
	F_MSG_MDI_HELP( F_MSG_ST( 9026) )	
END IF
 
close(parent) 
end event

type st_3 from so_statictext within w_sal_sale_plan_4_mobile_plan_popup
integer x = 859
integer y = 324
integer width = 558
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type st_2 from statictext within w_sal_sale_plan_4_mobile_plan_popup
integer x = 1435
integer y = 320
integer width = 457
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Customer Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_customer_code from uo_customer_code within w_sal_sale_plan_4_mobile_plan_popup
integer x = 1426
integer y = 396
integer taborder = 30
boolean bringtotop = true
end type

type cbx_auto_confirm from so_checkbox within w_sal_sale_plan_4_mobile_plan_popup
integer x = 3589
integer y = 252
boolean bringtotop = true
integer weight = 700
string text = "Auto Confirm"
boolean checked = true
end type

type cb_divide from so_commandbutton within w_sal_sale_plan_4_mobile_plan_popup
integer x = 2587
integer y = 604
integer width = 430
integer height = 76
integer taborder = 110
boolean bringtotop = true
boolean enabled = false
string text = "Lot Divide"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 

if dw_1.rowcount() < 1  then return 

long i , j ,k , lvl_count
Decimal  lvd_order_qty, lvd_new_qty

Do
	i++
	if dw_1.object.check_yn[i] = 'Y' then 
		j++
	end if
		
loop until i  = dw_1.rowcount() 
	
if j <> 1 then 	
	Messagebox("Nofity" , "Please check mark just one row")
	return
end if

		
		Long lvl_old_row
		//=======================================================
		// $$HEX28$$74c7f8bb200091c7c5c5c0c9dcc200ac2000b4b024b8c4c92000c4ac8dd640c720006fb8b8d2200084bd60d544c7200060d518c2c6c54cc7$$ENDHEX$$.
		//=======================================================
		if dw_1.object.check_yn[dw_1.getrow()] = 'Y' and dw_1.object.plan_transfer_yn[dw_1.getrow()] = 'N' then 
			
			lvl_old_row = dw_1.getrow()
		else
			Return
		end if
		
		lvd_order_qty = dw_1.object.order_qty[lvl_old_row]
		openwithparm(w_plan_master_plan_lot_popup,lvd_order_qty)
		
		if gst_return.gvb_return = true then 

			lvd_new_qty = message.doubleparm
			lvl_count   = Gst_return.Gvf_return[1]
			gst_return.gvf_return[1] = 0 
		else
			Return
		end if 
		
		if lvd_new_qty >=  lvd_order_qty then 
			messagebox('Notify','Divide qty should not be larger than the origin one!')
			return 
		end if 


IF lvd_order_qty - ( lvd_new_qty * lvl_count  ) > 0 THEN 

	dw_1.object.order_qty[lvl_old_row] = lvd_order_qty - ( lvd_new_qty * lvl_count  ) 
	dw_1.object.check_yn[lvl_old_row] = 'N'
	dw_1.object.lot_divide_yn[lvl_old_row] = 'Y'			
	
		DO
		k++
		dw_1.rowscopy(lvl_old_row, lvl_old_row, Primary!, dw_1,lvl_old_row,Primary!)		
		dw_1.object.customer_order_no[lvl_old_row] = f_get_any_no('CUSTOMER_ORDER_NO')
		dw_1.object.order_qty[lvl_old_row] = lvd_new_qty
		dw_1.object.check_yn[lvl_old_row] = 'N'
		dw_1.object.lot_divide_yn[lvl_old_row] = 'Y'
		
		LOOP UNTIL k  = lvl_count	
		dw_1.scrolltorow(lvl_old_row)
	
ELSEIF lvd_order_qty - ( lvd_new_qty * lvl_count  ) = 0 THEN 
	
		dw_1.object.order_qty[lvl_old_row] =lvd_new_qty
		dw_1.object.check_yn[lvl_old_row] = 'N'
		dw_1.object.lot_divide_yn[lvl_old_row] = 'Y'			
	
		DO
		k++
		dw_1.rowscopy(lvl_old_row, lvl_old_row, Primary!, dw_1,lvl_old_row,Primary!)		
		dw_1.object.customer_order_no[lvl_old_row] = f_get_any_no('CUSTOMER_ORDER_NO')
		dw_1.object.order_qty[lvl_old_row] = lvd_new_qty
		dw_1.object.check_yn[lvl_old_row] = 'N'
		dw_1.object.lot_divide_yn[lvl_old_row] = 'Y'

		LOOP UNTIL k  = lvl_count - 1
		
		dw_1.scrolltorow(lvl_old_row)

ELSE
	
	MESSAGEBOX("Notify" , "Lot Divide Qty Invalid" ) 
	
END IF 


//======================================================================
MSG = F_MSGBOX( 1170 )
IF MSG = 1 THEN
	if dw_1.update() < 0 then
		rollback;
	else
		commit;
		f_msg_mdi_help(f_msg_st(170))
	end if
END IF
end event

type cb_lot_save from so_commandbutton within w_sal_sale_plan_4_mobile_plan_popup
integer x = 3031
integer y = 604
integer width = 430
integer height = 76
integer taborder = 120
boolean bringtotop = true
boolean enabled = false
string text = "Lot Save"
end type

event clicked;call super::clicked;MSG = F_MSGBOX( 1170 )
IF MSG = 1 THEN
	if dw_1.update() < 0 then
		rollback;
	else
		commit;
		f_msg_mdi_help(f_msg_st(170))
	end if
END IF
end event

type cb_1 from so_commandbutton within w_sal_sale_plan_4_mobile_plan_popup
integer x = 2153
integer y = 604
integer width = 430
integer height = 76
integer taborder = 130
boolean bringtotop = true
boolean enabled = false
string text = "Lot Merge"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 
if dw_1.rowcount() < 1  then return 
long i , j = 0 , lvl_row[2], k= 1
Decimal  lvd_qty

for i = 1 to dw_1.rowcount()
	
	 if dw_1.object.check_yn[i] = 'Y' then 
		j++
	 else
		
	 end if
next

if j <> 2 then 
	messagebox('Notify','You have to select two records, please do again!')
	return 
end if 

for i = 1 to dw_1.rowcount()
	
	if dw_1.object.check_yn[i] = 'Y' then 
		lvl_row[k] = dw_1.object.selected_row[i]
		k++
	end if 
	
next


msg = f_msgbox1( 1161 , this.text )
if msg = 1 then 
else
	return
end if

if dw_1.object.item_code[lvl_row[1]]  = dw_1.object.item_code[lvl_row[2]]   and dw_1.object.customer_order_no_origin[lvl_row[1]]  = dw_1.object.customer_order_no_origin[lvl_row[2]]   then
	
	lvd_qty =  dw_1.object.order_qty[lvl_row[1]] + dw_1.object.order_qty[lvl_row[2]]
	
	dw_1.object.order_qty[lvl_row[1]]  = lvd_qty

	dw_1.deleterow(lvl_row[2])
	
			IF DW_1.UPDATE() < 0  THEN
			  	 ROLLBACK;
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			END IF
               F_RETRIEVE()	
	
else
	messagebox('Notify','This two records are not match!')
	return 
end if 

	
end event

type rb_diff from so_radiobutton within w_sal_sale_plan_4_mobile_plan_popup
integer x = 2167
integer y = 424
integer width = 512
boolean bringtotop = true
integer weight = 700
string text = "Plan Transfer =Y"
end type

event clicked;call super::clicked;dw_1.setfilter( " plan_transfer_yn = '"+"Y'")
dw_1.filter()
end event

type rb_all from so_radiobutton within w_sal_sale_plan_4_mobile_plan_popup
integer x = 2171
integer y = 308
integer width = 407
boolean bringtotop = true
integer weight = 700
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.SetFilter("")
dw_1.filter()


end event

type rb_1 from so_radiobutton within w_sal_sale_plan_4_mobile_plan_popup
integer x = 2446
integer y = 304
integer width = 512
boolean bringtotop = true
integer weight = 700
string text = "Plan Transfer =N"
end type

event clicked;call super::clicked;dw_1.setfilter( " plan_transfer_yn = '"+"N'")
dw_1.filter()
end event

type uo_dateset from uo_ymd_calendar within w_sal_sale_plan_4_mobile_plan_popup
integer x = 27
integer y = 400
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_sal_sale_plan_4_mobile_plan_popup
integer x = 439
integer y = 400
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_1 from so_statictext within w_sal_sale_plan_4_mobile_plan_popup
integer x = 41
integer y = 328
integer width = 795
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Delivery Date"
end type

type rb_2 from so_radiobutton within w_sal_sale_plan_4_mobile_plan_popup
integer x = 46
integer y = 588
integer width = 393
boolean bringtotop = true
integer weight = 700
string text = "Today"
end type

event clicked;call super::clicked;uo_dateend.settext( string(f_t_sysdate()) )
end event

type rb_3 from so_radiobutton within w_sal_sale_plan_4_mobile_plan_popup
integer x = 462
integer y = 588
integer width = 512
boolean bringtotop = true
integer weight = 700
string text = "Today + 1 Week"
end type

event clicked;call super::clicked;uo_dateend.settext( string(f_v_sysdate(-7)) )
end event

type rb_4 from so_radiobutton within w_sal_sale_plan_4_mobile_plan_popup
integer x = 1024
integer y = 588
integer width = 512
boolean bringtotop = true
integer weight = 700
string text = "Today + 2 Week"
end type

event clicked;call super::clicked;uo_dateend.settext( string(f_v_sysdate(-14)) )
end event

type rb_5 from so_radiobutton within w_sal_sale_plan_4_mobile_plan_popup
integer x = 1563
integer y = 588
integer width = 512
boolean bringtotop = true
integer weight = 700
string text = "Today + 4 Week"
end type

event clicked;call super::clicked;uo_dateend.settext( string(f_v_sysdate(-28)) )
end event

type ddlb_item_code from uo_item_code within w_sal_sale_plan_4_mobile_plan_popup
integer x = 859
integer y = 400
integer width = 558
integer taborder = 40
boolean bringtotop = true
end type

type gb_1 from so_groupbox within w_sal_sale_plan_4_mobile_plan_popup
integer x = 2990
integer y = 220
integer width = 1189
integer height = 328
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_sal_sale_plan_4_mobile_plan_popup
integer x = 5
integer y = 220
integer width = 2089
integer height = 328
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_6 from so_groupbox within w_sal_sale_plan_4_mobile_plan_popup
integer x = 2107
integer y = 220
integer width = 864
integer height = 328
integer taborder = 60
integer weight = 700
long textcolor = 16711680
string text = "Filter"
end type

type gb_3 from so_groupbox within w_sal_sale_plan_4_mobile_plan_popup
integer x = 9
integer y = 544
integer width = 2085
integer height = 148
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Date Filter"
end type

type gb_4 from so_groupbox within w_sal_sale_plan_4_mobile_plan_popup
integer x = 2112
integer y = 548
integer width = 1385
integer height = 148
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Lot Manage"
end type

