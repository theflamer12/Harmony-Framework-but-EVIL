	//x = floor(xstart + 32 * dsin(FRAME_TIMER));
	
	var p = instance_find(obj_player, 0);
	instance_act_solid(p, [-p.wall_w, -p.hitbox_h, p.wall_w, p.hitbox_h], id, [-16, -16, 16, 16]);
	
	