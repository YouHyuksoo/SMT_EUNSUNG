HA$PBExportHeader$infinity21_jsmes.sra
$PBExportComments$Generated Application Object
forward
global type infinity21_jsmes from application
end type
global transaction1 sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
ENVIRONMENT LENV
TRANSACTION DBTrans
//++++++++++++++++++++++++++++++++++++++++++
STRING GVS_APPLICATION_NAME
//++++++++++++++++++++++++++++++++++++++++++
STRING GVS_ORGANIZATION_CODE , GVS_ORGANIZATION_FULL_NAME
INT      MSG , GVI_OPENTAB_COUNT = 0 ,GVI_OPENSHEET_POSITION = 1 , GVI_ORGANIZATION_ID , GVI_DB_STATUS , GVI_USER_LEVEL ,  GVI_DATESET_RANGE ,GVI_DATEEND_RANGE
DECIMAL GVF_SYSTEM_VERSION , GVF_TIME

STRING GVS_BRING_IN_OUT_AUTO_SELECT
STRING GVS_INTERFACE_YN , GVS_ALERT_ACTION_CODE , GVS_APP_NAME ,GVS_APP_INITIAL ,  GVS_ORGANIZATION_NAME 
STRING GVS_DEPARTMENT_CODE , GVS_USER_NAME  , GVS_EMAIL_ADDRESS , GVS_DATABASE  , GVS_HOSTNAME , GVS_DEST_PATH
STRING GVS_COMPUTER_LOGIN_USER , GVS_COMPUTER_NAME , GVS_IP_ADDRESS , GVS_MAC_ADDRESS
STRING GVS_USER_ID , GVS_PASSWORD , GVS_PREVIOUS_LANGUAGE , GVS_LANGUAGE ,GVS_USER_ROLE 

STRING GVS_UE_DATA_CONTROL , GVS_CLIPBOARD , GVS_COLUMNNAME 
STRING GVS_ZOOM_SIZE , GVS_SORT_COLUMN , GVS_SORT_TYPE ,GVS_CURRENCY , GVS_DATA_OBJECT , GVS_DEFAULT_DIRECTORY
STRING GVS_VIEWER_PATH  , Gvs_monitor_type  , gvs_log_trace
INT Gvi_inputmode
//==============================
// DATA WINDOW
//==============================
STRING  GVS_DBERRORMESSAGE , GVS_ERROR_SYNTAX , GVS_BORDER_STYLE , GVS_DATAWINDOW_COLOR , GVS_LAST_SQLSYNTAX 
LONG     GVL_DBERRORCODE , GVL_ERROR_ROW , ROWCNT , GVL_DUAL_MONITOR_X , GVL_TITLE_TEXT_COLOR , GVL_HEADER_COLOR
LONG     GVL_ROW_DELETED , GVL_CURRENTROW  , GVL_ROWCOPY_ROW
INT        GVI_ROWFOCUSCHANGE_ON_OFF = 1 , GVI_DW_EDIT_MODE = 0 , GVI_LANGUAGE_DIRECT_CHANGE = 0  , GVI_SCROLL_TIMER

