/// @description Insert description here
	// Inherit the parent event
	event_inherited();

	//Rotate the camera
	if(global.bonus_stage_type == BONUSTYPE.SLOT_MACHINE)
	{
		camera_set_view_angle(view_camera[0], camera_get_view_angle(view_camera[0]) + (0.25 * camera_facing));
	}