HA$PBExportHeader$w_pln_smd_plan_append_popup.srw
$PBExportComments$(Item Query)-$$HEX4$$80bd88d470c88cd6$$ENDHEX$$
forward
global type w_pln_smd_plan_append_popup from w_popup_root
end type
type cb_select from commandbutton within w_pln_smd_plan_append_popup
end type
type cb_retrieve from commandbutton within w_pln_smd_plan_append_popup
end type
type st_9 from so_statictext within w_pln_smd_plan_append_popup
end type
type st_1 from statictext within w_pln_smd_plan_append_popup
end type
type uo_dateend from uo_ymd_calendar within w_pln_smd_plan_append_popup
end type
type ddlb_master_model_name from uo_master_model_name_ddlb within w_pln_smd_plan_append_popup
end type
type sle_workorder_no from so_singlelineedit within w_pln_smd_plan_append_popup
end type
type st_2 from statictext within w_pln_smd_plan_append_popup
end type
type ddlb_line_code from uo_line_code within w_pln_smd_plan_append_popup
end type
type st_3 from so_statictext within w_pln_smd_plan_append_popup
end type
type em_plan_qty from so_editmask within w_pln_smd_plan_append_popup
end type
type st_4 from statictext within w_pln_smd_plan_append_popup
end type
type cb_save from commandbutton within w_pln_smd_plan_append_popup
end type
type ddlb_shift_code from uo_basecode within w_pln_smd_plan_append_popup
end type
type st_5 from statictext within w_pln_smd_plan_append_popup
end type
type ddlb_top_bottom from uo_basecode within w_pln_smd_plan_append_popup
end type
type st_6 from statictext within w_pln_smd_plan_append_popup
end type
type gb_1 from so_groupbox within w_pln_smd_plan_append_popup
end type
type gb_2 from so_groupbox within w_pln_smd_plan_append_popup
end type
end forward

global type w_pln_smd_plan_append_popup from w_popup_root
integer width = 5015
integer height = 1968
string title = "Model Master Popup"
boolean minbox = true
windowtype windowtype = popup!
boolean contexthelp = false
cb_select cb_select
cb_retrieve cb_retrieve
st_9 st_9
st_1 st_1
uo_dateend uo_dateend
ddlb_master_model_name ddlb_master_model_name
sle_workorder_no sle_workorder_no
st_2 st_2
ddlb_line_code ddlb_line_code
st_3 st_3
em_plan_qty em_plan_qty
st_4 st_4
cb_save cb_save
ddlb_shift_code ddlb_shift_code
st_5 st_5
ddlb_top_bottom ddlb_top_bottom
st_6 st_6
gb_1 gb_1
gb_2 gb_2
end type
global w_pln_smd_plan_append_popup w_pln_smd_plan_append_popup

on w_pln_smd_plan_append_popup.create
int iCurrent
call super::create
this.cb_select=create cb_select
this.cb_retrieve=create cb_retrieve
this.st_9=create st_9
this.st_1=create st_1
this.uo_dateend=create uo_dateend
this.ddlb_master_model_name=create ddlb_master_model_name
this.sle_workorder_no=create sle_workorder_no
this.st_2=create st_2
this.ddlb_line_code=create ddlb_line_code
this.st_3=create st_3
this.em_plan_qty=create em_plan_qty
this.st_4=create st_4
this.cb_save=create cb_save
this.ddlb_shift_code=create ddlb_shift_code
this.st_5=create st_5
this.ddlb_top_bottom=create ddlb_top_bottom
this.st_6=create st_6
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_select
this.Control[iCurrent+2]=this.cb_retrieve
this.Control[iCurrent+3]=this.st_9
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.uo_dateend
this.Control[iCurrent+6]=this.ddlb_master_model_name
this.Control[iCurrent+7]=this.sle_workorder_no
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.ddlb_line_code
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.em_plan_qty
this.Control[iCurrent+12]=this.st_4
this.Control[iCurrent+13]=this.cb_save
this.Control[iCurrent+14]=this.ddlb_shift_code
this.Control[iCurrent+15]=this.st_5
this.Control[iCurrent+16]=this.ddlb_top_bottom
this.Control[iCurrent+17]=this.st_6
this.Control[iCurrent+18]=this.gb_1
this.Control[iCurrent+19]=this.gb_2
end on

