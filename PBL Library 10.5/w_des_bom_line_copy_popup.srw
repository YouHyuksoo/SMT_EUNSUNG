HA$PBExportHeader$w_des_bom_line_copy_popup.srw
forward
global type w_des_bom_line_copy_popup from w_popup_root
end type
type gb_2 from so_groupbox within w_des_bom_line_copy_popup
end type
type cb_1 from so_commandbutton within w_des_bom_line_copy_popup
end type
type st_source from so_statictext within w_des_bom_line_copy_popup
end type
type uo_dateset from uo_ymd_calendar within w_des_bom_line_copy_popup
end type
type st_1 from so_statictext within w_des_bom_line_copy_popup
end type
type st_dest_line_code from so_statictext within w_des_bom_line_copy_popup
end type
type st_source_line_code from so_statictext within w_des_bom_line_copy_popup
end type
type ddlb_source_line_code from uo_line_code within w_des_bom_line_copy_popup
end type
type cbx_all from so_checkbox within w_des_bom_line_copy_popup
end type
type cbx_replace_item_only from so_checkbox within w_des_bom_line_copy_popup
end type
type cbx_ignore_line_code from so_checkbox within w_des_bom_line_copy_popup
end type
type ddlb_model_name from uo_model_name_ddlb within w_des_bom_line_copy_popup
end type
type lb_line from so_listbox within w_des_bom_line_copy_popup
end type
end forward

global type w_des_bom_line_copy_popup from w_popup_root
integer width = 1993
integer height = 1700
string title = "BOM Copy"
gb_2 gb_2
cb_1 cb_1
st_source st_source
uo_dateset uo_dateset
st_1 st_1
st_dest_line_code st_dest_line_code
st_source_line_code st_source_line_code
ddlb_source_line_code ddlb_source_line_code
cbx_all cbx_all
cbx_replace_item_only cbx_replace_item_only
cbx_ignore_line_code cbx_ignore_line_code
ddlb_model_name ddlb_model_name
lb_line lb_line
end type
global w_des_bom_line_copy_popup w_des_bom_line_copy_popup

type variables

end variables

on w_des_bom_line_copy_popup.create
int iCurrent
call super::create
this.gb_2=create gb_2
this.cb_1=create cb_1
this.st_source=create st_source
this.uo_dateset=create uo_dateset
this.st_1=create st_1
this.st_dest_line_code=create st_dest_line_code
this.st_source_line_code=create st_source_line_code
this.ddlb_source_line_code=create ddlb_source_line_code
this.cbx_all=create cbx_all
this.cbx_replace_item_only=create cbx_replace_item_only
this.cbx_ignore_line_code=create cbx_ignore_line_code
this.ddlb_model_name=create ddlb_model_name
this.lb_line=create lb_line
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_2
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.st_source
this.Control[iCurrent+4]=this.uo_dateset
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_dest_line_code
this.Control[iCurrent+7]=this.st_source_line_code
this.Control[iCurrent+8]=this.ddlb_source_line_code
this.Control[iCurrent+9]=this.cbx_all
this.Control[iCurrent+10]=this.cbx_replace_item_only
this.Control[iCurrent+11]=this.cbx_ignore_line_code
this.Control[iCurrent+12]=this.ddlb_model_name
this.Control[iCurrent+13]=this.lb_line
end on

on w_des_bom_line_copy_popup.destroy
call super::destroy
destroy(this.gb_2)
destroy(this.cb_1)
destroy(this.st_source)
destroy(this.uo_dateset)
destroy(this.st_1)
destroy(this.st_dest_line_code)
destroy(this.st_source_line_code)
destroy(this.ddlb_source_line_code)
destroy(this.cbx_all)
destroy(this.cbx_replace_item_only)
destroy(this.cbx_ignore_line_code)
destroy(this.ddlb_model_name)
destroy(this.lb_line)
end on

type p_title from w_popup_root`p_title within w_des_bom_line_copy_popup
integer width = 1947
end type

type cb_sort from w_popup_root`cb_sort within w_des_bom_line_copy_popup
integer x = 562
integer y = 1856
integer width = 320
integer height = 140
integer taborder = 70
integer weight = 400
end type

type cb_close from w_popup_root`cb_close within w_des_bom_line_copy_popup
boolean visible = true
integer x = 923
integer y = 1464
integer width = 320
integer height = 140
integer taborder = 60
integer weight = 400
end type

event cb_close::clicked;call super::clicked;MESSAGE.DOUBLEPARM = -1
end event

type st_msg from w_popup_root`st_msg within w_des_bom_line_copy_popup
boolean visible = true
integer y = 200
integer width = 1947
end type

