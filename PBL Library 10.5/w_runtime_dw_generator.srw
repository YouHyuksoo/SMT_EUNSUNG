HA$PBExportHeader$w_runtime_dw_generator.srw
$PBExportComments$Dual Language Information Manage
forward
global type w_runtime_dw_generator from w_main_root
end type
type cb_generate from so_commandbutton within w_runtime_dw_generator
end type
type cb_file_open from so_commandbutton within w_runtime_dw_generator
end type
type sle_path from so_singlelineedit within w_runtime_dw_generator
end type
type lb_pbl from so_picturelistbox within w_runtime_dw_generator
end type
type cb_select_object from so_commandbutton within w_runtime_dw_generator
end type
type cb_edit_mode_on from so_commandbutton within w_runtime_dw_generator
end type
type cb_edit_mode_off from so_commandbutton within w_runtime_dw_generator
end type
type sle_title_object_name from so_singlelineedit within w_runtime_dw_generator
end type
type sle_title_text from so_singlelineedit within w_runtime_dw_generator
end type
type sle_type from so_singlelineedit within w_runtime_dw_generator
end type
type cb_change_language from so_commandbutton within w_runtime_dw_generator
end type
type cb_1 from so_commandbutton within w_runtime_dw_generator
end type
type cb_2 from so_commandbutton within w_runtime_dw_generator
end type
type gb_1 from so_groupbox within w_runtime_dw_generator
end type
type gb_2 from so_groupbox within w_runtime_dw_generator
end type
end forward

global type w_runtime_dw_generator from w_main_root
integer width = 5440
integer height = 3352
string title = "Runtime DW Generator"
cb_generate cb_generate
cb_file_open cb_file_open
sle_path sle_path
lb_pbl lb_pbl
cb_select_object cb_select_object
cb_edit_mode_on cb_edit_mode_on
cb_edit_mode_off cb_edit_mode_off
sle_title_object_name sle_title_object_name
sle_title_text sle_title_text
sle_type sle_type
cb_change_language cb_change_language
cb_1 cb_1
cb_2 cb_2
gb_1 gb_1
gb_2 gb_2
end type
global w_runtime_dw_generator w_runtime_dw_generator

type variables
datawindow ivd_data_window
string is_path
end variables

on w_runtime_dw_generator.create
int iCurrent
call super::create
this.cb_generate=create cb_generate
this.cb_file_open=create cb_file_open
this.sle_path=create sle_path
this.lb_pbl=create lb_pbl
this.cb_select_object=create cb_select_object
this.cb_edit_mode_on=create cb_edit_mode_on
this.cb_edit_mode_off=create cb_edit_mode_off
this.sle_title_object_name=create sle_title_object_name
this.sle_title_text=create sle_title_text
this.sle_type=create sle_type
this.cb_change_language=create cb_change_language
this.cb_1=create cb_1
this.cb_2=create cb_2
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_generate
this.Control[iCurrent+2]=this.cb_file_open
this.Control[iCurrent+3]=this.sle_path
this.Control[iCurrent+4]=this.lb_pbl
this.Control[iCurrent+5]=this.cb_select_object
this.Control[iCurrent+6]=this.cb_edit_mode_on
this.Control[iCurrent+7]=this.cb_edit_mode_off
this.Control[iCurrent+8]=this.sle_title_object_name
this.Control[iCurrent+9]=this.sle_title_text
this.Control[iCurrent+10]=this.sle_type
this.Control[iCurrent+11]=this.cb_change_language
this.Control[iCurrent+12]=this.cb_1
this.Control[iCurrent+13]=this.cb_2
this.Control[iCurrent+14]=this.gb_1
this.Control[iCurrent+15]=this.gb_2
end on

on w_runtime_dw_generator.destroy
call super::destroy
destroy(this.cb_generate)
destroy(this.cb_file_open)
destroy(this.sle_path)
destroy(this.lb_pbl)
destroy(this.cb_select_object)
destroy(this.cb_edit_mode_on)
destroy(this.cb_edit_mode_off)
destroy(this.sle_title_object_name)
destroy(this.sle_title_text)
destroy(this.sle_type)
destroy(this.cb_change_language)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.gb_1)
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
Gst_set.Report_window    = false  // Report Window  True / Flase

/*****************************************
* Data WIndow Property
******************************************/
Ivs_resize_type    = 'MASTER_DETAIL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'Y' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

ivs_modify_mark = 'N'
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

F_MENU_CONTROL('DATA_CONTROL' , FALSE)  // All Data Control

/****************************************
* 
****************************************/
SELECTED_DATA_WINDOW = DW_2
end event

event ue_data_control;call super::ue_data_control;Long ROW
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		
		
		    DW_2.RETRIEVE()
              DW_2.SETFOCUS()
				  
	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
