function [time_click, whichButton] = Wait_user_input(CFG_general, CFG_test)

whichButton = 0;
if strcmp(CFG_test.expected_user_input, 'mouse')
    [~, ~, ~, whichButton] = GetClicks([],0,[]);
    time_click = GetSecs;
else
    while 1
        [keyIsDown, time_click, keyCode] = KbCheck;
        if keyIsDown
            if keyCode(CFG_general.spaceKey)
                break;
            elseif keyCode(CFG_general.escKey)
                ShowCursor;
                Screen('CloseAll');
                return;
            end
        end
    end
end