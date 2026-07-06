HA$PBExportHeader$w_sort.srw
$PBExportComments$$$HEX8$$70b374c7c0d0200008c7c4b3b0c62000$$ENDHEX$$Sort Program
forward
global type w_sort from w_none_dw_popup_root
end type
type st_2 from so_statictext within w_sort
end type
type st_1 from so_statictext within w_sort
end type
type st_5 from so_statictext within w_sort
end type
type cb_ok from so_commandbutton within w_sort
end type
type dw_2 from datawindow within w_sort
end type
type dw_3 from datawindow within w_sort
end type
type st_3 from so_statictext within w_sort
end type
end forward

global type w_sort from w_none_dw_popup_root
integer x = 1038
integer y = 600
integer width = 2194
integer height = 1780
string title = "Sort Column List"
string icon = "Row.ico"
toolbaralignment toolbaralignment = alignatleft!
st_2 st_2
st_1 st_1
st_5 st_5
cb_ok cb_ok
dw_2 dw_2
dw_3 dw_3
st_3 st_3
end type
global w_sort w_sort

type variables
// determines if left mouse button is down for employees datawindow
boolean    ib_down

// determines if left mouse button is down for employee details datawindow
boolean   ib_detail_down

// determines if message to drag detail employee is displayed
boolean   ib_detail_message

// Test if any employees status has been changed.
boolean   ib_changed

datawindow dw_1
end variables

on w_sort.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_1=create st_1
this.st_5=create st_5
this.cb_ok=create cb_ok
this.dw_2=create dw_2
this.dw_3=create dw_3
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_5
this.Control[iCurrent+4]=this.cb_ok
this.Control[iCurrent+5]=this.dw_2
this.Control[iCurrent+6]=this.dw_3
this.Control[iCurrent+7]=this.st_3
end on

on w_sort.destroy
call super::destroy
destroy(this.st_2)
destroy(this.st_1)
destroy(this.st_5)
destroy(this.cb_ok)
destroy(this.dw_2)
destroy(this.dw_3)
destroy(this.st_3)
end on

event open;
dw_1 = create datawindow

dw_1 = message.Powerobjectparm

int i_cnt,i_st_cnt, i = 0,i_row,i_find, xxx

string s_1[],s_t,s_obj,s_s,s_sf,s_kjh

string s_h_1[],s_sort,s_st[]


s_sort = dw_1.Describe("DataWindow.Table.Sort")
s_sort = s_sort + ","

s_obj = dw_1.describe("datawindow.objects")
s_obj = s_obj + "~t"

DO WHILE i = 0
	
	s_t   = mid(s_obj,1,pos(s_obj,"~t",1) -1)    // column value read
	s_obj = mid(s_obj,pos(s_obj,"~t",1) +1)
	
	s_s    = mid(s_sort,1,pos(s_sort,",",1) -1)  // sort setting value read
	s_sort = mid(s_sort,pos(s_sort,",",1) +1)
	
	if len(s_s) > 0 then
		i_st_cnt = i_st_cnt + 1
   	s_st[i_st_cnt] = s_s
	end if

	if len(s_t) > 0 then
		if mid(s_t,1,4) <> "obj_" then
   	   		if pos(s_t,"_t") < 1 then 
 		   		i_cnt = i_cnt + 1		
				s_1[i_cnt] = s_t			
				s_t = s_t + "_t" + ".text"
				//----------------------------------
				s_kjh = dw_1.describe(s_t)

				if mid(s_kjh,1,1) = '~r' then
					s_kjh = mid(s_kjh,2,len(s_kjh) - 1)
				end if 
				//"$$HEX4$$c6c560c530ae2000$$ENDHEX$$
				if pos(s_kjh,'"',1) > 0 then
			    	xxx = pos(s_kjh,'"',1)
					s_kjh = mid(s_kjh,1,xxx - 1) + mid(s_kjh,xxx + 1, len(s_kjh))
				end if
			
				if pos(s_kjh,'"',1) > 0 then
			    	xxx = pos(s_kjh,'"',1)
					s_kjh = mid(s_kjh,1,xxx - 1) + mid(s_kjh,xxx + 1, len(s_kjh))
				end if
			
				//~r $$HEX3$$c6c560c530ae$$ENDHEX$$..$$HEX3$$00acb4c670b3$$ENDHEX$$..
				if pos(s_kjh,'~r',1) > 0 then
			    	xxx = pos(s_kjh,'~r',1)
					s_kjh = mid(s_kjh,1,xxx - 1) + mid(s_kjh,xxx + 2, len(s_kjh))
				end if
				
				if pos(s_kjh,'~r',1) > 0 then
			    	xxx = pos(s_kjh,'~r',1)
					s_kjh = mid(s_kjh,1,xxx - 1) + mid(s_kjh,xxx + 2, len(s_kjh))
				end if
				
				s_h_1[i_cnt] = s_kjh
				//----------------------------------
	  			//s_h_1[i_cnt] = dw_1.describe(s_t)						
		   end if	
		end if
	else
		i = 1
	end if

LOOP

i_row = UpperBound(s_1)
INT i_ii

FOR i=1 TO i_row

  	if Trim(s_h_1[i])	<> '!' then 
	    i_ii = dw_2.insertrow(0)
    	 dw_2.SetItem(i_ii,"a",s_1[i])
    	 dw_2.SetItem(i_ii,"a_t",s_h_1[i])	
	    dw_2.SetItem(i_ii,"a_num",i)		
   end if
NEXT

i_row = UpperBound(s_st)


