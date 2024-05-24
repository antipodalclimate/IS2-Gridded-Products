% This code takes the collected track data, bins it into lat-lon bins,
% and then produces gridded maps of relevant data
%
% Input:
%   save_path - Directory of the .mat file created by previous code.

% must run config_all first in the home code directory

run(fullfile(OPTS.code_loc,'config_all.m')); 

% Looping over hemispheres and files
for hemi_ind = 1:length(OPTS.hemi_dir)

    OPTS.hemi = OPTS.hemi_dir{hemi_ind};

    % List the files in each hemisphere
    proc_files = dir(fullfile(OPTS.processing_loc,OPTS.hemi, '*.mat'));



    % Directory where processed files will be saved. This specifies the
    % hemisphere and the grid used in the product.
    OPTS.save_dir = fullfile(OPTS.processing_loc,OPTS.hemi,OPTS.gridname);
    OPTS.netcdf_name = fullfile(OPTS.output_loc,['IS2_Data_' OPTS.gridname '_' OPTS.hemi '.nc']);

    if exist(OPTS.netcdf_name,'file')

        delete(OPTS.netcdf_name);

    end

    % Each process file should also have a corresponding geophysical file
    % (which contains lat, lon, strong beam data, etc)
    geo_files = dir(fullfile(OPTS.save_dir,'GEO','*.mat'));

    load(fullfile(geo_files(1).folder,geo_files(1).name),'GEODATA')

    h5create(OPTS.netcdf_name,'/latitude',size(GEODATA.lat));
    h5create(OPTS.netcdf_name,'/longitude',size(GEODATA.lat));

    h5write(OPTS.netcdf_name,'/latitude',GEODATA.lat);
    h5write(OPTS.netcdf_name,'/longitude',GEODATA.lon);

    OPTS.nyears = str2num(geo_files(end).name(1:4)) - 2017; 
    OPTS.nx = size(GEODATA.lat,1); 
    OPTS.ny = size(GEODATA.lat,2); 
    %% 
    compile_GEO(OPTS);

    for proc_ind = 1:length(PROCESSES)

        proc_files = dir(fullfile(OPTS.save_dir,PROCESSES(proc_ind).name,'*.mat'));

        % Run the file given proc_files.
%         run([PROCESSES(proc_ind).code_folder '/compile_' PROCESSES(proc_ind).name '.m'])

    end

end

