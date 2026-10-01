HA$PBExportHeader$w_logon.srw
forward
global type w_logon from w_none_dw_popup_root
end type
type sle_msg from so_singlelineedit within w_logon
end type
type cbx_autosave from so_checkbox within w_logon
end type
type st_organization from so_statictext within w_logon
end type
type st_password from so_statictext within w_logon
end type
type st_username from so_statictext within w_logon
end type
type rb_english from so_radiobutton within w_logon
end type
type rb_chiness from so_radiobutton within w_logon
end type
type rb_korean from so_radiobutton within w_logon
end type
type ddlb_organization_id from so_dropdownlistbox within w_logon
end type
type pb_logon from so_pbutton within w_logon
end type
type pb_exit from so_pbutton within w_logon
end type
type em_version from so_editmask within w_logon
end type
type sle_user_id from so_singlelineedit within w_logon
end type
type sle_user_name from so_singlelineedit within w_logon
end type
type sle_password from so_singlelineedit within w_logon
end type
type ddlb_database from so_dropdownlistbox within w_logon
end type
type st_servername from so_statictext within w_logon
end type
type p_2 from picture within w_logon
end type
type p_3 from picture within w_logon
end type
type dw_userface from datawindow within w_logon
end type
type rb_native from radiobutton within w_logon
end type
type rb_jdbc from radiobutton within w_logon
end type
type sle_hostname from so_singlelineedit within w_logon
end type
type st_hostname from so_statictext within w_logon
end type
type rb_intranet from radiobutton within w_logon
end type
type rb_extranet from radiobutton within w_logon
end type
type sle_department_code from so_singlelineedit within w_logon
end type
type sle_department_name from so_singlelineedit within w_logon
end type
type dw_1 from u_dw_xplistbar within w_logon
end type
type st_userid from so_statictext within w_logon
end type
type st_1 from so_statictext within w_logon
end type
type st_companyname from so_statictext within w_logon
end type
type pb_1 from so_pbutton within w_logon
end type
type p_4 from picture within w_logon
end type
type st_2 from statictext within w_logon
end type
type gb_location from so_groupbox within w_logon
end type
type gb_network_driver from so_groupbox within w_logon
end type
type gb_language from so_groupbox within w_logon
end type
type gb_user_information from so_groupbox within w_logon
end type
end forward

global type w_logon from w_none_dw_popup_root
integer width = 3131
integer height = 1668
boolean titlebar = false
boolean controlmenu = false
windowtype windowtype = popup!
long backcolor = 134217732
boolean contexthelp = false
sle_msg sle_msg
cbx_autosave cbx_autosave
st_organization st_organization
st_password st_password
st_username st_username
rb_english rb_english
rb_chiness rb_chiness
rb_korean rb_korean
ddlb_organization_id ddlb_organization_id
pb_logon pb_logon
pb_exit pb_exit
em_version em_version
sle_user_id sle_user_id
sle_user_name sle_user_name
sle_password sle_password
ddlb_database ddlb_database
st_servername st_servername
p_2 p_2
p_3 p_3
dw_userface dw_userface
rb_native rb_native
rb_jdbc rb_jdbc
sle_hostname sle_hostname
st_hostname st_hostname
rb_intranet rb_intranet
rb_extranet rb_extranet
sle_department_code sle_department_code
sle_department_name sle_department_name
dw_1 dw_1
st_userid st_userid
st_1 st_1
st_companyname st_companyname
pb_1 pb_1
p_4 p_4
st_2 st_2
gb_location gb_location
gb_network_driver gb_network_driver
gb_language gb_language
gb_user_information gb_user_information
end type
global w_logon w_logon

type variables
String lvs_sql_net ,lvs_password , lvs_profile_edit , lvs_System_check , lvs_download 
string lvs_internal , lvs_external , lvs_hardware , lvs_printing , lvs_network , lvs_remote_control

boolean ib_Painting
end variables

forward prototypes
public function integer wf_language_change (string as_language, string as_organization_id)
end prototypes

public function integer wf_language_change (string as_language, string as_organization_id);if as_language = 'C' THEN
	
  st_userid.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "USERIDTITLE_C", st_userid.text)
  st_username.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "USERNAMETITLE_C", st_username.text)	
  st_password.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "PASSWORDTITLE_C", st_password.text)		
  st_organization.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "ORGANIZATIONTITLE_C", st_organization.text)		  
  st_servername.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "SERVERNAMETITLE_C", st_servername.text)		  
  st_hostname.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "HOSTNAMETITLE_C", st_hostname.text)		    
  gb_language.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "LANGUAGETITLE_C", gb_language.text)		      
  gb_user_information.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "USERINFORMATIONTITLE_C", gb_user_information.text)		       
  
  gb_location.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "LOCATIONTITLE_C", gb_location.text)		       
  rb_intranet.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "INTRANETTITLE_C", rb_intranet.text)		         
  rb_extranet.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "EXTRANETTITLE_C", rb_extranet.text)		         
  
  pb_logon.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "CONNECTTITLE_C", pb_logon.text)		    
  pb_exit.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "EXITTITLE_C", pb_exit.text)		  
  
  lvs_sql_net = ProfileString ("MESSAGE.INI", "LogonLanguage", "SQLNETEDIT_C", 'SQL Net Edit')	  
  lvs_password = ProfileString ("MESSAGE.INI", "LogonLanguage", "CHANGE_C", 'Password Change')	  
  lvs_profile_edit = ProfileString ("MESSAGE.INI", "LogonLanguage", "PROFILEEDIT_C", 'Profile Edit')	  
  lvs_system_check = ProfileString ("MESSAGE.INI", "LogonLanguage", "SYSTEMCHECK_C", 'System Check')	    
  lvs_download = ProfileString ("MESSAGE.INI", "LogonLanguage", "DOWNLOAD_C", 'Download')	      
  lvs_internal = ProfileString ("MESSAGE.INI", "LogonLanguage", "INTRANETTITLE_C", 'Internal')		         
  lvs_external = ProfileString ("MESSAGE.INI", "LogonLanguage", "EXTRANETTITLE_C", 'External')
  
  lvs_hardware = ProfileString ("MESSAGE.INI", "LogonLanguage", "HARDWARE_C", 'Hardware')
  lvs_printing = ProfileString ("MESSAGE.INI", "LogonLanguage", "PRINTING_C", 'Printer')
  lvs_network = ProfileString ("MESSAGE.INI", "LogonLanguage", "NETWORK_C", 'Network')

  lvs_remote_control = ProfileString ("MESSAGE.INI", "LogonLanguage", "REMOTECONTROL_C", 'Remote Control')
 
 st_companyname.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "CompanyName"+as_organization_id+"_C",     st_companyname.text)  
  
elseif as_language = 'K' THEN
	
   st_userid.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "USERIDTITLE_K", st_userid.text)
  st_username.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "USERNAMETITLE_K", st_username.text)	
  st_password.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "PASSWORDTITLE_K", st_password.text)		
  st_organization.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "ORGANIZATIONTITLE_K", st_organization.text)		  
  st_servername.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "SERVERNAMETITLE_K", st_servername.text)		    
  st_hostname.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "HOSTNAMETITLE_K", st_hostname.text)		    
  gb_language.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "LANGUAGETITLE_K", gb_language.text)		    
  gb_user_information.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "USERINFORMATIONTITLE_K", gb_user_information.text)		       
  gb_location.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "LOCATIONTITLE_K", gb_location.text)		       
  rb_intranet.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "INTRANETTITLE_K", rb_intranet.text)		         
  rb_extranet.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "EXTRANETTITLE_K", rb_extranet.text)		         
  pb_logon.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "CONNECTTITLE_K", pb_logon.text)		    
  pb_exit.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "EXITTITLE_K", pb_exit.text)		


  lvs_sql_net = ProfileString ("MESSAGE.INI", "LogonLanguage", "SQLNETEDIT_K", 'SQL Net Edit')	  
  lvs_password = ProfileString ("MESSAGE.INI", "LogonLanguage", "CHANGE_K", 'Password Change')	  
  lvs_profile_edit = ProfileString ("MESSAGE.INI", "LogonLanguage", "PROFILEEDIT_K", 'Profile Edit')	  
  lvs_system_check = ProfileString ("MESSAGE.INI", "LogonLanguage", "SYSTEMCHECK_K", 'System Check')	    
  lvs_download = ProfileString ("MESSAGE.INI", "LogonLanguage", "DOWNLOAD_K", 'Download')	        
  lvs_internal = ProfileString ("MESSAGE.INI", "LogonLanguage", "INTRANETTITLE_K", 'Internal')		         
  lvs_external = ProfileString ("MESSAGE.INI", "LogonLanguage", "EXTRANETTITLE_K", 'External')
  
  lvs_hardware = ProfileString ("MESSAGE.INI", "LogonLanguage", "HARDWARE_K", 'External')
  lvs_printing = ProfileString ("MESSAGE.INI", "LogonLanguage", "PRINTING_K", 'Printer')
  lvs_network = ProfileString ("MESSAGE.INI", "LogonLanguage", "NETWORK_K", 'Network')
  lvs_remote_control = ProfileString ("MESSAGE.INI", "LogonLanguage", "REMOTECONTROL_K", 'Remote Control')  
  
  st_companyname.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "CompanyName"+as_organization_id+"_K",     st_companyname.text)  
  
