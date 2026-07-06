HA$PBExportHeader$w_smt_line_master.srw
$PBExportComments$$$HEX6$$80bd88d42000c8b9a4c230d1$$ENDHEX$$
forward
global type w_smt_line_master from w_main_root
end type
type st_2 from so_statictext within w_smt_line_master
end type
type sle_line_code from so_singlelineedit within w_smt_line_master
end type
type sle_machine_code from so_singlelineedit within w_smt_line_master
end type
type st_1 from so_statictext within w_smt_line_master
end type
type cb_1 from so_commandbutton within w_smt_line_master
end type
type cb_2 from so_commandbutton within w_smt_line_master
end type
type cb_update from so_commandbutton within w_smt_line_master
end type
type em_location_start from so_editmask within w_smt_line_master
end type
type em_location_end from so_editmask within w_smt_line_master
end type
type cb_3 from so_commandbutton within w_smt_line_master
end type
type st_3 from so_statictext within w_smt_line_master
end type
type st_4 from so_statictext within w_smt_line_master
end type
type rb_left from radiobutton within w_smt_line_master
end type
type rb_right from radiobutton within w_smt_line_master
end type
type rb_none from radiobutton within w_smt_line_master
end type
type em_table_id from so_singlelineedit within w_smt_line_master
end type
type rb_ignore from radiobutton within w_smt_line_master
end type
type rb_lr from radiobutton within w_smt_line_master
end type
type cb_4 from so_commandbutton within w_smt_line_master
end type
type cbx_layout_auto_retrieve from so_checkbox within w_smt_line_master
end type
type cbx_all from so_checkbox within w_smt_line_master
end type
type gb_1 from so_groupbox within w_smt_line_master
end type
type gb_2 from so_groupbox within w_smt_line_master
end type
type gb_3 from so_groupbox within w_smt_line_master
end type
type gb_4 from so_groupbox within w_smt_line_master
end type
end forward

global type w_smt_line_master from w_main_root
integer width = 5870
integer height = 2904
string title = "SMT Line Master"
st_2 st_2
sle_line_code sle_line_code
sle_machine_code sle_machine_code
st_1 st_1
cb_1 cb_1
cb_2 cb_2
cb_update cb_update
em_location_start em_location_start
em_location_end em_location_end
cb_3 cb_3
st_3 st_3
st_4 st_4
rb_left rb_left
rb_right rb_right
rb_none rb_none
em_table_id em_table_id
rb_ignore rb_ignore
rb_lr rb_lr
cb_4 cb_4
cbx_layout_auto_retrieve cbx_layout_auto_retrieve
cbx_all cbx_all
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
end type
global w_smt_line_master w_smt_line_master

on w_smt_line_master.create
int iCurrent
call super::create
this.st_2=create st_2
this.sle_line_code=create sle_line_code
this.sle_machine_code=create sle_machine_code
this.st_1=create st_1
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_update=create cb_update
this.em_location_start=create em_location_start
this.em_location_end=create em_location_end
this.cb_3=create cb_3
this.st_3=create st_3
this.st_4=create st_4
this.rb_left=create rb_left
this.rb_right=create rb_right
this.rb_none=create rb_none
this.em_table_id=create em_table_id
this.rb_ignore=create rb_ignore
this.rb_lr=create rb_lr
this.cb_4=create cb_4
this.cbx_layout_auto_retrieve=create cbx_layout_auto_retrieve
this.cbx_all=create cbx_all
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.sle_line_code
this.Control[iCurrent+3]=this.sle_machine_code
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.cb_update
this.Control[iCurrent+8]=this.em_location_start
this.Control[iCurrent+9]=this.em_location_end
this.Control[iCurrent+10]=this.cb_3
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.st_4
this.Control[iCurrent+13]=this.rb_left
this.Control[iCurrent+14]=this.rb_right
this.Control[iCurrent+15]=this.rb_none
this.Control[iCurrent+16]=this.em_table_id
this.Control[iCurrent+17]=this.rb_ignore
this.Control[iCurrent+18]=this.rb_lr
this.Control[iCurrent+19]=this.cb_4
this.Control[iCurrent+20]=this.cbx_layout_auto_retrieve
this.Control[iCurrent+21]=this.cbx_all
this.Control[iCurrent+22]=this.gb_1
this.Control[iCurrent+23]=this.gb_2
this.Control[iCurrent+24]=this.gb_3
this.Control[iCurrent+25]=this.gb_4
end on

