HA$PBExportHeader$w_table_description_rpt.srw
$PBExportComments$$$HEX8$$4cd174c714be24c185baacb9ecd3b8d2$$ENDHEX$$
forward
global type w_table_description_rpt from w_main_root
end type
type st_1 from statictext within w_table_description_rpt
end type
type ddlb_table_name from uo_table_name within w_table_description_rpt
end type
type rb_desc from so_radiobutton within w_table_description_rpt
end type
type rb_spec from so_radiobutton within w_table_description_rpt
end type
type cb_get_spec from so_commandbutton within w_table_description_rpt
end type
type gb_where_condition from groupbox within w_table_description_rpt
end type
type gb_1 from groupbox within w_table_description_rpt
end type
type gb_2 from groupbox within w_table_description_rpt
end type
end forward

global type w_table_description_rpt from w_main_root
string title = "Table Description Report"
st_1 st_1
ddlb_table_name ddlb_table_name
rb_desc rb_desc
rb_spec rb_spec
cb_get_spec cb_get_spec
gb_where_condition gb_where_condition
gb_1 gb_1
gb_2 gb_2
end type
global w_table_description_rpt w_table_description_rpt

type variables

end variables

on w_table_description_rpt.create
int iCurrent
call super::create
this.st_1=create st_1
this.ddlb_table_name=create ddlb_table_name
this.rb_desc=create rb_desc
this.rb_spec=create rb_spec
this.cb_get_spec=create cb_get_spec
this.gb_where_condition=create gb_where_condition
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.ddlb_table_name
this.Control[iCurrent+3]=this.rb_desc
this.Control[iCurrent+4]=this.rb_spec
this.Control[iCurrent+5]=this.cb_get_spec
this.Control[iCurrent+6]=this.gb_where_condition
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.gb_2
end on

on w_table_description_rpt.destroy
call super::destroy
destroy(this.st_1)
destroy(this.ddlb_table_name)
destroy(this.rb_desc)
destroy(this.rb_spec)
destroy(this.cb_get_spec)
destroy(this.gb_where_condition)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event activate;call super::activate;
/***************************************
* $$HEX17$$08c7c4b324c115c8d0c5200000ad5cd52000acc06dd544c720004bc105d35cd5e4b2$$ENDHEX$$
*
*
****************************************/
Gst_set.window_id        = this.classname() 
Gst_set.author           = "JiSheng Technology"
Gst_set.creation_date    = '20041101'
Gst_set.last_modify_date = '20041101'
Gst_set.Report_window    = TRUE  // $$HEX7$$08b8ecd3b8d2200008c7c4b3b0c6$$ENDHEX$$

/****************************************

*****************************************/
 
IVS_RESIZE_TYPE    = 'NORMAL'  // $$HEX25$$08c7c4b3b0c620006cd030aed0c5200030b57cb7200070b374c7c0d0200008c7c4b3b0c62000acc074c788c92000c0bcbdac$$ENDHEX$$
ivs_modify_security = 'N'
ivs_dw_1_selected_row_yn ='N'
/****************************************
* $$HEX6$$54ba74b2200078d5e4b4c1b9$$ENDHEX$$
* ADMIN     : ADMIN  ( $$HEX5$$04c8b4ccacc0a9c62000$$ENDHEX$$)
* $$HEX8$$00adacb9200020002000200020002000$$ENDHEX$$: MANAGE ( $$HEX8$$04c854ba74b2acc0a9c600aca5b22000$$ENDHEX$$)
* $$HEX7$$acc0a9c690c72000200020002000$$ENDHEX$$: GUEST  ( $$HEX11$$30ae08cd2000f1b45db8200070c88cd6200000aca5b2$$ENDHEX$$)
* $$HEX8$$70c88cd6200020002000200020002000$$ENDHEX$$: QUERY  ( $$HEX10$$15c8f4bc70c88cd6ccb9200000aca5b220002000$$ENDHEX$$)
* $$HEX5$$70b374c7c0d070c891c7$$ENDHEX$$: DATA_CONTROL  ( $$HEX12$$85c725b8200018c215c82000adc01cc8200024c115c82000$$ENDHEX$$)
* $$HEX7$$08b8ecd3b8d22000200020002000$$ENDHEX$$: REPORT ( $$HEX4$$08b8ecd3b8d22000$$ENDHEX$$, $$HEX5$$9ccd25b800adacb92000$$ENDHEX$$)
****************************************/
f_menu_control('DATA_CONTROL_MODIFY' , TRUE)  // $$HEX8$$70b374c7c0d0200070c891c700aca5b2$$ENDHEX$$
/****************************************
* $$HEX11$$70b374c7c0d0200008c7c4b3b0c6200078d5e4b4c1b9$$ENDHEX$$
****************************************/

