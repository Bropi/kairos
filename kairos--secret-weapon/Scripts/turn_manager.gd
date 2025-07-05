extends Node

#other nodes' references
@onready var blue_group: Node2D = $"../UnitManager/BlueGroup"
@onready var red_group: Node2D = $"../UnitManager/RedGroup"
@onready var unit_manager: Node2D = $"../UnitManager"

#turn indicator UI nodes' references
@onready var label_blue: Label = $"../UI/TurnIndicator/LabelBlue"
@onready var label_red: Label = $"../UI/TurnIndicator/LabelRed"

#turn manager variables
var blue_team_members : int
var red_team_members : int
var blue_has_moved : int
var red_has_moved : int
var turn : String

#count group members on loading the scene for turn management
func _ready():
	blue_team_members = 0
	red_team_members = 0
	blue_has_moved = 0
	red_has_moved = 0
	turn = "blue"
	label_blue.visible = true
	label_red.visible = false
	count_team_members()

#Get call from unit script when a unit has moved
func unit_set_move(team: String):
	if team == "blue":
		blue_has_moved += 1
		if blue_has_moved == blue_team_members:
			turn_over("blue")
	elif team == "red":
		red_has_moved += 1
		if red_has_moved == red_team_members:
			turn_over("red")

#Gets called when all units in a team have moved and starts the next turn
func turn_over(team: String):
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
		
	#updates all unit positions in the unit manager and turn indicators
	update_turn_indicator(team)
	unit_manager.update_unit_positions()
	print("All units have moved in team: " + team)
	

#counts team members of both teams
func count_team_members():
	blue_team_members = blue_group.get_child_count()
	red_team_members = red_group.get_child_count()
	print("Blue team has: " + str(blue_team_members) + " units")
	print("Red team has: " + str(red_team_members) + " units")

#turn indicator funcs:
func update_turn_indicator(team: String):
	if team == "blue":
		label_blue.visible = false
		label_red.visible = true
	else: #team = red
		label_blue.visible = true
		label_red.visible = false

#make function to remove team member size if a unit is defeated
