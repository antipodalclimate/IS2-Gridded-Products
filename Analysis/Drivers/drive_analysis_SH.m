% This code takes the collected track data, bins it into lat-lon bins,
% and then produces gridded maps of relevant data
%
% Input:
%   save_path - Directory of the .mat file created by previous code.

clear;

% Change for local system.
% This should do it, if the code is run in the Driver folder.
OPTS.code_loc = dir(fullfile('..','..')).folder;

% Location of all Data. Fullfile adds the correct slash.
OPTS.data_loc = fullfile(OPTS.code_loc,'Data','Beam_Data_Mat');
OPTS.processing_loc = fullfile(OPTS.code_loc,'Data','Processed_Data');
OPTS.analysis_loc = fullfile(OPTS.code_loc,'Analysis/');

OPTS.voluble = 0; 

OPTS.gridname = '25km';

addpath(OPTS.analysis_loc);

% Configuration
hemi_dir = {'NH', 'SH'};

PROCESSES = struct('name',{'FSD','WAVES','LIF'}, ...
    'DO_REPLACE',{0,0,0}, ...
    'code_folder',{fullfile(OPTS.analysis_loc,'FSD'),fullfile(OPTS.analysis_loc,'WAVES'),fullfile(OPTS.analysis_loc,'LIF')});

% Looping over hemispheres and files
for hemi_ind = 2:length(hemi_dir)
    
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
    mkdir(save_dir);
end

if ~exist(fullfile(save_dir,'GEO'), 'dir')
    mkdir(fullfile(save_dir,'GEO'));
end

for i = 1:length(PROCESSES)


    if ~exist(fullfile(save_dir, PROCESSES(i).name), 'dir')

        mkdir(fullfile(save_dir, PROCESSES(i).name));


    end


end

end

function DO_ANALYSIS = shouldProcessFile(save_loc, DO_REPLACE,name)
% Determine whether to process the file based on existence and DO_REPLACE flag

% If the file exists and we don't want to replace it, don't analyse it.
if exist(save_loc, 'file') == 2 && ~DO_REPLACE
    disp([name 'files already exist: ' save_loc]);
    DO_ANALYSIS = 0;

else

    % If it doesn't exists, or we do want to replace anything, let's go for
    % it.
    % disp(['Saving ' name ' files to ' save_loc]);
    DO_ANALYSIS = 1;

end

end
