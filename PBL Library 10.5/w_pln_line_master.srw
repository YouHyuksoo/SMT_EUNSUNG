HA$PBExportHeader$w_pln_line_master.srw
$PBExportComments$Line Master
forward
global type w_pln_line_master from w_main_root
end type
type st_line_code from statictext within w_pln_line_master
end type
type ddlb_line_code from uo_line_code within w_pln_line_master
end type
type cb_1 from commandbutton within w_pln_line_master
end type
type gb_1 from so_groupbox within w_pln_line_master
end type
end forward

global type w_pln_line_master from w_main_root
integer width = 4571
integer height = 2748
string title = "Product Line Master"
st_line_code st_line_code
ddlb_line_code ddlb_line_code
cb_1 cb_1
gb_1 gb_1
end type
global w_pln_line_master w_pln_line_master

on w_pln_line_master.create
int iCurrent
call super::create
this.st_line_code=create st_line_code
this.ddlb_line_code=create ddlb_line_code
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_line_code
this.Control[iCurrent+2]=this.ddlb_line_code
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.gb_1
end on

on w_pln_line_master.destroy
call super::destroy
destroy(this.st_line_code)
destroy(this.ddlb_line_code)
destroy(this.cb_1)
destroy(this.gb_1)
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
Ivs_resize_type                      = 'MASTER_DETAIL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


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

event ue_data_control;call super::ue_data_control;long row
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
			dw_1.retrieve( ddlb_line_code.GETCODE() + '%', gvi_organization_id)
			dw_1.setfocus()
			
	case 'INSERT'		
			f_set_column_initial_value( dw_1, dw_1.getrow() , 'ALL' )
	case 'APPEND'		
			f_set_column_initial_value( dw_2, 0 , 'ALL' )
	case 'DELETE'
		
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
			
	case 'UPDATE'
		
			if dw_1.update() < 0 OR DW_2.UPDATE () < 0 then
				rollback;
			else
				commit;
				f_msg_mdi_help(f_msg_st(170))
			end if
			
	case else
end choose


end event

type dw_5 from w_main_root`dw_5 within w_pln_line_master
integer y = 316
end type

type dw_4 from w_main_root`dw_4 within w_pln_line_master
integer y = 316
end type

type dw_3 from w_main_root`dw_3 within w_pln_line_master
integer y = 316
integer width = 4544
end type

type dw_2 from w_main_root`dw_2 within w_pln_line_master
integer y = 1412
integer width = 4549
integer height = 1196
boolean titlebar = true
string title = "Shaft"
string dataobject = "d_smt_feeder_shaft_lst"
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_pln_line_master
integer y = 316
integer width = 4544
integer height = 1084
boolean titlebar = true
string title = "Line Master"
string dataobject = "d_pln_line_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
dw_2.retrieve( this.object.line_code[currentrow]  , gvi_organization_id )
end event

type uo_tabpages from w_main_root`uo_tabpages within w_pln_line_master
end type

type st_line_code from statictext within w_pln_line_master
integer x = 69
integer y = 104
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
string text = "Line Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_line_code from uo_line_code within w_pln_line_master
integer x = 69
integer y = 184
integer taborder = 20
boolean bringtotop = true
end type

type cb_1 from commandbutton within w_pln_line_master
boolean visible = false
integer x = 850
integer y = 84
integer width = 457
integer height = 132
integer taborder = 30
boolean bringtotop = true
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
end type

event clicked;string arg_pcb , arg_line_code , arg_ijobdate , arg_bcr
long i 
dw_2.retrieve()

dw_2.bringtotop = true 

DO
  	i++
	arg_pcb = dw_2.object.i_pcb[i]
	arg_line_code =  dw_2.object.line_code[i]
	arg_bcr      =  dw_2.object.i_bcr[i]
	arg_ijobdate =   dw_2.object.ijobdate[i]

INSERT INTO smd_material_05
    SELECT   'YS10',
             a.cequipname,
             :arg_pcb,
             a.cpbaitem,
             a.ctb,
             a.citemname,
             a.citemlot,
             'Maker',
             to_Date( :arg_ijobdate, 'yyyymmddhh24miss') ,
             to_Date( :arg_ijobdate, 'yyyymmddhh24miss') ,
             :arg_bcr ,
             NULL,
             NULL
      FROM   tbhccsmanager a
     WHERE   a.cequipname =:arg_line_code
         AND a.citemlot IS NOT NULL
         AND (a.cequipname, a.cpbaitem, a.citemname, a.cfeeder, TO_CHAR (a.ddockdate, 'YYYYMMDDHH24MISS'), a.ctb) IN
                     (  SELECT   cequipname,
                                 cpbaitem,
                                 citemname,
                                 cfeeder,
                                 MAX (TO_CHAR (ddockdate, 'YYYYMMDDHH24MISS')),
                                 ctb
                          FROM   tbhccsmanager
                         WHERE   cequipname = :arg_line_code
                             AND TO_CHAR (ddockdate, 'YYYYMMDDHH24MISS') <=:arg_ijobdate        
                             AND ( cpbaitem LIKE 'M%' OR  cpbaitem LIKE 'E%' OR  cpbaitem LIKE 'CP%' )
                      GROUP BY   cequipname,
                                 cpbaitem,
                                 citemname,
                                 cfeeder,
                                 ctb);
											
	if f_sql_check() < 0 then 
		return 
	end if 

COMMIT;

f_msg_mdi_help( string(i) +"/" + string(dw_2.rowcount()) )

LOOP UNTIL i = dw_2.rowcount( )



end event

type gb_1 from so_groupbox within w_pln_line_master
integer x = 9
integer width = 786
integer height = 304
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

