HA$PBExportHeader$w_mcn_machine_mounter_status_master.srw
$PBExportComments$Customer Infromation Manage
forward
global type w_mcn_machine_mounter_status_master from w_main_root
end type
end forward

global type w_mcn_machine_mounter_status_master from w_main_root
integer width = 4571
integer height = 2748
string title = ""
end type
global w_mcn_machine_mounter_status_master w_mcn_machine_mounter_status_master

on w_mcn_machine_mounter_status_master.create
call super::create
end on

on w_mcn_machine_mounter_status_master.destroy
call super::destroy
end on

event activate;call super::activate;/***************************************
* Window Default Property 
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20051101'
Gst_set.last_modify_date = '20051101'
Gst_set.Report_window    = False  // Report Window  True / Flase

/*****************************************
* Data Window Property
******************************************/
Ivs_resize_type                      = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

/****************************************
*  Menu Property
*****************************************
* ADMIN  ( All Control )
* MANAGE ( Manager )
* GUEST  ( Only Query )
* QUERY  ( Only Query  )
* DATA_CONTROL  ( Insert Delete Update )
* REPORT ( Report )
****************************************/
F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control




end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

event ue_data_control;call super::ue_data_control;long row
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
			dw_1.retrieve( )
			dw_1.setfocus()

	case else
end choose


end event

type dw_5 from w_main_root`dw_5 within w_mcn_machine_mounter_status_master
end type

type dw_4 from w_main_root`dw_4 within w_mcn_machine_mounter_status_master
end type

type dw_3 from w_main_root`dw_3 within w_mcn_machine_mounter_status_master
integer width = 4544
integer height = 1388
end type

type dw_2 from w_main_root`dw_2 within w_mcn_machine_mounter_status_master
integer width = 4549
integer height = 828
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_mcn_machine_mounter_status_master
integer x = 9
integer y = 4
integer width = 4544
integer height = 2328
boolean titlebar = true
string title = "Line Master"
string dataobject = "d_mcn_machine_mounter_status_matrix"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_mcn_machine_mounter_status_master
end type

