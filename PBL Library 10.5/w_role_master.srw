HA$PBExportHeader$w_role_master.srw
$PBExportComments$Role  Information Manage
forward
global type w_role_master from w_main_root
end type
type uo_role from uo_role_code within w_role_master
end type
type cb_1 from so_commandbutton within w_role_master
end type
type cb_2 from so_commandbutton within w_role_master
end type
type sle_dest_role_code from so_singlelineedit within w_role_master
end type
type st_1 from so_statictext within w_role_master
end type
type sle_dest_role_name from so_singlelineedit within w_role_master
end type
type st_2 from so_statictext within w_role_master
end type
type cb_3 from so_commandbutton within w_role_master
end type
type rb_all from so_radiobutton within w_role_master
end type
type rb_2 from so_radiobutton within w_role_master
end type
type cb_4 from so_commandbutton within w_role_master
end type
type ddlb_from_org from uo_orz_id within w_role_master
end type
type ddlb_to_org from uo_orz_id within w_role_master
end type
type st_8 from so_statictext within w_role_master
end type
type st_9 from so_statictext within w_role_master
end type
type st_3 from so_statictext within w_role_master
end type
type sle_window_name from so_singlelineedit within w_role_master
end type
type st_4 from so_statictext within w_role_master
end type
type sle_1 from so_singlelineedit within w_role_master
end type
type gb_1 from so_groupbox within w_role_master
end type
type gb_2 from so_groupbox within w_role_master
end type
type gb_3 from so_groupbox within w_role_master
end type
type gb_4 from so_groupbox within w_role_master
end type
type gb_5 from so_groupbox within w_role_master
end type
type gb_6 from so_groupbox within w_role_master
end type
end forward

global type w_role_master from w_main_root
integer height = 2860
string title = "Role"
uo_role uo_role
cb_1 cb_1
cb_2 cb_2
sle_dest_role_code sle_dest_role_code
st_1 st_1
sle_dest_role_name sle_dest_role_name
st_2 st_2
cb_3 cb_3
rb_all rb_all
rb_2 rb_2
cb_4 cb_4
ddlb_from_org ddlb_from_org
ddlb_to_org ddlb_to_org
st_8 st_8
st_9 st_9
st_3 st_3
sle_window_name sle_window_name
st_4 st_4
sle_1 sle_1
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
gb_5 gb_5
gb_6 gb_6
end type
global w_role_master w_role_master

on w_role_master.create
int iCurrent
call super::create
this.uo_role=create uo_role
this.cb_1=create cb_1
this.cb_2=create cb_2
this.sle_dest_role_code=create sle_dest_role_code
this.st_1=create st_1
this.sle_dest_role_name=create sle_dest_role_name
this.st_2=create st_2
this.cb_3=create cb_3
this.rb_all=create rb_all
this.rb_2=create rb_2
this.cb_4=create cb_4
this.ddlb_from_org=create ddlb_from_org
this.ddlb_to_org=create ddlb_to_org
this.st_8=create st_8
this.st_9=create st_9
this.st_3=create st_3
this.sle_window_name=create sle_window_name
this.st_4=create st_4
this.sle_1=create sle_1
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_5=create gb_5
this.gb_6=create gb_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_role
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.sle_dest_role_code
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.sle_dest_role_name
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.cb_3
this.Control[iCurrent+9]=this.rb_all
this.Control[iCurrent+10]=this.rb_2
this.Control[iCurrent+11]=this.cb_4
this.Control[iCurrent+12]=this.ddlb_from_org
this.Control[iCurrent+13]=this.ddlb_to_org
this.Control[iCurrent+14]=this.st_8
this.Control[iCurrent+15]=this.st_9
this.Control[iCurrent+16]=this.st_3
this.Control[iCurrent+17]=this.sle_window_name
this.Control[iCurrent+18]=this.st_4
this.Control[iCurrent+19]=this.sle_1
this.Control[iCurrent+20]=this.gb_1
this.Control[iCurrent+21]=this.gb_2
this.Control[iCurrent+22]=this.gb_3
this.Control[iCurrent+23]=this.gb_4
this.Control[iCurrent+24]=this.gb_5
this.Control[iCurrent+25]=this.gb_6
end on

