/// @description Script
	//Code written by joshyflip
	bouncing = false

	with(child_right)
	{
		y = other.y+64+other.weight;
		
		// Make the platform semi solid
		var c = player_act_semi_solid();
		
		if(c && obj_player.ground)
		{
			other.right_override = true;
			//obj_player.y +=6;
			obj_player.y = y - obj_player.hitbox_h - 1;
		}
		
	}

	with(child_weight)
	{
		if(!ground) yspeed += 0.22;
		y += yspeed;
		if(place_meeting(x, y + yspeed, obj_player) && obj_player.ground && !ground)
		{
			obj_player.knockout_type = K_DIE;
		}
		
		while(instance_place(x,y,other.child_right) && !ground && yspeed > 0)
		{
			yspeed = 0;
			y-=1;
			ground = true;
			other.bouncing = true;
		}
		if(ground)
		{
			y=other.child_right.y;
		}
		if(ground || other.right_override)
		{
			other.weightoff = false;
		}
		if(!ground && !other.right_override)
		{
			other.weightoff = true;
		}
		if(other.right_override)
		{
			other.weightoff = false;
		}
		if(!other.weightoff) other.weight = min(other.weight+6,16);
		if(other.weightoff) other.weight = max(other.weight-6,-16);
		
		
	}

	right_override = false

	with(child_left)
	{
		// Make the platform semi solid
		var c = player_act_semi_solid();
		
		if(c && other.child_weight.ground && obj_player.ground)
		{
			if(other.bouncing = false)
			{
				other.child_weight.ground = false;
				other.child_weight.yspeed = -8;
				if(on_screen()) play_sound(sfx_spring);
			}
			else
			{
				var player = instance_nearest(x, y, obj_player)
				with(player)
				{
					animation_play(animator, ANIM.SPRING);
					state = player_state_spring;
					y_speed = -10;
					ground = false;
				}
				if(on_screen()) play_sound(sfx_spring);
			} 
			obj_player.y = y - obj_player.hitbox_h - 1;
		}
		
		
		y = other.y+64-other.weight
	}



	for (var i = 0; i < 5; ++i) 
	{
	    with(child_bead[i])
		{
			y = other.y +72+(other.weight*0.25)*(i-2);
		}
	}