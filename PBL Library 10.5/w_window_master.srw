HA$PBExportHeader$w_window_master.srw
$PBExportComments$Window Information Manage
forward
global type w_window_master from w_main_root
end type
type st_14 from so_statictext within w_window_master
end type
type st_1 from so_statictext within w_window_master
end type
type sle_window_name from so_singlelineedit within w_window_master
end type
type sle_window_description from so_singlelineedit within w_window_master
end type
type sle_path from so_singlelineedit within w_window_master
end type
type cb_file_open from so_commandbutton within w_window_master
end type
type cb_retrieve from so_commandbutton within w_window_master
end type
type lb_pbl from so_picturelistbox within w_window_master
end type
type lb_object_type from so_picturelistbox within w_window_master
end type
type cb_1 from so_commandbutton within w_window_master
end type
type cb_2 from so_commandbutton within w_window_master
end type
type gb_2 from so_groupbox within w_window_master
end type
type gb_1 from so_groupbox within w_window_master
end type
end forward

global type w_window_master from w_main_root
integer width = 4645
integer height = 2916
string title = "Application WIndow"
st_14 st_14
st_1 st_1
sle_window_name sle_window_name
sle_window_description sle_window_description
sle_path sle_path
cb_file_open cb_file_open
cb_retrieve cb_retrieve
lb_pbl lb_pbl
lb_object_type lb_object_type
cb_1 cb_1
cb_2 cb_2
gb_2 gb_2
gb_1 gb_1
end type
global w_window_master w_window_master

type variables
string is_path
end variables

on w_window_master.create
int iCurrent
call super::create
this.st_14=create st_14
this.st_1=create st_1
this.sle_window_name=create sle_window_name
this.sle_window_description=create sle_window_description
this.sle_path=create sle_path
this.cb_file_open=create cb_file_open
this.cb_retrieve=create cb_retrieve
this.lb_pbl=create lb_pbl
this.lb_object_type=create lb_object_type
this.cb_1=create cb_1
this.cb_2=create cb_2
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_14
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_window_name
this.Control[iCurrent+4]=this.sle_window_description
this.Control[iCurrent+5]=this.sle_path
this.Control[iCurrent+6]=this.cb_file_open
this.Control[iCurrent+7]=this.cb_retrieve
this.Control[iCurrent+8]=this.lb_pbl
this.Control[iCurrent+9]=this.lb_object_type
this.Control[iCurrent+10]=this.cb_1
this.Control[iCurrent+11]=this.cb_2
this.Control[iCurrent+12]=this.gb_2
this.Control[iCurrent+13]=this.gb_1
end on

on w_window_master.destroy
call super::destroy
destroy(this.st_14)
destroy(this.st_1)
destroy(this.sle_window_name)
destroy(this.sle_window_description)
destroy(this.sle_path)
destroy(this.cb_file_open)
destroy(this.cb_retrieve)
destroy(this.lb_pbl)
destroy(this.lb_object_type)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.gb_2)
destroy(this.gb_1)
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
Ivs_resize_type    = 'MASTER_DETAIL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default


ivs_modify_security = 'N' 
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

event ue_data_control;call super::ue_data_control;LONG ROW


