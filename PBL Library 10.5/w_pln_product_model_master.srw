HA$PBExportHeader$w_pln_product_model_master.srw
$PBExportComments$$$HEX17$$b9c278c7d0c658c7a8ba78b3d0c5200000b35cd52000b9d231c144c7200000adacb9$$ENDHEX$$
forward
global type w_pln_product_model_master from w_main_root
end type
type st_mrm_no from statictext within w_pln_product_model_master
end type
type sle_model_name from so_singlelineedit within w_pln_product_model_master
end type
type cb_1 from so_commandbutton within w_pln_product_model_master
end type
type cb_delete from so_commandbutton within w_pln_product_model_master
end type
type cb_show from so_commandbutton within w_pln_product_model_master
end type
type rb_master from so_radiobutton within w_pln_product_model_master
end type
type rb_2 from so_radiobutton within w_pln_product_model_master
end type
type em_version from so_editmask within w_pln_product_model_master
end type
type st_1 from so_statictext within w_pln_product_model_master
end type
type tab_1 from tab within w_pln_product_model_master
end type
type tabpage_1 from userobject within tab_1
end type
type dw_6 from so_datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_6 dw_6
end type
type tabpage_2 from userobject within tab_1
end type
type dw_7 from so_datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_7 dw_7
end type
type tabpage_3 from userobject within tab_1
end type
type dw_8 from so_datawindow within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_8 dw_8
end type
type tab_1 from tab within w_pln_product_model_master
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
type cb_2 from so_commandbutton within w_pln_product_model_master
end type
type st_2 from statictext within w_pln_product_model_master
end type
type ddlb_customer_code from uo_customer_code_name within w_pln_product_model_master
end type
type sle_item_code from so_singlelineedit within w_pln_product_model_master
end type
type st_3 from statictext within w_pln_product_model_master
end type
type sle_master_model_name from so_singlelineedit within w_pln_product_model_master
end type
type st_4 from statictext within w_pln_product_model_master
end type
type st_5 from statictext within w_pln_product_model_master
end type
type uo_dateend from uo_ymd_calendar within w_pln_product_model_master
end type
type gb_1 from so_groupbox within w_pln_product_model_master
end type
type gb_2 from so_groupbox within w_pln_product_model_master
end type
type gb_5 from so_groupbox within w_pln_product_model_master
end type
end forward

global type w_pln_product_model_master from w_main_root
integer width = 5509
integer height = 2952
string title = ""
st_mrm_no st_mrm_no
sle_model_name sle_model_name
cb_1 cb_1
cb_delete cb_delete
cb_show cb_show
rb_master rb_master
rb_2 rb_2
em_version em_version
st_1 st_1
tab_1 tab_1
cb_2 cb_2
st_2 st_2
ddlb_customer_code ddlb_customer_code
sle_item_code sle_item_code
st_3 st_3
sle_master_model_name sle_master_model_name
st_4 st_4
st_5 st_5
uo_dateend uo_dateend
gb_1 gb_1
gb_2 gb_2
gb_5 gb_5
end type
global w_pln_product_model_master w_pln_product_model_master

on w_pln_product_model_master.create
int iCurrent
call super::create
this.st_mrm_no=create st_mrm_no
this.sle_model_name=create sle_model_name
this.cb_1=create cb_1
this.cb_delete=create cb_delete
this.cb_show=create cb_show
this.rb_master=create rb_master
this.rb_2=create rb_2
this.em_version=create em_version
this.st_1=create st_1
this.tab_1=create tab_1
this.cb_2=create cb_2
this.st_2=create st_2
this.ddlb_customer_code=create ddlb_customer_code
this.sle_item_code=create sle_item_code
this.st_3=create st_3
this.sle_master_model_name=create sle_master_model_name
this.st_4=create st_4
this.st_5=create st_5
this.uo_dateend=create uo_dateend
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_5=create gb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_mrm_no
this.Control[iCurrent+2]=this.sle_model_name
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.cb_delete
this.Control[iCurrent+5]=this.cb_show
this.Control[iCurrent+6]=this.rb_master
this.Control[iCurrent+7]=this.rb_2
this.Control[iCurrent+8]=this.em_version
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.tab_1
this.Control[iCurrent+11]=this.cb_2
this.Control[iCurrent+12]=this.st_2
this.Control[iCurrent+13]=this.ddlb_customer_code
this.Control[iCurrent+14]=this.sle_item_code
this.Control[iCurrent+15]=this.st_3
this.Control[iCurrent+16]=this.sle_master_model_name
this.Control[iCurrent+17]=this.st_4
this.Control[iCurrent+18]=this.st_5
this.Control[iCurrent+19]=this.uo_dateend
this.Control[iCurrent+20]=this.gb_1
this.Control[iCurrent+21]=this.gb_2
this.Control[iCurrent+22]=this.gb_5
end on

