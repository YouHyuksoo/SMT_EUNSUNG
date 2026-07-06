HA$PBExportHeader$w_report_generator.srw
$PBExportComments$$$HEX9$$70c874ac08c8ddc031c1a9c608c7c4b3b0c6$$ENDHEX$$
forward
global type w_report_generator from w_main_root
end type
type cb_1 from so_commandbutton within w_report_generator
end type
type cb_file_open from so_commandbutton within w_report_generator
end type
type cb_2 from so_commandbutton within w_report_generator
end type
type sle_datawindow_name from so_singlelineedit within w_report_generator
end type
type st_1 from so_statictext within w_report_generator
end type
type cb_3 from so_commandbutton within w_report_generator
end type
type cb_4 from so_commandbutton within w_report_generator
end type
type cb_5 from so_commandbutton within w_report_generator
end type
type gb_1 from so_groupbox within w_report_generator
end type
type gb_2 from so_groupbox within w_report_generator
end type
end forward

global type w_report_generator from w_main_root
integer width = 4763
integer height = 3024
string title = "Where Condition Generator"
string icon = "Form!"
string ivs_dw_2_selected_row_yn = "Y"
string ivs_dw_3_selected_row_yn = "Y"
cb_1 cb_1
cb_file_open cb_file_open
cb_2 cb_2
sle_datawindow_name sle_datawindow_name
st_1 st_1
cb_3 cb_3
cb_4 cb_4
cb_5 cb_5
gb_1 gb_1
gb_2 gb_2
end type
global w_report_generator w_report_generator

type variables
int ivi_preview
string is_path
end variables

forward prototypes
public function integer wf_set_column_dddw (string arg_window_name, string arg_datawindow_name, string arg_column_name, readonly integer arg_org)
public function long wf_get_column_display_size (string arg_window_name, string arg_datawindow_name, string arg_column_name)
end prototypes

public function integer wf_set_column_dddw (string arg_window_name, string arg_datawindow_name, string arg_column_name, readonly integer arg_org);DATAWINDOWCHILD IDW_CHILD            
INT LVI_COUNT
STRING LVS_MODIFY_STRING , LVS_DDDW_NAME , LVS_DSIPAME , LVS_DATANAME , LVS_DDDW_VALUE


SELECT COLUMN_DDDW_NAME , COLUMN_DDDW_DISPNAME , COLUMN_DDDW_DATANAME , COLUMN_DDDW_VALUE
   INTO :LVS_DDDW_NAME , :LVS_DSIPAME , :LVS_DATANAME , :LVS_DDDW_VALUE
   FROM ISYS_REPORT_WINDOW_PROPERTY
 WHERE WINDOW_NAME          = :ARG_WINDOW_NAME
     AND DATAWINDOW_NAME  = :ARG_DATAWINDOW_NAME
     AND COLUMN_NAME            = UPPER(:ARG_COLUMN_NAME)	
     AND ORGANIZATION_ID      = :ARG_ORG ;
	  
	IF F_SQL_CHECK() < 0  THEN 
		RETURN -1
	END IF
 
 IF LVS_DDDW_NAME = '' OR ISNULL(LVS_DDDW_NAME) OR LVS_DDDW_NAME = '?' THEN 
	RETURN 0 	
 ELSE
	
	DW_3.MODIFY(ARG_COLUMN_NAME+'.DDDW.ALLOWEDIT=NO')
	DW_3.MODIFY(ARG_COLUMN_NAME+'.DDDW.AUTOHSCROLL=NO')	
	DW_3.MODIFY(ARG_COLUMN_NAME+'.DDDW.AUTORETRIEVE=NO')		
	DW_3.MODIFY(ARG_COLUMN_NAME+'.DDDW.USEASBORDER=NO')			
	DW_3.MODIFY(ARG_COLUMN_NAME+'.DDDW.DATACOLUMN='+LVS_DATANAME)				
	DW_3.MODIFY(ARG_COLUMN_NAME+'.DDDW.DISPLAYCOLUMN='+LVS_DSIPAME)					
	DW_3.MODIFY(ARG_COLUMN_NAME+'.DDDW.HSCROLLBAR=NO')						
	DW_3.MODIFY(ARG_COLUMN_NAME+'.DDDW.HSPLITSCROLL=NO')							
	DW_3.MODIFY(ARG_COLUMN_NAME+'.DDDW.IMEMODE=0')								
	DW_3.MODIFY(ARG_COLUMN_NAME+'.DDDW.LIMIT=8')									
	DW_3.MODIFY(ARG_COLUMN_NAME+'.DDDW.NAME='+LVS_DDDW_NAME)									     
	DW_3.MODIFY(ARG_COLUMN_NAME+'.DDDW.NILISNULL=NO')									     	
	DW_3.MODIFY(ARG_COLUMN_NAME+'.DDDW.PERCENTWIDTH=300')
	DW_3.MODIFY(ARG_COLUMN_NAME+'.DDDW.REQUIRED=NO')	
	DW_3.MODIFY(ARG_COLUMN_NAME+'.DDDW.SHOWLIST=NO')		
     DW_3.MODIFY(ARG_COLUMN_NAME+'.DDDW.VSCROLLBAR=NO')
	  

	 DW_3.GETCHILD( ARG_COLUMN_NAME , IDW_CHILD)
	 IDW_CHILD.settransobject( SQLCA) 
	 IDW_CHILD.RETrieve( GVS_LANGUAGE , STRING(GVI_ORGANIZATION_ID) ,  LVS_DDDW_VALUE ) 
      IDW_CHILD.insertrow(1)		
		
	RETURN 1
	
