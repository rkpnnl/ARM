% Read ARM Tower Processed Eddy Correlation Wind Surface Flux data (Eg.,sgp30co2flx25mC1.b1)
% Datasets are averaged for 30 minutes - 

% Note: Should be interpolated to every 15 minute time intervals for Lidar comparison

function [Met] = ARM_30co2flx_Proc_CDF(proffile,tol)

% Read the Processed Met Surface Flux NC files for the ARM Site Flux
% Towers (E37, E39 and E41) prior to October 2019

% Input:
% 1. NetCDF filename (proffile)
% 2. Averaging time period in minutes (tol)

% Example: [Met] = ARM_30co2flx_Proc_CDF('sgp30co2flx25mC1.b1.20030105.000000.cdf',15)

% Written by R Krishnamurthy
% Pacific Northwest National Laboratory


Met.base_time = ncread(proffile,'base_time'); % Base Time seconds since 1970-1-1 0:00:00 0:00
Met.time_offset = ncread(proffile,'time_offset'); % 'seconds since 2019-07-10 00:00:00 0:00

try
    Met.time = ncread(proffile,'time');
catch
    time = num2str(ncread(proffile,'yyyydddhhmmss')); % yyyy ddd hh mm ss
    year = str2num(time(:,1:4));
    day = str2num(time(:,5:7));
    hours = str2num(time(:,8:9));
    mins = str2num(time(:,10:11));
    secs = str2num(time(:,12:13));
    Met.str = time;
    Met.time = hours*60*60 + mins*60 + secs;
end
Met.mtime = double(719529 + Met.base_time/24/60/60) + Met.time/24/60/60; % Matlab time


% Average or Interpolate the profiles to "tol" provided in the
% input in minutes
% Interpolate to every 15 minutes
t2 = Met.mtime(1):tol/24/60:Met.mtime(end); % 15 min average measurements
Met.mtime_avg = t2;

% try
    Met.sensible_heat_flux = interp1(Met.mtime,ncread(proffile,'h'),t2);% {'corrected sensible heat flux'}
    Met.latent_heat_flux = interp1(Met.mtime,ncread(proffile,'le'),t2);
    Met.zm = ncread(proffile,'zm');
    Met.var_rot_u = interp1(Met.mtime,ncread(proffile,'var_rot_u'),t2);
    Met.var_rot_u(interp1(Met.mtime,double(ncread(proffile,'qc_var_rot_u')),t2) > 0) = NaN;
    Met.var_rot_v = interp1(Met.mtime,ncread(proffile,'var_rot_v'),t2);
    Met.var_rot_v(interp1(Met.mtime,double(ncread(proffile,'qc_var_rot_v')),t2) > 0) = NaN;
    Met.variance_w = interp1(Met.mtime,ncread(proffile,'var_rot_w'),t2);
    Met.variance_w(interp1(Met.mtime,double(ncread(proffile,'qc_var_rot_w')),t2) > 0) = NaN;
    
    Met.turbulent_kinetic_energy = 0.5*(Met.var_rot_u + Met.var_rot_v + Met.variance_w);
    Met.air_temperature = interp1(Met.mtime,ncread(proffile,'mean_t'),t2);
    Met.friction_velocity = interp1(Met.mtime,ncread(proffile,'ustar'),t2);
    Met.mean_wind = interp1(Met.mtime,ncread(proffile,'mean_rot_u'),t2);
    Met.L = interp1(Met.mtime,ncread(proffile,'Lmoni'),t2); % Monin-obukhov length
    Met.wind_direction = interp1(Met.mtime,ncread(proffile,'wdir'),t2);
    
    
    % Filter the data
    Met.mean_wind(interp1(Met.mtime,double(ncread(proffile,'qc_mean_rot_u')),t2) > 0) = NaN;
    Met.wind_direction(interp1(Met.mtime,double(ncread(proffile,'qc_wdir')),t2) > 0) = NaN;
    Met.air_temperature(interp1(Met.mtime,double(ncread(proffile,'qc_mean_t')),t2) > 0) = NaN;
    Met.sensible_heat_flux(interp1(Met.mtime,double(ncread(proffile,'qc_h')),t2) > 0) = NaN;
    Met.latent_heat_flux(interp1(Met.mtime,double(ncread(proffile,'qc_le')),t2) > 0) = NaN;
    Met.friction_velocity(interp1(Met.mtime,double(ncread(proffile,'qc_ustar')),t2) > 0) = NaN;
    Met.L(interp1(Met.mtime,double(ncread(proffile,'qc_Lmoni')),t2) > 0) = NaN;
    
% catch
%     
%     Met.mtime_avg = [];
%     Met.mean_wind = [];
%     Met.wind_direction = [];
%     Met.variance_u = [];
%     Met.variance_v = [];
%     Met.variance_w = [];
%     Met.sensible_heat_flux = [];
%     Met.latent_heat_flux = [];
%     Met.air_temperature = [];
%     Met.friction_velocity = [];
%     Met.L = [];
%     Met.turbulent_kinetic_energy = [];
% end