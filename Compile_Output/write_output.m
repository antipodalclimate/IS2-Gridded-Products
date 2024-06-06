
OPTS.h5_name = fullfile(OPTS.output_loc,['IS2_Data_' OPTS.gridname '_' OPTS.hemi '.h5']);

if exist(OPTS.h5_name,'file')

    delete(OPTS.h5_name);

end

h5create(OPTS.h5_name,'/latitude',size(GEODATA.lat));
h5write(OPTS.h5_name,'/latitude',GEODATA.lat);

h5create(OPTS.h5_name,'/longitude',size(GEODATA.lat));
h5write(OPTS.h5_name,'/longitude',GEODATA.lon);



proc_fields = fieldnames(OUT);

for proc_ind = 1:length(proc_fields)
    % Each OUT field is another structure.

    save_str = ['/' proc_fields{proc_ind}];

    out_fields = fieldnames(eval(['OUT.' proc_fields{proc_ind}]));

    for field_ind = 1:length(out_fields)

        save_field = eval(['OUT.' proc_fields{proc_ind} '.' out_fields{field_ind}]);

        h5create(OPTS.h5_name,[save_str '/' out_fields{field_ind}],size(save_field),'Fillvalue',0);
        h5write(OPTS.h5_name, [save_str '/' out_fields{field_ind}],save_field);

    end

end


%
%
% for proc_ind = 1:length(PROCESSES)
%
%     if PROCESSES(proc_ind).DO_COMPILE == 1
%
%         % Run the file given proc_files.
%         run([PROCESSES(proc_ind).code_folder '/write_' PROCESSES(proc_ind).name '.m'])
%
%     end
%
% end
