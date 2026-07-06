HA$PBExportHeader$w_mcn_jig_mask_check_history.srw
$PBExportComments$$$HEX8$$08ae15d680acacc074c725b800adacb9$$ENDHEX$$
forward
global type w_mcn_jig_mask_check_history from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mcn_jig_mask_check_history
end type
type uo_dateend from uo_ymd_calendar within w_mcn_jig_mask_check_history
end type
type st_4 from so_statictext within w_mcn_jig_mask_check_history
end type
type st_2 from so_statictext within w_mcn_jig_mask_check_history
end type
type sle_jig_lot_no from so_singlelineedit within w_mcn_jig_mask_check_history
end type
type ddlb_model_name from uo_set_model_name_ddlb within w_mcn_jig_mask_check_history
end type
type st_1 from so_statictext within w_mcn_jig_mask_check_history
end type
type gb_2 from so_groupbox within w_mcn_jig_mask_check_history
end type
end forward

global type w_mcn_jig_mask_check_history from w_main_root
integer width = 5024
integer height = 3028
string title = "Mask Tension Manual Check Master"
uo_dateset uo_dateset
uo_dateend uo_dateend
st_4 st_4
st_2 st_2
sle_jig_lot_no sle_jig_lot_no
ddlb_model_name ddlb_model_name
st_1 st_1
gb_2 gb_2
end type
global w_mcn_jig_mask_check_history w_mcn_jig_mask_check_history

type variables
string lvs_jig_lot_no , lvs_jig_code
long lvl_break_value , lvl_hit_value ,lvl_row
end variables

on w_mcn_jig_mask_check_history.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_4=create st_4
this.st_2=create st_2
this.sle_jig_lot_no=create sle_jig_lot_no
this.ddlb_model_name=create ddlb_model_name
this.st_1=create st_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.sle_jig_lot_no
this.Control[iCurrent+6]=this.ddlb_model_name
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.gb_2
end on

on w_mcn_jig_mask_check_history.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_4)
destroy(this.st_2)
destroy(this.sle_jig_lot_no)
destroy(this.ddlb_model_name)
destroy(this.st_1)
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

end event

event ue_data_control;call super::ue_data_control;string lvs_date
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
				
					   dw_1.retrieve( ddlb_model_name.getcode()+'%' ,  sle_jig_lot_no.text+'%' ,   uo_dateset.text() , uo_dateend.text() ,  gvi_organization_id)		
	

	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mcn_jig_mask_check_history
integer y = 308
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_mcn_jig_mask_check_history
integer y = 308
integer taborder = 0
end type

type dw_3 from w_main_root`dw_3 within w_mcn_jig_mask_check_history
integer y = 308
integer width = 4544
integer height = 1092
integer taborder = 0
boolean titlebar = true
end type

type dw_2 from w_main_root`dw_2 within w_mcn_jig_mask_check_history
integer y = 308
integer width = 4544
integer height = 1092
integer taborder = 0
boolean titlebar = true
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_2::rbuttondown;call super::rbuttondown;if dwo.name = 'repair_vendor_code' then 	
	open(w_com_supplier_popup)	
	if  gst_return.gvb_return  = true then
	   this.object.repair_vendor_code[row] = message.stringparm
	   gst_return.gvs_return[1]  = ''		
	end if
end if
end event

type dw_1 from w_main_root`dw_1 within w_mcn_jig_mask_check_history
integer y = 308
integer width = 4544
integer height = 1092
integer taborder = 0
boolean titlebar = true
string title = "Metal Mask Inventory"
string dataobject = "d_mcn_jig_mask_check_lst"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_mcn_jig_mask_check_history
integer taborder = 0
end type

type uo_dateset from uo_ymd_calendar within w_mcn_jig_mask_check_history
event destroy ( )
integer x = 1943
integer y = 172
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mcn_jig_mask_check_history
event destroy ( )
integer x = 2359
integer y = 172
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_4 from so_statictext within w_mcn_jig_mask_check_history
integer x = 1947
integer y = 92
integer width = 814
integer height = 68
boolean bringtotop = true
string text = "Receipt Date"
end type

type st_2 from so_statictext within w_mcn_jig_mask_check_history
integer x = 1102
integer y = 92
integer width = 832
integer height = 68
boolean bringtotop = true
long textcolor = 0
string text = "JIG Lot No"
end type

type sle_jig_lot_no from so_singlelineedit within w_mcn_jig_mask_check_history
integer x = 1102
integer y = 172
integer width = 832
integer height = 84
boolean bringtotop = true
end type

type ddlb_model_name from uo_set_model_name_ddlb within w_mcn_jig_mask_check_history
integer x = 206
integer y = 172
integer width = 887
integer height = 1936
integer taborder = 60
boolean bringtotop = true
end type

type st_1 from so_statictext within w_mcn_jig_mask_check_history
integer x = 210
integer y = 104
integer width = 887
integer height = 68
boolean bringtotop = true
string text = "Model Name"
end type

type gb_2 from so_groupbox within w_mcn_jig_mask_check_history
integer x = 14
integer width = 2798
integer height = 300
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

