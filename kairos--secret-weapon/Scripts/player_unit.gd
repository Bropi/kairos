extends CharacterBody2D

#other node's scripts:
@onready var tile_map_layer_selected: TileMapLayer = $"../../../TileMapLayers/TileMapLayerSelected"
@onready var turn_manager: Node = $"../../../TurnManager"
@onready var unit_manager: Node2D = $"../../../UnitManager"

#player node's children:
@onready var sprite_2d_selected: Sprite2D = $Sprite2dSelected
@onready var sprite_2d_moved: Sprite2D = $Sprite2dMoved
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var select_sound: AudioStreamPlayer2D = $Node2D/SelectSound
@onready var confirm_sound: AudioStreamPlayer2D = $Node2D/ConfirmSound
@onready var error_sound: AudioStreamPlayer2D = $Node2D/ErrorSound
@onready var hover_sound: AudioStreamPlayer2D = $Node2D/HoverSound


#unit variables
var is_turn : bool
var has_moved : bool
var is_player_selected : bool
#var team : String
var unit_location : Vector2i
@export var team: String

#unit combat stats
@export var unit_type: String
@export var health: int = 1
@export var damage: int = 1
@export var attack_range: int = 2
@export var walking_range: int = 2

#tile variables
var clicked_tile : Vector2i
var tile_occupied : bool
var tile_in_bounds : bool
var tile_in_unit_range : bool


#on start put player vars in right state: team blue starts, team red second
func _ready() -> void:
	is_turn = true
	has_moved = false
	is_player_selected = false
	sprite_2d_moved.visible = false
	sprite_2d_selected.visible = false
	unit_location = tile_map_layer_selected.local_to_map(global_position)
	tile_occupied = false
	
	#check which team this unit is in 
	check_team()
	if team == "red":
		is_turn = false
		animated_sprite_2d.modulate = Color(1, 0.3, 0)       # Red
		animated_sprite_2d.scale.x = -1  # Flipped
		
	update_unit_stats(unit_type)
	#assign combat stats after verifying what kind of unit the player is
	#use another func for this


#input recognition functions:

# Called when selecting this unit's Area2D
func _on_clicked_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("leftClick"):
		
		#checks + change variables and play sound: this unit is selected
		if is_turn && !has_moved && !is_player_selected && !other_unit_selected():
			is_player_selected = true
			sprite_2d_moved.visible = false
			sprite_2d_selected.visible = true
			select_sound.play()
			clicked_tile = tile_map_layer_selected.local_to_map(get_global_mouse_position())
			print("\nSelected unit on tile: " + str(clicked_tile))
			#update tile grid script:
			tile_map_layer_selected.unit_selected = true
			tile_map_layer_selected.check_surrounding_tiles(clicked_tile, walking_range)
			
		#elif !is_turn && !is_player_selected:
			#error_sound.play()





# Handles left mouse clicks on the map after selection for movement
func _unhandled_input(event):
	
	if is_turn && is_player_selected && event.is_action_pressed("leftClick"):
		clicked_tile = tile_map_layer_selected.local_to_map(get_global_mouse_position())
		
		#check with tilemap script if selected tile is within unit's walking range:
		tile_in_unit_range = tile_map_layer_selected.dic_selected.has(str(clicked_tile))
		#check if the clicked position already contains a unit or is out of bounds
		if !is_tile_occupied(clicked_tile) && is_tile_in_bounds(clicked_tile) && tile_in_unit_range:
			move_pos(clicked_tile)
			is_player_selected = false
			has_moved = true
			is_turn = false
			sprite_2d_selected.visible = false
			sprite_2d_moved.visible = true
			unit_manager.update_unit_positions()
			#call turn manager script to let it know a unit of this team has moved
			if team == "blue":
				turn_manager.unit_set_move("blue")
			else:
				turn_manager.unit_set_move("red")
			#deselect highlighted tiles in tilemap layer script
			tile_map_layer_selected.dic_selected.clear()
			tile_map_layer_selected.unit_selected = false
			tile_map_layer_selected.clear_highlights()
			
		#if the tile is already taken/out of bounds the selected unit will be deselected
		else:
			tile_map_layer_selected.dic_selected.clear()
			tile_map_layer_selected.unit_selected = false
			tile_map_layer_selected.clear_highlights()
			error_sound.play()
			self.deselect()
		



#methods that input functions use for selection and movement:

# Move unit to grid tile if valid tile
func move_pos(tile: Vector2i):
	global_position = tile_map_layer_selected.map_to_local(tile)
	confirm_sound.play()
	print("unit moved to tile: " + str(tile))
	#self.deselect()

# Check if target tile is already occupied
func is_tile_occupied(tile_pos: Vector2i) -> bool:
	#this var is for later combat implementation
	var occupier = "none"
	tile_occupied = false
	
	if unit_manager.is_tile_occupied(self.team, tile_pos) == "blue"\
	or unit_manager.is_tile_occupied(self.team, tile_pos) == "red":
		tile_occupied = true
		
	return tile_occupied

# Check if tile is in bounds and return a fitting value
func is_tile_in_bounds(tile_pos: Vector2i) -> bool:
	#check if given position is inside the tile grid
	if tile_pos.x >= tile_map_layer_selected.x_offset && tile_pos.x < tile_map_layer_selected.x_offset + tile_map_layer_selected.grid_width \
	&& tile_pos.y >= tile_map_layer_selected.y_offset && tile_pos.y < tile_map_layer_selected.y_offset + tile_map_layer_selected.grid_height:
		#print("tile is in bounds")
		return true
	else:
		#print("tile is out of bounds")
		return false
		

func other_unit_selected() -> bool:
	for unit in get_tree().get_nodes_in_group("PlayerGroup"):
		if unit.is_player_selected == true:
			print("Other unit already selected")
			return true
	return false

#checks which parent node this unit has for team assignment and change vars accordingly
func check_team():
	if str(get_parent()) == "BlueGroup:<Node2D#36893099724>":
		self.team = "blue"
	if str(get_parent()) == "RedGroup:<Node2D#37849401093>":
		self.team = "red"

#get team func for unit manager
func get_team():
	return team

# Deselect this unit
func deselect():
	print("Unit deselected")
	has_moved = false
	is_player_selected = false
	sprite_2d_moved.visible = false
	sprite_2d_selected.visible = false

#gets called every new turn to refresh the unit variables
func new_turn():
	print("starts a new turn!")
	is_turn = true
	has_moved = false
	is_player_selected = false
	sprite_2d_moved.visible = false
	sprite_2d_selected.visible = false
	unit_location = tile_map_layer_selected.local_to_map(global_position)
	
	
	
#combat functions
func update_unit_stats(unit_type : String):
	health = 1
	damage = 1
	attack_range = 2
	walking_range = 2
	


#pathfinding functions
 
