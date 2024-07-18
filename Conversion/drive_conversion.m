function drive_conversion(OPTS)

% Function that drives the conversion of all netcdf-based data.

if OPTS.DO_PARALLEL_CONVERSION

    try

        parpool(gcp('nocreate'));

    catch


    end

end

% Add location of conversion code

addpath(fullfile(OPTS.code_loc,'Conversion/'));


% Hemispheric file directories. To be changed in future iteration when it
% becomes necessary. Should just search through files using data_loc/*/*.nc
% for example
filedirs = {fullfile(OPTS.track_loc, 'NH/'), fullfile(OPTS.track_loc, 'SH/')};

% Hemispheric save directories. Keep this I think for simplicity.
savedirs = { fullfile(OPTS.code_loc,'Data','Beam_Data_Mat',OPTS.version_string,'NH'), fullfile(OPTS.code_loc,'Data','Beam_Data_Mat',OPTS.version_string,'SH')};

% IS2 beam identifies
beam_names = {'gt1r','gt1l','gt2r','gt2l','gt3r','gt3l'};

%% Main conversion loop
% This is written as a separate function do_conversion to allow for
% switching between the parallel or serial codes in testing.

% Loop through hemisphere directories
for i = 1:2
    % Loop through years
    for yr = 2018:2024
        % Loop through months
        for mo = 1:12
            % Execute conversion in parallel for each beam if required
            if OPTS.DO_PARALLEL_CONVERSION
                parfor beamind = 1:6
                    do_conversion(i,yr,mo,beamind,filedirs,savedirs,beam_names,OPTS.DO_REPLACE_CONVERSION);
                end
            else
                for beamind = 1:6
                    do_conversion(i,yr,mo,beamind,filedirs,savedirs,beam_names,OPTS.DO_REPLACE_CONVERSION);
                end
            end
        end

    end

end

end

function do_conversion(i,yr,mo,beamind,filedirs,savedirs,beam_names,DO_REPLACE)

% Format year and month strings
yrstr = num2str(yr);
mostr = sprintf('%02d', mo); % Pad month with zero if needed

% Generate full save path for the current beam
save_str = fullfile(savedirs{i}, [yrstr mostr '-beam-' beam_names{beamind} '.mat']);

if ~DO_REPLACE

    fprintf('\n Checking %s ',[yrstr mostr '-beam-' beam_names{beamind} '.mat ---- ']);

    % Attempt to load the mat file to check existence

    if exist(save_str,'file')

        fprintf('Exists');

    else

        fprintf('Doesnt exist ');
        % Call function to convert data if file does not exist

        convert_IS2_data_bybeam(yr, mo, beamind, filedirs{i}, save_str);

    end

else

    fprintf('\n Replacing %s ',[yrstr mostr '-beam-' beam_names{beamind} '.mat']);

    % Call function to convert data regardless of existence
    convert_IS2_data_bybeam(yr, mo, beamind, filedirs{i}, save_str);

end

end
