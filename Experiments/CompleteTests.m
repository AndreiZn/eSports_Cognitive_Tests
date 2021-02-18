%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Complete Test.m     Jan 28, 2019
%   Psychophysiological Tests for eSport Project
%	Developers: Behnam Irani, Konstatin Sozykin, Andrei Znobishchev
%   Revised on          Feb 18, 2019, Phan A.H
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [CFG, DATA] = CompleteTests(CFG, DATA)

CFG.general.order_of_tests = 1:CFG.general.available_num_of_tests;
for test_idx = CFG.general.order_of_tests
    
    if CFG.general.flags(test_idx)
        
        % Read test_name
        test_name = CFG.tests{test_idx}.test_name;
        
        % Use config file
        congif_name = [test_name, '_config'];
        [CFG] = feval(congif_name, CFG, test_idx);
        
        % Run test test_name
        [CFG, DATA] = feval(test_name, CFG, DATA, test_idx);
        
        disp(['4: ' num2str(CFG.general.win)]);
        % Save data online and end current test
        Save_intermiediate_results(CFG, DATA);
        [CFG] = End_of_experiment(CFG);
    end
end