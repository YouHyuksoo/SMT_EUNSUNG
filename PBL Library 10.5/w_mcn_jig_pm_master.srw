HA$PBExportHeader$w_mcn_jig_pm_master.srw
$PBExportComments$Customer Infromation Manage
forward
global type w_mcn_jig_pm_master from w_main_root
end type
type sle_jig_code from so_singlelineedit within w_mcn_jig_pm_master
end type
type st_1 from so_statictext within w_mcn_jig_pm_master
end type
type ddlb_jig_type from uo_basecode within w_mcn_jig_pm_master
end type
type st_6 from so_statictext within w_mcn_jig_pm_master
end type
type st_line_code from statictext within w_mcn_jig_pm_master
end type
type gb_1 from groupbox within w_mcn_jig_pm_master
end type
type ddlb_line_code from uo_line_code within w_mcn_jig_pm_master
end type
type cb_5 from so_commandbutton within w_mcn_jig_pm_master
end type
type cb_6 from so_commandbutton within w_mcn_jig_pm_master
end type
type cb_print from so_commandbutton within w_mcn_jig_pm_master
end type
type rb_list from so_radiobutton within w_mcn_jig_pm_master
end type
type rb_label from so_radiobutton within w_mcn_jig_pm_master
end type
type ddlb_pm_type from uo_basecode within w_mcn_jig_pm_master
end type
type st_3 from so_statictext within w_mcn_jig_pm_master
end type
type gb_2 from so_groupbox within w_mcn_jig_pm_master
end type
type gb_3 from so_groupbox within w_mcn_jig_pm_master
end type
type gb_4 from so_groupbox within w_mcn_jig_pm_master
end type
end forward

global type w_mcn_jig_pm_master from w_main_root
integer y = 256
integer width = 6048
integer height = 3104
string title = "JIG PM Master"
windowstate windowstate = maximized!
sle_jig_code sle_jig_code
st_1 st_1
ddlb_jig_type ddlb_jig_type
st_6 st_6
st_line_code st_line_code
gb_1 gb_1
ddlb_line_code ddlb_line_code
cb_5 cb_5
cb_6 cb_6
cb_print cb_print
rb_list rb_list
rb_label rb_label
ddlb_pm_type ddlb_pm_type
st_3 st_3
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
end type
global w_mcn_jig_pm_master w_mcn_jig_pm_master

on w_mcn_jig_pm_master.create
int iCurrent
call super::create
this.sle_jig_code=create sle_jig_code
this.st_1=create st_1
this.ddlb_jig_type=create ddlb_jig_type
this.st_6=create st_6
this.st_line_code=create st_line_code
this.gb_1=create gb_1
this.ddlb_line_code=create ddlb_line_code
this.cb_5=create cb_5
this.cb_6=create cb_6
this.cb_print=create cb_print
this.rb_list=create rb_list
this.rb_label=create rb_label
this.ddlb_pm_type=create ddlb_pm_type
this.st_3=create st_3
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_jig_code
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.ddlb_jig_type
this.Control[iCurrent+4]=this.st_6
this.Control[iCurrent+5]=this.st_line_code
this.Control[iCurrent+6]=this.gb_1
this.Control[iCurrent+7]=this.ddlb_line_code
this.Control[iCurrent+8]=this.cb_5
this.Control[iCurrent+9]=this.cb_6
this.Control[iCurrent+10]=this.cb_print
this.Control[iCurrent+11]=this.rb_list
this.Control[iCurrent+12]=this.rb_label
this.Control[iCurrent+13]=this.ddlb_pm_type
this.Control[iCurrent+14]=this.st_3
this.Control[iCurrent+15]=this.gb_2
this.Control[iCurrent+16]=this.gb_3
this.Control[iCurrent+17]=this.gb_4
end on