on w_role_master.destroy
call super::destroy
destroy(this.uo_role)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.sle_dest_role_code)
destroy(this.st_1)
destroy(this.sle_dest_role_name)
destroy(this.st_2)
destroy(this.cb_3)
destroy(this.rb_all)
destroy(this.rb_2)
destroy(this.cb_4)
destroy(this.ddlb_from_org)
destroy(this.ddlb_to_org)
destroy(this.st_8)
destroy(this.st_9)
destroy(this.st_3)
destroy(this.sle_window_name)
destroy(this.st_4)
destroy(this.sle_1)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_5)
destroy(this.gb_6)
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
Ivs_resize_type    = 'MASTER_DETAIL_12T'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'Y' //Default
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
		
		      DW_1.RESET()
		     if rb_all.checked = true then 
				DW_1.RETRIEVE( '%' , '*' , GVS_LANGUAGE , GVI_ORGANIZATION_ID)
			else
				DW_1.RETRIEVE( '%' , UO_ROLE.TEXT(), GVS_LANGUAGE , GVI_ORGANIZATION_ID)				
			end if
			
			DW_2.RETRIEVE(UO_ROLE.TEXT()  , GVI_ORGANIZATION_ID)
                  DW_2.SETFOCUS()

	CASE 'INSERT'
		
		     open(w_getin_new_role_code_name)
		     if Gst_return.Gvb_return = True then 
		     else
				return
			end if
		
		
			  INSERT INTO "ISYS_ROLE"  
					 ( "ROLE_CODE",   
					   "WINDOW_NAME",   
					   "ORGANIZATION_ID",   
					   "ROLE_NAME",   
					   "ROLE_TYPE",   
					   "DATESET",   
					   "DATEEND",   
					   "ENTER_DATE",   
					   "ENTER_BY",   
					   "LAST_MODIFY_DATE",   
					   "LAST_MODIFY_BY" )  
			  VALUES ( :Gst_return.Gvs_return[1],   
					   '*',   
					   :Gvi_organization_id,   
					   :Gst_return.Gvs_return[2],   
					   'N',   
					   TRUNC(SYSDATE),   
					   TO_DATE('99991231' , 'YYYYMMDD'),   
					   SYSDATE,   
					   :Gvs_user_id,   
					   SYSDATE,   
					   :Gvs_user_id)  ;

			if f_sql_check() < 0 then 
				return
			else
				commit ;
			end if 
