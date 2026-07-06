HA$PBExportHeader$w_mcn_machine_pm_master.srw
$PBExportComments$Customer Infromation Manage
forward
global type w_mcn_machine_pm_master from w_main_root
end type
type sle_machine_code from so_singlelineedit within w_mcn_machine_pm_master
end type
type st_1 from so_statictext within w_mcn_machine_pm_master
end type
type ddlb_machine_type from uo_basecode within w_mcn_machine_pm_master
end type
type st_6 from so_statictext within w_mcn_machine_pm_master
end type
type st_line_code from statictext within w_mcn_machine_pm_master
end type
type gb_1 from groupbox within w_mcn_machine_pm_master
end type
type ddlb_line_code from uo_line_code within w_mcn_machine_pm_master
end type
type cb_5 from so_commandbutton within w_mcn_machine_pm_master
end type
type cb_6 from so_commandbutton within w_mcn_machine_pm_master
end type
type rb_list from so_radiobutton within w_mcn_machine_pm_master
end type
type rb_label from so_radiobutton within w_mcn_machine_pm_master
end type
type ddlb_pm_type from uo_basecode within w_mcn_machine_pm_master
end type
type st_3 from so_statictext within w_mcn_machine_pm_master
end type
type cb_print from so_commandbutton within w_mcn_machine_pm_master
end type
type cb_1 from so_commandbutton within w_mcn_machine_pm_master
end type
type st_2 from so_statictext within w_mcn_machine_pm_master
end type
type ddlb_dest_machine_code from uo_machine_code_by_line within w_mcn_machine_pm_master
end type
type ddlb_dest_line_code from uo_line_code within w_mcn_machine_pm_master
end type
type st_4 from so_statictext within w_mcn_machine_pm_master
end type
type gb_2 from so_groupbox within w_mcn_machine_pm_master
end type
type gb_3 from so_groupbox within w_mcn_machine_pm_master
end type
type gb_4 from so_groupbox within w_mcn_machine_pm_master
end type
type gb_5 from so_groupbox within w_mcn_machine_pm_master
end type
end forward

global type w_mcn_machine_pm_master from w_main_root
integer y = 256
integer width = 6048
integer height = 3104
string title = "Machine PM Master"
windowstate windowstate = maximized!
sle_machine_code sle_machine_code
st_1 st_1
ddlb_machine_type ddlb_machine_type
st_6 st_6
st_line_code st_line_code
gb_1 gb_1
ddlb_line_code ddlb_line_code
cb_5 cb_5
cb_6 cb_6
rb_list rb_list
rb_label rb_label
ddlb_pm_type ddlb_pm_type
st_3 st_3
cb_print cb_print
cb_1 cb_1
st_2 st_2
ddlb_dest_machine_code ddlb_dest_machine_code
ddlb_dest_line_code ddlb_dest_line_code
st_4 st_4
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
gb_5 gb_5
end type
global w_mcn_machine_pm_master w_mcn_machine_pm_master

on w_mcn_machine_pm_master.create
int iCurrent
call super::create
this.sle_machine_code=create sle_machine_code
this.st_1=create st_1
this.ddlb_machine_type=create ddlb_machine_type
this.st_6=create st_6
this.st_line_code=create st_line_code
this.gb_1=create gb_1
this.ddlb_line_code=create ddlb_line_code
this.cb_5=create cb_5
this.cb_6=create cb_6
this.rb_list=create rb_list
this.rb_label=create rb_label
this.ddlb_pm_type=create ddlb_pm_type
this.st_3=create st_3
this.cb_print=create cb_print
this.cb_1=create cb_1
this.st_2=create st_2
this.ddlb_dest_machine_code=create ddlb_dest_machine_code
this.ddlb_dest_line_code=create ddlb_dest_line_code
this.st_4=create st_4
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_5=create gb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_machine_code
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.ddlb_machine_type
this.Control[iCurrent+4]=this.st_6
this.Control[iCurrent+5]=this.st_line_code
this.Control[iCurrent+6]=this.gb_1
this.Control[iCurrent+7]=this.ddlb_line_code
this.Control[iCurrent+8]=this.cb_5
this.Control[iCurrent+9]=this.cb_6
this.Control[iCurrent+10]=this.rb_list
this.Control[iCurrent+11]=this.rb_label
this.Control[iCurrent+12]=this.ddlb_pm_type
this.Control[iCurrent+13]=this.st_3
this.Control[iCurrent+14]=this.cb_print
this.Control[iCurrent+15]=this.cb_1
this.Control[iCurrent+16]=this.st_2
this.Control[iCurrent+17]=this.ddlb_dest_machine_code
this.Control[iCurrent+18]=this.ddlb_dest_line_code
this.Control[iCurrent+19]=this.st_4
this.Control[iCurrent+20]=this.gb_2
this.Control[iCurrent+21]=this.gb_3
this.Control[iCurrent+22]=this.gb_4
this.Control[iCurrent+23]=this.gb_5
end on

