HA$PBExportHeader$w_dual_language.srw
$PBExportComments$Dual Language Information Manage
forward
global type w_dual_language from w_main_root
end type
type sle_english from so_singlelineedit within w_dual_language
end type
type sle_korea from so_singlelineedit within w_dual_language
end type
type sle_local from so_singlelineedit within w_dual_language
end type
type st_2 from so_statictext within w_dual_language
end type
type st_3 from so_statictext within w_dual_language
end type
type st_4 from so_statictext within w_dual_language
end type
type ddlb_chk from so_dropdownlistbox within w_dual_language
end type
type st_1 from so_statictext within w_dual_language
end type
type cb_1 from so_commandbutton within w_dual_language
end type
type sle_before from so_singlelineedit within w_dual_language
end type
type sle_after from so_singlelineedit within w_dual_language
end type
type st_5 from so_statictext within w_dual_language
end type
type st_6 from so_statictext within w_dual_language
end type
type cb_2 from so_commandbutton within w_dual_language
end type
type rb_english from so_radiobutton within w_dual_language
end type
type rb_korea from so_radiobutton within w_dual_language
end type
type rb_local from so_radiobutton within w_dual_language
end type
type cb_wordcap from so_commandbutton within w_dual_language
end type
type ddlb_org_id from uo_orz_id within w_dual_language
end type
type st_7 from so_statictext within w_dual_language
end type
type cb_3 from so_commandbutton within w_dual_language
end type
type ddlb_from_org from uo_orz_id within w_dual_language
end type
type ddlb_to_org from uo_orz_id within w_dual_language
end type
type st_8 from so_statictext within w_dual_language
end type
type st_9 from so_statictext within w_dual_language
end type
type cbx_sync_with_update from so_checkbox within w_dual_language
end type
type gb_1 from so_groupbox within w_dual_language
end type
type gb_2 from so_groupbox within w_dual_language
end type
type gb_3 from so_groupbox within w_dual_language
end type
type gb_4 from so_groupbox within w_dual_language
end type
end forward

global type w_dual_language from w_main_root
string title = "Dual Language"
sle_english sle_english
sle_korea sle_korea
sle_local sle_local
st_2 st_2
st_3 st_3
st_4 st_4
ddlb_chk ddlb_chk
st_1 st_1
cb_1 cb_1
sle_before sle_before
sle_after sle_after
st_5 st_5
st_6 st_6
cb_2 cb_2
rb_english rb_english
rb_korea rb_korea
rb_local rb_local
cb_wordcap cb_wordcap
ddlb_org_id ddlb_org_id
st_7 st_7
cb_3 cb_3
ddlb_from_org ddlb_from_org
ddlb_to_org ddlb_to_org
st_8 st_8
st_9 st_9
cbx_sync_with_update cbx_sync_with_update
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
end type
global w_dual_language w_dual_language

type variables
datawindow ivd_data_window
end variables

on w_dual_language.create
int iCurrent
call super::create
this.sle_english=create sle_english
this.sle_korea=create sle_korea
this.sle_local=create sle_local
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.ddlb_chk=create ddlb_chk
this.st_1=create st_1
this.cb_1=create cb_1
this.sle_before=create sle_before
this.sle_after=create sle_after
this.st_5=create st_5
this.st_6=create st_6
this.cb_2=create cb_2
this.rb_english=create rb_english
this.rb_korea=create rb_korea
this.rb_local=create rb_local
this.cb_wordcap=create cb_wordcap
this.ddlb_org_id=create ddlb_org_id
this.st_7=create st_7
this.cb_3=create cb_3
this.ddlb_from_org=create ddlb_from_org
this.ddlb_to_org=create ddlb_to_org
this.st_8=create st_8
this.st_9=create st_9
this.cbx_sync_with_update=create cbx_sync_with_update
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_english
this.Control[iCurrent+2]=this.sle_korea
this.Control[iCurrent+3]=this.sle_local
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.ddlb_chk
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.sle_before
this.Control[iCurrent+11]=this.sle_after
this.Control[iCurrent+12]=this.st_5
this.Control[iCurrent+13]=this.st_6
this.Control[iCurrent+14]=this.cb_2
this.Control[iCurrent+15]=this.rb_english
this.Control[iCurrent+16]=this.rb_korea
this.Control[iCurrent+17]=this.rb_local
this.Control[iCurrent+18]=this.cb_wordcap
this.Control[iCurrent+19]=this.ddlb_org_id
this.Control[iCurrent+20]=this.st_7
this.Control[iCurrent+21]=this.cb_3
this.Control[iCurrent+22]=this.ddlb_from_org
this.Control[iCurrent+23]=this.ddlb_to_org
this.Control[iCurrent+24]=this.st_8
this.Control[iCurrent+25]=this.st_9
this.Control[iCurrent+26]=this.cbx_sync_with_update
this.Control[iCurrent+27]=this.gb_1
this.Control[iCurrent+28]=this.gb_2
this.Control[iCurrent+29]=this.gb_3
this.Control[iCurrent+30]=this.gb_4
end on

