% Read the energy balance Bowen ratio (EBBR) data from ARM VAPs at C1 - sgp30ebbrE32.b1

function [EBBR] = ARM_EBBR_CDF(proffile, tol)

% Read the energy balance Bowen ratio (EBBR) VAPs - With Soil moisture, temperature,
% Net Radiation,friction, velocity, bowen_ratio, latent_heat_flux, sensible_heat_flux', 

% Input:
% 1. NetCDF filename (proffile)
% 2. Averaging time period in minutes (tol)

% Example: [EBBR] = ARM_EBBR_CDF('sgpebbrE37.b1.20111125.000000.cdf',15)

% Written by R Krishnamurthy
% Pacific Northwest National Laboratory

EBBR.base_time = ncread(proffile,'base_time'); % Base Time seconds since 1970-1-1 0:00:00 0:00
EBBR.time_offset = ncread(proffile,'time_offset'); % 'seconds since 2019-07-10 00:00:00 0:00
EBBR.time = ncread(proffile,'time'); % seconds since 2019-07-10 00:00:00 0:00
EBBR.mtime = double(719529 + EBBR.base_time/24/60/60) + EBBR.time/24/60/60; % Matlab time

try
    % Average or Interpolate the profiles to "tol" provided in the
    % input in minutes
    deltaT = (EBBR.mtime(2)-EBBR.mtime(1))*24*60;

    if(deltaT >= tol)

        % Interpolate to every 15 minutes
        t2 = EBBR.mtime(1):tol/24/60:EBBR.mtime(end); % 15 min average measurements
        EBBR.mtime_avg = t2;

        % Save Averaged data
        EBBR.net_radiation = interp1(EBBR.mtime,ncread(proffile,'net_radiation'),t2); % Downwelling shortwave hemispheric irradiance
        EBBR.surface_soil_heat_flux_1 = interp1(EBBR.mtime,ncread(proffile,'surface_soil_heat_flux_avg'),t2); % in W/m2
        EBBR.surface_soil_heat_flux_2 = interp1(EBBR.mtime,ncread(proffile,'surface_soil_heat_flux_2'),t2);
        EBBR.surface_soil_heat_flux_3 = interp1(EBBR.mtime,ncread(proffile,'surface_soil_heat_flux_3'),t2);
        EBBR.soil_moisture_1 = interp1(EBBR.mtime,ncread(proffile,'soil_moisture_1'),t2);
        EBBR.soil_moisture_2 = interp1(EBBR.mtime,ncread(proffile,'soil_moisture_2'),t2);
        EBBR.soil_moisture_3 = interp1(EBBR.mtime,ncread(proffile,'soil_moisture_3'),t2);
        EBBR.soil_temp_1 = interp1(EBBR.mtime,ncread(proffile,'soil_temp_1'),t2);
        EBBR.soil_temp_2 = interp1(EBBR.mtime,ncread(proffile,'soil_temp_2'),t2);
        EBBR.soil_temp_3 = interp1(EBBR.mtime,ncread(proffile,'soil_temp_3'),t2);

        EBBR.bowen_ratio = interp1(EBBR.mtime,ncread(proffile,'bowen_ratio'),t2);
        EBBR.latent_heat_flux = interp1(EBBR.mtime,ncread(proffile,'latent_heat_flux'),t2);
        EBBR.sensible_heat_flux = interp1(EBBR.mtime,ncread(proffile,'sensible_heat_flux'),t2);

        % Filter data based on QC parameters in the file
        EBBR.net_radiation(interp1(EBBR.mtime,double(ncread(proffile,'qc_net_radiation')),t2)> 0) = NaN;
        EBBR.surface_soil_heat_flux_1(interp1(EBBR.mtime,double(ncread(proffile,'qc_surface_soil_heat_flux_avg')),t2)> 0) = NaN;
        EBBR.surface_soil_heat_flux_2(interp1(EBBR.mtime,double(ncread(proffile,'qc_surface_soil_heat_flux_2')),t2)> 0) = NaN;
        EBBR.surface_soil_heat_flux_3(interp1(EBBR.mtime,double(ncread(proffile,'qc_surface_soil_heat_flux_3')),t2)> 0) = NaN;
        EBBR.soil_moisture_1(interp1(EBBR.mtime,double(ncread(proffile,'qc_soil_moisture_1')),t2)> 0) = NaN;
        EBBR.soil_moisture_2(interp1(EBBR.mtime,double(ncread(proffile,'qc_soil_moisture_2')),t2)> 0) = NaN;
        EBBR.soil_moisture_3(interp1(EBBR.mtime,double(ncread(proffile,'qc_soil_moisture_3')),t2)> 0) = NaN;
        EBBR.soil_temp_1(interp1(EBBR.mtime,double(ncread(proffile,'qc_soil_temp_1')),t2)> 0) = NaN;
        EBBR.soil_temp_2(interp1(EBBR.mtime,double(ncread(proffile,'qc_soil_temp_2')),t2)> 0) = NaN;
        EBBR.soil_temp_3(interp1(EBBR.mtime,double(ncread(proffile,'qc_soil_temp_3')),t2)> 0) = NaN;
        EBBR.bowen_ratio(interp1(EBBR.mtime,double(ncread(proffile,'qc_bowen_ratio')),t2)> 0) = NaN;
        EBBR.latent_heat_flux(interp1(EBBR.mtime,double(ncread(proffile,'qc_latent_heat_flux')),t2)> 0) = NaN;
        EBBR.sensible_heat_flux(interp1(EBBR.mtime,double(ncread(proffile,'qc_sensible_heat_flux')),t2)> 0) = NaN;

    else 
        % Average to every 15 minutes
        t2 = EBBR.mtime(1):tol/24/60:EBBR.mtime(end); % 15 min average measurements
        EBBR.mtime_avg = t2(1:end-1);
        
        % Save Averaged data
        EBBR.net_radiation = interval_avg(EBBR.mtime,ncread(proffile,'net_radiation'),t2); % Downwelling shortwave hemispheric irradiance
        EBBR.surface_soil_heat_flux_1 = interval_avg(EBBR.mtime,ncread(proffile,'surface_soil_heat_flux_avg'),t2); % in W/m2
        EBBR.surface_soil_heat_flux_2 = interval_avg(EBBR.mtime,ncread(proffile,'surface_soil_heat_flux_2'),t2);
        EBBR.surface_soil_heat_flux_3 = interval_avg(EBBR.mtime,ncread(proffile,'surface_soil_heat_flux_3'),t2);
        EBBR.soil_moisture_1 = interval_avg(EBBR.mtime,ncread(proffile,'soil_moisture_1'),t2);
        EBBR.soil_moisture_2 = interval_avg(EBBR.mtime,ncread(proffile,'soil_moisture_2'),t2);
        EBBR.soil_moisture_3 = interval_avg(EBBR.mtime,ncread(proffile,'soil_moisture_3'),t2);
        EBBR.soil_temp_1 = interval_avg(EBBR.mtime,ncread(proffile,'soil_temp_1'),t2);
        EBBR.soil_temp_2 = interval_avg(EBBR.mtime,ncread(proffile,'soil_temp_2'),t2);
        EBBR.soil_temp_3 = interval_avg(EBBR.mtime,ncread(proffile,'soil_temp_3'),t2);

        EBBR.bowen_ratio = interval_avg(EBBR.mtime,ncread(proffile,'bowen_ratio'),t2);
        EBBR.latent_heat_flux = interval_avg(EBBR.mtime,ncread(proffile,'latent_heat_flux'),t2);
        EBBR.sensible_heat_flux = interval_avg(EBBR.mtime,ncread(proffile,'sensible_heat_flux'),t2);

        % Filter data based on QC parameters in the file
        EBBR.net_radiation(interval_avg(EBBR.mtime,double(ncread(proffile,'qc_net_radiation')),t2)> 0) = NaN;
        EBBR.surface_soil_heat_flux_1(interval_avg(EBBR.mtime,double(ncread(proffile,'qc_surface_soil_heat_flux_avg')),t2)> 0) = NaN;
        EBBR.surface_soil_heat_flux_2(interval_avg(EBBR.mtime,double(ncread(proffile,'qc_surface_soil_heat_flux_2')),t2)> 0) = NaN;
        EBBR.surface_soil_heat_flux_3(interval_avg(EBBR.mtime,double(ncread(proffile,'qc_surface_soil_heat_flux_3')),t2)> 0) = NaN;
        EBBR.soil_moisture_1(interval_avg(EBBR.mtime,double(ncread(proffile,'qc_soil_moisture_1')),t2)> 0) = NaN;
        EBBR.soil_moisture_2(interval_avg(EBBR.mtime,double(ncread(proffile,'qc_soil_moisture_2')),t2)> 0) = NaN;
        EBBR.soil_moisture_3(interval_avg(EBBR.mtime,double(ncread(proffile,'qc_soil_moisture_3')),t2)> 0) = NaN;
        EBBR.soil_temp_1(interval_avg(EBBR.mtime,double(ncread(proffile,'qc_soil_temp_1')),t2)> 0) = NaN;
        EBBR.soil_temp_2(interval_avg(EBBR.mtime,double(ncread(proffile,'qc_soil_temp_2')),t2)> 0) = NaN;
        EBBR.soil_temp_3(interval_avg(EBBR.mtime,double(ncread(proffile,'qc_soil_temp_3')),t2)> 0) = NaN;
        EBBR.bowen_ratio(interval_avg(EBBR.mtime,double(ncread(proffile,'qc_bowen_ratio')),t2)> 0) = NaN;
        EBBR.latent_heat_flux(interval_avg(EBBR.mtime,double(ncread(proffile,'qc_latent_heat_flux')),t2)> 0) = NaN;
        EBBR.sensible_heat_flux(interval_avg(EBBR.mtime,double(ncread(proffile,'qc_sensible_heat_flux')),t2)> 0) = NaN;
    end
catch
    EBBR.mtime_avg = [];
    EBBR.net_radiation = []; % Downwelling shortwave hemispheric irradiance
    EBBR.surface_soil_heat_flux_1 = []; % in W/m2
    EBBR.surface_soil_heat_flux_2 = [];
    EBBR.surface_soil_heat_flux_3 = [];
    EBBR.soil_moisture_1 = [];
    EBBR.soil_moisture_2 = [];
    EBBR.soil_moisture_3 = [];
    EBBR.soil_temp_1 = [];
    EBBR.soil_temp_2 = [];
    EBBR.soil_temp_3 = [];
    EBBR.bowen_ratio = [];
    EBBR.latent_heat_flux = [];
    EBBR.sensible_heat_flux = [];
end
    
% General Parameters
EBBR.lat = ncread(proffile,'lat'); 
EBBR.lon = ncread(proffile,'lon'); 
EBBR.alt = ncread(proffile,'alt');

EBBR.facility = ncreadatt(proffile,'/','facility_id');
EBBR.site_id = ncreadatt(proffile,'/','site_id');
