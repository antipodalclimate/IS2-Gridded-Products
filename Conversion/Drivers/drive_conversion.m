% Initialize parallel pool if required
try

    parpool();

catch 


end
% Change for local system. 
Code_loc = '/Users/chorvat/Code/IS2-Gridded-Products';

% Location of all Data. Fullfile adds the correct slash. 
data_loc = fullfile(Code_loc,'Data','All_Track_Data');

% Add location of conversion code

addpath(fullfile(Code_loc,'Conversion'));


% Hemispheric file directories
filedirs = {fullfile(data_loc, 'NH/'), fullfile(data_loc, 'SH/')};

% Hemispheric save directories
savedirs = { fullfile(Code_loc,'Data','Beam_Data_Mat/NH'), fullfile(Code_loc,'Data','Beam_Data_Mat/SH')};

% IS2 beam identifies
beam_names = {'gt1r','gt1l','gt2r','gt2l','gt3r','gt3l'};

% Decide if existing files should be replaced
DO_REPLACE = true;

%%

% Loop through hemisphere directories
for i = 1:2
    % Loop through years
    for yr = 2018:2024
        % Loop through months
        for mo = 1:12
            % Execute conversion in parallel for each beam
            for beamind = 1:6
           
                % Format year and month strings
                yrstr = num2str(yr);
                mostr = sprintf('%02d', mo); % Pad month with zero if needed

                % Generate full save path for the current beam
                save_str = fullfile(savedirs{i}, [yrstr mostr '-beam-' beam_names{beamind} '.mat']);

                if ~DO_REPLACE
                
                    disp(['Checking For Existing Converted Files At ' save_str]);

                    % Attempt to load the mat file to check existence
                 
                    try
             
                        MF = matfile(save_str);
                        disp(['Already exists at ' save_str]);
                   
                    catch err
                        disp(['Does not exist at ' save_str]);
                        % Call function to convert data if file does not exist
                        convert_IS2_data_bybeam(yr, mo, beamind, filedirs{i}, save_str);
                  
                    end
              
                else
           
                    disp(['Not Checking: Replacing Anything at ' save_str]);
          
                    % Call function to convert data regardless of existence
                    convert_IS2_data_bybeam(yr, mo, beamind, filedirs{i}, save_str);
             
                end
    
            end
  
        end

    end

end