% Read ARM Tower Surface Soil Tempearture and Moisture (Eg.,sgpswatsE13.b1.20170626.000700.nc)

% Note: Should be interpolated to every 15 minute time intervals for Lidar comparison

function [Met] = ARM_swats_Proc_CDF(proffile,tol)

% Read the Processed Met Surface Flux NC files for the ARM Site Flux

% Input:
% 1. NetCDF filename (proffile)
% 2. Averaging time period in minutes (tol)

% Example: [Met] = ARM_swats_Proc_CDF('sgpswatsE13.b1.20030105.000000.cdf',15)

% Written by R Krishnamurthy
% Pacific Northwest National Laboratory


Met.base_time = ncread(proffile,'base_time'); % Base Time seconds since 1970-1-1 0:00:00 0:00
Met.time_offset = ncread(proffile,'time_offset'); % 'seconds since 2019-07-10 00:00:00 0:00
Met.time = ncread(proffile,'time'); % seconds since 2019-07-10 00:00:00 0:00
Met.mtime = double(719529 + Met.base_time/24/60/60) + Met.time/24/60/60; % Matlab time

Met.depth = ncread(proffile,'depth'); % seconds since 2019-07-10 00:00:00 0:00

% Average or Interpolate the profiles to "tol" provided in the
% input in minutes
% Interpolate to every 15 minutes
t2 = Met.mtime(1):tol/24/60:Met.mtime(end); % 15 min average measurements
Met.mtime_avg = t2;

% try
    soil_moisturee = ncread(proffile,'watcont_e'); %soil_moisturee = soil_moisturee(1,:);
    soil_moisturew = ncread(proffile,'watcont_w'); %soil_moisturew = soil_moisturew(1,:);
    tsoile = ncread(proffile,'tsoil_e'); %tsoile = tsoile(1,:);
    tsoilw = ncread(proffile,'tsoil_w'); %tsoilw = tsoilw(1,:);
    
% %     Filter the data
    qc_tsoil_e = double(ncread(proffile,'qc_tsoil_e'));qc_tsoil_w = double(ncread(proffile,'qc_tsoil_w'));
    qc_watcont_e = double(ncread(proffile,'qc_watcont_e'));qc_watcont_w = double(ncread(proffile,'qc_watcont_w'));
    %qc_tsoil_e = qc_tsoil_e(1,:);qc_tsoil_w = qc_tsoil_w(1,:);
    %qc_watcont_e = qc_watcont_e(1,:);qc_watcont_w = qc_watcont_w(1,:);
    tsoile(qc_tsoil_e > 0) = NaN;tsoilw(qc_tsoil_w > 0) = NaN;
    soil_moisturee(qc_watcont_e > 0) = NaN;soil_moisturew(qc_watcont_w > 0) = NaN;
    
    Met.soil_moisturee = interp1(Met.mtime,soil_moisturee',t2); 
    Met.soil_moisturew = interp1(Met.mtime,soil_moisturew',t2); 
    Met.tsoile = interp1(Met.mtime,tsoile',t2); 
    Met.tsoilw = interp1(Met.mtime,tsoilw',t2);
    
    
    

% catch
%     
%     Met.mtime_avg = [];
%     Met.soil_moisturee = []; 
%     Met.soil_moisturew = []; 
%     Met.tsoile = []; 
%     Met.tsoilw = []; 
% end