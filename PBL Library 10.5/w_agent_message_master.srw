HA$PBExportHeader$w_agent_message_master.srw
$PBExportComments$Dual Message  Information Manage
forward
global type w_agent_message_master from w_main_root
end type
type sle_english from so_singlelineedit within w_agent_message_master
end type
type sle_korea from so_singlelineedit within w_agent_message_master
end type
type sle_local from so_singlelineedit within w_agent_message_master
end type
type sle_msg_id from so_singlelineedit within w_agent_message_master
end type
type st_1 from so_statictext within w_agent_message_master
end type
type st_2 from so_statictext within w_agent_message_master
end type
type st_3 from so_statictext within w_agent_message_master
end type
type st_4 from so_statictext within w_agent_message_master
end type
type uo_user from uo_user_id_name within w_agent_message_master
end type
type st_5 from so_statictext within w_agent_message_master
end type
type rb_message_list from so_radiobutton within w_agent_message_master
end type
type rb_1 from so_radiobutton within w_agent_message_master
end type
type st_6 from so_statictext within w_agent_message_master
end type
type uo_dateset from uo_ymd_calendar within w_agent_message_master
end type
type uo_dateend from uo_ymd_calendar within w_agent_message_master
end type
type cb_1 from so_commandbutton within w_agent_message_master
end type
type gb_1 from so_groupbox within w_agent_message_master
end type
type gb_2 from so_groupbox within w_agent_message_master
end type
type gb_3 from so_groupbox within w_agent_message_master
end type
end forward

global type w_agent_message_master from w_main_root
string title = "Message Agent"
toolbaralignment toolbaralignment = floating!
sle_english sle_english
sle_korea sle_korea
sle_local sle_local
sle_msg_id sle_msg_id
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
uo_user uo_user
st_5 st_5
rb_message_list rb_message_list
rb_1 rb_1
st_6 st_6
uo_dateset uo_dateset
uo_dateend uo_dateend
cb_1 cb_1
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_agent_message_master w_agent_message_master

on w_agent_message_master.create
int iCurrent
call super::create
this.sle_english=create sle_english
this.sle_korea=create sle_korea
this.sle_local=create sle_local
this.sle_msg_id=create sle_msg_id
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.uo_user=create uo_user
this.st_5=create st_5
this.rb_message_list=create rb_message_list
this.rb_1=create rb_1
this.st_6=create st_6
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.cb_1=create cb_1
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_english
this.Control[iCurrent+2]=this.sle_korea
this.Control[iCurrent+3]=this.sle_local
this.Control[iCurrent+4]=this.sle_msg_id
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.uo_user
this.Control[iCurrent+10]=this.st_5
this.Control[iCurrent+11]=this.rb_message_list
this.Control[iCurrent+12]=this.rb_1
this.Control[iCurrent+13]=this.st_6
this.Control[iCurrent+14]=this.uo_dateset
this.Control[iCurrent+15]=this.uo_dateend
this.Control[iCurrent+16]=this.cb_1
this.Control[iCurrent+17]=this.gb_1
this.Control[iCurrent+18]=this.gb_2
this.Control[iCurrent+19]=this.gb_3
end on

