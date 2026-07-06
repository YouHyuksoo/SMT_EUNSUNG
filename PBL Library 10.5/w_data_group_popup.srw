HA$PBExportHeader$w_data_group_popup.srw
forward
global type w_data_group_popup from w_none_dw_popup_root
end type
type st_1 from so_statictext within w_data_group_popup
end type
type st_2 from so_statictext within w_data_group_popup
end type
type plb_column_list from so_picturelistbox within w_data_group_popup
end type
type st_3 from so_statictext within w_data_group_popup
end type
type plb_group_by from so_picturelistbox within w_data_group_popup
end type
type plb_value from so_picturelistbox within w_data_group_popup
end type
type cb_1 from so_commandbutton within w_data_group_popup
end type
type rb_1 from so_radiobutton within w_data_group_popup
end type
type rb_2 from so_radiobutton within w_data_group_popup
end type
type rb_3 from so_radiobutton within w_data_group_popup
end type
type rb_4 from so_radiobutton within w_data_group_popup
end type
type cb_2 from so_commandbutton within w_data_group_popup
end type
type gb_1 from so_groupbox within w_data_group_popup
end type
end forward

global type w_data_group_popup from w_none_dw_popup_root
integer width = 2569
integer height = 1888
string title = "Data Group Popup"
boolean minbox = true
windowtype windowtype = popup!
boolean contexthelp = false
st_1 st_1
st_2 st_2
plb_column_list plb_column_list
st_3 st_3
plb_group_by plb_group_by
plb_value plb_value
cb_1 cb_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
cb_2 cb_2
gb_1 gb_1
end type
global w_data_group_popup w_data_group_popup

type variables
Boolean ib_down
Integer ivi_index
end variables

on w_data_group_popup.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
this.plb_column_list=create plb_column_list
this.st_3=create st_3
this.plb_group_by=create plb_group_by
this.plb_value=create plb_value
this.cb_1=create cb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.cb_2=create cb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.plb_column_list
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.plb_group_by
this.Control[iCurrent+6]=this.plb_value
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.rb_1
this.Control[iCurrent+9]=this.rb_2
this.Control[iCurrent+10]=this.rb_3
this.Control[iCurrent+11]=this.rb_4
this.Control[iCurrent+12]=this.cb_2
this.Control[iCurrent+13]=this.gb_1
end on

on w_data_group_popup.destroy
call super::destroy
destroy(this.st_1)
destroy(this.st_2)
destroy(this.plb_column_list)
destroy(this.st_3)
destroy(this.plb_group_by)
destroy(this.plb_value)
destroy(this.cb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.cb_2)
destroy(this.gb_1)
end on

event open;call super::open;datawindow ARG_DW
String   	lvs_col_name , lvs_col_mean , ls_datatype
Integer		lvi_count

ARG_DW = MESSAGE.POWEROBJECTPARM
plb_group_by.Reset()

Gst_dw_colinfo.i_dw_colcount = 0
Gst_dw_colinfo.i_dw_colcount=Integer(  ARG_DW.Describe("DataWindow.Column.Count"))

For lvi_count = 1 to Gst_dw_colinfo.i_dw_colcount
	
	lvs_col_name = ''
	
	lvs_col_name	= ARG_DW.Describe('#'+String(lvi_count)+".Name")	
	lvs_col_mean   = ARG_DW.Describe(lvs_col_name+"_t.Text")	
	
		if ARG_DW.Describe(lvs_col_name + ".type") = "column" then
			ls_datatype = ARG_DW.Describe(lvs_col_name + ".coltype")
				if left(ls_datatype, 4) = "char"  then
					plb_column_list.additem(lvs_col_name+'('+lvs_col_mean+')' , 1 )
				elseif ls_datatype = "datetime" or ls_datatype = "date" then
					plb_column_list.additem(lvs_col_name+'('+lvs_col_mean+')' , 3 )
			     elseif ls_datatype = "int" or ls_datatype = "long" or ls_datatype = "number" or left(ls_datatype,7) = "decimal" then
					plb_column_list.additem(lvs_col_name+'('+lvs_col_mean+')' , 2 )
			     end if
		end if	
	
Next


end event

type p_title from w_none_dw_popup_root`p_title within w_data_group_popup
integer width = 2546
end type

type cb_close from w_none_dw_popup_root`cb_close within w_data_group_popup
boolean visible = true
integer x = 2231
integer y = 1684
integer taborder = 40
end type

