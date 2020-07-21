
function [ARM] = ARM_Halo_wstats_CDF(wstatsfile)

% Read the Processed Vertical Profiles & cloud properties CDF files for the ARM Site Doppler Lidars

ARM.base_time = ncread(wstatsfile,'base_time'); % Base Time seconds since 1970-1-1 0:00:00 0:00
ARM.time_offset = ncread(wstatsfile,'time_offset'); % 'seconds since 2019-07-10 00:00:00 0:00
ARM.time = ncread(wstatsfile,'time'); % seconds since 2019-07-10 00:00:00 0:00

ARM.mtime = double(719529 + ARM.base_time/24/60/60) + ARM.time/24/60/60; % Matlab converted time

ARM.time_bounds = ncread(wstatsfile,'time_bounds'); % Base Time seconds since 1970-1-1 0:00:00 0:00
ARM.height = ncread(wstatsfile,'height'); % Height above ground level
ARM.lat = ncread(wstatsfile,'lat'); % Height above ground level
ARM.lon = ncread(wstatsfile,'lon'); % Height above ground level
ARM.alt = ncread(wstatsfile,'alt'); % Height above ground level
ARM.snr = ncread(wstatsfile,'snr'); % SNR
ARM.snr_25 = ncread(wstatsfile,'snr_25'); % SNR 25th percentile
ARM.snr_75 = ncread(wstatsfile,'snr_75'); % SNR 75th percentile
ARM.w = ncread(wstatsfile,'w'); % w - Vertical velocity
ARM.w_25 = ncread(wstatsfile,'w_25'); % w 25th percentile
ARM.w_75 = ncread(wstatsfile,'w_75'); % w 75th percentile
ARM.noise = ncread(wstatsfile,'noise'); % Variance of random noise in vertical velocity
ARM.w_variance = ncread(wstatsfile,'w_variance'); % Noise corrected vertical velocity variance
ARM.w_skewness = ncread(wstatsfile,'w_skewness'); % Vertical velocity skewness using SNR threshold
ARM.w_kurtosis = ncread(wstatsfile,'w_kurtosis'); % Vertical velocity kurtosis using SNR threshold
ARM.dl_cbh = ncread(wstatsfile,'dl_cbh'); % Median Doppler lidar cloud base height
ARM.dl_cbh_25 = ncread(wstatsfile,'dl_cbh_25'); % Median Doppler lidar cloud base height 25 percentile
ARM.dl_cbh_75 = ncread(wstatsfile,'dl_cbh_75'); % Median Doppler lidar cloud base height 75 percentile
ARM.dl_cbh_zmax = ncread(wstatsfile,'dl_cbh_zmax'); % Maximum detection height for dl_cbh
ARM.dl_cloud_frequency = ncread(wstatsfile,'dl_cloud_frequency'); % Fraction of time that a cloud is detected during averaging period from DL
ARM.cbw = ncread(wstatsfile,'cbw'); % Median Doppler lidar cloud base vertical velocity
ARM.cbw_25 = ncread(wstatsfile,'cbw_25'); % Median Doppler lidar cloud base vertical velocity 25th percentile
ARM.cbw_75 = ncread(wstatsfile,'cbw_75'); % Median Doppler lidar cloud base vertical velocity 75th percentile
ARM.cbw_up_fraction = ncread(wstatsfile,'cbw_up_fraction'); % Doppler lidar cloud base vertical velocity updraft fraction
ARM.nshots = ncread(wstatsfile,'nshots');
ARM.ngate_samples = ncread(wstatsfile,'ngate_samples');
ARM.averaging_time = ncread(wstatsfile,'averaging_time');
ARM.snr_threshold = ncread(wstatsfile,'snr_threshold'); % SNR threshold for skewenss and kurtosis calculation
ARM.sample_frequency = ncread(wstatsfile,'sample_frequency');
ARM.wavelength = ncread(wstatsfile,'wavelength'); % Doppler Lidar wavelength
ARM.ceil_cbh = ncread(wstatsfile,'ceil_cbh'); % Median ceilometer cloud base height
ARM.ceil_cbh_25 = ncread(wstatsfile,'ceil_cbh_25'); % Ceilometer cloud base height 25th percentile
ARM.ceil_cbh_75 = ncread(wstatsfile,'ceil_cbh_75'); % Ceilometer cloud base height 75th percentile
ARM.ceil_cbh_zmax = ncread(wstatsfile,'ceil_cbh_zmax'); % Maximum detection height for ceil_cbh
ARM.ceil_cloud_frequency = ncread(wstatsfile,'ceil_cloud_frequency');% Fraction of time that a cloud is detected during averaging period from ceil
ARM.ceil_lat = ncread(wstatsfile,'ceil_lat');% Ceilometer north latitude
ARM.ceil_lon = ncread(wstatsfile,'ceil_lon');% Ceilometer east Longitude
ARM.ceil_alt = ncread(wstatsfile,'ceil_alt');% Ceilometer Altitude
ARM.ecor_temp = ncread(wstatsfile,'ecor_temp'); % Temperature from eddy correlation system
ARM.ecor_tke = ncread(wstatsfile,'ecor_tke'); % (turbulence kinetic energy from eddy correlation system
ARM.ecor_ustar = ncread(wstatsfile,'ecor_ustar'); % friction velocity from eddy correlation system
ARM.ecor_w_var = ncread(wstatsfile,'ecor_w_var'); % w variance from eddy correlation system
ARM.ecor_w_skew = ncread(wstatsfile,'ecor_w_skew'); % w skewness from eddy correlation system
ARM.ecor_w_kurt = ncread(wstatsfile,'ecor_w_kurt'); % w kurtosis from eddy correlation system
ARM.ecor_wt = ncread(wstatsfile,'ecor_wt'); % wt covariance from eddy correlation system
ARM.ecor_wq = ncread(wstatsfile,'ecor_wq'); % wq covariance from eddy correlation system
ARM.ecor_lat = ncread(wstatsfile,'ecor_lat');
ARM.ecor_lon = ncread(wstatsfile,'ecor_lon');
ARM.ecor_alt = ncread(wstatsfile,'ecor_alt');
ARM.met_spr_mean = ncread(wstatsfile,'met_spr_mean'); % Mean surface precipitation rate from surface meteorological instrumentation
ARM.met_lat = ncread(wstatsfile,'met_lat');
ARM.met_lon = ncread(wstatsfile,'met_lon');
ARM.met_alt = ncread(wstatsfile,'met_alt');
