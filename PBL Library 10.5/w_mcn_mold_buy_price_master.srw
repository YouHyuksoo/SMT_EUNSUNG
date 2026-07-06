HA$PBExportHeader$w_mcn_mold_buy_price_master.srw
$PBExportComments$Customer Infromation Manage
forward
global type w_mcn_mold_buy_price_master from w_main_root
end type
type ddlb_supplier_code from uo_supplier_code within w_mcn_mold_buy_price_master
end type
type st_3 from so_statictext within w_mcn_mold_buy_price_master
end type
type gb_1 from so_groupbox within w_mcn_mold_buy_price_master
end type
type st_14 from so_statictext within w_mcn_mold_buy_price_master
end type
type sle_item_name from so_singlelineedit within w_mcn_mold_buy_price_master
end type
type sle_1 from so_singlelineedit within w_mcn_mold_buy_price_master
end type
type st_4 from so_statictext within w_mcn_mold_buy_price_master
end type
type sle_mold_code from so_singlelineedit within w_mcn_mold_buy_price_master
end type
type st_1 from so_statictext within w_mcn_mold_buy_price_master
end type
type tab_1 from tab within w_mcn_mold_buy_price_master
end type
type tabpage_1 from userobject within tab_1
end type
type cb_close from so_commandbutton within tabpage_1
end type
type cb_copy from so_commandbutton within tabpage_1
end type
type st_2 from so_statictext within tabpage_1
end type
type uo_close_date from uo_ymd_calendar within tabpage_1
end type
type tabpage_1 from userobject within tab_1
cb_close cb_close
cb_copy cb_copy
st_2 st_2
uo_close_date uo_close_date
end type
type tabpage_2 from userobject within tab_1
end type
type cb_1 from so_commandbutton within tabpage_2
end type
type tabpage_2 from userobject within tab_1
cb_1 cb_1
end type
type tabpage_3 from userobject within tab_1
end type
type st_5 from so_statictext within tabpage_3
end type
type st_6 from so_statictext within tabpage_3
end type
type ddlb_before_supplier from uo_supplier_code within tabpage_3
end type
type ddlb_after_supplier from uo_supplier_code within tabpage_3
end type
type cb_2 from so_commandbutton within tabpage_3
end type
type tabpage_3 from userobject within tab_1
st_5 st_5
st_6 st_6
ddlb_before_supplier ddlb_before_supplier
ddlb_after_supplier ddlb_after_supplier
cb_2 cb_2
end type
type tab_1 from tab within w_mcn_mold_buy_price_master
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
end forward

global type w_mcn_mold_buy_price_master from w_main_root
integer width = 4384
integer height = 2656
string title = "Mold Unit Price Master"
ddlb_supplier_code ddlb_supplier_code
st_3 st_3
gb_1 gb_1
st_14 st_14
sle_item_name sle_item_name
sle_1 sle_1
st_4 st_4
sle_mold_code sle_mold_code
st_1 st_1
tab_1 tab_1
end type
global w_mcn_mold_buy_price_master w_mcn_mold_buy_price_master

on w_mcn_mold_buy_price_master.create
int iCurrent
call super::create
this.ddlb_supplier_code=create ddlb_supplier_code
this.st_3=create st_3
this.gb_1=create gb_1
this.st_14=create st_14
this.sle_item_name=create sle_item_name
this.sle_1=create sle_1
this.st_4=create st_4
this.sle_mold_code=create sle_mold_code
this.st_1=create st_1
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_supplier_code
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.st_14
this.Control[iCurrent+5]=this.sle_item_name
this.Control[iCurrent+6]=this.sle_1
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.sle_mold_code
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.tab_1
end on

