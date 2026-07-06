HA$PBExportHeader$w_popup_root.srw
$PBExportComments$(Item Query)-$$HEX4$$80bd88d470c88cd6$$ENDHEX$$
forward
global type w_popup_root from window
end type
type p_title from st_uo_gradiant within w_popup_root
end type
type cb_sort from so_commandbutton within w_popup_root
end type
type cb_close from so_commandbutton within w_popup_root
end type
type st_msg from so_statictext within w_popup_root
end type
type dw_1 from datawindow within w_popup_root
end type
type dw_2 from datawindow within w_popup_root
end type
type dw_3 from datawindow within w_popup_root
end type
end forward

global type w_popup_root from window
integer width = 3470
integer height = 2240
boolean titlebar = true
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 12632256
boolean contexthelp = true
boolean center = true
event ue_post_open ( )
p_title p_title
cb_sort cb_sort
cb_close cb_close
st_msg st_msg
dw_1 dw_1
dw_2 dw_2
dw_3 dw_3
end type
global w_popup_root w_popup_root

type variables
DOUBLE setrow
DATAWINDOW IVD_SELECTED_DATA_WINDOW
STRING IVS_MOUSEMOVE_YN = 'N'
STRING IVS_RESIZE_TYPE = 'NORMAL'

//==============================
// ANIMATEWINDOW CONSTASNT
//==============================
CONSTANT LONG AW_HOR_POSITIVE = 1
CONSTANT LONG AW_HOR_NEGATIVE = 2
CONSTANT LONG AW_VER_POSITIVE = 4
CONSTANT LONG AW_VER_NEGATIVE = 8
CONSTANT LONG AW_CENTER = 16
CONSTANT LONG AW_HIDE = 65536
CONSTANT LONG AW_ACTIVATE = 131072
CONSTANT LONG AW_SLIDE = 262144
CONSTANT LONG AW_BLEND = 524288 


end variables

forward prototypes
public subroutine wf_animatewindow (integer arg_time, long arg_type)
end prototypes

event ue_post_open();//=====================
// dddw auto set
//=====================
f_set_column_dddw( dw_1 )
f_set_column_dddw( dw_2 )
f_set_column_dddw( dw_3 )


st_msg.resize(width - 5 , st_msg.height )	
p_title.resize(width -5,  p_title.height)		

IF UPPER(IVS_RESIZE_TYPE) = 'DEFAULT' THEN

ELSEIF UPPER(IVS_RESIZE_TYPE) = 'NORMAL' THEN
	
	dw_1.resize(width , height - dw_1.y )	
	
	dw_2.resize(width , height - dw_2.y )	
	
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL' THEN
	
	dw_2.y = dw_1.y + dw_1.HEIGHT
     dw_2.resize(width - dw_2.x -34, dw_2.height )		
	
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'VERTICAL' THEN
	
	dw_1.resize(width  / 2, height - dw_1.y )	
	dw_2.x = dw_1.width
	dw_2.resize(width  / 2, height - dw_2.y )		
	
END IF
end event

public subroutine wf_animatewindow (integer arg_time, long arg_type);//===============================
// CENTER POSITION
//===============================
long llX, llY, llXRes, llYRes
IF GetEnvironment ( lEnv ) = 1 THEN
// Get current screen settings
llXRes = lEnv.ScreenWidth
llYRes = lEnv.ScreenHeight
ELSE
//Default to 640x480
llXRes = 1024
llYRes = 768
END IF
// Convert pixels to PB units
llXRes = PixelsToUnits ( llXRes, XPixelsToUnits! )
llYRes = PixelsToUnits ( llYRes, YPixelsToUnits! )
// Is this window too wide for the current resolution ???
IF llXRes <= this.Width THEN
// Move window to leftmost position
llX = 0
ELSE
// Center window horizontally
llX = (llXRes - this.Width) / 2
END IF
// Is this window too high for the current resolution ???
IF llYRes <= this.Height THEN
// Move window to topmost position
llY = 0 
ELSE
// Center window vertically
llY = (llYRes - this.Height) / 2
END IF

this.x = llX
this.y = llY

this.VISIBLE = false

animatewindow(handle(this),arg_time, arg_type )  
this.VISIBLE = true
this.setredraw( true)

end subroutine

on w_popup_root.create
this.p_title=create p_title
this.cb_sort=create cb_sort
this.cb_close=create cb_close
this.st_msg=create st_msg
this.dw_1=create dw_1
this.dw_2=create dw_2
this.dw_3=create dw_3
this.Control[]={this.p_title,&
this.cb_sort,&
this.cb_close,&
this.st_msg,&
this.dw_1,&
this.dw_2,&
this.dw_3}
end on

on w_popup_root.destroy
destroy(this.p_title)
destroy(this.cb_sort)
destroy(this.cb_close)
destroy(this.st_msg)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.dw_3)
end on

