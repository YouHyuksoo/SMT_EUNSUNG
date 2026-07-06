HA$PBExportHeader$w_power_printer.srw
$PBExportComments$PowerPrinter sample main window
forward
global type w_power_printer from window
end type
type cb_help from commandbutton within w_power_printer
end type
type dw_1 from datawindow within w_power_printer
end type
type tab_1 from tab within w_power_printer
end type
type tabpage_prnlist from userobject within tab_1
end type
type cb_3 from commandbutton within tabpage_prnlist
end type
type st_2 from statictext within tabpage_prnlist
end type
type lb_printerlist from listbox within tabpage_prnlist
end type
type cb_printerlist from commandbutton within tabpage_prnlist
end type
type st_5 from statictext within tabpage_prnlist
end type
type st_6 from statictext within tabpage_prnlist
end type
type tabpage_prnlist from userobject within tab_1
cb_3 cb_3
st_2 st_2
lb_printerlist lb_printerlist
cb_printerlist cb_printerlist
st_5 st_5
st_6 st_6
end type
type tabpage_orientation from userobject within tab_1
end type
type st_7 from statictext within tabpage_orientation
end type
type st_orientation from statictext within tabpage_orientation
end type
type cb_1 from commandbutton within tabpage_orientation
end type
type cb_2 from commandbutton within tabpage_orientation
end type
type tabpage_orientation from userobject within tab_1
st_7 st_7
st_orientation st_orientation
cb_1 cb_1
cb_2 cb_2
end type
type tabpage_binlist from userobject within tab_1
end type
type cb_getbinlist from commandbutton within tabpage_binlist
end type
type lb_bins from listbox within tabpage_binlist
end type
type rb_default from radiobutton within tabpage_binlist
end type
type rb_named from radiobutton within tabpage_binlist
end type
type cb_getbin from commandbutton within tabpage_binlist
end type
type cb_setbin from commandbutton within tabpage_binlist
end type
type tabpage_binlist from userobject within tab_1
cb_getbinlist cb_getbinlist
lb_bins lb_bins
rb_default rb_default
rb_named rb_named
cb_getbin cb_getbin
cb_setbin cb_setbin
end type
type tabpage_papersize from userobject within tab_1
end type
type lb_papersizes from listbox within tabpage_papersize
end type
type cb_getpapersizelist from commandbutton within tabpage_papersize
end type
type cb_getpapersize from commandbutton within tabpage_papersize
end type
type cb_setpapersize from commandbutton within tabpage_papersize
end type
type st_10 from statictext within tabpage_papersize
end type
type tabpage_papersize from userobject within tab_1
lb_papersizes lb_papersizes
cb_getpapersizelist cb_getpapersizelist
cb_getpapersize cb_getpapersize
cb_setpapersize cb_setpapersize
st_10 st_10
end type
type tabpage_other from userobject within tab_1
end type
type cb_testscale from commandbutton within tabpage_other
end type
type st_39 from statictext within tabpage_other
end type
type st_14 from statictext within tabpage_other
end type
type st_13 from statictext within tabpage_other
end type
type st_12 from statictext within tabpage_other
end type
type st_9 from statictext within tabpage_other
end type
type dw_2 from datawindow within tabpage_other
end type
type cb_test from commandbutton within tabpage_other
end type
type st_8 from statictext within tabpage_other
end type
type st_11 from statictext within tabpage_other
end type
type tabpage_other from userobject within tab_1
cb_testscale cb_testscale
st_39 st_39
st_14 st_14
st_13 st_13
st_12 st_12
st_9 st_9
dw_2 dw_2
cb_test cb_test
st_8 st_8
st_11 st_11
end type
type tabpage_error from userobject within tab_1
end type
type st_18 from statictext within tabpage_error
end type
type st_17 from statictext within tabpage_error
end type
type st_16 from statictext within tabpage_error
end type
type st_15 from statictext within tabpage_error
end type
type cb_getexmsg from commandbutton within tabpage_error
end type
type cb_getexcode from commandbutton within tabpage_error
end type
type tabpage_error from userobject within tab_1
st_18 st_18
st_17 st_17
st_16 st_16
st_15 st_15
cb_getexmsg cb_getexmsg
cb_getexcode cb_getexcode
end type
type tabpage_printer_connection from userobject within tab_1
end type
type st_24 from statictext within tabpage_printer_connection
end type
type st_23 from statictext within tabpage_printer_connection
end type
type st_22 from statictext within tabpage_printer_connection
end type
type st_21 from statictext within tabpage_printer_connection
end type
type sle_addprnconn_printername from singlelineedit within tabpage_printer_connection
end type
type sle_addprnconn_servername from singlelineedit within tabpage_printer_connection
end type
type st_20 from statictext within tabpage_printer_connection
end type
type st_19 from statictext within tabpage_printer_connection
end type
type cb_deleteprnconnection from commandbutton within tabpage_printer_connection
end type
type cb_addprnconnection from commandbutton within tabpage_printer_connection
end type
type tabpage_printer_connection from userobject within tab_1
st_24 st_24
st_23 st_23
st_22 st_22
st_21 st_21
sle_addprnconn_printername sle_addprnconn_printername
sle_addprnconn_servername sle_addprnconn_servername
st_20 st_20
st_19 st_19
cb_deleteprnconnection cb_deleteprnconnection
cb_addprnconnection cb_addprnconnection
end type
type tabpage_adddel_printers from userobject within tab_1
end type
type st_30 from statictext within tabpage_adddel_printers
end type
type cb_delprinter from commandbutton within tabpage_adddel_printers
end type
type cb_addprinter from commandbutton within tabpage_adddel_printers
end type
type sle_addprn_servername from singlelineedit within tabpage_adddel_printers
end type
type sle_addprn_printprocessor from singlelineedit within tabpage_adddel_printers
end type
type sle_addprn_drivername from singlelineedit within tabpage_adddel_printers
end type
type sle_addprn_portname from singlelineedit within tabpage_adddel_printers
end type
type sle_addprn_printername from singlelineedit within tabpage_adddel_printers
end type
type st_29 from statictext within tabpage_adddel_printers
end type
type st_28 from statictext within tabpage_adddel_printers
end type
type st_27 from statictext within tabpage_adddel_printers
end type
type st_26 from statictext within tabpage_adddel_printers
end type
type st_25 from statictext within tabpage_adddel_printers
end type
type tabpage_adddel_printers from userobject within tab_1
st_30 st_30
cb_delprinter cb_delprinter
cb_addprinter cb_addprinter
sle_addprn_servername sle_addprn_servername
sle_addprn_printprocessor sle_addprn_printprocessor
sle_addprn_drivername sle_addprn_drivername
sle_addprn_portname sle_addprn_portname
sle_addprn_printername sle_addprn_printername
st_29 st_29
st_28 st_28
st_27 st_27
st_26 st_26
st_25 st_25
end type
type tabpage_addel_drivers from userobject within tab_1
end type
type cb_6 from commandbutton within tabpage_addel_drivers
end type
type cb_5 from commandbutton within tabpage_addel_drivers
end type
type cb_4 from commandbutton within tabpage_addel_drivers
end type
type sle_adddriver_version from singlelineedit within tabpage_addel_drivers
end type
type sle_adddriver_servername from singlelineedit within tabpage_addel_drivers
end type
type sle_adddriver_configfile from singlelineedit within tabpage_addel_drivers
end type
type sle_adddriver_datafile from singlelineedit within tabpage_addel_drivers
end type
type sle_adddriver_driverpath from singlelineedit within tabpage_addel_drivers
end type
type sle_adddriver_environment from singlelineedit within tabpage_addel_drivers
end type
type sle_adddriver_drivername from singlelineedit within tabpage_addel_drivers
end type
type st_37 from statictext within tabpage_addel_drivers
end type
type st_36 from statictext within tabpage_addel_drivers
end type
type st_35 from statictext within tabpage_addel_drivers
end type
type st_34 from statictext within tabpage_addel_drivers
end type
type st_33 from statictext within tabpage_addel_drivers
end type
type st_32 from statictext within tabpage_addel_drivers
end type
type st_31 from statictext within tabpage_addel_drivers
end type
type tabpage_addel_drivers from userobject within tab_1
cb_6 cb_6
cb_5 cb_5
cb_4 cb_4
sle_adddriver_version sle_adddriver_version
sle_adddriver_servername sle_adddriver_servername
sle_adddriver_configfile sle_adddriver_configfile
sle_adddriver_datafile sle_adddriver_datafile
sle_adddriver_driverpath sle_adddriver_driverpath
sle_adddriver_environment sle_adddriver_environment
sle_adddriver_drivername sle_adddriver_drivername
st_37 st_37
st_36 st_36
st_35 st_35
st_34 st_34
st_33 st_33
st_32 st_32
st_31 st_31
end type
type tabpage_printjobs from userobject within tab_1
end type
type lb_jobs from listbox within tabpage_printjobs
end type
type sle_enumjobs_printername from singlelineedit within tabpage_printjobs
end type
type cb_enumjobs from commandbutton within tabpage_printjobs
end type
type tabpage_printjobs from userobject within tab_1
lb_jobs lb_jobs
sle_enumjobs_printername sle_enumjobs_printername
cb_enumjobs cb_enumjobs
end type
type tabpage_enum_drivers from userobject within tab_1
end type
type lb_printerdrivers from listbox within tabpage_enum_drivers
end type
type sle_enumprinterdriver_printername from singlelineedit within tabpage_enum_drivers
end type
type cb_getprinterdriver from commandbutton within tabpage_enum_drivers
end type
type cb_enumprinterdrivers from commandbutton within tabpage_enum_drivers
end type
type tabpage_enum_drivers from userobject within tab_1
lb_printerdrivers lb_printerdrivers
sle_enumprinterdriver_printername sle_enumprinterdriver_printername
cb_getprinterdriver cb_getprinterdriver
cb_enumprinterdrivers cb_enumprinterdrivers
end type
type tabpage_desktop from userobject within tab_1
end type
type cb_print from commandbutton within tabpage_desktop
end type
type rb_stretch from radiobutton within tabpage_desktop
end type
type rb_bestfit from radiobutton within tabpage_desktop
end type
type rb_clientarea from radiobutton within tabpage_desktop
end type
type rb_entirewindow from radiobutton within tabpage_desktop
end type
type cb_capturewindow from commandbutton within tabpage_desktop
end type
type cb_capturedesktop from commandbutton within tabpage_desktop
end type
type gb_3 from groupbox within tabpage_desktop
end type
type gb_2 from groupbox within tabpage_desktop
end type
type gb_1 from groupbox within tabpage_desktop
end type
type tabpage_desktop from userobject within tab_1
cb_print cb_print
rb_stretch rb_stretch
rb_bestfit rb_bestfit
rb_clientarea rb_clientarea
rb_entirewindow rb_entirewindow
cb_capturewindow cb_capturewindow
cb_capturedesktop cb_capturedesktop
gb_3 gb_3
gb_2 gb_2
gb_1 gb_1
end type
type tabpage_enumfonts from userobject within tab_1
end type
type cb_setprinterfont from commandbutton within tabpage_enumfonts
end type
type cb_enumprinterfonts from commandbutton within tabpage_enumfonts
end type
type st_38 from statictext within tabpage_enumfonts
end type
type lb_fonts from listbox within tabpage_enumfonts
end type
type tabpage_enumfonts from userobject within tab_1
cb_setprinterfont cb_setprinterfont
cb_enumprinterfonts cb_enumprinterfonts
st_38 st_38
lb_fonts lb_fonts
end type
type tab_1 from tab within w_power_printer
tabpage_prnlist tabpage_prnlist
tabpage_orientation tabpage_orientation
tabpage_binlist tabpage_binlist
tabpage_papersize tabpage_papersize
tabpage_other tabpage_other
tabpage_error tabpage_error
tabpage_printer_connection tabpage_printer_connection
tabpage_adddel_printers tabpage_adddel_printers
tabpage_addel_drivers tabpage_addel_drivers
tabpage_printjobs tabpage_printjobs
tabpage_enum_drivers tabpage_enum_drivers
tabpage_desktop tabpage_desktop
tabpage_enumfonts tabpage_enumfonts
end type
type cb_unlock from commandbutton within w_power_printer
end type
type cb_about from commandbutton within w_power_printer
end type
type st_driver from statictext within w_power_printer
end type
type st_4 from statictext within w_power_printer
end type
type st_port from statictext within w_power_printer
end type
type st_3 from statictext within w_power_printer
end type
type st_1 from statictext within w_power_printer
end type
type cb_bye from commandbutton within w_power_printer
end type
type st_printer from statictext within w_power_printer
end type
end forward

