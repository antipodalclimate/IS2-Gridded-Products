[TEMP.n,TEMP.n_strong] = deal(nan(OPTS.nx,OPTS.ny,length(GEO_files)));

% Accumulate within each granule

% Do those for general statistics first
for gran_ind = 1:length(GEO_files)

    % First do the general statistics
    GEODATA = load(fullfile(GEO_files(gran_ind).folder,GEO_files(gran_ind).name),'GEODATA').GEODATA;

    TEMP.n(:,:,gran_ind) = reshape(GEODATA.num_tracks,size(GEODATA.lat));
    TEMP.n_strong(:,:,gran_ind) = reshape(GEODATA.num_tracks_strong,size(GEODATA.lat));

    
end

OUT.GEO.n_gran_all(:,:,mo_ind,yr_ind) = sum(TEMP.n,3,'omitmissing');
OUT.GEO.n_gran_strong(:,:,mo_ind,yr_ind) = sum(TEMP.n_strong,3,'omitmissing');