on w_pln_smd_plan_append_popup.destroy
call super::destroy
destroy(this.cb_select)
destroy(this.cb_retrieve)
destroy(this.st_9)
destroy(this.st_1)
destroy(this.uo_dateend)
destroy(this.ddlb_master_model_name)
destroy(this.sle_workorder_no)
destroy(this.st_2)
destroy(this.ddlb_line_code)
destroy(this.st_3)
destroy(this.em_plan_qty)
destroy(this.st_4)
destroy(this.cb_save)
destroy(this.ddlb_shift_code)
destroy(this.st_5)
destroy(this.ddlb_top_bottom)
destroy(this.st_6)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;//this.setredraw( false)
//f_set_layered_window( handle(this) , 85 )
//postevent('ue_post_open')

dw_1.settransobject(sqlca)



end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
end if
end event

type p_title from w_popup_root`p_title within w_pln_smd_plan_append_popup
integer width = 5010
end type

type cb_sort from w_popup_root`cb_sort within w_pln_smd_plan_append_popup
boolean visible = true
integer x = 50
integer y = 16
integer width = 279
integer height = 144
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_pln_smd_plan_append_popup
boolean visible = true
integer x = 4722
integer y = 260
integer width = 279
integer height = 144
integer taborder = 0
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_pln_smd_plan_append_popup
boolean visible = true
integer y = 484
integer width = 5010
end type

type dw_1 from w_popup_root`dw_1 within w_pln_smd_plan_append_popup
boolean visible = true
integer y = 588
integer width = 5010
integer height = 1304
integer taborder = 70
boolean titlebar = true
string dataobject = "d_des_model_master_by_master_model_popup"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
CB_SELECT.TRIGGEREVENT(CLICKED!)
end event

type dw_2 from w_popup_root`dw_2 within w_pln_smd_plan_append_popup
boolean visible = true
integer y = 772
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_pln_smd_plan_append_popup
integer y = 784
end type

type cb_select from commandbutton within w_pln_smd_plan_append_popup
integer x = 3877
integer y = 264
integer width = 279
integer height = 144
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Append"
boolean default = true
end type

event clicked;int row 	, lvl_carrier_size , lvl_plan_qty
double lvdb_seq	 , lvdb_group_seq
string lvs_master_model_name , lvs_model_name , lvs_item_code , lvs_work_order_no , LVS_LINE_CODE , lvs_shift_code , lvs_pcb_item


LVS_LINE_CODE =  ddlb_line_code.GETCODE() 
lvs_work_order_no = sle_workorder_no.text
lvs_master_model_name = ddlb_master_model_name.getcode()
lvl_plan_qty = long( em_plan_qty.text )
lvs_shift_code = ddlb_shift_code.getcode()
lvs_pcb_item =ddlb_top_bottom.getcode()

IF LVS_LINE_CODE = ''  or LVS_LINE_CODE = '%' or isnull(LVS_LINE_CODE) THEN 
	f_msgbox1(102  ,f_get_dual_lang_text ( gvs_language , 'LINE CODE'))
	RETURN 
END IF 
IF lvs_pcb_item = ''  or lvs_pcb_item = '%' or isnull(lvs_pcb_item) THEN 
	f_msgbox1(102  ,f_get_dual_lang_text ( gvs_language , 'PCB ITEM'))
	RETURN 
END IF 
IF lvs_master_model_name = ''  or lvs_master_model_name = '%' or isnull(lvs_master_model_name) THEN 
	f_msgbox1(102  ,f_get_dual_lang_text ( gvs_language , 'MASTER MODEL NAME'))
	RETURN 
END IF 

IF lvs_work_order_no = ''  or lvs_work_order_no = '%' or isnull(lvs_work_order_no) THEN 
	f_msgbox1(102  ,f_get_dual_lang_text ( gvs_language ,'Work Order No'))
	RETURN 
