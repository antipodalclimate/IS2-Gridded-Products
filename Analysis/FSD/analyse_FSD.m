%% FSD-related things

% The general end product is a segmentation of each track into floes with
% their specified location/length/segment count and corresponding index. 

% This makes a vector of when we transition onto and off of a floe. 

up = strfind([0,is_ocean'],[0 1]);
down = strfind([is_ocean',0],[1 0]);

if ~isempty(up)
    
    % If there is a switch from ocean to ice. 

    % Remove any that are isolated single points. Repeated with "usable"
    % later. 
    % toosmall = intersect(up,down);
    % up = setxor(up,toosmall)';
    % down = setxor(down,toosmall)';

    % Location of up
    Uloc = up - 1;
    Uloc(Uloc==0) = 1;

    floe_length = tmp_dist(down) - tmp_dist(up);
    floe_ind = round(.5*(down + up));
    floe_seglength = floe_length./(down - up)';
    floe_nsegs = (down - up)';


else

    floe_length = [];
    floe_ind = [];
    floe_seglength = [];
    floe_nsegs = [];

end

%%

% Floe definition of usable. 
usable_floe = logical((floe_length > OPTS.FSD.min_length).* ...
    (floe_seglength < OPTS.FSD.max_seg_length).* ...
    (floe_nsegs >= OPTS.FSD.min_nsegs));

usable_floe(1) = 0; % exclude endpoints
usable_floe(end) = 0; % exclude endpoints

% Naive - need at least 3 segments
floe_length = floe_length(usable_floe);
floe_ind = floe_ind(usable_floe);
floe_seglength = floe_seglength(usable_floe); 
floe_nsegs = floe_nsegs(usable_floe); 

all_floeids = cat(1,all_floeids,floe_ind + lenct);
all_floelengths = cat(1,all_floelengths,floelen_0);
all_floe_seglengths = cat(1,all_floe_seglengths,floe_seglength_0);
all_usable_floes = cat(1,all_usable_floes,usable_floe);