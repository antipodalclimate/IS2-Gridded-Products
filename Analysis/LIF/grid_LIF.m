% Add up the total length of leads in each location

fprintf('LIF - ')

LIF_GEO = struct();

LIF_GEO.water_length = accumarray(ALL_posloc,(DATA(:,ID.type) > 1).*(DATA(:,ID.length)),[numel(GEODATA.lat) 1],@sum);
LIF_GEO.specular_length = accumarray(ALL_posloc,(DATA(:,ID.type) > 1) .* (DATA(:,ID.type) < 6) .*(DATA(:,ID.length)),[numel(GEODATA.lat) 1],@sum);
LIF_GEO.ice_length = accumarray(ALL_posloc,(DATA(:,ID.type) == 0).*(DATA(:,ID.length)),[numel(GEODATA.lat) 1],@sum);

% Here just consider the strong beams. 
LIF_GEO.water_length_strong = accumarray(ALL_posloc,(DATA(:,ID.type) > 1).*(DATA(:,ID.length) .* (ALL_beamflag == 1)),[numel(GEODATA.lat) 1],@sum);
LIF_GEO.specular_length_strong  = accumarray(ALL_posloc,(DATA(:,ID.type) > 1) .* (DATA(:,ID.type) < 6) .*(DATA(:,ID.length)) .* (ALL_beamflag == 1),[numel(GEODATA.lat) 1],@sum);
LIF_GEO.ice_length_strong  = accumarray(ALL_posloc,(DATA(:,ID.type) == 0).*(DATA(:,ID.length) .* (ALL_beamflag == 1)),[numel(GEODATA.lat) 1],@sum);

LIF_GEO.SIC_SSMI = accumarray(ALL_posloc,DATA(:,ID.conc_SSMI),[numel(GEODATA.lat) 1],@mean);
LIF_GEO.SIC_AMSR = accumarray(ALL_posloc,DATA(:,ID.conc_AMSR),[numel(GEODATA.lat) 1],@mean);

save(OPTS.save_loc{proc_ind},'LIF_GEO'); 
