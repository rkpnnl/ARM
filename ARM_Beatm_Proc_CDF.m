% Read the Met Files (Eg., sgparmbeatmC1.c1) from ARM Sites
% Datasets are averaged for every 1 minute

function [Met] = ARM_Beatm_Proc_CDF(proffile,tol)

% Read the Processed Met Wind CDF files for the ARM Site Doppler Lidars
% Input:
% 1. NetCDF filename (proffile)
% 2. Averaging time period in minutes (tol)

% Example: [Met] = ARM_Beatm_Proc_CDF('sgparmbeatmC1.c1.20020101.000000.cdf',15)

% Written by R Krishnamurthy
% Pacific Northwest National Laboratory


Met.base_time = ncread(proffile,'base_time'); % Base Time seconds since 1970-1-1 0:00:00 0:00
Met.time_offset = ncread(proffile,'time_offset'); % 'seconds since 2019-07-10 00:00:00 0:00
Met.time = ncread(proffile,'time'); % seconds since 2019-07-10 00:00:00 0:00
Met.mtime = double(719529 + Met.base_time/24/60/60) + Met.time/24/60/60; % Matlab time

% Average or Interpolate the profiles to "tol" provided in the
% input in minutes
deltaT = (Met.mtime(2)-Met.mtime(1))*24*60;
try
    if(deltaT >= tol)

        % Interpolate to every 15 minutes
        t2 = Met.mtime(1):tol/24/60:Met.mtime(end); % 15 min average measurements
        Met.mtime_avg = t2;

        Met.atmos_pressure = interp1(Met.mtime,ncread(proffile,'p_sfc'),t2);
        Met.temp_mean = interp1(Met.mtime,ncread(proffile,'T_sfc'),t2); % qc_temp_mean
        Met.rh_mean = interp1(Met.mtime,ncread(proffile,'rh_sfc'),t2);

        Met.u_sfc = interp1(Met.mtime,ncread(proffile,'u_sfc'),t2);
        Met.v_sfc = interp1(Met.mtime,ncread(proffile,'v_sfc'),t2);

        Met.SH_baebbr = interp1(Met.mtime,ncread(proffile,'SH_baebbr'),t2);
        Met.LH_baebbr = interp1(Met.mtime,ncread(proffile,'LH_baebbr'),t2);

        Met.precip = interp1(Met.mtime,ncread(proffile,'prec_sfc'),t2);  % Corrected precipitation total
        Dp = ncread(proffile,'Td_z'); Dp = Dp(1,:); % Just the first height closest to the ground from sounding
        Met.Dp = interp1(Met.mtime,Dp,t2);
        clear Dp
        
    else

        % Average to every 15 minutes
        t2 = Met.mtime(1):tol/24/60:Met.mtime(end); % 15 min average measurements
        Met.mtime_avg = t2(1:end-1);

        Met.atmos_pressure = interval_avg(Met.mtime,ncread(proffile,'p_sfc'),t2);
        Met.temp_mean = interval_avg(Met.mtime,ncread(proffile,'T_sfc'),t2); % qc_temp_mean
        Met.rh_mean = interval_avg(Met.mtime,ncread(proffile,'rh_sfc'),t2);
        Met.u_sfc = interval_avg(Met.mtime,ncread(proffile,'u_sfc'),t2); 
        Met.v_sfc = interval_avg(Met.mtime,ncread(proffile,'v_sfc'),t2); 

        Met.SH_baebbr = interval_avg(Met.mtime,ncread(proffile,'SH_baebbr'),t2);
        Met.LH_baebbr = interval_avg(Met.mtime,ncread(proffile,'LH_baebbr'),t2); % qc_temp_mean
        Met.prec_sfc = interval_avg(Met.mtime,ncread(proffile,'prec_sfc'),t2);  % Corrected precipitation total
        Dp = ncread(proffile,'Td_z'); Dp = Dp(1,:); % Just the first height closest to the ground from sounding
        Met.Dp = interval_avg(Met.mtime,Dp,t2);
        clear Dp
    end
catch % for *.nc files
    
    if(deltaT >= tol)

        % Interpolate to every 15 minutes
        t2 = Met.mtime(1):tol/24/60:Met.mtime(end); % 15 min average measurements
        Met.mtime_avg = t2;

        Met.atmos_pressure = interp1(Met.mtime,ncread(proffile,'pressure_sfc'),t2);
        Met.temp_mean = interp1(Met.mtime,ncread(proffile,'temperature_sfc'),t2); % qc_temp_mean
        Met.rh_mean = interp1(Met.mtime,ncread(proffile,'relative_humidity_sfc'),t2);
        Met.u_sfc = interp1(Met.mtime,ncread(proffile,'u_wind_sfc'),t2);
        Met.v_sfc = interp1(Met.mtime,ncread(proffile,'v_wind_sfc'),t2);
        Met.SH_baebbr = interp1(Met.mtime,ncread(proffile,'sensible_heat_flux_baebbr'),t2);
        Met.LH_baebbr = interp1(Met.mtime,ncread(proffile,'latent_heat_flux_baebbr'),t2);

        Met.precip = interp1(Met.mtime,ncread(proffile,'precip_rate_sfc'),t2);  % Corrected precipitation total
        Dp = ncread(proffile,'dewpoint_h'); Dp = Dp(1,:); % Just the first height closest to the ground from sounding
        Met.Dp = interp1(Met.mtime,Dp,t2);
        clear Dp
        
    else

        % Average to every 15 minutes
        t2 = Met.mtime(1):tol/24/60:Met.mtime(end); % 15 min average measurements
        Met.mtime_avg = t2(1:end-1);

        Met.atmos_pressure = interval_avg(Met.mtime,ncread(proffile,'pressure_sfc'),t2);
        Met.temp_mean = interval_avg(Met.mtime,ncread(proffile,'temperature_sfc'),t2); % qc_temp_mean
        Met.rh_mean = interval_avg(Met.mtime,ncread(proffile,'relative_humidity_sfc'),t2);
        Met.u_sfc = interval_avg(Met.mtime,ncread(proffile,'u_wind_sfc'),t2); 
        Met.v_sfc = interval_avg(Met.mtime,ncread(proffile,'v_wind_sfc'),t2); 
        Met.SH_baebbr = interval_avg(Met.mtime,ncread(proffile,'sensible_heat_flux_baebbr'),t2);
        Met.LH_baebbr = interval_avg(Met.mtime,ncread(proffile,'latent_heat_flux_baebbr'),t2); % qc_temp_mean
        Met.prec_sfc = interval_avg(Met.mtime,ncread(proffile,'precip_rate_sfc'),t2);  % Corrected precipitation total
        Dp = ncread(proffile,'dewpoint_h'); Dp = Dp(1,:); % Just the first height closest to the ground from sounding
        Met.Dp = interval_avg(Met.mtime,Dp,t2);
        clear Dp
    end
    
    
end
    
% General parameters

Met.lat = ncread(proffile,'lat'); 
Met.lon = ncread(proffile,'lon'); 
Met.alt = ncread(proffile,'alt');

Met.facility = ncreadatt(proffile,'/','facility_id');
Met.site_id = ncreadatt(proffile,'/','site_id');