type dw_1 from w_popup_root`dw_1 within w_des_bom_line_copy_popup
boolean visible = true
integer y = 1972
integer taborder = 0
boolean titlebar = true
end type

type dw_2 from w_popup_root`dw_2 within w_des_bom_line_copy_popup
boolean visible = true
integer x = 9
integer y = 1952
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_des_bom_line_copy_popup
integer y = 1796
integer taborder = 80
end type

type gb_2 from so_groupbox within w_des_bom_line_copy_popup
integer y = 328
integer width = 1966
integer height = 1096
integer weight = 700
long textcolor = 16711680
string text = "Copy Condition"
end type

type cb_1 from so_commandbutton within w_des_bom_line_copy_popup
integer x = 599
integer y = 1464
integer width = 320
integer height = 140
integer taborder = 50
boolean bringtotop = true
integer weight = 400
string text = "Copy"
end type

event clicked;string      lvs_dest_parent_item_code , lvs_source_parent_item_code , lvs_source_line_code , lvs_dest_line_code 
datetime lvdt_dateset
int lvi_count , i , lvi_count_replace , lvi_count_delete, lvi_count_bom

//====================================================
// $$HEX9$$20c1ddd01cb48cac2000c6c5e4b274ba2000$$ENDHEX$$return
//====================================================
if lb_line.totalselected( ) = 0 then return

//====================================================
//
//====================================================
lvdt_dateset = uo_dateset.text()

if isnull(ddlb_source_line_code.text  ) then 	
	f_msgbox1(102 , st_source_line_code.text )
	return
else
	lvs_source_line_code =  ddlb_source_line_code.getcode( )
end if 
//==========================================
//
//==========================================
if isnull(ddlb_model_name.getcode()) and cbx_all.checked = false then 	
	f_msgbox1(102 , st_source.text )
	return
else
	
if cbx_all.checked = true then 
	lvs_source_parent_item_code = '%'
else
	lvs_source_parent_item_code = ddlb_model_name.getcode()
end if 
	
end if 

if cbx_all.checked = true then 
	lvs_dest_parent_item_code = '%'
else
	lvs_dest_parent_item_code =ddlb_model_name.getcode()
end if

if cbx_all.checked = true then  
else
	if lvs_source_parent_item_code = lvs_dest_parent_item_code and lvs_source_line_code = lvs_dest_line_code then 
		f_msgbox1(813 , lvs_dest_parent_item_code )	
		return
	end if 
end if

//========================================================
// Source Model $$HEX21$$d0c5200000b374d520003cd554b308b874c744c5c3c674c7200074c8acc758d594b2c0c9200055d678c7$$ENDHEX$$
//========================================================

lvi_count_bom = 0

 select count(*) 
    into :lvi_count_bom
  from id_eng_bom_smt 
where parent_item_code =  :lvs_source_parent_item_code 
   and line_code = :lvs_source_line_code
   and organization_id = :gvi_organization_id ;
								
if ( f_sql_check() < 0 ) then 
	
   return
	
end if 	

if lvi_count_bom = 0 then 
   
   Messagebox("Notify" ,"Not Found "+lvs_source_parent_item_code+'  '+lvs_source_line_code )
   ddlb_source_line_code.setfocus( )
   return
	
end if
																
//========================================		
// $$HEX16$$20c1ddd05cd520007cb778c7d0c5200000b374d52000f5bcacc0200098ccacb9$$ENDHEX$$
//========================================
			
