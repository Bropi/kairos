extends CharacterBody2D

var is_turn = true
var pos_to_go_to = Vector2.ZERO
var is_player_selected = false

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pos_to_go_to = global_position


func _input(event):
	#player select
	#Logic for checks
	if is_turn:
		#logic for if the left mouse clicked on the sprite
		if is_player_selected == false && event is InputEventMouseButton && event.pressed && event.button_index == MOUSE_BUTTON_LEFT:
			if sprite_2d.get_rect().has_point(to_local(event.position)):
				print("You selected a player unit!")
				is_player_selected = true
				
		elif is_player_selected && event.is_action_pressed("leftClick"):
			pos_to_go_to = get_global_mouse_position()
			print("You moved to position: " + str(get_global_mouse_position()))
			is_player_selected = false

func _physics_process(delta: float) -> void:
	var vel = (pos_to_go_to - self.global_position)
	vel = vel.clamp(Vector2(-300,-300), Vector2(300,300))
	velocity = vel
	move_and_slide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