event open;////===============================
//// CENTER POSITION
////===============================
//long llX, llY, llXRes, llYRes
//
//IF GetEnvironment ( lEnv ) = 1 THEN
//	// Get current screen settings
//	llXRes = lEnv.ScreenWidth
//	llYRes = lEnv.ScreenHeight
//ELSE
//	//Default to 1024/768
//	llXRes = 1024
//	llYRes = 768
//END IF
//
//// Convert pixels to PB units
//llXRes = PixelsToUnits ( llXRes, XPixelsToUnits! )
//llYRes = PixelsToUnits ( llYRes, YPixelsToUnits! )
//// Is this window too wide for the current resolution ???
//IF llXRes <= this.Width THEN
//// Move window to leftmost position
//llX = 0
//ELSE
//// Center window horizontally
//llX = (llXRes - this.Width) / 2
//END IF
//// Is this window too high for the current resolution ???
//IF llYRes <= this.Height THEN
//// Move window to topmost position
//llY = 0 
//ELSE
//// Center window vertically
//llY = (llYRes - this.Height) / 2
//END IF
//
//this.visible = false
//
//this.x = llX 
//this.y = llY -120
//
////animatewindow(handle(this),500, 524288 )  //fade 
////animatewindow(handle(this),500, 262148 )  //$$HEX8$$04c7d0c51cc1200044c598b75cb82000$$ENDHEX$$
////262145 $$HEX5$$7cc6bdcad0c51cc12000$$ENDHEX$$-> $$HEX5$$24c678b9bdca3cc75cb8$$ENDHEX$$
////262146 $$HEX6$$24c678b9bdcad0c51cc12000$$ENDHEX$$-> $$HEX4$$7cc6bdca3cc75cb8$$ENDHEX$$
//
////================================================
////
////================================================
////[instance variable]  
////CONSTANT LONG AW_HOR_POSITIVE = 1
////CONSTANT LONG AW_HOR_NEGATIVE = 2
////CONSTANT LONG AW_VER_POSITIVE = 4
////CONSTANT LONG AW_VER_NEGATIVE = 8
////CONSTANT LONG AW_CENTER = 16
////CONSTANT LONG AW_HIDE = 65536
////CONSTANT LONG AW_ACTIVATE = 131072
////CONSTANT LONG AW_SLIDE = 262144
////CONSTANT LONG AW_BLEND = 524288  
////
////[powerscript, open event]
////// slide right to left
////AnimateWindow ( Handle( this ),500,AW_HOR_NEGATIVE) 
////
////// slide left to right
////AnimateWindow ( Handle( this ),500,AW_HOR_POSITIVE)
////
////// slide top to bottom
////AnimateWindow ( Handle( this ),500,AW_VER_POSITIVE)
////
////// slide bottom to top
////AnimateWindow ( Handle( this ),500,AW_VER_NEGATIVE)
////
////// from center expand
//AnimateWindow ( Handle( this ),500,AW_CENTER)
////
////// reveal diagonnally
////AnimateWindow ( Handle( this ),500,AW_VER_NEGATIVE + AW_HOR_NEGATIVE)
//this.visible = TRUE
//this.setredraw( true)

//========================================
//
//========================================
dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)
dw_3.settransobject(sqlca)

cb_close.setfocus()

IVD_SELECTED_DATA_WINDOW = DW_1

if gds_dual.rowcount() < 1 then 
	f_msgbox(136) //There is not a possibility of knowing multi national language information  "Error" , "Language Info Not Found "
	return
end if

this.st_msg.text = "Language Change..."
  f_dual_lang_change_text(this)
this.st_msg.text = ''

triggerevent('ue_post_open')
end event

event resize;st_msg.resize(newwidth - 5 , st_msg.height )	
p_title.resize(newwidth , p_title.height)			
IF  UPPER(IVS_RESIZE_TYPE) = 'DEFAULT' THEN
	
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'NORMAL' THEN
	
	dw_1.resize(newwidth , newheight - dw_1.y )	
	dw_2.resize(newwidth , newheight - dw_2.y )	

ELSEIF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL' THEN
	
	dw_1.resize(newwidth , newheight - dw_1.y )		

	
	dw_2.y = dw_1.y + dw_1.HEIGHT 
     dw_2.resize(newwidth  - dw_2.x , dw_2.height )
	
ELSEIF UPPER(IVS_RESIZE_TYPE) = 'VERTICAL' THEN
	
	
	dw_1.resize(newwidth  / 2, newheight - dw_1.y )	

	dw_2.x = dw_1.width
	dw_2.resize(newwidth  / 2, newheight - dw_2.y )		

END IF
end event

event rbuttondown;msg = f_msgbox( 143) // "Language Extract ?"
IF MSG =1 THEN
ELSE
	RETURN 
END IF
window activesheet
activesheet = w_main_frame.GetActiveSheet( )
Selected_window = THIS

if Gvs_language = 'E' then
	IF IsValid(activesheet) THEN
		w_main_frame.SetMicroHelp("Searching...")
	
		f_dual_lang_gettext( Selected_window ) 
		
		w_main_frame.SetMicroHelp("Done.")	
	END IF