//			ROW = DW_2.INSERTROW(DW_2.GETROW())
//			DW_2.SCROLLTOROW(ROW)
//			F_SET_SECURITY_ROW(DW_2 , ROW , 'ALL')
//			
//			DW_2.SETITEM( ROW , 'ROLE_CODE' , Gst_return.Gvs_return[1])
//			DW_2.SETITEM( ROW , 'ROLE_NAME' , Gst_return.Gvs_return[2])			
//			DW_2.SETITEM( ROW , 'DATESET' ,F_T_SYSDATE() )
//			DW_2.SETITEM( ROW , 'DATEEND' ,F_T_MAXDATE() )
//			
//			DW_2.SETITEM( ROW , 'ROLE_TYPE' ,'N' )			
//			
//			DW_2.SETFOCUS()
//			
//			F_MSG_MDI_HELP( F_MSG_ST(152))
//			
//			DW_2.GRoupcalc( )
			
	CASE 'APPEND'
			ROW = DW_2.INSERTROW(0)
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW , 'ALL')	
			
			DW_2.SETITEM( ROW , 'DATESET' ,F_T_SYSDATE() )			
			DW_2.SETITEM( ROW , 'ROLE_TYPE' ,'N' )			
			DW_2.SETITEM( ROW , 'DATEEND' ,F_T_MAXDATE() )
			DW_2.SETFOCUS()
			
			F_MSG_MDI_HELP( F_MSG_ST(152))	
			DW_2.GRoupcalc( )			
	CASE 'DELETE'
		
		  	IF DW_2.GETROW() < 1 THEN RETURN 
			  
			MSG = F_MSGBOX(1003) 
			IF MSG = 1 THEN
				
				
				//=============================================
				// Privilege Delete First 
				//=============================================				
				STRING LVS_WINDOW_NAME , LVS_ROLE_CODE
				LVS_ROLE_CODE= DW_2.OBJECT.ROLE_CODE[DW_2.GETROW()]
				LVS_WINDOW_NAME = DW_2.OBJECT.WINDOW_NAME[DW_2.GETROW()]
				
				DELETE FROM isys_privilege
			     WHERE ROLE_CODE            = :LVS_ROLE_CODE
				    AND WINDOW_NAME      = :LVS_WINDOW_NAME
				    AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
				
				IF F_SQL_CHECK() < 0 THEN 
					RETURN
				END IF
				
				GVL_ROW_DELETED = DW_2.GETROW()			
				DW_2.DELETEROW(GVL_ROW_DELETED)		
				DW_2.SETFOCUS()
				ROW = DW_2.GETROW()
				DW_2.SCROLLTOROW(ROW)
				DW_2.SETCOLUMN(1)
			END IF
			
	CASE 'UPDATE'
		
			IF DW_2.UPDATE() < 0 THEN
					ROLLBACK;
			ELSE
					 COMMIT;
            	         F_MSG_MDI_HELP( F_MSG_ST(170))//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			END IF
			
	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;f_child_dw2(dw_1, 'window_name', gvs_language, string(gvi_organization_id))
f_child_dw2(dw_1, 'window_description', gvs_language, string(gvi_organization_id))

f_child_dw2(dw_2, 'window_name', gvs_language, string(gvi_organization_id))
f_child_dw2(dw_2, 'window_description', gvs_language, string(gvi_organization_id))

/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
SELECTED_DATA_WINDOW = DW_1
SETPOINTER(HOURGLASS!)







end event

type dw_5 from w_main_root`dw_5 within w_role_master
integer y = 572
end type

type dw_4 from w_main_root`dw_4 within w_role_master
integer y = 572
end type

type dw_3 from w_main_root`dw_3 within w_role_master
integer y = 572
integer width = 603
integer height = 416
end type

type dw_2 from w_main_root`dw_2 within w_role_master
integer x = 2107
integer y = 572
integer width = 4786
integer height = 2172
integer taborder = 40
boolean titlebar = true
string title = "Role List"
string dataobject = "d_role_lst_tree"
end type

event dw_2::dragdrop;call super::dragdrop;DATAWINDOW ldw_Source 
LONG Lvl_row
string lvs_role_code , lvs_role_name
IF source.TypeOf() = DataWindow! THEN
   ldw_Source	= source
	
   IF ldw_Source  = THIS THEN 
   ELSE
		
		if row < 1 then 
			
			Lvl_row = this.insertrow(0)
			f_set_security_row( this , lvl_row , 'ALL')