//=============================
// $$HEX3$$8cad5cd52000$$ENDHEX$$
//=============================
STRING GVS_SHOW_INVENTORY_PRICE ='Y' , GVS_SHOW_UNIT_PRICE='Y' , GVS_SHOW_SALE_PRICE = 'Y'
STRING GVS_DOWNLOAD_DOCUMENT = 'Y'
//==============================
// OPTION VALUE
//==============================
STRING GVS_WORKSTAGE_INVENTORY_REGENERATE = 'N'
STRING GVS_DB_CANCEL ='N'
STRING GVS_MATERIAL_COST_TYPE = 'A'
STRING GVS_POPUP_AUTO_ACTIVE = 'N'  
STRING GVS_DEPARTMENT_AUTO_SET = 'N'
STRING GVS_ENTERTOTAB_YN = 'N' 
STRING GVS_SYSTEM_ACCESS_YN ='N' 
STRING GVS_ERROR_LOG_TRACE_YN ='N' 
STRING GVS_DELETESELECTE_MOD = 'N' 
STRING GVS_LOCALE //$$HEX4$$c0c9edc56cad38bb$$ENDHEX$$
STRING GVS_START_URL //$$HEX3$$dcc291c72000$$ENDHEX$$URL
STRING GVS_INTERNAL_PRICE_CHECK_YN = 'N'
STRING GVS_PRODUCT_OQC_YN = 'N'  
STRING GVS_TRANSFER_INVOICE_TYPE = 'A4'
STRING GVS_PRODUCT_RECEIPT_AUTO_CONFIRM = 'N'
STRING GVS_PRODUCT_SHIPPING_AUTO_CONFIRM = 'N' 
STRING GVS_PRODUCT_SALE_PLAN_AUTO_CONFIRM = 'N' 
STRING GVS_PRODUCT_SALE_INVOICE_AUTO_CONFIRM = 'N' 
STRING GVS_SUBSTITUTE_FOR_ARRIVAL = 'N' //$$HEX13$$9ccd1cbc44c72000c4b329cc3cc75cb8200000b3b4cc98ccacb9$$ENDHEX$$
STRING GVS_PRODUCT_RECEIPT_PRICE_TYPE = 'B' //$$HEX13$$1cc888d418bc1cc888d485c7e0ace8b200ac200020c715d62000$$ENDHEX$$B=$$HEX5$$6cade4b9e8b200ac2000$$ENDHEX$$, L=$$HEX7$$04c8d4c6c9d3e0ade8b200ac2000$$ENDHEX$$I=$$HEX6$$04d6acc7e0ace8b200ac2000$$ENDHEX$$, M=$$HEX6$$f9b2d4c6c9d3e0ade8b200ac$$ENDHEX$$
STRING GVS_PRODUCT_SALE_PRICE_TYPE = 'S' //S = $$HEX5$$10d3e4b900ac20002000$$ENDHEX$$, O = $$HEX5$$18c2fcc800ac20002000$$ENDHEX$$, $$HEX11$$e0ac1dac6cad84bd2000c6c594b22000e8b200ac2000$$ENDHEX$$F
STRING GVS_MATERIAL_REQUEST_IGNORE_ACTUAL ='N' //$$HEX35$$ddc0b0c091c5b0c090c7acc720002000e0c2adccdcc22000e4c201c874c7200088c754b37cb7c4b3200034bbdcc258d5e0ac20009ccde0ace0c2adcc60d518c2200088c74cc7$$ENDHEX$$
STRING GVS_WORKORDER_GENERATE_BY_PRODUCT_PLAN ='N' //$$HEX27$$1cc888d4200091c7c5c5c0c9dcc2ddc031c1dcc22000a8bae0b4200080bd88d4d0c520009ccde0ac08c615c844c72000ccb9ecb42000$$ENDHEX$$, $$HEX19$$18bc1cc888d4200091c7c5c5c0c9dcc2dcc2d0c520009ccde0ac08c615c8200048c5ccb9ecb4$$ENDHEX$$.
STRING GVS_ASSEMBLY_OQC_AUTO_PASS = 'N' //$$HEX13$$18bc1cc888d42000ddc0b0c0e4c201c8200085c725b8dcc22000$$ENDHEX$$OQC $$HEX10$$80acacc0200090c7d9b3200069d5a9acecc580bd$$ENDHEX$$
STRING GVS_SALE_DIVISION 
STRING GVS_USE_HUB_WAREHOUSE = 'N'
STRING GVS_PRODUCT_LQC_AUTO_PASS = 'N'
STRING GVS_PRODUCT_OQC_AUTO_PASS ='N'
STRING GVS_ASSEMBLY_LQC_AUTO_PASS = 'N'
STRING GVS_ARRIVAL_EXCESS_ORDER_QTY = 'N'
STRING GVS_USE_LOCATION_CODE= 'N'
STRING GVS_ALLOW_LAST_MM_RECEIPT_CANCEL ='N'
STRING GVS_USE_MATERIAL_MFS = 'Y' 
STRING Gvs_product_actual_over_plan_qty = 'Y'
STRING Gvs_ASSEMBLY_actual_over_plan_qty ='Y' 
STRING Gvs_assembly_actual_auto_trans = 'N'
STRING Gs_product_actual_barcode_yn ='N'
STRING Gvs_product_shipping_plan_oqc_yn ='N'
STRING Gvs_material_recycle_auto_issue ='N'
STRING Gvs_mfs_auto_set = 'Y' 
STRING Gvs_free_subcontract_bom_exploasion_error_ignore_yn ='N'
STRING Gvs_WQC_REQUEST_INVENTORY_MOVE = 'N'
STRING Gvs_FQC_REQUEST_INVENTORY_MOVE = 'N'
STRING Gvs_lqc_auto_request ='Y'
STRING Gvs_oqc_auto_request ='Y'
STRING Gvs_allow_ws_minus_inventory = 'Y'
STRING Gvs_material_receipt_return_auto_po = 'N'
STRING Gvs_lqc_merge_check_mfs
STRING Gvs_customer_order_no_auto_set ='N'
STRING Gvs_item_buy_price_auto_confirm ='N'
STRING Gvs_prod_sale_price_auto_confirm = 'N'
STRING GVS_SHIPPING_INVOICE_TYPE = 'A4' //A4 , DOT , ALL
STRING Gvs_unit_price_check_yn = 'Y' //$$HEX8$$6cade4b9e8b200ac2000b4cc6cd02000$$ENDHEX$$
STRING Gvs_SHIPPING_AMT_PRECISION = '2' //2,1,0
STRING Gvs_PRODUCT_MATERIAL_COST = 'B' //B,M,BM
STRING GVS_BARCODE_AUTO_PRINT = 'N' //N,Y
STRING GVS_SHOW_ITEM_IMAGE = 'N' //Y , N
STRING GVS_ITEM_SEARCH_YN = 'N'
STRING Gvs_PAID_RECEIPT_AUTO_RI = 'N' //Y,N
STRING Gvs_item_receipt_invoice_auto_confirm ='N'
STRING Gvs_use_sale_charge_condition = 'N'  //sale charge
STRING Gvs_barcode_type
STRING Gvs_ifts_check_yn = 'N'
STRING Gvs_ists_check_yn = 'N'
STRING Gvs_router_check_yn = 'N'
STRING Gvs_visual_check_yn = 'N'
STRING Gvs_repair_check_yn = 'N'
STRING Gvs_mix_check_yn = 'N'
STRING Gvs_assembly_result_receipt_wh = 'N'
STRING Gvs_product_plan_from_sale_plan = 'N'