on w_smt_line_master.destroy
call super::destroy
destroy(this.st_2)
destroy(this.sle_line_code)
destroy(this.sle_machine_code)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_update)
destroy(this.em_location_start)
destroy(this.em_location_end)
destroy(this.cb_3)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.rb_left)
destroy(this.rb_right)
destroy(this.rb_none)
destroy(this.em_table_id)
destroy(this.rb_ignore)
destroy(this.rb_lr)
destroy(this.cb_4)
destroy(this.cbx_layout_auto_retrieve)
destroy(this.cbx_all)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
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
		   
			DW_1.RESET()
			DW_2.RESET()
			DW_1.RETRIEVE(  sle_line_code.text+'%' , sle_machine_code.text+'%' , GVI_ORGANIZATION_ID )
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

type dw_5 from w_main_root`dw_5 within w_smt_line_master
integer y = 320
end type

type dw_4 from w_main_root`dw_4 within w_smt_line_master
integer x = 5
integer y = 320
end type

type dw_3 from w_main_root`dw_3 within w_smt_line_master
integer x = 5
integer y = 320
integer taborder = 50
end type

type dw_2 from w_main_root`dw_2 within w_smt_line_master
integer y = 1532
integer width = 4517
integer height = 1104
integer taborder = 0
boolean titlebar = true
string title = "SMT Location List"
string dataobject = "d_ib_machine_location_lst"
end type

event dw_2::itemchanged;call super::itemchanged;if dwo.name = 'line_code' or dwo.name ='machine' or dwo.name ='table_id' or dwo.name ='address' or dwo.name ='position' then
	
	this.object.location_code[row] = this.object.line_code[row]+this.object.machine[row]+this.object.table_id[row]+this.object.address[row]+this.object.position[row]
	
end if 
end event

