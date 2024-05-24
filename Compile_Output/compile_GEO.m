function compile_GEO(OPTS)

disp('Putting together general statistics')

[n_gran_all,n_gran_strong] = deal(zeros(OPTS.nx,OPTS.ny,12,OPTS.nyears));

for yr_ind = 1:OPTS.nyears

    for mo_ind = 1:12

        yrstr = num2str(yr_ind + 2017);
        mostr = sprintf('%02d', mo_ind); % Pad month with zero if needed

        geo_files = dir(fullfile(OPTS.save_dir,'GEO',[yrstr mostr '*.mat']));

        [temp_n,temp_n_strong] = deal(nan(OPTS.nx,OPTS.ny,length(geo_files)));

        for gran_ind = 1:length(geo_files)

            GEODATA = load(fullfile(geo_files(gran_ind).folder,geo_files(gran_ind).name),'GEODATA').GEODATA;

            temp_n(:,:,gran_ind) = reshape(GEODATA.num_tracks,size(GEODATA.lat));
            temp_n_strong(:,:,gran_ind) = reshape(GEODATA.num_tracks_strong,size(GEODATA.lat));

        end

        n_gran_all(:,:,mo_ind,yr_ind) = sum(temp_n,3,'omitmissing');
        n_gran_strong(:,:,mo_ind,yr_ind) = sum(temp_n_strong,3,'omitmissing');

    end
end


h5create(OPTS.netcdf_name,'/n_gran',size(n_gran_all),'Fillvalue',-1);
h5write(OPTS.netcdf_name,'/n_gran',n_gran_all);

h5create(OPTS.netcdf_name,'/n_gran_strong',size(n_gran_strong),'Fillvalue',-1);
h5write(OPTS.netcdf_name,'/n_gran_strong',n_gran_strong);