//			this.object.role_code[Lvl_row] = this.object.role_code[row]			
//			this.object.role_name[Lvl_row] = this.object.role_name[row]						
			this.object.role_type[Lvl_row] = 'N'		
			this.object.window_name[Lvl_row] = ldw_Source.object.window_name[ldw_Source.getrow()]			
			this.object.window_description[Lvl_row] = ldw_Source.object.window_description[ldw_Source.getrow()]						
			this.object.dateset[Lvl_row] = f_t_sysdate()
			this.object.dateend[Lvl_row] = f_t_maxdate()						
		else
			lvs_role_code = this.object.role_code[row]			
			lvs_role_name = this.object.role_name[row]						
			Lvl_row = this.insertrow(row)
			f_set_security_row( this , lvl_row , 'ALL')
			this.object.role_code[Lvl_row] = lvs_role_code
			this.object.role_name[Lvl_row] = lvs_role_name
			this.object.role_type[Lvl_row] = 'N'			
			this.object.window_name[Lvl_row] = ldw_Source.object.window_name[ldw_Source.getrow()]		
			this.object.window_description[Lvl_row] = ldw_Source.object.window_description[ldw_Source.getrow()]									
			this.object.dateset[Lvl_row] = f_t_sysdate()
			this.object.dateend[Lvl_row] = f_t_maxdate()			
			
		end if

	END IF
		  
END IF

THIS.DRAG(END!)

THIS.GRoupcalc( )
end event

event dw_2::rbuttondown;call super::rbuttondown;if dwo.name ='window_name' then 
	open(w_window_popup)
	if message.stringparm = '' then
		return
	end if
	
	dw_2.setitem( row , 'window_name' , message.stringparm )
	
end if
end event

type dw_1 from w_main_root`dw_1 within w_role_master
integer y = 572
integer width = 2098
integer height = 2172
boolean titlebar = true
string title = "Window List"
string dataobject = "d_window_4_role_lst_tree"
end type

event dw_1::clicked;call super::clicked;IF UPPER(DWO.TYPE) = 'COLUMN' THEN
	DRAG(BEGIN!)
END IF
end event

type uo_tabpages from w_main_root`uo_tabpages within w_role_master
end type

type uo_role from uo_role_code within w_role_master
integer x = 649
integer y = 108
integer taborder = 70
boolean bringtotop = true
end type

on uo_role.destroy
call uo_role_code::destroy
end on

type cb_1 from so_commandbutton within w_role_master
integer x = 3470
integer y = 72
integer width = 471
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer weight = 400
string text = "Role Apply"
end type

event clicked;IF F_OBJECT_ROLE_CHECK() = FALSE THEN  RETURN
STRING IVS_USER_ID , IVS_ROLE_CODE
LONG  LVL_COUNT
IVS_ROLE_CODE = UO_ROLE.TEXT()

IF IVS_ROLE_CODE = '' OR ISNULL(IVS_ROLE_CODE) THEN 
	f_msgbox( 160)
//	("Notify" ," You Must Choose Role Code!" )
	UO_ROLE.SETFOCUS()
	RETURN
END IF

MSG = F_MSGBOX( 159)
//MSG = ("Confirm" ,"Do You wish to Apply Changed Roll?"  , QUESTION! , YESNO! )
IF MSG = 1 THEN 
ELSE
	RETURN
END IF
SETPOINTER(HOURGLASS!)

DELETE  FROM isys_privilege
 WHERE ( window_name, role_code , organization_id )
      IN ( SELECT  window_name, role_code , organization_id 
		      FROM isys_privilege
		    WHERE role_code       = :IVS_ROLE_CODE
			    AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
			    AND ROLE_TYPE <>  'U'
				 
		     MINUS 
			  
			  SELECT  window_name, role_code , organization_id 
			    FROM  isys_role
               WHERE  role_code       = :IVS_ROLE_CODE
			    AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
			) 
   AND ROLE_TYPE = 'N' 	;		 
			 
	 IF F_SQL_CHECK() < 0 THEN 
		 RETURN
	 END IF 
