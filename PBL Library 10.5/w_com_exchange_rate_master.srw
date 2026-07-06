HA$PBExportHeader$w_com_exchange_rate_master.srw
$PBExportComments$Exchange Rate Master Window
forward
global type w_com_exchange_rate_master from w_main_root
end type
type ddlb_basis_currency from uo_currency_code within w_com_exchange_rate_master
end type
type st_currency from so_statictext within w_com_exchange_rate_master
end type
type st_date from so_statictext within w_com_exchange_rate_master
end type
type em_date_start from uo_ymd_calendar within w_com_exchange_rate_master
end type
type em_date_end from uo_ymd_calendar within w_com_exchange_rate_master
end type
type cb_1 from commandbutton within w_com_exchange_rate_master
end type
type em_rate from editmask within w_com_exchange_rate_master
end type
type st_4 from statictext within w_com_exchange_rate_master
end type
type st_1 from so_statictext within w_com_exchange_rate_master
end type
type ddlb_currency from uo_currency_code within w_com_exchange_rate_master
end type
type em_buying_rate from editmask within w_com_exchange_rate_master
end type
type st_2 from statictext within w_com_exchange_rate_master
end type
type em_selling_rate from editmask within w_com_exchange_rate_master
end type
type st_3 from statictext within w_com_exchange_rate_master
end type
type gb_1 from so_groupbox within w_com_exchange_rate_master
end type
type gb_2 from groupbox within w_com_exchange_rate_master
end type
end forward

global type w_com_exchange_rate_master from w_main_root
integer width = 4571
integer height = 2748
string title = "Exchange Rate Master"
ddlb_basis_currency ddlb_basis_currency
st_currency st_currency
st_date st_date
em_date_start em_date_start
em_date_end em_date_end
cb_1 cb_1
em_rate em_rate
st_4 st_4
st_1 st_1
ddlb_currency ddlb_currency
em_buying_rate em_buying_rate
st_2 st_2
em_selling_rate em_selling_rate
st_3 st_3
gb_1 gb_1
gb_2 gb_2
end type
global w_com_exchange_rate_master w_com_exchange_rate_master

on w_com_exchange_rate_master.create
int iCurrent
call super::create
this.ddlb_basis_currency=create ddlb_basis_currency
this.st_currency=create st_currency
this.st_date=create st_date
this.em_date_start=create em_date_start
this.em_date_end=create em_date_end
this.cb_1=create cb_1
this.em_rate=create em_rate
this.st_4=create st_4
this.st_1=create st_1
this.ddlb_currency=create ddlb_currency
this.em_buying_rate=create em_buying_rate
this.st_2=create st_2
this.em_selling_rate=create em_selling_rate
this.st_3=create st_3
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_basis_currency
this.Control[iCurrent+2]=this.st_currency
this.Control[iCurrent+3]=this.st_date
this.Control[iCurrent+4]=this.em_date_start
this.Control[iCurrent+5]=this.em_date_end
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.em_rate
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.ddlb_currency
this.Control[iCurrent+11]=this.em_buying_rate
this.Control[iCurrent+12]=this.st_2
this.Control[iCurrent+13]=this.em_selling_rate
this.Control[iCurrent+14]=this.st_3
this.Control[iCurrent+15]=this.gb_1
this.Control[iCurrent+16]=this.gb_2
end on

on w_com_exchange_rate_master.destroy
call super::destroy
destroy(this.ddlb_basis_currency)
destroy(this.st_currency)
destroy(this.st_date)
destroy(this.em_date_start)
destroy(this.em_date_end)
destroy(this.cb_1)
destroy(this.em_rate)
destroy(this.st_4)
destroy(this.st_1)
destroy(this.ddlb_currency)
destroy(this.em_buying_rate)
destroy(this.st_2)
destroy(this.em_selling_rate)
destroy(this.st_3)
destroy(this.gb_1)
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
*  Menu Property
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

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

