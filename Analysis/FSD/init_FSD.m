% Initialization of FSD code. 

% These are the core output files for each track. 

ALL_floelengths = []; % A vector of floe lengths
ALL_floeids = []; % A vector of floe ids
ALL_floe_seglengths = []; % A vector of floe segment lengths
ALL_usable_floes = []; % A list of all usable floes

OPTS.FSD = struct(); 
OPTS.FSD.min_length = 30; % Minimum average floe length
OPTS.FSD.max_seg_length = 100; % Maximum average seg length 
OPTS.FSD.min_nsegs = 3; % Minimum number of ATL07 segments to be a floe
