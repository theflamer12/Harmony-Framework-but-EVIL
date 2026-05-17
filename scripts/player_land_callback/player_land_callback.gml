// This is executed every time the player lands
function player_land_callback()
{
	// Reset the badnik chain
	obj_level.badnik_chain = 0;
	
	// Stop rolling when landing
	if(state == player_state_roll)
	{
		state = player_state_normal;	
	}
}