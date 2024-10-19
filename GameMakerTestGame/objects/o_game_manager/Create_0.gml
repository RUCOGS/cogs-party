/// @description Insert description here
// You can write your code in this editor

//window_set_fullscreen(true)

show_debug_message("spawning players")
	
for (var i = 0; i < 4; i++) {
	with (instance_create_depth(i * 128, 0, 0, o_player)) {
		self.construct("hello")
	}
}