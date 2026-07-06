HA$PBExportHeader$w_system_config.srw
$PBExportComments$Dual Language Information Manage
forward
global type w_system_config from w_main_root
end type
type ddlb_org_id from uo_orz_id within w_system_config
end type
type st_7 from so_statictext within w_system_config
end type
type cb_1 from so_commandbutton within w_system_config
end type
type ddlb_from_org from uo_orz_id within w_system_config
end type
type st_8 from so_statictext within w_system_config
end type
type st_9 from so_statictext within w_system_config
end type
type ddlb_to_org from uo_orz_id within w_system_config
end type
type cb_3 from so_commandbutton within w_system_config
end type
type gb_2 from so_groupbox within w_system_config
end type
type gb_1 from so_groupbox within w_system_config
end type
end forward

global type w_system_config from w_main_root
string title = "System Environment"
ddlb_org_id ddlb_org_id
st_7 st_7
cb_1 cb_1
ddlb_from_org ddlb_from_org
st_8 st_8
st_9 st_9
ddlb_to_org ddlb_to_org
cb_3 cb_3
gb_2 gb_2
gb_1 gb_1
end type
global w_system_config w_system_config

type variables
datawindow ivd_data_window
end variables

on w_system_config.create
int iCurrent
call super::create
this.ddlb_org_id=create ddlb_org_id
this.st_7=create st_7
this.cb_1=create cb_1
this.ddlb_from_org=create ddlb_from_org
this.st_8=create st_8
this.st_9=create st_9
this.ddlb_to_org=create ddlb_to_org
this.cb_3=create cb_3
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_org_id
this.Control[iCurrent+2]=this.st_7
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.ddlb_from_org
this.Control[iCurrent+5]=this.st_8
this.Control[iCurrent+6]=this.st_9
this.Control[iCurrent+7]=this.ddlb_to_org
this.Control[iCurrent+8]=this.cb_3
this.Control[iCurrent+9]=this.gb_2
this.Control[iCurrent+10]=this.gb_1
end on

on w_system_config.destroy
call super::destroy
destroy(this.ddlb_org_id)
destroy(this.st_7)
destroy(this.cb_1)
destroy(this.ddlb_from_org)
destroy(this.st_8)
destroy(this.st_9)
destroy(this.ddlb_to_org)
destroy(this.cb_3)
destroy(this.gb_2)
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
Ivs_resize_type    = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
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
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		
			DW_1.RETRIEVE(DDLB_ORG_ID.GETCODE()+'%')
			DW_1.GRoupcalc( )
			DW_1.SETFOCUS()
			
	CASE 'INSERT'
			ROW = DW_1.INSERTROW(DW_1.GETROW())
			DW_1.SCROLLTOROW(ROW)
			DW_1.GRoupcalc( )
			F_SET_SECURITY_ROW(DW_1 , ROW , 'ALL')
	CASE 'APPEND'
			ROW = DW_1.INSERTROW(0)
			DW_1.SCROLLTOROW(ROW)
			DW_1.GRoupcalc( )			
			F_SET_SECURITY_ROW(DW_1 , ROW , 'ALL')	
	CASE 'DELETE'
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
						
	CASE 'UPDATE'
		
          	IF DW_1.UPDATE() < 0 THEN
				ROLLBACK;
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( "Update Complete" ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			END IF
			
	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_system_config
integer y = 296
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_system_config
integer y = 296
integer taborder = 50
end type

type dw_3 from w_main_root`dw_3 within w_system_config
integer y = 300
integer taborder = 60
end type

type dw_2 from w_main_root`dw_2 within w_system_config
integer y = 300
integer taborder = 70
end type

type dw_1 from w_main_root`dw_1 within w_system_config
integer y = 296
integer width = 4507
integer height = 1948
integer taborder = 0
boolean titlebar = true
string title = "System Environment List"
string dataobject = "d_system_config"
end type

type ddlb_org_id from uo_orz_id within w_system_config
integer x = 32
integer y = 172
integer width = 722
boolean bringtotop = true
end type

type st_7 from so_statictext within w_system_config
integer x = 32
integer y = 88
integer width = 722
boolean bringtotop = true
integer weight = 700
string text = "Org ID"
end type

type cb_1 from so_commandbutton within w_system_config
integer x = 905
integer y = 116
integer height = 100
integer taborder = 20
boolean bringtotop = true
string text = "Config Reset"
end type

event clicked;call super::clicked;int lvi_return
lvi_return = f_config_setup()
if lvi_return >= 0 then
	Messagebox("Notify" , "OK")
else
	Messagebox("Notify" , "Config Reset Failed")	
end if
end event

type ddlb_from_org from uo_orz_id within w_system_config
integer x = 2039
integer y = 124
integer width = 722
integer taborder = 50
boolean bringtotop = true
end type

type st_8 from so_statictext within w_system_config
integer x = 2043
integer y = 44
integer width = 722
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "From"
end type

type st_9 from so_statictext within w_system_config
integer x = 2775
integer y = 48
integer width = 722
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "To"
end type

type ddlb_to_org from uo_orz_id within w_system_config
integer x = 2770
integer y = 124
integer width = 722
integer taborder = 60
boolean bringtotop = true
end type

type cb_3 from so_commandbutton within w_system_config
integer x = 1445
integer y = 116
integer height = 100
integer taborder = 80
boolean bringtotop = true
string text = "Sync Config"
end type

event clicked;call super::clicked;INT LVI_FROM_ORG , LVI_TO_ORG

LVI_FROM_ORG = INTEGER( DDLB_FROM_ORG.GETCODE( ) )
LVI_TO_ORG = INTEGER( DDLB_TO_ORG.GETCODE( ) )

msg = f_msgbox1( 1161 , this.text)
if msg = 1 then
else
	return
end if

  INSERT INTO "ISYS_CONFIG"  
         ( "CONFIG_NAME",   
           "ORGANIZATION_ID",   
           "CONFIG_DESCRIPTION",   
           "CONFIG_VALUE",   
           "CONFIG_VALUE_DESCRIPTION",   
           "ENTER_DATE",   
           "ENTER_BY",   
           "LAST_MODIFY_DATE",   
           "LAST_MODIFY_BY",   
           "USE_YN" )  
SELECT "CONFIG_NAME",   
          :LVI_TO_ORG , 
           "CONFIG_DESCRIPTION",   
           "CONFIG_VALUE",   
           "CONFIG_VALUE_DESCRIPTION",   
           "ENTER_DATE",   
           "ENTER_BY",   
           "LAST_MODIFY_DATE",   
           "LAST_MODIFY_BY",   
           "USE_YN"
 FROM ISYS_CONFIG 
    WHERE ORGANIZATION_ID  = 		 :LVI_FROM_ORG
	  AND CONFIG_NAME  NOT IN ( SELECT CONFIG_NAME FROM ISYS_CONFIG WHERE ORGANIZATION_ID  =  :LVI_TO_ORG ) ;
	  
IF F_SQL_CHECK() < 0 THEN 
	RETURN
ELSE
	
	
	MSG = F_MSGBOX1( 9014  , String(sqlca.sqlnrows) )
	IF MSG = 1 THEN 
		COMMIT ;
	ELSE
		ROLLBACK;
	END IF
END IF 
		 
		 


end event

type gb_2 from so_groupbox within w_system_config
integer x = 791
integer width = 2761
integer height = 284
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_1 from so_groupbox within w_system_config
integer width = 773
integer height = 284
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

