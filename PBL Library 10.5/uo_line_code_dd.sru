HA$PBExportHeader$uo_line_code_dd.sru
$PBExportComments$Line ddlb Object
forward
global type uo_line_code_dd from dropdownlistbox
end type
end forward

global type uo_line_code_dd from dropdownlistbox
integer width = 631
integer height = 832
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean autohscroll = true
boolean sorted = false
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type
global uo_line_code_dd uo_line_code_dd

forward prototypes
public function string text ()
public subroutine selectitem (string arg_text)
public function string getcode ()
public function string getname ()
public subroutine redraw ()
end prototypes

public function string text ();RETURN THIS.TEXT
end function

public subroutine selectitem (string arg_text);INT LVI_RETURN
LVI_RETURN = THIS.SELECTITEM( ARG_TEXT , 0 )


	

end subroutine

public function string getcode ();IF  POS( THIS.TEXT , ':' ) <= 0  THEN 
	RETURN	THIS.TEXT
ELSE
 
RETURN TRIM(MID( THIS.TEXT,  1, POS( THIS.TEXT , ':' ) -1 ))

END IF


//RETURN TRIM(MID( THIS.TEXT ,  POS( THIS.TEXT , ':' ) +1 , 100  ))
end function

public function string getname ();//IF  POS( THIS.TEXT , ':' ) <= 0  THEN 
//	RETURN	THIS.TEXT
//ELSE
// 
//          RETURN TRIM(MID( THIS.TEXT,  1, POS( THIS.TEXT , ':' ) -1 ))
//
//END IF

//
RETURN TRIM(MID( THIS.TEXT ,  POS( THIS.TEXT , ':' ) +1 , 10  ))
end function

public subroutine redraw ();LONG I
STRING LVS_LINE_CODE , LVS_LINE_NAME 

DECLARE CUR_01 CURSOR FOR 
	SELECT LINE_CODE, LINE_NAME
  	  FROM  IP_PRODUCT_LINE
	 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
	      AND LINE_CODE <> '*'
	      ORDER BY MES_DISPLAY_SEQUENCE ;
	 
OPEN CUR_01 ;

THIS.RESET()
THIS.ADDITEM('%')

IF F_SQL_CHECK_WITH_MSG('OPEN FROM IP_PRODUCT_LINE') < 0 THEN 
	CLOSE CUR_01 ;

END IF	

DO 
	FETCH CUR_01 INTO :LVS_LINE_CODE , :LVS_LINE_NAME ;
	
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM IP_PRODUCT_LINE') < 0 THEN 
		CLOSE CUR_01 ;

	END IF	
	
	IF SQLCA.SQLCODE = 100 THEN 
		CLOSE CUR_01 ;		
		EXIT
	END IF 
	
	LVS_LINE_CODE = LVS_LINE_CODE+':' + LVS_LINE_NAME
	THIS.ADDITEM(LVS_LINE_CODE)
I++
F_MSG_MDI_HELP('UO_LINE_CODE : Construnctor-> '+STRING(I)+"Rows")  			
LOOP UNTIL 1 = 2
THIS.Selectitem( 1)




end subroutine

event constructor;LONG I
STRING LVS_LINE_CODE , LVS_LINE_NAME , LVS_LINE_CODE_CONDITION

DECLARE CUR_01 CURSOR FOR 
	SELECT LINE_CODE, LINE_NAME
  	  FROM  IP_PRODUCT_LINE
	 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
	      AND LINE_CODE <> '*'
	      ORDER BY MES_DISPLAY_SEQUENCE  ;
	 
OPEN CUR_01 ;

THIS.RESET()
THIS.ADDITEM('%')

IF F_SQL_CHECK_WITH_MSG('OPEN FROM IP_PRODUCT_LINE') < 0 THEN 
	CLOSE CUR_01 ;
	RETURN
END IF	

DO 
	FETCH CUR_01 INTO :LVS_LINE_CODE , :LVS_LINE_NAME ;
	
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM IP_PRODUCT_LINE') < 0 THEN 
		CLOSE CUR_01 ;
		RETURN
	END IF	
	
	IF SQLCA.SQLCODE = 100 THEN 
		CLOSE CUR_01 ;		
		EXIT
	END IF 
	
	LVS_LINE_CODE = LVS_LINE_CODE+':' + LVS_LINE_NAME
	THIS.ADDITEM(LVS_LINE_CODE)
I++
F_MSG_MDI_HELP('UO_LINE_CODE : Construnctor-> '+STRING(I)+"Rows")  			
LOOP UNTIL 1 = 2
 THIS.Selectitem( 1)





end event

on uo_line_code_dd.create
end on

on uo_line_code_dd.destroy
end on