on w_mcn_machine_pm_master.destroy
call super::destroy
destroy(this.sle_machine_code)
destroy(this.st_1)
destroy(this.ddlb_machine_type)
destroy(this.st_6)
destroy(this.st_line_code)
destroy(this.gb_1)
destroy(this.ddlb_line_code)
destroy(this.cb_5)
destroy(this.cb_6)
destroy(this.rb_list)
destroy(this.rb_label)
destroy(this.ddlb_pm_type)
destroy(this.st_3)
destroy(this.cb_print)
destroy(this.cb_1)
destroy(this.st_2)
destroy(this.ddlb_dest_machine_code)
destroy(this.ddlb_dest_line_code)
destroy(this.st_4)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_5)
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
			DW_1.RETRIEVE(  sle_machine_code.text+'%' , ddlb_machine_type.getcode( )+'%' , ddlb_line_code.getcode( )+'%'  ,  gvi_organization_id )
		ELSE
			
			DW_4.RETRIEVE(   ddlb_line_code.getcode( )+'%'  , sle_machine_code.text+'%' , ddlb_machine_type.getcode( )+'%' ,    ddlb_pm_type.getcode()+'%' , gvs_language ,  gvi_organization_id )
		
			
		END IF 
	CASE 'INSERT'
	
				if dw_1.getrow() < 1 then return 
				ROW = dw_2.insertrow( 0)		
				DW_2.SCROLLTOROW(ROW)
				F_SET_SECURITY_ROW(DW_2 , ROW , 'ALL')
				
				dw_2.object.line_code[ROW] = dw_1.object.line_code[dw_1.getrow()]
				dw_2.object.machine_code[ROW] = dw_1.object.machine_code[dw_1.getrow()]
				
				
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


end event

event ue_post_open;call super::ue_post_open;  
/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_mcn_machine_pm_master
integer x = 14
integer y = 284
end type

type dw_4 from w_main_root`dw_4 within w_mcn_machine_pm_master
integer x = 14
integer y = 284
integer width = 5051
integer height = 1120
integer taborder = 80
boolean titlebar = true
string title = "PM Label"
string dataobject = "d_mcn_machine_pm_label_rpt"
end type

type dw_3 from w_main_root`dw_3 within w_mcn_machine_pm_master
integer x = 2519
integer y = 1412
integer width = 2505
integer height = 844
integer taborder = 70
boolean titlebar = true
string dataobject = "d_mcn_machine_pm_plan_hist"
borderstyle borderstyle = styleraised!
end type

type dw_2 from w_main_root`dw_2 within w_mcn_machine_pm_master
integer y = 1412
integer width = 2505
integer height = 844
integer taborder = 100
boolean titlebar = true
string dataobject = "d_mcn_machine_pm_plan_lst"
end type

event dw_2::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
	dw_3.retrieve( dw_2.object.line_code[currentrow] , dw_2.object.machine_code[currentrow] , dw_2.object.pm_type[currentrow] , gvi_organization_id     )
end event

type dw_1 from w_main_root`dw_1 within w_mcn_machine_pm_master
integer x = 14
integer y = 284
integer width = 5051
integer height = 1120
boolean titlebar = true
string title = "Machine List"
string dataobject = "d_mcn_machine_4_pm_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow = 0 then return

	dw_2.retrieve( dw_1.object.line_code[currentrow]  , dw_1.object.machine_code[currentrow] , gvi_organization_id )

