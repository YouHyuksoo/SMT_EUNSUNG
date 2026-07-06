HA$PBExportHeader$w_excel_loader_master.srw
$PBExportComments$Dual Language Information Manage
forward
global type w_excel_loader_master from w_main_root
end type
type cb_2 from so_commandbutton within w_excel_loader_master
end type
type sle_sheet_name from so_singlelineedit within w_excel_loader_master
end type
type cb_1 from so_commandbutton within w_excel_loader_master
end type
type st_2 from so_statictext within w_excel_loader_master
end type
type cb_3 from so_commandbutton within w_excel_loader_master
end type
type sle_excel_column_name from so_singlelineedit within w_excel_loader_master
end type
type st_3 from so_statictext within w_excel_loader_master
end type
type cb_4 from so_commandbutton within w_excel_loader_master
end type
type ddlb_table_name from uo_table_name within w_excel_loader_master
end type
type sle_table_column_name from so_singlelineedit within w_excel_loader_master
end type
type st_1 from so_statictext within w_excel_loader_master
end type
type cbx_auto_link from so_checkbox within w_excel_loader_master
end type
type cb_5 from so_commandbutton within w_excel_loader_master
end type
type cb_6 from so_commandbutton within w_excel_loader_master
end type
type cb_7 from so_commandbutton within w_excel_loader_master
end type
type sle_1 from so_singlelineedit within w_excel_loader_master
end type
type sle_2 from so_singlelineedit within w_excel_loader_master
end type
type cb_8 from so_commandbutton within w_excel_loader_master
end type
type rb_id_item from so_radiobutton within w_excel_loader_master
end type
type rb_bom from so_radiobutton within w_excel_loader_master
end type
type rb_buy_price from so_radiobutton within w_excel_loader_master
end type
type rb_sale_price from so_radiobutton within w_excel_loader_master
end type
type rb_shipping from so_radiobutton within w_excel_loader_master
end type
type em_sap_yyyymm from uo_ym within w_excel_loader_master
end type
type cb_delete_all from so_commandbutton within w_excel_loader_master
end type
type rb_2 from so_radiobutton within w_excel_loader_master
end type
type rb_item_receipt from so_radiobutton within w_excel_loader_master
end type
type cbx_unit_bom from so_checkbox within w_excel_loader_master
end type
type gb_2 from so_groupbox within w_excel_loader_master
end type
type gb_1 from so_groupbox within w_excel_loader_master
end type
type gb_3 from so_groupbox within w_excel_loader_master
end type
type gb_4 from so_groupbox within w_excel_loader_master
end type
type gb_5 from so_groupbox within w_excel_loader_master
end type
type gb_6 from so_groupbox within w_excel_loader_master
end type
end forward

global type w_excel_loader_master from w_main_root
integer height = 2808
string title = "Excel Loader"
cb_2 cb_2
sle_sheet_name sle_sheet_name
cb_1 cb_1
st_2 st_2
cb_3 cb_3
sle_excel_column_name sle_excel_column_name
st_3 st_3
cb_4 cb_4
ddlb_table_name ddlb_table_name
sle_table_column_name sle_table_column_name
st_1 st_1
cbx_auto_link cbx_auto_link
cb_5 cb_5
cb_6 cb_6
cb_7 cb_7
sle_1 sle_1
sle_2 sle_2
cb_8 cb_8
rb_id_item rb_id_item
rb_bom rb_bom
rb_buy_price rb_buy_price
rb_sale_price rb_sale_price
rb_shipping rb_shipping
em_sap_yyyymm em_sap_yyyymm
cb_delete_all cb_delete_all
rb_2 rb_2
rb_item_receipt rb_item_receipt
cbx_unit_bom cbx_unit_bom
gb_2 gb_2
gb_1 gb_1
gb_3 gb_3
gb_4 gb_4
gb_5 gb_5
gb_6 gb_6
end type
global w_excel_loader_master w_excel_loader_master

type variables
datawindow ivd_data_window
end variables

on w_excel_loader_master.create
int iCurrent
call super::create
this.cb_2=create cb_2
this.sle_sheet_name=create sle_sheet_name
this.cb_1=create cb_1
this.st_2=create st_2
this.cb_3=create cb_3
this.sle_excel_column_name=create sle_excel_column_name
this.st_3=create st_3
this.cb_4=create cb_4
this.ddlb_table_name=create ddlb_table_name
this.sle_table_column_name=create sle_table_column_name
this.st_1=create st_1
this.cbx_auto_link=create cbx_auto_link
this.cb_5=create cb_5
this.cb_6=create cb_6
this.cb_7=create cb_7
this.sle_1=create sle_1
this.sle_2=create sle_2
this.cb_8=create cb_8
this.rb_id_item=create rb_id_item
this.rb_bom=create rb_bom
this.rb_buy_price=create rb_buy_price
this.rb_sale_price=create rb_sale_price
this.rb_shipping=create rb_shipping
this.em_sap_yyyymm=create em_sap_yyyymm
this.cb_delete_all=create cb_delete_all
this.rb_2=create rb_2
this.rb_item_receipt=create rb_item_receipt
this.cbx_unit_bom=create cbx_unit_bom
this.gb_2=create gb_2
this.gb_1=create gb_1
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_5=create gb_5
this.gb_6=create gb_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.sle_sheet_name
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.cb_3
this.Control[iCurrent+6]=this.sle_excel_column_name
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.cb_4
this.Control[iCurrent+9]=this.ddlb_table_name
this.Control[iCurrent+10]=this.sle_table_column_name
this.Control[iCurrent+11]=this.st_1
this.Control[iCurrent+12]=this.cbx_auto_link
this.Control[iCurrent+13]=this.cb_5
this.Control[iCurrent+14]=this.cb_6
this.Control[iCurrent+15]=this.cb_7
this.Control[iCurrent+16]=this.sle_1
this.Control[iCurrent+17]=this.sle_2
this.Control[iCurrent+18]=this.cb_8
this.Control[iCurrent+19]=this.rb_id_item
this.Control[iCurrent+20]=this.rb_bom
this.Control[iCurrent+21]=this.rb_buy_price
this.Control[iCurrent+22]=this.rb_sale_price
this.Control[iCurrent+23]=this.rb_shipping
this.Control[iCurrent+24]=this.em_sap_yyyymm
this.Control[iCurrent+25]=this.cb_delete_all
this.Control[iCurrent+26]=this.rb_2
this.Control[iCurrent+27]=this.rb_item_receipt
this.Control[iCurrent+28]=this.cbx_unit_bom
this.Control[iCurrent+29]=this.gb_2
this.Control[iCurrent+30]=this.gb_1
this.Control[iCurrent+31]=this.gb_3
this.Control[iCurrent+32]=this.gb_4
this.Control[iCurrent+33]=this.gb_5
this.Control[iCurrent+34]=this.gb_6
end on

