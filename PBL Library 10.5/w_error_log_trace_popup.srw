HA$PBExportHeader$w_error_log_trace_popup.srw
forward
global type w_error_log_trace_popup from w_none_dw_popup_root
end type
end forward

global type w_error_log_trace_popup from w_none_dw_popup_root
integer width = 1797
integer height = 504
long backcolor = 16711935
boolean contexthelp = false
end type
global w_error_log_trace_popup w_error_log_trace_popup

on w_error_log_trace_popup.create
call super::create
end on

on w_error_log_trace_popup.destroy
call super::destroy
end on

event open;call super::open;//send(handle(rte_1),770,0, 0)

end event

type p_title from w_none_dw_popup_root`p_title within w_error_log_trace_popup
end type

type cb_close from w_none_dw_popup_root`cb_close within w_error_log_trace_popup
boolean visible = true
integer x = 1495
integer y = 212
end type

type st_msg from w_none_dw_popup_root`st_msg within w_error_log_trace_popup
boolean visible = true
integer x = 59
integer y = 1256
end type

