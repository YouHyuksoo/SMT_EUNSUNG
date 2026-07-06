HA$PBExportHeader$w_db_object_master.srw
$PBExportComments$DB Object  Information Manage
forward
global type w_db_object_master from w_main_root
end type
type st_2 from so_statictext within w_db_object_master
end type
type sle_object_name from singlelineedit within w_db_object_master
end type
type cb_generate from so_commandbutton within w_db_object_master
end type
type ddlb_object_type from uo_object_type within w_db_object_master
end type
type st_1 from so_statictext within w_db_object_master
end type
type cb_1 from so_commandbutton within w_db_object_master
end type
type gb_1 from groupbox within w_db_object_master
end type
type gb_2 from groupbox within w_db_object_master
end type
end forward

global type w_db_object_master from w_main_root
integer width = 4974
integer height = 2620
string title = "Object Master"
st_2 st_2
sle_object_name sle_object_name
cb_generate cb_generate
ddlb_object_type ddlb_object_type
st_1 st_1
cb_1 cb_1
gb_1 gb_1
gb_2 gb_2
end type
global w_db_object_master w_db_object_master

type variables
//
end variables

on w_db_object_master.create
int iCurrent
call super::create
this.st_2=create st_2
this.sle_object_name=create sle_object_name
this.cb_generate=create cb_generate
this.ddlb_object_type=create ddlb_object_type
this.st_1=create st_1
this.cb_1=create cb_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.sle_object_name
this.Control[iCurrent+3]=this.cb_generate
this.Control[iCurrent+4]=this.ddlb_object_type
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.gb_2
end on

on w_db_object_master.destroy
call super::destroy
destroy(this.st_2)
destroy(this.sle_object_name)
destroy(this.cb_generate)
destroy(this.ddlb_object_type)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event activate;call super::activate;/***************************************
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
Ivs_resize_type    = 'MASTER_DETAIL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
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

F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control

/****************************************
* 
****************************************/

end event

event ue_data_control;call super::ue_data_control;Long ROW
CHOOSE CASE Gvs_Ue_DATA_control
	CASE 'RETRIEVE'
		

	         DW_1.RETRIEVE( DDLB_OBJECT_TYPE.TEXT+'%' , SLE_OBJECT_NAME.TEXT+'%' , GVS_LANGUAGE )
             DW_1.SETFOCUS()
			
	CASE 'INSERT'
			ROW = DW_1.INSERTROW(DW_1.GETROW())
			DW_1.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_1 , ROW , 'NONORG')
	CASE 'APPEND'
			ROW = DW_1.INSERTROW(0)
			DW_1.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_1 , ROW , 'NONORG')	
	CASE 'DELETE'
			if DW_1.AcceptText() = -1 then
				return
			end if
			
			// $$HEX7$$54badcc2c0c9200038d69ccd2000$$ENDHEX$$($$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?)
			MSG = F_MSGBOX(1003) 
			IF MSG = 1 THEN
				Gvl_row_deleted = DW_1.GetRow()			
				DW_1.DELETEROW(Gvl_row_deleted)		
				DW_1.SetFocus()
				ROW = DW_1.GetRow()
				DW_1.ScrollToRow(row)
				DW_1.SetColumn(1)
			END IF
						
	CASE 'UPDATE'
		
	IF DW_1.UPDATE() < 0 THEN
				ROLLBACK;
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( F_MSG_ST( 170) ) 
				// st_msg.text = "Update Complete"//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			END IF
			
	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_db_object_master
integer y = 292
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_db_object_master
integer y = 292
integer taborder = 50
end type

type dw_3 from w_main_root`dw_3 within w_db_object_master
integer y = 292
integer taborder = 60
end type

type dw_2 from w_main_root`dw_2 within w_db_object_master
integer y = 1320
integer width = 4507
integer height = 1032
integer taborder = 70
boolean titlebar = true
string title = "Object Source"
string dataobject = "d_object_source"
end type

