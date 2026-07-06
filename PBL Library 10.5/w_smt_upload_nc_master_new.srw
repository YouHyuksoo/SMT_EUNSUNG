HA$PBExportHeader$w_smt_upload_nc_master_new.srw
$PBExportComments$$$HEX4$$ddc0b0c0c4ac8dd6$$ENDHEX$$
forward
global type w_smt_upload_nc_master_new from w_main_root
end type
type cb_1 from commandbutton within w_smt_upload_nc_master_new
end type
type sle_lot_name from so_singlelineedit within w_smt_upload_nc_master_new
end type
type mle_2 from so_multilineedit within w_smt_upload_nc_master_new
end type
type rb_pana from so_radiobutton within w_smt_upload_nc_master_new
end type
type dw_6 from so_datawindow within w_smt_upload_nc_master_new
end type
type cb_2 from commandbutton within w_smt_upload_nc_master_new
end type
type st_status from so_statictext within w_smt_upload_nc_master_new
end type
type dw_7 from so_datawindow within w_smt_upload_nc_master_new
end type
type dw_8 from so_datawindow within w_smt_upload_nc_master_new
end type
type dw_9 from so_datawindow within w_smt_upload_nc_master_new
end type
type dw_10 from so_datawindow within w_smt_upload_nc_master_new
end type
type dw_11 from so_datawindow within w_smt_upload_nc_master_new
end type
type dw_12 from so_datawindow within w_smt_upload_nc_master_new
end type
type rb_npm from so_radiobutton within w_smt_upload_nc_master_new
end type
type dw_13 from so_datawindow within w_smt_upload_nc_master_new
end type
type rb_pana_position from so_radiobutton within w_smt_upload_nc_master_new
end type
type cb_3 from commandbutton within w_smt_upload_nc_master_new
end type
type gb_1 from so_groupbox within w_smt_upload_nc_master_new
end type
type gb_3 from so_groupbox within w_smt_upload_nc_master_new
end type
end forward

global type w_smt_upload_nc_master_new from w_main_root
integer width = 6715
integer height = 2804
string title = "Plan Master"
windowstate windowstate = maximized!
cb_1 cb_1
sle_lot_name sle_lot_name
mle_2 mle_2
rb_pana rb_pana
dw_6 dw_6
cb_2 cb_2
st_status st_status
dw_7 dw_7
dw_8 dw_8
dw_9 dw_9
dw_10 dw_10
dw_11 dw_11
dw_12 dw_12
rb_npm rb_npm
dw_13 dw_13
rb_pana_position rb_pana_position
cb_3 cb_3
gb_1 gb_1
gb_3 gb_3
end type
global w_smt_upload_nc_master_new w_smt_upload_nc_master_new

type variables
string LVS_LINE_CODE , lvs_pcb_item  , lvs_master_model_name , lvs_smt_model_name , lvs_layout_model_name
end variables

forward prototypes
public function integer wf_panasonic ()
public function integer wf_samsung ()
public function integer wf_npm ()
public function integer wf_panasonic_block ()
end prototypes

public function integer wf_panasonic ();integer li_FileNum , li_eof , li_eof2 , lvi_loop
string is_filename , is_fullname , ls_text
string LVS_MACHINE_GROUP , LVS_START_TABLE_ID 
string lvs_n ,lvs_item_id , lvs_plan_date , lvs_lot_name , lvs_pa , lvs_pb , lvs_PartsLIB_yn = 'N'
string lvs_partname1 ,  lvs_chipname , lvs_chipname1 , lvs_partname2 , lvs_chipname2 , lvs_table  , lvs_address , lvs_location_infor1 , lvs_location_infor2
int i , row , lvi_item_unit_qty


//=========================================
//
//=========================================

st_status.text = "Delete ib_mnt_plandata" 

delete from ib_mnt_plandata ;

if sqlca.sqlcode < 0 then 
	MESSAGEBOX("ERROR" , SQLCA.SQLerrtext )
	rollback;
	return -1
end if 

//if GetFileOpenName ("Open", is_fullname, is_filename,   "txt", "Text Files (*.txt),*.txt,INI Files " + "(*.ini), *.ini,Batch Files (*.bat),*.bat",  "d:\temp") < 1 then return
lvi_loop = 0
do 
	lvi_loop ++
	is_fullname = string(dw_6.object.file_name[lvi_loop])
	LVS_MACHINE_GROUP =  dw_6.object.machine_group[lvi_loop]
	LVS_START_TABLE_ID=  dw_6.object.start_table_id[lvi_loop]
	
	if is_fullname  = '' or isnull(is_fullname) then 
		continue 
	end if 
	st_status.text = "File Open : "+is_fullname 
	
	
		li_FileNum = FileOpen (is_fullname, LineMode!)
		
		//=========================================
		//
		//=========================================
		st_status.text = "Delete ib_mnt_partslib"
		
		delete from ib_mnt_partslib ;
		if sqlca.sqlcode < 0 then 
			
			MESSAGEBOX("ERROR" , SQLCA.SQLerrtext )
			rollback;
			return -1
		end if 
		//=========================================
		//
		//=========================================
		st_status.text = "Delete ib_mnt_stockdata"
		delete from ib_mnt_stockdata ;
		if sqlca.sqlcode < 0 then 
			MESSAGEBOX("ERROR" , SQLCA.SQLerrtext )
			rollback;
			return -1
		end if 
		
		//=========================================
		//
		//=========================================
		st_status.text = "Delete ib_mnt_positiondata"
		delete from ib_mnt_positiondata ;
		if sqlca.sqlcode < 0 then 
			MESSAGEBOX("ERROR" , SQLCA.SQLerrtext )
			rollback;
			return -1
		end if 
		
		//=========================================
		//
		//=========================================
		st_status.text = "Delete ib_mnt_blockdata"
		delete from ib_mnt_blockdata ;
		if sqlca.sqlcode < 0 then 
			MESSAGEBOX("ERROR" , SQLCA.SQLerrtext )
			rollback;
			return -1
		end if 
		
		//=========================================
		//
		//=========================================
		
		do
			li_eof = FileReadEx (li_FileNum, ls_text ) 
		
		//===========================================================================
		// [LotNames]
		//===========================================================================
			if ls_text = '[LotNames]' then
				
				st_status.text ="[LotNames]"+" Extract"
				
				li_eof = FileReadEx (li_FileNum, ls_text )  //$$HEX6$$c0d074c7c0d2200009000900$$ENDHEX$$
				li_eof2 = FileReadEx (li_FileNum, ls_text )  //$$HEX6$$6fb8b8d270b374c7c0d02000$$ENDHEX$$
				
				lvs_lot_name = f_replace_string ( mid( ls_text , 1 , pos( ls_text , ' ') -1 ) , '"' , '')
				sle_lot_name.text =lvs_lot_name 
				
			end if 
		//===========================================================================
		// [BlockData]
		//===========================================================================
			if ls_text = '[BlockData]' then
				
				st_status.text ="[BlockData]"+" Extract"
				
				li_eof = FileReadEx (li_FileNum, ls_text )  //$$HEX4$$c0d074c7c0d22000$$ENDHEX$$
				
				li_eof2 = FileReadEx (li_FileNum, ls_text )
				
				do while ( mid(ls_text , 1 ,1) <> '[' and li_eof2 <> 0 )
		
					mle_2.text = mle_2.text + ls_text+"~r~n"
					
					dw_10.importstring( f_replace_string( ls_text ,' ' , '~t' ) +"~t"+string(today() ,'yyyymmdd')+"~t"+lvs_lot_name )
					li_eof2 = FileReadEx (li_FileNum, ls_text )	
				loop  ;
				
			end if 
		//===========================================================================
		// [ib_mnt_positiondata]
		//===========================================================================
			
			if ls_text = '[PartsLIB]' then
				
				lvs_PartsLIB_yn = 'Y'
				
				st_status.text ="[PartsLIB]"+" Extract"
				
				li_eof = FileReadEx (li_FileNum, ls_text )  //$$HEX4$$c0d074c7c0d22000$$ENDHEX$$
				
				li_eof2 = FileReadEx (li_FileNum, ls_text )
				
				do while ( mid(ls_text , 1 ,1) <> '[' and li_eof2 <> 0 )
		
					mle_2.text = mle_2.text + ls_text+"~r~n"
					
					dw_7.importstring( f_replace_string( ls_text ,' ' , '~t' ) +"~t"+string(today() ,'yyyymmdd')+"~t"+lvs_lot_name )
					li_eof2 = FileReadEx (li_FileNum, ls_text )	
				loop  ;
				
				
				
				
			end if 
