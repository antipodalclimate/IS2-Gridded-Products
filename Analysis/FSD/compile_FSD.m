
disp('Putting together FSD statistics')

[R_mean,R_rep] = deal(zeros(OPTS.nx,OPTS.ny,12,OPTS.nyears));

for yr_ind = 1:OPTS.nyears

    for mo_ind = 1:12

        yrstr = num2str(yr_ind + 2017);
        mostr = sprintf('%02d', mo_ind); % Pad month with zero if needed

        files = dir(fullfile(OPTS.save_dir,'FSD/',[yrstr mostr '*.mat']));

        [temp_n,temp_n_strong] = deal(nan(OPTS.nx,OPTS.ny,length(files)));

        for gran_ind = 1:length(files)

            FSDDATA = load(fullfile(files(gran_ind).folder,files(gran_ind).name),'GEODATA').GEODATA;

            temp_n(:,:,gran_ind) = reshape(FSDDATA.moments(1)./FSDDATA.num_floes,size(FSDDATA.lat));
            temp_n_strong(:,:,gran_ind) = reshape(FSDDATA.num_tracks_strong,size(FSDDATA.lat));

        end

        n_gran_all(:,:,mo_ind,yr_ind) = sum(temp_n,3,'omitmissing');
        n_gran_strong(:,:,mo_ind,yr_ind) = sum(temp_n_strong,3,'omitmissing');

    end
end


h5create(OPTS.netcdf_name,'/n_gran',size(n_gran_all),'Fillvalue',-1);
h5write(OPTS.netcdf_name,'/n_gran',n_gran_all);

h5create(OPTS.netcdf_name,'/n_gran_strong',size(n_gran_strong),'Fillvalue',-1);
h5write(OPTS.netcdf_name,'/n_gran_strong',n_gran_strong);
