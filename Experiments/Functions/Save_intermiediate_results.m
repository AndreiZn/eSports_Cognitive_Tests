function Save_intermiediate_results(CFG, DATA)

intermediate_results_root = [CFG.general.data_folder_name, 'Intermediate_results\'];
if ~exist(intermediate_results_root, 'dir')
    mkdir(intermediate_results_root)
end
save([intermediate_results_root, 'CFG.mat'], 'CFG') 
save([intermediate_results_root, 'DATA.mat'], 'DATA') 