HA$PBExportHeader$w_mat_item_master.srw
$PBExportComments$Material Item Master
forward
global type w_mat_item_master from w_main_root
end type
type st_1 from so_statictext within w_mat_item_master
end type
type ddlb_item_code from uo_item_code within w_mat_item_master
end type
type ddlb_supplier_code from uo_supplier_code within w_mat_item_master
end type
type st_2 from so_statictext within w_mat_item_master
end type
type sle_item_name from so_singlelineedit within w_mat_item_master
end type
type st_14 from so_statictext within w_mat_item_master
end type
type sle_1 from so_singlelineedit within w_mat_item_master
end type
type st_3 from so_statictext within w_mat_item_master
end type
type tab_1 from tab within w_mat_item_master
end type
type tabpage_1 from userobject within tab_1
end type
type st_10 from statictext within tabpage_1
end type
type cb_1 from so_commandbutton within tabpage_1
end type
type tabpage_1 from userobject within tab_1
st_10 st_10
cb_1 cb_1
end type
type tabpage_2 from userobject within tab_1
end type
type cb_5 from so_commandbutton within tabpage_2
end type
type cb_2 from so_commandbutton within tabpage_2
end type
type st_4 from so_statictext within tabpage_2
end type
type ddlb_after_supplier from uo_supplier_code within tabpage_2
end type
type ddlb_before_supplier from uo_supplier_code within tabpage_2
end type
type st_5 from so_statictext within tabpage_2
end type
type tabpage_2 from userobject within tab_1
cb_5 cb_5
cb_2 cb_2
st_4 st_4
ddlb_after_supplier ddlb_after_supplier
ddlb_before_supplier ddlb_before_supplier
st_5 st_5
end type
type tabpage_3 from userobject within tab_1
end type
type ddlb_to_org from uo_orz_id within tabpage_3
end type
type st_9 from so_statictext within tabpage_3
end type
type st_8 from so_statictext within tabpage_3
end type
type ddlb_from_org from uo_orz_id within tabpage_3
end type
type cb_3 from so_commandbutton within tabpage_3
end type
type tabpage_3 from userobject within tab_1
ddlb_to_org ddlb_to_org
st_9 st_9
st_8 st_8
ddlb_from_org ddlb_from_org
cb_3 cb_3
end type
type tabpage_4 from userobject within tab_1
end type
type st_7 from so_statictext within tabpage_4
end type
type st_6 from so_statictext within tabpage_4
end type
type cb_4 from so_commandbutton within tabpage_4
end type
type sle_after from so_singlelineedit within tabpage_4
end type
type sle_before from so_singlelineedit within tabpage_4
end type
type tabpage_4 from userobject within tab_1
st_7 st_7
st_6 st_6
cb_4 cb_4
sle_after sle_after
sle_before sle_before
end type
type tab_1 from tab within w_mat_item_master
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type
type gb_2 from so_groupbox within w_mat_item_master
end type
end forward

global type w_mat_item_master from w_main_root
integer width = 4608
integer height = 2640
string title = "Material Master"
st_1 st_1
ddlb_item_code ddlb_item_code
ddlb_supplier_code ddlb_supplier_code
st_2 st_2
sle_item_name sle_item_name
st_14 st_14
sle_1 sle_1
st_3 st_3
tab_1 tab_1
gb_2 gb_2
end type
global w_mat_item_master w_mat_item_master

on w_mat_item_master.create
int iCurrent
call super::create
this.st_1=create st_1
this.ddlb_item_code=create ddlb_item_code
this.ddlb_supplier_code=create ddlb_supplier_code
this.st_2=create st_2
this.sle_item_name=create sle_item_name
this.st_14=create st_14
this.sle_1=create sle_1
this.st_3=create st_3
this.tab_1=create tab_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.ddlb_item_code
this.Control[iCurrent+3]=this.ddlb_supplier_code
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.sle_item_name
this.Control[iCurrent+6]=this.st_14
this.Control[iCurrent+7]=this.sle_1
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.tab_1
this.Control[iCurrent+10]=this.gb_2
end on

