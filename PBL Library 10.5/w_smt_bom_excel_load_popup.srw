HA$PBExportHeader$w_smt_bom_excel_load_popup.srw
$PBExportComments$(Item Query)-$$HEX4$$80bd88d470c88cd6$$ENDHEX$$
forward
global type w_smt_bom_excel_load_popup from w_popup_root
end type
type cb_1 from commandbutton within w_smt_bom_excel_load_popup
end type
type cb_save_form from so_commandbutton within w_smt_bom_excel_load_popup
end type
type rb_normal from so_radiobutton within w_smt_bom_excel_load_popup
end type
type rb_simple from so_radiobutton within w_smt_bom_excel_load_popup
end type
type st_smt_model_name from so_statictext within w_smt_bom_excel_load_popup
end type
type ddlb_pcb_item from uo_basecode within w_smt_bom_excel_load_popup
end type
type ddlb_smt_model_name from uo_smt_model_name_ddlb within w_smt_bom_excel_load_popup
end type
type ddlb_model_name from uo_set_model_name_ddlb within w_smt_bom_excel_load_popup
end type
type st_model_name from so_statictext within w_smt_bom_excel_load_popup
end type
type ddlb_line_code from uo_line_code within w_smt_bom_excel_load_popup
end type
type st_line_code from so_statictext within w_smt_bom_excel_load_popup
end type
type st_pcb_item from so_statictext within w_smt_bom_excel_load_popup
end type
type cb_shaft_copy from commandbutton within w_smt_bom_excel_load_popup
end type
type st_revision from so_statictext within w_smt_bom_excel_load_popup
end type
type ddlb_revision from uo_mfs_bom_revision_dynamic within w_smt_bom_excel_load_popup
end type
type cbx_direct from so_checkbox within w_smt_bom_excel_load_popup
end type
type ddlb_direct_shaft from so_dropdownlistbox within w_smt_bom_excel_load_popup
end type
type cb_direct from commandbutton within w_smt_bom_excel_load_popup
end type
type gb_3 from so_groupbox within w_smt_bom_excel_load_popup
end type
type gb_2 from so_groupbox within w_smt_bom_excel_load_popup
end type
end forward

global type w_smt_bom_excel_load_popup from w_popup_root
integer width = 5289
integer height = 2840
string title = "BOM Excel Load Popup"
cb_1 cb_1
cb_save_form cb_save_form
rb_normal rb_normal
rb_simple rb_simple
st_smt_model_name st_smt_model_name
ddlb_pcb_item ddlb_pcb_item
ddlb_smt_model_name ddlb_smt_model_name
ddlb_model_name ddlb_model_name
st_model_name st_model_name
ddlb_line_code ddlb_line_code
st_line_code st_line_code
st_pcb_item st_pcb_item
cb_shaft_copy cb_shaft_copy
st_revision st_revision
ddlb_revision ddlb_revision
cbx_direct cbx_direct
ddlb_direct_shaft ddlb_direct_shaft
cb_direct cb_direct
gb_3 gb_3
gb_2 gb_2
end type
global w_smt_bom_excel_load_popup w_smt_bom_excel_load_popup

type variables
		STRING LVS_SET_ITEM_CODE , LVS_MODEL_NAME , lvs_smt_model_name , lvs_line_code , lvs_pcb_item , lvs_revision , lvs_direct_shaft
		DOUBLE LVDB_SESSION_ID
end variables

on w_smt_bom_excel_load_popup.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.cb_save_form=create cb_save_form
this.rb_normal=create rb_normal
this.rb_simple=create rb_simple
this.st_smt_model_name=create st_smt_model_name
this.ddlb_pcb_item=create ddlb_pcb_item
this.ddlb_smt_model_name=create ddlb_smt_model_name
this.ddlb_model_name=create ddlb_model_name
this.st_model_name=create st_model_name
this.ddlb_line_code=create ddlb_line_code
this.st_line_code=create st_line_code
this.st_pcb_item=create st_pcb_item
this.cb_shaft_copy=create cb_shaft_copy
this.st_revision=create st_revision
this.ddlb_revision=create ddlb_revision
this.cbx_direct=create cbx_direct
this.ddlb_direct_shaft=create ddlb_direct_shaft
this.cb_direct=create cb_direct
this.gb_3=create gb_3
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_save_form
this.Control[iCurrent+3]=this.rb_normal
this.Control[iCurrent+4]=this.rb_simple
this.Control[iCurrent+5]=this.st_smt_model_name
this.Control[iCurrent+6]=this.ddlb_pcb_item
this.Control[iCurrent+7]=this.ddlb_smt_model_name
this.Control[iCurrent+8]=this.ddlb_model_name
this.Control[iCurrent+9]=this.st_model_name
this.Control[iCurrent+10]=this.ddlb_line_code
this.Control[iCurrent+11]=this.st_line_code
this.Control[iCurrent+12]=this.st_pcb_item
this.Control[iCurrent+13]=this.cb_shaft_copy
this.Control[iCurrent+14]=this.st_revision
this.Control[iCurrent+15]=this.ddlb_revision
this.Control[iCurrent+16]=this.cbx_direct
this.Control[iCurrent+17]=this.ddlb_direct_shaft
this.Control[iCurrent+18]=this.cb_direct
this.Control[iCurrent+19]=this.gb_3
this.Control[iCurrent+20]=this.gb_2
end on

on w_smt_bom_excel_load_popup.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.cb_save_form)
destroy(this.rb_normal)
destroy(this.rb_simple)
destroy(this.st_smt_model_name)
destroy(this.ddlb_pcb_item)
destroy(this.ddlb_smt_model_name)
destroy(this.ddlb_model_name)
destroy(this.st_model_name)
destroy(this.ddlb_line_code)
destroy(this.st_line_code)
destroy(this.st_pcb_item)
destroy(this.cb_shaft_copy)
destroy(this.st_revision)
destroy(this.ddlb_revision)
destroy(this.cbx_direct)
destroy(this.ddlb_direct_shaft)
destroy(this.cb_direct)
destroy(this.gb_3)
destroy(this.gb_2)
end on

event open;call super::open;dw_1.settransobject(sqlca)


