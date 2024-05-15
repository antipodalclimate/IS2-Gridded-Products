# IS2-Gridded Product
Code for analyzing tracks and converting to a specified gridded product

To be filled out. 

Generally, consists of code that processes data from an existing set of .h5 or .nc files. It then accumulates statistics into bins at a specified time and spatial resolution to create value-added products. 

First, we need to download and examine data derived from a set of .h5/.nc files from ICESat-2. 

**Data/**
Hidded folder with required directory structure, starting with "All_Tracks_Netcdf"

  - **All_Track_Data/**

Contains an un-ordered set of .h5 (.nc) files that we wish to grid and compare. These are files of the form: processed_ATL07-01_20181031065620_04990101_006_02.nc

**Beam-Data-Mat/**
      - **NH/**
      - **SH/**

Contains Matlab-compatible files generated by conversion scripts that are segmented into NH/ and SH/. Files are of the form: 201907-beam-gt2r.mat

**Conversion/**

Contains scripts and drivers that take in IS2 data and organizes it into Matlab compatible .mat files broken down by each month/year/beam/hemisphere and selecting only the specific fields desired for the analysis as specified in the script. If there are 10,000 tracks covering 2 full years, for example, this will take the 10,000 different .h5 files and convert to a set ot 12 x 2 x 6 x 2 = 288 .mat files of varying size. These data will retain their RGT structure but they will be chunked up into smaller pieces for analysis. This produces 
  
  - **Drivers/**
      Contains a series of "drivers" that operate over the .h5/.nc files. Because the analysis is month-and-beam-by-month-and-beam, these are looped over and output checked against saved data. These          loops take place across hemispheres, years, beams, and month for the conversion script. 
  - **Bash_Scripts/**
      Contains scripts for submitting SLURM jobs that run the relevant conversion code. For example IS2_nc_to_mat.sh submits a job to run drive_conversion.m 
  - _convert_IS2_data_bybeam.m_
      Script to do the actual conversion for a given month/year/beam/hemisphere.

**Analysis/** 

Contains scripts and drivers that analyse RGT-wise data in .mat format to obtain gridded products. The output is places in Output/
  
  - **Drivers/**
      Contains a series of "drivers" that operate over the .mat files. The analysis is looped over month-by-month. These loops take place across hemispheres, years, and month, but accumulate all beams into grids. 
  - **Bash_Scripts/**
      Contains scripts for submitting SLURM jobs that run the relevant conversion code. For example IS2_nc_to_mat.sh submits a job to run drive_conversion.m 
  - _analyse_waves_and_FSD.m_
      Script to do the actual analysis for wave, FSD, LIF info by combining many RGTs into grids using forms of Matlab accumarray function. 

**Output/**
  Subfolder that contains output from Analysis scripts. Output data will be in subfolders of the form HEM-GRID (i.e. NH-100x100 is NH gridded data on a 100x100 km gridding). This data is large and is ignored here except for showing directory structure. 






