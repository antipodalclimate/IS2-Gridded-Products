function analyse_file(file_path,PROCESSES,OPTS)
% Code that helps with the analysis of a single .mat file that corresponds
% to a month and beam of aggregated IS2 data.

% Here is the data itself.
DATA = matfile(file_path);

%% Now we want to perform various functions on the data.
% Because we don't care about the tracks themselves, we want to create a
% long vector which has lat/lon/height. We do this by concatenating all
% of the beams together.

DATA = DATA.fields;


% DATA is ntracks x nfields - for every segment we have
% latitude/longitude/elevation/segment length/photon rate/freeboard

if numel(DATA) == 0
    % Don't waste our time with files with no data.

    return


end

disp('-----------------------------------------');
disp(['Processing file: ' file_path]);

%%
% Now we initialize the required pieces. We will keep all data in the
% current workspace because some of it is duplicative. So we have separate
% calls to init and analysis codes for each component we wish to add. The
% only requirement is that new pieces added should not conflict with
% pre-existing variables. This potentially should be avoided using
% structures (WAVES.height, or similar). For now we will not add this but
% note it to be changed in the future if the code enjoys wider adoption.

% We have two types of files
% AT_X is the along-track version of field X consisting of raw data
% These are processed in the first analyse_P call. These might be shared
% across processed.

% ALL_X is the version of field X accumulated across multiple RGTs/Beams
% These are processed in the grid_P call.

% Variables with no first capitalized part are internal to any process.
% They should be contained to that piece of the code itself. We may opt to
% wipe those fields later.

init_setup;

% Initialize information needed for each process.
for proc_ind = 1:length(PROCESSES)
    if PROCESSES(proc_ind).DO_ANALYSIS == 1
        run([PROCESSES(proc_ind).code_folder '/init_' PROCESSES(proc_ind).name '.m'])
    end
end

%% Now start the main loop - analysis on each track.

for track_ind = 1:STATS.numtracks % for every track

    % First compute distance along track using lat and lon coordinates

    track_rgt = STATS.track_cycle(track_ind);
    beamflag = STATS.beamflag(track_ind);

    AT_lat = DATA{track_ind,ID.lat};
    AT_lon = DATA{track_ind,ID.lon};

    if length(AT_lat) > 1 % along-track distance
        % These are effectively the along-track distances between central
        % points in each segment.
        AT_dist = distance([AT_lat(1:end-1) AT_lon(1:end-1)],[AT_lat(2:end) AT_lon(2:end)],STATS.earthellipsoid);
        % We exclude heights greater than 1km and segments that are too long,
        % and segments that are overlapping, to start. We will exclude others later.
        usable = find(abs(DATA{track_ind,ID.height}) < 1000 ...
            & DATA{track_ind,ID.length} < OPTS.max_seg_size ...
            & [AT_dist(1); AT_dist] > 0.5);
        AT_dist = [0; cumsum(AT_dist)];


    else
        
        
        usable = []; 
        AT_dist = 0;
    
    end


    % Distance is now the sum of distances
    if length(AT_lat) > 1
    end

    % total number of segments in the track.
    num_segs = length(AT_dist);
    num_usable_segs = length(usable);

    %% Preprocess The track
    % Remove unphysical values
    try

        AT_lat = AT_lat(usable);
        AT_lon = AT_lon(usable);
        AT_dist = AT_dist(usable);

    catch

        disp(['CHRIS IS WORKING ON AN ERROR FOR SHORT TRACK DISTANCES NT is ' track_ind]);
        AT_dist = [];

    end

    % Now sort by distance.

    [AT_dist,sort_ind] = sort(AT_dist); % Sort the distance to be increasing.

    ALL_usable = cat(1,ALL_usable,usable + STATS.lenct);

    % Sorting vector so can be put in order
    ALL_sorter = cat(1,ALL_sorter,sort_ind+length(ALL_sorter));

    %% All along-track raw data will have the prefix AT

    % Dedupe and sort ice vector
    AT_is_ice = DATA{track_ind,ID.type}(usable(sort_ind));

    % Dedupe and sort height vector
    AT_height = DATA{track_ind,ID.height}(usable(sort_ind));

    % Dedupe and sort segment length vector
    AT_seg_len = DATA{track_ind,ID.length}(usable(sort_ind));

    % Get the ID of each track at the resolution of each segment.
    id_unique = 0*AT_is_ice + track_ind;
    rgt_unique = 0*AT_is_ice + track_rgt;
    beamflag_unique = 0*AT_is_ice + beamflag;

    ALL_ids = cat(1,ALL_ids,id_unique);
    ALL_rgts = cat(1,ALL_rgts,rgt_unique);
    ALL_beamflag = cat(1,ALL_beamflag,beamflag_unique);

    % Ocean is the stuff that isn't ice.
    AT_is_ocean = AT_is_ice > 1;

    %% Now we do the specific calculations for along-track data
    for proc_ind = 1:length(PROCESSES)

        if PROCESSES(proc_ind).DO_ANALYSIS == 1

            run(fullfile(PROCESSES(proc_ind).code_folder,['analyse_' PROCESSES(proc_ind).name]))

        end

    end

    % This adds the unusable vector by the size of the field
    STATS.lenct = STATS.lenct + num_segs;
    STATS.len_usable = STATS.len_usable + num_usable_segs;
    STATS.num_segs(track_ind) = num_segs;
    STATS.num_usable_segs(track_ind) = num_usable_segs;


    clearvars -except ALL_* STATS OPTS PROCESSES DATA ID track_ind 

    % %% Now we do the calculations for taking along-track data to gridded data


end

%% Now we move to the calculations which are across all segments in this area/time.

grid_general; 

fprintf('Gridding Process Data: ')

for proc_ind = 1:length(PROCESSES)

    if PROCESSES(proc_ind).DO_ANALYSIS == 1

        run(fullfile(PROCESSES(proc_ind).code_folder,['grid_' PROCESSES(proc_ind).name]))

    end

end

disp('Done');