//======================================================
//
//======================================================
		  if ls_text = '[PartsData]' AND lvs_PartsLIB_yn = 'N' then
				
				
				st_status.text ="[PartsData]"+" Extract"
				
				
				li_eof = FileReadEx (li_FileNum, ls_text )  //$$HEX4$$c0d074c7c0d22000$$ENDHEX$$
				
				li_eof2 = FileReadEx (li_FileNum, ls_text )
				
				do while ( mid(ls_text , 1 ,1) <> '[' and li_eof2 <> 0 )
		
					mle_2.text = mle_2.text + ls_text+"~r~n"
					
					dw_7.importstring( f_replace_string( ls_text ,' ' , '~t' ) +"~t"+string(today() ,'yyyymmdd')+"~t"+lvs_lot_name )
					li_eof2 = FileReadEx (li_FileNum, ls_text )	
				loop  ;
				
			end if 		
		

		//==========================================================================
		//
		//==========================================================================
		
			if ls_text = '[PositionData]' then
				st_status.text ="[PositionData]"+" Extract"
				
				li_eof  = FileReadEx (li_FileNum, ls_text )  //$$HEX6$$c0d074c7c0d2200009000900$$ENDHEX$$
				li_eof2 = FileReadEx (li_FileNum, ls_text )
					
				do while ( mid(ls_text , 1 ,1) <> '[' and  li_eof2<> 0 )
					mle_2.text = mle_2.text + ls_text+"~r~n"
				//	dw_13.importstring( f_replace_string( ls_text ,' ' , '~t' )+"~t"+string(today(),'yyyymmdd hhmmss')+"~t"+lvs_lot_name )
					dw_13.importstring( f_replace_string( ls_text ,' ' , '~t' )+"~t"+lvs_lot_name )
					li_eof2 = FileReadEx (li_FileNum, ls_text )			
				loop ;
			end if 
				


		//==========================================================================
		//
		//==========================================================================
		
			if ls_text = '[StockData]' then
				st_status.text ="[StockData]"+" Extract"
				
				li_eof  = FileReadEx (li_FileNum, ls_text )  //$$HEX6$$c0d074c7c0d2200009000900$$ENDHEX$$
				li_eof2 = FileReadEx (li_FileNum, ls_text )
					
				do while ( mid(ls_text , 1 ,1) <> '[' and  li_eof2<> 0 )
					mle_2.text = mle_2.text + ls_text+"~r~n"
					dw_8.importstring( f_replace_string( ls_text ,' ' , '~t' )+"~t"+string(today(),'yyyymmdd hhmmss')+"~t"+lvs_lot_name )
					li_eof2 = FileReadEx (li_FileNum, ls_text )			
				loop ;
			end if 
				
		loop until li_eof = -100
		
		//===========================================================================
		//
		//===========================================================================
		FileClose (li_FileNum)  
		
		//===========================================================================
		//
		//===========================================================================
		if dw_7.update()  < 0 then 
			st_status.text ="Update dw_7"
			return -1 
		end if 
		if dw_8.update() < 0 then 
			st_status.text ="Update dw_8"
			return -1 
		end if 

		if dw_10.update() < 0 then 
			st_status.text ="Update dw_10"
			return -1 
		end if 
		
		if dw_13.update() < 0 then 
			st_status.text ="Update dw_13 Position Data"
			return -1 
		end if 
		
		
		commit ;
		
		//===================================================
		//
		//===================================================

			
		declare cl_stock cursor for 
		select n  , pa , pb , plan_date , lot_name from ib_mnt_stockdata order by idnum ;
		
		open cl_stock ;
		
		do
			 lvs_n = ''
			 lvs_pa  = '' 
			 lvs_pb = '' 
			 lvs_plan_date = ''
			 lvs_lot_name = ''
			 
			fetch cl_stock into :lvs_n ,:lvs_pa , :lvs_pb ,  :lvs_plan_date , :lvs_lot_name;
			
			if sqlca.sqlcode < 0 then
				close cl_stock ;
				rollback ;
				exit
			end if 
			
			if sqlca.sqlcode = 100 then 
				close cl_stock ;
				exit
			end if 
			
			i++
			IF LEN(lvs_n) =5 THEN 
				
				
				IF mid(lvs_n , 3 ,1 ) <> '0' THEN 
					
					lvs_table = 'Z' 
					lvs_address =  'TRAY'+RIGHT(lvs_n , 1 )
					
				ELSE
				
					 select  chr( ascii(:LVS_START_TABLE_ID) +  to_number( substr(:lvs_n , 1 ,1) ) -1  )
					 into :lvs_table
					 from dual ;
				 	 lvs_address = string(INTEGER(mid(lvs_n , 3 ,3 )) , '00')
				END IF 
		
			ELSE
				
							
				IF mid(lvs_n , 4 ,1 ) <> '0' THEN 
					
					lvs_table = 'Z' 
					Lvs_address =  'TRAY'+RIGHT(lvs_n , 1 )
					
				ELSE	
				
					select  chr( ascii(:LVS_START_TABLE_ID) +  to_number( substr(:lvs_n , 1 ,2) ) -1  )
					   into :lvs_table
					  from dual ;
				 	lvs_address = string(INTEGER(mid(lvs_n , 4 ,3 )) , '00')
				 END IF 
		
			END IF
			
			if lvs_pa <> '0' and lvs_pb <> '0' then  //$$HEX3$$91c5bdca2000$$ENDHEX$$
			
			  //==============================================
			  //
			  //==============================================	
				
				select  substr(  partsname  , 1 ,  decode (  instr( partsname , '-' , 7 , 1 ) , 0  , length( partsname) ,  instr( partsname , '-' , 7 , 1 ) -1   ) ) , chipname 
				into   :lvs_partname1  , :lvs_chipname1
				from ib_mnt_partslib
				where idnum = :lvs_pa	  ;
				 
				 
				 lvi_item_unit_qty = 0 ;
				 
				SELECT listagg(c, ',' ) within GROUP(ORDER BY c)   , count(*)
				into :lvs_location_infor1  		 , :lvi_item_unit_qty
				from ib_mnt_positiondata
	//			from ib_mnt_blockdata
				where parts = :lvs_pa
				   and pu = :lvs_n ;
				
		
				row = dw_1.insertrow(0)
				dw_1.object.plan_date[row] = lvs_plan_date
				dw_1.object.lot_name[row] = lvs_lot_name
				dw_1.object.table_id[row] = lvs_table
				dw_1.object.address[row] = lvs_address
				dw_1.object.position[row] = 'L'
				dw_1.object.partname[row] = lvs_partname1
				dw_1.object.chipname[row] = lvs_chipname1
				dw_1.object.location_info[row] = lvs_location_infor1		
				dw_1.object.line_code[row] = lvs_line_code
				dw_1.object.model_name[row] =LVS_LAYOUT_MODEL_NAME //lvs_model_name
				dw_1.object.pcb_item[row] = lvs_pcb_item
				dw_1.object.machine_group[row] = lvs_machine_group+" B:"+lvs_pa
				dw_1.object.item_unit_qty[row] = lvi_item_unit_qty
				
				dw_1.object.machine_code[row] = lvs_line_code+  string( integer(lvs_machine_group) , '00') 
				
			  //==============================================
			  //
			  //==============================================
				select   substr(  partsname  , 1 ,  decode (  instr( partsname , '-' , 7 , 1 ) , 0  , length( partsname) ,  instr( partsname , '-' , 7 , 1 ) -1   ) ) , chipname 
				 into :lvs_partname2   	, :lvs_chipname2	
				from ib_mnt_partslib
				where idnum = :lvs_pb ;	
				
				
				
				lvi_item_unit_qty = 0 ;
				SELECT listagg(c, ',' ) within GROUP(ORDER BY c)   , count(* )
				into   :lvs_location_infor2		 , :lvi_item_unit_qty
				from ib_mnt_positiondata
	//			from ib_mnt_blockdata
				where parts =:lvs_pb 
				  and pu = :lvs_n ;
				
				row = dw_1.insertrow(0)
				dw_1.object.plan_date[row] = lvs_plan_date
				dw_1.object.lot_name[row] = lvs_lot_name
				dw_1.object.table_id[row] = lvs_table
				dw_1.object.address[row] = lvs_address
				dw_1.object.position[row] = 'R'
				dw_1.object.partname[row] = lvs_partname2
				dw_1.object.chipname[row] = lvs_chipname2
				dw_1.object.location_info[row] = lvs_location_infor2		
					dw_1.object.line_code[row] = lvs_line_code
				dw_1.object.model_name[row] = LVS_LAYOUT_MODEL_NAME //lvs_model_name
				dw_1.object.pcb_item[row] = lvs_pcb_item	
				dw_1.object.machine_group[row] = lvs_machine_group+" B:"+lvs_pb
				dw_1.object.item_unit_qty[row] = lvi_item_unit_qty
				dw_1.object.machine_code[row] = lvs_line_code+  string( integer(lvs_machine_group) , '00') 
				
			elseif lvs_pa <> '0' and lvs_pb = '0' then  //$$HEX3$$7cc6bdca2000$$ENDHEX$$
				
				select  substr(  partsname  , 1 ,  decode (  instr( partsname , '-' , 7 , 1 ) , 0  , length( partsname) , instr( partsname , '-' , 7 , 1 ) -1   ) ) , chipname
				into :lvs_partname1   		, :lvs_chipname1
				from ib_mnt_partslib
				where idnum = :lvs_pa	  ;	
				

				lvi_item_unit_qty = 0 ;
				SELECT listagg(c, ',' ) within GROUP(ORDER BY c)   , count( * )
				into   :lvs_location_infor1  		 , :lvi_item_unit_qty
				from ib_mnt_positiondata
				//			from ib_mnt_blockdata
				where parts = :lvs_pa 
				  and pu = :lvs_n ;
				 
				
				row = dw_1.insertrow(0)
				dw_1.object.plan_date[row] = lvs_plan_date
				dw_1.object.lot_name[row] = lvs_lot_name
				dw_1.object.table_id[row] = lvs_table
				dw_1.object.address[row] = lvs_address
				dw_1.object.position[row] = 'L'	
				dw_1.object.partname[row] = lvs_partname1
				dw_1.object.chipname[row] = lvs_chipname1
				dw_1.object.location_info[row] = lvs_location_infor1		
				dw_1.object.line_code[row] = lvs_line_code
				dw_1.object.model_name[row] =LVS_LAYOUT_MODEL_NAME //lvs_model_name
				dw_1.object.pcb_item[row] = lvs_pcb_item
				dw_1.object.machine_group[row] = lvs_machine_group+" L:"+lvs_pa
				dw_1.object.item_unit_qty[row] = lvi_item_unit_qty
				dw_1.object.machine_code[row] = lvs_line_code+  string( integer(lvs_machine_group) , '00') 
				
			elseif lvs_pa = '0' and lvs_pb <> '0' then  //$$HEX4$$24c678b9bdca2000$$ENDHEX$$
				
				select   substr(  partsname  , 1 ,  decode (  instr( partsname , '-' , 7 , 1 ) , 0  , length( partsname) ,  instr( partsname , '-' , 7 , 1 ) -1   ) ) , chipname 
				into :lvs_partname2   		, :lvs_chipname2
				from ib_mnt_partslib
				where idnum = :lvs_pb	  ;
				
				
				
				lvi_item_unit_qty = 0 ;
				SELECT listagg(c, ',' ) within GROUP(ORDER BY c)   , count(* )
				into   :lvs_location_infor2 , :lvi_item_unit_qty
				from ib_mnt_positiondata
				//			from ib_mnt_blockdata
				where parts = :lvs_pb 
				  and pu = :lvs_n ;
				 
				
				row = dw_1.insertrow(0)
				dw_1.object.plan_date[row] = lvs_plan_date
				dw_1.object.lot_name[row] = lvs_lot_name
				dw_1.object.table_id[row] = lvs_table
				dw_1.object.address[row] = lvs_address
				dw_1.object.position[row] = 'R'	
				dw_1.object.partname[row] = lvs_partname2
				dw_1.object.chipname[row] = lvs_chipname2
				dw_1.object.location_info[row] = lvs_location_infor2	
				dw_1.object.line_code[row] = lvs_line_code
				dw_1.object.model_name[row] =LVS_LAYOUT_MODEL_NAME //lvs_model_name
				dw_1.object.pcb_item[row] = lvs_pcb_item
				dw_1.object.machine_group[row] = lvs_machine_group+" R:"+lvs_pb
				dw_1.object.item_unit_qty[row] = lvi_item_unit_qty
				dw_1.object.machine_code[row] = lvs_line_code+  string( integer(lvs_machine_group) , '00') 
				
			end if 
		
		loop until 1 =2 
		
		if dw_1.update() < 0 then 
			
			st_status.text ="Update dw_1"
			Rollback;
			
		else
			commit ;
			st_status.text ="Update OK"
		end if 
		dw_1.sort( )
		
