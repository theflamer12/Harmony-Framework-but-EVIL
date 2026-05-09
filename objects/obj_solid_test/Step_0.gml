	//x = floor(xstart + 32 * dsin(FRAME_TIMER));
	
	var p = instance_find(obj_player, 0);
	
	var myEpicBox = new instance_hitbox(-16, -16, 16, 16);
	var a = player_act_solid()
	
	if(a)
	{
		show_debug_message(a)	
	}
	
	depth = p.depth + 10;
	
	if(!on_screen())
		instance_deactivate_object(id)