HA$PBExportHeader$w_cancel_retrieve_pop.srw
$PBExportComments$$$HEX7$$70c88cd611c9c0c908c7c4b3b0c6$$ENDHEX$$
forward
global type w_cancel_retrieve_pop from window
end type
type st_msg from so_statictext within w_cancel_retrieve_pop
end type
type cb_2 from so_commandbutton within w_cancel_retrieve_pop
end type
type sle_retrieved_rows from so_singlelineedit within w_cancel_retrieve_pop
end type
type st_1 from so_statictext within w_cancel_retrieve_pop
end type
type cb_cancel from so_commandbutton within w_cancel_retrieve_pop
end type
type gb_1 from so_groupbox within w_cancel_retrieve_pop
end type
type oval_1 from oval within w_cancel_retrieve_pop
end type
type oval_2 from oval within w_cancel_retrieve_pop
end type
type oval_3 from oval within w_cancel_retrieve_pop
end type
type oval_4 from oval within w_cancel_retrieve_pop
end type
type oval_5 from oval within w_cancel_retrieve_pop
end type
type oval_6 from oval within w_cancel_retrieve_pop
end type
type oval_7 from oval within w_cancel_retrieve_pop
end type
end forward

global type w_cancel_retrieve_pop from window
integer x = 1161
integer y = 940
integer width = 1326
integer height = 580
boolean titlebar = true
windowtype windowtype = popup!
long backcolor = 12632256
boolean center = true
st_msg st_msg
cb_2 cb_2
sle_retrieved_rows sle_retrieved_rows
st_1 st_1
cb_cancel cb_cancel
gb_1 gb_1
oval_1 oval_1
oval_2 oval_2
oval_3 oval_3
oval_4 oval_4
oval_5 oval_5
oval_6 oval_6
oval_7 oval_7
end type
global w_cancel_retrieve_pop w_cancel_retrieve_pop

type variables
INT IVI_SCROLL
end variables

on w_cancel_retrieve_pop.create
this.st_msg=create st_msg
this.cb_2=create cb_2
this.sle_retrieved_rows=create sle_retrieved_rows
this.st_1=create st_1
this.cb_cancel=create cb_cancel
this.gb_1=create gb_1
this.oval_1=create oval_1
this.oval_2=create oval_2
this.oval_3=create oval_3
this.oval_4=create oval_4
this.oval_5=create oval_5
this.oval_6=create oval_6
this.oval_7=create oval_7
this.Control[]={this.st_msg,&
this.cb_2,&
this.sle_retrieved_rows,&
this.st_1,&
this.cb_cancel,&
this.gb_1,&
this.oval_1,&
this.oval_2,&
this.oval_3,&
this.oval_4,&
this.oval_5,&
this.oval_6,&
this.oval_7}
end on

on w_cancel_retrieve_pop.destroy
destroy(this.st_msg)
destroy(this.cb_2)
destroy(this.sle_retrieved_rows)
destroy(this.st_1)
destroy(this.cb_cancel)
destroy(this.gb_1)
destroy(this.oval_1)
destroy(this.oval_2)
destroy(this.oval_3)
destroy(this.oval_4)
destroy(this.oval_5)
destroy(this.oval_6)
destroy(this.oval_7)
end on

event open;GVS_DB_CANCEL ='N'
timer(0.1)
st_msg.visible = False
cb_cancel.setfocus()


end event

event timer;if cb_2.enabled = True then 
	if st_msg.Visible = True then 
		st_msg.Visible = False
	elseif 		st_msg.Visible = False then 
		st_msg.Visible = True
	end if
end if	

if oval_1.visible = True then 
	oval_1.visible = False	
	oval_2.visible = True
elseif oval_2.visible = True then 
	
	oval_2.visible = False
	oval_3.visible = True

elseif oval_3.visible = True then 
	oval_3.visible = false
	oval_4.visible = True 		
	
elseif oval_4.visible = True then 
	oval_4.visible = False 		
	oval_5.visible = True
	
elseif oval_5.visible = True then 
	
	oval_5.visible = False
	oval_6.visible = True
	
elseif oval_6.visible = True then 
	oval_6.visible = False
	oval_7.visible = True
elseif oval_7.visible = True then 
	oval_7.visible = False
	oval_1.visible = True	
	
end if
end event

event close;timer(0)
end event

event key;if key = keyf2! then 
	CLOSE(THIS)
end if
end event

type st_msg from so_statictext within w_cancel_retrieve_pop
integer x = 91
integer y = 380
integer width = 594
integer height = 72
integer weight = 700
long textcolor = 255
string text = "Again Retrieve=>"
alignment alignment = right!
end type

type cb_2 from so_commandbutton within w_cancel_retrieve_pop
integer x = 690
integer y = 356
integer width = 599
integer height = 108
integer taborder = 30
integer textsize = -10
boolean enabled = false
string text = "Countinue Retrieve"
end type

event clicked;Gvs_ue_data_control = 'NEXTPAGE'
SELECTED_WINDOW.TRIGGEREVENT('UE_DATA_CONTROL')
end event

type sle_retrieved_rows from so_singlelineedit within w_cancel_retrieve_pop
integer x = 855
integer y = 80
integer width = 256
integer height = 72
integer textsize = -10
integer weight = 700
long backcolor = 12632256
boolean border = false
boolean autohscroll = false
end type

type st_1 from so_statictext within w_cancel_retrieve_pop
integer x = 288
integer y = 84
integer width = 535
integer height = 60
integer textsize = -10
integer weight = 700
boolean enabled = false
string text = " Retrieve Count "
alignment alignment = right!
end type

type cb_cancel from so_commandbutton within w_cancel_retrieve_pop
integer x = 352
integer y = 216
integer width = 603
integer height = 108
integer taborder = 10
integer textsize = -10
string text = " Retrieve Cancel"
boolean cancel = true
boolean default = true
end type

event clicked;GVS_DB_CANCEL = 'Y'
CLOSE(PARENT)

end event

event losefocus;this.setfocus()
end event

type gb_1 from so_groupbox within w_cancel_retrieve_pop
integer x = 165
integer y = 12
integer width = 1093
integer height = 168
integer taborder = 20
integer textsize = -10
integer weight = 700
long textcolor = 16711680
end type

type oval_1 from oval within w_cancel_retrieve_pop
integer linethickness = 4
integer x = 27
integer y = 48
integer width = 55
integer height = 48
end type

type oval_2 from oval within w_cancel_retrieve_pop
integer linethickness = 4
long fillcolor = 16711680
integer x = 27
integer y = 104
integer width = 55
integer height = 48
end type

type oval_3 from oval within w_cancel_retrieve_pop
integer linethickness = 4
long fillcolor = 16776960
integer x = 27
integer y = 160
integer width = 55
integer height = 48
end type

type oval_4 from oval within w_cancel_retrieve_pop
integer linethickness = 4
long fillcolor = 65535
integer x = 27
integer y = 216
integer width = 55
integer height = 48
end type

type oval_5 from oval within w_cancel_retrieve_pop
integer linethickness = 4
long fillcolor = 65280
integer x = 27
integer y = 272
integer width = 55
integer height = 48
end type

type oval_6 from oval within w_cancel_retrieve_pop
long linecolor = 12632256
integer linethickness = 4
long fillcolor = 255
integer x = 27
integer y = 328
integer width = 55
integer height = 48
end type

type oval_7 from oval within w_cancel_retrieve_pop
integer linethickness = 4
long fillcolor = 16777215
integer x = 27
integer y = 384
integer width = 55
integer height = 48
end type

