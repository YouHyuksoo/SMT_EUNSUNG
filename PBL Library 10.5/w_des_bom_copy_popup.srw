HA$PBExportHeader$w_des_bom_copy_popup.srw
forward
global type w_des_bom_copy_popup from w_popup_root
end type
type gb_2 from so_groupbox within w_des_bom_copy_popup
end type
type cb_1 from so_commandbutton within w_des_bom_copy_popup
end type
type st_source from so_statictext within w_des_bom_copy_popup
end type
type st_dest from so_statictext within w_des_bom_copy_popup
end type
type st_dest_line_code from so_statictext within w_des_bom_copy_popup
end type
type st_source_line_code from so_statictext within w_des_bom_copy_popup
end type
type ddlb_source_model from uo_model_name_ddlb within w_des_bom_copy_popup
end type
type ddlb_dest_model from uo_model_name_ddlb within w_des_bom_copy_popup
end type
type ddlb_dest_line_code from uo_line_code within w_des_bom_copy_popup
end type
type ddlb_source_line_code from uo_line_code within w_des_bom_copy_popup
end type
type cbx_replace_include from so_checkbox within w_des_bom_copy_popup
end type
type rb_top from so_radiobutton within w_des_bom_copy_popup
end type
type rb_bottom from so_radiobutton within w_des_bom_copy_popup
end type
end forward

global type w_des_bom_copy_popup from w_popup_root
integer width = 1970
integer height = 1388
string title = "BOM Copy"
gb_2 gb_2
cb_1 cb_1
st_source st_source
st_dest st_dest
st_dest_line_code st_dest_line_code
st_source_line_code st_source_line_code
ddlb_source_model ddlb_source_model
ddlb_dest_model ddlb_dest_model
ddlb_dest_line_code ddlb_dest_line_code
ddlb_source_line_code ddlb_source_line_code
cbx_replace_include cbx_replace_include
rb_top rb_top
rb_bottom rb_bottom
end type
global w_des_bom_copy_popup w_des_bom_copy_popup

on w_des_bom_copy_popup.create
int iCurrent
call super::create
this.gb_2=create gb_2
this.cb_1=create cb_1
this.st_source=create st_source
this.st_dest=create st_dest
this.st_dest_line_code=create st_dest_line_code
this.st_source_line_code=create st_source_line_code
this.ddlb_source_model=create ddlb_source_model
this.ddlb_dest_model=create ddlb_dest_model
this.ddlb_dest_line_code=create ddlb_dest_line_code
this.ddlb_source_line_code=create ddlb_source_line_code
this.cbx_replace_include=create cbx_replace_include
this.rb_top=create rb_top
this.rb_bottom=create rb_bottom
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_2
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.st_source
this.Control[iCurrent+4]=this.st_dest
this.Control[iCurrent+5]=this.st_dest_line_code
this.Control[iCurrent+6]=this.st_source_line_code
this.Control[iCurrent+7]=this.ddlb_source_model
this.Control[iCurrent+8]=this.ddlb_dest_model
this.Control[iCurrent+9]=this.ddlb_dest_line_code
this.Control[iCurrent+10]=this.ddlb_source_line_code
this.Control[iCurrent+11]=this.cbx_replace_include
this.Control[iCurrent+12]=this.rb_top
this.Control[iCurrent+13]=this.rb_bottom
end on

on w_des_bom_copy_popup.destroy
call super::destroy
destroy(this.gb_2)
destroy(this.cb_1)
destroy(this.st_source)
destroy(this.st_dest)
destroy(this.st_dest_line_code)
destroy(this.st_source_line_code)
destroy(this.ddlb_source_model)
destroy(this.ddlb_dest_model)
destroy(this.ddlb_dest_line_code)
destroy(this.ddlb_source_line_code)
destroy(this.cbx_replace_include)
destroy(this.rb_top)
destroy(this.rb_bottom)
end on

type p_title from w_popup_root`p_title within w_des_bom_copy_popup
integer width = 1947
end type

type cb_sort from w_popup_root`cb_sort within w_des_bom_copy_popup
integer x = 0
integer y = 1424
integer width = 320
integer height = 140
integer taborder = 70
integer weight = 400
end type