on w_mcn_mold_buy_price_master.destroy
call super::destroy
destroy(this.ddlb_supplier_code)
destroy(this.st_3)
destroy(this.gb_1)
destroy(this.st_14)
destroy(this.sle_item_name)
destroy(this.sle_1)
destroy(this.st_4)
destroy(this.sle_mold_code)
destroy(this.st_1)
destroy(this.tab_1)
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
			
			dw_1.retrieve(sle_mold_code.text + '%', ddlb_supplier_code.text + '%', gvi_organization_id)
		
	case 'INSERT'
		
			DW_2.ENABLED = TRUE
			ROW = DW_2.INSERTROW(DW_2.GETROW())
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')
			dw_2.object.dateset[row] = f_t_sysdate()
			dw_2.object.dateend[row] = date('2999-12-31')
			dw_2.object.price_type[row] = 'F'
			dw_2.object.price_change_reason[row] = 'N'						
			dw_2.object.price_change_confirm_yn[row] = 'N'						
			dw_2.object.delivery[row] = '2'
			dw_2.object.currency[row] = Gvs_currency
			dw_2.object.line_type[row] = 'G'						
			
	case 'APPEND'		
			DW_2.ENABLED = TRUE
			ROW = DW_2.INSERTROW(DW_2.GETROW())
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')
			dw_2.object.dateset[row] = f_t_sysdate()
			dw_2.object.dateend[row] = date('2999-12-31')
			dw_2.object.price_type[row] = 'F'
			dw_2.object.price_change_reason[row] = 'N'			
			dw_2.object.price_change_confirm_yn[row] = 'N'		
			dw_2.object.delivery[row] = '2'
			dw_2.object.currency[row] = Gvs_currency			
			dw_2.object.line_type[row] = 'G'			
			
	case 'DELETE'
		
		  	if DW_2.AcceptText() = -1 then
				return
			end if
			
			if dw_2.object.price_change_confirm_yn[dw_2.getrow()] = 'Y' then 
				
				//Mes sagebox("Notify" , "Price aready confirmed")
				f_msg("Price aready confirmed",'P') 
				return
			end if 
			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
                      DW_2.deleterow( dw_2.getrow())
			END IF
			
	case 'UPDATE'
		
			IF DW_2.UPDATE() < 0  THEN
			  	 ROLLBACK;
			        RETURN
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
	                F_RETRIEVE()
			END IF

	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mcn_mold_buy_price_master
integer y = 316
end type

type dw_4 from w_main_root`dw_4 within w_mcn_mold_buy_price_master
integer y = 316
end type

type dw_3 from w_main_root`dw_3 within w_mcn_mold_buy_price_master
integer y = 336
end type

type dw_2 from w_main_root`dw_2 within w_mcn_mold_buy_price_master
integer y = 1952
integer width = 4334
integer height = 544
string dataobject = "d_mcn_mold_buy_price_mst"
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_2::itemchanged;call super::itemchanged;string lvs_return

if dwo.name = 'supplier_code' then 
	lvs_return = f_get_supplier_name(data , gvi_organization_id)
	if lvs_return = 'ERROR' then 
		return 1 
	end if  
	if lvs_return = 'NOTFOUND' then 
		return 1 
	end if
	
	this.object.supplier_name[row] = lvs_return 
end if 

if dwo.name = 'mold_code' then 
	
		IF F_CHECK_MOLD_EXISTS( DATA) < 1 then 
			F_MSGBOX(9041) //$$HEX16$$80bd88d4c8b9a4c230d12000f8bbf1b45db8200080bd88d4200085c7c8b2e4b2$$ENDHEX$$
			THIS.OBJECT.MOLD_CODE[ROW] = ''
			THIS.SETCOLUMN('mold_code')
			RETURN 1
		END IF		
	
	THIS.OBJECT.CURRENCY[ROW]   = ''
	THIS.OBJECT.UNIT_PRICE[ROW] = 0 
		
end if
end event

event dw_2::rbuttondown;call super::rbuttondown;if dwo.name = 'supplier_code' then 	
	open(w_com_mold_supplier_popup)	
	if  gst_return.gvb_return  = true then
	   this.object.supplier_code[row] = message.stringparm
	   gst_return.gvs_return[1]  = ''		
	end if
end if

if dwo.name = 'mold_code' then 
	open(w_mcn_mold_popup)	
	if  gst_return.gvb_return  = true then
	   this.object.mold_code[row] = message.stringparm
	   this.object.supplier_code[row]=	Gst_return.gvs_return[3]
	end if	
	
end if
end event

type dw_1 from w_main_root`dw_1 within w_mcn_mold_buy_price_master
integer y = 308
integer width = 4329
integer height = 1640
boolean titlebar = true
string title = "Mold Buy Price List"
string dataobject = "d_mcn_mold_buy_price_lst_tree"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;IF CURRENTROW = 0 THEN RETURN
DW_2.RETRIEVE( DW_1.GETITEMSTRING( CURRENTROW , 'ROWID' ) )

