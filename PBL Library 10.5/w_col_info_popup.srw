HA$PBExportHeader$w_col_info_popup.srw
$PBExportComments$DW Column Information
forward
global type w_col_info_popup from w_popup_root
end type
type cb_apply from so_commandbutton within w_col_info_popup
end type
type cb_retrieve from so_commandbutton within w_col_info_popup
end type
type cb_extract from so_commandbutton within w_col_info_popup
end type
type sle_window_name from so_singlelineedit within w_col_info_popup
end type
type sle_datawindow from so_singlelineedit within w_col_info_popup
end type
type cb_2 from so_commandbutton within w_col_info_popup
end type
type st_1 from so_statictext within w_col_info_popup
end type
type st_2 from so_statictext within w_col_info_popup
end type
type sle_object_type from so_singlelineedit within w_col_info_popup
end type
type st_3 from so_statictext within w_col_info_popup
end type
type cb_1 from so_commandbutton within w_col_info_popup
end type
type cb_3 from so_commandbutton within w_col_info_popup
end type
type cb_4 from so_commandbutton within w_col_info_popup
end type
type gb_2 from so_groupbox within w_col_info_popup
end type
type gb_1 from so_groupbox within w_col_info_popup
end type
end forward

global type w_col_info_popup from w_popup_root
integer width = 4023
integer height = 2584
string title = "Update Column Property"
cb_apply cb_apply
cb_retrieve cb_retrieve
cb_extract cb_extract
sle_window_name sle_window_name
sle_datawindow sle_datawindow
cb_2 cb_2
st_1 st_1
st_2 st_2
sle_object_type sle_object_type
st_3 st_3
cb_1 cb_1
cb_3 cb_3
cb_4 cb_4
gb_2 gb_2
gb_1 gb_1
end type
global w_col_info_popup w_col_info_popup

type variables
DATAWINDOW ARG_DW
STRING IVS_WINDOW , IVS_DATAWINDOW
end variables

on w_col_info_popup.create
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
this.sle_object_type=create sle_object_type
this.st_3=create st_3
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
this.Control[iCurrent+9]=this.sle_object_type
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.cb_1
this.Control[iCurrent+12]=this.cb_3
this.Control[iCurrent+13]=this.cb_4
this.Control[iCurrent+14]=this.gb_2
this.Control[iCurrent+15]=this.gb_1
end on

on w_col_info_popup.destroy
call super::destroy
destroy(this.cb_apply)
destroy(this.cb_retrieve)
destroy(this.cb_extract)
destroy(this.sle_window_name)
destroy(this.sle_datawindow)
destroy(this.cb_2)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_object_type)
destroy(this.st_3)
destroy(this.cb_1)
destroy(this.cb_3)
destroy(this.cb_4)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event open;call super::open;ARG_DW = MESSAGE.POWEROBJECTPARM
IVS_WINDOW         =  gst_return.gvs_return[1]
IVS_DATAWINDOW = gst_return.gvs_return[2]
SLE_WINDOW_NAME.TEXT= gst_return.gvs_return[1]
SLE_DATAWINDOW.TEXT= gst_return.gvs_return[2]
CB_EXTRACT.POSTEVENT(CLICKED!)

end event

event close;call super::close;ROLLBACK;
end event

type p_title from w_popup_root`p_title within w_col_info_popup
integer width = 3995
end type

type cb_sort from w_popup_root`cb_sort within w_col_info_popup
boolean visible = true
integer x = 1810
integer y = 352
integer width = 393
end type

type cb_close from w_popup_root`cb_close within w_col_info_popup
boolean visible = true
integer x = 3397
integer y = 352
integer width = 389
end type

event cb_close::clicked;call super::clicked;ROLLBACK ;
end event

type st_msg from w_popup_root`st_msg within w_col_info_popup
boolean visible = true
integer y = 576
integer width = 3995
end type

type dw_1 from w_popup_root`dw_1 within w_col_info_popup
boolean visible = true
integer x = 9
integer y = 876
integer width = 3995
integer height = 1620
boolean titlebar = true
string title = "Column Information"
string dataobject = "d_col_info_lst_popup_tree"
end type

type dw_2 from w_popup_root`dw_2 within w_col_info_popup
boolean visible = true
integer x = 9
integer y = 876
integer height = 480
end type

