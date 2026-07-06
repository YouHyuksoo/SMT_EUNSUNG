HA$PBExportHeader$u_dw_xplistbar.sru
forward
global type u_dw_xplistbar from datawindow
end type
type str_trackmouseevent from structure within u_dw_xplistbar
end type
end forward

type str_trackmouseevent from structure
	unsignedlong		cbsize
	unsignedlong		dwflag
	unsignedlong		hwndtrack
	unsignedlong		dwhovertime
end type

global type u_dw_xplistbar from datawindow
integer width = 686
integer height = 400
string title = "none"
string dataobject = "d_xplistbar"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
event ue_clicked ( string as_text )
event mousemove pbm_dwnmousemove
event mouseleave ( )
end type
global u_dw_xplistbar u_dw_xplistbar

type prototypes
Function Boolean TrackMouseEvent(Ref str_TRACKMOUSEEVENT lpTrackMouseEvent) Library 'user32.dll' alias for "TrackMouseEvent;Ansi" 
Function Long GetLastError() Library 'Kernel32.dll' 
end prototypes

type variables
Long il_filter[]
Long il_prev, il_rowcount
String is_prevobject

Boolean ib_mousemove

Constant ULong  WM_MOUSELEAVE = 675
Constant ULong  TME_LEAVE = 2
Constant ULong  HOVER_DEFAULT = 4294967295 
end variables

forward prototypes
public function integer of_additem (string as_type, string as_text, integer ai_parent, string as_picture)
public function integer of_reset ()
private function integer of_addparenttofilter (integer ai_parent)
private function integer of_removeparentfromfilter (integer ai_parent)
private function string of_getparentfilter ()
public function integer of_resize (integer ai_width)
end prototypes

event mousemove;boolean ll_return
Long ll_error

IF NOT ib_mousemove THEN
	ib_mousemove = TRUE

	str_TRACKMOUSEEVENT lpTrackMouseEvent

	lpTrackMouseEvent.cbSize = 16 //Structure is 4 ulongs which is 16 bytes
	lpTrackMouseEvent.dwFlag = TME_LEAVE
	lpTrackMouseEvent.hwndTrack = Handle (this)
	lpTrackMouseEvent.dwHoverTime = HOVER_DEFAULT // Hover time-out in milliseconds
	
	ll_return = TrackMouseEvent(lpTrackMouseEvent) 
END IF

IF il_prev <> row OR is_prevobject <> dwo.Name THEN	
		
	THIS.SetRedraw(FALSE)
	
	THIS.SetItem(il_prev, 'highlighted','N')	
	
	IF dwo.Name <> 't_filler' AND &
		dwo.Name <> 't_child_bkgrnd' AND &
		dwo.Name <> 't_space' AND &
		dwo.Name <> 't_header_filler' AND &
		dwo.Name <> 'datawindow' THEN

		THIS.SetItem(row, 'highlighted','Y')
	END IF
	
	il_prev = Row
	is_prevobject = dwo.Name
	
	THIS.SetRedraw(TRUE)
END IF
end event

event mouseleave();ib_mousemove = FALSE

THIS.SetItem(il_prev, 'highlighted','N')	
il_prev=0
end event

public function integer of_additem (string as_type, string as_text, integer ai_parent, string as_picture);Long ll_row

//Add some space above the header
IF Lower(as_type) = 'header' THEN
	THIS.of_AddItem('space','',0, '')
END IF

//Insert new item
ll_row = THIS.InsertRow(0)

//Set the item type
CHOOSE CASE Lower(as_type)
	CASE 'header'
		THIS.Object.item_type[ll_row] = 'HE'
	CASE 'child'
		THIS.Object.item_type[ll_row] = 'C'
	CASE 'space'
		THIS.Object.item_type[ll_row] = 'S'
	CASE 'filler'
		THIS.Object.item_type[ll_row] = 'F'
END CHOOSE

//Populate item information
THIS.Object.item_text[ll_row] = as_text
THIS.Object.item_number[ll_row] = ll_row
THIS.Object.parent_handle[ll_row] = ai_parent
THIS.Object.item_picture[ll_row] = as_picture
THIS.Object.highlighted[ll_row] = 'N'

il_rowcount = THIS.RowCount()

RETURN ll_row
end function

public function integer of_reset ();Long ll_filter[]

//remove all items from the filter array
il_filter = ll_filter

//Remove all the items from the listbar
THIS.Reset()

RETURN 1
end function

private function integer of_addparenttofilter (integer ai_parent);Long ll_index
Boolean lb_found = FALSE

//Find an empty spot in the filter array
FOR ll_index = 1 TO UpperBound(il_filter)
	IF il_filter[ll_index] = 0 THEN
		il_filter[ll_index] = ai_parent
		lb_found=TRUE
		EXIT
	END IF
NEXT

//If an empty spot was not found then add the item
IF NOT lb_found THEN
	il_filter[UpperBound(il_filter) + 1] = ai_parent
END IF

RETURN 1
end function

private function integer of_removeparentfromfilter (integer ai_parent);Long ll_index
Boolean lb_found = FALSE