STRING Gvs_show_machine_image
STRING Gvs_auto_shipping_plan
STRING Gvs_show_mold_image
STRING Gvs_show_unit_price_error_msg
STRING gvs_material_mfs_replace_location_code
STRING gvs_mfs_replace_location_code

STRING Gvs_work_order_by_mfs
STRING Gvs_work_board_type 
STRING Gvs_material_receipt_auto_confirm
//		 STRING Gvs_assembly_result_receipt_wh
STRING gvs_invoice_open_by_sale_plan
STRING Gvs_show_cart_image
STRING Gvs_product_st_by_item
STRING Gvs_unit_price_check_yn_4_po
STRING Gvs_label_size
STRING Gvs_material_fifo_yn
STRING Gvs_reel_divide_compare_yn = 'N' //$$HEX10$$b4b984bd60d5200044be50ad200080ac9dc92000$$ENDHEX$$
STRING Gvs_slip_process = 'N' // $$HEX16$$acc2bdb920001cbc89d5200029bc95bc20000900200009002000090009002000$$ENDHEX$$
//STRING GVS_USE_GMES_YN = 'Y'  // GMES $$HEX10$$7cb92000b5d174d52000a8ba78b320000fbc2000$$ENDHEX$$PID $$HEX3$$70c88cd62000$$ENDHEX$$
STRING Gvs_simple_model_master_yn = 'N' //$$HEX13$$a8ba78b32000c8b9a4c230d17cb9200004ace8b258d58cac2000$$ENDHEX$$
STRING Gvs_use_msl_level_value='N' //MSL LEVEL VALUE $$HEX4$$acc0a9c66cad84bd$$ENDHEX$$
STRING Gvs_labeler_path

//================================
//
//================================

