extends CharacterBody2D

var dir : float
var spawnPos : Vector2
var spawnRot : float

var timer : int
var speed = 850
var damage = 60
var slot = 1

var createExplosion = false
var bounce = false
var melee = false

var mousePos = get_global_mouse_position()
var mouseDirection = (mousePos - position).normalized()

var explosionPath = load("res://scenes/playerStuff/explosion.tscn")

func _ready() -> void:
	global_position = spawnPos
	global_rotation = spawnRot
	if timer == 0:
		timer = 50
	if damage <= 0:
		damage = 100
		
	if slot == 1:
		speed = 1000
		timer = 50
		damage = 50
		createExplosion = true
	else: if slot == 2:
		speed = 1800
		timer = 30
		damage = 40
		bounce = true
	rotate(get_angle_to(get_global_mouse_position()))
	mousePos = get_global_mouse_position()
	mouseDirection = (mousePos - position).normalized()
	velocity = mouseDirection * speed

func _physics_process(delta: float)->void :
	var tempVoc = velocity
	move_and_slide()
	if get_slide_collision_count() != 0 and bounce:
		if is_on_ceiling() or is_on_floor():
			velocity.y = -tempVoc.y
		if is_on_wall():
			velocity.x = -tempVoc.x
		global_rotation_degrees = -global_rotation_degrees
		damage *= 1.25
			
	if timer <= 0 or (get_slide_collision_count() != 0 and slot == 1):
		if createExplosion:
			explode()
		queue_free()
	timer -= 1

func _on_area_2d_body_entered(body: Node2D)->void :
	if body.is_in_group("enemies"):
		if createExplosion:
			explode()
		await get_tree().create_timer(0.01).timeout
		var enemy = get_node(body.get_path())
		if enemy.hitByRanged == true:
			enemy.takeDamage(round(damage))
		queue_free()

func explode():
	var explosion = explosionPath.instantiate()
	get_parent().add_child(explosion)
	explosion.slot = 1
	explosion.position = global_position
