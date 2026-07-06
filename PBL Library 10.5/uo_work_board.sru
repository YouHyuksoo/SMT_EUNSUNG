HA$PBExportHeader$uo_work_board.sru
forward
global type uo_work_board from userobject
end type
type pb_edit from picturebutton within uo_work_board
end type
type pb_history from picturebutton within uo_work_board
end type
type pb_update from picturebutton within uo_work_board
end type
type pb_delete from picturebutton within uo_work_board
end type
type pb_insert from picturebutton within uo_work_board
end type
type dw_1 from so_datawindow within uo_work_board
end type
type p_1 from picture within uo_work_board
end type
type pb_2 from picturebutton within uo_work_board
end type
type st_2 from statictext within uo_work_board
end type
type em_refresh_interval from editmask within uo_work_board
end type
type pb_refresh from picturebutton within uo_work_board
end type
type pb_1 from picturebutton within uo_work_board
end type
type st_1 from statictext within uo_work_board
end type
type gb_1 from groupbox within uo_work_board
end type
type dw_2 from so_datawindow within uo_work_board
end type
end forward

global type uo_work_board from userobject
integer width = 2231
integer height = 1520
long backcolor = 134217731
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event ue_post_open ( )
pb_edit pb_edit
pb_history pb_history
pb_update pb_update
pb_delete pb_delete
pb_insert pb_insert
dw_1 dw_1
p_1 p_1
pb_2 pb_2
st_2 st_2
em_refresh_interval em_refresh_interval
pb_refresh pb_refresh
pb_1 pb_1
st_1 st_1
gb_1 gb_1
dw_2 dw_2
end type
global uo_work_board uo_work_board

type variables
String lvs_rollout_yn = 'N' 
Datawindow Ivs_selected_data_window

end variables

forward prototypes
public function integer uf_retrieve ()
public function integer uf_set_interval (integer arg_interval)
end prototypes

event ue_post_open();Ivs_selected_data_window = dw_1

dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)

f_set_column_dddw( dw_1 )
f_set_column_dddw( dw_2 )

uf_retrieve()
end event

public function integer uf_retrieve ();Ivs_selected_data_window.Retrieve( Gvi_organization_id )
Return 1
end function

public function integer uf_set_interval (integer arg_interval);Int lvi_interval
lvi_interval = Integer(arg_interval)
Timer(lvi_interval)
Return 1
end function

on uo_work_board.create
this.pb_edit=create pb_edit
this.pb_history=create pb_history
this.pb_update=create pb_update
this.pb_delete=create pb_delete
this.pb_insert=create pb_insert
this.dw_1=create dw_1
this.p_1=create p_1
this.pb_2=create pb_2
this.st_2=create st_2
this.em_refresh_interval=create em_refresh_interval
this.pb_refresh=create pb_refresh
this.pb_1=create pb_1
this.st_1=create st_1
this.gb_1=create gb_1
this.dw_2=create dw_2
this.Control[]={this.pb_edit,&
this.pb_history,&
this.pb_update,&
this.pb_delete,&
this.pb_insert,&
this.dw_1,&
this.p_1,&
this.pb_2,&
this.st_2,&
this.em_refresh_interval,&
this.pb_refresh,&
this.pb_1,&
this.st_1,&
this.gb_1,&
this.dw_2}
end on

on uo_work_board.destroy
destroy(this.pb_edit)
destroy(this.pb_history)
destroy(this.pb_update)
destroy(this.pb_delete)
destroy(this.pb_insert)
destroy(this.dw_1)
destroy(this.p_1)
destroy(this.pb_2)
destroy(this.st_2)
destroy(this.em_refresh_interval)
destroy(this.pb_refresh)
destroy(this.pb_1)
destroy(this.st_1)
destroy(this.gb_1)
destroy(this.dw_2)
end on

event constructor;PostEvent('ue_post_open')
end event

type pb_edit from picturebutton within uo_work_board
integer x = 110
integer y = 16
integer width = 101
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "hand.ani"
string picturename = "EditStops!"
alignment htextalign = left!
boolean map3dcolors = true
string powertiptext = "Edit"
end type

event clicked;Ivs_selected_data_window = dw_1
dw_1.bringtotop = True

pb_insert.enabled = true

end event

type pb_history from picturebutton within uo_work_board
integer x = 215
integer y = 16
integer width = 101
integer height = 88
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "hand.ani"
string picturename = "Search!"
alignment htextalign = left!
boolean map3dcolors = true
string powertiptext = "Complete History"
end type

event clicked;Ivs_selected_data_window = dw_2
dw_2.bringtotop = True
pb_insert.enabled = false
end event

type pb_update from picturebutton within uo_work_board
integer x = 361
integer y = 180
integer width = 101
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "hand.ani"
string picturename = "Save!"
alignment htextalign = left!
boolean map3dcolors = true
string powertiptext = "Update"
end type

event clicked;if ivs_selected_data_window.update() < 0 then 
	Rollback;
