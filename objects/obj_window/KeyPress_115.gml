/// @description Change window size
	if(!global.dev_mode) exit;
	
	//Change the value and modulate it
	global.window_size = wrap(global.window_size + 1, 1, global.window_size_limit);
	
	//Call the resize event
	event_user(0);