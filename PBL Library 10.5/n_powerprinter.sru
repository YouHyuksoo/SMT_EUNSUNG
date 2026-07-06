HA$PBExportHeader$n_powerprinter.sru
$PBExportComments$PowerPrinter API nonvisualobject
forward
global type n_powerprinter from nonvisualobject
end type
end forward

global type n_powerprinter from nonvisualobject
end type
global n_powerprinter n_powerprinter

type prototypes
// all APIs are described in the help file

// check nvo constructor and destructor
function ulong CWin32Prn_CPP_CONSTRUCTOR() library "powerprn.dll"
subroutine CWin32Prn_CPP_DESTRUCTOR(ulong hdl) library "powerprn.dll"

// default printer APIs
Function  long dwGetDefaultPrinterName (ulong hdl, ref string sDefaultPprinter) Library "powerprn.dll" alias for "dwGetDefaultPrinterName;Ansi"
Function  long dwGetPrinterList (ulong hdl, ref string sDefaultPprinter) Library "powerprn.dll" alias for "dwGetPrinterList;Ansi"
Function Long dwGetDefaultPrinterDriver (ulong hdl, ref string sDefaultPprinter) Library "powerprn.dll" alias for "dwGetDefaultPrinterDriver;Ansi"	
Function Long dwSetDefaultPrinter (ulong hdl, string sDefaultPprinter) Library "powerprn.dll" alias for "dwSetDefaultPrinter;Ansi"	
Function Long dwGetDefaultPrinterEx (ulong hdl, ref string sPrinterName, ref string PrinterDriver, ref string printerport) Library "powerprn.dll" alias for "dwGetDefaultPrinterEx;Ansi"		
Function Long dwSetDefaultPrinterEx (ulong hdl, string sPrinterName, string PrinterDriver, string printerport) Library "powerprn.dll" alias for "dwSetDefaultPrinterEx;Ansi"		

// printer port
Function Long dwGetDefaultPrinterPort (ulong hdl, ref string sDefaultPprinter) Library "powerprn.dll" alias for "dwGetDefaultPrinterPort;Ansi"		
function long dwSetDefaultPrinterPort(long hdl, string portname) library "powerprn.dll" alias for "dwSetDefaultPrinterPort;Ansi"

// printer orientation
Function Long dwGetPrinterOrientation(ulong hdl, ref int iPrnOrientation) library "powerprn.dll"
Function Long dwSetPrinterOrientation(ulong hdl, int iPrnOrientation) library "powerprn.dll"

// int paper size
Function Long dwGetPaperSize(ulong hdl, ref int iPaperSize) library "powerprn.dll"
Function Long dwSetPaperSize(ulong hdl, int iPaperSize) library "powerprn.dll"

// int paper Length
Function Long dwGetPaperLength(ulong hdl, ref int iPaperLength) library "powerprn.dll"
Function Long dwSetPaperLength(ulong hdl, int iPaperLength) library "powerprn.dll"

// int paper Width
Function Long dwGetPaperWidth(ulong hdl, ref int iPaperWidth) library "powerprn.dll"
Function Long dwSetPaperWidth(ulong hdl, int iPaperWidth) library "powerprn.dll"

// Scale
Function Long dwGetScale(ulong hdl, ref int iScale) library "powerprn.dll"
Function Long dwSetScale(ulong hdl, int iScale) library "powerprn.dll"

// Copies
Function Long dwGetCopies(ulong hdl, ref int iCopies) library "powerprn.dll"
Function Long dwSetCopies(ulong hdl, int iCopies) library "powerprn.dll"

// Default Source
Function Long dwGetDefaultSource(ulong hdl, ref int iSource) library "powerprn.dll"
Function Long dwSetDefaultSource(ulong hdl, int iSource) library "powerprn.dll"

// int  dmPrintQuality
Function Long dwGetPrintQuality(ulong hdl, ref int iPrintQuality) library "powerprn.dll"
Function Long dwSetPrintQuality(ulong hdl, int iPrintQuality) library "powerprn.dll"

// Color
Function Long dwGetColor(ulong hdl, ref int iColor) library "powerprn.dll"
Function Long dwSetColor(ulong hdl, int iColor) library "powerprn.dll"

// Duplex
Function Long dwGetDuplex(ulong hdl, ref int iDuplex) library "powerprn.dll"
Function Long dwSetDuplex(ulong hdl, int iDuplex) library "powerprn.dll"

// YResolution
Function Long dwGetYResolution(ulong hdl, ref int iYResolution) library "powerprn.dll"
Function Long dwSetYResolution(ulong hdl, int iYResolution) library "powerprn.dll"

// TTOption
Function Long dwGetTTOption(ulong hdl, ref int iTTOption) library "powerprn.dll"
Function Long dwSetTTOption(ulong hdl, int iTTOption) library "powerprn.dll"

// Collate
Function Long dwGetCollate(ulong hdl, ref int iCollate) library "powerprn.dll"
Function Long dwSetCollate(ulong hdl, int iCollate) library "powerprn.dll"

subroutine dwAbout() library "powerprn.dll"
function long dwUnlock(string sRegisteredUser, long lKey) library "powerprn.dll" alias for "dwUnlock;Ansi"
Function  long dwGetPaperBinList(ulong hdl, ref string sBinList) Library "powerprn.dll" alias for "dwGetPaperBinList;Ansi"
Function  long dwGetNamedPaperBinList(ulong hdl, ref string sBinList) Library "powerprn.dll" alias for "dwGetNamedPaperBinList;Ansi"
Function Long dwGetSupportedPaperSizeList(ulong hdl, ref string szPageSizeList) Library "powerprn.dll" alias for "dwGetSupportedPaperSizeList;Ansi"

