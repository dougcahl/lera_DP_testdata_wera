# forked for WERA systems 
WERA test data, antenna position file and some scripts for use with the LERA_DP software


The two timeseries in /Site_gtn_ts/ are included for example data produced by scipts available at https://github.com/dougcahl/WERA_to_DP. One is produced from a .RAW file and the other from a .SORT file. The forked lera_DPd will automatically process either of these formats. 
Dec. 2019 -- Douglas Cahl, dcahl@geol.sc.edu


# lera_DP_testdata



Data for sample calculations

This Repo contains an example folder/subfolder setup needed to utilize LERA_DP as an initial exercise for running the software. Included are all necessary meta data files for the radar setup and pattern information as well as data files for 2 sites used in the pubication that describes this work:


Kirincich, A., B. Emery, L. Washburn, and P. Flament, 2018. Surface Current Mapping Using a Hybrid Direction Finding Approach for Flexible Antenna Arrays, JOAT (submitted).

The full subdirectory structure for each site=XXXX formulated as:

~/SITE_XXXX_ts           %the decimated timeseries files

~/SITE_XXXX_css          %spectral files

~/SITE_XXXX_config       %input header and pattern files 

~/SITE_XXXX              %output 'Radial Metrics' mat file 

~/SITE_XXXX_radave       %output 'Radial Short' mat file  

~/SITE_XXXX_radave_lluv  %output 'Radial Short' ascii lluv format file % suitable for transmission to the national archive

~/SITE_XXXX_pics         %output jpeg images of the processing results 

Started: November, 2018

Anthony Kirincich WHOI-PO akirincich@whoi.edu
