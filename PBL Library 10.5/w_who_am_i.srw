HA$PBExportHeader$w_who_am_i.srw
$PBExportComments$$$HEX10$$60c50cd5acb900cf74c758c1d0c500b358d5ecc5$$ENDHEX$$
forward
global type w_who_am_i from w_none_dw_popup_root
end type
type cb_insert from so_commandbutton within w_who_am_i
end type
type sle_user_id5 from so_singlelineedit within w_who_am_i
end type
type em_1 from so_editmask within w_who_am_i
end type
type sle_org_name from so_singlelineedit within w_who_am_i
end type
type st_14 from so_statictext within w_who_am_i
end type
type st_13 from so_statictext within w_who_am_i
end type
type st_12 from so_statictext within w_who_am_i
end type
type st_11 from so_statictext within w_who_am_i
end type
type sle_user_id3 from so_singlelineedit within w_who_am_i
end type
type sle_user_id2 from so_singlelineedit within w_who_am_i
end type
type sle_user_id1 from so_singlelineedit within w_who_am_i
end type
type st_10 from so_statictext within w_who_am_i
end type
type sle_user_id0 from so_singlelineedit within w_who_am_i
end type
type st_9 from so_statictext within w_who_am_i
end type
type sle_9 from so_singlelineedit within w_who_am_i
end type
type st_8 from so_statictext within w_who_am_i
end type
type sle_window_description from so_singlelineedit within w_who_am_i
end type
type st_7 from so_statictext within w_who_am_i
end type
type sle_window_title from so_singlelineedit within w_who_am_i
end type
type st_6 from so_statictext within w_who_am_i
end type
type sle_window_name from so_singlelineedit within w_who_am_i
end type
type st_5 from so_statictext within w_who_am_i
end type
type sle_organization_id from so_singlelineedit within w_who_am_i
end type
type st_4 from so_statictext within w_who_am_i
end type
type sle_user_name from so_singlelineedit within w_who_am_i
end type
type sle_3 from so_singlelineedit within w_who_am_i
end type
type sle_password from so_singlelineedit within w_who_am_i
end type
type sle_user_id from so_singlelineedit within w_who_am_i
end type
type st_3 from so_statictext within w_who_am_i
end type
type st_2 from so_statictext within w_who_am_i
end type
type st_1 from so_statictext within w_who_am_i
end type
type sle_selected_data_window from so_singlelineedit within w_who_am_i
end type
type st_15 from so_statictext within w_who_am_i
end type
type sle_library_name from so_singlelineedit within w_who_am_i
end type
type st_16 from so_statictext within w_who_am_i
end type
type p_1 from picture within w_who_am_i
end type
type st_17 from so_statictext within w_who_am_i
end type
type sle_iso_tag from so_singlelineedit within w_who_am_i
end type
type gb_2 from so_groupbox within w_who_am_i
end type
type gb_1 from so_groupbox within w_who_am_i
end type
end forward

global type w_who_am_i from w_none_dw_popup_root
integer x = 517
integer y = 300
integer width = 3291
integer height = 2040
string title = "About Application..."
long backcolor = 16777215
cb_insert cb_insert
sle_user_id5 sle_user_id5
em_1 em_1
sle_org_name sle_org_name
st_14 st_14
st_13 st_13
st_12 st_12
st_11 st_11
sle_user_id3 sle_user_id3
sle_user_id2 sle_user_id2
sle_user_id1 sle_user_id1
st_10 st_10
sle_user_id0 sle_user_id0
st_9 st_9
sle_9 sle_9
st_8 st_8
sle_window_description sle_window_description
st_7 st_7
sle_window_title sle_window_title
st_6 st_6
sle_window_name sle_window_name
st_5 st_5
sle_organization_id sle_organization_id
st_4 st_4
sle_user_name sle_user_name
sle_3 sle_3
sle_password sle_password
sle_user_id sle_user_id
st_3 st_3
st_2 st_2
st_1 st_1
sle_selected_data_window sle_selected_data_window
st_15 st_15
sle_library_name sle_library_name
st_16 st_16
p_1 p_1
st_17 st_17
sle_iso_tag sle_iso_tag
gb_2 gb_2
gb_1 gb_1
end type
global w_who_am_i w_who_am_i

type variables

end variables

