HA$PBExportHeader$w_profile_edit_window.srw
$PBExportComments$$$HEX9$$04d55cb80cd37cc718c215c808c7c4b3b0c6$$ENDHEX$$
forward
global type w_profile_edit_window from window
end type
type sle_msg from so_singlelineedit within w_profile_edit_window
end type
type cb_3 from commandbutton within w_profile_edit_window
end type
type cb_savefile from commandbutton within w_profile_edit_window
end type
type cb_1 from commandbutton within w_profile_edit_window
end type
type mle_1 from multilineedit within w_profile_edit_window
end type
end forward

global type w_profile_edit_window from window
integer x = 827
integer y = 576
integer width = 2990
integer height = 2100
boolean titlebar = true
string title = "Profile Edit Window"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 16777215
boolean center = true
sle_msg sle_msg
cb_3 cb_3
cb_savefile cb_savefile
cb_1 cb_1
mle_1 mle_1
end type
global w_profile_edit_window w_profile_edit_window

type variables
int   li_fileid
string is_filename, is_fullname , ls_return = 'N'
end variables

on w_profile_edit_window.create
this.sle_msg=create sle_msg
this.cb_3=create cb_3
this.cb_savefile=create cb_savefile
this.cb_1=create cb_1
this.mle_1=create mle_1
this.Control[]={this.sle_msg,&
this.cb_3,&
this.cb_savefile,&
this.cb_1,&
this.mle_1}
end on

on w_profile_edit_window.destroy
destroy(this.sle_msg)
destroy(this.cb_3)
destroy(this.cb_savefile)
destroy(this.cb_1)
destroy(this.mle_1)
end on

event open;mle_1.setfocus()
end event

type sle_msg from so_singlelineedit within w_profile_edit_window
integer y = 1936
integer width = 2976
integer taborder = 50
end type

type cb_3 from commandbutton within w_profile_edit_window
integer x = 2569
integer y = 1788
integer width = 402
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Close"
end type

event clicked;if ls_return = 'N'  then  //$$HEX8$$c0bcbdac74c72000c6c53cc774ba2000$$ENDHEX$$
	
	Closewithreturn(parent ,  ls_return )
else
	
	if ls_return = 'Y'  then  //$$HEX8$$18c215c8ccb9200018b4c8c53cc774ba$$ENDHEX$$
		
				msg = Messagebox("Nofity" , is_fullname+" Was Changed Do You Wish To Save ?" , stopsign! , yesnocancel!)
			
				if Msg = 1 then 
					
					cb_savefile.Triggerevent(clicked!)
					Closewithreturn(parent ,'Y' )
					
				elseif Msg = 2 then 
					
					Closewithreturn(parent , 'N' )
					
				else
					
					  Return	
					  
				end if
		
		
	else //$$HEX14$$18c215c8c4d6200000c8a5c72000c4b3200018b4c8c53cc774ba2000$$ENDHEX$$
		
		Closewithreturn(parent ,'Y' )		
		
	end if
	
end if
end event

type cb_savefile from commandbutton within w_profile_edit_window
integer x = 434
integer y = 1788
integer width = 402
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Save Profile"
end type

event clicked;Long lvl_length

li_fileid = FileOpen(is_fullname, TextMode!, Write!, LockWrite!, Replace!)
lvl_length = FileWriteEx(li_fileid,  mle_1.text)
FileClose(li_fileid)

sle_msg.text = "File Writed Byte="+string(lvl_length)
ls_return = 'S'


end event

type cb_1 from commandbutton within w_profile_edit_window
integer x = 27
integer y = 1788
integer width = 402
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Open Profile"
end type

event clicked;if message.stringparm = 'PROFILE' then

	if GetFileOpenName ("Open", is_fullname, is_filename, "ini", "INI Files (*.txt),*.ini", getcurrentdirectory(), 18) < 1 then return
	
	li_fileid = FileOpen(is_fullname, Textmode!, Read!, LockRead!)
	FileReadEx (li_fileid, mle_1.text)
	sle_msg.text = "File Opened Byte="+string(li_fileid)
	FileClose(li_fileid)
else
	
string ls_path

       RegistryGet( "HKEY_LOCAL_MACHINE\Software\ORACLE", "NLS_LANG", RegString!, ls_path)	
	   
	 Messagebox("Notify" ,   ls_path ) 
	
	if GetFileOpenName ("Open", is_fullname, is_filename, "ora", "ORA Files (*.ora),tnsnames.ora", ls_path, 18) < 1 then return
	
	li_fileid = FileOpen(is_fullname, Textmode!, Read!, LockRead!)
	FileReadEx (li_fileid, mle_1.text)
	sle_msg.text = "File Opened Byte="+string(li_fileid)
	FileClose(li_fileid)	
	
end if

end event

type mle_1 from multilineedit within w_profile_edit_window
integer x = 23
integer y = 16
integer width = 2953
integer height = 1744
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean hscrollbar = true
boolean vscrollbar = true
boolean autohscroll = true
boolean autovscroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;this.text = message.stringParm
end event

event modified;ls_return = 'Y'
end event