else
	f_msgbox( 101 )//	('Information', " If you want to get text Then change current language set by 'English'.")
end if
end event

event key;if Key = KeyEscape! then 
	
	MSG = F_MSGBOX( 9039) //$$HEX10$$04d6acc73dcc44c72000ebb244c74cae94c62000$$ENDHEX$$?
	
	if Msg = 1 then
	else
		 Return
	end if

	close(this)
end if
end event

type p_title from st_uo_gradiant within w_popup_root
integer height = 176
string text = ""
string #ivs_type = "H"
double #ivdb_color_1 = 255
end type

type cb_sort from so_commandbutton within w_popup_root
boolean visible = false
integer x = 2633
integer y = 40
integer width = 274
integer height = 100
integer taborder = 20
string text = "Sort"
end type

event clicked;f_sort_4_popup(IVD_SELECTED_DATA_WINDOW)
end event

type cb_close from so_commandbutton within w_popup_root
boolean visible = false
integer x = 2907
integer y = 40
integer width = 274
integer height = 100
integer taborder = 10
string text = "Close"
end type

event clicked;close(parent)
end event

type st_msg from so_statictext within w_popup_root
boolean visible = false
integer y = 288
integer width = 3205
integer height = 88
integer weight = 700
long textcolor = 16711680
boolean enabled = false
boolean border = true
borderstyle borderstyle = styleraised!
end type

type dw_1 from datawindow within w_popup_root
event uo_mousemove pbm_dwnmousemove
event ue_dwkey pbm_dwnkey
boolean visible = false
integer y = 384
integer width = 526
integer height = 424
integer taborder = 90
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

event uo_mousemove;IF IVS_MOUSEMOVE_YN = 'Y'  THEN 

	IF ROW < 1 THEN RETURN 
	IF Gvl_CurrentRow = ROW  THEN RETURN 
	IF THIS.ROWCOUNT() = 1 THEN RETURN 
	
	Gvl_CurrentRow = ROW
	
		IF THIS.ISSELECTED(row) = TRUE THEN 
			THIS.SELECTROW(0 , FALSE )	
			THIS.SELECTROW(row , FALSE )
		ELSE
			THIS.SELECTROW(0 , FALSE )		
			THIS.SELECTROW(row , TRUE )
			THIS.SETROW(ROW)
		END IF
	
	
END IF

 IF  UPPER(DWO.TYPE) = 'TEXT' AND  UPPER(DWO.NAME) = 'CHECK_YN_T' THEN
       THIS.Modify("CHECK_YN_T.Pointer='HAND.ANI'")	 
END IF

if row < 1 then return
IF   GVS_SHOW_ITEM_IMAGE = 'Y' AND ( UPPER(DWO.TYPE) = 'COLUMN' AND  UPPER(DWO.NAME) = 'ITEM_CODE'  ) THEN

 IF ISVALID(W_ITEM_IMAGE_FLAT) THEN
	RETURN
ELSE
	   OPENWITHPARM(W_ITEM_IMAGE_FLAT , STRING(THIS.OBJECT.ITEM_CODE[ROW]))
END IF 
ELSE

IF isvalid(W_ITEM_IMAGE_FLAT) then
	close(W_ITEM_IMAGE_FLAT)
end if 
END IF
end event

event ue_dwkey;if key = keyf8! then 
string ivs_select

if isvalid(dw_1) then 
	ivs_select = dw_1.Describe("DataWindow.Selected.Data")

   openwithparm(w_edit_window ,ivs_select )

end if
end if 
end event

event constructor;THIS.SETROWFOCUSINDICATOR( HAND!)	
end event

event retrievestart;setrow = 0 
end event

event retrieverow;setrow = setrow + 1 
end event

event retrieveend;ST_MSG.TEXT = STRING(SETROW)+" Rows Retrieved"
end event

event dberror;IF ISVALID(W_CANCEL_RETRIEVE_POP) THEN 
	CLOSE(W_CANCEL_RETRIEVE_POP)
END IF

STRING LVS_COLUMN_NAME ,LVS_COLUMN_NAME_LOCAL , LVS_COLUMN_DESC_LOCAL , LVS_COLOR 
STRING LVS_TABLE_NAME , LVS_CONSTRAINTS_NAME
Gvs_DberrorMessage = sqlerrtext
Gvl_DberrorCode   = sqldbcode
Gvs_error_syntax = sqlsyntax
Gvl_error_row = row

f_screen_capture()		

IF   sqldbcode = 1 THEN // UNIQUE CHECK

      F_MSGBOX1( 125 , "Row NUmber="+STRING(Gvl_error_row) )
	 return  1

