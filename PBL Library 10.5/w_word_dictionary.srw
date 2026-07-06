HA$PBExportHeader$w_word_dictionary.srw
$PBExportComments$$$HEX4$$a9c6b4c5acc004c8$$ENDHEX$$
forward
global type w_word_dictionary from w_main_root
end type
type st_1 from statictext within w_word_dictionary
end type
type st_2 from statictext within w_word_dictionary
end type
type sle_word from singlelineedit within w_word_dictionary
end type
type sle_column from singlelineedit within w_word_dictionary
end type
type cb_1 from commandbutton within w_word_dictionary
end type
type cb_2 from commandbutton within w_word_dictionary
end type
type rb_korea from radiobutton within w_word_dictionary
end type
type rb_china from radiobutton within w_word_dictionary
end type
type cb_3 from commandbutton within w_word_dictionary
end type
type gb_where_condition from groupbox within w_word_dictionary
end type
type gb_1 from groupbox within w_word_dictionary
end type
end forward

global type w_word_dictionary from w_main_root
string title = "Word Dictionary Master"
st_1 st_1
st_2 st_2
sle_word sle_word
sle_column sle_column
cb_1 cb_1
cb_2 cb_2
rb_korea rb_korea
rb_china rb_china
cb_3 cb_3
gb_where_condition gb_where_condition
gb_1 gb_1
end type
global w_word_dictionary w_word_dictionary

on w_word_dictionary.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
this.sle_word=create sle_word
this.sle_column=create sle_column
this.cb_1=create cb_1
this.cb_2=create cb_2
this.rb_korea=create rb_korea
this.rb_china=create rb_china
this.cb_3=create cb_3
this.gb_where_condition=create gb_where_condition
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.sle_word
this.Control[iCurrent+4]=this.sle_column
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.rb_korea
this.Control[iCurrent+8]=this.rb_china
this.Control[iCurrent+9]=this.cb_3
this.Control[iCurrent+10]=this.gb_where_condition
this.Control[iCurrent+11]=this.gb_1
end on

on w_word_dictionary.destroy
call super::destroy
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_word)
destroy(this.sle_column)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.rb_korea)
destroy(this.rb_china)
destroy(this.cb_3)
destroy(this.gb_where_condition)
destroy(this.gb_1)
end on

event activate;call super::activate;
/***************************************
* $$HEX17$$08c7c4b324c115c8d0c5200000ad5cd52000acc06dd544c720004bc105d35cd5e4b2$$ENDHEX$$
*
*
****************************************/
Gst_set.window_id        = this.classname() 
Gst_set.author           = "LanSheng"
Gst_set.creation_date    = '20041101'
Gst_set.last_modify_date = '20041101'
Gst_set.Report_window    = False  // $$HEX11$$08b8ecd3b8d2200008c7c4b3b0c600ac200044c5d8b2$$ENDHEX$$
/****************************************
* $$HEX4$$58d6bdac24c115c8$$ENDHEX$$
*****************************************/
Ivs_resize_type    = 'NORMAL'  // $$HEX25$$08c7c4b3b0c620006cd030aed0c5200030b57cb7200070b374c7c0d0200008c7c4b3b0c62000acc074c788c92000c0bcbdac$$ENDHEX$$
ivs_dw_1_use_focusindicator = 'Y' //Default $$HEX14$$ecd3e4cea4c2200078c714b500cf74c730d120005cd4dcc2ecc580bd$$ENDHEX$$
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default

/****************************************
* $$HEX6$$54ba74b2200078d5e4b4c1b9$$ENDHEX$$
* ADMIN     : ADMIN  ( $$HEX5$$04c8b4ccacc0a9c62000$$ENDHEX$$)
* $$HEX8$$00adacb9200020002000200020002000$$ENDHEX$$: MANAGE ( $$HEX8$$04c854ba74b2acc0a9c600aca5b22000$$ENDHEX$$)
* $$HEX7$$acc0a9c690c72000200020002000$$ENDHEX$$: GUEST  ( $$HEX11$$30ae08cd2000f1b45db8200070c88cd6200000aca5b2$$ENDHEX$$)
* $$HEX8$$70c88cd6200020002000200020002000$$ENDHEX$$: QUERY  ( $$HEX10$$15c8f4bc70c88cd6ccb9200000aca5b220002000$$ENDHEX$$)
* $$HEX5$$70b374c7c0d070c891c7$$ENDHEX$$: DATA_CONTROL  ( $$HEX12$$85c725b8200018c215c82000adc01cc8200024c115c82000$$ENDHEX$$)
* $$HEX7$$08b8ecd3b8d22000200020002000$$ENDHEX$$: REPORT ( $$HEX4$$08b8ecd3b8d22000$$ENDHEX$$, $$HEX5$$9ccd25b800adacb92000$$ENDHEX$$)
****************************************/
f_menu_control('DATA_CONTROL' , TRUE)  // $$HEX8$$70b374c7c0d0200070c891c700aca5b2$$ENDHEX$$
/****************************************
* $$HEX11$$70b374c7c0d0200008c7c4b3b0c6200078d5e4b4c1b9$$ENDHEX$$
****************************************/