STRING gvs_material_issue_compare_yn , gvs_issue_by_feeder_yn , gvs_long_term_inventory ,gvs_life_cycle_check_yn ,gvs_msl_time_check_yn
STRING gvs_msl_label_print , gvs_receipt_lot_check_yn , Gvs_USE_TRAY_DIVIDE_YN , Gvs_lot_divide_print_lg_label_yn
//================================
//
//================================
STRING Gvs_label_type
STRING Gvs_label_across = '1'
STRING Gvs_label_column_spacing = '0'
STRING Gvs_label_row_spacing = '300'
STRING Gvs_label_height = '1200'
STRING Gvs_label_width = '900'
STRING Gvs_label_font = '4'
STRING Gvs_label_fontface = 'Arial'
STRING gvs_label_zoom = '100'
STRING Gvs_top_margin = '0'
STRING Gvs_left_margin = '0'
STRING Gvs_bottom_margin = '0'
//==============================
//  
//==============================
DOUBLE           GVD_TITLE_BACKGROUND
DATASTORE    GDS_DUAL , GDS_MENU , GDS_PRIVILEGE

DATAWINDOW  SELECTED_DATA_WINDOW
WINDOW           SELECTED_WINDOW

//==============================
//  OLE OBJECT
//==============================
OLEOBJECT OLE_PARAM
OLEobject Speechobject
//==============================
//  STRUCTURE
//==============================
ST_DW_COLINFO  GST_DW_COLINFO
ST_SET                  GST_SET 
ST_RETURN           GST_RETURN
ST_EDIT_OBJECT  GST_EDIT_OBJECT
QOCINFO              GST_QOCINFO
//==============================
//  MENU
//==============================
INT GVI_MENU_ORDER , GVI_MENU_LEVEL , GVI_MENU_INDEX , GVI_DEEPS
//==============================
//
//==============================
DWOBJECT GS_ANYDATA

//==============================
//  FOR GRAPH WINDOW
//==============================
N_POWERPRINTER NVO_POWERPRN


//==============================
N_INET IN_INET
N_IR     IN_IR

//=====================================
// $$HEX8$$08c724c650b420002cd285bac4b32000$$ENDHEX$$
//=====================================
CONSTANT long GWL_EXSTYLE = (-20)
CONSTANT long WS_EX_LAYERED = 524288
CONSTANT long LWA_COLORKEY = 1
CONSTANT long LWA_ALPHA = 2
CONSTANT long ULW_COLORKEY = 1
CONSTANT long ULW_ALPHA = 2
CONSTANT long ULW_OPAQUE = 4

//=========================================
// $$HEX5$$b5d1e0c2ecd3b8d22000$$ENDHEX$$
//=========================================
constant int comEvSend      = 1   //$$HEX10$$d15301908b4ef64e023020002000200020002000$$ENDHEX$$
constant int comEvReceive  = 2  // $$HEX10$$a56336658b4ef64e023020002000200020002000$$ENDHEX$$
constant int comEvCTS       = 3   //clear-to-send   $$HEX9$$bf7ed8531653023020002000200020002000$$ENDHEX$$
constant int comEvDSR       = 4   //data-set   ready   $$HEX9$$bf7ed8531653023020002000200020002000$$ENDHEX$$
constant int comEvCD          = 5   //carrier   detect   $$HEX9$$bf7ed8531653023020002000200020002000$$ENDHEX$$
constant int comEvRing        =  6   //$$HEX10$$2f63c394c0684b6d023020002000200020002000$$ENDHEX$$
constant int comEvEOF        = 7   //$$HEX4$$8765f64ed37e5f67$$ENDHEX$$

constant int comEventBreak  = 1001  // $$HEX12$$a563366530522d4ead65e14ff75320002000200020002000$$ENDHEX$$
constant int comEventCTSTO  = 1002  // Clear-to-send   $$HEX7$$858df66520002000200020002000$$ENDHEX$$
constant int comEventDSRTO  = 1003  // Data-set   ready   $$HEX7$$858df66520002000200020002000$$ENDHEX$$
constant int comEventFrame  = 1004  // $$HEX8$$275e1995ef8b20002000200020002000$$ENDHEX$$
constant int comEventOverrun =  1006  // $$HEX9$$ef7ae353858d1f9020002000200020002000$$ENDHEX$$
constant int comEventCDTO   =1007   //Carrier   detect   $$HEX7$$858df66520002000200020002000$$ENDHEX$$
constant int comEventRxOver  = 1008  // $$HEX12$$a5633665137fb2513a53a26efa5120002000200020002000$$ENDHEX$$
constant int comEventRxParity =  1009  // Parity   $$HEX7$$1995ef8b20002000200020002000$$ENDHEX$$
constant int comEventTxFull  = 1010 //  $$HEX11$$204f938f137fb2513a53e16e20002000200020002000$$ENDHEX$$
constant int comEventDCB  = 1011  // $$HEX15$$c068227def7ae353200020002000be8b0759a76336525757200020002000$$ENDHEX$$(DCB)   $$HEX10$$f66584760f6116591995ef8b2000200020002000$$ENDHEX$$