global type w_power_printer from window
integer x = 832
integer y = 356
integer width = 2386
integer height = 1372
boolean titlebar = true
string title = "PowerPrinter by DigitalWave (http://www.digitalw.com)"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 12632256
boolean center = true
cb_help cb_help
dw_1 dw_1
tab_1 tab_1
cb_unlock cb_unlock
cb_about cb_about
st_driver st_driver
st_4 st_4
st_port st_port
st_3 st_3
st_1 st_1
cb_bye cb_bye
st_printer st_printer
end type
global w_power_printer w_power_printer

on w_power_printer.create
this.cb_help=create cb_help
this.dw_1=create dw_1
this.tab_1=create tab_1
this.cb_unlock=create cb_unlock
this.cb_about=create cb_about
this.st_driver=create st_driver
this.st_4=create st_4
this.st_port=create st_port
this.st_3=create st_3
this.st_1=create st_1
this.cb_bye=create cb_bye
this.st_printer=create st_printer
this.Control[]={this.cb_help,&
this.dw_1,&
this.tab_1,&
this.cb_unlock,&
this.cb_about,&
this.st_driver,&
this.st_4,&
this.st_port,&
this.st_3,&
this.st_1,&
this.cb_bye,&
this.st_printer}
end on

on w_power_printer.destroy
destroy(this.cb_help)
destroy(this.dw_1)
destroy(this.tab_1)
destroy(this.cb_unlock)
destroy(this.cb_about)
destroy(this.st_driver)
destroy(this.st_4)
destroy(this.st_port)
destroy(this.st_3)
destroy(this.st_1)
destroy(this.cb_bye)
destroy(this.st_printer)
end on

event open;nvo_PowerPrn = CREATE n_PowerPrinter

// default printer
st_printer.text = nvo_PowerPrn.of_GetDefaultPrinterName()
st_driver.text = nvo_PowerPrn.of_GetDefaultPrinterDriver()
st_port.text = nvo_PowerPrn.of_GetDefaultPrinterPort()

// default printer orientation
tab_1.tabpage_Orientation.st_orientation.text = nvo_PowerPrn.of_GetPrinterOrientationString()

// NB: To resolve the possible conflict of a printer name used 
// more than once (on different ports) we provide as well
// extended get set functions

string	sName, sDriver, sPort

// get
nvo_PowerPrn.of_GetDefaultPrinterEx(sName, sDriver, sPort)

// Set
//nvo_PowerPrn.of_SetDefaultPrinterEx(sName, sDriver, sPort)

tab_1.tabpage_printjobs.sle_enumjobs_printername.text = sname
tab_1.tabpage_enum_drivers.sle_enumprinterdriver_printername.text = sname

tab_1.tabpage_prnlist.cb_printerlist.postevent(clicked!)
end event

event close;DESTROY nvo_PowerPrn
end event

type cb_help from commandbutton within w_power_printer
integer x = 1957
integer y = 200
integer width = 379
integer height = 108
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Help !"
end type

event clicked;ShowHelp("powerprn.hlp", Index!)
end event

type dw_1 from datawindow within w_power_printer
boolean visible = false
integer x = 1943
integer y = 340
integer width = 384
integer height = 360
integer taborder = 20
string dataobject = "d_test"
boolean livescroll = true
end type

type tab_1 from tab within w_power_printer
integer x = 18
integer y = 204
integer width = 1902
integer height = 940
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean raggedright = true
integer selectedtab = 1
tabpage_prnlist tabpage_prnlist
tabpage_orientation tabpage_orientation
tabpage_binlist tabpage_binlist
tabpage_papersize tabpage_papersize
tabpage_other tabpage_other
tabpage_error tabpage_error
tabpage_printer_connection tabpage_printer_connection
tabpage_adddel_printers tabpage_adddel_printers
tabpage_addel_drivers tabpage_addel_drivers
tabpage_printjobs tabpage_printjobs
tabpage_enum_drivers tabpage_enum_drivers
tabpage_desktop tabpage_desktop
tabpage_enumfonts tabpage_enumfonts
end type

on tab_1.create
this.tabpage_prnlist=create tabpage_prnlist
this.tabpage_orientation=create tabpage_orientation
this.tabpage_binlist=create tabpage_binlist
this.tabpage_papersize=create tabpage_papersize
this.tabpage_other=create tabpage_other
this.tabpage_error=create tabpage_error
this.tabpage_printer_connection=create tabpage_printer_connection
this.tabpage_adddel_printers=create tabpage_adddel_printers
this.tabpage_addel_drivers=create tabpage_addel_drivers
this.tabpage_printjobs=create tabpage_printjobs
this.tabpage_enum_drivers=create tabpage_enum_drivers
this.tabpage_desktop=create tabpage_desktop
this.tabpage_enumfonts=create tabpage_enumfonts
this.Control[]={this.tabpage_prnlist,&
this.tabpage_orientation,&
this.tabpage_binlist,&
this.tabpage_papersize,&
this.tabpage_other,&
this.tabpage_error,&
this.tabpage_printer_connection,&
this.tabpage_adddel_printers,&
this.tabpage_addel_drivers,&
this.tabpage_printjobs,&
this.tabpage_enum_drivers,&
this.tabpage_desktop,&
this.tabpage_enumfonts}
end on

on tab_1.destroy
destroy(this.tabpage_prnlist)
destroy(this.tabpage_orientation)
destroy(this.tabpage_binlist)
destroy(this.tabpage_papersize)
destroy(this.tabpage_other)
destroy(this.tabpage_error)
destroy(this.tabpage_printer_connection)
destroy(this.tabpage_adddel_printers)
destroy(this.tabpage_addel_drivers)
destroy(this.tabpage_printjobs)
destroy(this.tabpage_enum_drivers)
destroy(this.tabpage_desktop)
destroy(this.tabpage_enumfonts)
end on

type tabpage_prnlist from userobject within tab_1
integer x = 18
integer y = 100
integer width = 1865
integer height = 824
long backcolor = 12632256
string text = "Printer List"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
cb_3 cb_3
st_2 st_2
lb_printerlist lb_printerlist
cb_printerlist cb_printerlist
st_5 st_5
st_6 st_6
end type

