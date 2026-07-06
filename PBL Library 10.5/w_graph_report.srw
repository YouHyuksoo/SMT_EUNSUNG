HA$PBExportHeader$w_graph_report.srw
$PBExportComments$$$HEX7$$98b704d52000b5d1c4ac00adacb9$$ENDHEX$$
forward
global type w_graph_report from w_graph_root
end type
type cb_resize from commandbutton within w_graph_report
end type
type cb_1x from so_commandbutton within w_graph_report
end type
type cb_2x from so_commandbutton within w_graph_report
end type
type hsb_1 from hscrollbar within w_graph_report
end type
type cb_1 from so_commandbutton within w_graph_report
end type
type cb_2 from so_commandbutton within w_graph_report
end type
end forward

global type w_graph_report from w_graph_root
integer width = 4722
integer height = 3144
string title = "Statistical Chart"
cb_resize cb_resize
cb_1x cb_1x
cb_2x cb_2x
hsb_1 hsb_1
cb_1 cb_1
cb_2 cb_2
end type
global w_graph_report w_graph_report

forward prototypes
public subroutine wf_zoom (string as_type)
end prototypes

public subroutine wf_zoom (string as_type);IF 	AS_TYPE = '+-' THEN
			dw_1.Object.DataWindow.Zoom = '71' 
ELSEIF AS_TYPE = '+-2' THEN
			dw_2.Object.DataWindow.Zoom = '90' 
ELSE
			dw_1.Object.DataWindow.Zoom = '100' 	
END IF
end subroutine

event ue_post_open;call super::ue_post_open;LONG		I, ll_row

//$$HEX11$$04d5b0b930d12000a9c6c0c9200024c115c8c0bc18c2$$ENDHEX$$
ivi_paper = 9  // A4 210 x 297 mm


//==============================
// $$HEX8$$acb9acc074c788c92000e8ceb8d264b8$$ENDHEX$$
//==============================
cb_resize.x = gr_1.x
cb_resize.y = gr_1.y+ gr_1.height
cb_resize.width = gr_1.width


end event

on w_graph_report.create
int iCurrent
call super::create
this.cb_resize=create cb_resize
this.cb_1x=create cb_1x
this.cb_2x=create cb_2x
this.hsb_1=create hsb_1
this.cb_1=create cb_1
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_resize
this.Control[iCurrent+2]=this.cb_1x
this.Control[iCurrent+3]=this.cb_2x
this.Control[iCurrent+4]=this.hsb_1
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.cb_2
end on

on w_graph_report.destroy
call super::destroy
destroy(this.cb_resize)
destroy(this.cb_1x)
destroy(this.cb_2x)
destroy(this.hsb_1)
destroy(this.cb_1)
destroy(this.cb_2)
end on

event ue_data_control;call super::ue_data_control;datetime	ldt_start, ldt_end
string		ls_init
Datawindow lvdw_primary

lvdw_primary =Message.PowerObjectParm

CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		
			setpointer( hourglass! )
			gr_1.reset ( all! )
			dw_1.dataobject	=	gvs_data_object
			dw_2.dataobject	=	""	
			dw_1.settransobject( sqlca )
			dw_2.settransobject( sqlca )
			
			//==========================================
			// Title Setup
			//==========================================
			if isValid(lvdw_primary) then
			gr_1.title	=	lvdw_primary.Describe( "report_title_t.text")
			else
				Return
			end if
			/*********************************************************
			* $$HEX19$$e4b26dadb4c5200098ccacb97cb9200004c75cd5200090c7ccb8200088bdecb724c630ae2000$$ENDHEX$$: w_genapp_frame$$HEX5$$d0c51cc1200020c1b8c5$$ENDHEX$$
			* $$HEX16$$74c7f3acd0c51cc194b22000c0bc58d6200091c7c5c5ccb9200018c289d568d5$$ENDHEX$$
			* BY KIM, YONG-CHUL
			**********************************************************/
			
			if	Gvs_language =	'C' or Gvs_language = 'K'    or Gvs_language = 'E'  then
			
				if gds_dual.rowcount() < 1 then 
					messagebox("Error" , "Language Info Not Found ")
					return
				else
					f_msg_mdi_help( "Dual Source "+string(gds_dual.rowcount())+" Rows Found" )
				end if
			  
				w_main_frame.SetMicroHelp("Language Change...")
				f_dual_lang_change_text(this)
			
				f_msg_mdi_help( '')
				w_main_frame.SetMicroHelp("Language Change Done.")
			end if
			
			wf_set_listbox()
			
			f_set_column_dddw( dw_1 )
			f_set_column_dddw( dw_2 )

			lvdw_primary.ShareData( dw_1 )
			f_msg_mdi_help(string(dw_2.rowcount()) + " Rows retrieved"  )
			plb_value.triggerevent( selectionchanged! )
			
						
			
		
