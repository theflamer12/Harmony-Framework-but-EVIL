#macro PLANE_A 0
#macro PLANE_B 1

function collision_point_check(radius_x, radius_y, collision_mode = CMODE_FLOOR, collision_plane = PLANE_A, semi_solid = false, solid_object = false)
{

	//New capped position:
	var new_x = floor(clamp(x, obj_camera.limit_left, obj_camera.limit_right));
	var new_y = floor(clamp(y, obj_camera.limit_top, obj_camera.limit_bottom));
	
	//Change direction
	var x_dir = dsin(90 * collision_mode);
	var y_dir = dcos(90 * collision_mode);
	
	//Solid terrain collision
	if(collision_point(new_x+radius_x*y_dir+radius_y*x_dir, new_y+radius_y*y_dir+radius_x*-x_dir, par_solid, true, true))
	{
		//Get the value from the object with what youre coliding
		var solidCollisions = ds_list_create();
		var SolidCount = collision_point_list(new_x + radius_x * y_dir + radius_y * x_dir, new_y + radius_y * y_dir + radius_x * -x_dir,par_solid,true,true,solidCollisions,false);
		for (var i = 0; i < SolidCount; i++)
		{
			var Solid =  solidCollisions[| i];
			if(Solid.collision_flag)
			{
				if (Solid.collision_type = "Full Solid" && Solid.collision_layer = "Both Layers"||
				Solid.collision_type = "Full Solid" && Solid.collision_layer = "Layer A" && collision_plane = 0 ||
				Solid.collision_type = "Full Solid" && Solid.collision_layer = "Layer B" && collision_plane = 1 ||
				Solid.collision_type = "Semi Solid" && Solid.platform_check && semi_solid)
				{
					ds_list_destroy(solidCollisions);
					return true;
				}
			}
		}
		ds_list_destroy(solidCollisions);
	}
	
	//Solid object interaction "par_solid_object"
	if(collision_point(new_x+radius_x*y_dir+radius_y*x_dir, new_y+radius_y*y_dir+radius_x*-x_dir, par_solid_object, true, true) && solid_object)
	{
		//Get the value from the object with what youre coliding
		var solidCollisions = ds_list_create();
		var SolidCount = collision_point_list(new_x + radius_x * y_dir + radius_y * x_dir, new_y + radius_y * y_dir + radius_x * -x_dir, par_solid_object, true, true, solidCollisions, false);
		for (var i = 0; i < SolidCount; i++)
		{
			var Solid =  solidCollisions[| i];
			if(Solid.collision_flag)
			{
				if (Solid.collision_type = "Full Solid" || Solid.collision_type = "Semi Solid" && semi_solid)
				{
					ds_list_destroy(solidCollisions);
					return true;
				}
			}
		}
		ds_list_destroy(solidCollisions);
	}
	//Get the size of collision layer array:
	var a_col = array_length(global.col_tile);
	
	//Handle tile collision (Native GameMaker implementation):
	for (var i = 0; i < a_col; ++i) 
	{
	    //Check if given layers exist(Prevents console output from spamming non existing layer):
		if(layer_exists(global.col_tile[i]))
		{
			//Colide with the tile layer:
			if(collision_point(new_x+radius_x*y_dir+radius_y*x_dir, new_y+radius_y*y_dir+radius_x*-x_dir, layer_tilemap_get_id(global.col_tile[i]), true, true) )
			{
				
				//Different layers collide depending on different behaviour:
				switch(i)
				{
					//Full solid:
					case 0:
						return true;
					
					//Semi solid:
					case 1:
						if(semi_solid) return true;
					break;
					
					//Full solid layer A:
					case 2:
						if(collision_plane == 0) return true;
					break;
					
					//Full solid layer B:
					case 3:
						if(collision_plane == 1) return true;
					break;
					
					//Full solid layer C[EVIL]:
					case 4:
						if(collision_plane == 2) return true;
					break;
				}
			}
		}
	}
}