//V1.1 APIs
function long dwGetExtendedErrorCode(ulong hdl) library "powerprn.dll"
subroutine dwGetExtendedErrorMessage(ulong hdl, ref string sErrorMsg) library "powerprn.dll" alias for "dwGetExtendedErrorMessage;Ansi"

// NT ONLY ! (for Network printer only). Drivers will be downloaded from SERVER
function long dwAddPrinterConnection (long hdl, string szServerName, string szPrnShareName) library "powerprn.dll" alias for "dwAddPrinterConnection;Ansi"
function long dwDeletePrinterConnection (long hdl, string szServerName, string szPrnShareName) library "powerprn.dll" alias for "dwDeletePrinterConnection;Ansi"

// Add Delete local & network printers
function long dwAddPrinter (long hdl, string szServerName, string szPrinterName, string szPortName, string szDriverName, string szPrintProcessor) library "powerprn.dll" alias for "dwAddPrinter;Ansi"
function long dwDeletePrinter (long hdl, string szPrinterName) library "powerprn.dll" alias for "dwDeletePrinter;Ansi"

// Add Delete printer driver. Files must already be present
function long dwAddPrinterDriver (long hdl, string szServerName, string szPrinterName, string szEnvironment, string szDriverPath, string szDataFile, string szConfigFile, long dVersion) library "powerprn.dll" alias for "dwAddPrinterDriver;Ansi"
function long dwDeletePrinterDriver (long hdl,string szServerName, string szEnvironment, string szDriverName) library "powerprn.dll" alias for "dwDeletePrinterDriver;Ansi"

// Get printer driver according to printer name
function long dwGetPrinterDriver( long hdl, string szPrinterName, ref driver_info_2 DriverInfo) library "powerprn.dll" alias for "dwGetPrinterDriver;Ansi"

// Enumerate all printer drivers installed
function long dwGetPrinterDrivers(long hdl, ref Driver_Info_2 pDriverInfo2 [], long  iMax, ref integer iActualOnes)library "powerprn.dll" alias for "dwGetPrinterDrivers;Ansi"

// Printer Job
function long dwEnumPrinterJobs(long hdl, string szPrinterName, long iMaxJobs,  ref job_info_1 ji1[], ref long  Jobs) library "powerprn.dll" alias for "dwEnumPrinterJobs;Ansi"

function long dwCaptureDesktop(long hdl) library "powerprn.dll"
function long dwPrintTheDIB(long hdl, int iOption, string szText) library "powerprn.dll" alias for "dwPrintTheDIB;Ansi"
function long dwCaptureWindow(long hdl, unsignedlong hWin, long fPrintArea) library "powerprn.dll"

// Printer Fonts
Function long dwEnumPrinterFonts (long hdl, ref string szFontList) Library "powerprn.dll" alias for "dwEnumPrinterFonts;Ansi"
Function long dwSetPrinterFont (long hdl, unsignedlong pDC, string szFontName, long iPoint, long iBold , long iItalic, long iUnderline , long iStrike) Library "powerprn.dll" alias for "dwSetPrinterFont;Ansi"


// Oh Oh Little hack !
function long PRP_GetDC (long printjob) library "Pbshr100.dll"
end prototypes

type variables
ulong this_hdl

Public:

