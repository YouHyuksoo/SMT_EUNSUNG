HA$PBExportHeader$w_graph_properties_popup.srw
$PBExportComments$Dynamic Graph Popup
forward
global type w_graph_properties_popup from w_none_dw_popup_root
end type
type tab_1 from tab within w_graph_properties_popup
end type
type tabpage_5 from userobject within tab_1
end type
type uo_graph_type from uo_graph_gallery within tabpage_5
end type
type tabpage_5 from userobject within tab_1
uo_graph_type uo_graph_type
end type
type tabpage_2 from userobject within tab_1
end type
type st_16 from so_statictext within tabpage_2
end type
type em_8 from editmask within tabpage_2
end type
type st_14 from so_statictext within tabpage_2
end type
type em_6 from editmask within tabpage_2
end type
type em_category_escapement from editmask within tabpage_2
end type
type st_4 from so_statictext within tabpage_2
end type
type em_5 from so_editmask within tabpage_2
end type
type st_13 from so_statictext within tabpage_2
end type
type em_4 from so_editmask within tabpage_2
end type
type st_12 from so_statictext within tabpage_2
end type
type tabpage_2 from userobject within tab_1
st_16 st_16
em_8 em_8
st_14 st_14
em_6 em_6
em_category_escapement em_category_escapement
st_4 st_4
em_5 em_5
st_13 st_13
em_4 em_4
st_12 st_12
end type
type tabpage_1 from userobject within tab_1
end type
type em_7 from editmask within tabpage_1
end type
type st_15 from so_statictext within tabpage_1
end type
type em_2 from so_editmask within tabpage_1
end type
type st_3 from so_statictext within tabpage_1
end type
type em_3 from so_editmask within tabpage_1
end type
type st_11 from so_statictext within tabpage_1
end type
type em_1 from so_editmask within tabpage_1
end type
type st_2 from so_statictext within tabpage_1
end type
type tabpage_1 from userobject within tab_1
em_7 em_7
st_15 st_15
em_2 em_2
st_3 st_3
em_3 em_3
st_11 st_11
em_1 em_1
st_2 st_2
end type
type tabpage_6 from userobject within tab_1
end type
type ddlb_legend from uo_basecode within tabpage_6
end type
type st_10 from statictext within tabpage_6
end type
type tabpage_6 from userobject within tab_1
ddlb_legend ddlb_legend
st_10 st_10
end type
type tabpage_3 from userobject within tab_1
end type
type htb_spacing from htrackbar within tabpage_3
end type
type st_9 from so_statictext within tabpage_3
end type
type st_8 from so_statictext within tabpage_3
end type
type htb_depth from htrackbar within tabpage_3
end type
type st_7 from so_statictext within tabpage_3
end type
type htb_rotation from htrackbar within tabpage_3
end type
type st_6 from so_statictext within tabpage_3
end type
type htb_elevation from htrackbar within tabpage_3
end type
type htb_perspective from htrackbar within tabpage_3
end type
type st_5 from so_statictext within tabpage_3
end type
type tabpage_3 from userobject within tab_1
htb_spacing htb_spacing
st_9 st_9
st_8 st_8
htb_depth htb_depth
st_7 st_7
htb_rotation htb_rotation
st_6 st_6
htb_elevation htb_elevation
htb_perspective htb_perspective
st_5 st_5
end type
type tabpage_4 from userobject within tab_1
end type
type sle_graph_title from so_singlelineedit within tabpage_4
end type
type st_1 from so_statictext within tabpage_4
end type
type cb_1 from so_commandbutton within tabpage_4
end type
type tabpage_4 from userobject within tab_1
sle_graph_title sle_graph_title
st_1 st_1
cb_1 cb_1
end type
type tab_1 from tab within w_graph_properties_popup
tabpage_5 tabpage_5
tabpage_2 tabpage_2
tabpage_1 tabpage_1
tabpage_6 tabpage_6
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type
end forward

global type w_graph_properties_popup from w_none_dw_popup_root
integer width = 2272
integer height = 1520
long backcolor = 67108864
boolean contexthelp = false
tab_1 tab_1
end type
global w_graph_properties_popup w_graph_properties_popup

type variables
graph igr_parm
datawindow idw_parm
object io_passed
end variables

on w_graph_properties_popup.create
int iCurrent
call super::create
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_graph_properties_popup.destroy
call super::destroy
destroy(this.tab_1)
end on

event open;call super::open;// Receive and remember in the igr_parm or idw_parm instance variable, the
// object that has been passed by the window that opened this.
//f_set_layered_window( handle(this) , 85 )
graphicobject lgro_hold

lgro_hold = message.powerobjectparm

If lgro_hold.TypeOf() = Graph! Then
	io_passed = Graph!
	igr_parm = message.powerobjectparm
Elseif lgro_hold.TypeOf() = Datawindow! Then
	io_passed = Datawindow!
	idw_parm = message.powerobjectparm
End If

end event

type p_title from w_none_dw_popup_root`p_title within w_graph_properties_popup
integer width = 2258
integer height = 144
end type

type cb_close from w_none_dw_popup_root`cb_close within w_graph_properties_popup
integer x = 32
integer y = 2296
end type