event open;call super::open;DECIMAL LVF_VERSION
THIS.TITLE = "("+Gvs_app_name+") About Application..." 

sle_user_id.TEXT = GVS_USER_ID
SLE_3.TEXT = string(GVi_USER_LEVEL)
sle_user_name.TEXT = GVS_USER_NAME
sle_organization_id.TEXT = STRING(GVI_ORGANIZATION_ID)
SLE_ORG_NAME.TEXT = GVS_ORGANIZATION_NAME

SLE_WINDOW_NAME.TEXT = Gst_set.window_id
sle_window_title.TEXT = Gst_set.window_title     
SLE_WINDOW_DESCRIPTION.TEXT = Gst_set.window_comment   
SLE_9.TEXT = Gst_set.author           
sle_user_id0.TEXT = Gst_set.creation_date    
sle_user_id1.TEXT = Gst_set.last_modify_date 

if isnull(selected_data_window) or isvalid(selected_data_window) = false then 
  return	
else
	sle_selected_data_window.text = selected_data_window.classname()
end if

SELECT VERSION INTO :LVF_VERSION
  FROM ISYS_WINDOW
  WHERE WINDOW_NAME = :Gst_set.window_id
    AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	 
IF F_SQL_CHECK() < 0 THEN 
	RETURN
END IF

sle_user_id2.TEXT =  STRING(LVF_VERSION)

IF Gst_set.Report_window = TRUE THEN 
	sle_user_id3.TEXT = 'Report Window' 
ELSE
	sle_user_id3.TEXT = 'Working Window' 	
END IF;

 ClassDefinition cd_windef
 cd_windef = FindClassDefinition(Gst_set.window_id)

sle_library_name.text = cd_windef.LibraryName

STRING lvs_iso_tag
SELECT ISO_TAG INTO :lvs_iso_tag
 FROM ISYS_WINDOW_ISO_TAG
 WHERE WINDOW_NAME = :sle_window_name.TEXT 
   AND  DATAWINDOW_NAME = :sle_selected_data_window.TEXT
   AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;

	
SLE_ISO_TAG.TEXT= lvs_iso_tag
end event

on w_who_am_i.create
int iCurrent
call super::create
this.cb_insert=create cb_insert
this.sle_user_id5=create sle_user_id5
this.em_1=create em_1
this.sle_org_name=create sle_org_name
this.st_14=create st_14
this.st_13=create st_13
this.st_12=create st_12
this.st_11=create st_11
this.sle_user_id3=create sle_user_id3
this.sle_user_id2=create sle_user_id2
this.sle_user_id1=create sle_user_id1
this.st_10=create st_10
this.sle_user_id0=create sle_user_id0
this.st_9=create st_9
this.sle_9=create sle_9
this.st_8=create st_8
this.sle_window_description=create sle_window_description
this.st_7=create st_7
this.sle_window_title=create sle_window_title
this.st_6=create st_6
this.sle_window_name=create sle_window_name
this.st_5=create st_5
this.sle_organization_id=create sle_organization_id
this.st_4=create st_4
this.sle_user_name=create sle_user_name
this.sle_3=create sle_3
this.sle_password=create sle_password
this.sle_user_id=create sle_user_id
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.sle_selected_data_window=create sle_selected_data_window
this.st_15=create st_15
this.sle_library_name=create sle_library_name
this.st_16=create st_16
this.p_1=create p_1
this.st_17=create st_17
this.sle_iso_tag=create sle_iso_tag
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_insert
this.Control[iCurrent+2]=this.sle_user_id5
this.Control[iCurrent+3]=this.em_1
this.Control[iCurrent+4]=this.sle_org_name
this.Control[iCurrent+5]=this.st_14
this.Control[iCurrent+6]=this.st_13
this.Control[iCurrent+7]=this.st_12
this.Control[iCurrent+8]=this.st_11
this.Control[iCurrent+9]=this.sle_user_id3
this.Control[iCurrent+10]=this.sle_user_id2
this.Control[iCurrent+11]=this.sle_user_id1
this.Control[iCurrent+12]=this.st_10
this.Control[iCurrent+13]=this.sle_user_id0
this.Control[iCurrent+14]=this.st_9
this.Control[iCurrent+15]=this.sle_9
this.Control[iCurrent+16]=this.st_8
this.Control[iCurrent+17]=this.sle_window_description
this.Control[iCurrent+18]=this.st_7
this.Control[iCurrent+19]=this.sle_window_title
this.Control[iCurrent+20]=this.st_6
this.Control[iCurrent+21]=this.sle_window_name
this.Control[iCurrent+22]=this.st_5
this.Control[iCurrent+23]=this.sle_organization_id
this.Control[iCurrent+24]=this.st_4
this.Control[iCurrent+25]=this.sle_user_name
this.Control[iCurrent+26]=this.sle_3
this.Control[iCurrent+27]=this.sle_password
this.Control[iCurrent+28]=this.sle_user_id
this.Control[iCurrent+29]=this.st_3
this.Control[iCurrent+30]=this.st_2
this.Control[iCurrent+31]=this.st_1
this.Control[iCurrent+32]=this.sle_selected_data_window
this.Control[iCurrent+33]=this.st_15
this.Control[iCurrent+34]=this.sle_library_name
this.Control[iCurrent+35]=this.st_16
this.Control[iCurrent+36]=this.p_1
this.Control[iCurrent+37]=this.st_17
this.Control[iCurrent+38]=this.sle_iso_tag
this.Control[iCurrent+39]=this.gb_2
this.Control[iCurrent+40]=this.gb_1
end on

