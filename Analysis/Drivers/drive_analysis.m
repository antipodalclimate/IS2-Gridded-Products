% This code takes the collected track data, bins it into lat-lon bins,
% and then produces gridded maps of relevant data
%
% Input:
%   save_path - Directory of the .mat file created by previous code.

clear;

% Change for local system.
Code_loc = '/Users/chorvat/Code/IS2-Gridded-Products/';
% Code_loc = '/gpfs/data/epscor/chorvat/IS2/IS2-Gridded-Products/'
% Location of all Data. Fullfile adds the correct slash.
data_loc = fullfile(Code_loc,'Data','Beam_Data_Mat');
output_loc = fullfile(Code_loc,'Output');
analysis_loc = fullfile(Code_loc,'Analysis/');

addpath(analysis_loc ...
    ); 

% Configuration
hemi_dir = {'NH', 'SH'};
gridname = '25km';

PROCESSES = struct('name',{'FSD','WAVES','LIF'}, ...
    'DO_REPLACE',{1,1,1}, ...
    'code_folder',{fullfile(analysis_loc,'FSD'),fullfile(analysis_loc,'WAVES'),fullfile(analysis_loc,'LIF')});

% Looping over hemispheres and files
for hemi_ind = 1:length(hemi_dir)

    % List the files in each hemisphere
    files = dir(fullfile(data_loc,hemi_dir{hemi_ind}, '*.mat'));

    % Directory where processed files will be saved. This specifies the
    % hemisphere and the grid used in the product.
    save_dir = fullfile(output_loc,hemi_dir{hemi_ind},gridname);

    % Create the save directories
    create_directories(save_dir,PROCESSES);

    % For every individual file, need to ascertain where the data will be
    % saved and whether there exists data there already that we don't want
    % to overwrite. DO_REPLACE flags tell us not to overwrite data if it is
    % found there.
    for file_ind = 1:length(files)

        file_dir = files(file_ind).folder;
        file_name = files(file_ind).name;

        for proc_ind = 1:length(PROCESSES)

            temp_save_loc = fullfile(save_dir,PROCESSES(proc_ind).name,files(file_ind).name);

            PROCESSES(proc_ind).DO_ANALYSIS = shouldProcessFile(temp_save_loc,PROCESSES(proc_ind).DO_REPLACE,PROCESSES(proc_ind).name);

        end

        if sum([PROCESSES(:).DO_ANALYSIS]) > 0

            % This runs the analysis code for the given beam/month, subject
            % to whatever we have passed for PROCESSES and using the grid
            % we identify. 
            analyse_file(fullfile(file_dir, file_name), PROCESSES,gridname);

        end

    end

end


function create_directories(save_dir,PROCESSES)
% Create necessary directories for saving processed files

if ~exist(save_dir, 'dir')
    mkdir(save_dir);
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