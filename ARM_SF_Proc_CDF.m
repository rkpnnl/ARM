
% Read ARM Tower Processed Eddy Correlation Wind Surface Flux data (Eg.,sgpecorsfE37.b1 & sgpco2flx4mC1.b1)
% Datasets are averaged for 30 minutes - 

% Note: Should be interpolated to every 15 minute time intervals for Lidar comparison

function [Met] = ARM_SF_Proc_CDF(proffile,tol)

% Read the Processed Met Surface Flux NC files for the ARM Site Flux
% Towers (E37, E39 and E41)

% Input:
% 1. NetCDF filename (proffile)
% 2. Averaging time period in minutes (tol)

% Example: [Met] = ARM_Met_CDF('sgpmetE32.b1.20111125.000000.cdf',15)

% Written by R Krishnamurthy
% Pacific Northwest National Laboratory


Met.base_time = ncread(proffile,'base_time'); % Base Time seconds since 1970-1-1 0:00:00 0:00
Met.time_offset = ncread(proffile,'time_offset'); % 'seconds since 2019-07-10 00:00:00 0:00
Met.time = ncread(proffile,'time'); % seconds since 2019-07-10 00:00:00 0:00

try
    K = ncread(proffile,'latent_heat_flux'); % for site C1
    Met.mtime = double(719529 + Met.base_time/24/60/60) + (Met.time-900)/24/60/60; % Matlab time make it start time
catch
    Met.mtime = double(719529 + Met.base_time/24/60/60) + Met.time/24/60/60; % Matlab time
end


try
    Met.day_of_year = ncread(proffile,'day_of_year'); %  Day of Year
catch
    disp('No Day of Year in this file')
end

% Average or Interpolate the profiles to "tol" provided in the
% input in minutes
deltaT = (Met.mtime(2)-Met.mtime(1))*24*60;