CHOOSE CASE GVS_UE_DATA_CONTROL
	CASE 'RETRIEVE'
		
		THIS.DW_1.RETRIEVE(SLE_WINDOW_NAME.TEXT+'%' , GVI_ORGANIZATION_ID)
		THIS.DW_1.SETFOCUS()
			

	CASE 'INSERT'
			ROW = THIS.DW_1.INSERTROW(THIS.DW_1.GETROW())
			THIS.DW_1.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(THIS.DW_1 , ROW , 'ALL')
			THIS.DW_1.SETFOCUS()
			F_MSG_MDI_HELP( F_MSG_ST(152))
	CASE 'APPEND'
			ROW = THIS.DW_1.INSERTROW(0)
			THIS.DW_1.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(THIS.DW_1 , ROW , 'ALL')	
			THIS.DW_1.SETFOCUS()
			F_MSG_MDI_HELP( F_MSG_ST(152))
			
	CASE 'DELETE'
	   
		  	IF THIS.DW_1.GETROW() < 1 THEN RETURN 
			  
          	MSG = F_MSGBOX(1003) 
			IF MSG = 1 THEN
				GVL_ROW_DELETED = THIS.DW_1.GETROW()			
				THIS.DW_1.DELETEROW(GVL_ROW_DELETED)		
				THIS.DW_1.SETFOCUS()
				ROW = THIS.DW_1.GETROW()
				THIS.DW_1.SCROLLTOROW(ROW)
				THIS.DW_1.SETCOLUMN(1)
			END IF
			  
	CASE 'UPDATE'
		
	          IF THIS.DW_1.UPDATE() < 0 THEN
				ROLLBACK;
			ELSE
			  COMMIT;
			  F_MSG_MDI_HELP( F_MSG_ST(170))
			END IF
			
	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())


end event

type dw_5 from w_main_root`dw_5 within w_window_master
integer y = 552
end type

type dw_4 from w_main_root`dw_4 within w_window_master
integer y = 552
end type

type dw_3 from w_main_root`dw_3 within w_window_master
integer y = 552
integer width = 603
integer height = 416
end type

type dw_2 from w_main_root`dw_2 within w_window_master
integer x = 9
integer y = 1964
integer width = 4539
integer height = 836
integer taborder = 40
boolean titlebar = true
string title = "Object List"
string dataobject = "d_object_list"
end type

