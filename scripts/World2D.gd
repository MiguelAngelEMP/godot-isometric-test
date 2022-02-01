extends Node2D

# Declare member variables here. Examples:
onready var node_MapGround = $Maps/MapGround
onready var node_MapIndicator = $Maps/MapIndicator
onready var node_MapSelectionZones = $Maps/MapSelectionZones
var selectable_coordinates = PoolVector2Array()

var unit_selected

signal unit_selected(unit)
signal units_unselected()

var unit_scene = preload("res://scenes/Unit.tscn")
var unit1 = unit_scene.instance()
var unit2 = unit_scene.instance()
var unit3 = unit_scene.instance()


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("unit_selected", $"/root/Game/UI", "_on_World2D_unit_selected")
	self.connect("units_unselected", $"/root/Game/UI", "_on_World2D_units_unselected")
	
	unit1.init("John", 8, 3, 8)
	add_child(unit1)
	unit1.set_map_position(Vector2(1,1))
	
	unit2.init("Doe", 15, 6, 8)
	add_child(unit2)
	unit2.set_map_position(Vector2(4,1))
	
	unit3.init("Max", 20, 20, 20)
	add_child(unit3)
	unit3.set_map_position(Vector2(8,3))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if unit_selected:
		_check_selected_unit(unit_selected)
	else:
		node_MapSelectionZones.clear()
	_check_units_selection()
	_check_input()


func _check_input():
	if Input.is_action_pressed("reset"):
		get_tree().reload_current_scene()


func _check_units_selection():
	if Input.is_action_just_pressed("left_click"):
		for unit_in_group in get_tree().get_nodes_in_group("units"):
			if unit_in_group.get_map_position() == node_MapIndicator.get_map_coordinates():
				get_tree().call_group_flags(SceneTree.GROUP_CALL_REALTIME,
					"units", "set_selected", false)
				unit_in_group.set_selected(true)
				unit_selected = unit_in_group
				emit_signal("unit_selected", unit_selected)
				break
			else:
				get_tree().call_group_flags(SceneTree.GROUP_CALL_REALTIME,
					"units", "set_selected", false)
				unit_selected = null
				emit_signal("units_unselected")


func _check_selected_unit(selected):
	var selected_position = selected.get_map_position()
	var unit_mp = selected.get_movement_points()
	var checking_position
	
	node_MapSelectionZones.clear()
	selectable_coordinates.append(selected_position)
	
	if unit_mp > 0:
		for mp in unit_mp:
			for coordinate in selectable_coordinates:
				checking_position = coordinate + Vector2(1,0)
				if node_MapGround.is_valid_cell(checking_position) and !(checking_position in selectable_coordinates):
					selectable_coordinates.append(checking_position)
				
				checking_position = coordinate + Vector2(0,1)
				if node_MapGround.is_valid_cell(checking_position) and !(checking_position in selectable_coordinates):
					selectable_coordinates.append(checking_position)
				
				checking_position = coordinate - Vector2(1,0)
				if node_MapGround.is_valid_cell(checking_position) and !(checking_position in selectable_coordinates):
					selectable_coordinates.append(checking_position)
				
				checking_position = coordinate - Vector2(0,1)
				if node_MapGround.is_valid_cell(checking_position) and !(checking_position in selectable_coordinates):
					selectable_coordinates.append(checking_position)
		
		for unit in get_tree().get_nodes_in_group("units"):
			if Array(selectable_coordinates).has(unit.get_map_position()):
				selectable_coordinates.remove(Array(selectable_coordinates).find(unit.get_map_position()))
		
		for coordinate in selectable_coordinates:
			node_MapSelectionZones.set_cellv(coordinate, 0)
		
		if node_MapSelectionZones.get_cellv(node_MapIndicator.get_map_coordinates()) != TileMap.INVALID_CELL:
			if Input.is_action_just_pressed("left_click"):
				selected.set_movement_points(
					selected.get_movement_points() - 
					(abs(selected.get_map_position().x - node_MapIndicator.get_map_coordinates().x) +
					abs(selected.get_map_position().y - node_MapIndicator.get_map_coordinates().y))
				)
				selected.set_map_position(node_MapIndicator.get_map_coordinates())
		
		selectable_coordinates.resize(0)


func _on_ButtonPassTurn_pressed():
	print("Turn Passed")
	for unit_in_group in get_tree().get_nodes_in_group("units"):
		unit_in_group.set_movement_points(unit_in_group.get_max_movement_points())
		unit_in_group.set_action_points(unit_in_group.get_max_action_points())
