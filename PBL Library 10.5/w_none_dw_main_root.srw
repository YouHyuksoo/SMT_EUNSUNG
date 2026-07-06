HA$PBExportHeader$w_none_dw_main_root.srw
$PBExportComments$Main Root Window
forward
global type w_none_dw_main_root from window
end type
end forward

global type w_none_dw_main_root from window
integer width = 1925
integer height = 908
boolean titlebar = true
string title = "Workspace"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 12632256
string icon = "AppIcon!"
boolean center = true
event ue_data_control ( )
event ue_post_open ( )
event ue_unmoved pbm_syscommand
end type
global w_none_dw_main_root w_none_dw_main_root

type variables
DWObject ls_anydata
Double setrow

STRING IVS_RESIZE_TYPE
STRING ivs_modify_security='Y'

STRING ivs_dw_1_use_focusindicator ='Y'
STRING ivs_dw_2_use_focusindicator ='N'
STRING ivs_dw_3_use_focusindicator ='N'
STRING ivs_dw_4_use_focusindicator ='N'
STRING ivs_dw_5_use_focusindicator ='N'

STRING ivs_dw_1_selected_row_yn = 'Y' 
STRING ivs_dw_2_selected_row_yn = 'N'
STRING ivs_dw_3_selected_row_yn = 'N'
STRING ivs_dw_4_selected_row_yn = 'N'
STRING ivs_dw_5_selected_row_yn = 'N'

STRING ivs_dw_1_retrice_cancel_popup_open = 'Y'
STRING ivs_dw_2_retrice_cancel_popup_open = 'Y'
STRING ivs_dw_3_retrice_cancel_popup_open = 'Y'
STRING ivs_dw_4_retrice_cancel_popup_open = 'Y'
STRING ivs_dw_5_retrice_cancel_popup_open = 'Y'


STRING ivs_dw_1_deleteselected_yn = 'Y' 
STRING ivs_dw_2_deleteselected_yn = 'Y' 
STRING ivs_dw_3_deleteselected_yn = 'Y' 
STRING ivs_dw_4_deleteselected_yn = 'Y' 
STRING ivs_dw_5_deleteselected_yn = 'Y' 

//=====================================
// Free Resize Variable
//=====================================
int ii_win_width, ii_win_height, ii_win_frame_w, ii_win_frame_h
str_size size_ctrl [] 

//Boolean variable to stop recursion
boolean ib_exec = false


//==============================
// ANIMATEWINDOW CONSTASNT
//==============================
CONSTANT LONG AW_HOR_POSITIVE = 1
CONSTANT LONG AW_HOR_NEGATIVE = 2
CONSTANT LONG AW_VER_POSITIVE = 4
CONSTANT LONG AW_VER_NEGATIVE = 8
CONSTANT LONG AW_CENTER = 16
CONSTANT LONG AW_HIDE = 65536
CONSTANT LONG AW_ACTIVATE = 131072
CONSTANT LONG AW_SLIDE = 262144
CONSTANT LONG AW_BLEND = 524288 


end variables

forward prototypes
public function integer wf_set_window_property (string arg_window_name)
public function integer wf_size_it ()
public function integer wf_resize_it (double size_factor)
end prototypes

event ue_post_open();/*********************************************************
* $$HEX19$$e4b26dadb4c5200098ccacb97cb9200004c75cd5200090c7ccb8200088bdecb724c630ae2000$$ENDHEX$$: w_genapp_frame$$HEX5$$d0c51cc1200020c1b8c5$$ENDHEX$$
* $$HEX16$$74c7f3acd0c51cc194b22000c0bc58d6200091c7c5c5ccb9200018c289d568d5$$ENDHEX$$
* BY KIM, YONG-CHUL
**********************************************************/
if	Gvs_language =	'C' or Gvs_language = 'K' then

	if gds_dual.rowcount() < 1 then 
		f_msgbox(136) //There is not a possibility of knowing multi national language information		
		return
	else
		F_MSG_MDI_HELP( "Dual Source "+string(gds_dual.rowcount())+" Rows Found" )
	end if
  
	w_main_frame.SetMicroHelp("Language Change...")
	
     f_dual_lang_change_text(this)
	  
	w_main_frame.SetMicroHelp("Language Change Done.")
	  	
