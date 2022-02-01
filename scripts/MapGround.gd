extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


# Tells if the map coordinate has a valid CELL.
func is_valid_cell(coordinate):
	return get_cellv(coordinate) != INVALID_CELL


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