on tabpage_prnlist.create
this.cb_3=create cb_3
this.st_2=create st_2
this.lb_printerlist=create lb_printerlist
this.cb_printerlist=create cb_printerlist
this.st_5=create st_5
this.st_6=create st_6
this.Control[]={this.cb_3,&
this.st_2,&
this.lb_printerlist,&
this.cb_printerlist,&
this.st_5,&
this.st_6}
end on

on tabpage_prnlist.destroy
destroy(this.cb_3)
destroy(this.st_2)
destroy(this.lb_printerlist)
destroy(this.cb_printerlist)
destroy(this.st_5)
destroy(this.st_6)
end on

type cb_3 from commandbutton within tabpage_prnlist
boolean visible = false
integer x = 1536
integer y = 696
integer width = 329
integer height = 128
integer taborder = 31
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "test"
end type

event clicked;string sPrinterName, ls_driver, ls_port, ls_dp
long	ll_pos

sPrinterName = lb_printerlist.SelectedItem()
	 
RegistryGet('HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Devices', sPrinterName, RegString!, ls_dp)	 

ll_pos = pos(ls_dp, ',')

ls_driver	= mid(ls_dp, 1, ll_pos - 1)
ls_port	= mid(ls_dp, ll_pos + 1, 100)
//winspool,Ne00:
	// set it 
//	nvo_powerprn.of_SetDefaultPrinter(sPrinterName)
	nvo_powerprn.of_setdefaultprinterex(sPrinterName,ls_driver, ls_port)
	//dwSetDefaultPrinterEx (ulong hdl, string sPrinterName, string PrinterDriver, string printerport)
	
		 	// update display
	st_printer.text = nvo_PowerPrn.of_GetDefaultPrinterName()
	st_driver.text = nvo_PowerPrn.of_GetDefaultPrinterDriver()
	st_port.text = nvo_PowerPrn.of_GetDefaultPrinterPort()


end event

type st_2 from statictext within tabpage_prnlist
integer x = 32
integer y = 20
integer width = 402
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "Printer List:"
boolean focusrectangle = false
end type

type lb_printerlist from listbox within tabpage_prnlist
event doubleclicked pbm_lbndblclk
integer x = 32
integer y = 112
integer width = 1074
integer height = 356
integer taborder = 1
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean vscrollbar = true
boolean sorted = false
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;string sPrinterName

if this.TotalItems() > 0 then

	// get selected name
	sPrinterName = this.SelectedItem()
	 
	// set it 
	nvo_powerprn.of_SetDefaultPrinter(sPrinterName)
	//dwSetDefaultPrinterEx (ulong hdl, string sPrinterName, string PrinterDriver, string printerport)
	
	// update display
	st_printer.text = nvo_PowerPrn.of_GetDefaultPrinterName()
	st_driver.text = nvo_PowerPrn.of_GetDefaultPrinterDriver()
	st_port.text = nvo_PowerPrn.of_GetDefaultPrinterPort()

	PrintSetup()
end if
end event

type cb_printerlist from commandbutton within tabpage_prnlist
event clicked pbm_bnclicked
integer x = 1134
integer y = 112
integer width = 242
integer height = 112
integer taborder = 1
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Get It"
end type

event clicked;string lsPrnList, lsprnName
long i, iPos

lb_printerlist.reset()

lsPrnList = nvo_PowerPrn.of_GetPrinterList()

// printer names are separated by semicolon
iPos = pos(lsPrnlist , ";")
do while iPos > 0 
	lsprnName = left(lsPrnList, iPos -1)
	lb_PrinterList.AddItem(lsPrnName)
		
	lsPrnList = right(lsPrnList, len(lsPrnList) - iPos)
	iPos = pos(lsPrnlist , ";")
loop




end event

type st_5 from statictext within tabpage_prnlist
integer x = 50
integer y = 536
integer width = 1248
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "Double-click on a printer to set it as the"
boolean focusrectangle = false
end type

type st_6 from statictext within tabpage_prnlist
integer x = 50
integer y = 624
integer width = 1248
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "default one."
boolean focusrectangle = false
end type

type tabpage_orientation from userobject within tab_1
integer x = 18
integer y = 100
integer width = 1865
integer height = 824
long backcolor = 12632256
string text = "Orientation"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
st_7 st_7
st_orientation st_orientation
cb_1 cb_1
cb_2 cb_2
end type

on tabpage_orientation.create
this.st_7=create st_7
this.st_orientation=create st_orientation
this.cb_1=create cb_1
this.cb_2=create cb_2
this.Control[]={this.st_7,&
this.st_orientation,&
this.cb_1,&
this.cb_2}
end on

on tabpage_orientation.destroy
destroy(this.st_7)
destroy(this.st_orientation)
destroy(this.cb_1)
destroy(this.cb_2)
end on

type st_7 from statictext within tabpage_orientation
integer x = 41
integer y = 68
integer width = 603
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "Printer Orientation:"
boolean focusrectangle = false
end type

type st_orientation from statictext within tabpage_orientation
integer x = 663
integer y = 68
integer width = 1019
integer height = 192
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
boolean focusrectangle = false
end type

type cb_1 from commandbutton within tabpage_orientation
event clicked pbm_bnclicked
integer x = 201
integer y = 592
integer width = 567
integer height = 108
integer taborder = 11
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Set as Portrait"
end type

event clicked;long i

i = nvo_PowerPrn.of_SetPrinterOrientation(nvo_PowerPrn.DMORIENT_PORTRAIT)
if i >= 0 then
	st_orientation.text = nvo_PowerPrn.of_GetPrinterOrientationString()
else
	MessageBox("PowerPrinter", "Unable to change orientation. Error code = " + string(i))
end if
end event

type cb_2 from commandbutton within tabpage_orientation
event clicked pbm_bnclicked
integer x = 923
integer y = 592
integer width = 567
integer height = 108
integer taborder = 2
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Set as Landscape"
end type

event clicked;long i

i = nvo_PowerPrn.of_SetPrinterOrientation(nvo_PowerPrn.DMORIENT_LANDSCAPE)

if i >= 0 then
	st_orientation.text = nvo_PowerPrn.of_GetPrinterOrientationString()
else
	MessageBox("PowerPrinter", "Unable to change orientation. Error code = " + string(i))
end if
end event

type tabpage_binlist from userobject within tab_1
integer x = 18
integer y = 100
integer width = 1865
integer height = 824
long backcolor = 12632256
string text = "PaperBin"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
cb_getbinlist cb_getbinlist
lb_bins lb_bins
rb_default rb_default
rb_named rb_named
cb_getbin cb_getbin
cb_setbin cb_setbin
end type

on tabpage_binlist.create
this.cb_getbinlist=create cb_getbinlist
this.lb_bins=create lb_bins
this.rb_default=create rb_default
this.rb_named=create rb_named
this.cb_getbin=create cb_getbin
this.cb_setbin=create cb_setbin
this.Control[]={this.cb_getbinlist,&
this.lb_bins,&
this.rb_default,&
this.rb_named,&
this.cb_getbin,&
this.cb_setbin}
end on

on tabpage_binlist.destroy
destroy(this.cb_getbinlist)
destroy(this.lb_bins)
destroy(this.rb_default)
destroy(this.rb_named)
destroy(this.cb_getbin)
destroy(this.cb_setbin)
end on

type cb_getbinlist from commandbutton within tabpage_binlist
event clicked pbm_bnclicked
integer x = 1458
integer y = 156
integer width = 274
integer height = 108
integer taborder = 3
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Get List"
end type

event clicked;string lsBinList, lsBinName
integer iPos, iStart, iLen


lb_bins.reset()

if rb_default.Checked = TRUE then
	lsBinList = nvo_PowerPrn.of_GetPaperBinList()
else
	lsBinList = nvo_PowerPrn.of_GetNamedPaperBinList()
end if

iLen = len(lsBinList)
iStart = 1
iPos = pos(lsBinList, ";")

do while (iPos > 0 )
	
	lsBinName = mid(lsBinList, iStart, (iPos - iStart))
	lb_bins.AddItem(lsBinName)
	iStart = iPos + 1
	iPos = pos(lsBinList, ";", iStart)
loop

end event

type lb_bins from listbox within tabpage_binlist
integer x = 73
integer y = 156
integer width = 1307
integer height = 588
integer taborder = 2
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean vscrollbar = true
boolean sorted = false
borderstyle borderstyle = stylelowered!
end type

type rb_default from radiobutton within tabpage_binlist
event clicked pbm_bnclicked
integer x = 59
integer y = 40
integer width = 288
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Default"
boolean checked = true
boolean lefttext = true
end type

event clicked;cb_setbin.enabled = TRUE

cb_getbinlist.PostEvent(Clicked!)
end event

type rb_named from radiobutton within tabpage_binlist
event clicked pbm_bnclicked
integer x = 430
integer y = 40
integer width = 288
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Named"
boolean lefttext = true
end type

event clicked;cb_setbin.enabled = FALSE

cb_getbinlist.PostEvent(Clicked!)
end event

type cb_getbin from commandbutton within tabpage_binlist
event clicked pbm_bnclicked
integer x = 1458
integer y = 496
integer width = 274
integer height = 108
integer taborder = 11
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Get Bin"
end type

event clicked;integer iSource

nvo_PowerPrn.of_GetPaperSource(iSource)

