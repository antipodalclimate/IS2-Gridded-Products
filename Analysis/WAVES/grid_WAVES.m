%% This code produces the gridded wave products


% Multiple for WAL
Mval = (.5 - (1/pi)*asin(ssh./moving_en + 1/sqrt(2))).^(-1);
Mval(abs(imag(Mval)) > 0) = 0;
Mval(isnan(Mval)) = 0;
Mval = min(Mval,10);

% Compute the fraction of all measurements (by length or number) that are
% "wave-affected"

% First eliminate all segments larger than 1 km - may be artificially big
not_too_long =fieldmat(:,length_id)<max_seg_size;

% Need to have two ssh points within 10 km
close_to_ssh = (moving_ssh_no >= 2);%  .* (ssh_neighbors <= window_10k);

% Need to know that the multi-surfaces are near each other.
has_single_surface = abs(fieldmat(:,exm1_id) - fieldmat(:,exm2_id)) ...
    < exmax_diff_threshold;

% Minimum threshold on moving std
wave_cutoff_ssh = max(ssh_moving_std,.1);
wave_cutoff_height = max(height_moving_std,.1);
both_cutoff_height = max(wave_cutoff_ssh,wave_cutoff_height);

% ice if tagged as sea ice by ATL07
is_ice = fieldmat(:,type_id) == 1;

% adjust for deviation from local ssh
height_adjusted = fieldmat(:,height_id) - ssh;

% Not too long, is ice, and has positive moving average
naive_reasonable = logical(not_too_long .* is_ice);

% Has positive points nearby
close_to_positive = moving_pos >= 2;
% Has negative points nearby - only for those values that are negative
close_to_negative = moving_neg >= 2;

% Included points have positive points nearby, aren't too long, and are
% identified as ice. Criteria I1-I2.
is_included = logical(not_too_long .* is_ice .* close_to_positive);

% Included points have positive points nearby, and aren't too long. Criteria I1.
is_included_lead = logical(not_too_long .* close_to_positive);

%%
% Wave candidates are those i|ncluded segs close to ssh points, and
% close to other negative values.
is_wave_candidate = logical(is_included .*close_to_ssh.* ...
    close_to_negative);

% Only include if there is a single surface
is_single_candidate = is_wave_candidate .* has_single_surface;

% Different metrics for being wave-affected

% Just negative, ice, and not too long.
naive_under = logical((fieldmat(:,height_id) < 0).*is_wave_candidate);

% Adjusted height is negative
is_under = logical((height_adjusted < 0).*is_wave_candidate);

% Height is negative beyond ssh or height variance
is_under_ssh_var = logical((height_adjusted < -wave_cutoff_ssh).*is_wave_candidate);
is_under_height_var = logical((height_adjusted < -wave_cutoff_height).*is_wave_candidate);
is_under_both_ex = logical((height_adjusted < -both_cutoff_height).*is_single_candidate);
is_under_both_var = logical((height_adjusted < -both_cutoff_height).*is_wave_candidate);

%%

% Take total length of negative elevations divided by total length of all
% segments. Multiply by two because all troughs have crests.
wave_area_frac_naive = 2 * sum(fieldmat(naive_under,2)) / sum(fieldmat(is_ice,2));
wave_area_frac = 2 * sum(fieldmat(is_under,2)) / sum(fieldmat(is_ice,2));
wave_area_frac_ssh = 2 * sum(fieldmat(is_under_ssh_var,2)) / sum(fieldmat(is_ice,2));
wave_area_frac_height = 2 * sum(fieldmat(is_under_height_var,2)) / sum(fieldmat(is_ice,2));
wave_area_frac_both = 2 * sum(fieldmat(is_under_both_var,2)) / sum(fieldmat(is_ice,2));
wave_area_frac_M_height = 2 * sum(Mval(is_under_height_var).*fieldmat(is_under_height_var,2)) / sum(fieldmat(is_ice,2));
wave_area_frac_both_ex = 2 * sum(fieldmat(is_under_both_ex,2)) / sum(fieldmat(is_ice,2));

