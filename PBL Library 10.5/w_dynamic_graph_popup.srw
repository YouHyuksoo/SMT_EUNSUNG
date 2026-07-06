HA$PBExportHeader$w_dynamic_graph_popup.srw
$PBExportComments$Dynamic Graph Popup
forward
global type w_dynamic_graph_popup from w_none_dw_popup_root
end type
type uo_graph_type from uo_graph_gallery within w_dynamic_graph_popup
end type
type sle_graph_title from so_singlelineedit within w_dynamic_graph_popup
end type
type em_category_escapement from editmask within w_dynamic_graph_popup
end type
type st_4 from so_statictext within w_dynamic_graph_popup
end type
type gr_1 from graph within w_dynamic_graph_popup
end type
type htb_perspective from htrackbar within w_dynamic_graph_popup
end type
type st_5 from so_statictext within w_dynamic_graph_popup
end type
type htb_elevation from htrackbar within w_dynamic_graph_popup
end type
type st_6 from so_statictext within w_dynamic_graph_popup
end type
type htb_rotation from htrackbar within w_dynamic_graph_popup
end type
type st_7 from so_statictext within w_dynamic_graph_popup
end type
type htb_depth from htrackbar within w_dynamic_graph_popup
end type
type st_8 from so_statictext within w_dynamic_graph_popup
end type
type htb_spacing from htrackbar within w_dynamic_graph_popup
end type
type st_9 from so_statictext within w_dynamic_graph_popup
end type
type ddlb_legend from uo_basecode within w_dynamic_graph_popup
end type
type st_10 from statictext within w_dynamic_graph_popup
end type
type cb_1 from so_commandbutton within w_dynamic_graph_popup
end type
type lb_category from listbox within w_dynamic_graph_popup
end type
type plb_value from picturelistbox within w_dynamic_graph_popup
end type
type gb_1 from so_groupbox within w_dynamic_graph_popup
end type
type gb_2 from so_groupbox within w_dynamic_graph_popup
end type
type gb_3 from so_groupbox within w_dynamic_graph_popup
end type
end forward

global type w_dynamic_graph_popup from w_none_dw_popup_root
integer width = 3566
integer height = 2304
string title = "Dynamic Graph Popup"
long backcolor = 67108864
uo_graph_type uo_graph_type
sle_graph_title sle_graph_title
em_category_escapement em_category_escapement
st_4 st_4
gr_1 gr_1
htb_perspective htb_perspective
st_5 st_5
htb_elevation htb_elevation
st_6 st_6
htb_rotation htb_rotation
st_7 st_7
htb_depth htb_depth
st_8 st_8
htb_spacing htb_spacing
st_9 st_9
ddlb_legend ddlb_legend
st_10 st_10
cb_1 cb_1
lb_category lb_category
plb_value plb_value
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_dynamic_graph_popup w_dynamic_graph_popup

type variables
datawindow idw_parm

end variables

forward prototypes
public subroutine wf_set_a_series (string as_title, string as_value, string as_category)
end prototypes

public subroutine wf_set_a_series (string as_title, string as_value, string as_category);long 		ll_row, ll_index,	&
				lc_amt
int			li_series_num
string		ls_title, ls_origin_sort , ls_datatype

if as_category = '' or isnull(as_category) then 
	Return
end if

if left(as_title,1) = '+'  then
	li_series_num = gr_1.addseries ( "@overlay~t" + as_title )
else
	li_series_num = gr_1.addseries ( as_title )
end if

if	li_series_num < 1 then return
  
	ls_datatype = idw_parm.describe(as_category + ".coltype")
	
	if ls_datatype = 'datetime' then
		ls_title	=	string(idw_parm.getitemdatetime( 1 , as_category ))
	else
		ls_title = idw_parm.getitemstring( 1 , as_category )
	end if

	lc_amt 	=	idw_parm.getitemnumber( 1 , as_value)
	
	ll_row = 1
	for	ll_index = 1 to ll_row
		
			ls_datatype = idw_parm.describe(as_category + ".coltype")
			
			if ls_datatype = 'datetime' or ls_datatype= 'date' then 
				
					if	string(idw_parm.getitemdatetime( ll_index , as_category )) = ls_title then
						lc_amt	+= idw_parm.getitemnumber(ll_index , as_value)	
					else
						gr_1.adddata (li_series_num, lc_amt, ls_title )		
						
						ls_title	=	string(idw_parm.getitemdatetime( ll_index , as_category ))
						lc_amt 	=	idw_parm.getitemnumber(ll_index , as_value)
					end if				
				
			else
					if	idw_parm.getitemstring( ll_index , as_category ) = ls_title then
						lc_amt	+= idw_parm.getitemnumber(ll_index , as_value)	
					else
						gr_1.adddata (li_series_num, lc_amt, ls_title )		
						
						ls_title	=	idw_parm.getitemstring( ll_index , as_category )
						lc_amt 	=	idw_parm.getitemnumber(ll_index , as_value)
					end if
			end if
			
			
			if	ll_index = ll_row then
				gr_1.adddata (li_series_num, lc_amt, ls_title )
			end if
	
	next

