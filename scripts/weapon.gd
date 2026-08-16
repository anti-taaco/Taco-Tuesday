extends CharacterBody2D

var direction = 1
var weaponSlot = 1
@onready var player: CharacterBody2D = $".."


func _process(delta: float)->void :
	if Input.is_action_pressed("left"):
		direction = -1
	else: if Input.is_action_pressed("right"):
		direction = 1
	global_position.x = player.position.x + 27 * direction
	global_position.y = player.position.y + 16
	rotate(get_angle_to(get_global_mouse_position()))

	if weaponSlot == 1:
		pass
	else: if weaponSlot == 2:
		pass
	else: if weaponSlot == 3:
		pass
