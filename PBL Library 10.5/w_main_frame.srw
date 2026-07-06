HA$PBExportHeader$w_main_frame.srw
$PBExportComments$Main Frame Window
forward
global type w_main_frame from window
end type
type mdi_1 from mdiclient within w_main_frame
end type
end forward

global type w_main_frame from window
integer width = 4718
integer height = 2880
boolean titlebar = true
string menuname = "m_main_frame_menu"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowtype windowtype = mdihelp!
windowstate windowstate = maximized!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_post_open ( )
event ue_move pbm_move
mdi_1 mdi_1
end type
global w_main_frame w_main_frame

event ue_post_open();/**********************************************************
* $$HEX15$$58d6bdac24c115c8c0bc18c2200008cd30ae54d668d518c2200038d69ccd$$ENDHEX$$
*
**********************************************************/
IF F_CONFIG_SETUP() < 0 THEN 
	f_msgbox(138)
END IF


/*********************************************************
* $$HEX19$$e4b26dadb4c5200098ccacb97cb9200004c75cd5200090c7ccb8200088bdecb724c630ae2000$$ENDHEX$$
* BY KIM, YONG-CHUL
**********************************************************/
gds_dual	=	create datastore
gds_dual.dataobject	=	'd_dual_language'
gds_dual.settransobject	(sqlca) 

gds_menu	=	create datastore
gds_menu.dataobject	=	'd_dynamic_menu_datastore'
gds_menu.settransobject(sqlca) 

GDS_PRIVILEGE	=	create datastore
GDS_PRIVILEGE.dataobject	=	'd_privilege_4_menu_lst'
GDS_PRIVILEGE.settransobject(sqlca) 

f_message_ontime( 1, f_msg_st(195)+'~r~n' )

if isvalid(w_message_ontime) then 
	w_message_ontime.wf_setposition( 10)
end if

//=====================================
// Dual Language / Menu Retrieve
//=====================================
Int lvi_return
lvi_return = gds_Dual.ImportFile(Gvs_Default_directory+'\isys_dual_language_'+string(Gvi_organization_id)+'.txt')

if lvi_return < 0 then 
   w_Message_ontime.pb_Info_msg.text = w_Message_ontime.pb_Info_msg.text+"Import Error ="+string(lvi_return)
else
   w_Message_ontime.pb_Info_msg.text = w_Message_ontime.pb_Info_msg.text+"Import Row Count ="+string(lvi_return)	
end if
	
IF gds_Dual.RowCount() < 1 THEN 
   w_Message_ontime.pb_Info_msg.text = w_Message_ontime.pb_Info_msg.text+Gvs_Default_directory+'\isys_dual_language_1.txt'+' Not Found'
   gds_Dual.Retrieve('%', '%', '%', '%', gvi_organization_id)
END IF

IF IsValid(w_Message_ontime) THEN 
	w_Message_ontime.wf_setposition(40)
END IF

gds_Menu.Retrieve(gvi_organization_id)	
IF IsValid(w_Message_ontime) THEN 
	w_Message_ontime.wf_setposition(80)
END IF

IF gds_Menu.RowCount() < 1 THEN 
	w_Message_ontime.pb_Info_msg.text = w_Message_ontime.pb_Info_msg.text+f_msg_st(139)  
END IF

//====================================
// $$HEX8$$8cad5cd508c7c4b3b0c6200070c88cd6$$ENDHEX$$
//====================================
GDS_PRIVILEGE.Retrieve( Gvs_user_id ,  gvi_organization_id)

Idle(1000)

w_main_frame.SetToolbar(2, TRUE, AlignAtLeft!)
w_main_frame.SetToolbar(3, FALSE, AlignAtRight!)
f_dual_lang_change_menu( m_main_frame_menu )

if isvalid(w_message_ontime) then 
	w_message_ontime.wf_setposition( 100)
end if

w_main_frame.setmicrohelp( string(gds_dual.rowcount())+" Rows Language Resource Found"  )

//===============================================
// $$HEX7$$14bcd5d054d674ba200024c608d5$$ENDHEX$$
//===============================================

openSheet(w_wallpaper_web, w_main_frame , Gvi_opensheet_position, Layered!)