loop until lvi_loop  = dw_6.rowcount( )
FileClose (li_FileNum)  
return 1
end function

public function integer wf_samsung ();integer li_FileNum , li_eof , li_eof2 , lvi_loop
string is_filename , is_fullname , ls_text  , lvs_feeder_type 
String  LVS_MACHINE_GROUP , LVS_START_TABLE_ID  , lvs_plan_date , lvs_lot_name  , lvs_chipname , lvs_table  , lvs_address , lvs_location_infor
int i , row , lvi_item_unit_qty
		
string lvs_no,lvs_REF , lvs_fdr , lvs_partname ;

//=========================================
//
//=========================================
delete from ib_mnt_plandata ;
if sqlca.sqlcode < 0 then 
	MESSAGEBOX("ERROR" , SQLCA.SQLerrtext )
	rollback;
	return -1
end if 

lvi_loop = 0
//=============================================
//
//=============================================
do 
	lvi_loop ++
	
	mle_2.text = mle_2.text +'~r~n'+string(lvi_loop)
	
	LVS_MACHINE_GROUP = ''
	LVS_START_TABLE_ID = ''
	lvs_plan_date = ''
	lvs_lot_name  = ''
	lvs_chipname = ''
	lvs_table  = ''
	lvs_address = '' 
	lvs_location_infor = ''
	
	is_fullname = string( dw_6.object.file_name[lvi_loop] )
	LVS_MACHINE_GROUP =  dw_6.object.machine_group[lvi_loop]
	LVS_START_TABLE_ID=  dw_6.object.start_table_id[lvi_loop]
	if is_fullname  = '' or isnull(is_fullname) then 
		continue 
	end if 
	
	//=========================================
	//
	//=========================================
	delete from ib_mnt_step_infor ;
	if sqlca.sqlcode < 0 then 
		
		MESSAGEBOX("ERROR" , SQLCA.SQLerrtext )
		rollback;
		return -1
	end if 	
	
	//=========================================
	//
	//=========================================
	delete from ib_mnt_part_information ;
	if sqlca.sqlcode < 0 then 
		MESSAGEBOX("ERROR" , SQLCA.SQLerrtext )
		rollback;
		return -1
	end if 	
	
	
		li_FileNum = FileOpen (is_fullname, LineMode!)

		//=========================================
		//
		//=========================================

		do
			li_eof = FileReadEx (li_FileNum, ls_text ) 
		
		//===========================================================================
		// [LotNames]
		//===========================================================================
			if ls_text = '[Board Information]' then
				
				li_eof = FileReadEx (li_FileNum, ls_text )  //Customer:	LG
				li_eof2 = FileReadEx (li_FileNum, ls_text )  //Board:	5$$HEX5$$7cb778c7200009000900$$ENDHEX$$
				
				lvs_lot_name =  trim(MID (  ls_text  , 7 , 100 ))	
				sle_lot_name.text =lvs_lot_name 
				
			end if 
			
			
		//===========================================================================
		// [BlockData]
		//===========================================================================
			if ls_text = '[Part Information]' then
				
				li_eof = FileReadEx (li_FileNum, ls_text )  //$$HEX4$$c0d074c7c0d22000$$ENDHEX$$
				
				li_eof2 = FileReadEx (li_FileNum, ls_text )
				
				do while ( mid(ls_text , 1 ,1) <> '[' and li_eof2 <> 0 )
		
					mle_2.text = mle_2.text + ls_text+"~r~n"		
					dw_11.importstring( f_replace_string( ls_text ,' ' , '~t' ) +"~t"+string(today() ,'yyyymmdd')+"~t"+lvs_lot_name )
					li_eof2 = FileReadEx (li_FileNum, ls_text )	
				loop  ;
				
			end if 	
			
		//===========================================================================
		// [Step Information]
		//===========================================================================
			if ls_text = '[Step Information]' then
				
				li_eof = FileReadEx (li_FileNum, ls_text )  //$$HEX3$$f5ac31bc2000$$ENDHEX$$
				li_eof = FileReadEx (li_FileNum, ls_text )  //Station: 	ST1F-Work
				li_eof = FileReadEx (li_FileNum, ls_text )  //$$HEX3$$f5ac31bc2000$$ENDHEX$$
				
				li_eof = FileReadEx (li_FileNum, ls_text )  //$$HEX4$$c0d074c7c0d22000$$ENDHEX$$
				li_eof2 = FileReadEx (li_FileNum, ls_text )
				
				//do while ( mid(ls_text , 1 ,1) <> '[' and li_eof2 <> 0 )
			    do while ( mid(ls_text , 1 ,1) <> '['  )	
					
				//	mle_2.text = mle_2.text + ls_text+"~r~n"
					if ls_text = '' or  mid( ls_text , 1,7) = 'Station'  or mid( ls_text , 1,2) =  'No' then 
						
						st_status.text = ls_text
					
					else
						dw_9.importstring( f_replace_string( ls_text ,' ' , '~t' ) +"~t"+string(today() ,'yyyymmdd')+"~t"+is_fullname )
					end if 
					li_eof2 = FileReadEx (li_FileNum, ls_text )	
					
					st_status.text = Mid (  ls_text , 1, 100) 
				loop  ;
				
			end if 
				
		loop until li_eof = -100
		
		//===========================================================================
		//
		//===========================================================================
		FileClose (li_FileNum)  
		
		//===========================================================================
		//
		//===========================================================================

		if dw_9.update() < 0 then 
			return -1 
		end if 

		commit ;
		
		//===================================================
		//
		//===================================================

	   declare cl_step cursor for 
		 select fdr ,  
		 
		          substr(  partname  , 1 ,  decode (  instr( partname , '-' , 7 , 1 ) , 0  , length( partname) ,  instr( partname , '-' , 7 , 1 ) -1   ) ) partname_sub ,
//		          replace(substr( partname ,1, 13 ) , '-','')   partname_sub , 
					 
		          max(partname)
		  from ib_mnt_step_infor 
		 group by substr(  partname  , 1 ,  decode (  instr( partname , '-' , 7 , 1 ) , 0  , length( partname) ,  instr( partname , '-' , 7 , 1 ) -1   ) ), fdr ;
		   //replace(substr( partname ,1, 13 ) , '-','')  , fdr ;
		
		open cl_step ;
		
		do
			fetch cl_step into  :lvs_fdr , :lvs_partname , :lvs_chipname;
			
			if sqlca.sqlcode < 0 then
				close cl_step ;
				rollback ;
				exit
			end if 
			
			if sqlca.sqlcode = 100 then 
				close cl_step ;
				exit
			end if 
			
			i++
			//==================================
			// 3$$HEX15$$90c7acb974ba200004d560b8b8d22000acb9b4c5ccb9200088c794b22000$$ENDHEX$$2 $$HEX5$$1cac4cd174c714be2000$$ENDHEX$$
			//==================================
			IF LEN(lvs_fdr) <= 3 THEN 
				
				IF mid(lvs_fdr , 1 ,1 )  = 'F' THEN 
					
				  select  chr( ascii(:LVS_START_TABLE_ID)  )
					 into :lvs_table
					 from dual ;
					 
					lvs_address =  TRIM(  STRING( INTEGER(MID(lvs_fdr , 2  , 2 )) , '00'))
					
				END IF 
		
				IF mid(lvs_fdr , 1 ,1 )  = 'R' THEN 
					
				   select  chr( ascii(:LVS_START_TABLE_ID) +  1 )
					 into :lvs_table
					 from dual ;
					lvs_address =  TRIM(  STRING( INTEGER(MID(lvs_fdr , 2  , 2 )) , '00'))
					
				END IF 		
		
			ELSE

				IF mid(lvs_fdr , 1 ,2 )  = '1F' THEN 
					
				  select  chr( ascii(:LVS_START_TABLE_ID)  )
					 into :lvs_table
					 from dual ;
					lvs_address =  TRIM(  STRING( INTEGER(MID(lvs_fdr , 4  , 2 )) , '00'))
					
				ELSEIF mid(lvs_fdr , 1 ,2 )  = '1R' THEN 
					
					  select  chr( ascii(:LVS_START_TABLE_ID) +  1 )
					 into :lvs_table
					 from dual ;
					lvs_address =  TRIM(  STRING( INTEGER(MID(lvs_fdr , 4  , 2 )) , '00'))
					
				ELSEIF mid(lvs_fdr , 1 ,2 )  = '2F' THEN 
					
					  select  chr( ascii(:LVS_START_TABLE_ID) +  2 )
					 into :lvs_table
					 from dual ;
					lvs_address =  TRIM(  STRING( INTEGER(MID(lvs_fdr , 4  , 2 )) , '00'))
					
				ELSEIF mid(lvs_fdr , 1 ,2 )  = '2R' THEN 
					
					  select  chr( ascii(:LVS_START_TABLE_ID) +  3 )
					 into :lvs_table
					 from dual ;
					lvs_address =  TRIM(  STRING( INTEGER(MID(lvs_fdr , 4  , 2 )) , '00'))
					
				ELSEIF mid(lvs_fdr , 1 ,1 )  = 'T' THEN 					
					
					 lvs_table = 'Z' 
					 lvs_address =  'TRAY'+TRIM(  STRING( INTEGER(MID(lvs_fdr , 4  , 1 )) , '00'))
				END IF 			
		
			END IF
				
				SELECT listagg(REF, ',' ) within GROUP(ORDER BY REF)   , count(DISTINCT REF)
				  into   :lvs_location_infor , :lvi_item_unit_qty
				from ( select ref , replace(substr( partname ,1, 13 ) , '-','') partname 
						  from ib_mnt_step_infor 
						  where replace(substr( partname ,1, 13 ) , '-','') = :lvs_partname 
						      and fdr = :lvs_fdr
						 group by ref , replace(substr( partname ,1, 13 ) , '-','') ) 
				where replace(substr( partname ,1, 13 ) , '-','') = :lvs_partname  ;		
				
				
				
				select distinct feeder 
				   into :lvs_feeder_type 
				  from ib_mnt_part_information where  partname = :lvs_partname ;
				 


				row = dw_1.insertrow(0)
				dw_1.object.plan_date[row] = lvs_plan_date
				dw_1.object.lot_name[row] = lvs_lot_name
				dw_1.object.table_id[row] = lvs_table
				dw_1.object.address[row] = lvs_address
				dw_1.object.position[row] = ''	
				dw_1.object.partname[row] = lvs_partname
				dw_1.object.chipname[row] = lvs_chipname
				dw_1.object.location_info[row] = lvs_location_infor		
				dw_1.object.feeder_type[row] = lvs_feeder_type		
				
				dw_1.object.line_code[row] = lvs_line_code
				dw_1.object.model_name[row] =LVS_LAYOUT_MODEL_NAME // lvs_model_name
				dw_1.object.pcb_item[row] = lvs_pcb_item
				dw_1.object.machine_group[row] = lvs_machine_group
				
				dw_1.object.item_unit_qty[row] = lvi_item_unit_qty
				dw_1.object.machine_code[row] = lvs_line_code+  string( integer(lvs_machine_group) , '00') 
				
		
		loop until 1 =2 
		
		if dw_1.update() < 0 then 
		else
			commit ;
		end if 
		dw_1.sort( )
		