END IF 


IF lvs_shift_code = ''  or lvs_shift_code = '%' or isnull(lvs_shift_code) THEN 
	f_msgbox1(102  ,f_get_dual_lang_text ( gvs_language , 'SHIFT CODE'))
	RETURN 
END IF 
//============================================
//
//============================================
declare cl1 cursor for select model_name , item_code , carrier_size 
    from ip_product_model_master
  where master_model_name = :lvs_master_model_name 
       and organization_id = :gvi_organization_id ;
		 

lvdb_group_seq = double(f_get_sequence( 'seq_plan_date_sequence'))

open cl1 ;

do
	
		fetch cl1 into :lvs_model_name , :lvs_item_code , :lvl_carrier_size  ;
		
		if sqlca.sqlcode = 100 then 
			close cl1 ;
			exit 
		end if 
		
		if f_sql_check() < 0 then 
			close cl1 ;
			exit 
		end if 

		ROW = w_pln_assembly_master_plan_master.dw_1.INSERTROW(w_pln_assembly_master_plan_master.dw_1.GETROW())
		w_pln_assembly_master_plan_master.dw_1.SCROLLTOROW(ROW)
		F_SET_SECURITY_ROW(w_pln_assembly_master_plan_master.dw_1 , ROW ,'ALL')
		
		w_pln_assembly_master_plan_master.dw_1.object.plan_date[row] =  uo_dateend.text() //  f_t_sysdate()		
		lvdb_seq = double(f_get_sequence( 'seq_plan_date_sequence'))
		w_pln_assembly_master_plan_master.dw_1.object.plan_sequence[row] = 	lvdb_seq
		w_pln_assembly_master_plan_master.dw_1.object.mfs_group_no[row] = 	'SMG'+STRING(lvdb_group_seq)
		w_pln_assembly_master_plan_master.dw_1.object.mfs[row] = 	'SMD'+STRING(lvdb_seq)
		w_pln_assembly_master_plan_master.dw_1.object.line_code[row] = 	LVS_LINE_CODE		
		w_pln_assembly_master_plan_master.dw_1.object.plan_status[row] = 	 'W'
		w_pln_assembly_master_plan_master.dw_1.object.plan_priority[row] = 	1
		w_pln_assembly_master_plan_master.dw_1.object.shift_code[row] = 	lvs_shift_code
		
		w_pln_assembly_master_plan_master.dw_1.object.pcb_item[row] = lvs_pcb_item
		w_pln_assembly_master_plan_master.dw_1.object.production_type[row] = 	'P'
		
		w_pln_assembly_master_plan_master.dw_1.object.master_model_name[row] = 	lvs_master_model_name
		w_pln_assembly_master_plan_master.dw_1.object.model_name[row] = 	lvs_model_name
		w_pln_assembly_master_plan_master.dw_1.object.model_suffix[row] = '*'
		w_pln_assembly_master_plan_master.dw_1.object.parent_item_code[row] = lvs_item_code
		w_pln_assembly_master_plan_master.dw_1.object.item_code[row] = '*'			
		w_pln_assembly_master_plan_master.dw_1.object.work_order_no[row] =lvs_work_order_no			
		w_pln_assembly_master_plan_master.dw_1.object.plan_qty[row] = lvl_plan_qty
		
		w_pln_assembly_master_plan_master.dw_1.object.actual_qty[row] = 0
		w_pln_assembly_master_plan_master.dw_1.object.plan_qty_d1[row] = 0
		w_pln_assembly_master_plan_master.dw_1.object.plan_qty_d2[row] = 0
		w_pln_assembly_master_plan_master.dw_1.object.plan_qty_d3[row] = 0

		w_pln_assembly_master_plan_master.dw_1.object.plan_time1[row] = 0
		w_pln_assembly_master_plan_master.dw_1.object.plan_time2[row] = 0
		w_pln_assembly_master_plan_master.dw_1.object.plan_time3[row] = 0
		w_pln_assembly_master_plan_master.dw_1.object.plan_time4[row] = 0						
		w_pln_assembly_master_plan_master.dw_1.object.plan_time5[row] = 0
		w_pln_assembly_master_plan_master.dw_1.object.plan_time6[row] = 0						
		w_pln_assembly_master_plan_master.dw_1.object.plan_time7[row] = 0
		w_pln_assembly_master_plan_master.dw_1.object.plan_time8[row] = 0
		w_pln_assembly_master_plan_master.dw_1.object.plan_time9[row] = 0
		w_pln_assembly_master_plan_master.dw_1.object.plan_time10[row] = 0								
		