// error codes
CONSTANT long NO_ERR	                                =1            // hey, no error !
CONSTANT long ERR_BAD_ARGUMENT	=-1	// bad arg given to function
CONSTANT long ERR_BUFFER_2SMALL	=-2	// not large enough
CONSTANT long ERR_NO_DEF_PRN		=-3	// no default printer
CONSTANT long ERR_NO_DEF_PORT	=-4	// no default printer port (v1.1)
CONSTANT long ERR_NO_DEF_DRIVER	=-5	// no default printer driver (v1.1)
CONSTANT long ERR_BUFFER_EMPTY	=-6	// given argument is empty ! (v1.1)
CONSTANT long ERR_NULL_POINTER	=-7	// null pointer eceived while expecting an argument (v1.1)
CONSTANT long	ERR_PRN_OPEN		=-100	// Cannot get the printer -- access problem ?
CONSTANT long	ERR_PRN_GET		=-101	// GetPrinter failed to return buffer size
CONSTANT long	ERR_GLOBAL_ALLOC	=-102	// GlobalAlloc failed
CONSTANT long	ERR_GLOBAL_LOCK	=-103	// GlobalLock failed 
CONSTANT long	ERR_PRINT_INFO2	=-104	// Cannot fill in PRINT_INFO_2 structure
CONSTANT long	ERR_PRN_NOCHANGE	=-105	// Printer doe snot support change
CONSTANT long	ERR_UPDT_DEVMODE	=-106	// Cannot update driver-dependent part of devmode
CONSTANT long	ERR_PRN_SET		=-107	// SetPrinter Failed
CONSTANT long ERR_ATTR_UNKNOWN	=-108	// Unknown Attribute
CONSTANT long ERR_DEVMODE_ISNULL	=-109	// GetPrinter API failed -- even if ret code was OK !
CONSTANT long ERR_NOT_IMPLEMENTED	=-110	// API not implmemented (v1.1)
CONSTANT long ERR_ADD_PRINTER		=-111	// AddPrinter API failed (v1.1)
CONSTANT long	ERR_ADD_PRNCONN	=-112	// AddPrinterConnection API failed (v1.1)
CONSTANT long	ERR_DEL_PRNCONN	=-113	// DeletePrinterConnection API failed (v1.1)
CONSTANT long ERR_DEL_PRINTER		=-114	// DeletePrinter API failed (v1.1)
CONSTANT long ERR_ADD_DRIVER		=-115	// AddAPrinterDriver failed (v1.1)
CONSTANT long ERR_DEL_DRIVER		=-116	// DelAPrinterDriver failed (v1.1)
CONSTANT long ERR_LOCAL_ALLOC		=-117	// LocalAlloc failed (v1.1)
CONSTANT long ERR_ENUM_NO_DRV	=-118	// EnumDrivers returned zero (v1.1)
CONSTANT long ERR_NOTHING_2DO	=-119	// Nothing to do (v1.1). Eg no print jobs
CONSTANT long ERR_ENUM_JOBS1		=-120	// EnumJobs (step 1) failed (v1.1)
CONSTANT long ERR_ENUM_JOBS2		=-121	// EnumJobs (step 2) failed (v1.1)
CONSTANT long ERR_WIN95_SETDEFPRNEX  =-122	// SetDefaultPrinterEx failed under Win 95 (v1.1)
CONSTANT long ERR_NOLOAD_POWERDIB	=-123	// Cannot load PowerDIB
CONSTANT long ERR_NOLOAD_FUNCTION      =-124	// Cannot Load function. This should never happen !
CONSTANT long ERR_BAD_DC		=-125	// Bad device context argument
CONSTANT long ERR_CREATE_FONT	=-126	// Could not create the font
CONSTANT long ERR_COPY_WINDOW	=-127	// Could not copy window

// orientation selections
CONSTANT uint DMORIENT_PORTRAIT = 1
CONSTANT uint DMORIENT_LANDSCAPE = 2

// paper selections
//  Warning: The PostScript driver mistakingly uses DMPAPER_ values between
// *  50 and 56.  Don//t use this range when defining new paper sizes.
 
CONSTANT int DMPAPER_FIRST = 1
CONSTANT int DMPAPER_LETTER = 1               // Letter 8 1/2 x 11 in
CONSTANT int DMPAPER_LETTERSMALL = 2          // Letter Small 8 1/2 x 11 in
CONSTANT int DMPAPER_TABLOID = 3              // Tabloid 11 x 17 in
CONSTANT int DMPAPER_LEDGER = 4               // Ledger 17 x 11 in
CONSTANT int DMPAPER_LEGAL = 5                // Legal 8 1/2 x 14 in
CONSTANT int DMPAPER_STATEMENT = 6            // Statement 5 1/2 x 8 1/2 in
CONSTANT int DMPAPER_EXECUTIVE = 7            // Executive 7 1/4 x 10 1/2 in
CONSTANT int DMPAPER_A3 = 8                   // A3 297 x 420 mm
CONSTANT int DMPAPER_A4 = 9                   // A4 210 x 297 mm
CONSTANT int DMPAPER_A4SMALL = 10             // A4 Small 210 x 297 mm
CONSTANT int DMPAPER_A5 = 11                  // A5 148 x 210 mm
CONSTANT int DMPAPER_B4 = 12                  // B4 250 x 354
CONSTANT int DMPAPER_B5 = 13                  // B5 182 x 257 mm
CONSTANT int DMPAPER_FOLIO = 14               // Folio 8 1/2 x 13 in
CONSTANT int DMPAPER_QUARTO = 15              // Quarto 215 x 275 mm
CONSTANT int DMPAPER_10x14 = 16               // 10x14 in
CONSTANT int DMPAPER_11X17 = 17               // 11x17 in
CONSTANT int DMPAPER_NOTE = 18                // Note 8 1/2 x 11 in
CONSTANT int DMPAPER_ENV_9 = 19               // Envelope #9 3 7/8 x 8 7/8
CONSTANT int DMPAPER_ENV_10 = 20              // Envelope #10 4 1/8 x 9 1/2
CONSTANT int DMPAPER_ENV_11 = 21              // Envelope #11 4 1/2 x 10 3/8
CONSTANT int DMPAPER_ENV_12 = 22              // Envelope #12 4 \276 x 11
CONSTANT int DMPAPER_ENV_14 = 23              // Envelope #14 5 x 11 1/2
CONSTANT int DMPAPER_CSHEET = 24              // C size sheet
CONSTANT int DMPAPER_DSHEET = 25              // D size sheet
CONSTANT int DMPAPER_ESHEET = 26              // E size sheet
CONSTANT int DMPAPER_ENV_DL = 27              // Envelope DL 110 x 220mm
CONSTANT int DMPAPER_ENV_C5 = 28              // Envelope C5 162 x 229 mm
CONSTANT int DMPAPER_ENV_C3 = 29              // Envelope C3  324 x 458 mm
CONSTANT int DMPAPER_ENV_C4 = 30              // Envelope C4  229 x 324 mm
CONSTANT int DMPAPER_ENV_C6 = 31              // Envelope C6  114 x 162 mm
CONSTANT int DMPAPER_ENV_C65 = 32             // Envelope C65 114 x 229 mm
CONSTANT int DMPAPER_ENV_B4 = 33              // Envelope B4  250 x 353 mm
CONSTANT int DMPAPER_ENV_B5 = 34              // Envelope B5  176 x 250 mm
CONSTANT int DMPAPER_ENV_B6 = 35              // Envelope B6  176 x 125 mm
CONSTANT int DMPAPER_ENV_ITALY = 36           // Envelope 110 x 230 mm
CONSTANT int DMPAPER_ENV_MONARCH = 37         // Envelope Monarch 3.875 x 7.5 in
CONSTANT int DMPAPER_ENV_PERSONAL = 38        // 6 3/4 Envelope 3 5/8 x 6 1/2 in
CONSTANT int DMPAPER_FANFOLD_US = 39          // US Std Fanfold 14 7/8 x 11 in
CONSTANT int DMPAPER_FANFOLD_STD_GERMAN = 40  // German Std Fanfold 8 1/2 x 12 in
CONSTANT int DMPAPER_FANFOLD_LGL_GERMAN = 41  // German Legal Fanfold 8 1/2 x 13 in