type dw_3 from w_popup_root`dw_3 within w_col_info_popup
integer y = 880
end type

type cb_apply from so_commandbutton within w_col_info_popup
integer x = 1280
integer y = 740
integer width = 389
integer height = 100
integer taborder = 30
boolean bringtotop = true
string text = "Apply"
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
	END IF
ELSE
	RETURN 
END IF

F_MSG_MDI_HELP(F_MSG_ST(170)) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
SELECTED_WINDOW.triggerevent( 'ue_post_open')
end event

type cb_retrieve from so_commandbutton within w_col_info_popup
integer x = 2208
integer y = 352
integer width = 393
integer height = 100
integer taborder = 20
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;ROLLBACK ;
dw_1.retrieve(IVS_WINDOW , IVS_DATAWINDOW , SLE_OBJECT_TYPE.TEXT+'%' ,gvi_organization_id  )

end event

type cb_extract from so_commandbutton within w_col_info_popup
integer x = 82
integer y = 740
integer width = 389
integer height = 100
integer taborder = 30
boolean bringtotop = true
string text = "Extract"
end type

event clicked;dw_1.settransobject(sqlca)

String lvs_col_name, lvs_update_yn , lvs_format , lvs_editmask , lvs_visible_yn , lvs_col_type
String lvs_width , lvs_height , lvs_sparse , lvs_column_order , lvs_column_align 
Integer lvi_count
String lvs_object_x1 , lvs_object_y1 , lvs_object_x2 , lvs_object_y2 , lvs_column_expression , lvs_band

STRING ls_dwobject 
Int li_objcount , li_start , li_end  , lvl_rows

	          SELECT COUNT(*) INTO :LVI_COUNT 
			   FROM ISYS_WINDOW_PROPERTY 
			WHERE WINDOW_NAME         = UPPER(:IVS_WINDOW)
			     AND DATAWINDOW_NAME = UPPER(:IVS_DATAWINDOW)
			     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
			
			IF F_SQL_CHECK() < 0 THEN 
				RETURN
			END IF
				
			IF LVI_COUNT > 0 THEN 
				
				MSG = F_MSGBOX1( 125 ,UPPER(IVS_WINDOW)) //@ $$HEX12$$00ac200074c7f8bb200074c8acc7200069d5c8b2e4b22000$$ENDHEX$$
				
			END IF

MSG = F_MSGBOX1( 1161 , THIS.TEXT ) //@ $$HEX7$$7cb9200098ccacb960d54cae94c6$$ENDHEX$$?
IF MSG = 1 THEN
	
			DELETE FROM ISYS_WINDOW_PROPERTY 
			WHERE WINDOW_NAME         = UPPER(:IVS_WINDOW)
			AND DATAWINDOW_NAME = UPPER(:IVS_DATAWINDOW)
			AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
			
			IF F_SQL_CHECK() < 0 THEN 	
				RETURN 
			END IF 

			dw_1.Reset()
			dw_1.ResetUPDATE()
			
			Gst_dw_colinfo.i_dw_colcount = 0
			Gst_dw_colinfo.i_dw_colcount=Integer(  ARG_DW.Describe("DataWindow.Column.Count"))

			ls_dwobject = ARG_DW.Object.DataWindow.Objects     // dw object list
			if len(trim(ls_dwobject)) = 0 then 
				return
			end if

			li_objcount = f_dual_lang_object_count(ls_dwobject)  // get object count


open(w_progress_popup )
w_progress_popup.f_set_range( 1 , Gst_dw_colinfo.i_dw_colcount + li_objcount )
w_progress_popup.f_setstep(1)
			//======================================================================
			// Column Object $$HEX2$$7cb92000$$ENDHEX$$Scan $$HEX2$$5cd5e4b2$$ENDHEX$$
			//======================================================================
			lvs_sparse = ARG_DW.Describe("datawindow.sparse")
			For lvi_count = 1 to Gst_dw_colinfo.i_dw_colcount
				
				dw_1.InsertRow(0)
				F_SET_SECURITY_ROW(DW_1 , lvi_count , 'ALL')
					
				lvs_col_name	= ARG_DW.Describe('#'+String(lvi_count)+".Name")	
				lvs_col_type	= ARG_DW.Describe('#'+String(lvi_count)+".ColType")					
				lvs_update_yn	= ARG_DW.Describe(lvs_col_name + ".Update")
				lvs_format= ARG_DW.Describe(lvs_col_name + ".format")
				lvs_editmask= ARG_DW.Describe(lvs_col_name + ".editmask.mask")
				lvs_visible_yn=   ARG_DW.Describe(lvs_col_name + ".visible")
				
				lvs_width = ARG_DW.Describe(lvs_col_name + ".width")
				lvs_height = ARG_DW.Describe(lvs_col_name + ".height")
			     lvs_object_x1 = ARG_DW.Describe(lvs_col_name + ".x")
			     lvs_object_y1 = ARG_DW.Describe(lvs_col_name + ".y")				  				  
				lvs_column_order = ARG_DW.Describe(lvs_col_name + ".x")
				lvs_column_align =  ARG_DW.Describe(lvs_col_name + ".Alignment")
				lvs_band=  ARG_DW.Describe(lvs_col_name + ".Band")

				dw_1.SetItem(lvi_count,'object_type' ,'COLUMN')
				dw_1.SetItem(lvi_count,'window_name' , UPPER(ivs_window) )
				dw_1.SetItem(lvi_count,'datawindow_name' ,UPPER( ivs_datawindow) )
				dw_1.SetItem(lvi_count,'column_name',UPPER(lvs_col_name))
				dw_1.SetItem(lvi_count,'column_type',UPPER(lvs_col_type))				
				
				dw_1.SetItem(lvi_count,'column_mean',ARG_DW.Describe(lvs_col_name+"_t.Text"))	
				dw_1.SetItem(lvi_count,'column_format',lvs_format)	
				dw_1.SetItem(lvi_count,'editmask',lvs_editmask)		
				dw_1.SetItem(lvi_count,'visible_yn',lvs_visible_yn)		
				dw_1.SetItem(lvi_count,'column_width',lvs_width)		
				dw_1.SetItem(lvi_count,'column_height',lvs_height)						
				dw_1.SetItem(lvi_count,'object_x1',lvs_object_x1)		
				dw_1.SetItem(lvi_count,'object_y1',lvs_object_y1)		
				dw_1.SetItem(lvi_count,'object_align',lvs_column_align)						
				dw_1.SetItem(lvi_count,'band',lvs_band )
				
				IF lvs_column_order = '?' THEN 
					lvs_column_order = '-1'
				END IF				
				
				dw_1.SetItem(lvi_count,'column_order',lvs_column_order)		
				
				IF Pos(lvs_sparse,lvs_col_name ) > 0 THEN 
					dw_1.SetItem(lvi_count,'sparse','Y')		
				ELSE
					dw_1.SetItem(lvi_count,'sparse','N')				
				END IF
				
				IF lvs_update_yn = "yes" Then
					dw_1.SetItem(lvi_count, 'update_yn', 'Y')	
				Else
					dw_1.SetItem(lvi_count, 'update_yn', 'N')
				End IF
			
			
			w_progress_popup.f_stepit()
			
			Next
//=================================================================
//
//=================================================================
	li_start = 0
	
	for lvi_count = 1 to li_objcount
		
		lvs_col_name = '' ; lvs_object_x1 ='' ; lvs_object_x2 ='' ;lvs_object_y1 = '';lvs_object_y2 = '' ; lvs_width = '' ;lvs_column_order = '' ; lvs_visible_yn = ''
		lvl_rows = 0 ;
		
		li_end = pos(ls_dwobject, "~t", li_start + 1)
		if lvi_count < li_objcount then    // last object check
			lvs_col_name = mid(ls_dwobject, li_start + 1, li_end - li_start - 1)	
		else
			lvs_col_name = mid(ls_dwobject, li_start + 1, len(ls_dwobject) - li_start)
		end if
	
	     lvs_band = ''
		if ARG_DW.describe (lvs_col_name + ".type") = "text" then    // object type check
		
			     lvl_rows = dw_1.InsertRow(0)
				F_SET_SECURITY_ROW(DW_1 , lvl_rows , 'ALL')
					
				lvs_col_name	= ARG_DW.Describe(lvs_col_name+".Name")	
				lvs_format= ARG_DW.Describe(lvs_col_name + ".format")
				lvs_editmask= ARG_DW.Describe(lvs_col_name + ".editmask.mask")
				lvs_visible_yn= ARG_DW.Describe(lvs_col_name + ".visible")
				lvs_width = ARG_DW.Describe(lvs_col_name + ".width")
				lvs_height = ARG_DW.Describe(lvs_col_name + ".height")				
				lvs_column_order = ARG_DW.Describe(lvs_col_name + ".x")
				lvs_object_x1 = ARG_DW.Describe(lvs_col_name + ".x")
				lvs_object_x2 = ARG_DW.Describe(lvs_col_name + ".x")
				lvs_object_y1 = ARG_DW.Describe(lvs_col_name + ".y")
				lvs_object_y2 = ARG_DW.Describe(lvs_col_name + ".y")	
				lvs_column_align =  ARG_DW.Describe(lvs_col_name + ".Alignment")				
				lvs_band=  ARG_DW.Describe(lvs_col_name + ".Band")				
				
				dw_1.SetItem(lvl_rows,'object_type' ,'TEXT')
				dw_1.SetItem(lvl_rows,'window_name' , UPPER(ivs_window) )
				dw_1.SetItem(lvl_rows,'datawindow_name' ,UPPER( ivs_datawindow) )
				dw_1.SetItem(lvl_rows,'column_name',UPPER(lvs_col_name))
				
				dw_1.SetItem(lvl_rows,'column_mean',ARG_DW.Describe(lvs_col_name+".text"))	
				dw_1.SetItem(lvl_rows,'column_format',lvs_format)	
				dw_1.SetItem(lvl_rows,'editmask',lvs_editmask)		
				dw_1.SetItem(lvl_rows,'visible_yn',lvs_visible_yn)	
				
				dw_1.SetItem(lvl_rows,'object_x1',lvs_object_x1)						
				dw_1.SetItem(lvl_rows,'object_x2',lvs_object_x1)										
				dw_1.SetItem(lvl_rows,'object_y1',lvs_object_y1)						
				dw_1.SetItem(lvl_rows,'object_y2',lvs_object_y1)		
				dw_1.SetItem(lvl_rows,'object_align',lvs_column_align)						
				
				dw_1.SetItem(lvl_rows,'column_width',lvs_width)		
				dw_1.SetItem(lvl_rows,'column_height',lvs_height)	
				dw_1.SetItem(lvl_rows,'band',lvs_band )				
				
				IF lvs_column_order = '?' THEN 
					lvs_column_order = '-1'
				END IF
				dw_1.SetItem(lvl_rows,'column_order',lvs_column_order)		
				
				dw_1.SetItem(lvl_rows,'sparse','N')				
				dw_1.SetItem(lvl_rows, 'update_yn', 'N')

		elseif 	ARG_DW.describe (lvs_col_name + ".type") = "line" then    // object type check
			
			
			     lvl_rows = dw_1.InsertRow(0)
				F_SET_SECURITY_ROW(DW_1 , lvl_rows , 'ALL')
					
				lvs_col_name	= ARG_DW.Describe(lvs_col_name+".Name")	
				lvs_visible_yn   = ARG_DW.Describe(lvs_col_name + ".visible")
				

				lvs_object_x1 = ARG_DW.Describe(lvs_col_name + ".x1")
				lvs_object_x2 = ARG_DW.Describe(lvs_col_name + ".x2")
				lvs_object_y1 = ARG_DW.Describe(lvs_col_name + ".y1")
				lvs_object_y2 = ARG_DW.Describe(lvs_col_name + ".y2")	
				lvs_band=  ARG_DW.Describe(lvs_col_name + ".Band")										
				
				dw_1.SetItem(lvl_rows,'object_type' ,'LINE')			
			     dw_1.SetItem(lvl_rows,'window_name' , UPPER(ivs_window) )
				dw_1.SetItem(lvl_rows,'datawindow_name' ,UPPER( ivs_datawindow) )
				dw_1.SetItem(lvl_rows,'column_name',UPPER(lvs_col_name))
				
				dw_1.SetItem(lvl_rows,'column_mean','LINE')
				dw_1.SetItem(lvl_rows,'visible_yn',lvs_visible_yn)		
				
				dw_1.SetItem(lvl_rows,'object_x1',lvs_object_x1)						
				dw_1.SetItem(lvl_rows,'object_x2',lvs_object_x2)										
				dw_1.SetItem(lvl_rows,'object_y1',lvs_object_y1)						
				dw_1.SetItem(lvl_rows,'object_y2',lvs_object_y2)										
				
				dw_1.SetItem(lvl_rows,'column_width',  string( long(lvs_object_x2) - long(lvs_object_x1)) )
				dw_1.SetItem(lvl_rows,'band',lvs_band )					
				
				IF lvs_object_x1 = '?' THEN 
					lvs_object_x1 = '-1'
				END IF					
				dw_1.SetItem(lvl_rows,'column_order',lvs_object_x1)		

				
				dw_1.SetItem(lvl_rows,'sparse','N')				
				dw_1.SetItem(lvl_rows, 'update_yn', 'N')
					
			
		elseif 	ARG_DW.describe (lvs_col_name + ".type") = "compute" then    // object type check

			     lvl_rows = dw_1.InsertRow(0)
				F_SET_SECURITY_ROW(DW_1 , lvl_rows , 'ALL')
					
				lvs_col_name	= ARG_DW.Describe(lvs_col_name+".Name")	
				lvs_format= ARG_DW.Describe(lvs_col_name + ".format")
				lvs_editmask= ARG_DW.Describe(lvs_col_name + ".editmask.mask")
				lvs_visible_yn= ARG_DW.Describe(lvs_col_name + ".visible")
				lvs_width = ARG_DW.Describe(lvs_col_name + ".width")
				lvs_height = ARG_DW.Describe(lvs_col_name + ".height")				
				lvs_column_order = ARG_DW.Describe(lvs_col_name + ".x")
				lvs_object_x1 = ARG_DW.Describe(lvs_col_name + ".x")
				lvs_object_x2 = ARG_DW.Describe(lvs_col_name + ".x")
				lvs_object_y1 = ARG_DW.Describe(lvs_col_name + ".y")
				lvs_object_y2 = ARG_DW.Describe(lvs_col_name + ".y")	
				lvs_column_align =  ARG_DW.Describe(lvs_col_name + ".Alignment")		
				lvs_column_expression =  ARG_DW.Describe(lvs_col_name + ".Expression")				
				lvs_band=  ARG_DW.Describe(lvs_col_name + ".Band")		
				
				dw_1.SetItem(lvl_rows,'object_type' ,'COMPUTE')
				dw_1.SetItem(lvl_rows,'window_name' , UPPER(ivs_window) )
				dw_1.SetItem(lvl_rows,'datawindow_name' ,UPPER( ivs_datawindow) )
				dw_1.SetItem(lvl_rows,'column_name',UPPER(lvs_col_name))
				
				dw_1.SetItem(lvl_rows,'column_mean','COMPUTE')
				dw_1.SetItem(lvl_rows,'column_format',lvs_format)	
				dw_1.SetItem(lvl_rows,'editmask',lvs_editmask)		
				dw_1.SetItem(lvl_rows,'visible_yn',lvs_visible_yn)	
				
				dw_1.SetItem(lvl_rows,'object_x1',lvs_object_x1)						
				dw_1.SetItem(lvl_rows,'object_x2',lvs_object_x1)										
				dw_1.SetItem(lvl_rows,'object_y1',lvs_object_y1)						
				dw_1.SetItem(lvl_rows,'object_y2',lvs_object_y1)		
				dw_1.SetItem(lvl_rows,'object_align',lvs_column_align)						
				
				dw_1.SetItem(lvl_rows,'column_width',lvs_width)		
				dw_1.SetItem(lvl_rows,'column_height',lvs_height)		
				dw_1.SetItem(lvl_rows,'column_expression',lvs_column_expression)
				dw_1.SetItem(lvl_rows,'band',lvs_band )
				
				IF lvs_column_order = '?' THEN 
					lvs_column_order = '-1'
				END IF				
				dw_1.SetItem(lvl_rows,'column_order',lvs_column_order)		
				
				dw_1.SetItem(lvl_rows,'sparse','N')				
				dw_1.SetItem(lvl_rows, 'update_yn', 'N')
		end if
		li_start = li_end
		
		w_progress_popup.f_stepit()		
	next
//==================================================================
ELSE

   CB_RETRIEVE.TRIGGEREVENT(CLICKED!)

END IF

dw_1.sort( )
dw_1.groupcalc( )
Close(w_progress_popup)
end event

type sle_window_name from so_singlelineedit within w_col_info_popup
integer x = 576
integer y = 276
integer width = 1001
integer taborder = 50
boolean bringtotop = true
textcase textcase = upper!
end type

type sle_datawindow from so_singlelineedit within w_col_info_popup
integer x = 576
integer y = 360
integer width = 448
integer taborder = 60
boolean bringtotop = true
textcase textcase = upper!
end type

type cb_2 from so_commandbutton within w_col_info_popup
integer x = 2601
integer y = 352
integer width = 393
integer height = 100
integer taborder = 30
boolean bringtotop = true
string text = "Reset"
end type

event clicked;MSG = F_MSGBOX1( 1161 , THIS.TEXT ) //@ $$HEX7$$7cb9200098ccacb960d54cae94c6$$ENDHEX$$?
IF MSG = 1 THEN 
	
	DELETE FROM ISYS_WINDOW_PROPERTY 
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

type st_1 from so_statictext within w_col_info_popup
integer x = 37
integer y = 288
integer width = 517
integer height = 52
boolean bringtotop = true
integer weight = 700
string text = "Window Name"
alignment alignment = right!
end type

type st_2 from so_statictext within w_col_info_popup
integer x = 37
integer y = 372
integer width = 517
integer height = 52
boolean bringtotop = true
integer weight = 700
string text = "Data Window Name"
alignment alignment = right!
end type

type sle_object_type from so_singlelineedit within w_col_info_popup
integer x = 576
integer y = 444
integer width = 448
integer taborder = 70
boolean bringtotop = true
textcase textcase = upper!
end type

type st_3 from so_statictext within w_col_info_popup
integer x = 37
integer y = 444
integer width = 517
integer height = 52
boolean bringtotop = true
integer weight = 700
string text = "Object Type"
alignment alignment = right!
end type

type cb_1 from so_commandbutton within w_col_info_popup
integer x = 2999
integer y = 352
integer width = 393
integer height = 100
integer taborder = 40
boolean bringtotop = true
string text = "Delete"
end type

event clicked;call super::clicked;if dw_1.getrow( ) < 1 then return

Long  LVL_COUNT , i  , j , k 

open(w_progress_popup)
gvs_deleteselecte_mod = 'Y'
LVL_COUNT =  dw_1.ROWCOUNT()
w_progress_popup.f_set_range( 0 ,  LVL_COUNT )
w_progress_popup.f_setstep(1)					
I = 1  ; k = 0 ; j = 0 
DO
K++

IF dw_1.object.check_yn[I] = 'Y' THEN 
	J++
	dw_1.DELETEROW( I )
ELSE
	 I++
END IF

  w_progress_popup.f_stepit()

LOOP UNTIL K = LVL_COUNT

Close(w_progress_popup)	
end event

type cb_3 from so_commandbutton within w_col_info_popup
integer x = 475
integer y = 740
integer width = 389
integer height = 100
integer taborder = 40
boolean bringtotop = true
string text = "Visible"
end type

event clicked;call super::clicked;if dw_1.rowcount( )  < 1 then return
int i
do
	i++
	if dw_1.object.check_yn[i] = 'Y' then
	else
		continue
	end if
	
	
	dw_1.object.visible_yn[i] = '1'
	
loop until i = dw_1.rowcount( )
end event

type cb_4 from so_commandbutton within w_col_info_popup
integer x = 869
integer y = 740
integer width = 389
integer height = 100
integer taborder = 50
boolean bringtotop = true
string text = "Hide"
end type

event clicked;call super::clicked;if dw_1.rowcount( )  < 1 then return
int i
do
	i++
	if dw_1.object.check_yn[i] = 'Y' then
	else
		continue
	end if
	
	
	dw_1.object.visible_yn[i] = '0'
	
loop until i = dw_1.rowcount( )
end event

type gb_2 from so_groupbox within w_col_info_popup
integer x = 1609
integer y = 220
integer width = 2382
integer height = 348
integer taborder = 50
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_1 from so_groupbox within w_col_info_popup
integer x = 9
integer y = 220
integer width = 1591
integer height = 348
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

