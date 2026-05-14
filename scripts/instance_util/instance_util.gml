#macro BOX_LEFT 0
#macro BOX_TOP 1
#macro BOX_RIGHT 2
#macro BOX_BOTTOM 3

function instance_act_solid(o, hitbox_other = noone, this = id, this_hitbox = noone)
{	
	// Temps
	var sideH = 0;
	var sideV = 0;
	var colX = o.x;
	var colY = o.y;
	
	// Make hitboxes
	var thisHitbox = _instance_evaluate_hitbox(this, this_hitbox);
	var otherHitbox = _instance_evaluate_hitbox(o, hitbox_other);
	
	// Orientate hitboxes depending on scale
	thisHitbox = _instance_orient_hitbox(this, thisHitbox);
	otherHitbox = _instance_orient_hitbox(o, otherHitbox);
	
	// Horizontal collision
	if(this.y + thisHitbox.top < o.y + otherHitbox.bottom && this.y + thisHitbox.bottom > o.y + otherHitbox.top)
	{
		var cenX = this.x + (thisHitbox.right + thisHitbox.left) * 0.5;
		if(o.x <= cenX)
		{
			if(o.x + otherHitbox.right + 1 >= this.x + thisHitbox.left)
			{
				sideH = C_LEFT;
				colX = this.x + (thisHitbox.left - otherHitbox.right) - 1;
			}
		} 
		else if(o.x + otherHitbox.left <= this.x + thisHitbox.right)
		{
			sideH = C_RIGHT;
			colX = this.x + (thisHitbox.right - otherHitbox.left);
		}
	}
	
	// Vertical collision
	var cenY = this.y + (thisHitbox.top + thisHitbox.bottom) * 0.5;
	if(this.x + thisHitbox.left < o.x + otherHitbox.right && this.x + thisHitbox.right > o.x + otherHitbox.left)
	{
		if(o.y < cenY)
		{
			if(o.y + otherHitbox.bottom + 1 >= this.y + thisHitbox.top)
			{
				sideV = C_TOP;	
				colY = this.y + (thisHitbox.top - otherHitbox.bottom) - 1;
			}
		} 
		else if(o.y + otherHitbox.top <= this.y + thisHitbox.bottom)
		{
			sideV = C_BOTTOM;	
			colY = this.y + (thisHitbox.bottom - otherHitbox.top);
		}
	}
	
	// Temps
	var side = 0;
	var deltaX = colX - o.x;
	var deltaY = colY - o.y;
	 
	// Get the correct collision side
	if((deltaX * deltaX >= deltaY * deltaY && (sideV || !sideH)) || (!sideH && sideV))
	{
		side = sideV;	
	}
	else
	{
		side = sideH;	
	}
	
	// Build the result struct
	var r = {
		object : o,
		this_object : this,
		this_box : thisHitbox,
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
		{
			if(o.debug || !o.collision_allow)
				return 0;
		
			player_react_solid(r);
		}
		else
			_instance_react_solid(r);
	}
	
	return side;
}

