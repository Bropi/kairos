extends Node2D

#variables for other node's scripts:
@onready var blue_group: Node2D = $BlueGroup
@onready var red_group: Node2D = $RedGroup
@onready var tile_map_layer_selected: TileMapLayer = $"../TileMapLayers/TileMapLayerSelected"

#unit manager variables:
var blue_unit_positions: Array[Vector2i] = []
var red_unit_positions: Array[Vector2i] = []
var unit_tile_pos: Vector2i

#function variables:
#is_tile_occupied:
var tile_pos : Vector2i
var occupied : String

func _ready() -> void:
	update_unit_positions()

#gets all units positions on the grid and puts them in arrays
#func update_unit_positions():
	#print("Blue team positions:")
	#for unit in blue_group.get_children():
		#var unit_tile_pos = tile_map_layer_selected.local_to_map(unit.global_position)
		#blue_unit_positions.append(unit_tile_pos)
		#print(unit_tile_pos)
		#
	#print("Red team positions:")
	#for unit in red_group.get_children():
		#var unit_tile_pos = tile_map_layer_selected.local_to_map(unit.global_position)
		#red_unit_positions.append(unit_tile_pos)
		#print(unit_tile_pos)

#update unit positions, called from units
func update_unit_positions():
	blue_unit_positions.clear()
	red_unit_positions.clear()
	
	print("Updating unit positions...")

	# Search all units in both groups
	for unit in blue_group.get_children() + red_group.get_children():
		var unit_tile_pos = tile_map_layer_selected.local_to_map(unit.global_position)

		if unit.team == "blue":
			blue_unit_positions.append(unit_tile_pos)
		elif unit.team == "red":
			red_unit_positions.append(unit_tile_pos)
			
		#print(unit.name, " → ", unit.team, " at ", unit_tile_pos)

#Used by player nodes to check other tile positions for occupation
func is_tile_occupied(team: String, target_tile: Vector2i) -> String:
	var occupied = "none"
	
	for tile_pos in blue_unit_positions + red_unit_positions:
		if tile_pos == target_tile:
			occupied = team
			#print("tile is occupied by a " + team + " unit")
			break
	
	return occupied