sle_path.TEXT = GETCURRENTDIRECTORY()


//================================

string 	ls_item
long		ll_total, i
int		file_ok

is_path = Getcurrentdirectory()

if is_path = "" then 
	f_msgbox(156) 	//("$$HEX2$$55d678c7$$ENDHEX$$","$$HEX15$$54d67cc7200088c794b2200004c758ce7cb9200085c725b858d538c194c6$$ENDHEX$$...!")
else
	lb_pbl.reset()
	lb_pbl.DirList(is_path + "\*.pbl", 0)
end if

ll_total = lb_pbl.TotalItems()
for i = 1 to ll_total
	ls_item	=	lb_pbl.text(i)
	lb_pbl.DeleteItem(i)
	lb_pbl.InsertItem(ls_item, 1, i)
next
end event

event resize;call super::resize;lb_pbl.height = newheight - lb_pbl.y
end event

type dw_5 from w_main_root`dw_5 within w_runtime_dw_generator
integer x = 901
integer y = 452
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_runtime_dw_generator
integer x = 901
integer y = 452
integer taborder = 50
end type

type dw_3 from w_main_root`dw_3 within w_runtime_dw_generator
integer x = 901
integer y = 452
integer taborder = 60
end type

type dw_2 from w_main_root`dw_2 within w_runtime_dw_generator
integer x = 901
integer y = 1272
integer width = 3611
integer height = 1064
integer taborder = 70
end type

event dw_2::clicked;call super::clicked;if upper(dwo.type) = 'TEXT'  then
	sle_title_object_name.text = string(dwo.name)	
	sle_title_text.text = dwo.text
elseif  upper(dwo.type) = 'COLUMN'  then
	
     sle_type.text = this.Describe( dwo.name+".Coltype")
	
end if
end event

type dw_1 from w_main_root`dw_1 within w_runtime_dw_generator
integer x = 905
integer y = 296
integer width = 3607
integer height = 972
integer taborder = 0
boolean titlebar = true
string dataobject = "d_object_list"
end type

event dw_1::doubleclicked;call super::doubleclicked;cb_select_object.triggerevent(clicked!)
end event

event dw_1::clicked;call super::clicked;SELECTED_DATA_WINDOW = DW_2
end event

type cb_generate from so_commandbutton within w_runtime_dw_generator
integer x = 2638
integer y = 60
integer width = 430
integer height = 96
integer taborder = 20
boolean bringtotop = true
boolean enabled = false
string text = "Generate"
end type

event clicked;call super::clicked;string ivs_datawindow