on w_dual_language.destroy
call super::destroy
destroy(this.sle_english)
destroy(this.sle_korea)
destroy(this.sle_local)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.ddlb_chk)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.sle_before)
destroy(this.sle_after)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.cb_2)
destroy(this.rb_english)
destroy(this.rb_korea)
destroy(this.rb_local)
destroy(this.cb_wordcap)
destroy(this.ddlb_org_id)
destroy(this.st_7)
destroy(this.cb_3)
destroy(this.ddlb_from_org)
destroy(this.ddlb_to_org)
destroy(this.st_8)
destroy(this.st_9)
destroy(this.cbx_sync_with_update)
destroy(this.gb_1)
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
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		
			String LS_CHK
			LS_CHK = DDLB_CHK.TEXT
			
			if ISNULL(LS_CHK) or LS_CHK = '' then
				LS_CHK = '%'
			end if
			
			DW_1.RETRIEVE(SLE_ENGLISH.TEXT+'%', SLE_LOCAL.TEXT+'%', SLE_KOREA.TEXT+'%', LS_CHK, DDLB_ORG_ID.GETCODE()+'%')
               DW_1.SETFOCUS()
			
	CASE 'INSERT'
			ROW = DW_1.INSERTROW(DW_1.GETROW())
			DW_1.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_1 , ROW , 'ALL')
	CASE 'APPEND'
			ROW = DW_1.INSERTROW(0)
			DW_1.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_1 , ROW , 'ALL')	
	CASE 'DELETE'
			if DW_1.AcceptText() = -1 then
				return
			end if
			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
				Gvl_row_deleted = DW_1.GetRow()			
				DW_1.DELETEROW(Gvl_row_deleted)		
				DW_1.SetFocus()
				ROW = DW_1.GetRow()
				DW_1.ScrollToRow(row)
				DW_1.SetColumn(1)
			END IF
						
	CASE 'UPDATE'
		
          	IF DW_1.UPDATE() < 0 THEN
				ROLLBACK;
			ELSE
				 COMMIT;
 				 f_msg_mdi_help( f_msg_st( 170) ) //$$HEX7$$00c8a5c718b4c8c5b5c2c8b2e4b2$$ENDHEX$$

			END IF
			
	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_dual_language
integer y = 588
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_dual_language
integer y = 588
integer taborder = 50
end type

type dw_3 from w_main_root`dw_3 within w_dual_language
integer y = 588
integer taborder = 60
end type

type dw_2 from w_main_root`dw_2 within w_dual_language
integer y = 588
integer taborder = 70
end type

type dw_1 from w_main_root`dw_1 within w_dual_language
integer y = 588
integer width = 4507
integer height = 1892
integer taborder = 0
boolean titlebar = true
string title = "Dual Language List"
string dataobject = "d_dual_language_lst"
end type

event dw_1::itemchanged;call super::itemchanged;if row < 1 then return
this.object.conver_chk[row] = 'Y'
end event

type uo_tabpages from w_main_root`uo_tabpages within w_dual_language
end type

