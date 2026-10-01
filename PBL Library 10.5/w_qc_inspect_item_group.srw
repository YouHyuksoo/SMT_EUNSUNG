HA$PBExportHeader$w_qc_inspect_item_group.srw
$PBExportComments$$$HEX7$$80acacc0f8adf9b8200000adacb9$$ENDHEX$$
forward
global type w_qc_inspect_item_group from w_main_root
end type
type st_1 from so_statictext within w_qc_inspect_item_group
end type
type sle_model_name from so_singlelineedit within w_qc_inspect_item_group
end type
type cb_save_format from so_commandbutton within w_qc_inspect_item_group
end type
type cb_1 from so_commandbutton within w_qc_inspect_item_group
end type
type st_2 from so_statictext within w_qc_inspect_item_group
end type
type sle_item_code from so_singlelineedit within w_qc_inspect_item_group
end type
type st_4 from so_statictext within w_qc_inspect_item_group
end type
type st_5 from so_statictext within w_qc_inspect_item_group
end type
type sle_fr_item_code from so_singlelineedit within w_qc_inspect_item_group
end type
type sle_to_item_code from so_singlelineedit within w_qc_inspect_item_group
end type
type cb_print from commandbutton within w_qc_inspect_item_group
end type
type gb_1 from so_groupbox within w_qc_inspect_item_group
end type
type gb_3 from so_groupbox within w_qc_inspect_item_group
end type
type gb_2 from so_groupbox within w_qc_inspect_item_group
end type
end forward

global type w_qc_inspect_item_group from w_main_root
string tag = "w_qc_insepct_item_group"
integer width = 5595
integer height = 2900
string title = "Time Check Inspection Item Mgt"
string icon = "Form!"
st_1 st_1
sle_model_name sle_model_name
cb_save_format cb_save_format
cb_1 cb_1
st_2 st_2
sle_item_code sle_item_code
st_4 st_4
st_5 st_5
sle_fr_item_code sle_fr_item_code
sle_to_item_code sle_to_item_code
cb_print cb_print
gb_1 gb_1
gb_3 gb_3
gb_2 gb_2
end type
global w_qc_inspect_item_group w_qc_inspect_item_group

type variables

end variables

on w_qc_inspect_item_group.create
int iCurrent
call super::create
this.st_1=create st_1
this.sle_model_name=create sle_model_name
this.cb_save_format=create cb_save_format
this.cb_1=create cb_1
this.st_2=create st_2
this.sle_item_code=create sle_item_code
this.st_4=create st_4
this.st_5=create st_5
this.sle_fr_item_code=create sle_fr_item_code
this.sle_to_item_code=create sle_to_item_code
this.cb_print=create cb_print
this.gb_1=create gb_1
this.gb_3=create gb_3
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.sle_model_name
this.Control[iCurrent+3]=this.cb_save_format
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.sle_item_code
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.st_5
this.Control[iCurrent+9]=this.sle_fr_item_code
this.Control[iCurrent+10]=this.sle_to_item_code
this.Control[iCurrent+11]=this.cb_print
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.gb_3
this.Control[iCurrent+14]=this.gb_2
end on

on w_qc_inspect_item_group.destroy
call super::destroy
destroy(this.st_1)
destroy(this.sle_model_name)
destroy(this.cb_save_format)
destroy(this.cb_1)
destroy(this.st_2)
destroy(this.sle_item_code)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.sle_fr_item_code)
destroy(this.sle_to_item_code)
destroy(this.cb_print)
destroy(this.gb_1)
destroy(this.gb_3)
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
Ivs_resize_type    = 'MASTER_DETAIL_1L2R'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