if dw_1.object.price_change_confirm_yn[currentrow] = 'Y' then
	DW_2.enabled = False
end if 
end event

event dw_1::doubleclicked;call super::doubleclicked;IF ROW < 1  THEN RETURN
DW_2.RETRIEVE( DW_1.GETITEMSTRING( ROW , 'ROWID' ) )
if dw_1.object.price_change_confirm_yn[row] = 'Y' then
	DW_2.enabled = False
end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mcn_mold_buy_price_master
end type

type ddlb_supplier_code from uo_supplier_code within w_mcn_mold_buy_price_master
integer x = 526
integer y = 176
integer width = 480
integer taborder = 20
boolean bringtotop = true
end type

type st_3 from so_statictext within w_mcn_mold_buy_price_master
integer x = 526
integer y = 96
integer width = 480
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Supplier Code"
end type

type gb_1 from so_groupbox within w_mcn_mold_buy_price_master
integer y = 4
integer width = 1957
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type st_14 from so_statictext within w_mcn_mold_buy_price_master
integer x = 1010
integer y = 96
integer width = 453
integer height = 68
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Mold Name"
end type

type sle_item_name from so_singlelineedit within w_mcn_mold_buy_price_master
integer x = 1010
integer y = 176
integer width = 453
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

SELECTED_DATA_WINDOW.SETFILTER('')
SELECTED_DATA_WINDOW.FILTER()

LVS_COLUMN = 'MOLD_NAME'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    SELECTED_DATA_WINDOW.SETFILTER('')
    SELECTED_DATA_WINDOW.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
SELECTED_DATA_WINDOW.FILTER()
F_MSG_MDI_HELP( STRING( SELECTED_DATA_WINDOW.ROWCOUNT() ) + " Found" )
end event

type sle_1 from so_singlelineedit within w_mcn_mold_buy_price_master
integer x = 1472
integer y = 176
integer width = 453
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

SELECTED_DATA_WINDOW.SETFILTER('')
SELECTED_DATA_WINDOW.FILTER()

LVS_COLUMN = 'MOLD_SPEC'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    SELECTED_DATA_WINDOW.SETFILTER('')
    SELECTED_DATA_WINDOW.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
SELECTED_DATA_WINDOW.FILTER()
F_MSG_MDI_HELP( STRING( SELECTED_DATA_WINDOW.ROWCOUNT() ) + " Found" )
end event

type st_4 from so_statictext within w_mcn_mold_buy_price_master
integer x = 1472
integer y = 96
integer width = 453
integer height = 68
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Mold Spec"
end type

type sle_mold_code from so_singlelineedit within w_mcn_mold_buy_price_master
integer x = 23
integer y = 176
integer height = 84
integer taborder = 50
boolean bringtotop = true
end type

type st_1 from so_statictext within w_mcn_mold_buy_price_master
integer x = 23
integer y = 96
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Mold Code"
end type

type tab_1 from tab within w_mcn_mold_buy_price_master
integer x = 2007
integer y = 8
integer width = 1961
integer height = 292
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
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 1925
integer height = 164
long backcolor = 15780518
string text = "Price Close"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Close!"
long picturemaskcolor = 536870912
cb_close cb_close
cb_copy cb_copy
st_2 st_2
uo_close_date uo_close_date
end type

on tabpage_1.create
this.cb_close=create cb_close
this.cb_copy=create cb_copy
this.st_2=create st_2
this.uo_close_date=create uo_close_date
this.Control[]={this.cb_close,&
this.cb_copy,&
this.st_2,&
this.uo_close_date}
end on

on tabpage_1.destroy
destroy(this.cb_close)
destroy(this.cb_copy)
destroy(this.st_2)
destroy(this.uo_close_date)
end on

