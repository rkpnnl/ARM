% Read the energy balance Bowen ratio (BAEBBR) data from ARM VAPs at C1 - sgp30ebbrE32.b1

function [BAEBBR] = ARM_BABAEBBR_CDF(proffile,tol)

% Read the energy balance Bowen ratio (BAEBBR) VAPs - BEST-ESTIMATE FLUXES 

% Input:
% 1. NetCDF filename (proffile)
% 2. Averaging time period in minutes (tol)

% Example: [BAEBBR] = ARM_BABAEBBR_CDF('sgpbaebbrE37.b1.20111125.000000.cdf',15)

% Written by R Krishnamurthy
% Pacific Northwest National Laboratory

BAEBBR.base_time = ncread(proffile,'base_time'); % Base Time seconds since 1970-1-1 0:00:00 0:00
BAEBBR.time_offset = ncread(proffile,'time_offset'); % 'seconds since 2019-07-10 00:00:00 0:00
BAEBBR.time = ncread(proffile,'time'); % seconds since 2019-07-10 00:00:00 0:00
BAEBBR.mtime = double(719529 + BAEBBR.base_time/24/60/60) + BAEBBR.time/24/60/60; % Matlab time

try
    % Average or Interpolate the profiles to "tol" provided in the
    % input in minutes
    deltaT = (BAEBBR.mtime(2)-BAEBBR.mtime(1))*24*60;

    if(deltaT >= tol)

        % Interpolate to every 15 minutes
        t2 = BAEBBR.mtime(1):tol/24/60:BAEBBR.mtime(end); % 15 min average measurements
        BAEBBR.mtime_avg = t2;

        BAEBBR.friction_velocity = interp1(BAEBBR.mtime,ncread(proffile,'friction_velocity'),t2); 
        BAEBBR.be_latent_heat_flux = interp1(BAEBBR.mtime,ncread(proffile,'be_latent_heat_flux'),t2); 
        BAEBBR.be_sensible_heat_flux = interp1(BAEBBR.mtime,ncread(proffile,'be_sensible_heat_flux'),t2); 
        BAEBBR.vegetation_height = interp1(BAEBBR.mtime,ncread(proffile,'vegetation_height'),t2);
        BAEBBR.solar_radiation = interp1(BAEBBR.mtime,ncread(proffile,'solar_radiation'),t2); 
        BAEBBR.net_radiation = interp1(BAEBBR.mtime,ncread(proffile,'net_radiation'),t2);

        % Filter data based on QC parameters in the file
        BAEBBR.net_radiation(interp1(BAEBBR.mtime,double(ncread(proffile,'qc_net_radiation')),t2)> 0) = NaN;
        BAEBBR.friction_velocity(interp1(BAEBBR.mtime,double(ncread(proffile,'qc_friction_velocity')),t2)> 0) = NaN;
        BAEBBR.be_latent_heat_flux(interp1(BAEBBR.mtime,double(ncread(proffile,'qc_be_latent_heat_flux')),t2)> 0) = NaN;
        BAEBBR.be_sensible_heat_flux(interp1(BAEBBR.mtime,double(ncread(proffile,'qc_be_sensible_heat_flux')),t2)> 0) = NaN;
        BAEBBR.vegetation_height(interp1(BAEBBR.mtime,double(ncread(proffile,'qc_vegetation_height')),t2)> 0) = NaN;
    %     BAEBBR.solar_radiation(interp1(BAEBBR.mtime,double(ncread(proffile,'qc_solar_radiation')),t2)> 0) = NaN;

    else
        % Average to every 15 minutes
        t2 = BAEBBR.mtime(1):tol/24/60:BAEBBR.mtime(end); % 15 min average measurements
        BAEBBR.mtime_avg = t2(1:end-1);

        BAEBBR.friction_velocity = interval_avg(BAEBBR.mtime,ncread(proffile,'friction_velocity'),t2); 
        BAEBBR.be_latent_heat_flux = interval_avg(BAEBBR.mtime,ncread(proffile,'be_latent_heat_flux'),t2); 
        BAEBBR.be_sensible_heat_flux = interval_avg(BAEBBR.mtime,ncread(proffile,'be_sensible_heat_flux'),t2); 
        BAEBBR.vegetation_height = interval_avg(BAEBBR.mtime,ncread(proffile,'vegetation_height'),t2);
        BAEBBR.solar_radiation = interval_avg(BAEBBR.mtime,ncread(proffile,'solar_radiation'),t2); 
        BAEBBR.net_radiation = interval_avg(BAEBBR.mtime,ncread(proffile,'net_radiation'),t2);

        % Filter data based on QC parameters in the file
        BAEBBR.net_radiation(interval_avg(BAEBBR.mtime,double(ncread(proffile,'qc_net_radiation')),t2)> 0) = NaN;
        BAEBBR.friction_velocity(interval_avg(BAEBBR.mtime,double(ncread(proffile,'qc_friction_velocity')),t2)> 0) = NaN;
        BAEBBR.be_latent_heat_flux(interval_avg(BAEBBR.mtime,double(ncread(proffile,'qc_be_latent_heat_flux')),t2)> 0) = NaN;
        BAEBBR.be_sensible_heat_flux(interval_avg(BAEBBR.mtime,double(ncread(proffile,'qc_be_sensible_heat_flux')),t2)> 0) = NaN;
        BAEBBR.vegetation_height(interval_avg(BAEBBR.mtime,double(ncread(proffile,'qc_vegetation_height')),t2)> 0) = NaN;
    %     BAEBBR.solar_radiation(interval_avg(BAEBBR.mtime,double(ncread(proffile,'qc_solar_radiation')),t2)> 0) = NaN;

    end
catch
    BAEBBR.mtime_avg = [];
    BAEBBR.friction_velocity = []; 
    BAEBBR.be_latent_heat_flux = []; 
    BAEBBR.be_sensible_heat_flux = []; 
    BAEBBR.vegetation_height = [];
    BAEBBR.solar_radiation = []; 
    BAEBBR.net_radiation = [];
end
% General Parameters
BAEBBR.lat = ncread(proffile,'lat'); 
BAEBBR.lon = ncread(proffile,'lon'); 
BAEBBR.alt = ncread(proffile,'alt');

BAEBBR.facility = ncreadatt(proffile,'/','facility_id');
BAEBBR.site_id = ncreadatt(proffile,'/','site_id');