/*****************************************
* Multi Selected Data Delete Control Default 'Y'
******************************************/
ivs_dw_1_deleteselected_yn = 'N'
ivs_dw_1_retrice_cancel_popup_open = 'Y'
ivs_dw_2_retrice_cancel_popup_open = 'Y'
ivs_dw_3_retrice_cancel_popup_open = 'Y'
ivs_dw_4_retrice_cancel_popup_open = 'Y'
ivs_dw_5_retrice_cancel_popup_open = 'Y'
/****************************************
* Menu Property $$HEX6$$54ba74b2200078d5e4b4c1b9$$ENDHEX$$
*****************************************
* ADMIN     : ADMIN  ( $$HEX5$$04c8b4ccacc0a9c62000$$ENDHEX$$)
* $$HEX8$$00adacb9200020002000200020002000$$ENDHEX$$: MANAGE ( $$HEX8$$04c854ba74b2acc0a9c600aca5b22000$$ENDHEX$$)
* $$HEX7$$acc0a9c690c72000200020002000$$ENDHEX$$: GUEST  ( $$HEX11$$30ae08cd2000f1b45db8200070c88cd6200000aca5b2$$ENDHEX$$)
* $$HEX8$$70c88cd6200020002000200020002000$$ENDHEX$$: QUERY  ( $$HEX10$$15c8f4bc70c88cd6ccb9200000aca5b220002000$$ENDHEX$$)
* $$HEX5$$70b374c7c0d070c891c7$$ENDHEX$$: DATA_CONTROL  ( $$HEX12$$85c725b8200018c215c82000adc01cc8200024c115c82000$$ENDHEX$$)
* $$HEX7$$08b8ecd3b8d22000200020002000$$ENDHEX$$: REPORT ( $$HEX4$$08b8ecd3b8d22000$$ENDHEX$$, $$HEX5$$9ccd25b800adacb92000$$ENDHEX$$)
* RETRIEVE
* DATA_CONTROL
* DATA_CONTROL_MODIFY
* DATA_CONTROL_INSERT
* DATA_CONTROL_DELETE
* REPORT
****************************************/
F_MENU_CONTROL('DATA_CONTROL' , TRUE)             // All Data Control
/****************************************
* 
****************************************/

end event

event ue_data_control;call super::ue_data_control;
Long ROW, MROW
string lvs_item_code, lvs_model_name

CHOOSE CASE Gvs_Ue_DATA_control
		
	CASE 'RETRIEVE'

			DW_1.reset()
			DW_1.RETRIEVE(sle_model_name.text + '%', sle_item_code.text + '%', gvi_organization_id)
			DW_1.SETFOCUS()
			
	CASE 'INSERT'
      		    
			MROW = DW_1.GETROW()
			
			if mrow < 1 then 
				return 
			end if 
			
			lvs_item_code    = DW_1.GETITEMSTRING(MROW, 'item_code')
			lvs_model_name = DW_1.GETITEMSTRING(MROW, 'model_name')
			 
			 
			ROW = DW_2.INSERTROW(DW_2.GETROW())
			DW_2.SCROLLTOROW(ROW)
			dw_2.setitem(row,'inspect_group', lvs_item_code )
			dw_2.setitem(row,'inspect_group_desc', lvs_model_name )
			F_SET_SECURITY_ROW(DW_2 , ROW , 'ALL')
			
					
			F_MSG_MDI_HELP( F_MSG_ST(152))
			
	CASE 'APPEND'
		
		
		
			MROW = DW_1.GETROW()
			
			if mrow < 1 then 
				return 
			end if 
			
			lvs_item_code = DW_1.GETITEMSTRING(MROW, 'item_code')
			lvs_model_name = DW_1.GETITEMSTRING(MROW, 'model_name')			 
			 
			ROW = DW_2.INSERTROW(0)
			DW_2.SCROLLTOROW(ROW)
			dw_2.setitem(row,'inspect_group', lvs_item_code )
			dw_2.setitem(row,'inspect_group_desc', lvs_model_name )
			F_SET_SECURITY_ROW(DW_2 , ROW , 'ALL')
			
					
			F_MSG_MDI_HELP( F_MSG_ST(152))
		
		
			
	CASE 'DELETE'
		
		  	IF DW_1.GETROW() < 1 THEN RETURN 
			  
	
			MSG = F_MSGBOX(1003) 
			IF MSG = 1 THEN
				GVL_ROW_DELETED = DW_2.GETROW()			
				DW_2.DELETEROW(GVL_ROW_DELETED)		
				DW_2.SETFOCUS()
				ROW = DW_2.GETROW()
				DW_2.SCROLLTOROW(ROW)
				DW_2.SETCOLUMN(1)
			END IF
			  
	CASE 'UPDATE'
		
	      IF DW_2.UPDATE() < 0  THEN
				ROLLBACK;
			ELSE
				 DW_2.RESETUPDATE()
				 COMMIT;
	  			 F_MSG_MDI_HELP( F_MSG_ST(170))//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			END IF
		    
			// F_RETRIEVE()
	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* Window Property Setup
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
//f_retrieve()
end event

type dw_5 from w_main_root`dw_5 within w_qc_inspect_item_group
integer x = 23
integer y = 300
end type

type dw_4 from w_main_root`dw_4 within w_qc_inspect_item_group
integer x = 23
integer y = 300
end type