function collision_line_check(radius_x, radius_y, collision_mode = CMODE_FLOOR, collision_plane = PLANE_A, semi_solid = false, solid_object = false){

	//Rotate line sensors	
	var X1, X2, Y1, Y2;
	switch(collision_mode)
	{
		case 0: X1 = radius_x Y1 = 0 X2 = radius_x Y2= radius_y break;
		case 1: X1 = 0 Y1 = -radius_x X2 = radius_y Y2= -radius_x break;
		case 2: X1 = radius_x Y1 = -0 X2 = radius_x Y2= -radius_y-1 break;
		case 3: X1 = -0 Y1 = radius_x X2 = -radius_y-1 Y2= radius_x break;
	}	
	
	//Collision with solid terrain "par_solid"
	if(collision_line(floor(x)+X1,floor(y)+Y1,floor(x)+X2,floor(y)+Y2,par_solid,true,true))
	{
		//Get the value from the object with what youre coliding
		var solidCollisions = ds_list_create();
		var SolidCount = collision_line_list(floor(x)+X1,floor(y)+Y1,floor(x)+X2,floor(y)+Y2,par_solid,true,true,solidCollisions,false);
		for (var i = 0; i < SolidCount; i++)
		{
			var Solid =  solidCollisions[| i];
			if(Solid.collision_flag){
				if (Solid.collision_type = "Full Solid" && Solid.collision_layer = "Both Layers"||
				Solid.collision_type = "Full Solid" && Solid.collision_layer = "Layer A" && collision_plane = 0 ||
				Solid.collision_type = "Full Solid" && Solid.collision_layer = "Layer B" && collision_plane = 1 ||
				Solid.collision_type = "Semi Solid" && semi_solid && Solid.platform_check)
				{
					ds_list_destroy(solidCollisions);
					return true;
				}
			}
		}
		ds_list_destroy(solidCollisions);
	}
	
	//Collision with solid terrain "par_solid"
	if(collision_line(floor(x)+X1, floor(y)+Y1, floor(x)+X2, floor(y)+Y2, par_solid_object, true, true) && solid_object)
	{
		//Get the value from the object with what youre coliding
		var solidCollisions = ds_list_create();
		var SolidCount = collision_line_list(floor(x)+X1, floor(y)+Y1, floor(x)+X2, floor(y)+Y2, par_solid_object, true, true, solidCollisions, false);
		for (var i = 0; i < SolidCount; i++)
		{
			var Solid =  solidCollisions[| i];
			if(Solid.collision_flag)
			{
				if (Solid.collision_type = "Full Solid" || Solid.collision_type = "Semi Solid" && semi_solid)
				{
					ds_list_destroy(solidCollisions);
					return true;
				}
			}
		}
		ds_list_destroy(solidCollisions);
	}
	
	//Get the size of collision layer array:
	var a_col = array_length(global.col_tile);
	
	//Handle tile collision (Native GameMaker implementation):
	for (var i = 0; i < a_col; ++i) 
	{
	    //Check if given layers exist(Prevents console output from spamming non existing layer):
		if(layer_exists(global.col_tile[i]))
		{
			//Colide with the tile layer:
			if(collision_line(floor(x)+X1, floor(y)+Y1, floor(x)+X2, floor(y)+Y2, layer_tilemap_get_id(global.col_tile[i]), true, true))
			{
				
				//Different layers collide depending on different behaviour:
				switch(i)
				{
					//Full solid:
					case 0:
						return true;
					
					//Semi solid:
					case 1:
						if(semi_solid) return true;
					break;
					
					//Full solid layer A:
					case 2:
						if(collision_plane == 0) return true;
					break;
					
					//Full solid layer B:
					case 3:
						if(collision_plane == 1) return true;
					break;
					
					//Full solid layer C[EVIL]:
					case 4:
						if(collision_plane == 2) return true;
					break;
				}
			}
		}
	}
}

