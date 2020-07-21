% Read the Soil Surface and Depth data from ARM VAPs at C1 - sgpco2flxsoilauxC1.b1

function [SoilAux] = ARM_SoilAux_CDF(proffile,tol)

% Read the Soil Surface Characteristics VAPs

% Input:
% 1. NetCDF filename (proffile)
% 2. Averaging time period in minutes (tol)

% Example: [SoilAux] = ARM_SoilAux_CDF('sgpco2flxsoilauxC1.b1.20111125.000000.cdf',15)

% Written by R Krishnamurthy
% Pacific Northwest National Laboratory


SoilAux.base_time = ncread(proffile,'base_time'); % Base Time seconds since 1970-1-1 0:00:00 0:00
SoilAux.time_offset = ncread(proffile,'time_offset'); % 'seconds since 2019-07-10 00:00:00 0:00
SoilAux.time = ncread(proffile,'time'); % seconds since 2019-07-10 00:00:00 0:00
SoilAux.mtime = double(719529 + SoilAux.base_time/24/60/60) + SoilAux.time/24/60/60; % Matlab time

% Average or Interpolate the profiles to "tol" provided in the
% input in minutes
deltaT = (SoilAux.mtime(2)-SoilAux.mtime(1))*24*60;

if(deltaT >= tol)
    
    % Interpolate to every 15 minutes
    t2 = SoilAux.mtime(1):tol/24/60:SoilAux.mtime(end); % 15 min average measurements
    SoilAux.mtime_avg = t2;
    
    SoilAux.sensor_depth = interp1(SoilAux.mtime,ncread(proffile,'sensor_depth'),t2);
    SoilAux.soil_moisture = interp1(SoilAux.mtime,ncread(proffile,'auxiliary_volumetric_water_content'),t2);
    SoilAux.soil_conduc = interp1(SoilAux.mtime,ncread(proffile,'auxiliary_soil_electrical_conductivity'),t2);
    SoilAux.soil_temp = interp1(SoilAux.mtime,ncread(proffile,'auxiliary_soil_temperature'),t2);
    SoilAux.soil_perm = interp1(SoilAux.mtime,ncread(proffile,'auxiliary_permittivity'),t2);

    % Filter the data based on QC values
    SoilAux.soil_moisture(interp1(SoilAux.mtime,double(ncread(proffile,'qc_auxiliary_volumetric_water_content')),t2)> 0) = NaN; 
    SoilAux.soil_conduc(interp1(SoilAux.mtime,double(ncread(proffile,'qc_auxiliary_soil_electrical_conductivity')),t2)> 0) = NaN; 
    SoilAux.soil_temp(interp1(SoilAux.mtime,double(ncread(proffile,'qc_auxiliary_soil_temperature')),t2)> 0) = NaN; 
    SoilAux.soil_perm(interp1(SoilAux.mtime,double(ncread(proffile,'qc_auxiliary_permittivity')),t2)> 0) = NaN;
    
else
    % Average to every 15 minutes
    t2 = SoilAux.mtime(1):tol/24/60:SoilAux.mtime(end); % 15 min average measurements
    SoilAux.mtime_avg = t2(1:end-1);
    
    SoilAux.sensor_depth = ncread(proffile,'sensor_depth');
    SoilAux.soil_moisture = interval_avg(SoilAux.mtime,ncread(proffile,'auxiliary_volumetric_water_content')',t2);
    SoilAux.soil_conduc = interval_avg(SoilAux.mtime,ncread(proffile,'auxiliary_soil_electrical_conductivity')',t2);
    SoilAux.soil_temp = interval_avg(SoilAux.mtime,ncread(proffile,'auxiliary_soil_temperature')',t2);
    SoilAux.soil_perm = interval_avg(SoilAux.mtime,ncread(proffile,'auxiliary_permittivity')',t2);

    % Filter the data based on QC values
    SoilAux.soil_moisture(interval_avg(SoilAux.mtime,double(ncread(proffile,'qc_auxiliary_volumetric_water_content'))',t2)> 0) = NaN; 
    SoilAux.soil_conduc(interval_avg(SoilAux.mtime,double(ncread(proffile,'qc_auxiliary_soil_electrical_conductivity'))',t2)> 0) = NaN; 
    SoilAux.soil_temp(interval_avg(SoilAux.mtime,double(ncread(proffile,'qc_auxiliary_soil_temperature'))',t2)> 0) = NaN; 
    SoilAux.soil_perm(interval_avg(SoilAux.mtime,double(ncread(proffile,'qc_auxiliary_permittivity'))',t2)> 0) = NaN;
    
end

% General Parameters
SoilAux.lat = ncread(proffile,'lat');
SoilAux.lon = ncread(proffile,'lon');
SoilAux.alt = ncread(proffile,'alt');

SoilAux.facility = ncreadatt(proffile,'/','facility_id');
SoilAux.site_id = ncreadatt(proffile,'/','site_id');
