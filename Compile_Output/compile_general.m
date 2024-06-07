[TEMP.n,TEMP.n_strong] = deal(nan(OPTS.nx,OPTS.ny,length(GEO_files)));

% Accumulate within each granule

% Do those for general statistics first

for beam_ind = 1:length(GEO_files)

    % First do the general statistics
    GEODATA = load(fullfile(GEO_files(beam_ind).folder,GEO_files(beam_ind).name),'GEODATA').GEODATA;

    TEMP.n(:,:,beam_ind) = reshape(GEODATA.num_tracks,size(GEODATA.lat));
    TEMP.n_strong(:,:,beam_ind) = reshape(GEODATA.num_tracks_strong,size(GEODATA.lat));

    TEMP.length(:,:,beam_ind) = reshape(GEODATA.len_segs,size(GEODATA.lat));
    TEMP.length_strong(:,:,beam_ind) = reshape(GEODATA.len_segs_strong,size(GEODATA.lat));
end

OUT.GEO.n_gran_all(:,:,mo_ind,yr_ind) = sum(TEMP.n,3,'omitmissing');
OUT.GEO.n_gran_strong(:,:,mo_ind,yr_ind) = sum(TEMP.n_strong,3,'omitmissing');

OUT.GEO.length(:,:,mo_ind,yr_ind) = sum(TEMP.length,3,'omitmissing');
OUT.GEO.length_strong(:,:,mo_ind,yr_ind) = sum(TEMP.length_strong,3,'omitmissing');