LVL_COUNT = LVL_COUNT+ SQLCA.SQLNROWS
 
 INSERT INTO isys_privilege
            (user_id, window_name, organization_id, dateset, dateend,
             role_code, ROLE_TYPE , enter_by, enter_date, last_modify_by,
             last_modify_date
            )
 select  DISTINCT b.user_id, 
               a.window_name,
			:gvi_organization_id,
			a.dateset,
			a.dateend,
			a.role_code, 'N' , 
			:gvs_user_id,
			trunc(sysdate),
			:gvs_user_id,
			trunc(sysdate)
   from isys_role a , ( select user_id , organization_id , role_code 
                          from isys_privilege
								 WHERE role_code       = :IVS_ROLE_CODE
                           AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
								  group by user_id , organization_id , role_code ) b
  where A.role_code       = B.role_code
    AND A.ORGANIZATION_ID = B.ORGANIZATION_ID 
    AND a.role_code       = :IVS_ROLE_CODE
    AND a.ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
    AND ( a.role_code , a.WINDOW_NAME ) 
    NOT IN ( SELECT b.role_code , B.WINDOW_NAME  FROM  isys_privilege b 
           WHERE B.role_code = :IVS_ROLE_CODE
             AND B.ORGANIZATION_ID = :GVI_ORGANIZATION_ID ) ;			
				 
	 IF F_SQL_CHECK() < 0 THEN 
		 RETURN
	 END IF

Msg= F_MSGBOX1( 9014 , 'Revoked Role = '+STRING(LVL_COUNT) +'  Granted Role='+STRING(SQLCA.SQLNROWS)) //@ $$HEX18$$74ac74c7200018c215c8200018b4c8c5b5c2c8b2e4b2200000c8a5c7200060d54cae94c6$$ENDHEX$$
IF MSG = 1 THEN 
	COMMIT ;
ELSE
	ROLLBACK;
END IF
	 
	 
end event

type cb_2 from so_commandbutton within w_role_master
integer x = 1870
integer y = 160
integer width = 471
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer weight = 400
string text = "Role Copy"
end type

event clicked;call super::clicked;Long i
STRING lvs_rowid

if dw_2.getrow() < 1 then 
	Messagebox("Notify" , "Right Side Role List Not Found. Retrieve Data and Check Retry.")
	return
end if 

if  SLE_DEST_ROLE_CODE.TEXT = '' OR SLE_DEST_ROLE_NAME.TEXT = '' then 
	F_MSGBOX( 158)
	//("Notify" , "Dest Role Code / Name Invalid")
	return
end if

do
	i++
	
	if DW_2.object.check_yn[i] = 'Y' then

	else
		continue 
	end if
		
		lvs_rowid = DW_2.object.rowid[i]
		
INSERT INTO "ISYS_ROLE"  
         ( "ROLE_CODE",   
           "WINDOW_NAME",   
           "ROLE_NAME",   
           "ROLE_TYPE",   
           "DATESET",   
           "DATEEND",   
           "ENTER_DATE",   
           "ENTER_BY",   
           "LAST_MODIFY_DATE",   
           "LAST_MODIFY_BY",   
           "ORGANIZATION_ID" )  
 SELECT :SLE_DEST_ROLE_CODE.TEXT ,   
           "WINDOW_NAME",   
           :SLE_DEST_ROLE_NAME.TEXT ,   
           "ROLE_TYPE",   
           "DATESET",   
           "DATEEND",   
           "ENTER_DATE",   
           "ENTER_BY",   
           "LAST_MODIFY_DATE",   
           "LAST_MODIFY_BY",   
           "ORGANIZATION_ID" 
   FROM "ISYS_ROLE"
 WHERE ROWID = :LVS_ROWID ;
 
 IF F_SQL_CHECK() < 0 THEN 
	RETURN
END IF
 	
loop until i = DW_2.rowcount()

MSG = F_MSGBOX( 1170 ) 
IF MSG = 1 THEN 
	COMMIT ;
	F_MSG_MDI_HELP( F_MSG_ST(170) )
	
ELSE
	ROLLBACK ; 
END IF

end event

type sle_dest_role_code from so_singlelineedit within w_role_master
integer x = 2368
integer y = 172
integer taborder = 80
boolean bringtotop = true
long backcolor = 16777215
end type

