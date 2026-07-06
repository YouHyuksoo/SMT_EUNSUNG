HA$PBExportHeader$w_mat_sub_issue_cancel_master.srw
$PBExportComments$Sub Material Issue Cancel Master
forward
global type w_mat_sub_issue_cancel_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mat_sub_issue_cancel_master
end type
type uo_dateend from uo_ymd_calendar within w_mat_sub_issue_cancel_master
end type
type ddlb_parent_item_code from uo_item_code within w_mat_sub_issue_cancel_master
end type
type st_3 from so_statictext within w_mat_sub_issue_cancel_master
end type
type st_4 from so_statictext within w_mat_sub_issue_cancel_master
end type
type rb_issue_cancel from so_radiobutton within w_mat_sub_issue_cancel_master
end type
type rb_departure from so_radiobutton within w_mat_sub_issue_cancel_master
end type
type cb_set from so_commandbutton within w_mat_sub_issue_cancel_master
end type
type st_1 from so_statictext within w_mat_sub_issue_cancel_master
end type
type st_2 from so_statictext within w_mat_sub_issue_cancel_master
end type
type ddlb_mfs from uo_mfs_workorder within w_mat_sub_issue_cancel_master
end type
type ddlb_workstage_code from uo_workstage_code_all within w_mat_sub_issue_cancel_master
end type
type ddlb_item_code from uo_item_code within w_mat_sub_issue_cancel_master
end type
type st_5 from so_statictext within w_mat_sub_issue_cancel_master
end type
type gb_1 from so_groupbox within w_mat_sub_issue_cancel_master
end type
type gb_2 from so_groupbox within w_mat_sub_issue_cancel_master
end type
type gb_3 from so_groupbox within w_mat_sub_issue_cancel_master
end type
end forward

global type w_mat_sub_issue_cancel_master from w_main_root
integer width = 4841
integer height = 2964
string title = "Material Issue Cancel Master"
uo_dateset uo_dateset
uo_dateend uo_dateend
ddlb_parent_item_code ddlb_parent_item_code
st_3 st_3
st_4 st_4
rb_issue_cancel rb_issue_cancel
rb_departure rb_departure
cb_set cb_set
st_1 st_1
st_2 st_2
ddlb_mfs ddlb_mfs
ddlb_workstage_code ddlb_workstage_code
ddlb_item_code ddlb_item_code
st_5 st_5
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_mat_sub_issue_cancel_master w_mat_sub_issue_cancel_master

on w_mat_sub_issue_cancel_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.ddlb_parent_item_code=create ddlb_parent_item_code
this.st_3=create st_3
this.st_4=create st_4
this.rb_issue_cancel=create rb_issue_cancel
this.rb_departure=create rb_departure
this.cb_set=create cb_set
this.st_1=create st_1
this.st_2=create st_2
this.ddlb_mfs=create ddlb_mfs
this.ddlb_workstage_code=create ddlb_workstage_code
this.ddlb_item_code=create ddlb_item_code
this.st_5=create st_5
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.ddlb_parent_item_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.rb_issue_cancel
this.Control[iCurrent+7]=this.rb_departure
this.Control[iCurrent+8]=this.cb_set
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.ddlb_mfs
this.Control[iCurrent+12]=this.ddlb_workstage_code
this.Control[iCurrent+13]=this.ddlb_item_code
this.Control[iCurrent+14]=this.st_5
this.Control[iCurrent+15]=this.gb_1
this.Control[iCurrent+16]=this.gb_2
this.Control[iCurrent+17]=this.gb_3
end on

on w_mat_sub_issue_cancel_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.ddlb_parent_item_code)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.rb_issue_cancel)
destroy(this.rb_departure)
destroy(this.cb_set)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.ddlb_mfs)
destroy(this.ddlb_workstage_code)
destroy(this.ddlb_item_code)
destroy(this.st_5)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
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
F_MENU_CONTROL('DATA_CONTROL' , FALSE)  // All Data Control





end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
uo_dateset.settext(string(f_t_sysdate(), 'yyyy/mm')+'/01')
end event

event ue_data_control;call super::ue_data_control;long row
string lvs_date
double lvd_seq
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
			dw_1.reset()
			if  rb_issue_cancel.checked   then 
			    dw_1.retrieve(  uo_dateset.text() , uo_dateend.text(), ddlb_mfs.text+'%' , ddlb_workstage_code.getcode()+'%' , ddlb_item_code.text + '%', ddlb_parent_item_code.text+'%' ,  gvi_organization_id)
			else
				dw_2.reset()
				dw_2.retrieve( uo_dateset.text() , uo_dateend.text(), ddlb_mfs.text+'%' , ddlb_workstage_code.getcode()+'%' , ddlb_item_code.text + '%',   gvi_organization_id)
			end if 
	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mat_sub_issue_cancel_master
