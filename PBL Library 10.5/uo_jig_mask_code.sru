HA$PBExportHeader$uo_jig_mask_code.sru
$PBExportComments$Line ddlb Object
forward
global type uo_jig_mask_code from dropdownlistbox
end type
end forward

global type uo_jig_mask_code from dropdownlistbox
integer width = 631
integer height = 832
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean allowedit = true
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type
global uo_jig_mask_code uo_jig_mask_code

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
end function

public function string getname ();RETURN TRIM(MID( THIS.TEXT ,  POS( THIS.TEXT , ':' ) +1 , 1  ))
end function

public subroutine redraw ();LONG I
STRING LVS_MACHINE_CODE , LVS_MACHINE_NAME , LVS_MACHINE_CODE_CONDITION

IF  POS( THIS.TEXT , ':' ) <= 0  THEN 
	LVS_MACHINE_CODE_CONDITION =	THIS.TEXT
ELSE
 
LVS_MACHINE_CODE_CONDITION = TRIM(MID( THIS.TEXT,  1, POS( THIS.TEXT , ':' ) -1 ))

END IF

IF THIS.TEXT = '%' THEN RETURN

DECLARE CUR_01 CURSOR FOR 
  SELECT "IMCN_MACHINE"."MACHINE_CODE",   
         "IMCN_MACHINE"."MACHINE_NAME"
    FROM "IMCN_MACHINE"  
   WHERE "IMCN_MACHINE"."ORGANIZATION_ID" = :GVI_ORGANIZATION_ID    ;

	 
OPEN CUR_01 ;

THIS.RESET()
THIS.ADDITEM('%')

IF F_SQL_CHECK_WITH_MSG('OPEN FROM IP_PRODUCT_WORKSTAGE') < 0 THEN 
	CLOSE CUR_01 ;
	RETURN
END IF	

DO 
	FETCH CUR_01 INTO :LVS_MACHINE_CODE , :LVS_MACHINE_NAME ;
	
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM IP_PRODUCT_WORKSTAGE') < 0 THEN 
		CLOSE CUR_01 ;
		RETURN
	END IF	
	
	IF SQLCA.SQLCODE = 100 THEN 
		CLOSE CUR_01 ;		
		EXIT
	END IF 
	
	LVS_MACHINE_CODE = LVS_MACHINE_CODE + ' : ' + LVS_MACHINE_NAME
	THIS.ADDITEM(LVS_MACHINE_CODE)
I++
F_MSG_MDI_HELP('UO_MACHINE_CODE : Construnctor-> '+STRING(I)+"Rows")  			
LOOP UNTIL 1 = 2






end subroutine

event constructor;LONG I
STRING LVS_JIG_CODE , LVS_JIG_NAME 

DECLARE CUR_01 CURSOR FOR 
  SELECT "IMCN_JIG"."JIG_CODE",   
              "IMCN_JIG"."JIG_NAME"
    FROM "IMCN_JIG"  
   WHERE "IMCN_JIG"."ORGANIZATION_ID" = :GVI_ORGANIZATION_ID    
	  AND JIG_CODE <> '*'
	  AND JIG_TYPE = 'M';

OPEN CUR_01 ;

THIS.RESET()
THIS.ADDITEM('%')

IF F_SQL_CHECK_WITH_MSG('OPEN FROM IP_PRODUCT_WORKSTAGE') < 0 THEN 
	CLOSE CUR_01 ;
	RETURN
END IF	

DO 
	FETCH CUR_01 INTO :LVS_JIG_CODE , :LVS_JIG_NAME ;
	
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM IP_PRODUCT_WORKSTAGE') < 0 THEN 
		CLOSE CUR_01 ;
		RETURN
	END IF	
	
	IF SQLCA.SQLCODE = 100 THEN 
		CLOSE CUR_01 ;		
		EXIT
	END IF 
	
	LVS_JIG_CODE = LVS_JIG_CODE + ' : ' + LVS_JIG_NAME
	THIS.ADDITEM(LVS_JIG_CODE)
I++
F_MSG_MDI_HELP('UO_JIG_CODE : Construnctor-> '+STRING(I)+"Rows")  			
LOOP UNTIL 1 = 2

THIS.SELECTITEM( 1)





end event

on uo_jig_mask_code.create
end on

on uo_jig_mask_code.destroy
end on

event rbuttondown;OPEN( W_MCN_JIG_POPUP )

if message.stringparm = '' then 
else
	this.text = message.stringparm
end if
end event

