%% Analysis script for wave process

if isempty(AT_dist(AT_is_ocean))

    dist_to_ssh = nan*AT_dist;

else

    [~,dist_to_ssh] = knnsearch(dist(AT_is_ocean),AT_dist);
end

if sum(AT_is_ocean) > 1

    % This is the interpolated SSH field, on all of the dist places
    ssh_interp = interp1(AT_dist(AT_is_ocean),AT_height(AT_is_ocean),AT_dist);


else

    ssh_interp = nan*AT_dist;

end

% How far away is the nearest SSH point.
ALL_ssh_neighbors = cat(1,ALL_ssh_neighbors,dist_to_ssh);

% Index of points in this window
pts = length(ALL_ssh_neighbors)-length(AT_seg_len)+1:length(ALL_ssh_neighbors);

%% Objects interpolated on the 50km moving window
% Total wave energy and SSH

% SSH
ALL_ssh = cat(1,ALL_ssh,ssh_interp); % movmean(ssh_interp,window_50k,'samplepoints',dist));

% Moving average wave energy
% Number of SSH points within that window

ALL_moving_en = cat(1,ALL_moving_en,movmean((AT_height-ALL_ssh(pts)).^2 .* AT_seg_len,OPTS.window_50k,'samplepoints',AT_dist));

%% Objects interpolated on the 10km moving window
% Standard deviation of Height

% height_moving_avg = cat(1,height_moving_avg,movmean(height,window_variance,'samplepoints',dist));
ALL_height_moving_std = cat(1,ALL_height_moving_std,movstd(AT_height,OPTS.window_10k,'samplepoints',AT_dist));

ALL_moving_ssh_no = cat(1,ALL_moving_ssh_no,movsum(AT_is_ocean,OPTS.window_10k,'samplepoints',AT_dist));

ALL_ssh_moving_std = cat(1,ALL_ssh_moving_std,movstd(ssh_interp,OPTS.window_10k,'samplepoints',AT_dist));


%% Objects interpolated on the 1km moving window

% Negative values of adjusted SSH
isneg = AT_height - ALL_ssh(pts) < 0;

ALL_moving_neg = cat(1,ALL_moving_neg,movsum(isneg,OPTS.window_1k,'samplepoints',AT_dist));
ALL_moving_pos = cat(1,ALL_moving_pos,movsum(~isneg,OPTS.window_1k,'samplepoints',AT_dist));

