% Read ARM Tower Processed Eddy Correlation Wind Surface Flux data (Eg.,sgp30ecorE37.b1)
% Datasets are averaged for 30 minutes - 

% Note: Should be interpolated to every 15 minute time intervals for Lidar comparison

function [Met] = ARM_ecor_Proc_CDF(proffile,tol)

% Read the Processed Met Surface Flux NC files for the ARM Site Flux
% Towers (E37, E39 and E41) prior to October 2019

% Input:
% 1. NetCDF filename (proffile)
% 2. Averaging time period in minutes (tol)

% Example: [Met] = ARM_ecor_Proc_CDF('sgp30ecorE37.b1.20111125.000000.cdf',15)

% Written by R Krishnamurthy
% Pacific Northwest National Laboratory


Met.base_time = ncread(proffile,'base_time'); % Base Time seconds since 1970-1-1 0:00:00 0:00
Met.time_offset = ncread(proffile,'time_offset'); % 'seconds since 2019-07-10 00:00:00 0:00
Met.time = ncread(proffile,'time'); % seconds since 2019-07-10 00:00:00 0:00
Met.mtime = double(719529 + Met.base_time/24/60/60) + Met.time/24/60/60; % Matlab time


% Average or Interpolate the profiles to "tol" provided in the
% input in minutes
% Interpolate to every 15 minutes
t2 = Met.mtime(1):tol/24/60:Met.mtime(end); % 15 min average measurements
Met.mtime_avg = t2;

try
    Met.mean_wind = interp1(Met.mtime,ncread(proffile,'wind_spd'),t2);
    Met.wind_direction = interp1(Met.mtime,ncread(proffile,'wind_dir'),t2);
    Met.variance_w = interp1(Met.mtime,ncread(proffile,'var_rot_w'),t2);
    Met.sensible_heat_flux = interp1(Met.mtime,ncread(proffile,'h'),t2);
    Met.latent_heat_flux = interp1(Met.mtime,ncread(proffile,'lv_e'),t2);
    Met.air_temperature = interp1(Met.mtime,ncread(proffile,'temp_irga'),t2);
    Met.friction_velocity = interp1(Met.mtime,ncread(proffile,'ustar'),t2);
    Met.momentum_flux = interp1(Met.mtime,ncread(proffile,'k'),t2);
    Met.mixing_ratio = interp1(Met.mtime,ncread(proffile,'mr'),t2);
    tke = 0.5*(ncread(proffile,'var_rot_u') + ncread(proffile,'var_rot_v') + ncread(proffile,'var_rot_w'));
    Met.turbulent_kinetic_energy = interp1(Met.mtime,tke,t2);

    % Filter the data
    Met.mean_wind(interp1(Met.mtime,double(ncread(proffile,'qc_wind_spd')),t2) > 0) = NaN;
    Met.wind_direction(interp1(Met.mtime,double(ncread(proffile,'qc_wind_dir')),t2) > 0) = NaN;
    Met.air_temperature(interp1(Met.mtime,double(ncread(proffile,'qc_temp_irga')),t2) > 0) = NaN;
    Met.sensible_heat_flux(interp1(Met.mtime,double(ncread(proffile,'qc_h')),t2) > 0) = NaN;
    Met.latent_heat_flux(interp1(Met.mtime,double(ncread(proffile,'qc_lv_e')),t2) > 0) = NaN;
    Met.friction_velocity(interp1(Met.mtime,double(ncread(proffile,'qc_ustar')),t2) > 0) = NaN;
    Met.momentum_flux(interp1(Met.mtime,double(ncread(proffile,'qc_k')),t2) > 0) = NaN;
catch
    Met.mtime_avg = [];
    Met.mean_wind = [];
    Met.wind_direction = [];
    Met.variance_w = [];
    Met.sensible_heat_flux = [];
    Met.latent_heat_flux = [];
    Met.air_temperature = [];
    Met.friction_velocity = [];
    Met.momentum_flux = [];
    Met.mixing_ratio = [];
    Met.turbulent_kinetic_energy = [];
end