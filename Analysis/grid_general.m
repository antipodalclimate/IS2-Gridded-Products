fprintf('Gridding General Data \n')

GEODATA = struct(); 

% Convert everything to all usable segments. 
DATA = cell2mat(DATA(:,:));
DATA = DATA(ALL_usable(ALL_sorter),:); 

fprintf('Have %d usable segments to analyse out of %d total for this location \n',STATS.len_usable,STATS.lenct);


% What grid will we bin the lat-lon values into
kdloc = fullfile(OPTS.code_loc,'SupportFiles','KDTrees',['KDTree_' OPTS.gridname]);
load(kdloc,['lat_' OPTS.hemi],['lon_' OPTS.hemi],['area_' OPTS.hemi],['KDTree_' OPTS.hemi]);

if strcmp(OPTS.hemi,'NH')
    KDtree = KDTree_NH;
    GEODATA.lat = lat_NH;
    GEODATA.lon = lon_NH;
    GEODATA.area = area_NH;
else
    KDtree = KDTree_SH;
    GEODATA.lat = lat_SH;
    GEODATA.lon = lon_SH;
    GEODATA.area = area_SH;
end

fprintf('Locating Grid Indices - ');
% Search for the grid values for each point via their lat/lon
ALL_posloc = knnsearch(KDtree,[DATA(:,ID.lat) DATA(:,ID.lon)],'K',1);
fprintf('Done \n')

% This helps counting the number of unique values. 
lenfac = @(x) length(unique(x)); 


%% Now make the standard geographic files. These will lie above Process-level geographic data. 
% Create a geographic data reference
GEODATA.num_tracks = accumarray(ALL_posloc,ALL_ids,[numel(GEODATA.lat) 1],lenfac); 
GEODATA.num_tracks_strong = accumarray(ALL_posloc(ALL_beamflag == 1),ALL_ids(ALL_beamflag == 1),[numel(GEODATA.lat) 1],lenfac); 

save(OPTS.save_GEO,'GEODATA','STATS','OPTS'); 