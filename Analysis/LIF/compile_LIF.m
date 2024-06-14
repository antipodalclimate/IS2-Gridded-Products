
LIF_folder = fullfile(OPTS.save_dir,'LIF');
    
for gran_ind = 1:length(GEO_files)

    % Load the gridded LIF files
    LIFDATA = load(fullfile(LIF_folder,GEO_files(gran_ind).name),'LIF_GEO').LIF_GEO;
    STATS = load(fullfile(GEO_files(gran_ind).folder,GEO_files(gran_ind).name),'STATS').STATS;
    n_gran = size(LIFDATA.water_length_n,2);

    % [N_floes,N_floes_strong,R_mean,R_rep] = deal(zeros(OPTS.nx,OPTS.ny,12,OPTS.nyears));
    TEMP.ice_length(:,:,:,gran_ind) = reshape(LIFDATA.ice_length_n,[size(GEODATA.lat) n_gran]);
    TEMP.ice_length_strong(:,:,:,gran_ind) = reshape(bsxfun(@times,LIFDATA.ice_length_n,STATS.beamflag'),[size(GEODATA.lat) n_gran]);


    TEMP.water_length(:,:,:,gran_ind) = reshape(LIFDATA.water_length_n,[size(GEODATA.lat) n_gran]);
    TEMP.water_length_strong(:,:,:,gran_ind) = reshape(bsxfun(@times,LIFDATA.water_length_n,STATS.beamflag'),[size(GEODATA.lat) n_gran]);

    TEMP.SIC_SSMI(:,:,gran_ind) = reshape(LIFDATA.SIC_SSMI,size(GEODATA.lat));
    TEMP.SIC_AMSR(:,:,gran_ind) = reshape(LIFDATA.SIC_AMSR,size(GEODATA.lat));

    TEMP.beamstr(gran_ind) = sum(STATS.beamflag) > 0;


end

% Now make output fields

OUT.LIF.LIF(:,:,mo_ind,yr_ind) = sum(TEMP.ice_length,[3 4])./sum(TEMP.water_length + TEMP.ice_length,[3 4]);
OUT.LIF.LIF_strong(:,:,mo_ind,yr_ind) = sum(TEMP.ice_length_strong,[3 4])./sum(TEMP.water_length_strong + TEMP.ice_length_strong,[3 4]);

TEMP.SIC_SSMI(TEMP.SIC_SSMI == 0) = nan; 
TEMP.SIC_AMSR(TEMP.SIC_AMSR == 0) = nan; 


OUT.LIF.SIC_SSMI(:,:,mo_ind,yr_ind) = mean(TEMP.SIC_SSMI,3,'omitmissing');
OUT.LIF.SIC_SSMI_strong(:,:,mo_ind,yr_ind) = mean(TEMP.SIC_SSMI(:,:,TEMP.beamstr),3,'omitmissing');
OUT.LIF.SIC_AMSR(:,:,mo_ind,yr_ind) = mean(TEMP.SIC_AMSR,3,'omitmissing');
OUT.LIF.SIC_AMSR_strong(:,:,mo_ind,yr_ind) = mean(TEMP.SIC_AMSR(:,:,TEMP.beamstr),3,'omitmissing'); 