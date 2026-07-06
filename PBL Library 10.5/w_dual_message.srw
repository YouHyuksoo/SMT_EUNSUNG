HA$PBExportHeader$w_dual_message.srw
$PBExportComments$Dual Message  Information Manage
forward
global type w_dual_message from w_main_root
end type
type sle_english from so_singlelineedit within w_dual_message
end type
type sle_korea from so_singlelineedit within w_dual_message
end type
type sle_local from so_singlelineedit within w_dual_message
end type
type sle_msg_id from so_singlelineedit within w_dual_message
end type
type st_1 from so_statictext within w_dual_message
end type
type st_2 from so_statictext within w_dual_message
end type
type st_3 from so_statictext within w_dual_message
end type
type st_4 from so_statictext within w_dual_message
end type
type cb_1 from so_commandbutton within w_dual_message
end type
type rb_msg_normal from so_radiobutton within w_dual_message
end type
type rb_2 from so_radiobutton within w_dual_message
end type
type gb_1 from so_groupbox within w_dual_message
end type
type gb_4 from so_groupbox within w_dual_message
end type
type gb_2 from so_groupbox within w_dual_message
end type
end forward

global type w_dual_message from w_main_root
string title = "Dual Message"
toolbaralignment toolbaralignment = floating!
sle_english sle_english
sle_korea sle_korea
sle_local sle_local
sle_msg_id sle_msg_id
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
cb_1 cb_1
rb_msg_normal rb_msg_normal
rb_2 rb_2
gb_1 gb_1
gb_4 gb_4
gb_2 gb_2
end type
global w_dual_message w_dual_message

on w_dual_message.create
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
this.cb_1=create cb_1
this.rb_msg_normal=create rb_msg_normal
this.rb_2=create rb_2
this.gb_1=create gb_1
this.gb_4=create gb_4
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_english
this.Control[iCurrent+2]=this.sle_korea
this.Control[iCurrent+3]=this.sle_local
this.Control[iCurrent+4]=this.sle_msg_id
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.rb_msg_normal
this.Control[iCurrent+11]=this.rb_2
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.gb_4
this.Control[iCurrent+14]=this.gb_2
end on

on w_dual_message.destroy
call super::destroy
destroy(this.sle_english)
destroy(this.sle_korea)
destroy(this.sle_local)
destroy(this.sle_msg_id)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.cb_1)
destroy(this.rb_msg_normal)
destroy(this.rb_2)
destroy(this.gb_1)
destroy(this.gb_4)
destroy(this.gb_2)
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
Ivs_resize_type    = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
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
CHOOSE CASE Gvs_ue_data_control
	CASE 'RETRIEVE'
		
			if rb_msg_normal.checked  = true then
				DW_1.RETRIEVE(SLE_MSG_ID.TEXT+'%', SLE_ENGLISH.TEXT+'%', SLE_LOCAL.TEXT+'%', SLE_KOREA.TEXT+'%', Gvi_organization_id)
				DW_1.SETFOCUS()
			else
				
				DW_2.RETRIEVE( SLE_ENGLISH.TEXT+'%', SLE_LOCAL.TEXT+'%', SLE_KOREA.TEXT+'%', Gvi_organization_id)
				DW_2.SETFOCUS()				
				
			end if 
			
	CASE 'INSERT'
		
			ROW = DW_1.INSERTROW(DW_1.GETROW())
			F_SET_SECURITY_ROW(DW_1 , ROW , 'NONORG')
			F_MSG_MDI_HELP( F_MSG_ST(152) )		
			
	CASE 'APPEND'

			ROW = DW_1.INSERTROW(0)
			F_SET_SECURITY_ROW(DW_1 , ROW , 'NONORG')	
			F_MSG_MDI_HELP( F_MSG_ST(152) )			
	CASE 'DELETE'
		
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
			
	CASE 'UPDATE'
		
			IF DW_1.UPDATE() < 0 or DW_2.UPDATE() < 0 THEN
				ROLLBACK;
			ELSE
				COMMIT;
				F_MSG_MDI_HELP( F_MSG_ST(170) )	 //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
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

type dw_5 from w_main_root`dw_5 within w_dual_message
integer y = 296
integer taborder = 50
end type

type dw_4 from w_main_root`dw_4 within w_dual_message
integer y = 296
integer taborder = 60
end type

type dw_3 from w_main_root`dw_3 within w_dual_message
integer y = 296
integer taborder = 70
end type

type dw_2 from w_main_root`dw_2 within w_dual_message
integer y = 296
integer width = 4517
integer height = 2212
integer taborder = 80
boolean titlebar = true
string dataobject = "d_dual_message_direct_lst"
boolean controlmenu = true
end type

