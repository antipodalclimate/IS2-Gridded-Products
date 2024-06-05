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
    disp('----------------------------------')
    fprintf('Doing the %s \n',OPTS.hemi);

    % Directory where processed files will be saved. This specifies the
    % hemisphere and the grid used in the product.
    OPTS.save_dir = fullfile(OPTS.processing_loc,OPTS.hemi,OPTS.gridname);

    % Each file should have a corresponding geophysical file
    % (which contains lat, lon, strong beam data, etc)
    geo_files = dir(fullfile(OPTS.save_dir,'GEO','*.mat'));
    load(fullfile(geo_files(1).folder,geo_files(1).name),'GEODATA')

    % These are for dimensions of the outgoing h5 file
    OPTS.nyears = str2num(geo_files(end).name(1:4)) - 2017;
    OPTS.nx = size(GEODATA.lat,1);
    OPTS.ny = size(GEODATA.lat,2);
    %%

    %

    compile_wrapper(OPTS,PROCESSES);

end

