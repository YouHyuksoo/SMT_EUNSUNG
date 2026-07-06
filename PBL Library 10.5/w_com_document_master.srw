HA$PBExportHeader$w_com_document_master.srw
$PBExportComments$Base Information Manage
forward
global type w_com_document_master from w_main_root
end type
type sle_doc_keyword from so_singlelineedit within w_com_document_master
end type
type st_2 from so_statictext within w_com_document_master
end type
type cb_1 from so_commandbutton within w_com_document_master
end type
type cb_2 from so_commandbutton within w_com_document_master
end type
type cb_view_doc from so_commandbutton within w_com_document_master
end type
type st_1 from so_statictext within w_com_document_master
end type
type sle_doc_group from so_singlelineedit within w_com_document_master
end type
type cb_3 from so_commandbutton within w_com_document_master
end type
type cb_4 from so_commandbutton within w_com_document_master
end type
type sle_model_name from so_singlelineedit within w_com_document_master
end type
type st_3 from so_statictext within w_com_document_master
end type
type gb_1 from so_groupbox within w_com_document_master
end type
type gb_2 from so_groupbox within w_com_document_master
end type
end forward

global type w_com_document_master from w_main_root
integer width = 5367
integer height = 3144
string title = "Document Master"
sle_doc_keyword sle_doc_keyword
st_2 st_2
cb_1 cb_1
cb_2 cb_2
cb_view_doc cb_view_doc
st_1 st_1
sle_doc_group sle_doc_group
cb_3 cb_3
cb_4 cb_4
sle_model_name sle_model_name
st_3 st_3
gb_1 gb_1
gb_2 gb_2
end type
global w_com_document_master w_com_document_master

type variables
datawindow ivd_data_window
long lvl_row , LVL_DOC_ID
end variables

on w_com_document_master.create
int iCurrent
call super::create
this.sle_doc_keyword=create sle_doc_keyword
this.st_2=create st_2
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_view_doc=create cb_view_doc
this.st_1=create st_1
this.sle_doc_group=create sle_doc_group
this.cb_3=create cb_3
this.cb_4=create cb_4
this.sle_model_name=create sle_model_name
this.st_3=create st_3
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_doc_keyword
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.cb_view_doc
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.sle_doc_group
this.Control[iCurrent+8]=this.cb_3
this.Control[iCurrent+9]=this.cb_4
this.Control[iCurrent+10]=this.sle_model_name
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.gb_2
end on

on w_com_document_master.destroy
call super::destroy
destroy(this.sle_doc_keyword)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_view_doc)
destroy(this.st_1)
destroy(this.sle_doc_group)
destroy(this.cb_3)
destroy(this.cb_4)
destroy(this.sle_model_name)
destroy(this.st_3)
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
Ivs_resize_type    = 'MASTER_DETAIL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
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
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		
			 dw_1.RETRIEVE( sle_model_name.text+'%' , SLE_Doc_GROUP.TEXT+'%' , SLE_Doc_KEYWORD.TEXT+'%' , GVI_ORGANIZATION_ID)
               dw_1.SETFOCUS()
			
	CASE 'INSERT'
		
		
			lvl_row = dw_1.INSERTROW(dw_1.GETROW())
			dw_1.SCROLLTOROW(ROW)
						
			SELECT MAX(DOC_ID)+1 
			   INTO :LVL_DOC_ID
			  FROM ICOM_DOCUMENT
			WHERE ORGANIZATION_ID  = :GVI_ORGANIZATION_ID ;
			
			IF F_SQL_CHECK() < 0 THEN 
				RETURN
			END IF
			
			DW_1.OBJECT.DOC_ID[lvl_row] = LVL_DOC_ID
			DW_1.OBJECT.DOC_CODE[lvl_row] = 'WORKORDER'
			
			F_SET_SECURITY_ROW(dw_1 , lvl_row , 'ALL')
			

	CASE 'DELETE'
			if dw_1.AcceptText() = -1 then
				return
			end if
			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
				Gvl_row_deleted = dw_1.GetRow()			
				dw_1.DELETEROW(Gvl_row_deleted)		
				dw_1.SetFocus()
				ROW = dw_1.GetRow()
				dw_1.ScrollToRow(row)
				dw_1.SetColumn(1)
			END IF
						
	CASE 'UPDATE'
		
          	IF dw_1.UPDATE() < 0 or dw_2.UPDATE() < 0 THEN
				ROLLBACK;
			ELSE
				 COMMIT;
 				 F_MSG_MDI_HELP( f_msg_st( 170) ) //$$HEX7$$00c8a5c718b4c8c5b5c2c8b2e4b2$$ENDHEX$$

			END IF
			
	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_com_document_master
