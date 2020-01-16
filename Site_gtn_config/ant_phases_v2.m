function [zphi] = ant_phases_v2(fradar,lon,lat,r,theta,c)
% function [zphi] = ant_phases_v2(fradar,lon,lat,r,theta,c)
% 
% input:
%  fradar       = radar operating frequency in MHz
%  lon(1:antN)  = antenna longitudes
%  lat(1:antN)  = antenna latitudes
%  r(1:rN)      = distance(s) to calculate antenna pattern (meters)
%  theta(1:thN) = direction(s) to calculate antenna pattern (math coords)
%  c            = speed of radiowave propogation in air (m/s)
%
% output:
%  zphi(antN,thN,rN) = complex antenna pattern for each antenna (assumes isotropic antennas)
%
% 11/18/2019 -- Douglas Cahl
% University of South Carolina

lambda_radar = c/fradar/10^6; % meters

% antenna positions
mean_lon = mean(lon);
mean_lat = mean(lat);
[x_radar,y_radar] = geog2utm(lon,lat,mean_lon,mean_lat); % zero at midpoint of antennas
x_radar = x_radar*1000; % convert to meters
y_radar = y_radar*1000;

%%%%%%%%%%%%%%%%%%%% antenna pattern
zphi = zeros(length(x_radar),length(theta),length(r));
for j = 1:length(r)
    dist = r(j); % in meters
    x = dist*cosd(theta);
    y = dist*sind(theta);
    
    %%
    zphi1 = zeros(length(x_radar),length(theta));
    for i=1:length(theta)
        d = sqrt( (x(i)-x_radar).^2 + (y(i)-y_radar).^2);   % distance to each antenna
        dd = d - d(1);                                      % difference to antenna 1 distance
        dphi = -2*pi*dd/lambda_radar;   % phase difference in radians to antenna 1
        zphi1(:,i) = exp(1i.*dphi);     % complex antenna pattern
    end
    zphi(:,:,j) = zphi1;
end

end