% Take total number of negative elevations divided by total number of all
% segments
wave_num_frac_naive = 2 * sum(naive_under)/sum(is_ice);
wave_num_frac = 2 * sum(is_under)/sum(is_included);
wave_num_frac_ssh = 2 * sum(is_under_ssh_var)/sum(is_included);
wave_num_frac_height = 2 * sum(is_under_height_var)/sum(is_included);
wave_num_frac_both = 2 * sum(is_under_both_var)/sum(is_included);
wave_num_frac_both_ex = 2 * sum(is_under_both_ex)/sum(is_included);
wave_num_frac_M_height = 2 * sum(Mval.*is_under_height_var)/sum(is_included);

fprintf('\nTotal number of ice segs: %2.1f million \n',sum(is_ice)/1e6)
fprintf('Total number of not-too-long ice segs: %2.1f million \n',sum(naive_reasonable)/1e6)
fprintf('Total number of not-too-long ice segs with positive MA: %2.1f million \n',sum(is_included)/1e6)
fprintf('Total number of wave_candidate ice segs: %2.1f million \n',sum(is_wave_candidate)/1e6)
fprintf('%2.1f percent of all ice segs (by number) have negative heights \n',wave_num_frac_naive*100);
fprintf('%2.1f percent of suitable segs (by number) have negative heights \n',wave_num_frac*100);
fprintf('%2.1f percent of suitable segs (by number) have statistically outlier negative heights vs SSH variance \n',wave_num_frac_ssh*100);
fprintf('%2.1f percent of suitable segs (by number) have statistically outlier negative heights vs height variance \n',wave_num_frac_height*100);
fprintf('%2.1f percent of suitable segs (by number) have statistically outlier negative heights vs both variance \n',wave_num_frac_both*100);
fprintf('%2.1f percent of suitable ex-adjusted segs (by number) have statistically outlier negative heights vs height variance \n',wave_num_frac_both_ex*100);
fprintf('%2.1f percent of M-adjusted suitable segs (by number) have statistically outlier negative heights \n',wave_num_frac_M_height*100);

fprintf('\nTotal length of ice segs: %2.1f km \n',sum(fieldmat(is_ice,2))/1000)
fprintf('Total length of not-too-long ice segs: %2.1f km \n',sum(fieldmat(logical(is_ice.*not_too_long),2))/1000)
fprintf('Total length of not-too-long ice segs with positive MA: %2.1f km \n',sum(fieldmat(is_included,2))/1000)
fprintf('Total length of wave candidate ice segs: %2.1f km \n',sum(fieldmat(is_wave_candidate,2))/1000)
fprintf('%2.1f percent of all ice segs (by length) have negative heights \n',wave_area_frac_naive*100);
fprintf('%2.1f percent of suitable segs (by length) have negative heights \n',wave_area_frac*100);
fprintf('%2.1f percent of suitable segs (by length) have statistically outlier negative heights vs SSH variance \n',wave_area_frac_ssh*100);
fprintf('%2.1f percent of suitable segs (by length) have statistically outlier negative heights vs Height variance \n',wave_area_frac_height*100);
fprintf('%2.1f percent of suitable ex-adjusted segs (by length) have statistically outlier negative heights vs both variance \n',wave_area_frac_both_ex*100);
fprintf('%2.1f percent of suitable segs (by length) have statistically outlier negative heights vs both variance \n',wave_area_frac_both*100);
fprintf('%2.1f percent of M-adjusted suitable segs (by length) have statistically outlier negative heights \n',wave_area_frac_M_height*100);



%% Accumulate all values that are below zero into the chosen lat-lon array

% Look at average freeboard
height_adjusted_geo = accumarray(posloc_all,is_included.*fieldmat(:,length_id).*fieldmat(:,height_id),[numel(lat_X) 1],@sum) ./ ...
    accumarray(posloc_all,is_included.*fieldmat(:,length_id),[numel(lat_X) 1],@sum);

% Take the points that are ok to use - numerator is ice points,
% denominator is all points (not too long and close to ice)
conc_wave_geo = accumarray(posloc_all,is_included.*fieldmat(:,length_id),[numel(lat_X) 1],@sum) ./ ...
    accumarray(posloc_all,is_included_lead.*fieldmat(:,length_id),[numel(lat_X) 1],@sum);

% This adds up all measurements that are reasonable
num_meas_geo = accumarray(posloc_all,is_included,[numel(lat_X) 1],@sum);
naive_num_meas_geo = accumarray(posloc_all,naive_reasonable,[numel(lat_X) 1],@sum);

