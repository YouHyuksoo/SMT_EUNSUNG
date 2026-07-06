HA$PBExportHeader$w_system_backup_master.srw
$PBExportComments$Dual Language Information Manage
forward
global type w_system_backup_master from w_main_root
end type
type st_7 from so_statictext within w_system_backup_master
end type
type ddlb_org_id from uo_orz_id within w_system_backup_master
end type
type cb_1 from so_commandbutton within w_system_backup_master
end type
type gb_2 from so_groupbox within w_system_backup_master
end type
type gb_1 from so_groupbox within w_system_backup_master
end type
end forward

global type w_system_backup_master from w_main_root
integer width = 4562
string title = "System Environment"
st_7 st_7
ddlb_org_id ddlb_org_id
cb_1 cb_1
gb_2 gb_2
gb_1 gb_1
end type
global w_system_backup_master w_system_backup_master

type variables
datawindow ivd_data_window
end variables

on w_system_backup_master.create
int iCurrent
call super::create
this.st_7=create st_7
this.ddlb_org_id=create ddlb_org_id
this.cb_1=create cb_1
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_7
this.Control[iCurrent+2]=this.ddlb_org_id
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.gb_2
this.Control[iCurrent+5]=this.gb_1
end on

on w_system_backup_master.destroy
call super::destroy
destroy(this.st_7)
destroy(this.ddlb_org_id)
destroy(this.cb_1)
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

F_MENU_CONTROL('DATA_CONTROL_MODIFY' , TRUE)  // All Data Control

/****************************************
* 
****************************************/

end event

event ue_data_control;call super::ue_data_control;Long i
String lvs_table , lvs_comment , lvs_execute
CHOOSE CASE Gvs_Ue_data_control
		
		
	CASE 'RETRIEVE'
		
		dw_1.reset( )
		dw_1.retrieve( )
	
		
	CASE 'UPDATE' 
		
	     dw_1.accepttext( )
		do
			i++
			
			lvs_table       = dw_1.object.tname[i] 
			lvs_comment = dw_1.object.comments[i] 
			
			if lvs_comment  = '' or isnull(lvs_comment) then 
			else
			
				lvs_execute = 'COMMENT ON TABLE '+LVS_TABLE+' IS '+'~''+lvs_comment+'~''
				EXECUTE  IMMEDIATE :lvs_execute ;
				
			end if
			
			if f_sql_check() < 0 then 
				return
			end if
			
		loop until i = dw_1.rowcount( )

			
	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_system_backup_master
integer y = 320
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_system_backup_master
integer y = 320
integer taborder = 50
end type

type dw_3 from w_main_root`dw_3 within w_system_backup_master
integer y = 320
integer taborder = 60
end type

type dw_2 from w_main_root`dw_2 within w_system_backup_master
integer y = 320
integer taborder = 70
end type

type dw_1 from w_main_root`dw_1 within w_system_backup_master
integer y = 320
integer width = 4507
integer height = 1920
integer taborder = 0
boolean titlebar = true
string title = "System Backup List"
string dataobject = "d_table_list"
end type

event dw_1::itemchanged;//overide
end event

type st_7 from so_statictext within w_system_backup_master
integer x = 32
integer y = 76
integer width = 722
boolean bringtotop = true
integer weight = 700
string text = "Org ID"
end type

type ddlb_org_id from uo_orz_id within w_system_backup_master
integer x = 32
integer y = 160
integer width = 722
integer taborder = 60
boolean bringtotop = true
end type

type cb_1 from so_commandbutton within w_system_backup_master
integer x = 955
integer y = 112
integer height = 116
integer taborder = 70
boolean bringtotop = true
string text = "Backup"
end type

type gb_2 from so_groupbox within w_system_backup_master
integer x = 823
integer width = 809
integer height = 312
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_1 from so_groupbox within w_system_backup_master
integer width = 809
integer height = 312
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

