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
	
	if(solid_object)
	{
		//Trigger the collision
		for(var i = 0; i < global.hitbox_index; i++)
		{
			var hitbox_array = global.hitbox_tocheck[i][0],
				hitbox_type = global.hitbox_tocheck[i][1],
				hitbox_id = global.hitbox_tocheck[i][2];
				
			if point_in_rectangle(new_x+radius_x*y_dir+radius_y*x_dir, new_y+radius_y*y_dir+radius_x*-x_dir, hitbox_array[0], hitbox_array[1], hitbox_array[2], hitbox_array[3]) && hitbox_id.collision_flag
			{
				if(hitbox_type == "solid" || hitbox_type == "semi-solid" && semi_solid)
				{
					return true;
				}
			}
		}
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
	
	if(solid_object)
	{
		//Trigger the collision
		for(var i = 0; i < global.hitbox_index; i++)
		{
			var hitbox_array = global.hitbox_tocheck[i][0],
				hitbox_type = global.hitbox_tocheck[i][1],
				hitbox_id = global.hitbox_tocheck[i][2];
				
			if rectangle_in_rectangle(floor(x)+X1, floor(y)+Y1, floor(x)+X2, floor(y)+Y2, hitbox_array[0], hitbox_array[1], hitbox_array[2], hitbox_array[3]) && hitbox_id.collision_flag
			{
				if(hitbox_type == "solid" || hitbox_type == "semi-solid" && semi_solid)
				{
					return true;
				}
			}
		}
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
	
	if(solid_object)
	{
		//Trigger the collision
		for(var i = 0; i < global.hitbox_index; i++)
		{
			var hitbox_array = global.hitbox_tocheck[i][0],
				hitbox_type = global.hitbox_tocheck[i][1],
				hitbox_id = global.hitbox_tocheck[i][2];
				
			if(rectangle_in_rectangle(bbox_left + offset_x, bbox_top + offset_y, bbox_right + offset_x, bbox_bottom + offset_y, hitbox_array[0], hitbox_array[1], hitbox_array[2], hitbox_array[3]) && hitbox_id.collision_flag)
			{
				if(hitbox_type == "solid" || hitbox_type == "semi-solid" && semi_solid)
				{
					return true;
				}
			}
		}
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

function instance_act_solid(hitbox_array = [bbox_left, bbox_top, bbox_right, bbox_bottom], player_target = instance_find(obj_player, 1))
{
	if(!variable_global_exists("hitbox_index")) global.hitbox_index = 0;
	
	for(var i = 0; i < global.hitbox_index; i++)
	{
		if(global.hitbox_tocheck[i][2] == id)
		{
			global.hitbox_tocheck[i][0] = hitbox_array;
			global.hitbox_tocheck[i][1] = "solid";
		}
		else
		{
			if(i == global.hitbox_index - 1)
			{
				global.hitbox_tocheck[global.hitbox_index][0] = hitbox_array;
				global.hitbox_tocheck[global.hitbox_index][1] = "solid";
				global.hitbox_tocheck[global.hitbox_index][2] = id;
				global.hitbox_index++;
	
				collision_flag = true;
			}
		}
	}
}

function instance_act_semi_solid(hitbox_array = [bbox_left, bbox_top, bbox_right, bbox_bottom], player_target = instance_find(obj_player, 1))
{
	if(!variable_global_exists("hitbox_index")) global.hitbox_index = 0;
	
	for(var i = 0; i < global.hitbox_index; i++)
	{
		if(global.hitbox_tocheck[i][2] == id)
		{
			global.hitbox_tocheck[i][0] = hitbox_array;
			global.hitbox_tocheck[i][1] = "semi-solid";
		}
		else
		{
			if(i == global.hitbox_index - 1)
			{
				global.hitbox_tocheck[global.hitbox_index][0] = hitbox_array;
				global.hitbox_tocheck[global.hitbox_index][1] = "semi-solid";
				global.hitbox_tocheck[global.hitbox_index][2] = id;
				global.hitbox_index++;
	
				collision_flag = true;
			}
		}
	}
}