HA$PBExportHeader$w_error_message.srw
$PBExportComments$$$HEX10$$d0c5ecb754badcc2c0c99ccd25b808c7c4b3b0c6$$ENDHEX$$
forward
global type w_error_message from w_none_dw_popup_root
end type
type st_12 from so_statictext within w_error_message
end type
type st_11 from so_statictext within w_error_message
end type
type cb_5 from so_commandbutton within w_error_message
end type
type sle_app_line_no from so_singlelineedit within w_error_message
end type
type st_4 from so_statictext within w_error_message
end type
type st_2 from so_statictext within w_error_message
end type
type st_1 from so_statictext within w_error_message
end type
type mle_help from so_multilineedit within w_error_message
end type
type st_5 from so_statictext within w_error_message
end type
type sle_org_line_no from so_singlelineedit within w_error_message
end type
type mle_syntax from so_multilineedit within w_error_message
end type
type cb_4 from so_commandbutton within w_error_message
end type
type cb_3 from so_commandbutton within w_error_message
end type
type cb_2 from so_commandbutton within w_error_message
end type
type mle_app_error_text from so_multilineedit within w_error_message
end type
type sle_app_error_code from so_singlelineedit within w_error_message
end type
type mle_org_error_text from so_multilineedit within w_error_message
end type
type sle_org_error_code from so_singlelineedit within w_error_message
end type
type gb_2 from so_groupbox within w_error_message
end type
type gb_1 from so_groupbox within w_error_message
end type
end forward

global type w_error_message from w_none_dw_popup_root
integer x = 357
integer y = 576
integer width = 4731
integer height = 2224
string title = "DataBase Error Information"
boolean minbox = true
windowtype windowtype = popup!
st_12 st_12
st_11 st_11
cb_5 cb_5
sle_app_line_no sle_app_line_no
st_4 st_4
st_2 st_2
st_1 st_1
mle_help mle_help
st_5 st_5
sle_org_line_no sle_org_line_no
mle_syntax mle_syntax
cb_4 cb_4
cb_3 cb_3
cb_2 cb_2
mle_app_error_text mle_app_error_text
sle_app_error_code sle_app_error_code
mle_org_error_text mle_org_error_text
sle_org_error_code sle_org_error_code
gb_2 gb_2
gb_1 gb_1
end type
global w_error_message w_error_message

on w_error_message.create
int iCurrent
call super::create
this.st_12=create st_12
this.st_11=create st_11
this.cb_5=create cb_5
this.sle_app_line_no=create sle_app_line_no
this.st_4=create st_4
this.st_2=create st_2
this.st_1=create st_1
this.mle_help=create mle_help
this.st_5=create st_5
this.sle_org_line_no=create sle_org_line_no
this.mle_syntax=create mle_syntax
this.cb_4=create cb_4
this.cb_3=create cb_3
this.cb_2=create cb_2
this.mle_app_error_text=create mle_app_error_text
this.sle_app_error_code=create sle_app_error_code
this.mle_org_error_text=create mle_org_error_text
this.sle_org_error_code=create sle_org_error_code
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_12
this.Control[iCurrent+2]=this.st_11
this.Control[iCurrent+3]=this.cb_5
this.Control[iCurrent+4]=this.sle_app_line_no
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.mle_help
this.Control[iCurrent+9]=this.st_5
this.Control[iCurrent+10]=this.sle_org_line_no
this.Control[iCurrent+11]=this.mle_syntax
this.Control[iCurrent+12]=this.cb_4
this.Control[iCurrent+13]=this.cb_3
this.Control[iCurrent+14]=this.cb_2
this.Control[iCurrent+15]=this.mle_app_error_text
this.Control[iCurrent+16]=this.sle_app_error_code
this.Control[iCurrent+17]=this.mle_org_error_text
this.Control[iCurrent+18]=this.sle_org_error_code
this.Control[iCurrent+19]=this.gb_2
this.Control[iCurrent+20]=this.gb_1
end on

on w_error_message.destroy
call super::destroy
destroy(this.st_12)
destroy(this.st_11)
destroy(this.cb_5)
destroy(this.sle_app_line_no)
destroy(this.st_4)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.mle_help)
destroy(this.st_5)
destroy(this.sle_org_line_no)
destroy(this.mle_syntax)
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.mle_app_error_text)
destroy(this.sle_app_error_code)
destroy(this.mle_org_error_text)
destroy(this.sle_org_error_code)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event open;call super::open;SLE_ORG_LINE_NO.TEXT          = STRING(GVL_ERROR_ROW)
SLE_ORG_ERROR_CODE.TEXT = STRING(GVL_DBERRORCODE)
MLE_ORG_ERROR_TEXT.TEXT  = GVS_DBERRORMESSAGE
MLE_SYNTAX.TEXT                    = Gvs_error_syntax

