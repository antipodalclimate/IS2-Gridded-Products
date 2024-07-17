%% super_driver.m 
% Running this takes .h5 data, converts to matlab-specific format, analyses
% along-track variables, grids it, and produces a netcdf output. All in
% one!

clear

%% configuration script. 
% This will also be called in individual drivers which might be run on
% their own without the overall driver

% This creates two files
% OPTS - which is a structure containing options for running the code
% PROCESSES - a structure containing info about which analysis we will
% perform. Editing config_all should help control what you want as output
config_all; 


%% Convert data
addpath(fullfile(OPTS.code_loc,'Conversion/'));
drive_conversion(OPTS);

%% Do gridding of data
addpath(fullfile(OPTS.code_loc,'Gridding/'));
drive_gridding;

%% Compile the output to netcdf
addpath(fullfile(OPTS.code_loc,'Compile_Output'));
drive_output; 

% And we're done! 