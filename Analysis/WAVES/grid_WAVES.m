fprintf('WAVES - ')

%% This code produces the gridded wave products


% Multiple for WAF
Mval = (.5 - (1/pi)*asin(ALL_ssh./ALL_moving_en + 1/sqrt(2))).^(-1);
Mval(abs(imag(Mval)) > 0) = 0;
Mval(isnan(Mval)) = 0;
Mval = min(Mval,10);

% Compute the fraction of all measurements (by length or number) that are
% "wave-affected"

is_ice = DATA(:,ID.type) == 1; 

% Need to have two ssh points within 10 km
close_to_ssh = (ALL_moving_ssh_no >= 2);%  .* (ssh_neighbors <= window_10k);

% Minimum threshold on moving std
wave_cutoff_ssh = max(ALL_ssh_moving_std,.1);
wave_cutoff_height = max(ALL_height_moving_std,.1);
both_cutoff_height = max(wave_cutoff_ssh,wave_cutoff_height);


% adjust for deviation from local ssh
height_adjusted = DATA(:,ID.height) - ALL_ssh;

% Usable segments that are ice, and have positive moving average
% There used to be a field here for not-too-long, but this was superfluous
% to the requirement that segment lengths were not usable if over 200 m
naive_reasonable = logical(is_ice);

% Has positive points nearby
close_to_positive = ALL_moving_pos >= 2;
% Has negative points nearby - only for those values that are negative
close_to_negative = ALL_moving_neg >= 2;

% Usable points have positive points nearby, and are
% identified as ice. Criteria I1-I2.
is_included = logical(is_ice .* close_to_positive);

% Usable points have positive points nearby. Criteria I1.
is_included_lead = logical(close_to_positive);

%%
% Wave candidates are those included segs close to ssh points, and
% close to other negative values.
is_wave_candidate = logical(is_included .*close_to_ssh.* ...
    close_to_negative);

% Different metrics for being wave-affected

% Just negative, ice, and not too long.
naive_under = logical((DATA(:,ID.height) < 0).*is_wave_candidate);

% Adjusted height is negative
is_under = logical((height_adjusted < 0).*is_wave_candidate);

% Height is negative beyond ssh or height variance
is_under_ssh_var = logical((height_adjusted < -wave_cutoff_ssh).*is_wave_candidate);
is_under_height_var = logical((height_adjusted < -wave_cutoff_height).*is_wave_candidate);
is_under_both_var = logical((height_adjusted < -both_cutoff_height).*is_wave_candidate);

%%

% Take total length of negative elevations divided by total length of all
% segments. Multiply by two because all troughs have crests.

wave_area_frac_naive = 2 * sum(DATA(naive_under,2)) / sum(DATA(is_ice,2));
wave_area_frac = 2 * sum(DATA(is_under,2)) / sum(DATA(is_ice,2));
wave_area_frac_ssh = 2 * sum(DATA(is_under_ssh_var,2)) / sum(DATA(is_ice,2));
wave_area_frac_height = 2 * sum(DATA(is_under_height_var,2)) / sum(DATA(is_ice,2));
wave_area_frac_both = 2 * sum(DATA(is_under_both_var,2)) / sum(DATA(is_ice,2));
wave_area_frac_M_height = 2 * sum(Mval(is_under_height_var).*DATA(is_under_height_var,2)) / sum(DATA(is_ice,2));

% Take total number of negative elevations divided by total number of all
% segments
wave_num_frac_naive = 2 * sum(naive_under)/sum(is_ice);
wave_num_frac = 2 * sum(is_under)/sum(is_included);
wave_num_frac_ssh = 2 * sum(is_under_ssh_var)/sum(is_included);
wave_num_frac_height = 2 * sum(is_under_height_var)/sum(is_included);
wave_num_frac_both = 2 * sum(is_under_both_var)/sum(is_included);
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
fprintf('%2.1f percent of M-adjusted suitable segs (by number) have statistically outlier negative heights \n',wave_num_frac_M_height*100);

fprintf('\nTotal length of usable ice segs: %2.1f km \n',sum(DATA(is_ice,ID.length))/1000)
fprintf('Total length of not-too-long ice segs with positive MA: %2.1f km \n',sum(DATA(is_included,ID.length))/1000)
fprintf('Total length of wave candidate ice segs: %2.1f km \n',sum(DATA(is_wave_candidate,ID.length))/1000)
fprintf('%2.1f percent of all ice segs (by length) have negative heights \n',wave_area_frac_naive*100);
fprintf('%2.1f percent of suitable segs (by length) have negative heights \n',wave_area_frac*100);
fprintf('%2.1f percent of suitable segs (by length) have statistically outlier negative heights vs SSH variance \n',wave_area_frac_ssh*100);
fprintf('%2.1f percent of suitable segs (by length) have statistically outlier negative heights vs Height variance \n',wave_area_frac_height*100);
fprintf('%2.1f percent of suitable segs (by length) have statistically outlier negative heights vs both variance \n',wave_area_frac_both*100);
fprintf('%2.1f percent of M-adjusted suitable segs (by length) have statistically outlier negative heights \n',wave_area_frac_M_height*100);



%% Accumulate all values that are below zero into the chosen lat-lon array

% Look at average freeboard
% Sum of freeboards by their length divided by total freeboard. 
WAVES_GEO.height_adjusted = accumarray(ALL_posloc,is_included.*DATA(:,ID.length).*DATA(:,ID.height),[numel(GEODATA.lat) 1],@sum) ./ ...
    accumarray(ALL_posloc,is_included.*DATA(:,ID.length),[numel(GEODATA.lat) 1],@sum);

