HA$PBExportHeader$w_mcn_jig_issue_master.srw
$PBExportComments$Material Receipt Master
forward
global type w_mcn_jig_issue_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mcn_jig_issue_master
end type
type uo_dateend from uo_ymd_calendar within w_mcn_jig_issue_master
end type
type st_3 from so_statictext within w_mcn_jig_issue_master
end type
type st_4 from so_statictext within w_mcn_jig_issue_master
end type
type rb_arrival from so_radiobutton within w_mcn_jig_issue_master
end type
type rb_issue from so_radiobutton within w_mcn_jig_issue_master
end type
type sle_jig_code from so_singlelineedit within w_mcn_jig_issue_master
end type
type cb_batch_issue from so_commandbutton within w_mcn_jig_issue_master
end type
type cb_issue_cancel from so_commandbutton within w_mcn_jig_issue_master
end type
type ddlb_issue_account from uo_basecode within w_mcn_jig_issue_master
end type
type st_6 from so_statictext within w_mcn_jig_issue_master
end type
type ddlb_machine_code from uo_machine_code within w_mcn_jig_issue_master
end type
type ddlb_workstage_code from uo_workstage_code_all within w_mcn_jig_issue_master
end type
type st_1 from so_statictext within w_mcn_jig_issue_master
end type
type st_2 from so_statictext within w_mcn_jig_issue_master
end type
type ddlb_jig_type from uo_basecode within w_mcn_jig_issue_master
end type
type st_5 from so_statictext within w_mcn_jig_issue_master
end type
type ddlb_issue_status from uo_basecode within w_mcn_jig_issue_master
end type
type st_7 from so_statictext within w_mcn_jig_issue_master
end type
type ddlb_1 from uo_line_code within w_mcn_jig_issue_master
end type
type st_8 from so_statictext within w_mcn_jig_issue_master
end type
type gb_1 from so_groupbox within w_mcn_jig_issue_master
end type
type gb_2 from so_groupbox within w_mcn_jig_issue_master
end type
type gb_4 from so_groupbox within w_mcn_jig_issue_master
end type
end forward

global type w_mcn_jig_issue_master from w_main_root
integer width = 4827
integer height = 3028
string title = "JIG Issue Master"
uo_dateset uo_dateset
uo_dateend uo_dateend
st_3 st_3
st_4 st_4
rb_arrival rb_arrival
rb_issue rb_issue
sle_jig_code sle_jig_code
cb_batch_issue cb_batch_issue
cb_issue_cancel cb_issue_cancel
ddlb_issue_account ddlb_issue_account
st_6 st_6
ddlb_machine_code ddlb_machine_code
ddlb_workstage_code ddlb_workstage_code
st_1 st_1
st_2 st_2
ddlb_jig_type ddlb_jig_type
st_5 st_5
ddlb_issue_status ddlb_issue_status
st_7 st_7
ddlb_1 ddlb_1
st_8 st_8
gb_1 gb_1
gb_2 gb_2
gb_4 gb_4
end type
global w_mcn_jig_issue_master w_mcn_jig_issue_master

on w_mcn_jig_issue_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_3=create st_3
this.st_4=create st_4
this.rb_arrival=create rb_arrival
this.rb_issue=create rb_issue
this.sle_jig_code=create sle_jig_code
this.cb_batch_issue=create cb_batch_issue
this.cb_issue_cancel=create cb_issue_cancel
this.ddlb_issue_account=create ddlb_issue_account
this.st_6=create st_6
this.ddlb_machine_code=create ddlb_machine_code
this.ddlb_workstage_code=create ddlb_workstage_code
this.st_1=create st_1
this.st_2=create st_2
this.ddlb_jig_type=create ddlb_jig_type
this.st_5=create st_5
this.ddlb_issue_status=create ddlb_issue_status
this.st_7=create st_7
this.ddlb_1=create ddlb_1
this.st_8=create st_8
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.rb_arrival
this.Control[iCurrent+6]=this.rb_issue
this.Control[iCurrent+7]=this.sle_jig_code
this.Control[iCurrent+8]=this.cb_batch_issue
this.Control[iCurrent+9]=this.cb_issue_cancel
this.Control[iCurrent+10]=this.ddlb_issue_account
this.Control[iCurrent+11]=this.st_6
this.Control[iCurrent+12]=this.ddlb_machine_code
this.Control[iCurrent+13]=this.ddlb_workstage_code
this.Control[iCurrent+14]=this.st_1
this.Control[iCurrent+15]=this.st_2
this.Control[iCurrent+16]=this.ddlb_jig_type
this.Control[iCurrent+17]=this.st_5
this.Control[iCurrent+18]=this.ddlb_issue_status
this.Control[iCurrent+19]=this.st_7
this.Control[iCurrent+20]=this.ddlb_1
this.Control[iCurrent+21]=this.st_8
this.Control[iCurrent+22]=this.gb_1
this.Control[iCurrent+23]=this.gb_2
this.Control[iCurrent+24]=this.gb_4
end on

