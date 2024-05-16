function analyse_file(file_path,PROCESSES,gridname)
% Code that helps with the analysis of a single .mat file that corresponds
% to a month and beam of aggregated IS2 data.

% Here is the data itself.
IS2data = matfile(file_path);

%% Now we want to perform various functions on the data.
% Because we don't care about the tracks themselves, we want to create a
% long vector which has lat/lon/height. We do this by concatenating all
% of the beams together.

fieldmat = IS2data.fields;
load(file_path,'timer');

% Fieldmat is nseg x nfields - for every segment we have
% latitude/longitude/elevation/segment length/photon rate/freeboard

if numel(fieldmat) == 0
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

% Here we do some initialization needed by any process code

numtracks = length(timer); % Number of tracks
earthellipsoid = referenceSphere('earth','m'); % For distance computation

init_ALL; 

% Initialize information needed for each process.
for i = 1:length(PROCESSES)
    if PROCESSES(i).DO_ANALYSIS == 1
        run([PROCESSES(i).code_folder '/init_' PROCESSES(i).name '.m'])
    end
end

%% Now start the main loop

for i = 1:numtracks % for every track

    % First compute distance along track using lat and lon coordinates

    tmp_lat = fieldmat{i,ID.lat};
    tmp_lon = fieldmat{i,ID.lon};

    if length(tmp_lat) > 1 % along-track distance
        % These are effectively the along-track distances between central
        % points in each segment.
        tmp_dist = distance([tmp_lat(1:end-1) tmp_lon(1:end-1)],[tmp_lat(2:end) tmp_lon(2:end)],earthellipsoid);
    else
        tmp_dist = [];
    end

    % We exclude heights greater than 1km and segments that are too long,
    % and segments that are overlapping, to start. We will exclude others later.
    usable = find(abs(fieldmat{i,ID.height}) < 1000 ...
        & fieldmat{i,ID.length} < OPTS.max_seg_size ...
        & [tmp_dist(1); tmp_dist] > 0.5);

    % Distance is now the sum of distances
    if length(tmp_lat) > 1
        tmp_dist = [0; cumsum(tmp_dist)];
    end

    % total number of segments in the track.
    num_segs = length(tmp_dist);
    num_usable_segs = sum(usable);

    %% Preprocess The track
    % Remove unphysical values
    try

        tmp_lat = tmp_lat(usable);
        tmp_lon = tmp_lon(usable);
        tmp_dist = tmp_dist(usable);

    catch

        disp(['CHRIS IS WORKING ON AN ERROR FOR SHORT TRACK DISTANCES NT is ' i]);
        tmp_dist = [];

    end

    % Now sort by distance.

    [tmp_dist,sort_ind] = sort(tmp_dist); % Sort the distance to be increasing.

    usable_vector = cat(1,usable_vector,usable + lenct);   

    % Sorting vector so can be put in order
    sortvec = cat(1,sortvec,sort_ind+length(sortvec));

    % Dedupe and sort ice vector
    is_ice = fieldmat{i,ID.type};
    is_ice = is_ice(usable);
    is_ice = is_ice(sort_ind);

    % Get the ID of each track
    ID_unique = 0*is_ice + i;

    idvec = cat(1,idvec,ID_unique);

    % Ocean is the stuff that isn't ice.
    is_ocean = is_ice > 1;

    %% Now we do the specific calculations for along-track data 
    for i = 1:length(PROCESSES)
        
        if PROCESSES(i).DO_ANALYSIS == 1
            run(fullfile(PROCESSES(i).code_folder,['analyse_' PROCESSES(i).name]))
        end

    end
end

