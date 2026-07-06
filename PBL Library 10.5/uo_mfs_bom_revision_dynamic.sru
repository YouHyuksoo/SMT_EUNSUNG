HA$PBExportHeader$uo_mfs_bom_revision_dynamic.sru
forward
global type uo_mfs_bom_revision_dynamic from dropdownlistbox
end type
type st_vendor from structure within uo_mfs_bom_revision_dynamic
end type
end forward

type st_vendor from structure
	string		vendor_name
	string		vendor_name_eng
end type

global type uo_mfs_bom_revision_dynamic from dropdownlistbox
integer width = 626
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
end type
global uo_mfs_bom_revision_dynamic uo_mfs_bom_revision_dynamic

forward prototypes
public function string text ()
public subroutine settext (double arg_text)
public function string getcode ()
public function string redraw (string arg_item_code)
end prototypes

public function string text ();RETURN THIS.TEXT
end function

public subroutine settext (double arg_text);THIS.SELECTITEM(THIS.ADDITEM(STRING(ARG_TEXT)))

end subroutine

public function string getcode ();IF  POS( THIS.TEXT , ':' ) <= 0  THEN 
	RETURN	THIS.TEXT
ELSE
 
RETURN TRIM(MID( THIS.TEXT,  1, POS( THIS.TEXT , ':' ) -1 ))

END IF
end function

public function string redraw (string arg_item_code);STRING LVS_MFS

DECLARE CL1 CURSOR FOR

SELECT REVISION FROM 
( 
SELECT MAX(MFS) REVISION
 FROM ID_MFS_BOM
WHERE ITEM_CODE = :ARG_ITEM_CODE
   AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID
GROUP BY ITEM_CODE , MFS 
) 
ORDER BY  REVISION DESC ;
	
 THIS.RESET()
 OPEN CL1;
 
 DO 
 FETCH CL1 INTO :LVS_MFS ;
 
	 IF F_SQL_CHECK() < 0 THEN 
		 CLOSE CL1 ;
		 RETURN '*'
	 END IF
	 
	 IF SQLCA.SQLCODE = 100 THEN 
		 CLOSE CL1 ;
		 EXIT
	 END IF
 
	THIS.ADDITEM( LVS_MFS ) 
	THIS.SELECTITEM(1)				
		
LOOP UNTIL 1 = 2

THIS.SELECTITEM( 1)
end function

on uo_mfs_bom_revision_dynamic.create
end on

on uo_mfs_bom_revision_dynamic.destroy
end on

