HA$PBExportHeader$uo_user_id_name_by_department.sru
forward
global type uo_user_id_name_by_department from dropdownlistbox
end type
end forward

global type uo_user_id_name_by_department from dropdownlistbox
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
global uo_user_id_name_by_department uo_user_id_name_by_department

forward prototypes
public function string text ()
public function string getcode ()
public function string getname ()
public subroutine setcode (string arg_code)
public subroutine redraw (string arg_dept_condition)
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

public subroutine redraw (string arg_dept_condition);this.reset()

STRING LVS_DEPT_CODE , LVS_DEPT_NAME

DECLARE CUR_01 CURSOR FOR 
	SELECT USER_ID , USER_NAME
  	  FROM ISYS_USERS
	 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
	     AND DEPARTMENT_CODE 
		  IN ( SELECT DEPARTMENT_CODE FROM ISYS_DEPARTMENT 
		         WHERE DEPARTMENT_CODE 
					IN ( SELECT CODE_MEAN_LOCAL FROM ISYS_BASECODE 
					       WHERE CODE_TYPE ='USER DEPT CONDITION'
							 AND CODE_NAME LIKE :ARG_DEPT_CONDITION ) 
                 )	 ;
		 
OPEN CUR_01 ;

DO WHILE SQLCA.SQLCODE = 0 
	FETCH CUR_01 INTO :LVS_DEPT_CODE , :LVS_DEPT_NAME ;
	
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM ISYS_DEPARTMENT') < 0 THEN 
		CLOSE CUR_01 ;
		RETURN
	END IF	
	
	IF SQLCA.SQLCODE = 100 THEN 
		EXIT
	END IF 
	
	LVS_DEPT_CODE = LVS_DEPT_CODE + ' : ' + LVS_DEPT_NAME
	THIS.ADDITEM(LVS_DEPT_CODE)
LOOP

THIS.ADDITEM('%')

THIS.SELECTITEM(1)
CLOSE CUR_01 ;



end subroutine

on uo_user_id_name_by_department.create
end on

on uo_user_id_name_by_department.destroy
end on

event rbuttondown;OPEN(W_USER_POPUP)

IF MESSAGE.STRINGPARM = '' THEN 
ELSE
	THIS.TEXT = MESSAGE.STRINGPARM 
END IF
end event

