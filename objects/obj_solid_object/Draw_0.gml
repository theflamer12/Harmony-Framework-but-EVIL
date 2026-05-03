/// @description Insert description here
	var collide = clamp(instance_act_solid(C_SOLID) + 1, 0, 10),
	array = ["NO", "MAIN", "BOTTOM", "TOP", "LEFT", "RIGHT", "BOTTOM_EXT", "TOP_EXT"];
	
	draw_self();
	draw_set_font(global.font_small);
	draw_text(x, y, array[collide]);