extends Control


func _on_ButtonNewGame_pressed():
	get_tree().change_scene("res://scenes/Game.tscn")


func _on_ButtonCloseGame_pressed():
	get_tree().quit()
