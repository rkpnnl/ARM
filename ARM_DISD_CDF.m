% Read the Disodometer data from ARM VAPs at C1 - sgpvdisC1.b1
% Available from 2011 to atleast 2020

function [DISD] = ARM_DISD_CDF(proffile,tol)

% Read the Disodometer data from ARM VAPs at C1
% Input:
% 1. NetCDF filename (proffile)
% 2. Averaging time period in minutes (tol)

% Example: [DISD] = ARM_DISD_CDF('sgpvdisC1.b1.20111125.000000.cdf',15)

% Written by R Krishnamurthy
% Pacific Northwest National Laboratory


DISD.base_time = ncread(proffile,'base_time'); % Base Time seconds since 1970-1-1 0:00:00 0:00
DISD.time_offset = ncread(proffile,'time_offset'); % 'seconds since 2019-07-10 00:00:00 0:00
DISD.time = ncread(proffile,'time'); % seconds since 2019-07-10 00:00:00 0:00
DISD.mtime = double(719529 + DISD.base_time/24/60/60) + DISD.time/24/60/60; % Matlab time

% Average or Interpolate the profiles to "tol" provided in the
% input in minutes
deltaT = (DISD.mtime(2)-DISD.mtime(1))*24*60;

if(deltaT > tol)
    
    % Interpolate to every 15 minutes
    t2 = DISD.mtime(1):tol/24/60:DISD.mtime(end); % 15 min average measurements
    DISD.mtime_avg = t2;
    
%     DISD.drop_diameter = interp1(DISD.mtime,ncread(proffile,'drop_diameter'),t2); % Also has 50 bins
%     DISD.num_drops = interp1(DISD.mtime,ncread(proffile,'num_drops'),t2);
%     DISD.num_density = interp1(DISD.mtime,ncread(proffile,'num_density'),t2);
    DISD.rain_rate = interp1(DISD.mtime,ncread(proffile,'rain_rate'),t2);
    DISD.rain_amount = interp1(DISD.mtime,ncread(proffile,'rain_amount'),t2);
    DISD.total_drops = interp1(DISD.mtime,ncread(proffile,'total_drops'),t2);
    DISD.liquid_water_content = interp1(DISD.mtime,ncread(proffile,'liquid_water_content'),t2);
    DISD.median_volume_diameter = interp1(DISD.mtime,ncread(proffile,'median_volume_diameter'),t2);

    % Filter the data based on QC values

%     DISD.num_density(interp1(DISD.mtime,double(ncread(proffile,'qc_num_density')),t2)> 0) = NaN; % Does not have a flag - used the same for Down Long
%     DISD.num_drops(interp1(DISD.mtime,double(ncread(proffile,'qc_num_drops')),t2)> 0) = NaN; 
    DISD.rain_rate(interp1(DISD.mtime,double(ncread(proffile,'qc_rain_rate')),t2)> 0) = NaN; 
    DISD.rain_amount(interp1(DISD.mtime,double(ncread(proffile,'qc_rain_amount')),t2)> 0) = NaN;
    DISD.total_drops(interp1(DISD.mtime,double(ncread(proffile,'qc_total_drops')),t2)> 0) = NaN;
    DISD.liquid_water_content(interp1(DISD.mtime,double(ncread(proffile,'qc_liquid_water_content')),t2)> 0) = NaN; 
    DISD.median_volume_diameter(interp1(DISD.mtime,double(ncread(proffile,'qc_median_volume_diameter')),t2)> 0) = NaN;

else
    
    % Average to every 15 minutes
    t2 = DISD.mtime(1):tol/24/60:DISD.mtime(end); % 15 min average measurements
    DISD.mtime_avg = t2(1:end-1);
%     DISD.drop_diameter = interval_avg(DISD.mtime,ncread(proffile,'drop_diameter'),t2);
%     DISD.num_drops = interval_avg(DISD.mtime,ncread(proffile,'num_drops'),t2);
%     DISD.num_density = interval_avg(DISD.mtime,ncread(proffile,'num_density'),t2);
    DISD.rain_rate = interval_avg(DISD.mtime,ncread(proffile,'rain_rate'),t2);
    DISD.rain_amount = interval_avg(DISD.mtime,ncread(proffile,'rain_amount'),t2);
    DISD.total_drops = interval_avg(DISD.mtime,ncread(proffile,'total_drops'),t2);
    DISD.liquid_water_content = interval_avg(DISD.mtime,ncread(proffile,'liquid_water_content'),t2);
    DISD.median_volume_diameter = interval_avg(DISD.mtime,ncread(proffile,'median_volume_diameter'),t2);
    
    % Filter the data based on QC values
    
%     DISD.num_density(interval_avg(DISD.mtime,double(ncread(proffile,'qc_num_density')),t2)> 0) = NaN; % Does not have a flag - used the same for Down Long
%     DISD.num_drops(interval_avg(DISD.mtime,double(ncread(proffile,'qc_num_drops')),t2)> 0) = NaN; 
    DISD.rain_rate(interval_avg(DISD.mtime,double(ncread(proffile,'qc_rain_rate')),t2)> 0) = NaN; 
    DISD.rain_amount(interval_avg(DISD.mtime,double(ncread(proffile,'qc_rain_amount')),t2)> 0) = NaN;
    DISD.total_drops(interval_avg(DISD.mtime,double(ncread(proffile,'qc_total_drops')),t2)> 0) = NaN;
    DISD.liquid_water_content(interval_avg(DISD.mtime,double(ncread(proffile,'qc_liquid_water_content')),t2)> 0) = NaN; 
    DISD.median_volume_diameter(interval_avg(DISD.mtime,double(ncread(proffile,'qc_median_volume_diameter')),t2)> 0) = NaN;
    
end
% General Parameters
DISD.lat = ncread(proffile,'lat');
DISD.lon = ncread(proffile,'lon');
DISD.alt = ncread(proffile,'alt');

DISD.facility = ncreadatt(proffile,'/','facility_id');
DISD.site_id = ncreadatt(proffile,'/','site_id');