on w_mat_item_master.destroy
call super::destroy
destroy(this.st_1)
destroy(this.ddlb_item_code)
destroy(this.ddlb_supplier_code)
destroy(this.st_2)
destroy(this.sle_item_name)
destroy(this.st_14)
destroy(this.sle_1)
destroy(this.st_3)
destroy(this.tab_1)
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
Ivs_resize_type                      = 'MASTER_DETAIL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


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
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		     DW_1.RESET()
			DW_2.RESET()
			dw_1.retrieve(ddlb_item_code.text() + '%',ddlb_supplier_code.text + '%' ,  gvi_organization_id)
		
	case 'INSERT'
		     DW_2.RESET()
			DW_2.ENABLED = TRUE
			ROW = DW_2.INSERTROW(DW_2.GETROW())
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')
			dw_2.object.dateset[row] = f_t_sysdate()
			dw_2.object.dateend[row] = date('2999-12-31')
			dw_2.object.order_type[row] = 'M'
			dw_2.object.inspect_rule[row] = 'I'
			dw_2.object.inspect_method[row] = 'S'						
			dw_2.object.main_vendor_yn[row] = 'Y'
			dw_2.object.order_rate[row] = 100
			dw_2.object.payment_type[row] = 'L'
			dw_2.object.longterm_delivery_yn[row] = 'N'			
			
	case 'APPEND'		
		
			f_set_column_initial_value( dw_2 , 0 , 'ALL' )
			
	case 'DELETE'
		
		  	if dw_2.AcceptText() = -1 then
				return
			end if
			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
				Gvl_row_deleted = dw_2.GetRow()			
				dw_2.DELETEROW(Gvl_row_deleted)		
				dw_2.SetFocus()
				ROW = dw_2.GetRow()
				dw_2.ScrollToRow(row)
				dw_2.SetColumn(1)
			END IF
	case 'UPDATE'
		
			IF DW_1.UPDATE() < 0 OR DW_2.UPDATE() < 0  THEN
			  	 ROLLBACK;
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
	                F_RETRIEVE()				 
			END IF

	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mat_item_master
integer y = 312
end type

type dw_4 from w_main_root`dw_4 within w_mat_item_master
integer x = 37
integer y = 324
end type

type dw_3 from w_main_root`dw_3 within w_mat_item_master
integer y = 388
end type