boolean visible = false
integer y = 352
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_com_document_master
boolean visible = false
integer y = 352
integer taborder = 50
end type

type dw_3 from w_main_root`dw_3 within w_com_document_master
boolean visible = false
integer y = 352
integer taborder = 60
end type

type dw_2 from w_main_root`dw_2 within w_com_document_master
integer x = 5
integer y = 2000
integer width = 4498
integer height = 964
integer taborder = 70
boolean titlebar = true
string title = "Doc Detail"
string dataobject = "d_com_document_mst"
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_2::resize;call super::resize;this.object.Doc_keyword.width = this.width
this.object.Doc_comment.width = this.width
this.object.Doc_comment.height = this.height
end event

type dw_1 from w_main_root`dw_1 within w_com_document_master
integer y = 308
integer width = 4507
integer height = 1684
integer taborder = 0
boolean titlebar = true
string title = "Doc List"
string dataobject = "d_com_document_lst"
boolean minbox = true
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;IF CURRENTROW <  1 THEN RETURN
DW_2.RETRIEVE( STRING( THIS.OBJECT.ROWID[CURRENTROW] ))
DW_1.SETFOCUS()
end event

event dw_1::doubleclicked;call super::doubleclicked;IF ROW <  1 THEN RETURN
DW_2.RETRIEVE( STRING( THIS.OBJECT.ROWID[ROW] ))
DW_1.SETFOCUS()
end event

event dw_1::buttonclicked;call super::buttonclicked;if dwo.name = 'b_item' then 
	
	open(w_des_model_master_popup)

	if gst_return.gvb_return = true then 
		
		this.object.model_name[row] = message.stringparm
		
	end if 
	
	
end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_com_document_master
end type

type sle_doc_keyword from so_singlelineedit within w_com_document_master
integer x = 1230
integer y = 164
integer width = 1138
integer taborder = 20
boolean bringtotop = true
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

LVS_COLUMN = "Doc_KEYWORD"

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

DW_1.SETFILTER('')
DW_1.FILTER()

IF THIS.TEXT = '' THEN 
	DW_1.SETFILTER('')
	DW_1.FILTER()
	RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

DW_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
DW_1.FILTER()
F_MSG_MDI_HELP( STRING( DW_1.ROWCOUNT() ) + " Found")
end event

type st_2 from so_statictext within w_com_document_master
integer x = 1234
integer y = 80
integer width = 1138
boolean bringtotop = true
integer weight = 700
string text = "Doc Keyword"
end type

type cb_1 from so_commandbutton within w_com_document_master
integer x = 3378
integer y = 88
integer height = 136
integer taborder = 30
boolean bringtotop = true
string text = "Update Doc File"
end type

event clicked;call super::clicked;INT    li_filenum , loops, i , lvi_count
LONG   flen, bytes_read , bytes_read_sum , new_pos 
BLOB   lib_file , b
string is_filename, is_fullname , LVS_DOC_CODE , lvs_line_code , lvs_workstage_code , lvs_model_name  ,  ls_docname[]



IF  dw_1.getrow() < 1 THEN 
	RETURN
END IF

LVS_DOC_CODE = STRING(dw_1.OBJECT.DOC_ID[dw_1.getrow()])

IF  isnull(LVS_DOC_CODE) THEN 
	RETURN
END IF

IF GetFileOpenName("Select File", is_fullname, ls_docname[], "ALL",  "All Files(*.*), *.*", "C:\", 18) < 1 THEN RETURN 


//IF getfileopenname("Select File", &
//							is_fullname, is_filename, "ppsx", &
//							+ "ppsx files (*.pps),*.ppsx" & 
//							+ "ppt files (*.ppt),*.ppt," &
//							+ "jpg files (*.jpg),*.jpg," &
//							+ "all files (*.*), *.*") < 1 THEN RETURN

flen = filelength(is_fullname)

is_filename = ls_docname[1]

IF flen < 0 THEN 
	f_msgbox1(9020 ,is_fullname ) 	//("error" , is_fullname+" file length unknown")
	RETURN 
END IF

li_filenum = fileopen(is_fullname,  streammode!, READ!, lockread!)

IF li_filenum <> -1 THEN

//bytes_read = filereadex(li_filenum, lib_file , flen )
//F_MSG_MDI_HELP( string(bytes_read_sum)+"/"+string(flen)+" bytes read" )
//fileclose(li_filenum)

		setpointer(hourglass!)
		if flen > 32765 then
		
				  if mod(flen, 32765) = 0 then
						loops = flen/32765
				  else
						loops = (flen/32765) + 1
				  end if
		else
				  loops = 1
		end if
		
		new_pos = 1
		for i = 1 to loops
				  bytes_read = fileread(li_filenum, b)
				  bytes_read_sum = bytes_read_sum + bytes_read
				  lib_file = lib_file + b
				  f_msg_mdi_help( string(bytes_read_sum)+"/"+string(flen)+" bytes read" )
		next
		
		fileclose(li_filenum)
					



//=========================================
//
//=========================================


	SELECT count(*) INTO :lvi_count
	  FROM ICOM_DOCUMENT
	WHERE DOC_ID  = :LVS_DOC_CODE 
		AND organization_id = :gvi_organization_id ;

	IF f_sql_check() < 0 THEN 	RETURN

	IF lvi_count = 0 THEN 
		f_msgbox1( 9021 , is_filename ) 	//("error", is_filename+" file name not found !" )
		RETURN
	END IF
//========================================
//
//========================================

//$$HEX8$$08cd30ae54d67cb920005cd5e4b22000$$ENDHEX$$
UPDATE ICOM_DOCUMENT 
	  SET DOC_IMAGE              =   EMPTY_BLOB()
WHERE DOC_ID                     = :LVS_DOC_CODE
	AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;

//$$HEX8$$c5c55cb8dcb47cb920005cd5e4b22000$$ENDHEX$$
UPDATEBLOB  ICOM_DOCUMENT 
		SET Doc_image = :lib_file 
	WHERE DOC_ID     = :LVS_DOC_CODE
		AND organization_id = :gvi_organization_id ;

IF f_sql_check() < 0 THEN 
	RETURN
END IF
//========================================
// $$HEX5$$0cd37cc785ba44c72000$$ENDHEX$$Update $$HEX3$$5cd5e4b22000$$ENDHEX$$
//========================================
int lvi_pos1 , lvi_pos2 , lvi_pos3
lvi_pos1 =  POS( is_filename , '_' , 1 )
lvi_pos2 =  POS( is_filename , '_' , lvi_pos1+1  )
lvi_pos3 =  POS( is_filename , '.' , 1  )


lvs_line_code            =   MID( is_filename , 1,  lvi_pos1 - 1 ) 
lvs_workstage_code  =   MID( is_filename , lvi_pos1 +1 ,   lvi_pos2 -  (lvi_pos1+1)    ) 
lvs_model_name               =   MID( is_filename , lvi_pos2 +1  , lvi_pos3 -  (lvi_pos2+1)  ) 

//=========================================
UPDATE  ICOM_DOCUMENT 
SET  Doc_file_name = :is_filename ,
       Last_modify_date = sysdate ,
	   line_code = :lvs_line_code ,
	   workstage_code = :lvs_workstage_code ,
	   model_name = :lvs_model_name 	
WHERE DOC_ID      = :LVS_DOC_CODE
AND organization_id = :gvi_organization_id ;

IF f_sql_check() < 0 THEN 
	RETURN
END IF				

IF sqlca.sqlnrows > 0 THEN
	F_MSG_MDI_HELP( f_msg_st(9022) ) 
ELSE
	f_msgbox1( 157 , is_filename )   //("error" , is_filename+"file upload to database failed" )
END IF;				

COMMIT ;


F_RETRIEVE()
END IF


//changedirectory(gvs_default_directory)
end event

type cb_2 from so_commandbutton within w_com_document_master
integer x = 3904
integer y = 88
integer height = 136
integer taborder = 40
boolean bringtotop = true
string text = "Clear Doc File"
end type

event clicked;call super::clicked;BLOB LVB_NULL
LONG LVL_DOC_CODE 

setnull(LVB_NULL)

LVB_NULL = blob(' ')


if dw_1.getrow( ) < 1  then 
	return
end if

LVL_DOC_CODE = dw_1.object.DOC_ID[dw_1.getrow()]

        UPDATE ICOM_DOCUMENT 
               SET DOC_IMAGE              =   EMPTY_BLOB()
         WHERE DOC_ID                     = :LVL_DOC_CODE
               AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
					
					
        UPDATE ICOM_DOCUMENT 
               SET DOC_FILE_NAME      =   NULL 
         WHERE DOC_ID                     = :LVL_DOC_CODE
               AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
					
IF sqlca.sqlnrows > 0 THEN
	F_MSG_MDI_HELP( f_msg_st(9022) ) 
ELSE
	f_msgbox1( 157 , 'ERROR' )   //("error" , is_filename+"file upload to database failed" )
END IF;				

 
IF F_SQL_CHECK() < 0 THEN 
  RETURN
END IF

COMMIT ;

changedirectory(gvs_default_directory)

end event

type cb_view_doc from so_commandbutton within w_com_document_master
integer x = 4430
integer y = 88
integer height = 136
integer taborder = 50
boolean bringtotop = true
string text = "View Doc File"
end type

event clicked;call super::clicked;String  Lvs_return
String  lvs_file_name

if dw_1.getrow() < 1 then return 

Lvs_return =  f_download_document (   string(dw_1.object.doc_id[dw_1.getrow()]  ))

if  Lvs_return <> 'ERROR' then 

	lvs_file_name = getcurrentdirectory()+"\Temp\"+Lvs_return
	
	IF lvs_file_name = '' OR ISNULL(lvs_file_name) THEN 
		RETURN
	END IF

	
	F_MSGBOX(9023)
	
	f_shell_execute_by_extention ( Lvs_return  , '' , getcurrentdirectory()+'\Temp'  )
	
else
	
end if




ChangeDirectory( Gvs_default_directory)
end event

type st_1 from so_statictext within w_com_document_master
integer x = 663
integer y = 80
integer width = 562
boolean bringtotop = true
integer weight = 700
string text = "Doc Group"
end type

type sle_doc_group from so_singlelineedit within w_com_document_master
integer x = 663
integer y = 168
integer width = 562
integer taborder = 30
boolean bringtotop = true
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

LVS_COLUMN = "Doc_GROUP"

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

DW_1.SETFILTER('')
DW_1.FILTER()

IF THIS.TEXT = '' THEN 
	DW_1.SETFILTER('')
	DW_1.FILTER()
	RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

DW_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
DW_1.FILTER()
F_MSG_MDI_HELP( STRING( DW_1.ROWCOUNT() ) + " Found")
end event

type cb_3 from so_commandbutton within w_com_document_master
integer x = 2523
integer y = 88
integer height = 136
integer taborder = 40
boolean bringtotop = true
string text = "Upload Doc File"
end type

event clicked;call super::clicked;INT    li_filenum , loops, i , lvi_count , j
LONG   flen, bytes_read , bytes_read_sum , new_pos 
BLOB   lib_file , b
string is_filename, is_fullname  , lvs_line_code , lvs_workstage_code , lvs_model_name  ,  ls_docname[] ,  ls_docpath
int lvi_pos1 = 0  , lvi_pos2 = 0 , lvi_pos3 = 0 

f_msg("[ $$HEX2$$7cb778c7$$ENDHEX$$_$$HEX2$$f5ac15c8$$ENDHEX$$_$$HEX3$$a8ba78b385ba$$ENDHEX$$.$$HEX4$$55d6a5c790c72000$$ENDHEX$$] $$HEX16$$0cd37cc785ba200015d6ddc2200078c7c0c9200059d578c7200058d538c194c6$$ENDHEX$$" , "P") 

IF GetFileOpenName("Select File", ls_docpath, ls_docname[], "ALL",  "All Files(*.*), *.*", "C:\", 18) < 1 THEN RETURN 

do
	
	j++
	
	    is_fullname = ''
	    is_filename = ''
	    i = 0  ; li_filenum = 0 ;loops = 0 ;  lvi_pos1 = 0  ; lvi_pos2 = 0 ; lvi_pos3 = 0 
		 
		if upperbound(ls_docname) = 1 then 

			is_fullname = ls_docpath
			is_filename = ls_docname[1]		
		else
			is_fullname = ls_docpath+"\"+ls_docname[j]
			is_filename = ls_docname[j]
			
		end if 
		
		flen = 0 
		flen = filelength(is_fullname)
		IF flen < 0 THEN 
			f_msgbox1(9020 ,is_filename ) 	//("error" , is_fullname+" file length unknown")
			RETURN 
		END IF
		
			li_filenum = 0
			
			li_filenum = fileopen(is_fullname,  streammode!)
	//		li_filenum = fileopen(is_fullname,  streammode!, READ!, lockread!)
			
			IF li_filenum <> -1 THEN
			
					setpointer(hourglass!)
					
					if flen > 32765 then
					
							  if mod(flen, 32765) = 0 then
									loops = flen/32765
							  else
									loops = (flen/32765) + 1
							  end if
					else
							  loops = 1
					end if
					
					new_pos = 1
					
                       b = blob('')
					lib_file = blob('')
					
					bytes_read = 0  ; bytes_read_sum = 0 ; 
					
					for i = 1 to loops
							  bytes_read = fileread(li_filenum, b)
							  bytes_read_sum = bytes_read_sum + bytes_read
							  lib_file = lib_file + b
							  f_msg_mdi_help( string(bytes_read_sum)+"/"+string(flen)+" bytes read" )
					next
					
					fileclose(li_filenum)
			
			    
			//=========================================
			//
			//=========================================
			
					SELECT MAX(DOC_ID)+1 
							INTO :LVL_DOC_ID
						  FROM ICOM_DOCUMENT
						WHERE ORGANIZATION_ID  = :GVI_ORGANIZATION_ID ;
						
						IF F_SQL_CHECK() < 0 THEN 
							RETURN
						END IF
						
						  INSERT INTO "ICOM_DOCUMENT"  
								( DOC_ID,   
								  DOC_CODE,   
								  ORGANIZATION_ID,   
								  DOC_GROUP,   
								  DOC_FILE_NAME,   
								  DOC_NAME,   
								  DOC_KEYWORD,   
								  DOC_COMMENT,   
								 // DOC_IMAGE,   
								  ENTER_DATE,   
								  ENTER_BY,   
								  LAST_MODIFY_DATE,   
								  LAST_MODIFY_BY,   
								  MODEL_NAME,   
								  LINE_CODE,   
								  WORKSTAGE_CODE,   
								  MACHINE_CODE,   
								  DATESET,   
								  DATEEND )  
					  VALUES ( :LVL_DOC_ID,   
								  'WORKORDER' , //DOC_CODE,   
								  :GVI_ORGANIZATION_ID , //ORGANIZATION_ID,   
								  NULL , //DOC_GROUP,   
								  NULL , //DOC_FILE_NAME,   
								  NULL , //, //DOC_NAME,   
								  NULL , //, //DOC_KEYWORD,   
								  NULL , //, //DOC_COMMENT,   
								  //DOC_IMAGE,   
								  SYSDATE  , //ENTER_DATE,   
								  :GVS_USER_ID , //ENTER_BY,   
								  SYSDATE , //LAST_MODIFY_DATE,   
								  :GVS_USER_ID , //LAST_MODIFY_BY,   
								  NULL , //MODEL_NAME,   
								  NULL , //LINE_CODE,   
								  NULL , //WORKSTAGE_CODE,   
								  NULL , //MACHINE_CODE,   
								  NULL , //DATESET,   
								  NULL  //DATEEND 
								 )  ;
			
						IF F_SQL_CHECK() < 0 THEN 
							RETURN
						END IF			
						
			//========================================
			//
			//========================================
			
			//$$HEX8$$08cd30ae54d67cb920005cd5e4b22000$$ENDHEX$$
			UPDATE ICOM_DOCUMENT 
				  SET DOC_IMAGE              =   EMPTY_BLOB()
			WHERE DOC_ID                     = :LVL_DOC_ID
				AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
			
			//$$HEX8$$c5c55cb8dcb47cb920005cd5e4b22000$$ENDHEX$$
			UPDATEBLOB  ICOM_DOCUMENT 
					SET Doc_image = :lib_file 
				WHERE DOC_ID     = :LVL_DOC_ID
					AND organization_id = :gvi_organization_id ;
			
			IF f_sql_check() < 0 THEN 
				RETURN
			END IF
			//========================================
			// $$HEX5$$0cd37cc785ba44c72000$$ENDHEX$$Update $$HEX3$$5cd5e4b22000$$ENDHEX$$
			//========================================

			lvi_pos1 =  POS( is_filename , '_' , 1 )
			lvi_pos2 =  POS( is_filename , '_' , lvi_pos1+1  )
			lvi_pos3 =  POS( is_filename , '.' , 1  )
			
			
			lvs_line_code            =   MID( is_filename , 1,  lvi_pos1 - 1 ) 
			lvs_workstage_code  =   MID( is_filename , lvi_pos1 +1 ,   lvi_pos2 -  (lvi_pos1+1)    ) 
			lvs_model_name               =   MID( is_filename , lvi_pos2 +1  , lvi_pos3 -  (lvi_pos2+1)  ) 
			
			//=========================================
				UPDATE  ICOM_DOCUMENT 
				SET  Doc_file_name = :is_filename ,
						 Last_modify_date = sysdate ,
						line_code = :lvs_line_code ,
						workstage_code = :lvs_workstage_code ,
						model_name = :lvs_model_name 	
				WHERE DOC_ID      = :LVL_DOC_ID
				AND organization_id = :gvi_organization_id ;
				
				IF f_sql_check() < 0 THEN 
					RETURN
				END IF				
			
				IF sqlca.sqlnrows > 0 THEN
					F_MSG_MDI_HELP( f_msg_st(9022) ) 
				ELSE
					f_msgbox1( 157 , is_filename )   //("error" , is_filename+"file upload to database failed" )
				END IF;				
			
			END IF

loop until j =  upperbound(ls_docname) 

COMMIT ;
F_RETRIEVE()

//INT    li_filenum , loops, i , lvi_count , J
//LONG   flen, bytes_read , bytes_read_sum , new_pos 
//BLOB   lib_file , b
//string is_filename, is_fullname , LVS_DOC_CODE , lvs_line_code , lvs_workstage_code , lvs_model_name  
//string ls_docpath , ls_docname[]
//
//
//IF GetFileOpenName("Select File", ls_docpath, ls_docname[], "ALL",  "All Files(*.*), *.*", "C:\", 18) < 1 THEN RETURN 
//
//do
//	J++
//
//				f_insert()
//				dw_1.scrolltorow(lvl_row)
//				
//				IF  dw_1.getrow() < 1 THEN 
//					RETURN
//				END IF
//				
//				LVS_DOC_CODE = STRING(dw_1.OBJECT.DOC_ID[lvl_row])
//				
//				IF  isnull(LVS_DOC_CODE) THEN 
//					RETURN
//				END IF
//
//			    f_update()
//				 
//				 
//			   if  upperbound(ls_docname[]) = 1 then 
//					 is_fullname =  ls_docpath
//				else
//				 
//           	      is_fullname =  ls_docpath+"\"+ls_docname[J]
//					  
//				end if 
//				
//				flen = 0 
//				flen = filelength(is_fullname)
//	
//				IF flen < 0 THEN 
//					f_msgbox1(9020 ,is_fullname ) 	//("error" , is_fullname+" file length unknown")
//					RETURN 
//				END IF
//				
//				li_filenum = fileopen(is_fullname,  streammode!, READ!, lockread!)
//				
//				IF li_filenum <> -1 THEN
//				
//						setpointer(hourglass!)
//						loops = 0 
//						
//						if flen > 32765 then
//						
//								  if mod(flen, 32765) = 0 then
//										loops = flen/32765
//								  else
//										loops = (flen/32765) + 1
//								  end if
//						else
//								  loops = 1
//						end if
//						
//						
//						SETNULL(lib_file)
//				         SETNULL(b)
//						bytes_read = 0 
//						new_pos = 1
//						
//						for i = 1 to loops
//								  bytes_read = fileread(li_filenum, b)
//								  bytes_read_sum = bytes_read_sum + bytes_read
//								  lib_file = lib_file + b
//								  f_msg_mdi_help( string(bytes_read_sum)+"/"+string(flen)+" bytes read" )
//						next
//						
//						fileclose(li_filenum)
//									
//	
//				
//				//=========================================
//				//
//				//=========================================
//				
//				
//					SELECT count(*) INTO :lvi_count
//					  FROM ICOM_DOCUMENT
//					WHERE DOC_ID  = :LVS_DOC_CODE 
//						AND organization_id = :gvi_organization_id ;
//				
//					IF f_sql_check() < 0 THEN 	RETURN
//				
//					IF lvi_count = 0 THEN 
//						f_msgbox1( 9021 , is_filename ) 	//("error", is_filename+" file name not found !" )
//						RETURN
//					END IF
//					
//					
//				//========================================
//				//
//				//========================================
//				
//				//$$HEX8$$08cd30ae54d67cb920005cd5e4b22000$$ENDHEX$$
//				UPDATE ICOM_DOCUMENT 
//					  SET DOC_IMAGE              =   EMPTY_BLOB()
//				WHERE DOC_ID                     = :LVS_DOC_CODE
//					AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
//				
//				//$$HEX8$$c5c55cb8dcb47cb920005cd5e4b22000$$ENDHEX$$
//				UPDATEBLOB  ICOM_DOCUMENT 
//						SET Doc_image = :lib_file 
//					WHERE DOC_ID     = :LVS_DOC_CODE
//						AND organization_id = :gvi_organization_id ;
//				
//				IF f_sql_check() < 0 THEN 
//					RETURN
//				END IF
//				//========================================
//				// $$HEX5$$0cd37cc785ba44c72000$$ENDHEX$$Update $$HEX3$$5cd5e4b22000$$ENDHEX$$
//						//========================================
//						int lvi_pos1 , lvi_pos2 , lvi_pos3
//						lvi_pos1 =  POS( is_filename , '_' , 1 )
//						lvi_pos2 =  POS( is_filename , '_' , lvi_pos1+1  )
//						lvi_pos3 =  POS( is_filename , '.' , 1  )
//						
//				
//						lvs_line_code            =   MID( is_filename , 1,  lvi_pos1 - 1 ) 
//						lvs_workstage_code  =   MID( is_filename , lvi_pos1 +1 ,   lvi_pos2 -  (lvi_pos1+1)    ) 
//						lvs_model_name               =   MID( is_filename , lvi_pos2 +1  , lvi_pos3 -  (lvi_pos2+1)  ) 
//						
//						//=========================================
//						UPDATE  ICOM_DOCUMENT 
//						SET  Doc_file_name = :is_filename ,
//								 Last_modify_date = sysdate ,
//								line_code = :lvs_line_code ,
//								workstage_code = :lvs_workstage_code ,
//								model_name = :lvs_model_name 	
//						WHERE DOC_ID      = :LVS_DOC_CODE
//						AND organization_id = :gvi_organization_id ;
//						
//						IF f_sql_check() < 0 THEN 
//							RETURN
//						END IF				
//						
//						IF sqlca.sqlnrows > 0 THEN
//							F_MSG_MDI_HELP( f_msg_st(9022) ) 
//						ELSE
//							f_msgbox1( 157 , is_filename )   //("error" , is_filename+"file upload to database failed" )
//						END IF;				
//				
//
//				
//
//				END IF
//loop until i = upperbound(ls_docname)
//				COMMIT ;
//				
//	F_RETRIEVE()
//
////changedirectory(gvs_default_directory)
end event

type cb_4 from so_commandbutton within w_com_document_master
integer x = 5042
integer y = 96
integer height = 136
integer taborder = 60
boolean bringtotop = true
string text = "Sync"
end type

event clicked;call super::clicked;long  i , j  , LVI_COUNT , LVL_ID
string lvs_workstage_code , LVS_ITEM  
BLOB lib_file

DECLARE CL1 CURSOR FOR 
  SELECT ITEM_CODE FROM TABLE1 
  where ITEM_CODE NOT IN ( SELECT MODEL_NAME FROM ICOM_DOCUMENT ) 
   ;

		
OPEN CL1 ;

i = 0 
DO

	I++
	LVS_ITEM = ''
	FETCH CL1 INTO :LVS_ITEM  ;
	
	IF LVS_ITEM = '' THEN 
		CLOSE CL1 ;
		EXIT 
	END IF 
	
	IF SQLCA.SQLCODE < 0 THEN 
		MESSAGEBOX("ERROR" , SQLCA.SQLERRTEXT) 
		CLOSE CL1 ;
		EXIT
	END IF 

	LVI_COUNT = 0
	J = 0 
						
	DO
		
		J++
			lvs_workstage_code = 'W'+STRING(J,'00')
			
		    LVI_COUNT = 0 
			SELECT COUNT(*) INTO :LVI_COUNT 
			 FROM ICOM_DOCUMENT
			WHERE MODEL_NAME = :LVS_ITEM
			    AND WORKSTAGE_CODE = :lvs_workstage_code ;
				 
			IF LVI_COUNT > 0 THEN 
				CONTINUE  
			ELSE
	
				//================================================
				//
				//================================================
				
				SELECT MAX(DOC_ID) +1 
						INTO :LVL_ID
					  FROM ICOM_DOCUMENT
					WHERE ORGANIZATION_ID  = :GVI_ORGANIZATION_ID ;
				
				IF F_SQL_CHECK() < 0 THEN 
					RETURN
				END IF
PARENT.TITLE   = '6'				
				INSERT INTO "ICOM_DOCUMENT"  
								( DOC_ID,   
								  DOC_CODE,   
								  ORGANIZATION_ID,   
								  DOC_GROUP,   
								  DOC_FILE_NAME,   
								  DOC_NAME,   
								  DOC_KEYWORD,   
								  DOC_COMMENT,   
								 // DOC_IMAGE,   
								  ENTER_DATE,   
								  ENTER_BY,   
								  LAST_MODIFY_DATE,   
								  LAST_MODIFY_BY,   
								  MODEL_NAME,   
								  LINE_CODE,   
								  WORKSTAGE_CODE,   
								  MACHINE_CODE,   
								  DATESET,   
								  DATEEND )  
			  
								  
					  VALUES ( :LVL_ID,   
								  'WORKORDER' , //DOC_CODE,   
								  :GVI_ORGANIZATION_ID , //ORGANIZATION_ID,   
								  'COPY' , //DOC_GROUP,   
								 '009_'||:lvs_workstage_code||'_'||:lvs_item||'.ppsx' , //DOC_FILE_NAME,   
								  NULL , //, //DOC_NAME,   
								  NULL , //, //DOC_KEYWORD,   
								  NULL , //, //DOC_COMMENT,   
								  //DOC_IMAGE,   
								  SYSDATE  , //ENTER_DATE,   
								  :GVS_USER_ID , //ENTER_BY,   
								  SYSDATE , //LAST_MODIFY_DATE,   
								  :GVS_USER_ID , //LAST_MODIFY_BY,   
								  :lvs_item , //MODEL_NAME,   
								  '009' , //LINE_CODE,   
								  :lvs_workstage_code , //WORKSTAGE_CODE,   
								  NULL , //MACHINE_CODE,   
								  NULL , //DATESET,   
								  NULL  //DATEEND 
								 )  ;
			
						IF F_SQL_CHECK() < 0 THEN 
							RETURN
						END IF		
								
PARENT.TITLE = '7'								
							SELECTBLOB DOC_IMAGE INTO :lib_file	
							 FROM ICOM_DOCUMENT
							WHERE DOC_ID = :J + 10 ;
							
							IF f_sql_check() < 0 THEN 
								RETURN
							END IF					
						
PARENT.TITLE = '8'							
							UPDATE ICOM_DOCUMENT 
							SET DOC_IMAGE              =   EMPTY_BLOB()
							WHERE DOC_ID                     = :LVL_ID
							AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
							IF f_sql_check() < 0 THEN 
								RETURN
							END IF					
PARENT.TITLE = '9'							
							//$$HEX8$$c5c55cb8dcb47cb920005cd5e4b22000$$ENDHEX$$
							UPDATEBLOB  ICOM_DOCUMENT 
								SET Doc_image = :lib_file 
							WHERE DOC_ID     = :LVL_ID
								AND organization_id = :gvi_organization_id ;
							
							IF f_sql_check() < 0 THEN 
								RETURN
							END IF					

					END IF 
		LOOP UNTIL J = 9
		
		this.text = STRING(I) 
	//	COMMIT ;
	LOOP UNTIL 1= 2 		
messagebox("End" , "end" )	
	CLOSE CL1 ;

end event

type sle_model_name from so_singlelineedit within w_com_document_master
integer x = 46
integer y = 168
integer width = 608
integer taborder = 40
boolean bringtotop = true
end type

type st_3 from so_statictext within w_com_document_master
integer x = 46
integer y = 76
integer width = 608
boolean bringtotop = true
integer weight = 700
string text = "Part No"
end type

type gb_1 from so_groupbox within w_com_document_master
integer width = 2414
integer height = 288
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_com_document_master
integer x = 2459
integer width = 2555
integer height = 288
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

