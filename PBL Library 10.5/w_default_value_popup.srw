HA$PBExportHeader$w_default_value_popup.srw
$PBExportComments$$$HEX7$$08cd30ae12ac24c115c81dd3c5c5$$ENDHEX$$
forward
global type w_default_value_popup from w_popup_root
end type
type cb_apply from so_commandbutton within w_default_value_popup
end type
type cb_retrieve from so_commandbutton within w_default_value_popup
end type
type cb_extract from so_commandbutton within w_default_value_popup
end type
type sle_window_name from so_singlelineedit within w_default_value_popup
end type
type sle_datawindow from so_singlelineedit within w_default_value_popup
end type
type cb_2 from so_commandbutton within w_default_value_popup
end type
type st_1 from so_statictext within w_default_value_popup
end type
type st_2 from so_statictext within w_default_value_popup
end type
type cb_1 from so_commandbutton within w_default_value_popup
end type
type cb_3 from so_commandbutton within w_default_value_popup
end type
type cb_4 from so_commandbutton within w_default_value_popup
end type
type gb_2 from so_groupbox within w_default_value_popup
end type
type gb_1 from so_groupbox within w_default_value_popup
end type
end forward

global type w_default_value_popup from w_popup_root
integer width = 4069
integer height = 2252
string title = "Update Column Property"
cb_apply cb_apply
cb_retrieve cb_retrieve
cb_extract cb_extract
sle_window_name sle_window_name
sle_datawindow sle_datawindow
cb_2 cb_2
st_1 st_1
st_2 st_2
cb_1 cb_1
cb_3 cb_3
cb_4 cb_4
gb_2 gb_2
gb_1 gb_1
end type
global w_default_value_popup w_default_value_popup

type variables
DATAWINDOW ARG_DW
STRING IVS_WINDOW , IVS_DATAWINDOW

end variables

on w_default_value_popup.create
int iCurrent
call super::create
this.cb_apply=create cb_apply
this.cb_retrieve=create cb_retrieve
this.cb_extract=create cb_extract
this.sle_window_name=create sle_window_name
this.sle_datawindow=create sle_datawindow
this.cb_2=create cb_2
this.st_1=create st_1
this.st_2=create st_2
this.cb_1=create cb_1
this.cb_3=create cb_3
this.cb_4=create cb_4
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_apply
this.Control[iCurrent+2]=this.cb_retrieve
this.Control[iCurrent+3]=this.cb_extract
this.Control[iCurrent+4]=this.sle_window_name
this.Control[iCurrent+5]=this.sle_datawindow
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.cb_3
this.Control[iCurrent+11]=this.cb_4
this.Control[iCurrent+12]=this.gb_2
this.Control[iCurrent+13]=this.gb_1
end on

on w_default_value_popup.destroy
call super::destroy
destroy(this.cb_apply)
destroy(this.cb_retrieve)
destroy(this.cb_extract)
destroy(this.sle_window_name)
destroy(this.sle_datawindow)
destroy(this.cb_2)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.cb_3)
destroy(this.cb_4)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event open;call super::open;ARG_DW                  = MESSAGE.POWEROBJECTPARM
IVS_WINDOW          =  gst_return.gvs_return[1]
IVS_DATAWINDOW = gst_return.gvs_return[2]

SLE_WINDOW_NAME.TEXT= gst_return.gvs_return[1]
SLE_DATAWINDOW.TEXT= gst_return.gvs_return[2]
//==================================
//
//==================================

CB_EXTRACT.TRIGGEREVENT(CLICKED!)

end event

type p_title from w_popup_root`p_title within w_default_value_popup
integer width = 4055
end type

type cb_sort from w_popup_root`cb_sort within w_default_value_popup
integer x = 18
integer y = 2304
integer width = 352
end type

type cb_close from w_popup_root`cb_close within w_default_value_popup
boolean visible = true
integer x = 3648
integer y = 316
integer width = 352
end type

type st_msg from w_popup_root`st_msg within w_default_value_popup
boolean visible = true
integer y = 588
integer width = 4055
end type

