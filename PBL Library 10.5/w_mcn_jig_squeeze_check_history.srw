HA$PBExportHeader$w_mcn_jig_squeeze_check_history.srw
$PBExportComments$$$HEX8$$08ae15d680acacc074c725b800adacb9$$ENDHEX$$
forward
global type w_mcn_jig_squeeze_check_history from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mcn_jig_squeeze_check_history
end type
type uo_dateend from uo_ymd_calendar within w_mcn_jig_squeeze_check_history
end type
type st_4 from so_statictext within w_mcn_jig_squeeze_check_history
end type
type st_2 from so_statictext within w_mcn_jig_squeeze_check_history
end type
type sle_squeze_lot_no from so_singlelineedit within w_mcn_jig_squeeze_check_history
end type
type gb_2 from so_groupbox within w_mcn_jig_squeeze_check_history
end type
end forward

global type w_mcn_jig_squeeze_check_history from w_main_root
integer width = 5161
integer height = 3028
string title = "JIG Squeeze Check Master"
uo_dateset uo_dateset
uo_dateend uo_dateend
st_4 st_4
st_2 st_2
sle_squeze_lot_no sle_squeze_lot_no
gb_2 gb_2
end type
global w_mcn_jig_squeeze_check_history w_mcn_jig_squeeze_check_history

type variables
int row 
string lvs_jig_lot_no , lvs_jig_code
long lvl_break_value , lvl_hit_value 
end variables

on w_mcn_jig_squeeze_check_history.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_4=create st_4
this.st_2=create st_2
this.sle_squeze_lot_no=create sle_squeze_lot_no
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.sle_squeze_lot_no
this.Control[iCurrent+6]=this.gb_2
end on

on w_mcn_jig_squeeze_check_history.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_4)
destroy(this.st_2)
destroy(this.sle_squeze_lot_no)
destroy(this.gb_2)
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
* Menu Property 
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
uo_dateset.settext(string(f_t_sysdate(), 'yyyy/mm')+'/01')

end event

event ue_data_control;call super::ue_data_control;long lvl_jig_check_sequence


choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		

			dw_1.reset()
		    dw_1.retrieve(sle_squeze_lot_no.text + '%' , uo_dateset.text() , uo_dateend.text() ,  gvi_organization_id)		


		
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mcn_jig_squeeze_check_history
integer y = 308
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_mcn_jig_squeeze_check_history
integer y = 308
integer taborder = 0
end type

type dw_3 from w_main_root`dw_3 within w_mcn_jig_squeeze_check_history
integer y = 308
integer width = 2354
integer height = 1560
integer taborder = 0
boolean titlebar = true
end type

event dw_3::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return
datetime lvdt_dateset , lvdt_dateend 

lvdt_dateset  = uo_dateset.text()
lvdt_dateend  = uo_dateend.text()

dw_2.retrieve( this.object.jig_code[currentrow] , lvdt_dateset , lvdt_dateend , gvi_organization_id  )
end event

type dw_2 from w_main_root`dw_2 within w_mcn_jig_squeeze_check_history
integer y = 308
integer width = 4178
integer height = 656
integer taborder = 0
boolean titlebar = true
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_mcn_jig_squeeze_check_history
integer y = 308
integer width = 4183
integer height = 1560
integer taborder = 0
boolean titlebar = true
string dataobject = "d_mcn_jig_squeze_check_hst"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_mcn_jig_squeeze_check_history
integer taborder = 0
end type

type uo_dateset from uo_ymd_calendar within w_mcn_jig_squeeze_check_history
event destroy ( )
integer x = 832
integer y = 164
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mcn_jig_squeeze_check_history
event destroy ( )
integer x = 1248
integer y = 164
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_4 from so_statictext within w_mcn_jig_squeeze_check_history
integer x = 837
integer y = 84
integer width = 814
integer height = 68
boolean bringtotop = true
string text = "Date"
end type

type st_2 from so_statictext within w_mcn_jig_squeeze_check_history
integer x = 69
integer y = 84
integer width = 750
integer height = 68
boolean bringtotop = true
long textcolor = 0
string text = "SQUEEZE Lot No"
end type

type sle_squeze_lot_no from so_singlelineedit within w_mcn_jig_squeeze_check_history
integer x = 69
integer y = 164
integer width = 750
integer height = 84
boolean bringtotop = true
end type

type gb_2 from so_groupbox within w_mcn_jig_squeeze_check_history
integer width = 1701
integer height = 300
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

