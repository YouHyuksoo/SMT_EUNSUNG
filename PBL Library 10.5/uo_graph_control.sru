HA$PBExportHeader$uo_graph_control.sru
forward
global type uo_graph_control from userobject
end type
type st_10 from statictext within uo_graph_control
end type
type ddlb_legend from uo_basecode within uo_graph_control
end type
type htb_spacing from htrackbar within uo_graph_control
end type
type st_9 from so_statictext within uo_graph_control
end type
type st_8 from so_statictext within uo_graph_control
end type
type htb_depth from htrackbar within uo_graph_control
end type
type htb_rotation from htrackbar within uo_graph_control
end type
type st_7 from so_statictext within uo_graph_control
end type
type st_6 from so_statictext within uo_graph_control
end type
type htb_elevation from htrackbar within uo_graph_control
end type
type htb_perspective from htrackbar within uo_graph_control
end type
type st_5 from so_statictext within uo_graph_control
end type
type pb_spacing from so_picturebutton within uo_graph_control
end type
type pb_title from so_picturebutton within uo_graph_control
end type
type pb_color from so_picturebutton within uo_graph_control
end type
type pb_type from so_picturebutton within uo_graph_control
end type
end forward

global type uo_graph_control from userobject
integer width = 1742
integer height = 312
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
st_10 st_10
ddlb_legend ddlb_legend
htb_spacing htb_spacing
st_9 st_9
st_8 st_8
htb_depth htb_depth
htb_rotation htb_rotation
st_7 st_7
st_6 st_6
htb_elevation htb_elevation
htb_perspective htb_perspective
st_5 st_5
pb_spacing pb_spacing
pb_title pb_title
pb_color pb_color
pb_type pb_type
end type
global uo_graph_control uo_graph_control

type variables


end variables

on uo_graph_control.create
this.st_10=create st_10
this.ddlb_legend=create ddlb_legend
this.htb_spacing=create htb_spacing
this.st_9=create st_9
this.st_8=create st_8
this.htb_depth=create htb_depth
this.htb_rotation=create htb_rotation
this.st_7=create st_7
this.st_6=create st_6
this.htb_elevation=create htb_elevation
this.htb_perspective=create htb_perspective
this.st_5=create st_5
this.pb_spacing=create pb_spacing
this.pb_title=create pb_title
this.pb_color=create pb_color
this.pb_type=create pb_type
this.Control[]={this.st_10,&
this.ddlb_legend,&
this.htb_spacing,&
this.st_9,&
this.st_8,&
this.htb_depth,&
this.htb_rotation,&
this.st_7,&
this.st_6,&
this.htb_elevation,&
this.htb_perspective,&
this.st_5,&
this.pb_spacing,&
this.pb_title,&
this.pb_color,&
this.pb_type}
end on

on uo_graph_control.destroy
destroy(this.st_10)
destroy(this.ddlb_legend)
destroy(this.htb_spacing)
destroy(this.st_9)
destroy(this.st_8)
destroy(this.htb_depth)
destroy(this.htb_rotation)
destroy(this.st_7)
destroy(this.st_6)
destroy(this.htb_elevation)
destroy(this.htb_perspective)
destroy(this.st_5)
destroy(this.pb_spacing)
destroy(this.pb_title)
destroy(this.pb_color)
destroy(this.pb_type)
end on

type st_10 from statictext within uo_graph_control
integer x = 1015
integer y = 212
integer width = 270
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
boolean enabled = false
string text = "Legend"
alignment alignment = right!
boolean focusrectangle = false
end type

type ddlb_legend from uo_basecode within uo_graph_control
integer x = 1349
integer y = 204
integer width = 384
integer height = 432
integer taborder = 50
boolean bringtotop = true
long backcolor = 67108864
end type

event getfocus;call super::getfocus;this.redraw( 'LEGEND')
end event

event selectionchanged;call super::selectionchanged;IF THIS.GETCODE() = 'ATBOTTOM' THEN 
	selected_data_window.object.GR_1.LEGEND = AtBottom!
ELSEIF  THIS.GETCODE() = 'ATTOP' THEN 
	selected_data_window.object.GR_1.LEGEND = AtTop!
ELSEIF  THIS.GETCODE() = 'ATLEFT' THEN 
	selected_data_window.object.GR_1.LEGEND = AtLeft!	
ELSEIF  THIS.GETCODE() = 'ATRIGHT' THEN 
	selected_data_window.object.GR_1.LEGEND = AtRight!		
END IF
end event

type htb_spacing from htrackbar within uo_graph_control
integer x = 1317
integer y = 104
integer width = 434
integer height = 88
boolean bringtotop = true
integer minposition = -360
integer maxposition = 360
integer position = 100
integer tickfrequency = 10
end type