on w_mcn_jig_issue_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.rb_arrival)
destroy(this.rb_issue)
destroy(this.sle_jig_code)
destroy(this.cb_batch_issue)
destroy(this.cb_issue_cancel)
destroy(this.ddlb_issue_account)
destroy(this.st_6)
destroy(this.ddlb_machine_code)
destroy(this.ddlb_workstage_code)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.ddlb_jig_type)
destroy(this.st_5)
destroy(this.ddlb_issue_status)
destroy(this.st_7)
destroy(this.ddlb_1)
destroy(this.st_8)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_4)
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
Ivs_resize_type                      = 'MASTER_DETAIL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


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
f_retrieve()
sle_jig_code.setfocus()
end event

event ue_data_control;call super::ue_data_control;long row
string lvs_date
double LVDB_RCV_ISS_SEQ
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
			dw_1.reset()
			dw_2.reset()
			dw_3.reset()
			if rb_arrival.checked = true  then 
			    dw_1.retrieve(sle_jig_code.text + '%',  ddlb_jig_type.GETCODE()+'%' ,  gvi_organization_id)
			else
				dw_3.retrieve(uo_dateset.text() , uo_dateend.text() , sle_jig_code.text + '%',ddlb_jig_type.GETCODE()+'%' , ddlb_issue_status.getcode()+'%' ,  gvi_organization_id)
			end if 
	
    case 'INSERT'
		
			ROW = DW_2.INSERTROW(0)
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')
              
			LVDB_RCV_ISS_SEQ  = F_GET_SEQUENCE('SEQ_MAT_ISSUE')
			
			DW_2.SETITEM( ROW , 'ISSUE_DATE' , F_T_SYSDATE() )
			DW_2.SETITEM( ROW , 'ISSUE_SEQUENCE' , LVDB_RCV_ISS_SEQ )
			DW_2.SETITEM( ROW , 'ISSUE_DEFICIT' , '3' )
			DW_2.SETITEM( ROW , 'ISSUE_STATUS' , 'N' ) //$$HEX5$$85c7e0acc1c0dcd02000$$ENDHEX$$N $$HEX3$$15c8c1c02000$$ENDHEX$$, C $$HEX2$$e8cd8cc1$$ENDHEX$$
			
	case 'APPEND'		
			
			ROW = DW_2.INSERTROW(DW_2.GETROW())
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')	

			LVDB_RCV_ISS_SEQ  = F_GET_SEQUENCE('SEQ_MAT_ISSUE')
			
			DW_2.SETITEM( ROW , 'ISSUE_DATE' , F_T_SYSDATE() )
			DW_2.SETITEM( ROW , 'ISSUE_SEQUENCE' , LVDB_RCV_ISS_SEQ )
			DW_2.SETITEM( ROW , 'ISSUE_DEFICIT' , '3' )
			DW_2.SETITEM( ROW , 'ISSUE_STATUS' , 'N' ) //$$HEX5$$85c7e0acc1c0dcd02000$$ENDHEX$$N $$HEX3$$15c8c1c02000$$ENDHEX$$, C $$HEX2$$e8cd8cc1$$ENDHEX$$
			
   		    DW_2.SETFOCUS()
		    F_MSG_MDI_HELP( F_MSG_ST(152 ))
			
	case 'DELETE'
		
		  	if DW_2.AcceptText() = -1 then
				return
			end if
			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
				Gvl_row_deleted = DW_2.GetRow()			
				DW_2.DELETEROW(Gvl_row_deleted)		
				DW_2.SetFocus()
				ROW = DW_2.GetRow()
				DW_2.ScrollToRow(row)
				DW_2.SetColumn(1)
			END IF		 
			
   case 'UPDATE'
		
			IF DW_2.UPDATE() < 0  THEN
			  	 ROLLBACK;
				 RETURN
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"			 
			END IF

	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mcn_jig_issue_master