type dw_1 from w_main_root`dw_1 within w_smt_line_master
integer y = 320
integer width = 4507
integer height = 1208
integer taborder = 40
boolean titlebar = true
string title = "SM Line List"
string dataobject = "d_ib_line_master_lst"
end type

event dw_1::doubleclicked;call super::doubleclicked;if row < 1 then return 

dw_2.retrieve( this.object.line_code[row] , this.object.machine[row] , gvi_organization_id )
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;if cbx_layout_auto_retrieve.checked = true then 
	
	if currentrow < 1 then return 

	dw_2.retrieve( this.object.line_code[currentrow] , this.object.machine[currentrow] , gvi_organization_id )

end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_smt_line_master
end type

type st_2 from so_statictext within w_smt_line_master
integer x = 55
integer y = 88
integer width = 439
integer height = 56
boolean bringtotop = true
string text = "Line Code"
end type

type sle_line_code from so_singlelineedit within w_smt_line_master
event ue_editchange pbm_enchange
integer x = 55
integer y = 164
integer width = 439
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

DW_1.SETFILTER('')
DW_1.FILTER()

LVS_COLUMN = 'LINE_CODE'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    DW_1.SETFILTER('')
    DW_1.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

DW_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
DW_1.FILTER()
F_MSG_MDI_HELP( STRING( DW_1.ROWCOUNT() ) + " Found" )
end event

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

type sle_machine_code from so_singlelineedit within w_smt_line_master
integer x = 503
integer y = 164
integer width = 590
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

type st_1 from so_statictext within w_smt_line_master
integer x = 503
integer y = 96
integer width = 590
integer height = 56
boolean bringtotop = true
string text = "Machine"
end type

type cb_1 from so_commandbutton within w_smt_line_master
integer x = 1184
integer y = 84
integer width = 352
integer height = 156
integer taborder = 30
boolean bringtotop = true
integer weight = 400
string text = "Insert"
end type

event clicked;call super::clicked;Int Lvi_row

if dw_1.getrow( ) < 1 then return

lvi_row = dw_2.insertrow(0)
dw_2.object.line_code[lvi_row] = dw_1.object.line_code[dw_1.getrow()]
dw_2.object.machine[lvi_row] = dw_1.object.machine[dw_1.getrow()]
f_set_security_row( dw_2 , lvi_row , 'ALL' ) 
end event

type cb_2 from so_commandbutton within w_smt_line_master
integer x = 1541
integer y = 84
integer width = 352
integer height = 156
integer taborder = 40
boolean bringtotop = true
integer weight = 400
string text = "Delete"
end type

event clicked;call super::clicked;if dw_2.getrow( ) < 1 then return
DW_2.DELETEROW( DW_2.GETROW() )
cb_update.triggerevent(clicked!)

end event

type cb_update from so_commandbutton within w_smt_line_master
integer x = 2258
integer y = 84
integer width = 352
integer height = 156
integer taborder = 50
boolean bringtotop = true
integer weight = 400
string text = "Update"
boolean default = true
end type

event clicked;call super::clicked;IF DW_2.UPDATE() < 0 THEN 
	ROLLBACK ;
	
ELSE
	COMMIT ;
	F_MSG_MDI_HELP( F_MSG_ST( 170) ) 	
END IF


end event

type em_location_start from so_editmask within w_smt_line_master
integer x = 3995
integer y = 148
integer width = 215
integer taborder = 70
boolean bringtotop = true
string text = "1"
string mask = "##0"
end type

type em_location_end from so_editmask within w_smt_line_master
integer x = 4215
integer y = 148
integer width = 215
integer taborder = 80
boolean bringtotop = true
string text = "1"
string mask = "##0"
end type

type cb_3 from so_commandbutton within w_smt_line_master
integer x = 5362
integer y = 88
integer width = 352
integer height = 156
integer taborder = 40
boolean bringtotop = true
integer weight = 400
string text = "Generate"
end type

event clicked;call super::clicked;Long i , k ,  m ,  lvi_row  , lvi_max_table
string lvs_table_id , lvs_position , lvs_address , lvs_table , lvs_table_id_chr
if dw_1.getrow() < 1 then 
	f_msgbox1(102 , f_get_dual_lang_text( Gvs_language , "Line Code"))
	return
end if 

i = long(em_location_start.text)

if rb_left.checked = true then 
		lvs_position = 'L'
elseif rb_right.checked = true then 
		lvs_position = 'R'
elseif rb_none.checked = true then 
		lvs_position = 'N'
elseif rb_ignore.checked = true then 
		lvs_position = ''
end if 

if cbx_all.checked = true then 
	
			lvs_table_id_chr =  em_table_id.text 
		
			select  ascii(  lower(:lvs_table_id_chr) ) into :lvi_max_table from dual ;

			
			do // $$HEX3$$7cb778c72000$$ENDHEX$$
				m = 0
				i = 0
				k++
	     
				 do // $$HEX4$$4cd174c714be2000$$ENDHEX$$
					i = 0
					m++
			         select  chr(96+:m) into :lvs_table from dual ;
						
					 do
						lvi_row = dw_2.insertrow(0)	
						dw_2.object.line_code[lvi_row] = dw_1.object.line_code[k]
						dw_2.object.machine[lvi_row] =  dw_1.object.machine[k]
						f_set_security_row( dw_2 , lvi_row , 'ALL' ) 
						
						lvs_address= trim(string(i,'00'))
						lvs_position = 'L'
						dw_2.object.location_code[lvi_row] = upper( lvs_table)+   lvs_address  +lvs_position 
						dw_2.object.table_id[lvi_row] = upper( lvs_table)
						
						lvi_row = dw_2.insertrow(0)	
						dw_2.object.line_code[lvi_row] = dw_1.object.line_code[k]
						dw_2.object.machine[lvi_row] =  dw_1.object.machine[k]
						f_set_security_row( dw_2 , lvi_row , 'ALL' ) 
						
						upper( lvs_table)
						lvs_address= trim(string(i,'00'))
						lvs_position = 'R'
						dw_2.object.location_code[lvi_row] = upper( lvs_table)+   lvs_address  +lvs_position 
						dw_2.object.table_id[lvi_row] = upper( lvs_table) 					
						i++
						
				  	    f_msg_mdi_help( string(k) +' ' +string(m)+' '+string(i) )
							
					loop until i > Long(em_location_end.text)
					
				loop until  96+m >=   lvi_max_table
				
			loop until  k >=  dw_1.rowcount() 
			
else
			
			do
					
				lvi_row = dw_2.insertrow(0)	
				dw_2.object.line_code[lvi_row] = dw_1.object.line_code[dw_1.getrow()]
				dw_2.object.machine[lvi_row] =  dw_1.object.machine[dw_1.getrow()]
				f_set_security_row( dw_2 , lvi_row , 'ALL' ) 
				
				lvs_table_id= em_table_id.text
				lvs_address= trim(string(i,'00'))
				dw_2.object.location_code[lvi_row] = lvs_table_id+   lvs_address  +lvs_position 
				dw_2.object.table_id[lvi_row] = lvs_table_id 
				i++	
			loop until i > Long(em_location_end.text)			
			
end if 
		

msg = f_msgbox(1170) 
if msg = 1 then 
	cb_update.triggerevent( clicked!)
else
	return
end if
end event

type st_3 from so_statictext within w_smt_line_master
integer x = 3995
integer y = 52
integer width = 439
integer height = 60
boolean bringtotop = true
string text = "Machine Location"
end type

type st_4 from so_statictext within w_smt_line_master
integer x = 3767
integer y = 52
integer width = 215
integer height = 60
boolean bringtotop = true
string text = "M.Table"
end type

type rb_left from radiobutton within w_smt_line_master
integer x = 4503
integer y = 60
integer width = 247
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Left"
end type

type rb_right from radiobutton within w_smt_line_master
integer x = 4777
integer y = 64
integer width = 210
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Right"
end type

type rb_none from radiobutton within w_smt_line_master
integer x = 4503
integer y = 160
integer width = 247
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "None"
boolean checked = true
end type

type em_table_id from so_singlelineedit within w_smt_line_master
integer x = 3776
integer y = 148
integer width = 187
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

type rb_ignore from radiobutton within w_smt_line_master
integer x = 4777
integer y = 160
integer width = 210
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Ignore"
end type

type rb_lr from radiobutton within w_smt_line_master
integer x = 5051
integer y = 56
integer width = 288
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Left/Right"
end type

type cb_4 from so_commandbutton within w_smt_line_master
integer x = 1906
integer y = 84
integer width = 352
integer height = 156
integer taborder = 50
boolean bringtotop = true
integer weight = 400
string text = "Delete All"
end type

event clicked;call super::clicked;msg = f_msgbox1(1161 , this.text )

if msg = 1 then 
	delete from ib_machine_location ;
	if f_sql_check() < 0 then 
		return 
	end if 
	
	commit ;
	
end if 
end event

type cbx_layout_auto_retrieve from so_checkbox within w_smt_line_master
integer x = 2615
integer y = 116
boolean bringtotop = true
string text = "Auto Retrieve"
end type

type cbx_all from so_checkbox within w_smt_line_master
integer x = 3154
integer y = 120
integer width = 370
boolean bringtotop = true
string text = "All"
end type

type gb_1 from so_groupbox within w_smt_line_master
integer x = 14
integer width = 1106
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_smt_line_master
integer x = 3625
integer width = 2190
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Location Process"
end type

type gb_3 from so_groupbox within w_smt_line_master
integer x = 1129
integer width = 1957
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Location Process"
end type

type gb_4 from so_groupbox within w_smt_line_master
integer x = 3104
integer width = 489
integer height = 296
integer taborder = 30
end type