end event

event ue_data_control;call super::ue_data_control;Long ROW
CHOOSE CASE Gvs_Ue_DATA_control
	CASE 'RETRIEVE'
						
			dw_1.RETRIEVE( '%'+SLE_WORD.TEXT+'%' , '%'+SLE_COLUMN.TEXT+'%')
         dw_1.SETFOCUS()
			
	CASE 'INSERT'
			ROW = dw_1.INSERTROW(dw_1.GETROW())
			dw_1.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(dw_1 , ROW , 'ALL')
			F_MSG_MDI_HELP(F_MSG_ST(152))
	CASE 'APPEND'
			ROW = dw_1.INSERTROW(0)
			dw_1.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(dw_1 , ROW , 'ALL')	
			F_MSG_MDI_HELP(F_MSG_ST(152))
	CASE 'DELETE'
		   
		  	IF DW_1.GETROW() < 1 THEN RETURN 
			  
			MSG = f_msgbox(1003) //("NOTIFY" , "DO YOU WISH TO CONTINUE ?" , STOPSIGN! , YESNO! ) 
			IF MSG = 1 THEN
				GVL_ROW_DELETED = DW_1.GETROW()			
				DW_1.DELETEROW(GVL_ROW_DELETED)		
				DW_1.SETFOCUS()
				ROW = DW_1.GETROW()
				DW_1.SCROLLTOROW(ROW)
				DW_1.SETCOLUMN(1)
			END IF
			
	CASE 'UPDATE'
		
	IF dw_1.UPDATE() < 0 THEN
				ROLLBACK;
			ELSE
				 COMMIT;
				F_MSG_MDI_HELP(F_MSG_ST(170))
			END IF
			
	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;SELECTED_DATA_WINDOW = DW_1
/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
//F_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_word_dictionary
integer y = 324
end type

type dw_4 from w_main_root`dw_4 within w_word_dictionary
integer y = 324
end type

type dw_3 from w_main_root`dw_3 within w_word_dictionary
integer y = 324
integer taborder = 0
end type

type dw_2 from w_main_root`dw_2 within w_word_dictionary
integer y = 324
integer taborder = 0
end type

type dw_1 from w_main_root`dw_1 within w_word_dictionary
integer y = 324
integer width = 4539
integer height = 2200
integer taborder = 30
boolean titlebar = true
string title = "Word Dictionary"
string dataobject = "d_word_dictionary"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;IF CURRENTROW = 0 THEN RETURN 
end event

type st_1 from statictext within w_word_dictionary
integer x = 27
integer y = 88
integer width = 677
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Word"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_word_dictionary
integer x = 731
integer y = 92
integer width = 677
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Column"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_word from singlelineedit within w_word_dictionary
event ue_editchange pbm_enchange
integer x = 27
integer y = 160
integer width = 677
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN = 'WORD_KOR'


IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

SELECTED_DATA_WINDOW.SETFILTER('')
SELECTED_DATA_WINDOW.FILTER()

IF THIS.TEXT = '' THEN 
	LVS_VALUE = '%'
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

SELECTED_DATA_WINDOW.SETFILTER( "( WORD_KOR LIKE '"+LVS_VALUE+"'" + ") OR ("+ " WORD_LOCAL LIKE '"+LVS_VALUE+"'" +") OR ("+" WORD_ENG LIKE '"+LVS_VALUE+"')")
SELECTED_DATA_WINDOW.FILTER()

end event

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

type sle_column from singlelineedit within w_word_dictionary
event ue_editchange pbm_enchange
integer x = 731
integer y = 160
integer width = 677
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN = 'COLUMN_NAME'


IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

SELECTED_DATA_WINDOW.SETFILTER('')
SELECTED_DATA_WINDOW.FILTER()

IF THIS.TEXT = '' THEN 
	SELECTED_DATA_WINDOW.SETFILTER('')
	SELECTED_DATA_WINDOW.FILTER()
	RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
SELECTED_DATA_WINDOW.FILTER()

end event

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

type cb_1 from commandbutton within w_word_dictionary
integer x = 1522
integer y = 128
integer width = 635
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Add New Word "
end type

event clicked;IF F_OBJECT_ROLE_CHECK() = FALSE THEN  RETURN

MSG = f_msgbox(155) //( "Confirm" , "Do You Wish To Add New Column ?" ,QUESTION! , YESNO! )
IF MSG = 1 THEN 
ELSE
	RETURN 
END IF

INSERT INTO isys_word_dictionary 
 (     word_eng, word_kor, word_local, word_description_kor,
       word_description_local, word_description_eng, column_name,
       column_type, column_length, column_scale,
       column_nullable, enter_by, enter_date, last_modify_by,
       last_modify_date , organization_id
)       

SELECT DISTINCT 
       COLUMN_NAME word_eng, 
       COLUMN_NAME word_kor, 
       COLUMN_NAME word_local, 
       COLUMN_NAME word_description_kor,
       COLUMN_NAME word_description_local, 
       COLUMN_NAME word_description_eng, 
       COLUMN_NAME column_name,
       DATA_TYPE   column_type, 
       MAX(DATA_LENGTH)  column_length, 
       max(DATA_SCALE)  column_scale ,
       MAX(NULLABLE)    column_nullable, 
       'ADMIN' enter_by, 
       SYSDATE enter_date, 
       'ADMIN' last_modify_by,
       SYSDATE last_modify_date , :Gvi_organization_id
 FROM USER_TAB_COLUMNS 
 WHERE COLUMN_NAME  NOT IN ( SELECT WORD_ENG FROM isys_word_dictionary where organization_id = :Gvi_organization_id ) 
 
 GROUP BY  COLUMN_NAME,DATA_TYPE  ; //DATA_LENGTH ;
 
 
 if f_sql_check() < 0 then 
	return
end if
   msg = f_msgbox( 1170 )
// MSG = ("Confirm" , "Do You Wish To Save ?" , QUESTION! , YESNO! )
 
 IF MSG = 1 THEN 
	F_MSG_MDI_HELP( STRING(SQLCA.SQLNROWS)+" Rows Completed!" )
     COMMIT ;
 ELSE
	 ROLLBACK ;
 END IF
end event

type cb_2 from commandbutton within w_word_dictionary
integer x = 2697
integer y = 128
integer width = 727
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Update By Text Manager"
end type

event clicked;IF F_OBJECT_ROLE_CHECK() = FALSE THEN  RETURN
//$$HEX16$$b8c5b4c5c0bc58d64cd174c714be30ae00c93cc75cb820007cc704adc0bcbdac$$ENDHEX$$
SETPOINTER(HOURGLASS!)
IF RB_CHINA.CHECKED = TRUE THEN 
	
	UPDATE isys_word_dictionary A
		SET ( A.word_local 
			 ) =
			  ( 
				 SELECT MAX(B.LOCAL_TEXT) 
					FROM ISYS_DUAL_LANGUAGE  B 
				  WHERE A.WORD_ENG = REPLACE( B.ENGLISH_TEXT , ' ' , '_' )
  				       AND B.ORGANIZATION_ID = :GVI_ORGANIZATION_ID
				       AND A.ORGANIZATION_ID = :GVI_ORGANIZATION_ID
					GROUP BY REPLACE( B.ENGLISH_TEXT , ' ' , '_' ) , ORGANIZATION_ID
				) 
	  WHERE A.WORD_ENG 
		 IN ( SELECT MAX(REPLACE( B.ENGLISH_TEXT , ' ' , '_' ))
				 FROM ISYS_DUAL_LANGUAGE B
				WHERE A.WORD_ENG = REPLACE( B.ENGLISH_TEXT , ' ' , '_' ) 
  				       AND B.ORGANIZATION_ID = :GVI_ORGANIZATION_ID				
				     AND A.ORGANIZATION_ID = :GVI_ORGANIZATION_ID
					GROUP BY REPLACE( B.ENGLISH_TEXT , ' ' , '_' ) , ORGANIZATION_ID					  
			  )   
		AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID	  ;
			  
