HA$PBExportHeader$w_dataobject_master.srw
$PBExportComments$DB Object  Information Manage
forward
global type w_dataobject_master from w_main_root
end type
type st_2 from so_statictext within w_dataobject_master
end type
type sle_window_name from singlelineedit within w_dataobject_master
end type
type sle_dataobject_name from singlelineedit within w_dataobject_master
end type
type st_1 from so_statictext within w_dataobject_master
end type
type mle_syntax from so_multilineedit within w_dataobject_master
end type
type cb_1 from so_commandbutton within w_dataobject_master
end type
type cb_2 from so_commandbutton within w_dataobject_master
end type
type gb_1 from groupbox within w_dataobject_master
end type
end forward

global type w_dataobject_master from w_main_root
integer width = 4974
integer height = 2620
string title = "Object Master"
st_2 st_2
sle_window_name sle_window_name
sle_dataobject_name sle_dataobject_name
st_1 st_1
mle_syntax mle_syntax
cb_1 cb_1
cb_2 cb_2
gb_1 gb_1
end type
global w_dataobject_master w_dataobject_master

type variables
//
end variables

on w_dataobject_master.create
int iCurrent
call super::create
this.st_2=create st_2
this.sle_window_name=create sle_window_name
this.sle_dataobject_name=create sle_dataobject_name
this.st_1=create st_1
this.mle_syntax=create mle_syntax
this.cb_1=create cb_1
this.cb_2=create cb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.sle_window_name
this.Control[iCurrent+3]=this.sle_dataobject_name
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.mle_syntax
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.gb_1
end on

on w_dataobject_master.destroy
call super::destroy
destroy(this.st_2)
destroy(this.sle_window_name)
destroy(this.sle_dataobject_name)
destroy(this.st_1)
destroy(this.mle_syntax)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.gb_1)
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

F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control

/****************************************
* 
****************************************/

end event

event ue_data_control;call super::ue_data_control;Long ROW
string	ls_window, ls_dataobject , ls_syntax
blob lblob_syntax

CHOOSE CASE Gvs_Ue_DATA_control
	CASE 'RETRIEVE'
		
				dw_1.retrieve( sle_window_name.text+'%', sle_dataobject_name.text+'%' , gvi_organization_id )
			
	CASE 'INSERT'
			ROW = DW_1.INSERTROW(DW_1.GETROW())
			DW_1.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_1 , ROW , 'ALL')

	
			ls_window		=	sle_window_name.text
			ls_dataobject	=	sle_dataobject_name.text

			dw_1.object.window_name[ROW]		=	ls_window
			dw_1.object.dataobject_name[ROW]	=	ls_dataobject
			dw_1.object.report_no[ROW]			=	1
			dw_1.object.use_flag[ROW]				=	'Y'
		
			dw_1.selectrow(0,false)
			dw_1.setrow(ROW)
			dw_1.selectrow(ROW,true)

	CASE 'APPEND'
			ROW = DW_1.INSERTROW(0)
			DW_1.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_1 , ROW , 'ALL')	
	
			ls_window		=	sle_window_name.text
			ls_dataobject	=	sle_dataobject_name.text

			dw_1.object.window_name[ROW]		=	ls_window
			dw_1.object.dataobject_name[ROW]	=	ls_dataobject
			dw_1.object.report_no[ROW]			=	1
			dw_1.object.use_flag[ROW]				=	'Y'
		
			dw_1.selectrow(0,false)
			dw_1.setrow(1)
			dw_1.selectrow(1,true)			
			
			
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
				ls_syntax		=	mle_syntax.text
				lblob_syntax	=	blob(ls_syntax)
				
				if ls_syntax = '' then
					return
				end if 
				
				
				ls_window		=	dw_1.object.window_name[dw_1.getrow()]
				ls_dataobject	=	dw_1.object.dataobject_name[dw_1.getrow()]
				
				updateblob	isys_dataobject
				set			do_syntax			=	:lblob_syntax
				where	organization_id					=	:gvi_organization_id 
				and		window_name			=	:ls_window
				and		dataobject_name		=	:ls_dataobject
				;
		
				if	f_sql_check() < 0 then
					return
				end if 
				
			     COMMIT;
				 F_MSG_MDI_HELP( F_MSG_ST( 170) ) 
			END IF

	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