type dw_1 from w_popup_root`dw_1 within w_default_value_popup
boolean visible = true
integer y = 680
integer width = 4055
integer height = 1472
boolean titlebar = true
string title = "Column Information"
string dataobject = "d_initial_value_popup"
end type

event dw_1::rbuttondown;call super::rbuttondown;String ls_dwhead , ls_dddw_col_name , lvs_initial_value_type
Int LVI_COUNT
if row < 1 then Return


lvs_initial_value_type = this.object.initial_value_type[row] 

if dwo.name = 'initial_value' then 
	
	if lvs_initial_value_type = 'NORMAL' then
		
		ls_dwhead =  this.object.column_name[row]
		ls_dddw_col_name = upper( f_replace_string(ls_dwhead,'_' , ' ') )
		
		SELECT COUNT(*) INTO :LVI_COUNT
		  FROM ISYS_BASECODE
		 WHERE CODE_TYPE = :ls_dddw_col_name
			  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
			  
		IF F_SQL_CHECK() < 0 THEN 
			RETURN
		END IF
		
		if lvi_count > 0 then 
			OpenWithParm(w_basecode_select_popup , ls_dddw_col_name)
		else
			OpenWithParm(w_basecode_select_popup ,'INITIAL VALUE')			
		end if
		
		if message.stringparm = '' then 
		else
			this.object.initial_value[row] = Message.stringParm
		end if
	
	elseif  lvs_initial_value_type = 'SEQUENCE' then
		
		Open(w_sequence_select_popup)
		
		if message.stringparm = '' then 
		else
			this.object.initial_value[row] = Message.stringParm
		end if		

	elseif  lvs_initial_value_type = 'FUNCTION' then
		
		Open(w_function_select_popup)
		
		if message.stringparm = '' then 
		else
			this.object.initial_value[row] = Message.stringParm
		end if		
		
	else
		Return 
	end if


end if
end event

type dw_2 from w_popup_root`dw_2 within w_default_value_popup
boolean visible = true
integer x = 9
integer y = 696
end type

