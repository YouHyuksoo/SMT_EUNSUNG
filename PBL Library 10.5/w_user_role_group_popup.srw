HA$PBExportHeader$w_user_role_group_popup.srw
$PBExportComments$(Supplier Query)-$$HEX5$$70ac98b798cc70c88cd6$$ENDHEX$$
forward
global type w_user_role_group_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_user_role_group_popup
end type
type cb_select from so_commandbutton within w_user_role_group_popup
end type
type st_14 from so_statictext within w_user_role_group_popup
end type
type sle_user_name from so_singlelineedit within w_user_role_group_popup
end type
type cb_1 from so_commandbutton within w_user_role_group_popup
end type
type sle_1 from so_singlelineedit within w_user_role_group_popup
end type
type st_1 from so_statictext within w_user_role_group_popup
end type
type gb_1 from so_groupbox within w_user_role_group_popup
end type
type gb_2 from so_groupbox within w_user_role_group_popup
end type
end forward

global type w_user_role_group_popup from w_popup_root
integer width = 3881
string title = "Group Role Popup"
cb_retrieve cb_retrieve
cb_select cb_select
st_14 st_14
sle_user_name sle_user_name
cb_1 cb_1
sle_1 sle_1
st_1 st_1
gb_1 gb_1
gb_2 gb_2
end type
global w_user_role_group_popup w_user_role_group_popup

on w_user_role_group_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.st_14=create st_14
this.sle_user_name=create sle_user_name
this.cb_1=create cb_1
this.sle_1=create sle_1
this.st_1=create st_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.st_14
this.Control[iCurrent+4]=this.sle_user_name
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.sle_1
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.gb_2
end on