end variables

global type infinity21_jsmes from application
string appname = "infinity21_jsmes"
boolean toolbartext = true
end type
global infinity21_jsmes infinity21_jsmes

type prototypes
function boolean GetComputerNameA(ref string cname,ref  long nbuf) library "Kernel32.dll" alias for "GetComputerNameA;Ansi"
Function boolean AnimateWindow(long hwnd,long dwTime,long dwFlags) Library 'user32.dll'
FUNCTION long GetUserNameA(ref string UserName, ref ulong BufferLength) LIBRARY "ADVAPI32.DLL" alias for "GetUserNameA;Ansi"
Function integer GetMACAddress ( ref string buf, integer len ) library "getmacip.dll" alias for "GetMACAddress;Ansi"
Function integer GetIPAddress ( ref string buf, integer len ) library "getmacip.dll" alias for "GetIPAddress;Ansi"
FUNCTION LONG ShellExecuteA(long hwnd, string lpOperation, string lpFile, string lpParameters, string lpDirectory, long nShowCmd) LIBRARY "shell32.DLL" alias for "ShellExecuteA;Ansi"
function long IsNetworkAlive(Ref Long lpdwFlags ) Library "SENSAPI.DLL" 
Function long IsDestinationReachableA( string lpszDestination , ref  qocinfo  lpQOCInfo  )  Library "SENSAPI.DLL" alias for "IsDestinationReachableA;Ansi"
Function boolean keybd_event( int bVk, int bScan, int dwFlags, int dwExtraInfo) LIBRARY 'user32.dll' 

FUNCTION long GetWindowLongA(long hwnd,long nOffset) library "user32.dll"
FUNCTION long SetWindowLongA(Long HWND,Long nIndex,Long dwNewLong) library "user32.dll"
FUNCTION Long SetLayeredWindowAttributes(Long hWnd,Long crKey,long bAlpha,Long dwFlags) LIBRARY "user32.dll" 

Function boolean sndPlaySoundA( string SoundName, uint Flags ) Library "WINMM.DLL" Alias for "sndPlaySoundA;Ansi"
Function uint waveOutGetNumDevs() Library "WINMM.DLL" Alias for "waveOutGetNumDevs;Ansi"
FUNCTION ULong MciSendString(String lpszCommand, ref String lpszReturnString, ULong cchReturn, ULong hwndCallback) LIBRARY "WINMM.DLL" ALIAS FOR "mciSendStringA;Ansi"

function LONG ImmGetContext( long handle ) LIBRARY "IMM32.DLL"
function LONG ImmSetConversionStatus( long hIMC, long fFlag, long l ) LIBRARY "IMM32.DLL"
function LONG ImmReleaseContext( long handle, long hIMC ) LIBRARY "IMM32.DLL"


end prototypes

type variables

end variables

event close;if FileExists ( 'postscript.bat')  then 
	FileDelete ('postscript.bat')
	//
end if
f_system_access(  'SYSTEM'  ,  'SYSTEM' , 'LOGOFF')
end event

on infinity21_jsmes.create
appname="infinity21_jsmes"
message=create message
sqlca=create transaction1
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on infinity21_jsmes.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;string ls_cmd, ls_arg[] 
integer i, li_argcnt
ls_cmd = Trim(CommandParm())
//==============================================
// $$HEX5$$f1c200aef8c274c728c6$$ENDHEX$$
//==============================================	
IF ls_cmd <> ''  THEN
	
			li_argcnt = 1
			DO WHILE Len(ls_cmd) > 0
			
				// Find the first blank
				i = Pos( ls_cmd, " ")
				// If no blanks (only one argument),
				// set i to point to the hypothetical character
				// after the end of the string
				if i = 0 then i = Len(ls_cmd) + 1
				// Assign the arg to the argument array.
				// Number of chars copied is one less than the
				// position of the space found with Pos
				ls_arg[li_argcnt] = Left(ls_cmd, i - 1)
				// Increment the argument count for the next loop
				li_argcnt = li_argcnt + 1
				// Remove the argument from the string
				// so the next argument becomes first
				ls_cmd = Replace(ls_cmd, 1, i, "")
			
			LOOP
	
