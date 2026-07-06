HA$PBExportHeader$uo_customer_code_name.sru
forward
global type uo_customer_code_name from dropdownlistbox
end type
end forward

global type uo_customer_code_name from dropdownlistbox
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
global uo_customer_code_name uo_customer_code_name

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

public function string getname ();RETURN TRIM(MID( THIS.TEXT ,  POS( THIS.TEXT , ':' ) +1 , 30  ))
end function

public subroutine redraw (string arg_org);this.reset()

STRING LVS_DEPT_CODE , LVS_DEPT_NAME

DECLARE CUR_01 CURSOR FOR 
	SELECT DEPARTMENT_CODE, DECODE( :GVS_LANGUAGE , 'C' , DEPARTMENT_NAME_LOCAL , 'K' , DEPARTMENT_NAME_KOR , 'E' , DEPARTMENT_NAME_ENG ) 
  	  FROM ISYS_DEPARTMENT
	 WHERE ORGANIZATION_ID like :arg_org || '%' 	 ;
		 
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

on uo_customer_code_name.create
end on

on uo_customer_code_name.destroy
end on

event constructor;STRING LVS_user_id , LVS_user_name

DECLARE CUR_01 CURSOR FOR 
	SELECT CUSTOMER_CODE , CUSTOMER_NAME
  	  FROM ICOM_CUSTOMER
	 WHERE CUSTOMER_CODE <> '*'
	     AND BUSINESS_TYPE <> 'H'
	     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
		 
OPEN CUR_01 ;

	IF F_SQL_CHECK_WITH_MSG('OPEN FROM ICOM_CUSTOMER') < 0 THEN 
		CLOSE CUR_01 ;
		RETURN
	END IF	

DO 
	FETCH CUR_01 INTO :LVS_user_id , :LVS_user_name ;
	
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM ICOM_CUSTOMER') < 0 THEN 
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

event rbuttondown;OPEN(W_COM_CUSTOMER_POPUP)

IF MESSAGE.STRINGPARM = '' THEN 
ELSE
	THIS.TEXT = MESSAGE.STRINGPARM 
END IF
end event