ELSEIF sqldbcode = 2291 THEN // CONSTRAINTS CHECK PARENT NOT FOUND
	
	LVS_CONSTRAINTS_NAME = MID( sqlerrtext , POS( sqlerrtext , '.' ,1 ) + 1 ,   POS(sqlerrtext , ')' ) - ( POS( sqlerrtext , '.' ,1 )  +1 )  )
	LVS_TABLE_NAME = F_GET_CONSTRAINTS_TABLE_NAME(LVS_CONSTRAINTS_NAME) 
	F_MSGBOX2(196, 'SQLCODE='+STRING(SQLCA.SQLCODE)+'  '+LVS_CONSTRAINTS_NAME , LVS_TABLE_NAME )		
	return 1
ELSEIF sqldbcode = 2292 THEN // CONSTRAINTS CHECK CHILD  FOUND CAN`T DELETE
     
    //ORA-02292: integrity constraint (LANSHENG.SYS_C0047281) violated - child record found	
	 
	LVS_CONSTRAINTS_NAME = MID( sqlerrtext , POS( sqlerrtext , '.' ,1 ) + 1 ,   POS(sqlerrtext , ')' ) - ( POS( sqlerrtext , '.' ,1 )  +1 )  )
	LVS_TABLE_NAME = F_GET_CONSTRAINTS_TABLE_NAME(LVS_CONSTRAINTS_NAME) 
	F_MSGBOX2(162, STRING(SQLCA.SQLCODE)+'  '+LVS_CONSTRAINTS_NAME , LVS_TABLE_NAME )		
	return 1
ELSEIF sqldbcode = 1400 THEN // NULL CHECK
	
	//ORA-01400: CANNOT INSERT NULL INTO ("TAPM"."CORRELATOR"."CORRELATOR_ID")

	LVS_COLUMN_NAME = MID( sqlerrtext , POS( sqlerrtext , '.' ,1 ) + 2 ,   POS(sqlerrtext , ')' ) - POS( sqlerrtext , '.' ,1 ) + 2     )
	LVS_COLUMN_NAME = MID( LVS_COLUMN_NAME , POS( LVS_COLUMN_NAME , '.' ,1 ) + 2 , LEN(LVS_COLUMN_NAME)  -  POS( LVS_COLUMN_NAME , '.' ,1 )  - 6 ) 
	
	SELECT DECODE( :GVS_LANGUAGE , 'K' , WORD_KOR , 'E' , WORD_ENG , WORD_LOCAL ) ,
             	   DECODE( :GVS_LANGUAGE , 'K' , WORD_DESCRIPTION_KOR , 'E' , WORD_DESCRIPTION_ENG , WORD_DESCRIPTION_LOCAL ) 
	   INTO :LVS_COLUMN_NAME_LOCAL , :LVS_COLUMN_DESC_LOCAL
	  FROM ISYS_WORD_DICTIONARY
    WHERE WORD_ENG = :LVS_COLUMN_NAME
	    AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID;
	 
	IF F_SQL_CHECK() < 0 THEN 
		RETURN 1
	END IF
	
	LVS_COLOR = THIS.DESCRIBE( LVS_COLUMN_NAME+".Background.Color")	
	
	IF SQLCA.SQLCODE = 100 THEN 
		 THIS.Modify ( LVS_COLUMN_NAME+".Background.Color='"+"255"+"'" )
		 THIS.Modify ( LVS_COLUMN_NAME+".Background.Color='"+LVS_COLOR+"'" )	 
		 THIS.Modify ( LVS_COLUMN_NAME+".Background.Color='"+"255"+"'" )
		 F_MSGBOX1(111, LVS_COLUMN_NAME+'~r~n'+sqlerrtext )				 
	ELSE
		 THIS.Modify ( LVS_COLUMN_NAME+".Background.Color='"+"255"+"'" )
		 THIS.Modify ( LVS_COLUMN_NAME+".Background.Color='"+LVS_COLOR+"'" )	 
		 THIS.Modify ( LVS_COLUMN_NAME+".Background.Color='"+"255"+"'" )
		F_MSGBOX1(111, "["+LVS_COLUMN_NAME_LOCAL+"]"+'~r~n'+"["+LVS_COLUMN_DESC_LOCAL+"]"+'~r~n')		        
	END IF
	
	THIS.SETFOCUS()
	THIS.SETROW(row)
	THIS.SETCOLUMN( LVS_COLUMN_NAME )
     THIS.Modify ( LVS_COLUMN_NAME+".Background.Color='"+LVS_COLOR+"'" )	 			
	RETURN 1 
	
END IF


//=========================================================
// Error Log Trace
//=========================================================
if Gvs_error_log_trace_yn = 'Y' then
	f_set_error_log_trace( w_main_frame.Getactivesheet() , 'DW_1' , 0 , ''  , Gvl_DberrorCode , Gvs_DberrorMessage , Gvs_error_syntax ) 
end if 
//=========================================================

OPEN(W_ERROR_MESSAGE)

IF ISVALID(W_CANCEL_RETRIEVE_POP) THEN 
	CLOSE(W_CANCEL_RETRIEVE_POP)