IF F_SQL_CHECK() < 0 THEN 
	RETURN
END IF
			  
  F_MSG_MDI_HELP(STRING(SQLCA.SQLNROWS)+" Rows Updated!")
	COMMIT ;         
   
END IF

IF RB_KOREA.CHECKED = TRUE THEN 
	
	UPDATE isys_word_dictionary A
		SET ( A.WORD_KOR 
			) =
			  ( 
				 SELECT REPLACE( MAX(B.KOREA_TEXT) , ':' , '' ) 
					FROM ISYS_DUAL_LANGUAGE  B 
				  WHERE A.WORD_ENG = REPLACE( REPLACE( B.ENGLISH_TEXT , ' ' , '_' )  , ':' , '' )
				        AND A.ORGANIZATION_ID = :GVI_ORGANIZATION_ID
  				       AND B.ORGANIZATION_ID = :GVI_ORGANIZATION_ID						  
					GROUP BY REPLACE( REPLACE( B.ENGLISH_TEXT , ' ' , '_' )  , ':' , '' ) , ORGANIZATION_ID
				) 
	  WHERE A.WORD_ENG 
		 IN ( SELECT MAX(REPLACE( REPLACE( B.ENGLISH_TEXT , ' ' , '_' )  , ':' , '' ))
				 FROM ISYS_DUAL_LANGUAGE B
				WHERE A.WORD_ENG  = REPLACE( REPLACE( B.ENGLISH_TEXT , ' ' , '_' )  , ':' , '' )
				     AND A.ORGANIZATION_ID = :GVI_ORGANIZATION_ID
  				       AND B.ORGANIZATION_ID = :GVI_ORGANIZATION_ID					  
				GROUP BY REPLACE( B.ENGLISH_TEXT , ' ' , '_' ) , ORGANIZATION_ID					  					  
			  )   
		AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID	  ;			  

IF F_SQL_CHECK() < 0 THEN 
	RETURN
END IF
   F_MSG_MDI_HELP( STRING(SQLCA.SQLNROWS)+" Rows Updated!")
   COMMIT ;         
   
END IF


end event

type rb_korea from radiobutton within w_word_dictionary
integer x = 2254
integer y = 92
integer width = 416
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Korea"
end type

type rb_china from radiobutton within w_word_dictionary
integer x = 2254
integer y = 180
integer width = 416
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "China"
boolean checked = true
end type

type cb_3 from commandbutton within w_word_dictionary
integer x = 3433
integer y = 128
integer width = 667
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Batch Delete"
end type

event clicked;IF F_OBJECT_ROLE_CHECK() = FALSE THEN  RETURN
LONG I , J , K , LVL_COUNT
STRING LVS_CHECK_YN

MSG = F_MSGBOX(1003) //$$HEX7$$adc01cc8200060d54cae94c62000$$ENDHEX$$? DO YOU WISH TO DELETE ?
IF MSG = 1 THEN 
ELSE
	RETURN
END IF

DW_1.ACCEPTTEXT()

LVL_COUNT =  DW_1.ROWCOUNT()
I = 1
DO
	K++
	LVS_CHECK_YN = DW_1.GETITEMSTRING( I , 'check_yn' )
	
	IF LVS_CHECK_YN = 'Y' THEN 
		J++
		DW_1.DELETEROW( I )
	ELSE
		 I++
	END IF
	
LOOP UNTIL K = LVL_COUNT

IF J > 0 THEN 
	Msg= F_MSGBOX1( 9030 , STRING(J)) //@ $$HEX18$$74ac74c72000adc01cc8200018b4c8c5b5c2c8b2e4b2200000c8a5c7200060d54cae94c6$$ENDHEX$$
ELSE
	RETURN
END IF

IF MSG = 1 THEN 
	
	IF DW_1.UPDATE() < 0 THEN 
		ROLLBACK;
	ELSE
		COMMIT;
		F_MSG_MDI_HELP(F_MSG_ST(170 ))
	END IF
	
ELSE
	
//	 F_UNDELETE()
	
END IF



end event

type gb_where_condition from groupbox within w_word_dictionary
integer width = 1445
integer height = 312
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

type gb_1 from groupbox within w_word_dictionary
integer x = 1449
integer width = 2683
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
string text = "Process"
end type

