HA$PBExportHeader$w_sql_painter.srw
forward
global type w_sql_painter from w_main_root
end type
type mle_sql from multilineedit within w_sql_painter
end type
type cb_1 from so_commandbutton within w_sql_painter
end type
type cb_2 from so_commandbutton within w_sql_painter
end type
type cb_3 from so_commandbutton within w_sql_painter
end type
type cb_4 from so_commandbutton within w_sql_painter
end type
type cb_5 from so_commandbutton within w_sql_painter
end type
type cb_6 from so_commandbutton within w_sql_painter
end type
type cb_7 from so_commandbutton within w_sql_painter
end type
type ddlb_table_name from uo_table_name within w_sql_painter
end type
type st_1 from so_statictext within w_sql_painter
end type
type cb_8 from so_commandbutton within w_sql_painter
end type
type cb_9 from so_commandbutton within w_sql_painter
end type
type gb_1 from so_groupbox within w_sql_painter
end type
type gb_2 from so_groupbox within w_sql_painter
end type
type gb_3 from so_groupbox within w_sql_painter
end type
end forward

global type w_sql_painter from w_main_root
integer width = 4032
integer height = 2168
boolean minbox = false
boolean maxbox = false
boolean center = true
mle_sql mle_sql
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
cb_4 cb_4
cb_5 cb_5
cb_6 cb_6
cb_7 cb_7
ddlb_table_name ddlb_table_name
st_1 st_1
cb_8 cb_8
cb_9 cb_9
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_sql_painter w_sql_painter

on w_sql_painter.create
int iCurrent
call super::create
this.mle_sql=create mle_sql
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.cb_4=create cb_4
this.cb_5=create cb_5
this.cb_6=create cb_6
this.cb_7=create cb_7
this.ddlb_table_name=create ddlb_table_name
this.st_1=create st_1
this.cb_8=create cb_8
this.cb_9=create cb_9
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.mle_sql
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.cb_3
this.Control[iCurrent+5]=this.cb_4
this.Control[iCurrent+6]=this.cb_5
this.Control[iCurrent+7]=this.cb_6
this.Control[iCurrent+8]=this.cb_7
this.Control[iCurrent+9]=this.ddlb_table_name
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.cb_8
this.Control[iCurrent+12]=this.cb_9
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_2
this.Control[iCurrent+15]=this.gb_3
end on

on w_sql_painter.destroy
call super::destroy
destroy(this.mle_sql)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.cb_4)
destroy(this.cb_5)
destroy(this.cb_6)
destroy(this.cb_7)
destroy(this.ddlb_table_name)
destroy(this.st_1)
destroy(this.cb_8)
destroy(this.cb_9)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
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

F_MENU_CONTROL('DATA_CONTROL' , FALSE)  // All Data Control

/****************************************
* 
****************************************/

end event

event open;call super::open;mle_sql.setfocus( )
end event

event ue_post_open;//RETURN
end event

event resize;//RETURN
end event

type dw_5 from w_main_root`dw_5 within w_sql_painter
integer y = 1240
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_sql_painter
integer y = 1244
integer taborder = 0
end type

type dw_3 from w_main_root`dw_3 within w_sql_painter
integer y = 1248
integer taborder = 0
end type

type dw_2 from w_main_root`dw_2 within w_sql_painter
integer x = 2935
integer y = 300
integer width = 1047
integer height = 700
integer taborder = 0
boolean titlebar = true
string title = "Clip"
end type

type dw_1 from w_main_root`dw_1 within w_sql_painter
integer y = 1228
integer width = 3995
integer height = 836
integer taborder = 0
boolean titlebar = true
string title = "SQL Result (DW1)"
string dataobject = "d_null_datawindow"
end type

type mle_sql from multilineedit within w_sql_painter
integer x = 5
integer y = 304
integer width = 2917
integer height = 696
integer taborder = 1
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 65280
long backcolor = 0
boolean hscrollbar = true
boolean vscrollbar = true
boolean autohscroll = true
boolean autovscroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from so_commandbutton within w_sql_painter
integer x = 869
integer y = 92
integer width = 407
integer height = 88
boolean bringtotop = true
string text = "Rollback"
end type

