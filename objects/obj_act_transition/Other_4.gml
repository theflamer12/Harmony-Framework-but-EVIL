/// @description Commit act transition	
	//Get important objects
	var marker, player;
	
	marker = obj_act_trans_marker;
	player = obj_player;
	
	//Position player
	player.x = marker.x + player_pos[0];
	player.y = marker.y + player_pos[1];
	
	//Player musc
	player.shield = shield_store;
	
	//Position the signpost
	var _sign = instance_create_depth(player.x, player.y, player.depth, obj_fake_sign);
	_sign.x = marker.x + sign_pos[0];
	_sign.y = marker.y + sign_pos[1];
	
	//Position the camera
	obj_camera.camera_x = marker.x + camera_pos[0];
	obj_camera.target_x = obj_camera.target.x;
	obj_camera.camera_y = marker.y + camera_pos[1] - 16;
	obj_camera.target_y = obj_camera.target.y;
	obj_camera.previous_x = obj_camera.target_x;
	obj_camera.previous_y = obj_camera.target_y;
	
	//Camera bounds
	obj_camera.limit_left = marker.x + cam_bound[0];
	obj_camera.target_left = marker.x + cam_bound[0];
	obj_camera.limit_right = marker.x + cam_bound[1];
	obj_camera.target_right = marker.x + cam_bound[1];
	obj_camera.limit_top = marker.y + cam_bound[2];
	obj_camera.target_top = marker.y + cam_bound[2];
	obj_camera.limit_bottom = marker.y + cam_bound[3];
	obj_camera.target_bottom = marker.y + cam_bound[3];
	
	//Storing background oh no (Part 2!)
	var names = variable_struct_get_names(background_store);
	for (var i = 0; i < array_length(names); i++)
	{
		var data = background_store[$ names[i]];
		var bg = asset_get_index(names[i]);
		
		//Check if object exists in the room to apply proper data
		if (bg != -1 && instance_exists(bg))
		{
			with (bg)
			{
				for (var n = 0; n < bg_id; ++n)
				{
					offset_x[n] = data.list_x[n];
					offset_y[n] = data.list_y[n];
					trigger[n]  = true;
				}
			}
		}
	}
	
	for(var i = 0; i <= 3; i++)
	{
		offset[i] = 0;	
	}
	
	for (var i = 0; i < monitor_len; ++i) 
	{
		var new_monitor;
		new_monitor = instance_create_depth(x, y, depth, obj_monitor);
		new_monitor.x = marker.x + monitor_x[i];
		new_monitor.y = marker.y + monitor_y[i];
		new_monitor.monitor_type = monitor_type[i];
		new_monitor.destroyed = monitor_destroy[i];
		new_monitor.depth = monitor_depth[i];
	}