type sle_english from so_singlelineedit within w_dual_language
integer x = 347
integer y = 164
integer width = 379
integer taborder = 20
boolean bringtotop = true
textcase textcase = upper!
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

LVS_COLUMN = "ENGLISH_TEXT"

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

SELECTED_DATA_WINDOW.SETFILTER('')
SELECTED_DATA_WINDOW.FILTER()

IF THIS.TEXT = '' THEN 
	SELECTED_DATA_WINDOW.SETFILTER('')
	SELECTED_DATA_WINDOW.FILTER()
	RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
SELECTED_DATA_WINDOW.FILTER()
F_MSG_MDI_HELP( STRING( SELECTED_DATA_WINDOW.ROWCOUNT() ) + " Found")
end event

type sle_korea from so_singlelineedit within w_dual_language
integer x = 731
integer y = 164
integer width = 425
integer taborder = 30
boolean bringtotop = true
textcase textcase = upper!
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

LVS_COLUMN = "KOREA_TEXT"

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

SELECTED_DATA_WINDOW.SETFILTER('')
SELECTED_DATA_WINDOW.FILTER()

IF THIS.TEXT = '' THEN 
	SELECTED_DATA_WINDOW.SETFILTER('')
	SELECTED_DATA_WINDOW.FILTER()
	RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
SELECTED_DATA_WINDOW.FILTER()
F_MSG_MDI_HELP( STRING( SELECTED_DATA_WINDOW.ROWCOUNT() ) + " Found")
end event

type sle_local from so_singlelineedit within w_dual_language
integer x = 1161
integer y = 164
integer width = 480
integer taborder = 40
boolean bringtotop = true
textcase textcase = upper!
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

LVS_COLUMN = "LOCAL_TEXT"

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

SELECTED_DATA_WINDOW.SETFILTER('')
SELECTED_DATA_WINDOW.FILTER()

IF THIS.TEXT = '' THEN 
	SELECTED_DATA_WINDOW.SETFILTER('')
	SELECTED_DATA_WINDOW.FILTER()
	RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
SELECTED_DATA_WINDOW.FILTER()
F_MSG_MDI_HELP( STRING( SELECTED_DATA_WINDOW.ROWCOUNT() ) + " Found")
end event

type st_2 from so_statictext within w_dual_language
integer x = 347
integer y = 80
integer width = 379
boolean bringtotop = true
integer weight = 700
string text = "ENGLISH"
end type

type st_3 from so_statictext within w_dual_language
integer x = 731
integer y = 80
integer width = 425
boolean bringtotop = true
integer weight = 700
string text = "KOREA"
end type

type st_4 from so_statictext within w_dual_language
integer x = 1161
integer y = 80
integer width = 480
boolean bringtotop = true
integer weight = 700
string text = "LOCAL"
end type

type ddlb_chk from so_dropdownlistbox within w_dual_language
integer x = 32
integer y = 164
integer width = 311
integer taborder = 10
boolean bringtotop = true
string item[] = {"","Y","N"}
end type

type st_1 from so_statictext within w_dual_language
integer x = 27
integer y = 76
integer width = 315
boolean bringtotop = true
integer weight = 700
string text = "CONVERT"
end type

type cb_1 from so_commandbutton within w_dual_language
integer x = 2450
integer y = 104
integer width = 581
integer height = 112
integer taborder = 50
boolean bringtotop = true
string text = "Sync Language Pack"
end type

event clicked;call super::clicked;Int lvi_Return

msg = f_msgbox1(1161 , this.text)
IF msg = 1 THEN 
	
	dw_1.retrieve( '%' ,'%','%' ,'%' , DDLB_ORG_ID.GETCODE()+'%' )
	if dw_1.getrow() < 1 then 
		Return
	end if
	lvi_Return = dw_1.SaveAs(Gvs_Default_directory+'\isys_dual_language_'+String(gvi_organization_id)+'.txt' , text! , FALSE , EncodingUTF16LE!)

	IF lvi_Return < 0 THEN 
		Messagebox("Notiry" , "Language Sync Failed! Directory = "+Gvs_Default_directory)	
	END IF
	
	f_msgbox(170)
	
