function check_instashield(do_want_to_exist)
{
	if(instance_exists(obj_instashield))
	{
		return (do_want_to_exist ? instance_place(x, y, obj_instashield) : false);
	}
	else
	{
		return !do_want_to_exist;
	}
}