clearvars -except OPTS PROCESSES

% config_all - for running analysis/conversion/compilation scripts

% Change for local system.
% This should do it, if the code is run in the Driver folder.
OPTS.code_loc = dir(fullfile('.')).folder;
% Location of all Data. Fullfile adds the correct slash.

% Version we care about
OPTS.version_string = 'v5'; 

% Location of .h5 files which contain the actual ATL07 granules
OPTS.track_loc = fullfile(OPTS.code_loc,'Data','All_Track_Data',OPTS.version_string);

% Location of .mat files which aggregate tracks into months/beams
OPTS.data_loc = fullfile(OPTS.code_loc,'Data','Beam_Data_Mat',OPTS.version_string);

% Where the processed (gridded .mat data) ends up
OPTS.processed_data_loc = fullfile(OPTS.code_loc,'Data','Processed_Data',OPTS.version_string);

% Data where we identify the modules we want to use
OPTS.process_loc = fullfile(OPTS.code_loc,'Processes/');

% Data for netcdf output 
OPTS.output_loc = fullfile(OPTS.code_loc,'Output/');

OPTS.voluble = 0; 
OPTS.gridname = '25km';

OPTS.DO_PARALLEL_CONVERSION = 0; 
OPTS.DO_REPLACE_CONVERSION = 1; 

% Configuration
OPTS.hemi_dir = {'NH', 'SH'};

% Now process configuration
PROCESSES = struct('name',{'FSD','WAVES','LIF'}, ...
    'DO_REPLACE',{1,1,1}, ...
    'DO_COMPILE',{1,1,1}, ...
    'code_folder',{fullfile(OPTS.process_loc,'FSD'),fullfile(OPTS.process_loc,'WAVES'),fullfile(OPTS.process_loc,'LIF')});
