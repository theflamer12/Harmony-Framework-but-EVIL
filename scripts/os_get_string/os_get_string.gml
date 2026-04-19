//Gamemaker should've had this in the first place
function os_get_string()
{
	switch(os_type)
	{
		case os_windows: return "Windows";
		case os_gxgames: return "GX Games";
		case os_linux: return "Linux";
		case os_macosx: return "MacOS";
		case os_ios: return "IOS";
		case os_tvos: return "tvOS";
		case os_android: return "Android";
		case os_ps4: return "PlayStaion 4";
		case os_ps5: return "PlayStaion 5";
		case os_gdk: return "GDK";
		case os_xboxseriesxs: return "Xbox";
		case os_switch: return "Switch";
		case os_unknown: return "Unknown";
		default: return "Unknown";
	}
}