CONSTANT int DMPAPER_LAST = 41

CONSTANT int DMPAPER_USER = 256

// bin selections
CONSTANT int DMBIN_FIRST = 1
CONSTANT int DMBIN_UPPER = 1
CONSTANT int DMBIN_ONLYONE = 1
CONSTANT int DMBIN_LOWER = 2
CONSTANT int DMBIN_MIDDLE = 3
CONSTANT int DMBIN_MANUAL = 4
CONSTANT int DMBIN_ENVELOPE = 5
CONSTANT int DMBIN_ENVMANUAL = 6
CONSTANT int DMBIN_AUTO = 7
CONSTANT int DMBIN_TRACTOR = 8
CONSTANT int DMBIN_SMALLFMT = 9
CONSTANT int DMBIN_LARGEFMT = 10
CONSTANT int DMBIN_LARGECAPACITY = 11
CONSTANT int DMBIN_CASSETTE = 14
CONSTANT int DMBIN_LAST = 14

CONSTANT int DMBIN_USER = 256             // device specific bins start here

// print qualities
CONSTANT int DMRES_DRAFT = -1
CONSTANT int DMRES_LOW = -2
CONSTANT int DMRES_MEDIUM = -3
CONSTANT int DMRES_HIGH = -4

// color enable/disable for color printers
CONSTANT int DMCOLOR_MONOCHROME = 1
CONSTANT int DMCOLOR_COLOR = 2

// duplex enable
CONSTANT int DMDUP_SIMPLEX = 1
CONSTANT int DMDUP_VERTICAL = 2
CONSTANT int DMDUP_HORIZONTAL = 3

// TrueType options
CONSTANT int DMTT_BITMAP = 1          // print TT fonts as graphics
CONSTANT int DMTT_DOWNLOAD = 2        // download TT fonts as soft fonts
CONSTANT int DMTT_SUBDEV = 3          // substitute device fonts for TT fonts

end variables

forward prototypes
public function string of_getprinterlist ()
public function string of_getdefaultprinterport ()
public function string of_getdefaultprinterdriver ()
public function string of_getdefaultprintername ()
public function integer of_setdefaultprinter (string as_printername)
public function string of_getprinterorientationstring ()
public function long of_getdefaultprinterex (ref string as_printername, ref string as_printerdriver, ref string as_printerport)
public function integer of_setdefaultprinterex (string as_printername, string as_printerdriver, string as_printerport)
public function long of_getprinterorientation (ref integer ai_prnorientation)
public function long of_setprinterorientation (integer ai_orient)
public subroutine of_about ()
public function boolean of_unlock (string as_reguser, long al_key)
public function string of_getpaperbinlist ()
public function string of_getnamedpaperbinlist ()
public function long of_getpapersource (ref integer ai_prnsource)
public function long of_setpapersource (integer ai_source)
public function string of_getsupportedpapersizelist ()
public function long of_setpapersize (integer ai_size)
public function long of_getpapersize (ref integer ai_size)
public function long of_getpaperlength (ref integer ai_size)
public function long of_getpaperwidth (ref integer ai_width)
public function long of_setpaperlength (integer ai_size)
public function long of_setpaperwidth (integer ai_size)
public function long of_getscale (ref integer ai_size)
public function long of_setscale (integer ai_size)
public function long of_getcopies (ref integer ai_size)
public function long of_setcopies (integer ai_size)
public function long of_getprintquality (ref integer ai_size)
public function long of_setprintquality (integer ai_size)
public function long of_getcolor (ref integer ai_size)
public function long of_getduplex (ref integer ai_size)
public function long of_getyresolution (ref integer ai_size)
public function long of_getttoption (ref integer ai_size)
public function long of_getcollate (ref integer ai_size)
public function long of_setcolor (integer ai_size)
public function long of_setduplex (integer ai_size)
public function long of_setyresolution (integer ai_size)
public function long of_setttoption (integer ai_size)
public function long of_setcollate (integer ai_size)
public function long of_getextendederrorcode ()
public function string of_getextendederrormessage ()
public function long of_addprinterconnection (string as_srvname, string as_prnname)
public function long of_delprinterconnection (string as_srvname, string as_prnname)
public function long of_addprinter (string as_servername, string as_printername, string as_portname, string as_drivername, string as_printprocessor)
public function long of_delprinter (string as_PrinterName)
public function long of_delprinterdriver (string as_ServerName, string as_Environment, string as_DriverName)
public function long of_getprinterdriver (string as_PrinterName, ref driver_info_2 as_di2)
public function long of_addprinterdriver (string as_servername, string as_drivername, string as_environment, string as_driverpath, string as_datafile, string as_configfile, long al_version)
public function long of_enumprinterdrivers (ref driver_info_2 as_di2[], long al_max, ref integer al_drivers)
public function long of_enumprinterjobs (string as_printername, long al_maxjobs, ref job_info_1 jobinfo[], ref long al_jobs)
public function long of_capturedesktop ()
public function long of_printdib (integer ai_option, string as_jobname)
public function long of_enumprinterfonts (ref string as_fonts)
public function long of_capturewindow (unsignedlong al_hwnd, long al_option)
public function long of_setdefaultprinterport (string as_port)
public function long of_getprinterdc (long al_printjob)
public function long of_setprinterfont (long al_pdc, string as_fontname, long al_point, long al_bold, long al_italic, long al_underline, long al_strike)
public function long of_getdefaultprinterhandle ()
end prototypes

