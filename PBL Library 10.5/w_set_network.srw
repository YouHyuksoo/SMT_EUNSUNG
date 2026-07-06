HA$PBExportHeader$w_set_network.srw
$PBExportComments$Datawindow Margin Setup
forward
global type w_set_network from w_none_dw_popup_root
end type
type sle_extranet_alias from so_singlelineedit within w_set_network
end type
type sle_internal_ip from so_singlelineedit within w_set_network
end type
type sle_sid from so_singlelineedit within w_set_network
end type
type sle_port from so_singlelineedit within w_set_network
end type
type st_1 from so_statictext within w_set_network
end type
type st_2 from so_statictext within w_set_network
end type
type st_3 from so_statictext within w_set_network
end type
type st_4 from so_statictext within w_set_network
end type
type cb_1 from so_commandbutton within w_set_network
end type
type sle_internal_alias from so_singlelineedit within w_set_network
end type
type st_5 from so_statictext within w_set_network
end type
type sle_tns_admin from so_singlelineedit within w_set_network
end type
type st_6 from so_statictext within w_set_network
end type
type st_7 from so_statictext within w_set_network
end type
type sle_extranet_ip from so_singlelineedit within w_set_network
end type
type sle_dbms from so_singlelineedit within w_set_network
end type
type st_8 from so_statictext within w_set_network
end type
type sle_ftp_pass from so_singlelineedit within w_set_network
end type
type st_9 from so_statictext within w_set_network
end type
type cb_2 from so_commandbutton within w_set_network
end type
end forward

global type w_set_network from w_none_dw_popup_root
integer width = 1842
integer height = 1500
sle_extranet_alias sle_extranet_alias
sle_internal_ip sle_internal_ip
sle_sid sle_sid
sle_port sle_port
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
cb_1 cb_1
sle_internal_alias sle_internal_alias
st_5 st_5
sle_tns_admin sle_tns_admin
st_6 st_6
st_7 st_7
sle_extranet_ip sle_extranet_ip
sle_dbms sle_dbms
st_8 st_8
sle_ftp_pass sle_ftp_pass
st_9 st_9
cb_2 cb_2
end type
global w_set_network w_set_network

on w_set_network.create
int iCurrent
call super::create
this.sle_extranet_alias=create sle_extranet_alias
this.sle_internal_ip=create sle_internal_ip
this.sle_sid=create sle_sid
this.sle_port=create sle_port
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.cb_1=create cb_1
this.sle_internal_alias=create sle_internal_alias
this.st_5=create st_5
this.sle_tns_admin=create sle_tns_admin
this.st_6=create st_6
this.st_7=create st_7
this.sle_extranet_ip=create sle_extranet_ip
this.sle_dbms=create sle_dbms
this.st_8=create st_8
this.sle_ftp_pass=create sle_ftp_pass
this.st_9=create st_9
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_extranet_alias
this.Control[iCurrent+2]=this.sle_internal_ip
this.Control[iCurrent+3]=this.sle_sid
this.Control[iCurrent+4]=this.sle_port
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.sle_internal_alias
this.Control[iCurrent+11]=this.st_5
this.Control[iCurrent+12]=this.sle_tns_admin
this.Control[iCurrent+13]=this.st_6
this.Control[iCurrent+14]=this.st_7
this.Control[iCurrent+15]=this.sle_extranet_ip
this.Control[iCurrent+16]=this.sle_dbms
this.Control[iCurrent+17]=this.st_8
this.Control[iCurrent+18]=this.sle_ftp_pass
this.Control[iCurrent+19]=this.st_9
this.Control[iCurrent+20]=this.cb_2
end on

