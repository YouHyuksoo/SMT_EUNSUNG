HA$PBExportHeader$w_library_select_popup.srw
forward
global type w_library_select_popup from w_none_dw_popup_root
end type
type lb_pbl from so_picturelistbox within w_library_select_popup
end type
type cb_exit from so_commandbutton within w_library_select_popup
end type
type cb_select from so_commandbutton within w_library_select_popup
end type
type p_1 from so_picture within w_library_select_popup
end type
type st_1 from so_statictext within w_library_select_popup
end type
end forward

global type w_library_select_popup from w_none_dw_popup_root
integer width = 2491
integer height = 1912
lb_pbl lb_pbl
cb_exit cb_exit
cb_select cb_select
p_1 p_1
st_1 st_1
end type
global w_library_select_popup w_library_select_popup

type variables
datawindow idw_dw_1
string is_path
end variables

on w_library_select_popup.create
int iCurrent
call super::create
this.lb_pbl=create lb_pbl
this.cb_exit=create cb_exit
this.cb_select=create cb_select
this.p_1=create p_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.lb_pbl
this.Control[iCurrent+2]=this.cb_exit
this.Control[iCurrent+3]=this.cb_select
this.Control[iCurrent+4]=this.p_1
this.Control[iCurrent+5]=this.st_1
end on

on w_library_select_popup.destroy
call super::destroy
destroy(this.lb_pbl)
destroy(this.cb_exit)
destroy(this.cb_select)
destroy(this.p_1)
destroy(this.st_1)
end on

event open;call super::open;idw_dw_1 = message.powerobjectparm

cb_select.triggerevent(clicked!)
end event

type p_title from w_none_dw_popup_root`p_title within w_library_select_popup
integer width = 2478
integer height = 312
end type

type cb_close from w_none_dw_popup_root`cb_close within w_library_select_popup
end type

type st_msg from w_none_dw_popup_root`st_msg within w_library_select_popup
end type

type lb_pbl from so_picturelistbox within w_library_select_popup
integer y = 320
integer width = 2478
integer height = 1336
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
long backcolor = 12639424
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

idw_dw_1.Reset( )
ll_file_count    = lb_pbl.TotalItems( )

// $$HEX9$$20c1ddd02000c6c53cc774ba2000acb934d1$$ENDHEX$$
if ll_file_count = 0 then return

SetPointer ( HourGlass! )
idw_dw_1.setredraw(false)

		ls_file	=	lb_pbl.text(index)
		ls_entries = LibraryDirectory(is_path + ls_file, DirDataWindow!)
				
				idw_dw_1.accepttext()
				
				// $$HEX22$$d4c5b8d2acb958c7200030aef8bc200015c8f4bc7cb9200000ac38c840c61cc1200078c7ecd3b8d25cd5e4b2$$ENDHEX$$.
				ll_temp	=	idw_dw_1.rowcount()
				ll_count = 	idw_dw_1.ImportString( UPPER(ls_Entries), 1, 10000, 1, 3, 3)
				
				// pbl, type, argument $$HEX6$$7cb9200000ac38c840c62000$$ENDHEX$$update$$HEX2$$5cd5e4b2$$ENDHEX$$.
				FOR i = ll_temp + 1 TO ll_count + ll_temp
					idw_dw_1.object.pbl_name[i]		= ls_file
					idw_dw_1.object.object_type[i]	= 'Datawindow'
				NEXT

idw_dw_1.setredraw(true)

end event

event doubleclicked;call super::doubleclicked;cb_exit.triggerevent(clicked!)
end event

type cb_exit from so_commandbutton within w_library_select_popup
integer x = 1934
integer y = 1684
integer height = 128
integer taborder = 20
boolean bringtotop = true
string text = "Exit"
end type

event clicked;call super::clicked;Close(parent)	
end event

type cb_select from so_commandbutton within w_library_select_popup
integer x = 27
integer y = 1684
integer height = 128
integer taborder = 30
boolean bringtotop = true
string text = "Select Library"
end type

event clicked;call super::clicked;string 	ls_item 
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

type p_1 from so_picture within w_library_select_popup
integer x = 2112
integer y = 8
integer width = 352
integer height = 300
boolean bringtotop = true
boolean originalsize = false
string picturename = "confirm.bmp"
end type

type st_1 from so_statictext within w_library_select_popup
integer x = 82
integer y = 108
integer width = 983
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
string text = "Select a report library"
alignment alignment = left!
end type