else
	commit ;
end if
end event

type pb_delete from picturebutton within uo_work_board
integer x = 251
integer y = 180
integer width = 101
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "hand.ani"
string picturename = "Custom094!"
alignment htextalign = left!
boolean map3dcolors = true
string powertiptext = "Delete"
end type

event clicked;STRING LVS_USER_ID

lvs_user_id = ivs_selected_data_window.object.enter_by[ ivs_selected_data_window.getrow()]

if LVS_USER_ID = GVS_USER_ID or GVI_USER_LEVEL > 8 then

     ivs_selected_data_window.deleterow( ivs_selected_data_window.getrow())

else
	f_msgbox(181)
end if
end event

type pb_insert from picturebutton within uo_work_board
integer x = 146
integer y = 180
integer width = 101
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "hand.ani"
string picturename = "Custom072!"
alignment htextalign = left!
boolean map3dcolors = true
string powertiptext = "Insert"
end type

event clicked;long row , lvl_sequence
row = dw_1.insertrow(0)
dw_1.setitem( row , 'work_board_writer' , Gvs_user_name )


SELECT count(*) 
INTO :lvl_sequence
 from isys_work_board
 where organization_id = :Gvi_organization_id ;

if  lvl_sequence = 0 then 
	lvl_sequence = 1
else
		SELECT max(work_board_sequence) + 1 
		INTO :lvl_sequence
		 from isys_work_board
		 where organization_id = :Gvi_organization_id ;
		 
		 if f_sql_check() < 0 then 
			Return
		end if
end if 
 
dw_1.setitem( row , 'work_board_sequence' ,  lvl_sequence )
dw_1.setitem( row , 'work_board_complete_yn' , 'N' )
dw_1.setitem( row , 'work_board_date' , f_sysdate())
f_set_security_row( DW_1 , ROW , 'ALL')
end event

type dw_1 from so_datawindow within uo_work_board
integer y = 304
integer width = 2235
integer height = 1216
integer taborder = 40
boolean titlebar = true
string title = "Edit"
string dataobject = "d_work_order_list"
end type

event rowfocuschanged;call super::rowfocuschanged;//string lvs_user_id
//if currentrow < 1 then return
//
//lvs_user_id = ivs_selected_data_window.object.enter_by[ currentrow]
//
//if gvi_user_level = 9 then
//
//elseif gvs_user_id <> lvs_user_id then
////		pb_delete.enabled = false
////		pb_update.enabled = false
//		dw_1.object.work_board_text[currentrow].protect = true
//		dw_1.object.work_board_complete_yn[currentrow].protect = true
//elseif gvs_user_id = lvs_user_id then
////		pb_delete.enabled = true
////		pb_update.enabled = true
//         dw_1.object.work_board_text[currentrow].protect = false
//		dw_1.object.work_board_complete_yn[currentrow].protect = false
//end if
end event

type p_1 from picture within uo_work_board
integer x = 2080
integer width = 137
integer height = 120
boolean originalsize = true
string picturename = "cdup.gif"
boolean focusrectangle = false
end type

type pb_2 from picturebutton within uo_work_board
integer x = 2080
integer y = 172
integer width = 101
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "hand.ani"
boolean originalsize = true
string picturename = "Custom038!"
alignment htextalign = left!
boolean map3dcolors = true
string powertiptext = "Apply"
end type

event clicked;uf_set_interval( Integer(em_refresh_interval.text ))
end event

type st_2 from statictext within uo_work_board
integer x = 1326
integer y = 188
integer width = 439
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 65535
long backcolor = 134217731
string text = "Refresh Interval"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_refresh_interval from editmask within uo_work_board
integer x = 1787
integer y = 172
integer width = 293
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "600"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "##0"
boolean spin = true
double increment = 1
end type

type pb_refresh from picturebutton within uo_work_board
integer x = 37
integer y = 180
integer width = 101
integer height = 88
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "hand.ani"
string picturename = "Continue!"
alignment htextalign = left!
boolean map3dcolors = true
string powertiptext = "Refresh"
end type

event clicked;uf_retrieve()
end event

type pb_1 from picturebutton within uo_work_board
integer y = 16
integer width = 101
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "hand.ani"
string picturename = "OutputPrevious!"
alignment htextalign = left!
string powertiptext = "Minimize"
end type

event clicked;parent.height = 136
lvs_rollout_yn = 'N'
end event

type st_1 from statictext within uo_work_board
integer x = 800
integer y = 20
integer width = 581
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 65280
long backcolor = 134217731
string text = "Work Board"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from groupbox within uo_work_board
integer x = 5
integer y = 120
integer width = 2217
integer height = 172
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 134217731
string text = "Process"
end type

type dw_2 from so_datawindow within uo_work_board
integer y = 304
integer width = 2235
integer height = 1216
integer taborder = 50
boolean titlebar = true
string title = "Hsitory"
string dataobject = "d_work_order_history_list"
end type