WAVES_GEO.ssh_anom = accumarray(ALL_posloc,ALL_ssh,[numel(GEODATA.lat) 1],@mean);
WAVES_GEO.ssh_std = accumarray(ALL_posloc,ALL_ssh_moving_std,[numel(GEODATA.lat) 1],@mean);
WAVES_GEO.height_std = accumarray(ALL_posloc,ALL_height_moving_std,[numel(GEODATA.lat) 1],@mean);
GEO_WABES.wave_energy = accumarray(ALL_posloc,ALL_moving_en,[numel(GEODATA.lat) 1],@sum);

% Take the points that are ok to use - numerator is ice points,
% denominator is all points (not too long and close to ice)
WAVES_GEO.conc_wave = accumarray(ALL_posloc,is_included.*DATA(:,ID.length),[numel(GEODATA.lat) 1],@sum) ./ ...
    accumarray(ALL_posloc,is_included_lead.*DATA(:,ID.length),[numel(GEODATA.lat) 1],@sum);

% This adds up all measurements that are reasonable
WAVES_GEO.num_wave = accumarray(ALL_posloc,is_included,[numel(GEODATA.lat) 1],@sum);
WAVES_GEO.num_ice = accumarray(ALL_posloc,naive_reasonable,[numel(GEODATA.lat) 1],@sum);

% This adds up the length of all measurements
WAVES_GEO.len_wave = accumarray(ALL_posloc,is_included.*DATA(:,ID.length),[numel(GEODATA.lat) 1],@sum);
WAVES_GEO.len_ice = accumarray(ALL_posloc,naive_reasonable.*DATA(:,ID.length),[numel(GEODATA.lat) 1],@sum);

% This is all measurements below zero (times 2)
WAVES_GEO.num_under = 2*accumarray(ALL_posloc,is_under,[numel(GEODATA.lat) 1],@sum);
WAVES_GEO.num_under_ice = 2*accumarray(ALL_posloc,naive_under,[numel(GEODATA.lat) 1],@sum);
WAVES_GEO.num_under_ssh = 2*accumarray(ALL_posloc,is_under_ssh_var,[numel(GEODATA.lat) 1],@sum);
WAVES_GEO.num_under_height =  2*accumarray(ALL_posloc,is_under_height_var,[numel(GEODATA.lat) 1],@sum);
WAVES_GEO.num_under_both = 2*accumarray(ALL_posloc,is_under_both_var,[numel(GEODATA.lat) 1],@sum);

% Adds up length of all that are negative (times 2) in each cell
WAVES_GEO.len_under = 2*accumarray(ALL_posloc,is_under.*DATA(:,ID.length),[numel(GEODATA.lat) 1],@sum);
WAVES_GEO.len_under_ice = 2*accumarray(ALL_posloc,naive_under.*DATA(:,ID.length),[numel(GEODATA.lat) 1],@sum);
WAVES_GEO.len_under_ssh = 2*accumarray(ALL_posloc,is_under_ssh_var.*DATA(:,ID.length),[numel(GEODATA.lat) 1],@sum);
WAVES_GEO.len_under_height = 2*accumarray(ALL_posloc,is_under_height_var.*DATA(:,ID.length),[numel(GEODATA.lat) 1],@sum);
WAVES_GEO.len_under_both = 2*accumarray(ALL_posloc,is_under_both_var.*DATA(:,ID.length),[numel(GEODATA.lat) 1],@sum);

% Don't need to multiply by 2 with M
WAVES_GEO.len_under_ssh_M = accumarray(ALL_posloc,is_under_ssh_var.*DATA(:,ID.length).*Mval,[numel(GEODATA.lat) 1],@sum);
WAVES_GEO.len_under_height_M = accumarray(ALL_posloc,is_under_height_var.*DATA(:,ID.length).*Mval,[numel(GEODATA.lat) 1],@sum);
WAVES_GEO.len_under_both_Ml = accumarray(ALL_posloc,is_under_both_var.*DATA(:,ID.length).*Mval,[numel(GEODATA.lat) 1],@sum);


% Accumulate wave energy into a single matrix
% % 2-D map of fraction by length in each cell
% perc_under_geo = len_under_geo ./ len_meas_geo;
% perc_under_geo(num_meas_geo==0) = nan;
% 
% perc_ssh_under_geo = len_ssh_under_geo ./ len_meas_geo;
% perc_ssh_under_geo(num_meas_geo==0) = nan;
% 
% perc_height_under_geo = len_height_under_geo ./ len_meas_geo;
% perc_height_under_geo(num_meas_geo==0) = nan;
% 
% perc_both_under_ex_geo = len_both_under_ex_geo ./ len_meas_geo;
% perc_both_under_ex_geo(num_meas_geo==0) = nan;
% 
% perc_M_ssh_under_geo = len_M_ssh_under_geo ./ len_meas_geo;
% perc_M_ssh_under_geo(num_meas_geo==0) = nan;
% 
% perc_M_height_under_geo = len_M_height_under_geo ./ len_meas_geo;
% perc_M_height_under_geo(num_meas_geo==0) = nan;
% 
% naive_perc_under_geo = naive_len_under_geo ./ naive_len_meas_geo;
% naive_perc_under_geo(naive_num_meas_geo==0) = nan;

% ssh anomaly

% Height variance

save(OPTS.save_loc{proc_ind},'WAVES_GEO'); 