type dw_3 from w_main_root`dw_3 within w_qc_inspect_item_group
integer x = 23
integer y = 300
integer taborder = 60
boolean titlebar = true
end type

type dw_2 from w_main_root`dw_2 within w_qc_inspect_item_group
integer x = 2409
integer y = 296
integer width = 1710
integer height = 924
integer taborder = 40
boolean titlebar = true
string title = "Inspection item list"
string dataobject = "d_qc_inspect_item_group_lst"
boolean controlmenu = true
end type

type dw_1 from w_main_root`dw_1 within w_qc_inspect_item_group
integer x = 14
integer y = 296
integer width = 2395
integer height = 1384
integer taborder = 50
boolean titlebar = true
string title = "Model list"
string dataobject = "d_qc_inspect_item_grp"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;
sle_fr_item_code.TEXT = ""

if currentrow < 1 then 
	dw_2.reset()
	return
END IF

dw_2.retrieve( dw_1.object.item_code[currentrow], gvi_organization_id )
sle_fr_item_code.TEXT = dw_1.object.item_code[currentrow]

end event

type uo_tabpages from w_main_root`uo_tabpages within w_qc_inspect_item_group
end type

type st_1 from so_statictext within w_qc_inspect_item_group
integer x = 64
integer y = 84
integer width = 1047
boolean bringtotop = true
integer weight = 700
long textcolor = 134217749
string text = "Model Name"
end type

type sle_model_name from so_singlelineedit within w_qc_inspect_item_group
string tag = "$$HEX31$$70c88cd658d5e0ac90c7200058d594b2200008ae15d654cfdcb47cb9200085c725b85cd5c4d6200070c88cd6200084bcbcd244c7200004b274b938c194c6$$ENDHEX$$"
integer x = 64
integer y = 168
integer width = 1047
integer taborder = 20
boolean bringtotop = true
textcase textcase = upper!
end type

type cb_save_format from so_commandbutton within w_qc_inspect_item_group
integer x = 3799
integer y = 104
integer width = 439
integer height = 120
integer taborder = 20
boolean bringtotop = true
string text = "Save Format"
end type

event clicked;call super::clicked;string     docname, named 
Long iret

SETPOINTER(HOURGLASS!)		
iret = GetFileSaveName("Select Excel File ("+dw_2.classname()+")" , docname, named, "xls", "Excel Files (*.xls),*.xls")		

IF iret =1 THEN 
//		dw_1.reset()
		dw_2.insertrow(0)
		uf_save_dw_as_excel( dw_2  , docname )
ELSE
	RETURN
END IF
end event

type cb_1 from so_commandbutton within w_qc_inspect_item_group
integer x = 4233
integer y = 104
integer width = 439
integer height = 120
integer taborder = 30
boolean bringtotop = true
string text = "Upload Excel"
end type

event clicked;call super::clicked;int i
dw_2.reset()
dw_2.importclipboard( )

do
	i++
	//dw_1.object.organization_id[i] =gvi_organization_id 
	F_SET_SECURITY_ROW( dw_2 , i  , 'ALL' )
loop until i = dw_2.rowcount( )

end event

type st_2 from so_statictext within w_qc_inspect_item_group
integer x = 1157
integer y = 84
integer width = 558
boolean bringtotop = true
integer weight = 700
long textcolor = 134217749
string text = "Item Code"
end type

type sle_item_code from so_singlelineedit within w_qc_inspect_item_group
string tag = "$$HEX31$$70c88cd658d5e0ac90c7200058d594b2200008ae15d654cfdcb47cb9200085c725b85cd5c4d6200070c88cd6200084bcbcd244c7200004b274b938c194c6$$ENDHEX$$"
integer x = 1147
integer y = 168
integer width = 562
integer taborder = 40
boolean bringtotop = true
textcase textcase = upper!
end type

type st_4 from so_statictext within w_qc_inspect_item_group
integer x = 1833
integer y = 92
integer width = 631
boolean bringtotop = true
integer weight = 700
long textcolor = 134217749
string text = "FROM Item Code"
end type

type st_5 from so_statictext within w_qc_inspect_item_group
integer x = 2487
integer y = 92
integer width = 631
boolean bringtotop = true
integer weight = 700
long textcolor = 134217749
string text = "TO ITEM CODE"
end type