end event

event open;call super::open;SELECTED_DATA_WINDOW = DW_1
end event

event ue_data_control;call super::ue_data_control;Long ROW
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		
		if rb_desc.checked = true then 
		   DW_1.RESET()
		   DW_1.RETRIEVE(ddlb_table_name.text)
             DW_1.SETFOCUS()
		else
			
		   DW_2.RESET()
		   DW_2.RETRIEVE()
             DW_2.SETFOCUS()			
			
		end if
			
			
	CASE 'UPDATE'
	      IF DW_1.UPDATE() < 0 THEN
				ROLLBACK;
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP(F_MSG_ST(170)) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			END IF
			
	CASE ELSE
END CHOOSE

end event

event ue_post_open;call super::ue_post_open;
/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
end event

type dw_5 from w_main_root`dw_5 within w_table_description_rpt
integer x = 9
integer y = 340
end type

type dw_4 from w_main_root`dw_4 within w_table_description_rpt
integer x = 9
integer y = 340
end type

type dw_3 from w_main_root`dw_3 within w_table_description_rpt
integer x = 9
integer y = 340
end type

type dw_2 from w_main_root`dw_2 within w_table_description_rpt
integer x = 9
integer y = 340
end type

type dw_1 from w_main_root`dw_1 within w_table_description_rpt
integer x = 9
integer y = 340
integer width = 4631
integer height = 2208
boolean titlebar = true
string title = "Table Description"
string dataobject = "d_table_description_rpt"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_table_description_rpt
end type

type st_1 from statictext within w_table_description_rpt
integer x = 763
integer y = 96
integer width = 1458
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Table Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_table_name from uo_table_name within w_table_description_rpt
integer x = 782
integer y = 192
integer width = 1458
integer height = 2124
integer taborder = 20
boolean bringtotop = true
end type

type rb_desc from so_radiobutton within w_table_description_rpt
integer x = 59
integer y = 96
integer width = 553
boolean bringtotop = true
integer weight = 700
string text = "Table Description"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = True
selected_data_window = dw_1
cb_get_spec.enabled  = False

//$$HEX2$$94cd00ac$$ENDHEX$$
end event

type rb_spec from so_radiobutton within w_table_description_rpt
integer x = 59
integer y = 200
integer width = 622
boolean bringtotop = true
integer weight = 700
string text = "Table Specification"
end type

event clicked;call super::clicked;dw_2.bringtotop = True
selected_data_window = dw_2
cb_get_spec.enabled  = True
end event

type cb_get_spec from so_commandbutton within w_table_description_rpt
integer x = 2414
integer y = 120
integer height = 116
integer taborder = 20
boolean bringtotop = true
boolean enabled = false
string text = "Get Table Spec"
end type

event clicked;call super::clicked;
//==========================================================================
// $$HEX5$$c0bc18c2200020c1b8c5$$ENDHEX$$
//==========================================================================
string lvs_table_name
STRING ERRORS, sql_syntax
STRING presentation_str, dwsyntax_str

STRING lvs_col_name, lvs_column_type , lvs_update_yn , lvs_format , lvs_editmask , lvs_visible_yn 
STRING lvs_no_width , lvs_column_title_prev_X , lvs_column_title_X , lvs_column_title_Y
STRING lvs_print_title_x , lvs_print_date_x , lvs_page_count_x , lvs_organization_id_title_x , lvs_organization_id_x
STRING lvs_column_title_Height , lvs_column_title_Width
Integer lvi_count 

STRING MODIFY_STRING , LVS_TITLE , LVS_RETURN
Long lvl_Return
//==========================================================================
//
//==========================================================================
lvs_table_name  = DDLB_TABLE_NAME.TEXT
IF lvs_table_name < '%' OR ISNULL(lvs_table_name) THEN RETURN

//================================================
//
//================================================
SQL_SYNTAX = "SELECT  * FROM "+lvs_table_name +" WHERE 1 = 2 "
PRESENTATION_STR =  "style(type=grid)"

DWSYNTAX_STR = SQLCA.SYNTAXFROMSQL(SQL_SYNTAX,   PRESENTATION_STR, ERRORS)

IF LEN(ERRORS) > 0 THEN
   MESSAGEBOX("CAUTION",  "SYNTAXFROMSQL CAUSED THESE ERRORS: " + ERRORS)
   RETURN
END IF

dw_2.DATAOBJECT = 'd_board_content'
dw_2.CREATE( DWSYNTAX_STR, ERRORS)
dw_2.BRINGTOTOP = TRUE 
dw_2.OBJECT.DATAWINDOW.TABLE.UPDATEKEYINPLACE='YES'
dw_2.OBJECT.DATAWINDOW.TABLE.UPDATEWHERE=2

IF LEN(ERRORS) > 0 THEN
   MESSAGEBOX("CAUTION", "CREATE CAUSE THESE ERRORS: " + ERRORS)
   RETURN
END IF

//================================================
//
//================================================

dw_2.settransobject(sqlca)
selected_data_window = dw_2
F_DUAL_LANG_CHANGE_TEXT(PARENT)
//=======================================
// 
//=======================================


dw_2.Modify("DataWindow.Header.COLOR='536870912'")
dw_2.Modify("DataWindow.Header.Height='464'")
dw_2.Modify("DataWindow.Detail.Height='108'")

dw_2.Modify("DataWindow.footer.COLOR='536870912'")
dw_2.Modify("DataWindow.footer.Height='84'")

//=======================================
//
//=======================================

gst_dw_colinfo.i_dw_colcount = 0
gst_dw_colinfo.i_dw_colcount=Integer(  dw_2.Describe("DataWindow.Column.Count"))

//=======================================

For lvi_count = 1 to gst_dw_colinfo.i_dw_colcount
		
	lvs_col_name	= dw_2.Describe('#'+String(lvi_count)+".Name")	

    //==============================================
    // $$HEX11$$eccefcb7c0d074c7c0d2200000ad28b820008dc131c1$$ENDHEX$$
    //==============================================	 
	lvs_column_title_Height = dw_2.Describe(lvs_col_name+'_t' + ".Height")
	lvs_column_title_Width  = dw_2.Describe(lvs_col_name+'_t' + ".width")	
	lvs_column_type            = mid(dw_2.Describe(lvs_col_name+ ".ColType"),1,4)
     lvs_column_title_Y = '300'
     lvs_column_title_Height = '110'	  
	  
	//=============================================
	// $$HEX9$$f5acb5d1f0d3b8d220008dc131c1c0bcbdac$$ENDHEX$$
	//=============================================
	dw_2.Modify(lvs_col_name+'_t' + ".font.face='TAHOMA'" )
	dw_2.Modify(lvs_col_name+".font.face='TAHOMA'" )	
	  
	//=============================================
	// $$HEX12$$eccefcb754d674ba5cd4dcc220006cd030ae2000c0bcbdac$$ENDHEX$$
	//=============================================	
		lvs_column_title_Width = string(lvl_Return)
		dw_2.Modify(lvs_col_name+'_t' + ".Width=400")				// 300 $$HEX3$$6cd030ae2000$$ENDHEX$$
		dw_2.Modify(lvs_col_name + ".Width=400")
	
    //==============================================
    // $$HEX11$$eccefcb7c0d074c7c0d2200000ad28b820008dc131c1$$ENDHEX$$
    //==============================================	 	
	dw_2.Modify(lvs_col_name+'_t' + ".Y='"+lvs_column_title_Y+"'")				
	dw_2.Modify(lvs_col_name+'_t' + ".Height='"+lvs_column_title_Height+"'")					
	dw_2.Modify(lvs_col_name+'_t' + ".Border='"+'2'+"'")			//BOX			
	
	
	IF UPPER(lvs_column_type) = 'DATE' OR  UPPER(lvs_column_type) = 'CHAR' THEN 	
		dw_2.Modify(lvs_col_name+'_t' + ".ALIGNMENT='"+'0'+"'")			//LEFT 0
	ELSE
		dw_2.Modify(lvs_col_name+'_t' + ".ALIGNMENT='"+'1'+"'")			//LEFT 0
	END IF	
	
    //==============================================
    // $$HEX8$$eccefcb7200000ad28b820008dc131c1$$ENDHEX$$
    //==============================================	 	
	
	IF UPPER(lvs_column_type) = 'DATE' OR  UPPER(lvs_column_type) = 'CHAR' THEN 	
		dw_2.Modify(lvs_col_name+ ".ALIGNMENT='"+'0'+"'")			//RIGHT 1
	ELSE
		dw_2.Modify(lvs_col_name+ ".ALIGNMENT='"+'1'+"'")			//LEFT 0
	END IF
	
    //==============================================	 		
	 
Next

//====================================
F_MSG_MDI_HELP( F_MSG_ST(170)) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
DW_2.INSERTROW(0)
end event

type gb_where_condition from groupbox within w_table_description_rpt
integer width = 713
integer height = 324
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Where Condition"
end type

type gb_1 from groupbox within w_table_description_rpt
integer x = 2281
integer width = 800
integer height = 324
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Process"
end type

type gb_2 from groupbox within w_table_description_rpt
integer x = 727
integer width = 1545
integer height = 324
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Where Condition"
end type

