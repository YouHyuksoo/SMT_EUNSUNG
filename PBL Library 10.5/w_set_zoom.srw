HA$PBExportHeader$w_set_zoom.srw
$PBExportComments$$$HEX8$$9ccd25b8dcc255d600b30fbc95cd8cc1$$ENDHEX$$
forward
global type w_set_zoom from w_popup_root
end type
type cb_12 from so_commandbutton within w_set_zoom
end type
type cb_11 from so_commandbutton within w_set_zoom
end type
type cb_10 from so_commandbutton within w_set_zoom
end type
type cb_insert from so_commandbutton within w_set_zoom
end type
type cb_retrieve from so_commandbutton within w_set_zoom
end type
type st_6 from so_statictext within w_set_zoom
end type
type cb_5 from so_commandbutton within w_set_zoom
end type
type cb_6 from so_commandbutton within w_set_zoom
end type
type sle_2 from so_singlelineedit within w_set_zoom
end type
type st_4 from so_statictext within w_set_zoom
end type
type st_3 from so_statictext within w_set_zoom
end type
type cb_4 from so_commandbutton within w_set_zoom
end type
type cb_3 from so_commandbutton within w_set_zoom
end type
type cb_2 from so_commandbutton within w_set_zoom
end type
type cb_1 from so_commandbutton within w_set_zoom
end type
type gb_2 from so_groupbox within w_set_zoom
end type
type gb_1 from so_groupbox within w_set_zoom
end type
end forward

global type w_set_zoom from w_popup_root
integer x = 987
integer y = 452
integer width = 3543
integer height = 1628
string title = "Magnification"
cb_12 cb_12
cb_11 cb_11
cb_10 cb_10
cb_insert cb_insert
cb_retrieve cb_retrieve
st_6 st_6
cb_5 cb_5
cb_6 cb_6
sle_2 sle_2
st_4 st_4
st_3 st_3
cb_4 cb_4
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
gb_2 gb_2
gb_1 gb_1
end type
global w_set_zoom w_set_zoom

type variables
window win_ref
end variables

on w_set_zoom.create
int iCurrent
call super::create
this.cb_12=create cb_12
this.cb_11=create cb_11
this.cb_10=create cb_10
this.cb_insert=create cb_insert
this.cb_retrieve=create cb_retrieve
this.st_6=create st_6
this.cb_5=create cb_5
this.cb_6=create cb_6
this.sle_2=create sle_2
this.st_4=create st_4
this.st_3=create st_3
this.cb_4=create cb_4
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_12
this.Control[iCurrent+2]=this.cb_11
this.Control[iCurrent+3]=this.cb_10
this.Control[iCurrent+4]=this.cb_insert
this.Control[iCurrent+5]=this.cb_retrieve
this.Control[iCurrent+6]=this.st_6
this.Control[iCurrent+7]=this.cb_5
this.Control[iCurrent+8]=this.cb_6
this.Control[iCurrent+9]=this.sle_2
this.Control[iCurrent+10]=this.st_4
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.cb_4
this.Control[iCurrent+13]=this.cb_3
this.Control[iCurrent+14]=this.cb_2
this.Control[iCurrent+15]=this.cb_1
this.Control[iCurrent+16]=this.gb_2
this.Control[iCurrent+17]=this.gb_1
end on

on w_set_zoom.destroy
call super::destroy
destroy(this.cb_12)
destroy(this.cb_11)
destroy(this.cb_10)
destroy(this.cb_insert)
destroy(this.cb_retrieve)
destroy(this.st_6)
destroy(this.cb_5)
destroy(this.cb_6)
destroy(this.sle_2)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event open;call super::open;dw_1.settransobject(sqlca)
cb_retrieve.triggerevent(clicked!)
end event

type p_title from w_popup_root`p_title within w_set_zoom
integer width = 3538
end type

type cb_sort from w_popup_root`cb_sort within w_set_zoom
integer x = 14
integer y = 1956
end type

type cb_close from w_popup_root`cb_close within w_set_zoom
boolean visible = true
integer x = 3209
integer y = 324
integer height = 108
end type

type st_msg from w_popup_root`st_msg within w_set_zoom
boolean visible = true
integer x = 5
integer y = 508
integer width = 3525
boolean enabled = true
end type

