/// @description Resize the window
	//Fullscreen
	window_set_fullscreen(global.window_size >= global.window_size_limit);
	
	//Screen resizing
	camera_set_view_size(view_camera[view_current], global.window_width, global.window_height);

	//Resize the window:
	window_set_size(global.window_width*global.window_size, global.window_height*global.window_size);

	//Resize the surface:
	surface_resize(application_surface, global.window_width, global.window_height);
	
	//Window size limiter
	global.window_size_limit = round(display_get_width() / global.window_width);
	
	//Center the screen
	window_center();	