end event

type uo_tabpages from w_main_root`uo_tabpages within w_mcn_machine_pm_master
end type

type sle_machine_code from so_singlelineedit within w_mcn_machine_pm_master
integer x = 1061
integer y = 160
integer width = 471
integer taborder = 20
boolean bringtotop = true
end type

type st_1 from so_statictext within w_mcn_machine_pm_master
integer x = 1061
integer y = 84
integer width = 471
integer height = 68
boolean bringtotop = true
string text = "Machine Code"
end type

type ddlb_machine_type from uo_basecode within w_mcn_machine_pm_master
integer x = 1536
integer y = 160
integer width = 864
integer height = 2108
integer taborder = 60
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;this.redraw( 'MACHINE TYPE')
end event

type st_6 from so_statictext within w_mcn_machine_pm_master
integer x = 1536
integer y = 88
integer width = 864
integer height = 68
boolean bringtotop = true
long textcolor = 0
string text = "Machine Type"
end type

type st_line_code from statictext within w_mcn_machine_pm_master
integer x = 535
integer y = 84
integer width = 521
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

type gb_1 from groupbox within w_mcn_machine_pm_master
integer x = 485
integer y = 4
integer width = 2807
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

type ddlb_line_code from uo_line_code within w_mcn_machine_pm_master
integer x = 535
integer y = 160
integer width = 521
integer height = 1876
integer taborder = 70
boolean bringtotop = true
end type

type cb_5 from so_commandbutton within w_mcn_machine_pm_master
integer x = 3351
integer y = 60
integer width = 347
integer height = 100
integer taborder = 80
boolean bringtotop = true
string text = "Confirm"
end type

event clicked;call super::clicked;if dw_2.getrow() < 1 then return 

datetime lvdt_null , lvdt_pm_date
string  lvs_line_code , lvs_machine_code,lvs_comments , lvs_pm_type ,lvs_pm_division
long lvl_break_value,lvl_hit_value

lvdt_pm_date = f_sysdate() 

msg = f_msgbox1(1160 , this.text) 

if msg = 1 then 
	
	  lvs_line_code = dw_2.object.line_code[dw_2.getrow()]
	  lvs_machine_code = dw_2.object.machine_code[dw_2.getrow()]
	  lvl_break_value = dw_2.object.break_value[dw_2.getrow()]

	  lvs_comments = dw_2.object.comments[dw_2.getrow()]
	  lvl_hit_value = dw_2.object.hit_value[dw_2.getrow()]
	  lvs_pm_type = dw_2.object.pm_type[dw_2.getrow()]
      lvs_pm_division= dw_2.object.pm_division[dw_2.getrow()]
		
		
        INSERT INTO imcn_machine_pm_master_hist (organization_id,
                                               machine_code,
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
						:lvs_machine_code,
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

type cb_6 from so_commandbutton within w_mcn_machine_pm_master
integer x = 3351
integer y = 152
integer width = 347
integer height = 112
integer taborder = 90
boolean bringtotop = true
string text = "Cancel"
end type

event clicked;call super::clicked;if dw_2.getrow() < 1 then return 

datetime  lvdt_pm_date , lvdt_null
string  lvs_machine_code,lvs_comments , lvs_pm_type
long lvl_break_value,lvl_hit_value , lvl_hit_value_new
setnull(lvdt_null)
msg = f_msgbox1(1160 , this.text) 

if msg = 1 then 
	
	  lvs_machine_code = dw_2.object.machine_code[dw_2.getrow()]
	  lvl_break_value = dw_2.object.break_value[dw_2.getrow()]
	  
	  lvs_comments = dw_2.object.comments[dw_2.getrow()]
	  lvs_pm_type = dw_2.object.pm_type[dw_2.getrow()]
	  lvdt_pm_date = dw_2.object.pm_date[dw_2.getrow()]
	 
	 
	 select hit_value into :lvl_hit_value_new
 		   from 	imcn_machine_pm_master
	  where machine_code = :lvs_machine_code
	     and pm_type = :lvs_pm_type
		 and organization_id = :gvi_organization_id ;	 
		if f_sql_check() < 0 then 
			return 
		end if 
		
	  select  hit_value
	     into  :lvl_hit_value
	     from 	imcn_machine_pm_master_hist 
	  where machine_code = :lvs_machine_code
	     and pm_type = :lvs_pm_type
		 and pm_date = :lvdt_pm_date 
		 and organization_id = :gvi_organization_id ;
		 
	if f_sql_check() < 0 then 
		return 
	end if 		 
	
      delete  from  imcn_machine_pm_master_hist 
	  where machine_code = :lvs_machine_code
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

type rb_list from so_radiobutton within w_mcn_machine_pm_master
integer x = 55
integer y = 72
integer width = 379
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

type rb_label from so_radiobutton within w_mcn_machine_pm_master
integer x = 55
integer y = 160
integer width = 379
boolean bringtotop = true
string text = "PM Label"
end type

event clicked;call super::clicked;cb_print.enabled = true
dw_4.bringtotop = true 
selected_data_window = dw_4
f_set_column_dddw( dw_4 )
end event

type ddlb_pm_type from uo_basecode within w_mcn_machine_pm_master
integer x = 2409
integer y = 160
integer width = 869
integer height = 2108
integer taborder = 70
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;this.redraw( 'PM TYPE')
end event

type st_3 from so_statictext within w_mcn_machine_pm_master
integer x = 2414
integer y = 76
integer width = 869
integer height = 68
boolean bringtotop = true
long textcolor = 0
string text = "PM Type"
end type

type cb_print from so_commandbutton within w_mcn_machine_pm_master
integer x = 5440
integer y = 100
integer width = 347
integer height = 120
integer taborder = 100
boolean bringtotop = true
string text = "Print"
end type

event clicked;call super::clicked;if rb_label.checked = true then 
	dw_4.print( false )
end if 
end event

type cb_1 from so_commandbutton within w_mcn_machine_pm_master
integer x = 3808
integer y = 100
integer width = 347
integer height = 120
integer taborder = 90
boolean bringtotop = true
string text = "Copy"
end type

event clicked;call super::clicked;STRING LVS_DEST_LINE_CODE , LVS_LINE_CODE
STRING LVS_DEST_MACHINE_CODE , LVS_MACHINE_CODE

LVS_DEST_LINE_CODE = DDLB_DEST_LINE_CODE.GETCODE() 
LVS_DEST_MACHINE_CODE = DDLB_DEST_MACHINE_CODE.GETCODE() 

IF LVS_DEST_LINE_CODE = '%' OR ISNULL(LVS_DEST_LINE_CODE) THEN 
	RETURN 
END IF 

IF LVS_DEST_MACHINE_CODE = '%' OR ISNULL(LVS_DEST_MACHINE_CODE) THEN 
	RETURN 
END IF 

if dw_1.getrow( ) < 1 then return 

MSG = F_MSGBOX1(1160 , THIS.TEXT ) 

IF MSG = 1 THEN 
ELSE
	RETURN 
END IF 

		LVS_LINE_CODE = DW_1.OBject.LINE_CODE[DW_1.GETROW()]
		LVS_MACHINE_CODE = DW_1.OBject.MACHINE_CODE[DW_1.GETROW()]

		  INSERT INTO "IMCN_MACHINE_PM_MASTER"  
					( "ORGANIZATION_ID",   
					  "LINE_CODE",   
					  "MACHINE_CODE",   
					  "PM_TYPE",   
					  "PLAN_DATE",   
					  "BREAK_VALUE",   
					  "HIT_VALUE",   
					  "PM_DATE",   
					  "COMMENTS",   
					  "CONFIRM_YN",   
					  "CONFIRM_BY",   
					  "CHARGER",   
					  "ENTER_DATE",   
					  "ENTER_BY",   
					  "LAST_MODIFY_DATE",   
					  "LAST_MODIFY_BY",   
					  "PM_DIVISION" )  
			  SELECT "IMCN_MACHINE_PM_MASTER"."ORGANIZATION_ID",   
						:LVS_DEST_LINE_CODE ,
						:LVS_DEST_MACHINE_CODE,   
						"IMCN_MACHINE_PM_MASTER"."PM_TYPE",   
						"IMCN_MACHINE_PM_MASTER"."PLAN_DATE",   
						"IMCN_MACHINE_PM_MASTER"."BREAK_VALUE",   
						"IMCN_MACHINE_PM_MASTER"."HIT_VALUE",   
						"IMCN_MACHINE_PM_MASTER"."PM_DATE",   
						"IMCN_MACHINE_PM_MASTER"."COMMENTS",   
						"IMCN_MACHINE_PM_MASTER"."CONFIRM_YN",   
						"IMCN_MACHINE_PM_MASTER"."CONFIRM_BY",   
						"IMCN_MACHINE_PM_MASTER"."CHARGER",   
						"IMCN_MACHINE_PM_MASTER"."ENTER_DATE",   
						"IMCN_MACHINE_PM_MASTER"."ENTER_BY",   
						"IMCN_MACHINE_PM_MASTER"."LAST_MODIFY_DATE",   
						"IMCN_MACHINE_PM_MASTER"."LAST_MODIFY_BY",   
						"IMCN_MACHINE_PM_MASTER"."PM_DIVISION"  
				 FROM "IMCN_MACHINE_PM_MASTER" 
		        WHERE LINE_CODE = :LVS_LINE_CODE
				    AND MACHINE_CODE = :LVS_MACHINE_CODE	
				    AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
				    AND ( LINE_CODE , MACHINE_CODE , PM_TYPE , ORGANIZATION_ID ) 
					      NOT IN ( SELECT LINE_CODE , MACHINE_CODE , PM_TYPE , ORGANIZATION_ID 
							             FROM IMCN_MACHINE_PM_MASTER
									  WHERE LINE_CODE = :LVS_DEST_LINE_CODE
									       AND MACHINE_CODE = :LVS_DEST_MACHINE_CODE
									       AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
									  ) ;

	IF F_SQL_CHECK() < 0 THEN 
		RETURN 
	END IF 
	
	COMMIT ;
	F_MSGBOX(170)
end event

type st_2 from so_statictext within w_mcn_machine_pm_master
integer x = 4745
integer y = 84
integer width = 626
integer height = 68
boolean bringtotop = true
string text = "Dest Machine Code"
end type

type ddlb_dest_machine_code from uo_machine_code_by_line within w_mcn_machine_pm_master
integer x = 4727
integer y = 156
integer height = 1740
integer taborder = 100
boolean bringtotop = true
end type

type ddlb_dest_line_code from uo_line_code within w_mcn_machine_pm_master
integer x = 4201
integer y = 156
integer width = 507
integer height = 1888
integer taborder = 70
boolean bringtotop = true
end type

event selectionchanged;call super::selectionchanged;ddlb_dest_machine_code.redraw( this.getcode() )
end event

type st_4 from so_statictext within w_mcn_machine_pm_master
integer x = 4201
integer y = 84
integer width = 507
integer height = 68
boolean bringtotop = true
string text = "Dest Line Code"
end type

type gb_2 from so_groupbox within w_mcn_machine_pm_master
integer x = 5408
integer width = 411
integer height = 272
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Print"
end type

type gb_3 from so_groupbox within w_mcn_machine_pm_master
integer x = 18
integer width = 462
integer height = 272
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_4 from so_groupbox within w_mcn_machine_pm_master
integer x = 3781
integer width = 1618
integer height = 272
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "PM Process"
end type

type gb_5 from so_groupbox within w_mcn_machine_pm_master
integer x = 3301
integer width = 466
integer height = 272
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "PM Process"
end type

