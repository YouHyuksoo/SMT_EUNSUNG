HA$PBExportHeader$uo_user_id_name_4_bring_in_out_confirm.sru
forward
global type uo_user_id_name_4_bring_in_out_confirm from dropdownlistbox
end type
end forward

global type uo_user_id_name_4_bring_in_out_confirm from dropdownlistbox
integer width = 608
integer height = 904
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "Help!"
long textcolor = 33554432
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type
global uo_user_id_name_4_bring_in_out_confirm uo_user_id_name_4_bring_in_out_confirm

forward prototypes
public function string text ()
public function string getcode ()
public function string getname ()
public subroutine redraw (string arg_org)
public subroutine setcode (string arg_code)
end prototypes

public function string text ();RETURN THIS.TEXT
end function

public function string getcode ();IF  POS( THIS.TEXT , ':' ) <= 0  THEN 
	RETURN	THIS.TEXT
ELSE
 
RETURN TRIM(MID( THIS.TEXT,  1, POS( THIS.TEXT , ':' ) -1 ))

END IF
end function

public function string getname ();RETURN TRIM(MID( THIS.TEXT ,  POS( THIS.TEXT , ':' ) +1 , 1  ))
end function

public subroutine redraw (string arg_org);STRING LVS_user_id , LVS_user_name

DECLARE CUR_01 CURSOR FOR 
	SELECT USER_ID , USER_NAME
  	  FROM ISYS_USERS
	 WHERE BRING_IN_OUT_MANAGER = 'Y'
	     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
		 
OPEN CUR_01 ;

	IF F_SQL_CHECK_WITH_MSG('OPEN FROM ISYS_USERS') < 0 THEN 
		CLOSE CUR_01 ;
		RETURN
	END IF	

DO 
	FETCH CUR_01 INTO :LVS_user_id , :LVS_user_name ;
	
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM ISYS_USERS') < 0 THEN 
		CLOSE CUR_01 ;
		RETURN
	END IF	
	
	IF SQLCA.SQLCODE = 100 THEN 
		CLOSE CUR_01 ;
		EXIT
	END IF 
	
	LVS_user_id = LVS_user_id + ' : ' + LVS_user_name
	THIS.ADDITEM(LVS_user_id)
LOOP UNTIL 1 = 2
CLOSE CUR_01;
THIS.ADDITEM('%')
THIS.SELECTITEM(1)




end subroutine

public subroutine setcode (string arg_code);STRING LVS_DEPT_CODE

	SELECT DEPARTMENT_CODE||' : '||DEPARTMENT_NAME INTO :LVS_DEPT_CODE
  	  FROM ISYS_DEPARTMENT
	 WHERE DEPARTMENT_CODE =  :arg_code 
	     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
		  
     IF F_SQL_CHECK() < 0 THEN 
		RETURN 
	END IF
		  
THIS.TEXT =LVS_DEPT_CODE
end subroutine

on uo_user_id_name_4_bring_in_out_confirm.create
end on

on uo_user_id_name_4_bring_in_out_confirm.destroy
end on

event constructor;STRING LVS_user_id , LVS_user_name

DECLARE CUR_01 CURSOR FOR 
	SELECT USER_ID , USER_NAME
  	  FROM ISYS_USERS
	 WHERE BRING_IN_OUT_MANAGER = 'Y'
	     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
		 
OPEN CUR_01 ;

	IF F_SQL_CHECK_WITH_MSG('OPEN FROM ISYS_USERS') < 0 THEN 
		CLOSE CUR_01 ;
		RETURN
	END IF	

DO 
	FETCH CUR_01 INTO :LVS_user_id , :LVS_user_name ;
	
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM ISYS_USERS') < 0 THEN 
		CLOSE CUR_01 ;
		RETURN
	END IF	
	
	IF SQLCA.SQLCODE = 100 THEN 
		CLOSE CUR_01 ;
		EXIT
	END IF 
	
	LVS_user_id = LVS_user_id + ' : ' + LVS_user_name
	THIS.ADDITEM(LVS_user_id)
LOOP UNTIL 1 = 2
CLOSE CUR_01;
THIS.ADDITEM('%')
THIS.SELECTITEM(1)




end event

event rbuttondown;OPEN(W_USER_POPUP)

IF MESSAGE.STRINGPARM = '' THEN 
ELSE
	THIS.TEXT = MESSAGE.STRINGPARM 
END IF
end event

