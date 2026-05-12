function create_effect(X, Y, sprite, anim_speed, obj_depth = depth - 1, x_speed = 0, y_speed = 0, x_accel = 0, y_accel = 0){
	//Create and get the object
	var o = instance_create_depth(X, Y, obj_depth, obj_effect);
	
	//Set the sprite and animation speed
	o.sprite = sprite;
	o.sprite_speed = anim_speed;
	
	// Play the animation
	with(o)
		animation_play_no_list(animator, sprite, anim_speed, false);
	
	//Physics properties
	o.x_speed = x_speed;
	o.y_speed = y_speed;
	o.x_accel = x_accel;
	o.y_accel = y_accel;
	
	//Return the instance
	return o;
}