END IF


end function

public function long wf_get_column_display_size (string arg_window_name, string arg_datawindow_name, string arg_column_name);STRING  LVS_COLUMN_TEXT_WIDTH

SELECT COLUMN_TEXT_WIDTH 
    INTO :LVS_COLUMN_TEXT_WIDTH
   FROM ISYS_REPORT_WINDOW_PROPERTY 
WHERE WINDOW_NAME = :ARG_WINDOW_NAME
     AND DATAWINDOW_NAME = :ARG_DATAWINDOW_NAME
	AND UPPER(COLUMN_NAME) =   :ARG_COLUMN_NAME
	AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;

IF F_SQL_CHECK() < 0 THEN 
	RETURN -1
END IF
RETURN  LONG(LVS_COLUMN_TEXT_WIDTH )
end function

on w_report_generator.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.cb_file_open=create cb_file_open
this.cb_2=create cb_2
this.sle_datawindow_name=create sle_datawindow_name
this.st_1=create st_1
this.cb_3=create cb_3
this.cb_4=create cb_4
this.cb_5=create cb_5
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_file_open
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.sle_datawindow_name
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.cb_3
this.Control[iCurrent+7]=this.cb_4
this.Control[iCurrent+8]=this.cb_5
this.Control[iCurrent+9]=this.gb_1
this.Control[iCurrent+10]=this.gb_2
end on

on w_report_generator.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.cb_file_open)
destroy(this.cb_2)
destroy(this.sle_datawindow_name)
destroy(this.st_1)
destroy(this.cb_3)
destroy(this.cb_4)
destroy(this.cb_5)
destroy(this.gb_1)
destroy(this.gb_2)
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
Ivs_resize_type    = 'MASTER_DETAIL_145_23M'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'Y' //Default
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

event ue_data_control;call super::ue_data_control;Long ROW
CHOOSE CASE Gvs_Ue_DATA_control
	CASE 'RETRIEVE'
		
			dw_2.reset()
			dw_2.retrieve( '%'+sle_datawindow_name.text+'%' , gvi_organization_id )
                  DW_2.SETFOCUS()
			
	CASE 'INSERT'
		      if dw_2.getrow() < 1 then return 
			  
			ROW = DW_3.INSERTROW(DW_3.GETROW())
			DW_3.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_3 , ROW , 'ALL')
			dw_3.object.datawindow_name[row] = dw_2.object.datawindow_name[dw_2.getrow()]
			dw_3.object.argument_sort_order[row] = dw_3.object.rownum[row]

			
	CASE 'APPEND'
		      if dw_2.getrow() < 1 then return 
			  
			ROW = DW_3.INSERTROW(DW_3.GETROW())
			DW_3.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_3 , ROW , 'ALL')
			dw_3.object.datawindow_name[row] = dw_2.object.datawindow_name[dw_2.getrow()]
			dw_3.object.argument_sort_order[row] = dw_3.object.rownum[row]
			
	CASE 'DELETE'
		
			if DW_3.AcceptText() = -1 then
				return
			end if
			
			// $$HEX7$$54badcc2c0c9200038d69ccd2000$$ENDHEX$$($$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?)
			MSG = F_MSGBOX(1003) 
			IF MSG = 1 THEN
				Gvl_row_deleted = DW_3.GetRow()			
				DW_3.DELETEROW(Gvl_row_deleted)		
				DW_3.SetFocus()
				ROW = DW_1.GetRow()
				DW_3.ScrollToRow(row)
				DW_3.SetColumn(1)
			END IF
						
	CASE 'UPDATE'
		
			if dw_2.update() < 0 or dw_3.update() < 0 then 
				rollback;
			else
				commit ;
				f_msgbox(170)
			end if 
			
	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;f_child_dw2(dw_2, 'column_name', gvs_language, '')


