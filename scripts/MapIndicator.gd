extends TileMap


# Declare member variables here.
var mouse_position

onready var node_map_ground = $"../MapGround"

var map_coordinates setget ,get_map_coordinates


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	mouse_position = get_viewport().get_mouse_position()
	_update_map(mouse_position)


func _update_map(position):
	position = to_local(position)
	map_coordinates = self.world_to_map(position)
	map_coordinates = map_coordinates.floor()
	
	self.clear()
	if node_map_ground.is_valid_cell(map_coordinates):
		self.set_cell(map_coordinates.x, map_coordinates.y, 0)
	else:
		map_coordinates = Vector2(0,0)

func get_map_coordinates():
	return map_coordinates