type st_1 from so_statictext within w_role_master
integer x = 2363
integer y = 104
integer height = 56
boolean bringtotop = true
string text = "Dest Role Code"
end type

type sle_dest_role_name from so_singlelineedit within w_role_master
integer x = 2871
integer y = 172
integer taborder = 90
boolean bringtotop = true
long backcolor = 16777215
end type

type st_2 from so_statictext within w_role_master
integer x = 2871
integer y = 104
integer height = 56
boolean bringtotop = true
string text = "Dest Role Name"
end type

type cb_3 from so_commandbutton within w_role_master
integer x = 3470
integer y = 184
integer width = 471
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer weight = 400
string text = "Add Window"
end type

event clicked;call super::clicked;Long i , j ,lvl_row
String  lvs_role_code	,  lvs_role_name
SETPOINTER(HOURGLASS!)


if dw_1.getrow() < 1 then 
	return
end if

if dw_2.getrow() < 1 then 
else
	
	lvs_role_code = dw_2.object.role_code[dw_2.getrow()]		
	lvs_role_name= dw_2.object.role_name[dw_2.getrow()]		
	
end if 



Open(w_please_wait_popup)
Do
	 i++
	 if dw_1.object.check_yn[i] = 'Y' then 
		J++
	 else
		continue
	 end if
 
		Lvl_row = dw_2.insertrow(0)
		f_set_security_row( dw_2 , lvl_row , 'ALL')
		

		dw_2.object.role_code[Lvl_row]  = lvs_role_code	
		dw_2.object.role_name[Lvl_row] =  lvs_role_name
		
		dw_2.object.window_name[Lvl_row] = dw_1.object.window_name[i]			
		dw_2.object.dateset[Lvl_row] = f_t_sysdate()
		dw_2.object.dateend[Lvl_row] = date( '9999/12/31')
		dw_2.object.role_type[Lvl_row] = 'N'
		
		dw_1.object.check_yn[i] = 'N'
	
Loop until i = dw_1.rowcount()

Close(w_please_wait_popup)

if j = 0 then 
	
  Messagebox("Notify", "You must select (Check)  `window name` in Window List" )
  dw_1.setfocus()
  dw_1.setcolumn('check_yn')
	
end if
end event

type rb_all from so_radiobutton within w_role_master
integer x = 50
integer y = 88
boolean bringtotop = true
string text = "All Window"
boolean checked = true
end type

type rb_2 from so_radiobutton within w_role_master
integer x = 50
integer y = 192
boolean bringtotop = true
string text = "New Window"
end type

type cb_4 from so_commandbutton within w_role_master
integer x = 1833
integer y = 452
integer width = 581
integer height = 92
integer taborder = 70
boolean bringtotop = true
integer weight = 400
string text = "Sync Org Role"
end type

event clicked;call super::clicked;INT LVI_FROM_ORG , LVI_TO_ORG

LVI_FROM_ORG = INTEGER( DDLB_FROM_ORG.GETCODE( ) )
LVI_TO_ORG = INTEGER( DDLB_TO_ORG.GETCODE( ) )

    INSERT INTO "ISYS_ROLE"  
         ( "ROLE_CODE",   
           "WINDOW_NAME",   
           "ORGANIZATION_ID",   
           "ROLE_NAME",   
           "ROLE_TYPE",   
           "DATESET",   
           "DATEEND",   
           "ENTER_DATE",   
           "ENTER_BY",   
           "LAST_MODIFY_DATE",   
           "LAST_MODIFY_BY" )  
     SELECT "ISYS_ROLE"."ROLE_CODE",   
            "ISYS_ROLE"."WINDOW_NAME",   
            :LVI_TO_ORG , //"ISYS_ROLE"."ORGANIZATION_ID",   
            "ISYS_ROLE"."ROLE_NAME",   
            "ISYS_ROLE"."ROLE_TYPE",   
            "ISYS_ROLE"."DATESET",   
            "ISYS_ROLE"."DATEEND",   
            "ISYS_ROLE"."ENTER_DATE",   
            "ISYS_ROLE"."ENTER_BY",   
            "ISYS_ROLE"."LAST_MODIFY_DATE",   
            "ISYS_ROLE"."LAST_MODIFY_BY"  
       FROM "ISYS_ROLE" 
    WHERE ORGANIZATION_ID  = 		 :LVI_FROM_ORG
	  AND ROLE_CODE NOT IN ( SELECT ROLE_CODE FROM ISYS_ROLE WHERE ORGANIZATION_ID  =  :LVI_TO_ORG ) ;
	  
