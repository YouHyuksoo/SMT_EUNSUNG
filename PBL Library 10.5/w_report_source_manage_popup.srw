HA$PBExportHeader$w_report_source_manage_popup.srw
$PBExportComments$$$HEX7$$38bb90c7b8d3d1c908c7c4b3b0c6$$ENDHEX$$
forward
global type w_report_source_manage_popup from w_popup_root
end type
type lb_pbl from so_picturelistbox within w_report_source_manage_popup
end type
type cb_file_open from so_commandbutton within w_report_source_manage_popup
end type
type cb_1 from so_commandbutton within w_report_source_manage_popup
end type
type cb_2 from so_commandbutton within w_report_source_manage_popup
end type
type cb_5 from so_commandbutton within w_report_source_manage_popup
end type
type cb_6 from so_commandbutton within w_report_source_manage_popup
end type
type cb_7 from so_commandbutton within w_report_source_manage_popup
end type
type cb_retrieve from so_commandbutton within w_report_source_manage_popup
end type
type cb_3 from so_commandbutton within w_report_source_manage_popup
end type
end forward

global type w_report_source_manage_popup from w_popup_root
integer x = 827
integer y = 576
integer width = 3922
integer height = 2276
string title = "Report Menu Source"
long backcolor = 79741120
lb_pbl lb_pbl
cb_file_open cb_file_open
cb_1 cb_1
cb_2 cb_2
cb_5 cb_5
cb_6 cb_6
cb_7 cb_7
cb_retrieve cb_retrieve
cb_3 cb_3
end type
global w_report_source_manage_popup w_report_source_manage_popup

type variables
string is_path
end variables

on w_report_source_manage_popup.create
int iCurrent
call super::create
this.lb_pbl=create lb_pbl
this.cb_file_open=create cb_file_open
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_5=create cb_5
this.cb_6=create cb_6
this.cb_7=create cb_7
this.cb_retrieve=create cb_retrieve
this.cb_3=create cb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.lb_pbl
this.Control[iCurrent+2]=this.cb_file_open
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.cb_5
this.Control[iCurrent+6]=this.cb_6
this.Control[iCurrent+7]=this.cb_7
this.Control[iCurrent+8]=this.cb_retrieve
this.Control[iCurrent+9]=this.cb_3
end on

on w_report_source_manage_popup.destroy
call super::destroy
destroy(this.lb_pbl)
destroy(this.cb_file_open)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_5)
destroy(this.cb_6)
destroy(this.cb_7)
destroy(this.cb_retrieve)
destroy(this.cb_3)
end on

event open;IVS_RESIZE_TYPE = 'DEFAULT'
Gst_return.gvb_return = false

//========================================
//
//========================================
dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)
dw_3.settransobject(sqlca)

cb_close.setfocus()

IVD_SELECTED_DATA_WINDOW = DW_1

if gds_dual.rowcount() < 1 then 
	f_msgbox(136) //There is not a possibility of knowing multi national language information  "Error" , "Language Info Not Found "
	return
end if

this.st_msg.text = "Language Change..."
  f_dual_lang_change_text(this)
this.st_msg.text = "Language Change Done."

triggerevent('ue_post_open')
end event

event ue_post_open;call super::ue_post_open;cb_retrieve.triggerevent( clicked!)
end event

type p_title from w_popup_root`p_title within w_report_source_manage_popup
integer width = 3913
end type

type cb_sort from w_popup_root`cb_sort within w_report_source_manage_popup
integer x = 0
integer y = 2252
end type

type cb_close from w_popup_root`cb_close within w_report_source_manage_popup
integer x = 0
integer y = 2356
end type

type st_msg from w_popup_root`st_msg within w_report_source_manage_popup
boolean visible = true
integer y = 204
integer width = 3913
end type

type dw_1 from w_popup_root`dw_1 within w_report_source_manage_popup
boolean visible = true
integer x = 1627
integer y = 300
integer width = 2281
integer height = 812
boolean titlebar = true
string title = "Datawindow List"
string dataobject = "d_report_object_list"
end type

type dw_2 from w_popup_root`dw_2 within w_report_source_manage_popup
boolean visible = true
integer y = 1108
integer width = 1609
integer height = 1068
boolean titlebar = true
string title = "Where Condition"
string dataobject = "d_datawindow_source_lst"
end type

event dw_2::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return