on w_excel_loader_master.destroy
call super::destroy
destroy(this.cb_2)
destroy(this.sle_sheet_name)
destroy(this.cb_1)
destroy(this.st_2)
destroy(this.cb_3)
destroy(this.sle_excel_column_name)
destroy(this.st_3)
destroy(this.cb_4)
destroy(this.ddlb_table_name)
destroy(this.sle_table_column_name)
destroy(this.st_1)
destroy(this.cbx_auto_link)
destroy(this.cb_5)
destroy(this.cb_6)
destroy(this.cb_7)
destroy(this.sle_1)
destroy(this.sle_2)
destroy(this.cb_8)
destroy(this.rb_id_item)
destroy(this.rb_bom)
destroy(this.rb_buy_price)
destroy(this.rb_sale_price)
destroy(this.rb_shipping)
destroy(this.em_sap_yyyymm)
destroy(this.cb_delete_all)
destroy(this.rb_2)
destroy(this.rb_item_receipt)
destroy(this.cbx_unit_bom)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_5)
destroy(this.gb_6)
end on

event activate;call super::activate;/***************************************
* $$HEX17$$08c7c4b324c115c8d0c5200000ad5cd52000acc06dd544c720004bc105d35cd5e4b2$$ENDHEX$$
*
*
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20051101'
Gst_set.last_modify_date = '20051101'
Gst_set.Report_window    = False  // Report Window  True / Flase

/*****************************************
* Data WIndow Property
******************************************/
Ivs_resize_type    = 'MASTER_DETAIL_12T_3B'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

/****************************************
* Menu Property $$HEX6$$54ba74b2200078d5e4b4c1b9$$ENDHEX$$
*****************************************
* ADMIN     : ADMIN  ( $$HEX5$$04c8b4ccacc0a9c62000$$ENDHEX$$)
* $$HEX8$$00adacb9200020002000200020002000$$ENDHEX$$: MANAGE ( $$HEX8$$04c854ba74b2acc0a9c600aca5b22000$$ENDHEX$$)
* $$HEX7$$acc0a9c690c72000200020002000$$ENDHEX$$: GUEST  ( $$HEX11$$30ae08cd2000f1b45db8200070c88cd6200000aca5b2$$ENDHEX$$)
* $$HEX8$$70c88cd6200020002000200020002000$$ENDHEX$$: QUERY  ( $$HEX10$$15c8f4bc70c88cd6ccb9200000aca5b220002000$$ENDHEX$$)
* $$HEX5$$70b374c7c0d070c891c7$$ENDHEX$$: DATA_CONTROL  ( $$HEX12$$85c725b8200018c215c82000adc01cc8200024c115c82000$$ENDHEX$$)
* $$HEX7$$08b8ecd3b8d22000200020002000$$ENDHEX$$: REPORT ( $$HEX4$$08b8ecd3b8d22000$$ENDHEX$$, $$HEX5$$9ccd25b800adacb92000$$ENDHEX$$)
****************************************/

F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control

/****************************************
* 
****************************************/

end event

event ue_data_control;call super::ue_data_control;Long row

CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'

			
	CASE 'INSERT'
		

			
	CASE 'APPEND'
		
			
	CASE 'DELETE'
		
		IF selected_data_window.GETROW() < 1 THEN RETURN 
			MSG = F_MSGBOX(1003) 
			IF MSG = 1 THEN
				GVL_ROW_DELETED = selected_data_window.GETROW()			
				selected_data_window.DELETEROW(GVL_ROW_DELETED)		
				selected_data_window.SETFOCUS()
				ROW = selected_data_window.GETROW()
				selected_data_window.SCROLLTOROW(ROW)
				selected_data_window.SETCOLUMN(1)
			END IF			
			
			
	CASE 'UPDATE'
		
		  if dw_3.update( ) < 0 then 
			Messagebox("Notify" , SQLCA.SQLErrtext )
			rollback;
		else
			commit ;
		end if
			
	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_excel_loader_master
integer y = 628
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_excel_loader_master
integer y = 632
integer taborder = 50
end type

type dw_3 from w_main_root`dw_3 within w_excel_loader_master
integer y = 1740
integer width = 3927
integer height = 748
integer taborder = 60
boolean titlebar = true
string title = "Table Specification"
end type

event dw_3::clicked;call super::clicked;sle_table_column_name.text = Gvs_columnname

drag(begin!)
end event

event dw_3::itemchanged;//OVERRIDE
end event

type dw_2 from w_main_root`dw_2 within w_excel_loader_master
integer x = 1966
integer y = 576
integer width = 1961
integer height = 1156
integer taborder = 70
boolean titlebar = true
string title = "Column Mapping"
string dataobject = "d_excel_loader_column_link"
end type

event dw_2::dragdrop;call super::dragdrop;datawindow ldw_Source
Long rows
IF source.TypeOf() = DataWindow! THEN

        ldw_Source = source

	
	if row < 1 then 
		rows = this.insertrow(0)
	else
		rows = row
	end if
	
	
            if upper(ldw_Source.classname( )) = 'DW_1' then
				
				this.object.excel_column_name[rows] = sle_excel_column_name.text
				
		elseif upper(ldw_Source.classname( )) = 'DW_3' then
			
				this.object.table_column_name[rows] = sle_table_column_name.text
				
		end if
END IF

drag(end!)
end event

event dw_2::clicked;call super::clicked;long i
if dwo.name = 'b_same' then 
	
	this.object.table_column_name[row] = this.object.excel_column_name[row]
	
elseif  dwo.name = 'b_del' then 
	
	this.deleterow(row)
	
elseif dwo.name = 'b_all_same' then 
	
	do
		i++
		
			this.object.table_column_name[i] = this.object.excel_column_name[i]
		
	loop until i = dw_2.rowcount( )
	
elseif dwo.name = 'b_all_del' then 
	
	do
		i++
		
			this.deleterow(i)
		
	loop until i = dw_2.rowcount( )
		
	
end if 
end event

event dw_2::itemchanged;//OVERRIDE
end event