END IF	
Return 1 // PB $$HEX33$$90c7b4ccd0c51cc12000b4b0f4bcb4b094b22000dcc2a4c25cd12000d0c5ecb7200054ba38c1c0c9200015bca4c220009ccd25b844c72000c9b930ae04c774d52000$$ENDHEX$$1 $$HEX7$$44c72000acb934d120005cd5e4b2$$ENDHEX$$.




end event

event doubleclicked; IF  UPPER(DWO.TYPE) = 'TEXT' AND  UPPER(DWO.NAME) = 'CHECK_YN_T' THEN
      Long i
		
	if this.object.check_yn_t.tag  = 'Y' then 	
		
		do
			i++
			this.object.check_yn[i] = 'N' 
		loop until i = this.rowcount()
		this.object.check_yn_t.tag  = 'N' 
	else
		
		do
			i++
			this.object.check_yn[i] = 'Y' 
		loop until i = this.rowcount()
		this.object.check_yn_t.tag  = 'Y' 
		
	end if
		
END IF
end event

type dw_2 from datawindow within w_popup_root
event uo_mousemove pbm_dwnmousemove
boolean visible = false
integer y = 384
integer width = 526
integer height = 424
integer taborder = 100
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

event uo_mousemove;IF IVS_MOUSEMOVE_YN = 'Y'  THEN 

	IF ROW < 1 THEN RETURN 
	IF Gvl_CurrentRow = ROW  THEN RETURN 
	IF THIS.ROWCOUNT() = 1 THEN RETURN 
	
	Gvl_CurrentRow = ROW
	
		IF THIS.ISSELECTED(row) = TRUE THEN 
			THIS.SELECTROW(0 , FALSE )	
			THIS.SELECTROW(row , FALSE )
		ELSE
			THIS.SELECTROW(0 , FALSE )		
			THIS.SELECTROW(row , TRUE )
			THIS.SETROW(ROW)
		END IF
	
	
END IF

 IF  UPPER(DWO.TYPE) = 'TEXT' AND  UPPER(DWO.NAME) = 'CHECK_YN_T' THEN
       THIS.Modify("CHECK_YN_T.Pointer='HAND.ANI'")	 
END IF

if row < 1 then return
IF   GVS_SHOW_ITEM_IMAGE = 'Y' AND ( UPPER(DWO.TYPE) = 'COLUMN' AND  UPPER(DWO.NAME) = 'ITEM_CODE'  ) THEN

 IF ISVALID(W_ITEM_IMAGE_FLAT) THEN
	RETURN
ELSE
	   OPENWITHPARM(W_ITEM_IMAGE_FLAT , STRING(THIS.OBJECT.ITEM_CODE[ROW]))
END IF 
ELSE

IF isvalid(W_ITEM_IMAGE_FLAT) then
	close(W_ITEM_IMAGE_FLAT)
end if 
END IF
end event

event clicked;//************************************************************************************
// QUICK SORT $$HEX2$$98ccacb9$$ENDHEX$$
//************************************************************************************
if UPPER(DWO.TYPE) = 'TEXT' then	
	IF row = 0 THEN 				
		F_QUICK_SORT(THIS , MID(STRING(DWO.NAME),1,LEN(STRING(DWO.NAME)) - 2) )
		this.groupcalc( )
	END IF
end if 
end event

event constructor;THIS.SETROWFOCUSINDICATOR( HAND!)	
end event

event retrieveend;ST_MSG.TEXT = STRING(SETROW)+" Rows Retrieved"
end event

event retrieverow;setrow = setrow + 1 
end event

event retrievestart;setrow = 0 
end event

event dberror;IF ISVALID(W_CANCEL_RETRIEVE_POP) THEN 
	CLOSE(W_CANCEL_RETRIEVE_POP)
END IF

STRING LVS_COLUMN_NAME ,LVS_COLUMN_NAME_LOCAL , LVS_COLUMN_DESC_LOCAL , LVS_COLOR 
STRING LVS_TABLE_NAME , LVS_CONSTRAINTS_NAME
Gvs_DberrorMessage = sqlerrtext
Gvl_DberrorCode   = sqldbcode
Gvs_error_syntax = sqlsyntax
Gvl_error_row = row

f_screen_capture()		

IF   sqldbcode = 1 THEN // UNIQUE CHECK

      F_MSGBOX1( 125 , "Row NUmber="+STRING(Gvl_error_row) )
	 return  1

ELSEIF sqldbcode = 2291 THEN // CONSTRAINTS CHECK PARENT NOT FOUND
	
	LVS_CONSTRAINTS_NAME = MID( sqlerrtext , POS( sqlerrtext , '.' ,1 ) + 1 ,   POS(sqlerrtext , ')' ) - ( POS( sqlerrtext , '.' ,1 )  +1 )  )
	LVS_TABLE_NAME = F_GET_CONSTRAINTS_TABLE_NAME(LVS_CONSTRAINTS_NAME) 
	F_MSGBOX2(196, 'SQLCODE='+STRING(SQLCA.SQLCODE)+'  '+LVS_CONSTRAINTS_NAME , LVS_TABLE_NAME )		
	return 1

