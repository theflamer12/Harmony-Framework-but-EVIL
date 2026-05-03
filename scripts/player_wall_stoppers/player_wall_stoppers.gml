function player_wall_stoppers(){
	var spd = ground ? ground_speed : x_speed;
	
	//Left wall collision
	if(point_check(-wall_w-1, wall_h, false) && spd < 0 && control_lock == 0)
	{
		if(ground)ground_speed = 0;
		x_speed = 0;
		
		if(mode != 0)
		{
			ground_angle = 0;
			player_reposition_mode();
		}
			
	}
	
	//Right wall collision
	if(point_check(wall_w+1, wall_h, false) && spd > 0 && control_lock == 0)
	{
		if(ground)ground_speed = 0;
		x_speed = 0;
		if(mode != 0)
		{
			ground_angle = 0;
			player_reposition_mode();
		}
	}
	

}