integer y = 652
end type

type dw_4 from w_main_root`dw_4 within w_mcn_jig_issue_master
integer y = 652
end type

type dw_3 from w_main_root`dw_3 within w_mcn_jig_issue_master
integer y = 632
integer width = 4544
integer height = 1240
boolean titlebar = true
string title = "JIG Issue List"
string dataobject = "d_mcn_jig_issue_lst"
end type

type dw_2 from w_main_root`dw_2 within w_mcn_jig_issue_master
integer y = 1876
integer width = 4549
integer height = 412
string dataobject = "d_mcn_jig_issue_mst"
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_2::rbuttondown;call super::rbuttondown;if dwo.name = 'supplier_code' then 	
	//open(w_com_mold_supplier_popup)	
	if  gst_return.gvb_return  = true then
	   this.object.supplier_code[row] = message.stringparm
	   gst_return.gvs_return[1]  = ''		
	end if
end if

if dwo.name = 'jig_code' then 
	open(w_mcn_jig_popup)	
	if  gst_return.gvb_return  = true then
	   this.object.jig_code[row] = message.stringparm
	   this.trigger event itemchanged( row , this.object.jig_code , this.object.jig_code[row] )
	end if	
	
end if
end event

type dw_1 from w_main_root`dw_1 within w_mcn_jig_issue_master
integer y = 632
integer width = 4544
integer height = 1244
boolean titlebar = true
string title = "JIG Inventory List"
string dataobject = "d_mcn_jig_inventory_4_issue_lst"
end type

event dw_1::itemchanged;call super::itemchanged;if dwo.name = 'issue_qty' then 
	
	if long(data) = 0 or isnull(data) then 
		
		this.object.check_yn[row] = 'N' 
	else
		this.object.check_yn[row] = 'Y' 		
	end if 
	
end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mcn_jig_issue_master
end type

type uo_dateset from uo_ymd_calendar within w_mcn_jig_issue_master
event destroy ( )
integer x = 1385
integer y = 156
integer taborder = 30
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mcn_jig_issue_master
event destroy ( )
integer x = 1801
integer y = 156
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_3 from so_statictext within w_mcn_jig_issue_master
integer x = 654
integer y = 80
integer width = 718
integer height = 68
boolean bringtotop = true
string text = "JIG Code"
end type

type st_4 from so_statictext within w_mcn_jig_issue_master
integer x = 1390
integer y = 76
integer width = 814
integer height = 68
boolean bringtotop = true
string text = "Date"
end type

type rb_arrival from so_radiobutton within w_mcn_jig_issue_master
integer x = 50
integer y = 80
integer width = 553
boolean bringtotop = true
integer weight = 700
string text = "JIG List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1
cb_batch_issue.enabled = true
cb_issue_cancel.enabled = false

end event

type rb_issue from so_radiobutton within w_mcn_jig_issue_master
integer x = 50
integer y = 184
integer width = 553
boolean bringtotop = true
integer weight = 700
string text = "JIG Issue List"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3
cb_batch_issue.enabled = false
cb_issue_cancel.enabled = true
end event

type sle_jig_code from so_singlelineedit within w_mcn_jig_issue_master
integer x = 654
integer y = 160
integer width = 718
integer height = 84
integer taborder = 40
boolean bringtotop = true
textcase textcase = upper!
end type

event modified;call super::modified;f_retrieve()
end event

