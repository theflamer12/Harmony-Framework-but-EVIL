#macro BOX_LEFT 0
#macro BOX_TOP 1
#macro BOX_RIGHT 2
#macro BOX_BOTTOM 3

function instance_act_solid(o, hitbox_other, this, this_hibox)
{
	var sideH = 0;
	var sideV = 0;
	
	var colX = o.x;
	var colY = o.y;
	
	var cenX = this.x + (this_hibox[BOX_RIGHT] + this_hibox[BOX_LEFT]) * 0.5;
	
	if(o.x <= cenX)
	{
		if(o.x + hitbox_other[BOX_RIGHT] + 1 >= this.x + this_hibox[BOX_LEFT] &&
		this.y + this_hibox[BOX_TOP] < o.y + hitbox_other[BOX_BOTTOM] && 
		this.y + this_hibox[BOX_BOTTOM] > o.y + hitbox_other[BOX_TOP])	
		{
			sideH = C_LEFT;
			colX = this.x + (this_hibox[BOX_LEFT] - hitbox_other[BOX_RIGHT]) - 1;
		}
	} 
	else if(o.x + hitbox_other[BOX_LEFT] <= this.x + this_hibox[BOX_RIGHT] &&
	this.y + this_hibox[BOX_TOP] < o.y + hitbox_other[BOX_BOTTOM] && 
	this.y + this_hibox[BOX_BOTTOM] > o.y + hitbox_other[BOX_TOP])	
	{
		sideH = C_RIGHT;
		colX = this.x + (this_hibox[BOX_RIGHT] - hitbox_other[BOX_LEFT]);
	}
	
	var cenY = this.y + (this_hibox[BOX_TOP] + this_hibox[BOX_BOTTOM]) * 0.5;
	
	if(o.y < cenY)
	{
		if(o.y + hitbox_other[BOX_BOTTOM] + 1 >= this.y + this_hibox[BOX_TOP] &&
		this.x + this_hibox[BOX_LEFT] < o.x + hitbox_other[BOX_RIGHT] &&
		this.x + this_hibox[BOX_RIGHT] > o.x + hitbox_other[BOX_LEFT])
		{
			sideV = C_TOP;	
			colY = this.y + (this_hibox[BOX_TOP] - hitbox_other[BOX_BOTTOM]) - 1;
		}
	} 
	else if(o.y + hitbox_other[BOX_TOP] <= this.y + this_hibox[BOX_BOTTOM] &&
	this.x + this_hibox[BOX_LEFT] < o.x + hitbox_other[BOX_RIGHT] &&
	this.x + this_hibox[BOX_RIGHT] > o.x + hitbox_other[BOX_LEFT])
	{
		sideV = C_BOTTOM;	
		colY = this.y + (this_hibox[BOX_BOTTOM] - hitbox_other[BOX_TOP]);
	}
	
	var side = 0;
	var deltaX = colX - o.x;
	var deltaY = colY - o.y;
	
	 
	if((deltaX * deltaX >= deltaY * deltaY && (sideV || !sideH)) || (!sideH && sideV))
	{
		side = sideV;	
	}
	else
	{
		side = sideH;	
	}
	
	show_debug_message(side)
	
	// Build the result struct
	var r = {
		object : o,
		this_object : this,
		this_box : this_hibox,
		col_side : side,
		col_x : colX,
		col_y : colY
	}
	
	// Check if this is a player object
	var isPlayer = o.object_index == obj_player;
	
	if(side != 0)
	{
		// If the other object is the player, then execute player's reaction to solid object
		if(isPlayer)
			player_react_solid(r);
		else
			instance_react_solid(r);
	}
	
}

// ===========================================================================================================
// Utilities internal functions
// ===========================================================================================================
function instance_react_solid(result)
{
	// Get values from the struct
	var o = result.object;
	var side = result.col_side;
	var colX = result.col_x;
	var colY = result.col_y
	
	// Vertical collision sides
	if(side == C_TOP || side == C_BOTTOM)
	{
		// Position the object
		o.y = colY;	
		
		// Stop object's vertical movement if it exists
		if(variable_instance_exists(o, "y_speed"))
		{
			if(side == C_TOP && o.y_speed > 0 || side == C_BOTTOM && o.y_speed < 0)
				o.y_speed = 0;
		}
	}
	
	// Horizontal collision sides
	if(side == C_LEFT || side == C_RIGHT)
	{
		// Position the object
		o.x = colX;	
			
		// Stop object's horizontal movement if it exists
		if(variable_instance_exists(o, "y_speed"))
		{
			if(side == C_LEFT && o.x_speed > 0 || side == C_RIGHT && o.x_speed < 0)
				o.x_speed = 0;
		}
	}
}

// Required to be split to keep things clean, player object reacts differently to the solid object and requires more code
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
			if(o.ground && o.x < this.x + result.this_box[BOX_LEFT])
				o.ledge = -1;
				
			if(o.ground && o.x > this.x + result.this_box[BOX_RIGHT])
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