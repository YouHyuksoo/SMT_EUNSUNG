HA$PBExportHeader$uo_customer_code.sru
forward
global type uo_customer_code from dropdownlistbox
end type
type st_customer from structure within uo_customer_code
end type
end forward

type st_customer from structure
	string		customer_name
	string		customer_name_eng
end type

global type uo_customer_code from dropdownlistbox
integer width = 457
integer height = 676
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean allowedit = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
event ue_editchange pbm_cbneditchange
end type
global uo_customer_code uo_customer_code

event ue_editchange;if Len(this.text) = 0 then
else
		openwithparm(w_customer_search_flat , this.text)
		this.text = message.stringparm
end if 

end event

event constructor;STRING LVS_CUSTOMER

DECLARE CL1 CURSOR FOR
SELECT CUSTOMER_CODE FROM ICOM_CUSTOMER
 WHERE TRUNC(DATESET) <= TRUNC(SYSDATE)
   AND TRUNC(DATEEND) >= TRUNC(SYSDATE)
   AND CUSTOMER_CODE <> '*'
   AND BUSINESS_TYPE <> 'H'
   AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	
 THIS.RESET()
 THIS.ADDITEM('%') 
 OPEN CL1;
 
 IF F_SQL_CHECK() < 0 THEN 
	 CLOSE CL1 ;
	 RETURN 
 END IF
 
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
THIS.SELECTITEM( 1)
end event

event selectionchanged;select customer_name into :message.stringparm
from icom_customer 
where customer_code= :this.text 
    and organization_id = :gvi_organization_id ;

if f_sql_check() < 0 then 
	
end if








end event

event rbuttondown;openWITHPARM(w_com_customer_popup , 'S') 
this.text = message.stringparm
end event

on uo_customer_code.create
end on

on uo_customer_code.destroy
end on

event dragdrop;DATAWINDOW ldw_Source 

IF source.TypeOf() = DataWindow! THEN

        ldw_Source = source
		  
	END IF
	
IF 	ldw_Source.GETCOLUMNNAME() = 'customer_id' THEN 
	

	THIS.TEXT =  STRING(ldw_Source.OBJECT.customer_id[ldw_Source.getrow()] )
	
END IF

THIS.DRAG(END!)
end event