type dw_1 from w_main_root`dw_1 within w_excel_loader_master
integer y = 576
integer width = 1961
integer height = 1156
integer taborder = 0
boolean titlebar = true
string title = "Excel Data"
end type

event dw_1::clicked;call super::clicked;sle_excel_column_name.text = Gvs_columnname

drag(begin!)
end event

type cb_2 from so_commandbutton within w_excel_loader_master
integer x = 37
integer y = 100
integer width = 389
integer taborder = 50
boolean bringtotop = true
string text = "Connect"
end type

event clicked;call super::clicked;DBTrans = CREATE transaction
DBTrans.DBMS = "ODBC"
DBTrans.AutoCommit = False
DBTrans.DBParm = "ConnectString='DSN=Excel Files;UID=;PWD='"

Connect Using DBTrans ;

if f_sql_check_dbtrans() < 0 then 
	return
else
	f_msg_mdi_help("Connect OK")
end if


ChangeDirectory( Gvs_default_directory)
end event

type sle_sheet_name from so_singlelineedit within w_excel_loader_master
integer x = 448
integer y = 104
integer width = 978
integer taborder = 60
boolean bringtotop = true
end type

type cb_1 from so_commandbutton within w_excel_loader_master
integer x = 37
integer y = 188
integer width = 389
integer height = 84
integer taborder = 60
boolean bringtotop = true
string text = "DisConnect"
end type

event clicked;call super::clicked;Disconnect Using DBTrans ;
end event

type st_2 from so_statictext within w_excel_loader_master
integer x = 448
integer y = 44
integer width = 978
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Excel Sheet Name"
end type

type cb_3 from so_commandbutton within w_excel_loader_master
integer x = 1440
integer y = 100
integer width = 434
integer height = 84
integer taborder = 70
boolean bringtotop = true
string text = "Retrieve"
boolean default = true
end type

event clicked;call super::clicked;string ERRORS, sql_syntax , lvs_sheet_name
string presentation_str, dwsyntax_str

//==========================
//
//==========================
lvs_sheet_name = sle_sheet_name.text


sql_syntax =  'select * from ['+lvs_sheet_name+'$]'

presentation_str = "style(type=grid)"
dwsyntax_str = DBTrans.SyntaxFromSQL(sql_syntax, presentation_str, ERRORS)

IF Len(ERRORS) > 0 THEN
   MessageBox("Caution" , "SyntaxFromSQL caused these errors: " + ERRORS)
   RETURN
END IF

dw_1.CREATE( DWSYNTAX_STR, ERRORS)
dw_1.BRINGTOTOP = TRUE 
dw_1.OBJECT.DATAWINDOW.TABLE.UPDATEKEYINPLACE='YES'
dw_1.OBJECT.DATAWINDOW.TABLE.UPDATEWHERE=2

//================================================
//
//================================================
IF Len(ERRORS) > 0 THEN
   MessageBox("Caution", "Create cause these errors: " + ERRORS)
   RETURN
END IF

dw_1.settransobject( DBTrans)
dw_1.retrieve( )
//=================================================
//
//=================================================
Int lvi_count , rows
string lvs_col_name
Gst_dw_colinfo.i_dw_colcount = 0
Gst_dw_colinfo.i_dw_colcount=Integer(  dw_1.Describe("DataWindow.Column.Count"))
//======================================================================
// Column Object $$HEX2$$7cb92000$$ENDHEX$$Scan $$HEX2$$5cd5e4b2$$ENDHEX$$
//======================================================================

string lvs_table_name_map[] 
//lvs_table_name_map[1] = 'SEQ'
lvs_table_name_map[2] = 'LVL'
lvs_table_name_map[3] = 'CHILD_ITEM'
lvs_table_name_map[4] = 'ITEM_TYPE'
lvs_table_name_map[5] = 'ITEM_NAME'
lvs_table_name_map[6] = 'ITEM_SPEC'
lvs_table_name_map[7] = 'ITEM_UOM'
lvs_table_name_map[8] = 'QTY'

dw_2.reset()
For lvi_count = 1 to Gst_dw_colinfo.i_dw_colcount
   
	lvs_col_name	= dw_1.Describe('#'+String(lvi_count)+".Name")	
	
	dw_1.Modify(lvs_col_name + "_t.y=8")
	dw_1.Modify(lvs_col_name + "_t.height=140")
	dw_1.Modify(lvs_col_name + "_t.width=300")
	
	dw_1.Modify(lvs_col_name + ".y=4")
	dw_1.Modify(lvs_col_name + ".height=80")	
	dw_1.Modify(lvs_col_name + ".width=300")
	
	if cbx_auto_link.checked = true then 
		
	   if cbx_unit_bom.checked = true and upper(lvs_col_name) = 'F1' then
	   else
		   rows = dw_2.insertrow(0)
		   dw_2.object.excel_column_name[rows] = upper(lvs_col_name)
		   if cbx_unit_bom.checked = true then 
			   dw_2.object.table_column_name[rows] = lvs_table_name_map[lvi_count]
		   end if 
	   end if 
	end if 
	
	f_msg_mdi_help(String(lvi_count)+" Rows Processed!")
Next 


end event

type sle_excel_column_name from so_singlelineedit within w_excel_loader_master
integer x = 46
integer y = 444
integer taborder = 70
boolean bringtotop = true
end type

type st_3 from so_statictext within w_excel_loader_master
integer x = 46
integer y = 364
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Excel Column Name"
end type

type cb_4 from so_commandbutton within w_excel_loader_master
integer x = 2167
integer y = 448
integer width = 389
integer height = 92
integer taborder = 80
boolean bringtotop = true
string text = "Replace"
end type

event clicked;call super::clicked;if dw_1.getrow() < 1 then 
	return
end if

OPEN(W_REPLACE_POPUP)
end event

type ddlb_table_name from uo_table_name within w_excel_loader_master
integer x = 448
integer y = 188
integer width = 978
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
end type

type sle_table_column_name from so_singlelineedit within w_excel_loader_master
integer x = 1047
integer y = 444
integer width = 553
integer taborder = 80
boolean bringtotop = true
end type

type st_1 from so_statictext within w_excel_loader_master
integer x = 1047
integer y = 364
integer width = 553
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Table Column Name"
end type

type cbx_auto_link from so_checkbox within w_excel_loader_master
integer x = 2185
integer y = 352
integer width = 562
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Column Auto Link"
boolean checked = true
end type

type cb_5 from so_commandbutton within w_excel_loader_master
integer x = 2560
integer y = 448
integer width = 389
integer height = 92
integer taborder = 20
boolean bringtotop = true
string text = "Show Value"
end type

event clicked;call super::clicked;Openwithparm(w_value_list_popup , sle_table_column_name.text)
end event

type cb_6 from so_commandbutton within w_excel_loader_master
integer x = 2958
integer y = 448
integer width = 389
integer height = 92
integer taborder = 90
boolean bringtotop = true
string text = "Load Data"
end type

event clicked;call super::clicked;int i , j , rows
string lvs_excel_column_name , lvs_table_column_name , lvs_column_type
string lvs_value

string lvs_max_item_code[] , lvs_product_parent_item


dw_3.reset() 

do
	i++
	
	rows = dw_3.insertrow( 0)	
	
	j = 0  ;
	do
		j++
		
				lvs_excel_column_name = dw_2.object.excel_column_name[j]
				lvs_table_column_name = dw_2.object.table_column_name[j]	
		
				lvs_column_type = mid(dw_1.Describe(lvs_excel_column_name+ ".ColType"),1,3)
						
				if lvs_column_type = 'num' or lvs_column_type = 'int'  then
						dw_3.setitem( rows , lvs_table_column_name , dw_1.getitemnumber(i , lvs_excel_column_name ) )
				elseif lvs_column_type = 'dec' then
						dw_3.setitem( rows , lvs_table_column_name , dw_1.getitemDecimal( i , lvs_excel_column_name ) )
				elseif lvs_column_type = 'cha' then
					       lvs_value = dw_1.getitemstring( i , lvs_excel_column_name )
						dw_3.setitem( rows , lvs_table_column_name ,  lvs_value )
				elseif lvs_column_type = 'dat' then
						dw_3.setitem( rows , lvs_table_column_name , dw_1.getitemdatetime( i , lvs_excel_column_name ) )
				else
					messagebox("error" , "Col Type Unknown" )
					return
				end if		
//======================================================================		
int LVL_LEVEL		
				if cbx_unit_bom.checked = true then 
					
					if upper(lvs_table_column_name) = 'LVL' then
						
						LVL_LEVEL = dw_1.getitemnumber(i , lvs_excel_column_name )
						if  LVL_LEVEL = 0 then
							dw_3.setitem( rows , 'parent_item' , dw_1.getitemstring( i , '$$HEX3$$90c754cfdcb4$$ENDHEX$$' ) )
							lvs_max_item_code[1]  = dw_1.getitemstring( i , '$$HEX3$$90c754cfdcb4$$ENDHEX$$' )
							
						else
							 dw_3.setitem( rows , 'parent_item' ,  lvs_max_item_code[LVL_LEVEL] )
							 lvs_max_item_code[LVL_LEVEL + 1]  = dw_1.getitemstring( i , '$$HEX3$$90c754cfdcb4$$ENDHEX$$' )							
						end if 
					end if
				end if 
		
//======================================================================				
	loop until j = dw_2.rowcount( )

	dw_3.object.set_item[rows] = lvs_max_item_code[1]  
	
loop until i = dw_1.rowcount( )

dw_3.accepttext( )

int k , m , lvl_check_level , lvl_count

do
	
	k++
	
	if k +1 > dw_3.rowcount( ) then 
	else
	
		if dw_3.object.lvl[k] < dw_3.object.lvl[k+1] then
			dw_3.object.assy_yn[k] = 'Y' 
			lvl_check_level = dw_3.object.lvl[k+1]
			//====================================
			//
			//====================================
			m = 0 ; lvl_count = 0
			do
				m++
				
				if  k+m > dw_3.rowcount( ) then 
					exit
				else
				
					if lvl_check_level = dw_3.object.lvl[k+m] then 
						lvl_count ++
					elseif lvl_check_level > dw_3.object.lvl[k+m] then
						exit
					end if 
					
				end if 
				
			loop until  1 = 2
			//====================================
			//
			//====================================			
			dw_3.object.assy_count[k] = lvl_count
		end if 
		
	end if 
	
loop until  k = dw_3.rowcount( )


msg = Messagebox("Notify" , "Save" , question! , yesno!)
if msg = 1 then 
	if dw_3.update() < 0 then 
		rollback;
	else
		commit ;
		dw_3.reset()
	end if 
end if 
		


end event

type cb_7 from so_commandbutton within w_excel_loader_master
integer x = 3355
integer y = 448
integer width = 389
integer height = 92
integer taborder = 100
boolean bringtotop = true
string text = "SQL Painter"
end type

event clicked;call super::clicked;open(w_sql_painter)
end event

type sle_1 from so_singlelineedit within w_excel_loader_master
integer x = 544
integer y = 444
integer width = 503
integer taborder = 90
boolean bringtotop = true
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_1.SETFILTER('')
dw_1.FILTER()

LVS_COLUMN =sle_excel_column_name.text
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_1.SETFILTER('')
    dw_1.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

dw_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found" )
end event

type sle_2 from so_singlelineedit within w_excel_loader_master
integer x = 1605
integer y = 444
integer taborder = 100
boolean bringtotop = true
end type

event modified;call super::modified;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_3.SETFILTER('')
dw_3.FILTER()

LVS_COLUMN =sle_table_column_name.text
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_3.SETFILTER('')
    dw_3.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

dw_3.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
dw_3.FILTER()
F_MSG_MDI_HELP( STRING( dw_3.ROWCOUNT() ) + " Found" )
end event

type cb_8 from so_commandbutton within w_excel_loader_master
integer x = 1440
integer y = 188
integer width = 434
integer height = 84
integer taborder = 80
boolean bringtotop = true
string text = "Table Open"
end type

event clicked;call super::clicked;if Gvi_user_level = 9 then 
	
else
	Messagebox("Notify" , "You have not Privilege! Requiered User Level 9")	
	return 
end if

string ERRORS, sql_syntax , lvs_table_name
string presentation_str, dwsyntax_str

//==========================
//
//==========================
lvs_table_name = ddlb_table_name.text


sql_syntax =  'select * from '+lvs_table_name+ ' where 1 = 2'

presentation_str = "style(type=grid)"
dwsyntax_str = sqlca.SyntaxFromSQL(sql_syntax, presentation_str, ERRORS)

IF Len(ERRORS) > 0 THEN
   MessageBox("Caution" , "SyntaxFromSQL caused these errors: " + ERRORS)
   RETURN
END IF

dw_3.CREATE( DWSYNTAX_STR, ERRORS)
dw_3.BRINGTOTOP = TRUE 
dw_3.OBJECT.DATAWINDOW.TABLE.UPDATEKEYINPLACE='YES'
dw_3.OBJECT.DATAWINDOW.TABLE.UPDATEWHERE=2

//================================================
//
//================================================
IF Len(ERRORS) > 0 THEN
   MessageBox("Caution", "Create cause these errors: " + ERRORS)
   RETURN
END IF

dw_3.settransobject( sqlca)
dw_3.retrieve( )
//=================================================
//
//=================================================
Int lvi_count
string lvs_col_name
Gst_dw_colinfo.i_dw_colcount = 0
Gst_dw_colinfo.i_dw_colcount=Integer(  dw_3.Describe("DataWindow.Column.Count"))
//======================================================================
// Column Object $$HEX2$$7cb92000$$ENDHEX$$Scan $$HEX2$$5cd5e4b2$$ENDHEX$$
//======================================================================
For lvi_count = 1 to Gst_dw_colinfo.i_dw_colcount

	lvs_col_name	= dw_3.Describe('#'+String(lvi_count)+".Name")	
	
	dw_3.Modify(lvs_col_name + "_t.y=8")
	dw_3.Modify(lvs_col_name + "_t.height=140")
	dw_3.Modify(lvs_col_name + "_t.width=300")
	
	dw_3.Modify(lvs_col_name + ".y=4")
	dw_3.Modify(lvs_col_name + ".height=80")	
	dw_3.Modify(lvs_col_name + ".width=300")
	f_msg_mdi_help(String(lvi_count)+" Rows Processed!")
Next 
//====================================================
//
//====================================================
STRING MODIFY_STRING , LVS_RETURN
MODIFY_STRING = 'CREATE  COMPUTE(NAME=NO_1 VISIBLE="1" BAND=DETAIL FONT.CHARSET="0" FONT.FACE="TAHOMA" FONT.FAMILY="2" FONT.HEIGHT="-8" FONT.PITCH="2" FONT.WEIGHT="700" BACKGROUND.MODE="2" BACKGROUND.COLOR="255" COLOR="0" X="0" Y="4" HEIGHT="64" WIDTH="150" FORMAT="[GENERAL]" EXPRESSION="GETROW()" ALIGNMENT="0" BORDER="0" CROSSTAB.REPEAT=NO )'
LVS_RETURN = dw_3.Modify(MODIFY_STRING)	

dw_3.insertrow(0)
end event

type rb_id_item from so_radiobutton within w_excel_loader_master
integer x = 1943
integer y = 80
boolean bringtotop = true
integer weight = 700
string text = "Item Master"
end type

event clicked;call super::clicked;string ERRORS, sql_syntax , lvs_table_name
string presentation_str, dwsyntax_str

//==========================
//
//==========================
lvs_table_name = 'ID_ITEM'


sql_syntax =  'select * from '+lvs_table_name+ ' where 1 = 2'

presentation_str = "style(type=grid)"
dwsyntax_str = sqlca.SyntaxFromSQL(sql_syntax, presentation_str, ERRORS)

IF Len(ERRORS) > 0 THEN
   MessageBox("Caution" , "SyntaxFromSQL caused these errors: " + ERRORS)
   RETURN
END IF

dw_3.CREATE( DWSYNTAX_STR, ERRORS)
dw_3.BRINGTOTOP = TRUE 
dw_3.OBJECT.DATAWINDOW.TABLE.UPDATEKEYINPLACE='YES'
dw_3.OBJECT.DATAWINDOW.TABLE.UPDATEWHERE=2

//================================================
//
//================================================
IF Len(ERRORS) > 0 THEN
   MessageBox("Caution", "Create cause these errors: " + ERRORS)
   RETURN
END IF

dw_3.settransobject( sqlca)
dw_3.retrieve( )
//=================================================
//
//=================================================
Int lvi_count
string lvs_col_name
Gst_dw_colinfo.i_dw_colcount = 0
Gst_dw_colinfo.i_dw_colcount=Integer(  dw_3.Describe("DataWindow.Column.Count"))
//======================================================================
// Column Object $$HEX2$$7cb92000$$ENDHEX$$Scan $$HEX2$$5cd5e4b2$$ENDHEX$$
//======================================================================
For lvi_count = 1 to Gst_dw_colinfo.i_dw_colcount

	lvs_col_name	= dw_3.Describe('#'+String(lvi_count)+".Name")	
	
	dw_3.Modify(lvs_col_name + "_t.y=8")
	dw_3.Modify(lvs_col_name + "_t.height=140")
	dw_3.Modify(lvs_col_name + "_t.width=300")
	
	dw_3.Modify(lvs_col_name + ".y=4")
	dw_3.Modify(lvs_col_name + ".height=80")	
	dw_3.Modify(lvs_col_name + ".width=300")
	f_msg_mdi_help(String(lvi_count)+" Rows Processed!")
Next 
//====================================================
//
//====================================================
STRING MODIFY_STRING , LVS_RETURN
MODIFY_STRING = 'CREATE  COMPUTE(NAME=NO_1 VISIBLE="1" BAND=DETAIL FONT.CHARSET="0" FONT.FACE="TAHOMA" FONT.FAMILY="2" FONT.HEIGHT="-8" FONT.PITCH="2" FONT.WEIGHT="700" BACKGROUND.MODE="2" BACKGROUND.COLOR="255" COLOR="0" X="0" Y="4" HEIGHT="64" WIDTH="150" FORMAT="[GENERAL]" EXPRESSION="GETROW()" ALIGNMENT="0" BORDER="0" CROSSTAB.REPEAT=NO )'
LVS_RETURN = dw_3.Modify(MODIFY_STRING)	

dw_3.insertrow(0)
end event

type rb_bom from so_radiobutton within w_excel_loader_master
integer x = 1943
integer y = 176
boolean bringtotop = true
integer weight = 700
string text = "BOM Master"
end type

event clicked;call super::clicked;string ERRORS, sql_syntax , lvs_table_name
string presentation_str, dwsyntax_str

//==========================
//
//==========================
lvs_table_name = 'ID_ENG_BOM'


sql_syntax =  'select * from '+lvs_table_name+ ' where 1 = 2'

presentation_str = "style(type=grid)"
dwsyntax_str = sqlca.SyntaxFromSQL(sql_syntax, presentation_str, ERRORS)

IF Len(ERRORS) > 0 THEN
   MessageBox("Caution" , "SyntaxFromSQL caused these errors: " + ERRORS)
   RETURN
END IF

dw_3.CREATE( DWSYNTAX_STR, ERRORS)
dw_3.BRINGTOTOP = TRUE 
dw_3.OBJECT.DATAWINDOW.TABLE.UPDATEKEYINPLACE='YES'
dw_3.OBJECT.DATAWINDOW.TABLE.UPDATEWHERE=2

//================================================
//
//================================================
IF Len(ERRORS) > 0 THEN
   MessageBox("Caution", "Create cause these errors: " + ERRORS)
   RETURN
END IF

dw_3.settransobject( sqlca)
dw_3.retrieve( )
//=================================================
//
//=================================================
Int lvi_count
string lvs_col_name
Gst_dw_colinfo.i_dw_colcount = 0
Gst_dw_colinfo.i_dw_colcount=Integer(  dw_3.Describe("DataWindow.Column.Count"))
//======================================================================
// Column Object $$HEX2$$7cb92000$$ENDHEX$$Scan $$HEX2$$5cd5e4b2$$ENDHEX$$
//======================================================================
For lvi_count = 1 to Gst_dw_colinfo.i_dw_colcount

	lvs_col_name	= dw_3.Describe('#'+String(lvi_count)+".Name")	
	
	dw_3.Modify(lvs_col_name + "_t.y=8")
	dw_3.Modify(lvs_col_name + "_t.height=140")
	dw_3.Modify(lvs_col_name + "_t.width=300")
	
	dw_3.Modify(lvs_col_name + ".y=4")
	dw_3.Modify(lvs_col_name + ".height=80")	
	dw_3.Modify(lvs_col_name + ".width=300")
	f_msg_mdi_help(String(lvi_count)+" Rows Processed!")
Next 
//====================================================
//
//====================================================
STRING MODIFY_STRING , LVS_RETURN
MODIFY_STRING = 'CREATE  COMPUTE(NAME=NO_1 VISIBLE="1" BAND=DETAIL FONT.CHARSET="0" FONT.FACE="TAHOMA" FONT.FAMILY="2" FONT.HEIGHT="-8" FONT.PITCH="2" FONT.WEIGHT="700" BACKGROUND.MODE="2" BACKGROUND.COLOR="255" COLOR="0" X="0" Y="4" HEIGHT="64" WIDTH="150" FORMAT="[GENERAL]" EXPRESSION="GETROW()" ALIGNMENT="0" BORDER="0" CROSSTAB.REPEAT=NO )'
LVS_RETURN = dw_3.Modify(MODIFY_STRING)	

dw_3.insertrow(0)
end event

type rb_buy_price from so_radiobutton within w_excel_loader_master
integer x = 2437
integer y = 76
integer width = 526
boolean bringtotop = true
integer weight = 700
string text = "Buy Price Master"
end type

event clicked;call super::clicked;string ERRORS, sql_syntax , lvs_table_name
string presentation_str, dwsyntax_str

//==========================
//
//==========================
lvs_table_name = 'IM_ITEM_UNIT_PRICE'


sql_syntax =  'select * from '+lvs_table_name+ ' where 1 = 2'

presentation_str = "style(type=grid)"
dwsyntax_str = sqlca.SyntaxFromSQL(sql_syntax, presentation_str, ERRORS)

IF Len(ERRORS) > 0 THEN
   MessageBox("Caution" , "SyntaxFromSQL caused these errors: " + ERRORS)
   RETURN
END IF

dw_3.CREATE( DWSYNTAX_STR, ERRORS)
dw_3.BRINGTOTOP = TRUE 
dw_3.OBJECT.DATAWINDOW.TABLE.UPDATEKEYINPLACE='YES'
dw_3.OBJECT.DATAWINDOW.TABLE.UPDATEWHERE=2

//================================================
//
//================================================
IF Len(ERRORS) > 0 THEN
   MessageBox("Caution", "Create cause these errors: " + ERRORS)
   RETURN
END IF

dw_3.settransobject( sqlca)
dw_3.retrieve( )
//=================================================
//
//=================================================
Int lvi_count
string lvs_col_name
Gst_dw_colinfo.i_dw_colcount = 0
Gst_dw_colinfo.i_dw_colcount=Integer(  dw_3.Describe("DataWindow.Column.Count"))
//======================================================================
// Column Object $$HEX2$$7cb92000$$ENDHEX$$Scan $$HEX2$$5cd5e4b2$$ENDHEX$$
//======================================================================
For lvi_count = 1 to Gst_dw_colinfo.i_dw_colcount

	lvs_col_name	= dw_3.Describe('#'+String(lvi_count)+".Name")	
	
	dw_3.Modify(lvs_col_name + "_t.y=8")
	dw_3.Modify(lvs_col_name + "_t.height=140")
	dw_3.Modify(lvs_col_name + "_t.width=300")
	
	dw_3.Modify(lvs_col_name + ".y=4")
	dw_3.Modify(lvs_col_name + ".height=80")	
	dw_3.Modify(lvs_col_name + ".width=300")
	f_msg_mdi_help(String(lvi_count)+" Rows Processed!")
Next 
//====================================================
//
//====================================================
STRING MODIFY_STRING , LVS_RETURN
MODIFY_STRING = 'CREATE  COMPUTE(NAME=NO_1 VISIBLE="1" BAND=DETAIL FONT.CHARSET="0" FONT.FACE="TAHOMA" FONT.FAMILY="2" FONT.HEIGHT="-8" FONT.PITCH="2" FONT.WEIGHT="700" BACKGROUND.MODE="2" BACKGROUND.COLOR="255" COLOR="0" X="0" Y="4" HEIGHT="64" WIDTH="150" FORMAT="[GENERAL]" EXPRESSION="GETROW()" ALIGNMENT="0" BORDER="0" CROSSTAB.REPEAT=NO )'
LVS_RETURN = dw_3.Modify(MODIFY_STRING)	

dw_3.insertrow(0)
end event

type rb_sale_price from so_radiobutton within w_excel_loader_master
integer x = 2437
integer y = 172
integer width = 530
boolean bringtotop = true
integer weight = 700
string text = "Sale Price Master"
end type

event clicked;call super::clicked;string ERRORS, sql_syntax , lvs_table_name
string presentation_str, dwsyntax_str

//==========================
//
//==========================
lvs_table_name = 'IS_PRODUCT_SALE_PRICE'


sql_syntax =  'select * from '+lvs_table_name+ ' where 1 = 2'

presentation_str = "style(type=grid)"
dwsyntax_str = sqlca.SyntaxFromSQL(sql_syntax, presentation_str, ERRORS)

IF Len(ERRORS) > 0 THEN
   MessageBox("Caution" , "SyntaxFromSQL caused these errors: " + ERRORS)
   RETURN
END IF

dw_3.CREATE( DWSYNTAX_STR, ERRORS)
dw_3.BRINGTOTOP = TRUE 
dw_3.OBJECT.DATAWINDOW.TABLE.UPDATEKEYINPLACE='YES'
dw_3.OBJECT.DATAWINDOW.TABLE.UPDATEWHERE=2

//================================================
//
//================================================
IF Len(ERRORS) > 0 THEN
   MessageBox("Caution", "Create cause these errors: " + ERRORS)
   RETURN
END IF

dw_3.settransobject( sqlca)
dw_3.retrieve( )
//=================================================
//
//=================================================
Int lvi_count
string lvs_col_name
Gst_dw_colinfo.i_dw_colcount = 0
Gst_dw_colinfo.i_dw_colcount=Integer(  dw_3.Describe("DataWindow.Column.Count"))
//======================================================================
// Column Object $$HEX2$$7cb92000$$ENDHEX$$Scan $$HEX2$$5cd5e4b2$$ENDHEX$$
//======================================================================
For lvi_count = 1 to Gst_dw_colinfo.i_dw_colcount

	lvs_col_name	= dw_3.Describe('#'+String(lvi_count)+".Name")	
	
	dw_3.Modify(lvs_col_name + "_t.y=8")
	dw_3.Modify(lvs_col_name + "_t.height=140")
	dw_3.Modify(lvs_col_name + "_t.width=300")
	
	dw_3.Modify(lvs_col_name + ".y=4")
	dw_3.Modify(lvs_col_name + ".height=80")	
	dw_3.Modify(lvs_col_name + ".width=300")
	f_msg_mdi_help(String(lvi_count)+" Rows Processed!")
Next 
//====================================================
//
//====================================================
STRING MODIFY_STRING , LVS_RETURN
MODIFY_STRING = 'CREATE  COMPUTE(NAME=NO_1 VISIBLE="1" BAND=DETAIL FONT.CHARSET="0" FONT.FACE="TAHOMA" FONT.FAMILY="2" FONT.HEIGHT="-8" FONT.PITCH="2" FONT.WEIGHT="700" BACKGROUND.MODE="2" BACKGROUND.COLOR="255" COLOR="0" X="0" Y="4" HEIGHT="64" WIDTH="150" FORMAT="[GENERAL]" EXPRESSION="GETROW()" ALIGNMENT="0" BORDER="0" CROSSTAB.REPEAT=NO )'
LVS_RETURN = dw_3.Modify(MODIFY_STRING)	

dw_3.insertrow(0)
end event

type rb_shipping from so_radiobutton within w_excel_loader_master
integer x = 3054
integer y = 72
integer width = 485
boolean bringtotop = true
integer weight = 700
string text = "Excel Shipping"
end type

event clicked;call super::clicked;string ERRORS, sql_syntax , lvs_table_name
string presentation_str, dwsyntax_str

//==========================
//
//==========================
lvs_table_name = 'IS_PRODUCT_SHIPPING_SAP'


sql_syntax =  'select * from '+lvs_table_name+ ' where 1 = 2'

presentation_str = "style(type=grid)"
dwsyntax_str = sqlca.SyntaxFromSQL(sql_syntax, presentation_str, ERRORS)

IF Len(ERRORS) > 0 THEN
   MessageBox("Caution" , "SyntaxFromSQL caused these errors: " + ERRORS)
   RETURN
END IF

dw_3.CREATE( DWSYNTAX_STR, ERRORS)
dw_3.BRINGTOTOP = TRUE 
dw_3.OBJECT.DATAWINDOW.TABLE.UPDATEKEYINPLACE='YES'
dw_3.OBJECT.DATAWINDOW.TABLE.UPDATEWHERE=2

//================================================
//
//================================================
IF Len(ERRORS) > 0 THEN
   MessageBox("Caution", "Create cause these errors: " + ERRORS)
   RETURN
END IF

dw_3.settransobject( sqlca)
dw_3.retrieve( )
//=================================================
//
//=================================================
Int lvi_count
string lvs_col_name
Gst_dw_colinfo.i_dw_colcount = 0
Gst_dw_colinfo.i_dw_colcount=Integer(  dw_3.Describe("DataWindow.Column.Count"))
//======================================================================
// Column Object $$HEX2$$7cb92000$$ENDHEX$$Scan $$HEX2$$5cd5e4b2$$ENDHEX$$
//======================================================================
For lvi_count = 1 to Gst_dw_colinfo.i_dw_colcount

	lvs_col_name	= dw_3.Describe('#'+String(lvi_count)+".Name")	
	
	dw_3.Modify(lvs_col_name + "_t.y=8")
	dw_3.Modify(lvs_col_name + "_t.height=140")
	dw_3.Modify(lvs_col_name + "_t.width=300")
	
	dw_3.Modify(lvs_col_name + ".y=4")
	dw_3.Modify(lvs_col_name + ".height=80")	
	dw_3.Modify(lvs_col_name + ".width=300")
	f_msg_mdi_help(String(lvi_count)+" Rows Processed!")
Next 
//====================================================
//
//====================================================
STRING MODIFY_STRING , LVS_RETURN
MODIFY_STRING = 'CREATE  COMPUTE(NAME=NO_1 VISIBLE="1" BAND=DETAIL FONT.CHARSET="0" FONT.FACE="TAHOMA" FONT.FAMILY="2" FONT.HEIGHT="-8" FONT.PITCH="2" FONT.WEIGHT="700" BACKGROUND.MODE="2" BACKGROUND.COLOR="255" COLOR="0" X="0" Y="4" HEIGHT="64" WIDTH="150" FORMAT="[GENERAL]" EXPRESSION="GETROW()" ALIGNMENT="0" BORDER="0" CROSSTAB.REPEAT=NO )'
LVS_RETURN = dw_3.Modify(MODIFY_STRING)	

dw_3.insertrow(0)
end event

type em_sap_yyyymm from uo_ym within w_excel_loader_master
integer x = 3817
integer y = 348
integer taborder = 20
boolean bringtotop = true
end type

type cb_delete_all from so_commandbutton within w_excel_loader_master
integer x = 3803
integer y = 452
integer width = 357
integer height = 92
integer taborder = 110
boolean bringtotop = true
string text = "Delete All"
end type

event clicked;call super::clicked;msg = f_msgbox1(1161 , this.text )
if msg = 1 then 
else
	return
end if

string lvs_close_yyyymm

lvs_close_yyyymm = em_sap_yyyymm.text


if rb_shipping.checked = true then 

		delete from is_product_shipping_sap
		where close_yyyymm = :lvs_close_yyyymm
		and organization_id = :gvi_organization_id ;
		
		if f_sql_check() < 0 then 
			return
		end if
		
elseif rb_item_receipt.checked = true then 
		
		delete from im_item_receipt_excel
		where close_yyyymm = :lvs_close_yyyymm
		and organization_id = :gvi_organization_id ;
		
		if f_sql_check() < 0 then 
			return
		end if		
		
else
		
		delete from is_product_receipt_excel
		where close_yyyymm = :lvs_close_yyyymm
		and organization_id = :gvi_organization_id ;
		
		if f_sql_check() < 0 then 
			return
		end if		
		
end if 

commit ;
		
		f_msgbox(1170)
end event

type rb_2 from so_radiobutton within w_excel_loader_master
integer x = 3054
integer y = 172
integer width = 640
boolean bringtotop = true
integer weight = 700
string text = "Excel Product Receipt"
end type

event clicked;call super::clicked;string ERRORS, sql_syntax , lvs_table_name
string presentation_str, dwsyntax_str

//==========================
//
//==========================
lvs_table_name = 'IS_PRODUCT_RECEIPT_EXCEL'


sql_syntax =  'select * from '+lvs_table_name+ ' where 1 = 2'

presentation_str = "style(type=grid)"
dwsyntax_str = sqlca.SyntaxFromSQL(sql_syntax, presentation_str, ERRORS)

IF Len(ERRORS) > 0 THEN
   MessageBox("Caution" , "SyntaxFromSQL caused these errors: " + ERRORS)
   RETURN
END IF

dw_3.CREATE( DWSYNTAX_STR, ERRORS)
dw_3.BRINGTOTOP = TRUE 
dw_3.OBJECT.DATAWINDOW.TABLE.UPDATEKEYINPLACE='YES'
dw_3.OBJECT.DATAWINDOW.TABLE.UPDATEWHERE=2

//================================================
//
//================================================
IF Len(ERRORS) > 0 THEN
   MessageBox("Caution", "Create cause these errors: " + ERRORS)
   RETURN
END IF

dw_3.settransobject( sqlca)
dw_3.retrieve( )
//=================================================
//
//=================================================
Int lvi_count
string lvs_col_name
Gst_dw_colinfo.i_dw_colcount = 0
Gst_dw_colinfo.i_dw_colcount=Integer(  dw_3.Describe("DataWindow.Column.Count"))
//======================================================================
// Column Object $$HEX2$$7cb92000$$ENDHEX$$Scan $$HEX2$$5cd5e4b2$$ENDHEX$$
//======================================================================
For lvi_count = 1 to Gst_dw_colinfo.i_dw_colcount

	lvs_col_name	= dw_3.Describe('#'+String(lvi_count)+".Name")	
	
	dw_3.Modify(lvs_col_name + "_t.y=8")
	dw_3.Modify(lvs_col_name + "_t.height=140")
	dw_3.Modify(lvs_col_name + "_t.width=300")
	
	dw_3.Modify(lvs_col_name + ".y=4")
	dw_3.Modify(lvs_col_name + ".height=80")	
	dw_3.Modify(lvs_col_name + ".width=300")
	f_msg_mdi_help(String(lvi_count)+" Rows Processed!")
Next 
//====================================================
//
//====================================================
STRING MODIFY_STRING , LVS_RETURN
MODIFY_STRING = 'CREATE  COMPUTE(NAME=NO_1 VISIBLE="1" BAND=DETAIL FONT.CHARSET="0" FONT.FACE="TAHOMA" FONT.FAMILY="2" FONT.HEIGHT="-8" FONT.PITCH="2" FONT.WEIGHT="700" BACKGROUND.MODE="2" BACKGROUND.COLOR="255" COLOR="0" X="0" Y="4" HEIGHT="64" WIDTH="150" FORMAT="[GENERAL]" EXPRESSION="GETROW()" ALIGNMENT="0" BORDER="0" CROSSTAB.REPEAT=NO )'
LVS_RETURN = dw_3.Modify(MODIFY_STRING)	

dw_3.insertrow(0)
end event

type rb_item_receipt from so_radiobutton within w_excel_loader_master
integer x = 3602
integer y = 76
integer width = 567
boolean bringtotop = true
integer weight = 700
string text = "Excel Item Receipt"
end type

event clicked;call super::clicked;string ERRORS, sql_syntax , lvs_table_name
string presentation_str, dwsyntax_str

//==========================
//
//==========================
lvs_table_name = 'IM_ITEM_RECEIPT_EXCEL'


sql_syntax =  'select * from '+lvs_table_name+ ' where 1 = 2'

presentation_str = "style(type=grid)"
dwsyntax_str = sqlca.SyntaxFromSQL(sql_syntax, presentation_str, ERRORS)

IF Len(ERRORS) > 0 THEN
   MessageBox("Caution" , "SyntaxFromSQL caused these errors: " + ERRORS)
   RETURN
END IF

dw_3.CREATE( DWSYNTAX_STR, ERRORS)
dw_3.BRINGTOTOP = TRUE 
dw_3.OBJECT.DATAWINDOW.TABLE.UPDATEKEYINPLACE='YES'
dw_3.OBJECT.DATAWINDOW.TABLE.UPDATEWHERE=2

//================================================
//
//================================================
IF Len(ERRORS) > 0 THEN
   MessageBox("Caution", "Create cause these errors: " + ERRORS)
   RETURN
END IF

dw_3.settransobject( sqlca)
dw_3.retrieve( )
//=================================================
//
//=================================================
Int lvi_count
string lvs_col_name
Gst_dw_colinfo.i_dw_colcount = 0
Gst_dw_colinfo.i_dw_colcount=Integer(  dw_3.Describe("DataWindow.Column.Count"))
//======================================================================
// Column Object $$HEX2$$7cb92000$$ENDHEX$$Scan $$HEX2$$5cd5e4b2$$ENDHEX$$
//======================================================================
For lvi_count = 1 to Gst_dw_colinfo.i_dw_colcount

	lvs_col_name	= dw_3.Describe('#'+String(lvi_count)+".Name")	
	
	dw_3.Modify(lvs_col_name + "_t.y=8")
	dw_3.Modify(lvs_col_name + "_t.height=140")
	dw_3.Modify(lvs_col_name + "_t.width=300")
	
	dw_3.Modify(lvs_col_name + ".y=4")
	dw_3.Modify(lvs_col_name + ".height=80")	
	dw_3.Modify(lvs_col_name + ".width=300")
	f_msg_mdi_help(String(lvi_count)+" Rows Processed!")
Next 
//====================================================
//
//====================================================
STRING MODIFY_STRING , LVS_RETURN
MODIFY_STRING = 'CREATE  COMPUTE(NAME=NO_1 VISIBLE="1" BAND=DETAIL FONT.CHARSET="0" FONT.FACE="TAHOMA" FONT.FAMILY="2" FONT.HEIGHT="-8" FONT.PITCH="2" FONT.WEIGHT="700" BACKGROUND.MODE="2" BACKGROUND.COLOR="255" COLOR="0" X="0" Y="4" HEIGHT="64" WIDTH="150" FORMAT="[GENERAL]" EXPRESSION="GETROW()" ALIGNMENT="0" BORDER="0" CROSSTAB.REPEAT=NO )'
LVS_RETURN = dw_3.Modify(MODIFY_STRING)	

dw_3.insertrow(0)
end event

type cbx_unit_bom from so_checkbox within w_excel_loader_master
integer x = 2990
integer y = 344
integer width = 562
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Unit BOM"
boolean checked = true
end type

type gb_2 from so_groupbox within w_excel_loader_master
integer y = 296
integer width = 2121
integer height = 264
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Filter"
end type

type gb_1 from so_groupbox within w_excel_loader_master
integer width = 1893
integer height = 292
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Connect"
end type

type gb_3 from so_groupbox within w_excel_loader_master
integer x = 1911
integer width = 1106
integer height = 288
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Select Table"
end type

type gb_4 from so_groupbox within w_excel_loader_master
integer x = 3776
integer y = 296
integer width = 411
integer height = 264
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = " YYYYMM"
end type

type gb_5 from so_groupbox within w_excel_loader_master
integer x = 2121
integer y = 296
integer width = 1650
integer height = 264
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_6 from so_groupbox within w_excel_loader_master
integer x = 3026
integer width = 1161
integer height = 288
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Select Table"
end type

