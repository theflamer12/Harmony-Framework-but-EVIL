function play_sound(sound, loop = false){
	//Stop the audio before playing so it doesn't overlay
	audio_stop_sound(sound);
	
	//Play the sound
	return audio_play_sound(sound, 0, loop, global.sfx_volume);
}