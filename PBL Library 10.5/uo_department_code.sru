HA$PBExportHeader$uo_department_code.sru
$PBExportComments$Method ( Text(return dept_code) , getdeptcode()  )
forward
global type uo_department_code from dropdownlistbox
end type
end forward

global type uo_department_code from dropdownlistbox
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
boolean allowedit = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type
global uo_department_code uo_department_code

forward prototypes
public function string text ()
public function string getcode ()
public function string getname ()
public subroutine redraw (string arg_org)
public subroutine setcode (string arg_code)
end prototypes

public function string text ();RETURN UPPER(THIS.TEXT)
end function

public function string getcode ();IF  POS( THIS.TEXT , ':' ) <= 0  THEN 
	RETURN	THIS.TEXT
ELSE
 
RETURN TRIM(MID( THIS.TEXT,  1, POS( THIS.TEXT , ':' ) -1 ))

END IF
end function

public function string getname ();RETURN TRIM(MID( THIS.TEXT ,  POS( THIS.TEXT , ':' ) +1 , 1  ))
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

	SELECT DEPARTMENT_CODE||' : '||DECODE( :GVS_LANGUAGE , 'E' ,DEPARTMENT_NAME_ENG , 'K' ,DEPARTMENT_NAME_KOR , 'C' , DEPARTMENT_NAME_LOCAL )  INTO :LVS_DEPT_CODE
  	  FROM ISYS_DEPARTMENT
	 WHERE DEPARTMENT_CODE =  :arg_code 
	     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
		  
     IF F_SQL_CHECK() < 0 THEN 
		RETURN 
	END IF
		  
THIS.TEXT =LVS_DEPT_CODE
end subroutine

on uo_department_code.create
end on

on uo_department_code.destroy
end on

event rbuttondown;OPEN(W_DEPARTMENT_POPUP)

IF MESSAGE.STRINGPARM = '' THEN 
ELSE
	THIS.TEXT = MESSAGE.STRINGPARM 
END IF
end event

event modified;LONG I
STRING LVS_DEPT_CODE , LVS_DEPT_NAME , LVS_DEPT_CODE_CONDITION

IF  POS( THIS.TEXT , ':' ) <= 0  THEN 
	LVS_DEPT_CODE_CONDITION =	THIS.TEXT
ELSE
 
LVS_DEPT_CODE_CONDITION = TRIM(MID( THIS.TEXT,  1, POS( THIS.TEXT , ':' ) -1 ))

END IF

IF THIS.TEXT = '%' THEN RETURN

DECLARE CUR_01 CURSOR FOR 
	SELECT DEPARTMENT_CODE, DECODE( :GVS_LANGUAGE , 'C' , DEPARTMENT_NAME_LOCAL , 'K' , DEPARTMENT_NAME_KOR , 'E' , DEPARTMENT_NAME_ENG ) 
  	  FROM ISYS_DEPARTMENT
	 WHERE DEPARTMENT_CODE LIKE :LVS_DEPT_CODE_CONDITION||'%'
	      AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	 
OPEN CUR_01 ;

THIS.RESET()
THIS.ADDITEM('%')

IF F_SQL_CHECK_WITH_MSG('OPEN FROM ISYS_DEPARTMENT') < 0 THEN 
	CLOSE CUR_01 ;
	RETURN
END IF	

DO 
	FETCH CUR_01 INTO :LVS_DEPT_CODE , :LVS_DEPT_NAME ;
	
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM ISYS_DEPARTMENT') < 0 THEN 
		CLOSE CUR_01 ;
		RETURN
	END IF	
	
	IF SQLCA.SQLCODE = 100 THEN 
		CLOSE CUR_01 ;		
		EXIT
	END IF 
	
	LVS_DEPT_CODE = LVS_DEPT_CODE + ' : ' + LVS_DEPT_NAME
	THIS.ADDITEM(LVS_DEPT_CODE)
I++
F_MSG_MDI_HELP('UO_DEPARTMENT_CODE : Construnctor-> '+STRING(I)+"Rows")  			
LOOP UNTIL 1 = 2
THIS.SELECTITEM(2)		 





end event

event constructor;IF GVS_DEPARTMENT_AUTO_SET = 'Y'  AND GVI_USER_LEVEL < 8 THEN 
	THIS.TEXT = GVS_DEPARTMENT_CODE
	TRIGGEREVENT('MODIFIED')
END IF
end event