type sle_fr_item_code from so_singlelineedit within w_qc_inspect_item_group
string tag = "$$HEX31$$70c88cd658d5e0ac90c7200058d594b2200008ae15d654cfdcb47cb9200085c725b85cd5c4d6200070c88cd6200084bcbcd244c7200004b274b938c194c6$$ENDHEX$$"
integer x = 1833
integer y = 176
integer width = 631
integer taborder = 50
boolean bringtotop = true
textcase textcase = upper!
end type

type sle_to_item_code from so_singlelineedit within w_qc_inspect_item_group
string tag = "$$HEX31$$70c88cd658d5e0ac90c7200058d594b2200008ae15d654cfdcb47cb9200085c725b85cd5c4d6200070c88cd6200084bcbcd244c7200004b274b938c194c6$$ENDHEX$$"
integer x = 2487
integer y = 176
integer width = 631
integer taborder = 50
boolean bringtotop = true
textcase textcase = upper!
end type

type cb_print from commandbutton within w_qc_inspect_item_group
integer x = 3177
integer y = 144
integer width = 370
integer height = 104
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Copy"
end type

event clicked;
If dw_1.rowcount() < 1 then return
dw_1.accepttext()

datetime lvd_today ; Select sysdate Into :lvd_today From dual ;

string lvs_fr_item ; lvs_fr_item = sle_fr_item_code.text
string lvs_to_item ; lvs_to_item = sle_to_item_code.text

if len(trim(lvs_fr_item)) < 1 then return
if len(trim(lvs_to_item)) < 1 then return

long lvl_count
string lvs_model_name

SELECT COUNT(*) INTO :LVL_COUNT FROM IP_PRODUCT_MODEL_MASTER WHERE ORGANIZATION_ID = :gvi_organization_id AND ITEM_CODE = :lvs_fr_item ;

IF LVL_COUNT < 1 THEN
	MESSAGEBOX("$$HEX2$$55d678c7$$ENDHEX$$", "$$HEX20$$f5bcacc060d5200044c574c75cd174c72000f1b45db818b4c0c920004ac558c5b5c2c8b2e4b22000$$ENDHEX$$~r~n~r~n $$HEX9$$91c7c5c544c7200011c9c0c969d5c8b2e4b2$$ENDHEX$$")
	RETURN
END IF

  SELECT COUNT(*)
    INTO :LVL_COUNT
    FROM IQC_INSPECTION_TEMPLATE
   WHERE ORGANIZATION_ID = :gvi_organization_id 
     AND INSPECT_GROUP = :lvs_fr_item ;

IF LVL_COUNT < 1 THEN
	MESSAGEBOX("$$HEX2$$55d678c7$$ENDHEX$$", "$$HEX26$$f5bcacc060d5200044c574c75cd1d0c5200080acacc06dd5a9ba74c72000f1b45db818b4c0c920004ac558c5b5c2c8b2e4b22000$$ENDHEX$$~r~n~r~n $$HEX9$$91c7c5c544c7200011c9c0c969d5c8b2e4b2$$ENDHEX$$")
	RETURN
END IF

SELECT COUNT(*), MAX(MODEL_NAME)
   INTO :LVL_COUNT, :lvs_model_name 
  FROM IP_PRODUCT_MODEL_MASTER 
 WHERE ORGANIZATION_ID = :gvi_organization_id 
     AND ITEM_CODE            = :lvs_to_item ;


IF LVL_COUNT < 1 THEN
	MESSAGEBOX("$$HEX2$$55d678c7$$ENDHEX$$", "$$HEX20$$f5bcacc020b4200044c574c75cd174c72000f1b45db818b4c0c920004ac558c5b5c2c8b2e4b22000$$ENDHEX$$~r~n~r~n $$HEX9$$91c7c5c544c7200011c9c0c969d5c8b2e4b2$$ENDHEX$$")
	RETURN
END IF


IF F_MSGBOX1(1161 , THIS.TEXT ) <> 1 THEN RETURN        // @$$HEX11$$44c72000e4c289d5200058d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?

  SELECT COUNT(*)
    INTO :LVL_COUNT
    FROM IQC_INSPECTION_TEMPLATE
   WHERE ORGANIZATION_ID = :gvi_organization_id 
     AND INSPECT_GROUP = :lvs_to_item ;

