HA$PBExportHeader$w_graph_color.srw
$PBExportComments$General response window for modifying the graph colors
forward
global type w_graph_color from w_none_dw_main_root
end type
type em_series from editmask within w_graph_color
end type
type cb_cancel from commandbutton within w_graph_color
end type
type rb_graph_textcolor from radiobutton within w_graph_color
end type
type rb_graph_background from radiobutton within w_graph_color
end type
type rb_series_background from radiobutton within w_graph_color
end type
type rb_series_foreground from radiobutton within w_graph_color
end type
type uo_color_select from uo_color_selection within w_graph_color
end type
type cb_ok from commandbutton within w_graph_color
end type
type gb_2 from groupbox within w_graph_color
end type
type gb_1 from groupbox within w_graph_color
end type
end forward

global type w_graph_color from w_none_dw_main_root
integer x = 375
integer y = 252
integer width = 2167
integer height = 656
string title = "Select Graph Colors"
windowtype windowtype = response!
long backcolor = 74481808
toolbaralignment toolbaralignment = alignatleft!
em_series em_series
cb_cancel cb_cancel
rb_graph_textcolor rb_graph_textcolor
rb_graph_background rb_graph_background
rb_series_background rb_series_background
rb_series_foreground rb_series_foreground
uo_color_select uo_color_select
cb_ok cb_ok
gb_2 gb_2
gb_1 gb_1
end type
global w_graph_color w_graph_color

type variables
graph igr_parm
datawindow idw_parm
string is_series_name
long il_backcolor, il_textcolor, il_serbackcolor []
long il_serforecolor []
long il_seriescount
object io_passed
end variables

event open;call super::open;//This will change the color of a graph that was passed in the message.powerobjectparm
//The graph may be in a datawindow or a graph object in a window.


//There are two sections of changes depending if the object passed
//was a graph or datawindow

int 		li_index
long		ll_gr_color
string	ls_series_name 

//get the object and test what type of object was passed
//the type of object will be stored in io_passed

graphicobject lgro_hold
lgro_hold =  message.powerobjectparm

//graph object was passed ?
If lgro_hold.TypeOf( ) = Graph! Then
	io_passed = Graph!
	igr_parm = message.powerobjectparm

	//set the series spin control
	//allow modifing multiple series within a graph
	il_seriescount = igr_parm.SeriesCount()


	//keep a copy of the graph for the cancel button
	il_backcolor = igr_parm.backcolor 
	il_textcolor = igr_parm.textcolor 
	For li_index = 1 to il_seriescount
		is_series_name = igr_parm.SeriesName (li_index)		
		igr_parm.getSeriesStyle ( is_series_name, background!, il_serbackcolor[li_index])
		igr_parm.getSeriesStyle ( is_series_name, foreground!, il_serforecolor[li_index])
	Next

	// Set the color selector user object to the series foreground color,
	// since that radio button starts out selected.
	is_series_name = igr_parm.SeriesName (1)
	igr_parm.getseriesstyle (is_series_name,foreground!, ll_gr_color)


//datawindow object was passed
Elseif lgro_hold.TypeOf( ) = Datawindow! Then
	io_passed = datawindow!
	idw_parm = message.powerobjectparm

	//set the series spin control
	//allow modifing multiple series within a graph
	il_seriescount = idw_parm.SeriesCount("gr_1")

	//keep a copy of the graph for the cancel button
	string ls_backcolor, ls_textcolor
	ls_backcolor = idw_parm.Object.gr_1.backcolor
	ls_textcolor = idw_parm.Object.gr_1.color
	il_backcolor = long(ls_backcolor)
	il_textcolor = long(ls_textcolor)
	For li_index = 1 to il_seriescount
		is_series_name = idw_parm.SeriesName ("gr_1", li_index)		
		idw_parm.getSeriesStyle ( "gr_1",is_series_name, background!, il_serbackcolor[li_index])
		idw_parm.getSeriesStyle ( "gr_1",is_series_name, foreground!, il_serforecolor[li_index])
	Next

	// Set the color selector user object to the series foreground color,
	// since that radio button starts out selected.
	is_series_name = idw_parm.SeriesName ("gr_1",1)
	idw_parm.getseriesstyle ("gr_1", is_series_name, foreground!, ll_gr_color)
End If

//modify the minmax of the series counter
If il_seriescount > 1 Then
	em_series.minmax = "1~~" + String(il_seriescount)
	em_series.enabled = true
End If

//set the color bar to the this foreground graph color
uo_color_select.uf_set_rgb (ll_gr_color)





end event