event clicked;call super::clicked;rollback;
mle_sql.text = mle_sql.text+'Rollback OK'+'~r~n'

end event

type cb_2 from so_commandbutton within w_sql_painter
integer x = 50
integer y = 92
integer width = 407
integer height = 88
boolean bringtotop = true
string text = "Select SQL"
end type

event clicked;call super::clicked;string ERRORS, sql_syntax
string presentation_str, dwsyntax_str

sql_syntax = mle_sql.text
sql_syntax = righttrim(sql_syntax)

if right(sql_syntax,1) = ';' then
	
	sql_syntax = mid( sql_syntax , 1 , len(sql_syntax) -1 )
	
else
	Messagebox("Notify" , "Syntax Invalid, Not found syntax end mark => ; ")
	mle_sql.setfocus( )
	return
end if


presentation_str = "style(type=grid)"
dwsyntax_str = SQLCA.SyntaxFromSQL(sql_syntax, presentation_str, ERRORS)

IF Len(ERRORS) > 0 THEN
   MessageBox("Caution" , "SyntaxFromSQL caused these errors: " + ERRORS)
   RETURN
END IF

dw_1.CREATE( DWSYNTAX_STR, ERRORS)
dw_1.BRINGTOTOP = TRUE 
dw_1.OBJECT.DATAWINDOW.TABLE.UPDATEKEYINPLACE='YES'
dw_1.OBJECT.DATAWINDOW.TABLE.UPDATEWHERE=2

//================================================
//
//================================================
IF Len(ERRORS) > 0 THEN
   MessageBox("Caution", "Create cause these errors: " + ERRORS)
   RETURN
END IF

dw_1.settransobject( sqlca)
dw_1.retrieve( )
end event

type cb_3 from so_commandbutton within w_sql_painter
integer x = 41
integer y = 1076
integer width = 407
integer height = 96
boolean bringtotop = true
string text = "Delete Row"
end type

event clicked;call super::clicked;if dw_1.getrow( ) < 1 then return

   dw_1.deleterow(dw_1.getrow() )
end event

type cb_4 from so_commandbutton within w_sql_painter
integer x = 457
integer y = 1076
integer width = 407
integer height = 96
boolean bringtotop = true
string text = "Update Row"
end type

event clicked;call super::clicked;if dw_1.update( ) < 0 then 
   rollback;
else
	
end if
end event

type cb_5 from so_commandbutton within w_sql_painter
integer x = 1280
integer y = 92
integer width = 407
integer height = 88
boolean bringtotop = true
string text = "Commit"
end type

event clicked;call super::clicked;commit ;
mle_sql.text = mle_sql.text+'Commit OK'+'~r~n'
end event

type cb_6 from so_commandbutton within w_sql_painter
integer x = 457
integer y = 92
integer width = 407
integer height = 88
integer taborder = 20
boolean bringtotop = true
string text = "Execute SQL"
end type

event clicked;call super::clicked;string lvs_sql

if righttrim(mle_sql.selectedtext()) <> "" or len( righttrim(mle_sql.selectedtext())) > 0  then 
	
	Messagebox("Selected" ,righttrim( mle_sql.selectedtext())	 )
	lvs_sql = righttrim(mle_sql.selectedtext()	)
	
else
	lvs_sql = righttrim(mle_sql.text)
end if 


if right(lvs_sql,1) = ';' then
	
	lvs_sql =  MID( lvs_sql , 1 , LEN(lvs_sql) -1 )
else

	Messagebox("Notify" , "Syntax Invalid, Not found syntax end mark => ; ")
	mle_sql.setfocus( )	
	Return
end if

Execute Immediate :lvs_sql ;

if sqlca.sqlcode < 0 then 
	mle_sql.text = mle_sql.text +'~r~n'
	mle_sql.text = mle_sql.text+sqlca.sqlerrtext+'~r~n'
