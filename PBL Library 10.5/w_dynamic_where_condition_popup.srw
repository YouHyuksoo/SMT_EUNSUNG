HA$PBExportHeader$w_dynamic_where_condition_popup.srw
$PBExportComments$$$HEX11$$acb9ecd3b8d208c7c4b3b0c670c874ac08c81dd3c5c5$$ENDHEX$$
forward
global type w_dynamic_where_condition_popup from w_popup_root
end type
type cb_retrieve_all from commandbutton within w_dynamic_where_condition_popup
end type
type cb_retrieve from commandbutton within w_dynamic_where_condition_popup
end type
type cbx_show_sql from checkbox within w_dynamic_where_condition_popup
end type
type cbx_auto_close from checkbox within w_dynamic_where_condition_popup
end type
type tab_1 from tab within w_dynamic_where_condition_popup
end type
type tabpage_1 from userobject within tab_1
end type
type tdw_3 from so_datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_1
tdw_3 tdw_3
end type
type tabpage_2 from userobject within tab_1
end type
type dw_4 from so_datawindow within tabpage_2
end type
type cb_1 from commandbutton within tabpage_2
end type
type cb_5 from commandbutton within tabpage_2
end type
type cb_4 from commandbutton within tabpage_2
end type
type cb_3 from commandbutton within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_4 dw_4
cb_1 cb_1
cb_5 cb_5
cb_4 cb_4
cb_3 cb_3
end type
type tab_1 from tab within w_dynamic_where_condition_popup
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type gb_1 from so_groupbox within w_dynamic_where_condition_popup
end type
type gb_2 from so_groupbox within w_dynamic_where_condition_popup
end type
end forward

global type w_dynamic_where_condition_popup from w_popup_root
integer width = 3063
integer height = 1972
string title = "Where Condition"
boolean controlmenu = false
windowtype windowtype = popup!
cb_retrieve_all cb_retrieve_all
cb_retrieve cb_retrieve
cbx_show_sql cbx_show_sql
cbx_auto_close cbx_auto_close
tab_1 tab_1
gb_1 gb_1
gb_2 gb_2
end type
global w_dynamic_where_condition_popup w_dynamic_where_condition_popup

type variables
DATAWINDOW ARG_DW
String ivs_window_name , ivs_datawindow_name
end variables

on w_dynamic_where_condition_popup.create
int iCurrent
call super::create
this.cb_retrieve_all=create cb_retrieve_all
this.cb_retrieve=create cb_retrieve
this.cbx_show_sql=create cbx_show_sql
this.cbx_auto_close=create cbx_auto_close
this.tab_1=create tab_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve_all
this.Control[iCurrent+2]=this.cb_retrieve
this.Control[iCurrent+3]=this.cbx_show_sql
this.Control[iCurrent+4]=this.cbx_auto_close
this.Control[iCurrent+5]=this.tab_1
this.Control[iCurrent+6]=this.gb_1
this.Control[iCurrent+7]=this.gb_2
end on

