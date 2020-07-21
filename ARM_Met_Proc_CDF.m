% Read the Met Files (Eg., sgpmetE32.b1) from ARM Sites
% Datasets are averaged for every 1 minute

function [Met] = ARM_Met_Proc_CDF(proffile,tol)

% Read the Processed Met Wind CDF files for the ARM Site Doppler Lidars
% Input:
% 1. NetCDF filename (proffile)
% 2. Averaging time period in minutes (tol)

% Example: [Met] = ARM_Met_CDF('sgpmetE32.b1.20111125.000000.cdf',15)

% Written by R Krishnamurthy
% Pacific Northwest National Laboratory


Met.base_time = ncread(proffile,'base_time'); % Base Time seconds since 1970-1-1 0:00:00 0:00
Met.time_offset = ncread(proffile,'time_offset'); % 'seconds since 2019-07-10 00:00:00 0:00
Met.time = ncread(proffile,'time'); % seconds since 2019-07-10 00:00:00 0:00
Met.mtime = double(719529 + Met.base_time/24/60/60) + Met.time/24/60/60; % Matlab time

% Average or Interpolate the profiles to "tol" provided in the
% input in minutes
deltaT = (Met.mtime(2)-Met.mtime(1))*24*60;

if(deltaT >= tol)
    
    % Interpolate to every 15 minutes
    t2 = Met.mtime(1):tol/24/60:Met.mtime(end); % 15 min average measurements
    Met.mtime_avg = t2;
    
    Met.atmos_pressure = interp1(Met.mtime,ncread(proffile,'atmos_pressure'),t2);
    Met.temp_mean = interp1(Met.mtime,ncread(proffile,'temp_mean'),t2); % qc_temp_mean
    Met.rh_mean = interp1(Met.mtime,ncread(proffile,'rh_mean'),t2);
    Met.vapor_pressure_mean = interp1(Met.mtime,ncread(proffile,'vapor_pressure_mean'),t2); 

    Met.wspd_vec_mean = interp1(Met.mtime,ncread(proffile,'wspd_vec_mean'),t2);
    Met.wdir_vec_mean = interp1(Met.mtime,ncread(proffile,'wdir_vec_mean'),t2); % qc_temp_mean
    Met.tbrg_precip_total_corr = interp1(Met.mtime,ncread(proffile,'tbrg_precip_total_corr'),t2);  % Corrected precipitation total
    
    % Filter the data based on the QC conditions in the Description (0 - data is OK, greater than
    % 0 is potentially bad data)
    
    Met.atmos_pressure(interp1(Met.mtime,double(ncread(proffile,'qc_atmos_pressure')),t2) > 0) = NaN;
    Met.temp_mean(interp1(Met.mtime,double(ncread(proffile,'qc_temp_mean')),t2) > 0) = NaN;
    Met.rh_mean(interp1(Met.mtime,double(ncread(proffile,'qc_rh_mean')),t2) > 0) = NaN;
    Met.vapor_pressure_mean(interp1(Met.mtime,double(ncread(proffile,'qc_vapor_pressure_mean')),t2) > 0) = NaN;
    Met.wspd_vec_mean(interp1(Met.mtime,double(ncread(proffile,'qc_wspd_vec_mean')),t2) > 0) = NaN;
    Met.wdir_vec_mean(interp1(Met.mtime,double(ncread(proffile,'qc_wdir_vec_mean')),t2) > 0) = NaN;
    Met.tbrg_precip_total_corr(interp1(Met.mtime,double(ncread(proffile,'qc_tbrg_precip_total_corr')),t2) > 0) = NaN;
    
else
    
    % Average to every 15 minutes
    t2 = Met.mtime(1):tol/24/60:Met.mtime(end); % 15 min average measurements
    Met.mtime_avg = t2(1:end-1);
    
    Met.atmos_pressure = interval_avg(Met.mtime,ncread(proffile,'atmos_pressure'),t2);
    Met.temp_mean = interval_avg(Met.mtime,ncread(proffile,'temp_mean'),t2); % qc_temp_mean
    Met.rh_mean = interval_avg(Met.mtime,ncread(proffile,'rh_mean'),t2);
    Met.vapor_pressure_mean = interval_avg(Met.mtime,ncread(proffile,'vapor_pressure_mean'),t2); 
    
    Met.wspd_vec_mean = interval_avg(Met.mtime,ncread(proffile,'wspd_vec_mean'),t2);
    Met.wdir_vec_mean = interval_avg(Met.mtime,ncread(proffile,'wdir_vec_mean'),t2); % qc_temp_mean
    Met.tbrg_precip_total_corr = interval_avg(Met.mtime,ncread(proffile,'tbrg_precip_total_corr'),t2);  % Corrected precipitation total
    
    % Filter the data based on the QC conditions in the Description (0 - data is OK, greater than
    % 0 is potentially bad data)
    
    Met.atmos_pressure(interval_avg(Met.mtime,double(ncread(proffile,'qc_atmos_pressure')),t2) > 0) = NaN;
    Met.temp_mean(interval_avg(Met.mtime,double(ncread(proffile,'qc_temp_mean')),t2) > 0) = NaN;
    Met.rh_mean(interval_avg(Met.mtime,double(ncread(proffile,'qc_rh_mean')),t2) > 0) = NaN;
    Met.vapor_pressure_mean(interval_avg(Met.mtime,double(ncread(proffile,'qc_vapor_pressure_mean')),t2) > 0) = NaN;
    Met.wspd_vec_mean(interval_avg(Met.mtime,double(ncread(proffile,'qc_wspd_vec_mean')),t2) > 0) = NaN;
    Met.wdir_vec_mean(interval_avg(Met.mtime,double(ncread(proffile,'qc_wdir_vec_mean')),t2) > 0) = NaN;
    Met.tbrg_precip_total_corr(interval_avg(Met.mtime,double(ncread(proffile,'qc_tbrg_precip_total_corr')),t2) > 0) = NaN;
    
end
    
    
% General parameters

Met.lat = ncread(proffile,'lat'); 
Met.lon = ncread(proffile,'lon'); 
Met.alt = ncread(proffile,'alt');

Met.facility = ncreadatt(proffile,'/','facility_id');
Met.site_id = ncreadatt(proffile,'/','site_id');
