% config_all - for running analysis/conversion/compilation scripts

% Change for local system.
% This should do it, if the code is run in the Driver folder.
OPTS.code_loc = dir(fullfile('.')).folder;
% Location of all Data. Fullfile adds the correct slash.
OPTS.data_loc = fullfile(OPTS.code_loc,'Data','Beam_Data_Mat');
OPTS.processing_loc = fullfile(OPTS.code_loc,'Data','Processed_Data');
OPTS.analysis_loc = fullfile(OPTS.code_loc,'Analysis/');

OPTS.output_loc = fullfile(OPTS.code_loc,'Output/');

OPTS.voluble = 0; 
OPTS.gridname = '25km';
% Location of all Data. Fullfile adds the correct slash.
OPTS.processing_loc = fullfile(OPTS.code_loc,'Data','Processed_Data');
OPTS.save_loc = fullfile(OPTS.code_loc,'Output');

OPTS.voluble = 0;

OPTS.gridname = '25km';

% Configuration
OPTS.hemi_dir = {'NH', 'SH'};

% Now process configuration
PROCESSES = struct('name',{'FSD','WAVES','LIF'}, ...
    'DO_REPLACE',{0,0,0}, ...
    'code_folder',{fullfile(OPTS.analysis_loc,'FSD'),fullfile(OPTS.analysis_loc,'WAVES'),fullfile(OPTS.analysis_loc,'LIF')});
