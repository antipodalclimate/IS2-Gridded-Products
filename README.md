# IS2-Gridded Product
Code for analyzing tracks and converting to a specified gridded product

To be filled out. 

Generally, consists of code that processes data from an existing set of .h5 or .nc files. It then accumulates statistics into bins at a specified time and spatial resolution to create value-added products. 

First, we need to download and examine data derived from a set of .h5/.nc files from ICESat-2. 

-Data/All_Tracks_NetCDF/

Contains an un-ordered set of .h5 (.nc) files that we wish to grid and compare. These are files of the form: processed_ATL07-01_20181031065620_04990101_006_02.nc

Convert_NC_to_Mat/
  - convert_IS2_data_bybeam.m

Contains a script that takes in IS2 data and organizes it into Matlab compatible .mat files broken down by each month/year/beam of the satellite and selecting only the specific fields desired for the analysis. 

If there are 10,000 tracks covering 2 full years, for example, this will take the 10,000 different .h5 files and convert to a set ot 12 x 2 x 6 = 144 .mat files of varying size. These data will retain their RGT structure but they will be chunked up into smaller pieces for analysis. 




