HA$PBExportHeader$uo_dynamic_filter.sru
forward
global type uo_dynamic_filter from userobject
end type
type sle_1 from so_singlelineedit within uo_dynamic_filter
end type
type ddlb_column_name from so_dropdownlistbox within uo_dynamic_filter
end type
end forward

global type uo_dynamic_filter from userobject
integer width = 1513
integer height = 100
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
sle_1 sle_1
ddlb_column_name ddlb_column_name
end type
global uo_dynamic_filter uo_dynamic_filter

type variables
datawindow ivd_datawindow
end variables

forward prototypes
public function integer redraw (datawindow arg_dw)
end prototypes

public function integer redraw (datawindow arg_dw);int lvi_count
string lvs_col_type, ls_names , ls_names_list , ls_object_name , ls_desc , ls_datatype

ivd_datawindow = arg_dw

	ls_names_list = arg_dw.Object.DataWindow.objects
	
	// Get each object from the list and add it to the objects listbox
	//The character fields are added to the category list box and the
	//number fields are added to the value listbox
	ls_names = ls_names_list
	
	ddlb_column_name.reset()
	
	do 
		ls_object_name = f_get_token (ls_names, "~t")
		lvs_col_type = arg_dw.Describe(ls_object_name + ".type") 
		ls_datatype  = arg_dw.Describe(ls_object_name + ".coltype")
		if lvs_col_type = "column"  then
			ls_desc		= arg_dw.Describe(ls_object_name+'_t' + ".text")
				//messagebox('', ls_desc)
				ddlb_column_name.AddItem (ls_desc+'                                                                     :'+ls_object_name+'#'+ls_datatype)
		end if
	loop until ls_names = ""

return 0 
end function

on uo_dynamic_filter.create
this.sle_1=create sle_1
this.ddlb_column_name=create ddlb_column_name
this.Control[]={this.sle_1,&
this.ddlb_column_name}
end on

on uo_dynamic_filter.destroy
destroy(this.sle_1)
destroy(this.ddlb_column_name)
end on

type sle_1 from so_singlelineedit within uo_dynamic_filter
integer x = 800
integer width = 709
integer height = 84
integer taborder = 20
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN , lvs_datatype
int lvi_return

ivd_datawindow.SETFILTER('')
ivd_datawindow.FILTER()


lvs_datatype= TRIM(MID(   ddlb_column_name.text , POS(   ddlb_column_name.text , '#' )+1    ,   Len(ddlb_column_name.text) )   )   
LVS_COLUMN = TRIM(MID(   ddlb_column_name.text , POS(   ddlb_column_name.text , ':' )+1    ,   POS(   ddlb_column_name.text , '#' )- ( POS(   ddlb_column_name.text , ':' )+1)  )   )   

IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    ivd_datawindow.SETFILTER('')
    ivd_datawindow.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

if mid(lvs_datatype,1,4) = 'char' then
	LVI_RETURN = ivd_datawindow.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
elseif lvs_datatype = 'number' or lvs_datatype = 'int' or lvs_datatype = 'long' or mid(lvs_datatype ,1,3)= 'dec' or lvs_datatype = 'double' then
	LVI_RETURN = ivd_datawindow.SETFILTER( 'string('+LVS_COLUMN+')'  +" LIKE '"+LVS_VALUE+"'")
elseif mid(lvs_datatype ,1,4) = 'date'  then 
	LVI_RETURN = ivd_datawindow.SETFILTER( 'string('+LVS_COLUMN+')'  +" LIKE '"+LVS_VALUE+"'")
end if
	
ivd_datawindow.FILTER()

IF LVI_RETURN > 0 THEN 
	F_MSG_MDI_HELP( STRING( ivd_datawindow.ROWCOUNT() ) + " Found" )
ELSE
	F_MSG_MDI_HELP(LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
END IF
end event

type ddlb_column_name from so_dropdownlistbox within uo_dynamic_filter
integer width = 795
integer height = 608
integer taborder = 10
end type

