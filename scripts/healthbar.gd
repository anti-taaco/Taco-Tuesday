extends ProgressBar

@onready var damagebar = $DamageBar
@onready var gameui = $".."

var timer = 0
var playerHP = 0
var damage = 0

func _ready()->void :
    value = gameui.playerHP

func _process(delta: float)->void :
    playerHP = gameui.playerHP
    if gameui.damage != 0:
        damage = gameui.damage
    max_value = gameui.maxHP
    damagebar.max_value = gameui.maxHP

    if value != playerHP:
        value -= damage * 0.2
    if value <= playerHP:
        value = playerHP


    if timer >= 21:
        if damagebar.value <= playerHP:
            damagebar.value = playerHP
            timer = 0
        else:
            damagebar.value -= damage * 0.3
    else: if damagebar.value != playerHP or timer >= 1:
        timer += 1