loop until 1= 2 
end event

type cb_retrieve from commandbutton within w_pln_smd_plan_append_popup
integer x = 4160
integer y = 264
integer width = 279
integer height = 144
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE(   ddlb_master_model_name.GETCODE()+'%' ,  GVI_ORGANIZATION_ID )
end event

type st_9 from so_statictext within w_pln_smd_plan_append_popup
integer x = 745
integer y = 248
integer width = 809
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Model Name"
end type

type st_1 from statictext within w_pln_smd_plan_append_popup
integer x = 1559
integer y = 248
integer width = 416
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Plan Date"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_dateend from uo_ymd_calendar within w_pln_smd_plan_append_popup
event destroy ( )
integer x = 1559
integer y = 332
integer height = 88
integer taborder = 40
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_master_model_name from uo_master_model_name_ddlb within w_pln_smd_plan_append_popup
integer x = 745
integer y = 332
integer height = 1736
integer taborder = 50
boolean bringtotop = true
end type

event selectionchanged;call super::selectionchanged;dw_1.retrieve( this.getcode() , gvi_organization_id )
end event

type sle_workorder_no from so_singlelineedit within w_pln_smd_plan_append_popup
integer x = 1984
integer y = 332
integer taborder = 50
boolean bringtotop = true
end type

type st_2 from statictext within w_pln_smd_plan_append_popup
integer x = 1979
integer y = 248
integer width = 498
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Work Order No"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_line_code from uo_line_code within w_pln_smd_plan_append_popup
integer x = 201
integer y = 328
integer width = 535
integer height = 1936
integer taborder = 50
boolean bringtotop = true
end type

type st_3 from so_statictext within w_pln_smd_plan_append_popup
integer x = 201
integer y = 248
integer width = 539
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Line Code"
end type

type em_plan_qty from so_editmask within w_pln_smd_plan_append_popup
integer x = 3424
integer y = 328
integer taborder = 60
boolean bringtotop = true
string text = ""
string mask = "###,##0"
boolean spin = true
double increment = 1
end type

type st_4 from statictext within w_pln_smd_plan_append_popup
integer x = 3424
integer y = 248
integer width = 402
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Plan Qty"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_save from commandbutton within w_pln_smd_plan_append_popup
integer x = 4443
integer y = 264
integer width = 279
integer height = 144
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Save"
end type

event clicked;if w_pln_assembly_master_plan_master.dw_1.update() < 0 then 
  rollback;
else
	commit ;
end if 

end event

type ddlb_shift_code from uo_basecode within w_pln_smd_plan_append_popup
integer x = 2491
integer y = 332
integer width = 471
integer taborder = 60
boolean bringtotop = true
end type

event constructor;call super::constructor;THIS.REDRAW('SHIFT CODE')
end event

type st_5 from statictext within w_pln_smd_plan_append_popup
integer x = 2496
integer y = 248
integer width = 498
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Shift Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_top_bottom from uo_basecode within w_pln_smd_plan_append_popup
integer x = 2971
integer y = 332
integer width = 448
integer taborder = 60
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw('TOP BOTTOM')
end event

type st_6 from statictext within w_pln_smd_plan_append_popup
integer x = 2971
integer y = 248
integer width = 448
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Top/Bottom"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from so_groupbox within w_pln_smd_plan_append_popup
integer y = 180
integer width = 3858
integer height = 284
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_pln_smd_plan_append_popup
integer x = 3867
integer y = 180
integer width = 1147
integer height = 276
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

