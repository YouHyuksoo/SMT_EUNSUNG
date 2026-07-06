HA$PBExportHeader$uo_ymd_calendar_4_popup.sru
$PBExportComments$yyyy mm dd Calendar Today
forward
global type uo_ymd_calendar_4_popup from userobject
end type
type cb_1 from commandbutton within uo_ymd_calendar_4_popup
end type
type st_1 from statictext within uo_ymd_calendar_4_popup
end type
type em_yyyymm from editmask within uo_ymd_calendar_4_popup
end type
type hsb_1 from hscrollbar within uo_ymd_calendar_4_popup
end type
type dw_1 from datawindow within uo_ymd_calendar_4_popup
end type
type em_1 from editmask within uo_ymd_calendar_4_popup
end type
end forward

global type uo_ymd_calendar_4_popup from userobject
integer width = 658
integer height = 588
long backcolor = 12632256
string pointer = "Help!"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event ue_mousedeactive ( )
cb_1 cb_1
st_1 st_1
em_yyyymm em_yyyymm
hsb_1 hsb_1
dw_1 dw_1
em_1 em_1
end type
global uo_ymd_calendar_4_popup uo_ymd_calendar_4_popup

forward prototypes
public function string uf_get_ymd_string ()
public function datetime uf_get_ymd_dt ()
public function string uf_get_ymd_str ()
public function datetime text ()
public subroutine settext (string arg_date)
end prototypes

public function string uf_get_ymd_string ();RETURN EM_1.TEXT
end function

public function datetime uf_get_ymd_dt ();//DATETIME LD_RTN_DATE
//
//SELECT TO_DATE(:EM_1.TEXT,'YYYY/MM/DD')
//INTO   :LD_RTN_DATE
//FROM   DUAL
//;
//
//RETURN LD_RTN_DATE
RETURN DATETIME(DATE(EM_1.TEXT))
end function

public function string uf_get_ymd_str ();RETURN STRING(DATETIME(DATE(EM_1.TEXT)),'YYYYMMDD')
end function

public function datetime text ();RETURN DATETIME(DATE(EM_1.TEXT))
end function

public subroutine settext (string arg_date);EM_1.TEXT = arg_date
end subroutine

on uo_ymd_calendar_4_popup.create
this.cb_1=create cb_1
this.st_1=create st_1
this.em_yyyymm=create em_yyyymm
this.hsb_1=create hsb_1
this.dw_1=create dw_1
this.em_1=create em_1
this.Control[]={this.cb_1,&
this.st_1,&
this.em_yyyymm,&
this.hsb_1,&
this.dw_1,&
this.em_1}
end on

on uo_ymd_calendar_4_popup.destroy
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.em_yyyymm)
destroy(this.hsb_1)
destroy(this.dw_1)
destroy(this.em_1)
end on

type cb_1 from commandbutton within uo_ymd_calendar_4_popup
integer x = 558
integer width = 101
integer height = 92
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = symbol!
fontpitch fontpitch = variable!
string facename = "Marlett"
string text = "r"
end type

event clicked;close(w_calendar_popup)
end event

event rbuttondown;MESSAGEBOX('UF_GET_YMD_STRING() --> YYYY/MM/DD','UF_GET_YMD_DT() DATETIME' + 'UF_GET_YMD_STR() YYYYMMDD')
end event

type st_1 from statictext within uo_ymd_calendar_4_popup
integer x = 416
integer width = 146
integer height = 96
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 8388608
boolean enabled = false
string text = "Double Click!!"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_yyyymm from editmask within uo_ymd_calendar_4_popup
integer y = 104
integer width = 256
integer height = 60
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 65280
long backcolor = 0
maskdatatype maskdatatype = datetimemask!
string mask = "yyyy/mm"
end type

event constructor;SELECT TO_CHAR(SYSDATE,'YYYY/MM') INTO :TEXT FROM DUAL ;
end event

type hsb_1 from hscrollbar within uo_ymd_calendar_4_popup
integer x = 256
integer y = 100
integer width = 389
integer height = 68
end type

event lineleft;Integer yyyy , mm
yyyy = integer(left(em_yyyymm.text,4))
mm   = integer(right(em_yyyymm.text,2))
IF YYYY = 0 OR MM = 0 THEN RETURN
select  to_char(add_months(to_date(:em_yyyymm.text||'/01','yyyy/mm/dd') , -1 ) , 'yyyy/mm')
  into :em_yyyymm.text
  from dual ;
if f_sql_check() < 0 then 
	return
end if

yyyy = integer(left(em_yyyymm.text,4))
mm   = integer(right(em_yyyymm.text,2))
dw_1.SetRedraw(FALSE)
dw_1.Reset()
dw_1.InsertRow(0)

// $$HEX12$$74c788bcecb274c7200087ba7cc74caec0c9200088c798b0$$ENDHEX$$? $$HEX9$$74c783ac40c72000dcad59ce74c7c8b24cae$$ENDHEX$$..
Integer month[12] = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }

// $$HEX12$$3cba00c8200024c744b178c7c0c9200080acacc058d590c7$$ENDHEX$$.
IF IsDate(String(yyyy)+"/2/29") THEN	// $$HEX6$$24c744b174c7c8b24cae2000$$ENDHEX$$29$$HEX7$$7cc74caec0c9200018c97cc5c0c9$$ENDHEX$$..
	month[2] = 29