//==================================================
//
//==================================================

Gvs_app_initial               = Profilestring("SYSTEM.INI","Application","ApplicationInitial","")
Gvs_app_name              = Profilestring("SYSTEM.INI","Application","ApplicationName","")
Gvf_system_version      = Real(Profilestring("SYSTEM.INI","Database","Version",""))
Gvi_opensheet_position= INTEGER(ProfileString ("SYSTEM.INI", "Application", "OpenSheetPosition", ""))
Gvs_error_log_trace_yn=Profilestring("SYSTEM.INI","Application","Errorlogtrace","") 

Gvi_organization_id        = Integer(ls_arg[1])
Gvs_language                 = ls_arg[2]
Gvs_previous_language = Gvs_language
Gvs_user_id                    = ls_arg[4]
Gvs_password                 = ls_arg[5]

//================================================
//  DBMS Driver 
//================================================
sqlca.dbms               = ProfileString ("SYSTEM.INI", "database", "dbms",       "")

if ProfileString ("SYSTEM.INI", "database", "dbms",       "") = 'JDBC' then 
   sqlca.dbparm = ProfileString ("SYSTEM.INI", "JDBCDBPARM", "dbparm",     "")		
else
   sqlca.dbparm = ProfileString ("SYSTEM.INI", "NATIVEDBPARM", "dbparm",     "")		
end if

sqlca.logid       =  ProfileString ("SYSTEM.INI", "database", "logid",      "")
sqlca.logpass   = f_password_decode(ProfileString ("SYSTEM.INI", "database", "LogPassWord", ""))
sqlca.servername = ls_arg[3]
//================================================
// $$HEX13$$30aef8bcb8c5b4c5200024c115c812ac20007dc7b4c524c630ae$$ENDHEX$$
//================================================

IF Gvs_language = '' OR ISNULL(Gvs_language) THEN 
	Gvs_language  = ProfileString ("SYSTEM.INI", "database", "DefaultLanguage", "")
END IF
//================================================================================
// $$HEX4$$b8c5b4c5c0bcbdac$$ENDHEX$$
//================================================================================
Gvs_database = ls_arg[3]

Disconnect;
Connect;
//=========================================
// Database Connect error
//=========================================
if sqlca.sqlcode <> 0 then
	Gvi_db_status = 0
	Close(w_openning_popup)
//     sle_msg.text = "Connection Failed "+string(sqlca.sqlcode)+' '+sqlca.sqlerrtext
	  
	  Messagebox("Database Connect Error" , "Error Code : "+SQLCA.servername+' '+SQLCA.DBMS+' '+string(sqlca.sqldbcode)+'~r~n'+"Error Number : "+string(sqlca.sqlcode)+'~r~n'+'Error Text :'+sqlca.sqlerrtext +'~r~n'+" Do You wish to System Check ?" , question! , yesno!)
       RETURN    
else
	
       Gvi_db_status = 1	
	  
end if
//==================================================
//
//==================================================
Select A.USER_NAME ,
		 B.ORGANIZATION_NAME ,		 
		 A.EMAIL_ADDRESS,
		 A.USER_LEVEL
    into :Gvs_user_name  ,  :Gvs_organization_name ,  :Gvs_email_address , :Gvi_user_level
   from ISYS_USERS A , ISYS_ORGANIZATION  B
 where A.user_id             =:Gvs_user_id
	and A.PASSWORD      = :Gvs_password
	and A.ORGANIZATION_ID  = :Gvi_organization_id
	and A.ORGANIZATION_ID = B.ORGANIZATION_ID;
	
if f_sql_check() < 1 then Return 

if sqlca.sqlcode = 100 then 
	f_msgbox( 118 ) //userid / password invalid
	Return
end if

SELECT DISTINCT MAX(ROLE_CODE) INTO :Gvs_User_Role
   FROM ISYS_PRIVILEGE
