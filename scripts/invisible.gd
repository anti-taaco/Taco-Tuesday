extends CharacterBody2D

var speed = 100

@onready var player = $".."

func _physics_process(delta: float)->void :
    var playerPos = player.global_position
    move_and_slide()