integer y = 316
end type

type dw_4 from w_main_root`dw_4 within w_mat_sub_issue_cancel_master
integer y = 316
boolean hscrollbar = false
boolean vscrollbar = false
end type

type dw_3 from w_main_root`dw_3 within w_mat_sub_issue_cancel_master
integer y = 316
end type

type dw_2 from w_main_root`dw_2 within w_mat_sub_issue_cancel_master
integer y = 316
integer width = 4544
integer height = 1564
boolean titlebar = true
string title = "Sub Material Issue List"
string dataobject = "d_mat_sub_issue_lst"
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_mat_sub_issue_cancel_master
integer y = 316
integer width = 4544
integer height = 1564
boolean titlebar = true
string title = "Sub Material Issue Cancel List"
string dataobject = "d_mat_sub_issue_cancel_lst"
end type

type uo_dateset from uo_ymd_calendar within w_mat_sub_issue_cancel_master
event destroy ( )
integer x = 837
integer y = 160
integer taborder = 30
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_sub_issue_cancel_master
event destroy ( )
integer x = 1253
integer y = 160
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_parent_item_code from uo_item_code within w_mat_sub_issue_cancel_master
integer x = 2642
integer y = 160
integer width = 498
integer taborder = 20
boolean bringtotop = true
end type

type st_3 from so_statictext within w_mat_sub_issue_cancel_master
integer x = 2642
integer y = 80
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Parent Item Code"
end type

type st_4 from so_statictext within w_mat_sub_issue_cancel_master
integer x = 841
integer y = 80
integer width = 814
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Issue Date"
end type

type rb_issue_cancel from so_radiobutton within w_mat_sub_issue_cancel_master
integer x = 59
integer y = 84
integer width = 631
boolean bringtotop = true
integer weight = 700
string text = "Sub Issue List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1

cb_set.enabled = true

end event

type rb_departure from so_radiobutton within w_mat_sub_issue_cancel_master
integer x = 59
integer y = 184
integer width = 677
boolean bringtotop = true
integer weight = 700
string text = "Sub Issue History List"
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
selected_data_window = dw_2

cb_set.enabled = false

end event

type cb_set from so_commandbutton within w_mat_sub_issue_cancel_master
integer x = 3762
integer y = 112
integer width = 498
integer height = 120
integer taborder = 30
boolean bringtotop = true
string text = "Issue Cancel"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 
if dw_1.rowcount() < 1 then return 
long  i , j 
Datetime lvdt_issue_date
String lvs_mfs
Double lvdb_work_order_no , lvl_issue_sequence

msg = f_msgbox1(1161,this.text)
if msg = 1 then 
else 
	return 
end if 

do
	i++
    if dw_1.object.check_yn[i] = 'Y' then 
    else
		continue
	end if
     lvs_mfs = dw_1.object.mfs[i]	
	lvdt_issue_date = dw_1.object.issue_date[i]
	lvl_issue_sequence = dw_1.object.issue_sequence[i]
	lvdb_work_order_no = double(dw_1.object.work_order_no[i])
	
	if f_mat_issue_cancel ( lvs_mfs , lvdt_issue_date ,  lvl_issue_sequence , lvdb_work_order_no , lvdt_issue_date) < 0 then 
	   rollback;
	   return
	end if
	j++
loop until i = dw_1.rowcount()

if j > 0 then 
	commit ;
	f_msgbox(170)
	f_retrieve()
else
	Rollback;
	Return
end if
end event

type st_1 from so_statictext within w_mat_sub_issue_cancel_master
integer x = 1669
integer y = 80
integer width = 430
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "MFS"
end type

type st_2 from so_statictext within w_mat_sub_issue_cancel_master
integer x = 2103
integer y = 80
integer width = 535
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Workstage Code"
end type

type ddlb_mfs from uo_mfs_workorder within w_mat_sub_issue_cancel_master
integer x = 1669
integer y = 160
integer width = 430
integer taborder = 20
boolean bringtotop = true
end type

type ddlb_workstage_code from uo_workstage_code_all within w_mat_sub_issue_cancel_master
integer x = 2103
integer y = 160
integer width = 539
integer taborder = 50
boolean bringtotop = true
end type

type ddlb_item_code from uo_item_code within w_mat_sub_issue_cancel_master
integer x = 3150
integer y = 160
integer width = 498
integer taborder = 60
boolean bringtotop = true
end type

type st_5 from so_statictext within w_mat_sub_issue_cancel_master
integer x = 3150
integer y = 80
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type gb_1 from so_groupbox within w_mat_sub_issue_cancel_master
integer x = 9
integer width = 773
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_mat_sub_issue_cancel_master
integer x = 795
integer width = 2926
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_mat_sub_issue_cancel_master
integer x = 3730
integer width = 567
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

