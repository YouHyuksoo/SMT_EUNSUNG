HA$PBExportHeader$w_privilege_master.srw
$PBExportComments$Plivilege  Information Manage
forward
global type w_privilege_master from w_main_root
end type
type cb_1 from so_commandbutton within w_privilege_master
end type
type cb_2 from so_commandbutton within w_privilege_master
end type
type uo_role from uo_role_code within w_privilege_master
end type
type uo_user from uo_user_id_name within w_privilege_master
end type
type st_1 from so_statictext within w_privilege_master
end type
type cb_3 from so_commandbutton within w_privilege_master
end type
type gb_2 from so_groupbox within w_privilege_master
end type
type gb_1 from so_groupbox within w_privilege_master
end type
end forward

global type w_privilege_master from w_main_root
integer width = 4791
integer height = 3332
string title = "Application Plivilege"
cb_1 cb_1
cb_2 cb_2
uo_role uo_role
uo_user uo_user
st_1 st_1
cb_3 cb_3
gb_2 gb_2
gb_1 gb_1
end type
global w_privilege_master w_privilege_master

type variables

end variables

on w_privilege_master.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.cb_2=create cb_2
this.uo_role=create uo_role
this.uo_user=create uo_user
this.st_1=create st_1
this.cb_3=create cb_3
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.uo_role
this.Control[iCurrent+4]=this.uo_user
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.cb_3
this.Control[iCurrent+7]=this.gb_2
this.Control[iCurrent+8]=this.gb_1
end on

on w_privilege_master.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.uo_role)
destroy(this.uo_user)
destroy(this.st_1)
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
Ivs_resize_type    = 'MASTER_DETAIL_12T_3B'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
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

event ue_data_control;call super::ue_data_control;LONG ROW

CHOOSE CASE GVS_UE_DATA_CONTROL
	CASE 'RETRIEVE'
		
		     DW_1.RESET( )
			DW_2.RESET( )
			DW_3.RESET( )
			DW_1.RETRIEVE( GVI_ORGANIZATION_ID)
			DW_2.RETRIEVE(  UO_USER.GETCODE() , GVI_ORGANIZATION_ID)
		     DW_3.RETRIEVE(  UO_USER.GETCODE() , GVS_LANGUAGE ,  GVI_ORGANIZATION_ID)
			

	CASE 'INSERT'
			ROW = DW_3.INSERTROW(DW_3.GETROW())
			DW_3.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_3 , ROW , 'ALL')
			DW_3.SETITEM( ROW , 'role_type' , 'U' )
			DW_3.SETITEM( ROW , 'dateset' , f_t_sysdate() )
			DW_3.SETITEM( ROW , 'dateset' , f_t_sysdate() )			
			DW_3.SETFOCUS()
			F_MSG_MDI_HELP( F_MSG_ST(152))
	CASE 'APPEND'
			ROW = DW_3.INSERTROW(0)
			DW_3.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_3 , ROW , 'ALL')	
			DW_3.SETITEM( ROW , 'role_type' , 'U' )			
			DW_3.SETITEM( ROW , 'dateset' , f_t_sysdate() )			
			DW_3.SETITEM( ROW , 'dateset' , f_t_sysdate() )			
			DW_3.SETFOCUS()
			F_MSG_MDI_HELP( F_MSG_ST(152))
	CASE 'DELETE'
	
		  	IF DW_3.GETROW() < 1 THEN RETURN 
			  
			MSG = F_MSGBOX(1003) 
			IF MSG = 1 THEN
				GVL_ROW_DELETED = DW_3.GETROW()			
				DW_3.DELETEROW(GVL_ROW_DELETED)		
				DW_3.SETFOCUS()
				ROW = DW_3.GETROW()
				DW_3.SCROLLTOROW(ROW)
				DW_3.SETCOLUMN(1)
			END IF
			
	CASE 'UPDATE'
		
			IF DW_3.UPDATE() < 0 THEN
				ROLLBACK;
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( F_MSG_ST(170))
			END IF
			
	CASE ELSE
END CHOOSE

end event

event ue_post_open;call super::ue_post_open;f_child_dw2(dw_3, 'window_name', gvs_language, string(gvi_organization_id))
f_child_dw2(dw_3, 'window_description', gvs_language, string(gvi_organization_id))
/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
/****************************************
*
*****************************************/





