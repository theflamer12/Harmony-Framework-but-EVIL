/// @description Insert description here
// You can write your code in this editor

draw_sprite(spr_gumball_machine,2,x,y);
draw_sprite(spr_gumball_machine,1,x,y+min(turns,50));
draw_self();
draw_sprite(spr_machine_lid, lid_frame, x, y + 64);
draw_sprite_ext(spr_machine_handle, 0, x, y + 28, 1, 1, handle_rot, c_white, 1);