loop until lvi_loop  = dw_6.rowcount( )
FileClose (li_FileNum)  
return 1
end function

public function integer wf_npm ();integer li_FileNum , li_eof , li_eof2 , lvi_loop
string is_filename , is_fullname , ls_text
string LVS_MACHINE_GROUP , LVS_START_TABLE_ID 

string lvs_n ,lvs_item_id , lvs_plan_date , lvs_lot_name , lvs_pa , lvs_pb
string lvs_partname1 ,  lvs_chipname , lvs_chipname1 , lvs_partname2 , lvs_chipname2 , lvs_table  , lvs_address , lvs_location_infor1 , lvs_location_infor2
int i , row , lvi_item_unit_qty

//=========================================
//
//=========================================
delete from ib_mnt_plandata ;
if sqlca.sqlcode < 0 then 
	MESSAGEBOX("ERROR" , SQLCA.SQLerrtext )
	rollback;
	return -1
end if 

//if GetFileOpenName ("Open", is_fullname, is_filename,   "txt", "Text Files (*.txt),*.txt,INI Files " + "(*.ini), *.ini,Batch Files (*.bat),*.bat",  "d:\temp") < 1 then return
lvi_loop = 0
do 
	lvi_loop ++
	is_fullname = string(dw_6.object.file_name[lvi_loop])
	LVS_MACHINE_GROUP =  dw_6.object.machine_group[lvi_loop]
	LVS_START_TABLE_ID=  dw_6.object.start_table_id[lvi_loop]
	
	if is_fullname  = '' or isnull(is_fullname) then 
		continue 
	end if 
	
		li_FileNum = FileOpen (is_fullname, LineMode!)
		
		//=========================================
		//
		//=========================================
		delete from ib_mnt_partslib ;
		if sqlca.sqlcode < 0 then 
			
			MESSAGEBOX("ERROR" , SQLCA.SQLerrtext )
			rollback;
			return -1
		end if 
		//=========================================
		//
		//=========================================
		delete from ib_mnt_stockdata ;
		if sqlca.sqlcode < 0 then 
			MESSAGEBOX("ERROR" , SQLCA.SQLerrtext )
			rollback;
			return -1
		end if 
		
		//=========================================
		//
		//=========================================
		delete from ib_mnt_positiondata_npm ;
		if sqlca.sqlcode < 0 then 
			MESSAGEBOX("ERROR" , SQLCA.SQLerrtext )
			rollback;
			return -1
		end if 
	
		//=========================================
		//
		//=========================================
		
		do
			li_eof = FileReadEx (li_FileNum, ls_text ) 
		
		//===========================================================================
		// [LotNames]
		//===========================================================================
			if ls_text = '[LotNames]' then
				st_status.text ="[LotNames]"+" Extract"
				li_eof = FileReadEx (li_FileNum, ls_text )  //$$HEX6$$c0d074c7c0d2200009000900$$ENDHEX$$
				li_eof2 = FileReadEx (li_FileNum, ls_text )  //$$HEX6$$6fb8b8d270b374c7c0d02000$$ENDHEX$$
				
				lvs_lot_name = f_replace_string ( mid( ls_text , 1 , pos( ls_text , ' ') -1 ) , '"' , '')
				sle_lot_name.text =lvs_lot_name 
				
			end if 

		//===========================================================================
		// [ib_mnt_positiondata] npm $$HEX8$$78c7bdacb0c6ccb92000acc0a9c62000$$ENDHEX$$
		//===========================================================================
			
			if ls_text = '[PositionData<1>]' then
				st_status.text ="[PositionData<1>]"+" Extract"
				li_eof  = FileReadEx (li_FileNum, ls_text )  //$$HEX6$$c0d074c7c0d2200009000900$$ENDHEX$$
				li_eof2 = FileReadEx (li_FileNum, ls_text )
					
				do while ( mid(ls_text , 1 ,1) <> '[' and  li_eof2<> 0 )
					mle_2.text = mle_2.text + ls_text+"~r~n"
					dw_12.importstring( f_replace_string( ls_text ,' ' , '~t' )+"~t"+string(today(),'yyyymmdd')+"~t"+lvs_lot_name )
					li_eof2 = FileReadEx (li_FileNum, ls_text )			
				loop ;
				
			end if 
			
			if ls_text = '[PositionData<2>]' then
				st_status.text ="[PositionData<2>]"+" Extract"
				li_eof  = FileReadEx (li_FileNum, ls_text )  //$$HEX6$$c0d074c7c0d2200009000900$$ENDHEX$$
				li_eof2 = FileReadEx (li_FileNum, ls_text )
					
				do while ( mid(ls_text , 1 ,1) <> '[' and  li_eof2<> 0 )
					mle_2.text = mle_2.text + ls_text+"~r~n"
					dw_12.importstring( f_replace_string( ls_text ,' ' , '~t' )+"~t"+string(today(),'yyyymmdd')+"~t"+lvs_lot_name )
					li_eof2 = FileReadEx (li_FileNum, ls_text )			
				loop ;
				
			end if 			
		//==========================================================================
		//
		//==========================================================================
		
			if ls_text = '[StockData]' then
				st_status.text ="[StockData]"+" Extract"
				li_eof  = FileReadEx (li_FileNum, ls_text )  //$$HEX6$$c0d074c7c0d2200009000900$$ENDHEX$$
				li_eof2 = FileReadEx (li_FileNum, ls_text )
					
				do while ( mid(ls_text , 1 ,1) <> '[' and  li_eof2<> 0 )
					mle_2.text = mle_2.text + ls_text+"~r~n"
					dw_8.importstring( f_replace_string( ls_text ,' ' , '~t' )+"~t"+string(today(),'yyyymmdd hhmmss')+"~t"+lvs_lot_name )
					li_eof2 = FileReadEx (li_FileNum, ls_text )			
				loop ;
			end if 			
			
			
		     if ls_text = '[PartsData]' then
				st_status.text ="[PartsData]"+" Extract"
				li_eof = FileReadEx (li_FileNum, ls_text )  //$$HEX4$$c0d074c7c0d22000$$ENDHEX$$
				
				li_eof2 = FileReadEx (li_FileNum, ls_text )
				
				do while ( mid(ls_text , 1 ,1) <> '[' and li_eof2 <> 0 )
		
					mle_2.text = mle_2.text + ls_text+"~r~n"
					
					dw_7.importstring( f_replace_string( ls_text ,' ' , '~t' ) +"~t"+string(today() ,'yyyymmdd')+"~t"+lvs_lot_name )
					li_eof2 = FileReadEx (li_FileNum, ls_text )	
				loop  ;
				
			end if 		
			
		loop until li_eof = -100
		
		//===========================================================================
		//
		//===========================================================================
		FileClose (li_FileNum)  
		
		//===========================================================================
		//
		//===========================================================================
		if dw_7.update()  < 0 then 
			st_status.text ="Update dw_7"
			return -1 
		end if 
		if dw_8.update() < 0 then 
			st_status.text ="Update dw_8"
			return -1 
		end if 

		if dw_10.update() < 0 then 
			st_status.text ="Update dw_10"
			return -1 
		end if 
	
		if dw_12.update() < 0 then 
			st_status.text ="Update dw_12"
			return -1 
		end if 	
	
		commit ;
		
		//===================================================
		//
		//===================================================

			
		declare cl_stock cursor for 
		select n  , pa , pb , plan_date , lot_name from ib_mnt_stockdata order by idnum ;
		
		open cl_stock ;
		
		do
			lvs_n = ''
			lvs_pa = ''
			lvs_pb = ''
			lvs_plan_date = '' 
			lvs_lot_name = ''
			
			fetch cl_stock into :lvs_n ,:lvs_pa , :lvs_pb ,  :lvs_plan_date , :lvs_lot_name;
			
			if sqlca.sqlcode < 0 then
				close cl_stock ;
				rollback ;
				exit
			end if 
			
			if sqlca.sqlcode = 100 then 
				close cl_stock ;
				exit
			end if 
		
			
			i++
			IF LEN(lvs_n) =5 THEN 
				
				
				IF mid(lvs_n , 3 ,1 ) <> '0' THEN 
					
					lvs_table = 'Z' 
					lvs_address =  'TRAY'+RIGHT(lvs_n , 1 )
					
				ELSE
				
					 select  chr( ascii(:LVS_START_TABLE_ID) +  to_number( substr(:lvs_n , 1 ,1) ) -1  )
					    into :lvs_table
					   from dual ;
				 	 lvs_address = string(INTEGER(mid(lvs_n , 3 ,3 )) , '00')
				END IF 
		
			ELSE
				
							
				IF mid(lvs_n , 4 ,1 ) <> '0' THEN 
					
					lvs_table = 'Z' 
					Lvs_address =  'TRAY'+RIGHT(lvs_n , 1 )
					
				ELSE	
				
					select  chr( ascii(:LVS_START_TABLE_ID) +  to_number( substr(:lvs_n , 1 ,2) ) -1  )
					 into :lvs_table
					 from dual ;
				 	lvs_address = string(INTEGER(mid(lvs_n , 4 ,3 )) , '00')
				 END IF 
		
			END IF
			
			if lvs_pa <> '0' and lvs_pb <> '0' then  //$$HEX3$$91c5bdca2000$$ENDHEX$$
			
			  //==============================================
			  //
			  //==============================================	
				
				select  substr(  partsname  , 1 ,  decode (  instr( partsname , '-' , 7 , 1 ) , 0  , length( partsname) ,  instr( partsname , '-' , 7 , 1 ) -1   ) ) , chipname 
				into   :lvs_partname1  , :lvs_chipname1
				from ib_mnt_partslib
				where idnum = :lvs_pa	  ;
				 
			 
				lvi_item_unit_qty = 0 ;
				lvs_location_infor1 = '';
				
				SELECT listagg(c, ',' ) within GROUP(ORDER BY c)   , count(*)
				into :lvs_location_infor1  		 , :lvi_item_unit_qty
				from ib_mnt_positiondata_npm
				where parts = :lvs_pa 
				   and pu = :lvs_n
			      ;

				row = dw_1.insertrow(0)
				dw_1.object.plan_date[row] = lvs_plan_date
				dw_1.object.lot_name[row] = lvs_lot_name
				dw_1.object.table_id[row] = lvs_table
				dw_1.object.address[row] = lvs_address
				dw_1.object.position[row] = 'L'
				dw_1.object.partname[row] = lvs_partname1
				dw_1.object.chipname[row] = lvs_chipname1
				dw_1.object.location_info[row] = lvs_location_infor1		
				dw_1.object.line_code[row] = lvs_line_code
				dw_1.object.model_name[row] = LVS_LAYOUT_MODEL_NAME //lvs_model_name
				dw_1.object.pcb_item[row] = lvs_pcb_item
				dw_1.object.machine_group[row] = lvs_machine_group
				dw_1.object.item_unit_qty[row] = lvi_item_unit_qty
				
				dw_1.object.machine_code[row] = lvs_line_code+  string( integer(lvs_machine_group) , '00') 
				
			  //==============================================
			  //
			  //==============================================
				select   substr(  partsname  , 1 ,  decode (  instr( partsname , '-' , 7 , 1 ) , 0  , length( partsname) ,  instr( partsname , '-' , 7 , 1 ) -1   ) ) , chipname 
				 into :lvs_partname2   	, :lvs_chipname2	
				from ib_mnt_partslib
				where idnum = :lvs_pb ;	
				
	
