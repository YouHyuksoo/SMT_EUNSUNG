HA$PBExportHeader$w_table_select_4_where_condition_popup.srw
forward
global type w_table_select_4_where_condition_popup from w_popup_root
end type
type cb_retrieve from commandbutton within w_table_select_4_where_condition_popup
end type
type cb_select from commandbutton within w_table_select_4_where_condition_popup
end type
type rb_all from radiobutton within w_table_select_4_where_condition_popup
end type
type rb_table from radiobutton within w_table_select_4_where_condition_popup
end type
type rb_view from radiobutton within w_table_select_4_where_condition_popup
end type
type cb_selectall from commandbutton within w_table_select_4_where_condition_popup
end type
type cb_releaseall from commandbutton within w_table_select_4_where_condition_popup
end type
type gb_2 from groupbox within w_table_select_4_where_condition_popup
end type
type gb_1 from groupbox within w_table_select_4_where_condition_popup
end type
type gb_3 from groupbox within w_table_select_4_where_condition_popup
end type
end forward

global type w_table_select_4_where_condition_popup from w_popup_root
integer width = 4155
integer height = 2136
string title = "Tabe / Where Condition"
cb_retrieve cb_retrieve
cb_select cb_select
rb_all rb_all
rb_table rb_table
rb_view rb_view
cb_selectall cb_selectall
cb_releaseall cb_releaseall
gb_2 gb_2
gb_1 gb_1
gb_3 gb_3
end type
global w_table_select_4_where_condition_popup w_table_select_4_where_condition_popup

on w_table_select_4_where_condition_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.rb_all=create rb_all
this.rb_table=create rb_table
this.rb_view=create rb_view
this.cb_selectall=create cb_selectall
this.cb_releaseall=create cb_releaseall
this.gb_2=create gb_2
this.gb_1=create gb_1
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.rb_all
this.Control[iCurrent+4]=this.rb_table
this.Control[iCurrent+5]=this.rb_view
this.Control[iCurrent+6]=this.cb_selectall
this.Control[iCurrent+7]=this.cb_releaseall
this.Control[iCurrent+8]=this.gb_2
this.Control[iCurrent+9]=this.gb_1
this.Control[iCurrent+10]=this.gb_3
end on

on w_table_select_4_where_condition_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.rb_all)
destroy(this.rb_table)
destroy(this.rb_view)
destroy(this.cb_selectall)
destroy(this.cb_releaseall)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.gb_3)
end on

event open;call super::open;dw_1.settransobject(sqlca)
CB_RETRIEVE.TRIGGEREVENT(CLICKED!)
end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
	
end if
end event

event resize;//OVERRIDE
end event

type p_title from w_popup_root`p_title within w_table_select_4_where_condition_popup
integer width = 4128
end type

type cb_sort from w_popup_root`cb_sort within w_table_select_4_where_condition_popup
boolean visible = true
integer x = 2487
integer y = 292
end type

type cb_close from w_popup_root`cb_close within w_table_select_4_where_condition_popup
boolean visible = true
integer x = 3040
integer y = 292
end type

type st_msg from w_popup_root`st_msg within w_table_select_4_where_condition_popup
boolean visible = true
integer y = 456
integer width = 4128
end type

type dw_1 from w_popup_root`dw_1 within w_table_select_4_where_condition_popup
boolean visible = true
integer y = 556
integer width = 1577
integer height = 1488
boolean titlebar = true
string title = "Table"
string dataobject = "d_table_name_select_popup"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF row = 0  THEN 
	RETURN -1
END IF

DW_2.RETRIEVE( GVS_LANGUAGE ,  THIS.OBJECT.TNAME[ROW])
end event

type dw_2 from w_popup_root`dw_2 within w_table_select_4_where_condition_popup
boolean visible = true
integer x = 1573
integer y = 556
integer width = 2551
integer height = 1488
boolean titlebar = true
string title = "Column"
string dataobject = "d_table_column_select_popup"
end type