for i = 1 to i_row
   if len(s_st[i]) > 0 then
		
		s_sf = "a = " + "~'" + trim(mid(s_st[i],1,len(s_st[i]) - 2)) + "~'" 
		i_find = dw_2.Find(s_sf, 1,dw_2.RowCount( ))

		if right(s_st[i],1) = "A" then
			dw_2.setitem(i_find,"a_check","Y")
		else
			dw_2.setitem(i_find,"a_check","N")
		end if		
		
      dw_2.RowsMove( i_find,i_find , primary!,dw_3, dw_3.rowcount() + 1, Primary!)	   
		
	end if
	
next

setfocus(cb_ok)
end event

type p_title from w_none_dw_popup_root`p_title within w_sort
integer width = 2181
end type

type cb_close from w_none_dw_popup_root`cb_close within w_sort
boolean visible = true
integer x = 1897
integer y = 240
end type

type st_msg from w_none_dw_popup_root`st_msg within w_sort
boolean visible = true
integer y = 356
integer width = 2181
end type

type st_2 from so_statictext within w_sort
integer x = 1097
integer y = 456
integer width = 425
integer height = 60
integer weight = 700
long textcolor = 128
boolean enabled = false
string text = "Sort Order"
alignment alignment = left!
end type

type st_1 from so_statictext within w_sort
integer x = 14
integer y = 456
integer width = 416
integer height = 60
integer weight = 700
long textcolor = 128
boolean enabled = false
string text = "Item"
alignment alignment = left!
end type

type st_5 from so_statictext within w_sort
integer x = 18
integer y = 260
integer width = 672
integer height = 56
integer weight = 700
long textcolor = 8388608
boolean enabled = false
string text = "Drag To Right From Left !"
end type

type cb_ok from so_commandbutton within w_sort
event clicked pbm_bnclicked
integer x = 1609
integer y = 240
integer width = 288
integer height = 96
integer taborder = 10
string text = "OK(&O)"
end type

event clicked;if dw_3.RowCount() < 1 then 
   dw_1.SetSort("")
   dw_1.sort()
   close(parent)	
	return
end if
	

long l_row
string s_col,s_check

FOR l_row=1 TO dw_3.Rowcount()
	s_check = dw_3.GetItemstring(l_row,"a_check")	
	IF s_check = "Y" then 
	   s_col   = s_col + dw_3.GetItemstring(l_row,"a") + " " + "A" + ","
	else
	   s_col   = s_col + dw_3.GetItemstring(l_row,"a") + " " + "D" + ","
	end if
NEXT

s_col = mid(s_col,1,len(s_col) - 1)

dw_1.SetSort(s_col)
dw_1.sort()
close(parent)


end event

event getfocus;this.default = true
end event

event losefocus;this.default = false
end event

type dw_2 from datawindow within w_sort
event ue_buttondown pbm_lbuttondown
event ue_buttonup pbm_lbuttonup
event ue_mousemove pbm_mousemove
integer x = 5
integer y = 524
integer width = 1065
integer height = 1172
string dragicon = "DosEdit5!"
string dataobject = "d_sort_source"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

on ue_buttondown;ib_down = true
end on

on ue_buttonup;ib_down = false

end on

event ue_mousemove;	if ib_down then
		this.Drag (begin!)
	end if

end event

event dragdrop;
DragObject	ldo_control
int			li_row

ldo_control = DraggedObject()

if ldo_control = dw_3 then
	li_row = dw_3.GetRow()
	if li_row > 0 then
		dw_3.RowsMove(li_row,li_row, Primary!,dw_2, &
         		dw_3.GetItemNumber(li_row,"a_num"), Primary!)		
	end if
end if


end event

event rowfocuschanged;if currentrow > 0 then 
//	f_select_current_row(this)
	selectrow(0,false)
	selectrow(currentrow,true)
end if
end event

event losefocus;this.SelectRow(0,False)
end event

event clicked;if row > 0 then
   this.SelectRow(0,False)
   this.SelectRow(row,True)
   this.setfocus()
end if
end event

type dw_3 from datawindow within w_sort
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
event ue_mousemove pbm_mousemove
integer x = 1074
integer y = 524
integer width = 1102
integer height = 1172
string dragicon = "Asterisk!"
string dataobject = "d_sort_target"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

on ue_lbuttondown;ib_detail_down = true
end on

on ue_lbuttonup;ib_detail_down = false
end on

event ue_mousemove;//////////////////////////////////////////////////////////////////////
// if left mouse button is down and user moves the mouse and 
// the pointer is over the employee picture, initiate drag mode.
//////////////////////////////////////////////////////////////////////

string	ls_emp_fname, &
			ls_emp_lname

// if message is not already being displayed, display it
if not ib_detail_message then
		ib_detail_message = true
end if
if ib_detail_down then
	this.Drag (begin!)
end if
if ib_detail_message then
	ib_detail_message = false
end if

end event

event dragdrop;
DragObject	ldo_control
int			li_row

ldo_control = DraggedObject()

if ldo_control = dw_2 then
	li_row = dw_2.GetRow()
	if li_row > 0 then
      dw_2.RowsMove(li_row,li_row, Primary!,dw_3, dw_3.rowcount() + 1, Primary!)		
	end if
end if


end event

event rowfocuschanged;if currentrow > 0 then 
	selectrow(0,false)
	selectrow(1,true)
end if
end event

event doubleclicked;if row < 1 then ; return ; end if
if this.GetItemString(row,"a_check") = 'Y' THEN
	this.SetItem(row,"a_check","N")
ELSE
	this.SetItem(row,"a_check","Y")
END IF
end event

event clicked;if row > 0 then
   this.SelectRow(0,False)
   this.SelectRow(row,True)
   this.setfocus()
end if
end event

event losefocus;this.SelectRow(0,False)
end event

type st_3 from so_statictext within w_sort
integer x = 1893
integer y = 456
integer width = 279
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 128
boolean enabled = false
string text = "ASC"
alignment alignment = right!
end type