ELSEIF sqldbcode = 2292 THEN // CONSTRAINTS CHECK CHILD  FOUND CAN`T DELETE
     
    //ORA-02292: integrity constraint (LANSHENG.SYS_C0047281) violated - child record found	
	 
	LVS_CONSTRAINTS_NAME = MID( sqlerrtext , POS( sqlerrtext , '.' ,1 ) + 1 ,   POS(sqlerrtext , ')' ) - ( POS( sqlerrtext , '.' ,1 )  +1 )  )
	LVS_TABLE_NAME = F_GET_CONSTRAINTS_TABLE_NAME(LVS_CONSTRAINTS_NAME) 
	F_MSGBOX2(162, STRING(SQLCA.SQLCODE)+'  '+LVS_CONSTRAINTS_NAME , LVS_TABLE_NAME )		
	return 1
ELSEIF sqldbcode = 1400 THEN // NULL CHECK
	
	//ORA-01400: CANNOT INSERT NULL INTO ("TAPM"."CORRELATOR"."CORRELATOR_ID")

	LVS_COLUMN_NAME = MID( sqlerrtext , POS( sqlerrtext , '.' ,1 ) + 2 ,   POS(sqlerrtext , ')' ) - POS( sqlerrtext , '.' ,1 ) + 2     )
	LVS_COLUMN_NAME = MID( LVS_COLUMN_NAME , POS( LVS_COLUMN_NAME , '.' ,1 ) + 2 , LEN(LVS_COLUMN_NAME)  -  POS( LVS_COLUMN_NAME , '.' ,1 )  - 6 ) 
	
	SELECT DECODE( :GVS_LANGUAGE , 'K' , WORD_KOR , 'E' , WORD_ENG , WORD_LOCAL ) ,
             	   DECODE( :GVS_LANGUAGE , 'K' , WORD_DESCRIPTION_KOR , 'E' , WORD_DESCRIPTION_ENG , WORD_DESCRIPTION_LOCAL ) 
	   INTO :LVS_COLUMN_NAME_LOCAL , :LVS_COLUMN_DESC_LOCAL
	  FROM ISYS_WORD_DICTIONARY
    WHERE WORD_ENG = :LVS_COLUMN_NAME
	    AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID;
	 
	IF F_SQL_CHECK() < 0 THEN 
		RETURN 1
	END IF
	
	LVS_COLOR = THIS.DESCRIBE( LVS_COLUMN_NAME+".Background.Color")	
	
	IF SQLCA.SQLCODE = 100 THEN 
		 THIS.Modify ( LVS_COLUMN_NAME+".Background.Color='"+"255"+"'" )
		 THIS.Modify ( LVS_COLUMN_NAME+".Background.Color='"+LVS_COLOR+"'" )	 
		 THIS.Modify ( LVS_COLUMN_NAME+".Background.Color='"+"255"+"'" )
		 F_MSGBOX1(111, LVS_COLUMN_NAME+'~r~n'+sqlerrtext )				 
	ELSE
		 THIS.Modify ( LVS_COLUMN_NAME+".Background.Color='"+"255"+"'" )
		 THIS.Modify ( LVS_COLUMN_NAME+".Background.Color='"+LVS_COLOR+"'" )	 
		 THIS.Modify ( LVS_COLUMN_NAME+".Background.Color='"+"255"+"'" )
		F_MSGBOX1(111, "["+LVS_COLUMN_NAME_LOCAL+"]"+'~r~n'+"["+LVS_COLUMN_DESC_LOCAL+"]"+'~r~n')		        
	END IF
	
	THIS.SETFOCUS()
	THIS.SETROW(row)
	THIS.SETCOLUMN( LVS_COLUMN_NAME )
     THIS.Modify ( LVS_COLUMN_NAME+".Background.Color='"+LVS_COLOR+"'" )	 			
	RETURN 1 
	
END IF


//=========================================================
// Error Log Trace
//=========================================================
if Gvs_error_log_trace_yn = 'Y' then
	f_set_error_log_trace( w_main_frame.Getactivesheet() , 'DW_1' , 0 , ''  , Gvl_DberrorCode , Gvs_DberrorMessage , Gvs_error_syntax ) 
end if 
//=========================================================

OPEN(W_ERROR_MESSAGE)

IF ISVALID(W_CANCEL_RETRIEVE_POP) THEN 
	CLOSE(W_CANCEL_RETRIEVE_POP)
END IF	
Return 1 // PB $$HEX33$$90c7b4ccd0c51cc12000b4b0f4bcb4b094b22000dcc2a4c25cd12000d0c5ecb7200054ba38c1c0c9200015bca4c220009ccd25b844c72000c9b930ae04c774d52000$$ENDHEX$$1 $$HEX7$$44c72000acb934d120005cd5e4b2$$ENDHEX$$.




end event