//				SELECT listagg(c, ',' ) within GROUP(ORDER BY c)   , count(*)
//				into   :lvs_location_infor2		 , :lvi_item_unit_qty
//				from ib_mnt_blockdata 
//				where parts =:lvs_pb ;

				lvi_item_unit_qty = 0 ;
				lvs_location_infor2 = '';
				
				SELECT listagg(c, ',' ) within GROUP(ORDER BY c)   , count(*)
				into :lvs_location_infor2  		 , :lvi_item_unit_qty
				from ib_mnt_positiondata_npm
				where parts = :lvs_pb
				   and pu = :lvs_n ;
				
				row = dw_1.insertrow(0)
				dw_1.object.plan_date[row] = lvs_plan_date
				dw_1.object.lot_name[row] = lvs_lot_name
				dw_1.object.table_id[row] = lvs_table
				dw_1.object.address[row] = lvs_address
				dw_1.object.position[row] = 'R'
				dw_1.object.partname[row] = lvs_partname2
				dw_1.object.chipname[row] = lvs_chipname2
				dw_1.object.location_info[row] = lvs_location_infor2		
				dw_1.object.line_code[row] = lvs_line_code
				dw_1.object.model_name[row] = LVS_LAYOUT_MODEL_NAME   //lvs_model_name
				dw_1.object.pcb_item[row] = lvs_pcb_item	
				dw_1.object.machine_group[row] = lvs_machine_group
				dw_1.object.item_unit_qty[row] = lvi_item_unit_qty
				dw_1.object.machine_code[row] = lvs_line_code+  string( integer(lvs_machine_group) , '00') 
				
			elseif lvs_pa <> '0' and lvs_pb = '0' then  //$$HEX3$$7cc6bdca2000$$ENDHEX$$
				
				select  substr(  partsname  , 1 ,  decode (  instr( partsname , '-' , 7 , 1 ) , 0  , length( partsname) , instr( partsname , '-' , 7 , 1 ) -1   ) ) , chipname
				into :lvs_partname1   		, :lvs_chipname1
				from ib_mnt_partslib
				where idnum = :lvs_pa	  ;	
				
	
				lvi_item_unit_qty = 0 ;
				lvs_location_infor1 = '';
				SELECT listagg(c, ',' ) within GROUP(ORDER BY c)   ,count(*)
				into :lvs_location_infor1  		 , :lvi_item_unit_qty
				from ib_mnt_positiondata_npm
				where parts = :lvs_pa
			    and pu = :lvs_n ;
				 
				
				row = dw_1.insertrow(0)
				dw_1.object.plan_date[row] = lvs_plan_date
				dw_1.object.lot_name[row] = lvs_lot_name
				dw_1.object.table_id[row] = lvs_table
				dw_1.object.address[row] = lvs_address
				dw_1.object.position[row] = 'L'	
				dw_1.object.partname[row] = lvs_partname1
				dw_1.object.chipname[row] = lvs_chipname1
				dw_1.object.location_info[row] = lvs_location_infor1		
				dw_1.object.line_code[row] = lvs_line_code
				dw_1.object.model_name[row] =LVS_LAYOUT_MODEL_NAME // lvs_model_name
				dw_1.object.pcb_item[row] = lvs_pcb_item
				dw_1.object.machine_group[row] = lvs_machine_group
				dw_1.object.item_unit_qty[row] = lvi_item_unit_qty
				dw_1.object.machine_code[row] = lvs_line_code+  string( integer(lvs_machine_group) , '00') 
				
			elseif lvs_pa = '0' and lvs_pb <> '0' then  //$$HEX4$$24c678b9bdca2000$$ENDHEX$$
				
				select   substr(  partsname  , 1 ,  decode (  instr( partsname , '-' , 7 , 1 ) , 0  , length( partsname) ,  instr( partsname , '-' , 7 , 1 ) -1   ) ) , chipname 
				into :lvs_partname2   		, :lvs_chipname2
				from ib_mnt_partslib
				where idnum = :lvs_pb	  ;
				
	

				lvi_item_unit_qty = 0 ;
				lvs_location_infor2 = '';
				SELECT listagg(c, ',' ) within GROUP(ORDER BY c)   , count(*)
				into :lvs_location_infor2		 , :lvi_item_unit_qty
				from ib_mnt_positiondata_npm
				where parts = :lvs_pb
				   and pu = :lvs_n ;				 
				
				row = dw_1.insertrow(0)
				dw_1.object.plan_date[row] = lvs_plan_date
				dw_1.object.lot_name[row] = lvs_lot_name
				dw_1.object.table_id[row] = lvs_table
				dw_1.object.address[row] = lvs_address
				dw_1.object.position[row] = 'R'	
				dw_1.object.partname[row] = lvs_partname2
				dw_1.object.chipname[row] = lvs_chipname2
				dw_1.object.location_info[row] = lvs_location_infor2	
				dw_1.object.line_code[row] = lvs_line_code
				dw_1.object.model_name[row] =LVS_LAYOUT_MODEL_NAME //lvs_model_name
				dw_1.object.pcb_item[row] = lvs_pcb_item
				dw_1.object.machine_group[row] = lvs_machine_group
				dw_1.object.item_unit_qty[row] = lvi_item_unit_qty
				dw_1.object.machine_code[row] = lvs_line_code+  string( integer(lvs_machine_group) , '00') 
				
			end if 
		
		loop until 1 =2 
		
		if dw_1.update() < 0 then 
			st_status.text ="Update dw_1"
			rollback ;
		else
			commit ;
			st_status.text ="Update OK"
		end if 
		dw_1.sort( )
		
loop until lvi_loop  = dw_6.rowcount( )
FileClose (li_FileNum)  
return 1
end function

public function integer wf_panasonic_block ();integer li_FileNum , li_eof , li_eof2 , lvi_loop
string is_filename , is_fullname , ls_text
string LVS_MACHINE_GROUP , LVS_START_TABLE_ID 
string lvs_n ,lvs_item_id , lvs_plan_date , lvs_lot_name , lvs_pa , lvs_pb , lvs_PartsLIB_yn = 'N'
string lvs_partname1 ,  lvs_chipname , lvs_chipname1 , lvs_partname2 , lvs_chipname2 , lvs_table  , lvs_address , lvs_location_infor1 , lvs_location_infor2
int i , row , lvi_item_unit_qty

//=========================================
//
//=========================================

st_status.text = "Delete ib_mnt_plandata" 

delete from ib_mnt_plandata ;

if sqlca.sqlcode < 0 then 
	MESSAGEBOX("ERROR" , SQLCA.SQLerrtext )
	rollback;
	return -1
end if 

//if GetFileOpenName ("Open", is_fullname, is_filename,   "txt", "Text Files (*.txt),*.txt,INI Files " + "(*.ini), *.ini,Batch Files (*.bat),*.bat",  "d:\temp") < 1 then return
lvi_loop = 0
do 
	lvi_loop ++
	is_fullname = string(dw_6.object.file_name[lvi_loop])
	LVS_MACHINE_GROUP =  dw_6.object.machine_group[lvi_loop]
	LVS_START_TABLE_ID=  dw_6.object.start_table_id[lvi_loop]
	
	if is_fullname  = '' or isnull(is_fullname) then 
		continue 
	end if 
	st_status.text = "File Open : "+is_fullname 
	
	
		li_FileNum = FileOpen (is_fullname, LineMode!)
		
		//=========================================
		//
		//=========================================
		st_status.text = "Delete ib_mnt_partslib"
		
		delete from ib_mnt_partslib ;
		
		if sqlca.sqlcode < 0 then 
			
			MESSAGEBOX("ERROR" , SQLCA.SQLerrtext )
			rollback;
			return -1
		end if 
		//=========================================
		//
		//=========================================
		st_status.text = "Delete ib_mnt_stockdata"
		delete from ib_mnt_stockdata ;
		if sqlca.sqlcode < 0 then 
			MESSAGEBOX("ERROR" , SQLCA.SQLerrtext )
			rollback;
			return -1
		end if 
		
		//=========================================
		//
		//=========================================
		st_status.text = "Delete ib_mnt_positiondata"
		delete from ib_mnt_positiondata ;
		if sqlca.sqlcode < 0 then 
			MESSAGEBOX("ERROR" , SQLCA.SQLerrtext )
			rollback;
			return -1
		end if 
		
		//=========================================
		//
		//=========================================
		st_status.text = "Delete ib_mnt_blockdata"
		delete from ib_mnt_blockdata ;
		if sqlca.sqlcode < 0 then 
			MESSAGEBOX("ERROR" , SQLCA.SQLerrtext )
			rollback;
			return -1
		end if 
		
		//=========================================
		//
		//=========================================
		
		do
			li_eof = FileReadEx (li_FileNum, ls_text ) 
		
		//===========================================================================
		// [LotNames]
		//===========================================================================
			if ls_text = '[LotNames]' then
				
				st_status.text ="[LotNames]"+" Extract"
				
				li_eof = FileReadEx (li_FileNum, ls_text )  //$$HEX6$$c0d074c7c0d2200009000900$$ENDHEX$$
				li_eof2 = FileReadEx (li_FileNum, ls_text )  //$$HEX6$$6fb8b8d270b374c7c0d02000$$ENDHEX$$
				
				lvs_lot_name = f_replace_string ( mid( ls_text , 1 , pos( ls_text , ' ') -1 ) , '"' , '')
				sle_lot_name.text =lvs_lot_name 
				
			end if 
		//===========================================================================
		// [BlockData]
		//===========================================================================
			if ls_text = '[BlockData]' then
				
				st_status.text ="[BlockData]"+" Extract"
				
				li_eof = FileReadEx (li_FileNum, ls_text )  //$$HEX4$$c0d074c7c0d22000$$ENDHEX$$
				
				li_eof2 = FileReadEx (li_FileNum, ls_text )
				
				do while ( mid(ls_text , 1 ,1) <> '[' and li_eof2 <> 0 )
		
					mle_2.text = mle_2.text + ls_text+"~r~n"
					
					dw_10.importstring( f_replace_string( ls_text ,' ' , '~t' ) +"~t"+string(today() ,'yyyymmdd')+"~t"+lvs_lot_name )
					li_eof2 = FileReadEx (li_FileNum, ls_text )	
				loop  ;
				
			end if 
		//===========================================================================
		// [ib_mnt_positiondata]
		//===========================================================================
			
			if ls_text = '[PartsLIB]' AND lvs_PartsLIB_yn = 'N' then
				
				lvs_PartsLIB_yn = 'Y'
				
				st_status.text ="[PartsLIB]"+" Extract"
				
				li_eof = FileReadEx (li_FileNum, ls_text )  //$$HEX4$$c0d074c7c0d22000$$ENDHEX$$
				
				li_eof2 = FileReadEx (li_FileNum, ls_text )
				
				do while ( mid(ls_text , 1 ,1) <> '[' and li_eof2 <> 0 )
		
					mle_2.text = mle_2.text + ls_text+"~r~n"
					
					dw_7.importstring( f_replace_string( ls_text ,' ' , '~t' ) +"~t"+string(today() ,'yyyymmdd')+"~t"+lvs_lot_name )
					li_eof2 = FileReadEx (li_FileNum, ls_text )	
				loop  ;
				
				
				
				
			end if 
