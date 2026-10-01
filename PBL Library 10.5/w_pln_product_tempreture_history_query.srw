HA$PBExportHeader$w_pln_product_tempreture_history_query.srw
$PBExportComments$Line Master
forward
global type w_pln_product_tempreture_history_query from w_main_root
end type
type st_mrm_no from statictext within w_pln_product_tempreture_history_query
end type
type sle_machine_code from so_singlelineedit within w_pln_product_tempreture_history_query
end type
type st_6 from so_statictext within w_pln_product_tempreture_history_query
end type
type uo_dateset from uo_ymd_calendar within w_pln_product_tempreture_history_query
end type
type uo_dateend from uo_ymd_calendar within w_pln_product_tempreture_history_query
end type
type st_label from statictext within w_pln_product_tempreture_history_query
end type
type rb_temp_list from so_radiobutton within w_pln_product_tempreture_history_query
end type
type rb_manage from so_radiobutton within w_pln_product_tempreture_history_query
end type
type cbx_auto_retrieve from so_checkbox within w_pln_product_tempreture_history_query
end type
type cb_1 from commandbutton within w_pln_product_tempreture_history_query
end type
type cbx_ng from so_checkbox within w_pln_product_tempreture_history_query
end type
type gb_2 from so_groupbox within w_pln_product_tempreture_history_query
end type
type gb_1 from so_groupbox within w_pln_product_tempreture_history_query
end type
type gb_3 from so_groupbox within w_pln_product_tempreture_history_query
end type
end forward

global type w_pln_product_tempreture_history_query from w_main_root
integer width = 5294
integer height = 2924
string title = "Tempreture Status Query"
st_mrm_no st_mrm_no
sle_machine_code sle_machine_code
st_6 st_6
uo_dateset uo_dateset
uo_dateend uo_dateend
st_label st_label
rb_temp_list rb_temp_list
rb_manage rb_manage
cbx_auto_retrieve cbx_auto_retrieve
cb_1 cb_1
cbx_ng cbx_ng
gb_2 gb_2
gb_1 gb_1
gb_3 gb_3
end type
global w_pln_product_tempreture_history_query w_pln_product_tempreture_history_query

type variables
Long Lvl_row 
String lvs_current_array_type , lvs_last_run_no
String lvs_user_line_code  , lvs_user_machine_code
end variables

on w_pln_product_tempreture_history_query.create
int iCurrent
call super::create
this.st_mrm_no=create st_mrm_no
this.sle_machine_code=create sle_machine_code
this.st_6=create st_6
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_label=create st_label
this.rb_temp_list=create rb_temp_list
this.rb_manage=create rb_manage
this.cbx_auto_retrieve=create cbx_auto_retrieve
this.cb_1=create cb_1
this.cbx_ng=create cbx_ng
this.gb_2=create gb_2
this.gb_1=create gb_1
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_mrm_no
this.Control[iCurrent+2]=this.sle_machine_code
this.Control[iCurrent+3]=this.st_6
this.Control[iCurrent+4]=this.uo_dateset
this.Control[iCurrent+5]=this.uo_dateend
this.Control[iCurrent+6]=this.st_label
this.Control[iCurrent+7]=this.rb_temp_list
this.Control[iCurrent+8]=this.rb_manage
this.Control[iCurrent+9]=this.cbx_auto_retrieve
this.Control[iCurrent+10]=this.cb_1
this.Control[iCurrent+11]=this.cbx_ng
this.Control[iCurrent+12]=this.gb_2
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_3
end on

on w_pln_product_tempreture_history_query.destroy
call super::destroy
destroy(this.st_mrm_no)
destroy(this.sle_machine_code)
destroy(this.st_6)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_label)
destroy(this.rb_temp_list)
destroy(this.rb_manage)
destroy(this.cbx_auto_retrieve)
destroy(this.cb_1)
destroy(this.cbx_ng)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.gb_3)
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
Ivs_resize_type                      = 'MASTER_DETAIL_12T_345B'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


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

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())


end event

event ue_data_control;call super::ue_data_control;long row, ll_row
dwitemstatus   ls_dw_item_status
datetime  ldt_sdate, ldt_edate
string      ls_machine