end subroutine

on w_dynamic_graph_popup.create
int iCurrent
call super::create
this.uo_graph_type=create uo_graph_type
this.sle_graph_title=create sle_graph_title
this.em_category_escapement=create em_category_escapement
this.st_4=create st_4
this.gr_1=create gr_1
this.htb_perspective=create htb_perspective
this.st_5=create st_5
this.htb_elevation=create htb_elevation
this.st_6=create st_6
this.htb_rotation=create htb_rotation
this.st_7=create st_7
this.htb_depth=create htb_depth
this.st_8=create st_8
this.htb_spacing=create htb_spacing
this.st_9=create st_9
this.ddlb_legend=create ddlb_legend
this.st_10=create st_10
this.cb_1=create cb_1
this.lb_category=create lb_category
this.plb_value=create plb_value
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_graph_type
this.Control[iCurrent+2]=this.sle_graph_title
this.Control[iCurrent+3]=this.em_category_escapement
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.gr_1
this.Control[iCurrent+6]=this.htb_perspective
this.Control[iCurrent+7]=this.st_5
this.Control[iCurrent+8]=this.htb_elevation
this.Control[iCurrent+9]=this.st_6
this.Control[iCurrent+10]=this.htb_rotation
this.Control[iCurrent+11]=this.st_7
this.Control[iCurrent+12]=this.htb_depth
this.Control[iCurrent+13]=this.st_8
this.Control[iCurrent+14]=this.htb_spacing
this.Control[iCurrent+15]=this.st_9
this.Control[iCurrent+16]=this.ddlb_legend
this.Control[iCurrent+17]=this.st_10
this.Control[iCurrent+18]=this.cb_1
this.Control[iCurrent+19]=this.lb_category
this.Control[iCurrent+20]=this.plb_value
this.Control[iCurrent+21]=this.gb_1
this.Control[iCurrent+22]=this.gb_2
this.Control[iCurrent+23]=this.gb_3
end on

on w_dynamic_graph_popup.destroy
call super::destroy
destroy(this.uo_graph_type)
destroy(this.sle_graph_title)
destroy(this.em_category_escapement)
destroy(this.st_4)
destroy(this.gr_1)
destroy(this.htb_perspective)
destroy(this.st_5)
destroy(this.htb_elevation)
destroy(this.st_6)
destroy(this.htb_rotation)
destroy(this.st_7)
destroy(this.htb_depth)
destroy(this.st_8)
destroy(this.htb_spacing)
destroy(this.st_9)
destroy(this.ddlb_legend)
destroy(this.st_10)
destroy(this.cb_1)
destroy(this.lb_category)
destroy(this.plb_value)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event open;call super::open;// Receive and remember in the igr_parm or idw_parm instance variable, the
// object that has been passed by the window that opened this.

idw_parm = message.powerobjectparm
	
String ls_names_list , ls_object_name , ls_names , ls_datatype , ls_desc

	ls_names_list = idw_parm.Object.DataWindow.objects
	
	// Get each object from the list and add it to the objects listbox
	//The character fields are added to the category list box and the
	//number fields are added to the value listbox
	ls_names = ls_names_list
	
	lb_category.reset()
	plb_value.reset()
	
	do 
		ls_object_name = f_get_token (ls_names, "~t")
		if idw_parm.Describe(ls_object_name + ".type") = "column" then
			ls_datatype = idw_parm.Describe(ls_object_name + ".coltype")
			ls_desc		= idw_parm.Describe(ls_object_name+'_t' + ".text")
			
			if left(ls_datatype, 4) = "char"  or ls_datatype = "datetime" or ls_datatype = "date" then
				lb_category.AddItem (ls_desc+'                                                  :'+ls_object_name)
			elseif ls_datatype = "int" or ls_datatype = "long" or ls_datatype = "number" or left(ls_datatype,7) = "decimal" then
				plb_value.AddItem (ls_desc+'                                                  :'+ls_object_name , 1)
			end if
		end if
	loop until ls_names = ""



end event

type p_title from w_none_dw_popup_root`p_title within w_dynamic_graph_popup
integer width = 3566
end type

type cb_close from w_none_dw_popup_root`cb_close within w_dynamic_graph_popup
integer x = 32
integer y = 2296
end type

