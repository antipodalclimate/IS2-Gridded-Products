data_loc = '/gpfs/data/epscor/chorvat/IS2/All_Tracks_NetCDF/'

filedirs = {[data_loc '/NH/'],[data_loc '/SH/']};

savedirs = {'/gpfs/data/epscor/chorvat/IS2/Data_By_Beam/NH/','/gpfs/data/epscor/chorvat/IS2/Data_By_Beam/SH/'};

beam_names = {'gt1r','gt1l','gt2r','gt2l','gt3r','gt3l'};

DO_REPLACE = false;
%%
parpool()



for i = 2:-1:1
    for yr = 2022:-1:2018
        for mo = 12:-1:1
            parfor beamind = 1:6
                
%%                 
                yrstr = num2str(yr);
                
                mostr=num2str(mo);
                if mo<10, mostr=['0',mostr]; end
                
                save_str = [savedirs{i} yrstr mostr '-beam-' beam_names{beamind} '.mat']
                

		if ~DO_REPLACE 

		disp(['Checking For Existing Converted Files At ' save_str])                

		try
                    
                    MF = matfile(save_str);
                    p = size(MF,'fields')
                    disp(['Already exists at ' save_str])
                
	 	
		
        
	        catch err
               
	            disp(['Doesnt Exist at ' save_str])
                    convert_IS2_data_bybeam(yr,mo,beamind,filedirs{i},savedirs{i});

                    
                end
                
		else
		   disp(['Not Checking: Replacing Anything at ' save_str])	
 		   convert_IS2_data_bybeam(yr,mo,beamind,filedirs{i},savedirs{i});
		 end
                
            end
            
        end
        
    end
    
end




