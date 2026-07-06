HA$PBExportHeader$w_psr_viewer.srw
$PBExportComments$Select a .psr file and view the PSR report file on the screen. Window and DataWindow will resize to match contents of the DataWindow.
forward
global type w_psr_viewer from w_main_root
end type
type cb_select from so_commandbutton within w_psr_viewer
end type
end forward

global type w_psr_viewer from w_main_root
integer x = 274
integer y = 292
integer width = 2967
integer height = 2136
string title = "PSR File Viewer"
boolean minbox = false
windowstate windowstate = maximized!
long backcolor = 74481808
toolbaralignment toolbaralignment = alignatleft!
cb_select cb_select
end type
global w_psr_viewer w_psr_viewer

type prototypes

end prototypes

type variables
int ii_minheight
int ii_minwidth
end variables

forward prototypes
public subroutine of_change_dw (string as_filename)
end prototypes

public subroutine of_change_dw (string as_filename);//This function will assign the PSR to the DataWindow and size it and the window to the best size for 
//the contents. This is done by searching the columns of the datawindow to find the right most
//width.  The height is determined by the size of the detail band and summary.

Integer			li_column_count, li_counter, li_column_x, li_column_y, 	li_column_width, li_column_height, &
					li_new_width, li_new_height, li_screenwidth, li_screenheight, li_controls, li_index, &
					li_winheight, 	li_winwidth, li_dwheight, li_dwwidth, &
					li_max_x = 0, li_max_y = 0, li_vscroll_width = 78, li_hscroll_height = 69
String			ls_detail_height, ls_header_height, ls_footer_height, ls_summary_height
DragObject	ldo_temp

//turn redraw off to help avoid flicker
dw_1.setredraw(false)

//store filename on screen
F_MSG_MDI_HELP( as_filename)

//assign the filename (.psr) to the datawindow dataobject.
dw_1.dataobject = as_filename

//size window to the new datawindow
//fill sort column list box with column name as defined in the datawindow
li_column_count = Integer(dw_1.Object.DataWindow.Column.Count)

//loop through all of the columns in the datawindow
For li_counter =  1 To li_column_count
//	Find max x	
	li_column_x = Integer(dw_1.Describe("#"+string(li_counter)+".X"))
	li_column_width = Integer(dw_1.Describe("#"+string(li_counter)+".Width"))
	If li_column_x + li_column_width > li_max_x Then
		li_max_x = li_column_x + li_column_width
	End If
Next 

//	Find max y -- get height of detail and summary band
ls_summary_height = dw_1.Object.Datawindow.Summary.Height
ls_detail_height = dw_1.Object.Datawindow.Detail.Height
ls_header_height = dw_1.Object.Datawindow.Header.Height
ls_footer_height = dw_1.Object.Datawindow.Footer.Height
li_max_y =  Integer(ls_summary_height) + &
				(Integer(ls_detail_height) * 5) + &
				Integer(ls_header_height) +  &
				Integer(ls_footer_height)

//set redraw back on
dw_1.setredraw(true)

//dw_1.settransobject(sqlca)
//f_set_column_dddw(dw_1)
//DW_1.RETRIEVE(  '200507' , '%'  , '%' , GVS_LANGUAGE , GVI_ORGANIZATION_ID)

end subroutine

event open;call super::open;///////////////////////////////////////////////////////////////////////////////////////////////////////
// Open script for w_psr_viewer
///////////////////////////////////////////////////////////////////////////////////////////////////////

//this will open a file selector, then display the PSR report file in a datawindow

//get original height/width of datawindow 
ii_minheight = dw_1.height
ii_minwidth = dw_1.width

//start off getting a file
cb_select.Post Event clicked()

end event

on w_psr_viewer.create
int iCurrent
call super::create
this.cb_select=create cb_select
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_select
end on

on w_psr_viewer.destroy
call super::destroy
destroy(this.cb_select)
end on

