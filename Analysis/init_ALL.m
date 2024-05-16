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

sortvec = []; % Will be used to sort the matfile
usable_vector = []; % Indicates when a segment is included
idvec = []; % Identification of segment

% Total segments - counted progressively
lenct = 0;
len_dupe_ct = 0; 