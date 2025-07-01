extends CharacterBody2D

@export var is_player: bool = true
@export var move_range := 3
@export var grid_pos := Vector2i.ZERO

var selected := false

func _ready():
	grid_pos = get_grid_position()
	

func get_grid_position():
	var tilemap = get_tree().get_root().get_node("Main/TileMapLayer")
	return tilemap.local_to_map(global_position)

func move_to(tile_pos: Vector2i):
	var tilemap = get_tree().get_root().get_node("Main/TileMapLayer")
	var world_pos = tilemap.map_to_local(tile_pos)
	global_position = world_pos
	grid_pos = tile_pos