event ue_data_control;call super::ue_data_control;long row
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
			dw_1.retrieve( em_date_start.text(), em_date_end.text(), ddlb_currency.text() + '%')
			dw_1.setfocus()
			
	case 'INSERT'
		
			row = dw_1.insertrow(dw_1.getrow())
			dw_1.scrolltorow(row)
			f_set_security_row(dw_1 , row , 'NONORG')
			f_msg_mdi_help(f_msg_st(152))
			
	case 'APPEND'
		
			row = dw_1.insertrow(0)
			dw_1.scrolltorow(row)
			f_set_security_row(dw_1 , row , 'NONORG')	
			f_msg_mdi_help(f_msg_st(152))		
			
	case 'DELETE'
		
		  	if dw_1.getrow() < 1 then return 
			  
			msg =f_msgbox(1003)
			if msg = 1 then
				gvl_row_deleted = dw_1.getrow()			
				dw_1.deleterow(gvl_row_deleted)		
				dw_1.setfocus()
				row = dw_1.getrow()
				dw_1.scrolltorow(row)
				dw_1.setcolumn(1)
			end if
			
	case 'UPDATE'
		
			if dw_1.update() < 0 then
				rollback;
			else
				commit;
				f_msg_mdi_help(f_msg_st(170))
			end if
			
	case else
end choose


end event

type dw_5 from w_main_root`dw_5 within w_com_exchange_rate_master
integer y = 316
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_com_exchange_rate_master
integer y = 316
integer taborder = 0
end type

type dw_3 from w_main_root`dw_3 within w_com_exchange_rate_master
integer y = 316
integer width = 4544
integer height = 1388
integer taborder = 90
end type