type cb_close from so_commandbutton within tabpage_1
integer x = 855
integer y = 36
integer width = 379
integer height = 100
integer taborder = 40
boolean bringtotop = true
string text = "Price Close"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 
if dw_2.rowcount() < 1  then return 
datetime lvdt_close_date ,  lvdt_dateset,  lvdt_dateend 
lvdt_close_date = uo_close_date.text()
lvdt_dateset = dw_2.object.dateset[1]
lvdt_dateend = dw_2.object.dateend[1]
if lvdt_close_date > lvdt_dateset   and  lvdt_close_date < lvdt_dateend   then 
	dw_2.object.dateend[1] = lvdt_close_date
else
	//mes sagebox('Notify','The close date is invalid!')
	f_msg('The close date is invalid!','P')
	return 
end if 

end event

type cb_copy from so_commandbutton within tabpage_1
integer x = 1243
integer y = 36
integer width = 379
integer height = 100
integer taborder = 40
boolean bringtotop = true
string text = "Price Copy"
end type

event clicked;call super::clicked;Datetime lvdt_null
setnull(lvdt_null)
if f_object_role_check() = false then return 
if dw_2.rowcount() < 1 then return 
dw_2.rowscopy(1, 1, Primary!, dw_2, 1, Primary!)
dw_2.object.dateset[1] = f_t_sysdate()
dw_2.object.dateend[1] = date('2999-12-31')
dw_2.object.unit_price[1] = 0 

dw_2.object.price_change_confirm_yn[1] = 'N'
dw_2.object.confirm_date[1] = lvdt_null
end event

type st_2 from so_statictext within tabpage_1
integer x = 9
integer y = 60
integer width = 407
integer height = 60
boolean bringtotop = true
integer weight = 700
long backcolor = 15780518
string text = "Close Date"
end type

type uo_close_date from uo_ymd_calendar within tabpage_1
integer x = 425
integer y = 48
integer taborder = 40
boolean bringtotop = true
end type

on uo_close_date.destroy
call uo_ymd_calendar::destroy
end on

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 1925
integer height = 164
long backcolor = 12632256
string text = "Get New Item"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "New!"
long picturemaskcolor = 536870912
cb_1 cb_1
end type

on tabpage_2.create
this.cb_1=create cb_1
this.Control[]={this.cb_1}
end on

on tabpage_2.destroy
destroy(this.cb_1)
end on

type cb_1 from so_commandbutton within tabpage_2
integer x = 27
integer y = 40
integer height = 96
integer taborder = 40
string text = "Get New Item"
end type

event clicked;call super::clicked;STRING LVS_MOLD_CODE  ,LVS_SUPPLIER_CODE
LONG  I , LVI_COUNT


DECLARE CL1 CURSOR FOR
SELECT MOLD_CODE,   SUPPLIER_CODE  FROM IMCN_MOLD
WHERE (  MOLD_CODE , SUPPLIER_CODE , ORGANIZATION_ID ) 
  NOT IN ( SELECT SUPPLIER_CODE , MOLD_CODE , ORGANIZATION_ID
                  FROM IMCN_MOLD_UNIT_PRICE
                WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID ) 
    AND ORGANIZATION_ID =  :GVI_ORGANIZATION_ID	;		   
	
SELECT count(*) into :lvi_count
FROM IMCN_MOLD
WHERE (  MOLD_CODE , SUPPLIER_CODE , ORGANIZATION_ID ) 
  NOT IN ( SELECT SUPPLIER_CODE , MOLD_CODE , ORGANIZATION_ID
                  FROM IMCN_MOLD_UNIT_PRICE
                WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID ) 
    AND ORGANIZATION_ID =  :GVI_ORGANIZATION_ID	;	
	
	IF F_SQL_CHECK() < 0 THEN 
		RETURN
	END IF 
	
OPEN CL1 ;

