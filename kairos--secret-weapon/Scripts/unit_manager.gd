extends Node2D

var selected_unit := null

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var clicked_pos = get_global_mouse_position()
		var tilemap = $"../TileMap"
		var tile_pos = tilemap.local_to_map(clicked_pos)

		if selected_unit:
			var dist = selected_unit.grid_pos.distance_to(tile_pos)
			if dist <= selected_unit.move_range:
				selected_unit.move_to(tile_pos)
				selected_unit = null
				get_node("../TurnManager").next_turn()
			return

		# Select unit
		for unit in get_children():
			if unit.get_grid_position() == tile_pos and unit.is_player == get_node("../TurnManager").current_player_turn:
				selected_unit = unit
				break
