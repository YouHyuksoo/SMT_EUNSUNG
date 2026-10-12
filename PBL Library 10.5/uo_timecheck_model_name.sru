HA$PBExportHeader$uo_timecheck_model_name.sru
forward
global type uo_timecheck_model_name from dropdownlistbox
end type
type st_vendor from structure within uo_timecheck_model_name
end type
end forward

type st_vendor from structure
	string		vendor_name
	string		vendor_name_eng
end type

global type uo_timecheck_model_name from dropdownlistbox
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
global uo_timecheck_model_name uo_timecheck_model_name

forward prototypes
public function string text ()
public function string getcode ()
public function string getmodel ()
public subroutine redraw (string arg_customer)
public subroutine settext (string arg_text)
end prototypes

public function string text ();RETURN THIS.TEXT
end function

public function string getcode ();
long   lvl_x2, lvl_x1
string lvs_code

lvl_x1         = pos( this.text, '[', 2 )
lvl_x2         = pos( this.text, ']', 2 )
//lvs_code     = mid( this.text, 2, lvl_x -2)

lvl_x2         = lvl_x2 - lvl_x1 -1
lvs_code     = mid( this.text, lvl_x1+1, lvl_x2)

return lvs_code
end function

public function string getmodel ();
long   lvl_x
string lvs_code

lvl_x           = pos( this.text, ']', 2 )
lvs_code     = mid( this.text, lvl_x+1)

return lvs_code
end function

public subroutine redraw (string arg_customer);
STRING LVS_MODEL

 DECLARE CL1 CURSOR FOR
 SELECT inspect_group_desc|| '  ['||t.inspect_group||']'       //  SELECT  '['||t.inspect_group||'] '||t.inspect_group_desc
   FROM IQC_INSPECTION_TEMPLATE T,
	        ip_product_model_master     M
 WHERE t.inspect_group        = m.item_code 
      and t.ORGANIZATION_ID = m.ORGANIZATION_ID 
	 and T.ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
     and M.customer_code      = :arg_customer
 GROUP BY t.inspect_group, t.inspect_group_desc;
 //ORDER BY t.inspect_group_desc;
 
	
 THIS.RESET()
 OPEN CL1;
 
 
 DO 
	
      FETCH CL1 INTO :LVS_MODEL ;
 
      IF F_SQL_CHECK() < 0 THEN 
	     CLOSE CL1 ;
	     RETURN 
      END IF
 
      IF SQLCA.SQLCODE = 100 THEN 
	     CLOSE CL1 ;
	     EXIT
      END IF
 
      THIS.ADDITEM( LVS_MODEL ) 
		
		
 LOOP UNTIL 1 = 2
end subroutine

public subroutine settext (string arg_text);
 INT LVI_RETURN
LVI_RETURN = THIS.SELECTITEM( ARG_TEXT , 0 )

end subroutine

on uo_timecheck_model_name.create
end on

on uo_timecheck_model_name.destroy
end on

event constructor;
THIS.REdraw( '%' )
end event

event modified;
THIS.TEXT = UPPER(THIS.TEXT)
end event