do
	
	i++
	
	st_msg.text= string(i)+ "/ "+string(lb_line.totalitems( )) 	
	
	if lb_line.state(i) = 1 then 
		lvs_dest_line_code =TRIM(MID( lb_line.text(i) ,  POS( lb_line.text(i) , ':' ) +1 , 100  ))	
	else
	    continue 
	end if
	
			//========================================		
			//
			//========================================
			if cbx_replace_item_only.checked = true then 
				 //$$HEX11$$00b3b4cc88d4ccb92000f5bcacc0200058d530ae2000$$ENDHEX$$
			//=========================================
			//
			//=========================================
			else
				
								select count(*) into :lvi_count
						  		from id_eng_bom_smt 
								where parent_item_code like  :lvs_source_parent_item_code 
								and line_code = :lvs_dest_line_code
								and organization_id = :gvi_organization_id ;
								
								if f_sql_check() < 0 then 
									return
								end if 	
								
							if  lvi_count> 0 then 
							  
									  delete from id_eng_bom_smt
									  where parent_item_code like  :lvs_source_parent_item_code 
										and line_code = :lvs_dest_line_code
										and organization_id = :gvi_organization_id ;
										
										if f_sql_check() < 0 then 
											return
										end if 			
								
							end if 
			//========================================		
			//
			//========================================		
			
				INSERT INTO "ID_ENG_BOM_SMT"  
								( "PARENT_ITEM_CODE",   
								"CHILD_ITEM_CODE",   
								"BOM_LEVEL",   
								"DATESET",   
								"DATEEND",   
								"LOCATION_CODE",   
								"ORGANIZATION_ID",   
								"SORT_SEQUENCE",   
								"ITEM_UNIT_QTY",   
								"WORKSTAGE_CODE",   
								"BOM_WORK_NO",   
								"ITEM_TYPE",   
								"LINE_TYPE",   
								"ENTER_BY",   
								"ENTER_DATE",   
								"LAST_MODIFY_BY",   
								"LAST_MODIFY_DATE",   
								"LOCATION_INFO",   
								"LINE_CODE",   
								"MACHINE",   
								"LOSS_RATE",   
								"SCRAP_RATE",   
								"ASSY_EXPLOSION_YN",   
								"ITEM_UNIT_QTY_EXT",   
								"LOCATION_CODE_ORG",   
								"VERSION",   
								"PCB_ITEM",   
								"MARKING_NO",   
								"COMMENTS",   
								"TABLE_ID",   
								"FEEDER_TYPE" ,
								REVISION,
								feeder_shaft,
                                    feeder_shaft_status,
                                    item_barcode,
                                    master_model_name ,
                                    model_name,
                                    smt_model_name
							)  
					 SELECT "ID_ENG_BOM_SMT"."PARENT_ITEM_CODE",   
								"ID_ENG_BOM_SMT"."CHILD_ITEM_CODE",   
								"ID_ENG_BOM_SMT"."BOM_LEVEL",   
								"ID_ENG_BOM_SMT"."DATESET",   
								"ID_ENG_BOM_SMT"."DATEEND",   
								"ID_ENG_BOM_SMT"."LOCATION_CODE",   
								"ID_ENG_BOM_SMT"."ORGANIZATION_ID",   
								"ID_ENG_BOM_SMT"."SORT_SEQUENCE",   
								"ID_ENG_BOM_SMT"."ITEM_UNIT_QTY",   
								"ID_ENG_BOM_SMT"."WORKSTAGE_CODE",   
								"ID_ENG_BOM_SMT"."BOM_WORK_NO",   
								"ID_ENG_BOM_SMT"."ITEM_TYPE",   
								"ID_ENG_BOM_SMT"."LINE_TYPE",   
								"ID_ENG_BOM_SMT"."ENTER_BY",   
								"ID_ENG_BOM_SMT"."ENTER_DATE",   
								"ID_ENG_BOM_SMT"."LAST_MODIFY_BY",   
								"ID_ENG_BOM_SMT"."LAST_MODIFY_DATE",   
								"ID_ENG_BOM_SMT"."LOCATION_INFO",   
								:lvs_dest_line_code , //"ID_ENG_BOM_SMT"."LINE_CODE",   
								"ID_ENG_BOM_SMT"."MACHINE",   
								"ID_ENG_BOM_SMT"."LOSS_RATE",   
								"ID_ENG_BOM_SMT"."SCRAP_RATE",   
								"ID_ENG_BOM_SMT"."ASSY_EXPLOSION_YN",   
								"ID_ENG_BOM_SMT"."ITEM_UNIT_QTY_EXT",   
								"ID_ENG_BOM_SMT"."LOCATION_CODE_ORG",   
								"ID_ENG_BOM_SMT"."VERSION",   
								"ID_ENG_BOM_SMT"."PCB_ITEM",   
								"ID_ENG_BOM_SMT"."MARKING_NO",   
								"ID_ENG_BOM_SMT"."COMMENTS",   
								"ID_ENG_BOM_SMT"."TABLE_ID",   
								"ID_ENG_BOM_SMT"."FEEDER_TYPE"  ,
								"ID_ENG_BOM_SMT"."REVISION" ,
							    	"ID_ENG_BOM_SMT"."FEEDER_SHAFT",
                                    "ID_ENG_BOM_SMT"."FEEDER_SHAFT_STATUS",
                                    "ID_ENG_BOM_SMT"."ITEM_BARCODE",
                                   "ID_ENG_BOM_SMT"."MASTER_MODEL_NAME" ,
                                    "ID_ENG_BOM_SMT"."MODEL_NAME",
                                    "ID_ENG_BOM_SMT"."SMT_MODEL_NAME"
								FROM "ID_ENG_BOM_SMT" 
								WHERE PARENT_ITEM_CODE = :lvs_source_parent_item_code
								AND LINE_CODE = :lvs_source_line_code 
								AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
								
								if f_sql_check() < 0 then 
									return
								end if
				end if  //replace only