on w_mcn_jig_pm_master.destroy
call super::destroy
destroy(this.sle_jig_code)
destroy(this.st_1)
destroy(this.ddlb_jig_type)
destroy(this.st_6)
destroy(this.st_line_code)
destroy(this.gb_1)
destroy(this.ddlb_line_code)
destroy(this.cb_5)
destroy(this.cb_6)
destroy(this.cb_print)
destroy(this.rb_list)
destroy(this.rb_label)
destroy(this.ddlb_pm_type)
destroy(this.st_3)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
end on

event activate;call super::activate;/***************************************
* $$HEX17$$08c7c4b324c115c8d0c5200000ad5cd52000acc06dd544c720004bc105d35cd5e4b2$$ENDHEX$$
*
*
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20051101'
Gst_set.last_modify_date = '20051101'
Gst_set.Report_window    = False  // Report Window  True / Flase

/*****************************************
* Data WIndow Property
******************************************/
Ivs_resize_type    = 'MASTER_DETAIL_145TF_23M'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

/****************************************
* Menu Property $$HEX6$$54ba74b2200078d5e4b4c1b9$$ENDHEX$$
*****************************************
* ADMIN     : ADMIN  ( $$HEX5$$04c8b4ccacc0a9c62000$$ENDHEX$$)
* $$HEX8$$00adacb9200020002000200020002000$$ENDHEX$$: MANAGE ( $$HEX8$$04c854ba74b2acc0a9c600aca5b22000$$ENDHEX$$)
* $$HEX7$$acc0a9c690c72000200020002000$$ENDHEX$$: GUEST  ( $$HEX11$$30ae08cd2000f1b45db8200070c88cd6200000aca5b2$$ENDHEX$$)
* $$HEX8$$70c88cd6200020002000200020002000$$ENDHEX$$: QUERY  ( $$HEX10$$15c8f4bc70c88cd6ccb9200000aca5b220002000$$ENDHEX$$)
* $$HEX5$$70b374c7c0d070c891c7$$ENDHEX$$: DATA_CONTROL  ( $$HEX12$$85c725b8200018c215c82000adc01cc8200024c115c82000$$ENDHEX$$)
* $$HEX7$$08b8ecd3b8d22000200020002000$$ENDHEX$$: REPORT ( $$HEX4$$08b8ecd3b8d22000$$ENDHEX$$, $$HEX5$$9ccd25b800adacb92000$$ENDHEX$$)
****************************************/

F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control

/****************************************
* 
****************************************/

end event

