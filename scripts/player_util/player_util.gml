function player_reposition_mode(force_mode = -1)
{
	mode = round(ground_angle/90) % 4;
	
	var true_mode = mode;
	
	if(force_mode != -1)
	{
		true_mode = force_mode;	
	}
	
	//Change direction
	x_dir = dsin(90 * true_mode);
	y_dir = dcos(90 * true_mode);
}

function player_hurt(hazard_x = x)
{
	with(obj_player)
	{
		hurt_position = hazard_x;
		knockout_type = K_HURT;
	}
}

function player_react_solid(result)
{
	// Get values from the struct
	var o = result.object;
	var this = result.this_object;
	var side = result.col_side;
	var colX = result.col_x;
	var colY = result.col_y
	
	// Vertical collision sides
	if(side == C_TOP || side == C_BOTTOM)
	{
		// Position the object
		o.y = colY;	
		
		// Flag player as on object
		if(side == C_TOP)
		{
			o.on_object = true;
			
			// Ledge direction
			if(o.ground && o.x < this.x + result.this_box.left)
				o.ledge = -1;
				
			if(o.ground && o.x > this.x + result.this_box.right)
				o.ledge = 1;
		}
		
		// Going down
		if(o.y_speed > 0)
		{
			
			// If player is going down the falls and hits an object, stop the player
			if(o.ground && (o.mode == 1 || o.mode == 3))
			{
				o.ground_speed = 0;	
			}
			
			// Land the player
			if(!o.ground && side = C_TOP)
			{
				// Stop falling
				o.y_speed = 0;
				
				// Transfer speed
				if(!o.ground)
					o.ground_speed = o.x_speed;
				
				o.ground = true;	
				o.landed = true;
			}
		}

		// Going up
		if(o.y_speed < 0)
		{
			if(!o.ground && side == C_BOTTOM)
				o.y_speed = 0;
			
			// If player is going up the walls, then stop
			if(o.ground && (o.mode == 1 || o.mode == 3))
			{
				o.ground_speed = 0;	
			}
		}

	}
		
	// Horizontal collision sides
	if(side == C_LEFT || side == C_RIGHT)
	{
		// Position the object
		o.x = colX;	
			
		// Stop the object from moving
		var spdVal = o.ground ? "ground_speed" : "x_speed";
		var spd = variable_instance_get(o, spdVal);
			
		if(side == C_LEFT && spd > 0 || side == C_RIGHT && spd < 0)
		{
			variable_instance_set(o, spdVal, 0);	
		}
					
		if(o.ground)
		{	
			// Get the correct pushing animation
			o.pushing = side;
			
			// Detach from ceiling
			if(o.mode == 2)
				o.ground_speed = 0;
		}
	}
}