/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_report_generator
integer y = 604
end type

type dw_4 from w_main_root`dw_4 within w_report_generator
integer y = 308
integer width = 4713
integer height = 1080
boolean titlebar = true
string title = "Preview"
end type

event dw_4::doubleclicked;call super::doubleclicked;dw_1.bringtotop = true
end event

type dw_3 from w_main_root`dw_3 within w_report_generator
integer x = 2373
integer y = 1392
integer width = 2373
integer height = 1120
integer taborder = 60
boolean titlebar = true
string title = "Where Condition List"
string dataobject = "d_report_source_where_lst"
borderstyle borderstyle = styleraised!
end type

type dw_2 from w_main_root`dw_2 within w_report_generator
integer y = 1392
integer width = 2373
integer height = 1120
integer taborder = 40
boolean titlebar = true
string title = "DW Source List"
string dataobject = "d_datawindow_source_lst"
end type

event dw_2::clicked;call super::clicked;string LVS_DATAWINDOW_NAME
int     LVI_COUNT

if dw_2.getrow( ) < 1 then return

if dwo.name = 'b_show_sql' then 

	Datastore ds
	
	ds = create datastore
	
	ds.dataobject = string(dw_2.object.datawindow_name[dw_2.getrow()])
	
	openwithparm( w_edit_window , string(ds.GETSQLSelect()))

end if 

if dwo.name = 'b_add_menu' then
	
		LVS_DATAWINDOW_NAME = this.object.datawindow_name[row] 
		
		if dw_2.update() < 0 then 
			rollback;
			return
		end if 
		
		SELECT COUNT(*) INTO :LVI_COUNT 
		FROM ISYS_REPORT_MENU
		WHERE DATAWINDOW_NAME = :LVS_DATAWINDOW_NAME
		AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
		
		IF F_SQL_CHECK() < 0 THEN 
			RETURN
		END IF 
	  
	     IF LVI_COUNT < 1 THEN 

				  INSERT INTO "ISYS_REPORT_MENU"  
					 ( "REPORT_DIVISION",   
					   "REPORT_GROUP",   
					   "REPORT_TITLE",   
					   "ORGANIZATION_ID",   
					   "DATAWINDOW_NAME",   
					   "USER_ID",   
					   "COMMENTS",   
					   "ENTER_DATE",   
					   "ENTER_BY",   
					   "LAST_MODIFY_DATE",   
					   "LAST_MODIFY_BY" )  
					   
				SELECT 
					 'S' , //"REPORT_DIVISION",   S SYSTEM , C $$HEX7$$acc0a9c690c7200015c858c72000$$ENDHEX$$
					   "REPORT_GROUP",   
					   "REPORT_TITLE",   
					   "ORGANIZATION_ID",   
					   "DATAWINDOW_NAME",   
					   :GVS_USER_ID,   
					   "COMMENTS",   
					   "ENTER_DATE",   
					   "ENTER_BY",   
					   "LAST_MODIFY_DATE",   
					   "LAST_MODIFY_BY"
				FROM ISYS_REPORT_SOURCE		   
			 WHERE DATAWINDOW_NAME = :LVS_DATAWINDOW_NAME
				AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
				
				IF F_SQL_CHECK() < 0 THEN 
					RETURN
				END IF 
			ELSE
				UPDATE ISYS_REPORT_MENU A
				      SET ( A.REPORT_GROUP , A.REPORT_TITLE , A.COMMENTS ) 
					    = ( SELECT B.REPORT_GROUP , B.REPORT_TITLE , B.COMMENTS
						      FROM ISYS_REPORT_SOURCE B
						    WHERE A.DATAWINDOW_NAME = B.DATAWINDOW_NAME
							  AND A.ORGANIZATION_ID = B.ORGANIZATION_ID 
							  AND B.DATAWINDOW_NAME = :LVS_DATAWINDOW_NAME
				                    AND B.ORGANIZATION_ID = :GVI_ORGANIZATION_ID)
							  
				WHERE A.DATAWINDOW_NAME = :LVS_DATAWINDOW_NAME
				    AND A.ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
					
				IF F_SQL_CHECK() < 0 THEN 
					RETURN
				END IF 			
			END IF
			
			
			msg = f_msgbox(1170)
			if msg = 1 then 
				commit ;
			else
				rollback;
			end if 

end if 

if dwo.name = 'b_add_arg' then 
	
	string lvs_datawindow_syntax , lvs_arg_list
	
	LVS_DATAWINDOW_NAME = this.object.datawindow_name[row] 
	lvs_datawindow_syntax = f_get_data_window_source( LVS_DATAWINDOW_NAME )
	
	//===============================================
	// $$HEX13$$d0c698b7200088c758b3200044c5dcad3cbab8d270c88cd62000$$ENDHEX$$
	//===============================================
	int i , lvi_pos1 , lvi_Pos2 , rows
	string lvs_argment , lvs_type
	
	lvi_pos1 = pos(lvs_datawindow_syntax , "arguments=((" , 1 )
	lvi_pos2 = pos(lvs_datawindow_syntax , "))" , lvi_pos1 ) 
	
	if lvi_pos1 > 0 and lvi_pos2 > lvi_pos1 then
	
	       lvi_pos2 = lvi_pos2 + 2
		 lvi_pos2  = lvi_pos2  - lvi_pos1 
		 
		 lvs_arg_list = mid( lvs_datawindow_syntax ,  lvi_pos1 , lvi_Pos2 )   
		  
		  //$$HEX12$$44d594c6c6c594b2200012ac44c72000c6c564c5e4b22000$$ENDHEX$$
	       lvs_arg_list = f_replace_string( lvs_arg_list ,'arguments=((' , '' )
		 lvs_arg_list = f_replace_string( lvs_arg_list ,'(' , '' )
		 lvs_arg_list = f_replace_string( lvs_arg_list ,')' , '' )		 
		 lvs_arg_list = f_replace_string( lvs_arg_list , '"' , '' )		 
		 lvs_arg_list = trim(lvs_arg_list)
		 
		 
		do
		     i++
		     if lvs_arg_list = "" then 
				exit
			end if 
			//$$HEX22$$5cd51cac29c5200094cd9ccd20005cd5e4b2200064cfc8b97cb920006cad84bd90c75cb820005cd5e4b22000$$ENDHEX$$
			
		     lvs_argment = trim(f_get_token( lvs_arg_list , "," ))
		     lvs_type       = trim(f_get_token( lvs_arg_list , "," ))
			 
			// $$HEX5$$85c725b85cd5e4b22000$$ENDHEX$$
			rows = dw_3.insertrow(0)
			f_set_security_row( dw_3, rows , 'ALL' )
			dw_3.object.argument_name[rows] = upper(":"+lvs_argment)
			dw_3.object.data_type[rows] = upper(lvs_type)
			dw_3.object.argument_sort_order[rows] = dw_3.rowcount( )
			dw_3.object.datawindow_name[rows] = LVS_DATAWINDOW_NAME
			
			if  UPPER(lvs_type) = 'STRING' then
				dw_3.object.default_value[rows] = '%'
			end if 
			
		loop until 1 = 2
		
		dw_3.sort( )

	end if 	
		
end if 
end event

event dw_2::rowfocuschanged;call super::rowfocuschanged;if currentrow = 0 then return

dw_3.retrieve( this.object.datawindow_name[currentrow] , gvi_organization_id )
end event

event dw_2::doubleclicked;call super::doubleclicked;dw_4.bringtotop = true
end event

type dw_1 from w_main_root`dw_1 within w_report_generator
integer y = 308
integer width = 4713
integer height = 1080
integer taborder = 50
boolean titlebar = true
string title = "Datawindow List"
string dataobject = "d_report_object_list"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_report_generator
end type

