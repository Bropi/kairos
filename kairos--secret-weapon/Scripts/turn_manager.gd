extends Node

var current_player_turn := true  # true = player, false = enemy
var selected_unit := null

func next_turn():
	current_player_turn = !current_player_turn
	selected_unit = null
