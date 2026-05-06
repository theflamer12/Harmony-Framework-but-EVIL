	//x = floor(xstart + 32 * dsin(FRAME_TIMER));
	
	var p = instance_find(obj_player, 0);
	
	var myEpicBox = new instance_hitbox(-16, -16, 16, 16);
	instance_act_semi_solid(p, [-p.wall_w, -p.hitbox_h, p.wall_w, p.hitbox_h]);
	
	depth = p.depth + 10;