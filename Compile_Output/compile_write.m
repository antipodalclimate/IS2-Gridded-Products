
OPTS.netcdf_name = fullfile(OPTS.output_loc,['IS2_Data_' OPTS.gridname '_' OPTS.hemi '.nc']);

if exist(OPTS.netcdf_name,'file')

    delete(OPTS.netcdf_name);

end

h5create(OPTS.netcdf_name,'/latitude',size(GEODATA.lat));
h5create(OPTS.netcdf_name,'/longitude',size(GEODATA.lat));

h5write(OPTS.netcdf_name,'/latitude',GEODATA.lat);
h5write(OPTS.netcdf_name,'/longitude',GEODATA.lon);

h5create(OPTS.netcdf_name,'/n_gran',size(n_gran_all),'Fillvalue',0);
h5write(OPTS.netcdf_name,'/n_gran',n_gran_all);