event doubleclicked; IF  UPPER(DWO.TYPE) = 'TEXT' AND  UPPER(DWO.NAME) = 'CHECK_YN_T' THEN
      Long i
		
	if this.object.check_yn_t.tag  = 'Y' then 	
		
		do
			i++
			this.object.check_yn[i] = 'N' 
		loop until i = this.rowcount()
		this.object.check_yn_t.tag  = 'N' 
	else
		
		do
			i++
			this.object.check_yn[i] = 'Y' 
		loop until i = this.rowcount()
		this.object.check_yn_t.tag  = 'Y' 
		
	end if
		
END IF
end event

type dw_3 from datawindow within w_popup_root
event uo_mousemove pbm_dwnmousemove
boolean visible = false
integer y = 384
integer width = 526
integer height = 424
integer taborder = 110
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

event uo_mousemove;IF IVS_MOUSEMOVE_YN = 'Y'  THEN 

	IF ROW < 1 THEN RETURN 
	IF Gvl_CurrentRow = ROW  THEN RETURN 
	IF THIS.ROWCOUNT() = 1 THEN RETURN 
	
	Gvl_CurrentRow = ROW
	
		IF THIS.ISSELECTED(row) = TRUE THEN 
			THIS.SELECTROW(0 , FALSE )	
			THIS.SELECTROW(row , FALSE )
		ELSE
			THIS.SELECTROW(0 , FALSE )		
			THIS.SELECTROW(row , TRUE )
			THIS.SETROW(ROW)
		END IF
	
	
END IF

 IF  UPPER(DWO.TYPE) = 'TEXT' AND  UPPER(DWO.NAME) = 'CHECK_YN_T' THEN
       THIS.Modify("CHECK_YN_T.Pointer='HAND.ANI'")	 
END IF

if row < 1 then return
IF   GVS_SHOW_ITEM_IMAGE = 'Y' AND ( UPPER(DWO.TYPE) = 'COLUMN' AND  UPPER(DWO.NAME) = 'ITEM_CODE'  ) THEN

 IF ISVALID(W_ITEM_IMAGE_FLAT) THEN
	RETURN
ELSE
	   OPENWITHPARM(W_ITEM_IMAGE_FLAT , STRING(THIS.OBJECT.ITEM_CODE[ROW]))
END IF 
ELSE

IF isvalid(W_ITEM_IMAGE_FLAT) then
	close(W_ITEM_IMAGE_FLAT)
end if 
END IF
end event

event clicked;//************************************************************************************
// QUICK SORT $$HEX2$$98ccacb9$$ENDHEX$$
//************************************************************************************
if UPPER(DWO.TYPE) = 'TEXT' then	
	IF row = 0 THEN 				
		F_QUICK_SORT(THIS , MID(STRING(DWO.NAME),1,LEN(STRING(DWO.NAME)) - 2) )
		this.groupcalc( )
	END IF
end if 
end event

event constructor;THIS.SETROWFOCUSINDICATOR( HAND!)	
end event

event dberror;IF ISVALID(W_CANCEL_RETRIEVE_POP) THEN 
	CLOSE(W_CANCEL_RETRIEVE_POP)
END IF

STRING LVS_COLUMN_NAME ,LVS_COLUMN_NAME_LOCAL , LVS_COLUMN_DESC_LOCAL , LVS_COLOR 
STRING LVS_TABLE_NAME , LVS_CONSTRAINTS_NAME
Gvs_DberrorMessage = sqlerrtext
Gvl_DberrorCode   = sqldbcode
Gvs_error_syntax = sqlsyntax
Gvl_error_row = row

f_screen_capture()		

IF   sqldbcode = 1 THEN // UNIQUE CHECK

      F_MSGBOX1( 125 , "Row NUmber="+STRING(Gvl_error_row) )
	 return  1

ELSEIF sqldbcode = 2291 THEN // CONSTRAINTS CHECK PARENT NOT FOUND
	
	LVS_CONSTRAINTS_NAME = MID( sqlerrtext , POS( sqlerrtext , '.' ,1 ) + 1 ,   POS(sqlerrtext , ')' ) - ( POS( sqlerrtext , '.' ,1 )  +1 )  )
	LVS_TABLE_NAME = F_GET_CONSTRAINTS_TABLE_NAME(LVS_CONSTRAINTS_NAME) 
	F_MSGBOX2(196, 'SQLCODE='+STRING(SQLCA.SQLCODE)+'  '+LVS_CONSTRAINTS_NAME , LVS_TABLE_NAME )		
	return 1

ELSEIF sqldbcode = 2292 THEN // CONSTRAINTS CHECK CHILD  FOUND CAN`T DELETE
     
    //ORA-02292: integrity constraint (LANSHENG.SYS_C0047281) violated - child record found	
	 
	LVS_CONSTRAINTS_NAME = MID( sqlerrtext , POS( sqlerrtext , '.' ,1 ) + 1 ,   POS(sqlerrtext , ')' ) - ( POS( sqlerrtext , '.' ,1 )  +1 )  )
	LVS_TABLE_NAME = F_GET_CONSTRAINTS_TABLE_NAME(LVS_CONSTRAINTS_NAME) 
	F_MSGBOX2(162, STRING(SQLCA.SQLCODE)+'  '+LVS_CONSTRAINTS_NAME , LVS_TABLE_NAME )		
	return 1