on w_who_am_i.destroy
call super::destroy
destroy(this.cb_insert)
destroy(this.sle_user_id5)
destroy(this.em_1)
destroy(this.sle_org_name)
destroy(this.st_14)
destroy(this.st_13)
destroy(this.st_12)
destroy(this.st_11)
destroy(this.sle_user_id3)
destroy(this.sle_user_id2)
destroy(this.sle_user_id1)
destroy(this.st_10)
destroy(this.sle_user_id0)
destroy(this.st_9)
destroy(this.sle_9)
destroy(this.st_8)
destroy(this.sle_window_description)
destroy(this.st_7)
destroy(this.sle_window_title)
destroy(this.st_6)
destroy(this.sle_window_name)
destroy(this.st_5)
destroy(this.sle_organization_id)
destroy(this.st_4)
destroy(this.sle_user_name)
destroy(this.sle_3)
destroy(this.sle_password)
destroy(this.sle_user_id)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_selected_data_window)
destroy(this.st_15)
destroy(this.sle_library_name)
destroy(this.st_16)
destroy(this.p_1)
destroy(this.st_17)
destroy(this.sle_iso_tag)
destroy(this.gb_2)
destroy(this.gb_1)
end on

type p_title from w_none_dw_popup_root`p_title within w_who_am_i
integer width = 3269
end type

type cb_close from w_none_dw_popup_root`cb_close within w_who_am_i
boolean visible = true
integer x = 2985
integer y = 1816
integer taborder = 0
integer weight = 400
end type