IF LVL_COUNT > 0 THEN
	
	IF MESSAGEBOX("$$HEX2$$55d678c7$$ENDHEX$$", "$$HEX12$$f5bcacc020b4200044c574c75cd1d0c5200074c7f8bb2000$$ENDHEX$$" + STRING(LVL_COUNT) + "$$HEX19$$74ac58c7200080acacc06dd5a9ba74c72000f1b45db818b4b4c5200088c7b5c2c8b2e4b22000$$ENDHEX$$~r~n~r~n $$HEX32$$30ae74c8d0c52000f1b45db81cb4200090c7ccb87cb92000a8ba50b42000adc01cc858d5e0ac200091c7c5c544c72000c4c989d558d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?", QUESTION!, YESNO!, 2) <> 1 THEN
		RETURN
	END IF
	
	  DELETE FROM IQC_INSPECTION_TEMPLATE
		WHERE ORGANIZATION_ID = :gvi_organization_id 
		  AND INSPECT_GROUP = :lvs_to_item ;
	
	if sqlca.sqlcode <> 0 then
		messagebox('$$HEX4$$91c7c5c524c658b9$$ENDHEX$$', '$$HEX12$$adc01cc8200091c7c5c511c9200024c658b91cbcddc02000$$ENDHEX$$: ~r~n' + sqlca.sqlerrtext)
		rollback;
		return 
	end if
	
END IF

  INSERT INTO IQC_INSPECTION_TEMPLATE  
         ( INSPECT_GROUP,   
           INSPECT_GROUP_DESC,   
           SAMPLE_QTY,   
           INSPECTION_ITEM_SEQ,   
           INSPECTION_ITEM,   
           INSPECTION_ITEM_TYPE,   
           INSPECTION_VALUE_LCL,   
           INSPECTION_VALUE_STD,   
           INSPECTION_VALUE_UCL,   
           INSPECTION_UNIT,   
           ORGANIZATION_ID,   
           LAST_MODIFY_DATE,   
           LAST_MODIFY_BY,   
           ENTER_DATE,   
           ENTER_BY,   
           DISPLAY_SEQ,   
           USE_FLAG )  
     SELECT :lvs_to_item        AS  INSPECT_GROUP,   
                 :lvs_model_name AS INSPECT_GROUP_DESC,   
            A.SAMPLE_QTY,   
            A.INSPECTION_ITEM_SEQ,   
            A.INSPECTION_ITEM,   
            A.INSPECTION_ITEM_TYPE,   
            A.INSPECTION_VALUE_LCL,   
            A.INSPECTION_VALUE_STD,   
            A.INSPECTION_VALUE_UCL,   
            A.INSPECTION_UNIT,   
            A.ORGANIZATION_ID,   
            :lvd_today AS LAST_MODIFY_DATE,   
            :GVS_USER_ID AS LAST_MODIFY_BY,   
            :lvd_today AS ENTER_DATE,   
            :GVS_USER_ID AS ENTER_BY,   
            A.DISPLAY_SEQ,   
            A.USE_FLAG  
       FROM IQC_INSPECTION_TEMPLATE A 
      WHERE ORGANIZATION_ID = :gvi_organization_id 
        AND INSPECT_GROUP = :lvs_fr_item 
		order by rownum ;

if sqlca.sqlcode <> 0 then
	messagebox('$$HEX4$$91c7c5c524c658b9$$ENDHEX$$', '$$HEX12$$f5bcacc0200091c7c5c511c9200024c658b91cbcddc02000$$ENDHEX$$: ~r~n' + sqlca.sqlerrtext)
	rollback;
	return 
end if

if sqlca.sqlnrows = 0 then
	messagebox('$$HEX4$$91c7c5c524c658b9$$ENDHEX$$', '$$HEX22$$91c7c5c544c7200085c8ccb858d500c63cc798b02000ddc031c11cb4200089d574c72000c6c5b5c2c8b2e4b2$$ENDHEX$$. $$HEX7$$55d678c774d52000fcc838c194c6$$ENDHEX$$')
	rollback;
	return 
end if

commit ;
messagebox("$$HEX2$$55d678c7$$ENDHEX$$", "$$HEX4$$15c8c1c085c8ccb8$$ENDHEX$$")

sle_to_item_code.text = ''

end event

type gb_1 from so_groupbox within w_qc_inspect_item_group
integer x = 18
integer width = 1742
integer height = 288
integer taborder = 10
integer weight = 700
long textcolor = 0
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_qc_inspect_item_group
integer x = 3753
integer width = 955
integer height = 288
integer taborder = 20
integer weight = 700
long textcolor = 0
string text = "Process"
end type

type gb_2 from so_groupbox within w_qc_inspect_item_group
integer x = 1778
integer width = 1961
integer height = 288
integer taborder = 10
integer weight = 700
long textcolor = 0
string text = "Copy"
end type

