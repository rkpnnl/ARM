
function Bulk_Nc_Mat_Arm_Halo_prof(cdffiles,dir_contents)

% convert all the netcdf files to Matlab files

for i = 1:length(dir_contents)
    
    proffile = dir_contents(i).name;
    [ARM_prof] = ARM_Halo_Proc_CDF([cdffiles proffile]);
    
     % save the data
    mkdir([cdffiles,'Matlab Files']);
    disp(['Saving Lidar...' datestr(ARM_prof.mtime(1))])
    savefile = ['sgpdlprofwind_' datestr(ARM_prof.mtime(1),'yyyymmdd_HHMMSS') '.mat'];
    save([cdffiles,'Matlab Files\' savefile],'ARM_prof');
    clear ARM_prof proffile savefile
end