on w_agent_message_master.destroy
call super::destroy
destroy(this.sle_english)
destroy(this.sle_korea)
destroy(this.sle_local)
destroy(this.sle_msg_id)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.uo_user)
destroy(this.st_5)
destroy(this.rb_message_list)
destroy(this.rb_1)
destroy(this.st_6)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.cb_1)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
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
Ivs_resize_type    = 'MASTER_DETAIL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'Y' //Default
ivs_dw_3_use_focusindicator = 'Y' //Default
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
CHOOSE CASE Gvs_ue_data_control
	CASE 'RETRIEVE'
		
	  if rb_message_list.checked = true then
		
	    DW_1.RETRIEVE(SLE_MSG_ID.TEXT+'%', SLE_ENGLISH.TEXT+'%', SLE_LOCAL.TEXT+'%', SLE_KOREA.TEXT+'%', Gvi_organization_id)
	    DW_2.RETRIEVE(GVS_LANGUAGE , UO_USER.GETCODE()+'%' , Gvi_organization_id)
         DW_1.SETFOCUS()
			
	else
		
	    DW_3.RETRIEVE( uo_dateset.text() , uo_dateend.text() ,GVS_LANGUAGE , Gvi_organization_id)
		 
	end if
			
	CASE 'INSERT'

			ROW = DW_1.INSERTROW(DW_1.GETROW())
			F_SET_SECURITY_ROW(DW_1 , ROW , 'ALL')
			F_MSG_MDI_HELP( F_MSG_ST(152) )			
	CASE 'APPEND'

			ROW = DW_1.INSERTROW(0)
			F_SET_SECURITY_ROW(DW_1 , ROW , 'ALL')	
			F_MSG_MDI_HELP( F_MSG_ST(152) )			
	CASE 'DELETE'
		
		if rb_message_list.checked = true then 
		
					IF DW_1.GETROW() < 1 THEN RETURN 
					  
					MSG = F_MSGBOX(1003) 
					IF MSG = 1 THEN
						GVL_ROW_DELETED = DW_1.GETROW()			
						DW_1.DELETEROW(GVL_ROW_DELETED)		
						DW_1.SETFOCUS()
						ROW = DW_1.GETROW()
						DW_1.SCROLLTOROW(ROW)
						DW_1.SETCOLUMN(1)
					END IF
		else
					IF DW_3.GETROW() < 1 THEN RETURN 
					  
					MSG = F_MSGBOX(1003) 
					IF MSG = 1 THEN
						GVL_ROW_DELETED = DW_3.GETROW()			
						DW_3.DELETEROW(GVL_ROW_DELETED)		
						DW_3.SETFOCUS()
						ROW = DW_3.GETROW()
						DW_3.SCROLLTOROW(ROW)
						DW_3.SETCOLUMN(1)
					END IF
			
		end if
			
	CASE 'UPDATE'
		
		IF RB_MESSAGE_LIST.checked = TRUE THEN 
			
				IF DW_1.UPDATE() < 0  OR DW_2.UPDATE() < 0 THEN
					ROLLBACK;
				ELSE
					COMMIT;
					F_MSG_MDI_HELP( F_MSG_ST(170) )	 //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
				END IF
			ELSE
				
				IF DW_3.UPDATE() < 0  THEN
					ROLLBACK;
				ELSE
					COMMIT;
					F_MSG_MDI_HELP( F_MSG_ST(170) )	 //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
				END IF
				
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

type dw_5 from w_main_root`dw_5 within w_agent_message_master
integer y = 476
integer taborder = 50
end type

type dw_4 from w_main_root`dw_4 within w_agent_message_master
integer y = 476
integer taborder = 60
end type

type dw_3 from w_main_root`dw_3 within w_agent_message_master
integer y = 476
integer width = 4517
integer height = 1264
integer taborder = 70
boolean titlebar = true
string title = "Agent Message History List"
string dataobject = "d_audit_message_history_lst"
end type

event dw_3::itemchanged;call super::itemchanged;datetime lvs_null
if dwo.name = 'confirm_yn' and data = 'Y' then 
   this.object.confirm_date[row] = f_sysdate()
   this.object.confirm_by[row] =Gvs_user_id
else
   setnull(lvs_null)	
   this.object.confirm_date[row] = lvs_null
   this.object.confirm_by[row] =''
end if 
end event

type dw_2 from w_main_root`dw_2 within w_agent_message_master
integer y = 1744
integer width = 4517
integer height = 1184
integer taborder = 80
boolean titlebar = true
string title = "Agent Message Filter"
string dataobject = "d_audit_message_filter_lst"
end type

event dw_2::rbuttondown;call super::rbuttondown;if dwo.name = 'user_id' then 
	Open(w_user_popup)
	
	if message.stringparm = '' then 
	else
		this.object.user_id[row] = message.stringparm
	end if
end if
end event

event dw_2::dragdrop;call super::dragdrop;DATAWINDOW ldw_Source 
LONG Lvl_row
String lvs_role_code , lvs_role_name
IF source.TypeOf() = DataWindow! THEN
   ldw_Source	= source
	
   IF ldw_Source  = THIS THEN 
   ELSE
		
		if row < 1 then 
			
			Lvl_row = this.insertrow(row)
			this.scrolltorow( lvl_row)
			f_set_security_row( this , lvl_row , 'ALL')
			this.object.user_id[Lvl_row] = Gvs_user_id
			this.object.msg_id[Lvl_row] = ldw_Source.object.msg_id[ldw_Source.getrow()]						
			
			if gvs_language = 'C'  then 
				this.object.detail[Lvl_row] = ldw_Source.object.detail_loc[ldw_Source.getrow()]										
			elseif gvs_language = 'K'  then 
				this.object.detail[Lvl_row] = ldw_Source.object.detail_kor[ldw_Source.getrow()]										
			elseif gvs_language = 'E'  then 
				this.object.detail[Lvl_row] = ldw_Source.object.detail_eng[ldw_Source.getrow()]										
			end if
			
			this.object.visible_yn[Lvl_row] = 'Y'
		else

			Lvl_row = this.insertrow(row)
			this.scrolltorow( lvl_row)
			f_set_security_row( this , lvl_row , 'ALL')
			this.object.user_id[Lvl_row] = Gvs_user_id
			
			this.object.msg_id[Lvl_row] = ldw_Source.object.msg_id[ldw_Source.getrow()]						
			
			if gvs_language = 'C'  then 
				this.object.detail[Lvl_row] = ldw_Source.object.detail_loc[ldw_Source.getrow()]										
			elseif gvs_language = 'K'  then 
				this.object.detail[Lvl_row] = ldw_Source.object.detail_kor[ldw_Source.getrow()]										
			elseif gvs_language = 'E'  then 
				this.object.detail[Lvl_row] = ldw_Source.object.detail_eng[ldw_Source.getrow()]										
			end if
			
			this.object.visible_yn[Lvl_row] = 'Y'			
		end if

	END IF
		  
