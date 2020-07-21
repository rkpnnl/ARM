% Read the Surface Energy Budget System data from ARM VAPs at C1 - sgpsebsE37.b1

function [SEBS] = ARM_SEBS_CDF(proffile,tol)

% Read the Surface Energy Budget VAPs - With Soil moisture, temperature,
% Albedo, Net Radiation,down_short_hemisp;up_short_hemisp;down_long;up_long

% Input:
% 1. NetCDF filename (proffile)
% 2. Averaging time period in minutes (tol)

% Example: [SEBS] = ARM_SEBS_CDF('sgpsebsE37.b1.20111125.000000.cdf',15)

% Written by R Krishnamurthy
% Pacific Northwest National Laboratory

SEBS.base_time = ncread(proffile,'base_time'); % Base Time seconds since 1970-1-1 0:00:00 0:00
SEBS.time_offset = ncread(proffile,'time_offset'); % 'seconds since 2019-07-10 00:00:00 0:00
SEBS.time = ncread(proffile,'time'); % seconds since 2019-07-10 00:00:00 0:00
SEBS.mtime = double(719529 + SEBS.base_time/24/60/60) + SEBS.time/24/60/60; % Matlab time

% Average or Interpolate the profiles to "tol" provided in the
% input in minutes
deltaT = (SEBS.mtime(2)-SEBS.mtime(1))*24*60;

if(deltaT >= tol)
    
    % Interpolate to every 15 minutes
    t2 = SEBS.mtime(1):tol/24/60:SEBS.mtime(end); % 15 min average measurements
    SEBS.mtime_avg = t2;
    
    % Save Averaged data
    SEBS.down_short_hemisp = interp1(SEBS.mtime,ncread(proffile,'down_short_hemisp'),t2); % Downwelling shortwave hemispheric irradiance
    SEBS.up_short_hemisp = interp1(SEBS.mtime,ncread(proffile,'up_short_hemisp'),t2); % Upwelling shortwave hemispheric irradiance
    SEBS.down_long = interp1(SEBS.mtime,ncread(proffile,'down_long'),t2); % Sky longwave irradiance
    SEBS.up_long = interp1(SEBS.mtime,ncread(proffile,'up_long'),t2);% Surface longwave irradiance
    
    SEBS.surface_soil_heat_flux_1 = interp1(SEBS.mtime,ncread(proffile,'surface_soil_heat_flux_1'),t2); % in W/m2
    SEBS.surface_soil_heat_flux_2 = interp1(SEBS.mtime,ncread(proffile,'surface_soil_heat_flux_2'),t2);
    SEBS.surface_soil_heat_flux_3 = interp1(SEBS.mtime,ncread(proffile,'surface_soil_heat_flux_3'),t2);
    SEBS.soil_moisture_1 = interp1(SEBS.mtime,ncread(proffile,'soil_moisture_1'),t2);
    SEBS.soil_moisture_2 = interp1(SEBS.mtime,ncread(proffile,'soil_moisture_2'),t2);
    SEBS.soil_moisture_3 = interp1(SEBS.mtime,ncread(proffile,'soil_moisture_3'),t2);
    SEBS.soil_temp_1 = interp1(SEBS.mtime,ncread(proffile,'soil_temp_1'),t2);
    SEBS.soil_temp_2 = interp1(SEBS.mtime,ncread(proffile,'soil_temp_2'),t2);
    SEBS.soil_temp_3 = interp1(SEBS.mtime,ncread(proffile,'soil_temp_3'),t2);

    SEBS.albedo = interp1(SEBS.mtime,ncread(proffile,'albedo'),t2);
    SEBS.net_radiation = interp1(SEBS.mtime,ncread(proffile,'net_radiation'),t2);
    SEBS.surface_energy_balance = interp1(SEBS.mtime,ncread(proffile,'surface_energy_balance'),t2);
    SEBS.wetness = interp1(SEBS.mtime,ncread(proffile,'wetness'),t2);
    
    % Filter data based on QC parameters in the file
    % Note: In this methodology - the neighboring values surrounding a bad
    % data will also be recorded as NaNs - which is best!
    SEBS.down_short_hemisp(interp1(SEBS.mtime,double(ncread(proffile,'qc_down_short_hemisp')),t2)> 0) = NaN;
    SEBS.up_short_hemisp(interp1(SEBS.mtime,double(ncread(proffile,'qc_up_short_hemisp')),t2)> 0) = NaN;
    SEBS.down_long(interp1(SEBS.mtime,double(ncread(proffile,'qc_down_long')),t2)> 0) = NaN;
    SEBS.up_long(interp1(SEBS.mtime,double(ncread(proffile,'qc_up_long')),t2)> 0) = NaN;
    
    SEBS.surface_soil_heat_flux_1(interp1(SEBS.mtime,double(ncread(proffile,'qc_surface_soil_heat_flux_1')),t2)> 0) = NaN;
    SEBS.surface_soil_heat_flux_2(interp1(SEBS.mtime,double(ncread(proffile,'qc_surface_soil_heat_flux_2')),t2)> 0) = NaN;
    SEBS.surface_soil_heat_flux_3(interp1(SEBS.mtime,double(ncread(proffile,'qc_surface_soil_heat_flux_3')),t2)> 0) = NaN;
    SEBS.soil_moisture_1(interp1(SEBS.mtime,double(ncread(proffile,'qc_soil_moisture_1')),t2)> 0) = NaN;
    SEBS.soil_moisture_2(interp1(SEBS.mtime,double(ncread(proffile,'qc_soil_moisture_2')),t2)> 0) = NaN;
    SEBS.soil_moisture_3(interp1(SEBS.mtime,double(ncread(proffile,'qc_soil_moisture_3')),t2)> 0) = NaN;
    SEBS.soil_temp_1(interp1(SEBS.mtime,double(ncread(proffile,'qc_soil_temp_1')),t2)> 0) = NaN;
    SEBS.soil_temp_2(interp1(SEBS.mtime,double(ncread(proffile,'qc_soil_temp_2')),t2)> 0) = NaN;
    SEBS.soil_temp_3(interp1(SEBS.mtime,double(ncread(proffile,'qc_soil_temp_3')),t2)> 0) = NaN;
    
    SEBS.albedo(interp1(SEBS.mtime,double(ncread(proffile,'qc_albedo')),t2)> 0) = NaN;
    SEBS.net_radiation(interp1(SEBS.mtime,double(ncread(proffile,'qc_net_radiation')),t2)> 0) = NaN;
    SEBS.surface_energy_balance(interp1(SEBS.mtime,double(ncread(proffile,'qc_surface_energy_balance')),t2)> 0) = NaN;
    SEBS.wetness(interp1(SEBS.mtime,double(ncread(proffile,'qc_wetness')),t2)> 0) = NaN;
    