//======================================================
//
//======================================================
		  if ls_text = '[PartsData]' AND lvs_PartsLIB_yn = 'N' then
				
				lvs_PartsLIB_yn = 'Y'
				
				st_status.text ="[PartsData]"+" Extract"
				
				
				li_eof = FileReadEx (li_FileNum, ls_text )  //$$HEX4$$c0d074c7c0d22000$$ENDHEX$$
				
				li_eof2 = FileReadEx (li_FileNum, ls_text )
				
				do while ( mid(ls_text , 1 ,1) <> '[' and li_eof2 <> 0 )
		
					mle_2.text = mle_2.text + ls_text+"~r~n"
					
					dw_7.importstring( f_replace_string( ls_text ,' ' , '~t' ) +"~t"+string(today() ,'yyyymmdd')+"~t"+lvs_lot_name )
					li_eof2 = FileReadEx (li_FileNum, ls_text )	
				loop  ;
				
			end if 		
		

		//==========================================================================
		//
		//==========================================================================
		
			if ls_text = '[PositionData]' then
				st_status.text ="[PositionData]"+" Extract"
				
				li_eof  = FileReadEx (li_FileNum, ls_text )  //$$HEX6$$c0d074c7c0d2200009000900$$ENDHEX$$
				li_eof2 = FileReadEx (li_FileNum, ls_text )
					
				do while ( mid(ls_text , 1 ,1) <> '[' and  li_eof2<> 0 )
					mle_2.text = mle_2.text + ls_text+"~r~n"
					dw_13.importstring( f_replace_string( ls_text ,' ' , '~t' )+"~t"+string(today(),'yyyymmdd hhmmss')+"~t"+lvs_lot_name )
					li_eof2 = FileReadEx (li_FileNum, ls_text )			
				loop ;
			end if 
				


		//==========================================================================
		//
		//==========================================================================
		
			if ls_text = '[StockData]' then
				st_status.text ="[StockData]"+" Extract"
				
				li_eof  = FileReadEx (li_FileNum, ls_text )  //$$HEX6$$c0d074c7c0d2200009000900$$ENDHEX$$
				li_eof2 = FileReadEx (li_FileNum, ls_text )
					
				do while ( mid(ls_text , 1 ,1) <> '[' and  li_eof2<> 0 )
					mle_2.text = mle_2.text + ls_text+"~r~n"
					dw_8.importstring( f_replace_string( ls_text ,' ' , '~t' )+"~t"+string(today(),'yyyymmdd hhmmss')+"~t"+lvs_lot_name )
					li_eof2 = FileReadEx (li_FileNum, ls_text )			
				loop ;
			end if 
				
		loop until li_eof = -100
		
		//===========================================================================
		//
		//===========================================================================
		FileClose (li_FileNum)  
		
		//===========================================================================
		//
		//===========================================================================
		if dw_7.update()  < 0 then 
			st_status.text ="Update dw_7"
			return -1 
		end if 
		if dw_8.update() < 0 then 
			st_status.text ="Update dw_8"
			return -1 
		end if 

		if dw_10.update() < 0 then 
			st_status.text ="Update dw_10"
			return -1 
		end if 
		
		if dw_13.update() < 0 then 
			st_status.text ="Update dw_13 Position Data"
			return -1 
		end if 
		
		
		commit ;
		
		//===================================================
		//
		//===================================================

			
		declare cl_stock cursor for 
		select n  , pa , pb , plan_date , lot_name from ib_mnt_stockdata order by idnum ;
		
		open cl_stock ;
		
		do
			 lvs_n = ''
			 lvs_pa  = '' 
			 lvs_pb = '' 
			 lvs_plan_date = ''
			 lvs_lot_name = ''
			 
			fetch cl_stock into :lvs_n ,:lvs_pa , :lvs_pb ,  :lvs_plan_date , :lvs_lot_name;
			
			if sqlca.sqlcode < 0 then
				close cl_stock ;
				rollback ;
				exit
			end if 
			
			if sqlca.sqlcode = 100 then 
				close cl_stock ;
				exit
			end if 
			
			i++
			IF LEN(lvs_n) =5 THEN 
				
				
				IF mid(lvs_n , 3 ,1 ) <> '0' THEN 
					
					lvs_table = 'Z' 
					lvs_address =  'TRAY'+RIGHT(lvs_n , 1 )
					
				ELSE
				
					 select  chr( ascii(:LVS_START_TABLE_ID) +  to_number( substr(:lvs_n , 1 ,1) ) -1  )
					 into :lvs_table
					 from dual ;
				 	 lvs_address = string(INTEGER(mid(lvs_n , 3 ,3 )) , '00')
				END IF 
		
			ELSE
				
							
				IF mid(lvs_n , 4 ,1 ) <> '0' THEN 
					
					lvs_table = 'Z' 
					Lvs_address =  'TRAY'+RIGHT(lvs_n , 1 )
					
				ELSE	
				
					select  chr( ascii(:LVS_START_TABLE_ID) +  to_number( substr(:lvs_n , 1 ,2) ) -1  )
					   into :lvs_table
					  from dual ;
				 	lvs_address = string(INTEGER(mid(lvs_n , 4 ,3 )) , '00')
				 END IF 
		
			END IF
			
			if lvs_pa <> '0' and lvs_pb <> '0' then  //$$HEX3$$91c5bdca2000$$ENDHEX$$
			
			  //==============================================
			  //
			  //==============================================	
				
				select  substr(  partsname  , 1 ,  decode (  instr( partsname , '-' , 7 , 1 ) , 0  , length( partsname) ,  instr( partsname , '-' , 7 , 1 ) -1   ) ) , chipname 
				into   :lvs_partname1  , :lvs_chipname1
				from ib_mnt_partslib
				where idnum = :lvs_pa	  ;
				 
			
				 lvi_item_unit_qty = 0 ;
				 
				SELECT listagg(c, ',' ) within GROUP(ORDER BY c)   , count(*)
				into :lvs_location_infor1  		 , :lvi_item_unit_qty
				from ib_mnt_blockdata
				where parts = :lvs_pa;
				
		
				row = dw_1.insertrow(0)
				dw_1.object.plan_date[row] = lvs_plan_date
				dw_1.object.lot_name[row] = lvs_lot_name
				dw_1.object.table_id[row] = lvs_table
				dw_1.object.address[row] = lvs_address
				dw_1.object.position[row] = 'L'
				dw_1.object.partname[row] = lvs_partname1
				dw_1.object.chipname[row] = lvs_chipname1
				dw_1.object.location_info[row] = lvs_location_infor1		
				dw_1.object.line_code[row] = lvs_line_code
				dw_1.object.model_name[row] = LVS_LAYOUT_MODEL_NAME //lvs_model_name
				dw_1.object.pcb_item[row] = lvs_pcb_item
				dw_1.object.machine_group[row] = lvs_machine_group+" B:"+lvs_pa
				dw_1.object.item_unit_qty[row] = lvi_item_unit_qty
				
				dw_1.object.machine_code[row] = lvs_line_code+  string( integer(lvs_machine_group) , '00') 
				
			  //==============================================
			  //
			  //==============================================
				select   substr(  partsname  , 1 ,  decode (  instr( partsname , '-' , 7 , 1 ) , 0  , length( partsname) ,  instr( partsname , '-' , 7 , 1 ) -1   ) ) , chipname 
				 into :lvs_partname2   	, :lvs_chipname2	
				from ib_mnt_partslib
				where idnum = :lvs_pb ;	

				lvi_item_unit_qty = 0 ;
				SELECT listagg(c, ',' ) within GROUP(ORDER BY c)   , count(* )
				into   :lvs_location_infor2		 , :lvi_item_unit_qty
				from ib_mnt_blockdata
				where parts =:lvs_pb ;
				
				row = dw_1.insertrow(0)
				dw_1.object.plan_date[row] = lvs_plan_date
				dw_1.object.lot_name[row] = lvs_lot_name
				dw_1.object.table_id[row] = lvs_table
				dw_1.object.address[row] = lvs_address
				dw_1.object.position[row] = 'R'
				dw_1.object.partname[row] = lvs_partname2
				dw_1.object.chipname[row] = lvs_chipname2
				dw_1.object.location_info[row] = lvs_location_infor2		
					dw_1.object.line_code[row] = lvs_line_code
				dw_1.object.model_name[row] = LVS_LAYOUT_MODEL_NAME //lvs_model_name
				dw_1.object.pcb_item[row] = lvs_pcb_item	
				dw_1.object.machine_group[row] = lvs_machine_group+" B:"+lvs_pb
				dw_1.object.item_unit_qty[row] = lvi_item_unit_qty
				dw_1.object.machine_code[row] = lvs_line_code+  string( integer(lvs_machine_group) , '00') 
				
			elseif lvs_pa <> '0' and lvs_pb = '0' then  //$$HEX3$$7cc6bdca2000$$ENDHEX$$
				
				select  substr(  partsname  , 1 ,  decode (  instr( partsname , '-' , 7 , 1 ) , 0  , length( partsname) , instr( partsname , '-' , 7 , 1 ) -1   ) ) , chipname
				into :lvs_partname1   		, :lvs_chipname1
				from ib_mnt_partslib
				where idnum = :lvs_pa	  ;	
				
	
				lvi_item_unit_qty = 0 ;
				SELECT listagg(c, ',' ) within GROUP(ORDER BY c)   , count( * )
				into   :lvs_location_infor1  		 , :lvi_item_unit_qty
				from ib_mnt_blockdata
				where parts = :lvs_pa ;
				 
		
				row = dw_1.insertrow(0)
				dw_1.object.plan_date[row] = lvs_plan_date
				dw_1.object.lot_name[row] = lvs_lot_name
				dw_1.object.table_id[row] = lvs_table
				dw_1.object.address[row] = lvs_address
				dw_1.object.position[row] = 'L'	
				dw_1.object.partname[row] = lvs_partname1
				dw_1.object.chipname[row] = lvs_chipname1
				dw_1.object.location_info[row] = lvs_location_infor1		
				dw_1.object.line_code[row] = lvs_line_code
				dw_1.object.model_name[row] =LVS_LAYOUT_MODEL_NAME // lvs_model_name
				dw_1.object.pcb_item[row] = lvs_pcb_item
				dw_1.object.machine_group[row] = lvs_machine_group+" L:"+lvs_pa
				dw_1.object.item_unit_qty[row] = lvi_item_unit_qty
				dw_1.object.machine_code[row] = lvs_line_code+  string( integer(lvs_machine_group) , '00') 
				
			elseif lvs_pa = '0' and lvs_pb <> '0' then  //$$HEX4$$24c678b9bdca2000$$ENDHEX$$
				
				select   substr(  partsname  , 1 ,  decode (  instr( partsname , '-' , 7 , 1 ) , 0  , length( partsname) ,  instr( partsname , '-' , 7 , 1 ) -1   ) ) , chipname 
				into :lvs_partname2   		, :lvs_chipname2
				from ib_mnt_partslib
				where idnum = :lvs_pb	  ;
	
				lvi_item_unit_qty = 0 ;
				SELECT listagg(c, ',' ) within GROUP(ORDER BY c)   , count(* )
				into   :lvs_location_infor2 , :lvi_item_unit_qty
				from  ib_mnt_blockdata
				where parts = :lvs_pb ;
				 
				
				row = dw_1.insertrow(0)
				dw_1.object.plan_date[row] = lvs_plan_date
				dw_1.object.lot_name[row] = lvs_lot_name
				dw_1.object.table_id[row] = lvs_table
				dw_1.object.address[row] = lvs_address
				dw_1.object.position[row] = 'R'	
				dw_1.object.partname[row] = lvs_partname2
				dw_1.object.chipname[row] = lvs_chipname2
				dw_1.object.location_info[row] = lvs_location_infor2	
				dw_1.object.line_code[row] = lvs_line_code
				dw_1.object.model_name[row] = LVS_LAYOUT_MODEL_NAME //lvs_model_name
				dw_1.object.pcb_item[row] = lvs_pcb_item
				dw_1.object.machine_group[row] = lvs_machine_group+" R:"+lvs_pb
				dw_1.object.item_unit_qty[row] = lvi_item_unit_qty
				dw_1.object.machine_code[row] = lvs_line_code+  string( integer(lvs_machine_group) , '00') 
				
			end if 
		
		loop until 1 =2 
		
		if dw_1.update() < 0 then 
			
			st_status.text ="Update dw_1"
			Rollback;
			
		else
			commit ;
			st_status.text ="Update OK"
		end if 
		dw_1.sort( )
		