on w_pln_product_model_master.destroy
call super::destroy
destroy(this.st_mrm_no)
destroy(this.sle_model_name)
destroy(this.cb_1)
destroy(this.cb_delete)
destroy(this.cb_show)
destroy(this.rb_master)
destroy(this.rb_2)
destroy(this.em_version)
destroy(this.st_1)
destroy(this.tab_1)
destroy(this.cb_2)
destroy(this.st_2)
destroy(this.ddlb_customer_code)
destroy(this.sle_item_code)
destroy(this.st_3)
destroy(this.sle_master_model_name)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.uo_dateend)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_5)
end on

event activate;call super::activate;/***************************************
* Window Default Property 
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20051101'
Gst_set.last_modify_date = '20051101'
Gst_set.Report_window    = False  // Report Window  True / Flase

/*****************************************
* Data Window Property
******************************************/
Ivs_resize_type                      = 'MASTER_DETAIL_TAB'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

/****************************************
*  Menu Property
*****************************************
* ADMIN  ( All Control )
* MANAGE ( Manager )
* GUEST  ( Only Query )
* QUERY  ( Only Query  )
* DATA_CONTROL  ( Insert Delete Update )
* REPORT ( Report )
****************************************/
F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control




end event

event ue_post_open;call super::ue_post_open;IF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_TAB' THEN //12345_TAB
	
	dw_1.resize(width - dw_1.x -34, height - ( dw_1.y + tab_1.height +120 ))
	dw_2.resize(width - dw_2.x -34, height - ( dw_2.y + tab_1.height +120 ))	
	dw_3.resize(width - dw_3.x -34, height - ( dw_3.y + tab_1.height +120))	
	dw_4.resize(width - dw_4.x -34, height - ( dw_4.y + tab_1.height +120))		
	dw_5.resize(width - dw_5.x -34, height - ( dw_5.y + tab_1.height +120))	
	
	tab_1.y = dw_1.y + dw_1.HEIGHT
	tab_1.resize(width - tab_1.x -34, tab_1.height )	
	
	tab_1.tabpage_1.dw_6.width = tab_1.tabpage_1.width - 50
	tab_1.tabpage_1.dw_6.height = tab_1.tabpage_1.height - 50
	tab_1.tabpage_2.dw_7.width = tab_1.tabpage_2.width - 50
	tab_1.tabpage_2.dw_7.height = tab_1.tabpage_2.height - 50	
	
	tab_1.tabpage_3.dw_8.width = tab_1.tabpage_2.width - 50	
	tab_1.tabpage_3.dw_8.height = tab_1.tabpage_2.height - 50	
END IF	  
/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

event ue_data_control;call super::ue_data_control;Long ROW
STRING LVS_SETYN

CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		
		if rb_master.checked = true then 
		     dw_1.reset()
			dw_1.RETRIEVE(  sle_model_name.text+'%' ,  ddlb_customer_code.getcode( )+'%' ,  sle_item_code.text +'%' ,  sle_master_model_name.text+'%' , GVI_ORGANIZATION_ID, uo_dateend.text() )
			dw_1.SETFOCUS()
		else
		     dw_3.reset()
			dw_3.RETRIEVE(  sle_model_name.text+'%' ,GVI_ORGANIZATION_ID )
			dw_3.SETFOCUS()			
		end if 
		
	CASE 'INSERT'
		
			
			if tab_1.selectedtab = 1 then 
		
					row = tab_1.tabpage_1.dw_6.insertrow(tab_1.tabpage_1.dw_6.getrow())
					tab_1.tabpage_1.dw_6.scrolltorow(row)
					f_set_security_row(tab_1.tabpage_1.dw_6 , row , 'ALL')
					F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
				
			else
					row = tab_1.tabpage_2.dw_7.insertrow(tab_1.tabpage_2.dw_7.getrow())
					tab_1.tabpage_2.dw_7.scrolltorow(row)
					f_set_security_row(tab_1.tabpage_2.dw_7 , row , 'ALL')
					F_MSG_MDI_HELP ( F_MSG_ST(152)	 )				
				
			end if 
			
	CASE 'APPEND'
		
					if tab_1.selectedtab = 1 then 
				
						row = tab_1.tabpage_1.dw_6.insertrow(0)
						tab_1.tabpage_1.dw_6.scrolltorow(row)
						f_set_security_row(tab_1.tabpage_1.dw_6 , row , 'ALL')
						F_MSG_MDI_HELP ( F_MSG_ST(152)	 )	
						
					else
						row = tab_1.tabpage_2.dw_7.insertrow(0)
						tab_1.tabpage_2.dw_7.scrolltorow(row)
						f_set_security_row(tab_1.tabpage_2.dw_7 , row , 'ALL')
						F_MSG_MDI_HELP ( F_MSG_ST(152)	 )							
						
						
					end if ;
	CASE 'DELETE'
		
					if tab_1.selectedtab = 1 then 		
		
					
						if tab_1.tabpage_1.dw_6.getrow() < 1 then return 
						  
						msg =f_msgbox(1003)
						if msg = 1 then
							gvl_row_deleted = tab_1.tabpage_1.dw_6.getrow()			
							tab_1.tabpage_1.dw_6.deleterow(gvl_row_deleted)		
							tab_1.tabpage_1.dw_6.setfocus()
							row = tab_1.tabpage_1.dw_6.getrow()
							tab_1.tabpage_1.dw_6.scrolltorow(row)
							tab_1.tabpage_1.dw_6.setcolumn(1)
						end if
					else
						if tab_1.tabpage_2.dw_7.getrow() < 1 then return 
						  
						msg =f_msgbox(1003)
						if msg = 1 then
							gvl_row_deleted =tab_1.tabpage_2.dw_7.getrow()			
							tab_1.tabpage_2.dw_7.deleterow(gvl_row_deleted)		
							tab_1.tabpage_2.dw_7.setfocus()
							row =tab_1.tabpage_2.dw_7.getrow()
							tab_1.tabpage_2.dw_7.scrolltorow(row)
							tab_1.tabpage_2.dw_7.setcolumn(1)
						end if						
						
					end if ; 			
	CASE 'UPDATE'
		
		tab_1.tabpage_1.dw_6.ACCEPTTEXT()
 
	      IF tab_1.tabpage_1.dw_6.UPDATE() < 0 or  tab_1.tabpage_2.dw_7.UPDATE() < 0 THEN
				F_MSG_MDI_HELP (  'UPDATE FAILED' ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
				ROLLBACK;
				RETURN
		ELSE
				 COMMIT;
       			 F_MSG_MDI_HELP ( F_MSG_ST(170)	 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
		END IF

	CASE ELSE
END CHOOSE


end event

event open;call super::open;//========================================
// Set Transaction
//========================================

if Gvs_simple_model_master_yn = 'Y' then 
	
	tab_1.tabpage_1.dw_6.dataobject = 'd_pln_product_model_master_simple_mst'
	tab_1.tabpage_1.dw_6.settransobject( sqlca)
	f_dual_lang_change_dwtext(tab_1.tabpage_1.dw_6)
	
else
	tab_1.tabpage_1.dw_6.settransobject( sqlca)
end if 


tab_1.tabpage_2.dw_7.settransobject( sqlca)
tab_1.tabpage_3.dw_8.settransobject( sqlca)

//========================================
// dddw Init
//========================================
f_set_column_dddw( tab_1.tabpage_1.dw_6 )
f_set_column_dddw( tab_1.tabpage_2.dw_7 )
f_set_column_dddw( tab_1.tabpage_3.dw_8 )

//========================================
// Share Data
//========================================

tab_1.tabpage_1.dw_6.sharedata( tab_1.tabpage_3.dw_8 )

end event

event resize;call super::resize;tab_1.tabpage_1.dw_6.width = tab_1.tabpage_1.width - 50
tab_1.tabpage_1.dw_6.height = tab_1.tabpage_1.height - 50

tab_1.tabpage_2.dw_7.width = tab_1.tabpage_2.width - 50
tab_1.tabpage_2.dw_7.height = tab_1.tabpage_2.height - 50
end event

type dw_5 from w_main_root`dw_5 within w_pln_product_model_master
integer y = 316
end type

type dw_4 from w_main_root`dw_4 within w_pln_product_model_master
integer y = 316
end type

type dw_3 from w_main_root`dw_3 within w_pln_product_model_master
integer x = 5
integer y = 316
integer width = 4544
integer height = 456
boolean titlebar = true
string title = "Document"
string dataobject = "d_pln_product_model_master_doc_lst"
end type

type dw_2 from w_main_root`dw_2 within w_pln_product_model_master
integer x = 5
integer y = 316
integer width = 4581
integer height = 1088
boolean titlebar = true
borderstyle borderstyle = styleraised!
end type

type dw_1 from w_main_root`dw_1 within w_pln_product_model_master
integer x = 5
integer y = 316
integer width = 4599
integer height = 1088
boolean titlebar = true
string title = "Product Model List"
string dataobject = "d_pln_product_model_master_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
tab_1.tabpage_1.dw_6.retrieve( this.object.model_name[currentrow])
tab_1.tabpage_2.dw_7.retrieve( this.object.model_name[currentrow] , GVI_ORGANIZATION_ID )
end event

type uo_tabpages from w_main_root`uo_tabpages within w_pln_product_model_master
end type

type st_mrm_no from statictext within w_pln_product_model_master
integer x = 1289
integer y = 88
integer width = 603
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Model Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_model_name from so_singlelineedit within w_pln_product_model_master
integer x = 1289
integer y = 180
integer width = 603
integer taborder = 30
boolean bringtotop = true
end type

type cb_1 from so_commandbutton within w_pln_product_model_master
integer x = 4151
integer y = 52
integer height = 112
integer taborder = 20
boolean bringtotop = true
string text = "Document Attatch"
end type

event clicked;call super::clicked;INT    LI_FILENUM , LOOPS, I , LVI_COUNT
LONG   FLEN, BYTES_READ , BYTES_READ_SUM , NEW_POS
BLOB   LIB_FILE , B
STRING IS_FILENAME, IS_FULLNAME , LVS_MODEL_NAME , LVS_ITEM_CODE
DOUBLE LVI_VERSION

IF  DW_1.GETROW() < 1 THEN 
	 RETURN
END IF

LVS_MODEL_NAME = DW_1.GETITEMSTRING( DW_1.GETROW() , "MODEL_NAME" )
LVI_VERSION        =  	Integer(em_version.text)

IF LVS_MODEL_NAME ='' OR ISNULL(LVS_MODEL_NAME) THEN 
	RETURN
END IF


IF GETFILEOPENNAME("SELECT FILE", &
	 IS_FULLNAME, IS_FILENAME, "PDF", &
	 + "PDF FILES (*.PDF),*.PDF," &
	 + "XLS FILES (*.XLS),*.XLS," &
	 + "DOC FILES (*.DOC),*.DOC," &			 
	 + "ALL FILES (*.*), *.*") < 1 THEN RETURN

FLEN = FILELENGTH(IS_FULLNAME)

IF FLEN < 0 THEN 
	CHANGEDIRECTORY(GVS_DEFAULT_DIRECTORY)		
	F_MSGBOX1(9020 ,IS_FULLNAME )
	RETURN 
END IF



//=======================================================
//
//=======================================================
  INSERT INTO "IP_PRODUCT_SPEC_CONFIRM_DOC"  
         ( "MODEL_NAME",   
           "LST_CONFIRM_DATE",   
           "VERSION",   
           "RECEIPT_DATE",   
           "ORGANIZATION_ID",   
           "ENTER_DATE",   
           "ENTER_BY",   
           "LAST_MODIFY_DATE",   
           "LAST_MODIFY_BY",   
           "DOCUMENT_NAME" )  
  VALUES ( :lvs_model_name , trunc(sysdate) , :lvi_version , sysdate ,  :gvi_organization_id , sysdate , :gvs_user_id , sysdate , :gvs_user_id ,:IS_FILENAME )  ;

if f_sql_check() < 0 then 
	return
end if 

//=======================================================

LI_FILENUM = FILEOPEN(IS_FULLNAME,  STREAMMODE!, READ!, LOCKREAD!)

IF LI_FILENUM <> -1 THEN
		
			SETPOINTER(HOURGLASS!)					
			IF FLEN > 32765 THEN
			
					  IF MOD(FLEN, 32765) = 0 THEN
							LOOPS = FLEN/32765
					  ELSE
							LOOPS = (FLEN/32765) + 1
					  END IF
			ELSE
					  LOOPS = 1
			END IF
			
			NEW_POS = 1
			FOR I = 1 TO LOOPS
					  BYTES_READ = FILEREAD(LI_FILENUM, B)
					  BYTES_READ_SUM = BYTES_READ_SUM + BYTES_READ
					  LIB_FILE = LIB_FILE + B
					  F_MSG_MDI_HELP( STRING(BYTES_READ_SUM)+"/"+STRING(FLEN)+" BYTES READ" )
			NEXT
			
			FILECLOSE(LI_FILENUM)
			SELECT COUNT(*) INTO :LVI_COUNT
			  FROM IP_PRODUCT_SPEC_CONFIRM_DOC
			 WHERE MODEL_NAME       = :LVS_MODEL_NAME 
				AND VERSION               = :LVI_VERSION
				AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
				  
			IF F_SQL_CHECK() < 0 THEN 
				CHANGEDIRECTORY(GVS_DEFAULT_DIRECTORY)		
				RETURN
			END IF				  
			
			IF LVI_COUNT = 0 THEN 
				CHANGEDIRECTORY(GVS_DEFAULT_DIRECTORY)		 
				F_MSGBOX1( 9021 , IS_FILENAME ) 
				//("ERROR", IS_FILENAME+" FILE NAME NOT FOUND !" )
				RETURN
			END IF
				  
			UPDATEBLOB IP_PRODUCT_SPEC_CONFIRM_DOC SET CONTENTS = :LIB_FILE 
			WHERE MODEL_NAME   = :LVS_MODEL_NAME 
				AND VERSION = :LVI_VERSION
				AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
				
			  IF F_SQL_CHECK() < 0 THEN 
				 CHANGEDIRECTORY(GVS_DEFAULT_DIRECTORY)		
				  RETURN
			  END IF						
				
			UPDATE IP_PRODUCT_SPEC_CONFIRM_DOC SET DOCUMENT_NAME = :IS_FILENAME 
			WHERE MODEL_NAME   = :LVS_MODEL_NAME 
				AND VERSION          = :LVI_VERSION
				AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;						
				
			  IF F_SQL_CHECK() < 0 THEN 
				  CHANGEDIRECTORY(GVS_DEFAULT_DIRECTORY)								
				  RETURN
			  END IF						
		
		  COMMIT ;
		  
		  IF SQLCA.SQLNROWS > 0 THEN
			  CHANGEDIRECTORY(GVS_DEFAULT_DIRECTORY)							
			  F_MSG_MDI_HELP( F_MSG_ST(9022) ) 
			  DW_1.RETRIEVE( DW_1.GETITEMSTRING( DW_1.GETROW(), 'MODEL_NAME' ) , GVI_ORGANIZATION_ID )
			  DW_1.SETFOCUS()							
		  ELSE
			  F_MSGBOX1( 157 , IS_FILENAME )   //("ERROR" , IS_FILENAME+"FILE UPLOAD TO DATABASE FAILED" )
			  
		  END IF;
END IF

CHANGEDIRECTORY(GVS_DEFAULT_DIRECTORY)		
end event

type cb_delete from so_commandbutton within w_pln_product_model_master
integer x = 4151
integer y = 172
integer height = 112
integer taborder = 30
boolean bringtotop = true
boolean enabled = false
string text = "Document Delete"
end type

event clicked;call super::clicked;STRING LVS_MODEL_NAME
INT LVI_VERSION

if dw_3.getrow() < 1 then return 

MSG = F_MSGBOX(1170)
IF MSG = 1 THEN 
ELSE
	RETURN
END IF 



LVS_MODEL_NAME = dw_3.object.model_name[dw_3.getrow()]

DELETE FROM IP_PRODUCT_SPEC_CONFIRM_DOC 
 WHERE MODEL_NAME = :LVS_MODEL_NAME 
     AND VERSION = :LVI_VERSION 
	AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	
IF F_SQL_CHECK() < 0 THEN
	RETURN 
END IF 

COMMIT ;
end event

type cb_show from so_commandbutton within w_pln_product_model_master
integer x = 4690
integer y = 56
integer width = 667
integer height = 112
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
string text = "Sow Document"
end type

event clicked;call super::clicked;if dw_3.getrow() < 1 then 
	return
end if

Long Lvl_return
String  lvs_file_name
if dw_3.getrow() < 1 then return 

Lvl_return =  f_download_spec_confirm_document ( String(dw_3.object.model_name[dw_3.getrow()]) , Double(dw_3.object.version[dw_3.getrow()] ) )

if  Lvl_return > 0 then 

	lvs_file_name = getcurrentdirectory()+"\Temp\"+dw_3.object.model_name[dw_3.getrow()] 
	
	IF lvs_file_name = '' OR ISNULL(lvs_file_name) THEN 
		RETURN
	END IF
	
	f_shell_execute_by_extention ( dw_3.object.document_name[dw_3.getrow()]  , '' , getcurrentdirectory()+'\Temp'  )
	
else
	
end if

end event

type rb_master from so_radiobutton within w_pln_product_model_master
integer x = 50
integer y = 80
boolean bringtotop = true
string text = "Model Master"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
selected_data_window= dw_1

cb_delete.enabled = false
cb_show.enabled = false
end event

type rb_2 from so_radiobutton within w_pln_product_model_master
integer x = 50
integer y = 180
boolean bringtotop = true
string text = "Document"
end type

event clicked;call super::clicked;dw_3.bringtotop = true
selected_data_window= dw_3

cb_delete.enabled = true
cb_show.enabled = true
end event

type em_version from so_editmask within w_pln_product_model_master
integer x = 3698
integer y = 172
integer height = 84
integer taborder = 30
boolean bringtotop = true
string text = "1"
end type

type st_1 from so_statictext within w_pln_product_model_master
integer x = 3698
integer y = 84
integer width = 402
integer height = 84
boolean bringtotop = true
string text = "Version"
end type

type tab_1 from tab within w_pln_product_model_master
integer x = 5
integer y = 1424
integer width = 4974
integer height = 1280
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean fixedwidth = true
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 4937
integer height = 1152
long backcolor = 12632256
string text = "Detail"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
dw_6 dw_6
end type

on tabpage_1.create
this.dw_6=create dw_6
this.Control[]={this.dw_6}
end on

on tabpage_1.destroy
destroy(this.dw_6)
end on

type dw_6 from so_datawindow within tabpage_1
integer y = 28
integer width = 4937
integer height = 1112
integer taborder = 40
string dataobject = "d_pln_product_model_master_mst"
borderstyle borderstyle = stylebox!
end type

event itemfocuschanged;call super::itemfocuschanged;this.object.help_msg.text  = f_get_dual_lang_text ( gvs_language ,  UPPER(dwo.name)+'_TAG_HELP')
end event

event itemchanged;call super::itemchanged;if dwo.name = 'model_name' then
	this.accepttext( )
	this.object.smt_model_name[row] = data
	this.object.master_model_name[row] = data
	if Gvs_simple_model_master_yn = 'Y' then 
	    this.object.customer_master_model_name[row] = data
	    this.object.master_spec[row] = data
	end if
	
elseif dwo.name = 'item_code' then
	this.accepttext( )	
	this.object.part_no[row] = data
end if 

end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 4937
integer height = 1152
long backcolor = 12632256
string text = "SW Version"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
dw_7 dw_7
end type

on tabpage_2.create
this.dw_7=create dw_7
this.Control[]={this.dw_7}
end on

on tabpage_2.destroy
destroy(this.dw_7)
end on

type dw_7 from so_datawindow within tabpage_2
integer y = 12
integer width = 4503
integer height = 996
integer taborder = 40
string dataobject = "d_smt_sw_lst"
borderstyle borderstyle = stylebox!
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 4937
integer height = 1152
long backcolor = 12632256
string text = "InterLock Option"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
dw_8 dw_8
end type

on tabpage_3.create
this.dw_8=create dw_8
this.Control[]={this.dw_8}
end on

on tabpage_3.destroy
destroy(this.dw_8)
end on

type dw_8 from so_datawindow within tabpage_3
integer y = 12
integer width = 4923
integer height = 1136
integer taborder = 40
string dataobject = "d_pln_product_model_master_4_interlock_mst"
end type

type cb_2 from so_commandbutton within w_pln_product_model_master
integer x = 4695
integer y = 160
integer width = 667
integer height = 112
integer taborder = 50
boolean bringtotop = true
string text = "Show BOM"
end type

event clicked;call super::clicked;string lvs_item_code

if dw_1.getrow() < 1 then return

lvs_item_code = dw_1.getitemstring( dw_1.getrow() , 'item_code' )
if lvs_item_code = '' or isnull(lvs_item_code) then return

openwithparm( w_des_bom_query_popup , lvs_item_code )
end event

type st_2 from statictext within w_pln_product_model_master
integer x = 658
integer y = 88
integer width = 631
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Customer Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_customer_code from uo_customer_code_name within w_pln_product_model_master
integer x = 658
integer y = 180
integer width = 631
integer height = 1808
integer taborder = 40
boolean bringtotop = true
end type

type sle_item_code from so_singlelineedit within w_pln_product_model_master
integer x = 1902
integer y = 180
integer width = 603
integer taborder = 40
boolean bringtotop = true
end type

type st_3 from statictext within w_pln_product_model_master
integer x = 1902
integer y = 88
integer width = 603
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Item Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_master_model_name from so_singlelineedit within w_pln_product_model_master
integer x = 2514
integer y = 180
integer width = 603
integer taborder = 50
boolean bringtotop = true
end type

type st_4 from statictext within w_pln_product_model_master
integer x = 2514
integer y = 88
integer width = 603
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Master Model Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_5 from statictext within w_pln_product_model_master
integer x = 3136
integer y = 88
integer width = 466
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Model DateEnd"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_dateend from uo_ymd_calendar within w_pln_product_model_master
event destroy ( )
integer x = 3163
integer y = 180
integer height = 88
integer taborder = 30
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type gb_1 from so_groupbox within w_pln_product_model_master
integer x = 622
integer width = 2994
integer height = 304
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_pln_product_model_master
integer x = 3639
integer width = 1751
integer height = 304
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_5 from so_groupbox within w_pln_product_model_master
integer x = 5
integer width = 603
integer height = 304
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

