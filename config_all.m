clearvars -except OPTS PROCESSES

% config_all - for running analysis/conversion/compilation scripts

% Change for local system.
% This should do it, if the code is run in the Driver folder.
OPTS.code_loc = dir(fullfile('.')).folder;
% Location of all Data. Fullfile adds the correct slash.
OPTS.data_loc = fullfile(OPTS.code_loc,'Data','Beam_Data_Mat');

% Where the processed (gridded .mat data) ends up
OPTS.processed_data_loc = fullfile(OPTS.code_loc,'Data','Processed_Data');

% Data where we identify the modules we want to use
OPTS.process_loc = fullfile(OPTS.code_loc,'Processes/');

% Data for netcdf output 
OPTS.output_loc = '/Users/chorvat/Dropbox (Brown)/Research Projects/Active/Data/ICESat-2/Gridded-Products-Data/';

% OPTS.output_loc = fullfile(OPTS.code_loc,'Output/');

OPTS.voluble = 0; 
OPTS.gridname = '25km';

OPTS.voluble = 0;

OPTS.gridname = '25km';

% Configuration
OPTS.hemi_dir = {'NH', 'SH'};

% Now process configuration
PROCESSES = struct('name',{'FSD','WAVES','LIF'}, ...
    'DO_REPLACE',{1,1,1}, ...
    'DO_COMPILE',{1,1,1}, ...
    'code_folder',{fullfile(OPTS.process_loc,'FSD'),fullfile(OPTS.process_loc,'WAVES'),fullfile(OPTS.process_loc,'LIF')});
