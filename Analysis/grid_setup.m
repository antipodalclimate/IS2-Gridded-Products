
% Convert everything to all usable segments. 
DATA = cell2mat(DATA(:,:));
DATA = DATA(ALL_usable(ALL_sorter),:); 

% What grid will we bin the lat-lon values into
kdloc = fullfile(OPTS.code_loc,'SupportFiles','KDTrees',['KDTree_' OPTS.gridname]);
load(kdloc,'lat_X','lon_X','KDTree');

disp('Finding Locations');
% Search for the grid values for each point via their lat/lon
posloc_all = knnsearch(KDTree,[DATA(:,ID.lat) DATA(:,ID.lon)],'K',1);