type cb_batch_issue from so_commandbutton within w_mcn_jig_issue_master
integer x = 3470
integer y = 352
integer width = 475
integer height = 124
integer taborder = 30
boolean bringtotop = true
string text = "Batch Issue"
end type

event clicked;call super::clicked;long LVDB_RCV_ISS_SEQ , Lvl_row , i , j
string lvs_line_code , lvs_workstage_code , lvs_machine_code , lvs_jig_issue_account , lvs_jig_location_code, lvs_jig_lot_no
datetime lvdt_date

if dw_1.getrow( ) < 1 then return

lvs_jig_issue_account =ddlb_issue_account.getcode( )
lvs_workstage_code = ddlb_workstage_code.getcode()

if lvs_jig_issue_account = '' or lvs_jig_issue_account='%' or isnull(lvs_jig_issue_account) then
	f_msgbox1( 102 , f_get_dual_lang_text( Gvs_language , "ISSUE ACCOUNT"))
	return
end if 

//if lvs_workstage_code = '' or lvs_workstage_code='%' or isnull(lvs_workstage_code) then
//	f_msgbox1( 102 , f_get_dual_lang_text( Gvs_language , "WORKSTAGE CODE"))
//	return
//end if 

msg = f_msgbox1(1161,this.text)
if msg = 1  then 
else
	return 
end if 

dw_2.reset()

for i = 1 to dw_1.rowcount()
	if dw_1.object.check_yn[i] = 'Y' then 
	
			Lvl_row = dw_2.insertrow(0)
			f_set_security_row( dw_2 , lvl_row , 'ALL')
			
			LVDB_RCV_ISS_SEQ  = F_GET_SEQUENCE('SEQ_JIG_ISSUE_SEQUENCE')

			DW_2.OBJECT.JIG_CODE[LVL_ROW] = dw_1.object.JIG_CODE[i]				
	
			DW_2.OBJECT.ISSUE_ACCOUNT[LVL_ROW] = lvs_jig_issue_account								
			DW_2.OBJECT.WORKSTAGE_CODE[LVL_ROW] = DDLB_WORKSTAGE_CODE.GETCODE()
			DW_2.OBJECT.MACHINE_CODE[LVL_ROW] = DDLB_MACHINE_CODE.GETCODE()
			DW_2.OBJECT.ISSUE_DATE[LVL_ROW] = F_T_SYSDATE()	
			DW_2.OBJECT.ISSUE_SEQUENCE[LVL_ROW] =LVDB_RCV_ISS_SEQ
			DW_2.OBJECT.ISSUE_DEFICIT[LVL_ROW] ='3'			
			DW_2.OBJECT.ISSUE_STATUS[LVL_ROW] ='N' 
			DW_2.OBJECT.ISSUE_QTY[LVL_ROW] = 1			
			
		     lvs_jig_lot_no =  dw_1.object.JIG_CODE[i]
				
			 //$$HEX10$$9ccde0ac98ccacb9200009000900090020002000$$ENDHEX$$
		    if dw_1.object.JIG_TYPE[i] = 'M' then
				
			   update imcn_jig
			  	   set issue_date = sysdate
		        where jig_lot_no = :lvs_jig_lot_no
				   and jig_type   = 'M' 
				   and organization_id = :gvi_organization_id ; 
					
			   if f_sql_check() < 0 then 
					
					f_msg_mdi_help(f_msg_st(9026))
					
					rollback;
	                  j = 0
		             exit
						 
			   end if 
			
		   end if
			
			
		j++
	end if 
next
if j >0 then 
//	msg = f_msgbox1(9014,string(j))
    msg = 1
	if msg = 1 then 
		if dw_2.update() < 0 then 
			rollback;
		else
			commit ;
			f_retrieve()
		end if
	else
		rollback; 
		f_msg_mdi_help(f_msg_st(9026))
	end if 
end if 

sle_jig_code.setfocus()
end event

type cb_issue_cancel from so_commandbutton within w_mcn_jig_issue_master
integer x = 3470
integer y = 472
integer width = 475
integer height = 124
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
string text = "Issue Cancel"
end type