SELECT ERROR_HELP INTO :MLE_HELP.TEXT 
  FROM ISYS_ERROR
 WHERE APPLICATION_NAME         = :Gvs_App_name
      AND APPLICATION_INITIAL      = :Gvs_app_initial
	 AND ORIGINAL_ERROR_CODE = TO_NUMBER(:SLE_ORG_ERROR_CODE.TEXT)
	 AND ERROR_TYPE                     = 'DATABASE'
	 AND ORGANIZATION_ID           = :GVI_ORGANIZATION_ID;
	
IF F_SQL_CHECK()  < 0 THEN 
	RETURN
END IF
end event

type p_title from w_none_dw_popup_root`p_title within w_error_message
integer width = 4745
end type

type cb_close from w_none_dw_popup_root`cb_close within w_error_message
boolean visible = true
integer x = 4425
integer y = 1924
integer height = 108
end type

type st_msg from w_none_dw_popup_root`st_msg within w_error_message
boolean visible = true
integer y = 2048
integer width = 4713
boolean enabled = true
end type

type st_12 from so_statictext within w_error_message
integer x = 82
integer y = 1388
integer width = 338
integer height = 76
integer weight = 700
string text = "LineNumber"
end type

type st_11 from so_statictext within w_error_message
integer x = 82
integer y = 1220
integer width = 338
integer height = 64
integer weight = 700
string text = "ErrorNumber"
end type

type cb_5 from so_commandbutton within w_error_message
integer x = 1179
integer y = 1928
integer width = 1019
integer height = 108
integer taborder = 70
string text = "Error Contents Registration"
end type

event clicked;IF LEN(MLE_HELP.TEXT) = 0 THEN 
	RETURN
END IF
msg = f_msgbox( 154)
//MSG = ("Confirm" , " Database Error Infromation Register ?" , QUESTION! , YESNO!)
IF MSG <> 1 THEN 
	RETURN
END IF

  ROWCNT	= 0 
  SELECT COUNT(*) INTO :ROWCNT FROM "ISYS_ERROR" 
   WHERE APPLICATION_NAME    = :Gvs_App_name
     AND APPLICATION_INITIAL = :Gvs_app_initial
     AND ORIGINAL_ERROR_CODE = TO_NUMBER(:SLE_ORG_ERROR_CODE.TEXT)
	  AND ERROR_TYPE = 'DATABASE'
	  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID;
	  IF  F_SQL_CHECK() < 1 THEN RETURN ;
		
	IF ROWCNT > 0 THEN 
		
		UPDATE "ISYS_ERROR" 
			SET ERROR_HELP = :MLE_HELP.TEXT ,
				 LAST_MODIFY_DATE = SYSDATE 								
       WHERE APPLICATION_NAME    = :Gvs_App_name
         AND APPLICATION_INITIAL = :Gvs_app_initial
         AND ORIGINAL_ERROR_CODE = TO_NUMBER(:SLE_ORG_ERROR_CODE.TEXT)
         AND ERROR_TYPE = 'DATABASE'
	    AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID;
			
	   IF F_SQL_CHECK_COMMIT('COMMIT') = 1 THEN f_msgbox(170) ; //=$$HEX18$$d0c5ecb77cb92000b4cc6cd058d5e0ac200015c8c1c074c774ba200000c8a5c75cd5e4b2$$ENDHEX$$
		
	ELSE		
  
     INSERT INTO "ISYS_ERROR"  
         ( "APPLICATION_NAME",   
           "APPLICATION_INITIAL",   
           "APP_ERROR_CODE",   
           "APP_ERROR_TEXT",   
           "ORIGINAL_ERROR_CODE",   
           "ORIGINAL_ERROR_TEXT",   
			  "ORGANIZATION_ID",
           "LAST_MODIFY_DATE",   
           "LAST_MODIFY_BY",
			  "ERROR_HELP",
			  "ERROR_TYPE" )  
     VALUES ( :Gvs_App_name , 
           :Gvs_app_initial,
           NVL(:sle_app_error_code.TEXT ,0),
           NVL(:mle_app_error_text.TEXT ,'X'),   
           TO_NUMBER(:SLE_ORG_ERROR_CODE.TEXT),
           :MLE_ORG_ERROR_TEXT.TEXT,   
			  :GVI_ORGANIZATION_ID ,
           SYSDATE,   
           :Gvs_user_name ,
			  :MLE_HELP.TEXT,
			  'DATABASE')  ;
			  
		 IF F_SQL_CHECK_COMMIT('COMMIT') = 1 THEN f_msgbox(170) ; //=$$HEX18$$d0c5ecb77cb92000b4cc6cd058d5e0ac200015c8c1c074c774ba200000c8a5c75cd5e4b2$$ENDHEX$$
	 END IF
end event

type sle_app_line_no from so_singlelineedit within w_error_message
integer x = 82
integer y = 1468
integer width = 338
integer height = 92
integer taborder = 30
integer weight = 700
long textcolor = 255
long backcolor = 12632256
boolean autohscroll = false
borderstyle borderstyle = stylebox!
end type

type st_4 from so_statictext within w_error_message
integer x = 105
integer y = 1608
integer width = 297
integer height = 64
integer weight = 700
string text = "Sql Scripts"
alignment alignment = right!
end type

type st_2 from so_statictext within w_error_message
integer x = 69
integer y = 728
integer width = 347
integer height = 64
integer weight = 700
string text = "Help "
alignment alignment = right!
end type

type st_1 from so_statictext within w_error_message
integer x = 78
integer y = 268
integer width = 352
integer height = 64
integer weight = 700
string text = "ErrorNumber"
end type

type mle_help from so_multilineedit within w_error_message
integer x = 434
integer y = 724
integer width = 4238
integer height = 392
integer taborder = 50
integer weight = 700
long backcolor = 29667104
string text = ""
boolean border = false
boolean hscrollbar = true
boolean vscrollbar = true
boolean autohscroll = true
boolean autovscroll = true
textcase textcase = upper!
end type

type st_5 from so_statictext within w_error_message
integer x = 78
integer y = 432
integer width = 352
integer height = 76
integer weight = 700
string text = "LineNumber"
end type

type sle_org_line_no from so_singlelineedit within w_error_message
integer x = 78
integer y = 504
integer width = 352
integer height = 92
integer taborder = 40
integer weight = 700
long backcolor = 12632256
boolean autohscroll = false
borderstyle borderstyle = stylebox!
end type

type mle_syntax from so_multilineedit within w_error_message
integer x = 434
integer y = 1468
integer width = 2478
integer height = 420
integer taborder = 60
integer weight = 700
long backcolor = 21025778
string text = ""
boolean border = false
boolean hscrollbar = true
boolean vscrollbar = true
boolean autohscroll = true
boolean autovscroll = true
end type

type cb_4 from so_commandbutton within w_error_message
integer x = 608
integer y = 1928
integer width = 571
integer height = 108
string text = "Transmit To Admin"
end type

type cb_3 from so_commandbutton within w_error_message
integer x = 82
integer y = 1928
integer width = 256
integer height = 108
string text = "Printer"
end type

event clicked;printsetup()
end event

type cb_2 from so_commandbutton within w_error_message
integer x = 338
integer y = 1928
integer width = 270
integer height = 108
string text = "Print"
end type

event clicked;long Job

Job = PrintOpen()

PrintScreen(Job, 1,1)

PrintClose(Job)
end event

type mle_app_error_text from so_multilineedit within w_error_message
integer x = 434
integer y = 1212
integer width = 2478
integer height = 244
integer weight = 700
long backcolor = 16777215
string text = ""
boolean border = false
boolean hscrollbar = true
boolean vscrollbar = true
boolean autohscroll = true
boolean autovscroll = true
end type

type sle_app_error_code from so_singlelineedit within w_error_message
integer x = 82
integer y = 1288
integer width = 338
integer height = 88
integer weight = 700
long textcolor = 255
long backcolor = 12632256
boolean autohscroll = false
borderstyle borderstyle = stylebox!
end type

type mle_org_error_text from so_multilineedit within w_error_message
integer x = 434
integer y = 268
integer width = 4238
integer height = 436
integer weight = 700
long textcolor = 65280
long backcolor = 0
string text = ""
boolean border = false
boolean hscrollbar = true
boolean vscrollbar = true
boolean autohscroll = true
boolean autovscroll = true
end type

type sle_org_error_code from so_singlelineedit within w_error_message
integer x = 78
integer y = 332
integer width = 352
integer height = 92
integer weight = 700
long backcolor = 12632256
boolean autohscroll = false
borderstyle borderstyle = stylebox!
end type

type gb_2 from so_groupbox within w_error_message
integer x = 32
integer y = 1152
integer width = 4672
integer height = 760
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Application Error"
end type

type gb_1 from so_groupbox within w_error_message
integer x = 32
integer y = 196
integer width = 4672
integer height = 952
integer taborder = 20
integer weight = 700
long textcolor = 255
string text = "Database Error"
end type