WHERE USER_ID =  :Gvs_user_id
    AND ORGANIZATION_ID =  :Gvi_organization_id ;
	 
if f_sql_check() < 1 then Return 

if Len(Gvs_user_name) = 0 then 
	Gvs_user_name = "Unknown User"
end if
//========================================
//Version Check
//========================================
  f_version_check()

//==============================================
// $$HEX13$$dcc2a4c25cd1200058d6bdacc0bc18c220007dc724c6e4b484c7$$ENDHEX$$
//==============================================
f_config_setup()
//==============================================
f_system_access( 'W_LOGON' ,  'POPUP WINDOW' , 'LOGON')
//System Runtime Default Directory
Gvs_default_directory = Getcurrentdirectory()

Open ( w_main_frame)

if Gvs_system_access_yn = 'Y' then 
	f_message_ontime(2, "System Access Monirotring Actived" )
end if

//===================================================
//			$$HEX7$$c1c911c820005cb8f8ad78c72000$$ENDHEX$$
//===================================================
ELSE

		Open (w_logon)
		//====================================
		// Execute PostScript
		//====================================
		//w_openning_popup.mle_message.text = w_openning_popup.mle_message.text+"Postscript Exists Check"+'~r~n'
		if FileExists ( 'postscript.bat')  then 
			 w_openning_popup.mle_message.text = w_openning_popup.mle_message.text+"Run Postscript"+'~r~n'
			Run( 'postscript.bat')
		end if

//====================================
// Get Environment
//====================================
// w_openning_popup.mle_message.text = w_openning_popup.mle_message.text+"Get Environment"+'~r~n'
IF GetEnvironment ( lEnv ) = 1 THEN
ELSE
	Messagebox("Error" , "Get Environment Failed")
END IF

//====================================
// Data Base Connection Status 0 Not Connected
//====================================
Gvi_db_status = 0

end if

end event

event systemerror; string ls_logline = " "
 
Gvl_DberrorCode =  sqlca.sqldbcode
Gvs_dberrorMessage = sqlca.sqlerrtext

if Gvs_language = 'K' then
 ls_logline += "$$HEX5$$24c658b988bc38d62000$$ENDHEX$$: "+String(error.number) + "~r~n " 
 ls_logline += "$$HEX5$$24c658b9b4b0a9c62000$$ENDHEX$$: "+error.text+ "~r~n " 
 ls_logline += "$$HEX5$$1cbcddc07cb778c72000$$ENDHEX$$: " + String(error.line) +"~r~n " 
 ls_logline += "$$HEX4$$74c7a4bcb8d22000$$ENDHEX$$: " + error.objectevent+ "~r~n " 
 ls_logline += "$$HEX5$$24c60cbe1dc8b8d22000$$ENDHEX$$: " + error.object+ "~r~n " 
 ls_logline += "$$HEX7$$08c7c4b3b0c654ba74b220002000$$ENDHEX$$: " + error.WindowMenu+ "~r~n "   
else
	
 ls_logline += "Error Number : "+String(error.number) + "~r~n " 
 ls_logline += "Error Text : "+error.text+ "~r~n " 
 ls_logline += "Occurred at Line : " + String(error.line) +"~r~n " 
 ls_logline += "Event : " + error.objectevent+ "~r~n " 
 ls_logline += "Object : " + error.object+ "~r~n " 
 ls_logline += "Window Menu : " + error.WindowMenu+ "~r~n "  

end if

rollback ;
 
  //================================================
 // Error Log Trace
 //================================================
 if isvalid(w_main_frame) then 
  f_set_error_log_trace( w_main_frame.Getactivesheet() ,  error.object , error.number , ls_logline ,  Gvl_DberrorCode ,  Gvs_dberrorMessage ,Gvs_last_sqlsyntax) 	
 else
  f_set_error_log_trace( selected_window ,  error.object , error.number , ls_logline ,  Gvl_DberrorCode ,  Gvs_dberrorMessage ,Gvs_last_sqlsyntax)  
 end if
 //================================================
 
 if  f_msgbox1( 144 ,  "At Application Systemerror"+'~r~n'+ls_logline +'~r~n'+ "Do you want to stop the program?" ) = 1 then 
    disconnect ;
    halt close
end if
end event