loop until lvi_loop  = dw_6.rowcount( )
FileClose (li_FileNum)  
return 1
end function

on w_smt_upload_nc_master_new.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.sle_lot_name=create sle_lot_name
this.mle_2=create mle_2
this.rb_pana=create rb_pana
this.dw_6=create dw_6
this.cb_2=create cb_2
this.st_status=create st_status
this.dw_7=create dw_7
this.dw_8=create dw_8
this.dw_9=create dw_9
this.dw_10=create dw_10
this.dw_11=create dw_11
this.dw_12=create dw_12
this.rb_npm=create rb_npm
this.dw_13=create dw_13
this.rb_pana_position=create rb_pana_position
this.cb_3=create cb_3
this.gb_1=create gb_1
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_lot_name
this.Control[iCurrent+3]=this.mle_2
this.Control[iCurrent+4]=this.rb_pana
this.Control[iCurrent+5]=this.dw_6
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.st_status
this.Control[iCurrent+8]=this.dw_7
this.Control[iCurrent+9]=this.dw_8
this.Control[iCurrent+10]=this.dw_9
this.Control[iCurrent+11]=this.dw_10
this.Control[iCurrent+12]=this.dw_11
this.Control[iCurrent+13]=this.dw_12
this.Control[iCurrent+14]=this.rb_npm
this.Control[iCurrent+15]=this.dw_13
this.Control[iCurrent+16]=this.rb_pana_position
this.Control[iCurrent+17]=this.cb_3
this.Control[iCurrent+18]=this.gb_1
this.Control[iCurrent+19]=this.gb_3
end on

on w_smt_upload_nc_master_new.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.sle_lot_name)
destroy(this.mle_2)
destroy(this.rb_pana)
destroy(this.dw_6)
destroy(this.cb_2)
destroy(this.st_status)
destroy(this.dw_7)
destroy(this.dw_8)
destroy(this.dw_9)
destroy(this.dw_10)
destroy(this.dw_11)
destroy(this.dw_12)
destroy(this.rb_npm)
destroy(this.dw_13)
destroy(this.rb_pana_position)
destroy(this.cb_3)
destroy(this.gb_1)
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
Ivs_resize_type    = 'MASTER_DETAIL_12T_345B'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

ivs_dw_1_retrice_cancel_popup_open = 'Y'
ivs_dw_2_retrice_cancel_popup_open = 'N'
ivs_dw_3_retrice_cancel_popup_open = 'N'
ivs_dw_4_retrice_cancel_popup_open = 'N'
ivs_dw_5_retrice_cancel_popup_open = 'N'

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

event ue_data_control;call super::ue_data_control;long row

CHOOSE CASE Gvs_Ue_data_control
		
		
	CASE 'RETRIEVE'
		
				dw_1.retrieve()
				dw_4.retrieve()
			    
	CASE 'INSERT'		//$$HEX5$$c4ac8dd694cd00ac2000$$ENDHEX$$
	
				
	CASE 'APPEND' 

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
				
				if dw_1.update() < 0 then 
					rollback;
				else
					commit ;
				end if 
				f_msgbox(170)
			 
	CASE ELSE
END CHOOSE
end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
st_status.width = dw_1.width + dw_2.width
dw_6.settransobject( sqlca)
dw_7.settransobject( sqlca)

dw_8.settransobject( sqlca)

dw_9.settransobject( sqlca)

dw_10.settransobject( sqlca)
dw_11.settransobject( sqlca)
dw_12.settransobject( sqlca) //position data npm

dw_13.settransobject( sqlca) //position data
end event

event resize;call super::resize;st_status.width = dw_1.width + dw_2.width
end event

type dw_5 from w_main_root`dw_5 within w_smt_upload_nc_master_new
integer x = 2638
integer y = 1100
integer width = 2729
integer height = 744
boolean titlebar = true
end type

type dw_4 from w_main_root`dw_4 within w_smt_upload_nc_master_new
integer x = 2638
integer y = 1100
integer width = 2729
integer height = 744
boolean titlebar = true
end type

type dw_3 from w_main_root`dw_3 within w_smt_upload_nc_master_new
integer x = 2638
integer y = 1100
integer width = 2729
integer height = 744
boolean titlebar = true
end type

type dw_2 from w_main_root`dw_2 within w_smt_upload_nc_master_new
integer x = 2638
integer y = 1100
integer width = 2729
integer height = 744
boolean titlebar = true
string title = "BOM"
end type