END IF
end event

type sle_before from so_singlelineedit within w_dual_language
integer x = 357
integer y = 360
integer width = 379
integer taborder = 60
boolean bringtotop = true
end type

type sle_after from so_singlelineedit within w_dual_language
integer x = 357
integer y = 452
integer width = 379
integer taborder = 70
boolean bringtotop = true
end type

type st_5 from so_statictext within w_dual_language
integer x = 41
integer y = 360
integer width = 302
boolean bringtotop = true
integer weight = 700
string text = "Before"
end type

type st_6 from so_statictext within w_dual_language
integer x = 41
integer y = 452
integer width = 302
boolean bringtotop = true
integer weight = 700
string text = "After"
end type

type cb_2 from so_commandbutton within w_dual_language
integer x = 1303
integer y = 336
integer width = 434
integer height = 100
integer taborder = 50
boolean bringtotop = true
string text = "Change"
end type

event clicked;call super::clicked;Long i , lvl_count
String Lvs_before , Lvs_after , lvs_rowid , lvs_english_text


MSG = F_MSGBOX1( 1161 , THIS.TEXT)
IF MSG = 1 THEN 
ELSE
	RETURN
END IF

Lvs_before = sle_before.text
Lvs_after = sle_after.text

if Lvs_before = '' or isnull(Lvs_before) then
	Messagebox("Notify" , "Before Word Invalid" )
	Return
end if

if rb_korea.checked = true then 

	select count(*) into :lvl_count 
	  from isys_dual_language
	 where korea_text like '%'||:lvs_before||'%'
		 and organization_id = :gvi_organization_id ;
	 
	 if f_sql_check() < 0 then 
		Return
	 end if	
	
	 if lvl_count = 0 then 
		Messagebox("Notify" , "No Data Found")
		Return
	end if
	
Open(w_progress_popup)
w_progress_popup.f_set_range( 0 , 	lvl_count )
w_progress_popup.f_setstep(1)

       Declare cl1 cursor for 
	   select rowid  , english_text from isys_dual_language
	 where korea_text like '%'||:lvs_before||'%'
		 and organization_id = :gvi_organization_id ;

	Open cl1 ;
	
	Do
		
		Fetch cl1 into :lvs_rowid , :lvs_english_text ;
		if f_sql_check() < 0 then 
		   Close(w_progress_popup)				
		   Close cl1;
		   Return
		end if
		
		if sqlca.sqlcode = 100 then 
		   CLose cl1 ;
		   Exit
		end if
		i++
	
		Update isys_dual_language set  korea_text = replace( korea_text , :lvs_before , :lvs_after ) 
		  where rowid = :lvs_rowid ;
		  
		 if sqlca.sqlcode < 0 then 
			msg = Messagebox("Notify" , lvs_english_text+'  '+sqlca.sqlerrtext+'  '+ 'Continue ?'  , stopsign! , yesno! )
			if msg = 1 then 
				Continue
			else
			      Close(w_progress_popup)					
				Close cl1 ;
				Rollback;
				return
			end if
		 end if		
		 w_progress_popup.f_stepit()		 
	        f_msg_mdi_help( string(i)+" Rows Processed")
	Loop until 1 = 2 
	
elseif rb_local.checked = true then 


	select count(*) into :lvl_count 
	  from isys_dual_language
	 where local_text like '%'||:lvs_before||'%'
		 and organization_id = :gvi_organization_id ;
	 
	 if f_sql_check() < 0 then 
		Return
	 end if	
	 
	 if lvl_count = 0 then 
		Messagebox("Notify" , "No Data Found")
		Return
	end if
	