on w_set_network.destroy
call super::destroy
destroy(this.sle_extranet_alias)
destroy(this.sle_internal_ip)
destroy(this.sle_sid)
destroy(this.sle_port)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.cb_1)
destroy(this.sle_internal_alias)
destroy(this.st_5)
destroy(this.sle_tns_admin)
destroy(this.st_6)
destroy(this.st_7)
destroy(this.sle_extranet_ip)
destroy(this.sle_dbms)
destroy(this.st_8)
destroy(this.sle_ftp_pass)
destroy(this.st_9)
destroy(this.cb_2)
end on

event open;//override

RegistryGet( "HKEY_LOCAL_MACHINE\Software\ORACLE", "TNS_ADMIN", RegString!, sle_tns_admin.text )
end event

type p_title from w_none_dw_popup_root`p_title within w_set_network
integer width = 1833
end type

type cb_close from w_none_dw_popup_root`cb_close within w_set_network
boolean visible = true
integer x = 1225
integer y = 1260
integer width = 416
integer taborder = 100
integer weight = 400
end type

type st_msg from w_none_dw_popup_root`st_msg within w_set_network
boolean visible = true
integer y = 200
integer width = 1833
end type

type sle_extranet_alias from so_singlelineedit within w_set_network
integer x = 722
integer y = 660
integer width = 626
integer taborder = 30
boolean bringtotop = true
textcase textcase = upper!
end type

type sle_internal_ip from so_singlelineedit within w_set_network
integer x = 722
integer y = 752
integer width = 626
integer taborder = 40
boolean bringtotop = true
textcase textcase = upper!
end type

type sle_sid from so_singlelineedit within w_set_network
integer x = 722
integer y = 928
integer width = 626
integer taborder = 60
boolean bringtotop = true
textcase textcase = upper!
end type

type sle_port from so_singlelineedit within w_set_network
integer x = 722
integer y = 1024
integer width = 626
integer taborder = 70
boolean bringtotop = true
string text = "1521"
textcase textcase = upper!
end type

type st_1 from so_statictext within w_set_network
integer x = 165
integer y = 660
integer width = 503
boolean bringtotop = true
string text = "Connect Alias External"
alignment alignment = right!
end type

type st_2 from so_statictext within w_set_network
integer x = 165
integer y = 756
boolean bringtotop = true
string text = "IP Address Internal"
alignment alignment = right!
end type

type st_3 from so_statictext within w_set_network
integer x = 165
integer y = 928
boolean bringtotop = true
string text = "Database"
alignment alignment = right!
end type

type st_4 from so_statictext within w_set_network
integer x = 165
integer y = 1024
boolean bringtotop = true
string text = "Database Port"
alignment alignment = right!
end type

type cb_1 from so_commandbutton within w_set_network
integer x = 375
integer y = 1260
integer width = 416
integer height = 100
integer taborder = 90
boolean bringtotop = true
integer weight = 400
string text = "Apply System.ini"
end type

event clicked;call super::clicked;if SLE_DBMS.TEXT = '' then 
else
	SetProfileString("SYSTEM.INI", "DATABASE", "DBMS", SLE_DBMS.TEXT)
end if 
if sle_internal_alias.text = '' then 
else
	SetProfileString("SYSTEM.INI", "DATABASE", "SERVERNAME", sle_internal_alias.TEXT)
end if 

if sle_EXTRANET_alias.text = '' then 
else
	SetProfileString("SYSTEM.INI", "DATABASE", "SERVERNAME_EXTRANET", sle_EXTRANET_alias.TEXT)
end if 

if sle_internal_ip.text = '' then 
else
	SetProfileString("SYSTEM.INI", "DATABASE", "HOSTNAME", sle_internal_ip.TEXT)
end if 

if sle_internal_ip.text = '' then 
else
	SetProfileString("SYSTEM.INI", "DATABASE", "FTP_HOST", sle_internal_ip.TEXT)
end if 

if sle_EXTRANET_ip.text = '' then 
else
	SetProfileString("SYSTEM.INI", "DATABASE", "HOSTNAME_EXTRANET", sle_EXTRANET_ip.TEXT)
end if 

if sle_EXTRANET_ip.text = '' then 
else
	SetProfileString("SYSTEM.INI", "DATABASE", "FTP_HOST_EXTRANET", sle_extranet_ip.TEXT)
end if 


SetProfileString("SYSTEM.INI", "DATABASE", "DATABASE", sle_sid.TEXT)

SetProfileString("SYSTEM.INI", "DATABASE", "FTP_DIRECTORY", sle_ftp_pass.TEXT)

end event

type sle_internal_alias from so_singlelineedit within w_set_network
integer x = 722
integer y = 572
integer width = 626
integer taborder = 20
boolean bringtotop = true
textcase textcase = upper!
end type

type st_5 from so_statictext within w_set_network
integer x = 165
integer y = 572
boolean bringtotop = true
string text = "Connect Alias Internal"
alignment alignment = right!
end type

type sle_tns_admin from so_singlelineedit within w_set_network
integer y = 364
integer width = 1833
boolean bringtotop = true
end type

type st_6 from so_statictext within w_set_network
integer x = 9
integer y = 292
integer height = 68
boolean bringtotop = true
string text = "Tns Admin"
alignment alignment = left!
end type

type st_7 from so_statictext within w_set_network
integer x = 165
integer y = 840
boolean bringtotop = true
string text = "IP Address External"
alignment alignment = right!
end type

type sle_extranet_ip from so_singlelineedit within w_set_network
integer x = 722
integer y = 840
integer width = 626
integer taborder = 50
boolean bringtotop = true
textcase textcase = upper!
end type

type sle_dbms from so_singlelineedit within w_set_network
integer x = 727
integer y = 480
integer width = 626
integer taborder = 10
boolean bringtotop = true
textcase textcase = upper!
end type

type st_8 from so_statictext within w_set_network
integer x = 165
integer y = 484
boolean bringtotop = true
string text = "Database"
alignment alignment = right!
end type

type sle_ftp_pass from so_singlelineedit within w_set_network
integer x = 722
integer y = 1116
integer width = 1015
integer taborder = 80
boolean bringtotop = true
string text = "/infinity21_upgrade_center/JSLCD"
textcase textcase = upper!
end type

type st_9 from so_statictext within w_set_network
integer x = 165
integer y = 1120
boolean bringtotop = true
string text = "FTP Root"
alignment alignment = right!
end type

type cb_2 from so_commandbutton within w_set_network
integer x = 800
integer y = 1260
integer width = 416
integer height = 100
integer taborder = 100
boolean bringtotop = true
integer weight = 400
string text = "Tns Generate"
end type

event clicked;call super::clicked;string lvs_text
integer li_FileNum

lvs_text =    sle_internal_alias.text+"="+"~r~n"+" (DESCRIPTION ="+"~r~n"+"    (ADDRESS_LIST ="+"~r~n"+"      (ADDRESS = (PROTOCOL = TCP)(HOST = "+sle_internal_ip.text+")(PORT = 1521))"+"~r~n"+"    )"+"~r~n"+"    (CONNECT_DATA ="+"~r~n"+"      (SERVICE_NAME = "+sle_sid.text+")"+"~r~n"+"    )"+"~r~n"+"  )"+"~r~n"+sle_extranet_alias.text+"="+"~r~n"+"  (DESCRIPTION ="+"~r~n"+"    (ADDRESS_LIST ="+"~r~n"+"      (ADDRESS = (PROTOCOL = TCP)(HOST = "+sle_extranet_ip.text+")(PORT = "+sle_port.text+"))"+"~r~n"+"    )"+"~r~n"+"    (CONNECT_DATA ="+"~r~n"+"      (SERVICE_NAME = "+sle_sid.text+")"+"~r~n"+"    )"+"~r~n"+"  )"
li_FileNum = FileOpen(sle_tns_admin.text+"\tnsname.ora", LineMode!, Write!, LockWrite!, Replace!)
FileWrite(li_FileNum, lvs_text)
FileClose(li_FileNum)
end event