END CHOOSE

end event

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
Ivs_resize_type    = 'GRAPH'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
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

F_MENU_CONTROL('REPORT' , TRUE)  // All Data Control

/****************************************
* 
****************************************/

end event

event open;call super::open;triggerevent('ue_post_open') 

end event

event resize;call super::resize;cb_resize.x = gr_1.x
cb_resize.y = gr_1.y+ gr_1.height
cb_resize.width = gr_1.width
dw_1.y  = cb_resize.y + cb_resize.height +2

cb_1x.enabled = false
cb_2x.enabled = true



end event

type cbx_count from w_graph_root`cbx_count within w_graph_report
integer x = 411
integer y = 1352
integer width = 343
integer height = 72
end type

type cbx_data from w_graph_root`cbx_data within w_graph_report
integer x = 151
integer y = 344
integer width = 471
integer height = 56
end type

type pb_color from w_graph_root`pb_color within w_graph_report
integer x = 210
integer y = 52
boolean originalsize = false
end type

type pb_print from w_graph_root`pb_print within w_graph_report
integer x = 530
integer y = 52
boolean originalsize = false
end type

type pb_spacing from w_graph_root`pb_spacing within w_graph_report
integer x = 421
integer y = 52
boolean originalsize = false
end type

type pb_title from w_graph_root`pb_title within w_graph_report
integer x = 320
integer y = 52
boolean originalsize = false
end type

type pb_type from w_graph_root`pb_type within w_graph_report
integer x = 105
integer y = 52
boolean originalsize = false
end type

type st_label from w_graph_root`st_label within w_graph_report
integer width = 539
end type

type lb_category from w_graph_root`lb_category within w_graph_report
integer x = 41
integer y = 568
integer width = 699
integer height = 764
boolean hscrollbar = true
end type

type st_category from w_graph_root`st_category within w_graph_report
integer x = 46
integer y = 492
integer width = 603
boolean enabled = true
alignment alignment = left!
end type

type st_value from w_graph_root`st_value within w_graph_report
integer x = 46
integer y = 1356
integer width = 361
integer height = 68
string text = "Values"
alignment alignment = left!
end type

type plb_value from w_graph_root`plb_value within w_graph_report
integer x = 41
integer y = 1440
integer width = 699
integer height = 980
boolean hscrollbar = true
end type

type dw_5 from w_graph_root`dw_5 within w_graph_report
boolean visible = false
integer x = 786
integer y = 1724
integer width = 3845
integer height = 480
end type

type dw_4 from w_graph_root`dw_4 within w_graph_report
boolean visible = false
integer x = 786
integer y = 1724
integer width = 3845
integer height = 480
end type

type dw_3 from w_graph_root`dw_3 within w_graph_report
boolean visible = false
integer x = 786
integer y = 1724
integer width = 3845
integer height = 480
end type

type dw_2 from w_graph_root`dw_2 within w_graph_report
boolean visible = false
integer x = 786
integer y = 1724
integer width = 3845
integer height = 480
end type