if(deltaT >= tol)
    
    % Interpolate to every 15 minutes
    t2 = Met.mtime(1):tol/24/60:Met.mtime(end); % 15 min average measurements
    Met.mtime_avg = t2;
    
    Met.momentum_flux = interp1(Met.mtime,ncread(proffile,'momentum_flux'),t2);
    Met.sensible_heat_flux = interp1(Met.mtime,ncread(proffile,'sensible_heat_flux'),t2);
    
    try
        Met.latent_heat_flux = interp1(Met.mtime,ncread(proffile,'latent_flux'),t2); 
    catch
        Met.latent_heat_flux = interp1(Met.mtime,ncread(proffile,'latent_heat_flux'),t2); % for site C1
    end
    
    Met.co2_flux = interp1(Met.mtime,ncread(proffile,'co2_flux'),t2); 
    Met.h2o_flux = interp1(Met.mtime,ncread(proffile,'h2o_flux'),t2);
    Met.h2o_mixing_ratio = interp1(Met.mtime,ncread(proffile,'h2o_mixing_ratio'),t2); 

    Met.air_temperature = interp1(Met.mtime,ncread(proffile,'air_temperature'),t2); 
    Met.air_pressure = interp1(Met.mtime,ncread(proffile,'air_pressure'),t2);
    Met.air_density = interp1(Met.mtime,ncread(proffile,'air_density'),t2);
    Met.specific_humidity = interp1(Met.mtime,ncread(proffile,'specific_humidity'),t2);
    try
        Met.evapotranspiration_flux = interp1(Met.mtime,ncread(proffile,'evapotranspiration_flux'),t2); 
    catch
        Met.evapotranspiration_flux = interp1(Met.mtime,ncread(proffile,'evapotranspiration_rate'),t2);
    end

    Met.relative_humidity = interp1(Met.mtime,ncread(proffile,'relative_humidity'),t2);
    Met.dew_point_temperature = interp1(Met.mtime,ncread(proffile,'dew_point_temperature'),t2); 

    try
        Met.wind_u_component = interp1(Met.mtime,ncread(proffile,'wind_u_component'),t2);
    catch
        Met.wind_u_component = interp1(Met.mtime,ncread(proffile,'eastward_wind'),t2);
    end

    try
        Met.wind_v_component = interp1(Met.mtime,ncread(proffile,'wind_v_component'),t2); % change to rotated winds for consistency
    catch
        Met.wind_v_component = interp1(Met.mtime,ncread(proffile,'northward_wind'),t2); % Rotated winds
    end

    try
        Met.wind_w_component = interp1(Met.mtime,ncread(proffile,'wind_w_component'),t2);
    catch
        Met.wind_w_component = interp1(Met.mtime,ncread(proffile,'vertical_wind'),t2);
    end
    
    try
        Met.mean_wind = interp1(Met.mtime,ncread(proffile,'mean_wind'),t2); 
    catch
        Met.mean_wind = interp1(Met.mtime,ncread(proffile,'wind_speed'),t2);
    end
    try
        Met.wind_direction = interp1(Met.mtime,ncread(proffile,'wind_direction_from_north'),t2);
    catch
        Met.wind_direction = interp1(Met.mtime,ncread(proffile,'wind_direction'),t2);
    end

    Met.friction_velocity = interp1(Met.mtime,ncread(proffile,'friction_velocity'),t2);
    Met.turbulent_kinetic_energy = interp1(Met.mtime,ncread(proffile,'turbulent_kinetic_energy'),t2);
    try
        Met.Monin_Obukhov_length = interp1(Met.mtime,ncread(proffile,'Monin_Obukhov_length'),t2);
    catch
        Met.Monin_Obukhov_length = interp1(Met.mtime,ncread(proffile,'monin_obukov_length'),t2);
    end

    try
        Met.Monin_Obukhov_stability_parameter = interp1(Met.mtime,ncread(proffile,'Monin_Obukhov_stability_parameter'),t2);
    catch
        Met.Monin_Obukhov_stability_parameter = interp1(Met.mtime,ncread(proffile,'monin_obukov_stability_parameter'),t2);
    end

    try
        Met.Bowen_ratio = interp1(Met.mtime,ncread(proffile,'Bowen_ratio'),t2);
    catch
        Met.Bowen_ratio = interp1(Met.mtime,ncread(proffile,'bowen_ratio'),t2);
    end

    try
        Met.variance_u = interp1(Met.mtime,ncread(proffile,'variance_u'),t2);
    catch
        Met.variance_u = interp1(Met.mtime,ncread(proffile,'eastward_wind_variance'),t2);
    end

    try
        Met.variance_v = interp1(Met.mtime,ncread(proffile,'variance_v'),t2); 
    catch
        Met.variance_v = interp1(Met.mtime,ncread(proffile,'northward_wind_variance'),t2); 
    end

    try
        Met.variance_w = interp1(Met.mtime,ncread(proffile,'variance_w'),t2);
    catch
        Met.variance_w = interp1(Met.mtime,ncread(proffile,'vertical_wind_variance'),t2);
    end
    
    % Filter the data based on QC values (0 is good, greater than 0 is bad)
    try
        Met.momentum_flux(interp1(Met.mtime,double(ncread(proffile,'qc_momentum_flux')),t2) > 0) = NaN;
        Met.sensible_heat_flux(interp1(Met.mtime,double(ncread(proffile,'qc_sensible_heat_flux')),t2) > 0) = NaN;
        Met.latent_heat_flux(interp1(Met.mtime,double(ncread(proffile,'qc_latent_flux')),t2) > 0) = NaN;
        Met.co2_flux(interp1(Met.mtime,double(ncread(proffile,'qc_co2_flux')),t2) > 0) = NaN;
        Met.h2o_flux(interp1(Met.mtime,double(ncread(proffile,'qc_h2o_flux')),t2) > 0) = NaN;
        Met.air_temperature(interp1(Met.mtime,double(ncread(proffile,'qc_air_temperature')),t2) > 0) = NaN;
        Met.air_pressure(interp1(Met.mtime,double(ncread(proffile,'qc_air_pressure')),t2) > 0) = NaN;
        Met.air_density(interp1(Met.mtime,double(ncread(proffile,'qc_air_density')),t2) > 0) = NaN;
        Met.wind_u_component(interp1(Met.mtime,double(ncread(proffile,'qc_wind_u_component')),t2) > 0) = NaN;
        Met.wind_v_component(interp1(Met.mtime,double(ncread(proffile,'qc_wind_v_component')),t2) > 0) = NaN;
        Met.wind_w_component(interp1(Met.mtime,double(ncread(proffile,'qc_wind_w_component')),t2) > 0) = NaN;
        Met.mean_wind(interp1(Met.mtime,double(ncread(proffile,'qc_mean_wind')),t2) > 0) = NaN;
        Met.wind_direction(interp1(Met.mtime,double(ncread(proffile,'qc_wind_direction_from_north')),t2) > 0) = NaN;
        Met.variance_u(interp1(Met.mtime,double(ncread(proffile,'qc_variance_u')),t2) > 0) = NaN;
        Met.variance_v(interp1(Met.mtime,double(ncread(proffile,'qc_variance_v')),t2) > 0) = NaN;
        Met.variance_w(interp1(Met.mtime,double(ncread(proffile,'qc_variance_w')),t2) > 0) = NaN;
    catch
        Met.momentum_flux(Met.momentum_flux == -9999) = NaN;
        Met.sensible_heat_flux(Met.sensible_heat_flux == -9999) = NaN;
        Met.latent_flux(Met.latent_heat_flux == -9999) = NaN;
        Met.co2_flux(Met.co2_flux == -9999) = NaN;
        Met.h2o_flux(Met.h2o_flux == -9999) = NaN;
        Met.air_temperature(Met.air_temperature == -9999) = NaN;
        Met.air_pressure(Met.air_pressure == -9999) = NaN;
        Met.air_density(Met.air_density == -9999) = NaN;
        Met.wind_u_component(Met.wind_u_component == -9999) = NaN;
        Met.wind_v_component(Met.wind_v_component == -9999) = NaN;
        Met.wind_w_component(Met.wind_w_component == -9999) = NaN;
        Met.mean_wind(Met.mean_wind == -9999) = NaN;
        Met.wind_direction(Met.wind_direction == -9999) = NaN;
        Met.variance_u(Met.variance_u == -9999) = NaN;
        Met.variance_v(Met.variance_v == -9999) = NaN;
        Met.variance_w(Met.variance_w == -9999) = NaN;
    end
    