type st_msg from w_none_dw_popup_root`st_msg within w_dynamic_graph_popup
integer y = 200
integer width = 3566
long backcolor = 67108864
end type

type uo_graph_type from uo_graph_gallery within w_dynamic_graph_popup
integer x = 1335
integer y = 1132
integer width = 2213
integer height = 1060
integer taborder = 30
long backcolor = 67108864
end type

event gallery_cancel;call super::gallery_cancel;Close (parent)

end event

event gallery_ok;call super::gallery_ok;int li_col,li_row, li_ret
string lvs_gr_name , ls_graph_type , lvs_graph_type , lvs_category , lvs_value , lvs_series , Lvs_graph_title , lvs_category_label , lvs_value_label
String lvs_syntax , lvs_return , lvs_category_escapement , lvs_perspective ,lvs_rotation ,lvs_elevation ,lvs_depth , lvs_spacing , lvs_legend

// Get the graph type from the graph gallery user object.
li_ret = uf_query_gallery (li_row, li_col, ls_graph_type)
if li_ret = 0 then
	messagebox ("Sorry!","Clicked on invalid type")
	return
end if

	// The user clicked on a graph type. Set the type in the passed 
	// datawindow object.
	Choose Case ls_graph_type
		case "area3d"
			lvs_graph_type = '15'
		case "areagraph"
			lvs_graph_type = '1'
		case "bar3dobjgraph"
			lvs_graph_type = '4'			
		case "barstack3dobjgraph"
			lvs_graph_type = '6'			
		case "bargraph"
			lvs_graph_type ='2'			
		case "bar3dgraph"
			lvs_graph_type = '3'			
		case "barstackgraph"
			lvs_graph_type ='5'			
			case "col3dgraph"
			lvs_graph_type ='8'				
		case "col3dobjgraph"
			lvs_graph_type ='9'			
		case "colgraph"
			lvs_graph_type ='7'			
		case "colstack3dobjgraph"
			lvs_graph_type ='11'
		case "colstackgraph"
			lvs_graph_type ='10'			
		case "line3d"
			lvs_graph_type ='16'			
		case "linegraph"
			lvs_graph_type ='12'			
		case "pie3d"
			lvs_graph_type ='17'			
		case "piegraph"
			lvs_graph_type ='13'			
		case "scattergraph"
			lvs_graph_type ='14'			
		case else
			messagebox ("Error!", "Invalid Graph Type")
	end choose

//count(goods_code for graph)

lvs_category          = TRIM(MID(  lb_category.selecteditem() ,  POS(  lb_category.selecteditem() , ':' ) +1, 200 )) 
lvs_category_label= TRIM(MID(  lb_category.selecteditem() ,  1 , POS(  lb_category.selecteditem() , ':' ) -1)) 

lvs_value           = 'Sum('+TRIM(MID(  plb_value.selecteditem() ,  POS(  plb_value.selecteditem() , ':' ) +1, 200 )) +' for graph)'
lvs_value_label =TRIM(MID(  plb_value.selecteditem() ,  1 , POS(  plb_value.selecteditem() , ':' ) -1)) 
lvs_category_escapement = em_category_escapement.text

if sle_graph_title.text = '' then 
	Lvs_graph_title = lvs_category_label+" Graph"
else	
	Lvs_graph_title = sle_graph_title.text
end if
lvs_gr_name = lvs_category_label+'_'+lvs_value_label+'_'+lvs_graph_type

lvs_perspective = string(htb_perspective.position)
lvs_rotation      = string(htb_rotation.position)
lvs_elevation    = string(htb_elevation.position)
lvs_depth         = string(htb_depth.position)
lvs_spacing      = string(htb_spacing.position)

IF DDLB_LEGEND.GETCODE() = 'ATBOTTOM' THEN 
	lvs_legend = '4'
ELSEIF  DDLB_LEGEND.GETCODE() = 'ATTOP' THEN 
	lvs_legend = '3'
ELSEIF  DDLB_LEGEND.GETCODE() = 'ATLEFT' THEN 
	lvs_legend = '1'
ELSEIF  DDLB_LEGEND.GETCODE() = 'ATRIGHT' THEN 
	lvs_legend = '2'
ELSE 
	lvs_legend = '4'	
END IF

//================================
// Add Series
//================================

Int i 
String ls_colname
for i = 1 to plb_value.totalitems ( )

	If plb_value.state ( i ) = 1 then
		
		ls_colname	= MID(  plb_value.text ( i ),  1 , 1)
		
		if left(ls_colname,1) = '+'  then
			
			ls_colname	= 	TRIM(MID(  plb_value.text ( i ),  POS(   plb_value.text ( i ) , ':' ) +1, 200 ))
			lvs_series = lvs_series+( "@overlay~t" + ls_colname )+","
			
		else
			
			ls_colname	= 	TRIM(MID(  plb_value.text ( i ),  POS(   plb_value.text ( i ) , ':' ) +1, 200 ))
			lvs_series = lvs_series+' '+ls_colname+","
			
		end if
		
	end if

next

lvs_series = Mid(lvs_series , 1 , Len( lvs_series ) -1 )

//==================================================================================================
// Object Create Syntax
//==================================================================================================
lvs_syntax = "create graph(band=foreground x='1' y='1' height='1185' width='2305' graphtype='"+lvs_graph_type +"' perspective='"+lvs_perspective+"' " + &
"rotation='"+lvs_rotation+"' color='0' backcolor='16777215' shadecolor='8355711' range= 0 border='3' " + &
"overlappercent='0' spacing='"+lvs_spacing+"' elevation='"+lvs_elevation+"' depth='"+lvs_depth+"' visible='1' name="+lvs_gr_name+"  resizeable=1  moveable=1 " + &
"series='"+lvs_series+"' category='"+lvs_category+"' values='"+lvs_value+"' title='"+lvs_graph_title+"'  " + &
"title.dispattr.backcolor='553648127' title.dispattr.alignment='2' title.dispattr.autosize='1'  " + &
"title.dispattr.font.charset='0' title.dispattr.font.escapement='0' title.dispattr.font.face='Tahoma'  " + &
"title.dispattr.font.family='2' title.dispattr.font.height='1' title.dispattr.font.italic='0'  " + &
"title.dispattr.font.orientation='0' title.dispattr.font.pitch='2' title.dispattr.font.strikethrough='0'  " + &
"title.dispattr.font.underline='0' title.dispattr.font.weight='700' title.dispattr.format='[General]'  " + &
"title.dispattr.textcolor='0' legend='4' legend.dispattr.backcolor='536870912'  " + &
"legend.dispattr.alignment='0' legend.dispattr.autosize='1' legend.dispattr.font.charset='0'  " + &
"legend.dispattr.font.escapement='0' legend.dispattr.font.face='Tahoma' legend.dispattr.font.family='2'  " + &
"legend.dispattr.font.height='1' legend.dispattr.font.italic='0' legend.dispattr.font.orientation='0'  " + &
"legend.dispattr.font.pitch='2' legend.dispattr.font.strikethrough='0' legend.dispattr.font.underline='0'  " + &
"legend.dispattr.font.weight='400' legend.dispattr.format='[General]' legend.dispattr.textcolor='0' " + &
"series.autoscale='1' series.droplines='0' series.frame='1' series.label='(None)'  " + &
"series.majordivisions='0' series.majorgridline='0' series.majortic='3' series.maximumvalue='0'  " + &
"series.minimumvalue='0' series.minordivisions='0' series.minorgridline='0' series.minortic='1'  " + &
"series.originline='0' series.primaryline='1' series.roundto='0' series.scaletype='1'  " + &
"series.scalevalue='1' series.secondaryline='0' series.shadebackedge='0'  " + &
"series.dispattr.backcolor='536870912' series.dispattr.alignment='0' series.dispattr.autosize='1'  " + &
"series.dispattr.font.charset='0' series.dispattr.font.escapement='0' series.dispattr.font.face='Tahoma'  " + &
"series.dispattr.font.family='2' series.dispattr.font.height='1' series.dispattr.font.italic='0'  " + &
"series.dispattr.font.orientation='0' series.dispattr.font.pitch='2' series.dispattr.font.strikethrough='0'  " + &
"series.dispattr.font.underline='0' series.dispattr.font.weight='400' series.dispattr.format='[General]'  " + &
"series.dispattr.textcolor='0' series.labeldispattr.backcolor='553648127'  " + &
"series.labeldispattr.alignment='2' series.labeldispattr.autosize='1' series.labeldispattr.font.charset='0'  " + &
"series.labeldispattr.font.escapement='0' series.labeldispattr.font.face='Tahoma'  " + &
"series.labeldispattr.font.family='2' series.labeldispattr.font.height='1' series.labeldispattr.font.italic='0'  " + &
"series.labeldispattr.font.orientation='0' series.labeldispattr.font.pitch='2'  " + &
"series.labeldispattr.font.strikethrough='0' series.labeldispattr.font.underline='0'  " + &
"series.labeldispattr.font.weight='400' series.labeldispattr.format='[General]'  " + &
"series.labeldispattr.textcolor='0' category.autoscale='1' category.droplines='0' category.frame='1'  " + &
"category.label='"+lvs_category_label+"' category.majordivisions='0' category.majorgridline='0'  " + &
"category.majortic='3' category.maximumvalue='5' category.minimumvalue='0'  " + &
"category.minordivisions='0' category.minorgridline='0' category.minortic='1' category.originline='0'  " + &
"category.primaryline='1' category.roundto='0' category.scaletype='1' category.scalevalue='1'  " + &
"category.secondaryline='0' category.shadebackedge='1' category.dispattr.backcolor='536870912'  " + &
"category.dispattr.alignment='2' category.dispattr.autosize='1' category.dispattr.font.charset='0'  " + &
"category.dispattr.font.escapement='"+lvs_category_escapement+"' category.dispattr.font.face='Tahoma' category.dispattr.font.family='2'  " + &
"category.dispattr.font.height='1' category.dispattr.font.italic='0' category.dispattr.font.orientation='0'  " + &
"category.dispattr.font.pitch='2' category.dispattr.font.strikethrough='0'  " + &
"category.dispattr.font.underline='0' category.dispattr.font.weight='400'  " + &
"category.dispattr.format='[General]' category.dispattr.textcolor='0'  " + &
"category.labeldispattr.backcolor='553648127' category.labeldispattr.alignment='2'  " + &
"category.labeldispattr.autosize='1' category.labeldispattr.font.charset='0'  " + &
"category.labeldispattr.font.escapement='0' category.labeldispattr.font.face='Tahoma'  " + &
"category.labeldispattr.font.family='2' category.labeldispattr.font.height='1'  " + &
"category.labeldispattr.font.italic='0' category.labeldispattr.font.orientation='0'  " + &
"category.labeldispattr.font.pitch='2' category.labeldispattr.font.strikethrough='0'  " + &
"category.labeldispattr.font.underline='0' category.labeldispattr.font.weight='400'  " + &
"category.labeldispattr.format='[General]' category.labeldispattr.textcolor='0'  " + &
"values.autoscale='1' values.droplines='0' values.frame='1' values.label='"+lvs_value_label+"'  " + &
"values.majordivisions='0' values.majorgridline='0' values.majortic='3' values.maximumvalue='1000'  " + &
"values.minimumvalue='0' values.minordivisions='0' values.minorgridline='0' values.minortic='1'  " + &
"values.originline='1' values.primaryline='1' values.roundto='0' values.scaletype='1' values.scalevalue='1'  " + &
"values.secondaryline='0' values.shadebackedge='0' values.dispattr.backcolor='536870912'  " + &
"values.dispattr.alignment='1' values.dispattr.autosize='1' values.dispattr.font.charset='0'  " + &
"values.dispattr.font.escapement='0' values.dispattr.font.face='Tahoma' values.dispattr.font.family='2'  " + &
"values.dispattr.font.height='1' values.dispattr.font.italic='0' values.dispattr.font.orientation='0'  " + &
"values.dispattr.font.pitch='2' values.dispattr.font.strikethrough='0' values.dispattr.font.underline='0'  " + &
"values.dispattr.font.weight='400' values.dispattr.format='[General]' values.dispattr.textcolor='0'  " + &
"values.labeldispattr.backcolor='553648127' values.labeldispattr.alignment='2'  " + &
"values.labeldispattr.autosize='1' values.labeldispattr.font.charset='0'  " + &
"values.labeldispattr.font.escapement='900' values.labeldispattr.font.face='Tahoma'  " + &
"values.labeldispattr.font.family='2' values.labeldispattr.font.height='1'  " + &
"values.labeldispattr.font.italic='0' values.labeldispattr.font.orientation='0'  " + &
"values.labeldispattr.font.pitch='2' values.labeldispattr.font.strikethrough='0'  " + &
"values.labeldispattr.font.underline='0' values.labeldispattr.font.weight='400'  " + &
"values.labeldispattr.format='[General]' values.labeldispattr.textcolor='0' )"

lvs_return = idw_parm.Modify(lvs_syntax)
if lvs_return = "" then 
	idw_parm.modify( lvs_gr_name+".Legend="+lvs_legend)	
else
    Messagebox("Notify" , lvs_syntax )
    Open( w_edit_window )
    Return
end if

Close (parent)
end event

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

event gallery_clicked;call super::gallery_clicked;int li_col,li_row, li_ret
string  ls_graph_type  
// Get the graph type from the graph gallery user object.
li_ret = uf_query_gallery (li_row, li_col, ls_graph_type)
if li_ret = 0 then
	messagebox ("Sorry!","Clicked on invalid type")
	return
end if

	// The user clicked on a graph type. Set the type in the passed 
	// datawindow object.
	Choose Case ls_graph_type
		case "area3d"
			gr_1.GraphType =area3d!
		case "areagraph"
			gr_1.GraphType =areagraph!
		case "bar3dobjgraph"
			gr_1.GraphType =bar3dobjgraph!
		case "barstack3dobjgraph"
			gr_1.GraphType = barstack3dobjgraph!
		case "bargraph"
			gr_1.GraphType =bargraph!
		case "bar3dgraph"
			gr_1.GraphType = bar3dgraph!
		case "barstackgraph"
			gr_1.GraphType =barstackgraph!
			case "col3dgraph"
			gr_1.GraphType =col3dgraph!
		case "col3dobjgraph"
			gr_1.GraphType =col3dobjgraph!
		case "colgraph"
			gr_1.GraphType =colgraph!
		case "colstack3dobjgraph"
			gr_1.GraphType =colstack3dobjgraph!
		case "colstackgraph"
			gr_1.GraphType =colstackgraph!
		case "line3d"
			gr_1.GraphType =line3d!
		case "linegraph"
			gr_1.GraphType =linegraph!
		case "pie3d"
			gr_1.GraphType =pie3d!
		case "piegraph"
			gr_1.GraphType =piegraph!
		case "scattergraph"
			gr_1.GraphType =scattergraph!
		case else
			messagebox ("Error!", "Invalid Graph Type")
	end choose


end event

type sle_graph_title from so_singlelineedit within w_dynamic_graph_popup
integer x = 69
integer y = 352
integer width = 1568
integer taborder = 20
boolean bringtotop = true
long backcolor = 16777215
end type

type em_category_escapement from editmask within w_dynamic_graph_popup
integer x = 178
integer y = 1424
integer width = 343
integer height = 92
integer taborder = 30
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

type st_4 from so_statictext within w_dynamic_graph_popup
integer x = 151
integer y = 1344
integer width = 357
boolean bringtotop = true
integer weight = 700
long backcolor = 67108864
string text = "Escapement"
alignment alignment = right!
end type

type gr_1 from graph within w_dynamic_graph_popup
integer x = 2537
integer y = 348
integer width = 987
integer height = 756
boolean bringtotop = true
boolean enabled = false
grgraphtype graphtype = colgraph!
long backcolor = 67108864
integer spacing = 100
string title = "Sample"
integer elevation = -10
integer rotation = 42
integer perspective = 5
integer depth = 100
grlegendtype legend = atbottom!
boolean focusrectangle = false
grsorttype seriessort = ascending!
grsorttype categorysort = ascending!
end type

on gr_1.create
TitleDispAttr = create grDispAttr
LegendDispAttr = create grDispAttr
PieDispAttr = create grDispAttr
Series = create grAxis
Series.DispAttr = create grDispAttr
Series.LabelDispAttr = create grDispAttr
Category = create grAxis
Category.DispAttr = create grDispAttr
Category.LabelDispAttr = create grDispAttr
Values = create grAxis
Values.DispAttr = create grDispAttr
Values.LabelDispAttr = create grDispAttr
TitleDispAttr.Weight=700
TitleDispAttr.FaceName="Tahoma"
TitleDispAttr.FontCharSet=DefaultCharSet!
TitleDispAttr.FontFamily=Swiss!
TitleDispAttr.FontPitch=Variable!
TitleDispAttr.Alignment=Center!
TitleDispAttr.BackColor=536870912
TitleDispAttr.Format="[General]"
TitleDispAttr.DisplayExpression="title"
TitleDispAttr.AutoSize=true
Category.Label="(None)"
Category.AutoScale=true
Category.ShadeBackEdge=true
Category.SecondaryLine=transparent!
Category.MajorGridLine=transparent!
Category.MinorGridLine=transparent!
Category.DropLines=transparent!
Category.OriginLine=transparent!
Category.MajorTic=Outside!
Category.DataType=adtText!
Category.DispAttr.Weight=400
Category.DispAttr.FaceName="Tahoma"
Category.DispAttr.FontCharSet=DefaultCharSet!
Category.DispAttr.FontFamily=Swiss!
Category.DispAttr.FontPitch=Variable!
Category.DispAttr.Alignment=Center!
Category.DispAttr.BackColor=536870912
Category.DispAttr.Format="[General]"
Category.DispAttr.DisplayExpression="category"
Category.DispAttr.AutoSize=true
Category.LabelDispAttr.Weight=400
Category.LabelDispAttr.FaceName="Tahoma"
Category.LabelDispAttr.FontCharSet=DefaultCharSet!
Category.LabelDispAttr.FontFamily=Swiss!
Category.LabelDispAttr.FontPitch=Variable!
Category.LabelDispAttr.Alignment=Center!
Category.LabelDispAttr.BackColor=536870912
Category.LabelDispAttr.Format="[General]"
Category.LabelDispAttr.DisplayExpression="categoryaxislabel"
Category.LabelDispAttr.AutoSize=true
Values.Label="Value"
Values.AutoScale=true
Values.SecondaryLine=transparent!
Values.MajorGridLine=transparent!
Values.MinorGridLine=transparent!
Values.DropLines=transparent!
Values.MajorTic=Outside!
Values.DataType=adtDouble!
Values.DispAttr.Weight=400
Values.DispAttr.FaceName="Tahoma"
Values.DispAttr.FontCharSet=DefaultCharSet!
Values.DispAttr.FontFamily=Swiss!
Values.DispAttr.FontPitch=Variable!
Values.DispAttr.Alignment=Right!
Values.DispAttr.BackColor=536870912
Values.DispAttr.Format="[General]"
Values.DispAttr.DisplayExpression="value"
Values.DispAttr.AutoSize=true
Values.LabelDispAttr.Weight=400
Values.LabelDispAttr.FaceName="Tahoma"
Values.LabelDispAttr.FontCharSet=DefaultCharSet!
Values.LabelDispAttr.FontFamily=Swiss!
Values.LabelDispAttr.FontPitch=Variable!
Values.LabelDispAttr.Alignment=Center!
Values.LabelDispAttr.BackColor=536870912
Values.LabelDispAttr.Format="[General]"
Values.LabelDispAttr.DisplayExpression="valuesaxislabel"
Values.LabelDispAttr.AutoSize=true
Values.LabelDispAttr.Escapement=900
Series.Label="(None)"
Series.AutoScale=true
Series.SecondaryLine=transparent!
Series.MajorGridLine=transparent!
Series.MinorGridLine=transparent!
Series.DropLines=transparent!
Series.OriginLine=transparent!
Series.MajorTic=Outside!
Series.DataType=adtText!
Series.DispAttr.Weight=400
Series.DispAttr.FaceName="Tahoma"
Series.DispAttr.FontCharSet=DefaultCharSet!
Series.DispAttr.FontFamily=Swiss!
Series.DispAttr.FontPitch=Variable!
Series.DispAttr.BackColor=536870912
Series.DispAttr.Format="[General]"
Series.DispAttr.DisplayExpression="series"
Series.DispAttr.AutoSize=true
Series.LabelDispAttr.Weight=400
Series.LabelDispAttr.FaceName="Tahoma"
Series.LabelDispAttr.FontCharSet=DefaultCharSet!
Series.LabelDispAttr.FontFamily=Swiss!
Series.LabelDispAttr.FontPitch=Variable!
Series.LabelDispAttr.Alignment=Center!
Series.LabelDispAttr.BackColor=536870912
Series.LabelDispAttr.Format="[General]"
Series.LabelDispAttr.DisplayExpression="seriesaxislabel"
Series.LabelDispAttr.AutoSize=true
LegendDispAttr.Weight=400
LegendDispAttr.FaceName="Tahoma"
LegendDispAttr.FontCharSet=DefaultCharSet!
LegendDispAttr.FontFamily=Swiss!
LegendDispAttr.FontPitch=Variable!
LegendDispAttr.BackColor=536870912
LegendDispAttr.Format="[General]"
LegendDispAttr.DisplayExpression="series"
LegendDispAttr.AutoSize=true
PieDispAttr.Weight=400
PieDispAttr.FaceName="Tahoma"
PieDispAttr.FontCharSet=DefaultCharSet!
PieDispAttr.FontFamily=Swiss!
PieDispAttr.FontPitch=Variable!
PieDispAttr.BackColor=536870912
PieDispAttr.Format="[General]"
PieDispAttr.DisplayExpression="if(seriescount > 1, series,string(percentofseries,~"0.00%~"))"
PieDispAttr.AutoSize=true
end on

on gr_1.destroy
destroy TitleDispAttr
destroy LegendDispAttr
destroy PieDispAttr
destroy Series.DispAttr
destroy Series.LabelDispAttr
destroy Series
destroy Category.DispAttr
destroy Category.LabelDispAttr
destroy Category
destroy Values.DispAttr
destroy Values.LabelDispAttr
destroy Values
end on

type htb_perspective from htrackbar within w_dynamic_graph_popup
integer x = 2071
integer y = 372
integer width = 471
integer height = 92
boolean bringtotop = true
integer minposition = -360
integer maxposition = 360
integer position = 2
integer tickfrequency = 10
end type

event moved;gr_1.perspective = scrollpos
end event

type st_5 from so_statictext within w_dynamic_graph_popup
integer x = 1701
integer y = 376
integer width = 347
integer height = 68
boolean bringtotop = true
integer weight = 700
long backcolor = 67108864
string text = "Perspective"
alignment alignment = right!
end type

type htb_elevation from htrackbar within w_dynamic_graph_popup
integer x = 2071
integer y = 492
integer width = 471
integer height = 92
boolean bringtotop = true
integer minposition = -360
integer maxposition = 360
integer position = 20
integer tickfrequency = 10
end type

event moved;gr_1.elevation = scrollpos
end event

type st_6 from so_statictext within w_dynamic_graph_popup
integer x = 1701
integer y = 496
integer width = 347
integer height = 68
boolean bringtotop = true
integer weight = 700
long backcolor = 67108864
string text = "Elevation"
alignment alignment = right!
end type

type htb_rotation from htrackbar within w_dynamic_graph_popup
integer x = 2071
integer y = 620
integer width = 471
integer height = 92
boolean bringtotop = true
integer minposition = -360
integer maxposition = 360
integer position = -20
integer tickfrequency = 10
end type

event moved;gr_1.Rotation = scrollpos
end event

type st_7 from so_statictext within w_dynamic_graph_popup
integer x = 1701
integer y = 624
integer width = 347
integer height = 68
boolean bringtotop = true
integer weight = 700
long backcolor = 67108864
string text = "Rotation"
alignment alignment = right!
end type

type htb_depth from htrackbar within w_dynamic_graph_popup
integer x = 2071
integer y = 724
integer width = 471
integer height = 92
boolean bringtotop = true
integer minposition = -360
integer maxposition = 360
integer position = 100
integer tickfrequency = 10
end type

event moved;gr_1.depth = scrollpos
end event

type st_8 from so_statictext within w_dynamic_graph_popup
integer x = 1701
integer y = 732
integer width = 347
integer height = 68
boolean bringtotop = true
integer weight = 700
long backcolor = 67108864
string text = "Depth"
alignment alignment = right!
end type

type htb_spacing from htrackbar within w_dynamic_graph_popup
integer x = 2071
integer y = 840
integer width = 471
integer height = 92
boolean bringtotop = true
integer minposition = -360
integer maxposition = 360
integer position = 100
integer tickfrequency = 10
end type

event moved;gr_1.spacing = scrollpos
end event

type st_9 from so_statictext within w_dynamic_graph_popup
integer x = 1701
integer y = 840
integer width = 347
integer height = 68
boolean bringtotop = true
integer weight = 700
long backcolor = 67108864
string text = "Sapcing"
alignment alignment = right!
end type

type ddlb_legend from uo_basecode within w_dynamic_graph_popup
integer x = 2094
integer y = 952
integer width = 434
integer height = 432
integer taborder = 50
boolean bringtotop = true
end type

event getfocus;call super::getfocus;this.redraw( 'LEGEND')
end event

event selectionchanged;call super::selectionchanged;IF THIS.GETCODE() = 'ATBOTTOM' THEN 
	GR_1.LEGEND = AtBottom!
ELSEIF  THIS.GETCODE() = 'ATTOP' THEN 
	GR_1.LEGEND = AtTop!
ELSEIF  THIS.GETCODE() = 'ATLEFT' THEN 
	GR_1.LEGEND = AtLeft!	
ELSEIF  THIS.GETCODE() = 'ATRIGHT' THEN 
	GR_1.LEGEND = AtRight!		
END IF
end event

type st_10 from statictext within w_dynamic_graph_popup
integer x = 1701
integer y = 960
integer width = 347
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

type cb_1 from so_commandbutton within w_dynamic_graph_popup
integer x = 55
integer y = 1228
integer height = 100
integer taborder = 50
boolean bringtotop = true
string text = "Change Color"
end type

event clicked;call super::clicked;SetPointer(HourGlass!)
//open the change color window and pass the graph to it in the 
//message.powerobjectparm
OpenWithParm (w_graph_color, gr_1)
end event

type lb_category from listbox within w_dynamic_graph_popup
integer x = 73
integer y = 440
integer width = 709
integer height = 660
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
boolean vscrollbar = true
boolean sorted = false
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;// When the category changes, we need to reconfigure everything on
// the graph. The selectionchanged event for the value list does this.
TriggerEvent (plb_value, selectionchanged!)
// set category label

integer 	li_ItemTotal, li_ItemCount
string	ls_label
// Get the number of items in the ListBox.
li_ItemTotal = this.TotalItems( )
// Loop through all the items.
FOR li_ItemCount = 1 to li_ItemTotal

// Is the item selected? If so, display the text
	IF this.State(li_ItemCount) = 1 THEN 
		ls_label	= ls_label + ' ' + TRIM(MID(  this.text(li_ItemCount),  1, POS(  this.text(li_ItemCount) , ':' )-1 ))
	END IF
	
NEXT

gr_1.Category.Label = ls_label
end event

type plb_value from picturelistbox within w_dynamic_graph_popup
integer x = 795
integer y = 440
integer width = 837
integer height = 660
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
boolean sorted = false
boolean multiselect = true
string item[] = {"","",""}
borderstyle borderstyle = stylelowered!
integer itempictureindex[] = {0,0,0}
string picturename[] = {"Graph!","Custom038!"}
long picturemaskcolor = 536870912
end type

event doubleclicked;string	ls_text

ls_text	=	this.text (index )

this.deleteitem(index)

if left(ls_text,1)  <>  '+' then
	this.insertitem( '+' + ls_text, 2, index)
else
	this.insertitem( mid(ls_text,2,100), 1, index)
end if


end event

event selectionchanged;int 		i
string	ls_colname, ls_title

gr_1.SetRedraw (False)

// Clear out all categories, series and data from the graph
gr_1.reset ( all! )

// Loop through all selected values and create as many series as the
// user specified.
for i = 1 to totalitems ( )
	If this.state ( i ) = 1 then
		ls_colname	= 	TRIM(MID(  this.text ( i ),  POS(   this.text ( i ) , ':' ) +1, 200 ))
		ls_title		= 	TRIM(MID(  this.text ( i ),  1, POS(   this.text ( i ) , ':' ) -1 ))
		
		wf_set_a_series (ls_title, ls_colname, TRIM(MID(  lb_category.text(lb_category.SelectedIndex()),  POS(  lb_category.text(lb_category.SelectedIndex()) , ':' ) +1, 200 )))		
	end if
next

gr_1.SetRedraw (True)
end event

type gb_1 from so_groupbox within w_dynamic_graph_popup
integer x = 27
integer y = 292
integer width = 1641
integer height = 824
integer taborder = 20
integer weight = 700
long textcolor = 16711680
long backcolor = 67108864
string text = "General Data"
end type

type gb_2 from so_groupbox within w_dynamic_graph_popup
integer x = 1678
integer y = 308
integer width = 1874
integer height = 808
integer taborder = 30
integer weight = 700
long textcolor = 16711680
long backcolor = 67108864
string text = "3D Pie Property"
end type

type gb_3 from so_groupbox within w_dynamic_graph_popup
integer x = 27
integer y = 1136
integer width = 590
integer height = 1052
integer taborder = 40
integer weight = 700
long textcolor = 16711680
long backcolor = 67108864
string text = "Property"
end type