type dw_2 from w_main_root`dw_2 within w_com_exchange_rate_master
integer y = 316
integer width = 4549
integer height = 828
integer taborder = 0
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_com_exchange_rate_master
integer y = 316
integer width = 4544
integer height = 2332
integer taborder = 0
boolean titlebar = true
string title = "Exchange Rate List"
string dataobject = "d_com_exchange_rate_lst"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_com_exchange_rate_master
integer taborder = 0
end type

type ddlb_basis_currency from uo_currency_code within w_com_exchange_rate_master
integer x = 846
integer y = 156
integer width = 503
integer taborder = 30
boolean bringtotop = true
end type

type st_currency from so_statictext within w_com_exchange_rate_master
integer x = 846
integer y = 76
integer width = 507
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Basis Currency"
end type

type st_date from so_statictext within w_com_exchange_rate_master
integer x = 32
integer y = 76
integer width = 809
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Exchange Date"
end type

type em_date_start from uo_ymd_calendar within w_com_exchange_rate_master
event destroy ( )
integer x = 23
integer y = 156
integer width = 398
integer taborder = 10
boolean bringtotop = true
string pointer = ""
end type

on em_date_start.destroy
call uo_ymd_calendar::destroy
end on

type em_date_end from uo_ymd_calendar within w_com_exchange_rate_master
event destroy ( )
integer x = 430
integer y = 156
integer width = 398
integer taborder = 20
boolean bringtotop = true
string pointer = ""
end type

on em_date_end.destroy
call uo_ymd_calendar::destroy
end on

type cb_1 from commandbutton within w_com_exchange_rate_master
integer x = 3319
integer y = 148
integer width = 411
integer height = 104
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Generate All"
end type

event clicked;IF F_OBJECT_ROLE_CHECK() = FALSE THEN  RETURN
DATETIME LVD_DATESET_CONDITION ,LVD_DATEEND_CONDITION ,  LVD_DATESET 
INT      I 
STRING LVS_CURRENCY , LVS_BASIS_CURRENCY
LONG LVL_COUNT
DECIMAL LVF_RATE , LVF_SELLING_RATE , LVF_BUYING_RATE
LVD_DATESET_CONDITION  = EM_DATE_START.TEXT()
LVD_DATEEND_CONDITION  = EM_DATE_END.TEXT()

LVS_CURRENCY              = DDLB_CURRENCY.TEXT 
LVS_BASIS_CURRENCY  = DDLB_BASIS_CURRENCY.TEXT 

LVF_RATE   = DEC( EM_RATE.TEXT )
LVF_BUYING_RATE   = DEC( EM_BUYING_RATE.TEXT )
LVF_SELLING_RATE   = DEC( EM_SELLING_RATE.TEXT )

IF EM_DATE_START.TEXT   >  EM_DATE_END.TEXT THEN 
	F_MSGBOX(105) //$$HEX19$$dcc291c77cc740c7200085c8ccb87cc72000f4bce4b2200091c744c57cc5200069d5c8b2e4b2$$ENDHEX$$
	RETURN
END IF
  
  I = 0 
  open(w_progress_popup)
  w_progress_popup.f_set_range( 0 ,  DaysAfter ( DATE(LVD_DATESET_CONDITION), DATE(LVD_DATEEND_CONDITION) ) )
  w_progress_popup.f_setstep(1)
  
  DO 
  
  SELECT :LVD_DATESET_CONDITION + :I 
     INTO :LVD_DATESET 
	 FROM DUAL ;
	 
  IF F_SQL_CHECK() < 0 THEN 
	  RETURN
  END IF 
 
	SELECT 	COUNT(*) INTO :LVL_COUNT
	  FROM ICOM_EXCHANGE_RATE
	WHERE DATESET = :LVD_DATESET
	    AND CURRENCY = :LVS_CURRENCY 
	    AND BASIS_CURRENCY = :LVS_BASIS_CURRENCY;
		
     IF F_SQL_CHECK() < 0 THEN 
	     RETURN
     END IF 
  
     IF LVL_COUNT > 0 THEN 
		DELETE FROM ICOM_EXCHANGE_RATE
		WHERE DATESET = :LVD_DATESET
	   	 AND CURRENCY = :LVS_CURRENCY
	     AND BASIS_CURRENCY = :LVS_BASIS_CURRENCY;			 
		  
		  IF F_SQL_CHECK() < 0 THEN 	  RETURN 

	END IF
		
		INSERT INTO "ICOM_EXCHANGE_RATE"  
			( "DATESET",   
			"CURRENCY",   
			"EXCHANGE_RATE",   
			"SELLING_RATE",   
			"BUYING_RATE",   
			"BASIS_CURRENCY",
			"ENTER_BY",   
			"ENTER_DATE",   
			"LAST_MODIFY_BY",   
			"LAST_MODIFY_DATE" )  
		VALUES ( :LVD_DATESET,   
			:LVS_CURRENCY,   
			:LVF_RATE,   
			:LVF_SELLING_RATE,   
			:LVF_BUYING_RATE,   
			:LVS_BASIS_CURRENCY,
			:GVS_USER_ID,   
			SYSDATE,   
			:GVS_USER_ID,   
			SYSDATE )  ;

  IF F_SQL_CHECK() < 0 THEN 
	  RETURN
  END IF 
  			  

	I++		  
	w_progress_popup.f_STEPIT()		  
	F_MSG_MDI_HELP(  STRING(I)+" 	Rows Processed")
	w_progress_popup.F_SET_MESSAGE(STRING(I)+" 	Rows Processed")
	
LOOP UNTIL LVD_DATESET = LVD_DATEEND_CONDITION
Close(w_progress_popup)
COMMIT ;
F_MSGBOX(170)
end event

type em_rate from editmask within w_com_exchange_rate_master
integer x = 1989
integer y = 152
integer width = 434
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#,##0.0000"
end type

type st_4 from statictext within w_com_exchange_rate_master
integer x = 1989
integer y = 76
integer width = 434
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Exchange Rate"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from so_statictext within w_com_exchange_rate_master
integer x = 1449
integer y = 76
integer width = 535
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Local Currency"
end type

type ddlb_currency from uo_currency_code within w_com_exchange_rate_master
integer x = 1449
integer y = 156
integer width = 535
integer taborder = 40
boolean bringtotop = true
end type

type em_buying_rate from editmask within w_com_exchange_rate_master
integer x = 2432
integer y = 152
integer width = 434
integer height = 92
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#,##0.0000"
end type

type st_2 from statictext within w_com_exchange_rate_master
integer x = 2432
integer y = 76
integer width = 434
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Buying Rate"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_selling_rate from editmask within w_com_exchange_rate_master
integer x = 2875
integer y = 152
integer width = 434
integer height = 92
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#,##0.0000"
end type

type st_3 from statictext within w_com_exchange_rate_master
integer x = 2889
integer y = 76
integer width = 434
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Selling Rate"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from so_groupbox within w_com_exchange_rate_master
integer width = 1394
integer height = 304
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from groupbox within w_com_exchange_rate_master
integer x = 1413
integer y = 8
integer width = 2354
integer height = 304
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Process"
end type