function collision_instance(offset_x, offset_y, collision_plane = PLANE_A, semi_solid = false, solid_object = false)
{

	//Collision with solid terrain "par_solid"
	if(instance_place(floor(x) + offset_x, floor(y) + offset_y, par_solid))
	{
		//Get the value from the object with what youre coliding
		var solidCollisions = ds_list_create();
		var SolidCount = instance_place_list(floor(x) + offset_x, floor(y) + offset_y, par_solid, solidCollisions, false);
		for (var i = 0; i < SolidCount; i++)
		{
			var Solid =  solidCollisions[| i];
			if(Solid.collision_flag){
				if (Solid.collision_type = "Full Solid" && Solid.collision_layer = "Both Layers"||
				Solid.collision_type = "Full Solid" && Solid.collision_layer = "Layer A" && collision_plane = 0 ||
				Solid.collision_type = "Full Solid" && Solid.collision_layer = "Layer B" && collision_plane = 1 ||
				Solid.collision_type = "Semi Solid" && semi_solid && Solid.platform_check)
				{
					ds_list_destroy(solidCollisions);
					return true;
				}
			}
		}
		ds_list_destroy(solidCollisions);
	}
	
	//Collision with solid terrain "par_solid"
	if(instance_place(floor(x) + offset_x, floor(y) + offset_y, par_solid_object) && solid_object)
	{
		//Get the value from the object with what youre coliding
		var solidCollisions = ds_list_create();
		var SolidCount = instance_place_list(floor(x) + offset_x, floor(y) + offset_y, par_solid_object, solidCollisions, false);
		for (var i = 0; i < SolidCount; i++)
		{
			var Solid =  solidCollisions[| i];
			if(Solid.collision_flag)
			{
				if (Solid.collision_type = "Full Solid" || Solid.collision_type = "Semi Solid" && semi_solid)
				{
					ds_list_destroy(solidCollisions);
					return true;
				}
			}
		}
		ds_list_destroy(solidCollisions);
	}
	
	//Get the size of collision layer array:
	var a_col = array_length(global.col_tile);
	
	//Handle tile collision (Native GameMaker implementation):
	for (var i = 0; i < a_col; ++i) 
	{
	    //Check if given layers exist(Prevents console output from spamming non existing layer):
		if(layer_exists(global.col_tile[i]))
		{
			//Colide with the tile layer:
			if(instance_place(floor(x) + offset_x, floor(y) + offset_y, layer_tilemap_get_id(global.col_tile[i])))
			{
				
				//Different layers collide depending on different behaviour:
				switch(i)
				{
					//Full solid:
					case 0:
						return true;
					
					//Semi solid:
					case 1:
						if(semi_solid) return true;
					break;
					
					//Full solid layer A:
					case 2:
						if(collision_plane == 0) return true;
					break;
					
					//Full solid layer B:
					case 3:
						if(collision_plane == 1) return true;
					break;
					
					//Full solid layer C[EVIL]:
					case 4:
						if(collision_plane == 2) return true;
					break;
				}
			}
		}
	}
}

#macro C_SOLID 0
#macro C_SEMISOLID 1

