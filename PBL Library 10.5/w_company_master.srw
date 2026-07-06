HA$PBExportHeader$w_company_master.srw
$PBExportComments$Company Infromation Manage
forward
global type w_company_master from w_main_root
end type
type st_1 from so_statictext within w_company_master
end type
type ddlb_1 from uo_company_code within w_company_master
end type
type gb_1 from groupbox within w_company_master
end type
end forward

global type w_company_master from w_main_root
integer y = 256
string title = "Company"
st_1 st_1
ddlb_1 ddlb_1
gb_1 gb_1
end type
global w_company_master w_company_master

on w_company_master.create
int iCurrent
call super::create
this.st_1=create st_1
this.ddlb_1=create ddlb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.ddlb_1
this.Control[iCurrent+3]=this.gb_1
end on

on w_company_master.destroy
call super::destroy
destroy(this.st_1)
destroy(this.ddlb_1)
destroy(this.gb_1)
end on

event activate;call super::activate;/***************************************
* $$HEX17$$08c7c4b324c115c8d0c5200000ad5cd52000acc06dd544c720004bc105d35cd5e4b2$$ENDHEX$$
*
*
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20051101'
Gst_set.last_modify_date = '20051101'
Gst_set.Report_window    = False  // Report Window  True / Flase

/*****************************************
* Data WIndow Property
******************************************/
Ivs_resize_type    = 'MASTER_DETAIL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

/****************************************
* Menu Property $$HEX6$$54ba74b2200078d5e4b4c1b9$$ENDHEX$$
*****************************************
* ADMIN     : ADMIN  ( $$HEX5$$04c8b4ccacc0a9c62000$$ENDHEX$$)
* $$HEX8$$00adacb9200020002000200020002000$$ENDHEX$$: MANAGE ( $$HEX8$$04c854ba74b2acc0a9c600aca5b22000$$ENDHEX$$)
* $$HEX7$$acc0a9c690c72000200020002000$$ENDHEX$$: GUEST  ( $$HEX11$$30ae08cd2000f1b45db8200070c88cd6200000aca5b2$$ENDHEX$$)
* $$HEX8$$70c88cd6200020002000200020002000$$ENDHEX$$: QUERY  ( $$HEX10$$15c8f4bc70c88cd6ccb9200000aca5b220002000$$ENDHEX$$)
* $$HEX5$$70b374c7c0d070c891c7$$ENDHEX$$: DATA_CONTROL  ( $$HEX12$$85c725b8200018c215c82000adc01cc8200024c115c82000$$ENDHEX$$)
* $$HEX7$$08b8ecd3b8d22000200020002000$$ENDHEX$$: REPORT ( $$HEX4$$08b8ecd3b8d22000$$ENDHEX$$, $$HEX5$$9ccd25b800adacb92000$$ENDHEX$$)
****************************************/

F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control

/****************************************
* 
****************************************/

end event

event ue_data_control;call super::ue_data_control;Long ROW
STRING LVS_RCV_ISS_TYPE
CHOOSE CASE Gvs_Ue_DATA_control
	CASE 'RETRIEVE'

 			DW_1.RETRIEVE( DDLB_1.TEXT+'%' )
	CASE	'INSERT'
		
			DW_2.ENABLED = TRUE
			ROW = DW_2.INSERTROW(DW_2.GETROW())
			DW_2.SCROLLTOROW(ROW)
			DW_2.setitem(ROW , 'enter_date' , f_sysdate())
			DW_2.setitem(ROW , 'enter_by' , Gvs_user_id)				
			DW_2.setitem(ROW , 'last_modify_by' , Gvs_user_id)
			DW_2.setitem(ROW , 'last_modify_date' , f_sysdate())
			
	CASE	'APPEND'
		
			DW_2.ENABLED = TRUE
			ROW = DW_2.INSERTROW(0)
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'NONORG')	
			DW_2.setitem(ROW , 'enter_date' , f_sysdate())
			DW_2.setitem(ROW , 'enter_by' , Gvs_user_id)				
			DW_2.setitem(ROW , 'last_modify_by' , Gvs_user_id)
			DW_2.setitem(ROW , 'last_modify_date' , f_sysdate())
			
			
	CASE	'DELETE'
			if DW_1.AcceptText() = -1 then
				return
			end if
			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
				Gvl_row_deleted = DW_1.GetRow()			
				DW_1.DELETEROW(Gvl_row_deleted)		
				DW_1.SetFocus()
				ROW = DW_1.GetRow()
				DW_1.ScrollToRow(row)
				DW_1.SetColumn(1)
			END IF
			dw_2.reset()
	CASE 'UPDATE'

	      IF dw_1.UPDATE() < 0	or DW_2.UPDATE() < 0 THEN
			  	 ROLLBACK;
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			END IF

 		
	CASE ELSE
END CHOOSE


end event

event open;call super::open;SELECTED_DATA_WINDOW = DW_1



end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_company_master
integer y = 356
end type

type dw_4 from w_main_root`dw_4 within w_company_master
integer y = 356
integer taborder = 80
end type

type dw_3 from w_main_root`dw_3 within w_company_master
integer y = 356
integer taborder = 70
end type

type dw_2 from w_main_root`dw_2 within w_company_master
integer y = 2304
integer width = 4599
integer height = 568
integer taborder = 100
string title = "Sale Price Confirm"
string dataobject = "d_company_mst"
end type

type dw_1 from w_main_root`dw_1 within w_company_master
integer y = 284
integer width = 4599
integer height = 2004
boolean titlebar = true
string title = "Campany Manage"
string dataobject = "d_company_lst"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF	ROW < 1	THEN	RETURN
DW_2.RETRIEVE( DW_1.GETITEMSTRING( ROW, "ROWID" ))
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;
IF	CURRENTROW < 1	THEN	RETURN
DW_2.RETRIEVE( DW_1.GETITEMSTRING( CURRENTROW, 'ROWID' ))



end event

type uo_tabpages from w_main_root`uo_tabpages within w_company_master
end type

type st_1 from so_statictext within w_company_master
integer x = 64
integer y = 64
integer width = 603
integer height = 48
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Company Code"
end type

type ddlb_1 from uo_company_code within w_company_master
integer x = 64
integer y = 128
integer width = 603
integer taborder = 20
boolean bringtotop = true
end type

type gb_1 from groupbox within w_company_master
integer x = 9
integer width = 709
integer height = 244
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Where Condition"
end type

