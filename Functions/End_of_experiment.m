function [CFG] = End_of_experiment(CFG)

CFG.general.num_experiment = CFG.general.num_experiment + 1;
for sec = 5:-1:1
    Screen('FillRect', CFG.general.win, CFG.general.bgcolor);
    display_text = {['End of Experiment ', num2str(CFG.general.num_experiment)], ['Next experiment will star in ' num2str(sec) ' seconds.']};
    Display_text(CFG.general, display_text)
    WaitSecs(1);
end

