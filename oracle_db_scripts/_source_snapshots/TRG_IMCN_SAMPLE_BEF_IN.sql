TRIGGER "INFINITY21_JSMES".TRG_IMCN_SAMPLE_BEF_IN
  before insert on imcn_sample  
  for each row
declare
  -- local variables here
begin
  
  if ( :new.verification_state1 = '*' ) then
    
       :new.verification_date1 := NULL;
       
  end if;
  
  if ( :new.verification_state2 = '*' ) then
    
       :new.verification_date2 := NULL;
       
  end if;
  
  if ( :new.verification_state3 = '*' ) then
    
       :new.verification_date3 := NULL;
       
  end if;
  
  if ( :new.verification_state4 = '*' ) then
    
       :new.verification_date4 := NULL;
       
  end if;
  
  if ( :new.verification_state5 = '*' ) then
    
       :new.verification_date5 := NULL;
       
  end if;
  
  if ( :new.verification_state6 = '*' ) then
    
       :new.verification_date6 := NULL;
       
  end if;

end;
