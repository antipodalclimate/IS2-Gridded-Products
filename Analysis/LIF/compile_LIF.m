
LIF_folder = fullfile(OPTS.save_dir,'LIF');
    
    STATS = load(fullfile(GEO_files(1).folder,GEO_files(1).name),'STATS').STATS;

[TEMP.ice_length,TEMP.water_length,TEMP.ice_length_strong,TEMP.water_length_strong] = ...
    deal(nan(OPTS.nx,OPTS.ny,STATS.numtracks,length(GEO_files)));

for beam_ind = 1:length(GEO_files)

    
    STATS = load(fullfile(GEO_files(beam_ind).folder,GEO_files(beam_ind).name),'STATS').STATS;
   
    LIFDATA = load(fullfile(LIF_folder,GEO_files(beam_ind).name),'LIF_GEO').LIF_GEO;
    % [N_floes,N_floes_strong,R_mean,R_rep] = deal(zeros(OPTS.nx,OPTS.ny,12,OPTS.nyears));
    
    TEMP.ice_length(:,:,:,beam_ind) = reshape(LIFDATA.ice_length_n,OPTS.nx,OPTS.ny,[]);
    TEMP.water_length(:,:,:,beam_ind) = reshape(LIFDATA.water_length_n,OPTS.nx,OPTS.ny,[]);
    
    TEMP.ice_length_strong(:,:,:,beam_ind) = reshape(bsxfun(@times,LIFDATA.ice_length_n,STATS.beamflag'),OPTS.nx,OPTS.ny,[]);
    TEMP.water_length_strong(:,:,:,beam_ind) = reshape(bsxfun(@times,LIFDATA.water_length_n,STATS.beamflag'),OPTS.nx,OPTS.ny,[]);

    TEMP.SIC_SSMI(:,:,beam_ind) = reshape(LIFDATA.SIC_SSMI,OPTS.nx,OPTS.ny); 
    TEMP.SIC_AMSR(:,:,beam_ind) = reshape(LIFDATA.SIC_AMSR,OPTS.nx,OPTS.ny); 

    TEMP.SIC_SSMI_strong(:,:,beam_ind) = reshape(bsxfun(@times,LIFDATA.SIC_SSMI,STATS.beamflag),OPTS.nx,OPTS.ny); 
    TEMP.SIC_AMSR_strong(:,:,beam_ind) = reshape(bsxfun(@times,LIFDATA.SIC_AMSR,STATS.beamflag),OPTS.nx,OPTS.ny); 


end

% Now make output fields

OUT.LIF.LIF(:,:,mo_ind,yr_ind) = sum(TEMP.ice_length,[3 4])./sum(TEMP.ice_length + TEMP.water_length,[3 4]); 
OUT.LIF.LIF_strong(:,:,mo_ind,yr_ind) = sum(TEMP.ice_length_strong,[3 4])./sum(TEMP.ice_length_strong + TEMP.water_length_strong,[3 4]); 

OUT.LIF.SIC_SSMI(:,:,mo_ind,yr_ind) = mean(TEMP.SIC_SSMI,3,'omitmissing');
OUT.LIF.SIC_SSMI_strong(:,:,mo_ind,yr_ind) = mean(TEMP.SIC_SSMI_strong,3,'omitmissing');

OUT.LIF.SIC_AMSR(:,:,mo_ind,yr_ind) = mean(TEMP.SIC_AMSR,3,'omitmissing');
OUT.LIF.SIC_AMSR_strong(:,:,mo_ind,yr_ind) = mean(TEMP.SIC_AMSR_strong,3,'omitmissing');
