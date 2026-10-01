HA$PBExportHeader$uo_timecheck_model_name2.sru
forward
global type uo_timecheck_model_name2 from dropdownlistbox
end type
end forward

global type uo_timecheck_model_name2 from dropdownlistbox
integer width = 809
integer height = 1608
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
boolean allowedit = true
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type
global uo_timecheck_model_name2 uo_timecheck_model_name2

forward prototypes
public function string text ()
public subroutine selectitem (string arg_text)
public function string getcode ()
public function string getname ()
public subroutine redraw (string arg_model_name)
public subroutine redraw_customer (string arg_customer)
end prototypes

public function string text ();RETURN UPPER(THIS.TEXT)
end function

public subroutine selectitem (string arg_text);INT LVI_RETURN
LVI_RETURN = THIS.SELECTITEM( ARG_TEXT , 0 )

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

public function string getname ();string lvs_name

IF  POS( upper(THIS.TEXT) , '@' ) <= 0  THEN 
	RETURN	THIS.TEXT
ELSE
 
    lvs_name = TRIM(MID( upper(THIS.TEXT),  1, POS( upper(THIS.TEXT) , '@' ) -2 ))
	RETURN lvs_name

END IF
end function

public subroutine redraw (string arg_model_name);LONG I
STRING LVS_MODEL_NAME  

 
  DECLARE CUR_01 CURSOR FOR
 SELECT inspect_group_desc|| ' @ '||t.inspect_group
   FROM IQC_INSPECTION_TEMPLATE T,
	        ip_product_model_master     M
 WHERE t.inspect_group        = m.item_code 
      and t.ORGANIZATION_ID = m.ORGANIZATION_ID 
	 and T.ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
     and T.inspect_group_desc  like :arg_model_name
 GROUP BY t.inspect_group, t.inspect_group_desc;
 
	
	
OPEN CUR_01 ;

THIS.RESET()
//THIS.ADDITEM('%')

IF F_SQL_CHECK_WITH_MSG('OPEN FROM IQC_INSPECTION_TEMPLATE') < 0 THEN 
	CLOSE CUR_01 ;
	RETURN
END IF	

DO 
	FETCH CUR_01 INTO :LVS_MODEL_NAME  ;
	
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM IQC_INSPECTION_TEMPLATE') < 0 THEN 
		CLOSE CUR_01 ;
		RETURN
	END IF	
	
	IF SQLCA.SQLCODE = 100 THEN 
		CLOSE CUR_01 ;		
		EXIT
	END IF 
	
	
	THIS.ADDITEM(LVS_MODEL_NAME)

     I++

    F_MSG_MDI_HELP('UO_MODEL_NAME : Construnctor -> '+STRING(I)+"Rows")  			

LOOP UNTIL 1 = 2

THIS.SELECTITEM( 1)





end subroutine

public subroutine redraw_customer (string arg_customer);LONG I
STRING LVS_MODEL_NAME  

 
  DECLARE CUR_01 CURSOR FOR
 SELECT inspect_group_desc|| ' @ '||t.inspect_group
   FROM IQC_INSPECTION_TEMPLATE T,
	        ip_product_model_master     M
 WHERE t.inspect_group        = m.item_code 
      and t.ORGANIZATION_ID = m.ORGANIZATION_ID 
	 and T.ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
     and M.customer_code      like :arg_customer
 GROUP BY t.inspect_group, t.inspect_group_desc;
 
	
	
OPEN CUR_01 ;

THIS.RESET()
//THIS.ADDITEM('%')

IF F_SQL_CHECK_WITH_MSG('OPEN FROM IQC_INSPECTION_TEMPLATE') < 0 THEN 
	CLOSE CUR_01 ;
	RETURN
END IF	

DO 
	FETCH CUR_01 INTO :LVS_MODEL_NAME  ;
	
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM IQC_INSPECTION_TEMPLATE') < 0 THEN 
		CLOSE CUR_01 ;
		RETURN
	END IF	
	
	IF SQLCA.SQLCODE = 100 THEN 
		CLOSE CUR_01 ;		
		EXIT
	END IF 
	
	
	THIS.ADDITEM(LVS_MODEL_NAME)

     I++

    F_MSG_MDI_HELP('UO_MODEL_NAME : Construnctor -> '+STRING(I)+"Rows")  			

LOOP UNTIL 1 = 2

THIS.SELECTITEM( 1)





end subroutine

on uo_timecheck_model_name2.create
end on

on uo_timecheck_model_name2.destroy
end on

event rbuttondown;OPEN(w_des_set_item_popup  )

if message.stringparm = '' then 
else
	this.text = Gst_return.Gvs_return[9]
end if
end event

event modified;//THIS.TEXT = UPPER(THIS.TEXT)

end event

event constructor;//THIS.REdraw( '%' )
end event

