HA$PBExportHeader$w_des_raw_bom_master.srw
$PBExportComments$$$HEX3$$d0c6e8b204c7$$ENDHEX$$BOM$$HEX2$$00adacb9$$ENDHEX$$
forward
global type w_des_raw_bom_master from w_main_root
end type
type uo_parent_item from uo_item_code within w_des_raw_bom_master
end type
type st_5 from so_statictext within w_des_raw_bom_master
end type
type st_14 from so_statictext within w_des_raw_bom_master
end type
type sle_item_name from so_singlelineedit within w_des_raw_bom_master
end type
type uo_child_item from uo_item_code within w_des_raw_bom_master
end type
type st_1 from so_statictext within w_des_raw_bom_master
end type
type rb_raw_bom from so_radiobutton within w_des_raw_bom_master
end type
type cb_1 from so_commandbutton within w_des_raw_bom_master
end type
type cb_2 from so_commandbutton within w_des_raw_bom_master
end type
type gb_where_condition from groupbox within w_des_raw_bom_master
end type
type gb_1 from groupbox within w_des_raw_bom_master
end type
type gb_2 from groupbox within w_des_raw_bom_master
end type
end forward

global type w_des_raw_bom_master from w_main_root
integer width = 4736
integer height = 2904
string title = "Raw Bom Master"
uo_parent_item uo_parent_item
st_5 st_5
st_14 st_14
sle_item_name sle_item_name
uo_child_item uo_child_item
st_1 st_1
rb_raw_bom rb_raw_bom
cb_1 cb_1
cb_2 cb_2
gb_where_condition gb_where_condition
gb_1 gb_1
gb_2 gb_2
end type
global w_des_raw_bom_master w_des_raw_bom_master

type variables

end variables

on w_des_raw_bom_master.create
int iCurrent
call super::create
this.uo_parent_item=create uo_parent_item
this.st_5=create st_5
this.st_14=create st_14
this.sle_item_name=create sle_item_name
this.uo_child_item=create uo_child_item
this.st_1=create st_1
this.rb_raw_bom=create rb_raw_bom
this.cb_1=create cb_1
this.cb_2=create cb_2
this.gb_where_condition=create gb_where_condition
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_parent_item
this.Control[iCurrent+2]=this.st_5
this.Control[iCurrent+3]=this.st_14
this.Control[iCurrent+4]=this.sle_item_name
this.Control[iCurrent+5]=this.uo_child_item
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.rb_raw_bom
this.Control[iCurrent+8]=this.cb_1
this.Control[iCurrent+9]=this.cb_2
this.Control[iCurrent+10]=this.gb_where_condition
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.gb_2
end on

on w_des_raw_bom_master.destroy
call super::destroy
destroy(this.uo_parent_item)
destroy(this.st_5)
destroy(this.st_14)
destroy(this.sle_item_name)
destroy(this.uo_child_item)
destroy(this.st_1)
destroy(this.rb_raw_bom)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.gb_where_condition)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event activate;call super::activate;
/***************************************
* $$HEX17$$08c7c4b324c115c8d0c5200000ad5cd52000acc06dd544c720004bc105d35cd5e4b2$$ENDHEX$$
*
*
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20051101'
Gst_set.last_modify_date = '20051101'
Gst_set.Report_window    = False  // Report Window  True / Flase

/*****************************************
* Data WIndow Property
******************************************/
Ivs_resize_type    = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