type cb_1 from so_commandbutton within w_report_generator
integer x = 1367
integer y = 96
integer width = 503
integer height = 120
integer taborder = 80
boolean bringtotop = true
integer weight = 400
string text = "Get DW Source"
end type

event clicked;call super::clicked;String ls_dwsyn, ls_errors , lvs_library, lvs_dw_name
string lvs_datawindow_name , lvs_report_title
string lvs_report_style,   lvs_presentation_style,   lvs_comments
Blob lvb_dwsyn_blob
int lvi_count

if dw_1.getrow() < 1 then 
	return
end if 

lvs_dw_name = dw_1.object.object_name[dw_1.getrow()]
lvs_library = dw_1.object.pbl_name[dw_1.getrow()]
ls_dwsyn = LibraryExport(lvs_library, lvs_dw_name, ExportDataWindow!)

lvs_datawindow_name = dw_1.object.object_name[dw_1.getrow()]
lvs_report_title = dw_1.object.desc[dw_1.getrow()]

select count(*) into :lvi_count
 from isys_report_source
where datawindow_name = :lvs_datawindow_name
    and organization_id = :gvi_organization_id ;

if f_sql_check() < 0 then 
	return
end if  

	if lvi_count = 0 then 
		
		  INSERT INTO "ISYS_REPORT_SOURCE"  
				 ( "DATAWINDOW_NAME",   
				   "ORGANIZATION_ID",   
				   "REPORT_TITLE",   
				   "REPORT_STYLE",   
				   "PRESENTATION_STYLE",   
				   "COMMENTS",   
				   "VERSION",   
				   "ENTER_BY",   
				   "ENTER_DATE",   
				   "LAST_MODIFY_BY",   
				   "LAST_MODIFY_DATE", REPORT_GROUP )  
		  VALUES ( :lvs_datawindow_name,   
				   :gvi_organization_id,   
				   :lvs_report_title,   
				   :lvs_report_style,   
				   :lvs_presentation_style,   
				   :lvs_comments ,
				   '1',   
				   :gvs_user_id ,
				   sysdate ,
				   :gvs_user_id ,
				   sysdate ,
				   '*' // DEFAULT 
				   )  ;
			if f_sql_check() < 0 then 
				return
			end if 

	else
		
		f_msgbox1(813 , lvs_datawindow_name ) //$$HEX10$$74c7f8bb200074c8acc7200069d5c8b2e4b22000$$ENDHEX$$
		
	end if 
	