public function string of_getprinterlist ();string lsPrnList
long i

// init string
lsPrnList = space(1050)

// go get it: i = number of printers

i = dwGetPrinterList (this_hdl, lsPrnList)

return trim(lsPrnList)
end function

public function string of_getdefaultprinterport ();//************************************************************
// Object: n_powerprinter
// Method: of_getdefaultprinterport
// Author: Marco Peretti - DigitalWave
// Date  : 8/5/97
//
// Arg   :
// Return: string
//
// Desc  : Get the default printer port
//
//************************************************************
// Modifications:
// Date            Author              Comments
//------------------------------------------------------------
//
//************************************************************

string lsPrn
long i

lsPrn = space(255)
i = dwGetDefaultPrinterPort (this_hdl, lsPrn)

if i <= 0 then
	lsPrn = "No port defined"
end if

return trim(lsPrn)
end function

public function string of_getdefaultprinterdriver ();//************************************************************
// Object: n_powerprinter
// Method: of_getdefaultprinterdriver
// Author: Marco Peretti - DigitalWave
// Date  : 8/5/97
//
// Arg   :
// Return: string
//
// Desc  : Get the default printer's driver.
//
//************************************************************
// Modifications:
// Date            Author              Comments
//------------------------------------------------------------
//
//************************************************************

string lsPrn
long i

// fill up the string before making the call
lsPrn = space(255)
i = dwGetDefaultPrinterDriver (this_hdl, lsPrn)

if i <= 0 then
	lsPrn = "No driver defined"
end if

return trim(lsPrn)
end function

public function string of_getdefaultprintername ();//************************************************************
// Object: n_powerprinter
// Method: of_getdefaultprintername
// Author: Marco Peretti - DigitalWave
// Date  : 8/5/97
//
// Arg   :
// Return: string
//
// Desc  : Get the default printer name. 
//
//************************************************************
// Modifications:
// Date            Author              Comments
//------------------------------------------------------------
//
//************************************************************

string lsPrn
long i

lsPrn = space(255)
i = dwGetDefaultPrinterName (this_hdl, lsPrn)

if i <= 0 then
	lsPrn = "No printer defined"
end if

return trim(lsPrn)
end function

public function integer of_setdefaultprinter (string as_printername);return dwSetDefaultPrinter(this_hdl, as_printername)
end function

public function string of_getprinterorientationstring ();int 		iOrient
long 		lError
string 	sOrient

lError = dwGetPrinterOrientation(this_hdl, iOrient)

if lError > 0 then
	
	choose case iOrient
		
		case DMORIENT_PORTRAIT
			sOrient = "Portrait"
		
		case DMORIENT_LANDSCAPE
			sOrient = "Landscape"
		
		case else
			sOrient = "Unknown Orientation"
	end choose
else
	sOrient = "Unable to fetch Orientation"
end if

return sOrient
		
end function

public function long of_getdefaultprinterex (ref string as_printername, ref string as_printerdriver, ref string as_printerport);//************************************************************
// Object: n_powerprinter
// Method: of_getdefaultprinterex
// Author: Marco Peretti - DigitalWave
// Date  : 8/5/97
//
// Arg   : string		Printer Name, by reference
//			  string		Printer Driver, by reference
//			  string		Printer Port, by reference
// Return: long
//
// Desc  : this API returns the default printer name, driver
//			  and port in one call.
//
//************************************************************
// Modifications:
// Date            Author              Comments
//------------------------------------------------------------
//
//************************************************************

long i

// fill them up before making the call
as_PrinterName		= space(200)
as_PrinterDriver	= space(200)
as_PrinterPort		= space(200)

i = dwGetDefaultPrinterEx (this_hdl, as_PrinterName, as_PrinterDriver, as_PrinterPort)

as_PrinterName		= trim(as_printername)
as_PrinterDriver	= trim(as_printerdriver)
as_PrinterPort		= trim(as_printerport)

return i
end function

public function integer of_setdefaultprinterex (string as_printername, string as_printerdriver, string as_printerport);return dwSetDefaultPrinterEx(this_hdl, as_printername, as_printerdriver, as_printerport)
end function