type st_msg from w_none_dw_popup_root`st_msg within w_data_group_popup
boolean visible = true
integer x = 5
integer y = 240
integer width = 2546
end type

type st_1 from so_statictext within w_data_group_popup
integer x = 1317
integer y = 348
integer width = 1193
boolean bringtotop = true
integer weight = 700
string text = "Group By"
alignment alignment = left!
end type

type st_2 from so_statictext within w_data_group_popup
integer x = 1317
integer y = 1096
integer width = 1193
boolean bringtotop = true
integer weight = 700
string text = "Value"
alignment alignment = left!
end type

type plb_column_list from so_picturelistbox within w_data_group_popup
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
event ue_mousemove pbm_mousemove
integer x = 73
integer y = 428
integer width = 1193
integer height = 1248
integer taborder = 10
string dragicon = "DataPipeline!"
boolean bringtotop = true
integer textsize = -8
string pointer = "hand.cur"
boolean hscrollbar = true
boolean vscrollbar = true
boolean multiselect = true
boolean extendedselect = true
string picturename[] = {"DataManip!","ComputeSum!","ComputeToday5!"}
long picturemaskcolor = 12632256
end type

event ue_lbuttondown;ib_down = true
end event

event ue_lbuttonup;ib_down= false
end event

event ue_mousemove;if selecteditem() = '' then 
	Return
end if
if ib_down = true then 
	Drag(begin!)
end if

st_msg.text = selecteditem()
end event

event dragdrop;call super::dragdrop;picturelistbox iplb_source
if source.Typeof() = picturelistbox! then
	
   iplb_source = 	source
   this.InsertItem(  iplb_source.selecteditem() , 1,0)
   iplb_source.DeleteItem(  iplb_source.SelectedIndex ( ))	
end if
end event

type st_3 from so_statictext within w_data_group_popup
integer x = 82
integer y = 344
integer width = 1193
boolean bringtotop = true
integer weight = 700
string text = "Column List"
alignment alignment = left!
end type

type plb_group_by from so_picturelistbox within w_data_group_popup
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
event ue_mousemove pbm_mousemove
integer x = 1312
integer y = 428
integer width = 1193
integer height = 592
integer taborder = 10
string dragicon = "DataPipeline!"
boolean bringtotop = true
integer textsize = -8
string pointer = "hand.cur"
boolean hscrollbar = true
boolean vscrollbar = true
boolean sorted = false
string picturename[] = {"DataManip!"}
long picturemaskcolor = 12632256
end type

event ue_lbuttondown;ib_down = true
end event

event ue_lbuttonup;ib_down= false
end event

event ue_mousemove;if selecteditem() = '' then 
	Return
end if
if ib_down = true then 
	Drag(begin!)
end if

st_msg.text = selecteditem()
end event

event dragdrop;call super::dragdrop;picturelistbox iplb_source
if source.Typeof() = picturelistbox! then
	
   iplb_source = 	source
   this.InsertItem(  iplb_source.selecteditem() , 1,ivi_index)
   iplb_source.DeleteItem(  iplb_source.SelectedIndex ( ))	
end if
end event

event dragwithin;call super::dragwithin;if index < 0 then 
	ivi_index = 0
else
	ivi_index = index
end if

end event

type plb_value from so_picturelistbox within w_data_group_popup
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
event ue_mousemove pbm_mousemove
integer x = 1317
integer y = 1300
integer width = 1193
integer height = 372
integer taborder = 20
string dragicon = "DataPipeline!"
boolean bringtotop = true
integer textsize = -8
string pointer = "hand.cur"
boolean hscrollbar = true
boolean vscrollbar = true
boolean sorted = false
string picturename[] = {"ComputeSum!"}
long picturemaskcolor = 12632256
end type

event ue_lbuttondown;ib_down = true
end event

event ue_lbuttonup;ib_down= false
end event

event ue_mousemove;if selecteditem() = '' then 
	Return
end if
if ib_down = true then 
	Drag(begin!)
end if

st_msg.text = selecteditem()
end event

event dragdrop;call super::dragdrop;picturelistbox iplb_source
if source.Typeof() = picturelistbox! then
	
   iplb_source = 	source
   this.InsertItem(  iplb_source.selecteditem() , 1,ivi_index)
   iplb_source.DeleteItem(  iplb_source.SelectedIndex ( ))	
end if
end event

event dragwithin;call super::dragwithin;if index < 0 then 
	ivi_index = 0
else
	ivi_index = index
end if

end event

type cb_1 from so_commandbutton within w_data_group_popup
integer x = 1957
integer y = 1684
integer width = 274
integer height = 100
integer taborder = 50
boolean bringtotop = true
string text = "Apply"
end type

event clicked;call super::clicked;Int i
string lvs_item , newsort , null_str
newsort = ""


if  plb_group_by.TotalItems() = 0  then 
		
		SetNull(null_str)
		selected_data_window.SetSort(null_str)
		selected_data_window.Sort( )	
	
end if


do 
	i++
	lvs_item = Mid (  plb_group_by.Text (i) , 1 , Pos( plb_group_by.Text (i) , "(" ) - 1 )
	
	newsort = newsort + lvs_item+','
		
Loop until i = plb_group_by.TotalItems()


newsort = Mid( newsort , 1 , Len(newsort) -1 ) 

st_msg.text = newsort

selected_data_window.SetSort(newsort)
selected_data_window.Sort( )



end event

type rb_1 from so_radiobutton within w_data_group_popup
integer x = 1344
integer y = 1208
integer width = 279
boolean bringtotop = true
string text = "Sum"
boolean checked = true
end type

type rb_2 from so_radiobutton within w_data_group_popup
integer x = 1659
integer y = 1208
integer width = 274
boolean bringtotop = true
string text = "Avg"
end type

type rb_3 from so_radiobutton within w_data_group_popup
integer x = 1957
integer y = 1212
integer width = 279
boolean bringtotop = true
string text = "Max"
end type

type rb_4 from so_radiobutton within w_data_group_popup
integer x = 2254
integer y = 1208
integer width = 242
boolean bringtotop = true
string text = "Min"
end type

type cb_2 from so_commandbutton within w_data_group_popup
integer x = 1678
integer y = 1684
integer width = 274
integer height = 100
integer taborder = 60
boolean bringtotop = true
string text = "OK"
end type

type gb_1 from so_groupbox within w_data_group_popup
integer x = 1321
integer y = 1168
integer width = 1184
integer height = 128
integer taborder = 20
end type

