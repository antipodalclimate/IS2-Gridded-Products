% Add up the total length of leads in each locatiom
GEODATA.water_length = accumarray(ALL_posloc,(DATA(:,ID.type) > 1).*(DATA(:,ID.length)),[numel(lat_X) 1],@sum);
GEODATA.specular_length = accumarray(ALL_posloc,(DATA(:,ID.type) > 1) .* (DATA(:,ID.type) < 6) .*(DATA(:,ID.length)),[numel(lat_X) 1],@sum);
GEODATA.ice_length = accumarray(ALL_posloc,(DATA(:,ID.type) == 0).*(DATA(:,ID.length)),[numel(lat_X) 1],@sum);

% Here just consider the strong beams. 
GEODATA.water_length_strong = accumarray(ALL_posloc,(DATA(:,ID.type) > 1).*(DATA(:,ID.length) .* (ALL_beamflag == 1)),[numel(lat_X) 1],@sum);
GEODATA.specular_length_strong  = accumarray(ALL_posloc,(DATA(:,ID.type) > 1) .* (DATA(:,ID.type) < 6) .*(DATA(:,ID.length)) .* (ALL_beamflag == 1),[numel(lat_X) 1],@sum);
GEODATA.ice_length_strong  = accumarray(ALL_posloc,(DATA(:,ID.type) == 0).*(DATA(:,ID.length) .* (ALL_beamflag == 1)),[numel(lat_X) 1],@sum);

GEODATA.SIC_SSMI = accumarray(posloc_all,DATA(:,ID.conc_SSMI),[numel(lat_X) 1],@mean);
GEODATA.SIC_AMSR = accumarray(posloc_all,DATA(:,ID.conc_AMSR),[numel(lat_X) 1],@mean);