end if

end event

event ue_unmoved;CHOOSE CASE commandtype
	CASE 61456, 61458
		message.processed = true
		message.returnvalue = 0
END CHOOSE

return

end event

public function integer wf_set_window_property (string arg_window_name);  SELECT UPPER(:ARG_WINDOW_NAME) , UPPER(DECODE( :GVS_LANGUAGE , 'K' ,  WINDOW_DESCRIPTION_KOR,  'E' ,  WINDOW_DESCRIPTION_ENG , WINDOW_DESCRIPTION_LOCAL )) WINDOW_DESCRIPTION ,
               UPPER(WINDOW_TYPE),
			VERSION
    INTO  :Gst_set.window_id,   
	          :Gst_set.window_comment,   
               :Gst_set.window_type,
               :Gst_set.version
    FROM ISYS_WINDOW  
	WHERE WINDOW_NAME     = UPPER(:ARG_WINDOW_NAME)
	  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;

IF F_SQL_CHECK() < 0 THEN 
	 RETURN -1
ELSE

END IF

IF SQLCA.SQLCODE = 100 THEN 
	Gst_set.window_id =    UPPER(ARG_WINDOW_NAME)
	Gst_set.window_title     = W_MAIN_FRAME.GETACTIVESHEET().title
     Gst_set.window_comment   = 'Unknown'   
     Gst_set.window_type      = 'None'
     Gst_set.version	       = 0

ELSE
	
	Gst_set.window_title     = W_MAIN_FRAME.GETACTIVESHEET().title
	
END IF


RETURN 0 
end function

public function integer wf_size_it ();////////////////////////////////////////////////////////////////////////////////////////////////////
// function: wf_size_it
////////////////////////////////////////////////////////////////////////////////////////////////////

// save the original sizes of the window and all of the objects on the window
// NOTE !!!! this process does not work on objects that are not descended
// from the dragobject class.

dragobject temp
int cnt,i
ii_win_width  = this.width
ii_win_height = this.height

//ii_win_frame_w = 0
//ii_win_frame_h = 0

ii_win_frame_w = this.width - this.WorkSpaceWidth()
ii_win_frame_h = this.height - this.WorkSpaceHeight()

cnt = upperbound(this.control)
for i = cnt to 1 step -1
	temp = this.control[i]
	
	// everything has a x,y,width and height
	size_ctrl[i].x = temp.x 
	size_ctrl[i].width = temp.width 
	size_ctrl[i].y = temp.y
	size_ctrl[i].height = temp.height 

	// now go get text size information
	choose case typeof(temp)
		case commandbutton!
			commandbutton cb
			cb = temp
			size_ctrl[i].fontsize = cb.textsize 

		case singlelineedit!
			singlelineedit sle
			sle = temp
			size_ctrl[i].fontsize = sle.textsize 

		case editmask!
			editmask em
			em = temp
			size_ctrl[i].fontsize  	=	em.textsize 

		case statictext!
			statictext st
			st = temp
			size_ctrl[i].fontsize  	=	st.textsize 
	
		case picturebutton!
			picturebutton pb
			pb = temp
			size_ctrl[i].fontsize = pb.textsize 

		case checkbox!
			checkbox cbx
			cbx = temp
			size_ctrl[i].fontsize  	=	cbx.textsize 

		case dropdownlistbox!
			dropdownlistbox ddlb
			ddlb = temp
			size_ctrl[i].fontsize  	=	ddlb.textsize 

		case groupbox!
			groupbox gb
			gb = temp
			size_ctrl[i].fontsize  	=	gb.textsize 

		case listbox!
			listbox lb
			lb = temp
			size_ctrl[i].fontsize  	=	lb.textsize 

		case multilineedit!
			multilineedit mle
			mle = temp
			size_ctrl[i].fontsize  	=	mle.textsize 
			
		case radiobutton!
			radiobutton rb
			rb = temp
			size_ctrl[i].fontsize  	=	rb.textsize 
	end choose