//===========================================
// $$HEX8$$00b3b4cc88d4a9ba200000adacb92000$$ENDHEX$$
//===========================================

	lvi_count_replace = 0
	
     select count(*) into :lvi_count_replace
       from id_eng_bom_smt_replace 
     where parent_item_code like  :lvs_source_parent_item_code 
		and line_code LIKE :lvs_source_line_code
		and organization_id = :gvi_organization_id ;
		
		if f_sql_check() < 0 then 
			return
		end if 	
		
//	if  lvi_count_replace > 0 then 
//		
//		//$$HEX25$$7cb778c744c7200034bbdcc258d5e0ac200000b3b4cc88d474c7200074c8acc7200058d574ba2000a4c2b5d05cd5e4b22000$$ENDHEX$$
//		//$$HEX8$$15c8a8b004c890c72000bdacb0c62000$$ENDHEX$$
//		//$$HEX35$$c0c918c294b220007cb778c7c4bcc4b3200000b3b4cc88d444c7200000adacb9200058d5c0bb5cb8200000b3c1c07cb778c7d0c52000f5bcacc0200074d5200000c9e4b22000$$ENDHEX$$
//		if cbx_ignore_line_code.checked = true then 
//			continue
//		end if 
//		
//	else
//		continue
//	end if 		
	
	lvi_count_delete = 0 
	
     select count(*) into :lvi_count_delete
       from id_eng_bom_smt_replace 
     where parent_item_code =  :lvs_source_parent_item_code 
		and line_code = :lvs_dest_line_code
		and organization_id = :gvi_organization_id ;
		
		if f_sql_check() < 0 then 
			return
		end if 		
		
	if lvi_count_delete > 0 then 
		
		  delete from id_eng_bom_smt_replace
		  where parent_item_code =  :lvs_source_parent_item_code 
			and line_code = :lvs_dest_line_code
			and organization_id = :gvi_organization_id ;
			
			if f_sql_check() < 0 then 
				return
			end if 			
	end if 
	
			  insert into id_eng_bom_smt_replace  
						( parent_item_code,   
						  child_item_code,   
						  replace_item_code ,
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
						  last_modify_date ,
						  line_code ,
						  machine ,
						  version ,
						  marking_no,
						  pcb_item ,
						  comments,
						  TABLE_ID,
						  FEEDER_TYPE,
						  REVISION,
						  feeder_shaft,
                             location_info,
                             smt_model_name
					  )  
				  select   distinct decode( :lvs_dest_parent_item_code , '%' , id_eng_bom_smt_replace.parent_item_code,  :lvs_dest_parent_item_code ) , //:lvs_dest_parent_item_code , //id_eng_bom.parent_item_code,   
							id_eng_bom_smt_replace.child_item_code,   
							id_eng_bom_smt_replace.replace_item_code ,
							id_eng_bom_smt_replace.bom_level,   
							id_eng_bom_smt_replace.dateset,   
							id_eng_bom_smt_replace.dateend,   
							id_eng_bom_smt_replace.location_code ,
							id_eng_bom_smt_replace.organization_id,   
							id_eng_bom_smt_replace.sort_sequence,   
							id_eng_bom_smt_replace.item_unit_qty,   
							id_eng_bom_smt_replace.workstage_code,   
							id_eng_bom_smt_replace.bom_work_no,   
							id_eng_bom_smt_replace.item_type,   
							id_eng_bom_smt_replace.line_type,   
							id_eng_bom_smt_replace.enter_by,   
							id_eng_bom_smt_replace.enter_date,   
							id_eng_bom_smt_replace.last_modify_by,   
							id_eng_bom_smt_replace.last_modify_date,
							:lvs_dest_line_code ,
							machine   ,   //id_eng_bom_replace.machine ,
							id_eng_bom_smt_replace.version ,
							id_eng_bom_smt_replace.marking_no,
							id_eng_bom_smt_replace.pcb_item ,
							id_eng_bom_smt_replace.comments,
							TABLE_ID,
							FEEDER_TYPE ,
							REVISION,
							feeder_shaft,
                               location_info,
                               smt_model_name
					 from id_eng_bom_smt_replace 
				  where parent_item_code =  :lvs_source_parent_item_code 
					and line_code = :lvs_source_line_code
					and organization_id = :gvi_organization_id  ;
					
					if f_sql_check() < 0 then 
						return
					end if
					