type cb_close from w_popup_root`cb_close within w_des_bom_copy_popup
boolean visible = true
integer x = 960
integer y = 1100
integer width = 507
integer height = 140
integer taborder = 60
integer weight = 400
end type

event cb_close::clicked;call super::clicked;MESSAGE.DOUBLEPARM = -1
end event

type st_msg from w_popup_root`st_msg within w_des_bom_copy_popup
boolean visible = true
integer y = 200
integer width = 1947
end type

type dw_1 from w_popup_root`dw_1 within w_des_bom_copy_popup
boolean visible = true
integer y = 1424
integer taborder = 0
boolean titlebar = true
end type

type dw_2 from w_popup_root`dw_2 within w_des_bom_copy_popup
boolean visible = true
integer y = 1424
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_des_bom_copy_popup
integer y = 1424
integer taborder = 80
end type

type gb_2 from so_groupbox within w_des_bom_copy_popup
integer y = 328
integer width = 1947
integer height = 748
integer weight = 700
long textcolor = 16711680
string text = "Copy Condition"
end type

type cb_1 from so_commandbutton within w_des_bom_copy_popup
integer x = 421
integer y = 1100
integer width = 535
integer height = 140
integer taborder = 50
boolean bringtotop = true
integer weight = 400
string text = "Copy"
end type

event clicked;STRING lvs_dest_parent_item_code , lvs_source_parent_item_code , lvs_source_line_code , lvs_dest_line_code , lvs_pcb_item
STRING lvs_source_shaft , lvs_dest_shaft , lvs_shaft_chage
INT        LVI_COUNT_EIXTIS , LVI_COUNT
//====================================================
//
//====================================================
if rb_top.checked = true then 
	lvs_pcb_item = 'T'
else
	lvs_pcb_item = 'B'
end if 

if isnull(ddlb_source_line_code.getcode()) or ddlb_source_line_code.getcode() = '%'  then 	
	f_msgbox1(102 , st_source_line_code.text )
	return
else
	lvs_source_line_code = ddlb_source_line_code.getcode()
end if 

if isnull(ddlb_dest_line_code.getcode()) or ddlb_dest_line_code.getcode() = '%' then 	
	f_msgbox1(102 , st_dest_line_code.text )
	return
else
	lvs_dest_line_code = ddlb_dest_line_code.getcode()
end if 

//==========================================
//
//==========================================
if isnull( ddlb_source_model.getcode()) or ddlb_source_model.getcode() = '%' then 	
	f_msgbox1(102 , st_source.text )
	return
else
	lvs_source_parent_item_code = ddlb_source_model.getcode()
end if 

if isnull( ddlb_dest_model.getcode()) or ddlb_dest_model.getcode() = '%' then 
	f_msgbox1(102 , st_dest.text )	
	return
else
	lvs_dest_parent_item_code = ddlb_dest_model.getcode()
end if 

if   lvs_source_parent_item_code = lvs_dest_parent_item_code and lvs_source_line_code = lvs_dest_line_code  then 
	f_msgbox1(813 , lvs_dest_parent_item_code )	
	return