type dw_2 from w_main_root`dw_2 within w_mat_item_master
integer y = 1716
integer width = 4544
integer height = 592
string dataobject = "d_mat_item_mst"
end type

event dw_2::rbuttondown;call super::rbuttondown;if dwo.name = 'supplier_code' then 
	open(w_com_supplier_popup)
	if message.stringparm = '' then 
	else
		this.object.supplier_code[row] = message.stringparm	
		IF ivs_modify_security = 'Y' THEN 
			F_SET_SECURITY_ROW( THIS , ROW , 'MODIFY' )
		END IF		
	end if 
	gst_return.gvs_return[1]	 = ''
end if 

if dwo.name = 'item_code' then 
	open(w_des_item_popup) 
	if gst_return.gvb_return = false then 
	else
		this.object.item_code[row] = MESSAGE.STRINGPARM
		this.object.item_name[row] = gst_return.gvs_return[3]
		this.object.item_spec[row] = gst_return.gvs_return[4]
		this.object.item_uom[row] = gst_return.gvs_return[5]		
		IF ivs_modify_security = 'Y' THEN 
			F_SET_SECURITY_ROW( THIS , ROW , 'MODIFY' )
		END IF		
		gst_return.gvs_return[3] = ''
		gst_return.gvs_return[4] = ''		
		gst_return.gvs_return[5] = ''				
	end if 

end if 


if dwo.name = 'warehouse_charge' then 
	
	open(w_user_popup )
	
	if message.stringparm = '' then 
	else
		
		this.object.warehouse_charge[row] = message.stringparm
		IF ivs_modify_security = 'Y' THEN 
			F_SET_SECURITY_ROW( THIS , ROW , 'MODIFY' )
		END IF		
	end if
	
end if

if dwo.name = 'order_charge' then 
	open(w_user_popup )	
	if message.stringparm = '' then 
	else
		
		this.object.order_charge[row] = message.stringparm
		IF ivs_modify_security = 'Y' THEN 
			F_SET_SECURITY_ROW( THIS , ROW , 'MODIFY' )
		END IF		
	end if
	
end if
end event

event dw_2::itemchanged;call super::itemchanged;string lvs_return
if dwo.name = 'item_code' then 
	
     lvs_return = f_set_item_name_spec_uom( this , row , this.object.item_code[row] )		

	if 	lvs_return = 'ERROR' THEN 
		return 1
	end if	
		
	if lvs_return = 'NOTFOUND' then 
		return 1  
	end if 		
end if
end event

type dw_1 from w_main_root`dw_1 within w_mat_item_master
integer y = 308
integer width = 4544
integer height = 1396
boolean titlebar = true
string title = "Material Item List"
string dataobject = "d_mat_item_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;IF CURRENTROW = 0 THEN RETURN
DW_2.RETRIEVE( DW_1.GETITEMSTRING( CURRENTROW , 'ROWID' ) )

end event

event dw_1::doubleclicked;call super::doubleclicked;IF ROW < 1  THEN RETURN
DW_2.RETRIEVE( DW_1.GETITEMSTRING( ROW , 'ROWID' ) )

end event

event dw_1::rbuttondown;call super::rbuttondown;if dwo.name = 'supplier_code' then 
	open(w_com_supplier_popup)
	if message.stringparm = '' then 
	else
		this.object.supplier_code[row] = message.stringparm	
		IF ivs_modify_security = 'Y' THEN 
			F_SET_SECURITY_ROW( THIS , ROW , 'MODIFY' )
		END IF		
	end if 
	gst_return.gvs_return[1]	 = ''
end if 

end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_item_master
end type

type st_1 from so_statictext within w_mat_item_master
integer x = 41
integer y = 104
integer width = 489
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mat_item_master
integer x = 41
integer y = 172
integer width = 489
integer taborder = 20
boolean bringtotop = true
end type

type ddlb_supplier_code from uo_supplier_code within w_mat_item_master
integer x = 535
integer y = 172
integer width = 494
integer taborder = 20
boolean bringtotop = true
end type

type st_2 from so_statictext within w_mat_item_master
integer x = 535
integer y = 104
integer width = 494
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Supplier Code"
end type

type sle_item_name from so_singlelineedit within w_mat_item_master
integer x = 1033
integer y = 172
integer width = 448
integer height = 84
integer taborder = 20
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

dw_1.SETFILTER('')
dw_1.FILTER()

LVS_COLUMN = 'ITEM_NAME'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_1.SETFILTER('')
    dw_1.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

dw_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found" )
end event

type st_14 from so_statictext within w_mat_item_master
integer x = 1033
integer y = 104
integer width = 448
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Item Name"
end type

type sle_1 from so_singlelineedit within w_mat_item_master
integer x = 1490
integer y = 172
integer width = 402
integer height = 84
integer taborder = 30
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

dw_1.SETFILTER('')
dw_1.FILTER()

LVS_COLUMN = 'ITEM_SPEC'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_1.SETFILTER('')
    dw_1.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

dw_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found" )
end event

type st_3 from so_statictext within w_mat_item_master
integer x = 1490
integer y = 104
integer width = 402
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Item Spec"
end type

