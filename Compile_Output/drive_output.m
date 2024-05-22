% This code takes the collected track data, bins it into lat-lon bins,
% and then produces gridded maps of relevant data
%
% Input:
%   save_path - Directory of the .mat file created by previous code.

% must run config_all first in the home code directory
clearvars -except OPTS PROCESSES

% Looping over hemispheres and files
for hemi_ind = 1:length(OPTS.hemi_dir)

    OPTS.hemi = OPTS.hemi_dir{hemi_ind};

    % List the files in each hemisphere
    proc_files = dir(fullfile(OPTS.processing_loc,OPTS.hemi, '*.mat'));

    % Directory where processed files will be saved. This specifies the
    % hemisphere and the grid used in the product.
    OPTS.save_dir = fullfile(OPTS.processing_loc,OPTS.hemi,OPTS.gridname);
    OPTS.netcdf_name = fullfile(OPTS.output_loc,['IS2_Data_' OPTS.gridname '_' OPTS.hemi '.nc']);

    for proc_ind = 1:length(PROCESSES)

        proc_files = dir(fullfile(OPTS.save_dir,PROCESSES(proc_ind).name,'*.mat'));
   
        run([PROCESSES(proc_ind).code_folder '/compile_' PROCESSES(proc_ind).name '.m'])

    end

    % For every individual file, need to ascertain where the data will be
    % saved and whether there exists data there already that we don't want
    % to overwrite. DO_REPLACE flags tell us not to overwrite data if it is
    % found there.
    for file_ind = 1:length(proc_files)

        file_dir = proc_files(file_ind).folder;
        file_name = proc_files(file_ind).name;

        OPTS.save_GEO = fullfile(OPTS.save_dir,'GEO',proc_files(file_ind).name);



    end

    if sum([PROCESSES(:).DO_ANALYSIS]) > 0

       
    end

end

