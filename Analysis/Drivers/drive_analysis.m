%% Analyse_frac_wave_affected
% This code takes the collected track data, the subsetted data, bins it
% into lat-lon bins, and then produces maps of the fraction of those bins
% that are affected by waves.

% Input require save_path - which is the directory of the .mat file created
% by previous code.

<<<<<<< HEAD
clear

file_heading = './';

hemi_dir = {'NH','SH',};

DO_WAVES = 1;
DO_FSD = 1;
DO_REPLACE = 0;

% try
%  parpool()
% catch err
%   err
% end
%%

gridname = '25km';

addpath('../Processing/');

for i = 1:2 % length(hemi_dir)
    
    file_dir = [file_heading hemi_dir{i}];
    
    files = dir([file_dir '/*.mat']);
    
    % Overall place where we will save each file
    save_dir = [file_heading 'Processed/' hemi_dir{i} '-' gridname '/'];
    
=======
% Change for local system.
% This should do it, if the code is run in the Driver folder. 
OPTS.code_loc = dir(fullfile('..','..')).folder;

% Location of all Data. Fullfile adds the correct slash.
OPTS.data_loc = fullfile(OPTS.code_loc,'Data','Beam_Data_Mat');
OPTS.output_loc = fullfile(OPTS.code_loc,'Output');
OPTS.analysis_loc = fullfile(OPTS.code_loc,'Analysis/');
OPTS.gridname = '25km'; 

addpath(OPTS.analysis_loc); 

% Configuration
hemi_dir = {'NH', 'SH'};

PROCESSES = struct('name',{'FSD','WAVES','LIF'}, ...
    'DO_REPLACE',{1,1,1}, ...
    'code_folder',{fullfile(OPTS.analysis_loc,'FSD'),fullfile(OPTS.analysis_loc,'WAVES'),fullfile(OPTS.analysis_loc,'LIF')});

% Looping over hemispheres and files
for hemi_ind = 1:length(hemi_dir)

    OPTS.hemi = hemi_dir{hemi_ind}; 

    % List the files in each hemisphere
    files = dir(fullfile(OPTS.data_loc,OPTS.hemi, '*.mat'));

    % Directory where processed files will be saved. This specifies the
    % hemisphere and the grid used in the product.
    OPTS.save_dir = fullfile(OPTS.output_loc,OPTS.hemi,OPTS.gridname);

    % Create the save directories
    create_directories(OPTS.save_dir,PROCESSES);

    % For every individual file, need to ascertain where the data will be
    % saved and whether there exists data there already that we don't want
    % to overwrite. DO_REPLACE flags tell us not to overwrite data if it is
    % found there.
    for file_ind = 1:length(files)

        file_dir = files(file_ind).folder;
        file_name = files(file_ind).name;

        OPTS.save_GEO = fullfile(OPTS.save_dir,'GEO',files(file_ind).name);

        for proc_ind = 1:length(PROCESSES)

            OPTS.save_loc{proc_ind} = fullfile(OPTS.save_dir,PROCESSES(proc_ind).name,files(file_ind).name);

            PROCESSES(proc_ind).DO_ANALYSIS = shouldProcessFile(OPTS.save_loc{proc_ind},PROCESSES(proc_ind).DO_REPLACE,PROCESSES(proc_ind).name);

        end

        if sum([PROCESSES(:).DO_ANALYSIS]) > 0

            % This runs the analysis code for the given beam/month, subject
            % to whatever we have passed for PROCESSES and using the grid
            % we identify. 
            analyse_file(fullfile(file_dir, file_name),PROCESSES,OPTS);

        end

    end

end


function create_directories(save_dir,PROCESSES,OPTS)
% Create necessary directories for saving processed files

if ~exist(save_dir, 'dir')
>>>>>>> distributed_analysis_scripts
    mkdir(save_dir);
    mkdir([save_dir 'WAVES/']);
    mkdir([save_dir 'FSD/']);
    
    % par
    for filename = 1:length(files)% :-1:1
        
        disp('-----------------------------------------');
        disp(['File at ' file_dir files(filename).name(1:end-4)]);
        
        % Specific file save name
        save_loc_waves = [save_dir 'WAVES/' files(filename).name];
        save_loc_fsd = [save_dir 'FSD/' files(filename).name];
        
        
        if (exist([save_loc_waves]) == 2) & (~DO_REPLACE)
            
            make_waves = 0;
            disp('Already There At ');
            disp(save_loc_waves);      
        else
            
            make_waves = 1;
            disp(['Saving wave files to ' save_loc_waves]);
            
        end
       
    
    if DO_FSD
        
        if (exist([save_loc_fsd]) == 2) & (~DO_REPLACE)
            
            make_fsd = 0;
            disp('Already There');
            
        else
            
            make_fsd = 1;
            
            disp(['Saving FSD files to ' save_loc_fsd]);
            
        end
        
    else
	make_fsd = 0; 
end

if ~exist(fullfile(save_dir,'GEO'), 'dir')
    mkdir(fullfile(save_dir,'GEO'));
end

for i = 1:length(PROCESSES)

if make_fsd + make_waves > 0
   
    analyse_waves_and_FSD([file_dir '/' files(filename).name], ...
        save_loc_waves,save_loc_fsd,gridname,make_waves,make_fsd);

end    

    end
    
end
