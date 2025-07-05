extends Node

@onready var blue_group: Node2D = $"../UnitManager/BlueGroup"
@onready var red_group: Node2D = $"../UnitManager/RedGroup"


var blue_team_members = 0
var red_team_members = 0
var blue_has_moved = 0
var red_has_moved = 0
var turn = "blue"

func _ready():
	count_group_members()

#Get call from unit script when a unit has moved
func unit_set_move(team: String):
	if team == "blue":
		blue_has_moved += 1
		if blue_has_moved == blue_team_members:
			_on_team_moved("blue")
	elif team == "red":
		red_has_moved += 1
		if red_has_moved == red_team_members:
			_on_team_moved("red")


func _on_team_moved(team: String):
	if team == "blue":
		for unit in red_group.get_children():
			unit.new_turn()
		for unit in blue_group.get_children():
			unit.deselect()
		blue_has_moved = 0
		
	else:
		for unit in blue_group.get_children():
			unit.new_turn()
		for unit in red_group.get_children():
			unit.deselect()
		red_has_moved = 0
	
	
	print("All units have moved in team: " + team)
	


func count_group_members():
	blue_team_members = blue_group.get_child_count()
	red_team_members = red_group.get_child_count()
	print("Blue team has: " + str(blue_team_members) + " units")
	print("Red team has: " + str(red_team_members) + " units")

#make function to remove team member size if a unit is defeated
