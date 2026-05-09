/// @description Hurt player

	//Get the center of the hitbox
	var center_x = bbox_left + (bbox_right - bbox_left) / 2;
	var col = player_act_solid();
	
	//Hurt the player
	if(col == (sign(image_xscale) == 1 ? C_LEFT : C_RIGHT))
	{
		var player = player_find(0)
		if(player.invincible_timer == 0)
			play_sound(sfx_spike);
			
		player_hurt(center_x);
	}