function compile_wrapper(OPTS,PROCESSES)

fprintf('General statistics \n')

OUT = struct();

for yr_ind = 1:OPTS.nyears

    for mo_ind = 1:12

        % Now try to create the relevant fields. 


        yrstr = num2str(yr_ind + 2017);
        mostr = sprintf('%02d', mo_ind); % Pad month with zero if needed

        GEO_files = dir(fullfile(OPTS.save_dir,'GEO',[yrstr mostr '*.mat']));

        TEMP = struct();

        if ~isempty(GEO_files)


            compile_GEO; 

           % Now do for specific processes. 

            for proc_ind = 1:length(PROCESSES)
                % Each process is analysed in the same month

                if PROCESSES(proc_ind).DO_COMPILE == 1

                    % Run the file given proc_files.
                    run([PROCESSES(proc_ind).code_folder '/compile_' PROCESSES(proc_ind).name '.m'])

                end

            end


        end

    end

end

%%

write_output; 