MessageBox("Source", string(iSource))
end event

type cb_setbin from commandbutton within tabpage_binlist
event clicked pbm_bnclicked
integer x = 1458
integer y = 632
integer width = 274
integer height = 108
integer taborder = 11
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Set Bin"
end type

event clicked;integer iSource
string sBIn

if lb_bins.TotalItems() > 0 then

	// get selected bin
	sBin = lb_bins.SelectedItem()

	if sBin = "" then
		MessageBox("Error", "No Paper Bin to choose from !. Please select one.")
	else
		iSource = integer(left(sBin, pos(sBin, " ")))
		if nvo_PowerPrn.of_SetPaperSource(iSource) > 0 then
			MessageBox("PowerPrinter", "Set paperBin succeeded !")
		end if
	end if
else
	MessageBox("Error", "No Paper Bins to choose from !")
end if


end event

type tabpage_papersize from userobject within tab_1
integer x = 18
integer y = 100
integer width = 1865
integer height = 824
long backcolor = 12632256
string text = "PaperSize"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
lb_papersizes lb_papersizes
cb_getpapersizelist cb_getpapersizelist
cb_getpapersize cb_getpapersize
cb_setpapersize cb_setpapersize
st_10 st_10
end type

on tabpage_papersize.create
this.lb_papersizes=create lb_papersizes
this.cb_getpapersizelist=create cb_getpapersizelist
this.cb_getpapersize=create cb_getpapersize
this.cb_setpapersize=create cb_setpapersize
this.st_10=create st_10
this.Control[]={this.lb_papersizes,&
this.cb_getpapersizelist,&
this.cb_getpapersize,&
this.cb_setpapersize,&
this.st_10}
end on

on tabpage_papersize.destroy
destroy(this.lb_papersizes)
destroy(this.cb_getpapersizelist)
destroy(this.cb_getpapersize)
destroy(this.cb_setpapersize)
destroy(this.st_10)
end on

type lb_papersizes from listbox within tabpage_papersize
integer x = 27
integer y = 236
integer width = 1179
integer height = 460
integer taborder = 11
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean vscrollbar = true
boolean sorted = false
borderstyle borderstyle = stylelowered!
end type

type cb_getpapersizelist from commandbutton within tabpage_papersize
event clicked pbm_bnclicked
integer x = 1271
integer y = 244
integer width = 489
integer height = 108
integer taborder = 11
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Get List"
end type

event clicked;string lsPaperList, lsPaperName
integer iPos, iStart, iLen


lb_papersizes.reset()

lsPaperList = nvo_PowerPrn.of_GetSupportedPaperSizeList()

iLen = len(lsPaperList)
iStart = 1
iPos = pos(lspaperList, ";")

do while (iPos > 0 )
	
	lspaperName = mid(lsPaperList, iStart, (iPos - iStart))
	lb_papersizes.AddItem(lsPaperName)
	iStart = iPos + 1
	iPos = pos(lsPaperList, ";", iStart)
loop

end event

type cb_getpapersize from commandbutton within tabpage_papersize
event clicked pbm_bnclicked
integer x = 1266
integer y = 456
integer width = 494
integer height = 108
integer taborder = 11
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Get Paper Size"
end type

event clicked;integer iSize

if nvo_PowerPrn.of_GetpaperSize(iSize) > 0 then
	MessageBox("PowerPrinter", "Page Size : " + string(iSize))
else
	MessageBox("PowerPrinter", "Could not fetch Paper Size")
end if
end event

type cb_setpapersize from commandbutton within tabpage_papersize
event clicked pbm_bnclicked
integer x = 1271
integer y = 584
integer width = 489
integer height = 108
integer taborder = 12
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Set Paper Size"
end type

event clicked;integer iSize
string sPaperSize

if lb_papersizes.TotalItems() > 0 then

	// get selected paper size
	sPaperSize = lb_papersizes.SelectedItem()

	if sPaperSize = "" then
		MessageBox("Error", "No Paper Size to choose from !. Please select one.")
	else	
		iSize = integer(left(spaperSize, pos(sPaperSize, " ")))
		if nvo_PowerPrn.of_SetPaperSize(iSize) > 0 then
			MessageBox("PowerPrinter", "Set Paper Size succeeded !")
		else
			MessageBox("PowerPrinter", "Set Paper Size failed !")
		end if
	end if
else
	MessageBox("Error", "No Paper Size to choose from !")
end if
end event

type st_10 from statictext within tabpage_papersize
integer x = 37
integer y = 148
integer width = 704
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "Supported Paper Sizes"
boolean focusrectangle = false
end type

type tabpage_other from userobject within tab_1
integer x = 18
integer y = 100
integer width = 1865
integer height = 824
long backcolor = 12632256
string text = "Other"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
cb_testscale cb_testscale
st_39 st_39
st_14 st_14
st_13 st_13
st_12 st_12
st_9 st_9
dw_2 dw_2
cb_test cb_test
st_8 st_8
st_11 st_11
end type

on tabpage_other.create
this.cb_testscale=create cb_testscale
this.st_39=create st_39
this.st_14=create st_14
this.st_13=create st_13
this.st_12=create st_12
this.st_9=create st_9
this.dw_2=create dw_2
this.cb_test=create cb_test
this.st_8=create st_8
this.st_11=create st_11
this.Control[]={this.cb_testscale,&
this.st_39,&
this.st_14,&
this.st_13,&
this.st_12,&
this.st_9,&
this.dw_2,&
this.cb_test,&
this.st_8,&
this.st_11}
end on

on tabpage_other.destroy
destroy(this.cb_testscale)
destroy(this.st_39)
destroy(this.st_14)
destroy(this.st_13)
destroy(this.st_12)
destroy(this.st_9)
destroy(this.dw_2)
destroy(this.cb_test)
destroy(this.st_8)
destroy(this.st_11)
end on

type cb_testscale from commandbutton within tabpage_other
integer x = 1390
integer y = 480
integer width = 247
integer height = 72
integer taborder = 5
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "test"
end type

event clicked;long ll_Ret

ll_Ret = nvo_powerprn.of_SetScale(50)
if ll_Ret > 0 then
	dw_1.Print()
elseif ll_ret = -105 then
	MessageBox("PowerPrinter", "You printer driver reports that the printer does not support the change.")
else
	MessageBox("PowerPrinter", "SetScale failed")
end if

end event

type st_39 from statictext within tabpage_other
integer x = 9
integer y = 484
integer width = 891
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "Get / Set Scale"
boolean focusrectangle = false
end type

type st_14 from statictext within tabpage_other
integer x = 9
integer y = 704
integer width = 1239
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "Check out the help file for more information."
boolean focusrectangle = false
end type

type st_13 from statictext within tabpage_other
integer x = 9
integer y = 392
integer width = 1211
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "Get / Set printer collate options"
boolean focusrectangle = false
end type

type st_12 from statictext within tabpage_other
integer x = 9
integer y = 300
integer width = 891
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "Get / Set printer color settings"
boolean focusrectangle = false
end type

type st_9 from statictext within tabpage_other
integer x = 9
integer y = 208
integer width = 891
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "Get / Set number of copies"
boolean focusrectangle = false
end type

type dw_2 from datawindow within tabpage_other
boolean visible = false
integer x = 1289
integer y = 432
integer width = 494
integer height = 360
integer taborder = 3
string dataobject = "d_test"
boolean livescroll = true
end type

type cb_test from commandbutton within tabpage_other
integer x = 1390
integer y = 112
integer width = 247
integer height = 72
integer taborder = 2
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "test"
end type

event clicked;string	sName, sDriver, sPort, sMsg, sFile
long 		lRet

// get default printer settings
nvo_PowerPrn.of_GetDefaultPrinterEx(sName, sDriver, sPort)

// print to file
sFile = "FILE:"
lRet = nvo_PowerPrn.of_SetDefaultPrinterPort(sFile)

if lRet > 0 then

	// print anything
	dw_1.Print()

	// restore default
	lRet = nvo_PowerPrn.of_SetDefaultPrinterPort(sPort)
	if lRet < 1 then
		sMsg = "WARNING: SetDefaultPrinterPort to FILE: succeded but could not restore previous one. Error Code is " + String(lRet)
	end if
else
	smsg = "Set Printer failed !. Error Code: " + String(lRet)
end if

if sMsg <> "" then
	MessageBox("PowerPrinter",sMsg)
end if
end event

type st_8 from statictext within tabpage_other
integer x = 9
integer y = 116
integer width = 1248
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "Print to file by using SetDefaultPrinterPort"
boolean focusrectangle = false
end type

type st_11 from statictext within tabpage_other
integer x = 9
integer y = 24
integer width = 1765
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "Paper Quality: Get / Set HIGH, MEDIUM, LOW, DRAFT, CUSTOM"
boolean focusrectangle = false
end type

type tabpage_error from userobject within tab_1
integer x = 18
integer y = 100
integer width = 1865
integer height = 824
long backcolor = 12632256
string text = "Extended Errors"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
st_18 st_18
st_17 st_17
st_16 st_16
st_15 st_15
cb_getexmsg cb_getexmsg
cb_getexcode cb_getexcode
end type

on tabpage_error.create
this.st_18=create st_18
this.st_17=create st_17
this.st_16=create st_16
this.st_15=create st_15
this.cb_getexmsg=create cb_getexmsg
this.cb_getexcode=create cb_getexcode
this.Control[]={this.st_18,&
this.st_17,&
this.st_16,&
this.st_15,&
this.cb_getexmsg,&
this.cb_getexcode}
end on

