% Add up the total length of leads in each location

fprintf('LIF - ')

LIF_GEO = struct();

%% Make an estimate like LIF_n for each 

by_int_ind = (ALL_ids-1)*(numel(GEODATA.lat)) + ALL_posloc; 

% These are ordered LIF measurements, with each beam overlying the region
% in question 
% To get the total LIF, we take sums over n
% To get strong-beam LIF, we can multiply and sum by STATS.beamflag

LIF_GEO.water_length_n = accumarray(by_int_ind,(DATA(:,ID.type) > 1).*(DATA(:,ID.length)),[numel(GEODATA.lat)*max(ALL_ids) 1],@sum);
LIF_GEO.water_length_n = reshape(LIF_GEO.water_length_n,[],STATS.numtracks); 

LIF_GEO.specular_length_n = accumarray(by_int_ind,(DATA(:,ID.type) > 1) .* (DATA(:,ID.type) < 6) .*(DATA(:,ID.length)),[numel(GEODATA.lat)*max(ALL_ids) 1],@sum);
LIF_GEO.specular_length_n = reshape(LIF_GEO.specular_length_n,[],STATS.numtracks); 

LIF_GEO.ice_length_n = accumarray(by_int_ind,(DATA(:,ID.type) == 1).*(DATA(:,ID.length)),[numel(GEODATA.lat)*max(ALL_ids) 1],@sum);
LIF_GEO.ice_length_n = reshape(LIF_GEO.ice_length_n,[],STATS.numtracks); 

LIF_GEO.SIC_SSMI = accumarray(ALL_posloc,DATA(:,ID.conc_SSMI),[numel(GEODATA.lat) 1],@mean);
LIF_GEO.SIC_AMSR = accumarray(ALL_posloc,DATA(:,ID.conc_AMSR),[numel(GEODATA.lat) 1],@mean);

if OPTS.voluble == 1

end

save(OPTS.save_loc{proc_ind},'LIF_GEO'); 