type dw_1 from w_main_root`dw_1 within w_db_object_master
integer y = 252
integer width = 4507
integer height = 1064
integer taborder = 0
boolean titlebar = true
string title = "Object List"
string dataobject = "d_object_description"
end type

event dw_1::doubleclicked;call super::doubleclicked;if row < 1 then 
	return
end if

dw_2.retrieve( dw_1.object.object_name[row] )
end event

type st_2 from so_statictext within w_db_object_master
integer x = 773
integer y = 76
integer width = 1216
integer height = 56
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Object Name"
end type

type sle_object_name from singlelineedit within w_db_object_master
event ue_editchange pbm_enchange
integer x = 773
integer y = 140
integer width = 1216
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "h_beam.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN = 'LOCAL_TEXT'

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

end event

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

type cb_generate from so_commandbutton within w_db_object_master
integer x = 2080
integer y = 100
integer width = 503
integer height = 100
integer taborder = 10
boolean bringtotop = true
string text = "New Create"
end type

event clicked;MSG = F_MSGBOX1( 1161 , THIS.TEXT)
IF MSG = 1 THEN 
ELSE
	RETURN 
END IF

DELETE FROM  ISYS_OBJECT  
 WHERE OBJECT_TYPE LIKE :DDLB_OBJECT_TYPE.TEXT||'%' 
    AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
 
IF F_SQL_CHECK() < 0 THEN 
	RETURN
END IF

  INSERT INTO "ISYS_OBJECT"  
         ( "OBJECT_NAME",   
           "OBJECT_TYPE",   
           "OBJECT_DESC_KOREA",   
           "OBJECT_DESC_LOCAL",   
           "OBJECT_COMMENT_KOREA",   
           "OBJECT_COMMENT_LOCAL",   			  
           "OBJECT_SCRIPTS",   
           "ENTER_BY",   
           "ENTER_DATE",   
           "LAST_MODIFY_BY",   
           "LAST_MODIFY_DATE" ,
		 "ORGANIZATION_ID"	  )  
    SELECT "OBJECT_NAME",   
			"OBJECT_TYPE",   
			'*' , 
			'*' ,
			'*' ,
			'*' ,
			'*',
			:GVS_USER_ID,
			SYSDATE,			  
			:GVS_USER_ID,				
			SYSDATE ,
               :GVI_ORGANIZATION_ID
      FROM USER_OBJECTS
	  WHERE OBJECT_TYPE LIKE :DDLB_OBJECT_TYPE.TEXT ||'%' 
	    AND OBJECT_NAME 
		 NOT IN ( SELECT OBJECT_NAME FROM ISYS_OBJECT WHERE OBJECT_TYPE = :DDLB_OBJECT_TYPE.TEXT );
	  
IF F_SQL_CHECK() < 0 THEN 
	RETURN
ELSE
	COMMIT;
	F_MSG_MDI_HELP( F_MSG_ST( 170 )) // $$HEX14$$31c1f5ac01c83cc75cb8200001c8a9c618b4c8c5b5c2c8b2e4b20900$$ENDHEX$$
END IF


end event

type ddlb_object_type from uo_object_type within w_db_object_master
integer x = 46
integer y = 140
integer taborder = 30
boolean bringtotop = true
boolean allowedit = true
end type

type st_1 from so_statictext within w_db_object_master
integer x = 46
integer y = 72
integer width = 722
integer height = 56
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Object Type"
end type

type cb_1 from so_commandbutton within w_db_object_master
integer x = 2587
integer y = 100
integer width = 503
integer height = 100
integer taborder = 20
boolean bringtotop = true
string text = "Add Create"
end type

event clicked;call super::clicked;MSG = F_MSGBOX1( 1161 , THIS.TEXT)
IF MSG = 1 THEN 
ELSE
	RETURN 
END IF


  INSERT INTO "ISYS_OBJECT"  
         ( "OBJECT_NAME",   
           "OBJECT_TYPE",   
           "OBJECT_DESC_KOREA",   
           "OBJECT_DESC_LOCAL",   
           "OBJECT_COMMENT_KOREA",   
           "OBJECT_COMMENT_LOCAL",   			  
           "OBJECT_SCRIPTS",   
           "ENTER_BY",   
           "ENTER_DATE",   
           "LAST_MODIFY_BY",   
           "LAST_MODIFY_DATE" )  
    SELECT "OBJECT_NAME",   
           "OBJECT_TYPE",   
			  '*' , 
			  '*' ,
			  '*' ,
			  '*' ,
			  '*' ,			  
	    	  :GVS_USER_ID,
    		  SYSDATE,			  
			  :GVS_USER_ID,				
			  SYSDATE

      FROM USER_OBJECTS
	  WHERE OBJECT_TYPE = :DDLB_OBJECT_TYPE.TEXT
	    AND OBJECT_NAME 
		 NOT IN ( SELECT OBJECT_NAME FROM ISYS_OBJECT WHERE OBJECT_TYPE = :DDLB_OBJECT_TYPE.TEXT );
	  
IF F_SQL_CHECK() < 0 THEN 
	RETURN
ELSE
	COMMIT;
	F_MSG_MDI_HELP( F_MSG_ST( 170 )) // $$HEX14$$31c1f5ac01c83cc75cb8200001c8a9c618b4c8c5b5c2c8b2e4b20900$$ENDHEX$$
END IF


end event

type gb_1 from groupbox within w_db_object_master
integer y = 12
integer width = 2021
integer height = 236
integer taborder = 10
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

type gb_2 from groupbox within w_db_object_master
integer x = 2039
integer y = 12
integer width = 1079
integer height = 232
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

