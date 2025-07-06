extends TileMapLayer

@onready var tile_map_layer_selected: TileMapLayer = $"."
@onready var unit_manager: Node2D = $"../../UnitManager"

var tile : Vector2i

var grid_width = 20
var grid_height = 10
var x_offset = 2
var y_offset = 1
var dic = {}
var dic_selected = {}
var surrounding_tile : Vector2i
var checked_tile : Vector2i

#check if unit is selected to prevent tile erasure
var unit_selected : bool
var offsets : Array

func _ready():
	unit_selected = false
	#writes all tile's coördinates into a dictionary (dic) for later lookup
	for x in range(x_offset, x_offset + grid_width):
		for y in range(y_offset, y_offset + grid_height):
			var cords = Vector2i(x, y)
			dic[str(cords)] = {
				"Type": "Grid",
				"Position": str(Vector2(x,y))
			}
			#print(dic[str(cords)])
			tile_map_layer_selected.set_cell(cords, 0, Vector2i(3, 2), 0)
			

func _process(delta):
	tile = local_to_map(get_global_mouse_position())
	
	if !unit_selected:
		clear_highlights()
		# Highlight tile under mouse if it's inside the grid
		if dic.has(str(tile)):
			tile_map_layer_selected.set_cell(tile, 1, Vector2i(5, 4), 0)  # Highlight tile
			#print(dic[str(tile)])
			
		
	#when unit is selected and the surrounding tiles recognize the tile that is hovered over:
	#highlight the surrounding tiles and update with the hovering tile to keep that one green
	elif dic_selected.has(str(tile)):
		#select only highlighted tiles
		clear_highlights()
		highlight_movement_zone()
		tile_map_layer_selected.set_cell(tile, 1, Vector2i(5, 4), 0)  # Highlight selected tile
		
	#when unit is selected but out of bounds of movement zone: make hovering tile invisible
	elif !dic_selected.has(str(tile)) && is_tile_inside_bounds(tile):
		clear_highlights()
		highlight_movement_zone()
		tile_map_layer_selected.set_cell(tile, 1, Vector2i(3, 2), 0)  # Highlight selected tile



#tile grid manipulation functions:

#gets called from player unit's move selection
func check_surrounding_tiles(selected_tile: Vector2i, radius: int):
	unit_selected = true
	checked_tile = selected_tile
	
	# Define the 8 surrounding directions (radius = 1)
	offsets = [
		Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
		Vector2i(-1,  0),                 Vector2i(1,  0),
		Vector2i(-1,  1), Vector2i(0,  1), Vector2i(1,  1)
	]
	# Clear previous selected tiles dictionary
	dic_selected.clear()
	#highlight available tiles and add offsets to dic_selected dictionary
	highlight_movement_zone()


#Highlight surrounding tiles where unit can go after selecting it
func highlight_movement_zone():
	var occupied = false
#Loop through offsets and calculate surrounding tiles
	for offset in offsets:
		#ask unit manager script without team flag if the tile is occupied
		#if the tile is occupied the func will return "none"
		var surrounding_tile = checked_tile + offset
		if unit_manager.is_tile_occupied("another", surrounding_tile) == "none":
			occupied = false
		else:
			occupied = true
		
		if is_tile_inside_bounds(surrounding_tile) && !occupied:
			#print("Surrounding tile:", surrounding_tile)
			# Highlight tile purple for movement zone
			tile_map_layer_selected.set_cell(surrounding_tile, 1, Vector2i(3, 4), 0)   
			dic_selected[str(surrounding_tile)] = {
				"Type": "offset",
				"Position": str(surrounding_tile)
			}
			
			

func clear_highlights():
	# Clear previous highlights (only within the grid)
	for x in range(x_offset, x_offset + grid_width):
		for y in range(y_offset, y_offset + grid_height):
			if !dic_selected.has(tile) && unit_selected:
				tile_map_layer_selected.erase_cell(Vector2i(x, y))
			else:
				tile_map_layer_selected.erase_cell(Vector2i(x, y))


func is_tile_inside_bounds(tile: Vector2i) -> bool:
	return tile.x >= x_offset && tile.x < x_offset + grid_width && \
		   tile.y >= y_offset && tile.y < y_offset + grid_height
