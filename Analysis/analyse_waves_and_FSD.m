function analyse_waves_and_FSD(file_path,outdir_waves,outdir_fsd,gridname,DO_WAVE,DO_FSD)
%%





fprintf('Have %d total segments to analyse \n',num_segs_total)
if num_segs_total >= 1




%%
% Take the naive sea ice concentration as the fraction of segments divided
% by the number of segments that are classified as ice or ocean
% dbstop
% Get the number of tracks that intersect each geographic location
lenfac = @(x) length(unique(x)); 

num_tracks_geo = accumarray(posloc_all,idvec,[numel(lat_X) 1],lenfac); 

% Add up the total length of leads in each locatiom
conc_lead_geo = accumarray(posloc_all,(fieldmat(:,type_id) > 1).*(fieldmat(:,length_id)),[numel(lat_X) 1],@sum);
% Divide by the total length of ice. 
conc_lead_geo = conc_lead_geo ./ accumarray(posloc_all,(fieldmat(:,type_id) > 0).*(fieldmat(:,length_id)),[numel(lat_X) 1],@sum);
% Subtract from 1. 
conc_lead_geo = 1 - conc_lead_geo; 

% Add up total length of specular leads
conc_spec_geo = accumarray(posloc_all,((fieldmat(:,type_id) > 1) .* (fieldmat(:,type_id) < 6)).*(fieldmat(:,length_id)),[numel(lat_X) 1],@sum);
% Divide by total length of ice
conc_spec_geo = conc_spec_geo ./ accumarray(posloc_all,(fieldmat(:,type_id) > 0).*(fieldmat(:,length_id)),[numel(lat_X) 1],@sum);
% Subtract from 1
conc_spec_geo = 1 - conc_spec_geo; 

conc_SSMI_geo = accumarray(posloc_all,fieldmat(:,conc_id),[numel(lat_X) 1],@mean);

%% Compute number of segments intersecting a region



%% Now Wave Code

if DO_WAVE
    
    
    
end

clearvars *_geo -except conc_*_geo num_tracks_geo

if DO_FSD   %%
    

% Criteria for inclusion of a location. Kind of already did it.
    fprintf('\nMeasured %2.0f thousand naive chord lengths \n',length(all_floeids_0)/1e3);
    fprintf('Total chord length is %2.0f km \n',sum(all_floelengths_0)/1000);
    fprintf('Average chord length (number) is %2.0f m \n',sum(all_floelengths_0)/length(all_floeids_0));

    fprintf('\nOf these,%2.0f thousand are usable \n',sum(all_usable_floes)/1e3);
    fprintf('For a chord length of %2.0f km \n',sum(all_floelengths_0(logical(all_usable_floes)))/1000);
    fprintf('Average chord length (number) is %2.0f m \n',sum(all_floelengths_0(logical(all_usable_floes)))/length(all_floeids_0));


    % What grid will we bin the lat-lon values into

    kdloc = ['../Processing/KDTrees/KDTree_' gridname];

    load(kdloc,'lat_X','lon_X','KDTree');

    disp('Finding Locations');

    % K nerest neighbor search into the loaded grid to find grid locations
    % For all the naive floes
    posloc_floes = knnsearch(KDTree,[floemat(:,lat_id) floemat(:,lon_id)],'K',1);

    %% FSD Geographic Fields

    % Number of floes at each point
    floenum_0_geo = accumarray(posloc_floes,1 + 0*all_floeids_0,[numel(lat_X) 1],@sum);
    floelength_0_geo = accumarray(posloc_floes,all_floelengths_0,[numel(lat_X) 1],@sum);
    floe_seglengths_0_geo = accumarray(posloc_floes,all_floe_seglengths_0,[numel(lat_X) 1],@sum);

    % Number of good floes at each point
    floenum_geo = accumarray(posloc_floes,all_usable_floes,[numel(lat_X) 1],@sum);
    floelength_geo = accumarray(posloc_floes,all_floelengths_0.*all_usable_floes,[numel(lat_X) 1],@sum);
    floe_seglengths_geo = accumarray(posloc_floes,all_floe_seglengths_0.*all_usable_floes,[numel(lat_X) 1],@sum);


    CLD_mom_0_geo = accumarray(posloc_floes,all_usable_floes,[numel(lat_X) 1],@sum);
    CLD_mom_1_geo = accumarray(posloc_floes,all_floelengths_0.*all_usable_floes,[numel(lat_X) 1],@sum);
    CLD_mom_2_geo = accumarray(posloc_floes,(all_floelengths_0.^2).*all_usable_floes,[numel(lat_X) 1],@sum);
    CLD_mom_3_geo = accumarray(posloc_floes,(all_floelengths_0.^3).*all_usable_floes,[numel(lat_X) 1],@sum);

    MCL_geo = CLD_mom_1_geo ./ CLD_mom_0_geo;
    RCL_geo = CLD_mom_3_geo ./ CLD_mom_2_geo;

    disp(['Saving ' outdir_fsd]);

    save(outdir_fsd,'lat_X','lon_X','*_geo','num_segs_total','numtracks');

end



%%
else
  disp('No Segments - not saving anyything'); 
end

%%