/****************************************
* Menu Property $$HEX6$$54ba74b2200078d5e4b4c1b9$$ENDHEX$$
*****************************************
* ADMIN     : ADMIN  ( $$HEX5$$04c8b4ccacc0a9c62000$$ENDHEX$$)
* $$HEX8$$00adacb9200020002000200020002000$$ENDHEX$$: MANAGE ( $$HEX8$$04c854ba74b2acc0a9c600aca5b22000$$ENDHEX$$)
* $$HEX7$$acc0a9c690c72000200020002000$$ENDHEX$$: GUEST  ( $$HEX11$$30ae08cd2000f1b45db8200070c88cd6200000aca5b2$$ENDHEX$$)
* $$HEX8$$70c88cd6200020002000200020002000$$ENDHEX$$: QUERY  ( $$HEX10$$15c8f4bc70c88cd6ccb9200000aca5b220002000$$ENDHEX$$)
* $$HEX5$$70b374c7c0d070c891c7$$ENDHEX$$: DATA_CONTROL  ( $$HEX12$$85c725b8200018c215c82000adc01cc8200024c115c82000$$ENDHEX$$)
* $$HEX7$$08b8ecd3b8d22000200020002000$$ENDHEX$$: REPORT ( $$HEX4$$08b8ecd3b8d22000$$ENDHEX$$, $$HEX5$$9ccd25b800adacb92000$$ENDHEX$$)
****************************************/

F_MENU_CONTROL('DATA_CONTROL_MODIFY' , false)  // All Data Control


end event

event ue_data_control;call super::ue_data_control;Long ROW
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		   
			dw_1.RETRIEVE( UO_PARENT_ITEM.TEXT()+'%' , UO_CHILD_ITEM.TEXT()+'%' ,  GVI_ORGANIZATION_ID)
			dw_1.SETFOCUS()
			
	CASE 'UPDATE'
 
	      IF DW_1.UPDATE() < 0 THEN
				ROLLBACK;
			ELSE
				 COMMIT;
			    F_MSG_MDI_HELP( F_MSG_ST(170)) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			END IF

	CASE ELSE
END CHOOSE
end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_des_raw_bom_master
integer x = 14
integer y = 328
end type

type dw_4 from w_main_root`dw_4 within w_des_raw_bom_master
integer x = 14
integer y = 328
end type

type dw_3 from w_main_root`dw_3 within w_des_raw_bom_master
integer x = 14
integer y = 328
end type

type dw_2 from w_main_root`dw_2 within w_des_raw_bom_master
integer x = 14
integer y = 328
end type

event dw_2::rbuttondown;call super::rbuttondown;IF DWO.NAME = 'parent_item_code' THEN
	OPEN(W_DES_ITEM_POPUP)
	IF message.stringparm = '' THEN 
	ELSE	
		THIS.SETITEM( ROW , 'parent_item_code' , message.stringparm )
	END IF		

ELSEIF DWO.NAME = 'child_item_code' THEN 
	OPEN(W_DES_ITEM_POPUP)
	IF message.stringparm = '' THEN 
	ELSE	
		THIS.SETITEM( ROW , 'child_item_code' , message.stringparm )	
	END IF		
END IF
	
end event

type dw_1 from w_main_root`dw_1 within w_des_raw_bom_master
integer y = 324
integer width = 4507
integer height = 2236
boolean titlebar = true
string title = "Raw BOM List"
string dataobject = "d_des_raw_bom_lst"
end type

event dw_1::rbuttondown;call super::rbuttondown;IF DWO.NAME = 'parent_item_code' THEN
	OPEN(w_des_item_popup)
	IF message.stringparm = '' THEN 
	ELSE
		THIS.SETITEM( ROW , 'parent_item_code' , message.stringparm )
		TRIGGER EVENT ITEMCHANGED( ROW , THIS.OBJECT.PARENT_ITEM_CODE , THIS.OBJECT.PARENT_ITEM_CODE[ROW])				
	END IF
ELSEIF DWO.NAME = 'child_item_code' THEN 
	OPEN(w_des_item_popup)
	IF message.stringparm = '' THEN 
	ELSE
		THIS.SETITEM( ROW , 'child_item_code' , message.stringparm )	
		TRIGGER EVENT ITEMCHANGED( ROW , THIS.OBJECT.CHILD_ITEM_CODE , THIS.OBJECT.CHILD_ITEM_CODE[ROW])		
	END IF
END IF 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_des_raw_bom_master
end type

type uo_parent_item from uo_item_code within w_des_raw_bom_master
integer x = 709
integer y = 188
integer width = 530
integer taborder = 80
boolean bringtotop = true
end type