CHOOSE CASE Gvs_Ue_data_control
		
	CASE 'RETRIEVE'
		
			dw_1.RETRIEVE()
	
	CASE 'INSERT'
		
		    
			
			dw_5.enabled = true
			dw_5.bringtotop = true 
			row = dw_5.insertrow(dw_5.getrow())
			dw_5.scrolltorow(row)
			f_set_security_row(dw_5 , row , 'ALL')
			
			
			if dw_2.getrow() < 1 then 
			else
				dw_5.object.machine_code[row] = dw_2.object.nodeid[dw_2.getrow()]
				dw_5.object.check_start_date[row] = dw_2.object.gather_date[dw_2.getrow()]
			end if 
			
			dw_5.object.confirm_date[row] = f_sysdate()
			dw_5.object.confirm_yn[row] = 'W'
	
			dw_5.object.check_sequence[row] =  f_get_sequence( 'SEQ_CHECK_SEQ') 
			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
			
	CASE 'APPEND'
		
			dw_5.enabled = true
			dw_5.bringtotop = true 
			row = dw_5.insertrow(dw_5.getrow())
			dw_5.scrolltorow(row)
			f_set_security_row(dw_5 , row , 'ALL')
			
			
			if dw_2.getrow() < 1 then 
			else
				dw_5.object.machine_code[row] = dw_2.object.nodeid[dw_2.getrow()]
				dw_5.object.check_start_date[row] = dw_2.object.gather_date[dw_2.getrow()]
			end if 
			
			dw_5.object.confirm_date[row] = f_sysdate()
			dw_5.object.confirm_yn[row] = 'W'
	
			dw_5.object.check_sequence[row] =  f_get_sequence( 'SEQ_CHECK_SEQ') 
			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
			
	CASE 'DELETE'
		
		  	if dw_5.getrow() < 1 then return 
			  
			msg =f_msgbox(1003)
			
			if msg = 1 then
				gvl_row_deleted = dw_5.getrow()			
				dw_5.deleterow(gvl_row_deleted)		
				dw_5.setfocus()
				row = dw_5.getrow()
				dw_5.scrolltorow(row)
				dw_5.setcolumn(1)
			end if
			
	CASE 'UPDATE'
		
		 dw_5.ACCEPTTEXT()
		 
		 if ( dw_5.getrow() < 1)  then return
		 
		 for ll_row = 1 to  dw_5.getrow()
			
		    //  ls_dw_item_status = dw_5.getitemstatus( ll_row, 'check_end_date', Primary! )
				
			// if ( ls_dw_item_status = New! or ls_dw_item_status = NewModified! or ls_dw_item_status = DataModified! ) then
				 
				  ldt_sdate    = dw_5.object.check_start_date[ll_row]
				  ldt_edate    = dw_5.object.check_end_date[ll_row]
				  ls_machine = dw_5.object.machine_code[ll_row]
				  
				  if ( ls_machine = '' or isnull(ls_machine) ) then
					  messagebox("$$HEX2$$bdace0ac$$ENDHEX$$", "$$HEX6$$10c880ac74c725b8d0c52000$$ENDHEX$$MACHINE CODE $$HEX6$$00ac2000c6c54dc7c8b2e4b2$$ENDHEX$$")
					  return
				  end if
				  
				   if (  isnull(ldt_sdate) or isnull(ldt_edate)  or ldt_sdate > ldt_edate ) then
					   messagebox("$$HEX2$$bdace0ac$$ENDHEX$$", "$$HEX13$$74c7c1c0200010c880ac74c725b8d0c5200080acacc0dcc291c7$$ENDHEX$$/$$HEX20$$85c8ccb8dcc204ac40c7200018bcdcb4dcc2200085c725b8200058d554c17cc5200069d5c8b2e4b2$$ENDHEX$$")
					   return
				  end if
				  
	   	   //  end if
				
	      next
	
	      IF dw_5.UPDATE() < 0 THEN
				ROLLBACK;
				RETURN
		ELSE
				 COMMIT;
       			 F_MSG_MDI_HELP ( F_MSG_ST(170)	 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
		END IF
			
	
	CASE ELSE
	
END CHOOSE
end event

type dw_5 from w_main_root`dw_5 within w_pln_product_tempreture_history_query
integer y = 1572
integer width = 4576
integer height = 1240
integer taborder = 0
boolean titlebar = true
string title = "$$HEX7$$74c7c1c0200010c880ac74c725b8$$ENDHEX$$"
string dataobject = "d_mcn_temerature_check_lst"
end type

type dw_4 from w_main_root`dw_4 within w_pln_product_tempreture_history_query
event ue_creategraph pbm_dwngraphcreate
integer x = 2597
integer y = 1572
integer width = 2656
integer height = 1240
integer taborder = 0
boolean titlebar = true
string title = "$$HEX7$$21ce15c82000b5c2c4b394cd74c7$$ENDHEX$$"
string dataobject = "d_com_humidity_raw_graph"
end type

event dw_4::ue_creategraph;string ls_seriesname

ls_seriesname = this.SeriesName( 'gr_1', 1)
this.SetSeriesStyle( 'gr_1' ,ls_seriesname, Nosymbol!)
this.SetSeriesStyle( 'gr_1' ,ls_seriesname, Nosymbol!)
this.SETSEriesstyle('gr_1' , ls_seriesname , Continuous!, 3)


ls_seriesname = this.SeriesName( 'gr_1', 2)
this.SetSeriesStyle( 'gr_1' ,ls_seriesname, Nosymbol!)
this.SETSEriesstyle('gr_1' , ls_seriesname , Continuous!, 3)


ls_seriesname = this.SeriesName( 'gr_1', 3)
this.SetSeriesStyle( 'gr_1' ,ls_seriesname, Nosymbol!)
this.SETSEriesstyle('gr_1' , ls_seriesname , Continuous!, 3)
end event

event dw_4::uo_mousemove;call super::uo_mousemove;
integer 	SeriesNbr, ItemNbr
string 	data_value,	&
			old_data

grObjectType	object_type
string 	SeriesName,			&
			ls_CategoryName,		&
			ls_SeriesName
string 	ls_name , data_name
long		ll_width

object_type 		      = 	this.ObjectAtPointer( dwo.name , SeriesNbr, ItemNbr)
ls_CategoryName	=	this.CategoryName(dwo.name ,  ItemNbr)
ls_SeriesName		=	this.SeriesName (dwo.name , SeriesNbr )

data_name = this.SeriesName(dwo.name , SeriesNbr)

setpointer(arrow!)

IF object_type = TypeData! THEN 
	
	old_data		=	data_value
	data_value 	= 	String( this.GetData( dwo.name , SeriesNbr, ItemNbr) , "###,###,##0.######")+" : "+ data_name
		
	if st_label.visible and old_data = data_value then
		return
	end if
	
	ll_width	=	( len( data_value ) + len(ls_CategoryName) ) * 40
	
	st_label.text = ls_CategoryName+" : "+data_value
	
//	st_label.x 	=   xpos - 2
//	st_label.y	=	ypos + 250
	st_label.x 	=   parent.pointerx( ) - 2
	st_label.y	=   parent.pointery( ) + 250
	
	st_label.width	=	ll_width
	st_label.visible = true	
	
	f_msg_mdi_help( ls_SeriesName + ' ** ' + ls_CategoryName + ' ** (' + data_value + ')' )
	
ELSEIF object_type = TypeCategory! THEN
		
	ll_width	=	len( ls_CategoryName ) * 40
	st_label.text =  ls_SeriesName + ' ** ' + ls_CategoryName + ' ** (' + data_value + ')' //ls_CategoryName
	
	st_label.x 	=   parent.pointerx( ) - 2
	st_label.y	=   parent.pointery( ) + 250
	
//	st_label.x 	=  xpos - 2
//	st_label.y	=	ypos + 250
	st_label.width	=	ll_width
	st_label.visible = true	
	
	f_msg_mdi_help( ls_CategoryName )
ELSE
	f_msg_mdi_help("")
	st_label.visible 	= 	false	
END IF

end event

type dw_3 from w_main_root`dw_3 within w_pln_product_tempreture_history_query
event ue_creategraph pbm_dwngraphcreate
integer x = 9
integer y = 1572
integer width = 2587
integer height = 1240
integer taborder = 0
boolean titlebar = true
string title = "$$HEX7$$21ce15c8200028c6c4b394cd74c7$$ENDHEX$$"
string dataobject = "d_com_tempreture_raw_graph"
end type

event dw_3::ue_creategraph;string ls_seriesname

ls_seriesname = dw_3.SeriesName( 'gr_1', 1)
dw_3.SetSeriesStyle( 'gr_1' ,ls_seriesname, Nosymbol!)
dw_3.SetSeriesStyle( 'gr_1' ,ls_seriesname, Nosymbol!)
DW_3.SETSEriesstyle('gr_1' , ls_seriesname , Continuous!, 3)


ls_seriesname = dw_3.SeriesName( 'gr_1', 2)
dw_3.SetSeriesStyle( 'gr_1' ,ls_seriesname, Nosymbol!)
DW_3.SETSEriesstyle('gr_1' , ls_seriesname , Continuous!, 3)


ls_seriesname = dw_3.SeriesName( 'gr_1', 3)
dw_3.SetSeriesStyle( 'gr_1' ,ls_seriesname, Nosymbol!)
DW_3.SETSEriesstyle('gr_1' , ls_seriesname , Continuous!, 3)
end event

event dw_3::uo_mousemove;call super::uo_mousemove;
integer 	SeriesNbr, ItemNbr
string 	data_value,	&
			old_data

grObjectType	object_type
string 	SeriesName,			&
			ls_CategoryName,		&
			ls_SeriesName
string 	ls_name , data_name
long		ll_width

object_type 		      = 	this.ObjectAtPointer( dwo.name , SeriesNbr, ItemNbr)
ls_CategoryName	=	this.CategoryName(dwo.name ,  ItemNbr)
ls_SeriesName		=	this.SeriesName (dwo.name , SeriesNbr )

data_name = this.SeriesName(dwo.name , SeriesNbr)

setpointer(arrow!)

IF object_type = TypeData! THEN 
	
	old_data		=	data_value
	data_value 	= 	String( this.GetData( dwo.name , SeriesNbr, ItemNbr) , "###,###,##0.######")+" : "+ data_name
		
	if st_label.visible and old_data = data_value then
		return
	end if
	
	ll_width	=	( len( data_value ) + len(ls_CategoryName) ) * 40
	
	st_label.text = ls_CategoryName+" : "+data_value
	
//	st_label.x 	=   xpos - 2
//	st_label.y	=	ypos + 250
	st_label.x 	=   parent.pointerx( ) - 2
	st_label.y	=   parent.pointery( ) + 250
	
	st_label.width	=	ll_width
	st_label.visible = true	
	
	f_msg_mdi_help( ls_SeriesName + ' ** ' + ls_CategoryName + ' ** (' + data_value + ')' )
	
ELSEIF object_type = TypeCategory! THEN
		
	ll_width	=	len( ls_CategoryName ) * 40
	st_label.text =  ls_SeriesName + ' ** ' + ls_CategoryName + ' ** (' + data_value + ')' //ls_CategoryName
	
	st_label.x 	=   parent.pointerx( ) - 2
	st_label.y	=   parent.pointery( ) + 250
	
//	st_label.x 	=  xpos - 2
//	st_label.y	=	ypos + 250
	st_label.width	=	ll_width
	st_label.visible = true	
	
	f_msg_mdi_help( ls_CategoryName )
ELSE
	f_msg_mdi_help("")

	st_label.visible 	= 	false	
END IF

end event

type dw_2 from w_main_root`dw_2 within w_pln_product_tempreture_history_query
event ue_creategraph pbm_dwngraphcreate
integer x = 2597
integer y = 320
integer width = 2656
integer height = 1240
integer taborder = 0
boolean titlebar = true
string title = "$$HEX2$$28c6c4b3$$ENDHEX$$/$$HEX7$$b5c2c4b3200021ce15c874c725b8$$ENDHEX$$"
string dataobject = "d_com_tempreture_raw_lst"
end type

event dw_2::ue_creategraph;string ls_seriesname

ls_seriesname = this.SeriesName( 'gr_1', 1)
this.SetSeriesStyle( 'gr_1' ,ls_seriesname, Nosymbol!)
ls_seriesname = this.SeriesName( 'gr_2', 2)
this.SetSeriesStyle( 'gr_2' ,ls_seriesname, Nosymbol!)


end event

event dw_2::rowfocuschanged;call super::rowfocuschanged;

if dw_2.getrow() < 1 then return 

if rb_manage.checked = true then 
	//dw_5.RETRIEVE(  this.object.nodeid[currentrow] , this.object.gather_date[currentrow] , this.object.gather_date[currentrow]  , gvi_organization_id )
	dw_5.RETRIEVE(  dw_1.object.nodeid[dw_1.getrow()] , uo_dateset.text() , uo_dateend.text() , gvi_organization_id )	
end if 
end event

type dw_1 from w_main_root`dw_1 within w_pln_product_tempreture_history_query
integer x = 9
integer y = 320
integer width = 2587
integer height = 1240
integer taborder = 0
boolean titlebar = true
string title = "$$HEX2$$28c6c4b3$$ENDHEX$$/$$HEX9$$b5c2c4b3200021ce15c830ae2000c1c0dcd0$$ENDHEX$$"
string dataobject = "d_com_tempreture_data_lst"
end type

event dw_1::uo_mousemove;call super::uo_mousemove;if row < 1 then return
IF   ( UPPER(DWO.TYPE) = 'COLUMN' AND  UPPER(DWO.NAME) = 'NODEID'  ) THEN

		IF ISVALID(W_MACHINE_IMAGE_FLAT) THEN
			RETURN
		ELSE
			OPENWITHPARM(W_MACHINE_IMAGE_FLAT , STRING(THIS.OBJECT.NODEID[ROW]))
		END IF 
ELSE

		IF isvalid(W_MACHINE_IMAGE_FLAT) then
			close(W_MACHINE_IMAGE_FLAT)
		end if 
END IF
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;string lvs_machine_name, lvs_humidity_yn, lvs_ng

if currentrow < 1 then return 

if ( cbx_ng.checked = true ) then
	 lvs_ng = 'NG'
else
	 lvs_ng = 'XX'
end if

if rb_temp_list.Checked =true   then 
	
	if cbx_auto_retrieve.checked = true then 
		
           lvs_machine_name = dw_1.object.machine_name[currentrow]
	       lvs_humidity_yn      = dw_1.object.humidity_yn[currentrow]		  
	
	      IF ( POS(lvs_machine_name, '$$HEX3$$c9b0a5c7e0ac$$ENDHEX$$' ) > 0 ) THEN
				
	           dw_3.object.gr_1.Values.MaximumValue = 12
               dw_3.object.gr_1.Values.MinimumValue = 0	
		  
               dw_4.object.gr_1.Values.MaximumValue = 100
               dw_4.object.gr_1.Values.MinimumValue = 0				
				
	      ELSE
				
  		        dw_3.object.gr_1.Values.MaximumValue = 30
                 dw_3.object.gr_1.Values.MinimumValue = 20	
		  
                 dw_4.object.gr_1.Values.MaximumValue = 70
                 dw_4.object.gr_1.Values.MinimumValue = 30					
				
		 END IF
			
			
           IF ( lvs_humidity_yn = 'Y' ) THEN
					
                 dw_2.retrieve( upper(dw_1.object.nodeid[currentrow] ) ,uo_dateset.text() , uo_dateend.text()  , gvi_organization_id, lvs_ng )	
                 dw_3.retrieve( upper(dw_1.object.nodeid[currentrow] ) ,uo_dateset.text() , uo_dateend.text()  , gvi_organization_id )
	            dw_4.retrieve( upper(dw_1.object.nodeid[currentrow] ) ,uo_dateset.text() , uo_dateend.text()  , gvi_organization_id )	
		
	     else
					
	          dw_4.reset( )		
		  
	          dw_2.retrieve( upper(dw_1.object.nodeid[currentrow] ) ,uo_dateset.text() , uo_dateend.text()  , gvi_organization_id, lvs_ng )	
              dw_3.retrieve( upper(dw_1.object.nodeid[currentrow] ) ,uo_dateset.text() , uo_dateend.text()  , gvi_organization_id )
		  		
	    END IF
		
	end if 
	
else
		dw_2.retrieve( upper(dw_1.object.nodeid[currentrow] ) ,uo_dateset.text() , uo_dateend.text()  , gvi_organization_id, lvs_ng )	
		dw_5.RETRIEVE(  dw_1.object.nodeid[dw_1.getrow()] , uo_dateset.text() , uo_dateend.text() , gvi_organization_id )	
end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_pln_product_tempreture_history_query
integer taborder = 0
end type

type st_mrm_no from statictext within w_pln_product_tempreture_history_query
integer x = 891
integer y = 92
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
string text = "Machine Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_machine_code from so_singlelineedit within w_pln_product_tempreture_history_query
integer x = 891
integer y = 176
integer width = 631
integer taborder = 10
boolean bringtotop = true
textcase textcase = upper!
end type

type st_6 from so_statictext within w_pln_product_tempreture_history_query
integer x = 1531
integer y = 88
integer width = 814
integer height = 68
boolean bringtotop = true
string text = "Check Date"
end type

type uo_dateset from uo_ymd_calendar within w_pln_product_tempreture_history_query
integer x = 1531
integer y = 172
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_pln_product_tempreture_history_query
integer x = 1943
integer y = 172
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_label from statictext within w_pln_product_tempreture_history_query
boolean visible = false
integer x = 544
integer y = 1580
integer width = 1367
integer height = 172
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 65535
boolean focusrectangle = false
end type

type rb_temp_list from so_radiobutton within w_pln_product_tempreture_history_query
integer x = 101
integer y = 80
integer width = 617
boolean bringtotop = true
string text = "Temperature List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
dw_2.bringtotop = true 
dw_3.bringtotop = true 
dw_4.bringtotop = true 
selected_data_window = dw_1
end event

type rb_manage from so_radiobutton within w_pln_product_tempreture_history_query
integer x = 101
integer y = 180
integer width = 617
boolean bringtotop = true
string text = "Check Histrory Manage"
end type

event clicked;call super::clicked;dw_5.bringtotop = true 
selected_data_window = dw_5

//
//if dw_1.getrow() < 1 then return 
//dw_5.RETRIEVE(  dw_1.object.nodeid[dw_1.getrow()] , uo_dateset.text() , uo_dateend.text() , gvi_organization_id )	
end event

type cbx_auto_retrieve from so_checkbox within w_pln_product_tempreture_history_query
integer x = 2510
integer y = 116
boolean bringtotop = true
string text = "Auto Retrieve"
boolean checked = true
end type

type cb_1 from commandbutton within w_pln_product_tempreture_history_query
integer x = 3749
integer y = 108
integer width = 457
integer height = 132
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Excel"
end type

event clicked;
Datawindow ivdw_data_window
string     docname, named 
Long iret

ivdw_data_window = dw_2

if isvalid(ivdw_data_window) then 
	
	if ivdw_data_window.getrow() < 1 then  
		Messagebox("Notify" ,"No Data Found")
		return
	end if
	
else
	return
end if

		SETPOINTER(HOURGLASS!)		
		iret = GetFileSaveName("Select Excel File ("+ivdw_data_window.classname()+")" , docname, named, "xls", "Excel Files (*.xls),*.xls")		

              IF iret =1 THEN 
		         uf_save_dw_as_excel( ivdw_data_window  , docname )
		ELSE
			RETURN
		END IF
end event

type cbx_ng from so_checkbox within w_pln_product_tempreture_history_query
integer x = 2985
integer y = 116
boolean bringtotop = true
string text = "$$HEX4$$74c7c1c074c725b8$$ENDHEX$$"
end type

event clicked;call super::clicked;
//
//string ls_dw_filter
//
//if ( this.checked = true ) then
//	
//	if ( dw_2.rowcount() < 1) then return
//	
//	ls_dw_filter = " min_temp_value > room_temperature or max_temp_value < room_temperature or min_humidity_value > humidity or min_humidity_value < humidity "
//	dw_2.SetFilter(ls_dw_filter)
//    dw_2.Filter( )
//	 
//else
//	
//	ls_dw_filter = ''
//    dw_2.SetFilter(ls_dw_filter)
//	dw_2.Filter( )
//	
//end if
end event

type gb_2 from so_groupbox within w_pln_product_tempreture_history_query
integer width = 818
integer height = 304
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_1 from so_groupbox within w_pln_product_tempreture_history_query
integer x = 2400
integer width = 1216
integer height = 304
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Option"
end type

type gb_3 from so_groupbox within w_pln_product_tempreture_history_query
integer x = 837
integer width = 1554
integer height = 304
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

