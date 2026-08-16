extends CharacterBody2D


var maxHealth = 100
var health = maxHealth
const maxStamina = 3.0
var currentStamina = maxStamina

var damage = 0
var mercy = 0
var mercyMax = 30

var speed = 1100.0
var moveSpeed = 0
var dashSpeed = 0
var addSpeed = 0

var gravity = 3700
var direction = 1.0
var walkDirection = 0.0
var tempDirection = 0.0

var isJumping = false
var jumpPower = -1600.0
var wallJumps = 0
var jumpCount = 2

var dashTimer = 0
var dashState = false

var isSliding = false
var stompState = false
const stompMax = 12

var s = 0
var sMax = 2
var maxAmmo = [1, 6, 1]
var currentAmmo = [100, 100, 100]
var maxClip = [4, 12, 100]
var currentClip = [100, 100, 100]
var reloadState = [false, false, false]
var reload = [0, 0, 0]
const reloadTime = [90, 160, 0]
var fireCD = [100, 100, 100]
var fireRate = [90, 35, 60]

var mousePos = get_global_mouse_position()

@onready var gameui = $GameUI
@onready var camera = $Camera
@onready var weapon = $Weapon
@onready var sprite = $AnimatedSprite2D
@onready var audio = $Audio


var projPath = load("res://scenes/playerStuff/projectile.tscn")
var meleePath = load("res://scenes/playerStuff/melee.tscn")

func _ready():
	for a in 3:
		if currentAmmo[a] >= maxAmmo[a]:
			currentAmmo[a] = maxAmmo[a]
		if currentClip[a] >= maxClip[a]:
			currentClip[a] = maxClip[a]


func _physics_process(delta: float)->void :
	mousePos = get_global_mouse_position()
	resourceManagement()

	if not dashState and not isSliding:
		facingDirection()
	handleControls()
	weaponPassive()
	airCheck()
	applyGravity(delta)

	if not isSliding:
		staminaRegen()
	healthStuff()

	move_and_slide()

func handleControls():
	handleMove()
	handleJump()
	if Input.is_action_just_pressed("fire"):
		weaponFire()
	weaponSwitch()

func facingDirection():
	if Input.is_action_pressed("left"):
		direction = -1.0
		walkDirection = -1.0
		sprite.flip_h = true
	else: if Input.is_action_pressed("right"):
		direction = 1.0
		walkDirection = 1.0
		sprite.flip_h = false
	else:
		walkDirection = 0.0
		sprite.play("idle")

func airCheck():
	if is_on_floor():
		wallJumps = 0
		stompState = false

	if velocity.y > 0:
		isJumping = true
	else: if velocity.y <= 0:
		isJumping = false

func applyGravity(delta):
	if not is_on_floor() and stompState == false:
		sprite.play("jump")
		velocity.y += gravity * delta

	if is_on_wall() and isJumping:
		velocity.y = gravity * 3 * delta
		if walkDirection == 0:
			velocity.x = 0
	if is_on_wall() and not is_on_floor():
		audio.playWall()
		if velocity.x >= 400 and - velocity.x >= -400:
			velocity.x = 0
	else:
		audio.stopWall()

func handleJump():
	if Input.is_action_just_pressed("jump") and dashState == false:
		if is_on_floor():
			velocity.y = jumpPower
		else: if is_on_wall():
			if moveSpeed <= speed:
				moveSpeed = direction * speed
			else:
				moveSpeed = direction * moveSpeed

			if wallJumps < jumpCount:
				velocity.y = jumpPower / 1.15
			wallJumps += 1
		stompState = false

	if Input.is_action_just_pressed("crouch") and not is_on_floor():
		stompState = true
	if stompState == true:
		velocity.x = 0
		if walkDirection == 0:
			moveSpeed = 0
		velocity.y = gravity / 1.3

