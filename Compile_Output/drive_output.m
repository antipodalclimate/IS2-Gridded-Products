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

    compile_wrapper(OPTS,PROCESSES);

end

function compile_wrapper(OPTS,PROCESSES)

fprintf('General statistics \n')

OUT = struct();

for yr_ind = 1:OPTS.nyears

    for mo_ind = 1:12

        % Now try to create the relevant fields.


        yrstr = num2str(yr_ind + 2017);
        mostr = sprintf('%02d', mo_ind); % Pad month with zero if needed

        GEO_files = dir(fullfile(OPTS.save_dir,'GEO',[yrstr mostr '*.mat']));

        TEMP = struct();

        if ~isempty(GEO_files)


            compile_GEO;

            % Now do for specific processes.

            for proc_ind = 1:length(PROCESSES)
                % Each process is analysed in the same month

                if PROCESSES(proc_ind).DO_COMPILE == 1

                    % Run the file given proc_files.
                    run([PROCESSES(proc_ind).code_folder '/compile_' PROCESSES(proc_ind).name '.m'])

                end

            end


        end

    end

end

%%

write_output(OPTS,OUT);

end

function write_output(OPTS,OUT)

OPTS.h5_name = fullfile(OPTS.output_loc,['IS2_Data_' OPTS.gridname '_' OPTS.hemi '.h5']);

if exist(OPTS.h5_name,'file')

    delete(OPTS.h5_name);

end

h5create(OPTS.h5_name,'/latitude',size(GEODATA.lat));
h5write(OPTS.h5_name,'/latitude',GEODATA.lat);

h5create(OPTS.h5_name,'/longitude',size(GEODATA.lat));
h5write(OPTS.h5_name,'/longitude',GEODATA.lon);

proc_fields = fieldnames(OUT);

for proc_ind = 1:length(proc_fields)
    % Each OUT field is another structure.

    save_str = ['/' proc_fields{proc_ind}];

    out_fields = fieldnames(eval(['OUT.' proc_fields{proc_ind}]));

    for field_ind = 1:length(out_fields)

        save_field = eval(['OUT.' proc_fields{proc_ind} '.' out_fields{field_ind}]);

        h5create(OPTS.h5_name,[save_str '/' out_fields{field_ind}],size(save_field),'Fillvalue',0);
        h5write(OPTS.h5_name, [save_str '/' out_fields{field_ind}],save_field);

    end

end


end