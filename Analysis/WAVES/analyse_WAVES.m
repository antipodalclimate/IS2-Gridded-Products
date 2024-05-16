%% Analysis script for wave process

% How far away is the nearest SSH point.
ssh_neighbors = cat(1,ssh_neighbors,dist_to_ssh);


% Index of points in this window
pts = length(ssh_neighbors)-length(seg_len)+1:length(ssh_neighbors);

%% Objects interpolated on the 50km moving window
% Total wave energy and SSH

% SSH
ssh = cat(1,ssh,ssh_interp); % movmean(ssh_interp,window_50k,'samplepoints',dist));

% Moving average wave energy
% Number of SSH points within that window

moving_en = cat(1,moving_en,movmean((height-ssh(pts)).^2 .* seg_len,window_50k,'samplepoints',dist));


%% Objects interpolated on the 10km moving window
% Standard deviation of Height

% height_moving_avg = cat(1,height_moving_avg,movmean(height,window_variance,'samplepoints',dist));
height_moving_std = cat(1,height_moving_std,movstd(height,window_10k,'samplepoints',dist));

moving_ssh_no = cat(1,moving_ssh_no,movsum(is_ocean,window_10k,'samplepoints',dist));

ssh_moving_std = cat(1,ssh_moving_std,movstd(ssh_interp,window_10k,'samplepoints',dist));


%% Objects interpolated on the 1km moving window

% Negative values of adjusted SSH
isneg = height - ssh(pts) < 0;

moving_neg = cat(1,moving_neg,movsum(isneg,window_1k,'samplepoints',dist));
moving_pos = cat(1,moving_pos,movsum(~isneg,window_1k,'samplepoints',dist));