event clicked;call super::clicked;long lvl_seq, lvl_return , i , j 
string lvs_mfs
datetime lvdt_date
msg = f_msgbox1(1161,this.text)
if msg = 1  then 
else
	return 
end if 
for i = 1 to dw_3.rowcount()
	if dw_3.object.check_yn[i] = 'Y' then 
		lvdt_date = dw_3.object.issue_date[i]
		lvl_seq = dw_3.object.issue_sequence[i]
		lvl_return = f_mcn_jig_issue_cancel(lvdt_date, lvl_seq)
		if lvl_return < 1  then 
			rollback;
			return
		end if 
		j++
	end if 
next
if j >0 then 
//	msg = f_msgbox1(9014,string(j))
    msg = 1
	if msg = 1 then 
		commit ; 
		f_retrieve()
	else
		rollback; 
		f_msg_mdi_help(f_msg_st(9026))
	end if 
end if 

sle_jig_code.setfocus()
end event

type ddlb_issue_account from uo_basecode within w_mcn_jig_issue_master
integer x = 50
integer y = 480
integer width = 686
integer taborder = 60
boolean bringtotop = true
boolean autohscroll = true
end type

event constructor;call super::constructor;THIS.REdraw( 'JIG ISSUE ACCOUNT')
THIS.SELectitem(2)
end event

type st_6 from so_statictext within w_mcn_jig_issue_master
integer x = 50
integer y = 396
integer width = 686
integer height = 72
boolean bringtotop = true
string text = "JIG Issue Account"
end type

type ddlb_machine_code from uo_machine_code within w_mcn_jig_issue_master
integer x = 2354
integer y = 480
integer width = 814
integer height = 1232
integer taborder = 50
boolean bringtotop = true
boolean autohscroll = true
end type

type ddlb_workstage_code from uo_workstage_code_all within w_mcn_jig_issue_master
integer x = 1390
integer y = 484
integer width = 951
integer height = 1232
integer taborder = 30
boolean bringtotop = true
boolean allowedit = true
end type

type st_1 from so_statictext within w_mcn_jig_issue_master
integer x = 1390
integer y = 400
integer width = 951
integer height = 72
boolean bringtotop = true
string text = "Workstage Code"
end type

type st_2 from so_statictext within w_mcn_jig_issue_master
integer x = 2354
integer y = 388
integer width = 814
integer height = 72
boolean bringtotop = true
string text = "Machine Code"
end type

type ddlb_jig_type from uo_basecode within w_mcn_jig_issue_master
integer x = 2226
integer y = 152
integer width = 878
integer taborder = 70
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'JIG TYPE')
end event

type st_5 from so_statictext within w_mcn_jig_issue_master
integer x = 2231
integer y = 72
integer width = 878
integer height = 68
boolean bringtotop = true
long textcolor = 0
string text = "Jig Type"
end type

type ddlb_issue_status from uo_basecode within w_mcn_jig_issue_master
integer x = 3104
integer y = 152
integer width = 686
integer taborder = 70
boolean bringtotop = true
boolean autohscroll = true
end type

event constructor;call super::constructor;THIS.REdraw( 'ISSUE STATUS')

end event

type st_7 from so_statictext within w_mcn_jig_issue_master
integer x = 3104
integer y = 76
integer width = 686
integer height = 68
boolean bringtotop = true
long textcolor = 0
string text = "Issue Status"
end type

type ddlb_1 from uo_line_code within w_mcn_jig_issue_master
integer x = 750
integer y = 480
integer height = 1232
integer taborder = 40
boolean bringtotop = true
end type

type st_8 from so_statictext within w_mcn_jig_issue_master
integer x = 750
integer y = 388
integer width = 622
integer height = 72
boolean bringtotop = true
string text = "Line Code"
end type

type gb_1 from so_groupbox within w_mcn_jig_issue_master
integer width = 622
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_mcn_jig_issue_master
integer x = 626
integer width = 3342
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_4 from so_groupbox within w_mcn_jig_issue_master
integer y = 312
integer width = 3973
integer height = 300
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