type tab_1 from tab within w_mat_item_master
integer x = 1984
integer y = 24
integer width = 2281
integer height = 276
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
boolean powertips = true
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
integer x = 18
integer y = 112
integer width = 2245
integer height = 148
long backcolor = 15780518
string text = "Get New Item"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Regenerate5!"
long picturemaskcolor = 536870912
st_10 st_10
cb_1 cb_1
end type

on tabpage_1.create
this.st_10=create st_10
this.cb_1=create cb_1
this.Control[]={this.st_10,&
this.cb_1}
end on

on tabpage_1.destroy
destroy(this.st_10)
destroy(this.cb_1)
end on

type st_10 from statictext within tabpage_1
integer x = 617
integer y = 52
integer width = 343
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 15780518
string text = "From Unit Price"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_1 from so_commandbutton within tabpage_1
integer x = 23
integer y = 16
integer width = 581
integer height = 124
integer taborder = 30
boolean bringtotop = true
string text = "Get New Item"
end type

event clicked;call super::clicked;MSG = F_MSGBOX1( 1161 , THIS.TEXT )
IF MSG = 1 THEN
	
ELSE
	RETURN
END IF
LONG lvl_rows
SETPOINTER(HOURGLASS!)

  INSERT INTO IM_ITEM_MASTER  
         ( ITEM_CODE,   
           SUPPLIER_CODE,   
           DATESET,   
           ORGANIZATION_ID,   
           ORDER_TYPE,   
           ORDER_RATE,   
           ORDER_LEADTIME,   
           ORDER_BAD_RATE,   
           MIM_ORDER_QTY,   
           PACKING_QTY,   
           LONGTERM_DELIVERY_YN,   
           WAREHOUSE_CHARGE,   
           ORDER_CHARGE,   
           DATEEND,   
           MAIN_VENDOR_YN,   
           PAYMENT_TYPE,   
	      INSPECT_RULE ,	  INSPECT_METHOD ,
           ENTER_BY,   
           ENTER_DATE,   
           LAST_MODIFY_BY,   
           LAST_MODIFY_DATE )  
			  
