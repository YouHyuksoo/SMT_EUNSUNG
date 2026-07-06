HA$PBExportHeader$n_ir.sru
$PBExportComments$Extension InternetResult class
forward
global type n_ir from pfc_n_ir
end type
end forward

global type n_ir from pfc_n_ir
end type
global n_ir n_ir

forward prototypes
public function integer internetdata (blob data)
end prototypes

public function integer internetdata (blob data);Messagebox( "IP" , STRING(data ,EncodingANSI!))
RETURN 1
end function

on n_ir.create
call super::create
end on

on n_ir.destroy
call super::destroy
end on

