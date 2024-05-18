% floemat = DATA(ALL_floeids,:);
fprintf('FSD - ')



% K nerest neighbor search into the loaded grid to find grid locations
% For all the naive floes

posloc_floes = ALL_posloc(ALL_floeids); % = knnsearch(KDTree,[floemat(:,lat_id) floemat(:,lon_id)],'K',1);

%% FSD Geographic Fields

FSD_GEO = struct();

% Number of floes at each point
FSD_GEO.floenum = accumarray(posloc_floes,1,[numel(GEODATA.lat) 1],@sum);
% Length of those floes
FSD_GEO.floelength = accumarray(posloc_floes,ALL_floelengths,[numel(GEODATA.lat) 1],@sum);

% sum of segment lengths
FSD_GEO.floe_seglengths = accumarray(posloc_floes,ALL_floe_seglengths,[numel(GEODATA.lat) 1],@sum);

% Moments of the chord length distribution
FSD_GEO.moment(:,1) = accumarray(posloc_floes,ALL_floelengths,[numel(GEODATA.lat) 1],@sum);
FSD_GEO.moment(:,2) = accumarray(posloc_floes,ALL_floelengths.^2,[numel(GEODATA.lat) 1],@sum);
FSD_GEO.moment(:,3) = accumarray(posloc_floes,ALL_floelengths.^3,[numel(GEODATA.lat) 1],@sum);
FSD_GEO.moment(:,4) = accumarray(posloc_floes,ALL_floelengths.^4,[numel(GEODATA.lat) 1],@sum);

% 
% MCL_geo = CLD_mom_1_geo ./ CLD_mom_0_geo;
% RCL_geo = CLD_mom_3_geo ./ CLD_mom_2_geo;

%% Output. 

if OPTS.voluble == 1

% Criteria for inclusion of a location. Kind of already did it.
fprintf('\nMeasured %2.0f thousand chord lengths \n',length(ALL_floeids)/1e3);
fprintf('Total chord length is %2.0f km \n',sum(ALL_floelengths)/1000);
fprintf('Average chord length (number) is %2.0f m \n',sum(ALL_floelengths)/length(ALL_floelengths));

end


save(OPTS.save_loc{proc_ind},'FSD_GEO'); 
