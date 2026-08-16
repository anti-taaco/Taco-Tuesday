extends Control

func _process(delta: float)->void :
	show()
	get_tree().paused = false
	print("men you")
	if $Button.button_pressed:
		get_tree().change_scene_to_file("res://scenes/playerStuff/player.tscn")