on w_graph_color.create
int iCurrent
call super::create
this.em_series=create em_series
this.cb_cancel=create cb_cancel
this.rb_graph_textcolor=create rb_graph_textcolor
this.rb_graph_background=create rb_graph_background
this.rb_series_background=create rb_series_background
this.rb_series_foreground=create rb_series_foreground
this.uo_color_select=create uo_color_select
this.cb_ok=create cb_ok
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_series
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.rb_graph_textcolor
this.Control[iCurrent+4]=this.rb_graph_background
this.Control[iCurrent+5]=this.rb_series_background
this.Control[iCurrent+6]=this.rb_series_foreground
this.Control[iCurrent+7]=this.uo_color_select
this.Control[iCurrent+8]=this.cb_ok
this.Control[iCurrent+9]=this.gb_2
this.Control[iCurrent+10]=this.gb_1
end on

on w_graph_color.destroy
call super::destroy
destroy(this.em_series)
destroy(this.cb_cancel)
destroy(this.rb_graph_textcolor)
destroy(this.rb_graph_background)
destroy(this.rb_series_background)
destroy(this.rb_series_foreground)
destroy(this.uo_color_select)
destroy(this.cb_ok)
destroy(this.gb_2)
destroy(this.gb_1)
end on

type em_series from editmask within w_graph_color
event ue_emchanged pbm_enchange
integer x = 1769
integer y = 356
integer width = 183
integer height = 100
integer taborder = 70
integer textsize = -9
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
boolean enabled = false
string text = "1"
boolean displayonly = true
borderstyle borderstyle = stylelowered!
string mask = "###,###."
boolean spin = true
double increment = 1
string minmax = "1~~1"
end type

on ue_emchanged;//Get new series name

If io_passed = Graph! Then
	is_series_name = igr_parm.SeriesName (integer(em_series.text))
Elseif io_passed = Datawindow! Then
	is_series_name = idw_parm.SeriesName ("gr_1", integer(em_series.text))
End If

If rb_series_background.checked Then rb_series_background.TriggerEvent("clicked")
If rb_series_foreground.checked Then rb_series_foreground.TriggerEvent("clicked")

end on

type cb_cancel from commandbutton within w_graph_color
integer x = 1719
integer y = 160
integer width = 297
integer height = 100
integer taborder = 20
integer textsize = -9
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Cancel"
boolean cancel = true
end type

event clicked;// Restore the 4 changable colors to their original color

//There are two sections of changes depending if the object passed
//was a graph or datawindow
int li_index

If io_passed = Graph! Then
	igr_parm.Setredraw (false)
	igr_parm.backcolor = il_backcolor
	igr_parm.textcolor = il_textcolor

	//cycle thru the series restoring each attribute of the series
	For li_index = 1 to il_seriescount
		is_series_name = igr_parm.SeriesName(li_index)
		igr_parm.SetSeriesStyle ( is_series_name, background!, il_serbackcolor[li_index])
		igr_parm.SetSeriesStyle ( is_series_name, foreground!, il_serforecolor[li_index])
	Next
	igr_parm.Setredraw (true)
Elseif io_passed = Datawindow! Then
	idw_parm.Setredraw (false)
	idw_parm.Object.gr_1.backcolor = string(il_backcolor)
	idw_parm.Object.gr_1.color = string(il_textcolor)
	
	//cycle thru the series restoring each attribute of the series
	For li_index = 1 to il_seriescount
		is_series_name = idw_parm.SeriesName("gr_1",li_index)
		idw_parm.SetSeriesStyle ( "gr_1", is_series_name, background!,il_serbackcolor[li_index])
		idw_parm.SetSeriesStyle ( "gr_1", is_series_name, foreground!,il_serforecolor[li_index])
	Next
	idw_parm.Setredraw (true)
End if



Close (parent)
end event

type rb_graph_textcolor from radiobutton within w_graph_color
integer x = 937
integer y = 360
integer width = 645
integer height = 72
integer taborder = 60
integer textsize = -9
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 74481808
string text = "Graph Gridlines"
end type

event clicked;// Get this color type from the graph and set the color in the color
// selector user object.

//There are two sections of changes depending if the object passed
//was a graph or datawindow

string ls_color

If io_passed = Graph! Then
	uo_color_select.uf_set_rgb (igr_parm.textcolor)
Elseif io_passed = Datawindow! Then
	ls_color = idw_parm.Object.gr_1.color
	uo_color_select.uf_set_rgb (Long(ls_color))
End if
end event

type rb_graph_background from radiobutton within w_graph_color
integer x = 937
integer y = 272
integer width = 663
integer height = 72
integer taborder = 40
integer textsize = -9
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 74481808
string text = "Graph Background"
end type

event clicked;// Get this color type from the graph and set the color in the color
// selector user object.
//There are two sections of changes depending if the object passed
//was a graph or datawindow

string ls_backcolor

