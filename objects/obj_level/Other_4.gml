/// @description Stage start
	//Play stage music
	play_music(stage_music, 0);
	
	//Reset stage data
	global.stage_timer = 0;
	
	//Position player to the checkpoint
	if(global.checkpoint_id != noone && instance_exists(global.checkpoint_id))
	{
		obj_player.x = global.checkpoint_id.x;
		obj_player.y = global.checkpoint_id.bbox_bottom - obj_player.hitbox_h;
		obj_camera.target_x = obj_player.x;
		obj_camera.target_y = obj_player.y-16;
		global.stage_timer = global.time_store;
	}
	
	var force_visible_for_new_keys = (global.bonus_stage_state == BONUSSTAGE.GOING_TO || array_length(variable_struct_get_names(global.store_background_visibility)) == 0);

	for (var i = 0; i < instance_number(par_background); ++i)
	{
		var bg = instance_find(par_background, i);
		var name = object_get_name(bg.object_index);
		
		if (variable_struct_exists(global.store_background_visibility, name)) 
		{
			bg.visible = global.store_background_visibility[$ name];
			continue; 
		}
		
		global.store_background_visibility[$ name] = force_visible_for_new_keys ? bg.visible : false;
		
		bg.visible = global.store_background_visibility[$ name];
	}
	
	show_debug_message(global.store_background_visibility);
	
	if !ds_map_exists(global.red_ring_map,stage_name) {
		ds_map_add(global.red_ring_map,stage_name,array_create(red_ring_count))
	}

	if (red_ring_count > 10) || (instance_number(obj_red_ring) > 10) || (instance_number(obj_red_ring) > red_ring_count) {
		throw "Red Ring count exceeds maximum count of " + string(min(red_ring_count,10));	
	}

	if (instance_number(obj_emerald_shard) == 0 && is_emerald_hunt) {
		throw "No Emeralds present for the emerald hunt";	
	}
	if (is_emerald_hunt) {
		if (emerald_hunt_randoms > emerald_hunt_total) {
			throw "Random emeralds exceeds the total count of " + string(emerald_hunt_total);	
		}
		if (emerald_hunt_total > 10) || (instance_number(obj_emerald_shard) > 10) || (instance_number(obj_emerald_shard) > emerald_hunt_total) {
			throw "Emerald shard count exceeds maximum count of " + string(min(emerald_hunt_total,10));	
		}
	}