else
	mle_sql.text = mle_sql.text +'~r~n'	
	mle_sql.text = mle_sql.text+sqlca.sqlerrtext+' '+string(sqlca.sqlnrows)+' Changed.'+'~r~n'	
end if
	
end event

type cb_7 from so_commandbutton within w_sql_painter
integer x = 3538
integer y = 108
integer width = 338
integer height = 88
integer taborder = 30
boolean bringtotop = true
string text = "Exit"
end type

event clicked;call super::clicked;Rollback;
Close(parent)
end event

type ddlb_table_name from uo_table_name within w_sql_painter
integer x = 1746
integer y = 112
integer width = 1088
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
end type

type st_1 from so_statictext within w_sql_painter
integer x = 1746
integer y = 44
integer width = 1088
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Table Name"
end type

type cb_8 from so_commandbutton within w_sql_painter
integer x = 2853
integer y = 108
integer width = 338
integer height = 88
integer taborder = 30
boolean bringtotop = true
string text = "Insert SQL"
end type

event clicked;call super::clicked;string lvs_table_name , lvs_column_name 
long i , lvi_count

lvs_table_name = ddlb_table_name.text


declare cl1 cursor for
select column_name 
 from user_tab_columns 
where table_name = :lvs_table_name ;

if f_sql_check() < 0 then
	return
end if

mle_sql.text = mle_sql.text+'~r~n'+'INSERT INTO '+lvs_table_name+' ( '+'~r~n'

select count(*) into :lvi_count
 from user_tab_columns 
where table_name = :lvs_table_name ;

if f_sql_check() < 0 then
	return
end if

open cl1;

do
	i++
	
	fetch cl1 into :lvs_column_name ;
	
	if f_sql_check() < 0 then 
		close cl1;
		return
	end if
	
	if sqlca.sqlcode = 100 then 
		close cl1 ;
		exit
	end if

	if i = lvi_count then
		mle_sql.text = mle_sql.text + lvs_column_name + ' )'+'~r~n'
	else
		mle_sql.text = mle_sql.text + lvs_column_name + ','+'~r~n'
	end if
	
loop until 1 = 2

end event

type cb_9 from so_commandbutton within w_sql_painter
integer x = 3195
integer y = 108
integer width = 338
integer height = 88
integer taborder = 40
boolean bringtotop = true
string text = "Select SQL"
end type

event clicked;call super::clicked;string lvs_table_name , lvs_column_name 
long i , lvi_count

lvs_table_name = ddlb_table_name.text


declare cl1 cursor for
select column_name 
 from user_tab_columns 
where table_name = :lvs_table_name ;

if f_sql_check() < 0 then
	return
end if

mle_sql.text = mle_sql.text+'~r~n'+'SELECT '+'~r~n'

select count(*) into :lvi_count
 from user_tab_columns 
where table_name = :lvs_table_name ;

if f_sql_check() < 0 then
	return
end if

open cl1;

do
	i++
	
	fetch cl1 into :lvs_column_name ;
	
	if f_sql_check() < 0 then 
		close cl1;
		return
	end if
	
	if sqlca.sqlcode = 100 then 
		close cl1 ;
		exit
	end if

	if i = lvi_count then
		mle_sql.text = mle_sql.text +' FROM '+lvs_table_name + ' ;'+'~r~n'
	elseif i = lvi_count -1 then
		mle_sql.text = mle_sql.text +'~t'+ lvs_column_name + '~r~n'
	else
		mle_sql.text = mle_sql.text +'~t'+ lvs_column_name + ','+'~r~n'		
	end if
	
loop until 1 = 2

end event

type gb_1 from so_groupbox within w_sql_painter
integer y = 1008
integer width = 901
integer height = 200
integer weight = 700
long textcolor = 16711680
string text = "Row Data"
end type

type gb_2 from so_groupbox within w_sql_painter
integer x = 1719
integer width = 2254
integer height = 236
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_3 from so_groupbox within w_sql_painter
integer x = 9
integer width = 1710
integer height = 236
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