elseif  as_language = 'E' THEN 
  st_userid.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "USERIDTITLE_E", st_userid.text)
  st_username.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "USERNAMETITLE_E", st_username.text)	
  st_password.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "PASSWORDTITLE_E", st_password.text)		
  st_organization.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "ORGANIZATIONTITLE_E", st_organization.text)		
  st_servername.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "SERVERNAMETITLE_E", st_servername.text)		    
  st_hostname.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "HOSTNAMETITLE_E", st_hostname.text)		    
  gb_language.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "LANGUAGETITLE_E", gb_language.text)		    
  gb_user_information.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "USERINFORMATIONTITLE_E", gb_user_information.text)		       
  gb_location.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "LOCATIONTITLE_E", gb_location.text)		       
  rb_intranet.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "INTRANETTITLE_E", rb_intranet.text)		         
  rb_extranet.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "EXTRANETTITLE_E", rb_extranet.text)		         
  pb_logon.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "CONNECTTITLE_E", pb_logon.text)		    
  pb_exit.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "EXITTITLE_E", pb_exit.text)		
  lvs_password = ProfileString ("MESSAGE.INI", "LogonLanguage", "CHANGE_E", 'Password Change')	  
  lvs_profile_edit = ProfileString ("MESSAGE.INI", "LogonLanguage", "PROFILEEDIT_E", 'Profile Edit')	  
  lvs_system_check = ProfileString ("MESSAGE.INI", "LogonLanguage", "SYSTEMCHECK_E", 'System Check')	    
  lvs_download = ProfileString ("MESSAGE.INI", "LogonLanguage", "DOWNLOAD_E", 'Download')	      
  
  lvs_internal = ProfileString ("MESSAGE.INI", "LogonLanguage", "INTRANETTITLE_E", 'Internal')		         
  lvs_external = ProfileString ("MESSAGE.INI", "LogonLanguage", "EXTRANETTITLE_E", 'External')
  
  lvs_hardware = ProfileString ("MESSAGE.INI", "LogonLanguage", "HARDWARE_E", 'Hardware')
  lvs_printing = ProfileString ("MESSAGE.INI", "LogonLanguage", "PRINTING_E", 'Printer')
  lvs_network = ProfileString ("MESSAGE.INI", "LogonLanguage", "NETWORK_E", 'Network')
  
  lvs_remote_control = ProfileString ("MESSAGE.INI", "LogonLanguage", "REMOTECONTROL_E", 'Remote Control')  
  st_companyname.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "CompanyName"+as_organization_id+"_E",   st_companyname.text)  
  
end if

Long ll_parent

dw_1.reset()

//Add new item
ll_parent = dw_1.of_AddItem('header','See Also',0, '')
dw_1.of_AddItem('child',lvs_sql_net,ll_parent, 'addhardware.bmp')
dw_1.of_AddItem('child',lvs_password,ll_parent, 'display.bmp')
dw_1.of_AddItem('child',lvs_profile_edit,ll_parent, 'sound.bmp')
dw_1.of_AddItem('child',lvs_System_check,ll_parent, 'power.bmp')
dw_1.of_AddItem('child',lvs_download,ll_parent, 'system.bmp')
dw_1.of_AddItem('filler','',ll_parent, '')//filler is necessary for looks

//Add new item
ll_parent = dw_1.of_AddItem('header','Location',0, '')
dw_1.of_AddItem('child',lvs_internal,ll_parent, 'internal.bmp')
dw_1.of_AddItem('child',lvs_external,ll_parent, 'external.bmp')
dw_1.of_AddItem('filler','',ll_parent, '')//filler is necessary for looks

//Add new item
ll_parent = dw_1.of_AddItem('header','Troubleshooters',0, '')
dw_1.of_AddItem('child',lvs_hardware,ll_parent, 'hardware.bmp')
dw_1.of_AddItem('child',lvs_printing,ll_parent, 'printing.bmp')
dw_1.of_AddItem('child',lvs_network,ll_parent, 'Networking.bmp')
dw_1.of_AddItem('child',lvs_remote_control,ll_parent, 'Phone.gif')
dw_1.of_AddItem('filler','',ll_parent, '')//filler is necessary for looks

RETURN 0
end function

on w_logon.create
int iCurrent
call super::create
this.sle_msg=create sle_msg
this.cbx_autosave=create cbx_autosave
this.st_organization=create st_organization
this.st_password=create st_password
this.st_username=create st_username
this.rb_english=create rb_english
this.rb_chiness=create rb_chiness
this.rb_korean=create rb_korean
this.ddlb_organization_id=create ddlb_organization_id
this.pb_logon=create pb_logon
this.pb_exit=create pb_exit
this.em_version=create em_version
this.sle_user_id=create sle_user_id
this.sle_user_name=create sle_user_name
this.sle_password=create sle_password
this.ddlb_database=create ddlb_database
this.st_servername=create st_servername
this.p_2=create p_2
this.p_3=create p_3
this.dw_userface=create dw_userface
this.rb_native=create rb_native
this.rb_jdbc=create rb_jdbc
this.sle_hostname=create sle_hostname
this.st_hostname=create st_hostname
this.rb_intranet=create rb_intranet
this.rb_extranet=create rb_extranet
this.sle_department_code=create sle_department_code
this.sle_department_name=create sle_department_name
this.dw_1=create dw_1
this.st_userid=create st_userid
this.st_1=create st_1
this.st_companyname=create st_companyname
this.pb_1=create pb_1
this.p_4=create p_4
this.st_2=create st_2
this.gb_location=create gb_location
this.gb_network_driver=create gb_network_driver
this.gb_language=create gb_language
this.gb_user_information=create gb_user_information
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_msg
this.Control[iCurrent+2]=this.cbx_autosave
this.Control[iCurrent+3]=this.st_organization
this.Control[iCurrent+4]=this.st_password
this.Control[iCurrent+5]=this.st_username
this.Control[iCurrent+6]=this.rb_english
this.Control[iCurrent+7]=this.rb_chiness
this.Control[iCurrent+8]=this.rb_korean
this.Control[iCurrent+9]=this.ddlb_organization_id
this.Control[iCurrent+10]=this.pb_logon
this.Control[iCurrent+11]=this.pb_exit
this.Control[iCurrent+12]=this.em_version
this.Control[iCurrent+13]=this.sle_user_id
this.Control[iCurrent+14]=this.sle_user_name
this.Control[iCurrent+15]=this.sle_password
this.Control[iCurrent+16]=this.ddlb_database
this.Control[iCurrent+17]=this.st_servername
this.Control[iCurrent+18]=this.p_2
this.Control[iCurrent+19]=this.p_3
this.Control[iCurrent+20]=this.dw_userface
this.Control[iCurrent+21]=this.rb_native
this.Control[iCurrent+22]=this.rb_jdbc
this.Control[iCurrent+23]=this.sle_hostname
this.Control[iCurrent+24]=this.st_hostname
this.Control[iCurrent+25]=this.rb_intranet
this.Control[iCurrent+26]=this.rb_extranet
this.Control[iCurrent+27]=this.sle_department_code
this.Control[iCurrent+28]=this.sle_department_name
this.Control[iCurrent+29]=this.dw_1
this.Control[iCurrent+30]=this.st_userid
this.Control[iCurrent+31]=this.st_1
this.Control[iCurrent+32]=this.st_companyname
this.Control[iCurrent+33]=this.pb_1
this.Control[iCurrent+34]=this.p_4
this.Control[iCurrent+35]=this.st_2
this.Control[iCurrent+36]=this.gb_location
this.Control[iCurrent+37]=this.gb_network_driver
this.Control[iCurrent+38]=this.gb_language
this.Control[iCurrent+39]=this.gb_user_information
end on