public function long of_getprinterorientation (ref integer ai_prnorientation);return dwGetPrinterOrientation(this_hdl, ai_PrnOrientation)
	

end function

public function long of_setprinterorientation (integer ai_orient);if ((ai_orient = DMORIENT_PORTRAIT)  or (ai_orient = DMORIENT_LANDSCAPE)) then
	return dwSetPrinterOrientation(this_hdl, ai_orient)
else
	return -2;
end if
end function

public subroutine of_about ();//************************************************************
// Object: n_powerprinter
// Method: of_about
// Author: Marco Peretti - DigitalWave
// Date  : 8/5/97
//
// Arg   :
// Return: (None)
//
// Desc  : Show about box
//
//************************************************************
// Modifications:
// Date            Author              Comments
//------------------------------------------------------------
//
//************************************************************

dwAbout()
end subroutine

public function boolean of_unlock (string as_reguser, long al_key);//************************************************************
// Object: n_powerprinter
// Method: of_unlock
// Author: Marco Peretti - DigitalWave
// Date  : 8/5/97
//
// Arg   :
// Return: boolean
//
// Desc  : Registered customers receive a user name and KEY
//			  that disables the registration reminder screen.
//			  NB: you have to call the API all the times !
//			  TIP: Place the call after the constructor.
//
//************************************************************
// Modifications:
// Date            Author              Comments
//------------------------------------------------------------
//
//************************************************************

return dwUnlock(as_reguser, al_key) = 1
end function

public function string of_getpaperbinlist ();//************************************************************
// Object: n_powerprinter
// Method: of_getpaperbinlist
// Author: Marco Peretti - DigitalWave
// Date  : 8/5/97
//
// Arg   :
// Return: string
//
// Desc  : Get the list of available paper bins. The paper bins 
// 		  are separated by semicolumn (;). Each paper bin consists 
//			  of a number (Bin ID) and a description. The paper bin 
//			  can be set by using dwSetDefaultSource . Please refer to 
//			  the sample applications for an implementation example.
//			  The separator character can be changed with
//			  of_SetListSeparator
//
//************************************************************
// Modifications:
// Date            Author              Comments
//------------------------------------------------------------
//
//************************************************************

string lsBinList
long i

lsBinList = space(500)
i = dwGetPaperBinList (this_hdl, lsBinList)

return trim(lsBinList)
end function

public function string of_getnamedpaperbinlist ();//************************************************************
// Object: n_powerprinter
// Method: of_getnamedpaperbinlist
// Author: Marco Peretti - DigitalWave
// Date  : 8/5/97
//
// Arg   :
// Return: string
//
// Desc  : Get a list of available paper bins. The bin name 
//			  are separated by semi column (;). This list is more 
//			  readable (for the end user) than the one returned 
//			  of_GetPaperBinList but there is no Bin ID associated.
//			  The separator character can be changed with 
//			  of_SetListSeparator
//
//************************************************************
// Modifications:
// Date            Author              Comments
//------------------------------------------------------------
//
//************************************************************

string lsBinList
long i

lsBinList = space(500)
i = dwGetNamedPaperBinList (this_hdl, lsBinList)

return trim(lsBinList)
end function

public function long of_getpapersource (ref integer ai_prnsource);return dwGetDefaultSource(this_hdl, ai_PrnSource) 
	

end function

public function long of_setpapersource (integer ai_source);return dwSetDefaultSource(this_hdl, ai_source)

end function

public function string of_getsupportedpapersizelist ();string lsPaperList
long i

lsPaperList = space(6000)
i = dwGetSupportedPaperSizeList (this_hdl, lsPaperList)

return trim(lsPaperList)
end function

public function long of_setpapersize (integer ai_size);return dwSetPaperSize(this_hdl, ai_size)
end function

public function long of_getpapersize (ref integer ai_size);return dwGetPaperSize(this_hdl, ai_size)
end function

public function long of_getpaperlength (ref integer ai_size);return dwGetPaperLength(this_hdl, ai_size)
end function

public function long of_getpaperwidth (ref integer ai_width);return dwGetPaperWidth(this_hdl, ai_width)
end function

public function long of_setpaperlength (integer ai_size);return dwSetPaperLength(this_hdl, ai_size)
end function

public function long of_setpaperwidth (integer ai_size);return dwSetPaperWidth(this_hdl, ai_size)
end function

public function long of_getscale (ref integer ai_size);return dwGetScale(this_hdl, ai_size)
end function

public function long of_setscale (integer ai_size);return dwSetScale(this_hdl, ai_size)
end function

public function long of_getcopies (ref integer ai_size);//************************************************************
// Object: n_powerprinter
// Method: of_getcopies
// Author: Marco Peretti - DigitalWave
// Date  : 8/5/97
//
// Arg   :
// Return: long
//
// Desc  : Returns the number of copies as set with dwSetCopies. 
//			  The device must support multiple-page copies.
//
//************************************************************
// Modifications:
// Date            Author              Comments
//------------------------------------------------------------
//
//************************************************************

return dwGetCopies(this_hdl, ai_size)
end function

public function long of_setcopies (integer ai_size);return dwSetCopies(this_hdl, ai_size)
end function

public function long of_getprintquality (ref integer ai_size);return dwGetPrintQuality(this_hdl, ai_size)
end function

public function long of_setprintquality (integer ai_size);return dwSetPrintQuality(this_hdl, ai_size)
end function