lvb_dwsyn_blob = blob(ls_dwsyn)

updateblob isys_report_source 
            set datawindow_source  = :lvb_dwsyn_blob
	 where datawindow_name = :lvs_datawindow_name
	     and organization_id = :gvi_organization_id ;

if f_sql_check() < 0 then 
	return
end if 
	
msg = f_msgbox(1170 )
if msg = 1 then 
	commit ;
	f_retrieve()
	f_msg_mdi_help(f_msg_st(170))	
else
	rollback;
end if 


end event

type cb_file_open from so_commandbutton within w_report_generator
integer x = 869
integer y = 96
integer width = 503
integer height = 120
integer taborder = 80
boolean bringtotop = true
integer weight = 400
string text = "Pbl File Search"
end type

event clicked;dw_1.bringtotop = true
openwithparm( w_library_select_popup , dw_1 )
end event

type cb_2 from so_commandbutton within w_report_generator
integer x = 1865
integer y = 96
integer width = 503
integer height = 120
integer taborder = 90
boolean bringtotop = true
integer weight = 400
string text = "Del DW Source"
end type

event clicked;call super::clicked;if dw_2.getrow() < 1 then return

msg = f_msgbox1(1161 , this.text)
if msg = 1 then 
   dw_2.deleterow(dw_2.getrow())
   f_update()
end if 
   
   


end event

type sle_datawindow_name from so_singlelineedit within w_report_generator
integer x = 78
integer y = 164
integer width = 727
integer height = 84
integer taborder = 20
boolean bringtotop = true
end type