event moved;selected_data_window.object.gr_1.spacing = scrollpos
end event

type st_9 from so_statictext within uo_graph_control
integer x = 1015
integer y = 104
integer width = 270
integer height = 68
boolean bringtotop = true
integer weight = 700
long backcolor = 67108864
string text = "Sapcing"
alignment alignment = right!
end type

type st_8 from so_statictext within uo_graph_control
integer x = 1015
integer y = 24
integer width = 270
integer height = 68
boolean bringtotop = true
integer weight = 700
long backcolor = 67108864
string text = "Depth"
alignment alignment = right!
end type

type htb_depth from htrackbar within uo_graph_control
integer x = 1317
integer y = 16
integer width = 434
integer height = 88
boolean bringtotop = true
integer minposition = -360
integer maxposition = 360
integer position = 100
integer tickfrequency = 10
end type

event moved;selected_data_window.object.gr_1.depth = scrollpos
end event

type htb_rotation from htrackbar within uo_graph_control
integer x = 571
integer y = 216
integer width = 434
integer height = 88
boolean bringtotop = true
integer minposition = -360
integer maxposition = 360
integer position = -20
integer tickfrequency = 10
end type

event moved;selected_data_window.object.gr_1.Rotation = scrollpos
end event

type st_7 from so_statictext within uo_graph_control
integer x = 256
integer y = 212
integer width = 311
integer height = 68
boolean bringtotop = true
integer weight = 700
long backcolor = 67108864
string text = "Rotation"
alignment alignment = right!
end type

type st_6 from so_statictext within uo_graph_control
integer x = 256
integer y = 124
integer width = 311
integer height = 68
boolean bringtotop = true
integer weight = 700
long backcolor = 67108864
string text = "Elevation"
alignment alignment = right!
end type

type htb_elevation from htrackbar within uo_graph_control
integer x = 571
integer y = 120
integer width = 434
integer height = 88
boolean bringtotop = true
integer minposition = -360
integer maxposition = 360
integer position = 20
integer tickfrequency = 10
end type

event moved;selected_data_window.object.gr_1.elevation = scrollpos
end event

type htb_perspective from htrackbar within uo_graph_control
integer x = 571
integer y = 24
integer width = 434
integer height = 88
boolean bringtotop = true
integer minposition = -360
integer maxposition = 360
integer position = 2
integer tickfrequency = 10
end type

event moved;selected_data_window.object.gr_1.perspective = scrollpos
end event

type st_5 from so_statictext within uo_graph_control
integer x = 256
integer y = 24
integer width = 311
integer height = 92
boolean bringtotop = true
integer weight = 700
long backcolor = 67108864
string text = "Perspective"
alignment alignment = right!
end type

type pb_spacing from so_picturebutton within uo_graph_control
integer x = 128
integer y = 148
integer width = 101
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
boolean originalsize = false
string picturename = "SpaceHorizontal!"
boolean map3dcolors = true
string powertiptext = "Graph Spacing..."
end type

event clicked;SetPointer(HourGlass!)

// Open the response window to set spacing. Pass it the graph so it
// can make changes.
OpenWithParm (w_graph_spacing, selected_data_window)

end event

type pb_title from so_picturebutton within uo_graph_control
integer x = 128
integer y = 56
integer width = 101
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
boolean originalsize = false
string picturename = "StaticText!"
boolean map3dcolors = true
string powertiptext = "Graph Title..."
end type

event clicked;SetPointer(HourGlass!)

// Open a response window to prompt for the new graph title. Pass the
// graph object as a parameter. The response window will handle the 
// rest.
OpenWithParm (w_graph_title, selected_data_window )

end event

type pb_color from so_picturebutton within uo_graph_control
integer x = 9
integer y = 148
integer width = 101
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
boolean originalsize = false
string picturename = "ArrangeIcons!"
boolean map3dcolors = true
string powertiptext = "Graph Color..."
end type

event clicked;SetPointer(HourGlass!)

//open the change color window and pass the graph to it in the 
//message.powerobjectparm

if isvalid(selected_data_window) then 
	OpenWithParm (w_graph_color,selected_data_window)
end if 
end event

type pb_type from so_picturebutton within uo_graph_control
integer x = 9
integer y = 60
integer width = 101
integer height = 88
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
boolean originalsize = false
string picturename = "Graph!"
alignment htextalign = center!
vtextalign vtextalign = multiline!
boolean map3dcolors = true
string powertiptext = "Graph Type..."
end type

event clicked;SetPointer(HourGlass!)

// Open the response window to set the graph type. Pass it the graph
// object and it will do the rest.
OpenWithParm (w_graph_type, selected_data_window )
end event