loop until  i = lb_line.totalitems( )

//=====================================
//
//=====================================
msg = f_msgbox1(9046 , 'BOM='+string(lvi_count_bom) +'  Replace='+string(lvi_count_replace))
if msg = 1 then 
	commit ;
	Close(parent)
else
	rollback;
	return ;
end if
end event

type st_source from so_statictext within w_des_bom_line_copy_popup
integer x = 18
integer y = 568
boolean bringtotop = true
string text = "Model Name"
alignment alignment = right!
end type

type uo_dateset from uo_ymd_calendar within w_des_bom_line_copy_popup
integer x = 539
integer y = 680
integer taborder = 30
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_1 from so_statictext within w_des_bom_line_copy_popup
integer x = 18
integer y = 692
boolean bringtotop = true
string text = "Dateset"
alignment alignment = right!
end type

type st_dest_line_code from so_statictext within w_des_bom_line_copy_popup
integer x = 18
integer y = 796
integer height = 68
boolean bringtotop = true
boolean enabled = false
string text = "Dest Line Code"
alignment alignment = right!
end type

type st_source_line_code from so_statictext within w_des_bom_line_copy_popup
integer x = 18
integer y = 468
integer height = 68
boolean bringtotop = true
boolean enabled = false
string text = "Source Line Code"
alignment alignment = right!
end type

type ddlb_source_line_code from uo_line_code within w_des_bom_line_copy_popup
integer x = 535
integer y = 464
integer taborder = 40
boolean bringtotop = true
end type

type cbx_all from so_checkbox within w_des_bom_line_copy_popup
integer x = 1175
integer y = 452
boolean bringtotop = true
string text = "All"
end type

type cbx_replace_item_only from so_checkbox within w_des_bom_line_copy_popup
integer x = 544
integer y = 1288
integer width = 713
boolean bringtotop = true
string text = "Replace Item Only"
end type

type cbx_ignore_line_code from so_checkbox within w_des_bom_line_copy_popup
integer x = 1093
integer y = 1288
integer width = 571
boolean bringtotop = true
string text = "Ignore Line Code"
end type

type ddlb_model_name from uo_model_name_ddlb within w_des_bom_line_copy_popup
integer x = 539
integer y = 556
integer taborder = 50
boolean bringtotop = true
end type

type lb_line from so_listbox within w_des_bom_line_copy_popup
integer x = 539
integer y = 784
integer width = 603
integer height = 496
integer taborder = 140
boolean bringtotop = true
integer weight = 400
boolean hscrollbar = true
boolean vscrollbar = true
boolean multiselect = true
end type

event constructor;call super::constructor;LONG I
STRING LVS_LINE_CODE , LVS_LINE_NAME , LVS_LINE_CODE_CONDITION

DECLARE CUR_01 CURSOR FOR 
	SELECT LINE_CODE , LINE_NAME 
  	  FROM  IP_PRODUCT_LINE
	 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
	      AND LINE_CODE <> '*' 
	      AND MES_DISPLAY_YN = 'Y';
	 
OPEN CUR_01 ;

THIS.RESET()
THIS.ADDITEM('%')

IF F_SQL_CHECK_WITH_MSG('OPEN FROM IP_PRODUCT_LINE') < 0 THEN 
	CLOSE CUR_01 ;
	RETURN
END IF	

DO 
	FETCH CUR_01 INTO :LVS_LINE_CODE , :LVS_LINE_NAME ;
	
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM IP_PRODUCT_LINE') < 0 THEN 
		CLOSE CUR_01 ;
		RETURN
	END IF	
	
	IF SQLCA.SQLCODE = 100 THEN 
		CLOSE CUR_01 ;		
		EXIT
	END IF 
	
	LVS_LINE_CODE = LVS_LINE_NAME +" : "+ LVS_LINE_CODE
	THIS.ADDITEM(LVS_LINE_CODE)
I++
F_MSG_MDI_HELP('UO_LINE_CODE : Construnctor-> '+STRING(I)+"Rows")  			
LOOP UNTIL 1 = 2
 THIS.Selectitem( 1)





end event