event activate;call super::activate;
/***************************************
* $$HEX17$$08c7c4b324c115c8d0c5200000ad5cd52000acc06dd544c720004bc105d35cd5e4b2$$ENDHEX$$
*
*
****************************************/
Gst_set.window_id        = this.classname() 
Gst_set.author           = "JiSheng Technology"
Gst_set.creation_date    = '20041101'
Gst_set.last_modify_date = '20041101'
Gst_set.Report_window    = TRUE  // $$HEX7$$08b8ecd3b8d2200008c7c4b3b0c6$$ENDHEX$$


/****************************************

*****************************************/
 
IVS_RESIZE_TYPE    = 'NORMAL'  // $$HEX25$$08c7c4b3b0c620006cd030aed0c5200030b57cb7200070b374c7c0d0200008c7c4b3b0c62000acc074c788c92000c0bcbdac$$ENDHEX$$
ivs_modify_security = 'N'
ivs_dw_1_selected_row_yn ='N'
ivs_dw_1_use_focusindicator = 'N' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

/****************************************
* $$HEX6$$54ba74b2200078d5e4b4c1b9$$ENDHEX$$
* ADMIN     : ADMIN  ( $$HEX5$$04c8b4ccacc0a9c62000$$ENDHEX$$)
* $$HEX8$$00adacb9200020002000200020002000$$ENDHEX$$: MANAGE ( $$HEX8$$04c854ba74b2acc0a9c600aca5b22000$$ENDHEX$$)
* $$HEX7$$acc0a9c690c72000200020002000$$ENDHEX$$: GUEST  ( $$HEX11$$30ae08cd2000f1b45db8200070c88cd6200000aca5b2$$ENDHEX$$)
* $$HEX8$$70c88cd6200020002000200020002000$$ENDHEX$$: QUERY  ( $$HEX10$$15c8f4bc70c88cd6ccb9200000aca5b220002000$$ENDHEX$$)
* $$HEX5$$70b374c7c0d070c891c7$$ENDHEX$$: DATA_CONTROL  ( $$HEX12$$85c725b8200018c215c82000adc01cc8200024c115c82000$$ENDHEX$$)
* $$HEX7$$08b8ecd3b8d22000200020002000$$ENDHEX$$: REPORT ( $$HEX4$$08b8ecd3b8d22000$$ENDHEX$$, $$HEX5$$9ccd25b800adacb92000$$ENDHEX$$)
****************************************/
f_menu_control('REPORT' , TRUE)  // $$HEX8$$70b374c7c0d0200070c891c700aca5b2$$ENDHEX$$
/****************************************
* $$HEX11$$70b374c7c0d0200008c7c4b3b0c6200078d5e4b4c1b9$$ENDHEX$$
****************************************/

end event

type dw_5 from w_main_root`dw_5 within w_psr_viewer
integer x = 5
integer y = 116
end type

type dw_4 from w_main_root`dw_4 within w_psr_viewer
integer x = 5
integer y = 116
end type

type dw_3 from w_main_root`dw_3 within w_psr_viewer
integer x = 5
integer y = 116
end type

type dw_2 from w_main_root`dw_2 within w_psr_viewer
integer x = 5
integer y = 116
end type

type dw_1 from w_main_root`dw_1 within w_psr_viewer
integer x = 5
integer y = 116
integer width = 2368
integer height = 1220
boolean titlebar = true
end type

type cb_select from so_commandbutton within w_psr_viewer
integer x = 9
integer y = 12
integer width = 581
integer height = 88
integer taborder = 30
integer textsize = -9
integer weight = 400
string facename = "MS Sans Serif"
string text = "&Select PSR Report..."
end type

event clicked;///////////////////////////////////////////////////////////////////////////////////////////////////////
// Clicked script for cb_select
///////////////////////////////////////////////////////////////////////////////////////////////////////

int li_rc
string ls_path, ls_file
//
//This will open the standard file open dialog box with PSR extensions
li_rc = GetFileSaveName("Select Saved Report File", ls_path,ls_file,"psr","Report File (*.PSR),*.PSR")

If li_rc = 0 Then
	Return
End If
ChangeDirectory ( Gvs_default_directory )
//change the datawindow
of_change_dw(ls_path)

end event

