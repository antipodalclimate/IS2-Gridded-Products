%% drive_conversion.m
% Function that drives the conversion of all netcdf-based data.

% Initialize parallel pool if required
DO_PARALLEL = 0;

% Decide if existing files should be replaced
DO_REPLACE = 0;

if DO_PARALLEL

    try

        parpool(gcp('nocreate'));

    catch


    end

end

% Change for local system.
Code_loc = dir(fullfile('..','..')).folder;

% Code_loc = '/gpfs/data/epscor/chorvat/IS2/IS2-Gridded-Products/'
% Location of all Data. Fullfile adds the correct slash.
data_loc = fullfile(Code_loc,'Data','All_Track_Data');

% Add location of conversion code

addpath(fullfile(Code_loc,'Conversion/'));


% Hemispheric file directories. To be changed in future iteration when it
% becomes necessary. Should just search through files using data_loc/*/*.nc
% for example
filedirs = {fullfile(data_loc, 'NH/'), fullfile(data_loc, 'SH/')};

% Hemispheric save directories. Keep this I think for simplicity.
savedirs = { fullfile(Code_loc,'Data','Beam_Data_Mat/NH'), fullfile(Code_loc,'Data','Beam_Data_Mat/SH')};

% IS2 beam identifies
beam_names = {'gt1r','gt1l','gt2r','gt2l','gt3r','gt3l'};

%% Main conversion loop
% This is written as a separate function do_conversion to allow for
% switching between the parallel or serial codes in testing.

% Loop through hemisphere directories
for i = 2:2
    % Loop through years
    for yr = 2018:2024
        % Loop through months
        for mo = 1:12
            % Execute conversion in parallel for each beam if required
            if DO_PARALLEL
                parfor beamind = 1:6
                    do_conversion(i,yr,mo,beamind,filedirs,savedirs,beam_names,DO_REPLACE);
                end
            else
                for beamind = 1:6
                    do_conversion(i,yr,mo,beamind,filedirs,savedirs,beam_names,DO_REPLACE);
                end
            end
        end

    end

end

function do_conversion(i,yr,mo,beamind,filedirs,savedirs,beam_names,DO_REPLACE);

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