type dw_1 from w_graph_root`dw_1 within w_graph_report
integer x = 786
integer y = 1724
integer width = 3845
integer height = 480
boolean titlebar = true
string title = "Data View"
boolean controlmenu = true
boolean maxbox = true
end type

event dw_1::dragdrop;call super::dragdrop;DATAWINDOW ldw_Source 
CommandButton  lcb__Source 
LONG LVL_ORG_Source_Y

IF source.TypeOf() = CommandButton! THEN
    lcb__Source = source	
    LVL_ORG_Source_Y =lcb__Source.Y
    
    lcb__Source.Y = DW_1.Y+ POINTERY()
	 
     DW_1.HEIGHT = DW_1.HEIGHT - (  DW_1.Y+ POINTERY() - LVL_ORG_Source_Y  - 10 ) 
	DW_1.Y =   lcb__Source.Y +  lcb__Source.HEIGHT

	
	gr_1.HEIGHT =  lcb__Source.Y - gr_1.Y

	  
END IF

THIS.DRAG(END!)
	
end event

type gb_view from w_graph_root`gb_view within w_graph_report
integer x = 9
integer y = 424
integer width = 777
integer height = 2020
integer weight = 400
long textcolor = 0
end type

type gb_process from w_graph_root`gb_process within w_graph_report
integer x = 0
integer width = 777
integer weight = 400
long textcolor = 0
end type

type gr_1 from w_graph_root`gr_1 within w_graph_report
integer x = 777
integer y = 24
integer width = 3845
integer height = 1676
string pointer = "HyperLink!"
long backcolor = 15780518
integer elevation = -30
integer rotation = -55
integer perspective = 1
integer depth = 40
end type

on gr_1.create
call super::create
Category.MajorGridLine=dot!
Category.DispAttr.TextSize=11
Category.DispAttr.DisplayExpression="if( category = 'Total', category, if(   categorycount  > 15, right(category,2), category))"
Values.RoundTo=0
Values.DispAttr.TextSize=13
LegendDispAttr.TextSize=11
end on

event gr_1::dragdrop;call super::dragdrop;CommandButton  ldw_Source 
LONG LVL_ORG_Source_Y
IF source.TypeOf() = CommandButton! THEN
    ldw_Source = source	
    LVL_ORG_Source_Y =ldw_Source.Y
    
     ldw_Source.Y = gr_1.Y + POINTERY()
	 
     gr_1.HEIGHT =  gr_1.HEIGHT  -  ( LVL_ORG_Source_Y - ldw_Source.Y  ) 
	  
	dw_1.Y =   ldw_Source.Y + ldw_Source.HEIGHT
	dw_1.HEIGHT = 	dw_1.HEIGHT +( LVL_ORG_Source_Y -  POINTERY() -10 )
		  
END IF
THIS.DRAG(END!)
end event

type cb_resize from commandbutton within w_graph_report
integer x = 786
integer y = 1704
integer width = 3845
integer height = 16
integer taborder = 80
boolean dragauto = true
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "SizeNS!"
end type

type cb_1x from so_commandbutton within w_graph_report
integer x = 41
integer y = 164
integer width = 325
integer taborder = 50
boolean bringtotop = true
integer weight = 400
boolean enabled = false
string text = "1X"
end type

event clicked;call super::clicked;gr_1.width = gr_1.width / 2
this.enabled = false
cb_2x.enabled = true
end event

type cb_2x from so_commandbutton within w_graph_report
integer x = 375
integer y = 164
integer width = 325
integer taborder = 60
boolean bringtotop = true
integer weight = 400
string text = "2X"
end type

event clicked;call super::clicked;cb_1x.enabled = true
gr_1.width = gr_1.width * 2
this.enabled = false
end event

type hsb_1 from hscrollbar within w_graph_report
integer x = 777
integer y = 28
integer width = 233
integer height = 68
boolean bringtotop = true
end type

event lineright;gr_1.x = gr_1.x - 100
end event

event lineleft;gr_1.x = gr_1.x + 100
end event

event constructor;this.position = gr_1.x
end event

type cb_1 from so_commandbutton within w_graph_report
integer x = 41
integer y = 248
integer width = 325
integer taborder = 70
boolean bringtotop = true
integer weight = 400
string text = "<<"
end type

event clicked;call super::clicked;gr_1.width = gr_1.width - 100
end event

type cb_2 from so_commandbutton within w_graph_report
integer x = 375
integer y = 248
integer width = 325
integer taborder = 80
boolean bringtotop = true
integer weight = 400
string text = ">>"
end type

event clicked;call super::clicked;gr_1.width = gr_1.width + 100
end event