on tabpage_error.destroy
destroy(this.st_18)
destroy(this.st_17)
destroy(this.st_16)
destroy(this.st_15)
destroy(this.cb_getexmsg)
destroy(this.cb_getexcode)
end on

type st_18 from statictext within tabpage_error
integer x = 23
integer y = 304
integer width = 1746
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "information."
boolean focusrectangle = false
end type

type st_17 from statictext within tabpage_error
integer x = 23
integer y = 212
integer width = 1746
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "should be called just after an API call failed and you need more"
boolean focusrectangle = false
end type

type st_16 from statictext within tabpage_error
integer x = 23
integer y = 120
integer width = 1746
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "and messages as set bythe standard Windows APIs. These APIs"
boolean focusrectangle = false
end type

type st_15 from statictext within tabpage_error
integer x = 23
integer y = 28
integer width = 1742
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "PowerPrinter v1.1 gives you access to the extended error codes"
boolean focusrectangle = false
end type

type cb_getexmsg from commandbutton within tabpage_error
integer x = 850
integer y = 540
integer width = 827
integer height = 108
integer taborder = 13
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Get Extended Error Message"
end type

event clicked;string ls_msg

ls_Msg = nvo_powerprn.of_GetExtendedErrorMessage()

MessageBox("PowerPrinter", ls_Msg)
end event

type cb_getexcode from commandbutton within tabpage_error
integer x = 87
integer y = 540
integer width = 722
integer height = 108
integer taborder = 12
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Get Extended Error Code"
end type

event clicked;long ll_code

ll_Code = nvo_powerprn.of_GetExtendedErrorCode()

MessageBox("PowerPrinter", "Extended error code is " + string(ll_Code))
end event

type tabpage_printer_connection from userobject within tab_1
integer x = 18
integer y = 100
integer width = 1865
integer height = 824
long backcolor = 12632256
string text = "Printer Connection"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
st_24 st_24
st_23 st_23
st_22 st_22
st_21 st_21
sle_addprnconn_printername sle_addprnconn_printername
sle_addprnconn_servername sle_addprnconn_servername
st_20 st_20
st_19 st_19
cb_deleteprnconnection cb_deleteprnconnection
cb_addprnconnection cb_addprnconnection
end type

on tabpage_printer_connection.create
this.st_24=create st_24
this.st_23=create st_23
this.st_22=create st_22
this.st_21=create st_21
this.sle_addprnconn_printername=create sle_addprnconn_printername
this.sle_addprnconn_servername=create sle_addprnconn_servername
this.st_20=create st_20
this.st_19=create st_19
this.cb_deleteprnconnection=create cb_deleteprnconnection
this.cb_addprnconnection=create cb_addprnconnection
this.Control[]={this.st_24,&
this.st_23,&
this.st_22,&
this.st_21,&
this.sle_addprnconn_printername,&
this.sle_addprnconn_servername,&
this.st_20,&
this.st_19,&
this.cb_deleteprnconnection,&
this.cb_addprnconnection}
end on

on tabpage_printer_connection.destroy
destroy(this.st_24)
destroy(this.st_23)
destroy(this.st_22)
destroy(this.st_21)
destroy(this.sle_addprnconn_printername)
destroy(this.sle_addprnconn_servername)
destroy(this.st_20)
destroy(this.st_19)
destroy(this.cb_deleteprnconnection)
destroy(this.cb_addprnconnection)
end on

type st_24 from statictext within tabpage_printer_connection
integer x = 18
integer y = 292
integer width = 1751
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "name and the printer SHARE name and click on ~'Connect~'"
boolean focusrectangle = false
end type

type st_23 from statictext within tabpage_printer_connection
integer x = 18
integer y = 200
integer width = 1751
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "if you do not have the printer drivers installed. Type the server"
boolean focusrectangle = false
end type

type st_22 from statictext within tabpage_printer_connection
integer x = 18
integer y = 108
integer width = 1751
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "Under Window NT you can easily connet to a network printer even"
boolean focusrectangle = false
end type

type st_21 from statictext within tabpage_printer_connection
integer x = 14
integer y = 20
integer width = 283
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "NT ONLY:"
boolean focusrectangle = false
end type

type sle_addprnconn_printername from singlelineedit within tabpage_printer_connection
integer x = 503
integer y = 680
integer width = 805
integer height = 92
integer taborder = 12
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type sle_addprnconn_servername from singlelineedit within tabpage_printer_connection
integer x = 503
integer y = 520
integer width = 805
integer height = 92
integer taborder = 12
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_20 from statictext within tabpage_printer_connection
integer x = 69
integer y = 692
integer width = 379
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "Printer Name:"
boolean focusrectangle = false
end type

type st_19 from statictext within tabpage_printer_connection
integer x = 55
integer y = 532
integer width = 370
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "Server Name:"
boolean focusrectangle = false
end type

type cb_deleteprnconnection from commandbutton within tabpage_printer_connection
integer x = 1481
integer y = 668
integer width = 261
integer height = 108
integer taborder = 12
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Delete"
end type

event clicked;long ll_Ret

ll_Ret = nvo_powerprn.of_DelPrinterConnection (sle_addprnconn_servername.text, sle_addprnconn_printername.text)

if ll_Ret > 0 then
	MessageBox("PowerPrinter", "Printer connection successfully added.")
elseif ll_ret =  nvo_powerprn.ERR_NOT_IMPLEMENTED then
	MessageBox("PowerPrinter","Printer connection failed. This API not supported under Windows 95. Please use dwAddPrinter.")	
else
	MessageBox("PowerPrinter","Printer connection failed. Please check Errors page for more details.")
end if	
end event

type cb_addprnconnection from commandbutton within tabpage_printer_connection
integer x = 1472
integer y = 516
integer width = 274
integer height = 108
integer taborder = 12
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Connect"
end type

event clicked;long ll_Ret

ll_Ret = nvo_powerprn.of_AddprinterConnection (sle_addprnconn_servername.text, sle_addprnconn_printername.text)

if ll_Ret > 0 then
	MessageBox("PowerPrinter", "Printer connection successfully added.")
elseif ll_ret =  nvo_powerprn.ERR_NOT_IMPLEMENTED then
	MessageBox("PowerPrinter","Printer connection failed. This API not supported under Windows 95. Please use dwAddPrinter.")	
else
	MessageBox("PowerPrinter","Printer connection failed. Please check Errors page for more details.")
end if	
end event

type tabpage_adddel_printers from userobject within tab_1
integer x = 18
integer y = 100
integer width = 1865
integer height = 824
long backcolor = 12632256
string text = "Add/Del Printers"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
st_30 st_30
cb_delprinter cb_delprinter
cb_addprinter cb_addprinter
sle_addprn_servername sle_addprn_servername
sle_addprn_printprocessor sle_addprn_printprocessor
sle_addprn_drivername sle_addprn_drivername
sle_addprn_portname sle_addprn_portname
sle_addprn_printername sle_addprn_printername
st_29 st_29
st_28 st_28
st_27 st_27
st_26 st_26
st_25 st_25
end type

on tabpage_adddel_printers.create
this.st_30=create st_30
this.cb_delprinter=create cb_delprinter
this.cb_addprinter=create cb_addprinter
this.sle_addprn_servername=create sle_addprn_servername
this.sle_addprn_printprocessor=create sle_addprn_printprocessor
this.sle_addprn_drivername=create sle_addprn_drivername
this.sle_addprn_portname=create sle_addprn_portname
this.sle_addprn_printername=create sle_addprn_printername
this.st_29=create st_29
this.st_28=create st_28
this.st_27=create st_27
this.st_26=create st_26
this.st_25=create st_25
this.Control[]={this.st_30,&
this.cb_delprinter,&
this.cb_addprinter,&
this.sle_addprn_servername,&
this.sle_addprn_printprocessor,&
this.sle_addprn_drivername,&
this.sle_addprn_portname,&
this.sle_addprn_printername,&
this.st_29,&
this.st_28,&
this.st_27,&
this.st_26,&
this.st_25}
end on

on tabpage_adddel_printers.destroy
destroy(this.st_30)
destroy(this.cb_delprinter)
destroy(this.cb_addprinter)
destroy(this.sle_addprn_servername)
destroy(this.sle_addprn_printprocessor)
destroy(this.sle_addprn_drivername)
destroy(this.sle_addprn_portname)
destroy(this.sle_addprn_printername)
destroy(this.st_29)
destroy(this.st_28)
destroy(this.st_27)
destroy(this.st_26)
destroy(this.st_25)
end on

type st_30 from statictext within tabpage_adddel_printers
integer x = 1143
integer y = 504
integer width = 530
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "NT Only !. See help"
boolean focusrectangle = false
end type

type cb_delprinter from commandbutton within tabpage_adddel_printers
integer x = 1422
integer y = 184
integer width = 334
integer height = 108
integer taborder = 4
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Del Printer"
end type

event clicked;long ll_Ret

ll_ret = nvo_powerprn.of_DelPrinter(sle_addprn_printername.text)

if ll_ret > 0 then
	MessageBox("PowerPrinter", "Printer successfully deleted.")
else
	MessageBox("PowerPrinter", "Oh Oh, could not delete the printer. Please check the Errors page for more details.")
end if
end event