IF F_SQL_CHECK() < 0 THEN 
	RETURN
ELSE
	MSG = F_MSGBOX( 1170 )
	IF MSG = 1 THEN 
		COMMIT ;
	ELSE
		ROLLBACK;
	END IF
END IF 
		 
		 


end event

type ddlb_from_org from uo_orz_id within w_role_master
integer x = 2427
integer y = 452
integer width = 722
integer taborder = 40
boolean bringtotop = true
end type

type ddlb_to_org from uo_orz_id within w_role_master
integer x = 3159
integer y = 452
integer width = 722
integer taborder = 50
boolean bringtotop = true
end type

type st_8 from so_statictext within w_role_master
integer x = 2432
integer y = 376
integer width = 722
integer height = 68
boolean bringtotop = true
string text = "From"
end type

type st_9 from so_statictext within w_role_master
integer x = 3163
integer y = 380
integer width = 722
integer height = 68
boolean bringtotop = true
string text = "To"
end type

type st_3 from so_statictext within w_role_master
integer x = 32
integer y = 396
integer width = 782
integer height = 56
boolean bringtotop = true
string text = "Window Name"
end type

type sle_window_name from so_singlelineedit within w_role_master
integer x = 32
integer y = 460
integer width = 782
integer height = 84
integer taborder = 30
boolean bringtotop = true
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

LVS_COLUMN = 'WINDOW_NAME'
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

type st_4 from so_statictext within w_role_master
integer x = 905
integer y = 396
integer width = 814
integer height = 56
boolean bringtotop = true
string text = "Role Window Name"
end type

type sle_1 from so_singlelineedit within w_role_master
integer x = 905
integer y = 460
integer width = 814
integer height = 84
integer taborder = 40
boolean bringtotop = true
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_2.SETFILTER('')
dw_2.FILTER()

LVS_COLUMN = 'WINDOW_NAME'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_2.SETFILTER('')
    dw_2.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

dw_2.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
dw_2.FILTER()
F_MSG_MDI_HELP( STRING( dw_2.ROWCOUNT() ) + " Found" )
end event

type gb_1 from so_groupbox within w_role_master
integer x = 1787
integer width = 1609
integer height = 336
integer taborder = 30
long textcolor = 16711680
string text = "Role Copy"
end type

type gb_2 from so_groupbox within w_role_master
integer width = 581
integer height = 336
integer taborder = 10
long textcolor = 16711680
string text = "Category"
end type

type gb_3 from so_groupbox within w_role_master
integer x = 3406
integer width = 585
integer height = 336
integer taborder = 20
long textcolor = 16711680
string text = "Process"
end type

type gb_4 from so_groupbox within w_role_master
integer x = 603
integer width = 1175
integer height = 336
integer taborder = 10
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_5 from so_groupbox within w_role_master
integer y = 332
integer width = 1769
integer height = 232
integer taborder = 20
long textcolor = 16711680
string text = "Filter"
end type

type gb_6 from so_groupbox within w_role_master
integer x = 1787
integer y = 332
integer width = 2194
integer height = 232
integer taborder = 30
long textcolor = 16711680
string text = "Process"
end type