on uo_parent_item.destroy
call uo_item_code::destroy
end on

type st_5 from so_statictext within w_des_raw_bom_master
integer x = 709
integer y = 120
integer width = 530
integer height = 56
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Parent Item Code"
end type

type st_14 from so_statictext within w_des_raw_bom_master
integer x = 1783
integer y = 116
integer width = 567
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Item Name"
end type

type sle_item_name from so_singlelineedit within w_des_raw_bom_master
event ue_editchange pbm_enchange
integer x = 1783
integer y = 188
integer width = 567
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
end type

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

LVS_COLUMN = 'ITEM_NAME'
IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

SELECTED_DATA_WINDOW.SETFILTER('')
SELECTED_DATA_WINDOW.FILTER()

IF THIS.TEXT = '' THEN 
	LVS_VALUE = '%'
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
SELECTED_DATA_WINDOW.FILTER()
//ST_MSG.TEXT = STRING( SELECTED_DATA_WINDOW.ROWCOUNT() ) + " Found"
end event

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

type uo_child_item from uo_item_code within w_des_raw_bom_master
integer x = 1248
integer y = 188
integer width = 530
integer taborder = 90
boolean bringtotop = true
end type

on uo_child_item.destroy
call uo_item_code::destroy
end on

type st_1 from so_statictext within w_des_raw_bom_master
integer x = 1248
integer y = 120
integer width = 530
integer height = 56
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Child Item Code"
end type

type rb_raw_bom from so_radiobutton within w_des_raw_bom_master
integer x = 37
integer y = 136
integer width = 590
boolean bringtotop = true
integer weight = 700
string text = "Raw BOM List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
selected_data_window = dw_1
end event

type cb_1 from so_commandbutton within w_des_raw_bom_master
integer x = 2496
integer y = 76
integer height = 100
integer taborder = 20
boolean bringtotop = true
string text = "Loop Check"
end type

event clicked;call super::clicked;STRING LVS_ITEM_CODE
LONG LVL_ROWS , I 

LVS_ITEM_CODE = uo_child_item.TEXT

DELETE FROM ID_ENG_BOM_LOOP_CHECK WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID  ;


INSERT INTO ID_ENG_BOM_LOOP_CHECK ( PARENT_ITEM_CODE , CHILD_ITEM_CODE , ORGANIZATION_ID , LEVEL_CHECK )

SELECT PARENT_ITEM_CODE , CHILD_ITEM_CODE , ORGANIZATION_ID , 1
   FROM ID_ENG_BOM 
WHERE CHILD_ITEM_CODE     = :LVS_ITEM_CODE
     AND ORGANIZATION_ID     = :GVI_ORGANIZATION_ID ;
	 
IF F_SQL_CHECK() < 0 THEN 
	RETURN
END IF 


INSERT INTO ID_ENG_BOM_LOOP_CHECK ( PARENT_ITEM_CODE , CHILD_ITEM_CODE , ORGANIZATION_ID  , LEVEL_CHECK)

SELECT PARENT_ITEM_CODE , CHILD_ITEM_CODE , ORGANIZATION_ID , 2
   FROM ID_ENG_BOM 
WHERE PARENT_ITEM_CODE  = :LVS_ITEM_CODE
     AND ORGANIZATION_ID     = :GVI_ORGANIZATION_ID ;
	 
IF F_SQL_CHECK() < 0 THEN 
	RETURN
END IF 

//===================================================================
//
//===================================================================
DO 

	INSERT INTO ID_ENG_BOM_LOOP_CHECK ( PARENT_ITEM_CODE , CHILD_ITEM_CODE , ORGANIZATION_ID )
	 
	
	SELECT PARENT_ITEM_CODE , CHILD_ITEM_CODE , ORGANIZATION_ID
	   FROM ID_ENG_BOM 
	WHERE PARENT_ITEM_CODE          IN  ( SELECT DISTINCT CHILD_ITEM_CODE FROM ID_ENG_BOM_LOOP_CHECK WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID )  
		 AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
		 
	MINUS 
	
	SELECT  PARENT_ITEM_CODE , CHILD_ITEM_CODE , ORGANIZATION_ID 
	 FROM ID_ENG_BOM_LOOP_CHECK
	WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID  ;
	
	IF F_SQL_CHECK() < 0 THEN 
		RETURN
	END IF 
	
	LVL_ROWS = SQLCA.SQLNrows
	COMMIT ; 
