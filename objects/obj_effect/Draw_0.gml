	/// @description Draw the effect
	if(!animator.animation_sprite)
		exit;
	
	gpu_set_blendmode(blend);
	draw_animator(animator ,,,,,, image_blend, image_alpha);
	gpu_set_blendmode(bm_normal)
	shader_reset()