end if 

     LVI_COUNT = 0

     SELECT COUNT(*) 
	    INTO :LVI_COUNT
       FROM ID_ENG_BOM_SMT 
     WHERE PARENT_ITEM_CODE =  :lvs_source_parent_item_code 
		AND LINE_CODE = :lvs_source_line_code
		AND ORGANIZATION_ID = :gvi_organization_id 
		AND PCB_ITEM = :lvs_pcb_item;
		
		IF F_SQL_CHECK() < 0 THEN 
		    RETURN
		END IF 
		
		IF LVI_COUNT = 0 THEN 
			MESSAGEBOX('Notify' , '$$HEX5$$30ae00c920007cb778c7$$ENDHEX$$: ' + lvs_source_line_code+ ', $$HEX2$$a8ba78b3$$ENDHEX$$: '  +lvs_source_parent_item_code+ ' T/B:' + lvs_pcb_item + '  ' + f_msg('$$HEX10$$7cb920003ecc44c718c22000c6c5b5c2c8b2e4b2$$ENDHEX$$','S'))
			RETURN 
		END IF 
		
	 LVI_COUNT_EIXTIS = 0 ;
	 
     SELECT COUNT(*) 
	    INTO :LVI_COUNT_EIXTIS
       FROM ID_ENG_BOM_SMT 
     WHERE PARENT_ITEM_CODE =  :lvs_dest_parent_item_code 
		AND LINE_CODE = :lvs_dest_line_code
		AND PCB_ITEM = :lvs_pcb_item 
		AND ORGANIZATION_ID = :gvi_organization_id;
		
		IF F_SQL_CHECK() < 0 THEN 
		    RETURN
		END IF 

		IF LVI_COUNT_EIXTIS > 0 THEN 
			MESSAGEBOX('Notify' , '$$HEX5$$01c8a9c620007cb778c7$$ENDHEX$$: ' + lvs_dest_line_code+ ', $$HEX2$$a8ba78b3$$ENDHEX$$: '  +lvs_dest_parent_item_code+ ' T/B:' + lvs_pcb_item + '  ' + + f_msg('$$HEX23$$74c7f8bb200074c8acc7200069d5c8b2e4b22000adc01cc8c4d62000e4b2dcc22000dcc2c4b3200058d538c194c6$$ENDHEX$$','S'))
			RETURN 
		END IF 		
	
			//========================================		
			//
			//========================================		
			
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
								FEEDER_SHAFT,
                                    feeder_shaft_status,
                                    item_barcode,
                                    master_model_name ,
                                    model_name,
                                    smt_model_name)  
					 SELECT :lvs_dest_parent_item_code,   
								ID_ENG_BOM_SMT.CHILD_ITEM_CODE,   
								ID_ENG_BOM_SMT.BOM_LEVEL,   
								ID_ENG_BOM_SMT.DATESET,   
								ID_ENG_BOM_SMT.DATEEND,   
								ID_ENG_BOM_SMT.LOCATION_CODE ,   
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
								:lvs_dest_line_code , //ID_ENG_BOM_SMT.LINE_CODE,   
								:lvs_dest_line_code|| substr( ID_ENG_BOM_SMT.MACHINE,3,2),   
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
							     ID_ENG_BOM_SMT.REVISION , 
								ID_ENG_BOM_SMT.FEEDER_SHAFT,
								ID_ENG_BOM_SMT.FEEDER_SHAFT_STATUS,
                                    ID_ENG_BOM_SMT.ITEM_BARCODE,
                                    ID_ENG_BOM_SMT.MASTER_MODEL_NAME ,
                                    ID_ENG_BOM_SMT.MODEL_NAME,
                                    ID_ENG_BOM_SMT.SMT_MODEL_NAME
						FROM ID_ENG_BOM_SMT 
					  WHERE PARENT_ITEM_CODE = :lvs_source_parent_item_code
						  AND LINE_CODE = :lvs_source_line_code 
						  AND PCB_ITEM = :lvs_pcb_item 
						  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
						  AND NVL(FEEDER_SHAFT,'*') LIKE NVL(:LVS_SOURCE_SHAFT,'*') ;

		
						IF F_SQL_CHECK() < 0 THEN 
							RETURN
						END IF
