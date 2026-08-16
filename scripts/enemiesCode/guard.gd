extends CharacterBody2D

var speed = 400
var direction = -1
var gravity = 1300
var damage = 10
var maxHealth = 200
var health = maxHealth
var flip = false

var hitByMelee = true
var hitByRanged = true

@onready var sprite = $AnimatedSprite2D

func _physics_process(delta: float)->void :
	if is_on_wall():
		direction *= -1
		if flip == true:
			flip = false
		else:
			flip = true
		sprite.flip_h = flip
	velocity.x = direction * speed

	if not is_on_floor():
		velocity.y += gravity * delta

	if health >= maxHealth:
		health = maxHealth
	if health <= 0:
		queue_free()
		print(get_name() + " died")

	move_and_slide()

func _on_area_2d_body_entered(body: Node2D)->void :
	if body.is_in_group("playerMelee"):
		print("Hit by " + body.get_name())

func takeDamage(dmgTaken):
	health -= dmgTaken
	print(str(dmgTaken) + " damage dealt")
	print("Health: " + str(health) + "/" + str(maxHealth))