type cb_addprinter from commandbutton within tabpage_adddel_printers
integer x = 1417
integer y = 44
integer width = 343
integer height = 108
integer taborder = 2
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Add printer"
end type

event clicked;long ll_Ret

ll_ret = nvo_powerprn.of_AddPrinter(sle_addprn_servername.text, sle_addprn_printername.text, sle_addprn_portname.text, sle_addprn_drivername.text, sle_addprn_printprocessor.text)

if ll_ret > 0 then
	MessageBox("PowerPrinter", "Printer successfully added.")
else
	MessageBox("PowerPrinter", "Oh Oh, could not add the printer. Please check the Errors page for more details.")
end if
end event

type sle_addprn_servername from singlelineedit within tabpage_adddel_printers
integer x = 489
integer y = 496
integer width = 617
integer height = 92
integer taborder = 14
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "\\SERVERNAME"
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type sle_addprn_printprocessor from singlelineedit within tabpage_adddel_printers
integer x = 489
integer y = 380
integer width = 823
integer height = 92
integer taborder = 21
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "WinPrint"
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type sle_addprn_drivername from singlelineedit within tabpage_adddel_printers
integer x = 489
integer y = 264
integer width = 823
integer height = 92
integer taborder = 12
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "HP LaserJet 5P"
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type sle_addprn_portname from singlelineedit within tabpage_adddel_printers
integer x = 489
integer y = 148
integer width = 823
integer height = 92
integer taborder = 2
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "LPT1:"
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type sle_addprn_printername from singlelineedit within tabpage_adddel_printers
integer x = 489
integer y = 32
integer width = 823
integer height = 92
integer taborder = 1
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "PRNTEST"
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_29 from statictext within tabpage_adddel_printers
integer x = 23
integer y = 504
integer width = 379
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "Server Name:"
boolean focusrectangle = false
end type

type st_28 from statictext within tabpage_adddel_printers
integer x = 23
integer y = 388
integer width = 443
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "Print Processor:"
boolean focusrectangle = false
end type

type st_27 from statictext within tabpage_adddel_printers
integer x = 23
integer y = 264
integer width = 379
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "Driver Name:"
boolean focusrectangle = false
end type

type st_26 from statictext within tabpage_adddel_printers
integer x = 23
integer y = 148
integer width = 379
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "Port Name:"
boolean focusrectangle = false
end type

type st_25 from statictext within tabpage_adddel_printers
integer x = 23
integer y = 44
integer width = 379
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "Printer Name:"
boolean focusrectangle = false
end type

type tabpage_addel_drivers from userobject within tab_1
integer x = 18
integer y = 100
integer width = 1865
integer height = 824
long backcolor = 12632256
string text = "Add/Del Drivers"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
cb_6 cb_6
cb_5 cb_5
cb_4 cb_4
sle_adddriver_version sle_adddriver_version
sle_adddriver_servername sle_adddriver_servername
sle_adddriver_configfile sle_adddriver_configfile
sle_adddriver_datafile sle_adddriver_datafile
sle_adddriver_driverpath sle_adddriver_driverpath
sle_adddriver_environment sle_adddriver_environment
sle_adddriver_drivername sle_adddriver_drivername
st_37 st_37
st_36 st_36
st_35 st_35
st_34 st_34
st_33 st_33
st_32 st_32
st_31 st_31
end type

on tabpage_addel_drivers.create
this.cb_6=create cb_6
this.cb_5=create cb_5
this.cb_4=create cb_4
this.sle_adddriver_version=create sle_adddriver_version
this.sle_adddriver_servername=create sle_adddriver_servername
this.sle_adddriver_configfile=create sle_adddriver_configfile
this.sle_adddriver_datafile=create sle_adddriver_datafile
this.sle_adddriver_driverpath=create sle_adddriver_driverpath
this.sle_adddriver_environment=create sle_adddriver_environment
this.sle_adddriver_drivername=create sle_adddriver_drivername
this.st_37=create st_37
this.st_36=create st_36
this.st_35=create st_35
this.st_34=create st_34
this.st_33=create st_33
this.st_32=create st_32
this.st_31=create st_31
this.Control[]={this.cb_6,&
this.cb_5,&
this.cb_4,&
this.sle_adddriver_version,&
this.sle_adddriver_servername,&
this.sle_adddriver_configfile,&
this.sle_adddriver_datafile,&
this.sle_adddriver_driverpath,&
this.sle_adddriver_environment,&
this.sle_adddriver_drivername,&
this.st_37,&
this.st_36,&
this.st_35,&
this.st_34,&
this.st_33,&
this.st_32,&
this.st_31}
end on

on tabpage_addel_drivers.destroy
destroy(this.cb_6)
destroy(this.cb_5)
destroy(this.cb_4)
destroy(this.sle_adddriver_version)
destroy(this.sle_adddriver_servername)
destroy(this.sle_adddriver_configfile)
destroy(this.sle_adddriver_datafile)
destroy(this.sle_adddriver_driverpath)
destroy(this.sle_adddriver_environment)
destroy(this.sle_adddriver_drivername)
destroy(this.st_37)
destroy(this.st_36)
destroy(this.st_35)
destroy(this.st_34)
destroy(this.st_33)
destroy(this.st_32)
destroy(this.st_31)
end on

type cb_6 from commandbutton within tabpage_addel_drivers
integer x = 951
integer y = 680
integer width = 247
integer height = 108
integer taborder = 13
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Get"
end type

event clicked;driver_info_2 di2	// printer driver information
long ll_ret

ll_Ret = nvo_powerprn.of_GetPrinterDriver(st_printer.text, di2)

if ll_ret > 0 then
	sle_adddriver_drivername.text = di2.pName
	sle_adddriver_environment.text = di2.pEnvironment
	sle_adddriver_datafile.text = di2.pDatafile
	sle_adddriver_driverpath.text = di2.pDriverPath
	sle_adddriver_configfile.text = di2.pConfigFile
	sle_adddriver_version.text = string(di2.dVersion)
	
else
	MessageBox("PowerPrinter", "GetPrinterDriver failed. Please check the errors page.")
end if
end event

type cb_5 from commandbutton within tabpage_addel_drivers
integer x = 1234
integer y = 680
integer width = 247
integer height = 108
integer taborder = 3
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Del"
end type

event clicked;long ll_ret

ll_Ret = nvo_powerprn.of_DelPrinterDriver(sle_adddriver_servername.text, sle_adddriver_environment.text, &
														sle_adddriver_drivername.text)
if ll_ret > 0 then														
	MessageBox("PowerPrinter", "DelPrinterDriver succeeded !")	
else
	MessageBox("PowerPrinter", "DelPrinterDriver failed. Please check the errors page.")
end if
end event

type cb_4 from commandbutton within tabpage_addel_drivers
integer x = 1504
integer y = 680
integer width = 247
integer height = 108
integer taborder = 3
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Add"
end type

event clicked;long ll_ret

ll_Ret = nvo_powerprn.of_AddPrinterDriver(sle_adddriver_servername.text, sle_adddriver_drivername.text, &
														sle_adddriver_environment.text, sle_adddriver_datafile.text, &
														sle_adddriver_driverpath.text, sle_adddriver_configfile.text, &
														long(sle_adddriver_version.text))
if ll_ret > 0 then														
	MessageBox("PowerPrinter", "AddPrinterDriver succeeded !")	
else
	MessageBox("PowerPrinter", "AddPrinterDriver failed. Please check the errors page.")
end if
end event

type sle_adddriver_version from singlelineedit within tabpage_addel_drivers
integer x = 512
integer y = 668
integer width = 261
integer height = 92
integer taborder = 13
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type sle_adddriver_servername from singlelineedit within tabpage_addel_drivers
integer x = 512
integer y = 560
integer width = 1234
integer height = 92
integer taborder = 14
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type sle_adddriver_configfile from singlelineedit within tabpage_addel_drivers
integer x = 512
integer y = 452
integer width = 1234
integer height = 92
integer taborder = 4
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type sle_adddriver_datafile from singlelineedit within tabpage_addel_drivers
integer x = 512
integer y = 344
integer width = 1234
integer height = 92
integer taborder = 21
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type sle_adddriver_driverpath from singlelineedit within tabpage_addel_drivers
integer x = 512
integer y = 240
integer width = 1234
integer height = 92
integer taborder = 12
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type sle_adddriver_environment from singlelineedit within tabpage_addel_drivers
integer x = 512
integer y = 128
integer width = 1234
integer height = 92
integer taborder = 2
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type sle_adddriver_drivername from singlelineedit within tabpage_addel_drivers
integer x = 512
integer y = 20
integer width = 1234
integer height = 92
integer taborder = 3
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_37 from statictext within tabpage_addel_drivers
integer x = 37
integer y = 676
integer width = 379
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "Version:"
boolean focusrectangle = false
end type

type st_36 from statictext within tabpage_addel_drivers
integer x = 37
integer y = 568
integer width = 379
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "Server:"
boolean focusrectangle = false
end type

type st_35 from statictext within tabpage_addel_drivers
integer x = 37
integer y = 464
integer width = 379
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "Config File:"
boolean focusrectangle = false
end type

type st_34 from statictext within tabpage_addel_drivers
integer x = 37
integer y = 364
integer width = 379
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "Data File:"
boolean focusrectangle = false
end type

type st_33 from statictext within tabpage_addel_drivers
integer x = 37
integer y = 256
integer width = 379
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "Driver Path:"
boolean focusrectangle = false
end type