public function long of_getcolor (ref integer ai_size);//************************************************************
// Object: n_powerprinter
// Method: of_getcolor
// Author: Marco Peretti - DigitalWave
// Date  : 8/5/97
//
// Arg   :
// Return: long
//
// Desc  : Get printer color settings
//
//************************************************************
// Modifications:
// Date            Author              Comments
//------------------------------------------------------------
//
//************************************************************

return dwGetColor(this_hdl, ai_size)
end function

public function long of_getduplex (ref integer ai_size);//************************************************************
// Object: n_powerprinter
// Method: of_getduplex
// Author: Marco Peretti - DigitalWave
// Date  : 8/5/97
//
// Arg   :
// Return: long
//
// Desc  : Return duplex settings.  
//			  possible values: DMDUP_SIMPLEX, DMDUP_HORIZONTAL, DMDUP_VERTICAL
//
//************************************************************
// Modifications:
// Date            Author              Comments
//------------------------------------------------------------
//
//************************************************************

return dwGetDuplex(this_hdl, ai_size)
end function

public function long of_getyresolution (ref integer ai_size);return dwGetYResolution(this_hdl, ai_size)
end function

public function long of_getttoption (ref integer ai_size);return dwGetTTOption(this_hdl, ai_size)
end function

public function long of_getcollate (ref integer ai_size);//************************************************************
// Object: n_powerprinter
// Method: of_getcollate
// Author: Marco Peretti - DigitalWave
// Date  : 8/5/97
//
// Arg   :
// Return: long
//
// Desc  : return collate settings. Collate is used to send 
//			  a document to be printyer multiple times only once.
//			  Not all printer support the collate attribute
//
//************************************************************
// Modifications:
// Date            Author              Comments
//------------------------------------------------------------
//
//************************************************************

return dwGetCollate(this_hdl, ai_size)
end function

public function long of_setcolor (integer ai_size);return dwSetColor(this_hdl, ai_size)
end function

public function long of_setduplex (integer ai_size);//************************************************************
// Object: n_powerprinter
// Method: of_setduplex
// Author: Marco Peretti - DigitalWave
// Date  : 8/5/97
//
// Arg   :
// Return: long
//
// Desc  :Set duplex settings
//			possible values: DMDUP_SIMPLEX, DMDUP_HORIZONTAL, DMDUP_VERTICAL
//
//************************************************************
// Modifications:
// Date            Author              Comments
//------------------------------------------------------------
//
//************************************************************

return dwSetDuplex(this_hdl, ai_size)
end function

public function long of_setyresolution (integer ai_size);return dwSetYResolution(this_hdl, ai_size)
end function

public function long of_setttoption (integer ai_size);return dwSetTTOption(this_hdl, ai_size)
end function

public function long of_setcollate (integer ai_size);return dwSetCollate(this_hdl, ai_size)
end function

public function long of_getextendederrorcode ();//************************************************************
// Object: n_powerprinter
// Method: of_getextendederrorcode
// Author: Marco Peretti - DigitalWave
// Date  : 8/5/97
//
// Arg   :
// Return: long
//
// Desc  : Return Extended Error Code set by Windows APIs in case
// 		  of an error. Error codes are as defined in the SDK
//
//************************************************************
// Modifications:
// Date            Author              Comments
//------------------------------------------------------------
//
//************************************************************

return dwGetExtendedErrorCode(this_hdl)
end function

public function string of_getextendederrormessage ();//************************************************************
// Object: n_powerprinter
// Method: of_getextendederrormessage
// Author: Marco Peretti - DigitalWave
// Date  : 8/5/97
//
// Arg   :
// Return: string
//
// Desc  : return the error message as set by Windows API
//			  erro messages as defined in the SDK
//
//************************************************************
// Modifications:
// Date            Author              Comments
//------------------------------------------------------------
//
//************************************************************

string ls_Msg

// be sure that we allocate enough space
ls_Msg = space(512)

dwGetExtendedErrorMessage(this_hdl, ls_msg)

return ls_Msg
end function

public function long of_addprinterconnection (string as_srvname, string as_prnname);//************************************************************
// Object: n_powerprinter
// Method: of_AddPrinterConnection
// Author: Marco Peretti - DigitalWave
// Date  : 8/5/97
//
// Arg   :
// Return: long
//
// Desc  : connect to a network printer. NT only
//
//************************************************************
// Modifications:
// Date            Author              Comments
//------------------------------------------------------------
//
//************************************************************

return dwAddPrinterConnection (this_hdl, as_srvname, as_prnname) 
end function

public function long of_delprinterconnection (string as_srvname, string as_prnname);//************************************************************
// Object: n_powerprinter
// Method: of_DelPrinterConnection
// Author: Marco Peretti - DigitalWave
// Date  : 8/5/97
//
// Arg   :
// Return: long
//
// Desc  : remove network printer connection. NT only
//
//************************************************************
// Modifications:
// Date            Author              Comments
//------------------------------------------------------------
//
//************************************************************

return dwdeletePrinterConnection (this_hdl, as_srvname, as_prnname) 
end function

public function long of_addprinter (string as_servername, string as_printername, string as_portname, string as_drivername, string as_printprocessor);long ll_ret
pointer oldpointer  // Declares a pointer variable

OldPointer = SetPointer(HourGlass!)