If io_passed = Graph! Then
	uo_color_select.uf_set_rgb (igr_parm.backcolor)
Elseif io_passed = Datawindow! Then
	ls_backcolor = idw_parm.Object.gr_1.backcolor
	uo_color_select.uf_set_rgb (long(ls_backcolor))
End If
end event

type rb_series_background from radiobutton within w_graph_color
integer x = 937
integer y = 184
integer width = 645
integer height = 72
integer taborder = 30
integer textsize = -9
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 74481808
string text = "Series Outline "
end type

on clicked;long ll_grcolor

// Get this color type from the graph and set the color in the color
// selector user object.

//There are two sections of changes depending if the object passed
//was a graph or datawindow

If io_passed = Graph! Then
	igr_parm.getseriesstyle (is_series_name,background!, ll_grcolor)
Elseif io_passed = Datawindow! Then
	idw_parm.getseriesstyle ("gr_1", is_series_name,background!, ll_grcolor)
End if
uo_color_select.uf_set_rgb (ll_grcolor)

end on

type rb_series_foreground from radiobutton within w_graph_color
integer x = 937
integer y = 96
integer width = 645
integer height = 72
integer taborder = 10
integer textsize = -9
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 74481808
string text = "Series Fill "
boolean checked = true
end type

on clicked;long ll_grcolor

// Get this color type from the graph and set the color in the color
// selector user object.

//There are two sections of changes depending if the object passed
//was a graph or datawindow

If io_passed = Graph! Then
	igr_parm.getseriesstyle (is_series_name,foreground!, ll_grcolor)
Elseif io_passed = Datawindow! Then
	idw_parm.getseriesstyle ("gr_1", is_series_name, foreground!, ll_grcolor)
End if

uo_color_select.uf_set_rgb (ll_grcolor)

end on

type uo_color_select from uo_color_selection within w_graph_color
integer x = 64
integer y = 36
integer taborder = 80
end type

event color_changed;call uo_color_selection::color_changed;string ls_new_color
long ll_color_hold

//There are two sections of changes depending if the object passed
//was a graph or datawindow
// When the color is changed, change the appropriate color in the
// graph, depending on which radio button is checked currently.

//graph
If io_passed = Graph! Then
	igr_parm.setredraw(false)

	//find out which attribute to change 
	If rb_graph_background.checked then
		igr_parm.backcolor = uo_color_select.uf_get_rgb()
	Elseif rb_graph_textcolor.checked then
		igr_parm.textcolor = uo_color_select.uf_get_rgb()
	Elseif rb_series_background.checked then
		igr_parm.SetSeriesStyle ( is_series_name, background!,& 
										uo_color_select.uf_get_rgb())
	Elseif rb_series_foreground.checked then
		igr_parm.SetSeriesStyle ( is_series_name, foreground!,& 
										uo_color_select.uf_get_rgb())
	End If
	igr_parm.setredraw(true)

//datawindow
Elseif io_passed = Datawindow! Then
	
	idw_parm.setredraw(false)

	//get new color
	ls_new_color = string (uo_color_select.uf_get_rgb())

	//find out which attribute to change 
	If rb_graph_background.checked then
		idw_parm.Object.gr_1.backcolor = ls_new_color
		
	Elseif rb_graph_textcolor.checked then

		idw_parm.getSeriesStyle ( "gr_1", is_series_name, background!, ll_color_hold)
		idw_parm.Object.gr_1.color = ls_new_color
		idw_parm.setredraw(true)
		idw_parm.SetSeriesStyle ( "gr_1", is_series_name, background!,	ll_color_hold)
		idw_parm.setredraw(false)

	Elseif rb_series_background.checked then
		idw_parm.SetSeriesStyle ( "gr_1", is_series_name, background!,& 
										uo_color_select.uf_get_rgb())
	Elseif rb_series_foreground.checked then
		idw_parm.SetSeriesStyle ( "gr_1", is_series_name, foreground!,& 
										uo_color_select.uf_get_rgb())
	End If 
	idw_parm.setredraw(true)
End If
end event

on uo_color_select.destroy
call uo_color_selection::destroy
end on

type cb_ok from commandbutton within w_graph_color
integer x = 1719
integer y = 40
integer width = 297
integer height = 100
integer taborder = 90
integer textsize = -9
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "OK"
boolean default = true
end type

on clicked;Close (parent)
end on

type gb_2 from groupbox within w_graph_color
integer x = 1719
integer y = 288
integer width = 293
integer height = 196
integer taborder = 50
integer textsize = -9
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 74481808
string text = "Series #"
end type

type gb_1 from groupbox within w_graph_color
integer x = 901
integer y = 8
integer width = 741
integer height = 480
integer textsize = -9
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 74481808
string text = "Items to Change"
end type