on w_logon.destroy
call super::destroy
destroy(this.sle_msg)
destroy(this.cbx_autosave)
destroy(this.st_organization)
destroy(this.st_password)
destroy(this.st_username)
destroy(this.rb_english)
destroy(this.rb_chiness)
destroy(this.rb_korean)
destroy(this.ddlb_organization_id)
destroy(this.pb_logon)
destroy(this.pb_exit)
destroy(this.em_version)
destroy(this.sle_user_id)
destroy(this.sle_user_name)
destroy(this.sle_password)
destroy(this.ddlb_database)
destroy(this.st_servername)
destroy(this.p_2)
destroy(this.p_3)
destroy(this.dw_userface)
destroy(this.rb_native)
destroy(this.rb_jdbc)
destroy(this.sle_hostname)
destroy(this.st_hostname)
destroy(this.rb_intranet)
destroy(this.rb_extranet)
destroy(this.sle_department_code)
destroy(this.sle_department_name)
destroy(this.dw_1)
destroy(this.st_userid)
destroy(this.st_1)
destroy(this.st_companyname)
destroy(this.pb_1)
destroy(this.p_4)
destroy(this.st_2)
destroy(this.gb_location)
destroy(this.gb_network_driver)
destroy(this.gb_language)
destroy(this.gb_user_information)
end on

event ue_post_open;SETPOINTER(HOURGLASS!)
INT I , J , LVI_LENGTH
STRING LVS_ORGANIZATION_ID , LVS_MY_LOCATION, LVS_APPNAME

