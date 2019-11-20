function [x_mouse, y_mouse] = Apply_mouse_sensitivity(x_mouse, y_mouse, CFG)

x_curr = x_mouse; y_curr = y_mouse;
[x_mouse,y_mouse,~] = GetMouse(CFG.general.win);
x_diff_mouse = x_mouse - x_curr; y_diff_mouse = y_mouse - y_curr;
x_mouse = x_curr + CFG.general.sensitivity_skip_factor*x_diff_mouse;
y_mouse = y_curr + CFG.general.sensitivity_skip_factor*y_diff_mouse;
SetMouse(x_mouse, y_mouse)