end event

type dw_5 from w_main_root`dw_5 within w_privilege_master
integer y = 396
end type

type dw_4 from w_main_root`dw_4 within w_privilege_master
integer y = 396
end type

type dw_3 from w_main_root`dw_3 within w_privilege_master
integer y = 1060
integer width = 4654
integer height = 1108
boolean titlebar = true
string title = "Privilege List"
string dataobject = "d_privilege_lst_tree"
end type

event dw_3::rbuttondown;call super::rbuttondown;if dwo.name = 'window_name' then 
	
	open(w_window_popup)
	
	if message.stringparm = '' or isnull( message.stringparm ) then
	else
		
		this.object.window_name[row] = message.stringparm
		
	end if 
	
end if 
end event

type dw_2 from w_main_root`dw_2 within w_privilege_master
integer x = 2327
integer y = 312
integer width = 2313
integer height = 740
integer taborder = 40
boolean titlebar = true
string title = "Granted Role List"
string dataobject = "d_granted_role_code_lst"
boolean maxbox = false
end type

event dw_2::itemchanged;//OVERRIDE
end event

type dw_1 from w_main_root`dw_1 within w_privilege_master
integer y = 312
integer width = 2313
integer height = 740
boolean titlebar = true
string title = "Available Role List"
string dataobject = "d_role_code_lst"
end type

event dw_1::rbuttondown;call super::rbuttondown;IF DWO.NAME = 'user_id' THEN 
	
	OPEN(W_USER_POPUP)
	IF message.stringparm = '' THEN 
	ELSE	
		THIS.SETITEM( ROW , 'user_id' , message.stringparm )	
	END IF			

ELSEIF DWO.NAME = 'role_code' THEN
	
	OPEN(W_ROLE_POPUP)
	IF message.stringparm = '' THEN 
	ELSE	
		THIS.SETITEM( ROW , 'role_code' , message.stringparm )	
		THIS.SETITEM( ROW , 'window_name' ,Gst_return.gvs_return[1] )			
	END IF				
	
END IF
end event

event dw_1::itemchanged;//OVERRIDE
end event

type uo_tabpages from w_main_root`uo_tabpages within w_privilege_master
end type

type cb_1 from so_commandbutton within w_privilege_master
integer x = 2409
integer y = 68
integer width = 498
integer height = 100
integer taborder = 30
boolean bringtotop = true
string text = "Grant  Role"
end type

event clicked;IF F_OBJECT_ROLE_CHECK() = FALSE THEN  RETURN
STRING IVS_USER_ID , IVS_ROLE_CODE

ivs_user_id   = uo_user.GETCODE()
ivs_role_code = UO_ROLE.TEXT()

if ivs_user_id = '' or isnull(ivs_user_id) then 
   f_msgbox(185)	
   return	
end if

if ivs_role_code = '' or isnull(ivs_role_code) then 
   f_msgbox(185)		
   return	
end if

MSG = f_msgbox2( 188 , IVS_ROLE_CODE , IVS_USER_ID ) //MSG = ("Confirm" ,"Grant Role To User ID : " + IVS_USER_ID+' Role Code : '+IVS_ROLE_CODE  , QUESTION! , YESNO! )

IF MSG = 1 THEN 
ELSE
	RETURN
END IF
SETPOINTER(HOURGLASS!)

 DELETE FROM ISYS_privilege
  WHERE ( user_id ,window_name , role_code , organization_id ) 
     IN ( SELECT :IVS_USER_ID,  A.window_name, :IVS_ROLE_CODE , A.organization_id
            from ISYS_role a
           where A.role_code       =  :IVS_ROLE_CODE
             AND A.ORGANIZATION_ID = :GVI_ORGANIZATION_ID
	     ) 
    AND ROLE_TYPE = 'N' ;
	 
	 IF F_SQL_CHECK() < 0 THEN 
		 RETURN
	 END IF
	 
 INSERT INTO ISYS_privilege
            (user_id, window_name, organization_id, dateset, dateend,
             role_code, ROLE_TYPE , enter_by, enter_date, last_modify_by,
             last_modify_date
            )
     select :IVS_USER_ID, 
               a.window_name,
			:gvi_organization_id,
			a.dateset,
			NVL( a.dateend , TO_DATE('99991231','YYYYMMDD')),
			a.role_code,
			'N' , //NORMAL ROLE
			:gvs_user_id,
			sysdate,
			:gvs_user_id,
			sysdate
   from isys_role a
  where role_code       =  :IVS_ROLE_CODE
    AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	 
	 IF F_SQL_CHECK() < 0 THEN 
		 RETURN
	 END IF
	 
