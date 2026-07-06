HA$PBExportHeader$uo_item_4_location.sru
$PBExportComments$Item Type
forward
global type uo_item_4_location from dropdownlistbox
end type
end forward

global type uo_item_4_location from dropdownlistbox
integer width = 731
integer height = 904
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "Help!"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type
global uo_item_4_location uo_item_4_location

forward prototypes
public function string text ()
public function string getcode ()
public function string getname ()
public subroutine setcode (string arg_code)
public subroutine redraw (string arg_item, string arg_location)
end prototypes

public function string text ();RETURN THIS.TEXT
end function

public function string getcode ();RETURN TRIM(MID( THIS.TEXT,  1, POS( THIS.TEXT , ':' ) -1 ))
end function

public function string getname ();RETURN TRIM(MID( THIS.TEXT ,  POS( THIS.TEXT , ':' ) +1 , 1  ))
end function

public subroutine setcode (string arg_code);THIS.TEXT = ARG_CODE
end subroutine

public subroutine redraw (string arg_item, string arg_location);STRING LVS_ITEM_CODE 


//MESSAGEBOX(arg_item, arg_location)

DECLARE CL1 CURSOR FOR
   SELECT  
               x.CHILD_ITEM_CODE||':'|| y.ITEM_NAME 
          FROM ( 

                  SELECT     
                               LEVEL bom_level, 
                               child_item_code, 
                               location_info,
                               item_type
                          FROM id_eng_bom
                         WHERE dateset <= sysdate
                           AND NVL (dateend, (sysdate+1)) >= sysdate
                           AND organization_id = :gvi_organization_id
                    START WITH child_item_code = :arg_item  
                           AND parent_item_code =
                                  (SELECT MAX (parent_item_code)
                                     FROM id_eng_bom
                                    WHERE child_item_code = :arg_item 
                                      AND dateset <= sysdate
                                      AND NVL (dateend, (sysdate+1)) >= sysdate
                                      AND organization_id =  :gvi_organization_id)
                           AND dateset <= sysdate
                           AND NVL (dateend, (sysdate+1)) >= sysdate
                           AND organization_id =  :gvi_organization_id
                    CONNECT BY PRIOR child_item_code = parent_item_code
                           AND dateset <= sysdate
                           AND NVL (dateend, (sysdate+1)) >= sysdate
                           AND NVL (assy_explosion_yn, 'N') = 'Y'
                           AND organization_id = :gvi_organization_id
                   
                 ) x, ID_ITEM y 
       WHERE instr(location_info, :arg_location) > 0 
          and x.child_item_code = y.item_code(+)
;
		


OPEN CL1;

THIS.RESET()
DO 
 FETCH CL1 INTO :LVS_ITEM_CODE ;
 
 IF F_SQL_CHECK() < 0 THEN 
	 CLOSE CL1 ;
	 RETURN 
 END IF
 
 IF SQLCA.SQLCODE = 100 THEN 
	 CLOSE CL1 ;
	 EXIT
 END IF
 
      THIS.ADDITEM( LVS_ITEM_CODE ) 
	 THIS.SELECTITEM(1)	
		
LOOP UNTIL 1 = 2
end subroutine

on uo_item_4_location.create
end on

on uo_item_4_location.destroy
end on

