clear
% in NH
fid = fopen('../Grid_files/psn25lats_v3.dat','r'); 
lat_NH = fread(fid,'integer*4')/1e5; 
lat_NH = reshape(lat_NH, [304 448]); 
lat_NH = lat_NH(2:2:end,2:2:end); 

fid = fopen('../Grid_files/psn25lons_v3.dat','r'); 
lon_NH = fread(fid,'integer*4')/1e5;  
lon_NH = reshape(lon_NH,[304 448]); 
lon_NH = lon_NH(2:2:end,2:2:end); 

fid = fopen('../Grid_files/pss25lats_v3.dat','r'); 
lat_SH = fread(fid,'integer*4')/1e5; 
lat_SH = reshape(lat_SH,[316 332]); 
lat_SH = lat_SH(2:2:end,2:2:end); 

fid = fopen('../Grid_files/pss25lons_v3.dat','r'); 
lon_SH = fread(fid,'integer*4')/1e5; 
lon_SH = reshape(lon_SH,[316 332]); 
lon_SH = lon_SH(2:2:end,2:2:end); 

%%
% Area a little more delicate
fid = fopen('../Grid_files/psn25area_v3.dat','r'); 
area_NH = fread(fid,'integer*4')/1e3; 
area_NH = reshape(area_NH,[304 448]); 
area_NH = reshape(area_NH,[2 304/2 2 448/2]); 
area_NH = squeeze(sum(sum(area_NH,1),3)); 

fid = fopen('../Grid_files/pss25area_v3.dat','r'); 
area_SH = fread(fid,'integer*4')/1e3; 
area_SH = reshape(area_SH,[316 332]); 
area_SH = reshape(area_SH,[2 316/2 2 332/2]); 
area_SH = squeeze(sum(sum(area_SH,1),3)); 

%% Do with KNN
lat_X = [lat_NH(:); lat_SH(:)];  
lon_X = [lon_NH(:); lon_SH(:)]; 

KDTree = createns([lat_X,lon_X]); 

save('../KDTrees/KDTree_50km.mat','KDTree','lat_X','lon_X','*_SH','*_NH'); 