//openSheet(w_wallpaper, w_main_frame , Gvi_opensheet_position, Layered!)

this.title = this.title+ "[User ID="+gvs_user_id+"][Level="+string(gvi_user_level)+'][DB='+ Gvs_database+"][ Computer="+f_get_computer_name()+"-"+f_get_computer_login_user_name()+"]"

openSheet(w_tab_sheet, w_main_frame , Gvi_opensheet_position, Layered!)
w_tab_sheet.height = 110
w_tab_sheet.bringtotop = false
////===============================================
////  $$HEX9$$f5acc0c9acc06dd520007dc7b4c5e4b484c7$$ENDHEX$$
////===============================================
//
//STRING LVS_ALERT_MESSAGE
//LVS_ALERT_MESSAGE = F_GET_ALERT_MESSAGE()
//
//IF    F_GET_ALERT_MESSAGE()  = 'ERROR' OR ISNULL(LVS_ALERT_MESSAGE) OR LVS_ALERT_MESSAGE = '' THEN
//	
//	
//ELSE
//	
//	 OPEN(W_ALERT)
//	 
//	 //=================================
//	 // ALERT ACTION PROCESS
//	 //=================================
//	 
//	 IF Gvs_alert_action_code = 'LOCK SYSTEM' THEN
//		
//		  RETURN
//		  
//	 ELSEIF  Gvs_alert_action_code = 'EXECUTE BATCH SCRIPT' THEN
//		
//		  RUN(GETCURRENTDIRECTORY()+'\ALERT_BATCH.BAT')
//		 
//	ELSEIF  Gvs_alert_action_code = 'DOWNLOAD PATCH' THEN		
//		
//		  // NOT DEFINED
//		
//	ELSEIF  Gvs_alert_action_code = 'HALT SYSTEM' THEN
//		
//		   HALT CLOSE
//			
//	ELSE
//
//		  // NOT DEFINED		 
//		 
//	END IF
//		
//END IF

//===============================================
//  menu $$HEX2$$1cc8b4c5$$ENDHEX$$
//===============================================

IF ( GVI_USER_LEVEL > 8 ) THEN
	
ELSE
	
	IF ( GVI_USER_LEVEL = 8 ) THEN
		
          m_main_frame_menu.m_manage.enabled = false
          m_main_frame_menu.m_system.enabled = false
	 
    ELSE
	
	     IF  ( GVI_USER_LEVEL > 2 ) THEN
		
		       m_main_frame_menu.m_manage.enabled = false
                m_main_frame_menu.m_system.enabled  = false
				 
		       m_main_frame_menu.m_design.enabled  = false
	
         ELSE
				
		       m_main_frame_menu.m_manage.enabled = false
                m_main_frame_menu.m_system.enabled  = false
		       m_main_frame_menu.m_design.enabled   = false
			 
		   	   m_main_frame_menu.m_confirm.enabled   = false
			   m_main_frame_menu.m_repair.enabled   = false
				
	    END IF

   END IF

END IF
end event

event ue_move;if isvalid(w_collapsemenu) then 
	w_collapsemenu.x = w_main_frame.workspacex( ) + 240
	w_collapsemenu.y = w_main_frame.workspacey( )+ 165
end if 
end event

on w_main_frame.create
if this.MenuName = "m_main_frame_menu" then this.MenuID = create m_main_frame_menu
this.mdi_1=create mdi_1
this.Control[]={this.mdi_1}
end on

on w_main_frame.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.mdi_1)
end on

event open;//=============================
//Database Wake Up
//Timer( 200 )
//=============================

THIS.TITLE = "["+Gvs_app_name+"]  ["+Gvs_organization_name+"]"
Postevent("UE_POST_OPEN")

end event

event timer;f_msg_mdi_help ( "Wake Up Database : "+string( f_ping_db() ) )
end event

event resize;if isvalid(w_collapsemenu) then 

w_collapsemenu.height = w_main_frame.height - 460
w_collapsemenu.width = w_main_frame.width - 280

end if 

if isvalid(w_tab_sheet) then 
	w_tab_sheet.width  = w_main_frame.width - 280
end if 

end event

type mdi_1 from mdiclient within w_main_frame
long BackColor=268435456
end type