// w_openning_popup.mle_message.text = w_openning_popup.mle_message.text+"Get Location Registry Key"+'=>'
//RegistryGet( "HKEY_LOCAL_MACHINE\Software\Infinity21\JSMES" , "MY_LOCATION", RegString!, LVS_MY_LOCATION)
RegistryGet( "HKEY_LOCAL_MACHINE\Software\Infinity21\" + GVS_APPLICATION_NAME, "MY_LOCATION", RegString!, LVS_MY_LOCATION)
// w_openning_popup.mle_message.text = w_openning_popup.mle_message.text+LVS_MY_LOCATION+'~r~n'
IF LVS_MY_LOCATION = 'INTRANET' THEN 
	 rb_intranet.checked = true
ELSEIF LVS_MY_LOCATION = 'EXTRANET' THEN 
	 rb_extranet.checked = true
ELSE
	 rb_intranet.checked = true	
END IF
 
//================================================
//  Application Information
//================================================

//w_openning_popup.mle_message.text = w_openning_popup.mle_message.text+"Loading Initialize File..."+'=>'
sle_msg.text = "Loading Initialize File..."


IF LVS_MY_LOCATION = 'EXTRANET' THEN
	Gvs_hostname               = Profilestring("SYSTEM.INI","Database","Hostname_extranet","")
else
	Gvs_hostname               = Profilestring("SYSTEM.INI","Database","Hostname","")	
end if

Gvs_app_initial               = Profilestring("SYSTEM.INI","Application","ApplicationInitial","")
Gvs_app_name              = Profilestring("SYSTEM.INI","Application","ApplicationName","")
Gvf_system_version      = Real(Profilestring("VERSION.INI","Database","Version",""))
Gvi_opensheet_position= INTEGER(ProfileString ("SYSTEM.INI", "Application", "OpenSheetPosition", ""))
Gvs_error_log_trace_yn=Profilestring("SYSTEM.INI","Application","Errorlogtrace","") 

sle_hostname.text = Gvs_hostname
//================================================
//  DBMS Driver 
//================================================
sqlca.dbms               = ProfileString ("SYSTEM.INI", "database", "dbms",       "")

if ProfileString ("SYSTEM.INI", "database", "dbms",       "") = 'JDBC' then 
   rb_jdbc.checked = true
   sqlca.dbparm = ProfileString ("SYSTEM.INI", "JDBCDBPARM", "dbparm",     "")		

else
   rb_native.checked = true	
   sqlca.dbparm = ProfileString ("SYSTEM.INI", "NATIVEDBPARM", "dbparm",     "")		
end if

sqlca.logid       = ProfileString ("SYSTEM.INI", "database", "logid",      "")
sqlca.logpass   = f_password_decode(ProfileString ("SYSTEM.INI", "database", "LogPassWord", ""))

//================================================
// $$HEX13$$30aef8bcb8c5b4c5200024c115c812ac20007dc7b4c524c630ae$$ENDHEX$$
//================================================

//RegistryGet( "HKEY_LOCAL_MACHINE\Software\Infinity21\JSMES", "APP_USER_LANGUAGE", RegString!, Gvs_language)
RegistryGet( "HKEY_LOCAL_MACHINE\Software\Infinity21\"+GVS_APPLICATION_NAME, "APP_USER_LANGUAGE", RegString!, Gvs_language)
IF Gvs_language = '' OR ISNULL(Gvs_language) THEN 
	Gvs_language  = ProfileString ("SYSTEM.INI", "database", "DefaultLanguage", "")
END IF

Lvs_organization_id = '1' 
em_version.text            = String(Gvf_system_version)

//================================================================================
// $$HEX28$$70b374c7c0d02000a0bc74c7a4c2200020c1ddd0acb9a4c2b8d2200015bca4c2d0c5200070b374c7c0d02000a0bc74c7a4c2200094cd00ac$$ENDHEX$$
//================================================================================
IF LVS_MY_LOCATION = 'EXTRANET' THEN
	
	ddlb_database.reset()
	ddlb_database.additem( ProfileString ("SYSTEM.INI", "database", "servername_extranet", "") )
	ddlb_database.selectitem(1)
	
ELSE

	ddlb_database.reset()
	ddlb_database.additem( ProfileString ("SYSTEM.INI", "database", "servername", "") )
	ddlb_database.selectitem(1)	
	
END IF

IF LVS_MY_LOCATION = 'EXTRANET' THEN
//================================================================================
sqlca.servername = ProfileString ("SYSTEM.INI", "database", "servername_extranet", "")
//================================================================================

else
//================================================================================
sqlca.servername = ProfileString ("SYSTEM.INI", "database", "servername", "")
//================================================================================	
end if
//================================================================================
// $$HEX4$$b8c5b4c5c0bcbdac$$ENDHEX$$
//================================================================================

//w_openning_popup.mle_message.text = w_openning_popup.mle_message.text+"Language Change"+'~r~n'
WF_LANGUAGE_CHANGE( Gvs_language , LVS_ORGANIZATION_ID )

//w_openning_popup.mle_message.text = w_openning_popup.mle_message.text+"Connect to Database=>"+sqlca.servername+'~r~n'
sle_msg.text  = "Try Connect to Database..."

Gvs_database = ddlb_database.text

Disconnect;
Connect;

//=========================================
// Database Connect error
//=========================================
if sqlca.sqlcode <> 0 then
	Gvi_db_status = 0
//	Close(w_openning_popup)
	
	
     sle_msg.text = "Connection Failed($$HEX4$$11c88dc1e4c228d3$$ENDHEX$$) "+string(sqlca.sqlcode)+' '+sqlca.sqlerrtext	
	MSG = Messagebox("Database Connect Error" , "$$HEX12$$24b1b8d2ccc66cd07cb9200055d678c7200058d538c194c6$$ENDHEX$$"+"Error Code : "+string(sqlca.sqldbcode)+'~r~n'+"Error Number : "+string(sqlca.sqlcode)+'~r~n'+'Error Text :'+sqlca.sqlerrtext +'~r~n'+" Do You wish to System Check ?" , question! , yesno!)
   
	IF MSG = 1 THEN 
		dw_1.event ue_clicked('System Check' )
//		PB_SYSTEM_CHECK.TRIGGEREVENT(CLICKED!)
		return
	ELSE
		return
	END IF
else
	
       Gvi_db_status = 1	
       pb_logon.enabled = true 
       sle_msg.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "CONNECTOK_"+Gvs_language, 'Established')		 
	  
end if

//====================================================================================
// $$HEX21$$acc0a9c690c7200015c8f4bc200008b8c0c9a4c230d1acb92000f1b45db8ecc580bd2000b4cc6cd02000$$ENDHEX$$
//====================================================================================

string LVS_USER_ID , LVS_USER_PASSWORD , LVS_AUTOSAVE

//RegistryGet( "HKEY_LOCAL_MACHINE\Software\Infinity21\JSMES", "APP_USER_ID", RegString!, LVS_USER_ID)
//RegistryGet( "HKEY_LOCAL_MACHINE\Software\Infinity21\JSMES", "APP_USER_PASSWORD", RegString!, LVS_USER_PASSWORD)
//RegistryGet( "HKEY_LOCAL_MACHINE\Software\Infinity21\JSMES", "APP_USER_AUTOSAVE", RegString!, LVS_AUTOSAVE)
RegistryGet( "HKEY_LOCAL_MACHINE\Software\Infinity21\"+GVS_APPLICATION_NAME, "APP_USER_ID", RegString!, LVS_USER_ID)
RegistryGet( "HKEY_LOCAL_MACHINE\Software\Infinity21\"+GVS_APPLICATION_NAME, "APP_USER_PASSWORD", RegString!, LVS_USER_PASSWORD)
RegistryGet( "HKEY_LOCAL_MACHINE\Software\Infinity21\"+GVS_APPLICATION_NAME, "APP_USER_AUTOSAVE", RegString!, LVS_AUTOSAVE)

//MESSAGEBOX(LVS_USER_ID +' '+ LVS_USER_PASSWORD , "HKEY_LOCAL_MACHINE\Software\Infinity21\"+GVS_APPLICATION_NAME ) 
SLE_USER_ID.TEXT = LVS_USER_ID
	
IF LVS_AUTOSAVE = '1' THEN 	
	CBX_AUTOSAVE.CHECKED = TRUE	
	SLE_PASSWORD.TEXT = LVS_USER_PASSWORD
END IF

/*****************************************************/
/* 2018.04.07                                                                                     */
/*****************************************************/
gvs_labeler_path = Profilestring("WORKENV.INI","OTHERAPP","LABELER","")


SLE_USER_ID.TRIGGEREVENT(MODIFIED!)	

//CLOSE(W_OPENNING_POPUP)
end event

event open;long result
f_set_layered_window( handle(this) , 85 )

//
//Speechobject = CREATE OLEObject
//result = Speechobject.ConnectToNewObject('Sapi.SpVoice')
//
//IF result < 0 THEN
//    DESTROY Speechobject
//    MessageBox("Connecting to Speech Object Failed",  "Error: " +String(result))
//   Return
//END IF


//----------------------------------------------------------------
// $$HEX6$$5cd56dadb4c5200024c115c8$$ENDHEX$$
//----------------------------------------------------------------
GVS_LANGUAGE = 'L'

//=====================================
//$$HEX11$$dcc2a4c25cd1200085ba200000ac38c824c630ae2000$$ENDHEX$$2017.02.23
//=====================================
GVS_APPLICATION_NAME = Profilestring("SYSTEM.INI","APPLICATION","APPLICATIONNAME","")


rb_korean.triggerevent(clicked!)
POSTEVENT('UE_POST_OPEN')


end event

type p_title from w_none_dw_popup_root`p_title within w_logon
boolean visible = false
integer y = 2044
integer width = 2551
integer height = 156
end type

type cb_close from w_none_dw_popup_root`cb_close within w_logon
integer x = 2277
integer y = 1940
integer taborder = 0
end type

type st_msg from w_none_dw_popup_root`st_msg within w_logon
integer y = 2212
integer width = 2551
long backcolor = 16777215
end type

type sle_msg from so_singlelineedit within w_logon
integer x = 1097
integer y = 1556
integer width = 2007
integer height = 88
integer weight = 700
long textcolor = 16777215
long backcolor = 0
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cbx_autosave from so_checkbox within w_logon
integer x = 1563
integer y = 1164
integer width = 489
integer weight = 700
long textcolor = 255
long backcolor = 0
string text = "Save Password"
end type

type st_organization from so_statictext within w_logon
integer x = 1115
integer y = 884
integer width = 439
integer height = 64
integer weight = 700
long textcolor = 65535
long backcolor = 0
string text = "Organization :"
alignment alignment = right!
end type

type st_password from so_statictext within w_logon
integer x = 1115
integer y = 792
integer width = 439
integer height = 68
integer weight = 700
long textcolor = 65535
long backcolor = 0
string text = "PassWord :"
alignment alignment = right!
end type

type st_username from so_statictext within w_logon
integer x = 1115
integer y = 696
integer width = 439
integer height = 64
integer weight = 700
long textcolor = 65535
long backcolor = 0
string text = "User Name :"
alignment alignment = right!
end type

type rb_english from so_radiobutton within w_logon
integer x = 2437
integer y = 348
integer width = 407
integer weight = 700
long textcolor = 20392369
long backcolor = 134217732
string text = "English"
end type

event clicked;call super::clicked;STRING LVS_ORGANIZATION_ID
GVS_LANGUAGE = 'E'

LVS_ORGANIZATION_ID = STRING(GVI_ORGANIZATION_ID)
IF ISNULL(GVI_ORGANIZATION_ID) OR GVI_ORGANIZATION_ID = 0 THEN 
	LVS_ORGANIZATION_ID = '1'
END IF
WF_LANGUAGE_CHANGE ( GVS_LANGUAGE , LVS_ORGANIZATION_ID )

end event

type rb_chiness from so_radiobutton within w_logon
integer x = 1797
integer y = 348
integer width = 407
integer weight = 700
long textcolor = 20392369
long backcolor = 134217732
string text = "Local"
end type

event clicked;call super::clicked;STRING LVS_ORGANIZATION_ID
GVS_LANGUAGE = 'C'

LVS_ORGANIZATION_ID = STRING(GVI_ORGANIZATION_ID)
IF ISNULL(GVI_ORGANIZATION_ID) OR GVI_ORGANIZATION_ID = 0 THEN 
	LVS_ORGANIZATION_ID = '1'
END IF

WF_LANGUAGE_CHANGE ( GVS_LANGUAGE , LVS_ORGANIZATION_ID)
end event

type rb_korean from so_radiobutton within w_logon
integer x = 1207
integer y = 348
integer width = 407
integer weight = 700
long textcolor = 20392369
long backcolor = 134217732
string text = "Korean"
boolean checked = true
end type

event clicked;call super::clicked;STRING LVS_ORGANIZATION_ID
GVS_LANGUAGE = 'K'
LVS_ORGANIZATION_ID = STRING(GVI_ORGANIZATION_ID)
IF ISNULL(GVI_ORGANIZATION_ID) OR GVI_ORGANIZATION_ID = 0 THEN 
	LVS_ORGANIZATION_ID = '1'
END IF
WF_LANGUAGE_CHANGE ( GVS_LANGUAGE , LVS_ORGANIZATION_ID )
end event

type ddlb_organization_id from so_dropdownlistbox within w_logon
integer x = 1563
integer y = 876
integer width = 795
integer height = 488
long textcolor = 0
long backcolor = 16777215
borderstyle borderstyle = stylebox!
end type

event selectionchanged;call super::selectionchanged;GVI_ORGANIZATION_ID =INTEGER( mid(THIS.TEXT,1,1) )
end event

type pb_logon from so_pbutton within w_logon
integer x = 2286
integer y = 1336
integer width = 407
integer height = 172
integer taborder = 30
integer textsize = -8
integer weight = 700
string pointer = "HAND.ANI"
boolean enabled = false
string text = "Logon"
boolean default = true
boolean originalsize = false
vtextalign vtextalign = vcenter!
boolean map3dcolors = true
end type

event clicked;call super::clicked;sle_msg.text = "Checking Autority...."
Gvs_user_id           = sle_user_id.text
Gvs_password        = sle_password.text
Gvi_organization_id = long(mid(ddlb_organization_id.text,1,1))

if isnull(gvi_organization_id) or gvi_organization_id = 0 and 'ADMIN' <> Gvs_user_id then 
	f_msgbox( 153)
//   ('Check','Not Found Your Organization Id!')
   return
end if 

//=====================================
// IP $$HEX2$$55d678c7$$ENDHEX$$
//===================================== 
 select SYS_CONTEXT ('USERENV', 'IP_ADDRESS') ,
          SYS_CONTEXT ('USERENV', 'HOST') ,
          SYS_CONTEXT ('USERENV', 'OS_USER') 
   into :Gvs_ip_address,
	     :GVS_COMPUTER_NAME,
		 :GVS_COMPUTER_LOGIN_USER
 from dual;

//========================================
// User Selected Language 
// $$HEX26$$5cb834ae54d674bad0c51cc12000acc0a9c690c700ac200020c1ddd05cd52000b8c5b4c5200024c115c844c7200030b578b9e4b2$$ENDHEX$$.
//========================================
		if  rb_korean.CHECKED = TRUE  THEN          
			Gvs_Language = 'K'
			Gvs_previous_language = Gvs_language
		elseif  rb_chiness.CHECKED = TRUE  THEN 
			Gvs_Language = 'C'			
			Gvs_previous_language = Gvs_language
		elseif 	rb_english.CHECKED = TRUE  THEN
			Gvs_Language = 'E'			
			Gvs_previous_language = Gvs_language
		end if

  Select A.USER_NAME ,
		B.ORGANIZATION_NAME ,	
		B.ORGANIZATION_CODE ,
		A.EMAIL_ADDRESS,
		A.USER_LEVEL ,
		NVL(A.SHOW_UNIT_PRICE ,'Y') ,
		NVL(A.SHOW_SALE_PRICE ,'Y') ,
		NVL(A.SHOW_INVENTORY_PRICE,'Y'),
		NVL(A.DOWNLOAD_DOCUMENT , 'Y')
    into :Gvs_user_name  ,  
	    :Gvs_organization_name ,  
	    :Gvs_organization_code , 
	    :Gvs_email_address , 
	    :Gvi_user_level ,
	    :Gvs_show_unit_price ,
	    :Gvs_show_sale_price	,
	    :Gvs_show_inventory_price ,
	    :Gvs_download_document
   from ISYS_USERS A , ISYS_ORGANIZATION  B
  where A.user_id             = :Gvs_user_id 
	and A.PASSWORD     = :Gvs_password
	and A.ORGANIZATION_ID  = :Gvi_organization_id 
	and A.ORGANIZATION_ID = B.ORGANIZATION_ID;
	
if f_sql_check() < 1 then Return 

if sqlca.sqlcode = 100 then 
	f_msgbox( 118 ) //userid / password invalid
	sle_password.setfocus()
	Return
end if

SELECT DISTINCT MAX(ROLE_CODE) INTO :Gvs_User_Role
   FROM ISYS_PRIVILEGE
WHERE USER_ID = :Gvs_user_id
    AND ORGANIZATION_ID = :Gvi_organization_id ;
	 
if f_sql_check() < 1 then Return 

if Len(Gvs_user_name) = 0 then 
	Gvs_user_name = "Unknown User"
end if

//==============================================
// $$HEX8$$08b8c0c9a4c230d1acb92000f1b45db8$$ENDHEX$$
//==============================================
STRING LVS_REG_PATH , LVS_REG_PATH_WOW

LVS_REG_PATH = "HKEY_LOCAL_MACHINE\Software\Infinity21\"+GVS_APPLICATION_NAME
LVS_REG_PATH_WOW =  "HKEY_LOCAL_MACHINE\Software\WOW6432Node\Infinity21\"+GVS_APPLICATION_NAME

//MESSAGEBOX('A', lvs_reg_path ) 

// if rb_intranet.checked = true then 
//	RegistrySet( "HKEY_LOCAL_MACHINE\Software\Infinity21\JSMES", "MY_LOCATION", RegString!,'INTRANET')
//else
//	RegistrySet( "HKEY_LOCAL_MACHINE\Software\Infinity21\JSMES", "MY_LOCATION", RegString!,'EXTRANET')
//end if
//
//RegistrySet( "HKEY_LOCAL_MACHINE\Software\Infinity21\JSMES", "APP_USER_ID", RegString!, STRING(Gvs_user_id))
//RegistrySet( "HKEY_LOCAL_MACHINE\Software\Infinity21\JSMES", "APP_USER_ORG", RegString!, STRING(Gvi_organization_id))
//RegistrySet( "HKEY_LOCAL_MACHINE\Software\Infinity21\JSMES", "APP_USER_LANGUAGE", RegString!, Gvs_language)	
//	
//IF cbx_autosave.checked = true THEN	
//	RegistrySet( "HKEY_LOCAL_MACHINE\Software\Infinity21\JSMES", "APP_USER_PASSWORD", RegString!, STRING(Gvs_password))	
//	RegistrySet( "HKEY_LOCAL_MACHINE\Software\Infinity21\JSMES", "APP_USER_AUTOSAVE", RegString!, '1')	
//ELSE
//	RegistrySet( "HKEY_LOCAL_MACHINE\Software\Infinity21\JSMES", "APP_USER_AUTOSAVE", RegString!, '0')
//END IF

//2017.02.23 zethani 
if rb_intranet.checked = true then 
	RegistrySet( LVS_REG_PATH, "MY_LOCATION", RegString!,'INTRANET')
else
	RegistrySet( LVS_REG_PATH, "MY_LOCATION", RegString!,'EXTRANET')
end if



if RegistrySet( LVS_REG_PATH, "APP_USER_ID", RegString!, STRING(Gvs_user_id)) <> 1 then 
	MessageBox("$$HEX2$$4cc5bcb9$$ENDHEX$$", "$$HEX11$$08b8c0c9a4c2b8d2acb92000f1b45db82000e4c228d3$$ENDHEX$$2")
	//f_msg("$$HEX11$$08b8c0c9a4c2b8d2acb92000f1b45db82000e4c228d3$$ENDHEX$$2",'P')
	if RegistrySet( LVS_REG_PATH_WOW, "APP_USER_ID", RegString!, STRING(Gvs_user_id)) <> 1 then
	  MessageBox("$$HEX2$$4cc5bcb9$$ENDHEX$$", "$$HEX12$$08b8c0c9a4c2b8d2acb92000f1b45db82000e4c228d32000$$ENDHEX$$WOW64")
	  // f_msg("$$HEX12$$08b8c0c9a4c2b8d2acb92000f1b45db82000e4c228d32000$$ENDHEX$$WOW64",'P')
	end if 
end if

RegistrySet( LVS_REG_PATH, "APP_USER_ORG", RegString!, STRING(Gvi_organization_id))
RegistrySet( LVS_REG_PATH, "APP_USER_LANGUAGE", RegString!, Gvs_language)	
	
IF cbx_autosave.checked = true THEN	
	RegistrySet( LVS_REG_PATH, "APP_USER_PASSWORD", RegString!, STRING(Gvs_password))	
	RegistrySet( LVS_REG_PATH, "APP_USER_AUTOSAVE", RegString!, '1')	
ELSE
	RegistrySet( LVS_REG_PATH, "APP_USER_AUTOSAVE", RegString!, '0')
END IF



//==Version Check==============================
  f_version_check()
//========================================

//==============================================
// $$HEX13$$dcc2a4c25cd1200058d6bdacc0bc18c220007dc724c6e4b484c7$$ENDHEX$$
//==============================================
f_config_setup()

//==============================================
f_system_access( parent.classname() ,  'POPUP WINDOW' , 'LOGON')

//System Runtime Default Directory
	Gvs_default_directory = Getcurrentdirectory()

//===============================================
//  
//===============================================


Open ( w_main_frame)
Close(W_LOGON)		
if Gvs_system_access_yn = 'Y' then 
	f_message_ontime(2, "System Access Monirotring Actived" )
end if

//==============================================
end event

event help;call super::help;Messagebox("Help" , "System Logon")
end event

type pb_exit from so_pbutton within w_logon
integer x = 2697
integer y = 1336
integer width = 407
integer height = 172
integer taborder = 40
integer textsize = -8
integer weight = 700
string text = "Exit"
vtextalign vtextalign = vcenter!
boolean map3dcolors = true
end type

event clicked;call super::clicked;Close(W_LOGON)

end event

type em_version from so_editmask within w_logon
integer x = 2789
integer y = 588
integer width = 210
integer height = 72
boolean bringtotop = true
long textcolor = 65280
long backcolor = 0
string text = "1.0"
boolean border = false
alignment alignment = center!
borderstyle borderstyle = stylebox!
end type

type sle_user_id from so_singlelineedit within w_logon
integer x = 1563
integer y = 588
integer width = 411
integer taborder = 10
boolean bringtotop = true
integer weight = 700
long textcolor = 0
long backcolor = 16777215
textcase textcase = upper!
borderstyle borderstyle = stylebox!
end type

event modified;call super::modified;STRING LS_ORG
LONG   LL_CNT

DDLB_ORGANIZATION_ID.RESET()

SELECT MAX(USER_NAME) , MAX(USER_NAME) , MAX(DEPARTMENT_CODE)
    INTO :SLE_USER_NAME.TEXT , :GVS_USER_NAME , :Gvs_department_code
   FROM ISYS_USERS
 WHERE USER_ID = :this.TEXT ;
 
IF F_SQL_CHECK() < 0 THEN
	RETURN
END IF


DECLARE C_ORG CURSOR FOR
  SELECT TO_CHAR(A.ORGANIZATION_ID)||' : '||B.ORGANIZATION_NAME
    FROM ISYS_USERS A, ISYS_ORGANIZATION B
  WHERE A.ORGANIZATION_ID = B.ORGANIZATION_ID
       AND A.USER_ID         = :THIS.TEXT ;
 
OPEN C_ORG ;
if f_sql_check() < 0 then 
	return
end if 

DO 
	
	FETCH C_ORG INTO :LS_ORG;
	
	IF F_SQL_CHECK() < 0 THEN 
		CLOSE C_ORG ;
		EXIT
	END IF 
	IF SQLCA.SQLCODE = 100 THEN 
		CLOSE C_ORG;
		EXIT
	END IF 
	
	LL_CNT ++
	DDLB_ORGANIZATION_ID.ADDITEM(LS_ORG) 
		
LOOP UNTIL 1 = 2

CLOSE C_ORG ;

DDLB_ORGANIZATION_ID.SELECTITEM(1)

IF LL_CNT < 1 AND 'ADMIN' <> this.TEXT THEN 
       f_msgbox( 118 )
	//('Confirm','User  ID Invalid Please Check User ID and Password')
	THIS.TEXT = ''
	THIS.SETFOCUS()
END IF 

//==========================================
// $$HEX17$$08b8c0c9a4c2b8d2acb9d0c51cc1200000c8a5c71cb4200012ac20007dc7b4c534c6$$ENDHEX$$
//==========================================

STRING LVS_USER_LANGUAGE , LVS_ORGANIZATION_ID , LVS_AUTOSAVE

//RegistryGet( "HKEY_LOCAL_MACHINE\Software\Infinity21\JSMES", "APP_USER_AUTOSAVE", RegString!,  LVS_AUTOSAVE)
//RegistryGet( "HKEY_LOCAL_MACHINE\Software\Infinity21\JSMES", "APP_USER_ORG" ,     RegString!,  LVS_ORGANIZATION_ID)
//RegistryGet( "HKEY_LOCAL_MACHINE\Software\Infinity21\JSMES", "APP_USER_LANGUAGE", RegString!,  LVS_USER_LANGUAGE)

RegistryGet( "HKEY_LOCAL_MACHINE\Software\Infinity21\"+GVS_APPLICATION_NAME, "APP_USER_AUTOSAVE", RegString!,  LVS_AUTOSAVE)
RegistryGet( "HKEY_LOCAL_MACHINE\Software\Infinity21\"+GVS_APPLICATION_NAME, "APP_USER_ORG" ,     RegString!,  LVS_ORGANIZATION_ID)
RegistryGet( "HKEY_LOCAL_MACHINE\Software\Infinity21\"+GVS_APPLICATION_NAME, "APP_USER_LANGUAGE", RegString!,  LVS_USER_LANGUAGE)

IF LVS_AUTOSAVE = '1' THEN 	
	
		DDLB_ORGANIZATION_ID.SELECTITEM( INTEGER(LVS_ORGANIZATION_ID)   )
		
		if LVS_USER_LANGUAGE = 'K' then 
			rb_korean.CHECKED = TRUE 
		elseif LVS_USER_LANGUAGE = 'C' then 
			rb_chiness.CHECKED = TRUE 
		elseif LVS_USER_LANGUAGE = 'E' then
			rb_english.CHECKED = TRUE 
		end if
   	
	WF_LANGUAGE_CHANGE( 	LVS_USER_LANGUAGE , LVS_ORGANIZATION_ID ) 
		
END IF
//============================================	
SLE_PASSWORD.setfocus()

GVS_USER_ID = this.TEXT
Gvi_organization_id = long(mid(ddlb_organization_id.text,1,1))

dw_userface.settransobject(sqlca)
dw_userface.retrieve(GVS_USER_ID , Gvi_organization_id)
dw_userface.bringtotop = true
//=============================================
// Department Code
//=============================================

sle_department_code.text = Gvs_department_code
sle_department_name.text = f_get_department_name(Gvs_department_code)
//=============================================

sle_password.setfocus()

end event

type sle_user_name from so_singlelineedit within w_logon
integer x = 1563
integer y = 688
integer width = 411
boolean bringtotop = true
integer weight = 700
long textcolor = 65535
long backcolor = 19343143
boolean enabled = false
borderstyle borderstyle = stylebox!
end type

type sle_password from so_singlelineedit within w_logon
integer x = 1563
integer y = 784
integer width = 795
integer taborder = 20
boolean bringtotop = true
integer weight = 700
long textcolor = 0
long backcolor = 16777215
boolean password = true
textcase textcase = upper!
borderstyle borderstyle = stylebox!
boolean hideselection = false
end type

event getfocus;call super::getfocus;//Speechobject.speak("$$HEX11$$44be00bc88bc38d67cb9200085c725b858d538c194c6$$ENDHEX$$")
end event

type ddlb_database from so_dropdownlistbox within w_logon
integer x = 1563
integer y = 1052
integer width = 795
boolean bringtotop = true
long textcolor = 0
long backcolor = 16777215
boolean allowedit = true
borderstyle borderstyle = stylebox!
end type

event modified;call super::modified;SETPOINTER(HOURGLASS!)
 
//================================================================================
sqlca.servername = ddlb_database.text
//================================================================================
Gvs_database = ddlb_database.text

Disconnect;
Connect;

//=========================================
// Database Connect error
//=========================================
if sqlca.sqlcode <> 0 then
	Gvi_db_status = 0
     sle_msg.text = "Connection Failed "+string(sqlca.sqlcode)+' '+sqlca.sqlerrtext
	  
	MSG = Messagebox("Database Connect Error" , "Error Code : "+string(sqlca.sqldbcode)+'~r~n'+"Error Number : "+string(sqlca.sqlcode)+'~r~n'+'Error Text :'+sqlca.sqlerrtext +'~r~n'+" Do You wish to System Check ?" , question! , yesno!)
   
	IF MSG = 1 THEN 
		dw_1.event ue_clicked( 'System Check')
//		PB_SYSTEM_CHECK.TRIGGEREVENT(CLICKED!)
		return
	ELSE
		return
	END IF
else
	
       Gvi_db_status = 1	
       pb_logon.enabled = true 
       sle_msg.text = ProfileString ("MESSAGE.INI", "LogonLanguage", "CONNECTOK_"+Gvs_language, 'Established')		 
	  
end if
SetProfileString("SYSTEM.INI", "DATABASE", "SERVERNAME", THIS.TEXT)
end event

type st_servername from so_statictext within w_logon
integer x = 1115
integer y = 1064
integer width = 439
integer height = 64
boolean bringtotop = true
integer weight = 700
long textcolor = 65535
long backcolor = 0
string text = "DB Server Name:"
alignment alignment = right!
end type

type p_2 from picture within w_logon
integer x = 2601
integer y = 1424
integer width = 73
integer height = 64
boolean bringtotop = true
boolean originalsize = true
string picturename = "CreateIndex!"
boolean focusrectangle = false
end type

type p_3 from picture within w_logon
integer x = 3008
integer y = 1424
integer width = 73
integer height = 64
boolean bringtotop = true
boolean originalsize = true
string picturename = "Exit!"
boolean focusrectangle = false
end type

type dw_userface from datawindow within w_logon
integer x = 2427
integer y = 692
integer width = 585
integer height = 448
boolean bringtotop = true
string title = "none"
string dataobject = "d_userface_image"
boolean livescroll = true
end type

type rb_native from radiobutton within w_logon
integer x = 96
integer y = 1816
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Native Drive"
boolean checked = true
end type

type rb_jdbc from radiobutton within w_logon
integer x = 96
integer y = 1920
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "JDBC Drive"
end type

type sle_hostname from so_singlelineedit within w_logon
integer x = 1655
integer y = 1800
integer width = 489
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
end type

type st_hostname from so_statictext within w_logon
integer x = 1207
integer y = 1800
integer width = 439
boolean bringtotop = true
integer weight = 700
long textcolor = 0
long backcolor = 16777215
string text = "Host Name:"
alignment alignment = right!
end type

type rb_intranet from radiobutton within w_logon
integer x = 709
integer y = 1816
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "Intranet"
boolean checked = true
end type

type rb_extranet from radiobutton within w_logon
integer x = 704
integer y = 1920
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "Extranet"
end type

type sle_department_code from so_singlelineedit within w_logon
integer x = 1984
integer y = 588
integer width = 375
boolean bringtotop = true
integer weight = 700
long textcolor = 65535
long backcolor = 19343143
boolean enabled = false
borderstyle borderstyle = stylebox!
end type

type sle_department_name from so_singlelineedit within w_logon
integer x = 1984
integer y = 688
integer width = 375
boolean bringtotop = true
integer weight = 700
long textcolor = 65535
long backcolor = 19343143
boolean enabled = false
borderstyle borderstyle = stylebox!
end type

type dw_1 from u_dw_xplistbar within w_logon
integer x = 14
integer y = 8
integer width = 1010
integer height = 1644
boolean bringtotop = true
borderstyle borderstyle = styleraised!
end type

event ue_clicked;call super::ue_clicked;//======================================
// $$HEX6$$08c7c4b3b0c6200068d5c4d6$$ENDHEX$$
// wf_language_change $$HEX9$$d0c51cc1200044c574c75cd12000ddc031c1$$ENDHEX$$
//======================================

choose case as_text 
		
case lvs_sql_net
	
	openwithparm( w_profile_edit_window ,'SQLNET' )
	if  message.stringparm = 'Y' then 
	    Parent.triggerevent( open! ) 
	end if 

case lvs_password
	  OPEN(W_PASSCHANGE)
case lvs_profile_edit

	openwithparm( w_profile_edit_window, 'PROFILE' )
	if  message.stringparm = 'Y' then 
		Parent.triggerevent( open! ) 
	end if 

case  lvs_system_check
	
			Constant long NETWORK_ALIVE_AOL = 4
			Constant long NETWORK_ALIVE_ADSL = 3
			Constant long NETWORK_ALIVE_LAN = 1
			Constant long NETWORK_ALIVE_WAN = 2
			
			Setpointer(hourglass!)
			Long Ret , lvl_return
			String sKind , lvs_db_error_text , LVS_APP_PATH , Lvs_app_path_status , LVs_tns_admin , Lvs_tns_status
			
			F_MESSAGE_ONTIME( 0 , "Please Wait for System Check")
			
			f_message_ontime_set_msg( '1) Application Path Checking...' )
			
			lvl_return = RegistryGet( "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\infinity21_jslcd.exe", "PATH", RegString!, LVS_APP_PATH)
			if lvl_return < 0 then 
			   Lvs_app_path_status = "Application Path "+LVS_APP_PATH+" Registry Invalid"	
			else
			   Lvs_app_path_status = "Application Path Registry Valid =>"+LVS_APP_PATH
			end if
			
			f_message_ontime_set_msg( '2) Database TNS Registry Checking...' )
			
			lvl_return = RegistryGet( "HKEY_LOCAL_MACHINE\Software\ORACLE", "TNS_ADMIN", RegString!, LVs_tns_admin )
			if lvl_return < 0 then 
			   Lvs_tns_status = "Database TNS "+LVs_tns_admin+" Registry Invalid"	
			else
			   Lvs_tns_status = "DatabaseTNS Registry Valid =>"+LVs_tns_admin	
			end if
			
			CLOSE(W_MESSAGE_ONTIME)
			MessageBox ("Destination : "+gvs_hostname+" Return Code : "+string(Gst_qocinfo.dwflag),+&
									"Application Path : "+Lvs_app_path_status+'~r~n'+&				
									"Database TNS : "+Lvs_tns_status+'~r~n~r~n'+&									
									"This local system IP Address : "+GVS_IP_ADDRESS+'~r~n'+&
									"This local system Name : "+GVS_COMPUTER_NAME+'~r~n'+'~r~n')					


//===================================================
case lvs_download

	boolean lb_exist
	lb_exist = FileExists('Infinity21_Loader.exe')
	IF lb_exist  = false THEN 
		MessageBox("Run",  "System Upgrade Loader not found Please Check File Exists : " + 'Infinity21_Loader.exe',stopsign!)
		Return
	ELSE
		RUN('Infinity21_Loader.exe system.ini') 		
		Halt Close 
	END IF	


//===================================================	
case lvs_hardware
	
	        Run('devmgmt.msc')
	
case lvs_printing
	
		PRINTSETUP()
	
case lvs_network
			F_MESSAGE_ONTIME( 0 , "Please Wait for System Check")
	      			f_message_ontime_set_msg( '3) Network Status Checking...' )
			If IsNetworkAlive(Ret) = 0 Then
				 CLOSE(W_MESSAGE_ONTIME)	
				MessageBox ("Network Status","Application Path : "+Lvs_app_path_status+'~r~n'+&
														"Database TNS : "+Lvs_tns_status+'~r~n~r~n'+&
																  "This local system IP Address : "+GVS_IP_ADDRESS+'~r~n'+&
																   "This local system Name : "+GVS_COMPUTER_NAME+'~r~n'+'~r~n'+&
																   "The local system is not connected to a network!"+"~r~n"+"$$HEX24$$74c7dcc2a4c25cd140c7200024b1b8d2ccc66cd0d0c52000f0c5b0ac18b4b4c5200088c7c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$!"+'~r~n'+&
																   "Check you Network , Lan Card , Network Cable ..."+"~r~n"+"$$HEX28$$24b1b8d2ccc66cd020000fbc20009cb774cedcb420009cb700cf74c714be2000f0c5b0ac2000c1c0dcd07cb9200055d678c758d538c194c6$$ENDHEX$$"+'~r~n')
				Return
			Else
					Choose Case Ret
					Case NETWORK_ALIVE_AOL
							sKind = 'AOL'
					Case NETWORK_ALIVE_LAN
							sKind = 'LAN'
					Case NETWORK_ALIVE_WAN
							sKind = 'WAN'
					Case NETWORK_ALIVE_ADSL
							sKind = 'ADSL'				
					Case else
							sKind = String(Ret)
					End Choose 
			end if 
			
			f_message_ontime_set_msg( '4) Network Destination '+gvs_hostname+' Checking...' )
			
			lvl_return = IsDestinationReachableA( gvs_hostname , Gst_qocinfo ) 
			 if lvl_return = 0 then 
				 CLOSE(W_MESSAGE_ONTIME)	
				MessageBox ("Destination : "+gvs_hostname+" Return Code : "+string(Gst_qocinfo.dwflag),+&													 								 
													  "This local system IP Address : "+GVS_IP_ADDRESS+'~r~n'+&
															   "This local system Name : "+GVS_COMPUTER_NAME+'~r~n'+'~r~n'+&
															   "The destination cannot be reached! (Cause Host down or Host Name Invalid )"+"~r~n"+"$$HEX16$$a9ba01c8c0c9d0c52000f0c5b0ac18b4c0c920004ac558c5b5c2c8b2e4b22000$$ENDHEX$$($$HEX34$$d0c678c740c720001cc184bc00ac2000bcae38c8200088c770ac98b020001cc184bc74c784b974c7200098c7bbba200018b4c8c544c7200018c2200088c7b5c2c8b2e4b2$$ENDHEX$$"+'~r~n'+&
															   "Check host name or host network or host power status ..."+"~r~n"+"$$HEX40$$a9ba01c8c0c920001cc184bc74c784b9200010b694b220001cc184bc58c7200024b1b8d2ccc66cd0200010b694b220001cc184bc58c7200004c8d0c62000c1c0dcd07cb92000b4cc6cd058d538c194c6$$ENDHEX$$"+'~r~n'+"~r~n")	
				RETURN
			else
			
				f_message_ontime_set_msg( '5) Database Status Checking...' )
				 if f_check_database_status() < 1 then 
						
						if Gvs_language = 'E' THEN
						
								 lvs_db_error_text = ProfileString ("MESSAGE.INI", "DATABASE", "EDB_"+STRING(SQLCA.SQLDBCODE), SQLCA.SQLERRTEXT )
						
						elseif Gvs_language = 'K' THEN
								 lvs_db_error_text = ProfileString ("MESSAGE.INI", "DATABASE", "KDB_"+STRING(SQLCA.SQLDBCODE), SQLCA.SQLERRTEXT )
								 
						elseif Gvs_language = 'C' THEN
								 lvs_db_error_text = ProfileString ("MESSAGE.INI", "DATABASE", "CDB_"+STRING(SQLCA.SQLDBCODE), SQLCA.SQLERRTEXT )
						end if 
						
						CLOSE(W_MESSAGE_ONTIME)
						MessageBox ("Destination : "+gvs_hostname+" Return Code : "+string(Gst_qocinfo.dwflag),+&																	
												"This local system IP Address : "+GVS_IP_ADDRESS+'~r~n'+&
												"This local system Name : "+GVS_COMPUTER_NAME+'~r~n'+'~r~n'+&
												"The local system is connected to a "+ sKind + " network!"+'~r~n'+"$$HEX6$$74c7dcc2a4c25cd140c72000$$ENDHEX$$"+sKind+" $$HEX11$$d0c52000f0c5b0ac18b4b4c5200088c7b5c2c8b2e4b2$$ENDHEX$$"+"~r~n" +"~r~n" +&
												gvs_hostname+" The destination can be reached!" + '~r~n' + &
												gvs_hostname+" $$HEX12$$a9ba01c8c0c9d0c52000f0c5b0ac18b4c8c5b5c2c8b2e4b2$$ENDHEX$$!" + '~r~n' + '~r~n' +&
												"The speed of data coming in from the destination is " + string(Gst_qocinfo.dwInSpeed / 1024 , '##,###.0') + " Kb/s," + '~r~n' +&
												"and the speed of data sent to the destination is " + string(Gst_qocinfo.dwOutSpeed / 1024 , '##,###.0') + " Kb/s."+'~r~n'+'~r~n'+&
												"Database Status Error"+'~r~n'+&
												"$$HEX16$$70b374c7c0d0a0bc74c7a4c2d0c5200038bb1cc800ac200088c7b5c2c8b2e4b2$$ENDHEX$$"+'~r~n'+'~r~n'+&
												"DB Server name : "+sqlca.servername+' '+  lvs_db_error_text	)
				 else
					
						CLOSE(W_MESSAGE_ONTIME)
						MessageBox ("Destination : "+gvs_hostname+" Return Code : "+string(Gst_qocinfo.dwflag),+&																	
												"This local system IP Address : "+GVS_IP_ADDRESS+'~r~n'+&
												"This local system Name : "+GVS_COMPUTER_NAME+'~r~n'+'~r~n'+&
												"The local system is connected to a "+ sKind + " network!"+'~r~n'+"$$HEX6$$74c7dcc2a4c25cd140c72000$$ENDHEX$$"+sKind+" $$HEX11$$d0c52000f0c5b0ac18b4b4c5200088c7b5c2c8b2e4b2$$ENDHEX$$"+"~r~n" +"~r~n" +&
												gvs_hostname+" The destination can be reached!" + '~r~n' + &
												gvs_hostname+" $$HEX12$$a9ba01c8c0c9d0c52000f0c5b0ac18b4c8c5b5c2c8b2e4b2$$ENDHEX$$!" + '~r~n' + '~r~n' +&
												"The speed of data coming in from the destination is " + string(Gst_qocinfo.dwInSpeed / 1024 , '##,###.0') + " Kb/s," + '~r~n' +&
												"and the speed of data sent to the destination is " + string(Gst_qocinfo.dwOutSpeed / 1024 , '##,###.0') + " Kb/s."+'~r~n'+'~r~n'+&
												"Database Status OK"+'~r~n'+&
												"$$HEX22$$70b374c7c0d0a0bc74c7a4c2200000ac200015c8c1c001c83cc75cb8200091c7d9b3200011c985c7c8b2e4b2$$ENDHEX$$")		
				end if
			
			end if
	
case lvs_internal
	
		msg = Messagebox("Notify" , "Infinty21 ERP application will be restart" , Question!, yesno!) //$$HEX21$$04d55cb8f8ada8b744c7200085c8ccb858d5e0ac2000e4b2dcc22000dcc291c7200060d54cae94c62000$$ENDHEX$$?
		if msg = 1 then 
		RegistrySet( "HKEY_LOCAL_MACHINE\Software\Infinity21\" + GVS_APPLICATION_NAME, "MY_LOCATION", RegString!,'INTRANET')
		Gvs_hostname       = Profilestring("SYSTEM.INI","Database","Hostname","")
		sle_hostname.text = Gvs_hostname	
		ddlb_database.reset()
		ddlb_database.additem( ProfileString ("SYSTEM.INI", "database", "servername", "") )
		ddlb_database.selectitem(1)
		Restart()
		end if 

case lvs_external
	
		MSG = Messagebox("Notify" , "Infinty21 ERP application will be restart" ) //$$HEX21$$04d55cb8f8ada8b744c7200085c8ccb858d5e0ac2000e4b2dcc22000dcc291c7200060d54cae94c62000$$ENDHEX$$?
		if msg = 1 then 		
		RegistrySet( "HKEY_LOCAL_MACHINE\Software\Infinity21\" + GVS_APPLICATION_NAME, "MY_LOCATION", RegString!,'EXTRANET')
		Gvs_hostname               = Profilestring("SYSTEM.INI","Database","Hostname_extranet","")
		sle_hostname.text = Gvs_hostname
		ddlb_database.reset()
		ddlb_database.additem( ProfileString ("SYSTEM.INI", "database", "servername_extranet", "") )
		ddlb_database.selectitem(1)
		Restart()
		end if 
		
case lvs_remote_control
	
		Run('C:\Program Files\CrossLoop\CrossLoopConnect.exe -ap=crossloop -port=5910 -udp=www.CrossLoop.com -webserver=server.crossloop.com -webservice=www.crossloop.com -startup=client')
		
end choose 


end event

type st_userid from so_statictext within w_logon
integer x = 1115
integer y = 588
integer width = 439
boolean bringtotop = true
integer weight = 700
long textcolor = 65535
long backcolor = 0
string text = "User ID :"
alignment alignment = right!
end type

type st_1 from so_statictext within w_logon
integer x = 2382
integer y = 592
integer width = 370
integer height = 68
boolean bringtotop = true
integer weight = 700
long textcolor = 65280
long backcolor = 0
string text = "Version :"
alignment alignment = right!
end type

type st_companyname from so_statictext within w_logon
integer x = 1097
integer y = 96
integer width = 1989
integer height = 152
boolean bringtotop = true
integer textsize = -20
integer weight = 700
long textcolor = 65280
long backcolor = 0
string text = "Infinity21 JSMES"
end type

type pb_1 from so_pbutton within w_logon
integer x = 1874
integer y = 1336
integer width = 407
integer height = 172
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
string pointer = "HAND.ANI"
string text = "Network"
boolean default = true
boolean originalsize = false
vtextalign vtextalign = vcenter!
boolean map3dcolors = true
end type

event clicked;call super::clicked;open(w_set_network)
end event

type p_4 from picture within w_logon
integer x = 2190
integer y = 1424
integer width = 73
integer height = 64
boolean bringtotop = true
boolean originalsize = true
string picturename = "Regenerate!"
boolean focusrectangle = false
end type

type st_2 from statictext within w_logon
integer x = 1115
integer y = 1396
integer width = 571
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 134217732
string text = "Ver 2025-11-21  v1.0"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_location from so_groupbox within w_logon
integer x = 603
integer y = 1752
integer width = 562
integer height = 268
integer weight = 700
long backcolor = 16777215
string text = "My Location"
end type

type gb_network_driver from so_groupbox within w_logon
integer x = 9
integer y = 1736
integer width = 585
integer height = 296
integer weight = 700
long backcolor = 16777215
string text = "Network Driver"
end type

type gb_language from so_groupbox within w_logon
integer x = 1088
integer y = 288
integer width = 2002
integer height = 192
long textcolor = 16777215
long backcolor = 134217732
end type

type gb_user_information from so_groupbox within w_logon
integer x = 1088
integer y = 504
integer width = 2002
integer height = 792
long textcolor = 16777215
long backcolor = 0
end type

type cb_sort from w_popup_root`cb_sort within w_logon
integer x = 1993
integer y = 0
integer taborder = 60
end type

type dw_2 from w_popup_root`dw_2 within w_logon
integer width = 293
integer height = 100
integer taborder = 90
end type

