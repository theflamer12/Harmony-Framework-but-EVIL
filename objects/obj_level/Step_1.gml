	/// @description Pause the game
	if(Input.StartPress && obj_player.input_disable = false  && !instance_exists(obj_pause))
	{
		global.process_objects = false;
		instance_create_depth(0, 0, -100, obj_pause);
	}
	