#define ext_new_player_data
return new PlayerData(argument0, argument1)

#define ext_init
p_num = parameter_count();
if (p_num > 0)
{
    var i;
    for (i = 0; i < p_num; i += 1)
    {
        p_string[i] = parameter_string(i + 1);
    }
}

window_set_fullscreen(true)
show_debug_message("inisdfsdft")

/// @desc			Creates a PlayerData type. PlayerData stores 
///					information about a specific player including 
///					the player's number, index, and score.
/// @param {Real}	_index
/// @param {Real}	_points
function PlayerData(_index, _points) constructor {
	number = _index + 1
	index = _index
	points = _points
}