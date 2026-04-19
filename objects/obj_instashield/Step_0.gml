    //Timer
    timer++;
    
    //Die if you touched the ground
    if(obj_player.ground || timer >= 12) instance_destroy();