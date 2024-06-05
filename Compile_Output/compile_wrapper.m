function compile_wrapper(OPTS,PROCESSES)

fprintf('General statistics \n')

[n_gran_all,n_gran_strong] = deal(zeros(OPTS.nx,OPTS.ny,12,OPTS.nyears));

for yr_ind = 1:OPTS.nyears

    for mo_ind = 1:12

        yrstr = num2str(yr_ind + 2017);
        mostr = sprintf('%02d', mo_ind); % Pad month with zero if needed

        GEO_files = dir(fullfile(OPTS.save_dir,'GEO',[yrstr mostr '*.mat']));

        if ~isempty(GEO_files)

            [TEMP_n,TEMP_n_strong] = deal(nan(OPTS.nx,OPTS.ny,length(GEO_files)));

            % Accumulate within each granlue
            for gran_ind = 1:length(GEO_files)


                % First do the general statistics
                GEODATA = load(fullfile(GEO_files(gran_ind).folder,GEO_files(gran_ind).name),'GEODATA').GEODATA;

                TEMP_n(:,:,gran_ind) = reshape(GEODATA.num_tracks,size(GEODATA.lat));
                TEMP_n_strong(:,:,gran_ind) = reshape(GEODATA.num_tracks_strong,size(GEODATA.lat));

                for proc_ind = 1:length(PROCESSES)

                    if PROCESSES(proc_ind).DO_COMPILE == 1

                        proc_files = dir(fullfile(OPTS.save_dir,PROCESSES(proc_ind).name,'*.mat'));

                        % Run the file given proc_files.
                        run([PROCESSES(proc_ind).code_folder '/compile_' PROCESSES(proc_ind).name '.m'])

                    end

                end

                n_gran_all(:,:,mo_ind,yr_ind) = sum(TEMP_n,3,'omitmissing');
                n_gran_strong(:,:,mo_ind,yr_ind) = sum(TEMP_n_strong,3,'omitmissing');


            end



        end

    end

end

%%

compile_write;

h5create(OPTS.netcdf_name,'/n_gran_strong',size(n_gran_strong),'Fillvalue',0);
h5write(OPTS.netcdf_name,'/n_gran_strong',n_gran_strong);