type st_32 from statictext within tabpage_addel_drivers
integer x = 37
integer y = 144
integer width = 379
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "Environment:"
boolean focusrectangle = false
end type

type st_31 from statictext within tabpage_addel_drivers
integer x = 37
integer y = 36
integer width = 379
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "Driver Name:"
boolean focusrectangle = false
end type

type tabpage_printjobs from userobject within tab_1
integer x = 18
integer y = 100
integer width = 1865
integer height = 824
long backcolor = 12632256
string text = "Print Jobs"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
lb_jobs lb_jobs
sle_enumjobs_printername sle_enumjobs_printername
cb_enumjobs cb_enumjobs
end type

on tabpage_printjobs.create
this.lb_jobs=create lb_jobs
this.sle_enumjobs_printername=create sle_enumjobs_printername
this.cb_enumjobs=create cb_enumjobs
this.Control[]={this.lb_jobs,&
this.sle_enumjobs_printername,&
this.cb_enumjobs}
end on

on tabpage_printjobs.destroy
destroy(this.lb_jobs)
destroy(this.sle_enumjobs_printername)
destroy(this.cb_enumjobs)
end on

type lb_jobs from listbox within tabpage_printjobs
integer x = 46
integer y = 208
integer width = 1710
integer height = 572
integer taborder = 21
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean vscrollbar = true
boolean sorted = false
borderstyle borderstyle = stylelowered!
end type

type sle_enumjobs_printername from singlelineedit within tabpage_printjobs
integer x = 535
integer y = 68
integer width = 1211
integer height = 100
integer taborder = 4
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type cb_enumjobs from commandbutton within tabpage_printjobs
integer x = 46
integer y = 64
integer width = 453
integer height = 108
integer taborder = 3
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Enum Jobs for:"
end type

event clicked;string sMsg, sItem
job_info_1 JobInfo [] 
long ll_Ret, lJobs, i

ll_Ret = nvo_powerprn.of_EnumPrinterJobs(sle_enumjobs_printername.text, 10, JobInfo[], lJobs)

if ll_Ret >= 0 then
	lb_Jobs.Reset()

   if lJobs = 0 then // printer queue is empty
   	MessageBox('PowerPrinter','No print Jobs found in the printer queue of ' + sle_EnumJobs_PrinterName.text)
	end if
          
	for i = 1 to lJobs 
              sItem = 'Printer Name: '
               sItem = sItem + JobInfo[i].pPrinterName
               lb_Jobs.AddItem(sItem)

               sItem = ' Machine Name: '
               sItem = sItem + JobInfo[i].pMachineName
               lb_Jobs.AddItem(sItem)

               sItem = ' User Name: '
               sItem = sItem + JobInfo[i].pUserName
               lb_Jobs.AddItem(sItem)

               sItem = ' Document: '
               sItem = sItem + JobInfo[i].pDocument
               lb_Jobs.AddItem(sItem)

               sItem = ' Data Type: '
               sItem = sItem + JobInfo[i].pDatatype
               lb_Jobs.AddItem(sItem)

               sItem = ' Status: '
               sItem = sItem + JobInfo[i].pStatus
               lb_Jobs.AddItem(sItem)

               sItem = ' Status: '
               sItem = sItem + string(JobInfo[i].Status)
               lb_Jobs.AddItem(sItem)

               sItem = ' Priority: '
               sItem = sItem + String(JobInfo[i].Priority)
               lb_Jobs.AddItem(sItem)

               sItem = ' Position: '
               sItem = sItem + String(JobInfo[i].Position)
               lb_Jobs.AddItem(sItem)

               sItem = ' Total Pages: '
               sItem = sItem + String(JobInfo[i].TotalPages)
               lb_Jobs.AddItem(sItem)

               sItem = ' Pages Printed: '
               sItem = sItem + String(JobInfo[i].PagesPrinted)
               lb_Jobs.AddItem(sItem)
				next
else 						// what's wrong ?
	MessageBox('PowerPrinter', 'EnumPrinterJobs failed. ErrorCode : ' + String(ll_Ret)+ ' Go to the Errors TAB Page and check the extended error code and message.')
end if	

end event

type tabpage_enum_drivers from userobject within tab_1
integer x = 18
integer y = 100
integer width = 1865
integer height = 824
long backcolor = 12632256
string text = "Enum Drivers"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
lb_printerdrivers lb_printerdrivers
sle_enumprinterdriver_printername sle_enumprinterdriver_printername
cb_getprinterdriver cb_getprinterdriver
cb_enumprinterdrivers cb_enumprinterdrivers
end type

on tabpage_enum_drivers.create
this.lb_printerdrivers=create lb_printerdrivers
this.sle_enumprinterdriver_printername=create sle_enumprinterdriver_printername
this.cb_getprinterdriver=create cb_getprinterdriver
this.cb_enumprinterdrivers=create cb_enumprinterdrivers
this.Control[]={this.lb_printerdrivers,&
this.sle_enumprinterdriver_printername,&
this.cb_getprinterdriver,&
this.cb_enumprinterdrivers}
end on

on tabpage_enum_drivers.destroy
destroy(this.lb_printerdrivers)
destroy(this.sle_enumprinterdriver_printername)
destroy(this.cb_getprinterdriver)
destroy(this.cb_enumprinterdrivers)
end on

type lb_printerdrivers from listbox within tabpage_enum_drivers
integer x = 27
integer y = 284
integer width = 1714
integer height = 484
integer taborder = 22
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean vscrollbar = true
boolean sorted = false
borderstyle borderstyle = stylelowered!
end type

type sle_enumprinterdriver_printername from singlelineedit within tabpage_enum_drivers
integer x = 681
integer y = 32
integer width = 1070
integer height = 100
integer taborder = 5
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type cb_getprinterdriver from commandbutton within tabpage_enum_drivers
integer x = 32
integer y = 28
integer width = 608
integer height = 108
integer taborder = 4
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Get Printer Driver for:"
end type

event clicked;driver_info_2 DriverInfo	// printer driver information
long ll_ret
string sItem

ll_Ret = nvo_powerprn.of_GetPrinterDriver(sle_enumprinterdriver_printername.text, DriverInfo)

if ll_ret > 0 then
	
	lb_printerdrivers.reset()	          

	sItem = 'Printer Driver Name: '
   sItem = sItem + DriverInfo.pName
   lb_printerdrivers.AddItem(sItem)

   sItem = ' Version: '
   sItem = sItem + string(DriverInfo.dVersion)
   lb_printerdrivers.AddItem(sItem)

   sItem = ' Environment: '
   sItem = sItem + DriverInfo.pEnvironment
   lb_printerdrivers.AddItem(sItem)

   sItem = ' Driver Path: '
   sItem = sItem + DriverInfo.pDriverPath
   lb_printerdrivers.AddItem(sItem)

   sItem = ' Data File: '
   sItem = sItem + DriverInfo.pDataFile
   lb_printerdrivers.AddItem(sItem)

   sItem = ' Config File: '
   sItem = sItem + DriverInfo.pConfigFile
   lb_printerdrivers.AddItem(sItem)
	
else
	MessageBox("PowerPrinter", "GetPrinterDriver failed. Please check the errors page.")
end if
end event

type cb_enumprinterdrivers from commandbutton within tabpage_enum_drivers
integer x = 32
integer y = 148
integer width = 686
integer height = 108
integer taborder = 3
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Enum All Printer Drivers"
end type

event clicked;driver_info_2 DriverInfo[]	// printer driver information
long ll_ret, ll_i, ll_max = 10
integer li_drivers
string sItem

ll_Ret = nvo_powerprn.of_EnumPrinterDrivers(DriverInfo, ll_max, li_Drivers)

if ll_ret > 0 then
	
	lb_printerdrivers.reset()
	
	for ll_i = 1 to li_drivers
		
		sItem = 'Printer Driver Name: '
   	sItem = sItem + DriverInfo[ll_i].pName
   	lb_printerdrivers.AddItem(sItem)

   	sItem = ' Version: '
   	sItem = sItem + string(DriverInfo[ll_i].dVersion)
   	lb_printerdrivers.AddItem(sItem)

   	sItem = ' Environment: '
   	sItem = sItem + DriverInfo[ll_i].pEnvironment
   	lb_printerdrivers.AddItem(sItem)

   	sItem = ' Driver Path: '
   	sItem = sItem + DriverInfo[ll_i].pDriverPath
   	lb_printerdrivers.AddItem(sItem)

   	sItem = ' Data File: '
   	sItem = sItem + DriverInfo[ll_i].pDataFile
   	lb_printerdrivers.AddItem(sItem)

   	sItem = ' Config File: '
   	sItem = sItem + DriverInfo[ll_i].pConfigFile
   	lb_printerdrivers.AddItem(sItem)
		
	next
else
	MessageBox("PowerPrinter", "GetPrinterDriver failed. Please check the errors page.")
end if
end event

type tabpage_desktop from userobject within tab_1
integer x = 18
integer y = 100
integer width = 1865
integer height = 824
long backcolor = 12632256
string text = "Desktop"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
cb_print cb_print
rb_stretch rb_stretch
rb_bestfit rb_bestfit
rb_clientarea rb_clientarea
rb_entirewindow rb_entirewindow
cb_capturewindow cb_capturewindow
cb_capturedesktop cb_capturedesktop
gb_3 gb_3
gb_2 gb_2
gb_1 gb_1
end type

