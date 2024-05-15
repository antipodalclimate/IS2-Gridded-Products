function analyse_file(file_path,PROCESSES,gridname)
% Code that helps with the analysis of a single .mat file that corresponds
% to a month and beam of aggregated IS2 data.

% Here is the data itself.
IS2data = matfile(file_path);

%% Now we want to perform various functions on the data.
% Because we don't care about the tracks themselves, we want to create a
% long vector which has lat/lon/height. We do this by concatenating all
% of the beams together.

fieldmat = IS2data.fields;
load(file_path,'timer');

% Fieldmat is nseg x nfields - for every segment we have
% latitude/longitude/elevation/segment length/photon rate/freeboard

if numel(fieldmat) == 0
    % Don't waste our time with files with no data.

    return


end

% Here are indices corresponding to specific file components
% Used to track which field is which.
% These should be verified in convert_IS2_data_bybeam.m
ID = struct();
ID.height = 1;
ID.length = 2;
ID.lat = 3;
ID.lon = 4;
ID.prate = 5;
ID.type = 6;
ID.ssh = 7;
ID.conc_SSMI = 8;
ID.conc_AMSR = 9;

disp('-----------------------------------------');
disp(['Processing file: ' file_path]);

% Now we initialize the required pieces. We will keep all data in the
% current workspace because some of it is duplicative. So we have separate
% calls to init and analysis codes for each component we wish to add. The
% only requirement is that new pieces added should not conflict with
% pre-existing variables. This potentially should be avoided using
% structures (WAVES.height, or similar). For now we will not add this but
% note it to be changed in the future if the code enjoys wider adoption.

% Here we do some initialization needed by any process code

numtracks = length(timer); % Number of tracks



for i = 1:length(PROCESSES)
    if PROCESSES(i).DO_ANALYSIS == 1
        run([PROCESSES(i).code_folder '/init_' PROCESSES(i).name '.m'])
    end
end