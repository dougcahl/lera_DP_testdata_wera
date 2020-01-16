%% radar_header.m


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% radar_header.m
%
% This m-file contains/loads the setup and sampling parameters for a
% lera radar system. It should be adjusted to be particular to the site
% in question during the site deployment phase an adjusted as needed there
% after.  
%
% Importantly, the lera_DP processing calls this file BOTH during the
% conversion from the raw A2D converted data file to the chirped, decimated
% timeseries file on the site computer as well as when processing the
% timeseries file to spectra and radials. It is critical that the same 
% radar_header file be used for both, and that the parameters correspond to
% how the radar was operated during the data collection period.
%
% Partially to ensure this, radar_header loads a mat file version of the
% same settings transfered to the DDS or DTACQ for operating the radar.
% Thus the file name (and date) of the last radar set up file is a critical
% parameter of this header file.
%
%  created by
%  Anthony Kirincich
%  WHOI PO
%  akirincich@whoi.edu  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 11/15/2019 -- updated for WERA radar system
% Douglas Cahl
% University of South Carolina
% dcahl@geol.sc.edu
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%

%% this filename below (line 43) and the antenna filename (line 74) are required to be set
%
%% decimated TS filename that has a header with the Radar setup
fn = '../Site_gtn_ts/20193221553_gtn.mat'; % decimated TS file from WERA .RAW file
% fn = '../Site_gtn_ts/20193221609_gtn.mat'; % from WERA .SORT file
load(fn,'RC','WERA')

% Radar Bandwidth
RC.Range_Res_km = WERA.RHF;
RC.BW = 3*10^8/(2*WERA.RHF*10^3); % or set manually here in Hz

%% Ranges
try % from WERA .SORT
    RC.Nranges  = WERA.NRRANGES; 
catch % from WERA .RAW
    RC.Nranges  = floor(RC.dec_samps_per_chirp/2);      % number of range bins
end
RC.dr       = RC.c/2/RC.BW;                         % range resolution in meters
RC.R        = (1:RC.Nranges)*RC.dr + RC.RAN_OFF_m;  % ranges in meters


%% %%%%%%%%%%%%%% likely user defined parameters %%%%%%%%
RC.SiteName = 'gtn';

%%% What type of radar is it?  MK2 or 3
%RC.radar_type='MK2';
RC.radar_type = 'WERA';

%%% set info on the antenna makeup
RC.RxAntConfig = '12-channel Linear Array';
% RC.RxAntConfig='8-channel Rectangular Array';
RC.TxAntConfig = '4-post Quad Array';
RC.Tx_bearing = 98; % in degT 

%%% RX array 
ant_pos_file = 'antpos_GTN.asc';  % RX antenna positions file from WERA system
ant = importdata(ant_pos_file,' ',1);
ant = ant.data;
ant_lons = ant(:,3);
ant_lats = ant(:,2);

% the antenna pattern only changes significantly within the first range cell, which isn't used for calculations
% antenna pattern at medium range, ex. r = 100 km
r = 10^5;       % in meters
phi=1:1:360;    % the steering angle, defined following van Trees.
psi0=phi-180;   % the response angle, defined here as the direction a wave-
                % form would be coming from as, measured by the array
                % design, following van Trees.
%%% both phi and psi are in math coordinates!!! %%%
A = ant_phases_v2(RC.Fc,ant_lons,ant_lats,r,phi,RC.c); % complex antenna pattern



% if you have an RXOFFSET
if WERA.RXOFFSET > 0 % should be updated this was used for .SORTs only
    disp('WERA.RXOFFSET > 0, check Doppler for accuracy')
    ddsclk = 90.742153846154*2*10^6; % find in WERA.mes
    % frequency and range offset
    dr = mode(diff(R));
    foff = -1*WERA.RXOFFSET*ddsclk/(2^48);
    rf = 1/(WERA.T_chirp_or);
    % if WERA.T_chirp > 10^4
    %     rf = 1/(WERA.T_chirp/10^6);
    % else
    %     rf = 1/(WERA.T_chirp);
    % end
    fs = 1/WERA.RATE;
    roff = floor(foff/rf);
    doff = foff-roff*rf;
    if doff > rf/2
        roff = roff + 1;
        doff = foff-roff*rf;
    end
    R = R + roff*dr;

    % meters
    r = R*1000;
    if abs(abs(doff) - fs) < .01
        f_offset = 0;
    else
        f_offset = -doff; % Doppler freq = freq - f_offset;
    end
    chirpN = length(t);
    f_radar = RC.Fc * 10^6;
    lambda_bragg = RC.c/f_radar/2;
    f_bragg = sqrt(9.81*2*pi/lambda_bragg)/2/pi;
    RC.r = r; % meters
    RC.R = R; % km
else
    foff = 0;
end

