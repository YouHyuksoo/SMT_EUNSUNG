HA$PBExportHeader$w_smt_location_master.srw
$PBExportComments$$$HEX6$$80bd88d42000c8b9a4c230d1$$ENDHEX$$
forward
global type w_smt_location_master from w_main_root
end type
type st_line_code from so_statictext within w_smt_location_master
end type
type sle_machine_code from so_singlelineedit within w_smt_location_master
end type
type st_machine_code from so_statictext within w_smt_location_master
end type
type ddlb_line_code from uo_line_code within w_smt_location_master
end type
type cb_1 from so_commandbutton within w_smt_location_master
end type
type mle_selected from so_multilineedit within w_smt_location_master
end type
type cb_2 from so_commandbutton within w_smt_location_master
end type
type gb_1 from so_groupbox within w_smt_location_master
end type
type gb_2 from so_groupbox within w_smt_location_master
end type
end forward

global type w_smt_location_master from w_main_root
integer width = 4736
integer height = 2904
string title = "SMT Location Master"
st_line_code st_line_code
sle_machine_code sle_machine_code
st_machine_code st_machine_code
ddlb_line_code ddlb_line_code
cb_1 cb_1
mle_selected mle_selected
cb_2 cb_2
gb_1 gb_1
gb_2 gb_2
end type
global w_smt_location_master w_smt_location_master

on w_smt_location_master.create
int iCurrent
call super::create
this.st_line_code=create st_line_code
this.sle_machine_code=create sle_machine_code
this.st_machine_code=create st_machine_code
this.ddlb_line_code=create ddlb_line_code
this.cb_1=create cb_1
this.mle_selected=create mle_selected
this.cb_2=create cb_2
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_line_code
this.Control[iCurrent+2]=this.sle_machine_code
this.Control[iCurrent+3]=this.st_machine_code
this.Control[iCurrent+4]=this.ddlb_line_code
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.mle_selected
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.gb_2
end on

on w_smt_location_master.destroy
call super::destroy
destroy(this.st_line_code)
destroy(this.sle_machine_code)
destroy(this.st_machine_code)
destroy(this.ddlb_line_code)
destroy(this.cb_1)
destroy(this.mle_selected)
destroy(this.cb_2)
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
Ivs_resize_type    = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
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

