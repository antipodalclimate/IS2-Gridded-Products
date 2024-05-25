% 
% disp('FSD statistics')
% 
% [R_mean,R_rep] = deal(zeros(OPTS.nx,OPTS.ny,12,OPTS.nyears));
% 
% for yr_ind = 1:OPTS.nyears
% 
%     for mo_ind = 1:12
% 
%         yrstr = num2str(yr_ind + 2017);
%         mostr = sprintf('%02d', mo_ind); % Pad month with zero if needed
% 
%         GEO_files = dir(fullfile(OPTS.save_dir,'GEO',[yrstr mostr '*.mat']));
%         FSD_files = dir(fullfile(OPTS.save_dir,'FSD/',[yrstr mostr '*.mat']));
% 
%         if ~isempty(FSD_files)
% 
%             [temp_N,temp_N_strong] = deal(nan(OPTS.nx,OPTS.ny,length(FSD_files)));
% 
%             for gran_ind = 1:length(FSD_files)
% 
%                 FSDDATA = load(fullfile(files(gran_ind).folder,files(gran_ind).name),'FSD_GEO').FSD_GEO;
%                 GEODATA = load(fullfile(geo_files(gran_ind).folder,geo_files(gran_ind).name),'GEODATA').GEODATA;
% 
% 
%                 temp_num(:,:,gran_ind) = reshape(FSDDATA.floenum,size(FSDDATA.lat));
%                 temp_num_strong(:,:,gran_ind) = reshape(FSDDATA.floenum,size(FSDDATA.lat));
% 
%             end
% 
%             n_gran_all(:,:,mo_ind,yr_ind) = sum(temp_n,3,'omitmissing');
%             n_gran_strong(:,:,mo_ind,yr_ind) = sum(temp_n_strong,3,'omitmissing');
% 
%         end
%     end
% end
% 
% 
% h5create(OPTS.netcdf_name,'/FSD/',size(n_gran_all),'Fillvalue',0);
% h5write(OPTS.netcdf_name,'/FSD/',n_gran_all);
% 
% h5create(OPTS.netcdf_name,'/FSD/',size(n_gran_strong),'Fillvalue',0);
% h5write(OPTS.netcdf_name,'/FSD/',n_gran_strong);
