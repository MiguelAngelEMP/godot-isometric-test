extends Position2D


# Declare member variables here. Examples:
onready var node_AnimatedSprite = $"AnimatedSprite"
onready var node_MapGround = $"../Maps/MapGround"
onready var node_MapIndicator = $"../Maps/MapIndicator"

enum direction {LEFT, RIGHT, UP, DOWN}

var world_position
var map_position setget set_map_position, get_map_position

var unit_name setget set_unit_name, get_unit_name
var health setget set_health, get_health
var max_health setget set_max_health, get_max_health
var movement_points setget set_movement_points, get_movement_points
var max_movement_points setget set_max_movement_points, get_max_movement_points
var action_points setget set_action_points, get_action_points
var max_action_points setget set_max_action_points, get_max_action_points

var selected setget set_selected, is_selected


# Getters and Setters
func get_unit_name():
	return unit_name


func set_unit_name(new_unit_name):
	unit_name = new_unit_name


func is_selected():
	return selected


func set_selected(new_selected):
	selected = new_selected


func get_health():
	return health


func set_health(new_health):
	health = new_health


func get_max_health():
	return max_health


func set_max_health(new_max_health):
	max_health = new_max_health


func get_movement_points():
	return movement_points


func set_movement_points(new_movement_points):
	movement_points = new_movement_points


func get_max_movement_points():
	return max_movement_points


func set_max_movement_points(new_max_movement_points):
	max_movement_points = new_max_movement_points


func get_action_points():
	return action_points


func set_action_points(new_action_points):
	action_points = new_action_points


func get_max_action_points():
	return max_action_points


func set_max_action_points(new_max_action_points):
	max_action_points = new_max_action_points


func get_map_position():
	map_position = node_MapGround.to_local(self.get_position())
	return node_MapGround.world_to_map(map_position)


func set_map_position(coordinate):
	world_position = node_MapGround.map_to_world(coordinate)
	world_position = node_MapGround.to_global(world_position)
	self.set_position(world_position)


# Initializer
func init(init_unit_name = "Unit", init_max_health=3,
		init_max_movement_points=3, init_max_action_points=3):
	unit_name = init_unit_name
	max_health = init_max_health
	max_movement_points = init_max_movement_points
	max_action_points = init_max_action_points


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("units")
	health = max_health
	movement_points = max_movement_points
	action_points = max_action_points
	node_AnimatedSprite.play("idle")


# Called every frame.
func _process(_delta):
#	_process_input()
	_process_selected()


func _process_input():
	if Input.is_action_just_pressed('left'):
		_move_to_direction(direction.LEFT)
		node_AnimatedSprite.play("idle_back")
		node_AnimatedSprite.set_flip_h(true)
		
	elif Input.is_action_just_pressed('right'):
		_move_to_direction(direction.RIGHT)
		node_AnimatedSprite.play("idle")
		node_AnimatedSprite.set_flip_h(false)
		
	elif Input.is_action_just_pressed('up'):
		_move_to_direction(direction.UP)
		node_AnimatedSprite.play("idle_back")
		node_AnimatedSprite.set_flip_h(false)
		
	elif Input.is_action_just_pressed('down'):
		_move_to_direction(direction.DOWN)
		node_AnimatedSprite.play("idle")
		node_AnimatedSprite.set_flip_h(true)


# Moves the unit to the given direction
func _move_to_direction(direction):
	var cell_to_move
	
	map_position = get_map_position()
	match direction:
		0:
			cell_to_move = map_position - Vector2(1,0)
		1:
			cell_to_move = map_position + Vector2(1,0)
		2:
			cell_to_move = map_position - Vector2(0,1)
		3:
			cell_to_move = map_position + Vector2(0,1)
	
	if node_MapGround.is_valid_cell(cell_to_move):
		set_map_position(cell_to_move)


func _process_selected():
	var actual_animation = node_AnimatedSprite.get_animation()
	
	if selected:
		if not actual_animation.begins_with("s_"):
			node_AnimatedSprite.play("s_" + actual_animation)
	else:
		if actual_animation.begins_with("s_"):
			node_AnimatedSprite.play(actual_animation.lstrip("s_"))