type dw_1 from w_main_root`dw_1 within w_smt_upload_nc_master_new
event ue_lbuttondown pbm_lbuttondown
integer x = 2638
integer y = 1100
integer width = 2729
integer height = 744
boolean titlebar = true
string title = "Feeder Layout"
string dataobject = "d_plandata"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_smt_upload_nc_master_new
end type

type cb_1 from commandbutton within w_smt_upload_nc_master_new
integer x = 219
integer y = 620
integer width = 375
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Generate"
end type

event clicked;//LVS_LINE_CODE    = DDLB_LINE_CODE.GETCODE()
//LVS_SMT_MODEL_NAME = DDLB_SMT_MODEL_NAME.GETCODE() 
//LVS_LAYOUT_MODEL_NAME = sle_layout_model_name.text
//lvs_pcb_item  = DDLB_PCB_ITEM.GETCODE()

if lvs_line_code = '' or lvs_line_code = '%' or LVS_SMT_MODEL_NAME = '' or LVS_SMT_MODEL_NAME = '%' or lvs_pcb_item = '' or lvs_pcb_item  = '%' or LVS_LAYOUT_MODEL_NAME = '' or isnull(LVS_LAYOUT_MODEL_NAME) then 
	 f_msg( "$$HEX3$$7cb778c72000$$ENDHEX$$/ $$HEX3$$a8ba78b32000$$ENDHEX$$/ $$HEX15$$d1d014bc40d120006cad84bd44c7200020c1ddd0200058d538c194c62000$$ENDHEX$$", 'P') 
	return -1
end if 


if dw_6.getrow() <1 then 
	f_msg( "$$HEX11$$0cd37cc744c7200020c1ddd0200058d538c194c62000$$ENDHEX$$", 'P')
	return -1 
end if 

if dw_6.object.start_table_id[1] = '' or isnull(dw_6.object.start_table_id[1]) then 
	f_msg( "$$HEX15$$dcc291c720004cd174c714be44c7200020c1ddd0200058d538c194c62000$$ENDHEX$$", 'P')
	return -1
end if 


msg = f_msgbox1(1161 , this.text )
if msg = 1 then 
else
	return 
end if 

dw_1.reset()

if rb_pana.checked = true then
	wf_panasonic_block( )
elseif  rb_pana_position.checked = true then
	wf_panasonic( )
elseif rb_npm.checked = true then 
	wf_npm( )
else
	wf_samsung( )
end if 

dw_4.retrieve( )
F_MSGBOX(170)
end event

type sle_lot_name from so_singlelineedit within w_smt_upload_nc_master_new
integer x = 837
integer y = 28
integer width = 2313
integer height = 68
integer taborder = 40
boolean bringtotop = true
end type

type mle_2 from so_multilineedit within w_smt_upload_nc_master_new
integer x = 837
integer y = 92
integer width = 2313
integer height = 832
integer taborder = 20
boolean bringtotop = true
long textcolor = 65280
long backcolor = 0
string text = ""
boolean hscrollbar = true
boolean vscrollbar = true
boolean autohscroll = true
end type

type rb_pana from so_radiobutton within w_smt_upload_nc_master_new
integer x = 78
integer y = 88
integer width = 658
boolean bringtotop = true
string text = "Panasonic CM(Block)"
end type

type dw_6 from so_datawindow within w_smt_upload_nc_master_new
integer y = 1108
integer width = 2624
integer height = 1568
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_smt_nc_upload_file_name_lst"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;
string is_fullname , is_filename

if dwo.name = 'b_file_upload' then 
if GetFileOpenName ("Open", is_fullname, is_filename,   "txt", "Text Files (*.txt),*.txt,INI Files " + "(*.ini), *.ini,All Files (*.*),*.*",  "d:\temp") < 1 then return

this.object.file_name[row] = is_fullname

end if 
end event

event itemchanged;//over
end event

type cb_2 from commandbutton within w_smt_upload_nc_master_new
integer x = 219
integer y = 744
integer width = 375
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Apply"
end type

event clicked;string lvs_revision
//if sle_revision.text = '' or isnull(sle_revision.text) then 
//	f_msg( "$$HEX10$$acb944be3cc844c7200085c725b858d538c194c6$$ENDHEX$$", 'P') 
//	sle_revision.setfocus()
//	return	
//else
//	lvs_revision = sle_revision.text
//end if 
if dw_1.getrow() < 1 then
	//Mess agebox("$$HEX2$$14bcf4bc$$ENDHEX$$" , "$$HEX22$$3cba00c82000ddc031c1200091c7c5c544c72000c4c989d55cd52000c4d6200001c8a9c6200058d538c194c6$$ENDHEX$$")
	f_msg( "$$HEX22$$3cba00c82000ddc031c1200091c7c5c544c72000c4c989d55cd52000c4d6200001c8a9c6200058d538c194c6$$ENDHEX$$", 'P') 
	return
end if 

msg = f_msgbox1(1161 , this.text ) 
	
if msg = 1 then 
else
	return 
end if 


//	if cbx_mixed.checked = true then 
//
//				delete from id_eng_bom_smt 
//				where ( parent_item_code , line_code  , pcb_item , location_code ) in ( select model_name , line_code  , pcb_item , table_id||address||position  FROM IB_MNT_PLANDATA ) 
//					 and organization_id = :gvi_organization_id ;
//				 
//				 if f_sql_check() < 0 then 
//					return 
//				end if 
//				
//				delete from id_eng_bom_smt_replace
//				where ( parent_item_code , line_code  , pcb_item , location_code ) in ( select model_name , line_code  , pcb_item , table_id||address||position  FROM IB_MNT_PLANDATA ) 
//				 and organization_id = :gvi_organization_id ;
//				 
//				 if f_sql_check() < 0 then 
//					return 
//				end if 	 
//				
//	else
	
				delete from id_eng_bom_smt 
				where ( parent_item_code , line_code  , pcb_item  ) in ( select model_name , line_code  , pcb_item   FROM IB_MNT_PLANDATA ) 
					 and organization_id = :gvi_organization_id ;
				 
				 if f_sql_check() < 0 then 
					return 
				end if 
				
				delete from id_eng_bom_smt_replace
				where ( parent_item_code , line_code  , pcb_item  ) in ( select model_name , line_code  , pcb_item   FROM IB_MNT_PLANDATA ) 
				 and organization_id = :gvi_organization_id ;
				 
				 if f_sql_check() < 0 then 
					return 
				end if 	 		
		
//	end if 
	 
	 
	 
INSERT INTO id_eng_bom_smt (parent_item_code,
                            child_item_code,
                            bom_level,
                            dateset,
                            dateend,
                            location_code,
                            organization_id,
                            sort_sequence,
                            item_unit_qty,
                            workstage_code,
                            bom_work_no,
                            item_type,
                            line_type,
                            enter_by,
                            enter_date,
                            last_modify_by,
                            last_modify_date,
                            location_info,
                            line_code,
                            machine,
                            loss_rate,
                            scrap_rate,
                            assy_explosion_yn,
                            item_unit_qty_ext,
                            location_code_org,
                            version,
                            pcb_item,
                            marking_no,
                            comments,
                            table_id,
                            feeder_type,
                            location_code_last ,
						 feeder_shaft,
						 revision,
						 master_model_name,
						 model_name,
						 smt_model_name )
  select  model_name , //parent_item_code,
            SUBSTR( partname , 1 ,  decode(  instr( partname , '-' , 7 , 1 ) , 0 , length(partname)  , instr( partname , '-' , 7 , 1 )  -1  )   )  , //child_item_code,
            1 , //bom_level,
            trunc(sysdate)  , //dateset,
            to_date('99991231' , 'yyyymmdd') , //dateend,
            table_id||address||position , //location_code,
            :gvi_organization_id , //organization_id,
            1 , //sort_sequence,
            item_unit_qty , //item_unit_qty,
            '*' , //workstage_code,
            0 , //bom_work_no,
            'T' , //item_type,
            f_get_line_type_from_item( SUBSTR( partname , 1 ,  decode( instr( partname , '-' , 7 , 1 ) ,0, length(partname) ,   instr( partname , '-' , 7 , 1 )     )         -1 )    , :gvi_organization_id )  , //line_type,
            :gvs_user_id , //enter_by,
            sysdate , //enter_date,
            :gvs_user_id , //last_modify_by,
            sysdate , //last_modify_date,
            location_info,
            line_code,
            machine_code ,
            0 loss_rate,
            0 scrap_rate,
            'Y' , //assy_explosion_yn,
            item_unit_qty  item_unit_qty_ext,
            NULL , //location_code_org,
            1 , //version,
            pcb_item,
            partname , //marking_no,
            'FROM NC MASTER' , //comments,
            table_id,
            feeder_type,
            '' location_code_last ,
		   '*' ,
			:lvs_revision ,
		   :lvs_master_model_name ,
	  	   :lvs_master_model_name ,
		   :lvs_smt_model_name // $$HEX16$$a8ba78b3c8b9a4c230d140c62000f0c5b0ace0acacb92000a8ba78b385ba2000$$ENDHEX$$
	 FROM IB_MNT_PLANDATA ;
	
	IF F_SQL_CHECK() < 0 THEN 
		RETURN 
	END IF 
	
	UPDATE ID_ITEM A 
	     SET A.FEEDER_SIZE = ( SELECT max(B.feeder_type)  
		                                       FROM IB_MNT_PLANDATA B 
										 WHERE A.ITEM_CODE = B.partname )
	  WHERE A.ITEM_CODE 
	         IN ( SELECT B.partname 
				    FROM  IB_MNT_PLANDATA B
				   WHERE A.ITEM_CODE = B.partname )
	      AND A.FEEDER_SIZE IS NULL 	;
				
		IF F_SQL_CHECK() < 0 THEN 
			RETURN 
		END IF   
	
	
	COMMIT; 
	
	f_msgbox(170) 
end event

type st_status from so_statictext within w_smt_upload_nc_master_new
integer x = 18
integer y = 952
integer width = 5353
integer height = 132
boolean bringtotop = true
integer textsize = -18
long textcolor = 0
long backcolor = 16777215
string text = "Message"
end type

type dw_7 from so_datawindow within w_smt_upload_nc_master_new
boolean visible = false
integer x = 3698
integer y = 56
integer width = 457
integer height = 268
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "PartsLIB"
string dataobject = "d_partlist"
boolean controlmenu = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event doubleclicked;call super::doubleclicked;this.bringtotop = false
end event

type dw_8 from so_datawindow within w_smt_upload_nc_master_new
boolean visible = false
integer x = 4178
integer y = 56
integer width = 457
integer height = 268
integer taborder = 30
boolean bringtotop = true
boolean titlebar = true
string title = "StrockData"
string dataobject = "d_stockdata"
boolean controlmenu = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event doubleclicked;call super::doubleclicked;this.bringtotop = false
end event

type dw_9 from so_datawindow within w_smt_upload_nc_master_new
boolean visible = false
integer x = 3698
integer y = 348
integer width = 457
integer height = 268
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "Step Infor(Smasung)"
string dataobject = "d_stepinfor"
boolean controlmenu = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event doubleclicked;call super::doubleclicked;this.bringtotop = false
end event

type dw_10 from so_datawindow within w_smt_upload_nc_master_new
boolean visible = false
integer x = 4178
integer y = 348
integer width = 457
integer height = 268
integer taborder = 30
boolean bringtotop = true
boolean titlebar = true
string title = "BlockData"
string dataobject = "d_blockdata"
boolean controlmenu = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event doubleclicked;call super::doubleclicked;this.bringtotop = false
end event

type dw_11 from so_datawindow within w_smt_upload_nc_master_new
boolean visible = false
integer x = 3182
integer y = 656
integer width = 457
integer height = 268
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "BlockData"
string dataobject = "d_mnt_part_information"
boolean controlmenu = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

type dw_12 from so_datawindow within w_smt_upload_nc_master_new
boolean visible = false
integer x = 3698
integer y = 648
integer width = 457
integer height = 268
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "BlockData"
string dataobject = "d_positiondata_npm"
boolean controlmenu = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

type rb_npm from so_radiobutton within w_smt_upload_nc_master_new
integer x = 78
integer y = 260
integer width = 658
boolean bringtotop = true
string text = "Panasonic NPM"
end type

type dw_13 from so_datawindow within w_smt_upload_nc_master_new
boolean visible = false
integer x = 4178
integer y = 648
integer width = 457
integer height = 268
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "BlockData"
string dataobject = "d_positiondata"
boolean controlmenu = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

type rb_pana_position from so_radiobutton within w_smt_upload_nc_master_new
integer x = 78
integer y = 172
integer width = 658
boolean bringtotop = true
string text = "Panasonic CM(Position)"
end type

type cb_3 from commandbutton within w_smt_upload_nc_master_new
integer x = 229
integer y = 488
integer width = 375
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "File"
end type

event clicked;string docpath, docname[]

integer i, li_cnt, li_rtn, li_filenum , lvi_row

li_rtn = GetFileOpenName("Select File",  docpath, docname[], "PBL", &
   + "PBL Files (*.PBL),*.PBL," &
   + "All Files (*.*), *.*",  "", 18)


IF li_rtn < 1 THEN return

li_cnt = Upperbound(docname)

do
	i++
	
	
	lvi_row= dw_6.insertrow(0)
	dw_6.object.fle_name[lvi_row] = docname[1]
	
//   sle_filename.text = string(docpath)

loop until i = li_cnt

end event

type gb_1 from so_groupbox within w_smt_upload_nc_master_new
integer x = 14
integer y = 16
integer width = 809
integer height = 352
integer taborder = 30
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_smt_upload_nc_master_new
integer x = 14
integer y = 376
integer width = 809
integer height = 548
integer taborder = 10
string text = "Process"
end type