dw_3.retrieve( this.object.datawindow_name[currentrow] , gvi_organization_id )
end event

type dw_3 from w_popup_root`dw_3 within w_report_source_manage_popup
boolean visible = true
integer x = 1627
integer y = 1116
integer width = 2281
integer height = 1068
boolean titlebar = true
string title = "Report List"
string dataobject = "d_report_source_where_lst"
end type

type lb_pbl from so_picturelistbox within w_report_source_manage_popup
integer x = 5
integer y = 304
integer width = 1614
integer height = 800
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
boolean hscrollbar = true
boolean vscrollbar = true
boolean multiselect = true
boolean extendedselect = true
string picturename[] = {"Library!"}
end type

event selectionchanged;call super::selectionchanged;// $$HEX13$$54d67cc72000acb9a4c2b8d27cb9200004c75cd52000c0bc18c2$$ENDHEX$$
string	ls_file
long	ll_file_count

// $$HEX19$$d4c5b8d2acb92000acb9a4c2b8d27cb9200000ac38c824c630ae200004c75cd52000c0bc18c2$$ENDHEX$$
string 	ls_entries
long	ll_count, i, ll_temp

dw_1.Reset( )
ll_file_count    = lb_pbl.TotalItems( )

// $$HEX9$$20c1ddd02000c6c53cc774ba2000acb934d1$$ENDHEX$$
if ll_file_count = 0 then return

SetPointer ( HourGlass! )
dw_1.setredraw(false)

		ls_file	=	lb_pbl.text(index)
		ls_entries = LibraryDirectory(is_path + ls_file, DirDataWindow!)
				
				dw_1.accepttext()
				
				// $$HEX22$$d4c5b8d2acb958c7200030aef8bc200015c8f4bc7cb9200000ac38c840c61cc1200078c7ecd3b8d25cd5e4b2$$ENDHEX$$.
				ll_temp	=	dw_1.rowcount()
				ll_count = 	dw_1.ImportString( UPPER(ls_Entries), 1, 10000, 1, 3, 3)
				
				// pbl, type, argument $$HEX6$$7cb9200000ac38c840c62000$$ENDHEX$$update$$HEX2$$5cd5e4b2$$ENDHEX$$.
				FOR i = ll_temp + 1 TO ll_count + ll_temp
					dw_1.object.pbl_name[i]		= ls_file
					dw_1.object.object_type[i]	= 'Datawindow'
				NEXT

dw_1.setredraw(true)

end event

type cb_file_open from so_commandbutton within w_report_source_manage_popup
integer x = 32
integer y = 48
integer width = 375
integer height = 104
integer taborder = 10
boolean bringtotop = true
string text = "Pbl File Search"
end type

event clicked;string 	ls_item 
long	ll_total, i
string	ls_full, named
int		file_ok


//file_ok = GetFileOpenName("Select File", ls_full, named, "PBL", "PowerBuild Library Files (*.PBL),*.PBL")
//if file_ok <> 1 then
//	return
//end if
is_path = getcurrentdirectory()

GetFolder ( title, is_path )


//is_path			=	left(ls_full, len(ls_full) - len(named))
//sle_path.text	=	is_path

if is_path = "" then 
	f_msgbox(156)	//("$$HEX2$$55d678c7$$ENDHEX$$","$$HEX15$$54d67cc7200088c794b2200004c758ce7cb9200085c725b858d538c194c6$$ENDHEX$$...!")
else
	is_path = is_path + "\"
	lb_pbl.reset()
	lb_pbl.DirList(is_path + "*.pbl", 0)
end if

ll_total = lb_pbl.TotalItems()
for i = 1 to ll_total
	ls_item	=	lb_pbl.text(i)
	lb_pbl.DeleteItem(i)
	lb_pbl.InsertItem(ls_item, 1, i)
next

changedirectory( Gvs_default_directory )
end event

type cb_1 from so_commandbutton within w_report_source_manage_popup
integer x = 411
integer y = 48
integer width = 375
integer height = 104
integer taborder = 30
boolean bringtotop = true
string text = "Upload"
end type

event clicked;call super::clicked;String ls_dwsyn, ls_errors , lvs_library, lvs_dw_name
string lvs_datawindow_name , lvs_report_title
string lvs_report_style,   lvs_presentation_style,   lvs_comments
Blob lvb_dwsyn_blob
int lvi_count

if dw_1.getrow() < 1 then 
	return
end if 

lvs_dw_name = dw_1.object.object_name[dw_1.getrow()]
lvs_library = dw_1.object.pbl_name[dw_1.getrow()]
ls_dwsyn = LibraryExport(lvs_library, lvs_dw_name, ExportDataWindow!)

lvs_datawindow_name = dw_1.object.object_name[dw_1.getrow()]
lvs_report_title = dw_1.object.desc[dw_1.getrow()]

select count(*) into :lvi_count
 from isys_report_source
where datawindow_name = :lvs_datawindow_name
    and organization_id = :gvi_organization_id ;

if f_sql_check() < 0 then 
	return
end if  

	if lvi_count = 0 then 
		
		  INSERT INTO "ISYS_REPORT_SOURCE"  
				 ( "DATAWINDOW_NAME",   
				   "ORGANIZATION_ID",   
				   "REPORT_TITLE",   
				   "REPORT_STYLE",   
				   "PRESENTATION_STYLE",   
				   "COMMENTS",   
				   "VERSION",   
				   "ENTER_BY",   
				   "ENTER_DATE",   
				   "LAST_MODIFY_BY",   
				   "LAST_MODIFY_DATE" )  
		  VALUES ( :lvs_datawindow_name,   
				   :gvi_organization_id,   
				   :lvs_report_title,   
				   :lvs_report_style,   
				   :lvs_presentation_style,   
				   :lvs_comments ,
				   '1',   
				   :gvs_user_id ,
				   sysdate ,
				   :gvs_user_id ,
				   sysdate 
				   )  ;
			if f_sql_check() < 0 then 
				return
			end if 				   
	end if 
			lvb_dwsyn_blob = blob(ls_dwsyn)
			updateblob isys_report_source set datawindow_source  = :lvb_dwsyn_blob
				where datawindow_name = :lvs_datawindow_name
				and organization_id = :gvi_organization_id ;
				
			if f_sql_check() < 0 then 
				return
			else
				commit ;
			end if 

end event

type cb_2 from so_commandbutton within w_report_source_manage_popup
integer x = 3525
integer y = 44
integer width = 375
integer height = 104
integer taborder = 40
boolean bringtotop = true
string text = "Close"
end type

event clicked;call super::clicked;Gst_return.gvb_return = false
close(parent)
end event

type cb_5 from so_commandbutton within w_report_source_manage_popup
integer x = 2368
integer y = 44
integer width = 375
integer height = 104
integer taborder = 40
boolean bringtotop = true
string text = "Insert"
end type

event clicked;call super::clicked;int row 

if dw_2.getrow() < 1 then return 

row = dw_3.insertrow(0)

f_set_security_row( dw_3 , row , 'ALL') 

dw_3.object.datawindow_name[row] = dw_2.object.datawindow_name[dw_2.getrow()]
dw_3.object.argument_sort_order[row] = dw_3.object.rownum[row]



end event

type cb_6 from so_commandbutton within w_report_source_manage_popup
integer x = 3141
integer y = 44
integer width = 375
integer height = 104
integer taborder = 50
boolean bringtotop = true
string text = "Save"
end type

event clicked;call super::clicked;if dw_2.update() < 0 or dw_3.update() < 0 then 
	rollback;
else
	commit ;
	f_msgbox(170)
end if 
end event

type cb_7 from so_commandbutton within w_report_source_manage_popup
integer x = 2743
integer y = 44
integer width = 375
integer height = 104
integer taborder = 50
boolean bringtotop = true
string text = "Delete"
end type

event clicked;call super::clicked;if dw_3.getrow( ) < 1 then return

dw_3.deleterow(dw_3.getrow() )
end event

type cb_retrieve from so_commandbutton within w_report_source_manage_popup
integer x = 800
integer y = 48
integer width = 375
integer height = 104
integer taborder = 50
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;call super::clicked;dw_2.retrieve( gvi_organization_id )
end event

type cb_3 from so_commandbutton within w_report_source_manage_popup
integer x = 1179
integer y = 48
integer width = 375
integer height = 104
integer taborder = 60
boolean bringtotop = true
string text = "Show SQL"
end type

event clicked;call super::clicked;if dw_2.getrow( ) < 1 then return

Datastore ds

ds = create datastore

ds.dataobject = string(dw_2.object.datawindow_name[dw_2.getrow()])

openwithparm( w_edit_window , string(ds.GETSQLSelect()))

end event

