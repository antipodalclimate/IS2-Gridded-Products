function convert_IS2_data_bybeam(year, month, beamind, filedir, save_str)
% Converts and saves data from ATL07 netcdf files.
%
% Inputs:
%   year      - Year of the data
%   month     - Month of the data
%   beamind   - Index of the beam to load
%   filedir   - Directory of the HDF5 files
%   save_str  - Filename to save the .mat file
%
% Outputs:
%   Saves a .mat file with the fields:
%   - field_names: Names of each field in fields
%   - fields: Segment-based data (cell array)
%   - timer: Character array with start time of each track
%   - beam_names: Names of the beams

[data_loc,~,~] = fileparts(filedir);

% Beam names
beam_names = {'gt1r', 'gt1l', 'gt2r', 'gt2l', 'gt3r', 'gt3l'};

% Field names we wish to convert to the .mat format by month/beam
field_names = {
    'sea_ice_segments/heights/height_segment_height', ...
    'sea_ice_segments/heights/height_segment_length_seg', ...
    'sea_ice_segments/latitude', ...
    'sea_ice_segments/longitude', ...
    'sea_ice_segments/stats/photon_rate', ...
    'sea_ice_segments/heights/height_segment_type', ...
    'sea_ice_segments/heights/height_segment_ssh_flag', ...
    'sea_ice_segments/stats/ice_conc_ssmi', ...
    'sea_ice_segments/stats/ice_conc_amsr2'
    };

% Formatting year and month
yrstr = num2str(year);
mostr = sprintf('%02d', month);

% Obtaining all .h5 files in the directory
ATL07_files = dir([filedir '*ATL07-0*_' yrstr mostr '*.nc']);
ngranules = length(ATL07_files);
nfields = length(field_names);

% Initialize the output fields
fields = cell(ngranules, nfields);
timer = cell(ngranules, 1);
beamflag = nan(ngranules,1); % Indicates whether a strong or weak beam
track_date = nan(ngranules,1);
track_cycle = nan(ngranules,1);

% Process each file
for fileind = 1:ngranules
    if mod(fileind, 100) == 1
        fprintf('Time: %d/%d, Beam %s, File %d of %d \n', month, year,beam_names{beamind},fileind, ngranules);
    end

    splitname = split(ATL07_files(fileind).name,'_'); 
    
    track_date(fileind) = datenum(splitname{3},'YYYYmmDDHHMMss');
    track_cycle(fileind) = str2num(splitname{4});

    filename_ATL07 = fullfile(filedir, ATL07_files(fileind).name);
    corrupt_file = false;

    try
       
        timer{fileind} = h5readatt(filename_ATL07, '/', 'time_coverage_start');

        tmp = h5readatt(filename_ATL07, ['/' beam_names{beamind} '/'], 'atlas_beam_type');
        
        if strcmp(tmp,'weak')
            beamflag(fileind) = 0;
        else
            beamflag(fileind) = 1;
        end

        for fieldind = 1:nfields
            fields{fileind, fieldind} = double(zeros(0, 1));
            if ~corrupt_file
                try
                    fields{fileind, fieldind} = double(h5read(filename_ATL07, ['/' beam_names{beamind} '/' field_names{fieldind}]));
                catch errread
                    fprintf('Error reading field %d (%s) in file %s\n', fieldind, field_names{fieldind}, filename_ATL07);
                    disp(errread.message);
                    
                    if ~exist(fullfile(data_loc,'Corrupted'), 'dir')

                        mkdir(fullfile(data_loc,'Corrupted'));


                    end

                    movefile(filename_ATL07, fullfile(OPTS.data_loc,'Corrupted'));
                    disp('Moved to Corrupted folder');
                    corrupt_file = true;
                end
            end
        end
    catch timerrread
        disp('Error reading time coverage start attribute:');
        disp(timerrread.message);
        movefile(filename_ATL07, fullfile(data_loc,'Corrupted'));
        disp('Moved to Corrupted folder');
    end
end

% Save results
save(save_str, 'field_names', 'fields', 'timer', 'beam_names','track_cycle','track_date','beamflag','-v7.3');
end