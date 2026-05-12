function player_collide_object(this_hitbox = -1, side = C_MAIN, player_id = 0){
	//Collision side macros:
	#macro C_MAIN 0
	#macro C_BOTTOM 1
	#macro C_TOP 2
	#macro C_LEFT 3
	#macro C_RIGHT 4
	#macro C_BOTTOM_EXT 5
	#macro C_TOP_EXT 6
	
	//Get nearest player object:
	var p = player_find(player_id);
	var pBox = player_get_hitbox(player_id);
	
	//Define hitbox size:
	switch(side)
	{
		//Bottom side of the hitbox:
		case C_BOTTOM: 
		pBox.top = 0;
		break;
		
		//Top side of the hitbox:
		case C_TOP: 
		pBox.bottom = 0;
		break;
		
		//Left side of the hitbox:
		case C_LEFT: 
		pBox.right = 0;
		break;
		
		//Right side of the hitbox:
		case C_RIGHT:
		pBox.left = 0;
		break;
	}
	
	var col = instance_collide(p, pBox, id, this_hitbox);
	
	if(p.hitbox_allow)
		return col;
	
}