on w_user_role_group_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.st_14)
destroy(this.sle_user_name)
destroy(this.cb_1)
destroy(this.sle_1)
destroy(this.st_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;dw_1.settransobject(sqlca)
CB_RETRIEVE.TRIGGEREVENT(CLICKED!)
SLE_USER_NAME.SETFOCUS()
end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
	
end if
end event

event activate;call super::activate;IVS_RESIZE_TYPE = 'DEFAULT'
end event

type p_title from w_popup_root`p_title within w_user_role_group_popup
integer width = 3867
end type

type cb_sort from w_popup_root`cb_sort within w_user_role_group_popup
boolean visible = true
integer x = 1422
integer y = 324
integer width = 283
integer height = 148
end type

type cb_close from w_popup_root`cb_close within w_user_role_group_popup
boolean visible = true
integer x = 1993
integer y = 324
integer width = 283
integer height = 148
end type

type st_msg from w_popup_root`st_msg within w_user_role_group_popup
boolean visible = true
integer x = 5
integer y = 568
integer width = 3867
end type

type dw_1 from w_popup_root`dw_1 within w_user_role_group_popup
boolean visible = true
integer x = 2039
integer y = 664
integer width = 1829
integer height = 1496
boolean titlebar = true
string title = "User List"
string dataobject = "d_user_role_group_popup"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
cb_select.triggerevent(clicked!)
end event

type dw_2 from w_popup_root`dw_2 within w_user_role_group_popup
boolean visible = true
integer x = 5
integer y = 664
integer width = 1573
integer height = 1496
boolean titlebar = true
string title = "Role List"
string dataobject = "d_role_group_popup"
end type

event dw_2::rowfocuschanged;call super::rowfocuschanged;this.selectrow(0 , false)
this.selectrow(currentrow , true)
end event

type dw_3 from w_popup_root`dw_3 within w_user_role_group_popup
integer x = 5
integer y = 664
end type

type cb_retrieve from so_commandbutton within w_user_role_group_popup
integer x = 1705
integer y = 324
integer width = 283
integer height = 148
integer taborder = 70
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE('%'+SLE_USER_NAME.TEXT+'%' , GVI_ORGANIZATION_ID )
dw_2.retrieve(GVI_ORGANIZATION_ID)
end event

type cb_select from so_commandbutton within w_user_role_group_popup
integer x = 1646
integer y = 1176
integer width = 347
integer height = 148
integer taborder = 80
boolean bringtotop = true
string text = "Grant >>"
end type

event clicked;IF F_OBJECT_ROLE_CHECK() = FALSE THEN  RETURN
STRING IVS_USER_ID , IVS_ROLE_CODE
int i

if dw_1.getrow() < 1 then 
	return
end if

if dw_2.getrow() < 1 then 
	return
end if

	IVS_ROLE_CODE = dw_2.object.role_code[dw_2.getrow()]
	MSG = f_msgbox2( 188 , IVS_ROLE_CODE , 'USERS' )

	IF MSG = 1 THEN 
	ELSE
		RETURN
	END IF
SETPOINTER(HOURGLASS!)


//===============================================================
//
//===============================================================
DO
	I++
	
	if dw_1.object.check_yn[i] = 'Y' then 
		
		IVS_USER_ID      =  dw_1.object.user_id[i]		

		
		if ivs_user_id = '' or isnull(ivs_user_id) then 
		   f_msgbox(185)	
		   return	
		end if
		
		if ivs_role_code = '' or isnull(ivs_role_code) then 
		   f_msgbox(185)		
		   return	
		end if
		
	else
		continue
	end if
		
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
			 
	loop until i = dw_1.rowcount( )
		
//===============================================================
//
//===============================================================
	 
Msg= F_MSGBOX1( 9014 , STRING(SQLCA.SQLNROWS)) //@ $$HEX18$$74ac74c7200018c215c8200018b4c8c5b5c2c8b2e4b2200000c8a5c7200060d54cae94c6$$ENDHEX$$
IF MSG = 1 THEN 
	COMMIT ;
ELSE
	ROLLBACK;
END IF
	 
	 
end event

type st_14 from so_statictext within w_user_role_group_popup
integer x = 50
integer y = 336
integer width = 640
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "User Name"
end type

type sle_user_name from so_singlelineedit within w_user_role_group_popup
integer x = 50
integer y = 420
integer width = 640
integer taborder = 30
boolean bringtotop = true
end type

event modified;call super::modified;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

LVS_COLUMN = 'USER_NAME'

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

dw_1.SETFILTER('')
dw_1.FILTER()

IF THIS.TEXT = '' THEN 
	LVS_VALUE = '%'
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

dw_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found" )
end event

type cb_1 from so_commandbutton within w_user_role_group_popup
integer x = 1646
integer y = 1332
integer width = 347
integer height = 148
integer taborder = 90
boolean bringtotop = true
string text = "<< Revoke"
end type

event clicked;call super::clicked;IF F_OBJECT_ROLE_CHECK() = FALSE THEN  RETURN
STRING IVS_USER_ID , IVS_ROLE_CODE
int i

if dw_1.getrow() < 1 then 
	return
end if

if dw_2.getrow() < 1 then 
	return
end if
IVS_ROLE_CODE =  dw_2.object.role_code[dw_2.getrow()]
MSG = F_MSGBOX2( 187 , IVS_ROLE_CODE , 'USERS' ) //MSG = ("Confirm" ,"Revoke Role To User ID : " + IVS_USER_ID+' Role Code : '+IVS_ROLE_CODE  , QUESTION! , YESNO! )
IF MSG = 1 THEN 
ELSE
	RETURN
END IF
SETPOINTER(HOURGLASS!)


do
	
	i++
	if dw_1.object.check_yn[i] = 'Y' then 
		
		IVS_USER_ID = dw_1.object.user_id[i]

	else
		continue 
	end if

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

     DELETE FROM ISYS_privilege
	   WHERE USER_ID LIKE  :IVS_USER_ID
		  AND ROLE_CODE = :IVS_ROLE_CODE
		  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID
		  AND  ROLE_TYPE = 'N' ;  //NORMAL ROLE
	 
	 IF F_SQL_CHECK() < 0 THEN 
		 RETURN
	 END IF
	 
loop until i = dw_1.rowcount( )


	 
Msg= F_MSGBOX1( 9014 , STRING(SQLCA.SQLNROWS)+'  '  ) //@ $$HEX18$$74ac74c7200018c215c8200018b4c8c5b5c2c8b2e4b2200000c8a5c7200060d54cae94c6$$ENDHEX$$
IF MSG = 1 THEN 
	COMMIT ;
ELSE
	ROLLBACK;
END IF
end event

type sle_1 from so_singlelineedit within w_user_role_group_popup
integer x = 704
integer y = 420
integer width = 640
integer taborder = 40
boolean bringtotop = true
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

LVS_COLUMN = 'DEPARTMENT_CODE'

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

dw_1.SETFILTER('')
dw_1.FILTER()

IF THIS.TEXT = '' THEN 
	LVS_VALUE = '%'
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

dw_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found" )
end event

type st_1 from so_statictext within w_user_role_group_popup
integer x = 713
integer y = 336
integer width = 640
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Department Code"
end type

type gb_1 from so_groupbox within w_user_role_group_popup
integer x = 1385
integer y = 208
integer width = 910
integer height = 336
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_user_role_group_popup
integer x = 5
integer y = 220
integer width = 1376
integer height = 336
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