end event

event activate;call super::activate;//===============================
//
//===============================
IVS_RESIZE_TYPE = 'DEFAULT'
IVS_MOUSEMOVE_YN = 'N'
end event

type p_title from w_popup_root`p_title within w_smt_bom_excel_load_popup
integer width = 5271
integer height = 188
long backcolor = 16777215
end type

type cb_sort from w_popup_root`cb_sort within w_smt_bom_excel_load_popup
integer x = 4709
integer y = 12
integer height = 156
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_smt_bom_excel_load_popup
boolean visible = true
integer x = 4864
integer y = 272
integer width = 393
integer height = 156
integer taborder = 0
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_smt_bom_excel_load_popup
boolean visible = true
integer y = 484
integer width = 5266
end type

type dw_1 from w_popup_root`dw_1 within w_smt_bom_excel_load_popup
integer x = 14
integer y = 584
integer width = 2665
integer height = 824
integer taborder = 70
boolean titlebar = true
string title = "SMT BOM Simple"
string dataobject = "d_smt_bom_excel_load_3_popup"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type dw_2 from w_popup_root`dw_2 within w_smt_bom_excel_load_popup
boolean visible = true
integer x = 2683
integer y = 584
integer width = 2578
integer height = 824
integer taborder = 0
boolean titlebar = true
string title = "SMT BOM Normal"
string dataobject = "d_des_bom_excel_load_2_popup"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type dw_3 from w_popup_root`dw_3 within w_smt_bom_excel_load_popup
boolean visible = true
integer y = 1416
integer width = 5253
integer height = 1080
boolean titlebar = true
string title = "BOM Comparision"
string dataobject = "d_des_bom_query_4_blocking_comparision"
boolean maxbox = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_1 from commandbutton within w_smt_bom_excel_load_popup
integer x = 2834
integer y = 272
integer width = 393
integer height = 156
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Paste"
end type

event clicked;int i

msg = f_msgbox1(1161 , this.text )
if msg =1 then 
else
	return 
end if 

if rb_normal.checked = true then 

		dw_2.reset()
		dw_2.importclipboard( )	
		
		delete from id_eng_bom_excel_2 ;
		
		if f_sql_check() < 0 then 
			return 
		end if 
	
		if dw_2.update() < 0 then 
			rollback;
		else
			commit;
			
			f_msgbox(170) 
		end if
		
end if 
//===================================
//
//===================================

lvs_smt_model_name  =  ddlb_smt_model_name.getcode()
lvs_line_code =  ddlb_line_code.getcode()
lvs_pcb_item = ddlb_pcb_item.getcode()
lvs_revision = ddlb_revision.getcode() 

if isnull(lvs_smt_model_name)  or lvs_smt_model_name = '' or lvs_smt_model_name = '%' then 	
	f_msgbox1(102 , st_smt_model_name.text )
	return
end if 

if isnull(lvs_line_code)  or lvs_line_code = '' or lvs_line_code = '%' then 	
	f_msgbox1(102 , st_line_code.text )
	return
end if 

if isnull(lvs_pcb_item)  or lvs_pcb_item = '' or lvs_pcb_item = '%' then 	
	f_msgbox1(102 , st_pcb_item.text )
	return
end if 

if isnull(lvs_revision)  or lvs_revision = '' or lvs_revision = '%' then 	
	f_msgbox1(102 , st_revision.text )
	return
end if 

INT LVI_COUNT

//SELECT COUNT(*) INTO :LVI_COUNT 
//  FROM ID_MFS_BOM 
//WHERE ITEM_CODE = ( SELECT ITEM_CODE FROM IP_PRODUCT_MODEL_MASTER WHERE SMT_MODEL_NAME = :lvs_smt_model_name ) 
//   AND MFS = :LVS_REVISION 
//   AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
//	
//if f_sql_check() < 0 then 
//	return 
//end if 	
//
//if lvi_count = 0 then 
//     //Mes sagebox("Error" , "Revision $$HEX9$$44c7200055d678c7200058d538c194c62000$$ENDHEX$$")
//	 f_msg( "Revision $$HEX8$$44c7200055d678c7200058d538c194c6$$ENDHEX$$",'S')
//	return 
//end if 

//==============================================
//
//==============================================

delete from id_eng_bom_excel_3 ;

if f_sql_check() < 0 then 
	return 
end if 

dw_1.reset()
dw_1.importclipboard( )	

do
	i++
	
	dw_1.object.model_name[i] =lvs_smt_model_name
	dw_1.object.line_code[i] =lvs_line_code
	dw_1.object.pcb_item[i] =  lvs_pcb_item
	dw_1.object.revision[i] =  lvs_revision
	
	if   mid( dw_1.object.g[i] ,1,1)  =  '1' then 
		dw_1.object.g[i] = string( long( mid(dw_1.object.g[i],1,1)) + 4 ) + trim(mid( dw_1.object.g[i] , 2, 10))
	end if 
	if   mid( dw_1.object.h[i] ,1,1)  =  '2' then 
		dw_1.object.h[i] = string( long( mid(dw_1.object.h[i],1,1)) + 4 ) + trim(mid( dw_1.object.h[i] , 2, 10))
	end if 
	if   mid( dw_1.object.i[i] ,1,1)  =  '3' then 
		dw_1.object.i[i] = string( long( mid(dw_1.object.i[i],1,1)) + 4 ) + trim(mid( dw_1.object.i[i] , 2, 10))
	end if 
	if   mid( dw_1.object.j[i] ,1,1)  =  '4' then 
		dw_1.object.j[i] = string( long( mid(dw_1.object.j[i],1,1)) + 4 ) + trim(mid( dw_1.object.j[i] , 2, 10))
	end if 	


		if mid( dw_1.object.k[i] ,1,1)  =  '1' 	then 
			dw_1.object.k[i] = string( long( mid(dw_1.object.k[i],1,1)) + 8 ) + trim(mid( dw_1.object.k[i] , 2, 10))
		end if 
			if mid( dw_1.object.L[i] ,1,1)  =  '2' 	then 
			dw_1.object.L[i] = string( long( mid(dw_1.object.L[i],1,1)) + 8 ) + trim(mid( dw_1.object.L[i] , 2, 10))
		end if 
		
		if mid( dw_1.object.m[i] ,1,1)  =  '3' 	then 
			dw_1.object.m[i] = string( long( mid(dw_1.object.m[i],1,1)) + 8 ) + trim(mid( dw_1.object.m[i] , 2, 10))
		end if 
		
		if mid( dw_1.object.n[i] ,1,1)  =  '4' 	then 
			dw_1.object.n[i] = string( long( mid(dw_1.object.n[i],1,1)) + 8 ) + trim(mid( dw_1.object.n[i] , 2, 10))
		end if 
	
loop until i = dw_1.rowcount( )

// SME $$HEX17$$0cd37cc720002cc6acb9200024c658b920005cb8200078c774d5200098ccacb92000$$ENDHEX$$
//dw_1.RowsCopy(dw_1.rowcount(), dw_1.RowCount(), Primary!, dw_1, dw_1.rowcount(), Primary!)

msg = f_msgbox1(1161 , 'Process' )
if msg =1 then 
	

		//=====================================================
		//
		//=====================================================
		if rb_simple.checked = true then 
			
				LVDB_SESSION_ID = 0 ;
				LVS_SET_ITEM_CODE = ''
				LVS_MODEL_NAME = ''
				
				LVS_SET_ITEM_CODE   =  ddlb_model_name.GETITEM( )
				LVS_MODEL_NAME        =  ddlb_model_name.getcode()
					
				if isnull(LVS_SET_ITEM_CODE)  or LVS_SET_ITEM_CODE = '' or LVS_SET_ITEM_CODE = '%' then 	
					f_msgbox1(102 , st_model_name.text )
					return
				end if 
			
			
				//======================================================
				//
				//======================================================
			
			
				st_msg.text = "Delete Excel Temp..."
				delete from id_eng_bom_excel_2 ;
				if f_sql_check() < 0 then 
					return 
				end if 
	
				
	         DELETE FROM   id_eng_bom_smt
              WHERE     parent_item_code = :lvs_smt_model_name
                      AND line_code = :lvs_line_code
                      AND pcb_item = :lvs_pcb_item
                      AND nvl(revision , '0000')  = nvl(:lvs_revision ,'0000') ;
				
				if f_sql_check() < 0 then 
					return 
				end if
				
				//=============================================
				//
				//=============================================
				st_msg.text = "Update Excel..."
				if dw_1.update() < 0 then 
					rollback;
					return 
				end if
				
				   INSERT INTO ID_ENG_BOM_EXCEL_2 (SEQ,
                                   PARENT_PART_NO,
                                   PART_NO,
                                   LINE_CODE,
                                   MACHINE,
                                   LOCATION,
                                   ITEM_SPEC,
                                   LOCATION_INFO,
                                   COMPONENT_QTY,
                                   PCB_ITEM,
                                   VERSION,
                                   CREATE_DATE,
                                   MARKING_NO,
                                   CHARGER,
                                   COMMENTS,
                                   REPLACE_ITEM_CODE,
                                   TABLE_ID,
                                   REVISION,
                                   FEEDER_SHAFT)
      SELECT MAX (ROWNUM),
             MODEL_NAME,
             ITEM_CODE,
             LINE_CODE,
             MACHINE_CODE,
             TRIM(LOCATION_INFOR),
             '',
             listagg (LOCATION_CODE, ',')
                WITHIN GROUP (ORDER BY LOCATION_CODE)
                AS LOCATION_INFOR,
             COUNT (*),
             PCB_ITEM,
             NVL(revision,'0000'),
             trunc(SYSDATE),
             '',
             '',
             '',
             '',
             TABLE_ID,
            NVL(revision,'0000'),
             'A' // DEFAULT 'A'
        FROM (SELECT ROWNUM,
                     LINE_CODE,
                     LINE_CODE AS MACHINE_CODE,
                     MODEL_NAME,
                     ITEM_CODE,
                     LOCATION_INFOR,
                     
                     TRIM(C || D || E || F || G || H || I || J||K||L||M||N||O||P||Q) ,
                     
                     SUBSTR (
                       TRIM(C || D || E || F || G || H || I || J||K||L||M||N||O||P||Q),
                        1,
                        INSTR ( TRIM(C || D || E || F || G || H || I || J||K||L||M||N||O||P||Q), 'T', 1))
                        TABLE_ID,
                        
                        
                     TRIM(C || D || E || F || G || H || I || J||K||L||M||N||O||P||Q)  AS LOCATION_CODE,

                     PCB_ITEM,
				   revision
                FROM ID_ENG_BOM_EXCEL_3)
				GROUP BY LINE_CODE,
							MODEL_NAME,
							ITEM_CODE,
							PCB_ITEM,
							TRIM(LOCATION_INFOR),
							TABLE_ID,
							revision;
							
				if f_sql_check() < 0 then 
					return 
				end if
			   //==============================================	
			   //	
			   //==============================================
				st_msg.text = "ERP BOM Explosion"
				LVDB_SESSION_ID       = F_BOM_QUERY_PRC( LVS_SET_ITEM_CODE , F_T_SYSDATE())
				
				IF LVDB_SESSION_ID <= 0 THEN
					F_MSGBOX1(9051 ,LVS_SET_ITEM_CODE  )        
				ELSE
					
						 //=============================================
						 //   $$HEX6$$88d4a9ba200044be50ad2000$$ENDHEX$$
						 //=============================================	 
						 STRING  LVS_CHILD_COUNT
						 
						SELECT  max(CHILD_ITEM_CODE) INTO :LVS_CHILD_COUNT FROM 
						    (
								SELECT CHILD_ITEM_CODE  FROM ID_ENG_BOM_SMT 
								WHERE PARENT_ITEM_CODE = :lvs_smt_model_name
								AND LINE_CODE = :LVS_line_code
								AND PCB_ITEM = :lvs_pcb_item
								AND NVL(FEEDER_SHAFT , 'A')  = 'A'
								
								MINUS 
								
								SELECT CHILD_ITEM_CODE  
								  FROM ID_ENG_BOM_TEMP 
								 WHERE SESSION_ID = :LVDB_SESSION_ID 
								
							);
		
							if f_sql_check() < 0 then 
								return 
							end if
							
							if LVS_CHILD_COUNT <> ''  THEN 
								messagebox("Error" , LVS_CHILD_COUNT+" Not Found")
								st_msg.text = f_msg("ERP BOM / Feeder Layout Unmatch.",'S')
								rollback ;	
								return 
							else
									st_msg.text = STRING(LVDB_SESSION_ID) + f_msg(" : ERP BOM Retrieve...",'S')
									DW_3.RETRIEVE( LVDB_SESSION_ID ,  LVS_LINE_CODE , lvs_smt_model_name ,  ddlb_pcb_item.getcode() ,   GVI_ORGANIZATION_ID )
									DW_3.SETFOCUS()
							end if 
				END IF		
		
//				if dw_3.rowcount( ) > 0 then 
//					st_msg.text = "ERP BOM / Feeder Layout Unmatch."
//					rollback ;
//				else
					cb_shaft_copy.enabled = true 
					commit ;
					f_msgbox(170) 
					st_msg.text = "OK"
		//		end if 
		
				COMMIT ; 
		end if
//====================================================
//
//====================================================
else
	return 
end if 

st_msg.text = "Done"

end event

type cb_save_form from so_commandbutton within w_smt_bom_excel_load_popup
integer x = 4475
integer y = 272
integer width = 393
integer height = 156
integer taborder = 100
boolean bringtotop = true
string text = "Save Form"
end type

event clicked;call super::clicked;string     docname, named 
Long iret

SETPOINTER(HOURGLASS!)		
iret = GetFileSaveName("Select Excel File ("+dw_1.classname()+")" , docname, named, "xls", "Excel Files (*.xls),*.xls")		

IF iret =1 THEN 
	
	if rb_normal.checked = true then 
		
		dw_2.insertrow( 0)
		uf_save_dw_as_excel( dw_2  , docname )
		
		
	else
		
		dw_1.insertrow( 0)
		uf_save_dw_as_excel( dw_1  , docname )		
		
	end if 
ELSE
	RETURN
END IF
		

end event

type rb_normal from so_radiobutton within w_smt_bom_excel_load_popup
integer x = 87
integer y = 268
integer width = 370
boolean bringtotop = true
string text = "Normal"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.visible = false
dw_2.visible = true 
end event

type rb_simple from so_radiobutton within w_smt_bom_excel_load_popup
integer x = 87
integer y = 356
integer width = 370
boolean bringtotop = true
string text = "Simple"
end type

event clicked;call super::clicked;dw_1.visible = true
dw_2.visible = false 
end event

type st_smt_model_name from so_statictext within w_smt_bom_excel_load_popup
integer x = 1015
integer y = 264
integer width = 585
boolean bringtotop = true
string text = "SMT Model Name"
end type

type ddlb_pcb_item from uo_basecode within w_smt_bom_excel_load_popup
integer x = 1609
integer y = 356
integer width = 297
integer height = 832
integer taborder = 110
boolean bringtotop = true
end type

event constructor;call super::constructor;THIS.REdraw( 'PCB ITEM')
end event

type ddlb_smt_model_name from uo_smt_model_name_ddlb within w_smt_bom_excel_load_popup
integer x = 1015
integer y = 356
integer width = 585
integer height = 1596
integer taborder = 120
boolean bringtotop = true
end type

type ddlb_model_name from uo_set_model_name_ddlb within w_smt_bom_excel_load_popup
integer x = 1911
integer y = 356
integer width = 635
integer height = 1596
integer taborder = 90
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
boolean autohscroll = true
end type

event selectionchanged;call super::selectionchanged;ddlb_revision.redraw( this.getname( ) )
end event

type st_model_name from so_statictext within w_smt_bom_excel_load_popup
integer x = 1911
integer y = 268
integer width = 635
boolean bringtotop = true
string text = "Model Name"
end type

type ddlb_line_code from uo_line_code within w_smt_bom_excel_load_popup
integer x = 535
integer y = 356
integer width = 471
integer height = 1596
integer taborder = 40
boolean bringtotop = true
end type

type st_line_code from so_statictext within w_smt_bom_excel_load_popup
integer x = 535
integer y = 264
integer width = 471
boolean bringtotop = true
boolean enabled = false
string text = "Line Code"
end type

type st_pcb_item from so_statictext within w_smt_bom_excel_load_popup
integer x = 1609
integer y = 264
integer width = 297
boolean bringtotop = true
boolean enabled = false
string text = "PCB ITem"
end type

type cb_shaft_copy from commandbutton within w_smt_bom_excel_load_popup
integer x = 3227
integer y = 272
integer width = 393
integer height = 156
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Shaft Copy"
end type

event clicked;  INT LVI_COUNT , LVI_COUNT_EIXTIS , J
  STRING lvs_shaft_chage , lvs_source_shaft , lvs_dest_shaft , LVS_LINE_SHAFT_TYPE
  
lvs_shaft_chage = 'Y'

lvs_smt_model_name  =  ddlb_smt_model_name.getcode()
lvs_line_code =  ddlb_line_code.getcode()
lvs_pcb_item = ddlb_pcb_item.getcode()

//lvs_dest_shaft = ddlb_direct_shaft.text 
//=========================================
//  $$HEX10$$7cb778c758c7200024c144be200020c715d62000$$ENDHEX$$CM $$HEX3$$78c7c0c92000$$ENDHEX$$NPM $$HEX7$$78c7c0c9d0c5200030b57cb72000$$ENDHEX$$
// NPM $$HEX19$$74c774ba20005cb800cf74c758c144c72000c0bcbdac200058d5c0c920004ac594b2e4b22000$$ENDHEX$$
// C , N 
//=========================================
SELECT MAX(LINE_SHAFT_TYPE) INTO :LVS_LINE_SHAFT_TYPE 
  FROM IB_LINE_MASTER WHERE LINE_CODE = :LVS_LINE_CODE ;
  
 IF F_SQL_CHECK() < 0 THEN 
	RETURN 
END IF 


if isnull(lvs_smt_model_name)  or lvs_smt_model_name = '' or lvs_smt_model_name = '%' then 	
	f_msgbox1(102 , st_smt_model_name.text )
	return
end if 

if isnull(lvs_line_code)  or lvs_line_code = '' or lvs_line_code = '%' then 	
	f_msgbox1(102 , st_line_code.text )
	return
end if 

if isnull(lvs_pcb_item)  or lvs_pcb_item = '' or lvs_pcb_item = '%' then 	
	f_msgbox1(102 , st_pcb_item.text )
	return
end if 


if isnull(ddlb_line_code.getcode()) then 	
	f_msgbox1(102 , st_line_code.text )
	return
else
	lvs_line_code = ddlb_line_code.getcode()
end if 

lvs_pcb_item = ddlb_pcb_item.getcode( )

if isnull(lvs_pcb_item) or lvs_pcb_item = '' or lvs_pcb_item = '%'  then
  	f_msgbox1(102 , st_pcb_item.text )
	return
end if 

////===========================================================
////
////===========================================================
//
//  SELECT COUNT(*) 
//	    INTO :LVI_COUNT
//       FROM ID_ENG_BOM_SMT 
//     WHERE PARENT_ITEM_CODE =  :lvs_smt_model_name 
//		AND LINE_CODE = :lvs_line_code
//		AND ORGANIZATION_ID = :gvi_organization_id 
//		AND PCB_ITEM = :lvs_pcb_item
//		AND NVL(FEEDER_SHAFT,'A')  ='A' ;
//		
//		IF F_SQL_CHECK() < 0 THEN 
//		    RETURN
//		END IF 
//		
//		IF LVI_COUNT = 0 THEN 
//			MESSAGEBOX('Notify' , lvs_line_code+  +lvs_smt_model_name+ 'A $$HEX15$$95cd15c8f4bc7cb920007cb920003ecc44c718c22000c6c5b5c2c8b2e4b2$$ENDHEX$$')
//			RETURN 
//		END IF 
//		
//	 LVI_COUNT_EIXTIS = 0 ;
//     SELECT COUNT(*) 
//	    INTO :LVI_COUNT_EIXTIS
//       FROM ID_ENG_BOM_SMT 
//     WHERE PARENT_ITEM_CODE =  :lvs_smt_model_name 
//		AND LINE_CODE = :lvs_line_code
//		AND PCB_ITEM = :lvs_pcb_item 
//		AND ORGANIZATION_ID = :gvi_organization_id
//		AND NVL(FEEDER_SHAFT,'*')  = :lvs_dest_shaft ;
//		
//		IF F_SQL_CHECK() < 0 THEN 
//		    RETURN
//		END IF 
//
//		IF LVI_COUNT_EIXTIS > 0 THEN 
//			MSG = MESSAGEBOX('Notify' , lvs_line_code+  +lvs_smt_model_name+ '$$HEX20$$74c7f8bb200074c8acc7200069d5c8b2e4b22000adc01cc8c4d62000f1b45db860d54cae94c62000$$ENDHEX$$?' , QUESTION! ,  YESNO!)
//			IF MSG = 1 THEN 
//				
//				DELETE FROM ID_ENG_BOM_SMT 
//					  WHERE PARENT_ITEM_CODE = :lvs_smt_model_name
//						  AND LINE_CODE = :lvs_line_code 
//						  AND PCB_ITEM = :lvs_pcb_item 
//						  AND  NVL(FEEDER_SHAFT,'*') = :lvs_dest_shaft
//						  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID 	;
//				
//						IF F_SQL_CHECK() < 0 THEN 
//		 				   RETURN
//						END IF 
//			ELSE
//					RETURN 
//			END IF 
//			
//		END IF 		
//	
//			//========================================		
//			//
//			//========================================	


 SELECT COUNT(*) 
       INTO :LVI_COUNT
       FROM ID_ENG_BOM_SMT 
     WHERE PARENT_ITEM_CODE =  :lvs_smt_model_name 
      AND LINE_CODE = :lvs_line_code
      AND ORGANIZATION_ID = :gvi_organization_id 
      AND PCB_ITEM = :lvs_pcb_item
      AND NVL(FEEDER_SHAFT,'A')  ='A' ;
      
      IF F_SQL_CHECK() < 0 THEN 
          RETURN
      END IF 
      
      IF LVI_COUNT = 0 THEN 
         MESSAGEBOX('Notify' , lvs_line_code+  +lvs_smt_model_name+ f_msg('A $$HEX15$$95cd15c8f4bc7cb920007cb920003ecc44c718c22000c6c5b5c2c8b2e4b2$$ENDHEX$$','S'))
         RETURN 
      END IF 
      
    LVI_COUNT_EIXTIS = 0 ;
     SELECT COUNT(*) 
       INTO :LVI_COUNT_EIXTIS
       FROM ID_ENG_BOM_SMT 
     WHERE PARENT_ITEM_CODE =  :lvs_smt_model_name 
      AND LINE_CODE = :lvs_line_code
      AND PCB_ITEM = :lvs_pcb_item 
      AND ORGANIZATION_ID = :gvi_organization_id
      AND NVL(FEEDER_SHAFT,'*')  IN (  '*' ,  'B' , 'C' , 'D' , 'E' , 'F'  , 'G' , 'H' ) ;
      
      IF F_SQL_CHECK() < 0 THEN 
          RETURN
      END IF 

      IF LVI_COUNT_EIXTIS > 0 THEN 
         MSG = MESSAGEBOX('Notify' , lvs_line_code+  +lvs_smt_model_name+ f_msg('$$HEX20$$74c7f8bb200074c8acc7200069d5c8b2e4b22000adc01cc8c4d62000f1b45db860d54cae94c62000$$ENDHEX$$?','S') , QUESTION! ,  YESNO!)
         IF MSG = 1 THEN 
            
            DELETE FROM ID_ENG_BOM_SMT 
                 WHERE PARENT_ITEM_CODE = :lvs_smt_model_name
                    AND LINE_CODE = :lvs_line_code 
                    AND PCB_ITEM = :lvs_pcb_item 
                    AND  NVL(FEEDER_SHAFT,'*') <> 'A' 
                    AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID    ;
            
                  IF F_SQL_CHECK() < 0 THEN 
                      RETURN
                  END IF 
         ELSE
               RETURN 
         END IF 
         
      END IF       
   
         //========================================      
         //
         //========================================   
			
			
		J = 1 ;	

DO 
      J++
      IF J = 2 THEN 
      lvs_dest_shaft = 'B'
      ELSEIF J = 3 THEN 
      lvs_dest_shaft = 'C'
      ELSEIF J = 4 THEN 
      lvs_dest_shaft = 'D'
      ELSEIF J = 5 THEN 
      lvs_dest_shaft = 'E'            
      ELSEIF J = 6 THEN 
      lvs_dest_shaft = 'F'
      ELSEIF J = 7 THEN 
      lvs_dest_shaft = 'G'                     
      //         ELSEIF J = 8 THEN 
      //            lvs_dest_shaft = 'H'
      END IF 
INSERT INTO ID_ENG_BOM_SMT  
				( PARENT_ITEM_CODE,   
				CHILD_ITEM_CODE,   
				BOM_LEVEL,   
				DATESET,   
				DATEEND,   
				LOCATION_CODE,   
				ORGANIZATION_ID,   
				SORT_SEQUENCE,   
				ITEM_UNIT_QTY,   
				WORKSTAGE_CODE,   
				BOM_WORK_NO,   
				ITEM_TYPE,   
				LINE_TYPE,   
				ENTER_BY,   
				ENTER_DATE,   
				LAST_MODIFY_BY,   
				LAST_MODIFY_DATE,   
				LOCATION_INFO,   
				LINE_CODE,   
				MACHINE,   
				LOSS_RATE,   
				SCRAP_RATE,   
				ASSY_EXPLOSION_YN,   
				ITEM_UNIT_QTY_EXT,   
				LOCATION_CODE_ORG,   
				VERSION,   
				PCB_ITEM,   
				MARKING_NO,   
				COMMENTS,   
				TABLE_ID,   
				FEEDER_TYPE ,
				REVISION ,
				FEEDER_SHAFT )  
	 SELECT :lvs_smt_model_name,   
				ID_ENG_BOM_SMT.CHILD_ITEM_CODE,   
				ID_ENG_BOM_SMT.BOM_LEVEL,   
				ID_ENG_BOM_SMT.DATESET,   
				ID_ENG_BOM_SMT.DATEEND,   
				
				DECODE( :lvs_shaft_chage , 'Y' , F_SET_FEEDER_SHAFT_CHANGE( :lvs_line_code , 'A' , :lvs_dest_shaft  ,  ID_ENG_BOM_SMT.LOCATION_CODE ) , LOCATION_CODE )  LOCATION_CODE,

				ID_ENG_BOM_SMT.ORGANIZATION_ID,   
				ID_ENG_BOM_SMT.SORT_SEQUENCE,   
				ID_ENG_BOM_SMT.ITEM_UNIT_QTY,   
				ID_ENG_BOM_SMT.WORKSTAGE_CODE,   
				ID_ENG_BOM_SMT.BOM_WORK_NO,   
				ID_ENG_BOM_SMT.ITEM_TYPE,   
				ID_ENG_BOM_SMT.LINE_TYPE,   
				ID_ENG_BOM_SMT.ENTER_BY,   
				ID_ENG_BOM_SMT.ENTER_DATE,   
				ID_ENG_BOM_SMT.LAST_MODIFY_BY,   
				ID_ENG_BOM_SMT.LAST_MODIFY_DATE,   
				ID_ENG_BOM_SMT.LOCATION_INFO,   
				:lvs_line_code , //ID_ENG_BOM_SMT.LINE_CODE,   
				:lvs_line_code|| substr( ID_ENG_BOM_SMT.MACHINE,3,2),   
				ID_ENG_BOM_SMT.LOSS_RATE,   
				ID_ENG_BOM_SMT.SCRAP_RATE,   
				ID_ENG_BOM_SMT.ASSY_EXPLOSION_YN,   
				ID_ENG_BOM_SMT.ITEM_UNIT_QTY_EXT,   
				ID_ENG_BOM_SMT.LOCATION_CODE_ORG,   
				ID_ENG_BOM_SMT.VERSION,   
				ID_ENG_BOM_SMT.PCB_ITEM,   
				ID_ENG_BOM_SMT.MARKING_NO,   
				ID_ENG_BOM_SMT.COMMENTS,   
				ID_ENG_BOM_SMT.TABLE_ID,   
				ID_ENG_BOM_SMT.FEEDER_TYPE  ,
				REVISION , 
				:LVS_DEST_SHAFT 
		FROM ID_ENG_BOM_SMT 
	  WHERE PARENT_ITEM_CODE = :lvs_smt_model_name
		  AND LINE_CODE = :lvs_line_code 
		  AND PCB_ITEM = :lvs_pcb_item 
		  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
		  AND NVL(FEEDER_SHAFT,'A') = 'A' ;

		IF F_SQL_CHECK_WITH_MSG( "DEST SHAFT="+LVS_DEST_SHAFT ) < 0 THEN 
			RETURN
		END IF

loop until j = 7 
commit ;
f_msgbox(170)					

end event

type st_revision from so_statictext within w_smt_bom_excel_load_popup
integer x = 2551
integer y = 268
integer width = 265
boolean bringtotop = true
string text = "Revision"
end type

type ddlb_revision from uo_mfs_bom_revision_dynamic within w_smt_bom_excel_load_popup
integer x = 2551
integer y = 352
integer width = 265
integer taborder = 20
boolean bringtotop = true
end type

type cbx_direct from so_checkbox within w_smt_bom_excel_load_popup
integer x = 3634
integer y = 272
integer width = 270
integer height = 68
boolean bringtotop = true
string text = "Direct"
end type

event clicked;call super::clicked;if this.checked = true then 
	cb_direct.enabled  = true 
else
	cb_direct.enabled  = false 	
end if 
end event

type ddlb_direct_shaft from so_dropdownlistbox within w_smt_bom_excel_load_popup
integer x = 3634
integer y = 340
integer width = 270
integer taborder = 100
boolean bringtotop = true
boolean allowedit = true
string item[] = {"H"}
end type

type cb_direct from commandbutton within w_smt_bom_excel_load_popup
integer x = 3913
integer y = 268
integer width = 393
integer height = 156
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Paste"
end type

event clicked;int i

msg = f_msgbox1(1161 , this.text )
if msg =1 then 
else
	return 
end if 

if rb_normal.checked = true then 

		dw_2.reset()
		dw_2.importclipboard( )	
		
		delete from id_eng_bom_excel_2 ;
		
		if f_sql_check() < 0 then 
			return 
		end if 
	
		if dw_2.update() < 0 then 
			rollback;
		else
			commit;
			
			f_msgbox(170) 
		end if
		
end if 
//===================================
//
//===================================

lvs_smt_model_name  =  ddlb_smt_model_name.getcode()
lvs_line_code =  ddlb_line_code.getcode()
lvs_pcb_item = ddlb_pcb_item.getcode()
lvs_revision = ddlb_revision.getcode() 
lvs_direct_shaft = ddlb_direct_shaft.text

if isnull(lvs_smt_model_name)  or lvs_smt_model_name = '' or lvs_smt_model_name = '%' then 	
	f_msgbox1(102 , st_smt_model_name.text )
	return
end if 

if isnull(lvs_line_code)  or lvs_line_code = '' or lvs_line_code = '%' then 	
	f_msgbox1(102 , st_line_code.text )
	return
end if 

if isnull(lvs_pcb_item)  or lvs_pcb_item = '' or lvs_pcb_item = '%' then 	
	f_msgbox1(102 , st_pcb_item.text )
	return
end if 

if isnull(lvs_revision)  or lvs_revision = '' or lvs_revision = '%' then 	
	f_msgbox1(102 , st_revision.text )
	return
end if 

INT LVI_COUNT
SELECT COUNT(*) INTO :LVI_COUNT 
  FROM ID_MFS_BOM 
WHERE ITEM_CODE = ( SELECT ITEM_CODE FROM IP_PRODUCT_MODEL_MASTER WHERE SMT_MODEL_NAME = :lvs_smt_model_name ) 
   AND MFS = :LVS_REVISION 
   AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	
if f_sql_check() < 0 then 
	return 
end if 	

if lvi_count = 0 then 
     //Mes sagebox("Error" , "Revision $$HEX9$$44c7200055d678c7200058d538c194c62000$$ENDHEX$$")
	f_msg( "Revision $$HEX8$$44c7200055d678c7200058d538c194c6$$ENDHEX$$",'S')
	return 
end if 

//==============================================
//
//==============================================

delete from id_eng_bom_excel_3 ;

if f_sql_check() < 0 then 
	return 
end if 

dw_1.reset()
dw_1.importclipboard( )	

do
	i++
	
	dw_1.object.model_name[i] =lvs_smt_model_name
	dw_1.object.line_code[i] =lvs_line_code
	dw_1.object.pcb_item[i] =  lvs_pcb_item
	
	if   mid( dw_1.object.g[i] ,1,1)  =  '1' then 
		dw_1.object.g[i] = string( long( mid(dw_1.object.g[i],1,1)) + 4 ) + trim(mid( dw_1.object.g[i] , 2, 10))
	end if 
	if   mid( dw_1.object.h[i] ,1,1)  =  '2' then 
		dw_1.object.h[i] = string( long( mid(dw_1.object.h[i],1,1)) + 4 ) + trim(mid( dw_1.object.h[i] , 2, 10))
	end if 
	if   mid( dw_1.object.i[i] ,1,1)  =  '3' then 
		dw_1.object.i[i] = string( long( mid(dw_1.object.i[i],1,1)) + 4 ) + trim(mid( dw_1.object.i[i] , 2, 10))
	end if 
	if   mid( dw_1.object.j[i] ,1,1)  =  '4' then 
		dw_1.object.j[i] = string( long( mid(dw_1.object.j[i],1,1)) + 4 ) + trim(mid( dw_1.object.j[i] , 2, 10))
	end if 	


		if mid( dw_1.object.k[i] ,1,1)  =  '1' 	then 
			dw_1.object.k[i] = string( long( mid(dw_1.object.k[i],1,1)) + 8 ) + trim(mid( dw_1.object.k[i] , 2, 10))
		end if 
			if mid( dw_1.object.L[i] ,1,1)  =  '2' 	then 
			dw_1.object.L[i] = string( long( mid(dw_1.object.L[i],1,1)) + 8 ) + trim(mid( dw_1.object.L[i] , 2, 10))
		end if 
		
		if mid( dw_1.object.m[i] ,1,1)  =  '3' 	then 
			dw_1.object.m[i] = string( long( mid(dw_1.object.m[i],1,1)) + 8 ) + trim(mid( dw_1.object.m[i] , 2, 10))
		end if 
		
		if mid( dw_1.object.n[i] ,1,1)  =  '4' 	then 
			dw_1.object.n[i] = string( long( mid(dw_1.object.n[i],1,1)) + 8 ) + trim(mid( dw_1.object.n[i] , 2, 10))
		end if 
	
loop until i = dw_1.rowcount( )

// SME $$HEX17$$0cd37cc720002cc6acb9200024c658b920005cb8200078c774d5200098ccacb92000$$ENDHEX$$
//dw_1.RowsCopy(dw_1.rowcount(), dw_1.RowCount(), Primary!, dw_1, dw_1.rowcount(), Primary!)

msg = f_msgbox1(1161 , 'Process' )
if msg =1 then 
	

		//=====================================================
		//
		//=====================================================
		if rb_simple.checked = true then 
			
				LVDB_SESSION_ID = 0 ;
				LVS_SET_ITEM_CODE = ''
				LVS_MODEL_NAME = ''
				
				LVS_SET_ITEM_CODE   =  ddlb_model_name.GETITEM( )
				LVS_MODEL_NAME        =  ddlb_model_name.getcode()
					
				if isnull(LVS_SET_ITEM_CODE)  or LVS_SET_ITEM_CODE = '' or LVS_SET_ITEM_CODE = '%' then 	
					f_msgbox1(102 , st_model_name.text )
					return
				end if 
			
			
				//======================================================
				//
				//======================================================
			
			
				st_msg.text = "Delete Excel Temp..."
				delete from id_eng_bom_excel_2 ;
				if f_sql_check() < 0 then 
					return 
				end if 
	
				
	         DELETE FROM   id_eng_bom_smt
              WHERE     parent_item_code = :lvs_smt_model_name
                      AND line_code = :lvs_line_code
                      AND pcb_item = :lvs_pcb_item
                      AND nvl(revision , '0000')  = nvl(:lvs_revision ,'0000') ;
				
				if f_sql_check() < 0 then 
					return 
				end if
				
				//=============================================
				//
				//=============================================
				st_msg.text = "Update Excel..."
				if dw_1.update() < 0 then 
					rollback;
					return 
				end if
				
				   INSERT INTO ID_ENG_BOM_EXCEL_2 (SEQ,
                                   PARENT_PART_NO,
                                   PART_NO,
                                   LINE_CODE,
                                   MACHINE,
                                   LOCATION,
                                   ITEM_SPEC,
                                   LOCATION_INFO,
                                   COMPONENT_QTY,
                                   PCB_ITEM,
                                   VERSION,
                                   CREATE_DATE,
                                   MARKING_NO,
                                   CHARGER,
                                   COMMENTS,
                                   REPLACE_ITEM_CODE,
                                   TABLE_ID,
                                   REVISION,
                                   FEEDER_SHAFT)
      SELECT MAX (ROWNUM),
             MODEL_NAME,
             ITEM_CODE,
             LINE_CODE,
             MACHINE_CODE,
             TRIM(LOCATION_CODE),
             '',
             listagg (LOCATION_INFOR, ',')
                WITHIN GROUP (ORDER BY LOCATION_INFOR)
                AS LOCATION_INFOR,
             COUNT (*),
             PCB_ITEM,
             '0000',
             trunc(SYSDATE),
             '',
             '',
             '',
             '',
             TABLE_ID,
             '0000' ,
             :lvs_direct_shaft // DEFAULT 'A'
        FROM (SELECT ROWNUM,
                     LINE_CODE,
                     LINE_CODE AS MACHINE_CODE,
                     MODEL_NAME,
                     ITEM_CODE,
                     LOCATION_INFOR,
                     
                     TRIM(C || D || E || F || G || H || I || J||K||L||M||N||O||P||Q) ,
                     
                     SUBSTR (
                       TRIM(C || D || E || F || G || H || I || J||K||L||M||N||O||P||Q),
                        1,
                        INSTR ( TRIM(C || D || E || F || G || H || I || J||K||L||M||N||O||P||Q), 'T', 1))
                        TABLE_ID,
                        
                        
                     TRIM(C || D || E || F || G || H || I || J||K||L||M||N||O||P||Q)  AS LOCATION_CODE,

                     PCB_ITEM
                FROM ID_ENG_BOM_EXCEL_3)
				GROUP BY LINE_CODE,
							MODEL_NAME,
							ITEM_CODE,
							PCB_ITEM,
							TRIM(LOCATION_CODE),
							TABLE_ID;
							
				if f_sql_check() < 0 then 
					return 
				end if
			   //==============================================	
			   //	
			   //==============================================
				st_msg.text = "ERP BOM Explosion"
				LVDB_SESSION_ID       = F_BOM_QUERY_PRC( LVS_SET_ITEM_CODE , F_T_SYSDATE())
				
				IF LVDB_SESSION_ID <= 0 THEN
					F_MSGBOX1(9051 ,LVS_SET_ITEM_CODE  )        
				ELSE
					
						 //=============================================
						 //   $$HEX6$$88d4a9ba200044be50ad2000$$ENDHEX$$
						 //=============================================	 
						 STRING  LVS_CHILD_COUNT
						 
						SELECT  max(CHILD_ITEM_CODE) INTO :LVS_CHILD_COUNT FROM 
						    (
								SELECT CHILD_ITEM_CODE  FROM ID_ENG_BOM_SMT 
								WHERE PARENT_ITEM_CODE = :lvs_smt_model_name
								AND LINE_CODE = :LVS_line_code
								AND PCB_ITEM = :lvs_pcb_item
								AND FEEDER_SHAFT  =:lvs_direct_shaft
								
								MINUS 
								
								SELECT CHILD_ITEM_CODE  
								  FROM ID_ENG_BOM_TEMP 
								 WHERE SESSION_ID = :LVDB_SESSION_ID 
								
							);
		
							if f_sql_check() < 0 then 
								return 
							end if
							
							if LVS_CHILD_COUNT <> ''  THEN 
								messagebox("Error" , LVS_CHILD_COUNT+ f_msg(" Not Found",'S') )
								st_msg.text = f_msg("ERP BOM / Feeder Layout Unmatch.",'S')
								rollback ;	
								return 
							else
									st_msg.text = STRING(LVDB_SESSION_ID) +f_msg(" : ERP BOM Retrieve...",'S')
									DW_3.RETRIEVE( LVDB_SESSION_ID ,  LVS_LINE_CODE , lvs_smt_model_name ,  ddlb_pcb_item.getcode() ,   GVI_ORGANIZATION_ID )
									DW_3.SETFOCUS()
							end if 
				END IF		
		
//				if dw_3.rowcount( ) > 0 then 
//					st_msg.text = "ERP BOM / Feeder Layout Unmatch."
//					rollback ;
//				else
					cb_shaft_copy.enabled = true 
					commit ;
					f_msgbox(170) 
					st_msg.text = "OK"
		//		end if 
		
				COMMIT ; 
		end if
//====================================================
//
//====================================================
else
	return 
end if 

st_msg.text = "Done"

end event

type gb_3 from so_groupbox within w_smt_bom_excel_load_popup
integer y = 196
integer width = 475
integer height = 264
integer taborder = 40
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_smt_bom_excel_load_popup
integer x = 480
integer y = 196
integer width = 4786
integer height = 264
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

