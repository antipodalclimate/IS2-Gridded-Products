%

WAVES_folder = fullfile(OPTS.save_dir,'WAVES');

[TEMP.WAF,TEMP.WAF_relax,TEMP.WAF_M] = deal(nan(OPTS.nx,OPTS.ny,length(GEO_files)));

for gran_ind = 1:length(GEO_files)

    WAVEDATA = load(fullfile(WAVES_folder,GEO_files(gran_ind).name),'WAVES_GEO').WAVES_GEO;


    % [N_floes,N_floes_strong,R_mean,R_rep] = deal(zeros(OPTS.nx,OPTS.ny,12,OPTS.nyears));
    TEMP.len_under_both(:,:,gran_ind) = reshape(WAVEDATA.len_under_both,size(GEODATA.lat)); %
    TEMP.len_under_height(:,:,gran_ind) = reshape(WAVEDATA.len_under_height,size(GEODATA.lat)); %
    TEMP.len_under_height_M(:,:,gran_ind) = reshape(WAVEDATA.len_under_height_M,size(GEODATA.lat)); %
    
    TEMP.len_wave(:,:,gran_ind) = reshape(WAVEDATA.len_wave,size(GEODATA.lat)); %


end

% Now make output fields


OUT.WAVES.WAF_both(:,:,mo_ind,yr_ind) = sum(TEMP.len_under_both,3)./sum(TEMP.len_wave,3);
OUT.WAVES.WAF(:,:,mo_ind,yr_ind) = sum(TEMP.len_under_height,3)./sum(TEMP.len_wave,3);
OUT.WAVES.WAF_M(:,:,mo_ind,yr_ind) = sum(TEMP.len_under_height_M,3)./sum(TEMP.len_wave,3);
