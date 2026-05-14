//Made by the_fakeflamer and bluespeedster
function player_handle_demo()
{
	//Variables
	var name;
	static old_state = 0;
	
	//Exit if the level name hasn't been set yet
	if(!variable_instance_exists(obj_level, "stage_name") || global.demo_play == DEMO_NULL) exit;
	
	//Filename
	name = string_replace_all(string_upper(obj_level.stage_name + "_" + string(obj_level.act)), " ", "_");
    
    //This is where demo shit is controlled
    if(global.demo_play == DEMO_PLAY)
    {
        var f = file_bin_open(name, 0);
        file_bin_seek(f, demo_timer);
        
        hold_up = file_bin_read_byte(f);
		hold_down = file_bin_read_byte(f);
		hold_left = file_bin_read_byte(f);
		hold_right = file_bin_read_byte(f);
		hold_a = file_bin_read_byte(f);
		hold_b = file_bin_read_byte(f);
		hold_c = file_bin_read_byte(f);
		hold_action = file_bin_read_byte(f);
	
		//Button holds
		press_up = file_bin_read_byte(f);
		press_down = file_bin_read_byte(f);
		press_left = file_bin_read_byte(f);
		press_right = file_bin_read_byte(f);
		press_a = file_bin_read_byte(f);
		press_b = file_bin_read_byte(f);
		press_c = file_bin_read_byte(f);
		press_action = file_bin_read_byte(f);
        
        if(global.stage_timer == 30000)
        {
			//Old state
			old_state = global.demo_play;
			
			//Set the demo machine to the end state
			global.demo_play = DEMO_END;
			
            //So you go to the next demo level
            global.demo_level_index++;
        }
        
        file_bin_close(f);
    }
    
    if(global.demo_play == DEMO_RECORD)
    {
        var f = file_bin_open(name, 2);
        file_bin_seek(f, demo_timer);
        
        file_bin_write_byte(f, hold_up);
        file_bin_write_byte(f, hold_down);
        file_bin_write_byte(f, hold_left);
        file_bin_write_byte(f, hold_right);
        file_bin_write_byte(f, hold_a);
        file_bin_write_byte(f, hold_b);
        file_bin_write_byte(f, hold_c);
        file_bin_write_byte(f, hold_action);
        
		//Button holds
        file_bin_write_byte(f, press_up);
        file_bin_write_byte(f, press_down);
        file_bin_write_byte(f, press_left);
        file_bin_write_byte(f, press_right);
        file_bin_write_byte(f, press_a);
        file_bin_write_byte(f, press_b);
        file_bin_write_byte(f, press_c);
        file_bin_write_byte(f, press_action);
        
        if(global.stage_timer == 31000)
        {
			//Old state
			old_state = global.demo_play;
			
			//Set the demo machine to the end state
			global.demo_play = DEMO_END;
        }
        
        file_bin_close(f);
    }
	
	if(global.demo_play == DEMO_END)
	{
		//Check
		var check = (old_state == DEMO_RECORD);
		
		//Else, fade to the title screen
        fade_to_room((check ? room : rm_splash), 2);
        music_set_fade(FADE_OUT, 2);
            
        //Reset these
		camera_set_mode(CAM_NULL);
        reset_stage_data();
		
		if(obj_fade.fade_timer == 0)
		{
		    global.demo_play = (check ? DEMO_PLAY : DEMO_NULL);
			if(check) demo_timer = 0;
		}
	}
    
    demo_timer += 16;
}

function demo_goto_room()
{
	//All the levels to have demos
    var lvl = [rm_arboreal_agate1, rm_arboreal_agate2];
        
    //Wrap the level index
    global.demo_level_index = wrap(global.demo_level_index, 0, array_length(lvl) - 1);
        
    //Fade to said level
    fade_to_room(lvl[global.demo_level_index], 1);
        
    //Change the game state to the demo
    global.demo_play = DEMO_PLAY;
}