Msg= F_MSGBOX1( 9014 , STRING(SQLCA.SQLNROWS)) //@ $$HEX18$$74ac74c7200018c215c8200018b4c8c5b5c2c8b2e4b2200000c8a5c7200060d54cae94c6$$ENDHEX$$
IF MSG = 1 THEN 
	COMMIT ;
ELSE
	ROLLBACK;
END IF
	 
	 
end event

type cb_2 from so_commandbutton within w_privilege_master
integer x = 2409
integer y = 180
integer width = 498
integer height = 100
integer taborder = 40
boolean bringtotop = true
string text = "Revoke Role"
end type

event clicked;IF F_OBJECT_ROLE_CHECK() = FALSE THEN  RETURN
STRING IVS_USER_ID , IVS_ROLE_CODE

IVS_USER_ID      = uo_user.getcode()
IVS_ROLE_CODE = uo_role.text()

IF IVS_USER_ID = '' OR IVS_ROLE_CODE = '' THEN 
     f_msgbox( 185 )//("Notify" , "You Must Input User ID and Role Code" )
	RETURN
END IF

IF  IVS_USER_ID = '%' THEN 
	
	 msg = f_msgbox( 186 )	//MSG = ("Notify" , "Do you wish to Revoke All Users privilege?" , QUESTION! , YESNO!)
	
	IF MSG = 1 THEN 
	ELSE
		RETURN	
	END IF
END IF

MSG = F_MSGBOX2( 187 , IVS_ROLE_CODE , IVS_USER_ID ) //MSG = ("Confirm" ,"Revoke Role To User ID : " + IVS_USER_ID+' Role Code : '+IVS_ROLE_CODE  , QUESTION! , YESNO! )
IF MSG = 1 THEN 
ELSE
	RETURN
END IF
SETPOINTER(HOURGLASS!)

     DELETE FROM ISYS_privilege
	   WHERE USER_ID LIKE  :IVS_USER_ID
		  AND ROLE_CODE = :IVS_ROLE_CODE
		  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID
		  AND  ROLE_TYPE = 'N' ;  //NORMAL ROLE
	 
	 IF F_SQL_CHECK() < 0 THEN 
		 RETURN
	 END IF
	 
Msg= F_MSGBOX1( 9014 , STRING(SQLCA.SQLNROWS)+'  '  ) //@ $$HEX18$$74ac74c7200018c215c8200018b4c8c5b5c2c8b2e4b2200000c8a5c7200060d54cae94c6$$ENDHEX$$
IF MSG = 1 THEN 
	COMMIT ;
ELSE
	ROLLBACK;
END IF
end event

type uo_role from uo_role_code within w_privilege_master
integer x = 1097
integer y = 108
integer taborder = 70
boolean bringtotop = true
end type

on uo_role.destroy
call uo_role_code::destroy
end on

type uo_user from uo_user_id_name within w_privilege_master
integer x = 91
integer y = 172
integer width = 1001
integer height = 2108
integer taborder = 80
boolean bringtotop = true
end type

type st_1 from so_statictext within w_privilege_master
integer x = 96
integer y = 112
integer width = 997
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "User ID / Name"
end type

type cb_3 from so_commandbutton within w_privilege_master
integer x = 2971
integer y = 184
integer height = 100
integer taborder = 40
boolean bringtotop = true
string text = "Grant  Role Group"
end type

event clicked;call super::clicked;OPEN(W_USER_ROLE_GROUP_POPUP)
end event

type gb_2 from so_groupbox within w_privilege_master
integer x = 2359
integer width = 1184
integer height = 304
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_1 from so_groupbox within w_privilege_master
integer x = 5
integer width = 2281
integer height = 304
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

