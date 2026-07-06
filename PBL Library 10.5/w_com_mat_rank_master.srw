HA$PBExportHeader$w_com_mat_rank_master.srw
$PBExportComments$$$HEX6$$80bd88d42000c8b9a4c230d1$$ENDHEX$$
forward
global type w_com_mat_rank_master from w_main_root
end type
type st_2 from so_statictext within w_com_mat_rank_master
end type
type sle_rank from so_singlelineedit within w_com_mat_rank_master
end type
type cb_2 from so_commandbutton within w_com_mat_rank_master
end type
type gb_where_condition from so_groupbox within w_com_mat_rank_master
end type
type gb_1 from so_groupbox within w_com_mat_rank_master
end type
end forward

global type w_com_mat_rank_master from w_main_root
integer width = 4736
integer height = 2904
string title = "Rank Master"
st_2 st_2
sle_rank sle_rank
cb_2 cb_2
gb_where_condition gb_where_condition
gb_1 gb_1
end type
global w_com_mat_rank_master w_com_mat_rank_master

on w_com_mat_rank_master.create
int iCurrent
call super::create
this.st_2=create st_2
this.sle_rank=create sle_rank
this.cb_2=create cb_2
this.gb_where_condition=create gb_where_condition
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.sle_rank
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.gb_where_condition
this.Control[iCurrent+5]=this.gb_1
end on

on w_com_mat_rank_master.destroy
call super::destroy
destroy(this.st_2)
destroy(this.sle_rank)
destroy(this.cb_2)
destroy(this.gb_where_condition)
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
		   
			DW_1.RETRIEVE(sle_rank.text+'%' , gvi_organization_id )
			DW_1.SETFOCUS()
			
	CASE 'INSERT'
			dw_1.enabled = true
			row = dw_1.insertrow(dw_1.getrow())
			dw_1.scrolltorow(row)
			f_set_security_row(dw_1 , row , 'ALL')
			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
	CASE 'APPEND'
			dw_1.enabled = true
			row = dw_1.insertrow(dw_1.getrow())
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
 
	       IF dw_1.UPDATE() < 0 THEN
				ROLLBACK;
				RETURN
			ELSE
				 COMMIT;
   			      F_MSG_MDI_HELP ( F_MSG_ST(170)	 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
				 F_RETRIEVE()
			END IF
	
	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_com_mat_rank_master
integer y = 320
end type

type dw_4 from w_main_root`dw_4 within w_com_mat_rank_master
integer x = 5
integer y = 320
end type

type dw_3 from w_main_root`dw_3 within w_com_mat_rank_master
integer x = 5
integer y = 320
integer taborder = 50
end type

type dw_2 from w_main_root`dw_2 within w_com_mat_rank_master
integer x = 5
integer y = 296
integer width = 4517
integer height = 408
integer taborder = 0
end type

type dw_1 from w_main_root`dw_1 within w_com_mat_rank_master
integer x = 5
integer y = 296
integer width = 4507
integer height = 1816
integer taborder = 40
boolean titlebar = true
string title = "Rank Master"
string dataobject = "d_com_mat_rank_mst"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_com_mat_rank_master
end type

type st_2 from so_statictext within w_com_mat_rank_master
integer x = 91
integer y = 92
integer width = 581
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Rank"
end type

type sle_rank from so_singlelineedit within w_com_mat_rank_master
event ue_editchange pbm_enchange
integer x = 91
integer y = 152
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

type cb_2 from so_commandbutton within w_com_mat_rank_master
integer x = 937
integer y = 88
integer width = 489
integer height = 128
integer taborder = 20
boolean bringtotop = true
string text = "Excel Paste"
end type

event clicked;call super::clicked;long i 

dw_1.reset()
dw_1.importclipboard( )

do
	i++
	
	dw_1.object.organization_id[i] = gvi_organization_id

loop until i = dw_1.rowcount()


end event

type gb_where_condition from so_groupbox within w_com_mat_rank_master
integer x = 805
integer width = 763
integer height = 280
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_1 from so_groupbox within w_com_mat_rank_master
integer x = 14
integer width = 763
integer height = 280
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