type st_msg from w_none_dw_popup_root`st_msg within w_who_am_i
boolean visible = true
integer x = 471
integer y = 1712
integer width = 2789
integer taborder = 1
long backcolor = 16777215
end type

type cb_insert from so_commandbutton within w_who_am_i
integer x = 2574
integer y = 1816
integer width = 402
integer height = 100
integer weight = 400
string text = "Register"
end type

event clicked;INT LVL_COUNT

SELECT COUNT(*)  INTO :LVL_COUNT
 FROM ISYS_WINDOW
 WHERE WINDOW_NAME = :sle_window_name.TEXT 
   AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	
	IF F_SQL_CHECK() < 0 THEN 
		RETURN
	END IF
	
	
  IF LVL_COUNT > 0 THEN 
	
	if gvs_language = 'C' then
			update ISYS_WINDOW
				set WINDOW_DESCRIPTION_LOCAL= :sle_window_description.text
			  WHERE WINDOW_NAME = :sle_window_name.TEXT 
					AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
			
			IF F_SQL_CHECK() < 0 THEN 
				RETURN 
			END IF
			
		elseif gvs_language = 'K' then
			update ISYS_WINDOW
				set WINDOW_DESCRIPTION_KOR= :sle_window_description.text
			  WHERE WINDOW_NAME = :sle_window_name.TEXT 
					AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
			
			IF F_SQL_CHECK() < 0 THEN 
				RETURN 
			END IF			
		else
			
			update ISYS_WINDOW
				set WINDOW_DESCRIPTION_ENG= :sle_window_description.text
			  WHERE WINDOW_NAME = :sle_window_name.TEXT 
					AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
			
			IF F_SQL_CHECK() < 0 THEN 
				RETURN 
			END IF
			
		end if

		 COMMIT ;
 
ELSE
	
	  INSERT INTO "ISYS_WINDOW"  
         ( "WINDOW_NAME",   
           "ORGANIZATION_ID",   
           "WINDOW_TYPE",   
           "VERSION",   
	      "WINDOW_GROUP_LOCAL",		
	      "WINDOW_GROUP_ENG",		
	      "WINDOW_GROUP_KOR",					
           "WINDOW_DESCRIPTION_KOR",   
           "WINDOW_DESCRIPTION_ENG",   
           "WINDOW_DESCRIPTION_LOCAL",   
           "ENTER_BY",   
           "ENTER_DATE",   
           "LAST_MODIFY_BY",   
           "LAST_MODIFY_DATE" )  
  VALUES (  :sle_window_name.TEXT  , :GVI_ORGANIZATION_ID , 'WINDOW' , 1 , 
                 '*' , '*' , '*' , 
                 :sle_window_name.TEXT ,:sle_window_name.TEXT ,:sle_window_name.TEXT ,
			    :GVS_USER_ID , SYSDATE , :GVS_USER_ID , SYSDATE ) ;
				 
				 
 	IF F_SQL_CHECK() < 0 THEN 
		RETURN 
	END IF

	COMMIT ;

END IF
        
////==================================================
////
////==================================================
//LVL_COUNT = 0
//SELECT COUNT(*)  INTO :LVL_COUNT
// FROM ISYS_WINDOW_ISO_TAG
// WHERE WINDOW_NAME = :sle_window_name.TEXT 
//   AND  DATAWINDOW_NAME = :sle_selected_data_window.TEXT
//   AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
//	
//	IF F_SQL_CHECK() < 0 THEN 
//		RETURN
//	END IF
//		
//		
//IF LVL_COUNT  = 0 THEN 		
//	
//	  INSERT INTO "ISYS_WINDOW_ISO_TAG"  
//         ( "WINDOW_NAME",   
//           "DATAWINDOW_NAME",   
//           "ISO_TAG",   
//           "ORGANIZATION_ID",   
//           "ENTER_DATE",   
//           "ENTER_BY",   
//           "LAST_MODIFY_DATE",   
//           "LAST_MODIFY_BY" )  
//  VALUES ( :sle_window_name.text ,   
//           :sle_selected_data_window.text,
//           :sle_iso_tag.text,   
//           :gvi_organization_id,   
//           sysdate,   
//           :gvs_user_id,   
//           sysdate,   
//           :gvs_user_id )  ;
//		   
//	IF F_SQL_CHECK() < 0 THEN 
//		RETURN
//	END IF
//	
//ELSE
//	
// 	UPDATE ISYS_WINDOW_ISO_TAG SET ISO_TAG = :SLE_ISO_TAG.TEXT
//       WHERE WINDOW_NAME = :sle_window_name.TEXT 
//	     AND DATAWINDOW_NAME = :sle_selected_data_window.TEXT
//	     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
//	
//	IF F_SQL_CHECK() < 0 THEN 
//		RETURN
//	END IF
//	
//END IF 

COMMIT ;
F_MSGBOX( 9031) // $$HEX13$$31c1f5ac01c83cc75cb8200001c8a9c618b4c8c5b5c2c8b2e4b2$$ENDHEX$$
end event

type sle_user_id5 from so_singlelineedit within w_who_am_i
integer x = 1463
integer y = 260
integer width = 521
integer height = 56
integer weight = 700
long textcolor = 255
long backcolor = 16777215
string text = " System Version :"
boolean border = false
boolean autohscroll = false
end type

type em_1 from so_editmask within w_who_am_i
integer x = 2011
integer y = 260
integer height = 56
long textcolor = 255
long backcolor = 16777215
boolean border = false
alignment alignment = center!
end type

event constructor;this.text = String(Gvf_system_version)
end event

type sle_org_name from so_singlelineedit within w_who_am_i
integer x = 2085
integer y = 1396
integer width = 1143
integer weight = 700
long textcolor = 0
long backcolor = 16777215
boolean autohscroll = false
end type

type st_14 from so_statictext within w_who_am_i
integer x = 1577
integer y = 1396
integer weight = 700
long backcolor = 16777215
boolean enabled = false
string text = "Organization Name"
alignment alignment = right!
end type

type st_13 from so_statictext within w_who_am_i
integer x = 2350
integer y = 1208
integer width = 384
integer height = 76
integer weight = 700
long backcolor = 16777215
boolean enabled = false
string text = "Window Type"
alignment alignment = right!
end type

type st_12 from so_statictext within w_who_am_i
integer x = 1888
integer y = 1292
integer width = 590
integer height = 76
integer weight = 700
long backcolor = 16777215
boolean enabled = false
string text = "Last Modify Date"
alignment alignment = right!
end type

type st_11 from so_statictext within w_who_am_i
integer x = 512
integer y = 1292
integer width = 590
integer height = 76
integer weight = 700
long backcolor = 16777215
boolean enabled = false
string text = "Creation Date"
alignment alignment = right!
end type

type sle_user_id3 from so_singlelineedit within w_who_am_i
integer x = 2747
integer y = 1192
integer width = 480
integer height = 92
integer weight = 700
long textcolor = 8388608
long backcolor = 16777215
boolean autohscroll = false
end type

type sle_user_id2 from so_singlelineedit within w_who_am_i
integer x = 2066
integer y = 1188
integer width = 274
integer height = 92
integer weight = 700
long textcolor = 8388608
long backcolor = 16777215
boolean autohscroll = false
end type

type sle_user_id1 from so_singlelineedit within w_who_am_i
integer x = 2514
integer y = 1292
integer width = 713
integer height = 92
integer weight = 700
long textcolor = 8388608
long backcolor = 16777215
boolean autohscroll = false
end type

type st_10 from so_statictext within w_who_am_i
integer x = 507
integer y = 1208
integer width = 590
integer height = 64
integer weight = 700
long backcolor = 16777215
boolean enabled = false
string text = "Maker"
alignment alignment = right!
end type

type sle_user_id0 from so_singlelineedit within w_who_am_i
integer x = 1134
integer y = 1292
integer width = 709
integer height = 92
integer weight = 700
long textcolor = 8388608
long backcolor = 16777215
boolean autohscroll = false
end type

type st_9 from so_statictext within w_who_am_i
integer x = 1774
integer y = 1208
integer width = 274
integer height = 76
integer weight = 700
long backcolor = 16777215
boolean enabled = false
string text = "Version"
alignment alignment = right!
end type

type sle_9 from so_singlelineedit within w_who_am_i
integer x = 1129
integer y = 1192
integer width = 640
integer height = 92
integer weight = 700
long textcolor = 8388608
long backcolor = 16777215
boolean autohscroll = false
end type

type st_8 from so_statictext within w_who_am_i
integer x = 507
integer y = 1108
integer width = 590
integer height = 76
integer weight = 700
long backcolor = 16777215
boolean enabled = false
string text = "Window Description"
alignment alignment = right!
end type

type sle_window_description from so_singlelineedit within w_who_am_i
integer x = 1129
integer y = 1092
integer width = 2103
integer height = 92
integer weight = 700
long textcolor = 8388608
long backcolor = 16777215
end type

type st_7 from so_statictext within w_who_am_i
integer x = 507
integer y = 1008
integer width = 590
integer height = 76
integer weight = 700
long backcolor = 16777215
boolean enabled = false
string text = "Window Title"
alignment alignment = right!
end type

type sle_window_title from so_singlelineedit within w_who_am_i
integer x = 1129
integer y = 992
integer width = 2103
integer height = 92
integer weight = 700
long textcolor = 8388608
long backcolor = 16777215
boolean autohscroll = false
end type

type st_6 from so_statictext within w_who_am_i
integer x = 507
integer y = 788
integer width = 590
integer height = 76
integer weight = 700
long backcolor = 16777215
boolean enabled = false
string text = "Window Name"
alignment alignment = right!
end type

type sle_window_name from so_singlelineedit within w_who_am_i
integer x = 1129
integer y = 772
integer width = 1669
integer height = 92
integer weight = 700
long textcolor = 8388608
long backcolor = 16777215
textcase textcase = upper!
end type

type st_5 from so_statictext within w_who_am_i
integer x = 681
integer y = 1396
integer width = 439
integer weight = 700
long backcolor = 16777215
boolean enabled = false
string text = "Organization ID"
alignment alignment = right!
end type

type sle_organization_id from so_singlelineedit within w_who_am_i
integer x = 1134
integer y = 1396
integer width = 439
integer weight = 700
long textcolor = 8388736
long backcolor = 16777215
boolean autohscroll = false
end type

type st_4 from so_statictext within w_who_am_i
integer x = 754
integer y = 556
integer width = 334
integer height = 76
integer weight = 700
long backcolor = 16777215
boolean enabled = false
string text = "User Name "
alignment alignment = right!
end type

type sle_user_name from so_singlelineedit within w_who_am_i
integer x = 1111
integer y = 548
integer width = 443
integer weight = 700
long textcolor = 8388736
long backcolor = 16777215
boolean autohscroll = false
end type

type sle_3 from so_singlelineedit within w_who_am_i
integer x = 2350
integer y = 548
integer width = 443
integer weight = 700
long textcolor = 8388736
long backcolor = 16777215
boolean autohscroll = false
end type

type sle_password from so_singlelineedit within w_who_am_i
integer x = 2350
integer y = 440
integer width = 439
integer weight = 700
long textcolor = 8388736
long backcolor = 16777215
boolean autohscroll = false
boolean password = true
end type

type sle_user_id from so_singlelineedit within w_who_am_i
integer x = 1111
integer y = 440
integer width = 443
integer weight = 700
long textcolor = 8388736
long backcolor = 16777215
boolean autohscroll = false
end type

type st_3 from so_statictext within w_who_am_i
integer x = 1792
integer y = 556
integer width = 526
integer height = 76
integer weight = 700
long backcolor = 16777215
boolean enabled = false
string text = "User Authority"
alignment alignment = right!
end type

type st_2 from so_statictext within w_who_am_i
integer x = 1792
integer y = 452
integer width = 526
integer height = 76
integer weight = 700
long backcolor = 16777215
boolean enabled = false
string text = "Password"
alignment alignment = right!
end type

type st_1 from so_statictext within w_who_am_i
integer x = 754
integer y = 452
integer width = 334
integer height = 76
integer weight = 700
long backcolor = 16777215
boolean enabled = false
string text = "User ID"
alignment alignment = right!
end type

type sle_selected_data_window from so_singlelineedit within w_who_am_i
integer x = 1129
integer y = 888
integer width = 1669
integer height = 92
boolean bringtotop = true
integer weight = 700
long textcolor = 8388608
long backcolor = 16777215
textcase textcase = upper!
end type

type st_15 from so_statictext within w_who_am_i
integer x = 507
integer y = 888
integer width = 590
integer height = 76
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
boolean enabled = false
string text = "Selected Data Window"
alignment alignment = right!
end type

type sle_library_name from so_singlelineedit within w_who_am_i
integer x = 1138
integer y = 1492
integer width = 2094
boolean bringtotop = true
integer weight = 700
long textcolor = 8388736
long backcolor = 16777215
end type

type st_16 from so_statictext within w_who_am_i
integer x = 681
integer y = 1500
integer width = 439
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
boolean enabled = false
string text = "Library Name"
alignment alignment = right!
end type

type p_1 from picture within w_who_am_i
integer x = 9
integer y = 376
integer width = 448
integer height = 1428
boolean bringtotop = true
string picturename = "infor_left.jpg"
boolean focusrectangle = false
end type

type st_17 from so_statictext within w_who_am_i
integer x = 681
integer y = 1604
integer width = 439
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
boolean enabled = false
string text = "ISO Tag"
alignment alignment = right!
end type

type sle_iso_tag from so_singlelineedit within w_who_am_i
integer x = 1138
integer y = 1596
integer width = 2094
boolean bringtotop = true
integer weight = 700
long textcolor = 8388736
long backcolor = 16777215
end type

type gb_2 from so_groupbox within w_who_am_i
integer x = 466
integer y = 696
integer width = 2802
integer height = 1020
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
string text = "Window Information"
end type

type gb_1 from so_groupbox within w_who_am_i
integer x = 466
integer y = 352
integer width = 2798
integer height = 332
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
string text = "User Information"
end type