type dw_3 from w_popup_root`dw_3 within w_default_value_popup
integer y = 696
end type

type cb_apply from so_commandbutton within w_default_value_popup
integer x = 2597
integer y = 428
integer width = 352
integer height = 100
integer taborder = 30
boolean bringtotop = true
string text = "Update"
end type

event clicked;Int i, J , lvi_count
String lvs_col_name, lvs_update_yn , LVS_FORMAT , lvs_editmask , lvs_visible_yn , lvs_width , lvs_column_order ,lvs_sparse_yn ,  lvs_sparse

MSG = F_MSGBOX1( 1161 , THIS.TEXT ) //@ $$HEX7$$7cb9200098ccacb960d54cae94c6$$ENDHEX$$?
IF MSG = 1 THEN 
	
	IF DW_1.UPDATE() < 0 THEN 
		ROLLBACK ;
		RETURN
	ELSE
		COMMIT ;
	     F_MSG_MDI_HELP(F_MSG_ST(170)) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"		
	END IF
	
ELSE
	RETURN 
END IF



end event

type cb_retrieve from so_commandbutton within w_default_value_popup
integer x = 2597
integer y = 316
integer width = 352
integer height = 100
integer taborder = 20
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;dw_1.retrieve(sle_window_name.text , sle_datawindow.text, gvi_organization_id  )

end event

type cb_extract from so_commandbutton within w_default_value_popup
integer x = 3296
integer y = 316
integer width = 352
integer height = 100
integer taborder = 30
boolean bringtotop = true
string text = "Extract"
end type

event clicked;dw_1.settransobject(sqlca)

String lvs_col_name , lvs_col_type
Integer lvi_count , I , Row

MSG = F_MSGBOX1( 1161 , THIS.TEXT ) //@ $$HEX7$$7cb9200098ccacb960d54cae94c6$$ENDHEX$$?
IF MSG = 1 THEN


			CB_RETRIEVE.TRIGGEREVENT(CLICKED!) 
			Gst_dw_colinfo.i_dw_colcount = 0
			Gst_dw_colinfo.i_dw_colcount=Integer(  arg_dw.Describe("DataWindow.Column.Count"))

			//======================================================================
			// Column Object $$HEX2$$7cb92000$$ENDHEX$$Scan $$HEX2$$5cd5e4b2$$ENDHEX$$
			//======================================================================
			Do
				i++
				lvs_col_name	= arg_dw.Describe('#'+String(I)+".Name")
				
				IF  UPPER(lvs_col_name) = "ORGANIZATION_ID"  or  UPPER(lvs_col_name) = 'ENTER_BY' or UPPER(lvs_col_name) = 'ENTER_DATE' or UPPER(lvs_col_name) = 'LAST_MODIFY_BY' or UPPER(lvs_col_name) = 'LAST_MODIFY_DATE' THEN
	                    CONTINUE
				END IF
                  					
					SELECT COUNT(*) INTO :LVI_COUNT 
					FROM isys_default_value 
					WHERE WINDOW_NAME     = UPPER(:IVS_WINDOW)
					AND DATAWINDOW_NAME = UPPER(:IVS_DATAWINDOW)
					AND COLUMN_NAME           = UPPER(:lvs_col_name)
					AND ORGANIZATION_ID     = :GVI_ORGANIZATION_ID ;
					
					IF F_SQL_CHECK() < 0 THEN 
						RETURN
					END IF				
				
				     IF LVI_COUNT > 0 THEN 
						CONTINUE
					END IF
				          
						IF arg_dw.describe (lvs_col_name + ".type") = "column" THEN 
							
							lvs_col_type = UPPER(arg_dw.Describe(lvs_col_name+".ColType"))
							
							Row = dw_1.InsertRow(0)
							F_SET_SECURITY_ROW(DW_1 ,  Row , 'ALL')
							
							dw_1.SetItem( Row,'window_name' , UPPER(ivs_window) )
							dw_1.SetItem( Row,'datawindow_name' ,UPPER( ivs_datawindow) )
							dw_1.SetItem( Row,'column_name',UPPER(lvs_col_name))
							dw_1.SetItem( Row,'column_type',  lvs_col_type )
							dw_1.SetItem( Row,'initial_value_type', 'NORMAL' )
							
							
							if arg_dw.Getrow() < 1 then 
							else
							
									if lvs_col_type = 'DATE'  or  lvs_col_type = 'DATETIME' then 
									elseif lvs_col_type = 'INT'  or lvs_col_type = 'NUMBER'  or lvs_col_type = 'LONG'  or lvs_col_type = 'ULONG'  or lvs_col_type = 'DOUBLE' or lvs_col_type = 'REAL'  then
										dw_1.SetItem( Row,'initial_value',  String(arg_dw.GetitemNumber( arg_dw.getrow() , lvs_col_name ))	 )
									elseif  UPPER(Mid(lvs_col_type,1,3))  = 'DEC' then 
										dw_1.SetItem( Row,'initial_value',  String(arg_dw.GetitemDecimal( arg_dw.getrow() , lvs_col_name ))	 )
									elseif  UPPER(Mid(lvs_col_type,1,4))  = 'CHAR' then 
										dw_1.SetItem( Row,'initial_value',  arg_dw.GetitemString( arg_dw.getrow() , lvs_col_name )	 )
									else
										Messagebox("Notify" , lvs_col_type +" This Type Not Support")
									end if							
									
								end if 
							
							IF Gvs_language = 'E' then 
								dw_1.SetItem( Row,'column_mean_eng',arg_dw.Describe(lvs_col_name+"_t.Text"))	
							ELSEIF Gvs_language = 'K' then 
								dw_1.SetItem( Row,'column_mean_kor',arg_dw.Describe(lvs_col_name+"_t.Text"))							
							ELSE
								dw_1.SetItem( Row,'column_mean_local',arg_dw.Describe(lvs_col_name+"_t.Text"))							
							END IF
							
						END IF
					Loop Until  I =  Gst_dw_colinfo.i_dw_colcount
END IF
end event

type sle_window_name from so_singlelineedit within w_default_value_popup
integer x = 46
integer y = 428
integer width = 1381
integer taborder = 50
boolean bringtotop = true
integer weight = 700
textcase textcase = upper!
end type

type sle_datawindow from so_singlelineedit within w_default_value_popup
integer x = 1431
integer y = 428
integer width = 553
integer taborder = 60
boolean bringtotop = true
integer weight = 700
textcase textcase = upper!
end type

type cb_2 from so_commandbutton within w_default_value_popup
integer x = 2944
integer y = 316
integer width = 352
integer height = 100
integer taborder = 30
boolean bringtotop = true
string text = "Reset"
end type

event clicked;MSG = F_MSGBOX1( 1161 , THIS.TEXT ) //@ $$HEX7$$7cb9200098ccacb960d54cae94c6$$ENDHEX$$?
IF MSG = 1 THEN 
	
	DELETE FROM ISYS_DEFAULT_VALUE
	  WHERE WINDOW_NAME         = UPPER(:IVS_WINDOW)
	      AND DATAWINDOW_NAME = UPPER(:IVS_DATAWINDOW)
		 AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
		
	 IF F_SQL_CHECK() < 0 THEN 	
		RETURN 
	END IF 
	
	COMMIT ;
	
	CB_RETRIEVE.TRIGGEREVENT(CLICKED!)
	
	F_MSG_MDI_HELP( F_MSG_ST(170) )
END IF 
end event

type st_1 from so_statictext within w_default_value_popup
integer x = 46
integer y = 356
integer width = 1381
integer height = 52
boolean bringtotop = true
integer weight = 700
string text = "Window Name"
end type

type st_2 from so_statictext within w_default_value_popup
integer x = 1431
integer y = 356
integer width = 553
integer height = 52
boolean bringtotop = true
integer weight = 700
string text = "Data Window Name"
end type

type cb_1 from so_commandbutton within w_default_value_popup
integer x = 2944
integer y = 428
integer width = 352
integer height = 100
integer taborder = 40
boolean bringtotop = true
string text = "Export"
end type

event clicked;call super::clicked;dw_1.SaveAs( Gvs_default_directory+'\isys_default_value.txt', TEXT!, True , EncodingUTF16LE! )
F_MSG_MDI_HELP( Gvs_default_directory+'\isys_default_value.txt' )
F_MSGBOX(170)
end event

type cb_3 from so_commandbutton within w_default_value_popup
integer x = 3296
integer y = 428
integer width = 352
integer height = 100
integer taborder = 20
boolean bringtotop = true
string text = "Verify Value"
end type

event clicked;call super::clicked;String lvs_initial_value_type , lvs_initial_value , lvs_return

lvs_initial_value_type = dw_1.object.initial_value_type[dw_1.getrow()]
lvs_initial_value  = dw_1.object.initial_value[dw_1.getrow()]

if lvs_initial_value_type	 = 'SEQUENCE' then
	lvs_return = String(f_get_sequence( lvs_initial_value ))
	Messagebox("Verify" , lvs_return )	
elseif lvs_initial_value_type	 = 'FUNCTION' then
	lvs_return = f_call_db_function( lvs_initial_value )
	Messagebox("Verify" , lvs_return )	
elseif lvs_initial_value_type	 = 'SQL' then		
	lvs_return = f_call_db_sql( lvs_initial_value )			
	Messagebox("Verify" , lvs_return )	
end if


end event

type cb_4 from so_commandbutton within w_default_value_popup
integer x = 3648
integer y = 428
integer width = 352
integer height = 100
integer taborder = 20
boolean bringtotop = true
string text = "Edit Text"
end type

event clicked;call super::clicked;string lvs_value 

lvs_value = dw_1.GetitemString( dw_1.getrow() , dw_1.GetcolumnName())

openWithparm(w_edit_window , lvs_value )

if message.stringparm = '' then 
else
	dw_1.Setitem( dw_1.getrow() , dw_1.GetcolumnName() ,  message.stringParm )
end if
end event

type gb_2 from so_groupbox within w_default_value_popup
integer x = 2551
integer y = 232
integer width = 1481
integer height = 348
integer taborder = 50
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_1 from so_groupbox within w_default_value_popup
integer x = 9
integer y = 232
integer width = 2002
integer height = 348
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