next

return 1
end function

public function integer wf_resize_it (double size_factor);////////////////////////////////////////////////////////////////////////////////////////////////////
// function: wf_resize_it
////////////////////////////////////////////////////////////////////////////////////////////////////


// loop through off of the objects captured in the wf_size_it function and resize them
// Note !! radio buttons and checkboxes do not size properly as they are of fixed size.

dragobject temp
int cnt,i

ib_exec = false // keep the function from being called recursively

//this.hide()
// resize the window
//this.width = ((  ii_win_width - ii_win_frame_w) * size_factor) + ii_win_frame_w
//this.height = ((  ii_win_height - ii_win_frame_h) * size_factor) + ii_win_frame_h

// for each control in the list, resize it and it's textsize (as applicable)
cnt = upperbound(this.control)
for i = cnt to 1 step -1
	
	temp = this.control[i]
//	temp.x		 = size_ctrl[i].x * size_factor
//	temp.width   = size_ctrl[i].width  * size_factor
//	temp.y		 = size_ctrl[i].y * size_factor
////	temp.height  = size_ctrl[i].height * size_factor 
	
	choose case typeof(temp)
		case commandbutton!
			commandbutton cb
			cb = temp
//			cb.textsize =  size_ctrl[i].fontsize * size_factor 

		case singlelineedit!
			singlelineedit sle
			sle = temp
			sle.textsize =  size_ctrl[i].fontsize * size_factor 
		
		case editmask!
			editmask em
			em = temp
//			em.textsize =  size_ctrl[i].fontsize * size_factor 
		
		case statictext!
			statictext st
			st = temp
//			st.textsize =  size_ctrl[i].fontsize * size_factor 

		case datawindow! // datawindows get zoomed
			datawindow dw
			dw = temp
			
			dw.x		 = size_ctrl[i].x * size_factor
			dw.width   = size_ctrl[i].width  * size_factor
			dw.y		 = size_ctrl[i].y * size_factor			
          	dw.height  = size_ctrl[i].height * size_factor 			
//			dw.Object.DataWindow.zoom = string(int(size_factor*100))

		case picturebutton!
			picturebutton pb
			pb = temp
//			pb.textsize =  size_ctrl[i].fontsize * size_factor 

		case checkbox!
			checkbox cbx
			cbx = temp
//			cbx.textsize =  size_ctrl[i].fontsize * size_factor 

		case dropdownlistbox!
			dropdownlistbox ddlb
			ddlb = temp
//			ddlb.textsize =  size_ctrl[i].fontsize * size_factor 

		case groupbox!
			groupbox gb
			gb = temp
          	gb.height  = size_ctrl[i].height * size_factor 				
//			gb.textsize =  size_ctrl[i].fontsize * size_factor 

		case listbox!
			listbox lb
			lb = temp
//			lb.textsize  =  size_ctrl[i].fontsize * size_factor 

		case multilineedit!
			multilineedit mle
			mle = temp
          	mle.height  = size_ctrl[i].height * size_factor 				
//			mle.textsize =  size_ctrl[i].fontsize * size_factor 

		case radiobutton!
			radiobutton rb
			rb = temp
//			rb.textsize =  size_ctrl[i].fontsize * size_factor 

	end choose
next

//this.Show()
ib_exec = true
return 1
end function

on w_none_dw_main_root.create
end on

on w_none_dw_main_root.destroy
end on

event open;PostEvent("ue_post_open")



end event

event activate;SELECTED_WINDOW = THIS

end event

event close;// $$HEX18$$70b374c7c0d008c7c4b3b0c6200018c215c8a8badcb47cb9200074d51cc85cd5e4b22000$$ENDHEX$$
Gvi_dw_edit_mode = 0
end event