LOOP UNTIL LVL_ROWS= 0 

	
I = 1 ;	

LONG LVL_COUNT
DO
	I++
	
UPDATE ID_ENG_BOM_LOOP_CHECK SET LEVEL_CHECK = :I + 1
WHERE PARENT_ITEM_CODE IN ( SELECT CHILD_ITEM_CODE 
                                                         FROM ID_ENG_BOM_LOOP_CHECK 
					                      WHERE LEVEL_CHECK = :I 
									AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID )
	 AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;	
	
	IF F_SQL_CHECK() < 0 THEN 
		RETURN
	END IF 

  SELECT COUNT(*) INTO :LVL_COUNT
     FROM ID_ENG_BOM_LOOP_CHECK
  WHERE NVL(LEVEL_CHECK,0) = 0 
      AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;

	IF F_SQL_CHECK() < 0 THEN 
		RETURN
	END IF 
	
	IF LVL_COUNT = 0 THEN 
		EXIT
	END IF 
	
LOOP UNTIL I = 30

commit ;


//MESS AGEBOX("Notify" , "Loop Check Completed" )
f_msg("Loop Check Completed",'S')
end event

type cb_2 from so_commandbutton within w_des_raw_bom_master
integer x = 2496
integer y = 176
integer height = 100
integer taborder = 30
boolean bringtotop = true
string text = "Show Loop"
end type

event clicked;call super::clicked;STRING LVS_CHECK_CHILD_ITEM_CODE , LVS_CHECK_PARENT_ITEM_CODE

SELECT PARENT_ITEM_CODE , CHILD_ITEM_CODE 
  INTO :LVS_CHECK_PARENT_ITEM_CODE , :LVS_CHECK_CHILD_ITEM_CODE 
 FROM ID_ENG_BOM_LOOP_CHECK A
 WHERE A.ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
     AND  A.PARENT_ITEM_CODE  IN (

SELECT  A.CHILD_ITEM_CODE 
FROM ID_ENG_BOM_LOOP_CHECK A
 WHERE A.ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
     AND  A.CHILD_ITEM_CODE 

	 IN ( SELECT B.PARENT_ITEM_CODE 
	           FROM ID_ENG_BOM_LOOP_CHECK B 
	        WHERE B.ORGANIZATION_ID  = :GVI_ORGANIZATION_ID 
		      AND B.CHILD_ITEM_CODE = A.PARENT_ITEM_CODE
		      AND B.LEVEL_CHECK >= A.LEVEL_CHECK
             ) 
);
			  
	IF F_SQL_CHECK() < 0 THEN 
		RETURN
	END IF 
	
	
IF TRIM(LVS_CHECK_PARENT_ITEM_CODE+'  '+LVS_CHECK_CHILD_ITEM_CODE) = '' 	THEN
	//MESS AGEBOX("Notify" , "No Data Found" )
	f_msg("No Data Found" ,'P')
ELSE
	
	MESSAGEBOX("NOTIFY" , LVS_CHECK_PARENT_ITEM_CODE+'  '+LVS_CHECK_CHILD_ITEM_CODE )
END IF

end event

type gb_where_condition from groupbox within w_des_raw_bom_master
integer x = 5
integer width = 645
integer height = 312
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Category"
end type

type gb_1 from groupbox within w_des_raw_bom_master
integer x = 2423
integer width = 677
integer height = 312
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Process"
end type

type gb_2 from groupbox within w_des_raw_bom_master
integer x = 658
integer y = 4
integer width = 1751
integer height = 312
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Where Condition"
end type

