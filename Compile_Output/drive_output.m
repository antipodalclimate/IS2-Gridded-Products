% This code processes collected track data, bins it into lat-lon bins,
% and produces gridded maps of relevant data.

% Input:
%   save_path - Directory of the .mat file created by previous code.

% Ensure to run config_all first in the home code directory
run(fullfile(OPTS.code_loc, 'config_all.m'));

% Loop over hemispheres and files
for hemi_ind = 1:length(OPTS.hemi_dir)
    OPTS.hemi = OPTS.hemi_dir{hemi_ind};
    disp('----------------------------------')
    fprintf('Processing hemisphere: %s\n', OPTS.hemi);

    % Directory where processed files will be saved
    % Specifies the hemisphere and the grid used in the product
    OPTS.save_dir = fullfile(OPTS.processing_loc, OPTS.hemi, OPTS.gridname);

    % Each file should have a corresponding geophysical file
    % (which contains lat, lon, strong beam data, etc)
    geo_files = dir(fullfile(OPTS.save_dir, 'GEO', '*.mat'));
    load(fullfile(geo_files(1).folder, geo_files(1).name), 'GEODATA')

    % Define dimensions for the output h5 file
    OPTS.nyears = str2num(geo_files(end).name(1:4)) - 2017;
    OPTS.nx = size(GEODATA.lat, 1);
    OPTS.ny = size(GEODATA.lat, 2);

    % Call the wrapper function to compile data
    compile_wrapper(OPTS, PROCESSES);
end

% Wrapper function to compile data
function compile_wrapper(OPTS, PROCESSES)

fprintf('Calculating general statistics\n')

OUT = struct();

% Loop over years and months
for yr_ind = 1:OPTS.nyears

    fprintf('\n Year %d: Month',yr_ind + 2017)

    for mo_ind = 1:12
        fprintf(' %d ',mo_ind)
        yrstr = num2str(yr_ind + 2017);
        mostr = sprintf('%02d', mo_ind); % Pad month with zero if needed

        GEO_files = dir(fullfile(OPTS.save_dir, 'GEO', [yrstr mostr '*.mat']));
        TEMP = struct();

        if ~isempty(GEO_files)
            compile_general;

            % Process each specific module's task
            for proc_ind = 1:length(PROCESSES)
                if PROCESSES(proc_ind).DO_COMPILE == 1
                    run([PROCESSES(proc_ind).code_folder '/compile_' PROCESSES(proc_ind).name '.m'])
                end
            end
        end
    end
end

% Write output data to file
disp('Saving')
write_output(OPTS, OUT, GEODATA);

end

% Function to write output data to HDF5 file
function write_output(OPTS, OUT, GEODATA)
OPTS.h5_name = fullfile(OPTS.output_loc, ['IS2_Data_' OPTS.gridname '_' OPTS.hemi '.h5']);

if exist(OPTS.h5_name, 'file')
    delete(OPTS.h5_name);
end

h5create(OPTS.h5_name, '/latitude', size(GEODATA.lat));
h5write(OPTS.h5_name, '/latitude', GEODATA.lat);

h5create(OPTS.h5_name, '/longitude', size(GEODATA.lat));
h5write(OPTS.h5_name, '/longitude', GEODATA.lon);

proc_fields = fieldnames(OUT);

for proc_ind = 1:length(proc_fields)
 
    save_str = ['/' proc_fields{proc_ind}];

    out_fields = fieldnames(OUT.(proc_fields{proc_ind}));

    for field_ind = 1:length(out_fields)

        save_field = OUT.(proc_fields{proc_ind}).(out_fields{field_ind});

        h5create(OPTS.h5_name, [save_str '/' out_fields{field_ind}], size(save_field), 'FillValue', 0);
        h5write(OPTS.h5_name, [save_str '/' out_fields{field_ind}], save_field);

    end
end
end