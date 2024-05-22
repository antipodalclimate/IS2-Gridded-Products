clear;

% Change for local system.
% This should do it, if the code is run in the Driver folder.
OPTS.code_loc = dir(fullfile('..')).folder;

% Location of all Data. Fullfile adds the correct slash.
OPTS.output_loc = fullfile(OPTS.code_loc,'Output');

OPTS.gridname = '25km';

