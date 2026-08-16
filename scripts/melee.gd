extends CharacterBody2D

var timer = 0
var timerMax = 100
var damage = 60
var slot = 1

var playerPos = Vector2(0, 0)
var playerDir = 0
var mousePos = 0
var mouseDirection = 0

var projPath = load("res://scenes/playerStuff/projectile.tscn")

func _physics_process(delta: float)->void :
	if slot == 1:
		damage = 70
		timerMax = 10

	if timer == 0:
		mousePos = get_global_mouse_position()
		rotate(get_angle_to(mousePos))
		mouseDirection = (mousePos - playerPos).normalized()
	global_position = playerPos + (mouseDirection * 65)
	move_and_slide()
	if timer >= timerMax:
		queue_free()
	timer += 1

func getPlayerPosition(pos):
	playerPos = pos

func getPlayerDirection(dir):
	playerDir = dir

func _on_area_2d_body_entered(body: Node2D)->void :
	if body.is_in_group("enemyRanged"):
		var enemy = get_node(body.get_path())
		var bullet = projPath.instantiate()
		get_parent().add_child(bullet)
		bullet.slot = 0
		bullet.speed = enemy.speed
		bullet.timerMax = enemy.timerMax
		bullet.damage = 100
		bullet.createExplosion = true
		bullet.position = enemy.global_position
		await get_tree().create_timer(0.01).timeout
		enemy.queue_free()
	else: if body.is_in_group("enemies"):
		var enemy = get_node(body.get_path())
		await get_tree().create_timer(0.01).timeout
		enemy.takeDamage(damage)
		for child in get_parent().get_children():
			if child.has_method("healUp"):
				child.healUp(10)