Open(w_progress_popup)
w_progress_popup.f_set_range( 0 , 	lvl_count )
w_progress_popup.f_setstep(1)
	
       Declare cl2 cursor for 
	   select rowid  , english_text from isys_dual_language
	 where local_text like '%'||:lvs_before||'%'
		 and organization_id = :gvi_organization_id ;

	Open cl2 ;
	
	Do
		
		Fetch cl2 into :lvs_rowid , :lvs_english_text;
		if f_sql_check() < 0 then 
		   Close(w_progress_popup)			
		   Close cl2;
		   Return
		end if
		
		if sqlca.sqlcode = 100 then 

		   CLose cl2 ;
		   Exit
		end if
		i++
	
		Update isys_dual_language set  local_text = replace( local_text , :lvs_before , :lvs_after ) 
		  where rowid = :lvs_rowid ;
		  
		 if sqlca.sqlcode < 0 then 
			msg = Messagebox("Notify" , lvs_english_text+'  '+sqlca.sqlerrtext+'  '+ 'Continue ?'  , stopsign! , yesno! )
			if msg = 1 then 
				Continue
			else
				Close(w_progress_popup)				
				Close cl2 ;
				Rollback;
				return
			end if
		 end if		
		 w_progress_popup.f_stepit()
	        f_msg_mdi_help( string(i)+" Rows Processed")
	Loop until 1 = 2 
	
end if
Close(w_progress_popup)

if i > 0 then 
	Commit ;
	F_MSGBOX(170)
else
	
	Rollback ;
end if
end event

type rb_english from so_radiobutton within w_dual_language
integer x = 750
integer y = 328
boolean bringtotop = true
integer weight = 700
string text = "English"
end type

event clicked;call super::clicked;cb_WordCap.enabled = true
end event

type rb_korea from so_radiobutton within w_dual_language
integer x = 750
integer y = 404
boolean bringtotop = true
integer weight = 700
string text = "Korea"
end type

type rb_local from so_radiobutton within w_dual_language
integer x = 750
integer y = 484
boolean bringtotop = true
integer weight = 700
string text = "Local"
end type

type cb_wordcap from so_commandbutton within w_dual_language
integer x = 1303
integer y = 440
integer width = 434
integer height = 100
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
string text = "WordCap"
end type

event clicked;call super::clicked;Long i
//if dwo.name = 'english_origin_text' then 
//
	do
		i++
		
		dw_1.object.english_origin_text[i] = WordCap(dw_1.object.english_origin_text[i])
		
	loop until i = dw_1.rowcount()
	
//end if
end event

type ddlb_org_id from uo_orz_id within w_dual_language
integer x = 1646
integer y = 164
integer width = 722
integer taborder = 20
boolean bringtotop = true
end type

type st_7 from so_statictext within w_dual_language
integer x = 1646
integer y = 80
integer width = 722
boolean bringtotop = true
integer weight = 700
string text = "Org ID"
end type

type cb_3 from so_commandbutton within w_dual_language
integer x = 1792
integer y = 440
integer width = 581
integer height = 100
integer taborder = 60
boolean bringtotop = true
string text = "Sync Org Language"
end type

event clicked;call super::clicked;INT LVI_FROM_ORG , LVI_TO_ORG

