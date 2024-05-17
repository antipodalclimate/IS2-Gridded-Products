% Here are indices corresponding to specific file components
% Used to track which field is which.
% These should be verified in convert_IS2_data_bybeam.m
ID = struct();
ID.height = 1;
ID.length = 2;
ID.lat = 3;
ID.lon = 4;
ID.prate = 5;
ID.type = 6;
ID.ssh = 7;
ID.conc_SSMI = 8;
ID.conc_AMSR = 9;

% Identify local moving average
OPTS.window_1k = 1000; % 1km window
OPTS.window_10k = 10000; % 10km window
OPTS.window_50k = 50000; % 50km window
OPTS.max_seg_size = 200; % Maximum size for individual segments to be kept

ALL_sorter = []; % Will be used to sort the matfile
ALL_usable = []; % Indicates when a segment is included
ALL_ids = []; % Identification of segment
ALL_rgts = []; % Identify the RGT for each file
ALL_beamstrength = []; % Identify if the beam is strong or weak. 

% Total segments - counted progressively
STATS.lenct = 0;
STATS.len_dupe_ct = 0; 

STATS.timer = load(file_path,'timer').timer;
STATS.track_cycle = load(file_path,'track_cycle').track_cycle;

if load(file_path,'track_cycle').track_cycle;

STATS.numtracks = length(STATS.timer); % Number of tracks
STATS.earthellipsoid = referenceSphere('earth','m'); % For distance computation