function instance_act_semi_solid(o, hitbox_other = noone, this = id, this_hitbox = noone)
{	
	// Make hitboxes
	var thisHitbox = _instance_evaluate_hitbox(this, this_hitbox);
	var otherHitbox = _instance_evaluate_hitbox(o, hitbox_other);
	
	// Orientate hitboxes depending on scale
	thisHitbox = _instance_orient_hitbox(this, thisHitbox);
	otherHitbox = _instance_orient_hitbox(o, otherHitbox);
	
	var otherEdge = o.y + otherHitbox.bottom;
	var otherEdgePrev = (o.y - o.y_speed) + otherHitbox.bottom;
	
	var platformTop = this.y + thisHitbox.top - 1;
	var platformBottom = this.y + thisHitbox.top + 4;
	
	var isColliding = (this.x + thisHitbox.left < o.x + otherHitbox.right) &&
		(this.x + thisHitbox.right > o.x + otherHitbox.left) &&
		o.y_speed >= 0 && otherEdge >= platformTop - 1 && otherEdgePrev <= platformBottom;
		
	if(isColliding)
	{
		o.y = platformTop - otherHitbox.bottom;
		
		// Check if this is a player object
		var isPlayer = o.object_index == obj_player;
		
		if(isPlayer)
		{
			// Flag player as on object
			o.on_object = true;
			
			// Ledge direction
			if(o.ground && o.x < this.x + thisHitbox.left)
				o.ledge = -1;
				
			if(o.ground && o.x > this.x + thisHitbox.right)
				o.ledge = 1;
		
			// Going down
			if(o.y_speed > 0)
			{
				// Land the player
				if(!o.ground)
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
		}
		
		return true;
	}
	
}

function instance_collide(o, hitbox_other = noone, this = id, this_hitbox = noone)
{
		// Temps
	var sideH = 0;
	var sideV = 0;
	var colX = o.x;
	var colY = o.y;
	
	// Make hitboxes
	var thisHitbox = _instance_evaluate_hitbox(this, this_hitbox);
	var otherHitbox = _instance_evaluate_hitbox(o, hitbox_other);
	
	// Orientate hitboxes depending on scale
	thisHitbox = _instance_orient_hitbox(this, thisHitbox);
	otherHitbox = _instance_orient_hitbox(o, otherHitbox);
	
	// Horizontal collision
	if(this.y + thisHitbox.top < o.y + otherHitbox.bottom && this.y + thisHitbox.bottom > o.y + otherHitbox.top)
	{
		var cenX = this.x + (thisHitbox.right + thisHitbox.left) * 0.5;
		if(o.x <= cenX)
		{
			if(o.x + otherHitbox.right >= this.x + thisHitbox.left)
			{
				sideH = C_LEFT;
				colX = this.x + (thisHitbox.left - otherHitbox.right) - 1;
			}
		} 
		else if(o.x + otherHitbox.left < this.x + thisHitbox.right)
		{
			sideH = C_RIGHT;
			colX = this.x + (thisHitbox.right - otherHitbox.left);
		}
	}
	
	// Vertical collision
	if(this.x + thisHitbox.left < o.x + otherHitbox.right && this.x + thisHitbox.right > o.x + otherHitbox.left)
	{
		var cenY = this.y + (thisHitbox.top + thisHitbox.bottom) * 0.5;
		if(o.y < cenY)
		{
			if(o.y + otherHitbox.bottom >= this.y + thisHitbox.top)
			{
				sideV = C_TOP;	
				colY = this.y + (thisHitbox.top - otherHitbox.bottom) - 1;
			}
		} 
		else if(o.y + otherHitbox.top < this.y + thisHitbox.bottom)
		{
			sideV = C_BOTTOM;	
			colY = this.y + (thisHitbox.bottom - otherHitbox.top);
		}
	}
	
	// Temps
	var side = 0;
	var deltaX = colX - o.x;
	var deltaY = colY - o.y;
	 
	// Get the correct collision side
	if((deltaX * deltaX >= deltaY * deltaY && (sideV || !sideH)) || (!sideH && sideV))
	{
		side = sideV;	
	}
	else
	{
		side = sideH;	
	}
	
	return side;
}

function instance_act_badnik()
{
	//Destroy the enemy
	if(player_collide_object())
	{
		var fly_angle = 90 - point_direction(obj_player.x, obj_player.y,x,y) 
		var fly_cond = (obj_player.state == player_state_tailsfly && abs(fly_angle) < 45)
		if(obj_player.attacking || obj_player.invincible || fly_cond)
		{
			//Create battery ring
			if(global.use_battery_rings)
				instance_create_depth(x, y, depth, obj_battery_ring);
			else	//Create flickies instead
				instance_create_depth(x, y, depth, obj_flicky);
		
			//Player bounce
			obj_player.y_speed = -abs(obj_player.y_speed);
		
			//Create score object and add combo and badnik chain
			obj_level.badnik_chain += 1;
			create_score();
		
			//Create explosion effect
			create_effect(x, y, spr_effect_explosion01, 0.3);
		
			//Play destroying sound
			play_sound(sfx_destroy);
		
			//Destroy badnik
			if (!instance_exists(obj_bonus_level)) {
				global.store_object_state[| id] = true
			}
			instance_destroy();	
		}
		else
		{
			//Player getting hurt
			player_hurt();
		}
	}	
}

// ===========================================================================================================
// Utilities internal functions
// ===========================================================================================================
function _instance_react_solid(result)
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

function _instance_orient_hitbox(this, hitbox) 
{
	var dstBox = new instance_hitbox();
	
	dstBox.left = hitbox.left * this.image_xscale;
	dstBox.right = hitbox.right * this.image_xscale;
	dstBox.top = hitbox.top * this.image_yscale;
	dstBox.bottom = hitbox.bottom * this.image_yscale;

	if (dstBox.left > dstBox.right) 
	{
		var s = dstBox.left
		dstBox.left = dstBox.right;
		dstBox.right = s;
	}
	
	if (dstBox.top > dstBox.bottom) 
	{
		var s = dstBox.top
		dstBox.top = dstBox.bottom;
		dstBox.bottom = s;
	}
	
	return dstBox;
}

function _instance_make_hitbox(inst)
{
	var newBox = new instance_hitbox();
	var s = inst.sprite_index;
	
	if(inst.mask_index)
		s = mask_index;
	
	newBox.left = sprite_get_bbox_left(s) - sprite_get_xoffset(s);
	newBox.right = sprite_get_bbox_right(s) - sprite_get_xoffset(s) + 1;
	newBox.top = sprite_get_bbox_top(s) - sprite_get_yoffset(s);
	newBox.bottom = sprite_get_bbox_bottom(s) - sprite_get_yoffset(s) + 1;
	
	return newBox;
}

function _instance_evaluate_hitbox(this, hitbox)
{
	var newBox;
	
	// Check if hitbox is a valid array
	if(is_array(hitbox))
	{
		newBox = new instance_hitbox(hitbox[0], hitbox[1], hitbox[2], hitbox[3]);
	}
	else if(is_struct(hitbox))
	{
		// If it's not an array, check if it's a struct
		newBox = new instance_hitbox(hitbox.left, hitbox.top, hitbox.right, hitbox.bottom);
	}
	else
	{
		// If it's not a struct either, build a new hitbox
		newBox = new instance_hitbox();
		newBox = _instance_make_hitbox(this);
	}	
	
	return newBox;
}

// ===========================================================================================================
// Utilities constructors
// ===========================================================================================================
function instance_hitbox(box_left = 0, box_top = 0, box_right = 0, box_bottom = 0) constructor
{
	left = box_left;
	top = box_top;
	right = box_right;
	bottom = box_bottom;
}