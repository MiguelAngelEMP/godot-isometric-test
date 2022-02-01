extends Control

# Declare member variables here. Examples:
onready var node_UnitPanels = $UnitPanels
onready var label_unit_name = $UnitPanels/PanelName/LabelUnitName
onready var label_life_values = $UnitPanels/PanelStats/GridContainer/LifeValues
onready var label_movement_values = $UnitPanels/PanelStats/GridContainer/MPValues
onready var label_action_values = $UnitPanels/PanelStats/GridContainer/APValues
onready var button_pass_turn = $UnitPanels/PanelTurn/ButtonPassTurn

# Called when the node enters the scene tree for the first time.
func _ready():
	button_pass_turn.connect("pressed", $"/root/Game/World2D", "_on_ButtonPassTurn_pressed")
	node_UnitPanels.set_visible(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_World2D_unit_selected(unit):
	print("Unit Selected : {name}".format({"name":unit.get_unit_name()}))
	node_UnitPanels.set_visible(true)
	label_unit_name.set_text(unit.get_unit_name())
	label_life_values.set_text("{actual}/{max}".format(
		{"actual":unit.get_health(),
		 "max":unit.get_max_health()}))
	label_movement_values.set_text("{actual}/{max}".format(
		{"actual":unit.get_movement_points(),
		 "max":unit.get_max_movement_points()}))
	label_action_values.set_text("{actual}/{max}".format(
		{"actual":unit.get_action_points(),
		 "max":unit.get_max_action_points()}))

func _on_World2D_units_unselected():
	print("Units Unselected")
	node_UnitPanels.set_visible(false)