func handleMove():
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		moveSpeed += walkDirection * speed / 12
		if moveSpeed >= speed or moveSpeed <= - speed:
			moveSpeed = direction * speed
		if is_on_floor():
			sprite.play("run")
	else: if is_on_floor():
		moveSpeed -= direction * speed / 18
		if direction * moveSpeed <= -25 and direction * - moveSpeed >= 25:
			moveSpeed = 0

	if Input.is_action_just_pressed("dash") and dashState == false and currentStamina >= 1:
		audio.playDash()
		dashState = true
		stompState = false
		currentStamina -= 1
	if dashState == true:
		dashSpeed = direction * speed * 1.8
		velocity.y = 0
		dashTimer += 1
		set_collision_layer_value(3, false)
		if dashTimer > 6:
			dashTimer = 0
			dashSpeed = 0
			if moveSpeed <= speed:
				moveSpeed = direction * speed
			dashState = false
			set_collision_layer_value(3, true)

	if Input.is_action_pressed("crouch") and is_on_floor():
		if not isSliding:
			tempDirection = 1.3
			isSliding = true
		isSliding = true
		moveSpeed = direction * speed * tempDirection
		tempDirection -= 0.025
		if tempDirection <= 0.8:
			tempDirection = 0.8
	else:
		isSliding = false

	if dashState == false:
		velocity.x = moveSpeed + dashSpeed + addSpeed
	else:
		velocity.x = dashSpeed


func staminaRegen():
	currentStamina += 0.0085
	if currentStamina >= maxStamina:
		currentStamina = maxStamina

func weaponFire():
	if fireCD[s] >= fireRate[s]:
		var bullet = projPath.instantiate()
		get_parent().add_child.call_deferred(bullet)
		bullet.slot = s+1;
		bullet.dir = weapon.rotation
		bullet.spawnPos = weapon.global_position
		bullet.spawnRot = weapon.rotation
		audio.playShoot(s)
		if s == 2:
			var melee = meleePath.instantiate()
			get_parent().add_child(melee)
			melee.slot = 1
			melee.position = global_position + ((get_global_mouse_position() - global_position).normalized() * 65)
			currentAmmo[2] += 1
		fireCD[s] = 0
		currentAmmo[s] -= 1

func weaponSwitch():
	if Input.is_action_just_pressed("primarySlot"):
		s = 0
	else: if Input.is_action_just_pressed("secondarySlot"):
		s = 1
	else: if Input.is_action_just_pressed("tertiarySlot"):
		s = 2
		
func weaponPassive():
	if fireCD[s] < fireRate[s]:
		fireCD[s] += 1

func _on_area_2d_body_entered(body: Node2D)->void :
	if body.is_in_group("enemies"):
		print("Hit by Enemy " + body.get_name())
		var enemy = get_node(body.get_path())
		takeDamage(enemy.damage)

func takeDamage(dmgTaken):
	if dashState == false and mercy >= 30:
		health -= dmgTaken
		print(str(dmgTaken) + " damage dealt")
		print("Health: " + str(health) + "/" + str(maxHealth))
		damage = dmgTaken
		if damage != 0:
			gameui.healthTimerReset()

func healUp(healing):
	health += healing

func resourceManagement():
	if health >= maxHealth:
		health = maxHealth

	for child in get_parent().get_children():
		if child.has_method("getPlayerPosition"):
			child.getPlayerPosition(global_position)

		if child.has_method("getPlayerDirection"):
			child.getPlayerDirection(direction)

	gameui.playerHP = health
	gameui.maxHP = maxHealth
	gameui.damage = damage
	gameui.stamina = currentStamina
	gameui.slot = s
	gameui.ammo = currentAmmo[s]
	gameui.maxAmmo = maxAmmo[s]
	gameui.fireCD = fireCD[s]
	gameui.fireRate = fireRate[s]
	
	$Cursor.position = get_local_mouse_position()

func healthStuff():
	mercy += 1
	if damage >= 40:
		mercyMax = 50
	else:
		mercyMax = 30
	if health <= 0 or Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
