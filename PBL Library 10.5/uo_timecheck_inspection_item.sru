HA$PBExportHeader$uo_timecheck_inspection_item.sru
forward
global type uo_timecheck_inspection_item from dropdownlistbox
end type
type st_vendor from structure within uo_timecheck_inspection_item
end type
end forward

type st_vendor from structure
	string		vendor_name
	string		vendor_name_eng
end type

global type uo_timecheck_inspection_item from dropdownlistbox
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
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
event type string getitem ( )
event redraw ( string arg_model )
end type
global uo_timecheck_inspection_item uo_timecheck_inspection_item

forward prototypes
public function string text ()
public subroutine settext (double arg_text)
public function string getcode ()
public subroutine redraw (string arg_model)
end prototypes

public function string text ();RETURN THIS.TEXT
end function

public subroutine settext (double arg_text);THIS.SELECTITEM(THIS.ADDITEM(STRING(ARG_TEXT)))

end subroutine

public function string getcode ();
long   lvl_x
string lvs_code

lvl_x           = pos( this.text, ']', 2 )
lvs_code     = mid( this.text, 2, lvl_x -2)

return lvs_code
end function

public subroutine redraw (string arg_model);

STRING LVS_MODEL

 DECLARE CL1 CURSOR FOR
 SELECT  '['||to_char(display_seq)||'] '||inspection_item
   FROM IQC_INSPECTION_TEMPLATE
 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
     AND  INSPECT_GROUP   = :arg_model
 ORDER BY display_seq;
 
	
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

on uo_timecheck_inspection_item.create
end on

on uo_timecheck_inspection_item.destroy
end on