on w_dynamic_where_condition_popup.destroy
call super::destroy
destroy(this.cb_retrieve_all)
destroy(this.cb_retrieve)
destroy(this.cbx_show_sql)
destroy(this.cbx_auto_close)
destroy(this.tab_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;ivs_window_name = GST_RETURN.GVS_RETURN[1]
ivs_datawindow_name  = GST_RETURN.GVS_RETURN[2]

tab_1.tabpage_1.tdw_3.settransobject(sqlca)
tab_1.tabpage_2.dw_4.settransobject(sqlca)

CB_RETRIEVE_ALL.SETFOcus( )
CB_RETRIEVE.SETFOcus( )
CB_CLOSE.SETFOcus( )

//===============================
//
//===============================
ARG_DW = MESSAGE.POWERobjectparm
STRING LVS_COLUMN_NAME , LVS_COLUMN_DESC  ,LVS_OPERATION ,LVS_DATA_TYPE , LVS_DEFAULT_VALUE , LVS_RELATION
INT LVI_COUNT , LVI_ROWS

DECLARE CL1 CURSOR FOR
SELECT COLUMN_NAME , COLUMN_DESC  , OPERATION ,DATA_TYPE , DEFAULT_VALUE  , RELATION 
    FROM ISYS_REPORT_WHERE_CONDITION
	 
 WHERE WINDOW_NAME          = :ivs_window_name
      AND DATAWINDOW_NAME = :ivs_datawindow_name
	 AND ORGANIZATION_ID     = :GVI_ORGANIZATION_ID ;
	 
	 IF F_SQL_CHECK() < 0 THEN 
		RETURN 
	END IF
	 
	 OPEN CL1 ;
	 DO
		
		
		FETCH CL1  INTO :LVS_COLUMN_NAME , :LVS_COLUMN_DESC  , :LVS_OPERATION ,:LVS_DATA_TYPE , :LVS_DEFAULT_VALUE  ,:LVS_RELATION ;
		
		IF F_SQL_CHECK() < 0 THEN 
			CLOSE CL1 ;
			EXIT
		END IF
		
		IF SQLCA.SQLCODE = 100 THEN 
			CLOSE CL1 ;
			EXIT
		END IF
		
		
	      LVI_ROWS=  DW_1.INSERTROW( 0)
		 
		 DW_1.OBJECT.COLUMN_NAME[LVI_ROWS] = LVS_COLUMN_NAME
 		 DW_1.OBJECT.DATA_TYPE[LVI_ROWS]       = LVS_DATA_TYPE
		 DW_1.OBJECT.OPERATION[LVI_ROWS]       = LVS_OPERATION
		 DW_1.OBJECT.VALUES[LVI_ROWS]              = LVS_DEFAULT_VALUE
		 DW_1.OBJECT.RELATION[LVI_ROWS]          = LVS_RELATION		 
		 
LOOP UNTIL 1 = 2 

end event

event resize;return
end event

event ue_post_open;call super::ue_post_open;f_set_column_dddw( tab_1.tabpage_1.tdw_3 )
f_set_column_dddw( tab_1.tabpage_2.dw_4 )
end event

type p_title from w_popup_root`p_title within w_dynamic_where_condition_popup
integer width = 3054
end type

type cb_sort from w_popup_root`cb_sort within w_dynamic_where_condition_popup
boolean visible = true
integer x = 837
integer y = 312
integer width = 402
end type

type cb_close from w_popup_root`cb_close within w_dynamic_where_condition_popup
boolean visible = true
integer x = 1243
integer y = 312
integer width = 402
end type

type st_msg from w_popup_root`st_msg within w_dynamic_where_condition_popup
boolean visible = true
integer y = 500
integer width = 3054
end type

type dw_1 from w_popup_root`dw_1 within w_dynamic_where_condition_popup
boolean visible = true
integer y = 620
integer width = 530
integer height = 336
end type

type dw_2 from w_popup_root`dw_2 within w_dynamic_where_condition_popup
boolean visible = true
integer y = 620
integer width = 530
integer height = 336
end type

type dw_3 from w_popup_root`dw_3 within w_dynamic_where_condition_popup
integer y = 620
integer width = 530
integer height = 336
end type

type cb_retrieve_all from commandbutton within w_dynamic_where_condition_popup
integer x = 32
integer y = 312
integer width = 402
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve All"
boolean default = true
end type

event clicked;string  old_select , where_clause , new_select  , Origin_select
int LVI_RETURN
dw_1.accepttext( )

Origin_select = arg_dw.getsqlselect()
old_select = arg_dw.getsqlselect()

where_clause = " WHERE"
where_clause = where_clause + ' organization_id = '+ string( gvi_organization_id ) 

new_select = f_get_token( old_select , 'WHERE' ) +'  '+where_clause

if cbx_show_sql.checked = true then 
    openwithparm(w_edit_window ,new_select)
end if

//==============================
//
//==============================
LVI_RETURN = arg_dw.setsqlselect(new_select)

if LVI_RETURN< 1  then 
	Messagebox("Notify" , string(LVI_RETURN)+ '~r~n'+new_select )
	Return 
end if
//arg_dw.settransobject( sqlca)
f_set_column_dddw(arg_dw)
arg_dw.retrieve() 

//==============================
//
//==============================
arg_dw.setsqlselect(Origin_select)
f_set_column_dddw(arg_dw)

if cbx_auto_close.checked = true then 
	close(parent)
end if
end event

type cb_retrieve from commandbutton within w_dynamic_where_condition_popup
integer x = 430
integer y = 312
integer width = 402
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve"
end type

event clicked;INT I
string old_select, new_select, where_clause
STRING LVS_COLUMN_NAME , LVS_OPERATION , LVS_DEFAULT_VALUE , LVS_RELATION , LVS_DATA_TYPE
// Get old SELECT statement

tab_1.tabpage_1.tdw_3.ACCEPTtext( )

old_select = ARG_DW.GetSQLSelect()

// Specify new WHERE clause

where_clause = " WHERE "

IF tab_1.tabpage_1.tdw_3.GETROW() < 1 THEN 

	where_clause = where_clause + ' ORGANIZATION_ID = '+ STRING( GVI_ORGANIZATION_ID ) 
	new_select = old_select + where_clause
	
	IF CBX_SHOW_SQL.CHECKED = TRUE THEN 
		
		 OPENWITHPARM(W_EDIT_WINDOW ,new_select)
		
	END IF
	
	ARG_DW.SetSQLSelect(new_select)
	f_set_column_dddw(ARG_DW)
	
	ARG_DW.RETRIEVE() 
	ARG_DW.SetSQLSelect(old_select)
	f_set_column_dddw(ARG_DW)

ELSE
		
		DO
			I++
			
			LVS_COLUMN_NAME  = tab_1.tabpage_1.tdw_3.OBJECT.COLUMN_NAME[I]
			LVS_DATA_TYPE  = tab_1.tabpage_1.tdw_3.OBJECT.DATA_TYPE[I]
			LVS_OPERATION        =tab_1.tabpage_1.tdw_3.OBJECT.OPERATION[I]
			LVS_DEFAULT_VALUE =tab_1.tabpage_1.tdw_3.OBJECT.VALUES[I]
			LVS_RELATION           =tab_1.tabpage_1.tdw_3.OBJECT.RELATION[I]	
			
			IF LVS_RELATION = '' OR ISNULL(LVS_RELATION) THEN  
				LVS_RELATION = ' '
			END IF
			
			IF LVS_DATA_TYPE = 'NUMBER' THEN 
			ELSE
								
				IF TRIM(LVS_OPERATION) = 'LIKE' THEN 
					LVS_DEFAULT_VALUE = "'"+LVS_DEFAULT_VALUE+"%'"	
				ELSE
					LVS_DEFAULT_VALUE = "'"+LVS_DEFAULT_VALUE+"'"
				END IF
				
			END IF
			
			if I = tab_1.tabpage_1.tdw_3.ROwcount( ) then 
				where_clause = where_clause + LVS_COLUMN_NAME+ '  ' +LVS_OPERATION +' '+LVS_DEFAULT_VALUE +' '
			else
				where_clause = where_clause + LVS_COLUMN_NAME+ '  ' +LVS_OPERATION +' '+LVS_DEFAULT_VALUE +' '+LVS_RELATION+' '				
			end if
			
		LOOP UNTIL I = tab_1.tabpage_1.tdw_3.ROwcount( )
		
		
			where_clause = where_clause + ' AND ORGANIZATION_ID = '+ STRING( GVI_ORGANIZATION_ID ) 
		
		// Add the new where clause to old_select
		
	     	new_select = old_select + where_clause
		
		// Set the SELECT statement for the DW

		IF CBX_SHOW_SQL.CHECKED = TRUE THEN 
			
			 OPENWITHPARM(W_EDIT_WINDOW ,new_select)
			
		END IF
		
		ARG_DW.SetSQLSelect(new_select)
		f_set_column_dddw(ARG_DW)
		
		ARG_DW.RETRIEVE() 
		ARG_DW.SetSQLSelect(old_select)
		f_set_column_dddw(ARG_DW)
		
END IF

IF cbx_auto_close.CHECKED = TRUE THEN 
	CLOSE(PARENT)
END IF
end event

type cbx_show_sql from checkbox within w_dynamic_where_condition_popup
integer x = 1737
integer y = 328
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Show SQL"
end type

type cbx_auto_close from checkbox within w_dynamic_where_condition_popup
integer x = 2171
integer y = 328
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Auto Close"
boolean checked = true
end type

type tab_1 from tab within w_dynamic_where_condition_popup
integer y = 600
integer width = 3040
integer height = 1268
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean fixedwidth = true
boolean multiline = true
boolean raggedright = true
boolean focusonbuttondown = true
boolean powertips = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3003
integer height = 1140
long backcolor = 12632256
string text = "Wehre Condition"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "AddWatch5!"
long picturemaskcolor = 12632256
tdw_3 tdw_3
end type

on tabpage_1.create
this.tdw_3=create tdw_3
this.Control[]={this.tdw_3}
end on

on tabpage_1.destroy
destroy(this.tdw_3)
end on

type tdw_3 from so_datawindow within tabpage_1
integer y = 8
integer width = 2994
integer height = 1056
integer taborder = 30
string dataobject = "d_dynamic_where_condition_popup"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3003
integer height = 1140
long backcolor = 12632256
string text = "Modify Where Condition"
long tabbackcolor = 12632256
string picturename = "EditStops!"
long picturemaskcolor = 12632256
dw_4 dw_4
cb_1 cb_1
cb_5 cb_5
cb_4 cb_4
cb_3 cb_3
end type

on tabpage_2.create
this.dw_4=create dw_4
this.cb_1=create cb_1
this.cb_5=create cb_5
this.cb_4=create cb_4
this.cb_3=create cb_3
this.Control[]={this.dw_4,&
this.cb_1,&
this.cb_5,&
this.cb_4,&
this.cb_3}
end on

on tabpage_2.destroy
destroy(this.dw_4)
destroy(this.cb_1)
destroy(this.cb_5)
destroy(this.cb_4)
destroy(this.cb_3)
end on

type dw_4 from so_datawindow within tabpage_2
integer y = 124
integer width = 2994
integer height = 944
integer taborder = 30
string dataobject = "d_dynamic_where_condition_lst"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

type cb_1 from commandbutton within tabpage_2
integer y = 24
integer width = 302
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve"
end type

event clicked;dw_4.retrieve( ivs_window_name , ivs_datawindow_name , Gvs_language , Gvi_organization_id )
end event

type cb_5 from commandbutton within tabpage_2
integer x = 901
integer y = 24
integer width = 302
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Update"
end type

event clicked;IF DW_4.UPDATE() < 0 THEN
	ROLLBACK;
ELSE
	 COMMIT;
END IF
end event

type cb_4 from commandbutton within tabpage_2
integer x = 603
integer y = 24
integer width = 302
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Delete"
end type

event clicked;int row
if dw_4.AcceptText() = -1 then
	return
end if
			
MSG = F_MSGBOX(1003) 
IF MSG = 1 THEN
	Gvl_row_deleted = dw_4.GetRow()			
	dw_4.DELETEROW(Gvl_row_deleted)		
	dw_4.SetFocus()
	ROW = dw_4.GetRow()
	dw_4.ScrollToRow(row)
	dw_4.SetColumn(1)
END IF
						

end event

type cb_3 from commandbutton within tabpage_2
integer x = 302
integer y = 24
integer width = 302
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Insert"
end type

event clicked;int row
STRING LVS_TABLE_NAME

ROW = dw_4.INSERTROW(0)
dw_4.SCROLLTOROW(ROW)
F_SET_SECURITY_ROW(dw_4 , ROW , 'ALL')

dw_4.OBJECT.WINDOW_NAME[ROW] = ivs_window_name
dw_4.OBJECT.DATAWINDOW_NAME[ROW] =ivs_datawindow_name

//f_child_dw2(dw_2, 'column_name', gvs_language,LVS_TABLE_NAME)
end event

type gb_1 from so_groupbox within w_dynamic_where_condition_popup
integer x = 1678
integer y = 196
integer width = 951
integer height = 288
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Option"
end type

type gb_2 from so_groupbox within w_dynamic_where_condition_popup
integer y = 196
integer width = 1669
integer height = 288
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