END IF

// $$HEX5$$74c788bcecb258c72000$$ENDHEX$$1$$HEX10$$7cc740c7200034bba8c2200094c67cc778c700ac$$ENDHEX$$?
Integer	first_day
first_day = Daynumber(Date(String(yyyy)+"-"+String(mm)+"-01"))

IF first_day = 1 THEN
	first_day = 7
ELSE
	first_day = first_day - 1
END IF

Integer i
FOR i = first_day TO first_day + month[mm] - 1
	dw_1.Object.Data[1, i] = String((i - first_day) + 1)
NEXT

//st_year.Text = String(yyyy)
//st_month.Text = String(mm)

dw_1.SetRedraw(TRUE)
//return FALSE
end event

event lineright;Integer yyyy , mm

yyyy = integer(left(em_yyyymm.text,4))
mm   = integer(right(em_yyyymm.text,2))
IF YYYY = 0 OR MM = 0 THEN RETURN

select  to_char(add_months(to_date(:em_yyyymm.text||'/01','yyyy/mm/dd') , 1 ) , 'yyyy/mm')
  into :em_yyyymm.text
  from dual ;
if f_sql_check() < 0 then 
	return
end if

yyyy = integer(left(em_yyyymm.text,4))
mm   = integer(right(em_yyyymm.text,2))
dw_1.SetRedraw(FALSE)
dw_1.Reset()
dw_1.InsertRow(0)

// $$HEX12$$74c788bcecb274c7200087ba7cc74caec0c9200088c798b0$$ENDHEX$$? $$HEX9$$74c783ac40c72000dcad59ce74c7c8b24cae$$ENDHEX$$..
Integer month[12] = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }

// $$HEX12$$3cba00c8200024c744b178c7c0c9200080acacc058d590c7$$ENDHEX$$.
IF IsDate(String(yyyy)+"/2/29") THEN	// $$HEX6$$24c744b174c7c8b24cae2000$$ENDHEX$$29$$HEX7$$7cc74caec0c9200018c97cc5c0c9$$ENDHEX$$..
	month[2] = 29
END IF

// $$HEX5$$74c788bcecb258c72000$$ENDHEX$$1$$HEX10$$7cc740c7200034bba8c2200094c67cc778c700ac$$ENDHEX$$?
Integer	first_day
first_day = Daynumber(Date(String(yyyy)+"-"+String(mm)+"-01"))

IF first_day = 1 THEN
	first_day = 7
ELSE
	first_day = first_day - 1
END IF

Integer i
FOR i = first_day TO first_day + month[mm] - 1
	dw_1.Object.Data[1, i] = String((i - first_day) + 1)
NEXT

//st_year.Text = String(yyyy)
//st_month.Text = String(mm)

dw_1.SetRedraw(TRUE)
//return FALSE
end event

type dw_1 from datawindow within uo_ymd_calendar_4_popup
integer y = 176
integer width = 645
integer height = 400
integer taborder = 30
string dataobject = "d_ex_month"
boolean livescroll = true
end type

event constructor;DW_1.SETTRANSOBJECT(SQLCA)

Integer yyyy , mm

yyyy = integer(left(em_yyyymm.text,4))
mm   = integer(right(em_yyyymm.text,2))
dw_1.SetRedraw(FALSE)
dw_1.Reset()
dw_1.InsertRow(0)

// $$HEX12$$74c788bcecb274c7200087ba7cc74caec0c9200088c798b0$$ENDHEX$$? $$HEX9$$74c783ac40c72000dcad59ce74c7c8b24cae$$ENDHEX$$..
Integer month[12] = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }

// $$HEX12$$3cba00c8200024c744b178c7c0c9200080acacc058d590c7$$ENDHEX$$.
IF IsDate(String(yyyy)+"/2/29") THEN	// $$HEX6$$24c744b174c7c8b24cae2000$$ENDHEX$$29$$HEX7$$7cc74caec0c9200018c97cc5c0c9$$ENDHEX$$..
	month[2] = 29
END IF

// $$HEX5$$74c788bcecb258c72000$$ENDHEX$$1$$HEX10$$7cc740c7200034bba8c2200094c67cc778c700ac$$ENDHEX$$?
Integer	first_day
first_day = Daynumber(Date(String(yyyy)+"-"+String(mm)+"-01"))

IF first_day = 1 THEN
	first_day = 7
ELSE
	first_day = first_day - 1
END IF

Integer i
FOR i = first_day TO first_day + month[mm] - 1
	dw_1.Object.Data[1, i] = String((i - first_day) + 1)
NEXT

//st_year.Text = String(yyyy)
//st_month.Text = String(mm)

dw_1.SetRedraw(TRUE)
//return FALSE
end event

event doubleclicked;if row < 1 then 
	return 
end if
EM_1.TEXT = em_yyyymm.text +'/'+dw_1.getitemstring( row , getcolumnname() ) 

message.stringparm = EM_1.TEXT
CLOSEWITHRETURN( w_calendar_popup , message.stringparm ) 



end event

type em_1 from editmask within uo_ymd_calendar_4_popup
integer width = 411
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "Help!"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datetimemask!
string mask = "yyyy/mm/dd"
boolean spin = true
end type

event constructor;SELECT TO_CHAR(SYSDATE , 'YYYY/MM/DD') INTO :TEXT FROM DUAL ;
end event