ELSEIF sqldbcode = 1400 THEN // NULL CHECK
	
	//ORA-01400: CANNOT INSERT NULL INTO ("TAPM"."CORRELATOR"."CORRELATOR_ID")

	LVS_COLUMN_NAME = MID( sqlerrtext , POS( sqlerrtext , '.' ,1 ) + 2 ,   POS(sqlerrtext , ')' ) - POS( sqlerrtext , '.' ,1 ) + 2     )
	LVS_COLUMN_NAME = MID( LVS_COLUMN_NAME , POS( LVS_COLUMN_NAME , '.' ,1 ) + 2 , LEN(LVS_COLUMN_NAME)  -  POS( LVS_COLUMN_NAME , '.' ,1 )  - 6 ) 
	
	SELECT DECODE( :GVS_LANGUAGE , 'K' , WORD_KOR , 'E' , WORD_ENG , WORD_LOCAL ) ,
             	   DECODE( :GVS_LANGUAGE , 'K' , WORD_DESCRIPTION_KOR , 'E' , WORD_DESCRIPTION_ENG , WORD_DESCRIPTION_LOCAL ) 
	   INTO :LVS_COLUMN_NAME_LOCAL , :LVS_COLUMN_DESC_LOCAL
	  FROM ISYS_WORD_DICTIONARY
    WHERE WORD_ENG = :LVS_COLUMN_NAME
	    AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID;
	 
	IF F_SQL_CHECK() < 0 THEN 
		RETURN 1
	END IF
	
	LVS_COLOR = THIS.DESCRIBE( LVS_COLUMN_NAME+".Background.Color")	
	
	IF SQLCA.SQLCODE = 100 THEN 
		 THIS.Modify ( LVS_COLUMN_NAME+".Background.Color='"+"255"+"'" )
		 THIS.Modify ( LVS_COLUMN_NAME+".Background.Color='"+LVS_COLOR+"'" )	 
		 THIS.Modify ( LVS_COLUMN_NAME+".Background.Color='"+"255"+"'" )
		 F_MSGBOX1(111, LVS_COLUMN_NAME+'~r~n'+sqlerrtext )				 
	ELSE
		 THIS.Modify ( LVS_COLUMN_NAME+".Background.Color='"+"255"+"'" )
		 THIS.Modify ( LVS_COLUMN_NAME+".Background.Color='"+LVS_COLOR+"'" )	 
		 THIS.Modify ( LVS_COLUMN_NAME+".Background.Color='"+"255"+"'" )
		F_MSGBOX1(111, "["+LVS_COLUMN_NAME_LOCAL+"]"+'~r~n'+"["+LVS_COLUMN_DESC_LOCAL+"]"+'~r~n')		        
	END IF
	
	THIS.SETFOCUS()
	THIS.SETROW(row)
	THIS.SETCOLUMN( LVS_COLUMN_NAME )
     THIS.Modify ( LVS_COLUMN_NAME+".Background.Color='"+LVS_COLOR+"'" )	 			
	RETURN 1 
	
END IF


//=========================================================
// Error Log Trace
//=========================================================
if Gvs_error_log_trace_yn = 'Y' then
	f_set_error_log_trace( w_main_frame.Getactivesheet() , 'DW_1' , 0 , ''  , Gvl_DberrorCode , Gvs_DberrorMessage , Gvs_error_syntax ) 
end if 
//=========================================================

OPEN(W_ERROR_MESSAGE)

IF ISVALID(W_CANCEL_RETRIEVE_POP) THEN 
	CLOSE(W_CANCEL_RETRIEVE_POP)
END IF	
Return 1 // PB $$HEX33$$90c7b4ccd0c51cc12000b4b0f4bcb4b094b22000dcc2a4c25cd12000d0c5ecb7200054ba38c1c0c9200015bca4c220009ccd25b844c72000c9b930ae04c774d52000$$ENDHEX$$1 $$HEX7$$44c72000acb934d120005cd5e4b2$$ENDHEX$$.




end event

event doubleclicked; IF  UPPER(DWO.TYPE) = 'TEXT' AND  UPPER(DWO.NAME) = 'CHECK_YN_T' THEN
      Long i
		
	if this.object.check_yn_t.tag  = 'Y' then 	
		
		do
			i++
			this.object.check_yn[i] = 'N' 
		loop until i = this.rowcount()
		this.object.check_yn_t.tag  = 'N' 
	else
		
		do
			i++
			this.object.check_yn[i] = 'Y' 
		loop until i = this.rowcount()
		this.object.check_yn_t.tag  = 'Y' 
		
	end if
		
END IF
end event

event retrieveend;ST_MSG.TEXT = STRING(SETROW)+" Rows Retrieved"
end event

event retrieverow;setrow = setrow + 1 
end event

event retrievestart;setrow = 0 
end event

