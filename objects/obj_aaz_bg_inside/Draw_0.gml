/// @description Inherited drawing

	// You can show and hide elements based on certain factors - here is an example:
	// THIS NEEDS TO BE ABOVE INHERITED EVENT!
	/*
	if(condition == true) {
		visibility[0] = false;
	}
	else {
		visibility[0] = true;
	}
	*/

	// Inherit the parent event
	event_inherited();

	//Water scale
	if(instance_exists(obj_water))
	{
		var a = floor(camera_get_view_y(view_camera[view_current])*factor_y[3] + offset_y[3]); //"3" is the index of the water's parallax
		bg_scale[3] = floor(obj_water.y - a) * (1 / 96); //"96" is the water parallax sprite's height
		bg_scale[3] = clamp(bg_scale[3], -1, 1);
	}