SELECT ITEM_CODE,   
           NVL( SUPPLIER_CODE, '*' ) ,  
           DECODE( MAX(DATESET), NULL , SYSDATE , MAX(DATESET) ) DATESET ,  
           ORGANIZATION_ID,   
           'A' ORDER_TYPE,   
           100 ORDER_RATE,   
           0 ORDER_LEADTIME,   
           0 ORDER_BAD_RATE,   
           0  MIM_ORDER_QTY,   
           0 PACKING_QTY,   
           'N' LONGTERM_DELIVERY_YN,   
           '' WAREHOUSE_CHARGE,   
           '' ORDER_CHARGE,   
           DECODE( MAX(DATEEND), NULL , SYSDATE , MAX(DATEEND) ) DATEEND ,  
           'Y' MAIN_VENDOR_YN,   
           'C'  PAYMENT_TYPE,   
		   'I' , //	  $$HEX6$$80acacc020006dd5a9ba2000$$ENDHEX$$
		   'S', //SAMPLE
           :GVS_USER_ID,   
           SYSDATE,   
           :GVS_USER_ID,   
           SYSDATE 
 FROM IM_ITEM_UNIT_PRICE B
 WHERE  B.LINE_TYPE <> 'T'
      AND B.ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
	 AND B.SUPPLIER_CODE <> '*' 
      AND ( B.ITEM_CODE  , B.SUPPLIER_CODE ) 
 NOT IN ( SELECT A.ITEM_CODE , A.SUPPLIER_CODE 
                 FROM IM_ITEM_MASTER A 
               WHERE A.ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
					
GROUP BY B.ITEM_CODE , B.SUPPLIER_CODE , B.ORGANIZATION_ID 					;
lvl_rows = sqlca.sqlnrows
IF F_SQL_CHECK() < 0 THEN 
	RETURN
END IF

COMMIT ;

MESSAGEBOX("Notify" , string(lvl_rows) +" Found")

F_MSG_ST(170)


end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2245
integer height = 148
long backcolor = 15780518
string text = "Supplier"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Custom046!"
long picturemaskcolor = 536870912
cb_5 cb_5
cb_2 cb_2
st_4 st_4
ddlb_after_supplier ddlb_after_supplier
ddlb_before_supplier ddlb_before_supplier
st_5 st_5
end type

on tabpage_2.create
this.cb_5=create cb_5
this.cb_2=create cb_2
this.st_4=create st_4
this.ddlb_after_supplier=create ddlb_after_supplier
this.ddlb_before_supplier=create ddlb_before_supplier
this.st_5=create st_5
this.Control[]={this.cb_5,&
this.cb_2,&
this.st_4,&
this.ddlb_after_supplier,&
this.ddlb_before_supplier,&
this.st_5}
end on

on tabpage_2.destroy
destroy(this.cb_5)
destroy(this.cb_2)
destroy(this.st_4)
destroy(this.ddlb_after_supplier)
destroy(this.ddlb_before_supplier)
destroy(this.st_5)
end on

type cb_5 from so_commandbutton within tabpage_2
integer x = 1568
integer y = 12
integer width = 667
integer taborder = 30
string text = "Sync Supplier with Price"
end type

event clicked;call super::clicked;update im_item_master a 
      set a.supplier_code = ( select b.supplier_code  
		                                    from im_item_unit_price b 
								    where a.supplier_code = '*' 
									   and b.supplier_code <> '*'									 
									   and a.item_code = b.item_code
									   and a.organization_id = b.organization_id
									   and b.dateset <= trunc(sysdate)
									   and b.dateend >=trunc(sysdate)
									   and a.supplier_code <> b.supplier_code
						                  and a.main_vendor_yn = 'Y'			  										
                                            )				

where a.supplier_code = '*'
   and a.main_vendor_yn = 'Y'			  
   and a.organization_id = :gvi_organization_id
   and ( a.supplier_code , a.item_code , a.organization_id )
      in ( select '*' , b.item_code , b.organization_id 
		    from im_item_unit_price b
           where a.supplier_code = '*' 
			and b.supplier_code <> '*'
			and a.item_code = b.item_code
			and a.organization_id = b.organization_id
			and b.dateset <= trunc(sysdate)
			and b.dateend >=trunc(sysdate)
		     and a.supplier_code <> b.supplier_code			
               and a.main_vendor_yn = 'Y'			  
         )										
;														  

if f_sql_check() < 0 then 
	return
end if


msg = f_msgbox(1170)
if msg = 1 then 
		commit; 
		f_msg_mdi_help(f_msg_st(170))
		f_retrieve()
		
	else
		rollback; 
		f_msg_mdi_help(f_msg_st(9026))

end if 

end event

type cb_2 from so_commandbutton within tabpage_2
string tag = "Select Item First"
integer x = 1056
integer y = 12
integer width = 503
integer taborder = 40
boolean bringtotop = true
string text = "Supplier Change"
end type

event clicked;call super::clicked;STRING  LVS_AFTER_SUPPLIER , LVS_BEFORE_SUPPLIER , LVS_ITEM_CODE , LVS_SUPPLIER_CODE
Long i 
LVS_AFTER_SUPPLIER  = ddlb_after_supplier.text
LVS_BEFORE_SUPPLIER= ddlb_before_supplier.text

if LVS_BEFORE_SUPPLIER  = '' or LVS_BEFORE_SUPPLIER = '%' then
   Return
end if 

if LVS_AFTER_SUPPLIER  = '' or LVS_AFTER_SUPPLIER = '%' then
   Return
end if 

if LVS_AFTER_SUPPLIER =  LVS_BEFORE_SUPPLIER then
   Return
end if 

MSG = F_MSGBOX1( 1161 ,LVS_BEFORE_SUPPLIER+'  => '+ LVS_AFTER_SUPPLIER+'   ' +THIS.TEXT )
IF MSG = 1 THEN 
ELSE
	RETURN
END IF


//==================================================
//
//==================================================
DO
i++

	if dw_1.object.check_yn[i] = 'Y' then
		LVS_ITEM_CODE = dw_1.object.item_code[i]
		LVS_SUPPLIER_CODE = dw_1.object.supplier_code[i]
	else
		continue
	end if
	
	if LVS_SUPPLIER_CODE <> LVS_BEFORE_SUPPLIER then
		continue
	end if 

UPDATE IM_ITEM_MASTER SET SUPPLIER_CODE = :LVS_AFTER_SUPPLIER
  WHERE SUPPLIER_CODE   = :LVS_BEFORE_SUPPLIER
     AND ITEM_CODE             = :LVS_ITEM_CODE
	AND SUPPLIER_CODE     = :LVS_SUPPLIER_CODE
     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	  
IF F_SQL_CHECK() < 0 THEN 
	RETURN
END IF


LOOP UNTIL i = dw_1.rowcount( )


MSG = F_MSGBOX( 1170 )

IF MSG = 1 THEN 
	COMMIT ;
	F_MSG_MDI_HELP( F_MSG_ST( 170) )
	f_retrieve()
ELSE
	ROLLBACK ;
END IF
end event

type st_4 from so_statictext within tabpage_2
integer x = 535
integer width = 512
integer height = 56
boolean bringtotop = true
integer weight = 700
long backcolor = 15780518
string text = "After Supplier"
end type

type ddlb_after_supplier from uo_supplier_code within tabpage_2
integer x = 535
integer y = 60
integer width = 512
integer taborder = 40
boolean bringtotop = true
end type

type ddlb_before_supplier from uo_supplier_code within tabpage_2
integer x = 14
integer y = 60
integer width = 512
integer taborder = 50
boolean bringtotop = true
end type

type st_5 from so_statictext within tabpage_2
integer x = 14
integer width = 549
integer height = 56
boolean bringtotop = true
integer weight = 700
long backcolor = 15780518
string text = "Before Supplier"
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2245
integer height = 148
long backcolor = 15780518
string text = "Transfer"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Synchronizer!"
long picturemaskcolor = 536870912
ddlb_to_org ddlb_to_org
st_9 st_9
st_8 st_8
ddlb_from_org ddlb_from_org
cb_3 cb_3
end type

on tabpage_3.create
this.ddlb_to_org=create ddlb_to_org
this.st_9=create st_9
this.st_8=create st_8
this.ddlb_from_org=create ddlb_from_org
this.cb_3=create cb_3
this.Control[]={this.ddlb_to_org,&
this.st_9,&
this.st_8,&
this.ddlb_from_org,&
this.cb_3}
end on

on tabpage_3.destroy
destroy(this.ddlb_to_org)
destroy(this.st_9)
destroy(this.st_8)
destroy(this.ddlb_from_org)
destroy(this.cb_3)
end on

type ddlb_to_org from uo_orz_id within tabpage_3
integer x = 626
integer y = 60
integer width = 590
integer taborder = 70
boolean bringtotop = true
end type

type st_9 from so_statictext within tabpage_3
integer x = 626
integer y = 4
integer width = 590
integer height = 60
boolean bringtotop = true
integer weight = 700
long backcolor = 15780518
string text = "To"
end type

type st_8 from so_statictext within tabpage_3
integer x = 18
integer width = 603
integer height = 60
boolean bringtotop = true
integer weight = 700
long backcolor = 15780518
string text = "From"
end type

type ddlb_from_org from uo_orz_id within tabpage_3
integer x = 14
integer y = 60
integer width = 603
integer taborder = 60
boolean bringtotop = true
end type

type cb_3 from so_commandbutton within tabpage_3
integer x = 1225
integer y = 28
integer width = 581
integer height = 116
integer taborder = 90
boolean bringtotop = true
string text = "Sync Material"
end type

event clicked;call super::clicked;LONG  i
INT LVI_FROM_ORG , LVI_TO_ORG , lvi_count
STRING LVS_ROWID ,lvs_own_supplier_code ,  lvs_supplier_code , lvs_item_code
LVI_FROM_ORG = INTEGER( DDLB_FROM_ORG.GETCODE( ) )
LVI_TO_ORG = INTEGER( DDLB_TO_ORG.GETCODE( ) )

if dw_1.getrow( ) = 0 then 
	return
end if

msg = f_msgbox1( 1161 , this.text)
if msg = 1 then
else
	return
end if

//============================================
//
//============================================

do
	i++
	if dw_1.object.check_yn[i] = 'Y' then 
		
		lvs_supplier_code= dw_1.object.supplier_code[i]
		lvs_item_code = dw_1.object.item_code[i]
		
	else
		continue
	end if
	
	if isnull(LVS_ROWID) then
		continue
	end if
	
	lvs_own_supplier_code = f_get_supplier_code_oneself(gvi_organization_id)
	
	if isnull(lvs_own_supplier_code) then 
		Messagebox("Notify" , "Own`s Supplier Code Not Found!")
		return
	end if
//============================================
//
//============================================	
	select count(*) into :lvi_count 
	  from icom_supplier
    where supplier_code = :lvs_own_supplier_code
	   and organization_id = 	:LVI_TO_ORG ;
	
	if lvi_count < 1 then 
		Messagebox("Notify" ,lvs_own_supplier_code+ "  Supplier code not found from Organization ID="+string(LVI_TO_ORG))
		return
	end if
//============================================
//
//============================================	
   INSERT INTO "IM_ITEM_MASTER"  
         ( "SUPPLIER_CODE",   
           "ITEM_CODE",   
           "DATESET",   
           "ORGANIZATION_ID",   
           "ORDER_TYPE",   
           "ORDER_RATE",   
           "ORDER_LEADTIME",   
           "ORDER_BAD_RATE",   
           "MIM_ORDER_QTY",   
           "PACKING_QTY",   
           "LONGTERM_DELIVERY_YN",   
           "WAREHOUSE_CHARGE",   
           "ORDER_CHARGE",   
           "DATEEND",   
           "MAIN_VENDOR_YN",   
           "PAYMENT_TYPE",   
           "INSPECT_METHOD",   
           "INSPECT_RULE",   
           "INCIDENTAL_EXPENSE_CODE",   
           "ENTER_BY",   
           "ENTER_DATE",   
           "LAST_MODIFY_BY",   
           "LAST_MODIFY_DATE" )  
     SELECT :lvs_own_supplier_code , //"IM_ITEM_MASTER"."SUPPLIER_CODE",   
            "IM_ITEM_MASTER"."ITEM_CODE",   
            "IM_ITEM_MASTER"."DATESET",   
            :LVI_TO_ORG , //"IM_ITEM_MASTER"."ORGANIZATION_ID",   
            "IM_ITEM_MASTER"."ORDER_TYPE",   
            "IM_ITEM_MASTER"."ORDER_RATE",   
            "IM_ITEM_MASTER"."ORDER_LEADTIME",   
            "IM_ITEM_MASTER"."ORDER_BAD_RATE",   
            "IM_ITEM_MASTER"."MIM_ORDER_QTY",   
            "IM_ITEM_MASTER"."PACKING_QTY",   
            "IM_ITEM_MASTER"."LONGTERM_DELIVERY_YN",   
            "IM_ITEM_MASTER"."WAREHOUSE_CHARGE",   
            "IM_ITEM_MASTER"."ORDER_CHARGE",   
            "IM_ITEM_MASTER"."DATEEND",   
            "IM_ITEM_MASTER"."MAIN_VENDOR_YN",   
            "IM_ITEM_MASTER"."PAYMENT_TYPE",   
            "IM_ITEM_MASTER"."INSPECT_METHOD",   
            "IM_ITEM_MASTER"."INSPECT_RULE",   
            "IM_ITEM_MASTER"."INCIDENTAL_EXPENSE_CODE",   
            :gvs_user_id,   
            sysdate,   
            "IM_ITEM_MASTER"."LAST_MODIFY_BY",   
            "IM_ITEM_MASTER"."LAST_MODIFY_DATE"  
  FROM "IM_ITEM_MASTER" 
   where supplier_code = :lvs_supplier_code
	  and item_code = :lvs_item_code
	  and dateset <= trunc(sysdate)
	  and dateend >= trunc(sysdate)
	 and organization_id = :LVI_FROM_ORG ;

	IF F_SQL_CHECK() < 0 THEN 
		RETURN
	END IF 

loop until i = dw_1.rowcount( )
	  
MSG = F_MSGBOX1( 9014  , String(sqlca.sqlnrows) )
IF MSG = 1 THEN 
	COMMIT ;
ELSE
	ROLLBACK;
END IF


end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2245
integer height = 148
long backcolor = 12632256
string text = "Order Charge"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "UserObject5!"
long picturemaskcolor = 536870912
st_7 st_7
st_6 st_6
cb_4 cb_4
sle_after sle_after
sle_before sle_before
end type

on tabpage_4.create
this.st_7=create st_7
this.st_6=create st_6
this.cb_4=create cb_4
this.sle_after=create sle_after
this.sle_before=create sle_before
this.Control[]={this.st_7,&
this.st_6,&
this.cb_4,&
this.sle_after,&
this.sle_before}
end on

on tabpage_4.destroy
destroy(this.st_7)
destroy(this.st_6)
destroy(this.cb_4)
destroy(this.sle_after)
destroy(this.sle_before)
end on

type st_7 from so_statictext within tabpage_4
integer x = 690
integer y = 4
integer width = 631
integer height = 56
integer weight = 700
string text = "After Order Charge"
end type

type st_6 from so_statictext within tabpage_4
integer y = 12
integer width = 672
integer height = 56
integer weight = 700
string text = "Before Order Charge"
end type

type cb_4 from so_commandbutton within tabpage_4
integer x = 1385
integer y = 16
integer width = 439
integer height = 120
integer taborder = 50
string text = "Change"
end type

event clicked;call super::clicked;string lvs_before_order_charge , lvs_item_code , lvs_supplier_code

lvs_before_order_charge = sle_before.text

if lvs_before_order_charge = '' or isnull(lvs_before_order_charge) then 
	Messagebox("Notify" , "Supplier Code Invalid")
	return
end if
//============================================
//
//============================================
long i
do
	i++
	
	if dw_1.object.check_yn[i] = 'Y' then 
		
		lvs_item_code      = dw_1.object.item_code[i] 
		lvs_supplier_code = dw_1.object.supplier_code[i] 
		
		update im_item_master set order_charge = :gvs_user_id 
		where item_code = :lvs_item_code
		    and supplier_code = :lvs_supplier_code
		    and order_charge = :lvs_before_order_charge 
		    and organization_id = :Gvi_organization_id ;
		
		if f_sql_check() < 0 then 
			return
		end if
	else
		continue 
	end if
	
loop until i = dw_1.rowcount()

//============================================
//
//============================================


msg = f_msgbox1( 9014 , string(sqlca.sqlnrows))
if msg = 1 then 
	commit ;
else
	rollback;
end if 
end event

type sle_after from so_singlelineedit within tabpage_4
integer x = 690
integer y = 68
integer width = 631
integer taborder = 60
boolean enabled = false
end type

event constructor;call super::constructor;this.text = Gvs_user_id +' : '+Gvs_user_name
end event

type sle_before from so_singlelineedit within tabpage_4
integer y = 68
integer width = 672
integer taborder = 50
integer weight = 700
end type

type gb_2 from so_groupbox within w_mat_item_master
integer y = 4
integer width = 1970
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