ll_ret = dwAddPrinter (this_hdl, as_ServerName, as_PrinterName, as_PortName, as_DriverName, as_PrintProcessor) 

SetPointer(OldPointer)

return  ll_ret
end function

public function long of_delprinter (string as_PrinterName);return dwDeletePrinter (this_hdl, as_PrinterName) 


end function

public function long of_delprinterdriver (string as_ServerName, string as_Environment, string as_DriverName);return dwDeletePrinterDriver (this_hdl, as_ServerName, as_Environment, as_DriverName)
end function

public function long of_getprinterdriver (string as_PrinterName, ref driver_info_2 as_di2);long ll_ret


as_di2.pName = space(200)
as_di2.pEnvironment = space(200)
as_di2.pDriverPath = space(200)
as_di2.pDataFile = space(200)
as_di2.pConfigFile = space(200)

ll_Ret = dwGetPrinterDriver( this_hdl, as_PrinterName, as_di2)

return ll_ret
end function

public function long of_addprinterdriver (string as_servername, string as_drivername, string as_environment, string as_driverpath, string as_datafile, string as_configfile, long al_version);return dwAddPrinterDriver (this_hdl, as_ServerName, as_DriverName, as_Environment, as_DriverPath, as_DataFile, as_ConfigFile, al_Version)
end function

public function long of_enumprinterdrivers (ref driver_info_2 as_di2[], long al_max, ref integer al_drivers);long ll_ret, ll_i


for ll_i = 1 to al_max
	as_di2[ll_i].pName = space(200)
	as_di2[ll_i].pEnvironment = space(200)
	as_di2[ll_i].pDriverPath = space(200)
	as_di2[ll_i].pDataFile = space(200)
	as_di2[ll_i].pConfigFile = space(200)
next

ll_Ret = dwGetPrinterDrivers( this_hdl, as_di2, al_Max, al_drivers)

return ll_ret
end function

public function long of_enumprinterjobs (string as_printername, long al_maxjobs, ref job_info_1 jobinfo[], ref long al_jobs);long ll_Ret, i
char cEmpty

cEmpty = char(0)

// initialize
for I = 1 to al_maxjobs
	JobInfo[i].pPrinterName = fill(cEmpty, 200)
   JobInfo[i].pMachineName = fill(cEmpty, 200)
   JobInfo[i].pUserName    = fill(cEmpty, 200)
   JobInfo[i].pDocument    = fill(cEmpty, 200)
   JobInfo[i].pDataType    = fill(cEmpty, 200)
   JobInfo[i].pStatus      = fill(cEmpty, 200)
next

ll_ret = dwEnumPrinterJobs(this_hdl, as_PrinterName, al_MaxJobs,  JobInfo, al_Jobs)


return ll_Ret
end function

public function long of_capturedesktop ();return dwCaptureDesktop(this_hdl)
end function

public function long of_printdib (integer ai_option, string as_jobname);return dwPrintTheDIB(this_hdl, ai_Option, as_JobName)
end function

public function long of_enumprinterfonts (ref string as_fonts);long ll_ret

as_fonts = Space(1500)

ll_ret = dwEnumPrinterFonts (this_hdl, as_Fonts) 

return ll_ret
end function

public function long of_capturewindow (unsignedlong al_hwnd, long al_option);return dwCaptureWindow(this_hdl, al_hwnd, al_option)
end function

public function long of_setdefaultprinterport (string as_port);return dwSetDefaultPrinterPort(this_hdl, as_Port)
end function

public function long of_getprinterdc (long al_printjob);return PRP_GetDC(al_printjob)
end function

public function long of_setprinterfont (long al_pdc, string as_fontname, long al_point, long al_bold, long al_italic, long al_underline, long al_strike);return dwSetPrinterFont (this_hdl, al_pDC, as_FontName, al_Point, al_Bold , al_Italic, al_Underline , al_Strike) 

end function

public function long of_getdefaultprinterhandle ();//************************************************************
// Object: n_powerprinter
// Method: of_getdefaultprintername
// Author: Marco Peretti - DigitalWave
// Date  : 8/5/97
//
// Arg   :
// Return: string
//
// Desc  : Get the default printer name. 
//
//************************************************************
// Modifications:
// Date            Author              Comments
//------------------------------------------------------------
//
//************************************************************

string lsPrn
long i

lsPrn = space(255)
i = dwGetDefaultPrinterName (this_hdl, lsPrn)

if i <= 0 then
	lsPrn = "No printer defined"
end if

return this_hdl
end function

on n_powerprinter.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_powerprinter.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;//************************************************************
// Object: n_powerprinter
// Method: constructor
// Author: Marco Peretti - DigitalWave
// Date  : 8/5/97
//
// Arg   :
// Return: long
//
// Desc  : call C++ constructor in DLL
//
//************************************************************
// Modifications:
// Date            Author              Comments
//------------------------------------------------------------
//
//************************************************************

this_hdl = CWin32Prn_CPP_CONSTRUCTOR()
end event

event destructor;//************************************************************
// Object: n_powerprinter
// Method: destructor
// Author: Marco Peretti - DigitalWave
// Date  : 8/5/97
//
// Arg   :
// Return: long
//
// Desc  : call C++ destructor in DLL
//
//************************************************************
// Modifications:
// Date            Author              Comments
//------------------------------------------------------------
//
//************************************************************

CWin32Prn_CPP_DESTRUCTOR(this_hdl)
end event