dw_1.height = dw_1.height - mle_syntax.height
mle_syntax.x = dw_1.x
mle_syntax.y = dw_1.y + dw_1.height 
mle_syntax.width = dw_1.width
end event

event resize;call super::resize;dw_1.height = dw_1.height - mle_syntax.height
mle_syntax.x = dw_1.x
mle_syntax.y = dw_1.y + dw_1.height 
mle_syntax.width = dw_1.width
end event

type dw_5 from w_main_root`dw_5 within w_dataobject_master
integer y = 292
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_dataobject_master
integer y = 292
integer taborder = 50
end type

type dw_3 from w_main_root`dw_3 within w_dataobject_master
integer y = 292
integer taborder = 60
end type

type dw_2 from w_main_root`dw_2 within w_dataobject_master
integer y = 292
integer width = 4507
integer height = 1064
integer taborder = 70
boolean titlebar = true
string title = "Preview"
end type

type dw_1 from w_main_root`dw_1 within w_dataobject_master
integer y = 292
integer width = 4507
integer height = 1064
integer taborder = 0
boolean titlebar = true
string title = "Object List"
string dataobject = "d_dataobject_lst"
end type

event dw_1::doubleclicked;call super::doubleclicked;if row < 1 then 
	return
end if

dw_2.retrieve( dw_1.object.object_name[row] )
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;string		ls_syntax,		&
			ls_window,		&	
			ls_dataobject
blob		lblob_syntax

if currentrow < 1 then return

setpointer(Hourglass!)

ls_window		=	object.window_name[currentrow]
ls_dataobject	=	object.dataobject_name[currentrow]

SELECTBLOB	DO_SYNTAX
INTO		:lblob_syntax
FROM		ISYS_DATAOBJECT
WHERE	ORGANIZATION_ID						=	:gvi_organization_id
AND		WINDOW_NAME			=	:ls_window
AND		DATAOBJECT_NAME		=	:ls_dataobject
;

if isnull(lblob_syntax) then	
	mle_syntax.text	=	''
else
	ls_syntax			=	string(lblob_syntax)
	mle_syntax.text	=	ls_syntax
end if
end event

type uo_tabpages from w_main_root`uo_tabpages within w_dataobject_master
end type

type st_2 from so_statictext within w_dataobject_master
integer x = 50
integer y = 68
integer width = 878
integer height = 60
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Window Name"
end type

type sle_window_name from singlelineedit within w_dataobject_master
event ue_editchange pbm_enchange
integer x = 50
integer y = 132
integer width = 878
integer height = 96
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

type sle_dataobject_name from singlelineedit within w_dataobject_master
event ue_editchange pbm_enchange
integer x = 942
integer y = 132
integer width = 878
integer height = 96
integer taborder = 20
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

type st_1 from so_statictext within w_dataobject_master
integer x = 942
integer y = 64
integer width = 878
integer height = 60
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "DataObject Name"
end type

type mle_syntax from so_multilineedit within w_dataobject_master
integer y = 1372
integer width = 4507
integer height = 1120
integer taborder = 60
boolean bringtotop = true
string text = ""
boolean hscrollbar = true
boolean vscrollbar = true
boolean autohscroll = true
boolean autovscroll = true
end type

type cb_1 from so_commandbutton within w_dataobject_master
integer x = 1938
integer y = 72
integer height = 140
integer taborder = 20
boolean bringtotop = true
string text = "Edit Mode"
end type

event clicked;call super::clicked;dw_1.bringtotop = true
mle_syntax.bringtotop = true

end event

type cb_2 from so_commandbutton within w_dataobject_master
integer x = 2487
integer y = 72
integer height = 140
integer taborder = 20
boolean bringtotop = true
string text = "Preview"
end type

event clicked;call super::clicked;STRING ls_syntax
if dw_1.getrow() < 1 then return 


ls_syntax	=	f_get_dataobject('REPORT', dw_1.object.window_name[dw_1.getrow()], dw_1.object.dataobject_name[dw_1.getrow()])
if	ls_syntax = '' or isnull(ls_syntax) then
	dw_2.dataobject  			= 'd_null_datawindow'
else
	dw_2.create(ls_syntax)
	
	dw_2.Modify("DataWindow.Print.Preview.Rulers=yes")
	
	dw_2.bringtotop = true
	dw_2.insertrow(0)
end if
end event

type gb_1 from groupbox within w_dataobject_master
integer y = 12
integer width = 1870
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