type st_1 from so_statictext within w_report_generator
integer x = 78
integer y = 92
integer width = 727
integer height = 68
boolean bringtotop = true
string text = "Datawindow Name"
end type

type cb_3 from so_commandbutton within w_report_generator
integer x = 2377
integer y = 96
integer width = 503
integer height = 120
integer taborder = 100
boolean bringtotop = true
integer weight = 400
string text = "Show Menu"
end type

event clicked;call super::clicked;string lvs_datawindow_name
if dw_2.getrow() < 1 then 
	lvs_datawindow_name = '%'
else
	lvs_datawindow_name = dw_2.object.datawindow_name[dw_2.getrow()]
end if 
openwithparm( w_report_menu_insert_popup , lvs_datawindow_name)
end event

type cb_4 from so_commandbutton within w_report_generator
integer x = 2880
integer y = 96
integer width = 503
integer height = 120
integer taborder = 110
boolean bringtotop = true
integer weight = 400
string text = "Show DW Syntax"
end type

event clicked;call super::clicked;if dw_2.getrow() < 1 then return

openwithparm( w_edit_window ,  f_get_data_window_source( dw_2.object.datawindow_name[dw_2.getrow()] ) )
end event

type cb_5 from so_commandbutton within w_report_generator
integer x = 3383
integer y = 96
integer width = 503
integer height = 120
integer taborder = 120
boolean bringtotop = true
integer weight = 400
string text = "Show DW Text"
end type

event clicked;call super::clicked;String lvs_col_name, lvs_col_mean , lvs_col_type , lvs_data_window
Integer lvi_count , li_objcount , li_start , li_end  , lvl_rows
String  lvs_band ,ls_dwobject , lvs_textlist , lvs_object_y1

//================================================
//
//================================================
if dw_2.getrow() < 1 then return 
lvs_data_window = f_get_data_window_source( dw_2.object.datawindow_name[dw_2.getrow()] )

//=============================================
if lvs_data_window = '' then 
	dw_4.dataobject = 'd_null_datawindow'
	return
else
	dw_4.Create ( lvs_data_window) 
end if 

f_dual_lang_change_dwtext(dw_4)


ls_dwobject = dw_4.Object.DataWindow.Objects     // dw object list
if len(trim(ls_dwobject)) = 0 then 
	return
end if

li_objcount = f_dual_lang_object_count(ls_dwobject)  // get object count

//=================================================================
//
//=================================================================
	li_start = 0
	
	for lvi_count = 1 to li_objcount
		
		lvs_col_name = '' 
		lvl_rows = 0 ;
		
		li_end = pos(ls_dwobject, "~t", li_start + 1)
		
		if lvi_count < li_objcount then    // last object check
			lvs_col_name = mid(ls_dwobject, li_start + 1, li_end - li_start - 1)	
		else
			lvs_col_name = mid(ls_dwobject, li_start + 1, len(ls_dwobject) - li_start)
		end if
	
	      lvs_band = ''
		   lvs_col_type = dw_4.describe (lvs_col_name + ".type") 
		if lvs_col_type = "text" then    // object type check
				
				lvs_band=  dw_4.Describe(lvs_col_name + ".Band")
				
				if lvs_band = 'header' then 
					lvs_col_name	= dw_4.Describe(lvs_col_name+".Name")						
				      lvs_col_mean     = lefttrim(dw_4.Describe(lvs_col_name+".text"))
                              lvs_object_y1     = dw_4.Describe(lvs_col_name + ".y")
							  
					lvs_textlist = lvs_textlist +mid(lvs_object_y1+"____________________________",1, 20)+"   "+mid(lvs_col_name +"________________________________________________", 1, 30 )+" "+lvs_col_mean + '~r~n'
				end if 
	
		end if
            li_start = li_end
	next

openwithparm( w_edit_window , lvs_textlist )
end event

type gb_1 from so_groupbox within w_report_generator
integer x = 841
integer width = 3072
integer height = 276
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Select Library"
end type

type gb_2 from so_groupbox within w_report_generator
integer x = 27
integer width = 809
integer height = 288
integer taborder = 20
integer weight = 700
string text = "Where Condition"
end type

