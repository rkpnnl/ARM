function [ARM] = ARM_Halo_Proc_CDF(proffile)

% Read the Processed Wind Profile CDF files for the ARM Site Doppler Lidars

ARM.base_time = ncread(proffile,'base_time'); % Base Time seconds since 1970-1-1 0:00:00 0:00
ARM.time_offset = ncread(proffile,'time_offset'); % 'seconds since 2019-07-10 00:00:00 0:00
ARM.time = ncread(proffile,'time'); % seconds since 2019-07-10 00:00:00 0:00

ARM.mtime = double(719529 + ARM.base_time/24/60/60) + ARM.time/24/60/60; % Matlab time


ARM.time_bounds = ncread(proffile,'time_bounds'); % Base Time seconds since 1970-1-1 0:00:00 0:00
ARM.height = ncread(proffile,'height'); % Height above ground level
ARM.scan_duration = ncread(proffile,'scan_duration'); % PPI scan duratio
ARM.elevation_angle = ncread(proffile,'elevation_angle'); % Beam elevation angle
ARM.nbeams = ncread(proffile,'nbeams'); % Number of beams (azimuth angles) used in wind vector estimation

ARM.u = ncread(proffile,'u'); % Eastward component of wind vector
ARM.u_error = ncread(proffile,'u_error'); % Estimated error in Eastward component of wind vector
ARM.v = ncread(proffile,'v'); % Northward component of wind vector
ARM.v_error = ncread(proffile,'v_error'); % Estimated error in northward component of wind vector
ARM.w = ncread(proffile,'w'); % Vertical component of wind vector
ARM.w_error = ncread(proffile,'w_error'); % Estimated error in vertical component of wind vector
ARM.wind_speed = ncread(proffile,'wind_speed'); % Wind speed
ARM.wind_speed_error = ncread(proffile,'wind_speed_error'); % Wind speed error
ARM.wind_direction = ncread(proffile,'wind_direction'); % Wind direction
ARM.wind_direction_error = ncread(proffile,'wind_direction_error'); % Wind direction error
ARM.residual = ncread(proffile,'residual'); % Fit residual'
ARM.correlation = ncread(proffile,'correlation'); % Fit correlation coefficient
ARM.mean_snr = ncread(proffile,'mean_snr'); % Signal to noise ratio averaged over nbeams
ARM.snr_threshold = ncread(proffile,'snr_threshold'); % SNR threshold'
ARM.met_wspd = ncread(proffile,'met_wspd'); % Vector mean surface wind speed from MET
ARM.met_wdir = ncread(proffile,'met_wdir'); % Vector mean surface wind direction from MET
ARM.met_spr = ncread(proffile,'met_spr'); % Mean surface precipitation rate during averaging period from MET
ARM.met_spr_min = ncread(proffile,'met_spr_min'); % Minimum surface precipitation rate during averaging period from MET
ARM.met_spr_max = ncread(proffile,'met_spr_max'); % Minimum surface precipitation rate during averaging period from MET
ARM.met_dt = ncread(proffile,'met_dt'); % Averaging period length used for MET data
ARM.met_lat = ncread(proffile,'met_lat'); % MET latitude
ARM.met_lon = ncread(proffile,'met_lon'); % MET longitude
ARM.met_alt = ncread(proffile,'met_alt'); % MET altitude
ARM.lat = ncread(proffile,'lat'); % latitude
ARM.lon = ncread(proffile,'lon'); % MET longitude
ARM.alt = ncread(proffile,'alt'); % altitude
