	//x = floor(xstart + 32 * dsin(FRAME_TIMER));
	
	var p = instance_find(obj_player, 0);
	
	var myEpicBox = new instance_hitbox(-16, -16, 16, 16);
	var a = instance_collide(p, [-p.wall_w, -p.hitbox_h, p.wall_w, p.hitbox_h]);
	
	if(a)
	{
		show_debug_message(a)	
	}
	
	depth = p.depth + 10;