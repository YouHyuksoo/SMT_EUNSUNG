HA$PBExportHeader$w_system_access_master.srw
$PBExportComments$System Access Master
forward
global type w_system_access_master from w_main_root
end type
type st_receipt_date from so_statictext within w_system_access_master
end type
type uo_dateset from uo_ymd_calendar within w_system_access_master
end type
type uo_dateend from uo_ymd_calendar within w_system_access_master
end type
type cb_1 from commandbutton within w_system_access_master
end type
type ddlb_user_id_name from uo_user_id_name within w_system_access_master
end type
type st_1 from so_statictext within w_system_access_master
end type
type gb_2 from so_groupbox within w_system_access_master
end type
type gb_1 from so_groupbox within w_system_access_master
end type
end forward

global type w_system_access_master from w_main_root
string title = "System Access Master"
string icon = "Form!"
st_receipt_date st_receipt_date
uo_dateset uo_dateset
uo_dateend uo_dateend
cb_1 cb_1
ddlb_user_id_name ddlb_user_id_name
st_1 st_1
gb_2 gb_2
gb_1 gb_1
end type
global w_system_access_master w_system_access_master

type variables

end variables

on w_system_access_master.create
int iCurrent
call super::create
this.st_receipt_date=create st_receipt_date
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.cb_1=create cb_1
this.ddlb_user_id_name=create ddlb_user_id_name
this.st_1=create st_1
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_receipt_date
this.Control[iCurrent+2]=this.uo_dateset
this.Control[iCurrent+3]=this.uo_dateend
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.ddlb_user_id_name
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.gb_2
this.Control[iCurrent+8]=this.gb_1
end on

on w_system_access_master.destroy
call super::destroy
destroy(this.st_receipt_date)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.cb_1)
destroy(this.ddlb_user_id_name)
destroy(this.st_1)
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
CHOOSE CASE Gvs_Ue_DATA_control
	CASE 'RETRIEVE'
		
				DW_1.RETRIEVE( UO_DATESET.TEXT() , UO_DATEEND.TEXT() , ddlb_user_id_name.getcode()+'%' , GVI_ORGANIZATION_ID)
				DW_1.SETFOCUS()				
		
			
	CASE 'DELETE'
		  	IF DW_1.GETROW() < 1 THEN RETURN 
			  
			MSG = F_MSGBOX(1003) 
			IF MSG = 1 THEN
				GVL_ROW_DELETED = DW_1.GETROW()			
				DW_1.DELETEROW(GVL_ROW_DELETED)		
				DW_1.SETFOCUS()
				ROW = DW_1.GETROW()
				DW_1.SCROLLTOROW(ROW)
				DW_1.SETCOLUMN(1)
			END IF
			
	CASE 'UPDATE'
		
	         IF DW_1.UPDATE() < 0 THEN
				ROLLBACK;
			ELSE
				 COMMIT;
	  			 F_MSG_MDI_HELP( F_MSG_ST(170))//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			END IF
			
	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* Window Property Setup
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_system_access_master
integer y = 300
end type

type dw_4 from w_main_root`dw_4 within w_system_access_master
integer y = 300
end type

type dw_3 from w_main_root`dw_3 within w_system_access_master
integer y = 300
integer taborder = 60
end type

type dw_2 from w_main_root`dw_2 within w_system_access_master
integer y = 300
integer taborder = 40
end type

type dw_1 from w_main_root`dw_1 within w_system_access_master
integer y = 300
integer width = 4544
integer height = 2200
integer taborder = 50
boolean titlebar = true
string title = "System Access List"
string dataobject = "d_system_access_lst"
end type

type st_receipt_date from so_statictext within w_system_access_master
integer x = 215
integer y = 84
integer width = 795
boolean bringtotop = true
integer weight = 700
string text = "System Access Date"
end type

type uo_dateset from uo_ymd_calendar within w_system_access_master
integer x = 206
integer y = 164
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_system_access_master
integer x = 622
integer y = 164
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type cb_1 from commandbutton within w_system_access_master
integer x = 1856
integer y = 108
integer width = 613
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Quick Delete ( All)"
end type

event clicked;MSG = F_MSGBOX( 1003 )
IF MSG = 1 THEN
	
	DELETE FROM "ISYS_SYSTEM_ACCESS"   WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	IF F_SQL_CHECK() < 0 THEN 
		ROLLBACK ;
	ELSE
		COMMIT ;
		F_MSG_MDI_HELP( F_MSG_ST(170 ))
		F_RETRIEVE()
	END IF

ELSE
	
END IF
end event

type ddlb_user_id_name from uo_user_id_name within w_system_access_master
integer x = 1047
integer y = 168
integer taborder = 60
boolean bringtotop = true
end type

type st_1 from so_statictext within w_system_access_master
integer x = 1047
integer y = 80
integer width = 608
boolean bringtotop = true
integer weight = 700
string text = "User ID / Name"
end type

type gb_2 from so_groupbox within w_system_access_master
integer x = 1815
integer width = 677
integer height = 288
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_1 from so_groupbox within w_system_access_master
integer x = 9
integer width = 1774
integer height = 288
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