DO
	FETCH CL1 INTO :LVS_MOLD_CODE  , :LVS_SUPPLIER_CODE ;
	
	IF F_SQL_CHECK() <  0 THEN 
		CLOSE CL1 ;
		RETURN
	END IF
	
	
	IF SQLCA.SQLCODE = 100 THEN 
		CLOSE CL1 ;
		EXIT
	END IF
	
	I++


  INSERT INTO IMCN_MOLD_UNIT_PRICE  
         ( DATESET,   
           MOLD_CODE,   
           SUPPLIER_CODE,   
           LINE_TYPE,   
           ORGANIZATION_ID,   
           DELIVERY,   
           CURRENCY,   
           UNIT_PRICE,   
           TAX_RATE,   
           PRICE_TYPE,   
           APPROVAL_NO,   
           STANDARD_UNIT_PRICE,   
           DATEEND,   
           PRICE_CHANGE_REASON,   
           CONFIRM_BY,   
           PRICE_CHANGE_CONFIRM_YN,   
           CONFIRM_DATE,   
           ENTER_DATE,   
           ENTER_BY,   
           LAST_MODIFY_DATE,   
           LAST_MODIFY_BY )  
VALUES (   TRUNC(SYSDATE) ,
           :LVS_MOLD_CODE   ,
           :LVS_SUPPLIER_CODE,   
           'G' , //LINE_TYPE,   
           :GVI_ORGANIZATION_ID,   
           2 , //DELIVERY,   
           :GVS_CURRENCY , //CURRENCY,   
           0 , //UNIT_PRICE,   
           0 , //TAX_RATE,   
           'T' , //PRICE_TYPE,   
           NULL , //APPROVAL_NO,   
           0 , //STANDARD_UNIT_PRICE,   
           TO_DATE('99991231' , 'YYYYMMDD') ,   //DATEEND
           'N' , //PRICE_CHANGE_REASON,   
           NULL , //CONFIRM_BY,   
           'N' , //PRICE_CHANGE_CONFIRM_YN,   
           NULL , //CONFIRM_DATE,   
           SYSDATE  , 
           :GVS_USER_ID ,
           SYSDATE , 
           :GVS_USER_ID  ) ;

	IF F_SQL_CHECK() < 0 THEN 
		CLOSE CL1 ;
		RETURN
	END IF 

LOOP UNTIL I = LVI_COUNT 
	
//===========================================
//
//===========================================

MSG = F_MSGBOX1(9014 , STRING(I))
IF MSG = 1 THEN 
	COMMIT ;
ELSE
	ROLLBACK;
END IF


				
				
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 1925
integer height = 164
long backcolor = 12632256
string text = "Supplier Change"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Custom046!"
long picturemaskcolor = 536870912
st_5 st_5
st_6 st_6
ddlb_before_supplier ddlb_before_supplier
ddlb_after_supplier ddlb_after_supplier
cb_2 cb_2
end type

on tabpage_3.create
this.st_5=create st_5
this.st_6=create st_6
this.ddlb_before_supplier=create ddlb_before_supplier
this.ddlb_after_supplier=create ddlb_after_supplier
this.cb_2=create cb_2
this.Control[]={this.st_5,&
this.st_6,&
this.ddlb_before_supplier,&
this.ddlb_after_supplier,&
this.cb_2}
end on

on tabpage_3.destroy
destroy(this.st_5)
destroy(this.st_6)
destroy(this.ddlb_before_supplier)
destroy(this.ddlb_after_supplier)
destroy(this.cb_2)
end on

type st_5 from so_statictext within tabpage_3
integer x = 489
integer y = 4
integer width = 489
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "After Supplier"
end type

type st_6 from so_statictext within tabpage_3
integer y = 4
integer width = 475
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Before Supplier"
end type

type ddlb_before_supplier from uo_supplier_code within tabpage_3
integer y = 76
integer width = 489
integer taborder = 20
boolean bringtotop = true
end type

type ddlb_after_supplier from uo_supplier_code within tabpage_3
integer x = 489
integer y = 76
integer width = 489
integer taborder = 20
boolean bringtotop = true
end type

type cb_2 from so_commandbutton within tabpage_3
integer x = 983
integer y = 60
integer width = 462
integer height = 108
integer taborder = 50
boolean bringtotop = true
string text = "Supplier Change"
end type

event clicked;call super::clicked;STRING  LVS_AFTER_SUPPLIER , LVS_BEFORE_SUPPLIER

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

UPDATE IMCN_MOLD_UNIT_PRICE SET SUPPLIER_CODE = :LVS_AFTER_SUPPLIER
  WHERE SUPPLIER_CODE   = :LVS_BEFORE_SUPPLIER
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

