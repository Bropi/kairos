extends TileMapLayer

@onready var tile_map_layer_selected: TileMapLayer = $"."

var grid_width = 20
var grid_height = 10
var x_offset = 2
var y_offset = 1
var dic = {}
var selected_tile

func _ready():
	for x in range(x_offset, x_offset + grid_width):
		for y in range(y_offset, y_offset + grid_height):
			var cords = Vector2i(x, y)
			dic[str(cords)] = {
				"Type": "Blue",
				"Position": str(Vector2(x,y))
			}
			tile_map_layer_selected.set_cell(cords, 0, Vector2i(3, 2), 0)  # Base tile

func _process(delta):
	var tile = local_to_map(get_global_mouse_position())
	selected_tile = map_to_local(tile)
	
	# Clear previous highlights (only within the grid)
	for x in range(x_offset, x_offset + grid_width):
		for y in range(y_offset, y_offset + grid_height):
			tile_map_layer_selected.erase_cell(Vector2i(x, y))

	# Highlight tile under mouse if it's inside the grid
	if dic.has(str(tile)):
		tile_map_layer_selected.set_cell(tile, 1, Vector2i(5, 4), 0)  # Highlight tile
		#print(dic[str(tile)])


func is_tile_inside_bounds(tile: Vector2i) -> bool:
	return tile.x >= x_offset && tile.x < x_offset + grid_width && \
		   tile.y >= y_offset && tile.y < y_offset + grid_height