on tabpage_desktop.create
this.cb_print=create cb_print
this.rb_stretch=create rb_stretch
this.rb_bestfit=create rb_bestfit
this.rb_clientarea=create rb_clientarea
this.rb_entirewindow=create rb_entirewindow
this.cb_capturewindow=create cb_capturewindow
this.cb_capturedesktop=create cb_capturedesktop
this.gb_3=create gb_3
this.gb_2=create gb_2
this.gb_1=create gb_1
this.Control[]={this.cb_print,&
this.rb_stretch,&
this.rb_bestfit,&
this.rb_clientarea,&
this.rb_entirewindow,&
this.cb_capturewindow,&
this.cb_capturedesktop,&
this.gb_3,&
this.gb_2,&
this.gb_1}
end on

on tabpage_desktop.destroy
destroy(this.cb_print)
destroy(this.rb_stretch)
destroy(this.rb_bestfit)
destroy(this.rb_clientarea)
destroy(this.rb_entirewindow)
destroy(this.cb_capturewindow)
destroy(this.cb_capturedesktop)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.gb_1)
end on

type cb_print from commandbutton within tabpage_desktop
integer x = 421
integer y = 552
integer width = 311
integer height = 132
integer taborder = 14
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Print"
end type

event clicked;integer li_PrintOption
string ls_JobName
long ll_Ret
    
If rb_BestFit.Checked = True Then
	li_PrintOption = 119
Else
   li_PrintOption = 120 // strecth to page
End If
    
ls_JobName = "This si the job name argument"
ll_Ret = nvo_powerprn.of_PrintDIB(li_PrintOption, ls_JobName)
If ll_Ret < 1 Then
	MessageBox ("PowerPrinter", "Could not print. Did you capture an image ?")
Else
	MessageBox ("PowerPrinter", "Print successful")
 End If
end event

type rb_stretch from radiobutton within tabpage_desktop
integer x = 782
integer y = 612
integer width = 489
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Strecth to page"
end type

type rb_bestfit from radiobutton within tabpage_desktop
integer x = 782
integer y = 548
integer width = 311
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Best Fit"
boolean checked = true
end type

type rb_clientarea from radiobutton within tabpage_desktop
integer x = 1257
integer y = 164
integer width = 466
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Client Area"
end type

type rb_entirewindow from radiobutton within tabpage_desktop
integer x = 1257
integer y = 92
integer width = 466
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Entire Window"
boolean checked = true
end type

type cb_capturewindow from commandbutton within tabpage_desktop
integer x = 722
integer y = 100
integer width = 489
integer height = 132
integer taborder = 2
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Capture Window"
end type

event clicked;long ll_ret

MessageBox("PowerPriner", "Warning: PowerBuilder does not give the good window handle. This sample is unable to capture the entire window but only the client area. The same API works well under both VB and Delphi.")

if rb_entirewindow.checked = TRUE then
	
	// capture entire window
	ll_ret = nvo_powerprn.of_CaptureWindow(handle(parent), 1)
else
	
	// capture client area
	ll_ret = nvo_powerprn.of_CaptureWindow(handle(parent), 2)
end if

if ll_ret > 0 then
	MessageBox("PowerPrinter", "Window image successfully captured !")
else
	MessageBox("PowerPrinter", "An error occurred while capturing the window image.")
end if
end event

type cb_capturedesktop from commandbutton within tabpage_desktop
integer x = 55
integer y = 100
integer width = 498
integer height = 132
integer taborder = 3
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Capture Desktop"
end type

event clicked;if nvo_powerprn.of_captureDesktop() > 0 then
	MessageBox("PowerPrinter", "Desktop window image successfully captured !")
else
	MessageBox("PowerPrinter", "An error occurred while capturing the desktop image.")
end if
	
end event

type gb_3 from groupbox within tabpage_desktop
integer x = 297
integer y = 456
integer width = 1152
integer height = 300
integer taborder = 12
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Print"
end type

type gb_2 from groupbox within tabpage_desktop
integer x = 9
integer y = 12
integer width = 640
integer height = 324
integer taborder = 5
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Desktop"
end type

type gb_1 from groupbox within tabpage_desktop
integer x = 677
integer y = 8
integer width = 1093
integer height = 328
integer taborder = 12
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Window"
end type

type tabpage_enumfonts from userobject within tab_1
integer x = 18
integer y = 100
integer width = 1865
integer height = 824
long backcolor = 12632256
string text = "Printer Fonts"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
cb_setprinterfont cb_setprinterfont
cb_enumprinterfonts cb_enumprinterfonts
st_38 st_38
lb_fonts lb_fonts
end type

on tabpage_enumfonts.create
this.cb_setprinterfont=create cb_setprinterfont
this.cb_enumprinterfonts=create cb_enumprinterfonts
this.st_38=create st_38
this.lb_fonts=create lb_fonts
this.Control[]={this.cb_setprinterfont,&
this.cb_enumprinterfonts,&
this.st_38,&
this.lb_fonts}
end on

on tabpage_enumfonts.destroy
destroy(this.cb_setprinterfont)
destroy(this.cb_enumprinterfonts)
destroy(this.st_38)
destroy(this.lb_fonts)
end on

type cb_setprinterfont from commandbutton within tabpage_enumfonts
integer x = 937
integer y = 272
integer width = 571
integer height = 108
integer taborder = 13
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Test SetPrinterFont"
end type

event clicked;long ll_PrinterDC, ll_PrintJob, ll_Ret
long ll_Point, ll_Bold, ll_Italic, ll_Underline, ll_Strike
string ls_Font

SetPointer(HourGlass!)
ll_PrintJob = PrintOpen()

// get printer DC
ll_PrinterDC = nvo_powerprn.of_GetPrinterDC(ll_PrintJob)

if lb_fonts.totalitems ( ) > 0 then
	if lb_fonts.selectedindex ( )	<> -1 then
		ls_Font = lb_fonts.selecteditem ( )
		ll_Point 		= 15	// point size
		ll_Bold 			= 0 	// 1 = BOLD
		ll_Italic		= 0	// 1 = italic
		ll_Underline	= 0 	// 1 = underline
		ll_Strike		= 0	// 1 = strikethrough
		
		Print(ll_PrintJob, "Before calling of_SetPrinterFont")
		ll_Ret = nvo_PowerPrn.of_SetPrinterFont(ll_PrinterDC, ls_Font, ll_Point, ll_Bold, ll_Italic, ll_Underline, ll_Strike)
		if ll_Ret > 0 then
			Print(ll_PrintJob, "After calling of_SetPrinterFont")
		else
			MessageBox("PowerPrinter", "SetPrinterFont failed.")
		end if
	else
		MessageBox("PowerPrinter", "Please select a font.")
	end if
end if	

printClose(ll_PrintJob)
end event

type cb_enumprinterfonts from commandbutton within tabpage_enumfonts
integer x = 937
integer y = 128
integer width = 320
integer height = 108
integer taborder = 3
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Get Fonts"
end type

event clicked;string ls_FontList, ls_FontName
long ll_ret,i, iPos

ll_ret = nvo_powerprn.of_EnumPrinterFonts(ls_FontList)

if ll_Ret > 0 then

	lb_fonts.reset()

	// font names are separated by semicolon
	iPos = pos(ls_Fontlist , ";")
	do while iPos > 0 
		ls_FontName = left(ls_FontList, iPos -1)
		lb_fonts.AddItem(ls_FontName)
		
		ls_FontList = right(ls_FontList, len(ls_FontList) - iPos)
		iPos = pos(ls_Fontlist , ";")
	loop
else
	messageBox("PowerPrinter", "EnumPrinterFonts failed !")
end if


end event

type st_38 from statictext within tabpage_enumfonts
integer x = 73
integer y = 32
integer width = 389
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "Printer Fonts:"
boolean focusrectangle = false
end type

type lb_fonts from listbox within tabpage_enumfonts
integer x = 69
integer y = 128
integer width = 827
integer height = 632
integer taborder = 22
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type cb_unlock from commandbutton within w_power_printer
integer x = 1961
integer y = 772
integer width = 379
integer height = 108
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Unlock"
end type

event clicked;//open(w_unlock)
end event

type cb_about from commandbutton within w_power_printer
integer x = 1961
integer y = 904
integer width = 379
integer height = 108
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "About"
end type

event clicked;nvo_PowerPrn.of_About()
end event

type st_driver from statictext within w_power_printer
integer x = 955
integer y = 96
integer width = 485
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean enabled = false
string text = "none"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_4 from statictext within w_power_printer
integer x = 955
integer y = 20
integer width = 485
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "Driver:"
boolean focusrectangle = false
end type

type st_port from statictext within w_power_printer
integer x = 1467
integer y = 96
integer width = 430
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean enabled = false
string text = "none"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_3 from statictext within w_power_printer
integer x = 1467
integer y = 20
integer width = 430
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "Port:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_power_printer
integer x = 32
integer y = 20
integer width = 869
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean enabled = false
string text = "Default Printer Name:"
boolean focusrectangle = false
end type

type cb_bye from commandbutton within w_power_printer
integer x = 1961
integer y = 1032
integer width = 379
integer height = 108
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Close"
end type

event clicked;close(parent)
end event

type st_printer from statictext within w_power_printer
integer x = 23
integer y = 96
integer width = 869
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean enabled = false
string text = "none"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