else
    % Average to every 15 minutes
    t2 = SEBS.mtime(1):tol/24/60:SEBS.mtime(end); % 15 min average measurements
    SEBS.mtime_avg = t2(1:end-1);
    
    % Save Averaged data
    SEBS.down_short_hemisp = interval_avg(SEBS.mtime,ncread(proffile,'down_short_hemisp'),t2); % Downwelling shortwave hemispheric irradiance
    SEBS.up_short_hemisp = interval_avg(SEBS.mtime,ncread(proffile,'up_short_hemisp'),t2); % Upwelling shortwave hemispheric irradiance
    SEBS.down_long = interval_avg(SEBS.mtime,ncread(proffile,'down_long'),t2); % Sky longwave irradiance
    SEBS.up_long = interval_avg(SEBS.mtime,ncread(proffile,'up_long'),t2);% Surface longwave irradiance

    SEBS.surface_soil_heat_flux_1 = interval_avg(SEBS.mtime,ncread(proffile,'surface_soil_heat_flux_1'),t2); % in W/m2
    SEBS.surface_soil_heat_flux_2 = interval_avg(SEBS.mtime,ncread(proffile,'surface_soil_heat_flux_2'),t2);
    SEBS.surface_soil_heat_flux_3 = interval_avg(SEBS.mtime,ncread(proffile,'surface_soil_heat_flux_3'),t2);
    SEBS.soil_moisture_1 = interval_avg(SEBS.mtime,ncread(proffile,'soil_moisture_1'),t2);
    SEBS.soil_moisture_2 = interval_avg(SEBS.mtime,ncread(proffile,'soil_moisture_2'),t2);
    SEBS.soil_moisture_3 = interval_avg(SEBS.mtime,ncread(proffile,'soil_moisture_3'),t2);
    SEBS.soil_temp_1 = interval_avg(SEBS.mtime,ncread(proffile,'soil_temp_1'),t2);
    SEBS.soil_temp_2 = interval_avg(SEBS.mtime,ncread(proffile,'soil_temp_2'),t2);
    SEBS.soil_temp_3 = interval_avg(SEBS.mtime,ncread(proffile,'soil_temp_3'),t2);

    SEBS.albedo = interval_avg(SEBS.mtime,ncread(proffile,'albedo'),t2);
    SEBS.net_radiation = interval_avg(SEBS.mtime,ncread(proffile,'net_radiation'),t2);
    SEBS.surface_energy_balance = interval_avg(SEBS.mtime,ncread(proffile,'surface_energy_balance'),t2);
    SEBS.wetness = interval_avg(SEBS.mtime,ncread(proffile,'wetness'),t2);
    
    % Filter data based on QC parameters in the file
    % Note: Here any bad data within the averaging interval will be
    % completely removed from the analysis
    SEBS.down_short_hemisp(interval_avg(SEBS.mtime,ncread(proffile,'qc_down_short_hemisp'),t2)> 0) = NaN;
    SEBS.up_short_hemisp(interval_avg(SEBS.mtime,ncread(proffile,'qc_up_short_hemisp'),t2)> 0) = NaN;
    SEBS.down_long(interval_avg(SEBS.mtime,ncread(proffile,'qc_down_long'),t2)> 0) = NaN;
    SEBS.up_long(interval_avg(SEBS.mtime,ncread(proffile,'qc_up_long'),t2)> 0) = NaN;
    
    SEBS.surface_soil_heat_flux_1(interval_avg(SEBS.mtime,ncread(proffile,'qc_surface_soil_heat_flux_1'),t2)> 0) = NaN;
    SEBS.surface_soil_heat_flux_2(interval_avg(SEBS.mtime,ncread(proffile,'qc_surface_soil_heat_flux_2'),t2)> 0) = NaN;
    SEBS.surface_soil_heat_flux_3(interval_avg(SEBS.mtime,ncread(proffile,'qc_surface_soil_heat_flux_3'),t2)> 0) = NaN;
    SEBS.soil_moisture_1(interval_avg(SEBS.mtime,ncread(proffile,'qc_soil_moisture_1'),t2)> 0) = NaN;
    SEBS.soil_moisture_2(interval_avg(SEBS.mtime,ncread(proffile,'qc_soil_moisture_2'),t2)> 0) = NaN;
    SEBS.soil_moisture_3(interval_avg(SEBS.mtime,ncread(proffile,'qc_soil_moisture_3'),t2)> 0) = NaN;
    SEBS.soil_temp_1(interval_avg(SEBS.mtime,ncread(proffile,'qc_soil_temp_1',t2)> 0)) = NaN;
    SEBS.soil_temp_2(interval_avg(SEBS.mtime,ncread(proffile,'qc_soil_temp_2',t2)> 0)) = NaN;
    SEBS.soil_temp_3(interval_avg(SEBS.mtime,ncread(proffile,'qc_soil_temp_3'),t2)> 0) = NaN;
    
    SEBS.albedo(interval_avg(SEBS.mtime,ncread(proffile,'qc_albedo'),t2)> 0) = NaN;
    SEBS.net_radiation(interval_avg(SEBS.mtime,ncread(proffile,'qc_net_radiation'),t2)> 0) = NaN;
    SEBS.surface_energy_balance(interval_avg(SEBS.mtime,ncread(proffile,'qc_surface_energy_balance'),t2)> 0) = NaN;
    SEBS.wetness(interval_avg(SEBS.mtime,ncread(proffile,'qc_wetness'),t2)> 0) = NaN;
    
end

% General Parameters
SEBS.lat = ncread(proffile,'lat'); 
SEBS.lon = ncread(proffile,'lon'); 
SEBS.alt = ncread(proffile,'alt');

SEBS.facility = ncreadatt(proffile,'/','facility_id');
SEBS.site_id = ncreadatt(proffile,'/','site_id');





