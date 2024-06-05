
OPTS.h5_name = fullfile(OPTS.output_loc,['IS2_Data_' OPTS.gridname '_' OPTS.hemi '.h5']);

if exist(OPTS.h5_name,'file')

    delete(OPTS.h5_name);

end

h5create(OPTS.h5_name,'/latitude',size(GEODATA.lat));
h5create(OPTS.h5_name,'/longitude',size(GEODATA.lat));

h5write(OPTS.h5_name,'/latitude',GEODATA.lat);
h5write(OPTS.h5_name,'/longitude',GEODATA.lon);

h5create(OPTS.h5_name,'/n_gran',size(n_gran_all),'Fillvalue',0);
h5write(OPTS.h5_name,'/n_gran',n_gran_all);


for proc_ind = 1:length(PROCESSES)

    if PROCESSES(proc_ind).DO_COMPILE == 1

        % Run the file given proc_files.
        run([PROCESSES(proc_ind).code_folder '/write_' PROCESSES(proc_ind).name '.m'])

    end

end
