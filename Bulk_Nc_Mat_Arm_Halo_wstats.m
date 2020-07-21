

function Bulk_Nc_Mat_Arm_Halo_wstats(cdffiles,dir_contents)


for i = 1:length(dir_contents)
    proffile = dir_contents(i).name;
    [ARM_wstats] = ARM_Halo_wstats_CDF([cdffiles proffile]);
    
     % save the data
    mkdir([cdffiles,'Matlab Files']);
    disp(['Saving Lidar...' datestr(ARM_wstats.mtime(1))])
    savefile = ['sgpdlprofwstats_' datestr(ARM_wstats.mtime(1),'yyyymmdd_HHMMSS') '.mat'];
    save([cdffiles,'Matlab Files\' savefile],'ARM_wstats');
    clear ARM_wstats proffile savefile
end