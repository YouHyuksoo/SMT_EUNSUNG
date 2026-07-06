HA$PBExportHeader$pb_uo_workflow.sru
forward
global type pb_uo_workflow from so_picturebutton
end type
end forward

global type pb_uo_workflow from so_picturebutton
integer width = 393
integer height = 344
integer textsize = -8
end type
global pb_uo_workflow pb_uo_workflow

type variables
string #window_name
end variables

on pb_uo_workflow.create
call super::create
end on

on pb_uo_workflow.destroy
call super::destroy
end on

event clicked;call super::clicked;boolean ib_valid
window child , wSheet
int i

//if isvalid(iws_active_window) then 
//
//	if iws_active_window.classname() = #window_name then 
//		iws_active_window.bringtotop = true
//		w_collapsemenu.pb_close.triggerevent(clicked!)
//	else
//		OpenSheet(child, #window_name , w_main_frame,  Gvi_opensheet_position, Layered!)
//	end if 
//else
//		OpenSheet(child, #window_name , w_main_frame,  Gvi_opensheet_position, Layered!)	
//end if 


//===========================================
i = 0;
wSheet = w_main_frame.GetFirstSheet()
if isvalid(wSheet) then
	
	if wSheet.classname() = #window_name then 
		i++

		if w_collapsemenu.ib_locked = true then 
			wSheet.bringtotop = true			
		else
	
			w_collapsemenu.pb_close.triggerevent(clicked!)
			wSheet.bringtotop = true				
		end if 
	else
			DO
				
				wSheet = w_main_frame.getnextsheet(wSheet)
				
				if IsValid (wSheet) then 
					if  wSheet.classname() = #window_name then 
						i++
						
						if w_collapsemenu.ib_locked = true then 						
							wSheet.bringtotop = true
						else
							
							w_collapsemenu.pb_close.triggerevent(clicked!)
							wSheet.bringtotop = true		
						end if 
						
						exit
					end if 	
				else
					exit
				end if 

			LOOP UNTIL 1 = 2
			
		if i = 0 then 
			OpenSheet(child, #window_name , w_main_frame,  Gvi_opensheet_position, Layered!)	
		end if 			
	end if 	
	

end if 
end event