if isvalid(selected_data_window) then 
	ivs_datawindow = selected_data_window.Describe("DataWindow.Syntax")
     openwithparm(w_show_datawindow_popup ,ivs_datawindow )
     w_show_datawindow_popup.sle_comment.text = dw_1.object.desc[dw_1.getrow()]
	 w_show_datawindow_popup.uo_filename.settext(sle_path.text+"\"+dw_1.object.pbl_name[dw_1.getrow()])
end if
end event

type cb_file_open from so_commandbutton within w_runtime_dw_generator
integer x = 1646
integer y = 52
integer width = 462
integer height = 96
integer taborder = 30
boolean bringtotop = true
string text = "Pbl File Search"
end type

event clicked;string 	ls_item
long		ll_total, i
int		file_ok

is_path = Getcurrentdirectory()
file_ok = GetFolder( "PBL Library", is_path )
if file_ok <> 1 then
	return
end if
sle_path.text	=	is_path

if is_path = "" then 
	f_msgbox(156) 	//("$$HEX2$$55d678c7$$ENDHEX$$","$$HEX15$$54d67cc7200088c794b2200004c758ce7cb9200085c725b858d538c194c6$$ENDHEX$$...!")
else
	lb_pbl.reset()
	lb_pbl.DirList(is_path + "\*.pbl", 0)
end if

ll_total = lb_pbl.TotalItems()
for i = 1 to ll_total
	ls_item	=	lb_pbl.text(i)
	lb_pbl.DeleteItem(i)
	lb_pbl.InsertItem(ls_item, 1, i)
next
end event

type sle_path from so_singlelineedit within w_runtime_dw_generator
integer x = 37
integer y = 64
integer width = 1600
integer height = 76
integer taborder = 30
boolean bringtotop = true
long backcolor = 12632256
boolean enabled = false
boolean autohscroll = false
end type

type lb_pbl from so_picturelistbox within w_runtime_dw_generator
integer y = 292
integer width = 887
integer height = 2052
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
long textcolor = 0
long backcolor = 134217747
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
string picturename[] = {"Library!"}
end type

event selectionchanged;call super::selectionchanged;// $$HEX13$$54d67cc72000acb9a4c2b8d27cb9200004c75cd52000c0bc18c2$$ENDHEX$$
string	ls_file
long		ll_file_count, ll_file_select
// $$HEX19$$d4c5b8d2acb92000acb9a4c2b8d27cb9200000ac38c824c630ae200004c75cd52000c0bc18c2$$ENDHEX$$
string 	ls_entries
long		ll_count, i, ll_temp

SetPointer ( HourGlass! )
dw_1.setredraw(false)
dw_1.Reset( )

// $$HEX9$$20c1ddd02000c6c53cc774ba2000acb934d1$$ENDHEX$$
ll_file_count  = lb_pbl.TotalItems( )
if ll_file_count = 0  then return


// $$HEX11$$54d67cc7200018c2ccb97cd0200018bcf5bc5cd5e4b2$$ENDHEX$$.
FOR ll_file_select = 1 TO ll_file_count
	
	// $$HEX16$$54d67cc774c7200020c1ddd01cb42000bdacb0c6ccb9200098ccacb95cd5e4b2$$ENDHEX$$.
	if lb_pbl.state(ll_file_select) = 1 then 
	
	   ls_file	=	lb_pbl.text(ll_file_select)
	   ls_entries = LibraryDirectory(is_path +"\"+ ls_file, DirDataWindow!)
				
				dw_1.accepttext()
				// $$HEX22$$d4c5b8d2acb958c7200030aef8bc200015c8f4bc7cb9200000ac38c840c61cc1200078c7ecd3b8d25cd5e4b2$$ENDHEX$$.
				ll_temp	=	dw_1.rowcount()
				ll_count = 	dw_1.ImportString( UPPER(ls_Entries), 1, 10000, 1, 3, 3)
				
				// pbl, type, argument $$HEX6$$7cb9200000ac38c840c62000$$ENDHEX$$update$$HEX2$$5cd5e4b2$$ENDHEX$$.
				FOR i = ll_temp + 1 TO ll_count + ll_temp
					dw_1.object.pbl_name[i]		= ls_file
					dw_1.object.object_type[i]	= "Datawindow"
				NEXT
				
			end if
NEXT

dw_1.setredraw(true)
cb_select_object.enabled = true
end event

type cb_select_object from so_commandbutton within w_runtime_dw_generator
integer x = 2112
integer y = 52
integer width = 462
integer height = 96
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
string text = "Select Object"
end type

event clicked;call super::clicked;if dw_1.getrow() < 1 then return

	dw_2.dataobject= dw_1.object.object_name[dw_1.getrow()]
	dw_2.settransobject(sqlca)
	selected_data_window = dw_2

//=======================
// Re call post Script
//=======================
f_set_column_dddw(dw_2)

dw_2.insertrow(0)
cb_generate.enabled = true
cb_change_language.enabled = true


end event

type cb_edit_mode_on from so_commandbutton within w_runtime_dw_generator
integer x = 2629
integer y = 160
integer width = 430
integer height = 96
integer taborder = 30
boolean bringtotop = true
string text = "Edit Mode On"
end type

event clicked;call super::clicked;Gvi_dw_edit_mode = 1
cb_edit_mode_on.enabled = false
cb_edit_mode_off.enabled = true
f_set_column_dddw(dw_2)


STRING ls_dwobject  , lvs_col_name , lvs_border
Int li_objcount , li_start , li_end  , lvi_count


ls_dwobject = selected_data_window.Object.DataWindow.Objects     // dw object list
	if len(trim(ls_dwobject)) = 0 then 
	   return
	end if

	li_objcount = f_dual_lang_object_count(ls_dwobject)  // get object count
	li_start = 0
	
	for lvi_count = 1 to li_objcount
		
		lvs_col_name = '' 
		
		li_end = pos(ls_dwobject, "~t", li_start + 1)
		if lvi_count < li_objcount then    // last object check
			lvs_col_name = mid(ls_dwobject, li_start + 1, li_end - li_start - 1)	
		else
			lvs_col_name = mid(ls_dwobject, li_start + 1, len(ls_dwobject) - li_start)
		end if
		
		selected_data_window.Modify( lvs_col_name+".resizeable = 1" )
		selected_data_window.Modify( lvs_col_name+".moveable = 1" )
		
		lvs_border = selected_data_window.Describe( lvs_col_name+".border" )
		selected_data_window.Modify( lvs_col_name+".tag='"+lvs_border +"'" )
		
		selected_data_window.Modify( lvs_col_name+".border = 2" )		
		selected_data_window.Modify( lvs_col_name+".Background.Mode=0")
		
		li_start = li_end
	next
selected_data_window.setredraw(true)
end event

type cb_edit_mode_off from so_commandbutton within w_runtime_dw_generator
integer x = 3063
integer y = 160
integer width = 430
integer height = 96
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
string text = "Edit Mode Off"
end type

event clicked;call super::clicked;if Gvi_dw_edit_mode = 1 then 
else
	return 
end if
selected_data_window.setredraw(true)
Gvi_dw_edit_mode = 0
cb_edit_mode_on.enabled = true
cb_edit_mode_off.enabled = false

STRING ls_dwobject  , lvs_col_name
Int li_objcount , li_start , li_end  , lvi_count


ls_dwobject = selected_data_window.Object.DataWindow.Objects     // dw object list
	if len(trim(ls_dwobject)) = 0 then 
	   return
	end if

	li_objcount = f_dual_lang_object_count(ls_dwobject)  // get object count
	li_start = 0
	
	for lvi_count = 1 to li_objcount
		
		lvs_col_name = '' 
		
		li_end = pos(ls_dwobject, "~t", li_start + 1)
		if lvi_count < li_objcount then    // last object check
			lvs_col_name = mid(ls_dwobject, li_start + 1, li_end - li_start - 1)	
		else
			lvs_col_name = mid(ls_dwobject, li_start + 1, len(ls_dwobject) - li_start)
		end if
		
		selected_data_window.Modify( lvs_col_name+".resizeable = 0" )
		selected_data_window.Modify( lvs_col_name+".moveable = 0" )
		selected_data_window.Modify( lvs_col_name+".border = '"+ selected_data_window.Describe( lvs_col_name+".tag")+"'")
//		selected_data_window.Modify( lvs_col_name+".Background.Mode=1")		
		
		
		li_start = li_end
	next
	
selected_data_window.setredraw(true)
end event

type sle_title_object_name from so_singlelineedit within w_runtime_dw_generator
integer x = 41
integer y = 160
integer width = 526
integer height = 76
integer taborder = 40
boolean bringtotop = true
end type

type sle_title_text from so_singlelineedit within w_runtime_dw_generator
integer x = 576
integer y = 160
integer width = 526
integer height = 76
integer taborder = 50
boolean bringtotop = true
end type

event modified;call super::modified;selected_data_window.Modify( sle_title_object_name.text+".Text='"+Wordcap(lower(sle_title_text.text))+"'" )
end event

type sle_type from so_singlelineedit within w_runtime_dw_generator
integer x = 1106
integer y = 160
integer width = 535
integer height = 76
integer taborder = 60
boolean bringtotop = true
end type

type cb_change_language from so_commandbutton within w_runtime_dw_generator
integer x = 3063
integer y = 60
integer width = 430
integer height = 96
integer taborder = 30
boolean bringtotop = true
boolean enabled = false
string text = "Language"
end type

event clicked;call super::clicked;/*********************************************************
* $$HEX19$$e4b26dadb4c5200098ccacb97cb9200004c75cd5200090c7ccb8200088bdecb724c630ae2000$$ENDHEX$$: w_genapp_frame$$HEX5$$d0c51cc1200020c1b8c5$$ENDHEX$$
* $$HEX16$$74c7f3acd0c51cc194b22000c0bc58d6200091c7c5c5ccb9200018c289d568d5$$ENDHEX$$
* BY KIM, YONG-CHUL
**********************************************************/
if	Gvs_language =	'C' or Gvs_language = 'K' then

	if gds_dual.rowcount() < 1 then 
		f_msgbox(136) //There is not a possibility of knowing multi national language information		
//		("Error" , "Language Info Not Found ")
		return
	else
		F_MSG_MDI_HELP( "Dual Source "+string(gds_dual.rowcount())+" Rows Found" )
	end if
  
	w_main_frame.SetMicroHelp("Language Change...")
	
     f_dual_lang_change_text(parent)
	  
	w_main_frame.SetMicroHelp("Language Change Done.")
	  	
end if
end event

type cb_1 from so_commandbutton within w_runtime_dw_generator
integer x = 3483
integer y = 160
integer width = 430
integer height = 96
integer taborder = 50
boolean bringtotop = true
string text = "Column Disable"
end type

event clicked;call super::clicked;selected_data_window.modify( selected_data_window.getcolumnname()+'.background.color='+string(rgb(192,192,192)) )
selected_data_window.modify( selected_data_window.getcolumnname()+'.tabsequence=0' )
end event

type cb_2 from so_commandbutton within w_runtime_dw_generator
integer x = 3904
integer y = 160
integer width = 430
integer height = 96
integer taborder = 60
boolean bringtotop = true
string text = "Column Enable"
end type

type gb_1 from so_groupbox within w_runtime_dw_generator
integer x = 2601
integer width = 1746
integer height = 280
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_runtime_dw_generator
integer x = 9
integer y = 4
integer width = 2583
integer height = 280
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

