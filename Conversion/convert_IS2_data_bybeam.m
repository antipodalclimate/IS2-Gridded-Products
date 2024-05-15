function convert_IS2_data_bybeam(year,month,beamind,filedir,save_str)
%% Code that loads in data from the ATL10 hdf5 files - bulky, yes, but necessary
% to susequently use all Matlab processing. The saved data is contained in
% two arrays which have consistent dimensions that can be segmented by
% common matrix commands.

% Optional input - save_path - a filename where the .mat file will be saved
% will be defaulted to Data.mat if not applied

% Output - a file $savename$.mat, which contains
% fields - a cell array Ntracks x Nbeams x Nfields for segment-based data
% lead_fields - a cell array Ntracks x Nbeams x Nfields for lead-based data
% timer - a character array Ntracks x 28 in size - each row describes the
% data on which the track began.

% field_names - a cell array with the name of each field in fields
% lead_field_names - " for lead_fields

%% Options are listed in this code block

% Directory of the files to consider - will load in all .h5 files in that
% directory

% Which beams to load in
beam_names = {'gt1r','gt1l','gt2r','gt2l','gt3r','gt3l'};

% Data that is read in on a per-segment basis
field_names = ...
    { ... % Get the ice segment information
    'sea_ice_segments/heights/height_segment_height' ...
    'sea_ice_segments/heights/height_segment_length_seg', ...
    'sea_ice_segments/latitude', ...
    'sea_ice_segments/longitude', ...
    'sea_ice_segments/stats/photon_rate', ... %    'freeboard_beam_segment/beam_freeboard/beam_fb_height', ...
    'sea_ice_segments/heights/height_segment_type', ...
    'sea_ice_segments/heights/height_segment_ssh_flag', ...
    'sea_ice_segments/stats/ice_conc_ssmi', ...
    'sea_ice_segments/stats/ice_conc_amsr2', ...
    };



yrstr = num2str(year);

mostr=num2str(month);
if month<10, mostr=['0',mostr]; end

% Obtains all .h5 files in that directory
% [filedir '*ATL07-0*_' yrstr mostr '*.nc']

% Because indexing is the same, and filenames are the same, these should
% follow each other.

ATL07_files = dir([filedir '*ATL07-0*_' yrstr mostr '*.nc']);

ngranules = length(ATL07_files);
nfields = length(field_names);

%% Initialize the output fields

fields = cell(ngranules,nfields);
timer = cell(ngranules,1);

%%
for fileind = 1:ngranules
 
    if mod(fileind,100) == 1
        
        fprintf('Month %d in %d, File %d of %d \n',month,year, fileind,length(ATL07_files));
        
    end
    
    % Respective file names
    filename_ATL07 = [filedir ATL07_files(fileind).name];
    
    corrupt_file = false; 

    % Load in start of track
    try

        timer{fileind} = h5readatt(filename_ATL07,'/','time_coverage_start');
             
    % For all segment-indexed fields
    for fieldind = 1:nfields

	fields{fileind,fieldind} = double(zeros(0,1));  
        
 	if ~corrupt_file

	try
            
            fields{fileind,fieldind} = double(h5read(filename_ATL07,['/' beam_names{beamind} '/' field_names{fieldind}]));
            
        catch errread

            fprintf('Filename is %s \n',filename_ATL07)
            fprintf('Field is number %d, named %s \n',fieldind,field_names{fieldind}); 
            disp(errread.message)
            movefile(filename_ATL07,'/gpfs/data/epscor/chorvat/IS2/All_Tracks_NetCDF/Corrupted/')
 	    disp('Moved to Corrupted folder'); 
	    corrupt_file = true; 
            
        end
        
	end

    end

    catch timerrread
        disp('WE HAVE A GODDAMN ERROR RIGHT HERE');
        filename_ATL07
        disp(timerrread)
        disp('END OF ERROR');
        movefile(filename_ATL07,'/gpfs/data/epscor/chorvat/IS2/All_Tracks_NetCDF/Corrupted/')
        disp('Moved to Corrupted folder');

    end

    
end

%%

% Convert the timing cell array to a character array as all inputs have the
% same dimensions
%timer = cell2mat(timer);

% if ngranules > 0
    
    save(save_str,'field_names','fields','timer','beam_names','-v7.3');
    
% end

end
