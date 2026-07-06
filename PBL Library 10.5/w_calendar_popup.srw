HA$PBExportHeader$w_calendar_popup.srw
forward
global type w_calendar_popup from w_none_dw_popup_root
end type
type uo_1 from uo_ymd_calendar_4_popup within w_calendar_popup
end type
end forward

global type w_calendar_popup from w_none_dw_popup_root
integer width = 686
integer height = 616
boolean titlebar = false
boolean controlmenu = false
boolean contexthelp = false
boolean center = false
uo_1 uo_1
end type
global w_calendar_popup w_calendar_popup

on w_calendar_popup.create
int iCurrent
call super::create
this.uo_1=create uo_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
end on

on w_calendar_popup.destroy
call super::destroy
destroy(this.uo_1)
end on

event open;call super::open;THIS.X =  workspacex()+pointerx()
THIS.y =  workspacey()+pointery()			
end event

type cb_close from w_none_dw_popup_root`cb_close within w_calendar_popup
end type

type st_msg from w_none_dw_popup_root`st_msg within w_calendar_popup
end type

type uo_1 from uo_ymd_calendar_4_popup within w_calendar_popup
integer x = 9
integer y = 8
integer taborder = 30
boolean bringtotop = true
end type

on uo_1.destroy
call uo_ymd_calendar_4_popup::destroy
end on