type dw_1 from w_popup_root`dw_1 within w_set_zoom
boolean visible = true
integer x = 5
integer y = 604
integer width = 3525
integer height = 944
integer taborder = 110
boolean titlebar = true
string title = "Magnification"
string dataobject = "d_dwzoom_manager"
end type

type dw_2 from w_popup_root`dw_2 within w_set_zoom
integer x = 5
integer y = 892
end type

type dw_3 from w_popup_root`dw_3 within w_set_zoom
integer x = 5
integer y = 892
end type

type cb_12 from so_commandbutton within w_set_zoom
integer x = 2126
integer y = 324
integer width = 274
integer height = 108
integer taborder = 100
string text = "Cancel"
end type

event clicked;dw_1.dbcancel()
end event

type cb_11 from so_commandbutton within w_set_zoom
integer x = 2935
integer y = 324
integer width = 274
integer height = 108
integer taborder = 90
string text = "Save"
end type

event clicked;msg = f_msgbox( 1170)
if Msg = 1 then 
	if dw_1.Update() < 0  then 
//			 F_SQL_CHECK()
			 Rollback;
	else
		F_MESSAGE_ONTIME(1,f_msg_st( 170) ) //$$HEX7$$00c8a5c718b4c8c5b5c2c8b2e4b2$$ENDHEX$$)
	    	Commit;		
	end if
else
end if
end event

type cb_10 from so_commandbutton within w_set_zoom
integer x = 2665
integer y = 324
integer width = 274
integer height = 108
integer taborder = 80
string text = "Delete"
end type

event clicked;dw_1.deleterow(dw_1.getrow())
msg = f_msgbox ( 1170 ) 
if Msg = 1 then 
	if dw_1.Update() = 1 then 
	    Commit;
	else
		 f_msgbox3(1173 , string(sqlca.sqlcode) , sqlca.sqlerrtext , string(dw_1.modifiedcount()+dw_1.deletedcount()) ) // save error
	      Rollback;
	end if
else
	Rollback;
	dw_1.retrieve()
end if
end event

type cb_insert from so_commandbutton within w_set_zoom
integer x = 2395
integer y = 324
integer width = 274
integer height = 108
integer taborder = 70
string text = "Insert"
end type

event clicked;Int Cur_row
string lvs_left_margin , lvs_right_margin , lvs_top_margin , lvs_bottom_margin
Cur_row = dw_1.insertrow(1)
dw_1.scrolltorow(Cur_row)

dw_1.setitem(Cur_row , 'window_name' , upper(selected_window.classname()) )
dw_1.setitem(Cur_row , 'datawindow_name' , upper(selected_data_window.classname()) )
dw_1.setitem(Cur_row , 'style' , '1' )
dw_1.setitem(Cur_row , 'zoom_is' , long(Gvs_zoom_size) )

lvs_left_margin =  selected_data_window.Describe("DataWindow.Print.Margin.left") 
lvs_right_margin =  selected_data_window.Describe("DataWindow.Print.Margin.right") 
lvs_top_margin =  selected_data_window.Describe("DataWindow.Print.Margin.top") 
lvs_bottom_margin =  selected_data_window.Describe("DataWindow.Print.Margin.bottom") 

dw_1.setitem(Cur_row , 'left_margin' ,      dec(lvs_left_margin) )
dw_1.setitem(Cur_row , 'right_margin' ,    dec(lvs_right_margin ))
dw_1.setitem(Cur_row , 'top_margin' ,      dec(lvs_top_margin ))
dw_1.setitem(Cur_row , 'bottom_margin' ,dec(lvs_bottom_margin ))

F_SET_SECURITY_ROW(dw_1,dw_1.GETROW(),'ALL')
end event

type cb_retrieve from so_commandbutton within w_set_zoom
integer x = 1856
integer y = 324
integer width = 274
integer height = 108
integer taborder = 30
string text = "Retrieve"
end type

event clicked;String Active_window

if isvalid(selected_window) then 
	
Active_window = selected_window.classname()
dw_1.reset()
dw_1.retrieve( upper(Active_window)+'%' , GVI_ORGANIZATION_ID)

else
	dw_1.reset()
	dw_1.retrieve( '%' , GVI_ORGANIZATION_ID)
end if


end event

type st_6 from so_statictext within w_set_zoom
integer x = 818
integer y = 348
integer width = 114
integer height = 60
integer weight = 700
boolean enabled = false
string text = "5%"
end type

type cb_5 from so_commandbutton within w_set_zoom
integer x = 928
integer y = 324
integer width = 178
integer height = 108
integer taborder = 140
string text = ">>"
end type

event clicked;if isnull(Gvs_zoom_size) or integer(Gvs_zoom_size) = 0 then 
	Gvs_zoom_size = '100'
end if

Gvs_zoom_size = string(integer(Gvs_zoom_size)+5)
f_set_zoom(selected_data_window,Gvs_zoom_size)
sle_2.text = Gvs_zoom_size+'%'
end event

type cb_6 from so_commandbutton within w_set_zoom
integer x = 640
integer y = 324
integer width = 178
integer height = 108
integer taborder = 130
string text = "<<"
end type

event clicked;if isnull(Gvs_zoom_size) or integer(Gvs_zoom_size) = 0 then 
	Gvs_zoom_size = '100'
end if

Gvs_zoom_size = string(integer(Gvs_zoom_size)-5)
f_set_zoom(selected_data_window,Gvs_zoom_size)
sle_2.text = Gvs_zoom_size+'%'
end event

type sle_2 from so_singlelineedit within w_set_zoom
integer x = 1669
integer y = 340
integer width = 142
integer taborder = 120
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
boolean autohscroll = false
end type

event constructor;this.text = Gvs_zoom_size
end event

type st_4 from so_statictext within w_set_zoom
integer x = 1390
integer y = 348
integer width = 87
integer height = 60
integer weight = 700
boolean enabled = false
string text = "1%"
end type

type st_3 from so_statictext within w_set_zoom
integer x = 215
integer y = 348
integer width = 114
integer height = 60
integer weight = 700
boolean enabled = false
string text = "10%"
end type

type cb_4 from so_commandbutton within w_set_zoom
integer x = 1211
integer y = 324
integer width = 178
integer height = 108
integer taborder = 60
string text = "<"
end type

event clicked;if isnull(Gvs_zoom_size) or integer(Gvs_zoom_size) = 0 then 
	Gvs_zoom_size = '100'
end if
Gvs_zoom_size = string(integer(Gvs_zoom_size)-1)
f_set_zoom(selected_data_window,Gvs_zoom_size)
sle_2.text = Gvs_zoom_size+'%'
end event

type cb_3 from so_commandbutton within w_set_zoom
integer x = 1477
integer y = 324
integer width = 178
integer height = 108
integer taborder = 150
string text = ">"
end type

event clicked;if isnull(Gvs_zoom_size) or integer(Gvs_zoom_size) = 0 then 
	Gvs_zoom_size = '100'
end if
Gvs_zoom_size = string(integer(Gvs_zoom_size)+1)
f_set_zoom(selected_data_window,Gvs_zoom_size)
sle_2.text = Gvs_zoom_size+'%'
end event

type cb_2 from so_commandbutton within w_set_zoom
integer x = 338
integer y = 324
integer width = 178
integer height = 108
integer taborder = 50
string text = ">>>"
end type

event clicked;if isnull(Gvs_zoom_size) or integer(Gvs_zoom_size) = 0 then 
	Gvs_zoom_size = '100'
end if

Gvs_zoom_size = string(integer(Gvs_zoom_size)+10)
f_set_zoom(selected_data_window,Gvs_zoom_size)
sle_2.text = Gvs_zoom_size+'%'
end event

type cb_1 from so_commandbutton within w_set_zoom
integer x = 37
integer y = 324
integer width = 178
integer height = 108
integer taborder = 40
string text = "<<<"
end type

event clicked;if isnull(Gvs_zoom_size) or integer(Gvs_zoom_size) = 0 then 
	Gvs_zoom_size = '100'
end if
Gvs_zoom_size = string(integer(Gvs_zoom_size)-10)
f_set_zoom(selected_data_window,Gvs_zoom_size)
sle_2.text = Gvs_zoom_size+'%'
end event

type gb_2 from so_groupbox within w_set_zoom
integer x = 1838
integer y = 252
integer width = 1669
integer height = 240
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_1 from so_groupbox within w_set_zoom
integer y = 252
integer width = 1838
integer height = 240
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

