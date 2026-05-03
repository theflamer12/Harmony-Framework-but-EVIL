/// @description Background switch using camera position
/// The setup for the object is done with an array in the variables, even if there is a single background.

/// If you want to set up the object to have one background show and one background hide, check how it's done
/// within Arboreal Agate (view_background is [obj_aaz_bg_1] and hide_background is [obj_aaz_bg_2]).

/// Alternatively, if you have multiple, you can set the expressions in the variables to be arrays like this:
/// view_background -> [obj_background_1]
/// hide_background -> [obj_background_2, obj_background_3]
/// Or vice versa! If there is something else you wish to add, you may modify this object as you wish.

/// The main reason why the detection was done via camera and not player collision was to not only future-
/// proof in case if you wish to add a second player character, but also in case of the player going
/// faster than the camera - it does make sense to use the camera to track background switching after all.

	var cx, cy, collide;
	cx = camera_get_view_x(view_camera[view_current])+global.window_width/2;
	cy = camera_get_view_y(view_camera[view_current])+global.window_height/2;
	collide = point_in_rectangle(cx,cy,bbox_left,bbox_top,bbox_right,bbox_bottom);
	
	if(collide)
	{
		for (var i = 0; i < array_length(view_background); ++i) {
		    if (instance_exists(view_background[i]))
			{
				with(view_background[i]) visible = true;
			}
		}
		for (var i = 0; i < array_length(hide_background); ++i) {
		    if (instance_exists(hide_background[i]))
			{
				with(hide_background[i]) visible = false;
			}
		}
	}