type dw_3 from w_popup_root`dw_3 within w_table_select_4_where_condition_popup
integer y = 568
end type

type cb_retrieve from commandbutton within w_table_select_4_where_condition_popup
integer x = 1211
integer y = 288
integer width = 279
integer height = 100
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve"
end type

event clicked;STRING LVS_TABTYPE
IF RB_ALL.CHECKED = TRUE THEN
	LVS_TABTYPE = '%'
ELSEIF  RB_TABLE.CHECKED = TRUE THEN 
	LVS_TABTYPE = 'TABLE%'
ELSEIF  RB_VIEW.CHECKED = TRUE THEN 
	LVS_TABTYPE = 'VIEW%'	
END IF
DW_1.RETRIEVE( LVS_TABTYPE)
end event

type cb_select from commandbutton within w_table_select_4_where_condition_popup
integer x = 2761
integer y = 292
integer width = 274
integer height = 100
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Select"
boolean default = true
end type

event clicked;IF DW_1.GETROW() = 0  THEN 
	RETURN -1
END IF

INT I , J 

STRING LVS_TABLE , LVS_SELECT

LVS_SELECT = 'SELECT '
LVS_TABLE= DW_1.OBJECT.TNAME[DW_1.GETROW()]


DO
	I++

	IF DW_2.OBJECT.SHOW_COLUMN[I] = 'Y' THEN
		
		J++
		
		IF J = 1 THEN 

		ELSE
			LVS_SELECT = LVS_SELECT +' , '+'~r~n'
		END IF
		
		LVS_SELECT = LVS_SELECT + DW_2.OBJECT.COLUMN_NAME[I]
		
	END IF 
	
LOOP UNTIL I = DW_2.ROWCOUNT()

LVS_SELECT = LVS_SELECT + ' FROM '+LVS_TABLE
MESSAGE.STRINGPARM = LVS_TABLE 


GST_RETURN.GVS_RETURN[1] = LVS_SELECT
CLOSEWITHRETURN(PARENT ,MESSAGE.STRINGPARM )
end event

type rb_all from radiobutton within w_table_select_4_where_condition_popup
integer x = 46
integer y = 312
integer width = 238
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "All"
end type

type rb_table from radiobutton within w_table_select_4_where_condition_popup
integer x = 320
integer y = 312
integer width = 293
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Table"
end type

type rb_view from radiobutton within w_table_select_4_where_condition_popup
integer x = 667
integer y = 312
integer width = 357
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "View Table"
boolean checked = true
end type

type cb_selectall from commandbutton within w_table_select_4_where_condition_popup
integer x = 1627
integer y = 288
integer width = 343
integer height = 100
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Select All"
end type

event clicked;IF F_OBJECT_ROLE_CHECK() = FALSE THEN  RETURN
LONG I 
IF DW_2.GETROW() < 1 THEN 
	RETURN
END IF
DO

     I++
    DW_2.SETITEM( I , 'show_column' , 'Y' )
    ST_MSG.TEXT = string( I ) + " Rows Selected " 

LOOP UNTIL I = DW_2.ROWCOUNT()
end event

type cb_releaseall from commandbutton within w_table_select_4_where_condition_popup
integer x = 1970
integer y = 288
integer width = 343
integer height = 100
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Release All"
end type

event clicked;IF F_OBJECT_ROLE_CHECK() = FALSE THEN  RETURN
LONG I
IF DW_2.GETROW() < 1 THEN 
	RETURN
END IF
DO
	I++
     DW_2.SETITEM( I , 'show_column' , 'N' )
   ST_MSG.TEXT = string( i ) + " Rows Selected " 

LOOP UNTIL I = DW_2.ROWCOUNT()
end event

type gb_2 from groupbox within w_table_select_4_where_condition_popup
integer y = 200
integer width = 1573
integer height = 248
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Table"
end type

type gb_1 from groupbox within w_table_select_4_where_condition_popup
integer x = 1595
integer y = 200
integer width = 832
integer height = 248
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Show Column Select/Release"
end type

type gb_3 from groupbox within w_table_select_4_where_condition_popup
integer x = 2427
integer y = 200
integer width = 937
integer height = 248
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Column"
end type

