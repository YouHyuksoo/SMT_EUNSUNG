HA$PBExportHeader$uo_timecheck_customer.sru
forward
global type uo_timecheck_customer from dropdownlistbox
end type
type st_vendor from structure within uo_timecheck_customer
end type
end forward

type st_vendor from structure
	string		vendor_name
	string		vendor_name_eng
end type

global type uo_timecheck_customer from dropdownlistbox
integer width = 850
integer height = 692
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean allowedit = true
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
event type string getitem ( )
end type
global uo_timecheck_customer uo_timecheck_customer

forward prototypes
public function string text ()
public subroutine settext (double arg_text)
public function string getcode ()
public subroutine redraw (string arg_customer)
end prototypes

public function string text ();RETURN THIS.TEXT
end function

public subroutine settext (double arg_text);THIS.SELECTITEM(THIS.ADDITEM(STRING(ARG_TEXT)))

end subroutine

public function string getcode ();
string lvs_code

IF  POS( upper(THIS.TEXT) , '@' ) <= 0  THEN 
	RETURN	THIS.TEXT
ELSE
 
    lvs_code = TRIM(MID( upper(THIS.TEXT),  POS( upper(THIS.TEXT) , '@' ) +2, 50 ))
	RETURN lvs_code

END IF
end function

public subroutine redraw (string arg_customer);
STRING LVS_CUSTOMER

 DECLARE CL1 CURSOR FOR
    SELECT distinct m.customer_name||' @ '||m.customer_code    
     FROM IQC_INSPECTION_TEMPLATE T,
              ip_product_model_master M              
    WHERE t.inspect_group   = m.item_code 
          and t.ORGANIZATION_ID = m.ORGANIZATION_ID ;
 
	
 THIS.RESET()
 OPEN CL1;
 
 
 DO 
	
      FETCH CL1 INTO :LVS_CUSTOMER ;
 
      IF F_SQL_CHECK() < 0 THEN 
	     CLOSE CL1 ;
	     RETURN 
      END IF
 
      IF SQLCA.SQLCODE = 100 THEN 
	     CLOSE CL1 ;
	     EXIT
      END IF
 
      THIS.ADDITEM( LVS_CUSTOMER ) 
		
		
 LOOP UNTIL 1 = 2
 
end subroutine

event constructor;
redraw( '%' )
end event

on uo_timecheck_customer.create
end on

on uo_timecheck_customer.destroy
end on