LVI_FROM_ORG = INTEGER( DDLB_FROM_ORG.GETCODE( ) )
LVI_TO_ORG = INTEGER( DDLB_TO_ORG.GETCODE( ) )

  INSERT INTO "ISYS_DUAL_LANGUAGE"  
         ( "ENGLISH_TEXT",   
           "ORGANIZATION_ID",   
           "LOCAL_TEXT",   
           "KOREA_TEXT",   
           "CONVER_CHK",   
           "ENTER_DATE",   
           "ENTER_BY",   
           "LAST_MODIFY_DATE",   
           "LAST_MODIFY_BY",   
           "ENGLISH_ORIGIN_TEXT" )  
     SELECT "ISYS_DUAL_LANGUAGE"."ENGLISH_TEXT",   
            :LVI_TO_ORG ,
            "ISYS_DUAL_LANGUAGE"."LOCAL_TEXT",   
            "ISYS_DUAL_LANGUAGE"."KOREA_TEXT",   
            "ISYS_DUAL_LANGUAGE"."CONVER_CHK",   
            "ISYS_DUAL_LANGUAGE"."ENTER_DATE",   
            "ISYS_DUAL_LANGUAGE"."ENTER_BY",   
            "ISYS_DUAL_LANGUAGE"."LAST_MODIFY_DATE",   
            "ISYS_DUAL_LANGUAGE"."LAST_MODIFY_BY",   
            "ISYS_DUAL_LANGUAGE"."ENGLISH_ORIGIN_TEXT"  
       FROM "ISYS_DUAL_LANGUAGE"  
    WHERE ORGANIZATION_ID  = 		 :LVI_FROM_ORG
	  AND ENGLISH_TEXT NOT IN ( SELECT ENGLISH_TEXT FROM ISYS_DUAL_LANGUAGE WHERE ORGANIZATION_ID  =  :LVI_TO_ORG ) ;
	  
IF F_SQL_CHECK() < 0 THEN 
	RETURN
ELSE
	MSG = F_MSGBOX( 1170 )
	IF MSG = 1 THEN 
		COMMIT ;
	ELSE
		ROLLBACK;
	END IF
END IF 

IF cbx_sync_with_update.checked = true then 
		 
		//==========================================	
		//
		//==========================================	
		UPDATE ISYS_DUAL_LANGUAGE A 
				SET (A.KOREA_TEXT , A.LOCAL_TEXT , A.ENGLISH_ORIGIN_TEXT )  =
					( SELECT B.KOREA_TEXT , B.LOCAL_TEXT , B.ENGLISH_ORIGIN_TEXT 
						  FROM ISYS_DUAL_LANGUAGE B
					WHERE A.ENGLISH_TEXT        = B.ENGLISH_TEXT
						AND A.ORGANIZATION_ID = :LVI_TO_ORG 
						AND B.ORGANIZATION_ID = :LVI_FROM_ORG 	) 
		WHERE EXISTS
				   ( SELECT '*'
						  FROM ISYS_DUAL_LANGUAGE B
					WHERE A.ENGLISH_TEXT        = B.ENGLISH_TEXT
					     AND A.ORGANIZATION_ID = :LVI_TO_ORG
						AND B.ORGANIZATION_ID = :LVI_FROM_ORG 	
					) ;
		
		IF F_SQL_CHECK() < 0 THEN 
			RETURN
		ELSE
			MSG = F_MSGBOX( 1170 )
			IF MSG = 1 THEN 
				COMMIT ;
			ELSE
				ROLLBACK;
			END IF
		END IF 
end if 
end event

type ddlb_from_org from uo_orz_id within w_dual_language
integer x = 2386
integer y = 412
integer width = 722
integer taborder = 30
boolean bringtotop = true
end type

type ddlb_to_org from uo_orz_id within w_dual_language
integer x = 3118
integer y = 412
integer width = 722
integer taborder = 40
boolean bringtotop = true
end type

type st_8 from so_statictext within w_dual_language
integer x = 2391
integer y = 332
integer width = 722
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "From"
end type

type st_9 from so_statictext within w_dual_language
integer x = 3122
integer y = 336
integer width = 722
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "To"
end type

type cbx_sync_with_update from so_checkbox within w_dual_language
integer x = 1801
integer y = 352
integer width = 562
integer height = 80
boolean bringtotop = true
integer weight = 700
string text = "Sync With Update"
end type

type gb_1 from so_groupbox within w_dual_language
integer y = 288
integer width = 1760
integer height = 288
integer weight = 700
long textcolor = 16711680
string text = "Word Change"
end type

type gb_2 from so_groupbox within w_dual_language
integer y = 4
integer width = 2409
integer height = 284
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_dual_language
integer x = 1765
integer y = 288
integer width = 2107
integer height = 288
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_4 from so_groupbox within w_dual_language
integer x = 2423
integer y = 4
integer width = 640
integer height = 288
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