///@param {Real} Type The type of collision you want
///@param {Object} Player You can also an array so you can check more than one instance
///@desc Returns the side the player touched, it'll be an array if you inputted more than one player
function instance_act_solid(type = C_SOLID, player = instance_find(obj_player, 0), hitbox_array = [bbox_left, bbox_top, bbox_right, bbox_bottom])
{
	var to_return = [];
	
	if(!variable_global_exists("solid_index"))
	{
		global.solid_index = 0;
		global.solid_list = [];
	}
	
	array_insert(global.solid_list, global.solid_index, [hitbox_array[0], hitbox_array[1], hitbox_array[2], hitbox_array[3], type, id]);
	global.solid_index++;
	
	for(var i = 0; i < array_length(player) + !is_array(player); i++)
	{
		var p = (is_array(player) ? player[i] : player);
		
		with(p)
		{
			if(!hitbox_allow) continue;
			
			var object = check_self(wall_w, hitbox_h, wall_w, hitbox_h,, p, hitbox_array, type);
	 
			if(object && yprevious + hitbox_h >= other.bbox_top)
			{
				//This is for rare cases, for example if there's a full moving solid object and you want player to be pushed out
				var wall_collision_bottom = false;
				if(variable_instance_exists(other, "wall_bottom"))
				{
					wall_collision_bottom = other.wall_bottom;
				}
		
				//Check flag for if player is below a solid
				var on_the_bottom = yprevious + hitbox_h >= other.bbox_bottom && ground && wall_collision_bottom;
		
				//Difference between current and previous x position of the player
				var previous_diff_x = xprevious - x;
		
				//Wall collision check cases
				var can_left = x + wall_w + previous_diff_x <= other.bbox_left || on_the_bottom;
				var can_right = x - wall_w + previous_diff_x >= other.bbox_right || on_the_bottom;
		
				//Left Wall
				while(check_self(0, hitbox_h, wall_w, hitbox_h,, p, hitbox_array, type) && can_left)
				{
					x -= 1;
				}
	
				//Right Wall
				while(check_self(wall_w, hitbox_h, 0, hitbox_h,, p, hitbox_array, type) && can_right)
				{
					x += 1;
				}	

				//Ceiling collision
				while(check_self(wall_w, hitbox_h, wall_w, 0,, p, hitbox_array, type) && y_speed <= 0){
					y+=1;
					if(!ground)
					{
						y_speed = 0;
					}
				}
			}
			//Landing
			if(check_self(wall_w, 0, wall_w, hitbox_h, true, p, hitbox_array, type) && !on_object && y_speed >= 0 && mode = 0){
				ground_speed = x_speed;
				ground = true;
				landed = true;
				on_object = true;
			}
	
			//FIX: Extending bottom
			var bottom_ext = 8+max(y-yprevious, 0)

			//Switch on object flags fix
			if(check_self(wall_w, 0, wall_w, hitbox_h+2, true, p, hitbox_array, type) && mode = 0) 
			{
				on_object = true;
			}
	
			while(check_self(wall_w, 0, wall_w, hitbox_h, true, p, hitbox_array, type) && mode != 0 && mode != 2)
			{
					y -= 1;	
			}
	
			if(on_object)
			{
				ground_angle = 0;
			}
		
			//Full ground collision POST
			if(ground && mode = 0){
				while(check_self(wall_w, 0, wall_w, hitbox_h+bottom_ext, true, p, hitbox_array, type) && !check_self(wall_w, 0, wall_w, hitbox_h, true, p, hitbox_array, type)){
					y += 1;	
				}
		
				while(check_self(wall_w, 0, wall_w, hitbox_h, true, p, hitbox_array, type))
				{
					y -= 1;	
				}
		
				if(!check_self(wall_w, 0, wall_w, hitbox_h+bottom_ext, true, p, hitbox_array, type))
				{
					on_object = false;
				}
			}
	
			//Disable on object collision in the air
			if(!ground) 
			{
				on_object = false;
			}
			
			var spd = !ground ? x_speed : ground_speed;
			
			//Left Wall
			if(check_self(0, hitbox_h, wall_w+1, hitbox_h,, p, hitbox_array, type) && (x + wall_w) + xprevious - x <= other.bbox_left && spd > 0){
				if(ground)ground_speed = 0;
				x_speed = 0;
				glide_speed = 0;
			}
			
	
			//Right Wall
			if(check_self(wall_w+1, hitbox_h, 0, hitbox_h,, p, hitbox_array, type) && (x - wall_w) + xprevious - x >= other.bbox_right && spd < 0){
				if(ground)ground_speed = 0;
				x_speed = 0;
				glide_speed = 0;
			}
			
			if(check_self(wall_w, hitbox_h+1, wall_w, 0,, p, hitbox_array, type) && y_speed < 0)
			{
				if(mode = 1 || mode = 3)
					ground_speed = 0;
			}
	
	
			if(check_self(wall_w, 0, wall_w, hitbox_h+1,, p, hitbox_array, type) && y_speed > 0)
			{
				if(mode = 1 || mode = 3)
				{
					x_speed = 0;
					ground_speed = 0;
				}
			}
		}
		
		//To give the side the player touched
		for(var j = 0; j < 7; j++)
		{
			if(player_check_collision(j, p, hitbox_array))
			{
				array_push(to_return, j);
				break;
			}
		
			if(j == 6) array_push(to_return, -1);
		}
		
		if(!is_array(p)) to_return = to_return[0];
	}
	
	return to_return;
}

