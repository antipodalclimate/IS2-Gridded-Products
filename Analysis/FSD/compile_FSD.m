%
FSD_folder = fullfile(OPTS.save_dir,'FSD');

[TEMP.floe_num,TEMP.floe_len,TEMP.floe_2] = deal(nan(OPTS.nx,OPTS.ny,length(GEO_files)));

for gran_ind = 1:length(GEO_files)

    FSDDATA = load(fullfile(FSD_folder,GEO_files(gran_ind).name),'FSD_GEO').FSD_GEO;


    % [N_floes,N_floes_strong,R_mean,R_rep] = deal(zeros(OPTS.nx,OPTS.ny,12,OPTS.nyears));


    TEMP.floe_len(:,:,gran_ind) = reshape(FSDDATA.moment(:,1),size(GEODATA.lat));
    TEMP.floe_2(:,:,gran_ind) = reshape(FSDDATA.moment(:,2),size(GEODATA.lat));
    TEMP.floe_num(:,:,gran_ind) = reshape(FSDDATA.floenum,size(GEODATA.lat));


end

% Now make output fields


OUT.FSD.floe_num(:,:,mo_ind,yr_ind) = sum(TEMP.floe_num,3);
OUT.FSD.R_mean(:,:,mo_ind,yr_ind) = sum(TEMP.floe_len,3)./sum(TEMP.floe_num,3);
OUT.FSD.R_eff(:,:,mo_ind,yr_ind) = sum(TEMP.floe_2,3)./sum(TEMP.floe_len,3);

%
% h5create(OPTS.netcdf_name,'/FSD/',size(n_gran_all),'Fillvalue',0);
% h5write(OPTS.netcdf_name,'/FSD/',n_gran_all);
%
% h5create(OPTS.netcdf_name,'/FSD/',size(n_gran_strong),'Fillvalue',0);
% h5write(OPTS.netcdf_name,'/FSD/',n_gran_strong);
