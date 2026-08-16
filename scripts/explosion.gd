extends CharacterBody2D

var timer = 0
var timerMax = 5
var damage = 40
var slot = 1

func _physics_process(delta: float)->void :
	if timer == 0:
		if slot == 1:
			timerMax = 5
			damage = 35
	print("explo timer: " + str(timer) + "/" + str(timerMax) )
	move_and_slide()
	if timer >= timerMax:
		queue_free()
	timer += 1


func _on_area_2d_body_entered(body: Node2D)->void :
	if body.is_in_group("enemies"):
		var enemy = get_node(body.get_path())
		enemy.takeDamage(round(damage))
	if body.is_in_group("player"):
		var play = get_node(body.get_path())
		var direction = (global_position - play.global_position).normalized()
		play.moveSpeed += play.speed * -direction.x * 2
		play.velocity.y += play.jumpPower