function player_check_collision(side, play = obj_player, hitbox_array)
{
	//Temp values:
	var player, left, top, right, bottom;
	
	//Get nearest player object:
	for(var i = 0; i < array_length(play) + !is_array(play); i++)
	{
		player = (is_array(play) ? play[i] : play);
		
		//Define hitbox size:
		switch(side)
		{
			//Main hitbox:
			case C_MAIN: 
				left = -player.wall_w;
				top = -player.hitbox_h;
				right = player.wall_w;
				bottom = player.hitbox_h;
			break;
		
			//Bottom side of the hitbox:
			case C_BOTTOM: 
				left = -player.wall_w;
				top = 0;
				right = player.wall_w;
				bottom = player.hitbox_h + 1;
			break;
		
			//Bottom side of the hitbox:
			case C_BOTTOM_EXT: 
				left = -player.wall_w;
				top = 0;
				right = player.wall_w;
				bottom = player.hitbox_h + 16;
			break;
		
			//Top side of the hitbox:
			case C_TOP: 
				left = -player.wall_w;
				top = -player.hitbox_h - 1;
				right = player.wall_w;
				bottom = 0;
			break;
		
			//Top side of the hitbox:
			case C_TOP_EXT: 
				left = -player.wall_w;
				top = -player.hitbox_h - 16;
				right = player.wall_w;
				bottom = 0;
			break;
		
			//Left side of the hitbox:
			case C_LEFT: 
				left = -player.wall_w - 1;
				top = -player.hitbox_h;
				right = 0;
				bottom = player.hitbox_h;
			break;
		
			//Right side of the hitbox:
			case C_RIGHT:
				left = 0;
				top = -player.hitbox_h;
				right = player.wall_w + 1;
				bottom = player.hitbox_h;
			break;
		}

		//player[i] events:
		with(player)
		{
			if(side == C_MAIN) return rectangle_in_rectangle(floor(x) + left - hitbox_left_offset, floor(y) + top - hitbox_top_offset, floor(x) + right + hitbox_right_offset, floor(y) + bottom + hitbox_bottom_offset, hitbox_array[0], hitbox_array[1], hitbox_array[2], hitbox_array[3]) == 2 && hitbox_allow
			
			//Check for player[i]'s collision with the object:
			return rectangle_in_rectangle(floor(x) + left - hitbox_left_offset, floor(y) + top - hitbox_top_offset, floor(x) + right + hitbox_right_offset, floor(y) + bottom + hitbox_bottom_offset, hitbox_array[0], hitbox_array[1], hitbox_array[2], hitbox_array[3]) && hitbox_allow; 
		}
	}
}

function check_self(x1, y1, x2, y2, semi_solid = false, player, hitbox_array, type)
{
	with(player)
	{
		//Disable collision
		if(!collision_allow) exit;
		
		return rectangle_in_rectangle(floor(x)-x1, floor(y)-y1, floor(x)+x2, floor(y)+y2, hitbox_array[0], hitbox_array[1], hitbox_array[2], hitbox_array[3]) && (type == C_SOLID || type == C_SEMISOLID && semi_solid);
	}
}