//Remove the item from the filter array so it's children
//can be displayed.
FOR ll_index = 1 TO UpperBound(il_filter)
	IF il_filter[ll_index] = ai_parent THEN
		il_filter[ll_index] = 0
		lb_found=TRUE
		EXIT
	END IF
NEXT

RETURN 1
end function

private function string of_getparentfilter ();Long ll_index
String ls_filter = ''

//Assemble all the filtered handles into a string
FOR ll_index = 1 TO UpperBound(il_filter)
	
	IF il_filter[ll_index] > 0 THEN
		IF ls_filter = '' THEN
			ls_filter = String(il_filter[ll_index])
	   ELSE
			ls_filter = ls_filter + ',' + String(il_filter[ll_index])
		END IF
	END IF
	
NEXT

IF Len(Trim(ls_filter)) > 0 THEN ls_filter = 'parent_handle not in (' + ls_filter + ')'

RETURN ls_filter
end function

public function integer of_resize (integer ai_width);String ls_return

//Resize the controls to the size datawindow control on the window
THIS.SetRedraw(FALSE)
ai_width = ai_width - 27

ls_return = THIS.Modify("t_child_bkgrnd.Width=" + String(ai_width - (Long(THIS.Describe("t_child_bkgrnd.X")) * 2)) )
ls_return = THIS.Modify("t_header_bkgrnd.Width=" + String(ai_width - (Long(THIS.Describe("t_header_bkgrnd.X")) * 2)) )
ls_return = THIS.Modify("t_filler.Width=" + String(ai_width - (Long(THIS.Describe("t_filler.X")) * 2)) )
ls_return = THIS.Modify("t_header_filler.Width=" + String(ai_width - (Long(THIS.Describe("t_header_filler.X")) * 2)) )
ls_return = THIS.Modify("t_space.Width=" + String(ai_width - (Long(THIS.Describe("t_space.X")) * 2)) )
//ls_return = THIS.Modify("item_text.Width=" + String(ai_width - 300 ) )

ls_return = THIS.Modify("p_expanded.x=" + String( Long(THIS.Describe("t_child_bkgrnd.x")) + Long(THIS.Describe("t_child_bkgrnd.width")) - Long(THIS.Describe("p_expanded.Width")) ))
ls_return = THIS.Modify("p_expandedhover.x=" + String( Long(THIS.Describe("t_child_bkgrnd.x")) + Long(THIS.Describe("t_child_bkgrnd.width")) - Long(THIS.Describe("p_expandedhover.Width")) ))

ls_return = THIS.Modify("p_collapsed.x=" + String( Long(THIS.Describe("t_child_bkgrnd.x")) + Long(THIS.Describe("t_child_bkgrnd.width")) - Long(THIS.Describe("p_collapsed.Width")) ))
ls_return = THIS.Modify("p_collapsedhover.x=" + String( Long(THIS.Describe("t_child_bkgrnd.x")) + Long(THIS.Describe("t_child_bkgrnd.width")) - Long(THIS.Describe("p_collapsedhover.Width")) ))

THIS.SetRedraw(TRUE)
RETURN 1
end function

on u_dw_xplistbar.create
end on

on u_dw_xplistbar.destroy
end on

event constructor;THIS.Object.datawindow.color = RGB(122,160,230)

of_Resize(THIS.Width)
end event

event clicked;IF row > 0 THEN
	CHOOSE CASE String(THIS.Object.item_type[row])
		CASE 'HE'
			THIS.Object.item_type[row] = 'HC'
			of_AddParentToFilter(Integer(THIS.Object.item_number[row]))
		CASE 'HC'
			THIS.Object.item_type[row] = 'HE'
			of_RemoveParentFromFilter(Integer(THIS.Object.item_number[row]))
		CASE 'C'
			IF dwo.Name = 'item_text' OR dwo.Name = 'item_picture' THEN
				THIS.Trigger Event ue_clicked(String(THIS.Object.item_text[row]))
			END IF
	END CHOOSE
	
	IF String(THIS.Object.item_type[row]) = 'HE' OR &
	   String(THIS.Object.item_type[row]) = 'HC' THEN
		THIS.SetFilter(of_GetParentFilter())
		THIS.Filter()
		THIS.SetSort('item_number')
		THIS.Sort()
	END IF
END IF
end event

event resize;
//If the scrollbar appears then resize the listbar so that
//it is completely visible.
IF Integer(THIS.Object.DataWindow.FirstRowOnPage) <> 1 OR &
	Integer(THIS.Object.DataWindow.lastRowOnPage) <> THIS.RowCount() THEN
	of_Resize(THIS.Width - 80)
ELSE
	of_Resize(THIS.Width)
END IF
end event

event losefocus;Long ll_index

THIS.SetRedraw(FALSE)
FOR ll_index = 1 TO il_rowcount
	THIS.SetItem(ll_index, 'highlighted','N')
NEXT
		
THIS.SetRedraw(TRUE)

end event

event other;Choose Case Message.Number
	Case WM_MOUSELEAVE
		This.TriggerEvent("MouseLeave")
End Choose 
end event

