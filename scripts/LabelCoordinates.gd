extends Label

var node_MapIndicator


# Called when the node enters the scene tree for the first time.
func _ready():
	node_MapIndicator = $"/root/Game/World2D/Maps/MapIndicator"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var map_coordinates = String(node_MapIndicator.get_map_coordinates())
	self.set_text(map_coordinates)
