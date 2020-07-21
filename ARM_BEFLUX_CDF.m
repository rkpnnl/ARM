% Read the Best Estimate Radiation Flux from ARM VAPs at C1 - sgpbeflux1longC1.c1

function [BEFLUX] = ARM_BEFLUX_CDF(proffile,tol)

% Read the Best Estimate Radiation Fluxes from ARM VAPs at C1

% Input:
% 1. NetCDF filename (proffile)
% 2. Averaging time period in minutes (tol)

% Example: [BEFLUX] = ARM_BEFLUX_CDF('sgpbeflux1longC1.b1.20111125.000000.cdf',15)

% Written by R Krishnamurthy
% Pacific Northwest National Laboratory


BEFLUX.base_time = ncread(proffile,'base_time'); % Base Time seconds since 1970-1-1 0:00:00 0:00
BEFLUX.time_offset = ncread(proffile,'time_offset'); % 'seconds since 2019-07-10 00:00:00 0:00
BEFLUX.time = ncread(proffile,'time'); % seconds since 2019-07-10 00:00:00 0:00
BEFLUX.mtime = double(719529 + BEFLUX.base_time/24/60/60) + BEFLUX.time/24/60/60; % Matlab time

% Average or Interpolate the profiles to "tol" provided in the
% input in minutes
deltaT = (BEFLUX.mtime(2)-BEFLUX.mtime(1))*24*60;

if(deltaT >= tol)
    
    % Interpolate to every 15 minutes
    t2 = BEFLUX.mtime(1):tol/24/60:BEFLUX.mtime(end); % 15 min average measurements
    BEFLUX.mtime_avg = t2;
    
    BEFLUX.down_short_hemisp = interp1(BEFLUX.mtime,ncread(proffile,'down_short_hemisp'),t2);
    BEFLUX.down_long_hemisp = interp1(BEFLUX.mtime,ncread(proffile,'down_long_hemisp'),t2);
    BEFLUX.short_direct_normal = interp1(BEFLUX.mtime,ncread(proffile,'short_direct_normal'),t2);
    BEFLUX.up_short_hemisp = interp1(BEFLUX.mtime,ncread(proffile,'up_short_hemisp'),t2);
    BEFLUX.up_long_hemisp = interp1(BEFLUX.mtime,ncread(proffile,'up_long_hemisp'),t2);
    
    BEFLUX.net_surface_radiation = interp1(BEFLUX.mtime,ncread(proffile,'net_surface_radiation'),t2);
    BEFLUX.albedo = interp1(BEFLUX.mtime,ncread(proffile,'albedo'),t2);
    
    % Filter the data based on QC values
    BEFLUX.down_short_hemisp(interp1(BEFLUX.mtime,double(ncread(proffile,'down_long_hemisp_flag')),t2) < 0) = NaN; % Does not have a flag - used the same for Down Long
    BEFLUX.down_long_hemisp(interp1(BEFLUX.mtime,double(ncread(proffile,'down_long_hemisp_flag')),t2) < 0) = NaN; 
    BEFLUX.short_direct_normal(interp1(BEFLUX.mtime,double(ncread(proffile,'short_direct_normal_flag')),t2) < 0) = NaN; 
    BEFLUX.up_short_hemisp(interp1(BEFLUX.mtime,double(ncread(proffile,'up_short_hemisp_flag')),t2) < 0) = NaN;
    BEFLUX.up_long_hemisp(interp1(BEFLUX.mtime,double(ncread(proffile,'up_long_hemisp_flag')),t2) < 0) = NaN;
    
else
    % Average to every 15 minutes
    t2 = BEFLUX.mtime(1):tol/24/60:BEFLUX.mtime(end); % 15 min average measurements
    BEFLUX.mtime_avg = t2(1:end-1);
    
    BEFLUX.down_short_hemisp = interval_avg(BEFLUX.mtime,ncread(proffile,'down_short_hemisp'),t2);
    BEFLUX.down_long_hemisp = interval_avg(BEFLUX.mtime,ncread(proffile,'down_long_hemisp'),t2);
    BEFLUX.short_direct_normal = interval_avg(BEFLUX.mtime,ncread(proffile,'short_direct_normal'),t2);
    BEFLUX.up_short_hemisp = interval_avg(BEFLUX.mtime,ncread(proffile,'up_short_hemisp'),t2);
    BEFLUX.up_long_hemisp = interval_avg(BEFLUX.mtime,ncread(proffile,'up_long_hemisp'),t2);
    
    BEFLUX.net_surface_radiation = interval_avg(BEFLUX.mtime,ncread(proffile,'net_surface_radiation'),t2);
    BEFLUX.albedo = interval_avg(BEFLUX.mtime,ncread(proffile,'albedo'),t2);
    
    % Filter the data based on QC values
    BEFLUX.down_short_hemisp(interval_avg(BEFLUX.mtime,double(ncread(proffile,'down_long_hemisp_flag')),t2) < 0) = NaN; % Does not have a flag - used the same for Down Long
    BEFLUX.down_long_hemisp(interval_avg(BEFLUX.mtime,double(ncread(proffile,'down_long_hemisp_flag')),t2) < 0) = NaN; 
    BEFLUX.short_direct_normal(interval_avg(BEFLUX.mtime,double(ncread(proffile,'short_direct_normal_flag')),t2) < 0) = NaN; 
    BEFLUX.up_short_hemisp(interval_avg(BEFLUX.mtime,double(ncread(proffile,'up_short_hemisp_flag')),t2) < 0) = NaN;
    BEFLUX.up_long_hemisp(interval_avg(BEFLUX.mtime,double(ncread(proffile,'up_long_hemisp_flag')),t2) < 0) = NaN;
    
end

% General Parameters

BEFLUX.lat = ncread(proffile,'lat');
BEFLUX.lon = ncread(proffile,'lon');
BEFLUX.alt = ncread(proffile,'alt');

% BEFLUX.facility = ncreadatt(proffile,'/','facility_id');
% BEFLUX.site_id = ncreadatt(proffile,'/','site_id');
