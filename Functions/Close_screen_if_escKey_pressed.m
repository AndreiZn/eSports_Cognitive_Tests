function Close_screen_if_escKey_pressed(escKey)

[~, ~, keyCode] = KbCheck;
if keyCode(escKey)
    ShowCursor;
    Screen('CloseAll');
end