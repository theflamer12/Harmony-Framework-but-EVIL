function player_angle_detection(){
	//Temp values
	var posx, posy;
	
	//Reset angle to the default
	static new_angle = 0;
	
	//Reset ramp flag to default
	on_edge = false;
	ground_push_flag = true;
	
	if(on_object || water_run && !on_terrain)
	{
		ground_angle = 0;
		exit;	
	}
	
	//Get ground angle
	if(ground)
	{
		//Get new ground angle
		if(!on_object)
		{
			//Get new angle from left ground sensor
			if(line_check(-hitbox_w, hitbox_h+1, true) && !line_check(hitbox_w, hitbox_h, true))
			{
					
				switch(mode)
				{
					case 0:
						posx = floor(x) - hitbox_w
						posy = floor(y) + hitbox_h
					break;
						
					case 1:
						posx = floor(x) + hitbox_h
						posy = floor(y) + hitbox_w
					break;
						
					case 2:
						posx = floor(x) - hitbox_w
						posy = floor(y) - hitbox_h
					break;
						
					case 3:
						posx = floor(x) - hitbox_h
						posy = floor(y) - hitbox_w
					break;
				}
					
				//Return new angle
				new_angle = get_angle(posx, posy, mode, reach_range);
			}
			
			//Get new angle from right ground sensor
			if(!line_check(-hitbox_w, hitbox_h, true) && line_check(hitbox_w, hitbox_h+1, true))
			{
				switch(mode)
				{
					case 0:
						posx = floor(x) + hitbox_w
						posy = floor(y) + hitbox_h
					break;
						
					case 1:
						posx = floor(x) + hitbox_h
						posy = floor(y) - hitbox_w
					break;
						
					case 2:
						posx = floor(x) + hitbox_w
						posy = floor(y) - hitbox_h
					break;
						
					case 3:
						posx = floor(x) - hitbox_h
						posy = floor(y) + hitbox_w
					break;
				}
				
				//Return new angle
				new_angle = get_angle(posx, posy, mode, reach_range);
			}
				
			//Get new angle from the middle ground sensor
			if(!line_check(-hitbox_w, hitbox_h+1, true) && !line_check(hitbox_w, hitbox_h+1, true) && line_check(0, hitbox_h+1, true))
			{
				posx = floor(x);
				posy = floor(y)-hitbox_w*(x_dir);
				
				//Return new angle
				new_angle = get_angle(posx, posy, mode);
			}
			
			//If player is on flat terrain force angle to the matching mode
			if(line_check(-hitbox_w, hitbox_h+1, true) && line_check(0, hitbox_h+1, true) && line_check(hitbox_w, hitbox_h+1, true))
			{
				new_angle = 90 * mode;
			}
		}
	}
	
	
	//Set ground angle to new angle
	ground_angle = new_angle;
	
}