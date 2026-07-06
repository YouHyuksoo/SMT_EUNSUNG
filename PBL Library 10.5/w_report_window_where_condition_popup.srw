HA$PBExportHeader$w_report_window_where_condition_popup.srw
$PBExportComments$$$HEX11$$acb9ecd3b8d208c7c4b3b0c670c874ac08c81dd3c5c5$$ENDHEX$$
forward
global type w_report_window_where_condition_popup from w_popup_root
end type
type cb_retrieve_all from commandbutton within w_report_window_where_condition_popup
end type
type cb_retrieve from commandbutton within w_report_window_where_condition_popup
end type
type cbx_show_sql from checkbox within w_report_window_where_condition_popup
end type
type cbx_auto_close from checkbox within w_report_window_where_condition_popup
end type
type gb_1 from so_groupbox within w_report_window_where_condition_popup
end type
type gb_2 from so_groupbox within w_report_window_where_condition_popup
end type
end forward

global type w_report_window_where_condition_popup from w_popup_root
integer width = 2926
integer height = 1712
string title = "Where Condition"
boolean controlmenu = false
windowtype windowtype = popup!
boolean center = false
cb_retrieve_all cb_retrieve_all
cb_retrieve cb_retrieve
cbx_show_sql cbx_show_sql
cbx_auto_close cbx_auto_close
gb_1 gb_1
gb_2 gb_2
end type
global w_report_window_where_condition_popup w_report_window_where_condition_popup

type variables
DATAWINDOW ARG_DW
end variables

on w_report_window_where_condition_popup.create
int iCurrent
call super::create
this.cb_retrieve_all=create cb_retrieve_all
this.cb_retrieve=create cb_retrieve
this.cbx_show_sql=create cbx_show_sql
this.cbx_auto_close=create cbx_auto_close
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve_all
this.Control[iCurrent+2]=this.cb_retrieve
this.Control[iCurrent+3]=this.cbx_show_sql
this.Control[iCurrent+4]=this.cbx_auto_close
this.Control[iCurrent+5]=this.gb_1
this.Control[iCurrent+6]=this.gb_2
end on

on w_report_window_where_condition_popup.destroy
call super::destroy
destroy(this.cb_retrieve_all)
destroy(this.cb_retrieve)
destroy(this.cbx_show_sql)
destroy(this.cbx_auto_close)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;CB_RETRIEVE_ALL.SETFOcus( )
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
	 
 WHERE WINDOW_NAME          = :GST_RETURN.GVS_RETURN[1]
      AND DATAWINDOW_NAME = :GST_RETURN.GVS_RETURN[2]
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

type p_title from w_popup_root`p_title within w_report_window_where_condition_popup
integer x = 5
integer width = 2912
end type

type cb_sort from w_popup_root`cb_sort within w_report_window_where_condition_popup
boolean visible = true
integer x = 837
integer y = 312
integer width = 402
end type

type cb_close from w_popup_root`cb_close within w_report_window_where_condition_popup
boolean visible = true
integer x = 2395
integer y = 296
integer width = 402
end type

type st_msg from w_popup_root`st_msg within w_report_window_where_condition_popup
boolean visible = true
integer y = 500
integer width = 2912
end type

type dw_1 from w_popup_root`dw_1 within w_report_window_where_condition_popup
boolean visible = true
integer y = 596
integer width = 2912
integer height = 1028
string dataobject = "d_report_window_where_condition_popup"
end type

type dw_2 from w_popup_root`dw_2 within w_report_window_where_condition_popup
boolean visible = true
integer y = 816
end type

type dw_3 from w_popup_root`dw_3 within w_report_window_where_condition_popup
end type

type cb_retrieve_all from commandbutton within w_report_window_where_condition_popup
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

event clicked;STRING old_select , where_clause , new_select
DW_1.ACCEPTtext( )

old_select = ARG_DW.GetSQLSelect()

where_clause = " WHERE"
where_clause = where_clause + ' ORGANIZATION_ID = '+ STRING( GVI_ORGANIZATION_ID ) 
new_select = old_select + where_clause

IF CBX_SHOW_SQL.CHECKED = TRUE THEN 
	
    OPENWITHPARM(W_EDIT_WINDOW ,new_select)
	
END IF

ARG_DW.SetSQLSelect(new_select)
ARG_DW.RETRIEVE() 
ARG_DW.SetSQLSelect(old_select)

IF cbx_auto_close.CHECKED = TRUE THEN 
	CLOSE(PARENT)
END IF
end event

type cb_retrieve from commandbutton within w_report_window_where_condition_popup
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

DW_1.ACCEPTtext( )

old_select = ARG_DW.GetSQLSelect()

// Specify new WHERE clause

where_clause = " WHERE "

IF DW_1.GETROW() < 1 THEN 

	where_clause = where_clause + ' ORGANIZATION_ID = '+ STRING( GVI_ORGANIZATION_ID ) 
	new_select = old_select + where_clause
	
	IF CBX_SHOW_SQL.CHECKED = TRUE THEN 
		
		 OPENWITHPARM(W_EDIT_WINDOW ,new_select)
		
	END IF
	
	ARG_DW.SetSQLSelect(new_select)
	ARG_DW.RETRIEVE() 
	ARG_DW.SetSQLSelect(old_select)

ELSE
		
		DO
			I++
			
			LVS_COLUMN_NAME  = DW_1.OBJECT.COLUMN_NAME[I]
			LVS_DATA_TYPE  = DW_1.OBJECT.DATA_TYPE[I]
			LVS_OPERATION        =DW_1.OBJECT.OPERATION[I]
			LVS_DEFAULT_VALUE =DW_1.OBJECT.VALUES[I]
			LVS_RELATION           =DW_1.OBJECT.RELATION[I]	
			
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
			
			if I = DW_1.ROwcount( ) then 
				where_clause = where_clause + LVS_COLUMN_NAME+ '  ' +LVS_OPERATION +' '+LVS_DEFAULT_VALUE +' '
			else
				where_clause = where_clause + LVS_COLUMN_NAME+ '  ' +LVS_OPERATION +' '+LVS_DEFAULT_VALUE +' '+LVS_RELATION+' '				
			end if
			
		LOOP UNTIL I = DW_1.ROwcount( )
		
		
			where_clause = where_clause + ' AND ORGANIZATION_ID = '+ STRING( GVI_ORGANIZATION_ID ) 
		
		// Add the new where clause to old_select
		
	     	new_select = old_select + where_clause
		
		// Set the SELECT statement for the DW

		IF CBX_SHOW_SQL.CHECKED = TRUE THEN 
			
			 OPENWITHPARM(W_EDIT_WINDOW ,new_select)
			
		END IF
		
		ARG_DW.SetSQLSelect(new_select)
		ARG_DW.RETRIEVE() 
		ARG_DW.SetSQLSelect(old_select)
		
		
END IF

IF cbx_auto_close.CHECKED = TRUE THEN 
	CLOSE(PARENT)
END IF
end event

type cbx_show_sql from checkbox within w_report_window_where_condition_popup
integer x = 1317
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

type cbx_auto_close from checkbox within w_report_window_where_condition_popup
integer x = 1774
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

type gb_1 from so_groupbox within w_report_window_where_condition_popup
integer x = 1280
integer y = 196
integer width = 951
integer height = 288
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Option"
end type

type gb_2 from so_groupbox within w_report_window_where_condition_popup
integer y = 196
integer width = 1266
integer height = 288
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

