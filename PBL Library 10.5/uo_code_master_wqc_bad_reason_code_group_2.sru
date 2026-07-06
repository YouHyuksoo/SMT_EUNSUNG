HA$PBExportHeader$uo_code_master_wqc_bad_reason_code_group_2.sru
forward
global type uo_code_master_wqc_bad_reason_code_group_2 from dropdownlistbox
end type
type st_vendor from structure within uo_code_master_wqc_bad_reason_code_group_2
end type
end forward

type st_vendor from structure
	string		vendor_name
	string		vendor_name_eng
end type

global type uo_code_master_wqc_bad_reason_code_group_2 from dropdownlistbox
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
end type
global uo_code_master_wqc_bad_reason_code_group_2 uo_code_master_wqc_bad_reason_code_group_2

forward prototypes
public function string text ()
public subroutine settext (double arg_text)
public subroutine redraw (string arg_codegroup)
end prototypes

public function string text ();RETURN THIS.TEXT
end function

public subroutine settext (double arg_text);THIS.SELECTITEM(THIS.ADDITEM(STRING(ARG_TEXT)))

end subroutine

public subroutine redraw (string arg_codegroup);STRING LVS_VALUE

DECLARE CL1 CURSOR FOR
SELECT DISTINCT CODE_GROUP_SECOND
  FROM ISYS_CODE_MASTER
 WHERE CODE_TYPE = 'WQC BAD REASON CODE'
     AND  CODE_GROUP like :arg_codegroup
     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;

	
 THIS.RESET()
 THIS.ADDITEM('%') 
 OPEN CL1;
 
 DO 
 FETCH CL1 INTO :LVS_VALUE ;
 
 IF F_SQL_CHECK() < 0 THEN 
	 CLOSE CL1 ;
	 RETURN 
 END IF
 
 IF SQLCA.SQLCODE = 100 THEN 
	 CLOSE CL1 ;
	 EXIT
 END IF
 
      THIS.ADDITEM( LVS_VALUE ) 

LOOP UNTIL 1 = 2
end subroutine

event constructor;STRING LVS_VALUE

DECLARE CL1 CURSOR FOR
SELECT DISTINCT CODE_GROUP_SECOND
  FROM ISYS_CODE_MASTER
 WHERE CODE_TYPE = 'WQC BAD REASON CODE'
     AND  CODE_GROUP like '%'
     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;

	
 THIS.RESET()
 THIS.ADDITEM('%') 
 OPEN CL1;
 
 DO 
 FETCH CL1 INTO :LVS_VALUE ;
 
 IF F_SQL_CHECK() < 0 THEN 
	 CLOSE CL1 ;
	 RETURN 
 END IF
 
 IF SQLCA.SQLCODE = 100 THEN 
	 CLOSE CL1 ;
	 EXIT
 END IF
 
      THIS.ADDITEM( LVS_VALUE ) 

LOOP UNTIL 1 = 2
end event

on uo_code_master_wqc_bad_reason_code_group_2.create
end on

on uo_code_master_wqc_bad_reason_code_group_2.destroy
end on

