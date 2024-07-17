%% Required things for any beam-month

% The general end product is a segmentation of each track into floes with
% their specified location/length/segment count and corresponding index.

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