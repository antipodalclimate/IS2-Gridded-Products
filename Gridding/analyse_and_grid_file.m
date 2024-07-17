function analyse_and_grid_file(file_path,PROCESSES,OPTS)
% Code that helps with the analysis of a single .mat file that corresponds
% to a month and beam of aggregated IS2 data.

% Here is the data itself.
DATA = matfile(file_path);

%% Now we want to perform various functions on the data.
% Because we don't care about the tracks themselves, we want to create a
% long vector which has lat/lon/height. We do this by concatenating all
% of the beams together.

DATA = DATA.fields;


% DATA is ntracks x nfields - for every segment we have
% latitude/longitude/elevation/segment length/photon rate/freeboard

if numel(DATA) == 0
    % Don't waste our time with files with no data.

    return


end

disp('-----------------------------------------');
disp(['Processing file: ' file_path]);

%%
% Now we initialize the required pieces. We will keep all data in the
% current workspace because some of it is duplicative. So we have separate
% calls to init and analysis codes for each component we wish to add. The
% only requirement is that new pieces added should not conflict with
% pre-existing variables. This potentially should be avoided using
% structures (WAVES.height, or similar). For now we will not add this but
% note it to be changed in the future if the code enjoys wider adoption.

% We have two types of files
% AT_X is the along-track version of field X consisting of raw data
% These are processed in the first analyse_P call. These might be shared
% across processed.

% ALL_X is the version of field X accumulated across multiple RGTs/Beams
% These are processed in the grid_P call.

% Variables with no first capitalized part are internal to any process.
% They should be contained to that piece of the code itself. We may opt to
% wipe those fields later.

run(fullfile(OPTS.process_loc,'General','init_general'));

% Initialize information needed for each process.
for proc_ind = 1:length(PROCESSES)
    if PROCESSES(proc_ind).DO_ANALYSIS == 1 
        run([PROCESSES(proc_ind).code_folder '/init_' PROCESSES(proc_ind).name '.m'])
    end
end

%% Now start the main loop - analysis on each track.

for track_ind = 1:STATS.numtracks % for every track

    % First compute distance along track using lat and lon coordinates

    run(fullfile(OPTS.process_loc,'General','analyse_general'))

    %% Now we do the specific calculations for along-track data
    for proc_ind = 1:length(PROCESSES)

        if PROCESSES(proc_ind).DO_ANALYSIS == 1

            run(fullfile(PROCESSES(proc_ind).code_folder,['analyse_' PROCESSES(proc_ind).name]))

        end

    end

    % This adds the unusable vector by the size of the field
    STATS.lenct = STATS.lenct + num_segs;
    STATS.len_usable = STATS.len_usable + num_usable_segs;
    STATS.num_segs(track_ind) = num_segs;
    STATS.num_usable_segs(track_ind) = num_usable_segs;


    clearvars -except ALL_* STATS OPTS PROCESSES DATA ID track_ind 

    % %% Now we do the calculations for taking along-track data to gridded data


end

%% Now we move to the calculations which are across all segments in this area/time.


run(fullfile(OPTS.process_loc,'General','grid_general'));

fprintf('Gridding Process Data for %d processes: \n',sum(vertcat(PROCESSES.DO_ANALYSIS)))

for proc_ind = 1:length(PROCESSES)

    if PROCESSES(proc_ind).DO_ANALYSIS == 1

        run(fullfile(PROCESSES(proc_ind).code_folder,['grid_' PROCESSES(proc_ind).name]))

    end

end