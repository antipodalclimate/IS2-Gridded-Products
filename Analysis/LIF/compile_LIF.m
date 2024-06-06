
LIF_folder = fullfile(OPTS.save_dir,'LIF');
    
for gran_ind = 1:length(GEO_files)

    LIFDATA = load(fullfile(LIF_folder,GEO_files(gran_ind).name),'LIF_GEO').LIF_GEO;

    % [N_floes,N_floes_strong,R_mean,R_rep] = deal(zeros(OPTS.nx,OPTS.ny,12,OPTS.nyears));
    TEMP.ice_length{gran_ind} = reshape(LIFDATA.ice_length_n,[size(GEODATA.lat) n_gran]);
    TEMP.total_length{gran_ind} = reshape(LIFDATA.ice_length_n,[size(GEODATA.lat) n_gran]);

end

% Now make output fields

