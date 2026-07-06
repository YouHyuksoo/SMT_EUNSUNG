HA$PBExportHeader$w_des_product_class_master.srw
$PBExportComments$$$HEX6$$80bd88d42000c8b9a4c230d1$$ENDHEX$$
forward
global type w_des_product_class_master from w_main_root
end type
type st_1 from so_statictext within w_des_product_class_master
end type
type st_2 from so_statictext within w_des_product_class_master
end type
type sle_product_name from so_singlelineedit within w_des_product_class_master
end type
type ddlb_product_class_code from uo_product_class_code within w_des_product_class_master
end type
type gb_where_condition from so_groupbox within w_des_product_class_master
end type
end forward

global type w_des_product_class_master from w_main_root
integer width = 4736
integer height = 2904
string title = "Product Class Master"
st_1 st_1
st_2 st_2
sle_product_name sle_product_name
ddlb_product_class_code ddlb_product_class_code
gb_where_condition gb_where_condition
end type
global w_des_product_class_master w_des_product_class_master

on w_des_product_class_master.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
this.sle_product_name=create sle_product_name
this.ddlb_product_class_code=create ddlb_product_class_code
this.gb_where_condition=create gb_where_condition
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.sle_product_name
this.Control[iCurrent+4]=this.ddlb_product_class_code
this.Control[iCurrent+5]=this.gb_where_condition
end on

on w_des_product_class_master.destroy
call super::destroy
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_product_name)
destroy(this.ddlb_product_class_code)
destroy(this.gb_where_condition)
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
STRING LVS_SETYN
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		   
			DW_1.RETRIEVE(ddlb_product_class_code.text+'%' , gvi_organization_id )
			DW_1.SETFOCUS()
	CASE 'INSERT'
			dw_2.enabled = true
			row = dw_2.insertrow(dw_2.getrow())
			dw_2.scrolltorow(row)
			f_set_security_row(dw_2 , row , 'ALL')
			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
	CASE 'APPEND'
			dw_2.enabled = true
			row = dw_2.insertrow(dw_2.getrow())
			dw_2.scrolltorow(row)
			f_set_security_row(dw_2 , row , 'ALL')
			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
	CASE 'DELETE'
		
		  	if dw_2.getrow() < 1 then return 
			  
			msg =f_msgbox(1003)
			if msg = 1 then
				gvl_row_deleted = dw_2.getrow()			
				dw_2.deleterow(gvl_row_deleted)		
				dw_2.setfocus()
				row = dw_2.getrow()
				dw_2.scrolltorow(row)
				dw_2.setcolumn(1)
			end if
			ddlb_product_class_code.reload()
	CASE 'UPDATE'
		
		DW_1.ACCEPTTEXT()
		IF DW_1.ModifiedCount() > 0 OR DW_1.DELETEDCOUNT() > 0 THEN
 
	      IF dw_1.UPDATE() < 0 THEN
				ROLLBACK;
				RETURN
			ELSE
				 COMMIT;
      			 F_MSG_MDI_HELP ( F_MSG_ST(170)	 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			END IF
			
		ELSE
			F_MSG_MDI_HELP("Modified Data Not Found")
		END IF
		
		
		IF DW_2.ModifiedCount() > 0 OR DW_2.DELETEDCOUNT() > 0 THEN
 
	      IF dw_2.UPDATE() < 0 THEN
				ROLLBACK;
				RETURN
			ELSE
				 COMMIT;
   			      F_MSG_MDI_HELP ( F_MSG_ST(170)	 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
				 F_RETRIEVE()
			END IF
			
		ELSE
			F_MSG_MDI_HELP("Modified Data Not Found")
		END IF
			ddlb_product_class_code.reload()
	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_des_product_class_master
integer y = 320
end type

type dw_4 from w_main_root`dw_4 within w_des_product_class_master
integer x = 5
integer y = 320
end type

type dw_3 from w_main_root`dw_3 within w_des_product_class_master
integer x = 5
integer y = 320
integer taborder = 50
end type

type dw_2 from w_main_root`dw_2 within w_des_product_class_master
integer y = 2112
integer width = 4517
integer height = 408
integer taborder = 0
string dataobject = "d_des_product_class_mst"
end type

event dw_2::itemchanged;call super::itemchanged;DATETIME LVD_DATESET , LVD_DATEEND
if dwo.name = 'dateset' or dwo.name =  'dateend' then 
	  
DW_2.ACCEPTTEXT()
LVD_DATESET = DW_2.GETITEMDATETIME( row , 'dateset' )
LVD_DATEEND = DW_2.GETITEMDATETIME( row , 'dateend' )

IF LVD_DATESET >  LVD_DATEEND THEN		
	DW_2.OBJECT.DATESET[ROW] = ''
	DW_2.OBJECT.DATEEND[ROW] = ''
	MESSAGEBOX("Notify" , "Dateend Must Greate then Dateset" )
	RETURN 1 
END IF		
				
end if 
end event

type dw_1 from w_main_root`dw_1 within w_des_product_class_master
integer x = 5
integer y = 296
integer width = 4507
integer height = 1816
integer taborder = 40
boolean titlebar = true
string title = "Product Class List"
string dataobject = "d_des_product_class_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow = 0 then return
DW_2.RETRIEVE( DW_1.GETITEMSTRING( DW_1.GETROW() , "rowid" ) )

end event

event dw_1::doubleclicked;call super::doubleclicked;if row = 0 then return
DW_2.RETRIEVE( DW_1.GETITEMSTRING( DW_1.GETROW() , "rowid"  ))



end event

type st_1 from so_statictext within w_des_product_class_master
integer x = 82
integer y = 116
integer width = 558
integer height = 56
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Product Class Code"
end type

type st_2 from so_statictext within w_des_product_class_master
integer x = 640
integer y = 116
integer width = 581
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Product Class Name"
end type

type sle_product_name from so_singlelineedit within w_des_product_class_master
event ue_editchange pbm_enchange
integer x = 640
integer y = 176
integer width = 581
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

SELECTED_DATA_WINDOW.SETFILTER('')
SELECTED_DATA_WINDOW.FILTER()

LVS_COLUMN = 'ITEM_NAME'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    SELECTED_DATA_WINDOW.SETFILTER('')
    SELECTED_DATA_WINDOW.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
SELECTED_DATA_WINDOW.FILTER()
F_MSG_MDI_HELP( STRING( SELECTED_DATA_WINDOW.ROWCOUNT() ) + " Found" )
end event

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

type ddlb_product_class_code from uo_product_class_code within w_des_product_class_master
integer x = 82
integer y = 176
integer width = 558
integer taborder = 20
boolean bringtotop = true
end type

type gb_where_condition from so_groupbox within w_des_product_class_master
integer x = 14
integer width = 1285
integer height = 300
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

