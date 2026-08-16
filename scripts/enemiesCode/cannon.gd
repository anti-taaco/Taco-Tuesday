extends CharacterBody2D

var speed = 0
var direction = -1
var gravity = 1300
var damage = 0

var maxHealth = 100
var health = maxHealth
var hitByMelee = true
var hitByRanged = true
var flip = false

var projSpeed = 800
var projDmg = 0
var projTimer = 0

var playerPos = 0

@onready var sprite = $AnimatedSprite2D
@onready var player = $"../Player"
@onready var sprite2 = $Sprite2D

var projPath = load("res://scenes/enemies/enemyProj.tscn")

func _physics_process(delta: float)->void :
	playerPos = player.global_position
	sprite2.rotation = get_angle_to(playerPos) + 160.25

	if sprite2.rotation <= 161.82080078125 and sprite2.rotation >= 158.67919921875:
		flip = true
	else:
		flip = false
	sprite2.flip_v = flip
	velocity.x = direction * speed

	if not is_on_floor():
		velocity.y += gravity * delta

	if health >= maxHealth:
		health = maxHealth
	if health <= 0:
		queue_free()
		print(get_name() + " died")

	if get_slide_collision_count() > 0:
		var play = get_node(player.get_path())
		if play.is_in_group("player"):
			projTimer += 1
			if projTimer >= 100:
				var bullet = projPath.instantiate()
				get_parent().add_child(bullet)
				bullet.enemy = 1
				bullet.playerPos = playerPos
				bullet.position = global_position
				projTimer = 0

	move_and_slide()

func _on_area_2d_body_entered(body: Node2D)->void :
	if body.is_in_group("playerMelee"):
		print("Hit by " + body.get_name())

func takeDamage(dmgTaken):
	health -= dmgTaken
	print(str(dmgTaken) + " damage to Cannonball")
	print("Health: " + str(health) + "/" + str(maxHealth))