END IF

THIS.DRAG(END!)
end event

type dw_1 from w_main_root`dw_1 within w_agent_message_master
integer y = 476
integer width = 4517
integer height = 1264
integer taborder = 90
boolean titlebar = true
string title = "Agent Message List"
string dataobject = "d_audit_message_code_lst"
end type

event dw_1::clicked;call super::clicked;IF UPPER(DWO.TYPE) = 'COLUMN' THEN
	DRAG(BEGIN!)
END IF
end event

type uo_tabpages from w_main_root`uo_tabpages within w_agent_message_master
end type

type sle_english from so_singlelineedit within w_agent_message_master
integer x = 1307
integer y = 160
integer taborder = 20
boolean bringtotop = true
end type

type sle_korea from so_singlelineedit within w_agent_message_master
integer x = 1810
integer y = 160
integer taborder = 30
boolean bringtotop = true
end type

type sle_local from so_singlelineedit within w_agent_message_master
integer x = 2313
integer y = 160
integer taborder = 40
boolean bringtotop = true
end type

type sle_msg_id from so_singlelineedit within w_agent_message_master
integer x = 805
integer y = 160
integer taborder = 10
boolean bringtotop = true
end type

type st_1 from so_statictext within w_agent_message_master
integer x = 809
integer y = 96
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "MSG ID"
end type

type st_2 from so_statictext within w_agent_message_master
integer x = 1307
integer y = 96
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "ENGLISH"
end type

type st_3 from so_statictext within w_agent_message_master
integer x = 1810
integer y = 96
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "KOREA"
end type

type st_4 from so_statictext within w_agent_message_master
integer x = 2313
integer y = 96
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "LOCAL"
end type

type uo_user from uo_user_id_name within w_agent_message_master
integer x = 2816
integer y = 156
integer taborder = 90
boolean bringtotop = true
end type

type st_5 from so_statictext within w_agent_message_master
integer x = 2821
integer y = 96
integer width = 603
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "User ID / Name"
end type

type rb_message_list from so_radiobutton within w_agent_message_master
integer x = 110
integer y = 76
boolean bringtotop = true
integer weight = 700
string text = "Message List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
selected_data_window = dw_1
end event

type rb_1 from so_radiobutton within w_agent_message_master
integer x = 110
integer y = 180
integer width = 512
boolean bringtotop = true
integer weight = 700
string text = "Message History"
end type

event clicked;call super::clicked;dw_3.bringtotop = true
selected_data_window = dw_3
end event

type st_6 from so_statictext within w_agent_message_master
integer x = 3429
integer y = 84
integer width = 818
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Audit Date"
end type

type uo_dateset from uo_ymd_calendar within w_agent_message_master
integer x = 3429
integer y = 156
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_agent_message_master
integer x = 3845
integer y = 152
integer taborder = 60
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type cb_1 from so_commandbutton within w_agent_message_master
integer x = 32
integer y = 340
integer width = 690
integer height = 100
integer taborder = 30
boolean bringtotop = true
string text = "Delete Message Filter"
end type

event clicked;call super::clicked;if dw_2.getrow() < 1 then return

dw_2.deleterow(dw_2.getrow())

MSG = F_MSGBOX1( 9014 , '1')
IF MSG = 1 THEN 
	
	IF DW_2.UPDATE() < 0 THEN 
		ROLLBACK ;
	ELSE
		COMMIT ;
		 F_MSG_MDI_HELP ( F_MSG_ST(170)	 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
		 F_RETRIEVE()		 
	END IF
ELSE
	
	F_RETRIEVE()
	
END IF
	
end event

type gb_1 from so_groupbox within w_agent_message_master
integer x = 750
integer width = 3534
integer height = 280
integer taborder = 100
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_agent_message_master
integer x = 14
integer y = 4
integer width = 731
integer height = 280
integer taborder = 110
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_3 from so_groupbox within w_agent_message_master
integer x = 9
integer y = 284
integer width = 731
integer height = 176
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Message Filter"
end type

