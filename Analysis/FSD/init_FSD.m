% Initialization of FSD code. 

% These are the core output files for each track. 

all_floelengths = []; % A vector of floe lengths
all_floeids = []; % A vector of floe ids
all_floe_seglengths = []; % A vector of floe segment lengths
all_usable_floes = []; % A list of all usable floes

OPTS.FSD = struct(); 
OPTS.FSD.min_length = 30; % Minimum average floe length
OPTS.FSD.max_seg_length = 100; % Maximum average seg length 
OPTS.FSD.min_nsegs = 3; % Minimum number of ATL07 segments to be a floe