% This adds up the length of all measurements
len_meas_geo = accumarray(posloc_all,is_included.*fieldmat(:,length_id),[numel(lat_X) 1],@sum);
naive_len_meas_geo = accumarray(posloc_all,naive_reasonable.*fieldmat(:,length_id),[numel(lat_X) 1],@sum);

% This is all measurements below zero (times 2)
num_under_geo = 2*accumarray(posloc_all,is_under,[numel(lat_X) 1],@sum);
naive_num_under_geo = 2*accumarray(posloc_all,naive_under,[numel(lat_X) 1],@sum);
num_ssh_under_geo = 2*accumarray(posloc_all,is_under_ssh_var,[numel(lat_X) 1],@sum);
num_height_under_geo = 2*accumarray(posloc_all,is_under_height_var,[numel(lat_X) 1],@sum);
num_both_under_ex_geo = 2*accumarray(posloc_all,is_under_both_ex,[numel(lat_X) 1],@sum);
num_both_under_geo = 2*accumarray(posloc_all,is_under_both_var,[numel(lat_X) 1],@sum);

% Adds up length of all that are negative (times 2) in each cell
len_under_geo = 2*accumarray(posloc_all,is_under.*fieldmat(:,length_id),[numel(lat_X) 1],@sum);
naive_len_under_geo = 2*accumarray(posloc_all,naive_under.*fieldmat(:,length_id),[numel(lat_X) 1],@sum);
len_ssh_under_geo = 2*accumarray(posloc_all,is_under_ssh_var.*fieldmat(:,length_id),[numel(lat_X) 1],@sum);
len_height_under_geo = 2*accumarray(posloc_all,is_under_height_var.*fieldmat(:,length_id),[numel(lat_X) 1],@sum);
len_both_under_ex_geo = 2*accumarray(posloc_all,is_under_both_ex.*fieldmat(:,length_id),[numel(lat_X) 1],@sum);
len_both_under_geo = 2*accumarray(posloc_all,is_under_both_var.*fieldmat(:,length_id),[numel(lat_X) 1],@sum);

% Don't need to multiply by 2 with M
len_M_ssh_under_geo = accumarray(posloc_all,is_under_ssh_var.*fieldmat(:,length_id).*Mval,[numel(lat_X) 1],@sum);
len_M_height_under_geo = accumarray(posloc_all,is_under_height_var.*fieldmat(:,length_id).*Mval,[numel(lat_X) 1],@sum);
len_M_both_under_geo = accumarray(posloc_all,is_under_both_var.*fieldmat(:,length_id).*Mval,[numel(lat_X) 1],@sum);

% 2-D map of fraction by length in each cell
perc_under_geo = len_under_geo ./ len_meas_geo;
perc_under_geo(num_meas_geo==0) = nan;

perc_ssh_under_geo = len_ssh_under_geo ./ len_meas_geo;
perc_ssh_under_geo(num_meas_geo==0) = nan;

perc_height_under_geo = len_height_under_geo ./ len_meas_geo;
perc_height_under_geo(num_meas_geo==0) = nan;

perc_both_under_ex_geo = len_both_under_ex_geo ./ len_meas_geo;
perc_both_under_ex_geo(num_meas_geo==0) = nan;

perc_M_ssh_under_geo = len_M_ssh_under_geo ./ len_meas_geo;
perc_M_ssh_under_geo(num_meas_geo==0) = nan;

perc_M_height_under_geo = len_M_height_under_geo ./ len_meas_geo;
perc_M_height_under_geo(num_meas_geo==0) = nan;

naive_perc_under_geo = naive_len_under_geo ./ naive_len_meas_geo;
naive_perc_under_geo(naive_num_meas_geo==0) = nan;

% ssh anomaly
ssh_anom_geo = accumarray(posloc_all,ssh,[numel(lat_X) 1],@mean);
ssh_std_geo = accumarray(posloc_all,ssh_moving_std,[numel(lat_X) 1],@mean);

% Height variance
height_std_geo = accumarray(posloc_all,height_moving_std,[numel(lat_X) 1],@mean);

% Accumulate wave energy into a single matrix
wave_energy_geo = accumarray(posloc_all,moving_en,[numel(lat_X) 1],@sum);

disp(['Saving ' outdir_waves]);

save(outdir_waves,'lat_X','lon_X','*_geo','num_segs_total','numtracks');