extends CharacterBody2D

var timer = 0
var timerMax = 30
var speed = 850
var damage = 20
var enemy = 1

var playerPos

func _physics_process(delta: float)->void :
    if enemy == 1:
        speed = 1000
        damage = 20
        timerMax = 100

    if timer == 0:
        rotate(get_angle_to(playerPos))
        var direction = (playerPos - position).normalized()
        velocity = direction * speed

    move_and_slide()
    if timer >= timerMax or get_slide_collision_count() != 0:
        queue_free()
    timer += 1

func getPlayerPosition(pos):
    playerPos = pos

func _on_area_2d_body_entered(body: Node2D)->void :
    if body.is_in_group("player"):
        var play = get_node(body.get_path())
        queue_free()
        play.takeDamage(damage)
