HA$PBExportHeader$uo_product_line_code.sru
$PBExportComments$Line ddlb Object
forward
global type uo_product_line_code from dropdownlistbox
end type
end forward

global type uo_product_line_code from dropdownlistbox
integer width = 631
integer height = 832
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type
global uo_product_line_code uo_product_line_code

forward prototypes
public function string text ()
public subroutine selectitem (string arg_text)
end prototypes

public function string text ();RETURN THIS.TEXT
end function

public subroutine selectitem (string arg_text);INT LVI_RETURN
LVI_RETURN = THIS.SELECTITEM( ARG_TEXT , 0 )

end subroutine

event constructor;STRING LVS_LINE_CODE

DECLARE CL1 CURSOR FOR
SELECT LINE_CODE FROM IP_PRODUCT_LINE
 WHERE LINE_CODE <> '*'
     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
 
 THIS.RESET()
 THIS.ADDITEM('%') 
 OPEN CL1;
 
 DO 
 FETCH CL1 INTO :LVS_LINE_CODE ;
 
 IF F_SQL_CHECK() < 0 THEN 
	 CLOSE CL1 ;
	 RETURN 
 END IF
 
 IF SQLCA.SQLCODE = 100 THEN 
	 CLOSE CL1 ;
	 EXIT
 END IF
 
      THIS.ADDITEM( LVS_LINE_CODE ) 
   	THIS.SELECTITEM(1)		
		
LOOP UNTIL 1 = 2
end event

on uo_product_line_code.create
end on

on uo_product_line_code.destroy
end on