type st_msg from w_none_dw_popup_root`st_msg within w_graph_properties_popup
integer y = 1344
integer width = 2254
long backcolor = 67108864
end type

type tab_1 from tab within w_graph_properties_popup
integer y = 160
integer width = 2258
integer height = 1180
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
boolean fixedwidth = true
boolean raggedright = true
boolean focusonbuttondown = true
boolean powertips = true
boolean boldselectedtext = true
alignment alignment = center!
integer selectedtab = 1
tabpage_5 tabpage_5
tabpage_2 tabpage_2
tabpage_1 tabpage_1
tabpage_6 tabpage_6
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type

on tab_1.create
this.tabpage_5=create tabpage_5
this.tabpage_2=create tabpage_2
this.tabpage_1=create tabpage_1
this.tabpage_6=create tabpage_6
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.Control[]={this.tabpage_5,&
this.tabpage_2,&
this.tabpage_1,&
this.tabpage_6,&
this.tabpage_3,&
this.tabpage_4}
end on

on tab_1.destroy
destroy(this.tabpage_5)
destroy(this.tabpage_2)
destroy(this.tabpage_1)
destroy(this.tabpage_6)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
end on

type tabpage_5 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 100
integer width = 2222
integer height = 1064
long backcolor = 67108864
string text = "Graph Type"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
uo_graph_type uo_graph_type
end type

on tabpage_5.create
this.uo_graph_type=create uo_graph_type
this.Control[]={this.uo_graph_type}
end on

on tabpage_5.destroy
destroy(this.uo_graph_type)
end on

type uo_graph_type from uo_graph_gallery within tabpage_5
event destroy ( )
integer y = 8
integer width = 2213
integer height = 1060
integer taborder = 40
long backcolor = 67108864
end type

on uo_graph_type.destroy
call uo_graph_gallery::destroy
end on

event destructor;call super::destructor;//GRAPH(NAME=SDFSDFDSFDSF VISIBLE="1" 
//MOVEABLE=1 RESIZEABLE=1 BAND=FOREGROUND X="87" Y="784" HEIGHT="1184" WIDTH="2304" GRAPHTYPE="17" 
//TITLE="SDFSDFDSFDSF" TITLE.DISPATTR.ALIGNMENT="2" 
//TITLE.DISPATTR.AUTOSIZE="1" 
//TITLE.DISPATTR.BACKCOLOR="553648127" 
//TITLE.DISPATTR.FONT.CHARSET="0" 
//TITLE.DISPATTR.FONT.FACE="TAHOMA" 
//TITLE.DISPATTR.FONT.FAMILY="2" 
//TITLE.DISPATTR.FONT.HEIGHT="1" 
//TITLE.DISPATTR.FONT.ITALIC="0" 
//TITLE.DISPATTR.FONT.PITCH="2" 
//TITLE.DISPATTR.FONT.STRIKETHROUGH="0" 
//TITLE.DISPATTR.FONT.WEIGHT="700" 
//TITLE.DISPATTR.FONT.UNDERLINE="0" 
//TITLE.DISPATTR.FONT.ESCAPEMENT="0" 
//TITLE.DISPATTR.FONT.ORIENTATION="0" 
//TITLE.DISPATTR.FORMAT="[GENERAL]" 
//TITLE.DISPATTR.TEXTCOLOR="0" BACKCOLOR="16777215" BORDER="3" COLOR="0" 
//DEPTH="100" 
//ELEVATION="20" 
//PERSPECTIVE="2" 
//ROTATION="-20" 
//LEGEND="4" 
//LEGEND.DISPATTR.ALIGNMENT="0" LEGEND.DISPATTR.AUTOSIZE="1" 
//LEGEND.DISPATTR.BACKCOLOR="536870912" 
//LEGEND.DISPATTR.FONT.CHARSET="0" 
//LEGEND.DISPATTR.FONT.FACE="TAHOMA" 
//LEGEND.DISPATTR.FONT.FAMILY="2" 
//LEGEND.DISPATTR.FONT.HEIGHT="1" 
//LEGEND.DISPATTR.FONT.ITALIC="0" 
//LEGEND.DISPATTR.FONT.PITCH="2" 
//LEGEND.DISPATTR.FONT.STRIKETHROUGH="0" 
//LEGEND.DISPATTR.FONT.WEIGHT="400" 
//LEGEND.DISPATTR.FONT.UNDERLINE="0" 
//LEGEND.DISPATTR.FONT.ESCAPEMENT="0" 
//LEGEND.DISPATTR.FONT.ORIENTATION="0" 
//LEGEND.DISPATTR.FORMAT="[GENERAL]" 
//LEGEND.DISPATTR.TEXTCOLOR="0" OVERLAPPERCENT="0" 
//PERSPECTIVE="2" 
//ROTATION="-20" 
//SHADECOLOR="8355711" SPACING="100" 
//CATEGORY="WAREHOUSE_NAME" 
//VALUES="SUM(ORGANIZATION_ID FOR GRAPH)" 
//SERIES.AUTOSCALE="1" 
//SERIES.DROPLINES="0" 
//SERIES.FRAME="1" 
//SERIES.LABEL="(NONE)" 
//SERIES.MAJORDIVISIONS="0" 
//SERIES.MAJORGRIDLINE="0" 
//SERIES.MAJORTIC="3" 
//SERIES.MAXIMUMVALUE="0" 
//SERIES.MINIMUMVALUE="0" 
//SERIES.MINORDIVISIONS="0" 
//SERIES.MINORGRIDLINE="0" 
//SERIES.MINORTIC="1" 
//SERIES.ORIGINLINE="0" 
//SERIES.PRIMARYLINE="1" 
//SERIES.ROUNDTO="0" 
//SERIES.SCALETYPE="1" 
//SERIES.SCALEVALUE="1" 
//SERIES.SECONDARYLINE="0" 
//SERIES.SHADEBACKEDGE="0" 
//SERIES.DISPATTR.ALIGNMENT="0" 
//SERIES.DISPATTR.AUTOSIZE="1" 
//SERIES.DISPATTR.BACKCOLOR="536870912" 
//SERIES.DISPATTR.FONT.CHARSET="0" 
//SERIES.DISPATTR.FONT.FACE="TAHOMA" 
//SERIES.DISPATTR.FONT.FAMILY="2" 
//SERIES.DISPATTR.FONT.HEIGHT="1" 
//SERIES.DISPATTR.FONT.ITALIC="0" 
//SERIES.DISPATTR.FONT.PITCH="2" 
//SERIES.DISPATTR.FONT.STRIKETHROUGH="0" 
//SERIES.DISPATTR.FONT.WEIGHT="400" 
//SERIES.DISPATTR.FONT.UNDERLINE="0" 
//SERIES.DISPATTR.FONT.ESCAPEMENT="0" 
//SERIES.DISPATTR.FONT.ORIENTATION="0" 
//SERIES.DISPATTR.FORMAT="[GENERAL]" 
//SERIES.DISPATTR.TEXTCOLOR="0" 
//SERIES.LABELDISPATTR.ALIGNMENT="2" SERIES.LABELDISPATTR.AUTOSIZE="1" 
//SERIES.LABELDISPATTR.BACKCOLOR="553648127" SERIES.LABELDISPATTR.FONT.CHARSET="0" 
//SERIES.LABELDISPATTR.FONT.FACE="TAHOMA" SERIES.LABELDISPATTR.FONT.FAMILY="2" 
//SERIES.LABELDISPATTR.FONT.HEIGHT="1" SERIES.LABELDISPATTR.FONT.ITALIC="0" 
//SERIES.LABELDISPATTR.FONT.PITCH="2" SERIES.LABELDISPATTR.FONT.STRIKETHROUGH="0" 
//SERIES.LABELDISPATTR.FONT.WEIGHT="400" SERIES.LABELDISPATTR.FONT.UNDERLINE="0" 
//SERIES.LABELDISPATTR.FONT.ESCAPEMENT="0" SERIES.LABELDISPATTR.FONT.ORIENTATION="0" SERIES.LABELDISPATTR.FORMAT="[GENERAL]" 
//SERIES.LABELDISPATTR.TEXTCOLOR="0" 
//CATEGORY.AUTOSCALE="1" 
//CATEGORY.DROPLINES="0" 
//CATEGORY.FRAME="1" 
//CATEGORY.LABEL="$$HEX4$$3dcce0ac74c784b9$$ENDHEX$$" CATEGORY.MAJORDIVISIONS="0" 
//CATEGORY.MAJORGRIDLINE="0" CATEGORY.MAJORTIC="3" 
//CATEGORY.MAXIMUMVALUE="5" CATEGORY.MINIMUMVALUE="0" CATEGORY.MINORDIVISIONS="0" CATEGORY.MINORGRIDLINE="0" 
//CATEGORY.MINORTIC="1" CATEGORY.ORIGINLINE="0" CATEGORY.PRIMARYLINE="1" CATEGORY.ROUNDTO="0" CATEGORY.SCALETYPE="1" 
//CATEGORY.SCALEVALUE="1" CATEGORY.SECONDARYLINE="0" CATEGORY.SHADEBACKEDGE="1" CATEGORY.DISPATTR.ALIGNMENT="2" 
//CATEGORY.DISPATTR.AUTOSIZE="1" CATEGORY.DISPATTR.BACKCOLOR="536870912" CATEGORY.DISPATTR.FONT.CHARSET="0" 
//CATEGORY.DISPATTR.FONT.FACE="TAHOMA" CATEGORY.DISPATTR.FONT.FAMILY="2" CATEGORY.DISPATTR.FONT.HEIGHT="1" 
//CATEGORY.DISPATTR.FONT.ITALIC="0" CATEGORY.DISPATTR.FONT.PITCH="2" CATEGORY.DISPATTR.FONT.STRIKETHROUGH="0" 
//CATEGORY.DISPATTR.FONT.WEIGHT="400" CATEGORY.DISPATTR.FONT.UNDERLINE="0" CATEGORY.DISPATTR.FONT.ESCAPEMENT="NONE" 
//CATEGORY.DISPATTR.FONT.ORIENTATION="0" CATEGORY.DISPATTR.FORMAT="[GENERAL]" CATEGORY.DISPATTR.TEXTCOLOR="0" 
//CATEGORY.LABELDISPATTR.ALIGNMENT="2" CATEGORY.LABELDISPATTR.AUTOSIZE="1" CATEGORY.LABELDISPATTR.BACKCOLOR="553648127" 
//CATEGORY.LABELDISPATTR.FONT.CHARSET="0" CATEGORY.LABELDISPATTR.FONT.FACE="TAHOMA" CATEGORY.LABELDISPATTR.FONT.FAMILY="2"
//CATEGORY.LABELDISPATTR.FONT.HEIGHT="1" CATEGORY.LABELDISPATTR.FONT.ITALIC="0" CATEGORY.LABELDISPATTR.FONT.PITCH="2" 
//CATEGORY.LABELDISPATTR.FONT.STRIKETHROUGH="0" CATEGORY.LABELDISPATTR.FONT.WEIGHT="400" CATEGORY.LABELDISPATTR.FONT.UNDERLINE="0" 
//CATEGORY.LABELDISPATTR.FONT.ESCAPEMENT="0" CATEGORY.LABELDISPATTR.FONT.ORIENTATION="0" CATEGORY.LABELDISPATTR.FORMAT="[GENERAL]"
//CATEGORY.LABELDISPATTR.TEXTCOLOR="0" 
//VALUES.AUTOSCALE="1" VALUES.DROPLINES="0" VALUES.FRAME="1" VALUES.LABEL="$$HEX2$$70c8c1c9$$ENDHEX$$ID" VALUES.MAJORDIVISIONS="0" 
//VALUES.MAJORGRIDLINE="0" VALUES.MAJORTIC="3" VALUES.MAXIMUMVALUE="1000" VALUES.MINIMUMVALUE="0" VALUES.MINORDIVISIONS="0" 
//VALUES.MINORGRIDLINE="0" VALUES.MINORTIC="1" VALUES.ORIGINLINE="1" VALUES.PRIMARYLINE="1" VALUES.ROUNDTO="0" VALUES.SCALETYPE="1" 
//VALUES.SCALEVALUE="1" VALUES.SECONDARYLINE="0" VALUES.SHADEBACKEDGE="0" VALUES.DISPATTR.ALIGNMENT="1" VALUES.DISPATTR.AUTOSIZE="1" 
//VALUES.DISPATTR.BACKCOLOR="536870912" VALUES.DISPATTR.FONT.CHARSET="0" VALUES.DISPATTR.FONT.FACE="TAHOMA" VALUES.DISPATTR.FONT.FAMILY="2" 
//VALUES.DISPATTR.FONT.HEIGHT="1" VALUES.DISPATTR.FONT.ITALIC="0" VALUES.DISPATTR.FONT.PITCH="2" 
//VALUES.DISPATTR.FONT.STRIKETHROUGH="0" VALUES.DISPATTR.FONT.WEIGHT="400" VALUES.DISPATTR.FONT.UNDERLINE="0" 
//VALUES.DISPATTR.FONT.ESCAPEMENT="0" VALUES.DISPATTR.FONT.ORIENTATION="0" VALUES.DISPATTR.FORMAT="[GENERAL]" 
//VALUES.DISPATTR.TEXTCOLOR="0" VALUES.LABELDISPATTR.ALIGNMENT="2" VALUES.LABELDISPATTR.AUTOSIZE="1" 
//VALUES.LABELDISPATTR.BACKCOLOR="553648127" VALUES.LABELDISPATTR.FONT.CHARSET="0" VALUES.LABELDISPATTR.FONT.FACE="TAHOMA" 
//VALUES.LABELDISPATTR.FONT.FAMILY="2" VALUES.LABELDISPATTR.FONT.HEIGHT="1" VALUES.LABELDISPATTR.FONT.ITALIC="0" 
//VALUES.LABELDISPATTR.FONT.PITCH="2" VALUES.LABELDISPATTR.FONT.STRIKETHROUGH="0" VALUES.LABELDISPATTR.FONT.WEIGHT="400" 
//VALUES.LABELDISPATTR.FONT.UNDERLINE="0" 
//VALUES.LABELDISPATTR.FONT.ESCAPEMENT="900" 
//VALUES.LABELDISPATTR.FONT.ORIENTATION="0" 
//VALUES.LABELDISPATTR.FORMAT="[GENERAL]" 
//VALUES.LABELDISPATTR.TEXTCOLOR="0"  RANGE=0 )
end event

event gallery_ok;call super::gallery_ok;int li_col,li_row, li_ret
string ls_graph_type

// Get the graph type from the graph gallery user object.
li_ret = uf_query_gallery (li_row, li_col, ls_graph_type)
if li_ret = 0 then
//	messagebox ("Sorry!","Clicked on invalid type")
	return
end if

If io_passed = Graph! Then
	// The user clicked on a graph type. Set the type in the passed graph
	// object.
	Choose Case ls_graph_type
		case "area3d"
			igr_parm.graphtype = area3d!
		case "areagraph"
			igr_parm.graphtype = areagraph!
		case "bar3dobjgraph"
			igr_parm.graphtype = bar3dobjgraph!
		case "barstack3dobjgraph"
			igr_parm.graphtype = barstack3dobjgraph!
		case "bargraph"
			igr_parm.graphtype = bargraph!
		case "bar3dgraph"
			igr_parm.graphtype = bar3dgraph!
		case "barstackgraph"
			igr_parm.graphtype = barstackgraph!
		case "col3dgraph"
			igr_parm.graphtype = col3dgraph!
		case "col3dobjgraph"
			igr_parm.graphtype = col3dobjgraph!
		case "colgraph"
			igr_parm.graphtype = colgraph!
		case "colstack3dobjgraph"
			igr_parm.graphtype = colstack3dobjgraph!
		case "colstackgraph"
			igr_parm.graphtype = colstackgraph!
		case "line3d"
			igr_parm.graphtype = line3d!
		case "linegraph"
			igr_parm.graphtype = linegraph!
		case "pie3d"
			igr_parm.graphtype = pie3d!
		case "piegraph"
			igr_parm.graphtype = piegraph!
		case "scattergraph"
			igr_parm.graphtype = scattergraph!
		case else
			messagebox ("Error!", "Invalid Graph Type")
	end choose
Elseif io_passed = Datawindow! Then
	// The user clicked on a graph type. Set the type in the passed 
	// datawindow object.
	Choose Case ls_graph_type
		case "area3d"
			idw_parm.Object.gr_1.graphtype = 15
		case "areagraph"
			idw_parm.Object.gr_1.graphtype = 1
		case "bar3dobjgraph"
			idw_parm.Object.gr_1.graphtype = 4
		case "barstack3dobjgraph"
			idw_parm.Object.gr_1.graphtype = 6
		case "bargraph"
			idw_parm.Object.gr_1.graphtype = 2
		case "bar3dgraph"
			idw_parm.Object.gr_1.graphtype = 3
		case "barstackgraph"
			idw_parm.Object.gr_1.graphtype = 5
			case "col3dgraph"
			idw_parm.Object.gr_1.graphtype = 8
		case "col3dobjgraph"
			idw_parm.Object.gr_1.graphtype = 9
		case "colgraph"
			idw_parm.Object.gr_1.graphtype = 7
		case "colstack3dobjgraph"
			idw_parm.Object.gr_1.graphtype = 11
		case "colstackgraph"
			idw_parm.Object.gr_1.graphtype = 10
		case "line3d"
			idw_parm.Object.gr_1.graphtype = 16
		case "linegraph"
			idw_parm.Object.gr_1.graphtype = 12
		case "pie3d"
			idw_parm.Object.gr_1.graphtype = 17
		case "piegraph"
			idw_parm.Object.gr_1.graphtype = 13
		case "scattergraph"
			idw_parm.Object.gr_1.graphtype = 14
		case else
			messagebox ("Error!", "Invalid Graph Type")
	end choose
End If
Close (w_graph_properties_popup)
end event

event gallery_cancel;call super::gallery_cancel;Close (w_graph_properties_popup)

end event

event gallery_clicked;call super::gallery_clicked;int li_col,li_row, li_ret
string  ls_graph_type  
// Get the graph type from the graph gallery user object.
li_ret = uf_query_gallery (li_row, li_col, ls_graph_type)
if li_ret = 0 then
	messagebox ("Sorry!","Clicked on invalid type")
	return
end if

If io_passed = Graph! Then
	// The user clicked on a graph type. Set the type in the passed graph
	// object.
	Choose Case ls_graph_type
		case "area3d"
			igr_parm.graphtype = area3d!
		case "areagraph"
			igr_parm.graphtype = areagraph!
		case "bar3dobjgraph"
			igr_parm.graphtype = bar3dobjgraph!
		case "barstack3dobjgraph"
			igr_parm.graphtype = barstack3dobjgraph!
		case "bargraph"
			igr_parm.graphtype = bargraph!
		case "bar3dgraph"
			igr_parm.graphtype = bar3dgraph!
		case "barstackgraph"
			igr_parm.graphtype = barstackgraph!
		case "col3dgraph"
			igr_parm.graphtype = col3dgraph!
		case "col3dobjgraph"
			igr_parm.graphtype = col3dobjgraph!
		case "colgraph"
			igr_parm.graphtype = colgraph!
		case "colstack3dobjgraph"
			igr_parm.graphtype = colstack3dobjgraph!
		case "colstackgraph"
			igr_parm.graphtype = colstackgraph!
		case "line3d"
			igr_parm.graphtype = line3d!
		case "linegraph"
			igr_parm.graphtype = linegraph!
		case "pie3d"
			igr_parm.graphtype = pie3d!
		case "piegraph"
			igr_parm.graphtype = piegraph!
		case "scattergraph"
			igr_parm.graphtype = scattergraph!
		case else
			messagebox ("Error!", "Invalid Graph Type")
	end choose
Elseif io_passed = Datawindow! Then
	// The user clicked on a graph type. Set the type in the passed 
	// datawindow object.
	Choose Case ls_graph_type
		case "area3d"
			idw_parm.Object.gr_1.graphtype = 15
		case "areagraph"
			idw_parm.Object.gr_1.graphtype = 1
		case "bar3dobjgraph"
			idw_parm.Object.gr_1.graphtype = 4
		case "barstack3dobjgraph"
			idw_parm.Object.gr_1.graphtype = 6
		case "bargraph"
			idw_parm.Object.gr_1.graphtype = 2
		case "bar3dgraph"
			idw_parm.Object.gr_1.graphtype = 3
		case "barstackgraph"
			idw_parm.Object.gr_1.graphtype = 5
			case "col3dgraph"
			idw_parm.Object.gr_1.graphtype = 8
		case "col3dobjgraph"
			idw_parm.Object.gr_1.graphtype = 9
		case "colgraph"
			idw_parm.Object.gr_1.graphtype = 7
		case "colstack3dobjgraph"
			idw_parm.Object.gr_1.graphtype = 11
		case "colstackgraph"
			idw_parm.Object.gr_1.graphtype = 10
		case "line3d"
			idw_parm.Object.gr_1.graphtype = 16
		case "linegraph"
			idw_parm.Object.gr_1.graphtype = 12
		case "pie3d"
			idw_parm.Object.gr_1.graphtype = 17
		case "piegraph"
			idw_parm.Object.gr_1.graphtype = 13
		case "scattergraph"
			idw_parm.Object.gr_1.graphtype = 14
		case else
			messagebox ("Error!", "Invalid Graph Type")
	end choose
End If


end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 2222
integer height = 1064
long backcolor = 67108864
string text = "Category"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
st_16 st_16
em_8 em_8
st_14 st_14
em_6 em_6
em_category_escapement em_category_escapement
st_4 st_4
em_5 em_5
st_13 st_13
em_4 em_4
st_12 st_12
end type

on tabpage_2.create
this.st_16=create st_16
this.em_8=create em_8
this.st_14=create st_14
this.em_6=create em_6
this.em_category_escapement=create em_category_escapement
this.st_4=create st_4
this.em_5=create em_5
this.st_13=create st_13
this.em_4=create em_4
this.st_12=create st_12
this.Control[]={this.st_16,&
this.em_8,&
this.st_14,&
this.em_6,&
this.em_category_escapement,&
this.st_4,&
this.em_5,&
this.st_13,&
this.em_4,&
this.st_12}
end on

on tabpage_2.destroy
destroy(this.st_16)
destroy(this.em_8)
destroy(this.st_14)
destroy(this.em_6)
destroy(this.em_category_escapement)
destroy(this.st_4)
destroy(this.em_5)
destroy(this.st_13)
destroy(this.em_4)
destroy(this.st_12)
end on

type st_16 from so_statictext within tabpage_2
integer x = 407
integer y = 636
integer width = 549
boolean bringtotop = true
integer weight = 700
long backcolor = 67108864
string text = "Text Escapement"
alignment alignment = right!
end type

type em_8 from editmask within tabpage_2
integer x = 969
integer y = 632
integer width = 366
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,##0"
boolean autoskip = true
boolean spin = true
string displaydata = "360~t360/900~t900/0~t0/450~t450/"
double increment = 1
string minmax = "0~~"
boolean usecodetable = true
end type

event modified;if io_passed = Graph! then 
	igr_parm.Category.labeldispattr.escapement = Long(this.text)	
else
	idw_parm.object.gr_1.Category.LabelDispattr.Font.Escapement= Long(this.text)
end if 
end event

type st_14 from so_statictext within tabpage_2
integer x = 407
integer y = 536
integer width = 549
boolean bringtotop = true
integer weight = 700
long backcolor = 67108864
string text = "Every Label"
alignment alignment = right!
end type

type em_6 from editmask within tabpage_2
integer x = 969
integer y = 532
integer width = 366
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,##0"
boolean autoskip = true
boolean spin = true
string displaydata = "360~t360/900~t900/0~t0/450~t450/"
double increment = 1
string minmax = "0~~"
boolean usecodetable = true
end type

event modified;if io_passed = Graph! then 
	igr_parm.Category.DisplayEveryNLabels = Integer(this.text)
else
	idw_parm.object.gr_1.Category.DisplayEveryNLabels = Integer(this.text)
end if 
//gr_1.Series.DisplayEveryNLabels = 10
end event

type em_category_escapement from editmask within tabpage_2
integer x = 969
integer y = 428
integer width = 366
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,##0"
boolean autoskip = true
boolean spin = true
string displaydata = "360~t360/900~t900/0~t0/450~t450/"
double increment = 1
string minmax = "0~~"
boolean usecodetable = true
end type

event modified;if io_passed = Graph! then 
//	gr_1.Category.Dispattr.Font.Escapement = Long(this.text)
	igr_parm.Category.dispattr.escapement = Long(this.text)	
else
	idw_parm.object.gr_1.Category.Dispattr.Font.Escapement = Long(this.text)
end if 
end event

type st_4 from so_statictext within tabpage_2
integer x = 407
integer y = 432
integer width = 549
boolean bringtotop = true
integer weight = 700
long backcolor = 67108864
string text = "Label Escapement"
alignment alignment = right!
end type

type em_5 from so_editmask within tabpage_2
integer x = 969
integer y = 340
integer width = 366
integer taborder = 90
boolean bringtotop = true
string mask = "###"
boolean spin = true
double increment = 1
end type

event modified;call super::modified;if io_passed = Graph! then 
	igr_parm.Category.MinorDivisions = Integer(this.text)
else
	idw_parm.object.gr_1.Category.MinorDivisions = Integer(this.text)	
end if
end event

type st_13 from so_statictext within tabpage_2
integer x = 407
integer y = 344
integer width = 549
boolean bringtotop = true
integer weight = 700
long textcolor = 0
long backcolor = 67108864
string text = "MinorDivisions"
alignment alignment = right!
end type

type em_4 from so_editmask within tabpage_2
integer x = 969
integer y = 248
integer width = 366
integer taborder = 80
boolean bringtotop = true
string mask = "###"
boolean spin = true
double increment = 1
end type

event modified;call super::modified;if io_passed = Graph! then 
	igr_parm.Category.MajorDivisions = Integer(this.text)
else
	idw_parm.object.gr_1.Category.MajorDivisions = Integer(this.text)
end if 
end event

type st_12 from so_statictext within tabpage_2
integer x = 407
integer y = 252
integer width = 549
boolean bringtotop = true
integer weight = 700
long textcolor = 0
long backcolor = 67108864
string text = "MajorDivisions"
alignment alignment = right!
end type

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 2222
integer height = 1064
long backcolor = 67108864
string text = "Values"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
em_7 em_7
st_15 st_15
em_2 em_2
st_3 st_3
em_3 em_3
st_11 st_11
em_1 em_1
st_2 st_2
end type

on tabpage_1.create
this.em_7=create em_7
this.st_15=create st_15
this.em_2=create em_2
this.st_3=create st_3
this.em_3=create em_3
this.st_11=create st_11
this.em_1=create em_1
this.st_2=create st_2
this.Control[]={this.em_7,&
this.st_15,&
this.em_2,&
this.st_3,&
this.em_3,&
this.st_11,&
this.em_1,&
this.st_2}
end on

on tabpage_1.destroy
destroy(this.em_7)
destroy(this.st_15)
destroy(this.em_2)
destroy(this.st_3)
destroy(this.em_3)
destroy(this.st_11)
destroy(this.em_1)
destroy(this.st_2)
end on

type em_7 from editmask within tabpage_1
integer x = 1001
integer y = 600
integer width = 366
integer height = 80
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,##0"
boolean autoskip = true
boolean spin = true
string displaydata = "360~t360/900~t900/0~t0/450~t450/"
double increment = 1
string minmax = "0~~"
boolean usecodetable = true
end type

event modified;if io_passed = Graph! then 
	igr_parm.Values.DisplayEveryNLabels = Integer(this.text)
else
	idw_parm.object.gr_1.Values.DisplayEveryNLabels = Integer(this.text)
end if 

end event

type st_15 from so_statictext within tabpage_1
integer x = 430
integer y = 604
integer width = 549
boolean bringtotop = true
integer weight = 700
long backcolor = 67108864
string text = "Every Label"
alignment alignment = right!
end type

type em_2 from so_editmask within tabpage_1
integer x = 1001
integer y = 508
integer width = 366
integer taborder = 80
boolean bringtotop = true
string mask = "###"
boolean spin = true
double increment = 1
end type

event modified;call super::modified;if io_passed = Graph! then 
	igr_parm.Values.roundtoUnit = rndNumber!
	igr_parm.Values.roundto = Integer(this.text)
else
	
	idw_parm.object.gr_1.Values.roundtoUnit = rndNumber!
	idw_parm.object.gr_1.Values.roundto = Integer(this.text)
	
end if 

end event

type st_3 from so_statictext within tabpage_1
integer x = 443
integer y = 512
integer width = 526
boolean bringtotop = true
integer weight = 700
long textcolor = 0
long backcolor = 67108864
string text = "RoundTo"
alignment alignment = right!
end type

type em_3 from so_editmask within tabpage_1
integer x = 1001
integer y = 412
integer width = 366
integer taborder = 80
boolean bringtotop = true
string mask = "###"
boolean spin = true
double increment = 1
end type

event modified;call super::modified;if io_passed = Graph! then 
	igr_parm.Values.MinorDivisions = Integer(this.text)
else
	idw_parm.object.gr_1.Values.MinorDivisions = Integer(this.text)	
end if
end event

type st_11 from so_statictext within tabpage_1
integer x = 443
integer y = 416
integer width = 526
boolean bringtotop = true
integer weight = 700
long textcolor = 0
long backcolor = 67108864
string text = "MinorDivisions"
alignment alignment = right!
end type

type em_1 from so_editmask within tabpage_1
integer x = 1001
integer y = 320
integer width = 366
integer taborder = 70
boolean bringtotop = true
string mask = "###"
boolean spin = true
double increment = 1
end type

event modified;call super::modified;if io_passed = Graph! then 
	igr_parm.Values.MajorDivisions = Integer(this.text)
else
	idw_parm.object.gr_1.Values.MajorDivisions = Integer(this.text)
end if 
end event

type st_2 from so_statictext within tabpage_1
integer x = 443
integer y = 324
integer width = 526
boolean bringtotop = true
integer weight = 700
long textcolor = 0
long backcolor = 67108864
string text = "MajorDivisions"
alignment alignment = right!
end type

type tabpage_6 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 2222
integer height = 1064
long backcolor = 67108864
string text = "Legend"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
ddlb_legend ddlb_legend
st_10 st_10
end type

on tabpage_6.create
this.ddlb_legend=create ddlb_legend
this.st_10=create st_10
this.Control[]={this.ddlb_legend,&
this.st_10}
end on

on tabpage_6.destroy
destroy(this.ddlb_legend)
destroy(this.st_10)
end on

type ddlb_legend from uo_basecode within tabpage_6
integer x = 453
integer y = 480
integer width = 1408
integer height = 432
integer taborder = 70
boolean bringtotop = true
end type

event getfocus;call super::getfocus;this.redraw( 'LEGEND')
end event

event selectionchanged;call super::selectionchanged;if io_passed = Graph! then 

	IF THIS.GETCODE() = 'ATBOTTOM' THEN 
		igr_parm.LEGEND = AtBottom!
	ELSEIF  THIS.GETCODE() = 'ATTOP' THEN 
		igr_parm.LEGEND = AtTop!
	ELSEIF  THIS.GETCODE() = 'ATLEFT' THEN 
		igr_parm.LEGEND = AtLeft!	
	ELSEIF  THIS.GETCODE() = 'ATRIGHT' THEN 
		igr_parm.LEGEND = AtRight!		
	END IF
	
else
	IF THIS.GETCODE() = 'ATBOTTOM' THEN 
		idw_parm.object.GR_1.LEGEND = 4
	ELSEIF  THIS.GETCODE() = 'ATTOP' THEN 
		idw_parm.object.GR_1.LEGEND = 3
	ELSEIF  THIS.GETCODE() = 'ATLEFT' THEN 
		idw_parm.object.GR_1.LEGEND = 1
	ELSEIF  THIS.GETCODE() = 'ATRIGHT' THEN 
		idw_parm.object.GR_1.LEGEND = 2
	END IF	
	
end if 
	
	
end event

type st_10 from statictext within tabpage_6
integer x = 453
integer y = 396
integer width = 1408
integer height = 80
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
alignment alignment = center!
boolean focusrectangle = false
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 2222
integer height = 1064
long backcolor = 67108864
string text = "3D"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
htb_spacing htb_spacing
st_9 st_9
st_8 st_8
htb_depth htb_depth
st_7 st_7
htb_rotation htb_rotation
st_6 st_6
htb_elevation htb_elevation
htb_perspective htb_perspective
st_5 st_5
end type

on tabpage_3.create
this.htb_spacing=create htb_spacing
this.st_9=create st_9
this.st_8=create st_8
this.htb_depth=create htb_depth
this.st_7=create st_7
this.htb_rotation=create htb_rotation
this.st_6=create st_6
this.htb_elevation=create htb_elevation
this.htb_perspective=create htb_perspective
this.st_5=create st_5
this.Control[]={this.htb_spacing,&
this.st_9,&
this.st_8,&
this.htb_depth,&
this.st_7,&
this.htb_rotation,&
this.st_6,&
this.htb_elevation,&
this.htb_perspective,&
this.st_5}
end on

on tabpage_3.destroy
destroy(this.htb_spacing)
destroy(this.st_9)
destroy(this.st_8)
destroy(this.htb_depth)
destroy(this.st_7)
destroy(this.htb_rotation)
destroy(this.st_6)
destroy(this.htb_elevation)
destroy(this.htb_perspective)
destroy(this.st_5)
end on

type htb_spacing from htrackbar within tabpage_3
integer x = 430
integer y = 764
integer width = 1723
integer height = 148
boolean bringtotop = true
integer minposition = -360
integer maxposition = 360
integer position = 100
integer tickfrequency = 10
end type

event moved;if io_passed = Graph! then 
	igr_parm.spacing = scrollpos
else
       idw_parm.object.gr_1.spacing = scrollpos	
end if 
	
end event

type st_9 from so_statictext within tabpage_3
integer x = 46
integer y = 792
integer width = 393
integer height = 68
boolean bringtotop = true
long backcolor = 67108864
string text = "Sapcing"
alignment alignment = right!
end type

type st_8 from so_statictext within tabpage_3
integer x = 46
integer y = 652
integer width = 393
integer height = 64
boolean bringtotop = true
long backcolor = 67108864
string text = "Depth"
alignment alignment = right!
end type

type htb_depth from htrackbar within tabpage_3
integer x = 430
integer y = 612
integer width = 1723
integer height = 148
boolean bringtotop = true
integer minposition = -360
integer maxposition = 360
integer position = 100
integer tickfrequency = 10
end type

event moved;if io_passed = Graph! then 
	igr_parm.depth = scrollpos
else
       idw_parm.object.gr_1.depth = scrollpos	
end if 
	
end event

type st_7 from so_statictext within tabpage_3
integer x = 46
integer y = 476
integer width = 393
integer height = 68
boolean bringtotop = true
long backcolor = 67108864
string text = "Rotation"
alignment alignment = right!
end type

type htb_rotation from htrackbar within tabpage_3
integer x = 430
integer y = 444
integer width = 1723
integer height = 148
boolean bringtotop = true
integer minposition = -360
integer maxposition = 360
integer position = -20
integer tickfrequency = 10
end type

event moved;if io_passed = Graph! then 
	igr_parm.Rotation = scrollpos
else
       idw_parm.object.gr_1.Rotation = scrollpos	
end if 
	
end event

type st_6 from so_statictext within tabpage_3
integer x = 46
integer y = 308
integer width = 393
integer height = 68
boolean bringtotop = true
long backcolor = 67108864
string text = "Elevation"
alignment alignment = right!
end type

type htb_elevation from htrackbar within tabpage_3
integer x = 430
integer y = 276
integer width = 1723
integer height = 148
boolean bringtotop = true
integer minposition = -360
integer maxposition = 360
integer position = 20
integer tickfrequency = 10
end type

event moved;if io_passed = Graph! then 
	igr_parm.elevation = scrollpos
else
       idw_parm.object.gr_1.elevation = scrollpos	
end if 
	
end event

type htb_perspective from htrackbar within tabpage_3
integer x = 430
integer y = 132
integer width = 1723
integer height = 148
boolean bringtotop = true
integer minposition = -360
integer maxposition = 360
integer position = 2
integer tickfrequency = 10
end type

event moved;if io_passed = Graph! then 
	igr_parm.perspective = scrollpos
else
       idw_parm.object.gr_1.perspective = scrollpos	
end if 
	
end event

type st_5 from so_statictext within tabpage_3
integer x = 46
integer y = 160
integer width = 393
integer height = 68
boolean bringtotop = true
long backcolor = 67108864
string text = "Perspective"
alignment alignment = right!
end type

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 2222
integer height = 1064
long backcolor = 67108864
string text = "ETC"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
sle_graph_title sle_graph_title
st_1 st_1
cb_1 cb_1
end type

on tabpage_4.create
this.sle_graph_title=create sle_graph_title
this.st_1=create st_1
this.cb_1=create cb_1
this.Control[]={this.sle_graph_title,&
this.st_1,&
this.cb_1}
end on

on tabpage_4.destroy
destroy(this.sle_graph_title)
destroy(this.st_1)
destroy(this.cb_1)
end on

type sle_graph_title from so_singlelineedit within tabpage_4
integer x = 27
integer y = 132
integer width = 2171
integer taborder = 30
boolean bringtotop = true
long backcolor = 16777215
end type

event modified;call super::modified;If io_passed = Graph! Then
	igr_parm.title = this.text
Elseif io_passed = Datawindow! Then
	// Set the graph title in the datawindow to the modified text.
	idw_parm.Object.gr_1.title = this.text
End If
end event

type st_1 from so_statictext within tabpage_4
integer x = 27
integer y = 48
integer width = 2171
boolean bringtotop = true
string text = "Graph Title"
end type

type cb_1 from so_commandbutton within tabpage_4
integer x = 896
integer y = 516
integer width = 370
integer height = 100
integer taborder = 60
boolean bringtotop = true
string text = "Color"
end type

event clicked;call super::clicked;SetPointer(HourGlass!)
//open the change color window and pass the graph to it in the 
//message.powerobjectparm
if io_passed = Graph! then 
	OpenWithParm (w_graph_color, igr_parm )
else
	OpenWithParm (w_graph_color, idw_parm )	
end if 
end event

