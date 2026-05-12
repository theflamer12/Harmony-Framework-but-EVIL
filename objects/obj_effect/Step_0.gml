/// @description Script
	
	// Update the animator
	animator_update(animator);
	
	//Destroy if effect is off-screen or if the animation is done
	if(!on_screen(16, 16) || animator.animation_finished)
	{
		instance_destroy();
	}
		
	//Physics
	x += x_speed;
	y += y_speed;
	
	//Acceleration
	x_speed += x_accel;
	y_speed += y_accel;
	
	//Update other stuff
	image_alpha += trans_speed
	image_angle += ang_speed
	image_xscale += xscale_spd
	image_yscale += yscale_spd