event ue_data_control;call super::ue_data_control;Long ROW
CHOOSE CASE Gvs_Ue_DATA_control
		
	CASE 'RETRIEVE'
		
		IF RB_LIST.CHECKED = TRUE THEN 
			
			DW_1.RESET( )
			DW_1.RETRIEVE(  sle_jig_code.text+'%' , ddlb_jig_type.getcode( )+'%' , ddlb_line_code.getcode( )+'%'  ,  gvi_organization_id )
		ELSE
			DW_4.RETRIEVE(   ddlb_line_code.getcode( )+'%'  , sle_jig_code.text+'%' , ddlb_jig_type.getcode( )+'%' ,    ddlb_pm_type.getcode()+'%' , gvs_language ,  gvi_organization_id )
	
		END IF 
			 
	CASE 'INSERT'
	
				if dw_1.getrow() < 1 then return 
				ROW = dw_2.insertrow( 0)		
				DW_2.SCROLLTOROW(ROW)
				F_SET_SECURITY_ROW(DW_2 , ROW , 'ALL')
				
				dw_2.object.line_code[ROW] = dw_1.object.line_code[dw_1.getrow()]
				dw_2.object.jig_code[ROW] = dw_1.object.jig_code[dw_1.getrow()]
				dw_2.object.jig_lot_no[ROW] = dw_1.object.jig_lot_no[dw_1.getrow()]
				
	CASE 'APPEND'

					   
						
	CASE 'DELETE'
		
		
		  	if dw_2.getrow() < 1 then return 
			  
			msg =f_msgbox(1003)
			if msg = 1 then
				gvl_row_deleted = dw_2.getrow()			
				dw_2.deleterow(gvl_row_deleted)		
				dw_2.setfocus()
				row = dw_2.getrow()
				dw_2.scrolltorow(row)
				dw_2.setcolumn(1)
			end if	
	
			
	CASE 'UPDATE'
	
		IF DW_2.UPDATE() < 0  THEN
			ROLLBACK;
		ELSE
			COMMIT;
			F_MSG_MDI_HELP ( F_MSG_ST(170)	 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
		END IF

 		
	CASE ELSE
END CHOOSE



//Long ROW
//CHOOSE CASE Gvs_Ue_DATA_control
//		
//	CASE 'RETRIEVE'
//		
//			DW_1.RESET( )
//			DW_1.RETRIEVE(  sle_jig_code.text+'%' , ddlb_jig_type.getcode( )+'%' , ddlb_line_code.getcode( )+'%'  ,  gvi_organization_id )
//			 
//	CASE 'INSERT'
//		
//
//		
//CASE 'APPEND'
//
//					   
//						
//	CASE 'DELETE'
//		
//	
//			
//	CASE 'UPDATE'
//	
//			
//		IF DW_2.UPDATE() < 0  or  DW_3.UPDATE() < 0  THEN
//			ROLLBACK;
//		ELSE
//			COMMIT;
//			F_MSG_MDI_HELP ( F_MSG_ST(170)	 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
//		END IF
//
// 		
//	CASE ELSE
//END CHOOSE
//
//
end event

event ue_post_open;call super::ue_post_open;  
/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_mcn_jig_pm_master
integer y = 292
end type

type dw_4 from w_main_root`dw_4 within w_mcn_jig_pm_master
integer y = 292
integer width = 5051
integer height = 1120
integer taborder = 80
boolean titlebar = true
string dataobject = "d_mcn_jig_pm_label_rpt"
end type

type dw_3 from w_main_root`dw_3 within w_mcn_jig_pm_master
integer x = 2519
integer y = 1412
integer width = 2505
integer height = 844
integer taborder = 70
boolean titlebar = true
string dataobject = "d_mcn_jig_pm_plan_hist"
borderstyle borderstyle = styleraised!
end type

type dw_2 from w_main_root`dw_2 within w_mcn_jig_pm_master
integer y = 1412
integer width = 2505
integer height = 844
integer taborder = 100
boolean titlebar = true
string dataobject = "d_mcn_jig_pm_plan_lst"
end type

event dw_2::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
	dw_3.retrieve( dw_2.object.line_code[currentrow] , dw_2.object.jig_code[currentrow] , dw_2.object.jig_lot_no[currentrow] , dw_2.object.pm_type[currentrow] , gvi_organization_id     )
end event

type dw_1 from w_main_root`dw_1 within w_mcn_jig_pm_master
integer y = 292
integer width = 5051
integer height = 1120
boolean titlebar = true
string title = "JIG List"
string dataobject = "d_mcn_jig_4_pm_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow = 0 then return

	dw_2.retrieve( dw_1.object.line_code[currentrow]  , dw_1.object.jig_code[currentrow] , dw_1.object.jig_lot_no[currentrow] , gvi_organization_id )

end event

type uo_tabpages from w_main_root`uo_tabpages within w_mcn_jig_pm_master
end type

type sle_jig_code from so_singlelineedit within w_mcn_jig_pm_master
integer x = 1193
integer y = 156
integer width = 471
integer height = 84
integer taborder = 20
boolean bringtotop = true
end type

type st_1 from so_statictext within w_mcn_jig_pm_master
integer x = 1193
integer y = 80
integer width = 471
integer height = 68
boolean bringtotop = true
string text = "JIG Code"
end type

type ddlb_jig_type from uo_basecode within w_mcn_jig_pm_master
integer x = 1669
integer y = 156
integer width = 603
integer height = 1876
integer taborder = 60
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;this.redraw( 'JIG TYPE')
end event

type st_6 from so_statictext within w_mcn_jig_pm_master
integer x = 1669
integer y = 84
integer width = 603
integer height = 68
boolean bringtotop = true
long textcolor = 0
string text = "JIG Type"
end type

type st_line_code from statictext within w_mcn_jig_pm_master
integer x = 553
integer y = 80
integer width = 631
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Line Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_mcn_jig_pm_master
integer x = 512
integer width = 2281
integer height = 272
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Where Condition"
end type

type ddlb_line_code from uo_line_code within w_mcn_jig_pm_master
integer x = 553
integer y = 156
integer height = 1876
integer taborder = 70
boolean bringtotop = true
end type

type cb_5 from so_commandbutton within w_mcn_jig_pm_master
integer x = 2862
integer y = 104
integer width = 347
integer height = 120
integer taborder = 80
boolean bringtotop = true
string text = "Confirm"
end type

event clicked;call super::clicked;if dw_2.getrow() < 1 then return 

datetime lvdt_null , lvdt_pm_date
string  lvs_line_code , lvs_jig_code,lvs_comments , lvs_pm_type ,lvs_pm_division , lvs_jig_lot_no
long lvl_break_value,lvl_hit_value

lvdt_pm_date = f_sysdate() 

msg = f_msgbox1(1160 , this.text) 

if msg = 1 then 
	
	  lvs_line_code = dw_2.object.line_code[dw_2.getrow()]
	  lvs_jig_code = dw_2.object.jig_code[dw_2.getrow()]
	  lvs_jig_lot_no  = dw_2.object.jig_lot_no[dw_2.getrow()]
	  lvl_break_value = dw_2.object.break_value[dw_2.getrow()]

	  lvs_comments = dw_2.object.comments[dw_2.getrow()]
	  lvl_hit_value = dw_2.object.hit_value[dw_2.getrow()]
	  lvs_pm_type = dw_2.object.pm_type[dw_2.getrow()]
      lvs_pm_division= dw_2.object.pm_division[dw_2.getrow()]
		
		
        INSERT INTO imcn_jig_pm_master_hist (organization_id,
                                               jig_code,
										  jig_lot_no , 					  
                                               break_value,
										  plan_date,					  
                                               pm_date,
                                               comments,
                                               enter_date,
                                               enter_by,
                                               last_modify_date,
                                               last_modify_by,
                                               hit_value,
                                               pm_type,
                                               confirm_yn,
										  pm_division)
            VALUES   (:gvi_organization_id,
						:lvs_jig_code,
						:lvs_jig_lot_no ,
						:lvl_break_value,
						sysdate ,
						:lvdt_pm_date,
						:lvs_comments,
						sysdate,
						:gvs_user_id ,
						sysdate,
						:gvs_user_id ,
						nvl(:lvl_hit_value,0) ,
						:lvs_pm_type,
						'Y' ,
						:lvs_pm_division);
	
	if f_sql_check() < 0 then 
		return 
	end if 
	
	dw_2.object.hit_value[dw_2.getrow()] = 0 
	dw_2.object.pm_date[dw_2.getrow()] =lvdt_pm_date
	
	if dw_2.update( ) < 0 then 
		rollback;
	else
		commit ;
	end if 

end if 



end event

type cb_6 from so_commandbutton within w_mcn_jig_pm_master
integer x = 3195
integer y = 104
integer width = 347
integer height = 120
integer taborder = 90
boolean bringtotop = true
string text = "Cancel"
end type

event clicked;call super::clicked;if dw_2.getrow() < 1 then return 

datetime  lvdt_pm_date , lvdt_null
string  lvs_jig_code,lvs_comments , lvs_pm_type , lvs_jig_lot_no
long lvl_break_value,lvl_hit_value , lvl_hit_value_new
setnull(lvdt_null)
msg = f_msgbox1(1160 , this.text) 

if msg = 1 then 
	
	  lvs_jig_code = dw_2.object.jig_code[dw_2.getrow()]
	  lvs_jig_lot_no= dw_2.object.jig_lot_no[dw_2.getrow()]
	  lvl_break_value = dw_2.object.break_value[dw_2.getrow()]
	  
	  lvs_comments = dw_2.object.comments[dw_2.getrow()]
	  lvs_pm_type = dw_2.object.pm_type[dw_2.getrow()]
	  lvdt_pm_date = dw_2.object.pm_date[dw_2.getrow()]
	 
	 
	 select hit_value into :lvl_hit_value_new
 		   from 	imcn_jig_pm_master
	  where jig_code = :lvs_jig_code
	     and jig_lot_no = :lvs_jig_lot_no
	     and pm_type = :lvs_pm_type
		 and organization_id = :gvi_organization_id ;	 
		if f_sql_check() < 0 then 
			return 
		end if 
		
	  select  hit_value
	     into  :lvl_hit_value
	     from 	imcn_jig_pm_master_hist 
	  where jig_code = :lvs_jig_code
	     and jig_lot_no = :lvs_jig_lot_no
	     and pm_type = :lvs_pm_type
		 and pm_date = :lvdt_pm_date 
		 and organization_id = :gvi_organization_id ;
		 
	if f_sql_check() < 0 then 
		return 
	end if 		 
	
      delete  from  imcn_jig_pm_master_hist 
	  where jig_code = :lvs_jig_code
	     and jig_lot_no = :lvs_jig_lot_no
	     and pm_type = :lvs_pm_type
		 and pm_date = :lvdt_pm_date 
		 and organization_id = :gvi_organization_id ;
		 
		
	if f_sql_check() < 0 then 
		return 
	end if 
	
	dw_2.object.hit_value[dw_2.getrow()] = lvl_hit_value  +lvl_hit_value_new
	dw_2.object.pm_date[dw_2.getrow()] = lvdt_null
	
	if dw_2.update( ) < 0 then 
		rollback;
	else
		commit ;
	end if 

end if 



end event

type cb_print from so_commandbutton within w_mcn_jig_pm_master
integer x = 3621
integer y = 100
integer width = 347
integer height = 120
integer taborder = 110
boolean bringtotop = true
string text = "Print"
end type

event clicked;call super::clicked;if rb_label.checked = true then 
	dw_4.print( false )
end if 
end event

type rb_list from so_radiobutton within w_mcn_jig_pm_master
integer x = 37
integer y = 72
integer width = 453
boolean bringtotop = true
string text = "List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
dw_2.bringtotop = true 
dw_3.bringtotop = true 
cb_print.enabled = false
selected_data_window = dw_1
end event

type rb_label from so_radiobutton within w_mcn_jig_pm_master
integer x = 37
integer y = 160
integer width = 453
boolean bringtotop = true
string text = "PM Label"
end type

event clicked;call super::clicked;cb_print.enabled = true
dw_4.bringtotop = true 
selected_data_window = dw_4
end event

type ddlb_pm_type from uo_basecode within w_mcn_jig_pm_master
integer x = 2281
integer y = 156
integer width = 494
integer height = 1876
integer taborder = 80
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;this.redraw( 'PM TYPE')
end event

type st_3 from so_statictext within w_mcn_jig_pm_master
integer x = 2281
integer y = 76
integer width = 494
integer height = 68
boolean bringtotop = true
long textcolor = 0
string text = "PM Type"
end type

type gb_2 from so_groupbox within w_mcn_jig_pm_master
integer x = 2798
integer width = 777
integer height = 272
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "PM Process"
end type

type gb_3 from so_groupbox within w_mcn_jig_pm_master
integer x = 3589
integer width = 411
integer height = 272
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Print"
end type

type gb_4 from so_groupbox within w_mcn_jig_pm_master
integer width = 507
integer height = 272
integer taborder = 40
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