else
    
    % Average to every 15 minutes
    t2 = Met.mtime(1):tol/24/60:Met.mtime(end); % 15 min average measurements
    Met.mtime_avg = t2(1:end-1);
    
    Met.momentum_flux = interval_avg(Met.mtime,ncread(proffile,'momentum_flux'),t2);
    Met.sensible_heat_flux = interval_avg(Met.mtime,ncread(proffile,'sensible_heat_flux'),t2);
    try
        Met.latent_heat_flux = interval_avg(Met.mtime,ncread(proffile,'latent_flux'),t2); 
    catch
        Met.latent_heat_flux = interval_avg(Met.mtime,ncread(proffile,'latent_heat_flux'),t2); % for site C1
    end

    Met.co2_flux = interval_avg(Met.mtime,ncread(proffile,'co2_flux'),t2); 
    Met.h2o_flux = interval_avg(Met.mtime,ncread(proffile,'h2o_flux'),t2);
    Met.h2o_mixing_ratio = interval_avg(Met.mtime,ncread(proffile,'h2o_mixing_ratio'),t2); 
    
    Met.air_temperature = interval_avg(Met.mtime,ncread(proffile,'air_temperature'),t2); 
    Met.air_pressure = interval_avg(Met.mtime,ncread(proffile,'air_pressure'),t2);
    Met.air_density = interval_avg(Met.mtime,ncread(proffile,'air_density'),t2);
    Met.specific_humidity = interval_avg(Met.mtime,ncread(proffile,'specific_humidity'),t2);
    try
        Met.evapotranspiration_flux = interval_avg(Met.mtime,ncread(proffile,'evapotranspiration_flux'),t2); 
    catch
        Met.evapotranspiration_flux = interval_avg(Met.mtime,ncread(proffile,'evapotranspiration_rate'),t2);
    end

    Met.relative_humidity = interval_avg(Met.mtime,ncread(proffile,'relative_humidity'),t2);
    Met.dew_point_temperature = interval_avg(Met.mtime,ncread(proffile,'dew_point_temperature'),t2); 
    
    try
        Met.wind_u_component = interval_avg(Met.mtime,ncread(proffile,'wind_u_component'),t2);
    catch
        Met.wind_u_component = interval_avg(Met.mtime,ncread(proffile,'eastward_wind'),t2);
    end

    try
        Met.wind_v_component = interval_avg(Met.mtime,ncread(proffile,'wind_v_component'),t2); % change to rotated winds for consistency
    catch
        Met.wind_v_component = interval_avg(Met.mtime,ncread(proffile,'northward_wind'),t2); % Rotated winds
    end
    
    try
        Met.wind_w_component = interval_avg(Met.mtime,ncread(proffile,'wind_w_component'),t2);
    catch
        Met.wind_w_component = interval_avg(Met.mtime,ncread(proffile,'vertical_wind'),t2);
    end
    
    try
        Met.mean_wind = interval_avg(Met.mtime,ncread(proffile,'mean_wind'),t2); 
    catch
        Met.mean_wind = interval_avg(Met.mtime,ncread(proffile,'wind_speed'),t2);
    end
    try
        Met.wind_direction = interval_avg(Met.mtime,ncread(proffile,'wind_direction_from_north'),t2);
    catch
        Met.wind_direction = interval_avg(Met.mtime,ncread(proffile,'wind_direction'),t2);
    end
    
    Met.friction_velocity = interval_avg(Met.mtime,ncread(proffile,'friction_velocity'),t2);
    Met.turbulent_kinetic_energy = interval_avg(Met.mtime,ncread(proffile,'turbulent_kinetic_energy'),t2);
    try
        Met.Monin_Obukhov_length = interval_avg(Met.mtime,ncread(proffile,'Monin_Obukhov_length'),t2);
    catch
        Met.Monin_Obukhov_length = interval_avg(Met.mtime,ncread(proffile,'monin_obukov_length'),t2);
    end
    
    try
        Met.Monin_Obukhov_stability_parameter = interval_avg(Met.mtime,ncread(proffile,'Monin_Obukhov_stability_parameter'),t2);
    catch
        Met.Monin_Obukhov_stability_parameter = interval_avg(Met.mtime,ncread(proffile,'monin_obukov_stability_parameter'),t2);
    end
    
    try
        Met.Bowen_ratio = interval_avg(Met.mtime,ncread(proffile,'Bowen_ratio'),t2);
    catch
        Met.Bowen_ratio = interval_avg(Met.mtime,ncread(proffile,'bowen_ratio'),t2);
    end
    
    try
        Met.variance_u = interval_avg(Met.mtime,ncread(proffile,'variance_u'),t2);
    catch
        Met.variance_u = interval_avg(Met.mtime,ncread(proffile,'eastward_wind_variance'),t2);
    end
    
    try
        Met.variance_v = interval_avg(Met.mtime,ncread(proffile,'variance_v'),t2); 
    catch
        Met.variance_v = interval_avg(Met.mtime,ncread(proffile,'northward_wind_variance'),t2); 
    end
    
    try
        Met.variance_w = interval_avg(Met.mtime,ncread(proffile,'variance_w'),t2);
    catch
        Met.variance_w = interval_avg(Met.mtime,ncread(proffile,'vertical_wind_variance'),t2);
    end
    
    % Filter the data based on QC values (0 is good, greater than 0 is bad)
    try
        Met.momentum_flux(interval_avg(Met.mtime,double(ncread(proffile,'qc_momentum_flux')),t2) > 0) = NaN;
        Met.sensible_heat_flux(interval_avg(Met.mtime,double(ncread(proffile,'qc_sensible_heat_flux')),t2) > 0) = NaN;
        Met.latent_heat_flux(interval_avg(Met.mtime,double(ncread(proffile,'qc_latent_flux')),t2) > 0) = NaN;
        Met.co2_flux(interval_avg(Met.mtime,double(ncread(proffile,'qc_co2_flux')),t2) > 0) = NaN;
        Met.h2o_flux(interval_avg(Met.mtime,double(ncread(proffile,'qc_h2o_flux')),t2) > 0) = NaN;
        Met.air_temperature(interval_avg(Met.mtime,double(ncread(proffile,'qc_air_temperature')),t2) > 0) = NaN;
        Met.air_pressure(interval_avg(Met.mtime,double(ncread(proffile,'qc_air_pressure')),t2) > 0) = NaN;
        Met.air_density(interval_avg(Met.mtime,double(ncread(proffile,'qc_air_density')),t2) > 0) = NaN;
        Met.wind_u_component(interval_avg(Met.mtime,double(ncread(proffile,'qc_wind_u_component')),t2) > 0) = NaN;
        Met.wind_v_component(interval_avg(Met.mtime,double(ncread(proffile,'qc_wind_v_component')),t2) > 0) = NaN;
        Met.wind_w_component(interval_avg(Met.mtime,double(ncread(proffile,'qc_wind_w_component')),t2) > 0) = NaN;
        Met.mean_wind(interval_avg(Met.mtime,double(ncread(proffile,'qc_mean_wind')),t2) > 0) = NaN;
        Met.wind_direction(interval_avg(Met.mtime,double(ncread(proffile,'qc_wind_direction_from_north')),t2) > 0) = NaN;
        Met.variance_u(interval_avg(Met.mtime,double(ncread(proffile,'qc_variance_u')),t2) > 0) = NaN;
        Met.variance_v(interval_avg(Met.mtime,double(ncread(proffile,'qc_variance_v')),t2) > 0) = NaN;
        Met.variance_w(interval_avg(Met.mtime,double(ncread(proffile,'qc_variance_w')),t2) > 0) = NaN;
    catch
        Met.momentum_flux(Met.momentum_flux == -9999) = NaN;
        Met.sensible_heat_flux(Met.sensible_heat_flux == -9999) = NaN;
        Met.latent_flux(Met.latent_heat_flux == -9999) = NaN;
        Met.co2_flux(Met.co2_flux == -9999) = NaN;
        Met.h2o_flux(Met.h2o_flux == -9999) = NaN;
        Met.air_temperature(Met.air_temperature == -9999) = NaN;
        Met.air_pressure(Met.air_pressure == -9999) = NaN;
        Met.air_density(Met.air_density == -9999) = NaN;
        Met.wind_u_component(Met.wind_u_component == -9999) = NaN;
        Met.wind_v_component(Met.wind_v_component == -9999) = NaN;
        Met.wind_w_component(Met.wind_w_component == -9999) = NaN;
        Met.mean_wind(Met.mean_wind == -9999) = NaN;
        Met.wind_direction(Met.wind_direction == -9999) = NaN;
        Met.variance_u(Met.variance_u == -9999) = NaN;
        Met.variance_v(Met.variance_v == -9999) = NaN;
        Met.variance_w(Met.variance_w == -9999) = NaN;
    end
    
end

% General parameters
Met.lat = ncread(proffile,'lat'); 
Met.lon = ncread(proffile,'lon'); 
Met.alt = ncread(proffile,'alt');

Met.facility = ncreadatt(proffile,'/','facility_id');
Met.site_id = ncreadatt(proffile,'/','site_id');
    
    