type dw_1 from w_main_root`dw_1 within w_dual_message
integer y = 296
integer width = 4517
integer height = 2212
integer taborder = 90
boolean titlebar = true
string title = "Dual Message List"
string dataobject = "d_dual_message"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_dual_message
end type

type sle_english from so_singlelineedit within w_dual_message
integer x = 1413
integer y = 160
integer taborder = 20
boolean bringtotop = true
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

LVS_COLUMN = "DETAIL_ENG"

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

DW_1.SETFILTER('')
DW_1.FILTER()

IF THIS.TEXT = '' THEN 
	DW_1.SETFILTER('')
	DW_1.FILTER()
	RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

DW_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
DW_1.FILTER()
F_MSG_MDI_HELP( STRING( DW_1.ROWCOUNT() ) + " Found")
end event

type sle_korea from so_singlelineedit within w_dual_message
integer x = 1915
integer y = 160
integer taborder = 30
boolean bringtotop = true
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

LVS_COLUMN = "DETAIL_KOR"

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

DW_1.SETFILTER('')
DW_1.FILTER()

IF THIS.TEXT = '' THEN 
	DW_1.SETFILTER('')
	DW_1.FILTER()
	RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

DW_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
DW_1.FILTER()
F_MSG_MDI_HELP( STRING( DW_1.ROWCOUNT() ) + " Found")
end event

type sle_local from so_singlelineedit within w_dual_message
integer x = 2418
integer y = 160
integer taborder = 40
boolean bringtotop = true
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

LVS_COLUMN = "DETAIL_LOC"

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

DW_1.SETFILTER('')
DW_1.FILTER()

IF THIS.TEXT = '' THEN 
	DW_1.SETFILTER('')
	DW_1.FILTER()
	RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

DW_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
DW_1.FILTER()
F_MSG_MDI_HELP( STRING( DW_1.ROWCOUNT() ) + " Found")
end event

type sle_msg_id from so_singlelineedit within w_dual_message
integer x = 910
integer y = 160
integer taborder = 10
boolean bringtotop = true
end type

type st_1 from so_statictext within w_dual_message
integer x = 914
integer y = 72
boolean bringtotop = true
integer weight = 700
string text = "MSG ID"
end type

type st_2 from so_statictext within w_dual_message
integer x = 1413
integer y = 72
boolean bringtotop = true
integer weight = 700
string text = "ENGLISH"
end type

type st_3 from so_statictext within w_dual_message
integer x = 1915
integer y = 72
boolean bringtotop = true
integer weight = 700
string text = "KOREA"
end type

type st_4 from so_statictext within w_dual_message
integer x = 2418
integer y = 72
boolean bringtotop = true
integer weight = 700
string text = "LOCAL"
end type

type cb_1 from so_commandbutton within w_dual_message
integer x = 2981
integer y = 76
integer width = 581
integer height = 164
integer taborder = 40
boolean bringtotop = true
string text = "Sync Message Pack"
end type

event clicked;call super::clicked;Int lvi_Return

msg = f_msgbox1(1161 , this.text)
IF msg = 1 THEN 
	
     DW_1.RETRIEVE(SLE_MSG_ID.TEXT+'%', SLE_ENGLISH.TEXT+'%', SLE_LOCAL.TEXT+'%', SLE_KOREA.TEXT+'%', Gvi_organization_id)
	if dw_1.getrow() < 1 then 
		Return
	end if
	lvi_Return = dw_1.SaveAs(Gvs_Default_directory+'\isys_dual_message_'+String(gvi_organization_id)+'.txt' , text! , FALSE , EncodingUTF16LE!)

	IF lvi_Return < 0 THEN 
		Messagebox("Notiry" , "Message Sync Failed! Directory = "+Gvs_Default_directory)	
	END IF
	
	f_msgbox(170)
	
END IF
end event

type rb_msg_normal from so_radiobutton within w_dual_message
integer x = 128
integer y = 80
boolean bringtotop = true
string text = "Message Normal"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop  = true 
selected_data_window = dw_1	
end event

type rb_2 from so_radiobutton within w_dual_message
integer x = 128
integer y = 172
boolean bringtotop = true
string text = "Message Direct"
end type

event clicked;call super::clicked;dw_2.bringtotop  = true 
selected_data_window = dw_2
end event

type gb_1 from so_groupbox within w_dual_message
integer x = 855
integer width = 2089
integer height = 288
integer taborder = 100
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_4 from so_groupbox within w_dual_message
integer x = 9
integer width = 823
integer height = 288
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_dual_message
integer x = 2953
integer width = 640
integer height = 288
integer taborder = 110
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

