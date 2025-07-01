extends Control

@export var tile_size: Vector2i = Vector2i(81, 81)
@export var grid_size: Vector2i = Vector2i(20, 10)

var hovered_tile: Vector2i = Vector2i(-1, -1)
var selected_tile: Vector2i = Vector2i(-1, -1)

func _ready():
	set_mouse_filter(Control.MOUSE_FILTER_PASS)
	queue_redraw()

func _process(_delta):
	var mouse_pos = get_local_mouse_position()
	hovered_tile = Vector2i(floor(mouse_pos.x / tile_size.x), floor(mouse_pos.y / tile_size.y))
	queue_redraw()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		selected_tile = hovered_tile
		queue_redraw()

func _draw():
	var grid_color = Color(1, 1, 1, 0.2)
	var hover_color = Color(1, 1, 1, 0.3)
	var select_color = Color(1, 0, 0, 0.4)

	# Draw grid lines
	for x in range(grid_size.x + 1):
		var px = x * tile_size.x
		draw_line(Vector2(px, 0), Vector2(px, grid_size.y * tile_size.y), grid_color)

	for y in range(grid_size.y + 1):
		var py = y * tile_size.y
		draw_line(Vector2(0, py), Vector2(grid_size.x * tile_size.x, py), grid_color)

	# Draw hovered tile
	if hovered_tile.x >= 0 and hovered_tile.x < grid_size.x and hovered_tile.y >= 0 and hovered_tile.y < grid_size.y:
		draw_rect(Rect2(hovered_tile * tile_size, tile_size), hover_color, true)

	# Draw selected tile
	if selected_tile.x >= 0 and selected_tile.x < grid_size.x and selected_tile.y >= 0 and selected_tile.y < grid_size.y:
		draw_rect(Rect2(selected_tile * tile_size, tile_size), select_color, true)