event ue_data_control;call super::ue_data_control;Long ROW
STRING LVS_SETYN
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		   
			DW_1.RETRIEVE(  ddlb_line_code.getcode( )+'%' , sle_machine_code.text+'%' , GVI_ORGANIZATION_ID )
			DW_1.SETFOCUS()
				
	CASE 'INSERT'
			dw_1.enabled = true
			row = dw_1.insertrow(dw_1.getrow())
			dw_1.scrolltorow(row)
			f_set_security_row(dw_1 , row , 'ALL')
			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
	CASE 'APPEND'
			dw_1.enabled = true
			row = dw_1.insertrow(0)
			dw_1.scrolltorow(row)
			f_set_security_row(dw_1 , row , 'ALL')
			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )	
	CASE 'DELETE'
		
		  	if dw_1.getrow() < 1 then return 
			  
			msg =f_msgbox(1003)
			if msg = 1 then
				gvl_row_deleted = dw_1.getrow()			
				dw_1.deleterow(gvl_row_deleted)		
				dw_1.setfocus()
				row = dw_1.getrow()
				dw_1.scrolltorow(row)
				dw_1.setcolumn(1)
			end if
			
	CASE 'UPDATE'
		
		DW_1.ACCEPTTEXT()
 
	      IF DW_1.UPDATE() < 0 THEN
				ROLLBACK;
				RETURN
		ELSE
				 COMMIT;
       			 F_MSG_MDI_HELP ( F_MSG_ST(170)	 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
		END IF

	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
f_retrieve()
end event

type dw_5 from w_main_root`dw_5 within w_smt_location_master
integer y = 320
end type

type dw_4 from w_main_root`dw_4 within w_smt_location_master
integer x = 5
integer y = 320
end type

type dw_3 from w_main_root`dw_3 within w_smt_location_master
integer x = 5
integer y = 320
integer taborder = 50
end type

type dw_2 from w_main_root`dw_2 within w_smt_location_master
integer x = 5
integer y = 320
integer taborder = 0
boolean titlebar = true
end type

type dw_1 from w_main_root`dw_1 within w_smt_location_master
integer x = 5
integer y = 320
integer width = 4507
integer height = 1208
integer taborder = 40
boolean titlebar = true
string title = "Line List"
string dataobject = "d_ib_location_master_lst"
end type

event dw_1::itemchanged;call super::itemchanged;if dwo.name = 'line_code' or dwo.name ='machine' or dwo.name ='table_id' or dwo.name ='address' or dwo.name ='position' then
	
	this.object.location_code[row] = this.object.line_code[row]+this.object.machine[row]+this.object.table_id[row]+this.object.address[row]+this.object.position[row]
	
end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_smt_location_master
end type

type st_line_code from so_statictext within w_smt_location_master
integer x = 82
integer y = 88
integer width = 590
integer height = 56
boolean bringtotop = true
string text = "Line Code"
end type

type sle_machine_code from so_singlelineedit within w_smt_location_master
integer x = 677
integer y = 164
integer width = 590
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

type st_machine_code from so_statictext within w_smt_location_master
integer x = 677
integer y = 96
integer width = 590
integer height = 56
boolean bringtotop = true
string text = "Machine"
end type

type ddlb_line_code from uo_line_code within w_smt_location_master
integer x = 55
integer y = 164
integer width = 617
integer height = 1964
integer taborder = 20
boolean bringtotop = true
boolean allowedit = true
end type

event selectionchanged;call super::selectionchanged;F_RETRIEVE()
end event

type cb_1 from so_commandbutton within w_smt_location_master
string tag = "$$HEX11$$0cd37cc744c72000c5c55cb8dcb4200069d5c8b2e4b2$$ENDHEX$$"
integer x = 2053
integer y = 92
integer width = 375
integer height = 152
integer taborder = 20
boolean bringtotop = true
integer weight = 400
string text = "Upload"
end type

event clicked;string docpath, docname[] , lvs_line_code , lvs_machine , ls_text
integer i, li_cnt, li_rtn , li_FileNum

////===========================================
//// $$HEX5$$7cb778c715c8f4bc2000$$ENDHEX$$
////===========================================
//lvs_line_code = ddlb_line_code.text()
//if lvs_line_code = '' or isnull(lvs_line_code) or lvs_line_code = '%' then 
//	f_msgbox1(111 , f_get_dual_lang_text( Gvs_language ,  "Line Code") )
//	return -1
//end if 
////===========================================
////$$HEX5$$24c144be15c8f4bc2000$$ENDHEX$$
////===========================================
//lvs_machine =sle_machine_code.text
//if lvs_machine = '' or isnull(lvs_machine) then 
//	f_msgbox1(111 , f_get_dual_lang_text( Gvs_language ,  "Machine Code") )	
//	return -1
//end if 

//=================================
// $$HEX8$$2cc6b4b920000cd37cc7200020c1ddd0$$ENDHEX$$
//=================================
li_rtn = GetFileOpenName("Select File",  docpath, docname[], "DOC", "Text Files (*.TXT),*.TXT," + "Doc Files (*.DOC),*.DOC," + "All Files (*.*), *.*",  Gvs_default_directory)

mle_selected.text = ""

IF li_rtn < 1 THEN return

	li_cnt = Upperbound(docname)
	if li_cnt = 1 then
			mle_selected.text = string(docpath)
	else

		for i=1 to li_cnt
			mle_selected.text += string(docpath) + "\" +(string(docname[i]))+"~r~n"
		next

end if
//===============================================
// $$HEX10$$0cd37cc72000c5c55cb8dcb4200038d69ccd2000$$ENDHEX$$
//===============================================
i = 0 
if li_cnt = 1 then 
		li_FileNum = FileOpen (docpath, LineMode!)
		if li_FileNum < 0 then 
			Messagebox("Error" , f_msg("File Open Error : ",'S') + docpath)
			Fileclose(li_FileNum)			
			return
		else
			FileReadEx (li_FileNum, ls_text ) 
			dw_1.importstring( ls_text )
			FileClose(li_FileNum)
		end if
else
//===========================================
// $$HEX15$$20c1ddd01cb420000cd37cc774c72000ecc5ecb71cac200078c7bdacb0c6$$ENDHEX$$
//===========================================
	do
		i++
		li_FileNum = FileOpen (docpath+'\'+docname[i], LineMode!)
		if li_FileNum < 0 then 
			Messagebox("Error" , f_msg("File Open Error : ",'S')+docpath+'\'+docname[i])
			Fileclose(li_FileNum)
			return
		else		
			FileReadEx (li_FileNum, ls_text ) 
			dw_1.importstring( ls_text )
			FileClose(li_FileNum)
		end if 
	loop until i = li_cnt
end if 

changedirectory( gvs_default_directory)


msg = f_msgbox(1170)
if msg = 1 then 
	if dw_1.update() < 0 then 
		rollback;
	else
		commit ;
	end if 
else
	
end if 
end event

type mle_selected from so_multilineedit within w_smt_location_master
integer x = 2446
integer y = 92
integer height = 148
integer taborder = 30
boolean bringtotop = true
string text = ""
end type

type cb_2 from so_commandbutton within w_smt_location_master
string tag = "$$HEX11$$0cd37cc744c72000c5c55cb8dcb4200069d5c8b2e4b2$$ENDHEX$$"
integer x = 1408
integer y = 96
integer width = 375
integer height = 152
integer taborder = 30
boolean bringtotop = true
integer weight = 400
string text = "Delete All"
end type

event clicked;call super::clicked;string lvs_line_code , lvs_machine

lvs_line_code  = ddlb_line_code.GETcode( )
lvs_machine    = sle_machine_code.text


if lvs_line_code = '' or lvs_machine = '' then 

	f_msgbox1(102 , st_line_code.text +' '+st_machine_code.text )
	return
	
end if 

msg = f_msgbox1(1161 , this.text )
if msg = 1 then 

	delete from IB_MACHINE_LOCATION 
	where line_code like :lvs_line_code
	and machine = :lvs_machine ;
	
	if f_sql_check() < 0 then 
		return 
	end if 
	
end if 

commit ;

f_msgbox(170)
end event

type gb_1 from so_groupbox within w_smt_location_master
integer x = 1358
integer width = 1673
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_smt_location_master
integer x = 14
integer width = 1335
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