type dw_1 from w_main_root`dw_1 within w_window_master
integer y = 552
integer width = 4539
integer height = 1400
boolean titlebar = true
string title = "Window Master"
string dataobject = "d_window_lst"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_window_master
end type

type st_14 from so_statictext within w_window_master
integer x = 37
integer y = 116
integer width = 494
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Window Name"
end type

type st_1 from so_statictext within w_window_master
integer x = 535
integer y = 116
integer width = 571
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Window Description"
end type

type sle_window_name from so_singlelineedit within w_window_master
integer x = 37
integer y = 196
integer width = 494
integer taborder = 20
boolean bringtotop = true
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN = 'WINDOW_NAME'

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

SELECTED_DATA_WINDOW.SETFILTER('')
SELECTED_DATA_WINDOW.FILTER()

IF THIS.TEXT = '' THEN 
	SELECTED_DATA_WINDOW.SETFILTER('')
	SELECTED_DATA_WINDOW.FILTER()
	RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
SELECTED_DATA_WINDOW.FILTER()

end event

type sle_window_description from so_singlelineedit within w_window_master
integer x = 535
integer y = 196
integer width = 571
integer taborder = 20
boolean bringtotop = true
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN = 'window_description_local'

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

SELECTED_DATA_WINDOW.SETFILTER('')
SELECTED_DATA_WINDOW.FILTER()

IF THIS.TEXT = '' THEN 
	SELECTED_DATA_WINDOW.SETFILTER('')
	SELECTED_DATA_WINDOW.FILTER()
	RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
SELECTED_DATA_WINDOW.FILTER()

end event

type sle_path from so_singlelineedit within w_window_master
integer x = 1175
integer y = 280
integer width = 1111
integer height = 244
integer taborder = 20
boolean bringtotop = true
long backcolor = 12632256
boolean enabled = false
boolean autohscroll = false
end type

type cb_file_open from so_commandbutton within w_window_master
integer x = 1179
integer y = 76
integer width = 549
integer height = 96
integer taborder = 20
boolean bringtotop = true
string text = "Pbl File Search"
end type

event clicked;string 	ls_item
long		ll_total, i
string	ls_full, named
int		file_ok


file_ok = GetFileOpenName("Select File", ls_full, named, "PBL", "PowerBuild Library Files (*.PBL),*.PBL")
if file_ok <> 1 then
	return
end if

is_path			=	left(ls_full, len(ls_full) - len(named))
sle_path.text	=	is_path

if is_path = "" then 
	f_msgbox(156)
	//("$$HEX2$$55d678c7$$ENDHEX$$","$$HEX15$$54d67cc7200088c794b2200004c758ce7cb9200085c725b858d538c194c6$$ENDHEX$$...!")
else
	lb_pbl.reset()
	lb_pbl.DirList(is_path + "*.pbl", 0)
end if

ll_total = lb_pbl.TotalItems()
for i = 1 to ll_total
	ls_item	=	lb_pbl.text(i)
	lb_pbl.DeleteItem(i)
	lb_pbl.InsertItem(ls_item, 1, i)
next
end event

type cb_retrieve from so_commandbutton within w_window_master
integer x = 1733
integer y = 76
integer width = 549
integer height = 96
integer taborder = 80
boolean bringtotop = true
string text = "Get Object"
end type

event clicked;// $$HEX13$$54d67cc72000acb9a4c2b8d27cb9200004c75cd52000c0bc18c2$$ENDHEX$$
string	ls_file
long		ll_file_count, ll_file_select

// $$HEX12$$1dacb4cc2000c0d085c744c7200004c75cd52000c0bc18c2$$ENDHEX$$
string	ls_type
long		ll_type_count, ll_type_select

// $$HEX19$$d4c5b8d2acb92000acb9a4c2b8d27cb9200000ac38c824c630ae200004c75cd52000c0bc18c2$$ENDHEX$$
string 	ls_entries
long		ll_count, i, ll_temp


dw_2.Reset( )
dw_2.bringtotop = true 
ll_type_count  = lb_object_type.TotalItems( )
ll_file_count  = lb_pbl.TotalItems( )

// $$HEX9$$20c1ddd02000c6c53cc774ba2000acb934d1$$ENDHEX$$
if ll_file_count = 0 or ll_type_count = 0 then return

SetPointer ( HourGlass! )
dw_2.setredraw(false)

// $$HEX11$$54d67cc7200018c2ccb97cd0200018bcf5bc5cd5e4b2$$ENDHEX$$.
FOR ll_file_select = 1 TO ll_file_count
	
	// $$HEX16$$54d67cc774c7200020c1ddd01cb42000bdacb0c6ccb9200098ccacb95cd5e4b2$$ENDHEX$$.
	if lb_pbl.state(ll_file_select) = 1 then 
	
		ls_file	=	lb_pbl.text(ll_file_select)
		
		// $$HEX11$$c0d085c7200018c2ccb97cd0200018bcf5bc5cd5e4b2$$ENDHEX$$.
		FOR ll_type_select = 1 TO ll_type_count
			
			// $$HEX16$$c0d085c774c7200020c1ddd01cb42000bdacb0c6ccb9200098ccacb95cd5e4b2$$ENDHEX$$. 
			if lb_object_type.state(ll_type_select) = 1 then 
			
				ls_type	=	lb_object_type.text(ll_type_select)
				
				CHOOSE CASE ls_type
					CASE 'Application'
						ls_entries = LibraryDirectory(is_path + ls_file, DirApplication!)
					CASE 'DataWindow'
						ls_entries = LibraryDirectory(is_path + ls_file, DirDataWindow!)
					CASE 'Function'
						ls_entries = LibraryDirectory(is_path + ls_file, DirFunction!)
					CASE 'Menu'
						ls_entries = LibraryDirectory(is_path + ls_file, DirMenu!)
					CASE 'Pipeline'
						ls_entries = LibraryDirectory(is_path + ls_file, DirPipeline!)
					CASE 'Project'
						ls_entries = LibraryDirectory(is_path + ls_file, DirProject!)
					CASE 'Query'
						ls_entries = LibraryDirectory(is_path + ls_file, DirQuery!)
					CASE 'Structure'
						ls_entries = LibraryDirectory(is_path + ls_file, DirStructure!)
					CASE 'User objects'
						ls_entries = LibraryDirectory(is_path + ls_file, DirUserObject!)
					CASE 'Window'
						ls_entries = LibraryDirectory(is_path + ls_file, DirWindow!)
				END CHOOSE
				
				dw_2.accepttext()
				
				// $$HEX22$$d4c5b8d2acb958c7200030aef8bc200015c8f4bc7cb9200000ac38c840c61cc1200078c7ecd3b8d25cd5e4b2$$ENDHEX$$.
				ll_temp	=	dw_2.rowcount()
				ll_count = 	dw_2.ImportString( UPPER(ls_Entries), 1, 10000, 1, 3, 3)
				
				// pbl, type, argument $$HEX6$$7cb9200000ac38c840c62000$$ENDHEX$$update$$HEX2$$5cd5e4b2$$ENDHEX$$.
				FOR i = ll_temp + 1 TO ll_count + ll_temp
					dw_2.object.pbl_name[i]		= ls_file
					dw_2.object.object_type[i]	= ls_type
					
					// function$$HEX5$$78c72000bdacb0c6ccb9$$ENDHEX$$argument$$HEX6$$7cb9200000ac38c828c6e4b2$$ENDHEX$$.
					if ls_type = 'Function' then
						ScriptDefinition		sd_myfunc
						VariableDefinition	vd_myfunc[]
						TypeDefinition			td_myfunc
						
						int li_loop, total
						string ls_libraries[], ls_func, ls_arg_name, ls_arg_type, ls_list
						
						ls_libraries[1]	= is_path + ls_file
						ls_func				= dw_2.object.object_name[i]
						
						sd_myfunc			= FindFunctionDefinition( ls_func, ls_libraries[]) 
						
						if ISNULL(sd_myfunc) then
							continue
						end if
						
						vd_myfunc[]			= sd_myfunc.ArgumentList 
						total					= upperbound(vd_myfunc)
						
						ls_list = ''
						for li_loop = 1 to total
							td_myfunc	= vd_myfunc[li_loop].typeinfo
							ls_arg_name = vd_myfunc[li_loop].name
							ls_arg_type = td_myfunc.DataTypeOf
							
							if ls_list = '' then
								ls_list += ls_arg_name + '(' + ls_arg_type + ')'
							else
								ls_list += ',   ' + ls_arg_name + '(' + ls_arg_type + ')'
							end if
						next
						dw_2.object.arg_list[i]	= ls_list
					
					end if
					
				NEXT
				
			end if
		NEXT
	end if
NEXT

dw_2.setredraw(true)

end event

type lb_pbl from so_picturelistbox within w_window_master
integer x = 2318
integer y = 44
integer width = 1531
integer height = 488
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
boolean hscrollbar = true
boolean vscrollbar = true
boolean multiselect = true
boolean extendedselect = true
string picturename[] = {"Library!"}
end type

type lb_object_type from so_picturelistbox within w_window_master
integer x = 3858
integer y = 44
integer width = 480
integer height = 488
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
boolean hscrollbar = true
boolean vscrollbar = true
boolean sorted = false
boolean multiselect = true
string item[] = {"Window","DataWindow","Function","Menu","Application","Pipeline","Project","Query","Struture","User objects"}
boolean extendedselect = true
integer itempictureindex[] = {1,2,3,4,5,6,7,8,9,10}
string picturename[] = {"Window!","DataWindow5!","Function!","Menu5!","Application!","DataPipeline!","Project!","Query5!","Structure5!","UserObject5!"}
end type

type cb_1 from so_commandbutton within w_window_master
integer x = 1179
integer y = 176
integer width = 549
integer height = 96
integer taborder = 90
boolean bringtotop = true
string text = "Upload Window"
end type

event clicked;int i , lvl_rows , LVI_COUNT
string LVS_OBJECT_NAME
if dw_2.getrow() < 1 then 
	return 
end if

DW_1.RESET()
F_SET_COLUMN_DDDW(DW_1)
do
	
	i++
	
	if dw_2.object.check_yn[i] = 'Y' then 
	else
		continue 
	end if
	
	
	LVS_OBJECT_NAME = UPPER( dw_2.object.object_name[i])
	
	SELECT COUNT(*) INTO :LVI_COUNT
	  FROM ISYS_WINDOW 
	WHERE WINDOW_NAME = :LVS_OBJECT_NAME
	    AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
		 
	IF F_SQL_CHECK() < 0 THEN 
		RETURN
	END IF
		

    if lvi_count > 0 then 
		Continue 
    end if

	lvl_rows = dw_1.insertrow(0)
	f_set_security_row( dw_1 , lvl_rows , 'ALL')
	dw_1.object.window_name[lvl_rows] = LVS_OBJECT_NAME
	dw_1.object.window_type[lvl_rows] = 'WINDOW'
	dw_1.object.version[lvl_rows] = 1.0
	dw_1.object.window_description_eng[lvl_rows] =  dw_2.object.desc[i]
	dw_1.object.window_description_kor[lvl_rows] =  dw_2.object.desc[i]
	dw_1.object.window_description_local[lvl_rows] =  dw_2.object.desc[i]	
	
	dw_1.object.window_group_eng[lvl_rows] = '*'
	dw_1.object.window_group_kor[lvl_rows] =  '*'
	dw_1.object.window_group_local[lvl_rows] =  '*'
	
loop until i = dw_2.rowcount()
end event

type cb_2 from so_commandbutton within w_window_master
integer x = 1733
integer y = 176
integer width = 549
integer height = 96
integer taborder = 100
boolean bringtotop = true
string text = "Upload Description"
end type

event clicked;string	ls_title , lvs_window , lvs_title_conversion
window lw_main
Long i , j 


do
    i++
    lvs_window = dw_1.object.window_name[i]	 
	// $$HEX12$$08c7c4b3b0c62000c0d074c7c0d220007dc7b4c524c630ae$$ENDHEX$$
	lw_main = CREATE using lvs_window
	ls_title = lw_main.Title
	DESTROY lw_main
	
	lvs_title_conversion = f_get_code_name( ls_title )
	
	if lvs_title_conversion = '' or isnull(lvs_title_conversion) then 
		continue
	else
		j++
				if gvs_language = 'C' then 
				
					Update isys_window set window_description_local = :lvs_title_conversion
					  where window_name = :lvs_window
							and organization_id = :gvi_organization_id ;
							
						if f_sql_check() < 0 then 
						 Return
					 end if
					 
				elseif gvs_language = 'K' then 
					
					Update isys_window set window_description_kor = :lvs_title_conversion
					  where window_name = :lvs_window
							and organization_id = :gvi_organization_id ;
							
						if f_sql_check() < 0 then 
						 Return
					 end if			
					 
				elseif gvs_language = 'E' then 
					
					Update isys_window set window_description_eng = :lvs_title_conversion
					  where window_name = :lvs_window
							and organization_id = :gvi_organization_id ;
							
						if f_sql_check() < 0 then 
						 Return
					 end if						 
				end if
		
		end if
	
loop until i = dw_1.rowcount( )

Msg= F_MSGBOX1( 9014 , STRING(j)) //@ $$HEX18$$74ac74c7200018c215c8200018b4c8c5b5c2c8b2e4b2200000c8a5c7200060d54cae94c6$$ENDHEX$$
IF MSG = 1 THEN 
	COMMIT ;
ELSE
	ROLLBACK;
END IF
	 
end event

type gb_2 from so_groupbox within w_window_master
integer x = 1134
integer width = 3241
integer height = 552
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_1 from so_groupbox within w_window_master
integer x = 9
integer width = 1111
integer height = 336
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

