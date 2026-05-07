function save_background_visibility(){
	for (var i = 0; i < instance_number(par_background); ++i)
	{
	    var bg = instance_find(par_background, i);
	    var name = object_get_name(bg.object_index);
		
	    global.store_background_visibility[$ name] = bg.visible;
	}
}

function reset_background_visibility(){
	global.store_background_visibility = {};
}