//==================================================================
//
//==================================================================
if cbx_replace_include.checked = true then 

			insert into id_eng_bom_smt_replace (  parent_item_code,
						child_item_code,
						replace_item_code,
						bom_level,
						dateset,
						dateend,
						location_code,
						organization_id,
						sort_sequence,
						item_unit_qty,
						workstage_code,
						bom_work_no,
						item_type,
						line_type,
						enter_by,
						enter_date,
						last_modify_by,
						last_modify_date,
						line_code,
						machine,
						version,
						pcb_item,
						marking_no,
						comments,
						model_name,
						table_id,
						feeder_type,
						REVISION,
				  	     feeder_shaft,
                           location_info,
                           smt_model_name
					  ) 						
			SELECT  :lvs_dest_parent_item_code , //parent_item_code,
						child_item_code,
						replace_item_code,
						bom_level,
						dateset,
						dateend,
						location_code,
						organization_id,
						sort_sequence,
						item_unit_qty,
						workstage_code,
						bom_work_no,
						item_type,
						line_type,
						enter_by,
						enter_date,
						last_modify_by,
						last_modify_date,
						:lvs_dest_line_code , //line_code,
						:lvs_dest_line_code||substr(machine,3,2),
						version,
						pcb_item,
						marking_no,
						comments,
						:lvs_dest_parent_item_code , //model_name,
						table_id,
						feeder_type,
						REVISION,
						feeder_shaft,
                           location_info,
                           smt_model_name		
			  FROM   id_eng_bom_smt_replace 
				  WHERE PARENT_ITEM_CODE = :lvs_source_parent_item_code
									  AND LINE_CODE = :lvs_source_line_code 
									  AND PCB_ITEM = :lvs_pcb_item 
									  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
			
			
			IF F_SQL_CHECK() < 0 THEN 
				RETURN
			END IF
		end if 

MSG = F_MSGBOX1(9046 , STRING(LVI_COUNT) )
IF MSG = 1 THEN 
	COMMIT ;
ELSE
	ROLLBACK;
	RETURN ;
END IF
end event

type st_source from so_statictext within w_des_bom_copy_popup
integer x = 251
integer y = 560
boolean bringtotop = true
string text = "Source Model"
alignment alignment = right!
end type

type st_dest from so_statictext within w_des_bom_copy_popup
integer x = 261
integer y = 764
boolean bringtotop = true
string text = "Dest Model"
alignment alignment = right!
end type

type st_dest_line_code from so_statictext within w_des_bom_copy_popup
integer x = 261
integer y = 660
integer width = 489
integer height = 68
boolean bringtotop = true
boolean enabled = false
string text = "Dest Line Code"
alignment alignment = right!
end type

type st_source_line_code from so_statictext within w_des_bom_copy_popup
integer x = 261
integer y = 460
integer width = 489
integer height = 68
boolean bringtotop = true
boolean enabled = false
string text = "Source Line Code"
alignment alignment = right!
end type

type ddlb_source_model from uo_model_name_ddlb within w_des_bom_copy_popup
integer x = 786
integer y = 548
integer width = 631
integer taborder = 80
boolean bringtotop = true
end type

type ddlb_dest_model from uo_model_name_ddlb within w_des_bom_copy_popup
integer x = 786
integer y = 748
integer width = 631
integer taborder = 90
boolean bringtotop = true
end type

type ddlb_dest_line_code from uo_line_code within w_des_bom_copy_popup
integer x = 786
integer y = 648
integer taborder = 90
boolean bringtotop = true
end type

type ddlb_source_line_code from uo_line_code within w_des_bom_copy_popup
integer x = 786
integer y = 452
integer taborder = 10
boolean bringtotop = true
end type

type cbx_replace_include from so_checkbox within w_des_bom_copy_popup
integer x = 800
integer y = 956
boolean bringtotop = true
string text = "Include Replace"
boolean checked = true
end type

type rb_top from so_radiobutton within w_des_bom_copy_popup
integer x = 800
integer y = 856
integer width = 325
boolean bringtotop = true
string text = "Top"
boolean checked = true
end type

event clicked;call super::clicked;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
dw_3.SETFILTER('')
dw_3.FILTER()

dw_3.SETFILTER( 'PCB_ITEM  LIKE '+"'"+"T"+"'")
dw_3.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found")
end event

type rb_bottom from so_radiobutton within w_des_bom_copy_popup
integer x = 1134
integer y = 852
boolean bringtotop = true
string text = "Bottom"
end type

event clicked;call super::clicked;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
dw_3.SETFILTER('')
dw_3.FILTER()

dw_3.SETFILTER( 'PCB_ITEM  LIKE '+"'"+"B"+"'")
dw_3.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found")
end event

