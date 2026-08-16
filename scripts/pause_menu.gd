extends Control

var paused = false

func _process(delta: float)->void :
	if Input.is_action_just_pressed("pause"):
		paused = !paused

	if paused:
		show()
		get_tree().paused = true
	else:
		hide()
		get_tree().paused = false
	
	if $Resume.button_pressed:
		paused = true
	if $Restart.button_pressed:
		get_tree().reload_current_scene()
	else: if $Quit.button_pressed:
		pass
